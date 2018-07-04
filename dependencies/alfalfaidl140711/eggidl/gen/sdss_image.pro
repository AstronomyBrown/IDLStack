;+
;NAME:
;	SDSS_IMAGE
;PURPOSE:
;	Imports images of a particular AGC galaxy into IDL
;	And possibly displays it, depending on user input
;
;CALLING SEQUENCE:
;	image = SDSS_IMAGE(ra, dec, [scale, opt, agc=agc, /show, /degrees])
;
;EXAMPLE:
;	image = SDSS_IMAGE(agc=331061, /show)
;	SDSS_IMAGE, agc=6990
;
;
;INPUTS:
;	ra, dec		The right ascension and declination of the galaxy,
;				in J2000 hours and degrees
;	scale		The number of arcseconds per pixel (defaults to 1)
;	size		The size of the image, in pixels (defaults to 501 if no AGC number
;				given; otherwise 2x optical radius)
;	opt			The SDSS options (the same as for SkyBrowser)
;	AGC			The AGC number of the galaxy.  If given, this overrides
;				the RA and DEC parameters
;
;KEYWORDS:
;	/show		Display an image of the galaxy, using tvscl
;	/degrees	The right ascension given is in degrees, rather than hours
;
;RETURNS:
;	image		A grayscale image of the galaxy
;
;REVISION HISTORY:
;       Written by   G.Hallenbeck	May 2011
;-

FUNCTION SDSS_IMAGE, ra, dec, scale=scale, size=size, opt=opt, agc=agc, show=show, degrees=degrees, color=color, depth=depth

	objSCALE  = (n_elements(scale) ne 0)?scale:0.4
	objOPT    = (n_elements(opt) ne 0)?opt:''
	objSIZE = (n_elements(size) ne 0)?size:501

	; Is the user just providing an AGC number?
	if n_elements(agc) ne 0 then begin
		
		; Load the AGC DATA, if needed
		common agcshare, agcdir
		common __agcdata, agctotal
		if n_elements(agctotal) eq 0 then restore, agcdir+'agctotal.sav'

		; Locate the AGC number of the galaxy of interest		
		index = (where(agctotal.agcnumber eq agc))[0]
		if index eq -1 then return, 1

		objRA   = (agctotal.rah[index] + agctotal.ram[index]/60. + agctotal.ras10[index]/60./60./10.)*15.
		objDEC  = agctotal.decd[index] + agctotal.decm[index]/60. + agctotal.decs[index]/60./60.
		objDEC *= (agctotal.sign[index] eq '+')?(1.):(-1.)
;		objSIZE = (agctotal.a100[index] > agctotal.b100[index])/100.*60./double(objSCALE)
;		print, objSIZE

		print, objRA, objDEC, objSIZE

	; Is the user giving us RA and DEC information?
	endif else begin
		objRA   = keyword_set(degrees)?ra:(ra*15.0)
		objDEC  = dec	

		print, objRA, objDEC, objSIZE
	endelse

	; Remove the previous 'tmp.jpg', for error checking
	spawn, 'rm -f tmp.jpg'

	; Create the wget command, piece by piece
	command  = "wget -q -O tmp.jpg '"
	command += 'http://casjobs.sdss.org/ImgCutoutDR7/getjpeg.aspx?'

	command += 'ra=' +strtrim(objRA,2) +'&'
	command += 'dec='+strtrim(objDEC,2)+'&'
	command += 'scale='+strtrim(objSCALE,2)+'&'
	command += 'width='+strtrim(objSIZE,2)+'&height='+strtrim(objSIZE,2)+'&'
	command += 'opt='+objOPT+"'"

	spawn, command
;	print, command

	; Double-check that the file loaded
	fail = file_test('tmp.jpg', /zero_length)

	; Was this the first attempt?  Attempt a second one!
	if fail and not(keyword_set(depth)) then begin
		print, 'Image retrieval unsuccessful -- trying a second time.'
		image = sdss_image(ra, dec, scale=scale, size=size, opt=opt, agc=agc, show=show, degrees=degrees, $
			color=color, /depth)
		return, image
	; Oh snap second attempt!
	endif else if fail then begin
		print, 'Image retrieval failed!'
		return, 0
	endif

	read_jpeg, 'tmp.jpg', image, grayscale=1-keyword_set(color)

	if keyword_set(show) then begin
		read_jpeg, 'tmp.jpg', timage, grayscale=1-keyword_set(color)
		dims = size(timage, /dim)
		window, 0, xsize=dims[1], ysize=dims[2], title='AGC '+strtrim(agc,2)
	;	tvscl, fancy_image, 1
		tvscl, timage, 0, true=1
	endif

	return, image

END

; A wrapper procedure if you'd prefer calling it that way for simplicity
PRO SDSS_IMAGE, agc, image, opt=opt
	if n_elements(opt) eq 0 then opt='GLIS'
	image = SDSS_IMAGE(agc=agc, opt=opt, /show, /color)
END
