;NAME:
; extract_compute.pro - Finds signals within a single drift and produces a list of candidates 
;
;LAST UPDATE: Aug 15, 2005 by AS
;--------------------------------------------------------------------------------------------------------------

pro ex3D_s,tav,r1,r2,d1,d2,c1,c2,source,SN=snth,NPIX=npix,AXIS=axis


t0=systime(1)

pi=3.141592

sigmin=5.           ;minimum template width investigated
sigmax=40.          ;maximum width
delta_sig=1.        ;step between values
sig_size=ceil((sigmax-sigmin)/delta_sig)

sig_size=10
sigmas=[3,5,7,11,15,20,25,30,35,40]

d=size(tav,/dimensions)
npol=d[1]

nch=c2-c1+1
if ((nch mod 2) ne 0) then nch=nch+1
nra=r2-r1+1
ndec=d2-d1+1
print,'nch=',nch,d[0]

gain=8.5

res=fltarr(nch,nra,ndec)
warr=fltarr(nch,nra,ndec)
farr=fltarr(nch,nra,ndec)
parr=fltarr(nch,nra,ndec)
narr=fltarr(nch,nra,ndec)

;------------------------------------------------
;Now we can start extracting signals!


;create templates and calculate their FFT

response=fltarr(sig_size,nch)
t=fltarr(sig_size,nch)
fft_t=fltarr(sig_size,nch)

for k=0,sig_size-1 do begin

;  tau=sigmin+k*delta_sig
  tau=sigmas[k]

  t(k,*)=1/sqrt((tau*sqrt(pi)))*exp(-(findgen(nch)-(nch/2))^2/(2*tau^2))

  ;put in wrap-around order
  response(k,0:(nch/2-1))=t(k,(nch/2):nch-1)
  response(k,(nch/2):nch-1)=t(k,0:(nch/2)-1)
 
  fft_t(k,*)=fft(response(k,*))*sqrt(nch)

endfor

stt=0.22 ;put better value in the future

for j=0,ndec-1 do begin

;start extracting spectrum by spectrum
  for i=0,nra-1 do begin

    data=tav[*,0,i,j]

dupl:

;calculate the Fourier transfrom of the data outside of the loop
    fft_d=fft(data)*sqrt(nch)

;initialize arrays
    cmax=fltarr(sig_size)
    cen=intarr(sig_size)

    for k=0,sig_size-1 do begin
     c=fltarr(nch)
;multiply the two Fourier transforms and do the inverse transform
     c=fft_d*conj(fft_t(k,*))
     fft_c=real_part(fft(c,/INVERSE)/sqrt(nch))
     cmax[k]=max(fft_c,n)
     cen[k]=n
    endfor ;k

    r=poly_fit(sigmas,cmax,5,YFIT=yfit)


;Calculate the parameters of the model

    bidon=max(cmax,best)

    ;creating temporary parameters
    delta_m=cen(best)
    sigma_m=sigmas[best]
    alpha_m=cmax(best)

    xx=3+findgen(1000)/1000.0*sigmas[sig_size-1]
    yy=r[0]+r[1]*xx+r[2]*xx^2+r[3]*xx^3+r[4]*xx^4+r[5]*xx^5

    bi=max(yy,be)
    sigma_m=xx[be]
    alpha_m=yy[be]
    peak_m=alpha_m*sqrt(nch)/sqrt(sqrt(pi)*sigma_m)

;Create the model
    model=peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))

;Calculate the total flux of the detection
    f=0.

    min1=delta_m-2*sigma_m
    if (min1 lt 0.0) then min1=1.

    max1=delta_m+2*sigma_m
    if (max1 gt (nch-1)) then max1=nch-2    

    for y=min1,max1 do begin
        f=f+model(y)*5.1   ; assuming 5.1 km/s between channels
    endfor
  

;Calculate the S/N of the detection

    clean=data-model

    min1=(delta_m)-4*sigma_m
    if (min1 lt 0.0) then min1=1.

    max1=(delta_m)+4*sigma_m
    if (max1 gt (nch-1)) then max1=nch-2

    noise=sqrt(total(clean^2)/nch)
    
    sn=peak_m/noise

;here starts the second calculation of S/N - THIS IS THE GOOD ONE!
     w=2.3568*sigma_m*5.1

     if (w lt 200) then begin
        sn2=sn*sqrt(w/(2*10.))  ; 10= spectral res. after 3pt Hanning. sm.
     endif else begin
        sn2=sn*sqrt(200.0/(2*10.))
     endelse

     if ((sn2 gt (2.5)) and (w lt 620)) then begin
;       print,i,j,sn,sn2,delta_m,sigma_m, $
;   format='("RA ",i3," DEC ",i3," has S/N=",f6.2," (",f6.2,")  in channel ",i4," (sig=",f5.2,")")'
       res(delta_m,i,j)=sn2
       warr(delta_m,i,j)=sigma_m
       farr(delta_m,i,j)=f
       parr(delta_m,i,j)=peak_m
       narr(delta_m,i,j)=noise

       data=clean
       goto,dupl
    endif

 endfor   ;i 
endfor ;j


;--------------------------------------------------------------------------------
; Let's do some of the analysis here already

;initialize arrays
pol_flag=intarr(500)
garr=fltarr(nch,nra,ndec)
raarr=fltarr(nch,nra,ndec)
decarr=fltarr(nch,nra,ndec)

cnt=0
entry={ch:0,ra:0,dec:0,w:0.0,ara:0.0,adec:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:0,color_pol:'',cz:0.0,agc:'',comments:''}
source=entry

cnt_det=0
diff_pol=fltarr(100,4)
color_pol=strarr(100)

map=res

 tempmax=fltarr(nch,3) 
 for j=0,nch-1 do begin
   maptmp=reform(map[j,*,*])
   m=max(maptmp,index)
   if (m eq 0.0) then continue  ;SEND THIS TO THE END
   dims=size(maptmp,/dimensions)
   ncol=dims[0]
    col_index=index mod ncol
    row_index=index / ncol
    tempmax(j,0)=m
    tempmax(j,1)=col_index
    tempmax(j,2)=row_index
endfor

 m=max(tempmax[*,0],index)
; if (m eq 0.0 or (m lt (snth))) then goto,ending
 col_index=fix(tempmax[index,1])
 row_index=fix(tempmax[index,2])

 indexch=index

 print,'max: ',m,indexch,col_index,row_index

 profile=replicate(0.1,nra,ndec)

 sigma_m=warr[index,col_index,row_index] 
 minch=fix(indexch-4*sigma_m)
 if (minch lt 0.0) then minch=1.
 maxch=fix(indexch+4*sigma_m)
 if (maxch gt nch-1) then maxch=nch-2


 ;get the size of the search region in RA


if (axis eq 'vel') then begin
 
 sb=0
 mindec=row_index-5
 maxdec=row_index+5
 if (mindec lt 0) then mindec=1
 if (maxdec gt ndec-1) then maxdec=ndec-2
 checkra=reform(total(map[*,*,mindec:maxdec],3))
 countra=0
 for i=1,200 do begin
       minra=col_index-i
       maxra=col_index+i
 
       if (minra-sb lt 0 and maxra+sb le (nra-1)) then begin
        mr1=maxra-sb
        if (mr1 lt 0) then mr1=0
        if(max(checkra[minch:maxch,mr1:maxra+sb]) eq 0.0) then break
        countra=countra+1
       endif

       if (maxra+sb gt (nra-1) and minra-sb ge 0) then begin
        if(max(checkra[minch:maxch,minra-sb:minra+sb]) eq 0.0) then break
        countra=countra+1
       endif

       if ((minra-sb ge 0) and (maxra+sb le (nra-1))) then begin
        if((max(checkra[minch:maxch,maxra-sb:maxra+sb]) eq 0.0) and (max(checkra[minch:maxch,minra-sb:minra+sb]) eq 0.0)) then break
        countra=countra+1
       endif  ;

       if ((minra lt 0) and (maxra gt nra-1)) then break

  endfor
  print,'countra: ',countra
  minra=round(col_index-countra)
  maxra=round(col_index+countra)
  if (minra lt 0) then minra=0
 if (maxra gt nra-1) then maxra=nra-1


 ;get the size of the search region in DEC
 checkdec=reform(total(map[*,minra:maxra,*],2))
 countdec=0
 for i=1,200 do begin
       mindec=row_index-i
       maxdec=row_index+i
       if (mindec lt 0) then mindec=0
       if (maxdec gt ndec-1) then maxdec=ndec-1
       if (mindec-sb lt 0) then begin
        if(max(checkdec[minch:maxch,maxdec-sb:maxdec+sb]) eq 0.0) then break
        countdec=countdec+1
       endif

      if (maxdec+sb gt (ndec-1)) then begin
        if(max(checkdec[minch:maxch,mindec-sb:mindec+sb]) eq 0.0) then break
        countdec=countdec+1
       endif

       if ((mindec-sb ge 0) and (maxdec+sb le (ndec-1))) then begin
        if((max(checkdec[minch:maxch,maxdec-sb:maxdec+sb]) eq 0.0) and (max(checkdec[minch:maxch,mindec-sb:mindec+sb]) eq 0.0)) then break
        countdec=countdec+1
       endif  
   endfor
  print,'countdec : ',countdec
  mindec=round(row_index-countdec)
  maxdec=round(row_index+countdec)
  if (mindec lt 0) then mindec=0
  if (maxdec gt ndec-1) then maxdec=ndec-1

  if (countra+countdec eq 0) then begin
     map[index,col_index,row_index]=0.0
  endif




;store the selected region in the PROFILE array
  for i=minra,maxra do begin
   for k=mindec,maxdec do begin
    profile[i,k]=max(map[minch:maxch,i,k])
   endfor
  endfor

endif ;if axis is vel


if (axis eq 'ra') then begin 
  profile1=fltarr(ndec)
  mindec=d1-d1
  maxdec=d2-d1
  minra=r1-r1
  maxra=r2-r1
  for i=minra,maxra do begin
   for k=mindec,maxdec do begin
    profile[i,k]=max(map[minch:maxch,i,k])
    profile1[k]=max(map[minch:maxch,minra:maxra,k])
   endfor
  endfor
endif ;if axis is ra

if (axis eq 'dec') then begin
  profile1=fltarr(nra)
  minra=r1-r1
  maxra=r2-r1
  mindec=d1-d1
  maxdec=d2-d1
  ;print,minch,maxch,minra,maxra,mindec,maxdec
 for i=minra,maxra do begin
   for k=mindec,maxdec do begin
    profile[i,k]=max(map[minch:maxch,i,k])
    profile1[i]=max(map[minch:maxch,i,mindec:maxdec])
   endfor
  endfor 
endif

;now fit a 2D gaussian, plot and record the result
    te= profile gt 0.2
    ind=where(te)

    si=size(ind,/dimension)
    print,'size: ',si

    if ((si ge npix)) then begin

     print,'I found a galaxy!'
     rawidth=0
     decwidth=0
     racen=0
     deccen=0

     if (si gt 5 and axis eq 'vel') then begin
;       yfit2D=GAUSS2DFIT(profile,a) ;NO TILT ALLOWED AT THE MOMENT
     svs=[double(col_index),double(row_index),double(countra),double(countdec),max(profile)]
     ers=replicate(1.0,nra,ndec)
     wef=replicate(1.0,nra,ndec)
     xra=indgen(nra)
     ydec=indgen(ndec)
     fitparams=MPFIT2DFUN('model_gauss2D',xra,ydec,profile,ers,svs,WEIGHTS=replicate(1.0,nra,ndec),/QUIET)
 
     if (fitparams[0] lt 0) then fitparams[0]=col_index
     if (fitparams[0] gt nra-1) then fitparams[0]=col_index
     if (fitparams[1] lt 0) then fitparams[1]=row_index
     if (fitparams[1] gt ndec-1) then fitparams[1]=row_index
     if (fitparams[2] lt 0) then fitparams[2]=double(countra)
     if (fitparams[3] lt 0) then fitparams[3]=double(countdec)

     racen=fitparams[0]
     deccen=fitparams[1]
     rawidth=fitparams[2]
     decwidth=fitparams[3]

     yfit2D=model_gauss2D(indgen(nra),indgen(ndec),fitparams)

     endif

     if (si le 5 and axis eq 'vel') then begin
      rawidth=0.0
      decwidth=0.0
      racen=col_index
      deccen=row_index
     endif

     
     if (axis eq 'ra' or axis eq 'dec') then begin
      if (axis eq 'ra') then npoints=ndec
      if (axis eq 'dec') then npoints=nra
      ti= profile1 gt 0.0
      ind=where(ti)
      siz=size(ind,/dimension)
      print,siz
      print,ind

      if (siz ge npix and siz gt 3) then begin
       x=indgen(npoints)
       y=gaussfit(x[ind],profile1[ind],a1,NTERMS=3,CHISQ=chi)
       z=(x-a1[1])/a1[2]
       w=a1[0]*exp(-z^2/2)
       rawidth=a1[2]
       decwidth=a1[2]
       racen=col_index
       deccen=row_index
      endif

     if (siz le 3) then begin
       print,'Not enough points to fit.  Will use default values.'
       rawidth=1.
       decwidth=1.
       racen=col_index
       deccen=row_index
     endif
     endif

     rafwhm=2.3548*rawidth*5*15.0/60 ;FWHM in arcminutes
     decfwhm=2.3548*decwidth         ;FWHM in arcminutes
     fwhm=2.3568*warr[indexch,col_index,row_index]*5.1  ;FWHM in km/s
     wkms=fwhm
     raarr[indexch,col_index,row_index]=rafwhm
     decarr[indexch,col_index,row_index]=decfwhm
 ;    print,rafwhm,decfwhm

;        !p.multi=0
;        device, decomposed=0
;        if (si gt 6 and axis eq 'vel') then begin 
;           contour,yfit2D,xrange=[minra,maxra],yrange=[mindec,maxdec]
;        endif

;        if (si le 6) then begin
;           plot,profile[*,0],xrange=[minra,maxra],yrange=[mindec,maxdec],/NODATA
;        endif
;        if (si gt 6 and axis ne 'vel') then begin
;           plot,profile[*,0],xrange=[minra,maxra],yrange=[mindec,maxdec],/NODATA
;        endif


;     for r=0,nra-1 do begin
;       for d=0,ndec-1 do begin
;         if (profile[r,d] gt 0 ) then begin
;             plots,r,d,psym=6
;         endif

;       endfor
;     endfor

;calculating the detection threshold

     w=2.3568*warr[indexch,col_index,row_index]*5.1
     if (wkms lt 200) then begin
        fth=narr[indexch,col_index,row_index]*(snth-0.5)*wkms/sqrt(wkms/(2*10.))
        fthok=narr[indexch,col_index,row_index]*(snth)*wkms/sqrt(wkms/(2*10.))
     endif else begin
        fth=narr[indexch,col_index,row_index]*(snth-0.5)*(wkms)/sqrt(200.0/(2*10.))
        fthok=narr[indexch,col_index,row_index]*(snth)*(wkms)/sqrt(200.0/(2*10.))
     endelse


     if (res[indexch,col_index,row_index] gt snth) then begin
       source.ch=indexch+c1
       source.ra=round(racen)+r1
       source.dec=round(deccen)+d1
       source.w=2.3568*warr[indexch,col_index,row_index]*5.1
       source.ara=raarr[indexch,col_index,row_index]
       source.adec=decarr[indexch,col_index,row_index]
       source.sn=res[indexch,col_index,row_index]
       source.int_flux=farr[indexch,col_index,row_index]
       source.peak_flux=parr[indexch,col_index,row_index]
       source.rms=narr[indexch,col_index,row_index]
       source.diff_pol=diff_pol[cnt_det]
       source.pol_flag=pol_flag[cnt_det]
       source.color_pol=color_pol[cnt_det]
     endif

 endif                          ;si


end                            ;procedure
