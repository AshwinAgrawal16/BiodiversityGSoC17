# exclude duplicates from the data
    if (is.matrix(x) | is.data.frame(x)) {
  if (duplicates) {
    cat("running duplicates test\n")
    if (is.null(species)) {
      dpl.test <- x
      warning("running duplicates test without species id-assuming single species in the dataset")
    } else {
      dpl.test <- data.frame(x, species)
    }
    dpl <- !duplicated(dpl.test)
    if (verbose) {
      cat(sprintf("flagged %s records \n", sum(!dpl)))
    }
  } else {
    dpl <- rep(NA, dim(x)[1])
  }
}
