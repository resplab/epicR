library(lme4)
library(sqldf)

lhs_data<-read.csv(file=paste(data_path,"/lhs.csv",sep=""))

x<-sqldf("SELECT id, MIN(year) AS min_year FROM lhs_data GROUP BY id")
y<-sqldf("SELECT a.* FROM lhs_data a INNER JOIN x ON a.id=x.id AND a.year=x.min_year")
y[,'FEV1']<-y['FEV1_0']
y[,'year']<-0
z<-sqldf("SELECT * FROM y UNION SELECT * FROM lhs_data ORDER BY id, year")
lhs_data<-z

lmer(FEV1~age_baseline+gender+age_baseline*year+gender*year+(1|id)+(year|id),data=lhs_data)

