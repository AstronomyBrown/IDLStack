PRO CORR_MAG_VAGC, ALFAFILE, VAGC, OUTCAT, petro=petro, model=model, noint=noint

;+
;NAME:
;       CORR_MAG_VAGC
;
;PURPOSE:
;       To match an ALFALFA catalog to the VAGC and produce extinction
;       correct B magnitudes
;
;SYNTAX:
;       CORR_MAG_VAGC, alfafile, vagc, outcat, (/petro),(/model), (/noint)
;
;INPUTS:
;       alfafile - the full pathname of an ALFALFA catalog
;
;       vagc - the pathname of the vagc (alfalfa limited) sav file
;
;OUTPUS:
;       outcat - an output structure that will contain blue magnitudes
;                for ALFALFA sources
;
;KEYWORDS:
;       petro - if this flag is set, B band magnitudes will be
;               calculated from the Petrosian Sloan magnitudes
;       model - if this flag is set, B band magnitudes will be
;               calculated from the model Sloan magnitudes
;       noint - don't apply the internal extinction correction
;
;EXAMPLE:
;       corr_mag_vagc,'CR1_catalog.dat','vagc/sdssimaging_alfalfa.sav',mbcat,/petro
;
;NOTES:
;
;REVISION HISTORY:
;       Written B. Adams August 2007
;
;-

;Check the syntax
if n_params() lt 3 then begin
  print, 'syntax: corr_mag_vagc, <alfafile>, <vagc>, outcat'
  print, 'Calculates blue magnitudes based on magnitudes'
  print, 'from the VAGC SDSS imaging survey.'
  print, 'Extinction corrections are applied.'
  return
endif


;Need to create a matched ALFALFA-VAGC catalog

match_vagc,alfafile,vagc,vagc_alfacat

;Will need the AGC for Galactic reddening
;Use a hardwired location to the IDL friendly version found on dorado3

restore,'/home/dorado3/galaxy/idl_alfa/agctotal.sav/'

;Pull the Dirbe reddening values out
n = n_elements(vagc_alfacat.object)
dirbe = fltarr(n)

for i=0,(n-1) do begin
  j = where( agctotal.agcnumber eq vagc_alfacat[i].agc, count )
  if (count ne 0) then dirbe[i] = float(agctotal.extdirbe[j]) / 1000.
endfor

;Separate the g and r magnitudes out from the VAGC
;Will have to convert from nanomaggies to magnitudes

;First check everything for the petro flag
if keyword_set(petro) then begin
    gband = vagc_alfacat.petroflux[1]
    rband = vagc_alfacat.petroflux[2]

    gmag=fltarr(n) - 99
    rmag=fltarr(n) - 99
    b_petro = fltarr(n) -99
    b_ab_petro = fltarr(n)-99

    j=where(gband gt 0, countj)
    k=where(rband gt 0, countk)

    if countj ne 0 then gmag[j] = 22.5 - 2.5 * alog10(gband[j])
    if countk ne 0 then rmag[k] = 22.5 - 2.5 * alog10(rband[k])

;Convert to B magnitude (AB system) using Blanton & Roweiss, 2007
    cp = where(gband gt 0 AND rband gt 0, ct1)
    if ct1 gt 0 then b_ab_petro[cp]= gmag[cp] + 0.2354 + 0.3915 * ( (gmag[cp] - rmag[cp]) - 0.6102 )
;Take AB to Johnson B by using conversion from Frei & Gunn, 1994
    if ct1 gt 0 then b_petro[cp] = b_ab_petro[cp] + 0.163
endif

;Do the same for model flag
if keyword_set(model) then begin
    gband = vagc_alfacat.modelflux[1]
    rband = vagc_alfacat.modelflux[2]

    gmag=fltarr(n) - 99
    rmag=fltarr(n) - 99
    b_model = fltarr(n)-99
    b_ab_model = fltarr(n)-99

    j=where(gband gt 0, countj)
    k=where(rband gt 0, countk)

    if countj ne 0 then gmag[j] = 22.5 - 2.5 * alog10(gband[j])
    if countk ne 0 then rmag[k] = 22.5 - 2.5 * alog10(rband[k])

;Convert to B magnitude (AB system) using Blanton & Roweiss, 2007
    cm = where(gband gt 0 AND rband gt 0, ct)
    if ct gt 0 then b_ab_model[cm] = gmag[cm] + 0.2354 + 0.3915 * ( (gmag[cm] - rmag[cm]) - 0.6102 )
;Take AB to Johnson B by using conversion from Frei & Gunn, 1994
    if ct gt 0 then b_model[cm] = b_ab_model[cm] + 0.163
endif

;Apply extinction corrections.
;Galactic extinction is always applied.
;Check for the flag for internal extinction.

b_model_corr=fltarr(n)-99
b_petro_corr=fltarr(n)-99
if keyword_set(model) then if ct gt 0 then b_model_corr[cm] = b_model[cm] - 4.315*dirbe[cm]
if keyword_set(petro) then if ct1 gt 0 then b_petro_corr[cp] = b_petro[cp] - 4.315*dirbe[cp]


print, 'There is no axial ratio information so internal extinction is not computed.'
;Internal extinction corrections come from Tully et al. 1998
;Note that this correction is commented out for the current time as it
;requires an inclination correction that is not available from the VAGC

;w50i = alfacat.w50
;gamma_b = 1.57 + 2.75 * ( alog10(w50i) - 2.5 )
;A_b = gamma_b * alog10(a_b)
;if keyword_set(noint) then begin
;  print, 'Internal exctinction correction will not be applied at this time.'
;endif else
;  if keyword_set(model) then b_model_corr = b_model_corr - A_b
;  if keyword_set(petro) then b_petro_corr = b_petro_corr - A_b
;end else


;create a dummy string array
extra=0
if keyword_set(model) then extra=extra+2
if keyword_set(petro) then extra=extra+2
ncol=n_tags(vagc_alfacat)+extra
nrow=n_elements(vagc_alfacat)
d=strarr(ncol,nrow)
indcat=n_tags(vagc_alfacat)-1

for j=0,nrow-1 do begin
    for k=0,indcat do d[k,j] = strjoin(string(vagc_alfacat[j].(k)))
    if keyword_set(model) then begin
        d[indcat+1,j]=b_model[j]
        d[indcat+2,j]=b_model_corr[j]
    endif
    if keyword_set(petro) then begin
        d[ncol-2,j]=b_petro[j]
        d[ncol-1,j]=b_petro_corr[j]
    endif
endfor

names=[tag_names(vagc_alfacat)]
if keyword_set(model) then names=[names,'b_model','B0_model']
if keyword_set(petro) then names=[names,'b_petro','B0_petro']

coln=strlowcase(names)

;check the data type for various columns
st = where(coln eq 'object' OR coln eq 'altname' OR coln eq 'hi_ra' OR coln eq 'hi_dec' OR coln eq 'opt_ra' $
           OR coln eq 'opt_dec' OR coln eq 'code' OR coln eq 'grid' OR coln eq 'rerun')
l = where(coln eq 'agc' OR coln eq 'dra' OR coln eq 'ddec' OR coln eq 'v50' or coln eq 'verr' OR coln eq 'w50' $
          OR coln eq 'werr' OR coln eq 'detections' OR coln eq 'match' OR coln eq 'sdss_imaging_tag' OR $
          coln eq 'sdss_imaging_tag_primary' OR coln eq 'run' OR coln eq 'camcol' OR coln eq 'field' $
          OR coln eq 'id' OR coln eq 'nchild' OR coln eq 'resolve_status' OR strpos(coln,'objc') ge 0 $
          OR coln eq 'vagc_select' OR coln eq 'calibobj_position' or coln eq 'ifield' or coln eq 'balkan_id')
far = where(strpos(coln,'flux') gt 0 OR coln eq 'nmgypercount' OR coln eq 'petror50' OR coln eq 'petror90' $
            OR coln eq 'extinction')
lar = where(coln eq 'calib_status' OR coln eq 'flags' OR coln eq 'flags2' OR coln eq 'colc')

j=where(st eq 0, stct)
k=where(l eq 0, lct)
h=where(far eq 0, farct)
kk=where(lar eq 0,larct)
if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue=-99L else if (farct gt 0) then cvalue=[-99.,-99.,-99.,-99.,-99.] else if (larct gt 0) then cvalue=[-99L,-99L,-99L,-99L,-99L] else cvalue=-99.

outcat = create_struct(names[0],cvalue)

for i=1,ncol-1 do begin
    j=where(st eq i, stct)
    k=where(l eq i, lct)
    h=where(far eq i, farct)
    kk=where(lar eq i,larct)
    if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue=-99L else if (farct gt 0) then cvalue=[-99.,-99.,-99.,-99.,-99.] else if (larct gt 0) then cvalue=[-99L,-99L,-99L,-99L,-99L] else cvalue=-99.
    outcat = create_struct(outcat,names[i],cvalue)
endfor

outcat = replicate(outcat,nrow)


for j=0,nrow-1 do for i=0,ncol-1 do outcat[j].(i) = reform(strsplit(d[i,j],/extract))


END
