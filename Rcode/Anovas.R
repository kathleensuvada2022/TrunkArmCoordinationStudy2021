# Script For ANOVAs - 1 way and 2 way 
# August 2022 Kacey Suvada

# Taken from https://www.scribbr.com/statistics/anova-in-r/

install.packages(c("ggplot2", "ggpubr", "tidyverse", "broom", "AICcmodavg"))

#Loading in Functions?Packages?
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)

#Loading in the Data
crop_data <- read.csv("/Users/kcs762/Desktop/'crop.data.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric"))

#Double checking was Data loaded
summary(crop_data)

#running a one way ANOVA

# Modeling crop yield as a function of the type of fertilizer used. Fertilizer is the independent variable. 

one.way <- aov(yield ~ fertilizer, data = crop_data)

# summary of ANOVA test
summary(one.way)


# Doing a two way ANOVA
two.way <- aov(yield ~ fertilizer + density, data = crop_data)

summary(two.way)
# 2 way was better bc sum squares residuals was reduced from 36-31. 

# The model summary first lists the independent variables being tested in the model 
# (in this case we have only one, ‘fertilizer’) and the model residuals (‘Residual’). 
# All of the variation that is not explained by the independent variables is called residual variance.

# The Df column displays the degrees of freedom for the independent variable 
# (the number of levels in the variable minus 1),
# and the degrees of freedom for the residuals (the total number of observations 
# minus one and minus the number of levels in the independent variables).

# The Sum Sq column displays the sum of squares (a.k.a. the total variation 
# between the group means and the overall mean).
# The Mean Sq column is the mean of the sum of squares, calculated by dividing 
# the sum of squares by the degrees of freedom for each parameter.

# The F-value column is the test statistic from the F test. This is the mean 
# square of each independent variable divided by the mean square of the residuals.
# The larger the F value, the more likely it is that the variation caused by the
# independent variable is real and not due to chance.

# !!!! The Pr(>F) column is the p-value of the F-statistic. 
# This shows how likely it is that the F-value calculated from the test 
# would have occurred if the null hypothesis of no difference among group means were true.
