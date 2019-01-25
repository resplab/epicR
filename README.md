[![Build Status](https://travis-ci.org/aminadibi/epicR.svg?branch=master)](https://travis-ci.org/aminadibi/epicR)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)


# epicR
R package for Evaluation Platform in COPD (EPIC). Please refer to the published paper for more information: 

Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., … Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. [https://doi.org/10.1177/0272989X18824098](https://doi.org/10.1177/0272989X18824098)


## Overview
epicR provides an interface to to interact with the Evaluation Platform in COPD (EPIC), a discrete-event-simulation (DES) whole-disease model of Chronic Onstructive Pulmonary Disease.

<p>
    <img src="https://journals.sagepub.com/na101/home/literatum/publisher/sage/journals/content/mdma/0/mdma.ahead-of-print/0272989x18824098/20190124/images/large/10.1177_0272989x18824098-fig1.jpeg"/>
</p>


## Installation
### Windows 7 or Later
1. Download and Install the latest version of R from [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Download and Install the latest version of Rtools from [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/) 
4. Using either an R session in Terminal or in R Studio, install the package `devtools`:

  `install.packages ('devtools')`

5. Install epicR from GitHub:

`devtools::install_github('aminadibi/epicR')`


### Mac OS Sierra and Later
1. Download and Install the latest version of R from [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Install Xcode from Mac App Store. 
4. Using either an R session in Terminal or in R Studio, install the package `devtools`:

  `install.packages ('devtools')`

5. Install epicR from GitHub:

`devtools::install_github('aminadibi/epicR')`

### Ubuntu 16.04 and Later
1. Install R by executing the following commands in Terminal:

  `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9`

  `sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'`

  `sudo apt-get update`

  `sudo apt-get install r-base`

If the installation is successful, you should be able to start R:

  `sudo -i R`

2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Install `libcurl` from Terminal: 

  `sudo apt-get install libcurl4-openssl-dev libssl-dev`

4. Using either an R session in Terminal or in R Studio, install the package `devtools`:

  `install.packages ('devtools')`
5. Install epicR from GitHub:

  `devtools::install_github('aminadibi/epicR')`

## Citation

Please cite:

```Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., … Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. https://doi.org/10.1177/0272989X18824098```
