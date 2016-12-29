library(dplyr)

###############################################################################################
## FUNCTIONS ##
###############################################################################################
msaFilter <- function(dataFrameName) {
                      dataFrameName <- dataFrameName %>% 
                        filter(MSA == 31140)
                    }

## Main 2015
main2015.01 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-01.txt"))
main2015.02 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-02.txt"))
main2015.03 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-03.txt"))
main2015.04 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-04.txt"))
main2015.05 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-05.txt"))
main2015.06 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-06.txt"))
main2015.07 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-07.txt"))

dataFrameOne <- do.call("rbind", list(main2015.01, 
                                      main2015.02, 
                                      main2015.03,
                                      main2015.04,
                                      main2015.05,
                                      main2015.06,
                                      main2015.07))
write.csv(dataFrameOne, file = 'dataFrameOne.csv')

main2015.08 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-08.txt"))
main2015.09 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-09.txt"))
main2015.10 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-10.txt"))
main2015.11 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-11.txt"))
main2015.12 <- msaFilter(read.delim("mainTextFiles/main2015/main2015-12.txt"))

dataFrameTwo   <- do.call("rbind", list(main2015.08, 
                                        main2015.09, 
                                        main2015.10,
                                        main2015.11,
                                        main2015.12))

write.csv(dataFrameTwo, file = 'dataFrameTwo.csv')

                                    rm(main2015.12, 
                                       main2015.11, 
                                       main2015.10, 
                                       main2015.09, 
                                       main2015.08, 
                                       dataFrameTwo)
                                    
## Main 2016
main2016.01 <- msaFilter(read.delim("mainTextFiles/main2016/Main 2016-01.txt"))
main2016.02 <- msaFilter(read.delim("mainTextFiles/main2016/Main 2016-02.txt"))
main2016.03 <- msaFilter(read.delim("mainTextFiles/main2016/Main 2016-03.txt"))
main2016.04 <- msaFilter(read.delim("mainTextFiles/main2016/Main 2016-04.txt"))
main2016.05 <- msaFilter(read.delim("mainTextFiles/main2016/Main 2016-05.txt"))
main2016.06 <- msaFilter(read.delim("mainTextFiles/main2016/Main 2016-06.txt"))

dataFrameThree <- do.call("rbind", list(main2016.01, 
                                        main2016.02,
                                        main2016.03,
                                        main2016.04,
                                        main2016.05,
                                        main2016.06))

write.csv(dataFrameThree, file = 'dataFrameThree.csv')

                                    rm(main2016.01, 
                                       main2016.02,
                                       main2016.03,
                                       main2016.04,
                                       main2016.05,
                                       main2016.06, 
                                       dataFrameThree)
                                    
dataFrameOne   <- read.csv('dataFrameOne.csv')
dataFrameTwo   <- read.csv('dataFrameTwo.csv')
dataFrameThree <- read.csv('dataFrameThree.csv')
                                    
louisvilleData <- rbind(dataFrameOne, dataFrameTwo, dataFrameThree)

write.csv(louisvilleData, file = 'louisvilleData.csv')

rm(dataFrameOne, dataFrameTwo, dataFrameThree, louisvilleData)




## Join mainFile with certification data by jobID
louisvilleData <- read.csv('louisvilleData.csv')

louisvilleData <- louisvilleData %>%
                      select(3, 5:6, 10:13, 20:22, 27:34, 40:54)
louisvilleDataCert <- left_join(louisvilleData, allCerts, by = 'BGTJobId')

rm(allCerts)


write.csv(louisvilleDataCert, file = 'louisvilleDataCerts.csv')
