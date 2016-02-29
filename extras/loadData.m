function T = loadData(param, lon, lat)

if strcmp(param,'2t')
    var = 't2m';
else
    var = param;
end

pref = 'erai_';
start_date = '2014-01-01';
end_date = '2014-12-31';
suff = '.nc';

file = strcat(pref,param,'_',start_date,'to',end_date,suff);
ncdisp(file)

%f = ncreadatt(file,var,'scale_factor');
%o = ncreadatt(file,var,'add_offset');

% Get temperatures at Greenwich (51.5, 0) using getVar
%ncid = netcdf.open(file, 'NC_NOWRITE');
%t = netcdf.getVar(ncid,3,[0 154 0],[1 1 1460],'double')*f+o;

% Get temperatures at Greenwich (51.5, 0) using ncread
ixlat = round((90-lat)/0.25 + 1);
ixlon = round(lon/0.25+1);
data = squeeze(ncread(file, var, [ixlon ixlat 1], [1 1 Inf]));

if strcmp(param,'tp')
    data = data*1000.;
end

times = ncread(file, 'time');

if strcmp(var,'t2m')
    toffset = 36;
else
    toffset = 33;
end

mDates = (datenum(1900,1,1) + (double(times)/24));
%mDates = x2mdate((times+toffset)/24); % WHY IS OFFSET NECESSARY?
dates = cellstr(datestr(mDates));
years = str2num(datestr(mDates, 'yyyy'));
months = str2num(datestr(mDates, 'mm'));
days = str2num(datestr(mDates, 'dd'));
hours = mod(times, 24);

T = table(data, dates, years, months, days, hours);
% Combine date and time into single string
%dt = cellstr(datestr(strcat(d, '-', num2str(h), ':00'), 'yyyy-mm-dd HH:MM'));