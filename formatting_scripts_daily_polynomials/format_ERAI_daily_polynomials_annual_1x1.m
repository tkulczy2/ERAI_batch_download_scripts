% CREATING POLYNOMIALS AT THE GRID CELL BY DAY LEVEL FOR ERA INTERIM TEMPERATURE AND PRECIPITATION DATA

% TAC WRITTEN 1.18.2015
% TAK EDITED 2.04.2016

% NOTE: this code pulls in daily ERA-Interim data formatted by TAK, stored in folder
% 'Volumes/Lab_shared_folder/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg
% and created by scripts in the folder Formatting_scripts_v2

%%

clear
close all
clc
diary('output_era_precip.txt')
%% SET UP

% access norgay from local
%cd '/Volumes/Lab_shared_folder/Datasets/Climate/Berkeley_Earth/'

% access norgay from shackleton
cd '/mnt/norgay/Datasets/Climate/ERA_Interim'

%mkdir Matlab_1deg_x_1deg_polynomials
mkdir Matlab_1deg_x_1deg_polynomials/PRECIP
mkdir Matlab_1deg_x_1deg_polynomials/TAVG
mkdir Matlab_1deg_x_1deg_polynomials/TMAX
mkdir Matlab_1deg_x_1deg_polynomials/TMIN


%% PULL IN DAILY DATA AT 1deg x 1deg RESOLUTION BY THE DECADE, SAVE BY THE DECADE

for v = {'precip', 'tavg', 'tmax', 'tmin'}
var = char(v);
VAR = upper(var);
for base_year = 1979:1:2015

    varyear = [var '_' num2str(base_year)];
    disp(['----------- DECADE BEGINNING ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_1deg_x_1deg/' VAR '/ERAI_DAILY_' VAR '_' num2str(base_year) '.mat'];
    eval(command)
    
    command = ['data_raw = ' varyear];
    eval(command)
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    command = ['data_actual = permute(data_raw.' var ', [2 1 3]);'];
    eval(command) 
    
    if ~strcmp(var, 'precip')
        disp('kelvin-to-celcius conversion')
        data_actual = data_actual - 273.15;
    end
% ----- CHOOSE MAXIMUM POLYNOMIAL DEGREE 
k = 8;
for i = 1:k
    
    disp(['----------- POLYNOMIAL ' num2str(i) ' -----------'])
    
    data_actual_poly = nan(size(data_actual));
    
    for j=1:size(data_actual,3)
        data_actual_poly(:,:,j) = data_actual(:,:,j).^i ;
    end
    
    poly_struct = struct([var '_actual_poly'], data_actual_poly, ...
        'lon', data_raw.lon, 'lat', data_raw.lat, ...
        'year', data_raw.year,'month', data_raw.month,  'day_of_month', data_raw.day_of_month, 'day_of_year', data_raw.day_of_year);
    
    command = [var '_poly_' num2str(i) ' = poly_struct; clear poly_struct'];
    eval(command)
    
    clear data_actual_poly poly_struct
end
    
    command = ['clearvars -except ' var '_poly* var VAR varyear base_year;'];
    eval(command)
    %save decdal files (roughly 800MB each)
    command = ['save Matlab_1deg_x_1deg_polynomials/' VAR '/' varyear '_raw_polynomials'];
    eval(command)
    
end

disp(['----DONE WITH ' VAR ' ----'])
clear;
end
diary('off')