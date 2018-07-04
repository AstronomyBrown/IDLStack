pro avebmoff,az,za,jd,maxoff,aveoff,rotAngl=rotAngl
;+
;NAME: 
;	AVEBMOFF
;
;PURPOSE:
;	To compute alfa beam positions (ra,dec 2000) from az, za, jd.
;	Computes avg. sep. between adjacent beams.
;	http://www.astro.cornell.edu/~galaxy/docs/figbeams.pdf
;	based on Phil's alfabeampos.pro
;
;SYNTAX:
;	avebmoff,az,za,jd,maxoff,aveoff,rotAngl=rotAngle
;	
;INPUTS:
;	az[n] - float - azimuth of central pixel in degrees
;	za[n] - float - zenith angle of central pixel in degrees
;	jd[n] - double - julian date for each az,za. Should include the fraction
;                  of the day.
;
;OUTPUTS:
;	maxoff - double - maximum separation in declination of specific
;                adjacent beams (ALFALFA drift configuration)
;	aveoff - double - average separation in declination of specific
;                adjacent beams (ALFALFA drift configuration)
;   
;KEYWORDS:
;	rotAngl - float - rotation angle (deg)of alfa rotator. default is 0 degrees.
;                   sitting on the rotator floor, positive is clockwise.
;
;NOTES:
;	This routine is normally called by OPTANG and OPTANGTAB
;	It calculates the average declination spacing of adjacent beams
;	for the "standard" E-ALFA drift configuration
;
;MODIFICATION HISTORY:
;	05Nov04  Originally written by the Cornell EGGfolks
;	12Nov04  Added documentation  (mph)
;
;-

;
; great circle offsets for the 7 beams in arc seconds. 
;
    azLen0=329.06               ; center to az edge of ellipse
    zaLen0=384.005              ; center to za edge of ellipse
    azAlfaOff=[0.000D  ,-164.530,-329.060,-164.530, 164.530,329.060,164.530]
    zaAlfaOff=[0.000D  , 332.558,  -4.703,-332.558,-332.558,  0.000,332.558]

    n=n_elements(az)
    if n_elements(rotAngl) eq 0 then rotAngl=0.
;
;   compute the az,za offsets
;
    azOff=fltarr(7)
    zaOff=fltarr(7)
    for i=1,6 do begin &$
        th= ((i-5.)*60 - rotAngl)*!dtor
        azOff[i]=azLen0*cos(th)/3600D
        zaOff[i]=zaLen0*sin(th)/3600D
    endfor
;
;   This is the amount to move the az,za so that the
;   the beam in on the optic axis. The positions of the sky of the
;   beams without the motion is opposite this value (since there are
;   an odd number of mirrors).
;   this is great circle so divide by sine of za.
;   
    rcv=17
    rahr=dblarr(7,n)
    decdeg=dblarr(7,n)
    dr=dblarr(7,n)
    dd=dblarr(7,n)
    azl=dblarr(7,n)
    zal=dblarr(7,n)
    aveoff=0.D
    deld16=0.D
    deld62=0.D
    deld20=0.D
    deld05=0.D
    deld53=0.D
    deld34=0.D

    for i=0,6 do begin
        zal[i,*]=za[*] - zaOff[i]
        azl[i,*]=az[*] - azOff[i]/sin(zal[i,*]*!dtor)
        ao_azzatoradec_j,rcv,reform(azl[i,*]),reform(zal[i,*]),jd,raL,decL
        raHr[i,*]  =raL 
        decDeg[i,*]=decL
        dr[i,*]=3600*(raHr[i,*]-raHr[0,*])
        dd[i,*]=(decdeg[i,*]-decdeg[0,*])*60. 
        
;        print,i,azoFF[i]*3600.,zaoff[i]*3600.,azl[i,*],zal[i,*],raHr[i,*],$
;               decDeg[i,*],dr[i,*],dd[i,*],$
;               format='(i2,2f8.1,2f10.3,2f9.4,2f7.2)'
    endfor
    
;
;   Checks the average separation of adjacent beams
;   See   http://www.astro.cornell.edu/~galaxy/docs/figbeams.pdf
;  
    maxoff=0.0D
    aveoff=0.0D

    deld16=abs(abs(dd[1,*])-abs(dd[6,*]))
    deld62=abs(abs(dd[6,*])-abs(dd[2,*]))
    deld20=abs(abs(dd[2,*])-abs(dd[0,*]))
    deld05=abs(abs(dd[0,*])-abs(dd[5,*]))
    deld53=abs(abs(dd[5,*])-abs(dd[3,*]))
    deld34=abs(abs(dd[3,*])-abs(dd[4,*]))

    maxoff=deld62
    if(deld16 gt maxoff) then maxoff=deld16    
    if(deld20 gt maxoff) then maxoff=deld20
    if(deld05 gt maxoff) then maxoff=deld05
    if(deld53 gt maxoff) then maxoff=deld53
    if(deld34 gt maxoff) then maxoff=deld34

    aveoff=(deld16+deld62+deld20+deld05+deld53+deld34)/6.0D
    
;    print,maxoff,aveoff,rotAngl
    return
end
