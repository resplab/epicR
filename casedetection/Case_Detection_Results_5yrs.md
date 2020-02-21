Case Detection Scenario Main Analysis
================
20 February, 2020

    ## Initializing the session

    ## [1] 0

**Global inputs:**

  - Medication adherence is 0.7
  - Smoking adherence is 0.7
  - Cost discounting: 0.015
  - QALY discounting: 0.015
  - Time horizon: 20
  - The WTP threshold for NMB is 50000

**Case detection inputs:**

  - Case detection occurs at 5 year intervals.
  - An outpatient diagnosis costs 61.18
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

11.56

</td>

<td style="text-align:right;">

30.46

</td>

<td style="text-align:right;">

42.01

</td>

</tr>

</tbody>

</table>

#### S1NoCD2: No Case detection- Other time interval

    ## [1] 0

    ## Terminating the session

    ## [1] 0

#### S1NoCD: No Case detection

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

S1NoCD2

</td>

<td style="text-align:right;">

74381

</td>

<td style="text-align:right;">

1249214

</td>

<td style="text-align:right;">

142295.3

</td>

<td style="text-align:right;">

380963

</td>

<td style="text-align:right;">

26864.41

</td>

<td style="text-align:right;">

26471.0

</td>

<td style="text-align:right;">

0.017

</td>

<td style="text-align:right;">

0.137

</td>

<td style="text-align:right;">

0.154

</td>

<td style="text-align:right;">

0.082

</td>

<td style="text-align:right;">

31103

</td>

<td style="text-align:right;">

5842

</td>

<td style="text-align:right;">

9767.0

</td>

<td style="text-align:right;">

834.0

</td>

<td style="text-align:right;">

0.219

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.069

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

1052277

</td>

<td style="text-align:right;">

57448

</td>

<td style="text-align:right;">

61706

</td>

<td style="text-align:right;">

13678

</td>

<td style="text-align:right;">

2491

</td>

<td style="text-align:right;">

160700373

</td>

<td style="text-align:right;">

2160.503

</td>

<td style="text-align:right;">

931258.3

</td>

<td style="text-align:right;">

12.520

</td>

<td style="text-align:right;">

623845.0

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

S1NoCD

</td>

<td style="text-align:right;">

74455

</td>

<td style="text-align:right;">

1254482

</td>

<td style="text-align:right;">

144754.5

</td>

<td style="text-align:right;">

249557

</td>

<td style="text-align:right;">

27399.12

</td>

<td style="text-align:right;">

32482.0

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.136

</td>

<td style="text-align:right;">

0.153

</td>

<td style="text-align:right;">

0.082

</td>

<td style="text-align:right;">

31041

</td>

<td style="text-align:right;">

5736

</td>

<td style="text-align:right;">

9824.0

</td>

<td style="text-align:right;">

819.0

</td>

<td style="text-align:right;">

0.214

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.068

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

1054890

</td>

<td style="text-align:right;">

59496

</td>

<td style="text-align:right;">

61264

</td>

<td style="text-align:right;">

14408

</td>

<td style="text-align:right;">

2551

</td>

<td style="text-align:right;">

162093650

</td>

<td style="text-align:right;">

2177.069

</td>

<td style="text-align:right;">

934933.0

</td>

<td style="text-align:right;">

12.557

</td>

<td style="text-align:right;">

625674.0

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

74418

</td>

<td style="text-align:right;">

1251848

</td>

<td style="text-align:right;">

143524.9

</td>

<td style="text-align:right;">

315260

</td>

<td style="text-align:right;">

27131.76

</td>

<td style="text-align:right;">

29476.5

</td>

<td style="text-align:right;">

0.019

</td>

<td style="text-align:right;">

0.137

</td>

<td style="text-align:right;">

0.153

</td>

<td style="text-align:right;">

0.082

</td>

<td style="text-align:right;">

31072

</td>

<td style="text-align:right;">

5789

</td>

<td style="text-align:right;">

9795.5

</td>

<td style="text-align:right;">

826.5

</td>

<td style="text-align:right;">

0.217

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.068

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

1053584

</td>

<td style="text-align:right;">

58472

</td>

<td style="text-align:right;">

61485

</td>

<td style="text-align:right;">

14043

</td>

<td style="text-align:right;">

2521

</td>

<td style="text-align:right;">

161397011

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

933095.7

</td>

<td style="text-align:right;">

12.539

</td>

<td style="text-align:right;">

624759.5

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

74463

</td>

<td style="text-align:right;">

1251286

</td>

<td style="text-align:right;">

141682.9

</td>

<td style="text-align:right;">

245683

</td>

<td style="text-align:right;">

55826.63

</td>

<td style="text-align:right;">

32280.0

</td>

<td style="text-align:right;">

0.028

</td>

<td style="text-align:right;">

0.148

</td>

<td style="text-align:right;">

0.270

</td>

<td style="text-align:right;">

0.089

</td>

<td style="text-align:right;">

30035

</td>

<td style="text-align:right;">

5570

</td>

<td style="text-align:right;">

9255.0

</td>

<td style="text-align:right;">

777.0

</td>

<td style="text-align:right;">

0.212

</td>

<td style="text-align:right;">

0.039

</td>

<td style="text-align:right;">

0.065

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

1054820

</td>

<td style="text-align:right;">

58031

</td>

<td style="text-align:right;">

60912

</td>

<td style="text-align:right;">

13236

</td>

<td style="text-align:right;">

2496

</td>

<td style="text-align:right;">

170832804

</td>

<td style="text-align:right;">

2294.197

</td>

<td style="text-align:right;">

933591.8

</td>

<td style="text-align:right;">

12.538

</td>

<td style="text-align:right;">

624588.8

</td>

<td style="text-align:right;">

117.128

</td>

<td style="text-align:right;">

\-0.019

</td>

<td style="text-align:right;">

\-6049.917

</td>

<td style="text-align:right;">

\-1085.146

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

74310

</td>

<td style="text-align:right;">

1249406

</td>

<td style="text-align:right;">

139676.9

</td>

<td style="text-align:right;">

247234

</td>

<td style="text-align:right;">

40175.08

</td>

<td style="text-align:right;">

32521.0

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.140

</td>

<td style="text-align:right;">

0.213

</td>

<td style="text-align:right;">

0.083

</td>

<td style="text-align:right;">

29262

</td>

<td style="text-align:right;">

5544

</td>

<td style="text-align:right;">

9230.0

</td>

<td style="text-align:right;">

778.0

</td>

<td style="text-align:right;">

0.209

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.066

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

1054825

</td>

<td style="text-align:right;">

56762

</td>

<td style="text-align:right;">

60161

</td>

<td style="text-align:right;">

13502

</td>

<td style="text-align:right;">

2452

</td>

<td style="text-align:right;">

165046694

</td>

<td style="text-align:right;">

2221.056

</td>

<td style="text-align:right;">

931999.4

</td>

<td style="text-align:right;">

12.542

</td>

<td style="text-align:right;">

624881.2

</td>

<td style="text-align:right;">

43.988

</td>

<td style="text-align:right;">

\-0.015

</td>

<td style="text-align:right;">

\-2937.340

</td>

<td style="text-align:right;">

\-792.754

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

74324

</td>

<td style="text-align:right;">

1253620

</td>

<td style="text-align:right;">

142405.1

</td>

<td style="text-align:right;">

248155

</td>

<td style="text-align:right;">

38232.11

</td>

<td style="text-align:right;">

32606.0

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.146

</td>

<td style="text-align:right;">

0.204

</td>

<td style="text-align:right;">

0.085

</td>

<td style="text-align:right;">

30553

</td>

<td style="text-align:right;">

5640

</td>

<td style="text-align:right;">

9579.0

</td>

<td style="text-align:right;">

862.0

</td>

<td style="text-align:right;">

0.215

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0.067

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

1056278

</td>

<td style="text-align:right;">

56650

</td>

<td style="text-align:right;">

61821

</td>

<td style="text-align:right;">

14373

</td>

<td style="text-align:right;">

2608

</td>

<td style="text-align:right;">

173025636

</td>

<td style="text-align:right;">

2327.991

</td>

<td style="text-align:right;">

934564.9

</td>

<td style="text-align:right;">

12.574

</td>

<td style="text-align:right;">

626382.0

</td>

<td style="text-align:right;">

150.923

</td>

<td style="text-align:right;">

0.017

</td>

<td style="text-align:right;">

8784.747

</td>

<td style="text-align:right;">

708.082

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

24.33

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

43926

</td>

<td style="text-align:right;">

727038.0

</td>

<td style="text-align:right;">

102873.10

</td>

<td style="text-align:right;">

144486

</td>

<td style="text-align:right;">

19930.05

</td>

<td style="text-align:right;">

19182

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.143

</td>

<td style="text-align:right;">

0.159

</td>

<td style="text-align:right;">

0.090

</td>

<td style="text-align:right;">

23603

</td>

<td style="text-align:right;">

4351

</td>

<td style="text-align:right;">

7391

</td>

<td style="text-align:right;">

640

</td>

<td style="text-align:right;">

0.229

</td>

<td style="text-align:right;">

0.042

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

593259

</td>

<td style="text-align:right;">

37489

</td>

<td style="text-align:right;">

46390

</td>

<td style="text-align:right;">

11741

</td>

<td style="text-align:right;">

2266

</td>

<td style="text-align:right;">

122561423

</td>

<td style="text-align:right;">

2790.179

</td>

<td style="text-align:right;">

539901.9

</td>

<td style="text-align:right;">

12.291

</td>

<td style="text-align:right;">

611768.3

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

43809

</td>

<td style="text-align:right;">

723720.2

</td>

<td style="text-align:right;">

99970.36

</td>

<td style="text-align:right;">

142366

</td>

<td style="text-align:right;">

32075.69

</td>

<td style="text-align:right;">

19036

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

0.148

</td>

<td style="text-align:right;">

0.237

</td>

<td style="text-align:right;">

0.092

</td>

<td style="text-align:right;">

22909

</td>

<td style="text-align:right;">

4316

</td>

<td style="text-align:right;">

6930

</td>

<td style="text-align:right;">

607

</td>

<td style="text-align:right;">

0.229

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.069

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

592842

</td>

<td style="text-align:right;">

37395

</td>

<td style="text-align:right;">

44285

</td>

<td style="text-align:right;">

11273

</td>

<td style="text-align:right;">

2108

</td>

<td style="text-align:right;">

123751988

</td>

<td style="text-align:right;">

2824.807

</td>

<td style="text-align:right;">

538117.2

</td>

<td style="text-align:right;">

12.283

</td>

<td style="text-align:right;">

611338.0

</td>

<td style="text-align:right;">

34.628

</td>

<td style="text-align:right;">

\-0.008

</td>

<td style="text-align:right;">

\-4376.023

</td>

<td style="text-align:right;">

\-430.283

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

11.56

</td>

<td style="text-align:right;">

11.56

</td>

<td style="text-align:right;">

24.33

</td>

<td style="text-align:right;">

42.01

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

34361

</td>

<td style="text-align:right;">

518001.3

</td>

<td style="text-align:right;">

82686.56

</td>

<td style="text-align:right;">

104556

</td>

<td style="text-align:right;">

14899.75

</td>

<td style="text-align:right;">

14302

</td>

<td style="text-align:right;">

0.022

</td>

<td style="text-align:right;">

0.131

</td>

<td style="text-align:right;">

0.148

</td>

<td style="text-align:right;">

0.083

</td>

<td style="text-align:right;">

19413

</td>

<td style="text-align:right;">

3577

</td>

<td style="text-align:right;">

6039

</td>

<td style="text-align:right;">

519

</td>

<td style="text-align:right;">

0.235

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.073

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

413577

</td>

<td style="text-align:right;">

30218

</td>

<td style="text-align:right;">

37181

</td>

<td style="text-align:right;">

9517

</td>

<td style="text-align:right;">

1790

</td>

<td style="text-align:right;">

99011907

</td>

<td style="text-align:right;">

2881.520

</td>

<td style="text-align:right;">

385850.3

</td>

<td style="text-align:right;">

11.229

</td>

<td style="text-align:right;">

558583.9

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

34402

</td>

<td style="text-align:right;">

517075.7

</td>

<td style="text-align:right;">

82346.85

</td>

<td style="text-align:right;">

103815

</td>

<td style="text-align:right;">

20291.25

</td>

<td style="text-align:right;">

13940

</td>

<td style="text-align:right;">

0.024

</td>

<td style="text-align:right;">

0.139

</td>

<td style="text-align:right;">

0.189

</td>

<td style="text-align:right;">

0.088

</td>

<td style="text-align:right;">

19512

</td>

<td style="text-align:right;">

3637

</td>

<td style="text-align:right;">

5897

</td>

<td style="text-align:right;">

504

</td>

<td style="text-align:right;">

0.237

</td>

<td style="text-align:right;">

0.044

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

413035

</td>

<td style="text-align:right;">

29440

</td>

<td style="text-align:right;">

36940

</td>

<td style="text-align:right;">

10052

</td>

<td style="text-align:right;">

1925

</td>

<td style="text-align:right;">

102402182

</td>

<td style="text-align:right;">

2976.635

</td>

<td style="text-align:right;">

385196.5

</td>

<td style="text-align:right;">

11.197

</td>

<td style="text-align:right;">

556869.5

</td>

<td style="text-align:right;">

95.115

</td>

<td style="text-align:right;">

\-0.032

</td>

<td style="text-align:right;">

\-2936.831

</td>

<td style="text-align:right;">

\-1714.456

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

34475

</td>

<td style="text-align:right;">

519668.8

</td>

<td style="text-align:right;">

84147.16

</td>

<td style="text-align:right;">

103039

</td>

<td style="text-align:right;">

30309.24

</td>

<td style="text-align:right;">

14013

</td>

<td style="text-align:right;">

0.029

</td>

<td style="text-align:right;">

0.154

</td>

<td style="text-align:right;">

0.260

</td>

<td style="text-align:right;">

0.097

</td>

<td style="text-align:right;">

18928

</td>

<td style="text-align:right;">

3625

</td>

<td style="text-align:right;">

6007

</td>

<td style="text-align:right;">

486

</td>

<td style="text-align:right;">

0.225

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.071

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

413765

</td>

<td style="text-align:right;">

31006

</td>

<td style="text-align:right;">

37134

</td>

<td style="text-align:right;">

9941

</td>

<td style="text-align:right;">

1947

</td>

<td style="text-align:right;">

107405415

</td>

<td style="text-align:right;">

3115.458

</td>

<td style="text-align:right;">

387323.2

</td>

<td style="text-align:right;">

11.235

</td>

<td style="text-align:right;">

558629.6

</td>

<td style="text-align:right;">

233.938

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

41834.022

</td>

<td style="text-align:right;">

45.665

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

34264

</td>

<td style="text-align:right;">

516790.4

</td>

<td style="text-align:right;">

83039.66

</td>

<td style="text-align:right;">

103014

</td>

<td style="text-align:right;">

24762.75

</td>

<td style="text-align:right;">

14039

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

0.148

</td>

<td style="text-align:right;">

0.227

</td>

<td style="text-align:right;">

0.093

</td>

<td style="text-align:right;">

18990

</td>

<td style="text-align:right;">

3657

</td>

<td style="text-align:right;">

6046

</td>

<td style="text-align:right;">

500

</td>

<td style="text-align:right;">

0.229

</td>

<td style="text-align:right;">

0.044

</td>

<td style="text-align:right;">

0.073

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

412119

</td>

<td style="text-align:right;">

30512

</td>

<td style="text-align:right;">

37404

</td>

<td style="text-align:right;">

9152

</td>

<td style="text-align:right;">

1898

</td>

<td style="text-align:right;">

104658087

</td>

<td style="text-align:right;">

3054.462

</td>

<td style="text-align:right;">

385100.3

</td>

<td style="text-align:right;">

11.239

</td>

<td style="text-align:right;">

558906.1

</td>

<td style="text-align:right;">

172.942

</td>

<td style="text-align:right;">

0.010

</td>

<td style="text-align:right;">

17464.795

</td>

<td style="text-align:right;">

322.174

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

34563

</td>

<td style="text-align:right;">

521867.3

</td>

<td style="text-align:right;">

84912.82

</td>

<td style="text-align:right;">

104357

</td>

<td style="text-align:right;">

23002.27

</td>

<td style="text-align:right;">

14035

</td>

<td style="text-align:right;">

0.025

</td>

<td style="text-align:right;">

0.142

</td>

<td style="text-align:right;">

0.206

</td>

<td style="text-align:right;">

0.091

</td>

<td style="text-align:right;">

19718

</td>

<td style="text-align:right;">

3713

</td>

<td style="text-align:right;">

6157

</td>

<td style="text-align:right;">

543

</td>

<td style="text-align:right;">

0.232

</td>

<td style="text-align:right;">

0.044

</td>

<td style="text-align:right;">

0.073

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

415162

</td>

<td style="text-align:right;">

31441

</td>

<td style="text-align:right;">

37577

</td>

<td style="text-align:right;">

9984

</td>

<td style="text-align:right;">

1837

</td>

<td style="text-align:right;">

107489100

</td>

<td style="text-align:right;">

3109.947

</td>

<td style="text-align:right;">

388747.5

</td>

<td style="text-align:right;">

11.248

</td>

<td style="text-align:right;">

559265.2

</td>

<td style="text-align:right;">

228.427

</td>

<td style="text-align:right;">

0.018

</td>

<td style="text-align:right;">

12554.869

</td>

<td style="text-align:right;">

681.288

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

S1c

</td>

<td style="text-align:right;">

74324

</td>

<td style="text-align:right;">

173025636

</td>

<td style="text-align:right;">

2327.991

</td>

<td style="text-align:right;">

934564.9

</td>

<td style="text-align:right;">

12.574

</td>

<td style="text-align:right;">

8784.747

</td>

<td style="text-align:right;">

708.082

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

34563

</td>

<td style="text-align:right;">

107489100

</td>

<td style="text-align:right;">

3109.947

</td>

<td style="text-align:right;">

388747.5

</td>

<td style="text-align:right;">

11.248

</td>

<td style="text-align:right;">

12554.869

</td>

<td style="text-align:right;">

681.288

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

34264

</td>

<td style="text-align:right;">

104658087

</td>

<td style="text-align:right;">

3054.462

</td>

<td style="text-align:right;">

385100.3

</td>

<td style="text-align:right;">

11.239

</td>

<td style="text-align:right;">

17464.795

</td>

<td style="text-align:right;">

322.174

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

34475

</td>

<td style="text-align:right;">

107405415

</td>

<td style="text-align:right;">

3115.458

</td>

<td style="text-align:right;">

387323.2

</td>

<td style="text-align:right;">

11.235

</td>

<td style="text-align:right;">

41834.022

</td>

<td style="text-align:right;">

45.665

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCD

</td>

<td style="text-align:right;">

74455

</td>

<td style="text-align:right;">

162093650

</td>

<td style="text-align:right;">

2177.069

</td>

<td style="text-align:right;">

934933.0

</td>

<td style="text-align:right;">

12.557

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

43926

</td>

<td style="text-align:right;">

122561423

</td>

<td style="text-align:right;">

2790.179

</td>

<td style="text-align:right;">

539901.9

</td>

<td style="text-align:right;">

12.291

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

34361

</td>

<td style="text-align:right;">

99011907

</td>

<td style="text-align:right;">

2881.520

</td>

<td style="text-align:right;">

385850.3

</td>

<td style="text-align:right;">

11.229

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

43809

</td>

<td style="text-align:right;">

123751988

</td>

<td style="text-align:right;">

2824.807

</td>

<td style="text-align:right;">

538117.2

</td>

<td style="text-align:right;">

12.283

</td>

<td style="text-align:right;">

\-4376.023

</td>

<td style="text-align:right;">

\-430.283

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

74310

</td>

<td style="text-align:right;">

165046694

</td>

<td style="text-align:right;">

2221.056

</td>

<td style="text-align:right;">

931999.4

</td>

<td style="text-align:right;">

12.542

</td>

<td style="text-align:right;">

\-2937.340

</td>

<td style="text-align:right;">

\-792.754

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

74463

</td>

<td style="text-align:right;">

170832804

</td>

<td style="text-align:right;">

2294.197

</td>

<td style="text-align:right;">

933591.8

</td>

<td style="text-align:right;">

12.538

</td>

<td style="text-align:right;">

\-6049.917

</td>

<td style="text-align:right;">

\-1085.146

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

34402

</td>

<td style="text-align:right;">

102402182

</td>

<td style="text-align:right;">

2976.635

</td>

<td style="text-align:right;">

385196.5

</td>

<td style="text-align:right;">

11.197

</td>

<td style="text-align:right;">

\-2936.831

</td>

<td style="text-align:right;">

\-1714.456

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

74418

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

161397011

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

933095.7

</td>

<td style="text-align:right;">

12.53857

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.53857

</td>

<td style="text-align:right;">

0.00000

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

0.00000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

74463

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

170832804

</td>

<td style="text-align:right;">

2294.197

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2294.197

</td>

<td style="text-align:right;">

933591.8

</td>

<td style="text-align:right;">

12.53766

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.53766

</td>

<td style="text-align:right;">

125.40720

</td>

<td style="text-align:right;">

\-0.0009145

</td>

<td style="text-align:right;">

\-137138.027

</td>

<td style="text-align:right;">

\-6049.917

</td>

<td style="text-align:right;">

\-171.13019

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

74310

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

165046694

</td>

<td style="text-align:right;">

2221.056

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2221.056

</td>

<td style="text-align:right;">

931999.4

</td>

<td style="text-align:right;">

12.54205

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.54205

</td>

<td style="text-align:right;">

52.26634

</td>

<td style="text-align:right;">

0.0034706

</td>

<td style="text-align:right;">

15059.902

</td>

<td style="text-align:right;">

\-2937.340

</td>

<td style="text-align:right;">

121.26182

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

74324

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

173025636

</td>

<td style="text-align:right;">

2327.991

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2327.991

</td>

<td style="text-align:right;">

934564.9

</td>

<td style="text-align:right;">

12.57420

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.57420

</td>

<td style="text-align:right;">

159.20148

</td>

<td style="text-align:right;">

0.0356260

</td>

<td style="text-align:right;">

4468.692

</td>

<td style="text-align:right;">

8784.747

</td>

<td style="text-align:right;">

1622.09705

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

43926

</td>

<td style="text-align:right;">

0.5902604

</td>

<td style="text-align:right;">

122561423

</td>

<td style="text-align:right;">

2790.179

</td>

<td style="text-align:right;">

1273.632

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

539901.9

</td>

<td style="text-align:right;">

12.29117

</td>

<td style="text-align:right;">

12.89498

</td>

<td style="text-align:right;">

12.53857

</td>

<td style="text-align:right;">

0.00000

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

0.00000

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

43809

</td>

<td style="text-align:right;">

0.5886882

</td>

<td style="text-align:right;">

123751988

</td>

<td style="text-align:right;">

2824.807

</td>

<td style="text-align:right;">

1273.632

</td>

<td style="text-align:right;">

2186.791

</td>

<td style="text-align:right;">

538117.2

</td>

<td style="text-align:right;">

12.28326

</td>

<td style="text-align:right;">

12.89498

</td>

<td style="text-align:right;">

12.53487

</td>

<td style="text-align:right;">

18.00074

</td>

<td style="text-align:right;">

\-0.0037090

</td>

<td style="text-align:right;">

\-4853.210

</td>

<td style="text-align:right;">

\-4376.023

</td>

<td style="text-align:right;">

\-203.45267

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

34361

</td>

<td style="text-align:right;">

0.4617297

</td>

<td style="text-align:right;">

99011907

</td>

<td style="text-align:right;">

2881.520

</td>

<td style="text-align:right;">

1557.408

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

385850.3

</td>

<td style="text-align:right;">

11.22931

</td>

<td style="text-align:right;">

13.66167

</td>

<td style="text-align:right;">

12.53857

</td>

<td style="text-align:right;">

0.00000

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

0.00000

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

34402

</td>

<td style="text-align:right;">

0.4622806

</td>

<td style="text-align:right;">

102402182

</td>

<td style="text-align:right;">

2976.635

</td>

<td style="text-align:right;">

1557.408

</td>

<td style="text-align:right;">

2213.489

</td>

<td style="text-align:right;">

385196.5

</td>

<td style="text-align:right;">

11.19692

</td>

<td style="text-align:right;">

13.66167

</td>

<td style="text-align:right;">

12.52226

</td>

<td style="text-align:right;">

44.69916

</td>

<td style="text-align:right;">

\-0.0163119

</td>

<td style="text-align:right;">

\-2740.281

</td>

<td style="text-align:right;">

\-2936.831

</td>

<td style="text-align:right;">

\-860.29350

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

34475

</td>

<td style="text-align:right;">

0.4632616

</td>

<td style="text-align:right;">

107405415

</td>

<td style="text-align:right;">

3115.458

</td>

<td style="text-align:right;">

1557.408

</td>

<td style="text-align:right;">

2279.193

</td>

<td style="text-align:right;">

387323.2

</td>

<td style="text-align:right;">

11.23490

</td>

<td style="text-align:right;">

13.66167

</td>

<td style="text-align:right;">

12.53744

</td>

<td style="text-align:right;">

110.40291

</td>

<td style="text-align:right;">

\-0.0011355

</td>

<td style="text-align:right;">

\-97227.161

</td>

<td style="text-align:right;">

41834.022

</td>

<td style="text-align:right;">

\-167.17866

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

34264

</td>

<td style="text-align:right;">

0.4604262

</td>

<td style="text-align:right;">

104658087

</td>

<td style="text-align:right;">

3054.462

</td>

<td style="text-align:right;">

1557.408

</td>

<td style="text-align:right;">

2246.691

</td>

<td style="text-align:right;">

385100.3

</td>

<td style="text-align:right;">

11.23921

</td>

<td style="text-align:right;">

13.66167

</td>

<td style="text-align:right;">

12.54630

</td>

<td style="text-align:right;">

77.90117

</td>

<td style="text-align:right;">

0.0077297

</td>

<td style="text-align:right;">

10078.106

</td>

<td style="text-align:right;">

17464.795

</td>

<td style="text-align:right;">

308.58598

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

34563

</td>

<td style="text-align:right;">

0.4644441

</td>

<td style="text-align:right;">

107489100

</td>

<td style="text-align:right;">

3109.947

</td>

<td style="text-align:right;">

1557.408

</td>

<td style="text-align:right;">

2278.476

</td>

<td style="text-align:right;">

388747.5

</td>

<td style="text-align:right;">

11.24750

</td>

<td style="text-align:right;">

13.66167

</td>

<td style="text-align:right;">

12.54042

</td>

<td style="text-align:right;">

109.68578

</td>

<td style="text-align:right;">

0.0018479

</td>

<td style="text-align:right;">

59358.523

</td>

<td style="text-align:right;">

12554.869

</td>

<td style="text-align:right;">

\-17.29317

</td>

</tr>

</tbody>

</table>

![](Case_Detection_Results_5yrs_files/figure-gfm/CEplot-1.png)<!-- -->

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

0.0190102

</td>

<td style="text-align:right;">

0.1365892

</td>

<td style="text-align:right;">

0.1534409

</td>

<td style="text-align:right;">

0.0819411

</td>

<td style="text-align:right;">

0.4175334

</td>

<td style="text-align:right;">

0.0777903

</td>

<td style="text-align:right;">

0.1316281

</td>

<td style="text-align:right;">

0.0111062

</td>

<td style="text-align:right;">

0.8416227

</td>

<td style="text-align:right;">

0.0467086

</td>

<td style="text-align:right;">

0.0491154

</td>

<td style="text-align:right;">

0.0112178

</td>

<td style="text-align:right;">

0.0020138

</td>

<td style="text-align:right;">

0.1890387

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

0.0276375

</td>

<td style="text-align:right;">

0.1483270

</td>

<td style="text-align:right;">

0.2696688

</td>

<td style="text-align:right;">

0.0889756

</td>

<td style="text-align:right;">

0.4033547

</td>

<td style="text-align:right;">

0.0748023

</td>

<td style="text-align:right;">

0.1242899

</td>

<td style="text-align:right;">

0.0104347

</td>

<td style="text-align:right;">

0.8429890

</td>

<td style="text-align:right;">

0.0463771

</td>

<td style="text-align:right;">

0.0486795

</td>

<td style="text-align:right;">

0.0105779

</td>

<td style="text-align:right;">

0.0019947

</td>

<td style="text-align:right;">

0.3940251

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

0.0233615

</td>

<td style="text-align:right;">

0.1402247

</td>

<td style="text-align:right;">

0.2125885

</td>

<td style="text-align:right;">

0.0826803

</td>

<td style="text-align:right;">

0.3937828

</td>

<td style="text-align:right;">

0.0746064

</td>

<td style="text-align:right;">

0.1242094

</td>

<td style="text-align:right;">

0.0104697

</td>

<td style="text-align:right;">

0.8442610

</td>

<td style="text-align:right;">

0.0454312

</td>

<td style="text-align:right;">

0.0481517

</td>

<td style="text-align:right;">

0.0108067

</td>

<td style="text-align:right;">

0.0019625

</td>

<td style="text-align:right;">

0.2876287

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

0.0230147

</td>

<td style="text-align:right;">

0.1455010

</td>

<td style="text-align:right;">

0.2043711

</td>

<td style="text-align:right;">

0.0851480

</td>

<td style="text-align:right;">

0.4110785

</td>

<td style="text-align:right;">

0.0758840

</td>

<td style="text-align:right;">

0.1288817

</td>

<td style="text-align:right;">

0.0115979

</td>

<td style="text-align:right;">

0.8425822

</td>

<td style="text-align:right;">

0.0451891

</td>

<td style="text-align:right;">

0.0493140

</td>

<td style="text-align:right;">

0.0114652

</td>

<td style="text-align:right;">

0.0020804

</td>

<td style="text-align:right;">

0.2684742

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

0.5902604

</td>

<td style="text-align:right;">

0.5807718

</td>

<td style="text-align:right;">

0.7167611

</td>

<td style="text-align:right;">

0.0190102

</td>

<td style="text-align:right;">

0.1365892

</td>

<td style="text-align:right;">

0.1534409

</td>

<td style="text-align:right;">

0.0819411

</td>

<td style="text-align:right;">

0.4175334

</td>

<td style="text-align:right;">

0.0777903

</td>

<td style="text-align:right;">

0.1316281

</td>

<td style="text-align:right;">

0.0111062

</td>

<td style="text-align:right;">

0.8416227

</td>

<td style="text-align:right;">

0.0467086

</td>

<td style="text-align:right;">

0.0491154

</td>

<td style="text-align:right;">

0.0112178

</td>

<td style="text-align:right;">

0.0020138

</td>

<td style="text-align:right;">

0.1890387

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

0.5886882

</td>

<td style="text-align:right;">

0.5781215

</td>

<td style="text-align:right;">

0.6965365

</td>

<td style="text-align:right;">

0.0215100

</td>

<td style="text-align:right;">

0.1401177

</td>

<td style="text-align:right;">

0.2075466

</td>

<td style="text-align:right;">

0.0827285

</td>

<td style="text-align:right;">

0.4085928

</td>

<td style="text-align:right;">

0.0773941

</td>

<td style="text-align:right;">

0.1255573

</td>

<td style="text-align:right;">

0.0106724

</td>

<td style="text-align:right;">

0.8436142

</td>

<td style="text-align:right;">

0.0467394

</td>

<td style="text-align:right;">

0.0475101

</td>

<td style="text-align:right;">

0.0108556

</td>

<td style="text-align:right;">

0.0018889

</td>

<td style="text-align:right;">

0.2772455

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

0.4617297

</td>

<td style="text-align:right;">

0.4137894

</td>

<td style="text-align:right;">

0.5761129

</td>

<td style="text-align:right;">

0.0190102

</td>

<td style="text-align:right;">

0.1365892

</td>

<td style="text-align:right;">

0.1534409

</td>

<td style="text-align:right;">

0.0819411

</td>

<td style="text-align:right;">

0.4175334

</td>

<td style="text-align:right;">

0.0777903

</td>

<td style="text-align:right;">

0.1316281

</td>

<td style="text-align:right;">

0.0111062

</td>

<td style="text-align:right;">

0.8416227

</td>

<td style="text-align:right;">

0.0467086

</td>

<td style="text-align:right;">

0.0491154

</td>

<td style="text-align:right;">

0.0112178

</td>

<td style="text-align:right;">

0.0020138

</td>

<td style="text-align:right;">

0.1890387

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

0.4622806

</td>

<td style="text-align:right;">

0.4130500

</td>

<td style="text-align:right;">

0.5737459

</td>

<td style="text-align:right;">

0.0198172

</td>

<td style="text-align:right;">

0.1411560

</td>

<td style="text-align:right;">

0.1770841

</td>

<td style="text-align:right;">

0.0852209

</td>

<td style="text-align:right;">

0.4187034

</td>

<td style="text-align:right;">

0.0785662

</td>

<td style="text-align:right;">

0.1296683

</td>

<td style="text-align:right;">

0.0109004

</td>

<td style="text-align:right;">

0.8418346

</td>

<td style="text-align:right;">

0.0461155

</td>

<td style="text-align:right;">

0.0489474

</td>

<td style="text-align:right;">

0.0116497

</td>

<td style="text-align:right;">

0.0021224

</td>

<td style="text-align:right;">

0.2270795

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

0.4632616

</td>

<td style="text-align:right;">

0.4151214

</td>

<td style="text-align:right;">

0.5862895

</td>

<td style="text-align:right;">

0.0217042

</td>

<td style="text-align:right;">

0.1499413

</td>

<td style="text-align:right;">

0.2194832

</td>

<td style="text-align:right;">

0.0900574

</td>

<td style="text-align:right;">

0.4105703

</td>

<td style="text-align:right;">

0.0783507

</td>

<td style="text-align:right;">

0.1310544

</td>

<td style="text-align:right;">

0.0106510

</td>

<td style="text-align:right;">

0.8406112

</td>

<td style="text-align:right;">

0.0472867

</td>

<td style="text-align:right;">

0.0490337

</td>

<td style="text-align:right;">

0.0115483

</td>

<td style="text-align:right;">

0.0021379

</td>

<td style="text-align:right;">

0.2943571

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

0.4604262

</td>

<td style="text-align:right;">

0.4128221

</td>

<td style="text-align:right;">

0.5785730

</td>

<td style="text-align:right;">

0.0205415

</td>

<td style="text-align:right;">

0.1464880

</td>

<td style="text-align:right;">

0.1990998

</td>

<td style="text-align:right;">

0.0879219

</td>

<td style="text-align:right;">

0.4122287

</td>

<td style="text-align:right;">

0.0789373

</td>

<td style="text-align:right;">

0.1318444

</td>

<td style="text-align:right;">

0.0108609

</td>

<td style="text-align:right;">

0.8413016

</td>

<td style="text-align:right;">

0.0469806

</td>

<td style="text-align:right;">

0.0493256

</td>

<td style="text-align:right;">

0.0109322

</td>

<td style="text-align:right;">

0.0021011

</td>

<td style="text-align:right;">

0.2572638

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

0.4644441

</td>

<td style="text-align:right;">

0.4168776

</td>

<td style="text-align:right;">

0.5916241

</td>

<td style="text-align:right;">

0.0201966

</td>

<td style="text-align:right;">

0.1430840

</td>

<td style="text-align:right;">

0.1875786

</td>

<td style="text-align:right;">

0.0871141

</td>

<td style="text-align:right;">

0.4208418

</td>

<td style="text-align:right;">

0.0794679

</td>

<td style="text-align:right;">

0.1329592

</td>

<td style="text-align:right;">

0.0114078

</td>

<td style="text-align:right;">

0.8401955

</td>

<td style="text-align:right;">

0.0475666

</td>

<td style="text-align:right;">

0.0493294

</td>

<td style="text-align:right;">

0.0115718

</td>

<td style="text-align:right;">

0.0020483

</td>

<td style="text-align:right;">

0.2423738

</td>

</tr>

</tbody>

</table>
