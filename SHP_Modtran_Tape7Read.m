function [modrun] = SHP_Modtran_Tape7Read(fpath, fname)


freq = [];
ttrans = [];
trad = [];
modrun = struct;
fid = fopen(fullfile(fpath, fname));
ctr = 0; %line counter
while ~feof(fid)
    ctr = ctr + 1;
    tline = fgetl(fid);
    if ctr == 6
        %get range info
        geometry_info = regexp(tline, '\s+', 'split');
        obs_height = str2double(geometry_info(1,2));
        zenith_angle = str2double(geometry_info(1,4));
        slant_range = str2double(geometry_info(1,5));
        
    elseif contains(tline, 'FREQ')
        hdr_elements = regexp(tline, '\s+', 'split');
        fidx = find(contains(hdr_elements,'FREQ')) -1;
        tidx = find(contains(hdr_elements,'TOT_TRANS')) -1;
        ridx = find(contains(hdr_elements,'TOTAL_RAD')) -1;
        dline = fgetl(fid);ctr = ctr + 1;
        %loop over numerical rows of data
        while ~feof(fid) %strcmp(strtrim(dline), '-9999.')
            if ~strcmp(strtrim(dline), '-9999.')
            begidx = 1;
            endidx = strfind(tline, hdr_elements{1,2}) + size(hdr_elements{1,2},2) - 1;
            dval = str2double(dline(1,begidx:endidx));
            for fctr = 3:size(hdr_elements, 2)
                begidx = endidx+1;
                endidx = strfind(tline, hdr_elements{1,fctr}) + size(hdr_elements{1,fctr},2) - 1;
                dval = [dval, str2double(dline(1,begidx:endidx))];
            end
                        freq = [freq; dval(1,fidx)]; %frequency, cm-1
                        ttrans = [ttrans; dval(1,tidx)]; %total transmittance
                        trad = [trad; dval(1,ridx)]; % total radiance
            dline = fgetl(fid);ctr = ctr + 1;
            else
            end
        end
    end
end
fclose(fid);

if ctr > 12 
    %tp7 file has contents
wavelength = (1e4)./freq; %wavelength, microns
tradum = trad.*freq./wavelength;
modrun.wavelength = wavelength;
modrun.ttrans = ttrans;
modrun.trad = tradum;
modrun.obs_height = obs_height;
modrun.zenith_angle = zenith_angle;
modrun.slant_range = slant_range;
else
    modrun.wavelength = NaN;
    modrun.ttrans = NaN;
modrun.trad = NaN;
modrun.obs_height = NaN;
modrun.zenith_angle = NaN;
modrun.slant_range = NaN;
end






