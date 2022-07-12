library(shiny)
library(stringr)
library(dplyr)

shinyUI(fluidPage(
          titlePanel("Data Science Capstone Project"),
             mainPanel(
                img(src="akinator4.png",align = "left", width="15%"),
                helpText("This dude will read your mind just a warning"),
                textInput("inputString", "Enter your thoughts here but save a word, Akinator will get that for you. What are you thinking? ",value = ""),
                helpText("Prepare your mind because it will be blown"),
                submitButton('Alacazam'),
                br(),
                img(src="akinator3.png", align = "left", width="15%"),
                helpText("To think is to create. The next word you would type is: "),
                verbatimTextOutput("prediction")
                                
              )
          )
                            
)