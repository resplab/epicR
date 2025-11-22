# Payoffs

## Overview

This document outlines the steps taken to determine input values for the
payoff module.

### Step 1: Estimating annual COPD medication costs

Annual COPD medication costs were estimated using two components:

1.  **Inhaler unit cost by drug class**
    - Prices were obtained from published literature (DOI:
      10.1513/AnnalsATS.202008-1082RL). Prices of SABA and LAMA were
      digitized from Figure 2A as these prices were not reported in the
      text.
    - It was assumed that one inhaler is used per month per drug class,
      resulting in 12 inhalers annually.  
    - Annual cost per drug class (2018 Costs USD) was calculated as:  
      `Annual Cost = Inhaler Unit Price × 12`
2.  **Real-world dispensing frequency based on proportion of days
    covered (PDC)**
    - PDC estimates were used to determine adherence to inhaler
      therapies
    - Sources for PDC data include:
      - **Mannino et al. 2022** (DOI: 10.1016/j.rmed.2022.106807)
      - **Slade et al. 2021** (DOI: 10.1186/s12890-021-01612-5)
      - **Bengtson et al. 2018** (DOI: 10.1177/1753466618772750)

##### Dispense frequency per year (adjusted via PDC)

**Mannino et al. 2022:**  
- **ICS + LAMA + LABA**: PDC = 0.66

**Slade et al. 2021:**  
- **LAMA + LABA**: PDC = 0.44  
- **LAMA**: PDC = 0.37

**Bengtson et al. 2018** - **SABA**: The study reported an average of 1
fill per month

**Adherence:** Adherence was determined to be an average of the PDC
reported between the studies that assessed non-SABA inhalers= 0.49.

| Drug Class        | Monthly Cost (USD) | Dispenses/Year | Estimated Annual Cost (USD) |
|:------------------|-------------------:|---------------:|----------------------------:|
| ICS + LAMA + LABA |             296.11 |             12 |                    3,553.32 |
| LAMA              |             208.10 |             12 |                    2,497.20 |
| LAMA+LABA         |             218.05 |             12 |                    2,616.60 |
| SABA              |              32.20 |             12 |                      386.40 |

Estimated Annual COPD Inhaler Costs by Drug Class

### Step 2: Estimating COPD-related background costs by GOLD stage

COPD-related background costs were estimated using data from Wallace et
al 2019 (DOI: 10.18553/jmcp.2019.25.2.205) Table 3, specifically the row
labeled “COPD-related costs, all patients”. Background costs were
calculated by subtracting the costs of **Inpatient Care**, **Emergency
Room (ER) Visits**, and **Pharmacy** from the **Total COPD-related
Medical Costs** (2016 Costs USD) as these costs are determined
separately.

| GOLD Stage | Total COPD-related Medical Costs | Inpatient | ER Visits | Pharmacy | Background Cost (USD) |
|:-----------|---------------------------------:|----------:|----------:|---------:|----------------------:|
| GOLD I     |                            5,945 |     3,853 |       186 |      592 |                 1,314 |
| GOLD II    |                            6,978 |     4,449 |       144 |    1,101 |                 1,284 |
| GOLD III   |                           10,751 |     6,277 |       193 |    2,000 |                 2,281 |
| GOLD IV    |                           18,070 |    12,139 |       534 |    2,479 |                 2,918 |

COPD-related Background Costs by GOLD Stage

### Step 3: Estimating exacerbation costs by severity

The exacerbation module assigns per-event direct medical costs based on
severity: **Mild**, **Moderate**, **Severe**, and **Very Severe**. These
cost estimates were derived from U.S.-based healthcare utilization
studies.

- **Mild Exacerbation**: Defined as an increase in bronchodilator use
  that does not result in a healthcare encounter. It is assumed that
  half of the number of available doses in a SABA inhaler is used per
  event. Cost of SABA inhaler is obtained from the published literature
  (DOI: 10.1513/AnnalsATS.202008-1082RL).
- **Moderate Exacerbation**: Involves a visit to a healthcare facility
  (e.g., physician office or emergency department) without resulting in
  hospital admission.
- **Severe Exacerbation**: Defined as an inpatient hospital admission
- **Very Severe Exacerbation**: Defined as ICU admission

The following references were used:

- **Dalal et al. 2011** (DOI: 10.1016/j.rmed.2010.09.003) — 2008 Costs
  USD  
- **Bogart et al. 2020** (DOI: 10.37765/ajmc.2020.43157) — 2017 Costs
  USD

| Exacerbation Severity | Definition                      | Cost (USD) | Source             |
|:----------------------|:--------------------------------|-----------:|:-------------------|
| Mild                  | Increased SABA medication usage |       16.1 | Assumption         |
| Moderate              | No hospitalization              |    2,107.0 | Bogart et al. 2020 |
| Severe                | Inpatient hospitalization       |   22,729.0 | Bogart et al. 2020 |
| Very Severe           | ICU + intubation                |   44,909.0 | Dalal et al. 2011  |

Per-Event COPD Exacerbation Costs by Severity

### Step 4: Estimating costs for smoking cessation

### Estimating the Cost of Smoking Cessation Therapy

To estimate the cost of smoking cessation therapy, the distribution of
commonly used pharmacologic and behavioral therapies was obtained from
the MMWR study (DOI: 10.15585/mmwr.mm7329a1). The reported usage among
individuals attempting to quit included:

- **Nicotine patch**: 19.6%  
- **Nicotine gum/lozenge**: 18.4%  
- **Nicotine spray/inhaler**: 1.0%  
- **Varenicline**: 9.6%  
- **Bupropion**: 6.4%  
- **Behavioral counseling**: 7.3%

#### Reweighted to Assume 100% Uptake

To standardize the distribution across therapies, reweighting was
performed using the total of all therapies (62.3%):

- **Nicotine patch**: (19.6 / 62.3) × 100 ≈ **31.5%**  
- **Nicotine gum/lozenge**: (18.4 / 62.3) × 100 ≈ **29.5%**  
- **Nicotine spray/inhaler**: (1.0 / 62.3) × 100 ≈ **1.6%**  
- **Varenicline**: (9.6 / 62.3) × 100 ≈ **15.4%**  
- **Bupropion**: (6.4 / 62.3) × 100 ≈ **10.3%**  
- **Behavioral counseling**: (7.3 / 62.3) × 100 ≈ **11.7%**

#### Estimated 3-Month Cost of Smoking Cessation Therapy

Cost estimates were based on 2025 GoodRx prices for a 3-month course of
pharmacotherapy.  
For behavioral counseling, Medicare reimburses up to 8 sessions per
year, which was assumed to be the number of sessions used.  
The per-session cost was based on **2015 CPT codes**:

- **99406**: \$14.37 for sessions \<10 minutes  
- **99407**: \$27.67 for sessions \>10 minutes

A midpoint value of **\$21.02** per session was applied, totaling
**\$168.16** for 8 sessions.

Using the reweighted proportions, the weighted average cost for 3 months
of smoking cessation pharmacotherapy was calculated as:

**Average cost**: \$125.65

| Therapy                | Reweighted Proportion (%) | Cost (USD) |
|:-----------------------|:--------------------------|-----------:|
| Nicotine Patch         | 31.5                      |      71.00 |
| Nicotine Gum/Lozenge   | 29.5                      |      35.00 |
| Nicotine Spray/Inhaler | 1.6                       |     550.00 |
| Varenicline            | 15.4                      |     402.00 |
| Bupropion              | 10.3                      |      25.00 |
| Behavioral Counseling  | 11.7                      |     168.16 |
| Average (weighted)     | –                         |     125.65 |

Smoking Cessation Therapy Use and Cost Estimates (3-Month Duration)

### Step 5: Estimating costs for GP visits and diagnostic spirometry

**GP visits**.  
CPT code 99214 is a standard outpatient GP visit, the midpoint between
facility and non facility visit reimbursement amounts was used which
equates \$94.15 (2015 Costs USD)

**Spirometry**. CPT code 94060 was used which equates to \$61.81 (2015
Costs USD)
