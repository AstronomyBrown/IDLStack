PRO READ_ALFALFACAT, INFILE, OUTCAT

;+
;NAME:
;       READ_ALFALFACAT
;PURPOSE:
;       To take a catalog in text format produced from the ALFALFA
;       pipeline and read it into an idl structure.  This is to allow
;       easy manipulation of observables and cross reference to other
;       catalogs from large surveys.
;
;       This routine takes an input file, checks for the number of
;       lines and reads into a structure.  Note that this is formatted
;       to expect the standard ALFALFA catalog.  This will ignore any
;       lines commented out with a pound sign.
;
;SYNTAX:
;       READ_ALFALFACAT, 'catalog.dat', outcat
;
;INPUTS:
;       infile - the full name of an input file in ALFALFA catalog
;                format, including directory structure
;
;OUTPUTS:
;       outcat - the name of the output structure which contains all
;                the information from the input catalog.
;
;EXAMPLE:
;       read_alfalfacat,'/home/humacao/humacao1/betsey/CR1_catalog.dat',testcat
;
;NOTES:
;
;REVISION HISTORY:
;       Written B. Adams  July 2007
;
;-


;Check the syntax.

if n_params() lt 2 then begin
  print, 'syntax: read_alfalfacat,infile,outcat'
  print, '        reads ALFALFA catalog <infile> into a structure <outcat>'
  return
endif

;Check for the number of lines in the input catalog.
;This will be used to initially populate a structure.
;Call wc to count the number of lines.  The last line is only counted
;if the file ends in a newline

spawn,'wc -l '+infile,lct

;This returns a single element array.  Remove the first element to a string.

lct=lct(0)

;Check that the file was found.
;If it wasn't, print an error message.

if strlen(lct) eq 0 then begin 
  print,'File not found.'
  return
endif

;Get the size of the catalog if the file was found.

i=strpos(lct,infile)
if (i ge 0) then lct=long(strmid(lct,0,i(0))) else lct=long(lct)

;Assume the first three lines are commented out header information and
;that the catalog ends in a new line.
;Then find the size of structure.

lines = lct - 3

;Open the input catalog
openr, lun, infile, /get_lun

;Define the structure and create the array to be read into
fmt = '(A17,x,F6,x,A9,x,A8,A7,x,I3,x,I3,2x,A8,A7,2x,F5.1,x,I5.5,2x,I3.3,2x,I4.4,2x,I3.3,2x,F6.2,x,F5.2,2x,F6.2,2x,F5.1,x,F5.2,3x,A1,5x,A7)'

entry={object:'', AGC:0L,altname:'',hi_ra:'',hi_dec:'',drA:0L,dDEC:0L,opt_ra:'',opt_dec:'',$
       hsize:0.0,v50:0L,verr:0L,w50:0L,werr:0L,SintP:0.0,Serr:0.0,Sintmap:0.0,SN:0.0,rms:0.0,$
       code:'',grid:''}

outcat=replicate(entry,lines)

;Keep track of the entry in catalog, allowing for commented lines at
;beginning

nentry = -3L

;Read catalog until end-of-file is reached
;If entry is not properly formatted go to error message and don't
;include in structure.  This should take care of first three commented
;lines, hopefully

while(eof(lun) ne 1) do begin
    on_ioerror, bad_rec
    error=1
    readf,lun,entry,format=fmt
    error=0
 
    outcat[nentry] = entry

 

   bad_rec:
   if (error eq 1) then print,'Not formatted properly at ',nentry

   nentry=nentry + 1

endwhile

free_lun,lun

END
