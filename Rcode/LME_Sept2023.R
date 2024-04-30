# Kacey's Stats Models 2023-2024



#install.packages("lme4")  # Install the lme4 package

library( tidyverse )
library( glmmTMB )
# library( tictoc ) # not used
library( ggeffects )
library(Matrix) # Need to load in package matrix to load in LME4
library(ggplot2)
library(lme4)
library(rlang)
#library(simr) for power analysis
library(emmeans)
library(lmerTest)
library(sjPlot)

AllData_Stroke_Paretic = AllData_Stroke_Paretic_2024_FEB
# Paretic Limb- restraint, loading, as categorical variables 
AllData_Stroke_Paretic$Restraint = as.factor(AllData_Stroke_Paretic$Restraint)
AllData_Stroke_Paretic$Loading = as.factor(AllData_Stroke_Paretic$Loading)
AllData_Stroke_Paretic$ID = as.factor(AllData_Stroke_Paretic$ID)

# Non-Paretic Limb- restraint, loading, as categorical variables 
Non_Paretic_FEB2024$Restraint = as.factor(Non_Paretic_FEB2024$Restraint)
Non_Paretic_FEB2024$Loading = as.factor(Non_Paretic_FEB2024$Loading)
Non_Paretic_FEB2024$ID = as.factor(Non_Paretic_FEB2024$ID)

# For Controls-restraint, loading, as categorical variables 
AllData_Controls_Feb2024$Restraint = as.factor(AllData_Controls_Feb2024$Restraint)
AllData_Controls_Feb2024$Loading = as.factor(AllData_Controls_Feb2024$Loading)
AllData_Controls_Feb2024$ID = as.factor(AllData_Controls_Feb2024$ID)

# Both Limbs Stroke- restraint, loading,limb,ID categorical variables
AllData_Stroke$Restraint = as.factor(AllData_Stroke$Restraint)
AllData_Stroke$Loading_C = scale(AllData_Stroke$Loading, scale=FALSE) #centering the loading
AllData_Stroke$Loading_0 = as.factor(ifelse(AllData_Stroke$Loading ==0,1,0)) # anywhere where 0 put 0, otherwise put a 1. 
AllData_Stroke$Loading_25 = as.factor(ifelse(AllData_Stroke$Loading ==25,1,0))  
AllData_Stroke$Loading_50 = as.factor(ifelse(AllData_Stroke$Loading ==50,1,0))  
AllData_Stroke$ARM = as.factor(AllData_Stroke$ARM)
AllData_Stroke$ID = as.factor(AllData_Stroke$ID)

# April 2024 Stroke and Controls- restraint, loading,limb,ID categorical variables
AllData_2024$Restraint = as.factor(AllData_2024$Restraint)
AllData_2024$Loading_C = scale(AllData_2024$Loading, scale=FALSE) #centering the loading
AllData_2024$Loading_0 = as.factor(ifelse(AllData_2024$Loading ==0,1,0)) # anywhere where 0 put 0, otherwise put a 1. 
AllData_2024$Loading_25 = as.factor(ifelse(AllData_2024$Loading ==25,1,0))  
AllData_2024$Loading_50 = as.factor(ifelse(AllData_2024$Loading ==50,1,0))  
AllData_2024$ARM = as.factor(AllData_2024$ARM)
AllData_2024$ID = as.factor(AllData_2024$ID)




# Models

# model1 <- glmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, family = gaussian(link = "identity"))
#yielded error saying to call lmer bc it's within the Gaussian Family so don't need GLME
# Restricted Maximum Likelihood (REML), provides better estimates of the random effects' variance components
# Trial is nested within participant ID so don't list ID and Trial Separate - Tested the effect of trial as main effect and was a non significant effect


#Paretic Limb
# Beta Regression Model
AllData_Stroke_Paretic$RDLL2 = AllData_Stroke_Paretic$RDLL/100 # setting the values to be between 0 and 1
AllData_Stroke_Paretic$RDLL2 = ifelse(AllData_Stroke_Paretic$RDLL2 > 1, .99, AllData_Stroke_Paretic$RDLL2) # line to cap the data at 1
mod2Beta = glmmTMB(formula= RDLL2 ~ Loading * Restraint  +(1 | ID), data= AllData_Stroke_Paretic, family=beta_family(link = "logit")) #  modeling continuous responses bounded between 0 and 1
#mod2Beta = glmmTMB(formula= RDLL2 ~ Loading * Restraint  +(1 | ID), data= AllData_Stroke_Paretic, family=ordbeta(link = "logit"))
tab_model(mod2Beta, show.df = TRUE) # Paretic Limb

ano9vsummary(mod2Beta)
# Plotting 
plot(ggpredict(mod2Beta, terms = c("Loading"))) #VISUALIZING EFFECT OF LOADING ON RDLL2
plot(ggpredict(mod2Beta, terms = c("Restraint")))# VISUALIZING EFFECT OF RESTRAINT ON RDLL2

#LME
model2 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, REML = TRUE)


#Omitting Restraint to Test Effect of Restraint on RDLL
model3 <- lmer(RDLL ~ Loading +(1 | ID), data = AllData_Stroke_Paretic,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model2, model3)
tab_model(model2, show.df = TRUE) # Paretic Limb
plot(ggpredict(model2, terms = c("Restraint")))# VISUALIZING EFFECT OF RESTRAINT ON RDLL2


print(model2)

#Non-Paretic Limb 

#Beta Regression
Non_Paretic_FEB2024$RDLL2 = Non_Paretic_FEB2024$RDLL/100
Non_Paretic_FEB2024$RDLL2 = ifelse(Non_Paretic_FEB2024$RDLL2 > 1, .999, Non_Paretic_FEB2024$RDLL2)
mod3Beta = glmmTMB(formula= RDLL2 ~ Loading * Restraint  +(1 | ID), data= Non_Paretic_FEB2024, family=ordbeta(link = "logit"))
#mod3Beta = glmmTMB(formula= RDLL2 ~ Loading * Restraint  +(1 | ID), data= Non_Paretic_Edited_AUG2023, family=beta_family(link = "logit"))
tab_model(mod3Beta, show.df = TRUE) # Non-Paretic Limb
plot(ggpredict(mod3Beta, terms = c("Restraint")))# VISUALIZING EFFECT OF RESTRAINT ON RDLL2


#LME
model4 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = Non_Paretic_FEB2024,REML = TRUE)
plot(ggpredict(model4, terms = c("Loading"))) #VISUALIZING EFFECT OF LOADING ON RDLL2
plot(ggpredict(model4, terms = c("Restraint")))# VISUALIZING EFFECT OF RESTRAINT ON RDLL2

model5 <- lmer(RDLL ~ Loading +(1 | ID), data = Non_Paretic_FEB2024,REML = TRUE)

# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model4, model5)
tab_model(model4, show.df = TRUE) # Non-Paretic Limb


#Controls
model6 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Controls_Feb2024,REML = TRUE)
model7 <- lmer(RDLL ~ Loading +(1 | ID), data = AllData_Controls,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model6, model7)
tab_model(model6, show.df = TRUE) #Controls
plot(ggpredict(model6, terms = c("Loading"))) #VISUALIZING EFFECT OF LOADING ON RDLL2
plot(ggpredict(model6, terms = c("Restraint")))# VISUALIZING EFFECT OF RESTRAINT ON RDLL2

#Beta Regression
AllData_Controls_Feb2024$RDLL2 = AllData_Controls_Feb2024$RDLL/100
AllData_Controls_Feb2024$RDLL2 = ifelse(AllData_Controls_Feb2024$RDLL2 > 1, .999, AllData_Controls_Feb2024$RDLL2)
mod4Beta = glmmTMB(formula= RDLL2 ~ Loading * Restraint  +(1 | ID), data= AllData_Controls_Feb2024, family=ordbeta(link = "logit"))
#mod3Beta = glmmTMB(formula= RDLL2 ~ Loading * Restraint  +(1 | ID), data= Non_Paretic_Edited_AUG2023, family=beta_family(link = "logit"))
tab_model(mod4Beta, show.df = TRUE) #  Controls
plot(ggpredict(mod4Beta, terms = c("Restraint")))# VISUALIZING EFFECT OF RESTRAINT ON RDLL2




# Combined Stroke Paretic and Non-Paretic
AllData_Stroke$RDLL2 = AllData_Stroke$RDLL/100
AllData_Stroke$RDLL2 = ifelse(AllData_Stroke$RDLL2 > 1, 1, AllData_Stroke$RDLL2)

# Beta Regression October 2023
#m = glmmTMB(formula= RDLL2 ~ Loading * Restraint * ARM +(1 | ID), data= AllData_Stroke, family=beta_family(link = "logit"))
#m = glmmTMB(formula= RDLL2 ~ Loading * Restraint * ARM +(1 | ID), data= AllData_Stroke, family=ordbeta(link = "logit"))
m = glmmTMB(formula= RDLL2 ~ Loading_C * Restraint * ARM +(1 | ID), data= AllData_Stroke, family=ordbeta(link = "logit"))
#m = glmmTMB(formula= RDLL2 ~ Loading_B + ARM + Restraint +  Loading_B : ARM  + Restraint : ARM +(1 | ID), data= AllData_Stroke, family=ordbeta(link = "logit"))

# separating loading terms
#m_loading = glmmTMB(formula= RDLL2 ~ Loading_0+Loading_25+Loading_50+ARM+Restraint+
 #                     Loading_0:ARM+Loading_25:ARM+Loading_50:ARM+Restraint:ARM +(1 | ID),data= AllData_Stroke,family=ordbeta(link = "logit"))

#m_loading = glmmTMB(formula= RDLL2 ~ Loading_0+Loading_50+ARM+Restraint+
#                      Loading_0:ARM+Loading_50:ARM+Restraint:ARM +(1 | ID),data= AllData_Stroke,family=ordbeta(link = "logit"))

tab_model(m, show.df = TRUE)
summary(m)
# Plotting 
plot(ggpredict(m, terms = c("Loading_C", "ARM")))
plot(ggpredict(m, terms = c("Restraint", "ARM")))

# For including the limb for all stroke data  USE THIS MODEL SEPT 2023
model8 <- lmer(RDLL ~ Loading * Restraint * ARM +(1 | ID) + (1 | ID:Trial) , data = AllData_Stroke,REML = TRUE)


################################################################################
# All Data Stroke and Controls- April 2024
AllData_2024$RDLL2 = AllData_2024$RDLL/100
AllData_2024$RDLL2 = ifelse(AllData_2024$RDLL2 > 1, 1, AllData_2024$RDLL2)

ModFinal = glmmTMB(formula= RDLL2 ~ Loading_C * Restraint * ARM + (1 | ARM:Restraint) + (1 | ARM:Loading_C) + (1 | ID), data= AllData_2024, family=ordbeta(link = "logit"))

# Plotting Model Summaries and Effect of Loading and Restraint
tab_model(ModFinal, show.df = TRUE)
summary(ModFinal)
# Plotting 
plot(ggpredict(ModFinal, terms = c("Loading_C", "ARM")))
plot(ggpredict(ModFinal, terms = c("Restraint", "ARM")))

################################################################################


#Omitting Restraint to Test Effect of Restraint on RDLL
model9 <- lmer(RDLL ~ Loading * ARM +(1 | ID), data = AllData_Stroke,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model8, model9)
tab_model(model8, show.df = TRUE) #Controls
anova(model8)

#Running Model on Raw Reaching Distance
model10 <- lmer(ReachingDistance ~ Loading * ARM *Restraint +(1 | ID), data = AllData_Stroke,REML = TRUE)


#outputs the estimates for your predictors
tab_model(model5, show.df = TRUE) # Non Paretic Limb
tab_model(model2, show.df = TRUE) # Paretic Limb
tab_model(model6, show.df = TRUE) # Controls

tab_model(model8, show.df = TRUE) # All Stroke Limb
summary(model4, show.df = TRUE) # All Stroke Limb

tab_model(model10, show.df = TRUE) # All Stroke Limb




#if there's significance, you can do some pairwise comparisons
em = emmeans(model4, ~ Loading * ARM)
summary(em)
pairs(em)

# Effect of Restraint at each Loading Level
two.way <- AllData_Stroke 
anova_test(dv = RDLL, wid = ID, within = Restraint) 
get_anova_table() 
adjust_pvalue(method = "bonferroni")

#Displays the effect of trunk restraint at each Limb Loading level
one.way 



########################Checking For Normality#################################
###############################################################################

#note, for lme, your data doesn't have to be normal.
#However, your residuals DO have to have normal distribution 

# Want to see residuals randomly dispersed
plot(residuals(model2)) 
#plot(fitted(model3), residuals(model3))

#Want to appear that the residuals are a Normal Distrib
hist(residuals(model2))

# Create a QQ plot
qqnorm(residuals(model2))
qqline(residuals(model2))



########################Z Scoring Raw Reaching Distance#########################
################################################################################


# Testing Zscore Method on Raw Reaching Distance


#Centering and Scaling Raw Reaching Distance 
ZscoreRD = scale(AllData_Stroke_Paretic$ReachingDistance)

# Appending original stroke paretic dataframe with new zscored variable
AllData_Stroke_Paretic$ZscoreReachingDistance <- ZscoreRD 


# Running Original Model with Scaled and Zscored Raw Reaching Distance
model15 <- lmer(ZscoreRD ~ Loading *Restraint +(1 | ID), data = AllData_Stroke_Paretic,REML = TRUE)

#Model Omitting Restraint
model16 <- lmer(ZscoreRD ~ Loading +(1 | ID), data = AllData_Stroke_Paretic,REML = TRUE)
#Chisquared test to see if there is a difference between the models
anova(model16, model15)



tab_model(model15, show.df = TRUE) 

########################Z Scoring %LL Reaching Distance#########################
################################################################################


#Centering and Scaling %LL Reaching Distance 
ZscoreRDLL = scale(AllData_Stroke_Paretic$RDLL)

# Appending original stroke paretic dataframe with new zscored variable
AllData_Stroke_Paretic$ZscoreReachLimbLength <- ZscoreRDLL 


# Running Original Model with Scaled and Zscored Raw Reaching Distance
model17 <- lmer(ZscoreRDLL ~ Loading *Restraint +(1 | ID), data = AllData_Stroke_Paretic,REML = TRUE)

#Model Omitting Restraint
model18 <- lmer(ZscoreRDLL ~ Loading +(1 | ID), data = AllData_Stroke_Paretic,REML = TRUE)
#Chisquared test to see if there is a difference between the models
anova(model17, model18)



tab_model(model17, show.df = TRUE)


############Running Model with Combined Variable for Limb and Restraint########
################################################################################

# Both Limbs Stroke- restraint, loading,limb,ID categorical variables
AllData_Stroke$Restraint = as.factor(AllData_Stroke$Restraint)
AllData_Stroke$Loading = as.factor(AllData_Stroke$Loading)
AllData_Stroke$ARM = as.factor(AllData_Stroke$ARM)
AllData_Stroke$ID = as.factor(AllData_Stroke$ID)
AllData_Stroke$ArmRestraint = as.factor(AllData_Stroke$ArmRestraint)



# Running Original Model with Scaled and Zscored Raw Reaching Distance
model19 <- lmer(ReachingDistance ~ ArmRestraint +(1 | ID), data = AllData_Stroke,REML = TRUE)
contrasts(AllData_Stroke$ArmRestraint)
#Model Omitting Restraint
model20 <- lmer(ReachingDistance ~ Loading +(1 | ID), data = AllData_Stroke,REML = TRUE)
#Chisquared test to see if there is a difference between the models
anova(model19, model20)



tab_model(model19, show.df = TRUE)

