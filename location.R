library(tidyverse)
library(readr)
library(stringr)
data<- read_csv(file ="./data/story-sales.zip" )

#extracting long and lat
location<-map(.x = data$`Store Location`, 
              .f = function(x) str_extract_all(x , pattern = "\\([^()]+\\)") ) %>% 
              flatten() %>%
              str_remove_all("[()]") %>%
              str_split_fixed("\\,", 2) %>% 
              as.data.frame() 
names(location)<-c("long", "lat")

