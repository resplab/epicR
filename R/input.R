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
  # First check user's config directory
  user_config_file <- file.path(Sys.getenv("HOME"), ".epicR", "config",
                                paste0("config_", jurisdiction, ".json"))

  if (file.exists(user_config_file)) {
    config_file <- user_config_file
    if (interactive()) {
      message(paste("Using user config file from:", config_file))
    }
  } else {
    # Fall back to package config
    config_file <- system.file("config", paste0("config_", jurisdiction, ".json"), package = "epicR")

    # If package not installed, try development mode path
    if (!file.exists(config_file) || config_file == "") {
      config_file <- file.path("inst", "config", paste0("config_", jurisdiction, ".json"))
    }

    if (file.exists(config_file) && interactive()) {
      message(paste("Using package config file from:", config_file))
    }
  }

  if (!file.exists(config_file)) {
    stop(paste("Configuration file for jurisdiction", jurisdiction, "not found.",
               "\nTry running copy_configs_to_user() to set up user configs."))
  }

  # Store config file path and modification time in session environment
  if (exists("session_env")) {
    session_env$config_file_path <- config_file
    session_env$config_file_mtime <- file.info(config_file)$mtime
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
  
  # Helper function to get metadata from config with fallback
  get_metadata <- function(section_name, param_name, type = "help", fallback = "") {
    metadata_key <- paste0(param_name, "_metadata")
    if (exists(section_name, config) && exists(metadata_key, config[[section_name]])) {
      metadata <- config[[section_name]][[metadata_key]]
      if (exists(type, metadata)) {
        result <- metadata[[type]]
        # Handle dynamic references that include jurisdiction
        if (type == "ref" && is.character(result) && grepl("canada", result, fixed = TRUE) && config$jurisdiction != "canada") {
          result <- gsub("canada", config$jurisdiction, result, fixed = TRUE)
        }
        return(result)
      }
    }
    return(fallback)
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
  input_help$global_parameters <- list(age0 = get_metadata("global_parameters", "age0", "help", "Starting age in the model"),
                                       time_horizon = get_metadata("global_parameters", "time_horizon", "help", "Model time horizon"),
                                       discount_cost = get_metadata("global_parameters", "discount_cost", "help", "Discounting for cost outcomes"),
                                       discount_qaly = get_metadata("global_parameters", "discount_qaly", "help", "Discounting for QALY outcomes"), 
                                       closed_cohort = get_metadata("global_parameters", "closed_cohort", "help", "Whether the model should run as closed_cohort, open-population by default"))



  input_help$agent$p_female <- get_metadata("agent", "p_female", "help", "Proportion of females in the population")
  input$agent$p_female <- convert_config_value(config$agent$p_female)
  input_ref$agent$p_female <- get_metadata("agent", "p_female", "ref", "Model assumption")


  input_help$agent$height_0_betas <- get_metadata("agent", "height_0_betas", "help", "Regression coefficients for estimating height (in meters) at baseline")
  input$agent$height_0_betas <- t(as.matrix(convert_config_value(config$agent$height_0_betas)))
  input_ref$agent$height_0_betas <- get_metadata("agent", "height_0_betas", "ref", "")


  input_help$agent$height_0_sd <- get_metadata("agent", "height_0_sd", "help", "SD representing heterogeneity in baseline height")
  input$agent$height_0_sd <- convert_config_value(config$agent$height_0_sd)
  input_ref$agent$height_0_sd <- get_metadata("agent", "height_0_sd", "ref", "")


  input_help$agent$weight_0_betas <- get_metadata("agent", "weight_0_betas", "help", "Regression coefficients for estimating weight (in Kg) at baseline")
  input$agent$weight_0_betas <- t(as.matrix(convert_config_value(config$agent$weight_0_betas)))
  input_ref$agent$weight_0_betas <- get_metadata("agent", "weight_0_betas", "ref", "")


  input_help$agent$weight_0_sd <- get_metadata("agent", "weight_0_sd", "help", "SD representing heterogeneity in baseline weight")
  input$agent$weight_0_sd <- convert_config_value(config$agent$weight_0_sd)
  input_ref$agent$weight_0_sd <- get_metadata("agent", "weight_0_sd", "ref", "")


  input_help$agent$height_weight_rho <- get_metadata("agent", "height_weight_rho", "help", "Correlation coefficient between weight and height at baseline")
  input$agent$height_weight_rho <- convert_config_value(config$agent$height_weight_rho)
  input_ref$agent$height_weight_rho <- get_metadata("agent", "height_weight_rho", "ref", "")

  input_help$agent$p_prevalence_age <- get_metadata("agent", "p_prevalence_age", "help", "Age pyramid at baseline")
  input$agent$p_prevalence_age <- convert_config_value(config$agent$p_prevalence_age)
  input$agent$p_prevalence_age <- input$agent$p_prevalence_age/sum(input$agent$p_prevalence_age)
  input_ref$agent$p_prevalence_age <- get_metadata("agent", "p_prevalence_age", "ref", paste("From config for", config$jurisdiction))


  input_help$agent$p_incidence_age <- get_metadata("agent", "p_incidence_age", "help", "Discrete distribution of age for the incidence population (population arriving after the first date) - generally estimated through calibration")
  if (config$agent$p_incidence_age == "calculated") {
    input$agent$p_incidence_age <- c(rep(0, 40), c(1), 0.02* exp(-(0:59)/5), rep(0, 111 - 40 - 1 - 60))
    input$agent$p_incidence_age <- input$agent$p_incidence_age/sum(input$agent$p_incidence_age)
  } else {
    input$agent$p_incidence_age <- convert_config_value(config$agent$p_incidence_age)
    input$agent$p_incidence_age <- input$agent$p_incidence_age/sum(input$agent$p_incidence_age)
  }
  input_ref$agent$p_incidence_age <- get_metadata("agent", "p_incidence_age", "ref", "")


  input_help$agent$p_bgd_by_sex <- get_metadata("agent", "p_bgd_by_sex", "help", "Life table")
  input$agent$p_bgd_by_sex <- create_matrix_from_config(config$agent$p_bgd_by_sex, transpose = FALSE)
  input_ref$agent$p_bgd_by_sex <- get_metadata("agent", "p_bgd_by_sex", "ref", paste("Life table for", config$jurisdiction))


  input_help$agent$l_inc_betas <- get_metadata("agent", "l_inc_betas", "help", "Ln of incidence rate of the new population - Calibration target to keep populatoin size and age pyramid in line with calibration")
  l_inc_config <- convert_config_value(config$agent$l_inc_betas)
  l_inc_config[1] <- l_inc_config[1] - input$global_parameters$closed_cohort*100  # adjust intercept for closed cohort
  input$agent$l_inc_betas <- t(as.matrix(l_inc_config))
  input_ref$agent$l_inc_betas <- get_metadata("agent", "l_inc_betas", "ref", "If closed cohort is enabled, incidence population will be turned off.")


  input_help$agent$ln_h_bgd_betas <- get_metadata("agent", "ln_h_bgd_betas", "help", "Increased Longevity Over time and effect of other variables")
  input$agent$ln_h_bgd_betas <- t(as.matrix(convert_config_value(config$agent$ln_h_bgd_betas)))
  input_ref$agent$ln_h_bgd_betas <- get_metadata("agent", "ln_h_bgd_betas", "ref", "")

  ### smoking;

  input_help$smoking$logit_p_current_smoker_0_betas <- get_metadata("smoking", "logit_p_current_smoker_0_betas", "help", "Probability of being a current smoker at the time of creation")
  input$smoking$logit_p_current_smoker_0_betas <- t(as.matrix(convert_config_value(config$smoking$logit_p_current_smoker_0_betas)))
  input_ref$smoking$logit_p_current_smoker_0_betas <- get_metadata("smoking", "logit_p_current_smoker_0_betas", "ref", "")

  input_help$smoking$logit_p_never_smoker_con_not_current_0_betas <- get_metadata("smoking", "logit_p_never_smoker_con_not_current_0_betas", "help", "Probability of being a never-smoker conditional on not being current smoker, at the time of creation")
  input$smoking$logit_p_never_smoker_con_not_current_0_betas <- t(as.matrix(convert_config_value(config$smoking$logit_p_never_smoker_con_not_current_0_betas)))
  input_ref$smoking$logit_p_never_smoker_con_not_current_0_betas <- get_metadata("smoking", "logit_p_never_smoker_con_not_current_0_betas", "ref", "")


  input_help$smoking$minimum_smoking_prevalence <- get_metadata("smoking", "minimum_smoking_prevalence", "help", "Minimum Smoking Prevalence")
  input$smoking$minimum_smoking_prevalence <- convert_config_value(config$smoking$minimum_smoking_prevalence)
  input_ref$smoking$minimum_smoking_prevalence <- get_metadata("smoking", "minimum_smoking_prevalence", "ref", "")


  #input_help$smoking$mortality_factor_current <- "Mortality ratio for current smokers vs. non-smokers"
  #input$smoking$mortality_factor_current <- 1.83  #1.83
  #input_ref$smoking$mortality_factor_current <- "Meta-analysis. doi:10.1001/archinternmed.2012.1397"

  #input_help$smoking$mortality_factor_former <- "Mortality ratio for former smokers vs. non-smokers"
  #input$smoking$mortality_factor_former <- 1.34  #1.34
  #input_ref$smoking$mortality_factor_former <- "Meta-analysis. doi:10.1001/archinternmed.2012.1397"

  input_help$smoking$mortality_factor_current <- get_metadata("smoking", "mortality_factor_current", "help", "Mortality ratio for current smokers vs. non-smokers by sex and age group")
  input$smoking$mortality_factor_current <- t(as.matrix(convert_config_value(config$smoking$mortality_factor_current)))
  input_ref$smoking$mortality_factor_current <- get_metadata("smoking", "mortality_factor_current", "ref", "Meta-analysis. doi:10.1001/archinternmed.2012.1397")

  input_help$smoking$mortality_factor_former <- get_metadata("smoking", "mortality_factor_former", "help", "Mortality ratio for former smokers vs. non-smokers by sex and age group")
  input$smoking$mortality_factor_former <- t(as.matrix(convert_config_value(config$smoking$mortality_factor_former)))
  input_ref$smoking$mortality_factor_former <- get_metadata("smoking", "mortality_factor_former", "ref", "Meta-analysis. doi:10.1001/archinternmed.2012.1397")


  input_help$smoking$pack_years_0_betas <- get_metadata("smoking", "pack_years_0_betas", "help", "Regression equations for determining the pack-years of smoking at the time of creation (for smokers)")
  input$smoking$pack_years_0_betas <- t(as.matrix(convert_config_value(config$smoking$pack_years_0_betas)))
  input_ref$smoking$pack_years_0_betas <- get_metadata("smoking", "pack_years_0_betas", "ref", "")


  input_help$smoking$pack_years_0_sd <- get_metadata("smoking", "pack_years_0_sd", "help", "Standard deviation for variation in pack-years among individuals (current or former smokers)")
  input$smoking$pack_years_0_sd <- convert_config_value(config$smoking$pack_years_0_sd)
  input_ref$smoking$pack_years_0_sd <- get_metadata("smoking", "pack_years_0_sd", "ref", "")


  input_help$smoking$ln_h_inc_betas <- get_metadata("smoking", "ln_h_inc_betas", "help", "Log-hazard of starting smoking (incidence or relapse)")
  input$smoking$ln_h_inc_betas <- convert_config_value(config$smoking$ln_h_inc_betas)
  input_ref$smoking$ln_h_inc_betas <- get_metadata("smoking", "ln_h_inc_betas", "ref", "")


  input_help$smoking$ln_h_ces_betas <- get_metadata("smoking", "ln_h_ces_betas", "help", "Log-hazard of smoking cessation")
  input$smoking$ln_h_ces_betas <- convert_config_value(config$smoking$ln_h_ces_betas)
  input_ref$smoking$ln_h_ces_betas <- get_metadata("smoking", "ln_h_ces_betas", "ref", "Diagnosis coefficient from Wu et al. BMC Public Health 2006")

  input_help$smoking$smoking_ces_coefficient <- get_metadata("smoking", "smoking_ces_coefficient", "help", "Coefficient for the decay rate of smoking cessaton treatment, default is 100")
  input$smoking$smoking_ces_coefficient <- convert_config_value(config$smoking$smoking_ces_coefficient)
  input_ref$smoking$smoking_ces_coefficient <- get_metadata("smoking", "smoking_ces_coefficient", "ref", "")

  input_help$smoking$smoking_cessation_adherence <- get_metadata("smoking", "smoking_cessation_adherence", "help", "Proportion adherent to smoking cessation treatment")
  input$smoking$smoking_cessation_adherence <- convert_config_value(config$smoking$smoking_cessation_adherence)
  input_ref$smoking$smoking_cessation_adherence <- get_metadata("smoking", "smoking_cessation_adherence", "ref", "")


  ## COPD
  input_help$COPD$logit_p_COPD_betas_by_sex <- get_metadata("COPD", "logit_p_COPD_betas_by_sex", "help", "Logit of the probability of having COPD (FEV1/FVC<0.7) at time of creation (separately by sex)")
  input$COPD$logit_p_COPD_betas_by_sex <- create_matrix_from_config(config$COPD$logit_p_COPD_betas_by_sex, transpose = FALSE)
  input_ref$COPD$logit_p_COPD_betas_by_sex <- get_metadata("COPD", "logit_p_COPD_betas_by_sex", "ref", "CanCold - Shahzad's Derivation. Last Updated on 2017-09-19, ne wmodel with no currnet smoker term")


  input_help$COPD$ln_h_COPD_betas_by_sex <- get_metadata("COPD", "ln_h_COPD_betas_by_sex", "help", "Log-hazard of developing COPD (FEV1/FVC<LLN) for those who did not have COPD at creation time (separately by sex)")
  input$COPD$ln_h_COPD_betas_by_sex <- create_matrix_from_config(config$COPD$ln_h_COPD_betas_by_sex, transpose = FALSE)
  input_ref$COPD$ln_h_COPD_betas_by_sex <- get_metadata("COPD", "ln_h_COPD_betas_by_sex", "ref", "Amin's Iterative solution. Last Updated on 2022-06-33 (0.29.0)")


  ## Lung function
  input_help$lung_function$fev1_0_prev_betas_by_sex <- get_metadata("lung_function", "fev1_0_prev_betas_by_sex", "help", "Regression (OLS) coefficients for mean of FEV1 at time of creation for those with COPD (separately by sex)")
  input$lung_function$fev1_0_prev_betas_by_sex <- create_matrix_from_config(config$lung_function$fev1_0_prev_betas_by_sex, transpose = FALSE)
  input_ref$lung_function$fev1_0_prev_betas_by_sex <- get_metadata("lung_function", "fev1_0_prev_betas_by_sex", "ref", "for LLN based on Shahzad's calculations. Last Updated on 2017-04-19. See https://github.com/aminadibi/epicR/issues/8")


  input_help$lung_function$fev1_0_prev_sd_by_sex <- get_metadata("lung_function", "fev1_0_prev_sd_by_sex", "help", "SD of FEV1 at time of creation for those with COPD (separately by sex)")
  input$lung_function$fev1_0_prev_sd_by_sex <- convert_config_value(config$lung_function$fev1_0_prev_sd_by_sex)
  input_ref$lung_function$fev1_0_prev_sd_by_sex <- get_metadata("lung_function", "fev1_0_prev_sd_by_sex", "ref", "")


  input_help$lung_function$fev1_0_inc_betas_by_sex <- get_metadata("lung_function", "fev1_0_inc_betas_by_sex", "help", "Regression (OLS) coefficients for mean of FEV1 at time of development of COPD(separately by sex)")
  input$lung_function$fev1_0_inc_betas_by_sex <- create_matrix_from_config(config$lung_function$fev1_0_inc_betas_by_sex, transpose = FALSE)
  input_ref$lung_function$fev1_0_inc_betas_by_sex <- get_metadata("lung_function", "fev1_0_inc_betas_by_sex", "ref", "for LLN based on Shahzad's calculations. Last Updated on 2017-04-19. See https://github.com/aminadibi/epicR/issues/8")


  input_help$lung_function$fev1_0_inc_sd_by_sex <- get_metadata("lung_function", "fev1_0_inc_sd_by_sex", "help", "SD of FEV1 at time of development of COPD (separately by sex)")
  input$lung_function$fev1_0_inc_sd_by_sex <- convert_config_value(config$lung_function$fev1_0_inc_sd_by_sex)
  input_ref$lung_function$fev1_0_inc_sd_by_sex <- get_metadata("lung_function", "fev1_0_inc_sd_by_sex", "ref", "")


  input_help$lung_function$fev1_0_ZafarCMAJ_by_sex <- get_metadata("lung_function", "fev1_0_ZafarCMAJ_by_sex", "help", "Regression coefficients for mean of FEV1 at time of creation with COPD or development of COPD based on Zafar's CMAJ. Used for conditional normal distribution in FEV1 decline equations.  (separately by sex)")
  input$lung_function$fev1_0_ZafarCMAJ_by_sex <- create_matrix_from_config(config$lung_function$fev1_0_ZafarCMAJ_by_sex, transpose = FALSE)
  input_ref$lung_function$fev1_0_ZafarCMAJ_by_sex <- get_metadata("lung_function", "fev1_0_ZafarCMAJ_by_sex", "ref", "Zafari Z, Sin DD, Postma DS, Lofdahl CG, Vonk J, Bryan S, Lam S, Tammemagi CM, Khakban R, Man SP, Tashkin D. Individualized prediction of lung-function decline in chronic obstructive pulmonary disease. Canadian Medical Association Journal. 2016 Oct 4;188(14):1004-11.")


  # NHANES:
  # input$lung_function$pred_fev1_betas_by_sex<-rbind(c(intercept=-0.7453,age=-0.04106,age2=0.004477,height2=0.00014098),c(-0.871,0.06537,0,0.00011496))

  input_help$lung_function$pred_fev1_betas_by_sex <- get_metadata("lung_function", "pred_fev1_betas_by_sex", "help", "Coefficients for calculation of predicted FEV1 based on individual characteristics")
  input$lung_function$pred_fev1_betas_by_sex <- create_matrix_from_config(config$lung_function$pred_fev1_betas_by_sex, transpose = FALSE)
  input_ref$lung_function$pred_fev1_betas_by_sex <- get_metadata("lung_function", "pred_fev1_betas_by_sex", "ref", "")



   input_help$lung_function$dfev1_betas <- get_metadata("lung_function", "fev1_betas_by_sex", "help", "Regression equations (mixed-effects model) for rate of FEV1 decline")
     input$lung_function$fev1_betas_by_sex <- create_matrix_from_config(config$lung_function$fev1_betas_by_sex, transpose = FALSE)
     input_ref$lung_function$dfev1_betas <- get_metadata("lung_function", "fev1_betas_by_sex", "ref", "")

  # input$lung_function$fev1_betas_by_sex <- cbind(male = c(intercept = -0.1543 , baseline_age = 0, baseline_weight_kg = 0,
  #                                                         height = 0, height_sq = 0, current_smoker = 0, age_height_sq = 0, followup_time = 0),
  #                                                female = c(intercept = -0.1543  , baseline_age =0, baseline_weight_kg = 0,
  #                                                           height = 0, height_sq =0, current_smoker = 0, age_height_sq = 0, followup_time = 0))
  input_ref$lung_function$dfev1_betas <- get_metadata("lung_function", "fev1_betas_by_sex", "ref", "")

  input_help$lung_function$dfev1_sigmas <- get_metadata("lung_function", "dfev1_sigmas", "help", "Sigmas in G Matrix for FEV1 decline")
  input$lung_function$dfev1_sigmas <- t(as.matrix(convert_config_value(config$lung_function$dfev1_sigmas)))
  input_ref$lung_function$dfev1_sigmas <- get_metadata("lung_function", "dfev1_sigmas", "ref", "")


  input_help$lung_function$dfev1_re_rho <- get_metadata("lung_function", "dfev1_re_rho", "help", "Correlation coefficient between random-effect terms in the mixed-effects model of FEV1 decline")
  input$lung_function$dfev1_re_rho <- convert_config_value(config$lung_function$dfev1_re_rho)
  input_ref$lung_function$dfev1_re_rho <- get_metadata("lung_function", "dfev1_re_rho", "ref", "G Matrix Zafari CMAJ 2016 - Modified")


  ## Exacerbation;

  input_help$exacerbation$ln_rate_betas = get_metadata("exacerbation", "ln_rate_betas", "help", "Regression coefficients for the random-effects log-hazard model of exacerbation (of any severity)")
  input$exacerbation$ln_rate_betas <- t(as.matrix(convert_config_value(config$exacerbation$ln_rate_betas)))
  input_ref$exacerbation$ln_rate_betas = get_metadata("exacerbation", "ln_rate_betas", "ref", "Rates from DOI: 10.2147/COPD.S13826, adjusted to account for diganosis bias. Adjusted on 2018-10-02 to match manuscript. Recalibrated on 2022-11-04, see validate_exacerbations()")

  input_help$exacerbation$ln_rate_intercept_sd = get_metadata("exacerbation", "ln_rate_intercept_sd", "help", "SD of the random intercept for log-hazard of exacerbation")
  input$exacerbation$ln_rate_intercept_sd = convert_config_value(config$exacerbation$ln_rate_intercept_sd)
  input_ref$exacerbation$ln_rate_intercept_sd = get_metadata("exacerbation", "ln_rate_intercept_sd", "ref", "")


  input_help$exacerbation$logit_severity_betas = get_metadata("exacerbation", "logit_severity_betas", "help", "Regression coefficients for the proportional odds model of exacerbation severity")
  input$exacerbation$logit_severity_betas = t(as.matrix(convert_config_value(config$exacerbation$logit_severity_betas)))
  input_ref$exacerbation$logit_severity_betas = get_metadata("exacerbation", "logit_severity_betas", "ref", "Shahzad's regression on MACRO with adjusted intercepts to match severity levels reported by Hoogendoorn et al. Last updated on manuscript submission")


  input_help$exacerbation$logit_severity_intercept_sd = get_metadata("exacerbation", "logit_severity_intercept_sd", "help", "SD of the random intercept for proportional odds model of exacerbation severity")
  input$exacerbation$logit_severity_intercept_sd = convert_config_value(config$exacerbation$logit_severity_intercept_sd)
  input_ref$exacerbation$logit_severity_intercept_sd = get_metadata("exacerbation", "logit_severity_intercept_sd", "ref", "")


  input_help$exacerbation$rate_severity_intercept_rho = get_metadata("exacerbation", "rate_severity_intercept_rho", "help", "Correlation coefficient between the random effect terms of rate and severity")
  input$exacerbation$rate_severity_intercept_rho = convert_config_value(config$exacerbation$rate_severity_intercept_rho)
  input_ref$exacerbation$rate_severity_intercept_rho = get_metadata("exacerbation", "rate_severity_intercept_rho", "ref", "")


  input_help$exacerbation$exac_end_rate <- get_metadata("exacerbation", "exac_end_rate", "help", "Rate of ending of an exacerbation (inversely realted to exacerbation duration) according to severity level")
  input$exacerbation$exac_end_rate <- t(as.matrix(convert_config_value(config$exacerbation$exac_end_rate)))
  input_ref$exacerbation$exac_end_rate <- get_metadata("exacerbation", "exac_end_rate", "ref", "")

  input_help$exacerbation$logit_p_death_by_sex <- get_metadata("exacerbation", "logit_p_death_by_sex", "help", "Probability of death due to exacerbation according to its severity level")
  input$exacerbation$logit_p_death_by_sex <- create_matrix_from_config(config$exacerbation$logit_p_death_by_sex, transpose = FALSE)
  input_ref$exacerbation$logit_p_death_by_sex <- get_metadata("exacerbation", "logit_p_death_by_sex", "ref", "")

  ## Symptoms;

  # cough;
  input_help$symptoms$logit_p_cough_COPD_by_sex <- get_metadata("symptoms", "logit_p_cough_COPD_by_sex", "help", "Probability of having cough for COPD patients")
  input$symptoms$logit_p_cough_COPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_cough_COPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_cough_COPD_by_sex <- get_metadata("symptoms", "logit_p_cough_COPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  input_help$symptoms$logit_p_cough_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_cough_nonCOPD_by_sex", "help", "Probability of having cough for non-COPD patients")
  input$symptoms$logit_p_cough_nonCOPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_cough_nonCOPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_cough_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_cough_nonCOPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  # phlegm;
  input_help$symptoms$logit_p_phlegm_COPD_by_sex <- get_metadata("symptoms", "logit_p_phlegm_COPD_by_sex", "help", "Probability of having phlegm for COPD patients")
  input$symptoms$logit_p_phlegm_COPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_phlegm_COPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_phlegm_COPD_by_sex <- get_metadata("symptoms", "logit_p_phlegm_COPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  input_help$symptoms$logit_p_phlegm_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_phlegm_nonCOPD_by_sex", "help", "Probability of having phlegm for non-COPD patients")
  input$symptoms$logit_p_phlegm_nonCOPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_phlegm_nonCOPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_phlegm_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_phlegm_nonCOPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  # dyspnea;
  input_help$symptoms$logit_p_dyspnea_COPD_by_sex <- get_metadata("symptoms", "logit_p_dyspnea_COPD_by_sex", "help", "Probability of having dyspnea for COPD patients")
  input$symptoms$logit_p_dyspnea_COPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_dyspnea_COPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_dyspnea_COPD_by_sex <- get_metadata("symptoms", "logit_p_dyspnea_COPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  input_help$symptoms$logit_p_dyspnea_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_dyspnea_nonCOPD_by_sex", "help", "Probability of having dyspnea for non-COPD patients")
  input$symptoms$logit_p_dyspnea_nonCOPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_dyspnea_nonCOPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_dyspnea_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_dyspnea_nonCOPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  # wheeze;
  input_help$symptoms$logit_p_wheeze_COPD_by_sex <- get_metadata("symptoms", "logit_p_wheeze_COPD_by_sex", "help", "Probability of having wheeze for COPD patients")
  input$symptoms$logit_p_wheeze_COPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_wheeze_COPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_wheeze_COPD_by_sex <- get_metadata("symptoms", "logit_p_wheeze_COPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  input_help$symptoms$logit_p_wheeze_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_wheeze_nonCOPD_by_sex", "help", "Probability of having wheeze for non-COPD patients")
  input$symptoms$logit_p_wheeze_nonCOPD_by_sex <- create_matrix_from_config(config$symptoms$logit_p_wheeze_nonCOPD_by_sex, transpose = FALSE)
  input_ref$symptoms$logit_p_wheeze_nonCOPD_by_sex <- get_metadata("symptoms", "logit_p_wheeze_nonCOPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")

  # covraiance matrices for symptoms
  input_help$symptoms$covariance_COPD <- get_metadata("symptoms", "covariance_COPD", "help", "Covariance matrix for symptoms random effects in COPD patients")
  input$symptoms$covariance_COPD <- do.call(cbind, lapply(config$symptoms$covariance_COPD, function(x) convert_config_value(x)))
  input_ref$symptoms$covariance_COPD <- get_metadata("symptoms", "covariance_COPD", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")


  input_help$symptoms$covariance_nonCOPD <- get_metadata("symptoms", "covariance_nonCOPD", "help", "Covariance matrix for symptoms random effects in non-COPD patients")
  input$symptoms$covariance_nonCOPD <- do.call(cbind, lapply(config$symptoms$covariance_nonCOPD, function(x) convert_config_value(x)))
  input_ref$symptoms$covariance_nonCOPD <- get_metadata("symptoms", "covariance_nonCOPD", "ref", "Kate's regression on CanCOLD, provided on 2019-05-22")


  ## Outpatient;

    # Primary care visits;
  input_help$outpatient$ln_rate_gpvisits_COPD_by_sex <- get_metadata("outpatient", "ln_rate_gpvisits_COPD_by_sex", "help", "Rate of GP visits for COPD patients")
  input$outpatient$ln_rate_gpvisits_COPD_by_sex <- create_matrix_from_config(config$outpatient$ln_rate_gpvisits_COPD_by_sex, transpose = FALSE)
  input$outpatient$dispersion_gpvisits_COPD <- convert_config_value(config$outpatient$dispersion_gpvisits_COPD)
  input_ref$outpatient$ln_rate_gpvisits_COPD_by_sex <- get_metadata("outpatient", "ln_rate_gpvisits_COPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-29")

  input_help$outpatient$ln_rate_gpvisits_nonCOPD_by_sex <- get_metadata("outpatient", "ln_rate_gpvisits_nonCOPD_by_sex", "help", "Rate of GP visits for Non-COPD patients")
  input$outpatient$ln_rate_gpvisits_nonCOPD_by_sex <- create_matrix_from_config(config$outpatient$ln_rate_gpvisits_nonCOPD_by_sex, transpose = FALSE)
  input_ref$outpatient$ln_rate_gpvisits_nonCOPD_by_sex <- get_metadata("outpatient", "ln_rate_gpvisits_nonCOPD_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-29")
  input$outpatient$dispersion_gpvisits_nonCOPD <- convert_config_value(config$outpatient$dispersion_gpvisits_nonCOPD)

    # Extras - DISABLED
  input$outpatient$rate_doctor_visit <- convert_config_value(config$outpatient$rate_doctor_visit)
  input$outpatient$p_specialist <- convert_config_value(config$outpatient$p_specialist)


  ## Case detection;

  input_help$diagnosis$p_case_detection <- get_metadata("diagnosis", "p_case_detection", "help", "Probability of recieving case detection in each year given they meet the selection criteria")
  input$diagnosis$p_case_detection <- convert_config_value(config$diagnosis$p_case_detection)
  input_ref$diagnosis$p_case_detection <- get_metadata("diagnosis", "p_case_detection", "ref", "Only applies if case_detection_start_year less than time_horizon.")

  input_help$diagnosis$case_detection_start_end_yrs <- get_metadata("diagnosis", "case_detection_start_end_yrs", "help", "Years in which case detection programme is to begin and end, respectively.")
  input$diagnosis$case_detection_start_end_yrs <- convert_config_value(config$diagnosis$case_detection_start_end_yrs)
  input_ref$diagnosis$case_detection_start_end_yrs <- get_metadata("diagnosis", "case_detection_start_end_yrs", "ref", "Acts as on on/off switch for case detection. Default is 100 i.e. case detection is off. To apply case detection, start year must be less than the time horizon. If case detection is to be administered for entire time horizon then start year would be zero and end year >= time horizon.")

  # input$smoking$ln_h_ces_betas[["diagnosis"]] <-  input$smoking$ln_h_ces_betas[["diagnosis"]] * input$diagnosis$p_case_detection
  # Turns off and on the effect of diagnosis on smoking cessation

  input_help$diagnosis$years_btw_case_detection <- get_metadata("diagnosis", "years_btw_case_detection", "help", "Number of years between case detection")
  input$diagnosis$years_btw_case_detection <- convert_config_value(config$diagnosis$years_btw_case_detection)
  input_ref$diagnosis$years_btw_case_detection <- get_metadata("diagnosis", "years_btw_case_detection", "ref", "")

  input_help$diagnosis$min_cd_age <- get_metadata("diagnosis", "min_cd_age", "help", "Minimum age for recieving case detection")
  input$diagnosis$min_cd_age <- convert_config_value(config$diagnosis$min_cd_age)
  input_ref$diagnosis$min_cd_age <- get_metadata("diagnosis", "min_cd_age", "ref", "")

  input_help$diagnosis$min_cd_pack_years <- get_metadata("diagnosis", "min_cd_pack_years", "help", "Minimum pack-years smoking to recieve case detection")
  input$diagnosis$min_cd_pack_years <- convert_config_value(config$diagnosis$min_cd_pack_years)
  input_ref$diagnosis$min_cd_pack_years <- get_metadata("diagnosis", "min_cd_pack_years", "ref", "")

  input_help$diagnosis$min_cd_symptoms <- get_metadata("diagnosis", "min_cd_symptoms", "help", "Set to 1 if only patients with symptoms should recieve case detection at baseline")
  input$diagnosis$min_cd_symptoms <- convert_config_value(config$diagnosis$min_cd_symptoms)
  input_ref$diagnosis$min_cd_symptoms <- get_metadata("diagnosis", "min_cd_symptoms", "ref", "")

  input_help$diagnosis$case_detection_methods <- get_metadata("diagnosis", "case_detection_methods", "help", "Sensitivity, specificity, and cost of case detection methods in the total population")
  input$diagnosis$case_detection_methods <- do.call(cbind, lapply(config$diagnosis$case_detection_methods, function(x) convert_config_value(x)))
  input_ref$diagnosis$case_detection_methods <- get_metadata("diagnosis", "case_detection_methods", "ref", "Sichletidis et al 2011")

  input_help$diagnosis$case_detection_methods_eversmokers <- get_metadata("diagnosis", "case_detection_methods_eversmokers", "help", "Sensitivity, specificity, and cost of case detection methods among ever smokers")
  input$diagnosis$case_detection_methods_eversmokers <- do.call(cbind, lapply(config$diagnosis$case_detection_methods_eversmokers, function(x) convert_config_value(x)))
  input_ref$diagnosis$case_detection_methods_eversmokers <- get_metadata("diagnosis", "case_detection_methods_eversmokers", "ref", "Haroon et al. BMJ Open 2015")

  input_help$diagnosis$case_detection_methods_symptomatic <- get_metadata("diagnosis", "case_detection_methods_symptomatic", "help", "Sensitivity, specificity, and cost of case detection methods among ever smokers")
  input$diagnosis$case_detection_methods_symptomatic <- do.call(cbind, lapply(config$diagnosis$case_detection_methods_symptomatic, function(x) convert_config_value(x)))
  input_ref$diagnosis$case_detection_methods_symptomatic <- get_metadata("diagnosis", "case_detection_methods_symptomatic", "ref", "CanCOLD analysed on Sept 9, 2019")



  ## Diagnosis;

  # Baseline diagnosis
  input_help$diagnosis$logit_p_prevalent_diagnosis_by_sex <- get_metadata("diagnosis", "logit_p_prevalent_diagnosis_by_sex", "help", "Probability of being diagnosed for patients with prevalent COPD")
  input$diagnosis$logit_p_prevalent_diagnosis_by_sex <- create_matrix_from_config(config$diagnosis$logit_p_prevalent_diagnosis_by_sex, transpose = FALSE)
  input_ref$diagnosis$logit_p_prevalent_diagnosis_by_sex <- get_metadata("diagnosis", "logit_p_prevalent_diagnosis_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-08-09")

  # Follow-up diagnosis
  input_help$diagnosis$logit_p_diagnosis_by_sex <- get_metadata("diagnosis", "logit_p_diagnosis_by_sex", "help", "Probability of being diagnosed for COPD patients")
  input$diagnosis$logit_p_diagnosis_by_sex <- create_matrix_from_config(config$diagnosis$logit_p_diagnosis_by_sex, transpose = FALSE)
  input_ref$diagnosis$logit_p_diagnosis_by_sex <- get_metadata("diagnosis", "logit_p_diagnosis_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-05-29")
  input$diagnosis$p_hosp_diagnosis <- convert_config_value(config$diagnosis$p_hosp_diagnosis)

  # Overdiagnosis

  input_help$diagnosis$logit_p_overdiagnosis_by_sex <- get_metadata("diagnosis", "logit_p_overdiagnosis_by_sex", "help", "Probability of being overdiagnosed for non-COPD subjects")
  input$diagnosis$logit_p_overdiagnosis_by_sex <- create_matrix_from_config(config$diagnosis$logit_p_overdiagnosis_by_sex, transpose = FALSE)
  input_ref$diagnosis$logit_p_overdiagnosis_by_sex <- get_metadata("diagnosis", "logit_p_overdiagnosis_by_sex", "ref", "Kate's regression on CanCOLD, provided on 2019-07-16")
  input$diagnosis$p_correct_overdiagnosis <- convert_config_value(config$diagnosis$p_correct_overdiagnosis)


  ## Medication;

  # adherence to medication
  input_help$medication$medication_adherence <- get_metadata("medication", "medication_adherence", "help", "Proportion adherent to medication")
  input$medication$medication_adherence <- convert_config_value(config$medication$medication_adherence)
  input_ref$medication$medication_adherence <- get_metadata("medication", "medication_adherence", "ref", "")

  # medication log-hazard regression matrix for rate reduction in exacerbations
  input_help$medication$medication_ln_hr_exac <- get_metadata("medication", "medication_ln_hr_exac", "help", "Rate reduction in exacerbations due to treatment")
  input$medication$medication_ln_hr_exac <- convert_config_value(config$medication$medication_ln_hr_exac)
  input_ref$medication$medication_ln_hr_exac <- get_metadata("medication", "medication_ln_hr_exac", "ref", "ICS/LABA: Annual Rate Ratio of Comibation Therapy (Salmeterol and Fluticasone Propionate) vs. Placebo from TORCH (doi: 10.1056/NEJMoa063070), ICS: Annual Rate Ratio between Fluticasone vs. Placebo from TRISTAN Trial (doi:10.1016/S0140-6736(03)12459-2), LABA: Annual Rate Ratio between Salmeterol vs. Placebo from TRISTAN Trial (doi:10.1016/S0140-6736(03)12459-2), LAMA-Zhou et al. 2017, LAMA/LABA-UPLIFT 2008, ICS/LAMA/LABA-KRONOS 2018")

  # cost of medications
  input_help$medication$medication_costs <- get_metadata("medication", "medication_costs", "help", "Costs of treatment")
  input$medication$medication_costs <- convert_config_value(config$medication$medication_costs)
  input_ref$medication$medication_costs <- get_metadata("medication", "medication_costs", "ref", "BC administrative data")

  # utility from medications
  input_help$medication$medication_utility <- get_metadata("medication", "medication_utility", "help", "Utility addition from treatment")
  input$medication$medication_utility <- convert_config_value(config$medication$medication_utility)
  input_ref$medication$medication_utility <- get_metadata("medication", "medication_utility", "ref", "Lambe et al. Thorax 2019")

  # medication event - disabled
  template = c(int = 0, sex = 0, age = 0, med_class = rep(0, length(medication_classes)))
  mx <- NULL
  for (i in medication_classes) mx <- rbind(mx, template)

  input$medication$ln_h_start_betas_by_class <- mx
  input$medication$ln_h_stop_betas_by_class <- mx
  input$medication$ln_rr_exac_by_class <- rep(log(1), length(medication_classes))  #TODO: update this to represent different medication effect


  ### comorbidity - DEPRECATED (MI/stroke/HF removed from model)
  # These inputs are no longer used - kept commented for reference
  # input$comorbidity$logit_p_mi_betas_by_sex = create_matrix_from_config(config$comorbidity$logit_p_mi_betas_by_sex, transpose = FALSE)
  # input$comorbidity$ln_h_mi_betas_by_sex = create_matrix_from_config(config$comorbidity$ln_h_mi_betas_by_sex, transpose = FALSE)
  # input$comorbidity$p_mi_death <- convert_config_value(config$comorbidity$p_mi_death)
  # input$comorbidity$logit_p_stroke_betas_by_sex = create_matrix_from_config(config$comorbidity$logit_p_stroke_betas_by_sex, transpose = FALSE)
  # input$comorbidity$ln_h_stroke_betas_by_sex = create_matrix_from_config(config$comorbidity$ln_h_stroke_betas_by_sex, transpose = FALSE)
  # input$comorbidity$p_stroke_death <- convert_config_value(config$comorbidity$p_stroke_death)
  # input$comorbidity$logit_p_hf_betas_by_sex = create_matrix_from_config(config$comorbidity$logit_p_hf_betas_by_sex, transpose = FALSE)
  # input$comorbidity$ln_h_hf_betas_by_sex = create_matrix_from_config(config$comorbidity$ln_h_hf_betas_by_sex, transpose = FALSE)


  ##cost and utility
  input$cost$bg_cost_by_stage <- t(as.matrix(convert_config_value(config$cost$bg_cost_by_stage)))
  input_help$cost$bg_cost_by_stage <- get_metadata("cost", "bg_cost_by_stage", "help", "Annual direct (NON-TREATMENT) maintenance costs for non-COPD and COPD by GOLD grades")
  #  input$cost$ind_bg_cost_by_stage=t(as.matrix(c(N=0, I=40, II=80, III=134, IV=134))) #TODO Not implemented in C yet.
  #  input_help$cost$ind_bg_cost_by_stage="Annual inddirect costs for non-COPD, and COPD by GOLD grades"
  input$cost$exac_dcost <- t(as.matrix(convert_config_value(config$cost$exac_dcost)))
  input_help$cost$exac_dcost <- get_metadata("cost", "exac_dcost", "help", "Incremental direct costs of exacerbations by severity levels")

  input$cost$cost_case_detection <- convert_config_value(config$cost$cost_case_detection)
  input_help$cost$cost_case_detection <- get_metadata("cost", "cost_case_detection", "help", "Cost of case detection")

  input$cost$cost_outpatient_diagnosis <- convert_config_value(config$cost$cost_outpatient_diagnosis)
  input_help$cost$cost_outpatient_diagnosis <- get_metadata("cost", "cost_outpatient_diagnosis", "help", "Cost of diagnostic spirometry")

  input$cost$cost_gp_visit <- convert_config_value(config$cost$cost_gp_visit)
  input_help$cost$cost_gp_visit <- get_metadata("cost", "cost_gp_visit", "help", "Cost of GP visit")

  input$cost$cost_smoking_cessation <- convert_config_value(config$cost$cost_smoking_cessation)
  input_help$cost$cost_smoking_cessation <- get_metadata("cost", "cost_smoking_cessation", "help", "Cost of 12 weeks Nicotine Replacement Therapy from Mullen BMJ Tobacco Control 2014")


  #input$cost$doctor_visit_by_type<-t(as.matrix(c(50,150)))

  input$utility$bg_util_by_stage <- t(as.matrix(convert_config_value(config$utility$bg_util_by_stage)))
  input_help$utility$bg_util_by_stage <- get_metadata("utility", "bg_util_by_stage", "help", "Background utilities for non-COPD, and COPD by GOLD grades")
  #  input$utility$exac_dutil=t(as.matrix(c(mild=-0.07, moderate=-0.37/2, severe=-0.3)))

  input$utility$exac_dutil <- do.call(cbind, lapply(config$utility$exac_dutil, function(x) convert_config_value(x)))
  input_help$utility$exac_dutil <- get_metadata("utility", "exac_dutil", "help", "Incremental change in utility during exacerbations by severity level")


  input$manual$MORT_COEFF <- convert_config_value(config$manual$MORT_COEFF)
  input$manual$smoking$intercept_k <- convert_config_value(config$manual$smoking_intercept_k)


  #Proportion of death by COPD that should be REMOVED from background mortality
  input$manual$explicit_mortality_by_age_sex <- create_matrix_from_config(config$manual$explicit_mortality_by_age_sex, transpose = FALSE)

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

  # All parameters are now read directly from config above

  model_input <- list ("values" = input, "help" = input_help, "ref" = input_ref, "config" = config)
  return (model_input)
}

#' Get the default model input (lazy initialization)
#'
#' This function provides access to the default model_input object.
#' The model_input is lazily initialized on first access to avoid
#' embedding paths during package installation.
#'
#' @return The default model input list
#' @keywords internal
get_default_model_input <- function() {
  if (is.null(.epicR_env$model_input)) {
    .epicR_env$model_input <- get_input()
  }
  .epicR_env$model_input
}

#' Reset the cached model input
#'
#' Forces the default model_input to be reloaded on next access.
#' Useful after modifying config files.
#'
#' @export
reset_model_input <- function() {
  .epicR_env$model_input <- NULL
  message("Model input cache cleared. It will be reloaded on next access.")
}

# Create an active binding so that 'model_input' works as before
# This is done via makeActiveBinding in .onLoad
