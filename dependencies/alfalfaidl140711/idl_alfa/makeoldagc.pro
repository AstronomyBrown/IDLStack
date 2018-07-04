;+
; NAME:
;      makeoldAGC
; PURPOSE:
;       Simple routine to read Arecibo General Catalog into IDL structure
;       This version accesses the 2004 AGC once and for all. It should never
;       be needed again!
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
;       none - opens agc files from dorado3
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
; EXAMPLE:
;
;       Pretty straight forward:  combinoldeagc
;
; PROCEDURES USED:
;        None.
;         
;
; MODIFICATION HISTORY:
;       WRITTEN, Brian Kent, Cornell U., June, 2004
;       Dec. 2004, B. Kent - Modified to save for use in agcbrowse
;       Nov. 2005, B. Kent - Modified to save three files
;       Jan. 2005, B. Kent - documentation updated - MPH now using.
;       Nov 2006,  MPH updates to read dorado disks, not esperanza's
;       Jun 2009,  MPH Modified combineagc quickly once and for all.
;
;----------------------------------------------------------


pro makeoldagc

restore, '/home/dorado3/galaxy/idl_alfa/agctemplate.sav'

agchidata=read_ascii('/home/dorado3/galaxy/esp3/cats/agcn_hidata_050416.agc', template=agctemplate)
agchidets=read_ascii('/home/dorado3/galaxy/esp3/cats/agcn_hidets_050416.agc', template=agctemplate)

records=n_elements(agchidata.(0))+n_elements(agchidets.(0))

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

for i=0, 42 do agctotal.(i)=[agchidata.(i),agchidets.(i)]

;   save, agctotal, filename='agctotal.sav'
   save, agchidets, filename='agchidets050416.sav'
   save, agchidata, filename='agchidata050416.sav'

print, 'AGC Old HI data: '+strcompress(n_elements(agchidata.(0)), /remove_all)+ ' entries.'
print, 'AGC Old HI dets only: '+strcompress(n_elements(agchidets.(0)), /remove_all)+ ' entries.'

delvarx, agchidata, agchidets


end
