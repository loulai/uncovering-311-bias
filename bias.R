library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

#reading data
d <- read_csv('311SR_from_2011.csv')
acsMessy <- read_csv("ACS_15_5YR_mean_median.csv")

#### filtering ACS 5 year income data

# removing row one
acs <- acsMessy[-1,]

# selecting columns that are not 'measures of error' 
acs <- acs[, !grepl("MOE", names(acs))] # 63 colmuns from 75

# selecting columns that are not 'familes' or 'married-couple familes' or 'nonfamily households' (i.e. keeping only 'households')
acs <- acs[, !grepl("HC02|HC03|HC04", names(acs))] # 54 columns from 75

# removing NA columns
acs <- acs[c(1:6)] 

# renaming columns 
acs = acs %>% rename(GEO_id = GEO.id, GEO_id2 = GEO.id2, #GEO_display_level = GEO.display-label (problematic!! fix)
                     total_household = HC01_EST_VC01, 
                     median_income = HC01_EST_VC13, 
                     mean_income = HC01_EST_VC15)

# converting to appropriate class
acs[, c(2, 4:6)] <- sapply(acs[, c(2, 4:6)], as.numeric)
View(acs)

##### plotting
# does the number of households in one area correlate to income?
ggplot(acs, aes(x=total_household, y=mean_income)) + geom_point()  # shows slight negative correlation

# is the average income the same as halfway (mean) income?
ggplot(acs, aes(x=mean_income, y=median_income)) + geom_point() # more deviation as mean income increases, i.e. income gap widens


