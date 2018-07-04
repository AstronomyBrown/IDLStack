PRO MATCH_SDSS, ALFAFILE, SDSSFILE, OUTCAT

;+
;
;NAME:
;       MATCH_SDSS
;
;PURPOSE:
;       To take an output CSV file from a SDSS coordinate match and
;       create an output structure with matched information between
;       ALFALFA detections and SDSS sources.
;
;SYNTAX:
;       match_sdss, alfafile, sdssfile, outcat
;
;INPUTS:
;       alfafile - the full path name for an ALFALFA catalog
;
;       sdss file - the full pathname for a CSV SDSS file produced by
;                   matching to ALFALFA coordinates
;
;OUTPUTS:
;       outcat - the output structure containing information from both
;                ALFALFA and SDSS on sources
;
;EXAMPLE:
;       match_sdss,'CR1_catalog.dat','result-1.csv',sdss_alfacat
;
;NOTES:
;
;REVISION HISTORY:
;       Written B. Adams August 2007
;
;-


;Check the syntax:
if n_params() lt 3 then begin
  print, 'syntax: match_sdss,<alfafile>,<sdssfile>,outcat'
  print, '        Creates a structure, outcat, of matched ALFALFA'
  print, '        and SDSS sources'
  return
endif


;Read the input files into structures
read_alfalfacat,alfafile,alfacat
read_csv_sdss,sdssfile,sdsscat

;Pull out HI ALFALFA coordinates for matching purposes  
inra = alfacat.hi_ra
indec = alfacat.hi_dec
rah=strmid(inra,0,2)
ram=strmid(inra,2,2)
ras=strmid(inra,4,4)
decd=strmid(indec,0,3)
decm=strmid(indec,3,2)
decs=strmid(indec,5,2)
ra = ( float(rah) + float(ram) / 60 + float(ras) / 3600 ) * 15
dec = float(decd) + float(decm) / 60 + float(decs) / 3600


;Figure out some sizes of arrays and create a dummy array to hold the
;values from SDSS of interest
nrows = n_elements(alfacat)
ncols = n_tags(sdsscat) + n_tags(alfacat) + 2
ind_sdss = ncols - n_tags(sdsscat) - 2
detections=intarr(nrows)
separation = fltarr(nrows)


d=strarr(ncols,nrows)

for i=0,nrows-1 do begin
  j=where(alfacat[i].object eq sdsscat.name, ct)
  detections[i] = ct
  d[ncols-2,i] = detections[i]
  for k=0,(ind_sdss-1) do d[k,i] = alfacat[i].(k)
  if (ct eq 0) then for k=ind_sdss,ncols-3 do d[k,i]='-99'
  if (ct gt 0) then begin
      dist_sdss = 3600 * sqrt( (ra[i] - sdsscat[j].ra)^2 + (dec[i] - sdsscat[j].dec)^2 )
      separation[i] = dist_sdss[0]
      if (ct eq 1) then begin
          for k=ind_sdss,ncols-3 do d[k,i] = sdsscat[j].(k-ind_sdss)
      endif
      if (ct gt 1) then begin
          closest = min(dist_sdss,loc)
          separation[i] = dist_sdss[loc]
          ind = j[loc]
          for k=ind_sdss,ncols-3 do d[k,i] = sdsscat[ind].(k-ind_sdss)
      endif
      d[ncols-1,i] = separation[i]
  endif
endfor

;Move the tag names along and add in detections and separation
colnames=strarr(ncols)
alfanames=tag_names(alfacat)
sdssnames=tag_names(sdsscat)
extranames=['detections','separation']
colnames=[alfanames,sdssnames,extranames]


;Create the structure
;Check the tag names to make sure the data value types are correct

;Put all the column names into lowercase to make checking tags easier
coln=strlowcase(colnames)

st = where(coln eq 'object' OR coln eq 'altname' OR coln eq 'hi_ra' OR coln eq 'hi_dec' OR coln eq 'opt_ra' $
           OR coln eq 'opt_dec' OR coln eq 'code' OR coln eq 'grid' OR coln eq 'name')
l = where(coln eq 'agc' OR coln eq 'dra' OR coln eq 'ddec' OR coln eq 'v50' or coln eq 'verr' OR coln eq 'w50' $
          OR coln eq 'werr' OR coln eq 'objid' OR coln eq 'flags' OR coln eq 'detections')


j=where(st eq 0, stct)
k=where(l eq 0, lct)
if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue= -99LL else cvalue=-99.

outcat = create_struct(colnames[0],cvalue)

for i=1,ncols-1 do begin
    j = where(st eq i, stct)
    k = where(l eq i, lct)
    if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue=-99LL else cvalue=-99.
    outcat = create_struct(outcat,colnames[i],cvalue)
endfor


outcat=replicate(outcat,nrows)

;Read the data into the structure


for i=0,ncols-1 do outcat.(i) = reform(d[i,*])



END
