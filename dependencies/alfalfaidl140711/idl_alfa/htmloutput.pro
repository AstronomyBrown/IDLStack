;+
; NAME:
;      HTMLOUTPUT
; PURPOSE:
;       Procedures for exporting Formatted, marked, CSV, SDSS, and HTML catalogs from GALCAT
;       
;
; EXPLANATION:
;
;       Each procedure is called from the "File" menu in galcat to export ASCII or HTML catalogs
;
;
;
; CALLING SEQUENCE:
;       
;       See respective procedure
;
; INPUTS:
;       list of source files
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
;       ASCII or HTML files
;
;
; RESTRICTIONS:
;
;        Typically used with galflux
;
; EXAMPLE:
;
;       Pretty straight forward:  Choose "File" and the appropriate catalog in GALCAT
;
; PROCEDURES USED:
;         
;
;
;
; MODIFICATION HISTORY:
;
;    Last updated:  November 1, 2009, Brian Kent, NRAO
;	Dec23 2009: added subgrid letter in formatted code output - rg
;
;


pro htmloutput, filename


restore,filename
srcname=src.srcname

nspec=n_elements(src.spectra)
if (nspec eq 0) then print,'No spectra stored in this file'



;Write spectra and plots

window, /free, retain=2, xsize=600, ysize=400
win=!d.window
stretch, 100,0

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(round(src.spectra[j].isophot)), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]


for specnr=0, nspec-1 do begin

spec=src.spectra[specnr].spec
velarr=src.spectra[specnr].velarr
weight=src.spectra[specnr].weight

nchn=n_elements(spec)



;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

ymin=-1.0*(max(src.spectra[specnr].peak_flx))
ymax=1.7*(max(src.spectra[specnr].peak_flx))



fwhm=nspec-1

;5 is the FWHM
vmin=min(velarr)
vmax=max(velarr)

charsize=1.1

plot,velarr,spec,xrange=[vmin,vmax],yrange=[ymin,ymax],xstyle=1,ystyle=1,position=[0.10,0.25,0.95,0.95], $
     ytitle='Flux Density [mJy]',title='HI'+srcname+ '   '+isophote[specnr]+' level', $
     charsize=charsize, xtickn=[' ',' ',' ',' ',' ',' ',' ']
oplot,velarr,fltarr(nchn),linestyle=1

weight=weight/max(weight)
plot,velarr,weight,xrange=[vmin,vmax],yrange=[0.0,1.2],xstyle=1,ystyle=1,position=[0.10,0.1,0.95,0.25], $
     xtitle='Velocity [km/s]',ytitle='Weight',charsize=charsize,linestyle=2, /noerase



 tvlct, r, g, b, /get
  r = congrid(r, 256)
  g = congrid(g, 256)
  b = congrid(b, 256)
  
  im = float(tvrd())
  im = byte((im/max(im))*255)
  image = bytarr(3, !d.x_size, !d.y_size)
  image[0, *, *] = r[im]
  image[1, *, *] = g[im]
  image[2, *, *] = b[im]
  filename='html/HI'+srcname+'_iso'+isophote[specnr]+'.jpg'
  write_png, 'temp1138', image
  spawn, 'convert -negate temp1138 jpeg:'+filename
  spawn, '/bin/rm temp1138', /sh




endfor

wdelete, win

stretch
device, decomposed=0

window, /free, retain=2, xsize=295, ysize=295
win=!d.window





;;;;;Make the map plot with ellipses

for specnr=0, nspec-1 do begin

loadct, 3, /silent

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

plot, [0,0], /nodata, xrange=[n_elements(src.srccube.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5,n_elements(src.srccube.dbox[0,0,*])-0.5] , $
             xtitle='X pixel', ytitle='Y pixel', xstyle=1, ystyle=1

PX = !X.WINDOW * !D.X_VSIZE 
PY = !Y.WINDOW * !D.Y_VSIZE
SX = PX[1] - PX[0] + 1 
SY = PY[1] - PY[0] + 1

tvscl, reverse(congrid(src.srccube.totf, sx,sy)), px[0], py[0]

;print, sx, sy, px[0], py[0]

plot, [0,0], /nodata, xrange=[n_elements(src.srccube.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5, n_elements(src.srccube.dbox[0,0,*])-0.5], $
             xtitle='X pixel', ytitle='Y pixel', /noerase, xstyle=1, ystyle=1


a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell

dims=size(reform(src.srccube.dbox[0,*,*]),/dimensions)

fmax=max(src.srccube.totf,index)
xpxpk=index mod dims[0]
ypxpk=index/dims[0]

device, decomposed=1
;Mark the maximum value
plotsym, 0, /fill
plots, round(xpxpk),round(ypxpk), psym=7, symsize=2, thick=2.0, color='000000'XL, /data   ; Black

;ellipse_colors=[239,223,208,31,111,255,160,63]
;PINK, GOLD, YELLOW, MAGENTA, CYAN, RED, GREEN, WHITE for custom
ellipse_colors=['00BBFF'XL, '7F7FFF'XL, '00FFFF'XL, 'FF00FF'XL, 'FFFF00'XL, '0000FF'XL, '00FF00'XL, 'FFFFFF'XL]
ellipse_labels=isophote

;Units of device coorindates
ellipse_xpos=5
ellipse_ypos=[105,90,75,60,45,30,15,-200]

if (nspec eq 7) then ellipse_ypos[7]=5

xyouts, 5,120, 'Contour', /device




iso=[0.5*fmax, 0.25*fmax,100.,200.,300.,500.,1000., -1]

indices=where(src.srccube.totf gt iso[specnr],ncount)
    if (ncount gt 4) then begin
        
  
  plots,fit_ellipse(indices,xsize=src.srccube.nbx,ysize=src.srccube.nby,axes=axes,orientation=orientation,center=center), $
         color=ellipse_colors[specnr], psym=8
  xyouts, ellipse_xpos, ellipse_ypos[specnr], ellipse_labels[specnr],$
           /device, color=ellipse_colors[specnr]

device, decomposed=0

;write out contour image
 tvlct, r, g, b, /get
  r = congrid(r, 256)
  g = congrid(g, 256)
  b = congrid(b, 256)
  
  im = float(tvrd())
  im = byte((im/max(im))*255)
  image = bytarr(3, !d.x_size, !d.y_size)
  image[0, *, *] = r[im]
  image[1, *, *] = g[im]
  image[2, *, *] = b[im]
  filename='html/HI'+srcname+'_ellipse_'+isophote[specnr]+'.jpg'
  write_png, 'temp1138', image
  spawn, 'convert -negate temp1138 jpeg:'+filename
  spawn, '/bin/rm temp1138', /sh




    endif

endfor



stretch
device, decomposed=0
loadct, 0, /silent
wdelete, win

;Write HTML file for each isophote

for specnr=0, nspec-1 do begin
;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

type='integrated'
V50=src.spectra[specnr].vcen[0]
V20=src.spectra[specnr].vcen[1]
Vcen=src.spectra[specnr].vcen[2]
VcenerrP=src.spectra[specnr].vcenerr_stat[0]
VGauss=src.spectra[specnr].vcen[3]
VGausserr=src.spectra[specnr].vcenerr_stat[3]
W50=src.spectra[specnr].width[0]
W20=src.spectra[specnr].width[1]
WGauss=src.spectra[specnr].width[3]
WerrP=src.spectra[specnr].widtherr[0]
WerrG=src.spectra[specnr].widtherr[3]
Stot_specP=src.spectra[specnr].flux_int_specP
Stot_specG=src.spectra[specnr].flux_int_specG
Stot_specP_err=sqrt(src.spectra[specnr].flux_specP_err_stat^2+src.spectra[specnr].flux_specP_err_sys^2)
Stot_specG_err=sqrt(src.spectra[specnr].flux_specG_err_stat^2+src.spectra[specnr].flux_specG_err_sys^2)
mean_flx=src.spectra[specnr].mean_flx
peak_flx=src.spectra[specnr].peak_flx
rmsP=src.spectra[specnr].rmsP
rmsG=src.spectra[specnr].rmsG
stn=src.spectra[specnr].ston
cont=src.spectra[specnr].continuum

RA_cen=src.spectra[specnr].RA_centroid
Dec_cen=src.spectra[specnr].Dec_centroid
radec_cen=radec_to_name(ra_cen,dec_cen)
RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell
radec_ell=radec_to_name(ra_ell,dec_ell)
a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell
npix_ell=src.spectra[specnr].npix_ell
isophot=src.spectra[specnr].isophot
map_smax=src.spectra[specnr].map_maxflx
Stot_map=src.spectra[specnr].flux_int_map
Stot_map_err=src.spectra[specnr].flux_map_err_stat

; get ellipse


totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; convert to string

sv50=strtrim(string(V50,W50,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,vcenerrp,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)



;HTML header file
openw, lun, 'html/HI'+srcname+'_'+strcompress(isophote[specnr], /remove_all)+'.html', /get_lun

printf, lun, '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
printf, lun, '<html>'
printf, lun, '<head>'
printf, lun, '<title>ALFALFA Catalog Object: HI'+srcname+'</title>'


printf, lun, '<style type="text/css">'
printf, lun, '  body {'
printf, lun, '    font: normal 0.8em Times, sans-serif;'
printf, lun, '  }'
printf, lun, ''
printf, lun, '  #popup {'
printf, lun, '    /* Necessary: */'
printf, lun, '    position: absolute;'
printf, lun, '    display: none;'
printf, lun, '    z-index: 10;'
printf, lun, ''
printf, lun, '    /* Additional styling: */'
printf, lun, '    width: 150px;'
printf, lun, '    font-size: small;'
printf, lun, '    background-color: #eee;'
printf, lun, '    border: 1px dotted #ece;'
printf, lun, '    opacity: .85;'
printf, lun, '    filter: alpha(opacity=85);'
printf, lun, '  }'
printf, lun, '</style>'










printf, lun, '</head>'
printf, lun, '<body style="background-color: #E5E5E5; ">'


printf, lun, '<div id="popup"></div>'
printf, lun, ''
printf, lun, '<script type="text/javascript"><!--'
printf, lun, ''
printf, lun, "var pop = document.getElementById('popup');"
printf, lun, ''
printf, lun, 'var xoffset = 15;'
printf, lun, 'var yoffset = 10;'
printf, lun, ''
printf, lun, 'document.onmousemove = function(e) {'
printf, lun, '  var x, y, right, bottom;'
printf, lun, '' 
printf, lun, '  try { x = e.pageX; y = e.pageY; } // FF'
printf, lun, '  catch(e) { x = event.x; y = event.y; } // IE'
printf, lun, ''
printf, lun, '  right = (document.documentElement.clientWidth || document.body.clientWidth || document.body.scrollWidth);'
printf, lun, '  bottom = (window.scrollY || document.documentElement.scrollTop || document.body.scrollTop) + (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight || document.body.scrollHeight);'
printf, lun, ''
printf, lun, '  x += xoffset;'
printf, lun, '  y += yoffset;'
printf, lun, ''
printf, lun, '  if(x > right-pop.offsetWidth)'
printf, lun, '    x = right-pop.offsetWidth;'
printf, lun, '' 
printf, lun, '  if(y > bottom-pop.offsetHeight)'
printf, lun, '    y = bottom-pop.offsetHeight;'
printf, lun, '' 
printf, lun, "  pop.style.top = y+'px';"
printf, lun, "  pop.style.left = x+'px';"
printf, lun, ''
printf, lun, '}'
printf, lun, ''
printf, lun, 'function popup(text) {'
printf, lun, '  pop.innerHTML = text;'
printf, lun, "  pop.style.display = 'block';"
printf, lun, '}'
printf, lun, ''
printf, lun, 'function popout() {'
printf, lun, "  pop.style.display = 'none';"
printf, lun, '}'
printf, lun, ''
printf, lun, ''
printf, lun, 'function wopen(url, name, w, h)'
printf, lun, '{'
printf, lun, '// Fudge factors for window decoration space.'
printf, lun, ' // In my tests these work well on all platforms & browsers.'
printf, lun, 'w += 32;'
printf, lun, 'h += 96;'
printf, lun, ' var win = window.open(url,'
printf, lun, '  name,'
printf, lun, "  'width=' + w + ', height=' + h + ', ' +"
printf, lun, "  'location=no, menubar=no, ' +"
printf, lun, "  'status=no, toolbar=no, scrollbars=no, resizable=no');"
printf, lun, ' win.resizeTo(w, h);'
printf, lun, ' win.focus();'
printf, lun, '}'
printf, lun, '//--></script>'




















printf, lun, '<h2>ALFALFA Catalog Object: HI'+srcname+'  (<a href="index.html"><i>Return to catalog</i>)</h2>'
;printf, lun, '<h3><a href="index.html">Return home</a></h3>'

printf, lun, '<hr>'
printf, lun, '<table cellpadding="2" cellspacing="0" border="1" align="left" width="800">'

printf, lun, '<tr>'
printf, lun, '<td valign="top">'

printf, lun, '<table cellpadding="2" cellspacing="1" border="0" align="left" width="400">'
printf, lun, '<tr>'
printf, lun, '<td valign="top">'

printf, lun, '<table border="0" cellspacing="1" width="50">'

for i=0, nspec-1 do begin
    
    color="#CCD8DC"
    if (i eq specnr) then color="#ED6078"

    printf, lun, '<tr><td bgcolor='+color+'><font size="-1"><a href="HI'+srcname+'_'+strcompress(isophote[i], /remove_all)+'.html">'+isophote[i]+'</a></font></td></tr>'
endfor



printf, lun, '</table>'

printf, lun, '</td>'

printf, lun, '<td>'

printf, lun, '<img src="HI'+srcname+'_iso'+isophote[specnr]+'.jpg">'

printf, lun, '</td>'

printf, lun, '</tr>'

printf, lun, '</table>'

printf, lun, '</td>'

printf, lun, '<td valign="top">'

fwhm=n_elements(src.spectra)-1
rahr=src.spectra[fwhm].ra_centroid
decdeg=src.spectra[fwhm].dec_centroid


;printf, lun, '<center><b><font size="-1"><p>Click the images for the data source.</p></font></b></center><center><b><i><font size="-1"><p>SDSS</p></font></i></b></center><p><a href="http://cas.sdss.org/astro/en/tools/chart/navi.asp?ra='+strcompress(rahr*15.0, /remove_all)+'&dec='+strcompress(decdeg, /remove_all)+'&opt=gli" target=new><img src="http://casjobs.sdss.org/ImgCutoutDR6/getjpeg.aspx?ra='+strcompress(rahr*15.0, /remove_all)+'&dec='+strcompress(decdeg, /remove_all)+'&scale=0.899550025&opt=GI&width=200&height=200" border=1></a></p><center><b><i><font size="-1"><p>Digital Sky Survey Blue 2</p></font></i></b></center><p><a href="http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD='+strcompress(rahr*15.0, /remove_all)+','+strcompress(decdeg, /remove_all)+'&SURVEY=DSS2+Blue&SCOORD=Equatorial&GRIDDD=Yes&SFACTOR=0.1&PIXELX=200&PIXELY=200&RETURN=GIF" target=new><img src="http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD='+strcompress(rahr*15.0, /remove_all)+','+strcompress(decdeg, /remove_all)+'&SURVEY=DSS2+Blue&SCOORD=Equatorial&GRIDDD=Yes&SFACTOR=0.1&PIXELX=200&PIXELY=200&RETURN=GIF" border=1></a></p><br></center>'

printf, lun, '<a href="http://cas.sdss.org/astro/en/tools/chart/navi.asp?ra='+strcompress(rahr*15.0, /remove_all)+'&dec='+strcompress(decdeg, /remove_all)+'&opt=gli" target=new onmouseover="popup('+"'Click for the Sloan Digital Sky Survey Navigator'"+')" onmouseout="popout()"><img src="http://casjobs.sdss.org/ImgCutoutDR6/getjpeg.aspx?ra='+strcompress(rahr*15.0, /remove_all)+'&dec='+strcompress(decdeg, /remove_all)+'&scale=1.0&opt=GI&width=200&height=200" border=1></a><br><center><a href="http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD='+strcompress(rahr*15.0, /remove_all)+','+strcompress(decdeg, /remove_all)+'&SURVEY=DSS2+Blue&SCOORD=Equatorial&GRIDDD=Yes&SFACTOR=0.2&PIXELX=200&PIXELY=200&RETURN=GIF" target=new onmouseover="popup('+"'Click for the Digital Sky Survey Blue 2'"+')" onmouseout="popout()"><img src="http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD='+strcompress(rahr*15.0, /remove_all)+','+strcompress(decdeg, /remove_all)+'&SURVEY=DSS2+Blue&SCOORD=Equatorial&GRIDDD=Yes&SFACTOR=0.1&PIXELX=200&PIXELY=200&RETURN=GIF" border=1></a></center>'


printf, lun, '</td>'

printf, lun, '</tr>'

printf, lun, '</table>'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printf, lun, '<table cellpadding="2" cellspacing="1" border="0" align="left" width="800">'

printf, lun, '<tr>'
printf, lun, '<td valign="top">'

printf, lun, '<font size="-1"><table cellpadding="2" cellspacing="1" border="0" width="570">'
printf, lun, '<th colspan="10"><i>Data for Isophote at the '+ssiso+' level</i></th>'
printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>V50,W50</b></td><td bgcolor="#CCD8DC">'+sv50+'</td><td bgcolor="#1E90FF"><b>Centroid</b></td><td bgcolor="#CCD8DC">'+radec_cen+' [2000]</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>V20,W20</b></td><td bgcolor="#CCD8DC">'+sv20+'</td><td bgcolor="#1E90FF"><b>Opt pos</b></td><td bgcolor="#CCD8DC">'+rdopt+' [2000]</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>Vcen</b></td><td bgcolor="#CCD8DC">'+svcen+'</td><td bgcolor="#1E90FF"><b>Cen_ell</b></td><td bgcolor="#CCD8DC">'+radec_ell+' [2000]</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>V,W Gauss</b></td><td bgcolor="#CCD8DC">'+svg+'</td><td bgcolor="#1E90FF"><b>Ellipse</b></td><td bgcolor="#CCD8DC">'+ellipse+'</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>Stot(profile, P)</b></td><td bgcolor="#CCD8DC">'+sstotP+'</td><td bgcolor="#1E90FF"><b>Isophote</b></td><td bgcolor="#CCD8DC">'+ssiso+'</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>Stot(profile, G)</b></td><td bgcolor="#CCD8DC">'+sstotG+'</td><td bgcolor="#1E90FF"><b>Map Smax</b></td><td bgcolor="#CCD8DC">'+smapsmax+'</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>rms</b></td><td bgcolor="#CCD8DC">'+srms+'</td><td bgcolor="#1E90FF"><b>Map Stot</b></td><td bgcolor="#CCD8DC">'+sstotm+'</td>'
printf, lun, '</tr>'

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>meanS, peakS</b></td><td bgcolor="#CCD8DC">'+smeans+'</td>'
printf, lun, '</tr>' 

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>S/N P</b></td><td bgcolor="#CCD8DC">'+sstnP+'</td>'
printf, lun, '</tr>' 

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>S/N G</b></td><td bgcolor="#CCD8DC">'+sstnG+'</td>'
printf, lun, '</tr>' 

printf, lun, '<tr>'
printf, lun, '<td bgcolor="#1E90FF"><b>Cont</b></td><td bgcolor="#CCD8DC">'+scont+'</td>'
printf, lun, '</tr>' 


printf, lun, '</table></font>'
printf, lun, '</td>'
printf, lun, '<td>'

filename_ell='HI'+srcname+'_ellipse_'+isophote[specnr]+'.jpg'
   printf, lun, '<img src="'+filename_ell+'">'
printf, lun, '</td>'


printf, lun, '</tr>
printf, lun, '</table>' 


printf, lun, '<font size="-1"><center><table cellpadding="2" cellspacing="1" border="0" align="left" width="800">'
printf, lun, '<th colspan="10">All Integrated Profile parameters</th>'
printf, lun, '<tr>'

printf, lun, '<td bgcolor="#1E90FF">Isophote</td>'
printf, lun, '<td bgcolor="#1E90FF">npix</td>'
printf, lun, '<td bgcolor="#1E90FF">Ellipse Center</td>'
printf, lun, '<td bgcolor="#1E90FF">Centroid</td>'
printf, lun, '<td bgcolor="#1E90FF">a_ell</td>'
printf, lun, '<td bgcolor="#1E90FF">b_ell</td>'
printf, lun, '<td bgcolor="#1E90FF">PA</td>'
printf, lun, '<td bgcolor="#1E90FF">V [P]</td>'
printf, lun, '<td bgcolor="#1E90FF">W [P]</td>'
printf, lun, '<td bgcolor="#1E90FF">V [G]</td>'
printf, lun, '<td bgcolor="#1E90FF">W [G]</td>'
printf, lun, '<td bgcolor="#1E90FF">Sint map</td>'
printf, lun, '<td bgcolor="#1E90FF">Sint P</td>'
printf, lun, '<td bgcolor="#1E90FF">Sint G</td>'
printf, lun, '<td bgcolor="#1E90FF">S/N 0</td>'
printf, lun, '<td bgcolor="#1E90FF">S/N 4</td>'

printf, lun, '</tr>'

for ns=0,nspec-1 do begin
printf, lun, '<tr>'
  rdell=radec_to_name(src.spectra[ns].ra_ell,src.spectra[ns].dec_ell)
  rdcen=radec_to_name(src.spectra[ns].ra_centroid,src.spectra[ns].dec_centroid)
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].isophot, format='(f5.0)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].phot_npix,format='(i5)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(rdell,format='(2x,a15)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(rdcen,format='(2x,a15)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].a_ell,format='(f6.1)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].b_ell,format='(f6.1)')+'</td>'	
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].PA_ell,format='(f5.0)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].vcen[0],format='(i5)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].width[0],format='(i4)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].vcen[3],format='(i5)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].width[3],format='(i4)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].flux_int_map/1000.,format='(f7.2)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].flux_int_specP/1000.,format='(f7.2)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].flux_int_specG/1000.,format='(f7.2)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].ston[0],format='(f7.1)')+'</td>'
  printf, lun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].ston[4],format='(f7.1)')+'</td>'

printf, lun, '</tr>'
endfor

printf, lun, '</table></center></font>'

printf, lun, '</body></html>'


close, lun
free_lun, lun 



endfor 





end 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro runlist, list

dir='/home/astrosun/bkent/a2010/src/'
dir=''

;Check to see if html directory exists.  If it does, then clear the
;directory.  If not, create a new one

  spawn,'ls -l html',answer
      IF answer[0] EQ '' THEN BEGIN
         print, 'Creating new HTML directory...'
         spawn, 'mkdir html'
      ENDIF 
      IF answer[0] NE '' THEN BEGIN
         print, 'HTML directory exists - deleting information in directory'
         spawn, '/bin/rm -r html/*.*'
      ENDIF 
    
   


;HTML header file - main catalog

openw, indexlun, 'html/index.html', /get_lun

printf, indexlun, '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
printf, indexlun, '<html>'
printf, indexlun, '<head>'


spawn, 'whoami', user

printf, indexlun, '<title>ALFALFA Catalog generated: '+systime(0)+'  by '+user+'</title>'
printf, indexlun, '</head>'
printf, indexlun, '<body style="background-color: #E5E5E5; ">'

printf, indexlun, '<b>ALFALFA Catalog generated: '+systime(0)+'  by '+user+'</b>'

printf, indexlun, '<center><font size="-1"><table cellpadding="2" cellspacing="1" border="0" align="left" width="800">'
;printf, indexlun, '<th colspan="10">All Integrated Profile parameters</th>'
printf, indexlun, '<tr>'

printf, indexlun, '<td bgcolor="#1E90FF">Object</td>'
printf, indexlun, '<td bgcolor="#1E90FF">AGC</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Other</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Ellipse Center</td>'
printf, indexlun, '<td bgcolor="#1E90FF">delta RA</td>'
printf, indexlun, '<td bgcolor="#1E90FF">delta DEC</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Optical Center</td>'
printf, indexlun, '<td bgcolor="#1E90FF">h_size</td>'
printf, indexlun, '<td bgcolor="#1E90FF">V [P]</td>'
printf, indexlun, '<td bgcolor="#1E90FF">v_err</td>'
printf, indexlun, '<td bgcolor="#1E90FF">W [P]</td>'
printf, indexlun, '<td bgcolor="#1E90FF">w_err</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Sint P</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Sint_err</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Sint map</td>'
printf, indexlun, '<td bgcolor="#1E90FF">Code</td>'
printf, indexlun, '</tr>'





;;;;;;; loop through each file and create main catalog
for i=0,n_elements(list)-1 do begin
htmloutput, dir+list[i]

restore,dir+list[i]

;print, list[i]
srcname=src.srcname
nspec=n_elements(src.spectra)

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(round(src.spectra[j].isophot)), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]


specnr=0 ;FWHM measurements

type='integrated'
V50=src.spectra[specnr].vcen[0]
V20=src.spectra[specnr].vcen[1]
Vcen=src.spectra[specnr].vcen[2]
VcenerrP=src.spectra[specnr].vcenerr_stat[0]
VGauss=src.spectra[specnr].vcen[3]
VGausserr=src.spectra[specnr].vcenerr_stat[3]
W50=src.spectra[specnr].width[0]
W20=src.spectra[specnr].width[1]
WGauss=src.spectra[specnr].width[3]
WerrP=src.spectra[specnr].widtherr[0]
WerrG=src.spectra[specnr].widtherr[3]
Stot_specP=src.spectra[specnr].flux_int_specP
Stot_specG=src.spectra[specnr].flux_int_specG
Stot_specP_err=sqrt(src.spectra[specnr].flux_specP_err_stat^2+src.spectra[specnr].flux_specP_err_sys^2)
Stot_specG_err=sqrt(src.spectra[specnr].flux_specG_err_stat^2+src.spectra[specnr].flux_specG_err_sys^2)
mean_flx=src.spectra[specnr].mean_flx
peak_flx=src.spectra[specnr].peak_flx
rmsP=src.spectra[specnr].rmsP
rmsG=src.spectra[specnr].rmsG
stn=src.spectra[specnr].ston
cont=src.spectra[specnr].continuum

RA_cen=src.spectra[specnr].RA_centroid
Dec_cen=src.spectra[specnr].Dec_centroid
radec_cen=radec_to_name(ra_cen,dec_cen)
RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell
radec_ell=radec_to_name(ra_ell,dec_ell)
a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell
npix_ell=src.spectra[specnr].npix_ell
isophot=src.spectra[specnr].isophot
map_smax=src.spectra[specnr].map_maxflx
Stot_map=src.spectra[specnr].flux_int_map
Stot_map_err=src.spectra[specnr].flux_map_err_stat

; get ellipse


totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; convert to string

sv50=strtrim(string(V50,W50,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,vcenerrp,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

;Added by BK April 2006
;Calculate delta RA and delta dec between ellipse and optical values -
;BOTH need to be in units of arcminutes, so don't forget to multiple
;by cosdec/15.0



deltara=(RA_ell-src.spectra[specnr].RA_opt)*3600.0*15.0*(cos(src.spectra[specnr].Dec_opt*!dpi/180.))   ;units of arcseconds
deltadec=(Dec_ell-src.spectra[specnr].Dec_opt)*3600.0

if (src.spectra[specnr].RA_opt eq 0.0 AND src.spectra[specnr].Dec_opt eq 0.0) then begin
  deltara=0.0
  deltadec=0.0
endif


;Determination of size
hsize=(a_ell*b_ell)/(3.5)^2


;Determine/Calculate errors - add in quadrature

vstaterr=src.spectra[specnr].vcenerr_stat[0]
   if (vstaterr eq 0.0) then vstaterr=src.spectra[specnr].vcenerr_stat[3]   ;if zero use gauss result
vsyserr=src.spectra[specnr].vcenerr_sys[0]*src.spectra[specnr].vcen[0]   ;use V50
   if (vsyserr eq 0.0)  then vsyserr=src.spectra[specnr].vcenerr_sys[3]*src.spectra[specnr].vcen[3]

verr=sqrt((vstaterr)^2+(vsyserr)^2)   ;add computed results in quadrature


wstaterr=src.spectra[specnr].widtherr[0]
   if (wstaterr eq 0.0) then wstaterr=src.spectra[specnr].widtherr[2]   ;if zero use gauss result
wsyserr=src.spectra[specnr].widtherr[3]*src.spectra[specnr].width[0]
   if (wsyserr eq 0.0) then wsyserr=src.spectra[specnr].widtherr[4]*src.spectra[specnr].width[2]

werr=sqrt((wstaterr)^2+(wsyserr)^2)   ;add computed results in quadrature

fluxstaterr=src.spectra[specnr].flux_specP_err_stat/1000.0
   if (fluxstaterr eq 0.0) then fluxstaterr=src.spectra[specnr].flux_specG_err_stat/1000.0   ;if zero use gauss result
fluxsyserr=src.spectra[specnr].flux_specP_err_sys    ;Don't need to convert to Jy km/s
   if (fluxsyserr eq 0.0)  then fluxsyserr=src.spectra[specnr].flux_specG_err_sys

fluxerr=sqrt((fluxstaterr)^2+(fluxsyserr)^2)   ;add computed results in quadrature


printf, indexlun, '<tr>'

ns=0  ; FWHM measurement

  rdell=radec_to_name(src.spectra[ns].ra_ell,src.spectra[ns].dec_ell)
  rdcen=radec_to_name(src.spectra[ns].ra_centroid,src.spectra[ns].dec_centroid)

  printf, indexlun, '<td bgcolor="#CCD8DC"><a href="HI'+srcname+'_'+strcompress(isophote[ns], /remove_all)+'.html">HI'+srcname+'</a></td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+src.spectra[ns].agcnr+'</td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+src.spectra[ns].agcname+'</td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(rdell,format='(2x,a15)')+'</td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(deltara,format='(i4)')+'</td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(deltadec,format='(i4)')+'</td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(rdopt,format='(2x,a15)')+'</td>'
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(hsize,format='(f6.1)')+'</td>'

  vel=src.spectra[ns].vcen[0]
  if (vel eq 0.0) then vel=src.spectra[ns].vcen[3]   ;if measured with Gaussian

  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(vel,format='(i5)')+'</td>'
  
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(verr,format='(i5)')+'</td>'

  width=src.spectra[ns].width[0]
  if (width eq 0.0) then width=src.spectra[ns].width[2]

  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(width,format='(i5)')+'</td>'
  
  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(werr,format='(i5)')+'</td>'

;  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].width[0],format='(i4)')+'</td>'
;  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].vcen[3],format='(i5)')+'</td>'
;  printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].width[3],format='(i4)')+'</td>'
 


  flux=src.spectra[ns].flux_int_specP/1000.
  if (flux eq 0.0) then flux=src.spectra[ns].flux_int_specG/1000.
 
   printf, indexlun, '<td bgcolor="#CCD8DC">'+string(flux, format='(f7.2)')+'</td>'
   
   printf, indexlun,  '<td bgcolor="#CCD8DC">'+string(fluxerr,format='(f5.2)')+'</td>'

   printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].flux_int_map/1000.,format='(f7.2)')+'</td>'

   printf, indexlun, '<td bgcolor="#CCD8DC">0</td>'

  ;printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].flux_int_specP/1000.,format='(f7.2)')+'</td>'
  ;printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].flux_int_specG/1000.,format='(f7.2)')+'</td>'
  ;printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].ston[0],format='(f7.1)')+'</td>'
  ;printf, indexlun, '<td bgcolor="#CCD8DC">'+string(src.spectra[ns].ston[4],format='(f7.1)')+'</td>'

printf, indexlun, '</tr>'

endfor


printf, indexlun, '</table></font></center>'
printf, indexlun, '</body>'
printf, indexlun, '</html>'


close, indexlun
free_lun, indexlun


end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro exportcsv, list, codes


dir='/home/astrosun/bkent/a2010/src/'
dir=''

;Check to see if html directory exists.  If it does, then clear the
;directory.  If not, create a new one

 
     
   spawn,'ls -l csv',answer
      IF answer[0] EQ '' THEN BEGIN
         print, 'Creating new CSV directory...'
         spawn, 'mkdir csv'
      ENDIF 
      IF answer[0] NE '' THEN BEGIN
         print, 'CSV directory exists - deleting information in directory'
         spawn, '/bin/rm -r csv/*.*'
      ENDIF   




;HTML header file

openw, indexlun, 'csv/catalog.csv', /get_lun




spawn, 'whoami', user

printf, indexlun, '### ALFALFA Catalog generated: '+systime(0)+'  by '+user



printf, indexlun, '# Object, AGC, Other, Ellipse Center,Centroid, Optical Center,a_ell,b_ell,PA,V [P],W [P],V [G],W [G],Sint map,Sint P,Sint G,S/N 0,S/N 4, ra_ec, dec_ec, racec, deccen, raopt, decopt, code, gridname'










;;;;;;; loop through each file
for i=0,n_elements(list)-1 do begin
;htmloutput, dir+list[i]

restore,dir+list[i]
srcname=src.srcname
nspec=n_elements(src.spectra)

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(round(src.spectra[j].isophot)), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]


specnr=0 ;FWHM measurements

type='integrated'
V50=src.spectra[specnr].vcen[0]
V20=src.spectra[specnr].vcen[1]
Vcen=src.spectra[specnr].vcen[2]
VcenerrP=src.spectra[specnr].vcenerr_stat[0]
VGauss=src.spectra[specnr].vcen[3]
VGausserr=src.spectra[specnr].vcenerr_stat[3]
W50=src.spectra[specnr].width[0]
W20=src.spectra[specnr].width[1]
WGauss=src.spectra[specnr].width[3]
WerrP=src.spectra[specnr].widtherr[0]
WerrG=src.spectra[specnr].widtherr[3]
Stot_specP=src.spectra[specnr].flux_int_specP
Stot_specG=src.spectra[specnr].flux_int_specG
Stot_specP_err=sqrt(src.spectra[specnr].flux_specP_err_stat^2+src.spectra[specnr].flux_specP_err_sys^2)
Stot_specG_err=sqrt(src.spectra[specnr].flux_specG_err_stat^2+src.spectra[specnr].flux_specG_err_sys^2)
mean_flx=src.spectra[specnr].mean_flx
peak_flx=src.spectra[specnr].peak_flx
rmsP=src.spectra[specnr].rmsP
rmsG=src.spectra[specnr].rmsG
stn=src.spectra[specnr].ston
cont=src.spectra[specnr].continuum

RA_cen=src.spectra[specnr].RA_centroid
Dec_cen=src.spectra[specnr].Dec_centroid
radec_cen=radec_to_name(ra_cen,dec_cen)
RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell
radec_ell=radec_to_name(ra_ell,dec_ell)
a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell
npix_ell=src.spectra[specnr].npix_ell
isophot=src.spectra[specnr].isophot
map_smax=src.spectra[specnr].map_maxflx
Stot_map=src.spectra[specnr].flux_int_map
Stot_map_err=src.spectra[specnr].flux_map_err_stat

; get ellipse


totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; convert to string

sv50=strtrim(string(V50,W50,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,vcenerrp,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

deltara=(RA_ell-src.spectra[specnr].RA_opt)*3600.0*15.0*(cos(src.spectra[specnr].Dec_opt*!dpi/180.))   ;units of arcseconds
deltadec=(Dec_ell-src.spectra[specnr].Dec_opt)*3600.0

if (src.spectra[specnr].RA_opt eq 0.0 AND src.spectra[specnr].Dec_opt eq 0.0) then begin
  deltara=0.0
  deltadec=0.0
endif


;Determination of size
hsize=(a_ell*b_ell)/(3.5)^2


;Determine/Calculate errors - add in quadrature

vstaterr=src.spectra[specnr].vcenerr_stat[0]
   if (vstaterr eq 0.0) then vstaterr=src.spectra[specnr].vcenerr_stat[3]   ;if zero use gauss result
vsyserr=src.spectra[specnr].vcenerr_sys[0]*src.spectra[specnr].vcen[0]   ;use V50
   if (vsyserr eq 0.0)  then vsyserr=src.spectra[specnr].vcenerr_sys[3]*src.spectra[specnr].vcen[3]

verr=sqrt((vstaterr)^2+(vsyserr)^2)   ;add computed results in quadrature


wstaterr=src.spectra[specnr].widtherr[0]
   if (wstaterr eq 0.0) then wstaterr=src.spectra[specnr].widtherr[2]   ;if zero use gauss result
wsyserr=src.spectra[specnr].widtherr[3]*src.spectra[specnr].width[0]
   if (wsyserr eq 0.0) then wsyserr=src.spectra[specnr].widtherr[4]*src.spectra[specnr].width[2]

werr=sqrt((wstaterr)^2+(wsyserr)^2)   ;add computed results in quadrature

fluxstaterr=src.spectra[specnr].flux_specP_err_stat/1000.0
   if (fluxstaterr eq 0.0) then fluxstaterr=src.spectra[specnr].flux_specG_err_stat/1000.0   ;if zero use gauss result
fluxsyserr=src.spectra[specnr].flux_specP_err_sys    ;Don't need to convert to Jy km/s
   if (fluxsyserr eq 0.0)  then fluxsyserr=src.spectra[specnr].flux_specG_err_sys

fluxerr=sqrt((fluxstaterr)^2+(fluxsyserr)^2)   ;add computed results in quadrature






ns=0  ; FWHM measurement

raell=src.spectra[ns].ra_ell
decell=src.spectra[ns].dec_ell
racen=src.spectra[ns].ra_centroid
deccen=src.spectra[ns].dec_centroid
raopt=src.spectra[specnr].RA_opt
decopt=src.spectra[specnr].Dec_opt

  rdell=radec_to_name(src.spectra[ns].ra_ell,src.spectra[ns].dec_ell)
  rdcen=radec_to_name(src.spectra[ns].ra_centroid,src.spectra[ns].dec_centroid)
  printf, indexlun, 'HI'+srcname+','+$
  src.spectra[ns].agcnr+','+$
  src.spectra[ns].agcname+','+$
  string(rdell,format='(2x,a15)')+','+$
  string(rdcen,format='(2x,a15)')+','+$
  string(rdopt,format='(2x,a15)')+','+$
  string(src.spectra[ns].a_ell,format='(f6.1)')+','+$
  string(src.spectra[ns].b_ell,format='(f6.1)')+','+$	
  string(src.spectra[ns].PA_ell,format='(f5.0)')+','+$
  string(src.spectra[ns].vcen[0],format='(i5)')+','+$
  string(src.spectra[ns].width[0],format='(i4)')+','+$
  string(src.spectra[ns].vcen[3],format='(i5)')+','+$
  string(src.spectra[ns].width[3],format='(i4)')+','+$
  string(src.spectra[ns].flux_int_map/1000.,format='(f7.2)')+','+$
  string(src.spectra[ns].flux_int_specP/1000.,format='(f7.2)')+','+$
  string(src.spectra[ns].flux_int_specG/1000.,format='(f7.2)')+','+$
  string(src.spectra[ns].ston[0],format='(f7.1)')+','+$
  string(src.spectra[ns].ston[4],format='(f7.1)')+','+$
  string(raell, format='(f12.9)')+','+$
  string(decell, format='(f12.9)')+','+$
  string(racen, format='(f12.9)')+','+$
  string(deccen, format='(f12.9)')+','+$
  string(raopt, format='(f12.9)')+','+$
  string(decopt, format='(f12.9)')+','+$
  string(codes[i], format='(1x, i3)')+','+$
  src.gridgen.name

  



endfor


close, indexlun
free_lun, indexlun



end






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;For exporting SDSS data
pro exportsdss, list, codes, marked=marked

dir=''

;Check to see if html directory exists.  If it does, then clear the
;directory.  If not, create a new one

if (keyword_set(marked) eq 0) then begin     
   spawn,'ls -l formatcat',answer
      IF answer[0] EQ '' THEN BEGIN
         print, 'Creating new formatted catalog directory...'
         spawn, 'mkdir formatcat'
      ENDIF 
      IF answer[0] NE '' THEN BEGIN
         print, 'Formatted catalog directory exists - deleting old SDSSCATALOG.DAT in directory'
         spawn, '/bin/rm -rf formatcat/sdsscatalog.dat'
      ENDIF   

openw, indexlun, 'formatcat/sdsscatalog.dat', /get_lun

endif

;-------------------------------

if (keyword_set(marked) eq 1) then begin
if (marked eq 1) then begin

  spawn,'ls -l markedcat',answer
      IF answer[0] EQ '' THEN BEGIN
         print, 'Creating new formatted MARKED catalog directory...'
         spawn, 'mkdir markedcat'
      ENDIF 
      IF answer[0] NE '' THEN BEGIN
         print, 'Formatted MARKED catalog directory exists - deleting old MARKEDCAT.DAT in directory'
         spawn, '/bin/rm -rf markedcat/sdssmarkedcat.dat'
      ENDIF   

openw, indexlun, 'markedcat/sdssmarkedcat.dat', /get_lun

endif
endif




spawn, 'whoami', user

printf, indexlun, '### Formatted ALFALFA Catalog generated: '+systime(0)+'  by '+user



;printf, indexlun, '# Object, AGC, Other, Ellipse Center,deltaRA, deltaDEC, Optical Center, hsize, V [P],verr,W [P],werr,Sint P,Sint_err,Sint_map, code'

printf, indexlun, '#Object              AGC    ObjID               SpecObjID         petroMag(error)                                                  modelMag(error)                                                   Extinction                     petR50_4  petR90_r  expAB_r    mjd  plate fiberID'
printf, indexlun, '#                                                                       u            g            r            i            z            u           g             r            i            z          u     g     r     i     z      '
;                  HI113610.6+100312 210497    587732771056975941  346440445976379392   17.20( 0.24)  16.28( 0.20)  15.95( 0.19)  15.82( 0.19)  15.75( 0.21)   0.12  0.09  0.07  0.05  0.04   6.34  13.07  0.44







;;;;;;; loop through each file
for i=0,n_elements(list)-1 do begin
;htmloutput, dir+list[i]

restore,dir+list[i]
srcname=src.srcname
nspec=n_elements(src.spectra)

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(round(src.spectra[j].isophot)), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]


specnr=0 ;FWHM measurements

type='integrated'
V50=src.spectra[specnr].vcen[0]
V20=src.spectra[specnr].vcen[1]
Vcen=src.spectra[specnr].vcen[2]
VcenerrP=src.spectra[specnr].vcenerr_stat[0]
VGauss=src.spectra[specnr].vcen[3]
VGausserr=src.spectra[specnr].vcenerr_stat[3]
W50=src.spectra[specnr].width[0]
W20=src.spectra[specnr].width[1]
WGauss=src.spectra[specnr].width[3]
WerrP=src.spectra[specnr].widtherr[0]
WerrG=src.spectra[specnr].widtherr[3]
Stot_specP=src.spectra[specnr].flux_int_specP
Stot_specG=src.spectra[specnr].flux_int_specG
Stot_specP_err=sqrt(src.spectra[specnr].flux_specP_err_stat^2+src.spectra[specnr].flux_specP_err_sys^2)
Stot_specG_err=sqrt(src.spectra[specnr].flux_specG_err_stat^2+src.spectra[specnr].flux_specG_err_sys^2)
mean_flx=src.spectra[specnr].mean_flx
peak_flx=src.spectra[specnr].peak_flx
rmsP=src.spectra[specnr].rmsP
rmsG=src.spectra[specnr].rmsG
stn=src.spectra[specnr].ston
cont=src.spectra[specnr].continuum

RA_cen=src.spectra[specnr].RA_centroid
Dec_cen=src.spectra[specnr].Dec_centroid
radec_cen=radec_to_name(ra_cen,dec_cen)
RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell
radec_ell=radec_to_name(ra_ell,dec_ell)
a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell
npix_ell=src.spectra[specnr].npix_ell
isophot=src.spectra[specnr].isophot
map_smax=src.spectra[specnr].map_maxflx
Stot_map=src.spectra[specnr].flux_int_map
Stot_map_err=src.spectra[specnr].flux_map_err_stat

; get ellipse


totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; convert to string

sv50=strtrim(string(V50,W50,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,vcenerrp,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

;rms added April 23, 2006
rms=src.spectra[specnr].rmsP

;If zero then use gaussian value instead
if (rms eq 0.0) then rms=src.spectra[specnr].rmsG


deltara=(RA_ell-src.spectra[specnr].RA_opt)*3600.0*15.0*(cos(src.spectra[specnr].Dec_opt*!dpi/180.))   ;units of arcseconds
deltadec=(Dec_ell-src.spectra[specnr].Dec_opt)*3600.0

if (src.spectra[specnr].RA_opt eq 0.0 AND src.spectra[specnr].Dec_opt eq 0.0) then begin
  deltara=0.0
  deltadec=0.0
endif


;Determination of size
hsize=(a_ell*b_ell)/(3.5)^2


;Determine/Calculate errors - add in quadrature

vstaterr=src.spectra[specnr].vcenerr_stat[0]
   if (vstaterr eq 0.0) then vstaterr=src.spectra[specnr].vcenerr_stat[3]   ;if zero use gauss result
vsyserr=src.spectra[specnr].vcenerr_sys[0]*src.spectra[specnr].width[0]   ;use width
   if (vsyserr eq 0.0)  then vsyserr=src.spectra[specnr].vcenerr_sys[3]*src.spectra[specnr].width[3]  ;use width value

verr=sqrt((vstaterr)^2+(vsyserr)^2)   ;add computed results in quadrature


wstaterr=src.spectra[specnr].widtherr[0]
   if (wstaterr eq 0.0) then wstaterr=src.spectra[specnr].widtherr[3]   ;if zero use gauss result
wsyserr=src.spectra[specnr].widtherr[4]*src.spectra[specnr].width[0]
   if (wsyserr eq 0.0) then wsyserr=src.spectra[specnr].widtherr[5]*src.spectra[specnr].width[3]

werr=sqrt((wstaterr)^2+(wsyserr)^2)   ;add computed results in quadrature

fluxstaterr=src.spectra[specnr].flux_specP_err_stat/1000.0
   if (fluxstaterr eq 0.0) then fluxstaterr=src.spectra[specnr].flux_specG_err_stat/1000.0   ;if zero use gauss result
fluxsyserr=src.spectra[specnr].flux_specP_err_sys/1000.0    ;Don't need to convert to Jy km/s
   if (fluxsyserr eq 0.0)  then fluxsyserr=src.spectra[specnr].flux_specG_err_sys/1000.0

fluxerr=sqrt((fluxstaterr)^2+(fluxsyserr)^2)   ;add computed results in quadrature


;print,fluxstaterr, fluxsyserr, fluxerr

;SDSS information

	objID=src.spectra[0].x_str[3]       ;string type
	specObjID=src.spectra[0].x_str[4]  ;string type
	petroMag_u=src.spectra[0].x_flt[0]
	petroMag_g=src.spectra[0].x_flt[1]
	petroMag_r=src.spectra[0].x_flt[2]
	petroMag_i=src.spectra[0].x_flt[3]
	petroMag_z=src.spectra[0].x_flt[4]
	petroMagErr_u=src.spectra[1].x_flt[0]
	petroMagErr_g=src.spectra[1].x_flt[1]
	petroMagErr_r=src.spectra[1].x_flt[2]
	petroMagErr_i=src.spectra[1].x_flt[3]
	petroMagErr_z=src.spectra[1].x_flt[4]
    	extinction_u=src.spectra[2].x_flt[0]
   	extinction_g=src.spectra[2].x_flt[1]
    	extinction_r=src.spectra[2].x_flt[2]
   	extinction_i=src.spectra[2].x_flt[3]
    	extinction_z=src.spectra[2].x_flt[4]
	petroR50_r=src.spectra[0].x_flt[10]
	petroR90_r=src.spectra[0].x_flt[11]
	expAB_r=src.spectra[0].x_flt[12]

	modelMag_u=src.spectra[0].x_flt[5]
	modelMag_g=src.spectra[0].x_flt[6]
	modelMag_r=src.spectra[0].x_flt[7]
	modelMag_i=src.spectra[0].x_flt[8]
	modelMag_z=src.spectra[0].x_flt[9]

	modelMagErr_u=src.spectra[1].x_flt[5]
	modelMagErr_g=src.spectra[1].x_flt[6]
	modelMagErr_r=src.spectra[1].x_flt[7]
	modelMagErr_i=src.spectra[1].x_flt[8]
	modelMagErr_z=src.spectra[1].x_flt[9]

	;Extract the returned variables from the View (not table) SpecObj,   mjd, plate, fiberID
	specObjstring=src.spectra[0].x_str[5]

	mjd=strcompress(strmid(specObjstring,0, 5))
	plate=strcompress(strmid(specObjstring,5,5))
	fiberID=strcompress(strmid(specObjstring,10,5))

if (specObjID eq '-1') then specObjID='                -1'    ;for formatting
                                      
ns=0  ; FWHM measurement

  rdell=radec_to_name(src.spectra[ns].ra_ell,src.spectra[ns].dec_ell)
  rdcen=radec_to_name(src.spectra[ns].ra_centroid,src.spectra[ns].dec_centroid)

 vel=src.spectra[ns].vcen[0]
  if (vel eq 0.0) then vel=src.spectra[ns].vcen[3]   ;if measured with Gaussian
 width=src.spectra[ns].width[0]
  if (width eq 0.0) then width=src.spectra[ns].width[3]

  flux=src.spectra[ns].flux_int_specP/1000.
    if (flux eq 0.0) then flux=src.spectra[ns].flux_int_specG/1000.

  stn=src.spectra[ns].ston[0]
  if (stn eq 0.0) then stn=src.spectra[ns].ston[4]    ;if measured with Gaussian

if (mjd eq ' ') then mjd=''
if (plate eq ' ') then plate=''
if (fiberID eq ' ') then fiberID=''

  outstring='HI'+srcname+$
  string(src.spectra[ns].agcnr, format='(1x,i6)')+'  '+$
  string(objID)+'  '+$
  string(specObjID)+' '+$
  string(petroMag_u, format='(f6.2)')+'('+string(petroMagErr_u, format='(f5.2)')+')'+$
  string(petroMag_g, format='(f6.2)')+'('+string(petroMagErr_g, format='(f5.2)')+')'+$
  string(petroMag_r, format='(f6.2)')+'('+string(petroMagErr_r, format='(f5.2)')+')'+$
  string(petroMag_i, format='(f6.2)')+'('+string(petroMagErr_i, format='(f5.2)')+')'+$
  string(petroMag_z, format='(f6.2)')+'('+string(petroMagErr_z, format='(f5.2)')+')'+$

  string(modelMag_u, format='(f6.2)')+'('+string(modelMagErr_u, format='(f5.2)')+')'+$
  string(modelMag_g, format='(f6.2)')+'('+string(modelMagErr_g, format='(f5.2)')+')'+$
  string(modelMag_r, format='(f6.2)')+'('+string(modelMagErr_r, format='(f5.2)')+')'+$
  string(modelMag_i, format='(f6.2)')+'('+string(modelMagErr_i, format='(f5.2)')+')'+$
  string(petroMag_z, format='(f6.2)')+'('+string(modelMagErr_z, format='(f5.2)')+')'+$

  string(extinction_u, format='(f6.2)')+$
  string(extinction_g, format='(f6.2)')+$
  string(extinction_r, format='(f6.2)')+$
  string(extinction_i, format='(f6.2)')+$
  string(extinction_z, format='(f6.2)')+' '+$
  string(petroR50_r, format='(f6.2)')+'     '+$
  string(petroR90_r, format='(f6.2)')+'   '+$
  string(expAB_r, format='(f6.2)')+'     '+$

  string(long(mjd), format='(i5)')+'  '+string(long(plate), format='(i4)')+'    '+string(long(fiberID), format='(i4)')

   

  if (objID eq '' OR objID eq '-1') then begin
    outstring='HI'+srcname+$
    string(src.spectra[ns].agcnr, format='(1x,i6)')
  endif

  printf, indexlun, outstring



endfor


close, indexlun
free_lun, indexlun


end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro exportformat, list, codes, marked=marked


;dir='/home/astrosun/bkent/a2010/src/'
dir=''

;Check to see if html directory exists.  If it does, then clear the
;directory.  If not, create a new one

if (keyword_set(marked) eq 0) then begin     
   spawn,'ls -l formatcat',answer
      IF answer[0] EQ '' THEN BEGIN
         print, 'Creating new formatted catalog directory...'
         spawn, 'mkdir formatcat'
      ENDIF 
      IF answer[0] NE '' THEN BEGIN
         print, 'Formatted catalog directory exists - deleting old CATALOG.DAT in directory'
         spawn, '/bin/rm -r formatcat/catalog.dat'
      ENDIF   

openw, indexlun, 'formatcat/catalog.dat', /get_lun

endif

;-------------------------------

if (keyword_set(marked) eq 1) then begin
if (marked eq 1) then begin

  spawn,'ls -l markedcat',answer
      IF answer[0] EQ '' THEN BEGIN
         print, 'Creating new formatted MARKED catalog directory...'
         spawn, 'mkdir markedcat'
      ENDIF 
      IF answer[0] NE '' THEN BEGIN
         print, 'Formatted MARKED catalog directory exists - deleting old MARKEDCAT.DAT in directory'
         spawn, '/bin/rm -r markedcat/markedcat.dat'
      ENDIF   

openw, indexlun, 'markedcat/markedcat.dat', /get_lun

endif
endif




spawn, 'whoami', user

printf, indexlun, '### Formatted ALFALFA Catalog generated: '+systime(0)+'  by '+user



;printf, indexlun, '# Object, AGC, Other, Ellipse Center,deltaRA, deltaDEC, Optical Center, hsize, V [P],verr,W [P],werr,Sint P,Sint_err,Sint_map, code'

printf, indexlun, '#Object              AGC     Other Ellipse Center  dRA dDEC Optical Center   hsize   v50 verr   W50 werr   SintP  Serr  Sintmap   SN   rms   code   grid'
printf, indexlun, '#                                  J2000                    J2000                    km/s                  Jykm/s                      mJy'








;;;;;;; loop through each file
for i=0,n_elements(list)-1 do begin
;htmloutput, dir+list[i]

restore,dir+list[i]
srcname=src.srcname
nspec=n_elements(src.spectra)

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(round(src.spectra[j].isophot)), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]


specnr=0 ;FWHM measurements

type='integrated'
V50=src.spectra[specnr].vcen[0]
V20=src.spectra[specnr].vcen[1]
Vcen=src.spectra[specnr].vcen[2]
VcenerrP=src.spectra[specnr].vcenerr_stat[0]
VGauss=src.spectra[specnr].vcen[3]
VGausserr=src.spectra[specnr].vcenerr_stat[3]
W50=src.spectra[specnr].width[0]
W20=src.spectra[specnr].width[1]
WGauss=src.spectra[specnr].width[3]
WerrP=src.spectra[specnr].widtherr[0]
WerrG=src.spectra[specnr].widtherr[3]
Stot_specP=src.spectra[specnr].flux_int_specP
Stot_specG=src.spectra[specnr].flux_int_specG
Stot_specP_err=sqrt(src.spectra[specnr].flux_specP_err_stat^2+src.spectra[specnr].flux_specP_err_sys^2)
Stot_specG_err=sqrt(src.spectra[specnr].flux_specG_err_stat^2+src.spectra[specnr].flux_specG_err_sys^2)
mean_flx=src.spectra[specnr].mean_flx
peak_flx=src.spectra[specnr].peak_flx
rmsP=src.spectra[specnr].rmsP
rmsG=src.spectra[specnr].rmsG
stn=src.spectra[specnr].ston
cont=src.spectra[specnr].continuum

RA_cen=src.spectra[specnr].RA_centroid
Dec_cen=src.spectra[specnr].Dec_centroid
radec_cen=radec_to_name(ra_cen,dec_cen)
RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell
radec_ell=radec_to_name(ra_ell,dec_ell)
a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell
npix_ell=src.spectra[specnr].npix_ell
isophot=src.spectra[specnr].isophot
map_smax=src.spectra[specnr].map_maxflx
Stot_map=src.spectra[specnr].flux_int_map
Stot_map_err=src.spectra[specnr].flux_map_err_stat

; get ellipse


totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; convert to string

sv50=strtrim(string(V50,W50,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,vcenerrp,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

;rms added April 23, 2006
rms=src.spectra[specnr].rmsP

;If zero then use gaussian value instead
if (rms eq 0.0) then rms=src.spectra[specnr].rmsG


deltara=(RA_ell-src.spectra[specnr].RA_opt)*3600.0*15.0*(cos(src.spectra[specnr].Dec_opt*!dpi/180.))   ;units of arcseconds
deltadec=(Dec_ell-src.spectra[specnr].Dec_opt)*3600.0

if (src.spectra[specnr].RA_opt eq 0.0 AND src.spectra[specnr].Dec_opt eq 0.0) then begin
  deltara=0.0
  deltadec=0.0
endif


;Determination of size
hsize=(a_ell*b_ell)/(3.5)^2


;Determine/Calculate errors - add in quadrature

vstaterr=src.spectra[specnr].vcenerr_stat[0]
   if (vstaterr eq 0.0) then vstaterr=src.spectra[specnr].vcenerr_stat[3]   ;if zero use gauss result
vsyserr=src.spectra[specnr].vcenerr_sys[0]*src.spectra[specnr].width[0]   ;use width
   if (vsyserr eq 0.0)  then vsyserr=src.spectra[specnr].vcenerr_sys[3]*src.spectra[specnr].width[3]  ;use width value

verr=sqrt((vstaterr)^2+(vsyserr)^2)   ;add computed results in quadrature


wstaterr=src.spectra[specnr].widtherr[0]
   if (wstaterr eq 0.0) then wstaterr=src.spectra[specnr].widtherr[3]   ;if zero use gauss result
wsyserr=src.spectra[specnr].widtherr[4]*src.spectra[specnr].width[0]
   if (wsyserr eq 0.0) then wsyserr=src.spectra[specnr].widtherr[5]*src.spectra[specnr].width[3]

werr=sqrt((wstaterr)^2+(wsyserr)^2)   ;add computed results in quadrature

fluxstaterr=src.spectra[specnr].flux_specP_err_stat/1000.0
   if (fluxstaterr eq 0.0) then fluxstaterr=src.spectra[specnr].flux_specG_err_stat/1000.0   ;if zero use gauss result
fluxsyserr=src.spectra[specnr].flux_specP_err_sys/1000.0    ;Don't need to convert to Jy km/s
   if (fluxsyserr eq 0.0)  then fluxsyserr=src.spectra[specnr].flux_specG_err_sys/1000.0

fluxerr=sqrt((fluxstaterr)^2+(fluxsyserr)^2)   ;add computed results in quadrature


;print,fluxstaterr, fluxsyserr, fluxerr



ns=0  ; FWHM measurement

  rdell=radec_to_name(src.spectra[ns].ra_ell,src.spectra[ns].dec_ell)
  rdcen=radec_to_name(src.spectra[ns].ra_centroid,src.spectra[ns].dec_centroid)

 vel=src.spectra[ns].vcen[0]
  if (vel eq 0.0) then vel=src.spectra[ns].vcen[3]   ;if measured with Gaussian
 width=src.spectra[ns].width[0]
  if (width eq 0.0) then width=src.spectra[ns].width[3]

  flux=src.spectra[ns].flux_int_specP/1000.
    if (flux eq 0.0) then flux=src.spectra[ns].flux_int_specG/1000.

  stn=src.spectra[ns].ston[0]
  if (stn eq 0.0) then stn=src.spectra[ns].ston[4]    ;if measured with Gaussian

  subgrid=''
  if src.spectra[0].velarr[512] lt  1000 then subgrid='a'
  if src.spectra[0].velarr[512] lt  7000 and src.spectra[0].velarr[512] gt 3000 then subgrid='b'
  if src.spectra[0].velarr[512] lt 12000 and src.spectra[0].velarr[512] gt 8000 then subgrid='c'
  if src.spectra[0].velarr[512] gt 13000 then subgrid='d'

  printf, indexlun, 'HI'+srcname+$
  string(src.spectra[ns].agcnr, format='(1x,i6)')+$
  string(src.spectra[ns].agcname, format='(1x, a8)')+$
  string(rdell,format='(2x,a15)')+$
  string(deltara, format='(i4)')+$
  string(deltadec, format='(i4)')+$
  string(rdopt,format='(2x,a15)')+$
  string(hsize,format='(1x,f6.1)')+$ 
  string(vel,format='(1x,i5)')+$ 
  string(round(verr),format='(1x,i4)')+$ 
  string(width,format='(1x,i5)')+$ 
  string(round(werr),format='(1x,i4)')+$  
  string(flux,format='(1x,f7.2)')+$
  string(fluxerr,format='(1x,f5.2)')+$
  string(src.spectra[ns].flux_int_map/1000.,format='(1x,f7.2)')+$
  string(stn,format='(f7.1)')+$
  string(rms, format='(f6.2)')+$
  string(codes[i], format='(1x, i3)')+$
  string(src.gridgen.name, format='(5x, a7)')+$
  string(subgrid, format='(a1)')
;Note to Brian - add grid name here - added August 2006
;subgrid letter added Dec09 -rg



endfor


close, indexlun
free_lun, indexlun



end
