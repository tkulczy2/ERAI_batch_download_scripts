#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import os, sys
from ecmwfapi import ECMWFDataServer

# To run this example, you need an API key
# available from https://api.ecmwf.int/v1/key/

year = sys.argv[1]
name = str(year)
# name = '2014'

fields = ['param','step','time','type']
parameters = ['2t','mx2t','mn2t','tp']

params = {'2t':"167.128",
          'mx2t':"201.128",
          'mn2t':"202.128",
          'tp':"228.128"}

steps = {'2t':"0",
         'mx2t':"03/06/09/12",
         'mn2t':"03/06/09/12",
         'tp':"03/06/09/12"}

times = {'2t':"00/06/12/18",
         'mx2t':"00/12",
         'mn2t':"00/12",
         'tp':"00/12"}

types = {'2t':"an",
         'mx2t':"fc",
         'mn2t':"fc",
         'tp':"fc"}

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


for p in parameters:
    server.retrieve({
        'stream'    : "oper",
        'levtype'   : "sfc",
        'param'     : params[p],
        'dataset'   : "interim",
        'step'      : steps[p],
        'grid'      : "0.25/0.25",
        'time'      : times[p],
        'date'      : "{}/to/{}".format(startDate, endDate),
        'type'      : types[p],
        'class'     : "ei",
        'format'    : "netcdf",
        'target'    : "{}erai_{}_{}to{}.nc".format(outputDir, p, startDate, endDate)
    })
