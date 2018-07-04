;+
;NAME:
;uflagbb.pro - Displays position-frequency strip maps and modifies pos /st
;
;SYNTAX:
;
;uflagbb,m,continuum,cmask,pos,N1=n1,N2=n2,GAUSAV=gausav,HAN=han,$
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
; If the keyword AGC is set, the program will overplot on each image
; AGC galaxies in the vicinity of the drift. "Vicinity" is decided
; by the program on the basis of the size of the galaxy (if size is
; listed in the AGC). To do so iti reads an ancillary file with all
; AGC gals within the Arecibo dec range.

; The POS.BADBOX tag tag is an array of integers (100,2,8,4). It
; contains the coords of the corners of up to 100 boxes containing
; parts of the map that are deemed "bad", an especially useful tool
; when the data will be used for gridding and producing clean cubes.
; The first dimension of .BADBOX is the box number; the second is the
; pol number, the third is the beam number and the fourth contains 4
; numbers which are LLch,LLrec,URch,URrec, i.e. the 
; ch nr and rec nr of the lower left (LL) corner of the box 
; and the ch nr and rec nr of the upper right (UR) corner of the box.

; .BADBOX numbers 0-20 are used for "default" rfi features, which appear
; very often in the data. Some effort is made also in setting up a
; "memory" of which beam/pol configs are most affected by each rfi feature.

; .BADBOX numbers 21-49 are used for new features cropping up in the data;
; when a "new" rfi featuer is flagged, the first unused .BADBOX with number
; in the range 21-49 is used.

; .BADBOX numbers 50-99 are used (hopefully infrequently) when the data
; is flooded with many rfi features. The program has an option "t" in
; its internal menu) to search and identify all the peaks in the "total"
; of the drift in the rec direction. Peaksare labelled in the image and
; the user has the option of "activating" a .BADBOX for each.

; The program uses PP's imgdisp procedure to display, one strip/pol at
; a time, position-frequency maps where the x-axis is chnr and the 
; y-axis is record (sample) nr along the strip. The continuum flux profile 
; profile along the strip is plotted on the side. The upper image is the
; spectral line data, the lower image is the mask used to produce 
; the total power continuum within bpc. The continuum mask shows
; the pixels that were excluded in the computation of total power,
; and it is displayed purely as a reference: the user actually works 
; only on the upper plot. The continuum mask follows a conservative
; approach and finds many more "bad" channels than there really are in
; the data. It is however useful to have it as a visual sanity check.
;
; The set of default .BADBOXes are built in the program to avoid having
; to set them each time. All the default .BADBOXes extend to the full
; duration of a drift (i.e. they are BAD CHANNELS). In the map display,
; their locations are indicated by red numbers across the top of the drift
; map. However only the boxes that are plotted as rectangles and labelled
; below each rectangle, are actually "activated" as a .BADBOX
;
; Since RFI features came and go from one day to the next, but persisting
; generally for the duration of an observing session, itis useful to
; build a "memory" of .BADBOXES, to avoid having to reset them for each
; drift. In addition to the "default" .BADBOXES, the program allows for
; writing a badbox file, dimensioned [100,2,8,4], containing all the
; settings used for a given drift. At the end of processing the drift,
; the user has the option ofo rewriting over that file. At the beginning
; of the inspection of each drift, the user can (a) read in that file in the
; internal .BADBOX, then modify it at will or (b) read in the default 
; .BADBOX file, specified inside the program itself.

;
; After each pol/beam map is smoothed and shown, the user can 

;               - delete a box for this map only                       (d boxnr)
;               - delete a box for this + all subsequent maps          (D boxnr)
;               - activate a box for this map only                     (a boxnr)
;               - activate a box for this + all subsq maps             (A boxnr)
;               - modify a box for this map only                       (m boxnr)
;               - modify a box for this + all subsequent maps          (M boxnr)
;               - insert a new box for this map only                   (i)
;               - insert a box for this + all subsequent maps          (I)
;               - obtain a row Total and identify peaks                (t)
;               - undo all peaks found by "t"                          (u)
;               - exit & go to next map (e)

; Option "d" 
; is used to de-activate a .BADBOX for a the beam/pol map being inspected,
; i.e. its [LLch,LLrec,URch,URrec] are set to zero for the given nb, npol.
;
; Option "D"
; is used to de-activate a .BADBOX for the current beam/pol being inspected,
; as well as for all the not yet inspected nbeam/npol maps of the drift.
; This is useful if, e.g., in the previous drift there was a box set, say,
; for GPS, affecting every bm/pol, and you are using the badbox file determined
; in the previous drift; using "D" will get rid of that badbox in all the
; beam/pols of the drift at  one time.
;
; Option "a"
; is used to activate a .BADBOX currently defined but not activated. For example,
; one of the default features with their IDs listed on top of the map, or any
; of the features found by the option "t" (see below). The activation takes
; place only for the current beam/pol.
;
; Option "A"
; is also used to activate a .BADBOX currently defined but not activated, as
; for option "a". However, the activation holds for all the maps of the drift
; which have not been set/inspected yet. For example, there is GPS in the
; first map you look at; GPS will appear in all the beams/pols; you might as
; well set it with "A".
;
; Option "m"
; is used to modify the boundaries of a set .BADBOX. It will prompt you to
; use the cursor to define a box, then allow you to inspect the characteristics
; of the data in that box (e.g. row, column plots, stat), then to enter
; manually the new values of [LLch,LLrec,URch,URrec] for that box. It only
; changes the given box for the current beam/pol map.
;
; Option "M"
; does the same thing as "m", but it does so for all the maps of the drift
; which have not been set/inspected yet.
;
; Option "i"
; is used to insert a "new" .BADBOX. The program will prompt the user to
; use the cursor to define a box, then allow inspection of the characteristics
; of the data in that box (e.g. row, column plots, stat); new values of
; [LLch,LLrec,URch,URrec] for that box are entered manually. It only
; changes the given box for the current beam/pol map.
;
; Option "I"
; does the same thing as "i", but it does so for all the maps of the drift
; which have not been set/inspected yet.
;
; Option "s"
; allows the user to reset the pos.status flag for an entire board or part
; thereof. If 	pos.status=0, the data are deemed good
;		pos.status=2, the data are deemed to be used at 1/2 weight
;		pos.status=3, the data are deemed to be used at 1/3 weight
;		pos.status=4, the data are deemed to be used at 1/4 weight
;		pos.status=8, the data are deemed to be used at 1/8 weight
;		pos.status.ge.9 the data aer unusable (equivalent to babdox=[0,0,4095,599])
;
; Option "t"
; is used in cases when there are a lot of rfi features in the data.
; Program computes a "total" spectrum in the record direction and identifies
; features by thresholding. It will label them inside the image [Note that
; it will also labelled galactic HI]. The user then decides which of those
; features should be activated as a .BADBOX, using the option "a" one 
; feature at a time. These features are all numbered 50 and up.
;
; Option "u"
; undoes the setting of all .BADBOXes numbered 50 and up (and removes the
; labels from the image). It does so for all the beam/pol left to inspect in 
; the drift.
;
; Option "g"
; prompts user to click on a postion in th map currently displayed and
; delivers an image from DSS, of size chosen by the user.
; 
; TIPS:
; 1) the program overwrites the POS structure only after the whole drift
;    has been processed, so ifi there is a crash, you should start from
;    the beginning of the drift.
; 2) If you goofed in setting parameters of a box, you can always modify
;    them or delete them
; 3) If you goofed and forgot the values [LLch,LLrec,URch,URrec] because
;    your darling called you on the phone, just enter 0,0,0,0 
; 4) If you noticed that a .BADBOX should have been activated or deleted
;    in a given map, take note of the beam/pol and box nr; you can always
;    reset it manually after you exit FLAGBB. E.g. you forgot to deactivate
;    box 2 in bm 4, pol 0, while you were processing the drift nr 13 in
;    the series of the observing session; after you are done with FLAGBB
;    IDL> pos[13].badbox[2,0,4,*]=0
;    will do the trick. or you can start from scratch on drift 13.
; 5) To inspect the job of box setting you've done, you can invoke the
;    program REVIEWBB. It is invoked with the same parameters as FLAGBB,
;    but it does nto change anything: it does just show you what you've set.
; 6) The program does not save POS after each drift, so it is your responsibility
;    to do so as often as you see fit, and certainly when you are done with
;    an observing session. When done, save POS thisi way:
;    IDL> save,POS,file='pos050322.sav'
;    where 050322 is the date of the observing session.
;
;
; AFTER BPD, THE HOUSE RECOMMENDS TO CALL THIS PROGRAM AS FOLLOWS:
;
;	FLAGBB,dred,cont_pt,mask,pos,gausav=11,han=3,agc=1
;
; If the user goes through the data of a drift and realizes that a given
; map needs to be revisited, the program can be reloaded only for the
; specific beam (n1=bean_to_redo, n2=beam_to_redo); however, both pols
; will have to be redone, rather than only the one that needs redoing.
;
; RG/05Mar23
; Related program: REVIEWBB	
;
; MODIFICATION HISTORY
;  05Oct31 - Brian Kent
;            -Changed default of Box Zero to channel 215
;            -Modifed insert box option to check that URch gt LLch /
;            -URrec gt LLrec, etc.
;            -"Beam" element 7 now reset to zero at the end since it
;            is not needed.
;  15Nov05 - RG
;	     - modified statement 
;              badbox=pos[index].badbox
;              that now reads:
;	       badbox[*,*,0:6,*]=pos[index].badbox[*,*,0:6,*]
;	       to overcome problem arising after element 7 was reset to 0 on 05Oct31
;  17Nov05 - RG
;            - set badbox[0,npbad,nsbad,*]=[0,0,nchn,nrec] when
;              board npbad,nsbad is found to be bad
;              User is warned upon caling flagbb, bad board map is not
;              displayed
;
;  07Jan06 - BK
;            - modification for full screen crosshairs for accurate bad-boxing
;
;  13Jan06 - RG
;	     - allowed for agc.list to have maxrec=100,000 galaxies (and obviated
;		problem of not plotting gals with RA > 12.5,h)
;
;  2+Jan06 - BK
;            - added option for user to request DSS/Sloan images with
;              'g' option and input image size in arcminutes.
;
;  29Jan06 - RG
;	     - added option "s"   
;
;  30Jan06 - BK - fixed coordinates in 'g' option   
;
;  02Feb06 - BK - added HVC catalog option - uses hvccat.pro   
;
;  14Jun06 - MH - fixed up typo in description of 'I' versus 'i' 
;
;  26Feb07 - BK - added hich3_index if statement to account for the
;            fact that 't' did not find any box candidates. 
;
;  07Jan09 - MH - allowed for agc.list to have maxrec=150,000 galaxies
;
;_____________________________________________________________________

; SUBROUTINE TO DISPLAY IMAGE AND CMASK MAPS; RETURNS mapwindow

pro display_drift,image,cmask,contprof,np=np,ns=ns,mapwindow

; clip is a 2-element array containg max and min clipping levels

if (n_elements(clip) eq 0) then clip=[-1.,1.]

nrec=n_elements(image[0,*])
nchn=n_elements(image[*,0])
SPEC=TOTAL(IMAGE,2)/NREC
;window,/free,xsize=1245*winscale,ysize=600,retain=2
; monkey here
winscale=0.8
window,/free,xsize=1245*winscale,ysize=700*winscale,retain=2
mapwindow=!d.window
!p.multi=[0,3,3,0,0]
loadct,1
device, decomposed=1
plot,contprof,findgen(nrec),position=[0.925,0.17,0.98,0.30],$  
     xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
plot,contprof,findgen(nrec),position=[0.925,0.36,0.98,0.95],$  
     xrange=[-10,160],xstyle=1,ystyle=1,xticks=2,charsize=0.8
plot,[0,1],[0,1],/nodata,xstyle=4,ystyle=4,position=[0.925,0.05,0.98,0.15]
plot,spec,xrange=[0,4096],yrange=[-0.04,0.06],xstyle=1,ystyle=1,$
     position=[0.05,0.05,0.89,0.15]
oplot,intarr(nchn),color='00FF00'XL
xyouts,0,-0.07,'LOVEDATA, Inc. Ithaca, NY',Size=0.75
device, decomposed=0
imgdisp,cmask,position=[0.05,0.17,0.89,0.30]
xyouts,0,nrec+18.,'Strip=' +strtrim(string(ns),2)+'  Pol='+strtrim(string(np),2),Size=1.5
imgdisp,image,position=[0.05,0.36,0.89,0.95],/histeq
;xyouts,0,nrec+18.,'Strip='+strtrim(string(ns),2),size=1.5
;xyouts,nchn-200,nrec+18.,'Pol='+strtrim(string(np),2),Size=1.5

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
     curfull, x,y,/data, /noclip
    ;cp, x=x, y=y
    xpos1=round(x)
    ypos1=round(y)
    if (xpos1 lt 0.) then xpos1 = 0.
    if (ypos1 lt 0.) then ypos1 = 0.
    wait, 0.5
print, 'Left click UPPER RIGHT corner of box...'
    curfull,x,y,/data, /noclip
    ;cp, x=x, y=y
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


pro print_badbox,badbox,np,ns,line1=line1,lineargs=lineargs

; PRINTS BADBOX FOR THE GIVEN NP,NS, RETURNS LINE1, LINEARGS

;   print,'---------------------------------------'     
;   print,ns,np,format='("Pix boxes thought bad for BEAM",i2," POL",i2)'
   print,'---------------------------------------' 
   Print,' Box nr  LLch    LLrec   URch   URrec'
   print,'---------------------------------------' 
   for nb=0,99 do begin
     if (total(badbox[nb,np,ns,*],4) ne 0) then $
     Print,nb,badbox[nb,np,ns,*],format='(3x,i2,4(4x,i4))'
   endfor
   print,'---------------------------------------' 

   print,'You can now :  - delete a box for this map only                       (d boxnr)'
   print,'               - delete a box for this + all subsequent maps          (D boxnr)'
   print,'               - activate a box for this map only                     (a boxnr)'
   print,'               - activate a box for this + all subsq maps             (A boxnr)'
   print,'               - modify a box for this map only                       (m boxnr)'
   print,'               - modify a box for this + all subsequent maps          (M boxnr)'
   print,'               - insert a new box for this map only                   (i)'
   print,'               - insert a box for this + all subsequent maps          (I)'
   print,'               - modify status flag for board or part thereof         (s)'
   print,'               - obtain a row Total and identify peaks                (t)'
   print,'               - undo all peaks found by "t"                          (u)'
   print,'               - get an image of specified size                       (g)'
   print,'               - HVC catalog maps                                     (h)'
   print,'               - exit & go to next map                                (e)'
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

end

;___________________________________________________________________

pro center_rfi,pvmap,badbox,nbox=nbox,npol=npol,nbm=nbm

; FINDS THE EXACT LOCATION OF PEAK and PARMS OF BADBOX NR nbox 
; pvmap SHOULD BE (4096X600)

profile=total(pvmap,2)/n_elements(pvmap[*,0])
nch1=badbox[nbox,npol,nbm,0]
nch2=badbox[nbox,npol,nbm,2]

IF (NBOX EQ 12) THEN PRINT,NBOX,NCH1,NCH2

;if (nbox gt 5 and nch1 gt 540 and nch1 lt 660) then nch1=660
if (nch1 lt 260) then goto,getout ; i.e. keep broad box
if (nch2 gt 3900) then nch2=3900
peak=max(profile[nch1:nch2],maxind)
maxind=maxind+nch1
rms=stddev(profile[maxind-200:maxind-100])
if (maxind lt  400) then rms=stddev(profile[300:500])
if (maxind gt 3600) then rms=stddev(profile[3600:3800])
if (peak/rms lt 6.) then begin
  Print,'Weak feature, hard to centroid: guess parms via "i" or "I"'
  Print,maxind,peak,rms,format='("Peak ch=",i4,"  Peak val=",f6.4,"  rms=",f6.4)'
  goto,getout
endif

IF (NBOX EQ 12) THEN PRINT,MAXIND,RMS

x=findgen(4096)
y=profile
seed=7L
y[0:nch1-100]=rms*RANDOMN(seed,nch1-100+1)
y[nch2+100:4095]=rms*RANDOMN(seed,4096-nch2-100)
est=[peak,maxind,5.]
result=GAUSSFIT(x,y,A,nterms=3,estimates=est)
rms=stddev(y-result)
nlo=floor(A[1]-A[2]*sqrt(2.*(alog(A[0])-alog(rms))))
nhi=ceil(A[1]+A[2]*sqrt(2.*(alog(A[0])-alog(rms))))
if (nlo lt 0 or nhi lt 0) then goto,getout
badbox[nbox,npol,nbm,*]=[nlo-4,0,nhi+4,599] ; allow for sidelobes
print,nbox,A[0],rms,round(A[1]),A[2],nlo-4,nhi+4, $
format='("Nbox=",i3,3x,"Peak val=",f7.4,3x,"rms=",f6.4,3x,"Peak ch=",i4,3x,"sigma=",f6.2,3x,"Bounds=",2i5)'

getout:
end




;___________________________________________________________________

; MAIN PROGRAM

pro uflagbb,	 	$;
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
;	flagbb,dred,cont_pt,mask,pos,gausav=11,han=3,agc=1



nrec=n_elements(m[0,*,0])
nchn=n_elements(m[0,0,0].d[*])
nstr=n_elements(m[0,0,*])
npol=n_elements(m[*,0,0])
cont=continuum

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
    tot=total(m[np,*,ns].d)  ; that means board was set as bad by calib2 and m.d is all zeroes
    if (count gt 2 or tot eq 0.) then begin
      nsbad[ns] = 1
      npbad[np] = 1
      Print,"WARNING: Bad data on strip ",ns," Pol ",np
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

;...........................................................................
; DEFAULT BAD BOXES
; WE ALLOW FOR 100 BAD BOXES FOR EACH NPOL, NBEAM COMBINATION IN A DRIFT.
; EACH BOX IS DEFINED BY THE LOWER LEFT (LL) AND UPPER RIGHT (UR) CORNER,
; SPECIFIED IN THE FOLLOWING ORDER: LLch, LLrec, URch, URrec
; BOX 0 IS THE LOW FREQ EDGE OF THE BAND, FROM CH 0 TO 199
; BOX 1 IS THE HI  FREQ EDGE OF THE BAND, FROM CH 3897 TO 4095
; BOX 3 IS FOR THE CHANS OVER THE 1350 MHZ RADAR
; BOX 6 IS FOR THE 1380 HARMONIC OF THE RADAR
; SOME BOXES ARE BAD IN JUST ABOUT ALL DRIFTS. OTHER BOXES ARE BAD IN SOME
; POL/BEAM COMBINATION, NOT IN OTHERS.
; 
badbox=intarr(100,2,8,4)
for ns=0,7 do begin
  for np=0,1 do begin
    badbox[0,np,ns,*]=[   0,0,0215,599]    ;Changed to 215 by B. Kent 05Oct31 
    badbox[1,np,ns,*]=[3897,0,4095,599]
    badbox[2,np, 7,*]=[ 205,0, 260,599]
    badbox[3,np, 7,*]=[ 260,0, 300,599]
    badbox[4,np, 7,*]=[ 360,0, 400,599]
    badbox[5,np,ns,*]=[0536,0,0680,599]
    badbox[6,np, 7,*]=[ 681,0, 730,599]
    badbox[7,np, 7,*]=[1600,0,1680,599]
    badbox[8,np,ns,*]=[1824,0,1885,599]
    badbox[9,np, 7,*]=[2390,0,2420,599]
    badbox[10,np,7,*]=[2630,0,2690,599]
    badbox[11,np,7,*]=[2830,0,2870,599]
    badbox[12,np,7,*]=[3040,0,3139,599]
    badbox[13,np,7,*]=[3540,0,3580,599]
    badbox[14,np,7,*]=[3630,0,3660,599]
    badbox[15,np,7,*]=[3845,0,3896,599]
  endfor
endfor
badbox[2,0,0,*]=badbox[2,0, 7,*]
badbox[2,1,0,*]=badbox[2,0, 7,*]
badbox[2,0,2,*]=badbox[2,0, 7,*]
badbox[2,1,2,*]=badbox[2,0, 7,*]
badbox[2,0,4,*]=badbox[2,0, 7,*]
badbox[2,1,4,*]=badbox[2,0, 7,*]
badbox[2,0,6,*]=badbox[2,0, 7,*]
badbox[2,1,6,*]=badbox[2,0, 7,*]
badbox[12,1,0,*]=badbox[12,0, 7,*]
badbox[12,0,1,*]=badbox[12,0, 7,*]
badbox[12,0,4,*]=badbox[12,0, 7,*]
badbox[12,1,4,*]=badbox[12,0, 7,*]
badbox[12,0,5,*]=badbox[12,0, 7,*]
badbox[12,1,5,*]=badbox[12,0, 7,*]
badbox[12,1,6,*]=badbox[12,0, 7,*]
badbox[15,0,0,*]=badbox[15,0,7,*]
badbox[15,0,2,*]=badbox[15,0,7,*]
badbox[15,1,2,*]=badbox[15,0,7,*]
badbox[15,0,4,*]=badbox[15,0,7,*]
badbox[15,1,4,*]=badbox[15,0,7,*]
badbox[15,0,6,*]=badbox[15,0,7,*]
badbox[15,1,6,*]=badbox[15,0,7,*]

maxclip=1.
minclip=-1.
Print,'Data display will be clipped at an intensity of +/-1: OK? [y/n, def=y]'
ans=''
read,ans
if (ans eq 'n' or ans eq 'N') then begin
  print,'Enter desired clipping levels: minclip, maxclip'
  read, minclip,maxclip
endif

badarr=intarr(4)
posindex=where(pos.scannumber eq m[0,0,0].h.std.scannumber)

print,'Do you wish to use default (d), your own file (o) or pos.badbox (p) for BADBOXES? (def=d)
ans=''
read,ans
if (ans eq 'o') then begin
  print,'Enter name of BADBOXES file'
  badboxin=''
  read,badboxin
  openr,lun,badboxin,/get_lun
  while(eof(lun) ne 1) do begin
    readf,lun,nbox,np,ns,badarr,format='(3i3,4i5)'
    badbox[nbox,np,ns,*]=badarr
  endwhile
  free_lun,lun
endif
if (ans eq 'p') then begin
  badbox[*,*,0:6,*]=pos[posindex].badbox[*,*,0:6,*]
endif

;..........................................................................

; READY TO GO LOOP THROUGH EACH BEAM, POL

peakid=0
nnn=lindgen(8)
if (n1 eq 0 and n2 eq 6) then nnn=[4,3,5,0,2,6,1,6] ; in Dec order for rotang=19

for nn=n1,n2  do begin
  ns=nnn[nn]
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
     badbox[0,np,ns,*]=[0,0,nchn-1,nrec-1]        ; flag entire board as bad with badbox 0
     goto, NextPol
   endif
;  REFINE LOCATION OF THE PEAKS OF BADBOX(RFI) 3 AND 5
;   find_35,reform(m_rficor[np,*,ns].d),np,ns,badbox

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
 
     if (peakid eq 1) then begin
       ny=570
       for nb=50,99 do begin
         if (total(badbox[nb,0,7,*],4) eq 0) then goto,out_of_peakid
         nx=badbox[nb,0,7,0]
         print,nb,badbox[nb,0,7,*],format='(i3,4i5)'
         ny=ny-20
         if (ny lt 490) then ny=570
         xyouts,nx,ny,strtrim(string(nb),2),charsize=1.2,color=128
       endfor
     endif
     out_of_peakid:

;     for nb=0,6 do begin
;       nb1=badbox[nb,np,ns,0]
;       nb2=badbox[nb,np,ns,2]
;       plots,[nb1,nb2],[nrec/2,nrec/2],linestyle=0,thick=4,color=128
;       if (total(badbox[nb,np,ns,*],4) ne 0) then $
;       xyouts,(nb1+nb2)/2,nrec/2-40,strtrim(string(nb),2),charsize=1.5,color=128
;     endfor
;     if (nbad gt 7) then begin
;       for nb=7,nbad-1 do begin
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


      if (n_elements(agc) eq 0) then goto, menu
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
        plots,xagc,yagc,psym=6,symsize=3,color=128
      endif



   menu:        
   print_badbox,badbox,np,ns,line1=line1,lineargs=lineargs

   case strmid(line1,0,1) of

   'e': goto, NextPol

   'd': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        if (nbox ge 100) then goto,menu
        badbox[nbox,np,ns,*]=0
        wdelete,mapwindow
        goto,display_image
        end

   'D': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        if (nbox ge 100) then goto,menu
        badbox[nbox,np,ns,*]=0
        if (nn lt n2) then begin
          nnn1=nn
          if (np eq 1) then nnn1=nn+1
          for nss=nnn1,n2 do begin
              for npp=0,1 do begin
                badbox[nbox,npp,nnn[nss],*]=0
              endfor
           endfor
        endif
        wdelete,mapwindow
        goto,display_image
        end

   'a': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        if (nbox ge 100) then goto,menu
;        if (nbox gt 20) then begin
;          print,'"a" only works with boxes 0-20; for insertion of others, use "i" or "I"'
;          goto,menu
;        endif
        if (total(badbox[nbox,0,7,*],4) eq 0) then begin
          print,'No parms for this box available: mistype?'
          goto,menu
        endif
        center_rfi,reform(m_rficor[np,*,ns].d),badbox,nbox=nbox,npol=0,nbm=7
        badbox[nbox,np,ns,*]=badbox[nbox,0,7,*]
        wdelete,mapwindow
        goto,display_image
        end

   'A': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        if (nbox ge 100) then goto,menu
;        if (nbox gt 20) then begin
;          print,'"A" only works with boxes 0-20; for insertion of others, use "i" or "I"'
;          goto,menu
;        endif
        if (total(badbox[nbox,np,7,*],4) eq 0) then begin
          print,'No parms for this box available: mistype?'
          goto,menu
        endif
        center_rfi,reform(m_rficor[np,*,ns].d),badbox,nbox=nbox,npol=0,nbm=7
        badbox[nbox,np,ns,*]=badbox[nbox,0,7,*]
        if (nn lt n2) then begin
          nnn1=nn
          if (np eq 1) then nnn1=nn+1
          for nss=nnn1,n2 do begin
              for npp=0,1 do begin
                badbox[nbox,npp,nnn[nss],*]=badbox[nbox,0,7,*]
              endfor
           endfor
        endif
        wdelete,mapwindow
        goto,display_image
        end
 
   'm': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        if (nbox ge 100) then goto,menu
        print,'Go get new corners of box...'
        check_drift,IMAGE,mapwindow=mapwindow
        print,'Enter new corners of box: LLch,LLrec,URch,URrec'
        read,LLch,LLrec,URch,URrec
        badbox[nbox,np,ns,*]=[LLch,LLrec,URch,URrec]
        badbox[nbox, 0, 7,*]=[LLch,LLrec,URch,URrec]
        badbox[nbox, 1, 7,*]=[LLch,LLrec,URch,URrec]
        wdelete,mapwindow
        goto,display_image
        end

   'M': begin
        if (lineargs eq '') then goto,menu
        reads,lineargs,nbox
        if (nbox ge 100) then goto,menu
        print,'Go get new corners of box...'
        check_drift,IMAGE,mapwindow=mapwindow
        print,'Enter new corners of box: LLch,LLrec,URch,URrec'
        read,LLch,LLrec,URch,URrec
        badbox[nbox,np,ns,*]=[LLch,LLrec,URch,URrec]
        badbox[nbox, 0, 7,*]=[LLch,LLrec,URch,URrec]
        badbox[nbox, 1, 7,*]=[LLch,LLrec,URch,URrec]
        if (nn lt n2) then begin
          nnn1=nn
          if (np eq 1) then nnn1=nn+1
          for nss=nnn1,n2 do begin
              for npp=0,1 do begin
                badbox[nbox,npp,nnn[nss],*]=[LLch,LLrec,URch,URrec]
              endfor
           endfor
        endif
        wdelete,mapwindow
        goto,display_image
        end

   'i': begin
        startofsmalli:
        ind=where(total(badbox[*,np,ns,*],4) eq 0)
        nbox=ind[min(where(ind gt 30))]  ; first free box (all zeros) with box nr > 30 
        check_drift,IMAGE,mapwindow=mapwindow
        print,'Enter new corners of box: LLch,LLrec,URch,URrec'
        read,LLch,LLrec,URch,URrec
        if (LLch gt URch OR LLrec gt URrec) then begin
          print, 'Incorrect order of input.  Choose another box area.'
          goto, startofsmalli
        endif else begin
          badbox[nbox,np,ns,*]=[LLch,LLrec,URch,URrec]
          badbox[nbox, 0, 7,*]=[LLch,LLrec,URch,URrec]
          badbox[nbox, 1, 7,*]=[LLch,LLrec,URch,URrec]
          wdelete,mapwindow
          goto,display_image
        endelse
        end

   'I': begin
        startofbigi:
        ind=where(total(badbox[*,np,ns,*],4) eq 0)
        nbox=ind[min(where(ind gt 30))]  ; first free box (all zeros) with box nr > 30
        check_drift,IMAGE,mapwindow=mapwindow
        print,'Enter new corners of box: LLch,LLrec,URch,URrec'
        read,LLch,LLrec,URch,URrec
        if (LLch gt URch OR LLrec gt URrec) then begin
          print, 'Incorrect order of input.  Choose another box area.'
          goto, startofbigi
        endif else begin
          badbox[nbox,np,ns,*]=[LLch,LLrec,URch,URrec]
          badbox[nbox, 0, 7,*]=[LLch,LLrec,URch,URrec]
          badbox[nbox, 1, 7,*]=[LLch,LLrec,URch,URrec]
          if (nn lt n2) then begin
            nnn1=nn
            if (np eq 1) then nnn1=nn+1
            for nss=nnn1,n2 do begin
                for npp=0,1 do begin
                  badbox[nbox,npp,nnn[nss],*]=[LLch,LLrec,URch,URrec]
                endfor
            endfor
          endif
        wdelete,mapwindow
        goto,display_image
        endelse
        end

   's': begin
        Print,'You may reset the pos.status flag of this board'
        Print,'   Reset all records (a) or record range (r)? (def=a)'
        sans=''
        read,sans
        recmin=0
        recmax=nrec-1
        if (sans eq 'r') then begin
          get_stat_rec:
          print, 'Left click LOWER record nr...'
          curfull, x,y,/data, /noclip
          ;cp, x=x, y=y
          ypos1=round(y)
          if (ypos1 lt 0.) then ypos1 = 0.
          wait, 0.5
          print, 'Left click UPPER record nr...'
          curfull,x,y,/data, /noclip
          ;cp, x=x, y=y
          ypos2=round(y)
          if (ypos2 gt nrec-1) then ypos2=nrec-1
          wait, 0.5
          print,round(ypos1),round(ypos2),format='("You Chose:",2(i4,","),"  OK?")'
          ssans=''
          read,ssans
          if (ssans eq 'n' or ssans eq 'N') then goto,get_stat_rec
          recmin=round(ypos1)
          recmax=round(ypos2)
        endif
        Print,'You can set the pos.status index as follows:'
        Print,'		0 or 1	bm/pol board (or chosen section is used at full weight'
        Print,'		N	board is used at 1/N weight'
        Print,'		[if N.ge.9	board is used at zero weight'
	Print,'    Enter a number'
        Read,qs
        pos[posindex].status[np,recmin:recmax,ns]=qs
        goto,menu
        end

   't': begin
        totprof=total(IMAGE,2)
        totch=findgen(n_elements(totprof))
        loindx=totch[250:3850]
        totrms=stddev(totprof[250:3850])
        for ntimes=0,5 do begin
          loindx=where(totprof lt 2.5*totrms)
          tmpindx=where(loindx gt 250 and loindx lt 3850)
          tmp=loindx[tmpindx]
          totrms=stddev(totprof[tmp])
          print,ntimes,n_elements(loindx),n_elements(tmp),totrms
        endfor
        hich=where(totprof gt 5.*totrms)
        hich2=where(hich gt 250 and hich lt 3850)
        hich3=hich[hich2]
        hish=shift(hich3,1)

        hich3_index=where(hich3-hish gt 1)
       if (hich3_index[0] ne -1) then begin

           npk1=[hich3[0],hich3[hich3_index]]
           npk2=[hich3[hich3_index-1],hich3[n_elements(hich3)-1]]
           npks=n_elements(npk1)
       endif else begin
           npks=0
           nbox=50
       endelse

       

      
        if (npks gt 0) then begin
          nbox=50
          for npk=0,npks-1 do begin
            peak=max(totprof[npk1[npk]:npk2[npk]],mch)
            mch=mch+npk1[npk]
            print,npk,nbox,mch,peak
            badbox[nbox,0,7,*]=[mch-10,0,mch+10,nrec-1]
            nbox=nbox+1
            if (nbox gt 99) then begin
              print,'... too many bad channels'
              goto,menu
            endif
          endfor
        endif
        peakid=1
        print,peakid,nbox,format='("PEAKID=",i2," filled to NBOX=",i3)'
        wdelete,mapwindow
        goto,display_image
        end

   'u': begin
        for nb=50,99 do begin
         badbox[nb,np,ns,*]=0
         badbox[nb,0,7,*]=0
         if (nn lt n2) then begin
          nnn1=nn
          if (np eq 1) then nnn1=nn+1
          for nss=nnn1,7 do begin
              for npp=0,1 do begin
                badbox[nb,npp,nnn[nss],*]=0
              endfor
           endfor
         endif
        endfor
        peakid=0
        wdelete,mapwindow
        goto,display_image
        end

    ;Option to get optical images in flagbb
    'g': begin
         
         wset, mapwindow
         print, 'Left Click the map to obtain an image...'
         curfull, x,y,/noclip, /data
         rahr=m[0,y,ns].rahr
         decdeg=m[0,y,ns].decdeg

         sizestring=''
         read, 'Image size (default 6 arcmin)? ', sizestring

         if (sizestring eq '') then begin
             imagesize=6.0
         endif else begin
             imagesize=double(sizestring)
         endelse
         window,/free,xsize=700,ysize=700,retain=2
         imagewindow=!d.window
         !p.multi=0
         loadct,1, /silent

         wset, imagewindow
         ;print, 'Please wait while image loads...'

         device, decomposed=1
         xyouts, 100, 350, 'Image is loading...', /device, charsize=2.0
         xyouts, 200, 300, '(c) LOVEDATA, Inc.   Ithaca, NY', /device, charsize=2.0

         queryDSS, [rahr*15.0D,decdeg], opticaldssimage, header, imsize=imagesize, survey='2b'

         osfamily = strupcase(!version.os_family)

         if (osfamily eq 'UNIX') then begin
         url='http://casjobs.sdss.org/ImgCutoutDR6/getjpeg.aspx?ra='+$
                    strcompress(rahr*15.0, /remove_all)+$
                    '&dec='+strcompress(decdeg, /remove_all)+$
                    '&scale='+strcompress(imagesize/6.67,/remove_all)+$
                    '&opt=I&width=400&height=400'

         filename='~/12junksdss.jpg'
         spawn, 'wget -q -O '+ filename + " '" + url + "'"
         spawn, 'convert '+filename+' '+filename
         read_jpeg, filename, sloanimage, true=1
         spawn, '/bin/rm -r ~/12junksdss.jpg'
         endif else begin
           sloanimage=dblarr(3,400,400)
         endelse


         xrange=[double(rahr-(imagesize/2.0)/60.0/15.0), double(rahr+(imagesize/2.0)/60.0/15.0)]
         yrange=[double(decdeg-(imagesize/2.0)/60.0), double(decdeg+(imagesize/2.0)/60.0)]
         ticklen=-0.01
         posarray=[0.15,0.15,0.95,0.95]

         device,decomposed=1
         color='00FFFF'XL    ;YELLOW

         plot, [0,0], /nodata, xrange=xrange, yrange=yrange, $
               title=strcompress(long(imagesize), /remove_all)+' arcminute optical image centered at RA: '+$
               strcompress(rahr, /remove_all)+' hours, Dec: '+strcompress(decdeg, /remove_all)+' degrees', $
               xtitle='Right Ascension [hms]', ytitle='Declination [dms]', xstyle=1, ystyle=1, position=posarray, $
               xtick_get=xvals, ytick_get=yvals, ticklen=ticklen, color=color, charsize=1.0

         nxticklabels=n_elements(xvals)
         nyticklabels=n_elements(yvals)

         xspacing=((xvals[n_elements(xvals)-1]-xvals[0])*60.0)/(nxticklabels-1)
         yspacing=((yvals[n_elements(yvals)-1]-yvals[0])*60.0)/(nyticklabels-1)

         ticlabels, xvals[0]*15.0, nxticklabels, xspacing, xticlabs,/ra,delta=1
         ticlabels, yvals[0], nyticklabels, yspacing, yticlabs, delta=1

         xticlabs=ratickname(xvals*15.0)
         yticlabs=dectickname(yvals)

         PX = !X.WINDOW * !D.X_VSIZE 
         PY = !Y.WINDOW * !D.Y_VSIZE 
         SX = PX[1] - PX[0] + 1 
         SY = PY[1] - PY[0] + 1

         erase

         device, decomposed=0
         loadct, 1, /silent
         stretch, 225,0

         if (opticaldssimage[0]  ne 0) then begin
             tvscl, congrid(opticaldssimage,sx,sy), px[0], py[0]
         endif else begin
             device, decomposed=1
             xyouts, 350,350, 'DSS2 Blue service not responding', alignment=0.5
         endelse
         status='DSS2Blue'
         device, decomposed=1

         ;Reverse RA values now that tick labels have been set
         xrange=[double(rahr+(imagesize/2.0)/60.0/15.0), double(rahr-(imagesize/2.0)/60.0/15.0)]

         plot, [0,0], /nodata, xrange=xrange, yrange=yrange, $
               title=strcompress(long(imagesize), /remove_all)+' arcminute optical image centered at RA: '+$
               strcompress(rahr, /remove_all)+' hours, Dec: '+strcompress(decdeg, /remove_all)+' degrees', $
               xtitle='Right Ascension [hms]', ytitle='Declination [dms]', xstyle=1, ystyle=1, position=posarray, $
               xtickn=reverse(xticlabs), ytickn=yticlabs, ticklen=ticklen, color=color, charsize=1.0, /NOERASE
         
         if (nagc gt 0) then begin
           resultcoords=convert_coord(agcdata[1,iagc], agcdata[2,iagc], /data, /double, /to_device)
           plots, agcdata[1,iagc], agcdata[2,iagc], psym=6,symsize=1.5, color='0000FF'XL, /data
           xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $ 
             strcompress(long(agcdata[0,iagc]), /remove_all)+', cz= '+strcompress(long(agcdata[5,iagc]), /remove_all),$
             color='0000FF'XL, /device, charsize=1.1        
         endif
         
         oplot, m.rahr, m.decdeg, psym=6,symsize=0.2, thick=2.0, color='0000FF'XL
         oplot, m[0,*,ns].rahr,  m[0,*,ns].decdeg,psym=6, symsize=0.2, thick=2.0, color='00FF00'XL
         xyouts, 25, 40, 'Green indicates current beam', charsize=2.0, /device, color='00FF00'XL

         xyouts, 25, 10, 'DSS 2 Blue     Left click for Sloan, Right Click to Exit', /device, charsize=2.0

         reload_image:

         curfull,x,y
         wait, 0.2
         erase
         device,decomposed=0

         if (!mouse.button eq 1) then begin
             if (status eq 'DSS2Blue') then begin
                
                tv,congrid(sloanimage, 3,sx,sy), px[0], py[0], true=1 
                device, decomposed=1
                xyouts, 25, 10, 'Sloan     Left click for DSS 2 Blue, Right Click to Exit', /device, charsize=2.0
                
                osfamily = strupcase(!version.os_family)

                 if (osfamily ne 'UNIX') then begin
                     xyouts, 350,350, 'Sloan feature available only on Linux', alignment=0.5
                 endif

                status='Sloan'             
             endif else begin
                loadct, 1, /silent
                stretch, 225,0

                if(opticaldssimage[0] ne 0) then begin
                    tvscl, congrid(opticaldssimage,sx,sy), px[0], py[0]
                endif else begin
                    device, decomposed=1
                    xyouts, 350,350, 'DSS2 Blue service not responding', alignment=0.5
                endelse

                device, decomposed=1
                xyouts, 25, 10, 'DSS 2 Blue     Left click for Sloan, Right Click to Exit', /device, charsize=2.0
                status='DSS2Blue'
             endelse

             device, decomposed=1
             
             plot, [0,0], /nodata, xrange=xrange, yrange=yrange, $
               title=strcompress(long(imagesize), /remove_all)+' arcminute optical image centered at RA: '+$
               strcompress(rahr, /remove_all)+' hours, Dec: '+strcompress(decdeg, /remove_all)+' degrees', $
               xtitle='Right Ascension [hms]', ytitle='Declination [dms]', xstyle=1, ystyle=1, position=posarray, $
               xtickn=reverse(xticlabs), ytickn=yticlabs, ticklen=ticklen, color=color, charsize=1.0, /NOERASE

             if (nagc gt 0) then begin
              resultcoords=convert_coord(agcdata[1,iagc], agcdata[2,iagc], /data, /double, /to_device)
              plots, agcdata[1,iagc], agcdata[2,iagc], psym=6,symsize=1.5, color='0000FF'XL, /data
              xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $ 
               strcompress(long(agcdata[0,iagc]), /remove_all)+', cz= '+strcompress(long(agcdata[5,iagc]), /remove_all),$
               color='0000FF'XL, /device, charsize=1.1        
             endif
             



             oplot, m.rahr, m.decdeg, psym=6,symsize=0.2, thick=2.0 , color='0000FF'XL
             oplot, m[0,*,ns].rahr, m[0,*,ns].decdeg, psym=6, symsize=0.2, thick=2.0, color='00FF00'XL
             xyouts, 25, 40, 'Green indicates current beam', charsize=2.0, /device, color='00FF00'XL

             device, decomposed=0
             loadct,1,/silent

             goto, reload_image

         endif else begin

         if (!d.window eq imagewindow) then wdelete, imagewindow
         
         wdelete, mapwindow
         goto,display_image

         endelse

         end    ;End of 'g' option


        ;HVC cloud option
   'h': begin

         rahr=m[0,299,ns].rahr
         decdeg=m[0,299,ns].decdeg
         
         !p.multi=0
         loadct,1, /silent
       
         hvccat, rahr, decdeg, windowid=windowid

         device, decomposed=1

         glactc, m.rahr, m.decdeg, 2000, l,b,1
         aitoff, l,b,x,y

         oplot, x,y, psym=3,symsize=0.2, thick=2.0 , color='0000FF'XL
         glactc, m[0,*,ns].rahr, m[0,*,ns].decdeg,2000,l,b,1
         aitoff,l,b,x,y
         oplot, x,y, psym=3, symsize=0.2, thick=2.0, color='00FF00'XL

         
         glactc, m[0,299,0].rahr, m[0,299,0].decdeg+1.0, 2000,lstart,bstart,1
         glactc, m[0,299,0].rahr, m[0,299,0].decdeg+2.0, 2000,lend,bend,1
         aitoff, lstart, bstart, xstart, ystart
         aitoff, lend, bend, xend, yend

         ;print, xstart, ystart, xend, yend
         ;plots, [xstart, xend], [ystart, yend], color='0000FF'XL
         ;plots, [xstart, xend], [ystart, ystart],color='0000FF'XL
         ;xyouts, xend,yend, 'Eq.N', charsize=2.0, /data, color='0000FF'XL

         angle=acos((xend-xstart)/sqrt((xend-xstart)^2+(yend-ystart)^2))
         xcen=200
         ycen=700

         one_arrow,xcen,ycen,angle*180/3.1415926D, 'N', color='0000FF'XL, charsize=1.5, $
                   arrowsize=[120.0, 15.0, 35.0], thick=2.0

         xyouts, 625, 30, 'Grid lines show constant Galactic Longitude and Latitude in an Aitoff projection.', /device
         xyouts, 625, 15, 'Current beam indicated in ', /device
         xyouts, 755, 15, ' GREEN', color='00FF00'XL, /device

         xyouts, 100, 20, 'RED ', color='0000FF'XL, /device, charsize=1.0
         xyouts, 125, 20, 'arrow points to Celestial north pole.', charsize=1.0, /device
     
         device, decomposed=0
         loadct,1,/silent

         ans=''
         read,ans, prompt='Enter to continue...'
         
         if (!d.window eq windowid) then wdelete, windowid

         wdelete, mapwindow
         goto,display_image


     end    ;end of 'h' option 











   '':  goto,NextPol 

   else: goto, menu
   endcase

   NextPol:
  endfor
endfor   ; closes ns loop




; WRITE BADBOX FOR KEEPS?

print,'Do you wish to keep the BADBOX file? (y/n, def=n)
ans=''
read,ans
if (ans eq 'y' or ans eq 'Y') then begin
  print,'Enter file name'
  badboxname=''
  read,badboxname
  openw,lun,badboxname,/get_lun
  for i=0,99 do begin
    for ns=0,7 do begin
      for np=0,1 do begin
        printf,lun,i,np,ns,badbox[i,np,ns,*],format='(3i3,4i5)'
      endfor
    endfor
  endfor
  free_lun,lun
endif

; DONE; NOW GO REPLACE NEW BADBOX ARRAY IN POS /ST
index=where(pos.scannumber eq m[0,0,0].h.std.scannumber)
badbox[*,*,7,*]=0    ;Reset last "beam" element 7 to zero
pos[index].badbox=badbox


!p.multi=0
wdelete,mapwindow
print,pos[index].scannumber,index,format='("Scan Nr",i10," done. Pos index:",i3)'

end
