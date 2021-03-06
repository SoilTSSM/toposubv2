
#R packages
require(raster)
require(horizon)

#==================================================================
# SETUP
#=================================================================
#workdir
wd="/home/joel/sim/topomap_test/"
dir.create(paste0(wd,'/predictors'))


#DEM Data dir
demDir="/home/joel/data/DEM/srtm"
setwd(demDir)

#parse credentials file to get user/pwd: https://urs.earthdata.nasa.gov/profile
USER=unlist(strsplit(readLines("~/.credentials_earthdata")[[1]],"="))[2]
PWD=unlist(strsplit(readLines("~/.credentials_earthdata")[[2]],"="))[2]

#use commandline args
#https://www.r-bloggers.com/passing-arguments-to-an-r-script-from-command-lines/

type="bbox" #"points or "bbox"

#points input
lon=c(85.52 ,85.68,84.2)
lat=c(28.1 ,28.3, 27.8)

#bbox=(e,s,w,n)
bbox=c(85.1, 27.8, 85.8, 27.7)

compute_svf<-FALSE

#==================================================================
# DEM retrieval based on set of points:
#=================================================================
if (type == "points"){
	setwd(demDir)
	df=data.frame(lon,lat)

	#find unique llcorner
	df2=unique(floor(df))

	#clean up
	system("rm SRTMDAT*")
	system("rm *.hgt")

	for (i in 1:(dim(df2)[1])){
		if (sign(df2$lat[i])==-1){LATVAL<-"S"}
		if (sign(df2$lat[i])==1){LATVAL<-"N"}
		if (sign(df2$lon[i])==-1){LONVAL<-"W"}
		if (sign(df2$lon[i])==1){LONVAL<-"E"}
		lon_pretty=formatC(df2$lon[i],width=3,flag="0")
		#get tile
		filetoget=paste0(LATVAL,df2$lat[i],LONVAL,lon_pretty,".SRTMGL1.hgt.zip")
		filetogetUNZIP=paste0(LATVAL,df2$lat[i],LONVAL,lon_pretty,".hgt")

	if (file.exists(filetoget)){ #dont download again
	   print(paste0(filetoget, " exists"))
	   	system(paste0("unzip ", filetoget))
		system(paste0("gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 ", filetogetUNZIP, " SRTMDAT",i,".tif"))
		} else {
		 
			system(paste0("wget --user ", USER ,  " --password " ,PWD, " http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/",filetoget))
			# extract
			system(paste0("unzip ", filetoget))
			system(paste0("gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 ", filetogetUNZIP, " SRTMDAT",i,".tif"))
		}
	}
}
#


#==================================================================
# DEM retrieval based on bbox
#=================================================================
if (type == "bbox"){
	setwd(demDir)
	floorbox=floor(bbox)
	lonseq=seq(floorbox[1],floorbox[3],1)
	latseq=seq(floorbox[2],floorbox[4],1)
	gridstoget=expand.grid(lonseq,latseq)
	names(gridstoget)<-c("lon", "lat")
	df2<-gridstoget
	#cleanup
	system("rm SRTMDAT*")
	system("rm *.hgt")

	for (i in 1:(dim(df2)[1])){
		if (sign(df2$lat[i])==-1){LATVAL<-"S"}
		if (sign(df2$lat[i])==1){LATVAL<-"N"}
		if (sign(df2$lon[i])==-1){LONVAL<-"W"}
		if (sign(df2$lon[i])==1){LONVAL<-"E"}
		lon_pretty=formatC(df2$lon[i],width=3,flag="0")
		#get tile
		filetoget=paste0(LATVAL,df2$lat[i],LONVAL,lon_pretty,".SRTMGL1.hgt.zip")
		filetogetUNZIP=paste0(LATVAL,df2$lat[i],LONVAL,lon_pretty,".hgt")

	if (file.exists(filetoget)){ #dont download again
	   print(paste0(filetoget, " exists"))
	   	system(paste0("unzip ", filetoget))
		system(paste0("gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 ", filetogetUNZIP, " SRTMDAT",i,".tif"))
		} else {
		 
			system(paste0("wget --user ", USER ,  " --password " ,PWD, " http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/",filetoget))
			# extract
			system(paste0("unzip ", filetoget))
			system(paste0("gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 ", filetogetUNZIP, " SRTMDAT",i,".tif"))
		}
	}
}
#==================================================================
# MERGE RASTER
#=================================================================
demfiles=list.files(pattern="SRTMDAT*")
if(length(demfiles)>1){
rasters1 <- list.files(pattern="SRTMDAT*",full.names=TRUE, recursive=FALSE)
rast.list <- list()
  for(i in 1:length(rasters1)) { rast.list[i] <- raster(rasters1[i]) }

# And then use do.call on the list of raster objects
rast.list$fun <- mean
rast.mosaic <- do.call(mosaic,rast.list)
dem<-rast.mosaic
}else{
	dem <- raster(demfiles)
}


#==================================================================
# EXTRACT SVF
#================================================================= 
#https://cran.r-project.org/web/packages/horizon/horizon.pdf
#http://onlinelibrary.wiley.com/doi/10.1002/joc.3523/pdf
if (compute_svf == TRUE){
r <- dem
s <- svf(r, nAngles=4, maxDist=500, ll=TRUE)

setwd(paste0(wd,'/predictors'))
writeRaster(round(s,2), "svf.tif", overwrite=TRUE) #write and reduce precision

}
#perhaps need to do this on indiv tiles for memory issues?

#==================================================================
# EXTRACT SLP/ASP
#================================================================= 
slp=terrain(dem, opt="slope", unit="degrees", neighbors=8)
asp=terrain(dem, opt="aspect", unit="degrees", neighbors=8)

#==================================================================
# WRITE OUTPUTS
#================================================================= 
setwd(paste0(wd,'/predictors'))
writeRaster(round(slp,0), "slp.tif", overwrite=TRUE) #write and reduce precision
writeRaster(round(asp,0), "asp.tif", overwrite=TRUE) #write and reduce precision
writeRaster(dem, "ele.tif", overwrite=TRUE)

#==================================================================
# CLEANUP
#================================================================= 
rm(list = ls())

#==================================================================
# OUTPUT
#================================================================= 

# dem.tif in longlat
# asp.tif in degrees
# slp.tif in degrees
# svf.tif

#write these to predictors dir


#=============================================================================================================
# OLDSTUFF
#=============================================================================================================
# elevation: https://pypi.python.org/pypi/elevation #perhaps not anymore?
#erathdata login: https://urs.earthdata.nasa.gov/profile
#gdal_translate

#pypi/elevation
# eio clip -o yala.tif --bounds 12.35 41.8 12.65 42
# eio clip -o test1.tif --bounds 12.35 31.8 12.65 32.1
# eio clip -o langtang.tif --bounds 85.52 28.1 85.68 28.3
# 85.52 28.1 85.68 28.2


#this works

# wget --user USER --password PWD http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/N28E085.SRTMGL1.hgt.zip
# unzip  N28E085.SRTMGL1.hgt.zip
# gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 N28E085.hgt SRTMDAT.tif

#naming convention  http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/
#name of dem file is llcorner 1deg tiles
# to find tile need to round down long/let to nearest degree




#points by google-api
#wget https://maps.googleapis.com/maps/api/elevation/json?locations=43.7391536,8.9847034&key=AIzaSyCTCRL-sszoCWqzNHcKz4FrAwJLvh7A3x8
