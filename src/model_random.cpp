/**
 * @file model_random.cpp
 * @brief Random number generation for the EPIC model
 *
 * This module provides high-performance random number generation using a
 * buffered approach for uniform, normal, exponential, and gamma distributions.
 */

#include "epic_model.h"

////////////////////////////////////////////////////////////////////////////////
// INTERNAL HELPER FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

static double* R_runif(int n, double *address)
{
  NumericVector temp(runif(n));
  std::copy(temp.begin(), temp.end(), address);
  return address;
}

static double* R_rnorm(int n, double *address)
{
  NumericVector temp(rnorm(n));
  std::copy(temp.begin(), temp.end(), address);
  return address;
}

static double* R_rexp(int n, double *address)
{
  NumericVector temp(rexp(n, 1));
  std::copy(temp.begin(), temp.end(), address);
  return address;
}

static double* R_rgamma(int n, double alpha, double beta, double *address)
{
  arma::vec lambda = arma::randg<arma::vec>(n, arma::distr_param(alpha, beta));
  std::copy(lambda.begin(), lambda.end(), address);
  return address;
}

////////////////////////////////////////////////////////////////////////////////
// BUFFER FILL FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

int runif_fill()
{
  R_runif(settings.runif_buffer_size, runif_buffer);
  runif_buffer_pointer = 0;
  ++runtime_stats.n_runif_fills;
  return 0;
}

int rnorm_fill()
{
  R_rnorm(settings.rnorm_buffer_size, rnorm_buffer);
  rnorm_buffer_pointer = 0;
  ++runtime_stats.n_rnorm_fills;
  return 0;
}

int rexp_fill()
{
  R_rexp(settings.rexp_buffer_size, rexp_buffer);
  rexp_buffer_pointer = 0;
  ++runtime_stats.n_rexp_fills;
  return 0;
}

int rgamma_fill_COPD()
{
  R_rgamma(settings.rgamma_buffer_size, 1/0.431, 1, rgamma_buffer_COPD);
  rgamma_buffer_pointer_COPD = 0;
  ++runtime_stats.n_rgamma_fills_COPD;
  return 0;
}

int rgamma_fill_NCOPD()
{
  R_rgamma(settings.rgamma_buffer_size, 1/0.4093, 1, rgamma_buffer_NCOPD);
  rgamma_buffer_pointer_NCOPD = 0;
  ++runtime_stats.n_rgamma_fills_NCOPD;
  return 0;
}

////////////////////////////////////////////////////////////////////////////////
// PUBLIC RANDOM NUMBER FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

double rand_unif()
{
  if(runif_buffer_pointer == settings.runif_buffer_size) { runif_fill(); }
  double temp = runif_buffer[runif_buffer_pointer];
  runif_buffer_pointer++;
  return temp;
}

double rand_norm()
{
  if(rnorm_buffer_pointer == settings.rnorm_buffer_size) { rnorm_fill(); }
  double temp = rnorm_buffer[rnorm_buffer_pointer];
  rnorm_buffer_pointer++;
  return temp;
}

double rand_exp()
{
  if(rexp_buffer_pointer == settings.rexp_buffer_size) { rexp_fill(); }
  double temp = rexp_buffer[rexp_buffer_pointer];
  rexp_buffer_pointer++;
  return temp;
}

double rand_gamma_COPD()
{
  if(rgamma_buffer_pointer_COPD == settings.rgamma_buffer_size) { rgamma_fill_COPD(); }
  double temp = rgamma_buffer_COPD[rgamma_buffer_pointer_COPD];
  rgamma_buffer_pointer_COPD++;
  return temp;
}

double rand_gamma_NCOPD()
{
  if(rgamma_buffer_pointer_NCOPD == settings.rgamma_buffer_size) { rgamma_fill_NCOPD(); }
  double temp = rgamma_buffer_NCOPD[rgamma_buffer_pointer_NCOPD];
  rgamma_buffer_pointer_NCOPD++;
  return temp;
}

int rand_Poisson(double rate)
{
  double out = 0;
  double time = 0;
  while(time < 1)
  {
    time = time + rand_exp() / rate;
    out++;
  }
  return (int)(out - 1);
}

void rbvnorm(double rho, double x[2])
{
  x[0] = rand_norm();
  double mu = rho * x[0];
  double v = (1 - rho * rho);
  x[1] = rand_norm() * sqrt(v) + mu;
}

int rand_NegBin(double rate, double dispersion, bool use_COPD_gamma)
{
  if (dispersion != 1)
  {
    double size = 1 / dispersion;
    double p = size / (size + rate);
    double beta = (1 - p) / p;
    double lambda = use_COPD_gamma ? rand_gamma_COPD() * beta : rand_gamma_NCOPD() * beta;
    return rand_Poisson(lambda);
  }
  return rand_Poisson(rate);
}

int rand_NegBin_COPD(double rate, double dispersion)
{
  return rand_NegBin(rate, dispersion, true);
}

int rand_NegBin_NCOPD(double rate, double dispersion)
{
  return rand_NegBin(rate, dispersion, false);
}

////////////////////////////////////////////////////////////////////////////////
// EXPORTED R FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

//' Samples from a multivariate normal
//' @param n number of samples to be taken
//' @param mu the mean
//' @param sigma the covariance matrix
//' @return the multivariate normal sample
//' @export
// [[Rcpp::export]]
arma::mat mvrnormArma(int n, arma::vec mu, arma::mat sigma) {
  int ncols = sigma.n_cols;
  arma::mat Y(n, ncols);
  for(int i = 0; i < ncols; i++) {
    Y(0, i) = rand_norm();
  }
  return arma::repmat(mu, 1, n).t() + Y * arma::chol(sigma);
}

// [[Rcpp::export]]
NumericVector Xrexp(int n, double rate)
{
  NumericVector temp(rexp(n, 1));
  return temp[0] / rate;
}
