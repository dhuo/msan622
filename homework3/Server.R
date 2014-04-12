library(ggplot2)
library(scales)
library(reshape2)
library(shiny)
library(grid)
library(plyr)
library(data.table)
require(GGally)

# load the dataset as global data
loadData <- function() {
     data(state)
     # Trandform to data frame
	 df <- data.frame(state.x77,
                 State = state.name,
                 Abbrev = state.abb,
                 Region = state.region,
                 Division = state.division)
	df$Region <- as.factor(df$Region)
    df$Abbrev <- as.factor(df$Abbrev)
    df$Division <- as.factor(df$Division)
    # add population density variable
     colnames(df)[4] ="Life.Exp"
     colnames(df)[6] = "HS.Grad"
     # give all rows a 9th colunmn whish is popluation per square:Density
     df[,9] = df$Population *1000/df$Area
     colnames(df)[9] ="People.Density"
	 return(df)
}
# creat the bubbleplot first
# make small bubbles shown on top
df <- df[order(df$Murder, decreasing = TRUE),]

getPlot <- function(df, colorScheme,Regions) {
          # Create bubble plot
  if(length(Regions)<1){
    df<-df
  }
  else{
    df<-df[which(df$Region %in% Regions),]
  }
          p <- ggplot(df, aes(
          x = People.Density,
          y = Income,
          color = Region,
          size = Murder))
         # Give points some alpha to help with overlap/density
         # Can also "jitter" to reduce overlap but reduce accuracy
         p <- p + geom_point(alpha = 0.7, position = "jitter")

         # Default size scale is by radius, force to scale by area instead
         # Optionally disable legends
         p <- p + scale_size_area(max_size = 12, guide = "none")
         # Tweak the plot limits
         p <- p + scale_x_continuous(
          limits = c(-100, 1100),
          expand = c(0, 20))

          p <- p + scale_y_continuous(
          limits = c(2000, 7000),
          expand = c(0, 0))

          # Make the grid square
          p <- p + coord_fixed(ratio = 0.15)

          # Modify the labels
          p <- p + ggtitle("50 States")
          p <- p + labs(
          size = "Murder",
          x = "People.Density",
          y = "Income")

# Modify the legend settings
p <- p + theme(legend.title = element_blank())
p <- p + theme(legend.direction = "horizontal")
p <- p + theme(legend.position = c(0.3, 0))
p <- p + theme(legend.justification = c(0, 0))
p <- p + theme(legend.background = element_blank())
p <- p + theme(legend.key = element_blank())
p <- p + theme(legend.text = element_text(size = 12))
p <- p + theme(legend.margin = unit(0, "pt"))

# Force the dots to plot larger in legend
p <- p + guides(colour = guide_legend(override.aes = list(size = 8)))
p <- p+geom_text(aes(label = Abbrev,size=1.5,alpha=0.5),col="#1C0A0A", hjust =0.5, vjust=0)  


# Indicate size
p <- p + annotate(
  "text", x = 650, y = 6500,
  hjust = 0.5, color = "grey40",
  label = "Circle area is proportional to Murder") +
  scale_color_brewer(palette = colorScheme) 

  return(p)
}



# Scattermatrix plot
# Create scatterplot matrix

getPlotmatrix <- function(df,colorScheme,Regions) {
  if(length(Regions)<1){
    df<-df
  }
  else{
    df<-df[which(df$Region %in% Regions),]
  }
        p <- ggpairs(df, 
             # Columns to include in the matrix
             columns = 1:4,
             # "blank" to turn off
             upper = "blank",
             
             # What to include below diagonal
             lower = list(continuous = "points"),
             
             # What to include in the diagonal
             diag = list(continuous = "density"),
             
             # How to label inner plots
             # internal, none, show
             axisLabels = "none",
             
             # Other aes() parameters
             colour = "Region",
             title = "States Scatterplot Matrix"
)+
geom_point(alpha = 0.5)+
    labs(x="", y="") + scale_color_brewer(palette = colorScheme) + 
    theme(legend.background = element_blank()) +
    theme(legend.title = element_blank()) +
    theme(legend.key = element_blank()) +
    theme(panel.grid.minor.x=element_blank(),
          panel.grid.minor.y=element_blank()) +
    theme(legend.position = c(1, 1)) +
    theme(legend.justification = c(1, 1)) +
    theme(axis.ticks.x=element_blank()) + theme(axis.ticks.y=element_blank()) +
    scale_colour_discrete(limits = levels(df$Region))

# Remove grid from plots along diagonal
for (i in 1:4) {
  # Get plot out of matrix
  inner = getPlot(p, i, i);
  
  # Add any ggplot2 settings you want
  inner = inner + theme(panel.grid = element_blank());
  
  # Put it back into the matrix
  p <- putPlot(p, inner, i, i);
}
    
}

#### parallel coordinate plot
getPlotparallel <- function(df,colorScheme,Regions) {
  if(length(Regions)<1){
    df<-df
  }
  else if(length(Regions)<2){
   
    return(NULL)
  }
  else{
    df<-df[which(df$Region %in% Regions),]
    df$Region<-factor(df$Region)
  }
  p <- ggparcoord(data = df,                   
                  # Which columns to use in the plot
                  columns = 1:4,                   
                  # Which column to use for coloring data
                  groupColumn = 11,                                    
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
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb")) 
  # Move label to bottom and add plattte
  p <- p + theme(legend.position = "bottom") + scale_color_brewer(palette = colorScheme)
  # Figure out y-axis range after GGally scales the data
  min_y <- min(p$data$value)
  max_y <- max(p$data$value)
  pad_y <- (max_y - min_y) * 0.1  
  # Calculate label positions for each veritcal bar
  lab_x <- rep(1:4,times=2) # 2 times, 1 for min 1 for max
  lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = 4)  
  # Get min and max values from original dataset
  lab_z <- c(sapply(df[,1:4], min), sapply(df[,1:4], max))  
  # Convert to character for use as labels
  lab_z <- as.character(lab_z)  
  # Add labels to plot
  p <- p + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 3)

}


#creat Shiny
shinyServer(function(input, output) {
  df<-loadData()  
  output$Plot1 <- renderPlot({
    p<-getPlot(df,input$colorScheme,input$Regions)
    print(p)    
  })
  output$Plot2 <- renderPlot({
    p<-getPlotmatrix(df,input$colorScheme,input$Regions)
    print(p)    
  })
  output$Plot3 <- renderPlot({
    p<-getPlotparallel(df,input$colorScheme,input$Regions)
    print(p)    
  })
})