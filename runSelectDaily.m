cd /home/theodor/norgay/data/sources/ERAI

files = dir('raw/*.nc');

mkdir('/home/theodor/norgay/data/sources/ERAI','DAILY');
mkdir('/home/theodor/norgay/data/sources/ERAI/DAILY','TMAX');
mkdir('/home/theodor/norgay/data/sources/ERAI/DAILY','TMIN');
mkdir('/home/theodor/norgay/data/sources/ERAI/DAILY','TAVG');
mkdir('/home/theodor/norgay/data/sources/ERAI/DAILY','PRECIP');

for fInfo = files'
    file = fInfo.name
    y = str2num(file(end-12:end-9))
    if y~=2015
        selectData
    end
end