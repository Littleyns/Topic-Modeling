
### Created by Dennis Herhausen ###

# Load the tidyverse package
library(tidyverse)

# If you run this code and get the error message "there is no package called 'tidyverse'", 
# you'll need to first install it, then run library() once again.

#######################################################################################

# Have a first look at the dataset
mpg

# Lear more about the dataset and open the "Help" tap
?mpg

# Load the dataset into your "Environment" tap
mpg <- mpg

#######################################################################################

# Correlate displ with hwy from the dataset mpg
cor(mpg$displ, mpg$hwy)

# Creating a first ggplot for displ and hwy from mpg in the "Plots" tab
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

#######################################################################################

# Adding different colors for different classes to your plot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
