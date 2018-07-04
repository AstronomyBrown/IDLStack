FUNCTION MAG_VAGC, INDEX_VAGC, INDEX_ALFALFA, NOKCOR=NOKCOR, NOINTCOR=NOINTCOR, NOGALCOR=NOGALCOR

;+
;NAME:
;       MAG_VAGC
;PURPOSE:
;       If an ALFALFA detection has a counterpart in the VAGC, find
;       the corrected apparent magnitude in the Johnson B band.
;       The corrections include internal extinction, galactic
;       extinction and a k-correction.
;       A filter transform is applied to go from the Sloan ugriz to
;       Johnson B band.
;
;SYNTAX:
;       MAG_VAGC, k, j
;
;INPUTS:
;       index_vagc - the index locating the entry of the vagc_alfalfa that
;              corresponds to the detection.
;       index_alfalfa - the index locating the entry of the detection
;                       in the alfalfa catalog.
;
;OUTPUTS:
;       none
;
;KEYWORDS:
;       nokcor - set this flag to skip the k correction at this level
;       nointcor - set this flag to skip the correction for internal
;                  extinction at this level
;       nogalcor - set this flag to skip the correction for Galactic
;                  extinction at this level
;
;NOTES:
;       The corrected magnitude will somehow be returned to a higher
;       level procedure where the catalog is sorted, matched and
;       luminosity information is collected.          
;
;REVISION HISTORY:
;       Written B. Adams   July 2007
;
;-   

;First find the g and r magnitudes from the VAGC.
;Find the Petrosian fluxes
;sdss_alfalfa should already be loaded in order to make a match to the VAGC.

vagc_g = sdss_alfalfa[index_vagc].petroflux[1]
vagc_r = sdss_alfalfa[index_vagc].petroflux[2]

;Fluxes are in 'nanomaggies' - convert to mags

mag_g = 22.5 - alog10(vagc_g)
mag_r = 22.5 - alog10(vagc_r)

;Apply the k-corrections given in the VAGC while still in the Sloan
;filter set.  These corrections come from the kcorrect procedure
;available through the SDSS collaboration.  E.g. Blanton & Roweiss
;2007.

;Check to see if the galaxy has a spectra and redshift
;If it does, use the regular k corrections, otherwise use the
;kcorrection assuming the redshift matches the nearest object if
;photoz's agree within 0.05

restore,'/home/humacao/humacao1/betsey/vagc/sdss_spectra_alfalfa.dat'
restore,'/home/humacao/humacao1/betsey/vagc/kcorrect_none_alfalfa.dat'
restore,'/home/humacao/humacao1/betsey/vagc/kcorrect_photoz_alfalfa.dat'


;K correction values will default to zero if no correction is to be
;applied or if there is no redshift information.

k_g = 0
k_r = 0

if keyword_set(nokcor) then begin
   print, 'K correction will not be applied at this time.'
endif else begin
  if (sdss_spectra_alfalfa[index_vagc].sdss_spectro_tag_primary ne -1) $
  then begin
    k_g = kcorrect_none_alfalfa[index_vagc].kcorrect[1]
    k_r = kcorrect_none_alfalfa[index_vagc].kcorrect[2]
  endif else begin
        if (kcorrect_photoz_alfalfa[incex_vagc] eq -1) then $
         print, 'No redshift information. K correction will not be applied.'
        k_g = kcorrect_photoz_alfalfa[index_vagc].kcorrect[1]
        k_r = kcorrect_photoz_alfalfa[index_vagc].kcorrect[2]
    endelse
endelse


;Compute internal extinction correction factor.
;If computation is not desired, a default value of 0 is returned.

;Use axial ratios from 2mass.  They are readily available in VAGC and
;will be more consistent with ALFALFA detections not in Sloan fields.

;The computation of gamma_b comes from Tully et al, 1998.
;The inclination corrected velocity width will somehow be passed down
;from the higher level procedure which calls this one.

gamma_b = 0

if keyword_set(nointcor) then begin
  print, 'Internal extinction correction will not be applied.'
endif else begin
  if (twomass_alfalfa[index_vagc].j_ba eq 0) then begin
   print, 'No axial ratio information; internal extinction will not be computed.'
  endif else begin
    gamma_b = 1.57 + 2.75* ( alog10(W_inc) - 2.5 )
  endelse
endelse

   

;Compute the Galactic extinction correction.
;These values come from the Schlegel et al. dust maps and can be found
;in the AGC.
;E(B-V) values get handed down from the AGC entry

a_b = 0

if keyword_set(nogalcor) then begin
  print, 'Galactic extinction correction will not be applied.'
endif else begin
  a_b = 4.315 * ebv
endelse


;Convert from Sloan filters to Johnson B band
;Conversions are from Blanton & Roweiss 2007 and are for AB magnitudes
;Sloan g,r,i are essentially AB (slight offset, not available?)
;Need to apply K-corrections to Sloan mags

magb_ab = mag_g + 0.2354 + 0.3915 * ( (mag_g - k_g) - (mag_r - k_r) - 0.6102 )

;Will want to convert from AB magnitude in B to return to the Johnson
;B broadband system.  This will allow consistency with RC3, for
;example.
;The AB offsets come from Frei & Gunn 1994
;Note this conversion allows the Blanton transforms to agree with
;Jester et al. 2005 to within 0.05 mags
;In the Johnson system, Vega has V = 0.03 and all colors equal to zero
;For the AB system, monochromatic flux has magnitude
;m(ab) = -2.5*log(f) - 48.6
;m(ab) = V for a flat spectrum source
;See Oke & Gunn 1983

magb = magb_ab + 0.163

;Apply the extinction corrections.
;They should be set to zero if they are not to be applied.
;Note will need to run another check on axial ratio so that we dont'
;take the log of zero

if (twomass_alfalfa[index_vagc].j_ba eq 0) then begin
  mag_b_cor = magb - a_b 
endif else begin
  mag_b_cor = magb - a_b - gamma_b * alog10(twomass_alfalfa[index_vagc].j_ba)
endelse

return,mag_b_cor

END
