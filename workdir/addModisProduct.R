#https://n5eil01u.ecs.nsidc.org/MOST/MOD10A1.006/ - TERRA
#https://n5eil01u.ecs.nsidc.org/MOSA/MYD10A1.006/ - AQUA
#require earthdata login


MODIS:::addProduct(product = "MOD10A1", sensor = "MODIS", platform = "Terra",pf1 = "MOST", pf2 = "MOD10A1.006", res = "500m", temp_res ="1 Day", topic = "Daily snow covered area", server = "https://n5eil01u.ecs.nsidc.org",path_ext="/home/joel/R/x86_64-pc-linux-gnu-library/3.4/MODIS/external", overwrite=FALSE)
