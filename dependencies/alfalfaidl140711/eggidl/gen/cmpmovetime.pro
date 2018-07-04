pro cmpmovetime,jd1,jd2,raH,decD,move,move_jd
;+
;NAME:
;	CMPMOVETIME
;PURPOSE:
;	Calculate the time it will take to move from az1, za1
;	to az2, za2.
;	This calculation leaves out the pointing model.
;
;SYNTAX:
;	CMPMOVETIME,jd1,jd2,raH,decD,move,move_jd
;
;INPUTS:
;	jd1 - JD at the start of the preceding drift; the telescope
;		will be there before the move.
;	jd2 - planned start of the following drift.
;	raH,decD - coordinates of the source.
;
;OUTPUTS:
;	move, move_jd - output of move time in two formats, seconds and JD.
;
;NOTES:
;	Called by lsttoazRT.pro; looking there might give you a better idea
;	of how cmpmovetime works and is useful.
;
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-

;  Calculate the time it will take to move from
;     az1,za1 to az2,za2
;  In this calculation, leave out the pointing model
;
;  Here jd1 should be the JD at the start of the preceding
;           drift; the telescope will be there before the move.
;       jd2 is the planned start of the following drift.
;
      SOLAR_TO_SIDEREAL=1.00273790935D
      rcv=17
;      ao_radecjtoazza,17,raH,decD,jd1,az1,za1,/nomodel
;      ao_radecjtoazza,17,raH,decD,jd2,az2,za2,/nomodel
      ao_radecjtoazza,17,raH,decD,jd1,az1,za1
      ao_radecjtoazza,17,raH,decD,jd2,az2,za2
;      print,jd1,az1,za1,$
;           format='(f18.8,3x,2f8.4)'
;      print,jd2,az2,za2,$
;           format='(f18.8,3x,2f8.4)'
      delta_az=abs(az2 - az1)
      delta_za=abs(za2 - za1)
;
;  Advertised slew speeds are  0.4  deg/s in Az
;                         and  0.04 deg/s in ZA
;
      move_az=delta_az/0.4D
      move_za=delta_za/0.04D
;       print,az,za,delta_az,delta_za,move_az,move_za,$
;          format='(2f8.3,2f6.3,2f7.1)'
;
;  PP says 4 sec to accelerate, ~10 sec to decelerate
;          3 sec to settle
;     add additional cushion, just to be sure == 20sec
;
      overhead=20.D   
      if(move_az gt move_za) then begin
          move=move_az+overhead
          endif else begin
          move=move_za+overhead
      endelse

      move_jd=(move/3600.D)/24.D/SOLAR_TO_SIDEREAL
;
return
end
