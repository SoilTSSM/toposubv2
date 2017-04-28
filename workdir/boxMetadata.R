#====================================================================
# SETUP
#====================================================================
#INFO

#DEPENDENCY
require(raster)
require(ncdf4)

#SOURCE
source('tscale_src.R')
#====================================================================
# PARAMETERS/ARGS
#====================================================================
args = commandArgs(trailingOnly=TRUE)
wd=args[1] #
nbox=as.numeric(args[2])
#gridEle=args[3]
#====================================================================
# PARAMETERS FIXED
#====================================================================

#**********************  SCRIPT BEGIN *******************************


########################################################################################################
#
#			TOPOSCALE SWin
#
########################################################################################################
#===========================================================================
#				SETUP
#===========================================================================
# wd<-getwd()
# root=paste(wd,'/',sep='')
# parfile=paste(root,'/src/TopoAPP/parfile.r', sep='')
# source(parfile) #give nbox and epath packages and functions
# nbox<-nboxSeq
# simindex=formatC(nbox, width=5,flag='0')
# spath=paste(epath,'/result/B',simindex,sep='') #simulation path

# setup=paste(root,'/src/TopoAPP/expSetup1.r', sep='')
# source(setup) #give tFile outRootmet

#===========================================================================
#				COMPUTE POINTS META DATA - eleDiff, gridEle, Lat, Lon
#===========================================================================
setwd(wd)
file='../eraDat/strd.nc'
infileT='../eraDat/tpl.nc'

nc=nc_open(infileT)
mf=read.table('listpoints.txt',header=TRUE,sep='\t')
npoints=length(mf$id)
eraBoxEle=read.table('../eraEle.txt',sep=',', header=FALSE)[,1]
print(eraBoxEle)
print(nbox)

#find ele diff station/gidbox
#eraBoxEle<-getEraEle(dem=eraBoxEleDem, eraFile=tFile) # $masl
gridEle<-rep(eraBoxEle[nbox],length(mf$id))

print(length(mf$id))
print(eraBoxEle[nbox])
print(gridEle)
mf$gridEle<-round(gridEle,2)
eleDiff=mf$ele-mf$gridEle
mf$eleDiff<-round(eleDiff,2)
print(eleDiff)
#get grid coordinates
coordMap=getCoordMap(file)
x<-coordMap$xlab[nbox] # long cell
y<-coordMap$ylab[nbox]# lat cell

#get long lat centre point of nbox (for solar calcs)
lat=ncvar_get(nc, 'latitude')
lon=ncvar_get(nc, 'longitude')
latn=lat[y]
lonn=lon[x]
mf$lat=rep(latn,length(mf$id))
mf$lon=rep(lonn,length(mf$id))

write.table(mf, 'listpoints.txt', row.names=FALSE, sep='\t')

