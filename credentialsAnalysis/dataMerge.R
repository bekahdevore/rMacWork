library(dplyr)

louisvilleDataCert <- left_join(louisvilleData, allCerts, by = 'BGTJobId')

rm(allCerts)


write.csv(louisvilleDataCert, file = 'louisvilleDataCerts.csv')
