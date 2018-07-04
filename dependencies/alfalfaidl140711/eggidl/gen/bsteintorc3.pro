PRO BSTEINTORC3, BSTEINTYPE, RC3TYPE, BAR

;+
; NAME: 
;	BSTEINTORC3
;
; PURPOSE:
;	Converts Burstein's type codes to a RC3 type system.
;	See TYPEESGC for a description of Burstein types.
;
; SYNTAX:
;	BSTEINTORC3,bsteintype, rc3type, bar
;
; INPUTS:
;	bsteintype - Burstein type - integer
;
; OUTPUTS:
;	rc3type	- RC3 type - integer
;	bar - string variable designating status - 'B' for barred galaxies, '' otherwise
;
; MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-


;Check arguments and keywords
if(n_params() ne 3) then message, 'Usage: BSTEINTORC3, BSTEINTYPE, RC3TYPE, BAR'
if(n_elements(BSTEINTYPE) eq 0) then message, 'BSTEINTYPE is undefined'


;Assign RC3type to BSTEINtypes
if(BSTEINTYPE eq 0) then begin
	RC3TYPE = 20
	BARRED = 0
endif else if((BSTEINTYPE eq 10) OR (BSTEINTYPE eq 11)) then begin
	RC3TYPE = -6
	BARRED = 0
endif else if(BSTEINTYPE eq 15) then begin
	RC3TYPE = -5
	BARRED = 0
endif else if((BSTEINTYPE GE 90) AND (BSTEINTYPE LE 103)) then begin
	RC3TYPE = -2
	BARRED = ((BSTEINTYPE eq 101) OR (BSTEINTYPE eq 103))
endif else if((BSTEINTYPE GE 110) AND (BSTEINTYPE LE 112)) then begin
	RC3TYPE = 0
	BARRED = BSTEINTYPE eq 111
endif else if((BSTEINTYPE GE 120) AND (BSTEINTYPE LE 122)) then begin
	RC3TYPE = 1
	BARRED = ((BSTEINTYPE eq 121) OR (BSTEINTYPE eq 122))
endif else if((BSTEINTYPE GE 130) AND (BSTEINTYPE LE 132)) then begin
	RC3TYPE = 2
	BARRED = ((BSTEINTYPE eq 131) OR (BSTEINTYPE eq 132))
endif else if((BSTEINTYPE GE 140) AND (BSTEINTYPE LE 142)) then begin
	RC3TYPE = 3
	BARRED = ((BSTEINTYPE eq 141) OR (BSTEINTYPE eq 142))
endif else if((BSTEINTYPE GE 150) AND (BSTEINTYPE LE 152)) then begin
	RC3TYPE = 4
	BARRED = ((BSTEINTYPE eq 151) OR (BSTEINTYPE eq 152))
endif else if((BSTEINTYPE GE 160) AND (BSTEINTYPE LE 162)) then begin
	RC3TYPE = 5
	BARRED = ((BSTEINTYPE eq 161) OR (BSTEINTYPE eq 162))
endif else if((BSTEINTYPE GE 170) AND (BSTEINTYPE LE 172)) then begin
	RC3TYPE = 6
	BARRED = ((BSTEINTYPE eq 171) OR (BSTEINTYPE eq 172))
endif else if((BSTEINTYPE GE 180) AND (BSTEINTYPE LE 182)) then begin
	RC3TYPE = 7
	BARRED = ((BSTEINTYPE eq 181) OR (BSTEINTYPE eq 182))
endif else if((BSTEINTYPE GE 200) AND (BSTEINTYPE LE 212)) then begin
	RC3TYPE = 10
	BARRED = BSTEINTYPE eq 211 
endif else if((BSTEINTYPE GE 300) AND (BSTEINTYPE LE 305)) then begin
	RC3TYPE = 3
	BARRED = ((BSTEINTYPE eq 305) OR (BSTEINTYPE eq 301))
endif else if((BSTEINTYPE eq 310) OR (BSTEINTYPE eq 320) OR (BSTEINTYPE eq 330) OR (BSTEINTYPE eq 400)) then begin
	RC3TYPE = 11
	BARRED = BSTEINTYPE eq 330
endif else if(BSTEINTYPE eq 410) then begin
	RC3TYPE = 11
	BARRED = 0
endif else if((BSTEINTYPE eq 500) OR (BSTEINTYPE eq 600) OR (BSTEINTYPE eq 650)) then begin
	RC3TYPE = 20
	BARRED = 0
endif else if(BSTEINTYPE eq 700) then begin
	RC3TYPE =99
	BARRED = 0
endif else if(BSTEINTYPE eq 900) then begin
	RC3TYPE=99
	BARRED = 0
endif else begin
	message,'ERROR: Burstein type code is illegal.'
endelse
	

if(BARRED eq 1) then begin
	BAR='B'
endif else begin
	BAR=''
endelse

RETURN

END
