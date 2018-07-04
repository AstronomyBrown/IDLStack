PRO COORDS_DIST,sourcevel,sourcename=sourcename,distance,edist,flag
;+
;NAME:
;	COORDS_DIST
;PURPOSE:
;	To use flowmodels to determine distances to galaxies with coordinates provided by
;	the calling program.
;	
;	This routine calls flowmodel_dist.pro for a set of galaxy input coordinates and outputs
;	three variables, called distance, edist and flag, which give the distance estimate
;	in km/s, the error estimate in km/s, and a flag which indicates potential problems
;	with the output.
;	
;	Coordinates can be entered in the expected GALFLUX format, hhmmss.s+ddmmss. Therefore,
;	for GALFLUX, the sourcename would be the radec_cen variable.
;
;SYNTAX:
;	COORDS_DIST,sourcevel,sourcename=sourcename,distance, edist, flag
;
;INPUTS:
;	sourcename - a string, the source name from GALFLUX in HHMMSS.S+DDMMSS
;	sourcevel - the source velocity in km/s
;
;OUTPUTS:
;	distance - distance, selected by the program, reported for input coordinates, in units of km/s
;	edist - error, estimated by the program, in km/s
;	flag - integer; an output flag to indicate possible problems; see notes.
;	
;REVISION HISTORY:
;       Written  A.Martin   June 2006
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

onedeg=!dpi/180

mycoords=sourcename

sign=''
reads,mycoords,rah,ram,ras,sign,decd,decm,decs,format='(i2,i2,a4,a1,i2,i2,i2)'
ras=float(ras)
;print,ras
rahours=rah + (ram/60.0) + (ras/3600.0)
rad=rahours*15
decd=decd + (decm/60.0) + (decs/3600.0)
if(SIGN eq '-') then decd=(-decd)
rar=rad*onedeg
decr=decd*onedeg
;print,rar,decr
myflowmodelcall,rar,decr,0,sourcevel,0,distance,edist,flag
;print,distance,edist,flag


END
