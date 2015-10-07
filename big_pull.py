#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import os, sys
from ecmwfapi import ECMWFDataServer



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

for y in range(1970, 2016):

    outputDir = os.path.expandvars('$HOME/ERA_Interim/'+str(y)+'/')

    try:
        os.makedirs(outputDir)
    except OSError:
        if not os.path.isdir(outputDir):
            raise



    startDate = str(y) + '-01-01'
    if y==2015:
        endDate = str(y) + '-06-30'
    else:
        endDate = str(y) + '-12-31'

    server = ECMWFDataServer()

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
            'target'    : "{}{}_{}to{}.nc".format(outputDir, p, startDate, endDate)
        })
