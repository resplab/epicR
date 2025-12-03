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
int set_settings_var(std::string name,NumericVector value)
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
List get_settings()
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

//' Returns the size of agent struct in bytes
//' @return size of agent struct in bytes
//' @export
// [[Rcpp::export]]
int get_agent_size_bytes()
{
  return sizeof(agent);
}

//' Returns run time stats.
//' @return agent size as well as memory and random variable fill stats.
//' @export
// [[Rcpp::export]]
List get_runtime_stats()
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

//' Returns current simulation progress.
//' @return Number of agents processed so far (last_id).
//' @export
// [[Rcpp::export]]
int get_progress()
{
  return last_id;
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
List get_agent(long id)
{
  return(get_agent(id,agent_stack));
}

//' Returns agent Smith.
//' @return agent smith.
//' @export
// [[Rcpp::export]]
List get_smith()
{
  return(get_agent(&smith));
}









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
            (*ag).medication_status= max((int)MED_CLASS_SABA, (*ag).medication_status);
            medication_LPT(ag);
          }
    }

    if ((*ag).diagnosis == 1 && (*ag).dyspnea==1)
    {
          if (rand_unif() < input.medication.medication_adherence)
          {
            (*ag).medication_status= max((int)MED_CLASS_LAMA, (*ag).medication_status);
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
               (*ag).medication_status= max((int)MED_CLASS_SABA, (*ag).medication_status);
               medication_LPT(ag);
          }
      }

    if ((*ag).diagnosis == 1 && (*ag).dyspnea==1)
      {
          if (rand_unif() < input.medication.medication_adherence)
          {
            (*ag).medication_status= max((int)MED_CLASS_LAMA, (*ag).medication_status);
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
                      (*ag).medication_status= max((int)MED_CLASS_SABA, (*ag).medication_status);
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
 * @see model_run() for how agents are created during simulation
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

  //symptoms
  update_symptoms(ag);

  //diagnosis
  update_prevalent_diagnosis(ag);




  //payoffs;
  (*ag).cumul_cost=0;
  (*ag).cumul_cost_prev_yr=0;
  (*ag).cumul_qaly=0;

  (*ag).payoffs_LPT=0;

  return(ag);
}



// [[Rcpp::export]]
int create_agents()
{
  if(agent_stack==NULL) return(-1);
  for(int i=0;i<settings.agent_stack_size;i++)
  {
    create_agent(&agent_stack[i],i);
  }

  return(0);
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
 * - Call deallocate_resources() when done to free memory
 * - Can be called multiple times (will realloc if buffers exist)
 *
 * @warning Buffers start with pointers set to trigger immediate refill
 *
 * @see deallocate_resources() for cleanup
 * @see init_session_internal() which calls this function
 */
// Forward declaration for use in error cleanup
int deallocate_resources();

// [[Rcpp::export]]
int allocate_resources()
{
  double *temp_double;
  agent *temp_agent;

  // Helper macro for safe realloc - preserves original pointer on failure
  #define SAFE_REALLOC_DOUBLE(ptr, size) do { \
    temp_double = (double *)realloc(ptr, (size) * sizeof(double)); \
    if (temp_double == NULL) goto allocation_failed; \
    ptr = temp_double; \
  } while(0)

  #define SAFE_REALLOC_AGENT(ptr, size) do { \
    temp_agent = (agent *)realloc(ptr, (size) * sizeof(agent)); \
    if (temp_agent == NULL) goto allocation_failed; \
    ptr = temp_agent; \
  } while(0)

  // Allocate random number buffers
  SAFE_REALLOC_DOUBLE(runif_buffer, settings.runif_buffer_size);
  runif_buffer_pointer = settings.runif_buffer_size; // invokes fill next time

  SAFE_REALLOC_DOUBLE(rnorm_buffer, settings.rnorm_buffer_size);
  rnorm_buffer_pointer = settings.rnorm_buffer_size;

  SAFE_REALLOC_DOUBLE(rexp_buffer, settings.rexp_buffer_size);
  rexp_buffer_pointer = settings.rexp_buffer_size;

  SAFE_REALLOC_DOUBLE(rgamma_buffer_COPD, settings.rgamma_buffer_size);
  rgamma_buffer_pointer_COPD = settings.rgamma_buffer_size;

  SAFE_REALLOC_DOUBLE(rgamma_buffer_NCOPD, settings.rgamma_buffer_size);
  rgamma_buffer_pointer_NCOPD = settings.rgamma_buffer_size;

  // Allocate agent stack (always needed)
  if (settings.agent_stack_size > 0) {
    SAFE_REALLOC_AGENT(agent_stack, settings.agent_stack_size);
  }
  agent_stack_pointer = 0;

  // Only allocate event_stack if record_mode requires it (saves ~2GB when not recording)
  if (settings.record_mode != record_mode_none && settings.event_stack_size > 0) {
    SAFE_REALLOC_AGENT(event_stack, settings.event_stack_size);
  } else {
    // Free any previously allocated event_stack when not recording
    if (event_stack != NULL) {
      free(event_stack);
      event_stack = NULL;
    }
  }

  #undef SAFE_REALLOC_DOUBLE
  #undef SAFE_REALLOC_AGENT

  return(0);

allocation_failed:
  // Clean up all allocated memory on failure
  deallocate_resources();
  return(ERR_MEMORY_ALLOCATION_FAILED);
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
 * Frees all memory allocated by allocate_resources().
 * Safe to call even if resources were not allocated (checks for NULL).
 *
 * @note Called automatically by terminate_session() in R
 * @note Uses try-catch to handle any deallocation errors gracefully
 *
 * @see allocate_resources() for allocation
 */
// [[Rcpp::export]]
int deallocate_resources()
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
 * @note Does NOT allocate memory - call allocate_resources() first
 * @note Called by init_session() in R after memory allocation
 *
 * @see init_session() R wrapper that calls Cdeallocate/Callocate/init_session_internal
 */
// [[Rcpp::export]]
int init_session_internal()
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
 * // run()  # which calls model_run internally
 * // get_output()
 * // terminate_session()
 */
// [[Rcpp::export]]
int model_run(int max_n_agents)
{
  if(max_n_agents<1) return(0);

  agent *ag;

  // Progress reporting variables
  // Use n_base_agents for progress as that's the actual target
  int total_agents_target = settings.n_base_agents;
  int progress_check_interval = std::max(1, total_agents_target / 100); // Update every ~1%
  int last_percent_reported = 0;

  Rprintf("Simulating %d base agents: ", total_agents_target);
  R_FlushConsole();

  while(calendar_time<input.global_parameters.time_horizon && max_n_agents>0)
    //for(int i=0;i<n_agents;i++)
  {
    max_n_agents--;

    // Check for user interrupt and report progress periodically
    // Use last_id which tracks total agents created
    if (last_id > 0 && last_id % progress_check_interval == 0 && last_id <= total_agents_target) {
      Rcpp::checkUserInterrupt(); // Allow user to interrupt with Ctrl+C

      // Report progress in 10% increments using R's console output
      int current_percent = (last_id * 100) / total_agents_target;
      // Report in 10% increments (10, 20, 30... 90, 100)
      int milestone = (current_percent / 10) * 10;
      if (milestone > last_percent_reported && milestone <= 100) {
        if (milestone % 50 == 0) {
          Rprintf("%d%%\n", milestone);
        } else {
          Rprintf("%d%% ", milestone);
        }
        R_FlushConsole();
        last_percent_reported = milestone;
      }
    }
    //calendar_time=0; NO! calendar_time is set to zero at init_session. model_run should be resumable;


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











