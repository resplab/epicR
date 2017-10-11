#' @export
report_exacerbation_by_time_base <- function(n_sim=10^5){
  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- settings$n_base_agents * 0

  init_session(settings = settings)

  run()

  op <- Cget_output()
  opx <- Cget_output_ex()

  cat("Annual rate of exacerbation:", sum(opx$n_exac_by_ctime_severity)/(op$cumul_time - opx$cumul_non_COPD_time), "\n")
  cat("Annual rate of exacerbation by severity:", colSums(opx$n_exac_by_ctime_severity)/(op$cumul_time - opx$cumul_non_COPD_time),
      "\n")

  exacerbation <- list("op"=op,"opx"=opx, "settings"=settings)
  terminate_session()

  return(exacerbation)

}

# Annual exacerbation rate over 20 years all population
#'@export
report_exacerbation_by_time_entire_all <- function(exacerbation){

  opx <- exacerbation$opx
  y <- rowSums(opx$n_exac_by_ctime_severity)/rowSums(opx$n_alive_by_ctime_sex)
  x <- 2015:2034

  data <- data.frame(x,y)
  names(data) <- c("year", "incidence")
  #p <- plot(2015:2034, y, type = "l", ylim = c(0, max(y)), xlab = "Year", ylab = "Annual incidence")
  #title(cex.main = 0.5, "Exacerbation rate over time (across population)")
  p <- plot_ly(data, x= ~year, y = ~incidence, type='scatter', mode='lines', line = list(color = toRGB("#009E73"))) %>%
    layout(yaxis=list(title='Annual Incidence (%)'),
           xaxis=list(title='Year', type='category', categoryorder='trace'),
           #title='Exacerbation rate over time (across population)',
           hovermode='x') #%>% config(displaylogo=F, modeBarButtonsToRemove=buttonremove)

  return(p)
}

# Annual exacerbation rate over 20 years all population by age group
report_exacerbation_by_time_entire_age <- function(exacerbation){

  opx <- exacerbation$opx

  g1 <- 41:55
  g2 <- 56:70
  g3 <- 71:84
  g4 <- 85:111

  a <- opx$n_exac_by_ctime_age
  b <- opx$n_alive_by_ctime_age
  y1 <- rowSums(a[, g1])/rowSums(b[, g1])
  y2 <- rowSums(a[, g2])/rowSums(b[, g2])
  y3 <- rowSums(a[, g3])/rowSums(b[, g3])
  y4 <- rowSums(a[, g4])/rowSums(b[, g4])
  max_y <- max(c(y1, y2, y3, y4))

  x <- 2015:2034

  data <- data.frame(x,y1,y2,y3,y4)
  names(data) <- c("year", "y1", "y2", "y3", "y4")

  p <- plot_ly(data, x= ~year, y = ~y1, type='scatter', name='40-54',mode='lines', line = list(color = toRGB("#009E73"))) %>%
    add_trace(y = ~y2, name='55-64', line = list(color = toRGB("#E69F00"))) %>%
    add_trace(y = ~y3, name='65-74', line = list(color = toRGB("#D55E00"))) %>%
    add_trace(y = ~y4, name='75+', line = list(color = toRGB("#4286f4"))) %>%
    layout(yaxis=list(title='Annual Incidence (%)'),
           xaxis=list(title='Year', type='category', categoryorder='trace'),
           title='Exacerbation rate by age group (across population)',
           hovermode='x') #%>% config(displaylogo=F, modeBarButtonsToRemove=buttonremove)
  return(p)
}

# Annual exacerbation rate over 20 years just COPD population
report_exacerbation_by_time_copd_all <- function(exacerbation){

  opx <- exacerbation$opx
  y <- rowSums(opx$n_exac_by_ctime_severity)/rowSums(opx$n_COPD_by_ctime_sex)

  x <- 2015:2034

  data <- data.frame(x,y)
  names(data) <- c("year", "incidence")
  p <- plot_ly(data, x= ~year, y = ~incidence, type='scatter', mode='lines', line = list(color = toRGB("#009E73"))) %>%
    layout(yaxis=list(title='Annual Incidence (%)'),
           xaxis=list(title='Year', type='category', categoryorder='trace'),
           title='Exacerbation rate over time (within COPD)',
           hovermode='x') #%>% config(displaylogo=F, modeBarButtonsToRemove=buttonremove)

  return(p)

}

#Annual exacerbation rate over 20 years just COPD by age group
report_exacerbation_by_time_copd_age <- function(exacerbation){

  opx <- exacerbation$opx

  g1 <- 41:55
  g2 <- 56:70
  g3 <- 71:84
  g4 <- 85:111

  a <- opx$n_exac_by_ctime_age
  b <- opx$n_COPD_by_ctime_age
  y1 <- rowSums(a[, g1])/rowSums(b[, g1])
  y2 <- rowSums(a[, g2])/rowSums(b[, g2])
  y3 <- rowSums(a[, g3])/rowSums(b[, g3])
  y4 <- rowSums(a[, g4])/rowSums(b[, g4])
  max_y <- max(c(y1, y2, y3, y4))

  x <- 2015:2034

  data <- data.frame(x,y1,y2,y3,y4)
  names(data) <- c("year", "y1", "y2", "y3", "y4")

  p <- plot_ly(data, x= ~year, y = ~y1, type='scatter', name='40-54',mode='lines', line = list(color = toRGB("#009E73"))) %>%
    add_trace(y = ~y2, name='55-64', line = list(color = toRGB("#E69F00"))) %>%
    add_trace(y = ~y3, name='65-74', line = list(color = toRGB("#D55E00"))) %>%
    add_trace(y = ~y4, name='75+', line = list(color = toRGB("#4286f4"))) %>%
    layout(yaxis=list(title='Annual Incidence (%)'),
           xaxis=list(title='Year', type='category', categoryorder='trace'),
           title='Exacerbation rate by age group (within COPD)',
           hovermode='x') #%>% config(displaylogo=F, modeBarButtonsToRemove=buttonremove)
  return(p)
}

# Annual exacerbation rate over 20 years just COPD by exacerbation severity
report_exacerbation_by_time_copd_severity <- function(exacerbation){

  opx <- exacerbation$opx
  a <- opx$n_exac_by_ctime_severity
  b <- opx$n_COPD_by_ctime_sex
  y1 <- (a[, 1])/rowSums(b)
  y2 <- (a[, 2])/rowSums(b)
  y3 <- (a[, 3] + a[, 4])/rowSums(b)
  max_y <- max(c(y1, y2, y3))
  x <- c(2015:2034)
  data <- data.frame(x, y1,y2,y3)
  names(data) <- c("year", "y1", "y2", "y3")

  p <- plot_ly(data, x= ~year, y= ~y1, type='scatter', name='Mild', mode='lines', line=list(color = toRGB("#009E73"))) %>%
    add_trace(y = ~y2, name='Moderate', line = list(color = toRGB("#E69F00"))) %>%
    add_trace(y = ~y3, name='Severe and Very Severe', line = list(color = toRGB("#D55E00"))) %>%
    layout(yaxis=list(title='Annual Incidence (%)'),
           xaxis=list(title='Year', type='category', categoryorder='trace'),
           title='Exacerbation rate by exacerbation severity (within COPD)',
           hovermode='x') #%>% config(displaylogo=F, modeBarButtonsToRemove=buttonremove)

  #pie(colSums(opx$n_exac_by_ctime_severity), labels = c("Mild", "Moderate", "severe", "very severe"))


  cat("Proportion by exacerbation severity:", format(colSums(opx$n_exac_by_ctime_severity/sum(opx$n_exac_by_ctime_severity)),
                                                     digits = 2), "\n")
  #terminate_session()

  return(p)
}


# testing <- function(exacerbation){
#   n_sim=10^2
#   init_session()
#   run(n_sim)
#   all_events <- as.data.frame(Cget_all_events_matrix())
#   print(dim(all_events))
#   return(all_events)
# }

# Annual exacerbation rate over 20 years just COPD by GOLD stage
report_exacerbation_by_time_copd_gold <- function(exacerbation){

  n_sim=10^2
  init_session()
  run(n_sim)
  all_events <- as.data.frame(Cget_all_events_matrix())
  print(dim(all_events))
  exac_events <- subset(all_events, event == 5)
  exit_events <- subset(all_events, event == 14)

  Follow_up_Gold <- c(0, 0, 0, 0)
  last_GOLD_transition_time <- 0
  for (i in 2:dim(all_events)[1]) {
    if (all_events[i, "id"] != all_events[i - 1, "id"])
      last_GOLD_transition_time <- 0
    if ((all_events[i, "id"] == all_events[i - 1, "id"]) & (all_events[i, "gold"] != all_events[i - 1, "gold"])) {
      Follow_up_Gold[all_events[i - 1, "gold"]] = Follow_up_Gold[all_events[i - 1, "gold"]] + all_events[i - 1, "followup_after_COPD"] -
        last_GOLD_transition_time
      last_GOLD_transition_time <- all_events[i - 1, "followup_after_COPD"]
    }
    if (all_events[i, "event"] == 14)
      Follow_up_Gold[all_events[i, "gold"]] = Follow_up_Gold[all_events[i, "gold"]] + all_events[i, "followup_after_COPD"] -
        last_GOLD_transition_time
  }

  terminate_session()

  categories <- c("GOLD I", "GOLD II", "GOLD III and IV")
  y1 <- as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1]
  y2 <- as.data.frame(table(exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2]
  y3 <- (as.data.frame(table(exac_events[, "gold"]))[3, 2] + as.data.frame(table(exac_events[, "gold"]))[4,2])/(Follow_up_Gold[3] + Follow_up_Gold[4])
  y <- c(y1,y2,y3)

  data <- data.frame(categories,y)

  p <- plot_ly(data, labels = ~categories, values = ~y, type = 'pie',
               textposition='inside',
               textinfo='label+percent',
               hoverinfo='text',
               text= '') %>%
    layout(title = 'Rates of exacerbation by GOLD stage (within COPD)',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

  cat("Rates of exacerbation per GOLD stage:\n")
  cat("GOLD I: ", y1, "\n")
  cat("GOLD II: ", y2, "\n")
  cat("GOLD III and IV :", y3,"\n")
  terminate_session()
  return(p)
}
