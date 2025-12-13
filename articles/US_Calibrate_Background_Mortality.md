# US_Calibrate Background Mortality

In this document, we aim to explore how the model behaves when
COPD-related mortality is turned off. Specifically, our goal is to
observe probability of death values that closely align with the
background mortality rates from official U.S. sources. This is the
expected behavior, as disabling exacerbation-related deaths causes the
model to no longer predict mortality from exacerbations, which should
result in values matching the background mortality rates.

To achieve this, we followed the series of steps below:

### Step 1: Shutting off exacerbation related mortality.

First, we set the intercept of the exacerbation equation to a high
value, effectively disabling death from exacerbations in the model. This
adjustment is made by changing the relevant variable as follows:

``` r
library(epicR)
packageVersion("epicR")
input<-get_input(jurisdiction = "us")
input$values$exacerbation$logit_p_death_by_sex <- cbind(
  male = c(intercept = -13000, age = log(1.05), mild = 0, moderate = 0, severe = 7.4,
    very_severe = 8, n_hist_severe_exac = 0),
  female = c(intercept = -13000, age = log(1.05), mild = 0, moderate = 0, severe = 7.4,
    very_severe = 8, n_hist_severe_exac = 0)
)

#also setting exlicit mortality = 0 so there is no correction made
input$values$manual$explicit_mortality_by_age_sex <- cbind(
    male = c(rep(0, 111)),
    female = c(rep(0, 111)))
```

### Step 2: Setting longevitiy-related parameters to 0.

Longevity is another factor in the model that influences population. To
ensure that no external factors impact the population, we set these
parameters to 0. This adjustment can be made in the input.R file.

``` r
input$values$agent$ln_h_bgd_betas <- t(as.matrix(c(intercept = 0, y = 0, y2 = 0, age = 0,
                                            b_mi = 0, n_mi = 0, b_stroke = 0,
                                            n_stroke = 0, hf = 0)))
```

### Step 3: Run the model for 1 year and retrieve events matrix

Initially we run the model for 1 year and get the events matrix. This
matrix logs all the events that individuals go through thoughout the
model. We will use this matrix to calculate death probabilities produced
by epicR

``` r
library(epicR)
settings <- get_default_settings()
settings$record_mode <- 2
settings$n_base_agents <- 3.5e5

# input <- get_input(jurisdiction = "us")

# set time horizon as 1 initially 
time_horizon <- 1
input$values$global_parameters$time_horizon <- time_horizon

results <- simulate(settings = settings, input = input$values, return_events = TRUE)
events <- results$events

# checking to make sure event 7 (death by exacerbation) is not included 
# because we shut that off in the model
unique(events$event)
table(events$event)
```

### Step 4: Calculating probability of death from events matrix

``` r
library(dplyr)
library(tidyr)

# we will group by age so we convert ages into whole numbers.
events <- events %>%
  mutate(age_and_local = floor(local_time + age_at_creation))

# Filter events to identify individuals who have experienced event 14,
# while also creating a flag for whether they ever experienced event 13 (death)
events_filtered<- events %>%
  mutate(death= ifelse(event==13,1,0)) %>%
  group_by(id) %>%
  mutate(ever_death = sum(death)) %>%
  filter(event==14) %>%
  ungroup()


# calculationg probability of death
death_prob<- events_filtered %>%
  group_by(age_and_local, female) %>%
  summarise(
    total_count = n(),
    death_count = sum(ever_death==1),
    death_probability = death_count / total_count
  )
```

### Inspecting the results

We should not consider 40 year-olds beause (Amin said … )

``` r
print(head(death_prob, 15))
print(tail(death_prob,15))
```

While these values are not perfectly aligned with our validation target,
the variation is negligible.

Next, we want to ensure a consistent directional effect. We expect that
increasing time_horizon to 5 years will bring the results closer to our
target.

``` r

# set time horizon to 5
time_horizon <- 6
input$values$global_parameters$time_horizon <- time_horizon

results5 <- simulate(settings = settings, input = input$values, return_events = TRUE)
events5 <- results5$events

table(events$event)

events5 <- events5 %>%
  mutate(age_and_local = floor(local_time + age_at_creation))


events5 <- events5 %>%
  mutate(local_time_adj = ceiling(events5$local_time))

# withing that year have they ever died?
events5_filtered<- events5 %>%
  mutate(death= ifelse(event==13,1,0)) %>%
  group_by(id,local_time_adj) %>%
  mutate(ever_death = sum(death)) %>%
  filter(event==14) %>%
  ungroup()


death_prob5<- events5_filtered %>%
  group_by(age_and_local, female, local_time_adj) %>%
  summarise(
    total_count = n(),
    death_count = sum(ever_death==1),
    death_probability = death_count / total_count
  )
```

Now, when we check the results. We see that the results are even further
away:

``` r
print(head(death_prob5, 15))
print(tail(death_prob5,15))
```

### Visualizing results

To better understand the differences, we visualize the results and
compare them against the target values.

``` r
death_prob_clean <- death_prob %>%
   ungroup() %>%
   select(age_and_local, female, death_probability) %>%
   pivot_wider(names_from = female, values_from = death_probability, names_prefix = "sex_")

colnames(death_prob_clean) <- c("Age", "Male", "Female")
```

``` r


USlifetables_num <- input$values$agent$p_bgd_by_sex


USlifetables_df <- data.frame(
  Age = 1:nrow(USlifetables_num),  # Start age from 1
  Male = USlifetables_num[, 1],
  Female = USlifetables_num[, 2]
)

common_ages <- intersect(death_prob_clean$Age, USlifetables_df$Age)

# filter both so only include the rows with matching Age
death_prob_filtered <- death_prob_clean[death_prob_clean$Age %in% common_ages, ]
USlifetables_filtered <- USlifetables_df[USlifetables_df$Age %in% common_ages, ]
```

``` r
library(ggplot2)
library(dplyr)

combined_data_long <- bind_rows(
  death_prob_filtered %>% mutate(Source = "epicR"),
  USlifetables_filtered %>% mutate(Source = "US Life Tables")
) %>%
  pivot_longer(cols = c("Male", "Female"), names_to = "Sex", values_to = "Death_Probability") %>%
  filter(Age > 40)  

ggplot(combined_data_long, aes(x = Age, y = Death_Probability, fill = Source)) +
  geom_col(position = "dodge", width = 1) +  
  facet_wrap(~Sex) +
  labs(
    title = "Comparison of epicR Death Probability vs. US Life Tables (time_horizon =1)",
    x = "Age",
    y = "Death Probability",
    fill = "Source:"
  ) +
  theme_minimal()+
  theme(
    legend.position = "top",
    legend.justification = "center",
    plot.title = element_text(hjust = 0.5, margin = margin(b = 10))
  )
```

When `time_horizon = 6`, we get the following plot.

``` r

library(ggplot2)
library(tidyr)
library(dplyr)

combined_data_long5 <- bind_rows(
  death_prob5_filtered %>% mutate(Source = "epicR"),
  USlifetables_filtered %>% mutate(Source = "US Life Tables")
) %>%
  pivot_longer(cols = c("Male", "Female"), names_to = "Sex", values_to = "Death_Probability") %>%
  filter(Age > 40)  


final_EPIC_death5<- filter(combined_data_long5, Source == "epicR")
final_US_death<- filter(combined_data_long5, Source == "US Life Tables")

# Add Death_Probability to USlifetables_filtered
USlifetables_filtered_long <- USlifetables_filtered %>%
  gather(key = "Sex", value = "Death_Probability", Male, Female)

# Loop through each unique year in the combined_data_long dataset
for (year in unique(combined_data_long5$Year)) {
  
  # Filter the data for the current year
  year_data <- combined_data_long5 %>% filter(Year == year)
  
  # Create the plot for the current year
  p <- ggplot(combined_data_long, aes(x = Age, y = Death_Probability, fill = Source)) +
  geom_col(position = "dodge", width = 1) +  
  facet_wrap(~Sex) +
  labs(
    title = "Comparison of epicR Death Probability vs. US Life Tables (time_horizon = 6)",
    x = "Age",
    y = "Death Probability",
    fill = "Source:"
  ) +
  theme_minimal()+
  theme(
    legend.position = "top",
    legend.justification = "center",
    plot.title = element_text(hjust = 0.5, margin = margin(b = 10))
  )
  
  # Print the plot for the current year
  # print(p)
}

print(p)
```

When we break it down and analyze per year, it seems to be in line with
what we expect.

### Eliminating smoking mortality

We have identified a potential source of the observed mortality
discrepancies. Specifically, the mortality ratio associated with both
former and current smokers appears to be influencing the results.

To investigate this, we set the following smoking-related mortality
factors to 1 (indicating no excess mortality risk for former and current
smokers):

After making this adjustment, the results align more closely with the
life tables.

- This suggests that either:
  - The model may be generating an excessive number of current and
    former smokers, leading to higher mortality than expected.
  - We will need to update the mortality ratio estimates depending on
    whether an individual currently or formerly smokes.

``` r


input$values$smoking$mortality_factor_former<- c(age40to49=1,age50to59=1,
                                                 age60to69=1,age70to79=1,
                                                 age80p=1)
input$values$smoking$mortality_factor_current<- c(age40to49=1,age50to59=1,
                                                  age60to69=1,age70to79=1,
                                                  age80p=1)
```

### Changing the intercept of `logit_p_never_smoker_con_not_current_0_betas`

Currently the model has too many former smokers. This can be adjusted by
increased the intercept of
`logit_p_never_smoker_con_not_current_0_betas`. So first,instead of
changing the mortality factors, we keep the mortality factors for
current and former smokers the same.

``` r

settings <- get_default_settings()
settings$record_mode <- 2
settings$n_base_agents <- 1e6

input<-get_input(jurisdiction = "us")

time_horizon <- 1
input$values$global_parameters$time_horizon <- time_horizon

# kept the same
input$values$smoking$mortality_factor_current <- t(as.matrix(c(age40to49 = 1,
                                                        age50to59 = 1,
                                                        age60to69 = 1.94,
                                                        age70to79 = 1.86,
                                                        age80p = 1.66 )))

# kept the same
input$values$smoking$mortality_factor_former<- t(as.matrix(c(age40to49 = 1,
                                                      age50to59 = 1,
                                                      age60to69 = 1.54,
                                                      age70to79 = 1.36,
                                                      age80p = 1.27 )))
```

Then, we adjust the intercept to ensure that the ratio of never-smokers
to the total population is approximately 0.21. We modify the intercept
accordingly to achieve this target.

``` r
# Probability of being a never-smoker conditional on not being current smoker,
# at the time of creation
input$values$smoking$logit_p_never_smoker_con_not_current_0_betas <-
  t(as.matrix(c(intercept = 4.85, sex = 0, age = -0.06, age2 = 0,
                sex_age = 0,sex_age2 = 0, year = -0.02)))

results <- simulate(settings = settings, input = input$values, return_events = TRUE)
events <- results$events
output <- results$extended

# checking the ratio
smoking_num<-output$n_smoking_status_by_ctime
never_smoker_ratio <- smoking_num[1, 3] / sum(smoking_num[1, ])
never_smoker_ratio
```

Now we can visualize the change:
