calib_params<-list(
  COPD=list(prevalence=0.193)
  
)




calibrate_explicit_mortality<-function(n_sim=10^8)
{
  cat("Difference between life table and observed mortality\n")
  cat("You need to put the returned values into model_input$manual$explicit_mortality_by_age_sex\n")
  cat(paste("n_sim=",n_sim,"\n"))
  
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-n_sim
  settings$event_stack_size<-0
  init_session(settings=settings)
  
  input<-model_input
  input$agent$l_inc_betas[1,]<--100 #No incidence (Life table is only valid for baseline)
  input$global_parameters$time_horizon<-1
  input$manual$explicit_mortality_by_age_sex<-input$manual$explicit_mortality_by_age_sex*0
  
  cat("working...\n")
  res<-run(input=input)    
  
  cat("Mortality rate was",Cget_output()$n_death/Cget_output()$cumul_time,"\n")
  
  difference<-model_input$agent$p_bgd_by_sex[41:111,]-(Cget_output_ex()$n_death_by_age_sex[41:111,]/Cget_output_ex()$sum_time_by_age_sex[41:111,])
  plot(40:110,difference[,1],type='l',col='blue',xlab="age",ylab="Difference")
  legend("topright",c("male","female"),lty=c(1,1),col=c("blue","red"))
  lines(40:110,difference[,2],type='l',col='red')
  title(cex.main=0.5,"Difference between expected (life table) to simulated mortality, by sex and age")
  
  difference[which(is.nan(difference))]<-0
  difference[which(abs(difference)==Inf)]<-0
  difference<-rbind(matrix(rep(0,80),ncol=2),difference)
  
  terminate_session()
  return(difference)
}




calibrate_mi_incidence<-function(simple=F)
{
  settings<-default_settings
  settings$record_mode<-record_mode["record_mode_none"]
  settings$n_base_agents<-100000
  settings$event_stack_size<-0
  init_session(settings=settings)
  
  observed<-c(age40=0.001,age50=0.002,age60=0.004,age70=0.007,age80=0.011)
  
  betas<-c(beta0=-7,beta_age=0.02,beta_age2=0.00015)
  
  ages<-c(40,50,60,70,80)
  
  equation<-function(betas,simple=T)
  {
    if(simple)  return(betas[1]+betas[2]*ages+betas[3]*ages^2);
    cat(betas,"\n")
    #betas[3]<-betas[3]/100
    model_input$comorbidity$ln_h_mi_betas_by_sex[1:3,1]<<-betas
    run()
    temp<-Cget_output_ex()
    res<-(temp$n_mi_by_age_sex[,1]/temp$n_alive_by_age_sex[,1])[c(41,51,61,71,81)]
    cat(res,"\n")
    return(res)
  }
  
  penalty<-function(x){return(sqrt(sum((log(observed)-equation(x))^2)));}
  
  res<-optim(par=betas,fn=penalty,method="SANN")
  
  plot(exp(equation(res$par)),type='l')
  lines(observed,type='o')
}









calibrate_smoking<-function()
{
  cat("I will try to estimate the value of input parameters with simulated data")
  petoc()
  
  CanSim.105.0501<-read.csv(paste(data_path,"/CanSim.105.0501.csv",sep=""),header=T)
  tab1<-rbind(CanSim.105.0501[1:3,"value"],CanSim.105.0501[4:6,"value"])/100
  barplot(tab1,beside=T,names.arg=c("40","52","65+"))
  
  settings$record_mode<-record_mode["record_mode_agent"]
  settings$agent_stack_size<-0
  settings$n_base_agents<-100000
  settings$event_stack_size<-settings$n_base_agents*2+10
  init_session()
  model_input$agent$l_inc_betas[1]<--1000
  
  model_input$smoking$logit_p_smoker_0_betas<-model_input$smoking$logit_p_smoker_0_betas*0
  run(1)
  data0<-get_events_by_type(events["event_start"])
  
  sex=data0[,'sex']
  age=data0[,'age_at_creation']
  age2=age^2
  ageCat<-3-(age<45)*1-(age<65)*1
  mydata<-as.data.frame(cbind(sex,age,age2,smoking_status=(runif(dim(data0)[1])<tab1[cbind(1+sex,ageCat)])*1,sex_age=sex*age,sex_age2=sex*age*age,real_p=tab1[cbind(1+sex,ageCat)]))
  reg<-glm(smoking_status~sex+age+age2+sex_age+sex_age2, data = mydata, family = "binomial")
  cat("regression coefficients are\n");print(coefficients(reg))  
  cat("I will update the input and run this again") 
  petoc()
  
  model_input$smoking$logit_p_smoker_0_betas<-t(as.matrix(c(coefficients(reg),year=0)));
  run(1)
  data0<-get_events_by_type(0)
  
  age_list<-list(a1=c(35,45),a2=c(45,65),a3=c(65,111))
  tab2<-tab1
  for(i in 0:1)
    for(j in 1:length(age_list))
      tab2[i+1,j]<-mean(data0[which(data0[,'sex']==i & data0[,'age_at_creation']>age_list[[j]][1] & data0[,'age_at_creation']<=age_list[[j]][2]),'smoking_status'])
  
  cat("I will now show you the model generated bar plor")
  petoc()
  barplot(tab2,beside=T,names.arg=c("40","52","65+"))
  
  petoc()
  cat("For your consideration:\n")
  paste(colnames(model_input$smoking$logit_p_smoker_0_betas),model_input$smoking$logit_p_smoker_0_betas,sep="=",collapse=",")
  message("This task is over.")
  petoc()
}


