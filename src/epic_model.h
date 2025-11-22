/**
 * @file epic_model.h
 * @brief Main header file for the EPIC DES model
 *
 * This header contains all shared declarations, struct definitions,
 * and extern declarations needed across the modular EPIC implementation.
 *
 * @author EPIC Development Team
 * @see model.cpp, model_random.cpp, model_agent.cpp, model_events.cpp
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
// CONSTANTS
////////////////////////////////////////////////////////////////////////////////

#define OUTPUT_EX_BIOMETRICS 1
#define OUTPUT_EX_SMOKING 2
#define OUTPUT_EX_COMORBIDITY 4
#define OUTPUT_EX_LUNG_FUNCTION 8
#define OUTPUT_EX_COPD 16
#define OUTPUT_EX_EXACERBATION 32
#define OUTPUT_EX_GPSYMPTOMS 64
#define OUTPUT_EX_MORTALITY 128
#define OUTPUT_EX_MEDICATION 256
#define OUTPUT_EX_POPULATION 512
#define OUTPUT_EX 65535

#define MAX_AGE 111

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
  MED_CLASS_MACRO = 16,
  N_MED_CLASS = 5
};

enum event_type {
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
  event_mi = 10,
  event_stroke = 11,
  event_hf = 12,
  event_bgd = 13,
  event_end = 14
};

////////////////////////////////////////////////////////////////////////////////
// UTILITY MACROS
////////////////////////////////////////////////////////////////////////////////

#define AS_VECTOR_DOUBLE(src) std::vector<double>(&src[0],&src[0]+sizeof(src)/sizeof(double))
#define AS_VECTOR_DOUBLE_SIZE(src,size) std::vector<double>(&src[0],&src[0]+size)
#define AS_MATRIX_DOUBLE(src)  array_to_Rmatrix(std::vector<double>(&src[0][0],&src[0][0]+sizeof(src)/sizeof(double)),sizeof(src[0])/sizeof(double))
#define AS_MATRIX_DOUBLE_SIZE(src,size)  array_to_Rmatrix(std::vector<double>(&src[0][0],&src[0][0]+size*sizeof(src[0])/sizeof(double)),sizeof(src[0])/sizeof(double))
#define AS_MATRIX_INT(src)  array_to_Rmatrix(std::vector<int>(&src[0][0],&src[0][0]+sizeof(src)/sizeof(int)),sizeof(src[0])/sizeof(int))
#define AS_MATRIX_INT_SIZE(src,size)  array_to_Rmatrix(std::vector<int>(&src[0][0],&src[0][0]+size*sizeof(src[0])/sizeof(int)),sizeof(src[0])/sizeof(int))
#define AS_VECTOR_INT(src) std::vector<int>(&src[0],&src[0]+sizeof(src)/sizeof(int))
#define AS_VECTOR_INT_SIZE(src,size) std::vector<int>(&src[0],&src[0]+size)

#define READ_R_VECTOR(src,dest) {if(src.size()==sizeof(dest)/sizeof(dest[0])) {std::copy(src.begin(),src.end(),&dest[0]); return(0);} else return(ERR_INCORRECT_VECTOR_SIZE);}
#define READ_R_MATRIX(src,dest) {if(src.size()==sizeof(dest)/sizeof(dest[0][0])) {std::copy(src.begin(),src.end(),&dest[0][0]); return(0);} else return(ERR_INCORRECT_VECTOR_SIZE);}

////////////////////////////////////////////////////////////////////////////////
// STRUCT DEFINITIONS
////////////////////////////////////////////////////////////////////////////////

/**
 * @struct settings_struct
 * @brief Model configuration settings
 */
struct settings_struct {
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

/**
 * @struct runtime_stats_struct
 * @brief Runtime statistics for debugging and profiling
 */
struct runtime_stats_struct {
  int agent_size;
  int n_runif_fills;
  int n_rnorm_fills;
  int n_rexp_fills;
  int n_rgamma_fills_COPD;
  int n_rgamma_fills_NCOPD;
};

/**
 * @struct input_struct
 * @brief All model input parameters
 */
struct input_struct {
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
    double logit_p_COPD_betas_by_sex[8][2];
    double ln_h_COPD_betas_by_sex[8][2];
  } COPD;

  struct {
    double fev1_0_prev_betas_by_sex[5][2];
    double fev1_0_prev_sd_by_sex[2];
    double fev1_0_inc_betas_by_sex[5][2];
    double fev1_0_inc_sd_by_sex[2];
    double pred_fev1_betas_by_sex[5][2];
    double fev1_betas_by_sex[8][2];
    double dfev1_re_rho;
    double dfev1_sigmas[2];
    double fev1_0_ZafarCMAJ_by_sex[8][2];
  } lung_function;

  struct {
    double logit_p_prevalent_diagnosis_by_sex[8][2];
    double logit_p_diagnosis_by_sex[8][2];
    double logit_p_overdiagnosis_by_sex[8][2];
    double p_correct_overdiagnosis;
  } diagnosis;

  struct {
    double ln_rate_betas[10];
    double ln_rate_intercept_sd;
    double rate_severity_intercept_rho;
    double logit_severity_betas[10];
    double logit_severity_intercept_sd;
    double exac_end_rate;
    double p_death[4];
  } exacerbation;

  struct {
    double bg_cost_by_stage[4];
    double exac_dcost[4];
    double cost_case_detection;
    double cost_outpatient_diagnosis;
    double cost_gp_visit;
    double cost_smoking_cessation;
  } cost;

  struct {
    double bg_util_by_stage[5];
    double exac_dutil[4][2];
  } utility;

  struct {
    double rate_doctor_visit;
    double ln_rate_gpvisits_COPD_by_sex[6][2];
    double ln_rate_gpvisits_NCOPD_by_sex[6][2];
  } outpatient;

  struct {
    double logit_p_cough_COPD_by_sex[8][2];
    double logit_p_cough_NCOPD_by_sex[7][2];
    double logit_p_phlegm_COPD_by_sex[8][2];
    double logit_p_phlegm_NCOPD_by_sex[7][2];
    double logit_p_wheeze_COPD_by_sex[8][2];
    double logit_p_wheeze_NCOPD_by_sex[7][2];
    double logit_p_dyspnea_COPD_by_sex[8][2];
    double logit_p_dyspnea_NCOPD_by_sex[7][2];
    double re_cough_sd;
    double re_phlegm_sd;
    double re_wheeze_sd;
    double re_dyspnea_sd;
    double re_cough_phlegm_rho;
    double re_wheeze_dyspnea_rho;
  } symptoms;

  struct {
    double logit_p_mi_betas_by_sex[8][2];
    double logit_p_stroke_betas_by_sex[8][2];
    double logit_p_hf_betas_by_sex[8][2];
    double ln_h_mi_betas_by_sex[8][2];
    double ln_h_stroke_betas_by_sex[8][2];
    double ln_h_hf_betas_by_sex[8][2];
    double p_mi_death;
    double p_stroke_death;
  } comorbidity;

  struct {
    double ln_h_start_betas_by_sex[8][2];
    double medication_ln_hr_exac[5];
  } medication;
};

/**
 * @struct agent
 * @brief Individual patient (agent) data structure
 */
struct agent {
  int id;
  double local_time;
  bool alive;
  bool sex;
  double dob;
  double age_at_creation;
  double time_at_creation;
  double height;
  double weight;
  int event;
  double tte;

  double fev1;
  double fev1_baseline;
  double fev1_slope;
  double fev1_slope_t;
  double age_baseline;
  double weight_baseline;
  double followup_time;
  double local_time_at_COPD;
  double fev1_tail;
  double _pred_fev1;

  int smoking_status;
  int smoking_status_LPT;
  double pack_years;

  int n_mi;
  int n_stroke;
  int b_mi;
  int b_stroke;
  int hf_status;
  double time_since_last_mi;
  double time_since_last_stroke;
  double time_since_hf;

  int gold;
  double p_COPD;

  double ln_exac_rate_intercept;
  double logit_exac_severity_intercept;
  int cumul_exac[4];
  double cumul_exac_time[4];
  int exac_status;
  int exac_LPT;
  double exac_history_time_first;
  double exac_history_time_second;
  int exac_history_severity_first;
  int exac_history_severity_second;
  int exac_history_n_moderate;
  int exac_history_n_severe_plus;

  double tmp_exac_rate;

  double symptom_score;
  double last_doctor_visit_time;
  int last_doctor_visit_type;
  int medication_status;

  int cough;
  int phlegm;
  int wheeze;
  int dyspnea;

  double re_cough;
  double re_phlegm;
  double re_wheeze;
  double re_dyspnea;

  double gpvisits;
  int diagnosis;
  double time_at_diagnosis;
  int smoking_at_diagnosis;
  int smoking_cessation;
  int smoking_cessation_count;
  int case_detection;
  int case_detection_eligible;
  double last_case_detection;

  double cumul_cost;
  double cumul_cost_prev_yr;
  double cumul_qaly;
};

/**
 * @struct output_struct
 * @brief Basic simulation output
 */
struct output_struct {
  double n_agents;
  double cumul_time;
  double n_deaths;
  double n_COPD_deaths;
  double n_exacs[4];
  double cumul_cost;
  double cumul_qaly;
};

/**
 * @struct output_ex_struct
 * @brief Extended simulation output with yearly breakdowns
 */
struct output_ex_struct {
  int n_current_agents;
  int output_ex_type;
  double biometrics_by_age_sex[MAX_AGE][2][5];
  double smoking_by_age_sex[MAX_AGE][2][4];
  double comorbidity_by_age_sex[MAX_AGE][2][8];
  double lung_function_by_age_sex[MAX_AGE][2][4];
  double COPD_by_age_sex[MAX_AGE][2][8];
  double exacerbation_by_age_sex[MAX_AGE][2][5];
  double exacerbation_by_gold_class[5][4];
  double annual_exac_rate_by_gold_class[5];
  double GP_by_age_sex[MAX_AGE][2][3];
  double mortality_by_age_sex[MAX_AGE][2][3];
  double medication_by_age_sex[MAX_AGE][2][2];
  double medication_by_comb[32];
  double population_by_age_sex[MAX_AGE][2][5];
};

////////////////////////////////////////////////////////////////////////////////
// EXTERN GLOBAL VARIABLES
////////////////////////////////////////////////////////////////////////////////

// Time and agent tracking
extern double calendar_time;
extern int last_id;

// Settings and input
extern settings_struct settings;
extern runtime_stats_struct runtime_stats;
extern input_struct input;

// Output
extern output_struct output;
extern output_ex_struct output_ex;

// Agent storage
extern agent *agent_stack;
extern long agent_stack_pointer;
extern agent *event_stack;
extern long event_stack_pointer;
extern agent smith;

// Random number buffers
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
int runif_fill();
int rnorm_fill();
int rexp_fill();
int rgamma_fill_COPD();
int rgamma_fill_NCOPD();

// Settings functions
void reset_runtime_stats();

// Output functions
void reset_output();
void reset_output_ex();
int push_event(agent *ag);

// Agent functions
agent *create_agent(agent *ag, int id);
List get_agent(agent *ag);
List get_agent(int id, agent agent_pointer[]);

// Event TTE functions (time-to-event)
double event_fixed_tte(agent *ag);
double event_birthday_tte(agent *ag);
double event_smoking_change_tte(agent *ag);
double event_COPD_tte(agent *ag);
double event_exacerbation_tte(agent *ag);
double event_exacerbation_end_tte(agent *ag);
double event_doctor_visit_tte(agent *ag);
double event_bgd_tte(agent *ag);

// Event process functions
void event_start_process(agent *ag);
void event_fixed_process(agent *ag);
void event_birthday_process(agent *ag);
void event_smoking_change_process(agent *ag);
void event_COPD_process(agent *ag);
void event_exacerbation_process(agent *ag);
void event_exacerbation_end_process(agent *ag);
void event_exacerbation_death_process(agent *ag);

// Helper functions used by events
void update_continuous_outcomes(agent *ag);
void update_symptoms(agent *ag);
void update_GPvisits(agent *ag);
void update_prevalent_diagnosis(agent *ag);
void update_diagnosis(agent *ag);

#endif // EPIC_MODEL_H
