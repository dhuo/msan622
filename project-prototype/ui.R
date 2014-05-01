library (shiny)


shinyUI(
  navbarPage('Countries Comparison Using Economic Indicators',
             tabPanel('Bubble Plot',
                      
                      pageWithSidebar(
                        headerPanel('Bubble_Plot'),
                        sidebarPanel(  
                          selectInput('SizeUI', 'Bubble Size Defined By:', choices=c('GDP.Billions.ppp','World.Rank','Fiscal.Freedom','Freedom.from.Corruption',
                                                                             'Business.Freedom','Labor.Freedom','Monetary.Freedom')),
                          selectInput('xUI', 'X:', choices=c('GDP.Billions.ppp','World.Rank','Fiscal.Freedom','Freedom.from.Corruption',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom')),
                          selectInput('yUI', 'Y:', choices=c('GDP.Billions.ppp','World.Rank','Fiscal.Freedom','Freedom.from.Corruption',
                                                                  'Business.Freedom','Labor.Freedom','Monetary.Freedom'))
                        ),
                       
                        mainPanel(  
                          tabPanel('Bubble_Plot', plotOutput('plot1'), width='200%', height='1000px'))
                      ))
             
                     )
             
  )