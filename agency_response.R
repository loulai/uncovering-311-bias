#this script analyzes whether or not there exists bias in agency response time by socioeconomic factors.
#is there a correlation in complaint type v. time to close?

library(ggplot2)
library(plyr)
library(dplyr)
library(reshape)
library(lubridate)
library(readr)

#setwd("/Users/brianavecchione/Documents/Microsoft/uncovering-311-bias")
complaints_2015_initial <- read_csv("311_service_requests_from_2015.csv")
#income_demographics <- read_csv("income_and_demographics.csv")

#select relevant columns 
data311_2015 <- complaints_2015_initial %>% select(`Unique Key`, `Created Date`, `Closed Date`, `Agency`, `Agency Name`,
                                                   `Complaint Type`, `Descriptor`, `Location Type`, 
                                                   `Incident Zip`, `Incident Address`, `Street Name`,
                                                   `Cross Street 1`, `Cross Street 2`, `Intersection Street 1`,
                                                   `Intersection Street 2`, `Address Type`, `City`, `Facility Type`,
                                                   `Status`, `Due Date`, `Resolution Description`, `Resolution Action Updated Date`,
                                                   `Community Board`, `Borough`, `Latitude`, `Longitude`, `Location`) 
data311_2015 <- data311_2015 %>% dplyr::rename(unique_key = `Unique Key`, 
                                                          created_date = `Created Date`,
                                                          closed_date = `Closed Date`,
                                                          agency = `Agency`,
                                                          agency_name = `Agency Name`,
                                                          complaint_type = `Complaint Type`,
                                                          descriptor = `Descriptor`,
                                                          location_type = `Location Type`,
                                                          zip = `Incident Zip`,
                                                          address = `Incident Address`,
                                                          streetname = `Street Name`,
                                                          cross_street_1 = `Cross Street 1`,
                                                          cross_street_2 = `Cross Street 2`,
                                                          intersection_st_1 = `Intersection Street 1`,
                                                          intersection_st_2 = `Intersection Street 2`,
                                                          address_type = `Address Type`,
                                                          city = `City`,
                                                          facility_type = `Facility Type`,
                                                          status = `Status`,
                                                          duedate = `Due Date`,
                                                          resolution_desc = `Resolution Description`,
                                                          resolution_action_updated_date = `Resolution Action Updated Date`,
                                                          cb = `Community Board`,
                                                          borough = `Borough`,
                                                          lat = `Latitude`,
                                                          long = `Longitude`,
                                                          location = `Location`)
                                                          
#format time series data (created/closed date), calculate time to close & order desc  
data311_2015$created_date <- mdy_hms(data311_2015$created_date,tz=Sys.timezone())
data311_2015$closed_date <- mdy_hms(data311_2015$closed_date,tz=Sys.timezone())
data311_2015 <- transform(data311_2015, time_to_close = difftime(data311_2015$closed_date, data311_2015$created_date, units="days"))
data311_2015 <- data311_2015[order(-data311_2015$time_to_close),]

#calculate num complaints by zip
data311_2015 <- data311_2015 %>% group_by(zip) %>% mutate(num_complaints = n())

#plot zipcode v time to close 
p <- ggplot(data = data311_2015, aes(time_to_close,num_complaints)) 
p <- p + geom_point()
p <- p + scale_x_continuous("\ntime_to_close")
#p <- p + scale_y_continuous("\nzip")
p <- p + ggtitle("Time to Close by Zip")
p <- p + geom_text(data = data311_2015, aes(label = zip))
p  
                 

