
function [sd, sname, snid, latstation, lonstation] = shp_NearestStation(latseek, lonseek)

% Find the currently active radiosonde station nearest to latseek and lonseek

% lat and lon are +/- decimal format
% INPUTS:
% latseek = local latitude of interest
% lonseek = local longitude of interest
% OUTPUTS:
% sd = distance to nearest station
% sname = name of station (sname)
% snid =  station ID
% latstation = latitude of nearest active station
% lonstation = longitude of nearest active station

% current year
[currentYear,~,~,~,~,~] = datevec(now);

% Load Station Listings or download from the web
% stpath = '/home/snillup/Documents/MATLAB/matlab_modtran/radiosonde_data';
stpath = 'C:\Users\shpul\OneDrive\Documents\MATLAB\matlab_modtran\radiosonde_data';
stname = 'igra2-station-list.txt';

sturl = fullfile('https://www1.ncdc.noaa.gov/pub/data/igra/', stname);
if exist(fullfile(stpath, stname), 'file') < 1
    % download the station list
    options = weboptions('Timeout', 60, 'ContentType', 'text');
    rwebdata = websave(fullfile(stpath, stname), sturl, options);%download text file
end

% read station listing file
stacode = [];
lat = [];
lon = [];
alt = [];
lname = [];
obs_start = [];
obs_end = [];
numobs = [];
xpos = [];
ypos = [];
zpos = [];
fid = fopen(fullfile(stpath, stname));
while ~feof(fid)
    tline = fgetl(fid);
    %fixed format file (good MAY 2020)
    stacode = [stacode; tline(1,1:11)]; %station code
    lat = [lat; str2double(tline(1,13:20))]; %latitude
    lon = [lon; str2double(tline(1,22:30))]; %longitude
    alt = [alt; str2double(tline(1,32:37))]; %altitude
    lname = [lname; tline(1,39:71)]; %location name
    obs_start = [obs_start; str2double(tline(1,73:76))]; %1st year of observations
    obs_end = [obs_end; str2double(tline(1,78:81))]; %last year of observations
    numobs = [numobs; str2double(tline(1,83:88))]; %total number of observations
    
    r = cosd(str2double(tline(1,13:20)));
    xpos = [xpos; r*cosd(str2double(tline(1,22:30)))];
    ypos = [ypos; r*sind(str2double(tline(1,22:30)))];
    zpos = [zpos; sind(str2double(tline(1,13:20)))];
    
end
fclose(fid);

%% Find the closest station

rseek = cosd(latseek);
xseek = rseek*cosd(lonseek);
yseek = rseek*sind(lonseek);
zseek = sind(latseek);

dp = zeros(size(xpos,1),1);
for ctr = 1:size(xpos,1)
    dp(ctr,1) = xseek.*xpos(ctr,1) + yseek*ypos(ctr,1) + zseek*zpos(ctr,1);
end    

[dps, dspidx] = sort(dp, 'descend');
for cctr = 1:size(dps,1)
    if obs_end(dspidx(cctr),1) == currentYear
        closestcurrentindex = dspidx(cctr);
        break;
    end
end
% snid = str2double(stacode(closestcurrentindex,7:11)); %station id, numeric
snid = stacode(closestcurrentindex,:);
sname = strtrim(lname(closestcurrentindex,:)); % station name, string
% disp(['Station ID = ' num2str(snid)]);
disp(['Station Code = ' snid]);
disp(['Closest Station Loc = ' sname]);
disp(['Latest Observation = ' num2str(obs_end(closestcurrentindex,:))]);
%% Compute distance from input lat, lon to nearest current station
latstation = lat(closestcurrentindex, 1);
lonstation = lon(closestcurrentindex, 1);
% haversine model
Re = 6371;
phi1 = latseek*(pi/180);
phi2 = latstation*(pi/180);
dphi = (latstation - latseek)*(pi/180);
dlambda = (lonstation-lonseek)*(pi/180);
a = (sin(dphi/2))^2 + cos(phi1)*cos(phi2)*(sin(dlambda/2))^2;
c = 2*atan2(sqrt(a), sqrt(1-a));
d = Re*c;
sd = d*0.6214; %distance to nearest station, miles

disp(['Station Lat = ' num2str(latstation)]);
disp(['Station Lon = ' num2str(lonstation)]);

disp(['Distance to nearest station (Haversine) ' num2str(sd) ' miles']);