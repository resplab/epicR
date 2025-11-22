// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-

/**
 * @file model.cpp
 * @brief EPIC (Evaluation Platform In COPD) - Discrete Event Simulation Engine
 *
 * This file contains the core C++ implementation of the EPIC model.
 *
 * Modularized structure:
 * - epic_model.h: Shared declarations, struct definitions, constants
 * - model_globals.cpp: Global variable definitions, utility functions
 * - model_random.cpp: Random number generation functions
 * - model.cpp: Settings, Input, Output, Agent, Event, and Model functions
 *
 * @author EPIC Development Team
 * @see https://github.com/resplab/epicR
 */

#include "epic_model.h"

// Export enum values to R
/*** R
errors<-c(
  ERR_INCORRECT_SETTING_VARIABLE=-1,
  ERR_INCORRECT_VECTOR_SIZE=-2,
  ERR_INCORRECT_INPUT_VAR=-3,
  ERR_EVENT_STACK_FULL=-4,
  ERR_MEMORY_ALLOCATION_FAILED=-5
)

record_mode<-c(
  record_mode_none=0,
  record_mode_agent=1,
  record_mode_event=2,
  record_mode_some_event=3
)

agent_creation_mode<-c(
  agent_creation_mode_one=0,
  agent_creation_mode_all=1,
  agent_creation_mode_pre=2
)

medication_classes<-c(
  MED_CLASS_SABA=1,
  MED_CLASS_LABA=2,
  MED_CLASS_LAMA=4,
  MED_CLASS_ICS=8,
  MED_CLASS_MACRO=16
)
*/





////////////////////////////////////////////////////////////////////////////////
// SECTION 1: SETTINGS
////////////////////////////////////////////////////////////////////////////////


//' Sets model settings.
//' @param name a name
//' @param value a value
//' @return 0 if successful.
//' @export
// [[Rcpp::export]]
int Cset_settings_var(std::string name,NumericVector value)
{
  if(name=="record_mode") {settings.record_mode=value[0]; return(0);}
  if(name=="events_to_record")
  {
    settings.n_events_to_record=0;
    for(int i=0;i<value.size();i++)
    {
      settings.events_to_record[i]=value[i];
      settings.n_events_to_record++;
    }
    return(0);
  }
  if(name=="agent_creation_mode") {settings.agent_creation_mode=value[0]; return(0);}
  if(name=="update_continuous_outcomes_mode") {settings.update_continuous_outcomes_mode=value[0]; return(0);}
  if(name=="random_number_agent_refill") {settings.random_number_agent_refill=value[0]; return(0);}
  if(name=="n_base_agents") {settings.n_base_agents=value[0]; return(0);}
  if(name=="runif_buffer_size") {settings.runif_buffer_size=value[0]; return(0);}
  if(name=="rnorm_buffer_size") {settings.rnorm_buffer_size=value[0]; return(0);}
  if(name=="rexp_buffer_size") {settings.rexp_buffer_size=value[0]; return(0);}
  if(name=="rgamma_buffer_size") {settings.rgamma_buffer_size=value[0]; return(0);}
  if(name=="agent_stack_size") {settings.agent_stack_size=value[0]; return(0);}
  if(name=="event_stack_size") {settings.event_stack_size=value[0]; return(0);}
  return(ERR_INCORRECT_SETTING_VARIABLE);
}

//' Returns current settings.
//' @return current settings.
//' @export
// [[Rcpp::export]]
List Cget_settings()
{
  return Rcpp::List::create(
    Rcpp::Named("record_mode")=settings.record_mode,
    Rcpp::Named("events_to_record")=AS_VECTOR_DOUBLE_SIZE(settings.events_to_record,settings.n_events_to_record),
    Rcpp::Named("agent_creation_mode")=settings.agent_creation_mode,
    Rcpp::Named("update_continuous_outcomes_mode")=settings.update_continuous_outcomes_mode,
    Rcpp::Named("random_number_agent_refill")=settings.random_number_agent_refill,
    Rcpp::Named("n_base_agents")=settings.n_base_agents,
    Rcpp::Named("runif_buffer_size")=settings.runif_buffer_size,
    Rcpp::Named("rnorm_buffer_size")=settings.rnorm_buffer_size,
    Rcpp::Named("rexp_buffer_size")=settings.rexp_buffer_size,
    Rcpp::Named("rgamma_buffer_size")=settings.rgamma_buffer_size,
    Rcpp::Named("agent_stack_size")=settings.agent_stack_size,
    Rcpp::Named("event_stack_size")=settings.event_stack_size
  );
}

//' Returns run time stats.
//' @return agent size as well as memory and random variable fill stats.
//' @export
// [[Rcpp::export]]
List Cget_runtime_stats()
{
  return Rcpp::List::create(
    Rcpp::Named("agent_size")=runtime_stats.agent_size,
    Rcpp::Named("n_runif_fills")=runtime_stats.n_runif_fills,
    Rcpp::Named("n_rnorm_fills")=runtime_stats.n_rnorm_fills,
    Rcpp::Named("n_rexp_fills")=runtime_stats.n_rexp_fills,
    Rcpp::Named("n_rgamma_fills_COPD")=runtime_stats.n_rgamma_fills_COPD,
    Rcpp::Named("n_rgamma_fills_NCOPD")=runtime_stats.n_rgamma_fills_NCOPD
  );
}


// SECTION 3: AGENT
////////////////////////////////////////////////////////////////////////////////

List get_agent(agent *ag)
{
  List out=Rcpp::List::create(
    Rcpp::Named("id")=(*ag).id,
    Rcpp::Named("local_time")=(*ag).local_time,
    Rcpp::Named("alive")=(*ag).alive,
    Rcpp::Named("sex")=(int)(*ag).sex,

    Rcpp::Named("height")=(*ag).height,
    Rcpp::Named("weight")=(*ag).weight,

    Rcpp::Named("age_at_creation")=(*ag).age_at_creation,
    Rcpp::Named("time_at_creation")=(*ag).time_at_creation,

    Rcpp::Named("smoking_status")=(*ag).smoking_status,
    Rcpp::Named("pack_years")=(*ag).pack_years,

    Rcpp::Named("fev1")=(*ag).fev1,
    Rcpp::Named("fev1_slope")=(*ag).fev1_slope,
    Rcpp::Named("fev1_slope_t")=(*ag).fev1_slope_t,

    Rcpp::Named("exac_status")=(*ag).exac_status,
    Rcpp::Named("ln_exac_rate_intercept")=(*ag).ln_exac_rate_intercept,
    Rcpp::Named("logit_exac_severity_intercept")=(*ag).logit_exac_severity_intercept,

    Rcpp::Named("cumul_exac0")=(*ag).cumul_exac[0],
    Rcpp::Named("cumul_exac1")=(*ag).cumul_exac[1],
    Rcpp::Named("cumul_exac2")=(*ag).cumul_exac[2],
    Rcpp::Named("cumul_exac3")=(*ag).cumul_exac[3]


  );
  // out["fev1_decline_intercept"] = (*ag).fev1_decline_intercept;
  out["weight_baseline"] = (*ag).weight_baseline; //added here because the function "create" above can take a limited number of arguments
  out["followup_time"] = (*ag).followup_time; //added here because the function "create" above can take a limited number of arguments
  out["age_baseline"] = (*ag).age_baseline; //added here because the function "create" above can take a limited number of arguments
  out["fev1_baseline"] = (*ag).fev1_baseline; //added for new implementation of FEV1 decline -- Shahzad!
  // out["fev1_baseline_ZafarCMAJ"] = (*ag).fev1_baseline_ZafarCMAJ; //added for new implementation of FEV1 decline -- Shahzad!
  out["fev1_tail"] = (*ag).fev1_tail;
  out["gold"] = (*ag).gold;
  out["local_time_at_COPD"]=(*ag).local_time_at_COPD;

  out["tte"] = (*ag).tte;
  out["event"] = (*ag).event;
  out["symptom_score"] = (*ag).symptom_score;
  out["last_doctor_visit_time"] = (*ag).last_doctor_visit_time;
  out["last_doctor_visit_type"] = (*ag).last_doctor_visit_type;
  out["medication_status"] = (*ag).medication_status;

  out["n_mi"] = (*ag).n_mi;
  out["n_stroke"] = (*ag).n_stroke;

  out["p_COPD"] = (*ag).p_COPD;

  out["cough"] = (*ag).cough;
  out["phlegm"] = (*ag).phlegm;
  out["dyspnea"] = (*ag).dyspnea;
  out["wheeze"] = (*ag).wheeze;

  out["exac_history_n_moderate"]  = (*ag).exac_history_n_moderate;
  out["exac_history_n_severe_plus"] = (*ag).exac_history_n_severe_plus;

  out["re_cough"] = (*ag).re_cough;
  out["re_phlegm"] = (*ag).re_phlegm;
  out["re_dyspnea"] = (*ag).re_dyspnea;
  out["re_wheeze"] = (*ag).re_wheeze;

  out["gpvisits"] = (*ag).gpvisits;
  out["diagnosis"] = (*ag).diagnosis;
  out["time_at_diagnosis"] = (*ag).time_at_diagnosis;
  out["smoking_at_diagnosis"] = (*ag).smoking_at_diagnosis;
  out["smoking_cessation"] = (*ag).smoking_cessation;
  out["case_detection"] = (*ag).case_detection;

  out["cumul_cost"] = (*ag).cumul_cost;
  out["cumul_cost_prev_yr"] = (*ag).cumul_cost_prev_yr;
  out["cumul_qaly"] = (*ag).cumul_qaly;

  return out;
}





//This is a generic function as both agent_stack and event_stack are arrays of agents;
List get_agent(int id, agent agent_pointer[])
{
  return(get_agent(&agent_pointer[id]));
}



// [[Rcpp::export]]
List Cget_agent(long id)
{
  return(get_agent(id,agent_stack));
}

//' Returns agent Smith.
//' @return agent smith.
//' @export
// [[Rcpp::export]]
List Cget_smith()
{
  return(get_agent(&smith));
}









#define CALC_MI_ODDS(ag) (exp(input.comorbidity.logit_p_mi_betas_by_sex[0][(*ag).sex]                   \
+input.comorbidity.logit_p_mi_betas_by_sex[1][(*ag).sex]*(*ag).age_at_creation                        \
  +input.comorbidity.logit_p_mi_betas_by_sex[2][(*ag).sex]*(*ag).age_at_creation*(*ag).age_at_creation\
  +input.comorbidity.logit_p_mi_betas_by_sex[3][(*ag).sex]*(*ag).pack_years                           \
  +input.comorbidity.logit_p_mi_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status                       \
  +input.comorbidity.logit_p_mi_betas_by_sex[5][(*ag).sex]*calendar_time                              \
  +input.comorbidity.logit_p_mi_betas_by_sex[6][(*ag).sex]*(*ag).weight/pow((*ag).height,2)           \
  +input.comorbidity.logit_p_mi_betas_by_sex[7][(*ag).sex]*(*ag).gold));                              \


#define CALC_PRED_FEV1(ag) (input.lung_function.pred_fev1_betas_by_sex[0][(*ag).sex]                                                                                        \
+input.lung_function.pred_fev1_betas_by_sex[1][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)                                                                        \
+input.lung_function.pred_fev1_betas_by_sex[2][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)*((*ag).age_at_creation+(*ag).local_time)                               \
+input.lung_function.pred_fev1_betas_by_sex[3][(*ag).sex]*(*ag).height*(*ag).height)

//////////////////////////////////////////////////////////////////// symptoms/////////////////////////////////////;
double update_symptoms(agent *ag)
{
  arma::mat rand_effect_arma;
  NumericVector mu (4); //default is zero
  NumericMatrix covariance_COPD(4,4);
  NumericMatrix covariance_nonCOPD(4,4);

  for (int i=0; i<4; i++){
    for (int j=0; j<4; j++) {
      covariance_COPD(i,j) = input.symptoms.covariance_COPD[i][j];
      covariance_nonCOPD(i,j) = input.symptoms.covariance_nonCOPD[i][j];
    }
  }

  //Rcout << " numeric vector mu = " << (mu) << std::endl;

  // Rcout << " covariance_COPD = " << (input.symptoms.covariance_COPD[1][1]) << std::endl;
  // Rcout << " covariance_COPD_NM = " << (covariance_COPD(1,1)) << std::endl;
  //
  // Rcout << " covariance_nonCOPD = " << (input.symptoms.covariance_nonCOPD[0][1]) << std::endl;
  // Rcout << " covariance_nonCOPD_NM = " << (covariance_nonCOPD(0,1)) << std::endl;

  arma::vec mu_arma = as<arma::vec>(mu);
  arma::mat covariance_COPD_arma = as<arma::mat>(covariance_COPD);
  arma::mat covariance_nonCOPD_arma = as<arma::mat>(covariance_nonCOPD);

  // Rcout << " covariance_COPD_arma = " << (covariance_COPD_arma) << std::endl; //debug
  // Rcout << " covariance_nonCOPD_arma = " << (covariance_nonCOPD_arma) << std::endl;  //debug

  double p_cough = 0;
  double p_phlegm = 0;
  double p_wheeze = 0;
  double p_dyspnea = 0;

  if ((*ag).gold>0) {
    // Rcout << "running mvrnormArma " << std::endl;
    mvrnormArma(1, mu_arma, covariance_COPD_arma);
    // Rcout << "assigning mvrnormArma " << std::endl;
    rand_effect_arma = mvrnormArma(1, mu_arma, covariance_COPD_arma);

    (*ag).re_cough = rand_effect_arma(0);
    (*ag).re_phlegm = rand_effect_arma(1);
    (*ag).re_wheeze = rand_effect_arma(2);
    (*ag).re_dyspnea = rand_effect_arma(3);

    // Rcout << "random effect = " << (rand_effect_arma) << std::endl;
    p_cough = exp(input.symptoms.logit_p_cough_COPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_cough_COPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_cough_COPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_cough_COPD_by_sex[3][(*ag).sex]*((*ag).pack_years) +
      input.symptoms.logit_p_cough_COPD_by_sex[4][(*ag).sex]*((*ag).fev1) + (*ag).re_cough);

    p_phlegm = exp(input.symptoms.logit_p_phlegm_COPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_phlegm_COPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_phlegm_COPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_phlegm_COPD_by_sex[3][(*ag).sex]*((*ag).pack_years) +
      input.symptoms.logit_p_phlegm_COPD_by_sex[4][(*ag).sex]*((*ag).fev1) + (*ag).re_phlegm);

    p_wheeze = exp(input.symptoms.logit_p_wheeze_COPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_wheeze_COPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_wheeze_COPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_wheeze_COPD_by_sex[3][(*ag).sex]*((*ag).pack_years) +
      input.symptoms.logit_p_wheeze_COPD_by_sex[4][(*ag).sex]*((*ag).fev1) + (*ag).re_wheeze);

    p_dyspnea = exp(input.symptoms.logit_p_dyspnea_COPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_dyspnea_COPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_dyspnea_COPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_dyspnea_COPD_by_sex[3][(*ag).sex]*((*ag).pack_years) +
      input.symptoms.logit_p_dyspnea_COPD_by_sex[4][(*ag).sex]*((*ag).fev1) + (*ag).re_dyspnea);

  } else if ((*ag).gold==0) {
    // Rcout << "running mvrnormArma non_COPD " << std::endl;
    mvrnormArma(1, mu_arma, covariance_nonCOPD_arma);
    // Rcout << "assigning mvrnormArma non_COPD " << std::endl;
    rand_effect_arma = mvrnormArma(1, mu_arma, covariance_nonCOPD_arma);

    (*ag).re_cough = rand_effect_arma(0);
    (*ag).re_phlegm = rand_effect_arma(1);
    (*ag).re_wheeze = rand_effect_arma(2);
    (*ag).re_dyspnea = rand_effect_arma(3);

    // Rcout << "random effect = " << (rand_effect_arma) << std::endl;

    p_cough = exp(input.symptoms.logit_p_cough_nonCOPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_cough_nonCOPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_cough_nonCOPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_cough_nonCOPD_by_sex[3][(*ag).sex]*((*ag).pack_years) + (*ag).re_cough);

    p_phlegm = exp(input.symptoms.logit_p_phlegm_nonCOPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_phlegm_nonCOPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_phlegm_nonCOPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_phlegm_nonCOPD_by_sex[3][(*ag).sex]*((*ag).pack_years) + (*ag).re_phlegm);

    p_wheeze = exp(input.symptoms.logit_p_wheeze_nonCOPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_wheeze_nonCOPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_wheeze_nonCOPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_wheeze_nonCOPD_by_sex[3][(*ag).sex]*((*ag).pack_years) + (*ag).re_wheeze);

    p_dyspnea = exp(input.symptoms.logit_p_dyspnea_nonCOPD_by_sex[0][(*ag).sex] +
      input.symptoms.logit_p_dyspnea_nonCOPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.symptoms.logit_p_dyspnea_nonCOPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.symptoms.logit_p_dyspnea_nonCOPD_by_sex[3][(*ag).sex]*((*ag).pack_years) +(*ag).re_dyspnea);
  }

  p_cough = p_cough / (1 + p_cough);
  p_phlegm = p_phlegm / (1 + p_phlegm);
  p_wheeze = p_wheeze / (1 + p_wheeze);
  p_dyspnea = p_dyspnea / (1 + p_dyspnea);


  if (rand_unif() < p_cough) {(*ag).cough = 1;}
    else {(*ag).cough = 0;}
  if (rand_unif() < p_phlegm) {(*ag).phlegm = 1;}
    else {(*ag).phlegm = 0;}
  if (rand_unif() < p_wheeze) {(*ag).wheeze = 1;}
    else {(*ag).wheeze = 0;}
  if (rand_unif() < p_dyspnea) {(*ag).dyspnea = 1;}
    else {(*ag).dyspnea = 0;}

  return(0);
}





/////////////////////////////////////////////////////////////////////////LPTs////////////////////////////////////////////////////////////////////////////////



void lung_function_LPT(agent *ag)
{
  if((*ag).gold==0)
  {
    //We are not currently modeling lung funciton in non-COPD patients. Everything starts when gold>0;
  }
  else  //apply LHS equations
  {

    //Applying FEV1 decline
    //  double dt=(*ag).local_time-(*ag).lung_function_LPT;
    //    (*ag).fev1=(*ag).fev1 + (*ag).fev1_slope*dt + 2*(*ag).fev1_slope_t*(*ag).local_time*dt + (*ag).fev1_slope_t*dt*dt;

    (*ag).followup_time=(*ag).local_time-(*ag).local_time_at_COPD;

    double dt = ((*ag).local_time-(*ag).lung_function_LPT);

    (*ag).fev1=(*ag).fev1 + dt*(*ag).fev1_slope + 2 * (*ag).fev1_slope_t * (*ag).followup_time * dt + (*ag).fev1_slope_t * dt * dt;

    //Adjusting FEV1 tail
    if ((*ag).fev1 < (*ag).fev1_tail) {
      (*ag).fev1 = (*ag).fev1_tail;
    }


    double pred_fev1=CALC_PRED_FEV1(ag);
    (*ag)._pred_fev1=pred_fev1;
    if ((*ag).fev1/pred_fev1<0.3) (*ag).gold=4;
    else
      if ((*ag).fev1/pred_fev1<0.5) (*ag).gold=3;
      else
        if ((*ag).fev1/pred_fev1<0.8) (*ag).gold=2;
        else (*ag).gold=1;
  }
  (*ag).lung_function_LPT=(*ag).local_time;
}


void smoking_LPT(agent *ag)
{
#ifdef OUTPUT_EX
  if((*ag).smoking_status==0) output_ex.cumul_time_by_smoking_status[0]+=(*ag).local_time-(*ag).smoking_status_LPT;
  else
    if((*ag).pack_years>0) output_ex.cumul_time_by_smoking_status[2]+=(*ag).local_time-(*ag).smoking_status_LPT;
    else output_ex.cumul_time_by_smoking_status[1]+=(*ag).local_time-(*ag).smoking_status_LPT;
#endif

    (*ag).pack_years+=(*ag).smoking_status*((*ag).local_time-(*ag).smoking_status_LPT);
    (*ag).smoking_status_LPT=(*ag).local_time;
}


void exacerbation_LPT(agent *ag)
{
  if((*ag).exac_status>0)
    (*ag).cumul_exac_time[(*ag).exac_status-1]+=(*ag).local_time-(*ag).exac_LPT;
  (*ag).exac_LPT=(*ag).local_time;
}


void payoffs_LPT(agent *ag)
{
  (*ag).cumul_cost+=input.cost.bg_cost_by_stage[(*ag).gold]*((*ag).local_time-(*ag).payoffs_LPT)/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);

  output_ex.annual_cost_ctime[(int)floor((*ag).time_at_creation+(*ag).local_time)]+=(*ag).cumul_cost-(*ag).cumul_cost_prev_yr;
  (*ag).cumul_cost_prev_yr=(*ag).cumul_cost;

  output_ex.cumul_time_by_ctime_GOLD[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).gold]+=((*ag).local_time-(*ag).medication_LPT);

  (*ag).cumul_qaly+=input.utility.bg_util_by_stage[(*ag).gold]*((*ag).local_time-(*ag).payoffs_LPT)/pow(1+input.global_parameters.discount_qaly,(*ag).local_time+calendar_time);

  (*ag).payoffs_LPT=(*ag).local_time;
}


void medication_LPT(agent *ag)
{
  #if (OUTPUT_EX & OUTPUT_EX_MEDICATION) > 0
  int time=floor((*ag).local_time+(*ag).time_at_creation);
    for(int i=0;i<N_MED_CLASS;i++)
      if(((*ag).medication_status >> i) & 1)
      {
        output_ex.medication_time_by_class[i]+=((*ag).local_time-(*ag).medication_LPT);
        output_ex.medication_time_by_ctime_class[time][i]+=((*ag).local_time-(*ag).medication_LPT);
      }
  #endif
    // costs
    //(*ag).cumul_cost+=1;
      (*ag).cumul_cost+=input.medication.medication_costs[(*ag).medication_status]*((*ag).local_time-(*ag).medication_LPT)/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);

    // qaly
      if((*ag).gold>0 && (*ag).diagnosis>0 && (((*ag).cough==1) || ((*ag).phlegm==1) || ((*ag).wheeze==1) || ((*ag).dyspnea==1)))
        {
          (*ag).cumul_qaly+=input.medication.medication_utility[(*ag).medication_status]*((*ag).local_time-(*ag).medication_LPT)/pow(1+input.global_parameters.discount_qaly,(*ag).local_time+calendar_time);
        }

    // smoking cessation count

    if((*ag).smoking_cessation_count==1)
    {
      output_ex.n_smoking_cessation_by_ctime[time]+=(*ag).smoking_cessation_count;
      (*ag).smoking_cessation_count=0;
    }


    (*ag).medication_LPT=(*ag).local_time;
}





//////////////////////////////////////////////////////////////////// gpvisits/////////////////////////////////////;
double update_gpvisits(agent *ag)
{

  double gpvisitRate = 0;

  if ((*ag).gold==0) {

  gpvisitRate = exp(input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[0][(*ag).sex] +
      input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[3][(*ag).sex]*((*ag).cough) +
      input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[4][(*ag).sex]*((*ag).phlegm) +
      input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[5][(*ag).sex]*((*ag).wheeze) +
      input.outpatient.ln_rate_gpvisits_nonCOPD_by_sex[6][(*ag).sex]*((*ag).dyspnea));

      double gpvisits=rand_NegBin_NCOPD(gpvisitRate, input.outpatient.dispersion_gpvisits_nonCOPD);
      (*ag).gpvisits = gpvisits;


  } else {

  gpvisitRate = exp(input.outpatient.ln_rate_gpvisits_COPD_by_sex[0][(*ag).sex] +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[3][(*ag).sex]*((*ag).fev1) +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[4][(*ag).sex]*((*ag).cough) +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[5][(*ag).sex]*((*ag).phlegm) +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[6][(*ag).sex]*((*ag).wheeze) +
     input.outpatient.ln_rate_gpvisits_COPD_by_sex[7][(*ag).sex]*((*ag).dyspnea));

      double gpvisits=rand_NegBin_COPD(gpvisitRate, input.outpatient.dispersion_gpvisits_COPD);
      (*ag).gpvisits = gpvisits;

    }

  return(0);
}

//////////////////////////////////////////////////////////////////// Diagnosis /////////////////////////////////////;

double apply_case_detection(agent *ag)
{
// if((*ag).case_detection>0) return(0); include if case detection should only happen once

  (*ag).case_detection = 0;
  double p_detection = 0;

  if ((((*ag).age_at_creation+(*ag).local_time) >= input.diagnosis.min_cd_age) &&
      ((*ag).pack_years >= input.diagnosis.min_cd_pack_years) &&
      ((*ag).gpvisits!=0) &&
      ((*ag).diagnosis==0) &&
      ((*ag).cough+(*ag).phlegm+(*ag).wheeze+(*ag).dyspnea >= input.diagnosis.min_cd_symptoms)) {


    if ((*ag).last_case_detection == 0)
        {
      // if(((*ag).cough+(*ag).phlegm+(*ag).wheeze+(*ag).dyspnea) >= input.diagnosis.min_cd_symptoms)
          // {
          p_detection = input.diagnosis.p_case_detection[(int)floor((*ag).local_time+calendar_time)];
          (*ag).case_detection_eligible=1;
          // }
        }

      else if (((*ag).local_time - (*ag).last_case_detection) >= input.diagnosis.years_btw_case_detection)
          {
            p_detection = input.diagnosis.p_case_detection[(int)floor((*ag).local_time+calendar_time)];
          }




  if (rand_unif() < p_detection) {

    (*ag).case_detection = 1;
    (*ag).last_case_detection = (*ag).local_time;
    (*ag).cumul_cost+=input.cost.cost_case_detection/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);

    } else {

    (*ag).case_detection = 0;
      }
        }

  return(0);
}

/// Baseline diagnosis

double update_prevalent_diagnosis(agent *ag)
{

  double p_prev_diagnosis = 0;

  if((*ag).gold!=0)  {

    if((*ag).diagnosis>0) return(0);

    p_prev_diagnosis = exp(input.diagnosis.logit_p_prevalent_diagnosis_by_sex[0][(*ag).sex] +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[3][(*ag).sex]*((*ag).fev1) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[4][(*ag).sex]*((*ag).cough) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[5][(*ag).sex]*((*ag).phlegm) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[6][(*ag).sex]*((*ag).wheeze) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[7][(*ag).sex]*((*ag).dyspnea) +
      input.diagnosis.logit_p_prevalent_diagnosis_by_sex[8][(*ag).sex]*((*ag).case_detection));

    p_prev_diagnosis = p_prev_diagnosis / (1 + p_prev_diagnosis);

    if (rand_unif() < p_prev_diagnosis)
    {
      (*ag).diagnosis = 1;
      //(*ag).cumul_cost+=input.cost.cost_outpatient_diagnosis/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time); // shouldn't be a cost associated with baseline diagnosis?
      (*ag).time_at_diagnosis=(*ag).local_time;
      (*ag).smoking_at_diagnosis=(*ag).smoking_status;
    }

    if ((*ag).diagnosis == 1 && (*ag).dyspnea==0)
    {
          if (rand_unif() < input.medication.medication_adherence)
          {
            (*ag).medication_status= max(MED_CLASS_SABA, (*ag).medication_status);
            medication_LPT(ag);
          }
    }

    if ((*ag).diagnosis == 1 && (*ag).dyspnea==1)
    {
          if (rand_unif() < input.medication.medication_adherence)
          {
            (*ag).medication_status= max(MED_CLASS_LAMA, (*ag).medication_status);
            medication_LPT(ag);
          }
    }
    if ((*ag).diagnosis==1 && (*ag).smoking_status==1 && (rand_unif()<input.smoking.smoking_cessation_adherence))
    {
      (*ag).cumul_cost+=(input.cost.cost_smoking_cessation/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time-1));
      (*ag).smoking_cessation=1;
      (*ag).smoking_cessation_count=1;
    }

  }
  return(0);
}


/// Follow-up diagnosis

 double update_diagnosis(agent *ag)
{

  double p_diagnosis = 0;

   if(floor((*ag).local_time+(*ag).time_at_creation)>=input.diagnosis.case_detection_start_end_yrs[0] && floor((*ag).local_time+(*ag).time_at_creation)<=input.diagnosis.case_detection_start_end_yrs[1]){
     apply_case_detection(ag);
   }

  if ((*ag).gpvisits!=0) {

  if((*ag).gold!=0)  {

    if((*ag).diagnosis>0) return(0);

    p_diagnosis = exp(input.diagnosis.logit_p_diagnosis_by_sex[0][(*ag).sex] +
      input.diagnosis.logit_p_diagnosis_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
      input.diagnosis.logit_p_diagnosis_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
      input.diagnosis.logit_p_diagnosis_by_sex[3][(*ag).sex]*((*ag).fev1) +
      input.diagnosis.logit_p_diagnosis_by_sex[4][(*ag).sex]*((*ag).gpvisits) +
      input.diagnosis.logit_p_diagnosis_by_sex[5][(*ag).sex]*((*ag).cough) +
      input.diagnosis.logit_p_diagnosis_by_sex[6][(*ag).sex]*((*ag).phlegm) +
      input.diagnosis.logit_p_diagnosis_by_sex[7][(*ag).sex]*((*ag).wheeze) +
      input.diagnosis.logit_p_diagnosis_by_sex[8][(*ag).sex]*((*ag).dyspnea) +
      input.diagnosis.logit_p_diagnosis_by_sex[9][(*ag).sex]*((*ag).case_detection));

    p_diagnosis = p_diagnosis / (1 + p_diagnosis);

    if (rand_unif() < p_diagnosis)
      {
        (*ag).diagnosis = 1;
        (*ag).cumul_cost+=input.cost.cost_outpatient_diagnosis/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);
        (*ag).time_at_diagnosis=(*ag).local_time;
        (*ag).smoking_at_diagnosis=(*ag).smoking_status;
        if((*ag).case_detection==1)
          {
          (*ag).case_detection=3; // increase to 3 for true positive
          }

      }

    if ((*ag).diagnosis == 1 && (*ag).dyspnea==0)
      {
        if (rand_unif() < input.medication.medication_adherence)
          {
               (*ag).medication_status= max(MED_CLASS_SABA, (*ag).medication_status);
               medication_LPT(ag);
          }
      }

    if ((*ag).diagnosis == 1 && (*ag).dyspnea==1)
      {
          if (rand_unif() < input.medication.medication_adherence)
          {
            (*ag).medication_status= max(MED_CLASS_LAMA, (*ag).medication_status);
            medication_LPT(ag);
          }
      }

    if ((*ag).diagnosis==1 && (*ag).smoking_status==1 && (rand_unif()<input.smoking.smoking_cessation_adherence))
    {
      (*ag).cumul_cost+=(input.cost.cost_smoking_cessation/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time-1));
      (*ag).smoking_cessation=1;
      (*ag).smoking_cessation_count=1;
    }

  } else if ((*ag).gold==0) {

    double correct_overdiagnosis = input.diagnosis.p_correct_overdiagnosis;

      if((*ag).diagnosis>0) {

        if(rand_unif() < correct_overdiagnosis) {

        (*ag).diagnosis = 0;
        (*ag).cumul_cost+=input.cost.cost_outpatient_diagnosis/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);
        (*ag).medication_status=0;
        medication_LPT(ag);
        (*ag).time_at_diagnosis=0;
        (*ag).smoking_at_diagnosis=0;
        (*ag).smoking_cessation=0;

         return(0);
      }

    } else if ((*ag).diagnosis==0) {

      double p_overdiagnosis = 0;

      p_overdiagnosis = exp(input.diagnosis.logit_p_overdiagnosis_by_sex[0][(*ag).sex] +
        input.diagnosis.logit_p_overdiagnosis_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[2][(*ag).sex]*((*ag).smoking_status) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[3][(*ag).sex]*((*ag).gpvisits) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[4][(*ag).sex]*((*ag).cough) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[5][(*ag).sex]*((*ag).phlegm) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[6][(*ag).sex]*((*ag).wheeze) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[7][(*ag).sex]*((*ag).dyspnea) +
        input.diagnosis.logit_p_overdiagnosis_by_sex[8][(*ag).sex]*((*ag).case_detection));

      p_overdiagnosis = p_overdiagnosis / (1 + p_overdiagnosis);

      if (rand_unif() < p_overdiagnosis)
        {
            (*ag).diagnosis = 1;
            (*ag).time_at_diagnosis=(*ag).local_time;
            (*ag).smoking_at_diagnosis=(*ag).smoking_status;
            //(*ag).cumul_cost+=(input.cost.cost_gp_visit/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time-1));


        } else {
            (*ag).diagnosis = 0;
          }

        if ((*ag).diagnosis == 1 && (*ag).case_detection==1)
        {
          (*ag).cumul_cost+=(input.cost.cost_outpatient_diagnosis/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time-1));
          (*ag).diagnosis = 0;
          (*ag).time_at_diagnosis=0;
          (*ag).smoking_at_diagnosis=0;
          (*ag).case_detection=2; // increase to 2 for false positive
        }

        if((*ag).diagnosis == 1 && (*ag).gold==0)

              {
                  if (rand_unif() < input.medication.medication_adherence)
                    {
                      (*ag).medication_status= max(MED_CLASS_SABA, (*ag).medication_status);
                      medication_LPT(ag);
                    }
              }

         if ((*ag).diagnosis==1 && (*ag).smoking_status==1 && (*ag).gold==0 && (rand_unif()<input.smoking.smoking_cessation_adherence))
            {
              (*ag).cumul_cost+=(input.cost.cost_smoking_cessation/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time-1));
              (*ag).smoking_cessation=1;
              (*ag).smoking_cessation_count=1;
            }

      }
    }
  }
  return(0);
}



////////////////////////////////////////////////////////////////////////////////
// AGENT CREATION
////////////////////////////////////////////////////////////////////////////////

/**
 * @brief Creates and initializes a new agent (virtual patient) in the simulation
 *
 * @param ag Pointer to the agent structure to initialize
 * @param id Unique identifier for the agent
 * @return Pointer to the initialized agent
 *
 * This function is the core of agent creation in EPIC. It performs the following:
 *
 * 1. **Basic Initialization**
 *    - Sets alive status, local time, and assigns unique ID
 *    - Resets all state variables to initial values
 *
 * 2. **Demographic Assignment**
 *    - Sex: Randomly assigned based on p_female parameter
 *    - Age: Sampled from age distribution (different for prevalent vs incident)
 *    - Height/Weight: Generated using correlated bivariate normal distribution
 *
 * 3. **Smoking Status**
 *    - Determines smoking status (current/former/never)
 *    - Assigns pack-years based on age and smoking history
 *
 * 4. **COPD Status (for prevalent agents)**
 *    - Determines COPD presence based on risk factors
 *    - If COPD present: assigns FEV1, GOLD stage, symptoms
 *    - Handles case detection and diagnosis
 *
 * 5. **Health Outcomes**
 *    - Initializes comorbidity status (MI, stroke, HF)
 *    - Sets up symptom variables (cough, phlegm, dyspnea, wheeze)
 *    - Initializes cost and QALY accumulators
 *
 * @note For prevalent agents (id < n_base_agents), age is sampled from
 *       p_prevalence_age; for incident agents, from p_incidence_age.
 *
 * @note COPD is only assigned to prevalent agents. Incident agents may
 *       develop COPD during simulation via the event_COPD event.
 *
 * @see event_COPD_tte() for incident COPD handling
 * @see Cmodel() for how agents are created during simulation
 */
agent *create_agent(agent *ag,int id)
{
double _bvn[2]; // Bivariate normal sample, reused for correlated variables

// ========== STEP 1: Basic Initialization ==========
(*ag).id=id;
(*ag).alive=1;
(*ag).local_time=0;
(*ag).age_baseline = 0;
(*ag).fev1_slope = 0;
(*ag).fev1_slope_t = 0;//resetting the value for new agent
//(*ag).fev1_baseline = 0; //resetting the value for new agent
//(*ag).fev1_decline_intercept = 0;
//(*ag).fev1_baseline_ZafarCMAJ = 0; // Only used for calculating intercept of FEV1 rate of decline
(*ag).weight_baseline = 0; //resetting the value for new agent
(*ag).followup_time = 0; //resetting the value for new agent
(*ag).local_time_at_COPD = 0; //resetting the value for new agent
(*ag).cough = 0;
(*ag).phlegm  = 0;
(*ag).wheeze  = 0;
(*ag).dyspnea = 0;

(*ag).re_cough = 0;
(*ag).re_phlegm  = 0;
(*ag).re_wheeze  = 0;
(*ag).re_dyspnea = 0;

(*ag).gpvisits  = 0;
(*ag).diagnosis = 0;
(*ag).time_at_diagnosis = 0;
(*ag).smoking_at_diagnosis = 0;
(*ag).smoking_cessation = 0;
(*ag).smoking_cessation_count = 0;
(*ag).case_detection = 0;
(*ag).case_detection_eligible = 0;
(*ag).last_case_detection = 0;

(*ag).tmp_exac_rate = 0;

(*ag).time_at_creation=calendar_time;
(*ag).sex=rand_unif()<input.agent.p_female;
(*ag).fev1_tail = sqrt(0.1845) * rand_norm() + 0.827;


// (*ag).norm_refill = 0;
// (*ag).exp_refill = 0;
// (*ag).unif_refill = 0;
// (*ag).gamma_COPD_refill = 0;
// (*ag).gamma_NCOPD_refill = 0;
// (*ag).norm_count = 0;
// (*ag).exp_count = 0;
// (*ag).unif_count = 0;
// (*ag).gamma_COPD_count = 0;
// (*ag).gamma_NCOPD_count = 0;


// ========== STEP 2: Age Assignment ==========
// Prevalent agents (id < n_base_agents) use p_prevalence_age distribution
// Incident agents use p_incidence_age distribution
double r=rand_unif();
double cum_p=0;

if(id<settings.n_base_agents)
  for(int i=input.global_parameters.age0;i<111;i++)
  {
    cum_p=cum_p+input.agent.p_prevalence_age[i];
    if(r<cum_p) {(*ag).age_at_creation=i+rand_unif(); break;}
  }
  else
    for(int i=input.global_parameters.age0;i<111;i++)
    {
      cum_p=cum_p+input.agent.p_incidence_age[i];
      //if(i==40) Rprintf("r=%f,cum_p=%f\n",r,cum_p);
      if(r<cum_p) {(*ag).age_at_creation=i; break;}
    }

// ========== STEP 3: Height and Weight Assignment ==========
    // Uses bivariate normal for correlated height/weight
    rbvnorm(input.agent.height_weight_rho,_bvn);
  (*ag).height=_bvn[0]*input.agent.height_0_sd
    +input.agent.height_0_betas[0]
  +input.agent.height_0_betas[1]*(*ag).sex
  +input.agent.height_0_betas[2]*(*ag).age_at_creation
  +input.agent.height_0_betas[3]*(*ag).age_at_creation*(*ag).age_at_creation
  +input.agent.height_0_betas[4]*(*ag).age_at_creation*(*ag).sex;

  (*ag).weight=_bvn[1]*input.agent.weight_0_sd
    +input.agent.weight_0_betas[0]
  +input.agent.weight_0_betas[1]*(*ag).sex
  +input.agent.weight_0_betas[2]*(*ag).age_at_creation
  +input.agent.weight_0_betas[3]*(*ag).age_at_creation*(*ag).age_at_creation
  +input.agent.weight_0_betas[4]*(*ag).age_at_creation*(*ag).sex
  +input.agent.weight_0_betas[5]*(*ag).height
  +input.agent.weight_0_betas[6]*calendar_time;

  // ========== STEP 4: Smoking Status Assignment ==========
  bool ever_smoker=false;

  double odds1=exp(input.smoking.logit_p_current_smoker_0_betas[0]
                     +input.smoking.logit_p_current_smoker_0_betas[1]*(*ag).sex
                     +input.smoking.logit_p_current_smoker_0_betas[2]*(*ag).age_at_creation
                     +input.smoking.logit_p_current_smoker_0_betas[3]*pow((*ag).age_at_creation,2)
                     +input.smoking.logit_p_current_smoker_0_betas[4]*(*ag).age_at_creation*(*ag).sex
                     +input.smoking.logit_p_current_smoker_0_betas[5]*pow((*ag).age_at_creation,2)*(*ag).sex
                     +input.smoking.logit_p_current_smoker_0_betas[6]*calendar_time
  );

  double temp = max(input.smoking.minimum_smoking_prevalence,(odds1/(1+odds1)));

  if(rand_unif() < temp) //adding a minimum baseline smoking prevalence. ever smoker
  {
    (*ag).smoking_status = 1;
    ever_smoker = true;
  }
  else
  {
    (*ag).smoking_status=0;
    double odds2=exp(input.smoking.logit_p_never_smoker_con_not_current_0_betas[0]
                       +input.smoking.logit_p_never_smoker_con_not_current_0_betas[1]*(*ag).sex
                       +input.smoking.logit_p_never_smoker_con_not_current_0_betas[2]*(*ag).age_at_creation
                       +input.smoking.logit_p_never_smoker_con_not_current_0_betas[3]*pow((*ag).age_at_creation,2)
                       +input.smoking.logit_p_never_smoker_con_not_current_0_betas[4]*(*ag).age_at_creation*(*ag).sex
                       +input.smoking.logit_p_never_smoker_con_not_current_0_betas[5]*pow((*ag).age_at_creation,2)*(*ag).sex
                       +input.smoking.logit_p_never_smoker_con_not_current_0_betas[6]*calendar_time
    );

    if(rand_unif()< (odds2/(1+odds2))) {
      (*ag).pack_years=0;
      ever_smoker = false;
    }
    else{
      ever_smoker = true;
    }
  }
  if(ever_smoker)
  {
    double temp=input.smoking.pack_years_0_betas[0]
    +input.smoking.pack_years_0_betas[1]*(*ag).sex
    +input.smoking.pack_years_0_betas[2]*((*ag).age_at_creation+(*ag).local_time)
    +input.smoking.pack_years_0_betas[3]*((*ag).time_at_creation+(*ag).local_time)
    +input.smoking.pack_years_0_betas[4]*(*ag).smoking_status;

    (*ag).pack_years=temp+rand_norm()*input.smoking.pack_years_0_sd;
    if ((*ag).pack_years < 0 ) {
      (*ag).pack_years = 0; //making sure we don't get negative pack_years
    }
  }


  (*ag).smoking_status_LPT=0;


  // ========== STEP 5: Exacerbation Random Effects ==========
  rbvnorm(input.exacerbation.rate_severity_intercept_rho,_bvn);
  (*ag).ln_exac_rate_intercept=_bvn[0]*input.exacerbation.ln_rate_intercept_sd;
  (*ag).logit_exac_severity_intercept=_bvn[1]*input.exacerbation.logit_severity_intercept_sd;

  (*ag).cumul_exac[0]=0;
  (*ag).cumul_exac[1]=0;
  (*ag).cumul_exac[2]=0;
  (*ag).cumul_exac[3]=0;
  (*ag).cumul_exac_time[0]=0;
  (*ag).cumul_exac_time[1]=0;
  (*ag).cumul_exac_time[2]=0;
  (*ag).cumul_exac_time[3]=0;
  (*ag).exac_status=0;
  (*ag).exac_LPT=0;

  (*ag).exac_history_time_first=0;
  (*ag).exac_history_time_second=0;

  (*ag).exac_history_severity_first=0;
  (*ag).exac_history_severity_second=0;

  (*ag).exac_history_n_moderate=0;
  (*ag).exac_history_n_severe_plus=0;


  // ========== STEP 6: COPD Status (Prevalent Agents Only) ==========
  // Calculate probability of COPD based on risk factors
  double COPD_odds=exp(input.COPD.logit_p_COPD_betas_by_sex[0][(*ag).sex]
                         +input.COPD.logit_p_COPD_betas_by_sex[1][(*ag).sex]*(*ag).age_at_creation
                         +input.COPD.logit_p_COPD_betas_by_sex[2][(*ag).sex]*(*ag).age_at_creation*(*ag).age_at_creation
                         +input.COPD.logit_p_COPD_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
                         +input.COPD.logit_p_COPD_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
                         +input.COPD.logit_p_COPD_betas_by_sex[5][(*ag).sex]*calendar_time)
                         //+input.COPD.logit_p_COPD_betas_by_sex[7]*(*ag).asthma
                         ;

  (*ag).p_COPD=COPD_odds/(1+COPD_odds);

  if(rand_unif()<COPD_odds/(1+COPD_odds))
  {
    (*ag).weight_baseline = (*ag).weight;
    (*ag).age_baseline = (*ag).local_time + (*ag).age_at_creation;
    (*ag).followup_time = 0 ;
    (*ag).local_time_at_COPD = (*ag).local_time;

    (*ag).fev1=input.lung_function.fev1_0_prev_betas_by_sex[0][(*ag).sex]
    +input.lung_function.fev1_0_prev_betas_by_sex[1][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)
    +input.lung_function.fev1_0_prev_betas_by_sex[2][(*ag).sex]*(*ag).height*(*ag).height
    +input.lung_function.fev1_0_prev_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
    +rand_norm()*input.lung_function.fev1_0_prev_sd_by_sex[(*ag).sex];


    double _beta_0=(*ag).fev1-
    (input.lung_function.fev1_0_ZafarCMAJ_by_sex[1][(*ag).sex]*(*ag).age_baseline
       +input.lung_function.fev1_0_ZafarCMAJ_by_sex[2][(*ag).sex]*(*ag).weight_baseline
       +input.lung_function.fev1_0_ZafarCMAJ_by_sex[3][(*ag).sex]*(*ag).height
       +input.lung_function.fev1_0_ZafarCMAJ_by_sex[4][(*ag).sex]*(*ag).height*(*ag).height
       +input.lung_function.fev1_0_ZafarCMAJ_by_sex[5][(*ag).sex]*(*ag).smoking_status
       +input.lung_function.fev1_0_ZafarCMAJ_by_sex[6][(*ag).sex]*(*ag).age_baseline*(*ag).height*(*ag).height);

       double _beta_0_prime=rand_norm()*sqrt((1-input.lung_function.dfev1_re_rho*input.lung_function.dfev1_re_rho)*input.lung_function.dfev1_sigmas[1]*input.lung_function.dfev1_sigmas[1])+
       (input.lung_function.fev1_betas_by_sex[0][(*ag).sex]+input.lung_function.dfev1_sigmas[1]/input.lung_function.dfev1_sigmas[0]*input.lung_function.dfev1_re_rho*(_beta_0-input.lung_function.fev1_0_ZafarCMAJ_by_sex[0][(*ag).sex]));

       (*ag).fev1_slope=_beta_0_prime
         +input.lung_function.fev1_betas_by_sex[1][(*ag).sex]*(*ag).age_baseline
         +input.lung_function.fev1_betas_by_sex[2][(*ag).sex]*(*ag).weight_baseline
         +input.lung_function.fev1_betas_by_sex[3][(*ag).sex]*(*ag).height
         +input.lung_function.fev1_betas_by_sex[4][(*ag).sex]*(*ag).height*(*ag).height
         +input.lung_function.fev1_betas_by_sex[5][(*ag).sex]*(*ag).smoking_status
         +input.lung_function.fev1_betas_by_sex[6][(*ag).sex]*(*ag).age_baseline*(*ag).height*(*ag).height;

         (*ag).fev1_slope_t=input.lung_function.fev1_betas_by_sex[7][(*ag).sex];

         //Adjusting FEV1 tail
          if ((*ag).fev1 < (*ag).fev1_tail) {
          (*ag).fev1 = (*ag).fev1_tail;
         }

         //Setting values for COPD prevalence cases
         (*ag).fev1_baseline = (*ag).fev1;

         // Intercept for FEV1 decline in prevalent cases

         double pred_fev1=CALC_PRED_FEV1(ag);
         (*ag)._pred_fev1=pred_fev1;

         if ((*ag).fev1/pred_fev1<0.3) (*ag).gold=4;
         else
           if ((*ag).fev1/pred_fev1<0.5) (*ag).gold=3;
           else
             if ((*ag).fev1/pred_fev1<0.8) (*ag).gold=2;
             else (*ag).gold=1;
  }
  else
  {
    (*ag).gold=0;
    (*ag).fev1=0;
    (*ag)._pred_fev1=0; //restarting _pred_fev1 for new people who don't have COPD

  }


  //lung function;
  (*ag).lung_function_LPT=0;


  //medication
  (*ag).medication_status=0;
  (*ag).medication_LPT=0;

  //comorbidity
  //mi
  double mi_odds=CALC_MI_ODDS(ag);

  if(rand_unif()<mi_odds/(1+mi_odds))
  {
    (*ag).n_mi=1;
  }
  else
  {
    (*ag).n_mi=0;
  }

  //symptoms
  update_symptoms(ag);

  //diagnosis
  update_prevalent_diagnosis(ag);

  //stroke
  double stroke_odds=exp(input.comorbidity.logit_p_stroke_betas_by_sex[0][(*ag).sex]
                           +input.comorbidity.logit_p_stroke_betas_by_sex[1][(*ag).sex]*(*ag).age_at_creation
                           +input.comorbidity.logit_p_stroke_betas_by_sex[2][(*ag).sex]*(*ag).age_at_creation*(*ag).age_at_creation
                           +input.comorbidity.logit_p_stroke_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
                           +input.comorbidity.logit_p_stroke_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
                           +input.comorbidity.logit_p_stroke_betas_by_sex[5][(*ag).sex]*calendar_time
                           +input.comorbidity.logit_p_stroke_betas_by_sex[6][(*ag).sex]*(*ag).weight/pow((*ag).height,2)
                           +input.comorbidity.logit_p_stroke_betas_by_sex[7][(*ag).sex]*(*ag).gold
                           +input.comorbidity.logit_p_stroke_betas_by_sex[8][(*ag).sex]*((*ag).n_mi>0)
                           +input.comorbidity.logit_p_stroke_betas_by_sex[9][(*ag).sex]*((*ag).n_mi)
  );
  if(rand_unif()<stroke_odds/(1+stroke_odds))
  {
    (*ag).n_stroke=1;
  }
  else
  {
    (*ag).n_stroke=0;
  }


  //hf
  double hf_odds=exp(input.comorbidity.logit_p_hf_betas_by_sex[0][(*ag).sex]
                       +input.comorbidity.logit_p_hf_betas_by_sex[1][(*ag).sex]*(*ag).age_at_creation
                       +input.comorbidity.logit_p_hf_betas_by_sex[2][(*ag).sex]*(*ag).age_at_creation*(*ag).age_at_creation
                       +input.comorbidity.logit_p_hf_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
                       +input.comorbidity.logit_p_hf_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
                       +input.comorbidity.logit_p_hf_betas_by_sex[5][(*ag).sex]*calendar_time
                       +input.comorbidity.logit_p_hf_betas_by_sex[6][(*ag).sex]*(*ag).weight/pow((*ag).height,2)
                       +input.comorbidity.logit_p_hf_betas_by_sex[7][(*ag).sex]*(*ag).gold
                       +input.comorbidity.logit_p_hf_betas_by_sex[8][(*ag).sex]*((*ag).n_mi>0)
                       +input.comorbidity.logit_p_hf_betas_by_sex[9][(*ag).sex]*((*ag).n_mi)
                       +input.comorbidity.logit_p_hf_betas_by_sex[10][(*ag).sex]*((*ag).n_stroke>0)
                       +input.comorbidity.logit_p_hf_betas_by_sex[11][(*ag).sex]*((*ag).n_stroke)
  );
  if(rand_unif()<hf_odds/(1+hf_odds))
  {
    (*ag).hf_status=1;
  }
  else
  {
    (*ag).hf_status=0;
  }




  //payoffs;
  (*ag).cumul_cost=0;
  (*ag).cumul_cost_prev_yr=0;
  (*ag).cumul_qaly=0;

  (*ag).payoffs_LPT=0;

  return(ag);
}



// [[Rcpp::export]]
int Ccreate_agents()
{
  if(agent_stack==NULL) return(-1);
  for(int i=0;i<settings.agent_stack_size;i++)
  {
    create_agent(&agent_stack[i],i);
  }

  return(0);
}









///////////////////////////////////////////////////////////////////EVENT/////////////////////////////////////////////////////////



enum events
{
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
};
/*** R
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
  */








agent *event_start_process(agent *ag)
{
#ifdef OUTPUT_EX
  update_output_ex(ag);
#endif
  return(ag);
}




agent *event_end_process(agent *ag)
{

  if((*ag).exac_status>0)
  {
    //NOTE: exacerbation timing is an LPT process and is treated separately.
    (*ag).cumul_cost+=input.cost.exac_dcost[(*ag).exac_status-1]/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);
    (*ag).cumul_qaly+=input.utility.exac_dutil[(*ag).exac_status-1][(*ag).gold-1]/pow(1+input.global_parameters.discount_qaly,(*ag).local_time+calendar_time);

  }

  ++output.n_agents;
  if(floor((*ag).local_time+(*ag).time_at_creation)>=input.diagnosis.case_detection_start_end_yrs[0] && floor((*ag).time_at_creation)<=input.diagnosis.case_detection_start_end_yrs[1]) ++output_ex.n_agents_CD;
  output.n_COPD+=((*ag).gold>0)*1;
  output.cumul_time+=(*ag).local_time;
  output.n_deaths+=!(*ag).alive;

  lung_function_LPT(ag);
  smoking_LPT(ag);
  exacerbation_LPT(ag);
  payoffs_LPT(ag);
  medication_LPT(ag);

  output.total_pack_years+=(*ag).pack_years;
  output.total_exac[0]+=(*ag).cumul_exac[0];
  output.total_exac[1]+=(*ag).cumul_exac[1];
  output.total_exac[2]+=(*ag).cumul_exac[2];
  output.total_exac[3]+=(*ag).cumul_exac[3];

  output.total_exac_time[0]+=(*ag).cumul_exac_time[0];
  output.total_exac_time[1]+=(*ag).cumul_exac_time[1];
  output.total_exac_time[2]+=(*ag).cumul_exac_time[2];
  output.total_exac_time[3]+=(*ag).cumul_exac_time[3];

  output.total_cost+=(*ag).cumul_cost;
  output.total_qaly+=(*ag).cumul_qaly;
  if((*ag).diagnosis>0 && (*ag).gold>0) output.total_diagnosed_time+=(*ag).local_time-(*ag).time_at_diagnosis;

  // output_ex.annual_cost_ctime[input.global_parameters.time_horizon-1]+=(*ag).cumul_cost-(*ag).cumul_cost_prev_yr;


#ifdef OUTPUT_EX
  //NO!!! We do not update many of output_ex stuff here. It might fall within the same calendar year of the last fixed event and results in double counting.
  //If it falls after that still we ignore as it is a partially observed year.
#endif
#if OUTPUT_EX>1
  //  output_ex.cumul_cost_ctime[input.global_parameters.time_horizon-1]+=(*ag).cumul_cost; // accounting for residual last year, for consistency with output.total_qaly and   output.total_cost
  //  output_ex.cumul_cost_gold_ctime[input.global_parameters.time_horizon-1][(*ag).gold]+=(*ag).cumul_cost;
  //  output_ex.cumul_qaly_ctime[input.global_parameters.time_horizon-1]+=(*ag).cumul_qaly;
  //  output_ex.cumul_qaly_gold_ctime[input.global_parameters.time_horizon-1][(*ag).gold]+=(*ag).cumul_qaly;

  int age=floor((*ag).local_time+(*ag).age_at_creation);
  //Rprintf("age at death=%f\n",age);
  if((*ag).gold==0) output_ex.cumul_non_COPD_time+=(*ag).local_time;
  if((*ag).alive==false)  output_ex.n_death_by_age_sex[age-1][(*ag).sex]+=1;

  if((*ag).case_detection_eligible==1) output_ex.n_case_detection_eligible+=1;
  if((*ag).diagnosis>0 && (*ag).gold>0 && floor((*ag).time_at_diagnosis)>=input.diagnosis.case_detection_start_end_yrs[0] && floor((*ag).time_at_diagnosis)<=input.diagnosis.case_detection_start_end_yrs[1]) output_ex.n_diagnosed_true_CD+=1;



  double time=(*ag).time_at_creation+(*ag).local_time;
  while(time>(*ag).time_at_creation)
  {
    int time_cut=floor(time);
    double delta=min(time-time_cut,time-(*ag).time_at_creation);
    if(delta==0) {time_cut-=1; delta=min(time-time_cut,time-(*ag).time_at_creation);}
    output_ex.sum_time_by_ctime_sex[time_cut][(*ag).sex]+=delta;
    time-=delta;
  }


  //double _age=(*ag).age_at_creation+(*ag).local_time;
  //while(_age>(*ag).age_at_creation)
  //{
  //  int age_cut=floor(_age);
  //  double delta=min(_age-age_cut,_age-(*ag).age_at_creation);
  //  if(delta==0) {age_cut-=1; delta=min(_age-age_cut,_age-(*ag).age_at_creation);}
  //  output_ex.sum_time_by_age_sex[age_cut][(*ag).sex]+=delta;
  //  _age-=delta;
  //}

  double _age=(*ag).age_at_creation+(*ag).local_time;
  int _low=floor((*ag).age_at_creation);
  int _high=ceil(_age);
  for(int i=_low;i<=_high;i++)
  {
    double delta=min(i+1,_age)-max(i,(*ag).age_at_creation);
    if(delta>1e-10) {
      output_ex.sum_time_by_age_sex[i-1][(*ag).sex]+=delta;
    }
  }

#endif


#if (OUTPUT_EX & OUTPUT_EX_COMORBIDITY) > 0
  output_ex.n_mi+=(*ag).n_mi;
  output_ex.n_stroke+=(*ag).n_stroke;
  output_ex.n_hf+=((*ag).hf_status>0);
#endif

  // needed for random number maintenance
  rand_NegBin_COPD(1, 1.1);
  rand_NegBin_NCOPD(1, 1.1);


  return(ag);
}



agent *event_stack;
int event_stack_pointer;


int push_event(agent *ag)
{
  if(event_stack_pointer==settings.event_stack_size) return(ERR_EVENT_STACK_FULL);
  if(settings.record_mode==record_mode_some_event)
  {
    int i;
    for(i=0;i<settings.n_events_to_record;i++)
    {
      if(settings.events_to_record[i]==(*ag).event)
      {
        event_stack[event_stack_pointer]=*ag;
        ++event_stack_pointer;
        return 0;
      }
    }
    return 0;
  }
  event_stack[event_stack_pointer]=*ag;
  ++event_stack_pointer;
  return(0);
}


//' Returns the events stack.
//' @param i number of event
//' @return events
//' @export
// [[Rcpp::export]]
List Cget_event(int i)
{
  return(get_agent(i,event_stack));
}

//' Returns total number of events.
//' @return number of events
//' @export
// [[Rcpp::export]]
int Cget_n_events() //number of events, not n events themselves;
  {
  return(event_stack_pointer);
  }

//' Returns all events of an agent.
//' @param id agent ID.
//' @return all events of agent \code{id}
//' @export
// [[Rcpp::export]]
DataFrame Cget_agent_events(int id) //Returns ALLva events of an agent;
  {
  DataFrame dfout;

  for(int i=0;i<event_stack_pointer;i++)
  {
    if(event_stack[i].id==id)
    {
      dfout.push_back(get_agent(i,event_stack));
    }
  }
  return(dfout);
  }


//' Returns all events of a certain type.
//' @param event_type a number
//' @return all events of the type \code{event_type}
//' @export
// [[Rcpp::export]]
DataFrame Cget_events_by_type(int event_type) //Returns all events of a given type for an agent;
  {
  DataFrame dfout;

  for(int i=0;i<event_stack_pointer;i++)
  {
    if(event_stack[i].event==event_type)
    {
      dfout.push_back(get_agent(i,event_stack));
    }
  }
  return(dfout);
  }


//' Returns all events.
//' @return all events
//' @export
// [[Rcpp::export]]
DataFrame Cget_all_events() //Returns all events from all agents;
  {
  DataFrame dfout;

  for(int i=0;i<event_stack_pointer;i++)
  {
    dfout.push_back(get_agent(i,event_stack));
  }
  return(dfout);
  }

//' Returns a matrix containing all events
//' @return a matrix containing all events
//' @export
// [[Rcpp::export]]
NumericMatrix Cget_all_events_matrix()
{
  NumericMatrix outm(event_stack_pointer,33);
  CharacterVector eventMatrixColNames(33);

// eventMatrixColNames = CharacterVector::create("id", "local_time","sex", "time_at_creation", "age_at_creation", "pack_years","gold","event","FEV1","FEV1_slope", "FEV1_slope_t","pred_FEV1","smoking_status", "localtime_at_COPD", "age_at_COPD", "weight_at_COPD", "height","followup_after_COPD", "FEV1_baseline");
// 'create' helper function is limited to 20 enteries

  eventMatrixColNames(0)  = "id";
  eventMatrixColNames(1)  = "local_time";
  eventMatrixColNames(2)  = "female";
  eventMatrixColNames(3)  = "time_at_creation";
  eventMatrixColNames(4)  = "age_at_creation";
  eventMatrixColNames(5)  = "pack_years";
  eventMatrixColNames(6)  = "gold";
  eventMatrixColNames(7)  = "event";
  eventMatrixColNames(8)  = "FEV1";
  eventMatrixColNames(9)  = "FEV1_slope";
  eventMatrixColNames(10) = "FEV1_acceleration";
  eventMatrixColNames(11) = "pred_FEV1";
  eventMatrixColNames(12) = "smoking_status";
  eventMatrixColNames(13) = "localtime_at_COPD";
  eventMatrixColNames(14) = "age_at_COPD";
  eventMatrixColNames(15) = "weight_at_COPD";
  eventMatrixColNames(16) = "height";
  eventMatrixColNames(17) = "followup_after_COPD";
  eventMatrixColNames(18) = "FEV1_baseline";
  eventMatrixColNames(19) = "exac_status";
  eventMatrixColNames(20) = "cough";
  eventMatrixColNames(21) = "phlegm";
  eventMatrixColNames(22) = "wheeze";
  eventMatrixColNames(23) = "dyspnea";
  eventMatrixColNames(24) = "gpvisits";
  eventMatrixColNames(25) = "diagnosis";
  eventMatrixColNames(26) = "medication_status";
  eventMatrixColNames(27) = "case_detection";
  eventMatrixColNames(28) = "cumul_cost";
  eventMatrixColNames(29) = "cumul_qaly";
  eventMatrixColNames(30) = "time_at_diagnosis";
  eventMatrixColNames(31) = "exac_history_n_moderate";
  eventMatrixColNames(32) = "exac_history_n_severe_plus";


  colnames(outm) = eventMatrixColNames;
  for(int i=0;i<event_stack_pointer;i++)
  {
    agent *ag=&event_stack[i];
    outm(i,0)=(*ag).id;
    outm(i,1)=(*ag).local_time;
    outm(i,2)=(*ag).sex;
    outm(i,3)=(*ag).time_at_creation;
    outm(i,4)=(*ag).age_at_creation;
    outm(i,5)=(*ag).pack_years;
    outm(i,6)=(*ag).gold;
    outm(i,7)=(*ag).event;
    outm(i,8)=(*ag).fev1;
    outm(i,9)=(*ag).fev1_slope;
    outm(i,10)=(*ag).fev1_slope_t;
    outm(i,11)=(*ag)._pred_fev1;
    outm(i,12)=(*ag).smoking_status;
    outm(i,13)=(*ag).local_time_at_COPD;
    outm(i,14)=(*ag).age_baseline;
    outm(i,15)=(*ag).weight_baseline;
    outm(i,16)=(*ag).height;
    outm(i,17)=(*ag).followup_time;
    outm(i,18)=(*ag).fev1_baseline;
    outm(i,19)=(*ag).exac_status;
    outm(i,20)=(*ag).cough;
    outm(i,21)=(*ag).phlegm;
    outm(i,22)=(*ag).wheeze;
    outm(i,23)=(*ag).dyspnea;
    outm(i,24)=(*ag).gpvisits;
    outm(i,25)=(*ag).diagnosis;
    outm(i,26)=(*ag).medication_status;
    outm(i,27)=(*ag).case_detection;
    outm(i,28)=(*ag).cumul_cost;
    outm(i,29)=(*ag).cumul_qaly;
    outm(i,30)=(*ag).time_at_diagnosis;
    outm(i,31)=(*ag).exac_history_n_moderate;
    outm(i,32)=(*ag).exac_history_n_severe_plus;

  }

  return(outm);
}



//////////////////////////////////////////////////////////////////EVENT_SMOKING////////////////////////////////////;
double event_smoking_change_tte(agent *ag)
{
  double rate, background_rate, diagnosed_rate=0;


  if((*ag).smoking_status==0)
  {
    rate=exp(input.smoking.ln_h_inc_betas[0]
               +input.smoking.ln_h_inc_betas[1]*(*ag).sex
               +input.smoking.ln_h_inc_betas[2]*((*ag).age_at_creation+(*ag).local_time)
               +input.smoking.ln_h_inc_betas[3]*pow((*ag).age_at_creation+(*ag).local_time,2)
               +input.smoking.ln_h_inc_betas[4]*(calendar_time+(*ag).local_time)); //TODO:should be cal+loc time???
  }
  else
  {
    background_rate=exp(input.smoking.ln_h_ces_betas[0]
               +input.smoking.ln_h_ces_betas[1]*(*ag).sex
               +input.smoking.ln_h_ces_betas[2]*((*ag).age_at_creation+(*ag).local_time)
               +input.smoking.ln_h_ces_betas[3]*pow((*ag).age_at_creation+(*ag).local_time,2)
               +input.smoking.ln_h_ces_betas[4]*(calendar_time+(*ag).local_time));

    diagnosed_rate=exp(input.smoking.ln_h_ces_betas[5] - input.smoking.smoking_ces_coefficient*((*ag).local_time-(*ag).time_at_diagnosis));

    rate = background_rate + (*ag).diagnosis * (*ag).smoking_at_diagnosis * (*ag).smoking_cessation * diagnosed_rate;
  }


  double tte=rand_exp()/rate;

  return(tte);
}





void event_smoking_change_process(agent *ag)
{
  smoking_LPT(ag);
 // if ((*ag).gold==0) { //for debug porpuses. No smoking change when COPD present
    if((*ag).smoking_status==0) {
      (*ag).smoking_status=1;
    }

    else {
      (*ag).smoking_status=0;
    }

//   }
}









//////////////////////////////////////////////////////////////////EVENT_COPD////////////////////////////////////;
double event_COPD_tte(agent *ag)
{
  if((*ag).gold>0) return(HUGE_VAL);

  double rate=exp(input.COPD.ln_h_COPD_betas_by_sex[0][(*ag).sex]
                    +input.COPD.ln_h_COPD_betas_by_sex[1][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)
                    +input.COPD.ln_h_COPD_betas_by_sex[2][(*ag).sex]*pow((*ag).age_at_creation+(*ag).local_time,2)
                    +input.COPD.ln_h_COPD_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
                    +input.COPD.ln_h_COPD_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
                    +input.COPD.ln_h_COPD_betas_by_sex[5][(*ag).sex]*(calendar_time+(*ag).local_time)
  );


  double tte;
  if(rate==0) tte=HUGE_VAL; else tte=rand_exp()/rate;
  //return(HUGE_VAL);
  return(tte);
}



void event_COPD_process(agent *ag)
{
  (*ag).weight_baseline = (*ag).weight;
  (*ag).age_baseline = (*ag).local_time+(*ag).age_at_creation;
  (*ag).followup_time = 0 ;
  (*ag).local_time_at_COPD = (*ag).local_time;

  (*ag).fev1=input.lung_function.fev1_0_inc_betas_by_sex[0][(*ag).sex]
  +input.lung_function.fev1_0_inc_betas_by_sex[1][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)
  +input.lung_function.fev1_0_inc_betas_by_sex[2][(*ag).sex]*(*ag).height*(*ag).height
  +input.lung_function.fev1_0_inc_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
  +rand_norm()*input.lung_function.fev1_0_inc_sd_by_sex[(*ag).sex];

  double _beta_0=(*ag).fev1-
  (input.lung_function.fev1_0_ZafarCMAJ_by_sex[1][(*ag).sex]*(*ag).age_baseline
     +input.lung_function.fev1_0_ZafarCMAJ_by_sex[2][(*ag).sex]*(*ag).weight_baseline
     +input.lung_function.fev1_0_ZafarCMAJ_by_sex[3][(*ag).sex]*(*ag).height
     +input.lung_function.fev1_0_ZafarCMAJ_by_sex[4][(*ag).sex]*(*ag).height*(*ag).height
     +input.lung_function.fev1_0_ZafarCMAJ_by_sex[5][(*ag).sex]*(*ag).smoking_status
     +input.lung_function.fev1_0_ZafarCMAJ_by_sex[6][(*ag).sex]*(*ag).age_baseline*(*ag).height*(*ag).height);

     double _beta_0_prime=rand_norm()*sqrt((1-input.lung_function.dfev1_re_rho*input.lung_function.dfev1_re_rho)*input.lung_function.dfev1_sigmas[1]*input.lung_function.dfev1_sigmas[1])+
     (input.lung_function.fev1_betas_by_sex[0][(*ag).sex]+input.lung_function.dfev1_sigmas[1]/input.lung_function.dfev1_sigmas[0]*input.lung_function.dfev1_re_rho*(_beta_0-input.lung_function.fev1_0_ZafarCMAJ_by_sex[0][(*ag).sex]));

     (*ag).fev1_slope=_beta_0_prime
       +input.lung_function.fev1_betas_by_sex[1][(*ag).sex]*(*ag).age_baseline
       +input.lung_function.fev1_betas_by_sex[2][(*ag).sex]*(*ag).weight_baseline
       +input.lung_function.fev1_betas_by_sex[3][(*ag).sex]*(*ag).height
       +input.lung_function.fev1_betas_by_sex[4][(*ag).sex]*(*ag).height*(*ag).height
       +input.lung_function.fev1_betas_by_sex[5][(*ag).sex]*(*ag).smoking_status
       +input.lung_function.fev1_betas_by_sex[6][(*ag).sex]*(*ag).age_baseline*(*ag).height*(*ag).height;

       (*ag).fev1_slope_t=input.lung_function.fev1_betas_by_sex[7][(*ag).sex];

       //Adjusting FEV1 tail
         if ((*ag).fev1 < (*ag).fev1_tail) {
          (*ag).fev1 = (*ag).fev1_tail;
          }

       double pred_fev1=CALC_PRED_FEV1(ag);
       (*ag)._pred_fev1=pred_fev1;
       if ((*ag).fev1/pred_fev1<0.3) (*ag).gold=4;
       else
         if ((*ag).fev1/pred_fev1<0.5) (*ag).gold=3;
         else
           if ((*ag).fev1/pred_fev1<0.8) (*ag).gold=2;
           else (*ag).gold=1;

           // FEV Decline

           (*ag).fev1_baseline = (*ag).fev1;

           // Intercept for FEv1 decline in COPD incidence cases
           // double fev1_mean_bivariate = input.lung_function.fev1_betas_by_sex[0][(*ag).sex]
           // + (input.lung_function.dfev1_sigmas[1]/input.lung_function.dfev1_sigmas[0]*input.lung_function.dfev1_re_rho) * ((*ag).fev1_baseline - (*ag).fev1_baseline_ZafarCMAJ - input.lung_function.fev1_0_ZafarCMAJ_by_sex[0][(*ag).sex]);
           //
           // double fev1_variance_bivariate = ((1-input.lung_function.dfev1_re_rho*input.lung_function.dfev1_re_rho)*input.lung_function.dfev1_sigmas[1]*input.lung_function.dfev1_sigmas[1]);

           // (*ag).fev1_decline_intercept = 0*rand_norm()*sqrt(fev1_variance_bivariate) + 0*fev1_mean_bivariate;
           //
           // // Calcuating FEV1_baseline based on Zafar's CMAJ paper, excluding the intercept term
           // (*ag).fev1_baseline_ZafarCMAJ = input.lung_function.fev1_0_ZafarCMAJ_by_sex[1][(*ag).sex]*(*ag).age_baseline
           //   +input.lung_function.fev1_0_ZafarCMAJ_by_sex[2][(*ag).sex]*(*ag).weight_baseline
           //   +input.lung_function.fev1_0_ZafarCMAJ_by_sex[3][(*ag).sex]*(*ag).height
           //   +input.lung_function.fev1_0_ZafarCMAJ_by_sex[4][(*ag).sex]*(*ag).height*(*ag).height
           //   +input.lung_function.fev1_0_ZafarCMAJ_by_sex[5][(*ag).sex]*(*ag).smoking_status
           //   +input.lung_function.fev1_0_ZafarCMAJ_by_sex[6][(*ag).sex]*(*ag).age_baseline*(*ag).height*(*ag).height;
           //
           // (*ag).fev1_slope=  (*ag).fev1_decline_intercept
           // +input.lung_function.fev1_betas_by_sex[1][(*ag).sex]*(*ag).age_baseline
           // +input.lung_function.fev1_betas_by_sex[2][(*ag).sex]*(*ag).weight_baseline
           // +input.lung_function.fev1_betas_by_sex[3][(*ag).sex]*(*ag).height
           // +input.lung_function.fev1_betas_by_sex[4][(*ag).sex]*(*ag).height*(*ag).height
           // +input.lung_function.fev1_betas_by_sex[5][(*ag).sex]*(*ag).smoking_status
           // +input.lung_function.fev1_betas_by_sex[6][(*ag).sex]*(*ag).age_baseline*(*ag).height*(*ag).height;
           //Follow_up term is not used here because this part of code is executed once and should be time independent



           (*ag).lung_function_LPT=(*ag).local_time;

#if OUTPUT_EX>1
           output_ex.cumul_non_COPD_time+=(*ag).local_time;
#endif
#if (OUTPUT_EX & OUTPUT_EX_COPD) > 0
           output_ex.n_inc_COPD_by_ctime_age[(int)floor((*ag).time_at_creation+(*ag).local_time)][(int)(floor((*ag).age_at_creation+(*ag).local_time))]+=1;
#endif
}







//////////////////////////////////////////////////////////////////EVENT_EXACERBATION////////////////////////////////////;
double event_exacerbation_tte(agent *ag)
{
  if((*ag).gold==0 || (*ag).exac_status>0) return(HUGE_VAL);

  double rate=exp((*ag).ln_exac_rate_intercept
                    +input.exacerbation.ln_rate_betas[0]
                    +input.exacerbation.ln_rate_betas[1]*(*ag).sex
                    +input.exacerbation.ln_rate_betas[2]*((*ag).age_at_creation+(*ag).local_time)
                    +input.exacerbation.ln_rate_betas[3]*(*ag).fev1
                    +input.exacerbation.ln_rate_betas[4]*(*ag).smoking_status
                    +input.exacerbation.ln_rate_betas[5]*((*ag).gold==1)
                    +input.exacerbation.ln_rate_betas[6]*((*ag).gold==2)
                    +input.exacerbation.ln_rate_betas[7]*((*ag).gold==3)
                    +input.exacerbation.ln_rate_betas[8]*((*ag).gold==4)
                    //+input.exacerbation.ln_rate_betas[9]*((*ag).diagnosis)
                    +input.medication.medication_ln_hr_exac[(*ag).medication_status] );

  (*ag).tmp_exac_rate= rate;

  if((*ag).medication_status>0)
  {
    for(int i=0;i<N_MED_CLASS;i++)
      if(((*ag).medication_status >> i) & 1)
        rate=rate*exp(input.medication.ln_rr_exac_by_class[i]);
  }

  double tte;

  if(rate==0) tte=HUGE_VAL; else tte=rand_exp()/rate;

  return(tte);
}





void event_exacerbation_process(agent *ag)
{
  double temp=(*ag).logit_exac_severity_intercept
  +input.exacerbation.logit_severity_betas[3]*(*ag).sex
  +input.exacerbation.logit_severity_betas[4]*((*ag).age_at_creation+(*ag).local_time)
  +input.exacerbation.logit_severity_betas[5]*(*ag).fev1
  +input.exacerbation.logit_severity_betas[6]*(*ag).smoking_status
  +input.exacerbation.logit_severity_betas[7]*(*ag).pack_years
  +input.exacerbation.logit_severity_betas[8]*(*ag).weight/((*ag).height*(*ag).height);

  double l1,l2,l3;
  l1=temp+input.exacerbation.logit_severity_betas[0];
  l2=temp+input.exacerbation.logit_severity_betas[1];
  l3=temp+input.exacerbation.logit_severity_betas[2];
  double p1,p2,p3;

  p1=1/(1+exp(-l1));
  p2=1/(1+exp(-l2))-1/(1+exp(-l1));
  p3=1/(1+exp(-l3))-1/(1+exp(-l2));
  // no need for p4, as its value is determined as 1-(p1+p2+p3)

  double r=rand_unif();

  if(r<p1) (*ag).exac_status=1;
  else if(r<(p1+p2)) (*ag).exac_status=2;
  else if(r<(p1+p2+p3)) (*ag).exac_status=3;
  else (*ag).exac_status=4;

  (*ag).cumul_exac[(*ag).exac_status-1]+=1;
  (*ag).exac_LPT=(*ag).local_time;


  double hosp_diagnosis;


  //Update exacerbation history
  if ((*ag).exac_status==2) (*ag).exac_history_n_moderate++;
  if ((*ag).exac_status>2) (*ag).exac_history_n_severe_plus++;


  (*ag).exac_history_time_second=(*ag).exac_history_time_first;
  (*ag).exac_history_severity_second=(*ag).exac_history_severity_first;
  (*ag).exac_history_time_first=(*ag).local_time;
  (*ag).exac_history_severity_first=(*ag).exac_status;


  if ((*ag).diagnosis==0)
  {
    if((*ag).gold>0 && (*ag).exac_status>2)
    {
      hosp_diagnosis = input.diagnosis.p_hosp_diagnosis;
    } else
    {
      hosp_diagnosis = 0;
    }
    if (rand_unif() < hosp_diagnosis)
    {
      (*ag).diagnosis = 1;
      (*ag).time_at_diagnosis=(*ag).local_time;
      (*ag).smoking_at_diagnosis=(*ag).smoking_status;

      if ((*ag).smoking_status==1 && (rand_unif()<input.smoking.smoking_cessation_adherence))
      {
        (*ag).cumul_cost+=(input.cost.cost_smoking_cessation/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time-1));
        (*ag).smoking_cessation=1;
        (*ag).smoking_cessation_count=1;
      }
    }
  }


  if((*ag).diagnosis==1 && (*ag).exac_status==2 && (*ag).dyspnea==1)
  {
    if (rand_unif() < input.medication.medication_adherence)
        {
        (*ag).medication_status= max(MED_CLASS_LAMA, (*ag).medication_status);
        medication_LPT(ag);
        }
  }

  if((*ag).diagnosis==1 && (*ag).exac_status==2 && (*ag).dyspnea==0)
  {
      if (rand_unif() < input.medication.medication_adherence)
        {
        (*ag).medication_status= max(MED_CLASS_SABA, (*ag).medication_status);
        medication_LPT(ag);
        }
  }

  if((*ag).diagnosis==1 && (*ag).dyspnea==0 && (((*ag).exac_status>2) |
     ((*ag).exac_history_severity_first==2 && ((*ag).local_time - (*ag).exac_history_time_first) <1 &&
     (*ag).exac_history_severity_second==2 && ((*ag).local_time - (*ag).exac_history_time_second) <1)))
  {
        if (rand_unif() < input.medication.medication_adherence)
        {
          (*ag).medication_status= max(MED_CLASS_LAMA | MED_CLASS_LABA, (*ag).medication_status);
          medication_LPT(ag);
        }
  }

  if((*ag).diagnosis==1 && (*ag).dyspnea==1 && (((*ag).exac_status>2) |
     ((*ag).exac_history_severity_first==2 && ((*ag).local_time - (*ag).exac_history_time_first) <1 &&
     (*ag).exac_history_severity_second==2 && ((*ag).local_time - (*ag).exac_history_time_second) <1)))
  {
      if (rand_unif() < input.medication.medication_adherence)
        {
          (*ag).medication_status=MED_CLASS_ICS | MED_CLASS_LAMA | MED_CLASS_LABA;
          medication_LPT(ag);
        }
  }

  #if (OUTPUT_EX & OUTPUT_EX_MEDICATION) > 0
    if((*ag).medication_status>0)
    {
      for(int i=0;i<N_MED_CLASS;i++)
        if(((*ag).medication_status >> i) & 1)
        {
          output_ex.n_exac_by_medication_class[i][(*ag).exac_status-1]+=1;
        }
    }
  #endif

  #if (OUTPUT_EX & OUTPUT_EX_EXACERBATION)>0
    output_ex.n_exac_by_ctime_age[(int)floor((*ag).time_at_creation+(*ag).local_time)][(int)(floor((*ag).age_at_creation+(*ag).local_time))]+=1;
    output_ex.n_exac_by_ctime_severity[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).exac_status-1]+=1;
    output_ex.n_exac_by_gold_severity[(*ag).gold-1][(*ag).exac_status-1]+=1;
    if ((*ag).diagnosis==1) output_ex.n_exac_by_gold_severity_diagnosed[(*ag).gold-1][(*ag).exac_status-1]+=1;
    output_ex.n_exac_by_ctime_severity_female[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).exac_status-1]+=(*ag).sex;
    output_ex.n_exac_by_ctime_GOLD[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).gold-1]+=1;
    if ((*ag).exac_status > 2) output_ex.n_severep_exac_by_ctime_age[(int)floor((*ag).time_at_creation+(*ag).local_time)][(int)(floor((*ag).age_at_creation+(*ag).local_time))]+=1;
    if ((*ag).diagnosis==0 && (*ag).gold>0) output_ex.n_exac_by_ctime_severity_undiagnosed[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).exac_status-1]+=1;
    if ((*ag).diagnosis==1 && (*ag).gold>0) output_ex.n_exac_by_ctime_severity_diagnosed[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).exac_status-1]+=1;

  #endif

}

//////////////////////////////////////////////////////////////////EVENT_EXACERBATIN_END////////////////////////////////////;
double event_exacerbation_end_tte(agent *ag)
{
  if((*ag).exac_status==0) return(HUGE_VAL);

  double rate=input.exacerbation.exac_end_rate[(*ag).exac_status-1];

  double tte;

  if(rate==0) tte=HUGE_VAL; else tte=rand_exp()/rate;

  return(tte);
}





void event_exacerbation_end_process(agent *ag)
{
  (*ag).cumul_cost+=(input.cost.exac_dcost[(*ag).exac_status-1]/pow(1+input.global_parameters.discount_cost,(*ag).time_at_creation+(*ag).local_time-1));
  output_ex.annual_cost_ctime[(int)floor((*ag).time_at_creation+(*ag).local_time)]+=(*ag).cumul_cost-(*ag).cumul_cost_prev_yr;
  (*ag).cumul_cost_prev_yr=(*ag).cumul_cost;
  (*ag).cumul_qaly+=(input.utility.exac_dutil[(*ag).exac_status-1][(*ag).gold-1]/pow(1+input.global_parameters.discount_qaly,(*ag).time_at_creation+(*ag).local_time-1));
  (*ag).exac_status=0;
}











//////////////////////////////////////////////////////////////////EVENT_EXACERBATIN_DEATH////////////////////////////////////;
double event_exacerbation_death_tte(agent *ag)
{
  if((*ag).exac_status == 0) return(HUGE_VAL);

  double tte=HUGE_VAL;

  //  double p=input.exacerbation.logit_logit_p_death_by_sex[(*ag).exac_status-1];


  double p = 0;
  if ((*ag).exac_status > 2) {
    p = exp(input.exacerbation.logit_p_death_by_sex[0][(*ag).sex]
              + input.exacerbation.logit_p_death_by_sex[1][(*ag).sex]*((*ag).local_time+(*ag).age_at_creation)
              + input.exacerbation.logit_p_death_by_sex[2][(*ag).sex]*((*ag).exac_status==1)
              + input.exacerbation.logit_p_death_by_sex[3][(*ag).sex]*((*ag).exac_status==2)
              + input.exacerbation.logit_p_death_by_sex[4][(*ag).sex]*((*ag).exac_status==3)
              + input.exacerbation.logit_p_death_by_sex[5][(*ag).sex]*((*ag).exac_status==4)
              + input.exacerbation.logit_p_death_by_sex[6][(*ag).sex]*0 //Placeholder for incorporating history of smoking
    );
  }

  p = p / (1 + p);

  if (rand_unif() < p)
  {
    tte=1/input.exacerbation.exac_end_rate[(*ag).exac_status-1];
    //All death occur at the end of expected time of exacerbation (for now);
    (*ag).local_time += tte;
    return(0);
  }
  else
  {
    return(HUGE_VAL);
  }

}





void event_exacerbation_death_process(agent *ag)
{
  (*ag).alive=false;
#if (OUTPUT_EX & OUTPUT_EX_EXACERBATION)>0
  output_ex.n_exac_death_by_ctime_age[(int)floor((*ag).time_at_creation+(*ag).local_time)][(int)(floor((*ag).age_at_creation+(*ag).local_time))]+=1;
  output_ex.n_exac_death_by_ctime_severity[(int)floor((*ag).time_at_creation+(*ag).local_time)][(*ag).exac_status-1]+=1;
  output_ex.n_exac_death_by_age_sex[(int)(floor((*ag).age_at_creation+(*ag).local_time))][(*ag).sex]+=1;

#endif
  //Rprintf("Death by chocolate!\n");
}




////////////////////////////////////////////////////////////////////comorbidity events/////////////////////////////////////;
double event_mi_tte(agent *ag)
{
  double age=(*ag).local_time+(*ag).age_at_creation;
  double time=calendar_time+(*ag).local_time;
  //int age_cut=floor(age);

  double rate=exp(
    input.comorbidity.ln_h_mi_betas_by_sex[0][(*ag).sex]
  +input.comorbidity.ln_h_mi_betas_by_sex[1][(*ag).sex]*age
    +input.comorbidity.ln_h_mi_betas_by_sex[2][(*ag).sex]*age*age
    +input.comorbidity.ln_h_mi_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
    +input.comorbidity.ln_h_mi_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
    +input.comorbidity.ln_h_mi_betas_by_sex[5][(*ag).sex]*time
    +input.comorbidity.ln_h_mi_betas_by_sex[6][(*ag).sex]*((*ag).weight/pow((*ag).height,2))
    +input.comorbidity.ln_h_mi_betas_by_sex[7][(*ag).sex]*(*ag).gold
    +input.comorbidity.ln_h_mi_betas_by_sex[8][(*ag).sex]*((*ag).n_mi>0)
    +input.comorbidity.ln_h_mi_betas_by_sex[9][(*ag).sex]*(*ag).n_mi
  );

  if(rate==0) return(HUGE_VAL);
  return(rand_exp()/rate);
}



void event_mi_process(agent *ag)
{
  (*ag).n_mi++;
  (*ag).cumul_cost+=input.cost.mi_dcost;
  if(rand_unif()<input.comorbidity.p_mi_death)
  {
    (*ag).alive=0;
  }
#if (OUTPUT_EX & OUTPUT_EX_COMORBIDITY) > 0
  output_ex.n_incident_mi++;
  output_ex.n_mi_by_age_sex[(int)floor((*ag).local_time+(*ag).age_at_creation)][(*ag).sex]++;
  output_ex.n_mi_by_ctime_sex[(int)floor((*ag).local_time+calendar_time)][(*ag).sex]++;
#endif
}





double event_stroke_tte(agent *ag)
{
  double age=(*ag).local_time+(*ag).age_at_creation;
  double time=calendar_time+(*ag).local_time;
  //int age_cut=floor(age);

  double rate=exp(
    input.comorbidity.ln_h_stroke_betas_by_sex[0][(*ag).sex]
  +input.comorbidity.ln_h_stroke_betas_by_sex[1][(*ag).sex]*age
    +input.comorbidity.ln_h_stroke_betas_by_sex[2][(*ag).sex]*age*age
    +input.comorbidity.ln_h_stroke_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
    +input.comorbidity.ln_h_stroke_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
    +input.comorbidity.ln_h_stroke_betas_by_sex[5][(*ag).sex]*time
    +input.comorbidity.ln_h_stroke_betas_by_sex[6][(*ag).sex]*((*ag).weight/pow((*ag).height,2))
    +input.comorbidity.ln_h_stroke_betas_by_sex[7][(*ag).sex]*(*ag).gold
    +input.comorbidity.ln_h_stroke_betas_by_sex[8][(*ag).sex]*((*ag).n_mi>0)
    +input.comorbidity.ln_h_stroke_betas_by_sex[9][(*ag).sex]*(*ag).n_mi
    +input.comorbidity.ln_h_stroke_betas_by_sex[10][(*ag).sex]*((*ag).n_stroke>0)
    +input.comorbidity.ln_h_stroke_betas_by_sex[11][(*ag).sex]*(*ag).n_stroke
  );

  if(rate==0) return(HUGE_VAL);
  return(rand_exp()/rate);
}


void event_stroke_process(agent *ag)
{
  (*ag).n_stroke++;
  (*ag).cumul_cost+=input.cost.stroke_dcost;
  if(rand_unif()<input.comorbidity.p_stroke_death)
  {
    (*ag).alive=0;
  }
#if (OUTPUT_EX & OUTPUT_EX_COMORBIDITY) > 0
  output_ex.n_incident_stroke++;
  output_ex.n_stroke_by_age_sex[(int)floor((*ag).local_time+(*ag).age_at_creation)][(*ag).sex]++;
  output_ex.n_stroke_by_ctime_sex[(int)floor((*ag).local_time+calendar_time)][(*ag).sex]++;
#endif
}





double event_hf_tte(agent *ag)
{
  if((*ag).hf_status>0) return(HUGE_VAL);

  double age=(*ag).local_time+(*ag).age_at_creation;
  double time=calendar_time+(*ag).local_time;
  //int age_cut=floor(age);

  double rate=exp(
    input.comorbidity.ln_h_hf_betas_by_sex[0][(*ag).sex]
  +input.comorbidity.ln_h_hf_betas_by_sex[1][(*ag).sex]*age
    +input.comorbidity.ln_h_hf_betas_by_sex[2][(*ag).sex]*age*age
    +input.comorbidity.ln_h_hf_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
    +input.comorbidity.ln_h_hf_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
    +input.comorbidity.ln_h_hf_betas_by_sex[5][(*ag).sex]*time
    +input.comorbidity.ln_h_hf_betas_by_sex[6][(*ag).sex]*((*ag).weight/pow((*ag).height,2))
    +input.comorbidity.ln_h_hf_betas_by_sex[7][(*ag).sex]*(*ag).gold
    +input.comorbidity.ln_h_hf_betas_by_sex[8][(*ag).sex]*((*ag).n_mi>0)
    +input.comorbidity.ln_h_hf_betas_by_sex[9][(*ag).sex]*(*ag).n_mi
    +input.comorbidity.ln_h_hf_betas_by_sex[10][(*ag).sex]*((*ag).n_stroke>0)
    +input.comorbidity.ln_h_hf_betas_by_sex[11][(*ag).sex]*(*ag).n_stroke
  );

  if(rate==0) return(HUGE_VAL);
  return(rand_exp()/rate);
}


void event_hf_process(agent *ag)
{
  (*ag).hf_status=1;
#if (OUTPUT_EX & OUTPUT_EX_COMORBIDITY) > 0
  output_ex.n_incident_hf++;
#endif
}




////////////////////////////////////////////////////////////////////EVENT_bgd/////////////////////////////////////;
double event_bgd_tte(agent *ag)
{
  double age=(*ag).local_time+(*ag).age_at_creation;
  double time=(*ag).time_at_creation+(*ag).local_time;
  int age_cut=floor(age);

  double _or=exp(
    input.agent.ln_h_bgd_betas[0]
  +input.agent.ln_h_bgd_betas[1]*time
    +input.agent.ln_h_bgd_betas[2]*time*time
    +input.agent.ln_h_bgd_betas[3]*age
    +input.agent.ln_h_bgd_betas[4]*((*ag).n_mi>0)
    +input.agent.ln_h_bgd_betas[5]*((*ag).n_mi)
    +input.agent.ln_h_bgd_betas[6]*((*ag).n_stroke>0)
    +input.agent.ln_h_bgd_betas[7]*((*ag).n_stroke)
    +input.agent.ln_h_bgd_betas[8]*((*ag).hf_status));

    double ttd=HUGE_VAL;
    double p=input.agent.p_bgd_by_sex[age_cut][(int)(*ag).sex];
    if(p==0) return(ttd);

    double odds=p/(1-p)*_or;
    p=odds/(1+odds);

    //adjusting background mortality for current smokers
    if ((*ag).smoking_status > 1e-5) {
      p *= input.smoking.mortality_factor_current[0] * ((age >= 40) && (age < 50)) +
        input.smoking.mortality_factor_current[1] * ((age >= 50) && (age < 60)) +
        input.smoking.mortality_factor_current[2] * ((age >= 60) && (age < 70)) +
        input.smoking.mortality_factor_current[3] * ((age >= 70) && (age < 80)) +
        input.smoking.mortality_factor_current[4] * (age >= 80);

      if (p > 1) {p = 1;}

      //adjusting background mortality for former smokers
    } else if ((*ag).pack_years > 1e-5) {
      p *= input.smoking.mortality_factor_former[0] * ((age >= 40) && (age < 50)) +
        input.smoking.mortality_factor_former[1] * ((age >= 50) && (age < 60)) +
        input.smoking.mortality_factor_former[2] * ((age >= 60) && (age < 70)) +
        input.smoking.mortality_factor_former[3] * ((age >= 70) && (age < 80)) +
        input.smoking.mortality_factor_former[4] * (age >= 80);
      if (p > 1) {p = 1;}
    }
    if(p==1)
    {
      ttd=0;
    }
    else
    {
      double rate=-log(1-p);
      if(rate>0)  ttd=rand_exp()/rate; else ttd=HUGE_VAL;
      //if(rand_unif()<p) ttd=rand_unif();
    }
    return(ttd);
}





void event_bgd_process(agent *ag)
{
  (*ag).alive=false;
}















//////////////////////////////////////////////////////////////////EVENT_DOCTOR_VISIT////////////////////////////////////;
double event_doctor_visit_tte(agent *ag)
{
  return(HUGE_VAL); //Currently disabled;
  double rate=input.outpatient.rate_doctor_visit;

  double tte=rand_exp()/rate;

  return(tte);
}





void event_doctor_visit_process(agent *ag)
{
  if(rand_unif()<input.outpatient.p_specialist)
  {
    (*ag).last_doctor_visit_type=1;
  }
  else
  {
    (*ag).last_doctor_visit_type=0;
  }

  output.total_doctor_visit[(*ag).last_doctor_visit_type]+=1;

  output.total_cost+=input.cost.doctor_visit_by_type[(*ag).last_doctor_visit_type]/pow(1+input.global_parameters.discount_cost,(*ag).local_time+calendar_time);

  (*ag).last_doctor_visit_time=(*ag).local_time;
}




















/////////////////////////////////////////////////////////////////////EVENT_FIXED/////////////////////////////////;
#define EVENT_FIXED_FREQ 1

double event_fixed_tte(agent *ag)
{
  return(floor((*ag).local_time*EVENT_FIXED_FREQ)/EVENT_FIXED_FREQ+1/EVENT_FIXED_FREQ-(*ag).local_time);
}



agent *event_fixed_process(agent *ag)
{
  (*ag).weight+=input.agent.weight_0_betas[6];
  (*ag).weight_LPT=(*ag).local_time;



  update_symptoms(ag); //updating in the annual event
  update_gpvisits(ag);
  update_diagnosis(ag);

  smoking_LPT(ag);

  lung_function_LPT(ag);
  exacerbation_LPT(ag);
  payoffs_LPT(ag);
  medication_LPT(ag);



#ifdef OUTPUT_EX
  update_output_ex(ag);
#endif

  //resetting annual cost and qaly
    //(*ag).annual_cost=0;
    //(*ag).annual_qaly=0;

  //COPD;
  double COPD_odds=exp(input.COPD.logit_p_COPD_betas_by_sex[0][(*ag).sex]
                         +input.COPD.logit_p_COPD_betas_by_sex[1][(*ag).sex]*(*ag).age_at_creation
                         +input.COPD.logit_p_COPD_betas_by_sex[2][(*ag).sex]*(*ag).age_at_creation*(*ag).age_at_creation
                         +input.COPD.logit_p_COPD_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
                         +input.COPD.logit_p_COPD_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
                         +input.COPD.logit_p_COPD_betas_by_sex[5][(*ag).sex]*calendar_time)
                         //+input.COPD.logit_p_COPD_betas_by_sex[7]*(*ag).asthma
                         ;

  (*ag).p_COPD=COPD_odds/(1+COPD_odds);

  return(ag);
}








/////////////////////////////////////////////////////////event_birthday/////////////////////////////////////////////////

double event_birthday_tte(agent *ag)
{
  return(HUGE_VAL);
  double age=(*ag).age_at_creation+(*ag).local_time;
  double delta=1-(age-floor(age));
  if(delta==0) delta=1;
  //Rprintf("%f,%f\n",delta,(*ag).local_time+(*ag).age_at_creation);
  return(delta);
}


agent *event_birthday_process(agent *ag)
{
  //Rprintf("%f\n",(*ag).local_time+(*ag).age_at_creation);
  return(ag);
}






////////////////////////////////////////////////////////////////////////////////
// MEMORY MANAGEMENT
////////////////////////////////////////////////////////////////////////////////

/**
 * @brief Allocates memory resources required for simulation
 *
 * @return 0 on success, ERR_MEMORY_ALLOCATION_FAILED on failure
 *
 * This function allocates all dynamic memory needed by the simulation:
 *
 * ## Allocated Resources
 *
 * | Resource             | Size (configured via settings)      | Purpose                    |
 * |---------------------|-------------------------------------|----------------------------|
 * | runif_buffer        | runif_buffer_size * sizeof(double)  | Uniform random numbers     |
 * | rnorm_buffer        | rnorm_buffer_size * sizeof(double)  | Normal random numbers      |
 * | rexp_buffer         | rexp_buffer_size * sizeof(double)   | Exponential random numbers |
 * | rgamma_buffer_COPD  | rgamma_buffer_size * sizeof(double) | COPD gamma random numbers  |
 * | rgamma_buffer_NCOPD | rgamma_buffer_size * sizeof(double) | Non-COPD gamma randoms     |
 * | agent_stack         | agent_stack_size * sizeof(agent)    | Agent storage              |
 * | event_stack         | event_stack_size * sizeof(agent)    | Event recording storage    |
 *
 * ## Usage Notes
 *
 * - Must be called before running the simulation
 * - Called automatically by init_session() in R
 * - Call Cdeallocate_resources() when done to free memory
 * - Can be called multiple times (will realloc if buffers exist)
 *
 * @warning Buffers start with pointers set to trigger immediate refill
 *
 * @see Cdeallocate_resources() for cleanup
 * @see Cinit_session() which calls this function
 */
// [[Rcpp::export]]
int Callocate_resources()
{
  if(runif_buffer==NULL)
    runif_buffer=(double *)malloc(settings.runif_buffer_size*sizeof(double));
  else
    realloc(runif_buffer,settings.runif_buffer_size*sizeof(double));
  if(runif_buffer==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  runif_buffer_pointer=settings.runif_buffer_size; //invoikes fill next time;

  if(rnorm_buffer==NULL)
    rnorm_buffer=(double *)malloc(settings.rnorm_buffer_size*sizeof(double));
  else
    realloc(rnorm_buffer,settings.rnorm_buffer_size*sizeof(double));
  if(rnorm_buffer==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rnorm_buffer_pointer=settings.rnorm_buffer_size;

  if(rexp_buffer==NULL)
    rexp_buffer=(double *)malloc(settings.rexp_buffer_size*sizeof(double));
  else
    realloc(rexp_buffer,settings.rexp_buffer_size*sizeof(double));
  if(rexp_buffer==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rexp_buffer_pointer=settings.rexp_buffer_size;

  if(rgamma_buffer_COPD==NULL)
    rgamma_buffer_COPD=(double *)malloc(settings.rgamma_buffer_size*sizeof(double));
  else
    realloc(rgamma_buffer_COPD,settings.rgamma_buffer_size*sizeof(double));
  if(rgamma_buffer_COPD==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rgamma_buffer_pointer_COPD=settings.rgamma_buffer_size;

  if(rgamma_buffer_NCOPD==NULL)
    rgamma_buffer_NCOPD=(double *)malloc(settings.rgamma_buffer_size*sizeof(double));
  else
    realloc(rgamma_buffer_NCOPD,settings.rgamma_buffer_size*sizeof(double));
  if(rgamma_buffer_NCOPD==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rgamma_buffer_pointer_NCOPD=settings.rgamma_buffer_size;

  if(agent_stack==NULL)
    agent_stack=(agent *)malloc(settings.agent_stack_size*sizeof(agent));
  else
    realloc(agent_stack,settings.agent_stack_size*sizeof(agent));
  if(agent_stack==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  agent_stack_pointer=0;

  if(event_stack==NULL)
    event_stack=(agent *)malloc(settings.event_stack_size*sizeof(agent));
  else
    realloc(event_stack,settings.event_stack_size*sizeof(agent));
  if(event_stack==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);

  return(0);
}


// [[Rcpp::export]]
List Cget_pointers()
{
  return(Rcpp::List::create(
      //Rcpp::Named("runif_buffer_address")=reinterpret_cast<long &>(runif_buffer),
      //Rcpp::Named("rnorm_buffer_address")=reinterpret_cast<long &>(rnorm_buffer),
      //Rcpp::Named("rexp_buffer_address")=reinterpret_cast<long &>(rexp_buffer),
      //Rcpp::Named("agent_stack")=reinterpret_cast<long &>(agent_stack),
      //Rcpp::Named("event_stack")=reinterpret_cast<long &>(event_stack)
  )
  );
}



/**
 * @brief Deallocates all simulation memory resources
 *
 * @return 0 on success
 *
 * Frees all memory allocated by Callocate_resources().
 * Safe to call even if resources were not allocated (checks for NULL).
 *
 * @note Called automatically by terminate_session() in R
 * @note Uses try-catch to handle any deallocation errors gracefully
 *
 * @see Callocate_resources() for allocation
 */
// [[Rcpp::export]]
int Cdeallocate_resources()
{
  try
  {
    if(runif_buffer!=NULL) {free(runif_buffer); runif_buffer=NULL;}
    if(rnorm_buffer!=NULL) {free(rnorm_buffer); rnorm_buffer=NULL;}
    if(rexp_buffer!=NULL) {free(rexp_buffer); rexp_buffer=NULL;}
    if(rgamma_buffer_COPD!=NULL) {free(rgamma_buffer_COPD); rgamma_buffer_COPD=NULL;}
    if(rgamma_buffer_NCOPD!=NULL) {free(rgamma_buffer_NCOPD); rgamma_buffer_NCOPD=NULL;}
    if(agent_stack!=NULL) {free(agent_stack); agent_stack=NULL;}
    if(event_stack!=NULL) {free(event_stack); event_stack=NULL;}
  }catch(const std::exception& e){};
  return(0);
}




// [[Rcpp::export]]
int Cdeallocate_resources2()
{
  try
  {
    delete[] runif_buffer;
    delete[] rnorm_buffer;
    delete[] rexp_buffer;
    delete[] rgamma_buffer_COPD;
    delete[] rgamma_buffer_NCOPD;
    delete[] agent_stack;
    delete[] event_stack;
  }catch(const std::exception& e){};
  return(0);
}





int Callocate_resources2()
{
  //runif_buffer=(double *)malloc(runif_buffer_size*sizeof(double));
  runif_buffer=new double[settings.runif_buffer_size];
  if(runif_buffer==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  runif_buffer_pointer=settings.runif_buffer_size; //invokes fill next time;

  rnorm_buffer=new double[settings.rnorm_buffer_size];
  if(rnorm_buffer==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rnorm_buffer_pointer=settings.rnorm_buffer_size;

  rexp_buffer=new double[settings.rexp_buffer_size];
  if(rexp_buffer==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rexp_buffer_pointer=settings.rexp_buffer_size;

  rgamma_buffer_COPD=new double[settings.rgamma_buffer_size];
  if(rgamma_buffer_COPD==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rgamma_buffer_pointer_COPD=settings.rgamma_buffer_size;

  rgamma_buffer_NCOPD=new double[settings.rgamma_buffer_size];
  if(rgamma_buffer_NCOPD==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  rgamma_buffer_pointer_NCOPD=settings.rgamma_buffer_size;

  agent_stack=new agent[settings.agent_stack_size];
  if(agent_stack==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);
  agent_stack_pointer=0;

  event_stack=new agent[settings.event_stack_size];
  if(event_stack==NULL) return(ERR_MEMORY_ALLOCATION_FAILED);

  return(0);
}

/**
 * @brief Initializes a new simulation session
 *
 * @return 0 on success
 *
 * Resets all simulation state to prepare for a new run. This function:
 *
 * 1. Resets event_stack_pointer to 0
 * 2. Clears all output accumulators (reset_output, reset_output_ex)
 * 3. Resets runtime statistics
 * 4. Sets calendar_time to 0
 * 5. Resets last_id (agent counter) to 0
 *
 * @note Does NOT allocate memory - call Callocate_resources() first
 * @note Called by init_session() in R after memory allocation
 *
 * @see init_session() R wrapper that calls Cdeallocate/Callocate/Cinit_session
 */
// [[Rcpp::export]]
int Cinit_session()
{
  event_stack_pointer=0;

  reset_output();
  reset_output_ex();
  reset_runtime_stats(); runtime_stats.agent_size=sizeof(agent);

  calendar_time=0;
  last_id=0;

  return(0);
}



////////////////////////////////////////////////////////////////////////////////
// MAIN SIMULATION ENGINE
////////////////////////////////////////////////////////////////////////////////

/**
 * @brief Main discrete event simulation engine for EPIC
 *
 * @param max_n_agents Maximum number of agents to simulate (can be used to limit runtime)
 * @return 0 on success, negative error code on failure
 *
 * This is the core simulation loop that drives the EPIC model. It implements
 * a discrete event simulation (DES) approach where:
 *
 * ## Algorithm Overview
 *
 * 1. **Agent Creation Loop** (outer loop)
 *    - Creates new agents until time_horizon is reached or max_n_agents limit hit
 *    - Each agent starts at calendar_time and advances through local_time
 *
 * 2. **Event Processing Loop** (inner loop per agent)
 *    - Computes time-to-event (TTE) for all possible events
 *    - Selects the event with minimum TTE (next event)
 *    - Advances time and processes the winning event
 *    - Continues until agent dies, reaches max age, or simulation ends
 *
 * ## Event Types Processed
 *
 * | Event Type           | Description                              |
 * |---------------------|------------------------------------------|
 * | event_fixed         | Annual outcomes update                    |
 * | event_birthday      | Age increment, annual updates             |
 * | event_smoking_change| Smoking status transition                 |
 * | event_COPD          | COPD incidence                            |
 * | event_exacerbation  | Acute exacerbation onset                  |
 * | event_exacerbation_end | Exacerbation resolution                |
 * | event_doctor_visit  | Healthcare visit (currently disabled)     |
 * | event_bgd           | Background (non-COPD) death               |
 * | event_end           | Simulation end for agent                  |
 *
 * ## Agent Creation Modes
 *
 * Controlled by settings.agent_creation_mode:
 * - **agent_creation_mode_one**: Create one agent at a time (uses `smith`)
 * - **agent_creation_mode_all**: Create and store all agents in agent_stack
 * - **agent_creation_mode_pre**: Use pre-created agents from agent_stack
 *
 * ## Recording Modes
 *
 * Controlled by settings.record_mode:
 * - **record_mode_none**: Only aggregate outputs collected
 * - **record_mode_agent**: Agent-level outcomes recorded
 * - **record_mode_event**: All events for all agents recorded
 * - **record_mode_some_event**: Only specified event types recorded
 *
 * ## Time Management
 *
 * - `calendar_time`: Global simulation time (years from start)
 * - `local_time`: Time since agent creation
 * - Actual agent time = calendar_time + local_time
 *
 * @note This function is resumable - calendar_time persists between calls
 * @note Memory must be allocated via init_session() before calling
 *
 * @see create_agent() for agent initialization
 * @see push_event() for event recording
 * @see event_*_process() functions for event handlers
 *
 * @example
 * // Basic usage from R:
 * // init_session()
 * // run()  # which calls Cmodel internally
 * // Cget_output()
 * // terminate_session()
 */
// [[Rcpp::export]]
int Cmodel(int max_n_agents)
{
  if(max_n_agents<1) return(0);

  agent *ag;

  while(calendar_time<input.global_parameters.time_horizon && max_n_agents>0)
    //for(int i=0;i<n_agents;i++)
  {
    max_n_agents--;
    //calendar_time=0; NO! calendar_time is set to zero at init_session. Cmodel should be resumable;


    if(settings.random_number_agent_refill==1)
    {
      runif_buffer_pointer=settings.runif_buffer_size; //invokes fill next time;
      rnorm_buffer_pointer=settings.rnorm_buffer_size;
      rexp_buffer_pointer=settings.rexp_buffer_size;
      rgamma_buffer_pointer_COPD=settings.rgamma_buffer_size;
      rgamma_buffer_pointer_NCOPD=settings.rgamma_buffer_size;
    }

    switch(settings.agent_creation_mode)
    {

    case agent_creation_mode_one:
      ag=create_agent(&smith,last_id);
      break;

    case agent_creation_mode_all:
      ag=create_agent(&agent_stack[last_id],last_id);
      break;

    case agent_creation_mode_pre:
      ag=&agent_stack[last_id];
      break;

    default:
      return(-1);
    }

    (*ag).tte=0;
    event_start_process(ag);
    (*ag).event=event_start;
    if(settings.record_mode==record_mode_event || settings.record_mode==record_mode_agent || settings.record_mode==record_mode_some_event)
    {
      int _res=push_event(ag);
      if(_res<0) return(_res);
    }


    while(calendar_time+(*ag).local_time<input.global_parameters.time_horizon && (*ag).alive && (*ag).age_at_creation+(*ag).local_time<MAX_AGE)
    {


      double tte=input.global_parameters.time_horizon-calendar_time-(*ag).local_time;;
      int winner=-1;
      double temp;

      temp=event_fixed_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_fixed;
      }

      temp=event_birthday_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_birthday;
      }

      temp=event_smoking_change_tte(ag);
   //   if(temp<tte && (*ag).gold==0)  //for debug porpuses, no smoking change when COPD is present
      if(temp<tte)
      {
        tte=temp;
        winner=event_smoking_change;
      }

      temp=event_COPD_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_COPD;
      }

      temp=event_exacerbation_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_exacerbation;
      }

      temp=event_exacerbation_end_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_exacerbation_end;
      }

      temp=event_exacerbation_death_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_exacerbation_death;
      }

      temp=event_doctor_visit_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_doctor_visit;
      }

      // Comorbidity events (MI, stroke, HF) are not currently implemented

      temp=event_bgd_tte(ag);
      if(temp<tte)
      {
        tte=temp;
        winner=event_bgd;
      }


      if(calendar_time+(*ag).local_time+tte<input.global_parameters.time_horizon)
      {
        (*ag).tte=tte;
        (*ag).local_time=(*ag).local_time+tte;

        if(settings.update_continuous_outcomes_mode==1)
        {
          lung_function_LPT(ag);
          smoking_LPT(ag);
          exacerbation_LPT(ag);
          payoffs_LPT(ag);
          medication_LPT(ag);
        }

        switch(winner)
        {
        case event_fixed:
          event_fixed_process(ag);
          (*ag).event=event_fixed;
          break;
        case event_birthday:
          event_birthday_process(ag);
          (*ag).event=event_birthday;
          break;
        case event_smoking_change:
          event_smoking_change_process(ag);
          (*ag).event=event_smoking_change;
          break;
        case event_COPD:
          event_COPD_process(ag);
          (*ag).event=event_COPD;
          break;
        case event_exacerbation:
          event_exacerbation_process(ag);
          (*ag).event=event_exacerbation;
          break;
        case event_exacerbation_end:
          event_exacerbation_end_process(ag);
          (*ag).event=event_exacerbation_end;
          break;
        case event_exacerbation_death:
          event_exacerbation_death_process(ag);
          (*ag).event=event_exacerbation_death;
          break;
        case event_doctor_visit:
          event_doctor_visit_process(ag);
          (*ag).event=event_doctor_visit;
          break;
        /*case event_mi:
          event_mi_process(ag);
          (*ag).event=event_mi;
          break;
        case event_stroke:
          event_stroke_process(ag);
          (*ag).event=event_stroke;
          break;
        case event_hf:
          event_hf_process(ag);
          (*ag).event=event_hf;
          break;*/
        case event_bgd:
          event_bgd_process(ag);
          (*ag).event=event_bgd;
          break;
        }
        if(settings.record_mode==record_mode_event || settings.record_mode==record_mode_some_event)
        {
          int _res=push_event(ag);
          if(_res<0) return(_res);
        }
      }
      else
      {//past TH, set the local time to TH as the next step will be agent end;
        (*ag).tte=input.global_parameters.time_horizon-calendar_time-(*ag).local_time;
        (*ag).local_time=(*ag).local_time+(*ag).tte;
      }
    }//while (within agent)

    event_end_process(ag);
    (*ag).event=event_end;
    if(settings.record_mode==record_mode_event || settings.record_mode==record_mode_agent || settings.record_mode==record_mode_some_event)
    {
      int _res=push_event(ag);
      if(_res<0) return(_res);
    }

    if (output.n_agents>settings.n_base_agents)  //now we are done with prevalent cases and are creating incident cases;
      {
      double incidence = exp(input.agent.l_inc_betas[0]+input.agent.l_inc_betas[1]*calendar_time+input.agent.l_inc_betas[2]*calendar_time*calendar_time);
      if(incidence<0.000000000000001) calendar_time=input.global_parameters.time_horizon; else {
        if (calendar_time!=0) calendar_time=calendar_time+1/(incidence*settings.n_base_agents); else calendar_time=calendar_time+1; //suprresing incidence cases in the first year
      }
      }
    last_id++;
  }//Outer while (between-agent)
  return(0);
  }











