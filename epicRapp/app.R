#----------------------------------------------------------------------------------------------------------------------------------
# Author: Ainsleigh Hill
# Date created: September 29, 2017
# Date modified: September 29, 2017
# Purpose: Create Shiny web app from EpicR package
#----------------------------------------------------------------------------------------------------------------------------------

library(shiny)
library(ggplot2)
library(plotly)


options(shiny.error = function() {
  stop("")
}) # removes red error message from Shiny webpage


ui <- fluidPage(

  tags$head(
    tags$link(rel='stylesheet', type="text/css", href="sidebar.css")
  ),

  headerPanel("EPIC (Evaluation Platform in COPD)"),



  mainPanel(
    tabsetPanel(
      tabPanel("Annual Exacerbation Rates",
               sidebarLayout(
               sidebarPanel(
                 selectInput('population', 'Population', c('Entire population', 'COPD population')),
                 width = 5,
                 uiOutput("age.severity")
               ),
               mainPanel()
               ))
    )
  )

)



server <- function(input, output, session) {

  popOptions <- c("Entire population", "COPD population")

  output$age.severity <- renderUI({

    if (input$population==popOptions[1]) {
      list(selectInput('group', "Patient Group", c("All", "By Age Group")))

    } else if (input$population==popOptions[2]) {

      list(selectInput('group', "Patient Group", c("All", "By Age Group", "By Exacerbation Severity", "By GOLD Stage")))
    }

    })}

shinyApp(ui = ui, server = server)




