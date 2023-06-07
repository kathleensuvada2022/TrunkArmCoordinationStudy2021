# K. Suvada
# August 2022

# ANOVA tutorial 
#Original Source:https://www.statology.org/repeated-measures-anova-in-r/
# Info on AOV function https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/aov

library(xlsx)
library(rstatix)
library(reshape)
library(tidyverse)
library(dplyr)
library(ggpubr)
library(plyr)
library(datarium)

#create data
df <- data.frame(patient=rep(1:5, each=4),
                 drug=rep(1:4, times=5),
                 response=c(30, 28, 16, 34,
                            14, 18, 10, 22,
                            24, 20, 18, 30,
                            38, 34, 20, 44,
                            26, 28, 14, 30))

# View data 

df

#Perform repeated measures ANOVA (in this case repeated measure is patient)

# independent variable is drug 
# repeated measure is patient 
# Measuring  response.
model_example <- aov(response~factor(drug)+Error(factor(patient)), data = df)

#example of 2 factor no repeated measures aov(len ~ supp + dose, data = my_data) want to see if len depends on supp and dose


# Summary 
summary(model_example)

###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################

# For Kacey's Data 

# August 2022

#Loading Library and Importing Data
library(readxl)

#AllData_Stroke_Paretic <- read_excel("Desktop/Stroke/Paretic/AllData_Stroke_Paretic.xlsx")

AllData_Stroke_Paretic <- read_excel("Desktop/Stroke/Paretic/AllData_Stroke_Paretic.xlsx")
#Viewing Data 
View(AllData_Stroke_Paretic)
 


# BELOW ACTUALLY RAN!!!!! WORKS! 


################FOR PARETIC LIMB ################################################
# Need to Convert to Data Frame before running through ANOVA
Data_Paretic<-data.frame(AllData_Stroke_Paretic)


# The effect of limb loading Limb.Load and trunk restraint Trunk.Restrained (1 is restrained) on Trunk Displacement TR(normalized to limb length) 
# Anything in the 'Error' is the repeated measure. So for most examples, it's the participant for me do loading and trunk restraint. 
# 'data' is the data frame you want R to look

# 2 way (Limb Loading and Trunk Restraint) ANOVA where looking at Trunk Displacement Normalized to Limb Length
modelTD <- aov(X.Trunk.Disp.~factor(Trunk.Restraint)+factor(Limb.Loading), data = Data_Paretic)

# or alternatively adding participant as a repeated measure: repeated measure is same measure under different conditions
modelTD <- aov(Trunk.Restraint~factor(Trunk.Restraint)+factor(Limb.Loading)+Error(factor(X.Partid.)), data = Data_Paretic)


#Summarizing Data 
summary(modelTD)

# 2 way (Limb Loading and Trunk Restraint) ANOVA where looking at Reaching Distance Normalized to Limb Length
modelRD <- aov(RDLL~factor(Trunk.Restraint)+factor(Limb.Loading), data = Data_Paretic)

modelRD2 <- aov(X.Reaching.Distance.~factor(Trunk.Restraint)+factor(Limb.Loading), data = Data_Paretic)


# or alternatively adding participant as a repeated measure: repeated measure is same measure under different conditions
modelRD <- aov(RDLL~factor(Trunk.Restraint)+factor(Limb.Loading)+Error(factor(X.Partid.)), data = Data_Paretic)

# or alternatively adding Limb Loading  as a repeated measure: repeated measure is same measure under different conditions
modelRD <- aov(RDLL~factor(Trunk.Restraint)+factor(Limb.Loading)+Error(factor(Limb.Loading)), data = Data_Paretic)


#Summarizing Data 
summary(modelRD)

summary(modelRD2)
################FOR NON PARETIC LIMB ################################################

# Need to Convert to Data Frame before running through ANOVA
Data_NonParetic<-data.frame(AllDataNonParetic)


# The effect of limb loading Limb.Load and trunk restraint Trunk.Restrained (1 is restrained) on Trunk Displacement TR(normalized to limb length) 
# Anything in the 'Error' is the repeated measure. So for most examples, it's the participant for me do loading and trunk restraint. 
# 'data' is the data frame you want R to look

# 2 way (Limb Loading and Trunk Restraint) ANOVA where looking at Trunk Displacement Normalized to Limb Length
modelTD <- aov(X.Trunk.Disp.~factor(Trunk.Restrained)+factor(Limb.Loading), data = Data_NonParetic)

# or alternatively adding participant as a repeated measure: repeated measure is same measure under different conditions
#modelTD <- aov(NormArmlength_TR~factor(Trunk.Restrained)+factor(Limb.Loading)+Error(factor(Partid)), data = Data_NonParetic)


#Summarizing Data 
summary(modelTD)

# 2 way (Limb Loading and Trunk Restraint) ANOVA where looking at Reaching Distance Normalized to Limb Length
modelRD <- aov(X.Reaching.Distance.~factor(Trunk.Restrained)+factor(Limb.Loading), data = Data_NonParetic)

# or alternatively adding participant as a repeated measure: repeated measure is same measure under different conditions
#modelRD <- aov(NormArmlength_RD~factor(Trunk.Restrained)+factor(Limb.Loading)+Error(factor(Partid)), data = Data_NonParetic)

# or alternatively adding Limb Loading  as a repeated measure: repeated measure is same measure under different conditions
#modelRD <- aov(NormArmlength_RD~factor(Trunk.Restrained)+factor(Limb.Loading)+Error(factor(Limb.Load)), data = Data_NonParetic)


#Summarizing Data 
summary(modelRD)


################FOR Controls ################################################
Data_Controls<-data.frame(AllData_Controls)

# 2 way (Limb Loading and Trunk Restraint) ANOVA where looking at Trunk Displacement Normalized to Limb Length
modelTD <- aov(TrunkDisp~factor(TrunkRestrained)+factor(Loading), data = Data_Controls)

summary(modelTD)

# 2 way (Limb Loading and Trunk Restraint) ANOVA where looking at Reaching Distance Normalized to Limb Length
modelRD <- aov(Reaching.Distance~factor(TrunkRestrained)+factor(Loading), data = Data_Controls)

summary(modelRD)
