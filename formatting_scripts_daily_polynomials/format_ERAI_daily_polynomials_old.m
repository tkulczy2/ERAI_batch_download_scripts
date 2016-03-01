% CREATING POLYNOMIALS AT THE GRID CELL BY DAY LEVEL FOR BERKELEY EARTH TEMPERATURE DATA

% TAC WRITTEN 1.18.2015
% TAK EDITED 2.04.2016

% NOTE: this code pulls in daily ERA-Interim data formatted by TAK, stored in folder
% 'Volumes/Lab_shared_folder/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg
% and created by scripts in the folder Formatting_scripts_v2

%%

clear
close all
clc

%% SET UP

% access norgay from local
%cd '/Volumes/Lab_shared_folder/Datasets/Climate/Berkeley_Earth/'

% access norgay from shackleton
cd '/mnt/norgay/Datasets/Climate/ERA_Interim'

mkdir Matlab_1deg_x_1deg_polynomials
mkdir Matlab_1deg_x_1deg_polynomials/PRECIP
mkdir Matlab_1deg_x_1deg_polynomials/TAVG
mkdir Matlab_1deg_x_1deg_polynomials/TMAX
mkdir Matlab_1deg_x_1deg_polynomials/TMIN

% ----- CHOOSE MAXIMUM POLYNOMIAL DEGREE 
k = 8;

%% PULL IN DAILY TEMPERATURE DATA AT 1deg x 1deg RESOLUTION BY THE DECADE, SAVE BY THE DECADE

% -------- PRECIP

for base_year = 1979:1:2015

    disp(['----------- DECADE BEGINNING ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_1deg_x_1deg/PRECIP/ERAI_DAILY_PRECIP_' num2str(base_year) '.mat'];
    eval(command)
    
    command = ['data_raw = precip'];
    eval(command);
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    data_actual = permute(data_raw.precip, [2 1 3]); 
    
% lat and lon values
lat = data_raw.lat;
lon = data_raw.lon;
years = year(data_raw.T);
months = month(data_raw.T);
day_of_month = day(data_raw.T);
day_of_year = datenum(data_raw.T) - datenum(years(1),1,1) + 1;

for i = 1:k
    
    disp(['----------- POLYNOMIAL ' num2str(i) ' -----------'])
    
    data_actual_poly = nan(size(data_actual));
    
    for j=1:size(data_actual,3)
        data_actual_poly(:,:,j) = data_actual(:,:,j).^i ;
    end
    
    poly_struct = struct('precip_actual_poly', data_actual_poly, ...
        'lon', lon, 'lat', lat, ...
        'year', years,'month', months,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['precip_poly_' num2str(i) ' = poly_struct; clear poly_struct'];
    eval(command)
    
    clear data_actual_poly poly_struct
end
    
    clear data_actual* data_raw command* ans i j d S
    command = ['clear data_' num2str(base_year)];
    eval(command)
    clear command
    %save decdal files (roughly 80MB each)
    command = ['save Matlab_1deg_x_1deg_polynomials/PRECIP/precip_' num2str(base_year) '_raw_polynomials'];
    eval(command)
    
    
end

disp('----DONE WITH PRECIP ----')

%% PULL IN TAVG, COMPUTE POLYNOMIALS, SAVE BY DECADE
clear; k=8;

% -------- TAVG

for base_year = 1979:1:2015

    disp(['----------- DECADE BEGINNING ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_1deg_x_1deg/TAVG/ERAI_DAILY_TAVG_' num2str(base_year) '.mat'];
    eval(command)
    
    command = ['data_raw = tavg'];
    eval(command);
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    data_actual = permute(data_raw.tavg, [2 1 3]); 
    data_actual = data_actual - 273.15;

% lat and lon values
lat = data_raw.lat;
lon = data_raw.lon;
years = year(data_raw.T);
months = month(data_raw.T);
day_of_month = day(data_raw.T);
day_of_year = datenum(data_raw.T) - datenum(years(1),1,1) + 1;

for i = 1:k
    
    disp(['----------- POLYNOMIAL ' num2str(i) ' -----------'])
    
    data_actual_poly = nan(size(data_actual));
    
    for j=1:size(data_actual,3)
        data_actual_poly(:,:,j) = data_actual(:,:,j).^i ;
    end
    
    poly_struct = struct('tavg_actual_poly', data_actual_poly, ...
        'lon', lon, 'lat', lat, ...
        'year', years,'month', months,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['tavg_poly_' num2str(i) ' = poly_struct; clear poly_struct'];
    eval(command)
    
    clear data_actual_poly poly_struct
end
    
    clear data_actual* data_raw command* ans i j d S
    command = ['clear data_' num2str(base_year)];
    eval(command)
    clear command
    %save decdal files (roughly 80MB each)
    command = ['save Matlab_1deg_x_1deg_polynomials/TAVG/tavg_' num2str(base_year) '_raw_polynomials'];
    eval(command)
    
    
end

disp('----DONE WITH TAVG ----')

%% PULL IN TMAX, COMPUTE POLYNOMIALS, SAVE BY DECADE
clear; k=8;

% -------- TMAX

for base_year = 1979:1:2015

    disp(['----------- DECADE BEGINNING ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_1deg_x_1deg/TMAX/ERAI_DAILY_TMAX_' num2str(base_year) '.mat'];
    eval(command)
    
    command = ['data_raw = tmax'];
    eval(command);
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    data_actual = permute(data_raw.tmax, [2 1 3]); 
    data_actual = data_actual - 273.15;
    
% lat and lon values
lat = data_raw.lat;
lon = data_raw.lon;
years = year(data_raw.T);
months = month(data_raw.T);
day_of_month = day(data_raw.T);
day_of_year = datenum(data_raw.T) - datenum(years(1),1,1) + 1;

for i = 1:k
    
    disp(['----------- POLYNOMIAL ' num2str(i) ' -----------'])
    
    data_actual_poly = nan(size(data_actual));
    
    for j=1:size(data_actual,3)
        data_actual_poly(:,:,j) = data_actual(:,:,j).^i ;
    end
    
    poly_struct = struct('tmax_actual_poly', data_actual_poly, ...
        'lon', lon, 'lat', lat, ...
        'year', years,'month', months,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['tmax_poly_' num2str(i) ' = poly_struct; clear poly_struct'];
    eval(command)
    
    clear data_actual_poly poly_struct
end
    
    clear data_actual* data_raw command* ans i j d S
    command = ['clear data_' num2str(base_year)];
    eval(command)
    clear command
    %save decdal files (roughly 80MB each)
    command = ['save Matlab_1deg_x_1deg_polynomials/TMAX/tmax_' num2str(base_year) '_raw_polynomials'];
    eval(command)
    
    
end

disp('----DONE WITH TMAX ----')

%% PULL IN TMIN, COMPUTE POLYNOMIALS, SAVE BY DECADE
clear; k=8;

for base_year = 1979:1:2015

    disp(['----------- DECADE BEGINNING ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_1deg_x_1deg/TMIN/ERAI_DAILY_TMIN_' num2str(base_year) '.mat'];
    eval(command)
    
    command = ['data_raw = tmin'];
    eval(command);
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    data_actual = permute(data_raw.tmin, [2 1 3]); 
    data_actual = data_actual - 273.15;
    
% lat and lon values
lat = data_raw.lat;
lon = data_raw.lon;
years = year(data_raw.T);
months = month(data_raw.T);
day_of_month = day(data_raw.T);
day_of_year = datenum(data_raw.T) - datenum(years(1),1,1) + 1;

for i = 1:k
    
    disp(['----------- POLYNOMIAL ' num2str(i) ' -----------'])
    
    data_actual_poly = nan(size(data_actual));
    
    for j=1:size(data_actual,3)
        data_actual_poly(:,:,j) = data_actual(:,:,j).^i ;
    end
    
    poly_struct = struct('tmin_actual_poly', data_actual_poly, ...
        'lon', lon, 'lat', lat, ...
        'year', years,'month', months,  'day_of_month', day_of_month, 'day_of_year',  day_of_year);
    
    command = ['tmin_poly_' num2str(i) ' = poly_struct; clear poly_struct'];
    eval(command)
    
    clear data_actual_poly poly_struct
end
    
    clear data_actual* data_raw command* ans i j d S
    command = ['clear data_' num2str(base_year)];
    eval(command)
    clear command
    %save decdal files (roughly 80MB each)
    command = ['save Matlab_1deg_x_1deg_polynomials/TMIN/tmin_' num2str(base_year) '_raw_polynomials'];
    eval(command)
    
    
end

disp('----DONE WITH TMIN ----')

%%

disp('----DONE WITH PRECIP, TAVG, TMAX, TMIN----')
