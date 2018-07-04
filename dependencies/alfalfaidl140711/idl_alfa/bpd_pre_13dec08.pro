;+
; NAME:
;
; bpd  	BP calibrate, scale, 1st order baseline a drift; write to .SAV file
;
; SYNTAX:
;
; bpd, d,ncalib,brdstat=brdstat,calwhat=calwhat,poswhat=poswhat,
;      calmask=calmask,force_interp=force_interp, interp_reg=interp_reg,
;      dred,caldrift=caldrift,calsession=calsession,runpos=run_pos,mc=mc,BP2=BP2,
;      mask=mask,cont_bg=cont_bg,cont_pt=cont_pt, fileout=fileout
;
; PARAMETERS
;
; d		input drift structure
; ncalib	calibration structure (input) produced by calib2 from CAL scans
; brdstat	input bytarr (2,8) =1 if pol, beam OK, =0 if pol,beam bad.
;		Written to .SAV file.
; calwhat	input string ('new' or 'append') declaring whether a new or an
;		old calsession structure should be written to
; poswhat	input string ('new' or 'append') declaring whether a new or an
;		old runpos structure should be written to
; calmask	input byte array (nchn) defining the mask used for estimation
;		total power in CAL scans
; force_interp	if =1, then bandpass is interpolated across interp_reg
; interp_reg	edges of spectral intervals across which the bandpass is to be 
;		interpolated (normally across FAA radar and galactic HI)
; dred		output drift structure, bandpass calibrated, scaled (in K)
;		and baselined (sort of)
; caldrift	output calibration monitoring structure, containing beam
;		intensity ratios and values of cals that would apply if
;		current cal ratios were taken into account. Structure
;		is written in SAV file even if chosen not to be returned.
; calsession	array of caldrift structures for observing session;
;		updated with every drift. NOT written in .SAV file.
; runpos	array of positions for the run. Updated with every drift.
;		NOT written in .SAV file.
; mc		fltarr (10,2,nrec,8) of continuum intensities [K] in 10 
;		contiguous sections of the bandwidth, for each pol, rec, beam
; BP2		fltarr (4096,2,8) bandpasses (in instrumental units) for each
;		pol, beam in the drift. Written to .SAV file
; mask		bytarr (4096,2,nrec,8) mask defining sp chans over which mc array
;		was measured; cont_tot and cont_bg (see below) are measured over
;		mask*calmask. Written to .SAV file.
; cont_bg	fltarr (2,nrec,8) with background continuum (point sources subtracted)
; 		measured over a mask defined by mask*calmask (see above). 
;		Written to .SAV file.. 
; cont_pt	fltarr (2,nrec,8) continuum profile, pt sources only. Written to .SAV file.
;
; fileout       output file
;
; DESCRIPTION
;
; Procedure bpd calls bpc and bandpasses one polarization/beam board at a time.
; It then uses the contents of structure ncalib to convert data to K scale.
; It returns a bandpass calibrated, scaled drift structure (dred); the array
; of bandpasses used for each pol/bm combination (BP2); a caldrift and an
; updated calsession structures (which monitor the calibration of the data);
; an updated pos structure (runpos), containing positional information for
; all the spectra in the drift; a mask used for continuum total power
; computations (mask); the continuum background (excluding point sources) for
; each pol/beam/record in the drift (cont_bg), in K; the continuum contribution
; by point sources for each pol/beam/rec in the drift (cont_pt) in K; the
; continuum contribution by pt sources for each pol/beam/rec in the drift,
; separately for 10 contiguous segments of the 100 MHz bandwidth (excluding
; the 5.5% edges of the band), also in K (mc).
;
; It requires d and ncalib as inputs. Other inputs can be defaulted, but
; some defaults will give rise to trouble if applied blindly, e.g. brdstat,
; calsess, poswhat/
;
; The procedure also places a spectrum in the eight location of the nbeam
; dimension. This is an array of zeros where the median of the 7 beam spectra 
; are "normal". If that median is abnormal, e.g. strong RFI, galactic HI,
; that spectral channel contains the nonzero emdian in nb=8.
;
; Procedure also corrects occasional positional screw-ups of CIMA, the AO
; data taking user interface.
;
; It will also optionally place the correct positions in the IDL headers.
; This should not be neceessary in 2005, for finally AO is placing positions
; in fits headers for all beams (and not only beam 0). but the option is
; there.
;
; It also provides information in the IDL header which is absent from the
; fits header, such as central and rest frequency, heliocentric Doppler
; correction along the l.o.s.
;
; Further, it invokes make_caldrift and computes a caldrift structure,
; and it tags it on to the array of caldrifts structures calsession.
;
; Finally, it creates or appends a position structure for the run,
; and ti saves several of the products in an IDL .SAV file named, e.g.:
;   d074625+095451.502685667.sav
; where the first 6-digit number is the RA(J2000) of the first record
; of beam 0, the second 6-digit nr (and sign) is the Declination of that
; record, and the third 9-digit number is the scan number of the drift.
;
; RG: 30Jan05
; BK: 06Mar05
; RG: 23Mar05 - Modified format of pos /st, adding tags .scannumber and .badbox
;
;_____________________________________________________________________________________

pro  bpd, d,ncalib,brdstat=brdstat,calwhat=calwhat,poswhat=poswhat, $
      calmask=calmask,force_interp=force_interp, interp_reg=interp_reg,           $
      dred,caldrift=caldrift,calsession=calsession,runpos=runpos,mc=mc,BP2=BP2,  $
      mask=mask,cont_bg=cont_bg,cont_pt=cont_pt, fileout=fileout

t0=systime(1)
hor
ver

; GET DIMENSIONS
dred=d
nrec=n_elements(dred[0,*,0])
nchn=n_elements(dred[0,0,0].d)
nstrips=n_elements(dred[0,0,*])

;_______________________________________________________________
; FLAG BAD BOARDS
if(n_elements(brdstat) eq 0) then begin
  brdstat=bytarr(2,8)+1  ; BOARD STATUS; SET =0 FOR BAD BOARDS
  brdstat[0,1]=0
  for ib=0,nstrips-1 do begin
    for ip=0,1 do begin
      if (brdstat[ip,ib] eq 0) then begin
        print, 'BEAM=',ib,' POL=',ip,'  is taken to be BAD'
      endif
    endfor
  endfor
endif

; DECIDE ON NEW OR APPEND TO CALSESSION
;calwhat must be either 'new' or 'append'
if (n_elements(calsession) eq 0 and calwhat eq 'new') then begin
  calwhat='new'
  print,'Starting a new calsession...'
endif
if (calwhat eq 'append' and n_elements(calsession) eq 0) then $
  message,'You must indicate name of calsession structure...'

if (calwhat eq 'append' and n_elements(calsession) gt 0) then print, 'Appending to calsession...'

; NEW OR APPEND TO POSRUN, THE RUN POS /ST
; poswhat must be either 'new' or 'append'
if (n_elements(runpos) eq 0 and poswhat eq 'new') then begin
  poswhat='new'
  print,'Starting a new pos structure for the run...'
endif

if (n_elements(runpos) gt 0 and poswhat eq 'append') then print, 'Appending runpos structure with new record...'

if (poswhat eq 'append' and n_elements(runpos) eq 0) then $
  message,'You must indicate name of runpos structure...'

; SET CALMASK, IN CASE IT WASN'T INPUT; THIS IS MASK SUPPOSEDLY USED FOR CALS
if (n_elements(calmask) eq 0) then begin	; i.e., unless calmask is entered to override ncalib
  calmask=intarr(nchn)
  cregions=reform(ncalib.cregions[0,0,*])	; NOTE: we are assuming mask the same for all brds
  for nnr=0,19 do begin
    nnnr=nnr*2
    if (cregions[nnnr] eq 0) then goto,enough_cregion
    calmask[cregions[nnnr]:cregions[nnnr+1]]=1
  endfor
  enough_cregion:
;  calmask[800:1600] = 1
;  calmask[2000:2800]= 1
;  calmask[3150:3400]= 1
endif

; IN CASE NOT ENTERED, DEFINE DEFAULT SPECTRAL REGIONS TO INTERPOLATE ACROSS
if (n_elements(force_interp) eq 0) then force_interp=1
if (n_elements(interp_reg) eq 0) then begin
  interp_reg=[540,670,695,710,3490,3520]
endif

; CHECK FOR ncalib
if (n_elements(ncalib) eq 0) then message,'Structure ncalib unavailable; halting process'

;_______________________________________________________________

; INITIALIZE ARRAYS
mc=fltarr(10,2,nrec,nstrips)
mask=bytarr(nchn,2,nrec,nstrips)
BP2=fltarr(nchn,2,nstrips)
Cont_bg=fltarr(2,nrec,nstrips)
cont=fltarr(2,nrec,nstrips)
Tsys=fltarr(nrec)

dec=dred[0,0,0].decdeg
decd=floor(dec)
decx=(dec-decd)*60.
decm=floor(decx)
decs=round((decx-decm)*60.)
ra=dred[0,0,0].rahr
rah=floor(ra)
rax=(ra-rah)*60.
ram=floor(rax)
ras=round((rax-ram)*60.)
scan=dred[0,0,0].h.std.scannumber
name=string(rah,ram,ras,decd,decm,decs,scan,format='("d",3i2.2,"+",3i2.2,".",i9)')
ira00=rah*10000+ram*100+ras
idec00=decd*10000+decm*100+decs

; PROCESS ONE BEAM, ONE POL AT A TIME _______________________________________________
for ns=0,nstrips-2  do begin
   for np=0,1  do begin
     t00=systime(1)
;    GET CALMASK FROM ncalib
     calmask=bytarr(nchn)
     for creg=0,38,2 do begin
       i1 = ncalib.cregions[np,ns,creg]
       i2 = ncalib.cregions[np,ns,creg+1]
       if (i1 eq 0) then goto, skiploop
       calmask[i1:i2] = 1B
     endfor
     skiploop:
;    SKIP BAD BOARDS 
     if (brdstat[np,ns] eq 0) then begin
       dred[np,*,ns].d=-1.e20
       mask[*,np,*,ns]=0
       goto, endofloop
     endif
     s_in = reform(dred[np,*,ns].d)  ; THIS IS THE INPUT MAP
     for nr=0,nrec-1 do begin        ; MUST FIND A BETTER QUALITY CHECK THAN THIS
       index=where(finite(s_in[*,nr]) eq 0,badcount)            ;
       if (badcount gt 0) then s_in[index,nr]=0.                ;
       if (badcount gt nchn/2) then begin                       ;
         s_out=s_in                                             ;
         goto, writepol ; that's near the bottom of the loop    ;
       endif                                                    ;
     endfor                                                     ;
;    CALL BPC ROUTINE
     bpc, s_in,s_out,calmask=calmask,plot=plot,$
          force_interp=force_interp,interp_reg=interp_reg,$
          occupancy=occupancy,rmsarr=rmsarr,BPn=BPn,BP0=BP0,totBPg=totBPg, $
          mask_for_contstrips=mask_for_contstrips,Tsys_nosrc=Tsys_nosrc,$
          Cont_pts=Cont_pts,Totalcounts=Totalcounts,Cont_strips=Cont_strips

;    CONVERT TO TSYS (k) UNITS
;    STORE TSYS in HDR AT DRED.H.PROC.DAR[6] AND TCAL IN ...DAR[5]
     medTsys=ncalib.medTsys[np,ns]
     medCrat=ncalib.medCrat[np,ns]
     cgoodch=where(calmask ne 0,count)
     totBPc=mean(BP0[cgoodch])  ; MEAN TP OVER THE BP, OF THE CHNS USED FOR NCALIB

     dred[np,*,ns].h.proc.dar[5]=ncalib.calvals[np,ns]

     for nr=0,nrec-1  do begin
       Tsys[nr]=(totBPc/totBPg)*medCrat
;      ^^^ 	THIS WILL HAVE TO BE GENERALIZED TO: USE EITHER FIT OR MED
       dred[np,nr,ns].h.proc.dar[6]=Tsys[nr]
       dred[np,nr,ns].h.proc.iar[0]=ira00
       dred[np,nr,ns].h.proc.iar[1]=idec00
       dred[np,nr,ns].h.proc.iar[2]=scan
;      so that 'd'+[...].iar[0]+'+'+[...].iar[1]+'.'[...].iar[2]+'.sav' 
;      is the name of the save file with these data      
       s_out[*,nr]=s_out[*,nr]*Tsys[nr]
       Totalcounts[nr]=Totalcounts[nr]*Tsys[nr]
       Tsys_nosrc[nr]=Tsys_nosrc[nr]*Tsys[nr]
       Cont_pts[nr]=Cont_pts[nr]*Tsys[nr]
       Cont_strips[*,nr]=Cont_strips[*,nr]*Tsys[nr]
     endfor
     
; CONSTRUCT BP MASK, BP FOR EACH STRIP
     mask[*,np,*,ns]=mask_for_contstrips[*,*]
     BP2[*,np,ns]=BP0
     Cont_bg[np,*,ns]=Tsys_nosrc
     cont[np,*,ns]= Cont_pts[*]

     writepol:
;     sbpc[np,*,*] = s_out[*,*]
     cmax = max(Cont_pts)
     rcmax=where(Cont_pts ge cmax)
     for reg=0,9 do begin
       mc[reg,np,*,ns]=Cont_strips[reg,*]
     endfor
     for nrec=0,nrec-1  do begin
       dred[np,nrec,ns].d[*] = s_out[*,nrec]
     endfor
     t01=systime(1)
     print,ns,np,t01-t00,format='("Strip nr: ",i3,"  Pol:",i2,"  Time:",f6.1)'

   endofloop:
   endfor
endfor
;_____________________________________________________________________________________

t1=systime(1)
;print,'Done with bpc: ',t1-t0

; PUT MEDIAN (ACROSS BEAMS) IN EIGHTH "STRIP" (ns=7=nstrips-1),
; AND SET THE CHANNELS UNAFFECTED BY RFI OR STRONG SIGNALS TO ZERO

result = median(dred.d,DIMENSION=4,/EVEN)
hansmo=[0.5,1.,0.5]/2.
for np=0,1 do begin
  for nr=0,nrec-1 do begin
;   HANNING SMOOTHING FIRST
    smoothedspec = convol(result[*,np,nr],hansmo,/edge_truncate)
    medarr = fltarr(25)
    rmsarr = fltarr(25)
    for nstart=8,32 do begin
      n1=nstart*100
      medarr[nstart-8] = median(smoothedspec[n1:(n1+200)])
      rmsarr[nstart-8] = stddev(smoothedspec[n1:(n1+200)])
    endfor
    medmed = median(medarr)
    rmsmin = min(rmsarr)
    dred[np,nr,7].d = smoothedspec - medmed
    dummy = smoothedspec - medmed
    zindx = where (dummy lt 3.5*rmsmin and dummy gt -4.*rmsmin, zcount)
    dummy[zindx] = 0.
;   FLAG NONZERO ALSO THE (+/- 1) EDGES OF RFI INTERVALS
    zindx2=where(shift(dummy,1)-shift(dummy,-1) eq 0, zcount2)
;   zcount2 is zcount MINUS one chan on each side of strong features. i.e.
;   we extend the domain of "badness" +/- chans around each "bad" feature:
    dred[np,nr,7].d[zindx2] = 0.
  endfor
endfor

; IMPROVE BP NEAR GALACTIC HI
; FIRST GO THROUGH THE CHNS AROUND GAL HI AND RAISE BASELINE FLOOR TO 0 IF AVG << 0

for np=0,1 do begin
  for ns=0,6 do begin
    smod=reform(dred[np,*,ns].d[*])
    for ir=0,nrec-1 do begin
      smod[*,ir]=hans(3,smod[*,ir])
    endfor
    for ich=3440,3600 do begin
      yarr=smod[ich,*]
      medsecs,yarr,15,xmed,medarr,nmed  ; medsecs is part of bpc ==> already compiled
      result=sort(medarr)
      bottom=(medarr[result[0]]+medarr[result[1]])/2. ; call bottom the avg of the lowest 2 sections
      rms1=stdev(yarr[xmed[result[0]]-7:xmed[result[0]]+7])/3.74
      rms2=stdev(yarr[xmed[result[1]]-7:xmed[result[1]]+7])/3.74
      rms0=max(rms1,rms2)
      if (bottom lt -2*rms0) then dred[np,*,ns].d[ich]=dred[np,*,ns].d[ich]+abs(bottom)
    endfor
  endfor
endfor

; THEN SEE WHETHER THERE ARE SYSTEMATIC DEVIATIONS FROM THE TOTAL OF ALL BEAM/POL 
; AND APPLY IT, PROVIDED THAT IT DOES NOT LOWER BASELINE BELOW ZERO
;bpmed=median(dred.d,DIMENSION=3,/EVEN)
;totmed=median(bpmed,DIMENSION=3,/EVEN)
;totmed=median(totmed,DIMENSION=2,/EVEN)
;bpdiff=bpmed
;for np=0,1 do begin
;  for ns=0,6 do begin
;    bpdiff[*,np,ns]=bpmed[*,np,ns]-totmed
;    indx=where(totmed[3470:3520] gt 1)
;    factor=fltarr(nchn)+1.
;    factor[indx+3470]=factor[indx+3470]/totmed[indx+3470]
;    for ich=3470,3520 do begin
;      if (dred[np,*,ns].d[ich] gt bpdiff[ich,np,ns]*factor[ich]) then $
;      dred[np,*,ns].d[ich]=dred[np,*,ns].d[ich]-bpdiff[ich,np,ns]*factor[ich]
;    endfor
;  endfor
;endfor

;MUST CORRECT RAJ, WHICH OCCASIONALLY IS OFF BY 1-3 SEC...

ra1=reform(dred[1,*,0].rahr)
ra2=ra1
rec=dindgen(nrec)
goodrec=lindgen(nrec)
for nloop=0,2 do begin
  coeff = poly_fit(rec(goodrec),ra1(goodrec),1,YFIT=yfit, /DOUBLE)
  sdev = stddev(ra1[goodrec]-yfit,/NAN)
  rfit = coeff(0) + coeff(1)*rec
  resid = ra1 - rfit
  badrec = where(abs(resid) gt 10.*sdev,bad_count)
  goodrec = where(abs(resid) lt 10.*sdev,good_count)
endfor
dr=dblarr(nrec)
if(bad_count gt 0) then begin 
;  ra2[badrec]=coeff[0]+coeff[1]*rec[badrec]
;  dr[badrec]=ra2[badrec]-ra1[badrec]
;  for ns=0,7 do begin
;    dred[*,badrec,ns].rahr = dred[*,badrec,ns].rahr + dr[badrec]
;  endfor
;;  dred[*,badrec,0].rahr=ra2[badrec]
  Print,'RA errors encountered in this drift, nrecords=:',badrec
endif


;CORRECT POSITIONS FOR BEAMS OFF CENTER, SINCE AO IS STILL NOT
;DELIVERING ON PROPER HEADERS....
;raoff=dblarr(8)
;raoff=[0.D,+0.001278D,+0.006522D,+0.005247D,-0.001278D,-0.006528D,-0.005242D,-0.005242D]
;decoff=dblarr(8)
;decoff=[0.D,-0.104333D,-0.035500D,+0.069167D,+0.104333D,+0.034667D,-0.069500D,-0.069500D]
;for ib=0,7 do begin
;  dred[*,*,ib].rahr=dred[*,*,0].rahr+raoff[ib]
;  dred[*,*,ib].decdeg=dred[*,*,0].decdeg+decoff[ib]
;endfor
; Commented out section of 8 stts above b/c in mar05 b/c (1) they only apply to AZ=180,
; and (2) AO header positions appear to be now reliable

; PLACE CORRECT VALUES IN HEADER LOCATIONS
dred.h.dop.freqbcrest=1420.4058
if (dred[0,0,0].h.std.scannumber lt 503885135) then begin
  dred.h.iflo.if1.rffrq=1385.0000
endif else begin
  dred.h.iflo.if1.rffrq=0.0
; in this case vel array should be built from heliocentric d.h.dop.velorz=7663.0 km/s
endelse
if (dred[0,0,0].h.pnt.r.heliovelproj eq 0. and dred[0,0,0].h.pnt.r.geovelproj eq 0.) then begin
; HELIOVELPROJ COMPUTED FOR BM 0 OK FOR ALL
    rah0=dred[0,0,0].rahr
    decd0=dred[0,0,0].decdeg
    julday0=dred[0,0,0].hf.mjd_obs+2400000.5
    velarr0=chdoppler(rah0,decd0,julday0)  ;uses CHeiles' function
    rah9=dred[0,nrec-1,0].rahr
    decd9=dred[0,nrec-1,0].decdeg
    julday9=dred[0,nrec-1,0].hf.mjd_obs+2400000.5
    velarr9=chdoppler(rah9,decd9,julday9)  ;uses CHeiles' function
    dvel=(velarr9-velarr0)/(nrec-1)
    for nr=0,nrec-1 do begin
      dred[*,nr,*].h.pnt.r.heliovelproj=(velarr0[1]+dvel[1]*nr)/2.99792458e5
      dred[*,nr,*].h.pnt.r.geovelproj=(velarr0[0]+dvel[0]*nr)/2.99792458e5
    endfor
endif

; COMPUTE POL/BM RATIOS AND STORE IN caldrift, calsession
cont=reform(mc[6,*,*,*])
make_caldrift,dred,cont,caldrift,ncalib,brdstat=brdstat

; APPEND TO CALSESSION UNLESS CALSESSION IS NEW
if (calwhat eq 'new') then begin
  calsession=caldrift
endif else begin
  calsession=[calsession,caldrift]
endelse


t2=systime(1)
print,'Done with resetting headers: ',t2-t0
; PUT THINGS AWAY ON .SAV FILE
;cont_tot=fltarr(nrec,nstrips)
;for irec=0,nrec-1 do begin
;  cont_tot[irec,*]=total(reform(cont[*,irec,*])*brdstat[*,*],1)/total(brdstat,1)
;endfor
cont_pt=cont
fileout=name+'.sav'
save,dred,ncalib,caldrift,brdstat,mc,mask,BP2,Cont_bg,cont_pt,file=fileout
; dred 		IS THE PROCESSED STRUCTURE
; caldrift	IS THE CALIBRATION STRUCTURE
; mc		IS A [10,2,NREC,8] ARRAY OF CONTINUUM PS SOURCES, OVER 10 bw STRIPS
; mask		IS a [4096,2,NREC,8] BYTE ARRAY WITH MASK OVER WHICH CONTM WAS COMPUTED
; BP2		IS A [4096,2,8] ARRAY CONTAINING THE BANDPASSES FOR ALL STRIPS
; Cont_BG	IS A [2,NREC,8] ARRAY WITH CONTINUUM BACKGROUND (NO PT SRCS)
; cont_pt	IS A [2,NREC,8] ARRAY OF CONTINUUM PT SOURCES, BROAD BAND


; CREATE/APPEND A POS /ST FOR THE RUN

record={name:name+'.sav', $
         scannumber:dred[0,0,0].h.std.scannumber, $
         posang:dred[0,0,0].hf.alfa_ang, $
         cenRAhr:dred[0,nrec/2,0].rahr, $
         cenDecdeg:dred[0,0,0].decdeg, $
         az0:dred[0,0,0].az, $
         za0:dred[0,0,0].za, $
         rahr:reform(dred[0,*,*].rahr), $
         decdeg:reform(dred[0,*,*].decdeg), $
         cont:cont_pt, $
         status: fltarr(2,nrec,8), $
         badbox: intarr(100,2,8,4)}
record.cont=cont_pt
if(poswhat eq 'new') then begin
  runpos=record
endif else begin
  runpos=[runpos,record]
endelse

!p.multi=0
t3=systime(1)
print,'Fine: ',t3-t0

end
