********************************************************************************
*  File:    The Birthday Problem
*  Date:    24-May-2022
*  Author:  Georgie Gagnon, gagnongeorgie@gmail.com
********************************************************************************
*  Question: How many people do you need in a room to make the probability at 
*  least 50% for two people to share the same birthday?
********************************************************************************
* Create the observations 
clear
set obs 99

* we need at least 2 people in a room for the first observation
gen n = _n + 1
* we now have 2-100 people in a room 

* Create a variable representing the number of unique birthdays
gen u = 365 - _n

* Create a variable representing the number of unique birthdays
* as a proportion of the total number of unique birthdays 
gen pu = u/365

* Create the running product of pu 
* ie. it should look like (364/365)(363/365)(362/365)
* this is the probability that any 2 people have different birthdays
gen probdiff = exp(sum(ln(pu)))

* Then the probability that any 2 people have the same birthday is 1 - probdiff
gen probsame = 1 - probdiff

********************************************************************************
* Flag the number of people needed in a room for the probability of sharing a 
* same birthday to be at least 50% and display the result
gen flag = n if probsame > 0.5
quietly summarize flag
display as text "the number of people needed is equal to " as result r(min)

********************************************************************************
* Generate a graph that matches what The Economist would publish
graph twoway line probsame n,  ///
xline(23, lcolor(erose%80)) ///
xlabel(0(10)100) xtitle("Number of people in the room") ///
ylabel(0 "0%" 0.1 "10%" 0.2 "20%"  0.3 "30%" 0.4 "40%" 0.5 "50%" 0.6 "60%" 0.7 "70%" 0.8 "80%" 0.9 "90%" 1 "100%") ///
ytitle("Probability two people share the same birthday") ///
title({bf:The Birthday Problem}) scheme(economist) plotregion(margin(medium))

graph export Stata_birthdayproblem_graph.png, as(png)





