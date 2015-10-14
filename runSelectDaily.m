cd /home/tkulczycki/norgay/data/sources/ERAI

files = dir('3HOURLY/*.nc');

mkdir('/home/tkulczycki/norgay/data/sources/ERAI','DAILY');
mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','TMAX');
mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','TMIN');
mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','TAVG');
mkdir('/home/tkulczycki/norgay/data/sources/ERAI/DAILY','PRECIP');

for fInfo = files'
    file = fInfo.name
    y = str2num(file(end-12:end-9))
    if y~=2015
        selectData
    end
end