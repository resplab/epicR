library(epicR)
context("Sanity COPD")

test_that("Zero COPD patients are created when  both prevalence and incidence parameters are set to zero", {
  init_session()
  input <- model_input$values
  input$COPD$logit_p_COPD_betas_by_sex <- input$COPD$logit_p_COPD_betas_by_sex * 0 - 100
  input$COPD$ln_h_COPD_betas_by_sex <- input$COPD$ln_h_COPD_betas_by_sex * 0 - 100
  run(input = input)

  expect_equal(Cget_output()$n_COPD, 0)
  dataS <- get_events_by_type(events["event_start"])
  expect_equal(mean(dataS[, "gold"] > 0 ), 0)
  dataS <- get_events_by_type(events["event_end"])
  expect_equal(mean(dataS[, "gold"] > 0), 0)
  terminate_session()
})

test_that("Creating COPD cases only through incidence will result in an incidence below 15%", {
  init_session()
  input <- model_input$values
  input$COPD$logit_p_COPD_betas_by_sex <- input$COPD$logit_p_COPD_betas_by_sex * 0 - 100
  run(input = input)
  dataS <- get_events_by_type(events["event_start"])
  expect_equal(mean(dataS[, "gold"] > 0 ), 0)
  dataS <- get_events_by_type(events["event_end"])
  expect_lt(mean(dataS[, "gold"] > 0), 0.15)
  terminate_session()
})

test_that("Switiching off incidence and creating COPD cases only through a prevalence of 0.5, will result in 0.5 prevalence at start and end", {
  init_session()
  input <- model_input$values
  input$COPD$logit_p_COPD_betas_by_sex <- input$COPD$logit_p_COPD_betas_by_sex * 0
  input$COPD$ln_h_COPD_betas_by_sex <- input$COPD$ln_h_COPD_betas_by_sex * 0 - 100
  run(input = input)
  dataS <- get_events_by_type(events["event_start"])
  expect_lt(mean(dataS[, "gold"] > 0 ), 0.52)
  expect_gt(mean(dataS[, "gold"] > 0 ), 0.48)

  dataS <- get_events_by_type(events["event_end"])
  expect_lt(mean(dataS[, "gold"] > 0 ), 0.52)
  expect_gt(mean(dataS[, "gold"] > 0 ), 0.48)
  terminate_session()
})


