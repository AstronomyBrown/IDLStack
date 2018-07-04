;+
;NAME:
;strip_agc.pro - Displays position-frequency strip maps, overplotting AGC gals
;
;SYNTAX:
;
; strip_agc,m,continuum,N1=n1,N2=n2,units=units,wait=wait
;
;PARAMETERS:
;
;	m	input file - a map structure of nrec records
;		 	     			nchn spectral channels
;						nstr strips
;						npol (2) polarizations
;	continuum	input file - a continuum map of nrec x nstr, or
;                                    npol x nrec x nstr [e.g. cont_pt], or
;                                    nerg x np x nrec x nstr [e.g. mc]
;
;KEYWORDS:
;
;	N1	first strip number to process (default 0)
;	N2 	last strip number to process (default nrec-1)
;	UNITS	units of the spectral data: 0 - Tsys (default)
;					    1 - Kelvin
;                                           2 - Jy
;                                           3 - mJy
;	WAIT	time in seconds between displays of one strip and the 
;		next. Default = 1 sec
;DESCRIPTION:

;
; RG/21Mar05	started
;_____________________________________________________________________

pro strip_agc,m,continuum,N1=n1,N2=n2,units=units,wait=wait

; READ THE AGCLIST

openr,lun,'/home/dorado3/riccardo/idl_alfa/agc.list',/get_lun
agcdata=fltarr(12,19599)
agcname=strarr(19599)
readf,lun,agcdata,format='(i6,2f9.5,2f6.1,6i6,i8)
point_lun,lun,0
readf,lun,agcname,format='(80x,a9)'
free_lun,lun

nrec=n_elements(m[0,*,0])
nchn=n_elements(m[0,0,0].d[*])
nstr=n_elements(m[0,0,*])
npol=n_elements(m[*,0,0])
cont=continuum


; CHECK INPUTS

if (n_elements(n1) eq 0 ) then begin
   n1 = 0
   n2 = nstr-1
endif
if (n2 gt nstr-1) then n2=nstr-1
if (n_elements(nch1) eq 0 ) then begin
   nch1 = 0
   nch2 = nchn-1
endif
if (n_elements(wait) eq 0) then begin
   stare = 1.
endif else begin
   stare = wait
endelse

if (n_elements(units) eq 0) then begin
   units = 0
endif
; UNITS DETERMINE SCALING OF CONTINUUM PLOT ALONG EDGE OF MAP
if (units eq 0 ) then ufact = 3000.
if (units eq 1 ) then ufact = 100.
if (units eq 2 ) then ufact = 1000.
if (units ge 3 ) then ufact = 1.
; CHECK WHICH CONTINUUM INPUT FILE WAS USED AND REDUCE NDIM TO 2
result=size(continuum)
ndim=result[0]
if(ndim eq 3) then cont=reform(continuum[0,*,*])  ; assumes a cont_pt file
if(ndim eq 4) then cont=reform(continuum[7,0,*,*]); assumes an mc file

contprof=fltarr(nrec)
window,/free,retain=2,xsize=960,ysize=768
loadct, 1

nnn=lindgen(8)
if (n1 eq 0 and n2 eq 6) then nnn=[4,3,5,0,2,6,1,6] ; in Dec order for rotang=19

for nn=n1,n2  do begin
   ns=nnn[nn]
   contprof= cont[*,ns]
   cmax = max(contprof)
   rcmax= where(contprof ge cmax)
;  FIND the AGC GALS TOUCHED BY the DRIFT
   ra1=m[0,0,ns].rahr
   ra2=m[0,nrec-1,ns].rahr
   dec=m[0,nrec/2,ns].decdeg
   
   iagc=where(agcdata[1,*] gt (ra1-agcdata[3,*]/3600.) and $
              agcdata[1,*] lt (ra2+agcdata[3,*]/3600.) and $
              abs(agcdata[2,*]-dec)*60. lt agcdata[4,*],nagc)
   if (nagc gt 0) then begin
     xagc=agcdata[6,iagc]
     yagc=agcdata[6,iagc]
     for nla=0,nagc-1 do begin
       agcnr=agcdata[0,iagc[nla]]
       rahr=agcdata[1,iagc[nla]]
       decd=agcdata[2,iagc[nla]]
       result=min(abs(m[0,*,ns].rahr-agcdata[1,iagc[nla]]),recnr)
       yagc[nla]=round(recnr)
       ddec=abs(decd-dec)*60.
       chn0=agcdata[6,iagc[nla]]
       cz=agcdata[5,iagc[nla]]
       width=agcdata[7,iagc[nla]]
       FI=agcdata[10,iagc[nla]]
       Btype=agcdata[11,iagc[nla]]
       print,agcnr,rahr,decd,cz,width,FI/100.,ns,chn0,round(recnr),ddec,Btype, $
             format='(i6,2f9.5," cz=",i5," W=",i5," FI=",f6.2,"  - bm=",i2," chnr=",i4," rec=",i4,"   ddec=",f4.2,"  T=",i3)'
     endfor
   endif

   !p.multi=[0,2,1,0,0]

   img=reform(m[0,*,ns].d[nch1:nch2])
   device, decomposed=1
   plot,contprof*ufact,findgen(nrec),position=[0.92,0.05,0.98,0.90],$  
        xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
   device, decomposed=0
   imgdisp,img,position=[0.05,0.05,0.89,0.90],/histeq

   if (nagc gt 0) then begin
     tvlct,255B,0B,0B,128
     plots,xagc,yagc,psym=6,symsize=3,color=128
   endif
   xyouts,0,nrec+0.05*nrec,$
              'Strip='+ strtrim(ns,2)+'    Pol=Avg'$
             +'     Dec='+string(m[0,0,ns].decdeg),size=1.5
   xyouts,0,nrec+0.025*nrec,'max cont='+ string(cmax*ufact)$
            +'  at rec '+strtrim(rcmax,2),size=1.5
   wait,stare
   ans=''
   read,ans
endfor   ; closes ns loop

!p.multi=0

end
