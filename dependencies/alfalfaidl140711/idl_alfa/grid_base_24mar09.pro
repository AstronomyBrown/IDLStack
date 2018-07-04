;+
;NAME:
;GRID_BASE
;
;SYNTAX:
;
;pro grid_base, grid_in, grid_out,n1=1,n2=n2,basefile=basefile
;
;
; The input grid_in is a GRID structure, produced by grid_prep. 
; The output grid_out is the input GRID structure, with some parts 
; (baseline,nbase,grms,bregs) modified.
;
; GRID is a structure containing:
; grid={name		str(64), a name for the grid picked by the user
;      RAmin, Decmin	min RA, Dec of grid map [hh.hhhh, dd.dddd]
;      DeltaRA,DeltaDec	grid step in RA (sec of time ) and in Dec (arcmin)
;	NOTE THAT THE GRID POINT WITH THE LOWEST RA,DEC HAS
;	RA=RAmin+DeltaRA/2., Dec=Decmin+DeltaDec/2
;      NX,NY		number of grid point in RA, in Dec
;      map_projection	string, describing the ttype of map projection
;      czmin		velocity of lowest vel channel of grid (km/s)
;      NZ		number of spectral channels in grid
;      velarr		velocity array 
;      wf_type		string(64) describing the type of weight function
;			used to grid
;      wf_fwhm		fwhm of grid function (arcmin)
;      han		int, nr of channels used to hansmooth spectral data
;			(1, 3, 5, 7)
;      medsubtract	if ne 0 then a median has been removed from each drift
;      baseline		structure containing the details of baselining process
;      		.nbase		intarr[2,NY] baseline polynomial order for given dec 
;				strip/pol; all spectra in one dec strip get same order
;		.coeff		double array[2,NX,NY,10] baseline coeffs
;				for each grid pt spectrum; max order=9
;      		.nreg		intarr[2,NY,40,4] boundaries of baseline regions
;				dim=2 		polarization
;				dim=NY		nr of Dec strip of grid points
;				dim=40		up to 40 regions per Dec strip
;				dim=4		llch,ll grid pt inx, urch, ur grid pt in RA of
;						baseline region EXCLUDED from baseline fit
;               .rms            fltarr[2,NX,NY] rms of each spectrum
;      calib_facs	fltarr(2,8,5) poly coeff of fits to conversion factors
;			to go from drift scan spectral units to grid map
;			dim=2 corresponds to polarizations
;			dim=8 corresponds to beam numbers
;			dim=5 corresponds to coeff, e.g. c0, c1, c2, c3, c4,
;				where coeffs refer to fit of conversion factors
;				as a function of time (modified Julian date)
;      grms		rms of spectral values over the whole grid
;      date		string, date when proc run 
;      who		name of person who produced this 
;      pos		pos structure array with all drifts contributing to grid map
;			there are as many array elements as there are drift scans 
;			contributing. Each array element has format:
;		.name		string, name of the drift scan
;		.scannumber	long integer
;		.posang		double, angle of the ALFA array, deg
;		.cenrahr	double, Ra in hrs at center of drift scan
;		.cendecdeg	double, Dec in deg at center of drift scan
;		.AZ0		double, azimuth angle in deg of bm0
;		.ZA0		double, zanith angle in deg of bm 0
;		.rahr		double array[600,8] RA positions of each rec/bm in scan
;		.decdeg		double array[600,8] Dec ositions of each rec/bm in scan
;		.cont		float array[2,600,8] continuum flux at given pol/rec/bm
;		.status		float array[2,600,8] status of given pol/rec/bm
;		.badbox		int array[100,2,8,4] corners of badboxes set by flagbb
;      drift_list	structure array containing list of drifts contributing, w/as many 
;			array elements as drift scans contributing; each record of array is:
;		.name		string, drift scan name
;		.scannumber	long, scan number
;		.cenrahr	double, Ra in hrs at center of drift scan
;		.cendecdeg	double, Dec in deg at center of drift scan
;      grid_makeup      structure array describing grid makeup, with as many elements as
;			there are grid points; each element of array contains:
;		.i		int index of grid pt in ra direction
;		.j		int index of grid pt in dec direction
;		.ra		double RA in hh.hhhhh of grid pt
;		.dec		double Dec in dd.dddd of grid pt
;		.driftname	string array[16} of up to 16 drift scans contributing
;				to flux at this grid pt
;		.scannumber	long array[16] of up to 16 drift scans contributing
;				to flux at this grid pt
;		.startrecnr	long[16,8] first rec in scan contributing to grid pt
;				for given beam
;		.stoprecnr	long[16,8] last rec in scan contributing to grid pt
;				for given beam
;		.date		string
;      d		fltarr[NZ,2,NX,NY] of grid spectral values
;			this IS the data cube
;      w		fltarr[NZ,2,NX,NY] of weights for each sp value
;      cont		fltarr[2,NX,NY] of continuum fluxes
;      cw               fltarr[2,NX,NY] weight of cont map
;
; First writing RG/05Oct05
; Major upgrade RG/29oct05
; Small change made to outer loop and window deletion at end   B. Kent 7Nov05
;
;-------------------------------------------------------------------------------------------
;
;NAME:
;robfit_poly - robust polyfit for 1d array
;SYNTAX:  coef=robfit_poly(x,y,deg,nsig=nsig,double=double,sig=sig,imask=imask,$
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
function  robfit_poly,x,y,deg,nsig=nsig,imask=imask,forcemask=forcemask,$
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

;---------------------------------------------------------------------------------------

pro recompute,grid,grid_out,baseline

; reads the baseline structure and recomputes baselines for all the
; strips for which nbase (and presumably nregions) have been previously set.
; It copies the baselined spectra into grid_out

nrec=grid.nx
nchn=grid.nz
xarr=fltarr(nchn)

indx=where(baseline.nbase[1,*] ne 0,nd)

for nnj=0,nd-1 do begin
  nj=indx[nnj]
  print,'restoring strip ',nj
  for np=0,1 do begin
    image=reform(grid.d[*,np,*,nj])
    this_nreg=reform(baseline.nreg[np,nj,*,*])
    bmask = intarr(nchn,nrec)+1
    bmaskrob = intarr(nchn,nrec)
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
    fmap=fltarr(nchn,1,nrec,1)
    rmsarr=fltarr(nrec)
    for nr=0,nrec-1 do begin
      spec1 = reform(image[*,nr])
      coeffs=reform(baseline.coeffs[np,nr,nj,*])
      fit=poly(xarr,coeffs)
      grid_out.d[*,np,nr,nj]=spec1-fit
    endfor
  endfor
endfor
grid_out.baseline=baseline

end

;---------------------------------------------------------------------------------------

; SUBROUTINE TO DISPLAY spectral data IMAGE AND weight IMAGE; RETURNS mapwindow

pro base_imdisplay,image,wimage,contprof,mapwindow,nj,np,nreg1,forcereg1,decst

nxpx=n_elements(image[0,*])
nchn=n_elements(image[*,0])
SPEC=TOTAL(IMAGE,2)/Nxpx
;window,/free,xsize=1245,ysize=600,retain=2
window,/free,xsize=1024,ysize=700,retain=2
mapwindow=!d.window
!p.multi=[0,3,3,0,0]
loadct,1
device, decomposed=1
plot,contprof,findgen(nxpx),position=[0.925,0.36,0.98,0.95],$  
     xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
plot,[0,1],[0,1],/nodata,xstyle=4,ystyle=4,position=[0.925,0.05,0.98,0.15]
plot,spec,xrange=[0,nchn],yrange=[-4,6],xstyle=1,ystyle=1,$
     position=[0.05,0.05,0.89,0.15]
oplot,intarr(nchn),color='00FF00'XL
xyouts,0,-6,'A Production of LOVEDATA, Inc. Ithaca, NY',Size=0.75
device, decomposed=0
imgdisp,wimage,position=[0.05,0.17,0.89,0.30]
xyouts,0,nxpx+nxpx*0.1,'Strip=' +strtrim(string(nj),2)+'  Pol='+strtrim(string(np),2)+$
                  '   Dec='+decst,Size=1.5
imgdisp,image,position=[0.05,0.36,0.89,0.95],/histeq
;xyouts,0,nxpx+18.,'Strip='+strtrim(string(nj),2),size=1.5
;xyouts,nchn-200,nxpx+18.,'Pol='+strtrim(string(np),2),Size=1.5
device, decomposed=1
       for nb=0,39 do begin
         if (total(nreg1[nb,*],2) ne 0) then begin
          LLch =nreg1[nb,0]
          LLrec=nreg1[nb,1]
          URch =nreg1[nb,2]
          URrec=nreg1[nb,3]
          plots,[LLch,URch],[LLrec,LLrec],linestyle=0,color='00FF00'XL,thick=2
          plots,[LLch,URch],[URrec,URrec],linestyle=0,color='00FF00'XL,thick=2
          plots,[LLch,LLch],[LLrec,URrec],linestyle=0,color='00FF00'XL,thick=2
          plots,[URch,URch],[LLrec,URrec],linestyle=0,color='00FF00'XL,thick=2
          abitrec=nxpx/20
          abitch =nchn/100
          xyouts,(LLch+URch)/2-abitch,LLrec-abitrec,strtrim(string(nb),2),charsize=1.5,color='00FF00'XL
         endif
       endfor
       for nb=0,9 do begin
         if (total(forcereg1[nb,*],2) ne 0) then begin
          LLch =forcereg1[nb,0]
          LLrec=forcereg1[nb,1]
          URch =forcereg1[nb,2]
          URrec=forcereg1[nb,3]
          plots,[LLch,URch],[LLrec,LLrec],linestyle=0,color='0000FF'XL,thick=2
          plots,[LLch,URch],[URrec,URrec],linestyle=0,color='0000FF'XL,thick=2
          plots,[LLch,LLch],[LLrec,URrec],linestyle=0,color='0000FF'XL,thick=2
          plots,[URch,URch],[LLrec,URrec],linestyle=0,color='0000FF'XL,thick=2
          abitrec=nxpx/20
          abitch =nchn/100
          xyouts,(LLch+URch)/2-abitch,LLrec-abitrec,strtrim(string(nb),2),charsize=1.5,color='0000FF'XL
         endif
       endfor

device, decomposed=0

end

;----------------------------------------------------------------------------------

pro base_plot_spec1,xarr,yarr,specwindow,yfit=yfit,recnr=recnr,stripnr=stripnr,$
                    cmask=cmask,gridm=gridm,rms=rms,fit_flag=fit_flag

   ind=where(gridm.i eq recnr and gridm.j eq stripnr,nind)
;   print,nind,stripnr,recnr
   ra=gridm[ind].ra
   dec=gridm[ind].dec
   sign='+'
   if dec lt 0 then sign='-'
   rh=floor(ra)
   dd=floor(dec)
   rm=(ra-rh)*60.
   irm=floor(rm)
   dm=(dec-dd)*60.
   idm=floor(dm)
   rs=(rm-irm)*60.
   ids=round((dm-idm)*60.)
   rast=string(rh,irm,rs,format='(i2,1x,i2.2,1x,f4.1)')
   decst=string(sign,dd,idm,ids,format='(a1,i2.2,1x,i2.2,1x,i2.2)')
   window,/free,xsize=900,ysize=450,xpos=350,ypos=450
   !p.multi=0
   specwindow=!d.window
   nchn=n_elements(xarr)
   device,decomposed=1
   plot,xarr,yarr,yrange=[-10,20],xrange=[0,nchn-1],xstyle=1
   if (n_elements(yfit) ne 0) then oplot,xarr,yfit
   strms=string(rms,format='(f5.2)')
   if (n_elements(recnr) ne 0) then begin 
     xyouts,50,15,'pix '+strtrim(string(recnr),2)+'    RA='+rast+'  Dec='+decst+$
                  '   rms='+strms,charsize=1.5
   endif
   if (n_elements(cmask) gt 0) then begin
     badindx=where(cmask eq 0, nbad)
     if (nbad gt 0) then oplot,xarr[badindx],yarr[badindx],psym=4,color='00FF00'XL
   endif
   if (n_elements(fit_flag) gt 0) then begin
     if (fit_flag eq 0) then xyouts, 150,13.5,'map not fitted yet...(fit is for prev map)'
   endif
   device,decomposed=0
   end

;----------------------------------------------------------------------------------

pro base_nregions,nreg1,np,nj,line1=line1,lineargs=lineargs

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
   print,'               - activate a DO-fit box               (A)'
   print,'               - delete   a DO-fit box               (D boxnr)'
   print,'               - fit the map with poly n             (f n)'
   print,'               - accelerator for f 1                 (g)'
   print,'               - accelerator for f 1, V all chans    (h)'
   print,'               - silent h accel: f1, V all ch/maps   (H)'
   print,'               - special fit: separate set of recs   (s)'
   print,'               - special fit: remove rfi feature     (v)'
   print,'                    (always AFTER f and s!)'
   print,'               - special fit: remove rfi feature     (V)'
   print,'                    (as above, but dont show each spec)'
   print,'               - clear special fits                  (k)'
   print,'               - check baseline quality              (c recnr)'
   print,'               - apply base and go to next strip/pol (n or CR)'
   print,'               - leave unchaged and go to next       (u)
   print,'               - display image after fit             (p)'
   print,'               - display image before fit            (b)'
   print,'               - recomp base from baseline/st        (r)'
   print,'               - partial save of grid_out            (S)'
   print,'               - exit                                (x)'
   line1='string'
   read,'?',line1
   if (line1 eq 'g') then line1='f 1'
   line=strtrim(line1,1) ; remv leading blnks
   itemp=strpos(line1,' ') ; find char nr w 1ast occurrence of blnk
   len=strlen(line1) ; nr of chars in line
   if (itemp ne -1) and((itemp+1) le len) then begin
    lineargs=strmid(line1,itemp+1,len-(itemp)) ; contains args, e.g. 'd 3'
   endif else begin
    lineargs=''
   endelse

end

;----------------------------------------------------------------------------------

pro grid_base,grid_in,grid_out,n1=n1,n2=n2,inbasefile=inbasefile,outbasefile=outbasefile

; baseline is a string filename of a structure saved on disk every time a board
; is processed. IF the program processes only part of the grid file, baseline
; is used to store and recall processed nregions (similar to bb in flagbb)

grid=grid_in
grid_out=grid_in

nchn=grid_in.NZ
xarr=findgen(nchn)
nx =grid_in.NX
nrec=nx
ny =grid_in.NY
baseline=grid_in.baseline

if (n_elements(inbasefile) gt 0) then restore,inbasefile
if (n_elements(outbasefile) eq 0) then outbasefile='outbasefile.sav'

nreg=baseline.nreg
coeffs=baseline.coeffs
nbase=baseline.nbase

; OPEN THE FILE FOR TEMP WRITE OUT OF BASELINED DATA
openw,lun,'tmp_data.dat',/get_lun 

forcereg=intarr(10,4)

if (n_elements(n1) eq 0) then n1=0
if (n_elements(n2) eq 0) then n2=NY-1

nreg=intarr(2,NY,40,4)
this_nreg=intarr(40,4)
prev_nreg=intarr(40,4)

for nj=n1,n2 do begin  ; WE LOOP THROUGH EACH DEC STRIP OF THE GRID
  idd=where(grid.grid_makeup.i eq 0 and grid.grid_makeup.j eq nj)
  dec=grid.grid_makeup[idd].dec
  sign='+'
  if dec lt 0 then sign='-'
  dd=floor(dec)
  dm=(dec-dd)*60.
  idm=floor(dm)
  ids=round((dm-idm)*60.)
  decst=string(sign,dd,idm,ids,format='(a1,i2.2,1x,i2.2,1x,i2.2)')

  for np=0,1 do begin    ; AND SEPARATELY FOR EACH POL
    
    fit_flag=0
    image=reform(grid.d[*,np,*,nj])
    wimage=reform(grid.w[*,np,*,nj])
    contprof=reform(grid.cont[np,*,nj])
    this_nreg=reform(nreg[np,nj,*,*])

    fmap=fltarr(nchn,1,nrec,1)
    smap=fltarr(nchn,1,nrec,1)
    vmap=fltarr(nchn,1,nrec,1)

    display_image:
    if (total(this_nreg) eq 0 and total(prev_nreg) ne 0) then this_nreg=prev_nreg
    base_imdisplay,image,wimage,contprof,mapwindow,nj,np,this_nreg,forcereg,decst

    menu:
    base_nregions,this_nreg,np,nj,line1=line1,lineargs=lineargs

    case strmid(line1,0,1) of

    'u': begin
         baseline=grid_out.baseline
         save,baseline,file=outbasefile
         data=grid_out.d[*,np,*,nj]
         magic_value=0123456789L
         info=size(data)
         info_size=n_elements(info)
         header=[magic_value,np,nj,info_size,info]
         writeu,lun,header
         writeu,lun,data
         wdelete,mapwindow
         goto, Nextmap
         end

    'n': begin
         if (fit_flag eq 0) then begin
           print,'you forgot to fit this map...'
           goto,menu
         endif
         if (n_elements(nnns) ne 0) then begin ; some recs have been baselined separately
           grid_out.d[*,np,sind,nj]=grid_out.d[*,np,sind,nj]-smap[*,0,sind,0]
           grid_out.d[*,np,nsind,nj]=grid_out.d[*,np,nsind,nj]-fmap[*,0,nsind,0]
         endif else begin  ; the 2D baseline is it
           grid_out.d[*,np,*,nj]=grid_out.d[*,np,*,nj]-fmap[*,0,*,0]
         endelse
         if (n_elements(nnnv) gt 0) then $ ;some rfi was fixed
             grid_out.d[vind,np,*,nj]=grid_out.d[vind,np,*,nj] - vmap[vind,0,*,0]
         grid_out.baseline=baseline
         prev_nreg=this_nreg
         forcereg=intarr(10,4)  ; reset this one every time: to be used sparingly!
         save,baseline,file=outbasefile
         data=grid_out.d[*,np,*,nj]
         magic_value=0123456789L
         info=size(data)
         info_size=n_elements(info)
         header=[magic_value,np,nj,info_size,info]
         writeu,lun,header
         writeu,lun,data
         wdelete,mapwindow
         goto, Nextmap
         end

    '' : begin
         if (fit_flag eq 0) then begin
           print,'you forgot to fit this map...'
           goto,menu
         endif
         if (n_elements(nnns) ne 0) then begin ; some recs have been baselined separately
           grid_out.d[*,np,sind,nj]=grid_out.d[*,np,sind,nj]-smap[*,0,sind,0]
           grid_out.d[*,np,nsind,nj]=grid_out.d[*,np,nsind,nj]-fmap[*,0,nsind,0]
         endif else begin  ; the 2D baseline is it
           grid_out.d[*,np,*,nj]=grid_out.d[*,np,*,nj]-fmap[*,0,*,0]
         endelse
         if (n_elements(nnnv) gt 0) then $ ;some rfi was fixed
             grid_out.d[vind,np,*,nj]=grid_out.d[vind,np,*,nj] - vmap[vind,0,*,0]
         grid_out.baseline=baseline
         prev_nreg=this_nreg
         forcereg=intarr(10,4)  ; reset this one every time: to be used sparingly!
;         baseline.nreg[np,nj,*,*]=this_nreg
;         baseline.nbase[np,nj]=norder
         save,baseline,file=outbasefile
         data=grid_out.d[*,np,*,nj]
         magic_value=0123456789L
         info=size(data)
         info_size=n_elements(info)
         header=[magic_value,np,nj,info_size,info]
         writeu,lun,header
         writeu,lun,data
         wdelete,mapwindow
         goto, Nextmap
         end

    'd': begin
         if (lineargs eq '') then goto,menu
         reads,lineargs,nbox
         this_nreg[nbox,*]=0
         wdelete,mapwindow
         goto,display_image
         end

    'D': begin
         if (lineargs eq '') then goto,menu
         reads,lineargs,nbox
         forcereg[nbox,*]=0
         wdelete,mapwindow
         goto,display_image
         end

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
         if (xpos2 gt nchn-1) then xpos2=nchn-1
         if (ypos2 gt nrec-1) then ypos2=nrec-1
         wait, 0.5
         device, decomposed=1
         plots,[xpos1,xpos2],[ypos1,ypos1],color='00FF00'XL,thick=2
         plots,[xpos1,xpos2],[ypos2,ypos2],color='00FF00'XL,thick=2
         plots,[xpos1,xpos1],[ypos1,ypos2],color='00FF00'XL,thick=2
         plots,[xpos2,xpos2],[ypos1,ypos2],color='00FF00'XL,thick=2
         abitch=nchn/100
         abitrec=nrec/20
         xyouts,(xpos1+xpos2)/2-abitch,ypos1-abitrec,strtrim(string(nbox),2),charsize=1.5,color='00FF00'XL
         print,round(xpos1),round(ypos1),round(xpos2),round(ypos2),format='(i4,3(",",i4))'
         this_nreg[nbox,*]=[round(xpos1),round(ypos1),round(xpos2),round(ypos2)]
         goto, menu
         end

    'A': begin
         ind=where(total(forcereg,2) eq 0)
         nbox=min(ind)  ;FIRST FREE BOX
         wset,mapwindow
         Print,'Select a DO-fit box in map:'
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
         if (xpos2 gt nchn-1) then xpos2=nchn-1
         if (ypos2 gt nrec-1) then ypos2=nrec-1
         wait, 0.5
         device, decomposed=1
         plots,[xpos1,xpos2],[ypos1,ypos1],color='0000FF'XL,thick=2
         plots,[xpos1,xpos2],[ypos2,ypos2],color='0000FF'XL,thick=2
         plots,[xpos1,xpos1],[ypos1,ypos2],color='0000FF'XL,thick=2
         plots,[xpos2,xpos2],[ypos1,ypos2],color='0000FF'XL,thick=2
         abitch=nchn/100
         abitrec=nrec/20
         xyouts,(xpos1+xpos2)/2-abitch,ypos1-abitrec,strtrim(string(nbox),2),charsize=1.5,color='0000FF'XL
         print,round(xpos1),round(ypos1),round(xpos2),round(ypos2),format='(i4,3(",",i4))'
         forcereg[nbox,*]=[round(xpos1),round(ypos1),round(xpos2),round(ypos2)]
         goto, menu
         end

    'c': begin
       ; HERE WE CHECK THE BASELINE QUALITY ON A SINGLE SPECTRUM
         if (lineargs eq '') then begin
           wset,mapwindow
           print,'Left click on the map to select the spectrum to display'
           cp,x=x,y=y
           recnr=round(y)
           chnr=round(x)
           if (recnr lt 0) then recnr=0
           if (recnr gt nrec-1) then recnr=nrec-1
         endif else begin
           reads,lineargs,recnr
           recnr=round(recnr)
         endelse
         spec1=reform(image[*,recnr])
         if (n_elements(nnns) eq 0) then begin
           specfit=fmap[*,0,recnr,0]
         endif else begin
           specfit=smap[*,0,recnr,0]
         endelse
         rms=baseline.rms[np,recnr,nj]
         base_plot_spec1,xarr,spec1,yfit=specfit,specwindow,recnr=recnr,stripnr=nj,$
             cmask=reform(bmaskrob[*,recnr]),gridm=grid.grid_makeup,rms=rms,fit_flag=fit_flag
         print,'Hit CR when done inspecting'
         ans=''
         read,ans
         wdelete,specwindow
         wdelete,mapwindow
         goto,display_image
         end        

    'f': begin
         if (lineargs eq '') then begin
           norder=norder
         endif else begin
           reads,lineargs,norder
         endelse
         bmask = intarr(nchn,nrec)+1
         bmaskrob = intarr(nchn,nrec)
         forcemask= intarr(nchn,nrec)
         indf=where(total(forcereg,2) ne 0,nindf)
         if (nindf ne 0) then begin
           for nnindf=0,nindf-1 do begin
             llch=forcereg[indf[nnindf],0]
             urch=forcereg[indf[nnindf],2]
             llrec=forcereg[indf[nnindf],1]
             urrec=forcereg[indf[nnindf],3]
             forcemask[llch:urch,llrec:urrec]=1
           endfor
         endif
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
         fmap=fltarr(nchn,1,nrec,1)
         rmsarr=fltarr(nx)
         for nr=0,nx-1 do begin
           spec1 = reform(image[*,nr])
           mask1 = reform(bmask[*,nr])
           fmask1= reform(forcemask[*,nr])
;           measure_errors=(-(mask1-1.)*1e5+1.D)
;           a=poly_fit(xarr,spec1,norder,yfit=yfit,$
;                      yband=yband,measure_errors=measure_errors,/double)

           coeffs=robfit_poly(xarr,spec1,norder,nsig=2.0,double=double,sig=sig,imask=mask1,$
                      forcemask=fmask1,gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           mask1=lonarr(nchn,1)
           mask1[gindx,0]=1
           bmaskrob[*,nr]=mask1[*,0]
           baseline.nreg[np,nj,*,*]=this_nreg
           baseline.nbase[np,nj]=norder
           baseline.coeffs[np,nr,nj,*]=0.D
           baseline.coeffs[np,nr,nj,0:norder]=coeffs
           baseline.rms[np,nr,nj]=sig
           fmap[*,0,nr,0]=yfit
           rmsarr[nr]=sig
         endfor
;         print,rmsarr[0:10]
         fit_flag=1
         goto,menu
         end

    's': begin
         if (fit_flag eq 0) then begin
           print,'You should take care of 2D fit first...'
           goto,menu
         endif
         print, 'Left click on LOWER record...'
         cp, x=x, y=y
         ypos1=round(y)
         if (ypos1 lt 0.) then ypos1 = 0.
         wait,0.5
         print, 'Left click on UPPER record...'
         cp, x=x, y=y
         ypos2=round(y)
         if (ypos2 gt nrec-1) then ypos2 = nrec-1
         wait,0.5
         yfit=fltarr(nchn)
         for nr=ypos1,ypos2 do begin
           spec1=reform(image[*,nr])
           mask1=reform(bmask[*,nr])   ; this gets run AFTER f, so bmask is defined
           fmask1= reform(forcemask[*,nr])
           askagain:
           yfit=fltarr(nchn)
           base_plot_spec1,xarr,spec1,yfit=yfit,specwindow,recnr=nr,stripnr=nj,$
             cmask=mask1[*],gridm=grid.grid_makeup,rms=0.0
           print,'Enter desired poly order for fit'
           read,this_nfit
           wdelete,specwindow
           coeffs=robfit_poly(xarr,spec1,this_nfit,nsig=2.0,double=double,sig=sig,imask=mask1,$
                      forcemask=fmask1,gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           if (this_nfit eq 0) then yfit=fltarr(nchn)+yfit
           base_plot_spec1,xarr,spec1,yfit=yfit,specwindow,recnr=nr,stripnr=nj,$
             cmask=mask1[*],gridm=grid.grid_makeup,rms=sig
           print,'Happy with fit? (y/n, def=y)'
           ans=''
           read,ans
           wdelete,specwindow
           if (ans eq 'n') then begin
             yfit=fltarr(nchn)
             goto,askagain
           endif
           smap[*,0,nr,0]=yfit
           yfit=fltarr(nchn)
         endfor
         sind=where(total(smap[*,0,*,0],1) ne 0,nnns)
         dummy=intarr(nrec)
         dummy[sind]=1
         nsind=where(dummy eq 0)
         print,sind
         goto,menu
         end

    'v': begin
         if (fit_flag eq 0) then begin
           print,'You should take care of 2D fit first...'
           goto,menu
         endif
         print, 'Left click on LOWER channel...'
         cp, x=x, y=y
         xpos1=round(x)
         if (xpos1 lt 0.) then xpos1 = 0.
         wait,0.5
         print, 'Left click on UPPER channel...'
         cp, x=x, y=y
         xpos2=round(x)
         if (xpos2 gt nchn-1) then xpos2 = nchn-1
         wait,0.5
         rarr=findgen(nrec)
         spec2=fltarr(nrec)
         yfit=fltarr(nrec)
         for nch=xpos1,xpos2 do begin
           if (n_elements(nnns) eq 0) then begin
             spec2=reform(image[nch,*])-reform(fmap[nch,0,*,0])
           endif else begin
             spec2[nsind]=reform(image[nch,nsind])-reform(fmap[nch,0,nsind,0])
             spec2[sind] =reform(image[nch,sind])-reform(smap[nch,0,sind,0])
           endelse
           window,/free,xsize=600,ysize=400,xpos=600,ypos=600
           !p.multi=0
           specwindow=!d.window
           plot,rarr,spec2,xrange=[0,nrec-1],yrange=[min(spec2)-5,max(spec2)+5], $
                           xtitle='Pix nr',xstyle=1
           oplot,rarr,fltarr(nrec),linestyle=1
           xyouts,10,max(spec2)+3,charsize=1.2,'Ch nr = '+strtrim(string(nch),2)+ $
                                  '  Vel = '+strtrim(string(grid.velarr[nch],format='(i5)'),2)+' km/s'
           askagain2:
           print,'Enter desired poly order for fit'
           read,this_nfit
           if (this_nfit eq 99) then begin
             print,'Enter manual offset to be subtracted'
             read,ylevel
             yfit=ylevel
             goto,past_robfit
           endif
;           wdelete,specwindow
           coeffs=robfit_poly(rarr,spec2,this_nfit,nsig=2.0,double=double,sig=sig,$
                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           past_robfit:
           if (this_nfit eq 0 or this_nfit eq 99) then yfit=fltarr(nrec)+yfit
           oplot,rarr,yfit
;           base_plot_spec1,rarr,spec2,yfit=yfit,specwindow,recnr=nrec/2,stripnr=nj,rms=sig,$
;                      gridm=grid.grid_makeup
           print,'Happy with fit? (y/n, def=y)'
           ans=''
           read,ans
;           wdelete,specwindow
           if (ans eq 'n') then begin
             yfit=fltarr(nrec)
             goto,askagain2
           endif
           vmap[nch,0,*,0]=yfit
           yfit=fltarr(nrec)
           wdelete,specwindow
         endfor
         vind=where(total(vmap[*,0,*,0],3) ne 0,nnnv)
         print,vind
         goto,menu
         end


    'V': begin
         if (fit_flag eq 0) then begin
           print,'You should take care of 2D fit first...'
           goto,menu
         endif
         print, 'Left click on LOWER channel...'
         cp, x=x, y=y
         xpos1=round(x)
         if (xpos1 lt 0.) then xpos1 = 0.
         wait,0.5
         print, 'Left click on UPPER channel...'
         cp, x=x, y=y
         xpos2=round(x)
         if (xpos2 gt nchn-1) then xpos2 = nchn-1
         wait,0.5
         rarr=findgen(nrec)
         spec2=fltarr(nrec)
         yfit=fltarr(nrec)
         print,'Enter desired poly order for fit'
         read,this_nfit
         for nch=xpos1,xpos2 do begin
           if (n_elements(nnns) eq 0) then begin
             spec2=reform(image[nch,*])-reform(fmap[nch,0,*,0])
           endif else begin
             spec2[nsind]=reform(image[nch,nsind])-reform(fmap[nch,0,nsind,0])
             spec2[sind] =reform(image[nch,sind])-reform(smap[nch,0,sind,0])
           endelse
           coeffs=robfit_poly(rarr,spec2,this_nfit,nsig=2.0,double=double,sig=sig,$
                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           if (this_nfit eq 0 or this_nfit eq 99) then yfit=fltarr(nrec)+yfit
;           base_plot_spec1,rarr,spec2,yfit=yfit,specwindow,recnr=nrec/2,stripnr=nj,rms=sig,$
;                      gridm=grid.grid_makeup
           vmap[nch,0,*,0]=yfit
           yfit=fltarr(nrec)
         endfor
         vind=where(total(vmap[*,0,*,0],3) ne 0,nnnv)
         print,vind
         goto,menu
         end


    'h': begin
         norder=1
         bmask = intarr(nchn,nrec)+1
         bmaskrob = intarr(nchn,nrec)
         forcemask= intarr(nchn,nrec)
         indf=where(total(forcereg,2) ne 0,nindf)
         if (nindf ne 0) then begin
           for nnindf=0,nindf-1 do begin
             llch=forcereg[indf[nnindf],0]
             urch=forcereg[indf[nnindf],2]
             llrec=forcereg[indf[nnindf],1]
             urrec=forcereg[indf[nnindf],3]
             forcemask[llch:urch,llrec:urrec]=1
           endfor
         endif
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
         fmap=fltarr(nchn,1,nrec,1)
         rmsarr=fltarr(nx)
         for nr=0,nx-1 do begin
           spec1 = reform(image[*,nr])
           mask1 = reform(bmask[*,nr])
           fmask1= reform(forcemask[*,nr])
;           measure_errors=(-(mask1-1.)*1e5+1.D)
;           a=poly_fit(xarr,spec1,norder,yfit=yfit,$
;                      yband=yband,measure_errors=measure_errors,/double)

           coeffs=robfit_poly(xarr,spec1,norder,nsig=2.0,double=double,sig=sig,imask=mask1,$
                      forcemask=fmask1,gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           mask1=lonarr(nchn,1)
           mask1[gindx,0]=1
           bmaskrob[*,nr]=mask1[*,0]
           baseline.nreg[np,nj,*,*]=this_nreg
           baseline.nbase[np,nj]=norder
           baseline.coeffs[np,nr,nj,*]=0.D
           baseline.coeffs[np,nr,nj,0:norder]=coeffs
           baseline.rms[np,nr,nj]=sig
           fmap[*,0,nr,0]=yfit
           rmsarr[nr]=sig
         endfor
;         print,rmsarr[0:10]
         fit_flag=1

         rarr=findgen(nrec)
         spec2=fltarr(nrec)
         yfit=fltarr(nrec)
         this_nfit=1
         for nch=0,nchn-1 do begin
           if (n_elements(nnns) eq 0) then begin
             spec2=reform(image[nch,*])-reform(fmap[nch,0,*,0])
           endif else begin
             spec2[nsind]=reform(image[nch,nsind])-reform(fmap[nch,0,nsind,0])
             spec2[sind] =reform(image[nch,sind])-reform(smap[nch,0,sind,0])
           endelse
           coeffs=robfit_poly(rarr,spec2,this_nfit,nsig=2.0,double=double,sig=sig,$
                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           if (this_nfit eq 0 or this_nfit eq 99) then yfit=fltarr(nrec)+yfit
;           base_plot_spec1,rarr,spec2,yfit=yfit,specwindow,recnr=nrec/2,stripnr=nj,rms=sig,$
;                      gridm=grid.grid_makeup
           vmap[nch,0,*,0]=yfit
           yfit=fltarr(nrec)
         endfor
         vind=where(total(vmap[*,0,*,0],3) ne 0,nnnv)
;        print,vind
         wdelete,mapwindow
         imagef=image
         if (n_elements(nnns) eq 0) then begin
           imagef=imagef-reform(fmap[*,0,*,0])
         endif else begin
           imagef[*,nsind]=imagef[*,nsind]-reform(fmap[*,0,nsind,0])
           imagef[*,sind] =imagef[*,sind]-reform(smap[*,0,sind,0])
         endelse
         if (n_elements(nnnv) gt 0) then imagef[vind,*]=imagef[vind,*]-reform(vmap[vind,0,*,0])
         base_imdisplay,imagef,wimage,contprof,mapwindow,nj,np,this_nreg,forcereg,decst
         goto,menu
         end

    'H': begin
         goto, silent_h   ; that is outside of all loops
         end

    'k': begin
         smap=fltarr(nchn,1,nrec,1)
         vmap=fltarr(nchn,1,nrec,1)
         goto,menu
         end

    'b': begin
         wdelete,mapwindow
         goto,display_image
         end

    'p': begin
         wdelete,mapwindow
         imagef=image
         if (n_elements(nnns) eq 0) then begin
           imagef=imagef-reform(fmap[*,0,*,0])
         endif else begin
           imagef[*,nsind]=imagef[*,nsind]-reform(fmap[*,0,nsind,0])
           imagef[*,sind] =imagef[*,sind]-reform(smap[*,0,sind,0])
         endelse
         if (n_elements(nnnv) gt 0) then imagef[vind,*]=imagef[vind,*]-reform(vmap[vind,0,*,0])
         base_imdisplay,imagef,wimage,contprof,mapwindow,nj,np,this_nreg,forcereg,decst
         goto,menu
         end

    'r': begin
         ans=''
         if (n_elements(inbasefile) eq 0) then begin
           print,'You did not input inbasefile: go ahead anyway?'
           read,ans
           if (ans eq 'n' or ans eq 'N') then begin
             ans2=''
             print,'exit then?'
             read,ans2
             if (ans2 eq 'y' or ans2 eq 'Y') then goto,closing
           endif
           goto,menu
         endif
         print,'Enter name of temp data file (if still tmp_data.dat, RENAME IT!!)'
         tmpfilename=''
         read,tmpfilename
         grid_out.baseline=baseline
         openr,lun2,tmpfilename,/get_lun
         while (eof(lun2) ne 1) do begin
           magic_value=0L
           readu,lun2,magic_value
           swap_flag=0
           if (magic_value ne 123456789L) then begin
             magic_value=swap_endian(magic_value)
             if (magic_value ne 123456789L) then begin
               swap_flag =1 
             endif else begin
               message,'problem with byte swapping'
             endelse
           endif
           info_size=0L
           inp_np=0L
           inp_nj=0L
           info_size=0L
           readu,lun2,inp_np
           readu,lun2,inp_nj
           print,inp_np,inp_nj
           readu,lun2,info_size
           info=lonarr(info_size)
           readu,lun2,info
           if swap_flag then info=swap_endian(info)
           data=make_array(size=info)
           readu,lun2,data
           if swap_flag then data=swap_endian(temporary(data))
           grid_out.d[*,inp_np,*,inp_nj]=data
         endwhile
         free_lun,lun2
;         recompute,grid_in,grid_out,baseline
         goto,menu
         end

    'S': begin
         print,'... saving...'
         save,grid_out,file='grid_out.sav'
         goto,menu
         end

    'x': begin
         goto,closing
         end



    else: goto,menu
    endcase

   Nextmap:
  endfor ; close np loop
endfor   ; closes nj loop

silent_h:

IF (line1 eq 'H') then begin  ; you're processing "silent h" for full grid
  print,' Processing: f 1, V all chans, for all maps of the grid....'
  norder=1
  stripnr=0
; See if user want to skip range of channels
  vskip=intarr(nchn)+1
  Print,'V-skip range of channels? [y/n, def=n]'
  vans=''
  read,vans
  if (vans eq 'y' or vans eq 'Y') then begin
         choose_vrange:
         print, 'Left click on LOWER channel of range...'
         cp, x=x, y=y
         xpos1=round(x)
         if (xpos1 lt 0.) then xpos1 = 0.
         wait,0.5
         print, 'Left click on UPPER channel of range...'
         cp, x=x, y=y
         xpos2=round(x)
         if (xpos2 gt nchn-1) then xpos2=nchn-1
         vskip[xpos1:xpos2]=0
         print,' ....... another range? [y/n,def=n]'
         vvans=''
         read,vvans
         if (vvans eq 'y' or vvans eq 'Y') then goto,choose_vrange
  endif

  for nj=n1,n2 do begin  ; WE LOOP THROUGH EACH DEC STRIP OF THE GRID
    stripnr=stripnr +1
    if (stripnr eq 10) then begin
      print,' Done with strip ',nj
      stripnr=0
    endif
    for np=0,1 do begin    ; AND SEPARATELY FOR EACH POL

      image=reform(grid.d[*,np,*,nj])
      wimage=reform(grid.w[*,np,*,nj])
      contprof=reform(grid.cont[np,*,nj])
      this_nreg=reform(nreg[np,nj,*,*])

      fmap=fltarr(nchn,1,nrec,1)
      smap=fltarr(nchn,1,nrec,1)
      vmap=fltarr(nchn,1,nrec,1)
 
      bmask = intarr(nchn,nrec)+1
      bmaskrob = intarr(nchn,nrec)
      forcemask= intarr(nchn,nrec)
      indf=where(total(forcereg,2) ne 0,nindf)
         if (nindf ne 0) then begin
           for nnindf=0,nindf-1 do begin
             llch=forcereg[indf[nnindf],0]
             urch=forcereg[indf[nnindf],2]
             llrec=forcereg[indf[nnindf],1]
             urrec=forcereg[indf[nnindf],3]
             forcemask[llch:urch,llrec:urrec]=1
           endfor
         endif
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
         fmap=fltarr(nchn,1,nrec,1)
         rmsarr=fltarr(nx)
         for nr=0,nx-1 do begin
           spec1 = reform(image[*,nr])
           mask1 = reform(bmask[*,nr])
           fmask1= reform(forcemask[*,nr])
;           measure_errors=(-(mask1-1.)*1e5+1.D)
;           a=poly_fit(xarr,spec1,norder,yfit=yfit,$
;                      yband=yband,measure_errors=measure_errors,/double)

           coeffs=robfit_poly(xarr,spec1,norder,nsig=2.0,double=double,sig=sig,imask=mask1,$
                      forcemask=fmask1,gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           mask1=lonarr(nchn,1)
           mask1[gindx,0]=1
           bmaskrob[*,nr]=mask1[*,0]
           baseline.nreg[np,nj,*,*]=this_nreg
           baseline.nbase[np,nj]=norder
           baseline.coeffs[np,nr,nj,*]=0.D
           baseline.coeffs[np,nr,nj,0:norder]=coeffs
           baseline.rms[np,nr,nj]=sig
           fmap[*,0,nr,0]=yfit
           rmsarr[nr]=sig
         endfor
;         print,rmsarr[0:10]
         fit_flag=1

         rarr=findgen(nrec)
         spec2=fltarr(nrec)
         yfit=fltarr(nrec)
         this_nfit=1
         for nch=0,nchn-1 do begin
           if (vskip[nch] eq 0) then continue
           if (n_elements(nnns) eq 0) then begin
             spec2=reform(image[nch,*])-reform(fmap[nch,0,*,0])
           endif else begin
             spec2[nsind]=reform(image[nch,nsind])-reform(fmap[nch,0,nsind,0])
             spec2[sind] =reform(image[nch,sind])-reform(smap[nch,0,sind,0])
           endelse
           coeffs=robfit_poly(rarr,spec2,this_nfit,nsig=2.0,double=double,sig=sig,$
                      gindx=gindx,ngood=ngood,bindx=bindx,nbad=nbad,$
                      fpnts=fpnts,iter=iter,yfit=yfit,maxiter=20)
           if (this_nfit eq 0 or this_nfit eq 99) then yfit=fltarr(nrec)+yfit
;           base_plot_spec1,rarr,spec2,yfit=yfit,specwindow,recnr=nrec/2,stripnr=nj,rms=sig,$
;                      gridm=grid.grid_makeup
           vmap[nch,0,*,0]=yfit
           yfit=fltarr(nrec)
         endfor
         vind=where(total(vmap[*,0,*,0],3) ne 0,nnnv)
;        print,vind

         if (n_elements(nnns) ne 0) then begin ; some recs have been baselined separately
           grid_out.d[*,np,sind,nj]=grid_out.d[*,np,sind,nj]-smap[*,0,sind,0]
           grid_out.d[*,np,nsind,nj]=grid_out.d[*,np,nsind,nj]-fmap[*,0,nsind,0]
         endif else begin  ; the 2D baseline is it
           grid_out.d[*,np,*,nj]=grid_out.d[*,np,*,nj]-fmap[*,0,*,0]
         endelse
         if (n_elements(nnnv) gt 0) then $ ;some rfi was fixed
             grid_out.d[vind,np,*,nj]=grid_out.d[vind,np,*,nj] - vmap[vind,0,*,0]
         grid_out.baseline=baseline
         prev_nreg=this_nreg
         forcereg=intarr(10,4)  ; reset this one every time: to be used sparingly!

    endfor
  endfor
  wdelete,mapwindow
endif

closing:
!p.multi=0
print, 'Successful Completion.  Saving...'
save,grid_out,file='grid_out.sav'

end

