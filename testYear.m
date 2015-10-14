% file = deblank(fileread('currentFile.txt'));
% y = str2num(fileread('currentYear.txt'));

for lon = 0:45:315

%     latitudes = ncread(file, 'latitude');
%     longitudes = ncread(file, 'longitude');
    times = ncread(file, 'time');

    baseOffset = 33; % not sure why this is, but ERA dates are slightly off
    lonOffset = 3*lon/45; % add 3 hour offset to start of day for each 45 deg
    totOffset = baseOffset + lonOffset;

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
    ixlon = round(lon/0.25+1);

    nlat = 721; % get all lat for a particular lon range
    nlon = 45/0.25; % # of horizontal grid points in 45 deg arc

    % var = {'mx2t', 'mn2t', 'tp'}

%     mxData = ncread(file, 'mx2t', [ixlon 1 1], [nlon nlat Inf]);
%     mnData = ncread(file, 'mn2t', [ixlon 1 1], [nlon nlat Inf]);
     tpData = ncread(file, 'tp', [ixlon 1 1], [nlon nlat Inf])*1000;

    % Calculate incremental precip, instead of accumulated
     ix = find(hours==3 | hours==15);
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

%     mxData = mxData(:,:,years==y);
%     mnData = mnData(:,:,years==y);
     tpData = tpData(:,:,years==y);

    years = years(years==y);

    doy = mDates-datenum(year(mDates),1,1)+1;

    for dd = unique(doy)'
        ix = find(doy==dd);

%         dayMax = max(mxData(:,:,ix),[],3);
%         dayMin = min(mnData(:,:,ix),[],3);
         dayTP = sum(tpData(:,:,ix),3);

        if dd==1
%             yearMax = dayMax;
%             yearMin = dayMin;
             yearTP = dayTP;
        else
%             yearMax = cat(3,yearMax,dayMax);
%             yearMin = cat(3,yearMin,dayMin);
             yearTP = cat(3,yearTP,dayTP);
        end
    end

    display(lon);
    display(size(yearTP));
%     if lon==0
%         allMax = yearMax;
%         allMin = yearMin;
%         allTP = yearTP;
% 
%         Y = ncread(file, 'latitude');
%         X = ncread(file, 'longitude');
%         T = unique(mDates);
%     else
%         allMax = cat(1,allMax,yearMax);
%         allMin = cat(1,allMin,yearMin);
%         allTP = cat(1,allTP,yearTP);
%     end

    

end

% allAvg = (allMax + allMin)/2;
% 
% tmax = struct('tmax',allMax,'T',T,'Y',Y,'X',X);
% tmin = struct('tmin',allMin,'T',T,'Y',Y,'X',X);
% tavg = struct('tavg',allAvg,'T',T,'Y',Y,'X',X);
% precip = struct('precip',allTP,'T',T,'Y',Y,'X',X);


clear;
