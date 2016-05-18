%%
%   S. HSIANG 5/22/15
%   SCRIPT TO OPEN AND SAVE BIN SPECIFIC FILES FOR THE COMPLETE TIME PERIOD


%%

cd '/mnt/norgay/Datasets/Climate/ERA_Interim/'
mkdir Matlab_4d_stack_by_temp_bin
mkdir Matlab_4d_stack_by_temp_bin/TAVG
mkdir Matlab_4d_stack_by_temp_bin/PRECIP

%%



tic
clear
total_years = (2015-1978);

%--------------------------------------------
%-----------interior bins -40C to 34C

%for T = -3:3  
%for T = -41:-39
%for T = 33:35

for v = {'precip'}
% for v = {'tavg','precip'}
    var = char(v);
    VAR = upper(var);

    if strcmp(var, 'precip')
        bot_bin = 5;
        top_bin = 200;
        inc = 5;
        unit = 'mm';
    else
        bot_bin = -40.;
        top_bin = 35.;
        inc = 1;
        unit = 'C';
    end


    for T = bot_bin-inc:inc:top_bin %complete sample
        disp(['----------- bin: ' num2str(T) unit])

        % define variable and file names based on bin
        if T==(bot_bin-inc) %bottom bin
            varname = ['bin_nInf_' strrep(num2str(T+inc),'-','n') unit '_mask_monthly'];
            new_varname = [var '_bin_nInf_' strrep(num2str(T+inc),'-','n') unit '_daily_count_monthly'];
            new_filename = [var '_bin_nInf_' strrep(num2str(T+inc),'-','n') unit '_ERAI_1979_2015'];
        elseif T==top_bin %top bin
            varname = ['bin_' num2str(T) unit '_Inf_mask_monthly'];
            new_varname = [var '_bin_' num2str(T) unit '_Inf_daily_count_monthly'];
            new_filename = [var '_bin_' num2str(T) unit '_Inf_ERAI_1979_2015'];
        else
            varname = ['bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_mask_monthly'];
            new_varname = [var '_bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_daily_count_monthly'];
            new_filename = [var '_bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_ERAI_1979_2015'];
        end

        %create a large monthly array to encompass all years in the dataset
        %(for a specific temp bin)
        monthly_field_all = nan(180, 360, total_years, 12);
        year = nan(total_years, 1);
        month = [1:12]';

        %add specific decades of data to the complete montly stack

        %----------complete decades of data
        for y = 1979:1:2015

            disp(['decade: ' num2str(y)])
            command = ['load Matlab_4d_stack_by_decade/' VAR '/' var '_' num2str(y) '_raw_bin_counts ' varname];
            eval(command)
            command = ['data = ' varname ';'];
            eval(command)


            i1 = (y-1979)+1;
            %i2 = (y-1880)+10;

            monthly_field_all(:,:,i1,:) = data.monthly_field;
            year(i1) = data.year;

        end

        lat = data.lat;
        lon = data.lon;
        new_data = struct('monthly_field', monthly_field_all,'lat', lat, 'lon', lon, 'year', year,'month', month)

        %save a single 4D stack field describing a single temperature bin for
        %the entire time series

        command = [new_varname ' = new_data;'];
        eval(command)
        command = ['save(''Matlab_4d_stack_by_temp_bin/' VAR '/' new_filename ''', ''' new_varname ''', ''-v7.3'');' ];
        eval(command)

        clearvars y year tavg_* month* i1 lat lon command bin_* data new_* varname

    end

    clearvars T total_years
end
disp('-----------DONE------------')
toc

