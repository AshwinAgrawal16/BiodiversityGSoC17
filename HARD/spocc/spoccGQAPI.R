cleanSpocc<-function(species,portal,region){
  library(spocc)
  out <- occ(query=species, from=portal, ebirdopts=list(region=region))
  X<-occ2df(out)
  X[,"scientificName"]<-X[,"name"]
  X[,"countryCode"]<-region
  #flg<-add_flags(X)
  x<-X
  if("decimallongitude" %in% names(x) & "decimallatitude" %in% names(x)) {
    x <- x[, c("decimallongitude", "decimallatitude")]
    X<-X[ , -which(names(X) %in% c("decimallongitude", "decimallatitude"))]
    warning("Correcting names for GQ API and DwC format")
    names(x) <- c("decimalLongitude", "decimalLatitude")
    X<-cbind(X,x)
  }
  if("decimalLongitude" %in% names(x) & "decimalLatitude" %in% names(x)) {
    # x <- x[, c("decimalLongitude", "decimalLatitude")]
    warning("columns name correct according to GQAPI")
  }
  if("longitude" %in% names(x) & "latitude" %in% names(x)) {
    x <- x[, c("longitude", "latitude")]
    X<-X[ , -which(names(X) %in% c("longitude", "latitude"))]
    names(x) <- c("decimalLongitude", "decimalLatitude")
    X<-cbind(X,x)
    warning("Correcting names for GQ API and DwC format")
  }
  return(X)
  
}


#Example using the above function and pushing data to GQ API
dat1<-cleanSpocc('Setophaga caerulescens','ebird','US')
#For cleaning of records the previous function developed for gbif data can be integrated
flag<-add_flags(dat1)
dat1<-cbind(dat1,flag$flags)
View(dat1)

