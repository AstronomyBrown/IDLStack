;+
;NAME:
;radec_to_name
;SYNTAX: name=radec_to_name(ra,dec)
;INPUT:
;  - ra, dec  in hh.hhhhhh and dd.ddddd
;OUTPUT:
;  - name [a string of the form hhmmss.s+ddmmss]
;
; RG 31dec05

function radec_to_name,ra,dec

   rh=floor(ra)
   rmm=(ra-rh)*60.
   rm=floor(rmm)
   rs=(rmm-rm)*60.
   rrrr=rh*10000.+rm*100.+rs

   ddd=dec
   sign='+'
   if (ddd lt 0) then begin
     sign='-'
     ddd=-ddd
   endif
   dd=floor(ddd)
   dmm=(ddd-dd)*60.
   dm=floor(dmm)
   ds=round((dmm-dm)*60.)
   dddd=dd*10000.+dm*100.+ds

   return,string(rrrr,sign,dddd,format='(f8.1,a1,i6.6)')

end
