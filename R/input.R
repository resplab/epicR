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
  input$agent$p_incidence_age <- c(rep(0, 40), c(1), 0.02* exp(-(0:59)/5), rep(0, 111 - 40 - 1 - 60))
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
  input$agent$l_inc_betas = t(as.matrix(c(intercept = -3.55, y = 0.01, y2 = 0))) # intercept is the result of model calibration,
  input_ref$agent$l_inc_betas = ""


  input_help$agent$ln_h_bgd_betas = "Increased Longevity Over time and effect of other variables"
  input$agent$ln_h_bgd_betas = t(as.matrix(c(intercept = 0, y = -0.025, y2 = 0, age = 0, b_mi = 0, n_mi = 0, b_stroke = 0,
                                             n_stroke = 0, hf = 0)))  #AKA longevity
  input_ref$agent$ln_h_bgd_betas = ""

  ### smoking;

  input_help$smoking$logit_p_current_smoker_0_betas <- "Probability of being a current smoker at the time of creation"
  input$smoking$logit_p_current_smoker_0_betas <- t(as.matrix(c(Intercept = -1.8, sex = -0.22, age = -0.02, age2 = 0, sex_age = 0,
                                                                sex_age2 = 0, year = -0.02)))
  input_ref$smoking$logit_p_current_smoker_0_betas <- ""


  input_help$smoking$minimum_smoking_prevalence <- "Minimum Smoking Prevalence"
  input$smoking$minimum_smoking_prevalence <- 0.15
  input_ref$smoking$minimum_smoking_prevalence <- ""


  input_help$smoking$mortality_factor <- "Mortality ratio for smokers vs. non-smokers"
  input$smoking$mortality_factor <- 3
  input_ref$smoking$mortality_factor <- "https://doi.org/10.1186/s12916-015-0281-z"


  input_help$smoking$logit_p_ever_smoker_con_not_current_0_betas <- "Probability of being an ever smoker conditional on not being current smoker, at the time of creation"
  input$smoking$logit_p_ever_smoker_con_not_current_0_betas <- t(as.matrix(c(intercept = -0.3681, sex = 0, age = 0, age2 = 0, sex_age = 0,
                                                                             sex_age2 = 0, year = 0)))
  input_ref$smoking$logit_p_ever_smoker_con_not_current_0_betas <- ""


  input_help$smoking$pack_years_0_betas <- "Regression equations for determining the pack-years of smoking at the time of creation (for elogit_p_ever_smoker_con_current_0_betas smokers)"
  input$smoking$pack_years_0_betas <- t(as.matrix(c(intercept = -30, sex = -7.7, age = 0.8, year = -0.5, current_smoker = 11)))
  input_ref$smoking$pack_years_0_betas <- ""


  input_help$smoking$pack_years_0_sd <- "Standard deviation for variation in pack-years among individuals (current or former smokers)"
  input$smoking$pack_years_0_sd <- 5
  input_ref$smoking$pack_years_0_sd <- "Standard deviation for variation in pack-years among individuals (current or former smokers)"


  input_help$smoking$ln_h_inc_betas <- "Log-hazard of starting smoking (incidence or relapse)"
  input$smoking$ln_h_inc_betas <- c(intercept = -2, sex = -0.15, age = -0.02, age2 = 0, calendar_time = -0.02)
  input_ref$smoking$ln_h_inc_betas <- ""


  input_help$smoking$ln_h_ces_betas <- "Log-hazard of smoking cessation"
  input$smoking$ln_h_ces_betas <- c(intercept = -1.7, sex = 0, age = 0, age2 = 0, calendar_time = -0.02)
  input_ref$smoking$ln_h_ces_betas <- ""


  ## COPD
  input_help$COPD$logit_p_COPD_betas_by_sex <- "Logit of the probability of having COPD (FEV1/FVC<0.7) at time of creation (separately by sex)"
  input$COPD$logit_p_COPD_betas_by_sex <- cbind(male = c(intercept = -5.337997, age = 0.044918, age2 = 0, pack_years = 0.018734,
                                                         current_smoking = 1.093586, year = 0, asthma = 0),
                                                female = c(intercept = -4.377285, age = 0.031689, age2 = 0, pack_years = 0.025183,
                                                         current_smoking = 0.636127, year = 0, asthma = 0))
  input_ref$COPD$logit_p_COPD_betas_by_sex <- "CanCold - Shahzad's Derivation. Last Updated on 2017-04-19. See https://github.com/aminadibi/epicR/issues/8"


  input_help$COPD$ln_h_COPD_betas_by_sex <- "Log-hazard of developing COPD (FEV1/FVC<LLN) for those who did not have COPD at creation time (separately by sex)"
  input$COPD$ln_h_COPD_betas_by_sex <- cbind(male = c(Intercept =  -9.14458547, age = 0.06076611, age2 = 0, pack_years = 0.00299393,
                                                      smoking_status = 1.88052462, year = 0, asthma = 0),
                                             female = c(Intercept = -8.34076514, age = 0.04678374, age2 = 0, pack_years = 0.01402998,
                                                      smoking_status =  1.32274101, year = 0, asthma = 0))
  input_ref$COPD$ln_h_COPD_betas_by_sex <- "Amin's Iterative solution. Last Updated on 2017-09-07 (0.9.0)"


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


  input_help$lung_function$dfev1_sigmas <- "Sigmas in G Matrix for FEV1 decline"
  input$lung_function$dfev1_sigmas <- t(as.matrix(c(sigma1 = sqrt(0.1006), sigma2 = sqrt(0.000759))))
  input_ref$lung_function$dfev1_sigmas <- ""


  input_help$lung_function$dfev1_re_rho <- "Correlation coefficient between random-effect terms in the mixed-effects model of FEV1 decline"
  input$lung_function$dfev1_re_rho <- 0.09956332 # From G Matrix: 0.00087/(sqrt(0.1006)*sqrt(0.000759))
  input_ref$lung_function$dfev1_re_rho <- "G Matrix Zafari CMAJ 2016 - Modified"



  ## Exacerbation;

  input_help$exacerbation$ln_rate_betas = "Regression coefficients for the random-effects log-hazard model of exacerbation (of any severity)"
  input$exacerbation$ln_rate_betas = t(as.matrix(c(intercept = -2.1, female = 0, age = 0.04082 * 0.1, fev1 = -0, smoking_status = 0,
                                                   gold2 = 0.8, gold3p = 2)))
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
  input$exacerbation$logit_p_death_by_sex <- cbind(male = c(intercept = -13, age = log(1.05),  mild = 0, moderate = -2, severe = 7.4, very_severe = 8, n_hist_severe_exac = 0),
                                                   female = c(intercept = -13, age = log(1.05),  mild = 0, moderate = -2, severe = 7.4, very_severe = 8, n_hist_severe_exac = 0))
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
  input$cost$bg_cost_by_stage=t(as.matrix(c(N=0, I=144, II=430, III=628, IV=628)))
  input_help$cost$bg_cost_by_stage="Annual direct costs for non-COPD, and COPD by GOLD grades"
#  input$cost$ind_bg_cost_by_stage=t(as.matrix(c(N=0, I=40, II=80, III=134, IV=134))) #TODO Not implemented in C yet.
#  input_help$cost$ind_bg_cost_by_stage="Annual inddirect costs for non-COPD, and COPD by GOLD grades"
  input$cost$exac_dcost=t(as.matrix(c(mild=161,moderate=161,severe=6501, verysevere=6501)))
  input_help$cost$exac_dcost="Incremental direct costs of exacerbations by severity levels"

  #input$cost$doctor_visit_by_type<-t(as.matrix(c(50,150)))

  input$utility$bg_util_by_stage=t(as.matrix(c(N=0.85, I=0.81,II=0.72,III=0.67,IV=0.67)))
  input_help$utility$bg_util_by_stage="Background utilities for non-COPD, and COPD by GOLD grades"
#  input$utility$exac_dutil=t(as.matrix(c(mild=-0.07, moderate=-0.37/2, severe=-0.3)))
  input$utility$exac_dutil=cbind(
    gold1=c(mild=-0.00246, moderate=-0.00246, severe=-0.00797, verysevere=-0.00797),
    gold2=c(mild=-0.001698, moderate=-0.001698, severe=-0.00747, verysevere=-0.00747),
    gold3=c(mild=-0.00534, moderate=-0.00534, severe=-0.00717, verysevere=-0.00717),
    gold4=c(mild=-0.00534, moderate=-0.00534, severe=-0.00717, verysevere=-0.00717)
  );
  input_help$utility$exac_dutil="Incremental change in utility during exacerbations by severity level"

  input$manual$MORT_COEFF<-1
  input$manual$smoking$intercept_k<-1


  #Proportion of death by COPD that should be REMOVED from background mortality
  input$manual$explicit_mortality_by_age_sex<-cbind(
    #   0 for <35         35-39           40-44           45-49          50-54      55-59           60-64        65-69          70-74       75-79       80+
    male =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-0.00132,-0.000192428795552357,0.000257147320829132,0.000271227212785107,0.000435382466739466,0.000326930965567294,0.000108055893204873,0.000618904677838107,0.000449687079373819,0.000407010910871507,0.000497818931651111,0.000948868501275481,0.000869956243178709,0.000862589638387758,0.00108814884450936,0.00098819053116602,0.000817445342329688,0.000910637646998959,0.00109822713888443,0.00138360010837221,0.0016840001216008,0.00190752870460206,0.00199687601273131,0.00203898379799842,0.00237141952627013,0.00235296077898669,0.00248280302597937,0.00264510548033449,0.0031345921966757,0.00325750513217707,0.00352893365485422,0.00357874118696086,0.00330931907305822,0.00412559173778838,0.00504765619779635,0.00545588642367796,0.00649604493731815,0.00675348789969767,0.00652619891276281,0.00645558735660416,0.00808207905123483,0.00851153876781985,0.0088743752865835,0.0115982331791361,0.0140489641191684,0.0137615656081255,0.0143568965874517,0.0138488232261846,0.01808667794176,0.0186471355913765,0.0200497082536654,0.0226181915478259,0.0286137761129186,0.028359356219087,0.0404806806130972,0.0397497868972193,0.0379308701835575,0.0499167529794072,0.0547195662884387,0.0735219222855502,0.0674498098756862,0.114991248813968,0.0675003933848324,0.0839063012052854,0.176659052398659,0.0940538578908927,0.131042607704396,0.0871749930302215,0.28818689898759,-0.26154323498216,-0.560997710342556

)
    ,female =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.000146750995523261,0.000668765274468494,0.000812954594166732,0.000984019380347159,0.000285962014140024,0.000563227882497854,0.000804485941190143,0.000665218315642067,0.000839072235836068,0.00115591511539276,0.00107183465890956,0.00121812459236872,0.00135083595342536,0.0014163833507658,0.00144691264845482,0.00164260762804778,0.00156267711062897,0.001687586191402,0.00225716790414568,0.00214846224694652,0.00227938618965151,0.00262331396091859,0.00302435236642907,0.00270635968411142,0.00317903335322173,0.00358242829901853,0.00373603367097491,0.00418591591068962,0.00416366260827325,0.00426405638469407,0.00448081892096722,0.00564541392856702,0.00542487631552368,0.00550762448351334,0.00542863475021077,0.00624088913199001,0.00718443220848881,0.00801240991456567,0.00759194306722517,0.00726137218540649,0.00858991500057323,0.00938764340953272,0.0107178437473683,0.00893465522423165,0.00991881763310665,0.0110846249818337,0.014013226561789,0.0138266541378928,0.0179129166298439,0.0210712312824225,0.0180389005949242,0.0184315813323476,0.0200218077112527,0.0319103423425482,0.027066586530101,0.0358281081496245,0.0315542516406484,0.0527639598728097,0.048301593195766,0.0576091650495262,0.0713459106405255,0.0660100808721457,0.12927341533818,0.0956564697422835,0.134145215849941,0.113619843640465,0.0987951232316556,-0.0231759157309596,0.307844837353473,-0.835553814893533

    ))

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

  model_input <- list ("values" = input, "help" = input_help, "ref" = input_ref)
  return (model_input)
}

model_input <- init_input()
