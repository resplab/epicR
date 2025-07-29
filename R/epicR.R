#' \code{epicR} package
#'
#' Evaluation Platform in COPD (EPIC) R Package
#'
#' See the README on
#' \href{https://github.com/aminadibi/epicR#readme}{GitHub}
#'
#' @name epicR-package
#' @aliases epicR
"_PACKAGE"

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".",
  "Age", "Age_Group", "CD", "COPD", "Diagnosed", "Diagnosis", "Exacerbation", "Female", "GOLD",
  "GOLD1", "GOLD4", "Incidence", "Male", "Mild", "NoCOPD", "NonCOPD", "Number", "Overdiagnosed",
  "Prevalence", "Proportion", "Rate", "Sex", "Undiagnosed", "Variable", "VerySevere", "Visits",
  "Year", "Year_with_COPD", "age", "age_at_creation", "age_coeff_men", "age_coeff_women",
  "cox.zph", "coxph", "diagnosis", "event", "exac_status", "female", "followup_after_COPD",
  "gold", "intercept_men", "intercept_women", "iteration", "local_time",
  "medication_status", "pack_years", "packyears_coeff_men",
  "packyears_coeff_women", "population", "prop", "resid_age_coeff_men",
  "resid_age_coeff_women", "resid_intercept_men", "resid_intercept_women",
  "resid_packyears_coeff_men", "resid_packyears_coeff_women", "settings",
  "smoking_status", "theme_cleantable", "time_at_creation", "value", "variable"
))
