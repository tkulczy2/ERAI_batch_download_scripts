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

for v = {'tmax', 'tmin', 'prate', 'q2m'}
var = char(v);
VAR = upper(var);
    for y = 1979:1:2010
        
        % read monthly grib files (maybe add step 0)
        for m = 1:12
        
        filename = ['Raw_GRIB2_T382_Gaussian/'+var+'/'+var+'.gdas.'+yearmm+'.grb2']
        nc=ncgeodataset(filename);
        % need to change this depending on var
        varname = 'Maximum_temperature_height_above_ground_Mixed_intervals_Interval';
        s = nc.size(varname);
        data = nan(s(1),s(3),s(4));
        for i = 1:s(1)
            slice = double(squeeze(nc{varname}(i,:,:,:)));
            data(i,:,:) = slice;
        end
        data = double(squeeze(data));
        latitude = double(nc{'lat'}(:));
        longitude = double(nc{'lon'}(:));
        t = nc.variable('time');
        mdate = datenum(y,m,1,0,0,0) + double(t.data(:))/24;
        end
        
        year = year(mdate);
        month = month(mdate);
        
        % old commands
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
        
        
        
        varyear = [var '_' num2str(y)];
        disp(['----------- YEAR ' num2str(y) ' -----------'])

        command = ['load Matlab_.25deg_x_.25deg/' VAR '/ERAI_DAILY_' VAR '_' num2str(y) '.mat'];
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



for y = 1979:1:2010
    
    
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


