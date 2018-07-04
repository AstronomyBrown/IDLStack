FUNCTION MYDELTAV, distflow, sgl, sgb, vgal

;+
;NAME: 
;	MYDELTAV
;
;PURPOSE:
;	Finds the difference between the observed velocity and that
;	predicted by KLMFLOW at a given distance. This will be minimized
;	by ZBRAKVEL and ZBRENTVEL in FLOWMODEL.
;
;SYNTAX: 
;	result=MYDELTAV(distflow, sgl, sgb, vgal)
;
;INPUTS: 
;	distflow - a given distance
;	sgl, sgb, vgal - from calling routine
;OUTPUTS: 
;	result - difference between observed and predicted velocity.
;
; REVISION HISTORY:
;       Written  KLM January 2003
;       Converted to IDL   A.Martin   June 2006
;
;-	


;Variables used here: distflow, sgx, sgy, sgz, vr, vx, vy, vz, vsig
;and sgl, sgb, vgal used here and in FLOWMODEL


; Calculate supergalactic cartesian co-ords of galaxy at distance=distflow
sgx = distflow*cos(SGL)*cos(SGB)
sgy = distflow*sin(SGL)*cos(SGB)
sgz = distflow*sin(SGB)

; Call model routine 

klmflow,sgx,sgy,sgz,vx,vy,vz,vr,vsig   

mydeltav = vgal - vr

return, mydeltav
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO ZBRAKVEL, x1, x2, n, nb, xb1, xb2, nfound, sgl, sgb, vgal, FUNC_NAME=func_name
;+
; NAME:
;	ZBRAKVEL
;
; PURPOSE:
;	NOTE: This is NOT the original ZBRAK; it has been altered to allow
;	functions which call FOUR arguments (3 in addition to X).
;
;	THIS VERSION OF ZBRAK IS TAILORED TO THE FUNCTION MYDELTAV.
;
;	Bracket a zero that ZBRENT can then identify. Given a function FX
;	defined on the interval from x1 to x2, ZBRAK subdivides the interval
;	into n equally spaced segments and searches for zero-crossings of the
;	function. nb is an input, specifying the number of roots sought, and
;	is reset in the end to the number of bracketing pairs (xb1,xb2) that
;	are found by the function.
;
; EXPLANATION:
;	This routine "looks inward," starting from an initial interval, to
;	identify regions where a function changes sign.
;	Adapted from procedure of the same name in "Numerical Recipes" by
;	Press et al. (1992), Section 9.1
;
; SYNTAX:
;       ZBRAKVEL, x1, x2, n, nb, xb1, xb2, nfound, sgl, sgb, vgal, FUNC_NAME="name" 
;
; INPUTS:
;       x1, x2 - scalars, 2 points which bracket location of function zero,
;                                               that is, F(x1) < 0 < F(x2).
;	n - the number of intervals into which the function will divide the
;						bracketed region.
;	nb - the number of roots sought
;
;	sgl, sgb, vgal - deltav requires these inputs
;	
;
; REQUIRED INPUT KEYWORD:
;       FUNC_NAME = function name (string)
;
; OUTPUTS:
;       xb1, xb2 - arrays specifying the bracketing pairs for ZBRENT.
;	nfound - the number of solutions found.
;
;
; MODIFICATION HISTORY:
;       Converted to IDL from Num. Rec.   A. Martin   June 2006
;	Modified for specific function mydeltav.
;-

x1=float(x1)
x2=float(x2)

xb1=fltarr(nb)
xb2=fltarr(nb)

NBB=NB
NB=0
NFOUND=0
X=X1
DX=(X2-X1)/N                ;Determines the interval size
FP=call_function(func_name,x, sgl, sgb, vgal)

for i=1,N do begin
	X=X+DX
	FC=call_function(func_name,X, sgl, sgb, vgal)
	if((FC*FP) LT 0) then begin
		XB1(nb)=X-DX
		XB2(nb)=X
		NFOUND=NFOUND+1
		NB=NB+1
	endif
	FP=FC
	if(NBB EQ NB) then begin
		return
	endif
endfor

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function ZBRENTVEL, x1, x2, sgl, sgb, vgal, FUNC_NAME=func_name,    $
                         MAX_ITERATIONS=maxit, TOLERANCE=TOL
;+
; NAME:
;	ZBRENTVEL
;
; PURPOSE:
;	NOTE: This is NOT the original ZBRENT; it has been altered to allow
;	functions which FOUR arguments (3 in addition to X)
;
;	THIS VERSION IS TAILORED TO THE FUNCTION MYDELTAV
;
;	Find the zero of a 1-D function up to specified tolerance.
;
; EXPLANATION:
;	This routine assumes that the function is known to have a zero.
;	Adapted from procedure of the same name in "Numerical Recipes" by
;	Press et al. (1992), Section 9.3
;
; SYNTAX:
;	result = ZBRENTVEL( x1, x2, sgl, sgb, vgal, FUNC_NAME="name" )
;
; INPUTS:
;       x1, x2 = scalars, 2 points which bracket location of function zero,
;                                               that is, F(x1) < 0 < F(x2).
;       Note: computations are performed with
;       same precision (single/double) as the inputs and user supplied function.
;
; REQUIRED INPUT KEYWORD:
;       FUNC_NAME = function name (string)
;               Calling mechanism should be:  F = func_name( px, sgl, sgb, vgal )
;
; OPTIONAL INPUT KEYWORD:
;       MAX_ITER = maximum allowed number iterations, default=100.
;       TOLERANCE = desired accuracy of minimum location, default = 1.e-3.
;			NOTE: AM 2006: new version defaults to 1.e-4.
;
; OUTPUTS:
;       Returns the location of zero, with accuracy of specified tolerance.
;
; PROCEDURE:
;       Brent's method to find zero of a function by using bracketing,
;       bisection, and inverse quadratic interpolation.
;
; MODIFICATION HISTORY:
;       Written, Frank Varosi NASA/GSFC 1992.
;       FV.1994, mod to check for single/double prec. and set zeps accordingly.
;       Converted to IDL V5.0   W. Landsman   September 1997
;	Altered by A. Martin	June 2006	to change the default tolerance to 1.e-4
;						Modified for specific function mydeltav
;-
        if N_params() LT 2 then begin
             print,'Syntax - result = ZBRENT( x1, x2, FUNC_NAME = ,
             print,'                  [ MAX_ITER = , TOLERANCE = ])
             return, -1
        endif

        if N_elements( TOL ) NE 1 then TOL = 1.e-4
        if N_elements( maxit ) NE 1 then maxit = 100

        sz1 = size( x1 )
        sz2 = size( x2 )

        if (sz1[sz1[0]+1] EQ 5) OR (sz2[sz2[0]+1] EQ 5) then begin
                xa = double( x1 )
                xb = double( x2 )
                zeps = 1.d-14   ;machine epsilon in double precision.
          endif else begin
                xa = x1
                xb = x2
                zeps = 1.e-7    ;machine epsilon, smallest add, single prec.
           endelse

        fa = call_function( func_name, xa, sgl, sgb, vgal )
        fb = call_function( func_name, xb, sgl, sgb, vgal )
        fc = fb

        if (fb*fa GT 0) then begin
                message,"root must be bracketed by the 2 inputs",/INFO
                return,xa
           endif

        for iter = 1,maxit do begin

                if (fb*fc GT 0) then begin
                        xc = xa
                        fc = fa
                        Din = xb - xa
                        Dold = Din
                   endif

                if (abs( fc ) LT abs( fb )) then begin
                        xa = xb   &   xb = xc   &   xc = xa
                        fa = fb   &   fb = fc   &   fc = fa
                   endif

                TOL1 = 0.5*TOL + 2*abs( xb ) * zeps     ;Convergence check
                xm = (xc - xb)/2.

                if (abs( xm ) LE TOL1) OR (fb EQ 0) then return,xb

                if (abs( Dold ) GE TOL1) AND (abs( fa ) GT abs( fb )) then begin

                        S = fb/fa       ;attempt inverse quadratic interpolation

                        if (xa EQ xc) then begin
                                p = 2 * xm * S
                                q = 1-S
                          endif else begin
                                T = fa/fc
                                R = fb/fc
                                p = S * (2*xm*T*(T-R) - (xb-xa)*(R-1) )
                                q = (T-1)*(R-1)*(S-1)
                           endelse

                        if (p GT 0) then q = -q
                        p = abs( p )
                        test = ( 3*xm*q - abs( q*TOL1 ) ) < abs( Dold*q )

                        if (2*p LT test)  then begin
                                Dold = Din              ;accept interpolation
                                Din = p/q
                          endif else begin
                                Din = xm                ;use bisection instead
                                Dold = xm
                           endelse

                  endif else begin

                        Din = xm    ;Bounds decreasing to slowly, use bisection
                        Dold = xm
                   endelse

                xa = xb
                fa = fb         ;evaluate new trial root.

                if (abs( Din ) GT TOL1) then xb = xb + Din $
                                        else xb = xb + TOL1 * (1-2*(xm LT 0))

                fb = call_function( func_name, xb , sgl, sgb, vgal)
          endfor

        message,"exceeded maximum number of iterations: "+strtrim(iter,2),/INFO

return, xb
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO CARTTOLBR, x, y, z, l, b, r
;+
; NAME:
;	CARTTOLBR
;
; PURPOSE: 
;	Converts Cartesian coordinates to l,b,r in radians.
;
; EXPLANATION:
;	Input is x,y,z, output is r in same units and l and b in radians.
;	SUPERGALACTIC x,y,z, l=SGL, b=SGB. 
;
; SYNTAX:
;       CARTTOLBR, x, y, z, l, b, r 
;
; INPUTS:
;       x, y, z - Cartesian coordinates
;	
;
; OUTPUTS:
;	l, b, r - Galactic coordinates; l,b, in radians, r in units of x,y,z
;
; MODIFICATION HISTORY:
;	Written	KLM	May 2003
;       Converted to IDL   A. Martin   June 2006
;-

x=float(x)
y=float(y)
z=float(z)

onedeg=!dpi/180

; Find r      
r = sqrt(x^2 + y^2 + z^2)

; Find b
if(Z GE 0) then begin
	b=asin(z/r)
endif else if(Z EQ 0) then begin
	b=0
endif else begin
	b=-asin(-z/r)
endelse

; Find l

if((x GT 0) AND (y GE 0)) then begin
	l=atan(y/x)
endif else if((x EQ 0) AND (y GE 0)) then begin
	l = 90.*onedeg
endif else if((x GT 0) AND (y LT 0)) then begin
	l=(360.0*onedeg) - atan(-y/x)
endif else if((x EQ 0) AND (y LT 0)) then begin
	l=270.0*onedeg
endif else if((x LT 0) AND (y GE 0)) then begin
	l=(180.0*onedeg) - atan(-y/x)
endif else begin
	l=(180.0*onedeg) + atan(y/x)
endelse


end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PRO MYFLOWMODEL, CO1,CO2,COOPT,VEL,VELOPT, distflow,VS,NSOLNS,FLAG
;+
;NAME:
;	MYFLOWMODEL
;PURPOSE:
;	KLM flow model, adapted from the non-linear flow model of Tonry et al (2000),
;	which uses Yahil (1985) approximation (good to an overdensity of 30).
; 	
;	Compute distances from galaxy velocities and co-ordinates. This model includes 
;	the spherical infall on the Virgo Attractor and the Great Attractor, as well as 
;	a quadrupole correction which could be due either to non-spherical infall or the 
;	influence of external masses. There is also a velocity dispersion component which 
;	is a combination of thermal velocity dispersion and virial motions in Virgo, the 
;	GA and the Fornax Cluster. The parameters of the model were fit to a sample of about 
;	300 early-type galaxies with SBF distances (see Tonry et al 2000). 
;
;	The output of this routine consists of up to three possible best solutions. Older versions 
;	also output a file from which you can make a plot of the unnormalized 
;	probability given the model that the galaxy is at a given distance (which 
;	allows an estimate of the error in the model on the distance from the 
;	velocity dispersion) and also a file from which you can plot the function
;	mydeltav(dist,sgl,sgb,vgal) for the galaxy (to check the roots found are sensible).
;
;	NOTE: This version provides distances independent of h0 (ie. in units of km/s)
;
;SYNTAX:
;	MYFLOWMODEL, co1, co2, coopt, vel, velopt, dist, vs, nsolns, flag
;
;INPUTS:
;	co1, co2 - the input coordinates. Should be in J2000.
;	coopt - a flag which indicates the system of input coordinates co1 & co2.
;		coopt = 0: input equatorial, co1=RA, co2=DEC in RADIANS
;		coopt = 1: input galactic, co1=l, co2=b in RADIANS
;		coopt = 2: input supergalactic, co1=SGL, co2=SGB in RADIANS
;		For all flags, coordinates will be transformed to supergalactic SGL
;		and SGB in *RADIANS*
;	vel - radial velocity of source (km/s)
;	velopt - integer, indicating type of input velocity:
;		velopt = 0: vcmb will be calculated from vel using Lineweaver conversion.
;		velopt = 1: vcmb=vel, ie, input is already converted to CMB
;
;OUTPUTS:
;	distflow - 3-element array containing distance solutions in km/s
;	nsolns - integer; the number of solutions found.
;	flag - integer; an output flag to indicate possible problems; see notes.
;	
;REVISION HISTORY:
;	Created 24th Jan 2003, Karen L. Masters (KLM)
;	Last update 4th Feb 2003, KLM 
;
;	This version provides distances independent of h0 (ie. in units of km/s).
;	May 16th 2003, KLM.
;	J2000 co-ords, Feb 2005, KLM
;	Uses flow model fit to SFI++. June 2005, KLM
;       Converted to IDL   A.Martin   June 2006
;
;NOTES:
;       FLAG    (INT)   Flag to indicate possible problems
;                       0: No distance found. Usually close to D=0Mpc
;                       1: Everything is fine, single valued distance
;                      2: Double valued distance
;                      3: Triple valued distance
;                      10: Assigned to Virgo Core
;                      11: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued 
;                      12: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued 
;                      13: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued 
;                      20: Assigned to GA Core
;                      21: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued
;                      22: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued
;                      23: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued
;                      30: Assigned to Core of Fornax cluster
;
;	Cosmology:
;       	Ho             Hubble's constant
;       	(wx,wy,wz)     Peculiar velocity of Sun in CMB frame
;       	omega          Mass density parameter
;       	thermal        Thermal velocity dispersion in universe
;       
; 	Quadrupole:
;       	rquad          Cut-off radius
;       	qxx, qxy, qxz, qyz, qzz
;
; 	Attractors:
;       	xa,ya,za       Position in Supergalactic cartesian co-ords relative
;       	               to Local Group
;       	deltaa         Overdensity at position of LG
;       	gammaa         Power law fall off
;       	rcore         Core radius
;       	rcuta          Cut-off radius
;       	siga           Virial velocity dispersion which falls off like a 
;			       Gaussian centred on the attractor with width rcore
;     
;		Note: model also has non-attracting overdensities which are
;		simply described by a position and virial velocity dispersion
;
; 	Input to model
; 
;       	sgx,sgy,sgz     Supergalactic cartesian co-ords of galaxy
;       	r               Trial distance for galaxy      
;
; 	Output from model
;
;       	vx,vy,vz        Velocity in supergalactic cartesian co-ords in 
;                       CMB frame
;       	vr              Radial velocity in CMB frame
;       	vsig            Velocity dispersion at position of galaxy
;
;-

;important parameters: onedeg and NBRACK, which will indicate that ZBRAKVEL should
;attempt to locate NBRACK=3 solutions.

onedeg=!dpi/180.
NBRACK=3

;doubles, just in case
co1=double(co1)
co2=double(co2)
vel=double(vel)


; First step: convert coordinates into equatorial, supergalactic & galactic coordinates

if (COOPT EQ 0) then begin
	ra=co1
	dec=co2
	;convert from RA, DEC in degrees to SGL, SGB, l and b in degrees then convert to rads
	glactc,ra/onedeg,dec/onedeg,2000,sgl,sgb,1,/DEGREE,/SuperGalactic
	sgl=sgl*onedeg
	sgb=sgb*onedeg	
	glactc,ra/onedeg,dec/onedeg,2000,l,b,1,/DEGREE
	l=l*onedeg
	b=b*onedeg	
endif else if (COOPT EQ 1) then begin
	l=co1
	b=co2
	;convert from L,B in degrees to SGL, SGB in radians
	;I use glactc to convert from l,b to RA,DEC
	;and then use the RA & DEC to convert to SGL, SGB in deg then convert to rads
;Convert from L&B to RA,DEC in degrees
	glactc,ra,dec,2000,l/onedeg,b/onedeg,2,/DEGREE
;Convert from RA,DEC in degrees to SGL, SGB in degrees
	glactc,ra,dec,2000,sgl,sgb,1,/DEGREE,/SUPERGALACTIC
;Convert everything back to radians
	ra=ra*onedeg
	dec=dec*onedeg
	sgl=sgl*onedeg
	sgb=sgb*onedeg
endif else if (COOPT EQ 2) then begin
	sgl=co1
	sgb=co2
	;convert supergalactic to RA&DEC in degrees
	glactc,ra,dec,2000,sgl/onedeg,sgb/onedeg,2,/DEGREE,/SUPERGALACTIC
	;then convert from RA&DEC to galactic
	glactc,ra,dec,2000,l,b,1,/DEGREE
	;then convert everything back to radians
	RA=RA*onedeg
	DEC=DEC*onedeg
	l=l*onedeg
	b=b*onedeg
endif else begin
	message,'ERROR: Invalid entry for COOPT.'
endelse

; Convert velocity to CMB frame (using Lineweaver (1996) result of
; V= 369.0 +/- 2.5 km/s in direction of l = 264.31+/-0.19 degrees
; and b = 48.05 +/- 0.1 degrees

if (VELOPT EQ 0) then begin
	vgal= vel + vhel_to_cmb(l/onedeg,b/onedeg)
	vcmb = vgal
endif else if (VELOPT EQ 1) then begin
	vgal = vel
	vcmb = vel 
endif else begin
	message,'ERROR: Invalid entry for VELOPT.'
endelse

; Plausible range of distances. Peculiar velocity in excess of 2000 would be extremely
; unusual. Karen made this large so as to not miss any possible distances, but there 
; is no point in it being the whole universe.

rmin= (vgal - 2000.0) > 0.0
rmax = vgal + 2000.0

;Calculate probability distribution for distances given the velocity and position.
; P = (1.0/sqrt(2*pi)*sigv)*exp(-0.5*((vgal-vmod)/vsig)^2) from Tonry et al. (2000)

; We do this between dist=rmin and rmax Mpc in intervals of 0.5/h Mpc
; Comments from original fortran, in case you want file output:
;c File to write out to
;c      write(*,*) 'Probability distribution in distprob.out'
;c      open(1,file='distprob.out',status='unknown')
;c      write(1,*) 'Prob. of given distance (Mpc) for galaxy at SGL=',SGL,
;c     * ', SGB=',SGB,', Vcmb=',vgal
;c      write(*,*) 'Function to find roots of output to deltav.out'
;c      open(2,file='deltav.out',status='unknown')
;c      write(2,*) 'Observed minus predicted velocity at given distances f
;c     *or galaxy at SGL=',SGL,', SGB=',SGB,', Vcmb=',vgal

; The do loop!

r = rmin
while (R LE RMAX) do begin
	;calculate supergalactic cartesian coords of galaxy, input to the klmflow routine
	sgx = r*cos(SGL)*cos(SGB)
	sgy = r*sin(SGL)*cos(SGB)
	sgz = r*sin(SGB)
	;call klmflow:
	klmflow, sgx, sgy, sgz, vx, vy, vz, vr, vsig
	;calculate probability of distance given observed velocity vgal
	prob = (1000.0/(sqrt(2*!dpi)*vsig))*exp(-0.5*((vgal-vr)/vsig)^2)
	;calculate function DELTAV at the same intervals
	del = mydeltav(r,sgl,sgb,vgal)
	;step size of 0.5 Mpc
	r = r + 50.0
endwhile


; Search for distances at which the model predicts the observed CMB velocities
;
; Call ZBRAKVEL (Numerical Recipes) to look for NBRAK=3 zeroes in the deltav
NSOLNS=NBRACK
;NSOLNS will NOT, in IDL be reset to the actual number of solutions found. 
;An output variable NFOUND will determine how many solns were found. deltav is a function which
;computes the difference between the observed and predicted velocity at a given distance.
;Interval is divided into 50 segments to search for zero crossings. xb1(NSOLNS) and xb2(NSOLNS)
;are output as the NSOLNS bracketing pairs.

zbrakvel,rmin,rmax,50,NSOLNS,xb1,xb2,NFOUND,sgl,sgb,vgal,FUNC_NAME="mydeltav"
NSOLNS=NFOUND
FLAG=NSOLNS

if (NSOLNS eq 0) then return

;Use function ZBRENTVEL (Numerical Recipes) which searches for the root in the intervals
;found by ZBRAKVEL. Root is returned as zbrentvel with accuracy tol=1.E-4	

distflow=fltarr(NSOLNS)
for i=0, (NSOLNS-1) do begin
	rmin=xb1[i]
	rmax=xb2[i]
	distflow[i]=zbrentvel(rmin,rmax,sgl,sgb,vgal,FUNC_NAME="mydeltav")
endfor

;Want velocity dispersion at possible distances to get an estimate of the errors

vs=fltarr(NSOLNS)

for i=0, (NSOLNS-1) do begin
	sgx = distflow[i]*cos(SGL)*cos(SGB)
	sgy = distflow[i]*sin(SGL)*cos(SGB)
	sgz = distflow[i]*sin(SGB)
	klmflow, sgx, sgy, sgz, vx, vy, vz, vr, vout
	vs[i]=vout
endfor

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PRO KLMFLOW, x, y, z, vx, vy, vz, vr, vsig
;+
;NAME:
;	KLMFLOW
;PURPOSE:
; 	Based on a Fortran subroutine written by John Tonry (available on-line).
;	Edited to deal with distances in km/s (independent of Hubble's constant).
;	This version also uses NFW profiles for the attractors, and does not include
;	cutoff radii, except for the quadrupole.
;
;SYNTAX:
;	KLMFLOW, x, y, z, vx, vy, vz, vr, sig
;
;INPUTS:
;	x, y, z - Cartesian SuperGalactic coordinates of the source galaxy
;
;OUTPUTS:
;	vx, vy, vz - velocity in SG cartesian coords in CMB frame
;	vr - radial velocity in CMB frame
;	vsig - velocity dispersion at location of galaxy
;	
;REVISION HISTORY:
;	Created  Karen L. Masters (KLM)
;       Converted to IDL   A.Martin   June 2006
;-

;important parameters

if ((X EQ 0) AND (Y EQ 0) AND (Z EQ 0)) then x=0.001

onedeg=!dpi/180.
h0=70.0
omega=0.3
;concentration parameter
c=5.0
deltac=200.0*c^3/(3.0*(alog(1+c) - c/(1.0+c)))
;Thermal velocity dispersion (KLM)
rcore=2.0*h0
thermal=163.0
;VA parameters
sigv=650
;GA parameters
sigg=500
;Quadrupole parameters
rquad=50*h0

;Varying parameters
;Cosmology parameters
wx=-204
wy=160
wz=-261
;VA parameters
xv = -4.73*h0
yv=15.87*h0
zv=0.32*h0
r200v=1.7*h0
;GA parameters
xg=-30.51*h0
yg=26.18*h0
zg=-30.79*h0
r200g=2.17*h0
;Quadrupole parameters
qxx=8.52
qxy = 0.51
qxz=-2.71
qyz=0.36
qzz=-8.81

;Peculiar velocity
vx=wx
vy=wy
vz=wz

ivrw=round((vx*x + vy*y + vz*z)/ sqrt((x^2) + (y^2) + (z^2)))

;Hubble flow contribution
vx = vx + x
vy = vy + y
vz = vz + z

ivrh=round(sqrt((x^2) + (y^2) + (z^2)))

;Virgo attractor
distv = 0.001 > (sqrt((xv^2) + (yv^2) + (zv^2)))
rcv0 = c* distv/r200v
delta0 = deltac*(1./(1+rcv0) + alog(1+rcv0) - 1) / (omega*rcv0^3)

ratv = 0.001 > (sqrt((x-xv)^2 + (y-yv)^2 + (z-zv)^2))
rcv = c*ratv/r200v
delta=deltac*(1./(1+rcv) + alog(1+rcv) - 1)/(omega*rcv^3)

uinfall = 1./3. * ratv * (omega^0.6) * delta * ((1+delta)^(-0.25))

ux = -uinfall * (x-xv)/ratv
uy = -uinfall * (y-yv)/ratv
uz = -uinfall * (z-zv)/ratv

vx = vx + ux
vy = vy + uy
vz = vz + uz

ivrv = round((ux*x + uy*y + uz*z) / sqrt((x^2)+(y^2)+(z^2)))

;Great Attractor

distg=0.001 > (sqrt((xg^2) + (yg^2) + (zg^2)))
rcg0=c*distg/r200g
delta0 = deltac*(1./(1+rcg0) + alog(1+rcg0) - 1)/(omega*rcg0^3)

ratg = 0.001 > (sqrt((x-xg)^2+(y-yg)^2+(z-zg)^2))
rcg = c*ratg/r200g
delta = deltac*(1./(1+rcg) + alog(1+rcg) - 1)/(omega*rcg^3)

uinfall = 1./3. * ratg * (omega^0.6) * delta * ((1+delta)^(-0.25))
      
ux = -uinfall * (x-xg)/ratg
uy = -uinfall * (y-yg)/ratg
uz = -uinfall * (z-zg)/ratg

vx = vx + ux
vy = vy + uy
vz = vz + uz

ivrg = round((ux*x + uy*y + uz*z) / sqrt((x^2)+(y^2)+(z^2)))

;Quadrupole
; introduce      ezp(x) = exp(amax1(-20.0,x))

ratq = sqrt((x^2)+(y^2)+(z^2))

quadexp = (-20.0) > (-0.5*(ratq^2)/(rquad^2))
cut = exp(quadexp)

qyy = -qxx - qzz
ux = cut*(x*qxx + y*qxy + z*qxz)/h0
uy = cut*(x*qxy + y*qyy + z*qyz)/h0
uz = cut*(x*qxz + y*qyz + z*qzz)/h0

vx = vx + ux
vy = vy + uy
vz = vz + uz

ivrq = round((ux*x + uy*y + uz*z) / sqrt((x^2)+(y^2)+(z^2)))

;Radial component
vr=(vx*x + vy*y + vz*z) / sqrt((x^2)+(y^2)+(z^2))

;Thermal velocity
; again, introduce      ezp(x) = exp(amax1(-20.0,x))
vsig = thermal^2
thermexpv = (-20.0) > (-(ratv^2)/(rcore^2))
vsig = vsig + sigv*sigv*exp(thermexpv)
thermexpg = (-20.0) > (-(ratg^2)/(rcore^2))
vsig = vsig + sigg*sigg*exp(thermexpg)
vsig = sqrt(vsig)

;Details if desired:
;      write(*,*) ivrh, ivrw, ivrv, ivrg, ivrq, nint(vr), nint(vsig)
;	print,ivrh,ivrw,ivrv,ivrg,ivrq,round(vr),round(vsig)

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO MYFLOWMODELCALL, CO1,CO2,COOPT,VEL,VELOPT,DISTANCE, EDIST,FLAG
;+
;NAME:
;	MYFLOWMODELCALL
;PURPOSE:
;	To call flowmodel routine, deal with plausible errors on 
;	distances, and pick out the best distance out of multiple solutions. 
;
;	In this version you can pick your favourite value of H0 at the end as all
;	distances are dealt with in km/s units. Just divide the output distance 
;	(which is in km/s) by desired H0.
;
;SYNTAX:
;	MYFLOWMODELCALL, co1, co2, coopt, vel, velopt, distance, edit, flag
;
;INPUTS:
;	co1, co2 - the input coordinates. Should be in J2000.
;	coopt - a flag which indicates the system of input coordinates co1 & co2.
;		coopt = 0: input equatorial, co1=RA, co2=DEC in RADIANS
;		coopt = 1: input galactic, co1=l, co2=b in RADIANS
;		coopt = 2: input supergalactic, co1=SGL, co2=SGB in RADIANS
;		For all flags, coordinates will be transformed to supergalactic SGL
;		and SGB in *RADIANS*
;	vel - velocity
;	velopt - integer, indicating type of input velocity:
;		velopt = 0: Input velocity is heiocentric; vcmb will be calculated using Lineweaver conversion.
;		velopt = 1: Input is CMB velocity, i.e. CMB velocity has already been calculated
;
;OUTPUTS:
;	distance - distance, selected by the program, reported for input coordinates, in units of km/s
;	edist - error, estimated by the program, in km/s
;	flag - integer; an output flag to indicate possible problems; see notes.
;	
;REVISION HISTORY:
;       Written  KLM
;       Converted to IDL   A.Martin   June 2006
;	Error corrected    A.Martin   June 2008 (erroneous flag of 31 returned; final conditional statement of myflowmodelcall compared thetag to 
;						theta1, but should have been compared to theta2)
;
;NOTES:
;       FLAG    (INT)   Flag to indicate possible problems
;                       0: No distance found. Usually close to D=0Mpc
;                       1: Everything is fine, single valued distance
;                      2: Double valued distance
;                      3: Triple valued distance
;                      10: Assigned to Virgo Core
;                      11: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued 
;                      12: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued 
;                      13: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued 
;                      20: Assigned to GA Core
;                      21: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued
;                      22: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued
;                      23: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued
;                      30: Assigned to Core of Fornax cluster
;
; 
;-

;important parameters: onedeg and NBRACK, which will indicate that ZBRAK should
;attempt to locate NBRACK=3 solutions.

onedeg=!dpi/180.
NBRACK=3

;doubles, just in case
co1=double(co1)
co2=double(co2)
vel=double(vel)

; In order to use the error/indication flags properly, we first want to check
; whether the galaxy is in fact within the Virgo Cluster, the GA or Fornax (as 
; located in the models) before trying to find a distance for them.

; First step: calculate supergalactic coordinates for the galaxy

if (COOPT EQ 0) then begin
	ra=co1
	dec=co2
	;convert from RA, DEC in degrees to SGL, SGB, l and b in degrees then convert to rads
	glactc,ra/onedeg,dec/onedeg,2000,sgl,sgb,1,/DEGREE,/SuperGalactic
	sgl=sgl*onedeg
	sgb=sgb*onedeg	
	glactc,ra/onedeg,dec/onedeg,2000,l,b,1,/DEGREE
	l=l*onedeg
	b=b*onedeg
endif else if (COOPT EQ 1) then begin
	l=co1
	b=co2
	;convert from L,B in degrees to SGL, SGB in radians
	;this is messy, but it works!; I use glactc to convert from l,b to RA,DEC
	;and then use the RA & DEC to convert to SGL, SGB in deg then convert to rads
	glactc,ra,dec,2000,l/onedeg,b/onedeg,2,/DEGREE
	glactc,ra,dec,2000,sgl,sgb,1,/DEGREE,/SUPERGALACTIC
	ra=ra*onedeg
	dec=dec*onedeg
	sgl=sgl*onedeg
	sgb=sgb*onedeg
endif else if (COOPT EQ 2) then begin
	sgl=co1
	sgb=co2
	;convert supergalactic to RA&DEC in degrees
	glactc,ra,dec,2000,sgl/onedeg,sgb/onedeg,2,/DEGREE,/SUPERGALACTIC
	;then convert from RA&DEC to galactic
	glactc,ra,dec,2000,l,b,1,/DEGREE
	;then convert everything back to radians
	RA=RA*onedeg
	DEC=DEC*onedeg
	l=l*onedeg
	b=b*onedeg
endif else begin
	message,'ERROR: Invalid entry for COOPT.'
endelse

; Convert velocity to CMB frame (using Lineweaver (1996) result of
; V= 369.0 +/- 2.5 km/s in direction of l = 264.31+/-0.19 degrees
; and b = 48.05 +/- 0.1 degrees

if (VELOPT EQ 0) then begin
	vcmb= vel + vhel_to_cmb(l/onedeg,b/onedeg)
endif else if (VELOPT EQ 1) then begin
	vcmb = vel
endif else begin
	message,'ERROR: Invalid entry for VELOPT.'
endelse

;print, l, b, sgl, sgb, vcmb

;Search for galaxies within angular core radius and with velocities no more different from
;the cluster velocity than the velocity dispersion.

; Virgo Cluster parameters
h0=70.
xv = -4.7*h0
yv = 15.9*h0
zv = -0.3*h0
carttolbr,xv,yv,zv,sglv,sgbv,dv

;CMB velocity of Virgo, assuming it is at rest wrt the CMB
vv = dv
sigv = 650

;Angular size of 2Mpc core
thetav = 2.0*h0/dv


;If within angular distance of 2Mpc of core and velocity dispersion of cluster velocity
;then set to distance of cluster. Returns control.

theta1 = sqrt((SGL-sglv)^2 + (SGB-sgbv)^2)
veldiff = abs(vv - vcmb)

if ((theta1 LE thetav) AND (veldiff LE sigv)) then begin
	NSOLNS=1
	distance=dv
	EDIST = 2.0*h0
	FLAG=10
	return
endif

; Great Attractor parameters
xg = -30.5*h0
yg = 26.2 *h0
zg = -30.8*h0
sigg = 500
carttolbr,xg,yg,zg,sglg,sgbg,dg

;CMB velocity of GA, assuming it is at rest wrt the CMB
vg = dg

;Angular size of 2Mpc core
thetag = 2.0*h0/dg

;If within angular distance of 2Mpc of core and velocity dispersion
;of cluster velocity then set to distance of cluster. Returns control.

theta2 = sqrt((SGL-sglg)^2 + (SGB-sgbg)^2)
veldiff=abs(vg - vcmb)


if ((theta2 LE thetag) AND (veldiff LE sigg)) then begin
	NSOLNS=1
	distance=dg
	EDIST = 2.0*h0
	FLAG=20
	return
endif

;Now determine the distance using myflowmodel
;myflowmodel will return arrays dist and vs and a number of solutions
;given by NSOLNS; the current routine will then deal with decision-making

myflowmodel,co1,co2,coopt,vel,velopt,distflow,vs,nsolns,flag


;The most likely situations are 1 solution, then 0, then 2, then 3.
if (NSOLNS EQ 1) then begin
	distance = distflow[0]
	edist=vs[0]

;Galaxies with NSOLNS = 0 are usually at d=0 Mpc (or very close by).
;Set error equal to thermal velocity dispersion in km/s

endif else if (NSOLNS eq 0) then begin
	DISTANCE = 0.0
	EDIST = 163.

;Two solutions. Pick dist[0]. Error is max of difference between the two distances
;or error on DIST[0] using above method.

endif else if (NSOLNS eq 2) then begin
	DISTANCE = distflow[0]
	Diffdist = abs(distflow[0] - distflow[1])
	EDIST = VS[0]
	EDIST = EDIST > Diffdist

;Three solutions. Pick DIST[1]. Error is max of difference between the three distances
;or the error on DIST[1] using above method

endif else if (NSOLNS eq 3) then begin
	DISTANCE=distflow[1]
	Diffdist1=abs(distflow[0] - distflow[1])
	Diffdist3=abs(distflow[1] - distflow[2])
	Diffdist=(Diffdist1 + Diffdist3) / 2.0

	EDIST = VS[1]
	EDIST = EDIST > diffdist

;something weird happened
endif else begin
	print,'Nsolns = ',NSOLNS
	message,'Cannot deal with NSOLNS!'
endelse

;Search for galaxies near Virgo or GA
;Need supergalactic x, y, z

r=distance
x = r*cos(SGL)*cos(SGB)
y = r*sin(SGL)*cos(SGB)
z = r*sin(SGB)

ratv=sqrt(((x-xv)^2)+((y-yv)^2)+((z-zv)^2))

if ((ratv LE (6.0*h0)) OR (theta1 LE thetav)) then begin
	FLAG=FLAG+10
endif

;print,ratv

;GA Parameters

ratg=sqrt(((x-xg)^2)+((y-yg)^2)+((z-zg)^2))
if ((ratg LE (10.0*h0)) OR (theta2 LE thetag)) then begin
	FLAG=FLAG+20
endif

;print, ratg

return
END
