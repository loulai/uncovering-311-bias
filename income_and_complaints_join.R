library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)

# read data
setwd("~/Desktop/programming/msft/uncovering-311-bias/data")
income_initial <- read_csv("income_and_demographics.csv")

# remove margins of error, city and state
income <- income_initial[, c(-3, -5, -6, -7)]

# merging with inner join
grand <- merge(income, complaints, by="zip")

# 196 observations of 41 variables

# adding normalized number of complaints by household and population
grand <- grand %>% mutate(complaints_per_household = total_complaints/households, complaints_per_person = total_complaints/population_estimate) 
# 196 obs., of 43 variables

# ------------------------ functions

#-- mean square root error
mse <- function(lmfit)
    sqrt(mean((summary(lmfit)$residuals)^2))

# ------------------------

########################## prediction begins! Yay!

#=====  let's start with trying to predict the number of 311 calls just based off income, shall we?

# == split test/train
index <- sample(1:nrow(grand), size = 0.2 * nrow(grand))
test = grand[index, ] #39
train = grand[-index, ] #157

# == fitting model

# run regression on training data set
lm.fit1 <- lm(total_complaints ~ mean_income, train)

# predict values
predicted_complaints <- predict(lm.fit1, test)

### evaluating model on test data set

#graphing training & test data. Regression line is modeled on the training data, which is gray. It's designed to fit the test data in red.
ggplot() + geom_point(data=train, aes(mean_income, total_complaints), color = "gray") + geom_point(data=test, aes(mean_income, total_complaints, color = "red")) + geom_line(data=test, aes(mean_income, predicted_complaints, color = "red")) + labs(color = "Test Data")
rsq <- cor(predicted_complaints, test$total_complaints) ^ 2
rsq # will vary! from 0.006 to 0.160. Usually around 0.09

# this shows that the model isn't great at prediction, as 0.09 is not close to 1.00 at all.
# translation: average income per zip code is not enough to predict the volume of 311 calls for that neighborhood.


#===== fitting everything to see most significant predictor variables (i.e. feature selection, yay!)

# based on unmodified data (i.e. no mutates)
train = grand[-index, ] #157
test = grand[index, ] #39
lm.fit2 <- lm(total_complaints ~ ., data = train)
summary(lm.fit2)

#====== literally everything this time
# remove zip 
df2 <- grand[c(-1)]

# split test and train
train_df2 = df2[-index, ] #152
test_df2 = df2[index, ] #37

# fitting
lm.fit3 <- lm(num_total_complaints ~ ., data = train_df2)
summary(lm.fit3)

# creating actual predictions
pred3 <- predict(lm.fit3, test_df2)
test_df2 <- mutate(test_df2, predicted = pred3)

# plotting predicted vs real
ggplot(test_df2, aes(predicted, num_total_complaints)) + geom_point()

# plotting regression (predicted = red, actual = grey)
ggplot(data = test_df2) + geom_point(aes(mean_income, num_total_complaints), color = "gray") + geom_point(aes(mean_income, predicted), color = "red")

mse(lm.fit3) # 2356.732


############## exploration

# plotting complaints_per_household by income
# (theory: higher income, higher household complaint rate)
ggplot(data = grand) + geom_point(aes(mean_income, complaints_per_household))

# plotting complaints_per_person by income
