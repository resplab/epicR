## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(rmarkdown.html_vignette.check_title = FALSE)

## ----eval=FALSE---------------------------------------------------------------
# # Read the US template
# us_config <- jsonlite::fromJSON("inst/config/config_us.json")
# 
# # Modify for Germany
# germany_config <- us_config
# germany_config$jurisdiction <- "germany"
# 
# # Save the template
# jsonlite::write_json(germany_config, "inst/config/config_germany.json",
#                      pretty = TRUE, auto_unbox = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# # Test that the configuration loads without errors
# library(epicR)
# input <- get_input(jurisdiction = "germany")

## ----eval=FALSE---------------------------------------------------------------
# # Run a small simulation to check for errors
# init_session()
# input <- get_input(jurisdiction = "germany")
# run(input = input$values)
# results <- Cget_output()
# terminate_session()

## ----eval=FALSE---------------------------------------------------------------
# # 1. Create base configuration
# germany_config <- list(
#   jurisdiction = "germany",
#   global_parameters = list(
#     age0 = 40,
#     time_horizon = 20,
#     discount_cost = 0.03,  # German health economics guidelines
#     discount_qaly = 0.03,
#     closed_cohort = 0
#   ),
#   agent = list(
#     p_female = 0.507,  # German Federal Statistical Office 2023
#     # ... other parameters
#   ),
#   cost = list(
#     cost_gp_visit = 25.50,  # German fee schedule 2023
#     cost_outpatient_diagnosis = 85.40,
#     # ... other costs
#   )
#   # ... other parameter categories
# )
# 
# # 2. Save configuration
# jsonlite::write_json(germany_config,
#                      "inst/config/config_germany.json",
#                      pretty = TRUE, auto_unbox = TRUE)
# 
# # 3. Test the configuration
# library(epicR)
# input <- get_input(jurisdiction = "germany")

