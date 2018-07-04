PRO MATCH_VAGC, ALFAFILE, VAGC, OUTCAT, opt=opt, hi=hi, radius=radius

;+
;NAME:
;       MATCH_VAGC
;
;PURPOSE:
;       This procedure is designed to take an ALFALFA catalog produced
;by the pipeline and match HI detections to sources in the VAGC.  At
;this point in time the output catalog only returns  information about
;matches from the Sloan imaging survey.  However this information
;includes an identifier for sources in the VAGC and would allow easy
;matches to the other catalogs included in the VAGC.
;
;SYNTAX:
;        MATCH_VAGC, alfafile, vagc, outcat,(/hi),(/opt)
;
;INPUTS:
;        alfafile - the full pathname of an ALFALFA catalog produced by
;                  the standard pipeline.
;        vagc - the full location of the idl save file that is the
;               ALFALFA coverage limited SDSS Imaging information from
;               the VAGC
;
;OUTPUTS:
;        outcat - an output catalog containing the ALFALFA and SDSS
;                 information for sources.
;
;KEYWORDS:
;        /hi - set to use HI coordinates of ALFALFA detection for
;              matching
;        /opt - set to use coordinates of identified optical
;               counterpart for matching
;        radius - radius to look for optical matches within.  Defaults
;                 to 60 arcseconds
;
;EXAMPLE:
;        match_vagc,'CR1_catalog.dat','vagc/sdssimaging_alfalfa.sav',vagc_alfacat,/hi
;
;NOTES:
;        If neither the /hi nor /opt keywords are set, the procedure
;        will default to using the HI coordinates for matching purposes
;
;REVISION HISTORY:
;        Written by B. Adams  August 2007
;        Modified by B. Adams August 2007 to create output structure
;        from a string array rather than appending columns
;-

;Check the syntax
if n_params() lt 3 then begin
  print, 'syntax: match_vagc,alfafile,vagcfile,outcat,(/opt),(/hi),(radius=60)'
  print, 'Searches for matching objects from the VAGC SDSS imaging data using'
  print, 'either optical or HI coordinates within a box defined by radius.'
  print, 'The closest match is returned.'
  return
endif

;Read the ALFALFA catalog into a structure
read_alfalfacat,alfafile,alfacat

;Restore the IDL save file of the SDSS Imaging survey portion of the
;VAGC
restore,vagc

;Convert RA and DEC strings from the ALFALFA catalog into decimal
;degree
if keyword_set(opt) then begin
  inra = alfacat.opt_ra
  indec = alfacat.opt_dec
endif else begin
  inra = alfacat.hi_ra
  indec = alfacat.hi_dec
endelse

rah=strmid(inra,0,2)
ram=strmid(inra,2,2)
ras=strmid(inra,4,4)
decd=strmid(indec,0,3)
decm=strmid(indec,3,2)
decs=strmid(indec,5,2)
ra = ( float(rah) + float(ram) / 60 + float(ras) / 3600 ) * 15
dec = float(decd) + float(decm) / 60 + float(decs) / 3600

;Search for all the matches within a given search radius.
;If no radius is given, default to 60 arcseconds.
;Okay, it's actually a square of dimension 2*radius

if keyword_set(radius) then begin
  search = radius
endif else begin
  search = 60
endelse

search = float(search)
search = search / 3600.

;Find sizes and create dummy array
n = n_elements(alfacat)
detections = intarr(n)
match = ulon64arr(n)
separation = fltarr(n)
nrow = n
ncol = n_tags(alfacat) + n_tags(sdssimaging_alfalfa) + 3
d = strarr(ncol,nrow)
indvagc = n_tags(alfacat)

;Search for closest matches and put data into string array
for i=0,(n-1) do begin
  j = where( (ra[i] + search) gt sdssimaging_alfalfa.ra AND (ra[i] - search) lt sdssimaging_alfalfa.ra )
  k = where( (dec[i] + search) gt sdssimaging_alfalfa[j].dec AND (dec[i] - search) lt sdssimaging_alfalfa[j].dec, count)
  for h1=0,n_tags(alfacat)-1 do d[h1,i]=alfacat[i].(h1)
  if (count ne 0) then begin
    detections[i] = count
    ind = j[k]
    match[i] = ind[0]
    dist_vagc = 3600 * sqrt( (ra[i] - sdssimaging_alfalfa[ind].ra)^2 + (dec[i] - sdssimaging_alfalfa[ind].dec)^2 )
    separation[i] = dist_vagc[0]
    if count eq 1 then for h2=indvagc,ncol-4 do d[h2,i] = strjoin(string(sdssimaging_alfalfa[ind].(h2-indvagc)))
    if count gt 1 then begin
      closest = min(dist_vagc,loc)
      match[i] = ind[loc]
      separation[i] = dist_vagc[loc]
      for h2=indvagc,ncol-4 do d[h2,i] = strjoin(string(sdssimaging_alfalfa[ind[loc]].(h2-indvagc)))
    endif
  endif
  d[ncol-3,i] = detections[i]
  d[ncol-2,i] = separation[i]
  d[ncol-1,i] = match[i]
endfor

;The array detections contains the number of matches for an ALFALFA
;source within the specified box.
;Currently the procedure defaults to returning the closest match.
;A more sophisticated check should be included in the future


;get tag names
names = [tag_names(alfacat),tag_names(sdssimaging_alfalfa),'detections','separation','match']
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
;help,outcat,/st

for j=0,nrow-1 do for i=0,ncol-1 do outcat[j].(i) = reform(strsplit(d[i,j],/extract))

END
