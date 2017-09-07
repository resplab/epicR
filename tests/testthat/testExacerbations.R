library(epicR)
context("Exacerbation Tests")

test_that("Exacerbation rates per GOLD stage are not more than 10% off when compared with literature", {
  init_session()
  run()
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
  GOLD_I_diff <- abs((as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1]) - 0.79)
  GOLD_II_diff <- abs((as.data.frame(table(exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2]) - 1.22)
  GOLD_IIIp_diff <- abs (((as.data.frame(table(exac_events[, "gold"]))[3, 2] + as.data.frame(table(exac_events[, "gold"]))[4,2])/(Follow_up_Gold[3] + Follow_up_Gold[4])) - 1.47)

  expect_lt (GOLD_I_diff/0.79, 0.2)
  expect_lt (GOLD_II_diff/1.22, 0.2)
  expect_lt (GOLD_IIIp_diff/1.47, 0.2)
  })
