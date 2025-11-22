/**
 * @file epic_model.h
 * @brief Main header file for the EPIC DES model
 *
 * This header contains all shared declarations, struct definitions,
 * and extern declarations needed across the modular EPIC implementation.
 */

#ifndef EPIC_MODEL_H
#define EPIC_MODEL_H

#include "RcppArmadillo.h"
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(cpp11)]]

#include <algorithm>
#include <cmath>

using namespace Rcpp;
using std::min;
using std::max;

////////////////////////////////////////////////////////////////////////////////
// CONSTANTS AND OUTPUT FLAGS
////////////////////////////////////////////////////////////////////////////////

#define OUTPUT_EX_BIOMETRICS 1
#define OUTPUT_EX_SMOKING 2
// OUTPUT_EX_COMORBIDITY removed - MI/stroke/HF deprecated
#define OUTPUT_EX_LUNG_FUNCTION 8
#define OUTPUT_EX_COPD 16
#define OUTPUT_EX_EXACERBATION 32
#define OUTPUT_EX_GPSYMPTOMS 64
#define OUTPUT_EX_MORTALITY 128
#define OUTPUT_EX_MEDICATION 256
#define OUTPUT_EX_POPULATION 512
#define OUTPUT_EX 65535

#define MAX_AGE 111
#define N_MED_CLASS 5

////////////////////////////////////////////////////////////////////////////////
// ENUMERATIONS
////////////////////////////////////////////////////////////////////////////////

enum errors {
  ERR_INCORRECT_SETTING_VARIABLE = -1,
  ERR_INCORRECT_VECTOR_SIZE = -2,
  ERR_INCORRECT_INPUT_VAR = -3,
  ERR_EVENT_STACK_FULL = -4,
  ERR_MEMORY_ALLOCATION_FAILED = -5
};

enum record_mode_enum {
  record_mode_none = 0,
  record_mode_agent = 1,
  record_mode_event = 2,
  record_mode_some_event = 3
};

enum agent_creation_mode_enum {
  agent_creation_mode_one = 0,
  agent_creation_mode_all = 1,
  agent_creation_mode_pre = 2
};

enum medication_classes {
  MED_CLASS_SABA = 1,
  MED_CLASS_LABA = 2,
  MED_CLASS_LAMA = 4,
  MED_CLASS_ICS = 8,
  MED_CLASS_MACRO = 16
};

enum events {
  event_start = 0,
  event_fixed = 1,
  event_birthday = 2,
  event_smoking_change = 3,
  event_COPD = 4,
  event_exacerbation = 5,
  event_exacerbation_end = 6,
  event_exacerbation_death = 7,
  event_doctor_visit = 8,
  event_medication_change = 9,
  event_bgd = 10,
  event_end = 11
};

////////////////////////////////////////////////////////////////////////////////
// UTILITY MACROS
////////////////////////////////////////////////////////////////////////////////

#define AS_VECTOR_DOUBLE(src) std::vector<double>(&src[0],&src[0]+sizeof(src)/sizeof(double))
#define AS_VECTOR_DOUBLE_SIZE(src,size) std::vector<double>(&src[0],&src[0]+size)
#define AS_MATRIX_DOUBLE(src) array_to_Rmatrix(std::vector<double>(&src[0][0],&src[0][0]+sizeof(src)/sizeof(double)),sizeof(src[0])/sizeof(double))
#define AS_MATRIX_DOUBLE_SIZE(src,size) array_to_Rmatrix(std::vector<double>(&src[0][0],&src[0][0]+size*sizeof(src[0])/sizeof(double)),sizeof(src[0])/sizeof(double))
#define AS_MATRIX_INT(src) array_to_Rmatrix(std::vector<int>(&src[0][0],&src[0][0]+sizeof(src)/sizeof(int)),sizeof(src[0])/sizeof(int))
#define AS_MATRIX_INT_SIZE(src,size) array_to_Rmatrix(std::vector<int>(&src[0][0],&src[0][0]+size*sizeof(src[0])/sizeof(int)),sizeof(src[0])/sizeof(int))
#define AS_VECTOR_INT(src) std::vector<int>(&src[0],&src[0]+sizeof(src)/sizeof(int))
#define AS_VECTOR_INT_SIZE(src,size) std::vector<int>(&src[0],&src[0]+size)

#define READ_R_VECTOR(src,dest) {if(src.size()==sizeof(dest)/sizeof(dest[0])) {std::copy(src.begin(),src.end(),&dest[0]); return(0);} else return(ERR_INCORRECT_VECTOR_SIZE);}
#define READ_R_MATRIX(src,dest) {if(src.size()==sizeof(dest)/sizeof(dest[0][0])) {std::copy(src.begin(),src.end(),&dest[0][0]); return(0);} else return(ERR_INCORRECT_VECTOR_SIZE);}

#define CALC_PRED_FEV1(ag) (input.lung_function.pred_fev1_betas_by_sex[0][(*ag).sex] \
+input.lung_function.pred_fev1_betas_by_sex[1][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time) \
+input.lung_function.pred_fev1_betas_by_sex[2][(*ag).sex]*((*ag).age_at_creation+(*ag).local_time)*((*ag).age_at_creation+(*ag).local_time) \
+input.lung_function.pred_fev1_betas_by_sex[3][(*ag).sex]*(*ag).height*(*ag).height)


////////////////////////////////////////////////////////////////////////////////
// STRUCT DEFINITIONS
////////////////////////////////////////////////////////////////////////////////

struct settings {
  int record_mode;
  int events_to_record[100];
  int n_events_to_record;
  int agent_creation_mode;
  int update_continuous_outcomes_mode;
  int random_number_agent_refill;
  int n_base_agents;
  int runif_buffer_size;
  int rnorm_buffer_size;
  int rexp_buffer_size;
  int rgamma_buffer_size;
  int agent_stack_size;
  int event_stack_size;
};

struct runtime_stats {
  int agent_size;
  int n_runif_fills;
  int n_rnorm_fills;
  int n_rexp_fills;
  int n_rgamma_fills_COPD;
  int n_rgamma_fills_NCOPD;
};

struct input {
  struct {
    int time_horizon;
    double y0;
    double age0;
    double discount_cost;
    double discount_qaly;
    int closed_cohort;
  } global_parameters;

  struct {
    double p_female;
    double height_0_betas[5];
    double height_0_sd;
    double weight_0_betas[7];
    double weight_0_sd;
    double height_weight_rho;
    double p_prevalence_age[111];
    double p_incidence_age[111];
    double l_inc_betas[3];
    double p_bgd_by_sex[111][2];
    double ln_h_bgd_betas[9];
  } agent;

  struct {
    double logit_p_current_smoker_0_betas[7];
    double logit_p_never_smoker_con_not_current_0_betas[7];
    double pack_years_0_betas[5];
    double pack_years_0_sd;
    double ln_h_inc_betas[5];
    double minimum_smoking_prevalence;
    double mortality_factor_current[5];
    double mortality_factor_former[5];
    double ln_h_ces_betas[6];
    double smoking_ces_coefficient;
    double smoking_cessation_adherence;
  } smoking;

  struct {
    double logit_p_COPD_betas_by_sex[7][2];
    double ln_h_COPD_betas_by_sex[7][2];
  } COPD;

  struct {
    double fev1_0_prev_betas_by_sex[6][2];
    double fev1_0_prev_sd_by_sex[2];
    double fev1_0_inc_betas_by_sex[6][2];
    double fev1_0_inc_sd_by_sex[2];
    double pred_fev1_betas_by_sex[4][2];
    double fev1_betas_by_sex[8][2];
    double dfev1_re_rho;
    double dfev1_sigmas[2];
    double fev1_0_ZafarCMAJ_by_sex[8][2];
  } lung_function;

  struct {
    double logit_p_prevalent_diagnosis_by_sex[9][2];
    double logit_p_diagnosis_by_sex[10][2];
    double p_hosp_diagnosis;
    double logit_p_overdiagnosis_by_sex[9][2];
    double p_correct_overdiagnosis;
    double p_case_detection[20];
    double case_detection_start_end_yrs[2];
    double years_btw_case_detection;
    double min_cd_age;
    double min_cd_pack_years;
    double min_cd_symptoms;
    double case_detection_methods[3][4];
    double case_detection_methods_eversmokers[3][5];
    double case_detection_methods_symptomatic[3][2];
  } diagnosis;

  struct {
    double ln_rate_betas[10];
    double ln_rate_intercept_sd;
    double rate_severity_intercept_rho;
    double logit_severity_betas[9];
    double logit_severity_intercept_sd;
    double exac_end_rate[4];
    double p_death[4];
    double logit_p_death_by_sex[7][2];
  } exacerbation;

  struct {
    double bg_cost_by_stage[5];
    double exac_dcost[4];
    double cost_case_detection;
    double cost_outpatient_diagnosis;
    double cost_gp_visit;
    double cost_smoking_cessation;
    double doctor_visit_by_type[2];
  } cost;

  struct {
    double bg_util_by_stage[5];
    double exac_dutil[4][4];
  } utility;

  struct {
    double rate_doctor_visit;
    double p_specialist;
    double ln_rate_gpvisits_COPD_by_sex[8][2];
    double ln_rate_gpvisits_nonCOPD_by_sex[7][2];
    double dispersion_gpvisits_COPD;
    double dispersion_gpvisits_nonCOPD;
  } outpatient;

  struct {
    double logit_p_cough_COPD_by_sex[5][2];
    double logit_p_cough_nonCOPD_by_sex[4][2];
    double logit_p_phlegm_COPD_by_sex[5][2];
    double logit_p_phlegm_nonCOPD_by_sex[4][2];
    double logit_p_wheeze_COPD_by_sex[5][2];
    double logit_p_wheeze_nonCOPD_by_sex[4][2];
    double logit_p_dyspnea_COPD_by_sex[5][2];
    double logit_p_dyspnea_nonCOPD_by_sex[4][2];
    double re_cough_sd;
    double re_phlegm_sd;
    double re_wheeze_sd;
    double re_dyspnea_sd;
    double re_cough_phlegm_rho;
    double re_wheeze_dyspnea_rho;
    double covariance_COPD[4][4];
    double covariance_nonCOPD[4][4];
  } symptoms;

  struct {
    double ln_h_start_betas_by_sex[8][2];
    double medication_ln_hr_exac[16];
    double medication_costs[16];
    double medication_utility[16];
    double medication_adherence;
    double ln_h_start_betas_by_class[5][8];
    double ln_h_stop_betas_by_class[5][8];
    double ln_rr_exac_by_class[5];
  } medication;

  struct {
  } project_specific;
};

struct agent {
  long id;
  double local_time;
  bool alive;
  bool sex;

  double age_at_creation;
  double age_baseline;

  double time_at_creation;
  double followup_time;

  double height;
  double weight;
  double weight_LPT;
  double weight_baseline;

  int smoking_status;
  double pack_years;
  double smoking_status_LPT;

  double fev1;
  double fev1_baseline;
  double fev1_slope;
  double fev1_slope_t;
  double fev1_tail;

  double lung_function_LPT;
  int gold;
  int local_time_at_COPD;
  double _pred_fev1;

  double ln_exac_rate_intercept;
  double logit_exac_severity_intercept;

  int cumul_exac[4];
  double cumul_exac_time[4];
  double exac_LPT;
  int exac_status;
  double tmp_exac_rate;

  double exac_history_time_first, exac_history_time_second;
  int exac_history_severity_first, exac_history_severity_second;

  int exac_history_n_moderate, exac_history_n_severe_plus;

  double symptom_score;

  double last_doctor_visit_time;
  int last_doctor_visit_type;

  int medication_status;
  double medication_LPT;

  double cumul_cost;
  double cumul_cost_prev_yr;
  double cumul_qaly;

  double payoffs_LPT;

  double tte;
  int event;

  double p_COPD;

  bool cough;
  bool phlegm;
  bool dyspnea;
  bool wheeze;

  int gpvisits;
  int diagnosis;
  double time_at_diagnosis;
  int smoking_at_diagnosis;
  bool smoking_cessation;
  int smoking_cessation_count;
  double p_hosp_diagnosis;
  double p_correct_overdiagnosis;
  int case_detection;
  int case_detection_eligible;
  int last_case_detection;
  double p_case_detection[20];
  double case_detection_start_end_yrs[2];
  int years_btw_case_detection;
  double min_cd_age;
  double min_cd_pack_years;
  int min_cd_symptoms;

  double re_cough;
  double re_phlegm;
  double re_dyspnea;
  double re_wheeze;
};

struct output {
  int n_agents;
  double cumul_time;
  int n_deaths;
  int n_COPD;
  double total_pack_years;
  int total_exac[4];
  double total_exac_time[4];
  int total_doctor_visit[2];
  double total_cost;
  double total_qaly;
  double total_diagnosed_time;
};

#ifdef OUTPUT_EX
struct output_ex {
  int n_alive_by_ctime_sex[1000][2];
  int n_smoking_status_by_ctime[1000][3];
  int n_alive_by_ctime_age[1000][111];
  int n_current_smoker_by_ctime_sex[1000][2];
  double annual_cost_ctime[1000];
  double sum_fev1_ltime[1000];
  double cumul_time_by_smoking_status[3];
  double sum_time_by_ctime_sex[100][2];
  double sum_time_by_age_sex[111][2];

#if OUTPUT_EX > 1
  double cumul_non_COPD_time;
  double sum_p_COPD_by_ctime_sex[1000][2];
  double sum_pack_years_by_ctime_sex[1000][2];
  double sum_age_by_ctime_sex[1000][2];
  int n_death_by_age_sex[111][2];
  int n_alive_by_age_sex[111][2];
#endif

#if (OUTPUT_EX & OUTPUT_EX_COPD) > 0
  int n_COPD_by_ctime_sex[1000][2];
  int n_COPD_by_ctime_age[100][111];
  int n_inc_COPD_by_ctime_age[100][111];
  int n_COPD_by_ctime_severity[100][5];
  int n_COPD_by_age_sex[111][2];
  int n_Diagnosed_by_ctime_sex[1000][2];
  int n_Overdiagnosed_by_ctime_sex[1000][2];
  int n_Diagnosed_by_ctime_severity[1000][5];
  int n_case_detection_by_ctime[1000][3];
  int n_case_detection_eligible;
  int n_diagnosed_true_CD;
  int n_agents_CD;
  double cumul_time_by_ctime_GOLD[100][5];
#endif

#if (OUTPUT_EX & OUTPUT_EX_EXACERBATION) > 0
  int n_exac_by_ctime_age[100][111];
  int n_severep_exac_by_ctime_age[100][111];
  int n_exac_death_by_ctime_age[100][111];
  int n_exac_death_by_ctime_severity[100][4];
  int n_exac_death_by_age_sex[111][2];
  int n_exac_by_ctime_severity[100][4];
  int n_exac_by_gold_severity[4][4];
  int n_exac_by_gold_severity_diagnosed[4][4];
  int n_exac_by_ctime_severity_female[100][4];
  int n_exac_by_ctime_GOLD[100][4];
  int n_exac_by_ctime_severity_undiagnosed[100][4];
  int n_exac_by_ctime_severity_diagnosed[100][4];
#endif

#if (OUTPUT_EX & OUTPUT_EX_GPSYMPTOMS) > 0
  int n_GPvisits_by_ctime_sex[1000][2];
  int n_GPvisits_by_ctime_severity[1000][5];
  int n_GPvisits_by_ctime_diagnosis[1000][2];
  int n_cough_by_ctime_severity[1000][5];
  int n_phlegm_by_ctime_severity[1000][5];
  int n_wheeze_by_ctime_severity[1000][5];
  int n_dyspnea_by_ctime_severity[1000][5];
#endif

// OUTPUT_EX_COMORBIDITY removed - MI/stroke/HF deprecated

#if (OUTPUT_EX & OUTPUT_EX_BIOMETRICS) > 0
  double sum_weight_by_ctime_sex[1000][2];
#endif

#if (OUTPUT_EX & OUTPUT_EX_MEDICATION) > 0
  double medication_time_by_class[N_MED_CLASS];
  double medication_time_by_ctime_class[1000][N_MED_CLASS];
  double n_exac_by_medication_class[N_MED_CLASS][3];
  int n_smoking_cessation_by_ctime[1000];
#endif
};
#endif

////////////////////////////////////////////////////////////////////////////////
// EXTERN GLOBAL VARIABLES
////////////////////////////////////////////////////////////////////////////////

extern double calendar_time;
extern int last_id;

extern struct settings settings;
extern struct runtime_stats runtime_stats;
extern struct input input;
extern struct output output;

#ifdef OUTPUT_EX
extern struct output_ex output_ex;
#endif

extern agent *agent_stack;
extern long agent_stack_pointer;
extern agent *event_stack;
extern long event_stack_pointer;
extern agent smith;

extern double *runif_buffer;
extern long runif_buffer_pointer;
extern double *rnorm_buffer;
extern long rnorm_buffer_pointer;
extern double *rexp_buffer;
extern long rexp_buffer_pointer;
extern double *rgamma_buffer_COPD;
extern long rgamma_buffer_pointer_COPD;
extern double *rgamma_buffer_NCOPD;
extern long rgamma_buffer_pointer_NCOPD;

////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
////////////////////////////////////////////////////////////////////////////////

// Utility functions
NumericMatrix array_to_Rmatrix(std::vector<double> x, int nCol);
NumericMatrix array_to_Rmatrix(std::vector<int> x, int nCol);

// Random number functions
double rand_unif();
double rand_norm();
double rand_exp();
double rand_gamma_COPD();
double rand_gamma_NCOPD();
int rand_Poisson(double rate);
int rand_NegBin(double rate, double dispersion, bool use_COPD_gamma);
int rand_NegBin_COPD(double rate, double dispersion);
int rand_NegBin_NCOPD(double rate, double dispersion);
void rbvnorm(double rho, double x[2]);
arma::mat mvrnormArma(int n, arma::vec mu, arma::mat sigma);
int runif_fill();
int rnorm_fill();
int rexp_fill();
int rgamma_fill_COPD();
int rgamma_fill_NCOPD();

// Reset functions
void reset_runtime_stats();
void reset_output();
void reset_output_ex();

// Output functions
void update_output_ex(agent *ag);

// Agent functions
agent *create_agent(agent *ag, int id);
List get_agent(agent *ag);
List get_agent(int id, agent agent_pointer[]);

// Agent update/LPT functions (defined in model.cpp)
void lung_function_LPT(agent *ag);
void smoking_LPT(agent *ag);
void exacerbation_LPT(agent *ag);
void payoffs_LPT(agent *ag);
void medication_LPT(agent *ag);
double update_symptoms(agent *ag);
double update_gpvisits(agent *ag);
double update_diagnosis(agent *ag);

// Event stack functions
int push_event(agent *ag);

// Event handler functions
agent *event_start_process(agent *ag);
agent *event_end_process(agent *ag);
agent *event_fixed_process(agent *ag);
agent *event_birthday_process(agent *ag);
void event_smoking_change_process(agent *ag);
void event_COPD_process(agent *ag);
void event_exacerbation_process(agent *ag);
void event_exacerbation_end_process(agent *ag);
void event_exacerbation_death_process(agent *ag);
void event_mi_process(agent *ag);
void event_stroke_process(agent *ag);
void event_hf_process(agent *ag);
void event_bgd_process(agent *ag);
void event_doctor_visit_process(agent *ag);

// Event time-to-event functions
double event_fixed_tte(agent *ag);
double event_birthday_tte(agent *ag);
double event_smoking_change_tte(agent *ag);
double event_COPD_tte(agent *ag);
double event_exacerbation_tte(agent *ag);
double event_exacerbation_end_tte(agent *ag);
double event_exacerbation_death_tte(agent *ag);
double event_mi_tte(agent *ag);
double event_stroke_tte(agent *ag);
double event_hf_tte(agent *ag);
double event_bgd_tte(agent *ag);
double event_doctor_visit_tte(agent *ag);

#endif // EPIC_MODEL_H
