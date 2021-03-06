library (shiny)


shinyUI(     
  navbarPage("Countries Comparison Using Economic Indicators",
            tabPanel("Scatter Plot",
                      pageWithSidebar(
                        headerPanel("Freemdom from Corruption vs. GDP Capita"),
                        sidebarPanel( 
                          selectInput('xUI', 'X-Axis Choice:', choices=c('GDPcapita','World.Rank','Fiscal.Freedom','FreedomFCorruption',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom')),
                          selectInput('yUI', 'Y-Axis Choice:', choices=c('FreedomFCorruption','World.Rank','Fiscal.Freedom','GDPcapita',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom')),
                          sliderInput("xlimUI","GDP Range:", min=0, max=102900, value=c(0.100))
                        ),
                       
                        mainPanel(  
                          tabPanel("Scatter Plot",
                                   plotOutput('plot1', width='90%', height='1000px'))
                          )
                      )
                      ),
            tabPanel("Multiple Plot",
                     sidebarPanel(
                       selectInput("MultiUI", "MultiPlot Choice :", choices=c('FreedomFCorruption','World.Rank','Fiscal.Freedom','GDPcapita',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom'))
                       ),
                     mainPanel("Scatter Plot Matrix", plotOutput("multiPlot", width = "100%",height = "1000px" ))
                     
                       

),
           tabPanel("Parallel Coordinate Plot"),
           tabPanel("Bar Plot")
))

             


             
