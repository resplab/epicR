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

S1NoCD

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

743964

</td>

<td style="text-align:right;">

12526864

</td>

<td style="text-align:right;">

1432808

</td>

<td style="text-align:right;">

2455566

</td>

<td style="text-align:right;">

574715.6

</td>

<td style="text-align:right;">

326540

</td>

<td style="text-align:right;">

0.028

</td>

<td style="text-align:right;">

0.155

</td>

<td style="text-align:right;">

0.275

</td>

<td style="text-align:right;">

0.092

</td>

<td style="text-align:right;">

301010.0

</td>

<td style="text-align:right;">

56785.0

</td>

<td style="text-align:right;">

96054.0

</td>

<td style="text-align:right;">

8279

</td>

<td style="text-align:right;">

0.210

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

10545743

</td>

<td style="text-align:right;">

578571

</td>

<td style="text-align:right;">

620145.0

</td>

<td style="text-align:right;">

140029

</td>

<td style="text-align:right;">

24082

</td>

<td style="text-align:right;">

1762801835

</td>

<td style="text-align:right;">

2369.472

</td>

<td style="text-align:right;">

9343888

</td>

<td style="text-align:right;">

12.560

</td>

<td style="text-align:right;">

625610.4

</td>

<td style="text-align:right;">

222.426

</td>

<td style="text-align:right;">

0.009

</td>

<td style="text-align:right;">

24202.62

</td>

<td style="text-align:right;">

237.082

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

742720

</td>

<td style="text-align:right;">

12500524

</td>

<td style="text-align:right;">

1417507

</td>

<td style="text-align:right;">

2471543

</td>

<td style="text-align:right;">

415333.6

</td>

<td style="text-align:right;">

325612

</td>

<td style="text-align:right;">

0.024

</td>

<td style="text-align:right;">

0.144

</td>

<td style="text-align:right;">

0.215

</td>

<td style="text-align:right;">

0.085

</td>

<td style="text-align:right;">

301144.0

</td>

<td style="text-align:right;">

56309.0

</td>

<td style="text-align:right;">

95898.0

</td>

<td style="text-align:right;">

8211

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

10535425

</td>

<td style="text-align:right;">

573845

</td>

<td style="text-align:right;">

613050.0

</td>

<td style="text-align:right;">

137301

</td>

<td style="text-align:right;">

23862

</td>

<td style="text-align:right;">

1700028804

</td>

<td style="text-align:right;">

2288.923

</td>

<td style="text-align:right;">

9322276

</td>

<td style="text-align:right;">

12.552

</td>

<td style="text-align:right;">

625287.8

</td>

<td style="text-align:right;">

141.877

</td>

<td style="text-align:right;">

0.001

</td>

<td style="text-align:right;">

125679.10

</td>

<td style="text-align:right;">

\-85.433

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

743240

</td>

<td style="text-align:right;">

12501241

</td>

<td style="text-align:right;">

1428026

</td>

<td style="text-align:right;">

2476743

</td>

<td style="text-align:right;">

370840.8

</td>

<td style="text-align:right;">

326410

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

0.141

</td>

<td style="text-align:right;">

0.195

</td>

<td style="text-align:right;">

0.084

</td>

<td style="text-align:right;">

307492.0

</td>

<td style="text-align:right;">

57725.0

</td>

<td style="text-align:right;">

96806.0

</td>

<td style="text-align:right;">

8464

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

10525903

</td>

<td style="text-align:right;">

575894

</td>

<td style="text-align:right;">

618274.0

</td>

<td style="text-align:right;">

139396

</td>

<td style="text-align:right;">

24695

</td>

<td style="text-align:right;">

1727202425

</td>

<td style="text-align:right;">

2323.882

</td>

<td style="text-align:right;">

9320486

</td>

<td style="text-align:right;">

12.540

</td>

<td style="text-align:right;">

624693.4

</td>

<td style="text-align:right;">

176.837

</td>

<td style="text-align:right;">

\-0.010

</td>

<td style="text-align:right;">

\-17575.46

</td>

<td style="text-align:right;">

\-679.915

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

441029

</td>

<td style="text-align:right;">

7277380

</td>

<td style="text-align:right;">

1007241

</td>

<td style="text-align:right;">

1447885

</td>

<td style="text-align:right;">

194555.9

</td>

<td style="text-align:right;">

186669

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0.140

</td>

<td style="text-align:right;">

0.158

</td>

<td style="text-align:right;">

0.086

</td>

<td style="text-align:right;">

231582

</td>

<td style="text-align:right;">

42713

</td>

<td style="text-align:right;">

70381

</td>

<td style="text-align:right;">

6165

</td>

<td style="text-align:right;">

0.230

</td>

<td style="text-align:right;">

0.042

</td>

<td style="text-align:right;">

0.07

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

5959491

</td>

<td style="text-align:right;">

376680

</td>

<td style="text-align:right;">

448207

</td>

<td style="text-align:right;">

112180

</td>

<td style="text-align:right;">

20879

</td>

<td style="text-align:right;">

1174459700

</td>

<td style="text-align:right;">

2662.999

</td>

<td style="text-align:right;">

5408141

</td>

<td style="text-align:right;">

12.263

</td>

<td style="text-align:right;">

610464.6

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

441979

</td>

<td style="text-align:right;">

7301623

</td>

<td style="text-align:right;">

1004080

</td>

<td style="text-align:right;">

1435564

</td>

<td style="text-align:right;">

325593.2

</td>

<td style="text-align:right;">

188394

</td>

<td style="text-align:right;">

0.025

</td>

<td style="text-align:right;">

0.153

</td>

<td style="text-align:right;">

0.241

</td>

<td style="text-align:right;">

0.093

</td>

<td style="text-align:right;">

225721

</td>

<td style="text-align:right;">

42004

</td>

<td style="text-align:right;">

70377

</td>

<td style="text-align:right;">

6170

</td>

<td style="text-align:right;">

0.225

</td>

<td style="text-align:right;">

0.042

</td>

<td style="text-align:right;">

0.07

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

5985784

</td>

<td style="text-align:right;">

372666

</td>

<td style="text-align:right;">

449758

</td>

<td style="text-align:right;">

111895

</td>

<td style="text-align:right;">

20517

</td>

<td style="text-align:right;">

1250779791

</td>

<td style="text-align:right;">

2829.953

</td>

<td style="text-align:right;">

5429739

</td>

<td style="text-align:right;">

12.285

</td>

<td style="text-align:right;">

611423.1

</td>

<td style="text-align:right;">

166.954

</td>

<td style="text-align:right;">

0.023

</td>

<td style="text-align:right;">

7417.415

</td>

<td style="text-align:right;">

958.466

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

345715

</td>

<td style="text-align:right;">

5216559

</td>

<td style="text-align:right;">

838402.0

</td>

<td style="text-align:right;">

1051879

</td>

<td style="text-align:right;">

158302.2

</td>

<td style="text-align:right;">

141895

</td>

<td style="text-align:right;">

0.022

</td>

<td style="text-align:right;">

0.137

</td>

<td style="text-align:right;">

0.154

</td>

<td style="text-align:right;">

0.085

</td>

<td style="text-align:right;">

194871

</td>

<td style="text-align:right;">

36055

</td>

<td style="text-align:right;">

60858

</td>

<td style="text-align:right;">

5338

</td>

<td style="text-align:right;">

0.232

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

4160048

</td>

<td style="text-align:right;">

308960

</td>

<td style="text-align:right;">

376803

</td>

<td style="text-align:right;">

94975

</td>

<td style="text-align:right;">

17320

</td>

<td style="text-align:right;">

1002727198

</td>

<td style="text-align:right;">

2900.445

</td>

<td style="text-align:right;">

3885642

</td>

<td style="text-align:right;">

11.239

</td>

<td style="text-align:right;">

559071.4

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

344908

</td>

<td style="text-align:right;">

5200513

</td>

<td style="text-align:right;">

837627.5

</td>

<td style="text-align:right;">

1043528

</td>

<td style="text-align:right;">

202188.0

</td>

<td style="text-align:right;">

139838

</td>

<td style="text-align:right;">

0.024

</td>

<td style="text-align:right;">

0.143

</td>

<td style="text-align:right;">

0.189

</td>

<td style="text-align:right;">

0.089

</td>

<td style="text-align:right;">

193977

</td>

<td style="text-align:right;">

36209

</td>

<td style="text-align:right;">

61032

</td>

<td style="text-align:right;">

5104

</td>

<td style="text-align:right;">

0.232

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

4145370

</td>

<td style="text-align:right;">

307004

</td>

<td style="text-align:right;">

375375

</td>

<td style="text-align:right;">

96693

</td>

<td style="text-align:right;">

18249

</td>

<td style="text-align:right;">

1044441741

</td>

<td style="text-align:right;">

3028.175

</td>

<td style="text-align:right;">

3874349

</td>

<td style="text-align:right;">

11.233

</td>

<td style="text-align:right;">

558621.4

</td>

<td style="text-align:right;">

127.730

</td>

<td style="text-align:right;">

\-0.006

</td>

<td style="text-align:right;">

\-19820.31

</td>

<td style="text-align:right;">

\-449.951

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

344201

</td>

<td style="text-align:right;">

5199888

</td>

<td style="text-align:right;">

831582.2

</td>

<td style="text-align:right;">

1031170

</td>

<td style="text-align:right;">

296447.6

</td>

<td style="text-align:right;">

142174

</td>

<td style="text-align:right;">

0.029

</td>

<td style="text-align:right;">

0.152

</td>

<td style="text-align:right;">

0.259

</td>

<td style="text-align:right;">

0.096

</td>

<td style="text-align:right;">

191663

</td>

<td style="text-align:right;">

35819

</td>

<td style="text-align:right;">

60368

</td>

<td style="text-align:right;">

5315

</td>

<td style="text-align:right;">

0.230

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

4150542

</td>

<td style="text-align:right;">

301915

</td>

<td style="text-align:right;">

373859

</td>

<td style="text-align:right;">

97180

</td>

<td style="text-align:right;">

18577

</td>

<td style="text-align:right;">

1079183914

</td>

<td style="text-align:right;">

3135.331

</td>

<td style="text-align:right;">

3875935

</td>

<td style="text-align:right;">

11.261

</td>

<td style="text-align:right;">

559898.3

</td>

<td style="text-align:right;">

234.886

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

11060.01

</td>

<td style="text-align:right;">

826.984

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

344352

</td>

<td style="text-align:right;">

5196158

</td>

<td style="text-align:right;">

831133.1

</td>

<td style="text-align:right;">

1036545

</td>

<td style="text-align:right;">

246760.2

</td>

<td style="text-align:right;">

141166

</td>

<td style="text-align:right;">

0.026

</td>

<td style="text-align:right;">

0.147

</td>

<td style="text-align:right;">

0.224

</td>

<td style="text-align:right;">

0.093

</td>

<td style="text-align:right;">

192013

</td>

<td style="text-align:right;">

35850

</td>

<td style="text-align:right;">

60013

</td>

<td style="text-align:right;">

5203

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

4147097

</td>

<td style="text-align:right;">

304293

</td>

<td style="text-align:right;">

371096

</td>

<td style="text-align:right;">

97168

</td>

<td style="text-align:right;">

18564

</td>

<td style="text-align:right;">

1050566823

</td>

<td style="text-align:right;">

3050.852

</td>

<td style="text-align:right;">

3872515

</td>

<td style="text-align:right;">

11.246

</td>

<td style="text-align:right;">

559239.3

</td>

<td style="text-align:right;">

150.407

</td>

<td style="text-align:right;">

0.006

</td>

<td style="text-align:right;">

23621.50

</td>

<td style="text-align:right;">

167.962

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

344762

</td>

<td style="text-align:right;">

5197103

</td>

<td style="text-align:right;">

831182.7

</td>

<td style="text-align:right;">

1039231

</td>

<td style="text-align:right;">

228239.8

</td>

<td style="text-align:right;">

140487

</td>

<td style="text-align:right;">

0.025

</td>

<td style="text-align:right;">

0.146

</td>

<td style="text-align:right;">

0.211

</td>

<td style="text-align:right;">

0.092

</td>

<td style="text-align:right;">

191932

</td>

<td style="text-align:right;">

35654

</td>

<td style="text-align:right;">

60606

</td>

<td style="text-align:right;">

5261

</td>

<td style="text-align:right;">

0.231

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

4147923

</td>

<td style="text-align:right;">

301180

</td>

<td style="text-align:right;">

375243

</td>

<td style="text-align:right;">

97013

</td>

<td style="text-align:right;">

17700

</td>

<td style="text-align:right;">

1060076210

</td>

<td style="text-align:right;">

3074.806

</td>

<td style="text-align:right;">

3872734

</td>

<td style="text-align:right;">

11.233

</td>

<td style="text-align:right;">

558578.4

</td>

<td style="text-align:right;">

174.361

</td>

<td style="text-align:right;">

\-0.006

</td>

<td style="text-align:right;">

\-27366.97

</td>

<td style="text-align:right;">

\-492.923

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

441979

</td>

<td style="text-align:right;">

1250779791

</td>

<td style="text-align:right;">

2829.953

</td>

<td style="text-align:right;">

5429739

</td>

<td style="text-align:right;">

12.285

</td>

<td style="text-align:right;">

7417.415

</td>

<td style="text-align:right;">

958.466

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

344201

</td>

<td style="text-align:right;">

1079183914

</td>

<td style="text-align:right;">

3135.331

</td>

<td style="text-align:right;">

3875935

</td>

<td style="text-align:right;">

11.261

</td>

<td style="text-align:right;">

11060.015

</td>

<td style="text-align:right;">

826.984

</td>

</tr>

<tr>

<td style="text-align:left;">

S1a

</td>

<td style="text-align:right;">

743964

</td>

<td style="text-align:right;">

1762801835

</td>

<td style="text-align:right;">

2369.472

</td>

<td style="text-align:right;">

9343888

</td>

<td style="text-align:right;">

12.560

</td>

<td style="text-align:right;">

24202.618

</td>

<td style="text-align:right;">

237.082

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

344352

</td>

<td style="text-align:right;">

1050566823

</td>

<td style="text-align:right;">

3050.852

</td>

<td style="text-align:right;">

3872515

</td>

<td style="text-align:right;">

11.246

</td>

<td style="text-align:right;">

23621.503

</td>

<td style="text-align:right;">

167.962

</td>

</tr>

<tr>

<td style="text-align:left;">

S1NoCD

</td>

<td style="text-align:right;">

743618

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

441029

</td>

<td style="text-align:right;">

1174459700

</td>

<td style="text-align:right;">

2662.999

</td>

<td style="text-align:right;">

5408141

</td>

<td style="text-align:right;">

12.263

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

345715

</td>

<td style="text-align:right;">

1002727198

</td>

<td style="text-align:right;">

2900.445

</td>

<td style="text-align:right;">

3885642

</td>

<td style="text-align:right;">

11.239

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

S1b

</td>

<td style="text-align:right;">

742720

</td>

<td style="text-align:right;">

1700028804

</td>

<td style="text-align:right;">

2288.923

</td>

<td style="text-align:right;">

9322276

</td>

<td style="text-align:right;">

12.552

</td>

<td style="text-align:right;">

125679.099

</td>

<td style="text-align:right;">

\-85.433

</td>

</tr>

<tr>

<td style="text-align:left;">

S3a

</td>

<td style="text-align:right;">

344908

</td>

<td style="text-align:right;">

1044441741

</td>

<td style="text-align:right;">

3028.175

</td>

<td style="text-align:right;">

3874349

</td>

<td style="text-align:right;">

11.233

</td>

<td style="text-align:right;">

\-19820.307

</td>

<td style="text-align:right;">

\-449.951

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

344762

</td>

<td style="text-align:right;">

1060076210

</td>

<td style="text-align:right;">

3074.806

</td>

<td style="text-align:right;">

3872734

</td>

<td style="text-align:right;">

11.233

</td>

<td style="text-align:right;">

\-27366.973

</td>

<td style="text-align:right;">

\-492.923

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

743240

</td>

<td style="text-align:right;">

1727202425

</td>

<td style="text-align:right;">

2323.882

</td>

<td style="text-align:right;">

9320486

</td>

<td style="text-align:right;">

12.540

</td>

<td style="text-align:right;">

\-17575.459

</td>

<td style="text-align:right;">

\-679.915

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

743964

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1762801835

</td>

<td style="text-align:right;">

2369.472

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2369.472

</td>

<td style="text-align:right;">

9343888

</td>

<td style="text-align:right;">

12.55960

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.55960

</td>

<td style="text-align:right;">

216.99813

</td>

<td style="text-align:right;">

0.0107161

</td>

<td style="text-align:right;">

20249.694

</td>

<td style="text-align:right;">

24202.618

</td>

<td style="text-align:right;">

318.8078119

</td>

</tr>

<tr>

<td style="text-align:left;">

S1b

</td>

<td style="text-align:right;">

742720

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1700028804

</td>

<td style="text-align:right;">

2288.923

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2288.923

</td>

<td style="text-align:right;">

9322276

</td>

<td style="text-align:right;">

12.55154

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.55154

</td>

<td style="text-align:right;">

136.44906

</td>

<td style="text-align:right;">

0.0026548

</td>

<td style="text-align:right;">

51396.477

</td>

<td style="text-align:right;">

125679.099

</td>

<td style="text-align:right;">

\-3.7074142

</td>

</tr>

<tr>

<td style="text-align:left;">

S1c

</td>

<td style="text-align:right;">

743240

</td>

<td style="text-align:right;">

1.0000000

</td>

<td style="text-align:right;">

1727202425

</td>

<td style="text-align:right;">

2323.882

</td>

<td style="text-align:right;">

0.000

</td>

<td style="text-align:right;">

2323.882

</td>

<td style="text-align:right;">

9320486

</td>

<td style="text-align:right;">

12.54035

</td>

<td style="text-align:right;">

0.00000

</td>

<td style="text-align:right;">

12.54035

</td>

<td style="text-align:right;">

171.40867

</td>

<td style="text-align:right;">

\-0.0085356

</td>

<td style="text-align:right;">

\-20081.570

</td>

<td style="text-align:right;">

\-17575.459

</td>

<td style="text-align:right;">

\-598.1897062

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

441029

</td>

<td style="text-align:right;">

0.5928255

</td>

<td style="text-align:right;">

1174459700

</td>

<td style="text-align:right;">

2662.999

</td>

<td style="text-align:right;">

1409.172

</td>

<td style="text-align:right;">

2152.472

</td>

<td style="text-align:right;">

5408141

</td>

<td style="text-align:right;">

12.26255

</td>

<td style="text-align:right;">

12.96574

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

441979

</td>

<td style="text-align:right;">

0.5941025

</td>

<td style="text-align:right;">

1250779791

</td>

<td style="text-align:right;">

2829.953

</td>

<td style="text-align:right;">

1409.172

</td>

<td style="text-align:right;">

2253.261

</td>

<td style="text-align:right;">

5429739

</td>

<td style="text-align:right;">

12.28506

</td>

<td style="text-align:right;">

12.96574

</td>

<td style="text-align:right;">

12.56135

</td>

<td style="text-align:right;">

100.78901

</td>

<td style="text-align:right;">

0.0124743

</td>

<td style="text-align:right;">

8079.703

</td>

<td style="text-align:right;">

7417.415

</td>

<td style="text-align:right;">

522.5079863

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

345715

</td>

<td style="text-align:right;">

0.4647057

</td>

<td style="text-align:right;">

1002727198

</td>

<td style="text-align:right;">

2900.445

</td>

<td style="text-align:right;">

1503.134

</td>

<td style="text-align:right;">

2152.472

</td>

<td style="text-align:right;">

3885642

</td>

<td style="text-align:right;">

11.23944

</td>

<td style="text-align:right;">

13.68563

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

344908

</td>

<td style="text-align:right;">

0.4636209

</td>

<td style="text-align:right;">

1044441741

</td>

<td style="text-align:right;">

3028.175

</td>

<td style="text-align:right;">

1503.134

</td>

<td style="text-align:right;">

2210.175

</td>

<td style="text-align:right;">

3874349

</td>

<td style="text-align:right;">

11.23299

</td>

<td style="text-align:right;">

13.68563

</td>

<td style="text-align:right;">

12.54854

</td>

<td style="text-align:right;">

57.70269

</td>

<td style="text-align:right;">

\-0.0003342

</td>

<td style="text-align:right;">

\-172643.648

</td>

<td style="text-align:right;">

\-19820.307

</td>

<td style="text-align:right;">

\-74.8344493

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

344201

</td>

<td style="text-align:right;">

0.4626706

</td>

<td style="text-align:right;">

1079183914

</td>

<td style="text-align:right;">

3135.331

</td>

<td style="text-align:right;">

1503.134

</td>

<td style="text-align:right;">

2258.304

</td>

<td style="text-align:right;">

3875935

</td>

<td style="text-align:right;">

11.26067

</td>

<td style="text-align:right;">

13.68563

</td>

<td style="text-align:right;">

12.56368

</td>

<td style="text-align:right;">

105.83117

</td>

<td style="text-align:right;">

0.0148042

</td>

<td style="text-align:right;">

7148.736

</td>

<td style="text-align:right;">

11060.015

</td>

<td style="text-align:right;">

633.9574746

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

344352

</td>

<td style="text-align:right;">

0.4628735

</td>

<td style="text-align:right;">

1050566823

</td>

<td style="text-align:right;">

3050.852

</td>

<td style="text-align:right;">

1503.134

</td>

<td style="text-align:right;">

2219.532

</td>

<td style="text-align:right;">

3872515

</td>

<td style="text-align:right;">

11.24580

</td>

<td style="text-align:right;">

13.68563

</td>

<td style="text-align:right;">

12.55630

</td>

<td style="text-align:right;">

67.05934

</td>

<td style="text-align:right;">

0.0074290

</td>

<td style="text-align:right;">

9026.656

</td>

<td style="text-align:right;">

23621.503

</td>

<td style="text-align:right;">

303.9721739

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

344762

</td>

<td style="text-align:right;">

0.4634247

</td>

<td style="text-align:right;">

1060076210

</td>

<td style="text-align:right;">

3074.806

</td>

<td style="text-align:right;">

1503.134

</td>

<td style="text-align:right;">

2231.486

</td>

<td style="text-align:right;">

3872734

</td>

<td style="text-align:right;">

11.23306

</td>

<td style="text-align:right;">

13.68563

</td>

<td style="text-align:right;">

12.54905

</td>

<td style="text-align:right;">

79.01334

</td>

<td style="text-align:right;">

0.0001810

</td>

<td style="text-align:right;">

436487.462

</td>

<td style="text-align:right;">

\-27366.973

</td>

<td style="text-align:right;">

\-70.3825494

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

0.0277449

</td>

<td style="text-align:right;">

0.1552819

</td>

<td style="text-align:right;">

0.2745156

</td>

<td style="text-align:right;">

0.0923464

</td>

<td style="text-align:right;">

0.4046029

</td>

<td style="text-align:right;">

0.0763276

</td>

<td style="text-align:right;">

0.1291111

</td>

<td style="text-align:right;">

0.0111282

</td>

<td style="text-align:right;">

0.8418502

</td>

<td style="text-align:right;">

0.0461864

</td>

<td style="text-align:right;">

0.0495052

</td>

<td style="text-align:right;">

0.0111783

</td>

<td style="text-align:right;">

0.0019224

</td>

<td style="text-align:right;">

0.4011113

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

0.0238629

</td>

<td style="text-align:right;">

0.1436186

</td>

<td style="text-align:right;">

0.2145821

</td>

<td style="text-align:right;">

0.0849204

</td>

<td style="text-align:right;">

0.4054610

</td>

<td style="text-align:right;">

0.0758146

</td>

<td style="text-align:right;">

0.1291173

</td>

<td style="text-align:right;">

0.0110553

</td>

<td style="text-align:right;">

0.8427987

</td>

<td style="text-align:right;">

0.0459057

</td>

<td style="text-align:right;">

0.0490419

</td>

<td style="text-align:right;">

0.0109836

</td>

<td style="text-align:right;">

0.0019089

</td>

<td style="text-align:right;">

0.2930029

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

0.0230052

</td>

<td style="text-align:right;">

0.1413558

</td>

<td style="text-align:right;">

0.1953301

</td>

<td style="text-align:right;">

0.0837340

</td>

<td style="text-align:right;">

0.4137183

</td>

<td style="text-align:right;">

0.0776667

</td>

<td style="text-align:right;">

0.1302486

</td>

<td style="text-align:right;">

0.0113880

</td>

<td style="text-align:right;">

0.8419887

</td>

<td style="text-align:right;">

0.0460669

</td>

<td style="text-align:right;">

0.0494570

</td>

<td style="text-align:right;">

0.0111506

</td>

<td style="text-align:right;">

0.0019754

</td>

<td style="text-align:right;">

0.2596877

</td>

</tr>

<tr>

<td style="text-align:left;">

S2NoCD

</td>

<td style="text-align:right;">

0.5928255

</td>

<td style="text-align:right;">

0.5810544

</td>

<td style="text-align:right;">

0.7055273

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

0.5941025

</td>

<td style="text-align:right;">

0.5829901

</td>

<td style="text-align:right;">

0.7033131

</td>

<td style="text-align:right;">

0.0215057

</td>

<td style="text-align:right;">

0.1442623

</td>

<td style="text-align:right;">

0.2098977

</td>

<td style="text-align:right;">

0.0850225

</td>

<td style="text-align:right;">

0.4096757

</td>

<td style="text-align:right;">

0.0771471

</td>

<td style="text-align:right;">

0.1303403

</td>

<td style="text-align:right;">

0.0112376

</td>

<td style="text-align:right;">

0.8426554

</td>

<td style="text-align:right;">

0.0458429

</td>

<td style="text-align:right;">

0.0492512

</td>

<td style="text-align:right;">

0.0110214

</td>

<td style="text-align:right;">

0.0019063

</td>

<td style="text-align:right;">

0.2788810

</td>

</tr>

<tr>

<td style="text-align:left;">

S3NoCD

</td>

<td style="text-align:right;">

0.4647057

</td>

<td style="text-align:right;">

0.4165104

</td>

<td style="text-align:right;">

0.5872631

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

0.4636209

</td>

<td style="text-align:right;">

0.4152292

</td>

<td style="text-align:right;">

0.5867206

</td>

<td style="text-align:right;">

0.0196621

</td>

<td style="text-align:right;">

0.1390533

</td>

<td style="text-align:right;">

0.1721135

</td>

<td style="text-align:right;">

0.0821227

</td>

<td style="text-align:right;">

0.4170026

</td>

<td style="text-align:right;">

0.0784323

</td>

<td style="text-align:right;">

0.1307906

</td>

<td style="text-align:right;">

0.0109338

</td>

<td style="text-align:right;">

0.8421972

</td>

<td style="text-align:right;">

0.0461293

</td>

<td style="text-align:right;">

0.0491172

</td>

<td style="text-align:right;">

0.0111986

</td>

<td style="text-align:right;">

0.0020118

</td>

<td style="text-align:right;">

0.2175557

</td>

</tr>

<tr>

<td style="text-align:left;">

S3b

</td>

<td style="text-align:right;">

0.4626706

</td>

<td style="text-align:right;">

0.4151794

</td>

<td style="text-align:right;">

0.5824862

</td>

<td style="text-align:right;">

0.0216459

</td>

<td style="text-align:right;">

0.1440926

</td>

<td style="text-align:right;">

0.2128491

</td>

<td style="text-align:right;">

0.0862412

</td>

<td style="text-align:right;">

0.4141690

</td>

<td style="text-align:right;">

0.0779608

</td>

<td style="text-align:right;">

0.1299844

</td>

<td style="text-align:right;">

0.0112246

</td>

<td style="text-align:right;">

0.8426537

</td>

<td style="text-align:right;">

0.0457248

</td>

<td style="text-align:right;">

0.0489978

</td>

<td style="text-align:right;">

0.0112378

</td>

<td style="text-align:right;">

0.0020381

</td>

<td style="text-align:right;">

0.2843583

</td>

</tr>

<tr>

<td style="text-align:left;">

S3c

</td>

<td style="text-align:right;">

0.4628735

</td>

<td style="text-align:right;">

0.4148815

</td>

<td style="text-align:right;">

0.5821716

</td>

<td style="text-align:right;">

0.0206161

</td>

<td style="text-align:right;">

0.1412689

</td>

<td style="text-align:right;">

0.1922474

</td>

<td style="text-align:right;">

0.0844242

</td>

<td style="text-align:right;">

0.4145804

</td>

<td style="text-align:right;">

0.0779913

</td>

<td style="text-align:right;">

0.1294888

</td>

<td style="text-align:right;">

0.0110725

</td>

<td style="text-align:right;">

0.8426391

</td>

<td style="text-align:right;">

0.0459257

</td>

<td style="text-align:right;">

0.0487870

</td>

<td style="text-align:right;">

0.0112386

</td>

<td style="text-align:right;">

0.0020373

</td>

<td style="text-align:right;">

0.2496123

</td>

</tr>

<tr>

<td style="text-align:left;">

S3d

</td>

<td style="text-align:right;">

0.4634247

</td>

<td style="text-align:right;">

0.4149569

</td>

<td style="text-align:right;">

0.5822063

</td>

<td style="text-align:right;">

0.0201607

</td>

<td style="text-align:right;">

0.1408795

</td>

<td style="text-align:right;">

0.1846534

</td>

<td style="text-align:right;">

0.0838355

</td>

<td style="text-align:right;">

0.4143109

</td>

<td style="text-align:right;">

0.0776972

</td>

<td style="text-align:right;">

0.1302358

</td>

<td style="text-align:right;">

0.0111463

</td>

<td style="text-align:right;">

0.8426391

</td>

<td style="text-align:right;">

0.0456743

</td>

<td style="text-align:right;">

0.0491156

</td>

<td style="text-align:right;">

0.0112258

</td>

<td style="text-align:right;">

0.0019683

</td>

<td style="text-align:right;">

0.2366332

</td>

</tr>

</tbody>

</table>
