library(shiny)

data(movies)

shinyUI(
  pageWithSidebar(
    headerPanel("Movies Data"),
    
    sidebarPanel(
      radioButtons(
        "highLight",
        "MPAA Rating:",
        c("All", "PG", "PG-13", "R", "NC-17")
      ),
      
      checkboxGroupInput(
        "selectGenre",
        "Movie Genres:",
        c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short")
      ),
      sliderInput("dotSize", 
                  "Dot Size:", 
                  min = 1,
                  max = 10, 
                  value = 3,
                  step =1
      ),
      
      sliderInput("alphaSize", 
                  "Alpha Size:", 
                  min = .1,
                  max = 1, 
                  value = 0.9,
                  step = 0.1
      ),
      
      selectInput(
        "colorScheme",
        "Color Scheme:",
        choices = c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2")
      )
    ),
    mainPanel(plotOutput("scatterplot"), width = 7, height = 6)
  )
)