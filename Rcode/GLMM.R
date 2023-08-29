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


# Need to set restraint and loading as categorical variables 
AllData_Stroke_Paretic$Restraint = as.factor(AllData_Stroke_Paretic$Restraint)
AllData_Stroke_Paretic$Loading = as.factor(AllData_Stroke_Paretic$Loading)

# Running every trial
model1 <- glmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, family = gaussian(link = "identity"))
#yielded error saying to call lmer bc it's within the Gaussian Family so don't need GLMER

# Try running LMER 

# Restricted Maximum Likelihood (REML), provides better estimates of the random effects' variance components
model2 <- lmer(RDLL ~ Loading * Restraint + (1 | ID), data = AllData_Stroke_Paretic, REML = TRUE)

# Need to include the random effects from each participant and trial 
model3 <- lmer(RDLL ~ Loading * Restraint + (1 | ID/Trial), data = AllData_Stroke_Paretic,REML = TRUE)

anova(model2, model3)


#outputs the estimates for your predictors
tab_model(model3, show.df = TRUE)

tab_model(model2, show.df = FALSE)

#outputs the "anova" output
anova(model3)
#if there's significance, you can do some pairwise comparisons
emmeans(model3, pairwise ~ Loading * Restraint)
#checking for normality
#note, for lme, your data doesn't have to be normal.
#However, your residuals DO have to have normal distribution 

# Want to see residuals randomly dispersed
plot(residuals(model3)) 
#plot(fitted(model3), residuals(model3))

#Want to appear that the residuals are a Normal Distrib
hist(residuals(model3))

# Create a QQ plot
qqnorm(residuals(model3))
qqline(residuals(model3))



