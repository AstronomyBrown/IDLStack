;+
;NAME:
;bpc1_rg16.pro  -  bandpass correct (1D) one strip of a map
;
;SYNTAX:
;
;pro bpc, strip_in, strip_out, calmask=calmask, PLOT=plot,  $     
;         pause=pause,wn1=wn1, wn2=wn2,waitime=waitime,$
;	  force_interp=force_interp,interp_reg=interp_reg, $
;         occupancy=occupancy,rmsarr=rmsarr,BP0=BP0,BPn=BPn,totBPg=totBPg, $
;         contmask=contmask,bmask=bmask,cmask=cmask,Tsys_nosrc=Tsys_nosrc, $
;         Cont_pts=Cont_pts,Totalcounts=Totalcounts, $
;         Cont_strips=Contstrips
;
;PARAMETERS:
;
;	strip_in  	input 2D array (spectral values,records) input strip
;       strip_out	output strip, bp corrected
;       calmask		1D mask used for Tcal noise calibration, from ncalib \st
;
;OPTIONAL OUTPUT PARAMETERS:
;
;	occupancy	fraction of all records in the strip, for which
;			a given spectral channel does not depart from
;			fit by more than (+3,-5) stdd devs
;	rmsarr		array of power stdd devs along the strip, as (chnr)
;	BP0		1D BP shape
;	BPn		normalized BP, i.e. BP/totBPg
;       totBPg		mean value of BP over "power floor"  
;	contmask	2D mask used to estimate continuum
;	bmask		integer array (nchn,nrec):
;                       =1 pixel is < 3*rms of BP level
;                       =0 pixel is > +3*rms of BP level
;                       this can exclude entire records
;                       if strong cont src present; used to estimate "occupancy"
;	cmask		1D mask, flags sp channels we interpolate BP across
;	Tsys_nosrc	continuum "baseline" along strip, after removal
;			of point sources
; 	Cont_pts	continuum point source profile along strip
;	Totalcounts	total continuum profile along strip = Cont_pts + Tsys_nosrc
;	Cont_strips	continuum profile in 10 contiguous bands
;
;KEYWORDS:
;
;	pause		set to >0 if you wish to plot each individual
;                       profile Power(chn) b/w/ chn wn1 and wn2
;	wn1,wn2		boundaries of range of chn nrs to disply
;			power profile across strip (if pause set)
;	waitime		time in sec to stare at each plot (if pause set)
;	plot		set to >0 if you wish output plots
;	force_interp	set to >0 if you wish to "manually" interpolate
;	interp_reg      boundaries of interpolation regions, e.g.
;                       to interpolate b/w n1 and n2, b/w n3 and n4:
;                       interp_reg=[n1,n2,n3,n4]
;
;
;DESCRIPTION:
;
;Given a strip of nrec records of nchn spectral channels each, it
;computes a 1D "OFF" bandpass, excluding records with continuum 
;sources, strong emission lines and RFI. It goes through each
;spectral channel time series along the strip, fits a straight
;line to it and excludes outliers to the fit. The BP value for
;that sp. channel can be:
;(a) the c0 coeff in the linear fit c0+c1*x (after excl. outliers)
;(b) the median value of the strip (after excl. outliers)
;The keyword bpval selects between options (a) and (b) (0 and 1)
;It currently operates for a single polarization and a single
;correlator board at a time.

;This IDL procedure takes as input a strip (position, freq) of a data 
;cube(ra,dec,freq) and fits a 3rd order polynomial as a function of pos.
;for each channel number.  The user has the option of slowing the routine
;to better analyze problem spots (i.e. transient RFI), with the option 
;pause=1.  The problem channels can be specified in wn1 and wn2 as input
;from the procedure.

;In PART I, we fit a poly (n=1) to the array of size nrec, across the
;time domain (i.e. along the strip), ONE SPECTRAL CHANNEL AT A TIME.
;records which, for the particular spectral channel, are off scale,
;are bypassed in the calculation of the bandpass BP0. The value of 
;the BP0 depends on the value of the keyword "bpval".
;An rms (across the strip direction) is computed for each sp ch
;An "occupancy fraction", i.e. the fraction of records in the
;strip that are within few stddev from the fit, is also computed.
;Both rms and the occupancy fraction are arrays of size nchn

;In PART II, we inspect the rms array, of size nchn, and see which
;channels have problems, indicated by a large rms. The rms array
;is fitted by a polynomial, progressively excluding channels with
;large rms from the fit, in an iterative fashion. Afer few iterations,
;channels still "bad" are flagged (edges of bandpass are left alone).
;Regions of spectrum can also be "manually flagged", e.g. regions
;with galactic HI or with persistent rfi. If, e.g. 
;      force_interp=1,interp_reg=[450,480,670,700]
;it will interpolate BP between spectral channels 450 and 480
;and between spectral channels 670 and 700. Number of interpolation
;regions is arbitrary.
;The bandpass is interpolated across the "bad" channels, using a
;cubic spline.

;In PART III, we bandpass corrrect the full strip ==> strip_out
;Each record of strip_out is an "ON"; 
;the "OFF" is the normalized BP times Tsys; 
;Tsys is computed for each record as the
;sum over all channels of the OFF; then the BP corrected spectrum is
;                        ((ON-OFF)/OFF)*Tsys

;RG - last update 040812


;***************************************************************************

; NAME:
; medsecs.pro  - breaks array in sections and computes section medians
;
;Syntax:
;
; medsecs,yarr,nsec,xmed,medarr,nmed,xarr=xarr,mask=mask
;
;DESCRIPTION:
; 
; The input array yarr is subdivided into nsec sections 
; of array elements, and median values are computed for each section. 
; Array values for which an optional mask is = 0 are excluded.
; If fewer than 3 array elements in a section have mask ne 0, the median
; value for that section is set to 1.e8.
; The array of nsec median values, the x-coord of the center of the 
; corresponding section and the number of valid elements used to 
; compute median in that section, are returned.

pro medsecs, 	yarr, $		; input array of y-values
		nsec, $		; number of sections to subdivide arr
		xmed, $		; x-coord of center of each subsection (output)
		medarr, $	; median value for section (output)
		nmed, $		; number of elements used for median of section (output) 
		xarr=xarr, $	; array of x-values going with yarr [def=findgen(nsmp)]
		mask=mask	; mask array: =0 if array element to be skipped 
				; [def=intarr(nsmp)+1]


nsmp = n_elements(yarr)
nsub = nsmp/nsec
if (n_elements(xarr) eq 0)   then xarr=findgen(nsmp)
if (n_elements(arrmin) eq 0) then arrmin=min(yarr)
if (n_elements(arrmax) eq 0) then arrmax=max(yarr)
if (n_elements(mask) eq 0) then begin
  localmask = intarr(nsmp)+1
endif else begin
  localmask = mask
endelse

xmed = findgen(nsec)*nsub+nsub/2.
medarr = fltarr(nsec)
nmed = intarr(nsec)

; COMPUTE MEDIANS
for imed=0,nsec-1 do begin
  n1 = imed*nsub
  n2 = n1+nsub-1
  icon = where(localmask[n1:n2] ne 0, ncon) + n1
  if (ncon le 3) then begin
    medarr[imed] = 1.e8
  endif else begin
    medarr[imed] = median(yarr[icon],/even)
  endelse
  nmed[imed] = ncon
endfor

end


;***************************************************************************
pro bpc,   strip_in, $	; input 2d map
	   strip_out,$	; output 2d map
           calmask=calmask, $ ; mask used to measure CalON/CalOF TP
	   PLOT=plot,$  ; option to plot (=1) BP computation per each ch nr
           pause=pause,$; option to pause waitime b/w one ch display and next
           wn1=wn1, $	; start displaying from this ch nr
	   wn2=wn2, $	; stop displaying at this ch nr
	   waitime=waitime,$; pause time b/w chn displays
           force_interp=force_interp,$ ; if >1, interpolate BP b/w interp_regions
	   interp_reg=interp_reg, $ ; chn nrs across which BP needs interpoln
           occupancy=occupancy, $ ; occupancy array = n(good recs)/n(bad recs) for each sp chn
	   rmsarr=rmsarr, $	; rms arrray, rms for each sp chn, computed across rec direction
	   BP0=BP0, $	; Bandpass array
	   BPn=BPn, $	; normalized BP
	   totBPg=totBPg, $; integral of bandpass array
	   contmask=contmask, $  ; 2d mask used for Totalcounts (=1 for used pix) 
                                 ; equal to mask_for_contstrips*calmask
           mask_for_contstrips=mask_for_contstrips, $ ; mask used for Cont_strips
	   bmask=bmask, $	; first order BP, computed after ch by ch pass
	   cmask=cmask, $	; second pass mask, computed by inspecting rmsarr
	   Tsys_nosrc=Tsys_nosrc,$ ; System temp run, cont srcs removed
	   Cont_pts=Cont_pts, $  ; point src profile
	   Totalcounts=Totalcounts,$; Tsys_nosrc+Cont_pts
           Cont_strips=Cont_strips  ; 2d continuum map: 10 spectral strips, nrec records


         
;***************************************************************************

;PART 0. Check parameters & keywords

t00=systime(1)

if (n_elements(strip_in) eq 0) then $
   message,'You must specify the name of the input strip file'
if (n_params() lt 2) then $
   print,'No name entered for output file:', $
   '   ...are you sure you wish to see but not to play with output?'
if (n_elements(pause) eq 0) then begin
    xpause = 0
endif else begin
    xpause = 1
endelse
if (xpause) then begin
   if (n_elements(wn1) eq 0 or n_elements(wn2) eq 0 or $
               n_elements(waitime) eq 0) then $
    message, 'If you want to pause display, enter WN1, WN2 and WAITIME'
endif
if (n_elements(force_interp) ne 0 and n_elements(interp_reg) eq 0) then $ 
    message, 'You must enter array of forced interpolation windows...'
n_interp_reg=round(n_elements(interp_reg)/2)

;window,/free, retain=2	  ; Window to display successive plots for each channel

nrec     = n_elements(strip_in[0,*])	; Number of records along strip
nchn     = n_elements(strip_in[*,0])	; Number of spec. channels
x        = findgen(nrec)		; x-axis as f(rec) along strip
xx       = findgen(nchn)                ; x-axis as f(nch)
ind      = indgen(nchn)                 ; index nr eq to channel nr
occupancy= fltarr(nchn)			; Occupancy Array, values from 0 to 1
rmsarr   = fltarr(nchn)			; RMS array after polynomial fit
nfit1    = 1				; order of polyfit along strip
BPcoeff  = fltarr(nchn,nfit1+1)		; nchn by 4 array  - holds coefficients
					;    of polynomial for each channel
BPerr    = fltarr(nchn)			; Errors of fit for each channel
BP0      = fltarr(nchn)			; strip 1-d bandpass
medbp	 = fltarr(nchn)			; median bandpass

if (n_elements(calmask) eq 0) then begin ; use default for TP of CalON/CalOF
  calmask=bytarr(nchn)
  calmask[800:1800] = 1B
  calmask[2350:3400] = 1B
endif
;...........................................................................

; PART I
; Loop through each spectral channel and produce 1st order BP
;  Split nrec into 2 sections and each of those into 16 subsections. 
;  For each of the 2x16 subsections, compute median. 
;  From each section, pick the subsections with the lowest 4 medians 
;         ==> 8 subsections, 1/4 of the total set of nrec records
;  Fit a straight line to the 8 medians; value of the fit at record nrec/2 
;         ==> that'll be your BP value for that channel; now find "good" recs
;  Keeping fit fixed:
;    find rms of all nrec recs about fit, exclude points exceeding 3*rms and 
;         recompute rms; loop 4 times
;    remaining recs within 3*final rms are "good" (=1) in bmask. Others get 
;    flagged as bad (=0); final rms gets written into rmsarray
;    occupancy array is n(good)/nrec
;  In doing so, we are excluding most records with continuum sources & rfi
;  We do separately 2 sections b/c there may be an overall slope in the
;  continuum background (e.g. near spurs), and we don't want all low 
;  subsection medians to be on one end of the drift.

t0=systime(1)

bmask=intarr(nchn,nrec)+1

for i=0,nchn-1 do begin
   ch = reform(strip_in[i,*])
   medsecs,ch,32,xmed,medarr,nmed
   loindx=intarr(8)
   sortmedarr_indx=sort(medarr[0:15])
   loindx[0:3]=sortmedarr_indx[0:3]
   sortmedarr_indx=sort(medarr[16:31])
   loindx[4:7]=sortmedarr_indx[0:3]+16
   a=poly_fit(xmed[loindx],medarr[loindx],1,yfit=yfit,/double)
   fit = poly(x,a)
   BPset = fit[nrec/2]	; set = fit at center of drift
   res = ch - fit
   goodrec=lindgen(nrec)
   for ntimes=0,3 do begin
     rms = stddev(res[goodrec])
     goodrec = where(res le 2.0*rms,good_count)
   endfor
   badrec = where (res gt 2.0*rms,bad_count)

   if (bad_count gt 0) then bmask[i,badrec] = 0

   rmsarr[i] = rms
   occupancy[i] = float(good_count)/nrec
   BP0[i] = BPset

   if (xpause) then begin
     if(i le wn2 and i ge wn1) then begin
        plot, x,res, linestyle=0, $
        title='Channel number' + string(i+1),$
 	xtitle='Record nr along strip', ytitle='Intensity',$
        charsize=2.0,xrange=[0,nrec-1], yrange=[-0.05,0.05]
        oplot, fltarr(nrec)-mean(ch)+BP0[i]
        oplot,bmask[i,*]-0.98
        oplot,fltarr(nrec)+2.*rms
        oplot,fltarr(nrec)-5.*rms
        xyouts,600,0.04,'rms='+string(rms)
        stare=waitime
     endif else begin
        stare=0
     endelse
     wait, stare
   endif
endfor				;ENDFOR1

BP0 = hans(3,BP0)		; han smooth the bandpass

; we have produced:
;	BP0[0:nchn-1]	a 1D bandpass array of nchn elements
;	rmsarr "	a 1D rms array
;	occupancy	a 1D occupancy array (fraction of good recs for each chn)
;	bmask[nchn,nrec] a 2D lon array: =1 if pix OK, =0 if pix outlier 

rms_norm=(rmsarr/BP0)*100.  ; Normalize the rms and plot stuff

if (n_elements(plot) gt 0) then begin
; 4 plots in the same window: Occupancy, RMS, Mean BP, RMS Norm
	window,/free,retain=2
     	!p.multi=[0,2,2,2]
     	plot,occupancy, title='Occupancy Fraction', $
	xtitle='Channel Number', ytitle='Occupancy Fraction', $
	charsize=1.0, yrange=[0.5,1]
     	plot,rmsarr, title='RMS level', xtitle='Channel Number', $
	ytitle='RMS', charsize=1.0
	plot,BP0, title='Mean Bandpass', $
	xtitle='Channel Number',ytitle='Intensity', charsize=1.0
	plot,rms_norm, title='Normalized RMS = (rms/mean_BP)*100',$
        xtitle='Channel Number', ytitle='RMS Norm', charsize=1.0
        !p.multi=0
endif

t1=systime(1)
;print,'Time on Part I: ',t1-t0

;..........................................................................

; PART II 
; Now we inspect the 1D rms array; if for a given channel the rms is
; unusually large, we call "bad" all nrec pixels for that channel,
; and interpolate the BP across it.
; Check only channels within inner ~90% of bandpass; whatever's in the
; edges of the BP, is left unchanged
; Compute a spline interpolation over the whole BP spectrum, using the
; good spectral channels and replace the values of BP at sp channels
; that require interpolation with the spline (edges of BP remain unchanged)

t0=systime(1)

; First mask edges of the bandpass 
nedge   = 0.055*nchn   ; THIS FALLS ROUGHLY AT THE 3DB POINT OF THE BP SKIRT
lo_edge = round(nedge)
hi_edge = round(nchn-nedge)
tmp = intarr(nchn)+1
tmp[0:lo_edge] = 0
tmp[hi_edge:(nchn-1)] = 0

; Then mask channels within force_interp regions (gal HI or rfi)
if (n_elements(force_interp)) then begin
   for nreg=0,n_interp_reg-1 do begin
      nn1 = interp_reg[nreg*2]
      nn2 = interp_reg[nreg*2+1]
      tmp[nn1:nn2] = 0
   endfor
endif

; Now go find bad channels by checking large rms

tmpp = tmp
for loop=0,3 do begin   ; four itns enough. Loop ends at ENDFOR4
  measure_errors=(-(tmpp-1.)*1e5+1.D)
  a=poly_fit(xx,rms_norm,1,yfit=yfit, $
             yband=yband,measure_errors=measure_errors,/double)
  res = rms_norm-yfit
  goodch = where(tmpp eq 1,good_count)
  rmsrms = stddev(res[goodch])
  badch  = where(res gt 2.5*rmsrms or res lt -4.*rmsrms or tmp eq 0)
  tmpp = tmp
  tmpp[badch] = 0
endfor       ; ENDFOR4

; enter in mask rfi spikes of constant intensity
shiftBP = shift(BP0,2)
rmsbp = stddev(BP0-shiftBP)
nspike = where(BP0-shiftBP gt 3.0*rmsbp,nss)
tmpp[nspike] = 0
; broaden by 1 ch each side regions w/ sp chns already masked, for safety
shiftmaskp1 = shift(tmpp,1)
shiftmaskm1 = shift(tmpp,-1)
tmpp=tmpp+shiftmaskp1+shiftmaskm1
goodch = where(tmpp eq 3, gcount)	; will be used for Tsys
badch  = where(tmpp lt 3, bcount)	; will be used for Tsys
tmpp[goodch] = 1
tmpp[badch]  = 0
tmp = tmpp
tmp[0:lo_edge] = 1
tmp[hi_edge:nchn-1] = 1
keep_ch = where(tmp eq 1,kcount)	; BP chans not to be changed
interp_ch  = where(tmp eq 0,intcount)	; BP chans to be interpolated

cmask=intarr(nchn)+1
cmask[badch] = 0			; =0 all badch "columns"
; cmask now sets =0 all channels that are to be interpolated
; In Part III, we'll combine it with bmask to obtain a mask to measure TP
; We couldn't use bmask for that, b/c it excluded entire records,
; when continuum sources are present.

;OK, now go to interpolate

xxx= xx(keep_ch)
yyy= median(BP0(keep_ch),5)
yy = spline(xxx,yyy,xx,1.0)
;IN CASE SPLINE FAILS (IT OCCASIONALLY DOES...) TRY LINEAR INTERPOLTN:
inn=where(finite(yy) eq 0, innc)
if (innc gt 0) then yy=interpol(yyy,xxx,xx)
BP0[interp_ch] = yy[interp_ch]
;  Note: we only modify BP at interp_ch; BP remains unchanged at edges
;  badch includes: edges, interpolated regions and channels w/large rmsarr
;  goodch is the complement of badch

t2=systime(1)
;print,'Time on Part II: ',t2-t0


;........................................................................
;PART III
; Here we compute:
;=> Totalcounts is the total nr of counts (including BP), over
;   all goodch spectral channels, for each record along the strip
;=> Tsys_nosrc is a poly-fit to Totalcounts, after excluding the
;   continuum point sources. In const ZA drifts, it should be
;   nearly flat - changing only as the "electronic gain" of the
;   system varies. In other cases, it mainly reflects the change
;   of gain resulting from telescope motion.
;=> Cont_pts = Totalcounts - Tsys_nosrc
;   is the continuum emission by pt sources, along the strip
;=> strip_out : the bandpass calibrated spectral line data,
;   with continuum sources removed, as in
;            ((ON-OFF)/OFF)*T_sys
; ON is strip_in[chnr,recnr]
; OFF is normalized BPn*Tsys
; Tsys is Totalcounts in units of integrated (over goodch) backend counts
;=> cmask : 1D array (=0 for bad channels, =1 for good ones),
;   separately specified for each record of the strip.

t0 = systime(1)

; Must create a reliable mask to compute continuum power. Cannot use 
; bmask, because it masks continuum sources; cannot use cmask because
; it is effectvely a 1-D mask, for egregious constant frq rfi and galactic
; HI. We estimate new mask - contmask - by repeating process in Part I,
; this time in the spectral rather than time direction, i.e. one spectrum
; at a time.


contmask  = intarr(nchn,nrec) + 1
mask_for_contstrips = contmask
Totalcounts = fltarr(nrec)
strip_1   = fltarr(nchn,nrec)
strip_out = fltarr(nchn,nrec)
Cont_pts  = fltarr(nrec)  

; RESTRICT totBPg to a subset of chns of calmask
totBPg = total(BP0*cmask*calmask)/total(cmask*calmask)
BPn = BP0/totBPg

; get boundaries of 128 sections of spectrum

nr_c = 128
nnn = nchn/128
n1=indgen(nr_c)*nnn	 	;n1,n2 are boundaries of
n2=n1+nnn-1			;nr_c sections of spectrum
xmed = findgen(nr_c)*nnn + nnn/2.

for ismp=0,nrec-1  do begin

   strip_1[*,ismp] = strip_in[*,ismp]/BPn[*] ; flat spectrum, w/ zeropt
                                             ; near (iffy) cont level
   inn=where(finite(strip_1[*,ismp]) eq 0, count)
   if (count gt 2) then begin
     strip_out[inn,ismp]=-999.
     Totalcounts[ismp]=-999.
     Tsys_nosrc[ismp]=-999.
     goto, passOnThis
   endif

;  Cycle through the 128 spectral sections and find the baseline "floor"
;  as the median of the lowest 8 sections. Then fit 1st order baseline to
;  windowed data around floor and use to determine contmask. 

  medsecs,strip_1[*,ismp],128,xmed,medarr,nmed,mask=cmask

; find the "floor", separately in each half of spectrum, excluding edges
  loindx = intarr(64)
  sortmedarr_indx = sort(medarr[8:(nr_c/2-1)])
  loindx[0:31] = sortmedarr_indx[0:31] + 8
  sortmedarr_indx = sort(medarr[nr_c/2:(nr_c-8)])
  loindx[32:63] = sortmedarr_indx[0:31] + nr_c/2
  a = poly_fit(xmed[loindx],medarr[loindx],1,yfit=yfit,/double)
  fit = poly(xx,a)
;  yyfit=poly(xmed,a)
;    hor,300,3800
;  IF (ISMP eq 200) THEN BEGIN
;    PRINT, ISMP,loindx
;    plot,xmed,medarr,psym=5
;    oplot,xmed[loindx],medarr[loindx],psym=4,symsize=2.
;    oplot,xmed,yyfit,color=6
;    wait,1.
;    plot,xx,strip_1[*,ismp]
;    oplot,fit,color=4
;    WAIT,1.
;  ENDIF  

  thismask=intarr(nchn)
  for kk=0,63 do begin
    indx1=n1[loindx[kk]]
    indx2=n2[loindx[kk]]
    thismask[indx1:indx2]=1
  endfor
  res = strip_1[*,ismp] - fit
  loch = where(thismask eq 1)
  rms = stddev(res[loch])
  goodch = where(abs(res) lt 3.*rms and cmask ne 0,good_count)

; CHOOSE FITOPTION HERE: ONE HIGH ORDER BASELINE OR 2 LOWER ORDER?
  fitoption=2

  case fitoption of
  1: begin
;    SINGLE FIT TO FULL NCHN BAND; ALTERNATIVE TO SEPARATE FIT TO 2 HALVES
     for ntimes=0,2 do begin
       b=poly_fit(xx[goodch],strip_1[goodch,ismp],5,yfit=yfit,/double)
       res = strip_1[*,ismp]-poly(xx,b)
       hres=hans(5,res)
       rms = stddev(hres[goodch])
       goodch = where(abs(hres) le 2.5*rms and cmask ne 0,good_count)
     endfor
     end
  2: begin
;    LOWER ORDER FIT TO EACH OF TWO HALVES OF BAND; ALTERNATIVE TO SINGLE FIT
;    THIS IS A BIT FASTER
     ccm=cmask
     for ntimes=0,2 do begin
       mm1=ccm[0:2000]
       mm2=ccm[1750:4095]
       xx1=xx[0:2000]
       xx2=xx[1750:4095]
       gch1=where(mm1 eq 1, ng1)
       gch2=where(mm2 eq 1, ng2)
       c1=poly_fit(xx1[gch1],strip_1[xx1[gch1],ismp],3,yfit=yfit,/double)
       fit1=poly(xx,c1)
       c2=poly_fit(xx2[gch2],strip_1[xx2[gch2],ismp],3,yfit=yfit,/double)
       fit2=poly(xx,c2)
       res=strip_1[*,ismp]-fit1
       res[1845:(nchn-1)]=strip_1[1845:(nchn-1),ismp]-fit2[1845:(nchn-1)]
       hres=hans(5,res)
       rms = stddev(hres[goodch])
       goodch = where(abs(hres) le 2.5*rms and cmask ne 0,good_count)
       ccm=intarr(nchn)
       ccm[goodch]=1
     endfor
     end
     else: print,'fitoption must be 1 or 2'
  endcase

  thismask=intarr(nchn)
  thismask[goodch] = 1
  contmask[*,ismp] = thismask*calmask  ;contmask restricted to subset of calmask
  mask_for_contstrips[*,ismp] = thismask

  Totalcounts[ismp] = total(strip_in[*,ismp]*contmask[*,ismp])/total(BPn[*]*contmask[*,ismp])
  strip_out[*,ismp] = res[*]

endfor

; Now go find the"baseline" continuum drift of Totalcounts and separate
; it from continuum sources. 
;      Continuum drift will be ==> Tsys_nosrc
;      Continuum point sources ==> Cont_pts
;      Total continuum         ==> Totalcounts
; Loop few times through nrec to exclude records w/cont srcs
; (this we did in Part I on each spectral chn; now we do on Totalcounts only,
; so we cannot use goodrec of Part I, which was computed for each cp chan)

yrec1 = Totalcounts

;  nfit=3 will not always work well, unable to fit wiggly "baselines",
;  which will occur. However, using a higher order can produce even
;  more frequent problems, especially at the ends of the strip. I
;  prefer the former. Analysis of the continuum maps will require TLC.
goodrec=indgen(nrec)   ; initialize goodrec again

tmp = intarr(nrec) + 1
for loop=0,5 do begin		;loop ends at ENDFOR7
   measure_errors = -(tmp-1.)*1.e5 + 1.D
   coeff9 = poly_fit(x,yrec1,3,YFIT=yfit, $
            yband=yband,measure_errors=measure_errors,/double)
   yres = yrec1 - yfit
   goodrec = where (tmp eq 1,gcount)
   sdev = stddev(yres[goodrec],/NAN)
   goodrec = where(yres lt 1.0*sdev,gg)
   badrec  = where(yres ge 1.0*sdev,bb)
   tmp[goodrec]= 1
   if (bb gt 0) then tmp[badrec] = 0
;  use only the lowest recs to fit, rather than fitting through weak srcs
endfor				;ENDFOR7

Tsys_nosrc = yfit
Cont_pts   = Totalcounts - Tsys_nosrc
medval     = median(Cont_pts[goodrec],/even)
meanval    = mean(Cont_pts[goodrec])
Cont_pts   = Cont_pts - medval
Tsys_nosrc = Tsys_nosrc + medval
; this last correction is tiny but appropriate; equivalent along strip
; of correction in spectral domain of sttt SPEC_ZERO_ADJUST

; Now create continuum array: continuum maps over several spectral windows

Cont_strips=fltarr(10,nrec)
strip_2=strip_in
goodchreg=indgen(nchn)
edg_to_edg = hi_edge-lo_edge
d_edg=floor(edg_to_edg/10.)
n1=indgen(10)*d_edg+lo_edge
n2=n1+d_edg-1
for ismp=0,nrec-1  do begin
   strip_2[*,ismp] = strip_in[*,ismp]/BPn[*] - Tsys_nosrc[ismp]
;  strip_2 is now BP-corrected, cont. "baseline"-subtracted
;  it does however retain continuum point sources
   for nsec=0,9  do begin
      icon = where(reform(mask_for_contstrips[n1[nsec]:n2[nsec],ismp]) ne 0,ncon)+n1[nsec]
      if (ncon le 0) then begin
        Cont_strips[nsec,ismp]=0.
        print,'No good channels found to get cont on (nsec,nrec)=',nsec,ismp
        goto, endloop
      endif 
      Cont_strips[nsec,ismp] = mean(reform(strip_2[icon,ismp]))
      endloop:
   endfor
endfor

PassOnThis:
t3=systime(1)
;print,'Time in Part III: ',t3-t0
;print,'Time on bpc : ',t3-t00


;_______________________________________________________________



if (n_elements(plot) gt 0) then begin
; 4 plots in the same window: Occupancy, RMS, Mean BP, RMS Norm
	window,/free,retain=2
     	!p.multi=[0,2,2,2]
     	plot,occupancy, title='Occupancy Fraction', $
	xtitle='Channel Number', ytitle='Occupancy Fraction', $
	charsize=1.0, yrange=[0.5,1]
     	plot,rmsarr, title='RMS level', xtitle='Channel Number', $
	ytitle='RMS', charsize=1.0
	plot,BP0, title='Mean Bandpass (Pass 1)', $
	xtitle='Channel Number',ytitle='Intensity', charsize=1.0
	plot,rms_norm, title='Normalized RMS = (rms/BP0)*100',$
        xtitle='Channel Number', ytitle='RMS Norm', charsize=1.0

     	!p.multi=[0,2,2,2]
        plot,badch,BP0[badch],psym=6,color='00FF00'XL,$
	title='Mean Bandpass',xtitle='Channel Number', $
	ytitle='Response', xrange=[0,nchn]
        oplot,BP0
	plot,rms_norm, title='Normalized RMS', xtitle='Channel Number',$
 	ytitle='RMS Norm', charsize=1.0, yrange=[0.5,1.5]
        oplot, rfit[0,*], color='00FF00'XL
        oplot, rfit[1,*], color='FF00FF'XL
        oplot, rfit[2,*], color='FFFF00'XL
        oplot, rfit[3,*], color='00FFFF'XL
	oplot, goodch, rms_norm[goodch], color='00FF00'XL
        plot,Tsys_nosrc,title='System Temperature',$
        yrange=[min(Tsys_nosrc),max(Tsys_nosrc)],$
 	xtitle='Record Nr'
        plot,reform(Cont_strips[0,*]), $
	title='Spectrally Integrated Strip Profile',$
	xtitle='Record Nr.',ytitle='T (K)'
        !p.multi=0
	imgdisp,strip_out,/histeq
endif
end			; End of procedure
	
