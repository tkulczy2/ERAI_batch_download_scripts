% data sets to regrid
load('/mnt/norgay/Computation/climate_projection_system_2016_2_10/global_data/population_w_income.mat');
load('/mnt/norgay/Datasets/SAGE/formatted/cross_section.mat');
%

% ERA-Interim and GMFD
% ERAI is 0.25x0.25 and (721, 1440) from 90 to -90 (lat) and 0 to 359.75 (lon)
load('/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_.25deg_x_.25deg/TAVG/ERAI_DAILY_TAVG_2000.mat');
% GMFD is 0.25x0.25 and (720, 1440) from -89.875 to 89.875 (lat) and 0.125 to 359.875 (lon)
load('/mnt/norgay/Datasets/Climate/GMFD/Matlab_.25deg_x_.25deg/TMAX/GMFD_DAILY_TMAX_2000.mat');
%

% fix latitudes and longitudes
tavg.lat = tavg.lat(2:end-1); % drop +/- 90 from ERAI
tavg.lon = tavg.lon - 360.*(tavg.lon>180); % make longitudes > 180 negative
tmax.lon = tmax.lon - 360.*(tmax.lon>180);
%

% Regridding
population_ERAI = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, tavg.lon, tavg.lat);
crops_ERAI = flexible_coarsen_sum_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat, tavg.lon, tavg.lat);

population_GMFD = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, tmax.lon, tmax.lat);
crops_GMFD = flexible_coarsen_sum_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat, tmax.lon, tmax.lat);

% Saving
cd /mnt/norgay/Computation/climate_projection_system_2016_2_10/global_data

population_total_GMFD = struct('total_2000', population_GMFD,'lat', double(tmax.lat), 'lon', double(tmax.lon));
save population_GMFD population_total_GMFD
crop_fraction_GMFD = struct('total_2000', crops_GMFD,'lat', double(tmax.lat), 'lon', double(tmax.lon));
save crops_GMFD crop_fraction_GMFD

population_total_ERAI = struct('total_2000', population_ERAI,'lat', double(tavg.lat), 'lon', double(tavg.lon));
save population_ERAI population_total_ERAI
crop_fraction_ERAI = struct('total_2000', crops_ERAI,'lat', double(tavg.lat), 'lon', double(tavg.lon));
save crops_ERAI crop_fraction_ERAI

% % these maps don't seem to work
% imagesc(population_total_ERAI.lon, population_total_ERAI.lat, (population_total_ERAI.total_2000'))
% plotallcountries('k',.1); formatmap; colormapping;
% saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/population_ERAI.pdf')
% clf
% imagesc(population_total_GMFD.lon, population_total_GMFD.lat, (population_total_GMFD.total_2000'))
% plotallcountries('k',.1); formatmap; colormapping;
% saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/population_GMFD.pdf')
% clf
% imagesc(crop_fraction_ERAI.lon, crop_fraction_ERAI.lat, (crop_fraction_ERAI.total_2000'))
% plotallcountries('k',.1); formatmap; colormapping;
% saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/crops_ERAI.pdf')
% clf
% imagesc(crop_fraction_GMFD.lon, crop_fraction_GMFD.lat, (crop_fraction_GMFD.total_2000'))
% plotallcountries('k',.1); formatmap; colormapping;
% saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/crops_GMFD.pdf')
% clf

% these maps work
worldmap world
pcolorm(population_total_ERAI.lat, population_total_ERAI.lon, (population_total_ERAI.total_2000))
saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/population_ERAI.png')
clf
worldmap world
pcolorm(population_total_GMFD.lat, population_total_GMFD.lon, (population_total_GMFD.total_2000))
saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/population_GMFD.png')
clf
worldmap world
pcolorm(crop_fraction_ERAI.lat, crop_fraction_ERAI.lon, (crop_fraction_ERAI.total_2000))
saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/crops_ERAI.png')
clf
worldmap world
pcolorm(crop_fraction_GMFD.lat, crop_fraction_GMFD.lon, (crop_fraction_GMFD.total_2000))
saveas(gcf, '/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/temporary_sharing/crops_GMFD.png')
clf

