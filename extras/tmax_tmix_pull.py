#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import os
from ecmwfapi import ECMWFDataServer

# To run this example, you need an API key
# available from https://api.ecmwf.int/v1/key/

name = 't2m_5yr'

outputDir = os.path.expandvars('$HOME/ERA_Interim/'+name+'/')

try:
    os.makedirs(outputDir)
except OSError:
    if not os.path.isdir(outputDir):
        raise

server = ECMWFDataServer()

startYear = 1979
endYear = 1984
startDate = str(startYear) + '-01-01'
if endYear==2015:
    endDate = str(endYear) + '-06-30'
else:
    endDate = str(endYear) + '-12-31'
server.retrieve({
    'stream'    : "oper",
    'levtype'   : "sfc",
    'param'     : "167.128",
    'dataset'   : "interim",
    'step'      : "0",
    'grid'      : "0.25/0.25",
    'time'      : "00",
    'date'      : "{}/to/{}".format(startDate, endDate),
    'type'      : "an",
    'class'     : "ei",
    'format'    : "netcdf",
    'target'    : "{}era-i_{}to{}_00061218.nc".format(outputDir, startDate, endDate)
})
