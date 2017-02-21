library(curl)
temp <- tempfile()
curl_download("http://gbif.vm.ntnu.no/ipt/archive.do?r=bear_island_testfishing&v=1.2", tmp)

unzip(temp, files = c("occurrence.txt","measurementorfact.txt"), list = F)
occurrence <- read.table("occurrence.txt",sep="\t",header = T)
measurementorfact <- read.table("measurementorfact.txt",sep="\t",header = T)



library(tidyr)
library(dplyr)


measurementorfact_wide <- measurementorfact %>% select(id,measurementType,measurementValue) %>% 
  spread(key=measurementType,value=measurementValue) 
cdw <- left_join(occurrence,measurementorfact_wide)
View(cdw)
