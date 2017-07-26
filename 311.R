# reading data
d311 <- read_csv("311_service_requests_from_2011.csv")

# selecting only incident zip
d311 <- d311 %>% select(`Complaint Type`, `Incident Zip`)

# renaming
d311 <- d311 %>% rename(complaint_type = `Complaint Type`, incident_zip = `Incident Zip`)

# reordering
d311 <-  d311[c(2,1)]

# adding count of complaints
d311_new <- d311 %>% group_by(incident_zip) %>% mutate(num_total_complaints = n())

# removing complaint type
d311_new <- d311_new[, -2]

# removing duplicate rows
d311_new <- d311_new %>% distinct(incident_zip)

# removing NA's 
d311_new <- na.omit(d311_new)

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
# Flatbush. Brooklyn with 11,226 complaints

