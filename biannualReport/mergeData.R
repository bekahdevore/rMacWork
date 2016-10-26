library(dplyr)
library(RCurl)
library(stringr)
library(googlesheets)

burningGlassDataConnection <- getURL('https://docs.google.com/spreadsheets/d/19UB0HXT3LY4YuMWwpsllon7kt4QMjSq4yqBwY4GW0Kg/pub?gid=0&single=true&output=csv')
emsiDataConnection         <- getURL('https://docs.google.com/spreadsheets/d/1CT9R_MIs_s7ULDm-RCexVsW9m6LZa26EqH0Cd3LEB3k/pub?gid=0&single=true&output=csv')        

burningGlassDataJCTC <- read.csv(textConnection(burningGlassDataConnection), check.names = FALSE)
emsiDataJCTC         <- read.csv(textConnection(emsiDataConnection), check.names = FALSE)


biannualData <- full_join(emsiDataJCTC, burningGlassDataJCTC, by = 'SOC')

write.csv(biannualData, file = 'biannualData.csv')



#Merge Burning Glass data to update new job postings data
burningGlassOldConnect <- getURL('https://docs.google.com/spreadsheets/d/1It8xFhmmI0FwHUKSUeIPabjMLcjF9H6ZzRef--Y9DLo/pub?gid=590080743&single=true&output=csv')
burningGlassNewConnect <- getURL('https://docs.google.com/spreadsheets/d/1It8xFhmmI0FwHUKSUeIPabjMLcjF9H6ZzRef--Y9DLo/pub?gid=101764269&single=true&output=csv')        

burningGlassOld <- read.csv(textConnection(burningGlassOldConnect), check.names = FALSE)
burningGlassNew <- read.csv(textConnection(burningGlassNewConnect), check.names = FALSE)


top25highDemandJobPostingsNew <- left_join(burningGlassOld, burningGlassNew, by = 'SOC')

top25highDemandJobPostingsNew <- top25highDemandJobPostingsNew %>%
                                    select(1:4, 10, 6:8)

highDemandData_ss <- highDemandData_ss %>% 
  gs_edit_cells(input = top25highDemandJobPostingsNew,
                anchor = "A1", byrow = TRUE)

write.csv(top25highDemandJobPostingsNew, file = 'top25highDemandJobPostingsNew.csv')

