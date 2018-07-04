pro sort_get_radec,ra,dec,radec
  r=sixty(ra)
  rah=fix(r[0])
  ram=fix(r[1])
  ras=fix(r[2])
  rads=round((r[2]-ras)*10)

  if (rads ge 10) then begin
    rads=0
    ras=ras+1
  endif

  rahs=strtrim(rah,2)
  rams=strtrim(ram,2)
  rass=strtrim(ras,2)
  rads=strtrim(rads,2)

  if (rah lt 10) then rahs='0'+strtrim(rah,2)
  if (ram lt 10) then rams='0'+strtrim(ram,2)
  if (ras lt 10) then rass='0'+strtrim(ras,2)
  d=sixty(dec)
  dh=fix(d[0])
  dm=fix(d[1])
  ds=round(d[2])
  dhs=strtrim(dh,2)
  dms=strtrim(dm,2)
  dss=strtrim(ds,2)
  if (dh lt 10) then dhs='0'+strtrim(dh,2)
  if (dm lt 10) then dms='0'+strtrim(dm,2)
  if (ds lt 10) then dss='0'+strtrim(ds,2)
  sign='+'
  if (dec lt 0) then sign='-'
  radec=rahs+rams+rass+rads+sign+dhs+dms+dss
end

;----=====================================================================

pro sort_cat,file,fileout,N=n

ra=dblarr(n)
dec=dblarr(n)
scan=lon64arr(n)
beam=lonarr(n)
chan=lonarr(n)
rec=lonarr(n)
w=dblarr(n)
asize=dblarr(n)
speak=dblarr(n)
flux=dblarr(n)
sn=dblarr(n)
rms=dblarr(n)
cz=lonarr(n)
agc=lonarr(n)
comm=strarr(n)

ras=99.999
decs=99.9999
scans=99999LL
beams=9L
chans=999L
recs=999L
ws=99.9
asizes=99.9
speaks=99.9
fluxs=99.9
sns=99.9
rmss=99.9
czs=999L
agcs=999999L
comms='999999999'

openr,lun,file,/get_lun
for i=0,n-1 do begin
 readf,lun,ras,decs,scans,beams,chans,recs,ws,asizes,speaks,$
    fluxs,sns,rmss,czs,agcs,comms,$
     format='(d10.6,d11.7,i11,i2,i6,i5,d8.3,d9.3,d8.3,d8.3,d8.3,d8.3,x,i6,2x,i7,3x,a)'
    ra[i]=ras
    dec[i]=decs
    scan[i]=scans
    beam[i]=beams
    chan[i]=chans
    rec[i]=recs
    w[i]=ws
    asize[i]=asizes
    speak[i]=speaks
    flux[i]=fluxs
    sn[i]=sns
    rms[i]=rmss
    cz[i]=czs
    agc[i]=agcs
    comm[i]=comms
endfor
free_lun,lun

flag=intarr(n)

sra=sort(ra)

srcnbr=1

openw,lun,fileout,/get_lun
openw,lunall,fileout+'.all',/get_lun

for ii=0,n-1 do begin
  i=sra[ii]

  if (flag[i] eq 1) then continue

  dist_ra=abs(ra[i]-ra)*15.0*cos(dec[i]*!pi/180.0)*60.0
  dist_dec=abs(dec[i]-dec)*60.0
  dist_ch=abs(chan[i]-chan)
  match=where((dist_ch lt 20) and (dist_ra lt 4.0) and (dist_dec lt 8.0))

  nm=n_elements(match)

  if (nm eq 1) then begin
    flag[i]=1
    indsn=i
    j=match
  endif

  if (nm gt 1) then begin
    flag[match]=1
    maxsn=max(sn[match],indsn)
    j=match[indsn]
  endif

  sort_get_radec,ra[j],dec[j],radec
  printf,lun,srcnbr,scan[j],beam[j],ra[j],dec[j],chan[j],rec[j],radec,round(cz[j]),$
    round(w[j]),speak[j],flux[j],sn[j],rms[j],nm,agc[j],comm[j],$
    format='(i4,x,i9,x,i1,x,d9.5,d9.5,i5,i4,x,a16,i6,i4,x,f5.1,x,f5.1,x,f6.1,f4.1,i3,x,i7,a40)'

  if (nm eq 1) then begin
   printf,lunall,srcnbr,scan[j],beam[j],ra[j],dec[j],chan[j],rec[j],radec,round(cz[j]),$
    round(w[j]),speak[j],flux[j],sn[j],rms[j],nm,agc[j],comm[j],$
    format='(i4,x,i9,x,i1,x,d9.5,d9.5,i5,i4,x,a16,i6,i4,x,f5.1,x,f5.1,x,f6.1,f4.1,i3,x,i7,a40)'
  endif

  if (nm gt 1) then begin
    for kk=0,nm-1 do begin
    k=match[kk]
   sort_get_radec,ra[k],dec[k],radec
   printf,lunall,srcnbr,scan[k],beam[k],ra[k],dec[k],chan[k],rec[k],radec,round(cz[k]),$
    round(w[k]),speak[k],flux[k],sn[k],rms[k],nm,agc[k],comm[k],$
    format='(i4,x,i9,x,i1,x,d9.5,d9.5,i5,i4,x,a16,i6,i4,x,f5.1,x,f5.1,x,f6.1,f4.1,i3,x,i7,a40)'            
    endfor
  endif

  srcnbr=srcnbr+1

endfor

  ending:

  free_lun,lun
  free_lun,lunall

end
