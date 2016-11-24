#=============================================================================================================
#External Dependencies
#=============================================================================================================
# elevation: https://pypi.python.org/pypi/elevation
#erathdata login: https://urs.earthdata.nasa.gov/profile

eio clip -o yala.tif --bounds 12.35 41.8 12.65 42
eio clip -o test1.tif --bounds 12.35 31.8 12.65 32.1

eio clip -o langtang.tif --bounds 85.52 28.1 85.68 28.3
85.52 28.1 85.68 28.2
RTM3

#this works
wget --user EARTHDATALOGIN --password EARTHDATALOGIN http://e4ftl01.cr.usgs.gov//MODV6_Dal_D/SRTM/SRTMGL1.003/2000.02.11/N28E085.SRTMGL1.hgt.zip
unzip  N28E085.SRTMGL1.hgt.zip 
gdal_translate -q -co TILED=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 -co PREDICTOR=2 N28E085.hgt SRTMDAT.tif
