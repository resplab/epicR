test_that("(1) The average proportion diagnosed in GOLD 1 and 2 is < 40%,
           (2) The proportion diagnosed increases by GOLD stage, and
           (3) The overdiagnosis rate is always < 5%", {
  library(dplyr)
  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  # (1) Average proportion diagnosed in GOLD 1 and GOLD 2
  diag_prop <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     output_ex$n_Diagnosed_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)[,c(1,3,4,5,6)]

  names(diag_prop) <- c("Year","GOLD1","GOLD2","GOLD3","GOLD4")

  Gold_meanprop <- mean(c(diag_prop$GOLD1, diag_prop$GOLD2))

  expect_lt(Gold_meanprop,0.4)

  # Proportion diagnosed in GOLD 1 is <0.4 in every model year
  Gold_I_propTest <- diag_prop %>% filter(GOLD1>0.4)

  expect_equal(nrow(Gold_I_propTest),0)

  # (2) Proportion diagnosed increases by GOLD stage
  Gold_meanpropTest <- data.frame(mean=colMeans(diag_prop[,2:5]))
  Gold_meanpropTest$difference <- Gold_meanpropTest$mean - lag(Gold_meanpropTest$mean)

  expect_gt(Gold_meanpropTest$difference[2], 0)
  expect_gt(Gold_meanpropTest$difference[3], 0)
  expect_gt(Gold_meanpropTest$difference[4], 0)

  # (3) Proportion overdiagnosed in every model year:
  overdiag_prop <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                              NonCOPD=output_ex$n_COPD_by_ctime_severity[,1],
                              Overdiagnosed=rowSums(output_ex$n_Overdiagnosed_by_ctime_sex))

  overdiag_prop$Proportion <- overdiag_prop$Overdiagnosed/overdiag_prop$NonCOPD

  overdiag_prop <- overdiag_prop[-1,]

  overdiag_propTest <- overdiag_prop %>% filter (Proportion>0.05)

  expect_equal (nrow(overdiag_propTest), 0)

  terminate_session()

})
