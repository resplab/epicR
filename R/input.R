# The following declarations are already defined in mode.WIP.cpp
# they are replicated here to make it compatible with epicR as a package. Amin

record_mode<-c(
  record_mode_none=0,
  record_mode_agent=1,
  record_mode_event=2,
  record_mode_some_event=3
)


medication_classes<-c(
  MED_CLASS_SABA=1,
  MED_CLASS_LABA=2,
  MED_CLASS_LAMA=4,
  MED_CLASS_ICS=8,
  MED_CLASS_MACRO=16
)



events<-c(
  event_start=0,
  event_fixed=1,
  event_birthday=2,
  event_smoking_change=3,
  event_COPD=4,
  event_exacerbation=5,
  event_exacerbation_end=6,
  event_exacerbation_death=7,
  event_doctor_visit=8,
  event_medication_change=9,

  event_mi=10,
  event_stroke=11,
  event_hf=12,

  event_bgd=13,
  event_end=14
)


agent_creation_mode<-c(
  agent_creation_mode_one=0,
  agent_creation_mode_all=1,
  agent_creation_mode_pre=2
)



errors<-c(
  ERR_INCORRECT_SETTING_VARIABLE=-1,
  ERR_INCORRECT_VECTOR_SIZE=-2,
  ERR_INCORRECT_INPUT_VAR=-3,
  ERR_EVENT_STACK_FULL=-4,
  ERR_MEMORY_ALLOCATION_FAILED=-5
)

# End of declarations


#' Returns a list of default model input values
#' @param age0 Starting age in the model
#' @param time_horizon Model time horizon
#' @param discount_cost Discounting for cost outcomes
#' @param discount_qaly Discounting for QALY outcomes
#' @param closed_cohort Whether the model should run as closed_cohort, open-population by default.
#' @param jurisdiction Jurisdiction for model parameters ("canada" or "us")
#' @export
get_input <- function(age0 = 40,
                       time_horizon = 20,
                       discount_cost = 0,
                       discount_qaly = 0.03,
                       closed_cohort=0,
                       jurisdiction = "canada") {
  
  # Load configuration file based on jurisdiction
  config_file <- system.file("config", paste0("config_", jurisdiction, ".json"), package = "epicR")
  
  # If package not installed, try development mode path
  if (!file.exists(config_file) || config_file == "") {
    config_file <- file.path("inst", "config", paste0("config_", jurisdiction, ".json"))
  }
  
  if (!file.exists(config_file)) {
    stop(paste("Configuration file for jurisdiction", jurisdiction, "not found. Tried:", config_file))
  }
  
  # Load JSON configuration
  config <- jsonlite::fromJSON(config_file, simplifyVector = FALSE)
  
  # Helper function to convert config values to appropriate R types
  convert_config_value <- function(value) {
    if (is.character(value) && startsWith(value, "PLACEHOLDER_")) {
      stop(paste("Placeholder value not replaced:", value))
    }
    if (is.list(value) && length(value) > 0) {
      # Convert lists to matrices/vectors as needed
      if (all(sapply(value, is.numeric))) {
        return(unlist(value))
      }
      return(value)
    }
    return(value)
  }
  
  # Helper function to create matrices from config
  create_matrix_from_config <- function(config_section, transpose = TRUE) {
    if (is.list(config_section)) {
      mat <- do.call(cbind, lapply(config_section, function(x) convert_config_value(x)))
      if (transpose) mat <- t(mat)
      return(mat)
    }
    return(convert_config_value(config_section))
  }
  
  # Override config values with function parameters if provided
  if (!missing(age0)) config$global_parameters$age0 <- age0
  if (!missing(time_horizon)) config$global_parameters$time_horizon <- time_horizon
  if (!missing(discount_cost)) config$global_parameters$discount_cost <- discount_cost
  if (!missing(discount_qaly)) config$global_parameters$discount_qaly <- discount_qaly
  if (!missing(closed_cohort)) config$global_parameters$closed_cohort <- closed_cohort
  
  input <- list()
  input_help <- list()
  input_ref <- list()


  input$global_parameters <- list(age0 = config$global_parameters$age0,
                                  time_horizon = config$global_parameters$time_horizon,
                                  discount_cost = config$global_parameters$discount_cost,
                                  discount_qaly = config$global_parameters$discount_qaly,
                                  closed_cohort = config$global_parameters$closed_cohort)
  input_help$global_parameters <- list(age0 = "Starting age in the model",
                                       time_horizon = "Model time horizon",
                                       discount_cost = "Discounting for cost outcomes",
                                       discount_qaly = "Discounting for QALY outcomes",
                                       closed_cohort = "Whether the model should run as closed_cohort, open-population by default")



  input_help$agent$p_female <- "Proportion of females in the population"
  input$agent$p_female <- convert_config_value(config$agent$p_female)
  input_ref$agent$p_female <- "Model assumption"


  input_help$agent$height_0_betas <- "Regression coefficients for estimating height (in meters) at baseline"
  input$agent$height_0_betas <- t(as.matrix(convert_config_value(config$agent$height_0_betas)))
  input_ref$agent$height_0_betas <- ""


  input_help$agent$height_0_sd <- "SD representing heterogeneity in baseline height"
  input$agent$height_0_sd <- convert_config_value(config$agent$height_0_sd)
  input_ref$agent$height_0_sd <- ""


  input_help$agent$weight_0_betas <- "Regression coefficients for estimating weiight (in Kg) at baseline"
  input$agent$weight_0_betas <- t(as.matrix(convert_config_value(config$agent$weight_0_betas)))
  input_ref$agent$weight_0_betas <- ""


  input_help$agent$weight_0_sd <- "SD representing heterogeneity in baseline weight"
  input$agent$weight_0_sd <- convert_config_value(config$agent$weight_0_sd)
  input_ref$agent$weight_0_sd <- ""


  input_help$agent$height_weight_rho <- "Correlaiton coefficient between weight and height at baseline"
  input$agent$height_weight_rho <- convert_config_value(config$agent$height_weight_rho)
  input_ref$agent$height_weight_rho <- ""

  input_help$agent$p_prevalence_age <- "Age pyramid at baseline"
  input$agent$p_prevalence_age <- convert_config_value(config$agent$p_prevalence_age)
  input$agent$p_prevalence_age <- input$agent$p_prevalence_age/sum(input$agent$p_prevalence_age)
  input_ref$agent$p_prevalence_age <- paste("From config for", config$jurisdiction)


  input_help$agent$p_incidence_age <- "Discrete distribution of age for the incidence population (population arriving after the first date) - generally estimated through calibration"
  if (config$agent$p_incidence_age == "calculated") {
    input$agent$p_incidence_age <- c(rep(0, 40), c(1), 0.02* exp(-(0:59)/5), rep(0, 111 - 40 - 1 - 60))
    input$agent$p_incidence_age <- input$agent$p_incidence_age/sum(input$agent$p_incidence_age)
  } else {
    input$agent$p_incidence_age <- convert_config_value(config$agent$p_incidence_age)
    input$agent$p_incidence_age <- input$agent$p_incidence_age/sum(input$agent$p_incidence_age)
  }
  input_ref$agent$p_incidence_age <- ""


  input_help$agent$p_bgd_by_sex <- "Life table"
  input$agent$p_bgd_by_sex <- create_matrix_from_config(config$agent$p_bgd_by_sex, transpose = FALSE)
  input_ref$agent$p_bgd_by_sex <- paste("Life table for", config$jurisdiction)


  input_help$agent$l_inc_betas <- "Ln of incidence rate of the new population - Calibration target to keep populatoin size and age pyramid in line with calibration"
  l_inc_config <- convert_config_value(config$agent$l_inc_betas)
  l_inc_config[1] <- l_inc_config[1] - input$global_parameters$closed_cohort*100  # adjust intercept for closed cohort
  input$agent$l_inc_betas <- t(as.matrix(l_inc_config))
  input_ref$agent$l_inc_betas <- "If closed cohort is enabled, incidence population will be turned off."


  input_help$agent$ln_h_bgd_betas <- "Increased Longevity Over time and effect of other variables"
  input$agent$ln_h_bgd_betas <- t(as.matrix(convert_config_value(config$agent$ln_h_bgd_betas)))
  input_ref$agent$ln_h_bgd_betas <- ""

  ### smoking;

  input_help$smoking$logit_p_current_smoker_0_betas <- "Probability of being a current smoker at the time of creation"
  input$smoking$logit_p_current_smoker_0_betas <- t(as.matrix(c(Intercept = -0.2, sex = -1, age = -0.02, age2 = 0, sex_age = 0,
                                                                sex_age2 = 0, year = -0.02)))  #intercept -1.8 when age = -0.02
  input_ref$smoking$logit_p_current_smoker_0_betas <- ""

  input_help$smoking$logit_p_never_smoker_con_not_current_0_betas <- "Probability of being a never-smoker conditional on not being current smoker, at the time of creation"
  input$smoking$logit_p_never_smoker_con_not_current_0_betas <- t(as.matrix(c(intercept = 3.7, sex = 0, age = -0.06, age2 = 0, sex_age = 0,
                                                                              sex_age2 = 0, year = -0.02)))
  input_ref$smoking$logit_p_never_smoker_con_not_current_0_betas <- ""


  input_help$smoking$minimum_smoking_prevalence <- "Minimum Smoking Prevalence"
  input$smoking$minimum_smoking_prevalence <- 0.10
  input_ref$smoking$minimum_smoking_prevalence <- ""


  #input_help$smoking$mortality_factor_current <- "Mortality ratio for current smokers vs. non-smokers"
  #input$smoking$mortality_factor_current <- 1.83  #1.83
  #input_ref$smoking$mortality_factor_current <- "Meta-analysis. doi:10.1001/archinternmed.2012.1397"

  #input_help$smoking$mortality_factor_former <- "Mortality ratio for former smokers vs. non-smokers"
  #input$smoking$mortality_factor_former <- 1.34  #1.34
  #input_ref$smoking$mortality_factor_former <- "Meta-analysis. doi:10.1001/archinternmed.2012.1397"

  input_help$smoking$mortality_factor_current  <- "Mortality ratio for current  smokers vs. non-smokers by sex and age group"
  input$smoking$mortality_factor_current <- t(as.matrix(c(age40to49 = 1, age50to59 = 1, age60to69 = 1.94  , age70to79 = 1.86, age80p = 1.66 )))
  input_ref$smoking$mortality_factor_current <- "Meta-analysis. doi:10.1001/archinternmed.2012.1397"

  input_help$smoking$mortality_factor_former  <- "Mortality ratio for current  smokers vs. non-smokers by sex and age group"
  input$smoking$mortality_factor_former<- t(as.matrix(c(age40to49 = 1, age50to59 = 1, age60to69 = 1.54  , age70to79 = 1.36, age80p = 1.27 )))
  input_ref$smoking$mortality_factor_former <- "Meta-analysis. doi:10.1001/archinternmed.2012.1397"


  input_help$smoking$pack_years_0_betas <- "Regression equations for determining the pack-years of smoking at the time of creation (for elogit_p_never_smoker_con_current_0_betas smokers)"
  input$smoking$pack_years_0_betas <- t(as.matrix(c(intercept = 22, sex = -4, age = 0, year = -0.6, current_smoker = 10)))
  input_ref$smoking$pack_years_0_betas <- ""


  input_help$smoking$pack_years_0_sd <- "Standard deviation for variation in pack-years among individuals (current or former smokers)"
  input$smoking$pack_years_0_sd <- 5
  input_ref$smoking$pack_years_0_sd <- ""


  input_help$smoking$ln_h_inc_betas <- "Log-hazard of starting smoking (incidence or relapse)"
  input$smoking$ln_h_inc_betas <- c(intercept = -4, sex = -0.15, age = -0.02, age2 = 0, calendar_time = -0.01)
  input_ref$smoking$ln_h_inc_betas <- ""


  input_help$smoking$ln_h_ces_betas <- "Log-hazard of smoking cessation"
  input$smoking$ln_h_ces_betas <- c(intercept = -3.7,  sex = 0, age = 0.02, age2 = 0, calendar_time = -0.01, diagnosis = log(1.38))
  input_ref$smoking$ln_h_ces_betas <- "Diagnosis coefficient from Wu et al. BMC Public Health 2006"

  input_help$smoking$smoking_ces_coefficient <- "Coefficient for the decay rate of smoking cessaton treatment, default is 100"
  input$smoking$smoking_ces_coefficient <- 100
  input_ref$smoking$smoking_ces_coefficient <- ""

  input_help$smoking$smoking_cessation_adherence <- "Proportion adherent to smoking cessation treatment"
  input$smoking$smoking_cessation_adherence <- 0.7
  input_ref$smoking$smoking_cessation_adherence <- ""


  ## COPD
  input_help$COPD$logit_p_COPD_betas_by_sex <- "Logit of the probability of having COPD (FEV1/FVC<0.7) at time of creation (separately by sex)"
  input$COPD$logit_p_COPD_betas_by_sex <- cbind(male = c(intercept = -4.522189  , age = 0.033070   , age2 = 0, pack_years = 0.025049   ,
                                                         current_smoking = 0, year = 0, asthma = 0),
                                                female = c(intercept = -4.074861   , age = 0.027359   , age2 = 0, pack_years = 0.030399   ,
                                                           current_smoking = 0, year = 0, asthma = 0))
  input_ref$COPD$logit_p_COPD_betas_by_sex <- "CanCold - Shahzad's Derivation. Last Updated on 2017-09-19, ne wmodel with no currnet smoker term"


  input_help$COPD$ln_h_COPD_betas_by_sex <- "Log-hazard of developing COPD (FEV1/FVC<LLN) for those who did not have COPD at creation time (separately by sex)"
  input$COPD$ln_h_COPD_betas_by_sex <- cbind(male = c(Intercept =  -7.97107937, age = 0.03245063, age2 = 0, pack_years =  0.03578899,
                                                      smoking_status = 0, year = 0, asthma = 0),
                                             female = c(Intercept = -7.78520064, age = 0.02975571, age2 = 0, pack_years = 0.04087865,
                                                        smoking_status =  0, year = 0, asthma = 0))
  input_ref$COPD$ln_h_COPD_betas_by_sex <- "Amin's Iterative solution. Last Updated on 2022-06-33 (0.29.0)"


  ## Lung function
  input_help$lung_function$fev1_0_prev_betas_by_sex <- "Regression (OLS) coefficients for mean of FEV1 at time of creation for those with COPD (separately by sex)"
  input$lung_function$fev1_0_prev_betas_by_sex <- cbind(male = c(intercept = 1.546161, age = -0.031296, height_sq = 1.012579,
                                                                 pack_years = -0.006925, current_smoker = 0, sgrq = 0),
                                                        female = c(intercept = 1.329805, age = -0.031296, height_sq = 1.012579,
                                                                   pack_years = -0.006925, current_smoker = 0, sgrq = 0))
  input_ref$lung_function$fev1_0_prev_betas_by_sex <- "for LLN based on Shahzad's calculations. Last Updated on 2017-04-19. See https://github.com/aminadibi/epicR/issues/8"


  input_help$lung_function$fev1_0_prev_sd_by_sex <- "SD of FEV1 at time of creation for those with COPD (separately by sex)"
  input$lung_function$fev1_0_prev_sd_by_sex <- c(male = 0.6148, female = 0.4242)
  input_ref$lung_function$fev1_0_prev_sd_by_sex <- ""


  input_help$lung_function$fev1_0_inc_betas_by_sex <- "Regression (OLS) coefficients for mean of FEV1 at time of development of COPD(separately by sex)"
  input$lung_function$fev1_0_inc_betas_by_sex <- cbind(male = c(intercept = 1.4895 - 0.6831, age = -0.0322, height_sq = 1.27,
                                                                pack_years = -0.00428, current_smoker = 0, sgrq = 0),
                                                       female = c(intercept = 1.5737 - 0.425, age = -0.0275, height_sq = 0.97,
                                                                  pack_years = -0.00465, current_smoker = 0, sgrq = 0))
  input_ref$lung_function$fev1_0_inc_betas_by_sex <- "for LLN based on Shahzad's calculations. Last Updated on 2017-04-19. See https://github.com/aminadibi/epicR/issues/8"


  input_help$lung_function$fev1_0_inc_sd_by_sex <- "SD of FEV1 at time of development of COPD (separately by sex)"
  input$lung_function$fev1_0_inc_sd_by_sex <- c(male = 0.54, female = 0.36)
  input_ref$lung_function$fev1_0_inc_sd_by_sex <- ""


  input_help$lung_function$fev1_0_ZafarCMAJ_by_sex <- "Regression coefficients for mean of FEV1 at time of creation with COPD or development of COPD based on Zafar's CMAJ. Used for conditional normal distribution in FEV1 decline equations.  (separately by sex)"
  input$lung_function$fev1_0_ZafarCMAJ_by_sex <- cbind(male = c(intercept = 1.4275 + 0.4825, baseline_age = -0.00508, baseline_weight_kg = -0.00049,
                                                                height = -1.8725, height_sq = 1.9513, current_smoker = -0.09221, age_height_sq = -0.00832, followup_time = 0),
                                                       female = c(intercept = 1.4275,  baseline_age = -0.00508, baseline_weight_kg = -0.00049,
                                                                  height = -1.8725, height_sq = 1.9513, current_smoker = -0.09221, age_height_sq = -0.00832, followup_time = 0))
  input_ref$lung_function$fev1_0_ZafarCMAJ_by_sex <- "Zafari Z, Sin DD, Postma DS, Lofdahl CG, Vonk J, Bryan S, Lam S, Tammemagi CM, Khakban R, Man SP, Tashkin D. Individualized prediction of lung-function decline in chronic obstructive pulmonary disease. Canadian Medical Association Journal. 2016 Oct 4;188(14):1004-11."


  # NHANES:
  # input$lung_function$pred_fev1_betas_by_sex<-rbind(c(intercept=-0.7453,age=-0.04106,age2=0.004477,height2=0.00014098),c(-0.871,0.06537,0,0.00011496))

  input_help$lung_function$pred_fev1_betas_by_sex <- "Coefficients for calculation of predicted FEV1 based on individual characteristics"
  input$lung_function$pred_fev1_betas_by_sex <- cbind(male = c(intercept = 0.5536, age = -0.01303, age_sq = -0.000172, height = 1.4098),
                                                      female = c(intercept = 0.4333, age = -0.00361, age_sq = -0.000194, height = 1.1496))
  input_ref$lung_function$pred_fev1_betas_by_sex <- ""



   input_help$lung_function$dfev1_betas <- "Regression equations (mixed-effects model) for rate of FEV1 decline"
     input$lung_function$fev1_betas_by_sex <- cbind(male = c(intercept = -0.1543 - 0.00762, baseline_age = 0.002344, baseline_weight_kg = 0.000126,
                                                             height = 0.05835, height_sq = 0.01807, current_smoker = -0.03074, age_height_sq = -0.00093, followup_time = -0.00146),
                                                   female = c(intercept = -0.1543 , baseline_age = 0.002344, baseline_weight_kg = 0.000126,
                                                               height = 0.05835, height_sq = 0.01807, current_smoker = -0.03074, age_height_sq = -0.00093, followup_time = -0.00146))
     input_ref$lung_function$dfev1_betas <- ""

  # input$lung_function$fev1_betas_by_sex <- cbind(male = c(intercept = -0.1543 , baseline_age = 0, baseline_weight_kg = 0,
  #                                                         height = 0, height_sq = 0, current_smoker = 0, age_height_sq = 0, followup_time = 0),
  #                                                female = c(intercept = -0.1543  , baseline_age =0, baseline_weight_kg = 0,
  #                                                           height = 0, height_sq =0, current_smoker = 0, age_height_sq = 0, followup_time = 0))
  input_ref$lung_function$dfev1_betas <- ""

  input_help$lung_function$dfev1_sigmas <- "Sigmas in G Matrix for FEV1 decline"
  input$lung_function$dfev1_sigmas <- t(as.matrix(c(sigma1 = sqrt(0.1006), sigma2 = sqrt(0.000759))))
  input_ref$lung_function$dfev1_sigmas <- ""


  input_help$lung_function$dfev1_re_rho <- "Correlation coefficient between random-effect terms in the mixed-effects model of FEV1 decline"
  input$lung_function$dfev1_re_rho <- 0.09956332 # From G Matrix: 0.00087/(sqrt(0.1006)*sqrt(0.000759))
  input_ref$lung_function$dfev1_re_rho <- "G Matrix Zafari CMAJ 2016 - Modified"


  ## Exacerbation;

  input_help$exacerbation$ln_rate_betas = "Regression coefficients for the random-effects log-hazard model of exacerbation (of any severity)"
  input$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 1.4, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.7, gold1 = 0.3 , gold2 = -0.3 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))
  input_ref$exacerbation$ln_rate_betas = "Rates from DOI: 10.2147/COPD.S13826, adjusted to account for diganosis bias. Adjusted on 2018-10-02 to match manuscript. Recalibrated on 2022-11-04, see validate_exacerbations()"

  input_help$exacerbation$ln_rate_intercept_sd = "SD of the random intercept for log-hazard of exacerbation"
  input$exacerbation$ln_rate_intercept_sd = sqrt(0.55)
  input_ref$exacerbation$ln_rate_intercept_sd = ""


  input_help$exacerbation$logit_severity_betas = "Regression coefficients for the proportional odds model of exacerbation severity"
  input$exacerbation$logit_severity_betas = t(as.matrix(c(intercept1 = -3.609, intercept2 = 2.202, intercept3 = 5.208, female = -0.764,
                                                          age = -0.007, fev1 = 0.98, smoking_status = 0.348, pack_years = -0.001 , BMI = 0.018)))
  input_ref$exacerbation$logit_severity_betas = "Shahzad's regression on MACRO with adjusted intercepts to match severity levels reported by Hoogendoorn et al. Last updated on manuscript submission"


  input_help$exacerbation$logit_severity_intercept_sd = "SD of the random intercept for proportional odds model of exacerbation severity"
  input$exacerbation$logit_severity_intercept_sd = sqrt(2.0736)
  input_ref$exacerbation$logit_severity_intercept_sd = ""


  input_help$exacerbation$rate_severity_intercept_rho = "Correlation coefficient between the random effect terms of rate and severity"
  input$exacerbation$rate_severity_intercept_rho = -0
  input_ref$exacerbation$rate_severity_intercept_rho = ""


  input_help$exacerbation$exac_end_rate <- "Rate of ending of an exacerbation (inversely realted to exacerbation duration) according to severity level"
  input$exacerbation$exac_end_rate <- t(as.matrix(c(mild = 365/5, moderate = 365/5, severe = 365/5, verysevere = 365/5)))
  input_ref$exacerbation$exac_end_rate <- ""

  input_help$exacerbation$logit_p_death_by_sex <- "Probability of death due to exacerbation according to its severity level"
  #  input$exacerbation$p_death <- t(as.matrix(c(mild = 0, moderate = 0, severe = 0.1, verysevere = 0.1)))
  input$exacerbation$logit_p_death_by_sex <- cbind(male = c(intercept = -13, age = log(1.05),  mild = 0, moderate = 0, severe = 7.4, very_severe = 8, n_hist_severe_exac = 0),
                                                   female = c(intercept = -13, age = log(1.05),  mild = 0, moderate = 0, severe = 7.4, very_severe = 8, n_hist_severe_exac = 0))
  input_ref$exacerbation$logit_p_death_by_sex <- ""

  ## Symptoms;

  # cough;
  input_help$symptoms$logit_p_cough_COPD_by_sex <- "Probability of having cough for COPD patients"
  input$symptoms$logit_p_cough_COPD_by_sex <- cbind(male=c(intercept=4.4006, age=-0.0412, smoking=0.6036, packyears=0, fev1=-0.9564),
                                                    female=c(intercept=4.4006-0.9472, age=-0.0412, smoking=0.6036, packyears=0, fev1=-0.9564))
  input_ref$symptoms$logit_p_cough_COPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  input_help$symptoms$logit_p_cough_nonCOPD_by_sex <- "Probability of having cough for non-COPD patients"
  input$symptoms$logit_p_cough_nonCOPD_by_sex <- cbind(male=c(intercept=-5.2872, age=0.03429, smoking=0.3786, packyears=0),
                                                       female=c(intercept=-5.2872+0.2178, age=0.03429, smoking=0.3786, packyears=0))
  input_ref$symptoms$logit_p_cough_nonCOPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  # phlegm;
  input_help$symptoms$logit_p_phlegm_COPD_by_sex <- "Probability of having phlegm for COPD patients"
  input$symptoms$logit_p_phlegm_COPD_by_sex <- cbind(male=c(intercept=3.5726, age=-0.02422, smoking=1.0754, packyears=0, fev1=-1.6443),
                                                     female=c(intercept=3.5726-2.089, age=-0.02422, smoking=1.0754, packyears=0, fev1=-1.6443))
  input_ref$symptoms$logit_p_phlegm_COPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  input_help$symptoms$logit_p_phlegm_nonCOPD_by_sex <- "Probability of having phlegm for non-COPD patients"
  input$symptoms$logit_p_phlegm_nonCOPD_by_sex <- cbind(male=c(intercept=-10.3164, age=0.02771, smoking=0.5865, packyears=0),
                                                        female=c(intercept=-10.3164-0.3459, age=0.02771, smoking=0.5865, packyears=0))
  input_ref$symptoms$logit_p_phlegm_nonCOPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  # dyspnea;
  input_help$symptoms$logit_p_dyspnea_COPD_by_sex <- "Probability of having dyspnea for COPD patients"
  input$symptoms$logit_p_dyspnea_COPD_by_sex <-  cbind(male=c(intercept=4.8358, age=-0.00891, smoking=0.4177, packyears=0, fev1=-1.9942),
                                                       female=c(intercept=4.8358-0.6346, age=-0.00891, smoking=0.4177, packyears=0, fev1=-1.9942))
  input_ref$symptoms$logit_p_dyspnea_COPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  input_help$symptoms$logit_p_dyspnea_nonCOPD_by_sex <- "Probability of having dyspnea for non-COPD patients"
  input$symptoms$logit_p_dyspnea_nonCOPD_by_sex <- cbind(male=c(intercept=-7.1802, age=0.07002, smoking=0.8388, packyears=0),
                                                         female=c(intercept=-7.1802+0.9343, age=0.07002, smoking=0.8388, packyears=0))
  input_ref$symptoms$logit_p_dyspnea_nonCOPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  # wheeze;
  input_help$symptoms$logit_p_wheeze_COPD_by_sex <- "Probability of having wheeze for COPD patients"
  input$symptoms$logit_p_wheeze_COPD_by_sex <- cbind(male=c(intercept=14.2686, age=-0.1408, smoking=0.1345, packyears=0, fev1=-2.3122),
                                                     female=c(intercept=14.2686-1.4995, age=-0.1408, smoking=0.1345, packyears=0, fev1=-2.3122))
  input_ref$symptoms$logit_p_wheeze_COPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  input_help$symptoms$logit_p_wheeze_nonCOPD_by_sex <- "Probability of having wheeze for non-COPD patients"
  input$symptoms$logit_p_wheeze_nonCOPD_by_sex <- cbind(male=c(intercept=-6.6284, age=-0.02051, smoking=0.2332, packyears=0),
                                                        female=c(intercept=-6.6284+0.4671, age=-0.02051, smoking=0.2332, packyears=0))
  input_ref$symptoms$logit_p_wheeze_nonCOPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-22"

  # covraiance matrices for symptoms
  input_help$symptoms$covariance_COPD <- "Covariance matrix for symptoms random effects in COPD patients"
  input$symptoms$covariance_COPD<- cbind(cough = c(cough = 2.7934, phlegm =2.11077, wheeze =1.1737, dyspnea = 0.64573),
                                         phlegm = c(cough = 2.11077, phlegm = 7.0945, wheeze = 1.45258, dyspnea =0.89548),
                                         wheeze = c(cough = 1.1737, phlegm = 1.45258, wheeze = 7.4793, dyspnea =1.48313),
                                         dyspnea = c(cough = 0.64573, phlegm = 0.89548, wheeze = 1.48313, dyspnea = 3.6357))
  input_ref$symptoms$covariance_COPD <- "Kate's regression on CanCOLD, provided on 2019-05-22"


  input_help$symptoms$covariance_nonCOPD <- "Covariance matrix for symptoms random effects in non-COPD patients"
  input$symptoms$covariance_nonCOPD<- cbind(cough = c(cough = 10.4693, phlegm = 17.10328, wheeze = 9.39833, dyspnea = 1.04549),
                                            phlegm = c(cough = 17.10328, phlegm = 138.8000, wheeze = 36.8647, dyspnea = 4.67073),
                                            wheeze = c(cough = 9.39833, phlegm = 36.86470, wheeze = 107.09, dyspnea = 5.78527),
                                            dyspnea = c(cough = 1.04549, phlegm = 4.67073, wheeze = 5.78527, dyspnea = 5.1828))
  input_ref$symptoms$covariance_COPD <- "Kate's regression on CanCOLD, provided on 2019-05-22"


  ## Outpatient;

    # Primary care visits;
  input_help$outpatient$ln_rate_gpvisits_COPD_by_sex <- "Rate of GP visits for COPD patients"
  input$outpatient$ln_rate_gpvisits_COPD_by_sex <- cbind(male=c(intercept=0.4472, age=0.012, smoking=0.0669, fev1=-0.1414, cough=-0.0037,
                                                                phlegm=-0.0108, wheeze=0.0553, dyspnea=0.0947),
                                                         female=c(intercept=0.4472-0.0725, age=0.012, smoking=0.0669, fev1=-0.1414,
                                                                  cough=-0.0037, phlegm=-0.0108, wheeze=0.0553, dyspnea=0.0947))
  input$outpatient$dispersion_gpvisits_COPD <- 0.431
  input_ref$outpatient$ln_rate_gpvisits_COPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-29"

  input_help$outpatient$ln_rate_gpvisits_nonCOPD_by_sex <- "Rate of GP visits for Non-COPD patients"
  input$outpatient$ln_rate_gpvisits_nonCOPD_by_sex <-  cbind(male=c(intercept=-0.3596, age=0.0169, smoking=0.0722,  cough=0.181, phlegm=-0.0275,
                                                                    wheeze=0.2262, dyspnea=0.0807),
                                                             female=c(intercept=-0.3596+0.0095, age=0.0169, smoking=0.0722, cough=0.181,
                                                                      phlegm=-0.0275, wheeze=0.2262, dyspnea=0.0807))
  input_ref$outpatient$ln_rate_gpvisits_nonCOPD_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-29"
  input$outpatient$dispersion_gpvisits_nonCOPD <- 0.4093

    # Extras - DISABLED
  input$outpatient$rate_doctor_visit <- 0.1
  input$outpatient$p_specialist <- 0.1


  ## Case detection;

  input_help$diagnosis$p_case_detection <- "Probability of recieving case detection in each year given they meet the selection criteria"
  input$diagnosis$p_case_detection <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
  input_ref$diagnosis$p_case_detection <- "Only applies if case_detection_start_year less than time_horizon."

  input_help$diagnosis$case_detection_start_end_yrs <- "Years in which case detection programme is to begin and end, respectively."
  input$diagnosis$case_detection_start_end_yrs <- c(100,100)
  input_ref$diagnosis$case_detection_start_end_yrs <- "Acts as on on/off switch for case detection. Default is 100 i.e. case detection is off. To apply case detection, start year must be less than the time horizon. If case detection is to be administered for entire time horizon then start year would be zero and end year >= time horizon."

  # input$smoking$ln_h_ces_betas[["diagnosis"]] <-  input$smoking$ln_h_ces_betas[["diagnosis"]] * input$diagnosis$p_case_detection
  # Turns off and on the effect of diagnosis on smoking cessation

  input_help$diagnosis$years_btw_case_detection <- "Number of years between case detection"
  input$diagnosis$years_btw_case_detection <- 5
  input_ref$diagnosis$years_btw_case_detection <- ""

  input_help$diagnosis$min_cd_age <- "Minimum age for recieving case detection"
  input$diagnosis$min_cd_age <- 40
  input_ref$diagnosis$min_cd_age <- ""

  input_help$diagnosis$min_cd_pack_years <- "Minimum pack-years smoking to recieve case detection"
  input$diagnosis$min_cd_pack_years <- 0
  input_ref$diagnosis$min_cd_pack_years <- ""

  input_help$diagnosis$min_cd_symptoms <- "Set to 1 if only patients with symptoms should recieve case detection at baseline"
  input$diagnosis$min_cd_symptoms <- 0
  input_ref$diagnosis$min_cd_symptoms <- ""

  input_help$diagnosis$case_detection_methods <- "Sensitivity, specificity, and cost of case detection methods in the total population"
  input$diagnosis$case_detection_methods <- cbind(None=c(0, 0, 0),
                                                  CDQ17= c(4.1013, 4.394, 11.56),
                                                  FlowMeter= c(3.174, 1.6025, 30.46),
                                                  FlowMeter_CDQ= c(2.7321, 0.8779, 42.37))
  input_ref$diagnosis$case_detection_methods_eversmokers <- "Sichletidis et al 2011"

  input_help$diagnosis$case_detection_methods_eversmokers <- "Sensitivity, specificity, and cost of case detection methods among ever smokers"
  input$diagnosis$case_detection_methods_eversmokers <- cbind(None=c(0, 0, 0),
                                                              CDQ195= c(2.3848, 3.7262, 11.56),
                                                              CDQ165= c(3.7336, 4.8098, 11.56),
                                                              FlowMeter= c(3.1677, 2.6657, 24.33),
                                                              FlowMeter_CDQ= c(2.8545, 0.8779, 42.37))
  input_ref$diagnosis$case_detection_methods_eversmokers <- "Haroon et al. BMJ Open 2015"

  input_help$diagnosis$case_detection_methods_symptomatic <- "Sensitivity, specificity, and cost of case detection methods among ever smokers"
  input$diagnosis$case_detection_methods_symptomatic <- cbind(None=c(0, 0, 0),
                                                              FlowMeter= c(3.2705, 2.2735, 24.33))
  input_ref$diagnosis$case_detection_methods_symptomatic <- "CanCOLD analysed on Sept 9, 2019"



  ## Diagnosis;

  # Baseline diagnosis
  input_help$diagnosis$logit_p_prevalent_diagnosis_by_sex <- "Probability of being diagnosed for patients with prevalent COPD"
  input$diagnosis$logit_p_prevalent_diagnosis_by_sex <- cbind(male=c(intercept=1.0543, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                           cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                           case_detection=input$diagnosis$case_detection_methods[1,"None"]),
                                                    female=c(intercept=1.0543-0.1638, age=-0.0152, smoking=0.1068, fev1=-0.6146,
                                                             cough=0.075, phlegm=0.283, wheeze=-0.0275, dyspnea=0.5414,
                                                             case_detection=input$diagnosis$case_detection_methods[1,"None"]))
  input_ref$diagnosis$logit_p_prevalent_diagnosis_by_sex <- "Kate's regression on CanCOLD, provided on 2019-08-09"

  # Follow-up diagnosis
  input_help$diagnosis$logit_p_diagnosis_by_sex <- "Probability of being diagnosed for COPD patients"
  input$diagnosis$logit_p_diagnosis_by_sex <- cbind(male=c(intercept=-2, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                           gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                           case_detection=input$diagnosis$case_detection_methods[1,"None"]),
                                                    female=c(intercept=-2-0.4873, age=-0.0324, smoking=0.3711, fev1=-0.8032,
                                                             gpvisits=0.0087, cough=0.208, phlegm=0.4088, wheeze=0.0321, dyspnea=0.722,
                                                             case_detection=input$diagnosis$case_detection_methods[1,"None"]))
  input_ref$diagnosis$logit_p_diagnosis_by_sex <- "Kate's regression on CanCOLD, provided on 2019-05-29"
  input$diagnosis$p_hosp_diagnosis <- 1

  # Overdiagnosis

  input_help$diagnosis$logit_p_overdiagnosis_by_sex <- "Probability of being overdiagnosed for non-COPD subjects"
  input$diagnosis$logit_p_overdiagnosis_by_sex <- cbind(male=c(intercept=-5.2169, age=0.0025, smoking=0.6911, gpvisits=0.0075,
                                                               cough=0.7264, phlegm=0.7956, wheeze=0.66, dyspnea=0.8798,
                                                               case_detection=input$diagnosis$case_detection_methods[2,"None"]),
                                                    female=c(intercept=-5.2169+0.2597, age=0.0025, smoking=0.6911, gpvisits=0.0075,
                                                             cough=0.7264, phlegm=0.7956, wheeze=0.66, dyspnea=0.8798,
                                                             case_detection=input$diagnosis$case_detection_methods[2,"None"]))
  input_ref$diagnosis$logit_p_overdiagnosis_by_sex <- "Kate's regression on CanCOLD, provided on 2019-07-16"
  input$diagnosis$p_correct_overdiagnosis <- 0.5


  ## Medication;

  # adherence to medication
  input_help$medication$medication_adherence <- "Proportion adherent to medication"
  input$medication$medication_adherence <- 0.7
  input_ref$medication$medication_adherence <- ""

  # medication log-hazard regression matrix for rate reduction in exacerbations
  input_help$medication$medication_ln_hr_exac <- "Rate reduction in exacerbations due to treatment"
  input$medication$medication_ln_hr_exac<-c(input$medication$medication_ln_hr_exac<-c(None=0,
                                            SABA=0,
                                            LABA=log((1-0.20)^input$medication$medication_adherence),
                                            SABA_LABA=log((1-0.20)^input$medication$medication_adherence),
                                            LAMA=log((1-0.22)^input$medication$medication_adherence),
                                            LAMA_SABA=log((1-0.22)^input$medication$medication_adherence),
                                            LAMA_LABA=log((1-0.23)^input$medication$medication_adherence),
                                            LAMA_LABA_SABA=log((1-0.23)^input$medication$medication_adherence),
                                            ICS=log((1-0.19)^input$medication$medication_adherence),
                                            ICS_SABA=log((1-0.19)^input$medication$medication_adherence),
                                            ICS_LABA=log((1-0.25)^input$medication$medication_adherence),
                                            ICS_LABA_SABA=log((1-0.25)^input$medication$medication_adherence),
                                            ICS_LAMA=log((1-0.25)^input$medication$medication_adherence),
                                            ICS_LAMA_SABA=log((1-0.25)^input$medication$medication_adherence),
                                            ICS_LAMA_LABA=log((1-0.34)^input$medication$medication_adherence),
                                            ICS_LAMA_LABA_SABA=log((1-0.34)^input$medication$medication_adherence)))
  input_ref$medication$medication_ln_hr_exac <- "ICS/LABA: Annual Rate Ratio of Comibation Therapy (Salmeterol and Fluticasone Propionate) vs. Placebo from TORCH (doi: 10.1056/NEJMoa063070),
                                                 ICS: Annual Rate Ratio between Fluticasone vs. Placebo from TRISTAN Trial (doi:10.1016/S0140-6736(03)12459-2),
                                                 LABA: Annual Rate Ratio between Salmeterol vs. Placebo from TRISTAN Trial (doi:10.1016/S0140-6736(03)12459-2),
                                                 LAMA-Zhou et al. 2017, LAMA/LABA-UPLIFT 2008, ICS/LAMA/LABA-KRONOS 2018"

  # cost of medications
  input_help$medication$medication_costs <- "Costs of treatment"
  input$medication$medication_costs <-c(None=0,SABA=75.96*input$medication$medication_adherence, LABA=0, SABA_LABA=0,
                                        LAMA=504.66*input$medication$medication_adherence, LAMA_SABA=0,
                                        LAMA_LABA=923.06*input$medication$medication_adherence, LAMA_LAMA_SABA=0,
                                        ICS=0, ICS_SABA=0, ICS_LABA=0, ICS_LABA_SABA=0, ICS_LAMA=0, ICS_LAMA_SABA=0,
                                        ICS_LAMA_LABA=1631.81*input$medication$medication_adherence, ICS_LAMA_LABA_SABA=0)
  input_ref$medication$medication_costs <- "BC administrative data"

  # utility from medications
  input_help$medication$medication_utility <- "Utility addition from treatment"
  input$medication$medication_utility <-c(None=0,SABA=0.0367,LABA=0,SABA_LABA=0, LAMA=0.0367, LAMA_SABA=0, LAMA_LABA=0.0367,
                                        LAMA_LAMA_SABA=0, ICS=0, ICS_SABA=0, ICS_LABA=0, ICS_LABA_SABA=0, ICS_LAMA=0,
                                        ICS_LAMA_SABA=0, ICS_LAMA_LABA=0.0367, ICS_LAMA_LABA_SABA=0)
  input_ref$medication$medication_utility <- "Lambe et al. Thorax 2019"

  # medication event - disabled
  template = c(int = 0, sex = 0, age = 0, med_class = rep(0, length(medication_classes)))
  mx <- NULL
  for (i in medication_classes) mx <- rbind(mx, template)

  input$medication$ln_h_start_betas_by_class <- mx
  input$medication$ln_h_stop_betas_by_class <- mx
  input$medication$ln_rr_exac_by_class <- rep(log(1), length(medication_classes))  #TODO: update this to represent different medication effect


  ### comorbidity mi - not implemented
  input$comorbidity$logit_p_mi_betas_by_sex = cbind(male = c(intercept = -3000, age = 0.001, age2 = 0, pack_years = 0.01, smoking = 0.001,
                                                             calendar_time = 0, bmi = 0, gold = 0.05), female = c(intercept = -3000, age = 0.001, age2 = 0, pack_years = 0.01, smoking = 0.001,
                                                                                                                  calendar_time = 0, bmi = 0, gold = 0.05))
  input$comorbidity$ln_h_mi_betas_by_sex = cbind(male = c(intercept = -10000.748, age = 0.1133, age2 = -0.00044, pack_years = 0.01,
                                                          smoking = 0.70953, calendar_time = 0, bmi = 0.01, gold = 0.05, b_mi = 0.5, n_mi = 0), female = c(intercept = -30000, age = 0.001,
                                                                                                                                                           age2 = 0, pack_years = 0.01, smoking = 0.61868, calendar_time = 0, bmi = 0.01, gold = 0.05, b_mi = 0, n_mi = 0.01))
  input$comorbidity$p_mi_death <- 0.05


  #stroke - not implemented
  input$comorbidity$logit_p_stroke_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, b_mi=0, gold=0.05, b_mi=0, n_mi=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0)
  );
  input$comorbidity$ln_h_stroke_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0)
  );
  input$comorbidity$p_stroke_death<-0.18;


  #hf - not implemented
  input$comorbidity$logit_p_hf_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0)
  );
  input$comorbidity$ln_h_hf_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05,b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05,b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0)
  );


  ##cost and utility
  input$cost$bg_cost_by_stage=t(as.matrix(c(N=0, I=135*1.0528, II=330*1.0528, III=864*1.0528, IV=1178*1.0528)))
  input_help$cost$bg_cost_by_stage="Annual direct (NON-TREATMENT) maintenance costs for non-COPD and COPD by GOLD grades"
  #  input$cost$ind_bg_cost_by_stage=t(as.matrix(c(N=0, I=40, II=80, III=134, IV=134))) #TODO Not implemented in C yet.
  #  input_help$cost$ind_bg_cost_by_stage="Annual inddirect costs for non-COPD, and COPD by GOLD grades"
  input$cost$exac_dcost=t(as.matrix(c(mild=29*1.0528,moderate=726*1.0528,severe=9212*1.0528, verysevere=20170*1.0528)))
  input_help$cost$exac_dcost="Incremental direct costs of exacerbations by severity levels"

  input$cost$cost_case_detection <- input$diagnosis$case_detection_methods[3,"None"]
  input_help$cost$cost_case_detection <- "Cost of case detection"

  input$cost$cost_outpatient_diagnosis <- 61.18
  input_help$cost$cost_outpatient_diagnosis <- "Cost of diagnostic spirometry"

  input$cost$cost_gp_visit <- 35.27
  input_help$cost$cost_gp_visit <- "Cost of GP visit"

  input$cost$cost_smoking_cessation <- 368.76
  input_help$cost$cost_smoking_cessation <- "Cost of 12 weeks Nicotine Replacement Therapy from Mullen BMJ Tobacco Control 2014"


  #input$cost$doctor_visit_by_type<-t(as.matrix(c(50,150)))

  input$utility$bg_util_by_stage=t(as.matrix(c(N=0.86, I=0.81,II=0.72,III=0.68,IV=0.58)))
  input_help$utility$bg_util_by_stage="Background utilities for non-COPD, and COPD by GOLD grades"
  #  input$utility$exac_dutil=t(as.matrix(c(mild=-0.07, moderate=-0.37/2, severe=-0.3)))

  input$utility$exac_dutil=cbind(
    gold1=c(mild=-0.0225, moderate=-0.0225, severe=-0.0728, verysevere=-0.0728),
    gold2=c(mild=-0.0155, moderate=-0.0155, severe=-0.0683, verysevere=-0.0683),
    gold3=c(mild=-0.0488, moderate=-0.0488, severe=-0.0655, verysevere=-0.0655),
    gold4=c(mild=-0.0488, moderate=-0.0488, severe=-0.0655, verysevere=-0.0655)
  );
  input_help$utility$exac_dutil="Incremental change in utility during exacerbations by severity level"


  input$manual$MORT_COEFF<-1
  input$manual$smoking$intercept_k<-1


  #Proportion of death by COPD that should be REMOVED from background mortality
  input$manual$explicit_mortality_by_age_sex<-cbind(
    #   0 for <35         35-39           40-44           45-49          50-54      55-59           60-64        65-69          70-74       75-79       80+
    male =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.000403539,-0.000146157,-2.02E-06,2.86E-05,-3.44E-05,-4.23E-05,4.11E-05,6.17E-07,-0.000153637,-8.66E-05,-0.000164969,-0.000196571,-0.000187843,-0.000258444,-0.000313082,-0.000450107,-0.000503461,-0.000507455,-0.000685443,-0.000778368,0.000174258,0.001290859,0.001312415,0.001563206,0.001702653,0.001801797,0.001963438,0.002204392,0.002453385,0.002698432,0.002205324,0.0014888,0.001848938,0.001817781,0.002134294,0.002514315,0.00259607,0.003111937,0.003895328,0.004266737,0.003600876,0.002149508,0.003656,0.003476187,0.004743609,0.005217777,0.00717833,0.009193578,0.011745021,0.013994564,0.016918953,0.01972724,0.024327132,0.029473222,0.0333568,0.034382221,0.043683632,0.046918264,0.05015422,0.056785037,0.067912998,0.089136952,0.084619065,0.087049684,0.071382935,0.113123173,0.056760747,0.131580432,0.102958338,0.121878112,-0.173197386,-1
            )
    ,female =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.000259844,0.000101718,-3.40E-05,5.93E-05,8.02E-05,-1.50E-05,5.27E-05,-3.42E-05,-2.48E-05,-1.31E-05,-8.41E-05,-6.79E-05,-5.84E-05,-0.00019066,-0.000102213,-0.000117037,-0.000177858,-0.000220223,-0.000265341,-0.000330637,0.000229625,0.000747219,0.000783642,0.000885681,0.001036908,0.001221667,0.001263684,0.001488539,0.001609789,0.001895704,0.001446215,0.001285518,0.001500222,0.001575942,0.001798989,0.001964052,0.002175782,0.002460083,0.002847027,0.003243588,0.002699441,0.002155372,0.002928563,0.003010949,0.003689935,0.004178407,0.00548861,0.006334125,0.008011011,0.009087395,0.011673741,0.012943067,0.017208392,0.018224239,0.022955536,0.026702058,0.030114256,0.035733502,0.03965046,0.047085019,0.052203521,0.058999658,0.070092134,0.068989349,0.05458069,0.074344634,0.05941906,0.105553297,0.050910243,0.136369534,-0.107299339,-1    ))

  #  input$manual$explicit_mortality_by_age_sex <- input$manual$explicit_mortality_by_age_sex * 1000000000000

  #input$project_specific$ROC16_biomarker_threshold<-1
  #input_help$project_specific$ROC16_biomarker_threshold<-"Threshold on the biomarker value that prompts treatment"
  #input$project_specific$ROC16_biomarker_noise_sd<-0
  #input_help$project_specific$ROC16_biomarker_noise_sd<-"SD of the multiplicative log-normally distirbuted noise arround the actual exacerbation rate - this noise is added to make the biomarker 'imperfect'"
  #input$project_specific$ROC16_biomarker_cost<-100
  #input_help$project_specific$ROC16_biomarker_cost<-"Cost of the biomarker (per patient)"
  #input$project_specific$ROC16_treatment_cost<-4000
  #input_help$project_specific$ROC16_treatment_cost<-"Cost of treatment that will reduce the exacerbation rate"
  #input$project_specific$ROC16_treatment_RR<-0.75
  #input_help$project_specific$ROC16_treatment_RR<-"Treatment effect (relative risk of future exacerbations after treatment is initiated"

  # Replace remaining parameters with config values
  
  # Smoking parameters
  if (exists("smoking", config)) {
    input$smoking$logit_p_current_smoker_0_betas <- t(as.matrix(convert_config_value(config$smoking$logit_p_current_smoker_0_betas)))
    input$smoking$logit_p_never_smoker_con_not_current_0_betas <- t(as.matrix(convert_config_value(config$smoking$logit_p_never_smoker_con_not_current_0_betas)))
    input$smoking$minimum_smoking_prevalence <- convert_config_value(config$smoking$minimum_smoking_prevalence)
    input$smoking$mortality_factor_current <- t(as.matrix(convert_config_value(config$smoking$mortality_factor_current)))
    input$smoking$mortality_factor_former <- t(as.matrix(convert_config_value(config$smoking$mortality_factor_former)))
    input$smoking$pack_years_0_betas <- t(as.matrix(convert_config_value(config$smoking$pack_years_0_betas)))
    input$smoking$pack_years_0_sd <- convert_config_value(config$smoking$pack_years_0_sd)
    input$smoking$ln_h_inc_betas <- convert_config_value(config$smoking$ln_h_inc_betas)
    input$smoking$ln_h_ces_betas <- convert_config_value(config$smoking$ln_h_ces_betas)
    input$smoking$smoking_ces_coefficient <- convert_config_value(config$smoking$smoking_ces_coefficient)
    input$smoking$smoking_cessation_adherence <- convert_config_value(config$smoking$smoking_cessation_adherence)
  }
  
  # COPD parameters
  if (exists("COPD", config)) {
    input$COPD$logit_p_COPD_betas_by_sex <- create_matrix_from_config(config$COPD$logit_p_COPD_betas_by_sex, transpose = FALSE)
    input$COPD$ln_h_COPD_betas_by_sex <- create_matrix_from_config(config$COPD$ln_h_COPD_betas_by_sex, transpose = FALSE)
  }
  
  # Lung function parameters
  if (exists("lung_function", config)) {
    input$lung_function$fev1_0_prev_betas_by_sex <- create_matrix_from_config(config$lung_function$fev1_0_prev_betas_by_sex, transpose = FALSE)
    input$lung_function$fev1_0_prev_sd_by_sex <- convert_config_value(config$lung_function$fev1_0_prev_sd_by_sex)
    input$lung_function$fev1_0_inc_betas_by_sex <- create_matrix_from_config(config$lung_function$fev1_0_inc_betas_by_sex, transpose = FALSE)
    input$lung_function$fev1_0_inc_sd_by_sex <- convert_config_value(config$lung_function$fev1_0_inc_sd_by_sex)
    input$lung_function$fev1_0_ZafarCMAJ_by_sex <- create_matrix_from_config(config$lung_function$fev1_0_ZafarCMAJ_by_sex, transpose = FALSE)
    input$lung_function$pred_fev1_betas_by_sex <- create_matrix_from_config(config$lung_function$pred_fev1_betas_by_sex, transpose = FALSE)
    input$lung_function$fev1_betas_by_sex <- create_matrix_from_config(config$lung_function$fev1_betas_by_sex, transpose = FALSE)
    input$lung_function$dfev1_sigmas <- t(as.matrix(convert_config_value(config$lung_function$dfev1_sigmas)))
    input$lung_function$dfev1_re_rho <- convert_config_value(config$lung_function$dfev1_re_rho)
  }
  
  # Exacerbation parameters
  if (exists("exacerbation", config)) {
    input$exacerbation$ln_rate_betas <- t(as.matrix(convert_config_value(config$exacerbation$ln_rate_betas)))
    input$exacerbation$ln_rate_intercept_sd <- convert_config_value(config$exacerbation$ln_rate_intercept_sd)
    input$exacerbation$logit_severity_betas <- t(as.matrix(convert_config_value(config$exacerbation$logit_severity_betas)))
    input$exacerbation$logit_severity_intercept_sd <- convert_config_value(config$exacerbation$logit_severity_intercept_sd)
    input$exacerbation$rate_severity_intercept_rho <- convert_config_value(config$exacerbation$rate_severity_intercept_rho)
    input$exacerbation$exac_end_rate <- t(as.matrix(convert_config_value(config$exacerbation$exac_end_rate)))
    input$exacerbation$logit_p_death_by_sex <- create_matrix_from_config(config$exacerbation$logit_p_death_by_sex, transpose = FALSE)
  }
  
  # Cost and utility parameters
  if (exists("cost", config)) {
    input$cost$bg_cost_by_stage <- t(as.matrix(convert_config_value(config$cost$bg_cost_by_stage)))
    input$cost$exac_dcost <- t(as.matrix(convert_config_value(config$cost$exac_dcost)))
    input$cost$cost_case_detection <- convert_config_value(config$cost$cost_case_detection)
    input$cost$cost_outpatient_diagnosis <- convert_config_value(config$cost$cost_outpatient_diagnosis)
    input$cost$cost_gp_visit <- convert_config_value(config$cost$cost_gp_visit)
    input$cost$cost_smoking_cessation <- convert_config_value(config$cost$cost_smoking_cessation)
  }
  
  if (exists("utility", config)) {
    input$utility$bg_util_by_stage <- t(as.matrix(convert_config_value(config$utility$bg_util_by_stage)))
    if (is.list(config$utility$exac_dutil)) {
      input$utility$exac_dutil <- do.call(cbind, lapply(config$utility$exac_dutil, function(x) convert_config_value(x)))
    }
  }
  
  # Manual parameters
  if (exists("manual", config)) {
    input$manual$MORT_COEFF <- convert_config_value(config$manual$MORT_COEFF)
    input$manual$smoking$intercept_k <- convert_config_value(config$manual$smoking_intercept_k)
    input$manual$explicit_mortality_by_age_sex <- create_matrix_from_config(config$manual$explicit_mortality_by_age_sex, transpose = FALSE)
  }

  model_input <- list ("values" = input, "help" = input_help, "ref" = input_ref, "config" = config)
  return (model_input)
}

# Default model input for backward compatibility (only when config file exists)
if (file.exists(system.file("config", "config_canada.json", package = "epicR")) || 
    file.exists("inst/config/config_canada.json")) {
  model_input <- get_input()
}
