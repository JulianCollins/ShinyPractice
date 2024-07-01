# output$forecast_plot <- renderPlot({
#   plot(forecast_data())
# })
# Similarly, the renderTable() function tells the program to create a table based on the reactive expression we defined earlier. We use the tableOutput() function in the UI to display the table.
# 
# output$forecast_table <- renderTable({
#   forecast_data()$mean
# })
# Finally, we run the app using the shinyApp() function, with the UI and server arguments.
# 
# shinyApp(ui = ui, server = server)
# And that’s it! This program allows the user to choose a forecasting model, and then generates a plot and table with the predicted number of air passengers based on that model.
# 
# Here is the Full code block”

# Load required packages
library(shiny)
library(forecast)
library(ggplot2)
# Load AirPassengers dataset
data(AirPassengers)
# Define UI
ui <- fluidPage(
  
  # Title of the app
  titlePanel("AirPassengers Forecast"),
  
  # Sidebar with input controls
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "model", label = "Choose a model:",
                  choices = c("auto.arima", "ets", "holtwinters"))
    ),
    
    # Output plot and table
    mainPanel(
      plotOutput(outputId = "forecast_plot"),
      tableOutput(outputId = "forecast_table")
    )
  )
)
# Define server
server <- function(input, output) {
  
  # Reactive expression to create forecast based on selected model
  forecast_data <- reactive({
    if (input$model == "auto.arima") {
      fit <- auto.arima(AirPassengers)
      forecast(fit)
    } else if (input$model == "ets") {
      fit <- ets(AirPassengers)
      forecast(fit)
    } else {
      fit <- hw(AirPassengers)
      forecast(fit)
    }
  })
  
  # Output plot
  output$forecast_plot <- renderPlot({
    plot(forecast_data())
    #checkresiduals(forecast_data())
  })
  
  # Output table
  output$forecast_table <- renderTable({
    forecast_data()$mean
  })
}
# Run the app
shinyApp(ui = ui, server = server)
