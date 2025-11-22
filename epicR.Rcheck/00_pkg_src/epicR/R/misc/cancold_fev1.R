cancold_data<-read.csv("C:/Users/Mohsen/main/DATA/2016/CanCOLD/Mohsen_substudy_addHeightWeight_19Feb2016.csv")
cancold_data[which(cancold_data[,'EverSmokeStop']==99),'EverSmokeStop']<-cancold_data[which(cancold_data[,'EverSmokeStop']==99),'age']

pack_years<-(cancold_data[,'EverSmokeStop']-cancold_data[,'EverSmokeAge'])*cancold_data[,'EverSmokeAvgDay']/20
cancold_data[,'pack_years']<-pack_years

cancold_data[,'Height']<-cancold_data[,'Height']/100
cancold_data[,'include']<-1
cancold_data[which(cancold_data[,'EverSmokeAvgDay']>=99),'include']<-0
cancold_data[which(cancold_data[,'MAXFEV1FVCP_POST']>70),'include']<-0 

cancold_data[which(cancold_data[,'EverSmoke']==2),'EverSmoke']<-0
cancold_data[which(cancold_data[,'EverSmoke']==0),'pack_years']<-0

reg_data<-cancold_data[which(cancold_data[,'include']==1 & cancold_data[,'Sex']==1),]
reg<-lm(data=reg_data,formula=MAXFEV1_POST~age+pack_years+Height)
summary(reg)


reg_data<-cancold_data[which(cancold_data[,'include']==1 & cancold_data[,'Sex']==2),]
reg<-lm(data=reg_data,formula=MAXFEV1_POST~age+pack_years+Height)
summary(reg)


#Incident COPD
cancold_data[,'include']<-1
cancold_data[which(cancold_data[,'EverSmokeAvgDay']>=99),'include']<-0

cancold_data[,'fev1_to_fvc']<-cancold_data[,'MAXFEV1FVCP_POST']/100

reg_data<-cancold_data[which(cancold_data[,'include']==1 & cancold_data[,'Sex']==1),]
reg<-lm(data=reg_data,formula=MAXFEV1_POST~age+pack_years+Height+fev1_to_fvc)
summary(reg)

reg_data<-cancold_data[which(cancold_data[,'include']==1 & cancold_data[,'Sex']==2),]
reg<-lm(data=reg_data,formula=MAXFEV1_POST~age+pack_years+Height+fev1_to_fvc)
summary(reg)
