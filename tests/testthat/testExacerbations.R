library(testthat)
library(epicR)
library(dplyr)
library(tidyverse)

context("Exacerbation tests")

test_that("The number of severe exacerbations per year is close to 100,000,The annual rate of all exacerbations in Diagnosed is higher than Undiagnosed,
          The annual rate of all exacerbations in Diagnosed is higher that Undiagnosed in no treatment patients,
          The exacerbation rate and severe exacerbation rate is increased by Gold stage in no treatment patients ", {

  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()


  n_exac <- data.frame(year= 1:inputs$global_parameters$time_horizon,
                      Severe_Exacerbations = output_ex$n_exac_by_ctime_severity_diagnosed[,3]* (18.6e6/rowSums(output_ex$n_alive_by_ctime_sex)))

  averagen_severeexac <- mean (n_exac$Severe_Exacerbations)


  #Test number of severe exacerbations per year close to 100,000:
  expect_equal(averagen_severeexac, 100000, tolerance= 5e+3)



  #Exacerbation rate in Diagnosed patients
  diag_exacrate <- mean((rowSums(output_ex$n_exac_by_ctime_severity_diagnosed)/rowSums(output_ex$n_Diagnosed_by_ctime_sex))[-1])

  #Exacerbatio rate in undiagnosed patients
  undiag_exacrate <- mean((rowSums(output_ex$n_exac_by_ctime_severity - output_ex$n_exac_by_ctime_severity_diagnosed)/
                             rowSums(output_ex$n_COPD_by_ctime_sex - output_ex$n_Diagnosed_by_ctime_sex))[-1])


  #Test annual rate of rate of all exacerbations higher in diagnosed than undiagnosed
  expect_lt(undiag_exacrate, diag_exacrate )



  ## Set the treatment effect to 0 and redo the test
  init_session()
  input_nt <- init_input()
  input_nt$values$medication$medication_ln_hr_exac <- rep(0, length(input_nt$values$medication$medication_ln_hr_exac))
  run(input = input_nt$values)

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  #Exacerbation rate in Diagnosed patients
  diag_exacrate_nt <- mean((rowSums(output_ex$n_exac_by_ctime_severity_diagnosed)/rowSums(output_ex$n_Diagnosed_by_ctime_sex))[-1])

  #Exacerbatio rate in undiagnosed patients
  undiag_exacrate_nt <- mean((rowSums(output_ex$n_exac_by_ctime_severity - output_ex$n_exac_by_ctime_severity_diagnosed)/
                             rowSums(output_ex$n_COPD_by_ctime_sex - output_ex$n_Diagnosed_by_ctime_sex))[-1])


  #Test annual rate of rate of all exacerbations higher in diagnosed than undiagnosed
  expect_lt(undiag_exacrate_nt,diag_exacrate_nt)



  #Rate of exacerbation by Gold stage
  diag_exacrate_gold_nt <- rowSums(output_ex$n_exac_by_gold_severity_diagnosed)/colSums(output_ex$n_Diagnosed_by_ctime_severity[,2:5])
  diag_exacrategoldTest_nt= data.frame(mean=diag_exacrate_gold_nt)
  diag_exacrategoldTest_nt$difference <- diag_exacrategoldTest_nt$mean - lag(diag_exacrategoldTest_nt$mean)

  #Test the average rate of exacerbation has increased by Gold stage
  expect_gt(diag_exacrategoldTest_nt$difference[2], 0)
  expect_gt(diag_exacrategoldTest_nt$difference[3], 0)
  expect_gt(diag_exacrategoldTest_nt$difference[4], 0)



  #Rate of severe exacerbation by Gold stage
  diag_sevexacrate_gold_nt <- output_ex$n_exac_by_gold_severity_diagnosed[,3]/colSums(output_ex$n_Diagnosed_by_ctime_severity[,2:5])
  diag_sevexacrategoldTest_nt= data.frame(mean=diag_sevexacrate_gold_nt)
  diag_sevexacrategoldTest_nt$difference <- diag_sevexacrategoldTest_nt$mean - lag(diag_sevexacrategoldTest_nt$mean)

  #Test the average rate of severe exacerbation has increased by Gold stage
  expect_gt(diag_sevexacrategoldTest_nt$difference[2], 0)
  expect_gt(diag_sevexacrategoldTest_nt$difference[3], 0)
  expect_gt(diag_sevexacrategoldTest_nt$difference[4], 0)



  terminate_session()

})



