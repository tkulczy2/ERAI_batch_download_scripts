%%
%   S. HSIANG 5/22/15
%   SCRIPT TO FORMAT BERKELEY EARTH TEMP DATA INTO BINNED DEGREE STACKS FOR
%   USE IN PROJECTION SCRIPTS

%%

cd '/mnt/norgay/Datasets/Climate/ERA-Interim/'
mkdir Matlab_4d_stack_by_decade
mkdir Matlab_4d_stack_by_decade/TAVG
mkdir Matlab_4d_stack_by_decade/PRECIP

grid = '1deg_x_1deg';


%{
for base_year = 1979:1:2016

    clear bin_* command

    disp(['----------- YEAR ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_' grid '/TAVG/ERAI_DAILY_TAVG_' num2str(base_year) '.mat'];
    eval(command)
    
    %command = ['tavg_raw = tavg_' num2str(base_year)];
    command = ['tavg_raw = tavg'];
    eval(command);
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    S = size(tavg_raw.tavg_anomaly);
    tavg_actual =  nan(S(2), S(1), S(3));
    
    % NO LONGER NEED TO ADD ANOM+CLIM BECAUSE ERA-I DATA ARE ABSOLUTE, BUT CHECK SHAPE AFTER THIS STEP
    for i = 1:S(3)
        if tavg_raw.month(i) ~= 2 || tavg_raw.day_of_month(i) ~= 29
            d = tavg_raw.day_of_year(i);
            tavg_actual(:,:,i) = tavg_raw.tavg_anomaly(:,:,i)' + tavg_raw.tavg_climatology(:,:,d)';
        else
            %on leap days, assign Feb 29 climatology of March 1
            %(Feb 29 is 60th day of year)
            tavg_actual(:,:,i) = tavg_raw.tavg_anomaly(:,:,i)' + tavg_raw.tavg_climatology(:,:,60)';
            disp(['year ' num2str(tavg_raw.year(i)) ' is a leap year'])
        end
    end
    
    %lowest bin
    disp(['------------T < -40C'])
    bin_mask_daily = (tavg_actual<-40);
    command = ['bin_nInf_n40C_mask_monthly = monthify_stack_sum(tavg_raw.lat, tavg_raw.lon, [1:size(tavg_actual,3)], bin_mask_daily,' num2str(base_year) ');' ];
    eval(command)
    
    %highest bin
    disp(['------------T >= 35C'])
    bin_mask_daily = (tavg_actual>=35);
    command = ['bin_35C_Inf_mask_monthly = monthify_stack_sum(tavg_raw.lat, tavg_raw.lon, [1:size(tavg_actual,3)], bin_mask_daily,' num2str(base_year) ');'];
    eval(command)
    
    %all other bins
   for T = -40:34
%        for T = -10:-8
        
        disp(['------------T = ' num2str(T) 'C'])
        bin_mask_daily = (tavg_actual>=T & tavg_actual<T+1);
        if T<-1
            command_1 = ['bin_n' num2str(abs(T)) 'C_n' num2str(abs(T+1)) 'C_mask_monthly'];
        elseif T == -1
            command_1 = ['bin_n1_0_mask_monthly'];
        else
            command_1 = ['bin_' num2str(T) 'C_' num2str(T+1) 'C_mask_monthly'];
        end
        command_2 = ['= monthify_stack_sum(tavg_raw.lat, tavg_raw.lon, [1:size(tavg_actual,3)], bin_mask_daily, ' num2str(base_year) ');'];
        eval([command_1 command_2])
        
    end
    
    
    
    clear tavg_* command* T bin_mask_daily ans i d S
    %save decdal files (roughly 80MB each)
    command = ['save Matlab_4d_stack_by_decade/TAVG/tavg_' num2str(base_year) '_raw_bin_counts'];
    eval(command)
    
    
end
%}

for base_year = 1979:1:2015
    clear bin_* command

    disp(['----------- YEAR ' num2str(base_year) ' -----------'])
    
    command = ['load Matlab_' grid '/PRECIP/ERAI_DAILY_PRECIP_' num2str(base_year) '.mat'];
    eval(command)
    
    %command = ['tavg_raw = tavg_' num2str(base_year)];
    command = ['tavg_raw = precip'];
    eval(command);
    
    %transposing each layer of stack since Berkeley EARTH data is transposed
    %S = size(tavg_raw.tavg_anomaly);
    %tavg_actual =  nan(S(2), S(1), S(3));
    tavg_actual = permute(tavg_raw.precip, [2 1 3]);
    
    % NO LONGER NEED TO ADD ANOM+CLIM BECAUSE ERA-I DATA ARE ABSOLUTE, BUT CHECK SHAPE AFTER THIS STEP
%{
    for i = 1:S(3)
        if tavg_raw.month(i) ~= 2 || tavg_raw.day_of_month(i) ~= 29
            d = tavg_raw.day_of_year(i);
            tavg_actual(:,:,i) = tavg_raw.tavg_anomaly(:,:,i)' + tavg_raw.tavg_climatology(:,:,d)';
        else
            %on leap days, assign Feb 29 climatology of March 1
            %(Feb 29 is 60th day of year)
            tavg_actual(:,:,i) = tavg_raw.tavg_anomaly(:,:,i)' + tavg_raw.tavg_climatology(:,:,60)';
            disp(['year ' num2str(tavg_raw.year(i)) ' is a leap year'])
        end
    end
%}    
    % NEED TO DETERMINE CORRECT BINNING SCHEME FOR PRECIP
    %lowest bin
    disp(['------------T < -40C'])
    bin_mask_daily = (tavg_actual<-40);
    command = ['bin_nInf_n40C_mask_monthly = monthify_stack_sum(tavg_raw.lat, tavg_raw.lon, [1:size(tavg_actual,3)], bin_mask_daily,' num2str(base_year) ');' ];
    eval(command)
    
    %highest bin
    disp(['------------T >= 35C'])
    bin_mask_daily = (tavg_actual>=35);
    command = ['bin_35C_Inf_mask_monthly = monthify_stack_sum(tavg_raw.lat, tavg_raw.lon, [1:size(tavg_actual,3)], bin_mask_daily,' num2str(base_year) ');'];
    eval(command)
    
    %all other bins
   for T = -40:34
%        for T = -10:-8
        
        disp(['------------T = ' num2str(T) 'C'])
        bin_mask_daily = (tavg_actual>=T & tavg_actual<T+1);
        if T<-1
            command_1 = ['bin_n' num2str(abs(T)) 'C_n' num2str(abs(T+1)) 'C_mask_monthly'];
        elseif T == -1
            command_1 = ['bin_n1_0_mask_monthly'];
        else
            command_1 = ['bin_' num2str(T) 'C_' num2str(T+1) 'C_mask_monthly'];
        end
        command_2 = ['= monthify_stack_sum(tavg_raw.lat, tavg_raw.lon, [1:size(tavg_actual,3)], bin_mask_daily, ' num2str(base_year) ');'];
        eval([command_1 command_2])
        
    end
    
    
    
    clear tavg_* command* T bin_mask_daily ans i d S
    %save decdal files (roughly 80MB each)
    command = ['save Matlab_4d_stack_by_decade/PRECIP/precip_' num2str(base_year) '_raw_bin_counts'];
    eval(command)
    
    
end


disp('----DONE----')

















