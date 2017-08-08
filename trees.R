library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plyr)

# read data
setwd("~/Desktop/programming/msft/uncovering-311-bias/data")
trees_initial <- read_csv("tree_census_2015.csv")

####### aim: get number of trees per zip code

# renaming zipcode to zip
trees <- trees %>% rename(zip = zipcode)

# selecting only zipcode from big tree dataset
trees <- trees_initial %>% select(zip)

# counting trees by zipcode
trees <- trees %>% group_by(zip) %>% mutate(total_trees = n()) %>% distinct(zip)

# merging trees with grand table
grand_trees <- merge(trees, grand, by="zip")

# calculating trees per person
grand_trees <- grand_trees %>% mutate(trees_per_person = total_trees/population_estimate)

# joining number of tree requests by zip
grand_trees <- merge(tree_complaints, grand_trees, by="zip")

# plotting number of trees v. number of requests for trees
ggplot(grand_trees, aes(total_trees, new_tree_requests)) + geom_point(color = "black") + geom_smooth(method='lm', se=FALSE)

# plotting number of trees per person v. number of requests for trees
ggplot(grand_trees, aes(trees_per_person, new_tree_requests)) + geom_point(color = "black") + geom_smooth(method='lm', se=FALSE)


###### exploration

# what zip has most trees?
# 10312 Great Kills Staten Island has 22,186 trees

# what zip has least trees?
# 10115 Morningside Heights has 7 trees (tiny! Has a population of 0).

# what zip has the most trees per person?
# 10309 Rossvile, Staten Island at 0.3811 trees per person. Every 3 people have one tree.

# what zip has the least trees per person?
# 11697 Breezy Point, NY at 0.0074. Every 135 people get one tree.

