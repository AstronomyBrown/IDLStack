;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO DISTANCE_CATALOG,INPUT_FILE_TYPE,INPUT_FILE_NAME,OUTPUT_FILE_STRING
;+
;NAME:
;	DISTANCE_CATALOG
;PURPOSE:
;	To determine distances for objects in a formatted catalog. 
;	This program will read an AGC-formatted catalog or an ALFALFA
;	formatted catalog (the output from GALCAT) and calculate distances
;	using all available distance estimation techniques (pure Hubble flow,
;	the KLM flow model, and comparison to known groups and objects with known
;	primary distances. The best distance estimation method is selected based on
;	ALFALFA criteria. A mass for each object is also calculated.
;
;	This information is then output in a series of useful files, depending on whether
;	the input catalog was AGC or GALCAT formatted. In the case of an AGC formatted catalog,
;	the output will include the AGC number, the coordinates, the adopted heliocentric velocity
;	(since in the case of the AGC, there are often both optical and 21cm hel vels recorded),
;	the distance, the distance error, and a flag. The output files are different for
;	a GALCAT catalog, and include a TEX table for insertion in ALFALFA papers.
;
;	In the case of a GALCAT-formatted catalog, only objects of category 1 or 2
;	will have distances and masses calculated. Only these objects will appear
;	in the output files.
;
;	Note that these catalogs contain heliocentric velocity measurements. These
;	are converted to CMB rest-frame velocities within the code.
;
;CALLING SEQUENCE:
;	DISTANCE_CATALOG,INPUT_FILE_TYPE,INPUT_FILE_NAME,OUTPUT_FILE_STRING	
;
;EXAMPLE:
;	DISTANCE_CATALOG,0,'../catalogs/CR1catalog.dat','CR1'
;
;
;REQUIRES:
;	Must first compile the flow model software using "@egggeninit."
;	This code uses the code contained in "flowmodel_dist" in egggen, and explicitly
;	calls myflowmodelcall.
;
;INPUTS:
;	INPUT_FILE_TYPE - INTEGER - a code indicating whether the input catalog is in AGC format (0)
;				or in GALCAT catalog format (1). No other value is accepted.
;
;	*************NOTE: Input files may not have header lines. The first line must contain data
;				in the proper format!***************
;
;	INPUT_FILE_NAME - STRING - a string indicating the location of the input file. Must be in the
;				format specified by INPUT_FILE_TYPE
;	OUTPUT_FILE_STRING - STRING - a string indicating the naming convention to be used for output
;					files. i.e., in the case where OUTPUT_FILE_STRING='CR1', the
;					output files will be CR1.tex, CR1.table and CR1.info. Can also
;					use to indicate a subdirectory, i.e. OUTPUT_FILE_STRING='test1/CR1'.
;
;OUTPUTS:
;
;	SCREEN WARNINGS - In some cases, distances & masses will need to be investigated by hand. One particular
;				example is when the flow model returns a distance of 0 (which will lead to a
;				log(himass) of -Inf). In this case, a warning is printed to the screen:
;				"WARNING! Object number ## has 0 distance and infinite mass!"
;				In this case, the distance and the mass should be removed by hand from the
;				LATEX table and the .table file. However, it is also wise to try to figure out
;				why the distance was found to be zero and to consult the EGG group about a
;				better estimate.
;
;				It is also worth noticing that HVCs will have neither distances nor masses estimated.
;
;				Please keep in mind that the flow model code produces distances, errors, AND a warning flag
;				(see notes section) -- it's wise to look over these flags before accepting the distance & mass estimates!
;
;	The output files for a GALCAT-formatted catalog is as follows:
;	OUTPUT_FILE_STRING.tex - a file with the LATEX code necessary for an ALFALFA paper (as in papers III and V).
;					There are some special notes to keep in mind. In the case where no optical counterpart is
;					identified, blank spaces are printed in the table (rather than zeroes). Blank spaces are also
;					printed for the distance & mass estimates in the case of a high velocity cloud.
;					The columns are:
;					catalog number, AGC number, HI Right Ascension, HI Declination, Optical R.A., Optical Dec,
;					cz (km/s), W50, integrated flux (Jy km/s), integrated flux error, SNR, RMS, D (Mpc), log(M) (Msun)
;					and the detection code.
;
;					Please note that in PUBLISHED CATALOGS, each catalog number should be prefixed by the Catalog Release
;					code, i.e. Riccardo's paper was CR1, Amelie's was CR2, etc. To do this, you simply need to alter
;					the format statement in each section of the code where lines are written to texlun, from
;					"printf,texlun,catnr,agcnumber . . . format="(i5,'  & ',i6,' . . .. . . ." to "format="('2-',i5 . . . ."
;					Then the table will read 2-    1 through 2-xxxxx.
;
;	OUTPUT_FILE_STRING.table - a file in the same format as the above, without the TEX markup. 
;					Here are the column names & the format statement for reading the table file:
;					readf,newlun,catnr,agcnumber,rah,ram,ras,sign,decd,decm,decs,optrah,optram,optras,optsign,$
;					optdecd,optdecm,optdecs,cz,w50,werr,flux,fluxerr,snr,rms,distmpc,loghimass,code,$					
;					format='(i5,2x,i6,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,1x,i2,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,$
;					1x,i2,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)'
;				
;					Before reading, remember to pre-define strings: sign='' and optsign='', and to remove the header lines
;					from the file.
;
;	OUTPUT_FILE_STRING.info - a version for internal use only with full information included. Includes the 
;					calculated distance for each galaxy, and flags indicating how the distance
;					was estimated. Columns are as follows: AGC number, coordinates (hhmmss.s+ddmmss), heliocentric
;					velocity, distance (Mpc), distance error (Mpc), flowmodel flag, distance source flag. See the 
;					notes section for a full explanation of the flags. See also OUTPUT_FILE_STRING.agc for further
;					discussion.
;
;
;	The output file for an AGC-formatted catalog is as follows:
;	OUTPUT_FILE_STRING.agc - a file with the AGC number, coordinates, adopted heliocentric velocity,
;				calculated distance, the distance error, and 2 flags. The first flag indicates
;				the "flow model" flag (see notes); if this is any value other than -1, it means
;				a flow model was used to calculate the distance, and care should be taken. The second
;				flag indicates how the distance was estimated, as defined in the Notes section below.
;				Note that in some cases, a distance cannot be measured (because there is not adequate
;				velocity information for a given AGC source in the AGC). In such a case, the line is skipped,
;				and a warning is printed to the screen.	This could be changed (so that a line is printed for
;				every AGC entry) if it starts to become a problem!
;				The print statement is reproduced here, so that the file can be read easily:
;				printf,distlun,agcnumber,rah,ram,ras10,sign,decd,decm,decs,pickvel,distgal,edistgal,$
;				flowmodelflag,distflaggal,format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
;
;PROCEDURE:
;	The code is called with a flag to indicate whether the input file is in AGC or GALCAT format. The
;	program proceeds differently depending on the input file format, and in the end the outputs are also different.
;
;NOTES:
;	FLAGS ARE DEFINED AS FOLLOWS
;	FLOW MODEL FLAG: Flowmodel uses codes 0,1,2,3,10,11,12,13,20,21,22,23 and 30. If the flowmodel flag is -1, that means
;	the flowmodel was not at all employed in the distance determination for that object. Flow model flags are defined
;	in greater detail below.
;
;	DISTANCE SOURCE FLAG
;	-1 - no distance (High Velocity Cloud)	
;	99 - distance estimated using pure Hubble flow, using the object's CMB rest frame velocity and a
;		Hubble parameter H_0 = 70.0 km/s/Mpc. This applies to objects (or groups) with CMB frame
;		velocities greater than 6000 km/s. At the moment, the error on such a distance is given as 0.
;	98 - distance is from a primary distance measurement.
;	97 - object belongs to a group with a CMB rest frame velocity greater than 6000 km/s, so the distance
;		to the object was estimated using pure Hubble flow from the object's CMB frame velocity.
;	96 - object belongs to a group with a CMB rest frame velocity less than 6000 km/s, so the distance to
;		the object was estimated using the flow model and using the group's velocity.
;	95 - object belongs to a group, and one member has a primary distance, so all objects in the group
;		are assigned to that distance. ***THIS IS NOT EMPLOYED AT THE MOMENT BUT WILL BE IN THE FUTURE.***
;	94 - the object does not have a primary distance measurement, and does not belong to a group, so a flow
;		model distance is given.
;
;	When a flowmodel is used, the flag is also given (for diagnosing troublesome spots). If the flowmodel flag
;	entry is -1, this means that the flow model was not used in determining the distance.
;	
;	********************************************
;	Flowmodel flags indicate possible problems with the distance (and error) obtained using the flow model. IF
;	the flowmodel flag is anything other than a 1, 10, or 20, it is probably worth investigating and thinking about.
;                       0: No distance found. Usually close to D=0Mpc
;                       1: Everything is fine, single valued distance
;                      2: Double valued distance
;                      3: Triple valued distance
;                      10: Assigned to Virgo Core
;                      11: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued 
;                      12: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued 
;                      13: Near Virgo (within 6Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued 
;                      20: Assigned to GA Core
;                      21: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), single valued
;                      22: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), double valued
;                      23: Near GA (within 10Mpc which is region where SB00 
;                          claim that model is "uncertain"), triple valued
;                      30: Assigned to Core of Fornax cluster
;
; 
;REVISION HISTORY:
;       Adapted from existing code   A.Martin   August 2007
;       One line correction to catalog output when primary distances are used S.Stierwalt December 2007
;
;-


;useful parameters
onedeg=!dpi/180
H_0=70.0   ;this is the ALFALFA default

;FILE FORMATS: 0 is AGC, 1 is GALCAT

if((INPUT_FILE_TYPE NE 0) AND (INPUT_FILE_TYPE NE 1)) then begin
	print, 'Warning: INVALID INPUT_FILE_TYPE'
	print,'SYNTAX: DISTANCE_CATALOG,INPUT_FILE_TYPE,INPUT_FILE_NAME,OUTPUT_FILE_STRING'
	print,'Valid INPUT_FILE_TYPE is (1) for GALCAT catalog format or (0) for AGC format.'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endif else if (INPUT_FILE_TYPE EQ 0) then begin
	print,'Input file format is AGC.'

	;load the arrays for checking against distance calibrators and group assignments
	;pro knowndistances,calibagcnumber,calibdist,calibedist,grpagcnumber,grpcmbvel

	knowndistances,calibagcnumber,calibdist,calibedist,grpagcnumber,grpcmbvel

	;Set up for AGC
	extstr='.agc'
	output_file_name=OUTPUT_FILE_STRING+extstr

	;Output filename is now OUTPUT_FILE_STRING.agc
	openr, agclun, input_file_name, /get_lun
	openw, distlun, output_file_name, /get_lun
	;make a header for distlun	
	printf,distlun,'#AGCNUM     Coords   HelVel     Dist    EDist F1 F2'


	;Read in the AGC catalog

	;Prepare to read AGC


	DESCRIPTION = ''
	NGCIC = ''
	WHICH = ''
	TELCODE = ''
	WIDTHCODE = ''
	SIGN = ''
	AGCNUMBER = 0L
	outputstr = ''

	;READ AGC


	while(EOF(agclun) ne 1) do begin
	    readf, agclun, AGCNUMBER,WHICH, $
                  RAH,RAM,RAS10,SIGN,DECD,DECM,DECS, $
                  A100,B100,MAG10,INCCODE,POSANG,DESCRIPTION,BSTEINTYPE, $
                  VOPT,VERR,EXTRC3,EXTDIRBE,VSOURCE,NGCIC,$
                  FLUX100,RMS100,V21,WIDTH,WIDTHERR,WIDTHCODE,TELCODE,$
                  DETCODE,HISOURCE,STATUSCODE,SNRATIO,$
                  IBANDQUAL,IBANDSRC,IRASFLAG,ICLUSTER,HIDATA,$
                  IPOSITION,IPALOMAR,RC3FLAG,IROTCAT,NEWSTUFF,$
                  format = '(A6,A1,2I2.2,I3.3,A1,3I2.2,I5,2I4,I2,I3,A8,I3,I6,I3,2I5,I3,A8,I5,I4,I5,I4,I2,A4,A1,i1,I2,I1,I3,I1,I2,I1,I2,5I1,I2)'

	;        outputstr = string(AGCNUMBER,WHICH, $
	;                  RAH,RAM,RAS10,SIGN,DECD,DECM,DECS, $
	;                  A100,B100,MAG10,INCCODE,POSANG,DESCRIPTION,BSTEINTYPE, $
	;                  VOPT,VERR,EXTRC3,EXTDIRBE,VSOURCE,NGCIC,$
	;                  FLUX100,RMS100,V21,WIDTH,WIDTHERR,WIDTHCODE,TELCODE,$
	;                  DETCODE,HISOURCE,STATUSCODE,SNRATIO,$
	;                  IBANDQUAL,IBANDSRC,IRASFLAG,ICLUSTER,HIDATA,$
	;                  IPOSITION,IPALOMAR,RC3FLAG,IROTCAT,NEWSTUFF,$
	;                  format = '(A6,A1,2I2.2,I3.3,A1,3I2.2,I5,2I4,I2,I3,A8,I3,I6, $
	;			I3,2I5,I3,A8,I5,I4,I5,I4,I2,A4,A1,i1,I2,I1,I3,I1,I2,I1,I2,5I1,I2)')
	;	print,outputstr

	    rahours = float(rah) + float(ram)/60 + float(ras10)/36000
	    ra=rahours*15
	    dec= float(decd)+ float(decm)/60 + float(decs)/3600
	
	    if(sign eq '-') then dec = -dec

	    ;Convert to radians for flowmodel_dist.pro

	    rar=ra*onedeg
	    decr=dec*onedeg
	
	    ;Select velocity or deal with velocity problems
	    pickvel = 0
   
	    if((V21 EQ 0) AND (VOPT EQ 0)) then begin
		print,'No velocity information in catalog for AGC=',AGCNUMBER,'. Continuing to next line.'
		continue
	    endif else if ((V21 EQ 0) AND (VOPT NE 0)) then begin
		pickvel=vopt
	    endif else if ((DETCODE EQ 0) AND (VOPT NE 0)) then begin
		pickvel=vopt
	    endif else if ((DETCODE EQ 2) AND (VOPT NE 0)) then begin
		pickvel=vopt
	    endif else if ((DETCODE EQ 4) AND (VOPT NE 0)) then begin
		pickvel=vopt
	    endif else if ((DETCODE EQ 5) AND (VOPT NE 0)) then begin
		pickvel=vopt
	    endif else if ((DETCODE EQ 9) AND (VOPT EQ 0)) then begin
		pickvel=v21
	    endif else if ((DETCODE EQ 9) AND (VOPT NE 0)) then begin
		pickvel=vopt
	    endif else if ((V21 NE 0) AND (DETCODE EQ 1)) then begin
		pickvel=v21
	    endif else if ((V21 NE 0) AND (DETCODE EQ 3)) then begin
		pickvel=v21
	    endif else if ((V21 NE 0) AND (DETCODE EQ 8)) then begin
		pickvel=v21
	    endif else if ((V21 NE 0) AND (DETCODE EQ 6)) then begin
		pickvel=v21
	    endif else if ((V21 NE 0) AND (DETCODE EQ 7)) then begin
		pickvel=v21
	    endif else if ((V21 NE 0) AND (DETCODE EQ 9) AND (VOPT EQ 0)) then begin
		pickvel=v21
	    endif else begin
		print,'Problem with velocity information for AGC=',AGCNUMBER,'. Continuing to next line.'
		continue
	    endelse

	;calculate distances
	;first, convert heliocentric velocity to cmbvelocity
		;need to calculate galactic latitute and galactic longitude first
		;can use GLACTC to do this
	glactc,ra,dec,2000,l,b,1,/DEGREE
	velgal_cmb=vhel_to_cmb(l,b) + pickvel
	;next, check for primary distances

	distcalib=0
	edistcalib=0
	distflagcalib=0
	distflaggroup=0
	flowmodelflag=(-1)

		;call to distcalibs_check: pro distcalibs_check,agcnumber,calibagcnumber,calibdist,calibedist,distcalib,edistcalib,distflagcali
	distcalibs_check,agcnumber,calibagcnumber,calibdist,calibedist,distcalib,edistcalib,distflagcalib

	;if there is a primary distance, then you can just print that and skip to the next one
	if (distcalib NE 0) then begin

		printf,distlun,agcnumber,rah,ram,ras10,sign,decd,decm,decs,pickvel,distcalib,edistcalib,$
		flowmodelflag,distflagcalib,format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
	;format='(A6,1X,2I2.2,I3.3,A1,3I2.2,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
	;        outputstr = string(AGCNUMBER,WHICH, $
	;                  RAH,RAM,RAS10,SIGN,DECD,DECM,DECS, $
	;                  A100,B100,MAG10,INCCODE,POSANG,DESCRIPTION,BSTEINTYPE, $
	;                  VOPT,VERR,EXTRC3,EXTDIRBE,VSOURCE,NGCIC,$
	;                  FLUX100,RMS100,V21,WIDTH,WIDTHERR,WIDTHCODE,TELCODE,$
	;                  DETCODE,HISOURCE,STATUSCODE,SNRATIO,$
	;                  IBANDQUAL,IBANDSRC,IRASFLAG,ICLUSTER,HIDATA,$
	;                  IPOSITION,IPALOMAR,RC3FLAG,IROTCAT,NEWSTUFF,$
	;                  format = '(A6,A1,2I2.2,I3.3,A1,3I2.2,I5,2I4,I2,I3,A8,I3,I6, $
	;			I3,2I5,I3,A8,I5,I4,I5,I4,I2,A4,A1,i1,I2,I1,I3,I1,I2,I1,I2,5I1,I2)')
	;	print,outputstr

		continue
	endif


	;next, check for group assignment
	velgrp_cmb=0
		;call to grpassign_check: pro grpassign_check,agcnumber,grpagcnumber,grpcmbvel,velgrp_cmb,distflaggroup
	grpassign_check,agcnumber,grpagcnumber,grpcmbvel,velgrp_cmb,distflaggroup
		;distflaggroup will (temporarily) be 97 if a group velocity is indeed found.

	if (distflaggroup EQ 97) then begin
		;calculate distance based on the group velocity

		;first check: group velocity greater than 6000 km/s?
		if (velgrp_cmb GE 6000.0) then begin
			distgroupkms = velgrp_cmb
			distgroup = distgroupkms/H_0
			edistgroup = 0
			distflaggroup=97
			printf,distlun,agcnumber,rah,ram,ras10,sign,decd,decm,decs,pickvel,distgroup,edistgroup,$
			flowmodelflag,distflaggroup,format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
		endif else if (velgrp_cmb LT 6000.0) then begin
		;if group velocity is not greater than 6000 km/s, we have to use the flowmodel and set the flag to 96.
		;keep in mind that we already have the velocity in the CMB frame
			distflaggroup=96
			myflowmodelcall,rar,decr,0,velgrp_cmb,1,distgroupkms,edistgroupkms,flowmodelflag
			distgroup=distgroupkms/H_0
			edistgroup=edistgroupkms/H_0
			printf,distlun,agcnumber,rah,ram,ras10,sign,decd,decm,decs,pickvel,distgroup,edistgroup,$
			flowmodelflag,distflaggroup,format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
		endif

		

	endif else if (distflaggroup EQ 0) then begin
		;calculate the distance based on the velocity alone
		;first check: object velocity greater than 6000 km/s?

		if (velgal_cmb GE 6000.0) then begin
			distgalkms=velgal_cmb
			distgal=distgalkms/H_0
			edistgal = 0
			distflaggal=99
			printf,distlun,agcnumber,rah,ram,ras10,sign,decd,decm,decs,pickvel,distgal,edistgal,$
			flowmodelflag,distflaggal,format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
		;if object velocity is not greater than 6000 km/s, we have to use the flowmodel and set both of the flags
		;to the flow model code.
		endif else if (velgal_cmb LT 6000.0) then begin
			myflowmodelcall,rar,decr,0,velgal_cmb,1,distgalkms,edistgalkms,flowmodelflag
			distflaggal=94
			distgal=distgalkms/H_0
			edistgal=edistgalkms/H_0
			printf,distlun,agcnumber,rah,ram,ras10,sign,decd,decm,decs,pickvel,distgal,edistgal,$
			flowmodelflag,distflaggal,format='(I6,1X,2I02,I03,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
		endif
		

	endif

	endwhile 

	close, agclun
	close,distlun
	free_lun, agclun
	free_lun,distlun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endif else if (INPUT_FILE_TYPE EQ 1) then begin
	print,'Input file format is GALCAT catalog.'

	;load the arrays for checking against distance calibrators and group assignments
	;pro knowndistances,calibagcnumber,calibdist,calibedist,grpagcnumber,grpcmbvel

	knowndistances,calibagcnumber,calibdist,calibedist,grpagcnumber,grpcmbvel

	;set up for output files: .tex,.table, and .info
	texstr='.tex'
	output_tex=OUTPUT_FILE_STRING+texstr
	tablestr='.table'
	output_table=OUTPUT_FILE_STRING+tablestr
	infostr='.info'
	output_info=OUTPUT_FILE_STRING+infostr

	;now open up the input file
	openr,catlun,input_file_name,/get_lun
	;and then open up the output files
	openw,texlun,output_tex,/get_lun
	openw,tablelun,output_table,/get_lun
	openw,infolun,output_info,/get_lun

	;print a header for each of the files

	header1='#Nr      AGC               HI Coords (J2000)               Opt Coords (J2000)         cz     W50  Werr  Sint   Serr     S/N     RMS      D     log(M) Code'
	header2='#                      RA                 Dec             RA               Dec        km/s                 Jykm/s                       Mpc     Msun'
	printf,tablelun,header1
	printf,tablelun,header2

	printf,infolun,'#AGCNUM     Coords    HelVel     Dist    EDist F1 F2'

	;pre-define the necessary strings
	HINAME = ''
	AGCNUMBER = 0L
	AGCNAME = ''
	GRIDID = ''
	SIGN = ''
	OPTSIGN = ''
	catnr=1
	while(EOF(catlun) ne 1) do begin
	
		readf,catlun,HINAME,AGCNUMBER,AGCNAME,RAH,RAM,RAS,SIGN,DECD,DECM,DECS,dRA,dDEC,$
			OPTRAH,OPTRAM,OPTRAS,OPTSIGN,OPTDECD,OPTDECM,OPTDECS,HSIZE,CZ,CZERR,W50,WERR,FLUX,FLUXERR,SINTMAP,SNR,$
			RMS,CODE,GRIDID,$
		format='(A17,1X,A6,1X,A8,2X,2I2,F4.1,A1,3I2,1X,I3,1X,I3,2X,2I2,F4.1,A1,3I2,1X,F6.1,1X,I5,2X,I3,2X,I4,2X,I3,2X,F6.2,1X,F5.2,2X,F6.2,2X,F5.1,1X,F5.2,3X,I1,5X,A7)'

		;make strings
		raH=string(rah,format='(i02)')+' '+string(ram,format='(i02)')+' '+string(ras,format='(f04.1)')
		decH=sign+string(decd,format='(i02)')+' '+string(decm,format='(i02)')+' '+string(decs,format='(i02)')

		rao=string(optrah,format='(i02)')+' '+string(optram,format='(i02)')+' '+string(optras,format='(f04.1)')
		deco=sign+string(optdecd,format='(i02)')+' '+string(optdecm,format='(i02)')+' '+string(optdecs,format='(i02)')

		;if the rao & deco strings are "00 00 00" and "+00 00 00", then that shouldn't be printed to the files
		if((rao EQ '00 00 00.0') AND (deco EQ '+00 00 00')) then begin
			rao='        '
			deco='         '
		endif

		;skip anything that's not a 1 or a 2
		if ((code NE 1) AND (code NE 2)) then begin
			;need to include 9's, which will have -1 for both flags
			;need to print the same information to all three files, just with NO distance and NO himass (meaning they should be empty strings, in this case)
			if(code EQ 9) then begin
				;print to the tex table
				distmpc='      '
				loghimass='      '
				printf,texlun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distmpc,loghimass,code,$
   				format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',A6,' & ',A6,' & ',i1,2x,' \\')"
				;print to tablelun
				printf,tablelun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distmpc,loghimass,code,$
   				format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,A6,2x,A6,2x,i1)"

				;print to infolun the other information
				dist=0
				edist=0
				flowmodelflag=(-1)
				distflag=(-1)
				printf,infolun,agcnumber,rah,ram,ras,sign,decd,decm,decs,cz,dist,edist,flowmodelflag,$
				distflag,format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
				catnr=catnr+1
			endif
			continue
		endif

		onedeg=!dpi/180.0
		rahours = float(rah) + float(ram)/60 + float(ras)/3600
		ra=rahours*15.0
		dec= float(decd)+ float(decm)/60 + float(decs)/3600
		if(sign eq '-') then dec = -dec

		;convert to radians for flowmodel_dist.pro
		rar=ra*onedeg
		decr=dec*onedeg


		;calculate distances
		;first, convert heliocentric velocity to CMB rest frame velocity
			;need to calculate galactic lat & long to do this
			;can use GLACTC
		glactc,ra,dec,2000,l,b,1,/DEGREE
		velgal_cmb=vhel_to_cmb(l,b)+cz

		;next, check for primary distances
		distcalib=0
		edistcalib=0
		distflagcalib=0
		distflaggroup=0
		flowmodelflag=(-1)

			;call to distcalibs_check:
		distcalibs_check,agcnumber,calibagcnumber,calibdist,calibedist,distcalib,edistcalib,distflagcalib

			;if there is a primary distance, then you can just use that and skip to the next one
		if(distcalib NE 0) then begin
			;calculate mass
			distmpc=distcalib
			himass=235600.0*distmpc*distmpc*flux  
			loghimass=alog10(himass)
			
			;print to the output files

			;printing the tex table
			;to make this match what is seen in the catalog papers, you need to insert into the print statement
				;a number indicating the catalog number, as in CR1, CR2, etc. The beginning of the format
				;statement should then read format="('2-',i3,...."

			printf,texlun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distmpc,loghimass,code,$
   				format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',f6.1,' & ',f6.2,' & ',i1,2x,' \\')"
			
			;print to tablelun the same information as above, without the crazy formatting
			printf,tablelun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distmpc,loghimass,code,$
   				format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)"
			;format statement for reading table file should be
			;readf,newlun,catnr,agcnumber,rah,ram,ras,sign,decd,decm,decs,optrah,optram,optras,optsign,optdecd,optdecm,optdecs,cz,w50,werr,flux,fluxerr,snr,rms,distmpc,loghimass,code,
			;					
			;format='(i5,2x,i6,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,1x,i2,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,
			;1x,i2,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)'
			;remember to pre-define strings: sign='' and optsign=''



			printf,infolun,agcnumber,rah,ram,ras,sign,decd,decm,decs,cz,distcalib,edistcalib,flowmodelflag,$
				distflagcalib,format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'	
;added SS 07Dec17:
		        catnr=catnr+1
			continue
		endif

		;then check for group distances
		velgrp_cmb=0
			;call to grpassign_check
		grpassign_check,agcnumber,grpagcnumber,grpcmbvel,velgrp_cmb,distflaggroup
			;distflaggroup will temporarily be 97 if a group velocity is indeed found

		if(distflaggroup EQ 97) then begin
			;calculate distance based on the group velocity
			;first check: group velocity greater than 6000 km/s?
			if(velgrp_cmb GE 6000.0) then begin
				distgroupkms=velgrp_cmb
				distgroup=distgroupkms/H_0
				himass=235600.0*distgroup*distgroup*flux
				loghimass=alog10(himass)
				edistgroup=0
				distflaggroup=97

				;print to the files
				;print to the textable
				printf,texlun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgroup,loghimass,code,$
				format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',f6.1,' & ',f6.2,' & ',i1,2x,' \\')"

				;print to tablelun the same information as above, without the formatting
				printf,tablelun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgroup,loghimass,code,$
   				format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)"

				;print to infolun the other information
				printf,infolun,agcnumber,rah,ram,ras,sign,decd,decm,decs,cz,distgroup,edistgroup,flowmodelflag,$
				distflaggroup,format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
			endif else if(velgrp_cmb LT 6000.0) then begin
				;if group velocity is not greater than 6000 km/s, we have to use the flowmodel and set the flag to 96
				distflaggroup=96
				myflowmodelcall,rar,decr,0,velgrp_cmb,1,distgroupkms,edistgroupkms,flowmodelflag
				if(distgroupkms EQ 0) then begin
					print,'WARNING! WARNING! Object number ',catnr,' has 0 distance and infinite mass!*********************** WARNING!'
				endif
				distgroup=distgroupkms/H_0
				edistgroup=edistgroupkms/H_0
				himass=235600.0*distgroup*distgroup*flux
				loghimass=alog10(himass)

				if(loghimass LE 0) then begin
					print,'WARNING! WARNING! Object number ',strcompress(catnr,/remove_all),' has a problem with its mass! ********* WARNING!'
				endif

				;print to the files
				;print to the tex table

				printf,texlun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgroup,loghimass,code,$
				format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',f6.1,' & ',f6.2,' & ',i1,2x,' \\')"

				;print to tablelun the same information as above, without the formatting
				printf,tablelun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgroup,loghimass,code,$
   				format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)"

				;print to infolun the other information
				printf,infolun,agcnumber,rah,ram,ras,sign,decd,decm,decs,cz,distgroup,edistgroup,flowmodelflag,$
				distflaggroup,format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'
			endif
		

		;finally, if none of the above is true, you just have to calculate distance based on the velocity alone

		
		endif else if (distflaggroup EQ 0) then begin

			if(velgal_cmb GE 6000.0) then begin
				distgalkms=velgal_cmb
				distgal=distgalkms/H_0
				himass=235600.0*distgal*distgal*flux
				loghimass=alog10(himass)
				edistgal=0
				distflaggal=99

				;print to the files
				;print to the tex table
				printf,texlun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgal,loghimass,code,$
				format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',f6.1,' & ',f6.2,' & ',i1,2x,' \\')"

				;print to tablelun the same information as above, without the formatting
				printf,tablelun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgal,loghimass,code,$
   				format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)"

				;print to infolun the other information
				printf,infolun,agcnumber,rah,ram,ras,sign,decd,decm,decs,cz,distgal,edistgal,flowmodelflag,$
				distflaggal,format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'

			endif else if(velgal_cmb LT 6000.0) then begin
				;if the object velocity is not greater than 6000 km/s, we have to use the flow model and set the flags
				myflowmodelcall,rar,decr,0,velgal_cmb,1,distgalkms,edistgalkms,flowmodelflag
				if(distgalkms EQ 0) then begin
					print,'WARNING! WARNING! Object number ',strcompress(catnr,/remove_all),' has 0 distance and infinite mass!*********************** WARNING!'
				endif
				distflaggal=94
				distgal=distgalkms/H_0
				himass=235600.0*distgal*distgal*flux
				loghimass=alog10(himass)
				if(loghimass LE 0) then begin
					print,'WARNING! WARNING! Object number ',strcompress(catnr,/remove_all),' has a problem with its mass! ********* WARNING!'
				endif
				edistgal=edistgalkms/H_0

				;print to the files
				;print to the tex table
				printf,texlun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgal,loghimass,code,$
				format="(i5,'  & ',i6,' & ',a15,' & ',a15,' & ',a15,' & ',a15,' & ',i6,' & ',i5,'(',i3,') & ',f6.2,'(',f4.2,') &',f7.1,' & ',f6.2,' & ',f6.1,' & ',f6.2,' & ',i1,2x,' \\')"

				;print to tablelun the same information as above, without the formatting
				printf,tablelun,catnr,agcnumber,raH,decH,rao,deco,cz,w50,werr,flux,fluxerr,snr,rms,distgal,loghimass,code,$
   				format="(i5,2x,i6,2x,a15,2x,a15,2x,a15,2x,a15,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)"

				;print to infolun the other information
				printf,infolun,agcnumber,rah,ram,ras,sign,decd,decm,decs,cz,distgal,edistgal,flowmodelflag,$
				distflaggal,format='(I6,1X,2I02,F04.1,A1,3I02,1X,I5,1X,F8.2,1X,F8.2,1X,I2,1X,I2)'

			endif

		endif




		catnr=catnr+1
	endwhile

	close,catlun
	free_lun,catlun

	close,texlun
	free_lun,texlun

	close,tablelun
	free_lun,tablelun

	close,infolun
	free_lun,infolun
endif



END
