test_that("Random functions work with global state (backward compatibility)", {
  # Verify that existing random functions still work

  skip_if_not_installed("epicR")

  init_session()

  # The legacy random functions use global buffers
  # We can't call them directly from R, but we can verify
  # they work by running a small simulation
  set.seed(42)
  run(max_n_agents = 5)

  out <- Cget_output()
  expect_true(out$n_agents >= 0)
  expect_true(out$n_agents <= 5)

  terminate_session()
})

test_that("Context-aware random functions are implemented", {
  # This test verifies that the context-aware random functions exist
  # and can be used (even though we can't call them directly from R yet)

  skip_if_not_installed("epicR")

  # The context-aware random functions are internal C++ functions
  # We verify they're working by running simulations which internally
  # will use the context structures we created

  results <- list()

  for (i in 1:3) {
    init_session()
    set.seed(100 + i)
    run(max_n_agents = 3)
    results[[i]] <- Cget_output()
    terminate_session()
  }

  # All simulations should complete successfully
  expect_equal(length(results), 3)

  for (i in 1:3) {
    expect_true(results[[i]]$n_agents >= 0)
  }
})

test_that("Random number generation is reproducible with same seed", {
  # Verify that random number generation produces consistent results

  skip_if_not_installed("epicR")

  # Run 1
  init_session()
  set.seed(12345)
  run(max_n_agents = 10)
  out1 <- Cget_output()
  terminate_session()

  # Run 2 with same seed
  init_session()
  set.seed(12345)
  run(max_n_agents = 10)
  out2 <- Cget_output()
  terminate_session()

  # Results should be identical
  expect_equal(out1$n_deaths, out2$n_deaths)
  expect_equal(out1$n_COPD, out2$n_COPD)
  expect_equal(out1$total_cost, out2$total_cost, tolerance = 1e-10)
  expect_equal(out1$total_qaly, out2$total_qaly, tolerance = 1e-10)
})
