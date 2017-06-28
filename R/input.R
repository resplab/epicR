# The following declarations are already defined in mode.WIP.cpp
# they are replicated here to make it compatible with epicR as a pakcage. Amin

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

#' @export
init_input <- function() {
  input <- list()
  input_help <- list()
  input_ref <- list()


  input$global_parameters <- list(age0 = 40, time_horizon = 20, discount_cost = 0.03, discount_qaly = 0.03)
  input_help$global_parameters <- list(age0 = "Starting age in the model", time_horizon = "Model time horizon", discount_cost = "Discount value for cost outcomes",
                                       discount_qaly = "Discount value for QALY outcomes")



  input_help$agent$p_female <- "Proportion of females in the population"
  input$agent$p_female <- 0.5
  input_ref$agent$p_female <- "Model assumption"


  input_help$agent$height_0_betas <- "Regressoin coefficients for estimating height (in meters) at baseline"
  input$agent$height_0_betas <- t(as.matrix(c(intercept = 1.82657, sex = -0.13093, age = -0.00125, age2 = 2.31e-06, sex_age = -0.0001651)))
  input_ref$agent$height_0_betas <- ""


  input_help$agent$height_0_sd <- "SD representing heterogeneity in baseline height"
  input$agent$height_0_sd <- 0.06738
  input_ref$agent$height_0_sd <- ""


  input_help$agent$weight_0_betas <- "Regressoin coefficients for estimating weiight (in Kg) at baseline"
  input$agent$weight_0_betas <- t(as.matrix(c(intercept = 50, sex = -5, age = 0.1, age2 = 0, sex_age = 0, height = 1, year = 0.01)))
  input_ref$agent$weight_0_betas <- ""


  input_help$agent$weight_0_sd <- "SD representing heterogeneity in baseline weight"
  input$agent$weight_0_sd <- 5
  input_ref$agent$weight_0_sd <- ""


  input_help$agent$height_weight_rho <- "Correlaiton coefficient between weight and height at baseline"
  input$agent$height_weight_rho <- 0
  input_ref$agent$height_weight_rho <- ""

  input$agent$p_prevalence_age <- c(rep(0, 40), c(473.9 * 0, 462.7, 463, 469.3, 489.9, 486.3, 482.7, 479, 483.7, 509, 542.8, 557.7,
                                                  561.4, 549.7, 555.3, 544.6, 531.6, 523.9, 510.2, 494.1, 486.5, 465.6, 442.8, 424.6, 414.9, 404.3, 394.4, 391.5, 387.3, 330.9,
                                                  304.5, 292.2, 277.4, 255.1, 241.1, 223.2, 211.4, 198.8, 185.6, 178, 166.7, 155.2, 149.1, 140.6, 131.9, 119.7, 105.8, 95.4,
                                                  83.4, 73.2, 62.4, 52.3, 42.7, 34.7, 27, 19.9, 13.2, 8.8, 5.9, 3.8, 6.8), rep(0, 10))

  input_help$agent$p_prevalence_age <- "Age pyramid at baseline (taken from CanSim.052-0005.xlsm for year 2015)"
  input$agent$p_prevalence_age <- input$agent$p_prevalence_age/sum(input$agent$p_prevalence_age)
  input_ref$agent$p_prevalence_age <- "CanSim.052-0005.xlsm for year 2015. THANKS TO AMIN!"


  input_help$agent$p_incidence_age <- "Discrete distribution of age for the incidence population (population arriving after the first date) - generally estimated through calibration"
  input$agent$p_incidence_age <- c(rep(0, 40), c(1), 0.02 * exp(-(0:59)/5), rep(0, 111 - 40 - 1 - 60))
  input$agent$p_incidence_age <- input$agent$p_incidence_age/sum(input$agent$p_incidence_age)
  input_ref$agent$p_incidence_age <- ""


  input_help$agent$p_bgd_by_sex <- "Life table"
  input$agent$p_bgd_by_sex <- cbind(male = c(0.00522, 3e-04, 0.00022, 0.00017, 0.00013, 0.00011, 1e-04, 9e-05, 8e-05, 8e-05, 9e-05,
                                             1e-04, 0.00012, 0.00015, 2e-04, 0.00028, 0.00039, 0.00051, 0.00059, 0.00066, 0.00071, 0.00075, 0.00076, 0.00076, 0.00074,
                                             0.00071, 7e-04, 0.00069, 7e-04, 0.00071, 0.00074, 0.00078, 0.00082, 0.00086, 0.00091, 0.00096, 0.00102, 0.00108, 0.00115,
                                             0.00123, 0.00132, 0.00142, 0.00153, 0.00165, 0.00179, 0.00194, 0.00211, 0.00229, 0.00251, 0.00275, 0.00301, 0.00331, 0.00364,
                                             0.00401, 0.00441, 0.00484, 0.00533, 0.00586, 0.00645, 0.00709, 0.0078, 0.00859, 0.00945, 0.0104, 0.01145, 0.0126, 0.01387,
                                             0.01528, 0.01682, 0.01852, 0.0204, 0.02247, 0.02475, 0.02726, 0.03004, 0.0331, 0.03647, 0.04019, 0.0443, 0.04883, 0.05383,
                                             0.05935, 0.06543, 0.07215, 0.07957, 0.08776, 0.0968, 0.10678, 0.1178, 0.12997, 0.14341, 0.15794, 0.17326, 0.18931, 0.20604,
                                             0.21839, 0.23536, 0.2529, 0.27092, 0.28933, 0.30802, 0.32687, 0.34576, 0.36457, 0.38319, 0.40149, 0.41937, 0.43673, 0.4535,
                                             0.4696, 1), female = c(0.00449, 0.00021, 0.00016, 0.00013, 1e-04, 9e-05, 8e-05, 7e-05, 7e-05, 7e-05, 8e-05, 8e-05, 9e-05,
                                                                    0.00011, 0.00014, 0.00018, 0.00022, 0.00026, 0.00028, 0.00029, 3e-04, 3e-04, 0.00031, 0.00031, 3e-04, 3e-04, 3e-04, 0.00031,
                                                                    0.00032, 0.00034, 0.00037, 4e-04, 0.00043, 0.00047, 0.00051, 0.00056, 6e-04, 0.00066, 0.00071, 0.00077, 0.00084, 0.00092,
                                                                    0.001, 0.00109, 0.00118, 0.00129, 0.0014, 0.00153, 0.00166, 0.00181, 0.00197, 0.00215, 0.00235, 0.00257, 0.0028, 0.00307,
                                                                    0.00336, 0.00368, 0.00403, 0.00442, 0.00485, 0.00533, 0.00586, 0.00645, 0.0071, 0.00782, 0.00862, 0.00951, 0.01051, 0.01161,
                                                                    0.01284, 0.0142, 0.01573, 0.01743, 0.01934, 0.02146, 0.02384, 0.02649, 0.02947, 0.0328, 0.03654, 0.04074, 0.04545, 0.05074,
                                                                    0.05669, 0.06338, 0.07091, 0.0794, 0.08897, 0.09977, 0.11196, 0.12542, 0.13991, 0.15541, 0.1719, 0.18849, 0.20653, 0.22549,
                                                                    0.24526, 0.26571, 0.28671, 0.3081, 0.3297, 0.35132, 0.3728, 0.39395, 0.41461, 0.43462, 0.45386, 0.47222, 1))
  input_ref$agent$p_bgd_by_sex <- "Life table"


  input_help$agent$l_inc_betas = "Ln of incidence rate of the new population - Calibration target to keep populatoin size and age pyramid in line with calibration"
  input$agent$l_inc_betas = t(as.matrix(c(intercept = -3.55, y = 0.01, y2 = 0))) # intercept is the result of model calibration
  input_ref$agent$l_inc_betas = ""


  input_help$agent$ln_h_bgd_betas = "Effect of variables on background mortality"
  input$agent$ln_h_bgd_betas = t(as.matrix(c(intercept = 0, y = -0.025, y2 = 0, age = 0, b_mi = 0.1, n_mi = 0, b_stroke = 0.1,
                                             n_stroke = 0, hf = 0.1)))
  input_ref$agent$ln_h_bgd_betas = ""


  ### smoking;

  input_help$smoking$logit_p_current_smoker_0_betas <- "Probability of being a current smoker at the time of creation"
  input$smoking$logit_p_current_smoker_0_betas <- t(as.matrix(c(Intercept = -0.53, sex = -0.22, age = -0.02, age2 = 0, sex_age = 0,
                                                                sex_age2 = 0, year = -0.02)))
  input_ref$smoking$logit_p_current_smoker_0_betas <- ""


    input_help$smoking$logit_p_ever_smoker_con_not_current_0_betas <- "Probability of being an ever smoker conditional on not being current smoker, at the time of creation"
    input$smoking$logit_p_ever_smoker_con_not_current_0_betas <- t(as.matrix(c(intercept = 0, sex = 0, age = 0, age2 = 0, sex_age = 0,
                                                                             sex_age2 = 0, year = -0.02)))
    input_ref$smoking$logit_p_ever_smoker_con_not_current_0_betas <- ""


  input_help$smoking$pack_years_0_betas <- "Regression equations for determining the pack-years of smoking at the time of creation (for elogit_p_ever_smoker_con_current_0_betas smokers)"
  input$smoking$pack_years_0_betas <- t(as.matrix(c(intercept = -5, sex = -2, age = 0.8, year = -0.1, current_smoker = 1)))
  input_ref$smoking$pack_years_0_betas <- ""


  input_help$smoking$pack_years_0_sd <- "Standard deviation for variation in pack-years among individuals (current or former smokers)"
  input$smoking$pack_years_0_sd <- 5
  input_ref$smoking$pack_years_0_sd <- "Standard deviation for variation in pack-years among individuals (current or former smokers)"


  input_help$smoking$ln_h_inc_betas <- "Log-hazard of starting smoking (incidence or relapse)"
  input$smoking$ln_h_inc_betas <- c(intercept = -4, sex = -0.15, age = -0.02, age2 = 0, calendar_time = -0.02)
  input_ref$smoking$ln_h_inc_betas <- ""


  input_help$smoking$ln_h_ces_betas <- "Log-hazard of smoking cessation"
  input$smoking$ln_h_ces_betas <- c(intercept = -3, sex = 0, age = 0, age2 = 0, calendar_time = 0)
  input_ref$smoking$ln_h_ces_betas <- ""


  ## COPD
  input_help$COPD$logit_p_COPD_betas_by_sex <- "Logit of the probability of having COPD (FEV1/FVC<0.7) at time of creation (separately by sex)"
  input$COPD$logit_p_COPD_betas_by_sex <- cbind(male = c(intercept = -5.337997, age = 0.044918, age2 = 0, pack_years = 0.018734,
                                                         current_smoking = 1.093586, year = 0, asthma = 0),
                                                female = c(intercept = -4.377285, age = 0.031689, age2 = 0, pack_years = 0.025183,
                                                         current_smoking = 0.636127, year = 0, asthma = 0))
  input_ref$COPD$logit_p_COPD_betas_by_sex <- "CanCold - Shahzad's Derivation. Last Updated on 2017-04-19. See https://github.com/aminadibi/epicR/issues/8"


  input_help$COPD$ln_h_COPD_betas_by_sex <- "Log-hazard of developing COPD (FEV1/FVC<LLN) for those who did not have COPD at creation time (separately by sex)"
  input$COPD$ln_h_COPD_betas_by_sex <- cbind(male = c(Intercept = -8.341626527, age = 0.053539987, age2 = 0, pack_years = 0.004274558,
                                                      smoking_status = 1.523356867, year = 0, asthma = 0),
                                             female = c(Intercept = -7.40741695, age = 0.03751128, age2 = 0, pack_years = 0.01995802,
                                                      smoking_status = 0.92879076, year = 0, asthma = 0))
  input_ref$COPD$ln_h_COPD_betas_by_sex <- "Amin's Iterative solution. Last Updated on 2017-05-03 (v0.3.0)"


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
  input$lung_function$fev1_0_ZafarCMAJ_by_sex <- cbind(male = c(intercept = 1.4212 + 0.4625, baseline_age = -0.00519, baseline_weight_kg = -0.00011,
                                                                height = -1.7603, height_sq = 1.8931, current_smoker = -0.07722, age_height_sq = -0.0082, followup_time = 0),
                                                       female = c(intercept = 1.4212, baseline_age = -0.00519, baseline_weight_kg = -0.00011,
                                                                height = -1.7603, height_sq = 1.8931, current_smoker = -0.07722, age_height_sq = -0.0082, followup_time = 0))
  input_ref$lung_function$fev1_0_ZafarCMAJ_by_sex <- "Zafari Z, Sin DD, Postma DS, Löfdahl CG, Vonk J, Bryan S, Lam S, Tammemagi CM, Khakban R, Man SP, Tashkin D. Individualized prediction of lung-function decline in chronic obstructive pulmonary disease. Canadian Medical Association Journal. 2016 Oct 4;188(14):1004-11."


  # NHANES:
  # input$lung_function$pred_fev1_betas_by_sex<-rbind(c(intercept=-0.7453,age=-0.04106,age2=0.004477,height2=0.00014098),c(-0.871,0.06537,0,0.00011496))

  input_help$lung_function$pred_fev1_betas_by_sex <- "Coefficients for calculation of predicted FEV1 based on individual characteristics"
  input$lung_function$pred_fev1_betas_by_sex <- cbind(male = c(intercept = 0.5536, age = -0.01303, age_sq = -0.000172, height = 1.4098),
                                                      female = c(intercept = 0.4333, age = -0.00361, age_sq = -0.000194, height = 1.1496))
  input_ref$lung_function$pred_fev1_betas_by_sex <- ""



  input_help$lung_function$dfev1_betas <- "Regression equations (mixed-effects model) for rate of FEV1 decline"
  input$lung_function$fev1_betas_by_sex <- cbind(male = c(intercept = -0.1779 - 0.00886, baseline_age = 0.00231, baseline_weight_kg = 0.00015,
                                                          height = 0.07413, height_sq = 0.01139, current_smoker = -0.02579, age_height_sq = -0.00092, followup_time = -0.00044),
                                                 female = c(intercept = -0.1779, baseline_age = 0.00231, baseline_weight_kg = 0.00015,
                                                          height = 0.07413, height_sq = 0.01139, current_smoker = -0.02579, age_height_sq = -0.00092, followup_time = -0.00044))
  input_ref$lung_function$dfev1_betas <- ""


  input_help$lung_function$dfev1_re_sds <- "SD of random-effect terms in the mixed-effects model of FEV1 decline"
  input$lung_function$dfev1_re_sds <- t(as.matrix(c(intercept = 0, time = 0)))
  input_ref$lung_function$dfev1_re_sds <- ""


  input_help$lung_function$dfev1_re_rho <- "Correlation coefficient between random-effect terms in the mixed-effects model of FEV1 decline"
  input$lung_function$dfev1_re_rho <- -0
  input_ref$lung_function$dfev1_re_rho <- ""



  ## Exacerbation;

  input_help$exacerbation$ln_rate_betas = "Regression coefficients for the random-effects log-hazard model of exacerbation (of any severity)"
  input$exacerbation$ln_rate_betas = t(as.matrix(c(intercept = -0.785, female = 0.174353, age = 0.04082 * 0.1, fev1 = -0, smoking_status = 0,
                                                   gold2 = 0.46, gold3p = 0.65)))
  input_ref$exacerbation$ln_rate_betas = "Najafzadeh M, Marra CA, Lynd LD, Sadatsafavi M, FitzGerald JM, McManus B, Sin D. Future impact of various interventions on the burden of COPD in Canada: a dynamic population model. PloS one. 2012 Oct 11;7(10):e46746. Only function of GOLD for minimalism"


  input_help$exacerbation$logit_severity_betas = "Regression coefficients for the proportional odds model of exacerbation severity"
  input$exacerbation$logit_severity_betas = t(as.matrix(c(intercept1 = 1.091, intercept2 = 1.902, intercept3 = 5.208, female = -0.0431,
                                                          age = -0.0076, fev1 = -0.002945, smoking_status = 0, pack_years = -0.001127, BMI = 0.01782)))
  input_ref$exacerbation$logit_severity_betas = ""


  input_help$exacerbation$ln_rate_intercept_sd = "SD of the random intercept for log-hazard of exacerbation"
  input$exacerbation$ln_rate_intercept_sd = sqrt(0.55)
  input_ref$exacerbation$ln_rate_intercept_sd = ""


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
  input$exacerbation$logit_p_death_by_sex <- cbind(male = c(intercept = -6.10, age = log(1.05), verysevere_to_severe = 0, n_hist_severe_exac = 0),
                                                   female = c(intercept = -6.10, age = log(1.05),  verysevere_to_severe = 0, n_hist_severe_exac = 0))
  input_ref$exacerbation$logit_p_death_by_sex <- ""

  # Outpatient;
  input$outpatient$rate_doctor_visit <- 0.1
  input$outpatient$p_specialist <- 0.1


  # medication log-hazard regression matrix for initiation of each medication

  template = c(int = 0, sex = 0, age = 0, med_class = rep(0, length(medication_classes)))
  mx <- NULL
  for (i in medication_classes) mx <- rbind(mx, template)

  input$medication$ln_h_start_betas_by_class <- mx
  input$medication$ln_h_stop_betas_by_class <- mx
  input$medication$ln_rr_exac_by_class <- rep(log(1), length(medication_classes))  #TODO: update this to represent different medication effect


  ### comorbidity mi
  input$comorbidity$logit_p_mi_betas_by_sex = cbind(male = c(intercept = -3000, age = 0.001, age2 = 0, pack_years = 0.01, smoking = 0.001,
                                                             calendar_time = 0, bmi = 0, gold = 0.05), female = c(intercept = -3000, age = 0.001, age2 = 0, pack_years = 0.01, smoking = 0.001,
                                                                                                                  calendar_time = 0, bmi = 0, gold = 0.05))
  input$comorbidity$ln_h_mi_betas_by_sex = cbind(male = c(intercept = -10000.748, age = 0.1133, age2 = -0.00044, pack_years = 0.01,
                                                          smoking = 0.70953, calendar_time = 0, bmi = 0.01, gold = 0.05, b_mi = 0.5, n_mi = 0), female = c(intercept = -30000, age = 0.001,
                                                                                                                                                           age2 = 0, pack_years = 0.01, smoking = 0.61868, calendar_time = 0, bmi = 0.01, gold = 0.05, b_mi = 0, n_mi = 0.01))
  input$comorbidity$p_mi_death <- 0.05


  #stroke
  input$comorbidity$logit_p_stroke_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, b_mi=0, gold=0.05, b_mi=0, n_mi=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0)
  );
  input$comorbidity$ln_h_stroke_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0)
  );
  input$comorbidity$p_stroke_death<-0.18;


  #hf
  input$comorbidity$logit_p_hf_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0)
  );
  input$comorbidity$ln_h_hf_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05,b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.01, gold=0.05,b_mi=0, n_mi=0.01, b_stroke=0, n_stroke=0)
  );


  ##cost and utility
  input$cost$bg_cost_by_stage=t(as.matrix(c(N=0, I=36,II=215,III=524,IV=524)))
  input_help$cost$bg_cost_by_stage="Annual direct costs for non-COPD, and COPD by GOLD grades"
  input$cost$exac_dcost=t(as.matrix(c(mild=160,moderate=1500,severe=6500)))
  input_help$cost$exac_dcost="Incremental direct costs of exacerbations by severity levels"

  #input$cost$doctor_visit_by_type<-t(as.matrix(c(50,150)))

  input$utility$bg_util_by_stage=t(as.matrix(c(N=1, I=0.81,II=0.72,III=0.67,IV=0.67)))
  input_help$utility$bg_util_by_stage="Background utilities for non-COPD, and COPD by GOLD grades"
  input$utility$exac_dutil=t(as.matrix(c(mild=-0.07,moderate=-0.37/2,severe=-0.3)))
  input_help$utility$exac_dutil="Incremental change in utility during exacerbations by severity level"

  input$manual$MORT_COEFF<-1
  input$manual$smoking$intercept_k<-1


  #Proportion of death by COPD that should be REMOVED from background mortality
  input$manual$explicit_mortality_by_age_sex<-cbind(
    #   0 for <35         35-39           40-44           45-49          50-54      55-59           60-64        65-69          70-74       75-79       80+
    male =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.000682537561837509,0.000692239290761915,0.000717702765945308,0.000718157972650019,0.000740668380363496,0.000775579615689037,0.000781540800188696,0.000812715249157972,0.000821445334564957,0.000841236274036308,0.000883193311255267,0.000896699479332151,0.00089967532218331,0.000908623304486485,0.000966913745170578,0.000971418110393731,0.000939847985004366,0.000961630021184187,0.00093668629412762,0.000920335279180362,0.000885893548817421,0.000763281445166686,0.000709097237371762,0.000633844023225628,0.000480137468051825,0.000405086120143726,0.00023474800410795,5.55260469464643e-05,-0.000129757355180386,-0.000374897844564424,-0.000683827223229422,-0.00101962420230591,-0.00139658910365584,-0.00173377043465557,-0.00218555157307904,-0.00272333771933468,-0.00330539330604379,-0.00382514716817148,-0.00468180529959616,-0.00534224998726189,-0.00609353288488013,-0.00709620188794428,-0.00792955732423684,-0.00891857139278278,-0.0100829205408468,-0.0111015216571686,-0.0125418137018319,-0.0134898829007592,-0.0144450897647211,-0.0156549382762837,-0.0167335856378812,-0.0179735811783126,-0.0183499483335693,-0.0190962278632899,-0.0189595950213169,-0.016313542320767,-0.0184385575318834,-0.0189520089730894,-0.0184363975266301,-0.01784012115217,-0.0169798566196055,-0.0132381973495569,-0.0139313982604172,-0.0102075922207878,-0.00750978395397761,-0.00407896139250685,-0.000422442170957382,-0.00531542269821844,-0.00541328684660725,-0.00266870557243748,-0.764669376575367
)
    ,female =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.00122295118555757,0.001293525146198,0.00131829491618741,0.00135759246164127,0.00139574543713664,0.00143900449622371,0.00151348950676984,0.001584122980157,0.00162501734407912,0.00172342538809884,0.00177013047162379,0.00182362485462782,0.00191838078747516,0.00198451583351032,0.00205963255161307,0.00215265285964298,0.00222768502285646,0.00229244516051302,0.00234217774994552,0.00239352395251374,0.00248550656444669,0.00246065869241351,0.00254401819100341,0.00254227971081854,0.00257252709975878,0.00256078927960937,0.00254895242262907,0.00248372503480315,0.00248543686273677,0.00236206362325925,0.00227396714994816,0.00211659560881503,0.00199193131889561,0.00176194220326564,0.00151673177694323,0.00130353349116962,0.000875398081511106,0.000432858535383846,-0.000102658342757269,-0.000707948101948706,-0.00135959782750947,-0.00197599791304383,-0.00283594500170101,-0.00371320406567087,-0.0048922428245304,-0.00603184903479488,-0.00734984541785612,-0.00870570011832962,-0.0100862873793264,-0.0117637344384842,-0.0136215506986697,-0.0153804698777556,-0.0169898886282818,-0.0184714840042644,-0.0206545761890505,-0.0209691561293496,-0.0226439439807175,-0.0235278189880881,-0.0244840519460761,-0.0249096919340781,-0.0244271242760924,-0.0234048508574713,-0.023545101612623,-0.0226445757720996,-0.0221257378454246,-0.0190277312034191,-0.0134954845149789,-0.00818231254242435,-0.000485864138442149,0.00166812897665103,-0.749517846077257
))
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

  model_input<<-input
  model_input_help<<-input_help
  model_input_ref<<-input_ref
}
