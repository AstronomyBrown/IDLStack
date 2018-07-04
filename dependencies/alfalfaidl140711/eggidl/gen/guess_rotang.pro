;+
;NAME:
;	GUESS_ROTANG
;PURPOSE:
;	Finds approximate value of the ALFA rotation angle by calculating the
;	parallactic angle. The ALFA rotang should be close to the negative
;	para_ang plus some offset to achieve desired beam configuration on the
;	sky. For ALFALFA, offset=+19 for equally spaced beams.
;
;	For the geometry, see Frank Ghigo's GBT memo.
; 
; SYNTAX:   
;	GUESS_ROTANG,haH,decD,offsetang,paraangl,rotguess
;
;
;INPUTS:
;	ha          float   hour angle, in degrees
;	decD        float   Declination, in degrees
;	offsetang   float   The offset between the Para_ang and rot_ang
;
;OUTPUTS:
;	paraangl    float   parallactic angle of source
;	rotguess    float   Approximate ROTANG = rotD + OFFSETANG
;                       where rotD is computed from Para_ang.
;
;EXAMPLE:  
;	guess_rotang,-1.003,21.53417,+19.,paraangl,rotguess
;
;MODIFICATION HISTORY:
;	Updated for eggidl by mph 04Dec11
;
;NOTES:
;	-- code contains some extraneous calculations for diagnostic
;         purposes
;	-- in other words, this isn't intended to be foolproof
;        CAVEAT EMPTOR!
;
;    
;-
pro guess_rotang,ha,decD,offsetang,paraangl,rotguess
;
;
    latao=18.35381
    lataorad=latao/!radeg
    harad=ha/(!radeg/15.0D)
    decDrad=decD/!radeg
    sinha=sin(harad)
    cosha=cos(harad)
    cosdec=cos(decDrad)
    sindec=sin(decDrad)
    tanlat=tan(lataorad)
    tanp=sinha/(cosdec*tanlat - sindec*cosha)
    paraanglrad=atan(tanp)
    paraangl=paraanglrad*!radeg
    rotguess1=-paraangl+offsetang
;
; Now apply correction for ellipticity
;
    amin=329.D
    amaj=384.D
    yell=amin*sin(paraanglrad)
    ratell=yell/amin
    ratsq=1-(ratell*ratell)
    if(ratsq > 0) then begin
         xell=amaj*sqrt(ratsq)
         endif else begin
         xell=amaj
      endelse
    rotrad=-1.D*atan(yell/xell)
    rotD=rotrad*!radeg
;    print,xell,yell,rotD

    rotguess=rotD+offsetang
;    print,paraangl,rotguess1,rotguess
    return
end
    
   
