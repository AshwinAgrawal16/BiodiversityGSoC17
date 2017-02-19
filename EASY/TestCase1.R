library(rgbif)
library(rgeospatialquality)

if(requireNamespace("rgbif", quietly = TRUE)){


  d1 <- occ_data(
    scientificName="Perameles nasuta",
    limit=500,
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


#values must conform to the DarwinCore Standard

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





if(requireNamespace("rgbif", quietly = TRUE)){
  dd <- add_flags(d1)
  dd[1,]$flags  # Flags for the first record
}
