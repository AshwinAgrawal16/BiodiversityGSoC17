library(rvertnet)
rvertnet1<-function(taxon,countrycode){
  res <- vertsearch(taxon = taxon,country=countrycode)
  DATA<-res$data

if("scientificName" %in% names(DATA)==FALSE)
{colnames(DATA)[which(names(DATA) == "scientificname")] <- "scientificName"}
if("countryCode" %in% names(DATA)==FALSE)
colnames(DATA)[which(names(DATA) == "countrycode")] <- "countryCode"

x<-DATA

if("decimalLongitude" %in% names(x) & "decimalLatitude" %in% names(x)) {
  # x <- x[, c("decimalLongitude", "decimalLatitude")]
  warning("columns name correct according to GQAPI")
}

if("decimallongitude" %in% names(x) & "decimallatitude" %in% names(x)) {
  x <- x[, c("decimallongitude", "decimallatitude")]
  DATA<-DATA[ , -which(names(DATA) %in% c("decimallongitude", "decimallatitude"))]
  warning("Correcting names for GQ API and DwC format")
  names(x) <- c("decimalLongitude", "decimalLatitude")
  DATA<-cbind(DATA,x)
}

if("longitude" %in% names(x) & "latitude" %in% names(x)) {
  x <- x[, c("longitude", "latitude")]
  DATA<-DATA[ , -which(names(DATA) %in% c("longitude", "latitude"))]
  names(x) <- c("decimalLongitude", "decimalLatitude")
  DATA<-cbind(DATA,x)
  warning("Correcting names for GQ API and DwC format")
}
return(DATA)
}

#Example
DATA<-rvertnet1("mammalia","US")
#Pushing to GQ API
library(rgeospatialquality)
flag<-add_flags(DATA)
