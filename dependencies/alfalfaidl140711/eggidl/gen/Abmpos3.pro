
pro Abmpos3,az,za,jd,rahr,decdeg,azoff,zaoff,azl,zal,dr,dd,rotangl=rotangl
;+
;NAME: 
;	ABMPOS3
;
;PURPOSE:
;	To compute alfa beam positions (ra,dec 2000) from az, za, jd beam 0.
;
;SYNTAX: 
;	ABMPOS3,az,za,jd,rahr,decDeg,azoff,zaoff,azl,zal,dr,dd,rotAngl=rotAngl
;
;INPUTS:
;	az[n] -  float - azimuth of central pixel in degrees
;	za[n] - float - zenith angle of central pixel in degrees
;	jd[n] - double - julian date for each az,za. Should include the fraction
;                  of the day.
;
;KEYWORDS:
;	rotAngl - float - rotation angle (deg)of alfa rotator. default is 0 degrees.
;                   sitting on the rotator floor, positive is clockwise.
;
;OUTPUTS:
;	rahr - output RA in hours
;	decdeg - output Dec in degrees
;
;OUTPUTS:
;	raHrs[7,n] - float - ra(2000) in hours for the 7 beams and the n positions.
;	decDeg[7,n] - float - declination(2000) in degrees for the 7 beams and n positions.
;
;MODIFICATION HISTORY:
;	Documentation up-to-date as of July 2006.
;-


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

    for i=0,6 do begin
        zal[i,*]=za[*] - zaOff[i]
        azl[i,*]=az[*] - azOff[i]/sin(zal[i,*]*!dtor)
;       print,i,azoff[i],zaoff[i],azl,zal
        ao_azzatoradec_j,rcv,reform(azl[i,*]),reform(zal[i,*]),jd,raL,decL
        raHr[i,*]  =raL
        decDeg[i,*]=decL
        dr[i,*]=3600*(raHr[i,*]-raHr[0,*])
        dd[i,*]=(decdeg[i,*]-decdeg[0,*])*60. 
        print,i,azoFF[i]*3600.,zaoff[i]*3600.,azl[i,*],zal[i,*],raHr[i,*],$
               decDeg[i,*],dr[i,*],dd[i,*],$
               format='(i2,2f8.1,2f10.3,2f9.4,2f7.2)'
    endfor
    return
end
