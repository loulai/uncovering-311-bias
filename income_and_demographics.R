library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)


# reading data
income <- read_csv("income_and_demographics.csv")

grand <- merge(income, complaints, by="zip")

