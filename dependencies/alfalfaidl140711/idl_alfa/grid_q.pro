;+
;NAME:grid_q
;
;SYNTAX: grid_q, grid,f_ok
;INPUT:
;  grid		ALFALFA grid array
;
;OUTPUT:
;  a histogram plot of the weights in grid.w
;  f_ok	fraction of grid pixels with spectral weights 
;	greater than 90% of the weighhts' median value


pro grid_q,grid,med,f_90,f_16

ntot=n_elements(grid.w)
ww=reform(grid.w,1,ntot)
ww=reform(ww)
med=median(ww)
ind=where(ww gt 0.9*med,n_ok)
f_90=float(n_ok)/ntot
ind=where(ww gt 16,n_16)
f_16=float(n_16)/ntot
print,med, format="('Median pixel weight           =',f6.3)"
print,f_90,format="('Fraction of pix above 0.9*med =',f6.3)"
print,f_16,format="('Fraction of pix above 16      =',f6.3)"

end

;print,' Do you wish a histogram plot of spectral weights? (y/n, def=n)'
;ans=''
;read,ans
;if (ans eq 'y' or ans eq 'ANS') then begin
;	set_plot,'PS'
;	device,filename='w_hist.ps'
;	xsize=3.5
;	ysize=7.0
;	page_width=8.5
;	page_height=11.0
;	xoffset=(page_width-xsize)*0.5
;	yoffset=(page_height-ysize)*0.5
;	device,xsize=xsize,ysize=ysize,xoffset=xoffset,yoffset=yoffset,/inches
;	hist_plot,ww,min=0.,max=max(ww),binsize=0.1,/fill
;	device,/close_file
;	set_plot,'X'
;endif
;
;end
