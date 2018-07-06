; docformat = 'rst'

;+
; The purpose of aa_measure is to reduce and measure stacked spectra produced 
; by aa_stack. 
;
; This procedure iteratively measures spectra for all bins (including 2D)
; contained in the specified directory.
; 
;
; :Author:
;    Toby Brown
;
; :History:
;    Written by Toby Brown (April 2017). Based upon routines written by Silvia Fabello (April 2009).
;
;
; :Examples:
;    aa_measure is a main level procedure included in aa_measure.pro::
;
;       IDL> aa_measure, 'path/to/aa_stack_output'
;
;    Iteratively restores and plots stacked spectra in 'aa_stack_output' directory to
;    screen, asks user for baseline fitting parameters and profile edges, saves output to 
;    original aa_stack structures.
;
;-

;+
; Store mouse click to set channel mask for baseline measurement
;
; :Private:
;-
pro f_bmask,bmask,nchn
  repeat begin
    print, 'Left click LEFT end of baseline box, right click to exit...'
    cursor, x, y, /DATA
    print, 'x=', x,'', 'y=', y
    xpos1=round(x)
    if (xpos1 lt 0.) then xpos1 = 0.
    wait, 0.5
    if (!mouse.button eq 4) then goto, get_out
    print, 'Left click RIGHT edge of baseline box...'
    cursor, x, y, /DATA
    print, 'x=', x,'', 'y=', y
    xpos2=round(x)
    if (xpos2 gt nchn-1) then xpos2=nchn-1
    wait, 0.5
    bmask[xpos1:xpos2]=1
  endrep until (!mouse.button eq 4)
  get_out:
end

;+
; Lower order polynomial baseline fitting.
;
; :Private:
;-
pro b_fit,bmask,nchn,norder,CDFchoice,ansb
    IF (CDFchoice EQ 'Y') AND (ansb EQ 'y') THEN BEGIN
        print,'Choosing 2nd order polynomial'
        norder = 2
    ENDIF ELSE BEGIN  
        get_order:
        print,'Enter poly order:'
        read_norder:
        read, norder
    ENDELSE
    if (norder gt 11) then begin
    print,'Fit order =',norder,' is a bit extreme; enter value <12'
    goto, read_norder
  endif
end

;+
; Store mouse clicks to set mask for rms measurement
;
; :Private:
;
; :Obsolete:
;-
pro rms_mask, mask, nchn
 repeat begin
     print, 'Left click LEFT end of rms box, right click to exit...'
     cursor, x, y, /DATA
     print, 'x=', x,'', 'y=', y
     xpos1=round(x)
     if (xpos1 lt 0.) then xpos1 = 0.
     wait, 0.5
     if (!mouse.button eq 4) then goto, endloop
     print, 'Left click RIGHT edge of rms box...'
     cursor, x, y, /DATA
     print, 'x=', x,'', 'y=', y
     xpos2=round(x)
     if (xpos2 gt nchn-1) then xpos2=nchn-1
     wait, 0.5
     mask[xpos1:xpos2]=1
 endrep until (!mouse.button eq 4)
endloop:
end

;+
; :Params:
;    stackingdir : in, required, type=string
;                of the output directory of aa_stack.pro
;
; :Description:     
;   Procedure
;   ---------
;
;       1. Require user to specify if 2D bins were used in aa_stack.pro
;
;       2. Restore the main "stack" structure.
;
;       3. Smooth the spectrum: a default Hanning smoothing over 3 channels is applied
;           the user can then boxcar smooths over N channels.  
;
;       4. Subtract a baseline.
;
;       5. Flag the edges of the emission.
;
;       6. Evaluate the signal as integral inside the profile or
;           evaluate the signal of non-detections (300 km/s ms > 10^10Msol; 200km/s ms <= 10^10Msol) using rms value
;
;       7. Save output back to original structure.
;
;       8. Repeat for other bins in output directory.
;
; 
;
;   Outputs
;   -------
;    'stackingdir/stackingdir_bin_no.sav' - Modified stack structure with the following updated::
;
;        RED         - Reduction parameters i.e. profile edges, baseline masks
;
;        RMS         - Average rms of stacked spectrum
;
;        S, MHI,GF   - Total flux, HI mass, gas fractions
;
;        detflag     - Flag if stack is detection (1) or non-detections (0)
;
;
;   'output_bin_no_LOG.dat' - additional information about reduction appended:    
;           Polynomial order of fitted baseline; smoothing; S/N [ALFALFA]; edges of signal; measured signal
;       
; :Uses: 
;    f_bmask, b_fit
;       
; :Bugs:
;    
;
; :Categories: 
;    Data analysis, ALFALFA software
;
;  
;-
pro aa_measure, stackingdir

!EXCEPT=2 
HIfreq=1420.405751786D
lightsp=299792.458D
deltaf=0.024414063

read, xbin_tot, prompt='Enter number of first parameter bins [5]: '
if (xbin_tot eq '') then xbin_tot=5
xbin_tot = fix(xbin_tot)
ybin_tot = 5
; read, xbin_no, prompt='How many structures do you want to restore? (i.e. no. of bins) '

CDFchoice = 'N'
CDFchoice_str = ['','Are you measuring flux in cumulative distribution function (CDF) bins?',$
                     '(y/N)', '']
print, CDFchoice_str, FORMAT='(A)' 
read, CDFchoice ,prompt=''
CDFchoice = strmid(strupcase(CDFchoice),0,1)

for j=0,xbin_tot-1 do begin
    xbin_no = STRCOMPRESS((j + 1), /remove_all)
    for k=0,ybin_tot-1 do begin
    	
        ybin_no = STRCOMPRESS((k + 1), /remove_all)
        print, ''
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
            logFile = stackingdir+'/'+stackingdir+'_bin_'+xbin_no+'-'+ybin_no+'_LOG.dat'
            file=stackingdir+'/'+stackingdir+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
        ENDIF ELSE BEGIN  
            logFile = stackingdir+'/'+stackingdir+'_bin_'+xbin_no+'_LOG.dat'
            file=stackingdir+'/'+stackingdir+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
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
        ; The blue-shift equation for velocity is: vrad/c=(1 - f0/f)=z/(1+z)
        velarr=lightsp*(HIfreq/(HIfreq+deltaf*(511-xarr))-1)
        bmask=intarr(nchn)
        maskA=intarr(nchn)
        maskB=intarr(nchn)
        basecoef=dblarr(12)
        ; hor
        ; ver
        window,xsize=1200,ysize=700
        case stack.hd.input[2] of    ;which quantity has been stacked
            1: yt=textoidl('mJy (km/s)^2')
            2: yt=textoidl('mJy (km/s)^2 Mpc^2') 
            3: yt=textoidl('mJy (km/s)^2 Mpc^2 / M_{sun}') 
        endcase
        
        !P.MULTI = [0, 1, 2]
        print, max(xarr)
        plot, speca, title='pol A',ytitle=yt, charsize = 3 ,yrange=[1.2*min(speca),1.2*max(speca)], xrange=[min(xarr),max(xarr)]
        oplot,[511,511],[1.2*min(speca),1.2*max(speca)], linestyle=2
        click= ' '
        ; read,click,prompt='Enter to continue...'
        ;;POLB
        ;;Change the vertical scale if necessary
        ; hor
        ; ver
        plot,specb,title='pol B',ytitle=yt,charsize = 3 ,yrange=[1.2*min(specb),1.2*max(specb)], xrange=[min(xarr),max(xarr)]
        oplot,[511,511],[1.2*min(specb),1.2*max(specb)], linestyle=2
        ; read,click,prompt='Enter to continue...'

        print,'--- Averaged spectrum ---'
        ;;;FINAL SPEC
        ; hor
        ; ver
        spec=(specA+specB)/2.
        plot,xarr,spec,ytitle=yt,charsize = 3 ,yrange=[1.2*min(spec),1.2*max(spec)], xrange=[min(xarr),max(xarr)]
        oplot,[511,511],[-100,100], linestyle=2

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
           oplot,[511,511],[-100,100], linestyle=2
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
        plot,xarr,specnew,ytitle=yt,charsize = 3, xrange=[min(xarr),max(xarr)]
        oplot,[0,nchn],[0,0], linestyle=2
        oplot,[511,511],[-100,100], linestyle=2
        smo=5
        ; print, "Boxcar smoothing. Enter # of channels to smooth by (odd number): "
        ; read, smo
        specnew1=smooth(specnew,smo)
        ; hor
        ans=''
        plot,xarr,specnew1,ytitle=yt, charsize = 3, xrange=[min(xarr),max(xarr)]
        oplot,[0,nchn],[0,0], linestyle=2
        oplot,[511,511],[-100,100], linestyle=2
        ans='y'
        ;read,ans,prompt='OK? [Y/n]'
        if (ans eq '') then ans='y'
        ans=strmid(strlowcase(ans),0,1)
        if (ans eq 'n') then  goto,boxcarsm
        specnew= specnew1

        ; BASELINE FITTING
        print,''
        print,'--- Baseline Fitting ---'
        print,''
        f_bmask,bmask,nchn
        ansb='y'
        b_fit,bmask,nchn,norder,CDFchoice,ansb
        indb=where(bmask eq 1)
        fit_base:
        bcoef=poly_fit(xarr[indb],specnew[indb],norder)
        yfit=poly(xarr,bcoef)
        basecoef[0:norder]=bcoef
        oplot,yfit
        read,ansb,prompt='Baseline OK? [Y/n] '
        if (ansb eq '') then ansb='y'
        ansb=strmid(strlowcase(ansb),0,1)
        if (ansb eq 'n') then begin
            plot,specnew,ytitle=yt,charsize = 3
            oplot,[511,511],[-100,100], linestyle=2
            oplot,fltarr(nchn),linestyle=1
            b_fit,bmask,nchn,norder,CDFchoice,ansb
            indb=where(bmask eq 1)
            goto,fit_base
        endif
        spec=specnew-yfit
        plot,spec ,ytitle=yt,charsize = 3 
        oplot,[0,nchn],[0,0], linestyle=2
        oplot,[511,511],[-100,100], linestyle=2
        rms= stddev(spec[indb])

        ;;----------------------------------------
        ; Check if the stack is a non detection
        ; Evaluate the signal of non-detection (300 km/s ms > 10^10Msol; 200km/s ms <= 10^10Msol) using rms value
        detflag='y'
        detflag_n=1
        IF (CDFchoice EQ 'Y') THEN BEGIN
            detflag = 'y'
        ENDIF ELSE BEGIN  
            read, detflag, prompt='Is the stack a detection? [Y/n] '
            print, ''
        ENDELSE
        if (detflag eq '') then detflag='y'
        detflag=strmid(strlowcase(detflag),0,1)

        IF (detflag eq 'n') then begin
            ; rms= stack.rms_gf[0]
            totSerr_tot = 0
            TOTSERR_SYS = 0
            detflag_n=0
            ; MEASURE Signal upper limit
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

        ;;MEASURE Signal
        ;;zoom in spectrum first
        plot,spec,ytitle=yt,charsize = 3  
        oplot,[511,511],[-100,100], linestyle=2
        oplot,[0,nchn],[0,0], linestyle=2
        print,' '
        print,'Left click LEFT and RIGHT channel limits for plot'
        cursor, x, y, /DATA
        print, 'x=', x,'', 'y=', y
        hor1=round(x)
        wait,0.5
        cursor, x, y, /DATA
        print, 'x=', x,'', 'y=', y
        hor2=round(x)
        wait,0.5
        ; hor,hor1,hor2
        y_min=min(spec[hor1:hor2])
        y_max=max(spec[hor1:hor2])
        ; ver,y_min-0.2*(y_max-y_min)
        ; ver,y_max+0.2*(y_max-y_min)


        ;;Flag channels corresponding to edges [ch1,ch2] and peaks [chp1,chp2] of profile
        flagmsr:
        plot,velarr[hor1:hor2],spec[hor1:hor2],ytitle=yt,charsize = 3  
        oplot,[-5000,5000],[0,0], linestyle=2
        oplot,[0,0],[-100,100], linestyle=2
        oplot,fltarr(nchn), linestyle=2 ;y=0 dashed line
        print,' '
        print, 'Flag edges of spectral feature to be measured:'
        print, 'Left click LEFT edge of feature'
        cursor, x, y, /DATA
        print, 'x=', x,'', 'y=', y
        oplot,[x,x],[-100,100], linestyle=2
        ch1 = Value_Locate(velarr,x)
        ; ch1=round(x)                 ;scientific round
        wait,0.5
        print, 'Left click RIGHT edge of feature'
        cursor, x, y, /DATA
        print, 'x=', x,'', 'y=', y
        oplot,[x,x],[-100,100], linestyle=2
        ch2 = Value_Locate(velarr,x)
        ; ch2=round(x)
        ; flag,[ch1,ch2], linestyle=1
        wait,0.5

        ;;flux
        w=abs(velarr[ch1]-velarr[ch2])
        vch=0.5*(ch1+ch2)
        dv=abs(velarr[vch]-velarr[vch+1]) ;channel width in km/s
        print, dv
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
        ; print, "Estimate systematic errors caused by choice of signal boundaries "
        ; print,'Flag new boundary edges: '
        ; print, 'Left click LEFT edge '
        ; cursor, x, y, /DATA, /NORMAL
        ; print, 'x=', x,'', 'y=', y
        chn1=-1
        ; wait,0.5
        ; print, 'Left click RIGHT edge '
        ; cursor, x, y, /DATA, /NORMAL
        ; print, 'x=', x,'', 'y=', y
        chn2=x
        ; flag,[chn1,chn2], linestyle=1
        wait,0.5
        ; totSerr_sys= abs(totS- total(spec[chn1:chn2])*dv)/2. ; mJy km/s
        ; totSerr_tot=sqrt(totSerr_S05^2+totSerr_sys^2)
        
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
            ; stack.S.totSerr_sys3totSerr_sys
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
            print,'LOG(M_HI/M*) ',ALOG10(stack.GF.totGF)
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
         IF (detflag eq 'y') THEN printf, lun,ch1,ch2,format="('Signal edges [channels]:  ',i4,' - ',i4)"
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
