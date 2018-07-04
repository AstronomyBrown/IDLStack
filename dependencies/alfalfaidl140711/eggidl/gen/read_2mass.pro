PRO READ_2MASS, INFILE, OUTCAT

;+
;NAME:
;       READ_2MASS
;
;PURPOSE:
;       To take a textfile that is output from a multi-object
;       retrieval from the 2MASS GATOR query service and read it into
;       an IDL structure.
;
;SYNTAX:
;       READ_2MASS, '2mass.txt', outcat
;
;INPUTS:
;       infile - the full name of an input text file containing the
;                results of a multi-object query of 2MASS
;
;OUTPUTS:
;       outcat - the name of the output structure the 2MASS results
;                will be read into.  
;
;EXAMPLE:
;       read_2mass,'/home/humacao/humacao1/betsey/twomass_sources.txt',twomasscat
;
;NOTES:
;       This is designed to get the result of a 2MASS query into a
;       format that can be manipulated within IDL.  This is a step in
;       the process of matching ALFALFA objects with 2MASS detections.
;
;       IMPORTANT! This presumes you have done a global replace of all
;       'null' values with ' -99' (or a similarly valued placeholder
;       with four spaces) for formatting reasons
;
;REVISION HISTORY:
;       Written B. Adams  July 2007
;       Revised B. Adams  August 2007 to allow variance in number of columns
;
;-


;Check the syntax

if n_params() lt 2 then begin
  print, 'syntax: read_2mass,infile,outcat'
  print, '        Reads 2mass text file <infile> into a structure <outcat>'
  return
endif

;print a warning about null values

print, 'Warning: Make sure that <null> values have been replaced by < -99> or a similar place holder for formatting reasons.'

;Check for the number of lines in the input catalog.
;This will be used to initially populate a structure.
;Note that here we will knowingly overpopulate the structure since we
;are counting header lines and will need to trim it later.

;Call wc to count the number of lines.  

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

lines = strarr(lct)

openr,iou,infile,/get_lun
readf,iou,lines

dummy = ''
if not eof(iou) then begin
  readf,iou,dummy
  lines=[lines,dummy]
endif

close,iou
free_lun,iou

;Throw out the notes and general information
j = where(strmid(lines,0,1) ne '\')
lines = lines[j]

;Find the header
k=where(strmid(lines,0,1) eq '|')
header=lines[k]
remove,k,lines

;Find the column names and number of columns
l=strlen(header[0])
hline = header[0]

coln = strsplit(hline,'|',/extract)
coln = strcompress(coln,/remove_all)
ncol = n_elements(coln)

;Find number of rows
nrow = n_elements(lines)

;Split the data up and read it into a string array
d=strarr(ncol,nrow)
for i=0l,nrow-1 do d[*,i] = strsplit(lines[i],' ',/extract)


;Create the structure

;check for column names that do not correspond to floating numbers

s = where(coln eq 'objname_u' OR coln eq 'cys_u' OR coln eq 'equinox_u' OR coln eq 'designation' OR coln eq 'cc_flg')
l = where(coln eq 'cntr_u' OR strpos(coln,'flg') ge 0 OR strpos(coln,'phi') ge 0)

j = where(s eq 0,stct)
k=where(l eq 0, lct)
if (stct gt 0) then cvalue ='' else if (lct gt 0) then cvalue=0L else cvalue=0.

outcat = create_struct(coln[0],cvalue)

for i=1,ncol-1 do begin
    j = where(s eq i, stct)
    k = where(l eq i, lct)
    if (stct gt 0) then cvalue='' else if (lct gt 0) then cvalue=0L else cvalue=0.
    outcat=create_struct(outcat,coln[i],cvalue)
endfor

outcat=replicate(outcat,nrow)

;Read the data into the structure

for i=0,ncol-1 do outcat.(i) = reform(d[i,*])

;;Open the input text file
;openr, lun, infile, /get_lun
;
;;Define the structure and create the array that is to be read into.
;;This will be ugly because there are a lot of columns
;
;fmt='(I12,10x,F10.6,9x,F11.6,7x,A17,10x,F10.6,10x,F10.6,6x,A3,8x,A5,2x,A16,2x,F9.6,2x,F9.6,3x,F5.1,4x,F6.3,8x,F5.3,9x,I3.3,4x,F6.3,8x,F5.3,9x,I3.3,4x,F6.3,8x,F5.3,9x,I3,x,f5.3,2x,I4,2x,F5.3,4x,I4,2x,F6.2,2x,F6.3,6x,F5.3,2x,F6.3,6x,F5.3,2x,F6.3,6x,F5.3,4x,A3)'
;
;;Keep the same column names as 2MASS
;
;entry={cntr_u:0L, dist_x:0.0, pang_x:0.0, objname_u:'', ra_u:0L, dec_u:0L, cys_u:'', equinox_u:'',$
;       designation: '', ra:0.0, dec:0.0, r_k20fe:0.0, j_m_k20fe:0.0, j_msig_k20fe:0.0, j_flg_k20fe:0L,$
;       h_m_k20fe:0.0, h_msig_k20fe:0.0, h_flg_k20fe:0L, k_m_k20fe:0.0, k_msig_k20fe:0.0, k_flg_k20fe:0L,$
;       k_ba:0.0, k_phi:0L, sup_ba:0.0, sup_phi:0L, r_ext:0.0, j_m_ext:0.0, j_msig_ext:0.0, h_m_ext:0.0,$
;       h_msig_ext:0.0, k_m_ext:0.0, k_msig_ext:0.0, cc_flg:''}
;
;outcat=replicate(entry,lct)
;
;;Keep track of the count so that the structure can be trimmed at the
;;end
;n = 0L
;
;;Read catalog until end-of-file is reached.
;;If entry is not properly formatted go to error message and don't read
;;that line into the structure.
;
;
;
;
;while(eof(lun) ne 1) do begin
;  on_ioerror, bad_rec
;  error=1
;  readf,lun,entry,format=fmt
;  error=0
;
;  outcat[n] = entry
;
;  n = n + 1L
;
;  
;;Check to see if it is a header line.  If not, print a message warning
;;that the 'null' values need to be replaced with a number string of
;;the same length  
;  bad_rec:
;  if (error eq 1) then begin
;;      print, !error_state.msg
;;      readf,lun,line
;;      print, line
;;      if (strmid(line,0,1) ne '\') AND (strmid(line,0,1) ne '|') then print, 'Replace null values in file with a placeholder number.'
;      if (n gt 19) then print, 'Replace null values in file with a place holder.'
;  endif
;
;endwhile
;
;;Truncate catalog to get rid of empty entries at the end.
;
;outcat=outcat[0:(n-1)]
;
;free_lun,lun

END
