source toposat.ini

# compute from dem
latNorth=$(Rscript getExtent.R $wd/predictors/ele.tif latN)
latSouth=$(Rscript getExtent.R $wd/predictors/ele.tif latS)
lonEast=$(Rscript getExtent.R $wd/predictors/ele.tif lonE)
lonWest=$(Rscript getExtent.R $wd/predictors/ele.tif lonW)
eraDir=$(wd, '/eraDat')

python eraRetrievePLEVEL.py $startDate $endDate $latNorth $latSouth $lonEast $lonWest $grid $eraDir
python eraRetrieveSURFACE.py $startDate $endDate $latNorth $latSouth $lonEast $lonWest $grid $eraDir

# cut and reshape data to expected format


# Preprocess ERA-data
Rscript toposcale_pre.R $wd $startDate $endDate

# Prepare sim predicters and directories per ERA-grid
Rscript prepareSims.R $wd