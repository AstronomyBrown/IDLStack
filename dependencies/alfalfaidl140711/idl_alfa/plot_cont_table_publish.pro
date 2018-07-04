;+
; NAME:
;      PLOT_CONT_TABLE_PUBLISH
; PURPOSE:
;      Simple tool for creating publication quality plots of the continuum
;        pointing corrections for ALFALFA.  Returns the coefficients of the pointing corrections
;
; EXPLANATION:
;
;    Performs a robust 3rd order polynomial fit to determine the continuum pointing corrections for ALFALFA.
;
;
;
; CALLING SEQUENCE:
;
;       plot_cont_table_publish, cont_table, decmin, decmax, coefra, coefdec
;
; INPUTS:
;       cont_table or cont_table_final (an ALFALFA continuum structure)
;       
;
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;
;
;
; OUTPUTS:
;       coefra:  Right ascension coefficients - 3rd order poly a0, a1, a2, a3
;       coefdec:  Declination coefficients - 3rd order poly a0, a1, a2, a3
;
;
; RESTRICTIONS:
;
;        Works on ALFALFA data


pro plot_cont_table_publish, cont_table, decmin, decmax, coefra, coefdec


;Virgo example
;decmin=7.5
;decmax=16.5

;Anti-Virgo example
;decmin=23.5
;decmax=32.5



psopen, 'continuumall.ps', set_font='Times', /tt_font, xsize=7.0, ysize=5.0, /inches, /isolatin1
;1 column, 2 rows
!p.multi=[0,1,2,0,0]
multiplot

charsize=1.0

plotsym, 0



;RA
plot, cont_table.dec_cen,(((cont_table.ra_cen-cont_table.nvss_ra)*15.0)/cos(cont_table.dec_cen*!dpi/180.0))*3600.0,$
     psym=8, xrange=[decmin,decmax], yrange=[-60,60],$
     ytitle=textoidl('\DeltaRA [arcsec]'), charsize=charsize,$
      ;title='Continuum values N=1600, all data points', $
     xstyle=1, ystyle=1, symsize=0.5

multiplot

;DEC
plot, cont_table.dec_cen,(cont_table.dec_cen-cont_table.nvss_dec)*3600.0, $
     psym=8, xrange=[decmin,decmax], yrange=[-60,60],$
     xtitle='Declination J2000 [degrees]', ytitle=textoidl('\DeltaDecl. [arcsec]'), charsize=charsize,$
     xstyle=1, ystyle=1, symsize=0.5


count=0

multiplot, /reset
!p.multi=0

psclose

;----------------------------------------------------------------------------------------------------
;;;;;;;BINNED AVERAGE VALUES;;;;;;;;;;;

;window, /free, retain=2, xsize=800, ysize=800
psopen, 'continuumavg.ps', set_font='Times', /tt_font, xsize=7.0, ysize=5.0, /inches, /isolatin1
!p.multi=[0,1,2,0,0]
multiplot

plot, dist(5), /nodata, $
     psym=8, xrange=[decmin,decmax], yrange=[-60,60],$
     ytitle=textoidl('\DeltaRA [arcsec]'), charsize=charsize,$
     xstyle=1, ystyle=1

xvals=dblarr(1)
yvals=dblarr(1)

count=0

;Determine RA averages every quarter degree - 
for i=decmin+0.25,decmax,.25 do begin

index=where(cont_table.dec_cen lt i AND cont_table.dec_cen ge (i-0.25))

if (index[0] ne -1) then begin
yvalues=(((cont_table[index].ra_cen-cont_table[index].nvss_ra)*15.0)/cos(cont_table[index].dec_cen*!dpi/180.0))*3600.0

junkindex=where(yvalues gt -250.0)
yvalues=yvalues[junkindex]


avgdiff=meanrob(yvalues, gindx=gindx,nsig=2,fpnts=fpnts)

   if (gindx[0] ne -1) then begin
      errdiff=stddev(yvalues[gindx])/sqrt(n_elements(gindx)-1)

      count=count+n_elements(gindx)

      oploterror, i-0.125, avgdiff,0.125,errdiff, psym=8, symsize=0.5

      if (n_elements(gindx) eq 6) then begin
         ;print, yvalues
      endif
     
   endif

xvals=[xvals,i-0.125]
yvals=[yvals,avgdiff]

endif


endfor

xvals=xvals[1:n_elements(xvals)-1]
yvals=yvals[1:n_elements(yvals)-1]

;Determine fit
coefra=robfit_poly(xvals, yvals,3,nsig=2,yfit=yfit)

;Overplot fit in RED

oplot, xvals, yfit, linestyle=0,thick=2.0
oplot, findgen(20), fltarr(20), linestyle=1
;xyouts, 14,50,'!61539', /data

print, 'RA count: ',count

count=0

;Declination

multiplot

plot, dist(5), /nodata, $
     psym=8, xrange=[decmin,decmax], yrange=[-60,60],$
     xtitle='Declination J2000 [degrees]', ytitle=textoidl('\DeltaDecl. [arcsec]'), charsize=charsize,$
     xstyle=1, ystyle=1

xvals=dblarr(1)
yvals=dblarr(1)

;Determine Dec averages every quarter degree - 
for i=decmin+0.25,decmax,.25 do begin

index=where(cont_table.dec_cen lt i AND cont_table.dec_cen ge (i-0.25))

if (index[0] ne -1) then begin
yvalues=(cont_table[index].dec_cen-cont_table[index].nvss_dec)*3600.0
avgdiff=meanrob(yvalues, gindx=gindx,nsig=2,fpnts=fpnts)

    if (gindx[0] ne -1) then begin

       errdiff=stddev(yvalues[gindx])/sqrt(n_elements(gindx)-1)

       oploterror, i-0.125, avgdiff,0.125,errdiff, psym=8, symsize=0.5

       count=count+n_elements(gindx)

    endif

xvals=[xvals,i-0.125]
yvals=[yvals,avgdiff]

endif


endfor


xvals=xvals[1:n_elements(xvals)-1]
yvals=yvals[1:n_elements(yvals)-1]

;Determine fit
coefdec=robfit_poly(xvals, yvals,3,yfit=yfit)

;Overplot fit in RED

oplot, xvals, yfit, linestyle=0,thick=2.0
oplot, findgen(20), fltarr(20), linestyle=1
;xyouts, 14,50,'!61538 points used', /data

print, 'DEC count: ',count
print, ' '
print, ' '
print, 'COEF RA:  ', transpose(coefra)
print, 'COEF DEC: ', transpose(coefdec)

multiplot, /reset
!p.multi=0

psclose

end
