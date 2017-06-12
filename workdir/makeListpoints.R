#====================================================================
# SETUP
#====================================================================
#INFO
#use MAGST or MASD or SWE

#DEPENDENCY
require(raster)

#SOURCE

#====================================================================
# PARAMETERS/ARGS
#====================================================================
args = commandArgs(trailingOnly=TRUE)
wd=args[1] 
pointsFile=args[2]
#====================================================================
# PARAMETERS FIXED
#====================================================================

setwd(paste0(wd,'/predictors'))
predictors=list.files( pattern='*.tif$')
print(predictors)
rstack=stack(predictors)

dat= read.csv(pointsFile)
proj='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
lon=dat[,1]
lat=dat[,2]
loc <-data.frame(lon, lat)
shp <-SpatialPointsDataFrame(loc,as.data.frame(dat), proj4string= CRS(proj))
lp = extract(rstack,shp)
lp = data.frame(lp, lon,lat)
lp = na.omit(lp)
write.csv(lp, '../listpoints.txt', row.names=FALSE)

# Test if grid contains points and remove if not
library(rgeos)
raster <- rstack
poly  = shp
  ei <- as(extent(raster), "SpatialPolygons")
  if (gContainsProperly(poly, ei)) {
    print ("Grid contains points")
  } else if (gIntersects(poly, ei)) {
    print ("intersects")
  } else {
    print ("Grid contains no points, removing grid directory")
    system(paste0('rm -r ', wd))
  }

#Ensure grid names sequential

# compute svf for each point efficiently
#ele=raster('ele.tif')
#e <- extract(ele, shp, buffer=0.1)