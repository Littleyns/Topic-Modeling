
### Created by Dennis Herhausen ###

# Load the packages
library(quanteda)
library(topicmodels)

##########################################################################

# Build a corpus
text <- c("Due to bad loans, the bank agreed to pay the fines",
          "If you are late to pay off your loans to the bank, you will face fines",
          "A new restaurant opened in downtown",
          "There is a new restaurant that just opened",
          "How will you pay off the fines for the bank?")

# Create the dfm
dtm <-dfm(text, tolower=TRUE, remove=stopwords("en"), 
          remove_punct=TRUE, remove_numbers = TRUE)
dtm

# Fit LDAs with two clusters
LDA_fit_2 <- convert(dtm, to = "topicmodels") %>% 
  LDA(k = 2, method="Gibbs")

# Get top five terms per topic
get_terms(LDA_fit_2, 5)

# Get top topic per document
get_topics(LDA_fit_2)

##########################################################################

# Load additional packages
library(quanteda.textmodels)
library(tidytext)
library(ggplot2)
library(dplyr)

# Create and reduce the dfm
dfm_movie <- dfm(data_corpus_moviereviews, 
             tolower=TRUE, remove=stopwords("en"), 
             remove_punct=TRUE, remove_numbers = TRUE)
dfm_movie <- dfm_trim(dfm_movie, min_termfreq = 50, max_docfreq = 50)

# Check the size of the dfm
dfm_movie

# Fit LDAs with 5 and 10 clusters
LDA_fit_5 <- convert(dfm_movie, to = "topicmodels") %>% LDA(k = 5, method="Gibbs")
LDA_fit_10 <- convert(dfm_movie, to = "topicmodels") %>% LDA(k = 10, method="Gibbs")

# Get top ten terms per topic
get_terms(LDA_fit_5, 10)
get_terms(LDA_fit_10, 10)

##########################################################################

# Cross validation with log-likelihood
logLik(LDA_fit_5)
logLik(LDA_fit_10)

# Extract the per-topic-per-word probabilities
ap_topics <- tidy(LDA_fit_10, matrix = "beta")

# Select the top ten terms per topic
ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Display the top ten terms per topic
ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()
