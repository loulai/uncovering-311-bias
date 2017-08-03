library(ggplot2)
library(plyr)
library(dplyr)
library(reshape)

#setwd("/Users/brianavecchione/Documents/Microsoft/uncovering-311-bias")
complaints_2015_initial <- read_csv("311_service_requests_from_2015.csv")
income_demographics <- read_csv("income_and_demographics.csv")

#this script analyzes whether or not there exists bias in agency response time by socioeconomic factors.
#is there a correlation in complaint type v. time to close?

