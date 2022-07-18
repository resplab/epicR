library(epicR)
library(tidyverse)
library(ggthemes)


record_mode<-c(
  record_mode_none=0,  # do not record events, just summerize statistics
  record_mode_agent=1, #
  record_mode_event=2, #record all events => each line of the output represents one event foe each agent
  record_mode_some_event=3)

settings <- get_default_settings()
settings$record_mode <- record_mode["record_mode_event"]
settings$n_base_agents <- 50000 # change number of agents here
init_session(settings = settings)


# init_session()

run()


all_events <- data.frame(Cget_all_events_matrix())
op <- Cget_output()
output_ex <- Cget_output_ex()


#----------------------------DIAGNOSED ------------------------------------
#-------------------------------------------------------------------------

all_events_diagnosed <- subset(all_events, diagnosis > 0 & gold > 0 )

exac_events <- subset(all_events_diagnosed, event == 5 )
sev_exac_events <- subset(all_events_diagnosed, event == 5 & (exac_status == 3 | exac_status == 4) )
mod_sev_exac_events <- subset(all_events_diagnosed, event == 5 & (exac_status == 3 | exac_status == 4 | exac_status == 2) )
exit_events <- subset(all_events_diagnosed, event == 14)

Follow_up_Gold <- c(0, 0, 0, 0)
last_GOLD_transition_time <- 0
for (i in 2:dim(all_events_diagnosed)[1]) {
  if ((all_events_diagnosed[i, "id"] != all_events_diagnosed[i - 1, "id"]))
    last_GOLD_transition_time <- 0
  if ((all_events_diagnosed[i, "id"] == all_events_diagnosed[i - 1, "id"]) & (all_events_diagnosed[i, "gold"] != all_events_diagnosed[i - 1, "gold"])) {
    Follow_up_Gold[all_events_diagnosed[i - 1, "gold"]] = Follow_up_Gold[all_events_diagnosed[i - 1, "gold"]] + (all_events_diagnosed[i - 1, "local_time"]-all_events_diagnosed[i - 1, "time_at_diagnosis"]) -
      last_GOLD_transition_time
    last_GOLD_transition_time <- (all_events_diagnosed[i - 1, "local_time"]-all_events_diagnosed[i - 1, "time_at_diagnosis"])
  }
  if (all_events_diagnosed[i, "event"] == 14)
    Follow_up_Gold[all_events_diagnosed[i, "gold"]] = Follow_up_Gold[all_events_diagnosed[i, "gold"]] + (all_events_diagnosed[i, "local_time"]-all_events_diagnosed[i, "time_at_diagnosis"]) -
      last_GOLD_transition_time
}

terminate_session()


#-------------------------------TOTAL ------------------------------------------

# cat("Rates of exacerbation per GOLD stage:\n")
# cat("GOLD I: ", as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1], "\n")
# cat("GOLD II: ", as.data.frame(table(exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2], "\n")
# cat("GOLD III: ", as.data.frame(table(exac_events[, "gold"]))[3, 2]/Follow_up_Gold[3], "\n")
# cat("GOLD IV: ", as.data.frame(table(exac_events[, "gold"]))[4, 2]/Follow_up_Gold[4], "\n")

Exac_per_GOLD <- matrix (NA, nrow = 4, ncol =3)
colnames(Exac_per_GOLD) <- c("GOLD", "EPIC", "Hoogendoorn")
Exac_per_GOLD[1:4, 1] <- c("gold1", "gold2", "gold3", "gold4")
Exac_per_GOLD[1:4, 2] <- round(x=as.data.frame(table(exac_events[, "gold"]))[, 2]/Follow_up_Gold, digit = 2)
Exac_per_GOLD[1:4, 3] <- c(0.82, 1.17, 1.61, 2.10)


df <- as.data.frame(Exac_per_GOLD)
dfm <- reshape2::melt(df[,c("GOLD", "EPIC", "Hoogendoorn")],id.vars = 1)
plot_Exac_per_GOLD <- ggplot2::ggplot(dfm, aes(x = GOLD, y = as.numeric(value))) + scale_y_continuous(breaks = seq(0, 3, by = 0.5)) +  theme_tufte(base_size=14, ticks=F)  +
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge")   + ylab ("Rate") + labs(caption = "Total rate of exacerbations per year") + scale_fill_manual(values = c("#123456", "#FBB917"))
plot(plot_Exac_per_GOLD)

ggsave("Figures_calibration/totalExacs.png", width=10, height=8, device="png")


print("total rate of exacerbation:")
print(nrow(exac_events)/sum(Follow_up_Gold))


#--------------------------- total number of severe exacerbation:


print("Are number of severe and very severe exacerbations around 100'000?")
n_exac <- data.frame(year= 1:20,Severe_Exacerbations = (output_ex$n_exac_by_ctime_severity[,3]+output_ex$n_exac_by_ctime_severity[,4])* (100000/rowSums(output_ex$n_alive_by_ctime_sex)))
averagen_severeexac <- mean(n_exac$Severe_Exacerbations[round(nrow(n_exac)/2,0):nrow(n_exac)])
print(averagen_severeexac)

print("Are the number of severe and very severe exacerbations around 100'000 in 2017?")
n_exac <-(output_ex$n_exac_by_ctime_severity[3,3]+output_ex$n_exac_by_ctime_severity[3,4])*(100000/sum(output_ex$n_alive_by_ctime_sex[3,]))
print(n_exac)


## 2
#------------- --------------Abi's rates ------------------------------------
#----------------------------------------------------------------------------

# cat("Rates of moderate and severe exacerbation per GOLD stage:\n")
# cat("GOLD I: ", as.data.frame(table(mod_sev_exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1], "\n")
# cat("GOLD II: ", as.data.frame(table(mod_sev_exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2], "\n")
# cat("GOLD III: ", as.data.frame(table(mod_sev_exac_events[, "gold"]))[3, 2]/Follow_up_Gold[3], "\n")
# cat("GOLD IV: ", as.data.frame(table(mod_sev_exac_events[, "gold"]))[4, 2]/Follow_up_Gold[4], "\n")


Exac_per_GOLD <- matrix (NA, nrow = 4, ncol =3)
colnames(Exac_per_GOLD) <- c("GOLD", "EPIC", "Abi's rates")
Exac_per_GOLD[1:4, 1] <- c("gold1", "gold2", "gold3", "gold4")
Exac_per_GOLD[1:4, 2] <- round(x=as.data.frame(table(mod_sev_exac_events[, "gold"]))[, 2]/Follow_up_Gold, digit = 2)
Exac_per_GOLD[1:4, 3] <- c(0.58, 0.91, 1.41, 1.69)

df <- as.data.frame(Exac_per_GOLD)
dfm <- reshape2::melt(df[,c("GOLD", "EPIC", "Abi's rates")],id.vars = 1)
plot_Exac_per_GOLD <- ggplot2::ggplot(dfm, aes(x = GOLD, y = as.numeric(value))) + scale_y_continuous(breaks = seq(0, 2, by = 0.2)) +  theme_tufte(base_size=14, ticks=F) +
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge")   + ylab ("Rate") + labs(caption = "Total rate of moderate/severe exacerbations per year") + scale_fill_manual(values = c("#123456", "#990000"))
plot(plot_Exac_per_GOLD) 

ggsave("Figures_calibration/totalExceptMildExacs_Abi.png", width=10, height=8, device="png")

print("total rate of mod/severe and very severe exacerbation:")
print(nrow(mod_sev_exac_events)/sum(Follow_up_Gold))


## 3
#------------- --------------SEVERE ------------------------------------
#-------------------------------------------------------------------------

# cat("Rates of severe exacerbation per GOLD stage:\n")
# cat("GOLD I: ", as.data.frame(table(sev_exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1], "\n")
# cat("GOLD II: ", as.data.frame(table(sev_exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2], "\n")
# cat("GOLD III: ", as.data.frame(table(sev_exac_events[, "gold"]))[3, 2]/Follow_up_Gold[3], "\n")
# cat("GOLD IV: ", as.data.frame(table(sev_exac_events[, "gold"]))[4, 2]/Follow_up_Gold[4], "\n")


Exac_per_GOLD <- matrix (NA, nrow = 4, ncol =4)
colnames(Exac_per_GOLD) <- c("GOLD", "EPIC", "Hoogendoorn", "Abi's rates")
Exac_per_GOLD[1:4, 1] <- c("gold1", "gold2", "gold3", "gold4")
Exac_per_GOLD[1:4, 2] <- round(x=as.data.frame(table(sev_exac_events[, "gold"]))[, 2]/Follow_up_Gold, digit = 2)
Exac_per_GOLD[1:4, 3] <- c(0.11, 0.16, 0.22, 0.28)
Exac_per_GOLD[1:4, 4] <- c(0.10, 0.13, 0.32, 0.42)

df <- as.data.frame(Exac_per_GOLD)
dfm <- reshape2::melt(df[,c("GOLD", "EPIC", "Hoogendoorn", "Abi's rates")],id.vars = 1)
plot_Exac_per_GOLD <- ggplot2::ggplot(dfm, aes(x = GOLD, y = as.numeric(value))) + scale_y_continuous(breaks = seq(0, 1, by = 0.1)) +  theme_tufte(base_size=14, ticks=F) +
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge")   + ylab ("Rate") + labs(caption = "Total rate of *severe* exacerbations per year") + scale_fill_manual(values = c("#123456", "#FBB917", "#990000"))
plot(plot_Exac_per_GOLD) 

ggsave("Figures_calibration/totalSevExacs.png", width=10, height=8, device="png")

print("total rate of severe and very severe exacerbation:")
print(nrow(sev_exac_events)/sum(Follow_up_Gold))


# 4
#--------------------------- Severe to moderate + Severe ratio -----------
#-------------------------------------------------------------------------

cat("The ratio of severe exacerbations to moderate and severe:\n")
print(nrow(sev_exac_events)/nrow(mod_sev_exac_events))
# print(sum(output_ex$n_exac_by_ctime_severity_diagnosed[,3:4])/sum(output_ex$n_exac_by_ctime_severity_diagnosed[,2:4]))

# cat("GOLD I: ",as.data.frame(table(sev_exac_events[, "gold"]))[1, 2]/as.data.frame(table(mod_sev_exac_events[, "gold"]))[1, 2], "\n")
# cat("GOLD II: ",as.data.frame(table(sev_exac_events[, "gold"]))[2, 2]/as.data.frame(table(mod_sev_exac_events[, "gold"]))[2, 2], "\n")
# cat("GOLD III: ",as.data.frame(table(sev_exac_events[, "gold"]))[3, 2]/as.data.frame(table(mod_sev_exac_events[, "gold"]))[3, 2], "\n")
# cat("GOLD IV: ",as.data.frame(table(sev_exac_events[, "gold"]))[4, 2]/as.data.frame(table(mod_sev_exac_events[, "gold"]))[4, 2], "\n")

Exac_per_GOLD <- matrix (NA, nrow = 4, ncol =3)
colnames(Exac_per_GOLD) <- c("GOLD", "EPIC", "Abi's ratio")
Exac_per_GOLD[1:4, 1] <- c("gold1", "gold2", "gold3", "gold4")
Exac_per_GOLD[1:4, 2] <- round(x=as.data.frame(table(sev_exac_events[, "gold"]))[, 2]/as.data.frame(table(mod_sev_exac_events[, "gold"]))[, 2], digit = 2)
Exac_per_GOLD[1:4, 3] <- c(0.17, 0.15, 0.23, 0.25)

df <- as.data.frame(Exac_per_GOLD)
dfm <- reshape2::melt(df[,c("GOLD", "EPIC", "Abi's ratio")],id.vars = 1)
plot_Exac_per_GOLD <- ggplot2::ggplot(dfm, aes(x = GOLD, y = as.numeric(value))) + scale_y_continuous(breaks = seq(0, 2, by = 0.2)) +  theme_tufte(base_size=14, ticks=F) +
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge")   + ylab ("Rate") + labs(caption = "Total ratio of severe to moderate/severe exacerbations per year") + scale_fill_manual(values = c("#123456", "#990000"))
plot(plot_Exac_per_GOLD) 

ggsave("Figures_calibration/SevtoMod.png", width=10, height=8, device="png")


# #--------------------------- Severe to all -----------
# #-------------------------------------------------------------------------
# Exac_per_GOLD <- matrix (NA, nrow = 4, ncol =3)
# colnames(Exac_per_GOLD) <- c("GOLD", "EPIC", "Hoogendoorn")
# Exac_per_GOLD[1:4, 1] <- c("gold1", "gold2", "gold3", "gold4")
# Exac_per_GOLD[1:4, 2] <- round(x=as.data.frame(table(sev_exac_events[, "gold"]))[, 2]/as.data.frame(table(exac_events[, "gold"]))[, 2], digit = 2)
# Exac_per_GOLD[1:4, 3] <- c(0.13, 0.13, 0.13, 0.13)
# 
# df <- as.data.frame(Exac_per_GOLD)
# dfm <- reshape2::melt(df[,c("GOLD", "EPIC", "Hoogendoorn")],id.vars = 1)
# plot_Exac_per_GOLD <- ggplot2::ggplot(dfm, aes(x = GOLD, y = as.numeric(value))) + scale_y_continuous(breaks = seq(0, 2, by = 0.02)) +  theme_tufte(base_size=14, ticks=F) +
#   geom_bar(aes(fill = variable), stat = "identity", position = "dodge")   + ylab ("Rate") + labs(caption = "Total ratio of severe to all exacerbations per year") + scale_fill_manual(values = c("#123456", "#FBB917"))
# plot(plot_Exac_per_GOLD) 
# 
# ggsave("Figures_calibration/SevToAll.png", width=10, height=8, device="png")
# 

#--------------------------- Ratio of diagnosed to all -----------

mean(rowSums(output_ex$n_Diagnosed_by_ctime_sex)/rowSums(output_ex$n_COPD_by_ctime_sex))



#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
#_____________________UNDIAGNOSED_____________________________
#-------------------------------------------------------------------------

record_mode<-c(
  record_mode_none=0,  # do not record events, just summerize statistics
  record_mode_agent=1, #
  record_mode_event=2, #record all events => each line of the output represents one event foe each agent
  record_mode_some_event=3)

settings <- get_default_settings()
settings$record_mode <- record_mode["record_mode_event"]
settings$n_base_agents <- 50000 # change number of agents here
init_session(settings = settings)


# init_session()

run()


all_events <- data.frame(Cget_all_events_matrix())
op <- Cget_output()
output_ex <- Cget_output_ex()


all_events_undiagnosed <- subset(all_events, diagnosis == 0 & gold > 0  )

exac_events <- subset(all_events_undiagnosed, event == 5 )
sev_exac_events <- subset(all_events_undiagnosed, event == 5 & (exac_status == 3 | exac_status == 4) )
exit_events <- subset(all_events_undiagnosed, event == 14)


Follow_up_Gold <- c(0, 0, 0, 0)
last_GOLD_transition_time <- 0
for (i in 2:dim(all_events_undiagnosed)[1]) {
  if ((all_events_undiagnosed[i, "id"] != all_events_undiagnosed[i - 1, "id"]))
    last_GOLD_transition_time <- 0
  if ((all_events_undiagnosed[i, "id"] == all_events_undiagnosed[i - 1, "id"]) & (all_events_undiagnosed[i, "gold"] != all_events_undiagnosed[i - 1, "gold"])) {
    Follow_up_Gold[all_events_undiagnosed[i - 1, "gold"]] = Follow_up_Gold[all_events_undiagnosed[i - 1, "gold"]] + all_events_undiagnosed[i - 1, "followup_after_COPD"] -
      last_GOLD_transition_time
    last_GOLD_transition_time <- all_events_undiagnosed[i - 1, "followup_after_COPD"]
  }
  if (all_events_undiagnosed[i, "event"] == 14)
    Follow_up_Gold[all_events_undiagnosed[i, "gold"]] = Follow_up_Gold[all_events_undiagnosed[i, "gold"]] + all_events_undiagnosed[i, "followup_after_COPD"] -
      last_GOLD_transition_time
}

terminate_session()

cat("Rates of exacerbation per GOLD stage:\n")
cat("GOLD I: ", as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1], "\n")
cat("GOLD II: ", as.data.frame(table(exac_events[, "gold"]))[2, 2]/Follow_up_Gold[2], "\n")
cat("GOLD III: ", as.data.frame(table(exac_events[, "gold"]))[3, 2]/Follow_up_Gold[3], "\n")
cat("GOLD IV: ", as.data.frame(table(exac_events[, "gold"]))[4, 2]/Follow_up_Gold[4], "\n")

#_____ total rate:
print("total rate of exacerbation in undiagnosed:")
total_rate_undiagnosed <- (nrow(exac_events)/sum(Follow_up_Gold))
print(total_rate_undiagnosed)

gold2Plus <- as.data.frame(table(exac_events[, "gold"]))[2, 2]+as.data.frame(table(exac_events[, "gold"]))[3, 2]
gold2Plus_followUp <- sum(Follow_up_Gold[2:3])

Exac_per_GOLD <- matrix (NA, nrow = 3, ncol =3)
colnames(Exac_per_GOLD) <- c("GOLD", "EPIC", "CanCold")
Exac_per_GOLD[1:3, 1] <- c("Total", "gold1", "gold2+")
Exac_per_GOLD[1:3, 2] <- c(round(total_rate_undiagnosed,2), round(as.data.frame(table(exac_events[, "gold"]))[1, 2]/Follow_up_Gold[1], 2), round(gold2Plus/gold2Plus_followUp, 2) )
Exac_per_GOLD[1:3, 3] <- c(0.30, 0.24, 0.40)

df <- as.data.frame(Exac_per_GOLD)
dfm <- reshape2::melt(df[,c("GOLD", "EPIC", "CanCold")],id.vars = 1)
plot_Exac_per_GOLD <- ggplot2::ggplot(dfm, aes(x = GOLD,y = as.numeric(value))) + scale_y_continuous(breaks = seq(0, 1, by = 0.1)) +  theme_tufte(base_size=14, ticks=F) +
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge")   + ylab ("Rate") + labs(caption = "rate of exacerbations in undiagnosed") + scale_fill_manual(values = c("#123456", "#FBB917"))
plot(plot_Exac_per_GOLD) 

#------------------------------------------------------------severe ones:
#-------------------------------------------------------------------------





