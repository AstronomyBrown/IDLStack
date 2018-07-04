PRO LIST_COORDS_SDSS,INCAT,OUTFILE,HI=HI,OPT=OPT

;+
;NAME:
;       LIST_COORDS_SDSS
;
;PURPOSE:
;       Take an ALFALFA catalog and generate an outfile that is a list
;       of coordinates of sources in a format appropriate for upload
;       into CAS for SDSS.
;
;SYNTAX:
;       LIST_COORDS, 'catalog.dat', 'outfile, (/hi), (/opt)
;
;INPUTS:
;       incat - the full name of an input ALFALFA catalog, including
;               directory structure.
;
;OUTPUTS:
;       outfile - the name of the output text file containing a list
;                 of coordinates for upload into CAS
;
;KEYWORDS:
;       hi - if this flag is set the coordinate list constructed will
;            be from the HI coordinates
;       opt - if this flag is set the coordinate list constructed will
;             be from the coordinates of the identified optical counterpart.
;
;EXAMPLE:
;       list_coords,'/home/humacao/humacao1/betsey/CR1_catalog.dat','list.txt',/hi
;
;NOTES:
;       This creates a textfile formatted for CAS upload.  The website
;       for DR6 is
;       http://cas.sdss.org/dr6/en/tools/crossid/upload.asp.  Note
;       that the infile size is limited to 80 KB and the output will
;       not exceed 100,000 objects.  For larger searches, the catalog
;       will need to be broken into pieces.
;
;       The information desired from SDSS includes magnitude, errors
;       and axial ratios for galaxies near ALFALFA detections.
;       
;       A good starting query is:
;       SELECT 
;          g.ra, g.dec, 
;          g.modelMag_g, g.modelMagErr_g, g.modelMag_r, g.modelMagErr_r,
;          g.petroMag_g, g.petroMagErr_g, g.petroMag_r, g.petroMagErr_r,
;          flags, isoA_g, isoB_g, expAB_g
;       FROM #x x, #upload u, Galaxy g
;       WHERE u.up_id = x.up_id and x.objID=g.objID 
;       ORDER BY x.up_id
;
;REVISION HISTORY:
;       Written B. Adams  August 2007
;
;-

;Check syntax
if n_params() lt 2 then begin
  print, 'syntax: list_coords,incat,outfile,(/hi),(/opt)'
  print, '        Writes a list of coordinates corresponding to objects'
  print, '        in <incat> to <outfile> in the format for CAS'
  return
endif

;Access the ALFALFA catalog of interest
read_alfalfacat,incat,cat

;Need to figure out which set of coordinates are using.

if keyword_set(opt) then begin
  inra = cat.opt_ra
  indec = cat.opt_dec
endif else begin
  inra = cat.hi_ra
  indec = cat.hi_dec
endelse

n=n_elements(cat)

;Need to format RA and DEC appropriately
;Need decimal degree format

rah=strmid(inra,0,2)
ram=strmid(inra,2,2)
ras=strmid(inra,4,4)

decd=strmid(indec,0,3)
decm=strmid(indec,3,2)
decs=strmid(indec,5,2)

ra = ( float(rah) + float(ram) / 60 + float(ras) / 3600 ) * 15
dec = float(decd) + float(decm) / 60 + float(decs) / 3600

;Write a file that includes object name, ra, dec, coordinate system
;Open the file and write header immediately
;set the format to be used

fmt='(A17,3x,F11.7,3x,F10.6)'

openw,lun,outfile,/get_lun
printf,lun,'name                ra             dec '


;Now go through the catalog and write all the entries to the file in
;the correct format

for i=0, (n -1) do begin
  printf,lun,cat[i].object,ra[i],dec[i],format=fmt
endfor

close,lun
free_lun,lun

END
