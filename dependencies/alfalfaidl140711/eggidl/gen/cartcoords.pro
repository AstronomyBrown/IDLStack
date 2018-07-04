
PRO SC, RAR, DECR, RAD, X, Y, Z
;+
;NAME:
;	SC
;PURPOSE:
;	Converts from Spherical to Cartesian coordinates.
;
;SYNTAX:
;	SC, rar, decr, rad, x, y, z
;
;INPUTS:
;	rar - RA in radians
;	decr - Dec in radians
;	rad - the radius of the sphere of interest
;
;OUTPUTS:
;	x - x value
;	y - y value
;	z - z value
;
; MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-

;Check arguments and keywords
if(n_params() ne 6) then message, 'Usage: SC, rar, decr, rad, x, y, z'

rar=float(rar)
decr=float(decr)
rad=float(rad)

X=rad*COS(decr)*COS(rar)
Y=rad*COS(decr)*SIN(rar)
Z=rad*SIN(decr)


END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO SSGC, SGLR, SGBR, RAD, SGX, SGY, SGZ
;+
;NAME:
;	SSGC
;PURPOSE:
;	Converts from SG Sphericals to Cartesians
;
;SYNTAX:
;	SSGC, sglr, sgbr, rad, sgx, sgy, sgz
;
;INPUTS:
;	sglr - spherical SG long in radians
;	sgbr - spherical SG lat in radians 
;	rad - the radius of the sphere of interest
;	
;
;OUTPUTS:
;	sgx - x value result from SG conversion
;	sgy - y value result
;	sgz - z value result
;
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-

;Check arguments and keywords
if(n_params() ne 6) then message, 'Usage: ssgc, sglr, sgbr, rad, sgx, sgy, sgz'

sglr=float(sglr)
sgbr=float(sgbr)
rad=float(rad)

sgx=rad*COS(sgbr)*COS(sglr)
sgy=rad*COS(sgbr)*SIN(sglr)
sgz=rad*SIN(sgbr)

END

