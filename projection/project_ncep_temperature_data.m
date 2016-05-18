
% PROJECTING DAILY TEMPERATURE DATA FROM BEST FOR 
% BRA ADM 2, 2000-2009

% SMH WRITTEN 6.30.2015

% TAC EDITED 1.20.2015 to include polynomials aggregated correctly 

%%

clear
close all
clc

%% custom functions path
addpath('/mnt/norgay/Computation/climate_projection_system_2016_2_10')
addpath('/mnt/norgay/Datasets/Climate/ERA_Interim/erai_download_formatting_projection/projection');

%% THIS SECTION CONTAINS ALL VARIABLE FUNCTION NAMES

%set climate data name
CLIM = 'NCEP';
climateDir = 'NCEP_CDAS';
%obtain shapefile
sample = 'USA';
% for s = {'BRA' 'CHN' 'FRA' 'IND' 'MEX' 'USA'}
%     sample = char(s);    
    shapeDir = ['/mnt/norgay/Datasets/SHAPEFILES/' sample '/' sample '_adm'];
    shapeFile = [shapeDir '/' sample '_adm2.shp'];

    [s,a] = shaperead(shapeFile,'UseGeoCoords', true);
    [s,a] = drop_by_attribute(s, a, 'NAME_1', 'Alaska');
    a = combine_attributes(a, 'NAME_1', 'NAME_2');
    label = 'NAME_1_NAME_2';
    
    outputDir = {'/mnt/norgay/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2/Binned_temperature'};

    project_erai_weather_data_folder(s, a, label, outputDir)
% end
disp('----DONE----')
toc








