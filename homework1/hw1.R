library(ggplot2) 
library(reshape2)

#Load dataset
data(movies) 
data(EuStockMarkets)

#Filter out any rows that have a budget value less than or equal to 0 in the movies dataset
movies$budgetinthousand <- movies$budget/1000
movies <- subset(movies, budget>0)

#Add a genre column to the movies dataset as follows:
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
movies$genre = genre
#Transform the EuStockMarkets dataset to a time series as follows:
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

#Plot 1: Scatterplot.
scatterplot <- ggplot(movies, aes(x =budgetinthousand, y =rating,
                                  group = factor(genre),
                                  color=factor(genre))) +
  geom_point(shape=13,size=1.5)+
  ggtitle("Movies Budget and Rating")+
  xlab("Budget in thousand ") +
  scale_x_continuous(labels=dollar) +
  ylab("Rating") 

print(scatterplot)
ggsave(file = "hw1-scatter.png", plot = scatterplot, dpi = 300, width = 9, height = 4.25)

#Plot 2: Bar Chart.
barplot <- ggplot(movies, aes(x = genre, y= ..count..,)) +
  geom_bar(aes(fill = factor(genre))) +
  ggtitle("Count of all the genres") +
  ylim(0,2000) +
  ylab("Count") +
  xlab("Genre") 

print(barplot)
ggsave("hw1-bar.png", width = 9, height = 4.25, dpi = 300)

#Plot 3: Small Multiples. 
facetplot <- ggplot(movies, aes(x= budgetinthousand, y= rating))+
  geom_point(aes( group = factor(genre),
                  color=factor(genre),
                  col=genre))+
  facet_wrap( ~ genre, ncol = 3) +
  theme(legend.position = "none") +
  ggtitle("Movies Ratings and Budget Comparison by Genres")+
  xlab("Budget in Thousand")+
  ylab("Rating")
  scale_x_discrete(breaks = seq(1, 9))
print(facetplot)
ggsave("hw1-multiples.png", width = 9, height = 4.25, dpi = 300)

#Plot 4: Multi-Line Chart

eu$time <- as.numeric(eu$time)
result <- melt(eu,
           id.vars = "time",
           variable.name = "Stock",
           value.name = "Price")


result$Stock<-as.factor(result$Stock)
multiline <- ggplot(result,aes(x = time, y = Price, col = Stock)) +
  geom_line() +
  ggtitle("Price over different European stocks") +
  ylab("Price") +
  xlab("Stock") +
  labs(colour= "Stock")
  
print(multiline)

ggsave("hw1-multiline.png", width = 9, height = 4.25, dpi = 300)