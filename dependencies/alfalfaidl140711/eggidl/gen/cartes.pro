
FUNCTION CARTES, R1, R2, D1, D2

;+
;NAME: 
;	CARTES
;
;PURPOSE:
;	Calculates the separation between two objects. Input and output in radians!
;
;SYNTAX: 
;	result=CARTES(r1,r2,d1,d2)
;
;INPUTS: 
;	r1 - RA of object one in rad
;	r2 - RA of object two in rad
;	d1 - Dec of object one in rad
;	d2 - Dec of object two in rad
;OUTPUTS: 
;	result - separation of objects in rad
;
;MODIFICATION HISTORY:
;	Converted to IDL A. Martin June 2006
;-	

;Check arguments and keywords
if(n_params() ne 4) then message, 'Usage: result=cartes(r1,r2,d1,d2)'
r1=float(r1)
r2=float(r2)
d1=float(d1)
d2=float(d2)

COSSEP = SIN(D1)*SIN(D2) + COS(D1)*COS(D2)*(COS(R1)*COS(R2) + SIN(R1)*SIN(R2))

;There are a few different ways to make sure COSSEP can be defined as a cosine:
;COMPARE1=[COSSEP,1.0]
;COSSEP=MIN(compare1)
;COMPARE2=[COSSEP,-1.0]
;COSSEP=MAX(compare2)

;if(COSSEP LT 1.0) then COSSEP=COSSEP else COSSEP=1.0
;if(COSSEP GT (-1.0)) then COSSEP=COSSEP else COSSEP=(-1.0)

;I chose:

COSSEP = COSSEP < 1.0
COSSEP = COSSEP > (-1.0)
S=ACOS(COSSEP)

RETURN, s
END
