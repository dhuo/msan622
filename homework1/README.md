Homework 1: Basic Charts
==============================

| **Name**  | Dinglin Huo |
|----------:|:-------------|
| **Email** | dhuo@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `reshape2`

###Plot1: Scatterplot###

To run this code, need to use dataset 'movies', after set up the data, we could generate the plot with the following command in R:

```R
scatterplot <- ggplot(movies, aes(x =budgetinthousand, y =rating,
                                  group = factor(genre),
                                  color=factor(genre))) +
  geom_point(shape=13,size=1.5)+
  ggtitle("Movies Budget and Rating")+
  xlab("Budget in thousand ") +
  scale_x_continuous(labels=dollar) +
  ylab("Rating") 
```

#### Discussion ####
It is worth noticing from the graph generated get more density when the budget is in the lower section, and as the budget get higher, the ratings get centered in a rating range 5-8.
And I customize this R code with group the movies by their genres and display with different colours, to make it easier to tell which one have more density in certain budget level.
also, the geometry point shape I choose 13, and the size is 1.5. Also, I limit the x-axis by put the budget in thousands.
- [scatterplot](hw1-scatter.png)

###Plot2: Bar chart###

To genrate the chart with the following r code:

```R
barplot <- ggplot(movies, aes(x = genre, y= ..count..,)) +
  geom_bar(aes(fill = factor(genre))) +
  ggtitle("Count of all the genres") +
  ylim(0,2000) +
  ylab("Count") +
  xlab("Genre") 
```

#### Discussion####
It is obvious that the Mixed gener movie have the most counts among other movies, and the lowest counts goes to Animation.
I used 'ylim()' to limit the range from 0 to 2000, to be able to see the zero point of the count.
and use 'fill' to color the bars with different color by genres, consistent with the scatterplot color.
- [Barchart]{hw1-bar.png)

###Plot3: Small Multiples###

To generate the multiples with the following r code:

```R
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
```

#### Discussion####
The graph show under different genre topics, the rating performances varied by budget. as above, the colors are consistent.
I used 3 by 3 multiples, by 'scale_x_discrete' and color them by geners. and on the x axis, I showed the budget in thousand, which make them don't overlap each other.
- [SmallMultiples](hw1-multiples.png)

###Plot4: Multi lines###

To generate the multi lines with the following r code:

```R
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
```

#### Discussion####
This plot need to rearrange the data to three colomns 'time','stock','price'.So I rearrange the dataframe, and then plot them by differnt stock lines, color by different stock name use'col'.
And as we could see the SMI stock peaked in most recent data among others.
-[Multilines](hw1-multiline.png)

