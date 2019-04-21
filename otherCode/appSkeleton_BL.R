#install.packages("shinythemes") to run code
shinyApp(
  ui = tagList(
    shinythemes::themeSelector(),
    navbarPage(
      # theme = "cerulean",  # <--- To set and use a specific theme, uncomment this
      "Story County Liquor Sales",
      tabPanel("Temporal",
               sidebarPanel(
                 fileInput("file", "File input:")
                 #textInput("txt", "Text input:", "general"),
                 #sliderInput("slider", "Slider input:", 1, 100, 30),
                 # tags$h5("Deafult actionButton:"),
                 # actionButton("action", "Search"),
                 
                 # tags$h5("actionButton with CSS class:"),
                 # actionButton("action2", "Action button", class = "btn-primary")
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Timeframe",
                            radioButtons("radio", label = h3("Timeframe by:"),
                                         choices = list("Year" = 1, "Month" = 2, "DOW = day of week" = 3), 
                                         selected = 1)
                            # h4("Table"),
                            # tableOutput("table"),
                            # h4("Verbatim text output"),
                            # verbatimTextOutput("txtout"),
                            # h1("Header 1"),
                            # h2("Header 2"),
                            # h3("Header 3"),
                            # h4("Header 4"),
                            # h5("Header 5")
                   )
                   # tabPanel("Tab 2", "This panel is intentionally left blank"),
                   # tabPanel("Tab 3", "This panel is intentionally left blank")
                 )
               )
      ),
      tabPanel("Spatial",
               sidebarPanel(
                 fileInput("file", "File input:")
                 #textInput("txt", "Text input:", "general"),
                 #sliderInput("slider", "Slider input:", 1, 100, 30),
                 # tags$h5("Deafult actionButton:"),
                 # actionButton("action", "Search"),
                 
                 # tags$h5("actionButton with CSS class:"),
                 # actionButton("action2", "Action button", class = "btn-primary")
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Geo-reference",
                            radioButtons("radio", label = h3("Geo-reference by:"),
                                         choices = list("City" = 1, "Zipcode" = 2), 
                                         selected = 1)
                   )
                 )
               )
      )   
      #tabPanel("Navbar 3", "This panel is intentionally left blank")
    )
  ),
  server = function(input, output) {
    output$txtout <- renderText({
      paste(input$txt, input$slider, format(input$date), sep = ", ")
    })
    output$table <- renderTable({
      head(cars, 4)
    })
  }
)