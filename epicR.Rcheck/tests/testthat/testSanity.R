test_that("Testing if zeroing all costs, all utilities, and mortalities leads to expected results", {
  init_session()
  run()
  terminate_session()
  expect_equal(sanity_check(), 0)
})
