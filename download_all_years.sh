#!/bin/bash

for y in {1979..2015}
do
  python download_year_MaxMinPrecip.py $y
done
