test_that("In untreated patients:
           (1) The number of severe exacerbations per year is close to 100,000 (CIHI data),
           (2) The annual rate of all exacerbations is higher in diagnosed than undiagnosed patients, and
           (3) The rate of all exacerbations and severe exacerbations increases by GOLD stage", {


  library(dplyr)
  init_session()
  input <- get_input()
  input$values$medication$medication_ln_hr_exac <- rep(0, length(input$values$medication$medication_ln_hr_exac))
  run(input = input$values)

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  #(1) Number of severe exacerbations per year close to 100,000:
  n_exac <- data.frame(year= 1:inputs$global_parameters$time_horizon,
                      Severe_Exacerbations = output_ex$n_exac_by_ctime_severity_diagnosed[,3]* (18.6e6/rowSums(output_ex$n_alive_by_ctime_sex)))

  averagen_severeexac <- mean(n_exac$Severe_Exacerbations[round(nrow(n_exac)/2,0):nrow(n_exac)])

  expect_equal(averagen_severeexac, 100000, tolerance= 5e+3)

  terminate_session()

  # (2) Annual rate of all exacerbations is higher in diagnosed than undiagnosed patients
  diag_exacrate <- mean(rowSums(output_ex$n_exac_by_ctime_severity_diagnosed)/rowSums(output_ex$n_Diagnosed_by_ctime_sex))

  undiag_exacrate <- mean(rowSums(output_ex$n_exac_by_ctime_severity - output_ex$n_exac_by_ctime_severity_diagnosed)/
                             rowSums(output_ex$n_COPD_by_ctime_sex - output_ex$n_Diagnosed_by_ctime_sex))

  expect_lt(undiag_exacrate, diag_exacrate)

  # (3a) The overall rate of exacerbations increases by Gold stage
  diag_exacrate_gold <- rowSums(output_ex$n_exac_by_gold_severity_diagnosed)/
                            colSums(output_ex$n_Diagnosed_by_ctime_severity[,2:5])

  diag_exacrategoldTest <- data.frame(mean=diag_exacrate_gold)

  diag_exacrategoldTest$difference <- diag_exacrategoldTest$mean - lag(diag_exacrategoldTest$mean)

  expect_gt(diag_exacrategoldTest$difference[2], 0)
  expect_gt(diag_exacrategoldTest$difference[3], 0)
  expect_gt(diag_exacrategoldTest$difference[4], 0)

  # (3b) The rate of severe exacerbations increases by Gold stage
  diag_sevexacrate_gold <- output_ex$n_exac_by_gold_severity_diagnosed[,3]/colSums(output_ex$n_Diagnosed_by_ctime_severity[,2:5])
  diag_sevexacrategoldTest <- data.frame(mean=diag_sevexacrate_gold)
  diag_sevexacrategoldTest$difference <- diag_sevexacrategoldTest$mean - lag(diag_sevexacrategoldTest$mean)

  expect_gt(diag_sevexacrategoldTest$difference[2], 0)
  expect_gt(diag_sevexacrategoldTest$difference[3], 0)
  expect_gt(diag_sevexacrategoldTest$difference[4], 0)

  terminate_session()

})



