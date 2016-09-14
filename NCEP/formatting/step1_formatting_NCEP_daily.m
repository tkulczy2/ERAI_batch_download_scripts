
%formatting NCEP daily data

clear
% access norgay from local
cd '/Volumes/Lab_shared_folder/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2'

% access norgay from shackleton
%cd '/mnt/norgay/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2'

%%
load raw/NCEP_CDAS1_TEMP_1_Jan_1948_to_31_Dec_1970.mat
temp_1948_1970 = temp;

%%
load raw/NCEP_CDAS1_TEMP_1_Jan_1971_to_31_Dec_1990.mat
temp_1971_1990 = temp;

%load raw/NCEP_CDAS1_TEMP_1_Jan_1991_to_19_Sep_2011.mat
%temp_1991_2011 = temp;

%load raw/NCEP_CDAS1_TEMP_1_Jan_1991_to_31_Dec_2013.mat
%temp_1991_2013 = temp;

load raw/NCEP_CDAS1_TEMP_1_Jan_1991_to_31_Dec_2014.mat
temp_1991_2014 = temp;

clear temp

disp('done loading')


lat = temp_1948_1970.Y;
lon = temp_1948_1970.X;
temp_all = cat(3,temp_1948_1970.temp, temp_1971_1990.temp, temp_1991_2014.temp);
day_from_jan_1_1948 = cat(1,temp_1948_1970.T, temp_1971_1990.T, temp_1991_2014.T);

clear temp_19*

%%
save('formatted/NCEP_CDAS1_TEMP_1_Jan_1948_to_31_Dec_2014','-v7.3')

%%

clear
%access norgay from local
cd '/Volumes/Lab_shared_folder/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2'

% access norgay from shackleton
%cd '/mnt/norgay/Datasets/Climate/NCEP_CDAS/NCEP_CDAS1_daily_v2'
load formatted/NCEP_CDAS1_TEMP_1_Jan_1948_to_31_Dec_2014

%% COMPUTE DEGREE DAY MEASURES THAT WILL BE USED IN PROJECTION SCRIPTS

temp_all = temp_all - 273.15;

sum_temp = monthify_stack_sum(lat, lon, day_from_jan_1_1948, temp_all, 1948);

for cutoff =  0:5:30 %0:47
    
    command = ['dd' num2str(cutoff) '= (temp_all-' num2str(cutoff) ').*(temp_all >=' num2str(cutoff) ');'];
    eval(command)
    
    command =['sum_dd' num2str(cutoff) ' = monthify_stack_sum(lat, lon, day_from_jan_1_1948, dd' num2str(cutoff) ', 1948);'];
    eval(command)
    
    command = ['clear dd' num2str(cutoff)];
    eval(command)
    
    clear command
    
end


%% COMPUTE POLYNOMIAL OF DEGREE K THAT WILL BE USED IN PROJECTION SCRIPTS

% choose maximum polynomial degree
k = 8

for i=1:k
    command = ['temp_all_' num2str(i) '= temp_all;'];
    eval(command)
    
    for j=1:size(temp_all,3)
        command = ['temp_all_' num2str(i) '(:,:,j) = temp_all(:,:,j).^' num2str(i) ';'];
        eval(command)
    end
    
    command = ['sum_temp_' num2str(i) ' = monthify_stack_sum(lat, lon, day_from_jan_1_1948, temp_all_' num2str(i) ', 1948);'];
    eval(command)
    
    clear command
end
    

%% COMPUTE HEATING AND COOLING DEGREE DAY MEASURES CENTERED AT CUSTOM VALUE

% tau = centered value (tau=0 when T=tau) 
tau = 15;
intervals = ceil((35 - tau)/5)

temp_all_recenter = temp_all;
for i=1:size(temp_all,3)
    temp_all_recenter(:,:,i) = temp_all(:,:,i)-tau;
end

for cutoff = 0:5:(5*intervals) 
    
    % first run for positive values of tau (cooling degree days measure)
    command = ['cdd' num2str(cutoff) '= (temp_all_recenter-' num2str(cutoff) ').*(temp_all_recenter >=' num2str(cutoff) ');'];
    eval(command)

    command=['sum_cdd' num2str(cutoff) '= monthify_stack_sum(lat, lon, day_from_jan_1_1948, cdd' num2str(cutoff) ', 1948);'];
    eval(command)
    
    command = ['clear cdd' num2str(cutoff)];
    eval(command)
    
    % run for the negative values of tau (heating degree days measure)
    command = ['hdd' num2str(cutoff) '= (temp_all_recenter- (-1)*' num2str(cutoff) ').*(temp_all_recenter <= (-1)*' num2str(cutoff) ');'];
    eval(command)
    
    command = ['sum_hdd' num2str(cutoff) '= monthify_stack_sum(lat, lon, day_from_jan_1_1948, hdd' num2str(cutoff) ', 1948);'];
    eval(command)
    
    command =['clear hdd' num2str(cutoff)];
    eval(command)
    
    clear command
end
%%
clear ans cutoff i j  temp_all* temp_all_recenter day_from_jan_1_1948 lat lon

%% NATIVE FORMAT FOR NCEP IS FLIPPED UPSIDEDOWN AND CENTERED ON PACIFIC


total_years = size(sum_dd0.annual_field,3);

for cutoff = 0:5:30 %0:47
    
    %clip and move to recenter at 0,0
    command = ['sum_dd' num2str(cutoff) '.annual_field = cat(2,sum_dd' num2str(cutoff) '.annual_field(:,97:end,:), sum_dd' num2str(cutoff) '.annual_field(:,1:96,:));'];
    eval(command)
    
    command = ['sum_dd' num2str(cutoff) '.monthly_field = cat(2,sum_dd' num2str(cutoff) '.monthly_field(:,97:end,:,:), sum_dd' num2str(cutoff) '.monthly_field(:,1:96,:,:));'];
    eval(command)
    
    command = ['sum_dd' num2str(cutoff) '.lon = cat(1,sum_dd' num2str(cutoff) '.lon(97:end)-360, sum_dd' num2str(cutoff) '.lon(1:96));'];
    eval(command)
    
    % flipping about equator so properly oriented
    
    command = ['sum_dd' num2str(cutoff) '.lat = flipud(sum_dd' num2str(cutoff) '.lat);'];
    eval(command)
    
    for y = 1:total_years
        
        command = ['sum_dd' num2str(cutoff) '.annual_field(:,:,y) = flipud(sum_dd' num2str(cutoff) '.annual_field(:,:,y));'];
        eval(command)
        for m = 1:12

            command =['sum_dd' num2str(cutoff) '.monthly_field(:,:,y,m) = flipud(sum_dd' num2str(cutoff) '.monthly_field(:,:,y,m));'];
            eval(command)
            
        end
    end
    
end

clear y m cutoff command

%% REPEAT THE FLIP FOR THE POLYNOMIAL DATA

for poly = 1:k 
    
    %clip and move to recenter at 0,0
    command = ['sum_temp_' num2str(poly) '.annual_field = cat(2,sum_temp_' num2str(poly) '.annual_field(:,97:end,:), sum_temp_' num2str(poly) '.annual_field(:,1:96,:));'];
    eval(command)
    
    command = ['sum_temp_' num2str(poly) '.monthly_field = cat(2,sum_temp_' num2str(poly) '.monthly_field(:,97:end,:,:), sum_temp_' num2str(poly) '.monthly_field(:,1:96,:,:));'];
    eval(command)
    
    command = ['sum_temp_' num2str(poly) '.lon = cat(1,sum_temp_' num2str(poly) '.lon(97:end)-360, sum_temp_' num2str(poly) '.lon(1:96));'];
    eval(command)
    
    % flipping about equator so properly oriented
    
    command = ['sum_temp_' num2str(poly) '.lat = flipud(sum_temp_' num2str(poly) '.lat);'];
    eval(command)
    
    for y = 1:total_years
        
        command = ['sum_temp_' num2str(poly) '.annual_field(:,:,y) = flipud(sum_temp_' num2str(poly) '.annual_field(:,:,y));'];
        eval(command)
        for m = 1:12

            command =['sum_temp_' num2str(poly) '.monthly_field(:,:,y,m) = flipud(sum_temp_' num2str(poly) '.monthly_field(:,:,y,m));'];
            eval(command)
            
        end
    end
    
end

clear y m k poly command


%% REPEAT THE FLIP FOR THE RECENTERED DATA 

for cutoff = 0:5:(5*intervals)
    
    % COOLING DEGREE DAYS 
    
    %clip and move to recenter at 0,0 
    command = ['sum_cdd' num2str(cutoff) '.annual_field = cat(2,sum_cdd' num2str(cutoff) '.annual_field(:,97:end,:), sum_cdd' num2str(cutoff) '.annual_field(:,1:96,:));'];
    eval(command)
    
    command = ['sum_cdd' num2str(cutoff) '.monthly_field = cat(2,sum_cdd' num2str(cutoff) '.monthly_field(:,97:end,:,:), sum_cdd' num2str(cutoff) '.monthly_field(:,1:96,:,:));'];
    eval(command)
    
    command = ['sum_cdd' num2str(cutoff) '.lon = cat(1,sum_cdd' num2str(cutoff) '.lon(97:end)-360, sum_cdd' num2str(cutoff) '.lon(1:96));'];
    eval(command)
    
    % flipping about equator so properly oriented
    
    command = ['sum_cdd' num2str(cutoff) '.lat = flipud(sum_cdd' num2str(cutoff) '.lat);'];
    eval(command)
    
    for y = 1:total_years
        
        command = ['sum_cdd' num2str(cutoff) '.annual_field(:,:,y) = flipud(sum_cdd' num2str(cutoff) '.annual_field(:,:,y));'];
        eval(command)
        for m = 1:12

            command =['sum_cdd' num2str(cutoff) '.monthly_field(:,:,y,m) = flipud(sum_cdd' num2str(cutoff) '.monthly_field(:,:,y,m));'];
            eval(command)
            
        end
    end
    
     % NEGATIVE CUTOFF VALUES SECOND
    %clip and move to recenter at 0,0 
    command = ['sum_hdd' num2str(cutoff) '.annual_field = cat(2,sum_hdd' num2str(cutoff) '.annual_field(:,97:end,:), sum_hdd' num2str(cutoff) '.annual_field(:,1:96,:));'];
    eval(command)
    
    command = ['sum_hdd' num2str(cutoff) '.monthly_field = cat(2,sum_hdd' num2str(cutoff) '.monthly_field(:,97:end,:,:), sum_hdd' num2str(cutoff) '.monthly_field(:,1:96,:,:));'];
    eval(command)
    
    command = ['sum_hdd' num2str(cutoff) '.lon = cat(1,sum_hdd' num2str(cutoff) '.lon(97:end)-360, sum_hdd' num2str(cutoff) '.lon(1:96));'];
    eval(commavnd)
    
    % flipping about equator so properly oriented
    
    command = ['sum_hdd' num2str(cutoff) '.lat = flipud(sum_hdd' num2str(cutoff) '.lat);'];
    eval(command)
    
    for y = 1:total_years
        
        command = ['sum_hdd' num2str(cutoff) '.annual_field(:,:,y) = flipud(sum_hdd' num2str(cutoff) '.annual_field(:,:,y));'];
        eval(command)
        for m = 1:12

            command =['sum_hdd' num2str(cutoff) '.monthly_field(:,:,y,m) = flipud(sum_hdd' num2str(cutoff) '.monthly_field(:,:,y,m));'];
            eval(command)
            
        end
    end
    
end

clear y m cutoff command intervals
%% version that is imported to the projection scripts

save('formatted/NCEP_CDAS1_DegreeDays_1948_to_2014')


















