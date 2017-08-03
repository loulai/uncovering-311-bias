library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)

# read data
setwd("~/Desktop/programming/msft/uncovering-311-bias/data")
trees_initial <- read_csv("tree_census_2015.csv")

####### aim: get number of trees per zip code

# selecting only zipcode
trees <- trees_initial %>% select(zipcode)

# counting trees by zipcode
trees <- trees %>% group_by(zipcode) %>% mutate(total_trees = n()) %>% distinct(zipcode)







###### exploration

# what zip has most trees?
# 10312 has 22,186 trees, it's in Great Kills, Staten Island. 

# what zip has least trees?
# 10115 has 7 trees, it's in Morningside Heights and is tiny! And has a population of 0. 
