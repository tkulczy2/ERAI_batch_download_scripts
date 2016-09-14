%%
%   S. HSIANG 5/22/15
%   SCRIPT TO FORMAT BERKELEY EARTH TEMP DATA INTO BINNED DEGREE STACKS FOR
%   USE IN PROJECTION SCRIPTS

%%

cd '/mnt/norgay/Datasets/Climate/GMFD/'
mkdir Matlab_4d_stack_by_decade
mkdir Matlab_4d_stack_by_decade/TAVG
mkdir Matlab_4d_stack_by_decade/PRCP

start_year = 1948;
end_year = 2010;
year_inc = 1;

for v = {'tavg','prcp'}
    var = char(v);
    VAR = upper(var);

    if strcmp(var, 'prcp')
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
    for base_year = start_year:year_inc:end_year
        command = ['load Matlab_.25deg_x_.25deg/' VAR '/GMFD_DAILY_' VAR '_' num2str(base_year) '.mat'];
        eval(command)
        command = ['data_raw = ' var ';'];
        eval(command)

        % transposing stack to (lat x lon x time) to conform with Berkeley EARTH data
        command = ['data_actual = permute(data_raw.' var ', [2 1 3]);'];
        eval(command)

        lat = data_raw.lat;
        lon = data_raw.lon - 360.*(data_raw.lon>180); % make longitudes > 180 negative
        lat = double(lat);
        lon = double(lon);

        % Generate time variables
        yr = year(data_raw.T);
        mo = month(data_raw.T);
        dom = day(data_raw.T);
        doy = datenum(data_raw.T) - datenum(year(data_raw.T),1,1) + 1;
        
        %lowest bin
        disp(['------------T < ' num2str(bot_bin) unit])
        bin_mask_daily = (data_actual<bot_bin);
        command = ['bin_nInf_' strrep(num2str(bot_bin),'-','n') unit '_mask_monthly = monthify_stack_sum(lat, lon, [1:size(data_actual,3)], bin_mask_daily,' num2str(base_year) ');' ];
        eval(command)

        %highest bin
        disp(['------------T >= ' num2str(top_bin) unit])
        bin_mask_daily = (data_actual>=top_bin);
        command = ['bin_' num2str(top_bin) unit '_Inf_mask_monthly = monthify_stack_sum(lat, lon, [1:size(data_actual,3)], bin_mask_daily,' num2str(base_year) ');'];
        eval(command)

        %all other bins
        for T = bot_bin:inc:top_bin-inc

            disp(['------------T = ' num2str(T) unit])
            bin_mask_daily = (data_actual>=T & data_actual<T+inc);
            command_1 = ['bin_' strrep(num2str(T),'-','n') unit '_' strrep(num2str(T+inc),'-','n') unit '_mask_monthly'];
            command_2 = ['= monthify_stack_sum(lat, lon, [1:size(data_actual,3)], bin_mask_daily, ' num2str(base_year) ');'];
            eval([command_1 command_2])

        end

        clearvars data_* command* T bin_mask_daily ans i d S
        %save annual files (roughly ??MB each)
        command = ['save Matlab_4d_stack_by_decade/' VAR '/' var '_' num2str(base_year) '_raw_bin_counts'];
        eval(command)
    end
    clearvars -except start_year end_year year_inc v;
end

disp('----DONE----')

















