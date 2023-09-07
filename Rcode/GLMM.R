## Generalized Linear Mixed Effects Models in R - August 2023

# Starting with a OLS Regression Model: Restraint and Loading on Reaching Distance
OLS_RD <- lm(RDLL ~ Restraint + Loading, data = AllData_Stroke_Paretic_R_AVGs_Updated)
print(OLS_RD)

#Line Below does the same thing as line 4
lm(formula = RDLL ~ Restraint + Loading, data = AllData_Stroke_Paretic_R_AVGs_Updated)

# Generalized Linear Model: Uses a model of fit through maximum likelihood estimation 
ML_RD <- glm(RDLL ~ Restraint + Loading, data=AllData_Stroke_Paretic_R_AVGs_Updated)
print(ML_RD)


# Fitting a varying Intercept Model - Using a grouping variable (This would be if grouped all stroke together)
ML_RD.2 <- glm(RDLL ~ Restraint + Loading + ID, data=AllData_Stroke_Paretic_R_AVGs_Updated )
print(ML_RD.2 )


# The Akaike information criterion (AIC) is an estimator of prediction error and thereby 
# relative quality of statistical models for a given set of data. Given a collection of 
# models for the data, AIC estimates the quality of each model, relative to each of the 
# other models.
AIC(ML_RD.2)

anova(ML_RD, ML_RD.2, test="F")

################# From ChatGPT and Trudy ##################################################

install.packages("lme4")  # Install the lme4 package

library(Matrix) # Need to load in package matrix to load in LME4
library(ggplot2)
library(lme4)
library(rlang)
#library(simr) for power analysis
library(emmeans)
library(lmerTest)
library(sjPlot)
# Using a "*" between your terms instead of a "+" means that you are also 
# Testing effect of Restraint and Load and then their interaction.

# Running with Averages per condition per person 
#model1 <- glmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic_R_AVGs_Updated, family = gaussian(link = "identity"))
#changing loading and restriant to categorical variable

# For each dataset, converting categorical variables 

# Need to set restraint, loading, as categorical variables 
AllData_Stroke_Paretic$Restraint = as.factor(AllData_Stroke_Paretic$Restraint)
AllData_Stroke_Paretic$Loading = as.factor(AllData_Stroke_Paretic$Loading)
AllData_Stroke_Paretic$ID = as.factor(AllData_Stroke_Paretic$ID)

# For the Non-Paretic Limb 
Non_Paretic_Edited_AUG2023$Restraint = as.factor(Non_Paretic_Edited_AUG2023$Restraint)
Non_Paretic_Edited_AUG2023$Loading = as.factor(Non_Paretic_Edited_AUG2023$Loading)
Non_Paretic_Edited_AUG2023$ID = as.factor(Non_Paretic_Edited_AUG2023$ID)


# For Massdata Sheet for Stroke (paretic and Nonparetic arms) making restraint, loading, and limb categorical variables
AllData_Stroke$Restraint = as.factor(AllData_Stroke$Restraint)
AllData_Stroke$Loading = as.factor(AllData_Stroke$Loading)
AllData_Stroke$ARM = as.factor(AllData_Stroke$ARM)
AllData_Stroke$ID = as.factor(AllData_Stroke$ID)

# For Controls
AllData_Controls$Restraint = as.factor(AllData_Controls$Restraint)
AllData_Controls$Loading = as.factor(AllData_Controls$Loading)
AllData_Controls$ID = as.factor(AllData_Controls$ID)


# Models

# model1 <- glmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, family = gaussian(link = "identity"))
#yielded error saying to call lmer bc it's within the Gaussian Family so don't need GLME
# Restricted Maximum Likelihood (REML), provides better estimates of the random effects' variance components
# Trial is nested within participant ID so don't list ID and Trial Separate - Tested the effect of trial as main effect and was a non significant effect


#Paretic Limb
model2 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, REML = TRUE)
#Omitting Restraint to Test Effect of Restraint on RDLL
model3 <- lmer(RDLL ~ Loading +(1 | ID), data = AllData_Stroke_Paretic,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model2, model3)
tab_model(model2, show.df = TRUE) # Paretic Limb


#Non-Paretic Limb 
model4 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = Non_Paretic_Edited_AUG2023,REML = TRUE)
model5 <- lmer(RDLL ~ Loading +(1 | ID), data = Non_Paretic_Edited_AUG2023,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model4, model5)
tab_model(model4, show.df = TRUE) # Non-Paretic Limb


#Controls
model6 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Controls,REML = TRUE)
model7 <- lmer(RDLL ~ Loading +(1 | ID), data = AllData_Controls,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model6, model7)
tab_model(model6, show.df = TRUE) #Controls


# For including the limb for all stroke data  USE THIS MODEL SEPT 2023
model8 <- lmer(RDLL ~ Loading * Restraint * ARM +(1 | ID), data = AllData_Stroke,REML = TRUE)
#Omitting Restraint to Test Effect of Restraint on RDLL
model9 <- lmer(RDLL ~ Loading * ARM +(1 | ID), data = AllData_Stroke,REML = TRUE)
# Comparing with and Without Restraint to see the effect of Restraint Using ChiSquared Test
anova(model8, model9)



#Running Model on Raw Reaching Distance
model10 <- lmer(ReachingDistance ~ Loading * ARM *Restraint +(1 | ID), data = AllData_Stroke,REML = TRUE)



#outputs the estimates for your predictors
tab_model(model5, show.df = TRUE) # Non Paretic Limb
tab_model(model2, show.df = TRUE) # Paretic Limb
tab_model(model6, show.df = TRUE) # Controls

tab_model(model4, show.df = TRUE) # All Stroke Limb
summary(model4, show.df = TRUE) # All Stroke Limb

tab_model(model10, show.df = TRUE) # All Stroke Limb


#outputs the "anova" output
anova(model3) #Paretic
anova(model4) #Combined 
anova(model5) # Non-Paretic


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

#checking for normality
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



