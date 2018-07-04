PRO TYPEESGC, BSTEINTYPE, HGTYPE, BAR

;+
; NAME: 
;	TYPEESGC
;
; PURPOSE:
;	Converts from Burstein numerical coding of Nilson's UGC
;	morphological types to a 0-10 (E-pec) scale plus a BAR flag.
;	Galaxies w hich do not fit well on this scale (e.g. compacts) are
;	assigned HGTYPE=11.
;	See notes below for a description of Burstein types.
;	Was updated in 1/88 to account for new types:
;
;             12  :  used for Nilson's (and Giovanelli's)  "S..."
;             13  :   "    "     "       "       "         "..."
;             14  :  these are compact-looking galaxies which do not
;                    look like E's or S0's, i.e. the impression is
;                    that their photometric profile is not as
;                    strongly concentrated as a bulge; they are
;                    typically small, (less than 0.5') and could be
;                    burned out SB spirals, BCD's or others of the
;                    same sort. They are good candidates for finding
;                    HI (and are often strong FIR sources).
;             99  :  untyped
;
;	Also updated to accommodate deVaucouleurs system used by Corwin in ESGC.
;
; SYNTAX:
;	TYPEESGC,bsteintype, hgtype, bar
;
; INPUTS:
;	bsteintype - Burstein type - integer
;
; OUTPUTS:
;	hgtype	- HG type
;	bar - variable designating status - 'B' for barred galaxies, '' otherwise
;
; MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;
; NOTES:
;     Burstein's system:   0  untyped
;                         10  E, dwarf E
;                         11  dE    (Virgo BST class)
;                         15  E-S0
;                         90  dS0       91  dSB0
;                        100  S0       101  SB0     102  SAB0
;                        110  S0-a     111  SB0-a   112  S0-a/SB0-a
;                        120  Sa       121  SBa     122  Sa/SBa
;                        130  Sa-b     131  SBa-b   132  Sa/SBb
;                        140  Sb       141  SBb     142  Sb/SBb
;                        150  Sb-c     151  SBb-c   152  SBb/Sc, Sb/SBc
;                        160  Sc       161  SBc     162  Sc/SBc
;                        170  Scd      171  SBcd    172  Scd/SBcd
;                        180  Sd       181  SBd     182  Sd/SBd
;                        200  Irr      201  IB      202  I/IB
;                        210  Im       211  IBm     212  Im/Ibm
;                        300  S...     301  SB...   302 SAB...
;                                      305  SB...  DB original
;                        310  Sm       311  SBm     312  SABm     
;                        320  S IV, IV-V, etc.   330  SB IV, IV-V, etc.
;                        400  dwarf
;                        410  BCD
;                        500  compact
;                        600  multiple system
;                        650  typed galaxy + companion (e.g. "E + comp")
;                        700  peculiar, disturbed, disrupted, eruptive
;                        710  IO
;                        900  ...
;-


;Check arguments and keywords
if(n_params() ne 3) then message, 'Usage: TYPEESGC, BSTEINTYPE, HGTYPE, BAR'
if(n_elements(BSTEINTYPE) eq 0) then message, 'BSTEINTYPE is undefined'


;Assign types
if(BSTEINTYPE eq 0) then begin
	HGTYPE = 99
	BARRED = 0
endif else if((BSTEINTYPE GE 10) AND (BSTEINTYPE LE 15)) then begin
	HGTYPE = 0
	BARRED = 0
endif else if((BSTEINTYPE GE 90) AND (BSTEINTYPE LE 103)) then begin
	HGTYPE = 1
	BARRED = ((BSTEINTYPE eq 101) OR (BSTEINTYPE eq 91))
endif else if((BSTEINTYPE GE 110) AND (BSTEINTYPE LE 112)) then begin
	HGTYPE = 2
	BARRED = BSTEINTYPE eq 111
endif else if((BSTEINTYPE GE 120) AND (BSTEINTYPE LE 122)) then begin
	HGTYPE = 3
	BARRED = (BSTEINTYPE eq 121)
endif else if((BSTEINTYPE GE 130) AND (BSTEINTYPE LE 132)) then begin
	HGTYPE = 4
	BARRED = (BSTEINTYPE eq 131)
endif else if((BSTEINTYPE GE 140) AND (BSTEINTYPE LE 142)) then begin
	HGTYPE = 5
	BARRED = BSTEINTYPE eq 141
endif else if((BSTEINTYPE GE 150) AND (BSTEINTYPE LE 152)) then begin
	HGTYPE = 6
	BARRED = ((BSTEINTYPE eq 151) OR (BSTEINTYPE eq 152))
endif else if((BSTEINTYPE GE 160) AND (BSTEINTYPE LE 162)) then begin
	HGTYPE = 7
	BARRED = BSTEINTYPE eq 161
endif else if((BSTEINTYPE GE 170) AND (BSTEINTYPE LE 182)) then begin
	HGTYPE = 8
	BARRED = ((BSTEINTYPE eq 171) OR (BSTEINTYPE eq 181))
endif else if((BSTEINTYPE GE 200) AND (BSTEINTYPE LE 212)) then begin
	HGTYPE = 9
	BARRED = BSTEINTYPE eq 211 
endif else if((BSTEINTYPE GE 300) AND (BSTEINTYPE LE 305)) then begin
	HGTYPE = 12
	BARRED = ((BSTEINTYPE eq 305) OR (BSTEINTYPE eq 301))
endif else if((BSTEINTYPE GE 310) AND (BSTEINTYPE LE 312)) then begin
	HGTYPE = 8
	BARRED = BSTEINTYPE eq 311
endif else if((BSTEINTYPE eq 320) OR (BSTEINTYPE eq 330)) then begin
	HGTYPE = 8
	BARRED = BSTEINTYPE eq 330
endif else if(BSTEINTYPE eq 400) then begin
	HGTYPE = 9
	BARRED = 0
endif else if((BSTEINTYPE eq 410) OR (BSTEINTYPE eq 420)) then begin
	HGTYPE = 14
	BARRED = 0
endif else if((BSTEINTYPE eq 500) OR (BSTEINTYPE eq 600) OR (BSTEINTYPE eq 650)) then begin
	HGTYPE = 11
	BARRED = 0
endif else if((BSTEINTYPE eq 700) OR (BSTEINTYPE eq 710)) then begin
	HGTYPE =10
	BARRED = 0
endif else if(BSTEINTYPE eq 900) then begin
	HGTYPE=13
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PRO TYPEREVERT, HGTYPE, BAR, BSTEINTYPE

;+
;NAME: 
;	TYPEREVERT
;
;PURPOSE:
;	Reverts to Burstein type from HG type; obviously, the results
;	are not so fine-tuned as are true UGC types
;
;SYNTAX: 
;	TYPEREVERT,hgtype,bar,bsteintype
;
; INPUTS:
;	hgtype - HG type - integer
;	bar - variable designating status - 'B' for barred galaxies, '' otherwise
;
; OUTPUTS:
;	bsteintype - Burstein type - integer. See TYPEESGC for a description of Burstein types.
;
;MODIFICATION HISTORY:
;       Written  MH&RG
;       Converted to IDL   A.Martin   June 2006
;-	

;Check arguments and keywords
if(n_params() ne 3) then message, 'Usage: TYPEREVERT, HGTYPE, BAR, BSTEINTYPE'
if(n_elements(HGTYPE) eq 0) then message, 'HGTYPE is undefined'

typedefs=[[10,100,110,120,130,140,150,160,170,200,700,900,300,900,420],[10,101,111,121,131,141,151,161,171,200,700,900,301,900,420]]

if(HGTYPE eq 99) then begin
	bsteintype=0
endif

if((BAR eq 'B') AND (HGTYPE ne 99)) then begin
	bsteintype=typedefs[HGTYPE,1]
endif else if(HGTYPE ne 99) then begin
	bsteintype=typedefs[HGTYPE,0]
endif


END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
