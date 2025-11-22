## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE  # Set to FALSE to prevent long-running simulations during package check
)

## ----setup--------------------------------------------------------------------
# library(epicR)

## ----validation---------------------------------------------------------------
# inputs <- get_input()$values
# inputs$exacerbation$ln_rate_betas = t(as.matrix(c(intercept = -3.4, female = 0, age = 0.04082 * 0.1, fev1 = -0, smoking_status = 0, gold1 = 1.4 , gold2 = 2.0 , gold3 = 2.4 , gold4 = 2.8 , diagnosis_effect = 0.9)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation----------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.7, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0, gold1 = 0.6 , gold2 = 0.35 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation1---------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.7, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0, gold1 = 0.3 , gold2 = 0.1 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation2---------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.7, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.5, gold1 = 0.3 , gold2 = 0.05 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation3---------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.7, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.5, gold1 = 0.3 , gold2 = -0.5 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation4---------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.7, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.5, gold1 = 0.3 , gold2 = -0.2 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation5---------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.7, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.5, gold1 = 0.3 , gold2 = -0.3 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

## ----validationNewEquation6---------------------------------------------------
# inputs$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.4, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.7, gold1 = 0.3 , gold2 = -0.3 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
# validate_exacerbation(5e4, inputs)

