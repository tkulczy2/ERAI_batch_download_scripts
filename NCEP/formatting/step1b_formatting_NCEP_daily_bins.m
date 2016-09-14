%%

clear
%access norgay from local
%cd '/Volumes/Lab_shared_folder/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2'

% access norgay from shackleton
cd '/mnt/norgay/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2'
load formatted/NCEP_CDAS1_TEMP_1_Jan_1948_to_31_Dec_2014
mkdir 'Matlab_4d_stack_by_temp_bin'
mkdir 'Matlab_4d_stack_by_temp_bin/TAVG'

%% COMPUTE BINNED MEASURES THAT WILL BE USED IN PROJECTION SCRIPTS

temp_all = temp_all - 273.15;

var = 'tavg';
bot_bin = -40.;
top_bin = 35.;
inc = 1;
unit = 'C';

% total_years = size(bin_nInf_n40C_mask_monthly.annual_field,3);
total_years = 2015 - 1948;

for T = bot_bin-inc:inc:top_bin %complete sample
    disp(['----------- bin: ' num2str(T) unit])

    % define variable and file names based on bin
    if T==(bot_bin-inc) %bottom bin
        bin_mask_daily = (temp_all<bot_bin);
        varname = ['bin_nInf_' strrep(num2str(T+inc),'-','n') unit '_mask_monthly'];
        new_varname = [var '_bin_nInf_' strrep(num2str(T+inc),'-','n') unit '_daily_count_monthly'];
        new_filename = [var '_bin_nInf_' strrep(num2str(T+inc),'-','n') unit '_NCEP_1948_2014'];
    elseif T==top_bin %top bin
        bin_mask_daily = (temp_all>=top_bin);
        varname = ['bin_' num2str(T) unit '_Inf_mask_monthly'];
        new_varname = [var '_bin_' num2str(T) unit '_Inf_daily_count_monthly'];
        new_filename = [var '_bin_' num2str(T) unit '_Inf_NCEP_1948_2014'];
    else
        bin_mask_daily = (temp_all>=T & temp_all<T+inc);
        varname = ['bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_mask_monthly'];
        new_varname = [var '_bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_daily_count_monthly'];
        new_filename = [var '_bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_NCEP_1948_2014'];
    end
    
    command = [varname ' = monthify_stack_sum(lat, lon, [1:size(temp_all,3)], bin_mask_daily, 1948);' ];
    eval(command)

%% NATIVE FORMAT FOR NCEP IS FLIPPED UPSIDEDOWN AND CENTERED ON PACIFIC

    command = [varname '.annual_field = cat(2,' varname '.annual_field(:,97:end,:), ' varname '.annual_field(:,1:96,:));'];
    eval(command)
    command = [varname '.monthly_field = cat(2,' varname '.monthly_field(:,97:end,:,:), ' varname '.monthly_field(:,1:96,:,:));'];
    eval(command)
    command = [varname '.lon = cat(1,' varname '.lon(97:end)-360, ' varname '.lon(1:96));'];
    eval(command)
    
    % flipping about equator so properly oriented
    command = [varname '.lat = flipud(' varname '.lat);'];
    eval(command)
    for y = 1:total_years
        command = [varname '.annual_field(:,:,y) = flipud(' varname '.annual_field(:,:,y));'];
        eval(command)
        for m = 1:12
            command =[varname '.monthly_field(:,:,y,m) = flipud(' varname '.monthly_field(:,:,y,m));'];
            eval(command)
        end
    end
    
    command = [new_varname ' = ' varname ';'];
    eval(command)
    
    command = ['save(''Matlab_4d_stack_by_temp_bin/TAVG/' new_filename ''', ''' new_varname ''', ''-v7.3'');' ];
    eval(command)
    
    command = ['clearvars ' varname ' ' new_varname ';'];
    eval(command)
end

% clear
