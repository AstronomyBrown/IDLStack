;NAME:
; extract_compute.pro - Finds signals within a single drift and produces a list of candidates 
;
;LAST UPDATE: Aug 15, 2005 by AS
;--------------------------------------------------------------------------------------------------------------

;pro extract_compute,s,cont_tot,cont_pt,pos,SN=snth,SEED=seed,POLSKIP=polskip,SKIP=skip,INTERACT=interact
pro extract_small,mav,x1,x2,y1,y2,nb,source,SN=snth,NREC_MIN=nrec_min


t0=systime(1)

pi=3.141592

sigmin=5.           ;minimum template width investigated
sigmax=40.          ;maximum width
delta_sig=1.        ;step between values
sig_size=ceil((sigmax-sigmin)/delta_sig)

sig_size=10
sigmas=[3,5,7,11,15,20,25,30,35,40]

nst=0
nstop=4095
nch_cut=(nstop-nst)+1

d=size(mav.d,/dimensions)
;nch=d[0]
npol=d[1]
;nrec=d[2]
nbeam=d[3]

nch=x2-x1+1
if ((nch mod 2) ne 0) then nch=nch+1
nrec=y2-y1+1
;nbeam=1

j=nb

gain=10.5
if (j ne 0) then gain=8.5

;gain=replicate(8.5,nbeam)
;gain(0)=10.5

res=fltarr(nch,nrec,nbeam)
warr=fltarr(nch,nrec,nbeam)
farr=fltarr(nch,nrec,nbeam)
parr=fltarr(nch,nrec,nbeam)
narr=fltarr(nch,nrec,nbeam)

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


  mapn=reform(mav[0,y1:y2,j].d[x1:x2])
  stt=sqrt(total(mapn^2)/n_elements(mapn))


;start extracting spectrum by spectrum
  for i=0,nrec-1 do begin

    data=mapn[*,i]

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

;    window,/free,retain=2
    r=poly_fit(sigmas,cmax,5,YFIT=yfit)
;    plot,sigmas,cmax,xtitle='k',ytitle='cmax',psym=1,charsize=2.0
;    oplot,sigmas,yfit


;Calculate the parameters of the model

    bidon=max(cmax,best)

    ;creating temporary parameters
    delta_m=cen(best)+nst
    sigma_m=sigmas[best]
    alpha_m=cmax(best)

    xx=3+findgen(1000)/1000.0*sigmas[sig_size-1]
    yy=r[0]+r[1]*xx+r[2]*xx^2+r[3]*xx^3+r[4]*xx^4+r[5]*xx^5
;    oplot,xx,yy

    bi=max(yy,be)
    sigma_m=xx[be]
;    alpha_m=yy[be]

;    resp=fltarr(nch)
;    temp=1/sqrt((sigma_m*sqrt(pi)))*exp(-(findgen(nch)-(nch/2))^2/(2*sigma_m^2))
;    resp(0:(nch/2-1))=temp((nch/2):nch-1)
;    resp((nch/2):nch-1)=temp(0:(nch/2)-1)
; 
;    fftt=fft(resp)*sqrt(nch)
;    ct=fltarr(nch)
;    ct=fft_d*conj(fftt)
;    fftc=real_part(fft(ct,/INVERSE)/sqrt(nch))
;    cm=max(fftc,nm)
    
;    if (abs(nm-delta_m) gt 10) then begin
       alpha_m=yy[be]
;       delta_m=delta_m
;       print,'Significant difference ',sigma_m
;    endif else begin
;       alpha_m=cm
;       delta_m=nm
;    endelse

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
        f=f+model(y)*5.3   ; assuming 5.3 km/s between channels
    endfor
  

;Calculate the S/N of the detection

    clean=data-model

    min1=(delta_m-nst)-4*sigma_m
    if (min1 lt 0.0) then min1=1.

    max1=(delta_m-nst)+4*sigma_m
    if (max1 gt (nch-1)) then max1=nch-2

    noise=sqrt(total(clean^2)/nch)
    
    sn=peak_m/noise

;here starts the second calculation of S/N - THIS IS THE GOOD ONE!
     w=2.3568*sigma_m*5.3

     if (w lt 200) then begin
        sn2=f/(gain*0.22*sqrt(w/200))
     endif else begin
        sn2=f/(gain*0.22*(w/200))
     endelse


     if ((sn2 gt (2.5)) and (w lt 520)) then begin
;       print,i,j,sn,sn2,delta_m,sigma_m, $
;   format='("Record ",i3," of beam ",i2," has S/N=",f6.2," (",f6.2,")  in channel ",i4," (sig=",f5.2,")")'

       res(delta_m,i,j)=sn2
       warr(delta_m,i,j)=sigma_m
       farr(delta_m,i,j)=f
       parr(delta_m,i,j)=peak_m
       narr(delta_m,i,j)=noise

       data=clean
       goto,dupl
    endif

endfor ;i


;--------------------------------------------------------------------------------
; Let's do some of the analysis here already

;initialize arrays
pol_flag=intarr(nbeam,100)
garr=fltarr(nch,nrec,nbeam)

cnt=0
entry={ch:0,rec:0,w:0.0,asize:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:0,color_pol:'',cz:0.0,agc:'',comments:''}
source=entry


    analyze:
    map=reform(res[*,*,j])

;    comments=strarr(100)
    cnt_det=0
    diff_pol=fltarr(100,4)
    color_pol=strarr(100)

    m=max(map,index)

    dims=size(map,/dimensions)
    ncol=dims[0]
    col_index=index mod ncol
    row_index=index / ncol
      
    profile=fltarr(nrec)

    profile(row_index)=map[col_index,row_index]

    sigma_m=warr[col_index,row_index,j] 
    min2=fix((col_index)-5*sigma_m)
    if (min2 lt 0.0) then min2=1.

    max2=fix((col_index)+5*sigma_m)
    if (max2 gt nch-1) then max2=nch-2

    count=0

;    print,min2,max2
    for i=1,200 do begin

       minrow=row_index-i
       maxrow=row_index+i

       if (minrow lt 0) then begin
        if(max(map[min2:max2,row_index+i]) eq 0.0) then break
        profile(row_index+i)=max(map[min2:max2,row_index+i]) 
        count=count+1
       endif

       if (maxrow gt (nrec-1)) then begin
        if(max(map[min2:max2,row_index-i]) eq 0.0) then break
        profile(row_index-i)=max(map[min2:max2,row_index-i]) 
        count=count+1
       endif

       if ((minrow ge 0) and (maxrow le (nrec-1))) then begin
        if((max(map[min2:max2,row_index+i]) eq 0.0) and (max(map[min2:max2,row_index-i]) eq 0.0)) then break
        profile(row_index+i)=max(map[min2:max2,row_index+i])
        profile(row_index-i)=max(map[min2:max2,row_index-i])
       
        count=count+1
       endif  
    endfor


;put to zero all the values in the region that has just been selected
    min3=row_index-count
    max3=row_index+count
    if(min3 lt 0) then min3=0
    if(max3 gt (nrec-1)) then max3=nrec-1

    map[min2:max2,min3:max3]=fltarr((max2-min2+1),(max3-min3+1))

;now fit a gaussian, plot and record the result
    te= profile gt 0.0
    ind=where(te)

    si=size(ind,/dimension)
    if ((si gt nrec_min)) then begin

     x=indgen(nrec)

     y=gaussfit(x[ind],profile[ind],a,NTERMS=3,CHISQ=chi)
     z=(x-a[1])/a[2]   
     w=a[0]*exp(-z^2/2)

     gfwhm=2.3548*a[2]*15.0/60  ;FWHM in arcminuts
     fwhm=2.3568*warr[col_index,row_index,j]*5.3  ;FWHM in km/s
     wkms=fwhm
     garr[col_index,row_index,j]=gfwhm

;calculating the detection threshold

     if (wkms lt 200) then begin
        fth=0.22*(snth-0.5)*sqrt(wkms/200)
        fthok=0.22*(snth)*sqrt(wkms/200)
     endif else begin
        fth=0.22*(snth-0.5)*(wkms/200)
        fthok=0.22*(snth)*(wkms/200)
     endelse

     if (res[col_index,row_index,j] gt snth) then begin
       source.ch=col_index+x1
       source.rec=row_index+y1
       source.w=2.3568*warr[col_index,row_index,j]*5.3
       source.asize=garr[col_index,row_index,j]
       source.sn=res[col_index,row_index,j]
       source.int_flux=farr[col_index,row_index,j]
       source.peak_flux=parr[col_index,row_index,j]
       source.rms=narr[col_index,row_index,j]
       source.diff_pol=diff_pol[cnt_det]
       source.pol_flag=pol_flag[j,cnt_det]
       source.color_pol=color_pol[cnt_det]
     endif

       cnt_det=cnt_det+1
endif  ;si


end ;procedure
