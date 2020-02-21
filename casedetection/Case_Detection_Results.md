Case Detection Scenario Main Analysis
================
21 February, 2020

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

744269

</td>

<td style="text-align:right;">

12528884

</td>

<td style="text-align:right;">

1432236

</td>

<td style="text-align:right;">

3821799

</td>

<td style="text-align:right;">

266594.9

</td>

<td style="text-align:right;">

267294

</td>

<td style="text-align:right;">

0.017

</td>

<td style="text-align:right;">

0.136

</td>

<td style="text-align:right;">

0.152

</td>

<td style="text-align:right;">

0.080

</td>

<td style="text-align:right;">

311920.0

</td>

<td style="text-align:right;">

58468.0

</td>

<td style="text-align:right;">

97515.0

</td>

<td style="text-align:right;">

8375

</td>

<td style="text-align:right;">

0.218

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.068

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

10548526

</td>

<td style="text-align:right;">

581070

</td>

<td style="text-align:right;">

619058.0

</td>

<td style="text-align:right;">

137875

</td>

<td style="text-align:right;">

24213

</td>

<td style="text-align:right;">

1606055932

</td>

<td style="text-align:right;">

2157.897

</td>

<td style="text-align:right;">

9338608

</td>

<td style="text-align:right;">

12.547

</td>

<td style="text-align:right;">

625209.9

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

743618

</td>

<td style="text-align:right;">

12519993

</td>

<td style="text-align:right;">

1423050

</td>

<td style="text-align:right;">

2493413

</td>

<td style="text-align:right;">

266532.5

</td>

<td style="text-align:right;">

326966

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.135

</td>

<td style="text-align:right;">

0.151

</td>

<td style="text-align:right;">

0.080

</td>

<td style="text-align:right;">

309851.0

</td>

<td style="text-align:right;">

57833.0

</td>

<td style="text-align:right;">

96592.0

</td>

<td style="text-align:right;">

8349

</td>

<td style="text-align:right;">

0.218

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.068

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

10548868

</td>

<td style="text-align:right;">

577142

</td>

<td style="text-align:right;">

613079.0

</td>

<td style="text-align:right;">

139011

</td>

<td style="text-align:right;">

24293

</td>

<td style="text-align:right;">

1596581895

</td>

<td style="text-align:right;">

2147.046

</td>

<td style="text-align:right;">

9332708

</td>

<td style="text-align:right;">

12.550

</td>

<td style="text-align:right;">

625373.3

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

743944

</td>

<td style="text-align:right;">

12524438

</td>

<td style="text-align:right;">

1427643

</td>

<td style="text-align:right;">

3157606

</td>

<td style="text-align:right;">

266563.7

</td>

<td style="text-align:right;">

297130

</td>

<td style="text-align:right;">

0.019

</td>

<td style="text-align:right;">

0.135

</td>

<td style="text-align:right;">

0.151

</td>

<td style="text-align:right;">

0.080

</td>

<td style="text-align:right;">

310885.5

</td>

<td style="text-align:right;">

58150.5

</td>

<td style="text-align:right;">

97053.5

</td>

<td style="text-align:right;">

8362

</td>

<td style="text-align:right;">

0.218

</td>

<td style="text-align:right;">

0.041

</td>

<td style="text-align:right;">

0.068

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

10548697

</td>

<td style="text-align:right;">

579106

</td>

<td style="text-align:right;">

616068.5

</td>

<td style="text-align:right;">

138443

</td>

<td style="text-align:right;">

24253

</td>

<td style="text-align:right;">

1601318913

</td>

<td style="text-align:right;">

2152.474

</td>

<td style="text-align:right;">

9335658

</td>

<td style="text-align:right;">

12.549

</td>

<td style="text-align:right;">

625291.6

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

743564

</td>

<td style="text-align:right;">

12515614

</td>

<td style="text-align:right;">

1424207

</td>

<td style="text-align:right;">

3720384

</td>

<td style="text-align:right;">

661458.0

</td>

<td style="text-align:right;">

266677

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

0.159

</td>

<td style="text-align:right;">

0.310

</td>

<td style="text-align:right;">

0.094

</td>

<td style="text-align:right;">

297936.0

</td>

<td style="text-align:right;">

55789.0

</td>

<td style="text-align:right;">

95052.0

</td>

<td style="text-align:right;">

8268

</td>

<td style="text-align:right;">

0.209

</td>

<td style="text-align:right;">

0.039

</td>

<td style="text-align:right;">

0.067

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

10543334

</td>

<td style="text-align:right;">

580186

</td>

<td style="text-align:right;">

613031.0

</td>

<td style="text-align:right;">

138162

</td>

<td style="text-align:right;">

23168

</td>

<td style="text-align:right;">

1812706723

</td>

<td style="text-align:right;">

2437.862

</td>

<td style="text-align:right;">

9338959

</td>

<td style="text-align:right;">

12.560

</td>

<td style="text-align:right;">

625548.4

</td>

<td style="text-align:right;">

279.965

</td>

<td style="text-align:right;">

0.012

</td>

<td style="text-align:right;">

22634.75

</td>

<td style="text-align:right;">

338.476

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

744031

</td>

<td style="text-align:right;">

12527232

</td>

<td style="text-align:right;">

1423476

</td>

<td style="text-align:right;">

3771104

</td>

<td style="text-align:right;">

472651.8

</td>

<td style="text-align:right;">

267732

</td>

<td style="text-align:right;">

0.022

</td>

<td style="text-align:right;">

0.147

</td>

<td style="text-align:right;">

0.239

</td>

<td style="text-align:right;">

0.086

</td>

<td style="text-align:right;">

300061.0

</td>

<td style="text-align:right;">

56282.0

</td>

<td style="text-align:right;">

95022.0

</td>

<td style="text-align:right;">

8238

</td>

<td style="text-align:right;">

0.211

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

10555170

</td>

<td style="text-align:right;">

579985

</td>

<td style="text-align:right;">

611930.0

</td>

<td style="text-align:right;">

137971

</td>

<td style="text-align:right;">

24093

</td>

<td style="text-align:right;">

1744953853

</td>

<td style="text-align:right;">

2345.270

</td>

<td style="text-align:right;">

9343234

</td>

<td style="text-align:right;">

12.558

</td>

<td style="text-align:right;">

625534.1

</td>

<td style="text-align:right;">

187.373

</td>

<td style="text-align:right;">

0.010

</td>

<td style="text-align:right;">

18315.17

</td>

<td style="text-align:right;">

324.151

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

744241

</td>

<td style="text-align:right;">

12526040

</td>

<td style="text-align:right;">

1425468

</td>

<td style="text-align:right;">

3785287

</td>

<td style="text-align:right;">

410729.5

</td>

<td style="text-align:right;">

268195

</td>

<td style="text-align:right;">

0.020

</td>

<td style="text-align:right;">

0.145

</td>

<td style="text-align:right;">

0.215

</td>

<td style="text-align:right;">

0.086

</td>

<td style="text-align:right;">

306630.0

</td>

<td style="text-align:right;">

57102.0

</td>

<td style="text-align:right;">

96921.0

</td>

<td style="text-align:right;">

8185

</td>

<td style="text-align:right;">

0.215

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

10552130

</td>

<td style="text-align:right;">

579912

</td>

<td style="text-align:right;">

613803.0

</td>

<td style="text-align:right;">

138064

</td>

<td style="text-align:right;">

23945

</td>

<td style="text-align:right;">

1780680593

</td>

<td style="text-align:right;">

2392.613

</td>

<td style="text-align:right;">

9340657

</td>

<td style="text-align:right;">

12.551

</td>

<td style="text-align:right;">

625136.4

</td>

<td style="text-align:right;">

234.716

</td>

<td style="text-align:right;">

0.003

</td>

<td style="text-align:right;">

72784.35

</td>

<td style="text-align:right;">

\-73.475

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

442071

</td>

<td style="text-align:right;">

7301813

</td>

<td style="text-align:right;">

1004217

</td>

<td style="text-align:right;">

2222169

</td>

<td style="text-align:right;">

194185.5

</td>

<td style="text-align:right;">

155392

</td>

<td style="text-align:right;">

0.017

</td>

<td style="text-align:right;">

0.142

</td>

<td style="text-align:right;">

0.160

</td>

<td style="text-align:right;">

0.087

</td>

<td style="text-align:right;">

230921

</td>

<td style="text-align:right;">

42479

</td>

<td style="text-align:right;">

71098

</td>

<td style="text-align:right;">

6134

</td>

<td style="text-align:right;">

0.230

</td>

<td style="text-align:right;">

0.042

</td>

<td style="text-align:right;">

0.071

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

5985813

</td>

<td style="text-align:right;">

372679

</td>

<td style="text-align:right;">

449840

</td>

<td style="text-align:right;">

111511

</td>

<td style="text-align:right;">

20882

</td>

<td style="text-align:right;">

1178953040

</td>

<td style="text-align:right;">

2666.886

</td>

<td style="text-align:right;">

5426607

</td>

<td style="text-align:right;">

12.275

</td>

<td style="text-align:right;">

611104.1

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

441660

</td>

<td style="text-align:right;">

7298015

</td>

<td style="text-align:right;">

1012943

</td>

<td style="text-align:right;">

2177696

</td>

<td style="text-align:right;">

370373.4

</td>

<td style="text-align:right;">

153713

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.157

</td>

<td style="text-align:right;">

0.266

</td>

<td style="text-align:right;">

0.097

</td>

<td style="text-align:right;">

223645

</td>

<td style="text-align:right;">

41796

</td>

<td style="text-align:right;">

70081

</td>

<td style="text-align:right;">

6194

</td>

<td style="text-align:right;">

0.221

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

5973884

</td>

<td style="text-align:right;">

378523

</td>

<td style="text-align:right;">

452398

</td>

<td style="text-align:right;">

111720

</td>

<td style="text-align:right;">

20671

</td>

<td style="text-align:right;">

1280999360

</td>

<td style="text-align:right;">

2900.420

</td>

<td style="text-align:right;">

5427506

</td>

<td style="text-align:right;">

12.289

</td>

<td style="text-align:right;">

611543.5

</td>

<td style="text-align:right;">

233.534

</td>

<td style="text-align:right;">

0.013

</td>

<td style="text-align:right;">

17352.98

</td>

<td style="text-align:right;">

439.358

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

345121

</td>

<td style="text-align:right;">

5207056

</td>

<td style="text-align:right;">

832780.5

</td>

<td style="text-align:right;">

1603629

</td>

<td style="text-align:right;">

155214.3

</td>

<td style="text-align:right;">

115810

</td>

<td style="text-align:right;">

0.018

</td>

<td style="text-align:right;">

0.136

</td>

<td style="text-align:right;">

0.153

</td>

<td style="text-align:right;">

0.085

</td>

<td style="text-align:right;">

195158

</td>

<td style="text-align:right;">

36023

</td>

<td style="text-align:right;">

60353

</td>

<td style="text-align:right;">

5106

</td>

<td style="text-align:right;">

0.234

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

4155978

</td>

<td style="text-align:right;">

304655

</td>

<td style="text-align:right;">

372833

</td>

<td style="text-align:right;">

96398

</td>

<td style="text-align:right;">

18706

</td>

<td style="text-align:right;">

992079433

</td>

<td style="text-align:right;">

2874.584

</td>

<td style="text-align:right;">

3878332

</td>

<td style="text-align:right;">

11.238

</td>

<td style="text-align:right;">

559005.4

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

344998

</td>

<td style="text-align:right;">

5200765

</td>

<td style="text-align:right;">

838543.3

</td>

<td style="text-align:right;">

1585219

</td>

<td style="text-align:right;">

221257.8

</td>

<td style="text-align:right;">

116526

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.143

</td>

<td style="text-align:right;">

0.204

</td>

<td style="text-align:right;">

0.090

</td>

<td style="text-align:right;">

194391

</td>

<td style="text-align:right;">

36593

</td>

<td style="text-align:right;">

60645

</td>

<td style="text-align:right;">

5112

</td>

<td style="text-align:right;">

0.232

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

4144767

</td>

<td style="text-align:right;">

305848

</td>

<td style="text-align:right;">

376805

</td>

<td style="text-align:right;">

96609

</td>

<td style="text-align:right;">

18754

</td>

<td style="text-align:right;">

1062671232

</td>

<td style="text-align:right;">

3080.224

</td>

<td style="text-align:right;">

3874688

</td>

<td style="text-align:right;">

11.231

</td>

<td style="text-align:right;">

558472.0

</td>

<td style="text-align:right;">

205.640

</td>

<td style="text-align:right;">

\-0.007

</td>

<td style="text-align:right;">

\-31365.01

</td>

<td style="text-align:right;">

\-533.457

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

345141

</td>

<td style="text-align:right;">

5208656

</td>

<td style="text-align:right;">

836580.0

</td>

<td style="text-align:right;">

1556390

</td>

<td style="text-align:right;">

345910.1

</td>

<td style="text-align:right;">

116671

</td>

<td style="text-align:right;">

0.027

</td>

<td style="text-align:right;">

0.159

</td>

<td style="text-align:right;">

0.295

</td>

<td style="text-align:right;">

0.101

</td>

<td style="text-align:right;">

191380

</td>

<td style="text-align:right;">

36018

</td>

<td style="text-align:right;">

60214

</td>

<td style="text-align:right;">

5305

</td>

<td style="text-align:right;">

0.229

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

4154135

</td>

<td style="text-align:right;">

303477

</td>

<td style="text-align:right;">

377393

</td>

<td style="text-align:right;">

97243

</td>

<td style="text-align:right;">

18184

</td>

<td style="text-align:right;">

1111343559

</td>

<td style="text-align:right;">

3219.970

</td>

<td style="text-align:right;">

3883610

</td>

<td style="text-align:right;">

11.252

</td>

<td style="text-align:right;">

559392.1

</td>

<td style="text-align:right;">

345.385

</td>

<td style="text-align:right;">

0.015

</td>

<td style="text-align:right;">

23590.83

</td>

<td style="text-align:right;">

386.648

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

345874

</td>

<td style="text-align:right;">

5214195

</td>

<td style="text-align:right;">

837512.1

</td>

<td style="text-align:right;">

1575141

</td>

<td style="text-align:right;">

280292.9

</td>

<td style="text-align:right;">

117110

</td>

<td style="text-align:right;">

0.024

</td>

<td style="text-align:right;">

0.147

</td>

<td style="text-align:right;">

0.246

</td>

<td style="text-align:right;">

0.093

</td>

<td style="text-align:right;">

191211

</td>

<td style="text-align:right;">

36018

</td>

<td style="text-align:right;">

59550

</td>

<td style="text-align:right;">

5099

</td>

<td style="text-align:right;">

0.228

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

4158258

</td>

<td style="text-align:right;">

307714

</td>

<td style="text-align:right;">

375606

</td>

<td style="text-align:right;">

95828

</td>

<td style="text-align:right;">

18029

</td>

<td style="text-align:right;">

1068503274

</td>

<td style="text-align:right;">

3089.285

</td>

<td style="text-align:right;">

3886759

</td>

<td style="text-align:right;">

11.238

</td>

<td style="text-align:right;">

558785.7

</td>

<td style="text-align:right;">

214.700

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

\-2149723.33

</td>

<td style="text-align:right;">

\-219.694

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

344548

</td>

<td style="text-align:right;">

5199315

</td>

<td style="text-align:right;">

838281.5

</td>

<td style="text-align:right;">

1576249

</td>

<td style="text-align:right;">

254354.4

</td>

<td style="text-align:right;">

116872

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.145

</td>

<td style="text-align:right;">

0.229

</td>

<td style="text-align:right;">

0.092

</td>

<td style="text-align:right;">

193867

</td>

<td style="text-align:right;">

36387

</td>

<td style="text-align:right;">

60101

</td>

<td style="text-align:right;">

5177

</td>

<td style="text-align:right;">

0.231

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

4143537

</td>

<td style="text-align:right;">

304775

</td>

<td style="text-align:right;">

375816

</td>

<td style="text-align:right;">

98563

</td>

<td style="text-align:right;">

18531

</td>

<td style="text-align:right;">

1083688031

</td>

<td style="text-align:right;">

3145.245

</td>

<td style="text-align:right;">

3874067

</td>

<td style="text-align:right;">

11.244

</td>

<td style="text-align:right;">

559050.3

</td>

<td style="text-align:right;">

270.661

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

42890.68

</td>

<td style="text-align:right;">

44.863

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

S2a

</td>

<td style="text-align:right;">

441660

</td>

<td style="text-align:right;">

1280999360

</td>

<td style="text-align:right;">

2900.420

</td>

<td style="text-align:right;">

5427506

</td>

<td style="text-align:right;">

12.289

</td>

<td style="text-align:right;">

17352.98

</td>

<td style="text-align:right;">

439.358

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

345141

</td>

<td style="text-align:right;">

1111343559

</td>

<td style="text-align:right;">

3219.970

</td>

<td style="text-align:right;">

3883610

</td>

<td style="text-align:right;">

11.252

</td>

<td style="text-align:right;">

23590.83

</td>

<td style="text-align:right;">

386.648

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

743564

</td>

<td style="text-align:right;">

1812706723

</td>

<td style="text-align:right;">

2437.862

</td>

<td style="text-align:right;">

9338959

</td>

<td style="text-align:right;">

12.560

</td>

<td style="text-align:right;">

22634.75

</td>

<td style="text-align:right;">

338.476

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

744031

</td>

<td style="text-align:right;">

1744953853

</td>

<td style="text-align:right;">

2345.270

</td>

<td style="text-align:right;">

9343234

</td>

<td style="text-align:right;">

12.558

</td>

<td style="text-align:right;">

18315.17

</td>

<td style="text-align:right;">

324.151

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

344548

</td>

<td style="text-align:right;">

1083688031

</td>

<td style="text-align:right;">

3145.245

</td>

<td style="text-align:right;">

3874067

</td>

<td style="text-align:right;">

11.244

</td>

<td style="text-align:right;">

42890.68

</td>

<td style="text-align:right;">

44.863

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCD

</td>

<td style="text-align:right;">

744269

</td>

<td style="text-align:right;">

1606055932

</td>

<td style="text-align:right;">

2157.897

</td>

<td style="text-align:right;">

9338608

</td>

<td style="text-align:right;">

12.547

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

442071

</td>

<td style="text-align:right;">

1178953040

</td>

<td style="text-align:right;">

2666.886

</td>

<td style="text-align:right;">

5426607

</td>

<td style="text-align:right;">

12.275

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

345121

</td>

<td style="text-align:right;">

992079433

</td>

<td style="text-align:right;">

2874.584

</td>

<td style="text-align:right;">

3878332

</td>

<td style="text-align:right;">

11.238

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

744241

</td>

<td style="text-align:right;">

1780680593

</td>

<td style="text-align:right;">

2392.613

</td>

<td style="text-align:right;">

9340657

</td>

<td style="text-align:right;">

12.551

</td>

<td style="text-align:right;">

72784.35

</td>

<td style="text-align:right;">

\-73.475

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

345874

</td>

<td style="text-align:right;">

1068503274

</td>

<td style="text-align:right;">

3089.285

</td>

<td style="text-align:right;">

3886759

</td>

<td style="text-align:right;">

11.238

</td>

<td style="text-align:right;">

\-2149723.33

</td>

<td style="text-align:right;">

\-219.694

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

344998

</td>

<td style="text-align:right;">

1062671232

</td>

<td style="text-align:right;">

3080.224

</td>

<td style="text-align:right;">

3874688

</td>

<td style="text-align:right;">

11.231

</td>

<td style="text-align:right;">

\-31365.01

</td>

<td style="text-align:right;">

\-533.457

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

743944

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1601318913

</td>

<td style="text-align:right;">

2152.474

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2152.474

</td>

<td style="text-align:right;">

9335658

</td>

<td style="text-align:right;">

12.54888

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.54888

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

0.0000000

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

743564

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1812706723

</td>

<td style="text-align:right;">

2437.862

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2437.862

</td>

<td style="text-align:right;">

9338959

</td>

<td style="text-align:right;">

12.55972

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.55972

</td>

<td style="text-align:right;">

285.38858

</td>

<td style="text-align:right;">

0.0108442

</td>

<td style="text-align:right;">

26317.13

</td>

<td style="text-align:right;">

22634.75

</td>

<td style="text-align:right;">

256.8220164

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

744031

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1744953853

</td>

<td style="text-align:right;">

2345.270

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2345.270

</td>

<td style="text-align:right;">

9343234

</td>

<td style="text-align:right;">

12.55759

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.55759

</td>

<td style="text-align:right;">

192.79653

</td>

<td style="text-align:right;">

0.0087059

</td>

<td style="text-align:right;">

22145.56

</td>

<td style="text-align:right;">

18315.17

</td>

<td style="text-align:right;">

242.4974425

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

744241

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1780680593

</td>

<td style="text-align:right;">

2392.613

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2392.613

</td>

<td style="text-align:right;">

9340657

</td>

<td style="text-align:right;">

12.55058

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.55058

</td>

<td style="text-align:right;">

240.13904

</td>

<td style="text-align:right;">

0.0017002

</td>

<td style="text-align:right;">

141241.95

</td>

<td style="text-align:right;">

72784.35

</td>

<td style="text-align:right;">

\-155.1292236

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

442071

</td>

<td style="text-align:right;">

0.5942262

</td>

<td style="text-align:right;">

1178953040

</td>

<td style="text-align:right;">

2666.886

</td>

<td style="text-align:right;">

1399.151

</td>

<td style="text-align:right;">

2152.472

</td>

<td style="text-align:right;">

5426607

</td>

<td style="text-align:right;">

12.27542

</td>

<td style="text-align:right;">

12.94932

</td>

<td style="text-align:right;">

12.54887

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

\-0.4202545

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

441660

</td>

<td style="text-align:right;">

0.5936737

</td>

<td style="text-align:right;">

1280999360

</td>

<td style="text-align:right;">

2900.420

</td>

<td style="text-align:right;">

1399.151

</td>

<td style="text-align:right;">

2290.415

</td>

<td style="text-align:right;">

5427506

</td>

<td style="text-align:right;">

12.28888

</td>

<td style="text-align:right;">

12.94932

</td>

<td style="text-align:right;">

12.55723

</td>

<td style="text-align:right;">

137.94233

</td>

<td style="text-align:right;">

0.0083619

</td>

<td style="text-align:right;">

16496.59

</td>

<td style="text-align:right;">

17352.98

</td>

<td style="text-align:right;">

279.7308343

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

345121

</td>

<td style="text-align:right;">

0.4639072

</td>

<td style="text-align:right;">

992079433

</td>

<td style="text-align:right;">

2874.584

</td>

<td style="text-align:right;">

1527.594

</td>

<td style="text-align:right;">

2152.472

</td>

<td style="text-align:right;">

3878332

</td>

<td style="text-align:right;">

11.23760

</td>

<td style="text-align:right;">

13.68358

</td>

<td style="text-align:right;">

12.54887

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

\-0.4202545

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

344998

</td>

<td style="text-align:right;">

0.4637419

</td>

<td style="text-align:right;">

1062671232

</td>

<td style="text-align:right;">

3080.224

</td>

<td style="text-align:right;">

1527.594

</td>

<td style="text-align:right;">

2247.614

</td>

<td style="text-align:right;">

3874688

</td>

<td style="text-align:right;">

11.23104

</td>

<td style="text-align:right;">

13.68358

</td>

<td style="text-align:right;">

12.54624

</td>

<td style="text-align:right;">

95.14116

</td>

<td style="text-align:right;">

\-0.0026360

</td>

<td style="text-align:right;">

\-36092.36

</td>

<td style="text-align:right;">

\-31365.01

</td>

<td style="text-align:right;">

\-227.3637776

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

345141

</td>

<td style="text-align:right;">

0.4639341

</td>

<td style="text-align:right;">

1111343559

</td>

<td style="text-align:right;">

3219.970

</td>

<td style="text-align:right;">

1527.594

</td>

<td style="text-align:right;">

2312.745

</td>

<td style="text-align:right;">

3883610

</td>

<td style="text-align:right;">

11.25224

</td>

<td style="text-align:right;">

13.68358

</td>

<td style="text-align:right;">

12.55560

</td>

<td style="text-align:right;">

160.27224

</td>

<td style="text-align:right;">

0.0067265

</td>

<td style="text-align:right;">

23826.83

</td>

<td style="text-align:right;">

23590.83

</td>

<td style="text-align:right;">

175.6347568

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

345874

</td>

<td style="text-align:right;">

0.4649194

</td>

<td style="text-align:right;">

1068503274

</td>

<td style="text-align:right;">

3089.285

</td>

<td style="text-align:right;">

1527.594

</td>

<td style="text-align:right;">

2253.654

</td>

<td style="text-align:right;">

3886759

</td>

<td style="text-align:right;">

11.23750

</td>

<td style="text-align:right;">

13.68358

</td>

<td style="text-align:right;">

12.54635

</td>

<td style="text-align:right;">

101.18176

</td>

<td style="text-align:right;">

\-0.0025222

</td>

<td style="text-align:right;">

\-40116.67

</td>

<td style="text-align:right;">

\-2149723.33

</td>

<td style="text-align:right;">

\-227.7113983

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

344548

</td>

<td style="text-align:right;">

0.4631370

</td>

<td style="text-align:right;">

1083688031

</td>

<td style="text-align:right;">

3145.245

</td>

<td style="text-align:right;">

1527.594

</td>

<td style="text-align:right;">

2276.788

</td>

<td style="text-align:right;">

3874067

</td>

<td style="text-align:right;">

11.24391

</td>

<td style="text-align:right;">

13.68358

</td>

<td style="text-align:right;">

12.55368

</td>

<td style="text-align:right;">

124.31569

</td>

<td style="text-align:right;">

0.0048066

</td>

<td style="text-align:right;">

25863.75

</td>

<td style="text-align:right;">

42890.68

</td>

<td style="text-align:right;">

115.5921008

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

0.0190243

</td>

<td style="text-align:right;">

0.1353539

</td>

<td style="text-align:right;">

0.1514913

</td>

<td style="text-align:right;">

0.0798360

</td>

<td style="text-align:right;">

0.4178883

</td>

<td style="text-align:right;">

0.0781652

</td>

<td style="text-align:right;">

0.1304581

</td>

<td style="text-align:right;">

0.0112401

</td>

<td style="text-align:right;">

0.8422491

</td>

<td style="text-align:right;">

0.0462381

</td>

<td style="text-align:right;">

0.0491893

</td>

<td style="text-align:right;">

0.0110538

</td>

<td style="text-align:right;">

0.0019365

</td>

<td style="text-align:right;">

0.1867159

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

0.0263592

</td>

<td style="text-align:right;">

0.1594071

</td>

<td style="text-align:right;">

0.3103710

</td>

<td style="text-align:right;">

0.0936244

</td>

<td style="text-align:right;">

0.4006864

</td>

<td style="text-align:right;">

0.0750292

</td>

<td style="text-align:right;">

0.1278330

</td>

<td style="text-align:right;">

0.0111194

</td>

<td style="text-align:right;">

0.8424144

</td>

<td style="text-align:right;">

0.0463570

</td>

<td style="text-align:right;">

0.0489813

</td>

<td style="text-align:right;">

0.0110392

</td>

<td style="text-align:right;">

0.0018511

</td>

<td style="text-align:right;">

0.4644394

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

0.0215768

</td>

<td style="text-align:right;">

0.1467683

</td>

<td style="text-align:right;">

0.2385685

</td>

<td style="text-align:right;">

0.0860741

</td>

<td style="text-align:right;">

0.4032910

</td>

<td style="text-align:right;">

0.0756447

</td>

<td style="text-align:right;">

0.1277124

</td>

<td style="text-align:right;">

0.0110721

</td>

<td style="text-align:right;">

0.8425780

</td>

<td style="text-align:right;">

0.0462979

</td>

<td style="text-align:right;">

0.0488480

</td>

<td style="text-align:right;">

0.0110137

</td>

<td style="text-align:right;">

0.0019233

</td>

<td style="text-align:right;">

0.3320407

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

0.0202384

</td>

<td style="text-align:right;">

0.1449199

</td>

<td style="text-align:right;">

0.2151494

</td>

<td style="text-align:right;">

0.0856197

</td>

<td style="text-align:right;">

0.4120036

</td>

<td style="text-align:right;">

0.0767251

</td>

<td style="text-align:right;">

0.1302280

</td>

<td style="text-align:right;">

0.0109978

</td>

<td style="text-align:right;">

0.8424155

</td>

<td style="text-align:right;">

0.0462965

</td>

<td style="text-align:right;">

0.0490022

</td>

<td style="text-align:right;">

0.0110222

</td>

<td style="text-align:right;">

0.0019116

</td>

<td style="text-align:right;">

0.2881366

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

0.5942262

</td>

<td style="text-align:right;">

0.5830052

</td>

<td style="text-align:right;">

0.7034090

</td>

<td style="text-align:right;">

0.0190243

</td>

<td style="text-align:right;">

0.1353539

</td>

<td style="text-align:right;">

0.1514913

</td>

<td style="text-align:right;">

0.0798360

</td>

<td style="text-align:right;">

0.4178883

</td>

<td style="text-align:right;">

0.0781652

</td>

<td style="text-align:right;">

0.1304581

</td>

<td style="text-align:right;">

0.0112401

</td>

<td style="text-align:right;">

0.8422491

</td>

<td style="text-align:right;">

0.0462381

</td>

<td style="text-align:right;">

0.0491893

</td>

<td style="text-align:right;">

0.0110538

</td>

<td style="text-align:right;">

0.0019365

</td>

<td style="text-align:right;">

0.1867159

</td>

</tr>

<tr>

<td style="text-align:left;">

S2a

</td>

<td style="text-align:right;">

0.5936737

</td>

<td style="text-align:right;">

0.5827020

</td>

<td style="text-align:right;">

0.7095216

</td>

<td style="text-align:right;">

0.0223533

</td>

<td style="text-align:right;">

0.1457805

</td>

<td style="text-align:right;">

0.2267078

</td>

<td style="text-align:right;">

0.0872905

</td>

<td style="text-align:right;">

0.4082543

</td>

<td style="text-align:right;">

0.0772758

</td>

<td style="text-align:right;">

0.1291385

</td>

<td style="text-align:right;">

0.0113248

</td>

<td style="text-align:right;">

0.8415616

</td>

<td style="text-align:right;">

0.0467167

</td>

<td style="text-align:right;">

0.0494032

</td>

<td style="text-align:right;">

0.0110721

</td>

<td style="text-align:right;">

0.0019198

</td>

<td style="text-align:right;">

0.3090828

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

0.4639072

</td>

<td style="text-align:right;">

0.4157517

</td>

<td style="text-align:right;">

0.5833255

</td>

<td style="text-align:right;">

0.0190243

</td>

<td style="text-align:right;">

0.1353539

</td>

<td style="text-align:right;">

0.1514913

</td>

<td style="text-align:right;">

0.0798360

</td>

<td style="text-align:right;">

0.4178883

</td>

<td style="text-align:right;">

0.0781652

</td>

<td style="text-align:right;">

0.1304581

</td>

<td style="text-align:right;">

0.0112401

</td>

<td style="text-align:right;">

0.8422491

</td>

<td style="text-align:right;">

0.0462381

</td>

<td style="text-align:right;">

0.0491893

</td>

<td style="text-align:right;">

0.0110538

</td>

<td style="text-align:right;">

0.0019365

</td>

<td style="text-align:right;">

0.1867159

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

0.4637419

</td>

<td style="text-align:right;">

0.4152493

</td>

<td style="text-align:right;">

0.5873621

</td>

<td style="text-align:right;">

0.0201864

</td>

<td style="text-align:right;">

0.1392560

</td>

<td style="text-align:right;">

0.1813725

</td>

<td style="text-align:right;">

0.0828257

</td>

<td style="text-align:right;">

0.4169053

</td>

<td style="text-align:right;">

0.0789405

</td>

<td style="text-align:right;">

0.1308658

</td>

<td style="text-align:right;">

0.0112495

</td>

<td style="text-align:right;">

0.8417929

</td>

<td style="text-align:right;">

0.0463522

</td>

<td style="text-align:right;">

0.0495232

</td>

<td style="text-align:right;">

0.0110736

</td>

<td style="text-align:right;">

0.0019407

</td>

<td style="text-align:right;">

0.2322209

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

0.4639341

</td>

<td style="text-align:right;">

0.4158794

</td>

<td style="text-align:right;">

0.5859869

</td>

<td style="text-align:right;">

0.0227912

</td>

<td style="text-align:right;">

0.1486131

</td>

<td style="text-align:right;">

0.2350973

</td>

<td style="text-align:right;">

0.0888704

</td>

<td style="text-align:right;">

0.4128022

</td>

<td style="text-align:right;">

0.0781569

</td>

<td style="text-align:right;">

0.1302688

</td>

<td style="text-align:right;">

0.0115074

</td>

<td style="text-align:right;">

0.8419904

</td>

<td style="text-align:right;">

0.0461392

</td>

<td style="text-align:right;">

0.0495492

</td>

<td style="text-align:right;">

0.0111206

</td>

<td style="text-align:right;">

0.0018947

</td>

<td style="text-align:right;">

0.3197916

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

0.4649194

</td>

<td style="text-align:right;">

0.4163216

</td>

<td style="text-align:right;">

0.5866398

</td>

<td style="text-align:right;">

0.0214231

</td>

<td style="text-align:right;">

0.1420427

</td>

<td style="text-align:right;">

0.2062681

</td>

<td style="text-align:right;">

0.0843163

</td>

<td style="text-align:right;">

0.4122891

</td>

<td style="text-align:right;">

0.0781023

</td>

<td style="text-align:right;">

0.1292855

</td>

<td style="text-align:right;">

0.0112224

</td>

<td style="text-align:right;">

0.8419332

</td>

<td style="text-align:right;">

0.0464609

</td>

<td style="text-align:right;">

0.0493918

</td>

<td style="text-align:right;">

0.0110050

</td>

<td style="text-align:right;">

0.0018820

</td>

<td style="text-align:right;">

0.2737075

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

0.4631370

</td>

<td style="text-align:right;">

0.4151335

</td>

<td style="text-align:right;">

0.5871788

</td>

<td style="text-align:right;">

0.0208630

</td>

<td style="text-align:right;">

0.1409138

</td>

<td style="text-align:right;">

0.1961750

</td>

<td style="text-align:right;">

0.0838123

</td>

<td style="text-align:right;">

0.4163765

</td>

<td style="text-align:right;">

0.0786972

</td>

<td style="text-align:right;">

0.1301902

</td>

<td style="text-align:right;">

0.0113418

</td>

<td style="text-align:right;">

0.8417958

</td>

<td style="text-align:right;">

0.0462708

</td>

<td style="text-align:right;">

0.0494480

</td>

<td style="text-align:right;">

0.0112302

</td>

<td style="text-align:right;">

0.0019229

</td>

<td style="text-align:right;">

0.2554379

</td>

</tr>

</tbody>

</table>
