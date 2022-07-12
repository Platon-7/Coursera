library(shiny)
library(stringr)
library(dplyr)

bi_words <- readRDS("bi_words.rds")
tri_words  <- readRDS("tri_words.rds")
quad_words <- readRDS("quad_words.rds")
penta_words <- readRDS("penta_words.rds")
hexa_words <- readRDS("hexa_words.rds")
profanity <- read.table("facebook_profanity.txt", sep=",")

bigram <- function(input_phrase){
  num <- length(input_phrase)
  filter(bi_words,
         word1==input_phrase[num]) %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 2)) %>%
    as.character() -> out
  ifelse(out =="character(0)", "no_clue", return(out))
}

trigram <- function(input_phrase){
  num <- length(input_phrase)
  filter(tri_words,
         word1==input_phrase[num-1],
         word2==input_phrase[num])  %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 3)) %>%
    as.character() -> out
  ifelse(out=="character(0)", bigram(input_phrase), return(out))
}

quadgram <- function(input_phrase){
  num <- length(input_phrase)
  filter(quad_words,
         word1==input_phrase[num-2],
         word2==input_phrase[num-1],
         word3==input_phrase[num])  %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 4)) %>%
    as.character() -> out
  ifelse(out=="character(0)", trigram(input_phrase), return(out))
}

pentagram <- function(input_phrase){
  num <- length(input_phrase)
  filter(penta_words,
         word1==input_phrase[num-3],
         word2==input_phrase[num-2],
         word3==input_phrase[num-1],
         word4==input_phrase[num])  %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 5)) %>%
    as.character() -> out

  ifelse(out=="character(0)", quadgram(input_phrase), return(out))
}

hexagram <- function(input_phrase){
  num <- length(input_phrase)
  filter(hexa_words,
         word1==input_phrase[num-4],
         word2==input_phrase[num-3],
         word3==input_phrase[num-2],
         word4==input_phrase[num-1],
         word5==input_phrase[num])  %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 6)) %>%
    as.character() -> out
  
  ifelse(out=="character(0)", pentagram(input_phrase), return(out))
}



ngrams <- function(input_text){
  input_text <- data_frame(text = input_text)
  replace_reg <- "[^[:alpha:][:space:]]*"
  input_text <- input_text %>%
    mutate(text = str_replace_all(text, replace_reg, ""))
  input_count <- str_count(input_text, boundary("word"))
  input_phrase <- unlist(str_split(input_text, boundary("word")))
  if(input_count>0){
    for(n in 1:input_count){
      if(is.element(input_phrase[n], unlist(profanity))){
        return("Watch your language")
      }
    }
  }
  alacazam <- ifelse(input_count == 0, "Give this guy some love and type something for him to guess or he will be out of business",
                     ifelse (input_count == 1, bigram(input_phrase),
                             ifelse (input_count == 2, trigram(input_phrase),
                                     ifelse (input_count == 3, quadgram(input_phrase),
                                             ifelse(input_count ==4, pentagram(input_phrase), hexagram(input_phrase))))))
  if(alacazam == "no_clue"){
    alacazam = "Akinator is probably a fraud because he has no clue" 
  }

  return(alacazam)
}

shinyServer(function(input, output){
  output$prediction <- renderPrint({
    alacazam <- ngrams(input$inputString)
    alacazam
  })
  
  output$text1 <- renderText({
    input$inputString
  });
})