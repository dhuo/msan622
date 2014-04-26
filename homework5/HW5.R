require(ggplot2)
require(reshape2)
require(grid)
require(scales)

source("data.R")
source("prettier.R")


mydata <- subset(molten, 
              variable != "distanced"&
                variable != "petrolp"&
                variable != "laweffect"&
                variable !="vank"
              )




### Stacked Area Plot

p <- ggplot(mydata,aes(x=time, y= as.numeric(value))) +
  geom_area(
  aes(group = variable,
    fill = variable,
    # swap stacking order
    order = -as.numeric(variable)
  )
)+
  scale_fill_brewer(palette ="Pastel2", name = 'Deaths by Roles') 
p <- p + ggtitle("Deaths by Car accident in UK from 1969-1985")
p <- p + scale_year()
p <- p + scale_SB()
p <- p + theme_legend()
p <- p + theme(panel.background = element_rect(fill="white",colour="black"),
              panel.grid.major.x = element_line(color="black",size=0.5,linetype="dotted"),
              panel.grid.minor.x = element_line(color="black",size=0.1,linetype="dotted"),
              panel.grid.major.y = element_line(color="black",size=0.5,linetype="dotted"),
              panel.grid.minor.y = element_line(color="black",size=0.1,linetype="dotted"),
              axis.text.x = element_text(size = 12),
              axis.text.y = element_text(size = 12),
              axis.title.x = element_blank()
              ) 
p <- p + annotate(
  "text", x = 1969.2 , y = 200 ,
  hjust = 0,vjust = 0, color = "grey40", size = 4,alpha=0.5,
  label = "driverkh: drivers killed or injured, frontkh: front seat passenger killed or injured, rearpkh: rear passenger killed or injured") 
              
            
p <- p + coord_fixed(ratio = 1 / 1000)


print(p)

###Heatmap
# sum up all the victims killed or hurt by car accident
SB$total <- SB$driverkh + SB$frontpkh + SB$rearpkh + SB$vank
##melt dataset for heatmap
mydata2 <- melt(
  SB,
  id = c("year", "month", "time")
)

mydata2 <- subset(mydata2,
                  variable != "distanced"&
                    variable != "petrolp"&
                    variable != "laweffect"&
                    variable !="vank" &
                    variable != "driverkh"&
                    variable != "frontpkh" &
                    variable != "rearpkh" 
                    )
##Creat heatmap plot
p2 <- ggplot(mydata2, 
  aes(x = month, y = year)
) +
  ggtitle('Death Heatmap From 1969 to 1984')
p2 <- p2 + geom_tile(
  aes(fill = as.numeric(value)), 
  colour = "white"
) 
p2 <- p2 + scale_prgn() 
p2 <- p2 + scale_months() + 
  scale_y_discrete(expand = c(0, 0)) + 
  theme_heatmap() 


p2<-p2+theme(plot.title = element_text(size=20),
             axis.text.x = element_text(size=15),
             axis.text.y = element_text(size=16),
             axis.title.x =element_blank(),
             axis.title.y =element_blank())

p2<-p2+coord_flip()
print(p2)

#### Star Plot
mydata3 <- melt(
  SB,
  id = c("year", "month", "time")
)
mydata3 <- subset(mydata3, variable =="total")
p3 <- ggplot(mydata3,
  aes(
    x = month, 
    y = as.numeric(value), 
    group = year, 
    color = year
  )
)
p3 <- p3 + geom_line(alpha = 0.7)
p3 <- p3 + ggtitle("UK total car accident deaths from 1969 to 1984")

# make it pretty
p3 <- p3 + scale_months()
p3 <- p3 + scale_SB()
p3 <- p3 + theme_legend()
p3 <- p3 + theme_guide()


p3 <- p3 + coord_fixed(ratio = 1 / 1000)
p3 <- p3 + facet_wrap(~ year,ncol = 4)
p3 <- p3 + theme(legend.position = "none")
p3 <- p3 + coord_polar()
p3 <- p3 + theme( axis.title.x =element_blank())
p3 <- p3 + theme( axis.title.y =element_blank())
print(p3)
