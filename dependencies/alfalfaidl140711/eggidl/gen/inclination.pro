
FUNCTION CORRECTEDBOVERA, VISUALRATIO

;+
;NAME: 
;	CORRECTEDBOVERA
;
;PURPOSE:
;	Uses Lewis (1980) to correct for visual underestimate
;	of axial ratio b/a, with decreasing b/a
;
;SYNTAX: 
;	result=CORRECTEDBOVERA(visualratio)
;
;INPUTS: 
;	visualratio - b/a
;OUTPUTS: 
;	corbovera - the corrected visual ratio, used by INCLINATION
;
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-	

if(VISUALRATIO ge 0.78) then begin
	corbovera=visualratio
endif else if(VISUALRATIO ge 0.637) then begin
	corbovera=2.943*(SQRT(1 + 0.77*VISUALRATIO) -1)
endif else begin
	corbovera=10.33*(SQRT(1 + 0.204*VISUALRATIO) - 1)
endelse


return, corbovera

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


FUNCTION SFEROD, BOVERA, HGTYPE

;+
;NAME: 
;	SFEROD
;
;PURPOSE:
;	Computes square of cos(inc), assuming different
;	intrinsic axial ratios for diff. morph types (Lewis 1980)
;
;SYNTAX: 
;	result=SFEROD(bovera,hgtype)
;
;INPUTS: 
;	bovera - the visual ratio
;	hgtype - HG type
;OUTPUTS: 
;	sferodout - used by INCLINATION
;
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-	

trueratio=[0.23,0.23,0.23,0.23,0.20,0.175,0.140,0.103,0.10,0.10,0.175,0.175,0.175,0.175,0.175]
sferodout= ((bovera^2) - ((trueratio[hgtype])^2)) / (1 - ((trueratio[hgtype])^2))

if(sferodout le .00000001) then begin
	sferodout=.00000001
endif

return, sferodout

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


FUNCTION FACEON, RATIO, HGTYPE

;+
;NAME: 
;	FACEON
;
;PURPOSE:
;	This function computes the true axial ratio a/b as a function
;	of HG type using the recursion relation of Dickel and Rood.
;
;SYNTAX: 
;	result=FACEON(ratio,hgtype)
;
;INPUTS: 
;	ratio - uncorrected axial ratio
;	hgtype - HG type
;OUTPUTS: 
;	faceout
;
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-	

datac=[-.01,0.02,0.02,0.04,0.04,0.04,0.04,0.02,0.02,0.01,0.01,0.04,0.04,0.04,0.04]
datad=[0.92,0.65,0.65,0.73,0.73,0.73,0.73,0.74,0.74,0.75,0.75,0.73,0.73,0.73,0.73]

faceout=cdata[hgtype] + ddata[hgtype]*ALOG10(ratio)

return, faceout

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO INCLINATION, A, B, HGTYPE, DINCL, BOVERA, CORRDINCL

;+
;NAME:
;	INCLINATION
;PURPOSE:
;	To calculate inclination based on type and visual axis ratio.
;
;SYNTAX:
;	INCLINATION, a, b, hgtype, dincl, bovera, corrdincl
;
;INPUTS:
;	a
;	b
;	hgtype - HG type
;	dincl - inclination in degrees
;
;OUTPUTS:
;	corrdincl - corrected inclination
;	bovera - corrected ratio
;	
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-

;Check arguments and keywords
if(n_params() ne 6) then message, 'Usage: inclination, a, b, hgtype, dincl, bovera, corrdincl'

a=float(a)
b=float(b)
dincl=float(dincl)

if((A eq 0) OR (B eq 0)) then begin
	print,'a or b is zero. Continuing.'
endif 

if(A eq 0) then begin
	A=0.7
endif
if(B eq 0) then begin
	B=0.9*A
endif

BOVERA=CORRECTEDBOVERA(B/A)
COS2I=SFEROD(BOVERA,HGTYPE)

if(COS2I gt .00000001) then begin
	CORRDINCL=57.296*ACOS(SQRT(COS2I))
endif else begin
	CORRDINCL=90
endelse

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


