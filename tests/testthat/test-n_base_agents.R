# Test that n_base_agents produces exactly the expected number of base agents
# This test verifies the fix for the off-by-one error where epic was adding 1
# to whatever was given as the starting number in settings$n_base_agents

test_that("n_base_agents creates exactly the specified number of base agents", {
  # Use a closed cohort (no incident cases) to ensure we only count base agents
  # Set a small number of base agents for faster testing
  n_target <- 100

  settings <- get_default_settings()
  settings$n_base_agents <- n_target
  settings$record_mode <- epicR:::session_env$record_mode["record_mode_none"]

  init_session(settings = settings)

  # Get closed cohort input (sets incidence to near-zero)
  input <- get_input(closed_cohort = 1)$values

  # Run with just the base agents (use n_target as max_n_agents)
  run(n_agents = n_target, input = input)

  # Get the number of agents created
  output <- Cget_output()
  n_agents_created <- output$n_agents

  terminate_session()

  # The number of agents should be exactly n_target, not n_target + 1

  expect_equal(n_agents_created, n_target,
               info = paste("Expected", n_target, "base agents but got", n_agents_created))
})
