;+
;NAME:
;calib2 - reads dcalON and dcalOF structures of an observing session,  
;        computes fit to crat=(calON-calOFF)/calOFF
;
;SYNTAX:
;
; calib2,dcalON,dcalOF,ncalib
;
;PARAMETERS:
;
; dcalON  - an input 'm' type array of size [nchn,npol,ncal,nbrd]
;		a sequence of ncal calON spectra
; dcalOF  - an input 'm' type array of size [nchn,npol,ncal,nbrd]
;		a sequence of ncal calOFF spectra
;		npol=2= nr of pols 
;		ncal  = nr of cal pairs in session
;		nbrd=8= number of boards (7 beams + spare)
;		nchn  = nr of spectral channels 
; ncalib - an output structure containing the cal record for 
;		session. ;		Its contents are:
;
; ncalib.date: 		yddd integer (beginning of scan)
; ncalib.startime:	integer sssss, AST secs after midnite of first CalON of session
; ncalib.stoptime:	integer sssss, AST secs after midnite of last CalON of session
; ncalib.ncals:		integer, number ofcalON,calOF event pairs in scan 
; ncalib.RAhr0:		float array [100] RAJ(hrs) of up to 100 CalON records, bm 0
; ncalib.Decdeg0:	float array [100] decJ(deg) of up to 100 CalON records, bm 0
; ncalib.AZ0: 		float array [100] AZ of CalON records, bm 0
; ncalib.ZA0: 		float array [100] ZA of CalON records, bm 0
; ncalib.ctime:		float array [100] AST secs after midnite of each CalON record
; ncalib.calvals:	float array [2,8] nominal cal vals in K
; ncalib.crat:		float array [2,8,100], Calval_K/(TPCalON-TPCalOF) f/each cal event
; ncalib.Tsys:		float array [2,8,100], ncalib.crat x TPCalOF
; ncalib.nfit:		integer array [2,8] order of polyfit to crat vs. ctime
; ncalib.coeff:		double array [2,8,10], coeffs of polyfit to crat vs. ctime
; ncalib.medcrat:	float array [2,8], median crat over ncals
; ncalib.medTsys:	float array [2,8], median Tsys over ncals
; ncalib.cregions:	integer array [2,8,40], ch bounds of 20 regions for Total Power
; ncalib.Scals:		float array [2,8,3], cal values in Jy:
;			[*,*,0]: from last set of cross-scans
;			[*,*,1]: for avg of all cross-scans in run
;			[*,*,2]: adopted after cross-run inspection
;
;DESCRIPTION:
;
; In gory detail:
;
; step 1: dcalON, OF are read in; they contain the raw data for 
;	dcalON[ip,ical,ib].d[ich]), calOFF (dcalOF[ip,ical,ib].d[ich])
;	the two structures contain all cal data for whole obs. session
; step 2: looping in ip,ib, all spectra for a given [ip,ib] are displayed
;	and spectral masks are chosen. A sensible set of intervals
;       offered as a mask default
; step 3: for each [ip,ib] the ratio  crat=cal[K]/(calON-calOF) is
;	computed, where calON=TP avg of calON over the mask, etc.
; step 4: a 1D calx array is built, obtained reading from the header 
;	dcalON[ical,ip,0,ib].h.time
; step 5: for each [ip,ib], a polynomial is fit to crat=f(calx) and
;	the values of the fit coefficients are stored in ncalib
;
; RG/12Jan05 Modified from previous calib3.pro of Aug04
; RG/18Nov05 Fix to allow interactive change of mask window to properly work
; MH/18Nov09 Change regions to avoid new RFI => 1600 becomes 1560 
; MH/15Dec09 Revert back to 1600 since the RFI is fixed
;_____________________________________________________________________


pro calib2,dcalON,dcalOF,ncalib

;    Cals in (k) UNITS
;    THESE CAL VALUES (K) ARE APPROX APPROPRIATE FOR 1400 MHz
;    (AFTER TSYS MEMO BASED ON A1946 DATA)
     cals=fltarr(2,8)
     cals[0,*]=[12.00,10.67,11.34,11.21,10.99,11.17,11.63,11.63]
     cals[1,*]=[11.46,11.36,11.94,11.03,11.00,09.78,11.24,11.24]
; new set, 18Feb06, based on rescale_session computation using Jan06 gal HI data:
     cals[0,*]=[12.03,10.72,11.00,11.08,11.29,11.17,11.57,11.57]
     cals[1,*]=[11.48,11.92,11.21,10.98,11.50,08.94,11.71,11.71]

;    Cals in Jy: from values above, divided by 11.0(bm 0) or 8.5 K/Jy
;    WILL NEED TO INPUT DIRECTLY FROM CROSS-SCANS REDUCTION
     Scals=fltarr(2,8)
     Scals[0,*]=[1.091,1.255,1.334,1.319,1.293,1.314,1.368,1.368]
     Scals[1,*]=[1.042,1.336,1.405,1.298,1.294,1.151,1.322,1.322]


ncal=n_elements(dcalON[0,*,0])
nchn=n_elements(dcalON[0,0,0].d)
npol=n_elements(dcalON[*,0,0])
nbm =n_elements(dcalON[0,0,*])
if (npol ne 2 or nbm ne 8) then $
message,'Check size of input structure: npol or nbrd wrong'

; ANY BAD BOARDS IN SYSTEM?
brdstat=bytarr(2,8)+1
ans=''
print,'Any bad boards in system?'
read,ans
if (ans eq 'y' or ans eq 'Y') then begin
  print,'How many bad boards? [enter n]'
  read,nbad
  for ibad=0,nbad-1 do begin
    print,'Enter nbeam, npol of bad board'
    read,nbbad,npbad
    brdstat[npbad,nbbad]=0B
  endfor
endif

; INITIALIZE ncalib
ncalib={date:floor(dcalON[0,0,0].h.std.scannumber/100000.), $
        startime:dcalON[0,0,0].h.std.time, $
	stoptime:dcalON[0,ncal-1,0].h.std.time, $
	ncals:ncal, $
	RAhr0:reform(dcalON[0,*,0].rahr), $
	Decdeg0:reform(dcalON[0,*,0].decdeg), $
	AZ0:reform(dcalON[0,*,0].AZ), $
	ZA0:reform(dcalON[0,*,0].ZA), $
	ctime:reform(dcalON[0,*,0].h.std.time), $
	calvals:cals, $
	crat:fltarr(npol,nbm,ncal), $
	Tsys:fltarr(npol,nbm,ncal), $
	nfit:intarr(npol,nbm), $
	coeff:dblarr(npol,nbm,10), $
	cregions:intarr(npol,nbm,40), $
	medcrat:fltarr(2,8), $
	medtsys:fltarr(2,8), $
	Scals:fltarr(npol,nbm,3)}
ncalib.Scals[*,*,0]=Scals

; Make an avg calON, calOFF BP and display them

window, 1, retain=2,xsize=550,ysize=400,ypos=500
;tvlct, [70,255,0], [70,255,255], [70,0,0], 1

; VERIFY/MODIFY MASK, COMPUTE TP
crat=fltarr(npol,nbm,ncal)
Tsys=fltarr(npol,nbm,ncal)

for ip=0,npol-1  do begin
  for ib=0,nbm-1  do begin
    plot,dcalON[ip,0,ib].d,xrange=[400,nchn-400],yrange=[0.5,2.5], $
         xstyle=1,ystyle=1,xtitle='Ch. nr.',ytitle='Backend Counts', $
         title='CalON Spectra   Beam: '+strtrim(ib,2)+' pol:'+strtrim(ip,2), $
         xtickformat='(i4)'
    flag,[800,1600,2000,2800,3150,3400]
;   SET DEFAULT MASK
    mask=intarr(nchn)
    mask[800:1600]=1
    mask[2000:2800]=1
    mask[3150:3400]=1
    ncalib.cregions[ip,ib,0:5]=[800,1600,2000,2800,3150,3400]
    for ic=0,ncal-1 do begin
      oplot,dcalON[ip,ic,ib].d
    endfor
;  ADDED ON JAN 7, 2006, TO BYPASS INTERACTIVE CHANGE OF CREGIONS/ RG
    ans=''
    print,'Hit CR to view next board'
    read,ans
    GOTO,MAKAVS   ; CODE FROM HER TO MAKAVS IS NOW OBSOLETE
    Print, 'Mask OK? (CR=y)'
    ans=''
    read,ans
    if(strlowcase(ans) eq 'y' or strlowcase(ans) eq '') then begin
      goto, makavs
    endif else begin
      ncalib[ip,ib].cregions=0
    endelse

    icreg = 0
    mask=intarr(nchn)
    repeat begin
      print, 'Left click LEFT side of box, right k to exit...'
      cp, x=x, y=y
      xpos1=round(x)
      if (xpos1 lt 0.) then xpos1 = 0
      wait, 0.5
     if (!mouse.button eq 4) then goto, makavs
      print, 'Left click RIGHT side of box...'
      cp, x=x, y=y
      xpos2=round(x)
      if (xpos2 gt nchn-1) then xpos2=nchn-1
;      ncalib[ip,ib].cregions[icreg:icreg+1]=[xpos1,xpos2]
      ncalib.cregions[ip,ib,icreg:icreg+1]=[xpos1,xpos2]
;      print,ip,ib,icreg,icreg+1,ncalib.cregions[ip,ib,icreg:icreg+1]
      mask[xpos1:xpos2] = 1
      icreg=icreg+2
      wait, 0.5
    endrep until (!mouse.button eq 4)

    makavs:
;   OK, WE HAVE A MASK. NOW GET TPs FOR THAT BOARD
    TPcalON=fltarr(ncal)
    TPcalOF=TPcalON
    for ic=0,ncal-1 do begin
      TPcalON[ic]=total(reform(dcalON[ip,ic,ib].d)*mask)/total(mask)
      TPcalOF[ic]=total(reform(dcalOF[ip,ic,ib].d)*mask)/total(mask)
      crat[ip,ib,ic]=cals[ip,ib]/(TPcalON[ic]-TPcalOF[ic])
      Tsys[ip,ib,ic]=crat[ip,ib,ic]*TPcalOF[ic]
    endfor
  endfor
endfor

; LOAD COMPUTED ARRAY ON ncalib
ncalib.crat=crat
ncalib.Tsys=Tsys
ncalib.medcrat=median(crat,dimension=3,/even)
ncalib.medtsys=median(tsys,dimension=3,/even)
wdelete,1

; ZERO ENTRIES FOR BAD BOARDS
for nc=0,ncal-1 do begin
  ncalib.crat[*,*,nc]=reform(ncalib.crat[*,*,nc])*brdstat[*,*]
  ncalib.tsys[*,*,nc]=reform(ncalib.tsys[*,*,nc])*brdstat[*,*]
  ncalib.medcrat[*,*]=reform(ncalib.medcrat[*,*])*brdstat[*,*]
  ncalib.medtsys[*,*]=reform(ncalib.medtsys[*,*])*brdstat[*,*]
endfor

; SET UP TIME AXIS 

calx=ncalib.ctime
for ic=0,ncal-1 do begin
  if (calx[ic] lt calx[0]) then calx[ic]=calx[ic]+86400
endfor

; FIT crat ONE POL, ONE BEAM AT A TIME

for ib=0,nbm-1 do begin
  for ip=0,npol-1 do begin
    if (brdstat[ip,ib] eq 0) then begin
      ncalib.coeff[ip,ib,0]=0.D
      ncalib.nfit[ip,ib]=0
      goto,next_bm
    endif
    reset_crat:
    dummy=intarr(ncal)+1
    show_crat:
    ind=where(dummy eq 1)
    tmin=min(calx[ind])
    tmax=max(calx[ind])
    dt=0.05*(tmax-tmin)
    tsmin=min(tsys[ip,ib,ind])
    tsmax=max(tsys[ip,ib,ind])
    dts=0.3*(tsmax-tsmin)
    crmin=min(crat[ip,ib,ind])
    crmax=max(crat[ip,ib,ind])
    dcr=0.3*(crmax-crmin)

    window,2,retain=2,xsize=600,ysize=300,xpos=0,ypos=150, $
         title='Beam : '+strcompress(string(ib),/remove_all)+$
          '   Pol : '+strcompress(string(ip),/remove_all)
    plot,calx[ind],tsys[ip,ib,ind],psym=2,symsize=0.8, $
         xtitle='Time [AST sec]',ytitle='Tsys [K]', $
         xrange=[tmin-dt,tmax+dt],yrange=[tsmin-dts,tsmax+dts],xtickformat='(i5)', $
         title='This box is just for inspection: you are fitting the other box'
    xyouts,0.15,0.15,'Median='+strcompress(string(ncalib.medTsys[ip,ib])),/normal
    window,1, retain=2,xsize=600,ysize=300,$
    title='Beam : '+strcompress(string(ib),/remove_all)+$
          '   Pol : '+strcompress(string(ip),/remove_all),$
    xpos=0,ypos=600
    plot,calx[ind],crat[ip,ib,ind],psym=1,symsize=1.5,yrange=[crmin-dcr,crmax+dcr], $
         xrange=[tmin-dt,tmax+dt],xtitle='Time [AST sec]', $
         ytitle='Cal/(TPcalON-TPcalOF)  [K]', $
         title='K equivalent of 1 backend count',xtickformat='(i5)'
    xyouts,0.15,0.15,'Median='+strcompress(string(ncalib.medcrat[ip,ib])),/normal
    ans=''
    read,ans,prompt='Exclude points (e) restart (r) or fit (f)? (def=f)'
    if (strlowcase(ans) eq 'r') then goto, reset_crat
    if (strlowcase(ans) eq 'e') then begin
      dummy=intarr(ncal)+1
      repeat begin
        print, 'Left click on point to be excluded, right k to exit'
        cp,x=x,y=y
        wait,0.5
        if (!mouse.button eq 4) then goto, show_crat
        indx=where(abs(calx-x) lt 4.*min(abs(calx-x)) and $
             abs(crat[ip,ib,*]-y) lt 1.015*min(abs(crat[ip,ib,*]-y)))
        dummy[indx]=0
      endrep until (!mouse.button eq 4)
    endif      

  redy_to_fit:
    nfit=1L
    read,nfit,prompt='Enter fit order: '

    if (nfit eq 0) then begin
      ncalib.coeff[ip,ib,0]=median(crat[ip,ib,ind])
      ncalib.nfit[ip,ib]=0
      ymed=fltarr(100)+median(crat[ip,ib,ind])
      oplot,calx[ind],ymed
      read,ans,prompt='OK? (y/n), def=y'
      if (strlowcase(ans) eq 'n') then goto, reset_crat
      goto, next_bm
    endif

    a=poly_fit(calx[ind],crat[ip,ib,ind],nfit,yfit=yfit,/double)
    oplot,calx[ind],yfit
    read,ans,prompt='OK? (y/n), def=y'
    if (strlowcase(ans) eq 'n') then goto, reset_crat
;   if we got here, we're happy with the fit. Record it
    a=reform(a)
    for inf=0,nfit do begin
      ncalib.coeff[ip,ib,inf]=a[inf]
    endfor
    ncalib.nfit[ip,ib]=nfit
  next_bm:
  endfor
endfor

wdelete,1
wdelete,2

end
