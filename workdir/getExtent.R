# return extent of a raster as individul components
# args:
# pathtofile
# one of: lonW,lonE,latN,latS


args = commandArgs(trailingOnly=TRUE)
file=args[1]
coord=args[2]


require(raster)
r=raster(file)
myextent=extent(r)

if (coord=='lonW'){cat(as.numeric(myextent@ymin))}
if (coord=='lonE'){cat(as.numeric(myextent@ymax))}
if (coord=='latN'){cat(as.numeric(myextent@xmax))}
if (coord=='latS'){cat(as.numeric(myextent@xmin))}