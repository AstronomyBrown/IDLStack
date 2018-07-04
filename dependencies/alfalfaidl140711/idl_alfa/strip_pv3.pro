;+
;NAME:
;strip_pv.pro - Displays position-frequency strip maps
;
;SYNTAX:
;
; strip_pv,m,continuum,N1=n1,N2=n2,nch1=nch1,nch2=nch2,GAUSAV=gausav,HAN=han,$
;          SHOWPOL=showpol,RFIMOD=rfimod,UNITS=units,WAIT=wait,mask=mask
;
;PARAMETERS:
;
;	m	input file - a map structure of nrec records
;		 	     			nchn spectral channels
;						nstr strips
;						npol (2) polarizations
;	continuum	input file - a continuum map of nrec x nstr, or
;                                    npol x nrec x nstr [e.g. cont_pt], or
;                                    nerg x np x nrec x nstr [e.g. mc]
;
;	msmooth output file - the smoothed data set
;
;KEYWORDS:
;
;	N1	first strip number to process (default 0)
;	N2 	last strip number to process (default nrec-1)
;	nch1	first spectral channel to display
;	nch2	last spectral channel to display
;	GAUSAV	FWHM of a Gaussian weighting function, expresssed in
;		number of records, with which the strip should be
;		convolved, along the strip direction. Def=1
;	HAN	spectral smoothing applied to all spectra of the map,
;		in order to increase the sensitivity of the display.
;		Options are 3-channel, 5-channel and 7-channel Hanning
;		(HAN=3, HAN=5, HAN=7). Def=1
;	SHOWPOL	pol channel to be shown: 0, 1 if only one pol to be shown
;				         2, both are shown simultaneously.
;				         3, avg of the two is shown
;		If SHOWPOL not given, 2 is assumed.
;	MASK	mask of 1 (good pix) and 0 (bad pix) to use for m before
;               convolution. Bad pixels in m are converted to NaN so they
; 		are not used in the smoothing convolution. 
;       RFIMOD "RFI modification" option:
;               0, pixels for which maps in strip 7 are .ne.0, are set to zero
;                  in displayed data (strip 7 contains RFI+galHI maps for each pol
;                  in dred structure) 
;               1, maps in strip 7 are subtracted from data
;		2, uses mask to set 'bad' pixels in m to NaN before smoothing
;               -1 or RFIMOD not specified => no "RFI modification"
;	UNITS	units of the spectral data: 0 - Tsys (default)
;					    1 - Kelvin
;                                           2 - Jy
;                                           3 - mJy
;	WAIT	time in seconds between displays of one strip and the 
;		next. Default = 1 sec
;DESCRIPTION:
; It uses PP's imgdisp procedure to display, one strip at a time,
; position-frequency maps where the x-axis is chnr and the y-axis
; is record (sample) nr along the strip. The two polarizations are
; displayed simultaneously, on top of each other. Continuum flux 
; along the strip is plotted on the side.
; It is of course desirable for viewing purposes that the m array
; be bandpass subtracted.
;
; RG/14Jul04	started
; RG/08Aug04	allow for smoothed map display
; RG/30Oct04    Entered RFIMOD option, trimmed code
; RG/09Mar05    RFIMOD=2 and MASK keyword option added; allowe continuum to be
;               any of several files, of dimensions 2, 3 or 4
;_____________________________________________________________________

pro strip_pv,m,continuum,msmooth,N1=n1,N2=n2,nch1=nch1,nch2=nch2,GAUSAV=gausav,HAN=han,$
             SHOWPOL=showpol,RFIMOD=rfimod,UNITS=units,WAIT=wait,MASK=mask


nrec=n_elements(m[0,*,0])
nchn=n_elements(m[0,0,0].d[*])
nstr=n_elements(m[0,0,*])
npol=n_elements(m[*,0,0])
cont=continuum

; CHECK INPUTS

if (n_elements(n1) eq 0 ) then begin
   n1 = 0
   n2 = nstr-1
endif
if (n2 gt nstr-1) then n2=nstr-1
if (n_elements(nch1) eq 0 ) then begin
   nch1 = 0
   nch2 = nchn-1
endif
if (n_elements(wait) eq 0) then begin
   stare = 1.
endif else begin
   stare = wait
endelse
if (n_elements(GAUSAV) eq 0) then gausav=1
if (n_elements(HAN) eq 0) then han=1
if (n_elements(SHOWPOL) eq 0) then showpol=2
if (showpol ge 2) then begin
  np1=0
  np2=1
endif else begin
  np1=showpol
  np2=showpol
endelse
if (RFIMOD eq 2 and n_elements(MASK) eq 0) then message, $
   'For RFIMOD=2 you must input a MASK'
if (n_elements(RFIMOD) eq 0) then RFIMOD=-1
if (n_elements(units) eq 0) then begin
   units = 0
endif
; UNITS DETERMINE SCALING OF CONTINUUM PLOT ALONG EDGE OF MAP
ufact=1000.
if (units eq 0 ) then ufact = 3000.
if (units eq 1 ) then ufact = 100.
if (units eq 2 ) then ufact = 1000.
if (units ge 3 ) then ufact = 1.
; CHECK WHICH CONTINUUM INPUT FILE WAS USED AND REDUCE NDIM TO 2
result=size(continuum)
ndim=result[0]
if(ndim eq 3) then cont=reform(continuum[0,*,*])  ; assumes a cont_pt file
if(ndim eq 4) then cont=reform(continuum[7,0,*,*]); assumes an mc file

; SET KERNELS FOR SMOOTHING, INITIALIZE

gausskernel=psf_Gaussian(NPIXEL=41, FWHM=gausav,NDIMEN=1, /NORMALIZE) 
if (han eq 1) then hansmo=[1.]
if (han eq 3) then hansmo=[0.5,1.,0.5]/2.
if (han eq 5) then hansmo=[0.25,0.75,1.,0.75,0.25]/3.
if (han eq 7) then hansmo=[0.146,0.5,0.854,1.,0.854,0.5,0.146]/4.

msmooth=m
msmooth2=m
m_rficor=m
contprof=fltarr(nrec)
window,/free,retain=2,xsize=960,ysize=768
loadct, 1

; CHECK FOR BAD DATA

nsbad = intarr(nstr)
npbad = intarr(npol)
for ns=n1,n2 do begin
  for np=np1,np2 do begin
    inn=where(finite(m[np,*,ns].d) eq 0, count)
    if (count gt 2) then begin
      nsbad[ns] = 1
      npbad[np] = 1
      Print,"Bad data on strip ",ns," Pol ",np
    endif
  endfor
endfor 

;  IF RFIMOD=2, USE MASK TO SET "BAD" PIX TO NaN, SO THEY'RE NOT USED FOR SMOOTHING
;  IF RFIMOD=1, SUBTRACT FROM m THE RFI SPECTRUM STORED IN STRIP 7
;  IF RFIMOD=0, SET TO 0 m SPECTRAL VALUES FOR WHICH STRIP 7 .NE.0
;  IF RFIMOD=-1 (or not set), LEAVE m UNCHANGED

if (RFIMOD eq 1) then begin
  for ns=n1,n2 do begin
    m_rficor[*,*,ns].d=m[*,*,ns].d-m[*,*,7].d
  endfor
endif
if (RFIMOD eq 0) then begin
  for ns=n1,n2 do begin
    for np=np1,np2 do begin
      for nr=0,nrec-1 do begin
        zindx = where(m[np,nr,7].d ne 0.,zcount)
        m_rficor[np,nr,ns].d[zindx]=0.
      endfor
    endfor
  endfor
endif
if (RFIMOD eq 2) then begin
  for ns=n1,n2 do begin
    for np=np1,np2 do begin
      for nr=0,nrec-1 do begin
        imask=where(mask[*,np,nr,ns] eq 0,nmask)
        m_rficor[np,nr,ns].d[imask]=sqrt(-1.)
      endfor
    endfor
  endfor
endif


; ONLY ONE POL PROCESSED AND SHOWN

if (showpol lt 2) then begin
 np=showpol
 for ns=n1,n2  do begin
   contprof= cont[*,ns]
   cmax = max(contprof)
   rcmax= where(contprof ge cmax)
   if (npbad[np] eq 1 and nsbad[ns] eq 1) then begin ;IF IT's BAD SET TO 0
     msmooth2[np,*,ns].d = 0. 
     seed = 5L
     msmooth2[np,nrec/2,ns].d= RANDOMN(seed,nchn)
     goto, PlotThis
   endif
;  SMOOTH THE MAP 
   if (gausav gt 1) then begin
     for i=0,nchn-1 do begin
       nani=where(finite(m_rficor[np,*,ns].d[i]) eq 0,ncount)
       if(ncount gt 0.6*nchn) then goto,nextchannel
       smoothedsample=convol(reform(m_rficor[np,*,ns].d[i]), $
                             gausskernel, /EDGE_TRUNCATE,/NAN,MISSING=0)
       msmooth[np,*,ns].d[i]=reform(smoothedsample,1,nrec)
       nextchannel:     
     endfor
   endif
;   print,' Smoothed in time domain, beam/pol ',ns,np
   msmooth2[np,*,ns].d=msmooth[np,*,ns].d
   if (han gt 1) then begin
     for rec=0, nrec-1 do begin
       smoothedspec = convol(reform(msmooth[np,rec,ns].d),hansmo,$
                      /EDGE_TRUNCATE,/NAN,MISSING=0)
       msmooth2[np,rec,ns].d = smoothedspec
     endfor 
   endif
   PlotThis:
   msmooth[np,*,ns].d=msmooth2[np,*,ns].d
   !p.multi=[0,2,1,0,0]
   device, decomposed=1
   plot,contprof*ufact,findgen(nrec),position=[0.92,0.05,0.98,0.90],$  
        xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
   device, decomposed=0
   imgdisp,reform(msmooth[np,*,ns].d[nch1:nch2]),$
           position=[0.05,0.05,0.89,0.90],/histeq
   xyouts,0,nrec+0.05*nrec,$
              'Strip='+ strtrim(ns,2)+'    Pol='+strtrim(showpol,2)$
             +'     Dec='+string(m[0,0,ns].decdeg),size=1.5
   xyouts,0,nrec+0.025*nrec,'max cont='+ string(cmax*ufact)$
            +'  at rec '+strtrim(rcmax,2),size=1.5
   wait,stare
 endfor   ; closes ns loop
endif

; TWO POLS PROCESSED SEPARATELY, BOTH SHOWN (showpol eq 2) or AVG (showpol eq 3)

nnn=lindgen(8)
if (n1 eq 0 and n2 eq 6) then nnn=[4,3,5,0,2,6,1,6] ; in Dec order for rotang=19

if (showpol ge 2) then begin
 for nn=n1,n2  do begin
   ns=nnn[nn]
   Print,nn,nnn[nn],ns
   contprof= cont[*,ns]
   cmax = max(contprof)
   rcmax= where(contprof ge cmax)
;  SMOOTH THE MAPS
   for np=np1,np2 do begin
     if (npbad[np] eq 1 and nsbad[ns] eq 1) then begin
       msmooth2[np,*,ns].d = 0. 
       seed = 5L
       msmooth2[np,nrec/2,ns].d= RANDOMN(seed,nchn)
       goto, NextPol
     endif
     if (gausav gt 1) then begin
       for i=0,nchn-1 do begin
         smoothedsample=convol(reform(m_rficor[np,*,ns].d[i]), $
                              gausskernel, /EDGE_TRUNCATE,/NAN,MISSING=0)
         msmooth[np,*,ns].d[i]=reform(smoothedsample,1,nrec)     
       endfor
     endif
     msmooth2[np,*,ns].d=msmooth[np,*,ns].d
     if (han gt 1) then begin
       for rec=0, nrec-1 do begin
         smoothedspec = convol(reform(msmooth[np,rec,ns].d),hansmo,$
                          /edge_truncate,/NAN,MISSING=0)
         msmooth2[np,rec,ns].d = smoothedspec
       endfor 
     endif
     NextPol:
   endfor

   if (showpol eq 2) then begin   ; TWO POLS PROCESSED SEPARATELY, BOTH SHOWN
     msmooth[*,*,ns].d=msmooth2[*,*,ns].d
     !p.multi=[0,2,2,0,0]
     device, decomposed=1
     plot,contprof*ufact,findgen(nrec),position=[0.92,0.05,0.98,0.45],$  
        xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
     plot,contprof*ufact,findgen(nrec),position=[0.92,0.52,0.98,0.92],$  
        xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
     device, decomposed=0
;    imgdisp,reform(msmooth[0,*,ns].d),position=[0.05,0.52,0.89,0.92],/histeq
     imgdisp,reform(msmooth[0,*,ns].d[nch1:nch2]),position=[0.05,0.52,0.89,0.92],/histeq
     xyouts,0,nrec+18.,$
       'Strip='+string(ns)+'      Dec ='+string(m[0,0,ns].decdeg),size=1.5
     xyouts,nchn-200,nrec+18.,'Pol=0',Size=1.5
;    imgdisp,reform(msmooth[1,*,ns].d),position=[0.05,0.05,0.89,0.45],/histeq
     imgdisp,reform(msmooth[1,*,ns].d[nch1:nch2]),position=[0.05,0.05,0.89,0.45],/histeq
     xyouts,0,nrec+18.,'Strip=' + string(ns)+'      max cont='+ string(cmax*ufact),size=1.5
     xyouts,0.5*nchn,nrec+18.,'at rec'+string(rcmax),size=1.5
     xyouts,nchn-200,nrec+18.,'Pol=1',Size=1.5
     wait,stare 
   endif

   if (showpol eq 3) then begin   ; TWO POLS PROCESSED, THEN ADDED TOGETHER; AVG SHOWN
     !p.multi=[0,2,1,0,0]
     if (nsbad[ns] eq 0) then msmooth[0,*,ns].d=0.5*(msmooth2[0,*,ns].d+msmooth2[1,*,ns].d)
     if (nsbad[ns] eq 1) then begin
       npgood = where(npbad eq 0)
       msmooth[0,*,ns].d = msmooth2[npgood,*,ns].d
     endif
     img=reform(msmooth[0,*,ns].d[nch1:nch2])
     device, decomposed=1
     plot,contprof*ufact,findgen(nrec),position=[0.92,0.05,0.98,0.90],$  
        xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
     device, decomposed=0
     imgdisp,img,position=[0.05,0.05,0.89,0.90],/histeq
     xyouts,0,nrec+0.05*nrec,$
              'Strip='+ strtrim(ns,2)+'    Pol=Avg'$
             +'     Dec='+string(m[0,0,ns].decdeg),size=1.5
     xyouts,0,nrec+0.025*nrec,'max cont='+ string(cmax*ufact)$
            +'  at rec '+strtrim(rcmax,2),size=1.5
     wait,stare
   endif
 endfor   ; closes ns loop
endif

!p.multi=0

end
