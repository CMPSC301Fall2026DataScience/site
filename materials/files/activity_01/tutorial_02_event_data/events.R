# CMPSC301: Data Science
# Activity 01: Campus Event Data Challenge
#
# Run this file from this directory with:
# Rscript events.R

# Clear the environment and console to make a clean execution of the code.

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

# The values below represent attendance at a fictional five-day campus event.
# Part 1: Create and inspect a vector ------------------------------------
# DONE: Replace the NA values with five whole-number attendance counts.
# Choose values that are not all the same.
attendance <- c(10,20,30,40,50)

# DONE: Use sum(attendance) to calculate total attendance.
total_attendance <- sum(attendance)

# DONE: Use mean(attendance) to calculate average daily attendance.
average_attendance <- mean(attendance)

# DONE: Use min(attendance) and max(attendance) to find the smallest and
# largest attendance counts.
lowest_attendance <- min(attendance)
highest_attendance <- max(attendance)

# Part 2: Use vectorized operations --------------------------------------
# Imagine that 8 additional people attend each day next year.
# DONE: Use one vectorized expression to create projected_attendance.
projected_attendance <- c(20,40,50,80,90)

# DONE: Set high_attendance_days to the attendance counts that are at least
# 50. Use a comparison and logical indexing.

# Return TRUE or FALSE if a value is greater than or equal to 50.
high_attendance_days <- c(projected_attendance >= 50) 



# Part 3: Report your findings -------------------------------------------
print("Campus Event Data Challenge")
print(paste("Total attendance:", total_attendance))
print(paste("Average daily attendance:", average_attendance))
print(paste("Lowest attendance:", lowest_attendance))
print(paste("Highest attendance:", highest_attendance))
print("Projected attendance next year:")
print(projected_attendance)
print("Attendance counts of at least 50:")
print(high_attendance_days)

# Challenge: Create a vector named study_hours with five numeric values.
# Then calculate its total and use logical indexing to display only values
# greater than or equal to 2.
# DONE: Write your challenge code here.


my_study_hours <- c(3,5,6,3,4,3,0) # hours studying
total_hours_studied <- sum(my_study_hours)
my_study_hours_greater_than_two <- c(my_study_hours >=2)

print(paste("total study hours: ",total_hours_studied))
print(my_study_hours)
print(my_study_hours_greater_than_two)

