#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

pcaSTPSnomedSupplierTrimmed <- readRDS("data/pcaSTPSnomedSupplierTrimmed.Rds")


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

        # 
        mainPanel(
          plotOutput("chapterNIC")
          )
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
  
  
  output$chapterNIC <- renderPlot(
    pcaSTPSnomedSupplierTrimmed %>% filter(SUPPLIER_NAME == input$supplier) %>% 
      ggplot(aes(chapTotNIC, reorder(BNF_CHAPTER, chapTotNIC), fill = YEAR_DESC)) +
      geom_col(position = position_dodge(), alpha = 0.8)
  )
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
