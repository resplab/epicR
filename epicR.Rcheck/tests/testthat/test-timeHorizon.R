test_that("default time horizon is 20 years", {
  expect_equal(get_input()$values$global_parameters$time_horizon, 20)
})
