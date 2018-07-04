;NAME:
; ex3D_c.pro - Finds signals within a 3D tile and produces a list of candidates 
;
;LAST UPDATE: Dec.7, 2005 by AS
;
;MODIFICATION HISTORY:
;Nov. 10, 2005 (BK) - Small change to erase windows instead of deleting
;Dec. 7, 2005 (AS) - Changed the function that does the 2D gaussian fitting
;Jul. 28, 2006 (AS) - New calculation of the rms when a detection is
;                     made in the first part of the program.  Instead
;                     of calculating the rms of the noise over the
;                     spectrum minus template, the program now uses a
;                     "channel rms"  (i.e. the rms over all the
;                     records at the frequency and dec of the
;                     detection).  This solves in good part the problem of the
;                     countless spurious detections in the regions of
;                     the maps with lower weights.
;
;                   - Also changed the criteria for rejection of
;                     candidates based on polarisations.  Now will
;                     accept more things in the catalog, but will put
;                     a comment "pol.diff." for the cases that have
;                     some difference between the 2 polarisations, but
;                     not in a dramatic way.
;--------------------------------------------------------------------------------------------------------------


;===============================================================
;FUNCTION MODEL_GAUSS2D
;===============================================================

FUNCTION  model_gauss2D, x, y, parameter

nx=n_elements(x)
ny=n_elements(y)
z=fltarr(nx,ny)

for i=0,nx-1 do begin
 for j=0,ny-1 do begin
  exponent=0.5D0*((x[i]-parameter[0])^2/(parameter[2]^2)+(y[j]-parameter[1])^2/(parameter[3]^2))
  z[i,j]=parameter[4]*exp(-exponent)
 endfor
endfor
return,z

END


;===============================================================
;FUNCTION HERMITE
;===============================================================

pro hermite,nch,template,sigmas,peakt,hf,chp

numfunc=10
hcoeff=dblarr(numfunc,numfunc)
hcoeff[1,1]=1.
hcoeff[2,2]=sqrt(2.)
for n=1,numfunc-3 do begin
    hcoeff[n+2,1]=-sqrt(n/float(n+1))*hcoeff[n,1]
    for m=1,n+1 do hcoeff[n+2,m+1]=sqrt(2/float(n+1))*hcoeff[n+1,m]- $
      sqrt(n/float(n+1))*hcoeff[n,m+1]
endfor

x=double(findgen(nch))-nch/2.

a=[1,3]
nterm=n_elements(a)

s=double(15.)
w=double(5.)

h=dblarr(nterm,nch)
for i=0,nterm-1 do begin
    n=a[i]
    h[i,*]=exp(-0.5*(x/s)^2)*(hcoeff[n,1]+hcoeff[n,3]*(x/s)^2)/sqrt(s*sqrt(!pi))
endfor

c=dblarr(nch)
c[nch/2-floor(s*w/2.):nch/2+floor(s*w/2.)]=replicate(1.,(2*floor(s*w/2.)+1))

ch=dblarr(nterm)
for i=0,nterm-1 do ch[i]=total(h[i,*]*c)
nrm=sqrt(ch[0]^2+ch[1]^2)
ch=ch/nrm

t=dblarr(nch)
for i=0,nterm-1 do t=t+ch[i]*h[i,*]

sigmas=[3,4,5,7,8,9,10,11,12.5,14,16,18,20,22,25,27,30]
sig_size=n_elements(sigmas)

chp=fltarr(nterm,sig_size)
chp[0,0:2]=replicate(1.,3)
chp[0,7:(sig_size-1)]=replicate(ch[0],(sig_size-7))
chp[1,7:(sig_size-1)]=replicate(ch[1],(sig_size-7))
chp[0,3]=0.8*(1-ch[0])+ch[0]
chp[0,4]=0.6*(1-ch[0])+ch[0]
chp[0,5]=0.4*(1-ch[0])+ch[0]
chp[0,6]=0.2*(1-ch[0])+ch[0]
chp[1,3]=sqrt(1-chp[0,3]^2)
chp[1,4]=sqrt(1-chp[0,4]^2)
chp[1,5]=sqrt(1-chp[0,5]^2)
chp[1,6]=sqrt(1-chp[0,6]^2)

template=dblarr(sig_size,nch)
sig_t=fltarr(sig_size)
fwhm=fltarr(sig_size)
peakt=fltarr(sig_size)

hf=dblarr(2,sig_size,nch)
for i=0,sig_size-1 do begin
    s=sigmas[i]
    hf[0,i,*]=exp(-0.5*(x/s)^2)*(hcoeff[1,1]+hcoeff[1,3]*(x/s)^2)/sqrt(s*sqrt(!pi))
    hf[1,i,*]=exp(-0.5*(x/s)^2)*(hcoeff[3,1]+hcoeff[3,3]*(x/s)^2)/sqrt(s*sqrt(!pi))
    template[i,*]=chp[0,i]*hf[0,i,*]+chp[1,i]*hf[1,i,*]

    peak=max(template[i,*])
    index=where(template[i,*] gt peak/2.)
    fwhm[i]=2*((nch/2)-index[0])
    peakt[i]=peak
endfor

sigmas=fwhm

end

;===============================================================
;FUNCTION GAUSS_TEMPLATE
;===============================================================

pro gauss_template,nch,fft_gtempl,sig_gtempl,sig_size_gtempl

sig_gtempl=[3,5,7,11,15,20,25,30,35,40,45,50]
sig_size_gtempl=n_elements(sig_gtempl)
maxwidth=620.0

response=fltarr(sig_size_gtempl,nch)
t=fltarr(sig_size_gtempl,nch)
fft_gtempl=fltarr(sig_size_gtempl,nch)

for k=0,sig_size_gtempl-1 do begin
  tau=sig_gtempl[k]
  t(k,*)=1/sqrt((tau*sqrt(!pi)))*exp(-(findgen(nch)-(nch/2))^2/(2*tau^2))    

  ;put in wrap-around order
  response(k,0:(nch/2-1))=t(k,(nch/2):nch-1)
  response(k,(nch/2):nch-1)=t(k,0:(nch/2)-1)
                                                                                                                   
  fft_gtempl(k,*)=fft(response(k,*))*sqrt(nch)
endfor

end


;===============================================================
;MAIN PROGRAM
;===============================================================

pro ex3Dh_c,gr,sources,res,SN=snth,GALHI=galHI

if (n_elements(galHI) eq 0) then begin
galHI_menu:
ans='n'
read,'Does this Data Cube contain Galactic HI? (y/n) : ',ans
            case strtrim(ans,2) of
                 'y': begin
                       galHI='yes'
                      end
                 'n': begin
                       galHI='no'
                      end
                  else: begin
                         print,'I dont understand your answer! Please try again!'
                         goto,galHI_menu
                        end
             endcase
endif

t0=systime(1)

pi=3.141592

;sigmin=5.           ;minimum template width investigated
;sigmax=40.          ;maximum width
;delta_sig=1.        ;step between values
;sig_size=ceil((sigmax-sigmin)/delta_sig)

;sig_size=12
;sigmas=[3,5,7,11,15,20,25,30,35,40,45,50]
maxwidth=620.0

d=size(gr.d,/dimensions)
nch=d[0]
npol=d[1]
nra=d[2]
ndec=d[3]

;print,nch,npol,nra,ndec

;initialize matrices to record detections
res=fltarr(nch,nra,ndec)
warr=fltarr(nch,nra,ndec)
farr=fltarr(nch,nra,ndec)
parr=fltarr(nch,nra,ndec)
narr=fltarr(nch,nra,ndec)

;average the two polarizations
tav=gr.d
tav[*,0,*,*]=0.5*(gr.d[*,0,*,*]+gr.d[*,1,*,*])

;tav=tav[0:599,*,*,*]
;nch=600
;print,size(tav,/dimensions)

maxweight=max(gr.w)
;print,'The maximum weight in this grid is: ',strtrim(string(maxweight),2)

t1=systime(1)
;------------------------------------------------
;Now we can start extracting signals!

;window,/free,retain=2,xsize=800,ysize=800

;create templates and calculate their FFT

hermite,nch,template,sigmas,peakt
if (galHI eq 'yes') then gauss_template,nch,fft_gtempl,sig_gtempl,sig_size_gtempl

sig_size=n_elements(sigmas)

response=fltarr(sig_size,nch)
t=template
fft_t=fltarr(sig_size,nch)

for k=0,sig_size-1 do begin
  ;put in wrap-around order
  response(k,0:(nch/2-1))=t(k,(nch/2):nch-1)
  response(k,(nch/2):nch-1)=t(k,0:(nch/2)-1)
 
  fft_t(k,*)=fft(response(k,*))*sqrt(nch)
endfor

for j=0,ndec-1 do begin
  if ((j mod 10) eq 0) then print,'Working on DEC line ',j

;start extracting spectrum by spectrum
  for i=0,nra-1 do begin

    data=tav[*,0,i,j]
    firstpass=1

dupl:

;calculate the Fourier transfrom of the data outside of the loop
    fft_d=fft(data)*sqrt(nch)

;NEW 19/09/2006: Need a special case with purely gaussian templates
;for galactic HI, so will have two big if cases

    if (galHI eq 'yes' and firstpass eq 1) then begin
  
    fitgalHI=gaussfit(findgen(nch),data,NTERMS=3)
    data=data-fitgalHI
    firstpass=0
    goto,dupl

    cmax=fltarr(sig_size_gtempl)
    cen=intarr(sig_size_gtempl)

    for k=0,sig_size_gtempl-1 do begin
     c=fltarr(nch)
;multiply the two Fourier transforms and do the inverse transform
     c=fft_d*conj(fft_gtempl(k,*))
     fft_c=real_part(fft(c,/INVERSE)/sqrt(nch))
     cmax[k]=max(fft_c,n)
     cen[k]=n
    endfor ;k

    r=poly_fit(sig_gtempl,cmax,5,YFIT=yfit)

    plot,sig_gtempl,cmax,xtitle='k',ytitle='cmax',psym=1,charsize=2.0
;    print,sig_gtempl
;    print,cmax
;    device,decomposed=1


;Calculate the parameters of the model
                                                                                                                   
    bidon=max(cmax,best)
                                                                                                                   
    ;creating temporary parameters
    delta_m=cen(best)
    sigma_m=sigmas[best]
    alpha_m=cmax(best)
                                                                                                                   
    xx=3+findgen(1000)/1000.0*sigmas[sig_size-1]
    yy=r[0]+r[1]*xx+r[2]*xx^2+r[3]*xx^3+r[4]*xx^4+r[5]*xx^5
    oplot,xx,yy,color='FF0000'XL
    wait,0.2

    bi=max(yy,be)
    sigma_m=xx[be]
    alpha_m=yy[be]
    peak_m=alpha_m*sqrt(nch)/sqrt(sqrt(pi)*sigma_m)

    plot,data;,yrange=[-5,10]
    device,decomposed=1
    oplot,indgen(nch),replicate(peak_m,nch),color='FF0000'XL,linestyle=2

    firstpass=0


    endif else begin ;case for non galHI begins
  
;initialize arrays
    cmax=fltarr(sig_size)
    cen=intarr(sig_size)

    for k=0,sig_size-1 do begin
     c=fltarr(nch)
     c=fft_d*conj(fft_t(k,*)) ;multiply the two Fourier transforms and do the inverse transform
     fft_c=real_part(fft(c,/INVERSE)/sqrt(nch))
     cmax[k]=max(fft_c,n)
     cen[k]=n
    endfor ;k

;    window,/free,retain=2
    r=poly_fit(sigmas,cmax,8,YFIT=yfit)
    rp=poly_fit(sigmas,peakt,8,YFIT=yfitp)

;    plot,sigmas,cmax,xtitle='k',ytitle='cmax',psym=1,charsize=2.0
;    print,sigmas
;    print,cmax
;    device,decomposed=1


;Calculate the parameters of the model

    bidon=max(cmax,best)

    ;creating temporary parameters
    delta_m=cen(best)
    sigma_m=sigmas[best]/2.
    alpha_m=cmax(best)

    xx=sigmas[0]+findgen(1000)/1000.0*sigmas[sig_size-1]  ; ESSAYER DE REMPLACER 3. PAR sigmas[0]
    yy=r[0]+r[1]*xx+r[2]*xx^2+r[3]*xx^3+r[4]*xx^4+r[5]*xx^5+r[6]*xx^6+r[7]*xx^7+r[8]*xx^8
    zz=rp[0]+rp[1]*xx+rp[2]*xx^2+rp[3]*xx^3+rp[4]*xx^4+rp[5]*xx^5+rp[6]*xx^6+rp[7]*xx^7+rp[8]*xx^8
;    oplot,xx,yy,color='FF0000'XL
;    wait,0.2

    bi=max(yy,be)
    sigma_m=xx[be]/2.
    alpha_m=yy[be]
    peak_p=zz[be]

    peak_m=alpha_m*peak_p*sqrt(nch)


;    plot,data;,yrange=[-5,10]
;    device,decomposed=1
;    oplot,indgen(nch),replicate(peak_m,nch),color='FF0000'XL,linestyle=2

    endelse  ;finish the general case


;Create the model
    model=peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))
 ;   oplot,indgen(nch),model,color='0000FF'XL
 ;   wait,0.4

;Calculate the total flux of the detection
    f=0.

    min1=delta_m-round(sigma_m)
    if (min1 lt 0.0) then min1=1.

    max1=delta_m+round(sigma_m)
    if (max1 gt (nch-1)) then max1=nch-2    

    for y=min1,max1 do begin
        f=f+data(y)*5.1   ; assuming 5.1 km/s between channels
    endfor
  

;Calculate the S/N of the detection

    clean=data-model 

    ind_nogalHI=where(abs(gr.velarr) gt 200.)
    nogalHI=data(ind_nogalHI)
    size_nogalHI=n_elements(nogalHI)

    noise=sqrt(total(nogalHI^2)/size_nogalHI)
    noiseold=noise

    sn=peak_m/noise

;new calculation, with a best estimate of the rms
;note that we skip this new calculation if within galactic HI, where
;the channel rms calculation is not appropriate
    if (abs(gr.velarr[delta_m]) gt 200.) then begin

    minch=delta_m-sigma_m
    if (minch lt 0) then minch=0
    maxch=delta_m+sigma_m
    if (maxch gt nch-1) then maxch=nch-1 

    minra=i-5
    maxra=i+5
    if (minra le 0) then minra=1
    if (maxra ge nra-1) then maxra=nra-2

    w1=gr.w[minch:maxch,0,0:minra,j]
    w2=gr.w[minch:maxch,0,maxra:(nra-1),j]
    sw1=n_elements(w1)
    sw2=n_elements(w2)
    wrms=fltarr(sw1+sw2)
    wrms[0:sw1-1]=w1
    wrms[sw1:(sw1+sw2-1)]=w2

    d1=tav[minch:maxch,0,0:minra,j]
    d2=tav[minch:maxch,0,maxra:(nra-1),j]
    sd1=n_elements(d1)
    sd2=n_elements(d2)
    datarms=fltarr(sd1+sd2)
    datarms[0:sd1-1]=d1
    datarms[sd1:(sd1+sd2-1)]=d2

;    wrms=gr.w[minch:maxch,0,*,j]
;    datarms=tav[minch:maxch,0,*,j]
    nodatapts=where(wrms gt 0.0)
    if (n_elements(nodatapts) eq 1) then begin
        if (nodatapts lt 0) then goto,skipthenextline
    endif
    datarms=datarms[nodatapts]
    skipthenextline:
    chanrms=sqrt(total(datarms^2)/n_elements(datarms))

    within3sig=where(abs(datarms) lt 3*chanrms,nbrgood)
    chanrms=sqrt(total(datarms[within3sig]^2)/nbrgood)

    datarms=datarms[within3sig]
    within3sig=where(abs(datarms) lt 3*chanrms,nbrgood)
    chanrms=sqrt(total(datarms[within3sig]^2)/nbrgood)

    noise=chanrms
    sn=peak_m/noise
   endif


;here starts the second calculation of S/N - THIS IS THE GOOD ONE!
;     w=2.3568*sigma_m*5.1
    w=sigma_m*2*5.1

     if (w lt 20.) then sn2=sn
     if (w ge 20. and w lt 200.) then sn2=sn*sqrt(w/(2*10.))
     if (w ge 200.) then sn2=sn*sqrt(200.0/(2*10.))

     if ((sn2 gt (3.0)) and (w lt maxwidth)) then begin
;       print,i,j,sn,sn2,delta_m,(sigma_m*5.1), $
;   format='("RA ",i3," DEC ",i3," has S/N=",f6.2," (",f6.2,")  in channel ",i4," (sig=",f7.2,")")'

       res(delta_m,i,j)=sn2
       warr(delta_m,i,j)=sigma_m*2
       farr(delta_m,i,j)=f
       parr(delta_m,i,j)=peak_m
       narr(delta_m,i,j)=noise

       data=clean
       goto,dupl
    endif

 endfor     ;i
endfor      ;j


;goto,absoluteend

;--------------------------------------------------------------------------------
; Let's do some of the analysis here already

;initialize arrays
pol_flag=intarr(2000)
garr=fltarr(nch,nra,ndec)
raarr=fltarr(nch,nra,ndec)
decarr=fltarr(nch,nra,ndec)

minpts=4
minptsfit=6

cnt=0
entry={ch:0,ra:0,dec:0,w:0.0,ara:0.0,adec:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:0,color_pol:'',cz:0.0,agc:'',comments:''}
sources=replicate(entry,2000)

;    comments=strarr(100)
cnt_det=0
diff_pol=fltarr(2000)
color_pol=strarr(2000)

map=res

for n=0,4000 do begin
print,'n=',strtrim(n,2)

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
 if (m eq 0.0 or (m lt (snth))) then begin
     print,'the maximum is below the threshold, ending the search ',m
     goto,ending
 endif
 col_index=tempmax[index,1]
 row_index=tempmax[index,2]

 indexch=index
 print,'maximum: ',index,round(col_index),round(row_index),' (',strtrim(m,2),')'

 profile=replicate(0.1,nra,ndec)
 wprof=replicate(0.0,nra,ndec)

 sigma_m=warr[indexch,col_index,row_index]/2. 
 minch=fix(indexch-5*sigma_m)
 if (minch lt 0.0) then minch=0.
 maxch=fix(indexch+5*sigma_m)
 if (maxch gt nch-1) then maxch=nch-1

 ;find the right value for the rms noise
 noise=narr[indexch,col_index,row_index]
; noisesn=noise/1000.*sqrt(20.0)*sqrt(200.0)

 ;get the size of the search region in RA
 sb=0
 mindec=row_index-3
 maxdec=row_index+3
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
       endif  

       if ((minra lt 0) and (maxra gt nra-1)) then break

  endfor
;  print,'countra: ',countra
  minra=round(col_index-countra)
  maxra=round(col_index+countra)
  if (minra lt 0) then minra=0
  if (maxra gt nra-1) then maxra=nra-1


 ;get the size of the search region in DEC
 mnr=round(col_index-3)
 mxr=round(col_index+3)
 if (mnr lt 0) then mnr=0
 if (mxr gt nra-1) then mxr=nra-1
 checkdec=reform(total(map[*,mnr:mxr,*],2))
 countdec=0
 for i=1,200 do begin
       mindec=row_index-i
       maxdec=row_index+i

       if (mindec-sb lt 0 and maxdec+sb gt ndec-1) then break

       if (mindec-sb lt 0 and maxdec+sb le ndec-1) then begin
        if(max(checkdec[minch:maxch,maxdec-sb:maxdec+sb]) eq 0.0) then break
        countdec=countdec+1
       endif

       if (maxdec+sb gt (ndec-1) and mindec-sb ge 0) then begin
        if(max(checkdec[minch:maxch,mindec-sb:mindec+sb]) eq 0.0) then break
        countdec=countdec+1
       endif

       if ((mindec-sb ge 0) and (maxdec+sb le (ndec-1))) then begin
        if((max(checkdec[minch:maxch,maxdec-sb:maxdec+sb]) eq 0.0) and (max(checkdec[minch:maxch,mindec-sb:mindec+sb]) eq 0.0)) then break
        countdec=countdec+1
       endif  
   endfor
 ; print,'countdec : ',countdec
  mindec=round(row_index-countdec)
  maxdec=round(row_index+countdec)
  if (mindec lt 0) then mindec=0
  if (maxdec gt ndec-1) then maxdec=ndec-1

  if (countra+countdec eq 0) then begin
     map[index,col_index,row_index]=0.0
     continue
  endif

;store the selected region in the PROFILE array
  for i=minra,maxra do begin
   for k=mindec,maxdec do begin
    bidon=max(map[minch:maxch,i,k],indmax)
    profile[i,k]=max(map[minch:maxch,i,k])
    wprof[i,k]=warr[minch+indmax,i,k]
    if (profile[i,k] eq 0.0) then profile[i,k]=0.1
   endfor
  endfor

  profra=total(profile,2)
  profdec=total(profile,1)
  indra=where(profra gt ndec*0.1)
  inddec=where(profdec gt nra*0.1)
  if (n_elements(indra) lt 2) then goto,remove
  if (n_elements(inddec) lt 2) then goto,remove


;now fit a 2D gaussian, plot and record the result
    ind=where(profile gt 0.2)

    si=size(ind,/dimension)

;check if the widths of all the detections agree
    peakw=warr[indexch,col_index,row_index]
    widthsarray=wprof[ind]
;    print,'Widths:',widthsarray
;    print,'WIDTH AT MAX=',peakw
    goodw=where(widthsarray gt (peakw-0.5*peakw) and widthsarray lt (peakw+0.5*peakw))
;    print,'good widths:',widthsarray[goodw]
    print,'number of points before : '+strtrim(string(si),2)+'     after w criterion: '+strtrim(string(n_elements(goodw)),2)

    siold=si
    si=n_elements(goodw)

;check what is the weight in the map at the position of the maximum
    if (gr.w[indexch,0,col_index,row_index] lt maxweight/4. or gr.w[indexch,1,col_index,row_index] $
	lt maxweight/4.) then begin
;       print,'WEIGHTS TOO LOW, SKIP THIS DETECTION'
       goto,remove
    endif

    if (n eq 0 and si gt 100 and galHI eq 'yes' and abs(gr.velarr[indexch]) lt 100.) then begin
       minch2=fix(indexch-2.0*sigma_m)
       if (minch2 lt 0.0) then minch2=1.
       maxch2=fix(indexch+2.0*sigma_m)
       if (maxch2 gt nch-1) then maxch2=nch-2
       print,'Neglecting Galactic HI in region:',minch2,maxch2    
       map[minch2:maxch2,*,*]=fltarr((maxch2-minch2+1),nra,ndec)
       racen=round(nra/2)
       deccen=round(ndec/2)
       rawidth=nra
       decwidth=ndec
       rafwhm=2.3548*rawidth*5*15.0/60 ;FWHM in arcminutes
       decfwhm=2.3548*decwidth         ;FWHM in arcminutes
       fwhm=warr[indexch,col_index,row_index]*5.1  ;FWHM in km/s
       wkms=fwhm
       raarr[indexch,col_index,row_index]=rafwhm
       decarr[indexch,col_index,row_index]=decfwhm
       goto,forgalHI
    endif


    if ((si ge minpts)) then begin

     print,'I found a galaxy!'

;     yfit2D=GAUSS2DFIT(profile,a) ;NO TILT ALLOWED AT THE MOMENT

     if (siold ge minptsfit) then begin
     
     svs=[double(col_index),double(row_index),double(countra),double(countdec),max(profile)]
     ers=replicate(1.0,nra,ndec)
     wef=replicate(1.0,nra,ndec)
     xra=indgen(nra)
     ydec=indgen(ndec)
     fitparams=MPFIT2DFUN('model_gauss2D',xra,ydec,profile,ers,svs,WEIGHTS=replicate(1.0,nra,ndec),/QUIET)
;     print,'fitted 2D Gauss'
 
     racen=fitparams[0]
     deccen=fitparams[1]
     rawidth=fitparams[2]
     decwidth=fitparams[3]

     rafwhm=2.3548*rawidth*5*15.0/60 ;FWHM in arcminutes
     decfwhm=2.3548*decwidth         ;FWHM in arcminutes
 ;    print,'FHHM : ',rafwhm,decfwhm

     yfit2D=model_gauss2D(indgen(nra),indgen(ndec),fitparams)

;     print,'a: ',fitparams

     if (rawidth lt 0 or decwidth lt 0) then goto,remove
     if (rafwhm gt 20 or decfwhm gt 20) then goto,remove
     if (rawidth gt nra or decwidth gt ndec) then begin
       print,'box too big'
;       print,rawidth,3*nra,decwidth,3*ndec
       goto,remove
     endif

     mnr=round(racen-3*rawidth)
     mxr=round(racen+3*rawidth)
     mnd=round(deccen-3*decwidth)
     mxd=round(deccen+3*decwidth)
     if (mnr lt 0) then mnr=0
     if (mxr lt 0) then goto,remove
     if (mxd lt 0) then goto,remove
     if (mnr gt nra-1) then goto,remove
     if (mnd gt ndec-1) then goto,remove
     if (mxr gt nra-1) then mxr=nra-1
     if (mnd lt 0) then mnd=0
     if (mxd gt ndec-1) then mxd=ndec-1

     if (mxr-mnr gt 30) then begin
      mnr=minra
      mxr=maxra
     endif
     if (mxd-mnd gt 30) then begin
      mnd=mindec
      mxd=maxdec
     endif

     if (racen lt 0) then racen=0
     if (racen gt nra-1) then racen=nra-1
     if (deccen lt 0) then deccen=0
     if (deccen gt ndec-1) then deccen=ndec-1
     
     map[minch:maxch,mnr:mxr,mnd:mxd]=fltarr((maxch-minch+1),(mxr-mnr+1),(mxd-mnd+1))
     print,'putting to zero:',minch,maxch,mnr,mxr,mnd,mxd

   endif


     if (siold lt minptsfit) then begin
      remove:
      print,'not enough points to fit: ',strtrim(string(si),2)
      rawidth=0.0
      decwidth=0.0
      racen=col_index
      deccen=row_index

      mnr=minra-sb
      mxr=maxra+sb
      mnd=mindec-sb
      mxd=maxdec+sb
      if (mnr lt 0) then mnr=0
      if (mxr gt nra-1) then mxr=nra-1
      if (mnd lt 0) then mnd=0
      if (mxd gt ndec-1) then mxd=ndec-1
      map[minch:maxch,mnr:mxr,mnd:mxd]=fltarr((maxch-minch+1),(mxr-mnr+1),(mxd-mnd+1))
      print,'putting to zero:',minch,maxch,mnr,mxr,mnd,mxd

     endif


     rafwhm=2.3548*rawidth*5*15.0/60 ;FWHM in arcminutes
     decfwhm=2.3548*decwidth         ;FWHM in arcminutes
     fwhm=warr[indexch,col_index,row_index]*5.1  ;FWHM in km/s
     wkms=fwhm
     raarr[indexch,col_index,row_index]=rafwhm
     decarr[indexch,col_index,row_index]=decfwhm
 ;    print,rafwhm,decfwhm

;calculating the detection threshold

     forgalHI:

     if (wkms lt 200) then begin
        fth=narr[indexch,col_index,row_index]*(snth-0.5)*wkms/sqrt(wkms/(2*10.))
        fthok=narr[indexch,col_index,row_index]*(snth)*wkms/sqrt(wkms/(2*10.))
     endif else begin
        fth=narr[indexch,col_index,row_index]*(snth-0.5)*(wkms)/sqrt(200.0/(2*10.))
        fthok=narr[indexch,col_index,row_index]*(snth)*(wkms)/sqrt(200.0/(2*10.))
     endelse

     ; NOTE: the content of farr is in K, has to be converted to Jy!
     if((farr[indexch,col_index,row_index]) gt fth) then begin


     ; check if the source appears in both polarisations
        ws=warr[indexch,col_index,row_index]

        minw=indexch-(ws/2.)
        maxw=indexch+(ws/2.)
        if (minw lt 0) then minw=0
        if (maxw gt nch-1) then maxw=nch-1
        pol0=total(tav[minw:maxw,0,col_index,row_index])/sqrt(maxw-minw+1)
        pol1=total(tav[minw:maxw,1,col_index,row_index])/sqrt(maxw-minw+1)


        stt=narr[indexch,col_index,row_index]/sqrt(maxw-minw+1)

        sav=0.5*abs(pol0+pol1)
        diff_pol(cnt_det)=abs(pol0-pol1)/stt


        if (sav lt 50*stt) then begin
         if (diff_pol(cnt_det) gt (20.)) then begin   ;polarisations are obviously different
             pol_flag(cnt_det)=1
             color_pol(cnt_det)='0000FF'XL
         endif
         if (diff_pol(cnt_det) gt (8.) and diff_pol(cnt_det) le (20.)) then begin   ;marginal difference between pols
            pol_flag(cnt_det)=7
            color_pol(cnt_det)='00FF00'XL
         endif
         if  (diff_pol(cnt_det) le (8.)) then begin   ;good detection
             if((farr[indexch,col_index,row_index]) gt fthok) then begin
              color_pol(cnt_det)='00FF00'XL
             endif else begin
              color_pol(cnt_det)='00FF00'XL
              pol_flag(cnt_det)=0       
             endelse
         endif

        endif else begin
         if (diff_pol(cnt_det) gt (0.3*sav/stt)) then begin
            pol_flag(cnt_det)=1
            color_pol(cnt_det)='0000FF'XL
        endif
         if (diff_pol(cnt_det) gt (0.1*sav/stt) and diff_pol(cnt_det) le (0.3*sav/stt)) then begin
            pol_flag(cnt_det)=7
            color_pol(cnt_det)='00FF00'XL
        endif
         if (diff_pol(cnt_det) le (0.1*sav/stt)) then begin
             if((farr[indexch,col_index,row_index]) gt fthok) then begin
              color_pol(cnt_det)='00FF00'XL
             endif else begin
              color_pol(cnt_det)='00FF00'XL
              pol_flag(cnt_det)=0 
          endelse
        endif

       endelse 

       if (wkms gt 120.0 and res[indexch,col_index,row_index] lt 15) then begin
              color_pol(cnt_det)='00FF00'XL
              pol_flag(cnt_det)=0
       endif


; Put a special flag if the detection is in a region of the map with
; poor coverage, NEW! Feb.28, 2006

       if (gr.w[indexch,0,col_index,row_index] lt maxweight/3. or gr.w[indexch,1,col_index,row_index] $
lt maxweight/3.) then begin
          pol_flag(cnt_det)=6
          color_pol(cnt_det)='00BBFF'XL
          print,'Possibly a spurious detection: poor coverage'
       endif

       skip_pol:

;       if ((row_index lt 3) or (row_index gt ndec-4) or (col_index lt 3) or (col_index gt nra-4)) then begin
 ;         pol_flag[cnt_det]=3
;       endif

       sources[cnt_det].ch=indexch
       sources[cnt_det].ra=round(racen)
       sources[cnt_det].dec=round(deccen)
       sources[cnt_det].w=warr[indexch,col_index,row_index]*5.1
       sources[cnt_det].ara=raarr[indexch,col_index,row_index]
       sources[cnt_det].adec=decarr[indexch,col_index,row_index]
       sources[cnt_det].sn=res[indexch,col_index,row_index]
       sources[cnt_det].int_flux=farr[indexch,col_index,row_index]
       sources[cnt_det].peak_flux=parr[indexch,col_index,row_index]
       sources[cnt_det].rms=narr[indexch,col_index,row_index]
       sources[cnt_det].diff_pol=diff_pol[cnt_det]
       sources[cnt_det].pol_flag=pol_flag[cnt_det]
       sources[cnt_det].color_pol=color_pol[cnt_det]

       if (pol_flag[cnt_det] eq 7) then begin
           sources[cnt_det].comments='pol.diff.'
  ;         print,'updated comment for source ',cnt_det
       endif
       cnt_det=cnt_det+1
    endif


endif                          ;si

     if (si lt minpts) then begin
;     print,'not enough points ',si
;     remove:
;     print,'source rejected'
     rawidth=0.0
     decwidth=0.0
     racen=col_index
     deccen=row_index
     mnr=minra-sb
     mxr=maxra+sb
     mnd=mindec-sb
     mxd=maxdec+sb
     if (mnr lt 0) then mnr=0
     if (mxr gt nra-1) then mxr=nra-1
     if (mnd lt 0) then mnd=0
     if (mxd gt ndec-1) then mxd=ndec-1
     map[minch:maxch,mnr:mxr,mnd:mxd]=fltarr((maxch-minch+1),(mxr-mnr+1),(mxd-mnd+1))
;     print,'putting to zero:',minch,maxch,mnr,mxr,mnd,mxd
     endif


endfor

ending:
t2=systime(1)

;endfor


sourcestmp=sources
tcnt=0
for i=0,1999 do begin
 if (sources[i].ch eq 0 and sources[i].ra eq 0) then break
 tcnt=tcnt+1
endfor

if (tcnt eq 0) then begin
    print,'No sources were found'
endif else begin
    sources=sourcestmp[0:tcnt-1]
    print,'Total number of sources: ',strtrim(tcnt-1,2)
endelse

absoluteend:

end ;procedure
