#!/usr/bin/env python
__author__ = 'theodorkulczycki'

import getParameterYear
for p in ['57','58','169','182','189','210','212']:
    for y in [str(x) for x in range(1979,2015)]:
        getParameterYear.get(p, y)
