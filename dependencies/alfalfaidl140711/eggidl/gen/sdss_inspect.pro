;+
;NAME:
;	SDSS_INSPECT
;PURPOSE:
;   Allows the user to interactively select SDSS photometric and spectroscopic IDs
;   for AGC galaxies.
;
;   See sdss_inspect.readme for list of commands, or type
;   'help' at the prompt.
;
;   IMPORTANT: You MUST have write access to the directory this procedure is run
;   from, in order to download the SDSS images.
;
;
;
;CALLING SEQUENCE:
;   sdss_inspect, agcfile, outfile=outfile
;
;EXAMPLE:
;	sdss_inspect, '/home/hatillo/ghallenbeck/sdss-check/testfiles/test.agclist', outfile='test.sdss'
;
;INPUT:
;   agcfile     A file containing the AGC numbers of the galaxies to inspect
;               # can be used to 
;
;OPTIONAL INPUT:
;   outfile     The output file, containing the IDs and quality codes
;               If not specified, and the agcfile ends in '.agclist', then
;               the outfile will automatically be the input file with the
;               extension '.sdss'
;
;REVISION HISTORY:
;               Written by   G.Hallenbeck	May-June 2011
;-

PRO sdss_inspect, agcfile, outfile=outfile

	MAX_ENTRIES = 100000L
	line = ''

	openr, in, agcfile, /get_lun
	agclist = lonarr(MAX_ENTRIES)

	i = 0L
	while not(eof(in)) do begin
		readf, in, line
		if strpos(line, '#') ne -1 or strpos(line, 'AGC') ne -1 then continue

		agclist[i] = long(line)
;		print, agclist[i]
		i++
	endwhile
	agclist = agclist[0:i-1]

	if n_elements(outfile) eq 0 and strpos(agcfile, '.agclist') ne -1 then begin
		break = strpos(agcfile, '.agclist')
		outfile = strmid(agcfile,0,break)+'.sdss'
	endif

	openw, out, outfile, /get_lun
	printf, out, '#AGCnr     HI source       OC position   I P       SDSSname           PhotObjID             SpecObjID        u   g   r   i   z %light'

	for i=0L, n_elements(agclist)-1 do begin
		sdss_lookat, agclist[i], line
		printf, out, line
	endfor

	close, /all, /force

END
