library(dplyr)


file2015_01 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-01.txt")
file2015_02 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-02.txt")
file2015_03 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-03.txt")
file2015_04 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-04.txt")
file2015_05 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-05.txt")
file2015_06 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-06.txt")
file2015_07 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-07.txt")
file2015_08 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-08.txt")
file2015_09 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-09.txt")
file2015_10 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-10.txt")
file2015_11 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-11.txt")
file2015_12 <- read.delim("StdMajor Text Files/StdMajor 2015/StdMajor 2015-12.txt")

file2016_01 <- read.delim("StdMajor Text Files/StdMajor 2016/StdMajor 2016-01.txt")
file2016_02 <- read.delim("StdMajor Text Files/StdMajor 2016/StdMajor 2016-02.txt")
file2016_03 <- read.delim("StdMajor Text Files/StdMajor 2016/StdMajor 2016-03.txt")
file2016_04 <- read.delim("StdMajor Text Files/StdMajor 2016/StdMajor 2016-04.txt")
file2016_05 <- read.delim("StdMajor Text Files/StdMajor 2016/StdMajor 2016-05.txt")
file2016_06 <- read.delim("StdMajor Text Files/StdMajor 2016/StdMajor 2016-06.txt")

allStdMajor <- rbind(file2015_01,
                file2015_02,
                file2015_03,
                file2015_04,
                file2015_05,
                file2015_06,
                file2015_07,
                file2015_08,
                file2015_09,
                file2015_10,
                file2015_11,
                file2015_12,
                file2016_01,
                file2016_02,
                file2016_03,
                file2016_04,
                file2016_05,
                file2016_06)

rm(file2015_01,
   file2015_02,
   file2015_03,
   file2015_04,
   file2015_05,
   file2015_06,
   file2015_07,
   file2015_08,
   file2015_09,
   file2015_10,
   file2015_11,
   file2015_12,
   file2016_01,
   file2016_02,
   file2016_03,
   file2016_04,
   file2016_05,
   file2016_06)

write.csv(allStdMajor, file ='louisvilleDataStdMajor.csv')

