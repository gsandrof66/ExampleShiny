library(shiny)
library(colourpicker)
library(wordcloud2)

ui <- fluidPage(
  h1("Word Cloud"),
  sidebarLayout(
    sidebarPanel(
      # Add a textarea input
      textAreaInput("text", "Enter text", rows = 7),
      numericInput("num", "Maximum number of words",
                   value = 100, min = 5),
      colourInput("col", "Background color", value = "white")
    ),
    mainPanel(
      wordcloud2Output("cloud")
    )
  )
)

server <- function(input, output) {
  output$cloud <- renderWordcloud2({
    # Use the textarea's value as the word cloud data source
    create_wordcloud(data = input$text, num_words = input$num,
                     background = input$col)
  })
}

shinyApp(ui = ui, server = server)