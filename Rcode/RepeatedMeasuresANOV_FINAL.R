# K. Suvada
# 2022- 2023

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
# Another Example May 2023 - Repeated Measures ANOVA

#Loading in R Packages
library(tidyverse)
library(ggpubr)
library(rstatix)


#ARGUMENTS FOR 'anova_test' :

#data: data frame
#dv: (numeric) the dependent (or outcome) variable name.
#wid: variable name specifying the case/sample identifier.
#within: within-subjects factor or grouping variable

# Way to Extract ANOVA summary 

data("selfesteem2", package = "datarium")

# Gather the columns t1, t2 and t3 into long format.
# Convert id and time into factor variables
selfesteem2b <- selfesteem2 %>%
  
  gather(key = "time", value = "score", t1, t2, t3) %>%
  
  
  convert_as_factor(id, time) # Factor is anything with specific values 

res.aov <- anova_test(
  data = selfesteem2b, dv = score, wid = id,
  within = c(treatment, time)
)
get_anova_table(res.aov) # THIS LINE WORKS AND YIELDS SUMMARY OF ANOVA



################## KACEY'S DATA BELOW #########################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################



# MAY 2023 - 2 Way Repeated Measures ANOVA 

#Loading in R Packages
library(tidyverse)
library(ggpubr)
library(rstatix)

# Load in EXCEL Data Matrix in side window 

# This gives you the Data in a tibble form


#ARGUMENTS FOR 'anova_test' :

#data: data frame
#dv: (numeric) the dependent (or outcome) variable name.
#wid: variable name specifying the case/sample identifier.
#within: within-subjects factor or grouping variable

#Formatting Data and Converting to Tibble
AllData_Stroke_Paretic_R<-data.frame(AllData_Stroke_Paretic_R_TrialCorrected)  

AllData_Stroke_Paretic_R<- as_tibble(AllData_Stroke_Paretic_R_TrialCorrected) #%>% 

convert_as_factor(ID,Restraint,Loading) # Factor is anything with specific values 


# 3 Way Repeated Measures ANOVA ******* WORKS!!!****** MAY 2023*********
res.aov <- anova_test(
  data = AllData_Stroke_Paretic_R, dv = RDLL, wid = ID,
  within = c(Loading, Restraint, Trial)
)
get_anova_table(res.aov)


################################################################################

# 2 Way Repeated Measures ANOVA ***** USE THIS WORKS*** MAY 2023!!!!!!!!!!!! FINALL VERSION! 

#Loading in R Packages
library(tidyverse)
library(ggpubr)
library(rstatix)




############# RUN BELOW FOR PARETIC LIMB####################### FINAL MAY 2023

# For Paretic
AllData_Stroke_Paretic_R_AVGs$Restraint = as.factor(AllData_Stroke_Paretic_R_AVGs$Restraint)
AllData_Stroke_Paretic_R_AVGs$Loading = as.factor(AllData_Stroke_Paretic_R_AVGs$Loading)
AllData_Stroke_Paretic_R_AVGs$ID = as.factor(AllData_Stroke_Paretic_R_AVGs$ID)


res.aov <- anova_test(
  data = AllData_Stroke_Paretic_R_AVGs, dv = RDLL, wid = ID,
  within = c(Restraint,Loading)
)

get_anova_table(res.aov) # THIS LINE WORKS AND YIELDS SUMMARY OF ANOVA


# POST HOC TESTING FOR 2 WAY REPEATED MEASURES ANOVA

# Effect of Restraint at each Loading Level
one.way <- AllData_Stroke_Paretic_R_AVGs %>%
  group_by(Loading) %>%
  anova_test(dv = RDLL, wid = ID, within = Restraint) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")

#Displays the effect of trunk restraint at each Limb Loading level
one.way 

############# RUN BELOW FOR NON-PARETIC LIMB####################### FINAL MAY 2023
# For Non-Paretic
AllDataNonParetic_R_AVGs$Restraint = as.factor(AllDataNonParetic_R_AVGs$Restraint)
AllDataNonParetic_R_AVGs$Loading = as.factor(AllDataNonParetic_R_AVGs$Loading)
AllDataNonParetic_R_AVGs$ID = as.factor(AllDataNonParetic_R_AVGs$ID)

res.aov <- anova_test(
  data = AllDataNonParetic_R_AVGs, dv = RDLL, wid = ID,
  within = c(Restraint,Loading)
)

get_anova_table(res.aov) # THIS LINE WORKS AND YIELDS SUMMARY OF ANOVA


# POST HOC TESTING FOR 2 WAY REPEATED MEASURES ANOVA

# Effect of Restraint at each Loading Level
one.way <- AllDataNonParetic_R_AVGs %>%
  group_by(Loading) %>%
  anova_test(dv = RDLL, wid = ID, within = Restraint) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")

#Displays the effect of trunk restraint at each Limb Loading level
one.way 


############# RUN BELOW FOR CONTROLS####################### FINAL MAY 2023

# For Controls
AllData_Controls_R_AVGs$Restraint = as.factor(AllData_Controls_R_AVGs$Restraint)
AllData_Controls_R_AVGs$Loading = as.factor(AllData_Controls_R_AVGs$Loading)
AllData_Controls_R_AVGs$ID = as.factor(AllData_Controls_R_AVGs$ID)

res.aov <- anova_test(
  data = AllData_Controls_R_AVGs, dv = RDLL, wid = ID,
  within = c(Restraint,Loading)
)

get_anova_table(res.aov) # THIS LINE WORKS AND YIELDS SUMMARY OF ANOVA


# POST HOC TESTING FOR 2 WAY REPEATED MEASURES ANOVA

# Effect of Restraint at each Loading Level
one.way <- AllDataNonParetic_R_AVGs %>%
  group_by(Loading) %>%
  anova_test(dv = RDLL, wid = ID, within = Restraint) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")

#Displays the effect of trunk restraint at each Limb Loading level
one.way 


################################################################################
################################################################################
###############################################################################



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
Data_Paretic<-data.frame(AllData_Stroke_Paretic_R)


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

# Without Interaction Term
# modelRD <- aov(RDLL~factor(Trunk.Restraint)+factor(Limb.Loading), data = Data_Paretic) 

# With Interaction Term 
modelRD <- aov(RDLL~factor(Trunk.Restraint)*factor(Limb.Loading), data = Data_Paretic) 

modelRD2 <- aov(X.Reaching.Distance.~factor(Trunk.Restraint)+factor(Limb.Loading), data = Data_Paretic)


# or alternatively adding participant as a repeated measure: repeated measure is same measure under different conditions
modelRD <- aov(RDLL~factor(Trunk.Restraint)+factor(Limb.Loading)+Error(factor(X.Partid.)), data = Data_Paretic)

#May 2023
modelRD_2023 <- aov(RDLL~factor(Restraint)+factor(Loading)+Error(factor(ID)), data = Data_Paretic)


# or alternatively adding Limb Loading  as a repeated measure: repeated measure is same measure under different conditions
modelRD <- aov(RDLL~factor(Trunk.Restraint)+factor(Limb.Loading)+Error(factor(Limb.Loading)), data = Data_Paretic)


#Summarizing Data 
summary(modelRD)

summary(modelRD2)

summary(modelRD_2023)


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


modelRD_2023 <- aov(RDLL~factor(Restraint)+factor(Loading)+Error(factor(ID)), data = AllData_Controls_R_AVGs)

summary(modelRD_2023)
