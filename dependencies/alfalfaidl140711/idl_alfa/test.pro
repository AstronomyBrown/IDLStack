pro test,ncalib,calmask,cmask=cmask

nchn=4096
if (n_elements(cmask) eq 0) then begin	; i.e., unless calmask is entered to override ncalib
  calmask=intarr(nchn)
  cregions=reform(ncalib.cregions[0,0,*])	; NOTE: we are assuming mask the same for all brds
  for nnr=0,19 do begin
    nnnr=nnr*2
    if (cregions[nnnr] eq 0) then goto,enough_cregion
    calmask[cregions[nnnr]:cregions[nnnr+1]]=1
  endfor
  enough_cregion:
;  calmask[800:1600] = 1
;  calmask[2000:2800]= 1
;  calmask[3150:3400]= 1
endif

end
