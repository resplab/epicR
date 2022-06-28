report_mode <- 1
# If 1, we are generating a report!

petoc <- function() {
  if (report_mode == 0) {
    message("Press [Enter] to continue")
    r <- readline()
    if (r == "q") {
      terminate_session()
      stop("User asked for termination.\n")
    }
  }
}


#' Basic tests of model functionalty. Serious issues if the test does not pass.
#' @return tests results
#' @export
sanity_check <- function() {
  init_session()

  message("test 1: zero all costs\n")
  input <- model_input$values
  for (el in get_list_elements(input$cost)) input$cost[[el]] <- input$cost[[el]] * 0
  input$medication$medication_costs <- 0 * input$medication$medication_costs
  res <- run(100, input = input)
  if (Cget_output()$total_cost != 0)
    message("Test failed!") else message("Test passed!")
  terminate_session()


  message("test 2: zero all utilities\n")
  init_session()
  input <- model_input$values
  for (el in get_list_elements(input$utility)) input$utility[[el]] <- input$utility[[el]] * 0
  input$medication$medication_utility <- input$medication$medication_utility*0
  input$global_parameters$discount_qaly <- input$global_parameters$discount_qaly*0
  res <- run(100, input = input)
  if (Cget_output()$total_qaly != 0) {
    message("Test failed!")
    message(Cget_output()$total_qaly)} else message("Test passed!")
  terminate_session()

  message("test 3: one all utilities ad get one QALY without discount\n")
  init_session()
  input <- model_input$values
  input$global_parameters$discount_qaly <- 0
  input$medication$medication_utility <- input$medication$medication_utility*0
  for (el in get_list_elements(input$utility)) input$utility[[el]] <- input$utility[[el]] * 0 + 1
  input$utility$exac_dutil = input$utility$exac_dutil * 0
  res <- run(100, input = input)
  if (Cget_output()$total_qaly/Cget_output()$cumul_time != 1)
    message("Test failed!") else message("Test passed!")
  terminate_session()

  message("test 4: zero mortality (both bg and exac)\n")
  init_session()
  input <- model_input$values
  input$exacerbation$logit_p_death_by_sex <- input$exacerbation$logit_p_death_by_sex * 0 - 10000000  # log scale'
  input$agent$p_bgd_by_sex <- input$agent$p_bgd_by_sex * 0
  input$manual$explicit_mortality_by_age_sex <- input$manual$explicit_mortality_by_age_sex * 0
  res <- run(100, input = input)
  if (Cget_output()$n_deaths != 0) {
    message (Cget_output()$n_deaths)
    stop("Test failed!")
  } else message("Test passed!")
  terminate_session()
  return(0)
}







#' Returns results of validation tests for population module
#' @param incidence_k a number (default=1) by which the incidence rate of population will be multiplied.
#' @param remove_COPD 0 or 1, indicating whether COPD-caused mortality should be removed
#' @param savePlots 0 or 1, exports 300 DPI population growth and pyramid plots comparing simulated vs. predicted population
#' @return validation test results
#' @export
validate_population <- function(remove_COPD = 0, incidence_k = 1, savePlots = 0) {
  message("Validate_population(...) is responsible for producing output that can be used to test if the population module is properly calibrated.\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- 1e+06
  settings$event_stack_size <- 1
  init_session(settings = settings)
  input <- model_input$values  #We can work with local copy more conveniently and submit it to the Run function

  message("\nBecause you have called me with remove_COPD=", remove_COPD, ", I am", c("NOT", "indeed")[remove_COPD + 1], "going to remove COPD-related mortality from my calculations")
  petoc()

  # CanSim.052.0005<-read.csv(system.file ('extdata', 'CanSim.052.0005.csv', package = 'epicR'), header = T); #package ready
  # reading
  x <- aggregate(CanSim.052.0005[, "value"], by = list(CanSim.052.0005[, "year"]), FUN = sum)
  x[, 2] <- x[, 2]/x[1, 2]
  x <- x[1:input$global_parameters$time_horizon, ]
  plot(x, type = "l", ylim = c(0.5, max(x[, 2] * 1.5)), xlab = "Year", ylab = "Relative population size")
  title(cex.main = 0.5, "Relative populaton size")
  message("The plot I just drew is the expected (well, StatCan's predictions) relative population growth from 2015\n")
  petoc()

  if (remove_COPD) {
    input$exacerbation$logit_p_death_by_sex <- -1000 + input$exacerbation$logit_p_death_by_sex
    input$manual$explicit_mortality_by_age_sex <- 0
  }

  input$agent$l_inc_betas[1] <- input$agent$l_inc_betas[1] + log(incidence_k)

  message("working...\n")
  res <- run(input = input)
  if (res < 0) {
    stop("Something went awry; bye!")
    return()
  }

  n_y1_agents <- sum(Cget_output_ex()$n_alive_by_ctime_sex[1, ])
  legend("topright", c("Predicted", "Simulated"), lty = c(1, 1), col = c("black", "red"))

  message("And the black one is the observed (simulated) growth\n")
   ######## pretty population growth curve

  CanSim <- tibble::as_tibble(CanSim.052.0005)
  CanSim <- tidyr::spread(CanSim, key = year, value = value)
  CanSim <- CanSim[, 3:51]
  CanSim <- colSums (CanSim)

  df <- data.frame(Year = c(2015:(2015 + model_input$values$global_parameters$time_horizon-1)), Predicted = CanSim[1:model_input$values$global_parameters$time_horizon] * 1000, Simulated = rowSums(Cget_output_ex()$n_alive_by_ctime_sex)/ settings$n_base_agents * 18179400) #rescaling population. There are about 18.6 million Canadians above 40
  message ("Here's simulated vs. predicted population table:")
  print(df)
  dfm <- reshape2::melt(df[,c('Year','Predicted','Simulated')], id.vars = 1)
  plot_population_growth  <- ggplot2::ggplot(dfm, aes(x = Year, y = value)) +  theme_tufte(base_size=14, ticks=F) +
    geom_bar(aes(fill = variable), stat = "identity", position = "dodge") +
    labs(title = "Population Growth Curve") + ylab ("Population") +
    labs(caption = "(based on population at age 40 and above)") +
    theme(legend.title=element_blank()) +
    scale_y_continuous(name="Population", labels = scales::comma)

  plot (plot_population_growth)
  if (savePlots) ggsave(paste0("PopulationGrowth",".tiff"), plot = last_plot(), device = "tiff", dpi = 300)


  pyramid <- matrix(NA, nrow = input$global_parameters$time_horizon, ncol = length(Cget_output_ex()$n_alive_by_ctime_age[1, ]) -
                      input$global_parameters$age0)

  for (year in 0:model_input$values$global_parameters$time_horizon - 1) pyramid[1 + year, ] <- Cget_output_ex()$n_alive_by_ctime_age[year +1, -(1:input$global_parameters$age0)]


  message("Also, the ratio of the expected to observed population in years 10 and 20 are ", sum(Cget_output_ex()$n_alive_by_ctime_sex[10,
                                                                                                                                  ])/x[10, 2], " and ", sum(Cget_output_ex()$n_alive_by_ctime_sex[20, ])/x[20, 2])
  petoc()

  message("Now evaluating the population pyramid\n")
  for (year in c(2015, 2025, 2034)) {
    message("The observed population pyramid in", year, "is just drawn\n")
    x <- CanSim.052.0005[which(CanSim.052.0005[, "year"] == year & CanSim.052.0005[, "sex"] == "both"), "value"]
    #x <- c(x, rep(0, 111 - length(x) - 40))
    #barplot(x,  names.arg=40:110, xlab = "Age")
    #title(cex.main = 0.5, paste("Predicted Pyramid - ", year))
    dfPredicted <- data.frame (population = x * 1000, age = 40:100)


    # message("Predicted average age of those >40 y/o is", sum((input$global_parameters$age0:(input$global_parameters$age0 + length(x) -
    #                                                                                       1)) * x)/sum(x), "\n")
    # petoc()
    #
    # message("Simulated average age of those >40 y/o is", sum((input$global_parameters$age0:(input$global_parameters$age0 + length(x) -
    #                                                                                       1)) * x)/sum(x), "\n")
    # petoc()

    dfSimulated <- data.frame (population = pyramid[year - 2015 + 1, ], age = 40:110)
    dfSimulated$population <- dfSimulated$population * (-1) / settings$n_base_agents * 18179400 #rescaling population. There are 18179400 Canadians above 40

    p <- ggplot (NULL, aes(x = age, y = population)) + theme_tufte(base_size=14, ticks=F) +
         geom_bar (aes(fill = "Simulated"), data = dfSimulated, stat="identity", alpha = 0.5) +
         geom_bar (aes(fill = "Predicted"), data = dfPredicted, stat="identity", alpha = 0.5) +
         theme(axis.title=element_blank()) +
         ggtitle(paste0("Simulated vs. Predicted Population Pyramid in ", year)) +
         theme(legend.title=element_blank()) +
         scale_y_continuous(name="Population", labels = scales::comma) +
         scale_x_continuous(name="Age", labels = scales::comma)
    if (savePlots) ggsave(paste0("Population ", year,".tiff"), plot = last_plot(), device = "tiff", dpi = 300)

    plot(p)

  }
  terminate_session()
}





#' Returns results of validation tests for smoking module.
#' @param intercept_k a number
#' @param remove_COPD 0 or 1. whether to remove COPD-related mortality.
#' @return validation test results
#' @export
validate_smoking <- function(remove_COPD = 1, intercept_k = NULL) {
  message("Welcome to EPIC validator! Today we will see if the model make good smoking predictions")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- 1e+05
  settings$event_stack_size <- settings$n_base_agents * 1.7 * 30

  init_session(settings = settings)
  input <- model_input$values

  message("\nBecause you have called me with remove_COPD=", remove_COPD, ", I am", c("NOT", "indeed")[remove_COPD + 1], "going to remove COPD-related mortality from my calculations")
  if (remove_COPD) {
    input$exacerbation$logit_p_death_by_sex <- input$exacerbation$logit_p_death_by_sex * -10000 # TODO why was this zero? Amin
  }

  if (!is.null(intercept_k))
    input$manual$smoking$intercept_k <- intercept_k

  petoc()

  message("There are two validation targets: 1) the prevalence of current smokers (by sex) in 2015, and 2) the projected decline in smoking rate.\n")
  message("Starting validation target 1: baseline prevalence of smokers.\n")
  petoc()

  # CanSim.105.0501<-read.csv(paste(data_path,'/CanSim.105.0501.csv',sep=''),header=T) Included in the package as internal data
  tab1 <- rbind(CanSim.105.0501[1:3, "value"], CanSim.105.0501[4:6, "value"])/100
  message("This is the observed percentage of current smokers in 2014 (m,f)\n")
  barplot(tab1, beside = T, names.arg = c("40", "52", "65+"), ylim = c(0, 0.4), xlab = "Age group", ylab = "Prevalenc of smoking",
          col = c("black", "grey"))
  title(cex.main = 0.5, "Prevalence of current smoker by sex and age group (observed)")
  legend("topright", c("Male", "Female"), fill = c("black", "grey"))
  petoc()

  message("Now I will run the model using the default smoking parameters")
  petoc()
  message("running the model\n")

  run(input = input)
  dataS <- Cget_all_events_matrix()
  dataS <- dataS[which(dataS[, "event"] == events["event_start"]), ]
  age_list <- list(a1 = c(35, 45), a2 = c(45, 65), a3 = c(65, 111))
  tab2 <- tab1
  for (i in 0:1) for (j in 1:length(age_list)) tab2[i + 1, j] <- mean(dataS[which(dataS[, "female"] == i & dataS[, "age_at_creation"] >
                                                                                    age_list[[j]][1] & dataS[, "age_at_creation"] <= age_list[[j]][2]), "smoking_status"])

  message("This is the model generated bar plot")
  petoc()
  barplot(tab2, beside = T, names.arg = c("40", "52", "65+"), ylim = c(0, 0.4), xlab = "Age group", ylab = "Prevalence of smoking",
          col = c("black", "grey"))
  title(cex.main = 0.5, "Prevalence of current smoking at creation (simulated)")
  legend("topright", c("Male", "Female"), fill = c("black", "grey"))

  message("This step is over; press enter to continue to step 2")
  petoc()

  message("Now we will validate the model on smoking trends")
  petoc()

  message("According to Table 2.1 of this report (see the extracted data in data folder): http://www.tobaccoreport.ca/2015/TobaccoUseinCanada_2015.pdf, the prevalence of current smoker is declining by around 3.8% per year\n")
  petoc()

  op_ex <- Cget_output_ex()
  smoker_prev <- op_ex$n_current_smoker_by_ctime_sex/op_ex$n_alive_by_ctime_sex
  smoker_packyears <- op_ex$sum_pack_years_by_ctime_sex/op_ex$n_alive_by_ctime_sex

  plot(2015:(2015+input$global_parameters$time_horizon-1), smoker_prev[, 1], type = "l", ylim = c(0, 0.25), col = "black", xlab = "Year", ylab = "Prevalence of current smoking")
  lines(2015:(2015+input$global_parameters$time_horizon-1), smoker_prev[, 2], type = "l", col = "grey")
  legend("topright", c("male", "female"), lty = c(1, 1), col = c("black", "grey"))
  title(cex.main = 0.5, "Annual prevalence of currrent smoking (simulated)")

  plot(2015:(2015+input$global_parameters$time_horizon-1), smoker_packyears[, 1], type = "l", ylim = c(0, 30), col = "black", xlab = "Year", ylab = "Average Pack years")
  lines(2015:(2015+input$global_parameters$time_horizon-1), smoker_packyears[, 2], type = "l", col = "grey")
  legend("topright", c("male", "female"), lty = c(1, 1), col = c("black", "grey"))
  title(cex.main = 0.5, "Average Pack-Years Per Year for 40+ Population (simulated)")


  z <- log(rowSums(smoker_prev))
  message("average decline in % of current_smoking rate is", 1 - exp(mean(c(z[-1], NaN) - z, na.rm = T)))
  petoc()

  #plotting overall distribution of smoking stats over time
  smoking_status_ctime <- matrix (NA, nrow = input$global_parameters$time_horizon, ncol = 4)
  colnames(smoking_status_ctime) <- c("Year", "Non-Smoker", "Smoker", "Former smoker")
  smoking_status_ctime[1:(input$global_parameters$time_horizon), 1] <- c(2015:(2015 + input$global_parameters$time_horizon-1))
  smoking_status_ctime [, 2:4] <- op_ex$n_smoking_status_by_ctime / rowSums(as.data.frame (op_ex$n_alive_by_ctime_sex)) * 100
  df <- as.data.frame(smoking_status_ctime)
  dfm <- reshape2::melt(df[,c("Year", "Non-Smoker", "Smoker", "Former smoker")], id.vars = 1)
  plot_smoking_status_ctime  <- ggplot2::ggplot(dfm, aes(x = Year, y = value, color = variable)) +
    geom_point () + geom_line() + labs(title = "Smoking Status per year") + ylab ("%") +
    scale_colour_manual(values = c("#66CC99", "#CC6666", "#56B4E9")) + scale_y_continuous(breaks = scales::pretty_breaks(n = 12))



  plot(plot_smoking_status_ctime ) #plot needs to be showing

  # Plotting pack-years over time
  dataS <- as.data.frame (Cget_all_events_matrix())
  dataS <- subset (dataS, (event == 0 | event == 1 ))
  data_all <- dataS
  dataS <- subset (dataS, pack_years != 0)
  avg_pack_years_ctime <- matrix (NA, nrow = input$global_parameters$time_horizon + 1, ncol = 4)
  colnames(avg_pack_years_ctime) <- c("Year", "Smokers PYs", "Former Smokers PYs", "all")

  avg_pack_years_ctime[1:(input$global_parameters$time_horizon + 1), 1] <- c(2015:(2015 + input$global_parameters$time_horizon))

  for (i in 0:input$global_parameters$time_horizon) {
    smokers <- subset (dataS, (floor(local_time + time_at_creation) == (i)) & smoking_status != 0)
    prev_smokers <- subset (dataS, (floor(local_time + time_at_creation) == (i)) & smoking_status == 0)
    all <- subset (data_all, floor(local_time + time_at_creation) == i)
    avg_pack_years_ctime[i+1, "Smokers PYs"] <- colSums(smokers)[["pack_years"]] / dim (smokers)[1]
    avg_pack_years_ctime[i+1, "Former Smokers PYs"] <- colSums(prev_smokers)[["pack_years"]] / dim (prev_smokers) [1]
    avg_pack_years_ctime[i+1, "all"] <- colSums(all)[["pack_years"]] / dim (all) [1] #includes non-smokers

  }

  df <- as.data.frame(avg_pack_years_ctime)
  dfm <- reshape2::melt(df[,c( "Year", "Smokers PYs", "Former Smokers PYs", "all")], id.vars = 1)
  plot_avg_pack_years_ctime <- ggplot2::ggplot(dfm, aes(x = Year, y = value, color = variable)) +
    geom_point () + geom_line() + labs(title = "Average pack-years per year ") + ylab ("Pack-years")

  plot(plot_avg_pack_years_ctime) #plot needs to be showing

  # Plotting pack-years over age

  avg_pack_years_age <- matrix (NA, nrow = 110 - 40 + 1, ncol = 3)
  colnames(avg_pack_years_age) <- c("Age", "Smokers PYs", "Former Smokers PYs")

  avg_pack_years_age[1:(110 - 40 + 1), 1] <- c(40:110)

  for (i in 0:(110 - 40)) {
    smokers <- subset (dataS, (floor (local_time + age_at_creation) == (i+40)) & smoking_status != 0)
    prev_smokers <- subset (dataS, (floor (local_time + age_at_creation) == (i+40)) & smoking_status == 0)
    avg_pack_years_age[i+1, "Smokers PYs"] <- colSums(smokers)[["pack_years"]] / dim (smokers)[1]
    avg_pack_years_age[i+1, "Former Smokers PYs"] <- colSums(prev_smokers)[["pack_years"]] / dim (prev_smokers) [1]
  }

  df <- as.data.frame(avg_pack_years_age)
  dfm <- reshape2::melt(df[,c( "Age", "Smokers PYs", "Former Smokers PYs")], id.vars = 1)
  plot_avg_pack_years_age <- ggplot2::ggplot(dfm, aes(x = Age, y = value, color = variable, ymin = 40, ymax = 100)) +
    geom_point () + geom_line() + labs(title = "Average pack-years per age ") + ylab ("Pack-years")

  plot(plot_avg_pack_years_age) #plot needs to be showing


  message("This test is over; terminating the session")
  petoc()
  terminate_session()
}




#' Basic COPD test.
#' @return validation test results
#' @export
sanity_COPD <- function() {
  settings <- default_settings

  settings$record_mode <- session_env$record_mode["record_mode_agent"]
  # settings$agent_stack_size<-0
  # settings$n_base_agents <- 10000
  # settings$event_stack_size <- settings$n_base_agents * 10

  init_session(settings = settings)

  message("Welcome! I am going to check EPIC's sanity with regard to modeling COPD\n ")
  petoc()

  message("COPD incidence and prevalence parameters are as follows\n")

  message("model_input$values$COPD$logit_p_COPD_betas_by_sex:\n")
  print(model_input$values$COPD$logit_p_COPD_betas_by_sex)
  petoc()
  message("model_input$values$COPD$p_prevalent_COPD_stage:\n")
  print(model_input$values$COPD$p_prevalent_COPD_stage)
  petoc()
  message("model_input$values$COPD$ln_h_COPD_betas_by_sex:\n")
  print(model_input$values$COPD$ln_h_COPD_betas_by_sex)
  petoc()

  message("Now I am going to first turn off both prevalence and incidence parameters and run the model to see how many COPDs I get\n")
  petoc()
  input <- model_input$values
  input$COPD$logit_p_COPD_betas_by_sex <- input$COPD$logit_p_COPD_betas_by_sex * 0 - 100
  input$COPD$ln_h_COPD_betas_by_sex <- input$COPD$ln_h_COPD_betas_by_sex * 0 - 100
  run(input = input)
  message("The model is reporting it has got that many COPDs: ", Cget_output()$n_COPD, " out of ", Cget_output()$n_agents, " agents.\n")
  dataS <- get_events_by_type(events["event_start"])
  message("The prevalence of COPD in Start event dump is:", mean(dataS[, "gold"] > 0), "\n")
  dataS <- get_events_by_type(events["event_end"])
  message("The prevalence of COPD in End event dump is:", mean(dataS[, "gold"] > 0), "\n")
  petoc()

  message("Now I am going to switch off incidence and create COPD patients only through prevalence (set at 0.5)")
  petoc()
  get_input()
  input <- model_input$values
  input$COPD$logit_p_COPD_betas_by_sex <- input$COPD$logit_p_COPD_betas_by_sex * 0
  input$COPD$ln_h_COPD_betas_by_sex <- input$COPD$ln_h_COPD_betas_by_sex * 0 - 100
  run(input = input)
  message("The model is reporting it has got that many COPDs:", Cget_output()$n_COPD, " out of ", Cget_output()$n_agents, "agents.\n")
  dataS <- get_events_by_type(events["event_start"])
  message("The prevalence of COPD in Start event dump is:", mean(dataS[, "gold"] > 0), "\n")
  dataS <- get_events_by_type(events["event_end"])
  message("The prevalence of COPD in End event dump is:", mean(dataS[, "gold"] > 0), "\n")
  petoc()

  message("Now I am going to switch off prevalence and create COPD patients only through incidence\n")
  petoc()
  get_input()
  input <- model_input$values
  input$COPD$logit_p_COPD_betas_by_sex <- input$COPD$logit_p_COPD_betas_by_sex * 0 - 100

  run(input = input)
  message("The model is reporting it has got that many COPDs:", Cget_output()$n_COPD, " out of ", Cget_output()$n_agents, "agents.\n")
  dataS <- get_events_by_type(events["event_start"])
  message("The prevalence of COPD in Start event dump is:", mean(dataS[, "gold"] > 0), "\n")
  dataS <- get_events_by_type(events["event_end"])
  message("The prevalence of COPD in End event dump is:", mean(dataS[, "gold"] > 0), "\n")
  petoc()


  terminate_session()
}



#' Returns results of validation tests for COPD
#' @param incident_COPD_k a number (default=1) by which the incidence rate of COPD will be multiplied.
#' @param return_CI if TRUE, returns 95 percent confidence intervals for the "Year" coefficient
#' @return validation test results
#' @export
validate_COPD <- function(incident_COPD_k = 1, return_CI = FALSE) # The incidence rate is multiplied by K
{
  out <- list()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- 1e+05
  settings$event_stack_size <- settings$n_base_agents * 50
  init_session(settings = settings)
  input <- model_input$values

  if (incident_COPD_k == 0)
    input$COPD$ln_h_COPD_betas_by_sex <- input$COPD$ln_h_COPD_betas_by_sex * 0 - 100 else input$COPD$ln_h_COPD_betas_by_sex[1, ] <- model_input$values$COPD$ln_h_COPD_betas_by_sex[1, ] + log(incident_COPD_k)

  message("working...\n")
  run(input = input)
  op <- Cget_output()
  opx <- Cget_output_ex()
  data <- as.data.frame(Cget_all_events_matrix())
  dataS <- data[which(data[, "event"] == events["event_start"]), ]
  dataE <- data[which(data[, "event"] == events["event_end"]), ]

  out$p_copd_at_creation <- mean(dataS[, "gold"] > 0)

  new_COPDs <- which(dataS[which(dataE[, "gold"] > 0), "gold"] == 0)

  out$inc_copd <- sum(opx$n_inc_COPD_by_ctime_age)/opx$cumul_non_COPD_time
  out$inc_copd_by_sex <- sum(opx$n_inc_COPD_by_ctime_age)/opx$cumul_non_COPD_time

  x <- sqldf::sqldf("SELECT female, SUM(gold>0) AS n_copd, COUNT(*) AS n FROM dataS GROUP BY female")
  out$p_copd_at_creation_by_sex <- x[, "n_copd"]/x[, "n"]



  age_cats <- c(40, 50, 60, 70, 80, 111)
  dataS[, "age_cat"] <- as.numeric(cut(dataS[, "age_at_creation"] + dataS[, "local_time"], age_cats, include.lowest = TRUE))
  x <- sqldf::sqldf("SELECT age_cat, SUM(gold>0) AS n_copd, COUNT(*) AS n FROM dataS GROUP BY age_cat")
  temp <- x[, "n_copd"]/x[, "n"]
  names(temp) <- paste(age_cats[-length(age_cats)], age_cats[-1], sep = "-")
  out$p_copd_at_creation_by_age <- temp


  py_cats <- c(0, 15, 30, 45, Inf)
  dataS[, "py_cat"] <- as.numeric(cut(dataS[, "pack_years"], py_cats, include.lowest = TRUE))
  x <- sqldf::sqldf("SELECT py_cat, SUM(gold>0) AS n_copd, COUNT(*) AS n FROM dataS GROUP BY py_cat")
  temp <- x[, "n_copd"]/x[, "n"]
  names(temp) <- paste(py_cats[-length(py_cats)], py_cats[-1], sep = "-")
  out$p_copd_at_creation_by_pack_years <- temp


  dataF <- data[which(data[, "event"] == events["event_fixed"]), ]
  dataF[, "age"] <- dataF[, "local_time"] + dataF[, "age_at_creation"]
  dataF[, "copd"] <- (dataF[, "gold"] > 0) * 1
  dataF[, "gold2p"] <- (dataF[, "gold"] > 1) * 1
  dataF[, "gold3p"] <- (dataF[, "gold"] > 2) * 1
  dataF[, "year"] <- dataF[, "local_time"] + dataF[, "time_at_creation"]

    res <- glm(data = dataF[which(dataF[, "female"] == 0), ], formula = copd ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
    out$calib_prev_copd_reg_coeffs_male <- coefficients(res)
    if (return_CI) {out$conf_prev_copd_reg_coeffs_male <- stats::confint(res, "year", level = 0.95)}

    res <- glm(data = dataF[which(dataF[, "female"] == 1), ], formula = copd ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
    out$calib_prev_copd_reg_coeffs_female <- coefficients(res)
    if (return_CI) {out$conf_prev_copd_reg_coeffs_female <- stats::confint(res, "year", level = 0.95)}

    res <- glm(data = dataF[which(dataF[, "female"] == 0), ], formula = gold2p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
    out$calib_prev_gold2p_reg_coeffs_male <- coefficients(res)
    if (return_CI) {out$conf_prev_gold2p_reg_coeffs_male <- stats::confint(res, "year", level = 0.95)}

    res <- glm(data = dataF[which(dataF[, "female"] == 1), ], formula = gold2p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
    out$calib_prev_gold2p_reg_coeffs_female <- coefficients(res)
    if (return_CI) {out$conf_prev_gold2p_reg_coeffs_female <- stats::confint(res, "year", level = 0.95)}

    res <- glm(data = dataF[which(dataF[, "female"] == 0), ], formula = gold3p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
    out$calib_prev_gold3p_reg_coeffs_male <- coefficients(res)
    if (return_CI) {out$conf_prev_gold3p_reg_coeffs_male <- stats::confint(res, "year", level = 0.95)}

    res <- glm(data = dataF[which(dataF[, "female"] == 1), ], formula = gold3p ~ age + pack_years + smoking_status + year, family = binomial(link = logit))
    out$calib_prev_gold3p_reg_coeffs_female <- coefficients(res)
    if (return_CI) {out$conf_prev_gold3p_reg_coeffs_female <- stats::confint(res, "year", level = 0.95)}


  terminate_session()

  return(out)
}




#' Returns results of validation tests for payoffs, costs and QALYs
#' @param nPatient number of simulated patients. Default is 1e6.
#' @param disableDiscounting if TRUE, discounting will be disabled for cost and QALY calculations. Default: TRUE
#' @param disableExacMortality if TRUE, mortality due to exacerbations will be disabled for cost and QALY calculations. Default: TRUE
#' @return validation test results
#' @export
validate_payoffs <- function(nPatient = 1e6, disableDiscounting = TRUE, disableExacMortality = TRUE)
{
  out <- list()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- nPatient
  settings$event_stack_size <- 0
  init_session(settings = settings)
  input <- model_input$values

  if (disableDiscounting)  {
    input$global_parameters$discount_cost <- 0
    input$global_parameters$discount_qaly <- 0
  }

  if (disableExacMortality) {
    input$exacerbation$logit_p_death_by_sex <- -1000 + 0*input$exacerbation$logit_p_death_by_sex
  }

  run(input = input)
  op <- Cget_output()
  op_ex <- Cget_output_ex()

  exac_dutil<-Cget_inputs()$utility$exac_dutil
  exac_dcost<-Cget_inputs()$cost$exac_dcost


  total_qaly<-colSums(op_ex$cumul_qaly_gold_ctime)[2:5]
  qaly_loss_dueto_exac_by_gold<-rowSums(op_ex$n_exac_by_gold_severity*exac_dutil)
  back_calculated_utilities<-(total_qaly-qaly_loss_dueto_exac_by_gold)/colSums(op_ex$cumul_time_by_ctime_GOLD)[2:5]
  #I=0.81,II=0.72,III=0.68,IV=0.58)))

  out$cumul_time_per_GOLD <- colSums(op_ex$cumul_time_by_ctime_GOLD)[2:5]
  out$total_qaly <- total_qaly
  out$qaly_loss_dueto_exac_by_gold <-  qaly_loss_dueto_exac_by_gold
  out$back_calculated_utilities <- back_calculated_utilities
  out$utility_target_values <- input$utility$bg_util_by_stage
  out$utility_difference_percentage <- (out$back_calculated_utilities - out$utility_target_values[2:5]) / out$utility_target_values[2:5] * 100

  total_cost<-colSums(op_ex$cumul_cost_gold_ctime)[2:5]
  cost_dueto_exac_by_gold<-rowSums(t((exac_dcost)*t(op_ex$n_exac_by_gold_severity)))
  back_calculated_costs<-(total_cost-cost_dueto_exac_by_gold)/colSums(op_ex$cumul_time_by_ctime_GOLD)[2:5]
  #I=615, II=1831, III=2619, IV=3021

  out$total_cost <- total_cost
  out$cost_dueto_exac_by_gold <- cost_dueto_exac_by_gold
  out$back_calculated_costs <- back_calculated_costs
  out$cost_target_values <- input$cost$bg_cost_by_stage
  out$cost_difference_percentage <- (out$back_calculated_costs - out$cost_target_values[2:5]) / out$cost_target_values[2:5] * 100

  terminate_session()

  return(out)
}



#' Returns results of validation tests for mortality rate
#' @param n_sim number of simulated agents
#' @param bgd a number
#' @param bgd_h a number
#' @param manual a number
#' @param exacerbation a number
#' @param comorbidity a number
#' @return validation test results
#' @export
validate_mortality <- function(n_sim = 5e+05, bgd = 1, bgd_h = 1, manual = 1, exacerbation = 1, comorbidity = 1) {
  message("Hello from EPIC! I am going to test mortality rate and how it is affected by input parameters\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  input$global_parameters$time_horizon <- 1

  input$agent$p_bgd_by_sex <- input$agent$p_bgd_by_sex * bgd

  input$agent$ln_h_bgd_betas <- input$agent$ln_h_bgd_betas * bgd_h

  input$manual$explicit_mortality_by_age_sex <- input$manual$explicit_mortality_by_age_sex * manual

  input$exacerbation$logit_p_death_by_sex <- input$exacerbation$logit_p_death_by_sex * exacerbation

  if (comorbidity == 0) {
    input$comorbidity$p_mi_death <- 0
    input$comorbidity$p_stroke_death <- 0
    input$agent$ln_h_bgd_betas[, c("b_mi", "n_mi", "b_stroke", "n_stroke", "hf")] <- 0
  }

  message("working...\n")
  res <- run(input = input)

  message("Mortality rate was", Cget_output()$n_death/Cget_output()$cumul_time, "\n")


  if (Cget_output()$n_death > 0) {

    ratio<-(Cget_output_ex()$n_death_by_age_sex[41:111,]/Cget_output_ex()$sum_time_by_age_sex[41:111,])/model_input$values$agent$p_bgd_by_sex[41:111,]
    plot(40:110,ratio[,1],type='l',col='blue',xlab="age",ylab="Ratio", ylim = c(0, 4))
    legend("topright",c("male","female"),lty=c(1,1),col=c("blue","red"))
    lines(40:110,ratio[,2],type='l',col='red')
    title(cex.main=0.5,"Ratio of simulated to expected (life table) mortality, by sex and age")


    difference <- (Cget_output_ex()$n_death_by_age_sex[41:91, ]/Cget_output_ex()$sum_time_by_age_sex[41:91, ]) - model_input$values$agent$p_bgd_by_sex[41:91,
                                                                                                                                                       ]
    plot(40:90, difference[, 1], type = "l", col = "blue", xlab = "age", ylab = "Difference", ylim = c(-.1, .1))
    legend("topright", c("male", "female"), lty = c(1, 1), col = c("blue", "red"))
    lines(40:90, difference[, 2], type = "l", col = "red")
    title(cex.main = 0.5, "Difference between simulated and expected (life table) mortality, by sex and age")

    return(list(difference = difference))
  } else message("No death occured.\n")
}





#' Returns results of validation tests for comorbidities
#' @param n_sim number of agents
#' @return validation test results
#' @export
validate_comorbidity <- function(n_sim = 1e+05) {
  message("Hello from EPIC! I am going to validate comorbidities for ya\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  output <- Cget_output()
  output_ex <- Cget_output_ex()

  message("The prevalence of having MI at baseline was ", (output_ex$n_mi - output_ex$n_incident_mi)/output$n_agent, "\n")
  message("The incidence of MI during follow-up was ", output_ex$n_incident_mi/output$cumul_time, "/PY\n")
  message("The prevalence of having stroke at baseline was ", (output_ex$n_stroke - output_ex$n_incident_stroke)/output$n_agent, "\n")
  message("The incidence of stroke during follow-up was ", output_ex$n_incident_stroke/output$cumul_time, "/PY\n")
  message("The prevalence of having hf at baseline was ", (output_ex$n_stroke - output_ex$n_hf)/output$n_agent, "\n")
  message("The incidence of hf during follow-up was ", output_ex$n_incident_hf/output$cumul_time, "/PY\n")
  terminate_session()

  settings$record_mode <- record_mode["record_mode_some_event"]
  settings$events_to_record <- events[c("event_start", "event_mi", "event_stroke", "event_hf", "event_end")]
  settings$n_base_agents <- 1e+05
  settings$event_stack_size <- settings$n_base_agents * 1.6 * 10
  init_session(settings = settings)

  input <- model_input$values

  if (run(input = input) < 0)
    stop("Execution stopped.\n")
  output <- Cget_output()
  output_ex <- Cget_output_ex()

  # mi_events<-get_events_by_type(events['event_mi']) stroke_events<-get_events_by_type(events['event_stroke'])
  # hf_events<-get_events_by_type(events['event_hf']) end_events<-get_events_by_type(events['event_end'])

  plot(output_ex$n_mi_by_age_sex[41:100, 1]/output_ex$n_alive_by_age_sex[41:100, 1], type = "l", col = "red")
  lines(output_ex$n_mi_by_age_sex[41:100, 2]/output_ex$n_alive_by_age_sex[41:100, 2], type = "l", col = "blue")
  title(cex.main = 0.5, "Incidence of MI by age and sex")

  plot(output_ex$n_stroke_by_age_sex[, 1]/output_ex$n_alive_by_age_sex[, 1], type = "l", col = "red")
  lines(output_ex$n_stroke_by_age_sex[, 2]/output_ex$n_alive_by_age_sex[, 2], type = "l", col = "blue")
  title(cex.main = 0.5, "Incidence of Stroke by age and sex")

  plot(output_ex$n_hf_by_age_sex[, 1]/output_ex$n_alive_by_age_sex[, 1], type = "l", col = "red")
  lines(output_ex$n_hf_by_age_sex[, 2]/output_ex$n_alive_by_age_sex[, 2], type = "l", col = "blue")
  title(cex.main = 0.5, "Incidence of HF by age and sex")

  output_ex$n_mi_by_age_sex[41:111, ]/output_ex$n_alive_by_age_sex[41:111, ]
}



#' Returns results of validation tests for lung function
#' @return validation test results
#' @export
validate_lung_function <- function() {
  message("This function examines FEV1 values\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_some_event"]
  settings$events_to_record <- events[c("event_start", "event_COPD", "event_fixed")]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- 1e+05
  settings$event_stack_size <- settings$n_base_agents * 100

  init_session(settings = settings)

  input <- model_input$values
  input$global_parameters$discount_qaly <- 0

  run(input = input)

  all_events <- as.data.frame(Cget_all_events_matrix())

  COPD_events <- which(all_events[, "event"] == events["event_COPD"])
  start_events <- which(all_events[, "event"] == events["event_start"])

  out_FEV1_prev <- sqldf::sqldf(paste("SELECT gold, AVG(FEV1) AS 'Mean', STDEV(FEV1) AS 'SD' FROM all_events WHERE event=", events["event_start"],
                                      " GROUP BY gold"))
  out_FEV1_inc <- sqldf::sqldf(paste("SELECT gold, AVG(FEV1) AS 'Mean', STDEV(FEV1) AS 'SD' FROM all_events WHERE event=", events["event_COPD"],
                                     " GROUP BY gold"))

  out_gold_prev <- sqldf::sqldf(paste("SELECT gold, COUNT(*) AS N FROM all_events WHERE event=", events["event_start"], " GROUP BY gold"))
  out_gold_prev[, "Percent"] <- round(out_gold_prev[, "N"]/sum(out_gold_prev[, "N"]), 3)
  out_gold_inc <- sqldf::sqldf(paste("SELECT gold, COUNT(*) AS N FROM all_events WHERE event=", events["event_COPD"], " GROUP BY gold"))
  out_gold_inc[, "Percent"] <- round(out_gold_inc[, "N"]/sum(out_gold_inc[, "N"]), 3)

  COPD_events_patients <- subset(all_events, event == 4)
  start_events_patients <- subset(all_events, event == 0 & gold > 0)

  table(COPD_events_patients[, "gold"])/sum(table(COPD_events_patients[, "gold"]))

  table(start_events_patients[, "gold"])/sum(table(start_events_patients[, "gold"]))


  out_gold_inc_patients <- table(COPD_events_patients[, "gold"])/sum(table(COPD_events_patients[, "gold"]))

  out_gold_prev_patients <- table(start_events_patients[, "gold"])/sum(table(start_events_patients[, "gold"]))

  COPD_ids <- all_events[COPD_events, "id"]

  for (i in 1:100) {
    y <- which(all_events[, "id"] == COPD_ids[i] & all_events[, "gold"] > 0)
    if (i == 1)
      plot(all_events[y, "local_time"], all_events[y, "FEV1"], type = "l", xlim = c(0, 20), ylim = c(0, 5), xlab = "local time",
           ylab = "FEV1") else lines(all_events[y, "local_time"], all_events[y, "FEV1"], type = "l")
  }
  title(cex.main = 0.5, "Trajectories of FEV1 in 100 individuals")

  return(list(FEV1_prev = out_FEV1_prev, FEV1_inc = out_FEV1_inc, gold_prev = out_gold_prev, gold_inc = out_gold_inc, gold_prev_patients = out_gold_prev_patients,
              gold_inc_patients = out_gold_inc_patients))
}



#' Returns results of validation tests for exacerbation rates
#' @param base_agents Number of agents in the simulation. Default is 1e4.
#' @return validation test results
#' @export
validate_exacerbation <- function(base_agents=1e4) {

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  #settings$agent_stack_size <- 0
  settings$n_base_agents <- base_agents
  #settings$event_stack_size <- 1
  init_session(settings = settings)
  input <- model_input$values  #We can work with local copy more conveniently and submit it to the Run function

  run(input = input)
  op <- Cget_output()
  all_events <- as.data.frame(Cget_all_events_matrix())
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

  GOLD_I <- (as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1])

  GOLD_II <- (as.data.frame(table(exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2])

  GOLD_III <- (as.data.frame(table(exac_events[, "gold"]))[3, 2]/Follow_up_Gold[3])

  GOLD_IV<- (as.data.frame(table(exac_events[, "gold"]))[4, 2]/Follow_up_Gold[4])

  return(list(exacRateGOLDI = GOLD_I, exacRateGOLDII = GOLD_II, exacRateGOLDIII = GOLD_III, exacRateGOLDIV = GOLD_IV))
}


#' Returns the Kaplan Meier curve comparing COPD and non-COPD
#' @param savePlots TRUE or FALSE (default), exports 300 DPI population growth and pyramid plots comparing simulated vs. predicted population
#' @param base_agents Number of agents in the simulation. Default is 1e4.
#' @return validation test results
#' @export
validate_survival <- function(savePlots = FALSE, base_agents=1e4) {

  if (!requireNamespace("survival", quietly = TRUE)) {
    stop("Package \"survival\" needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("survminer", quietly = TRUE)) {
    stop("Package \"survminer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }


  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  #settings$agent_stack_size <- 0
  settings$n_base_agents <- base_agents
  #settings$event_stack_size <- 1
  init_session(settings = settings)
  input <- model_input$values  #We can work with local copy more conveniently and submit it to the Run function

  run(input = input)
  events <- as.data.frame(Cget_all_events_matrix())
  terminate_session()

  cohort <- subset(events, ((event==7) | (event==13) | (event==14)))

  cohort <- cohort %>% filter((id==lead(id) | ((event == 14) & id!=lag(id))))

  cohort$copd <- (cohort$gold>0)
  cohort$death <- (cohort$event!=14)
  cohort$age <- (cohort$age_at_creation+cohort$local_time)

  #fit <- survfit(Surv(age, death) ~ copd, data=cohort)
  fit <- survival::survfit(Surv(age, death) ~ copd, data=cohort)

  # Customized survival curves
  surv_plot <- survminer::ggsurvplot(fit, data = cohort, censor.shape="", censor.size = 1,
                          surv.median.line = "hv", # Add medians survival

                          # Change legends: title & labels
                          legend.title = "Disease Status",
                          legend.labs = c("Non-COPD", "COPD"),
                          # Add p-value and tervals
                          pval = TRUE,

                          conf.int = TRUE,
                          xlim = c(40,110),         # present narrower X axis, but not affect
                          # survival estimates.
                          xlab = "Age",   # customize X axis label.
                          break.time.by = 20,     # break X axis in time intervals by 500.
                          # Add risk table
                          #risk.table = TRUE,
                          tables.height = 0.2,
                          tables.theme = theme_cleantable(),

                          # Color palettes. Use custom color: c("#E7B800", "#2E9FDF"),
                          # or brewer color (e.g.: "Dark2"), or ggsci color (e.g.: "jco")
                          #palette = c("gray0", "gray1"),
                          ggtheme = theme_tufte() +
                            theme(axis.line = element_line(colour = "black"),
                                  panel.grid.major = element_blank(),
                                  panel.grid.minor = element_blank(),
                                  panel.border = element_blank(),
                                  panel.background = element_blank())  # Change ggplot2 theme
  )

  plot (surv_plot)

  if (savePlots) ggsave((paste0("survival-diagnosed", ".tiff")), plot = plot(surv_plot), device = "tiff", dpi = 300)

  fitcox <- coxph(Surv(age, death) ~ copd, data = cohort)
  ftest <- cox.zph(fitcox)
  print(summary(fitcox))

  return(surv_plot)
}


#' Returns results of validation tests for diagnosis
#' @param n_sim number of agents
#' @return validation test results
#' @export
validate_diagnosis <- function(n_sim = 1e+04) {
  message("Let's take a look at diagnosis\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  message("Here are the proportion of COPD patients diagnosed over model time: \n")

  diag <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     COPD=rowSums(output_ex$n_COPD_by_ctime_sex),
                     Diagnosed=rowSums(output_ex$n_Diagnosed_by_ctime_sex))

  diag$Proportion <- round(diag$Diagnosed/diag$COPD,2)

  print(diag)

  message("The average proportion diagnosed from year", round(length(diag$Proportion)/2,0), "to", length(diag$Proportion), "is",
      mean(diag$Proportion[(round(length(diag$Proportion)/2,0)):(length(diag$Proportion))]),"\n")

  diag.plot <- tidyr::gather(data=diag, key="Variable", value="Number", c(COPD,Diagnosed))

  diag.plotted <- ggplot2::ggplot(diag.plot, aes(x=Year, y=Number, col=Variable)) +
                  geom_line() + geom_point() + expand_limits(y = 0) +
                  theme_bw() + ylab("Number of COPD patients") + xlab("Years")

  plot(diag.plotted)

  message("\n")
  message("Now let's look at the proportion diagnosed by COPD severity.\n")

  prop <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     output_ex$n_Diagnosed_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)[,c(1,3,4,5,6)]

  names(prop) <- c("Year","GOLD1","GOLD2","GOLD3","GOLD4")
  prop <- prop[-1,]
  print(prop)

  message("The average proportion of GOLD 1 and 2 that are diagnosed from year", round(nrow(prop)/2,0), "to", max(prop$Year), "is",
      (mean(prop$GOLD1[round((nrow(prop)/2),0):nrow(prop)]) + mean(prop$GOLD2[round((nrow(prop)/2),0):nrow(prop)]))/2,"\n")

  prop.plot <- tidyr::gather(data=prop, key="GOLD", value="Proportion", c(GOLD1:GOLD4))

  prop.plotted <- ggplot2::ggplot(prop.plot, aes(x=Year, y=Proportion, col=GOLD)) +
                    geom_line() + geom_point() + expand_limits(y = 0) +
                    theme_bw() + ylab("Proportion diagnosed") + xlab("Years")

  plot(prop.plotted)

  terminate_session()
}

#' Returns results of validation tests for GP visits
#' @param n_sim number of agents
#' @return validation test results
#' @export
validate_gpvisits <- function(n_sim = 1e+04) {
  message("Let's take a look at GP visits\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  message("\n")
  message("Here is the Average number of GP visits by sex:\n")

  GPSex <- data.frame(1:inputs$global_parameters$time_horizon,
             output_ex$n_GPvisits_by_ctime_sex/output_ex$n_alive_by_ctime_sex)

  names(GPSex) <- c("Year","Male","Female")

  print(GPSex)

  GPSex.plot <- tidyr::gather(data=GPSex, key="Sex", value="Visits", c(Male,Female))

  GPSex.plot <- subset(GPSex.plot, Year!=1)

  GPSex.plotted <- ggplot2::ggplot(GPSex.plot, aes(x=Year, y=Visits, col=Sex)) +
                      geom_line() + geom_point() + expand_limits(y = 0) +
                      theme_bw() + ylab("Average GP visits/year") + xlab("Years")

  plot(GPSex.plotted)

  message("\n")

  message("Here is the Average number of GP visits by COPD severity:\n")

  GPCOPD <- data.frame(1:inputs$global_parameters$time_horizon,
                      output_ex$n_GPvisits_by_ctime_severity/output_ex$cumul_time_by_ctime_GOLD)

  names(GPCOPD) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  print(GPCOPD[-1,])


  GPCOPD.plot <- tidyr::gather(data=GPCOPD, key="COPD", value="Visits", c(NoCOPD:GOLD4))

  GPCOPD.plot <- subset(GPCOPD.plot, Year!=1)

  GPCOPD.plotted <- ggplot2::ggplot(GPCOPD.plot, aes(x=Year, y=Visits, col=COPD)) +
                        geom_line() + geom_point() + expand_limits(y = 0) +
                        theme_bw() + ylab("Average GP visits/year") + xlab("Years")

  plot(GPCOPD.plotted)

  message("\n")

  message("Here is the Average number of GP visits by COPD diagnosis status:\n")

  Diagnosed <- rowSums(output_ex$n_Diagnosed_by_ctime_sex)
  Undiagnosed <- rowSums(output_ex$cumul_time_by_ctime_GOLD[,2:5]) - Diagnosed
  data <- cbind(Undiagnosed, Diagnosed)

  GPDiag<- data.frame(Year=1:inputs$global_parameters$time_horizon,
                       output_ex$n_GPvisits_by_ctime_diagnosis/data)

  print(GPDiag[-1,])

  GPDiag.plot <- tidyr::gather(data=GPDiag, key="Diagnosis", value="Visits", c(Undiagnosed,Diagnosed))

  GPDiag.plot <- subset(GPDiag.plot, Year!=1)

  GPDiag.plotted <- ggplot2::ggplot(GPDiag.plot, aes(x=Year, y=Visits, col=Diagnosis)) +
                        geom_line() + geom_point() + expand_limits(y = 0) +
                        theme_bw() + ylab("Average GP visits/year") + xlab("Years")

  plot(GPDiag.plotted)

  message("\n")

  terminate_session()
}

#' Returns results of validation tests for Symptoms
#' @param n_sim number of agents
#' @return validation test results
#' @export
validate_symptoms <- function(n_sim = 1e+04) {
  message("Let's take a look at symptoms\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  # COUGH
  message("\n")
  message("I'm going to plot the prevalence of each symptom over time and by GOLD stage\n")
  message("\n")
  message("Cough:\n")
  message("\n")

  cough <- data.frame(1:inputs$global_parameters$time_horizon,
                      output_ex$n_cough_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(cough) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  print(cough)

  # plot
  cough.plot <- tidyr::gather(data=cough, key="GOLD", value="Prevalence", NoCOPD:GOLD4)
  cough.plot$Symptom <- "cough"

  cough.plotted <- ggplot2::ggplot(cough.plot, aes(x=Year, y=Prevalence, col=GOLD)) +
                      geom_smooth(method=lm, formula = y~x, level=0) + geom_point() + expand_limits(y = 0) +
                      theme_bw() + ylab("Proportion with cough") + xlab("Model Year")

  #plot(cough.plotted)

  message("\n")

  # PHLEGM
  message("Phlegm:\n")
  message("\n")

  phlegm <- data.frame(1:inputs$global_parameters$time_horizon,
                      output_ex$n_phlegm_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(phlegm) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  print(phlegm)

  # plot
  phlegm.plot <- tidyr::gather(data=phlegm, key="GOLD", value="Prevalence", NoCOPD:GOLD4)
  phlegm.plot$Symptom <- "phlegm"

  phlegm.plotted <- ggplot2::ggplot(phlegm.plot, aes(x=Year, y=Prevalence, col=GOLD)) +
    geom_smooth(method=lm, formula = y~x, level=0) + geom_point() + expand_limits(y = 0) +
    theme_bw() + ylab("Proportion with phlegm") + xlab("Model Year")

  #plot(phlegm.plotted)

  message("\n")

  # WHEEZE
  message("Wheeze:\n")
  message("\n")

  wheeze <- data.frame(1:inputs$global_parameters$time_horizon,
                       output_ex$n_wheeze_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(wheeze) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  print(wheeze)

  # plot
  wheeze.plot <- tidyr::gather(data=wheeze, key="GOLD", value="Prevalence", NoCOPD:GOLD4)
  wheeze.plot$Symptom <- "wheeze"

  wheeze.plotted <- ggplot2::ggplot(wheeze.plot, aes(x=Year, y=Prevalence, col=GOLD)) +
    geom_smooth(method=lm, formula = y~x, level=0) + geom_point() + expand_limits(y = 0) +
    theme_bw() + ylab("Proportion with wheeze") + xlab("Model Year")

  #plot(wheeze.plotted)

  message("\n")

  # DYSPNEA
  message("Dyspnea:\n")
  message("\n")

  dyspnea <- data.frame(1:inputs$global_parameters$time_horizon,
                       output_ex$n_dyspnea_by_ctime_severity/output_ex$n_COPD_by_ctime_severity)

  names(dyspnea) <- c("Year","NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  print(dyspnea)

  # plot
  dyspnea.plot <- tidyr::gather(data=dyspnea, key="GOLD", value="Prevalence", NoCOPD:GOLD4)
  dyspnea.plot$Symptom <- "dyspnea"

  dyspnea.plotted <- ggplot2::ggplot(dyspnea.plot, aes(x=Year, y=Prevalence, col=GOLD)) +
    geom_smooth(method=lm, formula = y~x, level=0) + geom_point() + expand_limits(y = 0) +
    theme_bw() + ylab("Proportion with dyspnea") + xlab("Model Year")

  #plot(dyspnea.plotted)

  message("\n")
  message("All symptoms plotted together:\n")

  all.plot <- rbind(cough.plot, phlegm.plot, wheeze.plot, dyspnea.plot)

  all.plotted <- ggplot2::ggplot(all.plot, aes(x=Year, y=Prevalence, col=GOLD)) +
    geom_smooth(method=lm, formula = y~x, level=0) + geom_point() + facet_wrap(~Symptom) +
    expand_limits(y = 0) +  theme_bw() + ylab("Proportion with symptom") + xlab("Model Year")

  plot(all.plotted)

  terminate_session()
}

#' Returns results of validation tests for Treatment
#' @param n_sim number of agents
#' @return validation test results
#' @export
validate_treatment<- function(n_sim = 1e+04) {
  message("Let's make sure that treatment (which is initiated at diagnosis) is affecting the exacerbation rate.\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  message("\n")
  message("Exacerbation rate for undiagnosed COPD patients.\n")
  message("\n")

  undiagnosed <- data.frame(cbind(1:inputs$global_parameters$time_horizon, output_ex$n_exac_by_ctime_severity_undiagnosed/
                                    (rowSums(output_ex$n_COPD_by_ctime_severity[,-1]) - rowSums(output_ex$n_Diagnosed_by_ctime_sex))))

  names(undiagnosed) <- c("Year","Mild","Moderate","Severe","VerySevere")
  print(undiagnosed)
  undiagnosed$Diagnosis <- "undiagnosed"

  message("\n")
  message("Exacerbation rate for diagnosed COPD patients.\n")
  message("\n")

  diagnosed <- data.frame(cbind(1:inputs$global_parameters$time_horizon,
                                output_ex$n_exac_by_ctime_severity_diagnosed/rowSums(output_ex$n_Diagnosed_by_ctime_sex)))

  diagnosed[1,2:5] <- c(0,0,0,0)
  names(diagnosed) <- c("Year","Mild","Moderate","Severe","VerySevere")
  print(diagnosed)
  diagnosed$Diagnosis <- "diagnosed"

  # plot
  exac.plot <- tidyr::gather(data=rbind(undiagnosed, diagnosed), key="Exacerbation", value="Rate", Mild:VerySevere)

  exac.plotted <- ggplot2::ggplot(exac.plot, aes(x=Year, y=Rate, fill=Diagnosis)) +
                      geom_bar(stat="identity", position="dodge") + facet_wrap(~Exacerbation, labeller=label_both) +
                      scale_y_continuous(expand = c(0, 0)) +
                      xlab("Model Year") + ylab("Annual rate of exacerbations") + theme_bw()

  plot(exac.plotted)

  message("\n")
  terminate_session()

  ###
  message("\n")
  message("Now, set the treatment effects to 0 and make sure the number of exacerbations increased among diagnosed patients.\n")
  message("\n")

  init_session(settings = settings)

  input_nt <- model_input$values

  input_nt$medication$medication_ln_hr_exac <- rep(0, length(inputs$medication$medication_ln_hr_exac))

  res <- run(input = input_nt)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs_nt <- Cget_inputs()
  output_ex_nt <- Cget_output_ex()

  exac.diff <- data.frame(cbind(1:inputs_nt$global_parameters$time_horizon,
                          output_ex_nt$n_exac_by_ctime_severity_diagnosed - output_ex$n_exac_by_ctime_severity_diagnosed))

  names(exac.diff) <- c("Year","Mild","Moderate","Severe","VerySevere")

  message("Without treatment, there was an average of:\n")
  message(mean(exac.diff$Mild),"more mild exacerbations,\n")
  message(mean(exac.diff$Moderate),"more moderate exacerbations,\n")
  message(mean(exac.diff$Severe),"more severe exacerbations, and\n")
  message(mean(exac.diff$VerySevere),"more very severe exacerbations per year.\n")

  ###
  message("\n")
  message("Now, set all COPD patients to diagnosed, then undiagnosed, and compare the exacerbation rates.\n")
  message("\n")

  init_session(settings = settings)

  input_nd <- model_input$values

  input_nd$diagnosis$logit_p_prevalent_diagnosis_by_sex <- cbind(male=c(intercept=-100, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                                            cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                                            case_detection=0),
                                                                     female=c(intercept=-100-0.1638, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                                              cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                                              case_detection=0))

  input_nd$diagnosis$p_hosp_diagnosis <- 0

  input_nd$diagnosis$logit_p_diagnosis_by_sex <- cbind(male=c(intercept=-100, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                                  gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                                  case_detection=0),
                                                           female=c(intercept=-100-0.4873, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                                    gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                                    case_detection=0))

  input_nd$diagnosis$logit_p_overdiagnosis_by_sex <- cbind(male=c(intercept=-100, age=0.0025, smoking=0.6911, gpvisits=0.0075,
                                                                      cough=0.7264, phlegm=0.7956, wheeze=0.66, dyspnea=0.8798,
                                                                      case_detection=0),
                                                               female=c(intercept=-100+0.2597, age=0.0025, smoking=0.6911, gpvisits=0.0075,
                                                                        cough=0.7264, phlegm=0.7956, wheeze=0.66, dyspnea=0.8798,
                                                                        case_detection=0))

  res <- run(input = input_nd)
  if (res < 0)
    stop("Execution stopped.\n")

  output_ex_nd <- Cget_output_ex()

  exac_rate_nodiag <- rowSums(output_ex_nd$n_exac_by_ctime_severity)/rowSums(output_ex_nd$n_COPD_by_ctime_sex)

  terminate_session()

  ###

  init_session(settings = settings)

  input_d <- model_input$values

  input_d$diagnosis$logit_p_prevalent_diagnosis_by_sex <- cbind(male=c(intercept=100, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                                        cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                                        case_detection=0),
                                                                 female=c(intercept=100-0.1638, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                                          cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                                          case_detection=0))

  input_d$diagnosis$p_hosp_diagnosis <- 1

  input_d$diagnosis$logit_p_diagnosis_by_sex <- cbind(male=c(intercept=100, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                              gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                              case_detection=0),
                                                       female=c(intercept=100-0.4873, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                                gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                                case_detection=0))


  res <- run(input = input_d)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs_d <- Cget_inputs()
  output_ex_d <- Cget_output_ex()

  exac_rate_diag <- rowSums(output_ex_d$n_exac_by_ctime_severity)/rowSums(output_ex_d$n_COPD_by_ctime_sex)

  ##
  message("Annual exacerbation rate (this is also plotted):\n")
  message("\n")

  trt_effect<- data.frame(Year=1:inputs_d$global_parameters$time_horizon,
                          Diagnosed = exac_rate_diag,
                          Undiagnosed = exac_rate_nodiag)

  trt_effect$Delta <- (trt_effect$Undiagnosed - trt_effect$Diagnosed)/trt_effect$Undiagnosed

  print(trt_effect)

  message("\n")
  message("Treatment reduces the rate of exacerbations by a mean of:", mean(trt_effect$Delta),"\n")

  # plot
  trt.plot <- tidyr::gather(data=trt_effect, key="Diagnosis", value="Rate", Diagnosed:Undiagnosed)

  trt.plotted <- ggplot2::ggplot(trt.plot, aes(x=Year, y=Rate, col=Diagnosis)) +
                            geom_line() + geom_point() + expand_limits(y = 0) +
                            theme_bw() + ylab("Annual exacerbation rate") + xlab("Years")

  plot(trt.plotted)

  terminate_session()
}

#' Returns results of Case Detection strategies
#' @param n_sim number of agents
#' @param p_of_CD probability of recieving case detection given that an agent meets the selection criteria
#' @param min_age minimum age that can recieve case detection
#' @param min_pack_years minimum pack years that can recieve case detection
#' @param only_smokers set to 1 if only smokers should recieve case detection
#' @param CD_method Choose one case detection method: CDQ195", "CDQ165", "FlowMeter", "FlowMeter_CDQ"
#' @return results of case detection strategy compared to no case detection
#' @export
test_case_detection <- function(n_sim = 1e+04, p_of_CD=0.1, min_age=40, min_pack_years=0, only_smokers=0, CD_method="CDQ195") {
  message("Comparing a case detection strategy to no case detection.\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
#  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  input$diagnosis$p_case_detection <- p_of_CD
  input$diagnosis$min_cd_age <- min_age
  input$diagnosis$min_cd_pack_years <- min_pack_years
  input$diagnosis$min_cd_smokers <-only_smokers

  input$diagnosis$logit_p_prevalent_diagnosis_by_sex <- cbind(male=c(intercept=1.0543, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                                     cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                                     case_detection=input$diagnosis$case_detection_methods[1,CD_method]),
                                                              female=c(intercept=1.0543-0.1638, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                                       cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                                       case_detection=input$diagnosis$case_detection_methods[1,CD_method]))

  input$diagnosis$logit_p_diagnosis_by_sex <- cbind(male=c(intercept=-2, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                           gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                           case_detection=input$diagnosis$case_detection_methods[1,CD_method]),
                                                    female=c(intercept=-2-0.4873, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                             gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                             case_detection=input$diagnosis$case_detection_methods[1,CD_method]))

  input$diagnosis$logit_p_overdiagnosis_by_sex <- cbind(male=c(intercept=-5.2169, age=0.0025, smoking=0.6911, gpvisits=0.0075,
                                                               cough=0.7264, phlegm=0.7956, wheeze=0.66, dyspnea=0.8798,
                                                               case_detection=input$diagnosis$case_detection_methods[2,CD_method]),
                                                        female=c(intercept=-5.2169+0.2597, age=0.0025, smoking=0.6911, gpvisits=0.0075,
                                                                 cough=0.7264, phlegm=0.7956, wheeze=0.66, dyspnea=0.8798,
                                                                 case_detection=input$diagnosis$case_detection_methods[2,CD_method]))
  message("\n")
  message("Here are your inputs for the case detection strategy:\n")
  message("\n")
  print(input$diagnosis)

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs <- Cget_inputs()
  output <- Cget_output()
  output_ex <- Cget_output_ex()

  # Exacerbations
  exac <- output$total_exac
  names(exac) <- c("Mild","Moderate","Severe","VerySevere")
    # rate
  total.gold <- colSums(output_ex$n_COPD_by_ctime_severity[,2:5])
  names(total.gold) <- c("GOLD1","GOLD2","GOLD3","GOLD4")

  exac.gs <- data.frame(output_ex$n_exac_by_gold_severity)
  colnames(exac.gs) <- c("Mild","Moderate","Severe","VerySevere")

  exac_rate <- rbind(GOLD1=exac.gs[1,]/total.gold[1],
                     GOLD2=exac.gs[2,]/total.gold[2],
                     GOLD3=exac.gs[3,]/total.gold[3],
                     GOLD4=exac.gs[4,]/total.gold[4])
  exac_rate$CD <- "Case detection"
  exac_rate$GOLD <- rownames(exac_rate)

  # GOLD
  gold <- data.frame(CD="Case detection",
                         Proportion=colMeans(output_ex$n_COPD_by_ctime_severity/rowSums(output_ex$n_alive_by_ctime_sex)))
  gold$GOLD <- c("NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  terminate_session()

  ## Rerunning with no case detection

  init_session(settings = settings)

  input_nocd <- model_input$values

  input_nocd$diagnosis$p_case_detection <- 0

  message("\n")
  message("Now setting the probability of case detection to", input_nocd$diagnosis$p_case_detection, "and re-running the model\n")
  message("\n")

  res <- run(input = input_nocd)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs_nocd <- Cget_inputs()
  output_nocd <- Cget_output()
  output_ex_nocd <- Cget_output_ex()

  # Exacerbations
  exac_nocd <- output_nocd$total_exac
  names(exac_nocd) <- c("Mild","Moderate","Severe","VerySevere")
    # rate
  total.gold_nocd <- colSums(output_ex_nocd$n_COPD_by_ctime_severity[,2:5])
  names(total.gold_nocd) <- c("GOLD1","GOLD2","GOLD3","GOLD4")

  exac.gs_nocd <- data.frame(output_ex_nocd$n_exac_by_gold_severity)
  colnames(exac.gs_nocd) <- c("Mild","Moderate","Severe","VerySevere")

  exac_rate_nocd <- rbind(GOLD1=exac.gs_nocd[1,]/total.gold_nocd[1],
                     GOLD2=exac.gs_nocd[2,]/total.gold_nocd[2],
                     GOLD3=exac.gs_nocd[3,]/total.gold_nocd[3],
                     GOLD4=exac.gs_nocd[4,]/total.gold_nocd[4])
  exac_rate_nocd$CD <- "No Case detection"
  exac_rate_nocd$GOLD <- rownames(exac_rate_nocd)

  # GOLD
  gold_nocd<- data.frame(CD="No case detection",
                         Proportion=colMeans(output_ex_nocd$n_COPD_by_ctime_severity/rowSums(output_ex_nocd$n_alive_by_ctime_sex)))
  gold_nocd$GOLD <- c("NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4")

  ## Difference between CD and No CD
  # Exacerbations
  exac.diff <- data.frame(cbind(CD=exac, NOCD=exac_nocd))
  exac.diff$Delta <- exac.diff$CD - exac.diff$NOCD

  message("Here are total number of exacerbations by severity:\n")
  message("\n")
  print(exac.diff)

  message("\n")
  message("The annual rate of exacerbations with case detection is:\n")
  print(exac_rate[,1:4])
  message("\n")
  message("The annual rate of exacerbations without case detection is:\n")
  print(exac_rate_nocd[,1:4])
  message("\n")
  message("This data is also plotted.\n")

  #plot
  exac.plot <- tidyr::gather(rbind(exac_rate, exac_rate_nocd), key="Exacerbation", value="Rate", Mild:VerySevere)

  exac.plotted <-ggplot2::ggplot(exac.plot, aes(x=Exacerbation, y=Rate, fill=CD)) +
                      geom_bar(stat="identity", position="dodge") + facet_wrap(~GOLD, scales="free_y") +
                      scale_y_continuous(expand = expand_scale(mult=c(0, 0.1))) +
                      xlab("Exacerbation") + ylab("Annual rate of exacerbations") + theme_bw()

  exac.plotted <- exac.plotted + theme(axis.text.x=element_text(angle=45, hjust=1)) +
                    theme(legend.title = element_blank())

  plot(exac.plotted)


  # GOLD
  # plot
  message("\n")
  message("The average proportion of agents in each gold stage is also plotted.\n")

  gold.plot <- rbind(gold, gold_nocd)

  gold.plot$GOLD <- factor(gold.plot$GOLD, levels=c("NoCOPD","GOLD1","GOLD2","GOLD3","GOLD4"))

  gold.plotted <- ggplot2::ggplot(gold.plot, aes(x=GOLD, y=Proportion, fill=CD)) +
                      geom_bar(stat="identity", position="dodge") +
                      scale_y_continuous(expand = c(0,0), limits=c(0,1)) +
                      xlab("GOLD stage") + ylab("Average proportion") + theme_bw()

  gold.plotted <- gold.plotted + theme(legend.title = element_blank())

  plot(gold.plotted)

  message("\n")

  terminate_session()
}


#' Returns results of validation tests for overdiagnosis
#' @param n_sim number of agents
#' @return validation test results
#' @export
validate_overdiagnosis <- function(n_sim = 1e+04) {
  message("Let's take a look at overdiagnosis\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_none"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- 0
  init_session(settings = settings)

  input <- model_input$values

  res <- run(input = input)
  if (res < 0)
    stop("Execution stopped.\n")

  inputs <- Cget_inputs()
  output_ex <- Cget_output_ex()

  message("Here are the proportion of non-COPD subjects overdiagnosed over model time: \n")

  overdiag <- data.frame(Year=1:inputs$global_parameters$time_horizon,
                     NonCOPD=output_ex$n_COPD_by_ctime_severity[,1],
                     Overdiagnosed=rowSums(output_ex$n_Overdiagnosed_by_ctime_sex))

  overdiag$Proportion <- overdiag$Overdiagnosed/overdiag$NonCOPD

  print(overdiag)

  message("The average proportion overdiagnosed from year", round(length(overdiag$Proportion)/2,0), "to", length(overdiag$Proportion), "is",
      mean(overdiag$Proportion[(round(length(overdiag$Proportion)/2,0)):(length(overdiag$Proportion))]),"\n")

  overdiag.plot <- tidyr::gather(data=overdiag, key="Variable", value="Number", c(NonCOPD, Overdiagnosed))

  overdiag.plotted <- ggplot2::ggplot(overdiag.plot, aes(x=Year, y=Number, col=Variable)) +
    geom_line() + geom_point() + expand_limits(y = 0) +
    theme_bw() + ylab("Number of non-COPD subjects") + xlab("Years")

  plot(overdiag.plotted)

  message("\n")

  terminate_session()

}


#' Returns results of validation tests for medication module.
#' @param n_sim number of agents
#' @return validation test results for medication
#' @export

validate_medication <- function(n_sim = 5e+04) {
  message("\n")
  message("Plotting medimessageion usage over time:")
  message("\n")
  petoc()

  settings <- default_settings
  settings$record_mode <- record_mode["record_mode_event"]
  settings$agent_stack_size <- 0
  settings$n_base_agents <- n_sim
  settings$event_stack_size <- settings$n_base_agents * 1.7 * 30
  init_session(settings = settings)

  input <- model_input$values

res <- run(input = input)
if (res < 0)
  stop("Execution stopped.\n")

all_events <- as.data.frame(Cget_all_events_matrix())
all_annual_events <- all_events[all_events$event==1,] # only annual event

# Prop on each med class over time and by gold
all_annual_events$time <- floor(all_annual_events$local_time + all_annual_events$time_at_creation)

med.plot <- all_annual_events %>%
  group_by(time, gold) %>%
  count(medication_status) %>%
  mutate(prop=n/sum(n))

med.plot$gold <- as.character(med.plot$gold )

# overall among COPD patients
copd <- med.plot %>%
  filter(gold>0) %>%
  group_by(time, medication_status) %>%
  summarise(n=sum(n)) %>%
  mutate(prop=n/sum(n), gold="all copd") %>%
  select(time, gold, everything())

med.plot <- rbind(med.plot, copd)

med.plot$medication_status <- ifelse(med.plot$medication_status==0,"none",
                                     ifelse(med.plot$medication_status==1,"SABA",
                                            ifelse(med.plot$medication_status==4,"LAMA",
                                                   ifelse(med.plot$medication_status==6,"LAMA/LABA",
                                                          ifelse(med.plot$medication_status==14,"ICS/LAMA/LABA",9)))))

med.plotted <- ggplot2::ggplot(data=med.plot, aes(x=time, y=prop, col=medication_status)) +
  geom_line() + facet_wrap(~gold, labeller=label_both) +
  expand_limits(y = 0) + theme_bw() + ylab("Proportion per medication class") + xlab("Years") +
  theme(legend.title=element_blank())

plot(med.plotted)

terminate_session()

}
