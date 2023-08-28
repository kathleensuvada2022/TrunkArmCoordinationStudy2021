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

