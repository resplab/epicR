/**
 * @file model_input.cpp
 * @brief Input parameter management for the EPIC model
 *
 * This module handles getting and setting input parameters that configure
 * the COPD simulation model behavior.
 */

#include "epic_model.h"

////////////////////////////////////////////////////////////////////////////////
// INPUT PARAMETER FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

//' Returns inputs
//' @return all inputs
//' @export
// [[Rcpp::export]]
List Cget_inputs()
{
  List out=Rcpp::List::create(
    Rcpp::Named("global_parameters")=Rcpp::List::create(
      Rcpp::Named("age0")=input.global_parameters.age0,
      Rcpp::Named("time_horizon")=input.global_parameters.time_horizon,
      Rcpp::Named("y0")=input.global_parameters.y0,
      Rcpp::Named("discount_cost")=input.global_parameters.discount_cost,
      Rcpp::Named("discount_qaly")=input.global_parameters.discount_qaly,
      Rcpp::Named("closed_cohort")=input.global_parameters.closed_cohort
    ),
    Rcpp::Named("agent")=Rcpp::List::create(
      Rcpp::Named("p_female")=input.agent.p_female,
      Rcpp::Named("height_0_betas")=AS_VECTOR_DOUBLE(input.agent.height_0_betas),
      Rcpp::Named("height_0_sd")=input.agent.height_0_sd,
      Rcpp::Named("weight_0_betas")=AS_VECTOR_DOUBLE(input.agent.weight_0_betas),
      Rcpp::Named("weight_0_sd")=input.agent.weight_0_sd,
      Rcpp::Named("height_weight_rho")=input.agent.height_weight_rho,

      Rcpp::Named("p_prevalence_age")=AS_VECTOR_DOUBLE(input.agent.p_prevalence_age),
      Rcpp::Named("p_incidence_age")=AS_VECTOR_DOUBLE(input.agent.p_incidence_age),
      Rcpp::Named("p_bgd_by_sex")=AS_MATRIX_DOUBLE(input.agent.p_bgd_by_sex),
      Rcpp::Named("l_inc_betas")=AS_VECTOR_DOUBLE(input.agent.l_inc_betas),
      Rcpp::Named("ln_h_bgd_betas")=AS_VECTOR_DOUBLE(input.agent.ln_h_bgd_betas)
    ),
    Rcpp::Named("smoking")=Rcpp::List::create(
      Rcpp::Named("logit_p_current_smoker_0_betas")=AS_VECTOR_DOUBLE(input.smoking.logit_p_current_smoker_0_betas),
      Rcpp::Named("logit_p_never_smoker_con_not_current_0_betas")=AS_VECTOR_DOUBLE(input.smoking.logit_p_never_smoker_con_not_current_0_betas),
      Rcpp::Named("pack_years_0_betas")=AS_VECTOR_DOUBLE(input.smoking.pack_years_0_betas),
      Rcpp::Named("pack_years_0_sd")=input.smoking.pack_years_0_sd,
      Rcpp::Named("ln_h_inc_betas")=AS_VECTOR_DOUBLE(input.smoking.ln_h_inc_betas),
      Rcpp::Named("minimum_smoking_prevalence")=input.smoking.minimum_smoking_prevalence,
      Rcpp::Named("mortality_factor_current")=AS_VECTOR_DOUBLE(input.smoking.mortality_factor_current),
      Rcpp::Named("mortality_factor_former")=AS_VECTOR_DOUBLE(input.smoking.mortality_factor_former),
      Rcpp::Named("ln_h_ces_betas")=AS_VECTOR_DOUBLE(input.smoking.ln_h_ces_betas),
      Rcpp::Named("smoking_ces_coefficient")=input.smoking.smoking_ces_coefficient,
      Rcpp::Named("smoking_cessation_adherence")=input.smoking.smoking_cessation_adherence
    ),
    Rcpp::Named("COPD")=Rcpp::List::create(
      Rcpp::Named("ln_h_COPD_betas_by_sex")=AS_MATRIX_DOUBLE(input.COPD.ln_h_COPD_betas_by_sex),
      Rcpp::Named("logit_p_COPD_betas_by_sex")=AS_MATRIX_DOUBLE(input.COPD.logit_p_COPD_betas_by_sex)
    ),
    Rcpp::Named("lung_function")=Rcpp::List::create(
      Rcpp::Named("pred_fev1_betas_by_sex")=AS_MATRIX_DOUBLE(input.lung_function.pred_fev1_betas_by_sex),
      Rcpp::Named("fev1_0_prev_betas_by_sex")=AS_MATRIX_DOUBLE(input.lung_function.fev1_0_prev_betas_by_sex),
      Rcpp::Named("fev1_0_prev_sd_by_sex")=AS_VECTOR_DOUBLE(input.lung_function.fev1_0_prev_sd_by_sex),
      Rcpp::Named("fev1_0_inc_betas_by_sex")=AS_MATRIX_DOUBLE(input.lung_function.fev1_0_prev_betas_by_sex),
      Rcpp::Named("fev1_0_inc_sd_by_sex")=AS_VECTOR_DOUBLE(input.lung_function.fev1_0_prev_sd_by_sex),
      Rcpp::Named("fev1_betas_by_sex")=AS_MATRIX_DOUBLE(input.lung_function.fev1_betas_by_sex),
      Rcpp::Named("fev1_0_ZafarCMAJ_by_sex")=AS_MATRIX_DOUBLE(input.lung_function.fev1_0_ZafarCMAJ_by_sex),
      Rcpp::Named("dfev1_sigmas")=AS_VECTOR_DOUBLE(input.lung_function.dfev1_sigmas),
      Rcpp::Named("dfev1_re_rho")=input.lung_function.dfev1_re_rho
    ),
    Rcpp::Named("exacerbation")=Rcpp::List::create(
      Rcpp::Named("ln_rate_betas")=AS_VECTOR_DOUBLE(input.exacerbation.ln_rate_betas),
      Rcpp::Named("logit_severity_betas")=AS_VECTOR_DOUBLE(input.exacerbation.logit_severity_betas),
      Rcpp::Named("ln_rate_intercept_sd")=input.exacerbation.ln_rate_intercept_sd,
      Rcpp::Named("logit_severity_intercept_sd")=input.exacerbation.logit_severity_intercept_sd,
      Rcpp::Named("rate_severity_intercept_rho")=input.exacerbation.rate_severity_intercept_rho,
      Rcpp::Named("exac_end_rate")=AS_VECTOR_DOUBLE(input.exacerbation.exac_end_rate),
      Rcpp::Named("logit_p_death_by_sex")=AS_MATRIX_DOUBLE(input.exacerbation.logit_p_death_by_sex)
    ),
    Rcpp::Named("symptoms")=Rcpp::List::create(
      Rcpp::Named("logit_p_cough_COPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_cough_COPD_by_sex),
      Rcpp::Named("logit_p_cough_nonCOPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_cough_nonCOPD_by_sex),
      Rcpp::Named("logit_p_phlegm_COPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_phlegm_COPD_by_sex),
      Rcpp::Named("logit_p_phlegm_nonCOPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_phlegm_nonCOPD_by_sex),
      Rcpp::Named("logit_p_dyspnea_COPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_dyspnea_COPD_by_sex),
      Rcpp::Named("logit_p_dyspnea_nonCOPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_dyspnea_nonCOPD_by_sex),
      Rcpp::Named("logit_p_wheeze_COPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_wheeze_COPD_by_sex),
      Rcpp::Named("logit_p_wheeze_nonCOPD_by_sex")=AS_MATRIX_DOUBLE(input.symptoms.logit_p_wheeze_nonCOPD_by_sex),
      Rcpp::Named("covariance_COPD")=AS_MATRIX_DOUBLE(input.symptoms.covariance_COPD),
      Rcpp::Named("covariance_nonCOPD")=AS_MATRIX_DOUBLE(input.symptoms.covariance_nonCOPD)
    ),
    Rcpp::Named("outpatient")=Rcpp::List::create(
      Rcpp::Named("rate_doctor_visit")=input.outpatient.rate_doctor_visit,
      Rcpp::Named("p_specialist")=input.outpatient.p_specialist,
      Rcpp::Named("ln_rate_gpvisits_nonCOPD_by_sex")=AS_MATRIX_DOUBLE(input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex),
      Rcpp::Named("ln_rate_gpvisits_COPD_by_sex")=AS_MATRIX_DOUBLE(input.outpatient.ln_rate_gpvisits_COPD_by_sex),
      Rcpp::Named("dispersion_gpvisits_COPD")=input.outpatient.dispersion_gpvisits_COPD,
      Rcpp::Named("dispersion_gpvisits_nonCOPD")=input.outpatient.dispersion_gpvisits_nonCOPD
    ),
    Rcpp::Named("diagnosis")=Rcpp::List::create(
      Rcpp::Named("logit_p_prevalent_diagnosis_by_sex")=AS_MATRIX_DOUBLE(input.diagnosis.logit_p_prevalent_diagnosis_by_sex),
      Rcpp::Named("logit_p_diagnosis_by_sex")=AS_MATRIX_DOUBLE(input.diagnosis.logit_p_diagnosis_by_sex),
      Rcpp::Named("p_hosp_diagnosis")=input.diagnosis.p_hosp_diagnosis,
      Rcpp::Named("logit_p_overdiagnosis_by_sex")=AS_MATRIX_DOUBLE(input.diagnosis.logit_p_overdiagnosis_by_sex),
      Rcpp::Named("p_correct_overdiagnosis")=input.diagnosis.p_correct_overdiagnosis,
      Rcpp::Named("p_case_detection")=AS_VECTOR_DOUBLE(input.diagnosis.p_case_detection),
      Rcpp::Named("case_detection_start_end_yrs")=AS_VECTOR_DOUBLE(input.diagnosis.case_detection_start_end_yrs),
      Rcpp::Named("years_btw_case_detection")=input.diagnosis.years_btw_case_detection,
      Rcpp::Named("min_cd_age")=input.diagnosis.min_cd_age,
      Rcpp::Named("min_cd_pack_years")=input.diagnosis.min_cd_pack_years,
      Rcpp::Named("min_cd_symptoms")=input.diagnosis.min_cd_symptoms,
      Rcpp::Named("case_detection_methods")=AS_MATRIX_DOUBLE(input.diagnosis.case_detection_methods),
      Rcpp::Named("case_detection_methods_eversmokers")=AS_MATRIX_DOUBLE(input.diagnosis.case_detection_methods_eversmokers),
      Rcpp::Named("case_detection_methods_symptomatic")=AS_MATRIX_DOUBLE(input.diagnosis.case_detection_methods_symptomatic)
    ),
    Rcpp::Named("comorbidity")=Rcpp::List::create(
      Rcpp::Named("logit_p_mi_betas_by_sex")=AS_MATRIX_DOUBLE(input.comorbidity.logit_p_mi_betas_by_sex),
      Rcpp::Named("ln_h_mi_betas_by_sex")=AS_MATRIX_DOUBLE(input.comorbidity.ln_h_mi_betas_by_sex),
      Rcpp::Named("p_mi_death")=input.comorbidity.p_mi_death,
      Rcpp::Named("logit_p_stroke_betas_by_sex")=AS_MATRIX_DOUBLE(input.comorbidity.logit_p_stroke_betas_by_sex),
      Rcpp::Named("ln_h_stroke_betas_by_sex")=AS_MATRIX_DOUBLE(input.comorbidity.ln_h_stroke_betas_by_sex),
      Rcpp::Named("p_stroke_death")=input.comorbidity.p_stroke_death,
      Rcpp::Named("logit_p_hf_betas_by_sex")=AS_MATRIX_DOUBLE(input.comorbidity.logit_p_hf_betas_by_sex),
      Rcpp::Named("ln_h_hf_betas_by_sex")=AS_MATRIX_DOUBLE(input.comorbidity.ln_h_hf_betas_by_sex)
    ),
    Rcpp::Named("cost")=Rcpp::List::create(
      Rcpp::Named("bg_cost_by_stage")=AS_VECTOR_DOUBLE(input.cost.bg_cost_by_stage),
      Rcpp::Named("exac_dcost")=AS_VECTOR_DOUBLE(input.cost.exac_dcost),
      Rcpp::Named("cost_case_detection")=input.cost.cost_case_detection,
      Rcpp::Named("cost_outpatient_diagnosis")=input.cost.cost_outpatient_diagnosis,
      Rcpp::Named("cost_gp_visit")=input.cost.cost_gp_visit,
      Rcpp::Named("cost_smoking_cessation")=input.cost.cost_smoking_cessation,
      Rcpp::Named("doctor_visit_by_type")=AS_VECTOR_DOUBLE(input.cost.doctor_visit_by_type)
    ),
    Rcpp::Named("utility")=Rcpp::List::create(
      Rcpp::Named("bg_util_by_stage")=AS_VECTOR_DOUBLE(input.utility.bg_util_by_stage),
      Rcpp::Named("exac_dutil")=AS_MATRIX_DOUBLE(input.utility.exac_dutil)
    ),
    Rcpp::Named("medication")=Rcpp::List::create(
      Rcpp::Named("medication_ln_hr_exac")=AS_VECTOR_DOUBLE(input.medication.medication_ln_hr_exac),
      Rcpp::Named("medication_costs")=AS_VECTOR_DOUBLE(input.medication.medication_costs),
      Rcpp::Named("medication_utility")=AS_VECTOR_DOUBLE(input.medication.medication_utility),
      Rcpp::Named("medication_adherence")=input.medication.medication_adherence,
      Rcpp::Named("ln_h_start_betas_by_class")=AS_MATRIX_DOUBLE(input.medication.ln_h_start_betas_by_class),
      Rcpp::Named("ln_h_stop_betas_by_class")=AS_MATRIX_DOUBLE(input.medication.ln_h_stop_betas_by_class),
      Rcpp::Named("ln_rr_exac_by_class")=AS_VECTOR_DOUBLE(input.medication.ln_rr_exac_by_class)
    ),
    Rcpp::Named("project_specific")=Rcpp::List::create(
      //Put your project-specific outputs here;
    )
  );

  return(out);
}


//' Sets input variables.
//' @param name a string
//' @param value a number
//' @return 0 if successful
//' @export
// [[Rcpp::export]]
int Cset_input_var(std::string name, NumericVector value)
{
  if(name=="global_parameters$age0") {input.global_parameters.age0=value[0]; return(0);}
  if(name=="global_parameters$time_horizon")  {input.global_parameters.time_horizon=value[0]; return(0);}
  if(name=="global_parameters$discount_cost") {input.global_parameters.discount_cost=value[0]; return(0);}
  if(name=="global_parameters$discount_qaly") {input.global_parameters.discount_qaly=value[0]; return(0);}
  if(name=="global_parameters$closed_cohort") {input.global_parameters.closed_cohort=value[0]; return(0);}

  if(name=="agent$p_female") {input.agent.p_female=value[0]; return(0);}
  if(name=="agent$p_prevalence_age") READ_R_VECTOR(value,input.agent.p_prevalence_age);
  if(name=="agent$height_0_betas") READ_R_VECTOR(value,input.agent.height_0_betas);
  if(name=="agent$height_0_sd") {input.agent.height_0_sd=value[0]; return(0);}
  if(name=="agent$weight_0_betas") READ_R_VECTOR(value,input.agent.weight_0_betas);
  if(name=="agent$weight_0_sd") {input.agent.weight_0_sd=value[0]; return(0);}
  if(name=="agent$height_weight_rho") {input.agent.height_weight_rho=value[0]; return(0);}

  if(name=="agent$p_incidence_age") READ_R_VECTOR(value,input.agent.p_incidence_age);
  if(name=="agent$p_bgd_by_sex") READ_R_MATRIX(value,input.agent.p_bgd_by_sex);
  if(name=="agent$l_inc_betas") READ_R_VECTOR(value,input.agent.l_inc_betas);
  if(name=="agent$ln_h_bgd_betas") READ_R_VECTOR(value,input.agent.ln_h_bgd_betas);

  if(name=="smoking$logit_p_current_smoker_0_betas") READ_R_VECTOR(value,input.smoking.logit_p_current_smoker_0_betas);
  if(name=="smoking$logit_p_never_smoker_con_not_current_0_betas") READ_R_VECTOR(value,input.smoking.logit_p_never_smoker_con_not_current_0_betas);
  if(name=="smoking$pack_years_0_betas") READ_R_VECTOR(value,input.smoking.pack_years_0_betas);
  if(name=="smoking$pack_years_0_sd") {input.smoking.pack_years_0_sd=value[0]; return(0);}
  if(name=="smoking$ln_h_inc_betas") READ_R_VECTOR(value,input.smoking.ln_h_inc_betas);
  if(name=="smoking$minimum_smoking_prevalence") {input.smoking.minimum_smoking_prevalence=value[0]; return(0);}
  if(name=="smoking$mortality_factor_current") READ_R_VECTOR(value,input.smoking.mortality_factor_current);
  if(name=="smoking$mortality_factor_former") READ_R_VECTOR(value,input.smoking.mortality_factor_former);
  if(name=="smoking$ln_h_ces_betas") READ_R_VECTOR(value,input.smoking.ln_h_ces_betas);
  if(name=="smoking$smoking_ces_coefficient") {input.smoking.smoking_ces_coefficient=value[0]; return(0);}
  if(name=="smoking$smoking_cessation_adherence") {input.smoking.smoking_cessation_adherence=value[0]; return(0);}

  if(name=="COPD$ln_h_COPD_betas_by_sex") READ_R_MATRIX(value,input.COPD.ln_h_COPD_betas_by_sex);
  if(name=="COPD$logit_p_COPD_betas_by_sex") READ_R_MATRIX(value,input.COPD.logit_p_COPD_betas_by_sex);

  if(name=="lung_function$pred_fev1_betas_by_sex") READ_R_MATRIX(value,input.lung_function.pred_fev1_betas_by_sex);
  if(name=="lung_function$fev1_0_prev_betas_by_sex") READ_R_MATRIX(value,input.lung_function.fev1_0_prev_betas_by_sex);
  if(name=="lung_function$fev1_0_prev_sd_by_sex") READ_R_VECTOR(value,input.lung_function.fev1_0_prev_sd_by_sex);
  if(name=="lung_function$fev1_0_inc_betas_by_sex") READ_R_MATRIX(value,input.lung_function.fev1_0_inc_betas_by_sex);
  if(name=="lung_function$fev1_0_inc_sd_by_sex") READ_R_VECTOR(value,input.lung_function.fev1_0_inc_sd_by_sex);
  if(name=="lung_function$pred_fev1_betas_by_sex") READ_R_MATRIX(value,input.lung_function.pred_fev1_betas_by_sex);
  if(name=="lung_function$fev1_betas_by_sex") READ_R_MATRIX(value,input.lung_function.fev1_betas_by_sex);
  if(name=="lung_function$fev1_0_ZafarCMAJ_by_sex") READ_R_MATRIX(value,input.lung_function.fev1_0_ZafarCMAJ_by_sex);

  if(name=="lung_function$dfev1_sigmas") READ_R_VECTOR(value,input.lung_function.dfev1_sigmas);
  if(name=="lung_function$dfev1_re_rho") {input.lung_function.dfev1_re_rho=value[0]; return(0);}

  if(name=="exacerbation$ln_rate_betas") READ_R_VECTOR(value,input.exacerbation.ln_rate_betas);
  if(name=="exacerbation$logit_severity_betas") READ_R_VECTOR(value,input.exacerbation.logit_severity_betas);
  if(name=="exacerbation$ln_rate_intercept_sd") {input.exacerbation.ln_rate_intercept_sd=value[0]; return(0);}
  if(name=="exacerbation$logit_severity_intercept_sd") {input.exacerbation.logit_severity_intercept_sd=value[0]; return(0);}
  if(name=="exacerbation$rate_severity_intercept_rho") {input.exacerbation.rate_severity_intercept_rho=value[0]; return(0);}
  if(name=="exacerbation$exac_end_rate") READ_R_VECTOR(value,input.exacerbation.exac_end_rate);
  if(name=="exacerbation$logit_p_death_by_sex") READ_R_MATRIX(value,input.exacerbation.logit_p_death_by_sex);

  if(name=="symptoms$logit_p_cough_COPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_cough_COPD_by_sex);
  if(name=="symptoms$logit_p_cough_nonCOPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_cough_nonCOPD_by_sex);
  if(name=="symptoms$logit_p_phlegm_COPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_phlegm_COPD_by_sex);
  if(name=="symptoms$logit_p_phlegm_nonCOPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_phlegm_nonCOPD_by_sex);
  if(name=="symptoms$logit_p_wheeze_COPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_wheeze_COPD_by_sex);
  if(name=="symptoms$logit_p_wheeze_nonCOPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_wheeze_nonCOPD_by_sex);
  if(name=="symptoms$logit_p_dyspnea_COPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_dyspnea_COPD_by_sex);
  if(name=="symptoms$logit_p_dyspnea_nonCOPD_by_sex") READ_R_MATRIX(value,input.symptoms.logit_p_dyspnea_nonCOPD_by_sex);

  if(name=="outpatient$ln_rate_gpvisits_nonCOPD_by_sex") READ_R_MATRIX(value,input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex);
  if(name=="outpatient$ln_rate_gpvisits_COPD_by_sex") READ_R_MATRIX(value,input.outpatient.ln_rate_gpvisits_COPD_by_sex);
  if(name=="outpatient$dispersion_gpvisits_COPD") {input.outpatient.dispersion_gpvisits_COPD=value[0]; return(0);}
  if(name=="outpatient$dispersion_gpvisits_nonCOPD") {input.outpatient.dispersion_gpvisits_nonCOPD=value[0]; return(0);}

  if(name=="diagnosis$logit_p_prevalent_diagnosis_by_sex") READ_R_MATRIX(value,input.diagnosis.logit_p_prevalent_diagnosis_by_sex);
  if(name=="diagnosis$logit_p_diagnosis_by_sex") READ_R_MATRIX(value,input.diagnosis.logit_p_diagnosis_by_sex);
  if(name=="diagnosis$p_hosp_diagnosis") {input.diagnosis.p_hosp_diagnosis=value[0]; return(0);};
  if(name=="diagnosis$logit_p_overdiagnosis_by_sex") READ_R_MATRIX(value,input.diagnosis.logit_p_overdiagnosis_by_sex);
  if(name=="diagnosis$p_correct_overdiagnosis") {input.diagnosis.p_correct_overdiagnosis=value[0]; return(0);};
  if(name=="diagnosis$p_case_detection") READ_R_VECTOR(value,input.diagnosis.p_case_detection);
  if(name=="diagnosis$case_detection_start_end_yrs") READ_R_VECTOR(value,input.diagnosis.case_detection_start_end_yrs);
  if(name=="diagnosis$years_btw_case_detection") {input.diagnosis.years_btw_case_detection=value[0]; return(0);};
  if(name=="diagnosis$min_cd_age") {input.diagnosis.min_cd_age=value[0]; return(0);};
  if(name=="diagnosis$min_cd_pack_years") {input.diagnosis.min_cd_pack_years=value[0]; return(0);};
  if(name=="diagnosis$min_cd_symptoms") {input.diagnosis.min_cd_symptoms=value[0]; return(0);};
  if(name=="diagnosis$case_detection_methods") READ_R_MATRIX(value,input.diagnosis.case_detection_methods);
  if(name=="diagnosis$case_detection_methods_eversmokers") READ_R_MATRIX(value,input.diagnosis.case_detection_methods_eversmokers);
  if(name=="diagnosis$case_detection_methods_symptomatic") READ_R_MATRIX(value,input.diagnosis.case_detection_methods_symptomatic);

  if(name=="symptoms$covariance_COPD") READ_R_MATRIX(value, input.symptoms.covariance_COPD);
  if(name=="symptoms$covariance_nonCOPD")  READ_R_MATRIX(value, input.symptoms.covariance_nonCOPD);

  if(name=="outpatient$rate_doctor_visit") {input.outpatient.rate_doctor_visit=value[0]; return(0);}
  if(name=="outpatient$p_specialist") {input.outpatient.p_specialist=value[0]; return(0);}

  if(name=="cost$bg_cost_by_stage") READ_R_VECTOR(value,input.cost.bg_cost_by_stage);
  if(name=="cost$cost_case_detection") {input.cost.cost_case_detection=value[0]; return(0);};
  if(name=="cost$cost_outpatient_diagnosis") {input.cost.cost_outpatient_diagnosis=value[0]; return(0);};
  if(name=="cost$cost_gp_visit") {input.cost.cost_gp_visit=value[0]; return(0);};
  if(name=="cost$cost_smoking_cessation") {input.cost.cost_smoking_cessation=value[0]; return(0);};

  if(name=="medication$medication_ln_hr_exac") READ_R_VECTOR(value,input.medication.medication_ln_hr_exac);
  if(name=="medication$medication_costs") READ_R_VECTOR(value,input.medication.medication_costs);
  if(name=="medication$medication_utility") READ_R_VECTOR(value,input.medication.medication_utility);
  if(name=="medication$medication_adherence") {input.medication.medication_adherence=value[0]; return(0);};
  if(name=="medication$ln_h_start_betas_by_class") READ_R_MATRIX(value,input.medication.ln_h_start_betas_by_class);
  if(name=="medication$ln_h_stop_betas_by_class") READ_R_MATRIX(value,input.medication.ln_h_stop_betas_by_class);
  if(name=="medication$ln_rr_exac_by_class") READ_R_VECTOR(value,input.medication.ln_rr_exac_by_class);

  if(name=="cost$exac_dcost") READ_R_VECTOR(value,input.cost.exac_dcost);
  if(name=="cost$doctor_visit_by_type") READ_R_VECTOR(value,input.cost.doctor_visit_by_type);

  if(name=="utility$bg_util_by_stage") READ_R_VECTOR(value,input.utility.bg_util_by_stage);
  if(name=="utility$exac_dutil") READ_R_MATRIX(value,input.utility.exac_dutil);

  if(name=="comorbidity$logit_p_mi_betas_by_sex") READ_R_MATRIX(value,input.comorbidity.logit_p_mi_betas_by_sex);
  if(name=="comorbidity$ln_h_mi_betas_by_sex") READ_R_MATRIX(value,input.comorbidity.ln_h_mi_betas_by_sex);
  if(name=="comorbidity$p_mi_death") {input.comorbidity.p_mi_death=value[0]; return(0);}
  if(name=="comorbidity$logit_p_stroke_betas_by_sex") READ_R_MATRIX(value,input.comorbidity.logit_p_stroke_betas_by_sex);
  if(name=="comorbidity$ln_h_stroke_betas_by_sex") READ_R_MATRIX(value,input.comorbidity.ln_h_stroke_betas_by_sex);
  if(name=="comorbidity$p_stroke_death") {input.comorbidity.p_stroke_death=value[0]; return(0);}
  if(name=="comorbidity$logit_p_hf_betas_by_sex") READ_R_MATRIX(value,input.comorbidity.logit_p_hf_betas_by_sex);
  if(name=="comorbidity$ln_h_hf_betas_by_sex") READ_R_MATRIX(value,input.comorbidity.ln_h_hf_betas_by_sex);

  //Define your project-specific inputs here;

  return(ERR_INCORRECT_INPUT_VAR);
}


//' Returns a sample output for a given year and gender.
//' @param year a number
//' @param sex a number, 0 for male and 1 for female
//' @return that specific output
//' @export
// [[Rcpp::export]]
double get_sample_output(int year, int sex)
{
  return input.agent.p_bgd_by_sex[year][(int)sex];
}
