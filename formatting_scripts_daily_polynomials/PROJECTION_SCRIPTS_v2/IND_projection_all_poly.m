
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
%CLIM = 'BEST';
if strcmp(CLIM, 'ERAI')
    climateDir = 'ERA_Interim';
elseif strcmp(CLIM, 'BEST')
    climateDir = 'Berkeley_Earth';
end
%obtain shapefile
sample = 'IND';
shapeDir = ['/mnt/norgay/Datasets/SHAPEFILES/' sample '/' sample '_adm'];
shapeFile = [sample '_adm1.shp'];

% Sol's machine
%cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/BRA

% Tamma - Shackleton: call shapefiles stored on Norgay
command = ['cd ' shapeDir];
eval(command)

[s,a] = shaperead(shapeFile,'UseGeoCoords', true); 
%% Sample specific instructions here

% Tamma-Shackleton: change directory to store output files on Norgay
baseDir = ['/mnt/norgay/Datasets/Climate/' climateDir];
command = ['cd ' baseDir '/Matlab_projected_DAILY_polynomials'];
eval(command) 

outputDir = [sample '_daily_' CLIM '_polynomials_.25deg'];

command = ['mkdir ' outputDir];
eval(command)
command = ['cd ' outputDir];
eval(command)
label = 'NAME_1';


for sample_first_year = 1990:1999
    
    for var = {'precip'}%,'tavg','tmax','tmin'}
        command = ['load ' baseDir '/Matlab_.25deg_x_.25deg_polynomials/' upper(char(var)) '/' char(var) '_' num2str(sample_first_year) '_raw_polynomials;'];
        eval(command) 
    end

    % Choose a max. polynomial power
    maxpower = 5;

    %%
    N = length(s);
    density = 1; %1 degree resolution
    % CAUTION - I'M DROPPING THE -90 LATITUDE OBSERVATION AND SHIFTING BY 0.5 DEGREES TO CONFORM WITH BEST WEIGHT GRID
    % lat = flip(precip_poly_1.lat(1:end-1)-0.5);
    % lon = precip_poly_1.lon;
    % ixlon = find(lon==180);
    % lon = [-360+lon(ixlon:end); lon(1:ixlon-1)] + 0.5;
    lat = precip_poly_1.lat;
    lon = precip_poly_1.lon;
    latlim = double([lat(1) lat(end)]);
    lonlim = double([lon(1) lon(end)]);

    %%
    % cross sectional data for weighting BEST data
    load '/mnt/norgay/Computation/sol_matlab_toolbox/global_data/population_BEST'
    load '/mnt/norgay/Computation/sol_matlab_toolbox/global_data/crops_BEST'

    % make an ID map set (works well for fewer than 150 districts)
    ID = generate_ID_maps_par(s, a, label, density, latlim, lonlim);
    N = length(ID.ID);

    %vectorize these ID maps into I and J locations in the array
    %entries hold the vectors describing the row and col of cell in the polygon
    ID_I = cell(N,1);
    ID_J = cell(N,1);

    %get indicies of maps, store in a structure that is N large
    for n = 1:N
        [I,J] = find(ID.masks(:,:,n)==1);
        ID_I{n} = I;
        ID_J{n} = J; 
    end

    %% loop through three temp variables, three polynomials, and output three weights for each temp measure

    tic
    for power=1:maxpower % these are polynomial powers
    T = 4; % 1 is tavg, 2 is tmax, 3 is tmin

    if T == 1
        command = ['temp_actual = tavg_poly_' num2str(power) '.tavg_actual_poly;'];
        eval(command)
        var = 'tavg';
    elseif T == 2
        command = ['temp_actual = tmax_poly_' num2str(power) '.tmax_actual_poly;'];
        eval(command)
        var = 'tmax';
    elseif T == 3
        command = ['temp_actual = tmin_poly_' num2str(power) '.tmin_actual_poly;'];
        eval(command)
        var = 'tmin';
    elseif T == 4
        % CAUTION - I'M DROPPING THE -90 LATITUDE DATA TO CONFORM WITH BEST GRID
        %command = ['temp_actual = cat(2, precip_poly_' num2str(power) '.precip_actual_poly(1:end-1,ixlon:end,:), precip_poly_' num2str(power) '.precip_actual_poly(1:end-1,1:ixlon-1,:));'];
        %eval(command)
        %command = ['temp_actual = flip(temp_actual, 1);'];
        command = ['temp_actual = precip_poly_' num2str(power) '.precip_actual_poly;'];
        eval(command)
        var = 'precip';
    end

    %generate the output table with headers and dates, columns are districts
    %and date variables

    command = ['total_days = size(' var '_poly_1.' var '_actual_poly,3);'];
    eval(command)
    output_area = cell(total_days+1,N+3);
    output_area(1,1:N) = ID.ID'; %header for first row are names of districts
    output_area{1,N+1} = 'day'; %headers
    output_area{1,N+2} = 'month'; %headers
    output_area{1,N+3} = 'year'; %headers

    command = ['output_area(2:end, N+1) = mat2cell(' var '_poly_' num2str(power) '.day_of_month,ones(total_days,1),1);'];
    eval(command)
    command = ['output_area(2:end, N+2) = mat2cell(' var '_poly_' num2str(power) '.month,ones(total_days,1),1);'];
    eval(command)
    command = ['output_area(2:end, N+3) = mat2cell(' var '_poly_' num2str(power) '.year,ones(total_days,1),1);'];
    eval(command)

    output_pop = output_area;
    output_crop = output_area;


    %loop to construct a matrix that is pixel-by-day for each district
    for n = 1:N

        %disp(['---- constructing output for ' ID.ID{n} ': ' num2str(n) ' of ' num2str(N) '----'])

        % create and fill in array that is days by pixels
        daily_pixel_temp = nan(total_days,length(ID_I{n}));

        for i = 1:length(ID_I{n})
            daily_pixel_temp(:,i) = temp_actual(ID_I{n}(i),ID_J{n}(i),:);
        end

        %generate a flag for any pixel that is nans for the entire sample
        nan_flags = (sum(isnan(daily_pixel_temp),1)==total_days)';

        %set missing obs to large number, will be killed by zero weight if
        %systemmatically missing
        daily_pixel_temp(isnan(daily_pixel_temp)) = 999999;

        %construct weighting vectors
        pixel_area_weights = ones(length(ID_I{n}),1);
        pixel_pop_weights = ones(length(ID_I{n}),1);
        pixel_crop_weights = ones(length(ID_I{n}),1);

        for i = 1:length(ID_I{n})
            pixel_area_weights(i) = cosd(lat(ID_I{n}(i)));
            pixel_pop_weights(i) = population_total_BEST.total_2000(ID_I{n}(i),ID_J{n}(i));
            pixel_crop_weights(i) = crop_fraction_BEST.total_2000(ID_I{n}(i),ID_J{n}(i));
        end

        %normalize weights and kill any pixels with missing data flag
        pixel_area_weights = pixel_area_weights/sum(pixel_area_weights).*(1-nan_flags);
        pixel_pop_weights = pixel_pop_weights/sum(pixel_pop_weights).*(1-nan_flags);
        pixel_crop_weights = pixel_crop_weights/sum(pixel_crop_weights).*(1-nan_flags);

        %matrix multiply day-by-pixel matrix by weights to get vector of
        %weighted means
        daily_mean_temps_area_weight = daily_pixel_temp*pixel_area_weights;
        daily_mean_temps_pop_weight = daily_pixel_temp*pixel_pop_weights;
        daily_mean_temps_crop_weight = daily_pixel_temp*pixel_crop_weights;

        %output daily vector as a column in output table
        output_area(2:end, n) = mat2cell(daily_mean_temps_area_weight,ones(total_days,1),1);
        output_pop(2:end, n) = mat2cell(daily_mean_temps_pop_weight,ones(total_days,1),1);
        output_crop(2:end, n) = mat2cell(daily_mean_temps_crop_weight,ones(total_days,1),1);

        %toc
    end

    %output
    cell2table2csv(output_area, [sample '_' num2str(sample_first_year) '_daily_' var '_area_weights_poly_' num2str(power)])
    cell2table2csv(output_pop, [sample  '_' num2str(sample_first_year) '_daily_' var '_pop_weights_poly_' num2str(power)])
    cell2table2csv(output_crop, [sample  '_' num2str(sample_first_year) '_daily_' var '_crop_weights_poly_' num2str(power)])

    disp(['-----------------------------finished with ' var ' for polynomial power ' num2str(power)])

    %end % close the tavg, tmax, tmin loop 

    disp(['-----------------------------finished with polynomial power ' num2str(power)])

    end % close polynomial power loop
    disp(['-----------------------------finished with year ' num2str(sample_first_year)])
end
disp('----DONE----')
toc








