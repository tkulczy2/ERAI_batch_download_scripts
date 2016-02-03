function selectDaily(f, y)

% f = deblank(fileread('currentFile.txt'));
% y = str2num(fileread('currentYear.txt'));
fNext = strrep(strrep(f,num2str(y), num2str(y+1)), num2str(y-1), num2str(y));
if y == 1979
    fNext = 'mx2t_mn2t_tp_3hour_1979-12-31to1980-12-31.nc';
end
for lon = 0:45:315

    gridDelta = 1.0;
    % ixlat = round((90-lat)/0.25 + 1);
    ixlon = round(lon/gridDelta+1);

    nlat = 180/gridDelta+1; % get all lat for a particular lon range (could use Inf instead)
    nlon = 45/gridDelta; % # of horizontal grid points in 45 deg arc

    mxData = ncread(f, 'mx2t', [ixlon 1 1], [nlon nlat Inf]);
    mnData = ncread(f, 'mn2t', [ixlon 1 1], [nlon nlat Inf]);
    tpData = ncread(f, 'tp', [ixlon 1 1], [nlon nlat Inf]);
    times = ncread(f, 'time');
    
    if lon > 135 && y ~= 2015
        mxData = cat(3, mxData, ncread(fNext, 'mx2t', [ixlon 1 9], [nlon nlat 8]));
        mnData = cat(3, mnData, ncread(fNext, 'mn2t', [ixlon 1 9], [nlon nlat 8]));
        tpData = cat(3, tpData, ncread(fNext, 'tp', [ixlon 1 9], [nlon nlat 8]));
        times = [times; ncread(fNext, 'time', 9, 8)];
    end
        

    % The way I initially read the dates from raw ERA files required this
    % adjustment, but not when converting dates using `datenum(1900,1,1) +
    % (double(times)/24)`
    %baseOffset = 33;
    baseOffset = 0;
    if lon <= 135
        lonOffset = 3*lon/45; % add 3 hour offset to start of day for each 45 deg east of 
    else
        lonOffset = -3*(360-lon)/45; % subtract 3 hour offset to start of day for each 45 deg
    end
    offset = baseOffset + lonOffset;
    

    mDates = (datenum(1900,1,1) + (double(times+offset)/24));
    %mDates = x2mdate((times+offset)/24);

    % year vector to identify which observations are associated with days
    % from the desired year (shifted so that 00:00 is associate with the
    % previous day)
    years = year(mDates-0.01);
    % hour vector to identify which observation are NOT accumulated on top
    % of previous observations (i.e. not hours 3 and 15)
    hours = hour(mDates);

%     years = str2num(datestr(mDates, 'yyyy')-0.01);
%     hours = str2num(datestr(mDates, 'hh'));
%     hours = mod(times, 24);

    
    mxData(mxData<0) = nan;
    mnData(mnData<0) = nan;
    tpData(tpData<0) = nan;

    % Calculate incremental precip, instead of accumulated
    % ix = find(hours==3 | hours==15);
    nix = find(hours~=3 & hours~=15);
    nix = nix(nix~=1);
    pinc = diff(tpData,[],3);
    tpData(:,:,nix) = pinc(:,:,nix-1);
    clear pinc nix;

    % Limit to records in the current year
    mDates = mDates(years==y);
    hours = hours(years==y);

    mxData = mxData(:,:,years==y);
    mnData = mnData(:,:,years==y);
    tpData = tpData(:,:,years==y);

    years = years(years==y);

    doy = floor(mDates-0.01 - datenum(y,1,1)+1);

    for dd = unique(doy)'
        ix = find(doy==dd);

        dayMax = max(mxData(:,:,ix),[],3);
        dayMin = min(mnData(:,:,ix),[],3);
        dayTP = sum(tpData(:,:,ix),3)*1000;

        if dd==1
            yearMax = dayMax;
            yearMin = dayMin;
            yearTP = dayTP;
        else
            yearMax = cat(3,yearMax,dayMax);
            yearMin = cat(3,yearMin,dayMin);
            yearTP = cat(3,yearTP,dayTP);
        end
    end

    if lon==0
        allMax = yearMax;
        allMin = yearMin;
        allTP = yearTP;

        Y = ncread(f, 'latitude');
        X = ncread(f, 'longitude');
        T = unique(floor(mDates-0.01));
    else
        allMax = cat(1,allMax,yearMax);
        allMin = cat(1,allMin,yearMin);
        allTP = cat(1,allTP,yearTP);
    end

    

end

allAvg = (allMax + allMin)/2;

tmax = struct('tmax',allMax,'T',T,'lat',Y,'lon',X);
tmin = struct('tmin',allMin,'T',T,'lat',Y,'lon',X);
tavg = struct('tavg',allAvg,'T',T,'lat',Y,'lon',X);
precip = struct('precip',allTP,'T',T,'lat',Y,'lon',X);

baseDir = '/mnt/norgay/Datasets/Climate/ERA-Interim/Matlab_1deg_x_1deg/';
save(strcat(baseDir,'/TMAX/ERAI_DAILY_TMAX_',num2str(y),'.mat'),'tmax','-v7.3');
save(strcat(baseDir,'/TMIN/ERAI_DAILY_TMIN_',num2str(y),'.mat'),'tmin','-v7.3');
save(strcat(baseDir,'/TAVG/ERAI_DAILY_TAVG_',num2str(y),'.mat'),'tavg','-v7.3');
save(strcat(baseDir,'/PRECIP/ERAI_DAILY_PRECIP_',num2str(y),'.mat'),'precip','-v7.3');

clear;
end
