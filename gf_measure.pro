; docformat = 'rst'
;+
; NAME:
;  gf_measure.pro	;   reduce and measure stacked spectrum (after gf_stack.pro)
;
;
; CATEGORY:
;   Data anaysis, ALFALFA software
;
;
; CALLING SEQUENCE:
;    GF_MEASURE, 'directoryname'
;
;
; PURPOSE:
;   Reduce and measure stacked spectrum (after gf_stack.pro)
;
;
; INPUTS:
;   'name': of the file/directory already used in the stacking
;
;
; PROCEDURE:
;
;   0 - Restore the main "stack" structure.
;
;   1 - Smooth the spectrum: a default Hanning smoothing over 2 channels is applied
;       the user can then boxcar smooths over N channels.  
;
;   2 - Subtract a baseline.
;
;   3 - Save measured spectrum to file.pdf
;
;   3 - Flag the edges of the emission.
;
;   4 - Evaluate the signal as integral inside the profile or
;       evaluate the signal of non-detections (300 km/s ms > 10^10Msol; 200km/s ms <= 10^10Msol) using rms value
;
;   5 - Save output.
;
;
; FUNCTIONS CALLED:
;
;   f_bmask - Set mask for baseline measurement
;
;   rms_mask - Set mask for rms measurement
;
;   b_fit - Fit baseline
;
;
; OUTPUTS:
;
;   'name/.sav':  modified file containing the STACK structure. Changed fields are:
;
;               RED  = Left/right edges of the profile as flagged by the user (channels)
;
;               RMS = average rms polA, average rms polB
;
;               S, MHI,GF = Total fluxes/gas fractions
;
;               SN = flx,mhi,gf  S/N evaluated following Saintoinge, and peak/rms
;
;               SPEC = final stacked spectrum
;
;               detflag =  flag if stack is detection (1) or non-detections (0), default detection, changed in HI_measure
;
;
; 'name_LOG.dat':  additional information about reduction appended:	
;           Polynomial order of fitted baseline; smoothing; S/N [ALFALFA]; edges of signal; measured signal
;
;
; EXAMPLE:
;
;   > .r gf_measure.pro  
;
;   > GF_MEASURE, 'sample'
;       Reads STACK structure from 'gf_stack.pro' galaxies, reduce and measure stacked spectrum.
;
;
; COMMENTS:
;   Consult ALFALFA team (Haynes and Giovanelli) before publishing. - TB
;
;
; MODIFICATION AND OWNERSHIP HISTORY:
;   Written by: Silvia Fabello (April 2009).
;
;   Current Version by: Toby Brown (June 2014). 
;
;   March 2010  Finalized for ALFALFA
;
;   September 2014 impoved compatibity with 'gf_stack.pro', bug fixes 
;
;   January 2015 added in upper limit calculation for non-detections
; 
;
;-
;;Set mask for baseline measurement
pro f_bmask,bmask,nchn
  repeat begin
    print, 'Left click LEFT end of baseline box, right click to exit...'
    cp, x=x, y=y
    xpos1=round(x)
    if (xpos1 lt 0.) then xpos1 = 0.
    wait, 0.5
    if (!mouse.button eq 4) then goto, get_out
    print, 'Left click RIGHT edge of baseline box...'
    cp, x=x, y=y
    xpos2=round(x)
    if (xpos2 gt nchn-1) then xpos2=nchn-1
    wait, 0.5
    bmask[xpos1:xpos2]=1
  endrep until (!mouse.button eq 4)
  get_out:
end

;;Fit baseline
pro b_fit,bmask,nchn,norder
   get_order:
  print,'Enter poly order:'
  read_norder:
  read, norder
  if (norder gt 11) then begin
    print,'Fit order =',norder,' is a bit extreme; enter value <12'
    goto, read_norder
  endif
end

;;Set mask for rms measurement
pro rms_mask,mask,nchn
 repeat begin
     print, 'Left click LEFT end of rms box, right click to exit...'
     cp, x=x, y=y
     xpos1=round(x)
     if (xpos1 lt 0.) then xpos1 = 0.
     wait, 0.5
     if (!mouse.button eq 4) then goto, endloop
     print, 'Left click RIGHT edge of rms box...'
     cp, x=x, y=y
     xpos2=round(x)
     if (xpos2 gt nchn-1) then xpos2=nchn-1
     wait, 0.5
     mask[xpos1:xpos2]=1
 endrep until (!mouse.button eq 4)
endloop:
end


;-------------------MAIN--------------------------
pro GF_MEASURE, output

!EXCEPT=2 
HIfreq=1420.405751786D
lightsp=299792.458D
deltaf=0.024414063

xbin_tot = 5
ybin_tot = 5
; read, xbin_no, prompt='How many structures do you want to restore? (i.e. no. of bins) '

CDFchoice = 'N'
CDFchoice_str = ['','Are you measuring flux in cumulative distribution function (CDF) bins?',$
                     '(Y/N)', '']
print, CDFchoice_str, FORMAT='(A)' 
read, CDFchoice ,prompt=''
CDFchoice = strmid(strupcase(CDFchoice),0,1)

for j=0,xbin_tot-1 do begin
    xbin_no = STRCOMPRESS((j + 1), /remove_all)
    for k=0,ybin_tot-1 do begin
    	
        ybin_no = STRCOMPRESS((k + 1), /remove_all)
        print, 'Beginning bin number ' +xbin_no+'-'+ybin_no

        ; Establish error handler. When errors occur, the index of the
        ; error is returned in the variable Error_status:
        CATCH, Error_status

        ;This statement begins the error handler:
        IF Error_status NE 0 THEN BEGIN
            PRINT, 'Error index: ', Error_status
            PRINT, 'Error message: ', !ERROR_STATE.MSG
            ; Handle the error by extending A:
            
            CATCH, /CANCEL
            goto, nogalaxies
        ENDIF

        IF CDFchoice EQ 'Y' THEN BEGIN
            logFile = output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'_LOG.dat'
            file=output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
        ENDIF ELSE BEGIN  
            logFile = output+'/'+output+'_bin_'+xbin_no+'_LOG.dat'
            file=output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
        ENDELSE

        restore, file

        case stack.hd.input[2] of    ;which quantity has been stacked
            1: begin                  ;flux
                speca=double(stack.speca.flx)
                specb=double(stack.specb.flx)
            end
            2: begin               ;M_HI
                speca=double(stack.speca.mhi)
                specb=double(stack.specb.mhi)
            end
            3: begin                  ;M_HI/M_*
                speca=double(stack.speca.gf)
                specb=double(stack.specb.gf)
            end
        endcase

        nused=stack.nused[0]
        nchn=N_ELEMENTS(speca)
        xarr=findgen(nchn)
        velarr=lightsp*(HIfreq/(HIfreq+deltaf*(511-xarr))-1)
        bmask=intarr(nchn)
        maskA=intarr(nchn)
        maskB=intarr(nchn)
        basecoef=dblarr(12)
        hor
        ver
        window,xsize=900,ysize=600
        case stack.hd.input[2] of    ;which quantity has been stacked
            1: yt=textoidl('mJy\cdot (km/s)^2')
            2: yt=textoidl('mJy\cdot (km/s)^2 Mpc^2') 
            3: yt=textoidl('mJy\cdot (km/s)^2 Mpc^2 / M_sol') 
        endcase
        ;;PO3A
        !P.MULTI = [0, 1, 2]
        plot, speca,title='pol A',ytitle=yt,charsize = 3 ,yrange=[1.2*min(speca),1.2*max(speca)]
        oplot,[511,511],[1.2*min(speca),1.2*max(speca)], linestyle=2
        click= ' '
        ; read,click,prompt='Enter to continue...'
        ;;POLB
        ;;Change the vertical scale if necessary
        hor
        ver
        plot,specb,title='pol B',ytitle=yt,charsize = 3 ,yrange=[1.2*min(specb),1.2*max(specb)]
        oplot,[511,511],[1.2*min(specb),1.2*max(specb)], linestyle=2
        ; read,click,prompt='Enter to continue...'

        print,'--- Averaged spectrum ---'
        ;;;FINAL SPEC
        hor
        ver
        spec=(specA+specB)/2.
        plot,spec,ytitle=yt,charsize = 3 ,yrange=[1.2*min(spec),1.2*max(spec)]
        oplot,[511,511],[1.2*min(spec),1.2*max(spec)], linestyle=2
        print,min(spec),max(spec)

        ysc='n'
        ;read, ysc, prompt='Rescale vertical axis? [y/N] '
        print, ''
        if (ysc eq '') then ysc='n'
        ysc=strmid(strlowcase(ysc),0,1)

        if (ysc eq 'y') then begin
           doysc:
           a=0.
           b=0.
           read, a, b, prompt='Enter desired ymin and ymax (e.g.: 1,5): '
           ver, a, b
           plot,spec,ytitle=yt,charsize = 3
           oplot,[511,511],[a,b], linestyle=2
           ans='y'
           read,ans,prompt='OK? [Y/n]'
           if (ans eq '') then ans='y'
           ans=strmid(strlowcase(ans),0,1)
           if (ans eq 'n') then  goto,doysc
        endif else begin 
           a=1.2*min(spec)
           b=1.2*max(spec)
        endelse


        ;;----------------------------------------
        ;; BOXCAR SMOOTHING
        specnew=hans(3,spec)
        print,'Permormed an Hanning smoothing over 2 channels.'

        boxcarsm:
        !P.MULTI=0
        plot,specnew,ytitle=yt,charsize = 3
        oplot,[511,511],[a,b], linestyle=2
        smo=5
        print, "Boxcar smoothing. Enter # of channels to smooth by (odd number): "
        ;read, smo
        specnew1=smooth(specnew,smo)
        hor
        ans=''
        plot,specnew1,ytitle=yt,charsize = 3
        oplot,[511,511],[a,b], linestyle=2
        ans='y'
        ;read,ans,prompt='OK? [Y/n]'
        if (ans eq '') then ans='y'
        ans=strmid(strlowcase(ans),0,1)
        if (ans eq 'n') then  goto,boxcarsm
        specnew= specnew1

        ; BASELINE FITTING
        print,''
        print, 'BASELINE FITTING'
        print,''
        f_bmask,bmask,nchn
        b_fit,bmask,nchn,norder
        indb=where(bmask eq 1)
        fit_base:
        bcoef=poly_fit(xarr[indb],specnew[indb],norder)
        yfit=poly(xarr,bcoef)
        basecoef[0:norder]=bcoef
        oplot,yfit
        ansb='y'
        read,ansb,prompt='Baseline OK? [Y/n]'
        if (ansb eq '') then ansb='y'
        ansb=strmid(strlowcase(ansb),0,1)
        if (ansb eq 'n') then begin
            plot,specnew,ytitle=yt,charsize = 3
            oplot,[511,511],[a,b], linestyle=2
            oplot,fltarr(nchn),linestyle=1
            b_fit,bmask,nchn,norder
            indb=where(bmask eq 1)
            goto,fit_base
        endif
        spec=specnew-yfit
        plot,spec ,ytitle=yt,charsize = 3 
        oplot,[511,511],[a,b], linestyle=2
        oplot,fltarr(nchn),linestyle=1

        rms= stddev(spec[indb])
        
        ;;----------------------------------------
        ;; Check if the stack is a non detection
        ; Evaluate the signal of non-detection (300 km/s ms > 10^10Msol; 200km/s ms <= 10^10Msol) using rms value
        detflag='y'
        detflag_n=1
        read, detflag, prompt='Is the stack a detection? [Y/N] '
        print, ''
        if (detflag eq '') then detflag='y'
        detflag=strmid(strlowcase(detflag),0,1)

        IF (detflag eq 'n') then begin
            ; rms= stack.rms_gf[0]
            totSerr_tot = 0
            TOTSERR_SYS = 0
            detflag_n=0
            ; print, 'rms = ', rms
            ;;MEASURE Signal upper limit
            w=300. ;; set velocity width 300 km/s for ms > 10^10Msol; 200km/s for ms <= 10^10Msol
            mean_ms = stack.MEAN_BINP[0]
            IF (mean_ms le 10) then w = 200.
            vch=FIX(0.5*(N_ELEMENTS(velarr)))
            dv=abs(velarr[vch]-velarr[vch+1]) ;channel width in km/s
            print, dv
            dv_smo=dv*sqrt(smo*smo+2.0*2.0)   ; vel. res. of Hanning + boxcar smoothed spectrum
            totS=double(rms*w*smo)
            totSerr=double(rms*dv*sqrt(60))
            totSerr_S05=double(2.*rms*sqrt(1.4*w*dv_smo)) ; CU HI archive definition (Springob+ 2005, eqn. 2)
            goto, exitmeasure
        ENDIF

        ;----------------------------------------
        ; Plot stack spec of jacknife.
        
        ; plotdir = '/mnt/cluster/kilborn/tbrown/TOBY_STACKING/TSTACK/plots/error_testing/'
        ; cgPS_open, plotdir +$
        ;     'HI_measure_bin'+xbin_no+$
        ;         '.pdf',$
        ; XSIZE = 11.4, XOFFSET = 0., YOFFSET = 0., YSIZE = 8.692, /landscape
        ; !P.CHARSIZE = 2
        ; !P.CHARTHICK = 1
        ; !P.FONT =0
        ; !P.THICK  = 10
        ; !X.THICK = 3
        ; !Y.THICK = 3
        
        ;cgText, 0.25,0.75, 'Bin number '+ bin_str ,COLOR='dodgerblue', /NORMAL
        
        ; cgPLOT, velarr, spec,CHARSIZE = 2,$
        ;     TITLE='Spectra for bin ='+xbin_no, $
        ;         XTICKS = 7, XMINOR = 4, YTICKS = 0,$ 
        ;             CHARTHICK = 1,$
        ;                 XTITLE = 'Velocity [km/s]',$
        ;                     YTITLE = 'S [mJy]', yrange=[-1e-6, 1e-6]

        ; cgText, 0.2, 0.8, STRCOMPRESS(NUSED) + ' spectra',COLOR='black', /NORMAL

        ; CgOPLOT,velarr, fltarr(N_ELEMENTS(velarr)),linestyle=1
        ; cgPS_Close

        ;----------------------------------------  
       
       
       
       
        ;;MEASURE Signal
        ;;zoom in spectrum first
        plot,spec,ytitle=yt,charsize = 3  
        oplot,[511,511],[a,b], linestyle=2
        print,' '
        print,'Left click LEFT and RIGHT channel limits for plot'
        cp, x=x, y=y
        hor1=round(x)
        wait,0.5
        cp, x=x, y=y
        hor2=round(x)
        wait,0.5
        hor,hor1,hor2
        y_min=min(spec[hor1:hor2])
        y_max=max(spec[hor1:hor2])
        ver,y_min-0.2*(y_max-y_min),y_max+0.2*(y_max-y_min)

        ;;Flag channels corresponding to edges [ch1,ch2] and peaks [chp1,chp2] of profile
        flagmsr:
        plot,spec,ytitle=yt,charsize = 3  
        oplot,[511,511],[a,b], linestyle=2
        oplot,fltarr(nchn), linestyle=2 ;y=0 dashed line
        print,' '
        print,'Flag edges of spectral feature to be measured:'
        print, 'Left click LEFT edge of feature'
        cp, x=x, y=y
        ch1=round(x)                 ;scientific round
        wait,0.5
        print, 'Left click RIGHT edge of feature'
        cp, x=x, y=y
        ch2=round(x)
        flag,[ch1,ch2], linestyle=1
        print,ch1,ch2,'chn'
        wait,0.5

        ;;flux
        w=abs(velarr[ch1]-velarr[ch2])
        vch=0.5*(ch1+ch2)
        dv=abs(velarr[vch]-velarr[vch+1]) ;channel width in km/s
        dv_smo=dv*sqrt(smo*smo+2.0*2.0)   ; vel. res. of Hanning + boxcar smoothed spectrum
        print, ''
        print, 'channels 1,2 ', ch1,ch2
        print, 'total spec ', total(spec[ch1:ch2])
        print, ''
        print, 'w = ', w, ' km/s'
        print, ''
        totS=double(total(spec[ch1:ch2])*dv)
        totSerr=double(rms*dv*sqrt(ch2-ch1))
        totSerr_S05=double(2.*rms*sqrt(1.4*w*dv_smo)) ; CU HI archive definition (Springob+ 2005, eqn. 2)
        peakS=double(max(spec[ch1:ch2]))
        print,'Serr ',totSerr
        print,'Serr S05 ',totSerr_S05

        ; SYSTEMATIC ERROR CAUSED BY CHOICE OF SIGNAL BOUNDARIES
        totSerr_sys=double(0.)
        totSerr_tot=double(0.)
        print, "Estimate systematic errors caused by choice of signal boundaries "
        print,'Flag new boundary edges: '
        print, 'Left click LEFT edge '
        cp, x=x, y=y
        chn1=x
        wait,0.5
        print, 'Left click RIGHT edge '
        cp, x=x, y=y
        chn2=x
        flag,[chn1,chn2], linestyle=1
        wait,0.5
        totSerr_sys= abs(totS- total(spec[chn1:chn2])*dv)/2. ; mJy km/s
        totSerr_tot=sqrt(totSerr_S05^2+totSerr_sys^2)
        
        exitmeasure: 
        smofac=W/(2.*dv_smo)            ; dv_smo= 10 km/s for ALFALFA, after han
        if (W gt 400.) then  smofac=400./(2.*dv_smo)
        stn=fltarr(4)
        stn[0]=(totS/W)*sqrt(smofac)/rms ; ALFALFA definition, width just width

        IF (detflag eq 'y') THEN stn[1]=peakS/rms

        print,'------------------------------------------------------------'
        print,' MEASURES '
        print,'------------------------------------------------------------'
        print,'n obj',nused
        print,' S/N [ALFALFA]:        ',stn[0]
        print,' S/N [peak/rms]:       ',stn[1]
        print,'------------------------------------------------------------'
       
        case stack.hd.input[2] of    ;which quantity has been stacked
        1: begin                  ;flux
            print,'flux [Jy]',totS/1000. ,' +/- ',totSerr_tot/1000. 
            ;;fill in structure
            stack.S.totS=totS
            stack.S.totSerr_sys3totSerr_sys
            stack.S.totSerr=totSerr_tot
            stack.spec.flx=spec
            stack.rms[2]=rms
            stack.rms[3]=rms/sqrt(150./dv_smo)
            stack.sn.flx=stn[0:1]
        end
        2: begin                   ;mhi
            mhi=double(2.356*10^4*10*totS/1000.) 
            mhi_err=double(2.356*10^4*10*totSerr_tot/1000.)
            print,'M_HI [M_sun]', mhi,' +/- ',mhi_err
            ;;fill in structure
            stack.MHI.totMHI=mhi
            stack.MHI.totMHIerr_sys=double(2.356*10^4*10*totSerr_sys/1000.)
            stack.MHI.totMHIerr= mhi_err
            stack.spec.mhi=spec
            stack.rms_mhi[0]=rms
            stack.rms_mhi[1]=rms/sqrt(150./dv_smo)
            stack.sn.mhi=stn[0:1]  
        end
        3: begin                   ;mhi/m*
            gf=double(2.356*10^4*10*totS/1000.)
            print,'TotS', totS
            gf_err=double(2.356*10^4*10*totSerr_tot/1000.)
            print,'M_HI/M* ',gf ,' +/- ',gf_err
            ;;fill in structure
            stack.GF.totGF=gf
            print,'LOG(M_HI/M*) ',ALOG10(stack.GF.totGF) ,' +/- ',gf_err
            ; stack.GF.totGFerr_sys=double(2.356*10^4*10*totSerr_sys/1000.)
            stack.GF.totGFerr=gf_err 
            stack.spec.gf=spec
            stack.rms_gf[0]=rms
            stack.rms_gf[1]=rms/sqrt(150./dv_smo)
            stack.sn.gf=stn[0:1]
            stack.detflag=detflag_n
        end
        endcase
      
        print,'------------------------------------------------------------'

        IF (detflag eq 'n') THEN stack.red.edge=[0,0] ELSE stack.red.edge=[ch1,ch2]        
        IF (detflag eq 'n') THEN stack.red.edge_err=[0,0] ELSE stack.red.edge_err=[chn1,chn2]
        stack.red.bmask=bmask
        stack.red.bord=norder
        stack.red.smooth=smo
        exitred:

        save,stack,file=file

        ;;Update Log file 
        print,'Reduction info appended to ', logFile

        openu,lun,logFile ,/get_lun,/append ; open the data file 4 update
        printf, lun,' '
        printf, lun, '-------------------------------------------------'
        printf, lun,'REDUCTION INFO'
        printf, lun,norder,format="('Baseline pol:  ',i2)"
        printf, lun,smo,format="('Boxcar smoothing:  ',i2)"
        printf, lun,stn[0],format="('S/N [ALFALFA]:  ',f4.1)"
         IF (detflag eq 'y') THEN printf, lun,chn1,chn2,format="('Signal edges [channels]:  ',i4,' - ',i4)"
        case stack.hd.input[2] of    ;which quantity has been stacked
            1: printf, lun,totS/1000.,totSerr_tot/1000.,format="('Measured flux [Jy]:  ',f6.2,' +/-',f6.2)"
            2: printf, lun,mhi,mhi_err,format="('Measured M_HI [Msun]:  ',e10.2,' +/-',e10.2)"
            3: printf, lun,gf,gf_err,format="('Measured M_HI/M*:  ',f5.3,' +/-',f5.3)"
        endcase
        if (stack.hd.input[3] eq 1) then printf, lun,stack.c_factor[1],format="('Correction for confusion (gf): ',f6.4)"

        close,lun, /ALL

        nogalaxies:

    endfor
endfor
end
