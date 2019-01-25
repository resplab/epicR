library(epicR)
context("COPD Incidence")

test_that("COPD incidence is set so that prevalence is independent of calendar year within GOLD and gender stratas", {
  init_session()
  run()
  data <- as.data.frame(Cget_all_events_matrix())
  terminate_session()

  dataF <- data[which(data[, "event"] == 1), ] #1 is event_fixed
  dataF[, "age"] <- dataF[, "local_time"] + dataF[, "age_at_creation"]
  dataF[, "copd"] <- (dataF[, "gold"] > 0) * 1
  dataF[, "gold2p"] <- (dataF[, "gold"] > 1) * 1
  dataF[, "gold3p"] <- (dataF[, "gold"] > 2) * 1
  dataF[, "year"] <- dataF[, "local_time"] + dataF[, "time_at_creation"]


  res <- glm(data = dataF[which(dataF[, "female"] == 0), ], formula = copd ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
  expect_lt (coefficients(res)[5], 0.02)
  res <- glm(data = dataF[which(dataF[ "female"] == 1), ], formula = copd ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
  expect_lt (coefficients(res)[5], 0.02)

  res <- glm(data = dataF[which(dataF[, "female"] == 0), ], formula = gold2p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
  expect_lt (coefficients(res)[5], 0.02)
  res <- glm(data = dataF[which(dataF[, "female"] == 1), ], formula = gold2p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
  expect_lt (coefficients(res)[5], 0.02)

# For GOLD stage III and IV, the sample size is small and higher error is expected.
  res <- glm(data = dataF[which(dataF[, "female"] == 0), ], formula = gold3p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
  expect_lt (coefficients(res)[5], 0.07)
  res <- glm(data = dataF[which(dataF[, "female"] == 1), ], formula = gold3p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
  expect_lt (coefficients(res)[5], 0.07)




})
