test_that("The mean GP visits (1) increases by GOLD stage, and (2) is higher in diagnosed than undiagnosed patients", {

  library(dplyr)
  init_session()
  run()
  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  # Average GPvisits by time and GOLD stage
  GPvisits <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     output_ex$n_GPvisits_by_ctime_severity/output_ex$cumul_time_by_ctime_GOLD)

  names(GPvisits) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")
  GPvisits <- GPvisits[-1,]

  GPvisits_meantest <- data.frame(mean=colMeans(GPvisits[,2:6]))
  GPvisits_meantest$difference <- GPvisits_meantest$mean - lag(GPvisits_meantest$mean)

  expect_gt(GPvisits_meantest$difference[2], 0)
  expect_gt(GPvisits_meantest$difference[3], 0)
  expect_gt(GPvisits_meantest$difference[4], 0)
  expect_gt(GPvisits_meantest$difference[5], 0)

  # Average GPvisits in diagnosed and undiagnosed
  Diagnosed <- rowSums(output_ex$n_Diagnosed_by_ctime_sex)
  Undiagnosed <- rowSums(output_ex$cumul_time_by_ctime_GOLD[,2:5]) - Diagnosed

  diag.undiag <- cbind(Undiagnosed, Diagnosed)

  GPDiag<- data.frame(Year=1:inputs$global_parameters$time_horizon,
                      output_ex$n_GPvisits_by_ctime_diagnosis/diag.undiag)

  GPDiag <- (GPDiag[-1,])

  GPvisits_Diagtest <- data.frame(mean=colMeans(GPDiag[,2:3]))
  GPvisits_Diagtest$difference <- GPvisits_Diagtest$mean - lag(GPvisits_Diagtest$mean)

  expect_gt(GPvisits_Diagtest$difference[2], 0)

  terminate_session()

})
