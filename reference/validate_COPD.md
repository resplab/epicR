# Returns results of validation tests for COPD

This function runs validation tests for COPD model outputs. It estimates
the baseline prevalence and incidence of COPD, along with sex-specific
baseline COPD prevalence. Additionally, it calculates the baseline
prevalence of COPD by age groups and smoking pack-years. It also
estimates the coefficients for the relationships between age,
pack-years, smoking status, and the prevalence of COPD.

## Usage

``` r
validate_COPD(incident_COPD_k = 1, return_CI = FALSE, jurisdiction = "canada")
```

## Arguments

- incident_COPD_k:

  a number (default=1) by which the incidence rate of COPD will be
  multiplied.

- return_CI:

  if TRUE, returns 95 percent confidence intervals for the "Year"
  coefficient

- jurisdiction:

  character string specifying the jurisdiction for validation ("canada"
  or "us"). Default is "canada".

## Value

For Canada: list with validation test results. For US: data frame with
COPD prevalence by age group over time.
