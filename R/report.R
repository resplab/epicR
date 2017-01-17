
report_COPD_by_ctime<-function(n_sim=10^6)
{
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  #settings$events_to_record<-events[c("event_COPD")]
  settings$agent_stack_size<-0
  settings$n_base_agents<-n_sim
  settings$event_stack_size<-settings$n_base_agents*0
  
  init_session(settings=settings)
  
  run()
  
  op<-Cget_output()
  opx<-Cget_output_ex()
  
  g1<-41:55
  g2<-56:70
  g3<-71:84
  g4<-85:111
  
  #Overall incidence
  y<-rowSums(opx$n_inc_COPD_by_ctime_age)/rowSums(opx$n_alive_by_ctime_age-opx$n_COPD_by_ctime_age)
  plot(2015:2034,y,type='l',ylim=c(0,max(y)),xlab="Year",ylab="Annual incidence")
  title(cex.main=1,"Incidence over time (simulated)")
  
  #Incidence by age group
  a<-opx$n_inc_COPD_by_ctime_age
  b<-opx$n_alive_by_ctime_age-opx$n_COPD_by_ctime_age
  y1<-rowSums(a[,g1])/rowSums(b[,g1])
  y2<-rowSums(a[,g2])/rowSums(b[,g2])
  y3<-rowSums(a[,g3])/rowSums(b[,g3])
  y4<-rowSums(a[,g4])/rowSums(b[,g4])
  max_y<-max(c(y1,y2,y3,y4))
  plot(2015:2034,y1,type='l',ylim=c(0,max_y*1.5),xlab="Year",ylab="Annual incidence",col="green")
  lines(2015:2034,y2,type='l',col="blue")
  lines(2015:2034,y3,type='l',col="black")
  lines(2015:2034,y4,type='l',col="red")
  legend("topright",c("40-54","55-64","65-74","75+"),lty=c(1,1,1,1),col=c("green","blue","black","red"))
  title(cex.main=1,"Incidence by age group (simulated)")
  
  
  #overall prevalence
  y<-rowSums(opx$n_COPD_by_ctime_age)/rowSums(opx$n_alive_by_ctime_age)
  plot(2015:2034,y,type='l',ylim=c(0,max(y)),xlab="Year",ylab="Annual prevalence")
  title(cex.main=1,"Prevalence over time (simulated)")
  
  #Prevalence by age groups;
  a<-opx$n_COPD_by_ctime_age
  b<-opx$n_alive_by_ctime_age
  y1<-rowSums(a[,g1])/rowSums(b[,g1])
  y2<-rowSums(a[,g2])/rowSums(b[,g2])
  y3<-rowSums(a[,g3])/rowSums(b[,g3])
  y4<-rowSums(a[,g4])/rowSums(b[,g4])
  max_y<-max(c(y1,y2,y3,y4))
  plot(2015:2034,y1,type='l',ylim=c(0,max_y*1.5),xlab="Year",ylab="Annual incidence",col="green")
  lines(2015:2034,y2,type='l',col="blue")
  lines(2015:2034,y3,type='l',col="black")
  lines(2015:2034,y4,type='l',col="red")
  legend("topright",c("40-54","55-64","65-74","75+"),lty=c(1,1,1,1),col=c("green","blue","black","red"))
  title(cex.main=1,"Prevalence by age group (simulated)")
  
  
  #Prevalence of GOLD stages over time;
  a<-opx$n_COPD_by_ctime_severity
  b<-opx$n_alive_by_ctime_sex
  y0<-a[,1]/rowSums(b)
  y1<-a[,2]/rowSums(b)
  y2<-a[,3]/rowSums(b)
  y3<-a[,4]/rowSums(b)
  y4<-a[,5]/rowSums(b)
  max_y<-max(c(y1,y2,y3,y4))
  plot(2015:2034,y1,type='l',ylim=c(0,max_y*1.5),xlab="Year",ylab="Annual prevalence by GOLD stage",col="black")
  lines(2015:2034,y2,type='l',col="blue")
  lines(2015:2034,y3,type='l',col="orange")
  lines(2015:2034,y4,type='l',col="red")
  legend("topright",c("GOLD I","GOLD II","GOLD III", "GOLD IV"),lty=c(1,1,1,1),col=c("black","blue","orange","red"))
  title(cex.main=1,"Prevalence by GOLD stage (simulated)")
}






report_exacerbation_by_time<-function(n_sim=10^6)
{
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-n_sim
  settings$event_stack_size<-settings$n_base_agents*0
  
  init_session(settings=settings)
  
  run()
  
  op<-Cget_output()
  opx<-Cget_output_ex()
  
  cat("Annual rate of exacerbation:",sum(opx$n_exac_by_ctime_severity)/(op$cumul_time-opx$cumul_non_COPD_time),"\n")
  cat("Annual rate of exacerbation by severity:",colSums(opx$n_exac_by_ctime_severity)/(op$cumul_time-opx$cumul_non_COPD_time),"\n")
  
  g1<-41:55
  g2<-56:70
  g3<-71:84
  g4<-85:111
  
  #Overall rate
  y<-rowSums(opx$n_exac_by_ctime_severity)/rowSums(opx$n_alive_by_ctime_sex)
  plot(2015:2034,y,type='l',ylim=c(0,max(y)),xlab="Year",ylab="Annual incidence")
  title(cex.main=0.5,"Exacerbation rate over time (across population)")
  
  #Rate by age group
  a<-opx$n_exac_by_ctime_age
  b<-opx$n_alive_by_ctime_age
  y1<-rowSums(a[,g1])/rowSums(b[,g1])
  y2<-rowSums(a[,g2])/rowSums(b[,g2])
  y3<-rowSums(a[,g3])/rowSums(b[,g3])
  y4<-rowSums(a[,g4])/rowSums(b[,g4])
  max_y<-max(c(y1,y2,y3,y4))
  plot(2015:2034,y1,type='l',ylim=c(0,max_y*1.5),xlab="Year",ylab="Annual rate",col="green")
  lines(2015:2034,y2,type='l',col="blue")
  lines(2015:2034,y3,type='l',col="black")
  lines(2015:2034,y4,type='l',col="red")
  legend("topright",c("40-54","55-64","65-74","75+"),lty=c(1,1,1,1),col=c("green","blue","black","red"))
  title(cex.main=1,"Exacerbation rate by age group (across all population)")
  
  
  #Overall rate (within COPD)
  y<-rowSums(opx$n_exac_by_ctime_severity)/rowSums(opx$n_COPD_by_ctime_sex)
  plot(2015:2034,y,type='l',ylim=c(0,max(y)),xlab="Year",ylab="Annual rate")
  title(cex.main=0.5,"Exacerbation rate over time (within COPD)")
  
  #Rate by age group (within COPD)
  a<-opx$n_exac_by_ctime_age
  b<-opx$n_COPD_by_ctime_age
  y1<-rowSums(a[,g1])/rowSums(b[,g1])
  y2<-rowSums(a[,g2])/rowSums(b[,g2])
  y3<-rowSums(a[,g3])/rowSums(b[,g3])
  y4<-rowSums(a[,g4])/rowSums(b[,g4])
  max_y<-max(c(y1,y2,y3,y4))
  plot(2015:2034,y1,type='l',ylim=c(0,max_y*1.5),xlab="Year",ylab="Annual rate",col="green")
  lines(2015:2034,y2,type='l',col="blue")
  lines(2015:2034,y3,type='l',col="black")
  lines(2015:2034,y4,type='l',col="red")
  legend("topright",c("40-54","55-64","65-74","75+"),lty=c(1,1,1,1),col=c("green","blue","black","red"))
  title(cex.main=1,"Exacerbation rate by age group (within COPD)")
  
  #Rate by severity (within COPD)
  a<-opx$n_exac_by_ctime_severity
  b<-opx$n_COPD_by_ctime_sex
  y1<-(a[,1])/rowSums(b)
  y2<-(a[,2])/rowSums(b)
  y3<-(a[,3])/rowSums(b)
  max_y<-max(c(y1,y2,y3))
  plot(2015:2034,y1,type='l',ylim=c(0,max_y*1.5),xlab="Year",ylab="Annual rate",col="green")
  lines(2015:2034,y2,type='l',col="blue")
  lines(2015:2034,y3,type='l',col="black")
  legend("topright",c("mild","moderate","severe"),lty=c(1,1,1),col=c("green","blue","black"))
  title(cex.main=1,"Exacerbation rate by age group (within COPD)")
  
  pie(colSums(opx$n_exac_by_ctime_severity),labels=c("Mild","Moderate","severe"))
  
  cat("Proportion by severity:",format(colSums(opx$n_exac_by_ctime_severity/sum(opx$n_exac_by_ctime_severity)),digits=2),"\n")
  
  terminate_session()
}
