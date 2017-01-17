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
  input$agent$p_prevalence_age<-c(rep(0,40),c(473.9  , #taken from CanSim.052-0005.xlsm for year 2015
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
  input$agent$p_incidence_age<-c(rep(0,40),c(1),0.01*exp(-(0:59)/5),rep(0,111-40-1-60))
  input$agent$p_incidence_age<-input$agent$p_incidence_age/sum(input$agent$p_incidence_age)
  
  input_help$agent$p_bgd_by_sex<-"Life table"
  input$agent$p_bgd_by_sex<-cbind(
    #male=(1+bitwAnd(1:111,1))/10000,
    #female=rep(10,111)/200
    male=c(0.00522,0.00030,0.00022,0.00017,0.00013,0.00011,0.00010,0.00009,0.00008,0.00008,0.00009,0.00010,0.00012,0.00015,0.00020,0.00028,0.00039,0.00051,0.00059,0.00066,0.00071,0.00075,0.00076,0.00076,0.00074,0.00071,0.00070,0.00069,0.00070,0.00071,0.00074,0.00078,0.00082,0.00086,0.00091,0.00096,0.00102,0.00108,0.00115,0.00123,0.00132,0.00142,0.00153,0.00165,0.00179,0.00194,0.00211,0.00229,0.00251,0.00275,0.00301,0.00331,0.00364,0.00401,0.00441,0.00484,0.00533,0.00586,0.00645,0.00709,0.00780,0.00859,0.00945,0.01040,0.01145,0.01260,0.01387,0.01528,0.01682,0.01852,0.02040,0.02247,0.02475,0.02726,0.03004,0.03310,0.03647,0.04019,0.04430,0.04883,0.05383,0.05935,0.06543,0.07215,0.07957,0.08776,0.09680,0.10678,0.11780,0.12997,0.14341,0.15794,0.17326,0.18931,0.20604,0.21839,0.23536,0.25290,0.27092,0.28933,0.30802,0.32687,0.34576,0.36457,0.38319,0.40149,0.41937,0.43673,0.45350,0.46960,1.00000)
    ,
    female=c(0.00449,0.00021,0.00016,0.00013,0.00010,0.00009,0.00008,0.00007,0.00007,0.00007,0.00008,0.00008,0.00009,0.00011,0.00014,0.00018,0.00022,0.00026,0.00028,0.00029,0.00030,0.00030,0.00031,0.00031,0.00030,0.00030,0.00030,0.00031,0.00032,0.00034,0.00037,0.00040,0.00043,0.00047,0.00051,0.00056,0.00060,0.00066,0.00071,0.00077,0.00084,0.00092,0.00100,0.00109,0.00118,0.00129,0.00140,0.00153,0.00166,0.00181,0.00197,0.00215,0.00235,0.00257,0.00280,0.00307,0.00336,0.00368,0.00403,0.00442,0.00485,0.00533,0.00586,0.00645,0.00710,0.00782,0.00862,0.00951,0.01051,0.01161,0.01284,0.01420,0.01573,0.01743,0.01934,0.02146,0.02384,0.02649,0.02947,0.03280,0.03654,0.04074,0.04545,0.05074,0.05669,0.06338,0.07091,0.07940,0.08897,0.09977,0.11196,0.12542,0.13991,0.15541,0.17190,0.18849,0.20653,0.22549,0.24526,0.26571,0.28671,0.30810,0.32970,0.35132,0.37280,0.39395,0.41461,0.43462,0.45386,0.47222,1.00000)
  )
  
  input$agent$l_inc_betas=t(as.matrix(c(intercept=-3.55,y=0.01,y2=0))); #intercept is the result ofmodel calibration
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
    male=c(intercept=-6,age=log(1.96)/10,age2=0,pack_years=log(1.20)/10,current_smoking=0,year=0,asthma=0),
    female=c(intercept=-6.2,age=log(1.94)/10,age2=0,pack_years=log(1.20)/10,current_smoking=0,year=0,asthma=0))
  input_help$COPD$logit_p_COPD_betas_by_sex<-"Logit of the probability of having COPD (FEV1/FVC<0.7) at time of creation (separately by sex)"
  input$COPD$ln_h_COPD_betas_by_sex<-cbind(
    male =c(Intercept =-6.65,age = 0.046 ,age2 = 0,pack_years = 0.016, smoking_status = 0,year = 0,asthma = 0)
    ,female =c(Intercept =-6.92 ,age = 0.05, age2 =0,pack_years = 0.016, smoking_status = 0 ,year = 0,asthma = 0))
 #  input$COPD$ln_h_COPD_betas_by_sex<-cbind(
  # male =c(Intercept =-6,age = 0.04048614 ,age2 = 0,pack_years = 0.01299697, smoking_status = 0,year = 0,asthma = 0)
   #,female =c(Intercept =-6.2 ,age = 0.04287276, age2 =0,pack_years = 0.01341118, smoking_status = 0 ,year = 0,asthma = 0))
#  input_help$COPD$ln_h_COPD_betas_by_sex<-"Log-hazard of developing COPD (FEV1/FVC<0.7) for those who did not have COPD at creation time (separately by sex)"
  
  
  ##Lung function
  input$lung_function$fev1_0_prev_betas_by_sex<-cbind(
    male=c(intercept=-1.969651,age=-0.027212,height=3.786599,pack_years=-0.005458,current_smoker=0,sgrq=0),
    female=c(intercept=-0.8339577 ,age=-0.0252077 ,height=2.7785297,pack_years=-0.0063040,current_smoker=0,sgrq=0))
  input_help$lung_function$fev1_0_prev_betas_by_sex<-"Regression (OLS) coefficients for mean of FEV1 at time of creation for those with COPD (separately by sex)"
  input$lung_function$fev1_0_prev_sd_by_sex<-c(male=0.6148,female=0.4242)
  input_help$lung_function$fev1_0_prev_sd_by_sex<-"SD of FEV1 at time of creation for those with COPD (separately by sex)"
  
  input$lung_function$fev1_0_inc_betas_by_sex<-cbind(
    male=c(intercept=-5.9429280+3.2719928*0.7,age=-0.0253224,height=4.7959326,pack_years=-0.0033031,current_smoker=0,sgrq=0),
    female=c(intercept=-3.1143794+2.1388758*0.7,age=-0.0234219,height=3.2741914,pack_years=-0.0032205,current_smoker=0,sgrq=0))
  input_help$lung_function$fev1_0_inc_betas_by_sex<-"Regression (OLS) coefficients for mean of FEV1 at time of development of COPD(separately by sex)"
  input$lung_function$fev1_0_inc_sd_by_sex<-c(male=0.54,female=0.36)
  input_help$lung_function$fev1_0_inc_sd_by_sex<-"SD of FEV1 at time of development of COPD (separately by sex)"
  
  #NHANES: input$lung_function$pred_fev1_betas_by_sex<-rbind(c(intercept=-0.7453,age=-0.04106,age2=0.004477,height2=0.00014098),c(-0.871,0.06537,0,0.00011496))
  
  input$lung_function$pred_fev1_betas_by_sex<-cbind(
    male=c(intercept=-2.06961, age=-0.03167, height=0.04215*100, reserved=0),
    female=c(intercept=-1.68697, age=-0.02773, height=0.03557*100, reserved=0))
  input_help$lung_function$pred_fev1_betas_by_sex<-"Coefficients for calculation of predicted FEV1 based on individual characteristics"
  
    
  input$lung_function$dfev1_betas<-t(as.matrix(c(intercept=-0.04,sex=0,age0=0,fev1_0=0,smoking=-0.0,time=-0)))
  input_help$lung_function$dfev1_betas<-"Regression equations (mixed-effects model) for rate of FEV1 decline"
  
  input$lung_function$dfev1_re_sds<-t(as.matrix(c(intercept=0.01,time=0)))
  input_help$lung_function$dfev1_re_sds<-"SD of random-effect terms in the mixed-effects model of FEV1 decline"
  input$lung_function$dfev1_re_rho<--0.5 
  input_help$lung_function$dfev1_re_rho<-"Correlation coefficient between random-effect terms in the mixed-effects model of FEV1 decline"
  
  


  ##Exacerbation;
  input$exacerbation$ln_rate_betas=t(as.matrix(c(intercept=1.2746-1.3256,female=0.1256,age=0.09066/10,fev1=-0.3159,smoking_status=0)))
  input_help$exacerbation$ln_rate_betas="Regression coefficients for the random-effects log-hazard model of exacerbation (of any severity)"
  input$exacerbation$logit_severity_betas=t(as.matrix(c(intercept1=2,intercept2=1.6655,female=-0.0431,age=-0.1685/10,fev1=-0.4279,smoking_status=0)))
  input_help$exacerbation$logit_severity_betas="Regression coefficients for the proportional odds model of exacerbation severity"
  
  input$exacerbation$ln_rate_intercept_sd=sqrt(0.6393)
  input_help$exacerbation$ln_rate_intercept_sd="SD of the random intercept for log-hazard of exacerbation"
  input$exacerbation$logit_severity_intercept_sd=sqrt(2.6560)
  input_help$exacerbation$logit_severity_intercept_sd="SD of the random intercept for proportional odds model of exacerbation severity"
  input$exacerbation$rate_severity_intercept_rho=-0.02162
  input_help$exacerbation$rate_severity_intercept_rho="Correlation coefficient between the random effect terms of rate and severity"
  
  input$exacerbation$exac_end_rate<-t(as.matrix(c(mild=365/5,moderate=365/10,severe=365/15)))
  input_help$exacerbation$exac_end_rate<-"Rate of ending of an exacerbation (inversely realted to exacerbation duration) according to severity level"
  
  input$exacerbation$p_death<-t(as.matrix(c(mild=0, moderate=0.01, severe=0.156)))
  input_help$exacerbation$p_death<-"Probability of deatth due to exacerbation according to its severity level"
  
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
    male =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-0.001606022,-0.001721182,-0.001819752,-0.002146852,-0.00216095,-0.002485366,-0.002706031,-0.002877154,-0.003034366,-0.003469705,-0.003651179,-0.003954358,-0.004331494,-0.004634207,-0.00496088,-0.005291894,-0.005780378,-0.006155577,-0.006722407,-0.007172968,-0.007724439,-0.008350107,-0.008766401,-0.009555234,-0.01012288,-0.01100497,-0.01156677,-0.01229621,-0.01293723,-0.01369846,-0.01432882,-0.01528052,-0.01656155,-0.0170177,-0.01841148,-0.01917625,-0.02023393,-0.02147138,-0.02245558,-0.02329407,-0.02437542,-0.0256063,-0.02656728,-0.02838095,-0.03011958,-0.03175774,-0.03394708,-0.03423261,-0.03840835,-0.04022946,-0.04102595,-0.04560408,-0.04524565,-0.05338276,-0.06014061,-0.06538362,-0.07304504,-0.0722152,-0.0765396,-0.07584602,-0.1078019,-0.09327656,0,0,0,0,0,0,0,0,0)
    ,female =c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-0.002033088,-0.002211023,-0.002353222,-0.002534367,-0.002806637,-0.002981846,-0.003295111,-0.00361843,-0.003932765,-0.004215818,-0.004720942,-0.005056373,-0.005376769,-0.005838936,-0.006269412,-0.006814707,-0.007456625,-0.007885078,-0.008656662,-0.009336134,-0.01006045,-0.01072995,-0.01162517,-0.01232033,-0.01319755,-0.01412953,-0.01527712,-0.01615174,-0.0171119,-0.01841287,-0.01990064,-0.02034583,-0.0223027,-0.02377605,-0.02477994,-0.02616677,-0.02736254,-0.02899826,-0.0301313,-0.03234479,-0.03393779,-0.03509401,-0.0365261,-0.03962095,-0.0399113,-0.04249013,-0.04543935,-0.04587082,-0.04723747,-0.05122213,-0.05296911,-0.05587932,-0.05834649,-0.06274314,-0.07038489,-0.07309963,-0.07794486,-0.08673318,-0.09298514,-0.100641,-0.1142307,-0.1178228,0,0,0,0,0,0,0,0,0)
  )
  #Carry the last observation forward up to age 111;
  input$manual$explicit_mortality_by_age_sex<-temp
  
  input$project_specific$ROC16_biomarker_threshold<-1
  input_help$project_specific$ROC16_biomarker_threshold<-"Threshold on the biomarker value that prompts treatment"
  input$project_specific$ROC16_biomarker_noise_sd<-0
  input_help$project_specific$ROC16_biomarker_noise_sd<-"SD of the multiplicative log-normally distirbuted noise arround the actual exacerbation rate - this noise is added to make the biomarker 'imperfect'"
  input$project_specific$ROC16_biomarker_cost<-100
  input_help$project_specific$ROC16_biomarker_cost<-"Cost of the biomarker (per patient)"
  input$project_specific$ROC16_treatment_cost<-4000
  input_help$project_specific$ROC16_treatment_cost<-"Cost of treatment that will reduce the exacerbation rate"
  input$project_specific$ROC16_treatment_RR<-0.75
  input_help$project_specific$ROC16_treatment_RR<-"Treatment effect (relative risk of future exacerbations after treatment is initiated"
  
  model_input<<-input
  model_input_help<<-input_help
}














tabulate_input<-function(input=model_input,input_help=model_input_help,show_values=FALSE)
{
  items<-get_list_elements(input)
  n<-length(items)
  out1<-items
  out2<-rep("",n)
  out3<-out2
  for(i in 1:n)
  {
    str=eval(parse(text=paste("input_help","$",items[i],sep="")))
    if(is.null(str)) out2[i]="<NO DESCRIPTION>" else out2[i]<-str
    if(show_values)
      out3[i]<-paste(eval(parse(text=paste("input","$",items[i],sep=""))),collapse=",")
  }
  out<-data.frame(Parameter=out1,Description=out2)
  if(show_values) out[,'Value']<-out3
  return(out)
}