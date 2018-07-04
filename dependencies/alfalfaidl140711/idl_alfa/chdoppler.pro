function chdoppler, ra, dec, julday, $
	path=path, light=light

;+
; NAME: chdoppler
;       
; PURPOSE: 
;       computes the projected velocity of the telescope wrt 
;       four coordinate systems: geo, helio, bary, lsr.
;	negative velocities mean approach
;
;       the standard LSR is defined as follows: the sun moves at 20.0 km/s
;       toward ra=18.0h, dec=30.0 deg in 1900 epoch coords
;
; CALLING SEQUENCE:
;        result = chdoppler( ra, dec, julday, path=path, light=light)
;
; INPUTS: ---------> CHDOPPLER IS NOT VECTORIZED; ONLY SINGLE NUMBERS INPUT   
;       ra - the source ra in decimal hours, equinox 2000
;       dec - the source dec in decimal hours, equinox 2000
;	julday - the julian day
;
; KEYWORDS:
;	/path - path for the station file.
;       /light - returns the velocity as a fraction of c
;
; NOTE:
;	if path is not specified, default long, lat are arecibo. if
;path is specified, it reads long, lat from the file
;		path + .station
;
; OUTPUTS: 
;       program returns the velocity in km/s, or as a faction of c if
;       the keyword /light is specified. the result is a 4-element
;	vector whose elements are [geo, helio, bary, lsr]. quick
;	comparison with phil's C doppler routines gives agreement to 
;	better than 100 m/s one arbitrary case.
;
; REVISION HISTORY: carlh 29oct04. 
;	from idoppler_ch; changed calculation epoch to 2000
;-

;------------------ORBITAL SECTION-------------------------
;GET THE COMPONENTS OF RA AND DEC, 2000u EPOCH
rasource=ra*15.*!dtor
decsource=dec*!dtor
xxsource = fltarr(3)
xxsource[0] = cos(decsource) * cos(rasource)
xxsource[1] = cos(decsource) * sin(rasource)
xxsource[2] = sin(decsource)

;GET THE EARTH VELOCITY WRT THE SUN CENTER
baryvel, julday, 2000.,vvorbit,velb

;PROJECTED VELOCITY OF EARTH CENTER WRT SUN TO THE SOURCE
pvorbit_helio = total(vvorbit* xxsource)
pvorbit_bary = total(velb* xxsource)


;-----------------------LSR SECTION-------------------------
;THE STANDARD LSR IS DEFINED AS FOLLOWS: THE SUN MOVES AT 20.0 KM/S
;TOWARD RA=18.0H, DEC=30.0 DEG IN 1900 EPOCH COORDS
;using PRECESS, this works out to ra=18.063955 dec=30.004661 in 2000 coords.
ralsr_rad= 2.*!pi*18./24.
declsr_rad= !dtor*30.
precess, ralsr_rad, declsr_rad, 1900., 2000.,/radian

;FIND THE COMPONENTS OF THE VELOCITY OF THE SUN WRT THE LSR FRAME 
xxlsr = fltarr(3)
xxlsr[0] = cos(declsr_rad) * cos(ralsr_rad)
xxlsr[1] = cos(declsr_rad) * sin(ralsr_rad)
xxlsr[2] = sin(declsr_rad)
vvlsr = 20.*xxlsr

;PROJECTED VELOCITY OF THE SUN WRT LSR TO THE SOURCE
pvlsr=total(vvlsr*xxsource)


;---------------------EARTH SPIN SECTION------------------------
lst_mean= 24./(2.*!pi)*juldaytolmst( julday)
raspin=(lst_mean- ra- 6.)* 15.* !dtor
decspin=0.0*!dtor

;PROJECTED DISTANCE FROM CENTER OF EARTH
IF KEYWORD_SET( PATH) THEN BEGIN
	station,lat,long, path=path
ENDIF ELSE lat= 18.3539444444

gclat = lat - 0.1924 * sin(2*lat*!dtor) ; true angle lat
rearth =( 0.99883 + 0.00167 * cos(2*lat*!dtor))* 6378.1 ;dist from center, km
rho=rearth*cos(gclat*!dtor)

;SPIN VELOCITY, KM/S
vspin=2*!pi*rho/86164.090

xxspin = fltarr(3)
xxspin[0] = cos(decspin) * cos(raspin)
xxspin[1] = cos(decspin) * sin(raspin)
xxspin[2] = sin(decspin)
vvspin = vspin*xxspin

;PROJECTED VELOCITY OF STATION WRT EARTH CENTER TO SOURCE
pvspin=total(vvspin*xxsource)

;---------------------NOW PUT IT ALL TOGETHER------------------

vtotal= fltarr( 4)
vtotal[0]= -pvspin
vtotal[1]= -pvspin- pvorbit_helio
vtotal[2]= -pvspin- pvorbit_bary
vtotal[3]= -pvspin- pvorbit_bary- pvlsr

if keyword_set(light) then vtotal=vtotal/(2.99792458e5)

;print, pvorbit, pvspin, vtotal, keyword_set( geo), keyword_set( helio)

return,vtotal
end






