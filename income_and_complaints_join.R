library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)


# read data
income <- read_csv("income_and_demographics.csv")

# remove margins of error, city and state
income <- income[, c(-3, -5, -6, -7)]

# inner join
grand <- merge(income, complaints, by="zip")

# ------------------------ functions

mse <- function(lmfit)
    sqrt(mean((summary(lmfit)$residuals)^2))

# ------------------------
###### prediction

# == split test/train
index <- sample(1:nrow(grand), size = 0.2 * nrow(grand))

test = grand[index, ] #37
train = grand[-index, ] #152
nrow(train)

# == fitting model

# run regression on training data set
lm.fit1 <- lm(num_total_complaints ~ mean_income, train)

# predict values
predicted_complaints <- predict(lm.fit1, test)

# evaluate model on test data set

#graphing training & test data. Regression line is modeled on the training data, which is gray. It's designed to fit the test data in red.
ggplot() + geom_point(data=train, aes(mean_income, num_total_complaints), color = "gray") + geom_point(data=test, aes(mean_income, num_total_complaints, color = "red")) + geom_line(data=test, aes(mean_income, predicted_complaints, color = "red")) + labs(color = "Test Data")
corr <- cor(predicted_complaints, test$num_total_complaints) ^ 2
corr # 0.036

# mean_income, unemployment rate

#===== fitting everything to see most significant ones

# selecting all data
#df <- select(grand, num_total_complaints, mean_income, median_income, 
#             race_white, race_native, race_black, race_asian, race_islander, race_other, race_two, race_hispanic,
#             unemployment_rate, family_poverty_percent) 



# based on unmodified data (i.e. no mutates)
train = df[-index, ] #152
test = df[index, ] #37
lm.fit2 <- lm(num_total_complaints ~ ., data = train)
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


