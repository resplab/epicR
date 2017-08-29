#' Runs the model and exports an excel file with all output data
#' @param nPatients number of agents
#' @return an excel file with all output
#' @export
export_figures <- function(nPatients = 10^4) {

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- nPatients
  settings$event_stack_size <- nPatients * 1.7 * 30
  init_session(settings = settings)
  input <- model_input$values

  run(input=input)
  data <- as.data.frame(Cget_all_events_matrix())
  op <- Cget_output()
  op_ex <- Cget_output_ex()
  terminate_session()

  ## Create Workbook object and add worksheets
  wb <- openxlsx::createWorkbook()

  ## Add worksheets
  openxlsx::addWorksheet(wb, "List of Figures")
  openxlsx::addWorksheet(wb, "COPD_incidence_by_year_sex")
  openxlsx::addWorksheet(wb, "COPD_incidence_by_age_sex")
  openxlsx::addWorksheet(wb, "COPD_prevalence_by_year_sex")
  openxlsx::addWorksheet(wb, "COPD_incidence_by_age_group_sex")
  openxlsx::addWorksheet(wb, "Prev_Age_Group_CanCOLD-BOLD")
  openxlsx::addWorksheet(wb, "COPD_prev_by_age_group_GOLD")
  openxlsx::addWorksheet(wb, "COPD_mortality_cause_death")
  openxlsx::addWorksheet(wb, "Age-specific-Mortality-per1000")
  openxlsx::addWorksheet(wb, "Cost_by_GOLD")
  openxlsx::addWorksheet(wb, "QALY_by_GOLD")
  openxlsx::addWorksheet(wb, "Clinical_trials")
  openxlsx::addWorksheet(wb, "GOLD_stage_by_year")
  openxlsx::addWorksheet(wb, "GOLD_by_sex_CanCOLD")
  openxlsx::addWorksheet(wb, "FEV1_by_sex_year")
  openxlsx::addWorksheet(wb, "Exacerbation")
  openxlsx::addWorksheet(wb, "Exac_rate_GOLD_stage")
  openxlsx::addWorksheet(wb, "Exac_by_type_sex_year")
  openxlsx::addWorksheet(wb, "Population_by_year")
  openxlsx::addWorksheet(wb, "Exac_by_age_year")
  openxlsx::addWorksheet(wb, "Smokers_by_year")

  ## Populate workbooks

  ## COPD Incidence per year and sex
  COPD_inc_by_sex <- matrix (NA, nrow = input$global_parameters$time_horizon, ncol = 3)
  colnames(COPD_inc_by_sex) <- c("Year", "Male", "Female")
  COPD_inc_by_sex[1:input$global_parameters$time_horizon, 1] <- c(2015:(2015+input$global_parameters$time_horizon-1))

  data_COPD_inc <- subset(data, event == 4)

  for (i in 1:input$global_parameters$time_horizon){
    COPD_inc_by_sex[i, 2] <- dim(subset(data_COPD_inc, (sex == 0)))[1]
    COPD_inc_by_sex[i, 3] <- dim(subset(data_COPD_inc, (sex == 1)))[1]
  }
  COPD_inc_by_sex[1:input$global_parameters$time_horizon, 2:3] <- COPD_inc_by_sex[1:input$global_parameters$time_horizon, 2:3] / op_ex$n_alive_by_ctime_sex

  openxlsx::writeData(wb, "COPD_incidence_by_year_sex", COPD_inc_by_sex, startCol = 2, startRow = 3, colNames = TRUE)

  df <- as.data.frame(COPD_inc_by_sex)
  dfm <- reshape2::melt(df[,c('Year','Male','Female')], id.vars = 1)
  plot_COPD_inc_by_sex <- ggplot2::ggplot(dfm, aes(x = Year, y = value)) +
    geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + ylim(low=0, high=0.5) + labs(title = "Incidence of COPD") + ylab ("COPD Incidence") + labs(caption = "(based on population at age 40 and above)")

  print(plot_COPD_inc_by_sex) #plot needs to be showing
  openxlsx::insertPlot(wb, "COPD_incidence_by_year_sex",  xy = c("J", 10), width = 20, height = 13.2 , fileType = "png", units = "cm")
#  rm(COPD_inc_by_sex, data_COPD_inc, plot_COPD_inc_by_sex)

  ## COPD Prevalence per year and sex
  COPD_prev_by_sex <- matrix (NA, nrow = input$global_parameters$time_horizon, ncol = 3)
  colnames(COPD_prev_by_sex) <- c("Year", "Male", "Female")
  COPD_prev_by_sex[1:input$global_parameters$time_horizon, 1] <- c(2015:(2015+input$global_parameters$time_horizon-1))
  COPD_prev_by_sex[1:input$global_parameters$time_horizon,2:3] <- op_ex$n_COPD_by_ctime_sex / op_ex$n_alive_by_ctime_sex
  openxlsx::writeData(wb, "COPD_prevalence_by_year_sex", COPD_prev_by_sex, startCol = 2, startRow = 3, colNames = TRUE)

  df <- as.data.frame(COPD_prev_by_sex)
  dfm <- reshape2::melt(df[,c('Year','Male','Female')],id.vars = 1)
  plot_COPD_prev_by_sex <- ggplot2::ggplot(dfm, aes(x = Year, y = value)) +
    geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + ylim(low=0, high=0.5) + labs(title = "Prevalence of COPD") + ylab ("Prevalence") + labs(caption = "(based on population at age 40 and above)")

  print(plot_COPD_prev_by_sex) #plot needs to be showing
  openxlsx::insertPlot(wb, "COPD_prevalence_by_year_sex",  xy = c("J", 10), width = 20, height = 13.2 , fileType = "png", units = "cm")


  ## FEV1 by sex and COPD year
  fev1_by_sex <- matrix (NA, nrow = input$global_parameters$time_horizon+1, ncol = 4)
  colnames(fev1_by_sex) <- c("Year_with_COPD", "Male", "Female", "All")
  fev1_by_sex[1:(input$global_parameters$time_horizon+1), 1] <- 1:(input$global_parameters$time_horizon+1)
  data_COPD <- subset (data, gold > 0)

  for (i in 0:input$global_parameters$time_horizon) {
    temp_data_COPD_years <- subset(data, ((followup_after_COPD == i) & (sex == 0)))
    fev1_by_sex[i+1, 2] <- mean (temp_data_COPD_years[,"FEV1"])

    temp_data_COPD_years <- subset(data, ((followup_after_COPD == i) & (sex == 1)))
    fev1_by_sex[i+1, 3] <- mean (temp_data_COPD_years[,"FEV1"])

    temp_data_COPD_years <- subset(data, followup_after_COPD == i)
    fev1_by_sex[i+1, 4] <- mean (temp_data_COPD_years[,"FEV1"])
  }

  openxlsx::writeData(wb, "FEV1_by_sex_year", fev1_by_sex, startCol = 2, startRow = 3, colNames = TRUE)

  df <- as.data.frame(fev1_by_sex)
  dfm <- reshape2::melt(df[,c('Year_with_COPD','Male','Female', "All")],id.vars = 1)
#  plot_fev1_by_sex <- ggplot2::ggplot(dfm, aes(x = Year_with_COPD, y = value)) +
  #  geom_point(aes(), stat = "identity", position = "dodge") + ylim(low=0, high=0.5)
  plot_fev1_by_sex <- ggplot2::ggplot(dfm, aes(Year_with_COPD, value, colour = variable)) +
    geom_point() + labs(title = "Mean FEV1 by Number of Years with COPD") + ylab ("FEV1 (L)")
  print(plot_fev1_by_sex) #plot needs to be showing
  openxlsx::insertPlot(wb, "FEV1_by_sex_year",  xy = c("J", 10), width = 20, height = 13.2 , fileType = "png", units = "cm")


  ## Save workbook
  ## Open in excel without saving file: openXL(wb)
  wbfilename <- paste(Sys.Date(), " Figures EpicR ver", packageVersion("epicR"), ".xlsx")
  openxlsx::saveWorkbook(wb, wbfilename, overwrite = TRUE)

  }
