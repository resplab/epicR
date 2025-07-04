% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validation.R
\name{validate_mortality}
\alias{validate_mortality}
\title{Returns results of validation tests for mortality rate}
\usage{
validate_mortality(
  n_sim = 5e+05,
  bgd = 1,
  bgd_h = 1,
  manual = 1,
  exacerbation = 1,
  comorbidity = 1
)
}
\arguments{
\item{n_sim}{number of simulated agents}

\item{bgd}{a number}

\item{bgd_h}{a number}

\item{manual}{a number}

\item{exacerbation}{a number}

\item{comorbidity}{a number}
}
\value{
validation test results
}
\description{
This function returns a table and a plot of the difference between simulated and expected
(life table) mortality, by sex and age.
}
