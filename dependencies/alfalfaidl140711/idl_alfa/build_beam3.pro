; build_beam3 - Given a grid and a map location (i,j), model the map beam at that
; location.  This routine works by first finding the drifts that contribute to 
; that grid point and then simulating observations of a point source located at that
; point.  The simulated drifts use the az=180 drifts from the A1963 program that have 
; been re-sampled to 25' x 25' @ 0.05'/px resolution and are carried out on a sky that 
; is  25' x 25' @ 0.05'/px.  The 0.05'/px resolution was chosen to minimize the error
; associated with mapping the declination of each drift onto the grid and to insure 
; 1s in RA involved an integer number of pixels.  
;
; build_beam.pro does the following:
; (1) The grid's grid_makeup structures are parsed to find all drifts that contribute 
;     to the point (i,j).  
; (2) The simulated sky with central point source is created and the beams are allowed 
;     to drift across.  A record is created for every second in RA for each beam and 
;     each drift.  These drifts are  fairly straight forward and are not aware of the 
;     two polarizations or missing data (via bad boxes) set in the grid's pos structures.
; (3) The simulated drifts are then mapped to a 1'/px grid similar to how grip_prep.pro
;     makes grids.  For the weight function we read the grid.wf_fwhm tag and assume that
;     a Gaussian weighting function is being used.  We also give beam 0 a higher (factor
;     of 1.27) weight that comes from my reading of grid_prep.pro.
; (4) The resulting map should be the beam associated with the map at that point.  This 
;     map is the normalized and the inner 25' x 25' is extracted and returned.
;
; The beams that build_beam produces agree well with isolated bright continuum sources 
; in several grids, both in terms of FWHM sizes and the overall shape of the beam.
;
; Typical run times for this procedure range between 5s and 12s, depending on how many
; drifts go into the point where the beam is being built.  The average run time is ~10s.
;
; build_beam2.pro differs from the original in how the simualted point source is observed.  
; In this version the correct region of each ALFA beam is read out rather than drifting the
; whole thing over a simulated sky.  This improves the run time by a factor of 7.  build_beam3
; differs from 2 in the way that logging information is handled and can return a string array
; of output statements.
;
; Usage:  build_beam3, grid_structure, map_coords, beam_out [, /Silent], [Output=<strarr of output>]
;
; Inputs:
;  grid_structure -> Full structure restored from a gridbf_*.sav file
;  map_coords -> 2 element array that specifies the (i,j) of the map point where a beam
;                needs to be calculated.  This cannot be overloaded and accepts only one
;                coordinate pair at a time.  
;  Silent -> Turn off information statements.  The default is to display them.
;  Output -> All logging statements are saved to a string array.  This array is returned with 
;            this varaible and is useful for interfacing with other programs.
;
; Outputs:
;  beam_out -> 25' x 25' @ 1'/px normalized (total(beam_out) = 1) beam at point (i,j)
; 
; Information Statements:
;  This procedure produces a variety of information statements.  These include current 
;  task (setup, observations, mapping, and beam reduction), total run time is seconds, 
;  number of drifts used, and the drift mean positional error in arc seconds due to the 
;  finite resolution of the grids.  There are currently no flags to turn these statements 
;  off with.
;
; Change Log;
; 10/10/07 - JD - Added `North` flag to deal with drifts north of zenith
;               - Added `Silent` flag to turn off information statements
; 10/12/07 - JD - Removed `North` flag because it was a bad idea.  We have the grid
;                 so we should use grid.pos.az0
; 11/12/07 - JD - From 0004+27 it looks like drifts north of zenith are handled correctly
; 11/18/07 - JD - Added Output flag so that this can work with cleanview.pro (currently
;                 called guitest.pro)
;
pro build_beam3, grid, cen, beam, Silent=Silent, Output=Output

common agcshare

; Start timer
t_start = systime(1)

if Not Keyword_Set(Silent) then begin
	print,''
	print,'build_beam3 started:'
	print,'> setup'
endif
Output = 'build_beam3 started:'
Output = [Output, '> setup']
;Get smoothing function FWHM
fwhm = grid.wf_fwhm
sigma = fwhm / 2.0 / sqrt( 2.0 * alog(2.0) )

; Convert from (i,j) to 1D index
index = cen[0]*grid.nx + cen[1]
; Determine the drifts that go into making that point and the
; ra and dec of that point
drift_name = (grid.grid_makeup)[index].driftname
pnt_ra = (grid.grid_makeup)[index].ra*15.0
pnt_dec = (grid.grid_makeup)[index].dec
temp = where( strcmp(drift_name, '') EQ 0 )
drift_name = drift_name[temp]
; Determine the decs of those drifts.  Here, we go back to the
; pos structure so we can find out where each beam goes
drift_dec = fltarr(n_elements(drift_name), 7)
names = grid.pos.name
for i=0,(n_elements(drift_name)-1) do begin
	match = where( strcmp(drift_name[i], names) EQ 1 )
	temp = abs( (grid.pos)[match].rahr[*,0]*15.0 - pnt_ra )
	closest = min( where( temp EQ min(temp) ) )	
	drift_dec[i,*] = (grid.pos)[match].decdeg[closest,0:6]
endfor
t_setup = systime(1)
if Not Keyword_Set(Silent) then begin
	print,'>  using '+strtrim(string(n_elements(drift_name)),2)+' drifts'
endif
Output=[Output,'>  using '+strtrim(string(n_elements(drift_name)),2)+' drifts']
; Determine the median AZ of the drifts.  This is used to determine whether or not
; we are north of zenith or not.  If we are then we reverse() the beam at the end.
med_az = median(grid.pos.az0)
if med_az GT 180 then med_az = med_az - 360.0
if abs(med_az) LT 5 then North = 0 else North = 1
if Not Keyword_Set(Silent) then begin
	if North EQ 1 then begin
		print,'>  drifts north of zenith'
	endif else begin
		print,'>  drifts south of zenith'
	endelse
endif
if North EQ 1 then begin
	Output = [Output, '>  drifts north of zenith']
endif else begin
	Output = [Output, '>  drifts south of zenith']
endelse

obs = dblarr(n_elements(drift_name), 7, 100)
; This needs to be moved to a more universal place such as homedir.  
restore,agcdir+'a1963_25_180.sav'
if Not Keyword_Set(Silent) then begin
	print,'> observe'
endif
Output = [Output, '> observe']
err = fltarr(n_elements(drift_dec))
for d=0,(n_elements(drift_name)-1) do begin
	for b=0,6 do begin
		dec_offset = (pnt_dec - drift_dec[d,b]) * 60.0
		loc_y = round( dec_offset / 0.05 ) + 250
		err[d*7+b] = (loc_y - 250) - dec_offset / 0.05

		if loc_y LT 0 OR loc_y GT 500 then continue		

		for r=0,99 do obs[d,b,99-r] = total(ant_pat[b, (r*5-0):(r*5+4), loc_y])
	endfor
endfor
t_obs = systime(1)
err = err * 0.05 * 60.0
if Not Keyword_Set(Silent) then print,'>  beam positional error '+ $
	strtrim(string(mean(err),Format='(F+5.2)'),2)+' +/- '+$
	strtrim(string(stddev(err),Format='(F4.2)'),2)+' arc sec'
Output = [Output, '>  beam positional error '+ $
	strtrim(string(mean(err),Format='(F+5.2)'),2)+' +/- '+$
	strtrim(string(stddev(err),Format='(F4.2)'),2)+' arc sec']

map = dblarr(25,25)
if Not Keyword_Set(Silent) then print,'> map'
Output = [Output, '> map']
for i=0,24 do begin
	for j=0,24 do begin
		for d=0,(n_elements(drift_name)-1) do begin
			for b=0,6 do begin
				dec_offset = (drift_dec[d,b] - pnt_dec) * 60.0
				loc_y = dec_offset - 0.5*err[d*7+b]*0.05 + 12.0
				for rp=0,99 do begin
					r = (rp-1.5)/4.0
					cosd = cos(drift_dec[d,b]*!Pi/180.0)
					d2 = ((r-i)*cosd)^2.0 + (loc_y-j)^2.0
					;print,d2
					w = exp(-d2/(2.0*sigma^2.0))
					if b EQ 0 then w *= 1.27
					map[i,j] += obs[d,b,rp]*exp(-d2/(2.0*sigma^2.0))
				endfor
			endfor
		endfor
	endfor
endfor
t_map = systime(1)

if Not Keyword_Set(Silent) then print,'> reduce'
Output = [Output, '> reduce']
map = map / total(map, /Double)
beam = map
; If we are drifting north of zenith the azimuth angle is flipped.  So, flip
; the output beam
if North then beam = reverse(beam)
t_end = systime(1)

if Not Keyword_Set(Silent) then print,'> total time '+strtrim(string(t_end-t_start),2)+' seconds'
Output = [Output, '> total time '+strtrim(string(t_end-t_start),2)+' seconds']

end
