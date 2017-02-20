library(sp)
library(raster)
library(rgeos)
library(rgbif)

UrbanCoordinates <- function(x, ref = NULL) {
  pts <- SpatialPoints(x)
  limits <- extent(pts) + 1
  
  if (is.null(ref)) {
    stop("No referencepolygons found. Set 'urban.ref'")
  }
  
  ref <- crop(ref, limits)
  
  urban <- over(x = pts, y = ref)[, 1]
  out <- is.na(urban)
  
  return(out)
}
