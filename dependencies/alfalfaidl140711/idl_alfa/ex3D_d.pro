;UPDATED on Jul.28 2006 to follow the changes mace in ex3D_c (see that
;file for more details.
;
;-----------------------------------------------------------------------------------------------
pro disp_drift3,image,imagew,cntarr,mapwindow,n,AXIS=axis
if (n_elements(clip) eq 0) then clip=[-1.,1.]
nx=n_elements(image[*,0])
ny=n_elements(image[0,*])
if (axis eq 'vel') then begin
   xs=500
   ys=800
endif
if (axis eq 'ra' or axis eq 'dec') then begin
   xs=1000
   ys=800
;   ys=xs*ny/nx
endif
window,/free,xsize=xs,ysize=ys,retain=2
mapwindow=!d.window
;!p.multi=0
!p.multi=[0,2,2,0,0]
loadct,1
device, decomposed=0
plot,cntarr,indgen(n_elements(cntarr)),xrange=[0,300],ytickname=replicate(' ',5),yticks=4,$
     xticks=3,position=[0.90,0.05,0.98,0.50],yrange=[0,n_elements(cntarr)],xstyle=1,ystyle=1
plot,cntarr,indgen(n_elements(cntarr)),xrange=[0,300],ytickname=replicate(' ',5),yticks=4,$
     xticks=3,position=[0.90,0.55,0.98,0.95],yrange=[0,n_elements(cntarr)],xstyle=1,ystyle=1
imgdisp,imagew,position=[0.08,0.05,0.88,0.50],noscale=noscale
imgdisp,image,position=[0.08,0.55,0.88,0.95],/histeq,usecongrid=usecongrid,zx=10,zy=10
xyouts,0.08,0.96,strtrim(axis,2)+' plane '+strtrim(string(n),2),charsize=2.5,charthick=2,/normal

end



;-----------------------------------------------------------------------------------------------
pro disp_weights,image,weightwindow,AXIS=axis
if (n_elements(clip) eq 0) then clip=[-1.,1.]
nx=n_elements(image[*,0])
ny=n_elements(image[0,*])
if (axis eq 'vel') then begin
   xs=300
   ys=300
endif
if (axis eq 'ra' or axis eq 'dec') then begin
   xs=500
   ys=300
;   ys=xs*ny/nx
endif
window,/free,xsize=xs,ysize=ys,retain=2
weightwindow=!d.window
;!p.multi=0
!p.multi=[0,2,2,0,0]
loadct,1
device, decomposed=0
imgdisp,image,position=[0.05,0.05,0.95,0.95],/histeq
end


;-----------------------------------------------------------------------------------------------
pro make_colours_special,nsources,sources,maxweight,weightsources
 for i=0,nsources-1 do begin
   if (weightsources[i] lt maxweight/2.) then sources[i].pol_flag=6
   case sources[i].pol_flag of
       0: sources[i].color_pol='00FF00'XL  ; good
       1: sources[i].color_pol='0000FF'XL  ; bad based on polarisations
       2: sources[i].color_pol='00BBFF'XL  ; good but just below S/N threshold
       3: sources[i].color_pol='FFFFFF'XL  ;put back bbbbff
       6: sources[i].color_pol='00BBFF'XL  ; probably spurious, low weights
       7: sources[i].color_pol='00FF00'XL  ;marginal in terms of polarisations
       9: sources[i].color_pol='0000FF'XL
       else: sources[i].color_pol='FFFFFF'XL
   endcase
 endfor
end

;-----------------------------------------------------------------------------------------------
pro make_colours3,nsources,sources   ;make color array
 for i=0,nsources-1 do begin
   case sources[i].pol_flag of
       0: sources[i].color_pol='00FF00'XL
       1: sources[i].color_pol='0000FF'XL 
       2: sources[i].color_pol='00BBFF'XL  
       3: sources[i].color_pol='FFFFFF'XL  ;put back bbbbff
       6: sources[i].color_pol='00BBFF'XL
       7: sources[i].color_pol='00FF00'XL  ;marginal in terms of polarisations
       9: sources[i].color_pol='0000FF'XL
       else: sources[i].color_pol='FFFFFF'XL
   endcase
 endfor
end


;-----------------------------------------------------------------------------------------------
pro get_corners3,sources,j,nra,ndec,nch,LLra,URra,LLdec,URdec,LLch,URch
      sizera=sources[j].ara
      sizedec=sources[j].adec
      if (sizera eq 0.) then sizera=2.
      if (sizedec eq 0.) then sizedec=2.
      LLra=sources[j].ra-sizera*3/(2.3548*5*15/60.0)
      LLdec=sources[j].dec-sizedec*3/2.3548
      URra=sources[j].ra+sizera*3/(2.3548*5*15/60.0)
      URdec=sources[j].dec+sizedec*3/2.3548
      LLch=sources[j].ch-sources[j].w*3/(5.3*2.3548)
      URch=sources[j].ch+sources[j].w*3/(5.3*2.3548)
      if (LLra lt 0) then LLra=0
      if (LLdec lt 0) then LLdec=0
      if (URra gt nra-1) then URra=nra-1
      if (URdec gt ndec-1) then URdec=ndec-1
      if (LLch lt 0) then LLch=0
      if (URch gt nch-1) then URch=nch-1
end


;-----------------------------------------------------------------------------------------------
pro search_agc3,gr,agcdata,n,nagc,xagc,yagc,iagc,VERBOSE=vrb,AXIS=axis

d=size(gr.d,/dimensions)
nch=d[0]
npol=d[1]
nra=d[2]
ndec=d[3]

if (axis eq 'vel') then begin
  ra1=gr.ramin
  ra2=gr.ramin+(gr.deltara/3600.0)*gr.nx
  dec1=gr.decmin
  dec2=gr.decmin+(gr.deltadec/60.0)*gr.ny
  nmin=n-10
  nmax=n+10
  if (nmin lt 0) then nmin=0
  if (nmax gt nch-1) then nmax=nch-1
  ch1=gr.velarr[nmin]
  ch2=gr.velarr[nmax]
endif

if (axis eq 'ra') then begin
  ra1=gr.ramin+(gr.deltara/3600.0)*n-0.0033   ;0.0033 hours = 3 arcminutes
  ra2=gr.ramin+(gr.deltara/3600.0)*n+0.0033
  dec1=gr.decmin
  dec2=gr.decmin+(gr.deltadec/60.0)*gr.ny
  ch1=gr.velarr[0]
  ch2=gr.velarr[nch-1]
endif

if (axis eq 'dec') then begin
  ra1=gr.ramin
  ra2=gr.ramin+(gr.deltara/3600.0)*gr.nx
  dec1=gr.decmin+(gr.deltadec/60.0)*n-0.05
  dec2=gr.decmin+(gr.deltadec/60.0)*n+0.05
  ch1=gr.velarr[0]
  ch2=gr.velarr[nch-1]
endif

      iagc=where(agcdata[1,*] gt (ra1-agcdata[3,*]/3600.) and $
               agcdata[1,*] lt (ra2+agcdata[3,*]/3600.) and $
               agcdata[2,*] gt (dec1-agcdata[4,*]/3600.) and $  ;should it be 60??
               agcdata[2,*] lt (dec2+agcdata[4,*]/3600.) and $
               agcdata[5,*] gt ch2 and agcdata[5,*] lt ch1, nagc)         
        
      if (nagc gt 0) then begin
                                                                                                           
        if (vrb ne 'no') then print,'AGC SOURCES----------------------------'
;        xagc=agcdata[6,iagc]
;        yagc=agcdata[6,iagc]
     xagc=fltarr(nagc)
     yagc=fltarr(nagc)

        for nla=0,nagc-1 do begin
          k=nla
          agcnr=agcdata[0,iagc[nla]]
          rh=floor(agcdata[1,iagc[nla]])
          rmm=(agcdata[1,iagc[nla]]-rh)*60.
          rm=floor(rmm)
          rs=(rmm-rm)*60.
          decd=agcdata[2,iagc[nla]]
          dd=floor(agcdata[2,iagc[nla]])
          dmm=(agcdata[2,iagc[nla]]-dd)*60.
          dm=floor(dmm)
          ds=round((dmm-dm)*60.)
;          result=min(abs(msm[0,*,nb].rahr-agcdata[1,iagc[nla]]),recnr)
;          yagc[nla]=round(recnr)
;          ddec=abs(decd-dec)*60.
          chn0=agcdata[6,iagc[nla]]
          cz=agcdata[5,iagc[nla]]
          width=agcdata[7,iagc[nla]]
          FI=agcdata[10,iagc[nla]]
          Btype=agcdata[11,iagc[nla]]

        if (axis eq 'vel') then begin
          xagc[k]=round((agcdata[1,iagc[k]]-gr.ramin)/(gr.deltara/3600.0))
          yagc[k]=round((agcdata[2,iagc[k]]-gr.decmin)/(gr.deltadec/60.0))
          vm=min(abs(gr.velarr-agcdata[5,iagc[k]]),ind)
          if (abs(ind-n) lt 20) then begin
           tvlct,255B,255B,0B,128
           plots,xagc[k],yagc[k],psym=6,symsize=3,color=128       
           if (vrb ne 'no') then begin
            print,agcnr,rh,rm,rs,dd,dm,ds,cz,width,FI/100.,xagc[k],yagc[k],$
              format='(i6,2x,2i2.2,f4.1,1x,3i2.2," cz=",i5," W=",i5," FI=",f6.2," x=",i5," y=",i5)' 
            endif
          endif
        endif
        if (axis eq 'ra') then begin
          vm=min(abs(gr.velarr-agcdata[5,iagc[k]]),ind)
          xagc[k]=ind
          yagc[k]=round((agcdata[2,iagc[k]]-gr.decmin)/(gr.deltadec/60.0))
          tvlct,255B,255B,0B,128
          plots,xagc[k],yagc[k],psym=6,symsize=3,color=128
          if (vrb ne 'no') then begin
           print,agcnr,rh,rm,rs,dd,dm,ds,cz,width,FI/100.,xagc[k],yagc[k],$
              format='(i6,2x,2i2.2,f4.1,1x,3i2.2," cz=",i5," W=",i5," FI=",f6.2," x=",i5," y=",i5)' 
          endif
        endif
        if (axis eq 'dec') then begin
          vm=min(abs(gr.velarr-agcdata[5,iagc[k]]),ind)
          xagc[k]=ind
          yagc[k]=round((agcdata[1,iagc[k]]-gr.ramin)/(gr.deltara/3600.0))
          tvlct,255B,255B,0B,128
          plots,xagc[k],yagc[k],psym=6,symsize=3,color=128
          if (vrb ne 'no') then begin
          print,agcnr,rh,rm,rs,dd,dm,ds,cz,width,FI/100.,xagc[k],yagc[k],$
              format='(i6,2x,2i2.2,f4.1,1x,3i2.2," cz=",i5," W=",i5," FI=",f6.2," x=",i5," y=",i5)' 
          endif
        endif

;        if (vrb ne 'no') then begin
;          print,agcnr,rh,rm,rs,dd,dm,ds,cz,width,FI/100.,xagc[k],yagc[k],$
;              format='(i6,2x,2i2.2,f4.1,1x,3i2.2," cz=",i5," W=",i5," FI=",f6.2," x=",i5," y=",i5)' 
;        endif
      endfor  

  endif 

  end


;-------------------------------------------------------------------------------------------
pro get_radec3,ra,dec,radec
  r=sixty(ra)
  rah=fix(r[0])
  ram=fix(r[1])
  ras=fix(r[2])
  rads=round((r[2]-ras)*10)

  if (rads ge 10) then begin
    rads=0
    ras=ras+1
  endif

  rahs=strtrim(rah,2)
  rams=strtrim(ram,2)
  rass=strtrim(ras,2)
  rads=strtrim(rads,2)
  if (rah lt 10) then rahs='0'+strtrim(rah,2)
  if (ram lt 10) then rams='0'+strtrim(ram,2)
  if (ras lt 10) then rass='0'+strtrim(ras,2)

  d=sixty(dec)
  dh=fix(d[0])
  dm=fix(d[1])
  ds=round(d[2])
  dhs=strtrim(string(dh),2)
  dms=strtrim(string(dm),2)
  dss=strtrim(string(ds),2)
  if (dh lt 10) then dhs='0'+dhs
  if (dm lt 10) then dms='0'+dms
  if (ds lt 10) then dss='0'+dss
  sign='+'
  if (dec lt 0) then sign='-'
  radec=rahs+rams+rass+rads+sign+dhs+dms+dss
end

;-----------------------------------------------------------------------------------------------
pro get_position3,x,y,nch,nra,ndec,action,AXIS=axis
        if (axis eq 'vel') then begin
          nx=nra
          ny=ndec
        endif
        if (axis eq 'ra') then begin
          nx=nch
          ny=ndec
        endif
        if (axis eq 'dec') then begin
          nx=nch
          ny=nra
        endif
        print,'Left-click at the desired position:'
        cursor,xc,yc
        print,xc,yc
        x=round(xc)
        y=round(yc)
        action=0
        if ((x lt 0) or (y lt 0) or (x gt nx-1) or (y gt ny-1)) then begin 
            action=1
        endif
end 

;-----------------------------------------------------------------------------------------------
pro click_box3,xll,xur,yll,yur,nra,ndec,nch,AXIS=axis
        if (axis eq 'vel') then begin
          nx=nra
          ny=ndec
        endif
        if (axis eq 'ra') then begin
          nx=nch
          ny=ndec
        endif
        if (axis eq 'dec') then begin
          nx=nch
          ny=nra
        endif

        print,'Left-click on lower left corner of region to search:'
        cursor,xll,yll
        xll=round(xll)
        yll=round(yll)
        if (xll lt 0) then xll=0
        if (xll gt nx-1) then xll=nx-1
        if (yll lt 0) then yll=0
        if (yll gt ny-1) then yll=ny-1
        wait,0.8
        print,'Left-click on upper right corner of region to search:'
        cursor,xur,yur
        xur=round(xur)
        yur=round(yur)
        if (xur lt 0) then xur=0
        if (xur gt nx-1) then xur=nx-1
        if (yur lt 0) then yur=0
        if (yur gt ny-1) then yur=ny-1
        wait,0.8
end



;-----------------------------------------------------------------------------------------------
pro draw_boxes3,r1,r2,d1,d2,c1,c2,AXIS=axis,COLOR=color,LABEL=label,SINGLE=single

if (n_elements(single) le 0) then single='no'

device,decomposed=1
if (axis eq 'vel' or axis eq 'none') then begin
  x1=r1
  x2=r2
  y1=d1
  y2=d2
endif
if (axis eq 'ra') then begin
  x1=c1
  x2=c2
  y1=d1
  y2=d2
endif
if (axis eq 'dec') then begin
  x1=c1
  x2=c2
  y1=r1
  y2=r2
endif
if ((x1-x2) eq 0. or (y1-y2) eq 0.) then begin
 plots,round(abs(x1+x2)/2.),round(abs(y1+y2)/2.),psym=6,symsize=3,color=color,thick=2.5
endif else begin
 plots,[x1,x2],[y1,y1],linestyle=0,thick=2.5,color=color
 plots,[x1,x2],[y2,y2],linestyle=0,thick=2.5,color=color
 plots,[x1,x1],[y1,y2],linestyle=0,thick=2.5,color=color
 plots,[x2,x2],[y1,y2],linestyle=0,thick=2.5,color=color
endelse
if (n_elements(label) gt 0) then begin
 xyouts,(x1+x2)/2,y1-8,label,charsize=1.5,charthick=2.5,color=color
endif
end


;-----------------------------------------------------------------------------------------------
pro draw_square3,r1,r2,d1,d2,c1,c2,AXIS=axis,COLOR=color,LABEL=label,SINGLE=single

if (n_elements(single) le 0) then single='no'

device,decomposed=1
if (axis eq 'vel' or axis eq 'none') then begin
  x=(r1+r2)/2.0
  y=(d1+d2)/2.0
endif
if (axis eq 'ra') then begin
  x=(c1+c2)/2.0
  y=(d1+d2)/2.0
endif
if (axis eq 'dec') then begin
  x=(c1+c2)/2.0
  y=(r1+r2)/2.0
endif

plots,x,y,psym=6,symsize=3,linestyle=0,thick=2.5,color=color

if (n_elements(label) gt 0) then begin
 xyouts,x,y-8,label,charsize=1.5,charthick=2.5,color=color
endif
end



;-----------------------------------------------------------------------------------------------
pro start_display3,gr,tav,res,n,nsources,velplane,wplane,cntarr,resvelplane,matcharr,galinplane,AXIS=axis
  if (axis eq 'vel') then begin
     velplane=reform(tav[n,0,*,*])
     resvelplane=reform(res[n,*,*])
     wplane=reform(gr.w[n,0,*,*])
     cntarr=fltarr(144)
  endif
  if (axis eq 'ra') then begin
     velplane=reform(tav[*,0,n,*])
     resvelplane=reform(res[*,n,*])
     wplane=reform(gr.w[*,0,n,*])
     cntarr=reform(0.5*(gr.cont[0,n,*]+gr.cont[1,n,*]))
  endif
  if (axis eq 'dec') then begin
     velplane=reform(tav[*,0,*,n])
     resvelplane=reform(res[*,*,n])
     wplane=reform(gr.w[*,0,*,n])
     cntarr=reform(0.5*(gr.cont[0,*,n]+gr.cont[1,*,n]))
  endif

;  print,'DETECTIONS, plane ',strtrim(n,2),'----------------------------'
   matcharr=intarr(nsources)
  galinplane=intarr(nsources)
end


;-----------------------------------------------------------------------------------------------
pro check_source_box3,x,y,sources,nsources,nra,ndec,nch,AXIS=axis,ACTION=action
  for i=0,nsources-1 do begin
    if (sources[i].ra eq 0  and sources[i].dec eq 0) then continue
    get_corners3,sources,i,nra,ndec,nch,LLra,URra,LLdec,URdec,LLch,URch
    if (axis eq 'vel') then begin
       minx=LLra
       maxx=URra
       miny=LLdec
       maxy=URdec
    endif
    if (axis eq 'ra') then begin
       minx=LLch
       maxx=URch
       miny=LLdec
       maxy=URdec
    endif
    if (axis eq 'dec') then begin
       minx=LLch
       maxx=URch
       miny=LLra
       maxy=URra
    endif
    if ((x gt minx) and (x lt maxx) and (y gt miny) and (y lt maxy)) then begin
       if (action eq 'delete') then sources[i].pol_flag=9
       if (action eq 'add') then begin
            if (sources[i].pol_flag eq 1 ) then sources[i].comments=sources[i].comments+' Extr.rej.(pol) '
            if (sources[i].pol_flag eq 2 ) then sources[i].comments=sources[i].comments+' Extr.rej.(S/N) '
            if (sources[i].pol_flag eq 3 ) then sources[i].comments=sources[i].comments+' Extr.rej.(edge) '
	    if (sources[i].pol_flag eq 6 ) then sources[i].comments=sources[i].comments+' low weights '
            sources[i].pol_flag=0
       endif 
    endif
  endfor
end 

;-----------------------------------------------------------------------------------------------
pro ex3D_small,tav,xll,xur,yll,yur,n,source,AXIS=axis,SN=snth_local,NPIX=npix,NPLANE=nplane
  d=size(tav,/dimensions)
  nch=d[0]
  npol=d[1]
  nra=d[2]
  ndec=d[3]

  if ((nplane mod 2) eq 0) then nplane=nplane+1
  npl=(nplane-1)/2

  if (axis eq 'vel') then begin
     if (n gt 60 and n lt nch-61) then begin
         cmin=n-60
         cmax=n+60
     endif
     if (n le 60) then begin
         cmin=0
         cmax=120
     endif
     if (n ge nch-61) then begin
         cmin=nch-120
         cmax=nch-1
     endif
     print,'searching region ',xll,xur,yll,yur,cmin,cmax
     ex3D_s,tav[cmin:cmax,0,xll:xur,yll:yur],xll,xur,yll,yur,cmin,cmax,source,SN=snth_local,NPIX=npix,AXIS=axis
  endif
  if (axis eq 'ra') then begin
     r1=n-npl
     r2=n+npl
     if (r1 lt 0) then r1=0
     if (r2 gt nra-1) then r2=nra-1
     print,'searching region ',r1,r2,yll,yur,xll,xur
     ex3D_s,tav[xll:xur,0,r1:r2,yll:yur],r1,r2,yll,yur,xll,xur,source,SN=snth_local,NPIX=npix,AXIS=axis
  endif
  if (axis eq 'dec') then begin
     d1=n-npl
     d2=n+npl
     if (d1 lt 0) then d1=0
     if (d2 gt ndec-1) then d2=ndec-1
     print,'searching region ',yll,yur,d1,d2,yll,yur,xll,xur
     ex3D_s,tav[xll:xur,0,yll:yur,d1:d2],yll,yur,d1,d2,xll,xur,source,SN=snth_local,NPIX=npix,AXIS=axis
  endif
end


;-----------------------------------------------------------------------------------------------
pro draw_spectrum3,tav,tsm,model,x,y,n,nch,swin,AXIS=axis,TITLE=titletext
 if (axis eq 'vel') then begin  
   ra=x
   dec=y
   ch=n
 endif 
 if (axis eq 'ra') then begin  
   ra=n
   dec=y
   ch=x
 endif
 if (axis eq 'dec') then begin  
   ra=y
   dec=n
   ch=x
 endif

 print,ra,dec,ch
 window,xsize=1000,ysize=500,/free,retain=2
 swin=!d.window
 !p.multi=[0,1,2,0,0]
 device,decomposed=1
 blue='FF0000'XL
 red='0000FF'XL
 green='00FF00'XL
 cmin=0
 cmax=0
 if (ch gt 200 and ch lt nch-201) then begin
         cmin=ch-200
         cmax=ch+200
 endif
 if (ch le 200) then begin
         cmin=0
         cmax=400
 endif
 if (ch ge nch-201) then begin
         cmin=nch-400
         cmax=nch-1
 endif
 xt=indgen(nch)
 temp=min(tav[cmin:cmax,0,ra,dec])
 plot,xt,tav[*,0,ra,dec],charsize=1.5,xstyle=1,ystyle=1,xrange=[cmin,cmax],yrange=[-20,40],title=titletext
 if (total(model) ne 0.0) then oplot,xt,model,color=green
 arrow,ch,temp-0.04,ch,temp+0.015,color=green,/data
 plot,xt,tsm[*,0,ra,dec],charsize=1.5,xstyle=1,ystyle=1,xrange=[cmin,cmax],yrange=[-20,40],/nodata
 temp=min(tsm[cmin:cmax,0,ra,dec])
 oplot,xt,tsm[*,0,ra,dec],color=blue
 oplot,xt,tsm[*,1,ra,dec],color=red
 arrow,ch,temp-0.04,ch,temp+0.015,color=green,/data
end 




;===============================================================================
;MAIN PROGRAM
;===============================================================================

pro ex3D_d,gr,sources_in,res,AXIS=axis,STEP=step,SKIP=skip,CATALOG=catalog

t0=systime(1)

pi=3.141592

sigmin=5.           ;minimum template width investigated
sigmax=40.          ;maximum width
delta_sig=1.        ;step between values
sig_size=ceil((sigmax-sigmin)/delta_sig)

s=gr.d
d=size(s,/dimensions)

nch=d[0]
npol=d[1]
nra=d[2]
ndec=d[3]


print,nch,npol,nra,ndec
tsm=s
tav=s
tav=0.5*(s[*,0,*,*]+s[*,1,*,*])

;checking for input parameters
if (n_elements(axis) le 0) then axis='vel'
if (n_elements(step) le 0) then step=1
if (n_elements(skip) le 0) then skip='no'
if (n_elements(catalog) le 0) then catalog='cubecat.dat'

;checking how many sources in the catalog for this drift
sources=sources_in

dd=size(sources,/dimensions)
ns=dd[0]
print,ns

;reading the AGC
common agcshare, agcdir
openr,lun,agcdir+'agc.list',/get_lun
maxrec=150000L
agcdata=dblarr(12,maxrec)
agcname=strarr(maxrec)
record={agcnr:0L,ra:0.D,dec:0.D,item3:0.0,item4:0.0,$
        item5:lonarr(7),aname:''}
nrecords=0L
while(eof(lun) ne 1) do begin
  readf,lun,record,format='(i6,2f9.5,2f6.1,6i6,i8,a9)'
  agcdata[0,nrecords]=record.agcnr
  agcdata[1,nrecords]=record.ra
  agcdata[2,nrecords]=record.dec
  agcdata[3,nrecords]=record.item3
  agcdata[4,nrecords]=record.item4
  agcdata[5:11,nrecords]=record.item5
  agcname[nrecords]=record.aname
  nrecords=nrecords+1
endwhile
   
free_lun,lun
agcdata=agcdata[*,0:nrecords-1]
agcname=agcname[0:nrecords-1]

;select the right gain value
gain=8.5


;analyse the results matrix

t1=systime(1)

;open file to write results
openw,lun2,catalog,/get_lun

;creating structure for additional detections
entry={ch:0,ra:0,dec:0,w:0.0,ara:0.0,adec:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:1,color_pol:'',cz:0.0,agc:'',comments:''}

;nsources=500
;extra_start=450
;nextra=450
nsources=ns+50
nextra=ns

sources=replicate(entry,nsources)
sources[0:ns-1]=sources_in
foundmatch=intarr(nsources)
printsource=intarr(nsources)

if (axis eq 'vel') then nmax=nch
if (axis eq 'ra') then nmax=nra
if (axis eq 'dec') then nmax=ndec


;getting the weights
maxweight=max(gr.w)
weightsources=fltarr(nsources)
for j=0,nsources-1 do begin
 weightsources(j)=(gr.w[sources[j].ch,0,sources[j].ra,sources[j].dec]+gr.w[sources[j].ch,1,sources[j].ra,sources[j].dec])/2.
endfor
make_colours_special,nsources,sources,maxweight,weightsources


;CREATING BOXES FOR EACH SOURCE AND GETTING cz
aLLra=intarr(nsources)
aURra=intarr(nsources)
aLLdec=intarr(nsources)
aURdec=intarr(nsources)
aLLch=intarr(nsources)
aURch=intarr(nsources)
for j=0,nsources-1 do begin
   sources[j].cz=gr.velarr[sources[j].ch]
   get_corners3,sources,j,nra,ndec,nch,c1,c2,c3,c4,c5,c6
   aLLra[j]=c1
   aURra[j]=c2
   aLLdec[j]=c3
   aURdec[j]=c4
   aLLch[j]=c5
   aURch[j]=c6
endfor


for n=0,nmax-1,step do begin
  if (n gt nmax-1) then goto,ending

  display_image:
  start_display3,gr,tav,res,n,nsources,velplane,wplane,cntarr,resvelplane,matcharr,galinplane,AXIS=axis

  if (skip eq 'yes') then begin
   if (total(resvelplane) eq 0) then continue ;if nothing in this vel plane, go to next
  endif

  make_colours3,nsources,sources
  if (n_elements(mapwindow) ne 0) then wdelete,mapwindow
  disp_drift3,velplane,wplane,cntarr,mapwindow,n,AXIS=axis
  search_agc3,gr,agcdata,n,nagc,xagc,yagc,iagc,VERBOSE='yes',AXIS=axis

   print,'DETECTIONS, plane ',strtrim(n,2),'----------------------------' 


  for v=1,8000 do begin  ;looking for elements in resvelplane

   m=max(resvelplane,index)
   if (m eq 0.0) then break
   dims=size(resvelplane,/dimensions)
   ncol=dims[0]
   col_index=index mod ncol
   row_index=index / ncol

   maxsnplane=m
   x=col_index
   y=row_index

   ;put that array point to zero
   resvelplane[col_index,row_index]=0.0

   match=-1

   if (axis eq 'vel') then begin
         rd=x
         dd=y
         cd=n
   endif
   if (axis eq 'ra') then begin
         rd=n
         dd=y
         cd=x
   endif
   if (axis eq 'dec') then begin
         rd=y
         dd=n
         cd=x
    endif

   indmatch=where((rd ge aLLra) and (rd le aURra) and (dd ge aLLdec) and (dd le aURdec) and (cd ge aLLch) and (cd le aURch))

   nel=n_elements(indmatch)
   if (nel eq 1) then begin
      if (indmatch lt 0) then break
      match=indmatch
      j=match
      if (matcharr[match] lt 1) then begin
           print,j,sources[j].ra,sources[j].dec,sources[j].ch,sources[j].w, $
              fix(sources[j].cz),sources[j].sn, $
              format='(i3,"    ra=",i3," dec=",i3," chan=",i4," w=",f6.2,"km/s  cz=",i6,"   sn=",f6.2)'
       make_colours3,nsources,sources
       if ((abs(aLLra[match]-aURra[match]) eq 0.0) or (abs(aLLdec[match]-aURdec[match]) eq 0.0)) then begin
            draw_square3,aLLra[match],aURra[match],aLLdec[match],aURdec[match],aLLch[match],aURch[match],AXIS=axis,COLOR=sources[match].color_pol,LABEL=strtrim(match,2)
       endif else begin
            draw_boxes3,aLLra[match],aURra[match],aLLdec[match],aURdec[match],aLLch[match],aURch[match],AXIS=axis,COLOR=sources[match].color_pol,LABEL=strtrim(match,2)
       endelse 
       matcharr[match]=1 
      endif 
   endif else begin
       for s=0,nel-1 do begin 
        match=indmatch[s]
        j=match
        if (matcharr[match] lt 1) then begin
           print,j,sources[j].ra,sources[j].dec,sources[j].ch,sources[j].w, $
              fix(sources[j].cz),sources[j].sn, $
              format='(i3,"    ra=",i3," dec=",i3," chan=",i4," w=",f6.2,"km/s  cz=",i6,"   sn=",f6.2)'
          make_colours3,nsources,sources
       if ((abs(aLLra[match]-aURra[match]) eq 0.0) or (abs(aLLdec[match]-aURdec[match]) eq 0.0)) then begin
            draw_square3,aLLra[match],aURra[match],aLLdec[match],aURdec[match],aLLch[match],aURch[match],AXIS=axis,COLOR=sources[match].color_pol,LABEL=strtrim(match,2)
       endif else begin
            draw_boxes3,aLLra[match],aURra[match],aLLdec[match],aURdec[match],aLLch[match],aURch[match],AXIS=axis,COLOR=sources[match].color_pol,LABEL=strtrim(match,2)
       endelse 
          matcharr[match]=1 
        endif 
       endfor
   endelse

endfor    ; end v loop


;making a special loop for the extra detections
 for j=ns,nsources-1 do begin
   if (sources[j].ra eq 0 and sources[j].ch eq 0) then continue
   sources[j].cz=gr.velarr[sources[j].ch]
   get_corners3,sources,j,nra,ndec,nch,c1,c2,c3,c4,c5,c6
   aLLra[j]=c1
   aURra[j]=c2
   aLLdec[j]=c3
   aURdec[j]=c4
   aLLch[j]=c5
   aURch[j]=c6 
 endfor    ;loop for extra detections



 for j=0,nsources-1 do begin

   if (sources[j].ra eq 0 and sources[j].ch eq 0) then continue

   if (axis eq 'vel') then begin
         plmin=aLLch[j]
         plmax=aURch[j]
   endif
   if (axis eq 'ra') then begin
         plmin=aLLra[j]
         plmax=aURra[j]
   endif
   if (axis eq 'dec') then begin
         plmin=aLLdec[j]
         plmax=aURdec[j]
   endif
    if ((n ge plmin) and (n le plmax)) then begin
        galinplane[j]=1
    endif

      if (galinplane[j] eq 1 and matcharr[j] eq 0) then begin
          colbox='FFFF00'XL
          if (sources[j].pol_flag ne 0 and sources[j].pol_flag ne 7) then colbox='BBBBFF'XL
          get_corners3,sources,j,nra,ndec,nch,LLra,URra,LLdec,URdec,LLch,URch
;          print,'corners for ',j,':',LLra,URra,LLdec,URdec,LLch,URch
          draw_boxes3,LLra,URra,LLdec,URdec,LLch,URch,AXIS=axis,COLOR=colbox,LABEL=strtrim(j,2)
           print,j,sources[j].ra,sources[j].dec,sources[j].ch,sources[j].w, $
              fix(sources[j].cz),sources[j].sn, $
              format='(i3,"    ra=",i3," dec=",i3," chan=",i4," w=",f6.2,"km/s  cz=",i6,"   sn=",f6.2)'
;          matcharr[j]=1
      endif
 endfor 

   menu:

   print,'---------------------------------------'

   print,'You can now :  - ignore a detection and remove from catalog          (d galnr or d+click)'
   print,'               - delete ALL galaxies from catalog                    (d 999)'
   print,'               - add a galaxy that was rejected to the catalog       (a galnr or a+click)'
   print,'               - add a comment for a galaxy (no apostrophes!)        (c galnr)'
   print,'               - show the spectrum of a point in the map             (s)'
   print,'               - blow-up a part of the map (pols. separate)          (b)'
   print,'               - find a source in a delimited region                 (f)'
   print,'               - jump to a channel (back or forth)                   (j nch)'
   print,'               - continue with the next plane                        (n or CR)'
   print,'               - exit program                                        (e or q)'
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

   case strmid(line1,0,1) of

;----------------------------
   'd': begin
        if (lineargs eq '') then begin
         print,'Click in the box of the galaxy you want to delete from the catalog:'
         cursor,x,y
         x=round(x)
         y=round(y)
         check_source_box3,x,y,sources,nsources,nra,ndec,nch,AXIS=axis,ACTION='delete'
         goto,display_image
        endif

        if (lineargs ne '') then begin
         reads,lineargs,ngal
         if (ngal ne 999) then sources[ngal].pol_flag=9
         if (ngal eq 999) then sources[*].pol_flag=9
         goto,display_image
        endif
    end  ;case 'd'


;------------------------------
   'a': begin
        if (lineargs eq '') then begin
         print,'Click in the box of the galaxy you want to add to the catalog:'
         cursor,x,y
         x=round(x)
         y=round(y)
         check_source_box3,x,y,sources,nsources,nra,ndec,nch,AXIS=axis,ACTION='add'
         goto,display_image
        endif        
        if (lineargs ne '') then begin
         reads,lineargs,ngal
         ngal=fix(ngal)
         if (ngal le nsources-1) then begin
            if (sources[ngal].pol_flag eq 1 ) then sources[ngal].comments=sources[ngal].comments+' Extr.rej.(pol) '
            if (sources[ngal].pol_flag eq 2 ) then sources[ngal].comments=sources[ngal].comments+' Extr.rej.(S/N) '
            if (sources[ngal].pol_flag eq 3 ) then sources[ngal].comments=sources[ngal].comments+' Extr.rej.(edge) '
	    if (sources[ngal].pol_flag eq 6 ) then sources[ngal].comments=sources[ngal].comments+' low weights  
            sources[ngal].pol_flag=0
         endif
         goto,display_image
        endif
        end

;-----------------------------
   'c': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,ngal
        print,'Enter your comment: '
        text=''
        read,text
        if (ngal le nsources-1) then sources[fix(ngal)].comments=sources[(ngal)].comments+' '+text
        print,'Comment recorded for galaxy '+strtrim(fix(ngal),2)
        goto,menu
        end

;-----------------------------
   's': begin
        if (lineargs eq '') then begin
         get_position3,x,y,nch,nra,ndec,action,AXIS=axis
         if (action eq 1) then begin
            print,'Out of bounds, please try again!'
            goto,menu
         endif
         model=fltarr(nch)
         draw_spectrum3,tav,tsm,model,x,y,n,nch,swin,AXIS=axis, $
           TITLE='Spectrum at x='+strtrim(string(x),2)+', y='+strtrim(string(y),2)
        endif ;if there is no argument


      if (lineargs ne '') then begin  ;if there is an argument
         reads,lineargs,ngal
         ngal=fix(ngal)
         if (ngal gt nsources-1) then begin
           print,'This object does not exist, try again!'
           goto,menu
         endif         
         if (axis eq 'vel') then begin
          x=sources[ngal].ra
          y=sources[ngal].dec
         endif
         if (axis eq 'ra') then begin
          x=sources[ngal].ch
          y=sources[ngal].dec
         endif
         if (axis eq 'dec') then begin
          x=sources[ngal].ch
          y=sources[ngal].ra
         endif
         sigma_m=sources[ngal].w/(2.3568*5.3)
         peak_m=sources[ngal].peak_flux
         delta_m=sources[ngal].ch
         model= peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))
         draw_spectrum3,tav,tsm,model,x,y,n,nch,swin,AXIS=axis, $
            TITLE='Source '+strtrim(string(ngal),2)+',   S/N='+strtrim(string(sources[ngal].sn),2)+',   W='+strtrim(string(sources[ngal].w),2)+'km/s,   Fpeak='+strtrim(string(sources[ngal].peak_flux),2)+'mJy (rms='+strtrim(string(sources[ngal].rms),2)+')'
      endif     ; if there is an argument   

         line2='string'
         read,'Done?',line2
         case strmid(line2,0,1) of
           'y': begin
             print,' '
             if (!d.window ne mapwindow) then wdelete,swin
             goto,display_image
           end
            else: begin
             print,' '
             if (!d.window ne mapwindow) then wdelete,swin
             goto,display_image
           end
         end 

     end  ;case 's'


;---------------------------
   'b': begin
        click_box3,xll,xur,yll,yur,nra,ndec,nch,AXIS=axis
        draw_boxes3,xll,xur,yll,yur,0,0,AXIS='none',COLOR='FFFFFF'XL

        if (axis eq 'dec') then begin
            polplot=reform(tsm[xll:xur,*,yll:yur,n])
            imgplot1=reform(polplot[*,0,*])
            imgplot2=reform(polplot[*,1,*])
            xarr=sources.ch
            yarr=sources.ra
        endif
        if (axis eq 'ra') then begin
            polplot=reform(tsm[xll:xur,*,n,yll:yur])
            imgplot1=reform(polplot[*,0,*])
            imgplot2=reform(polplot[*,1,*])
            xarr=sources.ch
            yarr=souces.dec
        endif
        if (axis eq 'vel') then begin
            polplot=reform(tsm[n,*,xll:xur,yll:yur])
            imgplot1=reform(polplot[0,*,*])
            imgplot2=reform(polplot[1,*,*])
            xarr=sources.ra
            yarr=sources.dec
        endif

        window,1,retain=2,xsize=450,ysize=800
        !p.multi=[0,2,0,0,0]
        bwin=!d.window

        print,'selected region: ',xll,xur,yll,yur,n

        device, decomposed=0
        imgdisp,imgplot1,position=[0.15,0.52,0.98,0.92],$
          xrange=[xll,xur],yrange=[yll,yur],xstyle=1,ystyle=1,charsize=1.5,/histeq
        device,decomposed=1
        for i=0,nsources-1 do begin
         if (xarr[i] gt xll and xarr[i] lt xur and yarr[i] gt yll and yarr[i] lt yur) then begin
           get_corners3,sources,i,nra,ndec,nch,LLra,URra,LLdec,URdec,LLch,URch
           if (axis eq 'ra') then begin
               opmn=LLra
               opmx=URra
           endif
           if (axis eq 'dec') then begin
               opmn=LLdec
               opmx=URdec
           endif
           if (axis eq 'vel') then begin
               opmn=LLch
               opmx=URch
           endif
           if ((n ge opmn) and (n le opmx)) then draw_boxes3,LLra,URra,LLdec,URdec,LLch,URch,AXIS=axis,COLOR=sources[i].color_pol
         endif
        endfor

        device,decomposed=0
        imgdisp,imgplot2,position=[0.15,0.05,0.98,0.45], $
          xrange=[xll,xur],yrange=[yll,yur],xstyle=1,ystyle=1,charsize=1.5,/histeq
        device,decomposed=1
        for i=0,nsources-1 do begin
         if (xarr[i] gt xll and xarr[i] lt xur and yarr[i] gt yll and yarr[i] lt yur) then begin
           get_corners3,sources,i,nra,ndec,nch,LLra,URra,LLdec,URdec,LLch,URch
           if (axis eq 'ra') then begin
               opmn=LLra
               opmx=URra
           endif
           if (axis eq 'dec') then begin
               opmn=LLdec
               opmx=URdec
           endif
           if (axis eq 'vel') then begin
               opmn=LLch
               opmx=URch
           endif
           if ((n ge opmn) and (n le opmx)) then draw_boxes3,LLra,URra,LLdec,URdec,LLch,URch,AXIS=axis,COLOR=sources[i].color_pol
         endif
        endfor

         line2='string'
         read,'Done?',line2
         case strmid(line2,0,1) of
           'y': begin
             if (!d.window eq bwin) then wdelete,bwin
             goto,display_image
           end
            else: begin
             if (!d.window eq bwin) then wdelete,bwin
             goto,display_image
           end
         end
        end ;end case b

;---------------------------   
   'j': begin   
        if (lineargs ne '') then begin
         reads,lineargs,nchn
         n=fix(nchn)
         goto,display_image
        endif
        end


;---------------------------
   'f': begin
         click_box3,xll,xur,yll,yur,nra,ndec,nch,AXIS=axis
         draw_boxes3,xll,xur,yll,yur,0,0,AXIS='none',COLOR='FFFFFF'XL
         param_select:
         npix=7.
         read,'Minimum number of pixels the source has to appear in? : ',npix
         snth_local=3.0
         read,'S/N threshold? : ',snth_local
         nplane=1
         if (axis ne 'vel') then begin
          read,'Number of planes to search? : ',nplane
         endif

         ex3D_small,tav,xll,xur,yll,yur,n,source,AXIS=axis,SN=snth_local,NPIX=npix,NPLANE=nplane

        if (source.ch eq 0 and source.ra eq 0) then begin
            print,'Sorry!  Nothing in the search region meets these criteria'
            ans='string'
            read,'Try again with new parameters? (y/n) : ',ans
            case strmid(ans,0,1) of
                 'y': begin
                      goto,param_select
                      end
                 'n': begin
                      goto,display_image
                      end
                  else: begin
                        goto,display_image
                        end  
             endcase
         endif

;        print,source
        print,source.ch,source.ra,source.dec,source.w,source.sn, $
              format='("The object found is in channel ",i4," RA: ",i3,"  DEC: ",i3," (w=",f6.2,"km/s  sn=",f6.2,")")'
 
        if (axis eq 'vel') then begin
         x=source.ra
         y=source.dec
        endif
        if (axis eq 'dec') then begin
         x=source.ch
         y=source.ra
        endif
        if (axis eq 'ra') then begin
         x=source.ch
         y=source.dec
        endif
        sigma_m=source.w/(2.3568*5.3)
        peak_m=source.peak_flux
        delta_m=source.ch
        model= peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))
        draw_spectrum3,tav,tsm,model,x,y,n,nch,fwin,AXIS=axis,TITLE=' '

        if (n_elements(mapwindow) ne 0) then wdelete,mapwindow
        disp_drift3,velplane,wplane,cntarr,mapwindow,n,AXIS=axis
        source.color_pol='00FF00'XL
        device,decomposed=1
        plots,x,y,psym=6,symsize=3,color='00FF00'XL
                
         smallmenu:
         line3='string'
         read,'Include it in the catalog? (y/n): ',line3

         case strmid(line3,0,1) of
          'y': begin
                print,'Including source in catalog'
                source.comments=' Man. id. '

                line6='string'
                read,'Comment for this object: ',line6
                source.comments=source.comments+' '+line6+' '
                temp=sources[nextra]
                temp=source
                sources[nextra]=temp
                galinplane[nextra]=1
                if (!d.window ne mapwindow) then wdelete,fwin
                print,'Recorded the following information for galaxy # ',strtrim(nextra,2)
                print,sources[nextra]
                get_corners3,sources,nextra,nra,ndec,nch,LLra,URra,LLdec,URdec,LLch,URch
                print,'Corners are:',LLra,URra,LLdec,URdec,LLch,URch
                nextra=nextra+1
                goto,display_image
               end
          'n': begin
                line4='string'
                read,'Try again with different parameters? (y/n): ',line4
                case strmid(line4,0,1) of
                 'y': begin
                      if (!d.window ne mapwindow) then wdelete,fwin
                      goto,param_select
                      end
                 'n': begin
                      if (!d.window ne mapwindow) then wdelete,fwin
                      goto,display_image
                      end ;end 'n'
                  else: begin
                       if (!d.window ne mapwindow) then wdelete,fwin
                       goto,display_image
                        end 
                endcase
               end
           else: begin
                  print,'I dont understand, please try again!'
                  goto,smallmenu
                 end

         endcase
    end ;end 'f' case


;-------------------------
   'n': begin
         nextbeam:
         break
        end

   '': begin
        goto,nextbeam
       end

;-------------------------
   'e': begin
         goto,ending
        end

   'q': begin
         goto,ending
        end

    else: begin
           print,'This is not a valid option, please try again!'
           goto,menu
          end 

end ;end case statement

endfor ;big loop through cube


ending:

if (n_elements(mapwindow) ne 0) then wdelete,mapwindow

;now writing to the catalogue

for i=0,nsources-1 do begin
  if (sources[i].pol_flag eq 0 or sources[i].pol_flag eq 7) then begin
           ;calculate RADEC and get redshift
           sources[i].cz=gr.velarr[sources[i].ch]
           ra=(gr.ramin+(gr.deltara/3600.)*sources[i].ra)
           if (ra lt 0.) then ra=ra+24.
           dec=(gr.decmin+(gr.deltadec/60.)*sources[i].dec)
           get_radec3,ra,dec,radec
           ;match with AGC
           iagc2=where(agcdata[1,*] gt (ra-0.0033) and $
                      agcdata[1,*] lt (ra+0.0033) and $
                      agcdata[2,*] gt (dec-(3/60.)) and $
                      agcdata[2,*] lt (dec+(3/60.)) and $
                      agcdata[5,*] gt (sources[i].cz-150.) and $
                      agcdata[5,*] lt (sources[i].cz+150.), nagc2)
           if (nagc2 gt 0) then begin
               if (nagc2 eq 1) then sources[i].agc=strtrim(abs(ulong(agcdata[0,iagc2])),2)
               if (nagc2 gt 1) then begin
                   print,'Match found with multiple AGC galaxies'
                   dist_ra=abs(agcdata[1,iagc2]-ra)*15.*60.
                   dist_dec=abs(agcdata[2,iagc2]-dec)*60.
                   mindist=min(sqrt(dist_ra^2+dist_dec^2),minindex)
                   sources[i].agc=strtrim(abs(ulong(agcdata[0,iagc2[minindex]])),2)
               endif
           endif
           ;writing to catalogue
           printf,lun2,i,ra,dec,$
            radec,sources[i].ch,sources[i].ra,sources[i].dec,sources[i].w,sources[i].ara,sources[i].adec,$
            sources[i].peak_flux,sources[i].int_flux,sources[i].sn,sources[i].rms,sources[i].cz,$
            sources[i].agc,sources[i].comments,$
            format='(i3,f10.6,f11.7,a16,i6,i5,i5,f8.3,f9.3,f9.3,f10.3,f10.3,f8.3,f8.3,x,i6,2x,i7,3x,a)'
  endif
endfor

free_lun,lun2

end
