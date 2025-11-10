# Using EPIC in R

## 1 Installation

If you do not have R installed on your computer, please go to [Appendix
1](#appendix1). Once you have R installed, you can install the **epicR**
package as per the instructions below:

### Windows 7 or Later

1.  Download and Install the latest version of R from
    <https://cran.r-project.org/bin/windows/base/>
2.  Download and Install R Studio from
    <https://www.rstudio.com/products/rstudio/download/>
3.  Download and Install the latest version of Rtools from
    <https://cran.r-project.org/bin/windows/Rtools/>
4.  Using either an R session in Terminal or in R Studio, install the
    package \`remotes\`\`:

``` r
install.packages('remotes')
```

5.  Install epicR from GitHub:

``` r
remotes::install_github('resplab/epicR')
```

### Mac OS Sierra and Later

TBD

### Ubuntu 22.04 and Later

1.  Install R by executing the following commands in Terminal:

``` bash
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
```

``` bash
  sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
```

``` bash
  sudo apt-get update
```

``` bash
  sudo apt-get install r-base
```

If the installation is successful, you should be able to start R:

``` bash
  sudo -i R
```

2.  Download and Install R Studio from
    <https://www.rstudio.com/products/rstudio/download/>
3.  Install `libcurl` from Terminal:

``` bash
  sudo apt-get install libcurl4-openssl-dev libssl-dev r-base-dev
```

4.  Using either an R session in Terminal or in R Studio, install the
    package `devtools`:

``` r
install.packages ('remotes')
```

5.  Install epicR from GitHub:

``` r
remotes::install_github('resplab/epicR')
```

## 2 Running the Model

Now that you have installed `epicR`, you can load the library:

``` r
library(epicR)
```

### Step 1: Initialize the Session

The backend of this package is in C++. In other languages such as
R/Python, memory allocation is taken care of for you. However, in C/C++,
you need to allocate memory yourself. You also need to deallocate memory
when the program is done. Because of this, we have the function
[`init_session()`](../reference/init_session.md).

[`init_session()`](../reference/init_session.md) is in the **core.R**
file, and calls 3 C functions: `Cdeallocate_resources()`,
`Callocate_resources()`, and `Cinit_session()`. You don’t really need to
know how these work, but basically they allocate/deallocate memory.

You need to call this before you run anything:

``` r
init_session()
```

In C++, a program that is successful returns `0`, so you should see this
in the R console.

### Step 2: Set the Inputs

The default input values are created in the file **input.R**. You can
retrieve these values using [`get_input()`](../reference/get_input.md).
This function returns a nested list. The returned list contains
`values`, `help` and `ref` which each hold further sub-lists. `help` and
`ref` contain explanations regarding what each input parameter means.

For easier notation we will refer the retrieved inputs as `input`:

``` r
input <- get_input()
```

Below is a list of the parameters that `input$values` returns.

`input$values` returns a list of lists, so you can further explore and
set specific inputs using the `$` operator. An example of how to do this
is shown below:

``` r
#changing time_horizon which can be accessed through global_parameters
input$values$global_parameters$time_horizon <- 5
#changing age0, which can be accessed through global_parameters, from the default value of 40 to 50
input$values$global_parameters$age0 <- 50
#changing p_females, which can be accessed through agent, from the default value 0.5 to 0.6.
input$values$agent$p_female <- 0.6
```

### Step 3: Run

After changing the inputs you can provide them to the
[`run()`](../reference/run.md) function. The
[`run()`](../reference/run.md) function has two arguments:
**max_n_agents** and **input**. If you created your own input in **Step
2**, you can put it in here; otherwise, you can leave the **input**
argument blank. The **max_n_agents** argument is how many people you
want in your model. The default is set to the maximum integer your
computer will allow. You can set this to a lower number if you like (it
might run faster).

``` r
#to run the simulation with default parameters
run()
#to run the simulation with custom parameters
run(max_n_agents = 1000, input = input$values)
```

### Step 4: Results

Once you have run the model simulation, there are several functions to
access the results.

The first function is the [`Cget_output()`](../reference/Cget_output.md)
which shows some of the overall results:

``` r
results <- Cget_output()
```

The second function [`Cget_output_ex()`](../reference/Cget_output_ex.md)
returns a very large list of results:

``` r
resultsExra <- Cget_output_ex()
```

**While interpreting the `age` column, it is important to note that EPIC
only starts simulating patients at age 40. Also comorbidities are not
implemented in the current version of epicR.**

The full snippet of the code:

``` r
init_session()
input <- get_input()
input$values$global_parameters$time_horizon <- 5
run(input=input$values)
results <- Cget_output()
resultsExra <- Cget_output_ex()
terminate_session()
```

For some studies, having access to the entire event history of the
simulated population might be beneficial. Capturing event history is
possible by setting record_mode as a setting.

[`Cget_all_events_matrix()`](../reference/Cget_all_events_matrix.md)
function returns the events matrix, with every event for every patient.
Note that you might need a large amount of memory available, if you want
to collect event history for a large number of patients.

``` r
settings <- get_default_settings()
# record_mode = 2 indicates recording every event that occure
settings$record_mode <- 2
#n_base_agents is the number of people at time 0.
settings$n_base_agents <- 1e4
init_session(settings = settings)
run()
results <- Cget_output()
events <- as.data.frame(Cget_all_events_matrix())
head(events)
terminate_session()
```

You can change the record mode of the simulation by accessing
`settings$record_mode` as shown above. Here are what different record
modes mean

As shown in the code snippet above, you can inspect the event matrix
[`Cget_all_events_matrix()`](../reference/Cget_all_events_matrix.md) by
converting it into a data frame using
`as.data.frame(Cget_all_events_matrix())`. This data frame consists of
33 columns, as detailed below.

In the events data frame, each type of event has a code corresponding to
the table below:

Note: Doctor visit and Medication change are not implemented in this
version if epicR

### Closed-cohort analysis

Closed-cohort analysis can be specified by changing the appropriate
input parameters:

``` r
library(epicR)
input <- get_input(closed_cohort = 1)$values
init_session()
run(input=input)
Cget_output()
terminate_session()
```
