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
; RG mod 18apr06 to include leading zeros in ra and avoid ds=60 etc.

function radec_to_name,ra,dec

   rh=floor(ra)
   rmm=(ra-rh)*60.
   rm=floor(rmm)
   rs=(rmm-rm)*60.
   if (rs gt 59.95) then begin
    rs = 0.
    rm = rm+1
   endif
   if (rm gt 59) then begin
    rm = rm - 60
    rh = rh + 1
   endif
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
   if (ds eq 60) then begin
     ds = 0
     dm = dm+1
   endif
   if (dm eq 60) then begin
     dm = 0
     dd = dd+1
   endif
   dddd=dd*10000.+dm*100.+ds

   return,string(rrrr,sign,dddd,format='(f08.1,a1,i6.6)')

end
