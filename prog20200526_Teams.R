### MCB 26.05.20; Workshop on basic R

### this is  a  comment


###################################### libraries #################################

#install.packages('MASS')

#install.packages('data.table')

install.packages('descr')




library(MASS)
library(data.table)
library(descr)

### to update the .RData object:

save.image()

ls()

### there are three basic methods: print, summary and plot

vector <- c(1,2,3,10,11)
### this sentence could have been written as
vector = c(1,2,3,10,11) 
### it's exactly the same to use <- (gets) or = (equals)
### BUT I like <- better!
### is the concatenate function - joins numbers into a vector

vector <- c(      1, 2, 3 ,10,   11)

print(vector)
length(vector)

### round brackets are used to limit arguments of a function

## a function has a name, arguments (input), and value (output)

vector ## note that by default, the method is print
## if I type the object's name, I get a print out of it

vector<- c(20,21,23)

print(vector)
summary(vector)
plot(vector)


vector2 <- c(1,5,7, 6)

vector + vector2 ## you get a warning because the lenghts of vector and vector2 don't coincide

### R has a lot of algebraic and statistical functions

mean(vector)
sd(vector)
max(vector)
median(vector)

### the previous four lines just print the outcomes of applying these functions to the  object named vector

### you can assign the output of a function to another object:

mean_vector <- mean(vector)

### square brackets are used to select or obtain subsets of indexed objects

vector
print(vector)

x <- 1:10000
length(x) ### 10000

x[1] ## extracts the first element of vector x


x[1:5] ### extracts the first five elements of x


x[c(1:5, 1000:1005)]

mean(x)
sd(x)

#### be careful of the type of arguments you use:

sqrt(-100)


### missing values are denoted by NA  
### Not Available

vector<- c(1,2,3,6,10,NA, 18)

vector

mean(vector) ## results in NA

mean(vector, na.rm=TRUE) ## runs mean with argument na.rm equals TRUE

### to see the argumetns of a function, use ? to open a help file

?mean
### note that the arguments of mean are
### x, trim = 0, na.rm = FALSE
### by default, trim takes the value 0, and na.rm takes the (logical) value FALSE
### the first argument of a function can go unnamed

mean(x=vector, na.rm=TRUE) ### change the value of na.rm manually to TRUE 

### how about working with some real values?

### suppose you have a csv file in your working directory

titanic3 <- read.csv(file="titanic3.csv")  

ls() ## lists all objects in the session


### note what happens if you say

ls ### this simpmly prints the object named ls - which is a function

### or if you say

ls() ### this runs the function named ls with the default arguments (because you're not specifying any)
## the output of running ls() is the objects in the .GlobalEnv

### let's look at the object titanic3

names(titanic3) ### gives a list of the variables contained in the object titanic3

str(titanic3) ## gives you the structure

### to see the libraries loaded into the RStudio session:

search()## lists all libraries present

### a data.frame  is the most important data structure in R

is.data.frame(titanic3) ## answer: TRUE

### to access variables from a data.frame, use the $ operator 

dim(titanic3) ## size = 1309 rows (individuals) and 14 columns (variables)

### operator $ selects variables in the data.frame

summary( titanic3$age)
boxplot(titanic3$age, col='orange', ylab='age of passengers', main='Data from Titanic')
?boxplot ## help for boxplot

hist(titanic3$age)

chisq.test( table( titanic3$pclass, titanic3$survived)) ## p < 0.0001, strong association


fisher.test(table( titanic3$sex, titanic3$survived)) ## p < 0.0001, strong association

plot(density(titanic3$fare, na.rm=TRUE )) ## smoothed histogram

tab1 <- table( titanic3$pclass, titanic3$survived) ## tab 1 is a table

tab1[1,] ### selects the first row
tab1[,1] ## selects the first column
tab1[1,1] ## selects the entry in (first row, first column)


### package data.table must be loaded in the session

search() ## note that data.table is in position 2 of this list

ls() ## runs ls with the default argument, which is the .GlobalEnv 
ls(pos=2)


### use package descr to print tables

### note that :: specifies the library in which the function lives

descr::crosstab(titanic3$survived, titanic3$pclass) ## provides tables with marginals

### using formulas

boxplot(age ~ sex, data=titanic3, col=c('orange', 'green3'))  ### outcome (dependent, or response) variable ~ covariates, or independent variables

wilcox.test( age ~ sex, data=titanic3) ## p = 0.041

with(titanic3, 
     tapply(age, sex, summary)
     ) ## applies the function summary to age by values of sex - interpreted in titanic3


with(titanic3, 
     tapply(age, survived, summary)
) ## applies the function summary to age by values of sex - interpreted in titanic3

boxplot(age ~ survived, data=titanic3, col=c('orange', 'green3'))  ### outcome (dependent, or response) variable ~ covariates, or independent variables

### fitting logistic regression models

mod1<- glm(survived ~ sex + pclass + age, 
           family=binomial(logit), data=titanic3)
##fits a logistic regression model to survived as a function of sex, pclass and age


print(mod1)
summary(mod1) ## useful
plot(mod1) ## nonsense in this case!

mod2<- glm(survived ~ sex + pclass + age + I(age^2), 
           family=binomial(logit), data=titanic3)

anova(mod1, mod2, test='Chisq') ## likelihood ratio test



