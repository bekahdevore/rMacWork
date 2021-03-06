library(dplyr)
library(RCurl)

socNamesConnection   <- getURL('https://docs.google.com/spreadsheets/d/1wWVpXkU7OG2dGjCEEOK4Z4sS02tgK9_zee9cl0MdQRE/pub?gid=0&single=true&output=csv')
emsiWageConnection   <- getURL("https://docs.google.com/spreadsheets/d/1CT9R_MIs_s7ULDm-RCexVsW9m6LZa26EqH0Cd3LEB3k/pub?gid=0&single=true&output=csv")
socNames             <- read.csv(textConnection(socNamesConnection))
                        colnames(socNames)[1] <- "socGroup"
socNames             <- socNames %>% select(1:2)

wageRanges           <- read.csv(textConnection(emsiWageConnection))
wageRanges           <- select(wageRanges, 1:4)

louisvilleDataCerts  <- read.csv('louisvilleDataCerts.csv')
employersData        <- louisvilleDataCerts %>% select(1, 9)
credentialsToOccupations <- louisvilleDataCerts %>% select(1:2, 5:6, 22, 36)
credentialsToOccupations <- na.omit(credentialsToOccupations)
credentialsToOccupations <- credentialsToOccupations %>% filter(SOC != "na")
rm(louisvilleDataCerts)

louisvilleDataMajor  <- read.csv('louisvilleDataStdMajor.csv')
louisvilleDataMajor  <- louisvilleDataMajor %>% select(2, 4)
louisvilleDataMajor  <- na.omit(louisvilleDataMajor)

#cip                 <- read.csv('louisvilleDataCIP.csv')
#major               <- read.csv('louisvilleDataStdMajor.csv')

#certifications      <- louisvilleDataCerts %>%
#                                 select(2, 36)
credentialsMajors <- left_join(credentialsToOccupations, louisvilleDataMajor, by = 'BGTJobId')
credentialsMajors <- na.omit(credentialsMajors)
credentialsMajors <- credentialsMajors %>% select(3:7)


## CREDENTIAL BY EDUCATION LEVEL
#credentialByEducationLevel <- louisvilleDataCerts %>%
#                                 select(2, 20:23, 36)

#credentialByEducationLevel <- na.omit(credentialByEducationLevel)
#summary(credentialByEducationLevel)

#write.csv(credentialByEducationLevel, file = "credentialByEducation.csv")


## CREDENTIAL TO OCCUPATION SANKEY


credentialsToOccupations <- louisvilleDataCerts %>% select(2:6)
credentialsToOccupations <- credentialsToOccupations %>% 
                                      group_by(SOC, Certification) %>%
                                      tally  %>%
                                      group_by(SOC) 

# Seperate first two numbers of SOC codes and put in new variable
splitSOC <- as.data.frame(t(sapply(credentialsToOccupations$SOC, function(x) substring(x, first=c(1, 1), last=c(2, 7)))))

# Change column names 
colnames(splitSOC)[1] <- "socGroup"
colnames(splitSOC)[2] <- "SOC"

splitSOC <- splitSOC %>% select(2, 1)
splitSOC <- unique(splitSOC)

credentialsToOccupations            <- left_join(credentialsToOccupations, splitSOC, by = 'SOC')
  credentialsToOccupations$socGroup <- as.character(credentialsToOccupations$socGroup)
  socNames$socGroup                 <- as.character(socNames$socGroup)
  
credentialsToOccupations <- left_join(credentialsToOccupations, socNames, by = "socGroup")

socNames4Digit    <- louisvilleDataCerts %>% select(5:6)
socNames4Digit    <- socNames4Digit      %>% filter(SOC != 'na')
socNames4Digit    <- unique(socNames4Digit)

credentialsToOccupations <- left_join(credentialsToOccupations, socNames4Digit, by = "SOC")
credentialsToOccupations <- credentialsToOccupations %>% filter(socGroup != 55)

credentialsToOccupations <- left_join(credentialsToOccupations, wageRanges, by = 'SOC')

credentialsToOccupations$label <- paste(credentialsToOccupations$SOCName, 
                                        "(", credentialsToOccupations$Pct..25.Hourly.Earnings, "-",
                                        credentialsToOccupations$Pct..75.Hourly.Earnings,")",
                                        sep = '\n') 

credentialsToOccupations <- credentialsToOccupations %>% select(7, 10, 2:3, 5:4, 1)

#colnames(credentialsToOccupations)[1] <- 'source'
#colnames(credentialsToOccupations)[2] <- 'target'
#colnames(credentialsToOccupations)[3] <- 'value'

write.csv(credentialsToOccupations, file = "sankey.csv")
write.csv(credentialsMajors,        file = "majors.csv")
write.csv(employersData,            file = "employers.csv")

#cip             <- cip %>%
#                    select(2, 4)
# Remove NA
#certifications <- na.omit(certifications)

#louisvilleDataAll <- left_join(louisvilleDataCerts)

