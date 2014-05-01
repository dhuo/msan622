library (shiny)


shinyUI(
  navbarPage('Countries Comparison',
             tabPanel('Bubble Plot',
                      pageWithSidebar(
                        headerPanel('Bubble Plot '),
                        sidebarPanel(  
                          selectInput('sizeUI', 'Bubble Size By:', choices=c('GDP.Billions.ppp','World.Rank','Fiscal.Freedom','Freedom.from.Corruption',
                                                                             'Business.Freedom','Labor.Freedom','Monetary.Freedom')),
                          selectInput('xUI', 'X:', choices=c('GDP.Billions.ppp','World.Rank','Fiscal.Freedom','Freedom.from.Corruption',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom')),
                          selectInput('yUI', 'Y:', choices=c('GDP.Billions.ppp','World.Rank','Fiscal.Freedom','Freedom.from.Corruption',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom'))
                        ),
                        mainPanel(  
                          tabPanel('Bubble Plot', plotOutput('bubPlot'), width='200%', height='800px'))
                      ))
             
                     )
             
  )