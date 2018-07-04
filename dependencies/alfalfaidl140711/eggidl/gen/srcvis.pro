pro srcvis,yymmdd,rcv,raHHMMSS,decDDMMSS,az,za
;+
;NAME:
;	SRCVIS
;
;PURPOSE:
;	Determines whether a source is visible in the Arecibo sky
;	on a given data, and returns the az, za of the source.
;
;SYNTAX:
;	SRCVIS,yymmdd,rcv,raHHMMSS,decDDMMSS,az,za
;
;INPUTS:
;	yymmdd - date
;	rcv - 17 for ALFA!
;	raHHMMSS - RA of source in HHMMSS format
;	decDDMMSS - Dec of source in DDMMSS format
;
;OUTPUTS:
;	az, za - coordinates for AO.
;
;MODIFICATION HISTORY:
;       Cornell EGGfolks 31Oct04
;-


;
;  example  
;  yymmdd=041128L
;  rcv=17                   ; this is ALFA
;  raHHMMSS=093210L
;  decDDMMSS=212003L
;
;  Cornell EGGfolks 31Oct04
;  
;
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
   print,'Source  ra,dec:  ',raHHMMSS,decDDMMSS
   print,'                 ',raH,decD 

  ao_radecJtoazza,rcv,raH,decD,julday,az,za
  print,'         jd        AST      LMST       az      za'
  jd=julday
  repeat begin
     jd=jd + 0.005D

     if (za gt 30D) then begin
     ao_radecJtoazza,rcv,raH,decD,jd,az,za
     endif
  endrep until (za lt 30D)

  repeat begin
     jd=jd + 0.005D
     ao_radecJtoazza,rcv,raH,decD,jd,az,za
     if (za lt 20D) then begin
     lmstrad=juldaytolmst(jd,obspos=obspos)
     lmst=lmstrad*!radeg/15.D
     LSThours=fix(lmst)
     lmin1=(lmst-LSThours)*60.D
     LSTminutes=fix(lmin1)
     dayfract=jd-julday
     AST=dayfract*24.0D
     ASThours=fix(AST)
     amin1=(AST-ASThours)*60.D
     ASTminutes=fix(amin1)

     print,jd,ASThours,ASTminutes,LSThours,LSTminutes,az,za, $
     format='(f15.3,2(3x,i2.2,"h",i2.2,"m"),3x,f7.2,f7.2)'
    endif  
  endrep until (za gt 30D)
  return
end
