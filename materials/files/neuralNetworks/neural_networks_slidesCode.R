# =====================================================================
# Neural Networks: R code from neural_networks_slides slides.
# Having the code in this source file will help you to run your
# experiments with neural networks. 
#
# Run section by section in class (RStudio: Ctrl/Cmd+Enter line by line,
# or use the document outline; each "----" header is a slide).
# Or run all at once:  Rscript src/neural_networks_slidesCode.R
# =====================================================================


# ---- Activation Functions ----------------------------------------------

# Sigmoid in R
sigmoid <- function(x) 1 / (1 + exp(-x))

# ReLU in R
relu <- function(x) pmax(0, x)

# Tanh in R
tanh_activation <- function(x) tanh(x)

# Softmax in R
softmax <- function(x) exp(x) / sum(exp(x))

# Try them out
x <- c(-5, -1, 0, 1, 5)
cat("x:      ", x, "\n")
cat("sigmoid:", round(sigmoid(x), 3), "\n")
cat("relu:   ", relu(x), "\n")
cat("tanh:   ", round(tanh_activation(x), 3), "\n")
cat("softmax:", round(softmax(c(1, 2, 3)), 3), " (sums to", sum(softmax(c(1, 2, 3))), ")\n")


# ---- Automated R Setup --------------------------------------------------
# Smart loading: install if missing, then load.

# Clear environment and plots
rm(list = ls()) # clear all variables
graphics.off()  # clear all plots
cat("\014")    # clear the console

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Smart loading: Install if missing, then load reticulate (for Python integration)
if(!require('reticulate')) {
  install.packages('reticulate')
  library('reticulate')
}

# Smart loading: Install if missing, then load neuralnet
if(!require('neuralnet')) {
  install.packages('neuralnet')
  library('neuralnet')
}

# Smart loading: Install if missing, then load nnet
if(!require('nnet')) {
  install.packages('nnet')
  library('nnet')
}

# Smart loading: Install if missing, then load tidyverse
if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

# Smart loading: Install if missing, then load caret
if(!require('caret')) {
  install.packages('caret')
  library('caret')
}


# ---- XOR in R (Part 1): Building the Data -------------------------------

# Create XOR dataset
xor_data <- data.frame(
  X1 = c(0, 0, 1, 1),
  X2 = c(0, 1, 0, 1),
  Y = c(0, 1, 1, 0)
)

cat("XOR Training Data:\n")
print(xor_data)


# ---- XOR in R (Part 2): Training the Network ----------------------------

# Build neural network
set.seed(301)
xor_nn <- neuralnet(
  Y ~ X1 + X2,
  data = xor_data,
  hidden = 2,              # 2 neurons in hidden layer
  linear.output = FALSE,   # Use activation function
  threshold = 0.01,        # Training threshold
  stepmax = 1e6            # Max iterations
)

cat("\nTraining completed!\n")
cat("Error:", xor_nn$result.matrix[1], "\n")


# ---- XOR in R (Part 3): Visualizing the Network -------------------------

# Plot the neural network structure
plot(xor_nn,
     rep = "best",
     main = "XOR Neural Network")


# ---- XOR in R (Part 4): Making Predictions ------------------------------

# Test the network
predictions <- predict(xor_nn, xor_data[, c("X1", "X2")])

# Round to binary output
results <- data.frame(
  X1 = xor_data$X1,
  X2 = xor_data$X2,
  Actual = xor_data$Y,
  Predicted = round(predictions, 3),
  Binary = round(predictions)
)

cat("\nPredictions:\n")
print(results)

# Calculate accuracy
accuracy <- sum(results$Actual == results$Binary) / nrow(results)
cat("\nAccuracy:", accuracy * 100, "%\n")


# ---- Iris Classification (R): Explore the Data --------------------------

# Load and prepare iris dataset
data(iris)

# Explore the data
cat("Iris Dataset Structure:\n")
str(iris)

cat("\nSpecies Distribution:\n")
print(table(iris$Species))

cat("\nFirst few rows:\n")
print(head(iris))


# ---- Iris Data Preparation (R) ------------------------------------------

# Normalize features (important for neural networks!)
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

iris_normalized <- iris %>%
  mutate(across(1:4, normalize))

# Create dummy variables for species
iris_data <- iris_normalized %>%
  mutate(
    setosa = ifelse(Species == "setosa", 1, 0),
    versicolor = ifelse(Species == "versicolor", 1, 0),
    virginica = ifelse(Species == "virginica", 1, 0)
  )

# Split into train (80%) and test (20%)
set.seed(123)
train_idx <- sample(1:nrow(iris_data), 0.8 * nrow(iris_data))
train_data <- iris_data[train_idx, ]
test_data <- iris_data[-train_idx, ]


# ---- Why Normalize? Make a Prediction! ----------------------------------

# The original ranges of the four iris measurements (in cm)
print(sapply(iris[, 1:4], range))


# ---- Building Iris Neural Network (R) -----------------------------------

cat("Training samples:", nrow(train_data), "\n")
cat("Testing samples:", nrow(test_data), "\n")

# Build neural network for iris classification
iris_nn <- neuralnet(
  setosa + versicolor + virginica ~
    Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
  data = train_data,
  hidden = c(5, 3),        # Two hidden layers: 5 and 3 neurons
  linear.output = FALSE,
  threshold = 0.01,
  stepmax = 1e6
)

cat("Training completed!\n")
cat("Error:", iris_nn$result.matrix[1], "\n")


# ---- Visualizing Iris Network (R) ---------------------------------------

# Plot the network
plot(iris_nn,
     rep = "best",
     main = "Iris Classification Neural Network")


# ---- Iris Predictions (R) - Part 1 --------------------------------------

# Make predictions on test set
predictions <- predict(iris_nn, test_data)

# Convert predictions to species names
predicted_species <- apply(predictions, 1, which.max)
predicted_species <- c("setosa", "versicolor", "virginica")[predicted_species]

# Actual species
actual_species <- test_data$Species

# Create results table
results <- data.frame(
  Actual = actual_species,
  Predicted = predicted_species,
  Correct = actual_species == predicted_species
)

# Display sample results
cat("\nSample Predictions:\n")
print(head(results, 15))


# ---- Iris Predictions (R) - Part 2: Evaluation Metrics ------------------

# Calculate accuracy
accuracy <- sum(results$Correct) / nrow(results)
cat("\nTest Accuracy:", round(accuracy * 100, 2), "%\n")

# Confusion matrix
cat("\nConfusion Matrix:\n")
print(table(Actual = actual_species, Predicted = predicted_species))


# ---- How Does Seed Change the Outcome (R) -------------------------------
# Same network, same data, three different random starting weights.

seed_runs <- map_dfr(1:3, \(s) {
  set.seed(s)                       # a different random START each time
  nn <- neuralnet(setosa + versicolor + virginica ~
                    Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
                  data = train_data, hidden = c(5, 3),
                  linear.output = FALSE, stepmax = 1e6)
  guess <- c("setosa", "versicolor", "virginica")[apply(predict(nn, test_data), 1, which.max)]
  tibble(seed = s,
         train_error = round(nn$result.matrix["error", 1], 4),
         steps       = nn$result.matrix["steps", 1],
         test_accuracy = round(mean(guess == test_data$Species), 3))
})
print(seed_runs)


# ---- Regression: Preparing the Data (R) ---------------------------------
# Predicting ozone (parts per billion) from sunlight, wind and temperature.

# Keep the complete rows of four columns
aq <- airquality %>%
  select(Ozone, Solar.R, Wind, Temp) %>%
  drop_na()

# Scale EVERYTHING to 0 to 1 - including the outcome, Ozone
aq_scaled <- aq %>% mutate(across(everything(), normalize))

# Split into train (80%) and test (20%)
set.seed(301)
aq_rows  <- sample(nrow(aq), round(0.8 * nrow(aq)))
aq_train <- aq_scaled[aq_rows, ]
aq_test  <- aq_scaled[-aq_rows, ]

# A helper to turn 0-to-1 predictions back into parts per billion
unscale <- function(p, original) p * (max(original) - min(original)) + min(original)

# Is this relationship a straight line?
print(
  ggplot(aq, aes(Temp, Ozone)) + geom_point(alpha = 0.6) +
    labs(title = "Is this relationship a straight line?")
)


# ---- Regression: Training the Network (R) -------------------------------

set.seed(301)
aq_nn <- neuralnet(Ozone ~ Solar.R + Wind + Temp,
                   data = aq_train, hidden = 3,
                   linear.output = TRUE,      # a NUMBER, not a probability
                   stepmax = 1e6)

# Predictions in real units (parts per billion)
nn_pred <- unscale(predict(aq_nn, aq_test)[, 1], aq$Ozone)
actual  <- aq$Ozone[-aq_rows]

# RMSE: the typical size of an error. Smaller is better.
rmse <- function(actual, pred) sqrt(mean((actual - pred)^2))
lm_fit <- lm(Ozone ~ Solar.R + Wind + Temp, data = aq[aq_rows, ])

print(
  tibble(model = c("Always guess the average", "Straight line: lm()", "Neural network"),
         RMSE  = round(c(rmse(actual, mean(aq$Ozone[aq_rows])),
                         rmse(actual, predict(lm_fit, aq[-aq_rows, ])),
                         rmse(actual, nn_pred)), 1))
)
# Try set.seed(123) above and see whether the ranking changes!


# ---- Asking "What If" Questions? (R) ------------------------------------
# Hold every input at a typical value, slide ONE input from low to high.

typical <- train_data %>%
  summarise(across(Sepal.Length:Petal.Width, median))

sweep <- typical[rep(1, 51), ] %>%
  mutate(Petal.Length = seq(0, 1, length.out = 51))   # scaled 0 to 1

probs <- predict(iris_nn, sweep)
colnames(probs) <- c("setosa", "versicolor", "virginica")

print(
  bind_cols(sweep, as_tibble(probs)) %>%
    pivot_longer(setosa:virginica, names_to = "species", values_to = "score") %>%
    ggplot(aes(Petal.Length, score, colour = species)) +
    geom_line(linewidth = 1.2) +
    labs(x = "Petal.Length (scaled 0 to 1)", y = "Network output",
         title = "What does the network say as the petals get longer?")
)
# Try sweeping Sepal.Width instead: does the network care about it at all?

