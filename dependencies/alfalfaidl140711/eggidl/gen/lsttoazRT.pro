pro lsttoazRT,yymmdd,lmstHHMMSS,raHHMMSS,decDDMMSS,driftTime
;+
;
;****DISCLAIMER: THIS ROUTINE IS NOT GUARANTEED TO WORK FOR YOU!
;                IT IS NOT DESIGNED TO APPLY IN ALL CASES!
;                IT IS YOUR RESPONSIBILITY TO CHECK IT!
;                Otherwise, you should **not** use it.
;
;NAME:
;	LSTTOAZRT
;
;PURPOSE:
;	For a given source of RA,Dec (J2000), compute the az, za and optimal
;	rotation angles for a succession of drifts of length DRIFTTIME, starting
;	on a given day yymmdd at a given LST and assuming the ALFALFA beam
;	configuration. Performs simple error check on slew times between drifts,
;	ALFA rotation limits, and optimization algorithm iteration boundaries.
;
;SYNTAX:
;	LSTTOAZRT, yymmdd,lmstHHMMSS,raHHMMSS,decDDMMSS,driftTime
;
;INPUTS:
;	yymmdd - long - desired date for calculation, in yymmdd format.
;	lmstHHMMSS - long - local mean sidereal time, in hhmmss format.
;	raHHMMSS - long - source RA in J2000, in hhmmss format.
;	decDDMMSS - long - source Dec in J2000, in ddmmss format.
;	driftTime - float - length of drift, sans cal, in seconds. For a1963
;			spectral line, this will be 480 seconds.
;
;OUTPUTS:
;	NONE YET!
;	azDrift[n]: double  azimuth of source, in degrees
;	zaDrift[n]: double  azimuth of source, in degrees
;	lstDrift[n] double  lst start of each drift
;	anglDrift[n]: float  optimal rotation angle of drift, in degrees
;         
;EXAMPLE:  
;	lsttoazRT,041202L,083200L,092810L,211326L,480.
;	lsttoazRT,041202L,074000L,085248L,200631L,240.
;	lsttoazRT,041202L,091000L,101955L,215931L,240.
;
;NOTES:
;	Note that you need to run this over +/- 1.2 HA, starting at ZA~18
;       This routine has NOT been tested on sources other than 
;       N2903 and two calibrators at +20 and +21 deg.
;
;	ASSUMES the array specified below
;	tstep:      float   time step between calculations, in seconds
;	caltime:    float   time overhead for cal firing
;
;	 You need to set the time between scans (tstep) according
;	 to the range of HA covered. This is optimized for NGC2903 (+21d).
;	 Sources at other declinations will require different tstep[i].
;	 Someday we might automate this, but not now.
;
;MODIFICATION HISTORY:
;	Written, MPH with apologies to RG and PP
;	30Nov04  eggidl initialization (by mph)
;       30Nov04  added check for slew time (mph)
;       01Dec04  added overheads; check for iteration boundaries (mph)
;       02Dec04  added ALFA rotation angle limits
;                modified meaning of DRIFTTIME
;                allow drifts of 240 sec and 480 sec (mph)
;                added call to separate cmpmovetime.pro (mph)
;       04Dec04  added check of time to rotate array (mph)
;       11Dec04  guess_rotang has been modified to include
;                ellipticity correction, and to return paraangl
;                for more general use
;                new guess_angle allows for smaller loop
;-  
;
  if(drifttime eq 480.) then begin
     numtracks=12
     tstep=dblarr(numtracks)
     tstep = [150.D, 130.D, 120.D, 120.D, 160.D, 200.D,$
              140.D, 120.D, 120.D, 110.D, 110.D, 100.D]
  endif
  if(drifttime eq 240.) then begin
     numtracks=40
     tstep=dblarr(numtracks)
     tstep[*]=90.D 
     tstep[8]=100.D
     tstep[9]=100.D
     tstep[10]=110.D
     tstep[11]=140.D
     tstep[12]=190.D  
     tstep[13]=180.D
     tstep[14]=120.D
  endif
  azDrift=dblarr(numtracks)
  zaDrift=dblarr(numtracks)
  lstDrift=dblarr(numtracks)
  jdDrift=dblarr(numtracks)
  angDrift=dblarr(numtracks)

  caltime=8.
  SOLAR_TO_SIDEREAL=1.00273790935D
  slewrate_az=0.4      ; deg/sec
  slewrate_za=0.04     ; deg/sec
  rcv=17

  raH=hms1_rad(raHHMMSS)*!radeg/360.D*24D
  decD=dms1_rad(decDDMMSS)*!radeg
  
  julday=yymmddtojulday(yymmdd) + 4./24.D
  y1=fix(yymmdd/10000L)
  year=y1+2000.D
  m1=yymmdd-y1*10000L
  month=fix(m1/100L)
  day=m1-month*100L
  iyear=fix(year)
  print,iyear,month,day,julday,$
    format='("almanac for day ",i4,1x,i2.2,1x,i2.2,"   JD(AST=0): ",f12.2)'
   print,'Computation via lsttoazRT (eggidl:mph) at: ',systime()
   print,'Source  ra,dec:  ',raHHMMSS,decDDMMSS
   print,'                 ',raH,decD

  lmst0hrad=juldaytolmst(julday,obspos=obspos)
  lmst0h=lmst0hrad*!radeg/15.0D
;  print,' JD at midnite ',julday,lmst0h
  lmststart=hms1_rad(lmstHHMMSS)*!radeg/360.D*24.D
  dayfract=(lmststart-lmst0h)/24.0D
  addtime=dayfract/SOLAR_TO_SIDEREAL
  AST=addtime*24.0D
  jd=julday+AST/24.0D

  ao_radecJtoazza,rcv,raH,decD,jd,az,za
  if(za gt 20) then begin 
    print,' Source not in AO range at this time. Try again.'
    return
    endif
  if(za lt 2) then begin
    print,' Source too close to zenith at this time. Check more carefully.'
    return
  endif
  print,'     Julian Date       AST       LMST       az        za  ',$
        ' RotAng  Sep    Slew  Rotate  dT'

  azDrift[0]=az
  zaDrift[0]=za
  jdDrift[0]=jd
  lstDrift[0]=lmststart
; 
; Real times need to include various overheads
;
  driftpluscal=drifttime+caltime
  driftpluspad=drifttime+tstep[0]
  deltat=(driftpluspad/3600.D)/24.D/SOLAR_TO_SIDEREAL
  driftjd=(driftpluscal/3600.D)/24.D/SOLAR_TO_SIDEREAL

  jd=jd-deltat
  ntrack=0
  move=0.0D
  rotatetime=0.0D
  time2next=0.D
  time2nextsec=0.D  
  
  repeat begin
     jd=jd + deltat
     ntrack=ntrack+1
     ao_radecJtoazza,rcv,raH,decD,jd,az,za 
     
    if(za gt 20) then begin
       print,' At this point, the source sets'
       return
    endif
    if(za lt 2) then begin
       ao_radecJtoazza,rcv,raH,decD,jd,az,za,/nomodel
       print,' Source crosses too close to zenith'
       print,za[0],'  ZA no model'
       return
    endif

;
;  check that slew time is adequate
;  
     if (ntrack gt 1) then begin
       jd_enddrift=jdDrift[ntrack-2] + driftjd
       jd2=jd
       jd1=jdDrift[ntrack-2]
       cmpmovetime,jd1,jd2,raH,decD,move,move_jd
       jd_begindrift=jd_enddrift + move_jd
       if(jd_begindrift gt jd) then begin
         print,'Move time = ',move,' secs; not enough time'
         return
         endif      
     endif

; 
; Now pretty up the times
;
     lmstrad=juldaytolmst(jd,obspos=obspos)
     lmst=lmstrad*!radeg/15.D
     LSThours=fix(lmst)
     lmin1=(lmst-LSThours)*60.D
     LSTminutes=fix(lmin1)
     lmin2=(lmin1-LSTminutes)*60.D
     LSTseconds=round(lmin2)
     if(LSTseconds ge 60) then begin
        LSTminutes = LSTminutes+1
        LSTseconds = LSTseconds-60
     endif
;
     dayfract=jd-julday
     AST=dayfract*24.0D
     if(AST lt 0) then begin
       AST=AST+24
     endif
     ASThours=fix(AST)
     amin1=(AST-ASThours)*60.D
     ASTminutes=fix(amin1)
     amin2=(amin1-ASTminutes)*60.D
     ASTseconds=round(amin2)
     if(ASTseconds ge 60) then begin
        ASTminutes = ASTminutes+1
        ASTseconds = ASTseconds-60
     endif


     tstepnext=0.
     driftpluspad=drifttime+tstep[ntrack-1]
     deltat=(driftpluspad/3600.D)/24.D/SOLAR_TO_SIDEREAL
     if(ntrack ne 1) then tstepnext=tstep[ntrack-2]
;
;  now let's go find the optimum rotation angle
;
     ha=lmst-raH
     minoff=10.D
     bestaveoff=10.D
     offset=19.
     guess_rotang,ha,decD,offset,paraangl,rotguess
     firstrot=rotguess - 1.5 + 0.1
     for i = 1L, 31L, 1L do begin
         rotangl=rotguess - 1.5 + 0.1*float(i)
         lastrot=rotangl
         avebmoff,az,za,jd,maxoff,aveoff,rotAngl=rotangl
;
; minimizing the maximum offset will give the best angle
;      
         if(maxoff lt minoff) then begin
            optrotang=rotangl
            minoff=maxoff
            bestaveoff=aveoff
         endif
     endfor
;     print,rotguess,optrotang
;
;  watchout
;
     if(optrotang gt 100.) then begin
             print,' OPTANG beyond ALFA limit; consider alternatives'
             return
         endif
     if(optrotang lt -99.) then begin
             print,' OPTANG beyond ALFA limit; consider alternatives'
             return
     endif
     del1=abs(firstrot-optrotang)
     del2=abs(lastrot-optrotang)
     azDrift[ntrack-1]=az
     zaDrift[ntrack-1]=za
     jdDrift[ntrack-1]=jd
     lstDrift[ntrack-1]=lmst
     angDrift[ntrack-1]=optrotang
; 
;  ALFA cannot walk and chew gum at the same time, so
;  it rotates to position before it starts slewing
;  so now check there really is enough time for that.
;  We are told that 500 rpm = 100 deg in 56 sec.
;  We noticed a move of 42deg took 36 sec.
;  There also appears to be ~10 sec overhead.
;   
     if(ntrack gt 1) then begin
        delta_rotation=abs(optrotang - angDrift[ntrack-2])
        rotatetime=(delta_rotation/1.7D) + 10.0D
        rotate_jd=(rotatetime/3600.D)/24.D/SOLAR_TO_SIDEREAL
        jd_enddrift=jdDrift[ntrack-2] + driftjd
        jd2=jd
        jd1=jdDrift[ntrack-2]
        jd_begindrift=jd_enddrift + move_jd + rotate_jd
        if(jd_begindrift gt jd) then begin
         print,'Rotate time = ',rotatetime,' secs; not enough time'
         print,angDrift[ntrack-2],optrotang
         return
         endif    
     endif
;     print,rotguess,firstrot,lastrot,optrotang,del1,del2
     print,ntrack,jd,ASThours,ASTminutes,ASTseconds,$
             LSThours,LSTminutes,LSTseconds,$
             az,za,optrotang,bestaveoff,move,rotatetime,tstepnext,$
  format='(i2,f16.6,2(2x,i2.2,"h",i2.2,"m",i2.2,"s"),2x,f8.4,f8.3,1x,f6.1,f6.2,3f7.1)'
     if(del1 lt 0.1) then print,$,
        ' Beware: rotang near iteration limit - first',rotguess,firstrot,optrotang,del1
     if(del2 lt 0.1) then print,$
        ' Beware: rotang near iteration limit - last',rotguess,lastrot,optrotang,del2
;
; set deltat for next az
;
     driftpluspad=drifttime+tstep[ntrack-1]
     deltat=(driftpluspad/3600.D)/24.D/SOLAR_TO_SIDEREAL
  endrep until (ntrack eq numtracks)
  return
end
