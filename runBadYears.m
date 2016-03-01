outputDir = '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_.25deg_x_.25deg/';
%outputDir = '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg/';
mkdir(outputDir);
mkdir(outputDir,'TMAX');
mkdir(outputDir,'TMIN');
mkdir(outputDir,'TAVG');
mkdir(outputDir,'PRECIP');

cd /mnt/norgay/Datasets/Climate/ERA_Interim/Raw_NetCDF_.25deg_x_.25deg/
files = dir('*.nc');
% still need to run 2000 and 2001
bad_years = [1981 2000 2001];
for fInfo = files'
    f = deblank(fInfo.name);
    y = str2num(f(end-12:end-9));
    if any(bad_years==y)
    selectDaily(f, y);
    end
    disp(['----- Done with year ' num2str(y) ' -----'])
end
