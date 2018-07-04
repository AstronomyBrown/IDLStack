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
;
;
;----------------------------------------------------------

pro pointcorrect

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
;if (decdeg gt 7.8 AND decdeg lt 16.5) then begin
;coefra=[56.608498D,      -15.295846D,       1.3616687D,    -0.042068705D]
;coefdec=[ -53.364512D,       16.971647D,      -1.5659715D,     0.048449057D]
if (decdeg gt 3.5 AND decdeg lt 16.5) then begin

coefra=[11.905457D,      -2.3707421D,      0.17682714D,   -0.0072884795D]
coefdec=[-3.3846874D,       3.8501986D,     -0.45065837D,     0.017657008D]


;coefra=[41.923654D,      -11.418516D,       1.0330777D,    -0.033012818D]
;coefdec=[2.2932564D,       2.1329762D,     -0.28803773D,     0.012773822D]
endif


;Correction coefficients for 3rd order poly for +24 to +28 declination range
if (decdeg gt 23.5 AND decdeg lt 32.5) then begin
;coefra=[  -33386.257D,       3837.6595D,      -146.93808D,       1.8728661D]
;coefdec=[   23056.414D,      -2666.3824D,       102.67591D,      -1.3165387D]

coefra=[-4529.7364D,       484.60883D,      -17.272189D,      0.20418388D]
coefdec=[ 893.88543D,      -102.73514D,       3.9175649D,    -0.049511474D]

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
