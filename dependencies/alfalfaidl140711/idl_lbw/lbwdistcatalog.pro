;NAME:
;
;	lbwdistcatalog - read LBW reduction .sav files and write data into a csv 
;	catalog file in a format readable by distance_catalog.pro
; 
;SYNTAX: lbwdistcatalog, filename=filename
;
;ARGS:
;
;OPTIONAL KEYWORDS:
;
;	filename - name that catalog file gets saved as
;
;DESCRIPTION:
;
;	Opens all the .sav files in current directory
;	Reads LBW reduction data from each .sav file
;	Writes LBW reduction data into a .csv catalog file
;
;HISTORY:
;	
;	AF	Jun14	Original version


PRO lbwdistcatalog, filename=filename

;SET DEFAULT CATALOG NAME
if n_elements(filename) eq 0 then filename='distcatalog.csv'


;WRITE CATALOG COLUMN HEADERS	
colheaders = ['RA','DEC', 'VEL'] 

;GRAB ALL .sav FILES IN CURRENT DIRECTORY
list = findfile('*.sav')

;DEFINE VARIABLES
n=n_elements(list)
ra=dblarr(n)
dec=dblarr(n)
vsys=fltarr(n)

;FOR EACH .sav FILE, EXTRACT LBW REDUCTION DATA
for i=0, n-1 do begin
	restore, list[i]
	ra[i]=lbwsrc.ra
	dec[i]=lbwsrc.dec
	vsys[i]=lbwsrc.vsys
endfor

;PUT ALL THE DATA TOGETHER IN ONE ARRAY
data = {RA: ra, Dec: dec, Vsys: vsys}

;WRITE THE .csv FILE
write_csv, filename, data, HEADER = colheaders


END
