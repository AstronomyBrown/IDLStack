;+
; NAME:
;      POINTCORRECT
; PURPOSE:
;       Applies pointing correction to ALFALFA sources
;
; EXPLANATION:
;
;      POINTCORRECT looks for ALFALFA sources files in the present
;      working directory.  It applies a correction from a polynomial
;      fit from continuum source positions.
;
; CALLING SEQUENCE:
;       pointcorrect
;
; INPUTS:
;       none - reads source files from directory automatically
;
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;    
;          
;
; OUTPUTS:
;       none
;
;
; RESTRICTIONS:
;
;       Only works with ALFALFA format source files on UNIX/ MacOS X
;
; EXAMPLE:
;
;      IDL>  pointcorrect
;
; PROCEDURES USED:
;        
;         
;
;
;
; MODIFICATION HISTORY:
;
;          Written, B. Kent, Cornell University  February 2007
;
;                  updated July 2008
;
;
;
;----------------------------------------------------------

pro pointcorrect

spawn, 'ls HI*.src', files


for i=0, n_elements(files)-1 do begin

restore, files[i]


coefra=[0.0D,0.0D,0.0D,0.0D]
coefdec=coefra


;Current as of July 25, 2008

coords=src.srcname

ra_hms=strmid(coords, 0,8)
dec_dms=strmid(coords, 8)

rahr=hms1_hr(ra_hms)
decdeg=dms1_deg(dec_dms)

;UNITS in seconds of arc
;Correction coefficients for 3rd order poly for +4 to +16 declination range
    if (decdeg gt 3.5 AND decdeg lt 16.5 AND $
        rahr le 17.0 AND rahr ge 5.5) then begin

        coefra=[11.071615D,      -2.0179680D,      0.12670865D,   -0.0052052522D]
        coefdec=[-9.3129978D,       6.0345242D,     -0.69725590D,     0.026112862D]
      
endif

;Correction coefficients for 3rd order poly for +27 declination
;range of Spring Sky
if (decdeg gt 25.3 AND decdeg lt 28.6 AND $
    rahr le 17.0 AND rahr ge 5.5) then begin

        coefra=[ 4698.7972D,   -601.16113D,   25.063258D,     -0.34318503D]
        coefdec=[ 66725.520D,  -7463.3766D,  278.11589D,      -3.4530198D]

endif

;Correction coefficients for 3rd order poly for +24 to +28 declination
;range of Fall Sky
if (decdeg gt 23.5 AND decdeg lt 32.5 AND $
    (rahr lt 5.0 OR rahr ge 20.0)) then begin

        coefra=[-5437.0693D,       583.40057D,      -20.849189D,      0.24723620]
        coefdec=[  948.77285D,      -107.93506D,       4.0712927D,    -0.050868007D]

endif

;Correction coefficients for 3rd order poly for +24 to +28 declination
;range of Southern Fall Sky
if (decdeg gt 13.5 AND decdeg lt 16.5 AND $
    (rahr lt 5.0 OR rahr ge 20.0)) then begin

      coefra=[-80813.586D,       15982.569D,      -1052.3137D,       23.064585D]
     coefdec=[ 55192.920D,      -10897.419D,       716.33148D,      -15.672597D]

endif


print, files[i]

    for j=0,n_elements(src.spectra)-1 do begin
          correction_ra_arcsec=coefra[0]+coefra[1]*src.spectra[j].dec_ell+coefra[2]*src.spectra[j].dec_ell^2+coefra[3]*src.spectra[j].dec_ell^3
          correction_dec_arcsec=coefdec[0]+coefdec[1]*src.spectra[j].dec_ell+coefdec[2]*src.spectra[j].dec_ell^2+coefdec[3]*src.spectra[j].dec_ell^3  

          cosdec=cos(src.spectra[j].dec_ell*!dpi/180.0)
          correction_dec_deg=correction_dec_arcsec/3600.0
          correction_ra_hr=(correction_ra_arcsec/3600.0/15.0)/cosdec

          src.spectra[j].ra_ell = src.spectra[j].ra_ell -correction_ra_hr
          src.spectra[j].dec_ell= src.spectra[j].dec_ell-correction_dec_deg

          if (src.spectra[j].ra_ell gt 24.0) then src.spectra[j].ra_ell=src.spectra[j].ra_ell-24.0
          if (src.spectra[j].ra_ell lt 0.0) then src.spectra[j].ra_ell=src.spectra[j].ra_ell+24.0

      print, '   spectra '+strcompress(j, /remove_all)+'  corrected to '+radec_to_name(src.spectra[j].ra_ell, src.spectra[j].dec_ell)

    endfor        

       

          ;Save new file with new name
          save, src, filename=files[i]
          print, '          File saved as '+files[i]
          print, ' '

endfor

print, 'All file name, src.srcnames, and src.spectra ellipse values corrected'


end
