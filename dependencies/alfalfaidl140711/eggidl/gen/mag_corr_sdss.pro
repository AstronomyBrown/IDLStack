PRO MAG_CORR_SDSS, ALFAFILE, SDSSFILE, CORRCAT, petro=petro, model=model, noint=noint

;+
;
;NAME:
;       MAG_CORR_SDSS
;
;PURPOSE:
;       To take an ALFALFA catalog, list of SDSS matches and create an
;       output structure containing information from ALFALFA, SDSS,
;       and corrected B band magnitudes.
;
;SYNTAX:
;       mag_corr_sdss, alfafile, sdssfile, corrcat, (/petro), (/model)
;
;INPUTS:
;       alfafile - the full pathname for an ALFALFA catalog
;
;       sdssfile - the full pathname for a CSV SDSS file of possible
;                  optical counterparts
;
;OUTPUTS:
;       corrcat - a structure containing information from both ALFALFA
;                 and SDSS, along with extinction corrected B band
;                 magnitude information
;
;KEYWORDS:
;       /petro - calculate the B mag based on sloan Petrosian mags
;       
;       /model - calculate the B mag based on sloan model mags
;
;       /noint - If set, internal extinction corrections will not be
;                applied to the galaxies
;
;EXAMPLE:
;       mag_corr_sdss,'CR1_catalog.dat','result-1.csv',corrcat,/petro,/model
;
;NOTES:
;       If neither petro nor model keywords are specified no B
;       magnitude information will be returned. 
;
;       The reported B band errors are only the errors in g and r
;       bands propagated through the formula for finding B.  They do
;       not include any uncertanities in the filter correction or any
;       other corrections
;
;       This procedure looks for the axial ratios from an exponential
;       fit in the g band.  The reasoning is that most galaxies
;       detected by ALFALFA will be late-type and well fit by an
;       exponential profile.  In addition, the sloan g filter is
;       closest to B and so will be most indicative of axial ratios in B
;
;REVISION HISTORY:
;       Written B. Adams August 2007
;
;-


;Check the syntax:
if n_params() lt 3 then begin
    print, 'syntax: mag_corr_sdss,<alfafile>,<sdssfile>,corr_cat'
    print, '        Created a structure, corr_cat, of matched ALFALFA'
    print, '        and SDSS sources along with extinction correct B mags'
    return
endif

;Create a matched structure to work with
match_sdss,alfafile,sdssfile,cat


;Some things to get started with
;check number of rows and the tags for the structure
nrows = n_elements(cat)
names = strlowcase(tag_names(cat))

;get reddening values from the AGC

restore,'/home/dorado3/galaxy/idl_alfa/agctotal.sav/'
dirbe = fltarr(nrows)
for i=0,(nrows-1) do begin
  j = where( agctotal.agcnumber eq cat[i].agc, count )
  if (count ne 0) then dirbe[i] = float(agctotal.extdirbe[j]) / 1000.
endfor




;check the flags and compute B mags (uncorrected)
;Convert to B mags (AB) using Blanton & Roweiss, 2007
;Convert to Johnson B using Frei & Gunn, 1994

if keyword_set(petro) then begin
    jp = where(names eq 'petromag_r', rctp)
    kp = where(names eq 'petromag_g', gctp)
    b_ab_petro = fltarr(nrows) - 99
    b_petro = fltarr(nrows) - 99
    B0_petro = fltarr(nrows) - 99
    if (gctp eq 0) OR (rctp eq 0) then begin
        print, 'Petrosian B magnitude cannnot be computed due to missing information'
    endif else begin
;filter transform to b 
        j = where(cat.petromag_g ne -99 AND cat.petromag_r ne -99)
        b_ab_petro[j] = cat[j].petromag_g + 0.2354 + 0.3915*( (cat[j].petromag_g - cat[j].petromag_r) - 0.6102)
        b_petro[j] = b_ab_petro[j] + 0.163
;galactic extinction from dirbe maps
        B0_petro[j] = b_petro[j] - 4.315*dirbe[j]
;check on internal extinction and apply from tully et al 1998
        if keyword_set(noint) then begin
            print, 'Internal extinction correction will not be applied at this time.' 
        endif else begin
            k = where(names eq 'expab_g', ch)
            if (ch eq 0) then begin
                print, 'Internal extinction correction cannot be applied due to missing axial ratio information.'
                print, ' The axial ratio from an exponential fit in the Sloan g filter is expected'
            endif else begin
                inc = fltarr(nrows)-99
                inc[j] = acos(cat[j].expab_g)
                w50i = cat.w50
                w50i[j] = cat[j].w50 / sin(inc[j])
                gamma_b = fltarr(nrows)
                gamma_b[j] = 1.57 + 2.75 * ( alog10(w50i[j]) - 2.5 )
                A_b = fltarr(nrows)
                A_b[j] = gamma_b[j] * alog10( 1. / cat[j].expab_g )
                B0_petro = B0_petro - A_b
            endelse
        endelse
    endelse
;check on errors and propagate through as best can
    jpe = where(names eq 'petromagerr_r', recp)
    kpe = where(names eq 'petromagerr_g', gecp)
    b_petro_err = fltarr(nrows)-99
    if (recp eq 0) OR (gecp eq 0) then begin
        print, 'Petrosian B errors cannot be computed due to missing information'
    endif else begin
        b_petro_err[j] = sqrt( cat[j].petromagerr_g^2 + (0.3915 * sqrt( cat[j].petromagerr_r^2 + cat[j].petromagerr_g^2 ) )^2  )
    endelse
endif



if keyword_set(model) then begin
    jm = where(names eq 'modelmag_r', rctm)
    km = where(names eq 'modelmag_g', gctm)
    b_ab_model=fltarr(nrows)-99
    b_model=fltarr(nrows)-99
    B0_model=fltarr(nrows)-99
    if (gctm eq 0) OR (rctm eq 0) then begin
        print, 'Model B magnitude cannnot be computed due to missing information'
    endif else begin
;filtertransforms to B
        j2 = where(cat.modelmag_g ne -99 AND cat.modelmag_r ne -99)
        b_ab_model[j2] = cat[j2].modelmag_g + 0.2354 + 0.3915*( (cat[j2].modelmag_g - cat[j2].modelmag_r) - 0.6102)
        b_model[j2] = b_ab_model[j2] + 0.163
;galactic extinction from dirbe maps
        B0_model[j2] = b_model[j2] - 4.315*dirbe[j2]
;check on internal extinction and apply from tully et al 1998
        if keyword_set(noint) then begin
            print, 'Internal extinction correction will not be applied at this time.' 
        endif else begin
            k = where(names eq 'expab_g', ch)
            if (ch eq 0) then begin
                print, 'Internal extinction correction cannot be applied due to missing axial ratio information.'
                print, ' The axial ratio from an exponential fit in the Sloan g filter is expected'
            endif else begin
                inc=fltarr(nrows)-99
                inc[j2] = acos(cat[j2].expab_g)
                w50i = cat.w50
                w50i[j2] = cat[j2].w50 / sin(inc[j2])
                gamma_b = fltarr(nrows)
                gamma_b[j2] = 1.57 + 2.75 * ( alog10(w50i[j2]) - 2.5 )
                A_b = fltarr(nrows)
                A_b[j2] = gamma_b[j2] * alog10( 1. / cat[j2].expab_g )
                B0_model = B0_model - A_b
            endelse
        endelse
    endelse
;check on errors and propagate through as best can
    jme = where(names eq 'modelmagerr_r', recm)
    kme = where(names eq 'modelmagerr_g', gecm)
    b_model_err = fltarr(nrows) -99
    if (recm eq 0) OR (gecm eq 0) then begin
        print, 'Model B errors cannot be computed due to missing information'
    endif else begin
        b_model_err[j2] = sqrt( cat[j2].modelmagerr_g^2 + (0.3915 * sqrt( cat[j2].modelmagerr_r^2 + cat[j2].modelmagerr_g^2 ) )^2  )
    endelse
endif

;Have corrected magnitudes, if asked for and info available.  Now need
;to create the output structure

extra = 0
if keyword_set(model) then extra = 3 + extra
if keyword_set(petro) then extra = 3 + extra

indcat = n_elements(names) - 1

ncols = n_elements(names) + extra + 1
d = strarr(ncols, nrows)


    for k=0,(indcat) do d[k,*] = cat[*].(k)

    if keyword_set(petro) then begin
        d[indcat+1,*] = b_petro[*]
        d[indcat+2,*] = B0_petro[*]
        d[indcat+3,*] = b_petro_err[*]
    endif

    if keyword_set(model) then begin
        d[ncols-4,*]=b_model[*]
        d[ncols-3,*]=B0_model[*]
        d[ncols-2,*]=b_model_err[*]
    endif

    d[ncols-1,*] = dirbe[*]

;add the new tag names
if keyword_set(petro) then names=[names,'b_petro','B0_petro','berr_petro']
if keyword_set(model) then names=[names,'b_model','B0_model','berr_model']
names = [names,'dirbe']

coln=strlowcase(names)

;check for tag names to get data type correct

st = where(coln eq 'object' OR coln eq 'altname' OR coln eq 'hi_ra' OR coln eq 'hi_dec' OR coln eq 'opt_ra' $
           OR coln eq 'opt_dec' OR coln eq 'code' OR coln eq 'grid' OR coln eq 'name')
l = where(coln eq 'agc' OR coln eq 'dra' OR coln eq 'ddec' OR coln eq 'v50' or coln eq 'verr' OR coln eq 'w50' $
          OR coln eq 'werr' OR coln eq 'objid' OR coln eq 'flags' OR coln eq 'detections')

j=where(st eq 0, stct)
k=where(l eq 0, lct)

if (stct gt 0) then cvalue='0' else if (lct gt 0) then cvalue=0LL else cvalue=0.

corrcat = create_struct(coln[0],cvalue)

for i=1,ncols-1 do begin
    j = where(st eq i, stct)
    k = where(l eq i, lct)
    if (stct gt 0) then cvalue='0' else if (lct gt 0) then cvalue=0LL else cvalue=0.
    corrcat = create_struct(corrcat,coln[i],cvalue)
endfor

corrcat=replicate(corrcat,nrows)

;read the data into the structure

for i=0,ncols-1 do corrcat.(i) = reform(d[i,*])

END
