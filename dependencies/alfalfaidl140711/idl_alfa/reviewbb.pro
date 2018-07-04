;+
;NAME:
;flagbb.pro - Displays position-frequency strip maps and modifies pos /st
;
;SYNTAX:
;
; flagbb,m,continuum,cmask,pos,N1=n1,N2=n2,GAUSAV=gausav,HAN=han,$
;             RFIMOD=rfimod,MASK=mask
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
;	cmask	the continuum mask produced by bpd
;
;	pos	the pos /st (e.g. runpos) produced by bpd
;
;KEYWORDS:
;
;	N1	first strip number to process (default 0)
;	N2 	last strip number to process (default nrec-1)
;	GAUSAV	FWHM of a Gaussian weighting function, expresssed in
;		number of records, with which the strip should be
;		convolved, along the strip direction. Def=1
;	HAN	spectral smoothing applied to all spectra of the map,
;		in order to increase the sensitivity of the display.
;		Options are 3-channel, 5-channel and 7-channel Hanning
;		(HAN=3, HAN=5, HAN=7). Def=1
;	AGC	if set, programs searches for AGC galaxies in the vicinity
;		of the drift and overplots their location in (RA,Vel)
;    The following keywords the user probably will never use:
;	MASK	mask of 1 (good pix) and 0 (bad pix) to use for m before
;               convolution. Bad pixels in m are converted to NaN so they
; 		are not used in the smoothing convolution. 
;       RFIMOD "RFI modification" option (def=-1):
;               0, pixels for which maps in strip 7 are .ne.0, are set to zero
;                  in displayed data (strip 7 contains RFI+galHI maps for each pol
;                  in dred structure) 
;               1, maps in strip 7 are subtracted from data
;		2, uses mask to set 'bad' pixels in m to NaN before smoothing
;               -1 or RFIMOD not specified => no "RFI modification"
;
;DESCRIPTION:
;
; Once the drift data have been bandpass calibrated, the user will
; visually inspect the data - ONE BEAM/POL AT A A TIME - and flag 
; bad parts of each 2-D map. This is also the first time in the
; data processing flow that the user gets to take a close look at
; the data. The user will thus use this module to:
; (i) inspect the data
; (ii) flag "bad boxes"
; (iii) enter comments in his/her reduction logfile.
; The coordinates of the regions of bad data in the 2-D map ("badboxes")
; are logged by the program in the "pos" structure, previously created
; by module "bpd". The tag in pos /st that contains this info is
; POS.BADBOX.
;	
; The POS.BADBOX tag tag is an array of integers (100,2,8,4). It
; contains the coords of the corners of up to 100 boxes containing
; parts of the map that are deemed "bad", an especially useful tool
; when the data will be used for gridding and producing clean cubes.
; The first dimension of .BADBOX is the box number; the second is the
; pol number, the third is the beam number and the fourth contains 4
; numbers which are LLch,LLrec,URch,URrec, i.e. the 
; ch nr and rec nr of the lower left (LL) corner of the box 
; and the ch nr and rec nr of the upper right (UR) corner of the box.

; The program uses PP's imgdisp procedure to display, one strip/pol at
; a time, position-frequency maps where the x-axis is chnr and the 
; y-axis is record (sample) nr along the strip. The continuum flux profile 
; profile along the strip is plotted on the side. The upper image is the
; spectral line data, the lower image is the mask used to produce 
; the total power continuum within bpc. The continuum mask shows
; the pixels that were excluded in the computation of total power,
; and it is displayed purely as a reference: you are actually only
; working on the upper plot. The continuum mask follows a conservative
; approach and finds many more "bad" channels than there really are in
; the data. It is however useful to have it as a visual sanity check.
;
; A set of default .BADBOXes are built in the program, to avoid having
; to set them each time. All the default .BADBOXes extend to the full
; duration of a drift (i.e. they are BAD CHANNELS). In the map display,
; they are indicated by red dashes midway through the drift, rather than
; as longitudinal boxes that would prevent from seeing whether the data
; are really bad.  
; After each pol/beam map is smoothed and shown, the user can 
;       (d) delete a bad box
;       (a 1) add a new bad box (just to the current map)
;       (a 7) add a new box to the current and all following maps of the drift
;       (e) exit and proceed to the next map
; Option (d) is used when a default badbox contains data which are actually 
; OK for this drift. Default BADBOXes were set after watching many data
; sets and repeatable patterns. The boundaries of two frequently appearing 
; BADBOXes near the center of the spectrum (near chns 1800 and 3000) are
; reset automaitically for each map after fitting a Gaussian to the RFI
; feature within them, that makes them bad.
; Option (a) allows the user to extract an avg raw or column plot within
; a chosen region, to better identify the bad part of the map. After this
; inspection, user will input LLch,LLrec,URch,URrec and a new badbox will
; have been created (for the beam/pol map).
; After all the beam/pol maps have been thus inspected, the program will
; replace the newly created BADBOX in the POS[n].BADBOX tag corresponding
; to the given drift.
; IF THE PROGRAM CRASHES BEFORE HAVING PROCESSED THE LAST 2-D MAP OF THE
; DRIFT (BEAM 6, POL 1), POS /ST HAS NOT BEEN UPDATED AND YOU NEED TO 
; START ANEW.
;
; AFTER BPD, THE HOUSE RECOMMENDS TO CALL THIS PROGRAM AS FOLLOWS:
;
;	reviewbb,dred,cont_pt,mask,pos,gausav=11,han=3,agc=1
;
; If the user goes through the data of a drift and realizes that a given
; map needs to be revisited, the program can be reloaded only for the
; specific beam (n1=bean_to_redo, n2=beam_to_redo); however, both pols
; will have to be redone, rather than only the one that needs redoing.
;
; RG/05Mar23	
; MH modified 09Jan07 to allow maxrec=150000 for AGC
;
;_____________________________________________________________________

; SUBROUTINE TO DISPLAY IMAGE AND CMASK MAPS; RETURNS mapwindow

pro display_drift,image,cmask,contprof,np=np,ns=ns,mapwindow

; clip is a 2-element array containg max and min clipping levels

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
;xyouts,0,nrec+18.,'Strip='+strtrim(string(ns),2),size=1.5
;xyouts,nchn-200,nrec+18.,'Pol='+strtrim(string(np),2),Size=1.5

end


;___________________________________________________________________

; MAIN PROGRAM

pro reviewbb,	 	$;
	m,		$; input drift structure (e.g. dred)
	continuum,	$; continuum profile (e.g. cont_pt, mc,)
	cmask,		$; mask used by bpc to measure total power
	pos,		$; position /st created by bpd (e.g. runpos) 	
	N1=n1,N2=n2,	$; first and last beam nr (def: 0, 6)
	GAUSAV=gausav,	$; HPFW of Gaussian smoothin in RA. Def=1
	HAN=han,	$; Hanning spectral smoothing. Def=1
	AGC=agc,	$; if set, program overplots AGC galaxies on image. Def=false
	RFIMOD=rfimod,  $; "RFI modification" option (def=-1)
	MASK=mask	 ; RFI mask (use only if RFIMOD=2

; AFTER BPD, THE HOUSE RECOMMENDS:
;	reviewbb,dred,cont_pt,mask,pos,gausav=11,han=3,agc=1

nrec=n_elements(m[0,*,0])
nchn=n_elements(m[0,0,0].d[*])
nstr=n_elements(m[0,0,*])
npol=n_elements(m[*,0,0])
cont=continuum

; MATCH THE LOCATION IN THE POS /ST

index=where(pos.scannumber eq m[0,0,0].h.std.scannumber)
badbox=pos[index].badbox

; READ THE AGCLIST

common agcshare, agcdir
;agcdir='/home/dorado3/galaxy/idl_alfa/'
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

; CHECK INPUTS

if (n_elements(n1) eq 0 ) then begin
   n1 = 0
   n2 = 6
endif
if (n2 gt nstr-1) then n2=nstr-1
if (n_elements(GAUSAV) eq 0) then gausav=1
if (n_elements(HAN) eq 0) then han=1

if (n_elements(RFIMOD) eq 0) then RFIMOD=-1
if (RFIMOD eq 2 and n_elements(MASK) eq 0) then message, $
   'For RFIMOD=2 you must input a MASK'
if (n_elements(units) eq 0) then units = 0

; UNITS DETERMINE SCALING OF CONTINUUM PLOT ALONG EDGE OF MAP
units=1
if (units eq 0 ) then ufact = 3000.
if (units eq 1 ) then ufact = 100.
if (units eq 2 ) then ufact = 1000.
if (units ge 3 ) then ufact = 1.
; CHECK WHICH CONTINUUM INPUT FILE WAS USED AND REDUCE NDIM TO 2
result=size(continuum)
ndim=result[0]
if(ndim eq 3) then cont=reform(continuum[0,*,*])  ; assumes a cont_pt file
if(ndim eq 4) then cont=reform(continuum[7,0,*,*]); assumes an mc file

; SET KERNELS FOR SMOOTHING, INITIALIZE

gausskernel=psf_Gaussian(NPIXEL=41, FWHM=gausav,NDIMEN=1, /NORMALIZE) 
if (han eq 1) then hansmo=[1.]
if (han eq 3) then hansmo=[0.5,1.,0.5]/2.
if (han eq 5) then hansmo=[0.25,0.75,1.,0.75,0.25]/3.
if (han eq 7) then hansmo=[0.146,0.5,0.854,1.,0.854,0.5,0.146]/4.

msmooth=m
msmooth2=m
m_rficor=m
contprof=fltarr(nrec)

; CHECK FOR BAD DATA

nsbad = intarr(nstr)
npbad = intarr(npol)
for ns=n1,n2 do begin
  for np=0,1 do begin
    inn=where(finite(m[np,*,ns].d) eq 0, count)
    tot=total(m[np,*,ns].d)
    if (count gt 2 or tot eq 0.) then begin
      nsbad[ns] = 1
      npbad[np] = 1
      Print,"Bad data on strip ",ns," Pol ",np
      Print,"---------Will flag entire board as bad----"
      ans=''
      read,ans
    endif
  endfor
endfor 

;  IF RFIMOD=2, USE MASK TO SET "BAD" PIX TO NaN, SO THEY'RE NOT USED FOR SMOOTHING
;  IF RFIMOD=1, SUBTRACT FROM m THE RFI SPECTRUM STORED IN STRIP 7
;  IF RFIMOD=0, SET TO 0 m SPECTRAL VALUES FOR WHICH STRIP 7 .NE.0
;  IF RFIMOD=-1 (or not set), LEAVE m UNCHANGED

if (RFIMOD eq 1) then begin
  for ns=n1,n2 do begin
    m_rficor[*,*,ns].d=m[*,*,ns].d-m[*,*,7].d
  endfor
endif
if (RFIMOD eq 0) then begin
  for ns=n1,n2 do begin
    for np=0,1 do begin
      for nr=0,nrec-1 do begin
        zindx = where(m[np,nr,7].d ne 0.,zcount)
        m_rficor[np,nr,ns].d[zindx]=0.
      endfor
    endfor
  endfor
endif
if (RFIMOD eq 2) then begin
  for ns=n1,n2 do begin
    for np=0,1 do begin
      for nr=0,nrec-1 do begin
        imask=where(mask[*,np,nr,ns] eq 0,nmask)
        m_rficor[np,nr,ns].d[imask]=sqrt(-1.)
      endfor
    endfor
  endfor
endif


maxclip=1.
minclip=-1.
Print,'Data display will be clipped at an intensity of +/-1: OK? [y/n, def=y]'
ans=''
read,ans
if (ans eq 'n' or ans eq 'N') then begin
  print,'Enter desired clipping levels: minclip, maxclip'
  read, minclip,maxclip
endif


;..........................................................................

; READY TO GO LOOP THROUGH EACH BEAM, POL

nnn=lindgen(8)
if (n1 eq 0 and n2 eq 6) then nnn=[4,3,5,0,2,6,1,6] ; in Dec order for rotang=19

for nn=n1,n2  do begin
  ns=nnn[nn]
  contprof= cont[*,ns]
  cmax = max(contprof)
  rcmax= where(contprof ge cmax)
; SMOOTH THE MAPS
  for np=0,1 do begin
   print,ns,np,format='("Reviewing ns,np=",2i3)'
   if (npbad[np] eq 1 and nsbad[ns] eq 1) then begin
     msmooth2[np,*,ns].d = 0. 
     seed = 5L
     msmooth2[np,nrec/2,ns].d= RANDOMN(seed,nchn)
     goto, NextPol
   endif

     if (gausav gt 1) then begin
       for i=0,nchn-1 do begin
         smoothedsample=convol(reform(m_rficor[np,*,ns].d[i]), $
                              gausskernel, /EDGE_TRUNCATE,/NAN,MISSING=0)
         msmooth[np,*,ns].d[i]=reform(smoothedsample,1,nrec)     
       endfor
     endif
     msmooth2[np,*,ns].d=msmooth[np,*,ns].d
     if (han gt 1) then begin
       for rec=0, nrec-1 do begin
         smoothedspec = convol(reform(msmooth[np,rec,ns].d),hansmo,$
                          /edge_truncate,/NAN,MISSING=0)
         msmooth2[np,rec,ns].d = smoothedspec
       endfor 
     endif

     if (n_elements(mapwindow) ne 0) then wdelete,mapwindow

     msmooth[np,*,ns].d=msmooth2[np,*,ns].d
     IMAGE=reform(msmooth[np,*,ns].d)
     contm=reform(cmask[*,np,*,ns])

   display_image:
     clipped_image=image
     for nr=0,nrec-1 do begin
       maxch=where(clipped_image[*,nr] gt maxclip,ncl)
       if (ncl gt 0) then clipped_image[maxch,nr]=maxclip
       minch=where(clipped_image[*,nr] lt minclip,ncl)
       if (ncl gt 0) then clipped_image[minch]=minclip
     endfor
     display_drift,clipped_image,contm,contprof*ufact,np=np,ns=ns,mapwindow
     tvlct,255B,0B,0B,128
;    TAG RFI FEATURES ON TOP OF MAP
     xyouts, 215,610,'2',charsize=1.2,color=128
     xyouts, 260,610,'3',charsize=1.2,color=128
     xyouts, 360,610,'4',charsize=1.2,color=128
     xyouts, 590,610,'5',charsize=1.2,color=128
     xyouts, 680,610,'6',charsize=1.2,color=128
     xyouts,1610,610,'7',charsize=1.2,color=128
     xyouts,1840,610,'8',charsize=1.2,color=128
     xyouts,2390,610,'9',charsize=1.2,color=128
     xyouts,2630,610,'10',charsize=1.2,color=128
     xyouts,2830,610,'11',charsize=1.2,color=128
     xyouts,3065,610,'12',charsize=1.2,color=128
     xyouts,3530,610,'13',charsize=1.2,color=128
     xyouts,3610,610,'14',charsize=1.2,color=128
     xyouts,3820,610,'15',charsize=1.2,color=128
     xyouts, 770,610,'16',charsize=1.2,color=128
     xyouts, 880,610,'17',charsize=1.2,color=128
     xyouts, 980,610,'18',charsize=1.2,color=128
     xyouts,2080,610,'19',charsize=1.2,color=128
     xyouts,2220,610,'20',charsize=1.2,color=128
     xyouts,2320,610,'21',charsize=1.2,color=128
     xyouts,3260,610,'22',charsize=1.2,color=128
     xyouts,3390,610,'23',charsize=1.2,color=128

       for nb=0,99 do begin
         if (total(badbox[nb,np,ns,*],4) ne 0) then begin
          LLch=badbox[nb,np,ns,0]
          LLrec=badbox[nb,np,ns,1]
          URch=badbox[nb,np,ns,2]
          URrec=badbox[nb,np,ns,3]
          plots,[LLch,URch],[LLrec,LLrec],linestyle=0,color=128
          plots,[LLch,URch],[URrec,URrec],linestyle=0,color=128
          plots,[LLch,LLch],[LLrec,URrec],linestyle=0,color=128
          plots,[URch,URch],[LLrec,URrec],linestyle=0,color=128
          abit=-20
          if (nb eq 1) then abit=75
          xyouts,(LLch+URch)/2+abit,LLrec-40,strtrim(string(nb),2),charsize=1.5,color=128
         endif
       endfor
;     endif


      if (n_elements(agc) eq 0) then goto, Nextpol
;     IF YOU GOT HERE, FIND the AGC GALS TOUCHED BY the DRIFT AND PLOT THEM IN GREEN
      ra1=msmooth[0,0,ns].rahr
      ra2=msmooth[0,nrec-1,ns].rahr
      dec=msmooth[0,nrec/2,ns].decdeg
    
      iagc=where(agcdata[1,*] gt (ra1-agcdata[3,*]/3600.) and $
               agcdata[1,*] lt (ra2+agcdata[3,*]/3600.) and $
               abs(agcdata[2,*]-dec)*60. lt agcdata[4,*],nagc)
      if (nagc gt 0) then begin
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
          result=min(abs(m[0,*,ns].rahr-agcdata[1,iagc[nla]]),recnr)
          yagc[nla]=round(recnr)
          ddec=abs(decd-dec)*60.
          chn0=agcdata[6,iagc[nla]]
          cz=agcdata[5,iagc[nla]]
          width=agcdata[7,iagc[nla]]
          FI=agcdata[10,iagc[nla]]
          Btype=agcdata[11,iagc[nla]]
          print,agcnr,rh,rm,rs,dd,dm,ds,cz,width,FI/100.,ns,chn0,round(recnr),ddec,Btype, $
              format='(i6,2x,2i2.2,f4.1,1x,3i2.2," cz=",i5," W=",i5," FI=",f6.2,"  - bm=",i2," chnr=",i4," rec=",i4,"   ddec=",f5.2,"  T=",i3)'
        endfor
      endif

      if (nagc gt 0) then begin
        tvlct,255B,255B,0B,128
        ;print, xagc,yagc
        plots,xagc,yagc,psym=6,symsize=3,color=128
      endif

   NextPol:
      print,'Hit CR for new map'
      ans=''
      read,ans
  endfor
endfor   ; closes ns loop

!p.multi=0
wdelete,mapwindow
print,m[0,0,0].h.std.scannumber,index,format='("Reviewed scan:",i9,"  pos index=",i3)'

end
