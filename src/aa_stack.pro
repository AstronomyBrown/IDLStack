; docformat = 'rst'

;+
; The purpose of aa_stack is to stack ALFALFA HI spectra in user defined bins. By setting user options, 
; the stacking procedure can be done in flux, HI mass or gas fraction units.
;
; The program's default inputs are contained in the accompanying 'inputexample.cfg'.
; 
; If \specplot keyword is set, aa_stack requires the `Coyote Library <http://www.idlcoyote.com/documents/programs.php>`
; to be installed on your machine.
;
; :Author:
;    Toby Brown
;
; :History:
;    Written by Toby Brown (April 2017). Based upon routines written by Silvia Fabello (April 2009).
;
;    Given an input parameter file, select galaxies, restore the corresponding structures
;     and stack the spectra; save the stacked structure.
;
; :Examples:
;    aa_stack is a main level procedure included in aa_stack.pro::
;
;       IDL> .r aa_stack.pro  
;
;    An example input file is provided with this distribution::
;
;       IDL> aa_stack, 'inputexample.cfg'
;
;    Stacks galaxies indexed by 'sample.fits' according to options defined in .cfg file, saves output::
;
;       IDL> aa_stack, 'inputexample.cfg', /usrinput, /specplot
;
;    Stacks galaxies indexed by 'sample.fits', **asks user to input commands and bin limits,
;     plots output spectrum**, saves output::
;
;-

;+
; Calculates the mode of an array.
; Works ONLY with integer data.
;
; Helper routine for main `aa_stack` routine. This routine is not
; intended to be called from anywhere except `idldoc_rst_template`, so it is
; marked with the `:Private:` tag. Routines/files marked with `:Private:` will
; show up in documentation created for developers (`IDLDOC, USER=0`), but not
; for users (`IDLDOC, /USER`).
;
; :Obsolete:
; :Private:
;-
pro MODE, array, mode
   On_Error, 2
   ; Check for arguments.
   if N_Elements(array) eq 0 then Message, 'Must pass an array argument.'
   ; Is the data an integer type? if not, exit.
   dataType = Size(array, /Type)
   if ((dataType gt 3) and (dataType lt 12)) then Message, 'Data is not INTEGER type.'
   ; Calculate the distribution frequency
   distfreq = Histogram(array, MIN=Min(array))
   ; Find the maximum of the frequency distribution.
   maxfreq = Max(distfreq)
   ; Find the mode.
   mode = Where(distfreq eq maxfreq, count) + Min(array)
   ; Warn the user if the mode is not singular.
   if count ne 1 then ok = Dialog_Message('The MODE is not singular.')

end

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
; :Params:
;    cfgfile : in, required, type=string
;                Configuration file containing path to sample catalogue, options for stacking routine,
;                bin edges (see 'inputexample.cfg').
; :Description:     
;   Procedure
;   ---------
;
;        1. Read input config file containing sample catalogue, output directory name, stacking options
;           and bin limits
;
;        2. [Optional] If usrinput kwarg set (`aa_stack, /usrinput`), user enters output directory name, stacking options and
;             bin limits
;
;        3. Select sample that has valid parameters, in particular metallicity and SF estimates are not 
;           available for all galaxies
;
;        4. Iteratively bin sample for stacking. In general, bin limits are passed from the configuration file,
;          however, 2D box bin limits (e.g. across the MZR) are hard coded for the moment.
;
;        5. Restore .src structures for galaxies in this bin
;
;        6. Read spectrum and, according to user inputs, weight spectrum by mass and/or redshift if required.  
;
;        7. Shift each spectrum so that galaxy central freq is at rest frq [chn 511]
;
;        8. Stack spectra, weighting by their rms
;
;        9. [Optional] If (`aa_stack, /specplot`) kwarg set, plot stacked spectrum to screen
;
;        10. Save output and metadata as IDL structure
;
;   Outputs
;   -------
;    'output/output_bin_no.sav' - file containing a stack spectrum's structure, as follows::
;
;        hd.input    - mean z, stellar mass, flag for stacked quantity
;
;        hd.file     - name of output file   
;
;        hd.index    - ID of galaxies in each stack
;
;        nused       - galaxies used, detected 
;
;        frqarr      - frequency array 
;
;        speca/specb - flux,mhi,gf: Array[nchannels], stacked spectrum for each polarization (the two options not chose are empty) 
;
;        RED         - Reduction parameters (filled after reduction in 'aa_measure.pro') 
;
;        RMS         - average rms polA, average rms polB, plus empty filled after reduction 
;
;        S, MHI,GF   - Total flux, HI mass, gas fractions, filled after reduction 
;
;        usrparam    - Parameters for this run of aa_stack.pro [whatp1, whatp2, whatp3, BCG_stack, CDFstack] 
;
;        p1lim       - bin limits on 1st order galaxy property (i.e. fixed stellar mass)
;
;        p2lim       - bin limits 2nd order property
;
;        p3lim       - bin limits 3rd order property
;
;        mean_x      - avg value per X-axis bin 
;
;        mean_binp   - average galaxy properties in each bin (see below)
;
;        detflag     - flag if stack is detection (1) or non-detections (0), default detection, changed in HI_measure
;
;       
; The following average properties of each bin are provided in mean_binp::
;
;        mean_ms          - stellar mass [log Msol]
;
;        mean_mh          - halo mass [log Msol]
;
;        mean_z           - redshift
;
;        mean_mu          - stellar surface density [log Msol kpc^-2]
;
;        mean_c           - concentration index
;
;        mean_nuvr        - NUV-r [mag]
;
;        mean_gr          - g-r [mag]
;
;        mean_sfr         - SFR [log Msol yr^-1]
;
;        mean_ssfr        - SSFR [log yr^-1]
;
;        mean_aahi        - HI mass [log Msol]
;
;        mean_fapc        - fixed aperture density percentile rank
;
;        mean_nnpc        - nearest neighbour density percentile rank
;
;        mean_ngal        - group multiplicity
;
;        mean_logOH       - metallicity [log OH + 12]
;
;        mean_sfr_tot_mpa - MPA/JHU total SFR [log Msol yr^-1]
;
;        mean_sfr_fib_mpa - MPA/JHU fibre SFR [log Msol yr^-1]
;
;        mean_sfr_fib_Ha  - Halpha fibre SFR [log Msol yr^-1]
;
;        mean_sfr_SED     - GSWLC fibre SFR [log Msol yr^-1]
;
; And median::
;
;        median_z         - redshift
;
;        median_logOH     - metallicity [log OH + 12]
;
;        median_ngal      - group multiplicity
;
;       
; 'output_bin_no_LOG.dat' - Logfile with the following information::
;        - Flags set by users.   
;        - Track of galaxies skipped because .src is missing, or quality flag is 0.
;        - Summary of numbers used
;
; :Keywords:
;    usrinput : in, optional, type=boolean
;       This tells aa_stack to accept manually entered stacking parameters, rather than from cfgfile
;    specplot : in, optional, type=boolean
;       Plot each stacked spectrum to screen. (WARNING: Slows aa_stack runtime considerably.)
;       
; :Uses: 
;    freqshift progbar
;       
; :Bugs:
;    Two dimensional bins are, for the moment, hard coded i.e. they are not passed from the input file.
;
; :Categories: 
;    Data analysis, spectral stacking, ALFALFA software
;
;  
;-
pro aa_stack, cfgfile, usrinput = usrinput, specplot = specplot

;;---------------------------------------------------------------------------------------------
; 0 - Read input config file containing sample catalogue, output directory name, stacking options
;     and bin limits
;

paramf = gm_read_textstructure(cfgfile)

print, ''
print, 'Please check that you have defined the correct inputs in the configuration file (e.g. params.cfg). '$
+ 'These are listed below and will be saved int the param.log file.'
print, ''
print, 'parameters in input file:'
help, paramf
print, ''

; Inputs
path=paramf.path ; source path
sampledir=paramf.sampledir ; database path
listname=paramf.listname ; database name

samplef = sampledir+listname

; Constants used
restfrq=double(paramf.restfrq)    ; HI rest freq [MHz]
deltaf=double(paramf.deltaf)    ; ALFALFA channel width [MHz/chn]
nchn=double(paramf.nchn)  ; no. ALFALFA channels
fib_diameter=double(paramf.fib_diameter) ;  diameter of SDSS fiber [arcsec]

; User defined parameters and flags
whatstack=fix(paramf.whatstack) ;  stack fluxes (1), MHI (2) or gas fractions (3)
BCG_stack=fix(paramf.BCG_stack) ;  all (1), isolated centrals (2), group centrals (3), all centrals (4), satellites (5)
sfrstack=fix(paramf.sfrstack) ; MPA-JHU total [Brinchmann+2004] (1), SED total [Salim+2016] (2), Halpha fibre [Kennicut+1998] (3)
lgOHstack=fix(paramf.lgOHstack) ; None (1), Mannucci+2010 (2), Tremonti+2004 (3), Kewley+Dopita 2002 (4)
CDFchoice=paramf.boxbin_choice;  Use 2 dimensional binning Y/N (limited functionality)
; if CDFchoice=Y, select plane across which to bin 
CDFstack=fix(paramf.boxstack) ; stellar mass-metallicity (1), stellar mass-SFR (2), stellar mass-sSFR (3)

whatp1=fix(paramf.whatp1) ; first order parameter - basically the x-axis in gf-X plane
whatp2=fix(paramf.whatp2) ; second and
whatp3=fix(paramf.whatp3) ; third order binning

; Output
output=paramf.output ;  output directory

; Limits used to bin sample for stacking
; gf_stack.pro, gf_measure.pro and gf_error.pro support two different modes of sample binning.
; 1 - 1D binning, setting second and third parameters within limits
; 2 - 2D binning accross a specified parameter space.
; Note: If a property is not chosen bins are not used at all.

;;;;; 2Dchoice=N BINNING ONLY ;;;;;;;;;;;;;;
; set the limits for the parameter chosen above.
mstar_lims=double(paramf.mstar_lims)
nuvr_lims=double(paramf.nuvr_lims)
mustar_lims=double(paramf.mustar_lims)
mhalo_lims=double(paramf.mhalo_lims)
ssfr_lims=double(paramf.ssfr_lims)
logOH_lims=double(paramf.logOH_lims)
gr_lims=double(paramf.gr_lims)

; choose limits of second and third parameter
p2lim=double(paramf.p2lim)
p3lim=double(paramf.p3lim)

;;Define final frequency array: 1024 chn, 1420MHz (v_0=V_syst) in chn 511.
frqarr=restfrq+(findgen(nchn)-511)*deltaf ;frequency array

; read in standard columns from fits file
data_tab_tot=mrdfits(samplef,1)
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
petroR50_r = data_tab_tot.petroR50_r
mass_hi_tot = data_tab_tot.log_MHI
detcode_tot = data_tab_tot.code ; 1 = det

; Establish error handler. When errors occur, the index of the
; error is returned in the variable Error_status:
CATCH,/CANCEL
CATCH, Error_status

;This statement begins the error handler:
if Error_status ne 0 then begin
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    PRINT, 'Columns are missing from file.'
    print, ''
    CATCH, /CANCEL
    ; Handle the error:
    ngal_tot = fltarr(n_elements(ra_tot))
    BCGflag_tot = fltarr(n_elements(ra_tot))
    sfr_tot_mpa_tot = fltarr(n_elements(ra_tot))
    sfr_fib_mpa_tot = fltarr(n_elements(ra_tot))
    sfr_tot_Ha_tot = fltarr(n_elements(ra_tot))
    sfr_tot_SED_tot = fltarr(n_elements(ra_tot))
    ssfr_tot = fltarr(n_elements(ra_tot))
    fapc_tot = fltarr(n_elements(ra_tot))
    nnpc_tot = fltarr(n_elements(ra_tot))
    mhpc_tot = fltarr(n_elements(ra_tot))
    iclass_tot = fltarr(n_elements(ra_tot))
    AGN_K01 = fltarr(n_elements(ra_tot))
    AGN_K03 = fltarr(n_elements(ra_tot))
    W1_W2 = fltarr(n_elements(ra_tot))
    OIII_tot = fltarr(n_elements(ra_tot))
    goto, skipread
endif

; Read in Environment, SF data etc and catch errors if no cols.
BCGflag_tot = data_tab_tot.flag_mstar ; 1 = BGG, 2 = satelite
ngal_tot = data_tab_tot.Ngal ; number of galaxies in group
sfr_tot_mpa_tot = data_tab_tot.SFR_MEDIAN_tot ; Aperture orrected MPA sfr
sfr_fib_mpa_tot = data_tab_tot.SFR_MEDIAN_fib ; Fiber MPA sfr
sfr_tot_Ha_tot = data_tab_tot.SFR_K98 ; Halpha (kennicutt 1998)
sfr_tot_SED_tot = data_tab_tot.logSFR_SED_S16 ; salim optical/UV
sfr_
ssfr_tot = data_tab_tot.sSFR_MEDIAN_tot ;
fapc_tot = data_tab_tot.fa_prank ; fixed aperture percentage rank
nnpc_tot = data_tab_tot.nn7_prank ; nth Neighbour percentage rank
mhpc_tot = data_tab_tot.mh_prank ; nth Neighbour percentage rank
iclass_tot = data_tab_tot.I_CLASS ; ionisation class
AGN_K01 = data_tab_tot.AGN_K01_flag ; Kewley+ 01 AGN class
AGN_K03 = data_tab_tot.AGN_K03_flag ; Kauffmann+ 03 AGN class
W1_W2 = data_tab_tot.W1_W2 ; W1-W2 colour
OIII_tot = data_tab_tot.OIII_sara ; OIII_sara

skipread:
print,'Total no. input objects:', ndata_tot
print, ''

; Calculate covering fraction of fibre. See Bothwell+13 & Kewley+05
; small angle approx
fib_diam_kpc = (fib_diameter * lumdist(z_tot,/silent)*1000)/206265 ; Mpc->kpc arcsec->radian
fib_area = !PI * (fib_diam_kpc/2)^2
gal_area = !PI * petroR50_r^2

; g-r
gr_tot = data_tab_tot.modelMag_g - data_tab_tot.modelMag_r

;;---------------------------------------------------------------------------------------------
; 0.5 - [Optional] Upon setting /usrinput kwarg, output directory name, user can enter 
;            stacking options and and bin limits

; Ask user for options if keyword set
if KEYWORD_SET(usrinput) then begin
    ; create directory in which results will be written
    read, output, prompt='Please enter output directory name: '

    ; select stacking units
    read,whatstack,prompt='Do you want to stack fluxes (1), M_HI (2) or gas fractions (3)?  [1] '

    ; select the SFR estimate
    sfrstack_str = ['', 'Choose SFR estimate...' $
                      , '... MPA total [B04] (1), SED integrated [S16] (2), Halpha SFRs [K98] (3)?', '']
    print, sfrstack_str, FORMAT='(A)' 
    read, sfrstack ,prompt=''

    ; select abundance estimate
    lgOHstack_str = ['','Choose Zgas calibration...','... None (1), Zgas [M08] (2), Zgas [T04] (3), Zgas [K08] (4)?', '']
    print, lgOHstack_str, FORMAT='(A)' 
    read, lgOHstack ,prompt=''

    ; choose galaxies cent/sat
    BCG_stack_str = ['' , 'Select the sample you want to stack:' $
                        , 'all galaxies: 1' $
                        , 'isolated centrals: 2' $ 
                        , 'group centrals: 3' $
                        , 'all centrals: 4' $
                        , 'satellites: 5', '']
    print, BCG_stack_str, FORMAT='(A)' 
    read, BCG_stack ,prompt=''
    print, ''

    ; bin in 2 dimensions
    CDFchoice_str = ['', 'Are you stacking using cumulative distribution function (CDF) binning?' $
                       , '(y/N)', '']
    print, CDFchoice_str, FORMAT='(A)' 
    read, CDFchoice ,prompt=''

    CDFchoice = strmid(strupcase(CDFchoice),0,1)
    if CDFchoice eq 'Y' then begin
        CDFstack_str = ['','Which CDF bins do you want to stack?' $
                          , 'Mass-Metallicity: 1' $
                          , 'Mass-SFR: 2' $ 
                          , 'Mass-sSFR: 3', '']
        print, CDFstack_str, FORMAT='(A)' 
        read, CDFstack ,prompt=''
        goto, paramskip
    endif

    ; Select the parameters and set limits
    whatp1_str = ['', 'What is the first parameter? ' $
                    , '1: stellar mass [log Msol]' $
                    , '2: NUV-r [mag]' $
                    , '3: stellar surface density [log Msol kpc^-2]' $
                    , '4: halo mass [log Msol]' $
                    , '5: sSFR [log yr^-1]' $
                    , '6: metallicity [log O/H + 12]' $
                    , '7: g-r [mag]' $
                    , '8: L(OIII) [log erg/s]', '']
    print, whatp1_str, FORMAT='(A)' 
    read,whatp1,prompt=''

    print, ''
    whatp2_str = ['', 'What is the second parameter? ' $
                    , '1: stellar mass [log Msol]' $
                    , '2: NUV-r [mag]' $
                    , '3: stellar surface density [log Msol kpc^-2]' $
                    , '4: halo mass [log Msol]' $
                    , '5: sSFR [log yr^-1]' $
                    , '6: metallicity [log O/H + 12]' $
                    , '7: g-r [mag]' $
                    , '8: L(OIII) [log erg/s]' $
                    , '9: SFR [log Msol yr^-1]' $
                    , '10: fixed aperture density percentile rank' $
                    , '11: nearest neighbour density percentile rank' $
                    , '12: halo mass percentile rank' $
                    , '13: group multiplicity' $
                    , '14: redshift' $
                    , '15: Kewley+01 AGN classification flag' $
                    , '16: Kauffmann+03 AGN classification flag' $
                    , '17: W1-W1 colour [mag]' $
                    , '99: none (only allowed for p2 and p3)', '']
    print, whatp2_str, FORMAT='(A)'
    p2lim = [-99., 99.]
    read,whatp2,prompt=''

    if whatp2 lt 99 then read,p2lim,prompt='Enter limits for parameter 2 (e.g. >>> -99,99): '
    print, ''
    whatp3_str = ['', 'What is the second parameter? ' $
                    , '1: stellar mass [log Msol]' $
                    , '2: NUV-r [mag]' $
                    , '3: stellar surface density [log Msol kpc^-2]' $
                    , '4: halo mass [log Msol]' $
                    , '5: sSFR [log yr^-1]' $
                    , '6: metallicity [log O/H + 12]' $
                    , '7: g-r [mag]' $
                    , '8: L(OIII) [log erg/s]' $
                    , '9: SFR [log Msol yr^-1]' $
                    , '10: fixed aperture density percentile rank' $
                    , '11: nearest neighbour density percentile rank' $
                    , '12: halo mass percentile rank' $
                    , '13: group multiplicity' $
                    , '14: redshift' $
                    , '15: Kewley+01 AGN classification flag' $
                    , '16: Kauffmann+03 AGN classification flag' $
                    , '17: W1-W1 colour [mag]' $
                    , '99: none (only allowed for p2 and p3)', '']    
    print, whatp3_str, FORMAT='(A)' 
    p3lim = [-99., 99.]
    read,whatp3,prompt=''
    if whatp3 lt 99 then read,p3lim, prompt='Enter limits for parameter 3 (e.g. >>> -99,99): ' 
    print, ''
endif

; SFR indicators
case sfrstack of
    1: sfr_tot = sfr_tot_mpa_tot
    2: sfr_tot = sfr_tot_SED_tot
    3: sfr_tot = sfr_tot_Ha_tot
endcase

CATCH, /cancel
CATCH, ERROR

if (ERROR ne 0L) then begin
    CATCH, /cancel
    print, 'No Metallicities in input file'
    print, ''
    lgOH_12_tot = fltarr(n_elements(ra_tot))
    lgOH_12_tot[where(lgOH_12_tot[*] eq 0.)] = !Values.F_NAN
    goto, skipmetal
endif

if lgOHstack eq 1 then begin
    lgOH_12_tot = fltarr(n_elements(ra_tot))
    lgOH_12_tot[where(lgOH_12_tot[*] eq 0.)] = !Values.F_NAN
endif

; assign different Z calibrations
case lgOHstack of
    1: begin
        print, ''
        print, 'No Metallicities used'
        print, ''
        lgOH_12_tot = fltarr(n_elements(ra_tot))
        lgOH_12_tot[where(lgOH_12_tot[*] eq 0.)] = !Values.F_NAN
    end
    2: lgOH_12_tot = data_tab_tot.lgOH_M10
    3: lgOH_12_tot = data_tab_tot.lgOH_MEDIAN_T04
    4: lgOH_12_tot = data_tab_tot.lgOH_K08
endcase

zgas_M08_tot = data_tab_tot.lgOH_M10
zgas_T04_tot = data_tab_tot.lgOH_MEDIAN_T04

CATCH, /CANCEL

;;---------------------------------------------------------------------------------------------
;       1 - Select sample that has valid parameters, in particular metallicity and SF estimates are not 
;           available for all galaxies

; if metallicities required, select valid estimates
if lgOHstack ge 2 then begin

    rad_covfrac = (fib_area/gal_area) *100
    print, 'No. galaxies w/ fibre covering > 20% area:', N_ELEMENTS(rad_covfrac[WHERE(rad_covfrac ge 20)])

    sfr_covfrac = (10^sfr_fib_mpa_tot/10^sfr_tot_mpa_tot)*100
    print, 'No. galaxies w/ fibre picking up > 20% SF:',N_ELEMENTS(sfr_covfrac[WHERE(sfr_covfrac ge 20)])

    print, 'Selecting galaxies w/ mstar <= 10^11 and valid Zgas and SFR calibrations:'

    valid_metal = WHERE((zgas_M08_tot gt 0.) and $
                        (zgas_T04_tot gt 0.) and $
                        (sfr_tot_mpa_tot gt -99) and $
                        (sfr_tot_Ha_tot gt -99) and $
                        (sfr_tot_SED_tot gt -99) and $
                        ; (rad_covfrac ge 20) and $
                        ; (sfr_covfrac ge 20) and $
                        (mass_tot LE 11.))

    ra_tot = ra_tot[valid_metal]
    dec_tot = dec_tot[valid_metal]
    z_tot = z_tot[valid_metal]
    mass_tot = mass_tot[valid_metal]
    ID_tot = ID_tot[valid_metal]
    IAU_tot = IAU_tot[valid_metal]
    halo_tot = halo_tot[valid_metal]
    MUst_tot = MUst_tot[valid_metal]
    C_tot = C_tot[valid_metal]
    NUVR_tot = NUVR_tot[valid_metal]
    mass_hi_tot = mass_hi_tot[valid_metal]
    detcode_tot = detcode_tot[valid_metal]
    BCGflag_tot = BCGflag_tot[valid_metal]
    ngal_tot = ngal_tot[valid_metal]
    sfr_tot = sfr_tot[valid_metal]
    ssfr_tot = ssfr_tot[valid_metal]

    sfr_tot_mpa_tot = sfr_tot_mpa_tot[valid_metal]
    sfr_fib_mpa_tot = sfr_fib_mpa_tot[valid_metal]
    sfr_tot_Ha_tot = sfr_tot_Ha_tot[valid_metal]
    sfr_tot_SED_tot = sfr_tot_SED_tot[valid_metal]

    fapc_tot = fapc_tot[valid_metal]
    nnpc_tot = nnpc_tot[valid_metal]
    mhpc_tot = mhpc_tot[valid_metal]
    lgOH_12_tot = lgOH_12_tot[valid_metal]
    print, 'No. objects:',N_ELEMENTS(ra_tot)
    print, ''
endif

skipmetal:
spawn,'mkdir '+output
print,'Results will be in directory ',output
print, ''

; selection added to use correct percentage ranks according to sat/cent/all designation
if BCG_stack eq 5 then begin
    fapc_tot = data_tab_tot.fasat_prank ; fixed aperture percentage rank
    nnpc_tot = data_tab_tot.nnsat_prank ; nth Neighbour percentage rank
    mhpc_tot = data_tab_tot.mhsat_prank ; nth Neighbour percentage rank
    PRINT, ''
    PRINT, '*** satellite percentage ranks used ***'
    PRINT, ''
endif

CDFchoice = strmid(strupcase(CDFchoice),0,1)
if CDFchoice eq 'Y' then goto, paramskip

;;---------------------------------------------------------------------------------------------
;       2 - Iteratively bin sample for stacking. In general, bin limits are passed from the configuration file,
;          however, 2D box bin limits (e.g. across the MZR) are hard coded for the moment.
mstar_lims=double(paramf.mstar_lims)
nuvr_lims=double(paramf.nuvr_lims)
mustar_lims=double(paramf.mustar_lims)
mhalo_lims=double(paramf.mhalo_lims)
ssfr_lims=double(paramf.ssfr_lims)
logOH_lims=double(paramf.logOH_lims)
gr_lims=double(paramf.gr_lims)
OIII_lims=double(paramf.OIII_lims)

case whatp1 of
    1: p1lim = mstar_lims
    2: begin
        p1lim = nuvr_lims
        ;; change limits if binning by 3rd parameter
        if (whatp3 le 4) OR (whatp2 eq 4) then begin
            PRINT, ''
            PRINT, 'Changing NUV-r binning to increase statistics.'
            PRINT, ''
            PRINT, 'New bins [mag]: 1-3, 3-4, 4-5, 5-8'
            PRINT, ''
            PRINT, ''
            p1lim = [1, 3, 4, 5, 8]
        endif
    end
    3: p1lim = mustar_lims
    4: p1lim = mhalo_lims
    5: p1lim = ssfr_lims
    6: p1lim = logOH_lims
    7: p1lim = gr_lims
    8: p1lim = OIII_lims
    endcase
paramskip:

if CDFchoice eq 'N' then goto, CDFskip

; define the x/y limits for each different mass-metallicity sample
; At the moment these bin limits are hard coded. This is because reading two dimensional arrays into 
; IDL using the input file is not straightforward.
p1lim = [9.0, 9.3, 9.6, 10, 10.4, 11]
case CDFstack of
    1: begin
        whatp1 = 1
        whatp2 = 6
        case lgOHstack of
            2: begin ; limits for m-zgas [M08] relation
            p2lim =[[8.4092688749235958, 8.5737211782833356, 8.6818920322749165, 8.7848300813178195, 8.8929629390400038, 9.1099870530120288] ,$
            [8.4348296863000432, 8.6784551908913787, 8.7894873840321246, 8.8924749886968257, 8.9802511345022076, 9.1074988901350959] ,$
            [8.4826806241102872, 8.7691858311456201, 8.8899629056493588, 8.9883090934432381, 9.0553751559992328, 9.1449120750131527] ,$
            [8.7100812565417201, 8.9065428771823782, 8.9951609552070018, 9.0555079030851751, 9.1007224265392317, 9.1605775309504409] ,$
            [8.5625675346990953, 8.9739334167908673, 9.0449542234492846, 9.0886060353639309, 9.1260829646277024, 9.1571708880870162]]

            ; limits for SFR cov frac > 20
            ; p2lim = [[8.4170414372793605, 8.5633389801529987, 8.68661195622904, 8.8105353236128323, 8.9293152472865636, 9.1099870530120288] ,$
            ;         [8.4348296863000432, 8.6693149316141529, 8.786336451871481, 8.9043729732367183, 9.0047003676844959, 9.1074988901350959] ,$
            ;         [8.4826806241102872, 8.7527943629037459, 8.8907291210269221, 9.0014960219987366, 9.0641337608206634, 9.1449120750131527] ,$
            ;         [8.7186585109257244, 8.9070388500709416, 9.0006175585309371, 9.0599679605760137, 9.1038029899935182, 9.1605775309504409] ,$
            ;         [8.6591645102069386, 8.9820848049195732, 9.046125170665146, 9.093029413608436, 9.1266587522698064, 9.1553431112006578]]


            ; limits for fiber area cov frac > 20
            ; p2lim = [[8.4219507163816338, 8.5707111015694117, 8.6685797150220267,$
            ;         8.7803441920386085, 8.9076393985201996, 9.0549903010800534], $
            ;         [8.4348296863000432, 8.6687872320984276, 8.777990817904028, $
            ;         8.8877534750591529, 8.9786175491134745, 9.0846342917487668], $
            ;         [8.4826806241102872, 8.7347720975592154, 8.8561528810588186, $
            ;         8.9541493960884786, 9.0318412350177084, 9.129597443137067], $
            ;         [8.5230485528273938, 8.8361408270697055, 8.9541209476110843, $
            ;         9.0298567782057866, 9.0840807641831027, 9.1449120750131527], $
            ;         [8.5676357574925799, 8.9401824738092319, 9.0225856564501328, $
            ;         9.0738371263244773, 9.1057764501726588, 9.1460890271606523]]
            end
            3: begin ; m-zgas [T04] relation 
            p2lim = [[8.0867977, 8.3800726, 8.5796337, 8.7019224, 8.8500557, 9.146286] ,$
                    [8.1776953, 8.5833969, 8.7093592, 8.8409128, 8.9717121, 9.1298733] ,$
                    [8.217041, 8.7044582, 8.8495579, 8.9847088, 9.0703869, 9.2397232] ,$
                    [8.5414867, 8.8721428, 8.9900637, 9.0736771, 9.1344156, 9.2603416] ,$
                    [8.2816458, 8.9722633, 9.0838346, 9.1447086, 9.2247887, 9.2691278]]
            
            ; limits for SFR cov frac > 20
            ; p2lim = [[8.0867977, 8.4348116, 8.6188116, 8.7487249, 8.9253302, 9.146286] ,$
            ;         [8.1776953, 8.5926809, 8.7174253, 8.8690338, 8.9989262, 9.1298733] ,$
            ;         [8.217041, 8.6979628, 8.8563671, 8.994647, 9.0899525, 9.2397232] ,$
            ;         [8.5860949, 8.9007568, 8.9982414, 9.0878258, 9.1453476, 9.2603416] ,$
            ;         [8.5221071, 8.9835539, 9.0910482, 9.1465158, 9.2261906, 9.2691278]]


            ; limits for fiber area cov frac > 20
            ; p2lim = [[8.1451693, 8.4201632, 8.6016226, 8.7263584, 8.8728056, 9.0737762],$
            ;         [8.2056332, 8.6012831, 8.7121153, 8.8517761, 8.9759264, 9.1139183],$
            ;         [8.3948317, 8.679594, 8.8132277, 8.9463758, 9.0500526, 9.1758165],$
            ;         [8.2886534, 8.7960463, 8.9453945, 9.0449715, 9.109273, 9.2397232],$
            ;         [8.4183912, 8.918416, 9.0082893, 9.1100359, 9.1500053, 9.2393742]]
            end
            4: begin ; m-zgas [KD02] relation 
            p2lim = [[8.2165403, 8.5046501, 8.6398296, 8.7656202, 8.9055901, 9.1013098], $
                    [8.2537699, 8.6141195, 8.7331495, 8.85254, 8.9658604, 9.1883698], $
                    [8.2853899, 8.6922998, 8.8145704, 8.93011, 9.03125, 9.1692104], $
                    [8.4828796, 8.7858496, 8.9232903, 9.0223904, 9.1223001, 9.2600603], $
                    [8.4716702, 8.8895702, 9.02948, 9.1094103, 9.1788397, 9.2289896]]
            end
        endcase
    end
    2: begin
    whatp1 = 1
    whatp2 = 8
    p2lim = [[-2.3935895, -1.0198947, -0.63261318, -0.37617978, -0.13608791, 0.43563241],$
            [-2.3204467, -0.84299988, -0.50093168, -0.24279277, -0.00052105653, 0.95069063],$
            [-2.3260891, -0.7591666, -0.33963716, -0.064185165, 0.178406, 1.0450674],$
            [-1.9641527, -0.48807943, -0.096372128, 0.19783889, 0.47380397, 1.3737562],$
            [-1.8785964, -0.14886373, 0.22740397, 0.56452155, 0.86913043, 1.4163351]]    
    end
    3: begin
    whatp1 = 1
    whatp2 = 5
    p2lim = [[-11.478507, -10.210714, -9.8387842, -9.5769396, -9.3557148, -8.7876368],$
            [-11.84898,  -10.317434, -9.9709435, -9.7209301, -9.488842, -8.5930595],$
            [-12.023958, -10.556909, -10.117835, -9.8408823, -9.6037712, -8.7592964],$
            [-12.155935, -10.678195, -10.277184, -9.9942894, -9.7516584, -8.8394737],$
            [-12.900444, -10.838449, -10.446731, -10.139709, -9.8286524, -9.1551046]]
    end
endcase
CDFskip:


    
for j=0,N_ELEMENTS(p1lim)-2 do begin
    for k=0,N_ELEMENTS(p2lim[*,0])-2 do begin

    ; set counters to zero
    nn=0  ; object counter  
    nnNdt=0 ; non-detections
    nndtc=0 ; detections

    
    xbin_no = STRCOMPRESS((j + 1), /remove_all)
    ybin_no = STRCOMPRESS((k + 1), /remove_all)

    case whatp1 of
    1: param_1 = mass_tot
    2: param_1 = NUVR_tot
    3: param_1 = MUst_tot
    4: param_1 = halo_tot
    5: param_1 = ssfr_tot
    6: param_1 = lgOH_12_tot
    7: param_1 = gr_tot
    8: param_1 = OIII_tot
    endcase
    
    case whatp2 of
    1: param_2 = mass_tot
    2: param_2 = NUVR_tot
    3: param_2 = MUst_tot
    4: param_2 = halo_tot
    5: param_2 = ssfr_tot
    6: param_2 = lgOH_12_tot
    7: param_2 = gr_tot
    8: param_2 = OIII_tot
    9: param_2 = sfr_tot
    10: param_2 = fapc_tot
    11: param_2 = nnpc_tot
    12: param_2 = mhpc_tot
    13: param_2 = ngal_tot
    14: param_2 = z_tot
    15: param_2 = AGN_K01
    16: param_2 = AGN_K03
    17: param_2 = W1_W2
    99: param_2 = mass_tot
    endcase

    case whatp3 of
    1: param_3 = mass_tot
    2: param_3 = NUVR_tot
    3: param_3 = MUst_tot
    4: param_3 = halo_tot
    5: param_3 = ssfr_tot
    6: param_3 = lgOH_12_tot
    7: param_3 = gr_tot
    8: param_3 = OIII_tot
    9: param_3 = sfr_tot
    10: param_3 = fapc_tot
    11: param_3 = nnpc_tot
    12: param_3 = mhpc_tot
    13: param_3 = ngal_tot
    14: param_3 = z_tot
    15: param_3 = AGN_K01
    16: param_3 = AGN_K03
    17: param_3 = W1_W2
    99: param_3 = mass_tot
    endcase

    PRINT, ''
    ; apply limits and bin galaxies
    case BCG_stack of
    1: begin
        if CDFchoice eq 'N' then begin
            bin_cond = WHERE((param_1 ge p1lim[j]) and (param_1 lt p1lim[j+1]) $
                and (param_2 ge p2lim[k]) and (param_2 lt p2lim[k+1]) $ ; 
                and (param_3 ge p3lim[0]) and (param_3 lt p3lim[1]))
                ; and (detcode_tot eq 1)
        endif
        if CDFchoice eq 'Y' then begin
            bin_cond = WHERE((param_1 ge p1lim[j]) and (param_1 lt p1lim[j+1]) $
                and (param_2 ge p2lim[k,j]) and (param_2 lt p2lim[k+1,j]) $ ; 
                and (param_3 ge p3lim[0]) and (param_3 lt p3lim[1]))
        endif
        end
    2: begin ; isolated
        PRINT, 'stacking isolated central galaxies (Ngal=1 & bcgflag=1)'
        bin_cond = WHERE((param_1 ge p1lim[j]) and (param_1 lt p1lim[j+1]) $
            and (param_2 ge p2lim[0]) and (param_2 lt p2lim[1]) $ ; 
            and (param_3 ge p3lim[0]) and (param_3 lt p3lim[1]) $
            and (ngal_tot eq 1))
        end
    3: begin ; centrals
        PRINT, 'stacking group central galaxies (Ngal>1 & bcgflag=1)'
        bin_cond = WHERE((param_1 ge p1lim[j]) and (param_1 lt p1lim[j+1]) $
            and (param_2 ge p2lim[0]) and (param_2 lt p2lim[1]) $ ; 
            and (param_3 ge p3lim[0]) and (param_3 lt p3lim[1]) $
            and (BCGflag_tot eq 1) $
            and (ngal_tot ge 2))
        end
    4: begin ; all centrals
        PRINT, 'stacking all central galaxies (Ngal=1)'
        bin_cond = WHERE((param_1 ge p1lim[j]) and (param_1 lt p1lim[j+1]) $
            and (param_2 ge p2lim[0]) and (param_2 lt p2lim[1]) $ ; 
            and (param_3 ge p3lim[0]) and (param_3 lt p3lim[1]) $
            and (BCGflag_tot eq 1))
        end
    5: begin ; satellites
        PRINT, 'stacking satellite galaxies (Ngal>1 & bcgflag=2)'
        bin_cond = WHERE((param_1 ge p1lim[j]) and (param_1 lt p1lim[j+1]) $
            and (param_2 ge p2lim[0]) and (param_2 lt p2lim[1]) $ ; 
            and (param_3 ge p3lim[0]) and (param_3 lt p3lim[1]) $
            and (BCGflag_tot eq 2))
        end
    endcase
    PRINT, ''

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
    gr = gr_tot[bin_cond]
    OIII = OIII_tot[bin_cond]
    sfr = sfr_tot[bin_cond]
    ssfr = ssfr_tot[bin_cond]
    halo = halo_tot[bin_cond]
    aamass_hi = mass_hi_tot[bin_cond]
    bcgflag = BCGflag_tot[bin_cond]
    ngal = ngal_tot[bin_cond]
    fapc = fapc_tot[bin_cond]
    nnpc = nnpc_tot[bin_cond]
    lgOH_12 = lgOH_12_tot[bin_cond]
    sfr_tot_mpa = sfr_tot_mpa_tot[bin_cond]
    sfr_fib_mpa = sfr_fib_mpa_tot[bin_cond]
    sfr_tot_Ha = sfr_tot_Ha_tot[bin_cond]
    sfr_tot_SED = sfr_tot_SED_tot[bin_cond]

    ;Define required arrays to be n-data long
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

    print, 'There are' + STRCOMPRESS(ndata) + ' galaxies in bin ' + xbin_no + '-' + ybin_no
    print, ''

    ;; Open LOG file to save data
    wfile=output+'/'+output+'_bin_'+xbin_no + '-' + ybin_no+'_LOG.dat'     
    openw, lun, wfile, /get_lun
    printf, lun, 'Stacking '+strcompress(whatstack, /remove_all)+' (1: fluxes, 2: M_HI, 3: M_HI/M_*)'
    printf, lun, ' '
    printf, lun, '-------------------------------------------------'
    printf, lun, 'Galaxies skipped:'
    
    ;; condition to skip bin it contains too few galaxies
    if (ndata lt 5) then begin
        PRINT, ''
        PRINT, '-------------------------------------------------'
        PRINT, 'Less than 5 galaxies in bin '+xbin_no + '-' + ybin_no
        PRINT, 'SKIPPING!'
        PRINT, ''
        goto, nogalaxies
    endif

    ; take mean values galaxy properties
    ; where appropriate linear mean is taken
    mean_ms = MEAN(mass)
    mean_mh = MEAN(halo)
    mean_z = MEAN(z_arr)
    mean_mu = MEAN(mu_st)
    mean_c = MEAN(C)
    mean_nuvr = MEAN(NUVR)
    mean_gr = MEAN(gr)
    mean_sfr = ALOG10(MEAN(10^sfr))
    mean_ssfr = ALOG10(MEAN(10^ssfr))
    mean_aahi = MEAN(aamass_hi)
    mean_fapc = MEAN(fapc)
    mean_nnpc = MEAN(nnpc)
    mean_ngal = MEAN(ngal)
    mean_logOH = MEAN(lgOH_12)
    mean_sfr_tot_mpa = ALOG10(MEAN(10^sfr_tot_mpa))
    mean_sfr_fib_mpa = ALOG10(MEAN(10^sfr_fib_mpa))
    mean_sfr_fib_Ha = ALOG10(MEAN(10^sfr_tot_Ha))
    mean_sfr_SED = ALOG10(MEAN(10^sfr_tot_SED))

    ; take median where appropriate
    median_z = MEDIAN(z_arr)
    median_logOH = MEDIAN(lgOH_12)
    median_ngal = MEDIAN(ngal)

    ; and mode
    ; MODE, bcgflag, mode_bcgflag

    case whatp1 of
        1: mean_x = MEAN(mass)
        2: mean_x = MEAN(NUVR)
        3: mean_x = MEAN(mu_st)
        4: mean_x = MEAN(halo)
        5: mean_x = MEAN(ssfr)
        6: mean_x = MEAN(lgOH_12)
        7: mean_x = MEAN(gr)
        8: mean_x = MEAN(OIII)
    endcase
        
    ;;---------------------------------------------------------------------------------------------
    ; 3 - Restore .src structures

    ;;keep two pols separated
    for all=0L,(ndata-1) do begin
     
        i=floor(100*all/ndata)        
        progbar, i

        ;;check and restore the file if exists, if not warn and skip 
        check=findfile(path+'ID_' + STRCOMPRESS(ID[all], /remove_all)+'.src')

        if (check eq '') then begin
            print,'Source file for galaxy ID_'+ STRCOMPRESS(ID[all], /remove_all)+' not found - skipping'
            goto, exitif
        endif
        restore,path+'ID_' + STRCOMPRESS(ID[all], /remove_all)+'.src'

        ;; Check qulity of spectrum and exit if bad
        qlt_flag=src.hd.flag_qlt
        if (qlt_flag eq 0) then begin
            printf, lun, 'ID_' + STRCOMPRESS(ID[all], /remove_all)+': Quality flag =0'
            goto, exitif
        end 

        ;;Read from source file parameters needed
        zspecarr=Z_tot[WHERE(ID_tot eq ID[all], /NULL)]
        zspec = DOUBLE(zspecarr[0,0])
        if (zspec lt 0.01) or (zspec gt 0.05) then begin
            print, ''
            print, MAX(Z_tot)
            print, MIN(Z_tot)
            print, zspec
            print, zspecarr
        endif
        
        wopt=src.hd.input[3]/2.       ;half w_opt if available from TF, or 300/2. km/s
        mstar_arr=mass_tot[WHERE(ID_tot eq ID[all], /NULL)]
        mstar= DOUBLE(mstar_arr[0,0])
        rms_A=src.rms[0]
        rms_B=src.rms[1]

        ;; Assign pol A and B flux
        sourcefrq = src.frqarr ; Frequency
        specA_in = src.specpol.YARRA
        specB_in = src.specpol.YARRB
        weightA = src.weight.wspeca
        weightB = src.weight.wspecb

        ;;; Set spec to 0 where weight < 0
        w = WHERE((weightA lt 0.1) or (weightB lt 0.1))
        specA_in[w] =  0
        specB_in[w] =  0

        ;;---------------------------------------------------------------------------------------------
        ; 4 - Read spectrum. Weight spectrum by mass and/or redshift if required.  

        case whatstack of 
            1: begin
                specA=specA_in ;flux
                specB=specA_in
            end
            2: begin             ;M_HI
                specA=DOUBLE(specA_in*lumdist(zspec,/silent)^2/(1.+zspec))      
                specB=DOUBLE(specB_in*lumdist(zspec,/silent)^2/(1.+zspec))         
            end
            3: begin             ;M_HI/M_*
                specA=DOUBLE(specA_in*lumdist(zspec,/silent)^2/(1.+zspec)/10.d0^mstar)
                specB=DOUBLE(specB_in*lumdist(zspec,/silent)^2/(1.+zspec)/10.d0^mstar)
            end
        endcase


        ;;---------------------------------------------------------------------------------------------
        ; 5 - Shift each spectrum so that galaxy central freq is in board center [chn 511]

        frq_c=DOUBLE(restfrq/(zspec + 1.))
        d_ch=floor((src.frqarr[511]-frq_c)/(deltaf))
        freqshift,d_ch,specA,spec_outA
        freqshift,d_ch,specB,spec_outB

        ;;---------------------------------------------------------------------------------------------
        ; 6 - Stack spectra, weighting by their rms        
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

        ;;---------------------------------------------------------------------------------------------
        ; 6.5 - [Optional] If \specplot kwarg set, plot stacked spectrum to screen
        if KEYWORD_SET(specplot) then begin
            plot, frqarr, (spec_outA+spec_outB)/2,$
               YRANGE=[MIN((spec_outA+spec_outB)/2), 1.2*MAX((spec_outA+spec_outB)/2)],$
                   XRANGE=[MIN(frqarr), MAX(frqarr)], Title= 'spec ID:'+ID[all],$
                       XTITLE = STRCOMPRESS(ID[all])
        endif
        
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
        
        exitif:
    endfor   
    printf, lun, '-------------------------------------------------'
    printf, lun, ' '

    print,' '
    print,nn,ndata,format="('(good) data found for ',i4,'/',i4,' input objects')"
    printf, lun, nn,ndata,format="('(good) data found for ',i4,'/',i4,' input objects')"
    free_lun, lun

    ;;mean
    z_avg=mean(z_vec[0:nn-1])
    mst_avg=mean(10^mst_vec[0:nn-1])

    index=indx[0:nn-1]


    print,'rms = ', rmstotA, rmstotB

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


    print,'---------------------------------------------------'
    print,'avg rms over all pol A =',total(rms_A_vec[0:nn-1])/nn,'+-',stdev(rms_A_vec[0:nn-1]),' [mJy]'
    print,'avg rms over all pol B =',total(rms_B_vec[0:nn-1])/nn,'+-',stdev(rms_B_vec[0:nn-1]),' [mJy]'
    print,'---------------------------------------------------'
    
    rmsav=total(rms_A_vec[0:nn-1])/nn
    rmsbv=total(rms_B_vec[0:nn-1])/nn

    ;;---------------------------------------------------------------------------------------------
    ; 7 - Save output and metadata as IDL structure
    print,''
    print,''
    print,' ------- SUMMARY --------------------------------------------------------------'
    print,' ------------------------------------------------------------------------------'
    print,'--> outputs:'
    print,output+'/'+output+'_bin_'+xbin_no + '-' + ybin_no+'.sav'
    print,''
    print,' ------------------------------------------------------------------------------'
    print,''

    sname=output+'/'+output+'_bin_'+xbin_no + '-' + ybin_no+'.sav'

    hd={input:[z_avg,mst_avg,whatstack],file:output,index:index}
    red={edge:[0,0],edge_err:[0,0],bmask:intarr(nchn),bord:0,smooth:0} ;reduction parameter
    specA={flx:stack_specA_flx,mhi:stack_specA_mhi,gf:stack_specA_gf}  
    specB={flx:stack_specB_flx,mhi:stack_specB_mhi,gf:stack_specB_gf} 
    spec={flx:fltarr(nchn),mhi:fltarr(nchn),gf:fltarr(nchn)} 
    S={totS:0.,totSerr:0.,totSerr_sys:0.,totSerr_tot:0.}
    MHI={totMHI:0.,totMHIerr:0.,totMHIerr_sys:0.,totMHIerr_tot:0.}
    GF={totGF:0.,totGFerr:0.,totGFerr_sys:0.,totGFerr_tot:0.}
    sn={flx:fltarr(3),mhi:fltarr(3),gf:fltarr(3)}

    stack ={hd:hd, $       ;z mean,mst mean, 0,0,0
            ID:ID, $ ; list of id's used in stack.
            nused:[nn,nnNdt,nnDtc], $
            frqarr:frqarr, $
            specA:specA, $
            specB:specB, $
            spec:spec, $              ;;to be filled later
            red:red,$
            rms:[rmsav,rmsbv,0.,0.],$
            rms_mhi:[0.,0.],$ ;; to be filled later
            rms_gf:[0.,0.],$
            S:S,$
            MHI:MHI,$
            GF:GF,$
            sn:sn,$
            usrparam:[whatp1, whatp2, whatp3, BCG_stack, CDFstack],$
            p1lim:p1lim,$ ; bin limits
            p2lim:p2lim,$
            p3lim:p3lim,$
            mean_binp:[mean_ms, mean_mh, mean_z, mean_mu, mean_c, mean_nuvr,$
                        mean_sfr, mean_ssfr, mean_aahi, mean_fapc, mean_nnpc,$
                             mean_logOH, mean_ngal,mean_sfr_tot_mpa,$
                                mean_sfr_fib_Ha,mean_sfr_SED,mean_sfr_fib_mpa],$ 
            median_binp:[median_z, median_logOH, median_ngal],$ ; avg bin properties
            ;mode_bcgflag:mode_bcgflag, $
            mean_x:mean_x,$ ; avg x-axis value per bin
            detflag:[1]} ; flag if stack is detection (1) or non-detections (0), default detection, changed in HI_measure
    save,stack,file=sname

    print,' '
    close, lun
    nogalaxies:
    endfor
endfor

!P.MULTI=0
end;
