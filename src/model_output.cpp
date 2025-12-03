/**
 * @file model_output.cpp
 * @brief Output management for the EPIC model
 *
 * This module handles simulation outputs including basic outputs,
 * extended outputs (output_ex), and output update functions.
 */

#include "epic_model.h"

////////////////////////////////////////////////////////////////////////////////
// SECTION 4: OUTPUT
////////////////////////////////////////////////////////////////////////////////

void reset_output()
{
  output.n_agents=0;
  output.cumul_time=0;
  output.n_deaths=0;
  output.n_COPD=0;
  output.total_pack_years=0;
  output.total_exac[0]=0;output.total_exac[1]=0;output.total_exac[2]=0;output.total_exac[3]=0;
  output.total_exac_time[0]=0;output.total_exac_time[1]=0;output.total_exac_time[2]=0;output.total_exac_time[3]=0;
  output.total_cost=0;
  output.total_qaly=0;
  output.total_diagnosed_time=0;
}

//' Main outputs of the current run.
//' @return number of agents, cumulative time, number of deaths, number of COPD cases, as well as exacerbation statistics and QALYs.
//' @export
// [[Rcpp::export]]
List get_output()
{
  return Rcpp::List::create(
    Rcpp::Named("n_agents")=output.n_agents,
    Rcpp::Named("cumul_time")=output.cumul_time,
    Rcpp::Named("n_deaths")=output.n_deaths,
    Rcpp::Named("n_COPD")=output.n_COPD,
    Rcpp::Named("total_exac")=AS_VECTOR_INT(output.total_exac),
    Rcpp::Named("total_exac_time")=AS_VECTOR_DOUBLE(output.total_exac_time),
    Rcpp::Named("total_pack_years")=output.total_pack_years,
    Rcpp::Named("total_cost")=output.total_cost,
    Rcpp::Named("total_qaly")=output.total_qaly,
    Rcpp::Named("total_diagnosed_time")=output.total_diagnosed_time
  //Define your project-specific output here;
  );
}





void reset_output_ex()
{
#ifdef OUTPUT_EX
  char *x=reinterpret_cast <char *>(&output_ex);
  for(unsigned i=0;i<sizeof(output_ex);i++)
    x[i]=0;
#endif
}

//' Extra outputs from the model
//' @return Extra outputs from the model.
//' @export
// [[Rcpp::export]]
List get_output_ex()
{
  List out=Rcpp::List::create(
#ifdef OUTPUT_EX
    Rcpp::Named("n_alive_by_ctime_sex")=AS_MATRIX_INT_SIZE(output_ex.n_alive_by_ctime_sex,input.global_parameters.time_horizon),
    Rcpp::Named("n_alive_by_ctime_age")=AS_MATRIX_INT_SIZE(output_ex.n_alive_by_ctime_age,input.global_parameters.time_horizon),
    Rcpp::Named("n_smoking_status_by_ctime")=AS_MATRIX_INT_SIZE(output_ex.n_smoking_status_by_ctime,input.global_parameters.time_horizon),
    Rcpp::Named("n_current_smoker_by_ctime_sex")=AS_MATRIX_INT_SIZE(output_ex.n_current_smoker_by_ctime_sex,input.global_parameters.time_horizon),
    Rcpp::Named("annual_cost_ctime")=AS_VECTOR_DOUBLE_SIZE(output_ex.annual_cost_ctime,input.global_parameters.time_horizon),
    //Rcpp::Named("cumul_cost_gold_ctime")=AS_MATRIX_DOUBLE_SIZE(output_ex.cumul_cost_gold_ctime,input.global_parameters.time_horizon),
    //Rcpp::Named("cumul_qaly_ctime")=AS_VECTOR_DOUBLE_SIZE(output_ex.cumul_qaly_ctime,input.global_parameters.time_horizon),
    //Rcpp::Named("cumul_qaly_gold_ctime")=AS_MATRIX_DOUBLE_SIZE(output_ex.cumul_qaly_gold_ctime,input.global_parameters.time_horizon),
    Rcpp::Named("sum_fev1_ltime")=AS_VECTOR_DOUBLE_SIZE(output_ex.sum_fev1_ltime,input.global_parameters.time_horizon),
    Rcpp::Named("cumul_time_by_smoking_status")=AS_VECTOR_DOUBLE(output_ex.cumul_time_by_smoking_status),
    Rcpp::Named("cumul_non_COPD_time")=output_ex.cumul_non_COPD_time,
    Rcpp::Named("sum_p_COPD_by_ctime_sex")=AS_MATRIX_DOUBLE_SIZE(output_ex.sum_p_COPD_by_ctime_sex,input.global_parameters.time_horizon),
    Rcpp::Named("sum_pack_years_by_ctime_sex")=AS_MATRIX_DOUBLE_SIZE(output_ex.sum_pack_years_by_ctime_sex,input.global_parameters.time_horizon),
    Rcpp::Named("sum_age_by_ctime_sex")=AS_MATRIX_DOUBLE_SIZE(output_ex.sum_age_by_ctime_sex,input.global_parameters.time_horizon),
    Rcpp::Named("n_death_by_age_sex")=AS_MATRIX_INT(output_ex.n_death_by_age_sex),
    Rcpp::Named("n_alive_by_age_sex")=AS_MATRIX_INT(output_ex.n_alive_by_age_sex),
    Rcpp::Named("sum_time_by_ctime_sex")=AS_MATRIX_DOUBLE_SIZE(output_ex.sum_time_by_ctime_sex,input.global_parameters.time_horizon),
    Rcpp::Named("sum_time_by_age_sex")=AS_MATRIX_DOUBLE(output_ex.sum_time_by_age_sex)
#endif
#if (OUTPUT_EX & OUTPUT_EX_BIOMETRICS) > 0
  ,Rcpp::Named("sum_weight_by_ctime_sex")=AS_MATRIX_DOUBLE_SIZE(output_ex.sum_weight_by_ctime_sex,input.global_parameters.time_horizon)
#endif
  );


#if (OUTPUT_EX & OUTPUT_EX_COPD)>0
  out["n_COPD_by_ctime_sex"]=AS_MATRIX_INT_SIZE(output_ex.n_COPD_by_ctime_sex,input.global_parameters.time_horizon),
    out["n_COPD_by_ctime_age"]=AS_MATRIX_INT_SIZE(output_ex.n_COPD_by_ctime_age,input.global_parameters.time_horizon),
    out["n_inc_COPD_by_ctime_age"]=AS_MATRIX_INT_SIZE(output_ex.n_inc_COPD_by_ctime_age,input.global_parameters.time_horizon),
    out["n_COPD_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_COPD_by_ctime_severity,input.global_parameters.time_horizon),
    out["n_COPD_by_age_sex"]=AS_MATRIX_INT(output_ex.n_COPD_by_age_sex),
    out["n_Diagnosed_by_ctime_sex"]=AS_MATRIX_INT_SIZE(output_ex.n_Diagnosed_by_ctime_sex,input.global_parameters.time_horizon),
    out["n_Overdiagnosed_by_ctime_sex"]=AS_MATRIX_INT_SIZE(output_ex.n_Overdiagnosed_by_ctime_sex,input.global_parameters.time_horizon),
    out["n_Diagnosed_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_Diagnosed_by_ctime_severity,input.global_parameters.time_horizon),
    out["n_case_detection_by_ctime"]=AS_MATRIX_INT_SIZE(output_ex.n_case_detection_by_ctime,input.global_parameters.time_horizon),
    out["n_case_detection_eligible"]=output_ex.n_case_detection_eligible,
    out["n_diagnosed_true_CD"]=output_ex.n_diagnosed_true_CD,
    out["n_agents_CD"]=output_ex.n_agents_CD,
    out("cumul_time_by_ctime_GOLD")=AS_MATRIX_DOUBLE_SIZE(output_ex.cumul_time_by_ctime_GOLD,input.global_parameters.time_horizon);
#endif


#if (OUTPUT_EX & OUTPUT_EX_EXACERBATION)>0
    out["n_exac_by_ctime_age"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_ctime_age,input.global_parameters.time_horizon);
    out["n_severep_exac_by_ctime_age"]=AS_MATRIX_INT_SIZE(output_ex. n_severep_exac_by_ctime_age,input.global_parameters.time_horizon);
    out["n_exac_death_by_ctime_age"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_death_by_ctime_age,input.global_parameters.time_horizon);
    out["n_exac_death_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_death_by_ctime_severity,input.global_parameters.time_horizon);
    out["n_exac_death_by_age_sex"]=AS_MATRIX_INT(output_ex.n_exac_death_by_age_sex);
    out["n_exac_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_ctime_severity,input.global_parameters.time_horizon);
    out["n_exac_by_gold_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_gold_severity,4);
    out["n_exac_by_gold_severity_diagnosed"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_gold_severity_diagnosed,4);
    out["n_exac_by_ctime_severity_female"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_ctime_severity_female,input.global_parameters.time_horizon);
    out["n_exac_by_ctime_GOLD"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_ctime_GOLD,input.global_parameters.time_horizon);
    out["n_exac_by_ctime_severity_undiagnosed"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_ctime_severity_undiagnosed,input.global_parameters.time_horizon);
    out["n_exac_by_ctime_severity_diagnosed"]=AS_MATRIX_INT_SIZE(output_ex.n_exac_by_ctime_severity_diagnosed,input.global_parameters.time_horizon);
#endif

#if (OUTPUT_EX & OUTPUT_EX_GPSYMPTOMS)>0
    out["n_GPvisits_by_ctime_sex"]=AS_MATRIX_INT_SIZE(output_ex.n_GPvisits_by_ctime_sex,input.global_parameters.time_horizon),
      out["n_GPvisits_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_GPvisits_by_ctime_severity,input.global_parameters.time_horizon),
      out["n_GPvisits_by_ctime_diagnosis"]=AS_MATRIX_INT_SIZE(output_ex.n_GPvisits_by_ctime_diagnosis,input.global_parameters.time_horizon),
      out["n_cough_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_cough_by_ctime_severity,input.global_parameters.time_horizon),
      out["n_phlegm_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_phlegm_by_ctime_severity,input.global_parameters.time_horizon),
      out["n_wheeze_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_wheeze_by_ctime_severity,input.global_parameters.time_horizon),
      out["n_dyspnea_by_ctime_severity"]=AS_MATRIX_INT_SIZE(output_ex.n_dyspnea_by_ctime_severity,input.global_parameters.time_horizon),
#endif

// OUTPUT_EX_COMORBIDITY removed - MI/stroke/HF deprecated

#if (OUTPUT_EX & OUTPUT_EX_MEDICATION)>0
      out["medication_time_by_class"]=AS_VECTOR_DOUBLE(output_ex.medication_time_by_class);
      out["medication_time_by_ctime_class"]=AS_MATRIX_DOUBLE_SIZE(output_ex.medication_time_by_ctime_class,input.global_parameters.time_horizon);
      out["n_smoking_cessation_by_ctime"]=AS_VECTOR_DOUBLE_SIZE(output_ex.n_smoking_cessation_by_ctime,input.global_parameters.time_horizon);
      out["n_exac_by_medication_class"]=AS_MATRIX_DOUBLE(output_ex.n_exac_by_medication_class);
#endif

      return(out);
}



//This function must run ONLY on start and fixed events; any other place and will mess up!
void update_output_ex(agent *ag)
{
#ifdef OUTPUT_EX
  int time=floor((*ag).local_time+(*ag).time_at_creation);
  int local_time=floor((*ag).local_time);

    output_ex.annual_cost_ctime[time]+=(*ag).cumul_cost-(*ag).cumul_cost_prev_yr;
    (*ag).cumul_cost_prev_yr=(*ag).cumul_cost;


  //if(time>=(*ag).time_at_creation)
  {
    int age=floor((*ag).age_at_creation+(*ag).local_time);
    output_ex.n_alive_by_ctime_age[time][age-1]+=1;   //age-1 -> adjusting for zero based system in C.
    output_ex.n_alive_by_ctime_sex[time][(*ag).sex]+=1;
    output_ex.n_alive_by_age_sex[age-1][(*ag).sex]+=1;
    if((*ag).smoking_status==1)
    {
      output_ex.n_smoking_status_by_ctime[time][1]+=1;
      output_ex.n_current_smoker_by_ctime_sex[time][(*ag).sex]+=1;
    }
    else
      if((*ag).pack_years>0)
        output_ex.n_smoking_status_by_ctime[time][2]+=1;
      else
        output_ex.n_smoking_status_by_ctime[time][0]+=1;


      //output_ex.cumul_cost_ctime[time]+=(*ag).annual_cost;
      //output_ex.cumul_cost_gold_ctime[time][(*ag).gold]+=(*ag).annual_cost;
      //output_ex.cumul_qaly_ctime[time]+=(*ag).annual_qaly;
      //output_ex.cumul_qaly_gold_ctime[time][(*ag).gold]+=(*ag).annual_qaly;

        output_ex.sum_fev1_ltime[local_time]+=(*ag).fev1;

      double odds=exp(input.COPD.logit_p_COPD_betas_by_sex[0][(*ag).sex]
                        +input.COPD.logit_p_COPD_betas_by_sex[1][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)
                        +input.COPD.logit_p_COPD_betas_by_sex[2][(*ag).sex]*pow((*ag).age_at_creation+(*ag).local_time,2)
                        +input.COPD.logit_p_COPD_betas_by_sex[3][(*ag).sex]*(*ag).pack_years
                        +input.COPD.logit_p_COPD_betas_by_sex[4][(*ag).sex]*(*ag).smoking_status
                        +input.COPD.logit_p_COPD_betas_by_sex[5][(*ag).sex]*(calendar_time+(*ag).local_time)
      );
      output_ex.sum_p_COPD_by_ctime_sex[time][(*ag).sex]+=odds/(1+odds);
      output_ex.sum_pack_years_by_ctime_sex[time][(*ag).sex]+=(*ag).pack_years;
      output_ex.sum_age_by_ctime_sex[time][(*ag).sex]+=(*ag).age_at_creation+(*ag).local_time;


#if (OUTPUT_EX & OUTPUT_EX_BIOMETRICS)>0
      output_ex.sum_weight_by_ctime_sex[time][(*ag).sex]+=(*ag).weight;
#endif

#if (OUTPUT_EX & OUTPUT_EX_COPD)>0
      output_ex.n_COPD_by_ctime_sex[time][(*ag).sex]+=((*ag).gold>0)*1;
      output_ex.n_COPD_by_ctime_age[time][age-1]+=((*ag).gold>0)*1;
      output_ex.n_COPD_by_ctime_severity[time][((*ag).gold)]+=1;
      output_ex.n_COPD_by_age_sex[age-1][(*ag).sex]+=1;
      if((*ag).gold>0) output_ex.n_Diagnosed_by_ctime_sex[time][(*ag).sex]+=((*ag).diagnosis>0)*1;
      if((*ag).gold==0) output_ex.n_Overdiagnosed_by_ctime_sex[time][(*ag).sex]+=((*ag).diagnosis>0)*1;
      if((*ag).gold>0) output_ex.n_Diagnosed_by_ctime_severity[time][(*ag).gold]+=((*ag).diagnosis>0)*1;
      if((*ag).case_detection>0 && floor((*ag).local_time+(*ag).time_at_creation)>=input.diagnosis.case_detection_start_end_yrs[0] && floor((*ag).local_time+(*ag).time_at_creation)<=input.diagnosis.case_detection_start_end_yrs[1]) output_ex.n_case_detection_by_ctime[time][(*ag).case_detection-1]+=1;
      //if((*ag).local_time>0) output_ex.cumul_time_by_ctime_GOLD[time][((*ag).gold)]+=1;
#endif

#if (OUTPUT_EX & OUTPUT_EX_GPSYMPTOMS)>0
      output_ex.n_GPvisits_by_ctime_sex[time][(*ag).sex]+=((*ag).gpvisits)*1;
      output_ex.n_GPvisits_by_ctime_severity[time][(*ag).gold]+=((*ag).gpvisits)*1;
      if((*ag).gold>0) output_ex.n_GPvisits_by_ctime_diagnosis[time][(*ag).diagnosis]+=((*ag).gpvisits)*1;
      output_ex.n_cough_by_ctime_severity[time][(*ag).gold]+=((*ag).cough>0)*1;
      output_ex.n_phlegm_by_ctime_severity[time][(*ag).gold]+=((*ag).phlegm>0)*1;
      output_ex.n_wheeze_by_ctime_severity[time][(*ag).gold]+=((*ag).wheeze>0)*1;
      output_ex.n_dyspnea_by_ctime_severity[time][(*ag).gold]+=((*ag).dyspnea>0)*1;
#endif

  }
#endif
}








