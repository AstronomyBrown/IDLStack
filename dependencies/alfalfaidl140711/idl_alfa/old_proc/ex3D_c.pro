;NAME:
; ex3D_c.pro - Finds signals within a 3D tile and produces a list of candidates 
;
;LAST UPDATE: Dec.7, 2005 by AS
;
;MODIFICATION HISTORY:
;Nov. 10, 2005 (BK) - Small change to erase windows instead of deleting
;Dec. 7, 2005 (AS) - Changed the function that does the 2D gaussian fitting
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
;MAIN PROGRAM
;===============================================================

pro ex3D_c,gr,sources,res,SN=snth,GALHI=galHI


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

sigmin=5.           ;minimum template width investigated
sigmax=40.          ;maximum width
delta_sig=1.        ;step between values
sig_size=ceil((sigmax-sigmin)/delta_sig)

sig_size=12
sigmas=[3,5,7,11,15,20,25,30,35,40,45,50]
maxwidth=620.0

s=gr.d

d=size(s,/dimensions)
nch=d[0]
npol=d[1]
nra=d[2]
ndec=d[3]

print,nch,npol,nra,ndec
tile=s

; read the AGC list
openr,lun,'/home/dorado3/galaxy/idl_alfa/agc.list',/get_lun
agcdata=fltarr(12,19599)
agcname=strarr(19599)
readf,lun,agcdata,format='(i6,2f9.5,2f6.1,6i6,i8)'
point_lun,lun,0
readf,lun,agcname,format='(80x,a9)'
free_lun,lun


;initialize matrices to record detections
res=fltarr(nch,nra,ndec)
warr=fltarr(nch,nra,ndec)
farr=fltarr(nch,nra,ndec)
parr=fltarr(nch,nra,ndec)
narr=fltarr(nch,nra,ndec)

;average the two polarizations
tav=tile
tav[*,0,*,*]=0.5*(tile[*,0,*,*]+tile[*,1,*,*])

t1=systime(1)
;------------------------------------------------
;Now we can start extracting signals!


;create templates and calculate their FFT

response=fltarr(sig_size,nch)
t=fltarr(sig_size,nch)
fft_t=fltarr(sig_size,nch)

for k=0,sig_size-1 do begin
  tau=sigmas[k]
  t(k,*)=1/sqrt((tau*sqrt(pi)))*exp(-(findgen(nch)-(nch/2))^2/(2*tau^2))

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

    ind_nogalHI=where(abs(gr.velarr) gt 50.)
    nogalHI=clean(ind_nogalHI)
    size_nogalHI=n_elements(nogalHI)

    noise=sqrt(total(nogalHI^2)/size_nogalHI)

    sn=peak_m/noise

;here starts the second calculation of S/N - THIS IS THE GOOD ONE!
     w=2.3568*sigma_m*5.1


     if (w lt 200) then begin
        sn2=sn*sqrt(w/(2*10.))  ; 10= spectral res. after 3pt Hanning. sm.
     endif else begin
        sn2=sn*sqrt(200.0/(2*10.))
     endelse
;     print,'S/N: ',sn2,sn3,sn4

     if ((sn2 gt (3.0)) and (w lt maxwidth)) then begin
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

 endfor     ;i
endfor      ;j




;--------------------------------------------------------------------------------
; Let's do some of the analysis here already

;initialize arrays
pol_flag=intarr(2000)
garr=fltarr(nch,nra,ndec)
raarr=fltarr(nch,nra,ndec)
decarr=fltarr(nch,nra,ndec)

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
 if (m eq 0.0 or (m lt (snth))) then goto,ending
 col_index=tempmax[index,1]
 row_index=tempmax[index,2]

 indexch=index
 print,'maximum: ',index,round(col_index),round(row_index),' (',strtrim(m,2),')'

; profile=fltarr(nra,ndec)
 profile=replicate(0.1,nra,ndec)

 sigma_m=warr[indexch,col_index,row_index] 
 minch=fix(indexch-5*sigma_m)
 if (minch lt 0.0) then minch=0.
 maxch=fix(indexch+5*sigma_m)
 if (maxch gt nch-1) then maxch=nch-1

 ;find the right value for the rms noise
 noise=narr[indexch,col_index,row_index]
 noisesn=noise/1000.*sqrt(20.0)*sqrt(200.0)

 ;get the size of the search region in RA
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
       endif  

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
;       mindecmin=mindec-1
;       mindecmax=mindec+1
;       maxdecmin=maxdec-1
;       maxdecmax=maxdec+1
;       if (mindecmin lt 0) then mindecmin=0
;       if (mindecmax gt

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
  print,'countdec : ',countdec
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
    profile[i,k]=max(map[minch:maxch,i,k])
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
    te= profile gt 0.2
    ind=where(te)

    si=size(ind,/dimension)
    print,'size: ',si

    if (n eq 0 and si gt 100 and galHI eq 'yes') then begin
       minch2=fix(indexch-3*sigma_m)
       if (minch2 lt 0.0) then minch2=1.
       maxch2=fix(indexch+3*sigma_m)
       if (maxch2 gt nch-1) then maxch2=nch-2
       print,'Neglecting Galactic HI in region:',minch2,maxch2    
       map[minch2:maxch2,*,*]=fltarr((maxch2-minch2+1),nra,ndec)
       racen=round(nra/2)
       deccen=round(ndec/2)
       rawidth=nra
       decwidth=ndec
       rafwhm=2.3548*rawidth*5*15.0/60 ;FWHM in arcminutes
       decfwhm=2.3548*decwidth         ;FWHM in arcminutes
       fwhm=2.3568*warr[indexch,col_index,row_index]*5.1  ;FWHM in km/s
       wkms=fwhm
       raarr[indexch,col_index,row_index]=rafwhm
       decarr[indexch,col_index,row_index]=decfwhm
       goto,forgalHI
    endif


    if ((si gt 5)) then begin

     print,'I found a galaxy!'

     if (si gt 5) then begin
;     yfit2D=GAUSS2DFIT(profile,a) ;NO TILT ALLOWED AT THE MOMENT
     
     svs=[double(col_index),double(row_index),double(countra),double(countdec),max(profile)]
     ers=replicate(1.0,nra,ndec)
     wef=replicate(1.0,nra,ndec)
     xra=indgen(nra)
     ydec=indgen(ndec)
     fitparams=MPFIT2DFUN('model_gauss2D',xra,ydec,profile,ers,svs,WEIGHTS=replicate(1.0,nra,ndec),/QUIET)
 
     racen=fitparams[0]
     deccen=fitparams[1]
     rawidth=fitparams[2]
     decwidth=fitparams[3]

     yfit2D=model_gauss2D(indgen(nra),indgen(ndec),fitparams)

     print,'a: ',fitparams

     if (rawidth lt 0 or decwidth lt 0) then goto,remove
     if (rawidth gt 3*nra or decwidth gt 3*ndec) then goto,remove


     mnr=round(racen-5*rawidth)
     mxr=round(racen+5*rawidth)
     mnd=round(deccen-5*decwidth)
     mxd=round(deccen+5*decwidth)
     if (mnr lt 0) then mnr=0
     if (mxr lt 0) then goto,remove
     if (mxd lt 0) then goto,remove
     if (mnr gt nra-1) then goto,remove
     if (mnd gt ndec-1) then goto,remove
     if (mxr gt nra-1) then mxr=nra-1
     if (mnd lt 0) then mnd=0
     if (mxd gt ndec-1) then mxd=ndec-1

     if (racen lt 0) then racen=0
     if (racen gt nra-1) then racen=nra-1
     if (deccen lt 0) then deccen=0
     if (deccen gt ndec-1) then deccen=ndec-1
     
     print,'putting to zero:',minch,maxch,mnr,mxr,mnd,mxd
 ;    help,map
     map[minch:maxch,mnr:mxr,mnd:mxd]=fltarr((maxch-minch+1),(mxr-mnr+1),(mxd-mnd+1))
;     map[indexch,col_index,row_index]=0.
     endif

     if (si le 5) then begin
      remove:
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
;      map[indexch,col_index,row_index]=0.
     endif


     rafwhm=2.3548*rawidth*5*15.0/60 ;FWHM in arcminutes
     decfwhm=2.3548*decwidth         ;FWHM in arcminutes
     fwhm=2.3568*warr[indexch,col_index,row_index]*5.1  ;FWHM in km/s
     wkms=fwhm
     raarr[indexch,col_index,row_index]=rafwhm
     decarr[indexch,col_index,row_index]=decfwhm
 ;    print,rafwhm,decfwhm

        
        if (n eq 0) then window,1,retain=2,xsize=768,ysize=614
        if (n gt 0) then erase
;        !p.multi=[0,2,0,0,0]
        !p.multi=0
        device, decomposed=0
;        imgdisp,reform(tav[indexch,0,0:nra-1,0:ndec-1]),position=[0.05,0.05,0.98,0.98],/histeq
        if (si gt 5) then begin 
           contour,yfit2D,xrange=[minra,maxra],yrange=[mindec,maxdec]
        endif

        if (si le 5) then begin
           plot,profile[*,0],xrange=[minra,maxra],yrange=[mindec,maxdec],/NODATA
        endif


     for r=minra,maxra do begin
       for d=mindec,maxdec do begin
         if (profile[r,d] gt 0.1 ) then begin
             plots,r,d,psym=6
         endif

       endfor
     endfor

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

        minw=indexch-ws
        maxw=indexch+ws
        if (minw lt 0) then minw=0
        if (maxw gt nch-1) then maxw=nch-1
        pol0=total(tav[minw:maxw,0,col_index,row_index])/sqrt(maxw-minw+1)
        pol1=total(tav[minw:maxw,1,col_index,row_index])/sqrt(maxw-minw+1)


        stt=narr[indexch,col_index,row_index]/sqrt(maxw-minw+1)

        sav=0.5*abs(pol0+pol1)
        diff_pol(cnt_det)=abs(pol0-pol1)/stt

        if (sav lt 50*stt) then begin
         if (diff_pol(cnt_det) gt (5)) then begin
            pol_flag(cnt_det)=1
            color_pol(cnt_det)='0000FF'XL            
         endif else begin
             if((farr[indexch,col_index,row_index]) gt fthok) then begin
              color_pol(cnt_det)='00FF00'XL
             endif else begin
              color_pol(cnt_det)='FFFF00'XL
              pol_flag(cnt_det)=2       
             endelse
         endelse

         endif else begin
         if (diff_pol(cnt_det) gt (0.1*sav/stt)) then begin
            pol_flag(cnt_det)=1
            color_pol(cnt_det)='0000FF'XL
         endif else begin
             if((farr[indexch,col_index,row_index]) gt fthok) then begin
              color_pol(cnt_det)='00FF00'XL
             endif else begin
              color_pol(cnt_det)='FFFF00'XL
              pol_flag(cnt_det)=2 
          endelse
        endelse

       endelse 

       if (wkms gt 120.0 and res[indexch,col_index,row_index] lt 15) then begin
              color_pol(cnt_det)='00FF00'XL
              pol_flag(cnt_det)=0
       endif

       skip_pol:

;       if ((row_index lt 3) or (row_index gt ndec-4) or (col_index lt 3) or (col_index gt nra-4)) then begin
 ;         pol_flag[cnt_det]=3
;       endif

       sources[cnt_det].ch=indexch
       sources[cnt_det].ra=round(racen)
       sources[cnt_det].dec=round(deccen)
       sources[cnt_det].w=2.3568*warr[indexch,col_index,row_index]*5.1
       sources[cnt_det].ara=raarr[indexch,col_index,row_index]
       sources[cnt_det].adec=decarr[indexch,col_index,row_index]
       sources[cnt_det].sn=res[indexch,col_index,row_index]
       sources[cnt_det].int_flux=farr[indexch,col_index,row_index]
       sources[cnt_det].peak_flux=parr[indexch,col_index,row_index]
       sources[cnt_det].rms=narr[indexch,col_index,row_index]
       sources[cnt_det].diff_pol=diff_pol[cnt_det]
       sources[cnt_det].pol_flag=pol_flag[cnt_det]
       sources[cnt_det].color_pol=color_pol[cnt_det]

       cnt_det=cnt_det+1
    endif


endif                           ;si

     if (si lt 6) then begin
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


endfor

ending:
t2=systime(1)

;endfor


sourcestmp=sources
tcnt=0
for i=0,499 do begin
 if (sources[i].ch eq 0 and sources[i].ra eq 0) then break
 tcnt=tcnt+1
endfor

sources=sourcestmp[0:tcnt-1]
print,'Total number of sources: ',strtrim(tcnt-1,2)
;save,tav,sources,$
; file='./tmp_extract/ext_'+strtrim(string(pos[index_pos].scannumber),2)+'.sav'
;print,'Saved temporary files'
;ending:

;print,'Preparation time : ',t1-t0
;print,'Computation time : ',t2-t1
;print,'----------------------------'
;print,'Total time : ',t2-t0

end ;procedure
