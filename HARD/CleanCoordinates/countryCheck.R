library(sp)
library(raster)
library(rgeos)
library(rgbif)

#pol is the refernece data for country coordinates.
Country <- function(x, countries, pol = NULL) {
  if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
    stop("Please install rnaturalearth.Aborting", 
         call. = FALSE)
  }
  pt <- SpatialPoints(x)
  
  if (is.null(pol)) {
    testpolys <- rnaturalearth::ne_countries(scale = "medium")
  } else {
    testpolys <- pol
  }
  testpolys <- crop(testpolys, extent(pt))
  
  country <- sp::over(x = pt, y = testpolys)[, "ISO3"]
  out <- as.character(country) == as.character(countries)
  out[is.na(out)] <- TRUE
  
  return(out)
}


#Driver
if (countrycheck) {
      if (verbose) {
        cat("running countrycheck test\n")
      }
      con <-CountryCheck(x, countries, pol = country.ref)   #country.ref is reference data
      if (verbose) {
        cat(sprintf("flagged %s records \n", sum(!con, na.rm = T)))
      }
    } else {
      con <- rep(NA, dim(x)[1])
    }
#con contains flagged records
