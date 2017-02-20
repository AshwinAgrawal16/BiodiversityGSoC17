ValidCoordinates <- function(x) {
  out <- list(is.na(x$decimallongitude), is.na(x$decimallatitude), 
              suppressWarnings(is.na(as.numeric(as.character(x$decimallongitude)))), 
              suppressWarnings(is.na(as.numeric(as.character(x$decimallatitude)))), 
              suppressWarnings(as.numeric(as.character(x$decimallongitude))) < -180, 
              suppressWarnings(as.numeric(as.character(x$decimallongitude))) > 180, 
              suppressWarnings(as.numeric(as.character(x$decimallatitude))) < -90,
              suppressWarnings(as.numeric(as.character(x$decimallatitude))) > 90)
  
  out <- !Reduce("|", out)
  return(out)
}

#Driver
if (verbose) {
      cat("running validity test\n")
    }
    val <- ValidCoordinates(x)
    
    if (!all(val)) {
      stop("invalid coordinates found, clean dataset before further tests:\n", 
           paste(which(val == FALSE), "\n"))
    }
