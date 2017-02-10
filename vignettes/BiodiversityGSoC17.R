## ---- fig.show='hold',fig.width = 5 ,fig.height = 5----------------------
library(rgbif)
library(maptools)
d1 <- occ_data(
  country = "AU",     # Country code for australia
  classKey= 359,      # Class code for mammalia
  from = 'gbif',
  limit=500,
  minimal=FALSE
)

d1 <- d1$data
View(d1)
plot(d1[,4:3], cex=1.0, col='blue')
data(wrld_simpl)
plot(wrld_simpl, add=TRUE)

