
# ERA box are defined at their centres (7.5, 46.5)
 # This function takes user defined coords as input and return nearest (outer) era-grid boundary

# example call makeBbox.R '/home/joel/src/TOPOMAP/toposubv2/topoMAPP/dat/eraigrid75.tif' ,'lonW',9

args = commandArgs(trailingOnly=TRUE)
file=args[1] # 0.25 0r 0.75 era grid fullpath
coordID=args[2] # id of coord eg lonW lonE latS latN
coord=args[3] # value of coord eg '9'

require(raster)
rst=raster(file)
library(sp)
e <- as(raster::extent(lonw, lone, lats, latn), "SpatialPolygons")
proj4string(e) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
plot(e,add=T)
plot(crop(e75,e, snap='out'))
ext=extent(crop(e75,e, snap='out'))

if (coord=='lonW'){cat(as.numeric(ext@xmin))}
if (coord=='lonE'){cat(as.numeric(ext@xmax))}
if (coord=='latN'){cat(as.numeric(ext@ymax))}
if (coord=='latS'){cat(as.numeric(ext@ymin))}



