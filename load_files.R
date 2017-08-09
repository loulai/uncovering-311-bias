# Run the following code to load required data from:
# - complaints.R (311 Service Request Data)
# - income_and_complaints_join.R (joining 311 and U.S. Census income and democraphics data)
# - trees.R (Tree census)

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)


# read data
setwd("~/Desktop/programming/msft/uncovering-311-bias/data") 
complaints_2015_initial <- read_csv("311_service_requests_from_2015.csv") 
                  
# selecting only complaint type and incident zip
complaints <- complaints_2015_initial %>% 
  select(`Complaint Type`, `Incident Zip`) %>% 
  dplyr::rename(complaint_type = `Complaint Type`, zip = `Incident Zip`) %>% 
  group_by(zip) %>% 
  mutate(total_complaints = n()) %>%
  select(-complaint_type) %>%
  distinct(zip) 



# (for trees) adding counts of different types of complaints, 
tree_complaints <- complaints %>% group_by(zip, complaint_type) %>% mutate(total_complaints_by_type= n()) %>% distinct(complaint_type)

# (for trees) selecting to view only zipcode, types of complaints and their occurances within that zip
tree_complaints <- tree_complaints  %>% select(zip, complaint_type, total_complaints_by_type)

# (for trees) selecting only New Tree Requests and renaming
tree_complaints <- tree_complaints %>% filter(complaint_type == "New Tree Request") %>% rename(new_tree_requests = total_complaints_by_type)
#175 obs 

# (for trees) removing the 'complaint type' becuase it's all trees now
tree_complaints <- tree_complaints[, -2]
