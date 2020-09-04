#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(tidyr)
library(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel("EU Stocks"), 
    h3("Bernie Duplan"),
    h3("9/4/20"),
    
    sidebarLayout(
        sidebarPanel(
            h3("Select a timeframe for price increase/decrease"),
            sliderInput("slider1", "Timeframe", 1, 365, 1),
            h3("Timeframe:"),
            textOutput("text1")
        ),
    
        mainPanel(
            h3("EU Stock Market Closing Prices"),
            h5("Mouse-Over for price and percent change"),
            plotlyOutput(outputId = "plot1")
        )
    )
))
