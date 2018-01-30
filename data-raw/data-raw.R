# Internal Data Documentation
# This document outlines how internal data were embedded within the package

CanSim.105.0501<-read.csv("./CanSim.105.0501.csv", header = T); #used for validation
CanSim.052.0005<-read.csv("./CanSim.052.0005.csv", header = T); #used for validation
devtools::use_data(CanSim.105.0501, CanSim.052.0005, internal = TRUE)
