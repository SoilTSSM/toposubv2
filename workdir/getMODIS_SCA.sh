# #https://github.com/lbusett/MODIStsp
# use to set params: "Rscript getMODIS_SCA.R TRUE $options_file"
# docs MÒDIS SCA https://modis-snow-ice.gsfc.nasa.gov/uploads/C6_MODIS_Snow_User_Guide.pdf

source toposat.ini
gui=$1 #TRUE or FALSE

# compute from dem
longWest=$(Rscript getExtent.R $wd/predictors/ele.tif lonW)
longEast=$(Rscript getExtent.R $wd/predictors/ele.tif lonE)
latNorth=$(Rscript getExtent.R $wd/predictors/ele.tif latN)
latSouth=$(Rscript getExtent.R $wd/predictors/ele.tif latS)
startDate=$startDate # from main pars
endDate=$endDate #from main pars

# Update bbox
bbox=$longWest,$latSouth,$longEast,$latNorth
startElement='"bbox": ['
endElement='],'
newPar=$startElement$bbox$endElement
oldParN=$(grep -n 'bbox' /home/joel/data/MODIS_ARC/SCA/options.json | awk -F: '{print $1}')
lineNo=$oldParN
var=$newPar
sed -i "${lineNo}s/.*/$var/" /home/joel/data/MODIS_ARC/SCA/options.json

#update startdate
findElement='"start_date":'
newPar=$findElement'"'$startDate'",'
oldParN=$(grep -n $findElement /home/joel/data/MODIS_ARC/SCA/options.json | awk -F: '{print $1}')
lineNo=$oldParN
var=$newPar
sed -i "${lineNo}s/.*/$var/" /home/joel/data/MODIS_ARC/SCA/options.json

#update enddate
findElement='"end_date":'
newPar=$findElement'"'$endDate'",'
oldParN=$(grep -n $findElement /home/joel/data/MODIS_ARC/SCA/options.json | awk -F: '{print $1}')
lineNo=$oldParN
var=$newPar
sed -i "${lineNo}s/.*/$var/" /home/joel/data/MODIS_ARC/SCA/options.json

# run MODIStsp tool
Rscript getMODIS_SCA.R $gui $options_file # cannot run non-interactively for some reason