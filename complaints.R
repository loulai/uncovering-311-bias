library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)

# read data
setwd("~/Desktop/programming/msft/uncovering-311-bias/data") 
complaints_2015_initial <- read_csv("311_service_requests_from_2015.csv")

# selecting only complaint type and incident zip
complaints_with_type <- complaints_2015_initial %>% select(`Complaint Type`, `Incident Zip`) 

# renaming columns
complaints_with_type <- complaints_with_type %>% dplyr::rename(complaint_type = `Complaint Type`, zip = `Incident Zip`)

# reordering columns (for readability)
complaints_with_type <-  complaints_with_type[c(2,1)]

# adding count of complaints
complaints <- complaints_with_type %>% group_by(zip) %>% mutate(total_complaints = n())

# removing complaint type 
complaints <- complaints[, -2]

# removing duplicate rows
complaints <- complaints %>% distinct(zip) # 700 zips

# removing NA's 
complaints <- na.omit(complaints)

# there are 699 zip codes of 2 variables (2015)
# end table should have zip code and count of complaints in that zip code

############# exploration

# how many unique 311 complaints are there?
complaints_unique <- complaints_with_type %>% distinct(complaint_type) 
nrow(complaints) # 231 (2015)

# what is the most complained about thing?
complaints_most <- complaints_with_type %>% group_by(complaint_type) %>% mutate(num_complaint_by_type = n()) %>% distinct(complaint_type)
View(complaints_most) # 225,083 complaints for HEAT/HOT WATER
top_10_complaints <- complaints_most[order(complaints_most$num_complaints_by_type, decreasing = TRUE)]
View(top_10_complaints)
g <- ggplot(complaints_most, aes(complaint_type, num_complaint_by_type))
g + geom_bar(stat = "identity")


