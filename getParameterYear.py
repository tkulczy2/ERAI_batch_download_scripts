#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import os, csv
from ecmwfapi import ECMWFDataServer

def get(parameter, year):

    if parameter.isdigit():
        try:
            paramDict = {row[3]:row[1] for row in csv.reader(open('parameter_info.csv','rU'))}
            paramName = paramDict[parameter]
            paramID = parameter
        except IOError:
            print "Parameter ID not valid"
    else:
        try:
            paramDict = {row[1]:row[3] for row in csv.reader(open('parameter_info.csv','rU'))}
            paramID = paramDict[parameter]
            paramName = parameter
        except IOError:
            print "Parameter name not valid"

    param = paramID + ".128"

    outputDir = os.path.expandvars('$HOME/norgay/data/sources/ERAI/3HOURLY/'+paramName+'/')
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

    if year=='2015':
        endDate = year + '-06-30'
    else:
        endDate = year + '-12-31'

    targetFile = "ERAI_{}_{}to{}.nc".format(paramName, startDate, endDate)

    server.retrieve({
        'stream'    : "oper",
        'levtype'   : "sfc",
        'param'     : param,
        'dataset'   : "interim",
        'step'      : "03/06/09/12",
        'grid'      : "0.25/0.25",
        'time'      : "00/12",
        'date'      : "{}/to/{}".format(startDate, endDate),
        'type'      : "fc",
        'class'     : "ei",
        'format'    : "netcdf",
        'target'    : outputDir+targetFile
    })
