###############################################################################
# File: The Birthday Problem 
# Date: May 25 2022 
# Author: Georgie Gagnon , gagnongeorgie@gmail.com
###############################################################################
# Set up 
rm(list=ls()) 
# load packages
# install.packages(c("ggplot2", "plyr", "tidyverse", "ggthemes", "extrafont"))
library(ggplot2)
library(plyr)
library(tidyverse)
library(ggthemes)
library(extrafont)
library(npreg)

# Apply the economist theme
theme_set(theme_economist())

###############################################################################
# Run a simulation with 2-101 people and 10,000 trials
simulation <- crossing(people = seq(2, 100, 1),
                       trial = 1:10000) %>%
  mutate(bday = map(people, ~ sample(365, ., replace = TRUE)),
         multiple = map_lgl(bday, ~ any(duplicated(.)))) %>%
  group_by(people) %>%
  summarize(probability = mean(multiple))

summary(simulation)

###############################################################################
# Display the solution 
solution <- subset(simulation, probability >= 0.5)
print("The Solution")
print(solution)

###############################################################################
# Generate a graph that matches what The Economist would publish

# First we need a spline interpolation to fit a smooth curve 
spline.df <- as.data.frame(spline(simulation$people, simulation$probability))

# First open a png file 
png("R_birthdayproblem_graph.png", width = 550, height = 550)

# Create the graph
ggplot(data = spline.df, aes(x = x, y = y)) +
  geom_line(color = "#3e647d", size = 2.5, lineend = "round") +
  geom_vline(xintercept = 23,  color = "#C91D42", linetype = "solid", alpha=0.3) +
  scale_y_continuous(labels = scales::percent_format(), position = "right",
                     breaks=seq(0,1,0.1)) +
  scale_x_continuous(breaks=seq(0,100,10)) +
  labs(title = "The Birthday Problem",
       y = "Probability two people share the same birthday\n", 
       x = "Number of people in the room\n") + 
  theme(text=element_text(family = "Verdana"),
        axis.title.y.right = element_text(size = 20, angle=90),
        axis.title.x.bottom = element_text(size = 20, vjust = -2),
        axis.text.y.right = element_text(size=20),
        axis.text.x.bottom = element_text(size=20, vjust = 2),
        plot.title = element_text(size=28, vjust=3),
        panel.background = element_rect(fill = "#c6d3df",
        colour = "#c6d3df", size = 0.5, linetype = "solid"),
        plot.background = element_rect(fill = "#c6d3df"), 
        plot.margin = margin(1,0,0,0.5, "cm"))
        
# Save it 
dev.off()





