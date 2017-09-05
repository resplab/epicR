library(epicR)
context("Population Tests")

test_that("Average population age in simulated and predicted pyramids are less than 0.1 years apart", {
  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- 1e+06
  settings$event_stack_size <- 1
  init_session(settings = settings)
  input <- model_input$values

  x <- aggregate(CanSim.052.0005[, "value"], by = list(CanSim.052.0005[, "year"]), FUN = sum)
  x[, 2] <- x[, 2]/x[1, 2]
  x <- x[1:input$global_parameters$time_horizon, ]

  input$agent$l_inc_betas[1] <- input$agent$l_inc_betas[1] + log(1)
  res <- run(input = input)
  expect_equal(res, 0)

  n_y1_agents <- sum(Cget_output_ex()$n_alive_by_ctime_sex[1, ])
  pyramid <- matrix(NA, nrow = input$global_parameters$time_horizon, ncol = length(Cget_output_ex()$n_alive_by_ctime_age[1, ]) -
                      input$global_parameters$age0)

  for (year in 0:model_input$values$global_parameters$time_horizon - 1) pyramid[1 + year, ] <- Cget_output_ex()$n_alive_by_ctime_age[year +
                                                                                                                                       1, -(1:input$global_parameters$age0)]

  for (year in c(2015, 2025, 2034)) {
    x <- CanSim.052.0005[which(CanSim.052.0005[, "year"] == year & CanSim.052.0005[, "sex"] == "both"), "value"]
    x <- c(x, rep(0, 111 - length(x) - 40))
    x1 <- (sum((input$global_parameters$age0:(input$global_parameters$age0 + length(x) - 1)) * x)/sum(x))
    x <- pyramid[year - 2015 + 1, ]
    x2 <- (sum((input$global_parameters$age0:(input$global_parameters$age0 + length(x) - 1)) * x)/sum(x))
    diff <- abs(x1 - x2)
    expect_lt (diff, 0.5)
  }
})
