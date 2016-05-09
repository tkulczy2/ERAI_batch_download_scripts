function [Q] = project_weather_par(s, a, label, field)

%
% S. HSIANG
% SMH2137@COLUMBIA.EDU
% 5/10
%
% T. Carleton edited for synthesis with all other commands in
% Lab_shared_folder/Computation/climate_projection_system_2016_2_10
% 
% T. Kulczycki edited to add ERA-Interim temperature and precip projection
% ----------------------------
%
% project_weather_par(s, a, label, variable)
%
% arguments:
%
% s         - a shapefile structure
% a         - corrosponding shapefile attributes
% label     - string reference for attribute that will be used to label obs
% field     - string that may be 'temp' or....
%
% Projects monthly weather data onto the shapefiles described by s and a,
% using label to mark the observations.  Monthly weather is averaged over
% each district by area and by population, for each month. All 24 values
% (per year) are recorded in the output_table. The output_table is ready
% for export (see CELL2CSV) and is in a "long" format where each obs is a
% district and year.
%
% Weather datasets are stored on the hard drive and accessed automatically
% depending on which variable is selected.
%
% Allowable values for "field" are:
%
%           'UDEL-temp1'    - surface temperature from UDEL v4.01 (1950-1970)
%           'UDEL-temp2'    - surface temperature from UDEL v4.01 (1971-1990)
%           'UDEL-temp3'    - surface temperature from UDEL v4.01 (1991-2010)
%           'UDEL-temp4'    - surface temperature from UDEL v4.01 (2011-2014)
%           'UDEL-precip1'  - precipitation from UDEL v4.01 (1950-1970)
%           'UDEL-precip2'  - precipitation from UDEL v4.01 (1971-1990)
%           'UDEL-precip3'  - precipitation from UDEL v4.01 (1991-2010)
%           'UDEL-precip4'  - precipitation from UDEL v4.01 (2011-2014)
%           'BOM-avg-temp'  - average temp from AUS BOM (1950-2007)
%           'BOM-max-temp'  - maximum temp from AUS BOM (1950-2007)
%           'BOM-min-temp'  - minimum temp from AUS BOM (1950-2007)
%           'BOM-precip'    - total precip from AUS BOM (1891-2007)
%           'NCEP-temp'     - surface temperature from NCEP CDAS 1 (1949-2008)
%           'NCEP-dd*'      - surface temp in degree days from NCEP CDAS 1 (1948-2010)
%                               *  = {0,10,20,23,25,27,29,30,35,40}
%           'CMAP-precip'   - precipitation rate from NCEP CMAP (1979-2008)
%           'LICRICE-pddi'  - power dissipation from LICRICE v2 (1950-2008)
%           'LICRICE-maxs'  - maximum windspeed from LICRICE v2 (1950-2008)
%           'LICRICE-pddi-high-res'
%                           - power dissipation from LICRICE v2 (1950-2008)
%                             resolution is 0.1 degree, limits = [48S,48N]
%           'LICRICE-maxs-high-res'
%                           - maximum windspeed from LICRICE v2 (1950-2008)
%                             resolution is 0.1 degree, limits = [48S,48N]
%           'DATASET_climatevariable_BIN_lowerbound_upperbound'
%           'NASA-aerosol'  - stratospheric optical depth (1984-2005)
%
% THIS CODE IS WRITTEN IN PARALLEL FOR DATASETS WITH A LARGE NUMBER OF
% ID-MAPS
%
% see also project_static_data_folder, project_weather_data_folder 
% project_complete_data_folder, project_weather_par_dateline


%=========== LOADING AND FORMATTING DATA ========================


%check if running in parellel
check_matlabpool;

tic

K = 150; %MAX NUMBER OF ID MAPS TO MAKE AND STORE

disp('------------------------------------------')
disp('               LOADING DATA ')
disp('------------------------------------------')

irregular_data = false;


%first check if designated output is a large number of 


% identifying strings for binned variables will all have the following form
%
% 'DATASET_climatevariable_BIN_lowerbound_upperbound'
%

%first check if this is a binned variable
binned_variable = false;
if length(regexp(field, '_BIN_'))>0 % true if '_BIN_' is present as part of name string
    binned_variable = true;
    
    %parse the field elements
    name_elements = regexp(field, '_', 'split');
    datasample = name_elements{1};
    clim_variable = name_elements{2};
    bin_lower_bound = name_elements{4};
    bin_upper_bound = name_elements{5};
    bin_id = [name_elements{4} '_' name_elements{5}];
end
 
%second check if this is a polynomial variable
polynomial_variable = false;
if length(regexp(field, '_polynomial_'))>0 % true if '_polynomial_' is present as part of name string
    polynomial_variable = true;
   
    %parse the field elements
    name_elements = regexp(field, '_', 'split');
    datasample = name_elements{1};
    clim_variable = 'tavg';
    poly_power = name_elements{3};
    poly_id = name_elements{3};
    
end

%third check if this is a degree-days variable
degreedays_variable = false;

if length(regexp(field, '_DEGDAY_'))>0 % true if 'dd_BIN_' is present as part of name string
    degreedays_variable = true;
    
    %parse the field elements
    name_elements = regexp(field, '_', 'split');
    datasample = name_elements{1};
    clim_variable = name_elements{2};
    bin_cutoff = name_elements{4};
    bin_id = name_elements{4};
    
end


% -----------------------------------
% IDENTIFYING AND LOADING IF BINNED DATA
% -----------------------------------

if binned_variable == true
    
    
    if strcmp(datasample,'BEST') 
        %---------------------------------------------------------------------|
        % BERKELEY EARTH SURFACE TEMPERATURE DATA
        %
        % PERIOD: 1880-2012
        % UNITS: count of days in temperature bin (1C wide)
        % 1.0 deg resolution (lat-lon)
        % lat lim ~ [-89.5 89.5]
        % lon lim ~ [-179.5 179.5]
        %
        % NOTES:
        % BEST data begins in Jan 1880, monthly obs
        % many missing obs in early periods
        %
        %project 1596 observations (up to Dec 2012, inclusive)
        
        pathname = '''/mnt/norgay/Datasets/Climate/Berkeley_Earth/Matlab_4d_stack_by_temp_bin/';
        if strcmp(clim_variable,'tavg')
            varname = 'average temperature';
            filename = [clim_variable '_bin_' bin_lower_bound '_' bin_upper_bound '_' datasample '_1880_2012'];
            command = ['load ' pathname 'TAVG/' filename ''''];
            eval(command)
            structure_name = [clim_variable '_bin_' bin_lower_bound '_' bin_upper_bound '_daily_count_monthly'];
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; returni
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        end
        
        density = 1; %1 degree resolution
        M = 12; %resolution is monthly   
        variable = [clim_variable '_bin_' bin_lower_bound '_' bin_upper_bound]; %string used to name outcome variables
        command = ['structure_x = ' structure_name '; clear ' structure_name];
        eval(command)
        
        lat = structure_x.lat;
        lon = structure_x.lon;
        latlim = double([lat(1) lat(end)]);
        lonlim = double([lon(1) lon(end)]);
        
        %--------USE THIS SECTION FOR REDUCED SAMPLE
        
        first_year_set = 1950; % <- set to first year in sample (end=2012) 
        
        year_ID_for_starting = find(structure_x.year==first_year_set);
        data = structure_x.monthly_field(:,:,year_ID_for_starting:end,:);   
        start_year = structure_x.year(year_ID_for_starting);
        years_total = length(structure_x.year(year_ID_for_starting:end));
        %
        %--------USE THIS SECTION FOR FULL SAMPLE 1880-2012 (COMMENT ABOVE)
        %data = structure_x.monthly_field;  
        %start_year = structure_x.year(1);
        %years_total = length(structure_x.year);
        %------------------------------------------------------------------
        
        clear structure_x year_ID_for_starting first_year_set
        source = 'BERKELEY EARTH SURFACE TEMPERATURE DATA';
        %---------------------------------------------------------------------|
        
        
    elseif strcmp(datasample,'ISCCP') 
        %---------------------------------------------------------------------|
        % ISCCP INSOLATION DATA
        %
        %ISCCP data begins in Jan 1983, monthly obs
        %project 324 observations (up to Dec 2009, inclusive), with additional
        %missing
        
        %need to mount NORGAY first
        pathname = '''/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_IBins_4D/';
        if strcmp(clim_variable,'Insol')
            varname = 'Insolation_3hr';
            filename = [datasample '_' clim_variable '_BIN_' bin_lower_bound '_' bin_upper_bound];
            command = ['load ' pathname filename ''''];
            eval(command)
            %structure_name = [clim_variable '_bin_' bin_lower_bound '_' bin_upper_bound '_3hr_count_monthly'];
            structure_name = 'IMonthBin';
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        end
        
        density = 2; %0.5 deg lon by 2.5 deg lat degree resolution
        M = 12; %resolution is monthly   
        variable = [clim_variable '_bin_' bin_lower_bound '_' bin_upper_bound]; %string used to name outcome variables
        command = ['structure_x = ' structure_name '; clear ' structure_name];
        eval(command)
 
        irregular_data = true;
    
        lat = structure_x.lat;
        lon = structure_x.lon;
        latlim = double([lat(1) lat(end)]);
        lonlim = double([lon(1) lon(end)]);

        data = structure_x.field;   

        start_year = structure_x.year(1);
        years_total = length(structure_x.year);

     
        clear structure_x year_ID_for_starting first_year_set

        source = 'ISCCP INSOLATION DATA';

        %---------------------------------------------------------------------|   
        
    
    elseif strcmp(datasample, 'CPC')
        %---------------------------------------------------------------------|
        % CPC UNIFIED GAUGE-BASED ANALAYSI OF GLOBAL DAILY PRECIPITATION
        if strcmp(clim_variable, 'precip')
            disp('------------------not formatted yet'); Q = false; return
        end
        %---------------------------------------------------------------------|
        
        
  
        
    elseif strcmp(datasample, 'ERA')
        %---------------------------------------------------------------------|
        % ECMWF ERA-INTERIM REANALYSIS
        if strcmp(clim_variable,'tavg')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable, 'precip')
            disp('------------------not formatted yet'); Q = false; return
        end
        %---------------------------------------------------------------------|
        
        
        
        
        
    elseif strcmp(datasample, 'CFSR')
        %---------------------------------------------------------------------|
        % 
        if strcmp(clim_variable,'tavg')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable, 'precip')
            disp('------------------not formatted yet'); Q = false; return
        end
        %---------------------------------------------------------------------|
    end

    
% -----------------------------------
% IDENTIFYING AND LOADING IF POLYNOMIAL DATA
% -----------------------------------

elseif polynomial_variable == true
    
    if strcmp(datasample,'BEST') 
        %---------------------------------------------------------------------|
        % BERKELEY EARTH SURFACE TEMPERATURE DATA
        %
        % PERIOD: 1880-2012
        % UNITS: count of days in temperature bin (1C wide)
        % 1.0 deg resolution (lat-lon)
        % lat lim ~ [-89.5 89.5]
        % lon lim ~ [-179.5 179.5]
        %
        % NOTES:
        % BEST data begins in Jan 1880, monthly obs
        % many missing obs in early periods
        %
        %project 1596 observations (up to Dec 2012, inclusive)
        
        %must mount NORGAY first
        pathname = '''/mnt/norgay/Datasets/Climate/Berkeley_Earth/Matlab_4d_stack_by_poly/';
        
        if strcmp(clim_variable,'tavg')
            
            varname = 'average temperature';
            filename = ['sum_' clim_variable '_' poly_power '_poly_' datasample '_1880_2012'];
            command = ['load ' pathname 'TAVG/' filename ''''];
            eval(command)
            structure_name = ['sum_' clim_variable '_' poly_power '_poly_monthly'];
            
         elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        end
        
        density = 1; %1 degree resolution
        M = 12; %resolution is monthly   
        variable = [clim_variable '_polynomial_' poly_power]; %string used to name outcome variables
        command = ['structure_x = ' structure_name '; clear ' structure_name];
        eval(command)
        
        lat = structure_x.lat;
        lon = structure_x.lon;
        latlim = double([lat(1) lat(end)]);
        lonlim = double([lon(1) lon(end)]);
        
        %--------USE THIS SECTION FOR REDUCED SAMPLE
        
        first_year_set = 1950; % <- set to first year in sample (end=2012) 
        
        year_ID_for_starting = find(structure_x.year==first_year_set);
        data = structure_x.monthly_field(:,:,year_ID_for_starting:end,:);   
        start_year = structure_x.year(year_ID_for_starting);
        years_total = length(structure_x.year(year_ID_for_starting:end));
        %
        %--------USE THIS SECTION FOR FULL SAMPLE 1880-2012 (COMMENT ABOVE)
        %data = structure_x.monthly_field;  
        %start_year = structure_x.year(1);
        %years_total = length(structure_x.year);
        %------------------------------------------------------------------
        
        clear structure_x year_ID_for_starting first_year_set
        source = 'BERKELEY EARTH SURFACE TEMPERATURE DATA';
        %---------------------------------------------------------------------|    
        
        
    elseif strcmp(datasample, 'UDEL')
        %---------------------------------------------------------------------|
        % UNIVERSITY OF DELAWARE
        if strcmp(clim_variable,'tavg')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable, 'precip')
            disp('------------------not formatted yet'); Q = false; return
        end
        %---------------------------------------------------------------------|
        
        
    elseif strcmp(datasample, 'NCEP')
        %---------------------------------------------------------------------|
        % 
        if strcmp(clim_variable,'tavg')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable, 'precip')
            disp('------------------not formatted yet'); Q = false; return
        end
        %---------------------------------------------------------------------|
    end

    
% -----------------------------------
% IDENTIFYING AND LOADING IF DEGREEDAY DATA
% -----------------------------------

elseif degreedays_variable == true
    
     if strcmp(datasample,'BEST') 
        %---------------------------------------------------------------------|
        % BERKELEY EARTH SURFACE TEMPERATURE DATA
        %
        % PERIOD: 1880-2012
        % UNITS: count of days in temperature bin (1C wide)
        % 1.0 deg resolution (lat-lon)
        % lat lim ~ [-89.5 89.5]
        % lon lim ~ [-179.5 179.5]
        %
        % NOTES:
        % BEST data begins in Jan 1880, monthly obs
        % many missing obs in early periods
        %
        %project 1596 observations (up to Dec 2012, inclusive)
        
        pathname = '''/mnt/norgay/Datasets/Climate/Berkeley_Earth/Matlab_4d_stack_by_DD/';
        
        if strcmp(clim_variable,'dd')
            varname = 'degree days';
            filename = ['sum_dd' bin_cutoff '_' datasample '_1880_2012'];
            command = ['load ' pathname 'TAVG/' filename ''''];
            eval(command)
            structure_name = ['sum_dd' bin_cutoff 'monthly'];
            
        elseif strcmp(clim_variable,'cdd')
            varname = 'cooling degree days';
            filename = ['sum_cdd' bin_cutoff '_' datasample '_1880_2012'];
            command = ['load ' pathname 'TAVG/' filename ''''];
            eval(command)
            structure_name = ['sum_cdd' bin_cutoff 'monthly'];
            
        elseif strcmp(clim_variable,'hdd')
            varname = 'heating degree days';
            filename = ['sum_hdd' bin_cutoff '_' datasample '_1880_2012'];
            command = ['load ' pathname 'TAVG/' filename ''''];
            eval(command)
            structure_name = ['sum_hdd' bin_cutoff 'monthly'];
            
        end
        
        density = 1; %1 degree resolution
        M = 12; %resolution is monthly   
        variable = [clim_variable '_bin_' bin_cutoff]; %string used to name outcome variables
        command = ['structure_x = ' structure_name '; clear ' structure_name];
        eval(command)
        
        lat = structure_x.lat;
        lon = structure_x.lon;
        latlim = double([lat(1) lat(end)]);
        lonlim = double([lon(1) lon(end)]);
        
        %--------USE THIS SECTION FOR REDUCED SAMPLE
        
        first_year_set = 1950; % <- set to first year in sample (end=2012) 
        
        year_ID_for_starting = find(structure_x.year==first_year_set);
        data = structure_x.monthly_field(:,:,year_ID_for_starting:end,:);   
        start_year = structure_x.year(year_ID_for_starting);
        years_total = length(structure_x.year(year_ID_for_starting:end));
        %
        %--------USE THIS SECTION FOR FULL SAMPLE 1880-2012 (COMMENT ABOVE)
        %data = structure_x.monthly_field;  
        %start_year = structure_x.year(1);
        %years_total = length(structure_x.year);
        %------------------------------------------------------------------
        
        clear structure_x year_ID_for_starting first_year_set
        source = 'BERKELEY EARTH SURFACE TEMPERATURE DATA';
        %---------------------------------------------------------------------|
    
        
        
     elseif strcmp(datasample, 'NCEP')
        %---------------------------------------------------------------------|
        % 
        if strcmp(clim_variable,'tavg')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmax')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable,'tmin')
            disp('------------------not formatted yet'); Q = false; return
        elseif strcmp(clim_variable, 'precip')
            disp('------------------not formatted yet'); Q = false; return
        end
        %---------------------------------------------------------------------|
    end
    
    
    
% -----------------------------------
% LOAD IF ANY NON-BINNED, NON-POLYNOMIAL, NON-DEGREEDAY DATA SAMPLES
% -----------------------------------

elseif strcmp(field,'UDEL-temp1')

    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE U. DEL RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =2;

    % Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Temp/formatted/UDEL_temp_1950_1970.mat'
    % Sol's machine
    %load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Temp/formatted/UDEL_temp_1950_1970.mat'
    
                                        % degrees C
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_temp.data; 
    lat = UDEL_temp.lat;
    lon = UDEL_temp.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_temp.year(1);
    years_total = length(UDEL_temp.year);

    clear UDEL_temp
    source = 'UNIV DELAWARE reconstruction';
    varname = 'temperature';
    variable = 'temp';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 492 observations (up to Dec 1990, inclusive)  
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
elseif strcmp(field,'UDEL-temp2')

    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE U. DEL RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =2;
    
    % Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Temp/formatted/UDEL_temp_1971_1990.mat'
    % Sol's machine
    %load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Temp/formatted/UDEL_temp_1971_1990.mat'
    
                                        % degrees C
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_temp.data; 
    lat = UDEL_temp.lat;
    lon = UDEL_temp.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_temp.year(1);
    years_total = length(UDEL_temp.year);

    clear UDEL_temp
    source = 'UNIV DELAWARE reconstruction';
    varname = 'temperature';
    variable = 'temp';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 492 observations (up to Dec 1990, inclusive)  
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    
elseif strcmp(field, 'UDEL-temp3')
    
    %                                       (replicate and adjust this
    %                                       section to allow alternative
    %                                       data sources)
    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE U. DEL RECONSTRUCTION DATA
    
    % setting appropriate densities based on the dataset
    
    density =2;
    
    % Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Temp/formatted/UDEL_temp_1991_2010.mat'
    % Sol's machine
    
   %load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Temp/formatted/UDEL_temp_1991_2010.mat'
    
                                        % formatted 1991-2010
                                        % degrees C
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_temp.data; 
    lat = UDEL_temp.lat;
    lon = UDEL_temp.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_temp.year(1);
    years_total = length(UDEL_temp.year);

    clear UDEL_temp
    source = 'UNIV DELAWARE reconstruction';
    varname = 'temperature';
    variable = 'temp';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 216 observations (up to Dec 2008, inclusive)
    
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
elseif strcmp(field, 'UDEL-temp4')
    
    %                                       (replicate and adjust this
    %                                       section to allow alternative
    %                                       data sources)
    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE U. DEL RECONSTRUCTION DATA
    
    % setting appropriate densities based on the dataset
    
    density =2;
    
    % Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Temp/formatted/UDEL_temp_2011_2014.mat'
    % Sol's machine
    %   load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Temp/formatted/UDEL_temp_2011_2014.mat'
    
                                        % formatted 2011-2014
                                        % degrees C
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_temp.data; 
    lat = UDEL_temp.lat;
    lon = UDEL_temp.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_temp.year(1);
    years_total = length(UDEL_temp.year);

    clear UDEL_temp
    source = 'UNIV DELAWARE reconstruction';
    varname = 'temperature';
    variable = 'temp';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 216 observations (up to Dec 2008, inclusive)
    
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

elseif strcmp(field,'UDEL-precip1')

    %---------------------------------------------------------------------|
    % VARIABLE = 'PRECIP': USE U. DEL RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =2;
    
    % Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Precip/formatted/UDEL_precip_1950_1970.mat'
    % Sol's machine
    %load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Precip/formatted/UDEL_precip_1950_1970.mat'
    
                                        % mm/month
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_precip.data; 
    lat = UDEL_precip.lat;
    lon = UDEL_precip.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_precip.year(1);
    years_total = length(UDEL_precip.year);

    clear UDEL_precip
    source = 'UNIV DELAWARE reconstruction';
    varname = 'precipitation';
    variable = 'precip';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 492 observations (up to Dec 1990, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
elseif strcmp(field,'UDEL-precip2')

    %---------------------------------------------------------------------|
    % VARIABLE = 'PRECIP': USE U. DEL RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =2;
    % Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Precip/formatted/UDEL_precip_1971_1990.mat'
    % Sol's machine
    %load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Precip/formatted/UDEL_precip_1971_1990.mat'
    
                                        % mm/month
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_precip.data; 
    lat = UDEL_precip.lat;
    lon = UDEL_precip.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_precip.year(1);
    years_total = length(UDEL_precip.year);

    clear UDEL_precip
    source = 'UNIV DELAWARE reconstruction';
    varname = 'precipitation';
    variable = 'precip';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 492 observations (up to Dec 1990, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
    
elseif strcmp(field,'UDEL-precip3')

    %---------------------------------------------------------------------|
    % VARIABLE = 'PRECIP': USE U. DEL RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =2;
% Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Precip/formatted/UDEL_precip_1991_2010.mat'
    % Sol's machine
    %load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Precip/formatted/UDEL_precip_1991_2010.mat'
    
                                        % formatted 1991-2010
                                        % mm/month
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_precip.data; 
    lat = UDEL_precip.lat;
    lon = UDEL_precip.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_precip.year(1);
    years_total = length(UDEL_precip.year);

    clear UDEL_precip
    source = 'UNIV DELAWARE reconstruction';
    varname = 'precipitation';
    variable = 'precip';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 216 observations (up to Dec 1990, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

elseif strcmp(field,'UDEL-precip4')

    %---------------------------------------------------------------------|
    % VARIABLE = 'PRECIP': USE U. DEL RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =2;
% Shackleton-Norgay
    load '/mnt/norgay/Datasets/Climate/UDEL/UDEL_v5/Precip/formatted/UDEL_precip_2011_2014.mat'
    % Sol's machine
    % load '/Volumes/Disk 1 RAID Set/DATASETS/UDEL_v4/Precip/formatted/UDEL_precip_2011_2014.mat'
    
                                        % formatted 2011-2014
                                        % mm/month
                                        % 0.5 deg resolution
                                        % lat lim ~ [-89.75 89.75]
                                        % lon lim ~ [-179.75 179.75]
                                        % 
    data = UDEL_precip.data; 
    lat = UDEL_precip.lat;
    lon = UDEL_precip.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = UDEL_precip.year(1);
    years_total = length(UDEL_precip.year);

    clear UDEL_precip
    source = 'UNIV DELAWARE reconstruction';
    varname = 'precipitation';
    variable = 'precip';

    %UDEL data begins in Jan 1950, monthly obs
    %its broken into three files since each is too large: 
    %1950-1970
    %1971-1990 
    %1991-2010
    
    %project 216 observations (up to Dec 1990, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    

elseif strcmp(field,'NASA-aerosol')

    %---------------------------------------------------------------------|
    % VARIABLE = 'AEROSOLOPTICALDEPTH': USE NASA SATTELITE DATA

    % setting appropriate densities based on the dataset
    
    density = 2;

    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Aerosol/nasa_struct.mat'    
    
                                        % unitless (optical depth)
                                        % irregular resolution (5 x 15 mostly)
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = nasa_struct.field; 
    lat = nasa_struct.lat;
    lon = nasa_struct.lon;
    

    % error if use stored lat lim because many countries fall between edge
    % of lim and edge of world, so dropped when making ID maps
    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = nasa_struct.year(1);
    years_total = length(nasa_struct.year);

    irregular_data = true;
    
    clear nasa_struct
    source = 'NASA interpolation';
    varname = 'aerosol';
    variable = 'aerosol';

    %UDEL data begins in Oct 1984, monthly obs (first 9 months are NaNs)
    
    %project 130 observations (up to July 2005, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
    
    
    %---------------------------------------------------------------------|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Nasa_flipped        
%
%   UNABLE TO TELL FOR SURE WHICH DATASET IS RIGHT SIDE UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
           
elseif strcmp(field,'NASA-aerosol-Flipped')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'AEROSOLOPTICALDEPTH': USE NASA SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Aerosol/nasa_flipped_struct.mat'    
    
                                        % optical depth (unitless)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = nasa_flipped_struct.field; 
   
    
    lat = nasa_flipped_struct.lat;
    lon = nasa_flipped_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = nasa_flipped_struct.year(1);
    years_total = length(nasa_flipped_struct.year);
 
    irregular_data = true;
    
    clear nasa_flipped_struct
    source = 'Nasa data from Larry';
    varname = 'nasa_flipped';
    variable = 'nasa_flipped';
 
    %NASA Data 
    
    M = 12; %resolution is monthly
               
    
elseif strcmp(field,'ISCCP-InsolationMonthTotal')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'AEROSOLOPTICALDEPTH': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_struct.field; 
   
    
    lat = Itot_struct.lat;
    lon = Itot_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_struct.year(1);
    years_total = length(Itot_struct.year);
 
    irregular_data = true;
    
    clear Itot_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot';
    variable = 'IMonthTot';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
    
    
    %---------------------------------------------------------------------|

elseif strcmp(field,'ISCCP-PctDCloudy')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'PctDCloudy': USE ISCCP Cloud Data
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_PctDCloudy_struct.mat'    
    
                                        % unitless fraction (fraction time Cloudy, Time-Weighted)
                                        % irregular resolution (2.5 x .5 mostly)
                                        %   but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = PctDCloudy_struct.field; 
    lat = PctDCloudy_struct.lat;
    lon = PctDCloudy_struct.lon;
    

    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];

    start_year = PctDCloudy_struct.year(1);
    years_total = length(PctDCloudy_struct.year);
 
    irregular_data = true;
    
    clear PctDCloudy_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'PctDCloudy';
    variable = 'PctDCloudy';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
    
    
    %---------------------------------------------------------------------|

elseif strcmp(field,'ISCCP-PctICloudy')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'PctICloudy': USE ISCCP Cloud Data
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_PctICloudy_struct.mat'    
    
                                        % unitless fraction (fraction time Cloudy, Insolation-Weighted)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = PctICloudy_struct.field; 
    lat = PctICloudy_struct.lat;
    lon = PctICloudy_struct.lon;
    
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = PctICloudy_struct.year(1);
    years_total = length(PctICloudy_struct.year);
 
    irregular_data = true;
    
    clear PctICloudy_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'PctICloudy';
    variable = 'PctICloudy';
 
    %ISCCP data begins in Jan 1983, monthly obs
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
    
    
    %---------------------------------------------------------------------|

elseif strcmp(field,'SPARC-aerosol')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'AEROSOLOPTICALDEPTH': USE sparc SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 1;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Aerosol/sparc_struct.mat'    
    
                                        % unitless (optical depth)
                                        % irregular resolution (5 x 360)
                                        % Regridded to be 1 x 1 degree
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = sparc_struct.field; 
    lat = sparc_struct.lat;
    lon = sparc_struct.lon;
    
 
    % error if use stored lat lim because many countries fall between edge
    % of lim and edge of world, so dropped when making ID maps
    latlim = [-89.5 89.5];
    lonlim = [-179.5 179.5];
 
    start_year = sparc_struct.year(1);
    years_total = length(sparc_struct.year);
 
    %irregular_data = true;
    
    clear sparc_struct
    source = 'sparc interpolation';
    varname = 'aerosol';
    variable = 'aerosol';
 
    %SPARC data begins in Jan 1979, monthly obs 
    
    %project 288 observations (up to Dec 2002, inclusive)
    
    M = 12; %resolution is monthly
    
    
    %---------------------------------------------------------------------|
      
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot-TOA        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
           
elseif strcmp(field,'ISCCP-InsolationMonthTotal-TOA')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'Top of atmosphere insolation': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_TOA_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_TOA_struct.field; 
   
    
    lat = Itot_TOA_struct.lat;
    lon = Itot_TOA_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_TOA_struct.year(1);
    years_total = length(Itot_TOA_struct.year);
 
    irregular_data = true;
    
    clear Itot_TOA_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_TOA';
    variable = 'IMonthTot_TOA';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot-direct        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
elseif strcmp(field,'ISCCP-InsolationMonthTotal-direct')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'direct sunlight': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_direct_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_direct_struct.field; 
   
    
    lat = Itot_direct_struct.lat;
    lon = Itot_direct_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_direct_struct.year(1);
    years_total = length(Itot_direct_struct.year);
 
    irregular_data = true;
    
    clear Itot_direct_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_direct';
    variable = 'IMonthTot_direct';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
      
          
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot-diffuse        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
elseif strcmp(field,'ISCCP-InsolationMonthTotal-diffuse')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'diffuse sunlight': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_diffuse_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_diffuse_struct.field; 
   
    
    lat = Itot_diffuse_struct.lat;
    lon = Itot_diffuse_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_diffuse_struct.year(1);
    years_total = length(Itot_diffuse_struct.year);
 
    irregular_data = true;
    
    clear Itot_diffuse_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_diffuse';
    variable = 'IMonthTot_diffuse';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
              
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot-TOA_normalized        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
           
elseif strcmp(field,'ISCCP-InsolationMonthTotal-TOA-normalized')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'Top of atmosphere insolation': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_TOA_normalized_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_TOA_normalized_struct.field; 
   
    
    lat = Itot_TOA_normalized_struct.lat;
    lon = Itot_TOA_normalized_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_TOA_normalized_struct.year(1);
    years_total = length(Itot_TOA_normalized_struct.year);
 
    irregular_data = true;
    
    clear Itot_TOA_normalized_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_normalized_TOA';
    variable = 'IMonthTot_normalized_TOA';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot-direct_normalized        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
elseif strcmp(field,'ISCCP-InsolationMonthTotal-direct-normalized')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'direct sunlight': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_direct_normalized_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_direct_normalized_struct.field; 
   
    
    lat = Itot_direct_normalized_struct.lat;
    lon = Itot_direct_normalized_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_direct_normalized_struct.year(1);
    years_total = length(Itot_direct_normalized_struct.year);
 
    irregular_data = true;
    
    clear Itot_direct_normalized_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_direct_normalized';
    variable = 'IMonthTot_direct_normalized';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
      
          
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot-diffuse_normalized        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
elseif strcmp(field,'ISCCP-InsolationMonthTotal-diffuse-normalized')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'diffuse sunlight': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_diffuse_normalized_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_diffuse_normalized_struct.field; 
   
    
    lat = Itot_diffuse_normalized_struct.lat;
    lon = Itot_diffuse_normalized_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_diffuse_normalized_struct.year(1);
    years_total = length(Itot_diffuse_normalized_struct.year);
 
    irregular_data = true;
    
    clear Itot_diffuse_normalized_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_diffuse_normalized';
    variable = 'IMonthTot_diffuse_normalized';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Itot_normalized        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
           
elseif strcmp(field,'ISCCP-InsolationMonthTotal-normalized')
 
    %---------------------------------------------------------------------|
    % VARIABLE = 'Top of atmosphere insolation': USE ISCCP SATTELITE DATA
 
    % setting appropriate densities based on the dataset
    
    density = 2;
 
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Pinatubo/Clouds/Gridded_4d_Metrics_To_Project/Structs/ISCCP_ITot_normalized_struct.mat'    
    
                                        % insolation (watt-hrs/m^2)
                                        % irregular resolution (2.5 x .5 mostly)
                                        % but from ISCCP eq. area grid.
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        % 
    data = Itot_normalized_struct.field; 
   
    
    lat = Itot_normalized_struct.lat;
    lon = Itot_normalized_struct.lon;
    
    latlim = [-89.75 89.75];
    lonlim = [-179.75 179.75];
 
    start_year = Itot_normalized_struct.year(1);
    years_total = length(Itot_normalized_struct.year);
 
    irregular_data = true;
    
    clear Itot_normalized_struct
    source = 'ISCCP Cloud Data Calculated in House';
    varname = 'IMonthTot_normalized';
    variable = 'IMonthTot_normalized';
 
    %ISCCP data begins in Jan 1983, monthly obs
    
    %project 324 observations (up to Dec 2009, inclusive), with additional
    %missing
    
    M = 12; %resolution is monthly
    


    
elseif strcmp(field,'BOM-avg-temp')

    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE Bureau of Meterology RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =4;

    load '/Volumes/Disk 1 RAID Set/DATASETS/BOM/formatted/BOM_precip_temp_1950_2007_wide' BOM_avg_temp
    
                                        % formatted 1950-2007
                                        % deg C
                                        % 0.25 deg resolution
                                        % lat lim ~ [-44.5 -9]
                                        % lon lim ~ [112 160]
                                        % 
    data = BOM_avg_temp.data; 
    lat = BOM_avg_temp.lat;
    lon = BOM_avg_temp.lon;
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = BOM_avg_temp.year(1);
    years_total = length(BOM_avg_temp.year);

    clear BOM_avg_temp
    source = 'Bureau of Meterology';
    varname = 'avg avg temp';
    variable = 'temp';
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
    
elseif strcmp(field,'BOM-max-temp')

    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE Bureau of Meterology RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =4;

    load '/Volumes/Disk 1 RAID Set/DATASETS/BOM/formatted/BOM_precip_temp_1950_2007_wide' BOM_max_temp
    
                                        % formatted 1950-2007
                                        % deg C
                                        % 0.25 deg resolution
                                        % lat lim ~ [-44.5 -9]
                                        % lon lim ~ [112 160]
                                        % 
    data = BOM_max_temp.data; 
    lat = BOM_max_temp.lat;
    lon = BOM_max_temp.lon; 
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = BOM_max_temp.year(1);
    years_total = length(BOM_max_temp.year);

    clear BOM_max_temp
    source = 'Bureau of Meterology';
    varname = 'avg max temp';
    variable = 'tMax';
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
    
elseif strcmp(field,'BOM-min-temp')

    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE Bureau of Meterology RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =4;

    load '/Volumes/Disk 1 RAID Set/DATASETS/BOM/formatted/BOM_precip_temp_1950_2007_wide' BOM_min_temp
    
                                        % formatted 1950-2007
                                        % deg C
                                        % 0.25 deg resolution
                                        % lat lim ~ [-44.5 -9]
                                        % lon lim ~ [112 160]
                                        % 
    data = BOM_min_temp.data; 
    lat = BOM_min_temp.lat;
    lon = BOM_min_temp.lon; 

    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = BOM_min_temp.year(1);
    years_total = length(BOM_min_temp.year);

    clear BOM_min_temp
    source = 'Bureau of Meterology';
    varname = 'avg min temp';
    variable = 'tMin';
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
        
elseif strcmp(field,'BOM-precip')

    %---------------------------------------------------------------------|
    % VARIABLE = 'PRECIP': USE Bureau of Meterology RECONSTRUCTION DATA

    % setting appropriate densities based on the dataset
    
    density =4;

    load '/Volumes/Disk 1 RAID Set/DATASETS/BOM/formatted/BOM_precip_temp_1950_2007_wide' BOM_precip
    
                                        % formatted 1891-2007
                                        % mm/month
                                        % 0.25 deg resolution
                                        % lat lim ~ [-44.5 -9]
                                        % lon lim ~ [112 160]
    data = BOM_precip.data; 
    lat = BOM_precip.lat;
    lon = BOM_precip.lon; 
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = BOM_precip.year(1);
    years_total = length(BOM_precip.year);

    clear BOM_precip
    source = 'Bureau of Meterology';
    varname = 'avg precip';
    variable = 'precip';
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
    
elseif strcmp(field, 'NCEP-temp')

    %---------------------------------------------------------------------|
    % VARIABLE = 'TEMP': USE NCEP CDAS1 REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density =1;

    load NCEP_CDAS1_1949_2008_4D   
    
                                        % formatted 1949-2009 
                                        % degrees C
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = CDAS1.temp; 
    lat = CDAS1.lat;
    lon = CDAS1.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1949;
    years_total = 60;

    clear NCEP1
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg temp';
    variable = 'temp';
    
    irregular_data = true;
    
    %NCEP data begins in Jan 1949, monthly obs
    %project 720 observations (up to Dec 2008, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

    
    
    
    
    
    
elseif strcmp(field, 'NCEP-cdd0')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Cooling degree days above ': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;
    
    %NEED TO MOUNT NORGAY FIRST
    load '/mnt/norgay/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2/formatted/NCEP_CDAS1_DegreeDays_1948_to_2014.mat' 'sum_cdd0' 'tau'
    
                                        % formatted 1948-2014 
                                        % degrees C above tau = 15 x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = sum_cdd0.monthly_field; 
    lat = sum_cdd0.lat;
    lon = sum_cdd0.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 67;

    clear sum_cdd0
    source = 'NCEP CDAS 1 reanalysis';
    varname = ['sum degree days above ' tau 'C']; clear tau;
    variable = 'CDD0';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 804 observations (up to Dec 2014, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
    
    
    
elseif strcmp(field, 'NCEP-dd0')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 0': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd0
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd0.monthly_field; 
    lat = avg_dd0.lat;
    lon = avg_dd0.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd0
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 0C';
    variable = 'DD0';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 756 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

elseif strcmp(field, 'NCEP-dd5')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 5': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd5
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd5.monthly_field; 
    lat = avg_dd5.lat;
    lon = avg_dd5.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd5
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 5C';
    variable = 'DD5';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    
  
    
elseif strcmp(field, 'NCEP-dd10')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 10': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd10
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd10.monthly_field; 
    lat = avg_dd10.lat;
    lon = avg_dd10.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd10
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 10C';
    variable = 'DD10';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    

elseif strcmp(field, 'NCEP-dd15')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 15': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd15
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd15.monthly_field; 
    lat = avg_dd15.lat;
    lon = avg_dd15.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd10
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 15C';
    variable = 'DD15';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    


    
elseif strcmp(field, 'NCEP-dd20')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 20': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd20
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd20.monthly_field; 
    lat = avg_dd20.lat;
    lon = avg_dd20.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd20
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 20C';
    variable = 'DD20';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    

elseif strcmp(field, 'NCEP-dd23')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 23': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd23
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd23.monthly_field; 
    lat = avg_dd23.lat;
    lon = avg_dd23.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd0
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 23C';
    variable = 'DD23';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

    elseif strcmp(field, 'NCEP-dd25')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 25': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd25
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd25.monthly_field; 
    lat = avg_dd25.lat;
    lon = avg_dd25.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd25
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 25C';
    variable = 'DD25';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
elseif strcmp(field, 'NCEP-dd27')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 27': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd27
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd27.monthly_field; 
    lat = avg_dd27.lat;
    lon = avg_dd27.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd27
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 27C';
    variable = 'DD27';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

elseif strcmp(field, 'NCEP-dd29')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 29': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd29
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd29.monthly_field; 
    lat = avg_dd29.lat;
    lon = avg_dd29.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd29
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 29C';
    variable = 'DD29';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
    
elseif strcmp(field, 'NCEP-dd30')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 30': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd30
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd30.monthly_field; 
    lat = avg_dd30.lat;
    lon = avg_dd30.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd30
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 30C';
    variable = 'DD30';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|

elseif strcmp(field, 'NCEP-dd35')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 35': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd35
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd35.monthly_field; 
    lat = avg_dd35.lat;
    lon = avg_dd35.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd35
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 35C';
    variable = 'DD35';
    
    irregular_data = true;

    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    

elseif strcmp(field, 'NCEP-dd40')

    %---------------------------------------------------------------------|
    % VARIABLE = 'Degree days above 40': USE NCEP CDAS1 DAILY REANALYSIS DATA

    % setting appropriate densities based on the dataset
    
    density = 1;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/NCEP_CDAS1_daily/formatted/NCEP_CDAS1_DegreeDays_1948_to_2013.mat' avg_dd40
    
                                        % formatted 1948-2010 
                                        % degrees C x days
                                        % irregular resolution (1.9047 x 1.8750 mostly)
                                        % lat lim ~ [-88.542 88.542]
                                        % lon lim ~ [-180 178.125]
    data = avg_dd40.monthly_field; 
    lat = avg_dd40.lat;
    lon = avg_dd40.lon;

    latlim = [-89 89];
    lonlim = [-179 179];
    
    start_year = 1948;
    years_total = 66;

    clear avg_dd40
    source = 'NCEP CDAS 1 reanalysis';
    varname = 'avg degree days above 40C';
    variable = 'DD40';
    
    irregular_data = true;
    
    %daily NCEP data begins in Jan 1948, monthly obs
    %project 780 observations (up to Dec 2013, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|    

 
    
elseif strcmp(field,'CMAP-precip')
    
    %---------------------------------------------------------------------|
    % VARIABLE = 'PRECIP': USE NCEP CMAP DATA

    % setting appropriate densities based on the dataset
    
    density =1;

    load NCEP_CMAP_1979_2008_4D    
                                        % formatted 1979-2008
                                        % mm/day
                                        % 2.5 degree resolution
                                        % lat lim ~ [-88.75 88.75]
                                        % lon lim ~ [-178.75 178.75]
    data = CMAP.precip; 
    lat = CMAP.lat;
    lon = CMAP.lon;

    latlim = [-89 89];
    lonlim = [-179 179];

    start_year = 1979;
    years_total = 30;

    clear CMAP
    source = 'NCEP CMAP v1 gauge and satellite';
    varname = 'avg. precipitation';
    variable = 'precip';
    
    irregular_data = true;

    %CMAP data begins in Jan 1979, monthly obs
    %project 360 observations (up to Dec 2008, inclusive)
    
    M = 12; %resolution is monthly
    %---------------------------------------------------------------------|
  
    
elseif strcmp(field,'LICRICE-pddi')
    
    %---------------------------------------------------------------------|
    % VARIABLE = 'PDDI': USE LICRICE2 DATA

    % setting appropriate densities based on the dataset
    
    density =1;

    load LICRICE2_global_density_1_yr_1950_2008  
    
                                        % formatted 1950-2008
                                        % m^3/s^2
                                        % 1 degree resolution
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        
                                        
                                        %MUST BE CLIPPED TO
                                        % lat lim = [-89 89]
                                        % lon lim = [-180 179]
                                        %IN ORDER FOR GENERATE_ID_MAPS TO
                                        %WORK
                                        
    data = output.annual_fields.pddi(2:end-1,1:end-1,:); 
    lat = output.annual_fields.lat(2:end-1);
    lon = output.annual_fields.lon(1:end-1);
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = 1950;
    years_total = 59;
    
    clear output
    source = 'LICRICE v2 using IBTrACS data, 1950-2008';
    varname = 'Power dissipation density index';
    variable = 'pddi';

    M = 1; %resolution is annual
    %---------------------------------------------------------------------|


elseif strcmp(field,'LICRICE-maxs')
    
    %---------------------------------------------------------------------|
    % VARIABLE = 'MAXS': USE LICRICE2 DATA

    % setting appropriate densities based on the dataset
    
    density =1;

    load LICRICE2_global_density_1_yr_1950_2008  
    
                                        % formatted 1950-2008
                                        % m/s
                                        % 1 degree resolution
                                        % lat lim ~ [-90 90]
                                        % lon lim ~ [-180 180]
                                        
                                        %MUST BE CLIPPED TO
                                        % lat lim = [-89 89]
                                        % lon lim = [-180 179]
                                        %IN ORDER FOR GENERATE_ID_MAPS TO
                                        %WORK
                                        
    data = output.annual_fields.maxs(2:end-1,1:end-1,:); 
    lat = output.annual_fields.lat(2:end-1);
    lon = output.annual_fields.lon(1:end-1);
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = 1950;
    years_total = 59;

    clear output
    source = 'LICRICE v2 using IBTrACS data, 1950-2008';
    varname = 'Annual maximum wind speed at location';
    variable = 'maxs';
    
    M = 1; %resolution is annual
    %---------------------------------------------------------------------|
  
    
    elseif strcmp(field,'LICRICE-pddi-high-res')
    
    %---------------------------------------------------------------------|
    % VARIABLE = 'PDDI': USE LICRICE2 DATA

    % setting appropriate densities based on the dataset
    
    % IMPORTANT NOTE: because the high-res LICRICE data file is so large,
    % running this script in parallel consumes a huge amount of memory
    % (since each ID mask stack is passed to each processor, storing the
    % entire stack multiple times). To avoid saturating the memory,
    % projections using this data set should not be run in parallel.
    % Instead, only set matlab pool to be one. (memory = 20GB, 4/2013)
    
    density = 10;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/LICRICE_v2_global/output/aggregate/ALL_BASINS_global_density_10_yr_1950_2008'
    
                                        % formatted 1950-2008
                                        % m^3/s^2
                                        % 0.1 degree resolution
                                        % lat lim ~ [-48 48]
                                        % lon lim ~ [-180 180]
                                        
                                        %MUST BE CLIPPED TO
                                        % lon lim = [-180 179.9]
                                        %IN ORDER FOR GENERATE_ID_MAPS TO
                                        %WORK
                                        
    data = output.annual_fields.pddi(:,1:end-1,:); 
    lat = output.annual_fields.lat;
    lon = output.annual_fields.lon(1:end-1);
    
    lat = dec(lat,1); %removing any stray numbers beyond first decimal
    lon = dec(lon,1); %removing any stray numbers beyond first decimal
    
    latlim = [lat(1) lat(end)];
    lonlim = [lon(1) lon(end)];

    start_year = 1950;
    years_total = 59;
    
    clear output
    source = 'LICRICE v2 using IBTrACS data, 1950-2008';
    varname = 'Power dissipation density index';
    variable = 'pddi_d10';

    M = 1; %resolution is annual
    
    K = 25; %MAX NUMBER OF ID MAPS TO MAKE AND STORE (TO LIMIT MEMORY USAGE)

    %---------------------------------------------------------------------|
  
    
    elseif strcmp(field,'LICRICE-maxs-high-res')
    
    %---------------------------------------------------------------------|
    % VARIABLE = 'MAXS': USE LICRICE2 DATA

    % setting appropriate densities based on the dataset
    
    
    % IMPORTANT NOTE: because the high-res LICRICE data file is so large,
    % running this script in parallel consumes a huge amount of memory
    % (since each ID mask stack is passed to each processor, storing the
    % entire stack multiple times). To avoid saturating the memory,
    % projections using this data set should not be run in parallel.
    % Instead, only set matlab pool to be one. (memory = 20GB, 4/2013)
    
    density = 10;

    load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/LICRICE_v2_global/output/aggregate/ALL_BASINS_global_density_10_yr_1950_2008'
    
                                        % formatted 1950-2008
                                        % m/s
                                        % 0.1 degree resolution
                                        % lat lim ~ [-48 48]
                                        % lon lim ~ [-180 180]
                                        
                                        %MUST BE CLIPPED TO
                                        % lon lim = [-180 179.9]
                                        %IN ORDER FOR GENERATE_ID_MAPS TO
                                        %WORK
                                        
    data = output.annual_fields.maxs(:,1:end-1,:); 
    lat = output.annual_fields.lat;
    lon = output.annual_fields.lon(1:end-1);
    
    lat = dec(lat,1); %removing any stray numbers beyond first decimal
    lon = dec(lon,1); %removing any stray numbers beyond first decimal
        
    latlim = [lat(1) lat(end)]; 
    lonlim = [lon(1) lon(end)];

    start_year = 1950;
    years_total = 59;
    
    clear output
    source = 'LICRICE v2 using IBTrACS data, 1950-2008';
    varname = 'Annual maximum wind speed at location';
    variable = 'maxs_d10';

    M = 1; %resolution is annual
    
    K = 25; %MAX NUMBER OF ID MAPS TO MAKE AND STORE (TO LIMIT MEMORY USAGE)

    %---------------------------------------------------------------------|

    
    
    
else
    disp('SOL: VARIABLE is not an allowed value, see HELPFILE')
    Q = false;
    return
end
    

%============ PROJECTING DATA =================================

% THIS SECTION MIGHT BE VESTIGAL SINCE NOW USEING NANSUM AND NANMEAN
% %setting missing obs to zero, mostly just over oceans
% %(otherwise get NaN for spatial sum)
% 
% for i = 1:size(data,1);
%     for j = 1:size(data,2);
%         for k = 1:size(data,3);
%             for l = 1:size(data,4);
%                 if isnan(data(i,j,k,l))
%                     data(i,j,k,l)=0;
%                 end
%             end
%         end
%     end
% end

disp('------------------------------------------')
disp('             PROJECTING DATA ')
disp('------------------------------------------')


N = size(a, 1);

output = cell(N*years_total+1,2+3*M); 

if M == 12 %monthly data

    output(1,:) = {label,'year',[variable '_m1_area'],[variable '_m2_area'],[variable '_m3_area'],[variable '_m4_area'],[variable '_m5_area'],[variable '_m6_area'],[variable '_m7_area'],[variable '_m8_area'],[variable '_m9_area'],[variable '_m10_area'],[variable '_m11_area'],[variable '_m12_area'],[variable '_m1_pop'],[variable '_m2_pop'],[variable '_m3_pop'],[variable '_m4_pop'],[variable '_m5_pop'],[variable '_m6_pop'],[variable '_m7_pop'],[variable '_m8_pop'],[variable '_m9_pop'],[variable '_m10_pop'],[variable '_m11_pop'],[variable '_m12_pop'],[variable '_m1_crop'],[variable '_m2_crop'],[variable '_m3_crop'],[variable '_m4_crop'],[variable '_m5_crop'],[variable '_m6_crop'],[variable '_m7_crop'],[variable '_m8_crop'],[variable '_m9_crop'],[variable '_m10_crop'],[variable '_m11_crop'],[variable '_m12_crop']};

elseif M == 1 %annual data
    
    output(1,:) = {label,'year',[variable '_area'],[variable '_pop'], [variable '_crop']};    

else
    disp('SOL: check that temporal resolution parameter M is 1 or 12')
end

% -----------------------------------
%   1: BUILD SETS OF ID MAPS  (30 seconds to make 100)
%   2: SLICE THE DATA BY YEAR
%   3: PROJECT ALL 12 MONTHS ON EACH SET OF MAPS
% -----------------------------------

%K = 150; %MAX NUMBER OF ID MAPS TO MAKE AND STORE (default set at top of
%script, adjusted in large data file entries).
 

disp(['MAX NUMBER OF ID MAPS TO MAKE AND STORE: ' num2str(K)])
number_of_steps = ceil(N/K);

cells_i = cell(number_of_steps,1); % STORE OUTPUT FROM EACH BLOCK IN A CELL

% -----------------------------------
%   1: BUILD SETS OF ID MAPS (100 at a time?) (30 seconds to make 100)
% -----------------------------------

for i = 1:number_of_steps
    
    disp('------------------------------------------')
    disp(['generating ID map block ' num2str(i) ' out of ' num2str(number_of_steps)])
    disp('------------------------------------------')
    
    start_index = (i-1)*K+1;
    end_index = min(N, i*K);
    
    obs_i = end_index-start_index+1; %is equal to K except for last block
    
    %this step takes about 3 seconds for every 10 districts
    
    ID = generate_ID_maps_par(s(start_index:end_index), a(start_index:end_index), label, density, latlim, lonlim);

    %------------------|
    %here, need to adjust ID maps for irregular data 
    %fields or data fields with a pixel size larger than 1 degree, but only
    %for certain fields
    if irregular_data == true
        
        N_masks = size(ID.masks, 3);
        
        masks = zeros(size(data,1),size(data,2),N_masks); %predefine masks at the coarsened resolution
        
        for mask_i = 1:N_masks
            masks(:,:,mask_i) = flexible_coarsen_par(ID.masks(:,:,mask_i), ID.lon, ID.lat, lon, lat);
        end
        masks = ceil(masks); %so that each is zero or one
        ID.masks = masks;
        ID.lat = lat;
        ID.lon = lon;
        clear masks N_masks
        
    end
    %------------------|
    
    %------------------|
    %here, need adjust ID maps for the BEST data set if binned data so that
    %total number of days in year sum to 365 otherwise missing coastal
    %pixels create a problem
    
    if binned_variable == true && strcmp(datasample,'BEST')
        
        load '/mnt/norgay/Computation/climate_projection_system_2016_2_10/global_data/BEST_nonmissing_data_mask' % pre-saved mask where 1 if nonmissing pixel
        
        N_masks = size(ID.masks, 3);
        for mask_i = 1:N_masks
            %eliminating pixes that generate_ID_maps_par assigns to
            %nonmissing but are missing in BEST data
            ID.masks(:,:,mask_i) = ID.masks(:,:,mask_i).*nonmissing_mask.mask;
        end
    end
    
    %------------------|
    
    
    
    cells_t = cell(years_total,1); %STORE OUTPUT FOR EACH YEAR

    % -----------------------------------
    %   2: SLICE THE DATA BY YEAR
    % -----------------------------------
    
    parfor t = 1:years_total
        
        disp(['year ' num2str(t) ' of ' num2str(years_total)])
        
        if M==12
            data_t = data(:,:,t,:); % SLICING THE RAW WEATHER VARS
        elseif M==1
            data_t = data(:,:,t); % SLICING THE RAW WEATHER VARS
        else
            disp('SOL: check that temporal resolution parameter M is 1 or 12')
        end
        
        output_t = cell(obs_i,2+3*M); %STORE FULL OUTPUT WITH NO HEADER
        
        year = start_year - 1 + t;
        output_t(:,2) = num2cell(year*ones(obs_i,1)); % ENTRY WITH YEAR
   
        output_t(:,1) = ID.ID; %ENTRY WITH DISTRICT

        % -----------------------------------
        %   3: PROJECT ALL 12 MONTHS ON EACH SET OF MAPS
        % -----------------------------------
        
        if M == 12
            for m = 1:12
                                
                % area-weights
                output_t(:,2+m) = num2cell(weight_means(data_t(:,:,1,m), ID.masks, 'area', lat, lon));
                
                % population-weights
                output_t(:,2+M+m) = num2cell(weight_means(data_t(:,:,1,m), ID.masks, 'population', lat, lon));
                
                % crop-weights
                output_t(:,2+2*M+m) = num2cell(weight_means(data_t(:,:,1,m), ID.masks, 'crops', lat, lon));
                
            end
            
        elseif M == 1
            
                % area-weights
                output_t(:,2+1) = num2cell(weight_means(data_t(:,:,1), ID.masks, 'area', lat, lon));

                % population-weights
                %output_t(:,2+2) = num2cell(weight_means(data_t(:,:,1), ID.masks, 'population', lat, lon));

                % crop-weights
                %output_t(:,2+3) = num2cell(weight_means(data_t(:,:,1), ID.masks, 'crops', lat, lon));

        else
            disp('SOL: check that temporal resolution parameter M is 1 or 12')
        end
        
        cells_t{t} = output_t; %storing years for each block
        %disp(cells_t{t})
    end

    cells_i{i} = cells_t; %storing blocks
    
    toc

end



% -----------------------------------
% REASSEMBLE THE FULL ARRAY
% -----------------------------------

for i =1:number_of_steps
    cells_i{i}=cat(1,cells_i{i}{:}); %concatenate the years for each block
end

output(2:end,:) = cat(1,cells_i{:});  %concatenate the blocks of years



%districts = struct('ID',{ID.ID}, 'structures', s, 'attributes', a, 'lat', lat,'lon', lon);
districts = struct('structures', s, 'attributes', a, 'lat', lat,'lon', lon);

parameters = struct('data_source', source, 'variable', varname, 'admin_level', label, 'run_date', date);

Q = struct('output_table', {output}, 'districts', districts , 'parameters', parameters);

disp('------------------------------------------')
disp('                   DONE ')
disp('------------------------------------------')

toc

return

