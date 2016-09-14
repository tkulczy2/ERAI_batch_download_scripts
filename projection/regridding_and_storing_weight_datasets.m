

clear

%data sets to regrid
load population_w_income
load '/Volumes/Disk 1 RAID Set/DATASETS/sage/formatted/cross_section.mat'
%%

cd '~/Dropbox/sol_matlab_toolbox/weather_data_projections'
load '/Volumes/Disk 1 RAID Set/DATASETS/BOM/formatted/BOM_precip_temp_1950_2007_wide' BOM_precip
load NCEP_CMAP_1979_2008_general
load NCEP_CDAS1_1949_2009_general

%BERKELEY EARTH data (density 1)
load BEST_nonmissing_data_mask

%density 1
load LICRICE2_global_density_1_yr_1950_2008
output1 = output; clear output

%density 10
load '/Volumes/Disk 1 RAID Set/LARGE_DATASETS/LICRICE_v2_global/output/aggregate/ALL_BASINS_global_density_10_yr_1950_2008'
output10 = output; clear output

%% 

%BEST

%use avg coarsen here because same resolution
population_BEST = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, nonmissing_mask.lon, nonmissing_mask.lat).*nonmissing_mask.mask;
crops_BEST = flexible_coarsen_sum_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat, nonmissing_mask.lon, nonmissing_mask.lat).*nonmissing_mask.mask;


%BOM

%use avg coarsen here because same resolution
population_BOM = flexible_coarsen_par(population.total_2000, population.lon, population.lat, BOM_precip.lon, BOM_precip.lat);


%for these, use the sum coarsen to preserve the number of people in the
%world (don't want avg number of people in pixel

% CMAP

population_CMAP = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, CMAP.lon, CMAP.lat);
abssum(population_CMAP)

crops_CMAP = flexible_coarsen_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat, CMAP.lon, CMAP.lat);


% NCEP

population_NCEP = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, NCEP1.lon, NCEP1.lat);
abssum(population_NCEP)

crops_NCEP = flexible_coarsen_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat,  NCEP1.lon, NCEP1.lat);


% LICRICE (density 1)

    %have to clip the dataset at the edges
    output1.annual_fields.lat = output1.annual_fields.lat(2:end-1);
    output1.annual_fields.lon = output1.annual_fields.lon(1:end-1);
    
population_LICRICE = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, output1.annual_fields.lon, output1.annual_fields.lat);
abssum(population_LICRICE)

crops_LICRICE = flexible_coarsen_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat,  output1.annual_fields.lon, output1.annual_fields.lat);


% LICRICE (density 10)

    %have to clip the dataset at the edges
    output10.annual_fields.lon = output10.annual_fields.lon(1:end-1);
    
population_LICRICE_10 = flexible_coarsen_sum_par(population.total_2000, population.lon, population.lat, output10.annual_fields.lon, output10.annual_fields.lat);
abssum(population_LICRICE_10)

crops_LICRICE_10 = flexible_coarsen_par(crop_fraction_2000_high_res.data, crop_fraction_2000_high_res.lon, crop_fraction_2000_high_res.lat,  output10.annual_fields.lon, output10.annual_fields.lat);



%% visually checking

figure
subplot(2,3,1)
imagesc(BOM_precip.lon, BOM_precip.lat,log(population_BOM))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,2)
imagesc( CMAP.lon, CMAP.lat, log(population_CMAP))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,3)
imagesc(NCEP1.lon, NCEP1.lat, log(population_NCEP))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,4)
imagesc(output1.annual_fields.lon, output1.annual_fields.lat, log(population_LICRICE))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,5)
imagesc(output10.annual_fields.lon, output10.annual_fields.lat, log(population_LICRICE_10))
plotallcountries('k',.5); formatmap; colormapping;


figure
subplot(2,3,1)
%no BOM
subplot(2,3,2)
imagesc( CMAP.lon, CMAP.lat, (crops_CMAP))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,3)
imagesc(NCEP1.lon, NCEP1.lat, (crops_NCEP))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,4)
imagesc(output1.annual_fields.lon, output1.annual_fields.lat, (crops_LICRICE))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,3,5)
imagesc(output10.annual_fields.lon, output10.annual_fields.lat, (crops_LICRICE_10))
plotallcountries('k',.5); formatmap; colormapping;

%BEST data checking
figure
subplot(2,1,1)
imagesc(nonmissing_mask.lon, nonmissing_mask.lat, log(population_BEST))
plotallcountries('k',.5); formatmap; colormapping;
subplot(2,1,2)
imagesc(nonmissing_mask.lon, nonmissing_mask.lat, crops_BEST)
plotallcountries('k',.5); formatmap; colormapping;

%% saving small files for rapid loading

cd ~/Dropbox/sol_matlab_toolbox/global_data/

population_total_BOM = struct('total_2000', population_BOM,'lat', BOM_precip.lat, 'lon', BOM_precip.lon)
population_total_CMAP = struct('total_2000', population_CMAP,'lat', CMAP.lat, 'lon', CMAP.lon)
population_total_NCEP = struct('total_2000', population_NCEP,'lat', NCEP1.lat, 'lon', NCEP1.lon)
population_total_LICRICE = struct('total_2000', population_LICRICE,'lat', output1.annual_fields.lat, 'lon', output1.annual_fields.lon)
population_total_LICRICE_density_10 = struct('total_2000', population_LICRICE_10,'lat', output10.annual_fields.lat, 'lon', output10.annual_fields.lon)
population_total_BEST = struct('total_2000', population_BEST,'lat', double(nonmissing_mask.lat), 'lon', double(nonmissing_mask.lon))


save population_BOM population_total_BOM
save population_CMAP population_total_CMAP
save population_NCEP population_total_NCEP
save population_LICRICE population_total_LICRICE
save population_LICRICE_density_10 population_total_LICRICE_density_10
save population_BEST population_total_BEST

crop_fraction_CMAP = struct('total_2000', crops_CMAP,'lat', CMAP.lat, 'lon', CMAP.lon)
crop_fraction_NCEP = struct('total_2000', crops_NCEP,'lat', NCEP1.lat, 'lon', NCEP1.lon)
crop_fraction_LICRICE = struct('total_2000', crops_LICRICE,'lat', output1.annual_fields.lat, 'lon', output1.annual_fields.lon)
crop_fraction_LICRICE_density_10 = struct('total_2000', crops_LICRICE_10,'lat', output10.annual_fields.lat, 'lon', output10.annual_fields.lon)
crop_fraction_BEST = struct('total_2000', crops_BEST,'lat', double(nonmissing_mask.lat), 'lon', double(nonmissing_mask.lon))

save crops_CMAP crop_fraction_CMAP
save crops_NCEP crop_fraction_NCEP
save crops_LICRICE crop_fraction_LICRICE
save crops_LICRICE_density_10 crop_fraction_LICRICE_density_10
save crops_BEST crop_fraction_BEST