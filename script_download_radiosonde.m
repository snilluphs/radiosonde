% latseek = 32.8897067;
% lonseek = -117.2261520;
% latseek = 21.9933;
% lonseek = -159.3467;
% latseek = 34.9091035; % Edwards AFB
% lonseek = -117.8821725; % Edwards AFB
% latseek = 33.5140573; % ABQ
% lonseek = -104.6867767; % ABQ
% latseek = 32.2169524; % Tucson
% lonseek = -110.9667378; % Tucson
latseek = 35.214517; % Amarillo, TX
lonseek = -101.837021;

% URL for full radiosonde data sets
% durl = 'https://www1.ncdc.noaa.gov/pub/data/igra/data/data-por/';

% URL for latest radiosonde data sets
durl = 'https://www1.ncdc.noaa.gov/pub/data/igra/data/data-y2d/';

[sd, sname, snid, slat, slon] = shp_NearestStation(latseek, lonseek);

% dname = ['./' snid '-data.txt.zip']; % full data set file name';
dname = [ snid '-data-beg2021.txt.zip']; % latest data set file name

% dpath = '/home/snillup/Documents/MATLAB/matlab_modtran/radiosonde_data';
dpath = 'C:\Users\shpul\OneDrive\Documents\MATLAB\matlab_modtran\radiosonde_data';
% fullurl = fullfile(durl, dname);
fullurl = [durl, dname];
options = weboptions('Timeout', 60);
rwebdata = websave(fullfile(dpath, dname), fullurl, options);%download zip file

unzip(fullfile(dpath, dname), dpath);

