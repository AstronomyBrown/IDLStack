;
; NAME: 
;   SLOANFETCH
;
; PURPOSE: 
;   Simple procedure to obtain the SDSS objectid and query the
;   database.  Typically returns the result to wrapper procedure CHECKSLOAN.PRO
;
;
; EXPLANATION: 

;
; CALLING SEQUENCE: 
;    sloanfetch, rahr, decdeg, agcnr, sdssresult
;
; INPUTS: 
;    rahr - right ascension (J2000) in decimal hours
;  decdeg - declination (J2000) in decimal degrees
;
;
; OUTPUTS: 
;      sdssresult - IDL structure of Sloan results (work in progress!)
;
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
;     sloanfetch, 12.5, 12.5, 123456, sdssresult
;
; PROCEDURES USED:
;       WEBGET()
;       
;       
;
; NOTES:
;
; MODIFICATION HISTORY: 
;     Written July 2007  B. Kent
;         March 2008 - Addded comments, given to MPH for use and review
;
;----------------------------------------------------------

pro sloanfetch, rahr, decdeg, agcnr, sdssresult

radeg=double(rahr)*15.0D
decdeg=double(decdeg)

;print, radeg, decdeg

;rastring=strmid(rastring, 0,2)+':'+strmid(rastring,2,2)+':'+strmid(rastring,4,5)
;decstring=strmid(decstring, 0,3)+':'+strmid(decstring,3,2)+':'+strmid(decstring,5,4)

url='http://cas.sdss.org/dr7/en/tools/explore/OETOC.asp?ra='+strcompress(string(double(radeg),format='(f15.10)'))+$
      '&dec='+strcompress(string(double(decdeg), format='(f15.10)'))

;print, url

filename='OETOC'

spawn, 'wget -q -O ~/'+ filename + ".html '" + url + "'"   

spawn, 'grep loadSummary ~/'+filename+'.html', answer

spawn, '/bin/rm -r ~/OETOC.html'

;use element number 1

pos=strpos(answer[1], "('")

if (pos[0] ne -1) then begin

    amppos=strpos(answer[1], '&amp;')
    hexcode1=strmid(answer[1], pos[0]+2, amppos[0]-pos[0]-2)

    specpos=strpos(answer[1], 'spec=')
    endpos=strpos(answer[1], "')")
    hexcode2=strmid(answer[1],specpos+5, endpos-specpos-5)

    ;Now get the summary.asp page for this object and retreive the ObjId

    url='http://cas.sdss.org/dr7/en/tools/explore/summary.asp?id='+$
         hexcode1+'&spec='+hexcode2

   ; print, url

    ;print, hexcode1, '   ', hexcode2

    filename='summary'
    spawn, 'wget -q -O ~/'+ filename + ".asp '" + url + "'"   

    spawn, 'grep "ObjId =" ~/'+filename +'.asp', answer

    spawn, '/bin/rm -r ~/summary.asp'

    ;help, answer[0]

    if (answer[0] ne '') then begin

        objidpos=strpos(answer[0], 'ObjId =')
        endpos=strpos(answer[0], '</h3>')
        objid=strmid(answer[0], objidpos+8, endpos-objidpos-9)     
    endif 
endif

;The SDSS objid identifier is now stored in the string objid

spawn, '/home/dorado3/galaxy/idl_alfa/sqlcl.py -q "SELECT p.objID,p.ra,p.dec,p.SpecObjID,p.type, '+$
'p.deVMag_u, p.deVMag_g,p.deVMag_r,p.deVMag_i,p.deVMag_z,'+$
'p.deVMagErr_u, p.deVMagErr_g, p.deVMagErr_r, p.deVMagErr_i, p.deVMagErr_z,'+$  

'p.expMag_u, p.expMag_g, p.expMag_r, p.expMag_i, p.expMag_z,'+$ 
'p.expMagErr_u, p.expMagErr_g, p.expMagErr_r, p.expMagErr_i, p.expMagErr_z,'+$ 

'p.modelMag_u, p.modelMag_g, p.modelMag_r, p.modelMag_i, p.modelMag_z, '+$
'p.modelMagErr_u, p.modelMagErr_g, p.modelMagErr_r, p.modelMagErr_i, p.modelMagErr_z, '+$

'p.petroMag_u, p.petroMag_g, p.petroMag_r, p.petroMag_i, p.petroMag_z, '+$
'p.petroMagErr_u, p.petroMagErr_g, p.petroMagErr_r, p.petroMagErr_i, p.petroMagErr_z, '+$

'p.dered_u, p.dered_g, p.dered_r, p.dered_i, p.dered_z '+$

' FROM PhotoObjAll p WHERE p.objID='+objid+'" -f csv > ~/temp1138.csv', answer

;Read in the result

restore, '/home/dorado3/galaxy/idl_alfa/sdsstemplate.sav'

sdssresult=read_ascii('~/temp1138.csv', template=sdsstemplate)

spawn, '/bin/rm -r ~/temp1138.csv'

;spawn, 'emacs ~/temp1138.csv &'



end
