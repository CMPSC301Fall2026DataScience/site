# Generates the eight group datasets for the linear regression discovery activity.
# Run from the project root:  Rscript data/make_data.R
library(tidyverse)
set.seed(301)

# Group 1: study hours vs exam score (scores capped at 100)
g1 <- tibble(hours = c(2, 3, 4, 5, 5, 6, 7, 8, 8, 10, 10, 12, 12, 14, 15, 16, 18, 20, 22, 25),
             score = pmin(100, round(52 + 1.6 * hours + rnorm(20, 0, 7))))

# Group 2: monthly advertising spend ($ thousands) vs sales revenue ($ thousands)
g2 <- tibble(month = 1:16,
             advertising = c(8, 12, 15, 10, 20, 22, 18, 25, 30, 28, 35, 32, 40, 38, 45, 42),
             sales = round(150 + 4.2 * advertising + rnorm(16, 0, 18)))

# Group 3: house size (sq ft) vs selling price ($), with other variables that matter
size <- c(1150, 1300, 1420, 1500, 1580, 1650, 1720, 1800, 1880, 1950, 2050, 2100,
          2200, 2280, 2350, 2450, 2600, 2700, 2850, 3000, 3150, 3300)
g3 <- tibble(size = size,
             bedrooms = pmin(5, pmax(2, round(size / 650 + rnorm(22, 0, 0.5)))),
             age = round(runif(22, 2, 60)),
             price = round((60000 + 125 * size - 900 * age + rnorm(22, 0, 22000)) / 500) * 500)

# Group 4: average daily temperature (C) vs household electricity use (kWh), heating season
g4 <- tibble(temperature = c(-8, -6, -5, -3, -2, 0, 1, 3, 4, 6, 7, 9, 10, 12, 13, 15, 16, 18),
             electricity = round(48 - 1.25 * temperature + rnorm(18, 0, 2.5), 1))

# Group 5: years of experience vs salary ($ thousands); employee 16 is unusual
g5 <- tibble(employee = 1:16,
             experience = c(1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 11, 12, 13, 22),
             salary = round(c(42 + 2.3 * c(1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 11, 12, 13) +
                                rnorm(15, 0, 3), 165)))

# Group 6: speed (km/h) vs fuel efficiency (km/L); gently curved in reality
spd <- c(60, 65, 70, 75, 80, 85, 90, 100, 105, 110, 115, 120, 125, 130)
g6 <- tibble(speed = spd,
             efficiency = round(17.5 - 0.0009 * (spd - 60)^2 - 0.02 * (spd - 60) +
                                  rnorm(14, 0, 0.35), 1))

# Group 7: campaign spend ($ hundreds) vs customer inquiries; campaign 12 went viral
g7 <- tibble(campaign = 1:15,
             spend = c(5, 8, 10, 12, 15, 18, 20, 22, 25, 28, 30, 32, 35, 38, 40),
             inquiries = round(20 + 3.1 * spend + rnorm(15, 0, 6)))
g7$inquiries[g7$campaign == 12] <- 310

# Group 8: daily high temperature (C) vs ice cream sales (units); accelerating curve
tmp <- c(10, 12, 13, 15, 16, 18, 19, 20, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35)
g8 <- tibble(temperature = tmp,
             sales = round(60 + 0.45 * (tmp - 10)^2 + rnorm(22, 0, 12)))

write_csv(g1, "data/group1_study_exam.csv")
write_csv(g2, "data/group2_advertising_sales.csv")
write_csv(g3, "data/group3_house_prices.csv")
write_csv(g4, "data/group4_temperature_electricity.csv")
write_csv(g5, "data/group5_experience_salary.csv")
write_csv(g6, "data/group6_speed_fuel.csv")
write_csv(g7, "data/group7_campaign_inquiries.csv")
write_csv(g8, "data/group8_temperature_icecream.csv")
