PRO READ_CSV_SDSS,FILE,DATA

;+
;NAME:
;       READ_CSV_SDSS
;
;PURPOSE:
;       To take a CSV file and read it into an idl structure.  Tag
;       names are pulled from the first row which is assumed to be a
;       header.
;
;SYNTAX:
;       READ_CSV, infile, data
;
;INPUTS:
;       infile - a CSV formatted file where the first line is a header
;
;OUTPUTS:
;       data - the output structure to read the CSV file into
;
;EXAMPLE:
;       read_csv, 'home/humacao/humacao1/betsey/results-1.csv', sdss
;
;NOTES:
;
;REVISION HISTORY:
;       Written B. Adams August 2007
;
;-


;Check the syntax

if n_params() lt 2 then begin
  print, 'syntax: read_csv,filename,data'
  print, 'Reads contents of <filename> into structuretre <data>'
  return
endif



;First read the entire file into a string array

;get line count
spawn, 'wc -l '+file,lct
lct = lct(0)

if strlen(lct) eq 0 then begin
    printf, 'File not found.'
    return
endif

i = strpos(lct,file)
if i ge 0 then lct = long(strmid(lct,0,i(0))) else lct = long(lct)

;create a string array and read file into it
lines = strarr(lct)

openr,iou,file,/get_lun
readf,iou,lines

dummy = ''
if not eof(iou) then begin
  readf,iou,dummy
  lines=[lines,dummy]
endif

close,iou
free_lun,iou


;Have string array lines where each line is a string that corresponds
;to a single row of the CSV table

;Separate header from data
header = lines[0]
remove,0,lines

;Find column names and number of columns
colnames = strsplit(header,',',/extract)
ncols = n_elements(colnames)

;find number of rows
nrows = n_elements(lines)

;split the data up and read into a string array
d=strarr(ncols,nrows)
for i=0L,nrows-1 do d[*,i] = strsplit(lines[i],',',/extract)

;create the structure
;check for the column names that do not correspond to floating numbers

if colnames[0] eq 'name' then cvalue ='0' else if colnames[0] eq 'objID' or colnames[0] eq 'flags' then cvalue =0LL else cvalue =0.

data = create_struct(colnames[0],cvalue)


for i=1,ncols-1 do begin
  if colnames[i] eq 'name' then cvalue='0' else if colnames[i] eq 'objID' or colnames[i] eq 'flags' then cvalue =0LL else cvalue =0.
  data = create_struct(data,colnames[i],cvalue)
endfor


data = replicate(data,nrows)

;read the data into the strucutre

for i=0,ncols-1 do data.(i) = reform(d[i,*])

;create tag names for columns

tags = tag_names(data)

END
