library(ggplot2)
library(shiny)
library(grid)
library(scales)
library(reshape)



loadData <- function(){
  mydata <- read.table("index2014_data1.csv",',', header=T,stringsAsFactors = F)

  return (mydata)
}



# bubble plot
BubblePlot<- function(data){
  plot <- data.frame(data)
  #Creat base plot
  p <- ggplot(plot, aes(x = as.numeric(GDPcapita),y = as.numeric(FreedomFCorruption),color = Region))
  p <- p + geom_point (alpha=0.6, position = 'jitter') + labs(color='Region')+xlab("GDP Per Capita")+ ylab("Freedom From Corruption Score out of 100")
  p <- p + geom_text(aes(label=Name,color=Region), hjust= 0.5,vjust=0)
  anontateText<-paste("")
  p <- p + annotate("text", x = 500, y = 4,hjust = 0.5,alpha=0.6, color = "grey40", size=4,label = anontateText)
  p <- p+ scale_size_discrete(guide ='none')
 
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

#Smalle Multiples
multiPlot <- function(data){
  plot1<- data.frame(data)
  p1 <- ggplot(plot1, aes(x=as.numeric(unemp.),y = as.numeic(inflation.),
                          color= Region))
  
  return(p1)
}
  



globalData<-loadData()


shinyServer(function(input, output){

  cat("Press \"ESC\" to exit...\n")
 data<- globalData
  
  
  
  output$plot1 <- renderPlot({
    plot1 <- BubblePlot(
      data
    )
    print(plot1)
  })
  
 output$multiPlot<- renderPlot({
   multiPlot<- multiPlot(
     data)
   print(multiPlot)
 })

  
  
})