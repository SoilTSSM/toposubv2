# ==================================================================== SETUP
# ==================================================================== INFO

# DEPENDENCY
require(raster)

# SOURCE

# ====================================================================
# PARAMETERS/ARGS
# ====================================================================
args <- commandArgs(trailingOnly = TRUE)
wd <- args[1]
# ==================================================================== PARAMETERS
# FIXED ====================================================================

# ********************** SCRIPT BEGIN *******************************

setwd(wd)
r <- raster(args[2])
x <- ncell(r)

cat(as.numeric(x))  #; invisible(x)
