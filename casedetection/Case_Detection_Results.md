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

  - Case detection occurs at 3 year intervals.
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

S1NoCD2

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

74371

</td>

<td style="text-align:right;">

1255151

</td>

<td style="text-align:right;">

144269.0

</td>

<td style="text-align:right;">

372943

</td>

<td style="text-align:right;">

66804.86

</td>

<td style="text-align:right;">

26432.0

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

0.158

</td>

<td style="text-align:right;">

0.308

</td>

<td style="text-align:right;">

0.093

</td>

<td style="text-align:right;">

29765

</td>

<td style="text-align:right;">

5556

</td>

<td style="text-align:right;">

9583.0

</td>

<td style="text-align:right;">

756.0

</td>

<td style="text-align:right;">

0.206

</td>

<td style="text-align:right;">

0.039

</td>

<td style="text-align:right;">

0.066

</td>

<td style="text-align:right;">

0.005

</td>

<td style="text-align:right;">

1056053

</td>

<td style="text-align:right;">

59481

</td>

<td style="text-align:right;">

61353

</td>

<td style="text-align:right;">

13927

</td>

<td style="text-align:right;">

2461

</td>

<td style="text-align:right;">

181363804

</td>

<td style="text-align:right;">

2438.636

</td>

<td style="text-align:right;">

936417.1

</td>

<td style="text-align:right;">

12.591

</td>

<td style="text-align:right;">

627119.3

</td>

<td style="text-align:right;">

278.133

</td>

<td style="text-align:right;">

0.071

</td>

<td style="text-align:right;">

3914.696

</td>

<td style="text-align:right;">

3274.290

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

74640

</td>

<td style="text-align:right;">

1254998

</td>

<td style="text-align:right;">

145127.3

</td>

<td style="text-align:right;">

377503

</td>

<td style="text-align:right;">

47864.08

</td>

<td style="text-align:right;">

27030.0

</td>

<td style="text-align:right;">

0.022

</td>

<td style="text-align:right;">

0.143

</td>

<td style="text-align:right;">

0.236

</td>

<td style="text-align:right;">

0.087

</td>

<td style="text-align:right;">

30732

</td>

<td style="text-align:right;">

5904

</td>

<td style="text-align:right;">

9722.0

</td>

<td style="text-align:right;">

823.0

</td>

<td style="text-align:right;">

0.212

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.067

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

1055073

</td>

<td style="text-align:right;">

58017

</td>

<td style="text-align:right;">

63455

</td>

<td style="text-align:right;">

13915

</td>

<td style="text-align:right;">

2606

</td>

<td style="text-align:right;">

177925068

</td>

<td style="text-align:right;">

2383.776

</td>

<td style="text-align:right;">

935793.1

</td>

<td style="text-align:right;">

12.537

</td>

<td style="text-align:right;">

624487.2

</td>

<td style="text-align:right;">

223.273

</td>

<td style="text-align:right;">

0.017

</td>

<td style="text-align:right;">

12898.673

</td>

<td style="text-align:right;">

642.216

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

74131

</td>

<td style="text-align:right;">

1247977

</td>

<td style="text-align:right;">

142147.0

</td>

<td style="text-align:right;">

376977

</td>

<td style="text-align:right;">

40926.38

</td>

<td style="text-align:right;">

26556.0

</td>

<td style="text-align:right;">

0.020

</td>

<td style="text-align:right;">

0.144

</td>

<td style="text-align:right;">

0.213

</td>

<td style="text-align:right;">

0.087

</td>

<td style="text-align:right;">

30094

</td>

<td style="text-align:right;">

5716

</td>

<td style="text-align:right;">

9685.0

</td>

<td style="text-align:right;">

854.0

</td>

<td style="text-align:right;">

0.212

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

1051104

</td>

<td style="text-align:right;">

57768

</td>

<td style="text-align:right;">

61484

</td>

<td style="text-align:right;">

13471

</td>

<td style="text-align:right;">

2500

</td>

<td style="text-align:right;">

177946180

</td>

<td style="text-align:right;">

2400.429

</td>

<td style="text-align:right;">

930572.9

</td>

<td style="text-align:right;">

12.553

</td>

<td style="text-align:right;">

625253.9

</td>

<td style="text-align:right;">

239.926

</td>

<td style="text-align:right;">

0.033

</td>

<td style="text-align:right;">

7275.584

</td>

<td style="text-align:right;">

1408.916

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

44135

</td>

<td style="text-align:right;">

728915.0

</td>

<td style="text-align:right;">

99715.61

</td>

<td style="text-align:right;">

221764

</td>

<td style="text-align:right;">

20025.00

</td>

<td style="text-align:right;">

15361

</td>

<td style="text-align:right;">

0.017

</td>

<td style="text-align:right;">

0.144

</td>

<td style="text-align:right;">

0.164

</td>

<td style="text-align:right;">

0.089

</td>

<td style="text-align:right;">

22765

</td>

<td style="text-align:right;">

4265

</td>

<td style="text-align:right;">

7228

</td>

<td style="text-align:right;">

593

</td>

<td style="text-align:right;">

0.228

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

598020

</td>

<td style="text-align:right;">

37344

</td>

<td style="text-align:right;">

44329

</td>

<td style="text-align:right;">

11018

</td>

<td style="text-align:right;">

2171

</td>

<td style="text-align:right;">

118268910

</td>

<td style="text-align:right;">

2679.708

</td>

<td style="text-align:right;">

541787.4

</td>

<td style="text-align:right;">

12.276

</td>

<td style="text-align:right;">

611104.6

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

44437

</td>

<td style="text-align:right;">

733222.2

</td>

<td style="text-align:right;">

102733.54

</td>

<td style="text-align:right;">

218481

</td>

<td style="text-align:right;">

37779.22

</td>

<td style="text-align:right;">

15576

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.164

</td>

<td style="text-align:right;">

0.271

</td>

<td style="text-align:right;">

0.104

</td>

<td style="text-align:right;">

22572

</td>

<td style="text-align:right;">

4335

</td>

<td style="text-align:right;">

7461

</td>

<td style="text-align:right;">

679

</td>

<td style="text-align:right;">

0.220

</td>

<td style="text-align:right;">

0.042

</td>

<td style="text-align:right;">

0.073

</td>

<td style="text-align:right;">

0.007

</td>

<td style="text-align:right;">

599293

</td>

<td style="text-align:right;">

38585

</td>

<td style="text-align:right;">

45654

</td>

<td style="text-align:right;">

11297

</td>

<td style="text-align:right;">

2198

</td>

<td style="text-align:right;">

134316567

</td>

<td style="text-align:right;">

3022.629

</td>

<td style="text-align:right;">

545220.0

</td>

<td style="text-align:right;">

12.270

</td>

<td style="text-align:right;">

610452.7

</td>

<td style="text-align:right;">

342.921

</td>

<td style="text-align:right;">

\-0.006

</td>

<td style="text-align:right;">

\-55489.38

</td>

<td style="text-align:right;">

\-651.918

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

34356

</td>

<td style="text-align:right;">

519308.4

</td>

<td style="text-align:right;">

83330.61

</td>

<td style="text-align:right;">

159909

</td>

<td style="text-align:right;">

15283.04

</td>

<td style="text-align:right;">

11430

</td>

<td style="text-align:right;">

0.018

</td>

<td style="text-align:right;">

0.133

</td>

<td style="text-align:right;">

0.150

</td>

<td style="text-align:right;">

0.087

</td>

<td style="text-align:right;">

19100

</td>

<td style="text-align:right;">

3516

</td>

<td style="text-align:right;">

6073

</td>

<td style="text-align:right;">

526

</td>

<td style="text-align:right;">

0.229

</td>

<td style="text-align:right;">

0.042

</td>

<td style="text-align:right;">

0.073

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

414292

</td>

<td style="text-align:right;">

30685

</td>

<td style="text-align:right;">

37225

</td>

<td style="text-align:right;">

9753

</td>

<td style="text-align:right;">

1652

</td>

<td style="text-align:right;">

99403761

</td>

<td style="text-align:right;">

2893.345

</td>

<td style="text-align:right;">

386761.5

</td>

<td style="text-align:right;">

11.257

</td>

<td style="text-align:right;">

559979.9

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

34551

</td>

<td style="text-align:right;">

521899.2

</td>

<td style="text-align:right;">

85341.65

</td>

<td style="text-align:right;">

158982

</td>

<td style="text-align:right;">

22400.11

</td>

<td style="text-align:right;">

11747

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.144

</td>

<td style="text-align:right;">

0.202

</td>

<td style="text-align:right;">

0.090

</td>

<td style="text-align:right;">

20133

</td>

<td style="text-align:right;">

3700

</td>

<td style="text-align:right;">

6110

</td>

<td style="text-align:right;">

575

</td>

<td style="text-align:right;">

0.236

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

0.007

</td>

<td style="text-align:right;">

414774

</td>

<td style="text-align:right;">

30550

</td>

<td style="text-align:right;">

39037

</td>

<td style="text-align:right;">

9806

</td>

<td style="text-align:right;">

1868

</td>

<td style="text-align:right;">

108843372

</td>

<td style="text-align:right;">

3150.223

</td>

<td style="text-align:right;">

388608.7

</td>

<td style="text-align:right;">

11.247

</td>

<td style="text-align:right;">

559219.5

</td>

<td style="text-align:right;">

256.878

</td>

<td style="text-align:right;">

\-0.010

</td>

<td style="text-align:right;">

\-25508.881

</td>

<td style="text-align:right;">

\-760.386

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

34563

</td>

<td style="text-align:right;">

520032.6

</td>

<td style="text-align:right;">

83599.60

</td>

<td style="text-align:right;">

155285

</td>

<td style="text-align:right;">

34958.90

</td>

<td style="text-align:right;">

11675

</td>

<td style="text-align:right;">

0.027

</td>

<td style="text-align:right;">

0.155

</td>

<td style="text-align:right;">

0.298

</td>

<td style="text-align:right;">

0.100

</td>

<td style="text-align:right;">

19124

</td>

<td style="text-align:right;">

3583

</td>

<td style="text-align:right;">

5953

</td>

<td style="text-align:right;">

540

</td>

<td style="text-align:right;">

0.229

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

414629

</td>

<td style="text-align:right;">

30279

</td>

<td style="text-align:right;">

37496

</td>

<td style="text-align:right;">

9970

</td>

<td style="text-align:right;">

1848

</td>

<td style="text-align:right;">

110988325

</td>

<td style="text-align:right;">

3211.189

</td>

<td style="text-align:right;">

387837.9

</td>

<td style="text-align:right;">

11.221

</td>

<td style="text-align:right;">

557848.2

</td>

<td style="text-align:right;">

317.844

</td>

<td style="text-align:right;">

\-0.036

</td>

<td style="text-align:right;">

\-8761.682

</td>

<td style="text-align:right;">

\-2131.674

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

34301

</td>

<td style="text-align:right;">

518241.3

</td>

<td style="text-align:right;">

82691.80

</td>

<td style="text-align:right;">

156565

</td>

<td style="text-align:right;">

27796.91

</td>

<td style="text-align:right;">

11594

</td>

<td style="text-align:right;">

0.024

</td>

<td style="text-align:right;">

0.147

</td>

<td style="text-align:right;">

0.243

</td>

<td style="text-align:right;">

0.096

</td>

<td style="text-align:right;">

18314

</td>

<td style="text-align:right;">

3526

</td>

<td style="text-align:right;">

5941

</td>

<td style="text-align:right;">

487

</td>

<td style="text-align:right;">

0.221

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

413822

</td>

<td style="text-align:right;">

30937

</td>

<td style="text-align:right;">

36729

</td>

<td style="text-align:right;">

9235

</td>

<td style="text-align:right;">

1761

</td>

<td style="text-align:right;">

105222878

</td>

<td style="text-align:right;">

3067.633

</td>

<td style="text-align:right;">

386391.6

</td>

<td style="text-align:right;">

11.265

</td>

<td style="text-align:right;">

560169.0

</td>

<td style="text-align:right;">

174.288

</td>

<td style="text-align:right;">

0.007

</td>

<td style="text-align:right;">

23979.455

</td>

<td style="text-align:right;">

189.123

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

34659

</td>

<td style="text-align:right;">

522111.4

</td>

<td style="text-align:right;">

84243.01

</td>

<td style="text-align:right;">

158157

</td>

<td style="text-align:right;">

25864.63

</td>

<td style="text-align:right;">

11355

</td>

<td style="text-align:right;">

0.022

</td>

<td style="text-align:right;">

0.152

</td>

<td style="text-align:right;">

0.234

</td>

<td style="text-align:right;">

0.096

</td>

<td style="text-align:right;">

19263

</td>

<td style="text-align:right;">

3609

</td>

<td style="text-align:right;">

6192

</td>

<td style="text-align:right;">

528

</td>

<td style="text-align:right;">

0.229

</td>

<td style="text-align:right;">

0.043

</td>

<td style="text-align:right;">

0.074

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

415985

</td>

<td style="text-align:right;">

31040

</td>

<td style="text-align:right;">

37639

</td>

<td style="text-align:right;">

9806

</td>

<td style="text-align:right;">

1680

</td>

<td style="text-align:right;">

110168857

</td>

<td style="text-align:right;">

3178.651

</td>

<td style="text-align:right;">

389142.1

</td>

<td style="text-align:right;">

11.228

</td>

<td style="text-align:right;">

558208.1

</td>

<td style="text-align:right;">

285.306

</td>

<td style="text-align:right;">

\-0.030

</td>

<td style="text-align:right;">

\-9596.935

</td>

<td style="text-align:right;">

\-1771.748

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

S1a

</td>

<td style="text-align:right;">

74371

</td>

<td style="text-align:right;">

181363804

</td>

<td style="text-align:right;">

2438.636

</td>

<td style="text-align:right;">

936417.1

</td>

<td style="text-align:right;">

12.591

</td>

<td style="text-align:right;">

3914.696

</td>

<td style="text-align:right;">

3274.290

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

74131

</td>

<td style="text-align:right;">

177946180

</td>

<td style="text-align:right;">

2400.429

</td>

<td style="text-align:right;">

930572.9

</td>

<td style="text-align:right;">

12.553

</td>

<td style="text-align:right;">

7275.584

</td>

<td style="text-align:right;">

1408.916

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

74640

</td>

<td style="text-align:right;">

177925068

</td>

<td style="text-align:right;">

2383.776

</td>

<td style="text-align:right;">

935793.1

</td>

<td style="text-align:right;">

12.537

</td>

<td style="text-align:right;">

12898.673

</td>

<td style="text-align:right;">

642.216

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

34301

</td>

<td style="text-align:right;">

105222878

</td>

<td style="text-align:right;">

3067.633

</td>

<td style="text-align:right;">

386391.6

</td>

<td style="text-align:right;">

11.265

</td>

<td style="text-align:right;">

23979.455

</td>

<td style="text-align:right;">

189.123

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCD

</td>

<td style="text-align:right;">

74381

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

44135

</td>

<td style="text-align:right;">

118268910

</td>

<td style="text-align:right;">

2679.708

</td>

<td style="text-align:right;">

541787.4

</td>

<td style="text-align:right;">

12.276

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

34356

</td>

<td style="text-align:right;">

99403761

</td>

<td style="text-align:right;">

2893.345

</td>

<td style="text-align:right;">

386761.5

</td>

<td style="text-align:right;">

11.257

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

44437

</td>

<td style="text-align:right;">

134316567

</td>

<td style="text-align:right;">

3022.629

</td>

<td style="text-align:right;">

545220.0

</td>

<td style="text-align:right;">

12.270

</td>

<td style="text-align:right;">

\-55489.376

</td>

<td style="text-align:right;">

\-651.918

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

34551

</td>

<td style="text-align:right;">

108843372

</td>

<td style="text-align:right;">

3150.223

</td>

<td style="text-align:right;">

388608.7

</td>

<td style="text-align:right;">

11.247

</td>

<td style="text-align:right;">

\-25508.881

</td>

<td style="text-align:right;">

\-760.386

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

34659

</td>

<td style="text-align:right;">

110168857

</td>

<td style="text-align:right;">

3178.651

</td>

<td style="text-align:right;">

389142.1

</td>

<td style="text-align:right;">

11.228

</td>

<td style="text-align:right;">

\-9596.935

</td>

<td style="text-align:right;">

\-1771.748

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

34563

</td>

<td style="text-align:right;">

110988325

</td>

<td style="text-align:right;">

3211.189

</td>

<td style="text-align:right;">

387837.9

</td>

<td style="text-align:right;">

11.221

</td>

<td style="text-align:right;">

\-8761.682

</td>

<td style="text-align:right;">

\-2131.674

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

0.0000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

74371

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

181363804

</td>

<td style="text-align:right;">

2438.636

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2438.636

</td>

<td style="text-align:right;">

936417.1

</td>

<td style="text-align:right;">

12.59116

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.59116

</td>

<td style="text-align:right;">

269.84612

</td>

<td style="text-align:right;">

0.0525842

</td>

<td style="text-align:right;">

5131.693

</td>

<td style="text-align:right;">

3914.696

</td>

<td style="text-align:right;">

2359.3652

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

74640

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

177925068

</td>

<td style="text-align:right;">

2383.776

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2383.776

</td>

<td style="text-align:right;">

935793.1

</td>

<td style="text-align:right;">

12.53742

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.53742

</td>

<td style="text-align:right;">

214.98640

</td>

<td style="text-align:right;">

\-0.0011544

</td>

<td style="text-align:right;">

\-186225.931

</td>

<td style="text-align:right;">

12898.673

</td>

<td style="text-align:right;">

\-272.7083

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

74131

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

177946180

</td>

<td style="text-align:right;">

2400.429

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2400.429

</td>

<td style="text-align:right;">

930572.9

</td>

<td style="text-align:right;">

12.55309

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.55309

</td>

<td style="text-align:right;">

231.63873

</td>

<td style="text-align:right;">

0.0145126

</td>

<td style="text-align:right;">

15961.217

</td>

<td style="text-align:right;">

7275.584

</td>

<td style="text-align:right;">

493.9912

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

44135

</td>

<td style="text-align:right;">

0.5930689

</td>

<td style="text-align:right;">

118268910

</td>

<td style="text-align:right;">

2679.708

</td>

<td style="text-align:right;">

1424.169

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

541787.4

</td>

<td style="text-align:right;">

12.27569

</td>

<td style="text-align:right;">

12.92171

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

0.0000

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

44437

</td>

<td style="text-align:right;">

0.5971270

</td>

<td style="text-align:right;">

134316567

</td>

<td style="text-align:right;">

3022.629

</td>

<td style="text-align:right;">

1424.169

</td>

<td style="text-align:right;">

2378.653

</td>

<td style="text-align:right;">

545220.0

</td>

<td style="text-align:right;">

12.26951

</td>

<td style="text-align:right;">

12.92171

</td>

<td style="text-align:right;">

12.53226

</td>

<td style="text-align:right;">

209.86265

</td>

<td style="text-align:right;">

\-0.0063119

</td>

<td style="text-align:right;">

\-33248.758

</td>

<td style="text-align:right;">

\-55489.376

</td>

<td style="text-align:right;">

\-525.4574

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

34356

</td>

<td style="text-align:right;">

0.4616625

</td>

<td style="text-align:right;">

99403761

</td>

<td style="text-align:right;">

2893.345

</td>

<td style="text-align:right;">

1547.433

</td>

<td style="text-align:right;">

2168.790

</td>

<td style="text-align:right;">

386761.5

</td>

<td style="text-align:right;">

11.25746

</td>

<td style="text-align:right;">

13.63722

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

0.0000

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

34551

</td>

<td style="text-align:right;">

0.4642828

</td>

<td style="text-align:right;">

108843372

</td>

<td style="text-align:right;">

3150.223

</td>

<td style="text-align:right;">

1547.433

</td>

<td style="text-align:right;">

2291.581

</td>

<td style="text-align:right;">

388608.7

</td>

<td style="text-align:right;">

11.24739

</td>

<td style="text-align:right;">

13.63722

</td>

<td style="text-align:right;">

12.52766

</td>

<td style="text-align:right;">

122.79100

</td>

<td style="text-align:right;">

\-0.0109111

</td>

<td style="text-align:right;">

\-11253.719

</td>

<td style="text-align:right;">

\-25508.881

</td>

<td style="text-align:right;">

\-668.3485

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

34563

</td>

<td style="text-align:right;">

0.4644441

</td>

<td style="text-align:right;">

110988325

</td>

<td style="text-align:right;">

3211.189

</td>

<td style="text-align:right;">

1547.433

</td>

<td style="text-align:right;">

2320.154

</td>

<td style="text-align:right;">

387837.9

</td>

<td style="text-align:right;">

11.22119

</td>

<td style="text-align:right;">

13.63722

</td>

<td style="text-align:right;">

12.51511

</td>

<td style="text-align:right;">

151.36453

</td>

<td style="text-align:right;">

\-0.0234679

</td>

<td style="text-align:right;">

\-6449.844

</td>

<td style="text-align:right;">

\-8761.682

</td>

<td style="text-align:right;">

\-1324.7613

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

34301

</td>

<td style="text-align:right;">

0.4609234

</td>

<td style="text-align:right;">

105222878

</td>

<td style="text-align:right;">

3067.633

</td>

<td style="text-align:right;">

1547.433

</td>

<td style="text-align:right;">

2248.129

</td>

<td style="text-align:right;">

386391.6

</td>

<td style="text-align:right;">

11.26473

</td>

<td style="text-align:right;">

13.63722

</td>

<td style="text-align:right;">

12.54368

</td>

<td style="text-align:right;">

79.33867

</td>

<td style="text-align:right;">

0.0051089

</td>

<td style="text-align:right;">

15529.523

</td>

<td style="text-align:right;">

23979.455

</td>

<td style="text-align:right;">

176.1060

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

34659

</td>

<td style="text-align:right;">

0.4657341

</td>

<td style="text-align:right;">

110168857

</td>

<td style="text-align:right;">

3178.651

</td>

<td style="text-align:right;">

1547.433

</td>

<td style="text-align:right;">

2307.147

</td>

<td style="text-align:right;">

389142.1

</td>

<td style="text-align:right;">

11.22774

</td>

<td style="text-align:right;">

13.63722

</td>

<td style="text-align:right;">

12.51504

</td>

<td style="text-align:right;">

138.35662

</td>

<td style="text-align:right;">

\-0.0235351

</td>

<td style="text-align:right;">

\-5878.729

</td>

<td style="text-align:right;">

\-9596.935

</td>

<td style="text-align:right;">

\-1315.1130

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

0.0259818

</td>

<td style="text-align:right;">

0.1583615

</td>

<td style="text-align:right;">

0.3080320

</td>

<td style="text-align:right;">

0.0926126

</td>

<td style="text-align:right;">

0.4002232

</td>

<td style="text-align:right;">

0.0747065

</td>

<td style="text-align:right;">

0.1288540

</td>

<td style="text-align:right;">

0.0101653

</td>

<td style="text-align:right;">

0.8413751

</td>

<td style="text-align:right;">

0.0473895

</td>

<td style="text-align:right;">

0.0488810

</td>

<td style="text-align:right;">

0.0110959

</td>

<td style="text-align:right;">

0.0019607

</td>

<td style="text-align:right;">

0.4630577

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

0.0216880

</td>

<td style="text-align:right;">

0.1432150

</td>

<td style="text-align:right;">

0.2356416

</td>

<td style="text-align:right;">

0.0869118

</td>

<td style="text-align:right;">

0.4117363

</td>

<td style="text-align:right;">

0.0790997

</td>

<td style="text-align:right;">

0.1302519

</td>

<td style="text-align:right;">

0.0110263

</td>

<td style="text-align:right;">

0.8406970

</td>

<td style="text-align:right;">

0.0462288

</td>

<td style="text-align:right;">

0.0505618

</td>

<td style="text-align:right;">

0.0110877

</td>

<td style="text-align:right;">

0.0020765

</td>

<td style="text-align:right;">

0.3298075

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

0.0202337

</td>

<td style="text-align:right;">

0.1443276

</td>

<td style="text-align:right;">

0.2128990

</td>

<td style="text-align:right;">

0.0867424

</td>

<td style="text-align:right;">

0.4059570

</td>

<td style="text-align:right;">

0.0771067

</td>

<td style="text-align:right;">

0.1306471

</td>

<td style="text-align:right;">

0.0115201

</td>

<td style="text-align:right;">

0.8422463

</td>

<td style="text-align:right;">

0.0462893

</td>

<td style="text-align:right;">

0.0492669

</td>

<td style="text-align:right;">

0.0107943

</td>

<td style="text-align:right;">

0.0020032

</td>

<td style="text-align:right;">

0.2879159

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

0.5930689

</td>

<td style="text-align:right;">

0.5822713

</td>

<td style="text-align:right;">

0.6947616

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

0.5971270

</td>

<td style="text-align:right;">

0.5857120

</td>

<td style="text-align:right;">

0.7157888

</td>

<td style="text-align:right;">

0.0223715

</td>

<td style="text-align:right;">

0.1509734

</td>

<td style="text-align:right;">

0.2309847

</td>

<td style="text-align:right;">

0.0932007

</td>

<td style="text-align:right;">

0.4138267

</td>

<td style="text-align:right;">

0.0785267

</td>

<td style="text-align:right;">

0.1344150

</td>

<td style="text-align:right;">

0.0122305

</td>

<td style="text-align:right;">

0.8396422

</td>

<td style="text-align:right;">

0.0475609

</td>

<td style="text-align:right;">

0.0500610

</td>

<td style="text-align:right;">

0.0114208

</td>

<td style="text-align:right;">

0.0020331

</td>

<td style="text-align:right;">

0.3093289

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

0.4616625

</td>

<td style="text-align:right;">

0.4148335

</td>

<td style="text-align:right;">

0.5806002

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

0.4642828

</td>

<td style="text-align:right;">

0.4169031

</td>

<td style="text-align:right;">

0.5946120

</td>

<td style="text-align:right;">

0.0202534

</td>

<td style="text-align:right;">

0.1429375

</td>

<td style="text-align:right;">

0.1846437

</td>

<td style="text-align:right;">

0.0838074

</td>

<td style="text-align:right;">

0.4306314

</td>

<td style="text-align:right;">

0.0801142

</td>

<td style="text-align:right;">

0.1318818

</td>

<td style="text-align:right;">

0.0117450

</td>

<td style="text-align:right;">

0.8402016

</td>

<td style="text-align:right;">

0.0465222

</td>

<td style="text-align:right;">

0.0504943

</td>

<td style="text-align:right;">

0.0112480

</td>

<td style="text-align:right;">

0.0021839

</td>

<td style="text-align:right;">

0.2358683

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

0.4644441

</td>

<td style="text-align:right;">

0.4154120

</td>

<td style="text-align:right;">

0.5824744

</td>

<td style="text-align:right;">

0.0226421

</td>

<td style="text-align:right;">

0.1493047

</td>

<td style="text-align:right;">

0.2398231

</td>

<td style="text-align:right;">

0.0896675

</td>

<td style="text-align:right;">

0.4170247

</td>

<td style="text-align:right;">

0.0785328

</td>

<td style="text-align:right;">

0.1297571

</td>

<td style="text-align:right;">

0.0112734

</td>

<td style="text-align:right;">

0.8413870

</td>

<td style="text-align:right;">

0.0463623

</td>

<td style="text-align:right;">

0.0493127

</td>

<td style="text-align:right;">

0.0113878

</td>

<td style="text-align:right;">

0.0021697

</td>

<td style="text-align:right;">

0.3257599

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

0.4609234

</td>

<td style="text-align:right;">

0.4139811

</td>

<td style="text-align:right;">

0.5761494

</td>

<td style="text-align:right;">

0.0211846

</td>

<td style="text-align:right;">

0.1445871

</td>

<td style="text-align:right;">

0.2070448

</td>

<td style="text-align:right;">

0.0872712

</td>

<td style="text-align:right;">

0.4071923

</td>

<td style="text-align:right;">

0.0779666

</td>

<td style="text-align:right;">

0.1299230

</td>

<td style="text-align:right;">

0.0105877

</td>

<td style="text-align:right;">

0.8419912

</td>

<td style="text-align:right;">

0.0469422

</td>

<td style="text-align:right;">

0.0487474

</td>

<td style="text-align:right;">

0.0108090

</td>

<td style="text-align:right;">

0.0021019

</td>

<td style="text-align:right;">

0.2771043

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

0.4657341

</td>

<td style="text-align:right;">

0.4170726

</td>

<td style="text-align:right;">

0.5869573

</td>

<td style="text-align:right;">

0.0204131

</td>

<td style="text-align:right;">

0.1473942

</td>

<td style="text-align:right;">

0.2030083

</td>

<td style="text-align:right;">

0.0873917

</td>

<td style="text-align:right;">

0.4185070

</td>

<td style="text-align:right;">

0.0788090

</td>

<td style="text-align:right;">

0.1328488

</td>

<td style="text-align:right;">

0.0111025

</td>

<td style="text-align:right;">

0.8410210

</td>

<td style="text-align:right;">

0.0469072

</td>

<td style="text-align:right;">

0.0493720

</td>

<td style="text-align:right;">

0.0112470

</td>

<td style="text-align:right;">

0.0020335

</td>

<td style="text-align:right;">

0.2615138

</td>

</tr>

</tbody>

</table>
