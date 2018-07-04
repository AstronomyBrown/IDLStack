
pro CAT_HISTS_GALCAT, CATNAME

;+
;NAME:
;	CAT_HISTS_GALCAT
;PURPOSE:
; 	Makes EPS plots of the cz, w50, integrated flux, and SNR histograms for
;	a catalog input in the standard catalog format output by GALCAT. For the final
;	product (the figure in an ALFALFA paper), we include a histogram of the mass as well,
;	so this program serves as a first check.
;
;	The height of the y-axis and the bin size for each histogram is set in the first few lines
;	of the program.
;
;	NOTE: Requires epsinit.pro and epsterm.pro to be compiled.
;
;CALLING SEQUENCE:
;	CAT_HISTS_GALCAT, CATNAME
;
;INPUTS:
;	CATNAME - filename of the input catalog, in standard GALCAT format.
;
;OUTPUTS:
;	hist_plots_nomass.eps - an EPS plot with the 4 histograms stacked on top of each other.
;
;NOTES:
;	The bin sizes for each are currently set as:
;	cz: 500 km/s
;	W50: 25 km/s
;	log10 (Flux Integral): 0.1
;	log10 S/N: 0.1
;
;	Riccardo, on the other hand, used 250, 10, 0.04, 0.025, and 0.1 for cz, W50, log10 Flux integral, log10 S/N, and log10 HI Mass
;	
;	
;REVISION HISTORY:
;	Created 2007 A. Saintonge
;	Documented July 2007, Ann Martin
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


;Reading in the catalog of galaxies
print,'reading the galaxy catalog'

openr,lun,catname,/get_lun

agcnumber=lonarr(1)
hiname=''
agcname=''
sign=''
optsign=''
cz=dblarr(1)
w50=dblarr(1)
werr=dblarr(1)
flux=dblarr(1)
fluxerr=dblarr(1)
snr=dblarr(1)
rms=dblarr(1)


i=0
while (eof(lun) ne 1) do begin

readf,lun,HINAME,MYAGCNUMBER,AGCNAME,RAH,RAM,RAS,SIGN,DECD,DECM,DECS,dRA,dDEC,$
			OPTRAH,OPTRAM,OPTRAS,OPTSIGN,OPTDECD,OPTDECM,OPTDECS,HSIZE,MYCZ,CZERR,MYW50,MYWERR,MYFLUX,MYFLUXERR,SINTMAP,MYSNR,$
			MYRMS,CODE,GRIDID,$
		format='(A17,1X,A6,1X,A8,2X,2I2,F4.1,A1,3I2,1X,I3,1X,I3,2X,2I2,F4.1,A1,3I2,1X,F6.1,1X,I5,2X,I3,2X,I4,2X,I3,2X,F6.2,1X,F5.2,2X,F6.2,2X,F5.1,1X,F5.2,3X,I1,5X,A7)'


	if((CODE EQ 1) OR (CODE EQ 2)) then begin
		agcnumber=[agcnumber,myagcnumber]
		cz=[cz,mycz]
		w50=[w50,myw50]
		werr=[werr,mywerr]
		flux=[flux,myflux]
		fluxerr=[fluxerr,myfluxerr]
		snr=[snr,mysnr]
		rms=[rms,myrms]

	endif


endwhile
close,lun
free_lun,lun

agcnumber=agcnumber[1:*]
cz=cz[1:*]
w50=w50[1:*]
werr=werr[1:*]
flux=flux[1:*]
fluxerr=fluxerr[1:*]
snr=snr[1:*]
rms=rms[1:*]


ngal=n_elements(agcnumber)
print,ngal,' good detections in the catalog'




;goto,ending
epsinit,'hist_plots_nomass.eps',xsize=6,ysize=10,/VECTOR
!p.multi=[0,1,4,0,0]

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
;flux PLOT
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
;min_value=6.0
;max_value=11.0
;binsize=0.25
;hist=histogram(alog10(HImass),min=min_value,max=max_value,binsize=binsize)
;nhist=n_elements(hist)
;
;bins=lindgen(nhist)*binsize+min_value
;
;x=fltarr(2*nhist)
;x[2*lindgen(nhist)]=bins
;x[2*lindgen(nhist)+1]=bins
;y=fltarr(2*nhist)
;y[2*lindgen(nhist)]=hist
;y[2*lindgen(nhist)+1]=hist
;y=shift(y,1)
;
;plot,x,y,xrange=[6.0,11.0],yrange=[0,120],xstyle=1,ystyle=1,xthick=2.,ythick=2.0,$
;     thick=2.0,charthick=2.0,charsize=1.5,xtitle='log10 HI Mass [solar]',ytitle='N'
;polyfill, [x, x[0]], [y, y[0]]
;
;print,'him',min(alog10(HImass)),max(alog10(HImass))


xyouts,0.92,0.95,'a',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.70,'b',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.45,'c',charsize=1.5,charthick=2.0,/NORMAL
xyouts,0.92,0.20,'d',charsize=1.5,charthick=2.0,/NORMAL
;xyouts,0.92,0.15,'e',charsize=1.5,charthick=2.0,/NORMAL


epsterm

ending:
end
