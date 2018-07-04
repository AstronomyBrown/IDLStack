function vhel_to_cmb,glongr, glatr
;+
; NAME:  
;       VHEL_TO_CMB
;
; PURPOSE:
;        Calculate the projection along the LOS velocity wrt to the CMB velocity
;
; EXPLANATION:
;       Function takes lb coordinates to compute the projection along 
;       the LOS velocity wrt to the CMB velocity.  Quite simple.
;
; SYNTAX: 
;       result=VHEL_TO_CMB(l,b)
;
; INPUT PARAMETERS: 
;       l:  galactic longitude in degrees
;       b:  galactic latitude in degrees
;
; OUTPUT PARAMETERS: ;
;      result - CMB velocity projected along the line of sight.
;              
; EXAMPLES:
;
;      IDL> print,  35344+vhel_to_cmb(112.62994,-25.039215)
;            You should get:  35031.226
;
;	Comments from original FORTRAN program:
;
;	"Computes the component, in the direction of
;	a given galaxy, of the motion of the Sun with
;	respect to the Local Universe. Source for velocities
;	and directions : Kogut et al. 1993 (ApJ 419,1)
;       Also added the Lineweaver 1996 paper.
;
;	Assumes you have already converted RA,Dec to l,b IN DEGREES!
;	Be sure to put a declaration statement like
;	REAL Vhel_to_CMB(GLONGR,GLATR)
;	in your main program. and then something like:
;	vcmb = vhelio + VHEL_to_CMB(glr,gbr)."
;
;
; MODIFICATION HISTORY: 
;       FORTRAN subroutine by R. Giovanelli, M.P. Haynes
;       Conversion to IDL, B. Kent, Cornell University, 2006
;-
      
      ONEDEG=!dpi/180.
      ;REAL GLATR, GLONGR, APEX(3), V_APEX, B_APEX, L_APEX, COS_ANG
     
      ;APEX=[369.5,264.4,48.4]    ;Kogut et al. 1993 (ApJ 419,1); uncomment if you want to use.
      ;APEX=[368.7,263.85,48.25]  ;Bennett et al. 2003 (ApJ 148, 1) ;uncomment if you want to use, but they're consistent within the errors
      APEX=[368.7,264.31,48.05]  ;Lineweaver et al. 1996 (ApJ 470, 38)
     
;     where Apex(0) is velocity of the Sun to the CMBin km/s,
;           Apex(1,2) are galactic longitude and latitude of Apex.
     
     
      V_APEX = APEX[0]
      L_APEX = APEX[1]*ONEDEG
      B_APEX = APEX[2]*ONEDEG
      COS_ANG = double(SIN(B_APEX)*SIN(GLATR*ONEDEG) + $
                COS(B_APEX)*COS(GLATR*ONEDEG)*COS(L_APEX - GLONGR*ONEDEG))
      Vhel_CMB = double(V_APEX*COS_ANG)
     
      return, Vhel_CMB 
      

end
