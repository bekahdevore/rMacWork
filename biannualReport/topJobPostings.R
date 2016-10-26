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





