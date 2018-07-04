;+
;NAME:
;GRID_flatfield
;
;SYNTAX:
;
;pro grid_flatfield, grid_in, grid_out,startch=startch,stopch=stopch
;
; The input grid_in is a GRID structure, produced by grid_prep and grid_base. 
; The output grid_out is the input GRID structure, after cosmetic improvements.
; The procedure produces "flat sky" channel maps; it can either process a whole
; grid or only the cannel maps between startch and stopch.
;
; DESCRIPTION:
;
; Flatfielding channel maps which are mostly empty of signals is straightforward
; and it is done automatically by applying robust polynomial fits of n=1 to
; each raster (strips of constant dec) of the channel map.
;
; Flatfielding channel maps with extended emission, e.g. with galactic HI,
; require interactive attention, especially if features are extended AND weak.
; A number of algorithms are available and can be applied individually or 
; sequentially, via a menu. 
;
; The input grid operated on by grid_flatfield has usually been already
; baselined in the spectral domain via grid_base. Grid_flatfield operates
; in an orthogonal plane, i.e. separately for each channel map.
;
; IF startch and stopch are NOT specified:
;
; The program first computes the median value of each channel map and displays
; it as a spectral plot; the user then chooses the ranges of spectral channels
; for which the corresponding channel maps will be flatfielded by applying
; a robust polyfit of n=1 to each raster in the map. 
; This part of the flatfielding is fast and usually very reliable. User can
; spot check the quality of the flatfielding job, whereby the "before" and
; the "after" versions of the channel map to be inspected are displayed side
; by side.
;
; Then the program enters in interactive mode, and each channel map that wasn't
; flatfielded via the robust poly option is proccessed with TLC, using one or
; more simple algorithms that optimize the desired result. 
; The following menu is available:
; 
;  You can now :   - add a no-fit box                         (b)
;                  - delete   a no-fit box                    (d boxnr)
;                  - fit median ( f(x), cross y)              (x)
;                  - fit median ( f(y), cross x)              (y)
;                  - fit median accelerator (x,y,f n,a)       (X n)
;                  - as X but only within given box           (W n)
;                  - fit vertical slice                       (v)
;                  - v + z over the whole x range             (V n)
;                  - interp. horizontal stripe                (i)
;                  - fit the map with iterative robust poly n (r n)
;                  - fit the map with one-try poly n          (f n)
;                  - apply multiplicative correction          (m nr)
;    (where nr is the min nr of pix in a raster, > 8 mJy, for correction
;     to be computed; def=4)'
;                  - add (med x + med y)/2                    (a)
;                  - subtract residuals of vert slice         (z)
;                  - check baseline quality                   (c rasternr)
;                  - partial save of grid_out                 (S)
;                  - reset and start anew                     (s)
;                  - apply and go to next strip/pol           (n or CR)
;                  - leave unchanged and go to next strip/pol (u)
;
; The 'r n' option is closest to what has been done to the nearly signal-empty
; channel maps, except that boxed regions are initially excluded from the fit,
; and the order is input by the user.
;
; The 'f n' option is analogous to the previous, except that there is no 
; iteration: the first fit of a poly of order n is taken, with given mask.
; This is desirable when very weak extended emission is present; the iterative
; approach only uses the mask for the first iteration, then it computes its
; own mask, posbily including parts of the image with weak emission.
;
; When only strong, localized sources are in the image, use 'r n'; when
; weak extended emission is present, mask it with the 'b' option and then
; use 'f n'.
;
; The 'm' option is generally used when there is strong extended emission,
; e.g. galactic HI, exhibiting strip bias. 'm' is a multiplicative correction
; which corrects for example for the fact that data has been converted to a
; flux density scale appropriate for point source or small sources, while
; galactic HI should remain expressed in antenna T. The procedure finds the
; systematic multiplicative factor rasters heavily weighed by beam 0, and
; applies it to the image. It can be applied successively more than once
; to the same image, for better effect.
; Since 'm' is a multiplicative correction, it can effectively be computed
; only if the map contains substantial emission. The 'nr' argument in 'm nr'
; refers to the minimum number of pixels in a given raster strip, which will
; exceed 10 mJy flux, for the m computation to be applied to that raster.
; Default is 4. Better avoid values of less than that. Use higher values
; if you care for a more precise computation (but that will reduce the number
; of strips being corrected in the map).
;
; 'x' and 'y' compute profiles of median values (after exclusion of boxed 
; regions) along x and y axes. The two functions represent large scale
; trends in the background emission (e.g. near wings of galactic HI), which
; are removed by poly fitting. For example, you can run 'x' and 'y' on the
; input image, then run a 'f 0' on it (thus removing background trends), as
; well as local striation, then reapply the background by invoking 'a'.
; This is useful in channel maps within the low emissivity wings of galctic
; HI. 'f 0' will remove striation as well as the extended weak background;
; 'a' put the background back, but you're now free of striation.
;
; 'v' and 'z' are seldom used but occasionally useful tools. 'v' computes
; a median vertical profile of the image, over a range of x-pix values.
; then it fits a poly 3 to that trend and records the residual from the
; fit. 's' applies an additive correction to each const dec strip raster,
; given by that residual. Occasionally useful when coarse offsets are
; see over a whole set of declination strips. Rarely effective, 'though.
;
; 'V' will apply 'v' and then 'z' over the whole x range; you can specify
; the polynomial degree (default 3, max 8)
;
; 'i' in case we want to remove a y-narrow horizontal stripe;
; defines a box and applies a linear vert. interpolation;
; intended to be used to refine the result of other options
;
; 'u' leaves a given channel map unchanged.
;
; 'b' adds a box of pixels to be excluded from poly fitting. Up to 40 of
; those can be used to mask emission or other feature in the channel image.
; They are "remembered" from one channel map to the next.
;
; 'd' is used to delete boxes activated by 'b'.
;
; At any given time, the corrections done to that point to the grid can be
; saved via 'S' (upper case) ==> this writes a file 'grid_out_flat.sav' on disk.
; The program will automatically write such a file every 10 channel maps
; iteratively processed, for safety, anyway.
; 
; Note that several of the "flatfielding" algorithms can be applied cumulatively
; to the iamge. You can for example do a 'f n' followed by a 'm'. The display
; will show the image "before" and "after" the last action. If you are unhappy
; with the outcome, you can always resume from the input image, by invoking
; 's' (note lower case).
;
; IF startch and stopch ARE SPECIFIED:
;
; Then only channel maps startch to stopch are iteratively worked on. The
; rest of the grid is elft unchanged. This is useful when, for example, you
; recover from a crash of the program, or when you discover that some channel
; map could be improved.
;
; BEST WAY TO USE THIS ROUTINE:
;
; After baselining the grid with grid_base, inspect iti with gridview, so you
; can appreciate the problems still extant in the data. Note the ranges of channel
; numbers of map that can be easily treated automatically by robust polyfit, and
; need no interactive work. Note the main problems in the rest. Then run this
; routine without the startch, stopch option, but with some previous awareness 
; of what you're about to fix.
; After you have run it, inspect the result with gridview, note the channel maps
; that still can be improved and run thisi routine with the startch, stopch option
; activated, specifically for the channel maps to be fixed.
;
; This routine allows for much latitude on the aprt of the user, in altering
; the data. and thus much damage can be done. So be careful. You can make the
; grids look better. You can also make them fake.
;
; NOTE: "flatfielding" is a misnomer. The term expresses well what is done for
; channel maps largely void of signal. When extended emission such as galactic HI
; is present, the lack of flatness in the image is inherent in the line emission,
; and should not be removed.
;
; Written by RG/Dec 05
; Modification history:
; 6apr06: Added the 'X' accelerator (AS)
; 12 aug 2010: RG added control of display for strong continuum sources
; 12 aug 2010: CG added 'V' and 'W' options
;---------------------------------------------------------------------------------------

; SUBROUTINE TO DISPLAY input and flatfielded images; RETURNS mapwindow

pro flat_imdisplay,image,fimage,nch,np,nreg=nreg,vel=vel, $
		col_index=col_index,row_index=row_index,mapwindow=mapwindow

nxpx=n_elements(image[*,0])
nypx=n_elements(image[0,*])
       if (n_elements(nreg) eq 0) then nreg=lonarr(40,4)
       bmask = intarr(nxpx,nypx)+1
       ind=where(total(nreg,2) ne 0,nind)
       if (nind ne 0) then begin
         for nnind=0,nind-1 do begin
           llch=nreg[ind[nnind],0]
           urch=nreg[ind[nnind],2]
           llrec=nreg[ind[nnind],1]
           urrec=nreg[ind[nnind],3]
           bmask[llch:urch,llrec:urrec]=0
         endfor
       endif
if(n_elements(vel) eq 0) then vel=0.
colin_min=col_index-5
colin_max=col_index+5
rowin_min=row_index-5
rowin_max=row_index+5
if (colin_min lt 0) then colin_min=0
if (colin_max gt nxpx-1) then colin_max=nxpx-1
if (rowin_min lt 0) then rowin_min=0
if (rowin_max gt nypx-1) then rowin_max=nypx-1
bmask(colin_min:colin_max,rowin_min:rowin_max)=0
goodindx=where(bmask eq 1)

iresult=moment(image[goodindx],sdev=isdev,mdev=imdev)
fresult=moment(fimage[goodindx],sdev=fsdev,mdev=fmdev)
imean=strtrim(string(iresult[0],format='(f7.2)'))
fmean=strtrim(string(fresult[0],format='(f7.2)'))
sisdev=strtrim(string(isdev,format='(f7.2)'))
sfsdev=strtrim(string(fsdev,format='(f7.2)'))
iskew=strtrim(string(iresult[2],format='(f6.2)'))
fskew=strtrim(string(fresult[2],format='(f6.2)'))
ikurt=strtrim(string(iresult[3],format='(f6.2)'))
fkurt=strtrim(string(fresult[3],format='(f6.2)'))
imed=strtrim(string(median(image),format='(f7.2)'))
fmed=strtrim(string(median(fimage),format='(f7.2)'))
strvel=strtrim(string(vel,format='(f7.1)'))

clip_i=iresult[0]+10.*isdev
clip_f=fresult[0]+10.*fsdev
cimage=image
cfimage=fimage
large_i=where(image gt clip_i,nlarge_i)
if(nlarge_i gt 0) then cimage(large_i)=clip_i
large_f=where(fimage gt clip_f,nlarge_f)
if (nlarge_f gt 0) then cfimage(large_f)=clip_f

window,/free,xsize=1024,ysize=500,retain=2
!p.multi=[0,2,1,0,0]
loadct,1
device, decomposed=1
imgdisp,cimage,position=[0.05,0.08,0.48,0.89]
mapwindow=!d.window
xyouts,0,nypx+10,'Input image'
xyouts,80,nypx+10,'Channel nr '+strtrim(string(nch))+'  Pol '+strtrim(string(np))+$
                 '     Vel='+strvel,charsize=1.5
xyouts,0,nypx+5,'mean='+imean+'  sdev='+sisdev+'  skew='+iskew+'  kurt='+ikurt+$
                 '  med='+imed,charsize=1.2
xyouts,0,-10,'A Production of LOVEDATA, Inc. Ithaca, NY',Size=0.75
       for nb=0,39 do begin
         if (total(nreg[nb,*],2) ne 0) then begin
          LLch =nreg[nb,0]
          LLrec=nreg[nb,1]
          URch =nreg[nb,2]
          URrec=nreg[nb,3]
          plots,[LLch,URch],[LLrec,LLrec],linestyle=0,color='00FF00'XL,thick=2
          plots,[LLch,URch],[URrec,URrec],linestyle=0,color='00FF00'XL,thick=2
          plots,[LLch,LLch],[LLrec,URrec],linestyle=0,color='00FF00'XL,thick=2
          plots,[URch,URch],[LLrec,URrec],linestyle=0,color='00FF00'XL,thick=2
          abitx=nxpx/40
          abity=nypx/40
          xyouts,(LLch+URch)/2-abitx,LLrec-abity,strtrim(string(nb),2),charsize=1.5,color='00FF00'XL
         endif
       endfor

imgdisp,cfimage,position=[0.54,0.08,0.97,0.89]
xyouts,nxpx-30,nypx+10,'Output image'
xyouts,0,nypx+5,'mean='+fmean+'  sdev='+sfsdev+'  skew='+fskew+'  kurt='+fkurt+$
                 '  med='+fmed,charsize=1.2
device, decomposed=0

end

;-------------------------------------------------------------------------------------------
;
;NAME:
;flat_robfit_poly - robust polyfit for 1d array
;SYNTAX:  coef=flat_robfit_poly(x,y,deg,nsig=nsig,double=double,sig=sig,imask=imask,$
;                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
;                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=maxiter)
;  ARGS:
;     x[n]  : x array for fit
;     y[n]  : y  array for fit 
;      deg  : int deg of polynomial fit
;KEYWORDS:
;     nsig  : float use nsig*sigma as the threshold for the points to
;                   keep on each iteration. The default is 3.
;     imask : long[] initial mask, zero where strong signal
;     double:       if set then force computation to be done in double
;                   precision.
;    maxiter:       maximum number of times to loop. default is 20.
; RETURNS:
;coef[deg+1]: float/double the fit coef. 
;   sig       float/double the last computed rms
;   fpnts :   float        the fraction of points used for the final
;                          computation
;    gindx:   long[]       indices into d for the points that were used
;                          for the computation.
;    ngood    long         number of points in gindx.
;    bindx:   long[]       indices into d for the points that were not used
;    nbad     long         number of points in bindx.
;    iter     long         number of iterations performed.
;    yfit :  float/double the fit evaluated at x[n]
;
; DESCRIPTION:
;    compute a robust polynomial fit for the input data x,y. The program loops
; doing:
;   0. create a mask that includes all the points.
;   1. fit the polynomial, rms residuals over the current mask
;   2. Find all points in the original array that are within nsig*sig of 
;      the fit. This becomes the new mask. 
;   3. if sig is less than the minimum sig so far, minsig=sig, and
;      store indices for this minimum sig
;   4  If the new mask does not have the   same number of points than the 
;      old mask, go to 1.
;   5. Check the coef of the Check if the 
;   5. Return the last coefs computed. If the keywords are present, return
;      the sig, index for good points, index for bad points, and the fraction
;      of points used in the final computation, and yfit.
;.
;-
;history:
; 06apr05 .. stole from avgrob
; 13jun05 .. this can oscillate. keep track of gindx of min sig
;            an place a limit on iter
; 29oct05 ..RG: stole from Phil, added initial mask (imask) input, to 
;               shorten convergence when big signal present in spectrum
; 23Nov05 ..RG: added a "force-to-use" mask, which should be used in fit,
;               no matter what the residuals may be; this helps when
;               signals are close to the edge of the band, and "anchoring"
;               the fit becomes necessary, else high order fit blows 
;
function  flat_robfit_poly,x,y,deg,nsig=nsig,imask=imask,forcemask=forcemask,$
                      double=double,sig=sig,gindx=gindx,$
                      iter=iter,ngood=ngood,bindx=bindx,nbad=nbad,fpnts=fpnts,$
                      yfit=yfit,status=status,maxiter=maxiter
    one=(keyword_set(double))?1D:1.
	if n_elements(maxiter) eq 0 then maxiter=20
    szx=size(x)
    npntsTot=szx[szx[0]+2]
    if not keyword_set(nsig) then nsig=3.
    nsig=nsig*one
    ngood=npntsTot
    gindx=lindgen(ngood)
    if (n_elements(imask) gt 0) then gindex=where(imask ne 0,ngood) ; added by rg
    if (n_elements(forcemask) eq 0) then forcemask=intarr(npntsTot)  ; added by rg
    done=0
    iter=1
	minsig=-1.
	chkiter=20
	gindsminsig=gindx
	start=1
    while (not done) do begin
        coef=poly_fit(x[gindx],y[gindx],deg,double=double,status=status,$
            yerror=sig)
        if sig eq 0. then begin
            done=1
        endif else begin
            yfit=poly(x,coef)
            gindx =where( abs(yfit-y) lt (nsig*sig) or forcemask eq 1,count) ; mod by rg
			if start then  begin
					gindxminsig=gindx
					minsig=sig
					start=0
					mincoef=coef
			endif
            if    (count ne ngood) then begin
                ngood=count
                iter=iter+1
				if sig lt minsig then begin
					minsig=sig
					gindxminsiq=gindx
					mincoef=coef
				endif
            endif else begin
                DONE=1
            endelse
        endelse
        if ngood eq 0 then done=1
		if iter gt maxiter then done=1
    endwhile
	if (sig gt minsig) and (start eq 0)  then begin
		sig=minsig
		gindx=gindxminsig
		ngood=n_elements(gindx)
		coef=mincoef
	endif
    if arg_present(bindx) or arg_present(nbad) then begin
        ii=intarr(npntsTot)
        if ngood gt 0 then ii[gindx]=1
        bindx=where(ii eq 0,nbad)
    endif
    if (n_elements(yfit) eq 0) and (arg_present(yfit)) then yfit=poly(x,coef)
    fpnts=ngood/(npntsTot*1.)
    return,coef
end

;.................................................................................

pro check_maps,grid_in,grid_out,nchn

Print,'Care to check any maps?'
ans=''
Read,ans
If (ans eq 'y' or ans eq 'Y') then begin
  pick_ch_number:
  Print,' Enter channel number, pol number (-1,-1 to move on)'
  Read,nch,np
  if (nch eq -1) then goto,moveon
  If (nch lt 0 or nch gt nchn or np lt 0 or np gt 1) then goto,pick_ch_number
  image=reform(grid_in.d[nch,np,*,*])
  fimage=reform(grid_out.d[nch,np,*,*])
  vel=grid.velarr[nch]
  flat_imdisplay,image,fimage,nch,np,vel=vel,mapwindow=mapwindow
  Print,'Hit return when done inspecting'
  read,ans
  wdelete,mapwindow
  goto,pick_ch_number
endif

moveon:
end

;...................................................................................

pro flat_menu,nreg1,np,nj,line1=line1,lineargs=lineargs

   print,'---------------------------------------' 
   Print,' Box nr  LLch    LLrec   URch   URrec'
   print,'---------------------------------------' 
   for nb=0,39 do begin
     if (total(nreg1[nb,*],2) ne 0) then $
     Print,nb,nreg1[nb,*],format='(3x,i2,4(4x,i4))'
   endfor
   print,'---------------------------------------' 

   print,'You can now :  - add a no-fit box                         (b)'
   print,'               - delete   a no-fit box                    (d boxnr)'
   print,'               - fit median ( f(x), cross y)              (x)'
   print,'               - fit median ( f(y), cross x)              (y)'
   print,'               - fit median accelerator (x,y,f n,a)       (X n)'
   print,'               - as X but only within given box           (W n)'
   print,'               - fit vertical slice                       (v)'
   print,'               - v + z over the whole x range             (V n)'
   print,'               - interp. horizonthal stripe               (i)'
   print,'               - fit the map with iterative robust poly n (r n)'
   print,'               - fit the map with one-try poly n          (f n)'
   print,'               - apply multiplicative correction          (m nr)'
   print,' (where nr is the min nr of pix in a raster, > 8 mJy, for correction'
   print,'  to be computed; def=4)'
   print,'               - add (med x + med y)/2                    (a)' 
   print,'               - subtract residuals of vert slice         (z)'
   print,'               - check baseline quality                   (c rasternr)'
   print,'               - partial save of grid_out                 (S)'
   print,'               - reset and start anew                     (s)'
   print,'               - apply and go to next strip/pol           (n or CR)'
   print,'               - leave unchanged and go to next strip/pol (u)'
   line1='string'
   read,'?',line1
   line=strtrim(line1,1) ; remv leading blnks
   itemp=strpos(line1,' ') ; find char nr w 1ast occurrence of blnk
   len=strlen(line1) ; nr of chars in line
   if (itemp ne -1) and((itemp+1) le len) then begin
    lineargs=strmid(line1,itemp+1,len-(itemp)) ; contains args, e.g. 'd 3'
   endif else begin
    lineargs=''
   endelse

end

;...................................................................................

pro grid_flatfield,grid_in,grid_out,startch=startch,stopch=stopch

!p.multi=0

grid_out=grid_in

nchn=n_elements(grid_in.d[*,0,0,0])
nx=n_elements(grid_in.d[0,0,*,0])
ny=n_elements(grid_in.d[0,0,0,*])
npol=2

contimage=reform((grid_in.cont[0,*,*]+grid_in.cont[1,*,*])/2.)
index=where(contimage eq max(contimage))
dims=size(contimage,/dimensions)
ncol=dims(0)
col_index=index mod ncol
row_index=index/ncol
;print,'x y max',col_index,row_index,max(contimage)

xarr=findgen(nx)
yarr=findgen(ny)
charr=findgen(nchn)

if (n_elements(startch) ne 0) then goto,ONE_BY_ONE

; PROLOG: Check medians of channel maps; pick regions for flatfielding

meds=fltarr(nchn)
for nch=0,nchn-1 do begin
  image=reform(total(grid_in.d[nch,*,*,*],2))
  meds[nch]=median(image,/even)
endfor

window,/free,xsize=600,ysize=400,retain=2
hor
ver
plot,charr,meds,yrange=[-2,2.]
oplot,charr,fltarr(nchn)
wmask=intarr(nchn)
Print,'Select intervals of channel numbers with floors set to zero'
pick_range:
Print,'   Left Click for low ch boundary'
cp, x=x, y=y
xpos1=round(x)
if (xpos1 lt 0.) then xpos1 = 0.
wait, 0.5
Print,'   Left Click for hi  ch boundary'
cp, x=x, y=y
xpos2=round(x)
if (xpos2 ge nchn) then xpos2 = nchn-1
wait, 0.5
wmask[xpos1:xpos2]=1
Print,' Another interval? (def=y)'
ans=''
read,ans
if (ans eq 'y' or ans eq 'Y' or ans eq '') then goto,pick_range

indch1=where(wmask eq 1, nindch1)
indch0=where(wmask eq 0, nindch0)
wdelete

; OK, channel maps with wmask=1 will be flatfielded automatically
;     channel maps with wmask=0 will be treated manually

; FLAT FIELD CHANNEL MAPS with wmask=1
; Do so by subtracting a n=1 iterative, robust fit from each raster 

nk=0
for k=0,nindch1-1 do begin
  nch=indch1[k]
  nk=nk+1
  if (nk eq 50) then begin
    print,nch
    nk=0
  endif
  for np=0,npol-1 do begin
    image=reform(grid_in.d[nch,np,*,*])
    fimage=image
    for nj=0,ny-1 do begin
       raster=reform(image[*,nj])
       coef=flat_robfit_poly(xarr,raster,1L,sig=sig)
       yf=poly(xarr,coef)
       fimage[*,nj]=image[*,nj]-yf
    endfor
    grid_out.d[nch,np,*,*]=fimage
  endfor
endfor

check_maps,grid_in,grid_out,nchn

; SMOOTH CHANNEL MAPS with wmask=0
; we do them interactively, one channel map, one pol at a time

ONE_BY_ONE:

!p.multi=0

norder=0L
nk=0
this_nreg=lonarr(40,4)

if (n_elements(startch) ne 0) then begin
  k1=startch
  k2=stopch
endif else begin
  k1=0
  k2=nindch0-1
endelse

for k=k1,k2 do begin
  if (n_elements(startch) ne 0) then begin
    nch=k
  endif else begin
    nch=indch0[k]
  endelse
  nk=nk+1
  if (nk eq 10) then begin
;    print,'.........................Saving grid_out, modified up to channel: ',nch
;    save,grid_out,file='grid_out_flat.sav'
    nk=0
  endif

  for np=0,npol-1 do begin 
    vert=fltarr(ny)
    medx=fltarr(nx)
    medy=fltarr(ny)
    image=reform(grid_in.d[nch,np,*,*])
    fimage=image
    display_image:
    velocity=grid_in.velarr[nch]
    flat_imdisplay,image,fimage,nch,np,nreg=this_nreg,vel=velocity, $
		col_index=col_index,row_index=row_index,mapwindow=mapwindow

    menu:
    flat_menu,this_nreg,np,nch,line1=line1,lineargs=lineargs

    case strmid(line1,0,1) of

    'b': begin
         ind=where(total(this_nreg,2) eq 0)
         nbox=min(ind)  ;FIRST FREE BOX
         wset,mapwindow
         Print,'Select a box in map to the right:'
         print, 'Left click LOWER LEFT corner of box...'
         cp, x=x, y=y
         xpos1=round(x)
         ypos1=round(y)
         if (xpos1 lt 0.) then xpos1 = 0.
         if (ypos1 lt 0.) then ypos1 = 0.
         wait, 0.5
         print, 'Left click UPPER RIGHT corner of box...'
         cp, x=x, y=y
         xpos2=round(x)
         ypos2=round(y)
         if (xpos2 gt nx-1) then xpos2=nx-1
         if (ypos2 gt ny-1) then ypos2=ny-1
         wait, 0.5
         device, decomposed=1
         plots,[xpos1,xpos2],[ypos1,ypos1],color='00FF00'XL,thick=2
         plots,[xpos1,xpos2],[ypos2,ypos2],color='00FF00'XL,thick=2
         plots,[xpos1,xpos1],[ypos1,ypos2],color='00FF00'XL,thick=2
         plots,[xpos2,xpos2],[ypos1,ypos2],color='00FF00'XL,thick=2
         abitx=nx/20
         abity=ny/20
         xyouts,(xpos1+xpos2)/2-abitx,ypos1-abity,$
                 strtrim(string(nbox),2),charsize=1.5,color='00FF00'XL
         print,round(xpos1),round(ypos1),round(xpos2),round(ypos2),format='(i4,3(",",i4))'
         this_nreg[nbox,*]=[round(xpos1),round(ypos1),round(xpos2),round(ypos2)]
         goto, menu
         end

    'd': begin
         if (lineargs eq '') then goto,menu
         reads,lineargs,nbox
         this_nreg[nbox,*]=0
         wdelete,mapwindow
         goto,display_image
         end
  
    'x': begin
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for ni=0,nx-1 do begin
           goodindx=where(bmask[ni,*] eq 1)
           medx[ni]=median(image[ni,goodindx],/even)
         endfor
         coeff=poly_fit(xarr,medx,3)
         medx=poly(xarr,coeff)
         goto,menu
         end

    'y': begin
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           goodindx=where(bmask[*,nj] eq 1)
           medy[nj]=median(image[goodindx,nj],/even)
         endfor
         coeff=poly_fit(yarr,medy,3)
         medy=poly(yarr,coeff)
         goto,menu
         end

    'a': begin
         image=fimage
         bgnd=fltarr(nx,ny)
         for ni=0,nx-1 do begin
           for nj=0,ny-1 do begin
             bgnd[ni,nj]=0.5*(medx[ni]+medy[nj])
           endfor
         endfor
         fimage=image+bgnd
         wdelete,mapwindow
         goto,display_image
         end

    'v': begin
         Print,'   Left Click for low ch boundary [on box on right]'
         cp, x=x, y=y
         xpos1=round(x)
         if (xpos1 lt 0.) then xpos1 = 0.
         wait, 0.5
         Print,'   Left Click for hi  ch boundary'
         cp, x=x, y=y
         xpos2=round(x)
         if (xpos2 ge nx) then xpos2 = nx-1
         wait, 0.5
         for nj=0,ny-1 do begin
           vert[nj]=median(fimage[xpos1:xpos2,nj],/even)
         endfor
         coeff=poly_fit(yarr,vert,3)
         vertfit=poly(yarr,coeff)
         vertres=vert-vertfit
         goto,menu
         end

    'V': begin
         if (lineargs eq '') then begin
           grad_poly=3
         endif else begin
           reads,lineargs,grad_poly
         endelse
         if grad_poly gt 8 then grad_poly=8
         xpos1=0.
         xpos2=nx-1
         for nj=0,ny-1 do begin
           vert[nj]=median(fimage[xpos1:xpos2,nj],/even)
         endfor
         coeff=poly_fit(yarr,vert,grad_poly)
         vertfit=poly(yarr,coeff)
         vertres=vert-vertfit
         image=fimage
         for nj=0,ny-1 do begin
           fimage[*,nj]=fimage[*,nj]-vertres[nj]
         endfor
         wdelete,mapwindow
         goto,display_image
         end

    'i': begin
         wset,mapwindow
         Print,'Select a box in map to the right:'
         print, 'Left click LOWER LEFT corner of box...'
         cp, x=x, y=y
         xpos1=floor(x)
         ypos1=floor(y)
         if (xpos1 lt 0.) then xpos1 = 0.
         if (ypos1 lt 0.) then ypos1 = 0.
         wait, 0.5
         print, 'Left click UPPER RIGHT corner of box...'
         cp, x=x, y=y
         xpos2=round(x)
         ypos2=round(y)
         if (xpos2 gt nx-1) then xpos2=nx-1
         if (ypos2 gt ny-1) then ypos2=ny-1
         for ncgx=xpos1,xpos2 do begin
	     value_low=fimage[ncgx,ypos1]
             value_high=fimage[ncgx,ypos2]
             cggrad=(value_high-value_low)/(ypos2-ypos1)
             for ncgy=ypos1,ypos2 do begin
		distanz=ncgy-ypos1
		interp_value=value_low+cggrad*distanz
                fimage[ncgx,ncgy]=interp_value
             endfor
         endfor
         wdelete,mapwindow
         goto,display_image
         end

    'z': begin
         image=fimage
         for nj=0,ny-1 do begin
           fimage[*,nj]=fimage[*,nj]-vertres[nj]
         endfor
         wdelete,mapwindow
         goto,display_image
         end

    'r': begin
         if (lineargs eq '') then begin
           norder=1
         endif else begin
           reads,lineargs,norder
         endelse
         image=fimage
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           spec1 = reform(image[*,nj])
           mask1 = reform(bmask[*,nj])

           coeffs=flat_robfit_poly(xarr,spec1,norder,nsig=2.0,double=double,$
                      sig=sig,imask=mask1,$
                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           fimage[*,nj]=image[*,nj]-yfit
         endfor
         fit_flag=1
         wdelete,mapwindow
         goto,display_image
         end
 
  
    'f': begin
         if (lineargs eq '') then begin
           norder=1
         endif else begin
           reads,lineargs,norder
         endelse
         image=fimage
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           spec1 = reform(image[*,nj])
           mask1 = reform(bmask[*,nj])
           gindx=where(mask1 eq 1)
           coef=poly_fit(xarr[gindx],spec1[gindx],norder,double=double,$
                status=status,yerror=sig)
           yfit=poly(xarr,coef)
           fimage[*,nj]=image[*,nj]-yfit
         endfor
         fit_flag=1
         wdelete,mapwindow
         goto,display_image
         end

    'm': begin
         if (lineargs eq '') then begin
           nnind=4
         endif else begin
           reads,lineargs,nnind
         endelse
         image=fimage
;        compute a "smooth image"
         simage=image
         for nj=0,ny-1 do begin
           n1=nj-15
           n2=nj+15
           if (n1 lt 0) then n1=0
           if (n2 gt ny-1) then n2=ny-1
           mask=intarr(ny)
           mask[n1:n2]=1
           for ni=0,nx-1 do begin
             ystrip=reform(image[ni,*])
             coeff=poly_fit(yarr[n1:n2],ystrip[n1:n2],4)
             yf=poly(yarr,coeff)
             simage[ni,nj]=yf[nj] 
           endfor
         endfor
;        habemus smooth image
         for nj=0,ny-1 do begin
           avrat=1.
           ind=where(simage[*,nj] gt 8.,nind)
           if (nind le nnind) then goto,nextraster
;          if (total(simage[*,nj]) gt 100.) then $
           avrat=total(image[ind,nj])/total(simage[ind,nj])
           fimage[*,nj]=image[*,nj]/avrat
           nextraster:
         endfor
         wdelete,mapwindow
         goto,display_image
         end

    'X': begin
         if (lineargs eq '') then begin
           norder=1
         endif else begin
           reads,lineargs,norder
         endelse
         ;this is option 'x'
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for ni=0,nx-1 do begin
           goodindx=where(bmask[ni,*] eq 1)
           medx[ni]=median(image[ni,goodindx],/even)
         endfor
         coeff=poly_fit(xarr,medx,3)
         medx=poly(xarr,coeff)
         ;this is option 'y'
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           goodindx=where(bmask[*,nj] eq 1)
           medy[nj]=median(image[goodindx,nj],/even)
         endfor
         coeff=poly_fit(yarr,medy,3)
         medy=poly(yarr,coeff)
         ;this is option 'f' with the correct norder
         imagein=image
         image=fimage
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           spec1 = reform(image[*,nj])
           mask1 = reform(bmask[*,nj])
           gindx=where(mask1 eq 1)
           coef=poly_fit(xarr[gindx],spec1[gindx],norder,double=double,$
                status=status,yerror=sig)
           yfit=poly(xarr,coef)
           fimage[*,nj]=image[*,nj]-yfit
         endfor
         fit_flag=1
         ;finally, this is option 'a'
         image=fimage
         bgnd=fltarr(nx,ny)
         for ni=0,nx-1 do begin
           for nj=0,ny-1 do begin
             bgnd[ni,nj]=0.5*(medx[ni]+medy[nj])
           endfor
         endfor
         fimage=image+bgnd
         image=imagein
         wdelete,mapwindow
         goto,display_image
         end

    'W': begin
         wset,mapwindow
         Print,'Select a box in map to the right:'
         print, 'Left click LOWER LEFT corner of box...'
         cp, x=x, y=y
         xpos1=round(x)
         ypos1=round(y)
         if (xpos1 lt 0.) then xpos1 = 0.
         if (ypos1 lt 0.) then ypos1 = 0.
         wait, 0.5
         print, 'Left click UPPER RIGHT corner of box...'
         cp, x=x, y=y
         xpos2=round(x)
         ypos2=round(y)
         if (xpos2 gt nx-1) then xpos2=nx-1
         if (ypos2 gt ny-1) then ypos2=ny-1
         wait, 0.5
         if (lineargs eq '') then begin
           norder=1
         endif else begin
           reads,lineargs,norder
         endelse
         ;this is option 'x'
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for ni=0,nx-1 do begin
           goodindx=where(bmask[ni,*] eq 1)
           medx[ni]=median(image[ni,goodindx],/even)
         endfor
         coeff=poly_fit(xarr,medx,3)
         medx=poly(xarr,coeff)
         ;this is option 'y'
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           goodindx=where(bmask[*,nj] eq 1)
           medy[nj]=median(image[goodindx,nj],/even)
         endfor
         coeff=poly_fit(yarr,medy,3)
         medy=poly(yarr,coeff)
         ;this is option 'f' with the correct norder
         imagein=image
         image=fimage
         bmask = intarr(nx,ny)+1
         ind=where(total(this_nreg,2) ne 0,nind)
         if (nind ne 0) then begin
           for nnind=0,nind-1 do begin
             llch=this_nreg[ind[nnind],0]
             urch=this_nreg[ind[nnind],2]
             llrec=this_nreg[ind[nnind],1]
             urrec=this_nreg[ind[nnind],3]
             bmask[llch:urch,llrec:urrec]=0
           endfor
         endif
         for nj=0,ny-1 do begin
           spec1 = reform(image[*,nj])
           mask1 = reform(bmask[*,nj])
           gindx=where(mask1 eq 1)
           coef=poly_fit(xarr[gindx],spec1[gindx],norder,double=double,$
                status=status,yerror=sig)
           yfit=poly(xarr,coef)
           for ni=0,nx-1 do begin
               if ni ge xpos1 and ni le xpos2 and nj ge ypos1 and nj le ypos2 $
                      then fimage[ni,nj]=image[ni,nj]-yfit[ni]
           endfor
         endfor
         fit_flag=1
         ;finally, this is option 'a'
         image=fimage
         bgnd=fltarr(nx,ny)
         for ni=0,nx-1 do begin
           for nj=0,ny-1 do begin
             bgnd[ni,nj]=0.5*(medx[ni]+medy[nj])
             if ni ge xpos1 and ni le xpos2 and nj ge ypos1 and nj le ypos2 $
                  then fimage[ni,nj]=image[ni,nj]+bgnd[ni,nj]
           endfor
         endfor
         image=imagein
         wdelete,mapwindow
         goto,display_image
         end

    'c': begin
         end

    's': begin
         image=reform(grid_in.d[nch,np,*,*])
         fimage=image
         wdelete,mapwindow
         goto,display_image
         end

    'S': begin
         print,'... saving...'
         save,grid_out,file='grid_out_flat.sav'
         goto,menu
         end

    'n': begin
         wdelete,mapwindow
         grid_out.d[nch,np,*,*]=fimage
         goto,next_pol
         end

    '' : begin
         wdelete,mapwindow
         grid_out.d[nch,np,*,*]=fimage
         goto,next_pol
         end

    'u': begin
         wdelete,mapwindow
         goto,next_pol
         end

    else: goto,menu
    endcase

    next_pol:
  endfor
  nextchannel:
endfor

check_maps,grid_in,grid_out,nchn
save,grid_out,file='grid_out_flat.sav'

!p.multi=0
hor
ver
end
    
