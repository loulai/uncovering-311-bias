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

# split test/train
index <- sample(1:nrow(grand), size = 0.2 * nrow(grand))

test = 