library(ggplot2)
library(shiny)
library(grid)
library(scales)
library(reshape)
library(data.table)
require(GGally)

#import and manage my dataset

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
region_palette <- brewer_pal(palette='Paired')(6)

# creat scatterplot matrix

p <- ggpairs(mydata,
              #coloumns include in matrix
              columns = c("PopinM","GDPinB","Inflation","GDPGRate","GDPcapita","FDIInflowM"),
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
              colour ="Region",
              params=list(corSize=1)
               )

# Remove grid from plots along diagonal
for (i in 1:6) {
  for(j in 1:6){
  # Get plot out of matrix
  inner <- getPlot(p, i, j)
  inner = inner + theme_bw()
  inner = inner + theme(panel.grid.major = element_line(color = "grey90"),
                         panel.background = element_rect(fill = NA),
                         legend.key= element_rect(fill = "Black"))
  inner <- inner + scale_color_manual(values=region_palette)
  # Add any ggplot2 settings you want
  #inner = inner + theme(panel.grid = element_blank())
#inner <- inner + theme(axis.ticks=element_blank())
inner = inner + theme(panel.grid.major = element_line(color = "grey90"),
panel.background = element_rect(fill = NA))
#inner <- inner + theme(axis.title.y=element_blank()) 
inner <- inner + theme(axis.text=element_blank())
inner <- inner + theme(panel.grid.minor = element_blank()) 
#inner <- inner + theme(panel.border = element_blank())
inner <- inner + theme(panel.background= element_blank(),
          axis.title= element_text(size=16,face="bold"),
          plot.title=element_text(size=18, face="bold"))
  
  

  # Put it back into the matrix
  p <- putPlot(p, inner, i, j)
  }
}



# Show the plot
print(p)
