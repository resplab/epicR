Rcpp::sourceCpp("./src/model.WIP.cpp")

# Cleaning up when package unloads
.onUnload <- function(libpath) {
  library.dynam.unload("epicR", libpath)
}


default_settings <- list(record_mode = record_mode["record_mode_event"],
                         events_to_record = c(0),
                         agent_creation_mode = agent_creation_mode["agent_creation_mode_one"],
                         update_continuous_outcomes_mode = 0,
                         n_base_agents = 1e+04,
                         runif_buffer_size = 1e+06,
                         rnorm_buffer_size = 1e+06,
                         rexp_buffer_size = 1e+06,
                         agent_stack_size = 0,
                         event_stack_size = 5e+05 * 1.7 * 30)


#' @export
init_session <- function(settings = default_settings) {
  cat("Initializing the session\n")
  if (exists("Cdeallocate_resources"))
    Cdeallocate_resources()
  if (!is.null(settings))
    apply_settings(settings)
  init_input()
  return(Callocate_resources())
}


#' @export
terminate_session <- function() {
  cat("Terminating the session\n")
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



update_run_env_setting <- function(setting_var, value) {
  res <- Cset_settings_var(setting_var, value)
  if (res < 0)
    return(res)
  settings[setting_var] <<- value
  return(0)
}





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
      return(res)
    }
  }

  return(0)
}

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



#' @export
get_agent_events <- function(id) {
  x <- Cget_agent_events(id)
  data <- data.frame(matrix(unlist(x), nrow = length(x), byrow = T))
  names(data) <- names(x[[1]])
  return(data)
}


#' @export
get_events_by_type <- function(event_type) {
  x <- Cget_events_by_type(event_type)
  data <- data.frame(matrix(unlist(x), nrow = length(x), byrow = T))
  names(data) <- names(x[[1]])
  return(data)
}

#' @export
get_all_events <- function() {
  x <- Cget_all_events()
  data <- data.frame(matrix(unlist(x), nrow = length(x), byrow = T))
  names(data) <- names(x[[1]])
  return(data)
}




#' @export
run <- function(max_n_agents = NULL, input = NULL) {
  Cinit_session()
  if (is.null(input))
    input <- model_input$values

  res <- set_Cmodel_inputs(process_input(input))
  if (res == 0) {
    if (is.null(max_n_agents))
      max_n_agents = .Machine$integer.max
    res <- Cmodel(max_n_agents)
  }
  if (res < 0) {
    cat("ERROR:", names(which(errors == res)), "\n")
  }
  return(res)
}




#' @export
resume <- function(max_n_agents = NULL) {
  if (is.null(max_n_agents))
    max_n_agents = settings$n_base_agents
  res <- Cmodel(max_n_agents)
  if (res < 0) {
    cat("ERROR:", names(which(errors == res)), "\n")
  }
  return(res)
}




# processes input and returns the processed one
process_input <- function(ls, decision = 1) {
  ls$agent$p_bgd_by_sex <- ls$agent$p_bgd_by_sex + ls$manual$explicit_mortality_by_age_sex
  ls$agent$p_bgd_by_sex <- ls$agent$p_bgd_by_sex

  ls$smoking$ln_h_inc_betas[1] <- ls$smoking$ln_h_inc_betas[1] + log(ls$manual$smoking$intercept_k)

  ls$manual <- NULL
  return(ls)
}



