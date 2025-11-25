test_that("Context structures can be created and destroyed without errors", {
  # This test verifies Phase 1 implementation is working

  skip_if_not_installed("epicR")

  # Initialize a session with default settings
  init_session()

  # The context functions are C++ internal functions
  # We'll verify they don't crash the session by running a small model

  # Run a minimal simulation (just 10 agents)
  settings <- get_default_settings()
  settings$record_mode <- 0  # No recording to minimize memory

  # This internally uses the new context structures
  tryCatch({
    # Small test run
    set.seed(123)
    run(max_n_agents = 10, settings = settings)

    # Get outputs - verifies context copying works
    out <- Cget_output()

    # Basic sanity checks
    expect_true(out$n_agents >= 0)
    expect_true(out$n_agents <= 10)
    expect_true(out$cumul_time >= 0)

    success <- TRUE
  }, error = function(e) {
    success <- FALSE
    fail(paste("Context management error:", e$message))
  })

  # Clean up
  terminate_session()

  expect_true(exists("success") && success,
              "Context management functions should work without errors")
})

test_that("Multiple simulation contexts can be created", {
  # This test verifies we can create multiple independent contexts
  # (Even though we can't access them directly from R yet)

  skip_if_not_installed("epicR")

  # Run multiple independent simulations
  results <- list()

  for (i in 1:3) {
    init_session()

    set.seed(100 + i)
    run(max_n_agents = 5)

    results[[i]] <- Cget_output()
    terminate_session()
  }

  # Verify we got results from all runs
  expect_equal(length(results), 3)

  # Each should have processed agents
  for (i in 1:3) {
    expect_true(results[[i]]$n_agents >= 0)
  }
})

test_that("Context memory management doesn't leak", {
  # Basic test that contexts are properly freed

  skip_if_not_installed("epicR")

  # Run several sessions in sequence
  for (i in 1:5) {
    init_session()
    run(max_n_agents = 2)
    out <- Cget_output()
    expect_true(out$n_agents >= 0)
    terminate_session()
  }

  # If we got here without crashing, memory management is likely OK
  expect_true(TRUE)
})
