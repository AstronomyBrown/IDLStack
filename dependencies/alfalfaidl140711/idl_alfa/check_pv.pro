;+
;NAME:
;check_pv.pro - Displays position-frequency strip maps and modifies pos /st
;
;SYNTAX:
;
; check_pv,m,continuum,cmask,pos,N1=n1,N2=n2,GAUSAV=gausav,HAN=han,$
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
;	check_pv,dred,cont_pt,mask,pos,gausav=11,han=3
;
; If the user goes through the data of a drift and realizes that a given
; map needs to be revisited, the program can be reloaded only for the
; specific beam (n1=bean_to_redo, n2=beam_to_redo); however, both pols
; will have to be redone, rather than only the one that needs redoing.
;
; RG/05Mar23	
;
;_____________________________________________________________________

; SUBROUTINE TO DISPLAY IMAGE AND CMASK MAPS; RETURNS mapwindow

pro display_drift,image,cmask,contprof,np=np,ns=ns,mapwindow

nrec=n_elements(image[0,*])
nchn=n_elements(image[*,0])
window,/free,xsize=1245,ysize=768,retain=2
mapwindow=!d.window
!p.multi=[0,2,2,0,0]
device, decomposed=1
plot,contprof,findgen(nrec),position=[0.92,0.05,0.98,0.45],$  
     xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
plot,contprof,findgen(nrec),position=[0.92,0.52,0.98,0.92],$  
     xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
device, decomposed=0
imgdisp,cmask,position=[0.05,0.05,0.89,0.45]
xyouts,0,nrec+18.,'Strip=' +strtrim(string(ns),2)+'   Cont mask',size=1.5
xyouts,nchn-200,nrec+18.,'Pol='+strtrim(string(np),2),Size=1.5
imgdisp,image,position=[0.05,0.52,0.89,0.92],/histeq
xyouts,0,nrec+18.,'Strip='+strtrim(string(ns),2),size=1.5
xyouts,nchn-200,nrec+18.,'Pol='+strtrim(string(np),2),Size=1.5

end

;______________________________________________________________________

; SUBROUTINE TO DISPLAY REGIONS OF MAP, FOR VISUAL INSPECTION
; MAPWINDOW IS INPUT HERE

pro check_drift,image,mapwindow=mapwindow

nchn = n_elements(image[*,0])
nrec = n_elements(image[0,*])


select_box:

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
    plots,[xpos1,xpos2],[ypos1,ypos1],color=12,thick=2
    plots,[xpos1,xpos2],[ypos2,ypos2],color=12,thick=2
    plots,[xpos1,xpos1],[ypos1,ypos2],color=12,thick=2
    plots,[xpos2,xpos2],[ypos1,ypos2],color=12,thick=2
print,round(xpos1),round(ypos1),round(xpos2),round(ypos2),format='(4(i4,","))'
hor
ver
while 1 do begin
  menu:
  print,'_______________________________________________________'
  print,''
  print,'KEY  ARGS      FUNCTION'
  print,'s    : get stats within the box'
  print,'c    : col plot: horiz avg and plot as a f(recnr)'
  print,'r    : row plot: vert  avg and plot as a f(chnr)'
  print,'b    : select a new box'
  print,'q    : quit'
  char=''
  read,char

  case char of
    'q': goto,done

    's': begin
         print,'Mean =',mean(image[xpos1:xpos2,ypos1:ypos2])
         print,'Var  =',variance(image[xpos1:xpos2,ypos1:ypos2])
         print,'Stdev=',stddev(image[xpos1:xpos2,ypos1:ypos2])
         end
    'c': begin
         hor,ypos1,ypos2
         xarr=findgen(nrec)
         yarr=total(image[xpos1:xpos2,*],1)/(xpos2-xpos1+1)
         window,/free,xsize=700,ysize=450,xpos=430,ypos=450
         !p.multi=0
         specwindow=!d.window
         plot,xarr,yarr
         end
    'r': begin
         hor,xpos1,xpos2
         xarr=findgen(nchn)
         yarr=total(image[*,ypos1:ypos2],2)/(ypos2-ypos1+1)
         window,/free,xsize=700,ysize=450,xpos=430,ypos=450
         !p.multi=0
         specwindow=!d.window
         plot,xarr,yarr
         end
    'b': begin
         if (n_elements(specwindow) ne 0) then wdelete,specwindow
         goto, select_box
         end
    else: goto,menu
  endcase
endwhile

done:
if (n_elements(specwindow) ne 0) then wdelete,specwindow
hor
ver
end

;___________________________________________________________________


pro print_badbox,badbox,np,ns,nbad,line1=line1,lineargs=lineargs

; PRINTS BADBOX FOR THE GIVEN NP,NS, RETURNS LINE1, LINEARGS

   print,'---------------------------------------'     
   print,ns,np,format='("Pix boxes thought bad for BEAM",i2," POL",i2)'
   print,'---------------------------------------' 
   Print,' Box nr  LLch    LLrec   URch   URrec'
   print,'---------------------------------------' 
   for nb=0,nbad-1 do begin
     Print,nb,badbox[nb,np,ns,*],format='(3x,i2,4(4x,i4))'
   endfor
   print,'---------------------------------------' 

   print,'You can now :  - delete a box (d boxnr)'
   print,'               - add a box only to this map (a 1)'
   print,'               - add a box for all bm/pol left (a 7)'
   print,'               - modify a box just for this bm/pol (m boxnr)'
   print,'               - exit & go to next map (e)'
   line1='string'
   read,'?',line1
   line=strtrim(strlowcase(line1),1) ; convrt to lowercase & remv leading blnks
   itemp=strpos(line1,' ') ; find char nr w 1ast occurrence of blnk
   len=strlen(line1) ; nr of chars in line
   if (itemp ne -1) and((itemp+1) le len) then begin
    lineargs=strmid(line1,itemp+1,len-(itemp)) ; contains args, e.g. 'd 3'
   endif else begin
    lineargs=''
   endelse

end

;___________________________________________________________________

pro find_35,pvmap,np,ns,badbox

; FINDS THE EXACT LOCATION OF BADBOX(RFI) PEAKS 3 and 5
; pvmap SHOULD BE (4096X600)

profile=total(pvmap,2)/n_elements(pvmap[*,0])
nch1=badbox[3,np,ns,0]
nch2=badbox[3,np,ns,2]
peak=max(profile[nch1:nch2],maxind)
maxind=maxind+nch1
x=findgen(4096)
y=profile
ymed=median(profile)
seed=7L
y[0:nch1-100]=ymed*RANDOMN(seed,nch1-100+1)
y[nch2+100:4095]=ymed*RANDOMN(seed,4096-nch2-100)
est=[peak,maxind,5.]
result=GAUSSFIT(x,y,A,nterms=3,estimates=est)
rms=stddev(y-result)
nlo=floor(A[1]-A[2]*sqrt(2.*(alog(A[0])-alog(rms))))
nhi=ceil(A[1]+A[2]*sqrt(2.*(alog(A[0])-alog(rms))))
badbox[3,np,ns,*]=[nlo-2,0,nhi+4,599] ; feature has sidelobe
print,ns,np,' box 3:',A[0],round(A[1]),A[2],nlo,nhi+4


if (ns eq 0 and np eq 0) then goto,getout
if (ns eq 1 and np eq 1) then goto,getout
if (ns eq 2  or ns eq 3) then goto,getout
if (ns eq 6 and np eq 0) then goto,getout

nch1=badbox[5,np,ns,0]
nch2=badbox[5,np,ns,2]
peak=max(profile[nch1:nch2],maxind)
maxind=maxind+nch1
y=profile
ymed=median(profile)
y[0:nch1-100]=ymed*RANDOMN(seed,nch1-100+1)
y[nch2+100:4095]=ymed*RANDOMN(seed,4096-nch2-100)
est=[peak,maxind,10.]
result=GAUSSFIT(x,y,A,nterms=3,estimates=est)
rms=stddev(y-result)
nlo=floor(A[1]-A[2]*sqrt(2.*(alog(A[0])-alog(rms))))
nhi=ceil(A[1]+A[2]*sqrt(2.*(alog(A[0])-alog(rms))))
badbox[5,np,ns,*]=[nlo-2,0,nhi+2,599]
print,ns,np,' box 5:',A[0],round(A[1]),A[2],nlo,nhi+1

getout:
end

;___________________________________________________________________

; MAIN PROGRAM

pro check_pv, 		$;
	m,		$; input drift structure (e.g. dred)
	continuum,	$; continuum profile (e.g. cont_pt, mc,)
	cmask,		$; mask used by bpc to measure total power
	pos,		$; position /st created by bpd (e.g. runpos) 	
	N1=n1,N2=n2,	$; first and last beam nr (def: 0, 6)
	GAUSAV=gausav,	$; HPFW of Gaussian smoothin in RA. Def=1
	HAN=han,	$; Hanning spectral smoothing. Def=1
	RFIMOD=rfimod,  $; "RFI modification" option (def=-1)
	MASK=mask	 ; RFI mask (use only if RFIMOD=2

; AFTER BPD, THE HOUSE RECOMMENDS:
;	check_pv,dred,cont_pt,mask,pos,gausav=11,han=3

nrec=n_elements(m[0,*,0])
nchn=n_elements(m[0,0,0].d[*])
nstr=n_elements(m[0,0,*])
npol=n_elements(m[*,0,0])
cont=continuum

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
    if (count gt 2) then begin
      nsbad[ns] = 1
      npbad[np] = 1
      Print,"Bad data on strip ",ns," Pol ",np
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

;...........................................................................
; DEFAULT BAD BOXES
; WE ALLOW FOR 100 BAD BOXES FOR EACH NPOL, NBEAM COMBINATION IN A DRIFT.
; EACH BOX IS DEFINED BY THE LOWER LEFT (LL) AND UPPER RIGHT (UR) CORNER,
; SPECIFIED IN THE FOLLOWING ORDER: LLch, LLrec, URch, URrec
; BOX 0 IS THE LOW FREQ EDGE OF THE BAND, FROM CH 0 TO 199
; BOX 1 IS THE HI  FREQ EDGE OF THE BAND, FROM CH 3897 TO 4095
; BOX 2 IS FOR THE CHANS OVER THE 1350 MHZ RADAR
; BOX 3 IS FOR THE 1380 HARMONIC OF THE RADAR
; BOXES 0-3 ARE BAD IN JUST ABOUT ALL DRIFTS. OTHER BOXES ARE BAD IN SOME
; POL/BEAM COMBINATION, NOT IN OTHERS.
; 
badbox=intarr(100,2,8,4)
for ns=0,7 do begin
  for np=0,1 do begin
    badbox[0,np,ns,*]=[   0,0,0204,599]
    badbox[1,np,ns,*]=[3897,0,4095,599]
    badbox[2,np,ns,*]=[0536,0,0716,599]
    badbox[3,np,ns,*]=[1824,0,1858,599]
  endfor
endfor
badbox[4,0,0,*]=[0205,0,0275,599]
badbox[4,1,0,*]=[0205,0,0275,599]
badbox[4,0,2,*]=[0205,0,0275,599]
badbox[4,1,2,*]=[0205,0,0275,599]
badbox[4,0,4,*]=[0205,0,0275,599]
badbox[4,1,4,*]=[0205,0,0275,599]
badbox[4,0,6,*]=[0205,0,0275,599]
badbox[4,1,6,*]=[0205,0,0275,599]
badbox[5,1,0,*]=[3040,0,3082,599]
badbox[5,0,1,*]=[3040,0,3082,599]
badbox[5,0,4,*]=[3040,0,3082,599]
badbox[5,1,4,*]=[3040,0,3082,599]
badbox[5,0,5,*]=[3040,0,3082,599]
badbox[5,1,5,*]=[3040,0,3082,599]
badbox[5,1,6,*]=[3040,0,3082,599]
badbox[6,0,0,*]=[3820,0,3896,599]
badbox[6,0,2,*]=[3845,0,3896,599]
badbox[6,1,2,*]=[3845,0,3896,599]
badbox[6,0,4,*]=[3845,0,3896,599]
badbox[6,1,4,*]=[3845,0,3896,599]
badbox[6,0,6,*]=[3820,0,3896,599]
badbox[6,1,6,*]=[3845,0,3896,599]
nbad=7

;..........................................................................

; READY TO GO LOOP THROUGH EACH BEAM, POL

for ns=n1,n2  do begin
  contprof= cont[*,ns]
  cmax = max(contprof)
  rcmax= where(contprof ge cmax)
; SMOOTH THE MAPS
  for np=0,1 do begin
   print,ns,np,format='("Processing ns,np=",2i3)'
   if (npbad[np] eq 1 and nsbad[ns] eq 1) then begin
     msmooth2[np,*,ns].d = 0. 
     seed = 5L
     msmooth2[np,nrec/2,ns].d= RANDOMN(seed,nchn)
     goto, NextPol
   endif
;  REFINE LOCATION OF THE PEAKS OF BADBOX(RFI) 3 AND 5
   find_35,reform(m_rficor[np,*,ns].d),np,ns,badbox

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
     display_drift,image,contm,contprof*ufact,np=np,ns=ns,mapwindow
     tvlct,255B,0B,0B,128
     for nb=0,6 do begin
       nb1=badbox[nb,np,ns,0]
       nb2=badbox[nb,np,ns,2]
       plots,[nb1,nb2],[nrec/2,nrec/2],linestyle=0,thick=4,color=128
     endfor
     if (nbad gt 7) then begin
       for nb=7,nbad-1 do begin
         LLch=badbox[nb,np,ns,0]
         LLrec=badbox[nb,np,ns,1]
         URch=badbox[nb,np,ns,2]
         URrec=badbox[nb,np,ns,3]
         plots,[LLch,URch],[LLrec,LLrec],linestyle=0,color=128
         plots,[LLch,URch],[URrec,URrec],linestyle=0,color=128
         plots,[LLch,LLch],[LLrec,URrec],linestyle=0,color=128
         plots,[URch,URch],[LLrec,URrec],linestyle=0,color=128
       endfor
     endif

   menu:        
   print_badbox,badbox,np,ns,nbad,line1=line1,lineargs=lineargs

   case strmid(line1,0,1) of

   'e': goto, NextPol

   'd': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        badbox[nbox,np,ns,*]=0
        wdelete,mapwindow
        goto,display_image
        end

   'a': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,seven
        print,'Go get corners of new box...'
        check_drift,IMAGE,mapwindow=mapwindow
        print,'Enter corners of box: LLch,LLrec,URch,URrec'
        read,LLch,LLrec,URch,URrec
        badbox[nbad,np,ns,*]=[LLch,LLrec,URch,URrec]
;       if a new box is added via 'a 7', we want it activated for all beams
;       (e.g. GPS), so we don't need to box it every time; it can get de-activated by
;       de-activated by using the "d" option
        if (ns lt 6 and seven eq 7) then begin
          nss1=ns
          if (np eq 1) then nss1=ns+1
          for nss=nss1,6 do begin
              for npp=0,1 do begin
                badbox[nbad,npp,nss,*]=[LLch,LLrec,URch,URrec]
              endfor
           endfor
        endif
        nbad=nbad+1L
        wdelete,mapwindow
        goto,display_image
        end
 
   'm': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        print,'Go get corners of new box...'
        check_drift,IMAGE,mapwindow=mapwindow
        print,'Enter corners of box: LLch,LLrec,URch,URrec'
        read,LLch,LLrec,URch,URrec
        badbox[nbox,np,ns,*]=[LLch,LLrec,URch,URrec]
        wdelete,mapwindow
        goto,display_image
        end
      
   else: goto, NextPol
   endcase

   NextPol:
  endfor
endfor   ; closes ns loop

; DONE; NOW GO REPLACE NEW BADBOX ARRAY IN POS /ST

index=where(pos.scannumber eq m[0,0,0].h.std.scannumber)
print,index
pos[index].badbox=badbox

!p.multi=0
wdelete,mapwindow
print,pos[index].scannumber,format='("Scan Nr",i10," done")'

end
