# Job de pater 20
# 160109
# Assignement 6 GeoScripting

library(rgdal)
library(rgeos)
library(sp)


# Download data -----------------------------------------------------------

placeURL <- "www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip"
railURL <- "www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip"

dir.create("data", showWarnings = FALSE)

inputZip <- list.files(path='data', pattern= '^.*\\.zip$')
if (length(inputZip) == 0){ ##only download when not alrady downloaded (safes time to debug the whole script)
  download.file(url = placeURL, destfile = 'data/places.zip', method = 'wget')
  download.file(url = railURL, destfile = 'data/rails.zip', method = 'wget')
}


placesDir = 'data/places'
railsDir = 'data/rails'

unzip('data/places.zip', exdir=placesDir)
unzip('data/rails.zip', exdir=railsDir)


# Read data ---------------------------------------------------------------

places <- readOGR(dsn = placesDir, layer = "places")
rails <- readOGR(dsn = railsDir, layer = "railways")


# Buffer data -------------------------------------------------------------

indusRails <- subset(rails, rails$type == "industrial")

#projections:
prj_string_WGS <- CRS("+proj=longlat +datum=WGS84")
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

indusRailsRD <- spTransform(indusRails,prj_string_RD)
indusRailsBuffer <- gBuffer(indusRailsRD,width = 5000,byid=TRUE)
indusRailsWGS <- spTransform(indusRailsBuffer, prj_string_WGS)


# Intersect ---------------------------------------------------------------

placesWGS <- spTransform(places, prj_string_WGS)
placesInBuffer <- gIntersection(placesWGS,indusRailsWGS,byid=TRUE)


# Find City ---------------------------------------------------------------

placesIDList <- strsplit(rownames(placesInBuffer@coords),split = " ")
placesID <- lapply(placesIDList, function(n) n[1])
placesInBufferStrings <- placesWGS[as.numeric(placesID),]

# City and population -----------------------------------------------------

# Utrecht, population: 100000
# lapply(placesInBufferStrings,function(n) print(n))
print(paste(as.character(placesInBufferStrings$name),"with a population around:",as.character(placesInBufferStrings$population)))


# Plot --------------------------------------------------------------------


plot(indusRailsWGS, col = "lightblue", lwd=2, add=F)
plot(indusRails, col = "red", lwd=5, add=T)
# text(max(bbox(indusRails)[1,]), max(bbox(indusRails)[2,]), "Industrial \n railroads")
plot(placesInBuffer, pch=19, cex=2, col = "red", add=T)
text(placesInBufferStrings@coords[,1], placesInBufferStrings@coords[,2], labels = placesInBufferStrings$name)

text(placesInBuffer@coords[1], placesInBuffer@coords[2], labels = placesInBufferStrings$name)
# plot arrow for indicating buffer
range <- bbox(indusRailsWGS)

