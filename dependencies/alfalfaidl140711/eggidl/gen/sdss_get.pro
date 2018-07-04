; SDSS_GET_AGC_DATA
;
; Calling Sequence:
;    sdss_get_agc_data, filename, photo=photo, spec=spec, fieldfile=fieldfile, savefile=savefile
;
; Required Arguments:
;    filename--  A file containing a list of AGC numbers, one to a line
;        The first line should just be the word 'AGC'
;
; Optional Arguments:
;    photo, spec-- Will be filled by the procedure by structures containing the
;        photometric and spectroscopic data, respectively
;    fieldfile-- A file containing the list of SDSS fields you want saved.
;        see /home/hatillo/ghallenbeck/sdss/settings.ini for more information
;        this file is also used if none is specified
;    savefile-- A filename that the structures will be saved to.  If left blank,
;        then the structures will not be saved, only returned to the variables
;        photo and spec.
;
; Example (runs on about 500 AGC numbers):
;
;    IDL> sdss_get_agc_data, '/home/hatillo/ghallenbeck/sdss/list-500', savefile='agcsdss.sav'
;    Reading file list of AGC numbers...done.
;
;    Querying SDSS Photometric Objects 100 entries at a time...
;    Finished with Query.
;
;    Extracting data from the query...
;    Finished extracting data.
;
;    Querying SDSS Spectroscopic Objects 100 entries at a time...
;    Finished with Query.
;
;    Extracting data from the query...
;    Finished extracting data.
;
;    The file 'agcsdss.sav' in the local directory now contains two structures: phot and spec
;
;
; Additional Notes:
;     This procedure should take about 15 minutes to run if used on the entire ALFALFA catalog.
;     It takes less than a minute for 500 AGC numbers
;
;     If you want the query to return more things, then you ONLY need to change the settings.ini file!
;     The queries and structures are built automagically! So you probably don't need to mess with this program!
;
;
;
; HISTORY:
;	July 2010	Created by ghallenbeck based on code by Shan Huang
;	


































; Converts the agc/sdss text crossfile into an IDL structure,
PRO sdss_generate_structure

; Common block that the agcsdss variable gets put into
COMMON sdss_common_data, agcsdss, query_base

; Define constants and initialize variables
;dirname = '/home/dorado3/galaxy/sdsscross/'
dirname = '/home/hatillo/ghallenbeck/sdss/'
MAX_ENTRIES = 1000000L
line = '' & i = 0L

; Make a template to read the file into
template = {AGC:0L, hisource:'', OCposition:'', Icode:0, Pcode:'', SDSSname:'', $
	photoObjID:ulong64(0), SpecObjID:ulong64(0), cz: double(0)}
data = replicate(template, MAX_ENTRIES)

; Open the crossfile. dirname should probably be dropped once this procedure is installed into the directory.
openr, in, dirname+'vccsdss.cross100705.txt', /get_lun

while ( not(eof(in)) ) do begin

	readf, in, line
	if (strpos(line, '#') ne -1) then continue	; Skip over commented lines

	; Some lines stop abruptly after the P-code.
	; This can be removed if that is ever changed
	if (strlen(line) le 100) then line += '                                                                                        '

	reads, line, template, format='(I6,1x,A17,1x,A15,1x,I1,1x,A1,1x,A19,3x,I18,3x,I18,6x,F12.10)'
	data[i] = template


	++i
endwhile

; Cut down to the data that we actually read and give it a nice name
data = data[0:i-1]
; This variable is automatically saved because of the COMMON block
agcsdss = data

close, in, /force

END








; This function just goes to the crosslist and finds the photo and spec object IDs for a given AGC number
; This way all of the crosslist information is hidden from the later functions.
FUNCTION sdss_fetch_ID, AGCnum, PHOTO=PHOTO, SPEC=SPEC

; Make sure the crosslist is initialized
COMMON sdss_common_data, agcsdss, query_base
if ( n_elements(agcsdss) eq 0 ) then sdss_generate_structure

index = ( where(agcsdss.AGC eq AGCnum) )[0]
if (index eq -1) then begin
	;print, 'No entry for AGC number '+strtrim(AGCnum, 2)
	RETURN, 0
endif

if ( n_elements(PHOTO) ne 0) then RETURN, agcsdss[index].photoObjID
if ( n_elements(SPEC ) ne 0) then RETURN, agcsdss[index].specObjID

RETURN, 0
END

;
; The function obj_parent finds the parent object for a given object ID, either photometric or spectroscopic
;
; For example:
;	IDL> print, obj_parent('587730775499407375', /PHOTO)
;   587730775499407374
;
FUNCTION sdss_obj_parent, objID, PHOTO=PHOTO, SPEC=SPEC

; Make sure input is given in correct format
if (n_elements(objID) eq 0) then message, 'Usage: parentID = obj_parent(objID, [/PHOTO], [/SPEC])'
if (n_elements(PHOTO) and n_elements(SPEC) ) then message, 'You must specify either PHOTO or SPEC, but not both.'
if (n_elements(PHOTO) eq 0 and n_elements(SPEC) eq 0) then message, 'You must specify either PHOTO or SPEC flag'

; Determine whether it is the spectroscoptic or photometric table we want
if (n_elements(PHOTO)) then table = 'PhotoObjAll' else table = 'SpecObjAll'

; Build the query
query = 'SELECT t.parentID FROM '+table+' t WHERE t.objID='+objID
; Execute the query
spawn, '/home/dorado3/galaxy/sdsscross/SQL_commandline_DR7.py -q "'+query+'"', qresult

; Was the query successful?  If so, it should be something like:
;	qresult[0] = 'parentID'
;	qresult[1] = '5490680934830304'
; If it fails:
;   qresult[0] = 'No objects have been found'
if (n_elements(qresult) ne 2) then begin
	message, 'Parent not found for objID '+objID+' in table '+table
	return, ''
endif

return, qresult[1]

END





FUNCTION sdss_filter, item
list = ['u','g','r','i','z']
result = ''

for i=0, n_elements(list)-1 do begin
	result+= item+'_'+list[i]+', '
endfor

RETURN, result
END

PRO sdss_build_query_base, settings_file

COMMON sdss_common_data, agcsdss, query_base

openr, in, settings_file, /GET_LUN
line = ''
query_base = ['SELECT ','SELECT ']


PHOTO = 0
SPEC  = 1
NONE  = 2

mode = NONE
while not(eof(in)) do begin

	readf, in, line

	; Skip comments
	if (strpos(line, '#') eq 0) then continue

	; Skip empty lines
	if (line eq '') then continue

	; Changing to a new mode
	if (strpos(line, '[Photometric]') ne -1) then begin
		mode = PHOTO
		continue
	endif
	if (strpos(line, '[Spectroscopic]') ne -1) then begin
		mode = SPEC
		continue
	endif

	; Is it a thing with several filters?
	if (strpos(line, '(ugriz)') ne -1) then begin
		query_base[mode] += sdss_filter(strmid(line,0,strpos(line,'(ugriz)')-1))
	endif else if (line ne '') then begin ; Just a normal object
		query_base[mode] += line + ','
	endif

endwhile

query_base[0] = strmid(query_base[0],0,strlen(query_base[0])-1)
query_base[1] = strmid(query_base[1],0,strlen(query_base[1])-1)
query_base += ' FROM ' + ['photoObjAll','specObjAll'] + ' WHERE '

close, in, /force

END


FUNCTION sdss_build_query, agclist, PHOTO=PHOTO, SPEC=SPEC

COMMON sdss_common_data, agcsdss, query_base

entries = n_elements(agclist)
goodones = 0L

IDcolName = (n_elements(PHOTO) ne 0)?('objID'):('specObjID')
query = (n_elements(PHOTO) ne 0)?(query_base[0]):(query_base[1])

; Make long list of 'OR's.
for i=0L, n_elements(agclist)-1 do begin ;entries-1 do begin
	ID = (n_elements(PHOTO) ne 0)?(sdss_fetch_ID(agclist[i], /PHOTO)):(sdss_fetch_ID(agclist[i], /SPEC))

	if (ID ne 0) then begin
		query += IDcolName+'='+strtrim(ID,2)+' OR '
		++goodones
	endif
	if (ID eq 0) then begin
		;print,'No SDSS object ID for AGC #'+strtrim(agclist[i],2)
	endif
endfor
; Chop off the last ' OR '
query = strmid(query,0,strlen(query)-4)

if ( total(goodones) eq 0) then RETURN, ''

RETURN, query
END

FUNCTION sdss_format_structure, agclist, query_result

; Build the template
filter = {u:0.0, g:0.0, r:0.0, i:0.0, z:0.0}
names = strsplit(query_result[0],',',/EXTRACT)
sample= strsplit(query_result[1],',',/EXTRACT)

filter_groups = intarr(n_elements(names))
filter_start  = intarr(n_elements(names))
nGroups = 0
template_def = 'template = {AGC:0L, '

for i=0, n_elements(names)-1 do begin

	; Is this one a 'filter'?  That is, are there 5 matching ones with '_u', '_g', etc in them?
	if( strpos(names[i],'_u') ne -1) then begin
		++nGroups
		filter_groups[i]       = nGroups
		filter_groups[i+1:i+4] = -nGroups
		template_def += strmid(names[i],0,strlen(names[i])-2) + ':filter, '
	endif
	; If this isn't part of a filter group, grab the name
	if( filter_groups[i] eq 0) then begin
		template_def += names[i] + ':0'

		; What type is this thing?
		; Is it a DOUBLE?
		if (strpos(sample[i],'.') ne -1) then template_def+='.0' $
		; Is it a REALLY LONG?
		else if (strlen(sample[i]) gt 4) then template_def+='ULL'

		template_def += ', '
	endif

endfor
template_def = strmid(template_def, 0, strlen(template_def)-2)+'}'

; Assign the structure definition to the variable TEMPLATE
worked = execute(template_def)
if not(worked) then RETURN, 0



; Loop over all of the entries
data = replicate(template, n_elements(query_result)-1)
for i=0L, n_elements(data)-1 do begin
	entry = strsplit(query_result[i+1],',', /EXTRACT)

	; Loop over all the names in the structure
	k = 1
	for j=0, n_elements(names)-1 do begin
		
		; Is it anything but a filter group?
		if ( filter_groups[j] eq 0 ) then begin
			; Assign the current index [j] in the (k)th member of the structure
			data[i].(k) = entry[j]
			++k
		endif
		; First entry in a filter group?
		if ( filter_groups[j] gt 0) then begin
			data[i].(k).u = entry[j]
			data[i].(k).g = entry[j+1]
			data[i].(k).r = entry[j+2]
			data[i].(k).i = entry[j+3]
			data[i].(k).z = entry[j+4]
			++k
		endif

	endfor

endfor

; This matches the AGC numbers with the entries
PHOTO = (names[0] eq 'objID')
j = 0L
for i=0L, n_elements(agclist)-1 do begin
	if (i mod 100 eq 0) then dist_cat_progbar, float(i)/float(n_elements(agclist))*100.
	objID = (PHOTO)?(sdss_fetch_ID(agclist[i],/PHOTO)):(sdss_fetch_ID(agclist[i],/SPEC))
	entry = ( where(data.(1) eq objID) )[0]

	; An entry is found!
	if (entry ne -1) then data[entry].AGC = agclist[i]

endfor




RETURN, data
END


; SDSS_WAIT
; Keeps track of how frequently queries have been made.
; If called more than 60 times within any 1:05 period,
; it makes you wait until it hasn't been called more than
; 60 times in the last 1:10 period.
; 
; SDSS complains if an IP address queries it more than 60
; times in 1:00, so this is just to be safe.

PRO sdss_wait

COMMON sdss_timer, times, query_no

if (n_elements(query_no) eq 0) then query_no = -1
++query_no

if (query_no eq 0) then times = systime(1)
if (query_no gt 0 and query_no lt 59) then times = [times, systime(1)]
if (query_no ge 60) then times = [times[1:*], systime(1)]

delta = times[n_elements(times)-1] - times[0]
if (delta le 65 and query_no ge 60) then begin

	wait_time = 70 - delta
	if( wait_time gt 1) then begin
		print, 'Too many queries in one minute: waiting for '+strtrim(floor(wait_time),2)+' seconds.                       '
		wait, wait_time	
	endif

endif

END








; SDSS_GET_AGC_DATA
PRO sdss_get_agc_data, filename, photo=photo, spec=spec, fieldfile=fieldfile, savefile=savefile

; Initializing Variables
step = 100
bigresult = ''

sdss_build_query_base, (n_elements(fieldfile) ne 0)?(fieldfile):('/home/hatillo/ghallenbeck/sdss/settings.ini')

;  Step 1:  Get the list of agcnumbers from the file
print, format='("Reading file list of AGC numbers...",$)'
agclist = read_ascii(filename, data_start=1)
agclist = long(agclist.field1)
print, 'done.' & print

; Step 2: Get photometry information from SDSS
print, 'Querying SDSS Photometric Objects '+strtrim(step,2)+' entries at a time...'
for i = 0L, n_elements(agclist)-1, step do begin
	dist_cat_progbar, float(i)/float(n_elements(agclist))*100.

	; Make sure we don't query SDSS more than 60 times per minute
	sdss_wait

	; Build a query of the next /step/ entries in the list
	query  = sdss_build_query(agclist[i:((n_elements(agclist)-1)< (i+step) )], /PHOTO)

	; Did building the query work?
	if (query ne '') then begin
		; Query the SDSS
		spawn, '/home/dorado3/galaxy/sdsscross/SQL_commandline_DR7.py -q "'+query+'"', result
		if (bigresult[0] eq '') then bigresult = result else $
		if (n_elements(result) gt 1) then bigresult = [bigresult, result[1:*]]
	endif

endfor
print, 'Finished with Query.                                                                                      '
print

; Step 3: Take the result from the query and reformat it into a structure.
print, 'Extracting data from the query...'
photo  = sdss_format_structure(agclist, bigresult)
print, 'Finished extracting data.                                                                                 '
print

; Step 4: Get spectroscopy information from SDSS
bigresult=''
print, 'Querying SDSS Spectroscopic Objects '+strtrim(step,2)+' entries at a time...'
for i = 0L, n_elements(agclist)-1, step do begin
	dist_cat_progbar, float(i)/float(n_elements(agclist))*100.

	; Make sure we don't query SDSS more than 60 times per minute
	sdss_wait

	; Build a query of the next /step/ entries in the list
	query  = sdss_build_query(agclist[i:((n_elements(agclist)-1)< (i+step) )], /SPEC)

	; Did building the query work?
	if (query ne '') then begin
		; Query the SDSS
		spawn, '/home/dorado3/galaxy/sdsscross/SQL_commandline_DR7.py -q "'+query+'"', result
		if (bigresult[0] eq '') then bigresult = result else $
		if (n_elements(result) gt 1) then bigresult = [bigresult, result[1:*]]
	endif

endfor
print, 'Finished with Query.                                                                                      '
print

; Step 5: Take the result from the query and reformat it into a structure.
print, 'Extracting data from the query...'
spec  = sdss_format_structure(agclist, bigresult)
print, 'Finished extracting data.                                                                                 '

; Step 6: Save to file, if necessary
if (n_elements(savefile) ne 0) then save, photo, spec, filename=savefile

END
