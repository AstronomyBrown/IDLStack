;+
;NAME:
;corposonoffrfi - process a position switch pair with rfi excision.
;SYNTAX: istat=corposonoffrfi(lun,bonoff,calscl,bonrecs,boffrecs,$
;                  scan=scan,maxrecs=maxrecs,sl=sl,$
;                  han=han,sclcal=sclcal,sclJy=sclJy,$
;   dataPassedIn:  boninp=boninp,boffinp=boffinp,bcalinp=bcalinp,$
;                  smorfi=smorfi,
;    rfiExcParms:  frqChnNsig=frqChnNsig,tpNSig=tpNsig,badNsig=badNsig,$
;                  flatTsys=flatTsys,adjKer=adjKern,$
;  ReturnRfiInfo:  bsmpPerChn=bsmpPerChn,bresdat=bresdat,bmask=bmask,$
;ReturnRfiTpInfo:  tpdat=tpdat,tpmask=tpmask,$
;                  verbtp=verbtp,verbwt=verbwt,verball=verball
;   
;INPUT ARGS:
;lun:         int   file lun if program is to read the data from disc.
;
;INPUT KEYWORDS:
;POSITIONING:
;scan:        long  scan number of on scan. If not supplied then start
;                   reading from the current position.
;maxrecs:     long  If then number of records in a scan in more than
;                   300, then you need to specify this value using the
;                   maxrecs keyword. If not, the routine will only
;                   read the first 300 records.
;sl[]: {getsl}      If you first scan the file with getsl() then passing
;                   the sl[] array in will allow the routine to do 
;                   random access (rather than sequentially searching
;                   for the scan on interest).
;DATA SCALING:  
;han:               If set then hanning smooth the data on input.
;sclCal:            if set then scale the data to kelvins using the
;                   cal scan that follows the position on/off.
;                   By default the units are Tsys (since we divide
;                   by to off source).
;sclJy:             If set then scale the data to Janskies. This is done
;                   by first scaling to kelvins using the cal on/off
;                   scans and then using the gain curve to scale from
;                   kelvins to Janskies. This only works for those
;                   receivers that have gain curves.
;                   cal scan that follows the position on/off.
;USERINPUTS DATA:
;boninp[]: {corget} The user passes in the on source records rather than
;                   reading them from disc.
;boffinp[]:{corget} The user passes in the off source records rather than
;                   reading them from disc.
;bcalinp[]:{corget} The user passes in the cal on/off records rather than
;                   reading them from disc.
;RFI EXCISION:
;smorfi:      long  When searching for rfi, smooth the data by
;                   smorfi channels before searching. smorfi should
;                   be an odd number. This is only used for searching
;                   for the rfi, the returned data is not smoothed.
;flatTsys:          If set, then divide each spectra by
;                   its median value before searching each freq channel
;                   along the time direction. This will allow records with
;                   total power fluctuations to be included.
;adjKer[i,j]: float convol this array with the mask array for each
;                   sbc. If the convolved value is not equal to the 
;                   sum of adjKer then also exclude this point. This
;                   array lets you exclude points adjacent to bad 
;                   points (xdim is frequency, ydim is time). The 
;                   array dimensions should be odd.
;frqChnNsig:  float The number of sigmas to use when excluding a point.
;                   linear fits are done by channel along the time axis.
;                   Points beyond frqChnNsig will be excluded from the
;                   averaging.
;badNsig:     float The rms/median is computed for each freq
;                   channel (after excluding bad points). If badNsig is
;                   provided, then any freq channels with rms/median
;                   greater than 3. will be refit along the time direction
;                   searching for bad points using badNsig rather than
;                   frqChnNSig as the threshold for bad points. 
;                   An example would be frqChnSig=3, badNsig=2.
;tpNsig:      float The total power is computed vs time for the points
;                   that pass the freqchannel test. A linear fit is 
;                   then done versus time. Any time points whose
;                   residuals are greater than tpNSig will be ignored.
;                   The default  is 0 (this computation is not done)
;RETURNED ARGS:
;bonoff:   {corget}     return processed (on-off)/off here. The units will
;                       by Tsys,K, or K/Jy depending on the sclCal and
;                       sclJy keywords. 
;calScl[2,nbrds]:float  values used to scale correlator counts to kelvins.
;bonrecs[]:{corget}     return individual on records. This is an
;                       optional argument. The units will be K (if /sclcal),
;                       Jy if /sclJy else correlator units
;boffrecs[] : {corget}  return then individual off records. This is an
;                       optional argument. The units will be K (if /sclcal),
;                       Jy if /sclJy else correlator units
;RETURNED KEYWORDS:
;
;bsmpPerChn: {corget}   holds the number of samples averaged for each 
;                       freq channel.
;bresdat[nsmp]:{corget} holds the residuals (in units of sigma along a 
;                       frequency channel)  for all the input data.
;bmask[nsmp]:{corget}   hold mask for points used. 0 excluded, 1. included.
;tpdat[ntmsmp,2,nbrds]:float Total power vs time for each subband used
;                       for total power clipping. This is after the
;                       bad frequency channels are removed. If only one
;                       polarization per board, then the 2nd pol index will
;                       have 0's.
;tpmask[ntmsmp,2,nbrds]:float Total power mask vs time for each subband used
;                       will contain 1 if time sample used, 0 if it
;                       was not used.
;DESCRIPTION:
;   Process a position switch on,off pair. Return a single spectrum
;per sbc of  (posOn-posOff)/posOff. Try to excise rfi before averaging.
;   The units will be:
; Kelvins  if /sclcal is set
; Janskies if /scljy  is set .
; TsysUnits if none of the above is set.
;
;   If bonrecs is specified then the individual on records will also
;be returned. If boffrecs is specified then the individual off records
;will be returned. The units for these spectra will be  Kelvins
;(if /sclcal,/scljy is set) or correlator units (linear in power).
;
;   The user can optionally pass in the data rather than reading it
;from disc (using the keywords boninp,boffinp,bcalinp). If you pass
;in data, you must pass in all the data (ons,offs, and cals).
;
;   The processing is:
;1. Input all of the on  records. Hanning smooth them if requested.
;2. Input all of the off records. Hanning smooth them if requested.
;3. Input the two calon, caloff records if we are scaling to kelvins, Jy,
;   or the user supplied the calscl keyword.
;4. Compute onoffAr[nsmp]= on/off for each record. 
;5. For each sbc of each correlator board call bpccmpbychan(onoffAr).
;   bpcbychan() does the following:
;   a.For each freq chan iteratively do a linear fit along the time direction 
;     throwing out any points that have fit residuals greater than freqChnNsig
;     (the default is 3 sigma). Continue fitting the same channel until no 
;     new points are thrown out (or an iteration limit is hit).
;   b.Flag all of the good and bad points found for a channel in bmask:
;     good values get 1, bad values get 0. Also store the fit residuals in
;     bresdat[].
;   c.badNsig is used to recompute the good/bad points using a smaller clipping
;     value (specified by badNsig). If badNsig is provided , then for each
;     freq channel compute: frqChanRms[nchan]= chanFitSigma/Mean(of channel) 
;     using the "good" datapoints it computed. The array frqChanRms is then 
;     searched for all outliers 3 sigma above its mean value. These channels
;     will be reprocessed using badNSig as the clipping level rather than
;     frqChnNsig (typically these values would be 3 and 2).
;     If bandNsig is not provided, then this step is not done.
;6. If tpNsig is provided, then compute the total power in the onoffar[]
;   for each time sample using the "good" data points. Do an interative
;   linear fit throwing out complete time points if the fit residuals for
;   a time point is greater than tpNsig. Any time points that get flagged
;   as bad will have all of their frequency channels flagged as bad.
;   This processing is only done if the keyword tpNsig  is provided.
;7. AFter flagging all of the good and bad points, average onoffAr[] over 
;   the good points and then subtract 1 (on-off)/off = (on/off - 1). Store 
;   the number of good points found in each frequency channel in the array 
;   bSmpPerChn.
;8. If we use the cals for scaling, also compute the average off source
;   value over the "good" data points. This is needed since we've been
;   working the whole time with on/off.
;   avgOffSrc
;9. If scaling to Kelvins,or Jy call corcalcmp(calrecs, /blda) with the cal 
;   on,off records. The routine will:
;   a. compute calRatio=(calOn-calOff)/caloff.
;   b. call corblauto(calRatio,deg=1,mask=calmask). It will interatively
;      fit a linear function to (calratio) throwing out any points that
;      are above 3 sigma. The cal mask will be all of the frequency channels
;      that fall below 3 sigma.
;   c. compute corToK= calInK/avg(calon-caloff) averaging over the "good" 
;      cal points.
;
;  -We've compute on/off which is in units of Tsys. The conversion factor
;   computed in c. converts from correlator counts to Kelvins. We need to
;   rescale the onoff computed in 7. back to correlator counts. This should
;   be done using the same frequency channels that were used to compute the 
;   cal scaling factor.
;    meanTpoff = mean(avgOffSrc[over channels where calmask is 1])
;  - compute onoff*meanTpOff * corToK
;10. If scaling to Jy then get the gain for this frequency and az,za in
;    K/Jy. Divide each frequency point in onoff by this value to get Jy.
;
;HOW WELL DOES THE EXCISION WORK:
;1. For a signal to be identified as rfi it must vary in time relative
;   to the median value in the channel. If the signal is stable or slowly 
;   drifts by a single channel over the integration time, then it will
;   not be excised.  
;2. We typically take 1 second records for 300 seconds on and off source.
;   This routine fits the 1 second data and uses the 1 second sigmas to try
;   and find bad data points. 
;       It then averages over these good data points by up to 300 which ;
;   reduces the sigma by sqrt(300). So a weak signal will pass the test.
;   the smorfi keyword will smooth over frequency channels before searching
;   for the bad points. This may help (depending on the width of the rfi).
;
;EXAMPLES:
;   Suppose we've opened a data (lun points to it) and it has the
; following data:
;
; W49A 417600054   300        onoff      on 19:26:12 11
; W49A 417600055   300        onoff     off 19:32:14 11
; W49A 417600056     1     calonoff      on 19:37:17 11
; W49A 417600057     1     calonoff     off 19:37:28 11
;
; istat=corposonoffrfi(lun,bonoff,calscl,scan=417600054L,/han,/sclcal,$
;                      bsmpPerchn=bsmpPerchn,bmask=bmask)
;
; bonoff[1]      will then have on/off-1 in Kelvins
; bsmpPerchn[1] will have the number of samples used in each frq channel
; bmask[300]     will have a 1,0 for the good and bad data points.
;
;; plot on/off -1 in kelvins
;
; corplot,bonof
;
;;plot the good points per channel
; corplot,bsmpperchn
; 
;; make an image of freq vs time of the points that were used (bright)
;; and not used (dark).
;; (first do xloadct to load a linear ramp in the color table)..
;
; img=corimgdisp(bmask,/nobpc,corplot)
;-
;12nov04 - bonrecs,boffrecs were always being returned in correlator
;          units... changed so they are returned in Cor,Tsys,K , or Jy.
;
function corposonoffrfi,lun,bonoff,calscl,bonrecs,boffrecs,$
                        scan=scan,maxrecs=maxrecs,sl=sl,han=han,$
                        sclcal=sclcal,sclJy=sclJy,$
                        bonin=bonin,boffin=boffin,bcalin=bcalin,$
                        smorfi=smorfi,adjKer=adjKer,flatTsys=flatTsys,$
                        frqChnNsig=frqChnNsig,tpNSig=tpNsig,badNsig=badNsig,$
                        bsmpPerChn=bsmpPerChn,bresdat=bresdat,bmask=bmask,$
                        tpdat=tpdat,tpmask=tpmask,$
                        verbtp=verbtp,verbwt=verbwt,verball=verball

    istat=1
    if not keyword_set(scan)    then scan=0
    if not keyword_set(sclcal)  then sclcal=0
    if not keyword_set(scljy)   then scljy=0
    ;
    ;   gain curve needs to scale to kelvins first
    ;
    if keyword_set(scljy)       then sclcal=1
    if not keyword_set(maxrecs)  then maxrecs=0
    if not keyword_set(sl)       then sl=0
    if not keyword_set(han)       then han=0
    usecals   = sclcal
    retonrecs = 0
    retoffrecs = 0
    if (n_params() ge 4) then usecals=1 ; they want to return them..
    if (n_params() ge 5) then retonrecs=1
    if (n_params() ge 6) then retoffrecs=1


    retBres=arg_present(bresdat)    ; they want residual returned..
    if not keyword_set(frqChnNsig) then frqChnNsig =3.
    if not keyword_set(tpNsig)     then tpNsig     =0.
    if not keyword_set(verbtp)     then verbtp     =0 
    if not keyword_set(verbwt)     then verbwt     =0 
    if not keyword_set(smorfi)        then smorfi        =0 
    if keyword_set(verball)        then begin
        verbtp=1;
    endif
    useAdjKer=n_elements(adjker) gt 1

    rettpdat   = arg_present(tpdat)
    rettpmask  = arg_present(tpmask)
    retallmask = arg_present(bmask)
    coltpbad=2
    cs=1.5
;
;   get the data check that they are on,off scans if we read them in..
;
    
    bufsPassedIn=(keyword_set(bonin) and keyword_set(boffin))
    if bufsPassedIn then begin
      if (n_elements(bonin) ne n_elements(boffin)) then begin
        print,'on,off scans have different number of records'
        goto ,errinp 
      endif
;
;   get the cal recs
;
        if usecals then begin
            if not keyword_set(bcalin) then begin
              print,'No cal records provided, can not scale to cals or Jy'
              goto,errinp
            endif
            bcalrecs=bcalin
        endif
    endif else begin
;
;    we read in the on,off buffers
;
      if (corinpscan(lun,bonrecs ,scan=scan,han=han,sl=sl,maxrecs=maxrecs) $
            eq 0) then goto,errinp
      if (corinpscan(lun,boffrecs,han=han,sl=sl,maxrecs=maxrecs)$
             eq 0) then goto,errinp
      if (n_elements(bonrecs) ne n_elements(boffrecs)) then begin
        print,'on,off scans have different number of records'
        goto ,errinp 
      endif
      if ( string(bonrecs[0].(0).h.proc.car[*,0]) ne 'on') then begin
        print,'1st scan not an on',bonrecs[0].(0).h.std.scannumber
        goto,errinp
      endif
      if ( string(boffrecs[0].b1.h.proc.car[*,0]) ne 'off') then begin
        print,'2nd scan not an off',boffrecs[0].b1.h.std.scannumber
        goto,errinp
      endif
;
;   get the cal recs
;
      if (usecals) then begin
        if (corgetm(lun,2,bcalrecs,sl=sl,han=han) ne 1 ) then begin
            print,'Could not read in the calon,off scans'
            goto,errinp
        endif
      endif
    endelse
;
;    compute on/off by rec
;
    if smorfi gt 1 then begin
        bonoffAsav=(bufsPassedIn) $
                        ?cormath(bonin,boffin,/div) $
                        :cormath(bonrecs,boffrecs,/div)
        corsmo,bonoffASav,bonoffA,smo=smorfi
    endif else begin
        bonoffA    =(bufsPassedIn) $
                        ?cormath(bonin,boffin,/div) $
                        :cormath(bonrecs,boffrecs,/div)
    endelse
    if usecals then boffavg=bonoffa[0]
;
;   compute 
;
    ntmSmp=n_elements(bonoffA)          ; number of time samples we have
    if tpNSig ne 0. then xtm=findgen(ntmSmp)
    bsmpPerChn=bonoffA[0]           ; keep track of good time samples/frq chan
    if retBres then bresdat=bonoffA ; return fit residuals
    nbrds=bonoffA[0].b1.h.cor.numbrdsused
    bonoff=bonoffa[0]
    if rettpdat   then tpdat=fltarr(ntmsmp,2,nbrds)
    if rettpmask  then tpmask=fltarr(ntmsmp,2,nbrds)
    if retallmask then bmask=bonOffA
;
;   loop over the number of correlator boards they have
;
    for ibrd=0,nbrds-1 do begin
        npol=bonOffA[0].(ibrd).h.cor.numsbcout
        if npol gt 2 then begin
            print,'corposonoffrfi does not support stokes data..sorry'
            goto , errinp
        endif
        nlags=bonOffA[0].(ibrd).h.cor.lagsbcout
        for ipol=0,npol-1 do begin
            nbadtp     =0L
;
;           for each channel do a linear fit over time. Iterate
;           throwing out points with large residuals. Return the fit
;           residuals:
;           resall[freqchn,tmpnts]- fit residuals normalized to the sigma of
;                         each channel.
;
;           We will use this resall to decide which points to use.
; 
            bpc=bpcmpbychan(bonoffA.(ibrd).d[*,ipol],deg=deg,nsig=frqChnNsig,$
            resall=resall,nlsig=badNsig,flatTsys=flatTsys)
;
;           for each time sample compute the fraction of freq points that are 
;           good
;   
            statar=make_array(nlags,ntmSmp,/float,value=1.)
            ind=where(abs(resall) gt frqChnNsig,count_resall)
            if count_resall gt 0 then statar[ind]=0.
            if useAdjKer then begin
                scale=total(adjKer)
                junk=convol(statar,adjKer,/edge_truncate)
                ind=where((junk ne scale),count)
                if count gt 0 then statar[ind]=0.
            endif
;
;           see if they want to test using total power fluctuations
;
            if tpNSig ne 0. then begin
                tp=total(bonoffA.(ibrd).d[*,ipol]*statAr,1)/total(statar,1)
                mask=maskbyrms(xtm,tp,deg=deg,nsig=tpNSig,indxbad=indbadtp,$
                               nbad=nbadtp)
                if verbtp then begin
                    lab=string(format='("total pwr brd:",i1," sbc:",i1)',$
                                ibrd+1,ipol+1)
                    plot,xtm,tp,charsize=cs,title=lab
                    if nbadtp gt 0 then begin
                        oplot,xtm[indbadtp],tp[indbadtp],psym=2,color=coltpbad
                    endif
                    if verbwt then key=checkkey(/wait)
                endif
                if rettpdat  then tpdat[*,ipol,ibrd]=tp
                if rettpmask then tpmask[*,ipol,ibrd]=mask
            endif
                
;
        if verbtp or verbwt then begin
            lin=string(format='("brd/sbc:",i2,i2," bpntbyfreq:",i6)',$
                        ibrd+1,ipol+1,count_resall)
            if tpNSig ne 0. then begin
                lin=lin+$
                string(format='(" bSmpbyTpSig:",i6)',nbadtp)
            endif
            print,lin
        endif
;
;           compute number of time samples each freq bin
;           and then sum over time by multiplying with the statar and
;           summing. statar will have 0 for points that are not used.

sumdata:    
            if nbadtp      gt 0 then statar[*,indbadtp]=0.
            if retallmask then bmask.(ibrd).d[*,ipol]=statar

            bsmpPerChn.(ibrd).d[*,ipol]=total(statar,2); # pnts each freq bin
            if sclcal then begin
                boffavg.(ibrd).d[*,ipol]=(bufsPassedIn) $
                            ? total(boffin.(ibrd).d[*,ipol]*statar,2) $
                            : total(boffrecs.(ibrd).d[*,ipol]*statar,2)
            endif
            if smorfi gt 1 then begin               ; use the unsmoothed data
                bonoff.(ibrd).d[*,ipol]=$
                        total(bonoffASav.(ibrd).d[*,ipol]*statar,2)
            endif else begin
                bonoff.(ibrd).d[*,ipol]=$
                        total(bonoffA.(ibrd).d[*,ipol]*statar,2)
            endelse
            if retBres then bresdat.(ibrd).d[*,ipol]=resall 
        endfor
    endfor
;
;   now normalize to number of samples
;
    bonoff=cormath(bonoff,bsmpPerChn,/div)
    bonoff=cormath(bonoff,ssub=1.)
;
;   if using cals, compute cal scale factor. We will use the calmask
;   to normalize the off source during the bandpass correction
;
    if usecals then begin
        istat=corcalcmp(bcalrecs[0],bcalrecs[1],calscl,mask=calmask,/blda,$
                    extra=_e)
        if sclcal then begin
            boffavg=cormath(boffavg,bsmpPerchn,/div)
;           we've computed (on-off)/off  
;           we really wanted (on-off)/normalized(off) where the off was
;           normalized to unity over the calmask non zero channels.
;           To get this we just multiply by normalized(off) and then
;           multiply by the correlator counts to kelvins scaling factor.
;
             for ibrd=0,nbrds-1 do begin
                 npol=bonOff.(ibrd).h.cor.numsbcout
                 if sclJy then begin 
                     if (corhgainget(bonoff.(ibrd).h,gainval) < 0) then begin
    print,'No gain curves for this rcvr. You need to remove scljy=1 keyword'
                        goto,errinp
                    endif
                    gainvalInv=1./gainval   ; k/Jy -> Jy/Kelvin
                endif else gainvalInv=1.
                for ipol=0,npol-1 do begin
                    ind=where(calmask.(ibrd)[*,ipol] eq 1,count)
                    scl= mean(boffavg.(ibrd).d[ind,ipol])*calscl[ipol,ibrd]*$
                         gainvalInv
                    bonoff.(ibrd).d[*,ipol]= bonoff.(ibrd).d[*,ipol] *scl
                    if retonrecs then $
                        bonrecs.(ibrd).d[*,ipol]= bonrecs.(ibrd).d[*,ipol]*scl
                    if retoffrecs then $
                        boffrecs.(ibrd).d[*,ipol]= boffrecs.(ibrd).d[*,ipol]*scl
                 endfor
             endfor
        endif
    endif

    return,1
errinp: return,0
end
