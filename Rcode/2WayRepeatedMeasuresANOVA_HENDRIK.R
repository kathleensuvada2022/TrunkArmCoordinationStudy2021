# Kacey Suvada
# 2023 PCMC Abstract 

################################################################################

#Loading in Required R Packages
library(tidyverse)
library(ggpubr)
library(rstatix)


############# RUN BELOW FOR PARETIC LIMB#######################

# data: full dataset with averages for each condition
# dv: main outcome measure testing
# ID: repeated measure AKA participant ID
# within: two factors testing effect on reaching distance limb length (RDLL)

res.aov <- anova_test(
  data = AllData_Stroke_Paretic_R_AVGs, dv = RDLL, wid = ID,
  within = c(Restraint,Loading)
)

#YIELDS SUMMARY OF ANOVA
get_anova_table(res.aov) 


# POST HOC TESTING FOR 2 WAY REPEATED MEASURES ANOVA

# Effect of Restraint at each Loading Level
one.way <- AllData_Stroke_Paretic_R_AVGs %>%
  group_by(Loading) %>%
  anova_test(dv = RDLL, wid = ID, within = Restraint) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")

#Displays the effect of trunk restraint at each Limb Loading level
one.way 