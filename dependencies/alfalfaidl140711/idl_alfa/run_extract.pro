;---------------------------------------------------------------------------------
;PROCEDURE run_extract
;run_extract,pos,agcdir,DATE=date,SN=sn,N1=n1,N2=n2,SKIP_CALC=skip,DIR=directory
;
;
;input: pos - the position file
;keywords:
;       DATE - the 6 digit date of the observing session
;       SN - the S/N threshold for the detections.  The program will accept 
;            anything above that value, and show you as potential detections
;            objects with S/N up to 0.5 below that.  The default value is 4.5.
;       N1 - the drift number where to start the extraction.  The default
;            value is 0.
;       N2 - the drift number where to end the extraction.  The default value
;            is (n_elements(pos)-1)
;       SKIP_CALC - set this keyword to jump over the computation part and go
;                   straight to the interactive display.
;                   0: do the computation (default)
;                   1: jump to display and append results to existing catalog
;                   2: jump to display and create a new catalog
;       DIR - the directory where the data is.  The default is:
;             /home/dorado11/galaxy/flagbb/"date"
;             (eg.:/home/dorado11/galaxy/flagbb/05.05.24/)
;example:
;IDL> run_extract,pos,DATE='050524',SN=4.5
;
; last modified, Dec.12 2005, AS
;----------------------------------------------------------------------------------

pro run_extract,pos,agcdir,DATE=date,SN=sn,N1=n1,N2=n2,SKIP_CALC=skip,DIR=directory

seed=5113
n=n_elements(pos)

if (n_elements(sn) le 0) then begin
  sn=4.5
  print,'Will use S/N limit of 4.5'
endif
if (n_elements(n1) le 0) then n1=0
if (n_elements(n2) le 0) then n2=n-1
print,'Drifts ',strtrim(string(n1),2),' through ',strtrim(string(n2),2),' will be examined.'
if (n_elements(skip) le 0) then skip=0

if (n_elements(date) gt 0) then begin
 date2=strmid(date,0,2)+'.'+strmid(date,2,2)+'.'+strmid(date,4,2)
endif

if (n_elements(directory) le 0) then directory='/home/dorado11/galaxy/flagbb/'+date2+'/'

if (skip eq 1) then goto,display

namefile='cat'+date+'.dat'
print,namefile,' will be written'
openw,lun2,namefile,/get_lun
free_lun,lun2

if (skip eq 2) then goto,display

;----------------------------------
;cleaning and preparing files
;$\rm tmp_extract/*

for i=n1,n2 do begin

   date2=strmid(date,0,2)+'.'+strmid(date,2,2)+'.'+strmid(date,4,2)
   name=directory+pos[i].name
;   name='/home/dorado11/galaxy/flagbb/'+date2+'/'+pos[i].name
   print,'Restoring ',name
   restore,name
   cont_tot=reform(mc[7,0,*,*])
 
   extract_compute,dred,cont_tot,cont_pt,pos,agcdir,SN=sn,SEED=seed,SKIP=0,POLSKIP=0,INTERACT=1
   seed=seed+1
endfor
;free_lun,lun


;Now second loop to do the analysis, now that all the computation is
;done.
display:

if (skip eq 0 or skip eq 2) then begin
 entry2={sourcesfinal, ch:0,rec:0,w:0.0,asize:0.0,sn:0.0,int_flux:0.0,peak_flux:0.0,rms:0.0,$
      diff_pol:0.0,pol_flag:0,color_pol:'',cz:0.0,agc:'',comments:'',scannumber:0L,$
      beam:0,radec:'000',sp0:fltarr(4096),sp1:fltarr(4096)}
 sources_final=replicate(entry2,1000)
endif
if (skip eq 1) then restore,'tmpsources'+date+'.sav'

for i=n1,n2 do begin
   nom='./tmp_extract/ext_'+strtrim(string(pos[i].scannumber),2)+'.sav'
   print,'Restoring ',nom
   restore,nom
   print,'Starting extract_display'
   extract_display,msm,cont_pt,sources,pos,sources_final,agcdir,SN=sn,DATE=date
   save,sources_final,file='tmpsources'+date+'.sav'
endfor

tot=0
for i=0,999 do begin
   if (sources_final[i].ch eq 0 and sources_final[i].scannumber eq 0 and sources_final[i].rec eq 0) then break
   tot=tot+1
endfor
sources_final=sources_final[0:tot]
save,sources_final,file='sources'+date+'.sav'

end  ;procedure
