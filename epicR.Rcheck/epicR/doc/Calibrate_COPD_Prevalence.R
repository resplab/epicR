## ----eval = TRUE, echo = TRUE, message=FALSE----------------------------------
library(epicR)
library(ggplot2)
library(dplyr)
library(knitr)

# Load EPIC general settings
settings <- get_default_settings()
settings$record_mode <- 0
settings$n_base_agents <- 1e6
init_session(settings = settings)

input <- get_input(jurisdiction = "us")
time_horizon <- 26
input$values$global_parameters$time_horizon <- time_horizon


## ----eval = TRUE, echo = TRUE-------------------------------------------------
input$values$COPD$logit_p_COPD_betas_by_sex <- cbind(male = c(intercept = -4.30190, age = 0.033070, age2 = 0, pack_years = 0.025049   ,
                                                       current_smoking = 0, year = 0, asthma = 0),
                                              female = c(intercept = -4.40202, age = 0.027359   , age2 = 0, pack_years=0.030399,                                                         current_smoking = 0, year = 0, asthma = 0))

## ----eval = TRUE, echo = TRUE-------------------------------------------------

# Run EPIC simulation
run(input = input$values)
output <- Cget_output_ex()
terminate_session()


## ----eval = TRUE, echo = TRUE-------------------------------------------------

# Determine overall COPD prevalence

COPDprevalence_ctime_age<-output$n_COPD_by_ctime_age
COPDprevalence_ctime_age<-as.data.frame(output$n_COPD_by_ctime_age)
totalpopulation<-output$n_alive_by_ctime_age

# Overall prevalence of COPD

alive_age_all <- rowSums(output$n_alive_by_ctime_age[1:26, 40:111])
COPD_age_all <- rowSums (output$n_COPD_by_ctime_age[1:26, 40:111])
prevalenceCOPD_age_all <- COPD_age_all / alive_age_all

# Prevalence by age 40-59 

alive_age_40to59 <- rowSums(output$n_alive_by_ctime_age[1:26, 40:59])
COPD_age_40to59 <-rowSums(output$n_COPD_by_ctime_age[1:26, 40:59])
prevalenceCOPD_age_40to59 <- COPD_age_40to59 / alive_age_40to59

# Prevalence by age 60-79

alive_age_60to79 <- rowSums(output$n_alive_by_ctime_age[1:26, 60:79])
COPD_age_60to79 <-rowSums(output$n_COPD_by_ctime_age[1:26, 60:79])
prevalenceCOPD_age_60to79 <- COPD_age_60to79 / alive_age_60to79

# Prevalence by age 80+

alive_age_over80 <- rowSums(output$n_alive_by_ctime_age[1:26, 80:111])
COPD_age_over80 <-rowSums(output$n_COPD_by_ctime_age[1:26, 80:111])
prevalenceCOPD_age_over80 <- COPD_age_over80 / alive_age_over80

# Display summary of COPD prevalence by age group 

COPD_prevalence_summary <- data.frame(
  Year = 2015:2040,
  Prevalence_all = prevalenceCOPD_age_all,
  Prevalence_40to59 = prevalenceCOPD_age_40to59,
  Prevalence_60to79 = prevalenceCOPD_age_60to79,
  Prevalence_over80 = prevalenceCOPD_age_over80
  )

kable(COPD_prevalence_summary, 
      caption = "COPD Prevalence by Age Group Over Time",
      digits = 3)

## ----prevalenceall, fig.width = 8, fig.height = 6, echo = FALSE, message = FALSE, warning = FALSE----

# Plot prevalence all ages
plot_prevalenceCOPD_age_all <- data.frame(
  Year = 2015:2040,
  Prevalence = prevalenceCOPD_age_all
  )

ggplot(plot_prevalenceCOPD_age_all, aes(x = Year, y = Prevalence)) +
    geom_line(linewidth = 1.5, color = "#003f5c") +           # Deep navy
    geom_point(size = 3, color = "#66c2ff", stroke = 0.8) +   # Light blue
    scale_y_continuous(
      labels = scales::percent_format(accuracy = 1),
      limits = c(0, 0.15),
      breaks = seq(0, 0.15, by = 0.05)
    ) +
    scale_x_continuous(breaks = seq(2015, 2040, by = 5)) +
    labs(
      title = "COPD Prevalence Over Time (All Ages)",
      subtitle = "Estimated proportion of population with COPD from 2016–2040",
      x = "Year",
      y = "Prevalence (%)"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 8)),
      plot.subtitle = element_text(size = 14, hjust = 0.5),
      axis.title = element_text(face = "bold"),
      axis.text = element_text(color = "black"),
      axis.line = element_line(color = "black", linewidth = 0.8),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )

## ----prevalenceof40to59, fig.width = 8, fig.height = 6, echo = FALSE, message = FALSE, warning = FALSE----

# Plot prevalence age 40-59
plot_prevalence_40to59<- data.frame (Year = 2015:2040, Prevalence = prevalenceCOPD_age_40to59)

ggplot(plot_prevalence_40to59, aes(x = Year, y = Prevalence)) +
  geom_line(linewidth = 1.5, color = "#003f5c") +           # Deep navy
  geom_point(size = 3, color = "#66c2ff", stroke = 0.8) +   # Light blue
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1),
    limits = c(0, 0.10),
    breaks = seq(0, 0.10, by = 0.05)) +
  scale_x_continuous(breaks = seq(2015, 2040, by = 5)) +
  labs(
    title = "COPD Prevalence Over Time (Age 40–59)",
    subtitle = "Estimated proportion of population with COPD from 2016–2040",
    x = "Year",
    y = "Prevalence (%)") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 8)),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(color = "black"),
    axis.line = element_line(color = "black", linewidth = 0.8),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    )

## ----prevalenceof60to79, fig.width = 8, fig.height = 6, echo = FALSE, message = FALSE, warning = FALSE----

# Plot prevalence age 60-79
plot_prevalence_60to79 <- data.frame(
  Year = 2015:2040,
  Prevalence = prevalenceCOPD_age_60to79
  )

ggplot(plot_prevalence_60to79, aes(x = Year, y = Prevalence)) +
    geom_line(linewidth = 1.5, color = "#003f5c") +           # Deep navy
    geom_point(size = 3, color = "#66c2ff", stroke = 0.8) +   # Light blue
    scale_y_continuous(
      labels = scales::percent_format(accuracy = 1),
      limits = c(0, 0.15),
      breaks = seq(0, 0.15, by = 0.05)
    ) +
    scale_x_continuous(breaks = seq(2015, 2040, by = 5)) +
    labs(
      title = "COPD Prevalence Over Time (Age 60–79)",
      subtitle = "Estimated proportion of population with COPD from 2016–2040",
      x = "Year",
      y = "Prevalence (%)"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 8)),
      plot.subtitle = element_text(size = 14, hjust = 0.5),
      axis.title = element_text(face = "bold"),
      axis.text = element_text(color = "black"),
      axis.line = element_line(color = "black", linewidth = 0.8),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )

## ----prevalenceofover80, fig.width = 8, fig.height = 6, echo = FALSE, message = FALSE, warning = FALSE----

# Plot prevalence age 80+
plot_prevalence_over80<- data.frame(Year = 2015:2040, Prevalence = prevalenceCOPD_age_over80)

ggplot(plot_prevalence_over80, aes(x = Year, y = Prevalence)) +
  geom_line(linewidth = 1.5, color = "#003f5c") +           # Deep navy
  geom_point(size = 3, color = "#66c2ff", stroke = 0.8) +   # Light blue
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1),
    limits = c(0, 0.30),
    breaks = seq(0, 0.30, by = 0.05)
    ) +
  scale_x_continuous(breaks = seq(2015, 2040, by = 5)) +
  labs(
    title = "COPD Prevalence Over Time (Age 80+)",
    subtitle = "Estimated proportion of population with COPD from 2016–2040",
    x = "Year",
    y = "Prevalence (%)"
    ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5, margin = margin(b = 8)),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(color = "black"),
    axis.line = element_line(color = "black", linewidth = 0.8),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    )

## ----eval = TRUE, echo = TRUE-------------------------------------------------

# Calculate COPD prevalence by sex over time

alive_sex <- output$n_alive_by_ctime_sex
COPD_sex <- output$n_COPD_by_ctime_sex
prevalenceCOPD_sex <- COPD_sex / alive_sex
prevalenceCOPD_sex<-as.data.frame (prevalenceCOPD_sex)

# Rename columns
colnames(prevalenceCOPD_sex) <- c("Male", "Female")
prevalenceCOPD_sex$Year <- 2015:2040


# Display summary of COPD prevalence by sex

kable(prevalenceCOPD_sex,
  caption = "COPD Prevalence by Sex Over Time",
  digits = 3
)

