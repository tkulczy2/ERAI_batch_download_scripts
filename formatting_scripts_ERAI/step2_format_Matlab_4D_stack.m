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

for v = {'tavg'}
var = char(v);
VAR = upper(var);
    for base_year = 1979:1:2015
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
        
        
        %lowest bin
        disp(['------------T < -40C'])
        bin_mask_daily = (data_actual<-40);
        command = ['bin_nInf_n40C_mask_monthly = monthify_stack_sum(data_raw.lat, data_raw.lon, [1:size(data_actual,3)], bin_mask_daily,' num2str(base_year) ');' ];
        eval(command)

        %highest bin
        disp(['------------T >= 35C'])
        bin_mask_daily = (data_actual>=35);
        command = ['bin_35C_Inf_mask_monthly = monthify_stack_sum(data_raw.lat, data_raw.lon, [1:size(data_actual,3)], bin_mask_daily,' num2str(base_year) ');'];
        eval(command)

        %all other bins
        for T = -40:34
    %        for T = -10:-8

            disp(['------------T = ' num2str(T) 'C'])
            bin_mask_daily = (data_actual>=T & data_actual<T+1);
            if T<-1
                command_1 = ['bin_n' num2str(abs(T)) 'C_n' num2str(abs(T+1)) 'C_mask_monthly'];
            elseif T == -1
                command_1 = ['bin_n1_0_mask_monthly'];
            else
                command_1 = ['bin_' num2str(T) 'C_' num2str(T+1) 'C_mask_monthly'];
            end
            command_2 = ['= monthify_stack_sum(data_raw.lat, data_raw.lon, [1:size(data_actual,3)], bin_mask_daily, ' num2str(base_year) ');'];
            eval([command_1 command_2])

        end



        clear data_* command* T bin_mask_daily ans i d S
        %save annual files (roughly ??MB each)
        command = ['save Matlab_4d_stack_by_decade/' VAR '/' var '_' num2str(base_year) '_raw_bin_counts'];
        eval(command)
    end
end

disp('----DONE----')

















