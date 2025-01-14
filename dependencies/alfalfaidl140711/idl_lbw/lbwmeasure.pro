;+
;NAME:
;  lbwmeasure - Measure qualities of an LBW-taken spectrum
;SYNTAX: readlbw, lbwfile, outfile=outfile
;ARGS:
;       lbwfile  : the file containing the LBW spectrum
;DESCRIPTION:
;  Use an LBW file to calculate spectral features:
;    - Integrated flux density
;    - Systemic velocity
;    - Source width
;    - Signal to noise
;  Be sure to run masklbw and lbwbaseline before using this program!
;
;HISTORY:
;
;   GH: Jan13    Original version
;   GH: Dec13    Updated to fit arbitrary resolution data
;   LL: 10Dec13  Updated to include gaussian fitting option
;   GH: 22Dec13  Updated to output W20, SN, and revamped 2-peaks fitting
;   GH: 02Jan14  Updated to include asymmetric peak fitting
;   GH: 28Apr14  Updated to catch problems in 2-peak fitting
;
;-

function gauss1, x, p, skew=skew, _EXTRA=extra

  z = (x-p(0))/p(1)
  f = z * 0

  ;; IDL will report "underflow" errors unless the domain is
  ;; restricted.  Here I restrict to 10-sigma
  wh = where(abs(z) LT 10., ct)

  ;; This is a gaussian whose total area is unity
  if ct GT 0 then $
    f(wh) = exp(-0.5D * z(wh)^2)/(sqrt(2.D * !dpi)*p(1))

  ;; Add skew if necessary
  if n_elements(skew) GT 0 then $
    f = (1.D + skew * z)*f

  ;; Apply normalization if needed
  if n_elements(p) GE 3 then f = p(2)*f
  return, f
end

FUNCTION MYGAUSS, X, P
  RETURN, P[0] + GAUSS1(X, P[1:3])
END

FUNCTION closest, array, value
;	Written by: Trevor Harris, Physics Dept., University of Adelaide,
;		July, 1990.
	if (n_elements(array) le 0) or (n_elements(value) le 0) then index=-1 $
	else if (n_elements(array) eq 1) then index=0 $
	else begin
		abdiff = abs(array-value)	 ;form absolute difference
		mindiff = min(abdiff,index)	 ;find smallest difference
	endelse

	return,index
end

PRO markregion, lbwsrc, message, edgechan, color=color, xrange=xrange, yrange=yrange, asymmetric=asymmetric

TRUE  = 1
FALSE = 0

; Define variables for which mouse button was clicked
LEFT_BUTTON   = 1
MIDDLE_BUTTON = 2
RIGHT_BUTTON  = 4

if n_elements(color) eq 0 then color = 150              ; Default to green

lbwplot, lbwsrc, /mask, xrange=xrange, yrange=yrange    ; Plot the source
loadct, 13, /silent

print, message
print, '  Left-click to select region boundaries.'
print, '  Right-click to start over.'

selecting_region = TRUE
while selecting_region do begin

	edgechan = [0,0]
	lbwplot, lbwsrc, /mask, xrange=xrange, yrange=yrange ; Show the stuff already
	loadct, 13, /silent
	
	for i=0L, 1 do begin             ; Loop twice: once for each side of the region of interest
		cursor, x, y, /up, /data     ; Get the x-y location of the cursor after a click
		button = !mouse.button       ; Get which button was pressed

		totheleft = where(lbwsrc.vel gt x)        ; Find the channel corresponding to this velocity
		edgechan[i] = totheleft[n_elements(totheleft)-1]

		if button and RIGHT_BUTTON then break

		oplot, [x,x],[-1e4,1e4], linestyle=2, color=color
	endfor
	if button and RIGHT_BUTTON then continue

	selecting_region = FALSE
endwhile

edgechan = edgechan[sort(edgechan)]

END

PRO edgefit, lbwsrc, edge, fit, flag, right=right, markup=markup
flag = 0

; Depending on whether we're on the left or right half of the spectrum,
; we'll want to call certain functions
if not(keyword_set(right)) then begin
	sign = 1
	minfun = 'min'
	maxfun = 'max'

;	range = [edge[0] + floor(0.8*(edge[1]-edge[0])), edge[1]]
endif else begin
	sign = -1
	minfun = 'max'
	maxfun = 'min'

;	range = [edge[0], edge[0]+floor(0.2*(edge[1]-edge[0])) ]
endelse
range = [edge[0], edge[1]]

; Using the marked edges, find the peaks and fit them

minspec = min(lbwsrc.spec[range[0]:range[1]]) ; What's the minimum value in this spectrum?
;if minspec le 0 then $
  ; Find last time the spectrum crosses 0
;  zerochan = call_function(minfun, where(lbwsrc.spec[range[0]:range[1]] le 0)) + range[0] $
;else $
  ; It doesn't cross 0, so take the minimum.
  zerochan = call_function(minfun, where(lbwsrc.spec[range[0]:range[1]] eq minspec)) + range[0]

maxval  = max(lbwsrc.spec[edge[0]:edge[1]])                                             ; Find value of the peak
maxchan = call_function(maxfun,where(lbwsrc.spec[edge[0]:edge[1]] eq maxval)) + edge[0] ; and, of course, where it occurs

; We will restrict our searches between the max and zero channel
edge = [maxchan, zerochan]
edge = edge[sort(edge)]

;oplot, [lbwsrc.vel[maxchan],lbwsrc.vel[maxchan]],[-100,1000], linestyle=2, color=175
;oplot, [lbwsrc.vel[zerochan],lbwsrc.vel[zerochan]],[-100,1000], linestyle=2, color=175

maxval -= lbwsrc.rms  ; Assume the maximum value has been contaminated by noise equal to rms
percent15 = 0.15*maxval  ; We fit the slope of the edge of the spectrum
percent85 = 0.85*maxval  ;   only where emission is betwen 15% and 85% of the maximum

; Restrict further to the region between 15% and 85% of maximum
;p15chan = call_function(minfun, where(lbwsrc.spec[edge[0]:edge[1]] le percent15))+edge[0]
;p85chan = call_function(maxfun, where(lbwsrc.spec[edge[0]:edge[1]] ge percent85))+edge[0]
p15chan = call_function(maxfun, where(lbwsrc.spec[edge[0]:edge[1]] ge percent15))+edge[0]
p85chan = call_function(minfun, where(lbwsrc.spec[edge[0]:edge[1]] le percent85))+edge[0]

midchan = [p15chan, p85chan]
midchan = midchan[sort(midchan)]

; Plot each individual data point, the peak value, peak-rms, and 15% and 85% levels
if n_elements(markup) then begin
	oplot, lbwsrc.vel, lbwsrc.spec, psym=2
	oplot, [-10000., 10000.], [maxval, maxval], color=150, linestyle=2
	oplot, [-10000., 10000.], [maxval+lbwsrc.rms, maxval+lbwsrc.rms], color=150, linestyle=2
	oplot, [-10000., 10000.], [percent15, percent15], color=225, linestyle=2
	oplot, [-10000., 10000.], [percent85, percent85], color=225, linestyle=2
	oplot, [lbwsrc.vel[midchan[0]], lbwsrc.vel[midchan[0]]], [-100,200], color=225, linestyle=2
	oplot, [lbwsrc.vel[midchan[1]], lbwsrc.vel[midchan[1]]], [-100,200], color=225, linestyle=2
endif

;oplot, [lbwsrc.vel[p15chan],lbwsrc.vel[p15chan]],[-100,1000], linestyle=2, color=200
;oplot, [lbwsrc.vel[p85chan],lbwsrc.vel[p85chan]],[-100,1000], linestyle=2, color=200

; Perform a a linear fit over the 15%-85% profile edge
xvals = lbwsrc.vel [midchan[0]:midchan[1]]
yvals = lbwsrc.spec[midchan[0]:midchan[1]]
errors = dblarr(n_elements(xvals))+lbwsrc.rms

; Oh my! There aren't enough points in the region to 
if n_elements(xvals) lt 2 or abs(edge[1]-edge[0]) lt 3 then begin
	print, 'There are not enough points in the selected edge region to produce a good fit!'
	print, 'Try smoothing the spectrum using lbwsmooth first.'
	print, 'Enter "Q" to exit and smooth manually, or press [ENTER] to try selecting a region again.'

	response = ''
	read, response

	if response eq '' then begin
		flag = 1
		return
	endif else begin
		flag = 2
		return
	endelse

endif

;stop

coef = linfit(xvals, yvals, measure_errors=errors, sigma=sigma, covar=covar, chisqr=chisqr)
intercept = coef[0]    ; Unpack the coefficient array
slope = coef[1]
inter_err = sigma[0]   ; And the uncertainty array
slope_err = sigma[1]

;oplot, lbwsrc.vel, coef[0]+coef[1]*lbwsrc.vel, color=225

; Use the fit information to find the velocity at half the peak intensity
halfpeak = 0.5*maxval
velocity = (halfpeak - intercept)/slope

peak20   = 0.2*maxval
vel20    = (peak20 - intercept)/slope

specrms = lbwsrc.rms
variance = 1/slope^2 * (specrms^2/4 + slope_err^2*velocity^2 + inter_err^2 + 2*velocity*covar[0,1])
error = sqrt(variance)

fit = {coef:coef, vel:velocity, vel20:vel20, sigma:sigma, covar:covar, chisqr:chisqr, fp:maxval, error:error}

END

; This function is just a straight-up adaptation of Springob 2005 Table 2 into IDL code
; We need to check separately for deltav and logSNR
FUNCTION calculatelambda, deltav, logSNR, smoothtype

	if smoothtype eq 'h' then begin

		if deltav lt 5. then begin
			if logSNR lt 0.6 then return, 0.005
			if logSNR gt 1.1 then return, 0.395
			; logSNR is between 0.6 and 1.1
			return, -0.4685 + 0.785*logSNR
	
		endif
	
		if deltav gt 11. then begin
			if logSNR lt 0.6 then return, 0.227
			if logSNR gt 1.1 then return, 0.533
			; logSNR is between 0.6 and 1.1
			return, -0.1523 + 0.623*logSNR
		endif
	
		; deltav is between 5 and 11
		if logSNR lt 0.6 then return, 0.037*deltav - 0.18
		if logSNR gt 1.1 then return, 0.023*deltav + 0.28
		; logSNR is between 0.6 and 1.1
		return, (0.0527*deltav - 0.732) + (-0.027*deltav + 0.92)*logSNR

	endif else if smoothtype eq 'b' then begin
		
		if deltav lt 5. then begin
			if logSNR lt 0.6 then return, 0.020
			if logSNR gt 1.1 then return, 0.430
			; logSNR is between 0.6 and 1.1
			return, -0.4705 + 0.820*logSNR
		endif

		if deltav gt 11. then begin
			if logSNR lt 0.6 then return, 0.332
			if logSNR gt 1.1 then return, 0.802
			; logSNR is between 0.6 and 1.1
			return, -0.2323 + 0.940*logSNR
		endif

		; deltav is between 5 and 11
		if logSNR lt 0.6 then return, 0.052*deltav - 0.24
		if logSNR gt 1.1 then return, 0.062*deltav + 0.12
		; logSNR is between 0.6 and 1.1
		return, (0.0397*deltav - 0.669) + (0.020*deltav + 0.72)*logSNR
		
	endif

END

PRO twopeakfit, lbwsrc, xrange, yrange, totflux, fluxerr, W50, W50err, vsys, vsyserr, W20, W20err, SN

	TRUE  = 1
	FALSE = 0

	; Define variables for which mouse button was clicked
	LEFT_BUTTON   = 1
	MIDDLE_BUTTON = 2
	RIGHT_BUTTON  = 4

;	fitting = TRUE
;	while fitting do begin
;		message = 'Select a region around the emission.'
;		markregion, lbwsrc, message, edge, color=150, xrange=xrange, yrange=yrange
;	
;		range = max(edge) - min(edge)
;		rangechunk = floor(range*0.6)
;	
;		edgefit, lbwsrc, [edge[0]+rangechunk, edge[1]], leftfit
;		oplot, lbwsrc.vel, leftfit.coef[0]+leftfit.coef[1]*lbwsrc.vel, color=225, thick=2  ; Plot fitted lines
;	
;		edgefit, lbwsrc, [edge[0], edge[1]-rangechunk], rightfit
;		oplot, lbwsrc.vel, rightfit.coef[0]+rightfit.coef[1]*lbwsrc.vel, color=225, thick=2
;	
;		print, 'Is this fit OK?'
;		print, '  Left-click to approve'
;		print, '  Right-click to try again'
;		cursor, x, y
;		button = !mouse.button
;		if button and LEFT_BUTTON then break ; Everything's good!
	
;	endwhile
	
	;; FIT LINES TO LEFT AND RIGHT SPECTRUM EDGE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	fitting_left = TRUE
	while fitting_left do begin
		message = 'Select a region around the left edge of emission.'
		markregion, lbwsrc, message, edge, color=150, xrange=xrange, yrange=yrange

		; Record the edges of the selected regions
		lbwsrc.fitedge[0] = min(edge)
		lbwsrc.fitedge[1] = max(edge)

		edgefit, lbwsrc, edge, leftfit, flag, markup=markup

		if (flag eq 1) then continue ; Fitting failed but user wants to try again
		if (flag eq 2) then return   ; Fitting failed and user wnats to smooth/start over

		oplot, lbwsrc.vel, leftfit.coef[0]+leftfit.coef[1]*lbwsrc.vel, color=225, thick=2  ; Plot fitted lines
	
		print, 'Is this fit OK?'
		print, '  Left-click to try again'
		print, '  Right-click to approve'
		cursor, x, y
		button = !mouse.button
		if (button and RIGHT_BUTTON) ne 0 then break ; Everything's good!
	
	endwhile
	
	fitting_right = TRUE
	while fitting_right do begin
		message = 'Select a region around the right edge of emission.'
		markregion, lbwsrc, message, edge, color=150, xrange=xrange, yrange=yrange

		; Record the edges of the selected regions
		lbwsrc.fitedge[2] = min(edge)
		lbwsrc.fitedge[3] = max(edge)

		edgefit, lbwsrc, edge, rightfit, flag, /right, markup=markup

		if (flag eq 1) then continue ; Fitting failed but user wants to try again
		if (flag eq 2) then return   ; Fitting failed and user wnats to smooth/start over

		oplot, lbwsrc.vel, rightfit.coef[0]+rightfit.coef[1]*lbwsrc.vel, color=225, thick=2
	
		print, 'Is this fit OK?'
		print, '  Left-click to try again'
		print, '  Right-click to approve'
		cursor, x, y
		button = !mouse.button
		if (button and RIGHT_BUTTON) ne 0 then break ; Everything's good!
	endwhile
	
	;; CALCULATE W50 and VSYS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	; Find the left and right edges of the spectrum using the line fits
	; i.e. find the location where the fitted flux density is 0 mJy
	; Remember, the coefficients are intercept (0) and slope (1) of a linear fit.
	leftedge  = min(where(lbwsrc.vel le -leftfit.coef[0] / leftfit.coef[1]))
	rightedge = max(where(lbwsrc.vel ge -rightfit.coef[0]/rightfit.coef[1]))
	; Find the delta-v at the center channel
	centerchan = floor((leftedge+rightedge)/2.)
	deltav = abs(lbwsrc.vel[centerchan+1]-lbwsrc.vel[centerchan-1])/2.
	
	; Calculate W50 and vsys
	vsys = 0.5*(rightfit.vel + leftfit.vel)
	W50 = abs(rightfit.vel-leftfit.vel)
	; Adjust W50 a la Springob et al 2005; Table 2
	fp = max(lbwsrc.spec[rightedge:leftedge])  ; Peak flux over the spectrum
	SNR = (fp - lbwsrc.rms) / lbwsrc.rms ; Approximate SNR for looking up in the table
	logSNR = alog10(SNR)                                    ; Logarithm of the SNR
    ; Looks up the value of the "lambda" correction
	lambda = calculatelambda(deltav, logSNR, strmid(lbwsrc.window, 0, 1))
	
	W50 = W50 - 2*deltav*lambda                ; Subtract off noise+instrumental broadening effect
	
	W20 = abs(rightfit.vel20 - leftfit.vel20)
	W20 = W20 - 2*deltav*lambda
	
	; Make a pretty plot
	lbwplot, lbwsrc, xrange=xrange, yrange=yrange, /mask ; Plot the spectrum
	loadct, 13, /silent
	oplot, lbwsrc.vel, leftfit.coef[0] +leftfit.coef[1] *lbwsrc.vel, color=225, thick=2  ; Plot fitted lines
	oplot, lbwsrc.vel, rightfit.coef[0]+rightfit.coef[1]*lbwsrc.vel, color=225, thick=2
	oplot, [vsys, vsys], [-100,1e4], linestyle=2, color=150             ; plot systemic velocity
	oplot, [leftfit.vel, rightfit.vel], 0.25*(leftfit.fp+rightfit.fp)*[1,1], linestyle=2, color=150 ; Plot W50
	
	;; INTEGRATE THE FLUX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	totflux = 0.  ; Running total of the integrated flux density
	
	for i=rightedge, leftedge do begin
		deltav = abs(lbwsrc.vel[i+1]-lbwsrc.vel[i-1])/2. ; Find the width of the current channel
		totflux += deltav * lbwsrc.spec[i]    ; Add current channel's integrated flux density to the total
	endfor
	
	totflux = totflux / 1000. ; Conversion from mJy km/s to Jy km/s
	
	; Calculate signal to noise (the ALFALFA way)
	SN = 1000*totflux/W50*sqrt( (W50 < 400.)/20. ) / lbwsrc.rms
	
	; Calculate errors
	fluxerr = 2*(lbwsrc.rms/1000)*sqrt(1.4*W50*deltav)
	W50err  = sqrt( leftfit.error^2 + rightfit.error^2  )
	W20err  = W50err
	Vsyserr = W50err/sqrt(2)

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; THE MAIN FUNCTION, lbwmeasure ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO lbwmeasure, lbwsrc, gaussian=gaussian, asymmetric=asymmetric, markup=markup

; Did the user actually send an LBW structure?
if DATATYPE(lbwsrc, /TNAME) ne 'STRUCT' then begin
	print, "Given variable isn't a structure."
	print, "Please rerun after running lbwfromcorfile."
	print, "See the documentation."
	return
endif

;check input
if keyword_set(gaussian) then dogaussian = 1 else dogaussian = 0

TRUE  = 1 ; Plain, unencumbered truth.
FALSE = 0

c = 3.e5  ; The speed of light

; Define variables for which mouse button was clicked
LEFT_BUTTON   = 1
MIDDLE_BUTTON = 2
RIGHT_BUTTON  = 4

;; ZOOM IN TO THE SOURCE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

finding_zoom = TRUE
while finding_zoom do begin

	print, 'Find a good zoom level to view the source.'
	print, '  Left-button drag to move the box.'
	print, '  Right-click to accept.'
	print, '  Middle-button drag to resize box.'
	print, '    (For mice without middle button, click right+left simultaneously)'

	; Calculate a nice-sized box for the box-cursor to start with
	lbwplot, lbwsrc, /mask

	centervel = lbwsrc.vel[lbwsrc.nchan/2]
	width = 800.
	left = centervel - width
	right = centervel + width
	if lbwsrc.yrange[0] ne -999 then begin
		yrange = lbwsrc.yrange[1]-lbwsrc.yrange[0]
		bottom = lbwsrc.yrange[0]+yrange*0.025
		top = lbwsrc.yrange[1]-yrange*0.025
	endif else begin
		maskleft = min(where(lbwsrc.mask))
		maskright = max(where(lbwsrc.mask))
		tmpspec = lbwsrc.spec[maskleft:maskright]

		yrange = max(tmpspec)-min(tmpspec)
		bottom = min(tmpspec)-yrange*0.025
		top = max(tmpspec)+yrange*0.025
	endelse

	bottomleft = convert_coord(left, bottom, /data, /to_device)
	topright   = convert_coord(right, top, /data, /to_device)
	x = bottomleft[0]
	y = bottomleft[1]
	nx = topright[0]-x
	ny = topright[1]-y

	print, x, y, nx, ny
	box_cursor, x, y, nx, ny, /init                          ; Get user zoom box
	result = convert_coord(x, y, /device, /to_data)          ; Convert x, y to data coordinates
	xmin = result[0]
	ymin = result[1]
	result = convert_coord(x+nx, y+ny, /device, /to_data)    ; Convert other corner to data coordinates
	xmax = result[0]
	ymax = result[1]

	; Plot the box for user to approve
	loadct, 13, /silent
	oplot, [xmin, xmax, xmax, xmin, xmin], [ymin, ymin, ymax, ymax, ymin], linestyle=2, color=150

	print
	print, 'Use this zoom level?'
	print, '  Left-click to choose again.'
	print, '  Right-click to accept.'

	cursor, x, y, /down, /data     ; Wait for a click
	button = !mouse.button         ; Get which button was pressed
	if (button AND RIGHT_BUTTON) ne 0 then break  ; You picked right? Okay we're done.

endwhile

; Use this particular range, ensuring proper ordering of values
xrange = [xmin<xmax, xmin>xmax]
yrange = [ymin<ymax, ymin>ymax]
;lbwplot, lbwsrc, xrange=xrange, yrange=yrange, /mask

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CALCULATE FIT PARAMETERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; IF GAUSSIAN FITTING, FIT A GAUSSIAN...
if dogaussian eq 1 then begin
	lbwsrc.fittype = 'G'

	fitting_gauss = TRUE
	while fitting_gauss do begin
		print, ''
		message = 'Click ONCE on EACH SIDE of the emission line.'
		markregion, lbwsrc, message, edge, color=150, xrange=xrange, yrange=yrange
		;provide an initial guess for the parameters:
		;start = [offset,mean,sigma,area]
		deltaedge = lbwsrc.vel[edge[0]]-lbwsrc.vel[edge[1]]
		;print, "delta edge=",lbwsrc.vel[edge[0]],"-",lbwsrc.vel[edge[1]], deltaedge
		midpt = lbwsrc.vel[edge[1]]+deltaedge/2.
		;print, 'Midpoint guess =',midpt,'km/s'
		;guess area is "peak value" * deltaedge
		area = lbwsrc.spec[closest(lbwsrc.vel,midpt)]*deltaedge
		start = [0.D, midpt, 0.67*deltaedge, area]
		YERR = lbwsrc.rms;intarr(size(lbwsrc.spec))
		; add baseline to the fit; choose the correct velocity channels
		;edit the mask to include the fit
		Smask = lbwsrc.mask; S stands for source
		Smask[edge[0]:edge[1]] = 1
		;plot,smask,xrange=[0,2050],yrange=[-1,2]
		Svel  = lbwsrc.vel[where(smask)]         ; Get masked velocity range
		Sspec = lbwsrc.spec[where(smask)]  ; Get masked spectrum
		N    = n_elements(Svel)                          ; How many points are being fit to?
		result = MPFITFUN('MYGAUSS', Svel, Sspec, YERR, start, /quiet, covar=COV)
		;print, result
		;calculate the FWHM
		GFWHM = 2.35482*result[2]
		GFWHMerr = 2.35482*sqrt(abs(COV[2,2]))
		;assign to W50:
		W50 = GFWHM
		W50err = GFWHMerr		
		; Calculate W20 as well
		W20 = 2*sqrt(2*alog(5))*result[2]
		W20err = 2*sqrt(2*alog(5))*sqrt(abs(COV[2,2]))

		;calculate the central velocity
		vsys = result[1] 
		Vsyserr = sqrt(abs(COV[1,1]))
		;calculate the flux under the curve
		totflux = result[3]/1000. ;from mJy km/s to Jy km/s
		fluxerr = sqrt(abs(COV[3,3]))/1000.
		oplot, lbwsrc.vel, result(0)+gauss1(lbwsrc.vel, result(1:3)), color=225, thick=2

		; Calculate signal to noise
		peakmJy = result[3]/(result[2]*sqrt(2*!dpi)) ; Calculate peak flux = area/(sigma * sqrt(2 pi) )
		SN = peakmJy / lbwsrc.rms

		lbwsrc.fitedge = [min(edge), max(edge)]

		print, 'Is this fit OK?'
		print, '  Left-click to try again'
		print, '  Right-click to approve'
		cursor, x, y
		button = !mouse.button
		if (button and RIGHT_BUTTON) ne 0 then break ; Everything's good!

	endwhile


endif else begin

;; IF NOT GAUSSIAN FITTING, FIT LINES TO LINE EDGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lbwsrc.fittype = 'P'
	twopeakfit, lbwsrc, xrange, yrange, totflux, fluxerr, W50, W50err, vsys, vsyserr, W20, W20err, SN

	if keyword_set(asymmetric) then begin
		
		print, 'Select new edges to estimate systematic uncertainties.'
		twopeakfit, lbwsrc, xrange, yrange, totflux2, fluxerr2, W502, W50err2, vsys2, vsyserr2, W202, W20err2, SN2

		fluxerr = sqrt( (fluxerr^2 + fluxerr2^2)/2. )
		totflux = (totflux + totflux2) / 2.

		W50err = sqrt( (W50err^2 + W50err2^2)/2. )
		W50 = (W50 + W502) / 2.
	
		vsyserr = sqrt( (vsyserr^2 + vsyserr2^2)/2. )
		vsys = (vsys + vsys2) / 2.

		W20err = sqrt( (W20err^2 + W20err2^2)/2. )
		W20 = (W20 + W202) / 2.

		SN = (SN+SN2)/2.

	endif

endelse

lbwsrc.W50    = W50
lbwsrc.W50err = W50err
lbwsrc.W20    = W20
lbwsrc.W20err = W20err
lbwsrc.vsys   = vsys
lbwsrc.vsyserr = vsyserr
lbwsrc.flux    = totflux
lbwsrc.fluxerr = fluxerr
lbwsrc.SN      = SN

print, ''
print, 'W50 = ', W50, ' +/- ', W50err,' km/s '
print, 'W20 = ', W20, ' +/- ', W20err,' km/s '
print, 'vsys = ', vsys, ' +/- ', Vsyserr, ' km/s'
print, 'flux = ', totflux,' +/- ', fluxerr, ' Jy km/s'
print, 'SN = ', SN

print
print, 'Please enter any comments:'
response=''
read, response
if response ne '' then lbwcomments, lbwsrc, response, /add

print
print, "Spectral line fit complete!"

END
