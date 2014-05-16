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

# Display parallel coordinate plot
print(p)