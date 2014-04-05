library(ggplot2)
library(shiny)
library(scales)
data(movies)


  data("movies", package = "ggplot2")


  #Add genre to movies dataset
  genre <- rep(NA, nrow(movies))
  count <- rowSums(movies[, 18:24])
  genre[which(count > 1)] = "Mixed"
  genre[which(count < 1)] = "None"
  genre[which(count == 1 & movies$Action == 1)] = "Action"
  genre[which(count == 1 & movies$Animation == 1)] = "Animation"
  genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
  genre[which(count == 1 & movies$Drama == 1)] = "Drama"
  genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
  genre[which(count == 1 & movies$Romance == 1)] = "Romance"
  genre[which(count == 1 & movies$Short == 1)] = "Short"
  movies$genre = as.factor(genre)

submovies <- subset(movies, budget>0)
#Filter out any rows that have a non valid mpaa rating in mpaa column
submovies <- subset(movies, mpaa !="" )

thousand_formatter <- function(x) {
  return(sprintf("%dk", round(x / 1000)))
} 


getPlot <- function(localFrame, highLight="none", selectGenre="none", dotSize= "none", alphaSize="none",colorScheme="Default") {
  
  
  p <- ggplot(submovies, aes(x = as.numeric(budget), y =rating, color = mpaa, group = factor(genre)))+
    geom_point(size = dotSize, alpha = alphaSize) +
    xlab("Movies Budget in thousand") +
    ylab("Movie Rating") +
    ggtitle ("IMDB Movie Ratings") +
    scale_x_continuous(label = thousand_formatter) +
    theme(panel.grid.major.x = element_blank()) +
    theme(panel.grid.minor.y = element_blank()) +
    theme(axis.text.x = element_text(size = 12)) +
    theme(axis.title.x = element_blank()) +
    labs(fill = "Movie Genres") +
    theme(legend.position="bottom") +
    theme(legend.direction="horizontal") 

  if (colorScheme == "Accent") {
    p <- p +
      scale_color_brewer(palette = "Accent")
  }
  else if (colorScheme == "Set1") {
    p <- p  +
      scale_color_brewer(palette = "Set1")
  }
  else if (colorScheme == "Set2") {
    p <- p  +
      scale_color_brewer(palette = "Set2")
  }
  else if (colorScheme == "Set3") {
    p <- p  +
      scale_color_brewer (palette = "Set3")
  }
  else if (colorScheme == "Dark2") {
    p <- p  +
      scale_color_brewer(palette = "Dark2")
  }
  else if (colorScheme == "Pastel1") {
    localPlot <- localPlot +
      scale_colr_brewer(palette = "Pastel1")
  }
  else if (colorScheme == "Pastel2") {
    p <- p  +
      scale_color_brewer(palette = "Pastel2")
  }
  else {
    p <- p  +
      scale_color_grey(start = 0.4, end = 0.4)
  }
    
  return(print(p))
}

  
  ####Shiny Server #####
  shinyServer(function(input, output) {
    
    cat("Press \"ESC\" to exit...\n")
    localFrame <- submovies
    
   hightLightS <- reactive ({
     if (input$highLight == "All") {
       result <- c("PG", "PG-13", "R", "NC-17")
       return(result)
     }
     else {
       return(input$highLight)
     }
   })
   
   
    output$scatterplot <- renderPlot({
      print(getPlot(localFrame,
                    hightLightS(),
                    input$selectGenre,
                    input$dotSize,
                    input$alphaSize, 
                    input$colorScheme),
    width =400,height=400)
  })
})
# runApp()
#library(shiny)
#shiny::runGitHub('msan622', 'dhuo', 'homework2')
