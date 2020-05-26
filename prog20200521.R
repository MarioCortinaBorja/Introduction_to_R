### First Rstudio session; 26th May 2020

#install.packages('tidyverse')
#install.packages('MASS')
## see https://cran.r-project.org/doc/contrib/Torfs+Brauer-Short-R-Intro.pdf

library(tidyverse)
library(MASS)

install.packages('readxl')
library(readxl)

Animals<- read_xlsx("Animals.xlsx", sheet="Animals")



table(titanic3$sex)

table(titanic3$survived)

tab1<- table(titanic3$sex, titanic3$survived)

tab1

chisq.test(tab1) #### very significant association - why?

boxplot(age ~ sex, data=titanic3)

table(titanic3$pclass)

tab2<- table(titanic3$pclass, titanic3$survived)

tab2

chisq.test(tab2) ### very significant association

hist(titanic3$fare) ### histogram of fares

hist(titanic3$age) ### note the mixture of children and adults

boxplot(age ~ survived, data=titanic3) ## not a lot of difference in ages by survivorship

wilcox.test(age ~ survived, data=titanic3) 
### p = 0.178, no significant difference in location of age by survivorsip


mod1<- glm(survived ~ sex + pclass + age, family=binomial(logit), data=titanic3)
### modelling odds of survivorship by sex, passenger class, and age

summary(mod1)

#Coefficients:
#  Estimate Std. Error z value Pr(>|z|)    
#(Intercept)  3.522074   0.326702  10.781  < 2e-16 ***
#  sexmale     -2.497845   0.166037 -15.044  < 2e-16 ***
#  pclass2nd   -1.280570   0.225538  -5.678 1.36e-08 ***
#  pclass3rd   -2.289661   0.225802 -10.140  < 2e-16 ***
#  age         -0.034393   0.006331  -5.433 5.56e-08 ***

## odds of survivorship are decreased for males vs females (reference category = females)
## odds decrease by passenger class (refernce category = 1st)
## odds of survivorship decrease by age: exp(-0.034393) = 0.9662: 
## for every year of age, the probability of surviving decreases 4%

## perhaps a linear trend for survivorship vs age is not appropriate 
## try quadratic

mod2<- glm(survived ~ sex + pclass + age + I(age^2), family=binomial(logit), data=titanic3)
### there are better forms of specifying a quadratic term but this is the simplest
### note the use of function I (identity)
  
### the models are nested, so a likelihoood ratio test is appropriate 

anova(mod1, mod2, test='Chisq')

# Analysis of Deviance Table

#Model 1: survived ~ sex + pclass + age
#Model 2: survived ~ sex + pclass + age + I(age^2)
#Resid. Df Resid. Dev Df Deviance Pr(>Chi)
#1      1041     982.45                     
#2      1040     980.83  1   1.6224   0.2028

### Analysis of deviance indicate that the goodness-of-fit doesn't significantly improved with a 
### quadratic term in age, so it seems linear trend with age is enough


