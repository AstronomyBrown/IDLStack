PRO LIST_COORDS_2MASS,INFILE,OUTFILE,HI=HI,OPT=OPT

;+
;NAME:
;       LIST_COORDS
;
;PURPOSE:
;       Take an ALFALFA catalog and generate an outfile that is a list
;       of coordinates of sources in a format appropriate for upload
;       into the GATOR query service for 2mass.
;
;SYNTAX:
;       LIST_COORDS, 'catalog.dat', 'outfile.tbl', (/hi), (/opt)
;
;INPUTS:
;       infile - the full name of an input ALFALFA catalog, including
;               directory structure.
;
;OUTPUTS:
;       outfile - the name of the output text file containing a list
;                 of coordinates for upload into 2MASS GATOR query
;                 service.
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
;       This creates a textfile formatted for GATOR upload.  If
;       coordinate type is not specified will default to using HI
;       coordinates.
;
;       Coordinates input to GATOR must be in decimal
;       degree format. According to the website, the convention for naming
;       the input tables is:  No more than 9 characters, followed by
;       ".tbl". Use only letters, numbers or underscores ("_"). The
;       first character must be alphabetic; no numerals allowed.
;
;REVISION HISTORY:
;       Written B. Adams  July 2007
;
;-

;Check syntax
if n_params() lt 2 then begin
  print, 'syntax: list_coords,incat,outfile,(/hi),(/opt)'
  print, '        Writes a list of coordinates corresponding to objects'
  print, '        in <incat> to <outfile> in the format for GATOR'
  return
endif

;Access the ALFALFA catalog of interest
read_alfalfacat,infile,cat

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

fmt='(2x,A17,3x,F11.7,3x,F10.6,3x,A3,3x,A7,2x)'

openw,lun,outfile,/get_lun
printf,lun,'| objname           | ra          | dec        | cys | equinox |'
printf,lun,'|                   |             |            |     |         |'


;Now go through the catalog and write all the entries to the file in
;the correct format

for i=0, (n -1) do begin
  printf,lun,cat[i].object,ra[i],dec[i],'equ','j2000  ',format=fmt
endfor

close,lun
free_lun,lun

END
