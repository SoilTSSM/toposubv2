#make slope-based land cover classsification (debris/bedrock)
#hardcoded DEM name and location
#can optionally project raster but 'terrain' fuction accepts ll data for slope calc.

require(raster)
require(rgdal)
#====================================================================
#			read DEM
#====================================================================
dem=raster('/home/joel/data/DEM/himachelpradesh/dem/merge2.tif')

#====================================================================
#			project DEM ll -> UTM
#====================================================================

system("gdalwarp -s_srs '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs' -t_srs '+proj=utm +zone=43 +ellps=WGS84 +datum=WGS84 +units=m +no_defs' -srcnodata -9999 -dstnodata -9999 ~/data/DEM/himachelpradesh/dem/merge2.tif ~/data/DEM/himachelpradesh/dem/merge2_utm.tif")

#====================================================================
#			compute slope
#====================================================================
utm=raster('/home/joel/data/DEM/himachelpradesh/dem/merge2_utm.tif')
terrain(utm, opt='slope', unit='degrees', neighbors=8, filename='~/data/DEM/himachelpradesh/dem/slp')  
terrain(dem, opt='slope', unit='degrees', neighbors=8, filename='~/data/DEM/himachelpradesh/dem/slp2') 


writeRaster(slp, '/home/joel/data/DEM/himachelpradesh/dem/slp.tif')
rm(slp)
#====================================================================
#	compute bedrock debris slope model (Boeckli 2012)
#====================================================================

smin=35
smax=55

#mr=(raster('/home/joel/data/DEM/himachelpradesh/dem/slp.tif')-smin)/(smax-smin)
r=raster('/home/joel/data/DEM/himachelpradesh/dem/slp2')
 calc(r, fun=function(x){(x - 35) / 20}, filename='/home/joel/data/DEM/himachelpradesh/dem/mr2')

#====================================================================
#		classify surface model
#====================================================================
mr=raster('/home/joel/data/DEM/himachelpradesh/dem/mr2')

#fuzzy classes
#from=c(-9999, 1)
#to=c(0, 9999)

#crisp classes ie split by 45 degree slope
from=c(-9999, 0.5)
to=c(0.5, 9999)

becomes=c(0,1)
rcl= data.frame(from, to, becomes)
reclassify(mr, rcl, filename='/home/joel/data/DEM/himachelpradesh/dem/mr_reclass2', overwrite=TRUE)

#==================================
require(raster)
require(rgdal)
#==============================================
#		convert raster to tiff (write in chuncks to allow large filesize)
#====================================================================

r=raster('/home/joel/data/DEM/himachelpradesh/dem/mr_reclass2')
s=raster(r)

tr <- blockSize(r)

s <- writeStart(s, filename= '/home/joel/data/DEM/himachelpradesh/dem/mr_reclass2.tif',format= 'GTiff' 
, overwrite=TRUE)
for (i in 1:tr$n) {
v <- getValuesBlock(r, row=tr$row[i], nrows=tr$nrows[i])
s <- writeValues(s, v, tr$row[i])
}
s <- writeStop(s)


#====================================================================
#		combine slope and veg to make surface layer
#====================================================================
#read in set projection if necessary
r2=raster('/home/joel/data/DEM/himachelpradesh/dem/mr_reclass2.tif') #ll
veg=raster('/home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class.tif') #0=veg, 1=no veg
projection(veg)<-'+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0' 



#resample veg to r2 resolution
resample(veg, r2, filename='/home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2.tif',method='ngb')


#reclassify
veg_resamp=raster('/home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2.tif') #0=veg, 1=no veg
#veg_resamp[veg_resamp==0]<-2
#veg_resamp[veg_resamp==1]<-NA
subsdf=data.frame(0,2)
subs(x=veg_resamp,  y=subsdf, by=1, which=2, subsWithNA=TRUE, filename='/home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2_subs.tif')

#replace veg NA with reclass 
veg_reclass=raster('/home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2_subs.tif') #0=veg, 1=no veg
cover(veg_reclass, r2, filename='/home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2_cover2.tif')

#write values 0= debris , 1= bedrock, 3=veg. ie debris covers boulder fields, scree slopes and non-vegetated sany soils, would be good to partition somehow.


#====================================================================
#			project DEM ll -> UTM
#====================================================================

saga
system("gdalwarp -s_srs '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs' -t_srs '+proj=utm +zone=43 +ellps=WGS84 +datum=WGS84 +units=m +no_defs' -srcnodata -9999 -dstnodata -9999 /home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2_subs.tif /home/joel/data/modis/ihcap/030296764911178/meanNDVI2009_13_2class_resamp2_subs_utm.tif")


