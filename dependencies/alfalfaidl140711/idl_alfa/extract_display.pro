;NAME:
; extract_display.pro - Creates an interactive display of a catalog of detections made by extract_compute.pro 
;
;LAST UPDATE: September 19, 2005 by AS
;
;MODIFICATIONS:
;17 Jan 06: allowed for agc.list to have maxrec=100,000 galaxies, a problem first reported for flagbb
;07 Jan 09: allowed for agc.list to have maxrec=150,000 galaxies, a problem first reported for flagbb
;
;--------------------------------------------------------------------------------------------------------------


pro disp_drift,image,cmask,contprof,np=np,ns=ns,mapwindow
if (n_elements(clip) eq 0) then clip=[-1.,1.]
nrec=n_elements(image[0,*])
nchn=n_elements(image[*,0])
window,/free,xsize=1245,ysize=600,retain=2
mapwindow=!d.window
!p.multi=[0,2,2,0,0]
loadct,1
device, decomposed=1
plot,contprof,findgen(nrec),position=[0.925,0.05,0.98,0.245],$
xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
plot,contprof,findgen(nrec),position=[0.925,0.32,0.98,0.95],$
xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
device, decomposed=0
imgdisp,cmask,position=[0.05,0.05,0.89,0.245]
xyouts,0,nrec+18.,'Strip=' +strtrim(string(ns),2)+'  Pol='+strtrim(string(np),2),Size=1.5
xyouts,100,-70,'LOVEDATA, Inc. Ithaca, NY',Size=0.7
imgdisp,image,position=[0.05,0.32,0.89,0.95],/histeq
end

;-------------------------------------------------------------------------------------------

pro make_colours,nsources,sources,nb   ;make color array
 for i=0,nsources-1 do begin
   case sources[nb,i].pol_flag of
       0: sources[nb,i].color_pol='00FF00'XL
       1: sources[nb,i].color_pol='0000FF'XL
       2: sources[nb,i].color_pol='00BBFF'XL
       3: sources[nb,i].color_pol='BBBBFF'XL
       9: sources[nb,i].color_pol='0000FF'XL
       else: sources[nb,i].color_pol='FFFFFF'XL
   endcase
 endfor
end


;-------------------------------------------------------------------------------------------

pro get_radec,ra,dec,radec
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
  dhs=strtrim(dh,2)
  dms=strtrim(dm,2)
  dss=strtrim(ds,2)
  if (dh lt 10) then dhs='0'+strtrim(dh,2)
  if (dm lt 10) then dms='0'+strtrim(dm,2)
  if (ds lt 10) then dss='0'+strtrim(ds,2)
  sign='+'
  if (dec lt 0) then sign='-'
  radec=rahs+rams+rass+rads+sign+dhs+dms+dss
end

;--------------------------------------------------------------------------------------------

pro search_agc,msm,agcdata,nb,nagc,xagc,yagc,iagc,VERBOSE=vrb   ;find the AGC galaxies in this drift and plot them

d=size(msm.d,/dimensions)
nch=d[0]
npol=d[1]
nrec=d[2]
nbeam=d[3]
      ra1=msm[0,0,nb].rahr
      ra2=msm[0,nrec-1,nb].rahr
      dec=msm[0,nrec/2,nb].decdeg
    
      iagc=where(agcdata[1,*] gt (ra1-agcdata[3,*]/3600.) and $
               agcdata[1,*] lt (ra2+agcdata[3,*]/3600.) and $
               abs(agcdata[2,*]-dec)*60. lt agcdata[4,*],nagc)
      if (nagc gt 0) then begin

        if (vrb ne 'no') then print,'AGC SOURCES----------------------------'
        xagc=agcdata[6,iagc]
        yagc=agcdata[6,iagc]
        for nla=0,nagc-1 do begin
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
          result=min(abs(msm[0,*,nb].rahr-agcdata[1,iagc[nla]]),recnr)
          yagc[nla]=round(recnr)
          ddec=abs(decd-dec)*60.
          chn0=agcdata[6,iagc[nla]]
          cz=agcdata[5,iagc[nla]]
          width=agcdata[7,iagc[nla]]
          FI=agcdata[10,iagc[nla]]
          Btype=agcdata[11,iagc[nla]]
          if (vrb ne 'no') then begin
          print,agcnr,rh,rm,rs,dd,dm,ds,cz,width,FI/100.,nb,chn0,round(recnr),ddec,Btype, $
              format='(i6,2x,2i2.2,f4.1,1x,3i2.2," cz=",i5," W=",i5," FI=",f6.2,"  - bm=",i2," chnr=",i4," rec=",i4,"   ddec=",f5.2,"  T=",i3)'
          endif
        endfor
      endif

      if (nagc gt 0) then begin
        tvlct,255B,255B,0B,128
        plots,xagc,yagc,psym=6,symsize=3,color=128
      endif
  end
  
;--------------------------------------------------------------------------------------------

pro draw_boxes,msm,nsources,sources,nb,gain,VERBOSE=vrb,SINGLE=single,EXTRA=extra     ;put boxes around the detections

  if (n_elements(extra) le 0) then extra='no'
  if (n_elements(single) le 0) then single='no'

  if (single ne 'yes') then begin 
  if (vrb ne 'no' and extra eq 'no') then  print,'DETECTIONS-----------------------------'
  if (vrb ne 'no' and extra eq 'yes' and nsources ne 0) then  print,'EXTRA DETECTIONS-----------------------'
   device,decomposed=1
   for i=0,nsources-1 do begin

     ilabel=i
     if (extra eq 'yes') then ilabel=ilabel+50

     if (sources[nb,i].ch gt 0.) then begin
       LLch=sources[nb,i].ch-sources[nb,i].w*3/(2*5.3)
       LLrec=sources[nb,i].rec-sources[nb,i].asize*3
       URch=sources[nb,i].ch+sources[nb,i].w*3/(2*5.3)
       URrec=sources[nb,i].rec+sources[nb,i].asize*3
       if (vrb ne 'no') then begin
       get_radec,msm[0,sources[nb,i].rec,nb].rahr,msm[0,sources[nb,i].rec,nb].decdeg,radec
       print,ilabel,radec,nb,sources[nb,i].ch,sources[nb,i].rec,sources[nb,i].int_flux/gain(nb),sources[nb,i].w, $
            sources[nb,i].sn, $
             format='(i3," ",a16,"   bm=",i2," chnr=",i4," rec=",i4," flux=",f6.2," w=",f6.2," km/s   sn=",f6.2)'
       endif
       plots,[LLch,URch],[LLrec,LLrec],linestyle=0,thick=1.5,color=sources[nb,i].color_pol
       plots,[LLch,URch],[URrec,URrec],linestyle=0,thick=1.5,color=sources[nb,i].color_pol
       plots,[LLch,LLch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[nb,i].color_pol
       plots,[URch,URch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[nb,i].color_pol
       xyouts,(LLch+URch)/2-20,LLrec-40,strtrim(string(ilabel),2),charsize=1.5,charthick=2.5,color=sources[nb,i].color_pol
     endif
 endfor
endif else begin
    if (sources.ch gt 0.) then begin
       LLch=sources.ch-sources.w*3/(2*5.3)
       LLrec=sources.rec-sources.asize*3
       URch=sources.ch+sources.w*3/(2*5.3)
       URrec=sources.rec+sources.asize*3
       if (vrb ne 'no') then begin
       get_radec,msm[0,sources.rec,nb].rahr,msm[0,sources.rec,nb].decdeg,radec
       print,i,radec,nb,sources.ch,sources.rec,sources.int_flux/gain(nb),sources.w, $
            sources.sn, $
             format='(i3," ",a16,"   bm=",i2," chnr=",i4," rec=",i4," flux=",f6.2," w=",f6.2," km/s   sn=",f6.2)'
       endif
       plots,[LLch,URch],[LLrec,LLrec],linestyle=0,thick=1.5,color=sources.color_pol
       plots,[LLch,URch],[URrec,URrec],linestyle=0,thick=1.5,color=sources.color_pol
       plots,[LLch,LLch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources.color_pol
       plots,[URch,URch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources.color_pol
      endif

 endelse
 
end

;-----------------------------------------------------------------------------------------------
pro draw_map,mav,flags,cont_pt,msm,agcdata,nb,nsources,sources,gain,mapwindow,nagc,xagc,yagc,iagc,VERBOSE=vrb
disp_drift,reform(mav[0,*,nb].d),reform(flags[*,0,*,nb]),reform(cont_pt[0,*,nb])*100, $
np=0,ns=nb,mapwindow
search_agc,msm,agcdata,nb,nagc,xagc,yagc,iagc,VERBOSE=vrb
draw_boxes,msm,nsources,sources,nb,gain,VERBOSE=vrb,SINGLE='no'
end


;-----------------------------------------------------------------------------------------------
pro plot_HI,mav,msm,sources,gain,beam,galn,nch
            j=beam
            i=galn
            x=sources[j,i].ch
            y=sources[j,i].rec
            sigma_m=sources[j,i].w/(2.3568*5.3)
            peak_m=sources[j,i].peak_flux
            delta_m=x
            model= peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))       
  
            get_radec,mav[0,sources[j,i].rec,j].rahr,mav[0,sources[j,i].rec,j].decdeg,radec
            window,8,xsize=800,ysize=800,retain=2
            !p.multi=0
            !p.multi=[0,1,2,0,0]
            defback=!p.background
            defcol=!p.color
            !p.background='ffffff'x; white background
            !p.color=0; draw in black
            device,decomposed=1
            blue='FF0000'XL
            red='0000FF'XL
            green='00FF00'XL
	    xmin=0
	    xmax=0
            if (x gt 250 and x lt nch-251) then begin
              xmin=x-250
              xmax=x+250
            endif
            if (x le 250) then begin
              xmin=0
              xmax=500
            endif
            if (x ge nch-251) then begin
              xmin=nch-500
              xmax=nch-1
            endif
            xt=indgen(4096)
            temp=min(mav[0,y,j].d[xmin:xmax])
            plot,xt,mav[0,y,j].d/gain(j)*1000,charsize=2.0,xrange=[xmin,xmax],xstyle=1,thick=2.0, $
               ytitle='Intensity [mJy]',position=[0.15,0.50,0.95,0.85]
            oplot,xt,model/gain(j)*1000,color=blue,thick=2.0
;            arrow,x,temp-8,x,temp-3,color=blue,/data
            xyouts,0.05,0.90,radec+'   w='+strtrim(string(sources(j,i).w),2)+'km/s    S/N='+strtrim(string(sources(j,i).sn),2),charsize=2.0,charthick=1.5,/normal
            plot,xt,msm[0,y,j].d/gain(j)*1000,charsize=2.0,xrange=[xmin,xmax],xstyle=1, $
               xtitle='Channel',ytitle='Intensity [mJy]',position=[0.15,0.15,0.95,0.50],/nodata
            temp=min(msm[*,y,j].d[xmin:xmax])
            oplot,xt,msm[0,y,j].d/gain(j)*1000,color=blue,thick=2.0
            oplot,xt,msm[1,y,j].d/gain(j)*1000,color=red,thick=2.0
;            arrow,x,temp-8,x,temp-3,color=blue,/data

;            print,'Writing HI profile for ',strtrim(radec,2)
;            image=screenread(depth=8)
;            tvlct,r,g,b,/get
;            write_png,radec+'.png',image,r,g,b
;            wdelete,8
            !p.background=defback; black background
            !p.color=defcol; draw in white 

end


;------------------------------------------------------------------------------------------------
pro calc_cz,msm,j,ch,rec,cz
; GLACTC, msm[0,rec,j].rahr, msm[0,rec,j].decdeg, 2000, gl, gb, 1
; frqarr=corfrq(msm[0,rec,j].hf)
; frest=1420.4058
; c=299792
; velarr=((frest-frqarr)/frqarr)*c
; vapex=19.5       ;in km/s
; lapex=56.157337  ;Galactic Long
; bapex=22.765049  ;Galactic Lat
; lapex_r=lapex*!pi/180
; bapex_r=bapex*!pi/180
; gl_r=gl*!pi/180
; gb_r=gb*!pi/180
; cos_p = sin(gb_r)*sin(bapex_r) + cos(gb_r)*cos(bapex_r)*cos(gl_r-lapex_r)
; v_corr=vapex*cos_p
; hvarr=velarr+v_corr
; cz=hvarr[ch]

cenfrq_used=msm[0,rec,j].hf.rpfreq
frqarr=cenfrq_used+(findgen(4096)-2048)*0.024414063
velarr_uncor=299792.458*(1420.4058/frqarr -1.)
heliovelproj=msm[0,rec,j].h.pnt.r.heliovelproj*299792.458
velarr_corr=velarr_uncor+heliovelproj
cz=velarr_corr[ch]
end


;===============================================================================
;MAIN PROGRAM
;===============================================================================

pro extract_display,msm,cont_pt,sources,pos,sources_final,agcdir,SN=snth,DATE=date

t0=systime(1)

pi=3.141592

sigmin=5.           ;minimum template width investigated
sigmax=40.          ;maximum width
delta_sig=1.        ;step between values
sig_size=ceil((sigmax-sigmin)/delta_sig)

nst=0
nstop=4095
nch_cut=(nstop-nst)+1

d=size(msm.d,/dimensions)
nch=d[0]
npol=d[1]
nrec=d[2]
nbeam=d[3]

orderbeams=[4,3,5,0,2,6,1]

;checking how many sources in the catalog for this drift
dd=size(sources,/dimensions)
nsources=dd[1]


; read the AGC list
openr,lun,agcdir+'agc.list',/get_lun
maxrec=150000L
agcdata=dblarr(12,maxrec)
agcname=strarr(maxrec)
record={agcnr:0L,ra:0.D,dec:0.D,item3:0.0,item4:0.0,$
        item5:lonarr(7),aname:''}
nrecords=0L
while(eof(lun) ne 1) do begin
  readf,lun,record,format='(i6,2f9.5,2f6.1,6i6,i8,a9)
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


;OLD AGC CALL
;openr,lun,agcdir+'agc.list',/get_lun
;agcdata=fltarr(12,100000)
;agcname=strarr(100000)
;readf,lun,agcdata,format='(i6,2f9.5,2f6.1,6i6,i8)'
;point_lun,lun,0
;readf,lun,agcname,format='(80x,a9)'
;free_lun,lun


;Finding the BADBOX file within the POS structure for this drift
index_pos=where(pos.scannumber eq msm[0,0,0].h.std.scannumber)
tm=pos.badbox
bb=tm[*,*,*,*,index_pos]

;creating the array with flags from badbox
flags=replicate(1,nch,npol,nrec,nbeam)
for p=0,1 do begin
for j=0,nbeam-2 do begin
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
endfor
endfor


;select the right gain value
gain=replicate(8.5,nbeam)
gain(0)=10.5

;analyse the results matrix

t1=systime(1)

;open file to write results
openu,lun2,'cat'+date+'.dat',/get_lun,/APPEND

;creating structure for additional detections
entry={sources, ch:0,rec:0,w:0.0,asize:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:0,color_pol:'',cz:0.0,agc:'',comments:''}
sources_extra=replicate(entry,nbeam,100)

mav=msm

;checking for existing detections in the final list
finalcount=0
for i=0,999 do begin
  if(sources_final[i].ch eq 0 and sources_final[i].rec eq 0 and sources_final[i].sn eq 0.0) then break
  finalcount=finalcount+1
endfor


for jj=0,nbeam-2 do begin

    mapwindow=998
    swin=999
    pwin=999
    gwin=999
    bwin=999

    j=orderbeams[jj]
   
    mav[0,*,j].d=(msm[0,*,j].d+msm[1,*,j].d)/2

    nextra=0
    
;------------------------------------------
;Display the drift with the sources found

 display_image:

if ((!d.window eq swin) or (!d.window eq pwin) or (!d.window eq gwin) or (!d.window eq bwin)) then begin
  wdelete,!d.window
  wset,mapwindow
endif

;make color array
make_colours,nsources,sources,j

; for i=0,nsources-1 do begin
;   case sources[j,i].pol_flag of
;       0: sources[j,i].color_pol='00FF00'XL
;       1: sources[j,i].color_pol='0000FF'XL
;       2: sources[j,i].color_pol='00BBFF'XL
;       else: sources[j,i].color_pol='FFFFFF'XL
;   endcase
; endfor
make_colours,nextra,sources_extra,j


 if (n_elements(mapwindow) ne 0 and (mapwindow lt 995)) then wdelete,mapwindow
 draw_map,mav,flags,cont_pt,msm,agcdata,j,nsources,sources,gain,mapwindow,nagc,xagc,yagc,iagc,VERBOSE='yes'
 draw_boxes,msm,nextra,sources_extra,j,gain,VERBOSE='yes',EXTRA='yes'

   menu:
 
if ((!d.window eq swin) or (!d.window eq pwin) or (!d.window eq gwin) or (!d.window eq bwin)) then begin
  wdelete,!d.window
  wset,mapwindow
endif

 
   print,'---------------------------------------'

   print,'You can now :  - ignore a detection and remove from catalog          (d galnr or d+click)'
   print,'               - delete ALL galaxies from catalog                    (d 99)'
   print,'               - add a galaxy in the catalog that was rejected       (a galnr or a+click)'
   print,'               - add a comment for a galaxy (no apostrophes!)        (c galnr)'
   print,'               - show the spectrum of a point in the map             (s)'
   print,'               - display the maps for each pol separately            (p)'
   print,'               - blow-up a part of the map (pols. separate)          (b)'
   print,'               - get the DSS image                                   (g)'
   print,'               - find a source in a delimited region                 (f)'
   print,'               - continue with the next beam                         (n or CR)'
   print,'               - exit program                                        (e)'
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

;   if (n_elements(swin) ne 0) then wdelete,swin

   case strmid(line1,0,1) of
   
   'n': begin
        nextbeam:

        for i=0,nsources-1 do begin

          if (sources[j,i].ch eq 0  and sources[j,i].rec eq 0) then break

          calc_cz,msm,j,sources(j,i).ch,sources(j,i).rec,cz
          sources[j,i].cz=cz

          if (nagc gt 0) then begin
             dist_freq=abs(xagc-sources[j,i].ch)
             dist_ra=abs(yagc-sources[j,i].rec)
             match=where((dist_freq lt 20) and (dist_ra lt 20)) ; match= within 20 channels and 5 arcmin (~20 recs)

             if (match[0] ge 0) then begin
              if (n_elements(match) eq 1) then begin
               print,'Match found with AGC galaxy'
               sources[j,i].comments=sources[j,i].comments+' AGC'+strtrim(abs(ulong(agcdata[0,iagc[match]])),2)
               sources[j,i].agc=strtrim(abs(ulong(agcdata[0,iagc[match]])),2)
              endif
              if (n_elements(match) gt 1) then begin
               print,'Match found with multiple AGC galaxies'
               ma=min(dist_ra,ima)
               sources[j,i].comments=sources[j,i].comments+' AGC'+strtrim(abs(ulong(agcdata[0,iagc[ima]])),2)
               sources[j,i].agc=strtrim(abs(ulong(agcdata[0,iagc[ima]])),2)
              endif
             endif
          endif
          if (sources[j,i].pol_flag eq 0) then begin
           printf,lun2,msm[0,sources(j,i).rec,j].rahr,msm[0,sources(j,i).rec,j].decdeg,msm[0,sources(j,i).rec,j].h.std.scannumber,j,$
            sources(j,i).ch,sources(j,i).rec,$
            sources(j,i).w, sources(j,i).asize, sources(j,i).peak_flux/gain(j)*1000, $
            sources(j,i).int_flux/gain(j),$
            sources(j,i).sn, sources(j,i).rms/gain(j)*1000, sources(j,i).cz,$
            sources(j,i).agc,sources(j,i).comments,$
            format='(f10.6,f11.7,i11,i2,i6,i5,f8.3,f9.3,f8.3,f8.3,f8.3,f8.3,x,i6,2x,i7,3x,a)'

           ;also write structure with the HI profile
;           plot_HI,mav,msm,sources,gain,j,i,nch
            ts1=sources[j,i]
            ts2=sources_final[finalcount]
            struct_assign,ts1,ts2
            sources_final[finalcount]=ts2
            sources_final[finalcount].beam=j
            sources_final[finalcount].scannumber=msm[0,0,0].h.std.scannumber
            sources_final[finalcount].sp0=msm[0,sources(j,i).rec,j].d
            sources_final[finalcount].sp1=msm[1,sources(j,i).rec,j].d
            get_radec,msm[0,sources[j,i].rec,j].rahr,msm[0,sources[j,i].rec,j].decdeg,radec
            sources_final[finalcount].radec=radec
            finalcount=finalcount+1
          endif
       endfor
  
       for i=0,nextra-1 do begin
          if (sources_extra[j,i].ch eq 0  and sources_extra[j,i].rec eq 0) then break

          calc_cz,msm,j,sources_extra(j,i).ch,sources_extra(j,i).rec,cz
          sources_extra[j,i].cz=cz

          if (nagc gt 0) then begin
             dist_freq=abs(xagc-sources_extra[j,i].ch)
             dist_ra=abs(yagc-sources_extra[j,i].rec)
             match=where((dist_freq lt 20) and (dist_ra lt 20)) ; match= within 20 channels and 5 arcmin (~20 recs)

             if (match[0] ge 0) then begin
              if (n_elements(match) eq 1) then begin
               print,'Match found with AGC galaxy'
               sources_extra[j,i].comments=sources_extra[j,i].comments+' AGC'+strtrim(abs(ulong(agcdata[0,iagc[match]])),2)
               sources_extra[j,i].agc=strtrim(abs(ulong(agcdata[0,iagc[match]])),2)
              endif
              if (n_elements(match) gt 1) then begin
               print,'Match found with multiple AGC galaxies'
               ma=min(dist_ra,ima)
               sources_extra[j,i].comments=sources_extra[j,i].comments+' AGC'+strtrim(abs(ulong(agcdata[0,iagc[ima]])),2)
               sources_extra[j,i].agc=strtrim(abs(ulong(agcdata[0,iagc[ima]])),2)
              endif
             endif
          endif
          if (sources_extra[j,i].pol_flag eq 0) then begin
           printf,lun2,msm[0,sources_extra(j,i).rec,j].rahr,msm[0,sources_extra(j,i).rec,j].decdeg,msm[0,sources_extra(j,i).rec,j].h.std.scannumber,j,$
            sources_extra(j,i).ch,sources_extra(j,i).rec,$
            sources_extra(j,i).w, sources_extra(j,i).asize, sources_extra(j,i).peak_flux/gain(j)*1000, $
            sources_extra(j,i).int_flux/gain(j),$
            sources_extra(j,i).sn, sources_extra(j,i).rms/gain(j)*1000, sources_extra(j,i).cz,$
            sources_extra(j,i).agc, sources_extra(j,i).comments,$
            format='(f10.6,f11.7,i11,i2,i6,i5,f8.3,f9.3,f8.3,f8.3,f8.3,f8.3,x,i6,2x,i7,3x,a)'
           ;also write file with the HI profile
           ;plot_HI,mav,msm,sources_extra,gain,j,i,nch
            ts1=sources[j,i]
            ts2=sources_final[finalcount]
            struct_assign,ts1,ts2
            sources_final[finalcount]=ts2
            sources_final[finalcount].beam=j
            sources_final[finalcount].scannumber=msm[0,0,0].h.std.scannumber
            sources_final[finalcount].sp0=msm[0,sources_extra(j,i).rec,j].d
            sources_final[finalcount].sp1=msm[1,sources_extra(j,i).rec,j].d
            get_radec,msm[0,sources_extra[j,i].rec,j].rahr,msm[0,sources_extra[j,i].rec,j].decdeg,radec
            sources_final[finalcount].radec=radec
            finalcount=finalcount+1
          endif
       endfor   

       wdelete,mapwindow

        break
    end 

   '': begin
        goto,nextbeam
       end
   
   'd': begin
        if (lineargs eq '') then begin
         print,'Click in the box of the galaxy you want to delete from the catalog:'
         cursor,x,y
         x=round(x)
         y=round(y)
         for i=0,nsources-1 do begin
          if (sources[j,i].ch eq 0  and sources[j,i].rec eq 0) then break
          LLch=sources[j,i].ch-sources[j,i].w*3/(2*5.3)
          LLrec=sources[j,i].rec-sources[j,i].asize*3
          URch=sources[j,i].ch+sources[j,i].w*3/(2*5.3)
          URrec=sources[j,i].rec+sources[j,i].asize*3
          if ((x gt LLch) and (x lt URch) and (y gt LLrec) and (y lt URrec)) then begin
            sources[j,i].pol_flag=9
          endif
         endfor
         for i=0,nextra-1 do begin
          if (sources_extra[j,i].ch eq 0  and sources_extra[j,i].rec eq 0) then break
          LLch=sources_extra[j,i].ch-sources_extra[j,i].w*3/(2*5.3)
          LLrec=sources_extra[j,i].rec-sources_extra[j,i].asize*3
          URch=sources_extra[j,i].ch+sources_extra[j,i].w*3/(2*5.3)
          URrec=sources_extra[j,i].rec+sources_extra[j,i].asize*3
          if ((x gt LLch) and (x lt URch) and (y gt LLrec) and (y lt URrec)) then begin
            sources_extra[j,i].pol_flag=9
          endif
         endfor
         goto,display_image
        endif

        if (lineargs ne '') then begin
         reads,lineargs,ngal
         if (ngal lt 50) then sources[j,ngal].pol_flag=9
         if (ngal ge 50) then sources_extra[j,(ngal-50)].pol_flag=9
         if (ngal eq 99) then sources[j,*].pol_flag=9
         goto,display_image
        endif
        end

   'c': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,ngal
        print,'Enter your comment: '
        text=''
        read,text
        if (ngal lt 50) then sources[j,fix(ngal)].comments=sources[j,fix(ngal)].comments+text
        if (ngal ge 50) then sources_extra[j,fix(ngal)-50].comments=sources_extra[j,fix(ngal)-50].comments+text
        print,'Comment recorded for galaxy '+strtrim(fix(ngal),2)
        goto,menu
        end

   'a': begin
        if (lineargs eq '') then begin
         print,'Click in the box of the galaxy you want to add to the catalog:'
         cursor,x,y
         x=round(x)
         y=round(y)
         for i=0,nsources-1 do begin
          if (sources[j,i].ch eq 0  and sources[j,i].rec eq 0) then break
          LLch=sources[j,i].ch-sources[j,i].w*3/(2*5.3)
          LLrec=sources[j,i].rec-sources[j,i].asize*3
          URch=sources[j,i].ch+sources[j,i].w*3/(2*5.3)
          URrec=sources[j,i].rec+sources[j,i].asize*3
          if ((x gt LLch) and (x lt URch) and (y gt LLrec) and (y lt URrec)) then begin
            if (sources[j,i].pol_flag eq 1 ) then sources[j,i].comments=sources[j,i].comments+' Extr.rej.(pol) '
            if (sources[j,i].pol_flag eq 2 ) then sources[j,i].comments=sources[j,i].comments+' Extr.rej.(S/N) '
            if (sources[j,i].pol_flag eq 3 ) then sources[j,i].comments=sources[j,i].comments+' Extr.rej.(edge) '
            sources[j,i].pol_flag=0
          endif
         endfor
          for i=0,nextra-1 do begin
          if (sources_extra[j,i].ch eq 0  and sources_extra[j,i].rec eq 0) then break
          LLch=sources_extra[j,i].ch-sources_extra[j,i].w*3/(2*5.3)
          LLrec=sources_extra[j,i].rec-sources_extra[j,i].asize*3
          URch=sources_extra[j,i].ch+sources_extra[j,i].w*3/(2*5.3)
          URrec=sources_extra[j,i].rec+sources_extra[j,i].asize*3
          if ((x gt LLch) and (x lt URch) and (y gt LLrec) and (y lt URrec)) then begin
            if (sources_extra[j,i].pol_flag eq 1 ) then sources_extra[j,i].comments=sources_extra[j,i].comments+' Extr.rej.(pol) '
            if (sources_extra[j,i].pol_flag eq 2 ) then sources_extra[j,i].comments=sources_extra[j,i].comments+' Extr.rej.(S/N) '
            if (sources_extra[j,i].pol_flag eq 3 ) then sources_extra[j,i].comments=sources_extra[j,i].comments+' Extr.rej.(edge) '
            sources_extra[j,i].pol_flag=0
          endif
         endfor
         goto,display_image
        endif        
        if (lineargs ne '') then begin
         reads,lineargs,ngal
         ngal=fix(ngal)
         if (ngal lt 50) then begin
            if (sources[j,ngal].pol_flag eq 1 ) then sources[j,ngal].comments=sources[j,ngal].comments+' Extr.rej.(pol) '
            if (sources[j,ngal].pol_flag eq 2 ) then sources[j,ngal].comments=sources[j,ngal].comments+' Extr.rej.(S/N) '
            if (sources[j,ngal].pol_flag eq 3 ) then sources[j,ngal].comments=sources[j,ngal].comments+' Extr.rej.(edge) '
             sources[j,ngal].pol_flag=0
         endif
         if (ngal ge 50) then begin
            sources_extra[j,ngal-50].pol_flag=0
         endif 
         goto,display_image
        endif
        end
   

   'p': begin
        window,1,retain=2,xsize=768,ysize=614
        pwin=!d.window
        !p.multi=[0,2,0,0,0]
        device, decomposed=0
        imgdisp,reform(msm[0,*,j].d),position=[0.05,0.52,0.98,0.92],/histeq
        xyouts,0,nrec+18.,$
          'Strip='+string(j)+'      Dec ='+string(msm[0,0,j].decdeg),size=1.5
        xyouts,nch-200,nrec+18.,'Pol=0',Size=1.5
        device,decomposed=1
        for i=0,nsources-1 do begin
         if (sources[j,i].ch gt 0.) then begin

           LLch=sources[j,i].ch-sources[j,i].w*3/(2*5.3)
           LLrec=sources[j,i].rec-sources[j,i].asize*3
           URch=sources[j,i].ch+sources[j,i].w*3/(2*5.3)
           URrec=sources[j,i].rec+sources[j,i].asize*3
           print,i,j,sources[j,i].ch,sources[j,i].rec,sources[j,i].int_flux/gain(j),$
                 sources[j,i].diff_pol,sources[j,i].pol_flag, sources[j,i].sn, $
             format='(i3,"   bm=",i2," chnr=",i4," rec=",i4," flux=",f6.2," diff=",f10.5,"   ",i2," sn=",f10.5)'
           plots,[LLch,URch],[LLrec,LLrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,URch],[URrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,LLch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[URch,URch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           xyouts,(LLch+URch)/2-20,LLrec-40,strtrim(string(i),2),charsize=1.5,$
                  charthick=2.5,color=sources[j,i].color_pol
          endif
        endfor
        device,decomposed=0
        imgdisp,reform(msm[1,*,j].d),position=[0.05,0.05,0.98,0.45],/histeq
        xyouts,nch-200,nrec+18.,'Pol=1',Size=1.5
        device,decomposed=1
        for i=0,nsources-1 do begin
         if (sources[j,i].ch gt 0.) then begin
           LLch=sources[j,i].ch-sources[j,i].w*3/(2*5.3)
           LLrec=sources[j,i].rec-sources[j,i].asize*3
           URch=sources[j,i].ch+sources[j,i].w*3/(2*5.3)
           URrec=sources[j,i].rec+sources[j,i].asize*3
           print,i,j,sources[j,i].ch,sources[j,i].rec,sources[j,i].int_flux/gain(j),$
                 sources[j,i].diff_pol,sources[j,i].pol_flag, sources[j,i].sn, $
             format='(i3,"   bm=",i2," chnr=",i4," rec=",i4," flux=",f6.2," diff=",f10.5,"   ",i2," sn=",f10.5)'
           plots,[LLch,URch],[LLrec,LLrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,URch],[URrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,LLch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[URch,URch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           xyouts,(LLch+URch)/2-20,LLrec-40,strtrim(string(i),2),charsize=1.5,$
                  charthick=2.5,color=sources[j,i].color_pol
         endif
        endfor

        line2='string'
        read,'Done?',line2
        case strmid(line2,0,1) of
           'y': begin
             goto,menu
           end
            else: begin
             goto,menu
           end
        end

;        goto,menu
        end

   's': begin
         if (n_elements(mapwindow) ne 0) then wdelete,mapwindow
         draw_map,mav,flags,cont_pt,msm,agcdata,j,nsources,sources,gain,mapwindow,nagc,xagc,yagc,iagc,VERBOSE='no'
         if (nextra ne 0) then draw_boxes,msm,nextra,sources_extra,j,gain,VERBOSE='no',EXTRA='yes'
        if (lineargs eq '') then begin
         print,'Left-click at the position for which you wish to get the spectrum'
         cursor,xc,yc
         print,xc,yc
         x=round(xc)
         y=round(yc)
         if ((x lt 0) or (y lt 0) or (x gt nch-1) or (y gt nrec-1)) then begin 
            print,'Out of bounds, try again!'
            goto,menu
         endif
         window,xsize=1000,ysize=500,/free,retain=2
         swin=!d.window
         !p.multi=[0,1,2,0,0]
         device,decomposed=1
         blue='FF0000'XL
         red='0000FF'XL
         green='00FF00'XL
	 xmin=0
	 xmax=0
         if (x gt 250 and x lt nch-251) then begin
            xmin=x-250
            xmax=x+250
         endif
         if (x le 250) then begin
            xmin=0
            xmax=500
         endif
         if (x ge nch-251) then begin
            xmin=nch-500
            xmax=nch-1
         endif
         xt=indgen(4096)
         temp=min(mav[0,y,j].d[xmin:xmax])
         plot,xt,mav[0,y,j].d,charsize=1.5,xrange=[xmin,xmax],xstyle=1
         arrow,x,temp-0.04,x,temp+0.015,color=green,/data
         plot,xt,msm[0,y,j].d,charsize=1.5,xrange=[xmin,xmax],xstyle=1,/nodata
         temp=min(msm[*,y,j].d[xmin:xmax])
         oplot,xt,msm[0,y,j].d,color=blue
         oplot,xt,msm[1,y,j].d,color=red
         arrow,x,temp-0.04,x,temp+0.015,color=green,/data
       endif  ;if there is no argument


        if (lineargs ne '') then begin
         reads,lineargs,ngal
         ngal=fix(ngal)
         if (ngal lt 50) then begin
          x=sources[j,ngal].ch
          y=sources[j,ngal].rec
          sigma_m=sources[j,ngal].w/(2.3568*5.3)
          peak_m=sources[j,ngal].peak_flux
         endif
         if (ngal ge 50) then begin
          x=sources_extra[j,ngal-50].ch
          y=sources_extra[j,ngal-50].rec
          sigma_m=sources_extra[j,ngal-50].w/(2.3568*5.3)
          peak_m=sources_extra[j,ngal-50].peak_flux
         endif
         delta_m=x
         model= peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))       
         if ((x lt 0) or (y lt 0) or (x gt nch-1) or (y gt nrec-1)) then begin 
            print,'Out of bounds, try again!'
            goto,menu
         endif
         window,xsize=1000,ysize=500,/free,retain=2
         swin=!d.window
         !p.multi=[0,1,2,0,0]
         device,decomposed=1
         blue='FF0000'XL
         red='0000FF'XL
         green='00FF00'XL
	 xmin=0
	 xmax=0
         if (x gt 250 and x lt nch-251) then begin
            xmin=x-250
            xmax=x+250
         endif
         if (x le 250) then begin
            xmin=0
            xmax=500
         endif
         if (x ge nch-251) then begin
            xmin=nch-500
            xmax=nch-1
         endif
         xt=indgen(4096)
         temp=min(mav[0,y,j].d[xmin:xmax])
         plot,xt,mav[0,y,j].d,charsize=1.5,xrange=[xmin,xmax],xstyle=1
         oplot,xt,model,color=green
         arrow,x,temp-0.04,x,temp+0.015,color=green,/data
         plot,xt,msm[0,y,j].d,charsize=1.5,xrange=[xmin,xmax],xstyle=1,/nodata
         temp=min(msm[*,y,j].d[xmin:xmax])
         oplot,xt,msm[0,y,j].d,color=blue
         oplot,xt,msm[1,y,j].d,color=red
;         oplot,xt,model,color=green
         arrow,x,temp-0.04,x,temp+0.015,color=green,/data
;         goto,menu
        endif

        line2='string'
        read,'Done?',line2
        case strmid(line2,0,1) of
           'y': begin
             goto,menu
           end
            else: begin
             goto,menu
           end
        end

        end ;s case


   'b': begin
        print,'Left-click on lower left corner of region to blow-up:'
        cursor,xll,yll
        xll=round(xll)
        yll=round(yll)
        if (xll lt 0) then xll=0
        if (yll lt 0) then yll=0
        wait,0.6
        print,'Left-click on upper right corner of region to blow-up:'
        cursor,xur,yur
        xur=round(xur)
        yur=round(yur)
        if (xur gt nch-1) then xur=nch-1
        if (yur gt nrec-1) then yur=nrec-1
        wait,0.6
        white='FFFFFF'XL
        plots,[xll,xur],[yll,yll],color=white,thick=2
        plots,[xll,xur],[yur,yur],color=white,thick=2
        plots,[xll,xll],[yll,yur],color=white,thick=2
        plots,[xur,xur],[yll,yur],color=white,thick=2

        polplot=msm[*,yll:yur,*].d[xll:xur]

        window,1,retain=2,xsize=450,ysize=800
        !p.multi=[0,2,0,0,0]
        bwin=!d.window
        device, decomposed=0
        imgdisp,reform(polplot[*,0,*,j]),position=[0.15,0.52,0.98,0.92],$
          xrange=[xll,xur],yrange=[yll,yur],xstyle=1,ystyle=1,charsize=1.5,/histeq
;        xyouts,0,nrec+18.,$
;          'Strip='+string(j)+'      Dec ='+string(msm[0,0,j].decdeg),size=1.5
;        xyouts,nch-200,nrec+18.,'Pol=0',Size=1.5
        device,decomposed=1

        for i=0,nsources-1 do begin
         if (sources[j,i].ch gt 0.) then begin

           LLch=sources[j,i].ch-sources[j,i].w*3/(2*5.3)
           LLrec=sources[j,i].rec-sources[j,i].asize*3
           URch=sources[j,i].ch+sources[j,i].w*3/(2*5.3)
           URrec=sources[j,i].rec+sources[j,i].asize*3
;           print,i,j,sources[j,i].ch,sources[j,i].rec,sources[j,i].int_flux/gain(j),$
;                 sources[j,i].diff_pol,sources[j,i].pol_flag, sources[j,i].sn, $
;             format='(i3,"   bm=",i2," chnr=",i4," rec=",i4," flux=",f6.2," diff=",f10.5,"   ",i2," sn=",f10.5)'
           plots,[LLch,URch],[LLrec,LLrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,URch],[URrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,LLch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[URch,URch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
;           xyouts,(LLch+URch)/2-20,LLrec-40,strtrim(string(i),2),charsize=1.5,$
;                  charthick=2.5,color=sources[j,i].color_pol
          endif
        endfor
        device,decomposed=0
        imgdisp,reform(polplot[*,1,*,j]),position=[0.15,0.05,0.98,0.45],$
          xrange=[xll,xur],yrange=[yll,yur],xstyle=1,ystyle=1,charsize=1.5,/histeq
;        xyouts,nch-200,nrec+18.,'Pol=1',Size=1.5
        device,decomposed=1
        for i=0,nsources-1 do begin
         if (sources[j,i].ch gt 0.) then begin
           LLch=sources[j,i].ch-sources[j,i].w*3/(2*5.3)
           LLrec=sources[j,i].rec-sources[j,i].asize*3
           URch=sources[j,i].ch+sources[j,i].w*3/(2*5.3)
           URrec=sources[j,i].rec+sources[j,i].asize*3
;           print,i,j,sources[j,i].ch,sources[j,i].rec,sources[j,i].int_flux/gain(j),$
;                 sources[j,i].diff_pol,sources[j,i].pol_flag, sources[j,i].sn, $
;             format='(i3,"   bm=",i2," chnr=",i4," rec=",i4," flux=",f6.2," diff=",f10.5,"   ",i2," sn=",f10.5)'
           plots,[LLch,URch],[LLrec,LLrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,URch],[URrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[LLch,LLch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
           plots,[URch,URch],[LLrec,URrec],linestyle=0,thick=1.5,color=sources[j,i].color_pol
;           xyouts,(LLch+URch)/2-20,LLrec-40,strtrim(string(i),2),charsize=1.5,$
;                  charthick=2.5,color=sources[j,i].color_pol
         endif
        endfor
         line2='string'
         read,'Done?',line2
         case strmid(line2,0,1) of
           'y': begin
             goto,display_image
           end
            else: begin
             goto,display_image
           end
         end
        end ;end case b


   'f': begin
         if (n_elements(mapwindow) ne 0) then wdelete,mapwindow
         draw_map,mav,flags,cont_pt,msm,agcdata,j,nsources,sources,gain,mapwindow,nagc,xagc,yagc,iagc,VERBOSE='no'
        if (nextra ne 0) then draw_boxes,msm,nextra,sources_extra,j,gain,VERBOSE='no',EXTRA='yes'
        print,'Left-click on lower left corner of region to search:'
        cursor,xll,yll
        xll=round(xll)
        yll=round(yll)
        if (xll lt 0) then xll=0
        if (xll gt nch-1) then xll=nch-1
        if (yll lt 0) then yll=0
        if (yll gt nrec-1) then yll=nrec-1
        wait,0.8
        print,'Left-click on upper right corner of region to search:'
        cursor,xur,yur
        xur=round(xur)
        yur=round(yur)

        if (xur lt 0) then xur=0
        if (xur gt nch-1) then xur=nch-1
        if (yur lt 0) then yur=0
        if (yur gt nrec-1) then yur=nrec-1
        wait,0.2
        white='FFFFFF'XL
        plots,[xll,xur],[yll,yll],color=white,thick=2
        plots,[xll,xur],[yur,yur],color=white,thick=2
        plots,[xll,xll],[yll,yur],color=white,thick=2
        plots,[xur,xur],[yll,yur],color=white,thick=2


        param_select:
        nrec_min=5
        read,'Minimum number of record the source has to appear in? : ',nrec_min

        snth_local=3.0
        read,'S/N threshold? : ',snth_local

        extract_small,mav,xll,xur,yll,yur,j,source,SN=snth_local,NREC_MIN=nrec_min

        if (source.ch eq 0 and source.rec eq 0) then begin
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
        
        print,source.ch,source.rec,source.w,source.sn, $
              format='("The object found is in channel ",i4," record ",i3," (w=",f6.2,"km/s  sn=",f6.2,")")'

         x=source.ch
         y=source.rec
         !p.multi=[0,1,2,0,0]
         device,decomposed=1
         blue='FF0000'XL
         red='0000FF'XL
         green='00FF00'XL
	 xmin=0
	 xmax=0
         if (x gt 250 and x lt nch-251) then begin
            xmin=x-250
            xmax=x+250
         endif
         if (x le 250) then begin
            xmin=0
            xmax=500
         endif
         if (x ge nch-251) then begin
            xmin=nch-500
            xmax=nch-1
         endif
        
         window,xsize=1000,ysize=500,/free,retain=2
         sigma_m=source.w/(2.3568*5.3)
         peak_m=source.peak_flux
         delta_m=x
         model= peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2)) 

         xt=indgen(4096)
         temp=min(mav[0,y,j].d[xmin:xmax])
         plot,xt,mav[0,y,j].d,charsize=1.5,xrange=[xmin,xmax],xstyle=1
         oplot,xt,model,color=green
         arrow,x,temp-0.04,x,temp+0.015,color=green,/data
         plot,xt,msm[0,y,j].d,charsize=1.5,xrange=[xmin,xmax],xstyle=1,/nodata
         temp=min(msm[*,y,j].d[xmin:xmax])
         oplot,xt,msm[0,y,j].d,color=blue
         oplot,xt,msm[1,y,j].d,color=red
         arrow,x,temp-0.04,x,temp+0.015,color=green,/data

         if (n_elements(mapwindow) ne 0) then wdelete,mapwindow
         draw_map,mav,flags,cont_pt,msm,agcdata,j,nsources,sources,gain,mapwindow,nagc,xagc,yagc,iagc,VERBOSE='no'
         source.color_pol='00FF00'XL 
         draw_boxes,msm,1,source,j,gain,VERBOSE='no',SINGLE='yes'


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
                print,source.comments
;                printf,lun2,msm[0,source.rec,j].rahr,msm[0,source.rec,j].decdeg,msm[0,source.rec,j].h.std.scannumber,j,$
;                  source.ch,source.rec,$
;                  source.w, source.asize, source.peak_flux/gain(j)*1000, $
;                  source.int_flux/gain(j),$
;                  source.sn, source.rms/gain(j)*1000,source.comments,$
;                   format='(f10.6,f11.7,i11,i2,i6,i5,f8.3,f9.3,f8.3,f8.3,f8.3,f8.3,3x,a)'
                sources_extra[j,nextra]=source
                nextra=nextra+1 
                goto,display_image
               end
          'n': begin
                line4='string'
                read,'Try again with different parameters? (y/n): ',line4
                case strmid(line4,0,1) of
                 'y': begin
                      goto,param_select
                      end
                 'n': begin
                      goto,display_image
                      end ;end 'n'
                  else: begin
                       goto,display_image
                        end 
                endcase
               end
           else: begin
                  print,'I dont understand, please try again!'
                  goto,smallmenu
                 end

         endcase

        line2='string'
        read,'Done?',line2
        case strmid(line2,0,1) of
           'y': begin
             goto,menu
           end
            else: begin
             goto,menu
           end
        end        

    end ;end case 'f'


   'g': begin
         if (n_elements(mapwindow) ne 0) then wdelete,mapwindow
         draw_map,mav,flags,cont_pt,msm,agcdata,j,nsources,sources,gain,mapwindow,nagc,xagc,yagc,iagc,VERBOSE='no'
         if (nextra ne 0) then draw_boxes,msm,nextra,sources_extra,j,gain,VERBOSE='no',EXTRA='yes'
         print,'Left-click on point for which you wish to get the image'
         cursor,x,y
         print,x,y
         x=round(x)
         y=round(y)
         if ((x lt 0) or (y lt 0) or (x gt nch-1) or (y gt nrec-1)) then begin 
            print,'Out of bounds, try again!'
            goto,menu
         endif
         ra=msm[0,y,j].rahr
         dec=msm[0,y,j].decdeg
         coords=[ra*15.0,dec]
         radius=5.0
         querydss, coords, image, Hdr, survey='2b', imsize=radius
;         window,xsize=700,ysize=700,/free,retain=2
;         gwin=!d.window
         !p.multi=0
         gwin=!d.window
         device,decomposed=0
         imgdisp,image,/invert
         goto,menu
        end


   'e': goto,ending

   else: begin
           print,'Wrong command, try again!'
           goto,menu
         end

   endcase

endfor

ending:

free_lun,lun2
;if (n_elements(mapwindow) ne 0) then wdelete,mapwindow

end ;procedure

