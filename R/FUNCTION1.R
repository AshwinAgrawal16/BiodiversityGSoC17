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
      minimal=FALSE
    )
  }

  if(requireNamespace("rgbif", quietly = TRUE)){
    d1 <- d1$data
  }

  j<-which(is.na(d1[,"decimalLatitude"]))    #Checking decimalLatitude for NA values
  k<-which(is.na(d1[,"decimalLongitude"]))   #Checking decimalLongitude for NA values
  i<-which(is.na(d1[,"name"]))               #Checking name for NA values
  l<-which(is.na(d1[,"countryCode"]))        #Checking countrycode for NA values
  r<-which(is.na(d1[,"scientificName"]))
  if(length(i)!=0)
    d1<-d1[-i,]
  if(length(k)!=0)
    d1<-d1[-k,]
  if(length(j)!=0)
    d1<-d1[-j,]
  if(length(l)!=0)
    d1<-d1[-l,]
  if(length(r)!=0)
    d1<-d1[-r,]


  #Caveat: while the API accepts scientific names as specified in the DarwinCore Standard, currently some tools only work if the "Genus"+"Specific Epithet" binomial is provided in this field.
  #Thus, instead of "Puma concolor (Linnaeus, 1771)", we recommend using just "Puma concolor" in the 'scientificName' field.
  #To follow the abve code copying the name to scientificName column
  for(i in 1:nrow(d1))
  {
    d1[i,"scientificName"]=d1[i,"name"]
  }

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
  library(rgeospatialquality)
  if(requireNamespace("rgbif")){
    i=0
    while(i<=4000)
    {
      if(i+1000>nrow(d1))
        dat<-subset(d1[(i+1):nrow(d1),])
      if(i+1000<=nrow(d1))
        dat<-subset(d1[(i+1):(i+1000),])
      
      
      dd1 <- add_flags(dat)
      #str(dd1)
      dd1[1,]$flags    ## Flags for the first record
      i=i+1000
    }
  }
  #End
}
