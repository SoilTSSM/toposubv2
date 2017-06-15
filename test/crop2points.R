# ==================================================================== SETUP
# ==================================================================== INFO
# account required https://urs.earthdata.nasa.gov/profile

# DEPENDENCY
require(raster)

# SOURCE


# ====================================================================
# PARAMETERS/ARGS
# ====================================================================
args <- commandArgs(trailingOnly = TRUE)
wd <- args[1]

# crop
rst <- raster("/home/joel/sim/topomap_points/predictors/ele.tif")
shp <- shapefile("/home/joel/sim/topomap_points/spatial/points.shp")
ele <- crop(rst, extent(shp) + 0.05, snap = "out")  # includes a buffer to allow for topo computations
writeRaster(ele, "predictors/ele.tif")
print("crop2points complete")

