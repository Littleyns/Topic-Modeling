
### Created by Dennis Herhausen ###

# Load the packages
library(quanteda)
library(quanteda.textmodels)
library(topicmodels)
library(readtext)
library(openxlsx)
library(ggplot2)

#######################################################################################

#Load example data from the readtext package (five inaugural speeches) into "dat_inaug"
path_data <- system.file("extdata/", package = "readtext")
dat_inaug <- readtext(paste0(path_data, "/csv/inaugCorpus.csv"), text_field = "texts")

# Construct a corpus of five inaugural speeches
corp_inaug <- corpus(dat_inaug)

# Summarize the information in the corpus 
summary(corp_inaug)

#######################################################################################

# read in "Social_Media_Data" as .tsv file 
(rt_smd <- readtext("C:/01 Teaching/KEDGE # Text Mining/Social_Media_Data.tsv", text_field = "TEXT"))
###Use your own folder!!!###

# Construct corpus of "Social_Media_Data"
data_smd <- corpus(rt_smd)

# Summary of "Social_Media_Data", showing 10 documents
summary(data_smd, n = 10)

#######################################################################################

# Summarize the information in the corpus 
summary(data_corpus_inaugural)

# Same as above but only 10 first entries
summary(data_corpus_inaugural, n = 10)

# Extract the last text, the inaugural speech of Donald Trump
texts(data_corpus_inaugural)[58]

#######################################################################################

# Store info from summary into "tokeninfo"
tokeninfo <- summary(data_corpus_inaugural)

# Longest inaugural speech (number of "tokens" = words)?
tokeninfo[which.max(tokeninfo$Tokens), ]

# Shortest inaugural speech (number of "tokens" = words)?
tokeninfo[which.min(tokeninfo$Tokens), ]

# Plot associations between "Year" and "Tokens" (Number of Words)
ggplot(data = tokeninfo, aes(x = Year, y = Tokens)) + 
  geom_line() + geom_point() + 
  scale_x_continuous(labels = c(seq(1789, 2017, 12)), 
                     breaks = seq(1789, 2017, 12))

#######################################################################################

# See in which context the word "future" was used
kw_future <- kwic(data_corpus_inaugural, pattern =  "future")
kw_future

# Search for phrase, increase window, and see in html
kw_bless <- kwic(data_corpus_inaugural, phrase("god bless"), window = 10)
View(kw_bless)

# Plot the pattern for "future" with absolute lenght
textplot_xray(kwic(data_corpus_inaugural, pattern = "future"), scale = "absolute")

#######################################################################################

# Use the text from the example
text <-  c(d1 = "A corpus is a set of documents.",
           d2 = "This is the second document in the corpus.")

# Convert text into a Document-Feature Matrix "as it is"
dtm1 <- dfm(text)
dtm1

# Convert text into a Document-Feature Matrix with preprocessing
dtm2 <- dfm(text, tolower=TRUE, remove=stopwords("en"), 
            remove_punct=TRUE, stem=TRUE)   
dtm2

# Inspect the stop words used 
stopwords("en")

#######################################################################################

# Convert inaugural speeches into a Document-Feature Matrix 
dtm_inaugural <- dfm(data_corpus_inaugural, 
                     tolower=TRUE, remove=stopwords("en"), 
                     remove_punct=TRUE, stem=TRUE)   
dtm_inaugural

#  Remove all terms for which the frequency is below 10
dtm_inaugural  = dfm_trim(dtm_inaugural, min_termfreq = 10)
dtm_inaugural

#######################################################################################

# Plot features of the inaugural speech as a wordcloud
data_corpus_inaugural %>%
  corpus_subset(President == "Obama") %>%
  dfm(remove = stopwords("en"), remove_punct=TRUE) %>%
  textplot_wordcloud(color = c("blue"))

data_corpus_inaugural %>%
  corpus_subset(President == "Trump") %>%
  dfm(remove = stopwords("en"), remove_punct=TRUE) %>%
  textplot_wordcloud(color = c("red"))

# Plot word keyness (words that occur differentially across the two presidents)
data_corpus_inaugural %>%
  corpus_subset(President %in%
                  c("Obama" , "Trump")) %>%
  dfm(groups = "President", remove = stopwords("en")) %>%
  textstat_keyness(target = "Trump") %>%
  textplot_keyness()

#######################################################################################

# Convert the last 20 speeches into a dfm according to the "party" 
dfmat_pres <- dfm(tail(data_corpus_inaugural, 20), groups = "Party", 
                  tolower=TRUE, remove=stopwords("en"), 
                  remove_punct=TRUE, stem=TRUE)

# We can sort this dfm, and inspect it:
dfm_sort(dfmat_pres)


# Convert the speeches since 1980 into a dfm
dfmat_inaug_post1980 <- dfm(corpus_subset(data_corpus_inaugural, Year > 1980),
                      tolower=TRUE, remove=stopwords("en"), 
                      remove_punct=TRUE, stem=TRUE)

# Calculate the cosine similarity between presidents
tstat_ot <- textstat_simil(dfmat_inaug_post1980, dfmat_inaug_post1980
                           [c("2009-Obama", "2013-Obama", "2017-Trump"), ], 
                           margin = "documents", method = "cosine")
tstat_ot
