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
'param','step','time','type'
codes  = {'2t':"167.128",
          'mx2t24':"51.128",
          'mv2t24':"52.128",
          'mx2t6':"121.128",
          'mn2t6':"122.128",
          'tp':"228.128"}
steps = {}
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
    'param'     : "167.128",
    'dataset'   : "interim",
    'step'      : "0",
    'grid'      : "0.25/0.25",
    'time'      : "00",
    'date'      : "{}/to/{}".format(startDate, endDate),
    'type'      : "an",
    'class'     : "ei",
    'format'    : "netcdf",
    'target'    : "{}erai_{}_{}to{}.nc".format(outputDir, startDate, endDate)
})
