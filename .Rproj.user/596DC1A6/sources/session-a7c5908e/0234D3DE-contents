# install.packages("shiny")
library(shiny)

# library to install from Github
# install.packages("remotes")
# install shinyDarkmode
# remotes::install_github("deepanshu88/shinyDarkmode")
library(shinyDarkmode)


ui <- fluidPage(
  use_darkmode(),
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output) {
  # from shinyDarkmode
  darkmode()
  output$distPlot <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

shinyApp(ui = ui, server = server)



