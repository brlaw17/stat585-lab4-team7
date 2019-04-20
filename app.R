library(shiny)
library(tidyr)
library(leaflet)
library(tidyverse)
# extract data
# data<- read_csv(file ="./data/story-sales.zip" )
# 
# #extracting long and lat
# location<-map(.x = data$`Store Location`,
#               .f = function(x) str_extract_all(x , pattern = "\\([^()]+\\)") ) %>%
#   flatten() %>%
#    str_remove_all("[()]") %>%
#    str_split_fixed("\\,", 2) %>%
#    as.data.frame()
#  names(location)<-c("lat", "long")
# 
#  data$long<-location$long%>% as.character() %>% as.numeric()
#  data$lat<-location$lat%>% as.character() %>% as.numeric()
#  data<- data[!is.na(data$long) & !is.na(data$lat),]
#  data<- data %>% mutate(City= as.factor(City), `Zip Code`=as.factor(`Zip Code`))
#  
#  df.map<-data %>% select(`Store Name`, Address,
#                  City, `Store Location`,
#                  long, lat, `Zip Code`) %>% unique()
ui <- fluidPage(
  
  titlePanel("Iowa Liquor Sales"),
  
  sidebarPanel(
    selectInput("City", label = "City", 
                choices = levels(unique(df.map$City)), selected = "AMES")
  ),
  
  titlePanel("Iowa Liquor Sales"),
  
  sidebarPanel(
    selectInput("ZipCode", label = "ZipCode", 
                choices = levels(unique(df.map$`Zip Code`)), selected = "50010")
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Cornfield", leafletOutput("map"))
    )
  )
)
##


server <- function(input, output) {


  output$map <-renderLeaflet({ 
    df.map %>% filter(City == input$City & `Zip Code`==input$ZipCode ) %>%  
    leaflet()%>%
    addTiles() %>%
    addMarkers(lng = ~long,
               lat = ~lat,
               popup = ~`Store Name`)
  })
}


###
# Run the application 
shinyApp(ui = ui, server = server)