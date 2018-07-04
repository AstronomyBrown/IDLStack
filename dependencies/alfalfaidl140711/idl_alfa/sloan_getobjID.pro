;+
; NAME:
;      sloan_getobjID
; PURPOSE:
;       Obtain SDSS Explorer URL and return the object ID for the GALCAT GUI
;       
;
; EXPLANATION:
;
;       Returns string type SDSS ObjID, which is stored in the galcat common block
;          and passed to sloan_galcat
;
; CALLING SEQUENCE:
;       
;       sloan_getobjID,objID
;
; INPUTS:
;       None.  Retreives SDSS URL via the C-program XCLIP
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
;       objID:  SDSS photometric identifier
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
;         External C-program:  xsel
;
;
;
; MODIFICATION HISTORY:
;
;    November 1, 2009, Brian Kent, NRAO - original version
;
;



pro sloan_getobjID, objID

common agcshare, agcdir

;Get data from the web browser
spawn, agcdir+'xsel', answer

;Example
;http://cas.sdss.org/dr7/en/tools/explore/obj.asp?id=587731511532060694
url=answer
pos=strpos(url,'=')
if (pos[0] eq -1) then begin
     status=dialog_message('Problem retrieving SDSS, please try again.')
     objID=''
endif else begin

	posperiod=strpos(strmid(url,pos+1), '.')
        if (posperiod[0] eq -1) then begin
 		objID=strmid(url,pos+1)
	endif else begin
		status=dialog_message('Problem retrieving SDSS, please try again.')
     		objID=''
        endelse

endelse

end