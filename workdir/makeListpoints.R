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

#====================================================================
# PARAMETERS FIXED
#====================================================================

setwd(paste0(wd,'/predictors'))
predictors=list.files( pattern='*.tif$')
print(predictors)
rstack=stack(predictors)

dat= read.csv('../points.txt')
proj='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
lon=dat[,1]
lat=dat[,2]
loc<-data.frame(lon, lat)
shp<-SpatialPointsDataFrame(loc,as.data.frame(dat), proj4string= CRS(proj))
lp=extract(rstack,shp)
write.csv(lp, '../listpoints.txt', row.names=FALSE)

# compute svf for each point efficiently
ele=raster('ele.tif')

e <- extract(ele, shp, buffer=0.1)