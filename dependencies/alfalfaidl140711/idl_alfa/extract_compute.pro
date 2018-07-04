;NAME:
; extract_compute.pro - Finds signals within a single drift and produces a list of candidates 
;
;LAST UPDATE: Aug 15, 2005 by AS
;--------------------------------------------------------------------------------------------------------------

pro extract_compute,s,cont_tot,cont_pt,pos,agcdir,SN=snth,SEED=seed,POLSKIP=polskip,SKIP=skip,INTERACT=interact

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

d=size(s.d,/dimensions)
nch=d[0]
npol=d[1]
nrec=d[2]
nbeam=d[3]

;checking the optional keywords
;if (n_elements(snth) eq 0) then snth=3 & print,'Will use S/N limit of 3'
;if (n_elements(skip) eq 0) then skip=0
;if (n_elements(interact) eq 0) then interact=1 & print,'Will use interactive mode'
;if (n_elements(polskip) eq 0) then polskip=1


; read the AGC list
openr,lun,agcdir+'agc.list',/get_lun
agcdata=fltarr(12,19599)
agcname=strarr(19599)
readf,lun,agcdata,format='(i6,2f9.5,2f6.1,6i6,i8)'
point_lun,lun,0
readf,lun,agcname,format='(80x,a9)'
free_lun,lun

swork=s

;Finding the BADBOX file within the POS structure for this drift
index_pos=where(pos.scannumber eq s[0,0,0].h.std.scannumber)
tm=pos.badbox
bb=tm[*,*,*,*,index_pos]

;select the right gain value
gain=replicate(8.5,nbeam)
gain(0)=10.5

;if (skip eq 1) then goto,graph


;initialize matrices to record detections

res=fltarr(nch,nrec,nbeam)
warr=fltarr(nch,nrec,nbeam)
farr=fltarr(nch,nrec,nbeam)
parr=fltarr(nch,nrec,nbeam)
narr=fltarr(nch,nrec,nbeam)

flags=replicate(1,nch,npol,nrec,nbeam)


;initialize kernels for smoothing
;gausav=11
;han=5

;gausskernel=psf_Gaussian(NPIXEL=41, FWHM=gausav,NDIMEN=1, /NORMALIZE)
;if (han eq 1) then hansmo=[1.]
;if (han eq 3) then hansmo=[0.5,1.,0.5]/2.
;if (han eq 5) then hansmo=[0.25,0.75,1.,0.75,0.25]/3.
;if (han eq 7) then hansmo=[0.146,0.5,0.854,1.,0.854,0.5,0.146]/4.



for p=0,1 do begin
;print,'Working on polarisation ',p


for j=0,nbeam-2 do begin

;print,'Starting for beam ',j

;selecting data for that beam
    mapn=reform(s[p,*,j].d)

;replace the regions where there is RFI
    for k=0,99 do begin
        if (total(bb[k,p,j,*],4) ne 0) then begin
            x1=bb[k,p,j,0]
            y1=bb[k,p,j,1]
            x2=bb[k,p,j,2]
            y2=bb[k,p,j,3]
            if (x1 gt x2) then begin
              print,'Box is flipped!'
              tmpx=x1
              x1=x2
              x2=tmpx
            endif
            if (y1 gt y2) then begin
              print,'Box is upside down!'
              tmpy=y1
              y1=y2
              y2=tmpy
            endif
            flags[x1:x2,p,y1:y2,j]=0
        endif
    endfor

    ;flag galactic hydrogen
    flags[3470:3530,p,0:599,j]=0

    ;calculate the standard deviation of the unflagged sections
    ind_good=where(flags[*,p,*,j],count_good)
    stt=sqrt(total(mapn[ind_good]^2)/count_good)
;    print,'Standard deviation is ',stt,' (beam ',j,')'

    ;replacing the flagged sections by noise
    ind_bad=where((flags[*,p,*,j] eq 0),count_bad)
    mapn[ind_bad]=randomn(seed,count_bad)*stt
;    print,'Replaced bad data'

    swork[p,*,j].d=reform(mapn,4096,1,600)

;    msm=swork
;    if (gausav gt 1) then begin
;       for i=0,nch-1 do begin
;         smoothedsample=convol(reform(swork[p,*,j].d[i]), $
;                              gausskernel, /EDGE_TRUNCATE,/NAN,MISSING=0)
;         msm[p,*,j].d[i]=reform(smoothedsample,1,nrec)
;       endfor
;    endif
;    
;    if (han gt 1) then begin
;       for rec=0,nrec-1 do begin
;         smoothedspec = convol(reform(msm[p,rec,j].d),hansmo,$
;                          /edge_truncate,/NAN,MISSING=0)
;         msm[p,rec,j].d = smoothedspec
;       endfor
;    endif

endfor ;j

endfor ;p



;up to now, we have been working on dred, now create msmooth
;need to do this for the two polarizations separately
strip_pv,swork,cont_tot,msm,n1=0,n2=6,showpol=2,gausav=11,han=3,rfimod=0,units=1
print,'Smoothing done'
wdelete,!d.window

;now, average the two polarizations
mav=msm
for j=0,nbeam-2 do begin
  mav[0,*,j].d=0.5*(msm[0,*,j].d+msm[1,*,j].d)
endfor


t1=systime(1)
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

for j=0,nbeam-2 do begin
  print,'Working on beam ',j

  mapn=reform(mav[0,*,j].d)

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
        f=f+model(y)*5.1   ; assuming 5.1 km/s between channels
    endfor
  

;Calculate the S/N of the detection

    clean=data-model[nst:nstop]

    min1=(delta_m-nst)-4*sigma_m
    if (min1 lt 0.0) then min1=1.

    max1=(delta_m-nst)+4*sigma_m
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

     if ((sn2 gt (3.0)) and (w lt 520)) then begin
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

  endfor ;j
endfor ;i


;--------------------------------------------------------------------------------
; Let's do some of the analysis here already

;initialize arrays
pol_flag=intarr(nbeam,100)
garr=fltarr(nch,nrec,nbeam)

cnt=0
entry={sources, ch:0,rec:0,w:0.0,asize:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:0,color_pol:'',cz:0.0,agc:'',comments:''}
sources=replicate(entry,nbeam,100)

mav=msm

for j=0,nbeam-2 do begin
   
    mav[0,*,j].d=(msm[0,*,j].d+msm[1,*,j].d)/2

    analyze:
    map=reform(res[*,*,j])

;    comments=strarr(100)
    cnt_det=0
    diff_pol=fltarr(100,4)
    color_pol=strarr(100)

  for n=1,300 do begin

    m=max(map,index)

    if (m eq 0.0) then break

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
    if ((si gt 10)) then begin

     x=indgen(nrec)

     y=gaussfit(x[ind],profile[ind],a,NTERMS=3,CHISQ=chi)
     z=(x-a[1])/a[2]   
     w=a[0]*exp(-z^2/2)

     gfwhm=2.3548*a[2]*15.0/60  ;FWHM in arcminuts
     fwhm=2.3568*warr[col_index,row_index,j]*5.1  ;FWHM in km/s
     wkms=fwhm
     garr[col_index,row_index,j]=gfwhm

;calculating the detection threshold

     if (wkms lt 200) then begin
        fth=narr[col_index,row_index]/gain(j)*(snth-0.5)*wkms/sqrt(wkms/(2*10.))
        fthok=narr[col_index,row_index]/gain(j)*(snth)*wkms/sqrt(wkms/(2*10.))
     endif else begin
        fth=narr[col_index,row_index]/gain(j)*(snth-0.5)*(wkms)/sqrt(200.0/(2*10.))
        fthok=narr[col_index,row_index]/gain(j)*(snth)*(wkms)/sqrt(200.0/(2*10.))
     endelse


     ; NOTE: the content of farr is in K, has to be converted to Jy!
;     if((farr[col_index,row_index,j]/gain(j)) gt fth) then begin
     if (res[col_index,row_index,j] gt (snth-0.5)) then begin


     ; check if the source appears in both polarisations

        if (polskip eq 1) then goto,skip_pol

        ws=warr[col_index,row_index,j]

        minw=col_index-ws
        maxw=col_index+ws
        if (col_index-ws lt 0) then minw=0
        if (col_index+ws gt nch-1) then maxw=nch-1
        pol0=total(msm[0,row_index,j].d[minw:maxw])/sqrt(2*ws+1)
        pol1=total(msm[1,row_index,j].d[minw:maxw])/sqrt(2*ws+1)

        if (row_index lt 300) then begin
           row=row_index+100
        endif else begin
           row=row_index-100
        end

        stt=sqrt(total(msm[0,row-20:row+20,j].d^2)/(41*nch))
;        print,stt

;        pol0=msm[0,row_index,j].d[col_index]
;        pol1=msm[1,row_index,j].d[col_index]

        sav=0.5*abs(pol0+pol1)
        diff_pol(cnt_det)=abs(pol0-pol1)/stt

        if (sav lt 10*snth*stt) then begin
         if (diff_pol(cnt_det) gt (5)) then begin
            pol_flag(j,cnt_det)=1
            color_pol(cnt_det)='0000FF'XL            
         endif else begin
             if(res[col_index,row_index,j] gt snth) then begin
;             if((farr[col_index,row_index,j]/gain(j)) gt fthok) then begin
              color_pol(cnt_det)='00FF00'XL
             endif else begin
              color_pol(cnt_det)='FFFF00'XL
              pol_flag(j,cnt_det)=2       
             endelse
         endelse

         endif else begin
         print,'Large galaxy'
         if (diff_pol(cnt_det) gt (0.1*sav/stt)) then begin
            pol_flag(j,cnt_det)=1
            color_pol(cnt_det)='0000FF'XL
         endif else begin
             if(res[col_index,row_index,j] gt snth) then begin
;             if((farr[col_index,row_index,j]/gain(j)) gt fthok) then begin
              color_pol(cnt_det)='00FF00'XL
             endif else begin
              color_pol(cnt_det)='FFFF00'XL
              pol_flag(j,cnt_det)=2 
          endelse
        endelse

       endelse

       skip_pol:

       if ((row_index lt 3) or (row_index gt nch-4)) then begin
          pol_flag[j,cnt_det]=3
       endif

       sources[j,cnt_det].ch=col_index
       sources[j,cnt_det].rec=row_index
       sources[j,cnt_det].w=2.3568*warr[col_index,row_index,j]*5.1
       sources[j,cnt_det].asize=garr[col_index,row_index,j]
       sources[j,cnt_det].sn=res[col_index,row_index,j]
       sources[j,cnt_det].int_flux=farr[col_index,row_index,j]
       sources[j,cnt_det].peak_flux=parr[col_index,row_index,j]
       sources[j,cnt_det].rms=narr[col_index,row_index,j]
       sources[j,cnt_det].diff_pol=diff_pol[cnt_det]
       sources[j,cnt_det].pol_flag=pol_flag[j,cnt_det]
       sources[j,cnt_det].color_pol=color_pol[cnt_det]

       cnt_det=cnt_det+1
    endif


    endif  ;si

endfor

t2=systime(1)

endfor

sourcestmp=sources
tcnt=0
for i=0,99 do begin
 if (total(sources[*,i].ch) eq 0) then break
 tcnt=tcnt+1
endfor

sources=sourcestmp[*,0:tcnt]

save,msm,cont_pt,sources,$
 file='./tmp_extract/ext_'+strtrim(string(pos[index_pos].scannumber),2)+'.sav'
print,'Saved temporary files'
ending:

;print,'Preparation time : ',t1-t0
;print,'Computation time : ',t2-t1
;print,'----------------------------'
;print,'Total time : ',t2-t0

end ;procedure
