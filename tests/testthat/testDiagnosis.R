library(testthat)
library(epicR)
library(dplyr)

context("Diagnosis Tests")
test_that("Proportion diagnosed in GOLD 1 and 2 is no greater than 40%, and Proporsed increased by Gold stage", {
  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  prop <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     output_ex$n_Diagnosed_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)[,c(1,3,4,5,6)]
  names(prop) <- c("Year","GOLD1","GOLD2","GOLD3","GOLD4")
  prop <- prop[-1,]


  #Total proportion of diagnosis of Gold 1 and Gold 2 
  Gold_I_meanprop <- mean(prop$GOLD1[1:nrow(prop)])
  Gold_II_meanprop <-mean(prop$GOLD2[1:nrow(prop)])
  
 
  # Test total proportion on average years
  expect_lt (Gold_I_meanprop,0.4)
  expect_lt (Gold_II_meanprop,0.4)
  
  # Test proportion year by year
  Gold_I_prop <- prop %>% filter(GOLD1>0.4)
  expect_equal (nrow(Gold_I_prop),0)
  
  #Test diagnosis proportion increases by GOLD stages
  Gold_meanprop= data.frame(colMeans(prop[,2:5]))
  all(diff(Gold_meanprop) > 0)

terminate_session()
})
