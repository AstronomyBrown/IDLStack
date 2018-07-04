PRO CORR_MAG_2MASS, ALFAFILE, TWOMASSFILE, OUTCAT, iso=iso, ext=ext, jmag=jmag, hmag=hmag, kmag=kmag, noint=noint

;+
;NAME:
;       CORR_MAG_2MASS
;
;PURPOSE:
;       To take a catalog that has been run through match2mass with
;       both 2mass and ALFALFA data and output a catalog that contains
;       corrected 2mass magnitudes.
;
;SYNTAX:
;       CORR_MAG_2MASS, incat, outcat, (/ext), (/iso), (/kmag),
;       (/hmag), (/jmag), (/noint)
;
;
;INPUTS:
;       alfafile - the full pathname of an ALFALFA catalog
;
;       twomassfile - the full pathname of the corresponding 2MASS
;                     catalog for the given ALFALFA catalog
;
;
;OUTPUTS:
;       outcat - an output catalog that contains all the information
;                of the input catalog plus the corrected magnitudes
;
;KEYWORDS:
;       /iso - correct the isophotal magnitudes
;       /ext - correct the extrapolated magnitudes
;       /jmag - correct the J mags
;       /hmag - correct the H mags
;       /kmag - correct the K mags
;       /noint - don't apply the correction for internal extinction
;
;EXAMPLE:
;       corr_mag_2mass,'CR1_catalog.dat','twomass_sources.txt',outcat,/ext,/jmag,/kmag,/noint
;
;NOTES:
;       This program applies Galactic and internal extinction
;       corrections to 2mass magnitudes.  The user has the option of
;       not applying the internal extinction corrections.  K corrections are not
;       available at this time.
;
;       The user must specify which magnitude system(s) and which
;       band(s) are to be used.  If none are specified, the procedure
;       will not correct any magnitudes.
;
;REVISION HISTORY:
;       Written B. Adams  July 2007
;
;-


;Check the syntax
if n_params() lt 3 then begin
  print, 'syntax: corr_mag_2mass, <alfafile>, <twomassfile>, outcat, (/ext), (/iso), (/jmag)$'
  print,          '(/kmag), (/hmag)'
  print, 'Applies magnitude corrections to selected magnitudes from a '
  print, ' catalog created by match2mass'
  return
endif


;Create a matched structure to work with
match2mass,alfafile,twomassfile,cat


;Use the IDL-friendly version of the AGC found in
;/home/dorado3/galaxy/idl_alfa/agctotal.sav'
;Note that this can be regenerated using combineagc.pro, found in the
;same directory.

restore,'/home/dorado3/galaxy/idl_alfa/agctotal.sav/'

;Get the number of rows and column names
nrow = n_elements(cat.object)
names = strlowcase(tag_names(cat))

;Get the DIRBE E(B-V) values from the AGC
dirbe=fltarr(nrow)
for i=0,(nrow-1) do begin
  j = where( agctotal.agcnumber eq cat[i].agc, count )
  if (count ne 0) then dirbe[i] = float(agctotal.extdirbe[j]) / 1000.
endfor

;Cycle through the possibilities of filter and magnitude type
;Check that the data exists and apply Galactic extinction corrections if it does
if keyword_set(ext) then begin

    if keyword_set(jmag) then begin
        j0_ext = fltarr(nrow)-99
        je = where(names eq 'j_m_ext', ject)
        if ject eq 0 then begin
            print, 'Information is missing for extrapolated J magnitude'
        endif else begin
            j2e = where(cat.j_m_ext ne -99, ch)
            if ch gt 0 then j0_ext[j2e] = cat[j2e].j_m_ext - 0.902*dirbe[j2e]
        endelse
    endif

    if keyword_set(hmag) then begin
        h0_ext = fltarr(nrow)-99
        he = where(names eq 'h_m_ext', hect)
        if hect eq 0 then begin 
            print, 'Information is missing for extrapolated H magnitude'
        endif else begin
            h2e = where(cat.h_m_ext ne -99,ch)
            if ch gt 0 then h0_ext[h2e] = cat[h2e].h_m_ext - 0.576*dirbe[h2e]
        endelse
    endif

    if keyword_set(kmag) then begin
        k0_ext = fltarr(nrow)-99
        ke = where(names eq 'k_m_ext', kect)
        if kect eq 0 then begin
            print, 'Information is missing for extrapolated K magnitude'
        endif else begin
            k2e = where(cat.k_m_ext ne -99, ch)
            if ch gt 0 then k0_ext[k2e] = cat[k2e].k_m_ext - 0.367*dirbe[k2e]
        endelse
    endif

endif


if keyword_set(iso) then begin

    if keyword_set(jmag) then begin
        j0_iso = fltarr(nrow)-99
        ji = where(names eq 'j_m_k20fe', jict)
        if jict eq 0 then begin
            print, 'Information is missing for isophotal J magnitude'
        endif else begin
            j2i = where(cat.j_m_k20fe ne -99, ch)
            if ch gt 0 then j0_iso[j2i] = cat[j2i].j_m_k20fe - 0.902*dirbe[j2i]
        endelse
    endif

    if keyword_set(hmag) then begin
        h0_iso = fltarr(nrow)-99
        hi = where(names eq 'h_m_k20fe', hict)
        if hict eq 0 then begin
            print, 'Information is missing for isophotal H magnitude'
        endif else begin
            h2i=where(cat.h_m_k20fe ne -99, ch)
            if ch gt 0 then h0_iso[h2i]=cat[h2i].h_m_k20fe - 0.576*dirbe[h2i]
        endelse
    endif

    if keyword_set(kmag) then begin
        k0_iso = fltarr(nrow)-99
        ki = where(names eq 'k_m_k20fe', kict)
        if kict eq 0 then begin
            print, 'Information is missing for isphotal K magnitude'
        endif else begin
            k2i = where(cat.k_m_k20fe ne -99, ch)
            if ch gt 0 then k0_iso[k2i]=cat[k2i].k_m_k20fe - 0.367*dirbe[k2i]
        endelse
    endif

endif


;Now check for internal extinction corrections
;The corrections come form Masters et al. 2003

if keyword_set(noint) then begin
    print, 'Internal extinction correction will not be applied.'
endif else begin
    ab = where(names eq 'k_ba', ch1)
    if (ch1 eq 0) then begin
        print, 'Axial ratio (K_BA) information is missing and internal extinction cannot be applied.'
    endif else begin
        logab = fltarr(nrow) - 99
        st = where(cat.k_ba gt 0, ch2)
        if (ch2 ne 0) then logab[st] = alog10( 1 / cat[st].k_ba )
        la = where( logab gt 0 AND logab le 0.5, ctl)
        ha = where(logab gt 0.5, cth)

        if keyword_set(iso) then begin

            if keyword_set(jmag) then begin
                if jict ne 0 then begin
                    jli = where( logab gt 0 AND logab le 0.5 and cat.j_m_k20fe ne -99, cjli)
                    jhi = where( logab gt 0.5 AND cat.j_m_k20fe ne -99, cjhi)
                    j0_iso_err = fltarr(nrow)-99
                    if (cjli ne 0) then begin
                        j0_iso[jli] = j0_iso[jli] - 0.48
                        j0_iso_err[jli] = sqrt( 0.015^2 + cat[jli].j_msig_k20fe^2 )
                    endif
                    if (cjhi ne 0) then begin
                        j0_iso[jhi] = j0_iso[jhi] - ( 1.6 + 0.24 / logab[jhi] )
                        j0_iso_err[jhi] = sqrt( 0.02^2 + cat[jhi].j_msig_k20fe^2 )
                    endif
                endif
            endif

            if keyword_set(hmag) then begin
                if hict ne 0 then begin
                    hli = where( logab gt 0 AND logab le 0.5 and cat.h_m_k20fe ne -99, chli)
                    hhi = where( logab gt 0.5 AND cat.h_m_k20fe ne -99, chhi)
                    h0_iso_err = fltarr(nrow)-99
                    if (chli ne 0) then begin
                        h0_iso[hli] = h0_iso[hli] - 0.39
                        h0_iso_err[hli] = sqrt( 0.015^2 + cat[hli].h_msig_k20fe^2 )
                    endif
                    if (chhi ne 0) then begin
                    	h0_iso[hhi] = h0_iso[hhi] - ( 1.4 + 0.2 / logab[hhi] )
                        h0_iso_err[hhi] = sqrt( 0.02^2 + cat[hhi].h_msig_k20fe^2 )
                    endif
                endif	
            endif

            if keyword_set(kmag) then begin
                if kict ne 0 then begin
                    kli = where( logab gt 0 AND logab le 0.5 and cat.k_m_k20fe ne -99, ckli)
                    khi = where( logab gt 0.5 AND cat.k_m_k20fe ne -99, ckhi)
                    k0_iso_err = fltarr(nrow) - 99
                    if (ckli ne 0) then begin
                        k0_iso[kli] = k0_iso[kli] - 0.26
                        k0_iso_err[kli] = sqrt( 0.015^2 + cat[kli].k_msig_k20fe^2 )
                    endif
                    if (ckhi ne 0) then begin
                        k0_iso[khi] = k0_iso[khi] - ( 1.1 + 0.13 / logab[khi] )
                        k0_iso_err[khi] = sqrt( 0.2^2 + cat[khi].k_msig_k20fe^2 )
                    endif
                endif	
            endif
        endif


        if keyword_set(ext) then begin

            if keyword_set(jmag) then begin
                if ject ne 0 then begin
                    jle = where( logab gt 0 AND logab le 0.5 and cat.j_m_ext ne -99, cjle)
                    jhe = where( logab gt 0.5 AND cat.j_m_ext ne -99, cjhe)
                    j0_ext_err = fltarr(nrow) - 99
                    if (cjle ne 0) then begin
                        j0_ext[jle] = j0_ext[jle] - 0.48
                        j0_ext_err[jle] = sqrt( 0.015^2 + cat[jle].j_msig_ext^2)
                    endif
                    if (cjhe ne 0) then begin 
                        j0_ext[jhe] = j0_ext[jhe] - ( 1.6 + 0.24 / logab[jhe] )
                        j0_ext_err[jhe] = sqrt( 0.02^2 + cat[jhe].j_msig_ext^2 )
                    endif
                endif
            endif


            if keyword_set(hmag) then begin
                if hect ne 0 then begin
                    hle = where( logab gt 0 AND logab le 0.5 and cat.h_m_ext ne -99, chle)
                    hhe = where( logab gt 0.5 AND cat.h_m_ext ne -99, chhe)
                    h0_ext_err = fltarr(nrow) - 99
                    if (chle ne 0) then begin
                        h0_ext[hle] = h0_ext[hle] - 0.39
                        h0_ext_err[hle] = sqrt( 0.015^2 + cat[hle].h_msig_ext^2 )
                    endif
                    if (chhe ne 0) then begin
                        h0_ext[hhe] = h0_ext[hhe] - ( 1.4 + 0.2 / logab[hhe] )
                        h0_ext_err[hhe] = sqrt( 0.02^2 + cat[hhe].h_msig_ext^2 )
                    endif
                endif
            endif


            if keyword_set(kmag) then begin
                if kect ne 0 then begin
                    kle = where( logab gt 0 AND logab le 0.5 and cat.k_m_ext ne -99, ckle)
                    khe = where( logab gt 0.5 AND cat.k_m_ext ne -99, ckhe)
                    k0_ext_err = fltarr(nrow) - 99
                    if (ckle ne 0) then begin
                        k0_ext[kle] = k0_ext[kle] - 0.26
                        k0_ext_err[kle] = sqrt( 0.015^2 + cat[kle].k_msig_ext^2 )
                    endif
                    if (ckhe ne 0) then begin
                        k0_ext[khe] = k0_ext[khe] - ( 1.1 + 0.13 / logab[khe] )
                        k0_ext_err[khe] = sqrt( 0.02^2 + cat[khe].k_msig_ext^2 )
                    endif
                endif            
            endif
        endif
    endelse
endelse


;Time to create the output structure
;Check on the number of keywords to see how many extra columns will be
;needed

extra = 0

if keyword_set(ext) then begin
    if keyword_set(jmag) then extra = extra + 2
    if keyword_set(hmag) then extra = extra + 2
    if keyword_set(kmag) then extra = extra + 2
endif
if keyword_set(iso) then begin
    if keyword_set(jmag) then extra = extra + 2
    if keyword_set(hmag) then extra = extra + 2
    if keyword_set(kmag) then extra = extra + 2
endif


ncol = n_elements(names) + extra + 1
d = strarr(ncol,nrow)

indcat = n_elements(names) - 1

    
    for k=0,indcat do d[k,*] = cat[*].(k)

    ind = indcat + 1
    if keyword_set(iso) then begin
        if keyword_set(jmag) then begin
            d[ind,*] = j0_iso
            d[ind+1,*] = j0_iso_err
            ind = ind+2
        endif
        if keyword_set(hmag) then begin
            d[ind,*] = h0_iso
            d[ind+1,*] = h0_iso_err
            ind = ind+2
        endif
        if keyword_set(kmag) then begin
            d[ind,*] = k0_iso
            d[ind+1,*] = k0_iso_err
            ind = ind+2
        endif
    endif
    if keyword_set(ext) then begin
        if keyword_set(jmag) then begin
            d[ind,*] = j0_ext
            d[ind+1,*] = j0_ext_err
            ind = ind+2
        endif
        if keyword_set(hmag) then begin
            d[ind,*] = h0_ext
            d[ind+1,*] = h0_ext_err
            ind = ind+2
        endif
        if keyword_set(kmag) then begin
            d[ind,*] = k0_ext
            d[ind+1,*] = k0_ext_err
            ind=ind+2
        endif
    endif

    d[ind,*] = dirbe[*]

;Add the new tag names

if keyword_set(iso) then begin
    if keyword_set(jmag) then names = [names, 'j0_iso', 'j0_iso_err']
    if keyword_set(hmag) then names= [names, 'h0_iso', 'h0_iso_err']
    if keyword_set(kmag) then names= [names, 'k0_iso', 'k0_iso_err']
endif
if keyword_set(ext) then begin
    if keyword_set(jmag) then names = [names, 'j0_ext', 'j0_ext_err']
    if keyword_set(hmag) then names = [names, 'h0_ext', 'h0_ext_err']
    if keyword_set(kmag) then names = [names, 'k0_ext', 'k0_ext_err']
endif
names=[names,'dirbe']

;Check for tag names to get data type correct


coln=strlowcase(names)

st = where(coln eq 'object' OR coln eq 'altname' OR coln eq 'hi_ra' OR coln eq 'hi_dec' OR coln eq 'opt_ra' $
           OR coln eq 'opt_dec' OR coln eq 'code' OR coln eq 'grid' OR coln eq 'objname_u' OR coln eq 'cys_u' $
           OR coln eq 'equinox_u' OR coln eq 'designation' OR coln eq 'cc_flg')
l = where(coln eq 'agc' OR coln eq 'dra' OR coln eq 'ddec' OR coln eq 'v50' or coln eq 'verr' OR coln eq 'w50' $
          OR coln eq 'werr' OR coln eq 'cntr_u' OR strpos(coln,'flg') ge 0 OR strpos(coln,'phi') ge 0 $
          OR coln eq 'detections')

j = where(st eq 0,stct)
k=where(l eq 0, lct)
if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue=-99L else cvalue=-99.

outcat = create_struct(names[0],cvalue)

for i=1,ncol-1 do begin
    j = where(st eq i, stct)
    k = where(l eq i, lct)
    if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue=-99LL else cvalue=-99.
    outcat = create_struct(outcat,names[i],cvalue)
endfor

outcat = replicate(outcat, nrow)

; Read the data into the structure

for i=0,ncol-1 do outcat.(i) = reform(d[i,*])


END
