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


# Need to set restraint, loading, as categorical variables 
AllData_Stroke_Paretic$Restraint = as.factor(AllData_Stroke_Paretic$Restraint)
AllData_Stroke_Paretic$Loading = as.factor(AllData_Stroke_Paretic$Loading)

# For the Non-Paretic Limb 
Non_Paretic_Edited_AUG2023$Restraint = as.factor(Non_Paretic_Edited_AUG2023$Restraint)
Non_Paretic_Edited_AUG2023$Loading = as.factor(Non_Paretic_Edited_AUG2023$Loading)


# For Massdata Sheet for Stroke (paretic and Nonparetic arms) making restraint, loading, and limb categorical variables
AllData_Stroke$Restraint = as.factor(AllData_Stroke$Restraint)
AllData_Stroke$Loading = as.factor(AllData_Stroke$Loading)
AllData_Stroke$ARM = as.factor(AllData_Stroke$ARM)


# Running every trial
# model1 <- glmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, family = gaussian(link = "identity"))
#yielded error saying to call lmer bc it's within the Gaussian Family so don't need GLMER

# Try running LMER 

# Restricted Maximum Likelihood (REML), provides better estimates of the random effects' variance components
model2 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, REML = TRUE)

# Need to include the random effects from each participant and trial 

# Trial is nested within participant ID so don't list ID and Trial Separate
model3 <- lmer(RDLL ~ Loading * Restraint + (1 | ID/Trial), data = AllData_Stroke_Paretic,REML = TRUE)

#For the Non-Paretic Limb Separate Analysis 
model5 <- lmer(RDLL ~ Loading * Restraint + (1 | ID/Trial), data = Non_Paretic_Edited_AUG2023,REML = TRUE)


# For including the limb for all stroke data 
model4 <- lmer(RDLL ~ Loading * Restraint * ARM *(1 | ID/Trial), data = AllData_Stroke,REML = TRUE)


anova(model2, model3)

#outputs the estimates for your predictors
tab_model(model5, show.df = TRUE) # Non Paretic Limb

tab_model(model3, show.df = TRUE) # Paretic Limb


tab_model(model4, show.df = TRUE) # All Stroke Limb

#outputs the "anova" output
anova(model3)
anova(model4)

#if there's significance, you can do some pairwise comparisons
emmeans(model3, pairwise ~ Loading * Restraint)
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



