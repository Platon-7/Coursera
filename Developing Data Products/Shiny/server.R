library(shiny)
library(C50)

shinyServer(function(input, output) {
  inner <- iris[,1:4]
  outsider <- iris[,5]
  model <- C5.0(inner, outsider, control = C5.0Control(noGlobalPruning = FALSE))
  prediction <- reactive({
    test <- data.frame("Sepal.Length" = input$sepal_length, "Sepal.Width" = input$sepal_width, "Petal.Length" = input$petal_length,
                                 "Petal.Width" = input$petal_width, "Species" = "User Input")
    predicted <- predict(model, test, type="class")
  })
  output$Species = prediction
  
})