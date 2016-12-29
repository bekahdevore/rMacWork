library(shiny)
library(blsAPI)
library(RCurl)
library(RJSONIO)
library(ggplot2)
library(dplyr)
library(scales)
library(plotly)
library(shinythemes)


## NEW NUMBERS FIND POSTINGS ON BURNING GLASS AND MONTH AND RELEASE DATA HERE: http://www.bls.gov/schedule/news_release/metro.htm
month              <- "November"
dataRelease        <- "12/29/16"
totalPostings      <- 8796
baPostings         <- 2178
# STORE LAST MONTHS NUMBERS BELOW
lastMonthsPostings <- 10359
baLastMonth        <- 2150

totalJobPostings  <- format(totalPostings, big.mark = ',')
baPlusJobPostings <- format(baPostings,    big.mark = ',')
percentBachelors  <- percent(round((baPostings/totalPostings), digits = 4)) 
percentageBaPlus  <- percentBachelors
#postingsChange    <- (totalPostings - lastMonthsPostings)
#baChange          <- (baPostings - baLastMonth)



shinyUI(fluidPage(
       theme = shinytheme("journal"),

    # Show a plot of the generated distribution
   fluidRow(
    column(12, 
       align = "center",
       h1("Unemployment Rate,", month, "2006-2016"),
       h6('Data Source: Bureau of Labor Statistics, Local Area Unemployment Statistics. Data Released: ', dataRelease),
       plotlyOutput("unemploymentRatePlot"),
       br(),
       br()),
    
    column(12, 
       br(), 
       br(),
       align = "center",
       h1("Size of Labor Force,", month,  "2006-2016"),
       h6('Data Source: Bureau of Labor Statistics, Local Area Unemployment Statistics. Data Released: ', dataRelease),
       plotlyOutput("laborForcePlot")
    ),
    column(12,
       align = "center",
       br(), 
       br(),
       br(), 
       br(),
       h1("Online Job Postings, ", month), 
       h3("Total: ", totalJobPostings, " Bachelors or higher: ", baPlusJobPostings)
           ), 
       align = "center",
       h4(percentageBaPlus, "of online job postings are adverstising for a bachelor's degree or higher in the Louisville MSA"), 
       h6('Data Source: Burning Glass Labor Insights')
  )))



