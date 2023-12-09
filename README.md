# radiosonde

# shp_NearestStation.m
- input latseek (latitude) and lonseek (longitude) in decimal format w/West = negative number and South = negative number
- prints the nearest radiosonde station ID, coordinates, etc. to console
- seeks only nearest station that is current to the date the function is run

# script_download_radiosonde.m
- START HERE
- input latseek (latitude) and lonseek (longitude) in decimal format w/West = negative number and South = negative number
- calls shp_NearestStation.m
- seeks only 'data-y2d' radiosonde measurements which currently (DEC 2023) goes back a couple of years
- edit variable 'dpath' to point to where you want to save the radiosonde data
- downloads 'data-y2d' and unzips it to a text file
# script_radiosonde_fileread_v2.m

# script_radiosonde_plots.m

