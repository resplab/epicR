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

////////////////////////////////////////////////////////////////////////////////
// CONTEXT MANAGEMENT FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

/**
 * @brief Create and initialize a random number context
 *
 * @param s Settings structure containing buffer sizes
 * @return Pointer to newly allocated random_context, or NULL on failure
 */
random_context* create_random_context(const struct settings& s)
{
  random_context* rctx = new random_context();
  if (rctx == NULL) return NULL;

  // Initialize all pointers to NULL
  rctx->runif_buffer = NULL;
  rctx->rnorm_buffer = NULL;
  rctx->rexp_buffer = NULL;
  rctx->rgamma_buffer_COPD = NULL;
  rctx->rgamma_buffer_NCOPD = NULL;

  // Copy buffer sizes
  rctx->runif_buffer_size = s.runif_buffer_size;
  rctx->rnorm_buffer_size = s.rnorm_buffer_size;
  rctx->rexp_buffer_size = s.rexp_buffer_size;
  rctx->rgamma_buffer_size = s.rgamma_buffer_size;

  // Allocate buffers
  if (allocate_random_buffers(rctx) != 0) {
    free_random_context(rctx);
    return NULL;
  }

  // Set pointers to trigger immediate fill
  reset_random_pointers(rctx);

  return rctx;
}

/**
 * @brief Allocate random number buffers for a context
 *
 * @param rctx Random context to allocate buffers for
 * @return 0 on success, ERR_MEMORY_ALLOCATION_FAILED on failure
 */
int allocate_random_buffers(random_context* rctx)
{
  if (rctx == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  // Allocate each buffer
  rctx->runif_buffer = (double *)malloc(rctx->runif_buffer_size * sizeof(double));
  if (rctx->runif_buffer == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  rctx->rnorm_buffer = (double *)malloc(rctx->rnorm_buffer_size * sizeof(double));
  if (rctx->rnorm_buffer == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  rctx->rexp_buffer = (double *)malloc(rctx->rexp_buffer_size * sizeof(double));
  if (rctx->rexp_buffer == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  rctx->rgamma_buffer_COPD = (double *)malloc(rctx->rgamma_buffer_size * sizeof(double));
  if (rctx->rgamma_buffer_COPD == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  rctx->rgamma_buffer_NCOPD = (double *)malloc(rctx->rgamma_buffer_size * sizeof(double));
  if (rctx->rgamma_buffer_NCOPD == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  return 0;
}

/**
 * @brief Reset random number buffer pointers to trigger refill
 *
 * @param rctx Random context to reset
 */
void reset_random_pointers(random_context* rctx)
{
  if (rctx == NULL) return;

  rctx->runif_buffer_pointer = rctx->runif_buffer_size;
  rctx->rnorm_buffer_pointer = rctx->rnorm_buffer_size;
  rctx->rexp_buffer_pointer = rctx->rexp_buffer_size;
  rctx->rgamma_buffer_pointer_COPD = rctx->rgamma_buffer_size;
  rctx->rgamma_buffer_pointer_NCOPD = rctx->rgamma_buffer_size;
}

/**
 * @brief Free a random number context and all its buffers
 *
 * @param rctx Random context to free
 */
void free_random_context(random_context* rctx)
{
  if (rctx == NULL) return;

  // Free all buffers
  if (rctx->runif_buffer != NULL) {
    free(rctx->runif_buffer);
    rctx->runif_buffer = NULL;
  }
  if (rctx->rnorm_buffer != NULL) {
    free(rctx->rnorm_buffer);
    rctx->rnorm_buffer = NULL;
  }
  if (rctx->rexp_buffer != NULL) {
    free(rctx->rexp_buffer);
    rctx->rexp_buffer = NULL;
  }
  if (rctx->rgamma_buffer_COPD != NULL) {
    free(rctx->rgamma_buffer_COPD);
    rctx->rgamma_buffer_COPD = NULL;
  }
  if (rctx->rgamma_buffer_NCOPD != NULL) {
    free(rctx->rgamma_buffer_NCOPD);
    rctx->rgamma_buffer_NCOPD = NULL;
  }

  // Free the context itself
  delete rctx;
}

/**
 * @brief Create and initialize a simulation context
 *
 * @param s Settings structure
 * @return Pointer to newly allocated simulation_context, or NULL on failure
 */
simulation_context* create_simulation_context(const struct settings& s)
{
  simulation_context* ctx = new simulation_context();
  if (ctx == NULL) return NULL;

  // Initialize simulation state
  ctx->calendar_time = 0;
  ctx->last_id = 0;

  // Copy settings
  ctx->settings = s;

  // Initialize output structures to zero
  char *output_ptr = reinterpret_cast<char *>(&ctx->output);
  for (unsigned i = 0; i < sizeof(ctx->output); i++)
    output_ptr[i] = 0;

  #ifdef OUTPUT_EX
  char *output_ex_ptr = reinterpret_cast<char *>(&ctx->output_ex);
  for (unsigned i = 0; i < sizeof(ctx->output_ex); i++)
    output_ex_ptr[i] = 0;
  #endif

  // Initialize runtime_stats to zero
  char *stats_ptr = reinterpret_cast<char *>(&ctx->runtime_stats);
  for (unsigned i = 0; i < sizeof(ctx->runtime_stats); i++)
    stats_ptr[i] = 0;

  // Initialize agent pointers to NULL
  ctx->agent_stack = NULL;
  ctx->event_stack = NULL;
  ctx->agent_stack_pointer = 0;
  ctx->event_stack_pointer = 0;

  // Initialize smith agent to zero
  char *smith_ptr = reinterpret_cast<char *>(&ctx->smith);
  for (unsigned i = 0; i < sizeof(ctx->smith); i++)
    smith_ptr[i] = 0;

  // Allocate agent stacks
  if (allocate_simulation_resources(ctx) != 0) {
    free_simulation_context(ctx);
    return NULL;
  }

  return ctx;
}

/**
 * @brief Allocate agent stacks for a simulation context
 *
 * @param ctx Simulation context to allocate resources for
 * @return 0 on success, ERR_MEMORY_ALLOCATION_FAILED on failure
 */
int allocate_simulation_resources(simulation_context* ctx)
{
  if (ctx == NULL) return ERR_MEMORY_ALLOCATION_FAILED;

  // Allocate agent stack
  if (ctx->settings.agent_stack_size > 0) {
    ctx->agent_stack = (agent *)malloc(ctx->settings.agent_stack_size * sizeof(agent));
    if (ctx->agent_stack == NULL) return ERR_MEMORY_ALLOCATION_FAILED;
  }
  ctx->agent_stack_pointer = 0;

  // Allocate event stack only if recording is enabled
  if (ctx->settings.record_mode != record_mode_none && ctx->settings.event_stack_size > 0) {
    ctx->event_stack = (agent *)malloc(ctx->settings.event_stack_size * sizeof(agent));
    if (ctx->event_stack == NULL) return ERR_MEMORY_ALLOCATION_FAILED;
  }
  ctx->event_stack_pointer = 0;

  return 0;
}

/**
 * @brief Reset a simulation context to initial state (ready for new run)
 *
 * @param ctx Simulation context to reset
 */
void reset_simulation_context(simulation_context* ctx)
{
  if (ctx == NULL) return;

  // Reset simulation state
  ctx->calendar_time = 0;
  ctx->last_id = 0;

  // Reset event stack pointer
  ctx->event_stack_pointer = 0;
  ctx->agent_stack_pointer = 0;

  // Reset outputs
  char *output_ptr = reinterpret_cast<char *>(&ctx->output);
  for (unsigned i = 0; i < sizeof(ctx->output); i++)
    output_ptr[i] = 0;

  #ifdef OUTPUT_EX
  char *output_ex_ptr = reinterpret_cast<char *>(&ctx->output_ex);
  for (unsigned i = 0; i < sizeof(ctx->output_ex); i++)
    output_ex_ptr[i] = 0;
  #endif

  // Reset runtime stats
  char *stats_ptr = reinterpret_cast<char *>(&ctx->runtime_stats);
  for (unsigned i = 0; i < sizeof(ctx->runtime_stats); i++)
    stats_ptr[i] = 0;
}

/**
 * @brief Free a simulation context and all its resources
 *
 * @param ctx Simulation context to free
 */
void free_simulation_context(simulation_context* ctx)
{
  if (ctx == NULL) return;

  // Free agent stacks
  if (ctx->agent_stack != NULL) {
    free(ctx->agent_stack);
    ctx->agent_stack = NULL;
  }
  if (ctx->event_stack != NULL) {
    free(ctx->event_stack);
    ctx->event_stack = NULL;
  }

  // Free the context itself
  delete ctx;
}

/**
 * @brief Initialize a context from current global variables
 *
 * Useful for transitioning from global-based code to context-based code.
 *
 * @param ctx Context to initialize
 */
void init_context_from_globals(simulation_context* ctx)
{
  if (ctx == NULL) return;

  ctx->calendar_time = calendar_time;
  ctx->last_id = last_id;
  ctx->settings = settings;
  ctx->output = output;
  #ifdef OUTPUT_EX
  ctx->output_ex = output_ex;
  #endif
  ctx->runtime_stats = runtime_stats;
  ctx->agent_stack = agent_stack;
  ctx->agent_stack_pointer = agent_stack_pointer;
  ctx->event_stack = event_stack;
  ctx->event_stack_pointer = event_stack_pointer;
  ctx->smith = smith;
}

/**
 * @brief Copy context values back to global variables
 *
 * Useful for transitioning from context-based code back to global-based code.
 *
 * @param ctx Context to copy from
 */
void copy_context_to_globals(const simulation_context* ctx)
{
  if (ctx == NULL) return;

  calendar_time = ctx->calendar_time;
  last_id = ctx->last_id;
  settings = ctx->settings;
  output = ctx->output;
  #ifdef OUTPUT_EX
  output_ex = ctx->output_ex;
  #endif
  runtime_stats = ctx->runtime_stats;
  agent_stack = ctx->agent_stack;
  agent_stack_pointer = ctx->agent_stack_pointer;
  event_stack = ctx->event_stack;
  event_stack_pointer = ctx->event_stack_pointer;
  smith = ctx->smith;
}

/**
 * @brief Merge outputs from source context into destination context
 *
 * Used to aggregate results from multiple parallel simulations.
 *
 * @param dest Destination context (accumulator)
 * @param src Source context to merge from
 */
void merge_outputs(simulation_context* dest, const simulation_context* src)
{
  if (dest == NULL || src == NULL) return;

  // Merge basic outputs
  dest->output.n_agents += src->output.n_agents;
  dest->output.cumul_time += src->output.cumul_time;
  dest->output.n_deaths += src->output.n_deaths;
  dest->output.n_COPD += src->output.n_COPD;
  dest->output.total_pack_years += src->output.total_pack_years;

  for (int i = 0; i < 4; i++) {
    dest->output.total_exac[i] += src->output.total_exac[i];
    dest->output.total_exac_time[i] += src->output.total_exac_time[i];
  }

  for (int i = 0; i < 2; i++) {
    dest->output.total_doctor_visit[i] += src->output.total_doctor_visit[i];
  }

  dest->output.total_cost += src->output.total_cost;
  dest->output.total_qaly += src->output.total_qaly;
  dest->output.total_diagnosed_time += src->output.total_diagnosed_time;

  #ifdef OUTPUT_EX
  // Merge extended outputs - arrays
  for (int t = 0; t < 1000; t++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.n_alive_by_ctime_sex[t][s] += src->output_ex.n_alive_by_ctime_sex[t][s];
      dest->output_ex.n_current_smoker_by_ctime_sex[t][s] += src->output_ex.n_current_smoker_by_ctime_sex[t][s];
      dest->output_ex.sum_time_by_ctime_sex[t][s] += src->output_ex.sum_time_by_ctime_sex[t][s];
    }

    for (int a = 0; a < 111; a++) {
      dest->output_ex.n_alive_by_ctime_age[t][a] += src->output_ex.n_alive_by_ctime_age[t][a];
    }

    for (int sm = 0; sm < 3; sm++) {
      dest->output_ex.n_smoking_status_by_ctime[t][sm] += src->output_ex.n_smoking_status_by_ctime[t][sm];
    }

    dest->output_ex.annual_cost_ctime[t] += src->output_ex.annual_cost_ctime[t];
    dest->output_ex.sum_fev1_ltime[t] += src->output_ex.sum_fev1_ltime[t];
  }

  for (int sm = 0; sm < 3; sm++) {
    dest->output_ex.cumul_time_by_smoking_status[sm] += src->output_ex.cumul_time_by_smoking_status[sm];
  }

  for (int a = 0; a < 111; a++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.sum_time_by_age_sex[a][s] += src->output_ex.sum_time_by_age_sex[a][s];
      dest->output_ex.n_death_by_age_sex[a][s] += src->output_ex.n_death_by_age_sex[a][s];
      dest->output_ex.n_alive_by_age_sex[a][s] += src->output_ex.n_alive_by_age_sex[a][s];
    }
  }

  #if OUTPUT_EX > 1
  dest->output_ex.cumul_non_COPD_time += src->output_ex.cumul_non_COPD_time;

  for (int t = 0; t < 1000; t++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.sum_p_COPD_by_ctime_sex[t][s] += src->output_ex.sum_p_COPD_by_ctime_sex[t][s];
      dest->output_ex.sum_pack_years_by_ctime_sex[t][s] += src->output_ex.sum_pack_years_by_ctime_sex[t][s];
      dest->output_ex.sum_age_by_ctime_sex[t][s] += src->output_ex.sum_age_by_ctime_sex[t][s];
    }
  }
  #endif

  #if (OUTPUT_EX & OUTPUT_EX_COPD) > 0
  for (int t = 0; t < 1000; t++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.n_COPD_by_ctime_sex[t][s] += src->output_ex.n_COPD_by_ctime_sex[t][s];
      dest->output_ex.n_Diagnosed_by_ctime_sex[t][s] += src->output_ex.n_Diagnosed_by_ctime_sex[t][s];
      dest->output_ex.n_Overdiagnosed_by_ctime_sex[t][s] += src->output_ex.n_Overdiagnosed_by_ctime_sex[t][s];
    }
    for (int a = 0; a < 111; a++) {
      dest->output_ex.n_COPD_by_ctime_age[t][a] += src->output_ex.n_COPD_by_ctime_age[t][a];
      dest->output_ex.n_inc_COPD_by_ctime_age[t][a] += src->output_ex.n_inc_COPD_by_ctime_age[t][a];
    }
    for (int sev = 0; sev < 5; sev++) {
      dest->output_ex.n_COPD_by_ctime_severity[t][sev] += src->output_ex.n_COPD_by_ctime_severity[t][sev];
      dest->output_ex.n_Diagnosed_by_ctime_severity[t][sev] += src->output_ex.n_Diagnosed_by_ctime_severity[t][sev];
    }
    for (int cd = 0; cd < 3; cd++) {
      dest->output_ex.n_case_detection_by_ctime[t][cd] += src->output_ex.n_case_detection_by_ctime[t][cd];
    }
  }

  for (int a = 0; a < 111; a++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.n_COPD_by_age_sex[a][s] += src->output_ex.n_COPD_by_age_sex[a][s];
    }
  }

  dest->output_ex.n_case_detection_eligible += src->output_ex.n_case_detection_eligible;
  dest->output_ex.n_diagnosed_true_CD += src->output_ex.n_diagnosed_true_CD;
  dest->output_ex.n_agents_CD += src->output_ex.n_agents_CD;
  #endif

  #if (OUTPUT_EX & OUTPUT_EX_EXACERBATION) > 0
  for (int t = 0; t < 100; t++) {
    for (int a = 0; a < 111; a++) {
      dest->output_ex.n_exac_by_ctime_age[t][a] += src->output_ex.n_exac_by_ctime_age[t][a];
      dest->output_ex.n_severep_exac_by_ctime_age[t][a] += src->output_ex.n_severep_exac_by_ctime_age[t][a];
      dest->output_ex.n_exac_death_by_ctime_age[t][a] += src->output_ex.n_exac_death_by_ctime_age[t][a];
    }
    for (int sev = 0; sev < 4; sev++) {
      dest->output_ex.n_exac_by_ctime_severity[t][sev] += src->output_ex.n_exac_by_ctime_severity[t][sev];
      dest->output_ex.n_exac_death_by_ctime_severity[t][sev] += src->output_ex.n_exac_death_by_ctime_severity[t][sev];
      dest->output_ex.n_exac_by_ctime_severity_female[t][sev] += src->output_ex.n_exac_by_ctime_severity_female[t][sev];
      dest->output_ex.n_exac_by_ctime_GOLD[t][sev] += src->output_ex.n_exac_by_ctime_GOLD[t][sev];
      dest->output_ex.n_exac_by_ctime_severity_undiagnosed[t][sev] += src->output_ex.n_exac_by_ctime_severity_undiagnosed[t][sev];
      dest->output_ex.n_exac_by_ctime_severity_diagnosed[t][sev] += src->output_ex.n_exac_by_ctime_severity_diagnosed[t][sev];
    }
  }

  for (int g = 0; g < 4; g++) {
    for (int sev = 0; sev < 4; sev++) {
      dest->output_ex.n_exac_by_gold_severity[g][sev] += src->output_ex.n_exac_by_gold_severity[g][sev];
      dest->output_ex.n_exac_by_gold_severity_diagnosed[g][sev] += src->output_ex.n_exac_by_gold_severity_diagnosed[g][sev];
    }
  }

  for (int a = 0; a < 111; a++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.n_exac_death_by_age_sex[a][s] += src->output_ex.n_exac_death_by_age_sex[a][s];
    }
  }
  #endif

  #if (OUTPUT_EX & OUTPUT_EX_GPSYMPTOMS) > 0
  for (int t = 0; t < 1000; t++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.n_GPvisits_by_ctime_sex[t][s] += src->output_ex.n_GPvisits_by_ctime_sex[t][s];
    }
    for (int sev = 0; sev < 5; sev++) {
      dest->output_ex.n_GPvisits_by_ctime_severity[t][sev] += src->output_ex.n_GPvisits_by_ctime_severity[t][sev];
      dest->output_ex.n_cough_by_ctime_severity[t][sev] += src->output_ex.n_cough_by_ctime_severity[t][sev];
      dest->output_ex.n_phlegm_by_ctime_severity[t][sev] += src->output_ex.n_phlegm_by_ctime_severity[t][sev];
      dest->output_ex.n_wheeze_by_ctime_severity[t][sev] += src->output_ex.n_wheeze_by_ctime_severity[t][sev];
      dest->output_ex.n_dyspnea_by_ctime_severity[t][sev] += src->output_ex.n_dyspnea_by_ctime_severity[t][sev];
    }
    for (int d = 0; d < 2; d++) {
      dest->output_ex.n_GPvisits_by_ctime_diagnosis[t][d] += src->output_ex.n_GPvisits_by_ctime_diagnosis[t][d];
    }
  }
  #endif

  #if (OUTPUT_EX & OUTPUT_EX_BIOMETRICS) > 0
  for (int t = 0; t < 1000; t++) {
    for (int s = 0; s < 2; s++) {
      dest->output_ex.sum_weight_by_ctime_sex[t][s] += src->output_ex.sum_weight_by_ctime_sex[t][s];
    }
  }
  #endif

  #if (OUTPUT_EX & OUTPUT_EX_MEDICATION) > 0
  for (int c = 0; c < N_MED_CLASS; c++) {
    dest->output_ex.medication_time_by_class[c] += src->output_ex.medication_time_by_class[c];
    for (int sev = 0; sev < 3; sev++) {
      dest->output_ex.n_exac_by_medication_class[c][sev] += src->output_ex.n_exac_by_medication_class[c][sev];
    }
  }

  for (int t = 0; t < 1000; t++) {
    for (int c = 0; c < N_MED_CLASS; c++) {
      dest->output_ex.medication_time_by_ctime_class[t][c] += src->output_ex.medication_time_by_ctime_class[t][c];
    }
    dest->output_ex.n_smoking_cessation_by_ctime[t] += src->output_ex.n_smoking_cessation_by_ctime[t];
  }
  #endif
  #endif // OUTPUT_EX

  // Merge runtime stats
  dest->runtime_stats.n_runif_fills += src->runtime_stats.n_runif_fills;
  dest->runtime_stats.n_rnorm_fills += src->runtime_stats.n_rnorm_fills;
  dest->runtime_stats.n_rexp_fills += src->runtime_stats.n_rexp_fills;
  dest->runtime_stats.n_rgamma_fills_COPD += src->runtime_stats.n_rgamma_fills_COPD;
  dest->runtime_stats.n_rgamma_fills_NCOPD += src->runtime_stats.n_rgamma_fills_NCOPD;
}

/**
 * @brief Aggregate multiple simulation contexts into one
 *
 * Creates a new context that contains the merged outputs from all input contexts.
 * Used to combine results from parallel simulation runs.
 *
 * @param contexts Array of context pointers to aggregate
 * @param n_contexts Number of contexts in the array
 * @return New context with aggregated results, or NULL on failure
 */
simulation_context* aggregate_contexts(simulation_context** contexts, int n_contexts)
{
  if (contexts == NULL || n_contexts <= 0) return NULL;

  // Create a new context for the aggregated result
  simulation_context* aggregated = create_simulation_context(contexts[0]->settings);
  if (aggregated == NULL) return NULL;

  // Merge all contexts into the aggregated one
  for (int i = 0; i < n_contexts; i++) {
    if (contexts[i] != NULL) {
      merge_outputs(aggregated, contexts[i]);
    }
  }

  return aggregated;
}
