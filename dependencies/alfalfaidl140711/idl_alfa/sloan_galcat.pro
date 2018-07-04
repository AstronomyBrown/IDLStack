;+
; NAME:
;      SLOAN_GALCAT
; PURPOSE:
;       IDL wrapper for SQLCL.py python class to obtain an SDSS SQL Query
;       
;
; EXPLANATION:
;
;       Returns requested SDSS information for use in the GALCAT GUI
;
;
;
; CALLING SEQUENCE:
;       
;       sloan_galcat,objID,SpecObjID,$
;                          petroMag_u,petroMag_g,petroMag_r,petroMag_i,petroMag_z,$
;                          petroMagErr_u,petroMagErr_g,petroMagErr_r,petroMagErr_i,petroMagErr_z,$
;                          extinction_u,extinction_g,extinction_r,extinction_i,extinction_z,$
;                          petroR50_r,petroR90_r,expAB_r
;
; INPUTS:
;       objID:  SDSS photometric identifier
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;
;          
;
; OUTPUTS:
;       SDSS parameters
;
;
; RESTRICTIONS:
;
;        Typically used with galflux
;
; EXAMPLE:
;
;       Pretty straight forward:  Choose "Acquire SDSS" from the GALCAT GUI
;
; PROCEDURES USED:
;         External python program:  sqlcl.py
;
;
;
; MODIFICATION HISTORY:
;
;    November 1, 2009, Brian Kent, NRAO - original version
;
;

pro sloan_galcat,objID,SpecObjID,$
                          petroMag_u,petroMag_g,petroMag_r,petroMag_i,petroMag_z,$
                          petroMagErr_u,petroMagErr_g,petroMagErr_r,petroMagErr_i,petroMagErr_z,$
                          extinction_u,extinction_g,extinction_r,extinction_i,extinction_z,$
                          petroR50_r,petroR90_r,expAB_r,$
                          modelMag_u,modelMag_g,modelMag_r,modelMag_i,modelMag_z,$
			  modelMagErr_u,modelMagErr_g,modelMagErr_r,modelMagErr_i,modelMagErr_z,$
                          mjd, plate, fiberID

common agcshare, agcdir

if (objid ne '') then begin

 result=file_test('~/temp1138.csv')
 if (result) then spawn, '/bin/rm -rf ~/temp1138.csv'

objidstring=objid

spawn, agcdir+'sqlcl.py -q "SELECT p.objID,p.SpecObjID, '+$

       'p.petroMag_u, p.petroMag_g, p.petroMag_r, p.petroMag_i, p.petroMag_z, '+$

       'p.petroMagErr_u, p.petroMagErr_g, p.petroMagErr_r, p.petroMagErr_i, p.petroMagErr_z, '+$

       'p.extinction_u, p.extinction_g, p.extinction_r, p.extinction_i, p.extinction_z, '+$

       'p.petroR50_r, p.petroR90_r, p.expAB_r, '+$

       'p.modelMag_u, p.modelMag_g, p.modelMag_r, p.modelMag_i, p.modelMag_z, '+$

       'p.modelmagErr_u, p.modelmagErr_g, p.modelmagErr_r, p.modelmagErr_i, p.modelmagErr_z '+$ 

       ' FROM PhotoObjAll p WHERE p.objID='+objidstring+'" -f csv > ~/temp1138.csv', answer


;Get the data from the temporary SDSS file
file='~/temp1138.csv'
readcol,file, objID,SpecObjID,$
                          petroMag_u,petroMag_g,petroMag_r,petroMag_i,petroMag_z,$
                          petroMagErr_u,petroMagErr_g,petroMagErr_r,petroMagErr_i,petroMagErr_z,$
                          extinction_u,extinction_g,extinction_r,extinction_i,extinction_z,$
                          petroR50_r,petroR90_r,expAB_r, $
			  modelMag_u,modelMag_g,modelMag_r,modelMag_i,modelMag_z,$
			  modelMagErr_u,modelMagErr_g,modelMagErr_r,modelMagErr_i,modelMagErr_z,$
                          format='A,A,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D',$
                          skipline=1, /silent

;spawn, 'more ~/temp1138.csv', junk

;preserve correct information about the identifiers
objID=strcompress(objID[0], /remove_all)            ;string type
specObjID=strcompress(specObjID[0], /remove_all)    ;string type

if (specObjID eq '0') then specObjID='-1'

;Reform arrays into scalars
petroMag_u=petroMag_u[0]
petroMag_g=petroMag_g[0]
petroMag_r=petroMag_r[0]
petroMag_i=petroMag_i[0]
petroMag_z=petroMag_z[0]
petroMagErr_u=petroMagErr_u[0]
petroMagErr_g=petroMagErr_g[0]
petroMagErr_r=petroMagErr_r[0]
petroMagErr_i=petroMagErr_i[0]
petroMagErr_z=petroMagErr_z[0]
extinction_u=extinction_u[0]
extinction_g=extinction_g[0]
extinction_r=extinction_r[0]
extinction_i=extinction_i[0]
extinction_z=extinction_z[0]
petroR50_r=petroR50_r[0]
petroR90_r=petroR90_r[0]
expAB_r=expAB_r[0]
modelMag_u=modelMag_u[0]
modelMag_g=modelMag_g[0]
modelMag_r=modelMag_r[0]
modelMag_i=modelMag_i[0]
modelMag_z=modelMag_z[0]
modelMagErr_u=modelMagErr_u[0]
modelMagErr_g=modelMagErr_g[0]
modelMagErr_r=modelMagErr_r[0]
modelMagErr_i=modelMagErr_i[0]
modelMagErr_z=modelMagErr_z[0]

;print, objID,SpecObjID,$
;       petroMag_u,petroMag_g,petroMag_r,petroMag_i,petroMag_z,$
;       petroMagErr_u,petroMagErr_g,petroMagErr_r,petroMagErr_i,petroMagErr_z,$
;       extinction_u,extinction_g,extinction_r,extinction_i,extinction_z,$
;       petroR50_r,petroR90_r,expAB_r

;print, objID

result=file_test('~/temp1138.csv')
 if (result) then spawn, '/bin/rm -rf ~/temp1138.csv'

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Query the SpecObj View, not the table

	mjd=''
	plate=''
	fiberID=''

	if (SpecObjID ne '-1') then begin

		specobjidstring=specobjid

		spawn, agcdir+'sqlcl.py -q "SELECT s.SpecObjID, s.mjd, s.plate, s.fiberID'+$

       		  ' FROM specObj s WHERE s.SpecObjID='+specobjidstring+'" -f csv > ~/temp1138.csv',$
		  answer

		;Get the data from the temporary SDSS file
		file='~/temp1138.csv'
		readcol,file, specObjID, mjd, plate, fiberID,$
                          format='A,A,A,A',$
                          skipline=1, /silent

		specObjID=strcompress(specObjID[0], /remove_all)    ;string type
		mjd=strcompress(mjd, /remove_all)  		    ;string type
		plate=strcompress(plate, /remove_all)		    ;string type
		fiberID=strcompress(fiberID, /remove_all)		    ;string type

	endif ;of specObjAll query


endif

end