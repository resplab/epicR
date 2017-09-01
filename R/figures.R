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
  openxlsx::addWorksheet(wb, "COPD_incidence_by_age_sex")
  openxlsx::addWorksheet(wb, "COPD_incidence_by_year_sex")
  openxlsx::addWorksheet(wb, "COPD_incidence_by_age_group_sex")
  openxlsx::addWorksheet(wb, "COPD_prevalence_by_year_sex")
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
  #######################################################  COPD_incidence_by_age  #####################################################
  COPD_inc_by_age_sex <- matrix (NA, nrow = 90-40+1, ncol = 1) #limiting it to people under 90 years old to avoid noise error
  #  colnames(COPD_inc_by_age_sex) <- c("Age", "Incidence")
  #  COPD_inc_by_age_sex[1:(110-40+1), 1] <- c(40:110)
  COPD_inc_by_age_sex <-  colSums(as.data.frame (op_ex$n_inc_COPD_by_ctime_age)[40:90]) / colSums(as.data.frame (op_ex$n_alive_by_ctime_age)[40:90])
  n_COPD_inc_by_age <- as.data.frame(colSums(as.data.frame (op_ex$n_inc_COPD_by_ctime_age)[40:90]))
  COPD_inc_by_age_sex <- as.data.frame(COPD_inc_by_age_sex) * 100 #converting values to percentage.
  alive_by_age <- as.data.frame(colSums(as.data.frame (op_ex$n_alive_by_ctime_age))[40:90])
  SE_COPD_inc_by_age_sex <- sqrt (COPD_inc_by_age_sex * (100 - COPD_inc_by_age_sex) / alive_by_age)

  df <- data.frame(Age = c(40:90), Incidence = COPD_inc_by_age_sex)
  colnames(df) <- c("Age", "Incidence")
  openxlsx::writeData(wb, "COPD_incidence_by_age_sex", df  , startCol = 2, startRow = 3, colNames = TRUE)

  plot_COPD_inc_by_age_sex  <- ggplot(df, aes(x = Age, y = Incidence)) +
    geom_bar(stat = "identity", position = "dodge",  fill = "#FF6666") +
    geom_errorbar(aes(ymin = Incidence - 1.96*SE_COPD_inc_by_age_sex, ymax = Incidence + 1.96*SE_COPD_inc_by_age_sex), width=.2, position = position_dodge(.9)) +
     labs(title = "Incidence of COPD by Age") + ylab ("COPD Incidence (%)") + labs(caption = "(based on population at age 40 and above)")

  print(plot_COPD_inc_by_age_sex ) #plot needs to be showing
  openxlsx::insertPlot(wb, "COPD_incidence_by_age_sex",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")



  ####################################################### COPD_incidence_by_age_group_sex #######################################################
  COPD_inc_by_age <- as.data.frame (op_ex$n_inc_COPD_by_ctime_age)
  alive_by_age <- as.data.frame (op_ex$n_alive_by_ctime_age)
  COPD_inc_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+
  num_COPD_inc_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+
  denom_COPD_inc_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+

  for (i in 1:5) {
    for (j in 0:9){
      num_COPD_inc_by_agegroup [i] <- num_COPD_inc_by_agegroup [i] + colSums(COPD_inc_by_age[10*(3+i)+j])
      denom_COPD_inc_by_agegroup [i] <- denom_COPD_inc_by_agegroup[i] + colSums(alive_by_age[10*(3+i)+j])
    }
  }

  #handling the special case of 90-110 years, ie: i=4
  for (j in 0:20){
    num_COPD_inc_by_agegroup [6] <- num_COPD_inc_by_agegroup [6] + colSums(COPD_inc_by_age[10*(3+6)+j])
    denom_COPD_inc_by_agegroup [6] <-denom_COPD_inc_by_agegroup [6] + colSums(alive_by_age[10*(3+6)+j])
  }

  COPD_inc_by_agegroup  <- num_COPD_inc_by_agegroup / denom_COPD_inc_by_agegroup

  COPD_inc_by_agegroup <- as.data.frame(COPD_inc_by_agegroup ) * 100 #converting into percentage
  SE_COPD_inc_by_agegroup <- sqrt (COPD_inc_by_agegroup  * (100 - COPD_inc_by_agegroup ) / denom_COPD_inc_by_agegroup)

  df <- data.frame(Age_Group = c("40-50", "50-60", "60-70", "70-80", "80-90", "90+"), Incidence = COPD_inc_by_agegroup) #converting values to percentage.
  colnames(df) <- c("Age_Group", "Incidence")
  openxlsx::writeData(wb, "COPD_incidence_by_age_group_sex", df  , startCol = 2, startRow = 3, colNames = TRUE)

  plot_COPD_inc_by_agegroup  <- ggplot(df, aes(x = Age_Group, y = Incidence)) +
    geom_bar(stat = "identity", position = "dodge", width = 0.2,  fill = "#FF6666") +
      geom_errorbar(aes(ymin = Incidence - 1.96*SE_COPD_inc_by_agegroup, ymax = Incidence + 1.96*SE_COPD_inc_by_agegroup), width=.2, position = position_dodge(.9)) +
      ylim(low = 0, high = 5) + labs(title = "Incidence of COPD by Age Group") + ylab ("COPD Incidence (%)") + labs(caption = "(based on population at age 40 and above)")

  print(plot_COPD_inc_by_agegroup ) #plot needs to be showing
  openxlsx::insertPlot(wb, "COPD_incidence_by_age_group_sex",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")



  ####################################################### COPD_Incidence_by_year_sex  #####################################################
  COPD_inc_by_year_sex <- matrix (NA, nrow = input$global_parameters$time_horizon, ncol = 3)
  SE_COPD_inc_by_year_sex <- matrix (NA, nrow = input$global_parameters$time_horizon, ncol = 2)

  colnames(COPD_inc_by_year_sex) <- c("Year", "Male", "Female")
  colnames(SE_COPD_inc_by_year_sex) <- c("Male", "Female")

  COPD_inc_by_year_sex[1:input$global_parameters$time_horizon, 1] <- c(2015:(2015+input$global_parameters$time_horizon-1))

  data_COPD_inc <- subset(data, event == 4)

  for (i in 1:input$global_parameters$time_horizon){
    COPD_inc_by_year_sex [i, 2] <- dim(subset(data_COPD_inc, (sex==00 & local_time == i) ))[1]
    COPD_inc_by_year_sex [i, 3] <- dim(subset(data_COPD_inc, (sex == 1 & local_time == i)))[1]
  }
  COPD_inc_by_year_sex [1:input$global_parameters$time_horizon, 2:3] <- COPD_inc_by_year_sex [1:input$global_parameters$time_horizon, 2:3] / op_ex$n_alive_by_ctime_sex * 100 #converting to percentage
  SE_COPD_inc_by_year_sex [1:input$global_parameters$time_horizon, 1:2] <- sqrt (COPD_inc_by_year_sex [1:input$global_parameters$time_horizon, 2:3] * (100 - COPD_inc_by_year_sex [1:input$global_parameters$time_horizon, 2:3]) / op_ex$n_alive_by_ctime_sex) #TODO Make sure it's correct and add it to ggplot.

  openxlsx::writeData(wb, "COPD_incidence_by_year_sex", COPD_inc_by_year_sex , startCol = 2, startRow = 3, colNames = TRUE)

  df <- as.data.frame(COPD_inc_by_year_sex)
  dfm <- reshape2::melt(df[,c('Year','Male','Female')], id.vars = 1)
  plot_COPD_inc_by_year_sex <- ggplot2::ggplot(dfm, aes(x = Year, y = value)) +
    geom_bar(aes(fill = variable), stat = "identity", position = "dodge") +
    ylim(low=0, high=50) + labs(title = "Incidence of COPD by Year") + ylab ("COPD Incidence (%)") + labs(caption = "(based on population at age 40 and above)")

  print(plot_COPD_inc_by_year_sex ) #plot needs to be showing
  openxlsx::insertPlot(wb, "COPD_incidence_by_year_sex",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")
  rm(data_COPD_inc)


  ####################################################### COPD Prevalence per year and sex  #####################################################
  COPD_prev_by_sex <- matrix (NA, nrow = input$global_parameters$time_horizon, ncol = 3)
  colnames(COPD_prev_by_sex) <- c("Year", "Male", "Female")
  COPD_prev_by_sex[1:input$global_parameters$time_horizon, 1] <- c(2015:(2015+input$global_parameters$time_horizon-1))
  COPD_prev_by_sex[1:input$global_parameters$time_horizon,2:3] <- op_ex$n_COPD_by_ctime_sex / op_ex$n_alive_by_ctime_sex * 100 #converting to percentage
  openxlsx::writeData(wb, "COPD_prevalence_by_year_sex", COPD_prev_by_sex, startCol = 2, startRow = 3, colNames = TRUE)

  df <- as.data.frame(COPD_prev_by_sex)
  dfm <- reshape2::melt(df[,c('Year','Male','Female')],id.vars = 1)
  plot_COPD_prev_by_sex <- ggplot2::ggplot(dfm, aes(x = Year, y = value)) +
    geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + ylim(low=0, high=50) + labs(title = "Prevalence of COPD by Year") + ylab ("Prevalence (%)") + labs(caption = "(based on population at age 40 and above)")

  print(plot_COPD_prev_by_sex) #plot needs to be showing
  openxlsx::insertPlot(wb, "COPD_prevalence_by_year_sex",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")



  ##################################################### COPD Prevalence by Age Group and Sex #####################################################

  COPD_by_ctime_age <- as.data.frame(op_ex$n_COPD_by_ctime_age)
  alive_by_ctime_age <- as.data.frame(op_ex$n_alive_by_ctime_age)
  COPD_prev_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+
  num_COPD_prev_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+
  denom_COPD_prev_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+


  for (i in 1:5) {
    for (j in 0:9){
      num_COPD_prev_by_agegroup [i] <- num_COPD_prev_by_agegroup [i] + colSums(COPD_by_ctime_age[10*(3+i)+j])
      denom_COPD_prev_by_agegroup [i] <- denom_COPD_prev_by_agegroup [i] + colSums(alive_by_ctime_age[10*(3+i)+j])
    }
  }

  #handling the special case of 90-110 years, ie: i=4
  for (j in 0:20){
    num_COPD_prev_by_agegroup [6] <- num_COPD_prev_by_agegroup [6] + colSums(COPD_by_ctime_age[10*(3+6)+j])
    denom_COPD_prev_by_agegroup [6] <- denom_COPD_prev_by_agegroup [6] + colSums(alive_by_ctime_age[10*(3+6)+j])
  }

  COPD_prev_by_agegroup <- num_COPD_prev_by_agegroup / denom_COPD_prev_by_agegroup * 100 #converting into percentage
  SE_COPD_prev_by_agegroup <- sqrt (COPD_prev_by_agegroup*(100-COPD_prev_by_agegroup)/denom_COPD_prev_by_agegroup)

  df <- data.frame(Age_Group = c("40-50", "50-60", "60-70", "70-80", "80-90", "90+"), Prevalence = COPD_prev_by_agegroup)
  openxlsx::writeData(wb, "Prev_Age_Group_CanCOLD-BOLD", df, startCol = 2, startRow = 3, colNames = TRUE)

  plot_COPD_prev_by_agegroup  <- ggplot2::ggplot(df, aes(x = Age_Group, y = Prevalence)) +
    geom_bar(stat = "identity", position = "dodge", width = 0.2, fill = "#FF6666") + geom_errorbar(aes(ymin = Prevalence - 1.96*SE_COPD_prev_by_agegroup, ymax = Prevalence + 1.96*SE_COPD_prev_by_agegroup ),
                                                                                                       width=.2, position=position_dodge(.9)) + ylim(low = 0, high = 50) + labs (title = "Prevalence of COPD by Age Group") + ylab ("Prevalence (%)") + labs(caption = "(error bars represent 95% CI)")

  print(plot_COPD_prev_by_agegroup) #plot needs to be showing
  openxlsx::insertPlot(wb, "Prev_Age_Group_CanCOLD-BOLD",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")

  ##################################################### COPD Prevalence by Age Group and GOLD #####################################################

  #COPD_prev_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+
  #num_COPD_prev_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+
  #denom_COPD_prev_by_agegroup <- matrix (0, nrow = 6, ncol = 1) #40-50, 50-60, 60-70, 70-80,  80-90, 90+


  #df <- data.frame(Age_Group = c("40-50", "50-60", "60-70", "70-80", "80-90", "90+"), Prevalence = COPD_prev_by_agegroup)
  #openxlsx::writeData(wb, "COPD_prev_by_age_group_GOLD", df, startCol = 2, startRow = 3, colNames = TRUE)

  #plot_COPD_prev_by_agegroup  <- ggplot2::ggplot(df, aes(x = Age_Group, y = Prevalence)) +
   # geom_bar(stat = "identity", position = "dodge", width = 0.2, fill = "#FF6666") + geom_errorbar(aes(ymin = Prevalence - 1.96*SE_COPD_prev_by_agegroup, ymax = Prevalence + 1.96*SE_COPD_prev_by_agegroup ),
  #                                                                                                 width=.2, position=position_dodge(.9)) + ylim(low = 0, high = 50) + labs (title = "Prevalence of COPD by Age Group") + ylab ("Prevalence (%)") + labs(caption = "(error bars represent 95% CI)")

  #print(plot_COPD_prev_by_agegroup) #plot needs to be showing
  #openxlsx::insertPlot(wb, "COPD_prev_by_age_group_GOLD",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")



  ##################################################### FEV1 by sex and COPD year #####################################################

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

  plot_fev1_by_sex <- ggplot2::ggplot(dfm, aes(Year_with_COPD, value, colour = variable)) +
    geom_point() + labs(title = "Mean FEV1 by Number of Years with COPD") + ylab ("FEV1 (L)")
  print(plot_fev1_by_sex) #plot needs to be showing
  openxlsx::insertPlot(wb, "FEV1_by_sex_year",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")


  ##################################################### Smokers_by_Year #####################################################
  smokers_by_year <- matrix (NA, nrow = input$global_parameters$time_horizon+1, ncol = 5)
  colnames(smokers_by_year) <- c("Year", "Never_Smoked", "Former_Smoker", "Smoker", "All")
  data_annual <- subset (data, event == 1)

  for (i in (1:input$global_parameters$time_horizon)) {
    smokers_by_year[i, 2] <- dim(subset(data_annual, ( smoking_status == 0) & (pack_years == 0) & (local_time == i)))[1]
    smokers_by_year[i, 3] <- dim(subset(data_annual, ((smoking_status == 0) & (pack_years > 0)& (local_time == i))))[1]
    smokers_by_year[i, 4] <- dim(subset(data_annual, ((smoking_status > 0)& (local_time == i))))[1]
    smokers_by_year[i, 5] <- dim(subset(data_annual, (local_time == i)))[1]
  }

  smokers_by_year <- 100 * smokers_by_year / smokers_by_year [, 5]
  smokers_by_year[1:input$global_parameters$time_horizon, 1] <- c(2015:(2015+input$global_parameters$time_horizon-1))
  smokers_by_year <- as.data.frame(smokers_by_year)
  openxlsx::writeData(wb, "Smokers_by_year", smokers_by_year, startCol = 2, startRow = 3, colNames = TRUE)
  dfm <- reshape2::melt(smokers_by_year[,c("Year", "Never_Smoked", "Former_Smoker", "Smoker", "All")],id.vars = 1)

  plot_smokers_by_year <- ggplot2::ggplot(smokers_by_year, aes( x = Year , y = Smoker, colour = "#FF6666")) +
    geom_point() + labs(title = "Current Smoker Ratio") + ylab ("Current Smoker (%)") + ylim(low=0, high=25)
#  plot_smokers_by_year <- qplot(Year, Smoker, data = smokers_by_year)

  print(plot_smokers_by_year) #plot needs to be showing
  openxlsx::insertPlot(wb, "Smokers_by_year",  xy = c("G", 3), width = 20, height = 13.2 , fileType = "png", units = "cm")





  ####################################################### Save workbook #####################################################
  ## Open in excel without saving file: openXL(wb)
  wbfilename <- paste(Sys.Date(), " Figures EpicR ver", packageVersion("epicR"), ".xlsx")
  openxlsx::saveWorkbook(wb, wbfilename, overwrite = TRUE)

  }
