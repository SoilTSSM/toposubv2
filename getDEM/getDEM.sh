#=============================================================================================================
#External Dependencies
#=============================================================================================================
# elevation: https://pypi.python.org/pypi/elevation
#erathdata login: https://urs.earthdata.nasa.gov/profile

eio clip -o yala.tif --bounds 12.35 41.8 12.65 42
eio clip -o test1.tif --bounds 12.35 31.8 12.65 32.1

eio clip -o langtang.tif --bounds 85.52 28.1 85.68 28.3
85.52 28.1 85.68 28.2


#this works
wget --user jfiddes --password St0kkang1 http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/N28E085.SRTMGL1.hgt.zip
unzip  N28E085.SRTMGL1.hgt.zip
gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 N28E085.hgt SRTMDAT.tif

#name of dem file is llcorner 1deg tiles
# to find tile need to round down long/let to nearest degree


#parse credentials file to get user/pwd
read.Files('~/.credentials_earthdata')
USER=unlist(strsplit(readLines('~/.credentials_earthdata')[[1]],'='))[2]
PWD=unlist(strsplit(readLines('~/.credentials_earthdata')[[2]],'='))[2]
#==================================================================
# DEM retrieval based on set of points:
#=================================================================

#points input
lon=c(85.52 ,85.68,84.2)
lat=c(28.1 ,28.3, 27.8)
df=data.frame(lon,lat)

#find unique llcorner
df2=unique(floor(df))

# construct query
#filename str = N28E08


for (i in 1:(dim(df2)[1])){

if (sign(df2$lat[i])==-1){LATVAL<-'S'}
if (sign(df2$lat[i])==1){LATVAL<-'N'}
if (sign(df2$lon[i])==-1){LONVAL<-'W'}
if (sign(df2$lon[i])==1){LONVAL<-'E'}

lon_pretty=formatC(df2$lon[i],width=3,flag='0')
system(paste0('wget --user ', USER ,  ' --password ' ,PWD, ' http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/',LATVAL,df2$lat[i],LONVAL,lon_pretty,'.SRTMGL1.hgt.zip'))
}

#==================================================================
# DEM retrieval based on bbox
#=================================================================
#bbox=(e,s,w,n)
bbox=c(85.52, 27.8, 89.68, 29.3)
floorbox=floor(bbox)
lonseq=seq(floorbox[1],floorbox[3],1)
latseq=seq(floorbox[2],floorbox[4],1)
gridstoget=expand.grid(lonseq,latseq)

#download
#asp/slp - R raster
# svf saga api
#https://cran.r-project.org/web/packages/horizon/horizon.pdf
#http://onlinelibrary.wiley.com/doi/10.1002/joc.3523/pdf

require(horizon)
  r <- getData('alt', country='CH')
     s <- svf(r, nAngles=8, maxDist=500, ll=TRUE)




#identify tiles required for given point or poinst or area

#points by google-api
wget https://maps.googleapis.com/maps/api/elevation/json?locations=43.7391536,8.9847034&key=AIzaSyCTCRL-sszoCWqzNHcKz4FrAwJLvh7A3x8
