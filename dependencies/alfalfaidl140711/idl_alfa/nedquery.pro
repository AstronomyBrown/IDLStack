;+
; NAME: 
;   NEDQUERY
;
; PURPOSE: 
;   Query the NED database given a RA (decimal degrees), DEC (decimal
;   degrees), and radius (arcminutes)
;
; EXPLANATION: 

;
; CALLING SEQUENCE: 
;    nedquery, ra,dec, radius, numberinfo, string_array
;
; INPUTS: 
;    ra - right ascension in decimal degrees
;    dec - declination in decimal degrees
;    radius - search radius in arcminutes
;
; OUTPUTS: 
;    numberinfo - string details how many results were returned (null
;                 if zero)
;    string_array - string array of objects found
;
; OPTIONAL INPUT KEYWORD:
;
;     Screen - print output to screen on terminal
;
; OPTIONAL OUTPUT: 
;
;
; OPTIONAL KEYWORD OUTPUT:
;
;            
; EXAMPLES:
;
;    nedquery, 180.0, 15.0, 10.0,  numberinfo, string_array
;
; PROCEDURES USED:
;       WEBGET()
;
; NOTES:
;
; MODIFICATION HISTORY: 
;     Written December 2, 2005
;     December 4, 2005 BK - added distance from search point
;
;      January 18, 2006 - BK - added terminal screen printing for
;                         standalone use
;
;         Aug  19, 2007 - Index mod for results
;
;-


pro nedquery, ra,dec, radius, numberinfo=numberinfo, string_array=string_array, screen=screen


  if N_params() LT 3 then begin
       print,'SYNTAX - nedquery, ra,dec, radius, numberinfo, string_array'
       print,'   Input - ra, dec, radius, numberinfo=numberinfo, string_array=string_array, screen=screen'
       print,'   Output -  numberinfo, string_array'
       return
  endif

radec,ra,dec,ihr,imin,xsec,ideg,imn,xsc
rastring=strcompress(ihr, /remove_all)+'+'+ $
         strcompress(imin, /remove_all)+'+'+ $
         strcompress(xsec, /remove_all)

decstring=strcompress(ideg, /remove_all)+'+'+ $
          strcompress(imn, /remove_all)+'+'+ $
          strcompress(xsc, /remove_all)

QueryURL = 'http://nedwww.ipac.caltech.edu/cgi-bin/nph-objsearch?in_csys=Equatorial&in_equinox=J2000.0&lon='+ $
            rastring+'&lat='+decstring+'&radius='+strcompress(radius, /remove_all)+'&search_type=Near+Position+Search&out_csys=Equatorial&out_equinox=J2000.0&obj_sort=Distance+to+search+center&of=pre_text&zv_breaker=30000.0&list_limit=5&img_stamp=YES&z_constraint=Unconstrained&z_value1=&z_value2=&z_unit=z&ot_include=ANY&nmp_op=ANY'

  Result = webget(QueryURL)
  found = 0

;Determine result - modified Aug 2007
index=where(result.text eq ' No object found.<br>')
;print, 'Index', index
   
if (index[0] eq -1) then begin
 
startindex=where(result.text eq '<A NAME="objlist">')
;print, 'Start index', startindex


t=result.text[startindex[0]+1]

headpos = strpos(t,'<h3>')
endpos=strpos(t,'NED.')
numberinfo = strmid(t,headpos+4,endpos-headpos)+' (within '+strcompress(radius, /remove_all)+' arcminutes)'

foundpos=strpos(numberinfo, 'objects')
numberstring=strmid(numberinfo,0,foundpos-1)
number=long(numberstring)

endif else begin
    number=0

endelse


if (number ne 0) AND $
   (N_Elements(result.text) GE 16) THEN BEGIN

      string_array=strarr(number)

      for i=startindex[0]+5, startindex[0]+5+number-1 do begin
            found = 1
             t = result.text[i]
            headpos = strpos(t,'A>')
            ihr=strmid(t,headpos+35,2)
            imin=strmid(t,headpos+38,2)
            xsec=strmid(t,headpos+41,4)
            ideg=strmid(t,headpos+47,3)
            imn=strmid(t,headpos+51,2)
            xsc=strmid(t,headpos+54,2)
            
            ;print, ihr+imin+xsec
            ra1=double(ihr+imin+xsec)
            dec1=double(ideg+imn+xsc)
            
            rahr=hms1_hr(ra1)
            decdeg=dms1_deg(dec1)
            
            GCIRC, 1, ra/15.0,dec,rahr, decdeg, DIS
	   
            dis=round(dis/60.0*100)/100.0
	    disstring=strcompress(dis, /remove_all)

            string_array[i-(startindex[0]+5)]= strmid(t,headpos+2,80)+'   '+strmid(disstring,0,strpos(disstring,'.')+3) 
      endfor

endif else begin
      numberinfo=''
      string_array= 'No objects returned by NED server'
endelse


if (keyword_set(screen)) then begin


print, ''
print, 'Results from NED at RA= '+strcompress(ra, /remove_all)+'     Dec= '+strcompress(dec, /remove_all)
print, numberinfo
print, '  Name 			         RA(J2000)   DEC(J2000)	TYPE      VEL    Z	   SKY DIST(arcmin)'
print, '  -------------------------------------------------------------------------------------------------'
print, string_array
print, ''

endif

END 
 
