# Load the shiny package
library(shiny)
library(shinyDarkmode)
# Define UI for the application
ui <- fluidPage(
  use_darkmode(),
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What is your name?", "Dean"),
      numericInput("num", "Number of flowers to show data for",
                   10, 1, nrow(iris))
    ),
    mainPanel(
      textOutput("greeting"),
      plotOutput("cars_plot"),
      tableOutput("iris_table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  darkmode()
  # Create a plot of the "cars" dataset 
  output$cars_plot <- renderPlot({
    plot(cars)
  })
  # # Render a text greeting as "Hello <name>"
  # output$greeting <- renderText({
  #   paste("Hello", textInput$name)
  # })
  # 
  # # Show a table of the first n rows of the "iris" data
  # output$iris_table <- renderTable({
  #   head(iris, n = input$num)
  # })
}

# Run the application
shinyApp(ui = ui, server = server)
