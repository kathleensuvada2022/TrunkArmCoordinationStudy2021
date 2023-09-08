
# September 2023
################################################################################

# 2 Way Repeated Measures ANOVA ****

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


###########################################################################