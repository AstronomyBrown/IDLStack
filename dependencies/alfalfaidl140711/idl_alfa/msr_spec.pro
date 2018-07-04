; RG 21Feb05   Description later...

pro msr_spec,velarr,specarr,specst,filename=filename,rahr=rahr,decd=decd


sizz=size(specarr)
nchn=sizz[1]
if (sizz[0] gt 1) then begin
  if (nchn ne n_elements(velarr)) then begin
    print,nchn,n_elements(velarr),format='("spec size=2,",i4," vel size=",i4)'
    message,'Size inconsistency b/w velarr and specarr'
  endif
endif 
;if (nchn gt 4096) then begin
;  velarr=rebin(velarr,4096)
;  specarr=rebin(specarr,4096)
;  nchn=4096
;endif
bandwidth=100.0 ; HARDWIRED BW FOR ALFALFA
chwidth=bandwidth/nchn

; DEFINE RECORD FORMAT

record={ name: '', $              ; spectrum name, e.g. 002233+271506
         rahr: 0., $              ; R.A. (2000) in hrs
         decd: 0., $              ; Dec  (2000) in deg
         feed: 1,  $              ; front end nr: 0=alfa, 1=lbw
         strip:0L, $              ; strip nr of map/d_file
         nrec: 0L, $              ; rec nr near center of feature (approx)
         npol: 0L, $              ; pol nr: 0, 1 or 3
         d_file: lonarr(3), $     ; identifier for d-structure from which spec extracted
                                  ; d_file[0]=hhmmss, d_file[1]=ddmmss of rec 0, bm 0,
                                  ; d_file[2]=scannr of raw IDL d structure
         nchn:nchn,     $         ; number of spectral channels in spectrum
         cen_f:0.,      $         ; center freq in MHz, as observed
         cen_v:0.,      $         ; center velocity in km/s, as observed; if set, then
                                  ; tracking LO used
         restfrq: 1420.4058, $    ; rest freq. of line
         cen_ch:0L, $             ; ch nr for center freq/center velocity
         ch_fwidth: chwidth, $    ; channel width in MHz
         heliovelproj: 0.D, $     ; heliovel Doppler shift, projected to l.o.s.
         nchlo: 0L, $             ; lo chnr boundary of feature
         nchhi: 0L, $             ; hi chnr boundary of feature
         vcen: fltarr(8), $       ; central vel of feature (km/s) [8-array]
         vcenerr_stat:fltarr(8), $; statistical error on vcen (km/s) [8-array]
         vcenerr_sys:0.,  $       ; systematic error on vcen, e.g. as caused by choice of signal boundaries
         width: fltarr(8), $      ; width of feature (km/s) [8-array, diff methods]
         widtherr: fltarr(8), $   ; width error (km/s) [8-array], generally=vcenerr*sqrt(2)
         pks_nch: lonarr(2), $    ; channel nrs of 1st, second peak of spectrum
         pks_flx: fltarr(2), $    ; flux at 1st, second peak of spectrum
         slope_coeff_lo:fltarr(3), $ ; coeffs of fit to feature slope, low  side
         slope_coeff_hi:fltarr(3), $ ; coeffs of fit to feature slope, high side
         msr_modes: strarr(8), $  ; description of measure modes
         mean_int: 0., $          ; mean intensity of feature within [nchlo,nchhi]
         peak_int: 0., $          ; peak intensity of feature within [nchlo,nchhi]
         peak_int_ch: 0L, $       ; channel nr of peak_int
         flux_int: 0., $          ; flux integral within [nchlo,nchhi]
         flux_err_stat:0., $      ; statistical error on flux integral
         flux_err_sys:0., $       ; systematic errors on flux integral
         peak_abs:0., $           ; peak absorption flux
         peak_abs_err:0., $       ; peak absorption flux error
         taudv_int: 0., $         ; integral on tau dv
         taudv_int_err: 0., $     ; integral on tau dv error
         continuum: 0., $         ; continuum flux level at source frq.
         rms: 0., $               ; rms
         ston: fltarr(8), $       ; signal_to_noise ratio or equivalent indicator
                                  ; mode of S/N computation:
                                  ;    [0]=avg flux over feature*sqrt(width < 100kms)/rms
                                  ;    [1]=avg flux*sqrt(width)/rms
                                  ;    [2]=peak flux/rm
                                  ;    [3-8]=whatever
         smo: 0L, $               ; spectral smo code: e.g. 1=no smo, 3=han3, 5=han5,
                                  ;                         7=han7
         detcode: intarr(4), $    ; detection code[0]: 1=real,2=good,3=fair,4=marginal,
                                  ;                    5=poor,6=confused or blend,
                                  ;                    7=corrupted (rfi,etc),99=nondet
                                  ;     other 3 slots: up for grabs
         grd_mode: '', $          ; mode of grid, if spectrum extracted from gridded data
         grd_parms:fltarr(4), $   ; params of grid (kerlnel width, kernel truncation,...)
         grd_smo: 0L, $           ; spect smoothing on grid, if spectrum extr. from grd data
         grd_dra: 0., $           ; grid pixel sep in rahr, if spectrum extracted from grid
         grd_ddec: 0., $          ; grid pixel sep in decd, if spectrum extracted from grid
         phot_mode: 0, $          ; descriptor of mode of spatial integration:
                                  ;  1=over a rectangular box of bounds xmin,xmax,ymin,ymax
                                  ;  2=over a circle or radius phot_rad
                                  ;  3=over an ellipse of PA=phot_ell_pa, axes phot_ell_a,b
         phot_npix: 0L, $         ; nr of spatial pix over which spectrum averaged
         phot_box: lonarr(4), $   ; x1,y1,x2,y2: ll, ur pix corners of box for spatial avg
         phot_rad: 0., $          ; photom radius, pix, over which spatial avging done
         phot_ell_a: 0., $        ; major axis of phot ellipse of spatial avging done
         phot_ell_b: 0., $        ; minor axis of phot ellipse of spatial avging
         phot_ell_pa: 0., $       ; PA of major axis of ellipse of spatial avging
         baseline: dblarr(12), $  ; coeffs of poly-base subtracted after spect extraction
                                  ; (this is the *last* baseln event; doesn't carry previous)
         xmin: 0., $              ; min x-value for plot
         xmax: 0., $              ; max x-value for plot
         xunits: 0,$              ; units of x-arr: 0= vel[km/s], 1=ch nr
         ymin: 0., $              ; min y-value for plot
         ymax: 0., $              ; max y-value for plot
         yunits: 0,$              ; yunits of processed spectrum: 0= mJy, 1= Jy, 2= K, 3= instrumental units, 4= units of Tsys
         x_int: lonarr(16), $     ; extra slots, long integer 16-arr; for future use
         x_flt: fltarr(16), $     ; extra slots, float 18-arr
         x_dbl: dblarr(8), $      ; extra slots, double 8-arr
         x_str: strarr(16), $     ; extra slots, character string 16-array
         comments: '', $
         date_of_red: '', $       ; date of reduction
         name_of_red:'RG', $      ; name of reducer
         mjd: 0.D, $              ; modified Julian date of data taking, if unambiguous
         data: fltarr(4096,4)}    ; data arrays: [*,0]=vel arr
                                  ;              [*,1]=raw spectral intensity arr
                                  ;              [*,2]=smoothed,baselined spectral intensity array
                                  ;              [*,3]=rfi arr

;............................................................................................

name=''
reads,filename,name,format='(a15)'
record.name=name
record.nchn=nchn
record.cen_ch=record.nchn/2
;record.cen_v=7700.
;record.cen_f=1385.
; ON 2 FEB 05, WE SWITCHED FROM FIXED TO TRACKING LO IN A2010:
if (record.dfile[2] lt 503885138 and record.dfile[2] ne 0) then begin
  record.cen_f=1385.0
endif else begin
  record.cen_v=7663.
endelse
record.data[*,0]=velarr
record.date_of_red=systime()

if (n_elements(rahr) gt 0) then record.rahr=rahr
if (n_elements(decd) gt 0) then record.decd=decd

; DISPLAY SPECTRUM as FUNCTION OF CH NR AND REMOVE Y-OFFSET

sparr=specarr*1000.
plot,sparr,xtickformat='(i5)'
print,'Zoom in via hor? (def=y)'
ans=''
read,ans
if (ans eq 'y' or ans eq 'Y' or ans eq '') then begin
  dohor:
  print,'Enter hor limits, in CH NR, e.g.: 2000,2800'
  read,hor1,hor2
  hor,hor1,hor2
  plot,sparr,xtickformat='(i4)'
  Print,'OK? (def=y)'
  read,ans
  if (ans eq 'n' or ans eq 'N') then goto,dohor
endif
print,'Subtract a y-offset from spectrum? (def=n)'
ans=''
read,ans
if (ans eq 'y' or ans eq 'Y') then begin
  print,'Enter offset'
  read,ysub
  sparr=sparr-ysub
  plot,sparr,xtickformat='(i5)'
endif 
print,'Smooth the spectrum? (def=y)'
read,ans
if (ans eq '' or ans eq 'y' or ans eq 'Y') then begin
  print,'Hanning smo 3,5 or 7? Enter nr'
  read,nhan
  sparr=hans(nhan,sparr)
  record.smo=nhan
  plot,sparr,xtickformat='(i5)'
endif

; PLOT AS A FUNCTION OF CH NR AND APPLY BASELINE

;istat=bluser(velarr,sparr,coef,mask,yfit)
; bluser craps out on CURSORSUBSET rec 43, called by BLMASK at record 54,
; on "Attempt to subscript XAXIS with <LONG     (        4096)> is out of range"
; Haven't got the time to debug it. Use a simpler homemade baseline routine:

xch=findgen(nchn)
set_base:
bmask=lonarr(nchn)
repeat begin
  print, 'Left click LO chan of Base region, right k to exit...'
  cp, x=x, y=y
  b1=round(x)
  wait, 0.5
  if (!mouse.button eq 4) then goto, done_nreg
  print, 'Left click HI chan of Base region...'
  cp, x=x, y=y
  b2=round(x)
  wait, 0.25
  bmask[b1:b2]=1
  endrep until (!mouse.button eq 4)
done_nreg:
print,'Enter poly fit order'
read,nfit
bind=where(bmask eq 1)
coef=poly_fit(xch[bind],sparr[bind],nfit,yfit=yfit,/double)
fit=poly(xch,coef)
oplot,fit
print,'OK (def) or refit (r)?'
read,ans
if (ans eq 'r' or ans eq 'R') then goto,set_base

sparr=sparr-fit
record.data[*,1]=specarr
record.data[*,2]=sparr
record.baseline=coef
bind=where(bmask eq 1,nbind)
rms=stddev(sparr(bind))
print,rms,format='("rms over baseline region is:",f8.3," mJy")'
record.rms=rms

; PLOT AS A FUNCTION OF CH NR AND FLAG CHANNELS FOR MSR

plot,sparr
print,'Reset hor values for MSR? (def=n)'
read,ans
if (ans eq 'y' or ans eq 'Y') then begin
  print,'Enter hor (ch nr) limits for plot, e.g.: 2500, 3300'
  read,hor1,hor2
  hor,hor1,hor2
  plot,sparr
endif
flagmsr:
print,'Flag edges of spectral feature to be measured:'
print, 'Left click LEFT edge of feature'
cp, x=x, y=y
loch=round(x)
wait,0.5
print, 'Left click RIGHT edge of feature'
cp, x=x, y=y
hich=round(x)
flag,[loch,hich]
wait,0.5
print, 'Flag the low ch peak of feature'
cp, x=x, y=y
result=max(sparr[round(x)-1:round(x)+1],cmax)
lopk=cmax+round(x)-1
wait,0.5
print, 'Flag the high ch peak of feature'
cp, x=x, y=y
result=max(sparr[round(x)-1:round(x)+1],cmax)
hipk=cmax+round(x)-1
flag,[lopk,hipk]
wait,0.5
print, 'Give estimate of systematic vel error, in channels'
read,vcenerr_sys
 
smax1=sparr[lopk]
sch1=min(abs(sparr[loch:lopk]-0.5*smax1),wch1)
wch1=wch1+loch
if (sparr[wch1] lt 0.5*smax1) then begin
  c1=wch1+(0.5*smax1-sparr[wch1])/(sparr[wch1+1]-sparr[wch1])
endif else begin
  c1=wch1-1.+(0.5*smax1-sparr[wch1-1])/(sparr[wch1]-sparr[wch1-1])
endelse
smax2=sparr[hipk]
sch2=min(abs(sparr[hipk:hich]-0.5*smax2),wch2)
wch2=wch2+hipk
if (sparr[wch2] lt 0.5*smax2) then begin
  c2=wch2-1+(0.5*smax2-sparr[wch2-1])/(sparr[wch2]-sparr[wch2-1])
endif else begin
  c2=wch2+(0.5*smax2-sparr[wch2])/(sparr[wch2+1]-sparr[wch2])
endelse
plot,sparr
oplot,fltarr(nchn)
flag,[c1,c2]
print,'OK (def) or remeasure (r)?'
read,ans
if (ans eq 'r' or ans eq 'R') then goto,flagmsr

vcen=0.5*(velarr[c2]+velarr[c1])
width=abs(velarr(c2)-velarr(c1))
dv=width/abs(c2-c1)
flux_int=total(sparr[loch:hich])*dv/1000.
dnn=hich-loch
dnn2=dnn
if (dnn2 gt 20) then dnn2=20.
flux_err_stat=rms*dv*dnn/sqrt(dnn2)/1000.
flux_err_sys=0.07*flux_int ; THIS IS FOR THE LBW DATA: RESET FOR ALFA!
peak_int=max(sparr[loch:hich])
mean_int=mean(sparr[loch:hich])
peak_int_ch=where(specarr[loch:hich] eq peak_int)+loch
ston=fltarr(8)
ston[0]=mean_int*sqrt(dnn2)/rms
ston[1]=mean_int*sqrt(dnn)/rms
ston[2]=peak_int/rms

record.nchlo=loch
record.nchhi=hich
record.pks_nch=[lopk,hipk]
record.pks_flx=[sparr[lopk],sparr[hipk]]
record.vcen[0]=vcen
record.width[0]=width
record.flux_int=flux_int
record.flux_err_stat=flux_err_stat
record.flux_err_sys =flux_err_sys
record.peak_int=peak_int
record.peak_int_ch=peak_int_ch
record.mean_int=mean_int
record.ston=ston

; DO ERROR ON VEL, WIDTH, USING RESULTS OF SIMULATION RUN ON 20FEB05 BY RG

;slope1=((sparr[lopk]-rms)/rms)/abs(lopk-loch)
;slope2=((sparr[hipk]-rms)/rms)/abs(hich-hipk)
normstn1=(sparr[lopk]-rms)/rms
normstn2=(sparr[hipk]-rms)/rms
verr1=(0.5525-0.05383*normstn1+0.00140*normstn1^2)*abs(lopk-loch-1)/2.
verr2=(0.5525-0.05383*normstn2+0.00140*normstn2^2)*abs(hich-hipk-1)/2.
print,verr1,verr2
vcenerr_stat=dv*sqrt((verr1^2+verr2^2)/2.)
vcenerr_sys=dv*vcenerr_sys
print,vcenerr_stat,vcenerr_sys
vcenerr_tot=sqrt(vcenerr_stat^2+vcenerr_sys^2)
widtherr=sqrt(2.)*sqrt(vcenerr_stat^2+vcenerr_sys^2)

record.vcenerr_stat[0]=vcenerr_stat
record.vcenerr_sys=vcenerr_sys
record.widtherr[0]=widtherr


velstr=string(vcen,vcenerr_tot,     format='("Velocity=",f6.0,"+/-",f5.0," km/s")')
wdstr =string(width,widtherr,       format='("Width   =",f6.0,"+/-",f5.0," km/s")')
flxstr=string(flux_int,flux_err_stat,flux_err_sys,format='("Flux Int=",f6.2,"+/-",f5.2,"+/-",f6.2," Jy km/s")')
rmsstr=string(rms,                  format='("Rms     =",f6.2,"         mJy")')
stnstr=string(ston[0],              format='("S/N[0]  =",f6.2)')

xmin=velarr[hor1]
xmax=velarr[hor2]
ymin=min(sparr[hor1:hor2])
ymax=max(sparr[hor1:hor2])
doplot:
yrange=[ymin-0.05*(ymax-ymin),ymax+0.05*(ymax-ymin)]
xrange=[xmin,xmax]
plot,velarr,sparr,xrange=xrange,yrange=yrange,xtickformat='(i5)',xstyle=1,ystyle=1, $
     xtitle='cz [km/s]',ytitle='Flux Density [mJy]',title=name
xyouts,xmin+0.05*(xmax-xmin),ymax-0.10*(ymax-ymin),velstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.15*(ymax-ymin),wdstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.20*(ymax-ymin),flxstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.25*(ymax-ymin),rmsstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.30*(ymax-ymin),stnstr
print,'Reset plot limits? (def=n)'
read,ans
if (ans eq 'y' or ans eq 'Y') then begin
  print,'Enter xmin,xmax,ymin,ymax'
  read,xmin,xmax,ymin,ymax
  goto,doplot
endif

print,'Postscript output for plot? (def=n)'
read,ans
if (ans eq 'y' or ans eq 'Y') then begin
set_plot,'PS'
device,file='s'+name+'.ps'
plot,velarr,sparr,xrange=xrange,yrange=yrange,xtickformat='(i5)',xstyle=1,ystyle=1, $
     xtitle='cz [km/s]',ytitle='Flux Density [mJy]',title=name
xyouts,xmin+0.05*(xmax-xmin),ymax-0.10*(ymax-ymin),velstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.15*(ymax-ymin),wdstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.20*(ymax-ymin),flxstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.25*(ymax-ymin),rmsstr
xyouts,xmin+0.05*(xmax-xmin),ymax-0.30*(ymax-ymin),stnstr
device,/close
set_plot,'X'
endif

record.xunits=0
record.yunits=0
record.xmin=xmin
record.xmax=xmax
record.ymin=ymin
record.ymax=ymax

hor
ver

; UPDATE SPECST

if (n_elements(specst) eq 0) then begin
  specst=record
endif else begin
  specst=[specst,record]
endelse

end
