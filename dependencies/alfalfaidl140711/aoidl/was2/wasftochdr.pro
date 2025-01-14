;+
;NAME:
;wasftochdr - convert fits hdr to cor header
;
;SYNTAX: istat=wasftochdr(desc,h,hf=hf,nrows=nrows,pol=pol,iscan=iscan)
;
;ARGS: 
;   desc:{wasdesc} was descriptor returned from wasopen()
;
;RETURNS:
;   istat: int  1 ok, 0 eof, -1 error.
;    h: {corhdr}  correlator header
;    hf:{washdr}  was hdr extension..
; nrows:   long   number of rows to advance desc.curpos if you
;                 want to update the position.
;pol[2,nbrds]:  long   codes the pol type polA=1, polB=2 for each 
;                 spectra on each board.
;iscan :   long   index into desc.scanI[] for this scans data.
;
;DESCRIPTION:
;   Read in fits header for the current group and convert it
;to a correlator header. If the file is not positioned at
;the start of a group, then move forward to the start of the
;next group.
;
;NOTE: this routine does not update the position in the file.
;You are left pointing at the input position.
;
; current data being loaded into b1.h from fits header:
; tointerimHdr      from fitsHdr
; --------------------
; STD
;h.std.hdrMarker      <pjp002>
;h.std.hdrlen           ..
;h.std.reclen           .. 
;h.std.sec.xxx          ..
;h.std.grpTotRecs    desc.scanI.nbrds 
;h.std.time          fits.crval5 convert to ast secs
;h.std.scannumber    fits.SCAN_NUMBER
;h.std.grpNum        desc.scanI.rowsInRec, curpos,
;h.std.grpCurRec     1..nbrds .. used for dop offsets
;h.std.azttd         fits.ENC_AZIMUTH
;h.std.grttd         fits.ENC_ELEVATIO
;h.std.chttd         fits.ENC_ALTEL
;h.std.posTmMs       fits.ENC_TIME
;h.std.grpTotRecs    desc.scanI.nbrds 
;h.std.grpTotRecs    desc.scanI.nbrds 
; --------------------
; COR
;h.cor.numbrdsused   desc.scanI.nbrds
;h.cor.numSbcOut     desc.scanI.nsbc
;h.cor.lagsbcout     desc.scanI.nlags
;h.cor.boardId       desc.scanI.brdNum
;h.cor.calon         desc.scanI.brdNum
;h.cor.caloff        desc.scanI.brdNum
;h.cor.lagconfig     fits.BACKENDMODE with translations..
;h.cor.bwnum         fits.BANDWID  0=100 MHZ
;h.cor.lag0pwrratio  fits.TOT_POWER 
;h.cor.attndb        desc.scanI.corattn
;
;h.cor.state.flipped fits.UPPERSB ..1 --> flipped
; --------------------
; IFLO
;h.iflo.if1.st1.rfnum     fits.rfnum
;h.iflo.if1.st1.ifnum     fits.ifnum
;h.iflo.if1.st1.hybrdIn   fits.hybrid
;h.iflo.if1.st1.lo1Hsd    ...
;h.iflo.if1.st1.lbwLinPol fits.LBWHYB
;h.iflo.if1.st1.syn1RfOn  ...
;h.iflo.if1.st1.syn2RfOn  ...
;h.iflo.if1.st1.lbFbA     ...
;h.iflo.if1.st1.lbFbB     ...
;h.iflo.if1.st1.useFiber  ...
;
;h.iflo.if1.st2.calRcvMux ...
;h.iflo.if1.st2.calType   fits.CALTYPE
;h.iflo.if1.st2.ac1PwrSw  ...
;h.iflo.if1.st2.ac2PwrSw  ...
;h.iflo.if1.st2.zmNormal  ...
;h.iflo.if1.st2.sbShClosed...
;h.iflo.if1.st2.lo2Hsd    ...
;
;h.iflo.if1.lo1           FITS.SYN1
;  IF2
;h.iflo.if2.synfreq       FITS.SYNFRQ
;h.iflo.if2.st .ifInpFreq .. not in fits header
;h.iflo.if2.st4.mixerCfrq .. FITS.MIXER 0,1,2,3 750,1250,1500,1750 MIXER CFR
; --------------------
; DOP
;h.iflo.dop.stat.copCorAllBands  ...
;h.iflo.dop.stat.velCrdSys fits.CTYPE1
;h.iflo.dop.stat.velType  ...
;
;h.iflo.dop.velObsProj    fits.velocity,fits.RESTFREQ,fits.crval1
;                 velObsProj=(1D + velocity[0]/c - (restFreq[0]/crval1[0]))*c
;                        sign of velocity in fits hdr wrong??
;
;h.iflo.dop.freqOffsets   .. force to 0,0,0,0 since bandcfr changes each brd.
;h.iflo.dop.freqBCRest    .. fits.RESTFREQ
;h.iflo.dop.velOrZ        .. fits.VELOCITY.. does not check for z.
;h.iflo.dop.factor        .. fits.crval1/fit.restFreq
; --------------------
; PNT
;h.pnt.stat.grMaster Hardcode to 1. 
;h.pnt.m.rajcumrd         .. warning time stamp not provided.
;h.pnt.m.decjcumrd           probably close to h.std.posTmMs
;h.pnt.r.azttd            .. same as in h.std.azttd...
;h.pnt.r.grttd
;h.pnt.r.chttd
;h.pnt.r.agctmstamp
;h.pnt.r.secMid           .. fit.off_time which come from pnt time stamp
;h.pnt.r.geovelproj       .. if fitsversion >= 1. fraction of c
;h.pnt.r.heliovelproj     .. if fitsversion >= 1. fraction of c
; --------------------
; PROC
;h.proc.srcname      fits.OBJECT
;h.proc.procname     fits.OBSMODE with name translation new to old
;h.proc.car
;  onoff  car[0]     cal fits.OBS_NAME with name translation new to old
;  spider car[0]     stripnum: fits.OBS_NAME translate 1,2,3,4
;
;h.proc.iar
;  onoff  iar[1]     fits.OBS_NAME onoff: 1,0 for cal
;  spider iar[1]     secsStrip: fits.exposure*fits.total_pattern
;         iar[2]     recsstrip: fits.total_pattern
;         iar[3]     stripsPattern : hardcoded to 4
;h.proc.dar
;  spider dar[1]     azoffset:fits.croff2,fits.rate_ra,fits.enc_time,
;                             fits.rate_dur,fits.crval5 and some computations
;  spider dar[2]     zaoffset:fits.croff3,fits.rate_dec,fits.enc_time,
;                             fits.rate_dur,fits.crval5 and some computations
;  spider dar[3]     rateAz  :fits.rate_ra
;  spider dar[4]     rateZa  :fits.rate_dec
; --------------------
; PROC
; -
;history
; 25jun04 - if frontend = alfa, force rfnum to be 17
; 13jul04 - check for eof by row.
; 18jul04 - added if2.. mixer
; 09aug04 - added rajcumrd decjcumrd
; 12aug04 - for spider scans with alfa include the pixel number in iar[5]
;           taken from the pattern name .
; 14aug04 - for spider scans load iar[0] with a beamwidth.Use stripLen/6.
; 20aug04 - added iscan keyword to return to user
; 26oct04 - <pjp001> version 1 of hf header
;       lst  - same for all
;    equinox - same for all boards. 2000.0    
;    crval2a - true ra pointing this beam on sky .changes for each beam     
;    crval3a - true dec pointing this beam on sky. changes each beam
;    crval2b - true az pointing this beam on sky . changes each beam
;    crval3b - true za pointing this beam on sky . changes each beam 
;    crval2c - raj ant pointing without rx offset. same for all
;    crval3c - decj ant pointing without rx offset. same for all
;    crval2g - true galactic l pointing this beam on sky. change each beam
;    crval3g - true galactic b pointing this beam on sky. change each beam
;    date_obs- observation date. same for all beams
;    bandwid - bandwidth hz. changes for each pixel(if not alfa)
;    crval1v - requested velocity (could change each spectra?) 
;    crpix1v - ref pixel for velocity          : different 
;    cunit1v - units of crval1v                : same for all
;    ctyp1v  - units for velocity coord system : same for all
;    specsys - velocity frame                  : same for all
;    croff2b - true az off to commanded map center:different 
;    croff3b - true za off to commanded map       : different
;
; 13nov04 - looks like cr1valv is m/sec. for dop computation i was 
;           using km/sec
; 13nov04 - <pjp002>
;           clean up standard header so we can write out the rms files.
;           need hdrlen,reclen, hdrmarker
; 28jan05 - <pjp003> changes for fitfiles version .9
;	      cdelt1 can now be neg if flipped. use abs().
;         crval2a went hours->secs. go back to hours here..
;         crval2c went hours->secs. go back to hours here..
;         crval5  went hours->secs. go back to hours here..
;         crval3b went za->elevation. back to za
;         ctype1,specsysv values for heliocent, geocent changed.
;         total_pattern-> totsubscan.. use colI index
;		  encTm changed to utc seconds.. back to ast millisecs
;		  off_time switched to utc.. back to ast.
;		  change name ctype1 to specsys.. as  a variable here..
; 02feb05 - <pjp004>changes for fitfiles version .92
;         0. use desc.fitsVersion instead of crval2a -1 to decide on versionHf
;			 change version -> versionHf.. just local variable
;		  1. check where crval2,3 comes from
;		  2. equinox changes meaning .92.. make same as before
;		  3. use colI for crval2a,3a now
;		  4. lst -> secs .. back to hours
;		  5. croff2,3,2b,3b.. now come from colI. 
;			 croff2 also went hours to degrees. go back..
;		  6. colI.raJ,decJ got renames to reqRaJ,reqDecJ
;		  --> NOTE hf.crval2c,3c was radians. switch back to 
;                  hr,deg. This was same as pnt.h.r.raJCumRd
;		  7. cunit1v now from desc.coli.cunit1v,
;		  8. ctype1v now comes from coli.ctype1v
;		  9. hf.crpix1v set to -1 since it was garbage and version 1.0
;			 has deleted it.
;		 10. include heliocentric, geocentric if fitsVers >= 1.
;
;-
function wasftochdr,desc,h,hf=hf,nrows=nrows,pol=pol,iscan=iscan
;
;   map the curpos row ptr (0 based) in the scan, grp we are about to read
;
    on_error,0
    errmsg=''
	verEps=.0001
	c_mps=299792458D
    istat=wasalignrec(desc,scanind=iscan,recInd=recInd)
    if istat ne 1 then return,istat
;
    rowsInRec=desc.scanI[iscan].rowsinrec
    curposUsed=desc.curpos
    if (curposUsed + rowsInRec - 1 ) ge desc.totrows then begin
        return,0                ; hit eof
    endif
    recNum=recInd+1
    nrows=rowsInRec
;
    curPosStart=desc.curpos
        
    nbrds=desc.scanI[iscan].nbrds
    pol  =intarr(2,nbrds)
    h =replicate({hdr},nbrds)
    hf=replicate({washdr},nbrds)
;
;  Get the data 
;
;   time crval5 and Ast .. this is from the datataking timestamp
;
    fxbread,desc.lun,crval5,'CRVAL5',curPosStart+1,errmsg=errmsg 
    if errmsg ne '' then goto,hdrreaderr
	if (desc.fitsVersion gt .89) then crval5=crval5/3600D ;back to hours<pjp003>
    timeAst= long((crval5 - 4.)*3600.)
    if timeAst lt 0L then timeAst=timeAst+86400L
;
;   mjd obs
;
    fxbread,desc.lun,mjd_obs,desc.colI.jd,curPosStart+1,errmsg=errmsg 
    if errmsg ne '' then goto,hdrreaderr
;
;   srcName 
;
    fxbread,desc.lun,src,'OBJECT',curPosStart+1,errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
    src=byte(src)
;
;   obs_name this rec
;
    fxbread,desc.lun,obsNm ,desc.colI.scantype,curPosStart+1,errmsg=errmsg ;byte
    obsNmL=strlowcase(obsNm)
    obsNmLen=strlen(obsNmL)
    if errmsg ne '' then goto,hdrreaderr


;
;    info for new fit header.. read each row of grp since value can
;    change board to board. there may be more than 1 row in a board.
;
;   freq Hz at reference pixel
;
    fxbread,desc.lun,crval1,'CRVAL1',[curPosStart+1,curPosStart+rowsInRec],$
                errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   freq step between channels.
;
    fxbread,desc.lun,cdelt1,'CDELT1',[curPosStart+1,curPosStart+rowsInRec],$
                errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   ref pix number (count from 1)
;
    fxbread,desc.lun,crpix1,'CRPIX1',[curPosStart+1,curPosStart+rowsInRec],$
                errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   restfreq
;
    fxbread,desc.lun,restfreq,desc.colI.restfreq,[curPosStart+1,$
            curPosStart+rowsInRec],errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   velocity
;
    fxbread,desc.lun,velocity,desc.colI.velocity,[curPosStart+1,$
                curPosStart+rowsInRec],errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   specsys/ctype1 .. velocity type 
;
    fxbread,desc.lun,specsys,desc.colI.ctype1,[curPosStart+1,$
            curPosStart+rowsInRec], errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   flip band flipped
;
    fxbread,desc.lun,flipped,desc.colI.flip,[curPosStart+1,$
            curPosStart+rowsInRec],errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   integration time
;

    fxbread,desc.lun,exp,'EXPOSURE',curPosStart+1, errmsg=errmsg 
;
;   bandwidth num 0 = 100, 1=50,2=25...
;
    fxbread,desc.lun,bandwd,'BANDWID',[curPosStart+1,curPosStart+rowsInRec],$
                errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
    bwnum=long(alog(100./(bandwd*1d-6))/alog(2.) + .5) ;to  Mhz
;
;   azimuth
;
    fxbread,desc.lun,az,desc.colI.az,curPosStart+1, errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
    az=long(az*10000.+.5)
;
;   lag0 pwrratio
;
    fxbread,desc.lun,lag0,'TOT_POWER',[curPosStart+1,curPosStart+rowsInRec],$
            errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   main elevation .. assume dome.. 
;
    fxbread,desc.lun,grza,desc.colI.el,curPosStart+1,errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
    grza=long((90.-grza)*10000. + .5)
;
;   ch za 
;
    fxbread,desc.lun,chza,desc.colI.elalt,curPosStart+1,errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
    chza=long((90.-chza)*10000. + .5)
;
;   time stamp for position
;
    fxbread,desc.lun,encTm,desc.colI.encTm,curPosStart+1, errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
	if desc.fitsVersion gt .89 then begin	; <pjp003>
		encTm=encTm - 4*3600D			; utc to ast
		if encTm lt 0D then encTm=86400D + encTm
		encTm=long(encTm*.001 + .5)
	endif
;
;   ifval
;
    fxbread,desc.lun,ifVal,'IFVAL',[curPosStart+1,curPosStart+rowsInRec],$
                 errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
;   backend setup
;
    fxbread,desc.lun,bkendmode,'BACKENDMODE',$
        [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
;
; iflo junk:
;
    fxbread,desc.lun,caltype,'CALTYPE',curPosStart+1, errmsg=errmsg ; ascii
    if errmsg ne '' then goto,hdrreaderr 
    case 1 of
        caltype eq 'hcal'   : ical=5
        caltype eq 'hcorcal': ical=1
        caltype eq 'hxcal'  : ical=3
        caltype eq 'h90cal' : ical=7
        caltype eq 'lcal'   : ical=4
        caltype eq 'lcorcal': ical=0
        caltype eq 'lxcal'  : ical=2
        caltype eq 'l90cal' : ical=6
        else : ical=0
    endcase
    fxbread,desc.lun,rfnum  ,'RFNUM',curPosStart+1, errmsg=errmsg   ; byte
    if errmsg ne '' then goto,hdrreaderr
    fxbread,desc.lun,frontend ,'FRONTEND',curPosStart+1, errmsg=errmsg   ; byte
    if errmsg ne '' then goto,hdrreaderr
    if strlowcase(frontend) eq 'alfa' then rfnum=17
    fxbread,desc.lun,lbwhybrid ,'LBWHYB',curPosStart+1, errmsg=errmsg   ; byte
    if errmsg ne '' then goto,hdrreaderr
    lbwLinPol=(lbwhybrid eq 0)?1:0
    fxbread,desc.lun,ifnum ,'IFNUM',curPosStart+1, errmsg=errmsg   ; byte
    if errmsg ne '' then goto,hdrreaderr
    fxbread,desc.lun,hybrid10gc ,'HYBRID',curPosStart+1, errmsg=errmsg   ; byte
    if errmsg ne '' then goto,hdrreaderr
    hybrid10gc=(hybrid10gc eq 0)?0:1
    iflostat1=(ishft(ulong(rfnum),27))      or (ishft(ulong(ifnum),24)) or $
              (ishft(ulong(hybrid10gc),23)) or (ishft(ulong(lbwLinPol),21)) 
    iflostat2=(ishft(ulong(ical),24))
;
    fxbread,desc.lun,syn1 ,'SYN1',curPosStart+1, errmsg=errmsg   ; 
    if errmsg ne '' then goto,hdrreaderr
;

    fxbread,desc.lun,syn2 ,'SYNFRQ',curPosStart+1, errmsg=errmsg   ;
    if errmsg ne '' then goto,hdrreaderr

    fxbread,desc.lun,mixerCfr ,'MIXER',curPosStart+1, errmsg=errmsg   ; 
    if errmsg ne '' then goto,hdrreaderr
    mixerCfr=long(mixerCfr)
 
    if2st4=ishft(mixerCfr,28)       ; array of 4
;
; pointing junk .. warning. time stamp for pointing not provided
;                  in file. 
;
;
    fxbread,desc.lun,dtemp ,desc.colI.reqRaJ,curPosStart+1, errmsg=errmsg   ;
    if errmsg ne '' then goto,hdrreaderr
	if desc.fitsVersion ge (.92 - verEps) then begin
       reqRaJRd=dtemp/360D*!dpi*2D             ; convert to radians..
	endif else begin
    	reqRaJRd=dtemp/24D*!dpi*2D             ; convert to radians..
    endelse
    fxbread,desc.lun,dtemp ,desc.colI.reqDecJ,curPosStart+1, errmsg=errmsg   ;
    if errmsg ne '' then goto,hdrreaderr
    reqDecJRd=dtemp/360D*!dpi*2D             ; convert to radians..

    fxbread,desc.lun,croff2 ,desc.colI.croff2,curPosStart+1, errmsg=errmsg 
	if desc.fitsVersion ge (.92 - verEps) then croff2=croff2/15D; back to hrs
    fxbread,desc.lun,croff3 ,desc.colI.croff3,curPosStart+1, errmsg=errmsg 
	; <pjp004> below
    fxbread,desc.lun,crval2 ,desc.colI.crval2,curPosStart+1, errmsg=errmsg 
    fxbread,desc.lun,crval3 ,desc.colI.crval3,curPosStart+1, errmsg=errmsg 
    fxbread,desc.lun,off_cs ,'OFF_CS',curPosStart+1, errmsg=errmsg 
    fxbread,desc.lun,off_time,'OFF_TIME',curPosStart+1, errmsg=errmsg 
	if desc.fitsVersion ge (.92 - verEps) then begin	; <pjp003>
		off_time=off_time - 4*3600D
		if off_time lt 0. then off_time=off_time + 86400D
	endif
    fxbread,desc.lun,rate_ra  ,desc.colI.rateRa,curPosStart+1, errmsg=errmsg
    fxbread,desc.lun,rate_dec ,desc.colI.rateDec,curPosStart+1, errmsg=errmsg
    fxbread,desc.lun,rate_dur,'RATE_DUR',curPosStart+1, errmsg=errmsg
    if desc.colI.rateTm ne -1 then begin
        fxbread,desc.lun,rate_time,desc.colI.rateTm,curPosStart+1, errmsg=errmsg
    endif else begin
        rate_time=0
    endelse
    fxbread,desc.lun,rate_cs,'RATE_CS',curPosStart+1, errmsg=errmsg
    if desc.colI.paraAngle ne -1 then begin
        fxbread,desc.lun,paraAngle,desc.colI.paraAngle,curPosStart+1,$
                    errmsg=errmsg
    endif else begin
        paraAngle=0.D
    endelse
    if desc.colI.alfaAngle ne -1 then begin
        fxbread,desc.lun,alfaAngle,desc.colI.alfaAngle,curPosStart+1,$
                    errmsg=errmsg
    endif else begin
        alfaAngle=0.D
    endelse
    if desc.colI.beamAz ne -1 then begin
        fxbread,desc.lun,beam_az,desc.colI.beamAz,$
        [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        fxbread,desc.lun,beam_za,desc.colI.beamZa,$
        [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
    endif
;
;	geo/helio velproj
;
	if desc.fitsVersion ge (1. - verEps) then begin
		  fxbread,desc.lun,geovelProj,'VEL_GEO',curPosStart+1,$
					  errmsg=errmsg
		  fxbread,desc.lun,heliovelProj,'VEL_BARY',curPosStart+1,$
					  errmsg=errmsg
	endif else begin
		geovelProj=0.
		heliovelProj=0.
	endelse
;
; ------------------------------------------------------------------
; 26oct04 desc.fitsVersion >= .5 additions. crval2a and associated junk <pjp001>
;
    versionHf=''
    if desc.fitsVersion ge (.5 - verEps) then begin
;       already input..
;       crval2c,3c is not raj
;       CRVAL1V is already input, it's velocity
;       specsys=ctype1
;
;      single row
;
;
        versionHf='1.0'
        fxbread,desc.lun,lst,'LST',curPosStart+1,errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
		if desc.fitsVersion ge (.92 - verEps) then lst=lst/3600D ;<pjp004>
;
       	fxbread,desc.lun,equinox,desc.colI.equinox,curPosStart+1,errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,date_obs,'DATE-OBS',curPosStart+1,errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,cunit1v,desc.colI.cunit1v,curPosStart+1,errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,ctype1v,desc.colI.ctype1v,curPosStart+1,errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
;      multi row  
;
        fxbread,desc.lun,crval2a,desc.colI.crval2a,$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
		; <pjp003>
		if desc.fitsVersion ge (.92 - verEps) then $
					crval2a=crval2a/15D ; back to hrs
;
        fxbread,desc.lun,crval3a,desc.colI.crval3a,$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,crval2b,desc.colI.crval2b,$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,crval3b,desc.colI.crval3b,$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
		if desc.fitsVersion gt (.92 - verEps) then $
				crval3b=90.-crval3b ; el-> za <pjp003>
;
;   
        fxbread,desc.lun,crval2g,'CRVAL2G',$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,crval3g,'CRVAL3G',$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,bandwid,'BANDWID',$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
;        this is velocity above...
;        fxbread,desc.lun,crval1v,'CRVAL1V',$
;            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
;        if errmsg ne '' then goto,hdrreaderr
;
; 		<pjp004>
;        fxbread,desc.lun,crpix1v,'CRPIX1V',$
;            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
;        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,croff2b,desc.colI.croff2b,$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
;
        fxbread,desc.lun,croff3b,desc.colI.croff3b,$
            [curPosStart+1,curPosStart+rowsInRec],errmsg=errmsg
        if errmsg ne '' then goto,hdrreaderr
    endif
;   
;------------------------------------------------------------------------
; pattern junk
;
;   procname (switch to pattern name)
;
    fxbread,desc.lun,patnam,desc.colI.patnam,curPosStart+1,errmsg=errmsg
    if errmsg ne '' then goto,hdrreaderr
    car0   =obsNmL                   ; by default use this..
    car0Len=obsNmLen                ; by default use this..
    iar    =lonarr(10)
    dar    =dblarr(10)
    proc_name=patnam
    case  1 of
        proc_name eq 'ONOFF': begin
                        proc_name='onoff'
                        if obsNmL eq 'on' then begin
                            if iscan lt (desc.totscans-2) then begin 
                                iar[1]=(desc.scanI[iscan+2].patnm eq 'CAL')?1:0 
                            endif
                        endif else begin
                            if iscan lt (desc.totscans-1) then begin 
                                iar[1]=(desc.scanI[iscan+1].patnm eq 'CAL')?1:0 
                            endif
                        endelse
                    end
        proc_name eq 'CAL'  : proc_name='calonoff'
        proc_name eq 'DRIFT': proc_name='cordrift'
        proc_name eq 'DPS'  : proc_name='dps'
        proc_name eq 'CROSS': proc_name='cross'
        proc_name eq 'ON'   : proc_name='on'
        proc_name eq 'RUN'   : proc_name='run'
;
;   spider scan
;
        strmid(proc_name,0,6) eq 'SPIDER': begin
                    if strlen(proc_name) eq 8 then begin
                        alfaBeam = long(strmid(proc_name,7,1))
;
;   FIX...
;   This is for data before beam offset included..
;
    azAlfaOff=[0.000D  ,-164.530,-329.060,-164.530, 164.530,329.060,164.530]
    zaAlfaOff=[0.000D  , 332.558,  -4.703,-332.558,-332.558,  0.000,332.558]
                        bmazoff=azAlfaOff[alfaBeam]/3600.; in deg
                        bmzaoff=zaAlfaOff[alfaBeam]/3600.; in deg
                        iar[5]=alfaBeam
                    endif else begin
                        bmazoff=0.
                        bmzaoff=0.
                        iar[5]=0
                    endelse
                        

                    proc_name='corcrossch'
    fxbread,desc.lun,recstrip ,desc.colI.totSubScan,curPosStart+1,errmsg=errmsg 
                    iar[1]=recstrip*(exp + .5)  ; secs per strip round..
                    iar[2]=recstrip      ; smples per strip
                    iar[3]=4             ; strips pattern

    timeastFl=(crval5 - 4d)*3600D
;
;    try and compute the offsets
;
        dt=(timeastFl - encTm*.001) 
        if abs(dt) gt 43200 then dt=dt+86400D  ; cross midnite
        tmdur=(rate_Dur+dt)
        if tmDur lt 0 then tmDur=0.
        azoff= (croff2 + rate_ra*(tmDur)) - bmazoff
        zaoff= (croff3 + rate_dec*(tmDur)) - bmzaoff
        dar[1]=azoff
        dar[2]=zaoff
        dar[3]=rate_ra
        dar[4]=rate_dec
        iar[0]= (sqrt(azoff^2 + zaoff^2)*60.)/3. ; estimate halfpwr beamwidth
        car0Len=2
        case obsNmL of
            'onaz'  : car0='01'
            'onza'  : car0='02'
            'onaz45': car0='03'
            'onza45': car0='04'
            else    : begin
                        car0=obsNmL
                        car0=obsNmLen
                      end
        endcase 
        end
        else : 
    endcase
    procname=byte(proc_name)
;------------------------------------------------------------------------
; 
; broken !!FIX!!
; std.grpCurRec ..since they don't start with first board all the time
; cor.bwNum     .. they have 100 Mhz bw.
; most of the h.dop header
;
;  compute observer velocity projected, and then dopplerCorFactor
;
;  DF=frqRP/frqBCRest=1./(1. + velObj-velUsrProj)
;  (1.+velobj-velusrProj)=frqBC/frqRP
;   (1. + velObj - frqBCRest/frqRP  = velUsrProj
;
;   FIX.. below is leaving velType to vel rather than Z
;   looks like sign of velocity is wrong..
;
    c=299792.458D               ; speed of light km/sec
    velObsProj=(1D + velocity[0]*1D-3/c - (restFreq[0]/crval1[0]))*c 
	if desc.fitsVersion gt .89 then begin
	    velSys=strmid(specsys[0],0,3)	
		match =['TOP','OBS','LSR','BAR','GEO'] ; <pjp003> check these
	endif else begin
    	ctemp=strmid(specsys[0],4,1)
    	if ctemp eq '-' then begin
        	velSys=strmid(specsys[0],4,4)
        	match=['-TOP','-OBS','-LSR','-HEL','-GEO']
    	endif else begin
        	match=['TOP','OBS','LSR','HEL','GEO']
        	velSys=strmid(specsys[0],0,4)
    	endelse
	endelse
    case 1 of 
        strcmp(velSys,match[0]):dopStat=0UL
        strcmp(velSys,match[1]):dopStat=0UL
        strcmp(velSys,match[2]):dopStat='18000000'XUL
        strcmp(velSys,match[3]):dopStat='10000000'XUL
        strcmp(velSys,match[4]):dopStat='08000000'XUL
        else: dopStat=0UL 
    endcase

;
; fits was one row per spectra,
; hdrcor has one entry per board..
; for those entries that differ by board, 
;  need to move info 1 board at a time.
;
    j=0                         ; index start of each board
;
;   things that do not change board to board
;
	h.std.hdrmarker = byte('hdr_')		;<pjp002>
	h.std.hdrlen    = 992
	h.std.sec.inp   = '080800a0'XUL
	h.std.sec.iflo  = '0a210088'XUL
	h.std.sec.proc  = '0c298058'XUL
	h.std.sec.time  = '0'XUL
	h.std.sec.pnt   = '0b1200f0'XUL
	h.std.sec.misc  = '0d2f00f0'XUL
    h.std.grpTotRecs=desc.scanI[iscan].nbrds
    h.std.time      =timeAst
    h.proc.srcname  =src
    h.proc.procname =procname
    h.proc.car[0:car0Len-1,0] =byte(car0)
    h.std.scanNumber=desc.scanI[iscan].scan
    h.std.grpNum    =recNum
    h.cor.numbrdsused=desc.scanI[iscan].nbrds

    h.std.azttd     =az
    h.std.grttd     =grza
    h.std.chttd     =chza
    h.std.posTmMs   =encTm

    h.iflo.if1.st1=iflostat1
    h.iflo.if1.st2=iflostat2
    h.iflo.if1.lo1=syn1

    h.dop.id         = byte('DOP ')
    h.dop.stat       = dopStat
    h.dop.velobsProj = velObsProj;
    h.pnt.stat       = '00200000'XL ; hard code greg master
    h.pnt.r.secMid   = off_time      ; offtime comes from pnt time stamp.
    h.pnt.r.rajcumrd  = reqRaJRd     ; cumulative ra position from az,za
    h.pnt.r.decjcumrd = reqDecJRd    ; cumulative dec position from az,za

    h.pnt.r.reqraterdsec[0]=rate_ra *!dtor
    h.pnt.r.reqraterdsec[1]=rate_dec*!dtor
    h.pnt.r.daynumastratestart= rate_time
    h.pnt.r.geovelproj        = geoVelProj/c_mps
    h.pnt.r.heliovelproj      = helioVelProj/c_mps

    h.pnt.m.azttd       =az
    h.pnt.m.grttd       =grza
    h.pnt.m.chttd       =chza
    h.pnt.m.agcTmStamp  =encTm
;
;   things that change board to board
;   .. here we grab from desc.scanI.. order is already set..
;
    h.cor.numSbcOut =desc.scanI[iscan].nsbc[0:nbrds-1]
    h.cor.lagsbcOut =desc.scanI[iscan].nlags[0:nbrds-1]
    h.cor.boardId   =desc.scanI[iscan].brdNum[0:nbrds-1]

	h.std.reclen    =(h.std.hdrlen) + (h.cor.numsbcout*h.cor.lagsbcout*4L)

    hf.numChan=desc.scanI[iscan].nlags[0:nbrds-1]
    hf.crval2   =crval2			; req ra  hours
    hf.crval3   =crval3         ; req dec  deg 
    hf.crval2c  =reqRaJRd/(!dpi*2d) *24D		    ; hours
    hf.crval3c  =reqDecJRd/(!dpi*2D)*360D           ; deg 
    hf.crval5   =crval5         ; secs
    hf.mjd_obs  =mjd_obs   
    hf.croff2   =croff2			; ra off hours
    hf.croff3   =croff3         ; dec off deg
    hf.off_cs   =off_cs      
    hf.alfa_ang =alfaAngle
    hf.para_ang =paraAngle
    hf.projid   =desc.projid
    hf.exp      = exp
    hf.obs_mode =patnam
    hf.obs_name =obsNm
    hf.rate_ra  =rate_ra
    hf.rate_dec =rate_dec
    hf.rate_dur =rate_dur
    hf.rate_time =rate_time
    hf.rate_cs   =rate_cs
    hf.version   =versionHf
;
;   pjp001
;   
    if desc.fitsVersion ge (.5 - verEps) then begin
        hf.lst       =lst
        hf.equinox   =equinox
        hf.date_obs  =date_obs
        hf.cunit1v   =cunit1v
        hf.ctype1v   =ctype1v          ; <pjp004> ctype1v
    endif
;
;   now loop over stuff that changes board to board that we read
;   from table
    for ibrd=0,nbrds-1 do begin
        npol=(desc.scanI[iscan].nsbc[ibrd] ge 2)?2:1
        ind=desc.scanI[iscan].ind[0:npol-1,ibrd]
        if desc.colI.beamAz ne -1 then begin
            hf[ibrd].beam_az=beam_az[ind[0]]
            hf[ibrd].beam_za=beam_za[ind[0]]
        endif
        pol[0:npol-1,ibrd]=ifval[ind]+1
        case bkendmode[ind[0]] of
            '1 chan, 3-level, pol a': lagconfig=5 ; thesetwo wrong
            '1 chan, 3-level, pol b': lagconfig=5
            '2 chan, 3-level auto'  : lagconfig=5
            '1 chan, 9-level, pol a': lagconfig=0
            '1 chan, 9-level, pol b': lagconfig=1
            '2 chan, 9-level auto'  : lagconfig=9
            '3-level, polarization':  lagconfig=10
            '9-level, polarization':  lagconfig=10
                           else:  lagconfig=9
         endcase
        h[ibrd].cor.lagconfig =lagconfig

        h[ibrd].cor.bwnum     =bwnum[ind[0]]
        h[ibrd].std.grpCurRec =ibrd + 1  ; <FIX> used for doppler offsets
        h[ibrd].cor.lag0pwrratio[0:npol-1] =lag0[ind]
        h[ibrd].cor.attndb[0:npol-1]       =$
        desc.scanI[iscan].corattn[0:npol-1,ibrd]
        corStat=0UL
        corStat=(flipped[ind[0]])?corStat or '00100000'XUL:corStat
        h[ibrd].cor.state=corStat
        h[ibrd].proc.iar=iar
        h[ibrd].proc.dar=dar
        h[ibrd].iflo.if2.synFreq=syn2
        h[ibrd].iflo.if2.st4    =if2st4
;
        hf[ibrd].rpfreq       =crval1[ind[0]] *1e-6
        hf[ibrd].rpChan       =crpix1[ind[0]]
        hf[ibrd].rpRestFreq   =restfreq[ind[0]]
        hf[ibrd].chanfreqStep =abs(cdelt1[ind[0]])*1e-6 ;<pjp003>
        if desc.fitsVersion ge (.5 - verEps)  then begin
            hf[ibrd].crval2a  =crval2a[ind[0]]
            hf[ibrd].crval3a  =crval3a[ind[0]]
            hf[ibrd].crval2b  =crval2b[ind[0]]
            hf[ibrd].crval3b  =crval3b[ind[0]]
            hf[ibrd].crval2g  =crval2g[ind[0]]
            hf[ibrd].crval3g  =crval3g[ind[0]]
            hf[ibrd].bandwid  =bandwid[ind[0]]
            hf[ibrd].crpix1v  =-1   ; crpix1v[ind[0]]
            hf[ibrd].croff2b  =croff2b[ind[0]]
            hf[ibrd].croff3b  =croff3b[ind[0]]
            hf[ibrd].specsys  =specsys[ind[0]]
            hf[ibrd].crval1v  =velocity[ind[0]]
        endif
;
;   doppler header
;
        h[ibrd].dop.freqOffsets=[0d,0D,0D,0D] ;  force it    
        h[ibrd].dop.freqBcRest = restfreq[ind[0]]*1d-6 ; for this board
        h[ibrd].dop.velOrZ     = velocity[ind[0]] *1d-3;m/sec to km/sec
        h[ibrd].dop.factor     = crval1[ind[0]]/restfreq[ind[0]]
    endfor
;
;    
    if (proc_name eq 'calonoff') and (car0  eq 'on') then  begin
        h.cor.calon = h.cor.lag0pwrratio
    endif else begin
        h.cor.caloff = h.cor.lag0pwrratio
    endelse
    return,1

hiteof:
    return,0
hdrreaderr:
    print,'Error reading hdr data:'+ errmsg
    return,-1
end
