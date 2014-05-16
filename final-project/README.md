Final Project
==============================

| **Name**  | Dinglin Huo  |
|----------:|:-------------|
| **Email** | dhuo@dons.usfca.edu |


###Project Dataset###

The dataset are obtained from The Heritage Foundation website, the dataset name is 2014 Index of Economic Freedom. mydataset contains 175 rows, representing 175 countries around the world, and 33 columns representing differents kinds of economical indicators, within there are different types of economic freedom indicators.

I cleaned my dataset and set the numeric values using `as.numeric()`, set the categorical value using `as.factor()` and get them ready for plotting.
also,I use `gsub()` to get ride of the non-readable characters in my coloumns, and set a `thousan_formatter` to prepare for axis text use,also I set the my variables to a global environment using `globalenv()` so all my plot could get access to this cleaned out dataset.

### Instructions ###

Packages I used for this project:
-library(ggplot2)
-library(shiny)
-library(grid)
-library(scales)
-library(reshape2)
-library(data.table)
-library(GGally)

### Introduction###
There are 4 types of Visualizations 

1. Scatter word plot
2. Scatterplot Matrix
3. Parallel  coordinates Plot
4. Bubble multiple plot


###Scatter Plot ###
---------------------------------------------

By using `shiny`package, I am able to put my data into function and pass it to plot. Here are the changes I made :
-use `geom_point()` for the base plot,set `jitter` to avoid overlap, 
-`geom_text()` to add Country Name for the scatters, set `jitter`avoid overlap.
-`annotate("text")` to add annotations on the background
-`scale_size_discrete` to "none" remove extra legend
-`scale_color_manual` to "Dark2" instead of default color, and give six Region consistent color during the interactivity. colors wont change when add/reduce regions.
- set breaks in `scale_x_continuous` with reasoanle ticks and label the x-axis by`thousand_formatter` to look more clean for the plot.
- change the panel grid color and linetype to `dotted`
- change the size of axis titles and make it bold
- change legend by`justification` and `position` and remove legend background.

my scatterplot is fairly telling the story of the dataset, since I plotted all the 177 countries in the dataset, without favoring to any aspect, to give an subjective view of the dataset, the page looks clean, I removed certain grids to reduce ink, also, I put the control bars and some annotation of the bottom of the plot, so give a bigger view of the plot itself,I added the name of each country on the plot, so its more easy to tell each countries performance under each indicator. the density of the dataset have small clusters in some area onthe plot, but as long as using filterring choice, filter out certain area, it become clear to read.Also with consistent color to each region, using filtering won't affect this.

The Visualiztion excels at showing an overview of the dataset, with multiple choice to change for the Y-axis, and with all 175 countries ploted out each time with their names,its very clear to find a trend or performance comparison for a single country, or for numbers of countries within one region, and we could see Qatar is always an outlier, and cluster on certain levels based on the Y-axis choice.

You could learn information by choose among all the freedom indicators, the Y -axis always show a positive relationship with the x-axis, you could see a positive trend along with the increase of GDP per capita, it represent with a high GDP per capita level, there is a higher degree of freedom on Freedom from corruption, investment freedom, financial freedom, etc. so it overally saying a richer country (per person) will bring a environment for economy(financially, legally,etc.) or vice versa.

###Interactivity###
----------------------------------------------------
Types of interactivity:
-Rationbutton()
-checkboxgroupinput()

To display the relationships between my X-Axis, "GDP Per Capita in Thousands", I put 6 different Economicc Freedom Indicators as Y -Axis, including for `checkboxgroupinput()` , they are : Freedom from Corruption, Fiscal Freedom, Business Freedom, Investment Freedom, Financial Freedom. by picking each different input, the plot will change too, it brings more information from the dataset to my visualiztion, and give the user a chance to see the performance under different Freedom levels, to compare and find relationship.and could see the movement of data under the choices.

By filterring the Regions of the countries, the user could get a clearer view of the plot, to avoid cluster,help out over plotting issue, would decreas/increase the density of my data, it could provide focus by single out each region to see their performance under each freedom indicators. could see under which one will they cluster, and read the area of cluster show the average performance of these countries under this indicator.

###First Visualiztion: Scatter Plot ###
--------------------------------------------------




