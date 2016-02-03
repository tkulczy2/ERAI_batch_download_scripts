function selectDaily(f, y)

% f = deblank(fileread('currentFile.txt'));
% y = str2num(fileread('currentYear.txt'));

for lon = 0:45:315

%     latitudes = ncread(file, 'latitude');
%     longitudes = ncread(file, 'longitude');
    times = ncread(f, 'time');

    baseOffset = 33; % not sure why this is, but ERA dates are slightly off
    lonOffset = 3*lon/45; % add 3 hour offset to start of day for each 45 deg
    totOffset = baseOffset + lonOffset;
    gridDelta = 1.0;

    mDates = x2mdate((times+totOffset)/24);
    %     dates = cellstr(datestr(mDates));
    years = str2num(datestr(mDates, 'yyyy'));
    %     months = str2num(datestr(mDates, 'mm'));
    %     days = str2num(datestr(mDates, 'dd'));
    hours = mod(times, 24);

    %     yearDates = dates(years==y);
    %     [C,ia,ic] = unique(yearDates);
    %     uniqueDates = yearDates(sort(ia));


    % ixlat = round((90-lat)/0.25 + 1);
    ixlon = round(lon/gridDelta+1);

    nlat = 180/gridDelta+1; % get all lat for a particular lon range
    nlon = 45/gridDelta; % # of horizontal grid points in 45 deg arc

    % var = {'mx2t', 'mn2t', 'tp'}

    mxData = ncread(f, 'mx2t', [ixlon 1 1], [nlon nlat Inf]);
    mnData = ncread(f, 'mn2t', [ixlon 1 1], [nlon nlat Inf]);
    tpData = ncread(f, 'tp', [ixlon 1 1], [nlon nlat Inf]);

    mxData(mxData<0) = nan;
    mnData(mnData<0) = nan;
    tpData(tpData<0) = nan;

    % Calculate incremental precip, instead of accumulated
    % ix = find(hours==3 | hours==15);
    nix = find(hours~=3 & hours~=15);
    pinc = diff(tpData,[],3);
    tpData(:,:,nix) = pinc(:,:,nix-1);
    clear pinc nix;

    % Limit to records in the current year
    mDates = mDates(years==y);
    %     dates = dates(years==y);
    %     months = months(years==y);
    %     days = days(years==y);
    hours = hours(years==y);

    mxData = mxData(:,:,years==y);
    mnData = mnData(:,:,years==y);
    tpData = tpData(:,:,years==y);

    years = years(years==y);

    doy = mDates-datenum(year(mDates),1,1)+1;

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
        T = unique(mDates);
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
