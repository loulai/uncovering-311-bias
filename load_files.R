# Run the following code to load required data from:
# - complaints.R (311 Service Request Data)
# - income_and_complaints_join.R (joining 311 and U.S. Census income and democraphics data)
# - trees.R (Tree census)

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)

setwd("~/Desktop/programming/msft/uncovering-311-bias/data") 

# (311) read
complaints_initial_2015 <- read_csv("311_service_requests_from_2015.csv") 
                  
# (311) clean
complaints <- complaints_2015_initial %>% 
  select(`Complaint Type`, `Incident Zip`) %>% 
  dplyr::rename(complaint_type = `Complaint Type`, zip = `Incident Zip`) %>% 
  group_by(zip) %>% 
  mutate(total_complaints = n()) %>%
  select(-complaint_type) %>%
  distinct(zip) # 700 obs, 2 var

# (Trees) clean
tree_complaints <- complaints_initial_2015 %>% 
  dplyr::rename(complaint_type = `Complaint Type`, zip = `Incident Zip`) %>% 
  group_by(zip, complaint_type) %>%
  mutate(total_complaints_by_type = n()) %>%
  distinct(complaint_type) %>%
  select(zip, complaint_type, total_complaints_by_type) %>%
  filter(complaint_type == "New Tree Request") %>%
  rename(new_tree_complaints = total_complaints_by_type) %>% 
  ungroup() %>% #required to drop column indicating all trees
  select(-complaint_type)

# (Census) read
income_initial_2015 <- read_csv("income_and_demographics.csv") 

# (Census) clean
income <- income_initial_2015[, c(-3, -5, -6, -7)] %>% 
  merge(complaints, by="zip") %>%
  mutate(complaints_per_household = total_complaints/households, complaints_per_person = total_complaints/population_estimate) # 196 obs. of 43 variables

# functions

# -- mean square root error
mse <- function(lmfit)
  sqrt(mean((summary(lmfit)$residuals)^2))
# --


