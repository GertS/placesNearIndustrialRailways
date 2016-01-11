# Job de pater 20
# 160109
# Assignement 6 GeoScripting



# Download data -----------------------------------------------------------

placeURL <- "www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip"
railURL <- "www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip"

dir.create("data", showWarnings = FALSE)
download.file(url = placeURL, destfile = 'data/places.zip', method = 'wget')
download.file(url = railURL, destfile = 'data/rails.zip', method = 'wget')

places <- unzip('data/places.zip', exdir='data/places')
rails <- unzip('data/rails.zip', exdir='data/rails')
