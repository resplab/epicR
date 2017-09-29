#----------------------------------------------------------------------------------------------------------------------------------
# Author: Ainsleigh Hill
# Date created: September 29, 2017
# Date modified: September 29, 2017
# Purpose: Create Shiny web app from EpicR package
#----------------------------------------------------------------------------------------------------------------------------------

library(shiny)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(epicR)
devtools::document()


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
               fluidRow(
               box(id="sidebarpop",
                 selectInput('population', 'Population', c('Entire population', 'COPD population')),
                 width = 4,
                 uiOutput("age.severity")
               ),
               box(id="mainpanelgraph",
                   title= "Exacerbation rate over time (across population)",status="primary",
                  plotlyOutput("age.severity.plots"), width=8
               )


              ))
    )
  )

)



server <- function(input, output, session) {

  popOptions <- c("Entire population", "COPD population")
  groupOptions <- c("All", "By Age Group", "By Exacerbation Severity", "By GOLD Stage")

  output$age.severity <- renderUI({

    if (input$population==popOptions[1]) {
      list(selectInput('group', "Patient Group", c("All", "By Age Group")))

    } else if (input$population==popOptions[2]) {

      list(selectInput('group', "Patient Group", c("All", "By Age Group", "By Exacerbation Severity", "By GOLD Stage")))
    }

  })

  output$age.severity.plots <- renderPlotly({

    exacerbation <- report_exacerbation_by_time_base()

    if (input$population==popOptions[1]) {

      if(input$group==groupOptions[1]){

        report_exacerbation_by_time_entire_all(exacerbation)

      } else if (input$group==groupOptions[2]) {

        report_exacerbation_by_time_entire_age(exacerbation)
      }

    } else if (input$population==popOptions[2]) {

      if(input$group==groupOptions[1]){
        report_exacerbation_by_time_copd_all(exacerbation)

      } else if (input$group==groupOptions[2]){
        report_exacerbation_by_time_copd_age(exacerbation)
      }
    }
  })

  }

shinyApp(ui = ui, server = server)




