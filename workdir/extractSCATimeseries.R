#====================================================================
# SETUP
#====================================================================
#INFO
#use MAGST or MASD or SWE

#DEPENDENCY
require(raster)
#require(MODIStsp) 

#SOURCE

#====================================================================
# PARAMETERS/ARGS
#====================================================================
args = commandArgs(trailingOnly=TRUE)
wd=args[1]
sca_wd=args[2] 
shpname=args[3] 

wd='/home/joel/sim/topomap_points/'
sca_wd='/home/joel/data/MODIS_ARC/SCA/data/Snow_Cov_Daily_500m_v5/SC'
shpname = '/home/joel/sim/topomap_points/spatial/points.shp' 


#Set the input paths to raster and shape file
setwd(sca_wd)
shp = shapefile(shpname)
rstack=stack(list.files(pattern='MOD*'))
MOD = extract(rstack, shp)
rstack=stack(list.files(pattern='MYD*'))
MYD = extract(rstack, shp)

# Combine timeseries
MOD[MOD > 100]  <- NA
MYD[MYD > 100]  <- NA
npoints = dim(MOD)[1]


my.na <- is.na(MOD)
MOD[my.na] <- MYD[my.na]

#construct dates
date = c()
names(rstack)
for(i in 1: length( names(rstack)))
{
	year <- unlist(strsplit(names(rstack)[i], '_'))[4]
	doy <- unlist(strsplit(names(rstack)[i], '_'))[5]
	dd = strptime(paste(year, doy), format="%Y %j")
	date = c(date, as.character(dd))
	
}

#construct dataframes
Npoints=dim(MOD)[1]

for (i in 1:Npoints)
	{
	fsca = as.vector(MOD[i,])
	df = data.frame(date, fsca)
	write.csv(df, paste0(wd,'/spatial/fca_P',i,'.csv'))
	}



#====================================================================
# MODIS SA CODES
#====================================================================
# 0-100=NDSI snow 200=missing data
# 201=no decision
# 211=night
# 237=inland water 239=ocean
# 250=cloud
# 254=detector saturated 255=fill
#====================================================================
# MODIS SA CODES
#====================================================================