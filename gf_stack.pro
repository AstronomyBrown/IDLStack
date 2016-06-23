; docformat = 'rst'
;+
; NAME:
;   gf_stack.pro  ; Spectral Stacking software, optimized for ALFALFA (Giovanelli et al. 2005) data.
;
;
; CATEGORY:
;	Data anaysis, spectral stacking, ALFALFA software
;
;
; CALLING SEQUENCE:
;   GF_STACK, 'filename.fits', /KEYW1, /KEYW2
;
;
; PURPOSE:
; Given an input list of objects, restore the corresponding structures
; and stack the spectra (MHI/M* by default); save the stacked structure. 
;
;
; INPUTS: 
;   name.fits: list of galaxies, with (at least) following data. Ra;
;              dec; mass_p50 [Log(Mstellar/Msolar)]; HI_flag; sdss (name) 
;
;   .src:      structures extracted from 'getspec.pro'
;	quantites to stack and their limits
;
;
; OPTIONAL INPUTS: 	       
;
;     - which quantity to stack (flux, MHI or MHI/M*)(MHI/M* by default), set keyword '/STACKQ'
;
;     - plot output spectra, set keyword '/PLOT'
;
;     - apply correction for beam confusion 	
;
;
; PROCEDURE:
;	GF_STACK:
;
;	   0 - User defined output directory name
;
;	   1 - User input quantites to stack and their limits
;
;	   2 - Restore .src structures
;
;	   3 - Read spectrum. Weight spectrum by mass and/or redshift if required.  
;
;	   4 - Shift each spectrum so that galaxy central freq is in board center [chn 511]
;
;	   5 - Stack spectra, weighting by their rms
;
;	  (6)- Estimate beam confusion (if required):	
;	       ***In unit of gas fraction for now***
;	   	   1) search for neighbours inside arecibo beam (restore structures);	
;	       2) evaluate their flux from inverse Zhang+09 relation;	
;	       3) correct for beam efficiency;	
;	       4) correct for velocity overlap;	
;	       5) sum over all neighbours contribution.
;
;	   7 - Save output and metadata
;
;
; FUNCTIONS CALLED:
;
;   freqshift - Shift spectra in Fourier space by taking first the FFT and then the inverse FFT in order
;              to centre the spectrum on the HI rest freq.
;
;   progbar - Create progress bar 
;
;
; OUTPUTS:
; 'name/.sav':  file containing a STACK structure as follow:
;
;               HD.input = Array[4]  mean z, stellar mass, flag for stacked quantity, flag for confusion correction  
;
;      	        HD.file  = name of output file  
;
;	        	HD.index = out of N galaxies in input, index of the ones used	 
;
;				nused = galaxies used, detected, confused
;
;				FRQARR = frequency array
;
;				SPECA/SPECB = flux,mhi,gf: Array[nchannels] = stacked spectrum for each polarization (the two options not chose are empty)
;
;				RED  = parameters filled after reduction ('hi_measure.pro')
;
;				RMS = average rms polA, average rms polB, plus empty filled after reduction
;
;				S, MHI,GF = Total fluxes/gas fractions, filled after reduction
;
;				PARAMS = Parameters by which stacked spectra are selected
;
;				lims = bin limits param 1
;
;				lim_ab = bin limits param 2
;
;				lim_ii = bin limits param 3
;
;				MEAN_MS = stellar mass for non_detection calc
;
;				MEAN_X = avg value per X-axis bin
;
;				detflag =  flag if stack is detection (1) or non-detections (0), default detection, changed in HI_measure
;
;				c_factor = flux confusion factor
;
; 'name_LOG.dat':  Logfile with the following information:
;		i)   Flags set by users.   
;       ii)  Track of galaxies skipped because .src is missing, or quality flag is 0.
;		iii) Summarizes numbers used/confused	 
;     
;
; EXAMPLE:
;	> .r gf_stack.pro  
;
;	> GF_STACK, 'sample.fits', /PLOT
;		Stacks galaxies indexed by 'sample.fits' and plots output spectrum, saves output
;
;	> GF_STACK, 'sample.fits', /STACKQ, /PLOT
;		Stacks galaxies indexed by 'sample.fits', user input stacked quantity and plots output spectrum, saves output
;
;	> GF_STACK, 'sample.fits'
;		Stacks galaxies indexed by 'sample.fits', saves output
;
;
; COMMENTS:
;
;	See stacksoftware-docs for installation information and README files
;
;	Consult ALFALFA team (Haynes and Giovanelli) before publishing. - TB
;
;
; MODIFICATION AND OWNERSHIP HISTORY:
;
;   Original Software by: Silvia Fabello (April 2009).
;
;	Current Version by: Toby Brown (June 2014).	
;
;	April 2009 written by Silvia Fabello
;
;   September 2009 add option to weight spectra by M/z if wanted.
;
;   January 2010 finalized for ALFALFA.
;
;   2012 added correction for beam confusion.
;
;	June 2014 modified for larger ALFALFA samples, improved binning procedure - TB
;
;	September 2014 added input choices, improved compatibility with 'gf_measure.pro'
;
;	January 2015 updated for 'DAG_jknife.pro'
;
;
;-

; 'pro' specifies a procedure name and parameters.
; Syntax: pro name, parameter_1, /KEYW1, /KEYW2

; Calculates the MODE (value with the maximum frequency distribution) of an array.
; Works ONLY with integer data.
pro MODE, array, mode



   On_Error, 2

   ; Check for arguments.
   IF N_Elements(array) EQ 0 THEN Message, 'Must pass an array argument.'

   ; Is the data an integer type? If not, exit.
   dataType = Size(array, /Type)
   IF ((dataType GT 3) AND (dataType LT 12)) THEN Message, 'Data is not INTEGER type.'

   ; Calculate the distribution frequency
   distfreq = Histogram(array, MIN=Min(array))

   ; Find the maximum of the frequency distribution.
   maxfreq = Max(distfreq)

   ; Find the mode.
   mode = Where(distfreq EQ maxfreq, count) + Min(array)

   ; Warn the user if the mode is not singular.
   IF count NE 1 THEN ok = Dialog_Message('The MODE is not singular.')

END

;;Shift spectra in Fourier space by taking first the FFT and then the inverse FFT in order
;; to centre the spectrum on the HI rest freq.
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



;;Create progress bar 
pro progbar, percent, length=length
  length = (keyword_set(length))?length:40
  per = percent/100.0
  
  less = (floor(per*length)     eq 0)? '' : replicate('+', floor(per * length))
  grea = (ceil ((1-per)*length) eq 0)? '' : replicate('-', ceil( (1-per)*length ))
  bar = strmid(strjoin([less,grea]),0,length)
  
  print, format='(%"' + bar + ' [' + strtrim(long(per*100.0),2) + '\%]\r",$)'
end



;MAIN   -----------------------------------------------------------------
pro GF_STACK, filename, STACKQ = stackq, PLOT = plot

!P.MULTI=0 

;;Parameters needed
rad2deg= 180.d0/!dpi ; radian to degrees conversion factor
lightsp=299792.458D           ; c [km/s]
restfrq=1420.4058             ;HI rest freq [MHz]
deltaf=0.024414063            ;[MHz/chn]
nchn=1024
sx=3.3/(2.*sqrt(2*alog(2)))/60. ;Size of AO beam IN DEGREE!
sy=3.8/(2.*sqrt(2*alog(2)))/60.
;;Define final arrays: 1024 chn, 1420MHz (v_0=V_syst) in chn 511.
frqarr=restfrq+(findgen(nchn)-511)*deltaf ;frequency array
path='/mnt/cluster/kilborn/tbrown/AA_project/SRCFILE/FULLSAMPLE/all/'
sampledir = '/mnt/cluster/kilborn/tbrown/AA_project/SAMPLES/metallicity/'
listname = sampledir + filename

data_tab_tot=mrdfits(listname,1)
ndata_tot=N_ELEMENTS(data_tab_tot.ra)
ra_tot=data_tab_tot.ra
dec_tot=data_tab_tot.dec
z_tot = data_tab_tot.z
mass_tot=data_tab_tot.lgMst_median
ID_tot=data_tab_tot.ID
IAU_tot=data_tab_tot.IAU
halo_tot=data_tab_tot.logMh_Mst
MUst_tot=data_tab_tot.mu_star
C_tot=data_tab_tot.C_idx
NUVR_tot=data_tab_tot.NUV_r
mass_hi_tot = data_tab_tot.log_MHI
detcode_tot = data_tab_tot.code ; 1 = det
BCGflag_tot = data_tab_tot.flag_mstar ; 1 = BGG, 2 = satelite
ngal_tot = data_tab_tot.Ngal ; number of galaxies in group
sfr_tot = data_tab_tot.MEDIAN_SFR
ssfr_tot = data_tab_tot.MEDIAN_SSFR 
fapc_tot = data_tab_tot.fa_prank ; fixed aperture percentage rank
nnpc_tot = data_tab_tot.nn7_prank ; nth Neighbour percentage rank
mhpc_tot = data_tab_tot.mh_prank ; nth Neighbour percentage rank
catch, error
IF (error ne 0L) THEN BEGIN
    catch, /cancel
    print, 'No Metallicities in input file'
    print, ''
    lgOH_12_tot = fltarr(n_elements(ra_tot))
    lgOH_12_tot[where(lgOH_12_tot[*] eq 0.)] = !Values.F_NAN
    goto, skipmetal
ENDIF
lgOH_12_tot = data_tab_tot.OH_MEDIAN_T04 ; log O/H + 12 metallicity, MPA cat.
skipmetal:
; (log M*)/(log Mh) baryon -> star efficiency
; ms_mh_tot = mass_tot/halo_tot

;; Ask user for options if keyword set
whatstack=3 ; set default to gas fractions
IF KEYWORD_SET(stackq) THEN read,whatstack,prompt='Do you want to stack: fluxes (1), M_HI (2) or gas fractions = M_HI/M_* (3, default)?  '

;;Correct for beam confusion? No
confcorrection='n' ; set default to no correction for beam confusion
conf_flag=0
;read,confcorrection,prompt='Do you want to correct for (eventual) beam confusion? [y/n] '
if (STRCMP(confcorrection,'yes',1, /FOLD_CASE) EQ 1) then   conf_flag=1

; create directory in which results will be written
output = ''
read, output, prompt='Please enter output directory name: '
spawn,'mkdir '+output
print,'Results will be in directory ',output


BCG_stack = 1
BCG_stack_str = ['','Select the sample you want to stack:', 'all galaxies: 1', 'isolated centrals: 2',$ 
						'group centrals: 3', 'all centrals: 4', 'satellites: 5', '']
print, BCG_stack_str, FORMAT='(A)' 
read, BCG_stack ,prompt=''
print, ''

; selection added to use correct percentage ranks according to sat/cent/all designation
IF BCG_stack EQ 5 THEN BEGIN
	fapc_tot = data_tab_tot.fasat_prank ; fixed aperture percentage rank
	nnpc_tot = data_tab_tot.nnsat_prank ; nth Neighbour percentage rank
	mhpc_tot = data_tab_tot.mhsat_prank ; nth Neighbour percentage rank
	PRINT, ''
	PRINT, '*** satellite percentage ranks used ***'
	PRINT, ''
ENDIF

; Select the parameters and set limits
whatp1_str = ['','What is the first parameter? ',$
				 'Stellar Mass: 1','NUV-r Colour: 2', $
				 	'Stellar Density: 3', 'Halo Mass: 4', $
				 		'SSFR: 5', 'Metalicity: 6', '']
print, whatp1_str, FORMAT='(A)' 
whatp1 = 9
read,whatp1,prompt=''
print, ''

whatp2_str = ['','What is the second parameter? ', 'Stellar Mass: 1',$
				 'NUV-r Colour: 2', 'Stellar Density: 3', 'Halo Mass: 4',$
				 'SFR: 5','sSFR: 6', 'Fixed Ap p-rank: 7', 'Nth Neighbour p-rank: 8',$
				 'Halo Mass p-rank: 9', 'Group Ngal: 10', 'Metalicity: 11', $
				 'redshift: 12','NONE: 99','']
print, whatp2_str, FORMAT='(A)'
whatp2 = 99
lim_ab = [-99., 99.]
read,whatp2,prompt=''
IF whatp2 LT 99 THEN read,lim_ab,prompt='Enter limits for parameter 2 (e.g. >>> -99,99): '
print, ''

whatp3_str = ['','What is the second parameter? ', 'Stellar Mass: 1',$
				 'NUV-r Colour: 2', 'Stellar Density: 3', 'Halo Mass: 4',$
				 'SFR: 5','sSFR: 6', 'Fixed Ap p-rank: 7', 'Nth Neighbour p-rank: 8',$
				 'Halo Mass p-rank: 9', 'Group Ngal: 10', 'Metalicity: 11', $
				 'redshift: 12','NONE: 99','']
print, whatp3_str, FORMAT='(A)' 
whatp3 = 99
lim_ii = [-99., 99.]
read,whatp3,prompt=''
IF whatp3 LT 99 THEN read,lim_ii,prompt='Enter limits for parameter 3 (e.g. >>> -99,99): ' 
print, ''

;; Default binning
CASE whatp1 OF
	1: BEGIN
		low_lim = [9., 9.4, 9.9, 10.4, 10.9]
		up_lim = [9.4, 9.9, 10.4, 10.9, 11.5] ; Mst binning
	END
	2: BEGIN
		; low_lim = [1, 2.3, 3.3, 4.3, 5.3]
		; up_lim = [2.3, 3.3, 4.3 ,5.3, 8]	; NUV-r binning
		low_lim = [1, 3, 4, 5]
		up_lim = [3, 4, 5 , 8]	; NUV-r binning
		;; change limits if binning by 3rd parameter
		IF (whatp3 le 4) OR (whatp2 eq 4) THEN BEGIN
			PRINT, ''
			PRINT, 'Changing NUV-r binning to increase statistics.'
			PRINT, ''
			PRINT, 'New bins: 1-3, 3-4, 4-5, 5-8'
			PRINT, ''
			PRINT, ''
			low_lim = [1, 3, 4, 5]
			up_lim = [3, 4, 5 , 8]	; NUV-r binning
		ENDIF
	END
	3: BEGIN
		low_lim = [7., 7.6, 8.1, 8.5, 9]
		up_lim =  [7.6, 8.1, 8.5, 9, 10.]	; mu_star binning
	END
	4: BEGIN
		low_lim = [10., 11., 12., 13., 14.]
		up_lim =  [11., 12., 13., 14.1, 15.]	; Mh binning
	END
	5: BEGIN
		low_lim = [-13., -11.5,-10.5, -9.5]
		up_lim =  [-11.5,-10.5, -9.5, -8.]	; SSFR binning
	END
	6: BEGIN
		low_lim = [7.0, 8.5, 8.8, 9.1]
		up_lim =  [8.5, 8.8, 9.1, 10.]	; log(O/H) + 12 binning
	END	
ENDCASE

FOR j=0,N_ELEMENTS(low_lim)-1 DO BEGIN
	
	bin_no = STRCOMPRESS((j + 1), /remove_all)
	
	CASE whatp1 OF
	    1: param_1 = mass_tot
	    2: param_1 = NUVR_tot
	    3: param_1 = MUst_tot
	    4: param_1 = halo_tot
	    5: param_1 = ssfr_tot
   	    6: param_1 = lgOH_12_tot
    ENDCASE
    
    CASE whatp2 OF
	    1: param_2 = mass_tot
	    2: param_2 = NUVR_tot
	    3: param_2 = MUst_tot
	    4: param_2 = halo_tot
	    5: param_2 = sfr_tot
	    6: param_2 = ssfr_tot
   	    7: param_2 = fapc_tot
   	    8: param_2 = nnpc_tot
   	    9: param_2 = mhpc_tot
   	    10: param_2 = ngal_tot
   	    11: param_2 = lgOH_12_tot
   	    12: param_2 = z_tot
   	    99: param_2 = mass_tot
    ENDCASE

    CASE whatp3 OF
	    1: param_3 = mass_tot
	    2: param_3 = NUVR_tot
	    3: param_3 = MUst_tot
	    4: param_3 = halo_tot
	    5: param_3 = sfr_tot
	    6: param_3 = ssfr_tot
   	    7: param_3 = fapc_tot
   	    8: param_3 = nnpc_tot
   	    9: param_3 = mhpc_tot
   	    10: param_3 = ngal_tot
   	    11: param_3 = lgOH_12_tot
   	    12: param_3 = z_tot
   	    99: param_3 = mass_tot
    ENDCASE
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;; MAKE SURE CORRECT CONDITIONS ARE SET!!!!!
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PRINT, ''
	;; upper and lower limit condition on bins
	CASE BCG_stack OF
	1: BEGIN
		PRINT, 'stacking all galaxies'
	    bin_cond = WHERE((param_1 ge low_lim[j]) AND (param_1 lt up_lim[j]) $
	        AND (param_2 ge lim_ab[0]) AND (param_2 lt lim_ab[1]) $ ; 
	        AND (param_3 ge lim_ii[0]) AND (param_3 lt lim_ii[1]))
	        ; AND (detcode_tot eq 1)
	    END
	2: BEGIN ; isolated
		PRINT, 'stacking isolated central galaxies (Ngal=1 & bcgflag=1)'
	    bin_cond = WHERE((param_1 ge low_lim[j]) AND (param_1 lt up_lim[j]) $
	        AND (param_2 ge lim_ab[0]) AND (param_2 lt lim_ab[1]) $ ; 
	        AND (param_3 ge lim_ii[0]) AND (param_3 lt lim_ii[1]) $
	        AND (ngal_tot eq 1))
	    END
	3: BEGIN ; centrals
		PRINT, 'stacking group central galaxies (Ngal>1 & bcgflag=1)'
	    bin_cond = WHERE((param_1 ge low_lim[j]) AND (param_1 lt up_lim[j]) $
	        AND (param_2 ge lim_ab[0]) AND (param_2 lt lim_ab[1]) $ ; 
	        AND (param_3 ge lim_ii[0]) AND (param_3 lt lim_ii[1]) $
	        AND (BCGflag_tot eq 1) $
	        AND (ngal_tot ge 2))
	    END
	4: BEGIN ; all centrals
		PRINT, 'stacking all central galaxies (Ngal=1)'
	    bin_cond = WHERE((param_1 ge low_lim[j]) AND (param_1 lt up_lim[j]) $
	        AND (param_2 ge lim_ab[0]) AND (param_2 lt lim_ab[1]) $ ; 
	        AND (param_3 ge lim_ii[0]) AND (param_3 lt lim_ii[1]) $
	        AND (BCGflag_tot eq 1))
	    END
	5: BEGIN ; satellites
		PRINT, 'stacking satellite galaxies (Ngal>1 & bcgflag=2)'
	    bin_cond = WHERE((param_1 ge low_lim[j]) AND (param_1 lt up_lim[j]) $
	        AND (param_2 ge lim_ab[0]) AND (param_2 lt lim_ab[1]) $ ; 
	        AND (param_3 ge lim_ii[0]) AND (param_3 lt lim_ii[1]) $
	        AND (BCGflag_tot eq 2))
	    END
    ENDCASE
	PRINT, ''    
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;; MAKE SURE CORRECT CONDITIONS ARE SET!!!!!
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	data_tab = data_tab_tot[bin_cond]
	ndata = N_ELEMENTS(ra_tot[bin_cond])
	ID = ID_tot[bin_cond]
	IAU = IAU_tot[bin_cond]
	ra = ra_tot[bin_cond]
	dec = dec_tot[bin_cond]
	z_arr = z_tot[bin_cond]
	mass = mass_tot[bin_cond]
	mu_st = MUst_tot[bin_cond]
	C = C_tot[bin_cond]
	NUVR = NUVR_tot[bin_cond]
	sfr = sfr_tot[bin_cond]
	ssfr = ssfr_tot[bin_cond]
	halo = halo_tot[bin_cond]
	aamass_hi = mass_hi_tot[bin_cond]
	bcgflag = BCGflag_tot[bin_cond]
	ngal = ngal_tot[bin_cond]
	fapc = fapc_tot[bin_cond]
	nnpc = nnpc_tot[bin_cond]
	lgOH_12 = lgOH_12_tot[bin_cond]


	print, 'There are' + STRCOMPRESS(ndata) + ' galaxies in bin ' + bin_no

	;;1- Restore the .src structures for the galaxies in input ; 
	;;keep two pols separated
	nn=0                    
	nnNdt=0
	nndtc=0
	nconf=0
	
	;print,'ndata',ndata
	;;Define & initialize vectors needed
	stack_specA=DBLARR(nchn)
	stack_specA[*] = 0.d0
	stack_specB=DBLARR(nchn)
	stack_specB[*] = 0.d0
	rms_A_vec=DBLARR(ndata)
	rms_B_vec=DBLARR(ndata)
	rmstotA=0.
	rmstotB=0.
	indx=DBLARR(ndata)
	z_vec=DBLARR(ndata)
	mst_vec=DBLARR(ndata)
	sconfone_up=DBLARR(ndata)
	sconfone=DBLARR(ndata)
	
	;; Open LOG file to save data
	wfile=output+'/'+output+'_bin_'+bin_no+'_LOG.dat'     
	openw, lun, wfile, /get_lun
	printf, lun, 'Stacking '+strcompress(whatstack, /remove_all)+' (1: fluxes, 2: M_HI, 3: M_HI/M_*)'
	printf, lun, 'Beam confusion correction: '+confcorrection
	printf, lun, ' '
	printf, lun, '-------------------------------------------------'
	printf, lun, 'Galaxies skipped:'
	
	;; condition to skip bin it contains too few galaxies
	IF (ndata lt 5) THEN BEGIN
		PRINT, ''
		PRINT, '-------------------------------------------------'
		PRINT, 'Less than 5 galaxies in bin + bin_no'
		PRINT, 'SKIPPING!'
		PRINT, ''
		goto, nogalaxies
	ENDIF


	; take mean values of each bin property
	mean_ms = MEAN(mass)
	mean_mh = MEAN(halo)
	mean_z = MEAN(z_arr)
	mean_mu = MEAN(mu_st)
	mean_c = MEAN(C)
	mean_nuvr = MEAN(NUVR)
	mean_sfr = MEAN(sfr)
	mean_ssfr = MEAN(ssfr)
	mean_aahi = MEAN(aamass_hi)
	mean_fapc = MEAN(fapc)
	mean_nnpc = MEAN(nnpc)
	mean_logOH = MEAN(lgOH_12)
	mean_ngal = MEAN(ngal)

	; take median where appropriate
	median_z = MEDIAN(z_arr)
	median_logOH = MEDIAN(lgOH_12)
	median_ngal = MEDIAN(ngal)

	; and mode
	MODE, bcgflag, mode_bcgflag



	CASE whatp1 OF
	    1: mean_x = MEAN(mass)
	    2: mean_x = MEAN(NUVR)
	    3: mean_x = MEAN(mu_st)
	    4: mean_x = MEAN(halo)
	    5: mean_x = MEAN(ssfr)
	    6: mean_x = MEAN(lgOH_12)
    ENDCASE

	; IF ndata GT 1000 then ndata = 1000
	FOR all=0L,(ndata-1) DO BEGIN
	 
		i=floor(100*all/ndata)		
		progbar, i

		;;check and restore the file if exists, if not warn and skip 
		check=findfile(path+'ID_' + STRCOMPRESS(ID[all], /remove_all)+'.src')

		if (check eq '') then begin
			print,'Source file for galaxy ID_'+ STRCOMPRESS(ID[all], /remove_all)+' not found - skipping'
			goto, exitif
		endif
		restore,path+'ID_' + STRCOMPRESS(ID[all], /remove_all)+'.src'

		;; Check qulity of spectrum
		qlt_flag=src.hd.flag_qlt
		if (qlt_flag eq 0) then begin
			printf, lun, gass[all],'; ',sdss[all],FORMAT ="('GASS ',i6,a,A,': Quality flag =0')"
			goto, exitif
		end 

		;;Read from source file parameters needed
		zspecarr=Z_tot[WHERE(ID_tot eq ID[all], /NULL)]
		zspec = DOUBLE(zspecarr[0,0])
		IF (zspec lt 0.01) or (zspec gt 0.05) THEN BEGIN
			print, ''
			print, MAX(Z_tot)
			print, MIN(Z_tot)
			print, zspec
			print, zspecarr
		ENDIF
		
		wopt=src.hd.input[3]/2.       ;half w_opt if available from TF, or 300/2. km/s
		mstar_arr=mass_tot[WHERE(ID_tot eq ID[all], /NULL)]
		mstar= DOUBLE(mstar_arr[0,0])
		rms_A=src.rms[0]
		rms_B=src.rms[1]

		; print, ''
		; print, 'test ',src.frqarr[511],frq_c,deltaf
		; print, ''

		; Checks to make sure arrays match
		; IF zspec NE (z_arr[all]) THEN BEGIN
		; 	PRINT, ''
		; 	PRINT, Z_tot[WHERE(ID_tot EQ ID[all[j]], /NULL)]
		; 	PRINT, Z[all]
		; 	PRINT, zspec
		; 	PRINT, 'Redshift arrays do not match, check indexing of filelist.'
		; 	PRINT, ''
		; 	STOP
		; ENDIF
		; IF mstar NE (mass[all]) THEN BEGIN
		; 	PRINT, ''
		; 	PRINT, mass_tot[WHERE(ID_tot EQ ID[all[j]], /NULL)]
		; 	PRINT, mass[all]
		; 	PRINT, mstar
		; 	PRINT, 'Mass arrays do not match, check indexing of filelist.'
		; 	PRINT, ''
		; 	STOP
		; ENDIF

		;; Assign pol A and B flux
		sourcefrq = src.frqarr ; Frequency
		specA_in = src.specpol.YARRA
		specB_in = src.specpol.YARRB
		; plot, (specA_in+specB_in)/2, charsize=2
		weightA = src.weight.wspeca
		weightB = src.weight.wspecb

		;;; Set spec to 0 where weight < 0
	    w = WHERE((weightA lt 0.1) or (weightB lt 0.1))
	    specA_in[w] =  0
	    specB_in[w] =  0

		CASE whatstack of 
		    1: begin
		        specA=specA_in ;flux
		        specB=specA_in
		    END
		    2: BEGIN             ;M_HI
		        specA=DOUBLE(specA_in*lumdist(zspec,/silent)^2/(1.+zspec))      
		        specB=DOUBLE(specB_in*lumdist(zspec,/silent)^2/(1.+zspec))         
		    END
		    3: BEGIN             ;M_HI/M_*
		        specA=DOUBLE(specA_in*lumdist(zspec,/silent)^2/(1.+zspec)/10.d0^mstar)
		        specB=DOUBLE(specB_in*lumdist(zspec,/silent)^2/(1.+zspec)/10.d0^mstar)
		    END
		ENDCASE

		;;---------------------------------------------------------------
		;; 2- shift each spectrum so that its central freq in in chn 511 ;
		frq_c=DOUBLE(restfrq/(zspec + 1.))
		d_ch=floor((src.frqarr[511]-frq_c)/(deltaf))
        ; print, ''
        ; print, 'test ',src.frqarr[511],frq_c,deltaf
        ; print, ''
		freqshift,d_ch,specA,spec_outA
		freqshift,d_ch,specB,spec_outB
		
		;;---------------------------------------------------------------
		;;3- Weighted co-adding
		stack_specA=stack_specA+spec_outA/(rms_A^2)
		stack_specB=stack_specB+spec_outB/(rms_B^2)
		yyy=(spec_outA+spec_outB)/2
		if total(yyy) eq 0.d0 then begin 
			
			print,''
			print,zspec_arr
			print,zspec
			print, mstar
			print,id[all]
			stop
		endif

		IF KEYWORD_SET(plot) THEN BEGIN

			plot, frqarr, (spec_outA+spec_outB)/2,$
		       YRANGE=[MIN((spec_outA+spec_outB)/2), 1.2*MAX((spec_outA+spec_outB)/2)],$
		           XRANGE=[MIN(frqarr), MAX(frqarr)], Title= 'spec ID:'+ID[all],$
		           	XTITLE = STRCOMPRESS(ID[all])

		    ; plot, frqarr, (stack_specA+stack_specB)/2,$
		    ;    YRANGE=[ -MAX((stack_specA+stack_specB)/2)/2, MAX((stack_specA+stack_specB)/2)], $
		    ;        XRANGE=[MIN(frqarr), MAX(frqarr)], Title= STRCOMPRESS(all),$
		    ;        	XTITLE = STRCOMPRESS(ID[all])
		
		ENDIF
		
		rms_A_vec[nn]=rms_A
		rms_B_vec[nn]=rms_B
		rmstotA=rmstotA+1/(rms_A^2)
		rmstotB=rmstotB+1/(rms_B^2)
		z_vec[nn]=zspec[0]
		mst_vec[nn]=mass[all]
		
		indx[nn]=all
		nn=nn+1
		;;count how many detection or non detection you have
		if (data_tab[all].code eq 1 or data_tab[all].code eq 2) then begin 
			nnDtc=nndtc+1
		endif else begin   
			nnNdt=nnNdt+1
		endelse

		;;---------------------------------------------------------------
		;;4-CONFUSION CORRECTION, if ASKED
		;;--------------------------------------------------------------
		if (conf_flag eq 1) then begin    
			;;1) search for neigh inside arecibo beam (restore structures)
			;; If no structure 
			gass_name=strcompress(data_tab[all].gass, /remove_all)
			;if (FILE_TEST('/afs/mpa/data/fabello/NEIGHB/n_'+gass_name+'.src') eq 0) then goto,exitif
			;restore,'/afs/mpa/data/fabello/NEIGHB/n_'+gass_name+'.src'
		if (FILE_TEST('/Users/thbrown/Documents/TOBY_STACKING//NEIGHB/n_'+gass_name+'.src') eq 0) then goto,exitif
		restore,'/Users/thbrown/Documents/TOBY_STACKING/NEIGHB/n_'+gass_name+'.src'
		
		if (neigh.N_BEAM gt 1) then begin
			index_c=where(neigh.flag_r eq 99)
			;;Get parameters of confused objects need for estimating their
			;;gas fractions.
			magt=neigh.mag[0,*]  ;k and gal. ext corrected g
			mag0=magt[index_c]
			magt=neigh.mag[1,*]  ;k and gal. ext corrected r
			mag1=magt[index_c]
			magt=neigh.mag[2,*]  ;k and gal. ext corrected i
			mag2=magt[index_c]
			petrt=neigh.petrR50[3,*] ;i band
			petrR50=petrt[index_c]
			wng=neigh.width[index_c]/2. ;half width, corrected for inclination
			
			ra_ng=neigh.ra[index_c]
			dec_ng=neigh.dec[index_c]
			MSTAR_ng=neigh.MSTAR[index_c]
			z_ng=neigh.z[index_c]
			
		for ngh=0,neigh.N_BEAM-1 do begin ;loop over neigh inside beam
			;;estimate Log gas fraction from Zahng
			mu_i=MAG2[ngh]+2.5*alog10(2.*!dpi*petrR50[ngh]*petrR50[ngh])
			lgf = -1.73238*(mag0[ngh]-mag1[ngh])+0.215182*mu_i-4.08451
			;if (lgf gt 0.18) then lgf=0.18 ;if
			;want to set up-lim to gf estimated
			Sexp=10^lgf*10^MSTAR_ng[ngh]/2.356/10.^4/10./lumdist(z_ng[ngh],/silent)^2 ;Jy
			deltav=70*abs(lumdist(z_ng[ngh],/silent)-lumdist(z,/silent))
			;;1) Check that estimated flux not higher than rms, or
			;;it would have been discarded by visual inspection.
			if (deltav ge 50) then begin
				;;if flux[mJy] > 2.2 mJy
			if (Sexp/wng[ngh]*1000. gt 2.2) then lgf=alog10(2.356*10.^4*10.*lumdist(z_ng[ngh])^2*Sexp)-MSTAR_ng[ngh]
			endif
			;; There would be the possibility of measuring flux
			;; from AA if structures for neiighbours/satellite availale
			;;define structure name=gass+ra+dec
			;ra_name=strcompress(ran[ngh], /remove_all)
			;dec_name=strcompress(decn[ngh], /remove_all)
			;z_name=strcompress(z_ng[ngh], /remove_all)
			;name=ra_name+'+'+dec_name+'-'+z_name
			;check=findfile('/afs/mpa/data/fabello/SRCSAT/'+name+'.src')                    
			;if (check eq ' ') then goto, skip_n 
			;restore,'/afs/mpa/data/fabello/SRCSAT/'+name+'.src'
			;spec_n=0.5*(src.specpol.yarrA+src.specpol.yarrb)
			;vmin=70*lumdist(zn[ngh],/silent)-wn[ngh]
			;vmax=70*lumdist(zn[ngh],/silent)+wn[ngh]
			;index_v=where(src.velarr[where(src.velarr ge vmin and src.velarr le vmax)])
			;Sint=total(spec_n[index_v])
			;if (Sint le 0) then Sint=0 ;now mJy
			;if (Sint/wn[ngh] gt 2.2) then lgf=alog10(2.356*10.^4*10.*lumdist(zn[ngh])^2*Sint/1000.)-MSTARn[ngh]
			
			;;2) Estimate correction for beam efficiency (function of projected separation and 
			;; beam response)
			x=abs(ra_ng[ngh]-ra[all])
			y=abs(dec_ng[ngh]-dec[all])
			fb=exp(-.5*(x/sx)^2-.5*(y/sy)^2) ;beam attenuation
			
			;;3) Estimate correction for velocity overlap
			fv=0.
			;;if dv greater than sum half width-> no overlap!
			;;if dv smaller than sum half width, overlap correction: 
			if (deltav lt (wopt+wng[ngh]) ) then fv = deltav/(2.*wng[ngh])
			if (fv gt 1) then fv=1
			
			;; Sum all effective contributions
			s = fb*10^lgf*10^MSTAR_ng[ngh]*(1+z_ng[ngh])/lumdist(z_ng[ngh],/silent)^2
			sconfone_up[all]= sconfone_up[all]+s             
			sconfone[all]= sconfone[all]+s*fv             
			
			;gfext[nconf,*]=[10^lgf,fB,fv]
			;cdist_vec[nconf]=sqrt(x^2+y^2)
			;cvel_vec[nconf]=deltav
			nconf=nconf+1
			skip_n:
		endfor
		endif
		
		sconfone[all]=sconfone[all]*lumdist(zspec[0],/silent)^2/10^mstar/(1.+zspec[0])/(rms_A)^2 
		;;There should be factor sqrt(2) because of two pols. Used only one
		;;(A&B similar), and factor deletes with another one later  
		sconfone_up[all]=sconfone_up[all]*lumdist(zspec[0],/silent)^2/10^mstar/(1.+zspec[0])/(rms_A)^2 
		
		
		endif
		exitif:
	ENDFOR   
	printf, lun, '-------------------------------------------------'
	printf, lun, ' '

	print,' '
	print,nn,ndata,format="('(good) data found for ',i4,'/',i4,' input objects')"
	print,'N CONF',nconf  
	printf, lun, nn,ndata,format="('(good) data found for ',i4,'/',i4,' input objects')"
	printf, lun, nconf,format="('Number of contaminant neighbours:  ',i4)"
	free_lun, lun

	;;mean
	z_avg=mean(z_vec[0:nn-1])
	mst_avg=mean(10^mst_vec[0:nn-1])

	index=indx[0:nn-1]


	print,'rms = ', rmstotA, rmstotB
	; plot, (stack_specA+stack_specB)/2, charsize=2

	stack_specA=stack_specA/rmstotA
	stack_specB=stack_specB/rmstotB

	stack_specA_flx=fltarr(nchn)
	stack_specB_flx=fltarr(nchn)
	stack_specA_mhi=fltarr(nchn)
	stack_specB_mhi=fltarr(nchn)
	stack_specA_gf=fltarr(nchn)
	stack_specB_gf=fltarr(nchn)
	case whatstack of 
	1: begin                   ;Flux
	stack_specA_flx=stack_specA
	stack_specB_flx=stack_specB
	end
	2: begin                   ;M_HI
	stack_specA_mhi=stack_specA
	stack_specB_mhi=stack_specB
	end
	3: begin                   ;M_HI/M_*
	stack_specA_gf=stack_specA
	stack_specB_gf=stack_specB
	end
	endcase


	;;--------------------------------------------------------------
	;  4) sum all secondary fluxes, all galaxies
	;;--------------------------------------------------------------
	sconf_up=0
	sconf=0
	if (conf_flag eq 1) then begin    
	if (nconf gt 0) then begin 
		sconf_up=total(sconfone_up[0:nn-1])/rmstotA
		;; Here the other factor sqrt(2) which deletes with one above
		sconf=total(sconfone[0:nn-1])/rmstotA
	endif
	endif

	print,'---------------------------------------------------'
	print,'avg rms over all pol A =',total(rms_A_vec[0:nn-1])/nn,'+-',stdev(rms_A_vec[0:nn-1]),' [mJy]'
	print,'avg rms over all pol B =',total(rms_B_vec[0:nn-1])/nn,'+-',stdev(rms_B_vec[0:nn-1]),' [mJy]'
	print,'---------------------------------------------------'
	
	rmsav=total(rms_A_vec[0:nn-1])/nn
	rmsbv=total(rms_B_vec[0:nn-1])/nn

	;-------------------------------------------------
	;;FINAL Save
	print,''
	print,''
	print,' ------- SUMMARY --------------------------------------------------------------'
	print,' ------------------------------------------------------------------------------'
	print,'--> outputs:'
	print,output+'/'+output+'_bin_'+bin_no+'.sav'
	print,''
	print,' ------------------------------------------------------------------------------'
	print,''

	sname=output+'/'+output+'_bin_'+bin_no+'.sav'

	hd={input:[z_avg,mst_avg,whatstack, conf_flag],file:output,index:index}
	red={edge:[0,0],edge_err:[0,0],bmask:intarr(nchn),bord:0,smooth:0} ;reduction parameter
	specA={flx:stack_specA_flx,mhi:stack_specA_mhi,gf:stack_specA_gf}  
	specB={flx:stack_specB_flx,mhi:stack_specB_mhi,gf:stack_specB_gf} 
	spec={flx:fltarr(nchn),mhi:fltarr(nchn),gf:fltarr(nchn)} 
	S={totS:0.,totSerr:0.,totSerr_sys:0.,totSerr_tot:0.}
	MHI={totMHI:0.,totMHIerr:0.,totMHIerr_sys:0.,totMHIerr_tot:0.}
	GF={totGF:0.,totGFerr:0.,totGFerr_sys:0.,totGFerr_tot:0.}
	sn={flx:fltarr(3),mhi:fltarr(3),gf:fltarr(3)}

	stack ={hd:hd, $       ;z mean,mst mean, 0,0,0
			nused:[nn,nnNdt,nnDtc,nconf], $
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
			params:[whatp1, whatp2, whatp3, BCG_stack],$
			lims:[[low_lim], [up_lim]],$ ; bin limits
			lim_ab:lim_ab,$
			lim_ii:lim_ii,$
			mean_binp:[mean_ms, mean_mh, mean_z, mean_mu, mean_c, mean_nuvr,$
						mean_sfr, mean_ssfr, mean_aahi, mean_fapc, mean_nnpc,$
						 	mean_logOH, mean_ngal],$ 
			median_binp:[median_z, median_logOH, median_ngal],$ ; avg bin properties
			mode_bcgflag:mode_bcgflag, $
			mean_x:mean_x,$ ; avg x-axis value per bin
			detflag:[1], $ ; flag if stack is detection (1) or non-detections (0), default detection, changed in HI_measure
			c_factor:[sconf_up,sconf]} ;flux confusion factor
	save,stack,file=sname		
	print,' '
	close, lun
	nogalaxies:
ENDFOR

!P.MULTI=0
END;
