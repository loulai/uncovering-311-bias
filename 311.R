# reading data
d311 <- read_csv("311_service_requests_from_2011.csv")

# selecting only incident zip
d311 <-d311 %>% select(`Complaint Type`, `Incident Zip`)

# renaming
d311 <- d311 %>% rename(complaint_type = `Complaint Type`, incident_zip = `Incident Zip`)

# reordering
d311 <-  d311[c(2,1)]

