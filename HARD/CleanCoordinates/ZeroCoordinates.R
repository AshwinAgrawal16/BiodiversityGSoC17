library(sp)
library(raster)
library(rgeos)
library(rgbif)

ZeroCoordinates <- function(x, pointlimit = 0.5) {
  pt <- sp::SpatialPoints(x)
  out <- rep(T, nrow(x))
  
  # plain zero in coordinates
  out[which(x$decimallongitude == 0 | x$decimallatitude == 0)] <- FALSE
  
  # if radius arounf point is 0
  Test <- rgeos::gBuffer(sp::SpatialPoints(cbind(0, 0)), width = pointlimit)
  out[which(!is.na(over(y = Test, x = pt)))] <- FALSE
  
  # if lat == long
  out[which(x$decimallongitude == x$decimallatitude)] <- FALSE
  
  return(out)
} 

#Example
#By default zeros and verbose =true
zeros=T
verbose=T
if (zeros) {
      if (verbose) {
        cat("running zero coordinate test\n")
      }
      zer <- ZeroCoordinates(x, pointlimit = zeros.rad)   #zeros.rad=reference data
      if (verbose) {
        cat(sprintf("flagged %s records \n", sum(!zer)))
      }
    } else {
      zer <- rep(NA, dim(x)[1])
    }
#zer is the flagged matrix
