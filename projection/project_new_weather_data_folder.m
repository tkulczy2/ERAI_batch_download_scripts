function [Q] = project_weather_data_folder(s,a,label,varargin)

%
% S. HSIANG
% SMH2137@COLUMBIA.EDU
% 7.11
%
% ---------------------
%
% project_weather_data_folder(s, a, label, filename)
%
% arguments:
%           s - structure array from shapefile
%           a - attribute array from shapefile
%           label - string with the name of the attribute used to label
%                   polygons in the shapefile (struct in A)
%           filename - (OPTIONAL) string with the desired path-filename for
%                      output (default uses LABEL, date and time)
%
% PROJECT_WEATHER_DATA_FOLDER constructs multiple datasets of weather variables
% for use in statistical analysis. It creats a new folder (FILENAME) with
% subdirectories containing CSV files and MAT files.
%
% The following datasets are called and projected onto the shapefile,
% unless they are commented out in the file below
%
%           'UDEL-temp1'    - surface temperature from UDEL v4.01 (1950-1970)
%           'UDEL-temp2'    - surface temperature from UDEL v4.01 (1971-1990)
%           'UDEL-temp3'    - surface temperature from UDEL v4.01 (1991-2010)
%           'UDEL-temp4'    - surface temperature from UDEL v4.01 (2011-2014)
%           'UDEL-precip1'  - precipitation from UDEL v4.01 (1950-1970)
%           'UDEL-precip2'  - precipitation from UDEL v4.01 (1971-1990)
%           'UDEL-precip3'  - precipitation from UDEL v4.01 (1991-2010)
%           'UDEL-precip4'  - precipitation from UDEL v4.01 (2011-2014)
% 'BOM-avg-temp'  - average temp from AUS BOM (1950-2007)
% 'BOM-max-temp'  - maximum temp from AUS BOM (1950-2007)
% 'BOM-min-temp'  - minimum temp from AUS BOM (1950-2007)
% 'BOM-precip'    - total precip from AUS BOM (1891-2007)
% 'NCEP-temp'     - surface temperature from NCEP CDAS 1 (1949-2008)
% 'CMAP-precip'   - precipitation rate from NCEP CMAP (1979-2008)
% 'LICRICE-pddi'  - power dissipation from LICRICE v2 (1950-2008)
% 'LICRICE-maxs'  - maximum windspeed from LICRICE v2 (1950-2008)
% 'NASA-aerosol'  - stratospheric optical depth (1984-2005)
%
% Notes: 
%   PROJECT_WEATHER_DATA_FOLDER calls various parallel functions for speed. 
%   Opening a large matlabpool will improve performance.
%
% IMPORTING TO STATA:
%   CSV datasets are ready for import to Stata. Upon import call functions:
%       label_weather_data.ado
%   to label variables for use. 
%
% See also project_weather_par, project_static_data_folder,
% project_complete_data_folder, project_weather_par_dateline






%check if running in parellel
check_matlabpool;

%store original location
original_folder = pwd;

%------------CREATING A FOLDER TO PLACE ALL OUTPUT
S = size(varargin);

if S(1) == 1
    %if a filename is specified, make that folder
    foldername = char(varargin{1});
else
    %if no filename is specified, make a generic folder
    c = clock;
    foldername = ['weather_' label '_' date '_' num2str(c(4)) num2str(c(5))];
end

command = ['mkdir ' foldername];
eval(command)
command = ['cd ' foldername];
eval(command)

mkdir csv
mkdir mat



%----------CALL DATSETS TO PROJECT

% 'UDEL-temp1'    - surface temperature from UDEL v3.01 (1950-1970)
% 'UDEL-temp2'    - surface temperature from UDEL v3.01 (1971-1990)
% 'UDEL-temp3'    - surface temperature from UDEL v3.01 (1991-2010)
% 'UDEL-precip1'  - precipitation from UDEL v3.02 (1950-1970)
% 'UDEL-precip2'  - precipitation from UDEL v3.02 (1971-1990)
% 'UDEL-precip3'  - precipitation from UDEL v3.02 (1991-2010)
% 'BOM-avg-temp'  - average temp from AUS BOM (1950-2007)
% 'BOM-max-temp'  - maximum temp from AUS BOM (1950-2007)
% 'BOM-min-temp'  - minimum temp from AUS BOM (1950-2007)
% 'BOM-precip'    - total precip from AUS BOM (1891-2007)
% 'NCEP-temp'     - surface temperature from NCEP CDAS 1 (1949-2008)
% 'NCEP-dd*'      - surface temp in degree days from NCEP CDAS 1 (1948-2013)
%                   *  = {0,5,10,15,20,25,30}
% 'CMAP-precip'   - precipitation rate from NCEP CMAP (1979-2008)
% 'LICRICE-pddi'  - power dissipation from LICRICE v2 (1950-2008)
% 'LICRICE-maxs'  - maximum windspeed from LICRICE v2 (1950-2008)
% 'LICRICE-pddi-high-res'
%                 - power dissipation from LICRICE v2 (1950-2008)
%                   resolution is 0.1 degree, limits = [48S,48N]
% 'LICRICE-maxs-high-res'
%                 - maximum windspeed from LICRICE v2 (1950-2008)
%                 resolution is 0.1 degree, limits = [48S,48N]
% 'NASA-aerosol'  - stratospheric optical depth (1984-2005)


%COMMENT OUT FIELDS TO LEAVE OUT

variable_list =   {
%     
%  

% % ERA-Interim
% % DECSENDING ORDER
% % % 
% 'ERAI_tavg_BIN_35C_Inf'
% 'ERAI_tavg_BIN_34C_35C'
% 'ERAI_tavg_BIN_33C_34C'
% 'ERAI_tavg_BIN_32C_33C'
% 'ERAI_tavg_BIN_31C_32C'
% 'ERAI_tavg_BIN_30C_31C'
% 'ERAI_tavg_BIN_29C_30C'
% 'ERAI_tavg_BIN_28C_29C'
% 'ERAI_tavg_BIN_27C_28C'
% 'ERAI_tavg_BIN_26C_27C'
% 'ERAI_tavg_BIN_25C_26C'
% 'ERAI_tavg_BIN_24C_25C'
% 'ERAI_tavg_BIN_23C_24C'
% 'ERAI_tavg_BIN_22C_23C'
% 'ERAI_tavg_BIN_21C_22C'
% 'ERAI_tavg_BIN_20C_21C'
% 'ERAI_tavg_BIN_19C_20C'
% 'ERAI_tavg_BIN_18C_19C'
% 'ERAI_tavg_BIN_17C_18C'
% 'ERAI_tavg_BIN_16C_17C'
% 'ERAI_tavg_BIN_15C_16C'
% 'ERAI_tavg_BIN_14C_15C'
% 'ERAI_tavg_BIN_13C_14C'
% 'ERAI_tavg_BIN_12C_13C'
% 'ERAI_tavg_BIN_11C_12C'
% 'ERAI_tavg_BIN_10C_11C'
% 'ERAI_tavg_BIN_9C_10C'
% 'ERAI_tavg_BIN_8C_9C'
% 'ERAI_tavg_BIN_7C_8C'
% 'ERAI_tavg_BIN_6C_7C'
% 'ERAI_tavg_BIN_5C_6C'
% 'ERAI_tavg_BIN_4C_5C'
% 'ERAI_tavg_BIN_3C_4C'
% 'ERAI_tavg_BIN_2C_3C'
% 'ERAI_tavg_BIN_1C_2C'
% 'ERAI_tavg_BIN_0C_1C'
% 'ERAI_tavg_BIN_n1C_0C'
% 'ERAI_tavg_BIN_n2C_n1C'
% 'ERAI_tavg_BIN_n3C_n2C'
% 'ERAI_tavg_BIN_n4C_n3C'
% 'ERAI_tavg_BIN_n5C_n4C'
% 'ERAI_tavg_BIN_n6C_n5C'
% 'ERAI_tavg_BIN_n7C_n6C'
% 'ERAI_tavg_BIN_n8C_n7C'
% 'ERAI_tavg_BIN_n9C_n8C'
% 'ERAI_tavg_BIN_n10C_n9C'
% 'ERAI_tavg_BIN_n11C_n10C'
% 'ERAI_tavg_BIN_n12C_n11C'
% 'ERAI_tavg_BIN_n13C_n12C'
% 'ERAI_tavg_BIN_n14C_n13C'
% 'ERAI_tavg_BIN_n15C_n14C'
% 'ERAI_tavg_BIN_n16C_n15C'
% 'ERAI_tavg_BIN_n17C_n16C'
% 'ERAI_tavg_BIN_n18C_n17C'
% 'ERAI_tavg_BIN_n19C_n18C'
% 'ERAI_tavg_BIN_n20C_n19C'
% 'ERAI_tavg_BIN_n21C_n20C'
% 'ERAI_tavg_BIN_n22C_n21C'
% 'ERAI_tavg_BIN_n23C_n22C'
% 'ERAI_tavg_BIN_n24C_n23C'
% 'ERAI_tavg_BIN_n25C_n24C'
% 'ERAI_tavg_BIN_n26C_n25C'
% 'ERAI_tavg_BIN_n27C_n26C'
% 'ERAI_tavg_BIN_n28C_n27C'
% 'ERAI_tavg_BIN_n29C_n28C'
% 'ERAI_tavg_BIN_n30C_n29C'
% 'ERAI_tavg_BIN_n31C_n30C'
% 'ERAI_tavg_BIN_n32C_n31C'
% 'ERAI_tavg_BIN_n33C_n32C'
% 'ERAI_tavg_BIN_n34C_n33C'
% 'ERAI_tavg_BIN_n35C_n34C'
% 'ERAI_tavg_BIN_n36C_n35C'
% 'ERAI_tavg_BIN_n37C_n36C'
% 'ERAI_tavg_BIN_n38C_n37C'
% 'ERAI_tavg_BIN_n39C_n38C'
% 'ERAI_tavg_BIN_n40C_n39C'
% 'ERAI_tavg_BIN_nInf_n40C'

% % NCEP CDAS1
% % DECSENDING ORDER
% % % 
'NCEP_tavg_BIN_35C_Inf'
'NCEP_tavg_BIN_34C_35C'
'NCEP_tavg_BIN_33C_34C'
'NCEP_tavg_BIN_32C_33C'
'NCEP_tavg_BIN_31C_32C'
'NCEP_tavg_BIN_30C_31C'
'NCEP_tavg_BIN_29C_30C'
'NCEP_tavg_BIN_28C_29C'
'NCEP_tavg_BIN_27C_28C'
'NCEP_tavg_BIN_26C_27C'
'NCEP_tavg_BIN_25C_26C'
'NCEP_tavg_BIN_24C_25C'
'NCEP_tavg_BIN_23C_24C'
'NCEP_tavg_BIN_22C_23C'
'NCEP_tavg_BIN_21C_22C'
'NCEP_tavg_BIN_20C_21C'
'NCEP_tavg_BIN_19C_20C'
'NCEP_tavg_BIN_18C_19C'
'NCEP_tavg_BIN_17C_18C'
'NCEP_tavg_BIN_16C_17C'
'NCEP_tavg_BIN_15C_16C'
'NCEP_tavg_BIN_14C_15C'
'NCEP_tavg_BIN_13C_14C'
'NCEP_tavg_BIN_12C_13C'
'NCEP_tavg_BIN_11C_12C'
'NCEP_tavg_BIN_10C_11C'
'NCEP_tavg_BIN_9C_10C'
'NCEP_tavg_BIN_8C_9C'
'NCEP_tavg_BIN_7C_8C'
'NCEP_tavg_BIN_6C_7C'
'NCEP_tavg_BIN_5C_6C'
'NCEP_tavg_BIN_4C_5C'
'NCEP_tavg_BIN_3C_4C'
'NCEP_tavg_BIN_2C_3C'
'NCEP_tavg_BIN_1C_2C'
'NCEP_tavg_BIN_0C_1C'
'NCEP_tavg_BIN_n1C_0C'
'NCEP_tavg_BIN_n2C_n1C'
'NCEP_tavg_BIN_n3C_n2C'
'NCEP_tavg_BIN_n4C_n3C'
'NCEP_tavg_BIN_n5C_n4C'
'NCEP_tavg_BIN_n6C_n5C'
'NCEP_tavg_BIN_n7C_n6C'
'NCEP_tavg_BIN_n8C_n7C'
'NCEP_tavg_BIN_n9C_n8C'
'NCEP_tavg_BIN_n10C_n9C'
'NCEP_tavg_BIN_n11C_n10C'
'NCEP_tavg_BIN_n12C_n11C'
'NCEP_tavg_BIN_n13C_n12C'
'NCEP_tavg_BIN_n14C_n13C'
'NCEP_tavg_BIN_n15C_n14C'
'NCEP_tavg_BIN_n16C_n15C'
'NCEP_tavg_BIN_n17C_n16C'
'NCEP_tavg_BIN_n18C_n17C'
'NCEP_tavg_BIN_n19C_n18C'
'NCEP_tavg_BIN_n20C_n19C'
'NCEP_tavg_BIN_n21C_n20C'
'NCEP_tavg_BIN_n22C_n21C'
'NCEP_tavg_BIN_n23C_n22C'
'NCEP_tavg_BIN_n24C_n23C'
'NCEP_tavg_BIN_n25C_n24C'
'NCEP_tavg_BIN_n26C_n25C'
'NCEP_tavg_BIN_n27C_n26C'
'NCEP_tavg_BIN_n28C_n27C'
'NCEP_tavg_BIN_n29C_n28C'
'NCEP_tavg_BIN_n30C_n29C'
'NCEP_tavg_BIN_n31C_n30C'
'NCEP_tavg_BIN_n32C_n31C'
'NCEP_tavg_BIN_n33C_n32C'
'NCEP_tavg_BIN_n34C_n33C'
'NCEP_tavg_BIN_n35C_n34C'
'NCEP_tavg_BIN_n36C_n35C'
'NCEP_tavg_BIN_n37C_n36C'
'NCEP_tavg_BIN_n38C_n37C'
'NCEP_tavg_BIN_n39C_n38C'
'NCEP_tavg_BIN_n40C_n39C'
'NCEP_tavg_BIN_nInf_n40C'

% % GMFD
% % DECSENDING ORDER
% % % 
% 'GMFD_tavg_BIN_35C_Inf'
% 'GMFD_tavg_BIN_34C_35C'
% 'GMFD_tavg_BIN_33C_34C'
% 'GMFD_tavg_BIN_32C_33C'
% 'GMFD_tavg_BIN_31C_32C'
% 'GMFD_tavg_BIN_30C_31C'
% 'GMFD_tavg_BIN_29C_30C'
% 'GMFD_tavg_BIN_28C_29C'
% 'GMFD_tavg_BIN_27C_28C'
% 'GMFD_tavg_BIN_26C_27C'
% 'GMFD_tavg_BIN_25C_26C'
% 'GMFD_tavg_BIN_24C_25C'
% 'GMFD_tavg_BIN_23C_24C'
% 'GMFD_tavg_BIN_22C_23C'
% 'GMFD_tavg_BIN_21C_22C'
% 'GMFD_tavg_BIN_20C_21C'
% 'GMFD_tavg_BIN_19C_20C'
% 'GMFD_tavg_BIN_18C_19C'
% 'GMFD_tavg_BIN_17C_18C'
% 'GMFD_tavg_BIN_16C_17C'
% 'GMFD_tavg_BIN_15C_16C'
% 'GMFD_tavg_BIN_14C_15C'
% 'GMFD_tavg_BIN_13C_14C'
% 'GMFD_tavg_BIN_12C_13C'
% 'GMFD_tavg_BIN_11C_12C'
% 'GMFD_tavg_BIN_10C_11C'
% 'GMFD_tavg_BIN_9C_10C'
% 'GMFD_tavg_BIN_8C_9C'
% 'GMFD_tavg_BIN_7C_8C'
% 'GMFD_tavg_BIN_6C_7C'
% 'GMFD_tavg_BIN_5C_6C'
% 'GMFD_tavg_BIN_4C_5C'
% 'GMFD_tavg_BIN_3C_4C'
% 'GMFD_tavg_BIN_2C_3C'
% 'GMFD_tavg_BIN_1C_2C'
% 'GMFD_tavg_BIN_0C_1C'
% 'GMFD_tavg_BIN_n1C_0C'
% 'GMFD_tavg_BIN_n2C_n1C'
% 'GMFD_tavg_BIN_n3C_n2C'
% 'GMFD_tavg_BIN_n4C_n3C'
% 'GMFD_tavg_BIN_n5C_n4C'
% 'GMFD_tavg_BIN_n6C_n5C'
% 'GMFD_tavg_BIN_n7C_n6C'
% 'GMFD_tavg_BIN_n8C_n7C'
% 'GMFD_tavg_BIN_n9C_n8C'
% 'GMFD_tavg_BIN_n10C_n9C'
% 'GMFD_tavg_BIN_n11C_n10C'
% 'GMFD_tavg_BIN_n12C_n11C'
% 'GMFD_tavg_BIN_n13C_n12C'
% 'GMFD_tavg_BIN_n14C_n13C'
% 'GMFD_tavg_BIN_n15C_n14C'
% 'GMFD_tavg_BIN_n16C_n15C'
% 'GMFD_tavg_BIN_n17C_n16C'
% 'GMFD_tavg_BIN_n18C_n17C'
% 'GMFD_tavg_BIN_n19C_n18C'
% 'GMFD_tavg_BIN_n20C_n19C'
% 'GMFD_tavg_BIN_n21C_n20C'
% 'GMFD_tavg_BIN_n22C_n21C'
% 'GMFD_tavg_BIN_n23C_n22C'
% 'GMFD_tavg_BIN_n24C_n23C'
% 'GMFD_tavg_BIN_n25C_n24C'
% 'GMFD_tavg_BIN_n26C_n25C'
% 'GMFD_tavg_BIN_n27C_n26C'
% 'GMFD_tavg_BIN_n28C_n27C'
% 'GMFD_tavg_BIN_n29C_n28C'
% 'GMFD_tavg_BIN_n30C_n29C'
% 'GMFD_tavg_BIN_n31C_n30C'
% 'GMFD_tavg_BIN_n32C_n31C'
% 'GMFD_tavg_BIN_n33C_n32C'
% 'GMFD_tavg_BIN_n34C_n33C'
% 'GMFD_tavg_BIN_n35C_n34C'
% 'GMFD_tavg_BIN_n36C_n35C'
% 'GMFD_tavg_BIN_n37C_n36C'
% 'GMFD_tavg_BIN_n38C_n37C'
% 'GMFD_tavg_BIN_n39C_n38C'
% 'GMFD_tavg_BIN_n40C_n39C'
% 'GMFD_tavg_BIN_nInf_n40C'
% % %

% % BEST bins
% % DECSENDING ORDER
% % % 
'BEST_tavg_BIN_35C_Inf'
'BEST_tavg_BIN_34C_35C'
'BEST_tavg_BIN_33C_34C'
'BEST_tavg_BIN_32C_33C'
'BEST_tavg_BIN_31C_32C'
'BEST_tavg_BIN_30C_31C'
'BEST_tavg_BIN_29C_30C'
'BEST_tavg_BIN_28C_29C'
'BEST_tavg_BIN_27C_28C'
'BEST_tavg_BIN_26C_27C'
'BEST_tavg_BIN_25C_26C'
'BEST_tavg_BIN_24C_25C'
'BEST_tavg_BIN_23C_24C'
'BEST_tavg_BIN_22C_23C'
'BEST_tavg_BIN_21C_22C'
'BEST_tavg_BIN_20C_21C'
'BEST_tavg_BIN_19C_20C'
'BEST_tavg_BIN_18C_19C'
'BEST_tavg_BIN_17C_18C'
'BEST_tavg_BIN_16C_17C'
'BEST_tavg_BIN_15C_16C'
'BEST_tavg_BIN_14C_15C'
'BEST_tavg_BIN_13C_14C'
'BEST_tavg_BIN_12C_13C'
'BEST_tavg_BIN_11C_12C'
'BEST_tavg_BIN_10C_11C'
'BEST_tavg_BIN_9C_10C'
'BEST_tavg_BIN_8C_9C'
'BEST_tavg_BIN_7C_8C'
'BEST_tavg_BIN_6C_7C'
'BEST_tavg_BIN_5C_6C'
'BEST_tavg_BIN_4C_5C'
'BEST_tavg_BIN_3C_4C'
'BEST_tavg_BIN_2C_3C'
'BEST_tavg_BIN_1C_2C'
'BEST_tavg_BIN_0C_1C'
'BEST_tavg_BIN_n1C_0C'
'BEST_tavg_BIN_n2C_n1C'
'BEST_tavg_BIN_n3C_n2C'
'BEST_tavg_BIN_n4C_n3C'
'BEST_tavg_BIN_n5C_n4C'
'BEST_tavg_BIN_n6C_n5C'
'BEST_tavg_BIN_n7C_n6C'
'BEST_tavg_BIN_n8C_n7C'
'BEST_tavg_BIN_n9C_n8C'
'BEST_tavg_BIN_n10C_n9C'
'BEST_tavg_BIN_n11C_n10C'
'BEST_tavg_BIN_n12C_n11C'
'BEST_tavg_BIN_n13C_n12C'
'BEST_tavg_BIN_n14C_n13C'
'BEST_tavg_BIN_n15C_n14C'
'BEST_tavg_BIN_n16C_n15C'
'BEST_tavg_BIN_n17C_n16C'
'BEST_tavg_BIN_n18C_n17C'
'BEST_tavg_BIN_n19C_n18C'
'BEST_tavg_BIN_n20C_n19C'
'BEST_tavg_BIN_n21C_n20C'
'BEST_tavg_BIN_n22C_n21C'
'BEST_tavg_BIN_n23C_n22C'
'BEST_tavg_BIN_n24C_n23C'
'BEST_tavg_BIN_n25C_n24C'
'BEST_tavg_BIN_n26C_n25C'
'BEST_tavg_BIN_n27C_n26C'
'BEST_tavg_BIN_n28C_n27C'
'BEST_tavg_BIN_n29C_n28C'
'BEST_tavg_BIN_n30C_n29C'
'BEST_tavg_BIN_n31C_n30C'
'BEST_tavg_BIN_n32C_n31C'
'BEST_tavg_BIN_n33C_n32C'
'BEST_tavg_BIN_n34C_n33C'
'BEST_tavg_BIN_n35C_n34C'
'BEST_tavg_BIN_n36C_n35C'
'BEST_tavg_BIN_n37C_n36C'
'BEST_tavg_BIN_n38C_n37C'
'BEST_tavg_BIN_n39C_n38C'
'BEST_tavg_BIN_n40C_n39C'
'BEST_tavg_BIN_nInf_n40C'


% % UDEL precip - incorrectly aggregated
% % DECSENDING ORDER
% % % 
% 'UDEL-precip1'
% 'UDEL-precip2'
% 'UDEL-precip3'

% % BEST temperature polynomial - correctly aggregated
% 'BEST_polynomial_1'
% 'BEST_polynomial_2'
% 'BEST_polynomial_3'
% 'BEST_polynomial_4'
% 'BEST_polynomial_5'
% 'BEST_polynomial_6'
% 'BEST_polynomial_7'
% 'BEST_polynomial_8'

% 'UDEL_precip_polynomial_1'
% 'UDEL_precip_polynomial_2'
% 'UDEL_precip_polynomial_3'
% 'UDEL_precip_polynomial_4'
% 'UDEL_precip_polynomial_5'
% 'UDEL_precip_polynomial_6'
% 'UDEL_precip_polynomial_7'
% 'UDEL_precip_polynomial_8'

};

N = length(variable_list);

fields = cell(N,1); %store cell arrays in mat file

for i = 1:N
    field =  variable_list{i};
    disp(['|-------------------------projecting ' field '-------------------------|'])
    
    
    %----------------------------------------------------------------------
    %project each dataset onto the shapefile
    %tabulate output
    x = project_new_weather_par(s, a, label, field); 
    
    % USE THIS COMMAND AS AN ALTERNATIVE FOR ABOVE COMMAND IF PROJECTING
    % ONLY ONTO THE FOUR COUNTRIES THAT SPAN THE DATELINE: USA, RUS, TUV
    % AND FJI:
    %x = project_weather_par_dateline(field); 
    % does not require s, a or label fields
    %----------------------------------------------------------------------
    
    
    %replace nan with missing obs
    y = nan2missing(x.output_table);

    %export to csv file
    %cell2csv(y, ['csv/' field]);
    cell2table2csv(y, ['csv/' field]); % 60% less time for large files
    
    fields{i} = x;
    
    clear x y
    
    %adjust field names so they are valid field names in a structure
    variable_list{i} = regexprep(field,'-','_'); 
    
%     email_me([field ' is done']);
    
end


% UNCOMMENT THESE TO SAVE DATA IN MATLAB FORMAT, LARGE FILE!

%weather_data = cell2struct(fields, variable_list,1);
%save mat/field_projections weather_data

clc


disp('------------------------------------------')
disp('DONE')
disp('------------------------------------------')
disp('DATASETS COMPLETED:')
disp(' ')
disp(variable_list)
disp('------------------------------------------')

Q = true; % weather_data;

%return to original location

command = ['cd ' original_folder];
eval(command);

end



