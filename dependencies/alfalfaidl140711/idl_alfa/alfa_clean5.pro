; combine_chans - Combine channels different ways to improve the per channel S/N.  The factor
; that determines how many to add together is CleanLimit.  Combine_chans adds channels together
; until at least 75% of channels have a peak > CleanLimit.
;
; Usage:  combine_chans, data_cube, CleanLimit [,NComb = <# of channels in new psuedo channel>] $
;	[,/Silent] [,Output=<strarr of output>]
;
; 
function combine_chans, data, CleanLimit, NComb=NComb, Silent=Silent, Output=Output
	; Define size of data cube
	vs = (size(data))[1]	; Size of velocity array
	xs = (size(data))[2]	; RA size
	ys = (size(data))[3]	; Dec size

	; Define cube RMS
	data_rms = stddev(data)
	
	; Find most of the ways to split up the channels
	temp = vs / (findgen(vs)+1)	; start at one so that if we have a really bright source
					; we get the full channel resolution
	smth = where( temp EQ fix(temp) ) + 1

	; Do the sum and figure out the new velocities associated with each
	; new channel
	for t=0L,(n_elements(smth)-1) do begin
		data2 = dblarr(vs/smth[t], xs, ys)
		metric = 0
		for i=0,(vs/smth[t]-1) do begin
			for j=(i*smth[t]),((i+1)*smth[t]-1) do data2[i,*,*] += data[j,*,*]
			if max(data2[i,*,*]) GT CleanLimit then metric += 1
		endfor
		if metric GE 0.75*vs/smth[t] then goto, GoodEnough

	endfor
	
	GoodEnough:
	; Define the new cube RMS
	data2_rms = stddev(data2)
	; Store the number of channels we are combining
	NComb = smth[(t<(n_elements(smth)-1))]

	; Print some interesting information
	if Not Keyword_Set(Silent) then begin
		print,'> combine_chan: combining '+$
			string(smth[(t<(n_elements(smth)-1))],Format='(I3)')+' channels'
	endif
	Output = [Output, '> combine_chan: combining '+$
			string(smth[(t<(n_elements(smth)-1))],Format='(I3)')+' channels']

	; Return the data cube
	return,data2
end

; alfa_clean5 - Deconvolve a data cube with a CLEAN-type (Hogbom 1974) method.  The 
; procedure accepts a number of inputs that control the CLEANing process, including map 
; RMS, the total number of iterations, and the FWHM of the restored beam.  The procedure
; also assumes that the beam provided is 25' x 25' @ 1'/px, i.e., a beam created by 
; build_beam[23]?.pro.
;
; This method differs from alfa_clean and alfa_clean2 in that it does not need a 0th-
; moment map to run.  The net result is that this cleaned data cube can be used to make 
; 0th- and 1st-moment maps.
;
; The procedure works as follows:
; (1) The data cube is read into the program as are all of the CLEAN control options.
; (2) The cleaning loop selects the maximum point in each map for cleaning.  If more 
;     than one point fits this selection criterion then the one closest to the lower 
;     left-hand corner is used.  The cleaning process removes a total flux from the 
;     map that is 10% of the maximum value.  In term of the maximum point, ~1% is 
;     removed from that location.  The loop continues until
;      (a) the RMS limit is hit (Sigma*RMS > map maximum point)
;      (b) the Flux limit is hit (Flux > map maximum point)
;      (c) the iteration limit is hit
;      (d) the total residual flux in the map becomes negative.  This exit point is 
;          checked before any flux is removed from the map to insure that the 
;          residuals always total > 0.
;    If more than one flux flag (Flux,Sigma) is selected, the larger limit is used.
; (3) The CLEANed data is re-convolved with a Gaussian beam with a FWHM of 3.5' or 
;     whatever is specified by the FWHM flag.  This re-convolved map is then added back
;     to the residual flux to create the output map.  
;
; Typical run times for this procedure are between 0.01s and 10s.  The average run time is 2s.
;
; Usage:  alfa_clean5, data_cube, beam, cleaned_map [, Continuum=<continuum_map>] [,C_Cleand=C_Cleand] 
;		[, MapRMS=<map rms from grid.grms>] NIter=<max # of iterations>] $
;         	[,Flux = <Flux limit>] [,FWHM = <FWHM of Gaussian restore beam>] $
;               [,Sigma = <Sigma limit>] [,Range = <channel range to clean>] [,/AllowSum] $
;		[,Exit_Status = <numererical exit status] [,/Silent] [,Output=<strarr of output>]
;
; Inputs:
;  data_cube -> [v, ra, dec] data cube
;  beam -> 25' x 25' @ 1'/px beam from build_build.pro for the pixel closest to the 
;  source's center
;  Continuum -> [ra, dec] map of continuum sources for cleaning
;  MapRMS -> RMS of the grid that the map is from
;  NIter -> Maximum number of iterations in the CLEAN loop.  The default is 1,500.
;  Flux -> The flux level, in mJy, to clean down to.
;  Sigma -> Sigma level with which to clean down to.  
;  Range -> Two element array of channel number to clean
;  AllowSum -> Allow alfa_clean5 to sum channels together to improve the per channel S/N
;  FWHM -> The FWHM of the Gaussian restore beam.  The default is 3.0'
;  Silent -> Turn off information statements.  The default is to display them.
;  Output -> All logging statements are saved to a string array.  This array is returned with 
;            this varaible and is useful for interfacing with other programs.
;
; Outputs:
;  cleaned_map -> The velocity integrated CLEANed map.  This map as the same RA and
;                 dec dimensions as the src.srccube.dbox data
;  c_cleand -> Cleaned version of continuum map (if supplied)
;  Exit_Status -> Numerical exit status for each channel's cleaning loop.  The codes are:
;                  -1 => exit caused by iteration limit
;                  +1 => exit caused by RMS limit
;                  +2 => exit caused by residuals limit
;  Output -> All logging statements are saved to a string array.  This array is returned with 
;            this varaible and is useful for interfacing with other programs.
;
; Information Statements:
;  This procedure produces a variety of information statements.  These include current 
;  task (setup, cleaning, and restore), total run time is seconds, name of the current
;  source, CLEAN loop control limits, the loop exit status, and the flux contained in 
;  the map.  These can be turned off with the Silent flag
;
pro alfa_clean5, dbox, beam, cleand, Continuum=Continuum, C_Cleand=C_cleand, MapRMS=MapRMS, $
	NIter=NIter, Flux=Flux, Sigma=Sigma, Range=Range, AllowSum=AllowSum, Exit_Status=Exit_Status, $
	FWHM=FWHM, Silent=Silent, Output=Output
t_start = systime(1)

; Determine box size
v_size = (size(dbox))[1]
x_size = (size(dbox))[2]
y_size = (size(dbox))[3]
if Not Keyword_Set(Silent) then begin
	print,''
	print,'alfa_clean5 started:'
	print,'> setup'
	print,'>  loaded '+string(v_size,Format='(I4)')+'x'+string(x_size,Format='(I3)')+'x'+ $
		string(y_size,Format='(I3)')+' data cube'
endif
Output = ['alfa_clean5 started:','> setup']
Output = [Output, '>  loaded '+string(v_size,Format='(I4)')+'x'+string(x_size,Format='(I3)')+ $
	'x'+string(y_size,Format='(I3)')+' data cube']

; Setup variabled that control the cleaning process.  
if n_elements(NIter) EQ 0 then NIter = 1500
; Check to see if the Sigma flag is set.  If not, set sigma to something
; rediculous so that we don't exit on this.
if n_elements(Sigma) EQ 0 then Sigma=0.0
; Same thing for flux. 
if n_elements(Flux) EQ 0 then Flux = 0.0
; If niether are set, default to a 10 Sigma limit (Method 1)
if Flux EQ 0.0 AND Sigma EQ 0.0 then Sigma = 10.0
; If both are set, pick the maximum and set flux to that.  Then, set Sigma to 0
if Flux NE 0.0 AND Sigma NE 0.0 then begin
	Flux = max([Flux, Sigma*MapRMS])
	Sigma = 0.0
endif

; Select range to operate on
if n_elements(Range) NE 2 then Range=[0L,1023L]

; Combine channels if asked
if KeyWord_Set(AllowSum) then begin
	dbox_old = dbox
	dbox = combine_chans(dbox_old[Range[0]:Range[1], *, *], (Flux+Sigma*MapRMS), NComb=NComb, $
		Silent=Silent, Output=Output)
	cleand = dbox_old*0.0
	C_Range = [0L, (n_elements(dbox[*,0,0])-1L)]
endif else C_Range = Range

v_size = (size(dbox))[1]
x_size = (size(dbox))[2]
y_size = (size(dbox))[3]

if Not Keyword_Set(Silent) then begin
	print,'> clean'
	print,'>  cleaning data cube to a peak flux of '+strtrim(string(Flux+Sigma*MapRMS),2)+ $
		' mJy or '+strtrim(string(NIter),2)+' iterations'
endif
Output = [Output, '> clean', '>  cleaning data cube to a peak flux of '+ $
	strtrim(string(Flux+Sigma*MapRms),2)+' mJy or '+ $
	strtrim(string(NIter),2)+' iterations']

; Setup the holding variables.  Working starts off the same as data but slowly has peaks 
; removed.  cleand starts off as zeros and slowly has peaks added to it.  
cleand = dbox*0.0
working = dbox

; Run through the CLEANing loop
exit_status = intarr( C_Range[1]-C_Range[0]+1 ) -1
; Loop over channels
for c=C_Range[0],C_Range[1] do begin
	for l=0L,(NIter-1) do begin
		; Select only one pixel at a time
		peak = (where(max(working[c,*,*]) EQ working[c,*,*]))[0]
		; Amount of flux at peak
		peak_value = (reform(working[c,*,*]))[peak]

		; Check to see if we can leave yet.  This is to test for the
		; flux/sigma limits
		if peak_value LE (Flux+Sigma*MapRms) then begin
			exit_status[c-C_Range[0]] = 1
			goto, CleanDone	
		endif

		; Convert from 1D -> 2D index
		peak_x = peak mod x_size
		peak_y = peak / x_size

		; Setup boundaries of removal to handle the edges.
		work_x_lo = max([(peak_x - 12),0])
		work_x_hi = min([(peak_x + 12),x_size-1])
		work_y_lo = max([(peak_y - 12),0])
		work_y_hi = min([(peak_y + 12),y_size-1])
		beam_x_lo = 12 - (peak_x - work_x_lo)
		beam_x_hi = 12 - (peak_x - work_x_hi)
		beam_y_lo = 12 - (peak_y - work_y_lo)
		beam_y_hi = 12 - (peak_y - work_y_hi)
	
		; Scale beam and fix boundaries to find what we need to remove
		to_remove = reform(0.1 * peak_value * beam[beam_x_lo:beam_x_hi, beam_y_lo:beam_y_hi])
	
		; Take that amount out of the working data array.  We don't update working 
		; and cleand until we know that removing this won't push total(working) < 0.
		temp = reform(working[c,*,*])
		temp[work_x_lo:work_x_hi, work_y_lo:work_y_hi] = $
			temp[work_x_lo:work_x_hi, work_y_lo:work_y_hi] - to_remove
		; Residuals limit bailout condition.  If we hit this then do remove this last
		; peak
		if total(temp) LE 0 then begin
			exit_status[c-C_Range[0]] = 2
			goto, CleanDone	
		endif
		
		; We made it this far so update working
		working[c,*,*] = temp
		; And add it into the cleaned map
		cleand[c,peak_x, peak_y] = cleand[c,peak_x, peak_y] + total(to_remove)
	endfor

	; Exit point if needed	
	CleanDone:

	; Report of exit status and progress
	resid_rms = stddev(working[c,*,*])
	exit_str = 'exiting on interation limit'
	if exit_status[c-C_Range[0]] EQ +1 then exit_str='exiting on flux limit'
	if exit_status[c-C_Range[0]] EQ +2 then exit_str='exiting on residuals limit'

	if Not Keyword_Set(Silent) then begin
		print,'>  Channel '+string(c,Format='(I4)')
		print,'>  '+exit_str
		print,'>   used '+strtrim(string((l+1)<NIter),2)+' iterations'
		print,'>   peak at loop exit '+strtrim(string(peak_value),2)+' mJy'
		print,'>   residual RMS is '+strtrim(string(resid_rms),2)+' mJy'
	endif
	Output = [Output, '>  Channel '+string(c,Format='(I4)'), '>  '+exit_str, $
		'>   used '+strtrim(string((l+1)<NIter),2)+' iterations', $
		'>   peak at loop exit '+strtrim(string(peak_value),2)+' mJy', $
		'>   residual RMS is '+strtrim(string(resid_rms),2)+' mJy']
endfor

; Restore the results to a gaussian beam with FWHM, uh, FWHM
if n_elements(FWHM) eq 0 then FWHM = 3.0
restore_sigma = double(FWHM) / 2.0 / sqrt( 2.0 * alog(2.0) )
if Not Keyword_Set(Silent) then begin
	print,'> restore'
	print,'>  using circular Gaussian with'+string(FWHM, Format='(F5.2)')+"' FWHM"
endif
Output = [Output, '> restore', '>  using circular Gaussian with'+string(FWHM, Format='(F5.2)')+"' FWHM"]

; Build restore kernel up
restore_beam = dblarr(21,21)
is = dblarr(21,21)
js = dblarr(21,21)
for i=0,20 do begin 
	is[i,*] = i-10
	js[*,i] = i-10
endfor
d2 = is^2.0 + js^2.0
restore_beam = exp(-d2/(2.0*restore_sigma^2.0))
restore_beam = restore_beam / total(restore_beam, /Double)

; Convolve with restore beam
for c=C_Range[0],C_Range[1] do begin
	temp = reform(cleand[c,*,*])
	cleand[c,*,*] = convolve(temp, restore_beam)
endfor
if Not Keyword_Set(Silent) then begin
	print,'>  clean map flux '+strtrim(string(total(cleand)/1000.0),2)+' Jy'
	print,'>  residual flux  '+strtrim(string(total(working/1000.0)),2)+' Jy'
endif
Output = [Output, '>  clean map flux '+strtrim(string(total(cleand)/1000.0),2)+' Jy', $
	'>  residual flux  '+strtrim(string(total(working/1000.0)),2)+' Jy']

; And add back in residuals
cleand = cleand + working
if Not Keyword_Set(Silent) then begin
	print,'>  total flux     '+strtrim(string(total(cleand)/1000.0),2)+' Jy'
	print,'>  input flux     '+strtrim(string(total(dbox)/1000.0),2)+' Jy'
endif
Output = [Output, '>  total flux     '+strtrim(string(total(cleand)/1000.0),2)+' Jy', $
	'>  input flux     '+strtrim(string(total(dbox)/1000.0),2)+' Jy']

; If we have summed channels together then resample back to the original velocity resolution
if KeyWord_Set(AllowSum) then begin
	cleand_old = cleand
	cleand = dbox_old
	for i=Range[0],Range[1] do $
		cleand[i, *, *] = cleand_old[(i-Range[0])/NComb, *, *] / double(NComb)
	dbox = dbox_old
endif

; Now for the Continuum map, if present
if n_elements(Continuum) NE 0 then begin
	if Not Keyword_Set(Silent) then begin
		print,'> clean'
		print,'>  cleaning continuum map to a peak flux of '+ $
			strtrim(string(Flux+Sigma*MapRms),2)+ ' mJy or '+ $
			strtrim(string(NIter),2)+' iterations'
	endif
	Output = [Output, '> clean', '>  cleaning continuum map to a peak flux of '+ $
	strtrim(string(Flux+Sigma*MapRms),2)+' mJy or '+ $
	strtrim(string(NIter),2)+' iterations']

	; Setup the holding variables.  Working starts off the same as data but slowly has peaks 
	; removed.  cleand starts off as zeros and slowly has peaks added to it.  
	c_cleand = Continuum*0.0
	c_working = Continuum
	c_exit_status = -1
	
	for l=0L,(NIter-1) do begin
		; Select only one pixel at a time
		peak = (where(max(c_working) EQ c_working))[0]
		; Amount of flux at peak
		peak_value = c_working[peak]

		; Check to see if we can leave yet.  This is to test for the
		; flux/sigma limits
		if peak_value LE (Flux+Sigma*MapRms) then begin
			c_exit_status = 1
			goto, C_CleanDone	
		endif

		; Convert from 1D -> 2D index
		peak_x = peak mod x_size
		peak_y = peak / x_size

		; Setup boundaries of removal to handle the edges.
		work_x_lo = max([(peak_x - 12),0])
		work_x_hi = min([(peak_x + 12),x_size-1])
		work_y_lo = max([(peak_y - 12),0])
		work_y_hi = min([(peak_y + 12),y_size-1])
		beam_x_lo = 12 - (peak_x - work_x_lo)
		beam_x_hi = 12 - (peak_x - work_x_hi)
		beam_y_lo = 12 - (peak_y - work_y_lo)
		beam_y_hi = 12 - (peak_y - work_y_hi)
	
		; Scale beam and fix boundaries to find what we need to remove
		to_remove = reform(0.1 * peak_value * beam[beam_x_lo:beam_x_hi, beam_y_lo:beam_y_hi])
	
		; Take that amount out of the working data array.  We don't update working 
		; and cleand until we know that removing this won't push total(working) < 0.
		temp = c_working
		temp[work_x_lo:work_x_hi, work_y_lo:work_y_hi] = $
			temp[work_x_lo:work_x_hi, work_y_lo:work_y_hi] - to_remove
		; Residuals limit bailout condition.  If we hit this then do remove this last
		; peak
		if total(temp) LE 0 then begin
			c_exit_status = 2
			goto, C_CleanDone	
		endif
		
		; We made it this far so update working
		c_working = temp
		; And add it into the cleaned map
		c_cleand[peak_x, peak_y] = c_cleand[peak_x, peak_y] + total(to_remove)
	endfor

	; Exit point if needed	
	C_CleanDone:

	; Report of exit status and progress
	c_resid_rms = stddev(c_working)
	c_exit_str = 'exiting on interation limit'
	if c_exit_status EQ +1 then c_exit_str='exiting on flux limit'
	if c_exit_status EQ +2 then c_exit_str='exiting on residuals limit'

	if Not Keyword_Set(Silent) then begin
		print,'>  Continuum Map'
		print,'>  '+c_exit_str
		print,'>   used '+strtrim(string((l+1)<NIter),2)+' iterations'
		print,'>   peak at loop exit '+strtrim(string(peak_value),2)+' mJy'
		print,'>   residual RMS is '+strtrim(string(c_resid_rms),2)+' mJy'
	endif
	Output = [Output, '>  Continuum Map', '>  '+c_exit_str, $
		'>   used '+strtrim(string((l+1)<NIter),2)+' iterations', $
		'>   peak at loop exit '+strtrim(string(peak_value),2)+' mJy', $
		'>   residual RMS is '+strtrim(string(c_resid_rms),2)+' mJy']

	if Not Keyword_Set(Silent) then begin
		print,'> restore'
		print,'>  using circular Gaussian with'+string(FWHM, Format='(F5.2)')+"' FWHM"
	endif
	Output = [Output, '> restore', '>  using circular Gaussian with'+string(FWHM, Format='(F5.2)')+"' FWHM"]

	temp = c_cleand
	c_cleand = convolve(temp, restore_beam)

	if Not Keyword_Set(Silent) then begin
		print,'>  clean continuum map flux '+strtrim(string(total(c_cleand)/1000.0),2)+' Jy'
		print,'>  residual flux  '+strtrim(string(total(c_working/1000.0)),2)+' Jy'
	endif
	Output = [Output, '>  clean continuum map flux '+strtrim(string(total(c_cleand)/1000.0),2)+' Jy', $
		'>  residual flux  '+strtrim(string(total(c_working/1000.0)),2)+' Jy']
	
	; And add back in residuals
	c_cleand = c_cleand + c_working
	if Not Keyword_Set(Silent) then begin
		print,'>  continuumtotal flux     '+strtrim(string(total(c_cleand)/1000.0),2)+' Jy'
		print,'>  input flux     '+strtrim(string(total(Continuum)/1000.0),2)+' Jy'
	endif
	Output = [Output, '>  continuum total flux     '+strtrim(string(total(c_cleand)/1000.0),2)+' Jy', $
		'>  input flux     '+strtrim(string(total(Continuum)/1000.0),2)+' Jy']
endif

t_end = systime(1)
if Not Keyword_Set(Silent) then begin
	print,'> total time '+strtrim(string(t_end-t_start),2)+' seconds'
endif
Output = [Output, '> total time '+strtrim(string(t_end-t_start),2)+' seconds']

end
