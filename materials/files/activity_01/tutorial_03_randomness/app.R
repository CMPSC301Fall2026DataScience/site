# CMPSC301: Data Science
# Can You Beat Randomness? Weighted Dice Explorer
#
# Start the app from this directory with:
# Rscript -e 'shiny::runApp()'

library(shiny)

ui <- fluidPage(
  titlePanel("Can You Beat Randomness?"),
  sidebarLayout(
    sidebarPanel(
      numericInput("roll_count", "Number of rolls", value = 1000,
                   min = 10, max = 100000, step = 10),
      sliderInput("six_weight", "Chance of rolling a 6", min = 0.01,
                  max = 0.80, value = 1 / 6, step = 0.01),
      actionButton("roll", "Roll the dice"),
      tags$hr(),
      p("A fair die gives every face a probability of 1/6. Increase the chance
        of a six and watch the simulated results change.")
    ),
    mainPanel(
      h3("What happened in this simulation?"),
      fluidRow(
        column(4, wellPanel(strong("Average roll"), textOutput("mean_roll"))),
        column(4, wellPanel(strong("Proportion of sixes"), textOutput("six_proportion"))),
        column(4, wellPanel(strong("Expected proportion"), textOutput("expected_proportion")))
      ),
      plotOutput("dice_plot", height = "360px"),
      h3("A note about evidence"),
      p("Small samples can look surprising. Run the same settings several times,
        then increase the number of rolls. A single unusual outcome is a reason
        to investigate, not proof that a die is weighted.")
    )
  )
)

server <- function(input, output, session) {
  rolls <- eventReactive(input$roll, {
    six_probability <- input$six_weight
    other_probability <- (1 - six_probability) / 5
    sample(1:6, size = input$roll_count, replace = TRUE,
           prob = c(rep(other_probability, 5), six_probability))
  }, ignoreNULL = FALSE)

  output$mean_roll <- renderText({
    round(mean(rolls()), 3)
  })

  output$six_proportion <- renderText({
    round(mean(rolls() == 6), 3)
  })

  output$expected_proportion <- renderText({
    round(input$six_weight, 3)
  })

  output$dice_plot <- renderPlot({
    counts <- tabulate(rolls(), nbins = 6)
    barplot(counts, names.arg = 1:6, col = "steelblue", border = NA,
            main = "Simulated Dice Rolls", xlab = "Die face", ylab = "Count")
    abline(h = length(rolls()) * input$six_weight, col = "firebrick",
           lwd = 2, lty = 2)
    legend("topright", legend = "Expected count for sixes", col = "firebrick",
           lty = 2, lwd = 2, bty = "n")
  })
}

shinyApp(ui, server)
