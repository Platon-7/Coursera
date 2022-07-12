library(shiny)
library(C50)

shinyUI(fluidPage(
  titlePanel("Species Prediction for the Iris Dataset"),
  sidebarLayout(
    sidebarPanel(
      h4("What is the Sepal Length?"),
      sliderInput("sepal_length", "slide me", 4.0, 8.0, value = 4.0, step = 0.1),
      
      h4("What is the Sepal Width?"),
      sliderInput("sepal_width", "slide me", 2.0, 5.0, value = 2.0, step = 0.1),
      
      h4("What is the Petal Length?"),
      sliderInput("petal_length", "slide me", 1.0, 7.0, value = 1.0, step = 0.1),
      
      h4("What is the Petal Width?"),
      sliderInput("petal_width", "slide me", 0.1, 3.0, value = 0.1, step = 0.1)
    ),
    mainPanel(
      h3("Predicted Value for Species:"),
      textOutput("Species")
    )
  )

)
)