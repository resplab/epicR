#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
 Check these declarations against the C/Fortran source code.
 */

/* .Call calls */
extern SEXP _epicR_Callocate_resources(void);
extern SEXP _epicR_Ccreate_agents(void);
extern SEXP _epicR_Cdeallocate_resources(void);
extern SEXP _epicR_Cget_agent(SEXP);
extern SEXP _epicR_Cget_agent_events(SEXP);
extern SEXP _epicR_Cget_agent_size_bytes(void);
extern SEXP _epicR_Cget_all_events(void);
extern SEXP _epicR_Cget_all_events_matrix(void);
extern SEXP _epicR_Cget_event(SEXP);
extern SEXP _epicR_Cget_events_by_type(SEXP);
extern SEXP _epicR_Cget_inputs(void);
extern SEXP _epicR_Cget_n_events(void);
extern SEXP _epicR_Cget_output(void);
extern SEXP _epicR_Cget_output_ex(void);
extern SEXP _epicR_Cget_pointers(void);
extern SEXP _epicR_Cget_progress(void);
extern SEXP _epicR_Cget_runtime_stats(void);
extern SEXP _epicR_Cget_settings(void);
extern SEXP _epicR_Cget_smith(void);
extern SEXP _epicR_Cinit_session(void);
extern SEXP _epicR_Cmodel(SEXP);
extern SEXP _epicR_Cset_input_var(SEXP, SEXP);
extern SEXP _epicR_Cset_settings_var(SEXP, SEXP);
extern SEXP _epicR_get_sample_output(SEXP, SEXP);
extern SEXP _epicR_mvrnormArma(SEXP, SEXP, SEXP);
extern SEXP _epicR_Xrexp(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"_epicR_Callocate_resources",    (DL_FUNC) &_epicR_Callocate_resources,    0},
  {"_epicR_Ccreate_agents",         (DL_FUNC) &_epicR_Ccreate_agents,         0},
  {"_epicR_Cdeallocate_resources",  (DL_FUNC) &_epicR_Cdeallocate_resources,  0},
  {"_epicR_Cget_agent",             (DL_FUNC) &_epicR_Cget_agent,             1},
  {"_epicR_Cget_agent_events",      (DL_FUNC) &_epicR_Cget_agent_events,      1},
  {"_epicR_Cget_agent_size_bytes",  (DL_FUNC) &_epicR_Cget_agent_size_bytes,  0},
  {"_epicR_Cget_all_events",        (DL_FUNC) &_epicR_Cget_all_events,        0},
  {"_epicR_Cget_all_events_matrix", (DL_FUNC) &_epicR_Cget_all_events_matrix, 0},
  {"_epicR_Cget_event",             (DL_FUNC) &_epicR_Cget_event,             1},
  {"_epicR_Cget_events_by_type",    (DL_FUNC) &_epicR_Cget_events_by_type,    1},
  {"_epicR_Cget_inputs",            (DL_FUNC) &_epicR_Cget_inputs,            0},
  {"_epicR_Cget_n_events",          (DL_FUNC) &_epicR_Cget_n_events,          0},
  {"_epicR_Cget_output",            (DL_FUNC) &_epicR_Cget_output,            0},
  {"_epicR_Cget_output_ex",         (DL_FUNC) &_epicR_Cget_output_ex,         0},
  {"_epicR_Cget_pointers",          (DL_FUNC) &_epicR_Cget_pointers,          0},
  {"_epicR_Cget_progress",          (DL_FUNC) &_epicR_Cget_progress,          0},
  {"_epicR_Cget_runtime_stats",     (DL_FUNC) &_epicR_Cget_runtime_stats,     0},
  {"_epicR_Cget_settings",          (DL_FUNC) &_epicR_Cget_settings,          0},
  {"_epicR_Cget_smith",             (DL_FUNC) &_epicR_Cget_smith,             0},
  {"_epicR_Cinit_session",          (DL_FUNC) &_epicR_Cinit_session,          0},
  {"_epicR_Cmodel",                 (DL_FUNC) &_epicR_Cmodel,                 1},
  {"_epicR_Cset_input_var",         (DL_FUNC) &_epicR_Cset_input_var,         2},
  {"_epicR_Cset_settings_var",      (DL_FUNC) &_epicR_Cset_settings_var,      2},
  {"_epicR_get_sample_output",      (DL_FUNC) &_epicR_get_sample_output,      2},
  {"_epicR_mvrnormArma",            (DL_FUNC) &_epicR_mvrnormArma,            3},
  {"_epicR_Xrexp",                  (DL_FUNC) &_epicR_Xrexp,                  2},
  {NULL, NULL, 0}
};

void R_init_epicR(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
