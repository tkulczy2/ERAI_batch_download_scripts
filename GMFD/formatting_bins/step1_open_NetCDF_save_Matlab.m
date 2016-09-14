%%
%   S. HSIANG 5/13/15
%   SCRIPT TO IMPORT AND FORMAT BERKELEY EARTH TEMPERATURE DATA FOR MATLAB

%%

clear
cd '/mnt/norgay/Datasets/Climate/GMFD/'
mkdir Matlab_.25deg_x_.25deg
mkdir Matlab_.25deg_x_.25deg/TMAX
mkdir Matlab_.25deg_x_.25deg/TMIN
mkdir Matlab_.25deg_x_.25deg/TAVG
mkdir Matlab_.25deg_x_.25deg/PRCP

start_year = 1948;
end_year = 2010;
year_inc = 1;

% -------- Native variables

for v = {'tmax', 'tmin', 'prcp'}
var = char(v);
VAR = upper(var);
    for y = start_year:year_inc:end_year
        
        input_filename = ['Raw_NetCDF_.25deg_x_.25deg/' var '_0p25_daily_' num2str(y) '-' num2str(y) '.nc'];
        
        lat = ncread(input_filename, 'latitude');
        lon = ncread(input_filename, 'longitude');
        T = ncread(input_filename, 'time');
        T = double(T) + datenum(y, 1, 1);
        
        data = squeeze(ncread(input_filename, var));
        
        if strcmp(var, 'prcp')
            disp('precipitation rate to quantity conversion')
            data = data * 86400.;
        else
            disp('kelvin-to-celcius conversion')
            data = data - 273.15;
        end
        
        command = [var ' = struct(''' var ''', data, ''T'', T, ''lat'', lat, ''lon'', lon);'];
        eval(command)
        
        % Save to norgay for future processing
        output_filename = ['/mnt/norgay/Datasets/Climate/GMFD/Matlab_.25deg_x_.25deg/' VAR '/GMFD_DAILY_' VAR '_' num2str(y) '.mat'];
        save(output_filename, var, '-v7.3');

    end

command = ['clearvars ' var ';'];
eval(command)
disp(['----DONE WITH ' VAR ' ----'])

end

% -------- Calculate TAVG

for y = start_year:year_inc:end_year
    load(['/mnt/norgay/Datasets/Climate/GMFD/Matlab_.25deg_x_.25deg/TMAX/GMFD_DAILY_TMAX_' num2str(y) '.mat']);
    load(['/mnt/norgay/Datasets/Climate/GMFD/Matlab_.25deg_x_.25deg/TMIN/GMFD_DAILY_TMIN_' num2str(y) '.mat']);
    
    tavg = struct('tavg', (tmax.tmax + tmin.tmin)/2, 'T', tmax.T, 'lat', tmax.lat, 'lon', tmax.lon);
    output_filename = ['/mnt/norgay/Datasets/Climate/GMFD/Matlab_.25deg_x_.25deg/TAVG/GMFD_DAILY_TAVG_' num2str(y) '.mat'];
    save(output_filename, 'tavg', '-v7.3');
end

clear;
