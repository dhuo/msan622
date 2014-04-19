
require(tm)        # corpus
require(SnowballC)
require(wordcloud) # word cloud
require(ggplot2)
library(scales)
require("reshape")

sotu_source <- DirSource(
  directory= file.path("sotu"),
  encoding="UTF-8",
  pattern="*.txt", # file name pattern
  recursive = FALSE,
  ignore.case=FALSE # ignore case in pattern
  )

sotu_corpus <-Corpus(
  sotu_source,
  readerControl=list(
    reader=readPlain, # read as plain text
    language="en"))

# change text to lower levels use tm_map
sotu_corpus <- tm_map(sotu_corpus,tolower)

# remove intra word dash line
sotu_corpus<-tm_map(sotu_corpus, removePunctuation, preserve_intra_word_dashes = TRUE)

# remove stop words
sotu_corpus<- tm_map(sotu_corpus, removeWords,stopwords("english"))

# remove numbers
sotu_corpus <- tm_map(sotu_corpus, removeNumbers)

# getStemLanguages()
sotu_corpus<-tm_map(sotu_corpus, stemDocument, lang="english")

#remove specific word
sotu_corpus<-tm_map(sotu_corpus,removeWords,c("will","this","that","can","get","year","let","make","said"))

# remove white space
sotu_corpus<-tm_map(sotu_corpus,stripWhitespace)

#calculate frequencies
sotu_tmd<-TermDocumentMatrix(sotu_corpus)

#convert to freq format
sotu_matrix <- as.matrix(sotu_tmd)
sotu_df<-data.frame(
  word= rownames(sotu_matrix),
  freq= rowSums(sotu_matrix),
  stringsAsFactors= FALSE)

#sort by freq
sotu_df<-sotu_df[with(
  sotu_df,
  order(freq, decreasing=TRUE)),]
# remove rownames colounm

rownames(sotu_df)<- NULL

#View(sotu_df)


##Creat Bubble plot


# Creat Bubble plot for the first 20 word frequencies.
b_df <- head(sotu_df, 20)
b_df$word <- factor(b_df$word, 
                    levels = b_df$word, 
                    ordered = TRUE)


# Bubble plot
p<- ggplot(b_df, aes(x=word,y=freq,color=word,size=freq))+
  geom_point(alpha=0.6,position="identity")+  
  theme_bw()+
  theme(axis.title.x=element_text(face="bold"),
        axis.title.y=element_text(face="bold"),
        plot.title=element_text(face="bold",size=15))

p<-p+ scale_size_area(max_size=15,guide="none")
p<-p+ scale_y_continuous(limits=c(40,160),expand=c(0,0))
p<-p+ coord_fixed(ratio=1/10)
p<-p+ scale_x_discrete(expand=c(0,1))
p<-p+ ggtitle("State of the Union Address 2012 to 2014") +
  xlab("Top 20 Word Stems (Removed stop words)") +
  ylab("Frequency") +
  theme(axis.ticks = element_blank())
p<-p+ theme(legend.position = "none")
p<-p+ theme(axis.text.x=element_blank())
p<-p+ theme(panel.grid.minor.x = element_blank()) +
  theme(panel.grid.major.x = element_blank())
p<-p+  scale_fill_brewer()
p<-p+ geom_text(aes(label=word,size= 10,alpha=0.9),col="#000000",hjust=0.5)


print(p)



## Co-occurance frequency words plot

# http://stackoverflow.com/questions/17294824/counting-words-in-a-single-document-from-corpus-in-r-and-putting-it-in-dataframe

# Create a data frame comparing 2012 and 2014
freq_df <- data.frame(
  sotu2012 = sotu_matrix[, "sotu2012.txt"],
  sotu2014 = sotu_matrix[, "sotu2014.txt"],
  stringsAsFactors = FALSE)

rownames(freq_df) <- rownames(sotu_matrix)
# Alternatively, just look at top 20
freq_df <- freq_df[order(
  rowSums(freq_df), 
  decreasing = TRUE),]

freq20_df <- head(freq_df, 20)

# Plot frequencies
p <- ggplot(freq20_df, aes(sotu2012, sotu2014))

p <- p + geom_text(colour = "red",angle=45,size=3,
                   label = rownames(freq20_df),
                   position = position_jitter(
                     width = 2,
                     height = 2),hjust=0, vjust=0)+
  geom_abline(intercept=0,slope=1,color="navy")+
  theme_bw()+
  theme(axis.title.x=element_text(face="bold"),
        axis.title.y=element_text(face="bold"),
        plot.title=element_text(face="bold",size=15))

p <- p + xlab("Year 2012") + ylab("Year 2014")
p <- p + ggtitle("State of the Union top 20 word Frequency map")
p <- p + scale_x_continuous(expand = c(0, 0))

p <- p + scale_y_continuous(expand = c(0, 0))
p <- p + coord_fixed(
  ratio = 1, 
  xlim = c(0, 60),
  ylim = c(0, 55))

print(p)

## Word Cloud




# Create Wordcloud

colnames(freq_df) <-c("sotu2012","sotu2014")
new <- freq_df[apply(freq_df,1,sum) >10,]
new <- as.matrix(new)
max<-as.integer(dim(new)[1]*0.5)
comparison.cloud(new,
                 colors=brewer.pal(6,"RdBu"),
                 max.words=max,
                 scale=c(3,0.25),
                 random.order=F)



# dev.off()
