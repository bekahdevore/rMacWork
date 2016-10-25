library(dplyr)

louisvilleDataCert <- left_join(louisvilleData, allCerts, by = 'BGTJobId')

rm(allCerts)
