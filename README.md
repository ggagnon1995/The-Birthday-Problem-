# The Birthday Problem
# [Project 1: The Birthday Problem: Overview](https://www.scientificamerican.com/article/bring-science-home-probability-birthday-paradox/) 


* This is a common problem analyzed in statistics. It asks: how many people are needed in a room to have at least a 50% probability of two people sharing the same birthday? The answer is 23 people. 

* From a programming point of view there are two ways you can solve this problem. The first is directly coding in the math and the second is using defined functions. I solved the problem in R and Python using functions. In Stata I directly coded the math. 

* Once the problem is solved, I created three nearly identical graphs that match The Economist magazines line graph theme. 

* In Python I used the Random Module to generate both a single random birthday and many random birthdays. Using thse functions I ran 10,000 trials to generate a list of probabilities. Once I generated the probabilities I saved them into a data frame and displayed the solution. Python does not have a module that instantly produces The Economist themed graphs so each element was considered carefully and coded to match. To do this I used the Matplot, Seaborn, Numpy, and Scipy modules. Scipy was needed to spline the data in order to fit a smooth curve.

![](/Python_birthdayproblem_graph.png)

* In R, I used the plyr package to break my function down into manageable pieces. I first used the crossing() function to generate all possible combinations of random birthdays among 10,000 trials. I used the map() function to apply this to all elements in each vector and assigned a variable name to the probability of duplicate birthdays. After displaying the solution I generated the graph. R has a package for directly applying the economist theme, however some of the colouring was off. I had to find the colour codes for what's used in the other two graphs for an exact match. The npreg pakage was used to spline the data to fit a smoother curve, but the curve isn't as smooth as what the other two programs produced. 

![](/R_birthdayproblem_graph.png)

* In Stata, I simply coded in the math. I generated a variable representing the number of unique birthdays as a proportion of total birthdays and took the running product. Since this represents the probability that two people have different birthdays, I generated the final probability by subtracting this result from 1. Fortunately, Stata doesn't need an additional package to apply The Economist theme to its graphs. Little was needed to be done to generate this visual. 

![](/Stata_birthdayproblem_graph.png)

* The overall purpose of this is to show my ability to perform the same activity across different programmes in an exact manner. Python and R represent my knowledge on creating functions. Stata represents my mathematical understanding of basic probability. 
