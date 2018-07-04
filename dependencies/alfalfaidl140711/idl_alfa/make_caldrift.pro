;+
; make_caldrift.pro	produces a caldrift structure and creates/appends to calsession
;
; SYNTAX
;
;	make_caldrift,dred,cont,caldrift,ncalib,brdstat=brdstat,HIchns=HIchns
;
; PARAMETERS
;
;	dred		input drift /st
;	cont		input continuum drift fltarr[2,nrec,8]
;	caldrift	output caldrift /st
;	ncalib		input ncalib /st
;	brdstat		status of pol/bm boards (0 if bad)
;	HIchns		intarr(2): 1st, last sp.chn. of Galactic HI line
;			if HIchns not specified, it will find the peak ch
;			of gal HI, pkch, and set HIchns=[pkch-1,pkch+1]
;
; DESCRIPTION OF caldrift \st
;
;	.name		string, name of drift scan
;       .scannr		lon, scan number
;	.mjd		dbl, modified Julian date of center record in drift
;	.startime	flt, in AST seconds after midnite
;	.stoptime	flt, in AST seconds after midnite
;	.ZA0		flt, ZA of beam 0
;	.AZ0		flt, AZ of beam 0
;	.polrat_cont	fltarr [8,3]; [*,0]= Pol0/Pol1 f/each bm, using cont profile
;				      [*,1]= same, for full calsession, backfilled later
;				      [*,2]= same, backfilled after end of run
;	.polrat_cont_err fltarr[8,3]; error on above; 2nd index as above
;	.polrat_line	fltarr [8,3]; Pol0/Pol1 f/each bm, using Gal HI
;				      second index as described above
;	.eqp_Tcals	fltarr [2,8,3]; TCals updated to accomodate polrat_line
;				      last index as above
;	.eqp_Tsys	fltarr [2,8,3]; as above, for Tsys
;	.chns_used	intarr [2]; chn. boundaries of interval for Galactic HI
;	.bmrat		fltarr [8,3]; line ratio of each bm to avg of all bms
;				      second indx as last in polrat_cont etc.
;	.eqbm_Tcals	fltarr [2,8,3]; Tcals updated to accomodate polrat_line, bmrat
;					last indx as above
;	.eqbm_Tsys	fltarr [2,8,3]; as above, for Tsys
;	.Scals		fltarr [2,8,3]; cals in Jy, copied from ncalib /st
;
; We keep track of changes in the cal values, by monitoring spectral line 
; (Galactic HI) and continuum ratios between pols of a given beam ("eqp")
; and spectral line ratios between a given beam and the avg of all beams 
; ("eqbm"). 
; .chns_used define the spectral range over which Galactic HI is avged.
; The .eqp_Tcals are the values used in scaling the drift data (ncalib.calvals)
; CORRECTED in the amount necessary to compensate for the eqp_polrat. I.e.,
; for a given bm the sum of calvals remains the same, their ratio is altered
; so that *if used corrected y those ratios* thescaled data would yield polratios
; identical to 1. The .eqp.Tsys are the Tsys that would result from those .eqp_Tcals.
; .bmrat uses the T_a of Pol0+Pol1 for each bm, avg over chns_used of Galactic HI,
; over the avg of all beams.
; .eqbm_Tcals uses .bmrat AND .polrat_line to obtain revised cal values
; .eqbm_Tsys are the corresponding Tsys
; Values of .polrat_cont, .polrat_line, eqp_Tcals, eqp_Tsys, eqbm.bmrat,
; eqbm_Tcals, .eqbm_Tsys corresponding to the higher values of the last 
; index of their arrays are not filled by this procedure, but rather  
; they are backfilled when a fulll session (or run) has been reduced.
; 
; RG 15Jan05
;
;________________________________________________________________________________

pro make_caldrift,dred,cont,caldrift,ncalib,brdstat=brdstat,HIchns=HIchns

;t0=systime(1)

if (n_elements(HIchns) eq 0) then begin
  spec=median(dred.d,dimension=4)
  spec2=median(spec,dimension=3)
  pk=max(spec2[3490:3510,0],chnr)
  pkch=chnr+3490
  chns_used = [(pkch-1),(pkch+1)]
endif else begin
  chns_used = HIchns
endelse
if (n_elements(brdstat) eq 0) then brdstat=bytarr(2,8)+1B

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

nrec=n_elements(dred[0,*,0])

; IF caldrift DOES NOT EXIST, CREATE IT; IF IT EXISTS, OVERWRITE IT
caldrift={name:name, $
	scannr:dred[0,0,0].h.std.scannumber, $
        mjd:dred[0,nrec/2,0].hf.mjd_obs, $
        startime:dred[0,0,0].h.std.time, $
        stoptime:dred[0,nrec-1,0].h.std.time, $
        za0:dred[0,0,0].ZA, $
        az0:dred[0,0,0].AZ, $
        polrat_cont:fltarr(8,3), $
        polrat_cont_err:fltarr(8,3), $
        polrat_line:fltarr(8,3), $
        eqp_Tcals:fltarr(2,8,3), $
        eqp_Tsys:fltarr(2,8,3), $
        chns_used:chns_used, $
        bmrat:fltarr(8,3), $
        eqbm_Tcals:fltarr(2,8,3), $
        eqbm_Tsys:fltarr(2,8,3), $
        Scals:fltarr(2,8,3)} 

; SET UP COMPARISON ARRAYS
galHI=total(dred[*,*,*].d[chns_used[0]:chns_used[1]],1)/float(chns_used[1]-chns_used[0]+1)
for ib=0,7 do begin
  for ip=0,1 do begin
    if (brdstat[ip,ib] eq 0) then galHI[ip,*,ib] = 0.
  endfor
endfor
  
; GET RATIO OF CAL 0 TO CAL 1 FOR EACH BEAM, AVG OVER DRIFT
prat_rec=fltarr(nrec,8)
for irec=0,nrec-1 do begin
  prat_rec[irec,*]=galHI[0,irec,*]/galHI[1,irec,*]
endfor
lprat=total(reform(prat_rec),1)/float(nrec) ;size nbeams

; GET TCals, Tsys, CORRECTED AFTER EQUALIZING POLS ON GAL HI
eqp_Tcals=fltarr(2,8,3)
eqp_Tsys =fltarr(2,8,3)
for ib=0,6 do begin
    sumdef=ncalib.calvals[0,ib]+ncalib.calvals[1,ib]
    ratdef=ncalib.calvals[0,ib]/ncalib.calvals[1,ib]
    eqp_Tcals[0,ib,0]=(sumdef*ratdef)/(lprat[ib]+ratdef)
    eqp_Tcals[1,ib,0]=(sumdef*lprat[ib])/(lprat[ib]+ratdef)
    if (brdstat[0,ib] eq 0 and brdstat[1,ib] ne 0) then begin
      eqp_Tcals[0,ib,0] = sqrt(-1.)
      eqp_Tcals[1,ib,0] = ncalib.calvals[1,ib]
    endif
    if (brdstat[1,ib] eq 0 and brdstat[0,ib] ne 0) then begin
      eqp_Tcals[1,ib,0] = sqrt(-1.)
      eqp_Tcals[0,ib,0] = ncalib.calvals[0,ib]
    endif
    eqp_Tsys[*,ib,0]=ncalib.medtsys[*,ib]*eqp_Tcals[*,ib]/ncalib.calvals[*,ib]
    for ip=0,1 do begin
      if(brdstat[ip,ib] eq 0) then eqp_Tsys[ip,ib,0]=0.
    endfor
endfor

; GET RATIOS OF BM i (POL 0 + POL 1) TO AVG OF ALL BMS, AVG THROUGH DRIFT
ratpb_rec=fltarr(nrec,8)
for irec=0,nrec-1 do begin
    avgpb=total(reform(galHI[*,irec,*])*brdstat[*,*])/total(brdstat)
    sum2=total(reform(galHI[*,irec,*])*brdstat[*,*],1)/total(brdstat,1)
    ratpb_rec[irec,*]=sum2[*]/avgpb
endfor
ratpb=median(ratpb_rec,DIMENSION=1) 
; AND GET TCals, Tsys CORRECTED AFTER EQUALIZING BEAMS ON GAL HI
eqbm_Tcals=eqp_Tcals
;eqbm_Scals=eqp_Tcals
eqbm_Tsys =eqp_Tsys
for ip=0,1 do begin
    eqbm_Tcals[ip,*,0]=eqp_Tcals[ip,*,0]/ratpb[*]
    eqbm_Tsys [ip,*,0]=eqp_Tsys [ip,*,0]/ratpb[*]
endfor

; GET RATIO OF CAL 0 TO CAL 1, AFTER EQUALIZING POLS ON CONT SRCS
; (USES PART OF CONT PROFILE WITH T_A>0.3 K
crat=fltarr(8)
crat_err=fltarr(8)
for ib=0,6 do begin
    hirec=where(reform(cont[1,*,ib]) gt 0.3,himany)
    if (himany ge 3) then begin
      cont_rat=reform(cont[0,hirec,ib]/cont[1,hirec,ib])
      crat_err[ib]=stddev(cont_rat)/sqrt(himany-1)
      crat[ib]=median(cont_rat)
    endif else begin
      crat[ib]=sqrt(-1.)
      crat_err[ib]=sqrt(-1.)
    endelse
    endloop:
endfor

;FILL THE rest of the STRUCTURE caldrift
  caldrift.polrat_cont[*,0]    =crat
  caldrift.polrat_cont_err[*,0]=crat_err
  caldrift.polrat_line[*,0]    =lprat
  caldrift.eqp_Tcals           =eqp_Tcals
  caldrift.eqp_Tsys            =eqp_Tsys
  caldrift.bmrat[*,0]          =ratpb
  caldrift.eqbm_Tcals          =eqbm_Tcals
;  caldrift.eqbm_Scals          =eqbm_Scals
  caldrift.eqbm_Tsys           =eqbm_Tsys
  caldrift.Scals               =ncalib.Scals

;t1=systime(1)
;print,t1-t0,' seconds to complete'

end


