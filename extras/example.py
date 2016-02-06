#!/usr/bin/env python
#
# (C) Copyright 2012-2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.
#

from ecmwfapi import ECMWFDataServer

# To run this example, you need an API key 
# available from https://api.ecmwf.int/v1/key/
 
server = ECMWFDataServer()
  
server.retrieve({
    'stream'    : "oper",
    'levtype'   : "sfc",
    'param'     : "165.128/166.128/167.128",
    'dataset'   : "interim",
    'step'      : "0",
    'grid'      : "0.75/0.75",
    'time'      : "00/06/12/18",
    'date'      : "2014-07-01/to/2014-07-31",
    'type'      : "an",
    'class'     : "ei",
    'format'    : "netcdf",
    'target'    : "interim_2014-07-01to2014-07-31_00061218.nc"
})
