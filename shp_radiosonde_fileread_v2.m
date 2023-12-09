rpath = 'C:\Users\shpul\OneDrive\Documents\MATLAB\matlab_modtran\radiosonde_data';
rname = 'USM00072363-data.txt';

% INPUTS:
% rpath = path to IGRAv2 txt file
% rname = name of the IGRAv2 radiosonde txt file

ID = rname(1,1:11);
outpath = fullfile(rpath, ID);
if ~isfolder(outpath)
    mkdir(outpath);
else
    %delete all *.mat files from directory
end
fid = fopen(fullfile(rpath, rname));
dataline = [];
tline = fgetl(fid);
while ~feof(fid)
    
    if contains(tline, '#') % header line
        if ~isempty(dataline)
            %save data
            save(fullfile(outpath, outname), 'dataline', 'lat', 'lon');
            dataline = [];
        end
        yyyy = tline(1,14:17);
        mm = tline(1,19:20);
        dd = tline(1,22:23);
        hh = tline(1,25:26);
        rt = tline(1,28:31);
        lat = str2double(tline(1,56:62))/1e4;
        lon = str2double(tline(1,64:71))/1e4;
        outname = [ID '_' yyyy mm dd '_' hh '_' rt '.mat'];
        disp(outname);
        
        
    else
        ET = tline(1,4:8); % MMMSS w/o zero padding
        if strcmp(ET, '-9999')
            ETIME = -9999;
        else
            ss = str2double(ET(1,4:5));
            mm2ss = str2double(ET(1,1:3))*60;
            if isnan(mm2ss)
                ETIME = ss;
            else
                ETIME = mm2ss + ss;
            end
        end
        PRESS = str2double(tline(1,10:15));
        PFLAG = tline(1,16);
        GPH = str2double(tline(1,17:21));
        ZFLAG = tline(1,22);
        TEMP = str2double(tline(1,23:27))/10;
        TFLAG = tline(1,28);
        RH = str2double(tline(1,29:33))/10;
        if ETIME ~= -8888 && ETIME ~= -9999 && PRESS ~= -9999 && GPH ~= -8888 && GPH ~= -9999 && TEMP ~= -888.8 && TEMP ~= -999.9 && RH ~= -888.8 && RH ~= -999.9
            dataline = [dataline; [ETIME, PRESS,  GPH, TEMP, RH]];
        end
        
    end
    tline = fgetl(fid);
    % Save dataline matrix:
    % save(fullfile(outpath, outname), 'dataline');
    asdf = 1;
end
fclose(fid);

% ---------------------
% Data Record Format:
% ---------------------
% -------------------------------
% Variable        Columns Type
% -------------------------------
% LVLTYP1         1-  1   Integer -
% LVLTYP2         2-  2   Integer
% ETIME           4-  8   Integer
% PRESS          10- 15   Integer
% PFLAG          16- 16   Character
% GPH            17- 21   Integer
% ZFLAG          22- 22   Character
% TEMP           23- 27   Integer
% TFLAG          28- 28   Character
% RH             29- 33   Integer
% DPDP           35- 39   Integer
% WDIR           41- 45   Integer
% WSPD           47- 51   Integer
% -------------------------------



% ---------------------
% Header Record Format:
% ---------------------
% ---------------------------------
% Variable   Columns  Type
% ---------------------------------
% HEADREC       1-  1  Character
% ID            2- 12  Character
% YEAR         14- 17  Integer
% MONTH        19- 20  Integer
% DAY          22- 23  Integer
% HOUR         25- 26  Integer
% RELTIME      28- 31  Integer
% NUMLEV       33- 36  Integer
% P_SRC        38- 45  Character
% NP_SRC       47- 54  Character
% LAT          56- 62  Integer
% LON          64- 71  Integer
% ---------------------------------