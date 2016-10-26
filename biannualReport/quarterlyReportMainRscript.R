library(dplyr)
library(RCurl)
library(stringr)
library(googlesheets)


#Import Data from google sheets 
burningGlassQuarterConnection   <- getURL('https://docs.google.com/spreadsheets/d/1DjmOHHFiPAyCKXkze6e8EVHBSGv-N7qt5rX1KezQUx0/pub?gid=0&single=true&output=csv')
burningGlassAnnualConnection    <- getURL('https://docs.google.com/spreadsheets/d/1DjmOHHFiPAyCKXkze6e8EVHBSGv-N7qt5rX1KezQUx0/pub?gid=1362303387&single=true&output=csv') 
emsiDataConnection              <- getURL('https://docs.google.com/spreadsheets/d/1DjmOHHFiPAyCKXkze6e8EVHBSGv-N7qt5rX1KezQUx0/pub?gid=1224165436&single=true&output=csv') 
socCrosswalkConnection          <- getURL('https://docs.google.com/spreadsheets/d/1DjmOHHFiPAyCKXkze6e8EVHBSGv-N7qt5rX1KezQUx0/pub?gid=1551915918&single=true&output=csv')

burningGlassQuarter <- read.csv(textConnection(burningGlassQuarterConnection), check.names = FALSE)
burningGlassAnnual  <- read.csv(textConnection(burningGlassAnnualConnection),  check.names = FALSE)
emsiData            <- read.csv(textConnection(emsiDataConnection),            check.names = FALSE)
socCrosswalk        <- read.csv(textConnection(socCrosswalkConnection),        check.names = FALSE)

# MAIN DATA FILE 
mainDataFile <- full_join(burningGlassQuarter, emsiData, by = 'SOC')
colnames(mainDataFile)[3] <- 'Job Postings'

mainDataFile <- full_join(mainDataFile, socCrosswalk, by = 'SOC')

mainDataFile    <- mainDataFile %>%
                    select(1, 12, 3, 5:11)
        
# Connect to Google Sheet
quarterlyReport <- gs_title('quarterlyReportRscriptOutput')


# TOP JOB POSTINGS DATA 
topJobPostings  <- mainDataFile %>%
                    select(1:3, 5:6, 9:10)

quarterlyReport <- quarterlyReport %>% 
                      gs_edit_cells(input  = topJobPostings,
                                    ws     = 1,
                                    anchor = "A1", 
                                    byrow  = TRUE)

# HIGH DEMAND DATA 
highDemandData <- full_join(mainDataFile, burningGlassAnnual, by = 'SOC')

highDemandData <- highDemandData %>%
                    select(1:2, 12, 4:5, 7:8)

#Remove $ from Median wage and convert to numeric
highDemandData$`Median Hourly Earnings` <- str_replace_all(
                                              highDemandData$`Median Hourly Earnings`, 
                                              '\\$', '')
highDemandData$`Median Hourly Earnings` <- as.numeric(as.character(highDemandData$`Median Hourly Earnings`))

#Filter median wage to above 22.73
highDemandData <- highDemandData %>% 
                      filter(highDemandData$`Median Hourly Earnings` >= 22.73)

colnames(highDemandData)[3] <- 'Job Postings'


#FUTURE CHANGES, DO ALL CALCULATIONS AND MELT IN R SCRIPT
#Remove commas from Number of Job Postings, 2016 - 2026 Change, Age 55-64, Age 65 + 
#Add new columns calculating Job Postings Ranking
#Add new columns calculating 

quarterlyReport <- quarterlyReport %>% 
                      gs_edit_cells(input  = highDemandData,
                                    ws = 2,
                                    anchor = "A1", 
                                    byrow = TRUE)

#write.csv(highDemandData, file = 'highDemandData.csv')