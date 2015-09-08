#!/usr/bin/env python
__author__ = 'theodorkulczycki'

from ecmwfapi import ECMWFDataServer

# To run this example, you need an API key
# available from https://api.ecmwf.int/v1/key/

server = ECMWFDataServer()

for year in range(1979,2016):
    startDate = str(year) + '-01-01'
    if year==2015:
        endDate = str(year) + '-06-30'
    else:
        endDate = str(year) + '-12-31'
    server.retrieve({
        'stream'    : "oper",
        'levtype'   : "sfc",
        'param'     : "165.128",
        'dataset'   : "interim",
        'step'      : "0",
        'grid'      : "0.75/0.75",
        'time'      : "00/06/12/18",
        'date'      : "%s/to/%s"%(startDate,endDate),
        'type'      : "an",
        'class'     : "ei",
        'format'    : "netcdf",
        'target'    : "era-i_%sto%s_00061218.nc"%(startDate,endDate)
    })
