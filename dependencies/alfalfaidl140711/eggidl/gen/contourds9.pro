; countourds9.pro
; by Krzysztof Findeisen
; Last modified 10/04/2006
; Wrapper for contour that prints output into a DS9-readable file
;
; To use, simply take whatever call to contour generated the contours, replace the routine 
; name, and add the ds9reg keyword.
; To produce a WCS contour file, x and y must be initialized to RA and DEC values (and 
; image must be north-aligned)
; If x and y are omitted, the file will be in (radio) image coordinates

pro contourds9, z, x, y, ds9reg=filename, _extra=extra

  if(not keyword_set(filename)) then begin
  	message, 'No output filename given. Syntax: ds9reg=filename'
  endif
  
  ; Work out the contours
  if n_params() eq 3 then begin
  	contour, z, x, y, path_xy=xy, path_info=info, /path_data_coords, _strict_extra=extra
  endif else if  n_params() eq 2 then begin
  	contour, z, x,    path_xy=xy, path_info=info, /path_data_coords, _strict_extra=extra
  endif else if  n_params() eq 1 then begin
  	contour, z,       path_xy=xy, path_info=info, /path_data_coords, _strict_extra=extra
  endif else begin
  	message, 'Incorrect number of arguments.', /continue
  	message, 'Syntax: contourds9, z, [x, y], ds9reg=filename'
  endelse
  	
  openw, unit, filename, /get_lun

  ; Print them out, one by one
  for i = 0, n_elements(info) - 1 do begin
  	; Get indices of points
  	if info[i].type eq 1 then
  		s = [indgen(info[i].n), 0]		; Countour closed -- repeat the last point
  	else
  		s = indgen(info[i].n)			; Contour open
  	; IDL has nice array printing commands...
  	printf, unit, xy[*, info[i].offset + s], format='(2(f12.6))'
  	printf, unit, ''			; DS9 seperates contours with blank lines
  endfor
  
  close, unit
  free_lun, unit

end
