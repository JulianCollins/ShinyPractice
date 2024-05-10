
library(shiny)
library(rio)
library(janitor)
library(plotly)
library(tidyverse)
library(scales)
library(zoo)


bgts_cgm_geog_icb <- readRDS("bgts_cgm_geog_icb.Rds")
  
glimpse(bgts_cgm_geog_icb)



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Blood Glucose Testing Strips & Continuous Glucose Monitors"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(

            selectizeInput("icb",
                        "Select ICB:",
                        choices = bgts_cgm_geog_icb$icb,
                        multiple = T
        )),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("line_nic")
        )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$line_nic <- renderPlotly({
      #
      sp <- bgts_cgm_geog_icb |> 
        filter(bnf_chemical_substance == "Glucose blood testing reagents") |> 
        filter(icb %in% input$icb) |> 
        group_by(bnf_chemical_substance, icb, year_month2) |> 
        summarise(net_ingredient_cost = sum(net_ingredient_cost)) |> 
        ungroup() 
        # 
      validate(
        need(input$icb, "Please select one or more ICB areas")
      )
     ggplotly(
        sp |> 
        ggplot(aes(x = year_month2, y = net_ingredient_cost, group = icb, colour = icb
                   )) +
        geom_line() +
        geom_point() +
        # geom_point(aes(text = paste0(icb, "\n",
        #                              year_month2, "\n",
        #                              bnf_chemical_substance, "\n",
        #                              net_ingredient_cost))) +
        theme_minimal() +
        scale_y_continuous(labels = comma, limits = c(0, NA)) +
        labs(x = "", y = "Net Ingredient Cost")) |> 
     #layout(tooltip = 'text', showlegend = F)
     layout(showlegend = F)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
