/**
 * @file model_types.h
 * @brief Type definitions and declarations for the EPIC DES model
 *
 * This header file contains shared type definitions, enumerations, and
 * struct declarations used throughout the EPIC discrete event simulation model.
 *
 * @note Include this file in any new source files that need access to model types.
 *
 * @author EPIC Development Team
 * @see model.cpp for implementation details
 */

#ifndef MODEL_TYPES_H
#define MODEL_TYPES_H

#include "RcppArmadillo.h"
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(cpp11)]]

#include <algorithm>

using namespace Rcpp;

////////////////////////////////////////////////////////////////////////////////
// CONSTANTS
////////////////////////////////////////////////////////////////////////////////

/**
 * @defgroup output_flags Extended Output Flags
 * Bit flags for controlling which extended outputs are collected.
 * Combine using bitwise OR to select multiple output types.
 * @{
 */
#define OUTPUT_EX_BIOMETRICS 1   ///< Height, weight, BMI
#define OUTPUT_EX_SMOKING 2       ///< Smoking status and pack-years
#define OUTPUT_EX_COMORBIDITY 4   ///< Comorbidities (MI, stroke, HF)
#define OUTPUT_EX_LUNG_FUNCTION 8 ///< FEV1, predicted FEV1
#define OUTPUT_EX_COPD 16         ///< COPD status and GOLD stage
#define OUTPUT_EX_EXACERBATION 32 ///< Exacerbation events
#define OUTPUT_EX_GPSYMPTOMS 64   ///< GP visits and symptoms
#define OUTPUT_EX_MORTALITY 128   ///< Mortality events
#define OUTPUT_EX_MEDICATION 256  ///< Medication use
#define OUTPUT_EX_POPULATION 512  ///< Population statistics
#define OUTPUT_EX 65535           ///< All extended outputs enabled
/** @} */

/**
 * @brief Maximum age simulated in the model (years)
 * Agents reaching this age are removed from simulation
 */
#define MAX_AGE 111

////////////////////////////////////////////////////////////////////////////////
// ENUMERATIONS
////////////////////////////////////////////////////////////////////////////////

/**
 * @enum errors
 * @brief Error codes returned by C functions
 *
 * Negative values indicate errors. Zero indicates success.
 */
enum errors {
  ERR_INCORRECT_SETTING_VARIABLE = -1,  ///< Invalid setting variable name
  ERR_INCORRECT_VECTOR_SIZE = -2,       ///< Vector size doesn't match expected
  ERR_INCORRECT_INPUT_VAR = -3,         ///< Invalid input variable name
  ERR_EVENT_STACK_FULL = -4,            ///< Event stack has reached capacity
  ERR_MEMORY_ALLOCATION_FAILED = -5     ///< Failed to allocate memory
};

/**
 * @enum record_mode
 * @brief Controls what data is recorded during simulation
 */
enum record_mode {
  record_mode_none = 0,       ///< Aggregates only (no individual data)
  record_mode_agent = 1,      ///< Agent-level data recorded
  record_mode_event = 2,      ///< All events recorded for all agents
  record_mode_some_event = 3  ///< Selected events recorded
};

/**
 * @enum agent_creation_mode
 * @brief Strategy for creating agents at simulation start
 */
enum agent_creation_mode {
  agent_creation_mode_one = 0,  ///< Create agents one at a time as needed
  agent_creation_mode_all = 1,  ///< Create all agents at once at start
  agent_creation_mode_pre = 2   ///< Pre-create agents with specific characteristics
};

/**
 * @enum medication_classes
 * @brief COPD medication classes as bit flags
 *
 * Each class is a power of 2 for bitwise combinations.
 * Example: LABA+ICS = MED_CLASS_LABA | MED_CLASS_ICS = 2|8 = 10
 */
enum medication_classes {
  MED_CLASS_SABA = 1,    ///< Short-Acting Beta-Agonist (rescue inhaler)
  MED_CLASS_LABA = 2,    ///< Long-Acting Beta-Agonist
  MED_CLASS_LAMA = 4,    ///< Long-Acting Muscarinic Antagonist
  MED_CLASS_ICS = 8,     ///< Inhaled Corticosteroid
  MED_CLASS_MACRO = 16,  ///< Macrolide antibiotic
  N_MED_CLASS = 5        ///< Number of medication classes
};

/**
 * @enum event_type
 * @brief Types of events that can occur in the simulation
 */
enum event_type {
  event_start = 0,             ///< Simulation start for agent
  event_fixed = 1,             ///< Annual fixed event (outcomes update)
  event_birthday = 2,          ///< Agent birthday
  event_smoking_change = 3,    ///< Smoking status change
  event_COPD = 4,              ///< COPD incidence
  event_exacerbation = 5,      ///< Exacerbation onset
  event_exacerbation_end = 6,  ///< Exacerbation resolution
  event_exacerbation_death = 7,///< Death from exacerbation
  event_doctor_visit = 8,      ///< Doctor visit (not currently implemented)
  event_medication_change = 9, ///< Medication change (not currently implemented)
  event_mi = 10,               ///< Myocardial infarction (not currently implemented)
  event_stroke = 11,           ///< Stroke (not currently implemented)
  event_hf = 12,               ///< Heart failure (not currently implemented)
  event_bgd = 13,              ///< Background death (non-COPD)
  event_end = 14               ///< Simulation end for agent
};

/**
 * @enum exacerbation_severity
 * @brief Severity levels for COPD exacerbations
 */
enum exacerbation_severity {
  exac_severity_mild = 0,       ///< Mild exacerbation
  exac_severity_moderate = 1,   ///< Moderate exacerbation
  exac_severity_severe = 2,     ///< Severe exacerbation
  exac_severity_very_severe = 3 ///< Very severe exacerbation
};

////////////////////////////////////////////////////////////////////////////////
// UTILITY MACROS
////////////////////////////////////////////////////////////////////////////////

/**
 * @defgroup array_conversion Array Conversion Macros
 * Macros for converting between C arrays and R vectors/matrices
 * @{
 */
#define AS_VECTOR_DOUBLE(src) std::vector<double>(&src[0],&src[0]+sizeof(src)/sizeof(double))
#define AS_VECTOR_DOUBLE_SIZE(src,size) std::vector<double>(&src[0],&src[0]+size)
#define AS_MATRIX_DOUBLE(src) array_to_Rmatrix(std::vector<double>(&src[0][0],&src[0][0]+sizeof(src)/sizeof(double)),sizeof(src[0])/sizeof(double))
#define AS_MATRIX_DOUBLE_SIZE(src,size) array_to_Rmatrix(std::vector<double>(&src[0][0],&src[0][0]+size*sizeof(src[0])/sizeof(double)),sizeof(src[0])/sizeof(double))
#define AS_MATRIX_INT(src) array_to_Rmatrix(std::vector<int>(&src[0][0],&src[0][0]+sizeof(src)/sizeof(int)),sizeof(src[0])/sizeof(int))
#define AS_MATRIX_INT_SIZE(src,size) array_to_Rmatrix(std::vector<int>(&src[0][0],&src[0][0]+size*sizeof(src[0])/sizeof(int)),sizeof(src[0])/sizeof(int))
#define AS_VECTOR_INT(src) std::vector<int>(&src[0],&src[0]+sizeof(src)/sizeof(int))
#define AS_VECTOR_INT_SIZE(src,size) std::vector<int>(&src[0],&src[0]+size)
/** @} */

/**
 * @defgroup io_macros Input/Output Macros
 * Macros for reading R vectors/matrices into C arrays
 * @{
 */
#define READ_R_VECTOR(src,dest) {if(src.size()==sizeof(dest)/sizeof(dest[0])) {std::copy(src.begin(),src.end(),&dest[0]); return(0);} else return(ERR_INCORRECT_VECTOR_SIZE);}
#define READ_R_MATRIX(src,dest) {if(src.size()==sizeof(dest)/sizeof(dest[0][0])) {std::copy(src.begin(),src.end(),&dest[0][0]); return(0);} else return(ERR_INCORRECT_VECTOR_SIZE);}
/** @} */

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

#endif // MODEL_TYPES_H
