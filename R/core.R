session_env<-new.env()
session_env$global_error_code_chain<-NULL
session_env$global_error_message_chain<-NULL
session_env$initialized <- FALSE
session_env$config_file_path <- NULL
session_env$config_file_mtime <- NULL


session_env$record_mode<-c(
  record_mode_none=0,
  record_mode_agent=1,
  record_mode_event=2,
  record_mode_some_event=3
)


session_env$agent_creation_mode<-c(
  agent_creation_mode_one=0,
  agent_creation_mode_all=1,
  agent_creation_mode_pre=2
)

# Cleaning up when package unloads
.onUnload <- function(libpath) {
  library.dynam.unload("epicR", libpath)
}







# Events per agent per year (empirically determined from model runs)
.events_per_agent_per_year <- 1.7

#' Get size of agent struct in bytes (from C code)
#' @return size in bytes
#' @export
get_agent_size_bytes <- function() {
  tryCatch(
    Cget_agent_size_bytes(),
    error = function(e) 800  # Fallback estimate if C function not available
  )
}

default_settings <- list(record_mode = session_env$record_mode["record_mode_none"],
                         events_to_record = c(0),
                         agent_creation_mode = session_env$agent_creation_mode["agent_creation_mode_one"],
                         update_continuous_outcomes_mode = 0,
                         random_number_agent_refill=0,
                         n_base_agents = 6e4,
                         runif_buffer_size = 5e4,
                         rnorm_buffer_size = 5e4,
                         rexp_buffer_size = 5e4,
                         rgamma_buffer_size = 5e4,
                         agent_stack_size = 0,
                         event_stack_size = NULL)  # NULL means auto-calculate

#' Exports default settings
#' @return default settings
#' @export
get_default_settings<-function()
{
  return(default_settings)
}

#' Calculate recommended event_stack_size for a given number of agents
#' @param n_agents number of agents to simulate
#' @param time_horizon simulation time horizon in years (default 20)
#' @return recommended event_stack_size
#' @export
calc_event_stack_size <- function(n_agents, time_horizon = 20) {
  events_per_agent <- .events_per_agent_per_year * time_horizon
  return(ceiling(n_agents * events_per_agent))
}

#' Estimate memory required for simulation
#' @param n_agents number of agents
#' @param record_mode recording mode (0=none, 1=agent, 2=event, 3=some_event)
#' @param time_horizon simulation time horizon in years
#' @return estimated memory in bytes
#' @export
estimate_memory_required <- function(n_agents, record_mode = 0, time_horizon = 20) {
  agent_size <- get_agent_size_bytes()

  # Random number buffers (5 buffers * 50000 * 8 bytes)
  buffer_mem <- 5 * 5e4 * 8

  # Agent stack (usually 0)
  agent_mem <- 0

  # Event stack (only when recording)
  if (record_mode != 0) {
    event_stack_size <- calc_event_stack_size(n_agents, time_horizon)
    event_mem <- event_stack_size * agent_size
  } else {
    event_mem <- 0
  }

  return(buffer_mem + agent_mem + event_mem)
}

#' Get available system memory (platform-specific)
#' @return available memory in bytes
#' @export
get_available_memory <- function() {
  tryCatch({
    os <- Sys.info()["sysname"]

    if (os == "Linux") {
      # Linux: read from /proc/meminfo
      if (file.exists("/proc/meminfo")) {
        meminfo <- readLines("/proc/meminfo", n = 10)
        # Prefer MemAvailable (accounts for caches), fallback to MemFree
        avail_line <- grep("^MemAvailable:", meminfo, value = TRUE)
        if (length(avail_line) == 0) {
          avail_line <- grep("^MemFree:", meminfo, value = TRUE)
        }
        if (length(avail_line) > 0) {
          mem_kb <- as.numeric(gsub("[^0-9]", "", avail_line[1]))
          return(mem_kb * 1024)  # Convert KB to bytes
        }
      }
    } else if (os == "Darwin") {
      # macOS: use vm_stat
      vm_stat <- system("vm_stat", intern = TRUE)
      # Parse page size (usually 4096 bytes)
      page_size <- 4096
      page_line <- grep("page size", vm_stat, value = TRUE)
      if (length(page_line) > 0) {
        page_size <- as.numeric(gsub("[^0-9]", "", page_line))
      }
      # Get free + inactive pages (available for use)
      free_line <- grep("Pages free:", vm_stat, value = TRUE)
      inactive_line <- grep("Pages inactive:", vm_stat, value = TRUE)
      free_pages <- if (length(free_line) > 0) as.numeric(gsub("[^0-9]", "", free_line)) else 0
      inactive_pages <- if (length(inactive_line) > 0) as.numeric(gsub("[^0-9]", "", inactive_line)) else 0
      return((free_pages + inactive_pages) * page_size)
    } else if (os == "Windows") {
      # Windows: use wmic command
      wmic_output <- system("wmic OS get FreePhysicalMemory /value", intern = TRUE)
      mem_line <- grep("FreePhysicalMemory", wmic_output, value = TRUE)
      if (length(mem_line) > 0) {
        mem_kb <- as.numeric(gsub("[^0-9]", "", mem_line))
        return(mem_kb * 1024)  # Convert KB to bytes
      }
    }

    # Fallback: assume 4GB available
    return(4e9)
  }, error = function(e) {
    # If anything fails, assume 4GB available
    return(4e9)
  })
}



# Population of Canada over 40 years by StatsCan 18,415.60

#' Initializes a model. Allocates memory to the C engine.
#' @param settings customized settings.
#' @return 0 if successful.
#' @export
init_session <- function(settings = get_default_settings()) {
  message("Initializing the session")
  message("Working directory: ", getwd())
  if (exists("Cdeallocate_resources"))
    Cdeallocate_resources()

  # Get time_horizon from input parameters for memory calculation
  input_params <- get_input()
  time_horizon <- input_params$values$global_parameters$time_horizon
  if (is.null(time_horizon)) time_horizon <- 20  # default

  # Auto-calculate event_stack_size if not specified (NULL)
  if (is.null(settings$event_stack_size)) {
    if (settings$record_mode == 0) {
      # No recording needed, minimal allocation
      settings$event_stack_size <- 0
    } else {
      # Calculate based on n_base_agents and time_horizon
      settings$event_stack_size <- calc_event_stack_size(settings$n_base_agents, time_horizon)
    }
  }

  # Check available memory before attempting allocation
  required_mem <- estimate_memory_required(settings$n_base_agents, settings$record_mode, time_horizon)
  available_mem <- get_available_memory()

  if (required_mem > available_mem * 0.8) {  # Leave 20% headroom
    required_gb <- required_mem / 1e9
    available_gb <- available_mem / 1e9
    stop(sprintf(
      "Insufficient memory for simulation. Required: %.1f GB, Available: %.1f GB. ",
      required_gb, available_gb),
      "Try reducing n_base_agents or use record_mode_none (record_mode=0) if you don't need to record events.",
      call. = FALSE)
  }

  if (!is.null(settings))
    apply_settings(settings)
  Cinit_session()

  # Allocate memory and check for errors
  alloc_result <- Callocate_resources()
  if (alloc_result != 0) {
    session_env$initialized <- FALSE
    current_settings <- Cget_settings()
    est_memory_gb <- estimate_memory_required(current_settings$n_base_agents,
                                               current_settings$record_mode, time_horizon) / 1e9
    stop(sprintf(
      "Memory allocation failed (error code: %d). Estimated memory required: %.1f GB. ",
      alloc_result, est_memory_gb),
      "Try reducing n_base_agents or use record_mode_none if you don't need to record events.",
      call. = FALSE)
  }

  session_env$initialized <- TRUE
  return(alloc_result)
}

#' Terminates a session and releases allocated memory.
#' @return 0 if successful.
#' @export
terminate_session <- function() {
  message("Terminating the session")
  session_env$initialized <- FALSE
  return(Cdeallocate_resources())
}


apply_settings <- function(settings = settings) {
  res <- 0
  ls <- Cget_settings()
  for (i in 1:length(ls)) {
    nm <- names(ls)[i]
    # message(nm)
    if (!is.null(settings[nm])) {
      res <- Cset_settings_var(nm, settings[[nm]])
      if (res != 0)
        return(res)
    }
  }
  return(res)
}




#' Get list elements
#' @param ls ls
#' @param running_name running_name
#' @export
get_list_elements <- function(ls, running_name = "") {
  out <- NULL
  if (length(ls) > 0) {
    for (i in 1:length(ls)) {
      if (typeof(ls[[i]]) == "list") {
        out <- c(out, paste(names(ls)[i], "$", get_list_elements(ls[[i]]), sep = ""))
      } else {
        out <- c(out, names(ls)[i])
      }
    }
  }
  return(out)
}


set_Cmodel_inputs <- function(ls) {
  if(length(ls)==0) return(0)
  nms <- get_list_elements(ls)
  for (i in 1:length(nms)) {
    last_var <- nms[i]
    # message(nms[i])
    val <- eval(parse(text = paste("ls$", nms[i])))
    # important: CPP is column major order but R is row major; all matrices should be tranposed before vectorization;
    if (is.matrix(val))
      val <- as.vector(t(val))
    res <- Cset_input_var(nms[i], val)
    if (res != 0) {
      message(last_var)
      set_error(res,paste("Invalid input:",last_var))
      return(res)
    }
  }

  return(0)
}

#' Express matrix.
#' @param mtx a matrix
#' @export
express_matrix <- function(mtx) {
  nr <- dim(mtx)[1]
  nc <- dim(mtx)[2]
  rnames <- rownames(mtx)
  cnames <- colnames(mtx)

  for (i in 1:nc) {
    cat(cnames[i], "=c(")
    for (j in 1:nr) {
      if (!is.null(rnames))
        cat(rnames[j], "=", mtx[j, i]) else cat(mtx[j, i])
      if (j < nr)
        cat(",")
    }
    cat(")\n")
    if (i < nc)
      cat(",")
  }
}  #Takes a named matrix and write the R code to populate it; good for generating input expressions from calibration results



#' Returns events specific to an agent.
#' @param id Agent number
#' @return dataframe consisting all events specific to agent \code{id}
#' @export
get_agent_events <- function(id) {
  x <- Cget_agent_events(id)
  data <- data.frame(matrix(unlist(x), nrow = length(x), byrow = T))
  names(data) <- names(x[[1]])
  return(data)
}

#' Returns certain events by type
#' @param event_type event_type number
#' @return dataframe consisting all events of the type \code{event_type}
#' @export
get_events_by_type <- function(event_type) {
  x <- Cget_events_by_type(event_type)
  data <- data.frame(matrix(unlist(x), nrow = length(x), byrow = T))
  names(data) <- names(x[[1]])
  return(data)
}

#' Returns all events.
#' @return dataframe consisting all events.
#' @export
get_all_events <- function() {
  x <- Cget_all_events()
  data <- data.frame(matrix(unlist(x), nrow = length(x), byrow = T))
  names(data) <- names(x[[1]])
  return(data)
}



#' Runs the model. Auto-initializes if no session is active.
#' @param max_n_agents maximum number of agents
#' @param input customized input criteria
#' @param settings customized settings (only used if auto-initializing)
#' @param auto_terminate whether to automatically terminate session after run (default: FALSE)
#' @param seed Random seed for reproducibility (optional). If provided, ensures identical results across runs
#' @return simulation results if successful
#' @export
#' @examples
#' \dontrun{
#' # Simple usage - everything handled automatically
#' results <- run()
#'
#' # Or with custom input
#' input <- get_input(jurisdiction = "us", time_horizon = 10)
#' results <- run(input = input$values)
#'
#' # Advanced: manual session management for multiple runs
#' init_session()
#' run()
#' run()  # run again with same session
#' terminate_session()
#'
#' # With reproducible results
#' run(seed = 123)
#' }
run <- function(max_n_agents = NULL, input = NULL, settings = NULL, auto_terminate = FALSE, seed = NULL) {

  # Set random seed for reproducibility if provided
  if (!is.null(seed)) {
    set.seed(seed)
    message("Random seed set to: ", seed)
  }

  # Auto-initialize if not already initialized
  auto_initialized <- FALSE
  if (!(session_env$initialized)) {
    message("No active session - initializing automatically")
    if (is.null(settings)) {
      settings <- get_default_settings()
    }
    init_session(settings = settings)
    auto_initialized <- TRUE
  }
  reset_errors()


  # Get default input (always needed)
  default_input_full <- get_input()

  # Display jurisdiction information
  jurisdiction <- "canada"  # default fallback
  if (!is.null(default_input_full$config$jurisdiction)) {
    jurisdiction <- default_input_full$config$jurisdiction
  }

  # Show appropriate message based on whether custom input is provided
  if (!is.null(input) && length(input) > 0) {
    message("Running EPIC model (with custom input parameters)")
  } else {
    message("Running EPIC model for jurisdiction: ", toupper(jurisdiction))
  }

  # Display record_mode information
  current_settings <- Cget_settings()
  record_mode_value <- current_settings$record_mode
  record_mode_names <- c("record_mode_none", "record_mode_agent", "record_mode_event", "record_mode_some_event")
  record_mode_name <- record_mode_names[record_mode_value + 1]
  message("Record mode: ", record_mode_name, " (", record_mode_value, ")")
  if (record_mode_value == 0) {
    message("Note: No events will be recorded. Use record_mode_event (2) or record_mode_agent (1) to record events.")
  }

  default_input <- default_input_full$values
  res<-set_Cmodel_inputs(process_input(default_input))

  if (!is.null(input) || length(input)==0)
  {
    res<-set_Cmodel_inputs(process_input(input))
    if(res<0)
    {
      set_error(res,"Bad Input")
    }
  }

  if (res == 0) {
    if (is.null(max_n_agents))
      max_n_agents = .Machine$integer.max
    res <- Cmodel(max_n_agents)
  }
  if (res < 0) {
    message("ERROR:", names(which(errors == res)))
    if (auto_terminate) {
      terminate_session()
    }
    stop("Simulation failed")
  }

  # Auto-terminate only if explicitly requested
  # Don't auto-terminate just because we auto-initialized
  # (simulate() needs the session to stay open to get results)
  if (auto_terminate) {
    terminate_session()
  }

  return(res)

}




#' Convenience function: run simulation and return results
#'
#' This is a simplified interface that handles session management automatically
#' and returns the results directly. Ideal for most users. Progress information
#' is displayed including: configuration summary, a real-time progress bar showing
#' percentage completion (10%, 20%, ... 100%), elapsed time, and data collection status.
#'
#' @param input customized input criteria (optional)
#' @param settings customized settings (optional)
#' @param jurisdiction Jurisdiction for model parameters ("canada" or "us")
#' @param time_horizon Model time horizon in years (default: 20)
#' @param n_agents Number of agents to simulate (default: 60,000)
#' @param extended_results whether to return extended results in addition to basic (default: TRUE)
#' @param return_events whether to return event matrix (default: FALSE). If TRUE, automatically sets record_mode=2
#' @param seed Random seed for reproducibility (optional). If provided, ensures identical results across runs
#' @return list with simulation results (always includes 'basic', includes 'extended' by default, optionally 'events')
#' @export
#' @examples
#' \dontrun{
#' # Simplest usage - includes both basic and extended results
#' results <- simulate()
#' print(results$basic)
#' print(results$extended)
#'
#' # With custom parameters
#' results <- simulate(jurisdiction = "us", time_horizon = 10, n_agents = 100000)
#'
#' # Quick test with fewer agents
#' results <- simulate(n_agents = 10000)
#'
#' # Basic output only (faster, less memory)
#' results <- simulate(extended_results = FALSE)
#' print(results$basic)
#'
#' # With event history
#' results <- simulate(return_events = TRUE)
#' print(results$events)  # Event matrix
#'
#' # With reproducible results
#' results1 <- simulate(seed = 123)
#' results2 <- simulate(seed = 123)
#' # results1 and results2 will be identical
#' }
simulate <- function(input = NULL, settings = NULL, jurisdiction = "canada",
                     time_horizon = 20, n_agents = NULL,
                     extended_results = TRUE, return_events = FALSE,
                     seed = NULL) {

  # Check if config file has been modified since last load
  config_changed <- FALSE
  if (!is.null(session_env$config_file_path) &&
        !is.null(session_env$config_file_mtime) &&
        file.exists(session_env$config_file_path)) {
    current_mtime <- file.info(session_env$config_file_path)$mtime
    if (current_mtime != session_env$config_file_mtime) {
      config_changed <- TRUE
      message(
        ">>> Config file has been modified - reloading automatically <<<"
      )
    }
  }

  # If no custom input provided, use get_input with specified parameters
  # Also reload if config file has changed
  if (is.null(input) || config_changed) {
    input_full <- get_input(jurisdiction = jurisdiction,
                            time_horizon = time_horizon)
    input <- input_full$values

    # If config changed, let user know which file was reloaded
    if (config_changed && !is.null(session_env$config_file_path)) {
      message(
        ">>> Reloaded config from: ", session_env$config_file_path, " <<<"
      )
    }
  }

  # Get or create settings
  if (is.null(settings)) {
    settings <- get_default_settings()
  }

  # Override n_base_agents if specified
  if (!is.null(n_agents)) {
    settings$n_base_agents <- n_agents
  }

  # If return_events is TRUE, automatically set record_mode
  if (return_events) {
    # Set record_mode to record_mode_event (2) to capture all events
    settings$record_mode <- 2

    # Calculate appropriate event_stack_size if not already set
    if (is.null(settings$event_stack_size) || settings$event_stack_size == 0) {
      settings$event_stack_size <- calc_event_stack_size(settings$n_base_agents, time_horizon)
    }
  }

  # Set random seed for reproducibility if provided
  if (!is.null(seed)) {
    set.seed(seed)
    message("Random seed set to: ", seed)
  }

  # Display configuration summary
  message("=== EPIC Simulation Configuration ===")
  message("Jurisdiction: ", toupper(jurisdiction))
  message("Time horizon: ", time_horizon, " years")
  message("Number of agents: ", format(settings$n_base_agents, scientific = FALSE, big.mark = ","))

  if (return_events || settings$record_mode > 0) {
    message("Event recording: ENABLED (record_mode = ", settings$record_mode, ")")
    if (!is.null(settings$event_stack_size) && settings$event_stack_size > 0) {
      # Calculate memory requirement and show in human-readable format
      agent_size_bytes <- get_agent_size_bytes()
      memory_bytes <- settings$event_stack_size * agent_size_bytes
      memory_gb <- memory_bytes / 1e9

      if (memory_gb >= 1) {
        memory_str <- sprintf("%.2f GB", memory_gb)
      } else {
        memory_mb <- memory_bytes / 1e6
        memory_str <- sprintf("%.1f MB", memory_mb)
      }

      message("Estimated memory for events: ", memory_str)
    }
  } else {
    message("Event recording: DISABLED")
  }
  message("=====================================")

  # Run WITHOUT auto-termination (we need to get results first)
  # Use tryCatch to ensure we terminate session even if errors occur
  tryCatch({
    # Track simulation time and show progress
    message("\nStarting simulation...")
    start_time <- Sys.time()

    run(input = input, settings = settings, auto_terminate = FALSE)

    # Calculate and display elapsed time
    end_time <- Sys.time()
    elapsed <- as.numeric(difftime(end_time, start_time, units = "secs"))

    if (elapsed < 60) {
      time_msg <- sprintf("%.1f seconds", elapsed)
    } else if (elapsed < 3600) {
      time_msg <- sprintf("%.1f minutes", elapsed / 60)
    } else {
      time_msg <- sprintf("%.1f hours", elapsed / 3600)
    }

    message("Simulation completed in ", time_msg)
    message("Collecting results...")

    # Get all results BEFORE terminating session
    results <- list(
      basic = Cget_output()
    )

    # Add extended results if requested (in addition to basic)
    if (extended_results) {
      message("Collecting extended results...")
      results$extended <- Cget_output_ex()
    }

    # Add events if requested
    if (return_events) {
      message("Collecting event history...")
      results$events <- as.data.frame(Cget_all_events_matrix())
    }

    # Now terminate the session
    terminate_session()

    message("Done!\n")

    return(results)

  }, error = function(e) {
    # Ensure we terminate session even on error
    if (session_env$initialized) {
      terminate_session()
    }
    stop("Simulation failed: ", e$message)
  })
}


#' Resumes running of model.
#' @param max_n_agents maximum number of agents
#' @return 0 if successful.
#' @export
resume <- function(max_n_agents = NULL) {
  if (is.null(max_n_agents))
    max_n_agents = settings$n_base_agents
  res <- Cmodel(max_n_agents)
  if (res < 0) {
    message("ERROR:", names(which(errors == res)))
  }
  return(res)
}




# processes input and returns the processed one
process_input <- function(ls, decision = 1)
{
  if(!is.null(ls$manual))
  {
    ls$agent$p_bgd_by_sex <- ls$agent$p_bgd_by_sex - ls$manual$explicit_mortality_by_age_sex
    ls$agent$p_bgd_by_sex <- ls$agent$p_bgd_by_sex


    ls$smoking$ln_h_inc_betas[1] <- ls$smoking$ln_h_inc_betas[1] + log(ls$manual$smoking$intercept_k)

    ls$manual <- NULL
  }
  return(ls)
}




reset_errors<-function()
{
  session_env$global_error_code_chain<-NULL
  session_env$global_error_message_chain<-NULL
}



set_error <- function(error_code, error_message="")
{
  session_env$global_error_code_chain<-c(session_env$global_error_code_chain,error_code)
  session_env$global_error_message_chain<-c(session_env$global_error_message_chain,error_message)
}


#' Returns errors
#' @return a text with description of error messages
#' @export
get_errors <- function()
{
  return(cbind(session_env$global_error_code_chain,session_env$global_error_message_chain))
}

