library(testthat)
library(epicR)
library(dplyr)
library(readr)

# Function to check if the target and simulated results are within a determined expected difference (tolerance)
expect_error_within <- function(actual, expected, tolerance = 0.1, label = NULL) {
  if (is.na(actual)) fail(paste(label, "Actual value is NA"))
  if (is.na(expected)) fail(paste(label, "Expected value is NA"))
  if (expected == 0) {
    if (actual == 0) succeed() else fail(paste(label, "Expected 0 but got", actual))
    return()
  }

  error_percentage <- abs((actual - expected) / expected) * 100

  # We expect the relative difference to be less than the tolerance (e.g., 0.5 for 50%)
  expect_lt(
    abs((actual - expected) / expected),
    tolerance,
    label = paste0(label, ": Actual=", round(actual, 4),
                   ", Expected=", round(expected, 4),
                   " (Error=", round(error_percentage, 2), "%)")
  )
}

test_that("validate_smokingUS: Matches 2018 and 2023 targets within 50%", {

  # Run the function to get model outputs
  capture.output({
    results_df <- validate_smokingUS()
  })

  # Define Targets
  target_current_2018 <- 0.132 # 13.2%
  target_former_2018  <- 0.293 # 29.3%
  target_never_2018   <- 0.575 # 57.5%
  target_current_2023 <- 0.097 # 9.7%

  # Validate 2018 Rates (Tolerance: 50% or 0.5)
  row_2018 <- results_df[results_df$Year == 2018, ]
  expect_error_within(row_2018$Current,   target_current_2018, 0.5, "2018 Current Smokers")
  expect_error_within(row_2018$Former,    target_former_2018,  0.5, "2018 Former Smokers")
  expect_error_within(row_2018$NonSmoker, target_never_2018,   0.5, "2018 Never Smokers")

  # Validate 2023 Current Smoker Rate (Tolerance: 50% or 0.5)
  row_2023 <- results_df[results_df$Year == 2023, ]
  expect_error_within(row_2023$Current, target_current_2023, 0.5, "2023 Current Smokers")
})

test_that("validate_COPDUS: Prevalence by age groups matches targets within 10%", {

  capture.output({
    copd_summary <- validate_COPDUS()
  })

  row_2015 <- copd_summary[copd_summary$Year == 2015, ]
  # Check COPD prevalence for age 40-59 and 60-79 (expected difference: 10%)
  expect_error_within(row_2015$Prevalence_40to59, 0.081, 0.1, "COPD Prevalence Age 40-59")
  expect_error_within(row_2015$Prevalence_60to79, 0.144, 0.1, "COPD Prevalence Age 60-79")
})

test_that("validate_populationUS: Projections match Census within 10% for ages 40-79 combined", {

  capture.output({
    pop_data <- validate_populationUS()
  })

  years_to_check <- c(2020, 2040, 2060)

  for (yr in years_to_check) {

    data_yr <- pop_data[pop_data$year == yr, ]

    # Check Age 40-79 Combined (expected difference: 10%)
    rows_combined <- data_yr[data_yr$age_group %in% c("40-59", "60-79"), ]

    if (nrow(rows_combined) > 0) {
      combined_epic <- sum(rows_combined$total_EPIC_population, na.rm = TRUE)
      combined_us   <- sum(rows_combined$total_US_population, na.rm = TRUE)

      expect_error_within(
        actual = combined_epic,
        expected = combined_us,
        tolerance = 0.1,
        label = paste("Population Age 40-79", yr)
      )
    } else {
      fail(paste("No population data found for Age 40-79 in year", yr))
    }
  }
})

test_that("validate_exacerbationUS: Runs without error", {
  capture.output({
    expect_error(validate_exacerbationUS(base_agents = 1e3), NA)
  })
})
