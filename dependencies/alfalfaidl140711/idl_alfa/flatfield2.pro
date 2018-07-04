;---------------------------------------------------------------------------------------

; SUBROUTINE TO DISPLAY input and flatfielded; RETURNS mapwindow

pro flat_imdisplay,image,fimage,nch,np,mapwindow=mapwindow

nxpx=n_elements(image[*,0])
nypx=n_elements(image[0,*])

iresult=moment(image,sdev=isdev,mdev=imdev)
fresult=moment(fimage,sdev=fsdev,mdev=fmdev)
imean=strtrim(string(iresult[0],format='(f5.2)'))
fmean=strtrim(string(fresult[0],format='(f5.2)'))
isdev=strtrim(string(isdev,format='(f5.2)'))
fsdev=strtrim(string(fsdev,format='(f5.2)'))
iskew=strtrim(string(iresult[2],format='(f6.2)'))
fskew=strtrim(string(fresult[2],format='(f6.2)'))
ikurt=strtrim(string(iresult[3],format='(f6.2)'))
fkurt=strtrim(string(fresult[3],format='(f6.2)'))
imed=strtrim(string(median(image),format='(f5.2)'))
fmed=strtrim(string(median(fimage),format='(f5.2)'))
window,/free,xsize=1024,ysize=500,retain=2
!p.multi=[0,2,1,0,0]
loadct,1
device, decomposed=1
mapwindow=!d.window
imgdisp,image,position=[0.05,0.08,0.48,0.89]
xyouts,0,nypx+10,'Input image'
xyouts,80,nypx+10,'Channel nr '+strtrim(string(nch))+'  Pol '+strtrim(string(np)),$
                 charsize=1.5
xyouts,0,nypx+5,'mean='+imean+'  sdev='+isdev+'  skew='+iskew+'  kurt='+ikurt+$
                 '  med='+imed,charsize=1.2
xyouts,0,-10,'A Production of LOVEDATA, Inc. Ithaca, NY',Size=0.75
imgdisp,fimage,position=[0.54,0.08,0.97,0.89]
xyouts,nxpx-30,nypx+10,'Output image'
xyouts,0,nypx+5,'mean='+fmean+'  sdev='+fsdev+'  skew='+fskew+'  kurt='+fkurt+$
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
  flat_imdisplay,image,fimage,nch,np,mapwindow=mapwindow
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

   print,'You can now :  - activate a no-fit box               (a)'
   print,'               - delete   a no-fit box               (d boxnr)'
   print,'               - fit the map with poly n             (f n)'
   print,'               - apply multiplicative correction     (m)'
   print,'               - check baseline quality              (c rasternr)'
   print,'               - reset and start anew                (r)'
   print,'               - apply and go to next strip/pol      (n or CR)'
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

pro flatfield,grid_in,grid_out

grid_out=grid_in

nchn=n_elements(grid_in.d[*,0,0,0])
nx=n_elements(grid_in.d[0,0,*,0])
ny=n_elements(grid_in.d[0,0,0,*])
npol=2

xarr=findgen(nx)
yarr=findgen(ny)
charr=findgen(nchn)

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

!p.multi=0

norder=0L
nk=0
this_nreg=lonarr(40,4)

for k=0,nindch0-1 do begin
  nch=indch0[k]
  nk=nk+1
  if (nk eq 10) then begin
    print,nch
    nk=0
  endif

  for np=0,npol-1 do begin 
    image=reform(grid_in.d[nch,np,*,*])
    fimage=image
    display_image:
    flat_imdisplay,image,fimage,nch,np,mapwindow=mapwindow

    menu:
    flat_menu,this_nreg,np,nch,line1=line1,lineargs=lineargs

    case strmid(line1,0,1) of

    'a': begin
         ind=where(total(this_nreg,2) eq 0)
         nbox=min(ind)  ;FIRST FREE BOX
         wset,mapwindow
         Print,'Select a box in map:'
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
         abitch=nchn/100
         abitrec=nrec/20
         xyouts,(xpos1+xpos2)/2-abitch,ypos1-abitrec,$
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
  
    'f': begin
         if (lineargs eq '') then begin
           norder=norder
         endif else begin
           reads,lineargs,norder
         endelse
         bmask = intarr(nx,ny)+1
         bmaskrob = intarr(nx,ny)
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
         fmap=fltarr(nx,ny)
         rmsarr=fltarr(nx)
         for nj=0,ny-1 do begin
           spec1 = reform(image[*,nj])
           mask1 = reform(bmask[*,nj])

           coeffs=flat_robfit_poly(xarr,spec1,norder,nsig=2.0,double=double,$
                      sig=sig,imask=mask1,$
                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           fimage[*,nj]=image[*,nj]-yfit
           mask1=lonarr(nx,1)
           mask1[gindx,0]=1
           bmaskrob[*,nr]=mask1[*,0]
           fmap[*,nj]=yfit
           rmsarr[nr]=sig
         endfor
;         print,rmsarr[0:10]
         fit_flag=1
         goto,menu
         end
 
    'm': begin
         end
 
    'c': begin
         end

    'r': begin
         end

    'n': begin
         end

    '' : begin
         end

    else: goto,menu
    endcase

;    GOTO,ZEROPOINT
; Now compute a "smooth image"
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
; habemus smooth image
    for nj=0,ny-1 do begin
      avrat=1.
      ind=where(simage[*,nj] gt 10.,nind)
      if (nind le 4) then goto,nextraster
;      if (total(simage[*,nj]) gt 100.) then $
      avrat=total(image[ind,nj])/total(simage[ind,nj])
      grid_out.d[nch,np,*,nj]=grid_in.d[nch,np,*,nj]/avrat
      nextraster:
    endfor
    GOTO,next_pol

; Now let's reset the zeropoint in an additive correction, to remove
; residual striping
; diff is the derivative in the zero point

    image=reform(grid_out.d[nch,np,*,*])
    ZEROPOINT:
    cimage=image
    for j=0,ny-1 do begin
      mima=median(image[*,j],/even)
      ind=where(image[*,j] gt mima)
      cimage[ind,j]=mima
    endfor
    shim=shift(cimage,0,1)
    diff=reform(total(cimage-shim,1))/ny
    zero=diff[0]
    diff[0]=0.
    diff[1:(ny-1)]=diff[1:(ny-1)]-mean(diff)
    diff[0]=0.
    co=poly_fit(yarr,diff,4)
    yf=poly(yarr,co)
    diff=diff-yf
    add=0.
    simage=image
    for j=1,ny-1 do begin
      add=add+diff[j]
      simage[*,j]=image[*,j]-add
    endfor

    grid_out.d[nch,np,*,*]=simage
    next_pol:
  endfor
  nextchannel:
endfor

check_maps,grid_in,grid_out,nchn

!p.multi=0
hor
ver
end
    