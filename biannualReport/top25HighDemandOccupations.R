#Merge Burning Glass data to update new job postings data
burningGlassConnect <- getURL('https://docs.google.com/spreadsheets/d/1It8xFhmmI0FwHUKSUeIPabjMLcjF9H6ZzRef--Y9DLo/pub?gid=590080743&single=true&output=csv')
emsiConnect         <- getURL('https://docs.google.com/spreadsheets/d/1It8xFhmmI0FwHUKSUeIPabjMLcjF9H6ZzRef--Y9DLo/pub?gid=101764269&single=true&output=csv')        

burningGlassData <- read.csv(textConnection(burningGlassConnect), 
                             check.names = FALSE)

emsiData         <- read.csv(textConnection(emsiConnect), 
                             check.names = FALSE)


top25highDemandJobPostingsNew <- left_join(burningGlassData, 
                                           emsiData, 
                                           by = 'SOC')

top25highDemandJobPostingsNew <- top25highDemandJobPostingsNew %>%
                                              select(1:4, 10, 6:8)



highDemandData_ss(ws = 'test') <- highDemandData_ss(ws = 'test') %>% 
                        gs_edit_cells(input  = top25highDemandJobPostingsNew,
                                      anchor = "A1", 
                                      byrow = TRUE)

#write.csv(top25highDemandJobPostingsNew, file = 'top25highDemandsJobPostingsNew.csv')