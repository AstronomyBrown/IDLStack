pro knowndistances,calibagcnumber,calibdist,calibedist,hardagcnumber,harddist,hardedist,grpagcnumber,grpcmbvel

	;This code gathers all the known distance information, opening up dist_calibs.dat and grp_assign.gals,
	;reading required information into arrays, and returning the necessary information to the main program
	;so that the arrays can be used to assign group & primary distances.
	;dist_calibs.dat and grp_assign.gals must be in the same directory as the code

    common agcshare, agcdir
	openr,caliblun, agcdir+'dist_calibs.dat',/get_lun
	
        MAX_ENTRIES = 100000
        entryno = 0

	calibagcnumber=dblarr(MAX_ENTRIES)
	calname=strarr(MAX_ENTRIES)
	junk2=strarr(MAX_ENTRIES)
	calvhel=dblarr(MAX_ENTRIES)
	calibdist=dblarr(MAX_ENTRIES)
	calibedist=dblarr(MAX_ENTRIES)
	junk3=strarr(MAX_ENTRIES)

	while(EOF(caliblun) ne 1) do begin
		lncalname=''
		lnjunk2=''
		lnjunk3=''
		readf,caliblun,lnCALAGCNUMBER,lnCALNAME,lnJUNK2,lnCALVHEL,lnCALIBDIST,lnCALIBEDIST,lnJUNK3,$
		format='(i6,1x,a8,1x,a15,i5,f8.3,f7.3,a50)'
	
		calibagcnumber[entryno] = lncalagcnumber
		calname[entryno]        = lncalname
		junk2[entryno]          = lnjunk2
		calvhel[entryno]        = lncalvhel
		calibdist[entryno]      = lncalibdist
		calibedist[entryno]     = lncalibedist
		junk3[entryno]          = lnjunk3
                entryno = entryno + 1
	endwhile
	
	calibagcnumber=calibagcnumber[0:entryno-1]
	calname=calname[0:entryno-1]
	junk2=junk2[0:entryno-1]
	calvhel=calvhel[0:entryno-1]
	calibdist=calibdist[0:entryno-1]
	calibedist=calibedist[0:entryno-1]
	junk3=junk3[0:entryno-1]

	close,caliblun
	free_lun,caliblun





	openr,hardlun, agcdir+'dist_hardwired.dat',/get_lun
	
	entryno = 0

	hardagcnumber=dblarr(MAX_ENTRIES)
	harddist=dblarr(MAX_ENTRIES)
	hardedist=dblarr(MAX_ENTRIES)

	while(EOF(hardlun) ne 1) do begin
		lnagc   = 0.0
		lndist  = 0.0
		lnedist = 0.0
		line = ''
		readf,hardlun,line
		reads,line,lnagc,lndist,lnedist,format='(i6,31x,f5.1,1x,f4.1,39x)'

		hardagcnumber[entryno] = lnagc
		harddist[entryno]      = lndist
		hardedist[entryno]     = lnedist

        entryno = entryno + 1
	endwhile

	hardagcnumber = hardagcnumber[0:entryno-1]
	harddist      =	harddist[0:entryno-1]
	hardedist     = hardedist[0:entryno-1]

	close,hardlun
	free_lun,hardlun






	openr,grplun,agcdir+'/grp_assign.gals',/get_lun

	entryno = 0

	grpagcnumber = dblarr(MAX_ENTRIES)
	grpnumber    = dblarr(MAX_ENTRIES)
	cenra        = dblarr(MAX_ENTRIES)
	cendec       = dblarr(MAX_ENTRIES)
	galra        = dblarr(MAX_ENTRIES)
	galdec       = dblarr(MAX_ENTRIES)
	sepmin       = dblarr(MAX_ENTRIES)
	grpcmbvel    = dblarr(MAX_ENTRIES)
	junk1        = strarr(MAX_ENTRIES)

	while(EOF(grplun) ne 1) do begin
		lnjunk1=''
		readf,grplun,lnGRPAGCNUMBER,lnGRPNUMBER,lnCENRA,lnCENDEC,lnGALRA,lnGALDEC,lnSEPMIN,IVGRP_CMB,lnJUNK1,$
		format='(2i6,4f10.5,f6.1,i6,a25)'

		grpagcnumber[entryno] = lngrpagcnumber
		grpnumber[entryno]    = lngrpnumber
		cenra[entryno]        = lncenra
		cendec[entryno]       = lncendec
		galra[entryno]        = lngalra
		galdec[entryno]       = lngaldec
		sepmin[entryno]       = lnsepmin
		grpcmbvel[entryno]    = ivgrp_cmb
		junk1[entryno]        = lnjunk1

		entryno = entryno + 1
	endwhile

	grpagcnumber=grpagcnumber[0:entryno-1]
	grpnumber=grpnumber[0:entryno-1]
	cenra=cenra[0:entryno-1]
	cendec=cendec[0:entryno-1]
	galra=galra[0:entryno-1]
	galdec=galdec[0:entryno-1]
	sepmin=sepmin[0:entryno-1]
	grpcmbvel=grpcmbvel[0:entryno-1]
	junk1=junk1[0:entryno-1]

	close,grplun
	free_lun,grplun




end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro distcalibs_check,agcnumber,calibagcnumber,calibdist,calibedist,distcalib,edistcalib,distflagcalib


	;see if the agcnumber matches any of the numbers in the array "calibagcnumber"
	index=where((AGCNUMBER eq CALIBAGCNUMBER),count)

	if(COUNT NE 0) then begin
			distcalib=calibdist[index]   ;distance in Mpc
			edistcalib=calibedist[index] ;distance error in Mpc
			distflagcalib=98
	endif




end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro grpassign_check,agcnumber,grpagcnumber,grpcmbvel,velgrp_cmb,distflaggroup

	;see if the agcnumber matches any numbers in the array "grpagcnumber"
	index=where((AGCNUMBER EQ GRPAGCNUMBER),count)

	if(COUNT NE 0) then begin
		velgrp_cmb=grpcmbvel[index]
		distflaggroup=97
	endif

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO GROUP_PRIMARIES

;;;;;;;;;;;;;;;;;
;NOTE: THIS CODE IS STILL UNDER CONSTRUCTION
;;;;;;;;;;;;;;;;


;+
;NAME:
;	GROUP_PRIMARIES
;PURPOSE:
;	To compare dist_calibs.dat and grp_assign.gals in order to determine the best primary
;	distance estimates to a group. Outputs a file called grp_primaries.dat which gives information
;	on every AGC galaxy that both belongs to a group and has a primary distance.
;
;CALLING SEQUENCE:
;	grp_primaries
;
;REQUIRES: 
;	Must be located in the same directory as grp_assign.gals and dist_calibs.dat, and you
;	must have write permission in that directory.
;	
;
;INPUTS:
;	None.	
;
;OUTPUTS:
;	grp_primaries.dat - A file containing information for each and every AGC number that is found
;				in both grp_assign.gals and dist_calibs.dat. Columns are AGC Number, Group
;				Number, Distance (Mpc), and Distance Error (Mpc).
;			Read statement is
;			readf,grpprimarylun,test_agcnum,test_grpnumber,test_dist,test_edist,format='(I6,2X,I6,2X,F8.2,2X,F8.2)'
;
;
;PROCEDURE:
;	The code is called with a flag to indicate whether the input file is in AGC or GALCAT format. The
;	program proceeds differently depending on the input file format, and in the end the outputs are also different.
;
;NOTES:
;	
;
; 
;REVISION HISTORY:
;       Written   A.Martin   August 2007
;
;-


;first, read both dist_calibs.dat and grp_assign.gals into arrays


openr,caliblun,agcdir+'dist_calibs.dat',/get_lun
	
	calibagcnumber=dblarr(1)
	calname=strarr(1)
	junk2=strarr(1)
	calvhel=dblarr(1)
	calibdist=dblarr(1)
	calibedist=dblarr(1)
	junk3=strarr(1)

	while(EOF(caliblun) ne 1) do begin
		lncalname=''
		lnjunk2=''
		lnjunk3=''
		readf,caliblun,lnCALAGCNUMBER,lnCALNAME,lnJUNK2,lnCALVHEL,lnCALIBDIST,lnCALIBEDIST,lnJUNK3,$
		format='(i6,1x,a8,1x,a15,i5,f8.3,f7.3,a50)'
	
		calibagcnumber=[calibagcnumber,lncalagcnumber]
		calname=[calname,lncalname]
		junk2=[junk2,lnjunk2]
		calvhel=[calvhel,lncalvhel]
		calibdist=[calibdist,lncalibdist]
		calibedist=[calibedist,lncalibedist]
		junk3=[junk3,lnjunk3]
		
	endwhile
	
	calibagcnumber=calibagcnumber[1:*]
	calname=calname[1:*]
	junk2=junk2[1:*]
	calvhel=calvhel[1:*]
	calibdist=calibdist[1:*]
	calibedist=calibedist[1:*]
	junk3=junk3[1:*]

	close,caliblun
	free_lun,caliblun

	openr,grplun,agcdir+'grp_assign.gals',/get_lun

	grpagcnumber=dblarr(1)
	grpnumber=dblarr(1)
	cenra=dblarr(1)
	cendec=dblarr(1)
	galra=dblarr(1)
	galdec=dblarr(1)
	sepmin=dblarr(1)
	grpcmbvel=dblarr(1)
	junk1=strarr(1)

	while(EOF(grplun) ne 1) do begin
		lnjunk1=''
		readf,grplun,lnGRPAGCNUMBER,lnGRPNUMBER,lnCENRA,lnCENDEC,lnGALRA,lnGALDEC,lnSEPMIN,IVGRP_CMB,lnJUNK1,$
		format='(2i6,4f10.5,f6.1,i6,a25)'

		grpagcnumber=[grpagcnumber,lngrpagcnumber]
		grpnumber=[grpnumber,lngrpnumber]
		cenra=[cenra,lncenra]
		cendec=[cendec,lncendec]
		galra=[galra,lngalra]
		galdec=[galdec,lngaldec]
		sepmin=[sepmin,lnsepmin]
		grpcmbvel=[grpcmbvel,ivgrp_cmb]
		junk1=[junk1,lnjunk1]		

	endwhile

	grpagcnumber=grpagcnumber[1:*]
	grpnumber=grpnumber[1:*]
	cenra=cenra[1:*]
	cendec=cendec[1:*]
	galra=galra[1:*]
	galdec=galdec[1:*]
	sepmin=sepmin[1:*]
	grpcmbvel=grpcmbvel[1:*]
	junk1=junk1[1:*]


	close,grplun
	free_lun,grplun




;next, check and see if any of the objects in each group have a primary distance

openw,grpprimarylun,'grp_primaries.dat',/get_lun

;first, set up the "out" arrays: the agcnumber with the primary, the group number, the distance, and the error on the distance
out_agc=dblarr(1)
out_grpnum=dblarr(1)
out_dist=dblarr(1)
out_edist=dblarr(1)

;for each AGC number in the group list, you want to check and see if it has a corresponding
;distance in the calibs list.
;if it does, then you need to grab the distance, the error distance, the AGC number, and the group number

n_groups=n_elements(grpagcnumber)
for i=0,n_groups-1 do begin
	;i is the index for anything from the GROUP file
	test_agcnum=grpagcnumber[i]
	test_index=where((TEST_AGCNUM EQ CALIBAGCNUMBER),count)
	;test_index is the index for anything from the CALIBS file

	if (count eq 1) then begin
		;determine the distance and the error for that calibrator
		test_dist=calibdist[test_index]
		test_edist=calibedist[test_index]
		;also grab the group number
		test_grpnumber=grpnumber[i]

		;print,test_agcnum,test_grpnumber,test_dist,test_edist,format='(I6,2X,I6,2X,F8.2,2X,F8.2)'

		out_agc=[out_agc,test_agcnum]
		out_grpnum=[out_grpnum,test_grpnumber]
		out_dist=[out_dist,test_dist]
		out_edist=[out_edist,test_edist]

		printf,grpprimarylun,test_agcnum,test_grpnumber,test_dist,test_edist,format='(I6,2X,I6,2X,F8.2,2X,F8.2)'
	endif

endfor

out_agc=out_agc[1:*]
out_grpnum=out_grpnum[1:*]
out_dist=out_dist[1:*]
out_edist=out_edist[1:*]

close,grpprimarylun
free_lun,grpprimarylun

;TEST: how can we find each of the unique elements?
grpsort=out_grpnum[sort(out_grpnum)]
;print,grpsort

;unique elements
grps_list=grpsort[uniq(grpsort)]
print,grps_list
print,'There are: ',n_elements(grps_list)

;out of 327 galaxies, there are only 123 distinct group numbers

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

