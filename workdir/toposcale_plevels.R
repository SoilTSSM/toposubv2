#====================================================================
# SETUP
#====================================================================
#INFO

#DEPENDENCY
require(raster)

#SOURCE
source('tscale_src.R')
#====================================================================
# PARAMETERS/ARGS
#====================================================================
args = commandArgs(trailingOnly=TRUE)
wd=args[1] #'/home/joel/sim/topomap_test/grid1' #
nbox=as.numeric(args[2])
dat='../eraDat/all/rhumPl'

#====================================================================
# PARAMETERS FIXED
#====================================================================

#**********************  SCRIPT BEGIN *******************************
setwd(wd)
coordmapfile='../eraDat/strd.nc'

#===========================================================================
#				POINTS
#===========================================================================
mf=read.table('listpoints.txt',header=TRUE,sep='\t')
npoints=length(mf$id)

#=======================================================================================================
#			READ FILES
#=======================================================================================================
load('../eraDat/all/gPl')
load(dat)
#========================================================================
#		COMPUTE SCALED FLUXES - T,Rh,Ws,Wd,LW
#========================================================================
#get grid coordinates
coordMap=getCoordMap(coordmapfile)
x<-coordMap$xlab[nbox] # long cell
y<-coordMap$ylab[nbox]# lat cell

#extract PL data by nbox coordinates dims[data,xcoord,ycoord, pressurelevel]
gpl=gPl_cut[,x,y,]
upl=uPl_cut[,x,y,] #VAR

#get station attributes
stations=mf$id
lsp=mf[stations,]

#init dataframes
uPoint=c()
nameVec=c()
	for (i in 1:length(lsp$id)){
		stationEle=lsp$ele[i]
		nameVec=c(nameVec,(lsp$id[i])) #keeps track of order of stations
		#WIND U
		wu<-plevel2point(gdat=gpl,dat=upl, stationEle=stationEle) #VAR
		uPoint=cbind(uPoint, wu) #VAR
	}

write.table(uPoint,paste(spath,  '/uPoint.txt',sep=''), row.names=F, sep=',') #ARV


