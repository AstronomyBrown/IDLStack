;NAME:
;        FINDGRID
;
;PURPOSE:
;        Output a string with the location of the grid
;
;EXPLANATION:
;        Reads most up to date file of grids which have been processed and 
;        either prints, the location of the grid or 
;        "I am sorry, this grid is not yet processed"
;
;CALLING SEQUENCE:
;        find_grid,rah,ram,dec,cz
;
;INPUTS:
;        rah - right ascension hour angle in form: hh
;        ram - right ascension minute angle in form: mm
;        dec - declination degree angle in form: dd
;        cz - velocity of object. Range: (-2000 to 17900)
;    OPTIONAL INPUT:
;        gridlocation - If the grids have moved, this may need a new input.
;
;OUTPUT:
;        String containing the location of the grid if it is processed.
;        Otherwise string saying grid has not been processed.
;
;NOTES:
;        The grids are often moved around thus there is an optional keyword if
;        the location of the grid is known. Currently the grid location is set
;        to: /home/vieques2/galaxy/grids/
;        This can be modified in line 44
;
;REVISION HISTORY:
;    Created July 2009, Tess Senty
;            Sep 2009, MH adds to error message to give helpful hint
;                      Incorporates into alfinit
;
;-

PRO FINDGRID,rah,ram,dec,cz, gridlocation=gridlocation

if (n_params() ne 4) then begin
    print, 'wrong input'
    print, 'please enter: rah,ram,dec,cz'
    return
endif

if (n_elements(gridlocation) eq 0) then $
    gridlocation='/home/vieques2/galaxy/grids/'

;Converts inputs to the nearest grid center
if (dec mod 2 eq 1) then dec=dec
if (dec mod 2 eq 0) then dec=dec+1

if (rah mod 2 eq 0) then ram=ram-(ram mod 8)+4
if (rah mod 2 eq 1) then begin
    ram=ram-(ram mod 4)
    if (ram mod 8 ne 0) then ram=ram+4
endif

if ((cz ge -2000) and (cz le 3300)) then vel='a'
if ((cz gt 3300) and (cz le 7550)) then vel='b'
if ((cz gt 7550) and (cz le 12450)) then vel='c'
if ((cz gt 12450) and (cz le 17900)) then vel='d'

;Loads the file with the most up to date list of the grids that exist.
url='http://caborojo.astro.cornell.edu/alfalfalog/idldocs/gridmasterlist.txt'

print, ' '
print, 'Obtaining latest list... '
print, ' '

spawn, 'wget -q -O gridmasterlist.txt ' + "'" + url + "'"

filename='gridmasterlist.txt'

;Open list of files, searches list for the grid which contains the input RA, 
;DEC and velocity. Prints the grid or says grid does not exist.
fmt='(a2, a2, a1, a2, a15, a1, a4)'
record={RAhr:'', RAmin:'', sign:'', DEC:'', file1:'', vel:'', file2:''}
ngrids=file_lines(filename)-1
data=replicate(record, 1)
openr, lun, filename, /get_lun

junk='junk'
readf, lun, junk, format='(1a1)'

badgrids=0L
nrecords=0L

while (eof(lun) ne 1) do begin
    readf, lun, record, format=fmt 
    rahr=double(record.RAhr)
    ramin=double(record.RAmin)
    dec1=double(record.DEC)
    if ((dec1 eq dec) and (record.vel eq vel) and (rahr eq rah) and $
            (ramin eq ram)) then begin
        data[nrecords]=record
        nrecords=nrecords+1L
    endif else badgrids=badgrids+1
endwhile

free_lun, lun

grid=gridlocation+data.rahr+data.ramin+data.sign+data.dec+data.file1+data.vel+data.file2

if (badgrids eq ngrids) then $
    print, 'I am sorry, this grid is not yet processed' $
    else print, grid

END
