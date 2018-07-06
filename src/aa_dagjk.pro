; docformat = 'rst'

;+
; 
; The purpose of aa_dagjk is to estimate errors on stacked quantity using a modified 
; delete-a-group jknife technique, a statistical estimate of the standard deviation 
; that incorporates both the variance of the estimator and its bias.
;
; See Eq.1 `Kott, 2001 <http://www.jos.nu/articles/abstract.asp?article=174521>`.
;
;
; When employed using random rejection, there are no theoretical advantages to DAGJK over the traditional
; ‘leave one out’ jackknife method. The main motivation for its use is that the grouping of
; data allows for significant gains in computational efficiency when applied to large samples
; while maintaining precision in the (nearly) unbiased confidence interval of the population
; parameter.
;
; This method ranks each spectra by a selected property (randomly, NUV-r, stellar mass), 
; it then calculates the gas fraction iteratively, while 
; discarding, in turn, a separate random subset of galaxies from the sample.
;
; e.g. for 100 galaxies in original stack and 20% resampling,
; aa_dagjk will remove 0-19,20-39,40-59,60-79, 80-100
;
; The resulting distribution of the stacked flux/mass/gas fractions is saved in the .sav structure.\
;
; :Author:
;    Toby Brown
;
; :History:
;    Written by Toby Brown (April 2017). Based upon routines written by Silvia Fabello (April 2009).
;
;
; :Examples:
;    aa_dagjk is a main level procedure included in aa_dagjk.pro::
;
;       IDL> aa_dagjk, 'path/to/aa_measure_output', 'path/to/file.cfg'
;
;    Iteratively stacks galaxies indexed by aa_stack, discarding 20% per iteration. Reduction and spectral measurements
;   are automatic.
;-

;+
; Shift spectra in Fourier space by taking first the FFT and then the inverse FFT in order
; to centre the spectrum on the HI rest freq and account for the fact that increments in frequency
; do not correspond to equal increments in radial velocity.
;
; :Private:
;-
pro freqshift,dx,spec_in,spec_out
  i=dcomplex(0,1) ; dcomple(A,B) returns A the real parts and B the imaginary parts of complex array i
  ddx=dx*(-1.)                 
  n=n_elements(spec_in)  ;  returns the number of elements contained in spec_in
  ;;create array of indices
  indarr=dindgen(n)
  indarr[(n/2+1):n-1]=(-1)*reverse(dindgen(n/2-1))-1 
  ;;calculate fourier transform of shifted spectrum
  ffts=fft(spec_in)*exp(2.0*!pi*i*ddx*indarr/double(n))
  ;;do the inverse transform to get back the shifted spectrum
  spec_out=(fft(ffts,/INVERSE))
  spec_out=real_part(spec_out)
end

;+
; Create progress bar 
;
; :Private:
;-
pro progbar, percent, length=length
  length = (keyword_set(length))?length:40
  per = percent/100.0
  
  less = (floor(per*length)     eq 0)? '' : replicate('+', floor(per * length))
  grea = (ceil ((1-per)*length) eq 0)? '' : replicate('-', ceil( (1-per)*length ))
  bar = strmid(strjoin([less,grea]),0,length)
  
  print, format='(%"' + bar + ' [' + strtrim(long(per*100.0),2) + '\%]\r",$)'
end


;+
; Store mouse click to set channel mask for baseline measurement
;
; :Private:
;-
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

;+
; :Params:
;    stackingdir : in, required, type=string
;                of the output directory of aa_measure.pro
;
;    parameterFile : in, required, type=string
;                Configuration file containing path to sample catalogue, options for stacking routine,
;                bin edges (see 'inputexample.yaml').
;
; :Description:     
;   Procedure
;   ---------
;
;       1. Restore stacked structure.
;
;       2. Rank galaxies by NUV-r, mu_star, M_star, C-index or Random (default NUV-r), and select 20% of the targets.
;
;       3. Stack following 'aa_stack.pro'.
;
;       4. Save a structure for each of the stacking repetition.
;
;       5. Measure the signal in the stacked spectrum, using the
;        reduction parameters from 'aa_measure.pro'
;
;       6. Update and modify the corresponding stack field with the values
;        measured. Which quantity is stacked, and if a correction for
;        confusion has to be applied is read from the structure (set
;        during 'aa_stack.pro').
; 
;
;   Outputs
;   -------
;    'output/output_bin_no.sav' -  Modified structure containing the stack,
;                                    now with DAG jackknife fluxes/HI masses/gas fractions
;
;        jknife_flx,jknife_mhi,jknife_gf  - 5 independent Jacknife measures of stacked flux,
;                                            HI mass or gas fraction.
;
; :Options:
;  It is possible for aa_dagjk program can handle multiple stacking directories. To do this pass an array
;  of directory strings to 
;       
;       pro aa_dagjk, stackingdir
;       folders = [stackingdir]
;
;
;  must be replaced with::
;
;       pro aa_dagjk, dir1, dir2, ..., dirN
;       folders = [dir1, dir2, ..., dirN]
;       
; :Uses: 
;    f_bmask, b_fit, progbar, freqshift
;       
; :Bugs:
;
;
; :Categories: 
;    Error analysis, ALFALFA software
;
;  
;-
pro aa_dagjk, stackingdir, parameterFile

; handle single and multiple directories 
if n_elements(stackingdir) eq 1 then begin
    folders = [stackingdir]
    paramf = [parameterFile]
endif else begin
    folders = stackingdir
endelse

!EXCEPT=2
; Constants used
lightsp=299792.458D  ;km/s
restfrq=1420.4058    ; HI rest freq [MHz]
deltaf=0.024414063   ; ALFALFA channel width [MHz/chn]
nchn=1024            ; no. ALFALFA channels

;;Define final frequency array: 1024 chn, 1420MHz (v_0=V_syst) in chn 511.
frqarr=restfrq+(findgen(nchn)-511)*deltaf ;frequency array

FOR fold=0,N_ELEMENTS(folders)-1 do begin

    ; read sample list
    paramf = gm_read_textstructure(parameterFile[fold])
    path=paramf.path ; source path
    sampledir=paramf.sampledir ; database path
    listname=paramf.listname ; database name

    samplef = sampledir+listname
    data_tab_tot=mrdfits(samplef,1)
    z_tot = data_tab_tot.z
    mass_tot=data_tab_tot.lgMst_median
    ID_tot=data_tab_tot.ID
    
    ; output folder
    output = folders[fold]
    spawn,'mkdir '+output+'/resample/'
    PRINT, ''
    read, xbin_tot, prompt='Enter number of first parameter bins [5]: '
    if (xbin_tot eq '') then xbin_tot=5
    xbin_tot = fix(xbin_tot)
    ybin_tot = 5
    ; read, bin_tot, prompt='How many structures do you want to RESTORE? (i.e. no. of bins) '
    j_pc = 20 ; set discard fraction to 20%


    FOR i=0,xbin_tot-1 do BEGIN
        
        xbin_no = STRCOMPRESS((i + 1), /remove_all)
        ; print, 'test', xbin_no

        FOR j=0,ybin_tot-1 do BEGIN

            ybin_no = STRCOMPRESS((j + 1), /remove_all)
            PRINT, ''
            PRINT, 'Beginning bin number ' +xbin_no+'-'+ybin_no
            PRINT, ''
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
            
            ;;Restore reduction and stacking info from main file
            PRINT, 'restoring... '+output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
            PRINT, ''
            file= output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
            RESTORE,file

            index=stack.hd.index
            IF stack.gf.totgf EQ 0 THEN BEGIN
                IF stack.MHI.totMHI EQ 0 THEN BEGIN
                    PRINT, ''
                    PRINT, 'No gas fraction. Run aa_measure.pro!'
                    PRINT, ''
                    goto, EXITDAG
                ENDIF
            ENDIF

            IF stack.detflag EQ 0 THEN BEGIN
                PRINT, ''
                PRINT, 'Non-detection, skipping Jackknife routine.'
                PRINT, ''
                goto, nogalaxies
            ENDIF
            
            ; IDs of galaxies used in central stack.
            ID = stack.ID
           
            ndata = N_ELEMENTS(ID)
            PRINT, 'There are' + STRCOMPRESS(ndata) + ' galaxies in bin ' + xbin_no+'-'+ybin_no

            
            ; print, MIN(mu_star), MAX(mu_star), N_ELEMENTS(mu_star)
            srcname='ID_'+STRCOMPRESS(ID, /remove_all)+'.src'
            data_file=path+srcname

            smo= stack.red.smooth
            bmask=stack.red.bmask
            norder=stack.red.bord
            ch1=stack.red.edge[0]
            ch2=stack.red.edge[1]
            chn1=stack.red.edge_err[0]
            chn2=stack.red.edge_err[1]
            xarr=findgen(nchn)
            velarr=lightsp*(Restfrq/(Restfrq+deltaf*(511-xarr))-1)
            indb=where(bmask EQ 1)
            nusedall=N_ELEMENTS(ID) -1 ;stack.nused[0]
            whatstack=stack.hd.input[2]

            ; percentage to resample
            j_step = FIX((ndata-1)*(j_pc/100.))
            rep = ndata/j_step
            cnt = 0 ; counter for the jknife reps

            PRINT,''
            PRINT, 'Randomised resample with' + STRCOMPRESS(j_pc) + '% discarded.' 
            PRINT,''

            ;;------------- Jackknife: resample at given percentage.
            ;;
            jknife_flx=FLTARR(rep)
            jknife_mhi=FLTARR(rep)
            jknife_gf=FLTARR(rep) 
            
            ;-------------------PLOT NUV-r HIST --------------------------        
            ;cgPS_open, plotdir + 'NUV-r_bin'+xbin_no+'_jk'+STRCOMPRESS(j_pc, /remove_all)+$
            ;    '.pdf',$  ;'_N' + STRCOMPRESS(cnt+1, /remove_all) + 
           ; 
            ;XSIZE = 11.4, XOFFSET = 0., YOFFSET = 0., YSIZE = 8.692, /landscape
            ;!P.CHARSIZE = 2
            ;!P.CHARTHICK = 1
            ;!P.FONT =0
            ;!P.THICK  = 10
            ;!X.THICK = 3
            ;!Y.THICK = 3
            CATCH, /CANCEL
            FOR jknife=0L,ndata-1,j_step DO BEGIN      ; Jackknife repetitions 

                pc=floor(100*jknife/(ndata))
                ;print, pc
                progbar, pc
                
                stack_specA=FLTARR(nchn)
                stack_specB=FLTARR(nchn)
                rms_A_vec=FLTARR(nusedall)
                rms_B_vec=FLTARR(nusedall)
                rmstotA=0.
                rmstotB=0.
                indx=FLTARR(nusedall)
                z_vec=FLTARR(nusedall)
                mst_vec=FLTARR(nusedall)
                sconfone_up=FLTARR(nusedall)
                sconfone=FLTARR(nusedall)
                ;; resampling of galaxies included in the stack
                idx=INDGEN(ndata)
                
                ; print, jknife, j_step, ndata
                IF (jknife+j_step ge ndata) THEN goto, stopjk
                
                PRINT, ''
                PRINT, 'Resample Number:' + STRCOMPRESS(cnt+1)
                PRINT, 'Galaxy spectra' + STRCOMPRESS(jknife+1) + ' -' + $
                        STRCOMPRESS(jknife+j_step) +' are being excluded.'
                
                all=[idx[0:jknife],idx[jknife+j_step:-1]]
                ii=index[all]              ;which position in the all initial sample
                nconf=0
                nnk = 0

                
                FOR k=0,n_elements(all)-1 DO BEGIN  

                    restore, path+'ID_' + STRCOMPRESS(ID[all[k]], /remove_all)+'.src'

                    
                    ra=src.hd.input[0]
                    dec=src.hd.input[1]

                    z= z_tot[WHERE(ID_tot EQ ID[all[k]], /NULL)]
                    z = DOUBLE(z[0])
                    mstar= mass_tot[WHERE(ID_tot EQ ID[all[k]], /NULL)]
                    mstar = DOUBLE(mstar[0])

                    ; z = DOUBLE(zspecarr[0])
                    ; z = z_arr[all[k]]
                    ; z = z[0]

                    wopt=src.hd.input[3]/2.       ;half w_opt if available from TF, or 300/2. km/s
                    ; mstar = mass[all[k]]
                    rms_A=src.rms[0]
                    rms_B=src.rms[1]

         
                    ;; Assign pol A and B flux
                    sourcefrq = src.frqarr ; Frequency
                    specA_in = src.specpol.YARRA
                    specB_in = src.specpol.YARRB
                    weightA = src.weight.wspeca
                    weightB = src.weight.wspecb

                    ; plot, (specA_in+specB_in)/2, charsize=2

                    ;;; Set spec to 0 where weight < 0
                    w = WHERE((weightA lt 0.1) or (weightB lt 0.1))
                    specA_in[w] =  0
                    specB_in[w] =  0

                    CASE whatstack of 
                        1: BEGIN
                            specA=specA_in ;flux
                            specB=specB_in
                        END
                        2: BEGIN             ;M_HI
                            specA=DOUBLE(specA_in*lumdist(z,/silent)^2/(1.+z))      
                            specB=DOUBLE(specB_in*lumdist(z,/silent)^2/(1.+z))         
                        END
                        3: BEGIN             ;M_HI/M_*
                            specA=DOUBLE(specA_in*lumdist(z,/silent)^2/(1.+z)/10.d0^mstar)
                            specB=DOUBLE(specB_in*lumdist(z,/silent)^2/(1.+z)/10.d0^mstar)
                        END
                    ENDCASE

                        ; IF k EQ 1 THEN stop

                    frq_c=(restfrq/(z + 1.))
                    d_ch=floor((src.frqarr[511]-frq_c)/(deltaf))

                    ; print, spec_outA
                    freqshift,d_ch,specA,spec_outA
                    freqshift,d_ch,specB,spec_outB

                    stack_specA=stack_specA+spec_outA/(rms_A^2)
                    stack_specB=stack_specB+spec_outB/(rms_B^2)

                    rms_A_vec[k]=rms_A
                    rms_B_vec[k]=rms_B
                    rmstotA=rmstotA+1/(rms_A^2)
                    rmstotB=rmstotB+1/(rms_B^2)
                    z_vec[k]=z
                    mst_vec[k]=mstar
                    indx[k]=k
                
                    nnk=nnk+1
                ENDFOR
             
             
                z_avg=mean(z_vec[0:k-1])
                mst_avg=mean(10^mst_vec[0:k-1])
                indexk=indx[0:k-1]
                rmsav=total(rms_A_vec[0:k-1])/k
                rmsbv=total(rms_B_vec[0:k-1])/k

                stack_specA=stack_specA/rmstotA
                stack_specB=stack_specB/rmstotB

                ; print,'rms = ', total(rms_A_vec[0:k-1])/k
                
                stack_specA_flx=FLTARR(nchn)
                stack_specB_flx=FLTARR(nchn)
                stack_specA_mhi=FLTARR(nchn)
                stack_specB_mhi=FLTARR(nchn)
                stack_specA_gf=FLTARR(nchn)
                stack_specB_gf=FLTARR(nchn)
                
                
                CASE whatstack of 
                    1: BEGIN                ;Flux
                       stack_specA_flx=stack_specA
                       stack_specB_flx=stack_specB
                    END
                    2: BEGIN                ;M_HI
                       stack_specA_mhi=stack_specA
                       stack_specB_mhi=stack_specB
                    END
                    3: BEGIN                ;M_HI/M_*
                       stack_specA_gf=stack_specA
                       stack_specB_gf=stack_specB
                    END
                ENDCASE

                
                sname=output+'/resample/'+output+'_'+xbin_no+'-'+ybin_no+'_rep-'+strtrim(rep+1,2) +'.sav'
                
                hd={input:[z_avg,mst_avg,whatstack],file:output,index:indexk}
                red={edge:[0,0],edge_err:[0,0],bmask:intarr(nchn),bord:0,smooth:0} ;reduction parameter
                specA={flx:stack_specA_flx,mhi:stack_specA_mhi,gf:stack_specA_gf}  
                specB={flx:stack_specB_flx,mhi:stack_specB_mhi,gf:stack_specB_gf} 
                spec={flx:FLTARR(nchn),mhi:FLTARR(nchn),gf:FLTARR(nchn)} 
                S={totS:0.,totSerr:0.,totSerr_sys:0.,totSerr_tot:0.}
                MHI={totMHI:0.,totMHIerr:0.,totMHIerr_sys:0.,totMHIerr_tot:0.}
                GF={totGF:0.,totGFerr:0.,totGFerr_sys:0.,totGFerr_tot:0.}
                sn={flx:FLTARR(3),mhi:FLTARR(3),gf:FLTARR(3)}
                
                
                stack ={hd:hd, $           ;z mean,mst mean, 0,0,0
                    nused:nnk, $
                    frqarr:frqarr, $
                    specA:specA, $
                    specB:specB, $
                    spec:spec, $              ;;to be filled later
                    red:red,$
                    rms:[rmsav,rmsbv,0.,0.],$
                    rms_mhi:[0.,0.],$
                    rms_gf:[0.,0.],$
                    S:S,$
                    MHI:MHI,$
                    GF:GF,$
                    sn:sn,$
                    c_factor:[-99,-99]}
                
                SAVE,stack,file=sname
        ;;------------------------------END STACKING, EVALUATE
                ;;RESTORE closed structure
                RESTORE,sname
                nused=stack.nused[0]
                
                CASE whatstack of          ;which quantity has been stacked
                    1: BEGIN                ;flux
                    speca=DOUBLE(stack.speca.flx)
                    specb=DOUBLE(stack.specb.flx)
                    END
                    2: BEGIN                ;M_HI
                    speca=DOUBLE(stack.speca.mhi)
                    specb=DOUBLE(stack.specb.mhi)
                    END
                    3: BEGIN                ;M_HI/M_*
                    speca=DOUBLE(stack.speca.gf)
                    specb=DOUBLE(stack.specb.gf)
                    END
                ENDCASE
                
                spec=(specA+specB)/2.
                specnew=hans(3,spec)
                specnew1=smooth(specnew,smo)
                specnew= specnew1  
                bcoef=poly_fit(xarr[indb],specnew[indb],norder)
                yfit=poly(xarr,bcoef)
                spec=specnew-yfit
                ; plot, spec, charsize=2
                rms= STDDEV(spec[indb])

                w=abs(velarr[ch1]-velarr[ch2])
                vch=0.5*(ch1+ch2)
                dv=abs(velarr[vch]-velarr[vch+1]) ;channel width in km/s
                dv_smo=dv*SQRT(smo*smo+2.0*2.0)   ; vel. res. of Hanning + boxcar smoothed spectrum
                
                totS=DOUBLE(total(spec[ch1:ch2])*dv)

                ; print, ''
                ; print, 'channels 1,2 ', ch1,ch2
                ; print, 'total spec ', total(spec[ch1:ch2])
                ; print, ''
                totSerr=DOUBLE(rms*dv*SQRT(ch2-ch1))
                totSerr_S05=DOUBLE(2.*rms*SQRT(1.4*w*dv_smo)) ; CU HI archive definition (Springob+ 2005, eqn. 2)
                peakS=DOUBLE(max(spec[ch1:ch2]))
                totSerr_sys=DOUBLE(0.)
                totSerr_tot=DOUBLE(0.)
                ; totSerr_sys= abs(totS- total(spec[chn1:chn2])*dv)/2. ; mJy km/s
                ; totSerr_tot=SQRT(totSerr_S05^2+totSerr_sys^2)
                
                smofac=W/(2.*dv_smo)       ; dv_smo= 10 km/s for ALFALFA, after han
                IF (W gt 400.) THEN  smofac=400./(2.*dv_smo)
                stn=FLTARR(4)
                stn[0]=(totS/W)*SQRT(smofac)/rms ; ALFALFA definition, width just width :)
                stn[1]=peakS/rms
                        
                CASE whatstack of          ;which quantity has been stacked
                    1: BEGIN                ;flux
                        stack.S.totS=totS
                        stack.S.totSerr_sys=totSerr_sys
                        stack.S.totSerr=totSerr_tot 
                        stack.spec.flx=spec
                        stack.rms[2]=rms
                        stack.rms[3]=rms/SQRT(150./dv_smo)
                        stack.sn.flx=stn[0:1]  
                    END
                    2: BEGIN                ;mhi
                        ; help, stack
                        stack.MHI.totMHI=DOUBLE(2.356*10^4*10*totS/1000.) 
                        stack.MHI.totMHIerr=DOUBLE(2.356*10^4*10*totSerr_tot/1000.)
                        stack.spec.mhi=spec
                        stack.rms_mhi[0]=rms
                        stack.rms_mhi[1]=rms/SQRT(150./dv_smo)
                        stack.sn.mhi=stn[0:1]  
                    END
                    3: BEGIN                ;mhi/m*
                        ; print,'TotS', totS
                        stack.GF.totGF=DOUBLE(2.356*10^4*10*totS/1000.) 
                        ; print,'M_HI/M* ', DOUBLE(2.356*10^4*10*totS/1000.)
                        stack.GF.totGFerr=DOUBLE(2.356*10^4*10*totSerr_tot/1000.)
                        stack.spec.gf=spec
                        stack.rms_gf[0]=rms
                        stack.rms_gf[1]=rms/SQRT(150./dv_smo)
                        stack.sn.gf=stn[0:1]
                    END
                ENDCASE
                
                ;----------------------------------------
                ; Plot stack spec of jackknife.
                
                ; plotdir = '/Users/thbrown/AA_project/TOBY_STACKING/TSTACK/plots/error_testing/jknife/specs/'
                ; cgPS_open, plotdir +$
                ;    'jk'+STRCOMPRESS(j_pc, /remove_all)+$
                ;        '_bin'+xbin_no+$
                ;            '_rep'+STRCOMPRESS(cnt+1, /remove_all)+$
                ;                '.pdf',$


                ; XSIZE = 11.4, XOFFSET = 0., YOFFSET = 0., YSIZE = 8.692, /landscape
                ; !P.CHARSIZE = 2
                ; !P.CHARTHICK = 1
                ; !P.FONT =0
                ; !P.THICK  = 10
                ; !X.THICK = 3
                ; !Y.THICK = 3
                ; CASE whatstack of    ;which quantity has been stacked
                ;   1: yt=textoidl('mJy\cdot (km/s)^2') 
                ;   2: yt=textoidl('mJy\cdot (km/s)^2 Mpc^2') 
                ;   3: yt=textoidl('mJy (km/s)^2 Mpc^2 / Msol') 
                ; ENDCASE        
                
                ; PLOT, velarr,  spec,CHARSIZE = 2,$
                ;    TITLE='Spectra for bin ='+xbin_no+', rep ='+STRCOMPRESS(cnt+1, /remove_all), $
                ;        YRANGE=[MIN(spec), MAX(spec)],$
                ;            XRANGE=[MIN(velarr), MAX(velarr)],$ 
                ;            CHARTHICK = 1,$
                ;                XTITLE = 'Velocity [km/s]',$
                ;                    YTITLE = yt
              
                ; OPLOT,velarr, fltarr(N_ELEMENTS(velarr)),linestyle=1
               
                ; vline,velarr[ch1], linestyle = 2, THICK  = 2
                ; vline,velarr[ch2], linestyle = 2, THICK  = 2

                ; cgPS_Close
                
                ;----------------------------------------
                
                stack.red.edge=[ch1,ch2]
                stack.red.edge_err=[chn1,chn2]
                stack.red.bmask=bmask
                stack.red.bord=norder
                stack.red.smooth=smo
             
                CASE whatstack of          ;which quantity (1.-(j_pc/100.)has been stacked
                    1: jknife_flx[cnt]=totS
                    2: jknife_mhi[cnt]=double(2.356*10^4*10*totS/1000.)
                    3: jknife_gf[cnt]=double(2.356*10^4*10*totS/1000.)
                ENDCASE
                skip:
                cnt = cnt+1 ; counter
            ENDFOR
            stopjk:
            
            SAVE,stack,file=sname
            ;;Save results in original structure 
            RESTORE,output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'.sav';, /RELAXED_STRUCTURE_ASSIGNMENT 
            
            stack = MOD_STRUCT(stack,'resamp_flx', FLTARR(rep)) ; Modify the existing structure to add input
            stack = MOD_STRUCT(stack,'resamp_MHI', FLTARR(rep)) ; jackknifed flx, mhi or gf measurments                 
            stack = MOD_STRUCT(stack,'resamp_GF', FLTARR(rep))
            
            PRINT, ''
            PRINT, ''
            PRINT, ''
            print,'Original M_HI/M* ', stack.gf.totgf
            PRINT, ''

            stack.resamp_flx=jknife_flx
            stack.resamp_MHI=jknife_mhi
            stack.resamp_GF=jknife_gf

            spath = output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'.sav'
            SAVE,stack,file=spath
            
            PRINT,'resample errors saved to '+spath
            openu,lun,output+'/'+output+'_bin_'+xbin_no+'-'+ybin_no+'_LOG.dat',/get_lun,/append ; open the data file 4 update
            PRINTF, lun,' '
            PRINTF, lun, '-------------------------------------------------'
            CASE stack.hd.input[2] of    ;which quantity has been stacked
                1: PRINTF, lun,STDDEV(stack.resamp_GF),format="('jknife error +/- ',f6.2)"
                2: PRINTF, lun,STDDEV(stack.resamp_GF),format="('jknife error +/- ',f10.2)"
                3: PRINTF, lun,STDDEV(stack.resamp_GF),format="('jknife error +/- ',f5.3)"
            ENDCASE
            PRINTF, lun,floor(0.8*nusedall),format="('Evaluated over stacking of ',i4,' galaxies')"
            
            close,lun
            free_lun, lun
            nogalaxies:

        ENDFOR
    ENDFOR
ENDFOR
EXITDAG:
PRINT, ''
PRINT, 'ALL DONE!'
PRINT, ''

END
