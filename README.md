[![Build Status](https://travis-ci.org/resplab/epicR.svg?branch=master)](https://travis-ci.org/resplab/epicR)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)


# epicR
R package for Evaluation Platform in COPD (EPIC). Please refer to the published paper for more information: 

Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., … Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. [https://doi.org/10.1177/0272989X18824098](https://doi.org/10.1177/0272989X18824098)


## Overview
epicR provides an interface to to interact with the Evaluation Platform in COPD (EPIC), a discrete-event-simulation (DES) whole-disease model of Chronic Onstructive Pulmonary Disease.

## Case Detection Analysis
In order to simulate the cost-effectiveness of case detection strategies for COPD analysis, follow the steps below. 

1. Follow the instructions below to install epicR from GitHub, but replace with:

```r
devtools::install_github('KateJohnson/epicR', ref="closed_cohort")
```
Confirm that `packageVersion("epicR")` is `1.27.6`.

2. In order to replicate the [case detection scenario results](https://github.com/KateJohnson/epicR/tree/closed_cohort/casedetection), go to `Case_Detection_Results.Rmd`, click the `Raw` button and copy all text that opens in the new page. 

3. Locally, start a new R Studio project, create a new R Markdown file (delete the default text), and paste the copied text.

4. Click knit and that's it!

Alternatively, you can clone this repo to get a local copy of `Case_Detection_Results.Rmd`.


Keep in mind that the analysis version of these results simulates 100 million agents with 3 and 5 year intervals between case detection. In order to do this you'll have to run the markdown script twice, once with `yrs_btw_CD = 3`, and once with `yrs_btw_CD = 5`. Make sure to change the values for all `Inputs [scenario name]` code chunks. Each time will take ~8 hours to run.

Refer to the forthcoming publication for more information:

Kate M. Johnson, Mohsen Sadatsafavi, Amin Adibi, Larry Lynd, Mark Harrison, Hamid Tavakoli, Don D. Sin, and Stirling Bryan. Cost-Effectiveness of Case Detection Strategies for the Early Detection of COPD.


## Installation
### Windows 7 or Later
1. Download and Install the latest version of R from [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Download and Install the latest version of Rtools from [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/) 
4. Using either an R session in Terminal or in R Studio, install the package `devtools`:

```r
  install.packages ('devtools')
```

5. Install epicR from GitHub:

```r
devtools::install_github('aminadibi/epicR')
```


### Mac OS Sierra and Later
1. Download and Install the latest version of R from [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
2. Download and Install R Studio from [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
3. Install homebrew from [https://brew.sh](https://brew.sh) and [Xcode](https://developer.apple.com/xcode/) developer tools from the App store.
4. Open the Terminal and use brew to install `llvm`:

```bash
  brew install llvm
```

5. Add the following to your `~/.bash_profile`:
  `export PATH="/usr/local/opt/llvm/bin:$PATH"`
  
  And this to your `~/.Rprofile`:
  `Sys.setenv(PATH=paste("/usr/local/opt/llvm/bin", Sys.getenv("PATH"), sep=":"))`
  
6. Using either an R session in Terminal or in R Studio, install the package `devtools`:

```r
install.packages ('devtools')
```

7. Install epicR from GitHub:
```r
devtools::install_github('resplab/epicR')
```

Note: If epicR is still not compiling correctly, `gfortran` needs to be installed separately. In the terminal:

```bash
brew install gfortran
```


Note: If epicR is still not compiling correctly, `gfortran` needs to be installed separately. In the terminal:

```bash
brew install gcc
```

Now, by default, R does not look for the HomeBrew version of gcc, so you will need to change this as well. First, you need to find the version of gcc you
are using:

```bash
brew list --versions gcc
```

The first number is {YOUR_GCC_MAIN_VERSION}, and the whole name is {YOUR_GCC_FULL_VERSION}. For example, on my computer, it is:

```
9.1.0
```

You will also need the folder name for your gcc, which you will need to log in as sudo to do:

```bash
sudo cd 
```

```bash
cd ~/usr/local/lib/gcc/{YOUR_GCC_MAIN_VERSION}/gcc
ls
```

The folder name printed out is {YOUR_GCC_TARGET}. For example, on my computer, it is:

```bash
x86_64-apple-darwin18
```

In terminal, use your favourite text editor to open the file "~/.R/Makevars":

```bash
open ~/.R/Makevars
```

This may open a blank file, or it might have some content already. Somewhere in the file, add the following:

```
CC = gcc-{YOUR_GCC_MAIN_VERSION}
CXX = g++-{YOUR_GCC_MAIN_VERSION}
FLIBS = -L/usr/local/lib/gcc/{YOUR_GCC_MAIN_VERSION}/gcc/{YOUR_GCC_TARGET}/{YOUR_GCC_FULL_VERSION} 
-L/usr/local/lib/gcc/{YOUR_GCC_MAIN_VERSION} -lgfortran -lquadmath -lm
```

For example, on my computer it would be:

```
CC = gcc-9
CXX = g++-9
FLIBS = -L/usr/local/lib/gcc/9/gcc/x86_64-apple-darwin18/9.1.0
-L/usr/local/lib/gcc/9 -lgfortran -lquadmath -lm
```

Once you have done this, save the file and close the text editor. You may need to restart RStudio, and try Step 7 again.


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
install.packages ('devtools')
```
  
5. Install epicR from GitHub:

```r
devtools::install_github('resplab/epicR')
```

# PRISM: EPIC on the Cloud

The [PRISM platform](https://prism.resp.core.ubc.ca) allows users to access EPIC through the cloud. A MACRO-enabled Excel-file can be used to interact with the model and see the results. To download the PRISM Excel template file for EPIC, please refer to the [PRISM model repository](http://resp.core.ubc.ca/ipress/prism)

## Citation

Please cite:

```Sadatsafavi, M., Ghanbarian, S., Adibi, A., Johnson, K., Mark FitzGerald, J., Flanagan, W., … Sin, D. (2019). Development and Validation of the Evaluation Platform in COPD (EPIC): A Population-Based Outcomes Model of COPD for Canada. Medical Decision Making. https://doi.org/10.1177/0272989X18824098```
