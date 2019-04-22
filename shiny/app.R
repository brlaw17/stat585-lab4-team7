library(shiny)
library(dplyr)
library(readr)
library(stringr)
library(leaflet)
data<- read_csv(file ="../data/story-sales.zip" )
# clean Date and City
newdat <- data %>% mutate(Date = lubridate::mdy(Date)) %>% 
  mutate(City = toupper(City))

# clean dataset at store level: use unique store name, extract Lat and Long for map
storeinfo <- newdat %>% 
  group_by(`Store Number`) %>% 
  filter(grepl("\\(",`Store Location`)) %>% 
  summarise(`Store Name` = unique(`Store Name`)[1], `Store Location` = unique(`Store Location`)[1]) %>% 
  mutate(Lat = purrr::map_chr(`Store Location`, .f = function(t) {
      t %>% str_extract_all("(?<=\\()[-0-9.]{1,}") %>% 
      unlist()}) %>% as.numeric(), 
      Long = purrr::map_chr(`Store Location`, .f = function(t) { 
          t %>% str_extract_all( "[-0-9.]{1,}(?=\\))") %>% 
          unlist()}) %>% as.numeric())


ui <- fluidPage(
  # title 
  titlePanel("Iowa Liquor Sales (Story County)"), 
  # navigation bar: two tabs are available
  navbarPage(title = "Result display", 
             # temporal tab
             tabPanel("Temporal", 
                      sidebarLayout(
                        sidebarPanel(
                          ## select time
                          dateInput("date", "Select Date", min = newdat$Date %>% min(), max = newdat$Date %>% max(), value = newdat$Date %>% min()),
                          ## select response
                          radioButtons("res", "Select variable:", 
                                       c("Sale (USD)" = "sale", 
                                         "Volume sold (Liters)" = "volume")),
                          ## slider for breaks
                          sliderInput("b", "Break of the histogram", min = 3, max = 100, value = 10)
                        ), 
                        mainPanel(
                          helpText("Here we present the histogram of the selected variable on the selected date"), 
                          plotOutput("plot1")
                        )
                      )
             ),
             # spacial tab
             tabPanel("Spacial", 
                      sidebarLayout(
                        ## city selection
                        sidebarPanel(
                          selectInput("city", label = "City:", 
                                      choices = unique(newdat$City), selected = "AMES"), 
                          radioButtons("res2", "Select variable:", 
                                       c("Sale (USD)" = "sale", 
                                         "Volume sold (Liters)" = "volume"))
                        ), 
                        ## map and responses
                        mainPanel(
                          helpText("Here we present the map of the selected city with the selected variable"),
                          leafletOutput("map")
                        )
                        
                      )
             )
             
  )
)

server <- function(input, output) {
  
  # for plot unber Temporal tab
  output$plot1 <- renderPlot({
    temp_dat <- newdat %>% filter(Date == input$date)
    if(nrow(temp_dat) >0) {
      if(input$res == "sale") {
        hist(temp_dat$`Sale (Dollars)`, col ="blue", breaks=input$b, 
             main = "Histogram of Sale (USD)", xlab = "Sale (USD)")
      } else {
        hist(temp_dat$`Volume Sold (Liters)`, col ="blue", breaks=input$b, 
             main = "Histogram of Volume Sold (Liters)", xlab = "Volume Sold (Liters)")
      }
    }
  })
  
  # for spacial dataset cleaning: store names are dirty, eg "Hyvee" and "HyVee"
  spacialSet <- reactive({ newdat %>% 
      filter(City == input$city) %>% 
      group_by(`Store Number`) %>% 
      summarise(`Sale (Dollars)` = `Sale (Dollars)` %>% sum(.,na.rm = T), 
                `Volume Sold (Liters)` = `Volume Sold (Liters)` %>% sum(.,na.rm = T)) %>% 
      dplyr::right_join(storeinfo) %>% 
      filter(!is.na(`Sale (Dollars)`))
  })
  # for plot under Spacial tab
#   output$map <-renderLeaflet({ 
#     if (input$res2=="sale") {
#       spacialSet() %>% 
#         leaflet()%>%
#         addTiles() %>%
#         addMarkers(lng = ~Long,
#                    lat = ~Lat,
#                    popup = ~paste("Store Name: ", spacialSet()$`Store Name`, "<br>",
#                                   "Sale (Dollars): ", spacialSet()$`Sale (Dollars)`, "<br>"), 
#                    clusterOptions = leaflet::markerClusterOptions())
#     } else{
#       spacialSet() %>% 
#         leaflet()%>%
#         addTiles() %>%
#         addMarkers(lng = ~Long,
#                    lat = ~Lat,
#                    popup = ~paste("Store Name: ", spacialSet()$`Store Name`, "<br>",
#                                   "Volume Sold (Dollars): ", spacialSet()$`Volume Sold (Liters)`, "<br>"), 
#                    clusterOptions = leaflet::markerClusterOptions())
#       
#     }
#   })
#   
# }

shinyApp(ui = ui, server = server)
