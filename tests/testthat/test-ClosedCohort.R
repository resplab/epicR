test_that("Closed-cohort option creates at least 20% fewer patients", {
  init_session()
  run()
  nOpenPopulation <- Cget_output()$n_agents
  terminate_session()

  init_session()
  input <- get_input(closed_cohort = 1)$values
  run(input=input)
  nClosedCohort <- Cget_output()$n_agents
  terminate_session()

  expect_lt(nClosedCohort, nOpenPopulation*0.8)
  expect_lt(Cget_inputs()$agent$l_inc_betas[1], -100)
})
