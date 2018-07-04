;+
;NAME:
;blmap.pro - Resets BP and Baselines a 2D strip segment of an m map 
;
;SYNTAX:
;
; blmap,m,blm,bl,npol=npol,ns=ns,mask2=mask2,nfit=nfit,GAUSAV=gausav,HAN=han,$
;       INTERACT=interact
;
;PARAMETERS:
;
;	m	input m file - a map of nchn spectral channels
;		 	     		npol polarizations
;		 	     		nrec records
;		 	     		nstrip strip segments
;	blm	output m file, with 2D strip ns baselined 
;	bl	"baseline" structure, containing fit baseline
;		details for each spectrum; if it doesn't exist,
;		procedure creates it; if it exists, it is
;		modified. Size: 2 x nrec x nstrip
;	npol	pol nr to be baselined
;	ns	strip segment nr to be baselined
;	mask2	a 2D mask used for baselining (all 1 except for
;		regions to be excluded from fit, which are =0)
;		It should be input to the program:
;		 - if not entered, it is set to mask2 = intarr(nchn,nrec)+1
;		Procedure will allow interactive determination by user. 
;		It will be returned as used.
;		NOTE it's 2D, i.e. it's NOT the same for all spectra
;		in the map
;	nfit	polynomial order for fit
;		THIS IS A 1D ARRAY of size nrec, so that different 
;		fit orders can be used for different records.
;		nfit is returned as it was input, NOT as modified
;		If it is not entered, user is prodded to set value,
;               which will be the same for all recs.
;		You can interactively modify nfit for a specific record. 
;
;KEYWORDS:
;
;	GAUSAV	FWHM of a GAussian weighting function, expresssed in
;		number of records, with which the map should be
;		convolved, FOR THE MAP DISPLAY ONLY (in order to 
;		have a higher sensitivity display). **The baseline
;		is actually applied to the unsmoothed map; the output
;		spectra remain unsmoothed**.
;	HAN	spectral smoothing applied to all spectra of the map,
;		in order to increase the sensitivity of the DISPLAY.
;		Options are 3-channel, 5-channel and 7-channel Hanning
;		(HAN=3, HAN=5, HAN=7).** The baseline
;		is actually applied to the unsmoothed map; the output
;		spectra remain unsmoothed**.
;	INTERACT = 0, then mask as supplied by user is applied
;		w/o any displays,
;		 = 1, map is displayed and option to either use
;		input mask or one interactively set is given

;DESCRIPTION:
;
; A 2D map (single strip, single pol) can have its "background"
; facelifted in two modes:
; 1) record intervals of the map can have a median (over selected
;    range of records) subtracted, to improve on a flawed BPC
; 2) each record can be baselined via subtraction of a polyfit
; In each case, regions of the map can be interactively selected
; to create the "off" or the fit.
; The displayed map can be smoothed, for better appreciation of
; baseline structure; the subtraction is done on the unsmoothed data.
; The outpur structure is identical to the input structure, except
; for the re-BP, baselined data in strip ns, polzn npol.
; Polynomial baselines are of order nfit to each of the spectra in  
; the strip ns, polarization npol of the map.
; It does so with minimal fuss (INTERACT=0), applying the input 2D
; array mask2 to exclude some aprts of the map from the fit;
; or it allows user to decide whether input mask2 should
; be used or a new one should be interactively set (INTERACT=1) 
; mask2 is a nchn x nrec array
; The mask2 used for the baseline fit is returned to the user
;
; A bl structure is either created or modified. Its contents are:
;	scannr		same as in m.h.std
;	recnr		same as in m.h.std
;	beamnr		for ALFA
;	rahr, decdeg	same as in m
;	pol_coadd	'yes' or 'no '; if 'yes' coadded spectra are in npol=0
;	stage		bline stage - 1 for first bline try (here)
;				    - 2 for fit to previously fit data, etc.
;	han		smoothing applied in output spectra. 
;			No smoothing=> han=1 (this procedure)
;			Use 3 for 'HAN 3', 5 for 'HAN 5', etc.
;	gausav		HPFW of Gaussian weight for avg along strip
;			direction. Here, no avging assumed, so gausav=1
;	in_data		string id of input structure type; here is 'mbp'
;	blorder		polyfit order of baseline
;	rms		rms of fit 
;	blcoeff		coeffs of polyfit, up to order 12 (beware it may bomb for
;                       very high values)
;	nregion		sequence of chan boundaries of mask (up to 20 prs)
;
; blmap processes one position-frequency map (single polarization)
; at a time.
;
; This procedure differs from that of PP's (cormapbl.pro) in the fact
; that it applies to a single 2D map rather than to a 3D cube and, more
; importantly, in that the baseline regions can be different for different
; spectra in the strip map: regions with signal can selectively be
; excluded from some spectra, and not from others in the strip map.
; The fit order can be different for different records, and is input as
; an array.
; The regions that can interactively be excluded from the baseline
; computation (i.e. seet to zero in the array mask2) are square boxes,
; the corners of which the user clicks on.
;
; Why one position-freq map at a time, rather than the full cube?
; It's easy to make a procedure that calls blmap and processes a
; full cube (it's blmaps.pro); however, we may want to apply TLC
; to specific maps in a cube that require special attention. 
;
;
; RG/29Jul04: first created as blmap.pro
; RG/23Nov04: generalized from blmap3.pro, including BP resetting
;_____________________________________________________________________

; SUBROUTINE TO DISPLAY THE 2D IMAGE

pro display_img,image,np=np,ns=ns,decd=decd,mapwindow


nrec=n_elements(image[0,*])
nchn=n_elements(image[*,0])
window,/free,xsize=960,ysize=700, retain=2
loadct, 1
device, decomposed=0

mapwindow=!d.window
!p.multi=[0,2,1]
imgdisp,image,$
        /histeq,$
        position=[0.05,0.05,0.95,0.95]
;contour, reform(msmooth[npol,*,ns].d), /fill, nlevels=100,$
;   position=[0.05,0.05,0.95,0.95],$
;   xrange=[0,nchn],yrange=[0,nrec],xstyle=1,ystyle=1
;xyouts,0,nrec+12.,mapid,size=1.5
xyouts,nchn/3,nrec+12,'Dec ='+string(decd),size=1.5
device, decomposed=1
;contour,mask2,thick=2,position=[0.05,0.05,0.95,0.95],$
;        c_colors='0000FF'XL,/overplot
yp=0
repeat begin
 yp=yp+100
 plots,[0,nchn-1],[yp,yp],linestyle=1
endrep until (yp gt nrec-100)
xp=0
repeat begin
 xp=xp+100
 plots,[xp,xp],[0,nrec-1],linestyle=1
endrep until (xp gt nchn-100)

end

;______________________________________________________________________

;SUBROUTINE TO SMOOTH THE IMAGE 
; GAUSAV is the HPFW of a gaussian in the rec direction
; HAN can be 3 oro 5, for Hanning smoothing in the spectral direction

pro smoothing,image_raw,image_smo,gausav=gausav,han=han

nrec=n_elements(image_raw[0,*])
nchn=n_elements(image_raw[*,0])

if (gausav gt 1) then begin
  gausskernel=psf_Gaussian(NPIXEL=41, FWHM=gausav,$
                           NDIMEN=1, /NORMALIZE)
  for i=0,nchn-1 do begin
    smoothedsample=convol(reform(image_raw[i,*]),gausskernel, /EDGE_TRUNCATE)
    image_smo[i,*]=reform(smoothedsample,1,nrec)     
  endfor
endif
image_smo2= image_smo
if (han gt 1) then begin
  if (han eq 3) then hansm=[0.5,1.,0.5]/2.
  if (han eq 5) then hansm=[0.25,0.75,1.,0.75,0.25]/3.
  if (han eq 7) then hansm=[0.146,0.5,0.854,1.,0.854,0.5,0.146]/4.
  for nr=0, nrec-1 do begin
    smoothedspec = convol(reform(image_smo[*,nr]),hansm,/edge_truncate)
    image_smo2[*,nr] = smoothedspec
  endfor 
endif

image_smo = image_smo2

end

;______________________________________________________________________

; SUBROUTINE TO DISPLAY REGIONS OF MAP, FOR VISUAL INSPECTION

pro check_img,image,mapwindow=mapwindow

nchn = n_elements(image[*,0])
nrec = n_elements(image[0,*])


select_box:

wset,mapwindow

Print,'Select a box in map:'
print, 'Left click LOWER LEFT corner of box...'
    cp, x=x, y=y
    xpos1=round(x)
    ypos1=round(y)
    if (xpos1 lt 0.) then xpos1 = 0.
    if (ypos1 lt 0.) then ypos1 = 0.
    wait, 0.5
    print,xpos1,ypos1
print, 'Left click UPPER RIGHT corner of box...'
    cp, x=x, y=y
    xpos2=round(x)
    ypos2=round(y)
    if (xpos2 gt nchn-1) then xpos2=nchn-1
    if (ypos2 gt nrec-1) then ypos2=nrec-1
    print,xpos2,ypos2
    wait, 0.5
    plots,[xpos1,xpos2],[ypos1,ypos1],color=12,thick=2
    plots,[xpos1,xpos2],[ypos2,ypos2],color=12,thick=2
    plots,[xpos1,xpos1],[ypos1,ypos2],color=12,thick=2
    plots,[xpos2,xpos2],[ypos1,ypos2],color=12,thick=2

hor
ver
while 1 do begin
  menu:
  print,'_______________________________________________________'
  print,''
  print,'KEY  ARGS      FUNCTION'
  print,'s    : get stats within the box'
  print,'r    : horiz avg and plot as a f(recnr)'
  print,'c    : vert  avg and plot as a f(chnr)'
  print,'q    : quit'
  char=''
  read,char

  case char of
    'q': goto,done

    's': begin
         print,'Mean =',mean(image[xpos1:xpos2,ypos1:ypos2])
         print,'Var  =',variance(image[xpos1:xpos2,ypos1:ypos2])
         print,'Stdev=',stddev(image[xpos1:xpos2,ypos1:ypos2])
         end
    'r': begin
         hor,ypos1,ypos2
         xarr=findgen(nrec)
         yarr=total(image[xpos1:xpos2,*],1)/(xpos2-xpos1+1)
         window,/free,xsize=700,ysize=450,xpos=430,ypos=450
         !p.multi=0
         specwindow=!d.window
         plot,xarr,yarr
         end
    'c': begin
         hor,xpos1,xpos2
         xarr=findgen(nchn)
         yarr=total(image[*,ypos1:ypos2],1)/(ypos2-ypos1+1)
         window,/free,xsize=700,ysize=450,xpos=430,ypos=450
         !p.multi=0
         specwindow=!d.window
         plot,xarr,yarr
         end
    else: goto,menu
  endcase
endwhile

done:
if (n_elements(specwindow) ne 0) then wdelete,specwindow
hor
ver
end
;______________________________________________________________________
;______________________________________________________________________

; MAIN PROGRAM

pro blmap,m,blm,bl,npol=npol,ns=ns,mask2=mask2,nfit=nfit,GAUSAV=gausav,HAN=han,$
          INTERACT=interact,MAPID=mapid



nrec=n_elements(m[npol,*,ns])
nstrip=n_elements(m[npol,0,*])
nchn=n_elements(m[npol,0,ns].d)
; if pols coadded on input, coadded spectra assumed to be in pol=0
; If bl structure doesn't exist (or isn't a 9-tag structure), define it
if (n_tags(bl) ne 14) then begin
   struct={bl,scannumber:0L,recnumber:0L,beam:0L,$
              rahr:0.,decdeg:0.,pol_coad:'',stage:1L,$
              han:1L,gausav:1L,in_data:'',$
              blorder:0L,rms:0.,$
              blcoeff:dblarr(13),nregion:intarr(40)}
   bl=replicate({bl},2,nrec,nstrip)
endif
if (n_elements(nfit) eq 0) then begin
  print,'fit order undefined. Enter order:'
  read,nff
  nfit =intarr(nrec)+nff
endif
pfit=nfit
if (n_elements(mask2) eq 0) then begin
  print,'mask2 undefined: I am setting all elements to 1'
  mask2=intarr(nchn,nrec)+1
endif
if (n_elements(GAUSAV) eq 0) then gausav=1
if (n_elements(HAN) eq 0) then han=1
if (n_elements(MAPID) eq 0) then MAPID=''
bl.pol_coad='no '
if (npol eq 2) then begin
  bl.pol_coad='yes'
  npol = 0
endif
bl.han=1
bl.in_data='mbp'
bl.gausav=1

image_raw = reform(m[npol,*,ns].d)
image_smo = image_raw
image_work= image_raw
decd = m[0,0,ns].decdeg

if (INTERACT eq 0) then goto, fitting

msmooth=m
mwork=m

;..............................................................................
; SMOOTH THE MAP (only for display purposes)

smoothmap:
smoothing, image_raw,image_smo,gausav=gausav,han=han

;..............................................................................
;DISPLAY THE SMOOTHED MAP

mapdisplay:
display_img, image_smo,np=npol,ns=ns,decd=decd,mapwindow

;..............................................................................
;OPTION TO INSPECT THE MAP AND IMPROVE BP SUBTRACTION

inspect:

ans=''
read,ans,prompt='Inspect the (unsmoothed) image? (y/n, def=y)  '
if (ans eq '' or ans eq 'y' or ans eq 'Y') then begin
    back:
    wdelete,mapwindow
    display_img, image_smo,np=npol,ns=ns,decd=decd,mapwindow
    check_img,image_raw,mapwindow=mapwindow
    ans2=''
    read,ans2,prompt='Select another box? (y/n def=n)'
    ans2=strlowcase(ans2)
    if (ans2 eq 'y') then goto,back
endif

read,ans,prompt='Do you want to reset bandpass segments? (y/n, def=n)'
ans=strlowcase(ans)
if (ans eq 'y') then begin
 bpset:
  print,'Enter record range: n1,n2  of region to be bandpass-reset'
  read,n1,n2
  rmask=intarr(nrec)
  wdelete,mapwindow
  display_img,image_smo,np=npol,ns=ns,decd=decd,mapwindow
  repeat begin
  print, 'Left click lower edge of rec interval to use for BP, right k to exit...'
    cp, x=x, y=y
    ypos1=round(y)
    if (ypos1 lt 0.) then ypos1 = 0.
    wait, 0.5
    if (!mouse.button eq 4) then goto, correct
  print, 'Left click UPPER edge of rec interval...'
    cp, x=x, y=y
    ypos2=round(y)
    if (ypos2 gt nrec-1) then ypos2=nrec-1
    wait, 0.5
    plots,[0,nchn-1],[ypos1,ypos1],color=12,thick=2
    plots,[0,nchn-1],[ypos2,ypos2],color=12,thick=2
    rmask[ypos1:ypos2]=1
  endrep until (!mouse.button eq 4)
 
  correct:
 
  ind = where(rmask ne 0,count)
  wmed = median(image_raw[*,ind],dimension=2)
  for nr=n1,n2 do begin
    image_work[*,nr] = image_work[*,nr] - wmed
  endfor

  ans2=''
  read,ans2,prompt='Done. Redo BP for another region? (y/n, def=n)'
  ans2=strlowcase(ans2)
  if (ans2 eq 'y') then goto, bpset

  smoothing, image_work,image_smo,gausav=gausav,han=han
  wdelete,mapwindow
  display_img,image_smo,np=npol,ns=ns,decd=decd,mapwindow

endif

ans=''
read,ans,prompt='Replace image and quit (q) or go to baseline (b)? (def=b)'
ans=strlowcase(ans)
if (ans eq 'q') then begin
  blm=m
  for nr=0,nrec-1 do begin
    blm[npol,nr,ns].d = image_work[*,nr]
  endfor
  goto, write_rest_of_bl
endif

;...............................................................................
;RESET THE MASK FOR BASELINE CALIBRATION

wdelete,mapwindow
display_img, image_smo,np=npol,ns=ns,decd=decd,mapwindow

print,'We are now ready to baseline one rec at a time....'
print,'You can set boxed nregions interactively on map'
ans=''
read,ans,prompt='Boxes excluded from fit. OK (CR), (r)eset or (c)heck spectrum fit? '
ans=strlowcase(ans)
if (ans eq '') then goto, fitting
if (ans eq 'c') then goto, plotbase

maskreset:
  mask2 = intarr(nchn,nrec)+1
  repeat begin
  print, 'Left click LOWER LEFT corner of box, right k to exit...'
    cp, x=x, y=y
    xpos1=round(x)
    ypos1=round(y)
    if (xpos1 lt 0.) then xpos1 = 0.
    if (ypos1 lt 0.) then ypos1 = 0.
    wait, 0.5
    print,xpos1,ypos1
    if (!mouse.button eq 4) then goto, querying
  print, 'Left click UPPER RIGHT corner of box...'
    cp, x=x, y=y
    xpos2=round(x)
    ypos2=round(y)
    if (xpos2 gt nchn-1) then xpos2=nchn-1
    if (ypos2 gt nrec-1) then ypos2=nrec-1
    print,xpos2,ypos2
    wait, 0.25
    plots,[xpos1,xpos2],[ypos1,ypos1],color=12,thick=2
    plots,[xpos1,xpos2],[ypos2,ypos2],color=12,thick=2
    plots,[xpos1,xpos1],[ypos1,ypos2],color=12,thick=2
    plots,[xpos2,xpos2],[ypos1,ypos2],color=12,thick=2
    mask2[xpos1:xpos2, ypos1:ypos2]=0
    device, decomposed=1
  endrep until (!mouse.button eq 4)

querying:
ans=''
read,ans,prompt='Happy with regions? (y/n, (c)heck fit on a record; def=y) '
ans=strlowcase(ans)
if (ans eq 'n') then goto, maskreset

plotbase:
xarr=findgen(nchn)
if (ans eq 'c' or ans eq 'r') then begin
  window,/free,xsize=700,ysize=450,xpos=430,ypos=450
  specwindow=!d.window
  repeat begin
    read,nr,prompt='Enter record nr: '
    mask1=reform(mask2[*,nr])
    yarr=reform(image_smo[*,nr])
    plotplot:
    plot,xarr,yarr,title='Baseline for record nr='+string(round(nr)),position=[0.05,0.05,0.95,0.95]
;    a=polyfitw(xarr*1.D,yarr*1.D,mask1,pfit[nr],yfit)
    measure_errors=(-(mask1-1.)*1e5+1.D)
    a=poly_fit(xarr,yarr,pfit[nr],yfit=yfit,$
               yband=yband,measure_errors=measure_errors,/double)
    oplot,xarr,yfit
    rans=''
    print,'Fit OK                         ... y or CR'
    print,'Check another                 ... c'
    print,'Reset map mask                ... r'
    print,'Change fit order for this rec ... f n'
    read,'?',rans
    rans=strlowcase(rans)
    if (strmid(rans,0,1) eq 'f') then begin
      reads,strmid(rans,2,2),norder
      pfit[nr]=round(norder)
      print,'Record '+string(round(nr))+' fit with nfit= '+strmid(rans,2,2)
      goto, plotplot
    endif
    if (rans eq 'c') then erase,specwindow
    if (rans eq 'r') then begin
      wdelete,specwindow
      wdelete,mapwindow
      goto, mapdisplay
    endif
  endrep until (rans eq '')
  wdelete,specwindow
endif

fitting:
xarr=findgen(nchn)
blm=m
nregion=intarr(20)
for i=0,nrec-1  do begin
  yarr=reform(image_work[*,i])
  mask1=reform(mask2[*,i])
  measure_errors=(-(mask1-1.)*1e5+1.D)
  a=poly_fit(xarr,yarr,pfit[i],yfit=yfit,$
             yband=yband,measure_errors=measure_errors,/double)
  blm[npol,i,ns].d=yarr-yfit
  indx=where(mask1 eq 1)
  rms=stddev(reform(blm[npol,i,ns].d[indx]))
  bl[npol,i,ns].RMS=rms
  bl[npol,i,ns].BLORDER=pfit[i]
  bl[npol,i,ns].BLCOEFF=a
  ind=where(mask1-shift(mask1,-1) ne 0,ncount)
  nregs=ncount/2
  if (mask1[0] eq 0) then ind=[-1,ind]
  j=0
  for n=0,nregs-1  do begin
    nregion[j]=ind[j]+1
    nregion[j+1]=ind[j+1]
    j = j+2
  endfor
  bl[npol,i,ns].NREGION=nregion
endfor

write_rest_of_bl:
bl[npol,*,ns].SCANNUMBER=blm[npol,*,ns].h.std.SCANNUMBER
bl[npol,*,ns].RECNUMBER=blm[npol,*,ns].h.std.RECNUMBER
bl[npol,*,ns].BEAM=0
bl[npol,*,ns].RAHR=blm[npol,*,ns].RAHR
bl[npol,*,ns].DECDEG=blm[npol,*,ns].DECDEG

print,'Done.'
!p.multi=0
wdelete,mapwindow

end

