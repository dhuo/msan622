library(ggplot2)
library(shiny)
library(grid)
library(scales)
library(reshape)
library(data.table)
library(GGally)


mydata <- read.csv("index2014_data1.csv",',', header=T,stringsAsFactors = F)

mydata$PopinM <- as.numeric(mydata$PopinM)
mydata$FDIInflowM <- as.numeric(mydata$FDIInflowM)
mydata$Region <- as.factor(mydata$Region)
mydata$Name <- as.factor(mydata$Name)
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
assign("mydata$Name",mydata$Name, envir=globalenv())
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
mydata <- data.frame(mydata)
colnames(mydata) <- gsub("\\.", "", colnames(mydata))

thousand_formatter <- function(x) {
  return(sprintf("%dk", round(x / 1000)))
} 

# Bubble plot

getPlot<- function(df, Highlight, yUI){
  #Creat base plot
  datalevels <- levels(mydata$Region)
#  subset <- df[which(Highlight %in% datalevels)]
  subset <- subset(df, (mydata$Region %in% Highlight))



  p <- ggplot(subset,aes_string(x = "GDPcapita",y = yUI,color = "Region"))
  p <- p + geom_point (alpha= 0.8,position = 'jitter') +labs("Region")+ xlab("GDP Per Capita in Thousand")+ ylab("Freedom Score out of 100")
  p <- p + geom_text(aes(label=Name,color=Region),size =4,position="jitter", hjust= 0.5,vjust=0)
  anontateText<-paste("")
  p <- p + annotate("text", x = 500, y = 4,hjust = 0.5,alpha=0.8, color = "grey40", size=4,label = anontateText)
  p <- p+ scale_size_discrete(guide ='none')+
  scale_fill_discrete(name="Country Regions")


palette<-brewer_pal(type="qual",palette="Dark2")(6)
names(palette)<- levels(subset$Region)
colScale <- scale_color_manual(name ="Region",values=palette)
  p <- p +colScale
  # Theme
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + scale_x_continuous(limits=c(0,102300),
                              breaks=seq(0,102300,5000),
                              expand = c(0.1, 0.1),
                              label = thousand_formatter)
  p <- p + scale_y_continuous(limits = c(0,100),
                              expand = c(0.02, 0.02))


  p <- p+ theme(panel.grid.major = element_blank())
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(
                 axis.title= element_text(size=18,face="bold"))
  #p <- p + theme(axis.ticks = element_blank())

  
  p <- p + theme(
#     legend.direction = "horizontal",
#     legend.position = "top",
#     legend.position = c(2, 1),
#     legend.justification = c(1, 1),
    legend.justification=c(1,0),
    legend.position=c(1,0),
    legend.background = element_blank(),
    #legend.title = element_text(size = 12),
    legend.key = element_blank(),
    # Title appearance
    legend.title = element_text(size=13, face="bold")
  )
  
  return (p)
}


#Smalle Multiples

  
getPara <- function(){
  # parallel Cood
  p <- ggparcoord(mydata, 
                  
                  # Which columns to use in the plot
                  columns = c("GovSpending","PropertyRights","MonetaryFreedom","FreedomFCorruption","FiscalFreedom",
                              "LaborFreedom","BusinessFreedom","TradeFreedom","InvestmentFreedom",
                              "FinancialFreedom"), 
                  
                  # Which column to use for coloring data
                  groupColumn = "Region", 
                  
                  # Allows order of vertical bars to be modified
                  order = "anyClass",
                  
                  # Do not show points
                  showPoints = FALSE,
                  
                  # Turn on alpha blending for dense plots
                  alphaLines = 0.6,
                  
                  # Turn off box shading range
                  shadeBox = NULL,
                  
                  # Will normalize each column's values to [0, 1]
                  scale = "uniminmax" # try "std" also
  )
  
  # Start with a basic theme
  p <- p + theme_minimal()
  
  
  # Decrease amount of margin around x, y values
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.text.y = element_blank())
  
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  #legend
  p <- p + theme(legend.text = element_text(size=14))
  p <- p+  theme(legend.margin = unit(0, "pt"))
  #p <- p + guides(colour = guide_legend(override.aes =list(size = 4)))
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
  
  # Move label to bottom
  p <- p + theme(legend.position = "bottom")
  palette<-brewer_pal(type="qual",palette="Set1")(6)
  p<-p+scale_color_manual(values=palette) 
  p<-p+geom_point(size=2)
  p<-p+labs(title="Parallel Coordinate Matrix")
  
  return(p)
}

getScatter <- function(){
  region_palette <- brewer_pal(palette='Paired')(6)
  
  # creat scatterplot matrix
  
  p <- ggpairs(mydata,
               #coloumns include in matrix
               columns = c("PopinM","GDPinB","Inflation","GDPcapita","FDIInflowM"),
               legends= F,
               #upper blank
               upper=list(continuous="cor"),
               # What to include below diagonal
               lower = list(continuous = "smooth"),
               # What to include in the diagonal
               diag=list(continuous="density"), 
               # Other aes() parameters
               axisLabels ="none",
               title = "Scatterplot Matrix",
               colour ="mydata$Region",
               params=list(corSize=1)
  )
  
  # Remove grid from plots along diagonal
  for (i in 1:5) {
    for(j in 1:5){
      # Get plot out of matrix
      inner <- getPlot(p, i, j)
      
      inner <- inner + theme(panel.grid.major = element_line(color = "grey90"),
                             panel.background = element_rect(fill = NA))
      
      # Add any ggplot2 settings you want
      inner = inner + theme(panel.grid = element_blank())+
        theme(axis.ticks=element_blank())+
        theme(axis.title.y=element_blank()) +
        theme(axis.text=element_blank())+
        theme(panel.grid.minor = element_blank()) +
        theme(panel.border = element_blank())+
        theme(panel.background= element_blank())+
        scale_color_manual(values=region_palette)
      
      # Put it back into the matrix
      p <- putPlot(p, inner, i, j)
    }
  }
  return(p)
}


# let the load data share with global Data

globalData<-mydata

# shiny Server function
shinyServer(function(input, output){

  cat("Press \"ESC\" to exit...\n")
 localFrame<- globalData
 
getHighlight <- reactive({
  results<- input$Highlight
  return(results)
})

getxUI <- reactive({
  results<- input$xUI
  return(results)
})

getyUI <- reactive({
  results<- input$yUI
  return(results)
})

 # Can control size if want
 output$scatterplot <- renderPlot(
{ 
  scatterplot <- getPlot(mydata, getHighlight(), getyUI())
  
  print(scatterplot)
}, 
width = 1300,
height = 1300)

output$plot2<- renderPlot({
  q<- getScatter(
    )
  print(q)
})

output$plot3 <- renderPlot({
  q1<- getPara(
    )
  print(q1)
})
  


})
  
