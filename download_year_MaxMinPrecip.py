#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import os, sys
from ecmwfapi import ECMWFDataServer

# To run this example, you need an API key
# available from https://api.ecmwf.int/v1/key/

year = sys.argv[1]

name = 'raw'
#grid = '1.0/1.0'
grid = '0.25/0.25'

#outputDir = os.path.expandvars('/mnt/norgay/Datasets/Climate/ERA_Interim/Raw_NetCDF_1deg_x_1deg/')
outputDir = os.path.expandvars('/mnt/norgay/Datasets/Climate/ERA_Interim/Raw_NetCDF_.25deg_x_.25deg/')

try:
    os.makedirs(outputDir)
except OSError:
    if not os.path.isdir(outputDir):
        raise

server = ECMWFDataServer()

if year!='1979':
    startDate = str(int(year)-1) + '-12-31'
else:
    startDate = year + '-01-01'

endDate = year + '-12-31'

targetFile = "mx2t_mn2t_tp_3hour_{}to{}.nc".format(startDate, endDate)

server.retrieve({
    'stream'    : "oper",
    'levtype'   : "sfc",
    'param'     : "201.128/202.128/228.128",
    'dataset'   : "interim",
    'step'      : "03/06/09/12",
    'grid'      : "{}".format(grid),
    'time'      : "00/12",
    'date'      : "{}/to/{}".format(startDate, endDate),
    'type'      : "fc",
    'class'     : "ei",
    'format'    : "netcdf",
    'target'    : outputDir+targetFile
})

#fileHandle = open(outputDir+'currentFile.txt','w')
#fileHandle.write(targetFile)
#fileHandle.close()

#fileHandle = open(outputDir+'currentYear.txt','w')
#fileHandle.write(year)
#fileHandle.close()
