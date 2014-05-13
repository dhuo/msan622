library(ggplot2)
library(shiny)
library(grid)
library(scales)
library(reshape)
library(data.table)


loadData <- function(){
  mydata <- read.csv("index2014_data1.csv",',',na.strings="N/A", header=T,stringsAsFactors = F)
  mydata$PopinM <- as.numeric(mydata$PopinM)
  mydata$FDIInflowM <- as.numeric(mydata$FDIInflowM)
  mydata$Name <- as.factor(mydata$Name)
  mydata$Region <- as.factor(mydata$Region)
  mydata$WorldRank <- as.numeric(mydata$WorldRank)
  mydata$RegionRank <- as.numeric(mydata$RegionRank)
  mydata$PropertyRights <- as.numeric(mydata$PropertyRights)
  mydata$PChangeFrom2013 <- as.numeric(mydata$PChangeFrom2013)
  mydata$InvestmentFreedom <- as.numeric(mydata$InvestmentFreedom)
  mydata$IFChangeFrom2013 <- as.numeric(mydata$IFChangeFrom2013)
  mydata$FinancialFreedom <- as.numeric(mydata$FinancialFreedom)
  mydata$FFChangeFrom2013.1 <- as.numeric(mydata$FFChangeFrom2013.1)
  mydata$GDPcapita<- as.numeric(mydata$GDPcapita)



  return (mydata)
}


mydata <- read.csv("index2014_data1.csv",',',na.strings="N/A", header=T,stringsAsFactors = F)

mydata$PopinM <- as.numeric(mydata$PopinM)
mydata$FDIInflowM <- as.numeric(mydata$FDIInflowM)
mydata$Name <- as.factor(mydata$Name)
mydata$Region <- as.factor(mydata$Region)
mydata$WorldRank <- as.numeric(mydata$WorldRank)
mydata$RegionRank <- as.numeric(mydata$RegionRank)
mydata$PropertyRights <- as.numeric(mydata$PropertyRights)
mydata$PChangeFrom2013 <- as.numeric(mydata$PChangeFrom2013)
mydata$InvestmentFreedom <- as.numeric(mydata$InvestmentFreedom)
mydata$IFChangeFrom2013 <- as.numeric(mydata$IFChangeFrom2013)
mydata$FinancialFreedom <- as.numeric(mydata$FinancialFreedom)
mydata$FFChangeFrom2013.1 <- as.numeric(mydata$FFChangeFrom2013.1)
mydata$GDPcapita<- as.numeric(mydata$GDPcapita)
assign("mydata$PopinM", mydata$PopinM, envir=globalenv())
assign("mydata$Name",mydata$name, envir=globalenv())
assign("mydata$Region", mydata$Region, envir= globalenv())
assign("mydata$WorldRank", mydata$WorldRank, envir= globalenv())
assign("mydata$RegionRank", mydata$RegionRank, envir= globalenv())
assign("mydata$FDIInflowM", mydata$FDIInflowM, envir=globalenv())
assign("mydata$PropertyRights", mydata$PropertyRights, envir=globalenv())
assign("mydata$PChangeFrom2013", mydata$PChangeFrom2013, envir=globalenv())
assign("mydata$InvestmentFreedom", mydata$InvestmentFreedom, envir=globalenv())
assign("mydata$IFChangeFrom2013", mydata$IFChangeFrom2013, envir=globalenv())
assign("mydata$FinancialFreedom", mydata$FinancialFreedom, envir=globalenv())
assign("mydata$FFChangeFrom2013.1", mydata$FFChangeFrom2013.1, envir=globalenv())
assign("mydata$GDPcapita", mydata$GDPcapita,envir=globalenv())


# Bubble plot

getPlot<- function(data,Highlight){
  #Creat base plot
  plot <- data.frame(data)
  p <- ggplot(plot, aes(x = GDPcapita,y = FreedomFCorruption,color = Region))
  p <- p + geom_point (alpha=0.6, position = 'jitter') + labs(color='Region')+xlab("GDP Per Capita")+ ylab("Freedom From Corruption Score out of 100")
  p <- p + geom_text(aes(label=Name,color=Region), hjust= 0.5,vjust=0)
  anontateText<-paste("")
  p <- p + annotate("text", x = 500, y = 4,hjust = 0.5,alpha=0.6, color = "grey40", size=4,label = anontateText)
  p <- p+ scale_size_discrete(guide ='none')
 
  # Theme
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + scale_x_continuous(limits = c(0, 102300))
  p <- p + scale_y_continuous(limits = c(0,100))
  p <- p+ theme(panel.grid.major = element_blank())
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(axis.text = element_blank(),
                 axis.title= element_text(size=18,face="bold"))
  p <- p + theme(axis.ticks = element_blank())
  
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
  

# let the load data share with global Data

globalData<-loadData()

# shiny Server function
shinyServer(function(input, output){

  cat("Press \"ESC\" to exit...\n")
 data<- globalData
  
 getHighlight <- reactive({
   result <- levels(data$Region)
   #         if(length(input$highlight) == 0) {
   #             return(result)
   #         }
   #         else {
   return(result[which(result %in% input$Highlight)])
   #         }
 })
 
 # Can control size if want
 output$scatterplot <- renderPlot(
{
  print(getPlot(getHighlight()))
}, 
width = 600,
height = 600)

  

  
 output$multiPlot<- renderPlot({
   multiPlot<- multiPlot(
     data)
   print(multiPlot)
 })

})
  
