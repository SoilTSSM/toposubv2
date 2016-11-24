#MODIS tool: reprojects and subsets and changes format to tiff (MRT tool)
library (RCurl)

library(rgdal)
tiles=('h23v05')#c('h18v04') #tile id - http://harvardforest.fas.harvard.edu/blog/modis-satellite-imagery-applied-phenological-assessment-team-bu
Sys.setenv(MRT_DATA_DIR  = "/home/joel/src/MRT/data/")

#=============== Tile index =====================
# tiles=('h24v05') = nORTHERN INDIA (ihacap)


name='MOD10A2'#modis product short name
#MODIS/Terra Snow Cover Daily L3 Global 500m SIN Grid MOD10A1.005
#MODIS/Terra Snow Cover 8-Day L3 Global 500m SIN Grid MOD10A2.005

#ftpRoot <- "ftp://n5eil01u.ecs.nsidc.org/SAN/MOST/MOD10A1.005/" #daily 500m sca
#ftpRoot <- "ftp://n5eil01u.ecs.nsidc.org/SAN/MOST/MOD10A2.005/" #8 day composite 500m

MRT <- '/home/joel/MRT/bin'  # MODIS Reprojection Tool exe files
workd <- '/home/joel/data/modis/h23v05'  # working directory

#===================reproject subset and change to tiff (MRT)
#write param 
  filename = file(paste(workd, "/mrt", name, ".prm", sep=""), open="wt")

  write(paste('INPUT_FILENAME = ', workd, 'TmpMosaic.hdf', sep=""), filename) 
  write('  ', filename, append=TRUE)
  write('SPECTRAL_SUBSET = ( 1 0 )', filename, append=TRUE)
  write('  ', filename, append=TRUE)
 # write('SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG', filename, append=TRUE)
  write('  ', filename, append=TRUE)
#alps
 # write('SPATIAL_SUBSET_UL_CORNER = ( 48.7 5.2 )', filename, append=TRUE)
 # write('SPATIAL_SUBSET_LR_CORNER = ( 45.10 11.2 )', filename, append=TRUE)
#afg
#  write('SPATIAL_SUBSET_UL_CORNER = ( 39 60 )', filename, append=TRUE)
#  write('SPATIAL_SUBSET_LR_CORNER = ( 29 76 )', filename, append=TRUE)
  write('  ', filename, append=TRUE)
  write(paste('OUTPUT_FILENAME = ', workd, 'tmp', name, '.tif', sep=""), filename, append=TRUE)
  write('  ', filename, append=TRUE)
  write('RESAMPLING_TYPE = NEAREST_NEIGHBOR', filename, append=TRUE)
  write('  ', filename, append=TRUE)
  write('OUTPUT_PROJECTION_TYPE = UTM', filename, append=TRUE)
 # write('OUTPUT_PROJECTION_TYPE = GEO', filename, append=TRUE)
  write('  ', filename, append=TRUE)
  write('OUTPUT_PROJECTION_PARAMETERS = ( ', filename, append=TRUE)
  write(' 0.0 0.0 0.0', filename, append=TRUE)
  write(' 0.0 0.0 0.0', filename, append=TRUE)
  write(' 0.0 0.0 0.0', filename, append=TRUE)
  write(' 0.0 0.0 0.0', filename, append=TRUE)
  write(' 0.0 0.0 0.0 )', filename, append=TRUE)
  write('  ', filename, append=TRUE)
  write('DATUM = WGS84', filename, append=TRUE)
  write('  ', filename, append=TRUE)
  write('OUTPUT_PIXEL_SIZE = 500', filename, append=TRUE)
  write('  ', filename, append=TRUE)
write('UTM_ZONE = 42', filename, append=TRUE) #alps =32
  close(filename)
setwd(workd)


modisDat<-list.files(recursive=T, pattern='hdf$')

mrtParamFile=paste(workd, "/mrt", name, ".prm", sep="")

for (i in 300:length(modisDat)){
outName=paste(strsplit(modisDat[i], '.hdf')[1], '.tif',sep='')

system(paste('/home/joel/src/MRT/bin/resample -p ', mrtParamFile,' -i ', modisDat[i],' -o ', outName, sep=""))
}

#for (i in 17:34){
#outName=paste(strsplit(modisDat[i], '.hdf')[1], '.tif',sep='')

#system(paste('resample -p ', mrtParamFile,' -i ', modisDat[i],' -o ', outName, sep=""))
#}


