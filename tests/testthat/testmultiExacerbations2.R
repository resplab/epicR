library(testthat)
library(epicR)
library(dplyr)
library(tidyverse)

context("The Number of Sever Exacerbation")

test_that("The number of severe exacerbations per year is close to 100,000", {

  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()


  n_exac <- data.frame(year= 1:inputs$global_parameters$time_horizon,
                      Severe_Exacerbations = output_ex$n_exac_by_ctime_severity_diagnosed[,3]* (18.6e6/rowSums(output_ex$n_alive_by_ctime_sex)))

  averagen_severeexac <- mean (n_exac$Severe_Exacerbations)


  #Test number of severe exacerbations per year close to 100,000:
  expect_equal(averagen_severeexac, 100000, tolerance= 5e+3)

  terminate_session()

})


context("The annual Rate of all exacerbations in Diagnosed and Undiagnosed")

test_that("The annual rate of all exacerbations in Diagnosed is higher than Undiagnosed", {

  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  #Exacerbation rate in Diagnosed patients
  diag_exacrate <- mean((rowSums(output_ex$n_exac_by_ctime_severity_diagnosed)/rowSums(output_ex$n_Diagnosed_by_ctime_sex))[-1])

  #Exacerbatio rate in undiagnosed patients
  undiag_exacrate <- mean((rowSums(output_ex$n_exac_by_ctime_severity - output_ex$n_exac_by_ctime_severity_diagnosed)/
                            rowSums(output_ex$n_COPD_by_ctime_sex - output_ex$n_Diagnosed_by_ctime_sex))[-1])


  #Test annual rate of rate of all exacerbations higher in diagnosed than undiagnosed
  expect_lt(undiag_exacrate, diag_exacrate )




  terminate_session()

})

# Set the treatment effect to 0 and redo the test
context("The annual Rate of all exacerbations in Diagnosed and Undiagnosed in no treatment patients")

test_that("The annual rate of all exacerbations in Diagnosed is higher that Undiagnosed in no treatment patients", {

  init_session()
  input_nt <- init_input()
  input_nt$values$medication$medication_ln_hr_exac <- rep(0, length(input_nt$values$medication$medication_ln_hr_exac))
  run(input = input_nt$values)

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  #Exacerbation rate in Diagnosed patients
  diag_exacrate <- mean((rowSums(output_ex$n_exac_by_ctime_severity_diagnosed)/rowSums(output_ex$n_Diagnosed_by_ctime_sex))[-1])

  #Exacerbatio rate in undiagnosed patients
  undiag_exacrate <- mean((rowSums(output_ex$n_exac_by_ctime_severity - output_ex$n_exac_by_ctime_severity_diagnosed)/
                             rowSums(output_ex$n_COPD_by_ctime_sex - output_ex$n_Diagnosed_by_ctime_sex))[-1])


  #Test annual rate of rate of all exacerbations higher in diagnosed than undiagnosed
  expect_lt(undiag_exacrate,diag_exacrate )




  terminate_session()

})


context("The (severe)exacerbation rate by Gold stage in no treatment patients")

test_that("The exacerbation rate and severe exacerbation rate is increased by Gold stage in no treatment patients ", {

  #Set the treatment effect to 0 and make sure the number if exacerbatiuons increased among diagnosed patients
  init_session()
  input_nt <- init_input()
  input_nt$values$medication$medication_ln_hr_exac <- rep(0, length(input_nt$values$medication$medication_ln_hr_exac))
  run(input = input_nt$values)

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  #Rate of exacerbation by Gold stage
  diag_exacrate_gold <- rowSums(output_ex$n_exac_by_gold_severity_diagnosed)/colSums(output_ex$n_Diagnosed_by_ctime_severity[,2:5])
  diag_exacrategoldTest= data.frame(mean=diag_exacrate_gold)
  diag_exacrategoldTest$difference <- diag_exacrategoldTest$mean - lag(diag_exacrategoldTest$mean)

  #Test the average rate of exacerbation has increased by Gold stage
  expect_gt(diag_exacrategoldTest$difference[2], 0)
  expect_gt(diag_exacrategoldTest$difference[3], 0)
  expect_gt(diag_exacrategoldTest$difference[4], 0)



  #Rate of severe exacerbation by Gold stage
  diag_sevexacrate_gold <- output_ex$n_exac_by_gold_severity_diagnosed[,3]/colSums(output_ex$n_Diagnosed_by_ctime_severity[,2:5])
  diag_sevexacrategoldTest= data.frame(mean=diag_sevexacrate_gold)
  diag_sevexacrategoldTest$difference <- diag_sevexacrategoldTest$mean - lag(diag_sevexacrategoldTest$mean)

  #Test the average rate of severe exacerbation has increased by Gold stage
  expect_gt(diag_sevexacrategoldTest$difference[2], 0)
  expect_gt(diag_sevexacrategoldTest$difference[3], 0)
  expect_gt(diag_sevexacrategoldTest$difference[4], 0)




  terminate_session()
})
