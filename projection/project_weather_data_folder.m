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
    foldername = varargin{1};
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

% ASCENDING ORDER
% % 
%'BEST_tavg_BIN_nInf_n40C'
%'BEST_tavg_BIN_n40C_n39C'
%'BEST_tavg_BIN_n39C_n38C'
% 'BEST_tavg_BIN_n38C_n37C'
% 'BEST_tavg_BIN_n37C_n36C'
% 'BEST_tavg_BIN_n36C_n35C'
% 'BEST_tavg_BIN_n35C_n34C'
% 'BEST_tavg_BIN_n34C_n33C'
% 'BEST_tavg_BIN_n33C_n32C'
% 'BEST_tavg_BIN_n32C_n31C'
% 'BEST_tavg_BIN_n31C_n30C'
% 'BEST_tavg_BIN_n30C_n29C'
% 'BEST_tavg_BIN_n29C_n28C'
% 'BEST_tavg_BIN_n28C_n27C'
% 'BEST_tavg_BIN_n27C_n26C'
% 'BEST_tavg_BIN_n26C_n25C'
% 'BEST_tavg_BIN_n25C_n24C'
% 'BEST_tavg_BIN_n24C_n23C'
% 'BEST_tavg_BIN_n23C_n22C'
% 'BEST_tavg_BIN_n22C_n21C'
% 'BEST_tavg_BIN_n21C_n20C'
% 'BEST_tavg_BIN_n20C_n19C'
% 'BEST_tavg_BIN_n19C_n18C'
% 'BEST_tavg_BIN_n18C_n17C'
% 'BEST_tavg_BIN_n17C_n16C'
% 'BEST_tavg_BIN_n16C_n15C'
% 'BEST_tavg_BIN_n15C_n14C'
% 'BEST_tavg_BIN_n14C_n13C'
% 'BEST_tavg_BIN_n13C_n12C'
% 'BEST_tavg_BIN_n12C_n11C'
% 'BEST_tavg_BIN_n11C_n10C'
% 'BEST_tavg_BIN_n10C_n9C'
% 'BEST_tavg_BIN_n9C_n8C'
% 'BEST_tavg_BIN_n8C_n7C'
% 'BEST_tavg_BIN_n7C_n6C'
% 'BEST_tavg_BIN_n6C_n5C'
% 'BEST_tavg_BIN_n5C_n4C'
% 'BEST_tavg_BIN_n4C_n3C'
% 'BEST_tavg_BIN_n3C_n2C'
% 'BEST_tavg_BIN_n2C_n1C'
% 'BEST_tavg_BIN_n1C_0C'
% 'BEST_tavg_BIN_0C_1C'
% 'BEST_tavg_BIN_1C_2C'
% 'BEST_tavg_BIN_2C_3C'
% 'BEST_tavg_BIN_3C_4C'
% 'BEST_tavg_BIN_4C_5C'
% 'BEST_tavg_BIN_5C_6C'
% 'BEST_tavg_BIN_6C_7C'
% 'BEST_tavg_BIN_7C_8C'
% 'BEST_tavg_BIN_8C_9C'
% 'BEST_tavg_BIN_9C_10C'
% 'BEST_tavg_BIN_10C_11C'
% 'BEST_tavg_BIN_11C_12C'
% 'BEST_tavg_BIN_12C_13C'
% 'BEST_tavg_BIN_13C_14C'
% 'BEST_tavg_BIN_14C_15C'
% 'BEST_tavg_BIN_15C_16C'
% 'BEST_tavg_BIN_16C_17C'
% 'BEST_tavg_BIN_17C_18C'
% 'BEST_tavg_BIN_18C_19C'
% 'BEST_tavg_BIN_19C_20C'
% 'BEST_tavg_BIN_20C_21C'
% 'BEST_tavg_BIN_21C_22C'
% 'BEST_tavg_BIN_22C_23C'
% 'BEST_tavg_BIN_23C_24C'
% 'BEST_tavg_BIN_24C_25C'
% 'BEST_tavg_BIN_25C_26C'
% 'BEST_tavg_BIN_26C_27C'
% 'BEST_tavg_BIN_27C_28C'
% 'BEST_tavg_BIN_28C_29C'
% 'BEST_tavg_BIN_29C_30C'
% 'BEST_tavg_BIN_30C_31C'
% 'BEST_tavg_BIN_31C_32C'
% 'BEST_tavg_BIN_32C_33C'
% 'BEST_tavg_BIN_33C_34C'
% 'BEST_tavg_BIN_34C_35C'
% 'BEST_tavg_BIN_35C_Inf'
% 
% 
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


%--------------POLYNOMIALS IN DAILY-TEMP, AGGREGATED CORR%ECTLY 
 %                                          (1/15/16 BY T. CARLETON)

% 'BEST_polynomial_1'
% 'BEST_polynomial_2' 
%  'BEST_polynomial_3' 
%  'BEST_polynomial_4' 
%  'BEST_polynomial_5' 
%  'BEST_polynomial_6' 
%  'BEST_polynomial_7' 
%  'BEST_polynomial_8' 
 
 %-------------DEGREE DAYS, AGGREGATED CORRECTLY 
 %                                          (1/15/16 BY T. CARLETON)
 %
% Field names for degree days in BEST (note this is standard degree days
% and degree days recentered around 15C for cooling and heating degree
% days) - computed using daily means, not sinusoidal interpolation

%normal degree days (define 0 as 0C)
% 'BEST_dd_DEGDAY_0'   
%  'BEST_dd_DEGDAY_5'
%  'BEST_dd_DEGDAY_10'
%  'BEST_dd_DEGDAY_15'
%  'BEST_dd_DEGDAY_20'
%  'BEST_dd_DEGDAY_25'
%  'BEST_dd_DEGDAY_30'
 
%  %cooling degree days (define 0 as 15C)
%  'BEST_cdd_DEGDAY_0'
%  'BEST_cdd_DEGDAY_5'
%  'BEST_cdd_DEGDAY_10'
%  'BEST_cdd_DEGDAY_15'
%  'BEST_cdd_DEGDAY_20'
%  
%  %heating degree days (define 0 as 15C)
%  'BEST_hdd_DEGDAY_0'
%  'BEST_hdd_DEGDAY_5'
%  'BEST_hdd_DEGDAY_10'
%  'BEST_hdd_DEGDAY_15'
%  'BEST_hdd_DEGDAY_20'
%  
 
 
 %-----THESE ARE USING ONLY THE AVG, NOT THE SUM (SUM IS CORRECT)
 %    'NCEP-dd0'
%     'NCEP-dd5'
%     'NCEP-dd10'
%     'NCEP-dd15'
%     'NCEP-dd20'
%     'NCEP-dd25'
%     'NCEP-dd30' 
%     'NCEP-cdd0'

%----------------------------AVG TEMP / PRECIP
 
%   'UDEL-temp1'
%    'UDEL-temp2'
%    'UDEL-temp3'
%    'UDEL-temp4'
% 
% 
    'UDEL-precip1'
    'UDEL-precip2'
    'UDEL-precip3'
    'UDEL-precip4'
%
%   'NCEP-temp'
%
%     'CMAP-precip'
%     'LICRICE-pddi'
%     'LICRICE-maxs'
%     'LICRICE-pddi-high-res'
%     'LICRICE-maxs-high-res'
%     'BOM-avg-temp'
%     'BOM-max-temp'
%     'BOM-min-temp'
%     'BOM-precip'
 
%------------------------------AEROSOLS AND CLOUDS

%      'SPARC-aerosol'
%      'NASA-aerosol'
%      'NASA-aerosol-Flipped'

%      'ISCCP-InsolationMonthTotal'
%      'ISCCP-PctDCloudy'
%      'ISCCP-PctICloudy'

%     'ISCCP-InsolationMonthTotal-TOA'
%     'ISCCP-InsolationMonthTotal-direct'
%     'ISCCP-InsolationMonthTotal-diffuse'
%     'ISCCP-InsolationMonthTotal-TOA-normalized'
%     'ISCCP-InsolationMonthTotal-direct-normalized'
%     'ISCCP-InsolationMonthTotal-diffuse-normalized'
%     'ISCCP-InsolationMonthTotal-normalized'
%     'ISCCP-InsolationMonthTotal-TOA'

% BINS THAT ARE 200 WATT-HRS WIDE
%'ISCCP_Insol_BIN_p0_p200'
% 'ISCCP_Insol_BIN_p200_p400'
% 'ISCCP_Insol_BIN_p400_p600'
% 'ISCCP_Insol_BIN_p600_p800'
% 'ISCCP_Insol_BIN_p800_p1000'
% 'ISCCP_Insol_BIN_p1000_p1200'
% 'ISCCP_Insol_BIN_p1200_p1400'
% 'ISCCP_Insol_BIN_p1400_p1600'
% 'ISCCP_Insol_BIN_p1600_p1800'
% 'ISCCP_Insol_BIN_p1800_p2000'
% 'ISCCP_Insol_BIN_p2000_p2200'
% 'ISCCP_Insol_BIN_p2200_p2400'
% 'ISCCP_Insol_BIN_p2400_p2600'
% 'ISCCP_Insol_BIN_p2600_p2800'
% 'ISCCP_Insol_BIN_p2800_p3000'
% 'ISCCP_Insol_BIN_p3000_p3200'
% 'ISCCP_Insol_BIN_p3200_p3400'
% 'ISCCP_Insol_BIN_p3400_p3600'
% 'ISCCP_Insol_BIN_p3600_p3800'
% 'ISCCP_Insol_BIN_p3800_p4000'
% 'ISCCP_Insol_BIN_p4000_p4200'


% BINS THAT ARE 100 WATT-HRS WIDE
%      'ISCCP_Insol_BIN_p0_p100'
%      'ISCCP_Insol_BIN_p100_p200'
%        'ISCCP_Insol_BIN_p200_p300'
%        'ISCCP_Insol_BIN_p300_p400'
%        'ISCCP_Insol_BIN_p400_p500'
%        'ISCCP_Insol_BIN_p500_p600'
%        'ISCCP_Insol_BIN_p600_p700'
%        'ISCCP_Insol_BIN_p700_p800'
%        'ISCCP_Insol_BIN_p800_p900'
%        'ISCCP_Insol_BIN_p900_p1000'
%        'ISCCP_Insol_BIN_p1000_p1100'
%        'ISCCP_Insol_BIN_p1100_p1200'
%        'ISCCP_Insol_BIN_p1200_p1300'
%        'ISCCP_Insol_BIN_p1300_p1400'
%        'ISCCP_Insol_BIN_p1400_p1500'
%        'ISCCP_Insol_BIN_p1500_p1600'
%        'ISCCP_Insol_BIN_p1600_p1700'
%        'ISCCP_Insol_BIN_p1700_p1800'
%        'ISCCP_Insol_BIN_p1800_p1900'
%        'ISCCP_Insol_BIN_p1900_p2000'

                };

N = length(variable_list);

fields = cell(N,1); %store cell arrays in mat file

for i = 1:N
    field =  variable_list{i};
    disp(['|-------------------------projecting ' field '-------------------------|'])
    
    
    %----------------------------------------------------------------------
    %project each dataset onto the shapefile
    %tabulate output
    x = project_weather_par(s, a, label, field); 
    
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
    
    email_me([field ' is done']);
    
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



