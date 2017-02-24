#displaying the map using shiny app
library(rgbif)
library(mapr)
map1 <- function(country,classKey){
  data <- occ_search(
    country = country,
    classKey = as.numeric(classKey),
    limit= 100,hasCoordinate = T)
  
  map_ggmap(data)
}
