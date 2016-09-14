%%% Updated script to project all weather data for summer school students
%%% AND for the mortality and labor mega-papers 
%%% Updates 2/10/2016: add in US at the county level, China at the county
%%% level and India at the district level (T. Carleton)

clear
close all
clc

%% custom functions path
addpath('/mnt/norgay/Computation/climate_projection_system_2016_2_10')
addpath('/home/tkulczycki/Dropbox/ChicagoRAs_Reanalysis/Repos/climate_download_formatting_projection/projection');

%% set climate according to the parameters being projected (in project_new_weather_par.m)
clim = 'BEST';

a = check_matlabpool;
if a == false
    pool = parpool(10,'IdleTimeout', 120);
end

T0 = clock;

% %% USA ADM2 
%  
% clear 
% close all 
% cd /home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/USA/gz_2010_us_050_00_500k 
% %  
% [s,a] = shaperead('gz_2010_us_050_00_500k.shp','UseGeoCoords', true) 
% %  
% [s, a] = drop_by_attribute(s, a, 'STATE', '15'); %Hawaii 
% [s, a] = drop_by_attribute(s, a, 'STATE', '02'); %Alaska 
% [s, a] = drop_by_attribute(s, a, 'STATE', '72'); %Puerto Rico 
% %  
% a = combine_attributes(a, 'STATE', 'COUNTY'); 
% %  
% %s = s(1:5); 
% %a = a(1:5); 
% %  
% %  
% plot_districts(s) 
% AX = axis; 
% lonlim = [floor(AX(1)) ceil(AX(2))]; 
% latlim = [floor(AX(3)) ceil(AX(4))]; 
% %  
% T1 = clock; 
% output = project_complete_data_folder_newclimate(s,a,'STATE_COUNTY', 1,latlim,lonlim,'USA_FIPS') 
% T2 = clock; 
% %  
% disp('--------------DONE DONE DONE-----------') 
% %  
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min']) 
% 
% 
% %% MEX
% 
% clear
% close all
% cd /home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/MEX
% 
% [s,a] = shaperead('national_municipal.shp','UseGeoCoords', true)
% 
% a = combine_attributes(a, 'NOM_ENT', 'NOM_MUN');
% 
% %s = s(1:5);
% %a = a(1:5);
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder_newclimate(s,a,'NOM_ENT_NOM_MUN', 1,latlim,lonlim,'test_MEX')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 
% 
% %% BRA ADM 2
% 
% clear
% close all
% cd /home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/BRA
% 
% [s,a] = shaperead('BRA_adm2.shp','UseGeoCoords', true)
% 
% a = combine_attributes(a, 'NAME_1', 'NAME_2');
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder_newclimate(s,a,'NAME_1_NAME_2', 1,latlim,lonlim,'test_BRA_adm2')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%% CHN
% % 
clear
close all
cd /home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/CHN/GIS

[s,a] = shaperead('city_poly.shp','UseGeoCoords', true)
a = combine_attributes(a, 'NAME_1', 'NAME_2');
a(1).NAME_1_NAME_2 = 'InnerMongolia-Hulunbuir';

cd ..

plot_districts(s)
AX = axis;
lonlim = [floor(AX(1)) ceil(AX(2))];
latlim = [floor(AX(3)) ceil(AX(4))];

T1 = clock;
output = project_complete_data_folder_newclimate(s,a,'NAME_1_NAME_2', 1,latlim,lonlim,'test_CHN_city')
T2 = clock;

disp('--------------DONE DONE DONE-----------')

disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])



% %% CHN DISTRICTS
% % % 
% clear
% close all
% 
% % cd /mnt/norgay/Summer-Workshop-Data/_spatial_data/CHN/GIS
% cd '/home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/CHN/CH_CENSUS2000'
% 
% [s,a] = shaperead('CH_CENSUS2000.shp','UseGeoCoords', true)
% a = combine_attributes(a, 'EPROV', 'ECNTY');
% 
% cd ..
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder_newclimate(s,a, 'EPROV_ECNTY', 1,latlim,lonlim,'test_CHN')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])



% %% FRA ADM2
% 
% clear
% close all
% cd /home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/FRA
% 
% [s,a] = shaperead('FRA_adm2.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% a = combine_attributes(a, 'NAME_1', 'NAME_2');
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder_newclimate(s,a,'NAME_1_NAME_2', 1,latlim,lonlim,'test_FRA_adm2')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 
% 
% %% IND 1961 DISTRICTS
%  
% clear
% close all
% % % Sol's machine
% % cd /home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/IND
% 
% % % Shackleton
% cd '/home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/IND_1961'
% 
% [s,a] = shaperead('district61.shp','UseGeoCoords', true)
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% % 
% T1 = clock;
% output = project_complete_data_folder_newclimate(s,a,'DIST61_ID', 1,latlim,lonlim,'test_IND_1961')
% T2 = clock;
% % 
% disp('--------------DONE DONE DONE-----------')
% % 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


% %% WORLD - IPUMS
% 
% clear
% close all
% cd /mnt/norgay_gcp/Summer-Workshop-Data/_spatial_data/WORLD/IPUMS
% 
% [s,a] = shaperead('world_geolev1.shp','UseGeoCoords', true)
% 
% [s, a] = drop_by_attribute(s, a, 'ADMIN_NAME', 'Alaska')
% [s, a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Russia')
% [s, a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Fiji')
% [s, a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Antarctica')
% [s, a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Tuvalu')
% [s, a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Hong Kong')
% 
% % a = combine_attributes(a, 'CNTRY_NAME', 'GEOLEVEL1');
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder_newclimate(s,a,'GEOLEVEL1', 1,latlim,lonlim,'test_WORLD_IPUMS_geocode')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])




