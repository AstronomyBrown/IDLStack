pro plot_cont_table, cont_table_final


cont_table=cont_table_final



charsize=1.4

;Note, ~1600 source used



window, /free, retain=2, xsize=900, ysize=700
!p.multi=[0,1,2,0,0]
multiplot

plotsym, 0, /fill
;RA
plot, cont_table.dec_cen,(((cont_table.ra_cen-cont_table.nvss_ra)*15.0)/cos(cont_table.dec_cen*!dpi/180.0))*3600.0,$
     psym=8, xrange=[min(cont_table.dec_cen)+0.1,max(cont_table.dec_cen)+0.1], yrange=[-60,60],$
     ytitle=textoidl('\DeltaRA [arcsec]'), charsize=charsize,$
      ;title='Continuum values N=1600, all data points', $
     xstyle=1, ystyle=1, symsize=0.7

oplot, findgen(100), fltarr(100), linestyle=2

multiplot

;DEC
plot, cont_table.dec_cen,(cont_table.dec_cen-cont_table.nvss_dec)*3600.0, $
     psym=8, xrange=[min(cont_table.dec_cen)+0.1,max(cont_table.dec_cen)+0.1], yrange=[-60,60],$
     xtitle='!6Declination J2000 [degrees]', ytitle=textoidl('\DeltaDecl. [arcsec]'), charsize=charsize,$
     xstyle=1, ystyle=1, symsize=0.7

oplot, findgen(100), fltarr(100), linestyle=2

count=0

multiplot, /reset
!p.multi=0

window, /free, retain=2, xsize=800, ysize=800

hor
ver




plot, alog10(cont_table.peak_interp), alog10(cont_table.nvss_peak_int), xstyle=1, ystyle=1,$
      xrange=[0.5,3.0], yrange=[0.5,3.0], charsize=1.5, $
      xtitle='ALFALFA interpolated peak intensity (continuum) [mJy/beam]', ytitle='NVSS continuum peak intensity [mJy/beam]', psym=6, symsize=1.0

oplot, findgen(10)-5, findgen(10)-5, linestyle=2


end
