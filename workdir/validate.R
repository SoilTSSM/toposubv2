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
valdat=args[1]
modDat=args[2]
magstCol=args[3]
lonCol=args[4]
latCol=args[5]
gridPath=args[6]


#====================================================================
# PARAMETERS FIXED
#====================================================================

#**********************  SCRIPT BEGIN *******************************
setwd(gridPath)
dat= read.table(valdat, sep=',', header=TRUE)


# FUNCTION
makePointShapeGeneriRc=function(lon,lat,data,proj='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
	{
	library(raster)
	library(rgdal)
	loc<-data.frame(lon, lat)
	spoints<-SpatialPointsDataFrame(loc,as.data.frame(data), proj4string= CRS(proj))
	return(spoints)
	}

#CODE
shp=makePointShapeGeneriRc(lon=dat[,lonCol],lat=dat[,latCol],data=dat,proj='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')


rst=raster(('landform.tif')
cp <- as(extent(rst), "SpatialPolygons")
id=which(over(shp, cp)==1)
plot(shp)
plot(rst, add=T)
valpoints=extract(rst,shp)
valIndex=which(is.na(valpoints)==FALSE)
magstVal= dat$Temp[valIndex]
modfile=read.table(modDat)
magstMod=magstMod[valIndex]