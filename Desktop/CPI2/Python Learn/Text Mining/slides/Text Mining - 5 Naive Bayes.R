
### Created by Dennis Herhausen ###

# 1. Training set to train the classifier
# 2. Validation/Test set to validate the classifier
# 3. Additional data to use the classifier

# Load the packages
library(quanteda)
library(quanteda.textmodels)
library(caret)
library(openxlsx)

#######################################################################################

# Convert the corpus of 2000 movie reviews into a dataframe
data_moviereviews <- convert(data_corpus_moviereviews, to="data.frame")

# Split the dataframe
data_movie_neg1 <- data_moviereviews[1:500, ]
data_movie_neg2 <- data_moviereviews[501:1000, ]
data_movie_pos1 <- data_moviereviews[1001:1500, ]
data_movie_pos2 <- data_moviereviews[1501:2000, ]

# Combine the dataframes
data_movie1 <- rbind(data_movie_neg1, data_movie_pos1)
data_movie2_wr <- rbind(data_movie_neg2, data_movie_pos2)

# Remove sentiment rating from the second dataset
data_movie2 = subset(data_movie2_wr, select = -c(sentiment))

# Convert dataframes into two corpi
corp_movies1 <- corpus(data_movie1)
corp_movies2 <- corpus(data_movie2)

#######################################################################################

# Generate 500 numbers without replacement
id_train <- sample(1:1000, 500, replace = FALSE)
head(id_train, 10)

# Create docvar with ID
corp_movies1$id_numeric <- 1:ndoc(corp_movies1)

# Get training set from corp_movies1
dfmat_training <- corpus_subset(corp_movies1, id_numeric %in% id_train) %>%
  dfm(remove = stopwords("english"), stem = TRUE)

# Get test set set from corp_movies1 (documents not in id_train)
dfmat_test <- corpus_subset(corp_movies1, !id_numeric %in% id_train) %>%
  dfm(remove = stopwords("english"), stem = TRUE)

# Get additional data from corp_movies2
dfm_add <- dfm(corp_movies2, remove = stopwords("english"), stem = TRUE)

#######################################################################################

# Train the naive Bayes classifier
tmod_nb <- textmodel_nb(dfmat_training, dfmat_training$sentiment)
summary(tmod_nb)

# Only consider features that occur in the training set and in the other sets
# Make the features identical using dfm_match()
dfmat_matched <- dfm_match(dfmat_test, features = featnames(dfmat_training))
dfm_matched <- dfm_match(dfm_add, features = featnames(dfmat_training))

# Inspect how well the classification worked
actual_class <- dfmat_matched$sentiment
predicted_class <- predict(tmod_nb, newdata = dfmat_matched)
tab_class <- table(actual_class, predicted_class)
tab_class

# Use the confusion matrix to assess the performance of the classification
confusionMatrix(tab_class, mode = "everything")

# Use the trained naive Bayes classifier on a new data set
prediction_add <- predict(tmod_nb, newdata = dfm_matched)

# Add prediction to new data set
corp_movies2$predicted_sentiment <- prediction_add

# Convert the corpus into data frame and inspect it 
data_movie_add <- convert(corp_movies2, to="data.frame")
View(data_movie_add)
