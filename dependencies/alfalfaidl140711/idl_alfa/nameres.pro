;+
; NAME: 
;   NAMERES
;
; PURPOSE: 
;   Query the NED database given a given galaxy name and attempt to
;   identify major catalog entries for that galaxy.  An attempt is made
;   to find the SDSS identifier.  If one cannot be found, SDSS is
;   queried via a browser, and the user can input coordinates 
;
;
; EXPLANATION: 

;
; CALLING SEQUENCE: 
;    nameres, table, set
;
; INPUTS: 
;    table - ALFALFA table structure produced from ALFALFA procedure 
;
;
; OUTPUTS: 
;      set - Appended ALFALFA table structure with SDSS information. 
;                Automatically saved to disk for each iteration
;
; OPTIONAL INPUT KEYWORD:
;
;
;
; OPTIONAL OUTPUT: 
;
;      *Note that a ASCII text listing of the search criteria, names,
;      and SDSS information is placed in a file called sdsscross.txt
;
; OPTIONAL KEYWORD OUTPUT:
;
;            
; EXAMPLES:
;
;     nameres, table, set
;
; PROCEDURES USED:
;       WEBGET()
;
;       Best if browser is open before starting the procedure!
;
; NOTES:
;
; MODIFICATION HISTORY: 
;     Written July 2007  B. Kent
;         March 2008 - Addded comments, given to MPH for use and review
;
;----------------------------------------------------------

pro nameres, table

;restore, 'table.sav'

;Need AGC, IC, NGC, VCC, CGCG, MCG, SDSS
;Need VCC ID if possible and BT magnitude
;Need all 5 SDSS magnitudes

record={HIsrc:'',agcnr:'',other:'',hra:0.D,hdec:0L,dra:0L,ddec:0L,$
        ora:0.D,odec:0L,hsize:0.,cz:0L,czerr:0L,w:0L,Werr:0L,$
        Sspec:0.,Specerr:0.,Smap:0.,SN:0.,rms:0.,code:0L,grid:'',extra:'', $
        vcc:0L, ngc:0L, ic:0L, sdss:'', Bmag:0.0, leda:''}

nrecords=0

openw, lun, 'sdsscross.txt', /get_lun

spawn, 'mkdir xml'

for i=0, n_elements(table)-1 do begin

agc=long(table[i].agcnr)
other=strcompress(table[i].other, /remove_all)

if (table[i].code eq 1 or table[i].code eq 2) then begin

    if (agc le 12943) then begin
        searchname='UGC+'+strcompress(agc, /remove_all)
        goto, continue
    endif

    if (other eq '') then begin
        searchname='AGC+'+strcompress(agc, /remove_all)
        other='-------'
        goto, continue
    endif

    searchname='UNKNOWN'


    ;Check for NGC
    pos=strpos(other, 'N')
    if (pos[0] ne -1) then begin
        ngcnum=strmid(other, pos[0]+1)
        searchname='NGC+'+ngcnum
    endif

    ;Check for VCC
    pos=strpos(other, 'VCC')
    if (pos[0] ne -1) then begin
        vccnum=strmid(other, pos[0]+3)
        searchname='VCC+'+vccnum
    endif

    ;Check for IC
    pos=strpos(other, 'I')
    if (pos[0] ne -1) then begin
        icnum=strmid(other, pos[0]+1, 4)
        searchname='IC+'+icnum
    endif

    ;Check for CGCG
    pos=strpos(other, '-')
    if (pos[0] ne -1) then begin
        searchname='CGCG+'+strmid(other, 0,7)
    endif

    ;check for RMB
    pos=strpos(other, 'RMB')
    if (pos[0] ne -1) then begin
        searchname=other
    endif

    ;check for FGC
    pos=strpos(other, 'FGC')
    if (pos[0] ne -1) then begin
        searchname=other
    endif
    
    ;check for VPC
    pos=strpos(other, 'VPC')
    if (pos[0] ne -1) then begin
        searchname=other
    endif
    
    ;check for GR
    pos=strpos(other, 'GR')
    if (pos[0] ne -1) then begin
        searchname=other
    endif

    ;check for Markarian galaxies
    pos=strpos(other, 'MK')
    if (pos[0] ne -1) then begin
        searchname=other
    endif

    ;check for Borngen galaxies
    pos=strpos(other, 'BO')
    if (pos[0] ne -1) then begin
        searchname=other
    endif



continue:

if (searchname eq 'UNKNOWN') then begin
print, agc, '   ', string(other,format='(a8)'), '   ', searchname
endif

;Begin NED search for resolving names such that matches can be made
url='http://nedwww.ipac.caltech.edu/cgi-bin/nph-objsearch?objname='+$
     searchname+'&extend=no&out_csys=Equatorial&out_equinox=J2000.0&obj_sort=RA+or+Longitude&of=xml_names&zv_breaker=30000.0&list_limit=5&img_stamp=YES'

;XML file should be returned.  Trouble reading into IDL just use grep
;and find the info you need

vcc='---------'
ugc='---------'
ngc='---------'
ic='---------'
sdss='------------------------'



filename=table[i].hisrc


spawn, 'wget -q -O ./xml/'+ filename + ".xml '" + url + "'"   

;Check to see if any response of this type is in NED
spawn, 'grep "There is no object with this name in NED" ./xml/'+filename+'.xml', answer
    if (answer[0] ne '') then goto, finish

spawn, 'grep "The object name that you submitted is not currently recognized by the NED name interpreter" ./xml/'+filename+'.xml', answer
    if (answer[0] ne '') then goto, finish





;Check for VCC numbers
spawn, 'grep VCC ./xml/'+filename+'.xml', answer

for j=0,n_elements(answer)-1 do begin

    pos=strpos(answer[j], 'VCC')
    if (pos[0] ne -1) then begin
        endtablepos=strpos(answer[j], '</TD>')
        vcc=strmid(answer[j], pos, endtablepos-pos)
    endif

endfor

;Check for UGC numbers
spawn, 'grep UGC ./xml/'+filename+'.xml', answer

for j=0,n_elements(answer)-1 do begin

    pos=strpos(answer[j], 'UGC')
    if (pos[0] ne -1) then begin
        endtablepos=strpos(answer[j], '</TD>')
        ugc=strmid(answer[j], pos, endtablepos-pos)
    endif

endfor

;Check for NGC numbers
spawn, 'grep NGC ./xml/'+filename+'.xml', answer

for j=0,n_elements(answer)-1 do begin

    pos=strpos(answer[j], 'NGC')
    if (pos[0] ne -1) then begin
        endtablepos=strpos(answer[j], '</TD>')
        ngc=strmid(answer[j], pos, 8)
    endif

endfor


;Check for IC numbers
spawn, 'grep IC ./xml/'+filename+'.xml', answer

for j=0,n_elements(answer)-1 do begin

    pos=strpos(answer[j], 'IC')
    if (pos[0] ne -1) then begin
        endtablepos=strpos(answer[j], '</TD>')
        ic=strmid(answer[j], pos, endtablepos-pos)
    endif

endfor


;Check for SDSS numbers
spawn, 'grep SDSS ./xml/'+filename+'.xml', answer

for j=0,n_elements(answer)-1 do begin

    pos=strpos(answer[j], 'SDSS')
    if (pos[0] ne -1) then begin
        endtablepos=strpos(answer[j], '</TD>')
        sdss=strmid(answer[j], pos, endtablepos-pos)
    endif

endfor





finish:

temprecord=record

;Get VCC catalog
restore, '/home/dorado3/galaxy/idl_alfa/vcccat.sav'

;read in old info
for k=0, 21 do begin

  temprecord.(k)=table[i].(k)

endfor

;enter new information
if (vcc ne '---------') then begin
   pos=strpos(vcc, 'VCC')
   temprecord.vcc=long(strmid(vcc, pos+4))
   vccnum=long(strmid(vcc, pos+4))
   temprecord.Bmag=vcccat[vccnum-1].BT
endif

if (ngc ne '---------') then begin
   pos=strpos(ngc, 'NGC')
   temprecord.ngc=long(strmid(ngc, pos+4))
endif

if (ic ne '---------') then begin
   pos=strpos(ic, 'IC')
   temprecord.ic=long(strmid(ic, pos+3))
endif

if (sdss ne '------------------------') then begin
    pos=strpos(sdss, 'J')
    temprecord.sdss=strmid(sdss, pos)
print, table[i].agcnr+string(table[i].code)+'    '+strcompress(table[i].ora, /remove_all)+'+'+strcompress(table[i].odec, /remove_all)+string(table[i].cz, format='(i7)')+string(table[i].cz/2.99792458e5)
endif

sdssanswer=''
;Query SDSS to get it manually
if (sdss eq '------------------------') then begin

url='http://cas.sdss.org/dr7/en/tools/explore/obj.asp?ra='+$
       strcompress(hms1_hr(table[i].ora)*15.0, /remove_all)+'&dec='+$
       strcompress(dms1_deg(table[i].odec), /remove_all)

spawn, '/usr/bin/firefox -remote "openurl('+url+')"', answer

read, sdssanswer, prompt=table[i].agcnr+string(table[i].code)+'    '+strcompress(table[i].ora, /remove_all)+'+'+strcompress(table[i].odec, /remove_all)+string(table[i].cz, format='(i7)')+string(table[i].cz/2.99792458e5)+'  SDSS: '

pos=strpos(sdssanswer, 'J')
temprecord.sdss=strmid(sdssanswer, pos)
sdss=sdssanswer
if (sdssanswer eq '') then sdss='------------------------'


endif



nrecords++ 

if (nrecords eq 1) then begin
    set=temprecord
  endif else begin
    set=[set,temprecord]
endelse




outputstring=  table[i].hisrc+'   '+$
        string(agc, format='(i6)')+'   '+$
               string(other,format='(a8)')+'   '+$
               string(searchname, format='(a12)')+'         '+ $
               string(vcc, format='(a9)')+'  '+$
               string(ngc, format='(a9)')+'  '+$
               sdss+'  '+$
               strcompress(temprecord.Bmag, /remove_all)+'   '+$
               strcompress(hms1_hr(table[i].ora)*15.0, /remove_all)+'   '+$
               strcompress(dms1_deg(table[i].odec), /remove_all)
                 
  

printf, lun, outputstring

endif       ; only 1's and 2's

;Save as you go...
save, set, filename='set.sav'

endfor

;spawn, 'grep CGCG /home/astrosun/bkent/voidl/VOlib_0.2/pro/nph-objsearch.xml', answer
;help, answer

close, lun
free_lun, lun


end
