library(shiny)
library(shinyDarkmode)
library(glue)
library(data.table)
library(dplyr)
library(plotly)
library(janitor)
library(DT)

df <- fread("https://query.data.world/s/evttstxtsvrim4mmge5ycs5gpil2nb?dws=00000") |> 
  filter(`Country/Region` == "United Kingdom")

df <- df |> select(-Lat, -Long) |>
  melt(id.vars = c(1,2), variable.name = "dates", value.name = "amount", variable.factor=F) |> 
  mutate(dates = as.IDate(dates, format = "%m/%d/%y")) |> 
  clean_names() |> 
  dplyr::select(-country_region) |> 
  arrange(dates)

ui <- fluidPage(
  use_darkmode(),
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What is your name?", "G"),
      dateRangeInput("dtRange", "Select Date Range:",
                     start = min(df$dates), end = max(df$dates)),
      selectInput("ddRegion", "UK Region:", 
                  choices = c("All", sort(unique(df$province_state)))),
      numericInput("num", "Number of rows to show data for",
                   5, 1, 20)
    ),
    mainPanel(
      textOutput("greeting"),
      plotlyOutput("ts_plot"),
      DT::dataTableOutput("pts_table")
      # tableOutput("ts_table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  darkmode()
  
  filtered_data <- reactive({
    # temp dataset
    if(input$ddRegion == "All"){
      tdf <- df |> filter(between(dates, as.IDate(input$dtRange[1]), as.IDate(input$dtRange[2])))
    }else{
      tdf <- df |> filter(province_state == input$ddRegion,
                          between(dates, as.IDate(input$dtRange[1]), as.IDate(input$dtRange[2])))
    }
    return(tdf)
  })
  
  # Create a plot of the "cars" dataset 
  output$ts_plot <- renderPlotly({
    plot_ly(filtered_data(), x = ~dates, y = ~amount, 
            type = 'scatter', mode = 'lines+markers') |>
      layout(title = "Time Series Plot",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Value"))
  })
  
  # Render a text greeting as "Hello <name>"
  output$greeting <- renderText({
    glue("Hello {input$name}, you selected {input$ddRegion}")
  })
  
  # output$ts_table <- renderTable({
  #   filtered_data() |> head(input$num)
  # })
  output$pts_table <- DT::renderDataTable({
    filtered_data()
  }, options = list(pageLength = input$num))  # Set number of rows per page
  
}

# Run the application
shinyApp(ui = ui, server = server)