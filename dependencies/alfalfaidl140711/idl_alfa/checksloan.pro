;+
; NAME: 
;   CHECKSLOAN
;
; PURPOSE: 
;   Simple wrapper procedure appends the ALFALFA/SDSS table structure
;    from the NAMERES.PRO procedure.  
;
;
; EXPLANATION: 

;
; CALLING SEQUENCE: 
;    checksloan, set
;
; INPUTS: 
;    set - Appended ALFALFA table structure from NAMERES.PRO
;
;
; OUTPUTS: 
;      sloantable - Appended ALFALFA table structure with SDSS information,
;            magnitudes, errors, and ID's.  Automatically saved to disk
;
; OPTIONAL INPUT KEYWORD:
;
;
;
; OPTIONAL OUTPUT: 
;

;
; OPTIONAL KEYWORD OUTPUT:
;
;            
; EXAMPLES:
;
;     checksloan, set
;
; PROCEDURES USED:
;       WEBGET()
;       SLOANFETCH.PRO
;       
;
; NOTES:
;
; MODIFICATION HISTORY: 
;     Written July 2007  B. Kent
;         March 2008 - Addded comments, given to MPH for use and review
;
;----------------------------------------------------------


pro checksloan, set

record={HIsrc:'',agcnr:'',other:'',hra:0.D,hdec:0L,dra:0L,ddec:0L,$
        ora:0.D,odec:0L,hsize:0.,cz:0L,czerr:0L,w:0L,Werr:0L,$
        Sspec:0.,Specerr:0.,Smap:0.,SN:0.,rms:0.,code:0L,grid:'',extra:'', $
        vcc:0L, ngc:0L, ic:0L, sdss:'', Bmag:0.0, leda:'',$
        objID:'',ra:0.0D,dec:0.0D,SpecObjID:'',type:0L,$
        deVMag_u:0.0D,deVMag_g:0.0D,deVMag_r:0.0D,deVMag_i:0.0D,deVMag_z:0.0D,$
          deVMagErr_u:0.0D,deVMagErr_g:0.0D,deVMagErr_r:0.0D,deVMagErr_i:0.0D,deVMagErr_z:0.0D,$
        expMag_u:0.0D,expMag_g:0.0D,expMag_r:0.0D,expMag_i:0.0D,expMag_z:0.0D,$
          expMagErr_u:0.0D,expMagErr_g:0.0D,expMagErr_r:0.0D,expMagErr_i:0.0D,expMagErr_z:0.0D,$
        modelMag_u:0.0D,modelMag_g:0.0D,modelMag_r:0.0D,modelMag_i:0.0D,modelMag_z:0.0D,$
          modelMagErr_u:0.0D,modelMagErr_g:0.0D,modelMagErr_r:0.0D,modelMagErr_i:0.0D,modelMagErr_z:0.0D,$
        petroMag_u:0.0D,petroMag_g:0.0D,petroMag_r:0.0D,petroMag_i:0.0D,petroMag_z:0.0D,$
          petroMagErr_u:0.0D,petroMagErr_g:0.0D,petroMagErr_r:0.0D,petroMagErr_i:0.0D,petroMagErr_z:0.0D,$
        dered_u:0.0D,dered_g:0.0D,dered_r:0.0D,dered_i:0.0D,dered_z:0.0D}

;restore, 'set.sav'
;restore, 'sloanfix.sav'


nrecords=0

for i=0,n_elements(set)-1 do begin

temprecord=record


rastring=strmid(set[i].sdss, 1,9)
decstring=strmid(set[i].sdss,10)



sloanfetch, hms1_hr(double(rastring)), dms1_deg(double(decstring)), set[i].agcnr, sdssresult



if (tag_exist(sdssresult, 'FIELD01')) then begin

   if (sdssresult.field05 ne 3) then begin
       print,i, '  '+set[i].sdss+'        Type: '+string(sdssresult.field05)+$
         '     '+sdssresult.field01+string(15.0*hms1_hr(double(rastring)))+'   '+string(dms1_deg(double(decstring)))+'   PROBLEM!'
   endif else begin

       print,i, '  '+set[i].sdss+'        Type: '+string(sdssresult.field05)+$
         '     '+sdssresult.field01+string(15.0*hms1_hr(double(rastring)))+'   '+string(dms1_deg(double(decstring)))
   endelse


endif else begin

print, ''
print, 'PROBLEM with: '+string(i)+'   '+set[i].agcnr+'  '+set[i].sdss
print, ''

endelse

;Get number of tags
rows=N_struct(set, ntags)

;Fill in first part of the table
for j=0,ntags-1 do begin
   temprecord.(j)=set[i].(j)
endfor

;Fill in sloan part

for j=0,49 do begin
   temprecord.(j+ntags)=sdssresult.(j)
endfor


nrecords++ 

if (nrecords eq 1) then begin
    sloantable=temprecord
  endif else begin
    sloantable=[sloantable,temprecord]
endelse


save, sloantable, filename='sloantable.sav'

endfor


end
