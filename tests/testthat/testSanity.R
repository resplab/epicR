library(epicR)
context("Sanity")

test_that("Zeroing all input costs will result in overall zero costs", {
  init_session()
  input <- model_input$values
  for (el in get_list_elements(input$cost)) input$cost[[el]] <- input$cost[[el]] * 0
  res <- run(1, input = input)
  expect_equal(Cget_output()$total_cost, 0)
  terminate_session()
})

test_that("Zeroing all utilities will result in overal zero utility", {
  init_session()
  input <- model_input$values
  for (el in get_list_elements(input$utility)) input$utility[[el]] <- input$utility[[el]] * 0
  res <- run(input = input)
  expect_equal(Cget_output()$total_qaly , 0)
  terminate_session()
})

test_that("A utility of one for everything will result in one QALY if no discounting", {
  init_session()
  input <- model_input$values
  input$global_parameters$discount_qaly <- 0
  for (el in get_list_elements(input$utility)) input$utility[[el]] <- input$utility[[el]] * 0 + 1
  input$utility$exac_dutil = input$utility$exac_dutil * 0
  res <- run(input = input)
  expect_equal(Cget_output()$total_qaly/Cget_output()$cumul_time, 1)
  terminate_session()
})

test_that ("Zeroing mortality rates (both background and exacerbation-caused) will result in zero mortality", {
  init_session()
  input <- model_input$values
  input$exacerbation$logit_p_death_by_sex <- input$exacerbation$logit_p_death_by_sex * 0 - 10000000  # log scale'
  input$agent$p_bgd_by_sex <- input$agent$p_bgd_by_sex * 0
  input$manual$explicit_mortality_by_age_sex <- input$manual$explicit_mortality_by_age_sex * 0
  res <- run(input = input)
  expect_equal(Cget_output()$n_deaths, 0)
  terminate_session()
})


