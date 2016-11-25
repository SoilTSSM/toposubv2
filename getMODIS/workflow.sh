#jf 2016-11-24

#=============================================================================================================
#External Dependencies
#=============================================================================================================
#MRT: https://lpdaac.usgs.gov/tools/modis_reprojection_tool
#pymodis: http://www.pymodis.org/
#erathdata login: https://urs.earthdata.nasa.gov/profile - doublecheck this.

#=============================================================================================================
#downloads files: http://www.pymodis.org/scripts/modis_download.html
#=============================================================================================================
modis_download.py -u ftp://n5eil01u.ecs.nsidc.org -t h23v05 -s SAN/MOST -p MOD10A2.005 -A ~/data/modis/h23v05

#=============================================================================================================
#converts - cant this to work
#=============================================================================================================
#modis_convert.py -s "( 1 0)" -e 32642 MOD10A2.A2008185.h23v05.005.2008196014145.hdf

#=============================================================================================================
#edit and run 
#=============================================================================================================
Rscript convertMODIS.R
#
