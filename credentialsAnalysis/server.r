library(shiny)
library(RCurl)
library(dplyr)
library(ggplot2)
library(ggthemes)

soc               <- getURL('https://docs.google.com/spreadsheets/d/1wWVpXkU7OG2dGjCEEOK4Z4sS02tgK9_zee9cl0MdQRE/pub?gid=0&single=true&output=csv')

allData           <- read.csv('louisvilleData.csv')
majorSocCodeNames <- read.csv(textConnection(soc))
majors            <- read.csv('majors.csv')

allData           <- allData %>% select(10:11, 40, 42)
majors            <- majors %>% select(2, 3, 6)

allData           <- allData %>% filter(Edu >= 16)
#Seperate first two numbers of SOC codes and put in new variable
splitSOC <- as.data.frame(t(sapply(unique(majors$SOC), function(x) substring(x, first=c(1, 1), last=c(2, 7)))))

#Change column names for merge
colnames(splitSOC)[1]          <- "socGroup"
colnames(splitSOC)[2]          <- "SOC"
colnames(majorSocCodeNames)[1] <- 'socGroup'

#Align data type for merge
splitSOC$socGroup          <- as.factor(splitSOC$socGroup)
majorSocCodeNames$socGroup <- as.factor(majorSocCodeNames$socGroup)

#Merge split SOC with 2-digit SOC code names
splitSOC <- left_join(splitSOC, majorSocCodeNames, by = 'socGroup')
splitSOC <- splitSOC %>% select(1:3)

#Merge majors and split SOC code data
majors    <- left_join(majors,  splitSOC, by = 'SOC')
degrees   <- left_join(allData, splitSOC, by = 'SOC')
degrees   <- na.omit(degrees)



# testing2 <- majors %>% filter(Occupation == "Management ")
# testing2 <- dplyr::count(testing2, Occupation, STDMajor)
# testing2 <- testing2 %>% arrange(desc(n)) %>%
#   top_n(10, n)
# 
# 
# g <- ggplot(testing2, aes(x = STDMajor, 
#                                       y = n) )+      
#   geom_bar(stat = 'identity') +
#   labs(x = '', 
#        y = 'Number of Job Postings') +
#   coord_flip()
# g
# 


shinyServer(function(input, output) {

  majorsDataTwoDigit <- reactive({
    if(input$occupation == "All"){
      majors <- dplyr::count(majors, STDMajor)
      majors <- majors %>% arrange(desc(n))
      majors <- majors %>% head(10)
      #majors <- majors %>% head(arrange(desc(n)), n = 10)
    }
    else{
    majors <- majors %>% filter(Occupation== input$occupation)
    majors <- dplyr::count(majors, Occupation, STDMajor)
    majors <- majors %>% arrange(desc(n)) 
    majors <- majors %>% head(10)
    #majors <- majors %>% arrange(desc(n)) %>% top_n(10, n)
    }
  })
  
  majorsDataSixDigit <- reactive({
    if(input$occupationSixDigit == "All"){
      majors <- dplyr::count(majors, STDMajor)
      majors <- majors %>% arrange(desc(n)) 
      majors <- majors %>% head(10)
      #majors <- majors %>% arrange(desc(n)) %>%head(n = 10)
    }
    else{
      majors <- majors %>% filter(SOCName == input$occupationSixDigit)
      majors <- dplyr::count(majors, SOCName, STDMajor)
      majors <- majors %>% arrange(desc(n)) 
      majors <- majors %>% head(10)
      #%>% top_n(10, n)
    }
  })
  #majors    <- dplyr::count(majors, SOCName, STDMajor)
  
#### DEGREES
  degreesDataTwoDigit <- reactive({
      degrees <- dplyr::count(degrees, Occupation)
      degrees <- degrees %>% arrange(desc(n))
      degrees <- degrees %>% head(20)
  })
  
  degreesDataSixDigit <- reactive({
      degrees <- dplyr::count(degrees, SOCName)
      degrees <- degrees %>% arrange(desc(n))
      degrees <- degrees %>% head(20)
  })
  #majors    <- dplyr::count(majors, SOCName, STDMajor)


      output$majors <- renderPlot({

        ggplot(majorsDataTwoDigit(), aes(x = reorder(STDMajor, n),
                                               y = n,
                                               fill = STDMajor)) +
          geom_bar(stat = 'identity') +
          labs(x = '',
               y = 'Number of Job Postings') +
          coord_flip() +
          guides(fill = FALSE) +
          theme_minimal() +
          theme(axis.text = element_text(size = 12))
      })

      output$majorsSixDigit <- renderPlot({

        ggplot(majorsDataSixDigit(), aes(x = reorder(STDMajor, n),
                                         y = n,
                                         fill = STDMajor)) +
          geom_bar(stat = 'identity') +
          labs(x = '',
               y = 'Number of Job Postings') +
          coord_flip() +
          guides(fill = FALSE) +
          theme_minimal() +
          theme(axis.text = element_text(size = 12))
      })
      
      
###### DEGREES       
      output$degrees <- renderPlot({
        
        ggplot(degreesDataTwoDigit(), aes(x = reorder(Occupation, n), 
                                         y = n, 
                                         fill = Occupation)) +      
          geom_bar(stat = 'identity') +
          labs(x = '', 
               y = 'Number of Job Postings') +
          coord_flip() +
          guides(fill = FALSE) +
          theme_minimal() +
          theme(axis.text = element_text(size = 16))
          
          
      })  
      
      output$degreesSixDigit <- renderPlot({
        
        ggplot(degreesDataSixDigit(), aes(x = reorder(SOCName, n), 
                                         y = n, 
                                         fill = SOCName)) +      
          geom_bar(stat = 'identity') +
          labs(x = '', 
               y = 'Number of Job Postings') +
          coord_flip() +
          guides(fill = FALSE) +
          theme_minimal() +
          theme(axis.text = element_text(size = 16))
      })  
  })
