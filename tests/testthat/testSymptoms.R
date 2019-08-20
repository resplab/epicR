library(testthat)
library(epicR)
library(dplyr)


context("Symptoms tests")

test_that("The average GP visits in eeach of the 4 symptoms (cough, phlegm, wheeze, dyspnea) has increased by Severity", {

  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  cough <- data.frame(1:inputs$global_parameters$time_horizon,
                      output_ex$n_cough_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(cough) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  phlegm <- data.frame(1:inputs$global_parameters$time_horizon,
                       output_ex$n_phlegm_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(phlegm) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  wheeze <- data.frame(1:inputs$global_parameters$time_horizon,
                       output_ex$n_wheeze_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(wheeze) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  dyspnea <- data.frame(1:inputs$global_parameters$time_horizon,
                        output_ex$n_dyspnea_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(dyspnea) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")


  #Test average prevalence of each of the symptoms has increased by GOLD stage for the overall years:

  ##COUGH
  cough_prop= data.frame(mean=colMeans(cough[,2:6]))
  cough_prop$difference <- cough_prop$mean - lag(cough_prop$mean)

  expect_gt(cough_prop$difference[2], 0)
  expect_gt(cough_prop$difference[3], 0)
  expect_gt(cough_prop$difference[4], 0)
  expect_gt(cough_prop$difference[5], 0)


  ##PHLEGM
  phlegm_prop= data.frame(mean=colMeans(phlegm[,2:6]))
  phlegm_prop$difference <- phlegm_prop$mean - lag(phlegm_prop$mean)

  #expect_gt(phlegm_prop$difference[2], 0)
  expect_gt(phlegm_prop$difference[3], 0)
  expect_gt(phlegm_prop$difference[4], 0)
  expect_gt(phlegm_prop$difference[5], 0)


  ##WHEEZE
  wheeze_prop= data.frame(mean=colMeans(wheeze[,2:6]))
  wheeze_prop$difference <- wheeze_prop$mean - lag(wheeze_prop$mean)

  expect_gt(wheeze_prop$difference[2], 0)
  expect_gt(wheeze_prop$difference[3], 0)
  expect_gt(wheeze_prop$difference[4], 0)
  expect_gt(wheeze_prop$difference[5], 0)


  ##DYSPNEA
  dyspnea_prop= data.frame(mean=colMeans(dyspnea[,2:6]))
  dyspnea_prop$difference <- dyspnea_prop$mean - lag(dyspnea_prop$mean)

  expect_gt(dyspnea_prop$difference[2], 0)
  expect_gt(dyspnea_prop$difference[3], 0)
  expect_gt(dyspnea_prop$difference[4], 0)
  expect_gt(dyspnea_prop$difference[5], 0)

  terminate_session()

})
