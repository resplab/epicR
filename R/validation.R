library("ggplot2")
library(sqldf)


report_mode<-1;  #If 1, we are generating a report!

petoc<-function()
{
  if(report_mode==0) 
  {
    message("Press [Enter] to continue")
    r<-readline()
    if(r=="q") 
    {
      terminate_session()
      stop("User asked for termination.\n")
    }
  }
}



sanity_check<-function()
{
  init_session()
  
  cat("test 1: zero all costs\n")
  input<-model_input
  for(el in get_list_elements(input$cost))
    input$cost[[el]]<-input$cost[[el]]*0;
  res<-run(1,input=input)
  if(Cget_output()$total_cost!=0) message("Test failed!") else message("Test passed!")
  
  
  cat("test 2: zero all utilities\n")
  input<-model_input
  for(el in get_list_elements(input$utility))
    input$utility[[el]]<-input$utility[[el]]*0;
  res<-run(input=input)
  if(Cget_output()$total_qaly!=0) message("Test failed!") else message("Test passed!")
    
  
  cat("test 3: one all utilities ad get one QALY without discount\n")
  input<-model_input
  input$global_parameters$discount_qaly<-0;
  for(el in get_list_elements(input$utility))
    input$utility[[el]]<-input$utility[[el]]*0+1;
  input$utility$exac_dutil=input$utility$exac_dutil*0
  res<-run(input=input)
  if(Cget_output()$total_qaly/Cget_output()$cumul_time!=1) message("Test failed!") else message("Test passed!")
  
  
  cat("test 4: zero mortality (both bg and exac)\n")
  input<-model_input
  input$exacerbation$p_death<-input$exacerbation$p_death*0;
  input$agent$p_bgd_by_sex<-input$agent$p_bgd_by_sex*0;
  input$manual$explicit_mortality<-input$manual$explicit_mortality*0;
  res<-run(input=input)
  if(Cget_output()$n_deaths!=0) {stop("Test failed!")} else message("Test passed!")
}









validate_population<-function(remove_COPD=0,incidence_k=1)
{
  cat ("Validate_population(...) is responsible for producing output that can be used to test if the population module is properly calibrated.\n")
  petoc()
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-100000
  settings$event_stack_size<-1
  init_session(settings=settings)
  input<-model_input #We can work with local copy more conveniently and submit it to the Run function
  
  cat("\nBecause you have called me with remove_COPD=",remove_COPD,", I am",c("NOT","indeed")[remove_COPD+1],"going to remove COPD-related mortality from my calculations");
  petoc()
  
  CanSim.052.0005<-read.csv(paste(data_path,"/CanSim.052.0005.csv",sep=""),header=T) 
  x<-aggregate(CanSim.052.0005[,"value"],by=list(CanSim.052.0005[,'year']),FUN=sum)
  x[,2]<-x[,2]/x[1,2]
  x<-x[1:input$global_parameters$time_horizon,]
  plot(x,type='l',ylim=c(0.5,max(x[,2]*1.5)),xlab="Year",ylab="Relative population size")
  title(cex.main=0.5,"Relative populaton size")
  cat("The plot I just drew is the expected (well, StatCan's predictions) relative population growth from 2015\n")
  petoc()
  
  if(remove_COPD)
  {
    input$exacerbation$p_death<-input$exacerbation$p_death*0;
    input$manual$PROP_COPD_DEATH_BY_SEX_AGE<-input$manual$PROP_COPD_DEATH_BY_SEX_AGE*0;
  }
  
  input$agent$l_inc_betas[1]<-input$agent$l_inc_betas[1]+log(incidence_k)
  
  cat("working...\n")
  res<-run(input=input)
  if(res<0) {stop("Something went awry; bye!"); return();}
  
  n_y1_agents<-sum(Cget_output_ex()$n_alive_by_ctime_sex[1,])
  lines(x[1:model_input$global_parameters$time_horizon,1],rowSums(Cget_output_ex()$n_alive_by_ctime_sex)/n_y1_agents,col="red")
  legend("topright",c("Predicted","Simulated"),lty=c(1,1),col=c("black","red"))
  
  cat("And the black one is the observed (simulated) growth\n")
  
  pyramid<-matrix(NA,nrow=input$global_parameters$time_horizon,ncol=length(Cget_output_ex()$n_alive_by_ctime_age[1,])-input$global_parameters$age0)
  
  for(year in 0:model_input$global_parameters$time_horizon-1)
    pyramid[1+year,]<-Cget_output_ex()$n_alive_by_ctime_age[year+1,-(1:input$global_parameters$age0)]
  
  
  cat("Also, the ratio of the expected to observed population in years 10 and 20 are ",sum(Cget_output_ex()$n_alive_by_ctime_sex[10,])/x[10,2]," and ",sum(Cget_output_ex()$n_alive_by_ctime_sex[20,])/x[20,2])
  petoc()
  
  cat("Now evaluating the population pyramid\n")
  for(year in c(2015,2025,2034))
  {
    cat("The observed population pyramid in",year,"is just drawn\n")
    x<-CanSim.052.0005[which(CanSim.052.0005[,'year']==year & CanSim.052.0005[,'sex']=='both'),'value']
    x<-c(x,rep(0,111-length(x)-40))
    barplot(x,xlab="Age")
    title(cex.main=0.5,paste("Predicted Pyramid - ",year))
    
    cat("PRedicted average age of those >40 y/o is",sum((input$global_parameters$age0:(input$global_parameters$age0+length(x)-1))*x)/sum(x),"\n")
    petoc()
    
    #cat("The predicted population pyramid in 2015 is just drawn\n")
    x<-pyramid[year-2015+1,]
    barplot(x,col="blue",xlab="Age")
    title(cex.main=0.5,paste("Simulated Pyramid - ",year))
    cat("Simulated average age of those >40 y/o is",sum((input$global_parameters$age0:(input$global_parameters$age0+length(x)-1))*x)/sum(x),"\n")
    petoc()
  }
  
  
  message("This task is over... terminating")
  terminate_session()
}







validate_smoking<-function(remove_COPD=1,intercept_k=NULL)
{
  cat ("Welcome to EPIC validator! Today we will see if the model make good smoking predictions")
  petoc()
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_agent"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-100000
  settings$event_stack_size<-settings$n_base_agents*2+10
  
  init_session(settings=settings)
  input<-model_input
  input$agent$l_inc_betas[1]<--1000 #No incident cases for now
  
  cat("\nBecause you have called me with remove_COPD=",remove_COPD,", I am",c("NOT","indeed")[remove_COPD+1],"going to remove COPD-related mortality from my calculations");
  if(remove_COPD)
  {
    input$exacerbation$p_death<-input$exacerbation$p_death*0;
    input$manual$PROP_COPD_DEATH_BY_SEX_AGE<-input$manual$PROP_COPD_DEATH_BY_SEX_AGE*0;
  }
  
  if(!is.null(intercept_k))   input$manual$smoking$intercept_k<-intercept_k
  
  petoc()
  
  cat ("There are two validation targets: 1) the prevalence of current smokers (by sex) in 2015, and 2) the projected decline in smoking rate.\n")
  cat("Starting validation target 1: baseline prevalence of smokers.\n")
  petoc()
  
  CanSim.105.0501<-read.csv(paste(data_path,"/CanSim.105.0501.csv",sep=""),header=T)
  tab1<-rbind(CanSim.105.0501[1:3,"value"],CanSim.105.0501[4:6,"value"])/100
  cat("This is the observed percentage of current smokers in 2014 (m,f)\n")
  barplot(tab1,beside=T,names.arg=c("40","52","65+"),ylim=c(0,0.4),xlab="Age group",ylab="Prevalenc of smoking",col=c("black","grey"))
  title(cex.main=0.5,"Prevalence of current smoker by sex and age group (observed)")
  legend("topright",c("Male","Female"),fill=c("black","grey"))
  petoc()
  
  cat("Now I will run the model using the default smoking parameters")
  petoc()
  cat("running the model\n")
  
  #remove COPD stuff;
  input$exacerbation$p_death<-input$exacerbation$p_death*0;
  input$manual$PROP_COPD_DEATH_BY_SEX_AGE<-input$manual$PROP_COPD_DEATH_BY_SEX_AGE*0;
  #input$smoking$logit_p_smoker_0_betas<-input$smoking$logit_p_smoker_0_betas*0
  run(input=input)
  dataS<-Cget_all_events_matrix()
  dataS<-dataS[which(dataS[,'event']==events["event_start"]),]
  age_list<-list(a1=c(35,45),a2=c(45,65),a3=c(65,111))
  tab2<-tab1
  for(i in 0:1)
    for(j in 1:length(age_list))
      tab2[i+1,j]<-mean(dataS[which(dataS[,'sex']==i & dataS[,'age_at_creation']>age_list[[j]][1] & dataS[,'age_at_creation']<=age_list[[j]][2]),'smoking_status'])
  
  cat("This is the model generated bar plot")
  petoc()
  barplot(tab2,beside=T,names.arg=c("40","52","65+"),ylim=c(0,0.4),xlab="Age group",ylab="Prevalenc of smoking",col=c("black","grey"))
  title(cex.main=0.5,"Prevalence of current smoking at creation (simulated)")
  legend("topright",c("Male","Female"),fill=c("black","grey"))
  
  cat("This step is over; press enter to continue to step 2")
  petoc()
  
  cat("Now we will validate the model on smoking trends")
  petoc()
  
  cat("According to Table 2.1 of this report (see the extraected data in data folder): http://www.tobaccoreport.ca/2015/TobaccoUseinCanada_2015.pdf, the prevalence of current smoker is declining by around 3.8% per year\n")
  petoc()
  
  x<-Cget_output_ex()
  y<-x$n_current_smoker_by_ctime_sex/x$n_alive_by_ctime_sex
  plot(2015:2034,y[,1],type='l',ylim=c(0,0.25),col="black",xlab="Year",ylab="Prevalence of current smoking")
  lines(2015:2034,y[,2],type='l',col='grey')
  legend("topright",c("male","female"),lty=c(1,1),col=c("black","grey"))
  title(cex.main=0.5,"Annual prevalence of currrent smoking (simulated")
  z<-log(rowSums(y))
  cat("average decline in % of current_smoking rate is",1-exp(mean(c(z[-1],NaN)-z,na.rm=T)))
  petoc()
  
  message("This test is over; terminating the session")
  petoc()
  terminate_session()
}












sanity_COPD<-function()
{
  settings<-default_settings
  
  settings$record_mode<-record_mode["record_mode_agent"]
  #settings$agent_stack_size<-0
  settings$n_base_agents<-10000
  settings$event_stack_size<-settings$n_base_agents*10
  
  init_session(settings=settings)
  
  cat("Welcome! I am going to check EPIC's sanity with regard to modeling COPD\n "); petoc()
  
  cat("COPD incidence and prevalence parameters are as follows\n")
  
  cat("model_input$COPD$logit_p_COPD_betas_by_sex:\n")
  print(model_input$COPD$logit_p_COPD_betas_by_sex)
  petoc()
  cat("model_input$COPD$p_prevalent_COPD_stage:\n")
  print(model_input$COPD$p_prevalent_COPD_stage)
  petoc()
  cat("model_input$COPD$ln_h_COPD_betas_by_sex:\n")
  print(model_input$COPD$ln_h_COPD_betas_by_sex)
  petoc()
  
  cat("Now I am going to first turn off both prevalence and incidence parameters and run the model to see how many COPDs I get\n")
  petoc()
  model_input$COPD$logit_p_COPD_betas_by_sex<<-model_input$COPD$logit_p_COPD_betas_by_sex*0-100
  model_input$COPD$ln_h_COPD_betas_by_sex<<-model_input$COPD$ln_h_COPD_betas_by_sex*0-100
  run()
  cat("The model is reporting it has got that many COPDs:",Cget_output()$n_COPD," out of ",Cget_output()$n_agents,"agents.\n")
  dataS<-get_events_by_type(events["event_start"])  
  cat("The prevalence of COPD in Start event dump is:",mean(dataS[,'gold']>0),"\n")
  dataS<-get_events_by_type(events["event_end"])
  cat("The prevalence of COPD in End event dump is:",mean(dataS[,'gold']>0),"\n")
  petoc()
  
  cat("Now I am going to switch off incidence and create COPD patients only through prevalence (set at 0.5)")
  petoc()
  init_input()
  model_input$COPD$logit_p_COPD_betas_by_sex<<-model_input$COPD$logit_p_COPD_betas_by_sex*0
  model_input$COPD$ln_h_COPD_betas_by_sex<<-model_input$COPD$ln_h_COPD_betas_by_sex*0-100
  run()
  cat("The model is reporting it has got that many COPDs:",Cget_output()$n_COPD," out of ",Cget_output()$n_agents,"agents.\n")
  dataS<-get_events_by_type(events["event_start"])  
  cat("The prevalence of COPD in Start event dump is:",mean(dataS[,'gold']>0),"\n")
  dataS<-get_events_by_type(events["event_end"])
  cat("The prevalence of COPD in End event dump is:",mean(dataS[,'gold']>0),"\n")
  petoc()
  
  cat("Now I am going to switch off prevalence and create COPD patients only through incidence (set at 1 per 10 PYs")
  petoc()
  init_input()
  model_input$COPD$logit_p_COPD_betas_by_sex<<-model_input$COPD$logit_p_COPD_betas_by_sex*0-100
  model_input$COPD$ln_h_COPD_betas_by_sex<<-model_input$COPD$ln_h_COPD_betas_by_sex*0
  model_input$COPD$ln_h_COPD_betas_by_sex[1,]<<-log(1/10);
  run()
  cat("The model is reporting it has got that many COPDs:",Cget_output()$n_COPD," out of ",Cget_output()$n_agents,"agents.\n")
  dataS<-get_events_by_type(events["event_start"])  
  cat("The prevalence of COPD in Start event dump is:",mean(dataS[,'gold']>0),"\n")
  dataS<-get_events_by_type(events["event_end"])
  cat("The prevalence of COPD in End event dump is:",mean(dataS[,'gold']>0),"\n")
  petoc()
  
  
  terminate_session()
}









validate_COPD<-function(incident_COPD_k=1)
{
  out<-list()
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_event"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-100000
  settings$event_stack_size<-settings$n_base_agents*50
  init_session(settings=settings)
  input<-model_input
  
  if(incident_COPD_k==0)
    input$COPD$ln_h_COPD_betas_by_sex<-input$COPD$ln_h_COPD_betas_by_sex*0-100 else
      input$COPD$ln_h_COPD_betas_by_sex[1,]<-model_input$COPD$ln_h_COPD_betas_by_sex[1,]+log(incident_COPD_k)
  
  cat("working...\n")
  run(input=input)
  op<-Cget_output()
  opx<-Cget_output_ex()
  data<-as.data.frame(Cget_all_events_matrix())
  dataS<-data[which(data[,'event']==events["event_start"]),]
  dataE<-data[which(data[,'event']==events["event_end"]),]
  
  out$p_copd_at_creation<-mean(dataS[,'gold']>0)
  
  new_COPDs<-which(dataS[which(dataE[,'gold']>0),'gold']==0)
  
  out$inc_copd<-sum(opx$n_inc_COPD_by_ctime_age)/opx$cumul_non_COPD_time
  out$inc_copd_by_sex<-sum(opx$n_inc_COPD_by_ctime_age)/opx$cumul_non_COPD_time
  
  x<-sqldf("SELECT sex, SUM(gold>0) AS n_copd, COUNT(*) AS n FROM dataS GROUP BY sex")
  out$p_copd_at_creation_by_sex<-x[,'n_copd']/x[,'n']
  
  
  
  age_cats<-c(40,50,60,70,80,111)
  dataS[,'age_cat']<-as.numeric(cut(dataS[,'age_at_creation']+dataS[,'local_time'],age_cats,include.lowest = TRUE))
  x<-sqldf("SELECT age_cat, SUM(gold>0) AS n_copd, COUNT(*) AS n FROM dataS GROUP BY age_cat")
  temp<-x[,'n_copd']/x[,'n']
  names(temp)<-paste(age_cats[-length(age_cats)],age_cats[-1],sep="-")
  out$p_copd_at_creation_by_age<-temp
  
  
  py_cats<-c(0,25,50,75,Inf)
  dataS[,'py_cat']<-as.numeric(cut(dataS[,'pack_years'],py_cats,include.lowest = TRUE))
  x<-sqldf("SELECT py_cat, SUM(gold>0) AS n_copd, COUNT(*) AS n FROM dataS GROUP BY py_cat")
  temp<-x[,'n_copd']/x[,'n']
  names(temp)<-paste(py_cats[-length(py_cats)],py_cats[-1],sep="-")
  out$p_copd_at_creation_by_pack_years<-temp
  
  
  dataF<-data[which(data[,'event']==events["event_fixed"]),]
  dataF[,'age']<-dataF[,'local_time']+dataF[,'age_at_creation']
  dataF[,'copd']<-(dataF[,'gold']>0)*1
  dataF[,'gold2p']<-(dataF[,'gold']>1)*1
  dataF[,'gold3p']<-(dataF[,'gold']>2)*1
  dataF[,'year']<-dataF[,'local_time']+dataF[,'time_at_creation']
  
  res<-glm(data=dataF[which(dataF[,'sex']==0),],formula=copd~age+pack_years+year,family=binomial(link=logit))
  out$calib_prev_copd_reg_coeffs_male<-coefficients(res)
  res<-glm(data=dataF[which(dataF[,'sex']==1),],formula=copd~age+pack_years+year,family=binomial(link=logit))
  out$calib_prev_copd_reg_coeffs_female<-coefficients(res)
  
  res<-glm(data=dataF[which(dataF[,'sex']==0),],formula=gold2p~age+pack_years+year,family=binomial(link=logit))
  out$calib_prev_gold2p_reg_coeffs_male<-coefficients(res)
  res<-glm(data=dataF[which(dataF[,'sex']==1),],formula=gold2p~age+pack_years+year,family=binomial(link=logit))
  out$calib_prev_gold2p_reg_coeffs_female<-coefficients(res)
  
  res<-glm(data=dataF[which(dataF[,'sex']==0),],formula=gold3p~age+pack_years+year,family=binomial(link=logit))
  out$calib_prev_gold3p_reg_coeffs_male<-coefficients(res)
  res<-glm(data=dataF[which(dataF[,'sex']==1),],formula=gold3p~age+pack_years+year,family=binomial(link=logit))
  out$calib_prev_gold3p_reg_coeffs_female<-coefficients(res)
  
  terminate_session()
  
  return(out)
}

















validate_mortality<-function(n_sim=10^7,bgd=1,bgd_h=1,manual=1,exacerbation=1,comorbidity=1)
{
  cat("Hello from EPIC! I am going to test mortality rate and how it is affected by input parameters\n")
  petoc()
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-n_sim
  settings$event_stack_size<-0
  init_session(settings=settings)
  
  input<-model_input
  input$agent$l_inc_betas[1,]<--100 #No incidence (Life table is only valid for baseline)
  input$global_parameters$time_horizon<-1
  
  input$agent$p_bgd_by_sex<-input$agent$p_bgd_by_sex*bgd
  
  input$agent$ln_h_bgd_betas<-input$agent$ln_h_bgd_betas*bgd_h
  
  input$manual$explicit_mortality_by_age_sex<-input$manual$explicit_mortality_by_age_sex*manual
  
  input$exacerbation$p_death<-input$exacerbation$p_death*exacerbation
  
  if(comorbidity==0)
  {
    input$comorbidity$p_mi_death<-0
    input$comorbidity$p_stroke_death<-0
    input$agent$ln_h_bgd_betas[,c("b_mi","n_mi","b_stroke","n_stroke","hf")]<-0
  }
  
  cat("working...\n")
  res<-run(input=input)    
  
  cat("Mortality rate was",Cget_output()$n_death/Cget_output()$cumul_time,"\n")
  
  if(Cget_output()$n_death>0)
  {
    ratio<-(Cget_output_ex()$n_death_by_age_sex[41:111,]/Cget_output_ex()$sum_time_by_age_sex[41:111,])/model_input$agent$p_bgd_by_sex[41:111,]
    plot(40:110,ratio[,1],type='l',col='blue',xlab="age",ylab="Ratio")
    legend("topright",c("male","female"),lty=c(1,1),col=c("blue","red"))
    lines(40:110,ratio[,2],type='l',col='red')
    title(cex.main=0.5,"Ratio of simulated to expected (life table) mortality, by sex and age")
    
    difference<-(Cget_output_ex()$n_death_by_age_sex[41:111,]/Cget_output_ex()$sum_time_by_age_sex[41:111,])-model_input$agent$p_bgd_by_sex[41:111,]
    plot(40:110,difference[,1],type='l',col='blue',xlab="age",ylab="Difference")
    legend("topright",c("male","female"),lty=c(1,1),col=c("blue","red"))
    lines(40:110,difference[,2],type='l',col='red')
    title(cex.main=0.5,"Difference between simulated and expected (life table) mortality, by sex and age")
    
    return(list(ratio=ratio,difference=difference))
  }
  else message("No death occured.\n")
}







validate_comorbidity<-function(n_sim=100000)
{
  cat("Hello from EPIC! I am going to validate comorbidities for ya\n")
  petoc()
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-n_sim
  settings$event_stack_size<-0
  init_session(settings=settings)
  
  input<-model_input
  
  res<-run(input=input)
  if(res<0) stop("Execution stopped.\n")
  
  output<-Cget_output()
  output_ex<-Cget_output_ex()
  
  cat("The prevalence of having MI at baseline was ",(output_ex$n_mi-output_ex$n_incident_mi)/output$n_agent,"\n")
  cat("The incidence of MI during follow-up was ",output_ex$n_incident_mi/output$cumul_time,"/PY\n")
  cat("The prevalence of having stroke at baseline was ",(output_ex$n_stroke-output_ex$n_incident_stroke)/output$n_agent,"\n")
  cat("The incidence of stroke during follow-up was ",output_ex$n_incident_stroke/output$cumul_time,"/PY\n")
  cat("The prevalence of having hf at baseline was ",(output_ex$n_stroke-output_ex$n_hf)/output$n_agent,"\n")
  cat("The incidence of hf during follow-up was ",output_ex$n_incident_hf/output$cumul_time,"/PY\n")
  terminate_session()
  
  settings$record_mode<-record_mode["record_mode_some_event"]
  settings$events_to_record<-events[c("event_start","event_mi","event_stroke","event_hf","event_end")]
  settings$n_base_agents<-100000
  settings$event_stack_size<-settings$n_base_agents*1.6*10
  init_session(settings=settings)
  
  input<-model_input  
  
  if(run(input=input)<0) stop("Execution stopped.\n")
  output<-Cget_output()
  output_ex<-Cget_output_ex()
  
  #mi_events<-get_events_by_type(events['event_mi'])
  #stroke_events<-get_events_by_type(events['event_stroke'])
  #hf_events<-get_events_by_type(events['event_hf'])
  #end_events<-get_events_by_type(events['event_end'])
  
  plot(output_ex$n_mi_by_age_sex[41:100,1]/output_ex$n_alive_by_age_sex[41:100,1],type='l',col='red')
  lines(output_ex$n_mi_by_age_sex[41:100,2]/output_ex$n_alive_by_age_sex[41:100,2],type='l',col='blue')
  title(cex.main=0.5,"Incidence of MI by age and sex")
  
  plot(output_ex$n_stroke_by_age_sex[,1]/output_ex$n_alive_by_age_sex[,1],type='l',col='red')
  lines(output_ex$n_stroke_by_age_sex[,2]/output_ex$n_alive_by_age_sex[,2],type='l',col='blue')
  title(cex.main=0.5,"Incidence of Stroke by age and sex")
  
  plot(output_ex$n_hf_by_age_sex[,1]/output_ex$n_alive_by_age_sex[,1],type='l',col='red')
  lines(output_ex$n_hf_by_age_sex[,2]/output_ex$n_alive_by_age_sex[,2],type='l',col='blue')
  title(cex.main=0.5,"Incidence of HF by age and sex")
  
  output_ex$n_mi_by_age_sex[41:111,]/output_ex$n_alive_by_age_sex[41:111,]
}





validate_lung_function<-function()
{
  cat("This function examines FEV1 values")
  petoc()
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_some_event"]
  settings$events_to_record<-events[c("event_start","event_COPD","event_fixed")]
  settings$agent_stack_size<-0
  settings$n_base_agents<-50000
  settings$event_stack_size<-settings$n_base_agents*100
  
  init_session(settings=settings)
  
  input<-model_input
  input$global_parameters$discount_qaly<-0
  
  run(input=input)
  
  x<-as.data.frame(Cget_all_events_matrix())
  
  COPD_events<-which(x[,'event']==events["event_COPD"])
  start_events<-which(x[,'event']==events["event_start"])
  
  out_FEV1_prev<-sqldf(paste("SELECT gold, AVG(FEV1) AS 'Mean', STDEV(FEV1) AS 'SD' FROM x WHERE event=",events["event_start"]," GROUP BY gold"))
  out_FEV1_inc<-sqldf(paste("SELECT gold, AVG(FEV1) AS 'Mean', STDEV(FEV1) AS 'SD' FROM x WHERE event=",events["event_COPD"]," GROUP BY gold"))
  
  out_gold_prev<-sqldf(paste("SELECT gold, COUNT(*) AS N FROM x WHERE event=",events["event_start"]," GROUP BY gold"))
  out_gold_prev[,'Percent']<-round(out_gold_prev[,'N']/sum(out_gold_prev[,'N']),3)
  out_gold_inc<-sqldf(paste("SELECT gold, COUNT(*) AS N FROM x WHERE event=",events["event_COPD"]," GROUP BY gold"))
  out_gold_inc[,'Percent']<-round(out_gold_inc[,'N']/sum(out_gold_inc[,'N']),3)
  
  COPD_ids<-x[COPD_events,'id']
  
  for(i in 1:100)
  {
    y<-which(x[,'id']==COPD_ids[i] & x[,'gold']>0)
    if(i==1)
      plot(x[y,'local_time'],x[y,'FEV1'],type='l',xlim=c(0,20),ylim=c(0,5),xlab="local time",ylab="FEV1") else 
        lines(x[y,'local_time'],x[y,'FEV1'],type='l') ;
  }
  title(cex.main=0.5,"Trajectories of FEV1 in 100 individuals")
  
  return(list(FEV1_prev=out_FEV1_prev,FEV1_inc=out_FEV1_inc,gold_prev=out_gold_prev,gold_inc=out_gold_inc))
}








