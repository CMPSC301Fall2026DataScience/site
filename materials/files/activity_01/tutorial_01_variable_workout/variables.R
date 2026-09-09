# CMPSC301: Data Science
# Activity 01: Variable Workout
#
# Run this file from this directory with:
# Rscript variables.R

# Clear the environment and console to make a clean execution of the code.

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

# Part 1: Create variables -----------------------------------------------
# DONE: Replace NA with a number of minutes that you spend traveling to campus.
commute_minutes <- 10

# DONE: Replace "" with the name of a data-science topic that interests you.
interest_topic <- "Under Water Basket Weaving"

# DONE: Replace NA with TRUE or FALSE to indicate whether you have used R before.
has_used_r_before <- TRUE

# Part 2: Use and update variables ---------------------------------------
# DONE: Set weekly_commute_minutes to the number of minutes spent commuting
# during a five-day week. Use commute_minutes in your expression.
weekly_commute_minutes <- 10

# DONE: Use interest_topic and toupper() to create an uppercase version.
interest_topic_upper <- toupper(interest_topic)

# DONE: Use ! to create a variable that is the opposite of has_used_r_before.
needs_first_r_experience <- !has_used_r_before

# Part 3: Check your work -------------------------------------------------
print("Variable workout")
print(paste("Interest topic:", interest_topic_upper))
print(paste("Weekly commute minutes:", weekly_commute_minutes))
print(paste("Needs a first R experience:", needs_first_r_experience))

# Challenge: Add one new descriptive variable of your own. Then use it in
# an expression or function and print the result below.
# DONE: Write your challenge code here.

difficult_homework = T 
print(paste(" The homework was difficult: ",difficult_homework))
