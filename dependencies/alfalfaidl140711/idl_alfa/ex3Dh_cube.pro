pro ex3Dh_cube,name,SN=snth,DIR=direc

;check input
if (n_elements(snth) eq 0) then begin
   print,'You must specify a S/N threshold'
   goto,ending
endif
if (n_elements(direc) eq 0) then direc='./'

for i=0,3 do begin
   if (i eq 0) then czbin='a'
   if (i eq 1) then czbin='b'
   if (i eq 2) then czbin='c'
   if (i eq 3) then czbin='d'
   if (i eq 0) then ghi='yes'
   if (i eq 1) then ghi='no'
   if (i eq 2) then ghi='no'
   if (i eq 3) then ghi='no'
   print,'Working on redshift range ',strtrim(czbin,2)
   restore,strtrim(direc,2)+'gridbf_'+name+czbin+'.sav'
   ex3Dh_c,grid,sources,res,SN=snth,GALHI=ghi
   print,'Now saving the parameters of the detections'
   save,sources,res,filename='cdh_'+name+czbin+'.sav'
endfor

ending:
end
