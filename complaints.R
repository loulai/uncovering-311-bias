library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)

# read data
setwd("~/Desktop/programming/msft/uncovering-311-bias/data")
complaints_with_type_initial <- read_csv("311_service_requests_from_2011.csv")

# selecting only complaint type and incident zip
complaints_with_type <- complaints_with_type_initial %>% select(`Complaint Type`, `Incident Zip`) 

# renaming columns
complaints_with_type <- complaints_with_type %>% dplyr::rename(complaint_type = `Complaint Type`, zip = `Incident Zip`)

# reordering columns (for readability)
complaints_with_type <-  complaints_with_type[c(2,1)]

# adding count of complaints
complaints <- complaints_with_type %>% group_by(zip) %>% mutate(num_total_complaints = n())

# removing complaint type 
complaints <- complaints[, -2]

# removing duplicate rows
complaints <- complaints %>% distinct(zip)

# removing NA's 
complaints <- na.omit(complaints)

# there are 696 zip codes
# end table should have zip code and count of complaints in that zip code

############# exploration

# how many unique 311 complaints are there?
complaints <- d311 %>% distinct(complaint_type) #219
View(complaints)

# what is the most complained about thing?
d311_new2 <- d311 %>% group_by(complaint_type) %>% mutate(num_complaint_by_type = n()) # HEATING
View(d311_new2)

# which zip code complains the most?
# Flatbush, Brooklyn with 11,226 complaints

