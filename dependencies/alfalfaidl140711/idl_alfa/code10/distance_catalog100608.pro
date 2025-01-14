;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;+
; NAME:
;	DISTANCE_CATALOG
;
; PURPOSE:
;	Read in a variety of catalog types and produce output
;	that contains our best-guesstimate of the distance to the
;	objects.  Flexibility of inputs and user-friendliness is a priority
;
; CALLING SEQUENCE:
;	distance_catalog, input_data, basename
;
; INPUT PARAMETERS:
;	input_data	The data to find distances to. This can be one of several things:
;		1. string containing filename of a GALCAT or AGC catalog
;		2. string containing filename of a CSV containing data (see below for more information)
;		3. string containing filename of a list of AGC numbers
;		4. A structure of the form used for AGC catalog '.sav' files
;			
;
;	basename	A string containing the base (filename without extension) for the outputs;
;			there are multiple outputs files, depending on the type of input data
;			- For example, choosing 'catalog' for the basename with a GALCAT-style catalog
;			  produces the files 'catalog.table', 'catalog.info', and 'catalog.tex'
;
; EXAMPLE:
;	> distance_catalog, '/home/hatillo/ghallenbeck/a7620/canven_cat.agc', 'canven'
;	[creates output files in the current directory called canven.agc, containing a table, and canven.sav,
;	 which contains a structure with all the relevant data]
;
; OUTPUTS:
;	There are no IDL outputs, but several files will be made in the current directory (or the one indicated in basename)
;
; DEPENDS ON:
;	User must have several functions contained in @alfinit for DISTANCE_CATALOG to work properly
;
; DETAILED INFORMATION ON HOW CATALOG FILES NEED TO BE FORMATTED:
;	All of the GALCAT and AGC catalogs need to have their headers or the program will crash!
;	I am lazy, and so the program determines the file type via the headers!
;	Specifically, AGC input files have no headers, and GALCAT catalogs begin with '###'
;
;	Files which are just a list of AGC numbers must have as their first line 'AGC' and the rest of the lines containing
;	one AGC number per line
;
;	CSV files must have a header, which must contain certain columns:
;		AGC [optional]
;		One of the following:
;			COORD - the coordinates in 'HHMMSS.S+DDMMSS' or 'HHMMSSS+DDMMSS' format
;		  or
;			two columns: RA, DEC - coordinates in decimal degrees
;		VEL - the heliocentric velocity of the galaxy, in km/s
;	The columns can be in whatever order you like.
;
;	The rest of the CSV file should consist of lines with only that information (separated by commas)
;
;
;NOTES:
;	FLAGS ARE DEFINED AS FOLLOWS
;	FLOW MODEL FLAG: Flowmodel uses codes 0,1,2,3,10,11,12,13,20,21,22,23 and 30. If the flowmodel flag is -1, that means
;	the flowmodel was not at all employed in the distance determination for that object. Flow model flags are defined
;	in greater detail below.
;
;	DISTANCE SOURCE FLAG
;	-1 - no distance (High Velocity Cloud)	
;	99 - distance estimated using pure Hubble flow, using the object's CMB rest frame velocity and a
;		Hubble parameter H_0 = 70.0 km/s/Mpc. This applies to objects (or groups) with CMB frame
;		velocities greater than 6000 km/s. At the moment, the error on such a distance is given as 0.
;	98 - distance is from a primary distance measurement.
;	97 - object belongs to a group with a CMB rest frame velocity greater than 6000 km/s, so the distance
;		to the object was estimated using pure Hubble flow from the object's CMB frame velocity.
;	96 - object belongs to a group with a CMB rest frame velocity less than 6000 km/s, so the distance to
;		the object was estimated using the flow model and using the group's velocity.
;	95 - object belongs to a group, and one member has a primary distance, so all objects in the group
;		are assigned to that distance. ***THIS IS NOT EMPLOYED AT THE MOMENT BUT WILL BE IN THE FUTURE.***
;	94 - the object does not have a primary distance measurement, and does not belong to a group, so a flow
;		model distance is given.
;	93 - the object does not have a primary distance measurement, but does have a "hardwired" distance, so
;		that one is given
;
;	When a flowmodel is used, the flag is also given (for diagnosing troublesome spots). If the flowmodel flag
;	entry is -1, this means that the flow model was not used in determining the distance.
;	
;	********************************************
;	Flowmodel flags indicate possible problems with the distance (and error) obtained using the flow model. IF
;	the flowmodel flag is anything other than a 1, 10, or 20, it is probably worth investigating and thinking about.
;                       0: No distance found. Usually close to D=0Mpc
;                       1: Everything is fine, single valued distance
;                      2: Double valued distance
;                      3: Triple valued distance
;                      10: Assigned to Virgo Core
;                      11: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued 
;                      12: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued 
;                      13: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued 
;                      20: Assigned to GA Core
;                      21: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued
;                      22: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued
;                      23: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued
;                      30: Assigned to Core of Fornax cluster
;
; HISTORY:
;	Adapted from existing code                                            A.Martin      August 2007
;	One line correction to catalog output when primary distances are used S.Stierwalt   December 2007
;	Almost entirely rewritten	                                      G. Hallenbeck February - March 2010
;	Added "hardwired" distances	                                      G. Hallenbeck March 2010
;	Added CMB velocity to structure - First IDL ALFA release              G. Hallenbeck April 5, 2010
;	Added bugfix for when there are no HVCs in an ALFALFA catalog         G. Hallenbeck April 9, 2010
;	Fixed a bug when using list of AGC numbers and AGC structure          G. Hallenbeck Jun 8, 2010
;-
;
;
;
;
;
;
;
;
;Input file types to support:
;	CSV
;	AGC - formatted catalog
;	AGC data structure
;	GALCAT catalog
;
;	Outputs for:
;	AGC - AGCnum, Coords, Helvel,Dist,EDist,F1,F2
;	CSV - Same as above, but no AGCnum if not given
;	GALCAT - A bit more complicated
;
;	Creating a .sav file with the data would probably be a good idea...
;
;
;; CODE TABLE OF CONTENTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; A. Helper function dist_cat_readcsv
; B. Helper function dist_cat_readdatafile
; C. Helper function dist_cat_read_agc
; D. Helper function dist_cat_read_galcat
; E. Helper function dist_cat_format_agc
; F. Helper function dist_cat_format_agclist
;
; I. The main function, DISTANCE_CATALOG
; I.0. Definitions of constants
; I.1. Extract input data
; I.2. Calculate distances
; I.3. Produce output files




























PRO dist_cat_progbar, percent, length=length

common progressbar_timestart, timestart

timenow = systime(1)

length = (keyword_set(length))?length:40
per = percent/100.0

less = (floor(per*length)     eq 0)? '' : replicate('+', floor(per * length))
grea = (ceil ((1-per)*length) eq 0)? '' : replicate('-', ceil( (1-per)*length ))
bar = strmid(strjoin([less,grea]),0,length)

if (percent eq 0) then begin
	timestart = systime(1)
	estimate = '?'
endif else begin
	eta = (100.0/float(percent) - 1.0) * (timenow - timestart)
	hr = floor(eta / 3600.0) & eta mod= 3600.0
	min = floor(eta / 60.0) & eta mod= 60.0
	min = ((min lt 10)?('0'):(''))+strtrim(min,2)
	sec = floor(eta)
	sec = ((sec lt 10)?('0'):(''))+strtrim(sec,2)
	estimate = (strtrim(hr,2)+':') + min +':' + sec
endelse
print, format='(%"(' + bar + ') [' + strtrim(long(per*100.0),2) + '\%] remaining: '+estimate+'\r",$)'

END









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART A. HELPER FUNCTION DIST_CAT_READCSV ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This function reads a CSV file and formats it for the main program
; The ultimate goal is to have flexibility: users can either enter in just AGC numbers,
; just coordinates (in several formats).  This might take awhile, but I'm gonna do it, dammit!

FUNCTION DIST_CAT_READCSV, FILENAME

MAX_ENTRIES = 1000000
csvstr = {agc:0L, ra:0.0, dec:0.0, vel:0L}
data = replicate(csvstr, MAX_ENTRIES)
temp = csvstr
index = 0L
line = ''

; Find out how many entries are in the file
x = query_ascii(file_expand_path(filename), info)
entries = float(info.lines)

openr, in, filename, /get_lun

readf, in, line
headers = strsplit(line, ',', /extract)

AGC   = where(headers eq 'AGC')
RA    = where(headers eq 'RA')
DEC   = where(headers eq 'DEC')
COORD = where(headers eq 'COORD')
VEL   = where(headers eq 'VEL')

;if ( (RA eq -1 or DEC eq -1) and COORD eq -1) then begin
;	print, 'The file does not contain coordinate data.'
;	print, 'There must be a column labeled COORD or two columns with RA and DEC data.'
;	return, 0
;endif

while((eof(in) ne 1) and index lt MAX_ENTRIES) do begin
	readf, in, line

	items = strsplit(line,',',/extract)

	temp.agc = (AGC eq -1) ? -1L : long(items[AGC])
	
	if (VEL ne -1) then temp.vel = long(items[VEL])

	if (COORD ne -1) then begin
		tempcoord = getdec(items[COORD])
		temp.ra  = tempcoord[0]*15.0
		temp.dec = tempcoord[1]
	endif else if (RA ne -1 and DEC ne -1) then begin
		temp.ra  = float(items[RA])
		temp.dec = float(items[DEC])
	endif


	data[index] = temp

	index = index+1
endwhile
print, "Entries Read: "+strtrim(index,2)

free_lun, in

data = data[0:index-1]
data = {agcnum:data.agc, ra:data.ra, dec:data.dec, vel:data.vel, cmbvel:fltarr(n_elements(data)), $
  dist:fltarr(n_elements(data)), edist:fltarr(n_elements(data)), f1:intarr(n_elements(data)), f2:intarr(n_elements(data))}

return, data

END

























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART B. HELPER FUNCTION DIST_CAT_READDATAFILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This function reads data files (specifically AGC and GALCAT files)
; while giving the user feedback on how long it's going to take

FUNCTION DIST_CAT_READDATAFILE, FILENAME, DATASTRUC, FORMAT

; Replicate the data structure and initialize
MAX_ENTRIES = 1000000
data = replicate(datastruc, MAX_ENTRIES)
temp = datastruc
line = ''

openr, lun, filename, /get_lun

; Find out how many entries are in the file
x = query_ascii(file_expand_path(filename), info)
entries = float(info.lines)

index=0L
step = ceil(n_elements(data)/200)

while((eof(lun) ne 1) and index lt MAX_ENTRIES) do begin
	; Print an update (every % done)
	if (index mod step eq 0) then dist_cat_progbar, index/float(entries)*100.0

	; Read the next line into a string
	readf, lun, line
	; Skip commented lines (those with a #-sign at the beginning)
	if (strpos(line,'#') eq 0) then continue

	; Read the data into the structure
	reads, line, temp, format=format
	data[index] = temp

	index = index+1
endwhile

data = data[0:index-1]

free_lun, lun

print, 'Entries Read: '+strtrim(index,2)+'                                                    '

return, data

END


















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART C. HELPER FUNCTION DIST_CAT_READ_AGC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This procedure sets up a number of structures and the file format of an AGC catalog
; then calls dist_cat_readdatafile to do the actual reading of the file
; dist_cat_read_agc then takes the returned raw data and extracts velocity information
; and formats the coordinates into decimal degree right ascensions and declinations

PRO DIST_CAT_READ_AGC, FILENAME, RAW_DATA, DATA

; Define the structure and read format of the AGC catalog
agstr = {agcnumber:0L, which:'', rah:0, ram:0, ras10:0, sign:'', decd:0, decm:0, decs:0, a100:0, b100:0, mag10:0, $
  inccode:0, posang:0, description:'', bsteintype:0, vopt:0L, verr:0, extrc3:0L, extdirbe:0L, vsource:0L, $
  ngcic:'', flux100:0L, rms100:0, v21:0L, width:0L, widtherr:0, widthcode:'', telcode:'', detcode:0, $
  hisource:0, statuscode:0, snratio:0, ibandqual:0, ibandsrc:0, irasflag:0, icluster:0, hidata:0, $
  iposition:0, ipalomar:0, rc3flag:0, irotcat:0, newstuff:0}
agcform='(I6,A1,I2,I2,I3,A1,I2,I2,I2,I5,2I4,I2,I3,A8,I3,I6,I3,2I5,I3,A8,I5,I4,I5,I4,I2,A4,A1,i1,I2,I1,I3,I1,I2,I1,I2,5I1,I2)'

; Read the catalog file using the generic reader
raw_data = dist_cat_readdatafile(filename, agstr, agcform)

print, 'Extracting coordinate and velocity information...'

data = raw_data
; Convert coordinates to decimal format and pick correct velocity
ra = (data.rah + data.ram/60.0 + data.ras10/36000.0)*15.0
dec = data.decd + data.decm/60.0 + data.decs/3600.0

badvel = 0L
step = ceil(n_elements(data)/100)
for i = 0L, n_elements(data)-1 do begin

	if (i mod step eq 0) then dist_cat_progbar, i/float(n_elements(data)-1)*100

    dec[i] = dec[i]*((data[i].sign eq '+')?(1.0):(-1.0))

	if (data[i].v21 eq 0 and data[i].vopt eq 0) then begin
		badvel = badvel + 1
		;print,'No velocity information in catalog for AGC=',data[i].agcnumber,'. Continuing to next line.'
		continue
	end

	if (data[i].v21 eq 0 and data[i].vopt ne 0) then begin data[i].v21 = data[i].vopt
	endif else if (data[i].detcode eq 0 or data[i].detcode eq 2 or data[i].detcode eq 4 or data[i].detcode eq 5 or data[i].detcode eq 9) then $
	  data[i].v21 = data[i].vopt

	if (data[i].v21 eq 0) then begin
		badvel = badvel + 1
		;print,'Problem with velocity information for AGC=',data[i].agcnumber,'. Continuing to next line.'
	endif
endfor
print, 'Number of good entries: '+strtrim(n_elements(data)-badvel,2)+' ('+$
  strtrim( long((n_elements(data)-badvel)/float(n_elements(data)) *100.0), 2)+'%)                               '

; Only want data with usable velocity information
ra   = ra  [where(data.v21 ne 0)]
dec  = dec [where(data.v21 ne 0)]
data = data[where(data.v21 ne 0)]

raw_data = {agcnumber:data.agcnumber, rah:data.rah, ram:data.ram, $
  ras10:data.ras10, sign:data.sign, decd:data.decd, decm:data.decm, $
  decs:data.decs, v21:data.v21, vopt:data.vopt, detcode:data.detcode}

; Now, convert everything into a standardized format for this program
data = {AGCnum:data.agcnumber, ra:ra, dec:dec, vel:data.v21, cmbvel:fltarr(n_elements(data)), $
  dist:dblarr(n_elements(data)), edist:dblarr(n_elements(data)), f1:intarr(n_elements(data)), f2:intarr(n_elements(data))}

print, 'Done extracting data.'

END













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART D. HELPER FUNCTION DIST_CAT_READ_GALCAT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This procedure sets up a number of structures and the file format of a GALCAT catalog
; then calls dist_cat_readdatafile to do the actual reading of the file
; dist_cat_read_galcat then takes the returned raw data and extracts detection codes
; and formats the coordinates into decimal degree right ascensions and declinations

PRO DIST_CAT_READ_GALCAT, FILENAME, RAW_DATA, DATA

; Define the structure and read format of a GALCAT catalog
alfstr = {Object:'', AGC:0L, Other:'', ERah:0, ERam:0, ERas:0.0, EDS:'', EDecd:0, EDecm:0, EDecs:0, dRA:0.0, $
  dDEC:0.0, ORah:0, ORam:0, ORas:0.0, ODS:'', ODecd:0, ODecm:0, ODecs:0, hSize:0.0, v50:0L, Verr:0.0, W50:0.0, Werr:0.0, $
  flux:0.0, FluxErr:0.0, Sintmap:0.0, SN:0.0, rms:0.0, code:0, Grid:''}
ALFALFA = '(A17,1x,I6,1x,A8,2x,I2,I2,F4.1,A1,I2,I2,I2,1x,I3,1x,I3,2x,2I2,F4.1,A1,3I2,3x,F4.1,1x,I5,3x,I2,3x,I3,2x,I3,2x,F6.2,2x,F4.2,3x,F5.2,2x,F5.1,1x,F5.2,3x,I1,5x,A8)'

; Read the catalog file using the generic reader
raw_data = dist_cat_readdatafile(filename, alfstr, ALFALFA)

; Special ALFALFA/GALCAT consideration: only include code 1 and 2 objects.
raw_data = raw_data[where(raw_data.code eq 1 or raw_data.code eq 2 or raw_data.code eq 9)]
data = raw_data

; Extract coordinates in decimal format
ra  = (data.erah+data.eram/60.0+data.eras/3600.0)*15.0
dec = (data.edecd+data.edecm/60.0+data.edecs/3600.0)
for i=0L, n_elements(dec)-1 do begin
  dec[i] = dec[i] * ((data[i].eds eq '+')?(1.0):(-1.0))
endfor

; Now, convert everything into a standardized format for this program
data = {AGCnum:long(data.AGC), ra:ra, dec:dec, vel:data.v50, cmbvel:fltarr(n_elements(data)), $
  dist:dblarr(n_elements(data)), edist:dblarr(n_elements(data)), f1:intarr(n_elements(data)), f2:intarr(n_elements(data)), $
  code:data.code}

END
















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART E. DIST_CAT_FORMAT_AGC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO DIST_CAT_FORMAT_AGC, raw_data, data

data = raw_data
; Convert coordinates to decimal format and pick correct velocity
ra = (data.rah + data.ram/60.0 + data.ras10/36000.0)*15.0
dec = data.decd + data.decm/60.0 + data.decs/3600.0

print, 'Number of Entries: ', strtrim(n_elements(ra),2)


badvel = 0L
step = ceil(n_elements(ra)/100)
for i = 0L, n_elements(ra)-1 do begin

	if (i mod step eq 0) then dist_cat_progbar, i/float(n_elements(ra)-1)*100

    dec[i] = dec[i]*((data.sign[i] eq '+')?(1.0):(-1.0))

	if (data.v21[i] eq 0 and data.vopt[i] eq 0) then begin
		badvel = badvel + 1
		print,'No velocity information in catalog for AGC=',data.agcnumber[i],'. Continuing to next line.       '
		continue
	end

	if (data.v21[i] eq 0 and data.vopt[i] ne 0) then begin data.v21[i] = data.vopt[i]
	endif else if (data.detcode[i] eq 0 or data.detcode[i] eq 2 or data.detcode[i] eq 4 or data.detcode[i] eq 5 or data.detcode[i] eq 9) then $
	  data.v21[i] = data.vopt[i]

	if (data.v21[i] eq 0) then begin
		badvel = badvel + 1
		print,'Problem with velocity information for AGC=',data.agcnumber[i],'. Continuing to next line.         '
	endif
endfor
print, 'Number of good entries: '+strtrim(n_elements(ra)-badvel,2)+' ('+$
  strtrim( long((n_elements(ra)-badvel)/float(n_elements(ra)) *100.0), 2)+'%)                               '

; Only want data with usable velocity information
raw_data.rah   = raw_data.rah  [where(data.v21 ne 0)]
raw_data.ram   = raw_data.ram  [where(data.v21 ne 0)]
raw_data.ras10 = raw_data.ras10[where(data.v21 ne 0)]
raw_data.sign  = raw_data.sign [where(data.v21 ne 0)]
raw_data.decd  = raw_data.decd [where(data.v21 ne 0)]
raw_data.decm  = raw_data.decm [where(data.v21 ne 0)]
raw_data.decm  = raw_data.decm [where(data.v21 ne 0)]

ra             = ra            [where(data.v21 ne 0)]
dec            = dec           [where(data.v21 ne 0)]
data.agcnumber = data.agcnumber[where(data.v21 ne 0)]
data.v21       = data.v21      [where(data.v21 ne 0)]

; Now, convert everything into a standardized format for this program
data = {AGCnum:data.agcnumber, ra:ra, dec:dec, vel:data.v21, cmbvel:fltarr(n_elements(ra)), $
  dist:dblarr(n_elements(ra)), edist:dblarr(n_elements(ra)), f1:intarr(n_elements(ra)), f2:intarr(n_elements(ra))}

print, 'Done converting data.'

END





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART F. DIST_CAT_AGCLIST ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO DIST_CAT_AGCLIST, filename, raw_data, data

data = dist_cat_readcsv(filename)

print, format='("Restoring AGC information...",$)' 
common agcshare, agcdir
restore, agcdir+'agctotal.sav'
print, 'done.'

print, 'Matching AGC numbers with data...'

itemlist = lonarr(n_elements(data.AGCnum))

index = 0L
step = ceil(n_elements(data.AGCnum)/100)
for i = 0L, n_elements(data.AGCnum)-1 do begin
	if (i mod step eq 0) then dist_cat_progbar, i/float(n_elements(data.AGCnum)-1)*100
	
	temp = where(agctotal.AGCnumber eq data.AGCnum[i])
	if (n_elements(temp) ne 1) then begin
		print, 'Multiple entries for AGC #' + strtrim(data.AGCnum[i], 2) +'.  Using first entry.                         '
	endif else if (temp eq -1) then begin
		print, 'No entry for AGC #' + strtrim(data.AGCnum[i], 2) + '.  Skipping.                                         '
		continue
	endif

	itemlist[index] = temp[0]
	index = index + 1
endfor
itemlist = itemlist[0:index-1]

raw_data = agctotal
raw_data = {agcnumber:raw_data.agcnumber[itemlist], rah:raw_data.rah[itemlist], ram:raw_data.ram[itemlist], $
  ras10:raw_data.ras10[itemlist], sign:raw_data.sign[itemlist], decd:raw_data.decd[itemlist], decm:raw_data.decm[itemlist], $
  decs:raw_data.decs[itemlist], v21:raw_data.v21[itemlist], vopt:raw_data.vopt[itemlist], detcode:raw_data.detcode[itemlist]}

print, 'Formatting AGC information...                                                 '
dist_cat_format_agc, raw_data, data

END














;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PART I. MAIN PROGRAM DISTANCE_CATALOG ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO DISTANCE_CATALOG, input_data, basename
RESOLVE_ROUTINE, 'glactc', /NO_RECOMPILE
RESOLVE_ROUTINE, 'bprecess', /NO_RECOMPILE

;; PART I.0: DEFINITIONS OF CONSTANTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; These constants define the type of input file
AGC     = 0
GALCAT  = 1
CSV     = 2

; Hubble's constant (in km/s / Mpc)
H_0 = 70.0

; These define the distance flags
GROUP_HUBBLE_FLOW  = 97
GROUP_FLOW_MODEL   = 96
HARDWIRED_DISTANCE = 93
PRIMARY_DISTANCE   = 98
HUBBLE_FLOW        = 99
FLOW_MODEL         = 94
HVC                = -1

; How can you LIVE without booleans?
FALSE = 0
TRUE  = 1

;; PART I.1: GET THE INPUT DATA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; First, we need to determine what sort of input file it is
; There are two possible inputs: a string (filename) or a structure (restored 'agcXXX.sav' file)

; This checks if its a string
if (size(input_data, /type) eq 7) then begin
	; It was a string -> input_data is a filename
	; Time to extract the data
	line = ''			; Variables for read need to be initialized
	openr, in, input_data, /get_lun	; Open the file
	readf, in, line					; Read the first line to find header info
	free_lun, in					; Close it; let the other guys re-open it if they need.

	; Now, we need to figure out what type of file we're dealing with
	if (strpos(line,'###') ne -1) then begin		; GALCAT catalog
		print, format='("File is a GALCAT catalog.  Reading data...")'
		dist_cat_read_galcat, input_data, raw_data, data
		type = GALCAT
		print, 'Done reading file.'
		endif else if (strpos(line,',') ne -1) then begin				; CSV file
		print, format='("File is a CSV.  Extracting data...")'
		data = dist_cat_readcsv(input_data)

		if (size(data, /type) eq 2) then return

		type = CSV
		print, 'done.'
	endif else if (line eq 'AGC') then begin
		print, 'File is a list of AGC numbers. Extracting data...'

		dist_cat_agclist, input_data, raw_data, data
		type = CSV

	endif else begin						; AGC catalog
		print, format='("File is an AGC catalog.  Reading data...")'
		dist_cat_read_agc, input_data, raw_data, data
		type = AGC
	endelse

endif else begin	; It's an AGC object
	print, format='("Input is AGC object. Reformatting object...")'
	raw_data = input_data
	dist_cat_format_agc, raw_data, data
	type = AGC

endelse

print

;; PART I.2: CALCULATE DISTANCES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Load the arrays for checking against distance calibrators and group assignments
print, format='("Loading known distances...",$)'
knowndistances,calibagcnumber,calibdist,calibedist,hardagcnumber,harddist,hardedist,grpagcnumber,grpcmbvel
print, 'done.'
print

print, 'Calculating distances...'

dist = 0.0
edist = 0.0
f1 = 0
f2 = 0

step = ceil(n_elements(data.ra) / 100)
for i=0L, n_elements(data.ra)-1 do begin

	if (i mod step eq 0) then dist_cat_progbar, i/float(n_elements(data.ra)-1)*100

	;Initialize a bunch of variables
	disthard       = 0.0
	edisthard      = 0.0
	distflaghard   = 0
	distcalib      = 0.0
	edistcalib     = 0.0
	distflagcalib  = 0.0
	distflaggroup  = 0.0
	flowmodelflag  = (-1)
	velgrp_cmb     = 0.0
	cmbvel         = 0.0
	foundagroup    = FALSE

	; Calculate the CMB velocity of the object, for use in the .sav file
	; Shan wants the CMB velocity so she's going to get it!
	ra = data.ra[i]
	dec= data.dec[i]
	vel = data.vel[i]
	glactc,ra,dec,2000,l,b,1, /DEGREE	; Find galactic coordinates
	cmbvel = vhel_to_cmb(l,b) + vel     ; Calculate cmb velocity
	data.cmbvel[i] = cmbvel

	; CSV files don't necessarily have AGC numbers, so check!
	if (data.AGCnum[i] ne -1) then begin	

		; Check for primary distance of current entry
		AGCnum = data.AGCnum[i]
		distcalibs_check,AGCnum,calibagcnumber,calibdist,calibedist,distcalib,edistcalib,distflagcalib
		if (distcalib ne 0) then begin
			data.dist[i]  = distcalib
			data.edist[i] = edistcalib
			data.f1[i]    = -1
			data.f2[i]    = distflagcalib
			continue
		endif

		; Check for hardwired distance of current entry
		distcalibs_check,AGCnum,hardagcnumber,harddist,hardedist,disthard,edisthard,distflaghard
		if (disthard ne 0) then begin
			data.dist[i]  = disthard
			data.edist[i] = edisthard
			data.f1[i]    = -1
			data.f2[i]    = HARDWIRED_DISTANCE
			continue
		endif

		; Check for group assignment to current object
		grpassign_check,data.AGCnum[i],grpagcnumber,grpcmbvel,velgrp_cmb,distflaggroup
		if(distflaggroup EQ 97) then begin
			vel = velgrp_cmb
			foundagroup = TRUE
			; This just redefines the velocity; it'll get set with everyone else below
		end

	endif

	distance_guess_verbose, ra, dec, cmbvel, dist, edist, f1, f2, CMB=TRUE
	data.dist[i] = dist
	data.edist[i] = edist
	data.f1[i] = f1
	data.f2[i] = f2
	data.cmbvel[i] = cmbvel

	; If there's a group, the flag information is a little craftier than usual.
	if (foundagroup) then begin
		data.f2[i] = (data.f2[i] eq HUBBLE_FLOW) ? GROUP_HUBBLE_FLOW : GROUP_FLOW_MODEL
	endif
endfor

; Special processing for GALCAT: make all HVCs have distance of '0', and set flags
if (type eq GALCAT) then begin
	if (total(where(data.code eq 9)) ne -1) then begin
		data.dist [where(data.code eq 9)] =  0
		data.edist[where(data.code eq 9)] =  0
		data.f1   [where(data.code eq 9)] = -1
		data.f2   [where(data.code eq 9)] = HVC
	endif
endif

print, 'Done calculating distances.                                              '
print
;; PART I.3: PRODUCE OUTPUT FILES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print, 'Producing output files:'


if (type eq AGC or type eq CSV) then begin
	file = basename + '.agc'
	print, file
	openw, out, file, /get_lun

	; Make a header
	printf, out, '#AGCNUM     Coords   HelVel     Dist    EDist F1 F2'

	; Loop through the data to print the output
	step = ceil(n_elements(data.ra)/100.0)
	for i=0L, n_elements(data.ra)-1 do begin
		; Progress bar
		if (i mod step eq 0) then dist_cat_progbar, i/float(n_elements(data.ra))*100.0

		; Output printing from the old distance_catalog
		printf,out, data.AGCnum[i], raw_data.rah[i] , raw_data.ram[i],  raw_data.ras10[i], raw_data.sign[i], $
                  raw_data.decd[i], raw_data.decm[i], raw_data.decs[i], data.vel[i],   data.dist[i],     data.edist[i],$
		          data.f1[i], data.f2[i], $
                  format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
	endfor

	free_lun, out

endif else if (type eq GALCAT) then begin
	; Three outputs: one is a TeX file, one a table, and one containing the minimum data
	; Make filenames, open the files, and print the names
	texfile = basename +'.tex'
	tabfile = basename +'.table'
	inffile = basename +'.info'
	openw,texout, texfile, /get_lun
	openw,tabout, tabfile, /get_lun
	openw,infout, inffile, /get_lun
	print, texfile+', '+tabfile+', '+inffile

	; Make headers for each of the files
	header1='#Nr      AGC               HI Coords (J2000)               Opt Coords (J2000)         cz     W50  Werr  Sint   Serr     S/N     RMS      D     log(M) Code'
	header2='#                      RA                 Dec             RA               Dec        km/s                 Jykm/s                       Mpc     Msun'
	printf,tabout,header1
	printf,tabout,header2
	printf,infout,'#AGCNUM     Coords    HelVel     Dist    EDist F1 F2'

	; Loop through all the data
	logmasses = fltarr(n_elements(data.ra))
	step = ceil(n_elements(data.ra)/100.0)
	for i=0L, n_elements(data.ra)-1 do begin
		; Progress bar
		if (i mod step eq 0) then dist_cat_progbar, i/float(n_elements(data.ra))*100.0

		; Make strings for the coordinates
		raH=string(raw_data[i].ERah,format='(i02)')+' '+string(raw_data[i].ERam,format='(i02)')+' '+string(raw_data[i].ERas,format='(f04.1)')
		decH=raw_data[i].EDS+string(raw_data[i].EDecd,format='(i02)')+' '+string(raw_data[i].EDecm,format='(i02)')+' '+string(raw_data[i].EDecs,format='(i02)')

		raO=string(raw_data[i].ORah,format='(i02)')+' '+string(raw_data[i].ORam,format='(i02)')+' '+string(raw_data[i].ORas,format='(f04.1)')
		decO=raw_data[i].ODS+string(raw_data[i].ODecd,format='(i02)')+' '+string(raw_data[i].ODecm,format='(i02)')+' '+string(raw_data[i].ODecs,format='(i02)')

		;if the rao & deco strings are "00 00 00" and "+00 00 00", then that shouldn't be printed to the files
		if((raO eq '00 00 00.0') and (decO eq '+00 00 00')) then begin
			raO='        '
			decO='         '
		endif

		if (data.f2[i] ne HVC and data.dist[i] ne 0) then begin
			loghimass = string(alog10(235600.0*data.dist[i]*data.dist[i]*raw_data[i].flux), format='(F6.2)')
			distmpc   = string(data.dist[i], format='(F6.1)')
			logmasses[i] = loghimass
		endif else if (data.f2[i] ne HVC) then begin
			loghimass = '  -Inf'
			distmpc   = '   0.0'
			logmasses[i] = -999
 		endif else begin
			loghimass = '      '
			distmpc =   '      '
			logmasses[i] = -999
		endelse

		; Print to the TeX file
		printf,texout,(i+1),data.AGCnum[i],raH,decH,raO,decO,data.vel[i],raw_data[i].w50,raw_data[i].werr,raw_data[i].flux,raw_data[i].FluxErr,raw_data[i].SN,raw_data[i].rms,distmpc,loghimass,data.code[i],$
  		  format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',A6,' & ',A6,' & ',i1,2x,' \\')"

		; Print to the table file
		printf,tabout,(i+1),data.AGCnum[i],raH,decH,raO,decO,data.vel[i],raw_data[i].w50,raw_data[i].werr,raw_data[i].flux,raw_data[i].FluxErr,raw_data[i].SN,raw_data[i].rms,distmpc,loghimass,data.code[i],$
 		  format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,A6,2x,A6,2x,i1)"

		; Print to the info file the other data
		printf,infout,data.AGCnum[i],raw_data[i].Erah,raw_data[i].ERam,raw_data[i].ERas,raw_data[i].EDS,raw_data[i].EDecd,raw_data[i].EDecm,raw_data[i].EDecs,data.vel[i],data.dist[i],data.edist[i],data.f1[i],data.f2[i], $
		  format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,3X,F6.2,1X,F8.2,1X,I2,1X,I2)'

	endfor

	; Make new structure, including the himass
	data = {agcnum:data.agcnum, ra:data.ra, dec:data.dec, vel:data.vel, cmbvel:data.cmbvel, dist:data.dist, $
			edist:data.edist, f1:data.f1, f2:data.f2, code:data.code, loghimass:logmasses}

	free_lun, texout
	free_lun, tabout
	free_lun, infout

endif






; Produce a .sav file with the data structure in it
file = basename+'.sav'
print, file+'                                               '
varname = file_basename(basename)
; I'm using execute so that we have a variable that matches the filename
x = execute(varname + ' = data')
x = execute('save, ' + varname + ', filename=basename+".sav"')

print
print, 'Distance calculation complete.'
print

; We're done.  Let's take a nap.
END
