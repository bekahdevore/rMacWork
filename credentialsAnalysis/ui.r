library(shiny)
library(shinythemes)
library(dplyr)
library(reshape2)
library(ggplot2)
library(plotly)
library(RCurl)
library(ggthemes)

majors <- read.csv('majors.csv')
majors <- majors %>% select(3)

soc        <- getURL('https://docs.google.com/spreadsheets/d/1wWVpXkU7OG2dGjCEEOK4Z4sS02tgK9_zee9cl0MdQRE/pub?gid=0&single=true&output=csv')
majorsList <- read.csv(textConnection(soc))

uniqueMajors  <- as.data.frame(sort(unique(majorsList$Occupation)))
uniqueMajors6 <- as.data.frame(sort(unique(majors$SOCName))) 


# Create 2-digit occupation group list with 'All' included at top
w                            <- as.data.frame("All")
colnames(w)                  <- "occupation"
colnames(uniqueMajors)[1]    <- "occupation"
majorsList                   <- rbind(w, uniqueMajors)


# Create 6-digit detailed occupation list with 'All' included at top
colnames(uniqueMajors6)[1]    <- "occupation"
majorsList6                   <- rbind(w, uniqueMajors6)

rm(w, majors, uniqueMajors, uniqueMajors6, soc)


navbarPage(
  theme = shinytheme('cosmo'),
  title = 'Job Postings in the Louisville MSA',
  
  tabPanel('Occupation', 
           h1("Job postings asking for at least a bachelor's degree"),
           h2("Top Occupation Groups"),
           #selectizeInput("occupation", label = h4("Choose/type an occupation group:"), 
           #              choices = majorsList), 
           plotOutput('degrees'), 
           #selectizeInput('occupationSixDigit', label = h4('Choose/type a detailed occupation:'), 
           #              choices = majorsList6),
           h2("Top Occupations"),
           plotOutput('degreesSixDigit')
           
  ), 
  
  tabPanel('Major', 
           
           h2("College majors employers want "),
           selectizeInput("occupation", label = h4("Choose/type an occupation group:"), 
                       choices = majorsList), 
           plotOutput('majors'), 
           selectizeInput('occupationSixDigit', label = h4('Choose/type a detailed occupation:'), 
                          choices = majorsList6),
           plotOutput('majorsSixDigit')
  ),
  

  
  tabPanel('About Data', 
           h1('Burning Glass, Labor Insights'),
           p('Online Job postings in the Louisville MSA, January 2015 - June 2016 ')
  ))
