;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;+
; NAME:
;	DISTANCE_GUESS
;
; PURPOSE:
;	Quickly and dirty determination of distance to a galaxy (in Mpc)
;	given its coordinates and velocity (in km/s)
;	Designed to be flexible in terms of possible inputs
;
; CALLING SEQUENCE:
;	DISTANCE_GUESS, C1, [C2,] V, [H_0, /RADIANS, /GALACTIC, /SUPERGALACTIC, /CMB]
;
; INPUT PARAMETERS:
;	c1, c2       - The input coordinates.  By default, in RA and declination, but optional
;				keywords allow them to be galactic or supergalactic coordinates
;			 The coordinates can also be entered as a single string of the format 'HHMMSS.S+DDMMSS'
;			 Coordinates can either be a decimal value or a string
;	v            - Velocity, in km/s. by default should be heliocentric velocity
;
; OPTIONAL INPUT PARAMETERS:
;	H_0	       - Hubble's constant. Defaults to 70 km/s / Mpc if not specified.
;
; OPTIONAL INPUT KEYWORDS:
;       /RADIANS       - The coordinates given are in radians
;	/GALACTIC      - coordinates are with respect to galactic plane
;	/SUPERGALACTIC - coordinates are with respect to supergalactic plane
;	/CMB           - velocity is with respect to the CMB, rather than heliocentric
;
; DEPENDS ON:
;	VHEL_TO_CMB, MYFLOWMODELCALL from @ALFINIT
;
;MODIFICATION HISTORY:
;	Created.		G. Hallenbeck	Dec.2009
;-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION GETDEC, DATA
;+
; NAME:
;	GETDEC()
;
; PURPOSE:
;	Convert a string in the format 'DD:MM:SS' and various permutations 
;	to floating-point degrees or radians.
;	The degrees, minutes, or seconds can be negative, and there can be
;	a colon, space, or no separator between the values.
;	Each digit must be exactly two characters long, except the seconds.
;
; CALLING SEQUENCE:
;	degrees = GETDEC (data)
;
; INPUTS:
;	data     - a string containing the degrees
;	/radians - optional keyword indicating result should be
;		returned in radians instead of degrees
;
; OUTPUTS:
;	A double degree value
;
; EXAMPLES:
;
;	IDL> print, getdec('001522.1+120000')
;		--> 0.25613889       12.000000
;
;	IDL> print, getdec('-00:15:10')
;		--> -0.25277778
;
;	IDL> print, getdec('-001510.5')
;		--> -0.25291667
;
; MODIFICATION HISTORY:
;	Created.			G. Hallenbeck	Jan.2010
;	Made significantly better	G. Hallenbeck	Feb.2010
;	  (made it find both RA and DEC, as well as dealing with the AGC format of RA)
;-

; Check if both RA and DEC are being included in one long string
if ( n_elements(strsplit(data, '+')) eq 2 or n_elements(strsplit(data,'-')) eq 2) then begin
	splitloc = strpos(data, '+') > strpos(data, '-')
	ra = getdec(strmid(data, 0, splitloc))
	dec = getdec(strmid(data, splitloc))

	return, [ra, dec]
endif

; Regular expression extraction
regex = '(-?[0-9]{2})[:h ]?(-?[0-9]{2})[:m ]?(-?[0-9\.]{2,4})'

result = stregex(data, regex, /extract, /subexpr)
deg  = abs(double(result[1]))
min  = abs(double(result[2]))
sec  = abs(double(result[3]))

; The seconds are complicated: if it goes XX.X or XX, then keep it as is,
; but if just XXX then need to divide by 10.
if (strlen(result[3]) eq 3 and strpos(result[3],'.') eq -1) then sec = sec/10.0

sign = (strpos(data,'-') eq -1) ? (1) : (-1)

; Convert the newfound data into degrees
deg = sign* (deg + min/60.0 + sec/3600.0)

return, deg

END





PRO DISTANCE_GUESS_VERBOSE, RA, DEC, VEL, DIST, EDIST, F1, F2, VEL_CMB, H_0 = H_0, CMB=CMB

radperdeg = !dpi/180.0

if (n_elements(H_0) eq 0) then H_0 = 70.0	; Determine if Hubble's constant is set or not.

;ra = coord[0]
;dec = coord[1]

co1r = ra * radperdeg				; Convert degrees to radians
co2r = dec * radperdeg

glactc,ra,dec,2000,l,b,1, /DEGREE		; Find galactic coordinates

if (keyword_set(CMB)) then begin
	vel_cmb = vel						; It's already in CMB rest frame
endif else begin
	vel_cmb = vhel_to_cmb(l,b) + vel	; Gotta convert it
endelse

; Now, calculate distance
if (vel_cmb ge 6000.0) then begin		; Use pure Hubble flow
	dist = vel_cmb/H_0
	edist = 0
	distancekms = vel_cmb
	f1 = -1
	f2 = 99
endif else begin				; Use the flow model
	velopt = 0				; Things that need to be defined for the flow model
	copt = 0
	myflowmodelcall,co1r,co2r,0,vel_cmb,1,distancekms,edistkms,flag
	dist = distancekms/H_0
	edist = edistkms/H_0
	f1 = flag
	f2 = 94
endelse

END






































PRO DISTANCE_GUESS, C1, C2, V, H_0 = H_0, RADIANS=RADIANS, GALACTIC=GALACTIC, SUPERGALACTIC=SUPERGALACTIC, CMB=CMB

CELES = 0 ; Set these constants for readability of code
GALAC = 1
SUPER = 2
radperdeg = !dpi/180.0

; Check to see if we're using one coordinate input or two
if (n_elements(v) eq 0) then begin
	co1 = strmid(c1, 0, 8)
	co2 = strmid(c1, 8, 7)
	vel = c2	
endif else begin
	co1 = c1
	co2 = c2
	vel = v
endelse



; Determine if Hubble's constant is set or not.
if (n_elements(H_0) eq 0) then H_0 = 70.0

; Determine what coordinate system is in use, as defined by MYFLOWMODEL
if (keyword_set(galactic)) then begin
	copt = GALAC
endif else begin
	if (keyword_set(supergalactic))  then copt = SUPER else copt = CELES
endelse

; Determine what format the velocity is in, as defined by MYFLOWMODEL
velopt = keyword_set(cmb)

; Parse the direction input
if (keyword_set(radians)) then begin
	co1d = co1 / radperdeg
	co2d = co2 / radperdeg
	co1r = co1
	co2r = co2
endif else begin
	co1d = co1
	co2d = co2

	if ((size(co1))[1] eq 7) then begin ; In string format
		co1d = getdec(co1)
		co2d = getdec(co2)
	endif

	if (copt eq CELES) then co1d = co1d * 15 ; Convert from RA hours to RA degrees

	co1r = co1d * radperdeg ; Convert degrees to radians
	co2r = co2d * radperdeg
endelse

; find CMB velocity
if (keyword_set(cmb)) then begin
	vel_cmb = vel
endif else begin
	; Get galactic coordinates
	case copt of
		CELES:	glactc,co1d,co2d,2000,l,b,1, /DEGREE
		GALAC:  begin
			; Already got them
			l = co1d
			b = co2d
			end
		SUPER:	begin
			; This will take two conversions, first supergalactic -> celestial
			glactc,ra,dec,2000,co1d,co2d,2, /DEGREE, /SUPERGALACTIC		
			; Then celestial -> supergalactic
			glactc,ra,dec,2000,l,b,1, /DEGREE
			end
	endcase
	
	vel_cmb = vhel_to_cmb(l,b) + vel
endelse

; Now, calculate distance
if (vel_cmb ge 6000.0) then begin	; Use pure Hubble flow
	distance = vel_cmb/H_0
	distancekms = vel_cmb
	flag = 99
endif else begin
	myflowmodelcall,co1r,co2r,copt,vel_cmb,1,distancekms,edistkms,flag
	distance = distancekms/H_0
endelse

case flag of
	 0   : info = 'Flow model: No distance found. usually close to D=0Mpc'
	 1   : info = 'Distance estimated using the flow model'
	 2   : info = 'Flow model: Double valued distance'
	 3   : info = 'Flow model: Triple valued distance'
	10   : info = 'Flow model: Assigned to Virgo Core'
	11   : info = 'Flow model: Near Virgo (model uncertain)'
	12   : info = 'Flow model: Near Virgo (model uncertain), double valued distance'
	13   : info = 'Flow model: Near Virgo (model uncertain), triple valued distance'
	20   : info = 'Flow model: Assigned to GA Core'
	21   : info = 'Flow model: Near GA (model uncertain)'
	22   : info = 'Flow model: Near GA (model uncertain), double valued distance'
	23   : info = 'Flow model: Near GA (model uncertain), triple valued distance'
	30   : info = 'Flow model: Assigned to Core of Fornax cluster'
	-1   : info = 'No distance (High Velocity Cloud)'
	99   : info = 'Distance estimated using pure Hubble flow, using objects CMB rest frame velocity'
	98   : info = 'Distance is from a primary distance measurement
	97   : info = 'Object belongs to high CMB velocity group, using groups CMB velocity and Hubble flow'
	96   : info = 'Object belongs to low CMB velocity group, using groups CMB velocity and flow model'
	95   : info = 'Object belongs to a group, and one member has a primary distance, so using that'
	94   : info = 'Distance estimated using the flow model'
	else : info = string(flag) + ' is not a valid flag number.'
endcase

print, 'Galaxy distance guesstimate:'+ string(distance, format='(F6.2)')+ ' Mpc'
print, 'Adjusted velocity of galaxy in CMB frame:'+ string(distancekms, format='(I6)') +' km/s'
print, info
if ((flag lt 95) and (flag ne -1)) then $
	print, 'Values returned from the flow model can be very inaccurate'
if (flag eq 99) then $
	print, 'Uncertainties on pure Hubble flow unknown'

END
