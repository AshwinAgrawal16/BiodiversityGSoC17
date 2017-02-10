#' @title Retrieve GBIF occurrence data and push it to Geospatial Quality API
#'
#' @description
#' \code{FUNCTION} Function to retrieve GBIF occurrence data of all terrestrial mammals in Australia and then sends all of them to the Geospatial Quality API.
#'
#' @param empty
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
      limit=500,
      minimal=FALSE
    )
  }


  if(requireNamespace("rgbif", quietly = TRUE)){
    d1 <- d1$data
    str(d1)
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

  library(rgeospatialquality)

  if(requireNamespace("rgbif", quietly = TRUE)){
    dd1 <- add_flags(d1)
    str(dd1)
    dd1[1,]$flags  # Flags for the first record
  }

  #End

}
