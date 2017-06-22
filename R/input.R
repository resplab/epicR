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
init_input<-function()
{
  input<-list()
  input_help<-list()

  input$global_parameters<-list(
    age0=40,
    time_horizon=20,
    discount_cost=0.03,
    discount_qaly=0.03
  )
  input_help$global_parameters<-list(
    age0="Starting age in the model",
    time_horizon="Model time horizon",
    discount_cost="Discount value for cost outcomes",
    discount_qaly="Discount value for QALY outcomes"
  )



  input$agent$p_female<-0.5
  input_help$agent$p_female<-"Proportion of females in the population"

  input$agent$height_0_betas<-t(as.matrix(c(intercept=1.82657,sex=-0.13093,age=-0.00125,age2=0.00000231,sex_age=-0.00016510)))
  input_help$agent$height_0_betas<-"Regressoin coefficients for estimating height (in meters) at baseline"
  input$agent$height_0_sd<-0.06738
  input_help$agent$height_0_sd<-"SD representing heterogeneity in baseline height"

  input$agent$weight_0_betas<-t(as.matrix(c(intercept=50,sex=-5,age=0.1,age2=0,sex_age=0,height=1,year=0.01)))
  input_help$agent$weight_0_betas<-"Regressoin coefficients for estimating weiight (in Kg) at baseline"
  input$agent$weight_0_sd<-5
  input_help$agent$weight_0_sd<-"SD representing heterogeneity in baseline weight"
  input$agent$height_weight_rho<-0
  input_help$agent$height_weight_rho<-"Correlaiton coefficient between weight and height at baseline"

  input_help$agent$p_prevalence_age<-"Age pyramid at baseline (taken from CanSim.052-0005.xlsm for year 2015)"
  input$agent$p_prevalence_age<-c(rep(0,40),c(473.9*0  , #THANKS TO AMIN! taken from CanSim.052-0005.xlsm for year 2015
                                              462.7  ,
                                              463  ,
                                              469.3	,
                                              489.9	,
                                              486.3	,
                                              482.7	,
                                              479	,
                                              483.7	,
                                              509	,
                                              542.8	,
                                              557.7	,
                                              561.4	,
                                              549.7	,
                                              555.3	,
                                              544.6	,
                                              531.6	,
                                              523.9	,
                                              510.2	,
                                              494.1	,
                                              486.5	,
                                              465.6	,
                                              442.8	,
                                              424.6	,
                                              414.9	,
                                              404.3	,
                                              394.4	,
                                              391.5	,
                                              387.3	,
                                              330.9	,
                                              304.5	,
                                              292.2	,
                                              277.4	,
                                              255.1	,
                                              241.1	,
                                              223.2	,
                                              211.4	,
                                              198.8	,
                                              185.6	,
                                              178	,
                                              166.7	,
                                              155.2	,
                                              149.1	,
                                              140.6	,
                                              131.9	,
                                              119.7	,
                                              105.8	,
                                              95.4	,
                                              83.4	,
                                              73.2	,
                                              62.4	,
                                              52.3	,
                                              42.7	,
                                              34.7	,
                                              27	,
                                              19.9	,
                                              13.2	,
                                              8.8	,
                                              5.9	,
                                              3.8	,
                                              6.8
  ),rep(0,10));
  input$agent$p_prevalence_age<-input$agent$p_prevalence_age/sum(input$agent$p_prevalence_age)

  input_help$agent$p_incidence_age<-"Discrete distribution of age for the incidence population (population arriving after the first date) - generally estimated through calibration"
  input$agent$p_incidence_age<-c(rep(0,40),c(1),0.03*exp(-(0:59)/5),rep(0,111-40-1-60))
  #input$agent$p_incidence_age<-c(rep(0,40),c(1),0.0*exp(-(0:59)/5),rep(0,111-40-1-60))
  input$agent$p_incidence_age<-input$agent$p_incidence_age/sum(input$agent$p_incidence_age)

  input_help$agent$p_bgd_by_sex<-"Life table"
  input$agent$p_bgd_by_sex<-cbind(
    #male=(1+bitwAnd(1:111,1))/10000,
    #female=rep(10,111)/200
    male=c(0.00522,0.00030,0.00022,0.00017,0.00013,0.00011,0.00010,0.00009,0.00008,0.00008,0.00009,0.00010,0.00012,0.00015,0.00020,0.00028,0.00039,0.00051,0.00059,0.00066,0.00071,0.00075,0.00076,0.00076,0.00074,0.00071,0.00070,0.00069,0.00070,0.00071,0.00074,0.00078,0.00082,0.00086,0.00091,0.00096,0.00102,0.00108,0.00115,0.00123,0.00132,0.00142,0.00153,0.00165,0.00179,0.00194,0.00211,0.00229,0.00251,0.00275,0.00301,0.00331,0.00364,0.00401,0.00441,0.00484,0.00533,0.00586,0.00645,0.00709,0.00780,0.00859,0.00945,0.01040,0.01145,0.01260,0.01387,0.01528,0.01682,0.01852,0.02040,0.02247,0.02475,0.02726,0.03004,0.03310,0.03647,0.04019,0.04430,0.04883,0.05383,0.05935,0.06543,0.07215,0.07957,0.08776,0.09680,0.10678,0.11780,0.12997,0.14341,0.15794,0.17326,0.18931,0.20604,0.21839,0.23536,0.25290,0.27092,0.28933,0.30802,0.32687,0.34576,0.36457,0.38319,0.40149,0.41937,0.43673,0.45350,0.46960,1.00000)
    ,
    female=c(0.00449,0.00021,0.00016,0.00013,0.00010,0.00009,0.00008,0.00007,0.00007,0.00007,0.00008,0.00008,0.00009,0.00011,0.00014,0.00018,0.00022,0.00026,0.00028,0.00029,0.00030,0.00030,0.00031,0.00031,0.00030,0.00030,0.00030,0.00031,0.00032,0.00034,0.00037,0.00040,0.00043,0.00047,0.00051,0.00056,0.00060,0.00066,0.00071,0.00077,0.00084,0.00092,0.00100,0.00109,0.00118,0.00129,0.00140,0.00153,0.00166,0.00181,0.00197,0.00215,0.00235,0.00257,0.00280,0.00307,0.00336,0.00368,0.00403,0.00442,0.00485,0.00533,0.00586,0.00645,0.00710,0.00782,0.00862,0.00951,0.01051,0.01161,0.01284,0.01420,0.01573,0.01743,0.01934,0.02146,0.02384,0.02649,0.02947,0.03280,0.03654,0.04074,0.04545,0.05074,0.05669,0.06338,0.07091,0.07940,0.08897,0.09977,0.11196,0.12542,0.13991,0.15541,0.17190,0.18849,0.20653,0.22549,0.24526,0.26571,0.28671,0.30810,0.32970,0.35132,0.37280,0.39395,0.41461,0.43462,0.45386,0.47222,1.00000)
  )

  input$agent$l_inc_betas=t(as.matrix(c(intercept=-3.55,y=0.01,y2=0))); #intercept is the result of model calibration
  input_help$agent$l_inc_betas="Ln of incidence rate of the new population - Calibration target to keep populatoin size and age pyramid in line with calibration"
  input$agent$ln_h_bgd_betas=t(as.matrix(c(intercept=0,y=-0.025,y2=0,age=0,b_mi=0.1,n_mi=0,b_stroke=0.1,n_stroke=0,hf=0.1)));
  input_help$agent$ln_h_bgd_betas="Effect of variables on background mortality"


  ###smoking;
  input$smoking$logit_p_current_smoker_0_betas<-t(as.matrix(c(Intercept=-0.53,sex=-0.22,age=-0.02,age2=0,sex_age=0,sex_age2=0,year=-0.02)));
    input_help$smoking$logit_p_current_smoker_0_betas<-"Probability of being a current smoker at the time of creation"
  input$smoking$logit_p_ever_smoker_con_not_current_0_betas<-t(as.matrix(c(intercept=0,sex=0,age=0,age2=0,sex_age=0,sex_age2=0,year=-0.02)));
    input_help$smoking$logit_p_ever_smoker_con_not_current_0_betas<-"Probability of being an ever smoker conditional on not being current smoker, at the time of creation"
  input$smoking$pack_years_0_betas<-t(as.matrix(c(intercept=-5,sex=-2,age=0.8,year=-0.1,current_smoker=1)));
    input_help$smoking$pack_years_0_betas<-"Regression equations for determining the pack-years of smoking at the time of creation (for elogit_p_ever_smoker_con_current_0_betas smokers)"
  input$smoking$pack_years_0_sd<-5;
    input_help$smoking$pack_years_0_sd<-"Standard deviation for variation in pack-years among individuals (current or former smokers)";
  input$smoking$ln_h_inc_betas<-c(intercept=-4,sex=-0.15,age=-0.02,age2=0,calendar_time=-0.02);
    input_help$smoking$ln_h_inc_betas<-"Log-hazard of starting smoking (incidence or relapse)"
  input$smoking$ln_h_ces_betas<-c(intercept=-3,sex=0,age=0,age2=0,calendar_time=0);
    input_help$smoking$ln_h_ces_betas<-"Log-hazard of smoking cessation"


  ##COPD
  input$COPD$logit_p_COPD_betas_by_sex<-cbind(
    male=c(intercept=-5.337997,age= 0.044918,age2=0,pack_years= 0.018734,current_smoking=1.093586,year=0,asthma=0), #Updated on 2017-04-19 for LLN based on Shahzad's calculations on CanCold. See https://github.com/aminadibi/epicR/issues/8
    female=c(intercept=-4.377285,age=0.031689,age2=0,pack_years=0.025183,current_smoking=0.636127,year=0,asthma=0)) #Updated on 2017-04-19 for LLN based on Shahzad's calculations on CanCold. See https://github.com/aminadibi/epicR/issues/8
  input_help$COPD$logit_p_COPD_betas_by_sex<-"Logit of the probability of having COPD (FEV1/FVC<0.7) at time of creation (separately by sex)"
  input$COPD$ln_h_COPD_betas_by_sex<-cbind(
    male =c(Intercept = -8.341626527, age = 0.053539987,age2 = 0,pack_years = 0.004274558 , smoking_status = 1.523356867 ,year = 0,asthma = 0) # Updated on 2017-05-03 (v0.3.0)
    ,female =c(Intercept = -7.40741695, age = 0.03751128, age2 =0,pack_years = 0.01995802, smoking_status = 0.92879076 ,year = 0,asthma = 0)) # Updated on 2017-05-03 (v0.3.0)
  input_help$COPD$ln_h_COPD_betas_by_sex<-"Log-hazard of developing COPD (FEV1/FVC<LLN) for those who did not have COPD at creation time (separately by sex)"


  ##Lung function
  input$lung_function$fev1_0_prev_betas_by_sex<-cbind(
    male=c(intercept=1.546161,age=-0.031296,height_sq=1.012579,pack_years=-0.006925,current_smoker=0,sgrq=0),  #Updated on 2017-04-19 for LLN based on Shahzad's calculations. See https://github.com/aminadibi/epicR/issues/8
    female=c(intercept= 1.329805 ,age=-0.031296 ,height_sq=1.012579,pack_years=-0.006925,current_smoker=0,sgrq=0))  #Updated on 2017-04-19 for LLN based on Shahzad's calculations. See https://github.com/aminadibi/epicR/issues/8
  input_help$lung_function$fev1_0_prev_betas_by_sex<-"Regression (OLS) coefficients for mean of FEV1 at time of creation for those with COPD (separately by sex)"

   input$lung_function$fev1_0_prev_sd_by_sex<-c(male=0.6148,female=0.4242)
  input_help$lung_function$fev1_0_prev_sd_by_sex<-"SD of FEV1 at time of creation for those with COPD (separately by sex)"

  input$lung_function$fev1_0_inc_betas_by_sex<-cbind(
    male=c(intercept= 1.4895-0.6831,age=-0.0322,height_sq=1.27,pack_years=-0.00428,current_smoker=0,sgrq=0),# Updated on 2017-04-19 for LLN based on Shahzad's calculations. See https://github.com/aminadibi/epicR/issues/8
    female=c(intercept=1.5737-0.425,age=-0.0275,height_sq=0.97,pack_years=-0.00465 ,current_smoker=0,sgrq=0)) # Updated on 2017-04-19 for LLN based on Shahzad's calculations. See https://github.com/aminadibi/epicR/issues/8

  input_help$lung_function$fev1_0_inc_betas_by_sex<-"Regression (OLS) coefficients for mean of FEV1 at time of development of COPD(separately by sex)"
  input$lung_function$fev1_0_inc_sd_by_sex<-c(male=0.54,female=0.36)
  input_help$lung_function$fev1_0_inc_sd_by_sex<-"SD of FEV1 at time of development of COPD (separately by sex)"


  input$lung_function$fev1_0_ZafarCMAJ_by_sex<-cbind(
    male=c(intercept=1421.2e-3+462.5e-3, baseline_age=-5.19e-3, baseline_weight_kg=-0.11e-3 ,height=-1760.3e-3, height_sq=1893.1e-3, current_smoker=-77.22e-3, age_height_sq=-8.2e-3, followup_time = 0),
    female=c(intercept=1421.2e-3, baseline_age=-5.19e-3, baseline_weight_kg=-0.11e-3, height=-1760.3e-3, height_sq=1893.1e-3, current_smoker=-77.22e-3, age_height_sq=-8.2e-3, followup_time = 0))
  input_help$lung_function$fev1_0_ZafarCMAJ_by_sex<-"Regression coefficients for mean of FEV1 at time of creation with COPD or development of COPD based on Zafar's CMAJ. Used for conditional normal distribution in FEV1 decline equations.  (separately by sex)"


  #NHANES: input$lung_function$pred_fev1_betas_by_sex<-rbind(c(intercept=-0.7453,age=-0.04106,age2=0.004477,height2=0.00014098),c(-0.871,0.06537,0,0.00011496))

  input$lung_function$pred_fev1_betas_by_sex<-cbind(
  #  male=c(intercept=-2.06961, age=-0.03167, height=0.04215*100, reserved=0),
   # female=c(intercept=-1.68697, age=-0.02773, height=0.03557*100, reserved=0))
    male=c(intercept= 0.5536, age=-0.01303, age_sq=-0.000172, height=1.4098),
    female=c(intercept= 0.4333, age=-0.00361, age_sq=-0.000194 ,height=1.1496))
  input_help$lung_function$pred_fev1_betas_by_sex<-"Coefficients for calculation of predicted FEV1 based on individual characteristics"


  #input$lung_function$dfev1_betas<-t(as.matrix(c(intercept=-0.04,sex=0,age0=0,fev1_0=0,smoking=-0.0,time=-0)))

  input$lung_function$fev1_betas_by_sex<-cbind(
    male=c(intercept=-177.9e-3-8.86e-3, baseline_age=2.31e-3, baseline_weight_kg=0.15e-3 ,height=74.13e-3, height_sq=11.39e-3, current_smoker=-25.79e-3, age_height_sq=-0.92e-3, followup_time = -0.44e-3),
    female=c(intercept=-177.9e-3, baseline_age=2.31e-3, baseline_weight_kg=0.15e-3, height=74.13e-3, height_sq=11.39e-3, current_smoker=-25.79e-3, age_height_sq=-0.92e-3, followup_time = -0.44e-3))
  input_help$lung_function$dfev1_betas<-"Regression equations (mixed-effects model) for rate of FEV1 decline"

  input$lung_function$dfev1_re_sds<-t(as.matrix(c(intercept=0.0,time=0)))
  input_help$lung_function$dfev1_re_sds<-"SD of random-effect terms in the mixed-effects model of FEV1 decline"
  input$lung_function$dfev1_re_rho<--0
  input_help$lung_function$dfev1_re_rho<-"Correlation coefficient between random-effect terms in the mixed-effects model of FEV1 decline"




  ##Exacerbation;

  input$exacerbation$ln_rate_betas=t(as.matrix(c(intercept=-0.785,female=0.174353,age=0.04082*0.1,fev1=-0,smoking_status=0,gold2=0.46,gold3p=0.65)))   #Najafzadeh et al (2012). Only function of GOLD for minimalism
  input_help$exacerbation$ln_rate_betas="Regression coefficients for the random-effects log-hazard model of exacerbation (of any severity)"
  input$exacerbation$logit_severity_betas=t(as.matrix(c(intercept1=1.091,intercept2=1.902, intercept3=5.208, female=-0.0431,age=-0.0076,fev1=-0.002945,smoking_status=0, pack_years=-0.001127, BMI=0.017820)))
  input_help$exacerbation$logit_severity_betas="Regression coefficients for the proportional odds model of exacerbation severity"

  input$exacerbation$ln_rate_intercept_sd=sqrt(0.55)
  input_help$exacerbation$ln_rate_intercept_sd="SD of the random intercept for log-hazard of exacerbation"
  input$exacerbation$logit_severity_intercept_sd=sqrt(2.0736)
  input_help$exacerbation$logit_severity_intercept_sd="SD of the random intercept for proportional odds model of exacerbation severity"
  input$exacerbation$rate_severity_intercept_rho=-0
  input_help$exacerbation$rate_severity_intercept_rho="Correlation coefficient between the random effect terms of rate and severity"

  input$exacerbation$exac_end_rate<-t(as.matrix(c(mild=365/5,moderate=365/5,severe=365/5, verysevere=365/5)))
  input_help$exacerbation$exac_end_rate<-"Rate of ending of an exacerbation (inversely realted to exacerbation duration) according to severity level"

  input$exacerbation$p_death<-t(as.matrix(c(mild=0, moderate=0, severe=0.046,verysevere=0.046))) #Based on Shahzad
  input_help$exacerbation$p_death<-"Probability of death due to exacerbation according to its severity level"

  #Outpatient;
  input$outpatient$rate_doctor_visit<-0.1
  input$outpatient$p_specialist<-0.1





  #medication
  #log-hazard regression matrix for initiation of each medication

  template=c(int=0,sex=0,age=0,med_class=rep(0,length(medication_classes)))
  mx<-NULL
  for(i in medication_classes)
    mx<-rbind(mx,template)

  input$medication$ln_h_start_betas_by_class<-mx
  input$medication$ln_h_stop_betas_by_class<-mx
  input$medication$ln_rr_exac_by_class<-rep(log(1),length(medication_classes))  #TODO: update this to represent different medication effect


  ###comorbidity
  #mi
  input$comorbidity$logit_p_mi_betas_by_sex=cbind(
    male=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.0, gold=0.05),
    female=c(intercept=-3000, age=0.001, age2=0, pack_years=0.01, smoking=0.001, calendar_time=0, bmi=0.0, gold=0.05)
  );
  input$comorbidity$ln_h_mi_betas_by_sex=cbind(
    male=c(intercept=-10000.748, age=0.1133, age2=-0.000440, pack_years=0.01, smoking=0.70953, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0.5, n_mi=0.0),
    female=c(intercept=-30000, age=0.001, age2=0, pack_years=0.01, smoking=0.61868, calendar_time=0, bmi=0.01, gold=0.05, b_mi=0, n_mi=0.01)
  );
  input$comorbidity$p_mi_death<-0.05;


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


  #Proportion of death by COPD that should be REMOVED from background mortality (http://vizhub.healthdata.org/cod/)
  temp<-cbind(
    #   0 for <35         35-39           40-44           45-49          50-54      55-59           60-64        65-69          70-74       75-79       80+
    male =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9.46849697157667e-05,0.000138766898756498,0.000164683305206475,0.000118672376787121,0.000248047700914157,0.000147870248196501,0.000177276089311144,0.000238443358118927,8.75836320216651e-05,0.000193485135610199,9.61001247608007e-05,0.000113247259993993,0.000180439524654865,7.77661643360447e-05,-1.58873075129943e-05,-4.06581010760094e-06,2.10738684917637e-05,-0.00011208257036614,-0.000221927707625972,-0.000215507629286613,-0.000455480350484299,-0.000467621409178368,-0.00066672397929024,-0.000617726906312387,-0.000931111690915826,-0.00112044474350589,-0.00126345849942418,-0.00181415527876831,-0.00214589971516534,-0.00227769765283942,-0.00281190348987817,-0.00296807125811665,-0.00337529169845254,-0.00400045454581269,-0.00447401102598177,-0.00492079705392738,-0.00572319443414398,-0.00692988040355495,-0.00713814037330796,-0.00833675432685788,-0.00873141678858643,-0.0101844728443815,-0.0114190706686127,-0.012235476214616,-0.0133348016105009,-0.0154552028430692,-0.0167334208489822,-0.0188374499578638,-0.0183257873563456,-0.0204294487958117,-0.0227681322724707,-0.0224648647614399,-0.0232266429901738,-0.0246689284771831,-0.0253879976538823,-0.02287155640141,-0.0250313928500381,-0.0230009600400853,-0.0283679381476064,-0.0275989677091063,-0.0240792248125702,-0.0153804069630081,-0.0193565522701748,-0.00780182690287906,-0.0240190122091741,-0.00780144824238765,0.00340791627175097,0.0122996662898819,0.00395570135666701,-0.0065559128642384,-0.764750741665919
)
    ,female =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.000475676886190955,0.00048190815311309,0.000577446706519459,0.000505564826332088,0.000576743707946104,0.000611641253120694,0.000635425763252806,0.000623487726037895,0.000621469343860466,0.000740802993809405,0.000789510290106238,0.00081660987410852,0.000864214854456994,0.000722022265899845,0.000961409549717451,0.000921474059839721,0.000883952042428452,0.000800855092904645,0.000934678124083467,0.000833474788032481,0.0008547820559751,0.000811677770299841,0.000750112058826919,0.00068236471145545,0.000682112673125412,0.000561231108367644,0.000423445289409193,0.000275452099961635,0.000177047200400252,0.000137110724680783,-0.000122325725685426,-0.000284644038556874,-0.000568106553179317,-0.000975304761717737,-0.00135775485236645,-0.00160198776146406,-0.00228105090275092,-0.00233268564153662,-0.00341267736934531,-0.00386901566488117,-0.00518635124653825,-0.00555119204496399,-0.00706158047124296,-0.00795240796124318,-0.00846098784273831,-0.00976041172214538,-0.0109383551977919,-0.0130544285506496,-0.0146007627149521,-0.0164682325603041,-0.0182661502898543,-0.0211366212302585,-0.02228277318772,-0.0243748235200433,-0.0267877003888109,-0.0255621003648333,-0.0292873368649903,-0.0319826821666682,-0.0290586441054032,-0.0284574053731152,-0.0287947360367167,-0.0257359620733139,-0.0336498010470379,-0.0252880038156065,-0.017772283450986,-0.0254089311575336,-0.0107837554153603,0.00673402510744414,-0.0296791566293115,-0.0224017816917056,-0.8022093744137
))
  #Carry the last observation forward up to age 111;
  input$manual$explicit_mortality_by_age_sex<-temp

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
}
