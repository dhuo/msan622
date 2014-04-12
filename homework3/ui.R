library(shiny)
library(ggplot2)

shinyUI(pageWithSidebar(

  
  headerPanel("50 States Panel"),
  
  # Sidebars
  sidebarPanel(
    checkboxGroupInput("Regions", "Region:",
                       c("Northeast" = "Northeast",
                         "North Central" = "North Central",
                         "South" = "South",  
                         "West" = "West"
                       )
    ),
    selectInput("colorScheme","Color Scheme:",
                c( "Paired", "Set2", "Set3", "Set1", "Pastel1", "Pastel2"),
                selected="Paired"
    )
  ),
  
  # Show the plots
  mainPanel(
    tabsetPanel(
      tabPanel("Bubble Plot",plotOutput("Plot1")),
      tabPanel("ScattterPlotMatrix",plotOutput("Plot2")),
      tabPanel("Parallel Plot",plotOutput("Plot3"))
    )
  )
))