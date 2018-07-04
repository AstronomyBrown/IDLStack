;+
;NAME: inspect - Makes 1D plots at cursor location on a map
;
;SYNTAX: inspect,m,NSTRIP=nstrip,SHOWPOL=showpol
;
;
;PARAMETERS:
;
;	m	input file - a map structure of nrec records
;		 	     			nchn spectral channels
;						nstr strips
;						npol (2) polarizations
;	NSTRIP	strip number at which 2D map is to be selected
;
;       SHOWPOL select polarization channel to be selected
;               Enter 0, 1 for A, B; 
;               Enter 3 for avg (assumed to be stored in 0)
;
;OUTPUT:
;
;	Interactive graphic display and (optionally) .ps file of 1D plot
;
;DESCRIPTION:
;
; Map structure m is displayed for NSTRIP and SHOWPOL using imgdisp.
; It uses the procedure LOADCOLORS from Gumley's book (p. 249).
; Make sure LOADCOLORS is compiled.
; Menu of options for 1D plot is:
;
; KEY  ARGS      FUNCTION
;  c  mode    : read cursor position and plot
;               mode=0 (xaxis => spectral channel)
;                    1 (xaxis => record number)
;               Place cursor on position and right click
;               By default, in mode=0 the spectrum stored in
;               nstrip=7 is overplot in red. You can override this
;               with the toggle swith '7'
;  7          : switches on and off the overplot of strip 7 in mode 0
;  m          : toggle switch for mode of cut and replot
;               in other direction at previous cursor location
;  x  xax     : change xaxis units
;               xax=0 ch nr (in mode 0) or rec nr (in mode 1)
;               xax=1 freq or RA
;               xax=2 vel
;  h  h1  h2  : change horiz scale (ch or rec) and replot
;               (set h1 to <0 to free scale)
;  v  v1  v2  : change vert scale and replot
;               (set v1 to -999 to free scale)
;  p          : make ps file of plot
;               (prompts for a file name)
;  q          : quit
;
; RG: 16Nov04
;_____________________________________________________________________

pro inspect,m,NSTRIP=nstrip,SHOWPOL=showpol,specapp=specapp,histeq=histeq

; atv_myplot and atv_specdet are USED IN atv_myplot ROUTINE
common atv_myplot,rah, $        ; vector of nrec RAH values
                  decd, $       ; scalar decdeg
                  vel_heliodop, $  ; vector (nrec) of helio doppler  in km/s
                  mask7, $       ; median mask in ns=7
                  nrec,nchn, $  ; scalars: # of recs, # of chans
                  ns,np, $      ; scalars: strip (bm) nr, pol nr
                  delta_frq, $  ; freq separation  b/w chns
                  delta_ra,  $  ; RA separation b/w recs in hrs 
                  RF_frq, $     ; frq in MHz at center of band
                  d_st          ; carry the "mother" structure of image
common atv_specdet, specdet, $	; array of structures with spectra/parms
                  spec1, $      ; structure with last spectrum/parms
                  specappend    ; if =1, append to existing specdet


nrec=n_elements(m[0,*,0])
nchn=n_elements(m[0,0,0].d[*])
nstr=n_elements(m[0,0,*])
ns=nstrip
npol=n_elements(m[*,0,0])

; CHECK INPUTS

if (n_elements(nstrip) eq 0 ) then begin
   Print,'Which Strip nr?'
   Read,nstrip
endif
if (n_elements(SHOWPOL) eq 0) then showpol=3 ; IE AVG

if (n_elements(specapp) eq 0) then specapp=1

if(specapp eq 0) then begin
  ans=''
  result = size(specdet)
  if (result[2] gt 1) then begin
    print,'Structure specdet has dim > 1; do you really want to initialize? (y/n)'
    read,ans
    if (strlowcase(ans) eq 'n') then message,'OK, be careful nest time.'
  endif
  make_specdet,spec1template
  specdet={spec1template}
endif

hor
ver
; GET IMAGE

if (showpol lt 2) then begin
  np=showpol
;  ptxt=strtrim(showpol,2)
  img=reform(m[np,*,ns].d[0:nchn-1])
endif else begin
  np=0
;  ptxt='Avg'
  img=reform(m[0,*,ns].d[0:nchn-1])
endelse

rah=reform(m[0,*,ns].rahr)
decd=m[0,0,ns].decdeg
delta_frq = m[0,0,ns].hf.chanfreqstep
delta_ra = (m[0,nrec-1,ns].rahr-m[0,0,ns].rahr)/(nrec-1)
mask7 = reform(m[np,*,7].d)
RF_frq = m[0,0,0].hf.rpfreq
vel_heliodop = reform(m[0,*,ns].h.pnt.r.heliovelproj)*2.99292458e5
d_st=m
specappend=specapp
goto,overthedoppler  ;WILL NEED TO FIX THIS, USING FAST LOOP OVER RECS
if (m[0,0,0].h.pnt.r.heliovelproj eq 0. and m[0,0,0].h.pnt.r.geovelproj eq 0.) then begin
    for nr=0,nrec-1 do begin
      rahr=m[0,nr,ns].rahr
      decdeg=m[0,nr,ns].decdeg
      julday=m[0,nr,ns].hf.mjd_obs+2400000.5
      velarr=chdoppler(rahr,decdeg,julday)  ;uses CHeiles' function
      myplot_parm.vel_heliodop[nr]=velarr[1]
    endfor
endif
overthedoppler:
if (n_elements(histeq) ne 0) then atv,img,/align,/stretch,/histeq
if (n_elements(histeq) eq 0) then atv,img,/align,/stretch

;endfor

end
