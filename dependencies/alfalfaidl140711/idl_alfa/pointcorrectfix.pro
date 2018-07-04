;+
; NAME:
;      POINTCORRECTFIX
; PURPOSE:
;       Applies pointing correction to ALFALFA sources and corrects
;       GALFLUX3 syntax errors.
;
; EXPLANATION:
;
;      POINTCORRECT looks for ALFALFA sources files in the present
;      working directory.  It applies a correction from a polynomial
;      fit from continuum source positions.  For use with GALFLUX 3
;      users prior to Feb 6, 2007
;
; CALLING SEQUENCE:
;       pointcorrectfix
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
;      IDL>  pointcorrectfix
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
;
;
;----------------------------------------------------------

pro pointcorrectfix

spawn, 'ls HI*.src', files


for i=0, n_elements(files)-1 do begin

restore, files[i]


coefra=[0.0D,0.0D,0.0D,0.0D]
coefdec=coefra


;Current as of January 6, 2007

coords=src.srcname

ra_hms=strmid(coords, 0,8)
dec_dms=strmid(coords, 8)

rahr=hms1_hr(ra_hms)
decdeg=dms1_deg(dec_dms)

;UNITS in seconds of arc
;Correction coefficients for 3rd order poly for +8 to +16 declination range
if (decdeg gt 7.8 AND decdeg lt 16.5) then begin
coefra=[56.608498D,      -15.295846D,       1.3616687D,    -0.042068705D]
coefdec=[ -53.364512D,       16.971647D,      -1.5659715D,     0.048449057D]
endif


;Correction coefficients for 3rd order poly for +24 to +28 declination range
if (decdeg gt 23.5 AND decdeg lt 28.5) then begin
coefra=[  -33386.257D,       3837.6595D,      -146.93808D,       1.8728661D]
coefdec=[   23056.414D,      -2666.3824D,       102.67591D,      -1.3165387D]
endif

print, files[i]

    for j=0,n_elements(src.spectra)-1 do begin
          correction_ra_arcsec=coefra[0]+coefra[1]*src.spectra[j].dec_ell+coefra[2]*src.spectra[j].dec_ell^2+coefra[3]*src.spectra[j].dec_ell^3
          ;correction_dec_arcsec=coefdec[0]+coefdec[1]*src.spectra[j].dec_ell+coefdec[2]*src.spectra[j].dec_ell^2+coefdec[3]*src.spectra[j].dec_ell^3  

                                ;This line computes the "incorrect"
                                ;correction made in GALFLUX3 until
                                ;February 6, 2007.  Only the ra
                                ;correction needs to be fixed
          rafix_arcsec=coefra[0]+coefra[1]*src.spectra[j].ra_ell+coefra[2]*src.spectra[j].ra_ell^2+coefra[3]*src.spectra[j].ra_ell^3

          cosdec=cos(src.spectra[j].dec_ell*!dpi/180.0)
          ;correction_dec_deg=correction_dec_arcsec/3600.0
          correction_ra_hr=(correction_ra_arcsec/3600.0/15.0)/cosdec
          
          rafix_hr=(rafix_arcsec/3600.0/15.0)/cosdec


          src.spectra[j].ra_ell = src.spectra[j].ra_ell + rafix_hr-correction_ra_hr
           ;DEC correction not required
          ;src.spectra[j].dec_ell= src.spectra[j].dec_ell-correction_dec_deg

          if (src.spectra[j].ra_ell gt 24.0) then src.spectra[j].ra_ell=src.spectra[j].ra_ell-24.0
          if (src.spectra[j].ra_ell lt 0.0) then src.spectra[j].ra_ell=src.spectra[j].ra_ell+24.0

      print, '   spectra '+strcompress(j, /remove_all)+'   REcorrected to '+radec_to_name(src.spectra[j].ra_ell, src.spectra[j].dec_ell)

      

     endfor

     

          ;Save new file with new name
          save, src, filename=files[i]
          print, '          File saved as '+files[i]
          print, ' '

endfor

print, 'All file name, src.srcnames, and src.spectra ellipse values REcorrected from GALflux3'


end
