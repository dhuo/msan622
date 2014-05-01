library(ggplot2)
library(shiny)
library(grid)




loadData <- function(){
  mydata <- read.csv("index2014_data.csv" ,  ',' , header=T)


  return (mydata)
}


BubblePlot<- function(economic_data){
  plot <- data.frame(economic_data)
  #Creat base plot
  p <- ggplot(plot, aes(x = GDP.Billions.ppp,y = Freedom.from.Corruption,color = as.factor(Region),size = Population.Millions))
  p <- p + geom_point (alpha=0.6, position = 'jitter') + labs(color='Region')+ labs(size='World rank')
  anontateText<-paste("Circle area is proportional to World Rank")
  p <- p + annotate("text", x = 30, y = 4,hjust = 0.5,alpha=0.6, color = "grey40", size=4,label = anontateText)

  p<- p + theme(panel.background = element_rect(fill = NA))
  p <- p+ theme(panel.grid.major = element_blank())
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(axis.text = element_blank())
  p<- p + theme(axis.ticks = element_blank())
  p <- p + theme(
    legend.direction = "horizontal",
    legend.position = "bottom",
    legend.position = c(1, 1),
    legend.justification = c(1, 1),
    legend.background = element_blank(),
    legend.title = element_text(size = 11),
    legend.key = element_blank()
  )
  return (p)
}




globalData<-loadData()

shinyServer(function(input, output){
  
  cat("Press \"ESC\" to exit...\n")
  data <- globalData
  
  
  
  output$plot1 <- renderPlot({
    plot1 <- BubblePlot(
      economic_data
    )
    print(plot1)
  })
  

  
  
})