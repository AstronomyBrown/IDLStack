;+
;NAME:
;	OPTANGTAB
;
;PURPOSE:
;	Finds optimal rotation angle, for equally spaced beams,
;	as given source tracks across the sky on given date.
;	Output table with parameters for diurnal track.
;	Assumes ALFALFA beam configuration layout. See:
;	http://www.astro.cornell.edu/~galaxy/docs/figbeams.pdf
;
;	Given an input date and position on the sky (J2000),
;	OPTANG tracks the source across the sky and calculates
;	the rotation angle which optimizes the equal spacing of
;	ALFA beam tracks for drift modes.
;
;SYNTAX:   
;	OPTANGTAB,yymmdd,raHHMMSS,decDDMMSS
;
;INPUTS:
;	yymmdd:     long    desired date for calculation, in yymmdd format
;	raHHMMSS:   long    source RA in J2000, in hhmmss format
;	decDDMMSS:  long    source Dec in J2000, in ddmmss format
;
;OUTPUTS:
;	nothing; output printed to screen
;
;EXAMPLE:
;	optangtab,041128L,093210L,212003L
;
;MODIFICATION HISTORY:
;
;05Nov04  Originally written by the Cornell EGGfolks
;12Nov04  Added documentation  (mph)
;13Nov04  Added call to guess_rotang (mph)
;11Dec04  Added return of paraang from guess_rotang
;
;PROCEDURES USED:
;	Phil's aoidl routines       aoidl
;       idlastro routines           
;       avebmoff.pro                eggidl/gen
;       guess_rotang.pro            eggidl/gen
;  
;-
pro optangtab,yymmdd,raHHMMSS,decDDMMSS
;

  rcv=17                    ; This only applied to ALFA of course

  raH=hms1_rad(raHHMMSS)*!radeg/360.D*24D
  decD=dms1_rad(decDDMMSS)*!radeg

  if(decD gt 17 and decD lt 19.5D) then begin
     print,' Warning:  too close to zenith to track'
     return
  endif

  julday=yymmddtojulday(yymmdd) + 4./24.D
  y1=fix(yymmdd/10000L)
  year=y1+2000.D
  m1=yymmdd-y1*10000L
  month=fix(m1/100L)
  day=m1-month*100L
  iyear=fix(year)

  print,'Beginning iteration... (the first loop is a full one)'
  print,iyear,month,day,julday,$
    format='("almanac for day ",i4,1x,i2.2,1x,i2.2,"   JD(AST=0): ",f12.2)'
   print,'Source  ra,dec:  ',raHHMMSS,decDDMMSS
;   print,'                 ',raH,decD 

  ao_radecJtoazza,rcv,raH,decD,julday,az,za
  print,'         jd        AST      LMST    HA        az      za   <dDec> OptAng'
  jd=julday
  repeat begin
     jd=jd + 0.005D
     if (za gt 20.5D) then begin
     ao_radecJtoazza,rcv,raH,decD,jd,az,za
     endif
  endrep until (za lt 20.5D)

; let's set the time to a nicer number, at earlier 10sec in AST
;
  jhours=(jd-julday)*24.0D
  jhoursfix=fix(jhours)
  jmins=(jhours-float(jhoursfix))*60.D
  jminutes=fix(jmins)
  jmin10=10L*fix(float(jminutes)/10.D)
  jhm=jhoursfix+float(jmin10)/60.D
  jd=jhm/24.0D + julday
;
;  calculate every 10 min in AST, except near transit
;  so decide by hour angle
;
  deltat=(10.D/60.D)/24.D
;
;  how to iterate in rotang depends on decl
;  may have to change if abs(rotang) cannot be more than 90deg
;
  ao_radecJtoazza,rcv,raH,decD,jd,az,za

  repeat begin
     jd=jd + deltat
     ao_radecJtoazza,rcv,raH,decD,jd,az,za
     if (za lt 20D) then begin
       lmstrad=juldaytolmst(jd,obspos=obspos)
       lmst=lmstrad*!radeg/15.D
       ha=lmst-raH
       LSThours=fix(lmst)
       lmin1=(lmst-LSThours)*60.D
       LSTminutes=fix(lmin1)
       dayfract=jd-julday
       AST=dayfract*24.0D
       ASThours=fix(AST)
       amin1=(AST-ASThours)*60.D
       ASTminutes=round(amin1)

       if(abs(ha) lt 0.15D) then begin
         deltat=0.1*(10.D/60.D)/24.D
         endif else begin
         deltat=(10.D/60.D)/24.
         endelse

       minoff=10.D
       bestaveoff=10.D
       offsetang=19.
       guess_rotang,ha,decD,offsetang,paraangl,rotguess
 
       for i = 1L, 20L, 1L do begin
         rotangl=rotguess - 11. + float(i)
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
        print,jd,ASThours,ASTminutes,LSThours,$
             LSTminutes,ha,az,za,bestaveoff,optrotang, $
     format='(f15.3,2(3x,i2.2,"h",i2.2,"m"),2x,f5.2,3x,f7.2,f7.2,2x,f5.2,2x,f5.0)'
     endif  
  endrep until (za gt 21D)
  return
end
