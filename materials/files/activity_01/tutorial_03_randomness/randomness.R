# CMPSC301: Data Science
# Instructor solution: Can You Beat Randomness?

# Clear the environment and console to make a clean execution of the code.

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console





set.seed(301)
number_of_flips <- 20
number_of_experiments <- 10000

one_experiment <- sample(c("H", "T"), size = number_of_flips, replace = TRUE)
heads_in_one_experiment <- sum(one_experiment == "H")

has_seven_heads_in_a_row <- function(flips) {
  for (start_position in 1:(length(flips) - 6)) {
    if (all(flips[start_position:(start_position + 6)] == "H")) {
      return(TRUE)
    }
  }
  FALSE
}

one_experiment_has_streak <- has_seven_heads_in_a_row(one_experiment)

streak_results <- replicate(number_of_experiments, {
  flips <- sample(c("H", "T"), size = number_of_flips, replace = TRUE)
  has_seven_heads_in_a_row(flips)
})
streak_proportion <- mean(streak_results)
streak_count <- sum(streak_results)

head_counts <- replicate(number_of_experiments, {
  sum(sample(c("H", "T"), size = number_of_flips, replace = TRUE) == "H")
})

print("Can You Beat Randomness?")
print(paste("Heads in the first 20 flips:", heads_in_one_experiment))
print(paste("Did the first experiment have 7 heads in a row?",
            one_experiment_has_streak))
print(paste("Experiments with a 7-head streak:", streak_count, "out of",
            number_of_experiments))
print(paste("Estimated probability:", round(streak_proportion, 4)))

hist(head_counts, breaks = seq(-0.5, number_of_flips + 0.5, by = 1),
     main = "Heads in 10,000 Experiments of 20 Coin Flips",
     xlab = "Number of heads", col = "steelblue", border = "white")

# Challenge: In 30 flips, eight consecutive heads occurred in about this
# proportion of simulated experiments.
eight_head_results <- replicate(number_of_experiments, {
  flips <- sample(c("H", "T"), size = 30, replace = TRUE)
  has_eight_heads <- any(sapply(1:(length(flips) - 7), function(start_position) {
    all(flips[start_position:(start_position + 7)] == "H")
  }))
  has_eight_heads
})
print(paste("Estimated probability of 8 heads in a row within 30 flips:",
            round(mean(eight_head_results), 4)))
