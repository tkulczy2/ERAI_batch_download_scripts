% TRMM precipitation data 1988-2015
iri_trmm = 'http://iridl.ldeo.columbia.edu/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/dods';
ncdisp(iri_trmm);
t = ncread(iri_trmm, 'T');
tm = double(t)+datenum(1998,1,1);
ixmin = min(find(year(tm)==2005));
ixmax = max(find(year(tm)==2005));
l = ixmax - ixmin;
p = ncread(iri_trmm, 'precipitation', [1 1 ixmin], [1440 400 l]);

% GHCN temperature and precipitation .... - 2004
iri_tmax = 'http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.GHCN_Daily/.version1/.TMAX/dods'
iri_tmin = 'http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.GHCN_Daily/.version1/.TMIN/dods'
iri_pcpn = 'http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.GHCN_Daily/.version1/.PCPN/dods'
iri_lat = 'http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.GHCN_Daily/.version1/.lat/dods'
iri_lon = 'http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.GHCN_Daily/.version1/.lon/dods'
lat = ncread(iri_lat, 'lat');
lon = ncread(iri_lon, 'lon');

% GSOD needs to be downloaded
