## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE  # Set to FALSE to prevent long simulations during package check
)

## ----setup--------------------------------------------------------------------
# library(epicR)

## ----initialize---------------------------------------------------------------
# init_session()
# run()

## ----basicOutput--------------------------------------------------------------
# results <- Cget_output()
# 

## -----------------------------------------------------------------------------
# results_ex<-Cget_output_ex()
# names(results_ex)
# terminate_session()

## -----------------------------------------------------------------------------
# inputs <- get_input()
# names(inputs)
# names(inputs$values)
# names(inputs$values$global_parameters)
# inputs$values$global_parameters$time_horizon
# 

## -----------------------------------------------------------------------------
# settings <- get_default_settings()
# settings$record_mode <- 2
# settings$n_base_agents <- 1e4
# init_session(settings = settings)
# 
# input <- get_input()
# input$values$global_parameters$time_horizon <- 5
# run(input=input$values)
# 
# results <- Cget_output()
# events <- as.data.frame(Cget_all_events_matrix())
# head(events)
# terminate_session()

## -----------------------------------------------------------------------------
# library(epicR)
# input <- get_input(closed_cohort = 1)$values
# init_session()
# run(input=input)
# Cget_output()
# terminate_session()

