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


PRO SDSS_QUERY, whereclause, result, table=table

	if n_elements(table) eq 0 then table='PhotoObjAll'

	query = 'SELECT objID, SpecObjID, nChild, parentID, u, g, r, i, z, err_u, err_g, err_r, err_i, err_z, ra, dec ' + $
		'FROM '+table+' WHERE '+whereclause

	sdss_wait
	spawn, '/home/dorado3/galaxy/sdsscross/SQL_commandline_DR7.py -q "'+query+'"', qresult

	; Clip the header
	qresult = qresult[1:n_elements(qresult)-1]

	MAX_CHILDREN = 100
	temp = {phot:0ULL, spec:0ULL, nChild:0L, parentID:0ULL, u:0.0, g:0.0, r:0.0, i:0.0, z:0.0, $
			uerr:0.0, gerr:0.0, rerr:0.0, ierr:0.0, zerr:0.0, ulight:0.0, glight:0.0, rlight:0.0, ilight:0.0,$
			zlight:0.0, ra:double(0.0), dec:double(0.0), cindex:intarr(25)-1, cid:ulon64arr(25)-1, primary:0}
	data = replicate(temp, n_elements(qresult))

	if n_elements(qresult) eq 0 then begin
		result = 0
		return
	endif

	for i=0L, n_elements(qresult)-1 do begin

		entry = strsplit(qresult[i], ',', /extract)

		temp.phot     = ulong64(entry[0])
		temp.spec     = ulong64(entry[1])
		temp.nChild   = long(entry[2])
		temp.parentID = ulong64(entry[3])
		temp.u        = float(entry[4])
		temp.g        = float(entry[5])		
		temp.r        = float(entry[6])
		temp.i        = float(entry[7])
		temp.z        = float(entry[8])
		temp.uerr     = float(entry[9])
		temp.gerr     = float(entry[10])		
		temp.rerr     = float(entry[11])
		temp.ierr     = float(entry[12])
		temp.zerr     = float(entry[13])
		temp.ra       = double(entry[14])
		temp.dec      = double(entry[15])

		data[i] = temp

	endfor

	; Clean up the worthless ones
	data = data[where(data.u ge 0)]

	result = data

END

PRO SDSS_QUERY_SPEC, whereclause, result

	query = 'SELECT  ra, dec, specObjID ' + $
		'FROM SpecObj WHERE '+whereclause

	sdss_wait
	spawn, '/home/dorado3/galaxy/sdsscross/SQL_commandline_DR7.py -q "'+query+'"', qresult

	; Empty result?
	if n_elements(qresult) eq 1 && qresult eq 'No objects have been found' then begin
		result = 0
		return
	endif

	; Clip the header
	qresult = qresult[1:n_elements(qresult)-1]

	MAX_CHILDREN = 100
	temp = {spec:0ULL, ra:double(0.0), dec:double(0.0)}
	data = replicate(temp, n_elements(qresult))

	if n_elements(qresult) eq 0 then begin
		result = 0
		return
	endif

	for i=0L, n_elements(qresult)-1 do begin

		entry = strsplit(qresult[i], ',', /extract)

		temp.ra       = double(entry[0])
		temp.dec      = double(entry[1])
		temp.spec     = ulong64(entry[2])

		data[i] = temp

	endfor

	; Clean up the worthless ones
;	data = data[where(data.u ge 0)]

	result = data

END


PRO sdss_image_plot, scale, size, ra, dec, galaxy, ct=ct, color=color, tag=tag

	if n_elements(color) ne 0 then loadct, 13, /silent else loadct, 0, /silent

	plotgals = galaxy[sort(galaxy.u+galaxy.g+galaxy.r+galaxy.i+galaxy.z)]
	plotchar = ''

	for i=0L, n_elements(plotgals)-1 do begin
		; Distance from center, in degrees
		offsetx = -(plotgals[i].ra - ra)		; Negative because RA increases to left
		offsety = (plotgals[i].dec - dec)		; Negative because IDL counts from top
		; Distance from center, in pixels
		offsetx *= 60.*58./scale
		offsety *= 60.*60./scale
		; Actual location, in pixels
		offsetx += size/2+2.
		offsety += size/2
		; Round so it looks pretty
		offsetx = floor(offsetx)+0.5
		offsety = floor(offsety)

		if keyword_set(tag) and i lt 3 then plotchar = strtrim(i+1,2) else plotchar = 'o'

		if n_elements(color) ne 0 then begin
			xyouts, offsetx-1, offsety-6, plotchar, alignment=0.5, /device, size=2, color=color
		endif else begin
			xyouts, offsetx-1, offsety-6, plotchar, alignment=0.5, /device, size=2
		endelse

	endfor

END

PRO SDSS_MARKUP, agc, galaxy, child, specID, silent=silent

	; Load the AGC DATA, if needed
	common agcshare, agcdir
	common __agcdata, agctotal
	if n_elements(agctotal) eq 0 then restore, agcdir+'agctotal.sav'

	; Load the user settings or set the defaults
	common inspectdata, opt, showALL
	if n_elements(opt) eq 0 then begin
		opt = 'IS'
		showALL = 0
	endif

	; Locate the AGC number of the galaxy of interest		
	index = (where(agctotal.agcnumber eq agc))[0]
	if index eq -1 then return

	ra = (agctotal.rah[index] + agctotal.ram[index]/60. + agctotal.ras10[index]/60./60./10.)*15.
	dec  = agctotal.decd[index] + agctotal.decm[index]/60. + agctotal.decs[index]/60./60.
	dec *= (agctotal.sign[index] eq '+')?(1.):(-1.)

	scale = 0.4	; Scale of final image, in arcsec/pixel
	; Object radius, in arcsec
	diameter = (agctotal.a100[index] > agctotal.b100[index])/100.*60.
	; Image size is the larger of 1.5 x diameter or 128 pixels (the smallest SDSS will give you)
	
	size = ceil(diameter*2/double(scale)) > 510
;	print, size

	image = sdss_image(ra, dec, scale=scale, size=size, opt=opt, /deg, /color)
	;fancy_image = sdss_image(ra, dec, scale=scale, size=size, opt='GLIP', /deg)

	; Get the photo objects in this region, and display them according to parent
	sdss_region_data, ra, dec, diameter*3>60, galaxy, allobjs, primary, specID

	device, decomposed=0, retain=2
	loadct, 0, /silent

	dims = size(image, /dim)
	window, 0, xsize=dims[1], ysize=dims[2], title='AGC '+strtrim(agc,2)
;	tvscl, fancy_image, 1
	tvscl, image, 0, true=1

	; Find the 1st, 2nd, and 3rd brightest children (by average ugriz color)
	cIndex = where(galaxy.nChild eq 0)
	if (cIndex[0] ne -1) then begin
		child = galaxy[cIndex]
		child = child[sort(child.r)]
	endif
	
	; Plot circles on the relevant features
	if strpos(opt, 'I') eq -1 then begin
		if showALL then	sdss_image_plot, scale, size, ra, dec, allobjs, color=0	; All photo objects
		sdss_image_plot, scale, size, ra, dec, primary, color=50				; The other top-level objects
		if n_elements(child) ne 0 then $
		sdss_image_plot, scale, size, ra, dec, child, color=150, /tag			; The children of the primary
		sdss_image_plot, scale, size, ra, dec, galaxy[0], color=255				; The primary = closest top-level to (ra,dec)	
	endif else begin

		if showALL then	sdss_image_plot, scale, size, ra, dec, allobjs, color=150	; All photo objects
		sdss_image_plot, scale, size, ra, dec, primary, color=0						; The other top-level objects
		if n_elements(child) ne 0 then $
		sdss_image_plot, scale, size, ra, dec, child, color=50, /tag				; The children of the primary
		sdss_image_plot, scale, size, ra, dec, galaxy[0], color=255					; The primary = closest top-level to (ra,dec)	
	endelse

;	radius = 1
;	strucElem = SHIFT(DIST(2*radius+1), radius, radius) LE radius
;	openImg = MORPH_OPEN(image, strucElem, /GRAY) 
;	TVSCL, openImg, 1 

;	stop

	if n_elements(child) ne 0 then galaxy = [galaxy[0], child]

END




PRO SDSS_REGION_DATA, ra, dec, radius, galaxy, alldata, primary, specID

;objID, SpecObjID, nChild
;modelMag_u, modelMag_g, modelMag_r, modelMag_i, modelMag_z

	rsec = radius/60./60.

	whereclause = '(ra BETWEEN '+strtrim(ra-rsec,2)+' AND '+strtrim(ra+rsec,2)+ $
	' AND dec BETWEEN '+strtrim(dec-rsec,2)+' AND '+strtrim(dec+rsec,2)+')'

	sdss_query, whereclause, data

	; Find the closest photometric object from PhotoObj
	dists   = (data.ra - ra)^2 + (data.dec - dec)^2
	closest = (where(dists eq min(dists)))[0]

	; Find the top parent object
	done = 0
	while (data[closest].parentID ne 0 and not(done)) do begin
		newclosest = where(data.phot eq data[closest].parentID)
		if newclosest[0] eq -1 then begin
			print, "Closest object's parent not in field.  Returning only closest object."
			primary = data[(where(dists eq min(dists)))[0]]
			galaxy = primary
			alldata = data
			specID = 0
			return
		endif
		closest = newclosest
	endwhile
	primary = data[closest]

	; Cross-reference parents with their children
	parent = where(data.nChild ne 0)
	for i=0L, n_elements(parent)-1 do begin
		if parent[0] eq -1 then continue

		mine = where(data.parentID eq data[parent[i]].phot)

		if mine[0] ne -1 then begin
			data[parent[i]].cindex = mine
			data[parent[i]].cid = data[mine].phot
		endif

	endfor

	; Take the parent and enumerate ALL of its children
	MAX_MEMBERS = 1000L
	galaxy = replicate(data[0], MAX_MEMBERS)
	entries = 1
	items = closest

	; This section involves a bunch of nonsense because the children
	; Can be evaluated recursively
	i = 0L
	while i le entries-1 do begin
		galaxy[i] = data[items[i]]
		
		; Oh snap does this one have children?
		if galaxy[i].nChild ne 0 and galaxy[i].cindex[0] ne -1 then begin
			found_children = n_elements(where(galaxy[i].cindex ne -1))
			entries += found_children
			items = [items, galaxy[i].cindex[0:found_children-1]]
		endif
		i++
	endwhile

	galaxy = galaxy[0:entries-1]

	; Calculate the percentage of light in each object

	toplevel = where(data.parentID eq 0)
	primary = data[toplevel]

	alldata = data

	gotspec = (where(galaxy.spec ne 0))[0]
	if gotspec ne -1 then begin
		specID = galaxy[gotspec].spec
	endif else begin

		sdss_query_spec, whereclause, sdata
		; Find the closest spectroscopic object
		if size(sdata, /tname) ne 'INT' then begin
			specdists = (sdata.ra - ra)^2 + (sdata.dec - dec)^2
			specclosest = (where(specdists eq min(specdists)))[0]
			specID = sdata[specclosest].spec
		endif else specID = 0

	endelse

END

PRO sdss_totallight, agc, galaxy, child, specID, zeroed

	; Percentage of light in each band
	counthese = where(1-zeroed)
	totalu = total(10.^(-child[counthese].u/2.5))
	totalg = total(10.^(-child[counthese].g/2.5))
	totalr = total(10.^(-child[counthese].r/2.5))
	totali = total(10.^(-child[counthese].i/2.5))
	totalz = total(10.^(-child[counthese].z/2.5))

	child.ulight = fix(10.^(-child.u/2.5)/totalu*100.)
	child.glight = fix(10.^(-child.g/2.5)/totalg*100.)
	child.rlight = fix(10.^(-child.r/2.5)/totalr*100.)
	child.ilight = fix(10.^(-child.i/2.5)/totali*100.)
	child.zlight = fix(10.^(-child.z/2.5)/totalz*100.)

	if (where(zeroed))[0] ne -1 then begin
		child[where(zeroed)].ulight = 0
		child[where(zeroed)].glight = 0
		child[where(zeroed)].rlight = 0
		child[where(zeroed)].ilight = 0
		child[where(zeroed)].zlight = 0
	endif

	galaxy[0].ulight = fix(10.^(-galaxy[0].u/2.5)/totalu*100.)
	galaxy[0].glight = fix(10.^(-galaxy[0].g/2.5)/totalg*100.)
	galaxy[0].rlight = fix(10.^(-galaxy[0].r/2.5)/totalr*100.)
	galaxy[0].ilight = fix(10.^(-galaxy[0].i/2.5)/totali*100.)
	galaxy[0].zlight = fix(10.^(-galaxy[0].z/2.5)/totalz*100.)

	print, 'AGC#: '+strtrim(agc,2)
	print, 'Parent Photo ID:       '+strtrim(galaxy[0].phot,2)
	print, 'Best Spectroscopic ID: '+strtrim(specID,2)
	print, 'Number of Children: '+ strtrim(n_elements(child),2)
	print

	print, format='("Object        u          g          r          i          z       u   g   r   i   z light%")'
;	print, format='("--------------------------------------")'
	print, galaxy[0].u, galaxy[0].uerr, galaxy[0].g, galaxy[0].gerr, galaxy[0].r, galaxy[0].rerr, $
			galaxy[0].i, galaxy[0].ierr, galaxy[0].z, galaxy[0].zerr, galaxy[0].ulight, galaxy[0].glight, galaxy[0].rlight,$
			galaxy[0].ilight, galaxy[0].zlight,$
		   format='("Parent    ",F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",1x,I3,1x,I3,1x,I3,1x,I3,1x,I3)'
	if n_elements(child) gt 0 then $
	print, child[0].u, child[0].uerr, child[0].g, child[0].gerr, child[0].r, child[0].rerr, $
			child[0].i, child[0].ierr, child[0].z, child[0].zerr, child[0].ulight, child[0].glight, child[0].rlight,$
			child[0].ilight, child[0].zlight,$
		   format='("1st Child ",F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",1x,I3,1x,I3,1x,I3,1x,I3,1x,I3)'
	if n_elements(child) gt 1 then $
	print, child[1].u, child[1].uerr, child[1].g, child[1].gerr, child[1].r, child[1].rerr, $
			child[1].i, child[1].ierr, child[1].z, child[1].zerr, child[1].ulight, child[1].glight, child[1].rlight,$
			child[1].ilight, child[1].zlight,$
		   format='("2nd Child ",F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",1x,I3,1x,I3,1x,I3,1x,I3,1x,I3)'
	if n_elements(child) gt 2 then $
	print, child[2].u, child[2].uerr, child[2].g, child[2].gerr, child[2].r, child[2].rerr, $
			child[2].i, child[2].ierr, child[2].z, child[2].zerr, child[2].ulight, child[2].glight, child[2].rlight,$
			child[2].ilight, child[2].zlight,$
		   format='("3rd Child ",F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",1x,I3,1x,I3,1x,I3,1x,I3,1x,I3)'

	for i=3, (n_elements(child)-1)<9 do begin
	print, (i+1),child[i].u, child[i].uerr, child[i].g, child[i].gerr, child[i].r, child[i].rerr, $
			child[i].i, child[i].ierr, child[i].z, child[i].zerr, child[i].ulight, child[i].glight, child[i].rlight,$
			child[i].ilight, child[i].zlight,$
		   format='(I1,"th Child ",F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",2x,F4.1,"(",F3.1,")",1x,I3,1x,I3,1x,I3,1x,I3,1x,I3)'
	endfor


END
