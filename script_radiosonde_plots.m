% apath = '/home/snillup/Documents/MATLAB/matlab_modtran/radiosonde_data/USM00072293';
% aname = 'USM00072293_20231005_00_2312.mat';
% apath = '/home/snillup/Documents/MATLAB/matlab_modtran/radiosonde_data/USM00091165';
% aname = 'USM00091165_20231004_00_2302.mat';
apath = 'C:\Users\shpul\OneDrive\Documents\MATLAB\matlab_modtran\radiosonde_data\USM00072363';
aname = 'USM00072363_20231107_12_1105.mat';

S = load(fullfile(apath, aname));
dataline = S.dataline;
lat = S.lat;
lon = S.lon;

tC = dataline(:,4);
alt_feet = dataline(:,3)*3.28084;
t_min = dataline(:,1)/60;
rh = dataline(:,5);
p_atm = dataline(:,2)*0.000145038;

utc_raw_str = cell2mat(regexp(aname, '(?<=_)(\d{4})(?=\.mat)', 'match'));
time_offset = round(lon/15);
hh = str2double(utc_raw_str(1,1:2));
lhh = hh + time_offset;
if lhh < 0
    lhh = lhh + 24;
elseif lhh > 24
    lhh = 24 - lhh;
end
local_str = cat(2, num2str(lhh), ':', utc_raw_str(1,3:4));
utc_str = cat(2, utc_raw_str(1,1:2), ':', utc_raw_str(1,3:4));

figure(1);
hold on
plot(tC, alt_feet, '-', 'LineWidth', 2);
text(0.5,0.95, ['Lat = ' num2str(lat) ' ^o'], 'Units', 'normalized');
text(0.5,0.9, ['Lon = ' num2str(lon) ' ^o'], 'Units', 'normalized');
text(0.5,0.85, ['UTC = ' utc_str], 'Units', 'normalized');
text(0.5,0.8, ['Local = ' local_str], 'Units', 'normalized');
xlabel('Temperature (^o C)'); ylabel('Altitude (feet)');
grid on;
set(gca, 'FontSize', 12);

fit_min = polyfit(t_min,alt_feet,1);
rate_min = fit_min(1,1);
rate_sec = rate_min/60;

figure(2);
hold on;
plot(t_min, alt_feet, '-', 'LineWidth', 2);
text(0.05,0.9, ['Rate of Climb = ' num2str(round(rate_sec)) ' feet/sec'], 'Units', 'normalized');
text(0.05,0.85, ['Lat = ' num2str(lat) ' ^o'], 'Units', 'normalized');
text(0.05,0.8, ['Lon = ' num2str(lon) ' ^o'], 'Units', 'normalized');
text(0.05,0.75, ['UTC = ' utc_str], 'Units', 'normalized');
text(0.05,0.7, ['Local = ' local_str], 'Units', 'normalized');
xlabel('Time (min)'); ylabel('Altitude (feet)');
grid on;
set(gca, 'FontSize', 12);


figure(3);
hold on;
plot(rh, alt_feet, '-', 'LineWidth', 2);
% text(0.05,0.9, ['Rate of Climb = ' num2str(round(rate_sec)) ' feet/sec'], 'Units', 'normalized');
text(0.05,0.85, ['Lat = ' num2str(lat) ' ^o'], 'Units', 'normalized');
text(0.05,0.8, ['Lon = ' num2str(lon) ' ^o'], 'Units', 'normalized');
text(0.05,0.75, ['UTC = ' utc_str], 'Units', 'normalized');
text(0.05,0.7, ['Local = ' local_str], 'Units', 'normalized');
xlabel('Relative Humidity'); ylabel('Altitude (feet)');
grid on;
set(gca, 'FontSize', 12);

figure(4);
hold on;
plot(p_atm, alt_feet, '-', 'LineWidth', 2);
% text(0.05,0.9, ['Rate of Climb = ' num2str(round(rate_sec)) ' feet/sec'], 'Units', 'normalized');
text(0.05,0.85, ['Lat = ' num2str(lat) ' ^o'], 'Units', 'normalized');
text(0.05,0.8, ['Lon = ' num2str(lon) ' ^o'], 'Units', 'normalized');
text(0.05,0.75, ['UTC = ' utc_str], 'Units', 'normalized');
text(0.05,0.7, ['Local = ' local_str], 'Units', 'normalized');
xlabel('Pressure (psi)'); ylabel('Altitude (feet)');
grid on;
set(gca, 'FontSize', 12);
