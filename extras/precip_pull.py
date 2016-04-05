#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import os
from ecmwfapi import ECMWFDataServer

# To run this example, you need an API key
# available from https://api.ecmwf.int/v1/key/

name = 'precip_all_steps'

outputDir = os.path.expandvars('$HOME/ERA_Interim/'+name+'/')

try:
    os.makedirs(outputDir)
except OSError:
    if not os.path.isdir(outputDir):
        raise

server = ECMWFDataServer()

startYear = 2014
endYear = 2014
startDate = str(startYear) + '-01-01'
if endYear==2015:
    endDate = str(endYear) + '-06-30'
else:
    endDate = str(endYear) + '-12-31'
server.retrieve({
    'stream'    : "oper",
    'levtype'   : "sfc",
    'param'     : "228.128",
    'dataset'   : "interim",
    'step'      : "03/06/09/12",
    'grid'      : "0.25/0.25",
    'time'      : "00/12",
    'date'      : "{}/to/{}".format(startDate, endDate),
    'type'      : "fc",
    'class'     : "ei",
    'format'    : "netcdf",
    'target'    : "{}erai_{}_{}to{}.nc".format(outputDir, name, startDate, endDate)
})
