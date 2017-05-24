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
valdat='/home/joel/valData2009.txt' #args[1]
magstCol=3 #args[2]
lonCol=7 #args[3]
latCol=8 # args[4]

#====================================================================
# PARAMETERS FIXED
#====================================================================

#**********************  SCRIPT BEGIN *******************************

dat= read.table('/home/joel/valData2009.txt', sep=',', header=TRUE)


# FUNCTION
makePointShapeGeneriRc=function(lon,lat,data,proj='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'){
library(raster)
library(rgdal)
loc<-data.frame(lon, lat)
spoints<-SpatialPointsDataFrame(loc,as.data.frame(data), proj4string= CRS(proj))
return(spoints)
}

#CODE
shp=makePointShapeGeneriRc(lon=dat[,lonCol],lat=dat[,latCol],data=dat,proj='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
rst=raster('/home/joel/sim/topomap_test/grid6/landform.tif')
cp <- as(extent(rst), "SpatialPolygons")
id=which(over(shp, cp)==1)
plot(shp)
plot(rst, add=T)
valpoints=extract(rst,shp)
valIndex=which(is.na(valpoints)==FALSE)
magstVal= dat$Temp[valIndex]


dat= read.table('/home/joel/valData2009.txt', sep=',', header=TRUE)
magstMod=read.table('/home/joel/sim/topomap_test/grid6/meanX_X100.000000.txt'
