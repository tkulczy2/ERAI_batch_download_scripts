
% PROJECTING DAILY TEMPERATURE DATA FROM BEST FOR 
% BRA ADM 2, 2000-2009

% SMH WRITTEN 6.30.2015

% TAC EDITED 1.20.2015 to include polynomials aggregated correctly 

%%

clear
close all
clc

%% custom functions path
currentpath = path;
newpath = '/mnt/norgay/Computation/sol_matlab_toolbox'
path(currentpath, newpath)
addpath('/mnt/norgay/Datasets/Climate/ERA_Interim/erai_download_formatting_projection/projection');

%% THIS SECTION CONTAINS ALL VARIABLE FUNCTION NAMES

%set climate data name
CLIM = 'ERAI';
climateDir = 'ERA_Interim';
%obtain shapefile
sample = 'USA';
% for s = {'BRA' 'CHN' 'FRA' 'IND' 'MEX' 'USA'}
%     sample = char(s);    
    shapeDir = ['/mnt/norgay/Datasets/SHAPEFILES/' sample '/' sample '_adm'];
    shapeFile = [shapeDir '/' sample '_adm2.shp'];

    [s,a] = shaperead(shapeFile,'UseGeoCoords', true); 
    a = combine_attributes(a, 'NAME_1', 'NAME_2');
    label = 'NAME_1_NAME_2';
    
    outputDir = {'/mnt/norgay/Datasets/Climate/ERA_Interim/Binned_temperature'};    

    project_erai_weather_data(s, a, label, outputDir)
% end
disp('----DONE----')
toc








