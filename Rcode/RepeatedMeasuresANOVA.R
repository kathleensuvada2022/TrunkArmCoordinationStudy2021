# K. Suvada
# August 2022

#Repeated Measures ANOVA tutorial 


#Original Source:https://www.statology.org/repeated-measures-anova-in-r/


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
model <- aov(response~factor(drug)+Error(factor(patient)), data = df)

#example of 2 factor no repeated measures aov(len ~ supp + dose, data = my_data) want to see if len depends on supp and dose


# Summary 
summary(model)

##############################################################################

# For Kacey's Data August 2022

#Loading Library and Importing Data
library(readxl)

AllData_Stroke_Paretic <- read_excel("Desktop/Stroke/Paretic/AllData_Stroke_Paretic.xlsx")

#Viewing Data 
View(AllData_Stroke_Paretic)
 
Data_Paretic<-data.frame(AllData_Stroke_Paretic)


# BELOW ACTUALLY RAN!!!!!
# THe effect of Condition on Reaching Distance where the repeated measure is the pariticipant
model1 <- aov(NormArmlength_RD.~factor(X.Condition.)+Error(factor(X.Partid.)), data = Data_Paretic)











