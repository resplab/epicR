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

  wb <- openxlsx::createWorkbook()

  terminate_session()
  }
