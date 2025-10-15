<!-- badges: start -->
[![R-CMD-check](https://github.com/resplab/epicR/workflows/R-CMD-check/badge.svg)](https://github.com/resplab/epicR/actions)
[![Codecov test coverage](https://codecov.io/gh/resplab/epicR/graph/badge.svg)](https://app.codecov.io/gh/resplab/epicR)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

# epicR
R package for Evaluation Platform in COPD (EPIC). Please refer to our published papers for more information: 

Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. [https://doi.org/10.1177/0272989X18824098](https://doi.org/10.1177/0272989X18824098)

Johnson KM, Sadatsafavi M, Adibi A, Lynd L, Harrison M, Tavakoli H, Sin DD, Bryan S. Cost effectiveness of case detection strategies for the early detection of COPD. Applied Health Economics and Health Policy. 2021 Mar;19(2):203-15. [https://doi.org/10.1007/s40258-020-00616-2](https://doi.org/10.1007/s40258-020-00616-2)

## Overview
epicR provides an interface to to interact with the Evaluation Platform in COPD (EPIC), a discrete-event-simulation (DES) whole-disease model of Chronic Onstructive Pulmonary Disease.

## Installation

### Prerequisites
epicR requires R version 4.1.0 or later and uses Rcpp/RcppArmadillo for C++ integration, which requires compilation tools to be installed on your system.

### Windows (Windows 10 or Later)

1. **Install R (version 4.1.0 or later)**
   - Download and install the latest version of R from [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)

2. **Install RStudio (Optional but Recommended)**
   - Download and install RStudio from [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)

3. **Install Rtools**
   - Download and install the latest version of Rtools from [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/)
   - **Important**: During installation, make sure to check the option to add Rtools to the system PATH
   - For R 4.3.0+, install Rtools43 or later
   - For R 4.2.x, install Rtools42

4. **Verify Rtools Installation**
   - Open R or RStudio and run:
   ```r
   # Check if Rtools is available
   Sys.which("make")
   ```
   - This should return a path to the make executable. If it returns an empty string, Rtools is not properly configured.

5. **Install the remotes package**
   ```r
   install.packages('remotes')
   ```

6. **Install epicR from GitHub**
   ```r
   remotes::install_github('resplab/epicR')
   ```

### macOS (macOS 11 Big Sur or Later)

1. **Install R (version 4.1.0 or later)**
   - Download and install the latest version of R from [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
   - Choose the appropriate version for your Mac:
     - For Apple Silicon (M1/M2/M3): Download the arm64 version
     - For Intel Macs: Download the x86_64 version

2. **Install RStudio (Optional but Recommended)**
   - Download and install RStudio from [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)

3. **Install Xcode Command Line Tools**
   - Open Terminal and run:
   ```bash
   xcode-select --install
   ```
   - Follow the prompts to complete the installation

4. **Install gfortran**
   - Download and install the appropriate gfortran version for your macOS from [https://github.com/fxcoudert/gfortran-for-macOS/releases](https://github.com/fxcoudert/gfortran-for-macOS/releases)
   - Choose the installer that matches your macOS version and chip architecture (Intel vs. Apple Silicon)

5. **Verify Compiler Installation**
   - Open Terminal and run:
   ```bash
   # Check clang
   clang --version
   
   # Check gfortran
   gfortran --version
   ```
   - Both commands should return version information

6. **Install the remotes package**
   - Open R or RStudio and run:
   ```r
   install.packages('remotes')
   ```

7. **Install epicR from GitHub**
   ```r
   remotes::install_github('resplab/epicR')
   ```

### Troubleshooting

#### Windows Issues
- If you encounter compilation errors, ensure Rtools is in your PATH. You can check this in R:
  ```r
  Sys.getenv("PATH")
  ```
- If the PATH doesn't include Rtools, you may need to add it manually or reinstall Rtools with the PATH option enabled.

#### macOS Issues
- If you encounter errors related to missing compilers after installation, try restarting your R session or computer.
- For Apple Silicon Macs, ensure you're using the arm64 version of R and compatible compilers.
- If you have previously installed older versions of compilers, they may interfere. Consider cleaning them up:
  ```bash
  # Only run if you have issues with old compiler installations
  sudo rm -rf /usr/local/clang*
  sudo rm -rf /usr/local/gfortran
  rm ~/.R/Makevars  # Remove custom compiler settings
  ```

### Ubuntu 22.04 and Later
1. Install R by executing the following commands in Terminal:

```bash
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
```
```bash
  sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
```
```bash
  sudo apt-get update
```
```bash
  sudo apt-get install r-base
```
If the installation is successful, you should be able to start R:
```bash
  sudo -i R
```

2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Install `libcurl` from Terminal: 

```bash
  sudo apt-get install libcurl4-openssl-dev libssl-dev r-base-dev
```

4. Using either an R session in Terminal or in R Studio, install the package `devtools`:

```r
install.packages ('remotes')
```
  
5. Install epicR from GitHub:

```r
remotes::install_github('resplab/epicR')
```

# Quick Guide

To run EPIC with default inputs and settings, use the code snippet below. 
```
library(epicR)
init_session()
run()
Cget_output()
terminate_session()
```
Default inputs can be retrieved with `get_input()`, changed as needed, and resubmitted as a parameter to the run function:
```
init_session()
input <- get_input()
input$values$global_parameters$time_horizon <- 5
run(input=input$values)
results <- Cget_output()
resultsExra <- Cget_output_ex()
terminate_session()

```

For some studies, having access to the entire event history of the simulated population might be beneficial. Capturing event history is possible by setting  `record_mode` as a `setting`. 

```
settings <- get_default_settings()
settings$record_mode <- 2
settings$n_base_agents <- 1e4
init_session(settings = settings)
run()
results <- Cget_output()
events <- as.data.frame(Cget_all_events_matrix())
head(events)
terminate_session()

```
Note that you might need a large amount of memory available, if you want to collect event history for a large number of patients. 

In the events data frame, each type of event has a code corresponding to the table below:

|Event|No.|
|-----|---|
|start |0 |
|annual|1 |
|birthday| 2 |
|smoking change | 3|
|COPD incidence | 4|
|Exacerbation | 5 |
|Exacerbation end| 6|
|Death by Exacerbation | 7|
|Doctor visit | 8|
|Medication change | 9|
|Background death | 13|
|End | 14|

  
## Closed-cohort analysis

Closed-cohort analysis can be specified by changing the appropriate input parameters. 

```
library(epicR)
input <- get_input(closed_cohort = 1)$values
init_session()
run(input=input)
Cget_output()
terminate_session()
```

# Peer Models Network: EPIC on the Cloud

The [Peer Models Network](https://www.peermodelsnetwork.com/) provides educational material abour the model. It also allows users to access EPIC through the cloud. A MACRO-enabled Excel-file can be used to interact with the model and see the results. To download the PRISM Excel template file for EPIC, or to access EPIC using APIs please refer to the [PMN model repository](https://models.peermodelsnetwork.com/#/)

## Citation

Please cite:

```Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., … Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. https://doi.org/10.1177/0272989X18824098```
