%%
%   S. HSIANG 5/13/15
%   SCRIPT TO IMPORT AND FORMAT BERKELEY EARTH TEMPERATURE DATA FOR MATLAB

%%

clear
cd '/mnt/norgay/Datasets/Climate/ERA-Interim/'
mkdir Matlab_1deg_x_1deg
mkdir Matlab_1deg_x_1deg/TAVG
mkdir Matlab_1deg_x_1deg/TMAX
mkdir Matlab_1deg_x_1deg/TMIN

% -------- TAVG

for y = 1979:1:2016
    
    
    filename = ['Raw_NetCDF_1deg_x_1deg/TAVG/Complete_TAVG_Daily_LatLong1_' num2str(y) '.nc']
    
    longitude = ncread(filename, 'longitude');
    latitude = ncread(filename, 'latitude');
    year = ncread(filename, 'year');
    month = ncread(filename, 'month');
    day_of_month = ncread(filename, 'day');
    day_of_year = ncread(filename, 'day_of_year');
    tavg_anomaly = ncread(filename, 'temperature');
    tavg_climatology = ncread(filename, 'climatology');
    
    data = struct('tavg_anomaly', tavg_anomaly, 'tavg_climatology', tavg_climatology, ...
        'lon',longitude,'lat',latitude, ...
        'year', year,'month', month,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['tavg_' num2str(y) ' = data'];
    eval(command)
    
    clear data latitude longitude month day_of_month day_of_year year tavg_anomaly tavg_climatology 
    
    command = ['save Matlab_1deg_x_1deg/TAVG/Complete_TAVG_Daily_LatLong1_' num2str(y) ' tavg_' num2str(y)]
    eval(command)
    clear
end

% -------- TMAX

for y = 1979:1:2016
    
    filename = ['Raw_NetCDF_1deg_x_1deg/TMAX/Complete_TMAX_Daily_LatLong1_' num2str(y) '.nc']
    
    longitude = ncread(filename, 'longitude');
    latitude = ncread(filename, 'latitude');
    year = ncread(filename, 'year');
    month = ncread(filename, 'month');
    day_of_month = ncread(filename, 'day');
    day_of_year = ncread(filename, 'day_of_year');
    tmax_anomaly = ncread(filename, 'temperature');
    tmax_climatology = ncread(filename, 'climatology');
    
    data = struct('tmax_anomaly', tmax_anomaly, 'tmax_climatology', tmax_climatology, ...
        'lon',longitude,'lat',latitude, ...
        'year', year,'month', month,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['tmax_' num2str(y) ' = data'];
    eval(command)
    
    clear data latitude longitude month day_of_month day_of_year year tmax_anomaly tmax_climatology 
    
    command = ['save Matlab_1deg_x_1deg/TMAX/Complete_TMAX_Daily_LatLong1_' num2str(y) ' tmax_' num2str(y)]
    eval(command)
    clear
end

% -------- TMIN

for y = 1979:1:2016
    
    filename = ['Raw_NetCDF_1deg_x_1deg/TMIN/Complete_TMIN_Daily_LatLong1_' num2str(y) '.nc']
    
    longitude = ncread(filename, 'longitude');
    latitude = ncread(filename, 'latitude');
    year = ncread(filename, 'year');
    month = ncread(filename, 'month');
    day_of_month = ncread(filename, 'day');
    day_of_year = ncread(filename, 'day_of_year');
    tmin_anomaly = ncread(filename, 'temperature');
    tmin_climatology = ncread(filename, 'climatology');
    
    data = struct('tmin_anomaly', tmin_anomaly, 'tmin_climatology', tmin_climatology, ...
        'lon',longitude,'lat',latitude, ...
        'year', year,'month', month,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['tmin_' num2str(y) ' = data'];
    eval(command)
    
    clear data latitude longitude month day_of_month day_of_year year tmin_anomaly tmin_climatology 
    
    command = ['save Matlab_1deg_x_1deg/TMIN/Complete_TMIN_Daily_LatLong1_' num2str(y) ' tmin_' num2str(y)]
    eval(command)
    clear
end


