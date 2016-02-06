%%
%   S. HSIANG 5/22/15
%   SCRIPT TO OPEN AND SAVE BIN SPECIFIC FILES FOR THE COMPLETE TIME PERIOD


%%

cd '/mnt/norgay/Datasets/Climate/ERA-Interim/'
mkdir Matlab_4d_stack_by_temp_bin
mkdir Matlab_4d_stack_by_temp_bin/TAVG

%%



tic
clear
total_years = (2012-1879);

%--------------------------------------------
%-----------interior bins -40C to 34C

%for T = -3:3  
%for T = -41:-39
%for T = 33:35

for T = -41:35 %complete sample
    disp(['-----------temp bin: ' num2str(T)])
    
    % define variable and file names based on bin
    if T==-41 %bottom bin
        varname = 'bin_nInf_n40C_mask_monthly';
        new_varname = ['tavg_bin_nInf_n40C_daily_count_monthly'];
        new_filename = ['tavg_bin_nInf_n40C_BEST_1880_2012'];
    elseif T ==35 %top bin
        varname = 'bin_35C_Inf_mask_monthly';
        new_varname = ['tavg_bin_35C_Inf_daily_count_monthly'];
        new_filename = ['tavg_bin_35C_Inf_BEST_1880_2012'];
    elseif T<-1
        varname = ['bin_n' num2str(abs(T)) 'C_n' num2str(abs(T+1)) 'C_mask_monthly'];
        new_varname = ['tavg_bin_n' num2str(abs(T)) 'C_n' num2str(abs(T+1)) 'C_daily_count_monthly'];
        new_filename = ['tavg_bin_n' num2str(abs(T)) 'C_n' num2str(abs(T+1)) 'C_BEST_1880_2012'];
    elseif T == -1
        varname = ['bin_n1_0_mask_monthly'];
        new_varname = ['tavg_bin_n1C_0C_daily_count_monthly']; %in earlier steps, lost celsius C in var names
        new_filename = ['tavg_bin_n1C_0C_BEST_1880_2012'];
    else
        varname = ['bin_' num2str(T) 'C_' num2str(T+1) 'C_mask_monthly'];
        new_varname = ['tavg_bin_' num2str(T) 'C_' num2str(T+1) 'C_daily_count_monthly'];
        new_filename = ['tavg_bin_' num2str(T) 'C_' num2str(T+1) 'C_BEST_1880_2012'];
    end
    
    %create a large monthly array to encompass all years in the dataset
    %(for a specific temp bin)
    monthly_field_all = nan(180, 360, total_years, 12);
    year = nan(total_years, 1);
    month = [1:12]';
    
    %add specific decades of data to the complete montly stack
    
    %----------complete decades of data
    for y = 1880:10:2000
        
        disp(['decade: ' num2str(y)])
        command = ['load Matlab_4d_stack_by_decade/TAVG/tavg_' num2str(y) '_raw_bin_counts ' varname];
        eval(command)
        command = ['data = ' varname ';'];
        eval(command)
        
        
        i1 = (y-1880)+1;
        i2 = (y-1880)+10;
        
        monthly_field_all(:,:,i1:i2,:) = data.monthly_field;
        year(i1:i2) = data.year;
        
    end
    
    %-----------2010-2012
    disp(['decade: 2010'])
    command = ['load Matlab_4d_stack_by_decade/TAVG/tavg_2010_raw_bin_counts ' varname];
    eval(command)
    command = ['data = ' varname ';'];
    eval(command)
    
    monthly_field_all(:,:,end-2:end,:) = data.monthly_field;
    year(end-2:end) = data.year;
    
    lat = data.lat;
    lon = data.lon;
    new_data = struct('monthly_field', monthly_field_all,'lat', lat, 'lon', lon, 'year', year,'month', month)
    
    %save a single 4D stack field describing a single temperature bin for
    %the entire time series
    
    command = [new_varname ' = new_data;'];
    eval(command)
    command = ['save Matlab_4d_stack_by_temp_bin/TAVG/' new_filename ' ' new_varname];
    eval(command)

    clear y year tavg_* month* i* lat lon command bin_* data new_* varname
    
end

clear T total_years

disp('-----------DONE------------')
toc

