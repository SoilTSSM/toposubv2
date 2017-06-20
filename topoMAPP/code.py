#!/usr/bin/env python
# import ipdb
# ipdb.set_trace

#============= LOGGING =========================================
import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# logger.info('Start reading database')
# # read database here
# records = {'john': 55, 'tom': 66}
# logger.debug('Records: %s', records)
# logger.info('Updating records ...')
# # update records here
# logger.info('Finish updating records')
#================================================================

import sys
import os
sys.path.append('/home/joel/src/TOPOMAP/toposubv2/topoMAPP/')
print sys.path
print sys.argv[0]
# print "sys.argv", sys.argv
# print "sys.path", sys.path
# print os.path.split(sys.argv[0])[0]
# sys.path.append(os.path.split(sys.argv[0])[0])

# TODO:
# read config - this gives srcdir and wd + other params
# declare wd once here
# syspath append get relative path

#config
from configobj import ConfigObj
config = ConfigObj('topomapp.conf')
wd = config['main']['wd']

# SETUP DOMAIN
from domain_setup import getDEM_points as gdem
gdem.main(wd ,config['main']['demDir'] ,config['era-interim']['grid'], config['main']['pointsFile'], config['main']['lonCol'], config['main']['latCol'])

from domain_setup import clipToEra as era
era.main(wd ,config['era-interim']['grid'])

from domain_setup import makeShape as shp
shp.main(wd , config['main']['pointsFile'], config['main']['lonCol'], config['main']['latCol'])
          
from domain_setup import domainPlot as dplot
dplot.main(wd , "TRUE") # shp = TRUE for points  run

from domain_setup import makeKML as kml
kml.main(wd, wd + '/predictors/ele.tif', "shape", wd + '/spatial/extent')
        
kml.main(wd, wd + '/spatial/eraExtent.tif', "raster", wd + '/spatial/eraExtent')

from domain_setup import computeTopo as topo
topo.main(wd, config['toposcale']['svfCompute'])

from domain_setup import makeSurface as surf
surf.main(wd, config['modis']['MODISdir'] )

#====================================================================
#	GET ERA
#====================================================================
from getERA import getExtent as ext
latN = ext.main(wd + '/predictors/ele.tif' , "latN")
latS = ext.main(wd + '/predictors/ele.tif' , "latS")
lonW = ext.main(wd + '/predictors/ele.tif' , "lonW")
lonE = ext.main(wd + '/predictors/ele.tif' , "lonE")

eraDir = wd + '/eraDat'
if not os.path.exists(eraDir):
	os.mkdir(eraDir)


from getERA import eraRetrievePLEVEL as plevel
print "Retrieving ECWMF pressure-level data"
plevel.retrieve_interim( config['main']['startDate'], config['main']['endDate'], latN, latS, lonE, lonW, config['era-interim']['grid'],eraDir)

from getERA import eraRetrieveSURFACE as surf
print "Retrieving ECWMF surface data"
surf.retrieve_interim(config['main']['startDate'], config['main']['endDate'], latN, latS, lonE, lonW, config['era-interim']['grid'],eraDir)

# Merge NDF timeseries (requires linux package cdo)
import subprocess
os.chdir(eraDir)
cmd     = 'cdo -b F64 -f -O nc2 mergetime' + ' interim_daily_PLEVEL* ' + ' PLEVEL.nc'
print("Running:" + str(cmd))
subprocess.check_output(cmd, shell = 'TRUE')

cmd     = 'cdo -b F64 -f -O nc2 mergetime' + wd +  ' /eraDat/interim_daily_SURF* ' + ' SURF.nc'
print("Running:" + str(cmd))
subprocess.check_output(cmd, shell = 'TRUE')

os.chdir(config['main']['srcdir'])

from getERA import era_prep as prep
prep.main(wd, config['main']['startDate'], config['main']['endDate'])

from getERA import prepSims as sim
sim.main(wd)

#====================================================================
#	makeListpoint
#====================================================================

# creates a listpoints for each ERA-grid, only required for point runs

# Returns number of cells in ERA-Grid extent"

from listpoints_make import getRasterDims as dims
ncells = dims.main(wd, wd + '/spatial/eraExtent.tif')

print 'Setting up simulation directories for ' + ncells  + ' ERA-Grids' 

# set up sim directoroes #and write metfiles
for Ngrid in range(1,ncells):
	print 'creating listpoints for grid ' + Ngrid
	gridpath=wd +'/grid'+ Ngrid

if os.path.exists(gridpath):
	from listpoints_make import makeListpoint as list
	list.main(config['main']['gridpath'], config['main']['pointsFile'],config['main']['pkCol'], config['main']['lonCol'], config['main']['latCol'])
else:
	print "Grid "+ Ngrid + " has been removed because it contained no points. Now processing grid" + Ngrid+1

	
done
