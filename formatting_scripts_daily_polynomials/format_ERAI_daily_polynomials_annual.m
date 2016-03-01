% CREATING POLYNOMIALS AT THE GRID CELL BY DAY LEVEL FOR ERA INTERIM TEMPERATURE AND PRECIPITATION DATA

% TAC WRITTEN 1.18.2015
% TAK EDITED 2.04.2016

% NOTE: this code pulls in daily ERA-Interim data formatted by TAK, stored in folder
% 'Volumes/Lab_shared_folder/Datasets/Climate/ERA_Interim/Matlab_.25deg_x_.25deg
% and created by scripts in the folder Formatting_scripts_v2

%%

clear
close all
clc
diary('output_era_precip_.25deg.txt')
%% SET UP

% access norgay from local
%cd '/Volumes/Lab_shared_folder/Datasets/Climate/Berkeley_Earth/'

% access norgay from shackleton
cd '/mnt/norgay/Datasets/Climate/ERA_Interim'

mkdir Matlab_.25deg_x_.25deg_polynomials
mkdir Matlab_.25deg_x_.25deg_polynomials/PRECIP
mkdir Matlab_.25deg_x_.25deg_polynomials/TAVG
mkdir Matlab_.25deg_x_.25deg_polynomials/TMAX
mkdir Matlab_.25deg_x_.25deg_polynomials/TMIN


%% PULL IN DAILY DATA AT .25deg x .25deg RESOLUTION BY THE YEAR, SAVE BY THE YEAR

for v = {'precip', 'tavg', 'tmax', 'tmin'}
var = char(v);
VAR = upper(var);
    for base_year = 1979:1:2015

        varyear = [var '_' num2str(base_year)];
        disp(['----------- YEAR ' num2str(base_year) ' -----------'])

        command = ['load Matlab_.25deg_x_.25deg/' VAR '/ERAI_DAILY_' VAR '_' num2str(base_year) '.mat'];
        eval(command)

        command = ['data_raw = ' var];
        eval(command)

        %transposing each layer of stack since Berkeley EARTH data is transposed
        command = ['data_actual = permute(data_raw.' var ', [2 1 3]);'];
        eval(command)

        % Get index of points corresponding to 1x1 grid cells
        ixlat = find(mod(data_raw.lat,0.5)==0 & mod(data_raw.lat,1)~=0);
        ixlon = find(mod(data_raw.lon,0.5)==0 & mod(data_raw.lon,1)~=0);

        % Filter to get 1x1 grid cells
        data_actual = data_actual(ixlat,ixlon,:);
        lat = data_raw.lat(ixlat);
        lon = data_raw.lon(ixlon) - 360.*(data_raw.lon(ixlon)>180); % make longitudes > 180 negative
        % Reorder latitude
        data_actual = flip(data_actual, 1);
        lat = flip(lat);
        % Reorder longitude
        data_actual = cat(2, data_actual(:,lon<0,:), data_actual(:,lon>0,:));
        lon = [lon(lon<0); lon(lon>0)];

        % Generate time variables
        yr = year(data_raw.T);
        mo = month(data_raw.T);
        dom = day(data_raw.T);
        doy = datenum(data_raw.T) - datenum(year(data_raw.T),1,1) + 1;

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
                'lon', lon, 'lat', lat, ...
                'year', yr,'month', mo,  'day_of_month', dom, 'day_of_year', doy);

            command = [var '_poly_' num2str(i) ' = poly_struct; clear poly_struct'];
            eval(command)

            clear data_actual_poly poly_struct
        end

        command = ['clearvars -except ' var '_poly* var VAR varyear base_year;'];
        eval(command)
        %save decdal files (roughly 800MB each)
        command = ['save Matlab_.25deg_x_.25deg_polynomials/' VAR '/' varyear '_raw_polynomials'];
        eval(command)

    end

disp(['----DONE WITH ' VAR ' ----'])
clear;
end
diary('off')