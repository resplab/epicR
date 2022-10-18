<!-- badges: start -->
[![R-CMD-check](https://github.com/resplab/epicR/workflows/R-CMD-check/badge.svg)](https://github.com/resplab/epicR/actions)
<!-- badges: end -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)


# epicR
R package for Evaluation Platform in COPD (EPIC). Please refer to the published paper for more information: 

Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., … Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. [https://doi.org/10.1177/0272989X18824098](https://doi.org/10.1177/0272989X18824098)


## Overview
epicR provides an interface to to interact with the Evaluation Platform in COPD (EPIC), a discrete-event-simulation (DES) whole-disease model of Chronic Onstructive Pulmonary Disease.

## Installation
### Windows 7 or Later
1. Download and Install the latest version of R from [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Download and Install the latest version of Rtools from [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/) 
4. Using either an R session in Terminal or in R Studio, install the package `devtools`:

```r
  install.packages('remotes')
```

5. Install epicR from GitHub:

```r
remotes::install_github('resplab/epicR')
```


### Mac OS Sierra and Later
1. Download and Install the latest version of R from [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Open the Terminal and remove previous installations of `clang`:

```bash
# Delete the clang4 binary
sudo rm -rf /usr/local/clang4
# Delete the clang6 binary
sudo rm -rf /usr/local/clang6

# Delete the prior version of gfortran installed
sudo rm -rf /usr/local/gfortran
sudo rm -rf /usr/local/bin/gfortran

# Remove the install receipts that indicate a package is present

# Remove the gfortran install receipts (run after the above commands)
sudo rm /private/var/db/receipts/com.gnu.gfortran.bom
sudo rm /private/var/db/receipts/com.gnu.gfortran.plist

# Remove the clang4 installer receipt
sudo rm /private/var/db/receipts/com.rbinaries.clang4.bom
sudo rm /private/var/db/receipts/com.rbinaries.clang4.plist

# Remove the Makevars file
rm ~/.R/Makevars
```
4. Install the latest version of `clang` by installing Xcode command tools: 
`xcode-select --install

5. Install the appropriate version of `gfortran` based on your Mac OS version using the dmg file found at [https://github.com/fxcoudert/gfortran-for-macOS/releases](https://github.com/fxcoudert/gfortran-for-macOS/releases) 

6. Using either an R session in Terminal or in R Studio, install the packages `remotes` and `usethis`:

```r
install.packages (c('remotes', 'usethis'))
```
7. Open the `.Renviron` file usibng the command `usethis::edit_r_environ()`
8. Add the line `PATH="/usr/local/clang8/bin:${PATH}"` to the file. If you installed any clang version above 8, modify the file accordingly. Save the `.Renviron` file and restart R.  

9. You should now be able to Install epicR from GitHub:
```r
remotes::install_github('resplab/epicR')
```

### Ubuntu 16.04 and Later
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
  sudo apt-get install libcurl4-openssl-dev libssl-dev
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
