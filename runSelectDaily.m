cd /home/tkulczycki/norgay/data/sources/ERAI/3HOURLY

files = dir('*.nc');

% mkdir('/home/tkulczycki/norgay/data/sources/ERAI','DAILY');
% mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','TMAX');
% mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','TMIN');
% mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','TAVG');
% mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','PRECIP');

for fInfo = files'
    f = deblank(fInfo.name);
    y = str2num(f(end-12:end-9));
    if y~=2015
        selectDaily(f, y);
    end
end