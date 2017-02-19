#' @title Retrieve GBIF occurrence data and push it to Geospatial Quality API
#'
#' @description
#' \code{FUNCTION} Function to retrieve GBIF occurrence data of all terrestrial mammals in Australia and then sends all of them to the Geospatial Quality API.
#'
#' @return Returns the data retrieved in string format and the pushed data to Geospatial Quality API.
#' @examples
#' FUNCTION()
#' @export

FUNCTION<-function(){
  if(requireNamespace("rgbif", quietly = TRUE)){
    library(rgbif)
    
    d1 <- occ_data(
      country = "AU",     # Country code for australia
      classKey= 359,      # Class code for mammalia
      from = 'gbif',
      limit=5000,
      minimal=FALSE,
      hasCoordinate = T
      
    )
  }
  
  if(requireNamespace("rgbif", quietly = TRUE)){
    d1 <- d1$data
  }
  
  
  ## Cleaning the data .
  library(tidyr)
  d1<-d1 %>% drop_na(decimalLatitude,decimalLongitude,countryCode,scientificName,name)
  
  d1$scientificName<-d1$name
  #Caveat: while the API accepts scientific names as specified in the DarwinCore Standard, currently some tools only work if the "Genus"+"Specific Epithet" binomial is provided in this field.
  #Thus, instead of "Puma concolor (Linnaeus, 1771)", we recommend using just "Puma concolor" in the 'scientificName' field.
  #To follow the abve code copying the name to scientificName column
  
  
  #Checking the values to conform to the DarwinCore Standard
  #decimalLatitude: Value for the Latitude in decimal degrees format (e.g. 42.332)
  #decimalLongitude: Value for the Longitude in decimal degrees format (e.g. -1.833)
  #countryCode: 2 character ISO code for the country
  #scientificName
  
  if(requireNamespace("rgbif", quietly = TRUE)){
    "decimalLatitude" %in% names(d1)
    "decimalLongitude" %in% names(d1)
    "countryCode" %in% names(d1)
    "scientificName" %in% names(d1)
  }

  #Pushing the data to Geospatial Quality API.
  #Hard limit of 1000 is set in the function add_flags.
  d5<-data.frame()
  library(rgeospatialquality)
  if(requireNamespace("rgbif")){
    i=0
    while(i<=4000)
    {
      if(i+1000>nrow(d1))
        dat<-subset(d1[(i+1):nrow(d1),])
      if(i+1000<=nrow(d1))
        dat<-subset(d1[(i+1):(i+1000),])
      
      i=i+1000
      
      ddd1 <- (add_flags(dat))
      ##Appending the data of flags in ome whole data frame
      d5<-rbind(d5,ddd1$flags)
      
    }
  }
  
  ##Appending the flagged data with original data.
  D<-cbind(d5,d1)
  View(D)
  #End
}
