;+
;NAME:
;waslist - list contents of a was data file
;
;SYNTAX: waslist,lun,recperpage
;
;ARGS:
;      desc: {wasdesc}  was descriptor returned by wasopen
;recperpage:    lines per page before wait for response. def:30
;
;DESCRIPTION:
;   List the hdr contents of a fits data file. A single line summary is 
;printed for each scan found in the file. The routine will print 30 lines 
;at a time before prompting the user to continue. This can be changed with 
;the recperpage keyword.
;
;   The listing contains:
;
;    SOURCE      SCAN     RA       DEC   C GRPS NIF NLAG    PatNm TopFrq RCV
;
;Where :
; label :  fits keyword
; SOURCE:  OBJECT
;     RA:  CRVAL2
;    DEC:  CRVAL3
;      C:   ?       coordinate system for ra,dec. not yet implemented
;   GRPS:   OBS_NUM number of integrations in scan. Use last obs_num of scan 
;                   and switch to make it 1 based.
;    NIF:   NIFS    number of IFs this integration 1,2, 4 for stokes.
;   NLAG:   LAGS_IN number of channels in spectrum.
;  PatNm:   PATTERN_NAME name of dataking pattern used to take the data.
; TopFrq:   CRVAL1  topocentric frequency at reference pixel (Mhz). 
;    Rcv:   RFNUM   id number for reciever (lbw is 5).
;
;NOTE:
;   Listing the file does not change the position of where the next read will
;occur in the file.
;-
;modhistory:
;14nov03 - stole from corlist
;06dec03 - output 1 line per scan,not every rec.
;11nov04 - fix rfnum for alfa.
;29jan05 - <pjp001> radec, were being printed out incorrectly
;02feb05 - <pjp004> changes for fitsVersion .92
;
pro waslist,desc,recperlist
;
; list the contents of the file
;12345678901234567890123456789012345678901234567890123456789012345678901234567890
;    SOURCE      SCAN     RA       DEC   C GRPS NIF NLAG    PatNm TopFrq RCV 
;aaaaaaaaaaaaxdddddddddxhhmmss.sxmddmmssxaxddddxdddxddddxaaaaaaaaxffff.fxdd 
;
;on_error,1
    on_ioerror,done
    lineToOutput=0
    if (n_elements(recperlist) eq 0) then linemax=30L else linemax=recperlist
;   if (n_elements(scan) ne 0) then begin
;       ind=where(desc.scanI.scan eq scan,count)
;       if count eq 0 then message,"scan not found"
;       desc.curpos=desc.scanI[ind].startind
;   endif
;   h=fxbheader(desc.lun)
;
;   
    linecnt=0L
    errmsg=''
    fxbread,desc.lun,scanInp,desc.colI.scan,errmsg=errmsg
    if errmsg ne '' then goto,done
    ntot=n_elements(scanInp)
    if ntot eq 0 then return
;
;    find then indices where the scans change.
;
    dif=scanInp-shift(scanInp,1)
    ind=where(dif ne 0,count)
    if count eq 0 then  begin       ; 1 scan ,wrap around gives 0
        ind=[0]
        count=1
    endif
    scanInp=scanInp[ind]
    fxbread,desc.lun,grpTmp,desc.colI.grp,errmsg=errmsg
    if count eq 1 then begin
        grp=grpTmp[ntot-1] - grpTmp[0] + 1l
    endif else begin
        grpEnd=[grpTmp[ind[1:*]-1],grpTmp[ntot-1]] 
        grpSt =grpTmp[ind[*]]
        grp= grpEnd-grpSt + 1 
    endelse
    fxbread,desc.lun,src,'OBJECT',errmsg=errmsg
    src=src[ind]
	; <pjp004> below
    fxbread,desc.lun,crval2,desc.colI.crval2,errmsg=errmsg
    ra =crval2[ind]
    fxbread,desc.lun,crval3,desc.colI.crval3,errmsg=errmsg
    dec=crval3[ind]
    crd=strarr(n_elements(dec)) + '?'               ; no coord system yet..
    fxbread,desc.lun,patName,desc.colI.patnam,errmsg=errmsg
    patName=patName[ind]
    fxbread,desc.lun,rfnum,'RFNUM',errmsg=errmsg
    fxbread,desc.lun,frontend,'FRONTEND',errmsg=errmsg
    rfNum=rfNum[ind]
    rfNum=rfNum[ind]
	iuseAlfa=where(frontend[ind] eq 'alfa',count)
	if count gt 0 then rfnum[iuseAlfa]=17
    fxbread,desc.lun,nlags,'LAGS_IN',errmsg=errmsg
    nlags=nlags[ind]
    fxbread,desc.lun,freqRP,'CRVAL1',errmsg=errmsg
    freqRp=freqRp[ind]
    freqRP= freqRP*1e-6
    fxbread,desc.lun,nifs,'NIFS',errmsg=errmsg
    nifs=nifs[ind]
;   print,irow,errmsg
;
    linecnt=0
    for i=0,n_elements(ind)-1 do begin
     if (linecnt ge linemax) then begin
        ans=' '
        read,"Enter return to continue, q to quit",ans
        if (ans eq 'q') then goto,done
        linecnt=0
     endif
     if (linecnt eq 0 ) then begin
print,"    SOURCE      SCAN     RA       DEC   C GRPS NIF NLAG    PatNm TopFrq RCV"
;                         crval2  crval3
;    SOURCE      SCAN     RA       DEC   C GRPS NIF NLAG    PatNm TopFrq RCV 
;aaaaaaaaaaaaxdddddddddxhhmmss.sxmddmmssxaxddddxdddxddddxaaaaaaaaxffff.fxdd 
;   a12           i9     f8.1     i7      a1 i4  i3   i4  a8       f6.1   i2
;
     endif
; <pjp002>
	 ll=fisecmidhms3(ra[i]/360D*86400.,h,m,s,/float) ; to time secs
	 rahms=h*10000L+m*100L +s
	 ll=fisecmidhms3(dec[i]*3600D,d,m,s,/float)       ; to arc secs
	 decdms=d*10000L+m*100L +s

     print,format=$
 '(a12," ",i9," ",f8.1," ",i7," ",a1," ",i4," ",i3," ",i4," ",a8," ",f6.1,i3)',$
 src[i],scanInp[i],rahms,long(decdms),crd[i],grp[i],nifs[i],nlags[i],$
		patName[i],freqRP[i],rfnum[i]
            
        linecnt=linecnt+1
    endfor
done:
return
end
