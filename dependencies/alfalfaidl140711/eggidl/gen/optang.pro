;+
;NAME:
;	OPTANG
;
;PURPOSE:
;	Find optimal rotation angle, for equally spaced beams,
;	as given source tracks across the sky on given date.
;	Assumes ALFALFA beam configuration layout. See:
;	http://www.astro.cornell.edu/~galaxy/docs/figbeams.pdf
;  
;	Given an input date and position on the sky (J2000),
;	OPTANG tracks the source across the sky and calculates
;	the rotation angle which optimizes the equal spacing of
;	ALFA beam tracks for drift modes.
;
;SYNTAX:   
;	OPTANG,yymmdd,lmstHHMMSS,raHHMMSS,decDDMMS
;
;INPUTS:
;	yymmdd:     long    desired date for calculation, in yymmdd format
;	lmstHHMMSS: long    local mean sidereal time, in hhmmss format
;	raHHMMSS:   long    source RA in J2000, in hhmmss format
;	decDDMMSS:  long    source Dec in J2000, in ddmmss format
;
;OUTPUTS:
;	nothing; prints to screen
;
;EXAMPLE:
;	optang,041128L,081300L,093210L,212003L
;
;MODIFICATION HISTORY:
;	13Nov04  Originally written by the Cornell EGGfolks
;	28Nov04  Updated to include more digits input to LMST
;	         Corrected JD calculation
;	29Nov04  Updated to search ROTANG every 0.5 degree
;	02Dec04  Added check of ROTANG limit (is actually 102 deg)
;	               and iteration boundaries
;	11Dec04  Added return of paraangl to guess_rotang
;
;
;PROCEDURES USED:   
;	Phil's aoidl routines       aoidl
;       avebmoff.pro                eggidl/gen
;       guess_rotang.pro            eggidl/gen
;
;-
pro optang,yymmdd,lmstHHMMSS,raHHMMSS,decDDMMSS
;
;
  rcv=17                    ; This only applied to ALFA of course
  jd=0.D
  rotstart=-90.D
  SOLAR_TO_SIDEREAL=1.00273790935D

  julday=yymmddtojulday(yymmdd) + 4./24.D

  lmst0hrad=juldaytolmst(julday,obspos=obspos)
  lmst0h=lmst0hrad*!radeg/15.0D
;  print,' JD at midnite ',julday,lmst0h

  raH=hms1_rad(raHHMMSS)*!radeg/360.D*24.D
  decD=dms1_rad(decDDMMSS)*!radeg

;  lmstHHMMSS=lmstHHMM*100L
  lmst=hms1_rad(lmstHHMMSS)*!radeg/360.D*24.D
  ha=lmst-raH
  LSThours=fix(lmst)
  lmin1=(lmst-LSThours)*60.D
  LSTminutes=round(lmin1)

  dayfract=(lmst-lmst0h)/24.0D
  addtime=dayfract/SOLAR_TO_SIDEREAL
  AST=addtime*24.0D
;  take into account difference between sidereal and solar day
;  AST=dayfract*24.0D
  ASThours=fix(AST)
  amin1=(AST-ASThours)*60.D
  ASTminutes=round(amin1)
 

  jd=julday+AST/24.0D
;
;  this to check for the moment
;  newlmstrad=juldaytolmst(jd,obspos=obspos)
;  newlmst=newlmstrad*!radeg/15.0D
;  print,lmst,newlmst,ASThours,ASTminutes

  ao_radecJtoazza,rcv,raH,decD,jd,az,za

  if(za gt 20) then begin
    print,' Source not in AO range at this time. Try again.'
    return
    endif
  if(za lt 2) then begin
    print,' Source too close to zenith at this time. Try again.'
    return
endif
;
;  now let's go find the optimum rotation angle
;

  minoff=10.D
  bestaveoff=10.D
  offset=19.
  guess_rotang,ha,decD,offset,paraangl,rotguess
  firstrot=rotguess -11.D + 0.25  
 
  for i = 1L, 40L, 1L do begin
         rotangl=rotguess - 11.D + 0.5*float(i)
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
;
;  watchout
;
     if(abs(optrotang) gt 100) then begin
             print,' OPTANG beyond ALFA limit; consider alternatives'
             return
     endif
     del1=abs(firstrot-optrotang)
     del2=abs(lastrot-optrotang)
 
   print,jd,ASThours,ASTminutes,LSThours,$
          LSTminutes,ha,az,za,bestaveoff,optrotang, $
   format='(f15.3,2(3x,i3.2,"h",i3.2,"m"),2x,f5.2,3x,f6.1,f6.1,2x,f5.2,2x,f6.1)'
     if(del1 lt 1) then print,' Beware rotation angle at iteration limit'
     if(del2 lt 1) then print,' Beware rotation angle at iteration limit'
  return
end
