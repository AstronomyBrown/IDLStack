
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTION BEAMCORR1GAUSS, HIDIAM, COS2I,TELCODE

;+
;NAME: 
;	BEAMCORR1GAUSS
;
;PURPOSE:
;	To correct for beam dilution. beamdiluchoice=1 calls BEAMCORR1GAUSS.
;
;SYNTAX: 
;	result=BEAMCORR1GAUSS(hidiam,cos2I,telcode)
;
;INPUTS: 
;	hidiam - in arcmin
;	cos2I - from fluxcorrection
;	telcode - telescope code (string)
;
;OUTPUTS: 
;	bc1gauss - the correction factor, used in FLUXCORRECTION
;
;-	

if(TELCODE eq '0') then begin 
	HPBW=3.3 
endif else if(TELCODE eq '1') then begin 
	HPBW=10.0 
endif else if(TELCODE eq '2') then begin 
	HPBW=8.8 
endif else if(TELCODE eq '3') then begin 
	HPBW=21.0 
endif else if(TELCODE eq '4') then begin 
	HPBW=3.8 
endif else if(TELCODE eq 'G') then begin 
	HPBW=3.5 
endif else if(TELCODE eq 'H') then begin 
	HPBW=15.5 
endif else if(TELCODE eq 'J') then begin 
	HPBW=3.5 
endif else if(TELCODE eq 'K') then begin 
	HPBW=9.0 
endif else begin 
	BC1GAUSS=1.0
	return, BC1GAUSS
endelse

BETASQ=(0.76*(HIDIAM/HPBW))^2
BC1GAUSS=SQRT( (1 + BETASQ)*(1+ BETASQ*COS2I))

return, BC1GAUSS

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTION BEAMCORR2GAUSS, HIDIAM, COS2I,TELCODE

;+
;NAME: 
;	BEAMCORR2GAUSS
;
;PURPOSE:
;	To correct for beam dilution. beamdiluchoice=0 calls BEAMCORR2GAUSS.
;
;SYNTAX: 
;	result=BEAMCORR2GAUSS(hidiam,cos2I,telcode)
;
;INPUTS: 
;	hidiam - in arcmin
;	cos2I - from fluxcorrection
;	telcode - telescope code (string)
;
;OUTPUTS: 
;	bc2gauss - the correction factor, used in FLUXCORRECTION
;
;-	

if(TELCODE eq '0') then begin 
	HPBW=3.3 
endif else if(TELCODE eq '1') then begin 
	HPBW=10.0 
endif else if(TELCODE eq '2') then begin 
	HPBW=8.8 
endif else if(TELCODE eq '3') then begin 
	HPBW=21.0 
endif else if(TELCODE eq '4') then begin 
	HPBW=3.8 
endif else if(TELCODE eq '6') then begin 
	HPBW=14.0 
endif else if(TELCODE eq 'C') then begin 
	HPBW=4.0 
endif else if(TELCODE eq 'G') then begin 
	HPBW=3.5 
endif else if(TELCODE eq 'H') then begin 
	HPBW=15.5 
endif else if(TELCODE eq 'J') then begin 
	HPBW=3.5 
endif else if(TELCODE eq 'K') then begin
 	HPBW=9.0 
endif else begin 
	BC2GAUSS=1.0
	return, BC2GAUSS
endelse

NUMER= HIDIAM/(2.2)
DENOM=HPBW/(2.0*SQRT(ALOG(2.)))
RATIO=(NUMER/DENOM)^2
ONE=1.0328/( SQRT( (1.0 + RATIO) *(1.0 + RATIO*COS2I)))
TWO=0.0328/( SQRT( (1.0+0.0529*RATIO)*(1.0+0.0529*RATIO*COS2I)))
BC2GAUSS=1.0/(ONE-TWO)

return, BC2GAUSS

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTION HIABSHG, HGTYPE, BOVERA

;+
;NAME: 
;	HIABSHG
;
;PURPOSE:
;	To correct for internal HI absorption, as a function
;	of visual ratio and the HG type of the galaxy.
;
;SYNTAX: 
;	result=HIABSHG(hgtype,bovera)
;
;INPUTS: 
;	hgtype - HG galaxy type.
;	bovera - the visual ratio
;OUTPUTS: 
;	hiabresult - the correction to the flux, used in FLUXCORRECTION
;
;-	

exponent=[0.0,0.0,0.0,0.04,0.08,0.16,0.14,0.14,0.0,0.0,0.0,0.16,0.16,0.16,0.16]
hiabresult= bovera^(-(exponent[hgtype]))
return, hiabresult

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FLUXCORRECTION, HIDIAM, DINCL, BOVERA, HGTYPE, TELCODE, BEAMDILUCHOICE

;+
;NAME:
;	FLUXCORRECTION
;PURPOSE:
;	To correct the HI flux for
;	1) pointing error . . . add a flat 5% for Arecibo
;	2) beam dilution
;	3) internal HI absorption
;
;SYNTAX:
;	result= FLUXCORRECTION(hidiam, dincl, bovera, hgtype, telcode, beamdiluchoice)
;
;INPUTS:
;	hidiam - in arcmin
;	dincl - inclination angle in degrees
;	bovera - visual ratio
;	hgtype - HG type (an integer)
;	telcode - telescope code (string)
;	beamdiluchoice - an integer. 0 calls BEAMCORR2GAUSS, 1 calls BEAMCORR1GAUSS, any other
;			choice sets the 2nd correction = 1.0
;
;OUTPUTS:
;	result - total flux correction from all 3 contributions - corr1*corr2*corr3
;
; MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-


onedeg=!dpi/180
dincl=float(dincl)
hidiam=float(hidiam)
bovera=float(bovera)

;corr 1: 1st correction for pointing error
;TELCODE=0 applies a flat 5%; no pointing error applied for other telcodes
if(TELCODE eq '0') then begin
	corr1=1.05 
endif else begin
	corr1=1.00
endelse

rincl=dincl*onedeg
cosrincl=cos(rincl)

;corr 2: 2nd correction for beam dilution.
;Corrections are based on HIDIAM, TELCODE, and inclination angle

if(BEAMDILUCHOICE eq 0) then begin
	corr2=BEAMCORR2GAUSS(HIDIAM,COSRINCL^2,TELCODE)
endif else if(BEAMDILUCHOICE eq 1) then begin
	corr2=BEAMCORR1GAUSS(HIDIAM,COSRINCL^2,TELCODE)
endif else begin
	corr2=1.0
endelse

;corr 3: 3rd correction for internal HI absorption
;Correction is based on visual ratio and HG type.
corr3=HIABSHG(HGTYPE,BOVERA)
fluxcorrout=corr1*corr2*corr3

RETURN, fluxcorrout
END

