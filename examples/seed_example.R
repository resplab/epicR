# Example: Using seed parameter for reproducible results
# This demonstrates how the seed parameter ensures identical results across runs

library(epicR)

# ==============================================================================
# Example 1: Without seed - Results vary between runs
# ==============================================================================

cat("\n=== Example 1: WITHOUT seed (results vary) ===\n")

# Run 1
results1 <- simulate(n_agents = 1000, time_horizon = 10)
cat("Run 1 - Deaths:", results1$basic$n_deaths, "\n")
cat("Run 1 - COPD cases:", results1$basic$n_COPD, "\n")

# Run 2
results2 <- simulate(n_agents = 1000, time_horizon = 10)
cat("Run 2 - Deaths:", results2$basic$n_deaths, "\n")
cat("Run 2 - COPD cases:", results2$basic$n_COPD, "\n")

cat("\nAre results identical? ", identical(results1$basic, results2$basic), "\n")

# ==============================================================================
# Example 2: With seed - Results are identical
# ==============================================================================

cat("\n=== Example 2: WITH seed (results identical) ===\n")

# Run 1 with seed
results3 <- simulate(n_agents = 1000, time_horizon = 10, seed = 123)
cat("Run 1 - Deaths:", results3$basic$n_deaths, "\n")
cat("Run 1 - COPD cases:", results3$basic$n_COPD, "\n")

# Run 2 with same seed
results4 <- simulate(n_agents = 1000, time_horizon = 10, seed = 123)
cat("Run 2 - Deaths:", results4$basic$n_deaths, "\n")
cat("Run 2 - COPD cases:", results4$basic$n_COPD, "\n")

cat("\nAre results identical? ", identical(results3$basic, results4$basic), "\n")

# ==============================================================================
# Example 3: Different seeds produce different results
# ==============================================================================

cat("\n=== Example 3: Different seeds produce different results ===\n")

results_seed1 <- simulate(n_agents = 1000, time_horizon = 10, seed = 123)
results_seed2 <- simulate(n_agents = 1000, time_horizon = 10, seed = 456)

cat("Seed 123 - Deaths:", results_seed1$basic$n_deaths, "\n")
cat("Seed 456 - Deaths:", results_seed2$basic$n_deaths, "\n")
cat("\nResults differ? ", !identical(results_seed1$basic, results_seed2$basic), "\n")

# ==============================================================================
# Example 4: Comparing interventions with controlled randomness
# ==============================================================================

cat("\n=== Example 4: Comparing interventions (same random variation) ===\n")

# Baseline scenario
baseline <- simulate(
  n_agents = 5000,
  time_horizon = 20,
  seed = 42
)

# Intervention: Increase smoking cessation rate
input <- get_input()
input$smoking$ln_h_ces_betas["intercept"] <-
  input$smoking$ln_h_ces_betas["intercept"] + 0.3  # 30% increase

intervention <- simulate(
  input = input,
  n_agents = 5000,
  time_horizon = 20,
  seed = 42  # Same seed as baseline
)

cat("Baseline deaths:", baseline$basic$n_deaths, "\n")
cat("Intervention deaths:", intervention$basic$n_deaths, "\n")
cat("Deaths prevented:", baseline$basic$n_deaths - intervention$basic$n_deaths, "\n")
cat("Baseline QALYs:", round(baseline$basic$total_qaly, 1), "\n")
cat("Intervention QALYs:", round(intervention$basic$total_qaly, 1), "\n")
cat("QALYs gained:", round(intervention$basic$total_qaly - baseline$basic$total_qaly, 1), "\n")

# ==============================================================================
# Example 5: Monte Carlo simulation with multiple seeds
# ==============================================================================

cat("\n=== Example 5: Monte Carlo simulation (multiple replicates) ===\n")

# Run 10 replicates with different seeds
n_replicates <- 10
seeds <- 100:(100 + n_replicates - 1)

cat("Running", n_replicates, "replicates...\n")

results_list <- lapply(seeds, function(s) {
  simulate(n_agents = 1000, time_horizon = 10, seed = s)
})

# Extract deaths from each replicate
deaths <- sapply(results_list, function(r) r$basic$n_deaths)

cat("\nDeaths across replicates:\n")
print(deaths)
cat("\nMean deaths:", round(mean(deaths), 1), "\n")
cat("SD deaths:", round(sd(deaths), 1), "\n")
cat("95% CI:", round(mean(deaths) - 1.96 * sd(deaths) / sqrt(n_replicates), 1),
    "to", round(mean(deaths) + 1.96 * sd(deaths) / sqrt(n_replicates), 1), "\n")

# ==============================================================================
# Example 6: Sensitivity analysis with controlled randomness
# ==============================================================================

cat("\n=== Example 6: Sensitivity analysis (time horizon) ===\n")

time_horizons <- c(10, 20, 30, 40)

cat("Varying time horizon while keeping random variation constant:\n")

for (th in time_horizons) {
  result <- simulate(
    n_agents = 1000,
    time_horizon = th,
    seed = 999  # Same seed for all
  )
  cat("Time horizon", th, "years - Deaths:", result$basic$n_deaths,
      "COPD:", result$basic$n_COPD, "\n")
}

cat("\n=== All examples completed successfully! ===\n")
