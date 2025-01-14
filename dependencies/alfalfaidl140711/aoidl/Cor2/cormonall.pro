;+ 
;NAME:
;cormonall - monitor correlator data, bandpass,rms,img
;SYNTAX: cormonall,lun,vel=vel,pol=pol,brdlist=brdlist,maxrecs=maxrecs,$
;           spcavg=spcavg,norms=norms,nospectra=nospectra,noimg=noimg,$
;           base=base,edgefr=edgefr,vrms=vrms,vavgspc=vavgspc,$
;           imgpol=imgpol,ravg=ravg,col=col,clip=clip,imgmedian=imgmedian,$
;           vonoff=vonoff,cont=cont,sl=sl,step=step,scan=scan,nolut=nolut
;           pltmsk=pltmsk
;ARGS:
;lun:     int  file descriptor to input from. No file positioning done.
;
;KEYWORDS for plotting:
;
;vel:          if set then plot x axis is velocity. default topocentric freq.
;pol:     char limit plots to just 1 polarization (if multiple pols per 
;              board). 'a' for polA  or 'b' for polB. default is both pols. 
;brdlist: long specify the boards to use. Count 1..4 (or 1..8 with alfa).
;              To use brds 1,2,3,4 use brdlist=1234 . This replaces
;              pltmask=
;df:           if set then remove digital filter bandpass from average spectra
;
;KEYWORDS for screen layout: 
;
;norms:        if set then don't display rms plots
;nospectra:    if set then don't display individual spectra
;noimg:        if set then don't display the image.
;maxrecs: int  max number of records in a scan (for image or rms). By
;              default the routine allows up to 300 recs. If your
;              scans have more than 300 recs then set maxrecs to the
;              maximum number you will have (but not too much bigger since
;              it will allocate a buffer to hold an entire scan).
;recsimg: int  minimum numbers or records for an image to be made. Def:40
;recsrms: int  minimum numbers or records for rms to be made. Def:10
;spcavg:  int  if non zero then also plot avg spectra. Update average plot
;              every spcavg recs. 1--> redisplay average every record.
;                                 2--> redisplay average every 2 recs etc..
;base:    int  if non zero then remove baseline of order "base" from 
;              average spectra. Ignore edgefr fraction of bandpass on 
;              each side
;edgefr[n]:flt fraction of bandpass on each side to ignore in fit. If
;              n=1 then use edgefr[0] for both edges. If n=2 then use [0]
;              for the left edge and [1] for the right edge. If edgefr is
;              not supplied, then use .15 if not /df and .1 if /df set.
;
;KEYWORDS for image:
;
;imgpol:string 'a' or 'b' polarization of image to display (if multiple pols
;              per board). default is polA
;ravg:    int   use a running average of (ravg) spectra for the bandpass
;              correction. The default is to average over the entire scan.
;              Note that for position switched spectra, the display
;              of the combined on,off image will always use the mean
;              of the off for the bandpass correction.
;col[2]:  int  average frequency channels between col[0] and col[1] and then
;              divide the image by this. flattens the image in the time 
;              direction.
;clip[2]: flt  By default the image max/min display is scaled to .02
;              of Tsys. The clip[2] will clip the display to the min,max of
;              clip[0],clip[1].
;imgmedian:    If set (/imgmedian) then use the median rather than the mean
;              when computing the bandpass correction (for flattening the
;              image). This helps if there is strong continum in the image.
;vonoff[2]:flt images of on/off position switching will include a lineplot
;              of [(on/off-1) - median(on/off-1)]. The default vertical scale
;              for this plot is +/- .005 Tsys (25Mhz, 1024 channels, and 
;              300 secs on gives a noise sigma of .0005). veronoff[2] lets 
;              you change the min,max to veronoff[0],veronoff[1].
;vrms[2]: flt  min, max value for rms plot. default is autoscale
;cont:         if set then don't remove the continuum from the on/off line
;              plot that is drawn on top of the image. Normally the plot
;              is (on/off-1) - median(on/off-1). Setting this keyword plots
;              (on/off-1). You will probably have to also use veronoff[] to
;              keep the drawing within the yaxis range. 
;vavgspc[2]:flt min, max value for plot of average spectra. If you have
;              baslined it then it should be about zero.
;nolut:        by default the routine will load a linear grey scale ramp 
;              into the color lookup table (lut) for the image. If you have 
;              already loaded the lut (eg xloadct) then /nolut will tell 
;              this routine to not modify the lut.
;
;KEYWORDS misc:
;sl[]: {scanlist} The scanlist returned by getsl() can be used to
;              speed the processing of the file.
;step:         if set then prompt the user to continue after each scan.
;han:          if set then hanning smooth the data on input
;scan:    long position to scan before monitoring
;pltmsk:  int  replaced by brdlist=
;              bitmask to display a subset of the boards.
;              1 brd1, 2 brd2, 3 brd1&brd2, 4 brd3, 5 brd1&brd3,6 brd2&brd3,
;              7 brd1&brd2&brd3, 8 brd4,9 brd1&brd4,10 brd4&brd2...
;
;DESCRIPTION:
;   cormonall processes a file displaying the individual spectral records,
;the rms by channel of each scan, an image of frequency by time for
;each scan, and a running average and final average of the spectra. 
;
;   The data is read from the file descriptor lun. It must be opened
;prior to calling this routine. The program starts reading from the current
;position in the file. Use rew,lun or print,posscan(lun,scan) if you want
;to position the file before processing. 
;
;   By default all spectral records are displayed, all scans with more than 
;10 records will have the rms by channel computed, and all scans with 40 
;records or more will have an image made. The norms, nospectra, noimg keywords
;can be used to not display one or more of these options.
;   To include the running and final average of the spectra use the keyword 
;spcavg. It will display the running  average every spcavg records. Two
;windows will be generated: one for the running average of a scan and a 
;second for the complete scan average. Scans with 1 record are not averaged.
;These two window occupy the same screen area as the image display.
;
;   If images are to be plotted the color lookup table (lut) will be
;loaded with a greyscale linear ramp. If you have already loaded the
;lut (eg with xloadct) then /nolut will tell the program to not touch
;the current values.
;
;   The routine will processes all of the records in a file and then wait
;for the file to grow so the next record can be displayed. You can hit
;any key and the program will prompt you to enter return to continue or
;q to quit. This allows you to stare at a plot or image for awhile before
;it gets overwritten.
;
;   You can limit the number of boards displayed with the brdlist= keyword.
;To display only boards 1,2, and 3 use brdlist=123
;
;   SPECTRA/RMS/AVG
;   The spectra, rms, and average windows are plotted versus topocentric
;velocity. The vel keyword can switch this to velocity (this keyword does not 
;affect the image x axis). The vrms and vavgspc can be used to change the 
;vertical scale of the rms plot and the average spectra plot.
;
;   IMAGES
;   An image of each scan with more than 40 records is made (unless /noimg
;is selected). If two polarizations per board are taken then the image will
;default to pol A. The imgpol keyword lets you choose the other polarization. 
;The image will be bandpas corrected by the mean spectra of the entire scan
;(or median if /median is supplied). The display range is scaled to 
;+/- .02 Tsys. You can change this range with the clip keyword. You can
;flatten the image in the time direction with the col (columns) keyword. 
;It will average over these columns and then divide this into the image.
;
;   If on/off position switch  data is found then the images work a little
;differently. The first image to appear is the on. The second image has the
;on records in the bottom half of the image and the off records in the
;top half of the image. The average off scan is used for the bandpass 
;correction for both the entire image (on and off scans)
;
;   A line plot is overplotted in the center of the image. It is:
;
;   (on/off-1) - (median(on/off-1))
;
;The default vertical scale for this plot is +/-.005 Tsys. You can change
;the range with the vonoff keyword. By default any continuum in the on or 
;off is removed (via the -median(on/off-1). The /cont keyword will leave the 
;continuum in the line plot. You will probably have to use the vonoff[] 
;keyword to readust the vertical scale.
;
;EXAMPLES:
;; load the grey scale lookup table
;   loadct,0
;; open a file and display it..
;   openr,lun,'/share/olcor/corfile.29may02.p1525.1',/get_lun
;;   default call
;   cormonall,lun
;;  at the end of the file, hit a key to get the prompt back, then enter
;;  q to exit the routine
;
;; change the dynamic range of the image to +/-.01 Tsys. blowup any
;; on/off-1 plots to .004 Tsys
;; only plot sbc 1 and 3 
;   rew,lun
;   cormonall,lun,clip=[-.01,.01],vonoff[-.004,.004],brdlist=13
;
;
;SEE ALSO:
;   The routine calls corplot,corrms,corimgdisp,and corimgonoff
;-
;history
;15sep02 - added digital filter bandpass removal.
;19dec02 - changed min img recs to 40 for katy flint.
;10jan03 - by default we now call loadct,0
;08jun04 - apply vavgspc to the normal spectra too
;12nov04 - converted to work with interim  cor and was data (except
;          was data does not work on the online file because of positioning
;          problems in the fits file while it is being written).
;        - deprecated pltmsk=, converted to brdlist=
;        - brdlist= now also applies to the image.
;29jan05 - was check pltmsk and setting default before setting
;          brdlist
;
pro cormonall,lun,sl=sl,norms=norms,nospectra=nospectra,noimg=noimg,step=step,$
               col=col,brdlist=brdlist,vel=vel,pol=pol,imgpol=imgpol,ravg=ravg,$
               clip=clip,vonoff=vonoff,cont=cont,han=han,vrms=vrms,scan=scan,$
               spcavg=spcavg,base=base,vavgspc=vavgspc,df=df,edgefract=edgefr,$
               recsimg=recsimg,recsrms=recsrms,maxrecs=maxrecs,$
               imgmedian=imgmedian,pltmsk=pltmsk
    forward_function checkkey

;    on_error,1
    if not keyword_set(maxrecs) then maxRecs=300L
    minRecsRms=10L
    minRecsImg=40L
    if n_elements(recsimg) gt 0 then minRecsImg=recsimg
    if n_elements(recsRms) gt 0 then minRecsRms=recsrms
    usewas=wascheck(lun)
    nrecsB =lonarr(2)
    dospectra=1
    doavgspc=0
    dorms=1
    doimg=1
    posOnScan =3
    posOffScan=4
    if n_elements(edgefr) eq 0 then begin
        edgefr=.15
        if keyword_set(df) then edgefr=.1
    endif
    labScanType=[$
    'regular scan','calOn','calOff','Position switch on','Position switch Off']
;-----------------------
;   setup the screen layout for the windows
;
    a=get_screen_size()
    screenx=a[0]
    screeny=a[1]
    winimg    =1 
    winrms    =2 
    winavg    =3 
    winavgl   =4 
    winspectra=0 
    if keyword_set(noimg)    then begin
        doimg=0
        plxlen=screenx*.46
    endif else begin
        plxlen=screenx*.4
    endelse
    plylen=screeny*.5
    plxpos  =-5
    pl3xpos =screenx-plxlen-5
    pl1ypos=30
    pl2ypos=pl1ypos+plylen
    pl3ypos=pl1ypos
    imgxlen=screenx-(plxlen+plxpos)
    imgylen=800
    imgxpos=plxlen+plxpos
    imgypos=screeny-imgylen
    if keyword_set(norms)    then dorms=0
    if keyword_set(spcavg)    then begin
        doavgspc=1
        pltavgevery=spcavg
    endif
    if keyword_set(nospectra) then dospectra=0
    if not keyword_set(step) then step=0 
    if not keyword_set(clip) then clip=0
    if not keyword_set(vonoff) then vonoff=0
    if not keyword_set(cont) then cont=0
    if not keyword_set(base)  then base=0
    useVrms=0
    useVavgspc=0
    if n_elements(vrms) eq  2 then useVrms=1
    if n_elements(vavgspc) eq  2 then useVavgspc=1
    if dospectra then window,winspectra,$
        xpos=plxpos,ypos=pl1ypos,xsize=plxlen,ysize=plylen
    if dorms then window,winrms,$
        xpos=plxpos,ypos=pl2ypos,xsize=plxlen,ysize=plylen
    if doimg then begin
        window,winimg,xsize=imgxlen,ysize=imgylen,xpos=imgxpos,ypos=imgypos
        if not keyword_set(nolut) then loadct,0
    endif
    if doavgspc then begin
        window,winavg,$
        xpos=pl3xpos,ypos=pl3ypos,xsize=plxlen,ysize=plylen
        window,winavgl,$
        xpos=pl3xpos,ypos=pl2ypos,xsize=plxlen,ysize=plylen
    endif
;-----------------------
    if n_elements(col) eq 0 then col=0
    if n_elements(pol) eq 0 then pol='a'
    case 1 of
            (pol eq 'a') or (pol eq 'A'):lpol=0
            (pol eq 'b') or (pol eq 'B'):lpol=1
            else: message,'pol keyword = "a" or "b"'
    endcase
    if not keyword_set(imgpol) eq 0 then imgpol=1
    if n_elements(vel) eq 0 then vel=0
    if n_elements(han) eq 0 then han=0
    if (n_elements(pltmsk) ne 0) and (n_elements(brdlist) eq 0) then begin
        ival=1L
        brdlist=0l
        for i=0,7 do begin
            if (pltmsk and ival) ne 0 then brdlist=brdList*10L + i + 1
            ival=ival*2L
        endfor
    endif
;
    if n_elements(pltmsk) eq 0 then pltmsk=(usewas)?127:15
    sluse=0
    if (n_elements(sl) gt 1) or (usewas)  then begin
        sluse=1
        slnumscans=(usewas)?lun.totscans: n_elements(sl)
        slscan=0
        slrec =0
    endif
    saveScans=dorms or doimg
    curscan  =0         ; we've input and plotted..
    nrecsB[0]=0
    nrecsB[1]=0
    indB=0                  ; start storing in first 
    scanDone=0              ; finished this scan, found a new 1
    curScanType=0
    lastScanType=0
    filedone=0
    ch=checkkey()           ; flush any chars there.
    maxwait=2               ; 2 secs
    if keyword_set(scan) then begin
        if sluse then begin
            ind=(usewas)?where(lun.scanI.scan eq scan,count)$
                        :where(sl.scan eq scan,count)
            if count eq 0 then begin
                print,'scan:',scan,' not in file
                return
            endif
            slscan=ind[0]
            slnumscans=slnumscans-ind[0]
            istat=(usewas)?posscan(lun,scan,1)$
                          :posscan(lun,scan,1,sl=sl)
        endif else begin
            istat=posscan(lun,scan,1)
            if istat ne 1 then begin
                print,scan,' not in file'
                return
            endif
        endelse
    endif
;
;   loop here
;
    recsavged=0L            ; in case averaging spectra
    for i=0L,99999L do begin
;
;   running without scan list
;
        if not sluse then begin     
;
;       loop waiting for a rec
;       let them head out, continue, or head out plottting last
;
           repeat begin
              istat=waitnxtgrp(lun,maxwait)
              if (istat  ne 0)  then begin
                if istat eq -2 then begin
                    print,"waitnxtgrp error. istat",istat
                    return
                endif
                ch=checkkey()
                if ch ne '' then begin
                    print,'q to quit, l plot last and quit, return to continue'
                    ch=checkkey(/wait)
                    if ch eq 'q' then goto,done
                    if ch eq 'l' then  begin
                        fileDone=1          ; check for final scan
                        goto,donescan
                    endif
                    print,'..continuing'
                endif
              endif
            endrep until istat eq 0
            point_lun,-lun,a
            istat=corget(lun,b,han=han)
            if istat ne 1 then return
         endif else begin
;           new scan , position
;           print,slscan,slrec,sl[slscan].scan,sl[slscan].numrecs
            istat=1
            recsInScan=(usewas)?lun.scanI[slscan].recsinscan:sl[slscan].numrecs
            if (slrec ge recsInScan) then begin
                slscan=slscan+1
                if slscan ge slnumscans then begin
                    filedone=1
                    goto,donescan
                endif
                scanTemp=(usewas)?lun.scanI[slscan].scan:sl[slscan].scan
                istat=posscan(lun,scanTemp,1,sl=sl)
                slrec=0
            endif
            if istat eq 1 then istat=corget(lun,b,han=han)
            if istat ne 1 then begin
                scanTemp=(usewas)?lun.scanI[slscan].scan:sl[slscan].scan
                print,'scan:',scanTemp,' not in file'
                return
            endif
            slrec=slrec+1
        endelse
;    --------------------
;    see if we save scans
;
        if saveScans then begin
;
;           same scan just add to array
;
            if curscan eq 0 then begin      ; first time through allocate
                bb=corallocstr(b[0],maxrecs*2)
                bb=reform(bb,maxrecs,2,/overwrite)
                curscan=b.b1.h.std.scannumber
                curScanType=scantype(bb[0,indB].b1.h)
                print,string(b.b1.h.proc.srcname),' scan:',curScan,' ',$
                    labScanType[curScanType]
            endif 
            if (curscan eq b.b1.h.std.scannumber) then begin
                if nrecsB[indB] lt maxRecs then $
                corstostr,b,b.b1.h.std.grpnum-1L+maxRecs*indB,bb
                nrecsB[indB]=nrecsB[indB]+1
            endif
         endif
;
;-------------------------------------------------- --------------------
;   end of scan processing, avg,rms, img plots
;
donescan:
    scandone=(curscan ne 0) and (curscan ne b.b1.h.std.scannumber) or $
        filedone
    if scanDone then begin
;
;       plot rms
;
    
        if dorms and (nrecsB[indB] ge minRecsRms) then begin
            wset,winrms
            if usevrms then begin
                ver,vrms[0],vrms[1]
            endif else begin
                ver
            endelse
            nrecs=  maxrecs<nrecsB[indB]
            brms=corrms(bb[0:nrecs-1,indB])
            corplot,brms,brdlist=brdlist,vel=vel,pol=lpol,extitle=' SCAN RMS'
            ver
        endif
;
;       do img 
;
        if doimg and (nrecsB[indB] ge minRecsImg) then begin
;
;        check if pos on/off done
;
            curScanType=scantype(bb[0,indB].b1.h)

            if (curScanType eq posOffScan) and $
               (lastScanType eq posOnScan) then begin
                wset,winimg
                non = nrecsB[0] < maxrecs
                noff= nrecsB[1] < maxrecs
                ball=corimgonoff(0,0,/red,/han,col=col,$
                     bon=bb[0:non-1,0],boff=bb[0:noff-1,1],$
                    win=winimg,wxlen=imgxlen, wylen=imgylen,wxpos=imgxpos,$
                    wypos=imgypos,pol=imgpol,clip=clip,ver=vonoff,cont=cont)
            endif else begin
                nrecs= nrecsB[0] < maxrecs
                img=corimgdisp(bb[0:nrecs-1,0],wxlen=imgxlen,wylen=imgylen,$
                           wxpos=imgxpos,wypos=imgypos,pol=imgpol,clip=clip,$
                           col=col,ravg=ravg,median=imgmedian,brdlist=brdlist)
            endelse
        endif
;
;       output average spectra
;
        if doavgspc and (recsavged gt 1) then begin
            if useVavgspc then begin
                ver,vavgspc[0],vavgspc[1]
            endif else begin
                ver
            endelse
            wset,winavgl
            if base ne 0 then begin
                svd= base gt 8
              istat=corbl(bavg,bl,deg=base,svd=svd,/auto,/sub,edgefr=edgefr)
              corplot,bl,brdlist=brdlist,vel=vel,pol=lpol,$
                        extitle=' Scan Avg'
            endif else begin
                corplot,bavg,brdlist=brdlist,vel=vel,pol=lpol,$
                        extitle=' Scan Avg'
            endelse
        endif

        recsavged=0
        scandone=0
        if filedone then goto,done
;
;       update for new scan
;
        lastScanType=curScanType
        curScanType=0
        if (string(b.b1.h.proc.procname) eq 'onoff') then begin
            car0=string(b.b1.h.proc.car[*,0])
            if car0 eq 'on'  then curScanType=posOnScan
            if car0 eq 'off' then curScanType=posOffScan
         endif
         if (curScanType eq posOffScan) and (lastScanType eq posOnScan) $
            then begin
            indB=1
         endif else begin
            indB=0
            bb=corallocstr(b,maxrecs*2)
            bb=reform(bb,maxrecs,2,/overwrite)
         endelse
         corstostr,b,0+indB*maxrecs,bb
         nrecsB[indB]=1
         curscan=b.b1.h.std.scannumber
         curScanType=scantype(b.b1.h)
         print,string(b.b1.h.proc.srcname),' scan:',curScan,' ',$
                labScanType[curScanType]

        if step then begin
            print,'return to continue,q to quit'
            test=' '
            read,test
            if test eq 'q' then goto,done
        endif
     endif   ; done scan
;
;-------------------------------------------------- --------------------
;   individual record plotting
;
     curscan=b.b1.h.std.scannumber
     if dospectra then begin
        if useVavgspc then begin 
            ver,vavgspc[0],vavgspc[1]
        endif else begin
            ver
        endelse
        wset,winspectra
        corplot,b,brdlist=brdlist,vel=vel,pol=lpol,extitle=' Single Rec'
     endif
;
;   output running avg of spectra
;
     if doavgspc then begin
;;      print,'recsavg:',recsavged,' avglast:',recsavgedlast
        if recsavged eq 0 then begin
            if keyword_set(df) then begin
                dfbp=cordfbp(b)
                b=cormath(b,dfbp,/div)
            endif
            coraccum,b,bavg,/new
        endif else begin
            if keyword_set(df) then begin
                b=cormath(b,dfbp,/div)
            endif
            coraccum,b,bavg
            bavg.b1.h.std.grpNum=b.b1.h.std.grpnum
            bavg.b1.h.std.time  =b.b1.h.std.time
        endelse
        recsavged=recsavged+1
;
;       display averaged rec on the second record
;
        if (recsavged gt 1) and  ((recsavged mod  pltavgevery) eq 0) then begin
            if useVavgspc then begin
                ver,vavgspc[0],vavgspc[1]
            endif else begin
                ver
            endelse
            wset,winavg
            if base ne 0 then begin
                svd= base gt 8
                istat=corbl(bavg,bl,deg=base,svd=svd,/auto,/sub,edgefr=edgefr)
                corplot,bl,brdlist=brdlist,vel=vel,pol=lpol,$
                    extitle=' Running Avg'
            endif else begin
                corplot,bavg,brdlist=brdlist,vel=vel,pol=lpol,$
                    extitle=' Running Avg'
            endelse
        endif
     endif

     ch=checkkey()
     if ch ne '' then begin
        print,'q to quit, return to continue'
        ch=checkkey(/wait)
        if ch eq 'q' then goto,done
    endif
    endfor
done:
    return
end
