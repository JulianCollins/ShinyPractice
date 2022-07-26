#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(plotly)
library(scales)

pcaSTPSnomedSupplierTrimmed <- readRDS("Data/pcaSTPSnomedSupplierTrimmed.Rds")


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("PCA Suppliers"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectizeInput("supplier",
                     "Select a Supplier",
                     choices = NULL)
    ),
    # second selector
    selectizeInput("supplier2",
                   "Select a Supplier",
                   choices = NULL)
  ),
  # 
  mainPanel(
    plotOutput("chapterNIC"),
    plotlyOutput("chapterNIC2")
  )
)



# 
server <- function(input, output, session) {
  updateSelectizeInput(
    session, 
    'supplier', 
    choices = pcaSTPSnomedSupplierTrimmed$SUPPLIER_NAME, 
    server = TRUE
  )
  
  updateSelectizeInput(
    session, 
    'supplier2', 
    choices = pcaSTPSnomedSupplierTrimmed$SUPPLIER_NAME, 
    server = TRUE
  )
  
  
  output$chapterNIC <- renderPlot(
    pcaSTPSnomedSupplierTrimmed %>% filter(SUPPLIER_NAME == input$supplier) %>% 
      ggplot(aes(chapTotNIC, reorder(BNF_CHAPTER, chapTotNIC), fill = YEAR_DESC)) +
      geom_col(position = position_dodge(), alpha = 0.8) +
      theme_light() +
      scale_x_continuous(labels = comma_format(prefix = "£")) +
      scale_fill_viridis_d(option = "E")
  )

  
  output$chapterNIC2 <- renderPlotly(
    ggplotly(
    pcaSTPSnomedSupplierTrimmed %>% filter(SUPPLIER_NAME == input$supplier2) %>% 
      ggplot(aes(chapTotNIC, reorder(BNF_CHAPTER, chapTotNIC), fill = YEAR_DESC)) +
      geom_col(position = position_dodge(), alpha = 0.8) +
      theme_light() +
      scale_x_continuous(labels = comma_format(prefix = "£")) +
      scale_fill_viridis_d(option = "E")
    )
  )
  

  
}

# Run the application 
shinyApp(ui = ui, server = server)


# library(shiny) library(ggplot2) library(ggthemes) library(plotly)  
# ui <- fluidPage(   titlePanel("Plotly"), sidebarLayout( sidebarPanel(), mainPanel(   plotlyOutput("plot2"))))    server <- function(input, output) {  output$plot2 <- renderPlotly({   ggplotly(
#   ggplot(data = mtcars, aes(x = disp, y = cyl)) +
#     geom_smooth(method = lm, formula = y~x) +
#     geom_point() +
#     theme_gdocs()) }) }  shinyApp(ui, server) 
