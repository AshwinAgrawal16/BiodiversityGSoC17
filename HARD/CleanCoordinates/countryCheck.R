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