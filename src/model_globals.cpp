/**
 * @file model_globals.cpp
 * @brief Global variable definitions for the EPIC model
 *
 * This file contains the actual definitions of all global variables
 * that are declared as extern in epic_model.h.
 */

#include "epic_model.h"

////////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLE DEFINITIONS
////////////////////////////////////////////////////////////////////////////////

// Time and agent tracking
double calendar_time = 0;
int last_id = 0;

// Settings
struct settings settings = {0};

// Runtime statistics
struct runtime_stats runtime_stats = {0};

// Input parameters
struct input input = {0};

// Output structures
struct output output = {0};

#ifdef OUTPUT_EX
struct output_ex output_ex = {0};
#endif

// Agent storage
agent *agent_stack = NULL;
long agent_stack_pointer = 0;
agent *event_stack = NULL;
long event_stack_pointer = 0;
agent smith = {0};

// Random number buffers
double *runif_buffer = NULL;
long runif_buffer_pointer = 0;
double *rnorm_buffer = NULL;
long rnorm_buffer_pointer = 0;
double *rexp_buffer = NULL;
long rexp_buffer_pointer = 0;
double *rgamma_buffer_COPD = NULL;
long rgamma_buffer_pointer_COPD = 0;
double *rgamma_buffer_NCOPD = NULL;
long rgamma_buffer_pointer_NCOPD = 0;

////////////////////////////////////////////////////////////////////////////////
// UTILITY FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

NumericMatrix array_to_Rmatrix(std::vector<double> x, int nCol)
{
  int nRow = x.size() / nCol;
  NumericMatrix y(nRow, nCol);
  for(int i = 0; i < nRow; i++)
    for(int j = 0; j < nCol; j++)
      y(i,j) = x[i * nCol + j];
  return y;
}

NumericMatrix array_to_Rmatrix(std::vector<int> x, int nCol)
{
  int nRow = x.size() / nCol;
  NumericMatrix y(nRow, nCol);
  for(int i = 0; i < nRow; i++)
    for(int j = 0; j < nCol; j++)
      y(i,j) = x[i * nCol + j];
  return y;
}

void reset_runtime_stats()
{
  char *x = reinterpret_cast<char *>(&runtime_stats);
  for(unsigned i = 0; i < sizeof(runtime_stats); i++)
    x[i] = 0;
}
