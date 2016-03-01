function selectDaily(f, y)

% Next year's data for Jan. 1 are needed to make the appropriate timezone adjustment for
% places west of GMT
fNext = strrep(strrep(f,num2str(y), num2str(y+1)), num2str(y-1), num2str(y));
if y == 1979
    fNext = 'mx2t_mn2t_tp_3hour_1979-12-31to1980-12-31.nc';
end

for lon = 0:45:315
    disp(['--Starting longitude ' num2str(lon) '--'])

    gridDelta = 1.;
    % ixlat = round((90-lat)/0.25 + 1);
    ixlon = round(lon/gridDelta+1);

    nlat = 180/gridDelta+1; % get all lat for a particular lon range (could use Inf instead)
    nlon = 45/gridDelta; % # of horizontal grid points in 45 deg arc

    tpData = ncread(f, 'tp', [ixlon 1 1], [nlon nlat Inf]);
    times = ncread(f, 'time');
    
    if y ~= 2015
        tpData = cat(3, tpData, ncread(fNext, 'tp', [ixlon 1 9], [nlon nlat 8]));
        times = [times; ncread(fNext, 'time', 9, 8)];
    end
    
    tpData(tpData<0) = 0;

    % The way I initially read the dates from raw ERA files required this
    % adjustment, but not when converting dates using `datenum(1900,1,1) +
    % (double(times)/24)`
    %baseOffset = 33;
    baseOffset = 0;
    lonOffset = 0;
    if lon <= 135
        lonOffset = 3*lon/45; % add 3 hour offset to start of day for each 45 deg east of 
    else
        lonOffset = -3*(360-lon)/45; % subtract 3 hour offset to start of day for each 45 deg
    end
    offset = baseOffset + lonOffset;
    
    unshiftedDates = (datenum(1900,1,1) + (double(times)/24));
    mDates = (datenum(1900,1,1) + (double(times+offset)/24));

    % year vector to identify which observations are associated with days
    % from the desired year (shifted so that 00:00 is associate with the
    % previous day)
    years = year(mDates-0.01);
    
    % hour vector to identify which observation are NOT accumulated on top
    % of previous observations (i.e. not hours 3 and 15)
    % Calculate incremental precip, instead of accumulated
    ixhour = find(hour(unshiftedDates)~=3 & hour(unshiftedDates)~=15);
    ixhour = ixhour(ixhour~=1); % in case index value 1
    pinc = diff(tpData,[],3);
    tpData(:,:,ixhour) = pinc(:,:,ixhour-1);
    clear pinc nix;

    % Limit to records in the current year
    mDates = mDates(years==y);
    tpData = tpData(:,:,years==y);
    years = years(years==y);

    % For each day of the year, take the relevant max/min/sum
    % and add to the data structure holding daily observations
    % for the entire year
    doy = floor(mDates-0.01 - datenum(y,1,1)+1);
    for dd = unique(doy)'
        ix = find(doy==dd);

        dayTP = sum(tpData(:,:,ix),3)*1000;

        if dd==1
            yearTP = dayTP;
        else
            yearTP = cat(3,yearTP,dayTP);
        end
    end

    % For the first timezone segment, initialize data structures
    % to hold global data. After that, add to them.
    if lon==0
        allTP = yearTP;

        Y = ncread(f, 'latitude');
        X = ncread(f, 'longitude');
        T = unique(floor(mDates-0.01));
    else
        allTP = cat(1,allTP,yearTP);
    end

end

% Convert to structure array for future processing
precip = struct('precip',allTP,'T',T,'lat',Y,'lon',X);

% Save to norgay for future processing
%outputDir = '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_.25deg_x_.25deg/';
outputDir = '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg/';
save(strcat(outputDir,'/PRECIP/ERAI_DAILY_PRECIP_',num2str(y),'.mat'),'precip','-v7.3');

clear;
end
