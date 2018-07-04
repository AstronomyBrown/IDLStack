;+
; NAME:
;      CONT_find
; PURPOSE:
;       Simple ALFALFA Tool for identifying NVSS sources
;
; EXPLANATION:
;
;NVSS is used as a guide.  Sources from NVSS are chosen in the grid
;reason that are greater than a peak intensity of 20 mJy/beam.  At
;each position of those sources in the grid, a gaussian fit is
;attemped for a 9 arcminutes window (IDL has trouble with anything
;smaller).
;The resulting centroid position from the Gaussian is used and the
;NVSS is searched once again for surrounding sources (orginially done
;to add the fluxes from surrounding sources), and the source with
;the closing matching position and flux (within 50%) is used.
;
;If an NVSS match is found, the max pixel in the grid cutout is
;determined.  The flux in a 7 arcminute block on that pixel is 
;summed, and divided by the sum of the beam weights at each of those
;points in the 7 arcminute block with an elliptical beam of size 3.3 x 3.8 arcminutes.
;
;An interpolated value (simpliest), gaussian peak, summed weighted
;elliptical, and a simple max pixel flux divided by gaussian weight
;(dist determined  between max pixel and gaussian fit) are saved.  The NVSS
;sizes, and peak intensities are recorded, and the NVSS errors in
;the peak intensity are also calculated (see NVSS documentation Condon
;et al.)
;
;
;
; CALLING SEQUENCE:
;       
;       cont_find, grid, nvsscat, finaltable
;
; INPUTS:
;       grid - an ALFALFA grid variable.
;       nvsscat - NVSS catalog file
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
;       finaltable - a continuum table structure
;
;
; RESTRICTIONS:
;
;        Works on ALFALFA data
;
; EXAMPLE:
;
;         Simple instructions to run stand alone
;         IDL> @alfinit
;         IDL> restore, '/home/dorado3/galaxy/idl_alfa/nvsscat_alfalfa.sav'
;         IDL> restore, '/home/arecibo2/galaxy/grids/1220+09/gridbf_1220+09b.sav'
;         IDL> cont_find, grid, nvsscat, cont_table
;         
;        See the cont_script file to run in a batch mode
;        
;
; PROCEDURES USED:
;         
;
; NODIFICATION HISTORY: 
;               B. Kent November 2006
;-------------------------------------------------------------------
pro cont_find, grid, nvsscat, finaltable


template={nvssid:0L, $
          ra_cen:0.0D, $
          dec_cen:0.0D, $
          peak_int:0.0D, $
          peak_interp:0.0D, $
          nvss_ra:0.0D, $
          nvss_dec:0.0D, $
          nvss_peak_int:0.0D, $
          nvsserror:0.0D, $
          MAJOR_AX:0.0D, $
          MINOR_AX:0.0D, $
          coeff:dblarr(7), $
          flag:0, $
          maxflux:0.0D, $
          correctedflux:0.0D, $
          sumcorrectedflux:0.0D}

finaltable=replicate(template, 1)


;First, find nvss sources with the grid coordinate ranges

ramin=grid.ramin
decmin=grid.decmin
xpix=dblarr(1000)
ypix=dblarr(1000)
count=0


   nx=n_elements(grid.d[0,0,*,0])
   ny=n_elements(grid.d[0,0,0,*])

   deltara=grid.deltara         ; grid spacing in RA, sec of time
   deltadec=grid.deltadec       ; grid spacing in Dec, arcmin
   rah=ramin+(dindgen(nx)+0.5)*deltara/3600.
   dec=decmin+(dindgen(ny)+0.5)*deltadec/(60.)

index=where(nvsscat.ra_2000_ lt max(rah)*15.0 AND $
               nvsscat.ra_2000_ gt min(rah)*15.0 AND $
               nvsscat.dec_2000_ lt max(dec) AND $
               nvsscat.dec_2000_ gt min(dec) AND $
               nvsscat.peak_int*1000.0 gt 20.0)




;Plot the map


mousestatus=1
sourcelist=strarr(1000)
window, /free, retain=2, xsize=495, ysize=495
xstyle=1
ystyle=1
posarray=[0.15,0.15,0.95,0.95]
color='00FFFF'XL
charsize=1.0
xtitle='RA pixel'
ytitle='DEC pixel'
ticklen=-0.01
smoothval=3

hor, 143,0
ver, 0,143


  device, decomposed=1 
  plot, [0,0], /nodata, xstyle=xstyle, ystyle=ystyle, position=posarray, $
             color=color, charsize=charsize, xtitle=xtitle, ytitle=ytitle, $
             ticklen=ticklen

  xyouts, 200,20, grid.name, /device, charsize=2.0, color=color

  device, decomposed=0
  loadct, 13, /silent
  
PX = !X.WINDOW * !D.X_VSIZE 
PY = !Y.WINDOW * !D.Y_VSIZE 
SX = PX[1] - PX[0] + 1 
SY = PY[1] - PY[0] + 1


 map=reform(grid.cont[*,*,*])
 map=total(map,1)/2.

;reverse and resize map - RA pixel increasing to the left

map=reverse(congrid(reform(map), sx, sy))

 offset=min(map)-(max(map)-min(map))*0.01
 tvscl, smooth(alog10(map-offset), smoothval, /edge_truncate), px[0], py[0] 

  device, decomposed=1

hor, 143,0
ver, 0,143

  plot, [0,0], /nodata, /noerase, xstyle=xstyle, ystyle=ystyle, position=posarray, $
             color=color, charsize=charsize, xtitle=xtitle, ytitle=ytitle, $
             ticklen=ticklen 
;  imgdisp, (reform(grid.cont[0,*,*])+reform(grid.cont[1,*,*]))/2.0, zx=6, zy=4, title=grid.name


;Now need to convert ra/dec into pixel value


for i=0, n_elements(index)-1 do begin

  ;nvsscat[index[i]].ra_2000_/15.0
  ;nvsscat[index[i]].dec_2000_

   raindex=where(rah ge nvsscat[index[i]].ra_2000_/15.0)
  decindex=where(dec ge nvsscat[index[i]].dec_2000_)



  ;llx is the lowest ra pixel, etc.

   llx=min(raindex)-4
   urx=min(raindex)+4
   lly=min(decindex)-4
   ury=min(decindex)+4

   if (llx lt 0) then llx=0
   if (urx gt 143) then urx=143
   if (lly lt 0) then lly=0
   if (ury gt 143) then ury=143

   rabox=rah[llx:urx]
   decbox=dec[lly:ury]
    
  

   cutout=reform((grid.cont[0,llx:urx, lly:ury]+grid.cont[1,llx:urx, lly:ury])/2.0) 

   ;Fit the 2D gaussian
   result=gauss2dfit(cutout, coeff, rabox, decbox)
   resultpix=gauss2dfit(cutout, coeffpix)
 
   ra_cen=coeff[4]
   dec_cen=coeff[5]

   interpflux=interpolate(cutout, coeffpix[4], coeffpix[5])
   gaussfitflux=coeff[0]+coeff[1]

   maxflux=max(cutout)
   cutoutmaxindex=where(cutout eq maxflux)
   
   ;convert to 2D coords
     s = SIZE(cutout)
      ncol = s(1)
     col = cutoutmaxindex MOD ncol
     row = cutoutmaxindex / ncol


   if (cutoutmaxindex[0] ne -1) then begin
      maxra=rabox[col]
      maxdec=decbox[row]
  endif

   ;Calculate the distance between the
   ;centroid position from the Gaussian,
   ;and the RA/Dec position of the pixel
   ;with the maximum value

    gcirc, 1, ra_cen, dec_cen, maxra, maxdec, separation  ;separation is returned in units of arcseconds

    ;Covert to arcminutes
    separation=separation/60.0

    FWHM=3.5
    sigma=FWHM/2.3548
    correctedflux=maxflux/exp(-0.5*(separation^2)/(sigma^2))


   ramin=min(rabox)
   ramax=max(rabox)

   decmin=min(decbox)
   decmax=max(decbox)

 indexcutout=where(nvsscat.ra_2000_ lt ramax*15.0 AND $
               nvsscat.ra_2000_ gt ramin*15.0 AND $
               nvsscat.dec_2000_ lt decmax AND $
               nvsscat.dec_2000_ gt decmin AND $
               nvsscat.peak_int*1000.0 gt 5.0)


                                ;Added November 10 - summed flux
                                ;                    method.  Add the
                                ;                    flux divided by
                                ;                    the weights of
                                ;                    the Gaussian beam

   sumflux=total(cutout[1:n_elements(rabox)-2,1:n_elements(decbox)-2])

   ;now determine the beam weights at those pixel positions
   sumbeam=0.0

   for m=1,n_elements(rabox)-2 do begin

       for l=1,n_elements(decbox)-2 do begin

            if (cutoutmaxindex[0] ne -1) then begin
                maxra=rabox[col]   ;location of max pixel
                maxdec=decbox[row] ;location of max pixel
                ;gcirc, 1, rabox[m], decbox[l], maxra, maxdec, separation  ;separation is returned in units of arcseconds

                ;separation in ra in ARCMINUTES!
                rasep=((15.0*(rabox[m]-maxra))*60.0)/cos(decbox[l]*!dpi/180.0)
                decsep=(decbox[l]-maxdec)*60.0

                 ;Covert to arcminutes
                ;separation=separation/60.0

                ;Use an elliptical Gaussian
                FWHMx=3.85
                sigmax=FWHMx/2.3548
                FWHMy=4.3
                sigmay=FWHMy/2.3548
                sumbeam=sumbeam+exp(-0.5*(rasep^2)/(sigmax^2))*exp(-0.5*(decsep^2)/(sigmay^2))
                ;sumbeam=sumbeam+exp(-0.5*(separation^2)/(sigma^2))

            endif

       endfor


   endfor


sumcorrectedflux=sumflux/sumbeam
   
if (indexcutout[0] ne -1) then begin

 gcirc, 1, dblarr(n_elements(indexcutout))+ra_cen, dblarr(n_elements(indexcutout))+dec_cen, $
                 nvsscat[indexcutout].ra_2000_/15.0,nvsscat[indexcutout].dec_2000_, dis    ;dis in units of arcseconds


    print, '           '
    print, '----------------------------------------'
   for j=0, n_elements(indexcutout)-1 do begin
     
 

       print ,j, strcompress(indexcutout[j]), nvsscat[indexcutout[j]].ra_2000_/15.0,nvsscat[indexcutout[j]].dec_2000_,$
                  nvsscat[indexcutout[j]].peak_int*1000.0, dis[j]/60.0, gseval(3.5,dis[j]/60.0)
               
 

   endfor 

    print, 'RAcen: ',ra_cen
    print, 'DECcen: ',dec_cen
    print, 'Flux: ',interpflux, ' mJy/beam'

    
       

       ;First check to see if the fit is any good

       if(ra_cen gt ramax OR ra_cen lt ramin OR dec_cen gt decmax OR dec_cen lt decmin) then begin
           print, 'Cannot fit...continuing to the next source'
           continue
       endif

     
       num=where(dis eq min(dis))

        ;topelements=0.0
        ;bottomelements=0.0

        ;for j=0, n_elements(indexcutout)-1 do begin
     
        ;   topelements=topelements+nvsscat[indexcutout[j]].peak_int*1000.0*gseval(3.5,dis[j]/60.0)   ;Flux times beam attenuation
           ;bottomelements=bottomelements+gseval(3.5,dis[j]/60.0)   ;Beam attenuation
  
        ;endfor

        ;nvss_flux=topelements
        ;print, 'NVSS summed flux/sum of beams:', nvss_flux


         if (num[0] ne -1) then begin 

             print, 'Coeff[0]+Coeff[1]=', coeff[0],'+',coeff[1],'=',coeff[0]+coeff[1]
             print, 'Interpolated=', interpflux
             print, 'Max Flux=', maxflux
             print, 'Corrected=', correctedflux
             print, 'SumCorrected=', sumcorrectedflux
             print, 'Diff: ', (abs(nvsscat[indexcutout[num]].peak_int*1000.0-(sumcorrectedflux))/(nvsscat[indexcutout[num]].peak_int*1000.0))

      if ((abs(nvsscat[indexcutout[num]].peak_int*1000.0-(sumcorrectedflux))/(nvsscat[indexcutout[num]].peak_int*1000.0)) gt 0.5) then begin
           print, 'Cannot find a good match...continuing to the next source'
           continue
       endif

       ;Calculate NVSS errors


       thetaN=45.0/3600.0

       majorpart=(1+(thetaN/nvsscat[indexcutout[num]].major_ax)^2)^(1.5)
       minorpart=(1+(thetaN/nvsscat[indexcutout[num]].minor_ax)^2)^(1.5)

       rho_sq=((nvsscat[indexcutout[num]].major_ax*nvsscat[indexcutout[num]].minor_ax)/(4*thetaN^2))*majorpart*minorpart*$
               (nvsscat[indexcutout[num]].peak_int^2/nvsscat[indexcutout[num]].I_rms^2)

       nvss_err_sq=2*nvsscat[indexcutout[num]].peak_int^2/(rho_sq)+(nvsscat[indexcutout[num]].peak_int*0.03)^2+0.0003^2

       ;Convert NVSS error to mJy
       nvsserror=1000.0*sqrt(nvss_err_sq)

       print, 'NVSS error: ', nvsserror
  
       tempnew=template

       tempnew.nvssid=indexcutout[num]
       tempnew.ra_cen=ra_cen
       tempnew.dec_cen=dec_cen
       tempnew.peak_int=coeff[0]+coeff[1]
       tempnew.peak_interp=interpflux
       tempnew.nvss_ra=nvsscat[indexcutout[num]].ra_2000_/15.0
       tempnew.nvss_dec=nvsscat[indexcutout[num]].dec_2000_
       tempnew.nvss_peak_int=nvsscat[indexcutout[num]].peak_int*1000.0
       tempnew.nvsserror=nvsserror
       tempnew.major_ax=nvsscat[indexcutout[num]].major_ax
       tempnew.minor_ax=nvsscat[indexcutout[num]].minor_ax
       tempnew.coeff=coeff
       tempnew.maxflux=maxflux
       tempnew.correctedflux=correctedflux
       tempnew.sumcorrectedflux=sumcorrectedflux
       tempnew.flag=n_elements(indexcutout)
       ;tempnew.nvss_peak_int=nvss_flux

       finaltable=[finaltable,tempnew]

       xpix[count]=(urx-llx)/2.0+llx
       ypix[count]=(ury-lly)/2.0+lly
       count++

       device, decomposed=1
       oplot, xpix, ypix, psym=6, color='00FFFF'XL
       print, 'Found a match!'
       ;wait, 1.0

       endif


endif else begin
   print, indexcutout
endelse




endfor

wdelete

finaltable=finaltable[1:n_elements(finaltable)-1]

;;;;;;;;;;;;;;;;;

charsize=2.0

;window, /free, retain=2, xsize=600, ysize=600
;plot, alog10(finaltable.peak_int), alog10(finaltable.nvss_peak_int), psym=6, xrange=[0.9,3.2], yrange=[0.9,3.2],$
;     xtitle='LOG 10 ALFALFA continuum [mJy/beam]', ytitle='LOG 10 NVSS continuum [mJy/beam]', charsize=charsize,$
;     title='Continuum comparison', xstyle=1, ystyle=1

;oplot, findgen(10), findgen(10), linestyle=2


;window, /free, retain=2, xsize=600, ysize=600

;plot, (((finaltable.ra_cen-finaltable.nvss_ra)*15.0)/cos(finaltable.dec_cen*!dpi/180.0))*3600.0,$
;        (finaltable.dec_cen-finaltable.nvss_dec)*3600.0, psym=1, xrange=[-60,60], yrange=[-60,60],$
;     xtitle='delta RA [arcsec]', ytitle='delta DEC [arcsec]', charsize=charsize,$
;     title='Positional Offsets'

;wait, 3.0

;wdelete
;wdelete


end 
