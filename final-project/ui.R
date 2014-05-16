library (shiny)


shinyUI(     
  navbarPage("Countries Comparison Using Economic Indicators",
            tabPanel("Scatter Plot",hr(),
                      fluidPage(
                        headerPanel("Freedom Indicators vs. GDP Capita"),
                        
                        plotOutput('scatterplot', width='100%', height='100%'),
                        
                        fluidRow( hr(),
                          column(4,
                                 
                                 helpText(paste("These controls shows:",
                                                "Y Axis to different Degree of Freedom;",
                                                "X Aix is GDP per Capita;",
                                                "Regions can be filtered by Regiona Name"))
                                 ),
                          column(3,
                          radioButtons("yUI",
                                      'Choice of Y-Axis :',
                                      c('FreedomFCorruption','FiscalFreedom',
                                                'BusinessFreedom','LaborFreedom',"InvestmentFreedom","FinancialFreedom"),
                                      selected = c('InvestmentFreedom')
                                      )
                          ),
                          column(4,
                          checkboxGroupInput(
                            "Highlight",
                            "Choice of Region:",
                            c("Middle East / North Africa", "Sub-Saharan Africa","Europe","South and Central America / Caribbean",
                              "North America","Asia-Pacific"),
                            selected = c("Middle East / North Africa", "Sub-Saharan Africa","Europe","South and Central America / Caribbean",
                                         "North America","Asia-Pacific")
                        )
                        )
                      ),
                      br()
                      ),hr()),
#             tabPanel("Scatter Plot Matrix",
#                      headerPanel("ScatterPlot Matrix"),
#                      plotOutput("plot2")
#                        #mainPanel(
#                          #img(src = "Rplot.png", height = 400, width =400)
#                        #)
#                      ),
           tabPanel("Parallel Coordinate Plot",hr(),
                    headerPanel("Parallel Coordinate Matrix"),
                    plotOutput("plot3"),width ="100%",height ="800px",br(),hr()
                    ),
           tabPanel("Bubble Plot",hr(),
                    headerPanel("Economic Freedom World Rank"),
                    plotOutput("plot4"),width="100%",height="100%",br(),hr()
                    )

  ))

             


             
