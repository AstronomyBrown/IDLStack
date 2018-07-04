;+
; NAME:
;      POINTCORRECTCR1
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
;	12Feb07/RG modified to correct HI pos in CR1 as in ALFALFA3
;
;
;
;----------------------------------------------------------

pro pointcorrectCR1

xdec=[11.5,12.5,13.5,14.5,15.5,16.5]
ydra=[-4.5,-4.5,-4.5,-4.8,-7.8,-10.]
yddec=[10.,9.5,6.8,7.5,12.1,15.]
xdec=rebin(xdec,60)
ydra=rebin(ydra,60)
yddec=rebin(yddec,60)

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

ndbin=round((decdeg-11.5)*10.)
dracorr=ydra[ndbin]
ddeccorr=yddec[ndbin]


print, files[i]

    for j=0,n_elements(src.spectra)-1 do begin
          correction_ra_arcsec=dracorr
          correction_dec_arcsec=ddeccorr  

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
