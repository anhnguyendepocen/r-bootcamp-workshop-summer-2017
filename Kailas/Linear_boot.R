# summary of unemp, public etc
sum.st <- subset(productivity, select = c("unemp", "public", "private", "gsp"))
summary(sum.st)
# correlation between expense and cprod
cor(sum.st)

# Fit our regression model
prod.mod <- lm(gsp ~ public, # regression formula
              data=productivity) # data set
# Summarize and print the results
summary(prod.mod) # show regression coefficients table


summary(lm(gsp ~ public + unemp, data = productivity))

class(prod.mod)
names(prod.mod)
methods(class = class(prod.mod))[1:9]

confint(prod.mod)
hist(residuals(prod.mod))

par(mar = c(4, 4, 2, 2), mfrow = c(1, 2)) #optional
plot(prod.mod, which = c(1, 2)) # "which" argument optional


# fit another model, adding house and senate as predictors
prod.private.mod <-  lm(gsp ~ public + unemp + private,
                      data = na.omit(productivity))
prod.mod <- update(prod.mod, data=na.omit(productivity))
# compare using the anova() function
anova(prod.mod, prod.private.mod)
coef(summary(prod.private.mod))


#Add the interaction to the model
prod.expense.by.percent <- lm(cprod ~ expense*income,
                             data=states.data) 
#Show the results
coef(summary(prod.expense.by.percent)) # show regression coefficients table



# make sure R knows region is categorical
#str(states.data$region)
#states.data$region <- factor(states.data$region)
#Add region to the model
#prod.region <- lm(cprod ~ region,
 #                data=states.data) 
#Show the results
#coef(summary(prod.region)) # show regression coefficients table
#anova(prod.region) # show ANOVA table

library(lme4)

gsp.mod <-lmer(gsp ~ 1 + (1|region),
             data=productivity, REML = FALSE)
summary(gsp.mod)

gsp.mod2 <-lmer(gsp~public + (1|region),
             data=productivity,
             REML = FALSE) 
summary(gsp.mod2)