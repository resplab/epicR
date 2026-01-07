# Returns results of validation tests for Symptoms

This function plots the prevalence of cough, dyspnea, phlegm and wheeze
over time and by GOLD stage.

## Usage

``` r
validate_symptoms(n_sim = 10000, jurisdiction = "canada")
```

## Arguments

- n_sim:

  number of agents

- jurisdiction:

  character string specifying the jurisdiction ("canada" or "us").
  Default is "canada"

## Value

validation test results
