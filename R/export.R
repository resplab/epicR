#' Runs the model and exports an excel file with all output data
#' @param nPaients number of agents
#' @return an excel file with all output
#' @export
export_run <- function(nPatients = 10^4) {

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- nPatients
  settings$event_stack_size <- nPatients * 1.7 * 30
  init_session(settings = settings)
  input <- model_input$values

  run(input=input)

  ## Create Workbook object and add worksheets
  wb <- openxlsx::createWorkbook()

  ## Add worksheets
  addWorksheet(wb, "COPD_incidence_by_year_sex")
  addWorksheet(wb, "COPD_incidence_by_age_sex")
  addWorksheet(wb, "COPD_prevalence_by_year_sex")
  addWorksheet(wb, "COPD_incidence_by_age_group_sex")
  addWorksheet(wb, "Prev_Age_Group_CanCOLD-BOLD")
  addWorksheet(wb, "COPD_prev_by_age_group_GOLD")
  addWorksheet(wb, "COPD_mortality_cause_death")
  addWorksheet(wb, "Age-specific-Mortality-per1000")
  addWorksheet(wb, "Cost_by_GOLD")
  addWorksheet(wb, "QALY_by_GOLD")
  addWorksheet(wb, "Clinical_trials")
  addWorksheet(wb, "GOLD_stage_by_year")
  addWorksheet(wb, "GOLD_by_sex_CanCOLD")
  addWorksheet(wb, "FEV1_by_sex_year")
  addWorksheet(wb, "Exacerbation_severity_by_year_sex_Comp_MARCO")
  addWorksheet(wb, "Exacerbation_rate_GOLD_stage")
  addWorksheet(wb, "Exac_by_type_sex_year")
  addWorksheet(wb, "Population_by_year")
  addWorksheet(wb, "Exac_by_age_year")
  addWorksheet(wb, "Smokers_by_year")

  ## Save workbook
  ## Open in excel without saving file: openXL(wb)
  wbfilename <- c(Sys.Date(), " Output EpicR ver", packageVersion("epicR"))
  saveWorkbook(wb, "writeDataExample.xlsx", overwrite = TRUE)

  terminate_session()
  }
