outputDir = '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg/';
mkdir(outputDir);
mkdir(outputDir,'TMAX');
mkdir(outputDir,'TMIN');
mkdir(outputDir,'TAVG');
mkdir(outputDir,'PRECIP');

cd /mnt/norgay/Datasets/Climate/ERA-Interim/Raw_NetCDF_1deg_x_1deg/
files = dir('*.nc');

for fInfo = files'
    f = deblank(fInfo.name);
    y = str2num(f(end-12:end-9));
    selectDaily(f, y);
end
