;+
; NAME:
;      combineAGC
; PURPOSE:
;       Simple routine to read Arecibo General Catalog into IDL structure
;
; EXPLANATION:
;
;     Opens AGC north and south catalogs, creates a structure entry
;     for each object.   Three files are saved for the north, south,
;     and combined AGC
;
;
; CALLING SEQUENCE:
;       combineagc
;
; INPUTS:
;       none - opens agc files from esperanza
;
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;   
;          
;
; OUTPUTS:
;       none
;
;
; RESTRICTIONS:
;
;        
;
; EXAMPLE:
;
;       Pretty straight forward:  combineagc
;
; PROCEDURES USED:
;        None.
;         
;
;
;
; MODIFICATION HISTORY:
;       WRITTEN, Brian Kent, Cornell U., June, 2004
;       Dec. 2004, B. Kent - Modified to save for use in agcbrowse
;       Nov. 2005, B. Kent - Modified to save three files
;       Jan. 2005, B. Kent - documentation updated - MPH now using.
;       Nov 2006,  MPH updates to read dorado disks, not esperanza's
;       May 2010,  MPH updates to make a 4th file which includes
;                  the galaxies -1 deg < DecJ < 0.
;
;----------------------------------------------------------


pro combineagc

restore, '/home/dorado3/galaxy/idl_alfa/agctemplate.sav'

agcnorth=read_ascii('/home/dorado3/galaxy/esp3/cats/agc2000.north', template=agctemplate)
agcsouth=read_ascii('/home/dorado3/galaxy/esp3/cats/agc2000.south', template=agctemplate)
agcnorthminus1=read_ascii('/home/dorado3/galaxy/esp3/cats/agc2000.northminus1', template=agctemplate)

records=n_elements(agcnorth.(0))+n_elements(agcsouth.(0))

agctotal={$
AGCNUMBER:lonarr(records),$
WHICH:strarr(records),$
RAH:intarr(records),$
RAM:intarr(records),$
RAS10:intarr(records),$
SIGN:strarr(records),$
DECD:intarr(records),$
DECM:intarr(records),$
DECS:intarr(records),$
A100:lonarr(records),$
B100:lonarr(records),$
MAG10:lonarr(records),$
INCCODE:lonarr(records),$
POSANG:lonarr(records),$
DESCRIPTION:strarr(records),$
BSTEINTYPE:lonarr(records),$
VOPT:lonarr(records),$
VERR:lonarr(records),$
EXTRC3:lonarr(records),$
EXTDIRBE:lonarr(records),$
VSOURCE:lonarr(records),$
NGCIC:strarr(records),$
FLUX100:lonarr(records),$
RMS100:lonarr(records),$
V21:lonarr(records),$
WIDTH:lonarr(records),$
WIDTHERR:lonarr(records),$
WIDTHCODE:strarr(records),$
TELCODE:strarr(records),$
DETCODE:lonarr(records),$
HISOURCE:intarr(records),$
STATUSCODE:intarr(records),$
SNRATIO:intarr(records),$
IBANDQUAL:intarr(records),$
IBANDSRC:intarr(records),$
IRASFLAG:intarr(records),$
ICLUSTER:intarr(records),$
HIDATA:intarr(records),$
IPOSITION:intarr(records),$
IPALOMAR:intarr(records),$
RC3FLAG:intarr(records),$
IROTCAT:intarr(records),$
NEWSTUFF:intarr(records)}

for i=0, 42 do agctotal.(i)=[agcnorth.(i),agcsouth.(i)]

   save, agctotal, filename='agctotal.sav'
   save, agcsouth, filename='agcsouth.sav'
   save, agcnorth, filename='agcnorth.sav'
   save, agcnorthminus1, filename='agcnorthminus1.sav'

print, 'AGC North: '+strcompress(n_elements(agcnorth.(0)), /remove_all)+ ' entries.'
print, 'AGC South: '+strcompress(n_elements(agcsouth.(0)), /remove_all)+ ' entries.'
print, 'AGC North-1: '+strcompress(n_elements(agcnorthminus1.(0)), /remove_all)+ ' entries.'
print, 'AGC Total: '+strcompress(n_elements(agcnorth.(0))+n_elements(agcsouth.(0)), /remove_all)+ ' entries.'

delvarx, agcnorth, agcsouth, agcnorthminus1,agctotal


end
