
clear
close all
clc

a = check_matlabpool;
if a == false
    pool = parpool(8,'IdleTimeout', 120);
end

T0 = clock;

%% AUS states (practice sample)

% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/AUS
% 
% [s,a] = shaperead('AUS_adm1.shp','UseGeoCoords', true)
% 
% [s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% [s, a] = drop_by_attribute(s, a, 'NAME_1', 'Coral Sea Islands')
% [s, a] = drop_by_attribute(s, a, 'NAME_1', 'Unknown1')
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_AUS')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])

%% GTM
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/GTM
% 
% [s,a] = shaperead('GTM_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_GTM')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%% NIC
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/NIC
% 
% [s,a] = shaperead('NIC_adm2.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_NIC')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%% IND
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/IND
% 
% [s,a] = shaperead('IND_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_IND')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 

%% IND - 1991 boundaries
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/IND_1991
% 
% [s,a] = shaperead('district91.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'DIST91_ID', 1,latlim,lonlim,'test_IND_1991')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 

%% NOR
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/NOR/N2000-Kartdata-master
% 
% 
% [s,a] = shaperead('NO_Kommuner_pol_latlng.shp','UseGeoCoords', true)
% a = combine_attributes(a, 'NAVN', 'KOMM');
% 
% cd ..
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAVN_KOMM', 1,latlim,lonlim,'test_NOR')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])

%% FRA ADM2
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/FRA
% 
% [s,a] = shaperead('FRA_adm2.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% a = combine_attributes(a, 'NAME_1', 'NAME_2');
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1_NAME_2', 1,latlim,lonlim,'test_FRA_adm2')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])

%% FRA ADM1
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/FRA
% 
% [s,a] = shaperead('FRA_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_FRA_adm1')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 
 
%% ISR
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/ISR
% 
% [s,a] = shaperead('ISR_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_ISR')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])

%% ITA

% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/ITA
% 
% [s,a] = shaperead('ITA_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_ITA')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])

%% NLD
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/NLD
% 
% [s,a] = shaperead('NLD_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_NLD')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 

%% ZAF
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/ZAF
% 
% [s,a] = shaperead('ZAF_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_ZAF')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 
% 

%% ESP

% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/ESP
% 
% [s,a] = shaperead('ESP_adm1.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_ESP')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 
% 

%% GBR

% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/GBR
% 
% [s,a] = shaperead('GBR_region.shp','UseGeoCoords', true)
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'ADMIN_NAME', 1,latlim,lonlim,'test_GBR')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 

%% CHN
% % 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/CHN/GIS
% 
% % % use the polygon file instead of this one 
% % [s,a] = shaperead('city_loc_new.shp','UseGeoCoords', true)
% % a = combine_attributes(a, 'city_name', 'province')
% 
% [s,a] = shaperead('city_poly.shp','UseGeoCoords', true)
% a = combine_attributes(a, 'NAME_1', 'NAME_2');
% a(1).NAME_1_NAME_2 = 'InnerMongolia-Hulunbuir';
% 
% cd ..
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,' NAME_1_NAME_2', 1,latlim,lonlim,'test_CHN')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 


%% BRA ADM 1
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/BRA
%  
% [s,a] = shaperead('BRA_adm1.shp','UseGeoCoords', true)
% 
% %a = combine_attributes(a, 'NAME_1', 'NAME_2');
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1', 1,latlim,lonlim,'test_BRA_adm1')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])

%% BRA ADM 2
% % 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/BRA
% 
% [s,a] = shaperead('BRA_adm2.shp','UseGeoCoords', true)
% 
% a = combine_attributes(a, 'NAME_1', 'NAME_2');
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1_NAME_2', 1,latlim,lonlim,'test_BRA_adm2')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 

%% BRA ADM 2 FOR LIMITED CITIES
% % 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/BRA
% 
% %obtain shapefile
% [s,a] = shaperead('BRA_adm2.shp','UseGeoCoords', true);
% 
% %keeping only the 6 cities with labor data
% [S, A] = keep_by_attribute(s, a, 'NAME_2', 'Porto Alegre');
% s(1) = S; a(1) = A;
% 
% [S, A] = keep_by_attribute(s, a, 'NAME_2', 'Rio de Janeiro');
% s(2) = S; a(2) = A;
% 
% [S, A] = keep_by_attribute(s, a, 'NAME_2', 'Belo Horizonte');
% s(3) = S; a(3) = A;
% 
% [S, A] = keep_by_attribute(s, a, 'NAME_2', 'São Paulo');
% s(4) = S; a(4) = A;
% 
% [S, A] = keep_by_attribute(s, a, 'NAME_2', 'Salvador');
% s(5) = S; a(5) = A;
% 
% [S, A] = keep_by_attribute(s, a, 'NAME_2', 'Recife');
% s(6) = S; a(6) = A;
% 
% s = s(1:6); a = a(1:6);
% clear S A
% 
% a = combine_attributes(a, 'NAME_1', 'NAME_2');
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder(s,a,'NAME_1_NAME_2', 1,latlim,lonlim,'BRA_6_cities_UDEL')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


 %% MEX
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/MEX
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
% output = project_complete_data_folder(s,a,'NOM_ENT_NOM_MUN', 1,latlim,lonlim,'test_MEX')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%% WORLD - IPUMS
% 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/WORLD/IPUMS
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
% a = combine_attributes(a, 'CNTRY_NAME', 'ADMIN_NAME');
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
% output = project_complete_data_folder(s,a,'CNTRY_NAME_ADMIN_NAME', 1,latlim,lonlim,'test_WORLD_IPUMS')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 
% 

%% WORLD - COUNTRIES

clear
close all

cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/WORLD/ESRI

load world_countries

[s, a] = drop_by_attribute(s, a, 'ISO_3DIGIT', 'USA')
[s, a] = drop_by_attribute(s, a, 'ISO_3DIGIT', 'USA')
[s, a] = drop_by_attribute(s, a, 'ISO_3DIGIT', 'HKG')
[s, a] = drop_by_attribute(s, a, 'ISO_3DIGIT', 'FJI')
[s, a] = drop_by_attribute(s, a, 'ISO_3DIGIT', 'TUV')
[s, a] = drop_by_attribute(s, a, 'ISO_3DIGIT', 'RUS')
[s, a] = drop_by_attribute(s, a, 'CNTRY_NAME', 'Antarctica')


a = combine_attributes(a, 'CNTRY_NAME', 'ISO_3DIGIT');

plot_districts(s)
AX = axis;
lonlim = [floor(AX(1)) ceil(AX(2))];
latlim = [floor(AX(3)) ceil(AX(4))];

T1 = clock;
output = project_complete_data_folder(s,a,'CNTRY_NAME_ISO_3DIGIT', 1,latlim,lonlim,'test_WORLD_ESRI')
T2 = clock;

disp('--------------DONE DONE DONE-----------')

disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%% WORLD - DATELINE COUNTRIES

clear
close all

cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/WORLD/ESRI

load world_countries

a = combine_attributes(a, 'CNTRY_NAME', 'ISO_3DIGIT');

plot_districts(s)
AX = axis;
lonlim = [floor(AX(1)) ceil(AX(2))];
latlim = [floor(AX(3)) ceil(AX(4))];

T1 = clock;
output = project_complete_data_folder_DATELINE(s,a,'CNTRY_NAME_ISO_3DIGIT', 1,latlim,lonlim,'test_WORLD_ESRI_DATELINE')
T2 = clock;

disp('--------------DONE DONE DONE-----------')

disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%% CHL
% % 
% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/CHL/cl_comunas_geo
% 
% % % use the polygon file instead of this one 
% % [s,a] = shaperead('city_loc_new.shp','UseGeoCoords', true)
% % a = combine_attributes(a, 'city_name', 'province')
% 
% [s,a] = shaperead('cl_comunas_geo.shp','UseGeoCoords', true)
% a = combine_attributes(a, 'NOMBRE', 'ID_2002');
% 
% cd ..
% 
% %[s, a] = drop_by_attribute(s, a, 'NAME_1', 'Ashmore and Cartier Islands')
% 
% 
% plot_districts(s)
% AX = axis;
% lonlim = [floor(AX(1)) ceil(AX(2))];
% latlim = [floor(AX(3)) ceil(AX(4))];
% 
% T1 = clock;
% output = project_complete_data_folder_ALL(s,a,'NOMBRE_ID_2002', 1,latlim,lonlim,'test_CHL')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])
% 

%% USA ADM2

% clear
% close all
% cd /Users/solhsiang/Dropbox/Rhodium/summer-workshop-data/_spatial_data/USA/gz_2010_us_050_00_500k
% 
% [s,a] = shaperead('gz_2010_us_050_00_500k.shp','UseGeoCoords', true)
% 
% [s, a] = drop_by_attribute(s, a, 'STATE', '15') %Hawaii
% [s, a] = drop_by_attribute(s, a, 'STATE', '02') %Alaska
% [s, a] = drop_by_attribute(s, a, 'STATE', '72') %Puerto Rico
% 
% a = combine_attributes(a, 'STATE', 'COUNTY');
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
% output = project_complete_data_folder(s,a,'STATE_COUNTY', 1,latlim,lonlim,'USA_FIPS')
% T2 = clock;
% 
% disp('--------------DONE DONE DONE-----------')
% 
% disp(['total runtime: ' num2str(etime(T2, T1)/60) ' min'])


%%
disp('--------------DONE DONE DONE-----------')
disp('--------------DONE DONE DONE-----------')
disp('--------------DONE DONE DONE-----------')
disp('--------------DONE DONE DONE-----------')
disp('--------------DONE DONE DONE-----------')

