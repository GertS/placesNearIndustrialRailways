# Job de pater 20
# 160109
# Assignement 6 GeoScripting

library(rgdal)

# Download data -----------------------------------------------------------

placeURL <- "www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip"
railURL <- "www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip"

dir.create("data", showWarnings = FALSE)

inputZip <- list.files(path='data', pattern= '^.*\\.zip$')
if (length(inputZip) == 0){ ##only download when not alrady downloaded (safes time to debug the whole script)
  download.file(url = placeURL, destfile = 'data/places.zip', method = 'wget')
  download.file(url = railURL, destfile = 'data/rails.zip', method = 'wget')
}

places <- unzip('data/places.zip', exdir='data/places')
rails <- unzip('data/rails.zip', exdir='data/rails')

dsn = file.path("data","places.shp")

