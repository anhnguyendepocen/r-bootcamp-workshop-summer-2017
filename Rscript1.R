
# install.packages("dplyr")
# install.packages("haven")
# install.packages("tidyverse")
# install.packages("ggplot2")
# 
# install.packages("sandwich")
# install.packages("lmtest")
# install.packages("car")
# install.packages("sjPlot")
# install.packages("stargazer")
# install.packages("doBy")
# install.packages("psych")

library(psych)
library(doBy)
library(car)
library(dplyr)
library(haven)
library(tidyverse)
library(ggplot2)
library(sjPlot)
library(data.table)

#Print R session info
sessionInfo()

#Show installed libraries/packages
library()

#Read the Data  
d<- read.csv("C:/Users/kvenkita/Dropbox (UNC Charlotte)/R Bootcamp/data.csv")

#Code a string variable as factor
d$name<-as.factor(d$name)
d$region<-as.factor(d$region)

#create a single new variable using calculation
d$GDP_cap <- d$GDP/d$POP

#drop this variable
head(d)
d<-d[c(-9)]

#create it again
d$GDP_cap <- d$GDP/d$POP
#Make a categorical variable from continuous variable
summary(d$GDP_cap)

#Creating GDPpercapita categories with quartile values
d$gdpcap_cat <- cut(d$GDP_cap,
                     breaks=c(-Inf, 1177, 15649, Inf),
                     labels=c("low","medium","high"))
names(d)
d$gdpcap_cat<-as.factor(d$gdpcap_cat)
#create several new variables (dplyr function of mutate)
d<-mutate(d,HEX_total=HEX*GDP,
         lnGDP=log(GDP),
         DEN=POP/LAN)
head(d)

#create a new factor variable based on an existing string variable
d$region1<-as.factor(d$region)

#Check the levels of this factor variable
levels(d$region)

#create dummy variables
library(psych)
dummy_reg<-dummy.code(d$region)
d<-data.frame(d,dummy_reg)

#rename variables
#install.packages("data.table")
library(data.table)
names(d)
setnames(d,old=c("East.Asia...Pacific"),new=("east_asia"))
setnames(d,old=c("Europe...Central.Asia", "Latin.America...Caribbean", "Middle.East...North.Africa", "North.America", "South.Asia", "Sub.Saharan.Africa"),new=c("europe","latinam","meast","northam","sasia","subsah_afr"))
names(d)

#Glance at your data
head(d)

#Call the library "CAR"
library(car)
??car

#Fit a simple linear regression model
reg1<-lm(MOR~GDP_cap,data=d)
reg1
summary(reg1)

#Fit a model with more variables
reg1<-lm(MOR~GDP_cap+HEX+DEN,data=d)
reg1
summary(reg1)

#Fit a model with factor variables
reg1<-lm(MOR~GDP_cap+HEX+DEN+region,data=d)
reg1
summary(reg1)

#Fit a loglinear model
reg1<-lm(log(MOR)~GDP_cap+HEX+DEN+region,data=d)
reg1
summary(reg1)

#Robust Standard Errors

library(lmtest) 
library(sandwich)
reg1$robse <- vcovHC(reg1, type="HC1")
coeftest(reg1,reg1$robse)

#Cluster Robust Standard Errors
summary(reg1, cluster=c("name"))
summary(reg1)


#Residual Plots
#library(car)
residualPlots(reg1)
residualPlots(reg1, ~ 1, fitted=TRUE)

#Influential observations
avPlots(reg1)
outlierTest(reg1)
influenceIndexPlot(reg1, id.n=3)
influencePlot(reg1, id.n=3)

#Normality and Multicollinearity
vif(reg1)
qqPlot(reg1)
ncvTest(reg1)

#Post-estimation, marginal effects, residuals and more...
library(sjPlot)
sjp.frq(d$region)

#Compare Regressions
reg1<-lm(MOR~GDP_cap+HEX+DEN,data=d)
reg2<-lm(log(MOR)~GDP_cap+log(HEX)+DEN,data=d)

##Create Formatted Table of Estimates from multiple specification
sjt.lm(reg1,reg2)

#Create plots of point-estimates and confidence intervals
sjp.lm(reg1)

#Create plots of standardized point-estimates and confidence intervals
sjp.lm(reg1, type="std")
sjp.lm(reg1, type="std", sort.est=FALSE)

sjp.lm(reg1, type="eff", sort.est=FALSE)

#Create plots of slope between predictors and response
sjp.lm(reg1, type="slope")

#Create plots of residuals and predictors 
sjp.lm(reg1, type="resid")

#Create plots of VIF
sjp.lm(reg1, type="vif")


#Create Interaction Plots
names(d)
reg1<-lm(MOR~GDP_cap+DEN+HEX*subsah_afr,data=d)
summary(reg1)
sjp.int(reg1, type = "cond")

reg1<-lm(MOR~GDP_cap+DEN+region*HEX,data=d)
summary(reg1)
sjp.int(reg1, type = "eff", facet.grid=TRUE)
sjp.int(reg1, type = "eff", facet.grid=TRUE,show.ci=TRUE)
sjp.int(reg1, type = "eff")


reg1<-lm(MOR~gdpcap_cat+DEN+HEX*subsah_afr,data=d)
summary(reg1)

reg1<-lm(MOR~gdpcap_cat*subsah_afr+DEN+HEX,data=d)
summary(reg1)

#Contingency Tables
sjp.xtab(d$region,d$gdpcap_cat)


#install.packages("stargazer")
library(stargazer)

stargazer(reg1,type="html")
