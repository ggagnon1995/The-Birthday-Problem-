# The Birthday Problem
# [Project 1: The Birthday Problem: Overview](https://www.scientificamerican.com/article/bring-science-home-probability-birthday-paradox/) 


* This is a common problem analyzed in statistics. It asks: how many people are needed in a room to have at least a 50% probability of two people sharing the same birthday? The answer is 23 people. 

* From a programming point of view there are two ways you can solve this problem. The first is directly coding in the math and the second is using defined functions. I solved the problem in R and Python using functions. In Stata I directly coded the math. 

* Once the problem is solved, I created three nearly identical graphs that match The Economist magazines line graph theme. 

## Python 

* In Python I used the Random Module to generate both a single random birthday and many random birthdays. Using thse functions I ran 10,000 trials to generate a list of probabilities. Once I generated the probabilities I saved them into a data frame and displayed the solution. Python does not have a module that instantly produces The Economist themed graphs so each element was considered carefully and coded to match. To do this I used the Matplot, Seaborn, Numpy, and Scipy modules. Scipy was needed to spline the data in order to fit a smooth curve.

#### Import libraries for generating the solution 

```python
from random import randint
import pandas as pd
```

#### Create some variables that we need 

```python
min_people = 2
max_people = 100
possible_bdays = 365
```

#### Define a function that produces a random birthday 

```python
def produce_rand_bday():
    bday = randint(1, possible_bdays)
    return bday
```

#### Use the random birthday function to define a function that produces many random birthdays 

```python
def produce_n_bdays(n):
    bdays = [produce_rand_bday() for _ in range(n)]
    return bdays
```

#### Define a function that produces coincident birthdays 

```python
def coincident_bdays(bdays):
    unique_bdays = set(bdays)
    
    num_bdays = len(bdays)
    num_unique_bdays = len(unique_bdays)
    same_bday = (num_bdays != num_unique_bdays)
    
    return same_bday
```

#### Perform multiple trials and calculate the probabilities

```python
trials = 10000
num_coincidents = 0 
```

##### Here, we have the probability any two people have the same birthday 

```python
def prob_estimate_n(n):
    num_coincidents = 0
    for _ in range(trials):
        bdays = produce_n_bdays(n)
        same_bday = coincident_bdays(bdays)
        if same_bday:
            num_coincidents += 1
            
    prob_same_bday =  num_coincidents / trials
    return prob_same_bday 
```

##### Here, we have a list of n probabilities that any two people have the same birthday 

```python
def prob_estimate_for_range(nr):
    n_probabilities = []
 
    for n in nr:
        prob_same_bday = prob_estimate_n(n)
        n_probabilities.append(prob_same_bday)
         
    return n_probabilities
```

```python
nr = range(min_people, max_people + 1)
n_probabilities = prob_estimate_for_range(nr)
```

#### Before making a graph, here is proof that you need 23 people for a probability of at least 50%

```python
people_in_room = pd.Series(nr, name = 'n')
probability_of_same_bday = pd.Series(n_probabilities, name='probability')
df = pd.concat([people_in_room, probability_of_same_bday], axis=1)
df = df.iloc[18:28,:] 
df
```

#### Save this table as an image 

```python
import matplotlib.pyplot as plt
from pandas.plotting import table 
```

```python
ax = plt.subplot(111, frame_on=False) # no visible frame
ax.xaxis.set_visible(False)  # hide the x axis
ax.yaxis.set_visible(False)  # hide the y axis

table(ax, df)  # where df is your data frame

plt.savefig('mytable.png')
```

![](/mytable.png)

#### Now we can plot the results, matching The Economist theme requires additional packages and many tweeks

```python
import seaborn as sns
import matplotlib.ticker as mtick
import numpy as np
from scipy.signal import savgol_filter
```

```python
fig, prob_plot = plt.subplots(figsize=(5.5, 5.5), dpi=100, facecolor='#c6d3df') # basic figure
prob_plot.set_facecolor('#c6d3df')
hfont = {'fontname':'Verdana'}

# adjust the axis to match the theme
prob_plot.xaxis.set_tick_params(width=1.5, length=5, direction="in")
prob_plot.set(xlim=(-5,105), 
     ylim=(-0.04,1.05),
     xticks=[0,10,20,30,40,50,60,70,80,90,100], # set axis values 
     yticks=[0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]) 
prob_plot.yaxis.set_ticks_position("right")  # economist puts y label on the right
prob_plot.yaxis.set_label_position("right")
prob_plot.yaxis.set_major_formatter(mtick.PercentFormatter(1.0))
prob_plot.yaxis.grid(color='white', which='major') # they only use y axis grid lines 
plt.axhline(y=0, color='white') # there is a horizontal line missing at y=0 
prob_plot.tick_params(axis='y', pad=15) # the y-axis labels should not touch the grid lines, shift right

y_new = savgol_filter(n_probabilities, 51, 3) # make a smooth line

sns.lineplot(x=nr, y=y_new, lw=4, color='#3e647d', solid_capstyle='round') # make the line ends rounded

# adjust the axis lines in terms of length and visibility 
prob_plot.spines['top'].set_visible(False) 
prob_plot.spines['right'].set_position(('data', 100.01))
prob_plot.spines['right'].set_visible(False)
prob_plot.spines['bottom'].set_position(('data',-0.04))
prob_plot.spines['left'].set_visible(False)

# labels and other 
plt.plot([23, 23], [-0.04, 1.05], lw=1.5, color='#C91D42', alpha=0.3) # add the red line at the solution
plt.xlabel('Number of people in the room', fontsize=14, **hfont)
plt.ylabel('Probability two people share the same birthday', fontsize=14, rotation=90, **hfont)
plt.title("The Birthday Problem", fontsize=22, fontweight='bold', loc="left", pad=15, **hfont) 
plt.tick_params(right = False, bottom = True)
plt.yticks(fontsize=14, **hfont)
plt.xticks(fontsize=14, **hfont)

plt.savefig('Python_birthdayproblem_graph.png',bbox_inches='tight')  

plt.show()
```

![](/Python_birthdayproblem_graph.png)

## R

* In R, I used the plyr package to break my function down into manageable pieces. I first used the crossing() function to generate all possible combinations of random birthdays among 10,000 trials. I used the map() function to apply this to all elements in each vector and assigned a variable name to the probability of duplicate birthdays. After displaying the solution I generated the graph. R has a package for directly applying the economist theme, however some of the colouring was off. I had to find the colour codes for what's used in the other two graphs for an exact match. The npreg pakage was used to spline the data to fit a smoother curve, but the curve isn't as smooth as what the other two programs produced. 

#### First, import the relevent libraries and set the theme for The Economist styled graph 

```
install.packages(c("ggplot2", "plyr", "tidyverse", "ggthemes", "extrafont"))
library(ggplot2)
library(plyr)
library(tidyverse)
library(ggthemes)
library(extrafont)
library(npreg)

# Apply the economist theme
theme_set(theme_economist())
```

### Now create a function that simulates the probelm 

```
simulation <- crossing(people = seq(2, 100, 1),
                       trial = 1:10000) %>%
  mutate(bday = map(people, ~ sample(365, ., replace = TRUE)),
         multiple = map_lgl(bday, ~ any(duplicated(.)))) %>%
  group_by(people) %>%
  summarize(probability = mean(multiple))

summary(simulation)

```
#### Before plotting, display the solution 

```
solution <- subset(simulation, probability >= 0.45)
print("The Solution")
print(solution)

   people probability
 
 1     22       0.472
 2     23       0.503
 3     24       0.544
 4     25       0.570
 5     26       0.597
 6     27       0.631
 7     28       0.656
 8     29       0.682
 9     30       0.704
10     31       0.723

```

#### Before plotting, the data needs a spline interpolation to fit a smoother curve 

```
spline.df <- as.data.frame(spline(simulation$people, simulation$probability))
```

#### Set up the plot, adjustments need to be made for as close to an exact match as possible (despite The Economist theme) 

```
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

```

![](/R_birthdayproblem_graph.png)

## Stata

* In Stata, I simply coded in the math. I generated a variable representing the number of unique birthdays as a proportion of total birthdays and took the running product. Since this represents the probability that two people have different birthdays, I generated the final probability by subtracting this result from 1. Fortunately, Stata doesn't need an additional package to apply The Economist theme to its graphs. Little was needed to be done to generate this visual. 

![](/Stata_birthdayproblem_graph.png)

* The overall purpose of this is to show my ability to perform the same activity across different programmes in an exact manner. Python and R represent my knowledge on creating functions. Stata represents my mathematical understanding of basic probability. 
