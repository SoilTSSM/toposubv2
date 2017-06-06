
#!/usr/bin/env python
import calendar
import sys
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
 
def retrieve_interim():
    """      
       A function to demonstrate how to iterate efficiently over several years and months etc    
       for a particular interim_request.     
       Change the variables below to adapt the iteration to your needs.
       You can use the variable "target" to organise the requested data in files as you wish.
       In the example below the data are organised in files per month. (eg "interim_daily_201510.grb")
    """
    strtDate = str(sys.argv[1])
    endDate = str(sys.argv[2]) 
    latNorth = str(sys.argv[3])
    latSouth =  str(sys.argv[4])
    lonEast = str(sys.argv[5])
    lonWest = str(sys.argv[6])
    grd =   str(sys.argv[7])
    eraDir =  sys.argv[8]

    string = strtDate
    strsplit = string.split('-' )
    yearStart = int(strsplit[0])
    monthStart = int(strsplit[1])

    string = endDate
    strsplit = string.split('-' )
    yearEnd = int(strsplit[0])
    monthEnd = int(strsplit[1])

    grid=str(grd) + "/" + str(grd)
    bbox=(str(latNorth) + "/" + str(lonWest) + "/" + str(latSouth) + "/" + str(lonEast)) 

    print("Retrieving ERA-Interim data")
    print("Bbox = " + bbox)
    print("Grid = " + grd)
    print("Start date = " + str(yearStart) + "-" + str(monthStart))
    print("End date = " + str(yearEnd) + "-" + str(monthEnd))

    for year in list(range(yearStart, yearEnd + 1)):
        for month in list(range(monthStart, monthEnd + 1)):
            startDate = "%04d%02d%02d" % (year, month, 1)
            numberOfDays = calendar.monthrange(year, month)[1]
            lastDate = "%04d%02d%02d" % (year, month, numberOfDays)
            target = eraDir + "/interim_daily_%04d%02d_PLEVEL.nc" % (year, month)
            requestDates = (startDate + "/TO/" + lastDate)
            interim_request(requestDates, target, grid, bbox)


def interim_request(requestDates, target, grid, bbox):
    """      
        An ERA interim request for analysis pressure level data.
        Change the keywords below to adapt it to your needs.
        (eg to add or to remove  levels, parameters, times etc)
        Request cost per day is 112 fields, 14.2326 Mbytes
    """
    server.retrieve({
        "dataset": "interim",
        "date": requestDates,
        "stream" : "oper",
        "levtype": "pl",
        "param": "129/130/157/131/132",
        "dataset": "interim",
        "step": "0",
        "grid": grid,
        "time": "00/06/12/18",
        "class": "ei",
        "format": "netcdf",
        "target": target,
        "type": "an",
        "area": bbox,
        "levelist": "500/650/775/850/925/1000",
        'RESOL' : "AV",
    })
if __name__ == "__main__":
    retrieve_interim()


  
