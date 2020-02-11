Case Detection Scenario Main Analysis
================
11 February, 2020

    ## Initializing the session

    ## [1] 0

**Global inputs:**

  - Medication adherence is 0.7
  - Smoking adherence is 0.7
  - Cost discounting: 0.015
      - *The default price year for costs is 2015 CAD*
  - QALY discounting: 0.015
  - Time horizon: 20
  - The WTP threshold for NMB is 50000

**Case detection inputs:**

  - Case detection occurs at 3 year intervals.
  - An outpatient diagnosis costs 58.79
  - The utility gain due to symptom relief from treatment is 0.0367

## S1 All patients scenario

All patients are eligible. The cost of case detection is:

<table>

<thead>

<tr>

<th style="text-align:right;">

None

</th>

<th style="text-align:right;">

CDQ17

</th>

<th style="text-align:right;">

FlowMeter

</th>

<th style="text-align:right;">

FlowMeter\_CDQ

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11.1

</td>

<td style="text-align:right;">

29.27

</td>

<td style="text-align:right;">

40.37

</td>

</tr>

</tbody>

</table>

#### S1NoCD: No Case detection

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S1NoCD2: No Case detection- Other time interval

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S1A: CDQ ≥17 points

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S1B: Screening Spirometry with BD

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S1C: CDQ ≥17 points and Screening Spirometry with BD

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

<table>

<thead>

<tr>

<th style="text-align:left;">

Scenario

</th>

<th style="text-align:right;">

Agents

</th>

<th style="text-align:right;">

PatientYears

</th>

<th style="text-align:right;">

CopdPYs

</th>

<th style="text-align:right;">

NCaseDetections

</th>

<th style="text-align:right;">

DiagnosedPYs

</th>

<th style="text-align:right;">

OverdiagnosedPYs

</th>

<th style="text-align:right;">

SABA

</th>

<th style="text-align:right;">

LAMA

</th>

<th style="text-align:right;">

LAMALABA

</th>

<th style="text-align:right;">

ICSLAMALABA

</th>

<th style="text-align:right;">

Mild

</th>

<th style="text-align:right;">

Moderate

</th>

<th style="text-align:right;">

Severe

</th>

<th style="text-align:right;">

VerySevere

</th>

<th style="text-align:right;">

MildPY

</th>

<th style="text-align:right;">

ModeratePY

</th>

<th style="text-align:right;">

SeverePY

</th>

<th style="text-align:right;">

VerySeverePY

</th>

<th style="text-align:right;">

NoCOPD

</th>

<th style="text-align:right;">

GOLD1

</th>

<th style="text-align:right;">

GOLD2

</th>

<th style="text-align:right;">

GOLD3

</th>

<th style="text-align:right;">

GOLD4

</th>

<th style="text-align:right;">

Cost

</th>

<th style="text-align:right;">

CostpAgent

</th>

<th style="text-align:right;">

QALY

</th>

<th style="text-align:right;">

QALYpAgent

</th>

<th style="text-align:right;">

NMB

</th>

<th style="text-align:right;">

IncrementalCosts

</th>

<th style="text-align:right;">

IncrementalQALY

</th>

<th style="text-align:right;">

ICER

</th>

<th style="text-align:right;">

IncrementalNMB

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S1NoCD

</td>

<td style="text-align:right;">

7422.0

</td>

<td style="text-align:right;">

124882.9

</td>

<td style="text-align:right;">

14161.71

</td>

<td style="text-align:right;">

38067

</td>

<td style="text-align:right;">

2719.299

</td>

<td style="text-align:right;">

2638

</td>

<td style="text-align:right;">

0.018

</td>

<td style="text-align:right;">

0.143

</td>

<td style="text-align:right;">

0.157

</td>

<td style="text-align:right;">

0.084

</td>

<td style="text-align:right;">

2843.0

</td>

<td style="text-align:right;">

556.0

</td>

<td style="text-align:right;">

909.0

</td>

<td style="text-align:right;">

68.0

</td>

<td style="text-align:right;">

0.201

</td>

<td style="text-align:right;">

0.039

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

105266.0

</td>

<td style="text-align:right;">

5924

</td>

<td style="text-align:right;">

6009.0

</td>

<td style="text-align:right;">

1294

</td>

<td style="text-align:right;">

225.0

</td>

<td style="text-align:right;">

14378336

</td>

<td style="text-align:right;">

1937.259

</td>

<td style="text-align:right;">

93140.90

</td>

<td style="text-align:right;">

12.549

</td>

<td style="text-align:right;">

625527.7

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCD2

</td>

<td style="text-align:right;">

7407.0

</td>

<td style="text-align:right;">

124598.7

</td>

<td style="text-align:right;">

14132.87

</td>

<td style="text-align:right;">

24845

</td>

<td style="text-align:right;">

2458.745

</td>

<td style="text-align:right;">

3260

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.130

</td>

<td style="text-align:right;">

0.142

</td>

<td style="text-align:right;">

0.073

</td>

<td style="text-align:right;">

3208.0

</td>

<td style="text-align:right;">

573.0

</td>

<td style="text-align:right;">

950.0

</td>

<td style="text-align:right;">

73.0

</td>

<td style="text-align:right;">

0.227

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.067

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

104997.0

</td>

<td style="text-align:right;">

5476

</td>

<td style="text-align:right;">

6440.0

</td>

<td style="text-align:right;">

1328

</td>

<td style="text-align:right;">

208.0

</td>

<td style="text-align:right;">

14781463

</td>

<td style="text-align:right;">

1995.607

</td>

<td style="text-align:right;">

92864.88

</td>

<td style="text-align:right;">

12.537

</td>

<td style="text-align:right;">

624876.8

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCDAvg

</td>

<td style="text-align:right;">

7414.5

</td>

<td style="text-align:right;">

124740.8

</td>

<td style="text-align:right;">

14147.29

</td>

<td style="text-align:right;">

31456

</td>

<td style="text-align:right;">

2589.022

</td>

<td style="text-align:right;">

2949

</td>

<td style="text-align:right;">

0.019

</td>

<td style="text-align:right;">

0.136

</td>

<td style="text-align:right;">

0.149

</td>

<td style="text-align:right;">

0.078

</td>

<td style="text-align:right;">

3025.5

</td>

<td style="text-align:right;">

564.5

</td>

<td style="text-align:right;">

929.5

</td>

<td style="text-align:right;">

70.5

</td>

<td style="text-align:right;">

0.214

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.066

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

105131.5

</td>

<td style="text-align:right;">

5700

</td>

<td style="text-align:right;">

6224.5

</td>

<td style="text-align:right;">

1311

</td>

<td style="text-align:right;">

216.5

</td>

<td style="text-align:right;">

14579900

</td>

<td style="text-align:right;">

1966.404

</td>

<td style="text-align:right;">

93002.89

</td>

<td style="text-align:right;">

12.543

</td>

<td style="text-align:right;">

625202.3

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

7385.0

</td>

<td style="text-align:right;">

124459.3

</td>

<td style="text-align:right;">

13505.89

</td>

<td style="text-align:right;">

37095

</td>

<td style="text-align:right;">

6161.599

</td>

<td style="text-align:right;">

2720

</td>

<td style="text-align:right;">

0.027

</td>

<td style="text-align:right;">

0.141

</td>

<td style="text-align:right;">

0.293

</td>

<td style="text-align:right;">

0.084

</td>

<td style="text-align:right;">

3053.0

</td>

<td style="text-align:right;">

484.0

</td>

<td style="text-align:right;">

833.0

</td>

<td style="text-align:right;">

84.0

</td>

<td style="text-align:right;">

0.226

</td>

<td style="text-align:right;">

0.036

</td>

<td style="text-align:right;">

0.062

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

105515.0

</td>

<td style="text-align:right;">

5372

</td>

<td style="text-align:right;">

6007.0

</td>

<td style="text-align:right;">

1210

</td>

<td style="text-align:right;">

249.0

</td>

<td style="text-align:right;">

15827638

</td>

<td style="text-align:right;">

2143.214

</td>

<td style="text-align:right;">

92924.98

</td>

<td style="text-align:right;">

12.583

</td>

<td style="text-align:right;">

627003.5

</td>

<td style="text-align:right;">

205.955

</td>

<td style="text-align:right;">

0.034

</td>

<td style="text-align:right;">

6123.252

</td>

<td style="text-align:right;">

1475.793

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

7428.0

</td>

<td style="text-align:right;">

125237.2

</td>

<td style="text-align:right;">

14108.52

</td>

<td style="text-align:right;">

37674

</td>

<td style="text-align:right;">

4719.021

</td>

<td style="text-align:right;">

2775

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.144

</td>

<td style="text-align:right;">

0.232

</td>

<td style="text-align:right;">

0.084

</td>

<td style="text-align:right;">

2901.0

</td>

<td style="text-align:right;">

561.0

</td>

<td style="text-align:right;">

933.0

</td>

<td style="text-align:right;">

69.0

</td>

<td style="text-align:right;">

0.206

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.066

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

105655.0

</td>

<td style="text-align:right;">

5661

</td>

<td style="text-align:right;">

6209.0

</td>

<td style="text-align:right;">

1326

</td>

<td style="text-align:right;">

216.0

</td>

<td style="text-align:right;">

16003606

</td>

<td style="text-align:right;">

2154.497

</td>

<td style="text-align:right;">

93418.17

</td>

<td style="text-align:right;">

12.576

</td>

<td style="text-align:right;">

626670.0

</td>

<td style="text-align:right;">

217.238

</td>

<td style="text-align:right;">

0.027

</td>

<td style="text-align:right;">

7989.709

</td>

<td style="text-align:right;">

1142.250

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

7462.0

</td>

<td style="text-align:right;">

125340.7

</td>

<td style="text-align:right;">

14447.74

</td>

<td style="text-align:right;">

37893

</td>

<td style="text-align:right;">

3989.452

</td>

<td style="text-align:right;">

2678

</td>

<td style="text-align:right;">

0.020

</td>

<td style="text-align:right;">

0.141

</td>

<td style="text-align:right;">

0.204

</td>

<td style="text-align:right;">

0.082

</td>

<td style="text-align:right;">

3145.0

</td>

<td style="text-align:right;">

587.0

</td>

<td style="text-align:right;">

994.0

</td>

<td style="text-align:right;">

75.0

</td>

<td style="text-align:right;">

0.218

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.069

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

105400.0

</td>

<td style="text-align:right;">

5733

</td>

<td style="text-align:right;">

6365.0

</td>

<td style="text-align:right;">

1428

</td>

<td style="text-align:right;">

231.0

</td>

<td style="text-align:right;">

17074777

</td>

<td style="text-align:right;">

2288.231

</td>

<td style="text-align:right;">

93426.97

</td>

<td style="text-align:right;">

12.520

</td>

<td style="text-align:right;">

623730.0

</td>

<td style="text-align:right;">

350.972

</td>

<td style="text-align:right;">

\-0.029

</td>

<td style="text-align:right;">

\-12129.844

</td>

<td style="text-align:right;">

\-1797.700

</td>

</tr>

</tbody>

</table>

*Treatment rate:* SABA is expressed per all patient-years, LAMA,
LAMA/LABA, ICS/LAMA/LABA are per COPD patient-years *Exacerbations:*
Total exacerbations and rate per COPD patient-year: *GOLD Stage:*
Cumulative patient-years *Cost/QALY:* Total cost and QALYs *NMB:* Net
Monetary Benefit is calculated as QALY per patient-year \* Lamba - Cost
per patient-year

-----

## S2 Symptomatic patients scenario

Patients with symptoms at year 1 are eligible. The cost of case
detection is:

    ## Initializing the session

    ## [1] 0

<table>

<thead>

<tr>

<th style="text-align:right;">

None

</th>

<th style="text-align:right;">

FlowMeter

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

23.38

</td>

</tr>

</tbody>

</table>

#### S2NoCD: No Case detection

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S2a: Screening Spirometry without BD

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

<table>

<thead>

<tr>

<th style="text-align:left;">

Scenario

</th>

<th style="text-align:right;">

Agents

</th>

<th style="text-align:right;">

PatientYears

</th>

<th style="text-align:right;">

CopdPYs

</th>

<th style="text-align:right;">

NCaseDetections

</th>

<th style="text-align:right;">

DiagnosedPYs

</th>

<th style="text-align:right;">

OverdiagnosedPYs

</th>

<th style="text-align:right;">

SABA

</th>

<th style="text-align:right;">

LAMA

</th>

<th style="text-align:right;">

LAMALABA

</th>

<th style="text-align:right;">

ICSLAMALABA

</th>

<th style="text-align:right;">

Mild

</th>

<th style="text-align:right;">

Moderate

</th>

<th style="text-align:right;">

Severe

</th>

<th style="text-align:right;">

VerySevere

</th>

<th style="text-align:right;">

MildPY

</th>

<th style="text-align:right;">

ModeratePY

</th>

<th style="text-align:right;">

SeverePY

</th>

<th style="text-align:right;">

VerySeverePY

</th>

<th style="text-align:right;">

NoCOPD

</th>

<th style="text-align:right;">

GOLD1

</th>

<th style="text-align:right;">

GOLD2

</th>

<th style="text-align:right;">

GOLD3

</th>

<th style="text-align:right;">

GOLD4

</th>

<th style="text-align:right;">

Cost

</th>

<th style="text-align:right;">

CostpAgent

</th>

<th style="text-align:right;">

QALY

</th>

<th style="text-align:right;">

QALYpAgent

</th>

<th style="text-align:right;">

NMB

</th>

<th style="text-align:right;">

IncrementalCosts

</th>

<th style="text-align:right;">

IncrementalQALY

</th>

<th style="text-align:right;">

ICER

</th>

<th style="text-align:right;">

IncrementalNMB

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

4413

</td>

<td style="text-align:right;">

72738.97

</td>

<td style="text-align:right;">

10261.551

</td>

<td style="text-align:right;">

22163

</td>

<td style="text-align:right;">

1920.269

</td>

<td style="text-align:right;">

1492

</td>

<td style="text-align:right;">

0.016

</td>

<td style="text-align:right;">

0.141

</td>

<td style="text-align:right;">

0.164

</td>

<td style="text-align:right;">

0.082

</td>

<td style="text-align:right;">

2338

</td>

<td style="text-align:right;">

388

</td>

<td style="text-align:right;">

683

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

0.228

</td>

<td style="text-align:right;">

0.038

</td>

<td style="text-align:right;">

0.067

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

59397

</td>

<td style="text-align:right;">

3611

</td>

<td style="text-align:right;">

4832

</td>

<td style="text-align:right;">

1080

</td>

<td style="text-align:right;">

233

</td>

<td style="text-align:right;">

10892652

</td>

<td style="text-align:right;">

2468.310

</td>

<td style="text-align:right;">

54028.51

</td>

<td style="text-align:right;">

12.243

</td>

<td style="text-align:right;">

609683.4

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

4417

</td>

<td style="text-align:right;">

72800.13

</td>

<td style="text-align:right;">

9781.133

</td>

<td style="text-align:right;">

21765

</td>

<td style="text-align:right;">

3568.709

</td>

<td style="text-align:right;">

1608

</td>

<td style="text-align:right;">

0.024

</td>

<td style="text-align:right;">

0.151

</td>

<td style="text-align:right;">

0.269

</td>

<td style="text-align:right;">

0.095

</td>

<td style="text-align:right;">

2054

</td>

<td style="text-align:right;">

388

</td>

<td style="text-align:right;">

638

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

0.210

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.065

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

59877

</td>

<td style="text-align:right;">

3703

</td>

<td style="text-align:right;">

4393

</td>

<td style="text-align:right;">

1111

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

11246791

</td>

<td style="text-align:right;">

2546.251

</td>

<td style="text-align:right;">

54193.76

</td>

<td style="text-align:right;">

12.269

</td>

<td style="text-align:right;">

610921.7

</td>

<td style="text-align:right;">

77.941

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

2960.824

</td>

<td style="text-align:right;">

1238.265

</td>

</tr>

</tbody>

</table>

*Treatment rate:* SABA is expressed per all patient-years, LAMA,
LAMA/LABA, ICS/LAMA/LABA are per COPD patient-years *Exacerbations:*
Total exacerbations and rate per COPD patient-year: *GOLD Stage:*
Cumulative patient-years *Cost/QALY:* Total cost and QALYs *NMB:* Net
Monetary Benefit is calculated as QALY per patient-year \* Lamba - Cost
per patient-year

-----

## S3 Smoking history scenario

Ever smokers ≥50 years of age are eligible. The cost of case detection
is:

    ## Initializing the session

    ## [1] 0

<table>

<thead>

<tr>

<th style="text-align:right;">

None

</th>

<th style="text-align:right;">

CDQ195

</th>

<th style="text-align:right;">

CDQ165

</th>

<th style="text-align:right;">

FlowMeter

</th>

<th style="text-align:right;">

FlowMeter\_CDQ

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11.1

</td>

<td style="text-align:right;">

11.1

</td>

<td style="text-align:right;">

23.38

</td>

<td style="text-align:right;">

40.37

</td>

</tr>

</tbody>

</table>

#### S3NoCD: No Case detection

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S3a: CDQ ≥19.5 points

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S3b: CDQ ≥16.5 points

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S3c: Screening spirometry without BD

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S3d: Screening Spirometry with BD + CDQ ≥17 points

    ## Initializing the session

    ## [1] 0

    ## [1] 0

    ## Terminating the session

    ## [1] 0

<table>

<thead>

<tr>

<th style="text-align:left;">

Scenario

</th>

<th style="text-align:right;">

Agents

</th>

<th style="text-align:right;">

PatientYears

</th>

<th style="text-align:right;">

CopdPYs

</th>

<th style="text-align:right;">

NCaseDetections

</th>

<th style="text-align:right;">

DiagnosedPYs

</th>

<th style="text-align:right;">

OverdiagnosedPYs

</th>

<th style="text-align:right;">

SABA

</th>

<th style="text-align:right;">

LAMA

</th>

<th style="text-align:right;">

LAMALABA

</th>

<th style="text-align:right;">

ICSLAMALABA

</th>

<th style="text-align:right;">

Mild

</th>

<th style="text-align:right;">

Moderate

</th>

<th style="text-align:right;">

Severe

</th>

<th style="text-align:right;">

VerySevere

</th>

<th style="text-align:right;">

MildPY

</th>

<th style="text-align:right;">

ModeratePY

</th>

<th style="text-align:right;">

SeverePY

</th>

<th style="text-align:right;">

VerySeverePY

</th>

<th style="text-align:right;">

NoCOPD

</th>

<th style="text-align:right;">

GOLD1

</th>

<th style="text-align:right;">

GOLD2

</th>

<th style="text-align:right;">

GOLD3

</th>

<th style="text-align:right;">

GOLD4

</th>

<th style="text-align:right;">

Cost

</th>

<th style="text-align:right;">

CostpAgent

</th>

<th style="text-align:right;">

QALY

</th>

<th style="text-align:right;">

QALYpAgent

</th>

<th style="text-align:right;">

NMB

</th>

<th style="text-align:right;">

IncrementalCosts

</th>

<th style="text-align:right;">

IncrementalQALY

</th>

<th style="text-align:right;">

ICER

</th>

<th style="text-align:right;">

IncrementalNMB

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

3528

</td>

<td style="text-align:right;">

53725.50

</td>

<td style="text-align:right;">

7906.149

</td>

<td style="text-align:right;">

16598

</td>

<td style="text-align:right;">

1297.364

</td>

<td style="text-align:right;">

1217

</td>

<td style="text-align:right;">

0.020

</td>

<td style="text-align:right;">

0.113

</td>

<td style="text-align:right;">

0.130

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

1745

</td>

<td style="text-align:right;">

348

</td>

<td style="text-align:right;">

489

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

0.221

</td>

<td style="text-align:right;">

0.044

</td>

<td style="text-align:right;">

0.062

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

43542

</td>

<td style="text-align:right;">

2950

</td>

<td style="text-align:right;">

3553

</td>

<td style="text-align:right;">

821

</td>

<td style="text-align:right;">

196

</td>

<td style="text-align:right;">

8045240

</td>

<td style="text-align:right;">

2280.397

</td>

<td style="text-align:right;">

40070.76

</td>

<td style="text-align:right;">

11.358

</td>

<td style="text-align:right;">

565615.9

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

3474

</td>

<td style="text-align:right;">

52479.52

</td>

<td style="text-align:right;">

8098.944

</td>

<td style="text-align:right;">

15976

</td>

<td style="text-align:right;">

2248.428

</td>

<td style="text-align:right;">

1190

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.171

</td>

<td style="text-align:right;">

0.232

</td>

<td style="text-align:right;">

0.106

</td>

<td style="text-align:right;">

1737

</td>

<td style="text-align:right;">

333

</td>

<td style="text-align:right;">

655

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

0.214

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.081

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

42187

</td>

<td style="text-align:right;">

3110

</td>

<td style="text-align:right;">

3388

</td>

<td style="text-align:right;">

1022

</td>

<td style="text-align:right;">

189

</td>

<td style="text-align:right;">

10496851

</td>

<td style="text-align:right;">

3021.546

</td>

<td style="text-align:right;">

39130.13

</td>

<td style="text-align:right;">

11.264

</td>

<td style="text-align:right;">

560163.9

</td>

<td style="text-align:right;">

741.149

</td>

<td style="text-align:right;">

\-0.094

</td>

<td style="text-align:right;">

\-7866.470

</td>

<td style="text-align:right;">

\-5451.961

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

3501

</td>

<td style="text-align:right;">

52987.25

</td>

<td style="text-align:right;">

8492.170

</td>

<td style="text-align:right;">

15876

</td>

<td style="text-align:right;">

3486.523

</td>

<td style="text-align:right;">

1164

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

0.151

</td>

<td style="text-align:right;">

0.291

</td>

<td style="text-align:right;">

0.091

</td>

<td style="text-align:right;">

2114

</td>

<td style="text-align:right;">

397

</td>

<td style="text-align:right;">

633

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

0.249

</td>

<td style="text-align:right;">

0.047

</td>

<td style="text-align:right;">

0.075

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

42289

</td>

<td style="text-align:right;">

2970

</td>

<td style="text-align:right;">

3890

</td>

<td style="text-align:right;">

1006

</td>

<td style="text-align:right;">

205

</td>

<td style="text-align:right;">

10778310

</td>

<td style="text-align:right;">

3078.638

</td>

<td style="text-align:right;">

39484.69

</td>

<td style="text-align:right;">

11.278

</td>

<td style="text-align:right;">

560827.2

</td>

<td style="text-align:right;">

798.241

</td>

<td style="text-align:right;">

\-0.080

</td>

<td style="text-align:right;">

\-10001.932

</td>

<td style="text-align:right;">

\-4788.674

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

3491

</td>

<td style="text-align:right;">

52736.72

</td>

<td style="text-align:right;">

8514.806

</td>

<td style="text-align:right;">

15879

</td>

<td style="text-align:right;">

3011.065

</td>

<td style="text-align:right;">

1071

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.146

</td>

<td style="text-align:right;">

0.258

</td>

<td style="text-align:right;">

0.089

</td>

<td style="text-align:right;">

2005

</td>

<td style="text-align:right;">

346

</td>

<td style="text-align:right;">

605

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

0.235

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.071

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

41983

</td>

<td style="text-align:right;">

3318

</td>

<td style="text-align:right;">

3540

</td>

<td style="text-align:right;">

980

</td>

<td style="text-align:right;">

278

</td>

<td style="text-align:right;">

10422378

</td>

<td style="text-align:right;">

2985.499

</td>

<td style="text-align:right;">

39303.07

</td>

<td style="text-align:right;">

11.258

</td>

<td style="text-align:right;">

559934.4

</td>

<td style="text-align:right;">

705.102

</td>

<td style="text-align:right;">

\-0.100

</td>

<td style="text-align:right;">

\-7084.417

</td>

<td style="text-align:right;">

\-5681.535

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

3467

</td>

<td style="text-align:right;">

53288.35

</td>

<td style="text-align:right;">

8790.045

</td>

<td style="text-align:right;">

16069

</td>

<td style="text-align:right;">

2726.934

</td>

<td style="text-align:right;">

1228

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.155

</td>

<td style="text-align:right;">

0.228

</td>

<td style="text-align:right;">

0.101

</td>

<td style="text-align:right;">

2129

</td>

<td style="text-align:right;">

354

</td>

<td style="text-align:right;">

628

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

0.242

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.071

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

42287

</td>

<td style="text-align:right;">

3232

</td>

<td style="text-align:right;">

3810

</td>

<td style="text-align:right;">

1112

</td>

<td style="text-align:right;">

194

</td>

<td style="text-align:right;">

10772974

</td>

<td style="text-align:right;">

3107.290

</td>

<td style="text-align:right;">

39636.58

</td>

<td style="text-align:right;">

11.433

</td>

<td style="text-align:right;">

568519.3

</td>

<td style="text-align:right;">

826.893

</td>

<td style="text-align:right;">

0.075

</td>

<td style="text-align:right;">

11083.581

</td>

<td style="text-align:right;">

2903.368

</td>

</tr>

</tbody>

</table>

*Treatment rate:* SABA is expressed per all patient-years, LAMA,
LAMA/LABA, ICS/LAMA/LABA are per COPD patient-years *Exacerbations:*
Total exacerbations and rate per COPD patient-year *GOLD Stage:*
Cumulative patient-years *Cost/QALY:* Total cost and QALYs *NMB:* Net
Monetary Benefit is calculated as QALY per patient-year \* Lamba - Cost
per patient-year

-----

## All Scenarios

*Ordered by descending Net Monetary Benefit*

<table>

<thead>

<tr>

<th style="text-align:left;">

Scenario

</th>

<th style="text-align:right;">

Agents

</th>

<th style="text-align:right;">

Cost

</th>

<th style="text-align:right;">

CostpAgent

</th>

<th style="text-align:right;">

QALY

</th>

<th style="text-align:right;">

QALYpAgent

</th>

<th style="text-align:right;">

ICER

</th>

<th style="text-align:right;">

IncrementalNMB

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

3467

</td>

<td style="text-align:right;">

10772974

</td>

<td style="text-align:right;">

3107.290

</td>

<td style="text-align:right;">

39636.58

</td>

<td style="text-align:right;">

11.433

</td>

<td style="text-align:right;">

11083.581

</td>

<td style="text-align:right;">

2903.368

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

7385

</td>

<td style="text-align:right;">

15827638

</td>

<td style="text-align:right;">

2143.214

</td>

<td style="text-align:right;">

92924.98

</td>

<td style="text-align:right;">

12.583

</td>

<td style="text-align:right;">

6123.252

</td>

<td style="text-align:right;">

1475.793

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

4417

</td>

<td style="text-align:right;">

11246791

</td>

<td style="text-align:right;">

2546.251

</td>

<td style="text-align:right;">

54193.76

</td>

<td style="text-align:right;">

12.269

</td>

<td style="text-align:right;">

2960.824

</td>

<td style="text-align:right;">

1238.265

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

7428

</td>

<td style="text-align:right;">

16003606

</td>

<td style="text-align:right;">

2154.497

</td>

<td style="text-align:right;">

93418.17

</td>

<td style="text-align:right;">

12.576

</td>

<td style="text-align:right;">

7989.709

</td>

<td style="text-align:right;">

1142.250

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCD

</td>

<td style="text-align:right;">

7422

</td>

<td style="text-align:right;">

14378336

</td>

<td style="text-align:right;">

1937.259

</td>

<td style="text-align:right;">

93140.90

</td>

<td style="text-align:right;">

12.549

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

4413

</td>

<td style="text-align:right;">

10892652

</td>

<td style="text-align:right;">

2468.310

</td>

<td style="text-align:right;">

54028.51

</td>

<td style="text-align:right;">

12.243

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

3528

</td>

<td style="text-align:right;">

8045240

</td>

<td style="text-align:right;">

2280.397

</td>

<td style="text-align:right;">

40070.76

</td>

<td style="text-align:right;">

11.358

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

7462

</td>

<td style="text-align:right;">

17074777

</td>

<td style="text-align:right;">

2288.231

</td>

<td style="text-align:right;">

93426.97

</td>

<td style="text-align:right;">

12.520

</td>

<td style="text-align:right;">

\-12129.844

</td>

<td style="text-align:right;">

\-1797.700

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

3501

</td>

<td style="text-align:right;">

10778310

</td>

<td style="text-align:right;">

3078.638

</td>

<td style="text-align:right;">

39484.69

</td>

<td style="text-align:right;">

11.278

</td>

<td style="text-align:right;">

\-10001.932

</td>

<td style="text-align:right;">

\-4788.674

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

3474

</td>

<td style="text-align:right;">

10496851

</td>

<td style="text-align:right;">

3021.546

</td>

<td style="text-align:right;">

39130.13

</td>

<td style="text-align:right;">

11.264

</td>

<td style="text-align:right;">

\-7866.470

</td>

<td style="text-align:right;">

\-5451.961

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

3491

</td>

<td style="text-align:right;">

10422378

</td>

<td style="text-align:right;">

2985.499

</td>

<td style="text-align:right;">

39303.07

</td>

<td style="text-align:right;">

11.258

</td>

<td style="text-align:right;">

\-7084.417

</td>

<td style="text-align:right;">

\-5681.535

</td>

</tr>

</tbody>

</table>

-----

## Cost Effectiveness Plane

Adjusted to the total population

<table>

<thead>

<tr>

<th style="text-align:left;">

Scenario

</th>

<th style="text-align:right;">

Agents

</th>

<th style="text-align:right;">

PropAgents

</th>

<th style="text-align:right;">

Cost

</th>

<th style="text-align:right;">

CostpAgent

</th>

<th style="text-align:right;">

CostpAgentExcluded

</th>

<th style="text-align:right;">

CostpAgentAll

</th>

<th style="text-align:right;">

QALY

</th>

<th style="text-align:right;">

QALYpAgent

</th>

<th style="text-align:right;">

QALYpAgentExcluded

</th>

<th style="text-align:right;">

QALYpAgentAll

</th>

<th style="text-align:right;">

IncrementalCosts

</th>

<th style="text-align:right;">

IncrementalQALY

</th>

<th style="text-align:right;">

ICERAdj

</th>

<th style="text-align:right;">

ICER

</th>

<th style="text-align:right;">

INMB

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S1NoCDAvg

</td>

<td style="text-align:right;">

7414.5

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

14579900

</td>

<td style="text-align:right;">

1966.404

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

1966.404

</td>

<td style="text-align:right;">

93002.89

</td>

<td style="text-align:right;">

12.54338

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.54338

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

7385.0

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

15827638

</td>

<td style="text-align:right;">

2143.214

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2143.214

</td>

<td style="text-align:right;">

92924.97

</td>

<td style="text-align:right;">

12.58294

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.58294

</td>

<td style="text-align:right;">

176.8107

</td>

<td style="text-align:right;">

0.0395551

</td>

<td style="text-align:right;">

4469.982

</td>

<td style="text-align:right;">

6123.252

</td>

<td style="text-align:right;">

1800.946

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

7428.0

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

16003606

</td>

<td style="text-align:right;">

2154.497

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2154.497

</td>

<td style="text-align:right;">

93418.17

</td>

<td style="text-align:right;">

12.57649

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.57649

</td>

<td style="text-align:right;">

188.0937

</td>

<td style="text-align:right;">

0.0331099

</td>

<td style="text-align:right;">

5680.883

</td>

<td style="text-align:right;">

7989.709

</td>

<td style="text-align:right;">

1467.403

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

7462.0

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

17074777

</td>

<td style="text-align:right;">

2288.231

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2288.231

</td>

<td style="text-align:right;">

93426.97

</td>

<td style="text-align:right;">

12.52037

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.52037

</td>

<td style="text-align:right;">

321.8270

</td>

<td style="text-align:right;">

\-0.0230144

</td>

<td style="text-align:right;">

\-13983.730

</td>

<td style="text-align:right;">

\-12129.844

</td>

<td style="text-align:right;">

\-1472.547

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

4413.0

</td>

<td style="text-align:right;">

0.5951851

</td>

<td style="text-align:right;">

10892652

</td>

<td style="text-align:right;">

2468.310

</td>

<td style="text-align:right;">

1228.468

</td>

<td style="text-align:right;">

1966.404

</td>

<td style="text-align:right;">

54028.51

</td>

<td style="text-align:right;">

12.24304

</td>

<td style="text-align:right;">

12.98497

</td>

<td style="text-align:right;">

12.54338

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

4417.0

</td>

<td style="text-align:right;">

0.5957246

</td>

<td style="text-align:right;">

11246791

</td>

<td style="text-align:right;">

2546.251

</td>

<td style="text-align:right;">

1228.468

</td>

<td style="text-align:right;">

2013.504

</td>

<td style="text-align:right;">

54193.76

</td>

<td style="text-align:right;">

12.26936

</td>

<td style="text-align:right;">

12.98497

</td>

<td style="text-align:right;">

12.55866

</td>

<td style="text-align:right;">

47.1003

</td>

<td style="text-align:right;">

0.0152817

</td>

<td style="text-align:right;">

3082.145

</td>

<td style="text-align:right;">

2960.824

</td>

<td style="text-align:right;">

716.983

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

3528.0

</td>

<td style="text-align:right;">

0.4758244

</td>

<td style="text-align:right;">

8045240

</td>

<td style="text-align:right;">

2280.397

</td>

<td style="text-align:right;">

1681.374

</td>

<td style="text-align:right;">

1966.404

</td>

<td style="text-align:right;">

40070.76

</td>

<td style="text-align:right;">

11.35793

</td>

<td style="text-align:right;">

13.61948

</td>

<td style="text-align:right;">

12.54338

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

NaN

</td>

<td style="text-align:right;">

0.000

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

3474.0

</td>

<td style="text-align:right;">

0.4685414

</td>

<td style="text-align:right;">

10496851

</td>

<td style="text-align:right;">

3021.546

</td>

<td style="text-align:right;">

1681.374

</td>

<td style="text-align:right;">

2309.300

</td>

<td style="text-align:right;">

39130.13

</td>

<td style="text-align:right;">

11.26371

</td>

<td style="text-align:right;">

13.61948

</td>

<td style="text-align:right;">

12.51571

</td>

<td style="text-align:right;">

342.8964

</td>

<td style="text-align:right;">

\-0.0276732

</td>

<td style="text-align:right;">

\-12390.914

</td>

<td style="text-align:right;">

\-7866.470

</td>

<td style="text-align:right;">

\-1726.557

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

3501.0

</td>

<td style="text-align:right;">

0.4721829

</td>

<td style="text-align:right;">

10778310

</td>

<td style="text-align:right;">

3078.638

</td>

<td style="text-align:right;">

1681.374

</td>

<td style="text-align:right;">

2341.138

</td>

<td style="text-align:right;">

39484.69

</td>

<td style="text-align:right;">

11.27812

</td>

<td style="text-align:right;">

13.61948

</td>

<td style="text-align:right;">

12.51393

</td>

<td style="text-align:right;">

374.7343

</td>

<td style="text-align:right;">

\-0.0294488

</td>

<td style="text-align:right;">

\-12724.949

</td>

<td style="text-align:right;">

\-10001.932

</td>

<td style="text-align:right;">

\-1847.174

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

3491.0

</td>

<td style="text-align:right;">

0.4708342

</td>

<td style="text-align:right;">

10422378

</td>

<td style="text-align:right;">

2985.499

</td>

<td style="text-align:right;">

1681.374

</td>

<td style="text-align:right;">

2295.401

</td>

<td style="text-align:right;">

39303.06

</td>

<td style="text-align:right;">

11.25840

</td>

<td style="text-align:right;">

13.61948

</td>

<td style="text-align:right;">

12.50780

</td>

<td style="text-align:right;">

328.9971

</td>

<td style="text-align:right;">

\-0.0355758

</td>

<td style="text-align:right;">

\-9247.774

</td>

<td style="text-align:right;">

\-7084.417

</td>

<td style="text-align:right;">

\-2107.788

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

3467.0

</td>

<td style="text-align:right;">

0.4675973

</td>

<td style="text-align:right;">

10772974

</td>

<td style="text-align:right;">

3107.290

</td>

<td style="text-align:right;">

1681.374

</td>

<td style="text-align:right;">

2348.128

</td>

<td style="text-align:right;">

39636.59

</td>

<td style="text-align:right;">

11.43253

</td>

<td style="text-align:right;">

13.61948

</td>

<td style="text-align:right;">

12.59687

</td>

<td style="text-align:right;">

381.7247

</td>

<td style="text-align:right;">

0.0534913

</td>

<td style="text-align:right;">

7136.199

</td>

<td style="text-align:right;">

11083.581

</td>

<td style="text-align:right;">

2292.841

</td>

</tr>

</tbody>

</table>

![](Case_Detection_Results_files/figure-gfm/CEplot-1.png)<!-- -->

## Clinical Results for all scenarios

Adjusted to the total population

<table>

<thead>

<tr>

<th style="text-align:left;">

Scenario

</th>

<th style="text-align:right;">

PropAgents

</th>

<th style="text-align:right;">

ProppPatientYears

</th>

<th style="text-align:right;">

ProppCopdPYs

</th>

<th style="text-align:right;">

SABAAll

</th>

<th style="text-align:right;">

LAMAAll

</th>

<th style="text-align:right;">

LAMALABAAll

</th>

<th style="text-align:right;">

ICSLAMALABAAll

</th>

<th style="text-align:right;">

MildpAgentAll

</th>

<th style="text-align:right;">

ModeratepAgentAll

</th>

<th style="text-align:right;">

SeverepAgentAll

</th>

<th style="text-align:right;">

VerySeverepAgentAll

</th>

<th style="text-align:right;">

NoCOPDpPYAll

</th>

<th style="text-align:right;">

GOLD1pPYAll

</th>

<th style="text-align:right;">

GOLD2pPYAll

</th>

<th style="text-align:right;">

GOLD3pPYAll

</th>

<th style="text-align:right;">

GOLD4pPYAll

</th>

<th style="text-align:right;">

DiagnosedpPYAll

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S1NoCDAvg

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

0.0193034

</td>

<td style="text-align:right;">

0.1363352

</td>

<td style="text-align:right;">

0.1494531

</td>

<td style="text-align:right;">

0.0784670

</td>

<td style="text-align:right;">

0.4080518

</td>

<td style="text-align:right;">

0.0761346

</td>

<td style="text-align:right;">

0.1253625

</td>

<td style="text-align:right;">

0.0095084

</td>

<td style="text-align:right;">

0.8427999

</td>

<td style="text-align:right;">

0.0456948

</td>

<td style="text-align:right;">

0.0498995

</td>

<td style="text-align:right;">

0.0105098

</td>

<td style="text-align:right;">

0.0017356

</td>

<td style="text-align:right;">

0.1830048

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

0.0269991

</td>

<td style="text-align:right;">

0.1406778

</td>

<td style="text-align:right;">

0.2929580

</td>

<td style="text-align:right;">

0.0837425

</td>

<td style="text-align:right;">

0.4134056

</td>

<td style="text-align:right;">

0.0655383

</td>

<td style="text-align:right;">

0.1127962

</td>

<td style="text-align:right;">

0.0113744

</td>

<td style="text-align:right;">

0.8477872

</td>

<td style="text-align:right;">

0.0431627

</td>

<td style="text-align:right;">

0.0482648

</td>

<td style="text-align:right;">

0.0097221

</td>

<td style="text-align:right;">

0.0020007

</td>

<td style="text-align:right;">

0.4562158

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

0.0231050

</td>

<td style="text-align:right;">

0.1443512

</td>

<td style="text-align:right;">

0.2323783

</td>

<td style="text-align:right;">

0.0840283

</td>

<td style="text-align:right;">

0.3905493

</td>

<td style="text-align:right;">

0.0755250

</td>

<td style="text-align:right;">

0.1256058

</td>

<td style="text-align:right;">

0.0092892

</td>

<td style="text-align:right;">

0.8436394

</td>

<td style="text-align:right;">

0.0452022

</td>

<td style="text-align:right;">

0.0495779

</td>

<td style="text-align:right;">

0.0105879

</td>

<td style="text-align:right;">

0.0017247

</td>

<td style="text-align:right;">

0.3344802

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

0.0199604

</td>

<td style="text-align:right;">

0.1406766

</td>

<td style="text-align:right;">

0.2040456

</td>

<td style="text-align:right;">

0.0822301

</td>

<td style="text-align:right;">

0.4214688

</td>

<td style="text-align:right;">

0.0786652

</td>

<td style="text-align:right;">

0.1332083

</td>

<td style="text-align:right;">

0.0100509

</td>

<td style="text-align:right;">

0.8409080

</td>

<td style="text-align:right;">

0.0457393

</td>

<td style="text-align:right;">

0.0507816

</td>

<td style="text-align:right;">

0.0113929

</td>

<td style="text-align:right;">

0.0018430

</td>

<td style="text-align:right;">

0.2761299

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

0.5951851

</td>

<td style="text-align:right;">

0.5831211

</td>

<td style="text-align:right;">

0.7253369

</td>

<td style="text-align:right;">

0.0193034

</td>

<td style="text-align:right;">

0.1363352

</td>

<td style="text-align:right;">

0.1494531

</td>

<td style="text-align:right;">

0.0784670

</td>

<td style="text-align:right;">

0.4080518

</td>

<td style="text-align:right;">

0.0761346

</td>

<td style="text-align:right;">

0.1253625

</td>

<td style="text-align:right;">

0.0095084

</td>

<td style="text-align:right;">

0.8427999

</td>

<td style="text-align:right;">

0.0456948

</td>

<td style="text-align:right;">

0.0498995

</td>

<td style="text-align:right;">

0.0105098

</td>

<td style="text-align:right;">

0.0017356

</td>

<td style="text-align:right;">

0.1830048

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

0.5957246

</td>

<td style="text-align:right;">

0.5836114

</td>

<td style="text-align:right;">

0.6913786

</td>

<td style="text-align:right;">

0.0241682

</td>

<td style="text-align:right;">

0.1425639

</td>

<td style="text-align:right;">

0.2205861

</td>

<td style="text-align:right;">

0.0874839

</td>

<td style="text-align:right;">

0.3696249

</td>

<td style="text-align:right;">

0.0761029

</td>

<td style="text-align:right;">

0.1192490

</td>

<td style="text-align:right;">

0.0091010

</td>

<td style="text-align:right;">

0.8462167

</td>

<td style="text-align:right;">

0.0464126

</td>

<td style="text-align:right;">

0.0463671

</td>

<td style="text-align:right;">

0.0107561

</td>

<td style="text-align:right;">

0.0006054

</td>

<td style="text-align:right;">

0.3053690

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

0.4758244

</td>

<td style="text-align:right;">

0.4306972

</td>

<td style="text-align:right;">

0.5588455

</td>

<td style="text-align:right;">

0.0193034

</td>

<td style="text-align:right;">

0.1363352

</td>

<td style="text-align:right;">

0.1494531

</td>

<td style="text-align:right;">

0.0784670

</td>

<td style="text-align:right;">

0.4080518

</td>

<td style="text-align:right;">

0.0761346

</td>

<td style="text-align:right;">

0.1253625

</td>

<td style="text-align:right;">

0.0095084

</td>

<td style="text-align:right;">

0.8427999

</td>

<td style="text-align:right;">

0.0456948

</td>

<td style="text-align:right;">

0.0498995

</td>

<td style="text-align:right;">

0.0105098

</td>

<td style="text-align:right;">

0.0017356

</td>

<td style="text-align:right;">

0.1830048

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

0.4685414

</td>

<td style="text-align:right;">

0.4207087

</td>

<td style="text-align:right;">

0.5724732

</td>

<td style="text-align:right;">

0.0195632

</td>

<td style="text-align:right;">

0.1687639

</td>

<td style="text-align:right;">

0.2072341

</td>

<td style="text-align:right;">

0.0977323

</td>

<td style="text-align:right;">

0.4093724

</td>

<td style="text-align:right;">

0.0745172

</td>

<td style="text-align:right;">

0.1485765

</td>

<td style="text-align:right;">

0.0100957

</td>

<td style="text-align:right;">

0.8406001

</td>

<td style="text-align:right;">

0.0473642

</td>

<td style="text-align:right;">

0.0489525

</td>

<td style="text-align:right;">

0.0121901

</td>

<td style="text-align:right;">

0.0016824

</td>

<td style="text-align:right;">

0.2474103

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

0.4721829

</td>

<td style="text-align:right;">

0.4247790

</td>

<td style="text-align:right;">

0.6002684

</td>

<td style="text-align:right;">

0.0218323

</td>

<td style="text-align:right;">

0.1571630

</td>

<td style="text-align:right;">

0.2438750

</td>

<td style="text-align:right;">

0.0896093

</td>

<td style="text-align:right;">

0.4590189

</td>

<td style="text-align:right;">

0.0829461

</td>

<td style="text-align:right;">

0.1451966

</td>

<td style="text-align:right;">

0.0096672

</td>

<td style="text-align:right;">

0.8378878

</td>

<td style="text-align:right;">

0.0460843

</td>

<td style="text-align:right;">

0.0528237

</td>

<td style="text-align:right;">

0.0120337

</td>

<td style="text-align:right;">

0.0018095

</td>

<td style="text-align:right;">

0.3291726

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

0.4708342

</td>

<td style="text-align:right;">

0.4227706

</td>

<td style="text-align:right;">

0.6018684

</td>

<td style="text-align:right;">

0.0205348

</td>

<td style="text-align:right;">

0.1540775

</td>

<td style="text-align:right;">

0.2244337

</td>

<td style="text-align:right;">

0.0880171

</td>

<td style="text-align:right;">

0.4447624

</td>

<td style="text-align:right;">

0.0761428

</td>

<td style="text-align:right;">

0.1415731

</td>

<td style="text-align:right;">

0.0108898

</td>

<td style="text-align:right;">

0.8371765

</td>

<td style="text-align:right;">

0.0489518

</td>

<td style="text-align:right;">

0.0500935

</td>

<td style="text-align:right;">

0.0118391

</td>

<td style="text-align:right;">

0.0023953

</td>

<td style="text-align:right;">

0.2952337

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

0.4675973

</td>

<td style="text-align:right;">

0.4271928

</td>

<td style="text-align:right;">

0.6213236

</td>

<td style="text-align:right;">

0.0207510

</td>

<td style="text-align:right;">

0.1590920

</td>

<td style="text-align:right;">

0.2071330

</td>

<td style="text-align:right;">

0.0958925

</td>

<td style="text-align:right;">

0.4625528

</td>

<td style="text-align:right;">

0.0774021

</td>

<td style="text-align:right;">

0.1450420

</td>

<td style="text-align:right;">

0.0105065

</td>

<td style="text-align:right;">

0.8357784

</td>

<td style="text-align:right;">

0.0480912

</td>

<td style="text-align:right;">

0.0520916

</td>

<td style="text-align:right;">

0.0128668

</td>

<td style="text-align:right;">

0.0017206

</td>

<td style="text-align:right;">

0.2711235

</td>

</tr>

</tbody>

</table>
