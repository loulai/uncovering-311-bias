library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)


# read data
income <- read_csv("income_and_demographics.csv")

# remove margins of error
income <- income[, c(-3,-5)]

# inner join
grand <- merge(income, complaints, by="zip")
View(grand)
View(income)

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

#selecting all 'fair' data
df <- select(grand, zip, mean_income, median_income, race_white, unemployment_rate, family_poverty_percent) 
View(df)

#based on unmodified data (i.e. no mutates)
View(train)
lm.fit2 <- lm(num_total_complaints ~ ., data = train)
summary(lm.fit2)

pred2 <- predict(lm.fit2, test)
validation <- mutate(validation, predicted = pred1)
View(validation)

#plotting predicted vs real
ggplot(validation, aes(predicted, total_trips)) + geom_point()

#plotting regression: predicted is red, actual is grey
ggplot(data = test) + geom_point(aes(tmin, total_trips), color = "gray") + geom_point(aes(tmin, predicted), color = "red")
mse(lm.fit1)
