
pro CAT_HISTS_DISTANCE, CATNAME

;+
;NAME:
;	CAT_HISTS_DISTANCE
;PURPOSE:
; 	Makes EPS plots of the cz, w50, integrated flux, SNR, and mass histograms for
;	a catalog input in the *.table format (the output of distance_catalog.pro).
;	Uses the mass estimates from distance_catalog.pro for the HI mass histogram.
;
;	The height of the y-axis and the bin size for each histogram is set in the first few lines
;	of the program.
;
;	NOTE: Requires epsinit.pro and epsterm.pro to be compiled.
;
;CALLING SEQUENCE:
;	CAT_HISTS_DISTANCE, CATNAME
;
;INPUTS:
;	CATNAME - filename of the input catalog, in *.table format (the output of distance_catlog.pro).
;
;OUTPUTS:
;	hist_plots_mass.eps - an EPS plot with the 5 histograms stacked on top of each other.
;	
;REVISION HISTORY:
;	Created 2007 A. Saintonge
;	Documented July 2007, Ann Martin
;	
;
;-

;set the upper bound of the y-axis for each case (height of the largest histogram bin) and the bin size for each case
;upper bound & binsize for cz
czbin=500
czy=60
;upper bound & binsize for w50
w50bin=25
w50y=80
;upper bound & binsize for flux
fluxbin=0.1
fluxy=100
;upper bound & binsize for SNR
SNRbin=0.1
SNRy=160
;upper bound & binsize for himass
himassbin=0.2
himassy=160

;Reading in the catalog of galaxies
print,'reading the galaxy catalog'

openr,lun,catname,/get_lun

catnr=dblarr(1)
agcnumber=lonarr(1)
sign=''
optsign=''
cz=dblarr(1)
w50=dblarr(1)
werr=dblarr(1)
flux=dblarr(1)
fluxerr=dblarr(1)
snr=dblarr(1)
rms=dblarr(1)
distmpc=dblarr(1)
loghimass=dblarr(1)

i=0
while (eof(lun) ne 1) do begin

readf,lun,mycatnr,myagcnumber,rah,ram,ras,sign,decd,decm,decs,optrah,optram,optras,optsign,$
			     optdecd,optdecm,optdecs,mycz,myw50,mywerr,myflux,myfluxerr,mysnr,myrms,mydistmpc,myloghimass,code,$					
			     format='(i5,2x,i6,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,1x,i2,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,1x,i2,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)'

	if((CODE EQ 1) OR (CODE EQ 2)) then begin
		catnr=[catnr,mycatnr]
		agcnumber=[agcnumber,myagcnumber]
		cz=[cz,mycz]
		w50=[w50,myw50]
		werr=[werr,mywerr]
		flux=[flux,myflux]
		fluxerr=[fluxerr,myfluxerr]
		snr=[snr,mysnr]
		rms=[rms,myrms]
		distmpc=[distmpc,mydistmpc]
		loghimass=[loghimass,myloghimass]
	endif


endwhile
close,lun
free_lun,lun

catnr=catnr[1:*]
agcnumber=agcnumber[1:*]
cz=cz[1:*]
w50=w50[1:*]
werr=werr[1:*]
flux=flux[1:*]
fluxerr=fluxerr[1:*]
snr=snr[1:*]
rms=rms[1:*]
distmpc=distmpc[1:*]
loghimass=loghimass[1:*]

ngal=n_elements(agcnumber)
print,ngal,' good detections in the catalog'


;---------------------------------------------
; calculating distance and HImass for all the sources


index=where(loghimass lt 8.0)
print,n_elements(index)
print,agcnumber[index]

;goto,ending
epsinit,'hist_plots_mass.eps',xsize=6,ysize=10,/VECTOR
!p.multi=[0,1,5,0,0]

;==========
;cz PLOT

min_value=-100
max_value=18000
binsize=czbin
hist=histogram(cz,min=min_value,max=max_value,binsize=binsize)
nhist=n_elements(hist)

bins=lindgen(nhist)*binsize+min_value

x=fltarr(2*nhist)
x[2*lindgen(nhist)]=bins
x[2*lindgen(nhist)+1]=bins
y=fltarr(2*nhist)
y[2*lindgen(nhist)]=hist
y[2*lindgen(nhist)+1]=hist
y=shift(y,1)

plot,x,y,xrange=[-300,18000],yrange=[0,czy],xstyle=1,ystyle=1,xthick=2.,ythick=2.0,$
      thick=2.0,charthick=2.0,charsize=1.5,xtitle='cz[km/s]',ytitle='N',xtickname=['0','5000','10000','15000']
polyfill, [x, x[0]], [y, y[0]]
print,'cz',min(cz),max(cz)

;================
;W PLOT
min_value=0
max_value=600
binsize=w50bin
hist=histogram(w50,min=min_value,max=max_value,binsize=binsize)
nhist=n_elements(hist)

bins=lindgen(nhist)*binsize+min_value

x=fltarr(2*nhist)
x[2*lindgen(nhist)]=bins
x[2*lindgen(nhist)+1]=bins
y=fltarr(2*nhist)
y[2*lindgen(nhist)]=hist
y[2*lindgen(nhist)+1]=hist
y=shift(y,1)

plot,x,y,xrange=[-20,600],yrange=[0,w50y],xstyle=1,ystyle=1,xthick=2.,ythick=2.0,$
      thick=2.0,charthick=2.0,charsize=1.5,xtitle='W50[km/s]',ytitle='N'
polyfill, [x, x[0]], [y, y[0]]
print,'w',min(w50),max(w50)

;================
;Sint PLOT
min_value=-0.5
max_value=2.2
binsize=fluxbin
hist=histogram(alog10(flux),min=min_value,max=max_value,binsize=binsize)
nhist=n_elements(hist)

bins=lindgen(nhist)*binsize+min_value

x=fltarr(2*nhist)
x[2*lindgen(nhist)]=bins
x[2*lindgen(nhist)+1]=bins
y=fltarr(2*nhist)
y[2*lindgen(nhist)]=hist
y[2*lindgen(nhist)+1]=hist
y=shift(y,1)

plot,x,y,xrange=[-0.6,2.2],yrange=[0,fluxy],xstyle=1,ystyle=1,xthick=2.,ythick=2.0,$
      thick=2.0,charthick=2.0,charsize=1.5,xtitle='log10 Flux Integral [Jy km/s]',ytitle='N'
polyfill, [x, x[0]], [y, y[0]]
print,'s',min(alog10(flux)),max(alog10(flux))

;================
;S/N PLOT
min_value=0.5
max_value=3.0
binsize=SNRbin
hist=histogram(alog10(snr),min=min_value,max=max_value,binsize=binsize)
nhist=n_elements(hist)

bins=lindgen(nhist)*binsize+min_value

x=fltarr(2*nhist)
x[2*lindgen(nhist)]=bins
x[2*lindgen(nhist)+1]=bins
y=fltarr(2*nhist)
y[2*lindgen(nhist)]=hist
y[2*lindgen(nhist)+1]=hist
y=shift(y,1)

plot,x,y,xrange=[0.5,3.0],yrange=[0,SNRy],xstyle=1,ystyle=1,xthick=2.,ythick=2.0,$
      thick=2.0,charthick=2.0,charsize=1.5,xtitle='log10 S/N',ytitle='N'
polyfill, [x, x[0]], [y, y[0]]

print,'snr',min(alog10(snr)),max(alog10(snr))

;================
;HImass PLOT
min_value=6.0
max_value=11.0
binsize=himassbin
hist=histogram(loghimass,min=min_value,max=max_value,binsize=binsize)
nhist=n_elements(hist)

bins=lindgen(nhist)*binsize+min_value

x=fltarr(2*nhist)
x[2*lindgen(nhist)]=bins
x[2*lindgen(nhist)+1]=bins
y=fltarr(2*nhist)
y[2*lindgen(nhist)]=hist
y[2*lindgen(nhist)+1]=hist
y=shift(y,1)

plot,x,y,xrange=[6.0,11.0],yrange=[0,himassy],xstyle=1,ystyle=1,xthick=2.,ythick=2.0,$
      thick=2.0,charthick=2.0,charsize=1.5,xtitle='log10 HI Mass [solar]',ytitle='N'
polyfill, [x, x[0]], [y, y[0]]

print,'him',min(logHImass),max(logHImass)


xyouts,0.92,0.95,'a',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.75,'b',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.55,'c',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.35,'d',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.15,'e',charsize=1.5,charthick=2.0,/NORMAL


epsterm

ending:
end
