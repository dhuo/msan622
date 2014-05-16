library(ggplot2)
library(shiny)
library(grid)
library(scales)
library(reshape)
library(data.table)
require(GGally)


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


df <- mydata
df <- df[order(df$PopinM, decreasing = TRUE),]
df <- subset(df,GDPGRate>0)
region_palette <- brewer_pal(palette='Dark2')(6)
# creat bubble plot

p <- ggplot (df,
             aes(x=Inflation,
                 y = WorldRank,
                 color = Region,
                 size=GDPGRate))

# help with overlap
p <- p + geom_point(alpha=0.8, position ="jitter") + facet_grid(.~ Region)

#size scale
p <- p + scale_size_area(max_size=14, guide ="none")
# plot limit
p <- p + geom_text(aes(label=Name),color="black",size =4,alpha=0.6,position="jitter", hjust= 0.5,vjust=-1)
p <- p + scale_x_continuous(
  limit= c(-1,24),
  #label=thousand_formatter,
  breaks=seq(-1,24,5),
  expand=c(0.1,0.1))
p <- p + scale_y_continuous(
  limits=c(0,190),
  breaks=seq(0,190,25),
  expand=c(0,0))
# make grid
p <- p + coord_fix(ratio=1)
# Modify the labels
p <- p + ggtitle("Economic Freedom World Rank ")
p <- p + labs(
  size = "Population in Millions")+
  xlab("Inflation Rate for Each Region")+
  ylab("Economic Freedom World Rank")

p <- p + theme_minimal()
# Modify the legend settings
# p <- p + theme(legend.title = element_blank())
# # p <- p + theme(legend.direction = "horizontal")
# # p <- p + theme(legend.position = c(0, 0))
# # p <- p + theme(legend.justification = c(0, 0))
# p <- p + theme(legend.background = element_blank())
# p <- p + theme(legend.key = element_blank())
# p <- p + theme(legend.text = element_text(size = 12))
# p <- p + theme(legend.margin = unit(0, "pt"))
p <- p + theme(legend.position ="none")
#p <- p + theme(panel.grid = element_blank())+
#p <- p +theme(axis.ticks=element_blank())
  #theme(axis.title.y=element_blank()) +
#p <- p +theme(axis.text=element_blank())
p <- p +theme(panel.grid.minor = element_blank()) 
  #theme(panel.border = element_blank())+
#p <- p +theme(panel.background= element_blank())
p <- p + scale_color_manual(values=region_palette)
p <- p + theme(panel.grid.major = element_line(color = "grey90"),
panel.background = element_rect(fill = NA),
legend.key= element_rect(fill = "Black"),
axis.title= element_text(size=16,face="bold"),
plot.title=element_text(size=18, face="bold"))

# Force the dots to plot larger in legend
# p <- p + guides(colour = guide_legend(override.aes = list(size = 8)))

# Indicate size is petal length
anontateText<-paste("Bubble Size is GDP Growth Rate")
p <- p + annotate("text", x = 12, y = 185,alpha=0.9, color = "navy", size=4,label = anontateText)

print(p)
