library(testthat)
library(epicR)
library(dplyr)


context("Diagnosis tests")

test_that("Proportion diagnosed in GOLD 1 and 2 is no greater than 40%, and increased by Gold stage, proportion of non-COPD subjects overdiagnosed over model time is no greater than 5%", {

  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  diag_prop <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     output_ex$n_Diagnosed_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)[,c(1,3,4,5,6)]

  names(diag_prop) <- c("Year","GOLD1","GOLD2","GOLD3","GOLD4")

  diag_prop <- diag_prop[-1,]

  overdiag_prop <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                              NonCOPD=output_ex$n_COPD_by_ctime_severity[,1],
                              Overdiagnosed=rowSums(output_ex$n_Overdiagnosed_by_ctime_sex))

  overdiag_prop$Proportion <- overdiag_prop$Overdiagnosed/overdiag_prop$NonCOPD

  overdiag_prop <- overdiag_prop[-1,]

  #Total proportion of diagnosis of Gold 1 and Gold 2
  Gold_I_meanprop <- mean(diag_prop$GOLD1[1:nrow(diag_prop)])

  Gold_II_meanprop <-mean(diag_prop$GOLD2[1:nrow(diag_prop)])


  # Test total proportion of diagnosis Gold 1 and Gold 2 on average years
  expect_lt (Gold_I_meanprop,0.4)

  expect_lt (Gold_II_meanprop,0.4)

  # Test proportion year by year
  Gold_I_propTest <- diag_prop %>% filter(GOLD1>0.4)

  expect_equal (nrow(Gold_I_propTest),0)

  # Test diagnosis proportion increases by GOLD stages

  Gold_meanpropTest= data.frame(mean=colMeans(diag_prop[,2:5]))
  Gold_meanpropTest$difference <- Gold_meanpropTest$mean - lag(Gold_meanpropTest$mean)

  expect_gt(Gold_meanpropTest$difference[2], 0)
  expect_gt(Gold_meanpropTest$difference[3], 0)
  expect_gt(Gold_meanpropTest$difference[4], 0)


  # Test proportion of overdiagnnosis of non-COPD every year:
  overdiag_propTest <- overdiag_prop %>% filter (Proportion>0.05)

  expect_equal (nrow(overdiag_propTest), 0)



terminate_session()
})
