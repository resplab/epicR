# EPIC Background

## 1 Introduction

The Evaluation Platform In COPD (EPIC) was a nationally funded research
project with the aim of creating an open-source, publicly available,
population-based ‘Whole Disease’ COPD model for epidemiological
projections and policy analyses in the Canadian context.

## 2 The Study

The **epicR** package and application are based on the paper
[Development and Validation of theEvaluation Platform in COPD (EPIC):A
Population-Based Outcomes Modelof COPD for
Canada](https://journals.sagepub.com/doi/pdf/10.1177/0272989X18824098),
published in 2019.

### 2.1 Background

The purpose of this study is to model how COPD (Chronic Obstructive
Pulmonary Disease) affects a whole population. In social sciences and
population health, we often use a **dynamic microsimulation** model to
look at how a disease might affect a population over a period of time.

### What is a Dynamic Microsimulation?

A dynamic microsimulation is a computer model which makes predictions
about how a population will be affected by say, a disease, over a set
period of time.

In the case of **EPIC**, we wanted to look at the affects of COPD on the
Canadian population. To start with, the computer model uses data from
the [2001 Canadian Community Health Survey
1.1](https://www23.statcan.gc.ca/imdb/p2SV.pl?Function=getSurvey&Id=3359)
to create simulated, or “artificial” people. The survey included
information from 105 908 Canadians. The model uses this to create ~ 22.5
million community-dwelling Canadians.

As with any real population, the simulated population is constantly
changing. We define a change in a simulated individual as an **event**.

We combined 12 different studies to look at 7 different aspects of COPD:

1.  [Demographic and Risk Factor Module](#demographic)
2.  [COPD Occurence Module](#occurence)
3.  [Lung Function Module](#lungfunction)
4.  [Exacerbation Module](#exacerbation)
5.  [Mortality Module](#mortality)
6.  [Payoff Module](#payoff)
7.  [Smoking Module](#smoking)

### Demographic and Risk Factor Module

The Demographic and Risk Factor Module is based on the results from
[POHEM](https://doi.org/10.1186/s12963-015-0057-x), which is the dynamic
microsimulation model we described previously. This is basically the
background data for the simulation.

### COPD Occurence Module

We used data from the Canadian Cohort of Obstructive Lung Disease (COLD)
to assign a binary COPD status to individuals upon their creation.

### Lung Function Module

Once the COPD designation is defined for an individual, an
individual-specific initial FEV₁ value and an individual-specific annual
rate of FEV₁ decline are assigned. The 3 components of this module are
the initial FEV₁ value for preexisting (prevalent) COPD cases, initial
FEV₁ values for incident COPD cases, and the slope of decline in FEV₁
over time.

### Exacerbation Module

In COPD, patients can sometimes experience what are called
exacerbations.

**exacerbation**: acute worsening of COPD symptoms; acute means sudden
onset, short in duration; COPD symptoms include shortness of breath,
wheezing, coughing up mucus, etc.

#### Exacerbation Severity

**hazard**: instantaneous exacerbation rate

### Mortality Module

We categorized death into two categories: death from COPD, and death not
from COPD. More formally:

**COPD-related mortality**: Death due to a severe or very severe COPD
exacerbation. **Background mortality**: Death from all other causes
(excluding COPD).

### Payoff Module

Like any disease, COPD costs money to treat, and is a cost on the
healthcare system. Additionally, having COPD can reduce quality of life,
which depends on the severity of the diagnosis and number of
exacerbations. We define cost and utility, below, and divided each into
2 categories:

#### Module Summary

### Smoking Module

This module assesses the impact of smoking on the development and
progression of COPD. Smoking status (e.g., smoker, former smoker,
non-smoker) is incorporated into the model to account for its effect on
the individual’s health trajectory.
