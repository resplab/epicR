## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(rmarkdown.html_vignette.check_title = FALSE)


## ----eval=FALSE, echo=TRUE----------------------------------------------------
# install.packages('remotes')

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# remotes::install_github('resplab/epicR')

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# install.packages('remotes')

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# remotes::install_github('resplab/epicR')

## ----eval = FALSE, echo = TRUE------------------------------------------------
# library(epicR)

## ----eval = FALSE, echo = TRUE------------------------------------------------
# init_session()

## ----eval = FALSE, echo = TRUE------------------------------------------------
# input <- get_input()

## ----eval=FALSE, echo=FALSE---------------------------------------------------
# library(htmltools)
# includeCSS("html/section-3/style-table.css")
# rawHTML <- paste(readLines("html/section-3/set-inputs.html"), collapse="\n")
# HTML(rawHTML)

## ----eval = FALSE, echo = TRUE------------------------------------------------
# #changing time_horizon which can be accessed through global_parameters
# input$values$global_parameters$time_horizon <- 5
# #changing age0, which can be accessed through global_parameters, from the default value of 40 to 50
# input$values$global_parameters$age0 <- 50
# #changing p_females, which can be accessed through agent, from the default value 0.5 to 0.6.
# input$values$agent$p_female <- 0.6

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# #to run the simulation with default parameters
# run()
# #to run the simulation with custom parameters
# run(max_n_agents = 1000, input = input$values)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# results <- Cget_output()

## ----eval=FALSE, echo=FALSE---------------------------------------------------
# library(htmltools)
# includeCSS("html/section-3/style-table.css")
# rawHTML <- paste(readLines("html/section-3/main-results.html"), collapse="\n")
# HTML(rawHTML)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# resultsExra <- Cget_output_ex()

## ----eval=FALSE, echo=FALSE---------------------------------------------------
# library(htmltools)
# includeCSS("html/section-3/style-table.css")
# rawHTML <- paste(readLines("html/section-3/ex-results.html"), collapse="\n")
# HTML(rawHTML)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# init_session()
# input <- get_input()
# input$values$global_parameters$time_horizon <- 5
# run(input=input$values)
# results <- Cget_output()
# resultsExra <- Cget_output_ex()
# terminate_session()

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# settings <- get_default_settings()
# # record_mode = 2 indicates recording every event that occurs
# settings$record_mode <- 2
# #n_base_agents is the number of people at time 0.
# settings$n_base_agents <- 1e4
# init_session(settings = settings)
# run()
# results <- Cget_output()
# events <- as.data.frame(Cget_all_events_matrix())
# head(events)
# terminate_session()

## ----eval=FALSE, echo=FALSE---------------------------------------------------
# library(htmltools)
# includeCSS("html/section-3/style-mini-table.css")
# rawHTML <- paste(readLines("html/section-3/record_mode.html"), collapse="\n")
# HTML(rawHTML)

## ----eval=FALSE, echo=FALSE---------------------------------------------------
# library(htmltools)
# includeCSS("html/section-3/style-table.css")
# rawHTML <- paste(readLines("html/section-3/event-matrix-cols.html"), collapse="\n")
# HTML(rawHTML)

## ----eval=FALSE, echo=FALSE---------------------------------------------------
# library(htmltools)
# includeCSS("html/section-3/style-mini-table.css")
# rawHTML <- paste(readLines("html/section-3/events.html"), collapse="\n")
# HTML(rawHTML)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# library(epicR)
# input <- get_input(closed_cohort = 1)$values
# init_session()
# run(input=input)
# Cget_output()
# terminate_session()

