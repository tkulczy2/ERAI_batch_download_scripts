
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

    % Sol's machine
    %cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/BRA

    % Tamma - Shackleton: call shapefiles stored on Norgay
%     command = ['cd ' shapeDir];
%     eval(command)

    [s,a] = shaperead(shapeFile,'UseGeoCoords', true); 
    %% Sample specific instructions here
    [s,a] = drop_by_attribute(s, a, 'BPL_CODE', '99999');
    [s,a] = drop_by_attribute(s, a, 'GEOLEVEL1', '999999');
    [s,a] = drop_by_attribute(s, a, 'ADMIN_NAME', 'Alaska');
    [s,a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Russia');
    [s,a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Fiji');
    [s,a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Antarctica');
    [s,a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Tuvalu');
    [s,a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Hong Kong');
    %[s,a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Congo');
    a = combine_attributes(a, 'CNTRY_NAME', 'ADMIN_NAME');
    for i=1:length(a)
      a(i).CNTRY_NAME_ADMIN_NAME = regexprep(a(i).CNTRY_NAME_ADMIN_NAME, ' \(.*\)', '');
    %  a(i).CNTRY_NAME_ADMIN_NAME = regexprep(a(i).CNTRY_NAME_ADMIN_NAME, ',.*-', '-');
      a(i).CNTRY_NAME_ADMIN_NAME = regexprep(a(i).CNTRY_NAME_ADMIN_NAME, 'rdoba.*rdoba', 'rdoba');
    end

    % Tamma-Shackleton: change directory to store output files on Norgay
    baseDir = ['/mnt/norgay/Datasets/Climate/' climateDir];
    command = ['cd ' baseDir '/Matlab_projected_DAILY_polynomials'];
    eval(command) 

    outputDir = [sample '_daily_' CLIM '_polynomials'];

    command = ['mkdir ' outputDir];
    eval(command)
    command = ['cd ' outputDir];
    eval(command)
    label = 'CNTRY_NAME_ADMIN_NAME';

% end
disp('----DONE----')
toc








