library(tidyverse)
library(readr)
library(stringr)
library(leaflet)
data<- read_csv(file ="./data/story-sales.zip" )

#extracting long and lat
location<-map(.x = data$`Store Location`,
              str_remove_all("[()]") %>%
                str_split_fixed("\\,", 2) %>% 
                as.data.frame() 
              names(location)<-c("long", "lat")
              names(location)<-c("lat", "long")
              
              data$long<-location$long%>% as.character() %>% as.numeric()
              data$lat<-location$lat%>% as.character() %>% as.numeric()
              data<-data[!is.na(data$long) & !is.na(data$lat),]
              data<- data %>% mutate(City= as.factor(City))
              
              
########## map example for ames
ames.data <- data %>% filter(City == "Ames" & `Zip Code`== 50010)
              
amesmap <-
  leaflet() %>% addProviderTiles(providers$OpenStreetMap)
amesmap %>% addMarkers(
  lng = ames.data$long[1:10],
  lat = ames.data$lat[1:10],
  popup = ames.data$`Store Name`[1:10]
)

              
              
#### dataframe just for map
df <- data %>% select(`Store Name`, Address,
                      City, `Store Location`, long, lat)

df.map <- df[!duplicated(df), ]