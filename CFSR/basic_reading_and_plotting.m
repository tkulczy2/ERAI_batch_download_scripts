% make sure to addpath to m_map if necessary 
%addpath('/home/tkulczycki/bin/matlab/m_map/');
% read data for a single time step of the entire globe
nc=ncgeodataset('tmax.gdas.198702.grb2')
varname = 'Maximum_temperature_height_above_ground_Mixed_intervals_Interval';
s = nc.size(varname);
data = nan(s(1),s(3),s(4));
for i = 1:s(1)
    slice = double(squeeze(nc{varname}(i,:,:,:)));
    data(i,:,:) = slice;
end
data = double(squeeze(data));
lat = double(nc{'lat'}(:));
lon = double(nc{'lon'}(:));
% reorder longitude so the map displays better
lon = lon - 360.*(lon>180);
data = cat(2, data(:,lon<0,:), data(:,lon>0,:));
lon = [lon(lon<0); lon(lon>0)];
% create map
m_proj('mollweide','lat',[min(lat(:)) max(lat(:))],'lon',[min(lon(:)) max(lon(:))]);
m_pcolor(lon,lat,data);
shading flat;
m_coast('line');
m_grid('box','fancy');