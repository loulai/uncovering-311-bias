library(tidyverse)
library(readr)
library(dplyr)
library(lubridate)

d <- read_csv('311SR_from_2011.csv')
income <- read_csv('2014-income-by-zip.csv')
colnames(d)
head(d)
d[2,]

#filtering income data
nyIncome <- income %>% filter(STATE == 'NY')
View(nyIncome)
