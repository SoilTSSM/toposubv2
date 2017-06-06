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

wd=

'/home/joel/data/MODIS_ARC/SCA'



'/home/joel/data/MODIS_ARC/SCA/Snow_Cov_Daily_500m_v5/Time_Series/RData/MYD10_A1_SC_365_2012_78_2013_RData.RData'
'/home/joel/data/MODIS_ARC/SCA/Snow_Cov_Daily_500m_v5/Time_Series/RData/MOD10_A1_SC_365_2012_90_2013_RData.RData'
'/home/joel/data/MODIS_ARC/SCA/Snow_Cov_Daily_500m_v5/Time_Series/RData/MOD10_A1_MYD10_A1_SC_365_2012_90_2013_RData.RData'

/home/joel/data/MODIS_ARC/SCA/Snow_Cov_Daily_500m_v5/Time_Series/RData/MOD10_A1_MYD10_A1_SC_365_2012_90_2013_RData.RData

#Set the input paths to raster and shape file
infile = '/home/joel/data/MODIS_ARC/SCA/Snow_Cov_Daily_500m_v5/Time_Series/RData/MOD10_A1_SC_1_2013_6_2013_RData.RData'
shpname = '/home/joel/data/GCOS/metadata_easy.shp'  
shp = shapefile(shpname)
#Set the start/end dates for extraction
#startdate = as.Date("2013-01-01")  
#enddate = as.Date("2013-01-06")    
#Load the RasterStack
inrts = get(load(infile)) 
# Compute average and St.dev
#dataavg = MODIStsp_extract(inrts, shpname, startdate, enddate, FUN = 'mean', na.rm = T)
#datasd = MODIStsp_extract (inrts, shpname, startdate, enddate, FUN = 'sd', na.rm = T)
# Plot average time series for the polygons
#plot.xts(dataavg) 

MOD = extract(inrts, shp)

infile = '/home/joel/data/MODIS_ARC/SCA/Snow_Cov_Daily_500m_v5/Time_Series/RData/MYD10_A1_SC_1_2013_6_2013_RData.RData'
shpname = '/home/joel/data/GCOS/metadata_easy.shp'  
shp = shapefile(shpname)
#Set the start/end dates for extraction
#startdate = as.Date("2013-01-01")  
#enddate = as.Date("2013-01-06")    
#Load the RasterStack
inrts = get(load(infile)) 
# Compute average and St.dev
#dataavg = MODIStsp_extract(inrts, shpname, startdate, enddate, FUN = 'mean', na.rm = T)
#datasd = MODIStsp_extract (inrts, shpname, startdate, enddate, FUN = 'sd', na.rm = T)
# Plot average time series for the polygons
#plot.xts(dataavg) 
MYD = extract(inrts, shp)

# Combine timeseries
MOD[MOD > 100]  <- NA
MYD[MYD > 100]  <- NA
npoints = dim(MOD)[1]


 my.na <- is.na(MOD)
 MOD[my.na] <- MYD[my.na]
