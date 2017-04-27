#====================================================================
# SETUP
#====================================================================
#INFO

#DEPENDENCY
require(raster)

#SOURCE

#====================================================================
# PARAMETERS/ARGS
#====================================================================
args = commandArgs(trailingOnly=TRUE)
wd= args[1]
#====================================================================
# PARAMETERS FIXED
#====================================================================

#**********************  SCRIPT BEGIN *******************************
setwd(wd)
eraExtent=raster(paste0(wd,'/eraExtent.tif'))


Nruns=ncell(eraExtent)
for (i in 1:Nruns){
dir.create(paste0('grid',i))
}

r=setValues(eraExtent,1:Nruns)
plot(extentPoly[extentPoly$eraExtent==1,])


