
### Created by Dennis Herhausen ###

# Load the packages
library(quanteda)
library(quanteda.textmodels)
library(topicmodels)
library(readtext)
library(openxlsx)
library(ggplot2)

#######################################################################################

# Create a new dictionary with four categories
dict <- dictionary(list(terrorism = 'terror*',
                        economy = c('econom*', 'tax*', 'job*'),
                        military = c('army','navy','military','airforce','soldier'),
                        freedom = c('freedom','liberty')))

# Use the dictionary to lookup categories in the speeches
dict_dtm <- dfm_lookup(dtm_inaugural, dict, exclusive=TRUE)

# Convert the output into a dataframe
df_inaugural <- convert(dict_dtm, to="data.frame")

# Inspect the dataframe with the output
View(df_inaugural)

# Convert the dataframe into a .csv file
write.csv(df_inaugural,'df_inaugural.csv')

# Convert the dataframe into a .xlxs file
write.xlsx(df_inaugural,'df_inaugural.xlsx')

#######################################################################################

# Use the laver-garry.cat dictionary
dict_lg <- dictionary(file = "C:/01 Teaching/KEDGE # Text Mining/laver-garry.cat", 
                      encoding = "UTF-8")
###Use your own folder!!!###

# Use the dictionary to lookup categories in the speeches
dict_dtm_lg <- dfm_lookup(dtm_inaugural, dict_lg, exclusive=TRUE)

# Convert the output into a dataframe
df_inaugural_lg <- convert(dict_dtm_lg, to="data.frame")

# Inspect the dataframe with the output
View(df_inaugural_lg)

# Convert the dataframe into a .xlxs file
write.xlsx(df_inaugural_lg,'df_inaugural_lg.xlsx')
