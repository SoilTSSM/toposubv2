#==================================================================
# SETUP
#=================================================================
source("/home/joel/src/TOPOMAP/toposubv2/workdir/toposub_src.R")
wd="/home/joel/sim/topomap_test/"
outDirPath ="/home/joel/data/MODIS_ARC/"#given in MODISoptions()


#==================================================================
# script
#=================================================================
setwd(wd)


#make horizon files MOVED TO SEPERATE SCRISPT
#hor(listPath=wd)

#prepare surface map

require('MODIS') # https://cran.r-project.org/web/packages/MODIS/MODIS.pdf
require('rgdal') #dont understand why need to load this manually
#getProduct() #identify products to download
myextent=raster('predictors/ele.tif') # output is projected and clipped to this extent

#getSds(HdfName='/home/joel/data/MODIS_ARC/MODIS/MOD13Q1.005/2000.08.12/MOD13Q1.A2000225.h25v06.005.2006307225438.hdf', SDSstring="250m 16 days NDVI") # incorrect result

mydates=c("2000-08-12", "2004-08-12","2008-08-12","2012-08-12","2016-08-12")

for (mydate in mydates){

runGdal(product='MOD13Q1', collection = NULL, begin = mydate, end = mydate, extent = myextent, tileH = NULL, tileV = NULL, buffer = 0,SDSstring = "1 0 0 0 0 0 0 0 0 0 0 0", job = NULL, checkIntegrity = TRUE, wait = 0.5, forceDownload = TRUE, overwrite = FALSE)
}
#scale product by 0.0001 to get 0-1

setwd(outDirPath)
modStack=stack(list.files(pattern='*.tif', recursive = TRUE))

















#get modal surface type of each sample 1=debris, 2=steep bedrock, 3=vegetation
zoneStats=getSampleSurface(spath=wd,Nclust=Nclust, predFormat=predFormat)
write.table(zoneStats, paste(spath,'/landcoverZones.txt',sep=''),sep=',', row.names=F)




#surface
getSampleSurface=function(spath,nclust){
require(raster)
lc=raster(paste(spath,'/surface.tif',sep=''))
zones=raster(paste(spath,'/landform_',nclust,'.tif',sep=''))
zoneStats=zonal(lc,zones, modal,na.rm=T)
return(zoneStats)
}

write.table(zone.stats, paste(spath,'landcoverZones.txt',sep=''),sep=',', row.names=F)
