pro make_specdet,spec1template
 
specdet={spec1template, $
         name: '', $              ; spectrum name, e.g. 002233+271506
         rahr: 0., $              ; R.A. (2000) in hrs
         decd: 0., $              ; Dec  (2000) in deg
         feed: 1,  $              ; front end nr: 0=alfa, 1=lbw
         strip:0L, $              ; strip nr of map/d_file
         nrec: 0L, $              ; rec nr near center of feature (approx)
         npol: 0L, $              ; pol nr: 0, 1 or 3
         d_file: lonarr(3), $     ; identifier for d-structure from which spec extracted
                                  ; d_file[0]=hhmmss, d_file[1]=ddmmss of rec 0, bm 0,
                                  ; d_file[2]=scannr of raw IDL d structure
         nchn:4096,     $         ; number of spectral channels in spectrum
         cen_f:0.,      $         ; center freq in MHz, as observed
         cen_v:0.,      $         ; center velocity in km/s, as observed; if set, then
                                  ; tracking LO used
         restfrq: 1420.4058, $    ; rest freq. of line
         cen_ch: 2048L, $         ; ch nr for center freq
         ch_fwidth: 0.02441406, $ ; channel width in MHz
         heliovelproj: 0.D, $     ; heliovel Doppler shift, projected to l.o.s.
         nchlo: 0L, $             ; lo chnr boundary of feature
         nchhi: 0L, $             ; hi chnr boundary of feature
         vcen: fltarr(8), $       ; central vel of feature (km/s) [8-array]
         vcenerr_stat:fltarr(8), $; statistical error on vcen (km/s) [8-array]
         vcenerr_sys:0.,  $       ; systematic error on vcen, e.g. as caused by choice of signal boundaries
         width: fltarr(8), $      ; width of feature (km/s) [8-array, diff methods]
         width_err: fltarr(8), $  ; width error (km/s) [8-array]
         pks_nch: lonarr(2), $    ; channel nrs of 1st, second peak of spectrum
         pks_flx: fltarr(2), $    ; flux at 1st, second peak of spectrum
         slope_coeff_lo:fltarr(3), $ ; coeffs of fit to feature slope, low  side
         slope_coeff_hi:fltarr(3), $ ; coeffs of fit to feature slope, high side
         msr_modes: strarr(8), $  ; description of measure modes
         mean_int: 0., $          ; mean intensity of feature within [nchlo,nchhi]
         peak_int: 0., $          ; peak intensity of feature within [nchlo,nchhi]
         peak_int_ch: 0L, $       ; channel nr of peak_int
         flux_int: 0., $          ; flux integral within [nchlo,nchhi]
         flux_err_stat:0., $      ; statistical error on flux integral
         flux_err_sys:0., $       ; systematic errors on flux integral
         peak_abs:0., $           ; peak absorption flux
         peak_abs_err:0., $       ; peak absorption flux error
         taudv_int: 0., $         ; integral on tau dv
         taudv_int_err: 0., $     ; integral on tau dv error
         continuum: 0., $         ; continuum flux level at source frq.
         rms: 0., $               ; rms
         ston: fltarr(8),   $     ; signal_to_noise ratio or equivalent indicator
                                  ; mode of S/N computation:
                                  ;    [0]=avg flux over feature*sqrt(width < 100kms)/rms
                                  ;    [1]=avg flux*sqrt(width)/rms
                                  ;    [2]=peak flux/rm
                                  ;    [3-8]=whatever
         smo: 0L,    $            ; spectral smo code: e.g. 1=no smo, 3=han3, 5=han5,
                                  ;                         7=han7
         detcode: intarr(4), $    ; detection code[0]: 1=real,2=good,3=fair,4=marginal,
                                  ;                    5=poor,6=confused or blend,
                                  ;                    7=corrupted (rfi,etc),99=nondet
                                  ;     other 3 slots: up for grabs
         grd_mode: '', $          ; mode of grid, if spectrum extracted from gridded data
         grd_parms:fltarr(4), $   ; params of grid (kerlnel width, kernel truncation,...)
         grd_smo: 0L, $           ; spect smoothing on grid, if spectrum extr. from grd data
         grd_dra: 0., $           ; grid pixel sep in rahr, if spectrum extracted from grid
         grd_ddec: 0., $          ; grid pixel sep in decd, if spectrum extracted from grid
         phot_mode: 0, $          ; descriptor of mode of spatial integration:
                                  ;  1=over a rectangular box of bounds xmin,xmax,ymin,ymax
                                  ;  2=over a circle or radius phot_rad
                                  ;  3=over an ellipse of PA=phot_ell_pa, axes phot_ell_a,b
         phot_npix: 0L, $         ; nr of spatial pix over which spectrum averaged
         phot_box: lonarr(4), $   ; x1,y1,x2,y2: ll, ur pix corners of box for spatial avg
         phot_rad: 0., $          ; photom radius, pix, over which spatial avging done
         phot_ell_a: 0., $        ; major axis of phot ellipse of spatial avging done
         phot_ell_b: 0., $        ; minor axis of phot ellipse of spatial avging
         phot_ell_pa: 0., $       ; PA of major axis of ellipse of spatial avging
         baseline: dblarr(12), $  ; coeffs of poly-base subtracted after spect extraction
                                  ; (this is the *last* baseln event; doesn't carry previous)
         xmin: 0., $              ; min x-value for plot
         xmax: 0., $              ; max x-value for plot
         xunits: 0,$              ; units of x-arr: 0= vel[km/s], 1=ch nr
         ymin: 0., $              ; min y-value for plot
         ymax: 0., $              ; max y-value for plot
         yunits: 0,$              ; yunits of processed spectrum: 0= mJy, 1= Jy, 2= K, 3= instrumental units, 4= units of Tsys
         x_int: lonarr(16), $     ; extra slots, long integer 16-arr; for future use
         x_flt: fltarr(16), $     ; extra slots, float 18-arr
         x_dbl: dblarr(8), $      ; extra slots, double 8-arr
         x_str: strarr(16), $     ; extra slots, character string 16-array
         comments: '', $
         date_of_red: '', $       ; date of reduction
         name_of_red:'RG', $      ; name of reducer
         mjd: 0.D, $              ; modified Julian date of data taking, if unambiguous
         data: fltarr(4096,4)}    ; data arrays: [*,0]=vel arr
                                  ;              [*,1]=raw spectral intensity arr
                                  ;              [*,2]=smoothed,baselined spectral intensity array
                                  ;              [*,3]=rfi arr
 
end
