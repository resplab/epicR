## ----eval = TRUE, echo = FALSE------------------------------------------------

library(knitr)

drug_costs <- data.frame(
  class <- c("ICS + LAMA + LABA", "LAMA", "LAMA+LABA", "SABA"),
  monthly_cost <- c(296.11, 208.10, 218.05, 32.2),
  dispenses_per_year = c(12, 12, 12, 12)
)

drug_costs$annual_cost <- round(drug_costs$monthly_cost * drug_costs$dispenses_per_year, 2)

kable(drug_costs,
      col.names = c("Drug Class", "Monthly Cost (USD)", "Dispenses/Year", "Estimated Annual Cost (USD)"),
      format.args = list(big.mark = ","),
      caption = "Estimated Annual COPD Inhaler Costs by Drug Class")


## ----eval = TRUE, echo = FALSE------------------------------------------------

copd_background_costs <- data.frame(
  `GOLD Stage` = c("GOLD I", "GOLD II", "GOLD III", "GOLD IV"),
  `Total COPD Cost` = c(5945, 6978, 10751, 18070),
  `Inpatient` = c(3853, 4449, 6277, 12139),
  `ER Visits` = c(186, 144, 193, 534),
  `Pharmacy` = c(592, 1101, 2000, 2479),
  `Background Cost` = c(1314, 1284, 2281, 2918)
)

kable(copd_background_costs,
      col.names = c("GOLD Stage", "Total COPD-related Medical Costs", "Inpatient", "ER Visits", "Pharmacy", "Background Cost (USD)"),
      format.args = list(big.mark = ","),
      caption = "COPD-related Background Costs by GOLD Stage")


## ----eval = TRUE, echo = FALSE------------------------------------------------

exacerbation_costs <- data.frame(
  `Exacerbation Severity` = c("Mild", "Moderate", "Severe", "Very Severe"),
  `Definition` = c(
    "Increased SABA medication usage",
    "No hospitalization",
    "Inpatient hospitalization",
    "ICU + intubation"
  ),
  `Cost (USD)` = c(16.1, 2107, 22729, 44909),
  `Source` = c(
    "Assumption",
    "Bogart et al. 2020",
    "Bogart et al. 2020",
    "Dalal et al. 2011"
  )
)

kable(exacerbation_costs,
      col.names = c("Exacerbation Severity", "Definition", "Cost (USD)", "Source"),
      format.args = list(big.mark = ","),
      caption = "Per-Event COPD Exacerbation Costs by Severity")

## ----eval = TRUE, echo = FALSE------------------------------------------------

smoking_cessation <- data.frame(
  Therapy = c("Nicotine Patch", "Nicotine Gum/Lozenge", "Nicotine Spray/Inhaler", 
              "Varenicline", "Bupropion", "Behavioral Counseling", "Average (weighted)"),
  `Reweighted Proportion (%)` = c(31.5, 29.5, 1.6, 15.4, 10.3, 11.7, "--"),
  `Cost (USD)` = c(71, 35, 550, 402, 25, 168.16, 125.65)
)

kable(smoking_cessation,
      col.names = c("Therapy", "Reweighted Proportion (%)", "Cost (USD)"),
      format.args = list(big.mark = ",", nsmall = 2),
      caption = "Smoking Cessation Therapy Use and Cost Estimates (3-Month Duration)")


