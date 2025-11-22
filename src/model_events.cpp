/**
 * @file model_events.cpp
 * @brief Event handlers for the EPIC DES model
 *
 * This module contains all discrete event simulation event handlers including:
 * - event_start/end processing
 * - smoking change events
 * - COPD onset events
 * - exacerbation events (start, end, death)
 * - comorbidity events (MI, stroke, heart failure)
 * - background death events
 * - doctor visit events
 * - fixed time events (annual updates)
 * - birthday events
 */

#include "epic_model.h"

///////////////////////////////////////////////////////////////////EVENT/////////////////////////////////////////////////////////

// events enum is defined in epic_model.h

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






