pro blocksched,yymmdd,ast1HHMM,ast2HHMM
;+
;NAME:
;	BLOCKSCHED
;
;PURPOSE:
;	Calculates LSF start/stop times for AST time block
;	on a given day. Redundant calculation allows for tidiness.
;
;SYNTAX:
;	blocksched, yymmdd,ast1HHMM,ast2HHMM
;
;EXAMPLE:
;	blocksched,050124L,0200L,0615L
;
;MODIFICATION HISTORY:
;	Cornell EGG IDL routine
;	04Dec12   --- mph
;
;-
  SOLAR_TO_SIDEREAL=1.00273790935D
  rcv=17
  julday=yymmddtojulday(yymmdd) + 4./24.D
  y1=fix(yymmdd/10000L)
  year=y1+2000.D
  m1=yymmdd-y1*10000L
  month=fix(m1/100L)
  day=m1-month*100L
  iyear=fix(year)
  print,iyear,month,day,julday,$
    format='("almanac for day ",i4,1x,i2.2,1x,i2.2,"   JD(AST=0): ",f12.2)'
  print,'Computation via blocksched (eggidl:mph) at: ',systime()


  lmst0hrad=juldaytolmst(julday,obspos=obspos)
  lmst0h=lmst0hrad*!radeg/15.0D
  print,' JD at 0h',julday,'  LMST at 0h: ',fisecmidhms3(lmst0h*3600D)
  lmst0HH=fix(lmst0h)
  lmstmin0=(lmst0h-float(lmst0HH))*60.
  lmst0MM=round(lmstmin0)

  ast1HH=fix(ast1HHMM/100)
  ast1MM=fix(ast1HHMM - float(ast1HH*100.))
  ast1H=float(ast1HH) + float(ast1MM)/60.
  
  ast2HH=fix(ast2HHMM/100)
  ast2MM=fix(ast2HHMM - float(ast2HH*100.))
  ast2H=float(ast2HH) + float(ast2MM)/60.

  dayfract1=ast1H/24.0D
  dayfract2=ast2H/24.0D
  lmst1H=lmst0h+dayfract1*24.0*SOLAR_TO_SIDEREAL
  lmst2H=lmst0h+dayfract2*24.0*SOLAR_TO_SIDEREAL
 
  jd1=julday+dayfract1
  jd2=julday+dayfract2
  lmst1rad=juldaytolmst(jd1,obspos=obspos)
  lmst1=lmst1rad*!radeg/15.0D
  lmst2rad=juldaytolmst(jd2,obspos=obspos)
  lmst2=lmst2rad*!radeg/15.0D

  LSThours1=fix(lmst1)
  lmin1=(lmst1-LSThours1)*60.D
  LSTminutes1=fix(lmin1)
  lmin2=(lmin1-LSTminutes1)*60.D
  LSTseconds1=round(lmin2)
  if(LSTseconds1 ge 60) then begin
        LSTminutes1 = LSTminutes1+1
        LSTseconds1 = LSTseconds1-60
    endif
  LSThours2=fix(lmst2)
  lmin1=(lmst2-LSThours2)*60.D
  LSTminutes2=fix(lmin1)
  lmin2=(lmin1-LSTminutes2)*60.D
  LSTseconds2=round(lmin2)
  if(LSTseconds2 ge 60) then begin
        LSTminutes2 = LSTminutes2+1
        LSTseconds2 = LSTseconds2-60
  endif

  print,fisecmidhms3(ast1H*3600D),'  ',fisecmidhms3(ast2H*3600D),$
    '   ',fisecmidhms3(lmst1H*3600D),'  ',fisecmidhms3(lmst2H*3600D)

  print,lmst0HH,lmst0MM,ast1HH,ast1MM,ast2HH,ast2MM,$
        LSThours1,LSTminutes1, LSThours2,LSTminutes2,$
        format='(2x,i2.2,"h",i2.2,2(3x,i2.2,"h",i2.2,"-",i2.2,"h",i2.2))'
end
