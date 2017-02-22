library(xlsx) 
library(tidyr)
library(dplyr)

# importing data;
# Raw data inn is in xls workbook with five worksheets containing the
# three DwC formatted sheets "location","event", and "occurence", and 
# then a sheet "measurements" with various measuremens on individuals,
# and then the sheet "measurments_description" giving the description of 
# headers and measurment units and methods in the measurments sheet.

# name of xl file
xl.inn <- "Lepidurus_Zackenberg.xls"
# read data

occurrence <- read.xlsx2(file=xl.inn,sheetName="occurrence") # the sheet containing the occurence information 
event <- read.xlsx2(file=xl.inn, sheetName="event") # the sheet with the information about the sampling events
location <- read.xlsx2(file=xl.inn,sheetName="location") # the sheet with the information about the location
measurm_facts <- read.xlsx2(file=xl.inn,sheetName="measurment_and_facts") # measurements and facts
measurm_description <- read.xlsx2(file=xl.inn,sheetName="measurments_description") # description of the terms used in the measurment and facts sheet
DwC_remarks <- read.xlsx2(file=xl.inn,sheetName="DwC_remarks") # remarks about the specific use of Darwin Core terms in this dataset 

# The data for the event core is for convinience punched in two tables
# Here, we merge the location and event table
# into one table 

# first join event and occurence table 
event_CORE <- left_join(event, location)

# Prefere to use day,month,year format for dates since this is an XL based dataset 
# Here, we use the day,month,year columns to create date in ISO format
eventDate <- paste(event_CORE$year,event_CORE$month,event_CORE$day,sep="-")

# write output to workdir
write.csv(event_CORE, "event_CORE.csv",row.names=F)

# occurence core as is
occurrence_EXTENTION <- occurrence
write.csv(occurrence_EXTENTION, "occurrence_EXTENTION.csv",row.names=F)

# reshaping the measurments table from wide format 
# to long format and creates the 
# measurments and facts EXTENTION of a DwC Archive. 

#flatten out measurments and facts and link to measurments description
temporary <- gather(measurm_facts,key=locationID)
names(temporary) <- c("locationID","measurementType","measurementValue")

temporary2 <- inner_join(temporary, measurm_description, by = "measurementType")
measurements.extention  <- temporary2[!(temporary2$measurementValue==""),] # deleate all records without measurements
head(measurements.extention)

#"case specific" where measurments are recorded on location level - link measruments to eventID
temporary3 <- subset(event_CORE, select = c(locationID,eventID) )
measurements.extention2 <- left_join(measurements.extention, temporary3)
measurements_and_facts_EXTENTION <- subset(measurements.extention2, select = -c(locationID) )

write.csv(measurements_and_facts_EXTENTION, "measurements.extention.csv",row.names=F)

#######################################################################
# 
# Write out hte DwC term description sheet as csv table for documentation 
#
#####################################################################

write.table(DwC_remarks, "DwC_remarks.csv",row.names=F,sep=";")
