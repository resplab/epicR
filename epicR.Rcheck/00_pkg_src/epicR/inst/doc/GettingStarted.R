## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE  # Set to FALSE to prevent long simulations during package check
)

## ----installation, eval=FALSE-------------------------------------------------
# # Install from GitHub
# pak::pkg_install("resplab/epicR")

## ----setup--------------------------------------------------------------------
# library(epicR)

## ----simple-simulate, eval=FALSE----------------------------------------------
# # Run with defaults - that's it!
# results <- simulate()
# 
# # Access basic results
# print(results$basic)
# 
# # Custom parameters
# results <- simulate(
#   jurisdiction = "us",
#   time_horizon = 10,
#   n_agents = 100000
# )
# 
# # Quick test with fewer agents (faster for testing)
# results <- simulate(n_agents = 10000)
# 
# # Get extended results (includes both basic and extended)
# results <- simulate(return_extended = TRUE)
# print(results$extended)
# 
# # Get event history (automatically sets record_mode)
# results <- simulate(return_events = TRUE)
# head(results$events)

## ----initialize, eval=FALSE---------------------------------------------------
# # Initialize with default settings
# init_session()

## ----run, eval=FALSE----------------------------------------------------------
# # Run with default inputs
# run()

## ----output, eval=FALSE-------------------------------------------------------
# results <- Cget_output()
# print(results)

## ----terminate, eval=FALSE----------------------------------------------------
# terminate_session()

## ----terminate-manual---------------------------------------------------------
# terminate_session()

## ----jurisdiction-------------------------------------------------------------
# # For Canadian population (default)
# input_canada <- get_input(jurisdiction = "ca")
# 
# # For US population
# input_us <- get_input(jurisdiction = "us")

## ----explore_inputs-----------------------------------------------------------
# inputs <- get_input()
# 
# # Top-level structure
# names(inputs)
# # [1] "values" "help" "references"
# 
# # Value categories
# names(inputs$values)
# 
# # Example: global parameters
# names(inputs$values$global_parameters)
# inputs$values$global_parameters$time_horizon  # Simulation duration in years

## ----modify_inputs------------------------------------------------------------
# input <- get_input()
# 
# # Change time horizon (years)
# input$values$global_parameters$time_horizon <- 20
# 
# # Modify COPD-related costs
# input$values$cost$exac_dcost  # Exacerbation costs by severity
# 
# # Run with modified inputs
# init_session()
# run(input = input$values)
# results <- Cget_output()
# terminate_session()

## ----settings-----------------------------------------------------------------
# settings <- get_default_settings()
# names(settings)

## ----n_agents-----------------------------------------------------------------
# settings <- get_default_settings()
# 
# # Quick test run
# settings$n_base_agents <- 1e4  # 10,000 agents
# 
# # Production run
# settings$n_base_agents <- 1e6  # 1,000,000 agents
# 
# # Check memory requirements before running large simulations
# estimate_memory_required(n_agents = 1e6, record_mode = 0, time_horizon = 20)

## ----extended_output----------------------------------------------------------
# init_session()
# run()
# 
# # Detailed output tables
# results_ex <- Cget_output_ex()
# names(results_ex)
# 
# terminate_session()

## ----individual_data----------------------------------------------------------
# settings <- get_default_settings()
# settings$record_mode <- 2
# settings$n_base_agents <- 1e4  # Keep small due to memory requirements
# 
# init_session(settings = settings)
# 
# input <- get_input()
# input$values$global_parameters$time_horizon <- 5
# run(input = input$values)
# 
# # Get all events as a data frame
# events <- as.data.frame(Cget_all_events_matrix())
# head(events)
# 
# terminate_session()

## ----closed_cohort------------------------------------------------------------
# # Get inputs configured for closed cohort
# input <- get_input(closed_cohort = 1)
# 
# init_session()
# run(input = input$values)
# results <- Cget_output()
# terminate_session()

## ----scenarios----------------------------------------------------------------
# # Baseline scenario
# init_session()
# input_baseline <- get_input()
# run(input = input_baseline$values)
# results_baseline <- Cget_output()
# terminate_session()
# 
# # Intervention scenario (e.g., improved case detection)
# init_session()
# input_intervention <- get_input()
# # Modify relevant parameters for your intervention
# # input_intervention$values$diagnosis$... <- new_value
# run(input = input_intervention$values)
# results_intervention <- Cget_output()
# terminate_session()
# 
# # Compare outcomes
# # cost_difference <- results_intervention$total_cost - results_baseline$total_cost
# # qaly_difference <- results_intervention$total_qaly - results_baseline$total_qaly
# # icer <- cost_difference / qaly_difference

## ----error_handling-----------------------------------------------------------
# tryCatch({
#   init_session()
#   run()
#   results <- Cget_output()
# }, finally = {
#   terminate_session()
# })

