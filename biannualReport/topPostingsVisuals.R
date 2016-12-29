library(ggplot2)
library(scales)
library(dplyr)


## ADJUST LIVING WAGE HERE 
mitLivingWage <- 22.73

## ORIGINAL DATAFRAME
originalData <- read.csv('topJobPostings.csv')

## CREATE SEPERATE DATASETS FROM ORIGINAL
topPostings <- originalData %>% top_n(30, deduplicated)
livingWageTopPostings <- originalData %>% 
                          filter(Median.Hourly.Earnings >= mitLivingWage) %>%
                          top_n(30, deduplicated)

## MAKE A FUNCTION
makePlots <- function(dataTable, upperLimit) {
p <- ggplot(dataTable, aes(x = reorder(Occupation, deduplicated), y = deduplicated, fill = Typical.Entry.Level.Education, 
                           label = paste(Pct..25.Hourly.Earnings, '-', Pct..75.Hourly.Earnings), 
                           width = .8)) + 
                       geom_bar(stat = 'identity', color = 'black')
p                 + 
  coord_flip()    + 
  theme_minimal() + 
  geom_text(hjust = -.1, size = 20) +
  ylab('Job Postings in Quarter')   +
  theme(axis.ticks.y      = element_blank(), 
        axis.text.y       = element_text(size = 50, face = 'bold'), 
        axis.text.x       = element_text(size = 60), 
        legend.title      = element_text(size = 75),
        legend.text       = element_text(size = 60), 
        legend.position   = c(.7, .7), 
        legend.key        = element_rect(color = 'white', size = 10),
        legend.key.size   = unit(5, 'lines'), 
        legend.background = element_blank(),
        axis.title        = element_blank(), 
        panel.grid.major  = element_line(size = .5, color = "grey")) + 
  scale_y_continuous(limits = c(0, upperLimit), expand = c(0,0))    +
  scale_fill_discrete(name  = 'Typical Entry-Level Education \n')
}

png(file="topPostings.png", width = 4000, height = 4000)
makePlots(topPostings, 3450)
dev.off()

makePlots(livingWageTopPostings, 1650)



## PIE CHARTS
topPostings$deduplicated <- round(topPostings$deduplicated, 0)
topPostings$deduplicated <- as.numeric(as.character(topPostings$deduplicated))

allPostings <- count(topPostings, Typical.Entry.Level.Education, wt = deduplicated)


allPostings$percent <-  allPostings$n/sum(allPostings$n)
q <- ggplot(allPostings, aes(x ='', y = n, 
                             fill = Typical.Entry.Level.Education, 
                             label = percent(percent))) +
      geom_bar(width = 1, stat = 'identity') + 
      geom_text() 

q + coord_polar("y", start = 0) + theme_void() + 
  theme(axis.text.x=element_blank())
