#prepare output data
  
  out <- list(val, zer, cen, urb, con)
  
  out <- Reduce("&", out)
  
  if (verbose) {
    if (!is.null(out)) {
      cat(sprintf("flagged %s of %s records, EQ = %s \n", sum(!out, na.rm = T), 
                  length(out), round(sum(!out, na.rm = T)/length(out), 2)))
    } else {
      cat("flagged 0 records, EQ = 0 \n")
    }
  }
