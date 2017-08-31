library(shiny)
library(ggplot2)
library(scales)

# For dropdown menu
actionLink <- function(inputId, ...) {
    tags$a(href='javascript:void',
           id=inputId,
           class='action-button',
           ...)
}

fluidPage(
    titlePanel("Demo"),
    fluidRow(
        column(3,
               wellPanel(
                   h4("Parameters"),
                   sliderInput(min = -0.2, 
                               max = 0.2, 
                               value = 0, 
                               step = 0.01, 
                               inputId = "apr", 
                               label = "Annual Rate of Return"),
                   sliderInput("vol", "Annual Volatility", 0.2, min = 0, max = 1, step = 0.02),
                   sliderInput("years", "Years to Retirement", 0, 50, value = 25),
                   numericInput("balance", "Starting Balance",0, min = 0),
                   numericInput("savings", "Monthly Savings", 500, min = 0),
                   numericInput("incremental", "Incremental Monthly Savings", 0),
                   numericInput("simulations", "Number of Simulations", 100),
                   submitButton()
               )
        ),
        column(9,
               plotOutput("plot1"),
               wellPanel(
                   span("Ending Portfolio Value:",
                        textOutput("value")
                   )
               )
        )
    )
)