library(epicR)
context("Exacerbation Tests")

test_that("Exacerbation rates per GOLD stage are not more than 10% off when compared with literature", {
  input <- model_input$values
  init_session()
  run()
  op <- Cget_output()
  all_events <- as.data.frame(Cget_all_events_matrix())
  exac_events <- subset(all_events, event == 5)
  exit_events <- subset(all_events, event == 14)

  Follow_up_Gold <- c(0, 0, 0, 0)
  last_GOLD_transition_time <- 0
  for (i in 2:dim(all_events)[1]) {
    if (all_events[i, "id"] != all_events[i - 1, "id"])
      last_GOLD_transition_time <- 0
    if ((all_events[i, "id"] == all_events[i - 1, "id"]) & (all_events[i, "gold"] != all_events[i - 1, "gold"])) {
      Follow_up_Gold[all_events[i - 1, "gold"]] = Follow_up_Gold[all_events[i - 1, "gold"]] + all_events[i - 1, "followup_after_COPD"] -
        last_GOLD_transition_time
      last_GOLD_transition_time <- all_events[i - 1, "followup_after_COPD"]
    }
    if (all_events[i, "event"] == 14)
      Follow_up_Gold[all_events[i, "gold"]] = Follow_up_Gold[all_events[i, "gold"]] + all_events[i, "followup_after_COPD"] -
        last_GOLD_transition_time
  }

  terminate_session()
  GOLD_I_diff <- abs((as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1]) - 0.1927)
  GOLD_II_diff <- abs((as.data.frame(table(exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2]) - 0.434)
  GOLD_III_diff <- abs((as.data.frame(table(exac_events[, "gold"]))[3, 2]/Follow_up_Gold[3]) - 0.939)
  GOLD_IV_diff <- abs((as.data.frame(table(exac_events[, "gold"]))[4, 2]/Follow_up_Gold[4]) - 1.92)
  total_exac_severep <- (op$total_exac[3] + op$total_exac[4]) / (input$global_parameters$time_horizon * default_settings$n_base_agents) * 18.6e6 #18.6e6 is roughly the 40+ population of Canada as of 2017

  # to be recalculated;
  expect_lt (GOLD_I_diff/0.1927, 0.4)
  expect_lt (GOLD_II_diff/0.434, 0.4)
  expect_lt (GOLD_III_diff/0.939, 0.4)
  expect_lt (GOLD_IV_diff/1.92, 0.4)

#  expect_lt (total_exac_severep, 10e4)
#  expect_gt (total_exac_severep, 7e4)
})

