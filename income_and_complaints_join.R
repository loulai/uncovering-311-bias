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
ggplot() + geom_point(data=train, aes(mean_income, num_total_complaints), color = "gray") 
         + geom_point(data=test, aes(mean_income, num_total_complaints, color="red"))
         + geom_line(data=test, aes(mean_income, predicted_complaints, color = "red"))
         + labs(color = "Test Data")

ggplot() + geom_point(data=train, aes(mean_income, num_total_complaints), color = "gray") 
         + geom_point(data=test, aes(mean_income, num_total_complaints, color = "red")) 
         + geom_line(data=test, aes(mean_income, predicted_complaints, color = "red")) 
         + labs(color = "Test Data")

corr <- cor(predicted_complaints, test$num_total_complaints) ^ 2
