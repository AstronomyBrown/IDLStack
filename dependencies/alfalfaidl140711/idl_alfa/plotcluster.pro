;-------------------------------------------------------------
;+
; NAME:
;       PLOTCLUSTER
; PURPOSE:
;       Set up the gui for plotcluster. Plotcluster displays a widget
;       where the user can input coordinates and the size of the box
;       that the user wants to view. Plotcluster will plot all
;       galaxies, clusters and NOG groups (if NOG option is turned on) in
;       the user specified region. If a cluster or NOG group is in the
;       region a cz vs. R plot is made of all the galaxies inside the
;       NOG group or cluster radius. A cz historgram is also made of all the
;       galaxies in the cluster or NOG group radius. The user can also
;       specify a box of which a cz vs. R plot and a cz historgram are
;       made.The user can also specify a cz range of which he wants a 
;       mean and standard deviation.
;
; EXPLANATION:
;       Set up the gui and let the event handler do the rest of the
;       work (plotting)
;
; SYNTAX:
;       PLOTCLUSTER
;
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;  
;
; PROCEDURES CALLED
;       PLOTCLUSTER_EVENT
;
; NOTES:
;       THIS PROGRAM REQUIRES THE AGC CATALOG TO BE LOCATED IN 
;       THE AGCDIR. IT ALSO REQUIRES A FILE
;       NAMED clustercat WITH THE CLUSTER CATALOG INFORMATION IN IT.
;       nog.tab7 IS ANOTHER FILE REQUIRED. THIS FILE HAS ALL THE NOG 
;       GROUP INFORMATION. ALL THESE FILES NEED TO BE LOCATED IN THE
;       AGCDIR.
;
;
;	Ann, summer 2007: When Walter wrote this code, he used the flow
;	model to obtain distances to NOG clusters (and therefore calculate
;	their linear size from their radial size). This has been changed
;	to use only the velocity (measured in the CMB rest frame) to estimate
;	distances using pure Hubble flow. While doing this I noticed that there
;	are some issues with switching back & forth between degrees and radians,
;	(see line 1602 for an example) so anyone using plotcluster in the 
;	future should keep this in mind!
;
;-
;-------------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function vhel_to_cmb,glongr, glatr
;+
; NAME:  
;       VHEL_TO_CMB
;
; PURPOSE:
;        Calculate the projection along the LOS velocity wrt to the CMB velocity
;
; EXPLANATION:
;       Function takes lb coordinates to compute the projection along 
;       the LOS velocity wrt to the CMB velocity.  Quite simple.
;
; SYNTAX: 
;       result=VHEL_TO_CMB(l,b)
;
; INPUT PARAMETERS: 
;       l:  galactic longitude in degrees
;       b:  galactic latitude in degrees
;
; OUTPUT PARAMETERS: ;
;      result - CMB velocity projected along the line of sight.
;              
; EXAMPLES:
;
;      IDL> print,  35344+vhel_to_cmb(112.62994,-25.039215)
;            You should get:  35031.226
;
;	Comments from original FORTRAN program:
;
;	"Computes the component, in the direction of
;	a given galaxy, of the motion of the Sun with
;	respect to the Local Universe. Source for velocities
;	and directions : Kogut et al. 1993 (ApJ 419,1)
;       Also added the Lineweaver 1996 paper.
;
;	Assumes you have already converted RA,Dec to l,b IN DEGREES!
;	Be sure to put a declaration statement like
;	REAL Vhel_to_CMB(GLONGR,GLATR)
;	in your main program. and then something like:
;	vcmb = vhelio + VHEL_to_CMB(glr,gbr)."
;
;
; HISTORY: 
;       FORTRAN subroutine by R. Giovanelli, M.P. Haynes
;       Conversion to IDL, B. Kent, Cornell University, 2006
;-
      
      ONEDEG=!dpi/180.
      ;REAL GLATR, GLONGR, APEX(3), V_APEX, B_APEX, L_APEX, COS_ANG
     
      ;APEX=[369.5,264.4,48.4]    ;Kogut et al. 1993 (ApJ 419,1); uncomment if you want to use.
      APEX=[368.7,264.31,48.05]  ;Lineweaver 1996
     
;     where Apex(0) is velocity of the Sun to the CMBin km/s,
;           Apex(1,2) are galactic longitude and latitude of Apex.
     
     
      V_APEX = APEX[0]
      L_APEX = APEX[1]*ONEDEG
      B_APEX = APEX[2]*ONEDEG
      COS_ANG = double(SIN(B_APEX)*SIN(GLATR*ONEDEG) + $
                COS(B_APEX)*COS(GLATR*ONEDEG)*COS(L_APEX - GLONGR*ONEDEG))
      Vhel_CMB = double(V_APEX*COS_ANG)
     
      return, Vhel_CMB 
      

end


;-------------------------------------------------------------
;+
; NAME:
;       DELCHR
; PURPOSE:
;       Delete all occurrences of a character from a text string.
; CATEGORY:
; SYNTAX:
;       new = delchr(old, char)
; INPUTS:
;       old = original text string.     in
;       char = character to delete.     in
; KEYWORD PARAMETERS:
; OUTPUTS:
;       new = resulting string.         out
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner.  5 Jul, 1988.
;       Johns Hopkins Applied Physics Lab.
;       RES 11 Sep, 1989 --- converted to SUN.
;       R. Sterner, 27 Jan, 1993 --- dropped reference to array.
;
; Copyright (C) 1988, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
FUNCTION DELCHR, OLD, C, help=hlp

if (n_params(0) lt 2) or keyword_set(hlp) then begin
    print,' Delete all occurrences of a character from a text string.'
    print,' new = delchr(old, char)
    print,'   old = original text string.     in'
    print,'   char = character to delete.     in'
    print,'   new = resulting string.         out'
    return, -1
endif

B = BYTE(OLD)                   ; convert string to a byte array.
CB = BYTE(C)                    ; convert char to byte.
w = where(b ne cb(0))
if w(0) eq -1 then return, ''   ; Nothing left.
return, string(b(w))            ; Return new string.
END
    
;-------------------------------------------------------------
;+
; NAME:
;       NWRDS
; PURPOSE:
;       Return the number of words in the given text string.
; CATEGORY:
; SYNTAX:
;       n = nwrds(txt)
; INPUTS:
;       txt = text string to examine.             in
; KEYWORD PARAMETERS:
;       Keywords:
;         DELIMITER = d.  Set delimiter character (def = space).
; OUTPUTS:
;       n = number of words found.                out
; COMMON BLOCKS:
; NOTES:
;       Notes: See also getwrd.
; MODIFICATION HISTORY:
;       R. Sterner,  7 Feb, 1985.
;       Johns Hopkins University Applied Physics Laboratory.
;       RES 4 Sep, 1989 --- converted to SUN.
;
; Copyright (C) 1985, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
 
function nwrds,txtstr, help=hlp, delimiter=delim

if (n_params(0) lt 1) or keyword_set(hlp) then begin
    print,' Return the number of words in the given text string.'
    print,' n = nwrds(txt)'
    print,'   txt = text string to examine.             in'
    print,'   n = number of words found.                out'
    print,' Keywords:'
    print,'   DELIMITER = d.  Set delimiter character (def = space).'
    print,' Notes: See also getwrd.'
    return, -1
endif
      
if strlen(txtstr) eq 0 then return,0 ; A null string has 0 words.
ddel = ' '			; Default word delimiter is a space.
if n_elements(delim) ne 0 then ddel = delim ; Use given word delimiter.
tst = (byte(ddel))(0)           ; Delimiter as a byte value.
tb = byte(txtstr)               ; String to bytes.
if ddel eq ' ' then begin       ; Check for tabs?
    w = where(tb eq 9B, cnt)    ; Yes.
    if cnt gt 0 then tb(w) = 32B ; Convert any to space.
endif
x = tb ne tst                   ; Locate words.
x = [0,x,0]                     ; Pad ends with delimiters.

y = (x-shift(x,1)) eq 1         ; Look for word beginnings.

n = fix(total(y))               ; Count word beginnings.

return, n

end

;-------------------------------------------------------------
;+
; NAME:
;       ISNUMBER
; PURPOSE:
;       Determine if a text string is a valid number.
; CATEGORY:
; SYNTAX:
;       i = isnumber(txt, [x])
; INPUTS:
;       txt = text string to test.                      in
; KEYWORD PARAMETERS:
; OUTPUTS:
;       x = optionaly returned numeric value if valid.  out
;       i = test flag:                                  out
;           0: not a number.
;           1: txt is a long integer.
;           2: txt is a float.
;           -1: first word of txt is a long integer.
;           -2: first word of txt is a float.
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner.  15 Oct, 1986.
;       Johns Hopkins Applied Physics Lab.
;       R. Sterner, 12 Mar, 1990 --- upgraded.
;	Richard Garrett, 14 June, 1992 --- fixed bug in returned float value.
;
; Copyright (C) 1986, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
FUNCTION ISNUMBER, TXT0, X, help=hlp

if (n_params(0) lt 1) or keyword_set(hlp) then begin
    print,' Determine if a text string is a valid number.'
    print,' i = isnumber(txt, [x])
    print,'   txt = text string to test.                      in'
    print,'   x = optionaly returned numeric value if valid.  out'
    print,'   i = test flag:                                  out'
    print,'       0: not a number.'
    print,'       1: txt is a long integer.'
    print,'       2: txt is a float.'
    print,'       -1: first word of txt is a long integer.'
    print,'       -2: first word of txt is a float.'
    return, -1
endif

TXT = STRTRIM(TXT0,2)           ; trim blanks.
X = 0                           ; define X.

IF TXT EQ '' THEN RETURN, 0	; null string not a number.

SN = 1
IF NWRDS(TXT) GT 1 THEN BEGIN	; get first word if more than one.
    SN = -1
    TXT = GETWRD(TXT,0)
ENDIF

f_flag = 0                      ; Floating flag.
b = byte(txt)
w = where(b eq 43, cnt)
if cnt gt 1 then return, 0
t = delchr(txt,'+')
w = where(b eq 45, cnt)
if cnt gt 1 then return, 0
t = delchr(t,'-')
w = where(b eq 46, cnt)         ; '.'
if cnt gt 1 then return, 0      ; May only be 1.
if cnt eq 1 then f_flag = 1     ; If one then floating.
t = delchr(t,'.')
w = where(b eq 101, cnt)        ; 'e'
if cnt gt 1 then return, 0
if cnt eq 1 then f_flag = 1
t = delchr(t,'e')
w = where(b eq 69, cnt)         ; 'E'
if cnt gt 1 then return, 0
if cnt eq 1 then f_flag = 1
t = delchr(t,'E')
w = where(b eq 100, cnt)        ; 'd'
if cnt gt 1 then return, 0
if cnt eq 1 then f_flag = 1
t = delchr(t,'d')
w = where(b eq 68, cnt)         ; 'D'
if cnt gt 1 then return, 0
if cnt eq 1 then f_flag = 1
t = delchr(t,'D')
if total((b eq 101)+(b eq 69)+(b eq 100)+(b eq 68)) gt 1 then return,0
b = byte(t)
if total((b ge 65) and (b le 122)) ne 0 then return, 0

c = strmid(t,0,1)
if (c lt '0') or (c gt '9') then return, 0 ; First char not a digit.

x = txt + 0.0                   ; Convert to a float.
if f_flag eq 1 then return, 2*sn ; Was floating.
if x eq long(x) then begin
    x = long(x)
    return, sn
endif else begin
    return, 2*sn
endelse

END

;-------------------------------------------------------------
;+
;NAME: 
;	CARTES
;
;PURPOSE:
;	Calculates the separation between two objects. Input and output in degrees!
;
;SYNTAX: 
;	result=CARTES(r1,r2,d1,d2)
;
;INPUTS: 
;	r1 - RA of object one in degrees
;	r2 - RA of object two in degrees
;	d1 - Dec of object one in degrees
;	d2 - Dec of object two in degrees
;OUTPUTS: 
;	result - separation of objects in rad
;
;-	
;-------------------------------------------------------------

FUNCTION CARTES, R1, R2, D1, D2
;Check arguments and keywords
if(n_params() ne 4) then message, 'Usage: result=cartes(r1,r2,d1,d2)'
r1=float(r1)
r2=float(r2)
d1=float(d1)
d2=float(d2)
onedeg = !dpi/180
COSSEP = SIN(D1*onedeg)*SIN(D2*onedeg) + COS(D1*onedeg)*COS(D2*onedeg)*(COS(R1*onedeg)*COS(R2*onedeg) + SIN(R1*onedeg)*SIN(R2*onedeg))

;There are a few different ways to make sure COSSEP can be defined as a cosine:
;COMPARE1=[COSSEP,1.0]
;COSSEP=MIN(compare1)
;COMPARE2=[COSSEP,-1.0]
;COSSEP=MAX(compare2)

;if(COSSEP LT 1.0) then COSSEP=COSSEP else COSSEP=1.0
;if(COSSEP GT (-1.0)) then COSSEP=COSSEP else COSSEP=(-1.0)

;I chose:

COSSEP = COSSEP < 1.0
COSSEP = COSSEP > (-1.0)
S=ACOS(COSSEP)

RETURN, s/onedeg
END


;-------------------------------------------------------------
;+
;NAME: 
;	SAVESTATEINFO
;
;PURPOSE:
;	Save all important info into the state structure
;
;SYNTAX: 
;	SAVESTATEINFO, INFO, INFOPTR
;
;INPUTS: 
;	INFO - Structure to be saved
;       INFOPTR - Pointer pointing to the destination of the updated
;                 structure
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-	
;-------------------------------------------------------------
PRO SAVESTATEINFO, INFO, INFOPTR
if(ptr_valid(infoptr) eq 0) then message, 'State information pointer is invalid'
if(n_elements(info) eq 0) then message, 'State information structure is undefined'
if keyword_set(no_copy) then begin
    *infoptr = temporary(info)
endif else begin
    *infoptr = info
endelse        
END

;-------------------------------------------------------------
;+
; NAME:
;       PLOTHISTANDCZR_CLUSTER
; PURPOSE:
;       Plot the cz histogram and the cz vs r plot
; EXPLANATION:
;       Takes cluster info and plots the velocity of the galaxies
;       inside the radius of the cluster vs the cluster-galaxy
;       separation. Also makes a histogram of the velocities of the
;       galaxies inside the radius of the cluster
;
; SYNTAX:
;        PLOTHISTANDCZR_CLUSTER, XRA_CLUST, XRA, YDEC_CLUST, YDEC,$
;        R_CLUST, NGAL, INDEX, GVEL, CLUST_VELOCITY, DRAW_CZ,$
;        DRAW_CZ_HIST, POINT_INFO, BIN_SLIDER, INFO, INFOPTR, $
;        CZSCALE, JUST_SCALE
;
; INPUTS:
;       XRA_CLUST -  Array with the R.A.'s of the clusters found in
;                    range
;       XRA - Array with the R.A.'s of the galaxies found in range
;       YDEC_CLUST - Array with the Decs of the clusters found in
;                    range
;       YDEC - Array with the Decs of the galaxies found in range
;       R_CLUST - Array of radii of the clusters
;       NGALS - Number of galaxies found
;       INDEX - Which cluster are we plotting for
;       GVEL - Array of velocities of the found galaxies
;       CLUST_VELOCITY - Array of velocities of the found clusters
;       DRAWCZ - Wigdet id of the cz vs. r plot draw widget
;       DRAW_CZ_HIST - Widget id of the cz histogram draw widget
;       POINT_INFO - Widget id of the info text box
;       BINSLIDER - Widget id of the cz bin slider
;       INFO - Structure to be saved for SAVESTATEINFO call
;       INFOPTR - Pointer pointing to the destination of the updated
;                 structure for SAVESTATEINFO call
;       CZSCALE - Zoom scale for the cz vs r plot
;       JUSTCALE - Whether or not only the cz vs r plot should be scaled
;
; PROCEDURES CALLED
;       PRINTCLUSTERINFO, PLOTHIST, SAVESTATEINFO, CARTES  
;
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-
;-------------------------------------------------------------

PRO PLOTHISTANDCZR_CLUSTER, XRA_CLUST, XRA, YDEC_CLUST, YDEC, R_CLUST, NGAL, INDEX, GVEL, CLUST_VELOCITY, DRAW_CZ, DRAW_CZ_HIST, POINT_INFO, $
                            BIN_SLIDER, INFO, INFOPTR, CZSCALE, JUST_SCALE

nplotgals = 0
r_cz = fltarr(10000)
cz = fltarr(10000)
for i = 0, ngal-1 do begin
    if(cartes(xra_clust[index], xra[i], ydec_clust[index], ydec[i]) le r_clust[index]/60 and xra[i] le info.ramax and $
      xra[i] ge info.ramin and ydec[i] ge info.decmin and ydec[i] le info.decmax)then begin
        r_cz[nplotgals] = cartes(xra_clust[index], xra[i], ydec_clust[index], ydec[i])
        cz[nplotgals] = gvel[i]
        nplotgals++
    endif
endfor

clust_cz = clust_velocity[index]
if(nplotgals gt 0) then begin
clust_cz_plot = fltarr(100) 
rmin_to_rmax = fltarr(100)

galcz = 0
if(czscale ne 1) then begin
    for i = 0, nplotgals-1 do begin
        if(cz[i] ne 0) then galcz = [galcz, cz[i]] 
    endfor
    if(n_elements(galcz) ge 2) then cz = galcz[1:n_elements(galcz)-1]   
    nplotgals = n_elements(cz)
endif

max_cz = max(cz[0:nplotgals-1])
min_cz = min(cz[0:nplotgals-1])
max_r = max(r_cz[0:nplotgals-1])
min_r = min(r_cz[0:nplotgals-1])

width = max([max_cz-clust_cz, clust_cz-min_cz])
max_cz = clust_cz+width/float(czscale)
min_cz = clust_cz-width/float(czscale)

for i = 0, 99 do begin
    rmin_to_rmax[i] = min_r-0.01 + i* (((max_r+0.01) - (min_r-0.01))/float(99))
    clust_cz_plot[i] = clust_cz
endfor

widget_control, draw_cz, get_value = wincz
wset, wincz

plot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], /nodata, yrange = [min_cz-1000/czscale, max_cz+1000/float(czscale)], ytitle = 'cz',$
  xtitle = 'R from center of cluster, group or box', xstyle = 1, ystyle = 1, xrange = [min_r- 0.01, max_r+0.01], $
  position=[0.19, 0.15, .95, 0.93]
oplot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], psym=1
oplot, rmin_to_rmax, clust_cz_plot, linestyle = 2

if(just_scale ne 1) then begin
    widget_control, draw_cz_hist, get_value = winczhist
    wset, winczhist
    binsize = (max_cz-min_cz)/(nplotgals/float(4))
    if(nplotgals ge 2) then plothist, cz[0:nplotgals-1], bin = binsize, xtitle = 'cz'
    
    widget_control, bin_slider, SET_SLIDER_MAX = binsize+binsize*.8
    widget_control, bin_slider, SET_SLIDER_MIN = binsize-binsize*.8
    widget_control, bin_slider, set_value = binsize
    
    point_info_text = ''
    printclusterinfo,xra_clust[index], ydec_clust[index], foundflag, point_info_text
    widget_control, point_info, set_value=point_info_text
endif
endif
info.galcz = cz
info.nplotgals = nplotgals

savestateinfo, info, infoptr


END

;-------------------------------------------------------------
;+
; NAME:
;       PLOTHISTANDCZR_NOG
; PURPOSE:
;       Plot the cz histogram and the cz vs r plot
; EXPLANATION:
;       Takes nog group info and plots the velocity of the galaxies
;       inside the radius of the nog group vs the nog-galaxy
;       separation. Also makes a histogram of the velocities of the
;       galaxies inside the radius of the nog group
;
; SYNTAX:
;        PLOTHISTANDCZR_NOG, XRA_NOG, XRA, YDEC_NOG, YDEC,$
;        R_NOG, NGAL, INDEX, GVEL, NOG_VELOCITY, DRAW_CZ,$
;        DRAW_CZ_HIST, POINT_INFO, BIN_SLIDER, INFO, INFOPTR, $
;        CZSCALE, JUST_SCALE
;
; INPUTS:
;       XRA_NOG -  Array with the R.A.'s of the nog groups found in
;                    range
;       XRA - Array with the R.A.'s of the galaxies found in range
;       YDEC_NOG - Array with the Decs of the nog groups found in
;                    range
;       YDEC - Array with the Decs of the galaxies found in range
;       R_NOG - Array of radii of the nog groups
;       NGALS - Number of galaxies found
;       INDEX - Which nog group are we plotting for
;       GVEL - Array of velocities of the found galaxies
;       NOG_VELOCITY - Array of velocities of the found nog groups
;       DRAWCZ - Wigdet id of the cz vs. r plot draw widget
;       DRAW_CZ_HIST - Widget id of the cz histogram draw widget
;       POINT_INFO - Widget id of the info text box
;       BINSLIDER - Widget id of the cz bin slider
;       INFO - Structure to be saved for SAVESTATEINFO call
;       INFOPTR - Pointer pointing to the destination of the updated
;                 structure for SAVESTATEINFO call
;       CZSCALE - Zoom scale for the cz vs r plot
;       JUSTCALE - Whether or not only the cz vs r plot should be scaled
;
; PROCEDURES CALLED
;       PRINTNOGINFO, PLOTHIST, SAVESTATEINFO, CARTES  
;
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-
;-------------------------------------------------------------

PRO PLOTHISTANDCZR_NOG, XRA_NOG, XRA, YDEC_NOG, YDEC, R_NOG, NGAL, INDEX, GVEL, NOG_VELOCITY, DRAW_CZ, DRAW_CZ_HIST, POINT_INFO, $
                            BIN_SLIDER, INFO, INFOPTR, CZSCALE, JUST_SCALE

nplotgals = 0
r_cz = fltarr(10000)
cz = fltarr(10000)
for i = 0, ngal-1 do begin
    if(cartes(xra_nog[index], xra[i], ydec_nog[index], ydec[i]) le r_nog[index] and xra[i] le info.ramax and $
      xra[i] ge info.ramin and ydec[i] ge info.decmin and ydec[i] le info.decmax)then begin
        r_cz[nplotgals] = cartes(xra_nog[index], xra[i], ydec_nog[index], ydec[i])
        cz[nplotgals] = gvel[i]
        nplotgals++
    endif
endfor

nog_cz = nog_velocity[index]

nog_cz_plot = fltarr(100) 
rmin_to_rmax = fltarr(100)

galcz = 0
if(czscale ne 1) then begin
    for i = 0, nplotgals-1 do begin
        if(cz[i] ne 0) then galcz = [galcz, cz[i]] 
    endfor
    if(n_elements(galcz) ge 2) then cz = galcz[1:n_elements(galcz)-1]   
    nplotgals = n_elements(cz)
endif

max_cz = max(cz[0:nplotgals-1])
min_cz = min(cz[0:nplotgals-1])
max_r = max(r_cz[0:nplotgals-1])
min_r = min(r_cz[0:nplotgals-1])

width = max([max_cz-nog_cz, nog_cz-min_cz])
max_cz = nog_cz+width/float(czscale)
min_cz = nog_cz-width/float(czscale)

for i = 0, 99 do begin
    rmin_to_rmax[i] = min_r-0.01 + i* (((max_r+0.01) - (min_r-0.01))/float(99))
    nog_cz_plot[i] = nog_cz
endfor

widget_control, draw_cz, get_value = wincz
wset, wincz

plot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], /nodata, yrange = [min_cz-1000/czscale, max_cz+1000/float(czscale)], ytitle = 'cz',$
  xtitle = 'R from center of cluster, group or box', xstyle = 1, ystyle = 1, xrange = [min_r- 0.01, max_r+0.01], $
  position=[0.19, 0.15, .95, 0.93]
oplot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], psym=1
oplot, rmin_to_rmax, nog_cz_plot, linestyle = 2

if(just_scale ne 1) then begin
    widget_control, draw_cz_hist, get_value = winczhist
    wset, winczhist
    binsize = (max_cz-min_cz)/(nplotgals/float(4))
    if(nplotgals ge 2) then plothist, cz[0:nplotgals-1], bin = binsize, xtitle = 'cz'
    
    widget_control, bin_slider, SET_SLIDER_MAX = binsize+binsize*.8
    widget_control, bin_slider, SET_SLIDER_MIN = binsize-binsize*.8
    widget_control, bin_slider, set_value = binsize
    
    point_info_text = ''
    printnoginfo,xra_nog[index], ydec_nog[index], foundflag, point_info_text
    widget_control, point_info, set_value=point_info_text
endif

info.galcz = cz
info.nplotgals = nplotgals

savestateinfo, info, infoptr


END

;-------------------------------------------------------------
;+
; NAME:
;       PRINTCLUSTERINFO
; PURPOSE:
;       Output a string with cluster info if cursor was on a cluster 
; EXPLANATION:
;       It reads in the file containing the info on the clusters
;       in the specified range and then checks if the cursor is within
;       a certain range of the coordinates of the cluster
;
; SYNTAX:
;       PRINTCLUSTERINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR
;
; INPUTS:
;       XCURS - X position of the cursor 
;       YCURS - Y position of the cursor

;
; OUTPUTS:
;       FOUNDFLAG - If there are no clusters in the position
;                        this is set to 0, else 1.
;       OUTPUTSTR - The string containing the cluster info of the 
;                      cluster
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-
;-------------------------------------------------------------
PRO PRINTCLUSTERINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR 
outputstr = ''

readcol, 'clusts.txt', clust_num, ra, dec, vel, red, size, /silent, delimiter = '|', format = '(a, f, f, f, f)'

for i = 0, n_elements(ra)-1 do begin 
    rah = fix(ra[i]/15)
    ram = fix((ra[i]/15-rah)*60)
    ras10 = fix(((ra[i]/15-rah)*60-ram)*600)

    decd = fix(dec[i])
    decm = fix((dec[i]-decd)*60)
    decs = fix(((dec[i]-decd)*60-decm)*60)

    sign = '+'
    if(dec[i] lt 0) then sign = '-' 

    if((abs(ra[i]-xcurs) lt 0.01  and  abs(dec[i]-ycurs) lt 0.01)) then begin
        outputstr = string(clust_num[i], RAH,RAM,RAS10,sign,DECD,DECM,DECS,vel[i], red[i], size[i], format = '(A12, 3x, 2I2.2,I3.3,A1,3I2.2, f , f, f)') 
         
        foundflag = 1
    endif
endfor
end
;-------------------------------------------------------------
;+
; NAME:
;       PRINTNOGINFO
; PURPOSE:
;       Output a string with nog group info if cursor was on a nog group 
; EXPLANATION:
;       It reads in the file containing the info on the nog groups
;       in the specified range and then checks if the cursor is within
;       a certain range of the coordinates of the nog group
;
; SYNTAX:
;       PRINTNOGINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR
;
; INPUTS:
;       XCURS - X position of the cursor 
;       YCURS - Y position of the cursor

;
; OUTPUTS:
;       FOUNDFLAG - If there are no nog groups in the position
;                        this is set to 0, else 1.
;       OUTPUTSTR - The string containing the nog group info of the 
;                      nog group
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-
;-------------------------------------------------------------
PRO PRINTNOGINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR 
openr, nog_txt_lun, 'nog.txt', /get_lun
name = ''
pnote = ''
comname = ''
p1name = '' 
p2name = ''
garcia = ''
tully = ''
nnog = 0
nvhel = 0
nognum = 0
sgn = ''

while(EOF(nog_txt_lun) ne 1) do begin
    readf, nog_txt_lun, IDNUM,PNOTE,NAME,NMEMB,irh,irm, $
      rs,sgn,idd,idm,ids,nvhel,comname,p1name,p2name,garcia,tully, $
      format = '(i4,1x,a1,1x,a15,i3,2x,i2,1x,i2,1x,f4.1,2x, a1,i2,1x,i2,1x,i2,3x,i4,1x,a15,1x,a16,1x,a16,1x,a20,1x,a20)'

    rahours = float(irh) + float(irm)/60 + float(rs)/3600
    ra=rahours*15
    dec= float(idd)+ float(idm)/60 + float(ids)/3600

    if((abs(ra-xcurs) lt 0.01  and  abs(dec-ycurs) lt 0.01)) then begin
        outputstr = string(idnum,PNOTE,NAME,NMEMB, irh,irm,rs,sgn,idd,idm,ids,nvhel,comname,p1name,$
                           p2name,garcia,tully, format = '(i4,1x,a1,1x,a10,i3,2x,i2,1x,i2,1x,f4.1,2x, a1,i2,1x,i2,1x,i2,3x,i4,1x,a10,1x,a10,1x,a10,1x,a10,1x,a10)')
        foundflag = 1
    endif
endwhile

close, nog_txt_lun
free_lun, nog_txt_lun

end

;-------------------------------------------------------------
;+
; NAME:
;       PRINTAGCINFO
; PURPOSE:
;       Output a string with agc info if cursor was on a agc galaxy 
; EXPLANATION:
;       It reads in the file containing the info on the agc galaxies
;       in the specified range and then checks if the cursor is within
;       a certain range of the coordinates of the galaxy
;
; SYNTAX:
;       PRINTAGCINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR
;
; INPUTS:
;       XCURS - X position of the cursor 
;       YCURS - Y position of the cursor
;
; OUTPUTS:
;       FOUNDFLAG - If there are no agc galaxies in the position
;                        this is set to 0, else 1.
;       OUTPUTSTR - The string containing the agc info of the agc
;                      galaxy
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated to idl by
;       WHH during summer 2006
;-
;-------------------------------------------------------------
PRO PRINTAGCINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR 

;
;   AGC declarations
; This procedure outputs a string, outputstr, that has all the agc info
DESCRIPTION = ''
NGCIC = ''
WHICH = ''
TELCODE = ''
WIDTHCODE = ''
SIGN = ''
AGCNUMBER = 0L
outputstr = ''
openr, gals_txt_lun, 'gals.txt', /get_lun
nr=0
while(EOF(gals_txt_lun) ne 1) do begin
    readf, gals_txt_lun, AGCNUMBER,WHICH,NGCIC,RAH,RAM,RAS10,SIGN,DECD,DECM,$
      DECS,A100,B100,MAG10,BSTEINTYPE,VOPT,VSOURCE,FLUX100,RMS100,$
      V21,WIDTH,WIDTHCODE,TELCODE,DETCODE,HISOURCE,IBANDQUAL,IBANDSRC,POSANG,IPOSITION,ipalomar,$
      format = '(I6,A1,A8,1x,2I2.2,I3.3,A1,3I2.2,I5,2I4,i6,2x,I5,I3,2x,I5,I7,1x,I7,I4,1x,A4,A4,i1,1x,I3,2i3,i5,2i3)'

    rahours = float(rah) + float(ram)/60 + float(ras10)/36000
    ra=rahours*15
    dec= float(decd)+ float(decm)/60 + float(decs)/3600

    if(sign eq '-') then dec = -dec
    if((abs(ra-xcurs) lt 0.01  and  abs(dec-ycurs) lt 0.01)) then begin

        outputstr = string(AGCNUMBER,WHICH,NGCIC,RAH,RAM,RAS10,SIGN,DECD,DECM,$
          DECS,A100,B100,MAG10,BSTEINTYPE,VOPT,VSOURCE,FLUX100,RMS100,$
          V21,WIDTH,WIDTHCODE,TELCODE,DETCODE,HISOURCE,$
          IBANDQUAL,IBANDSRC,POSANG,IPOSITION,ipalomar,$
          format = '(I6,A1,A8,1x,2I2.2,I3.3,A1,3I2.2,I5,2I4,i6,2x,I5,I3,2x,I5,I7,1x,I7,I4,1x,A4,A4,i1,1x,I3,2i3,i5,2i3)')
        foundflag = 1
    endif
endwhile
close, gals_txt_lun
free_lun, gals_txt_lun
end

;-------------------------------------------------------------
;+
; NAME:
;       DRAWGAL
; PURPOSE:
;       Returns an array with the galaxy coordinates that draw the
;       galaxy
;
; EXPLANATION:
;       Takes the galaxy radius and creates arrays that hold the
;       galaxy drawing coordinates
;
; SYNTAX:
;       DRAWGAL, XIN, YIN, GRAD, GEPS, GPA, SCALE, XGAL, YGAL, NGALPTS
;
; INPUTS:
;       XIN - The x coordinate of the galaxy center  
;       YIN - The y coordinate of the galaxy center
;       GRAD - The radius of the galaxy
;       GEPS - The galaxy eccentricity
;       SCALE - Scaling factor to use when making output arrays
;
; OUTPUTS:
;       XGAL - The array with the x positions of the galaxy (this is to
;           plot the galaxy)
;       YGAL - The array with the y positions of the galaxy (this is to
;           plot the galaxy)
;       NGALPTS - Number of points used to draw the galaxy
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated to idl by
;       WHH during summer 2006
;-
;-------------------------------------------------------------

PRO DRAWGAL, XIN, YIN, GRAD, GEPS, GPA, SCALE, XGAL, YGAL, NGALPTS
;
;  Calculates an array containing the outline of the galaxy
;
;  Input:   centra and centdec in degrees
;  Output:  x1,x2 in degrees
;
degrad = 57.29578
;
;  convert to arcsecs
;
xcent = xin*3600.0
ycent = yin*3600.0

if(grad lt 15) then grad *= scale

;  ang is the angle in degrees around the circle
;  this doesn't draw ellipses yet


    if(gpa eq 90 or gpa eq 0 or gpa ge 180) then begin
        ngalpts = 0
        ang = 0
        for j=0,360 do begin
            xgal[j] = xcent + grad * cos(float(ang)/degrad)
            ygal[j] = ycent + grad * sin(float(ang)/degrad)
            ang++
            ngalpts++
        endfor
        for j=0, ngalpts do begin
            xgal[j]=xgal[j]/3600
            ygal[j]=ygal[j]/3600
        endfor
    endif else ngalpts = 5

    if(gpa lt 90 and gpa ne 0) then begin
        theta=90-gpa
        xgal[0]=xcent+grad*cos(float(theta)/degrad)
        ygal[0]=ycent+grad*sin(float(theta)/degrad)
        xgal[1]=xcent
        ygal[1]=ycent+grad*geps
        xgal[2]=xcent-grad*cos(float(theta)/degrad)
        ygal[2]=ycent-grad*sin(float(theta)/degrad)
        xgal[3]=xcent
        ygal[3]=ycent-grad*geps
        xgal[4]=xgal[0]
        ygal[4]=ygal[0]
        for j=0, ngalpts do begin
            xgal[j]=xgal[j]/3600
            ygal[j]=ygal[j]/3600
        endfor
        
    endif

    if(gpa gt 90  and  gpa lt 180) then begin
        theta=gpa-90
        xgal[0]=xcent+grad*cos(float(theta)/degrad)
        ygal[0]=ycent-grad*sin(float(theta)/degrad)
        xgal[1]=xcent
        ygal[1]=ycent+grad*geps
        xgal[2]=xcent-grad*cos(float(theta)/degrad)
        ygal[2]=ycent+grad*sin(float(theta)/degrad)
        xgal[3]=xcent
        ygal[3]=ycent-grad*geps
        xgal[4]=xgal[0]
        ygal[4]=ygal[0]
        
        for j=0, ngalpts do begin
            xgal[j]=xgal[j]/3600
            ygal[j]=ygal[j]/3600
        endfor
    endif
    

end

;-------------------------------------------------------------
;+
; NAME:
;       DRAWNOG
; PURPOSE:
;       Returns an array with the nog group coordinates that draw the
;       group
;
; EXPLANATION:
;       Takes the nog velocity and creates arrays that hold the
;       group drawing coordinates
;
; SYNTAX:
;       DRAWNOG, XIN, YIN, VEL, XNOG, YNOG, NNOGPTS
;
; INPUTS:
;       XIN - The x coordinate of the group center  
;       YIN - The y coordinate of the group center
;       VEL - The velocity of the group
;
; OUTPUTS:
;       XNOG - The array with the x positions of the group (this is to
;           plot the group circle)
;       YNOG - The array with the y positions of the group (this is to
;           plot the group circle)
;       NNOGPTS - Number of points used to draw the group 
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-
;-------------------------------------------------------------
PRO DRAWNOG, XIN, YIN,  XNOG, YNOG, NNOGPTS, NOG_RAD
;
;  Calculates an array containing the outline f the galaxy
;
;  Input:   centra and centdec in degrees
;  Output:  x1,x2 in degrees
;

;
;  convert to arcsecs
;
xcent = xin*3600.0
ycent = yin*3600.0 
nnogpts = 0
ang = 0
for j=0,360 do begin
    nnogpts++
    xnog[j] = xcent + nog_rad*cos(float(ang)*!dtor)
    ynog[j] = ycent + nog_rad*sin(float(ang)*!dtor)
    ang++
endfor

for j=0, nnogpts do begin
    xnog[j]=xnog[j]/3600
    ynog[j]=ynog[j]/3600
endfor
end


;-------------------------------------------------------------
;+
; NAME:
;       DRAWCLUST
; PURPOSE:
;       Returns an array with the cluster coordinates that draw the
;       cluster
;
; EXPLANATION:
;       Takes the cluster radius and creates arrays that hold the
;       cluster drawing coordinates
;
; SYNTAX:
;       DRAWGAL, XIN, YIN, CLUST_RAD,XCLUST, YCLUST, NCLUSTPTS
;
; INPUTS:
;       XIN - The x coordinate of the cluster center  
;       YIN - The y coordinate of the cluster center
;       CLUST_RAD - The radius of the cluster
;
; OUTPUTS:
;       XCLUST - The array with the x positions of the cluster (this is to
;           plot the cluster)
;       YCLUST - The array with the y positions of the cluster (this is to
;           plot the cluster circle)
;       NCLUSTPTS - Number of points used to draw the cluster
;
; REVISION HISTORY:
;       Written by WHH during summer 2006
;-
;-------------------------------------------------------------
PRO DRAWCLUST, XIN, YIN, CLUST_RAD, XCLUST, YCLUST, NCLUSTPTS
;
;  Calculates an array containing the outline f the galaxy
;
;  Input:   centra and centdec in degrees
;  Output:  x1,x2 in degrees
;
degrad = 57.29578
clust_rad *= 60;

;  convert to arcsecs
;
xcent = xin*3600.0
ycent = yin*3600.0

nclustpts = 0
ang = 0
for j=0,360 do begin
    nclustpts++
    xclust[j] = xcent + clust_rad*cos(float(ang)/degrad)
    yclust[j] = ycent + clust_rad*sin(float(ang)/degrad)
    ang++
endfor

for j=0, nclustpts do begin
    xclust[j]=xclust[j]/3600
    yclust[j]=yclust[j]/3600
endfor

end


;-------------------------------------------------------------
;+
; NAME:
;       PLOTFRAME
; PURPOSE:
;       Does the actual plotting of the clusters, galaxies and frame of
;       interest.
; EXPLANATION:
;       Takes the user defined range and coordinates and then plots
;       all the galaxies and clusters in this range.
;
; SYNTAX:
;       PLOTFRAME, CENTRA, CENTDEC, RAMIN, RAMAX, DECMIN, DECMAX,
;       NAGC, XRA, YDEC, GSIZE, GELLIP, GPOSANG, GVEL, NGALS, $
;       R_CLUST, NCLUST, XRA_CLUST, YDEC_CLUST, CLUST_VELOCITY, HARD,$
;       FILENAME_PLOT, RANGE, CLUST_ID
;
; INPUTS:
;       CENTRA - Center R.A. defined by user
;       CENTRDEC - Center Dec defined by user
;       RAMIN - Minimum R.A. in range
;       RAMAX - Maximum R.A. in range
;       DECMIN - Minimum Dec in range
;       DECMAX - Maximum Dec in range
;       XRA - Array with the R.A.'s of the galaxies found in range
;       YDEC - Array with the Decs of the galaxies found in range
;       GSIZE - Array of sizes of galaxies to be plotted
;       GELLIP - Eccentricity of the galaxies
;       GPOSANG - Array of position angles of the found galaxies
;       GVEL - Array of velocities of the found galaxies
;       NGALS - Number of galaxies found
;       R_CLUST - Array of radii of the clusters
;       NCLUST - Number of clusters in range
;       XRA_CLUST -  Array with the R.A.'s of the clusters found in
;                   range
;       YDEC_CLUST - Array with the Decs of the clusters found in
;                    range
;       CLUST_VELOCITY - Array of velocities of the found clusters
;       HARD - Whether or not this plot should be on postscript or
;              screen, 0 is on screen, 1 is on postscript
;       FILENAME_PLOT - Name of postscript file to plot on
;       RANGE - Range defined by user
;       CLUST_ID - Array of cluster id's 
;
; PROCEDURES CALLED
;       PRINTAGCINFO, DRAWGAL, DRAWCLUST, PRINTCLUSTERINFO
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated and updated to idl
;       with added features by
;       WHH during summer 2006
;-
;-------------------------------------------------------------
PRO PLOTFRAME, CENTRA, CENTDEC, RAMIN, RAMAX, DECMIN, DECMAX, NAGC, XRA, YDEC, GSIZE, GELLIP, GPOSANG, GVEL, NGALS, R_CLUST, NCLUST, XRA_CLUST, $
                 YDEC_CLUST, CLUST_VELOCITY, HARD, FILENAME_PLOT, RANGE, CLUST_ID, NOG_FLAG, NNOG, XRA_NOG, YDEC_NOG, NOG_VEL, NOG_ID, NOG_RAD

; This procedure plots everything onto the plotting area (the axis,
; the galaxies and the beams)

; Some initialisation
label = ''
devname = ''
orient = ''
xlab = ''
ans = ''
blab = strarr(7)
xin_arr = fltarr(1)
yin_arr = fltarr(1)
xin_arr_clust = fltarr(1)
yin_arr_clust = fltarr(1)
xin_arr_nog = fltarr(1)
yin_arr_nog = fltarr(1)
x1 = fltarr(1000)
y1 = fltarr(1000)
xgal = fltarr(1000)
ygal = fltarr(1000)
xnog = fltarr(1000)
ynog = fltarr(1000)
xclust = fltarr(1000)
yclust = fltarr(1000)
nrads = 720
scale = 1.0
for i = 0, 6 do blab[i] = string(i)

; Make sure that the correct plotting device is chosen
entry_device = !d.name
if(hard eq 1) then begin
    set_plot, 'PS'
    device, filename = filename_plot, /color, xsize = 8.0, ysize = 8.0, xoffset = (8.5-7.0)*0.5, yoffset = (11-7.0)*0.5, /inches
    loadct, 39, /silent       
endif 

;Plot axis

plot, xin_arr, yin_arr, /nodata, xrange = [ramax, ramin], yrange = [decmin, decmax], xtitle = 'R.A. (Degrees)', ytitle = 'Dec. (Degrees)',$
  xstyle = 1, ystyle = 1, position=[0.08, 0.06, .86, 0.98]

if(hard eq 0) then begin
    device, decomposed = 0
    loadct, 39, /silent
endif

for j = 0, ngals-1 do begin

; Color according to gvel...

    xin = xra[j]
    yin = ydec[j]
    grad=gsize[j]
    geps=gellip[j]
    gpa=gposang[j]
    gv=gvel[j]
    drawgal, xin, yin, grad, geps, gpa, scale, xgal, ygal, ngalpts  
    xin_arr[0] = xin
    yin_arr[0] = yin
    
    if(hard eq 0) then begin
        if(gv le 18000) then begin
            color = gv/float(90)+50
        endif else color = 255
        oplot, xin_arr, yin_arr, psym = 1, color = color
        oplot, xgal[0:ngalpts-1], ygal[0:ngalpts-1], color = color        
    endif

    if(hard eq 1) then begin 
        if(gv le 18000) then begin
            color = gv/float(90)+50
        endif else color = 0
        oplot, xin_arr, yin_arr, psym = 1, color = color
        oplot, xgal[0:ngalpts-1], ygal[0:ngalpts-1], color = color
    endif
endfor

for j = 0, nclust-1 do begin

; Color according to cluster vel...

    xin_clust = xra_clust[j]
    yin_clust = ydec_clust[j]
    clust_rad = r_clust[j]
    clust_v = clust_velocity[j]
    drawclust, xin_clust, yin_clust, clust_rad, xclust, yclust, nclustpts
    xin_arr_clust[0] = xin_clust
    yin_arr_clust[0] = yin_clust
    
    if(hard eq 0) then begin
        if(clust_v le 18000) then begin
            color = clust_v/float(90)+50
        endif else color = 2551326182+465543
        oplot, xin_arr_clust, yin_arr_clust, psym = 1, color = color
        oplot, xclust[0:nclustpts-1], yclust[0:nclustpts-1], color = color
        xyouts, xin_clust, yin_clust, clust_id[j],$
          charsize = 3, charthick = 2, color = color, alignment = 0.5
    endif

    if(hard eq 1) then begin
        if(clust_v le 18000) then begin
            color = clust_v/float(90)+50
        endif else color = 0
        oplot, xin_arr_clust, yin_arr_clust, psym = 1, color = color
        oplot, xclust[0:nclustpts-1], yclust[0:nclustpts-1], color = color
        xyouts, xin_clust, yin_clust, clust_id[j],$
          charsize = 3, charthick = 2, color = color, alignment = 0.5
    endif
endfor
colorbar, range=[0,18000], bottom=50, /vertical, title='cz (km/s)', position=[0.88, 0.06, .90, 0.98], /right

if(nog_flag eq 1) then begin
    for j = 0, nnog-1 do begin
        
; Color according to cluster vel...
        
        xin_nog = xra_nog[j]
        yin_nog = ydec_nog[j]
        nog_v = nog_vel[j]
        nog_r = nog_rad[j]
        drawnog, xin_nog, yin_nog, xnog, ynog, nnogpts, nog_r
        xin_arr_nog[0] = xin_nog
        yin_arr_nog[0] = yin_nog
        
        if(hard eq 0) then begin
            if(nog_v le 18000) then begin
                color = nog_v/float(90)+50
            endif else color = 255
            oplot, xin_arr_nog, yin_arr_nog, psym = 1, color = color
            oplot, xnog[0:nnogpts-1], ynog[0:nnogpts-1], color = color
            xyouts, xin_nog, yin_nog, nog_id[j],$
              charsize = 3, charthick = 2, color = color, alignment = 0.5
        endif
        
        if(hard eq 1) then begin
            if(nog_v le 18000) then begin
                color = nog_v/float(90)+50
            endif else color = 0
            oplot, xin_arr_nog, yin_arr_nog, psym = 1, color = color
            oplot, xnog[0:nnogpts-1], ynog[0:nnogpts-1], color = color
            xyouts, xin_nog, yin_nog, nog_id[j],$
              charsize = 3, charthick = 2, color = color, alignment = 0.5
        endif
    endfor  
endif
if(hard eq 1) then device, /close
set_plot, entry_device
end


;-------------------------------------------------------------
;+
; NAME:
;       GETBOUNDS
; PURPOSE:
;       Calculates the plot bounds with the user defined range
;
; EXPLANATION:
;       Takes the center R.A., center Dec and range given by the user
;       and calculate the minimum and maximum R.A. and Dec
;
; SYNTAX:
;       GETBOUNDS, CENTRA, CENTDEC, RAMIN, RAMAX, DECMIN, DECMAX, NPIX
;
; INPUTS:
;       CENTRA - Center R.A. defined by user
;       CENTRDEC - Center Dec defined by user
;       NPIX - Range defined by user 
;
; OUTPUTS:
;       RAMIN - Minimum R.A. in range
;       RAMAX - Maximum R.A. in range
;       DECMIN - Minimum Dec in range
;       DECMAX - Maximum Dec in range  
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated and updated to idl
;       by WHH during summer 2006
;  
;-
;-------------------------------------------------------------

PRO GETBOUNDS, CENTRA, CENTDEC, RAMIN, RAMAX, DECMIN, DECMAX, NPIX
;  Finds
;
;  Input:   centra and centdec in degrees
;           apply cosine for center dec
;  Output:  ramin,ramax,decmin,decmax in degrees
;

degrad = 57.29578
scale = 1.0
npix *= 3600.0
half = float(npix)/2

;
;  convert to arcsecs
;

dec_first=(centdec*3600.0)-half*scale
dec_last=(centdec*3600.0)+half*scale

decr=centdec/degrad
cosdec=cos(decr)
del_ra=cosdec*scale

xcent=centra*3600.0
ra_first=xcent - half*del_ra
ra_last=xcent + half*del_ra

;
;   back to degrees
;
ramin=ra_first/3600.
ramax=ra_last/3600.
decmin=dec_first/3600.
decmax=dec_last/3600.

end


PRO PLOTCLUSTER_EVENT, EVENT

common agcshare

; Set up the widget state info structure
widget_control, event.top, get_uvalue = infoptr
info = *infoptr

; Find out which event caused the event
widget_ev = ''
widget_control, event.id, get_uvalue = widget_ev


; Big conditional statement to make sure user input is valid
if(widget_ev eq 'Plot' or widget_ev eq 'draw_widg' or widget_ev eq 'coords_text' or widget_ev eq 'range_text') then begin

    if(widget_ev eq 'Plot' or widget_ev eq 'coords_text' or widget_ev eq 'range_text') then begin

        range_length = 0              
; Let user know that the widget isn't being idle
        widget_control, event.top, hourglass = 1

        widget_control, info.coords_text, get_value = coords
        widget_control, info.range_text, get_value = range

; Default range is 2.4 degrees
        if(range[0] eq '') then range[0] = float(2.4)                       

        range_test = 0
; Make sure that the user input for the range is a number and that the
; range is between 0.5 and 10
        if(isnumber(range[0]) ne 0) then begin
            if(float(range[0]) le 10 and float(range[0]) ge 0.5) then range_test = 1
        endif

                                ; Check that the input for the
                                ; coordinates and range are valid

        boolstring = stregex(strcompress(string(coords), /remove_all),'[0-9]{7}[\+-][0-9]{6}')
        boolstring2 = strlen(strcompress(string(coords), /remove_all))
        
        if( boolstring[0] ne -1 and boolstring2[0] eq 14 and range_test eq 1) then begin
            range = range[0]
            coords = coords[0]
            x = 0
            y = 0
            xra = 0
            ydec = 0
            gsize = 0
            gellip = 0
            gposang = 0
            gvel = 0
            nagc = 0
            onedeg = !DTOR
            
; Open up files that will hold all the galaxy info in range
            openw, gals_radec_lun, 'gals.radec', /get_lun
            openw, gals_txt_lun, 'gals.txt', /get_lun
; Open up files that will hold all the cluster info in range
            openw, clusts_radec_lun, 'clusts.radec', /get_lun
            openw, clusts_txt_lun, 'clusts.txt', /get_lun

; Read coords
            sgn = ''
            reads, coords, irh, irm, irs10, sgn, idd, idm, ids, format = '(i2, i2, i3, a1, i2, i2, i2)'
            centrah = float(irh) + float(irm)/60.0 + float(irs10)/36000
            centra = centrah*15.0
            centdec = float(idd) + float(idm)/60.0 + float(ids)/3600
            
            if(sgn eq '-') then centdec = -centdec
            
;
; Go find the boundaries of the box, all in degrees
;
            npix = range
            getbounds, centra, centdec, ramin, ramax, decmin, decmax, npix
            bounds = strcompress(ramin, /remove_all) + ',' + strcompress(ramax) + ',' + strcompress(decmin) + ',' + strcompress(decmax)
            widget_control, info.boundaries_text, set_value = bounds
            hard = 0
            
;
;   Now go open the correct AGC file
;   and find all the agc galaxies in region and write their info to the
;   previously opened files
            
            if(decmin ge 0) then begin
                restore, agcdir+'agcnorth.sav'
                agccat = agcnorth
            endif else if(decmax lt 0) then begin 
                restore, agcdir+'agcsouth.sav'
                agccat = agcsouth
            endif else begin
                a = dialog_message('Out of range, please enter a smaller range', /error)
            endelse       
            ngal = 0
            for i = 0L, n_elements(agccat.rah)-1  do begin
                
                rahours = float(agccat.rah[i]) + float(agccat.ram[i])/60 + float(agccat.ras10[i])/36000
                ra = rahours*15	
                dec = float(agccat.decd[i]) + float(agccat.decm[i])/60 +float(agccat.decs[i])/3600
                if(agccat.SIGN[i] eq '-') then dec = -dec
                
                if(ra ge ramin and dec ge decmin and dec le decmax and ra le ramax) then begin                    
                    
                    nagc = [nagc,agccat.agcnumber[i]]
                    xra = [xra,ra]
                    ydec = [ydec,dec]
                    if(agccat.a100[i] gt 0) then gsize = [gsize, 60 *float(agccat.a100[i])/float(100)] else gsize = [gsize, 5]
                    if(agccat.b100[i] gt 0 and agccat.a100[i] ne 0) then gellip = [gellip, float(agccat.b100[i])/float(agccat.a100[i])] else gellip = [gellip, 1]
                    if(agccat.posang[i] ne 0) then gposang = [gposang, float(agccat.posang[i])] else gposang = [gposang, 0]
                    
                    vel = 0
                    if(agccat.vopt[i] ne 0) then vel = float(agccat.vopt[i])
                    if(agccat.v21[i] ne 0  and  (agccat.detcode[i] eq 1  or  agccat.detcode[i] eq 3  or agccat.detcode[i] eq 8)) then  vel = float(agccat.v21[i])
                    if(agccat.v21[i] ne 0  and  vel eq 0  and  (agccat.detcode[i] eq 2  or agccat.detcode[i] eq 5 or  agccat.detcode[i] eq 6 or agccat.detcode[i] eq 9))$
                      then vel = float(agccat.v21[i])
                    gvel = [gvel, vel]               
                    
                    printf, gals_radec_lun,agccat.agcnumber[i],ra,dec, format = '(i6,2e18.10)'
                    printf, gals_txt_lun, agccat.AGCNUMBER[i],agccat.WHICH[i],agccat.NGCIC[i],agccat.RAH[i],agccat.RAM[i],agccat.RAS10[i],agccat.SIGN[i],$
                      agccat.DECD[i],agccat.DECM[i],$
                      agccat.DECS[i],agccat.A100[i],agccat.B100[i],agccat.MAG10[i],agccat.BSTEINTYPE[i],$
                      agccat.VOPT[i],agccat.VSOURCE[i],agccat.FLUX100[i],agccat.RMS100[i],$
                      agccat.V21[i],agccat.WIDTH[i],agccat.WIDTHCODE[i],agccat.TELCODE[i],agccat.DETCODE[i],agccat.HISOURCE[i],$
                      agccat.IBANDQUAL[i],agccat.IBANDSRC[i],agccat.POSANG[i],agccat.IPOSITION[i],agccat.IPALOMAR[i],$
                      format = '(I6,A1,A8,1x,2I2.2,I3.3,A1,3I2.2,I5,2I4,i6,2x,I5,I3,2x,I5,I7,1x,I7,I4,1x,A4,A4,i1,1x,I3,2i3,i5,2i3)'

                    ngal++
                endif 
            endfor
            

            if(ngal ne 0) then begin
                nagc = nagc[1:*]
                xra = xra[1:*]
                ydec = ydec[1:*]
                gsize = gsize[1:*]
                gellip = gellip[1:*]
                gposang = gposang[1:*]
                gvel = gvel[1:*]
            endif

; Open the cluster catalog and find all the clusters in region and
; write their info to the previously opened files
; ra is in degrees

            readcol, agcdir+'clustercat', clust_num, ra_clust, dec_clust, clust_vel, clust_red, clust_size, /silent, delimiter = '|', format = '(a, f, f, f, f)'

            nclust = 0
            clust_id = ''
            xra_clust = 0
            ydec_clust = 0
            clust_velocity = 0
            r_clust = 0
            H0 = float(70)
            r_a = float(1.5)/float(0.7)

            for i = 0, n_elements(ra_clust)-1 do begin
                if(ra_clust[i] ge ramin and dec_clust[i] ge decmin and dec_clust[i] le decmax and ra_clust[i] le ramax) then begin
                    clust_id = [clust_id, clust_num[i]]
                    xra_clust = [xra_clust, ra_clust[i]]
                    ydec_clust = [ydec_clust, dec_clust[i]]
                    clust_velocity = [clust_velocity, clust_vel[i]]
                    r_clust = [r_clust, atan(r_a, clust_vel[i]/H0)*!radeg*60]
                    printf, clusts_radec_lun, clust_num[i], '|', ra_clust[i],'|', dec_clust[i]
                    printf, clusts_txt_lun, clust_num[i]+'|'+string(ra_clust[i])+'|'+ string(dec_clust[i])+'|'+ string(clust_vel[i])+'|'+$
                      string(clust_red[i])+'|'+ string(atan(r_a, clust_vel[i]/H0)*!radeg*60)
                    nclust++
                endif
            endfor

; Open NOG catalog if necesarry

            if(info.nogon eq 1) then begin
                openr, noglun,agcdir+'nog.tab7', /get_lun
                openw, nog_radec_lun, 'nog.radec', /get_lun
                openw, nog_txt_lun, 'nog.txt', /get_lun
                
                ra_nog = 0
                xra_nog = 0
                ydec_nog = 0
                dec_nog = 0
                name = ''
                pnote = ''
                comname = ''
                p1name = '' 
                p2name = ''
                garcia = ''
                tully = ''
                nnog = 0
                nvhel = 0
                nognum = 0
                sgn = ''
                nog_rad = 0
               

                onedeg = !DTOR
                
                while((ra_nog le ramax) and EOF(noglun) ne 1) do begin
                    readf, noglun, IDNUM,PNOTE,NAME,NMEMB,irh,irm, $
                      rs,sgn,idd,idm,ids,ivel,comname,p1name,p2name,garcia,tully, $
                      format = '(i4,1x,a1,1x,a15,i3,2x,i2,1x,i2,1x,f4.1,2x, a1,i2,1x,i2,1x,i2,3x,i4,1x,a15,1x,a16,1x,a16,1x,a20,1x,a20)'

                    cra = float(irh) + float(irm)/60 + rs/3600
                    cdec= float(idd)+ float(idm)/60 + float(ids)/3600
                    if(sgn eq '-') then cdec =- cdec
                    cra = cra * 15
                    jprecess, cra, cdec, ra_nog, dec_nog
                    
                    if(ra_nog ge ramin and dec_nog ge decmin and dec_nog le decmax and nmemb ge 3) then begin 
                        irh = fix(ra_nog/15)
                        irm = fix((ra_nog/15-irh)*60)
                        rs = fix(((ra_nog/15-irh)*60-irm)*600)/10.0

                        idd = fix(dec_nog)
                        idm = fix((dec_nog-idd)*60)
                        ids = fix(((dec_nog-idd)*60-idm)*60)
                        
                        glactc, ra_nog, dec_nog, 2000, gl, gb, 1, /degree
                        delv_yst = -79*cos(gl*onedeg)*cos(gb*onedeg) + 296*sin(gl*onedeg)*cos(gb*onedeg)- 36*sin(gb*onedeg)
                        vhel=float(ivel)-delv_yst
                        
                        nvhel = [nvhel,fix(vhel)]
                        
                        nognum = [nognum, idnum]
                        xra_nog = [xra_nog,ra_nog]
                        ydec_nog = [ydec_nog,dec_nog]
                        
                        ;myflowmodelcall, ra_nog, dec_nog, 0, fix(vhel), 0, distance, d_err, flag
			;ra_nog,dec_nob are in radians
			distance=fix(vhel)
                        nog_rad = [nog_rad, atan(r_a, distance/H0)*!radeg]
                        
                        printf, nog_radec_lun, idnum,ra_nog,dec_nog, format = '(i4,2e18.10)'
                        printf, nog_txt_lun, idnum,PNOTE,NAME,NMEMB, irh,irm,rs,sgn,idd,idm,ids,fix(vhel),comname,p1name,$
                          p2name,garcia,tully, format = '(i4,1x,a1,1x,a15,i3,2x,i2,1x,i2,1x,f4.1,2x, a1,i2,1x,i2,1x,i2,3x,i4,1x,a15,1x,a16,1x,a16,1x,a20,1x,a20)'
                        nnog++
                    endif 
                    
                endwhile
                info.nnog = nnog
                if(nnog ne 0) then begin
                    nognum = nognum[1:*]
                    xra_nog = xra_nog[1:*]
                    ydec_nog = ydec_nog[1:*]
                    nogvel = nvhel[1:*]
                    nog_rad = nog_rad[1:*]
                    
                    info.nognum = nognum
                    info.xra_nog = xra_nog
                    info.ydec_nog = ydec_nog
                    info.nogvel = nogvel        
                    info.nog_rad = nog_rad
                endif
                
                close, noglun
                free_lun, noglun
                close, nog_radec_lun
                free_lun, nog_radec_lun
                close, nog_txt_lun
                free_lun, nog_txt_lun    

            endif
            
; Prepare to plot the cz vs r plot                     
            nplotgals = 0
            r_cz = 0
            cz = 0

            if((nclust ne 0 and ngal ne 0) or (info.nnog ne 0 and info.nogon ne 0 and ngal ne 0) ) then begin
                if(nclust ne 0 and ngal ne 0) then begin
                    clust_id = clust_id[1: n_elements(clust_id)-1]
                    xra_clust = xra_clust[1:n_elements(xra_clust)-1]
                    ydec_clust = ydec_clust[1: n_elements(ydec_clust)-1]
                    clust_velocity = clust_velocity[1: n_elements(clust_velocity)-1]
                    r_clust = r_clust[1:*]
                    
                    for i = 0, ngal-1 do begin
                        if(cartes(xra_clust[0], xra[i], ydec_clust[0],ydec[i]) le r_clust[0]/float(60) and xra[i] le ramax and $
                           xra[i] ge ramin and ydec[i] ge decmin and ydec[i] le decmax) then begin
                            r_cz = [r_cz, cartes(xra_clust[0], xra[i], ydec_clust[0],ydec[i])]
                            cz = [cz, gvel[i]]
                            nplotgals++
                        endif
                    endfor
                    mid_cz = clust_velocity[0]                
                    
                endif else if(info.nnog ne 0 and info.nogon ne 0) then begin
                    for i = 0, ngal-1 do begin
                        if(cartes(info.xra_nog[0], xra[i], info.ydec_nog[0],ydec[i]) le info.nog_rad[0] and xra[i] le ramax and $
                           xra[i] ge ramin and ydec[i] ge decmin and ydec[i] le decmax ) then begin
                            r_cz = [r_cz, cartes(info.xra_nog[0], xra[i], info.ydec_nog[0],ydec[i])]
                            cz = [cz, gvel[i]]
                            nplotgals++
                        endif
                    endfor
                    mid_cz = info.nogvel[0] 
                    
                endif

                if(n_elements(r_cz) gt 1) then begin
                    r_cz = r_cz[1:*]
                    cz = cz[1:*]
                
                mid_cz_plot = fltarr(100) 
                rmin_to_rmax = fltarr(100)
                
                max_cz = max(cz[0:nplotgals-1])
                min_cz = min(cz[0:nplotgals-1])
                max_r = max(r_cz[0:nplotgals-1])
                min_r = min(r_cz[0:nplotgals-1])
                
                width = max([max_cz-mid_cz, mid_cz-min_cz])
                max_cz = mid_cz+width
                min_cz = mid_cz-width
                
                for i = 0, 99 do begin
                    rmin_to_rmax[i] = min_r-0.01 + i* (((max_r+0.01) - (min_r-0.01))/99.0)
                    mid_cz_plot[i] = mid_cz
                endfor

                widget_control, info.cz_slider, set_value = 1
                widget_control, info.cz_max_text, set_value = ' '
                widget_control, info.cz_min_text, set_value = ' '
                widget_control, info.cz_mean_text, set_value = ' '
                widget_control, info.cz_stdev_text, set_value = ' '

                widget_control, info.draw_cz, get_value = wincz
                wset, wincz
                
; Actually do the plotting
                plot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], /nodata, yrange = [min_cz-1000, max_cz+1000], ytitle = 'cz',$
                  xtitle = 'R from center of cluster, group or box', xstyle = 1, ystyle = 1, xrange = [min_r- 0.01, max_r+0.01],$
                  position=[0.19, 0.15, .95, 0.93]
                oplot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], psym=1
                oplot, rmin_to_rmax, mid_cz_plot, linestyle = 2
; Plot the cz histogram
                widget_control, info.draw_cz_hist, get_value = winczhist
                wset, winczhist
                binsize = (max_cz-min_cz)/(float(nplotgals)/4.0)
                if(nplotgals ge 2) then plothist, cz[0:nplotgals-1], bin = binsize, xtitle = 'cz'
; Set up the slider and drop widget properties                
                widget_control, info.bin_slider, SET_SLIDER_MAX = fix(binsize+binsize*.9)
                widget_control, info.bin_slider, SET_SLIDER_MIN = fix(binsize-binsize*.9)
                widget_control, info.bin_slider, set_value = binsize
            endif
                if(nclust gt 0) then dropstring = strcompress(clust_id[0:nclust-1])
                if(info.nogon eq 1 and info.nnog gt 0 and nclust gt 0) then dropstring = [dropstring, strcompress(string(info.nognum[0:info.nnog-1]))]
                if(info.nogon eq 1 and info.nnog gt 0 and nclust eq 0) then dropstring = strcompress(string(info.nognum[0:info.nnog-1]))
                widget_control, info.drop, set_value = dropstring

            endif else begin
                widget_control, info.drop, set_value = [' ']
                widget_control, info.draw_cz_hist, get_value = winczhist
                wset, winczhist
                erase
                widget_control, info.draw_cz, get_value = wincz
                wset, wincz
                erase
            endelse
            
            czscale = 1
            widget_control, info.cz_slider, SET_SLIDER_MAX = 100
            widget_control, info.cz_slider, SET_SLIDER_MIN = 1
            widget_control, info.cz_slider, set_value = czscale

; Save important changeds into the info structure
            
            widget_control, info.gals_text, set_value = strcompress(string(ngal))
            widget_control, info.clust_text, set_value = strcompress(string(nclust))
            widget_control, info.point_info, set_value=' '

            info.centra = centra
            info.centdec = centdec
            info.ramin = ramin
            info.ramax = ramax
            info.decmin = decmin
            info.decmax = decmax
            info.nagc = nagc
            info.xra = xra
            info.ydec = ydec
            info.gsize = gsize
            info.gellip = gellip
            info.gposang = gposang
            info.gvel = gvel
            info.ngal = ngal
            info.coords_plot = coords
            info.plotted = 1
            info.range = range
            info.clust_id = clust_id
            info.xra_clust = xra_clust
            info.ydec_clust = ydec_clust
            info.clust_velocity = clust_velocity
            info.nclust = nclust
            info.r_clust = r_clust
            info.galcz = cz
            info.nplotgals = nplotgals
            info.clustpic = 0
            info.numboxes = 0
            
                                ; Finally make the plot and close all the used files
            widget_control, info.draw_frame, get_value = winframe
            wset, winframe

            plotframe, centra, centdec, ramin, ramax, decmin, decmax, nagc, xra, ydec, gsize, gellip, gposang, gvel, ngal, r_clust, $
              nclust, xra_clust, ydec_clust, clust_velocity, hard, '', range, clust_id, info.nogon, info.nnog, info.xra_nog, info.ydec_nog, info.nogvel, info.nognum, $
              info.nog_rad
            
            info.s_x = !x.s
            info.s_y = !y.s
            info.window_x = !x.window
            info.window_y = !y.window 
            info.clip = !p.clip

            savestateinfo, info, infoptr

            close, gals_radec_lun
            close, gals_txt_lun
            free_lun, gals_txt_lun, gals_radec_lun
            close, clusts_radec_lun
            close, clusts_txt_lun
            free_lun, clusts_txt_lun, clusts_radec_lun
            
            widget_control, event.top, hourglass = 0
; If the user doesn't input a valid range or coordinates show warning message
        endif else if(range_test eq 0) then begin
            a = dialog_message('Please enter a valid range (> 0.5 and < 10)', /error)
        endif else a = dialog_message('Please enter valid coordinates', /error)
        
    endif

; If the draw widget is clicked return info about coords and galaxies
; clicked on
    if(widget_ev eq 'draw_widg' and info.plotted eq 1 and info.makebox eq 0) then begin

        widget_control, info.draw_frame, get_value = winframe
        wset, winframe

        !x.window = info.window_x 
        !x.s = info.s_x
        !y.window = info.window_y
        !y.s = info.s_y
        !p.clip = info.clip

        info.xc = event.x
        info.yc = event.y
        
        xy_data = convert_coord(info.xc, info.yc, /device, /to_data)
        x_data = xy_data[0]
        y_data =  xy_data[1]
        foundflag = 0
        if(info.ngal ne 0) then printagcinfo, x_data, y_data, foundflag, point_info_text
        if(foundflag eq 0 and info.nclust ne 0) then printclusterinfo, x_data, y_data, foundflag, point_info_text
        if(foundflag eq 0) then point_info_text = string(x_data, y_data, format = '(2f15.6,6x,2f15.6)')
        widget_control, info.point_info, set_value=point_info_text        
    endif

endif

; If this is the second click of the make box sequence, go ahead and
; plot the box and it to the box array
if(widget_ev eq 'draw_widg' and info.plotted eq 1 and info.makebox eq 1 and info.firstclick eq 1) then begin
    if(event.type eq 0) then begin

        widget_control, info.draw_frame, get_value = winframe
        wset, winframe
; Make sure everything is plotted in the right coordinates
        !x.window = info.window_x 
        !x.s = info.s_x
        !y.window = info.window_y
        !y.s = info.s_y        
        !p.clip = info.clip

        info.firstclick = 0
        info.makebox = 0
        xy_upperright = convert_coord(event.x, event.y, /device, /to_data)
        info.upperright_x[info.numboxes] = xy_upperright[0]
        info.upperright_y[info.numboxes] = xy_upperright[1]

        last_boxnum = info.numboxes
        widget_control, info.drop, get_value = clusterboxlist_temp
        if(info.numboxes ne 0) then begin
            last_box = clusterboxlist_temp[n_elements(clusterboxlist_temp)-1] 
            last_boxnum = fix(strmid(last_box, 3,strlen(last_box)-1))
        endif
; Do the actual plotting
        oplot, [info.lowerleft_x[info.numboxes], info.upperright_x[info.numboxes], info.upperright_x[info.numboxes], $
                info.lowerleft_x[info.numboxes], info.lowerleft_x[info.numboxes]], $
          [info.lowerleft_y[info.numboxes], info.lowerleft_y[info.numboxes], info.upperright_y[info.numboxes], $
           info.upperright_y[info.numboxes], info.lowerleft_y[info.numboxes]], linestyle = 2, color = 100
        xyouts, (info.lowerleft_x[info.numboxes]-info.upperright_x[info.numboxes])/2.0+info.upperright_x[info.numboxes], $
          (info.upperright_y[info.numboxes]-info.lowerleft_y[info.numboxes])/2.0 +info.lowerleft_y[info.numboxes], strcompress(string(last_boxnum+1)),$
          charsize = 3, charthick = 2, color = 100, alignment = 0.5
        info.numboxes++

        if(clusterboxlist_temp[0] ne ' ') then begin
            clusterboxlist = [clusterboxlist_temp, 'Box' + strcompress(string(last_boxnum+1))]
        endif else begin 
            clusterboxlist = 'Box' + strcompress(string(last_boxnum+1))

            if(info.ngal ne 0) then begin
                nplotgals = 0
                r_cz = fltarr(1000)
                cz = fltarr(1000)
                for i = 0, info.ngal-1 do begin
                    if(info.xra[i] ge info.upperright_x[info.boxpic] and info.xra[i] le info.lowerleft_x[info.boxpic] $
                       and info.ydec[i] ge info.lowerleft_y[info.boxpic] and info.ydec[i] le info.upperright_y[info.boxpic]) then begin
                        r_cz[nplotgals] = cartes((info.lowerleft_x[info.boxpic]-info.upperright_x[info.boxpic])/float(2)+info.upperright_x[info.boxpic], info.xra[i], $
                                                 (info.upperright_y[info.boxpic]-info.lowerleft_y[info.boxpic])/float(2)+info.lowerleft_y[info.boxpic], info.ydec[i])
                        cz[nplotgals] = info.gvel[i]
                        nplotgals++
                    endif
                endfor
                
                widget_control, info.draw_cz, get_value = wincz
                wset, wincz
                if(nplotgals ge 1) then begin
                    max_cz = max(cz[0:nplotgals-1])
                    min_cz = min(cz[0:nplotgals-1])
                    max_r = max(r_cz[0:nplotgals-1])
                    min_r = min(r_cz[0:nplotgals-1])
                    
                    
                    plot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], /nodata, yrange = [min_cz-10000, max_cz+10000], ytitle = 'cz',$
                      xtitle = 'R from center of cluster, group or box', xstyle = 1, ystyle = 1, xrange = [min_r- 0.01, max_r+0.01], $
                      position=[0.18, 0.13, .95, 0.93]
                    oplot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], psym=1
                    
                    widget_control, info.draw_cz_hist, get_value = winczhist
                    wset, winczhist
                    binsize = (max_cz-min_cz)/(float(nplotgals)/float(4))
                    
                    if(n_elements(cz[0:nplotgals-1]) ge 2) then  begin 
                        plothist, cz[0:nplotgals-1], bin = binsize, xtitle = 'cz' 
                        
                        widget_control, info.bin_slider, SET_SLIDER_MAX = binsize+binsize*.8
                        widget_control, info.bin_slider, SET_SLIDER_MIN = binsize-binsize*.8
                        widget_control, info.bin_slider, set_value = binsize
                    endif else erase
                endif else begin
                    max_cz = cz[0]
                    min_cz = cz[0]
                    max_r = r_cz[0]
                    min_r = r_cz[0]
                endelse
                
                widget_control, info.cz_slider, set_value = 1
                
                info.galcz = cz
                info.nplotgals = nplotgals
                
            endif
        endelse
        
        widget_control, info.drop, set_value = clusterboxlist
        device, CURSOR_standard = 30

        savestateinfo, info, infoptr
    endif
endif  
; If this is the first click of the make box sequence store the
; coordinates of the first click
if(widget_ev eq 'draw_widg' and info.plotted eq 1 and info.makebox eq 1 and info.firstclick eq 0) then begin
    if(event.type eq 0) then begin
        
        widget_control, info.draw_frame, get_value = winframe
        wset, winframe
; Make sure everything is in the beginning coordinates
        !x.window = info.window_x
        !x.s = info.s_x
        !y.window = info.window_y
        !y.s = info.s_y
        !p.clip = info.clip
        
        info.firstclick = 1
        xy_lowerleft = convert_coord(event.x, event.y, /device, /to_data)
        info.lowerleft_x[info.numboxes] = xy_lowerleft[0]
        info.lowerleft_y[info.numboxes] = xy_lowerleft[1]
        
        savestateinfo, info, infoptr
        
    endif
endif



; If user uses menu with save option save plot to ps file
if(widget_ev eq 'fileopt1' and info.plotted eq 1) then begin
    filename_plot = dialog_pickfile(/write, group=event.top)
    if(filename_plot ne '') then begin
        filename_plot += '.ps'
        hard = 1
        plotframe, info.centra, info.centdec, info.ramin, info.ramax, info.decmin, info.decmax, info.nagc, info.xra, $
          info.ydec, info.gsize, info.gellip, info.gposang, info.gvel, info.ngal, info.r_clust, info.nclust, $
          info.xra_clust, info.ydec_clust, info.clust_velocity, hard, filename_plot, info.range, info.clust_id, $
          info.nogon, info.nnog, info.xra_nog, info.ydec_nog, info.nogvel, info.nognum, info.nog_rad
    endif 
    
endif

if(widget_ev eq 'catalogopt1') then begin

    if(info.plotted eq 1) then begin 
        widget_control, info.drop, get_value = clusterboxlist

        openr, noglun,agcdir+'nog.tab7', /get_lun
        openw, nog_radec_lun, 'nog.radec', /get_lun
        openw, nog_txt_lun, 'nog.txt', /get_lun

        ra = 0
        xra_nog = 0
        ydec_nog = 0
        dec = 0
        name = ''
        pnote = ''
        comname = ''
        p1name = '' 
        p2name = ''
        garcia = ''
        tully = ''
        nnog = 0
        nvhel = 0
        nognum = 0
        sgn = ''
        nog_rad = 0
        H0 = float(70)
        r_a = float(1.5)/float(0.7)

        if(info.nogon eq 0) then begin
            info.nogon = 1 
            widget_control, event.id, set_button = 1
            onedeg = !DTOR
            
            while((ra le info.ramax) and EOF(noglun) ne 1) do begin
                readf, noglun, IDNUM,PNOTE,NAME,NMEMB,irh,irm, $
                  rs,sgn,idd,idm,ids,ivel,comname,p1name,p2name,garcia,tully, $
                  format = '(i4,1x,a1,1x,a15,i3,2x,i2,1x,i2,1x,f4.1,2x, a1,i2,1x,i2,1x,i2,3x,i4,1x,a15,1x,a16,1x,a16,1x,a20,1x,a20)'
                
                cra = float(irh) + float(irm)/60 + rs/3600
                cdec= float(idd)+ float(idm)/60 + float(ids)/3600
                if(sgn eq '-') then cdec =- cdec
                cra = cra * 15
                jprecess, cra, cdec, ra, dec

                if(ra ge info.ramin and dec ge info.decmin and dec le info.decmax and nmemb ge 3) then begin 
                    irh = fix(ra/15)
                    irm = fix((ra/15-irh)*60)
                    rs = fix(((ra/15-irh)*60-irm)*600)/10.0
                    
                    idd = fix(dec)
                    idm = fix((dec-idd)*60)
                    ids = fix(((dec-idd)*60-idm)*60)
                    
                    glactc, ra, dec, 2000, gl, gb, 1, /degree
                    delv_yst = -79*cos(gl*onedeg)*cos(gb*onedeg) + 296*sin(gl*onedeg)*cos(gb*onedeg)- 36*sin(gb*onedeg)
                    vhel=float(ivel)-delv_yst

                    nvhel = [nvhel,fix(vhel)]
                    
                    nognum = [nognum, idnum]
                    xra_nog = [xra_nog,ra]
                    ydec_nog = [ydec_nog,dec]
                    
                    ;myflowmodelcall, ra, dec, 0, fix(vhel), 0, distance, d_err, flag
		    distance=fix(vhel)
                    nog_rad = [nog_rad, atan(r_a, distance/H0)*!radeg]

                    printf, nog_radec_lun, idnum,ra,dec, format = '(i4,2e18.10)'
                    printf, nog_txt_lun, idnum,PNOTE,NAME,NMEMB, irh,irm,rs,sgn,idd,idm,ids,fix(vhel),comname,p1name,$
                      p2name,garcia,tully, format = '(i4,1x,a1,1x,a15,i3,2x,i2,1x,i2,1x,f4.1,2x, a1,i2,1x,i2,1x,i2,3x,i4,1x,a15,1x,a16,1x,a16,1x,a20,1x,a20)'
                    nnog++
                endif 
                
            endwhile

            if(nnog ne 0) then begin
                nognum = nognum[1:*]
                xra_nog = xra_nog[1:*]
                ydec_nog = ydec_nog[1:*]
                nogvel = nvhel[1:*]
                nog_rad = nog_rad[1:*]
                info.nognum = nognum
                info.xra_nog = xra_nog
                info.ydec_nog = ydec_nog
                info.nogvel = nogvel
                info.nnog = nnog
                info.nog_rad = nog_rad
                widget_control, info.draw_frame, get_value = winframe
                wset, winframe
                
                plotframe, info.centra, info.centdec, info.ramin, info.ramax, info.decmin, info.decmax, info.nagc, info.xra, $
                  info.ydec, info.gsize, info.gellip, info.gposang, info.gvel, info.ngal, info.r_clust, info.nclust, $
                  info.xra_clust, info.ydec_clust, info.clust_velocity, 0, '', info.range, info.clust_id, $
                  info.nogon, info.nnog, info.xra_nog, info.ydec_nog, info.nogvel, info.nognum, info.nog_rad

                
                if(info.nclust ne 0 and info.numboxes ne 0) then begin
                    dropstring = [clusterboxlist[0:info.nclust-1], strcompress(string(info.nognum[0:info.nnog-1])), clusterboxlist[info.nclust:*]]
                endif else if(info.nclust ne 0 and info.numboxes eq 0) then begin
                    dropstring = [clusterboxlist, strcompress(string(info.nognum[0:info.nnog-1]))]
                endif else if(info.nclust eq 0 and info.numboxes eq 0 and info.nnog gt 0) then begin 
                    dropstring = strcompress(string(info.nognum[0:info.nnog-1]))
                endif else dropstring = [strcompress(string(info.nognum[0:info.nnog-1])), clusterboxlist]

                widget_control, info.drop, set_value = dropstring

                if(info.numboxes ne 0) then begin
                    widget_control, info.draw_frame, get_value = winframe
                    wset, winframe
                    clusterboxlist = dropstring
                    boxnum = clusterboxlist[info.nclust+info.nnog:n_elements(clusterboxlist)-1]
                    for i = 0, n_elements(boxnum)-1 do begin
                        oplot, [info.lowerleft_x[i], info.upperright_x[i], info.upperright_x[i], $
                                info.lowerleft_x[i], info.lowerleft_x[i]], $
                          [info.lowerleft_y[i], info.lowerleft_y[i], info.upperright_y[i], $
                           info.upperright_y[i], info.lowerleft_y[i]], linestyle = 2, color = 100
                        xyouts, (info.lowerleft_x[i]-info.upperright_x[i])/float(2) +info.upperright_x[i], $
                          (info.upperright_y[i]-info.lowerleft_y[i])/float(2) +info.lowerleft_y[i],$
                          strcompress(fix(strmid(clusterboxlist[i+info.nnog+info.nclust], 3,strlen(clusterboxlist[i+info.nnog+info.nclust])-1))),$
                          charsize = 3, charthick = 2, color = 100, alignment = 0.5 
                    endfor
                endif

                if(info.nclust eq 0) then begin

                    plothistandczr_nog, info.xra_nog, info.xra, info.ydec_nog, info.ydec, info.nog_rad, info.ngal, 0, info.gvel, $
                      info.nogvel, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
                    widget_control, info.cz_slider, set_value = 1
                    
                endif

            endif 
            

        endif else begin 
            info.nogon = 0
            
            widget_control, event.id, set_button = 0

            widget_control, info.draw_frame, get_value = winframe
            wset, winframe
            
            plotframe, info.centra, info.centdec, info.ramin, info.ramax, info.decmin, info.decmax, info.nagc, info.xra, $
              info.ydec, info.gsize, info.gellip, info.gposang, info.gvel, info.ngal, info.r_clust, info.nclust, $
              info.xra_clust, info.ydec_clust, info.clust_velocity, 0, '', info.range, info.clust_id, $
              info.nogon, info.nnog, info.xra_nog, info.ydec_nog, info.nogvel, info.nognum, info.nog_rad 
            
            dropstring = ' '
            if(info.nclust ne 0 and info.numboxes ne 0 and info.nnog ne 0) then begin
                dropstring = [clusterboxlist[0:info.nclust-1], clusterboxlist[info.nclust+info.nnog:*]]
            endif else if(info.nclust ne 0 and info.numboxes eq 0) then begin
                dropstring = clusterboxlist[0:info.nclust-1]
            endif else if (info.nclust eq 0 and info.nnog eq 0 and info.numboxes ne 0) then begin
                dropstring = clusterboxlist
            endif else if (info.nclust eq 0 and info.nnog ne 0 and info.numboxes ne 0) then begin
                dropstring = clusterboxlist[info.nnog:*]
            endif
            
            widget_control, info.drop, set_value = dropstring

            info.nnog = 0

            if(info.numboxes ne 0) then begin
                widget_control, info.draw_frame, get_value = winframe
                wset, winframe
                clusterboxlist = dropstring
                boxnum = clusterboxlist[info.nclust:n_elements(clusterboxlist)-1]
                for i = 0, n_elements(boxnum)-1 do begin
                    oplot, [info.lowerleft_x[i], info.upperright_x[i], info.upperright_x[i], $
                            info.lowerleft_x[i], info.lowerleft_x[i]], $
                      [info.lowerleft_y[i], info.lowerleft_y[i], info.upperright_y[i], $
                       info.upperright_y[i], info.lowerleft_y[i]], linestyle = 2, color = 100
                    xyouts, (info.lowerleft_x[i]-info.upperright_x[i])/float(2) +info.upperright_x[i], $
                      (info.upperright_y[i]-info.lowerleft_y[i])/float(2) +info.lowerleft_y[i], $
                      strcompress(fix(strmid(clusterboxlist[i+info.nnog+info.nclust], 3,strlen(clusterboxlist[i+info.nnog+info.nclust])-1))),$
                      charsize = 3, charthick = 2, color = 100, alignment = 0.5       
                endfor
            endif

            if(info.nclust eq 0) then begin
                widget_control, info.draw_cz, get_value = wincz
                wset, wincz
                erase
                widget_control, info.draw_cz_hist, get_value = winczhist
                wset, winczhist
                erase
                widget_control, info.bin_slider, SET_SLIDER_MAX = 100
                widget_control, info.bin_slider, SET_SLIDER_MIN = 1
                widget_control, info.bin_slider, set_value = 0
                czscale = 1
                widget_control, info.cz_slider, SET_SLIDER_MAX = 100
                widget_control, info.cz_slider, SET_SLIDER_MIN = 1
                widget_control, info.cz_slider, set_value = czscale

            endif else if(info.nclust ne 0 and info.ngal ne 0) then begin
                plothistandczr_cluster, info.xra_clust, info.xra, info.ydec_clust, info.ydec, info.r_clust, info.ngal, info.clustpic, info.gvel, $
                  info.clust_velocity, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
                widget_control, info.cz_slider, set_value = 1
                
            endif

            
        endelse

        close, noglun
        free_lun, noglun
        close, nog_radec_lun
        free_lun, nog_radec_lun
        close, nog_txt_lun
        free_lun, nog_txt_lun

    endif else begin
        if(info.nogon eq 0) then begin
            info.nogon = 1
            widget_control, event.id, set_button = 1
        endif else begin
            info.nogon = 0
            widget_control, event.id, set_button = 0
            
        endelse
    endelse
    savestateinfo, info, infoptr
endif


; If the user selects a different cluster or box from the droplist
; replot the cz vs r plot and the cz historgram
if(widget_ev eq 'drop') then begin
; If the user picked a cluster plot the cz vs r plot and cz histogram
; for that cluster
    widget_control, info.cz_slider, set_value = 1
    widget_control, info.cz_max_text, set_value = ' '
    widget_control, info.cz_min_text, set_value = ' '
    widget_control, info.cz_mean_text, set_value = ' '
    widget_control, info.cz_stdev_text, set_value = ' '

    if(event.index lt info.nclust) then begin
        info.clustpic = event.index

        if(info.nclust ne 0 and info.ngal ne 0) then begin
            H0 = float(70)
            r_a = float(1.5)/float(0.7)
            plothistandczr_cluster, info.xra_clust, info.xra, info.ydec_clust, info.ydec, info.r_clust, info.ngal, event.index, info.gvel, $
              info.clust_velocity, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
            widget_control, info.cz_slider, set_value = 1
        endif
    endif else if(event.index lt info.nnog+info.nclust and event.index ge info.nclust) then begin
        plothistandczr_nog, info.xra_nog, info.xra, info.ydec_nog, info.ydec, info.nog_rad, info.ngal, event.index-info.nclust, info.gvel, $
          info.nogvel, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
        widget_control, info.cz_slider, set_value = 1
    endif else begin
; If the user picked a box then plot the cz vs. r plot and cz
; histogram
        if(info.nogon eq 1) then begin
            info.boxpic = event.index-info.nclust-info.nnog
        endif else info.boxpic = event.index-info.nclust

        if(info.ngal ne 0) then begin
            nplotgals = 0
            r_cz = fltarr(1000)
            cz = fltarr(1000)
            for i = 0, info.ngal-1 do begin
                if(info.xra[i] ge info.upperright_x[info.boxpic] and info.xra[i] le info.lowerleft_x[info.boxpic] $
                   and info.ydec[i] ge info.lowerleft_y[info.boxpic] and info.ydec[i] le info.upperright_y[info.boxpic]) then begin
                    r_cz[nplotgals] = cartes((info.lowerleft_x[info.boxpic]-info.upperright_x[info.boxpic])/float(2)+info.upperright_x[info.boxpic], info.xra[i], $
                                             (info.upperright_y[info.boxpic]-info.lowerleft_y[info.boxpic])/float(2)+info.lowerleft_y[info.boxpic], info.ydec[i])
                    cz[nplotgals] = info.gvel[i]
                    nplotgals++
                endif
            endfor

            widget_control, info.draw_cz, get_value = wincz
            wset, wincz
            if(nplotgals ge 1) then begin
                max_cz = max(cz[0:nplotgals-1])
                min_cz = min(cz[0:nplotgals-1])
                max_r = max(r_cz[0:nplotgals-1])
                min_r = min(r_cz[0:nplotgals-1])
                

                plot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], /nodata, yrange = [min_cz-10000, max_cz+10000], ytitle = 'cz',$
                  xtitle = 'R from center of cluster, group or box', xstyle = 1, ystyle = 1, xrange = [min_r- 0.01, max_r+0.01], $
                  position=[0.18, 0.13, .95, 0.93]
                oplot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], psym=1
                
                widget_control, info.draw_cz_hist, get_value = winczhist
                wset, winczhist
                binsize = (max_cz-min_cz)/(float(nplotgals)/float(4))
                
                if(n_elements(cz[0:nplotgals-1]) ge 2) then  begin 
                    plothist, cz[0:nplotgals-1], bin = binsize, xtitle = 'cz' 
                    
                    widget_control, info.bin_slider, SET_SLIDER_MAX = binsize+binsize*.8
                    widget_control, info.bin_slider, SET_SLIDER_MIN = binsize-binsize*.8
                    widget_control, info.bin_slider, set_value = binsize
                endif else erase
            endif else begin
                max_cz = cz[0]
                min_cz = cz[0]
                max_r = r_cz[0]
                min_r = r_cz[0]
            endelse

            widget_control, info.cz_slider, set_value = 1

            info.galcz = cz
            info.nplotgals = nplotgals
            
            savestateinfo, info, infoptr
        endif
    endelse
endif

; Rebin the cz histogram according to the binslider value
if(widget_ev eq 'binslider' and info.plotted eq 1) then begin
    if((info.nnog ne 0 and info.nogon ne 0) or info.nclust ne 0 or info.numboxes ne 0) then begin
        widget_control, info.draw_cz_hist, get_value = winczhist
        wset, winczhist
        binsize = event.value
        if(info.nplotgals ge 2) then plothist, info.galcz[0:info.nplotgals-1], bin = binsize, xtitle = 'cz'
    endif
endif
; Print out the mean and std. dev for a certain range of cz
if(widget_ev eq 'cz_stats' and info.plotted eq 1 and ((info.nnog ne 0 and info.nogon ne 0) or info.nclust ne 0 or info.numboxes ne 0)) then begin
    czmin = '0'
    czmax = '0'
    widget_control, info.cz_min_text, get_value = czmin
    widget_control, info.cz_max_text, get_value = czmax

    czmin = czmin[0]
    czmax = czmax[0]

    if(isnumber(czmin) ne 0 and isnumber(czmax) ne 0) then begin
        if(float(czmax) gt float(czmin) and float(czmin) ge min(info.galcz) and float(czmax) le max(info.galcz)) then begin 
            czmin = float(czmin)
            czmax = float(czmax)
            cz_stats_arr = fltarr(1000)
            count = 0
            for i = 1, info.nplotgals-1 do begin
                if(info.galcz[i] le czmax and info.galcz[i] ge czmin) then begin
                    cz_stats_arr[count] = info.galcz[i]        
                    count++
                endif
            endfor
            if(count gt 1) then begin
                widget_control, info.cz_mean_text, set_value = strcompress(string(mean(cz_stats_arr[0:count-1])),/remove_all)
                widget_control, info.cz_stdev_text, set_value = strcompress(string(stddev(cz_stats_arr[0:count-1])),/remove_all)
            endif
        endif else a = dialog_message('Please enter a valid range', /error)
    endif else a = dialog_message('Please enter a valid range', /error)
endif
; Do the same as for the cz stats button as for the cz_max text box
if(widget_ev eq 'cz_max' and info.plotted eq 1 and ((info.nnog ne 0 and info.nogon ne 0) or info.nclust ne 0 or info.numboxes ne 0)) then begin
    czmin = '0'
    czmax = '0'
    widget_control, info.cz_min_text, get_value = czmin
    widget_control, info.cz_max_text, get_value = czmax

    czmin = czmin[0]
    czmax = czmax[0]

    if(isnumber(czmin) ne 0 and isnumber(czmax) ne 0 and float(czmax) gt float(czmin) and float(czmin) ge min(info.galcz) and float(czmax) le max(info.galcz)) then begin 
        czmin = float(czmin)
        czmax = float(czmax)
        cz_stats_arr = fltarr(1000)
        count = 0
        for i = 1, info.nplotgals-1 do begin
            if(info.galcz[i] le czmax and info.galcz[i] ge czmin) then begin
                cz_stats_arr[count] = info.galcz[i]        
                count++
            endif
        endfor
        if(count gt 1) then begin
            widget_control, info.cz_mean_text, set_value = strcompress(string(mean(cz_stats_arr[0:count-1])),/remove_all)
            widget_control, info.cz_stdev_text, set_value = strcompress(string(stddev(cz_stats_arr[0:count-1])),/remove_all)
        endif
    endif else a = dialog_message('Please enter a valid range', /error)

endif

; Replot the cz vs. r plot when the cz slider is moved to zoom into
; the cz vs. r plot
if(widget_ev eq 'czslider') then begin

    czscale = event.value

    if(info.nclust ne 0 and info.ngal ne 0) then begin
        plothistandczr_cluster, info.xra_clust, info.xra, info.ydec_clust, info.ydec, info.r_clust, info.ngal, info.clustpic, info.gvel, $
          info.clust_velocity, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, czscale, 1

    endif
    if(info.nnog ne 0 and info.nogon ne 0) then begin
        plothistandczr_nog, info.xra_nog, info.xra, info.ydec_nog, info.ydec, info.nog_rad, info.ngal, info.clustpic, info.gvel, $
          info.nogvel, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, czscale, 1
    endif
endif
; Get ready to do the make box sequence
if(widget_ev eq 'makebox') then begin
    if(info.numboxes lt 10) then begin
        info.makebox = 1
        device, CURSOR_standard = 36
        savestateinfo, info, infoptr
    endif else a = dialog_message('Maximum of 10 boxes', /error)
endif
; Delete all boxes by replotting everything and removing the box info
; from the info structure and removing the boxes from the droplist
if(widget_ev eq 'delete_all_boxes') then begin

    widget_control, info.draw_frame, get_value = winframe
    wset, winframe

    plotframe, info.centra, info.centdec, info.ramin, info.ramax, info.decmin, info.decmax, info.nagc, info.xra, $
      info.ydec, info.gsize, info.gellip, info.gposang, info.gvel, info.ngal, info.r_clust, info.nclust, $
      info.xra_clust, info.ydec_clust, info.clust_velocity, 0, '', info.range, info.clust_id, $
      info.nogon, info.nnog, info.xra_nog, info.ydec_nog, info.nogvel, info.nognum, info.nog_rad

    info.numboxes = 0
    clusterboxlist = [' ']

    if(info.nclust ne 0) then clusterboxlist = strcompress(info.clust_id[0:info.nclust-1])
    
    savestateinfo, info, infoptr            
    widget_control, info.drop, set_value = clusterboxlist
    if(info.nclust ne 0) then begin
        plothistandczr_cluster, info.xra_clust, info.xra, info.ydec_clust, info.ydec, info.r_clust, info.ngal, 0, info.gvel, $
          info.clust_velocity, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
    endif else begin
        widget_control, info.draw_cz_hist, get_value = winczhist
        wset, winczhist
        erase
        widget_control, info.draw_cz, get_value = wincz
        wset, wincz
        erase
    endelse 
endif
; Delete a box by replotting everything and removing the box info
; from the info structure and removing the boxes from the droplist
if(widget_ev eq 'delete_box' and info.numboxes ne 0) then begin
    
    if(info.boxpic ne 0) then begin
        info.upperright_x = [info.upperright_x[0:info.boxpic-1],info.upperright_x[info.boxpic+1:n_elements(info.upperright_x)-1]]
        info.upperright_y = [info.upperright_y[0:info.boxpic-1],info.upperright_y[info.boxpic+1:n_elements(info.upperright_y)-1]]
        info.lowerleft_x = [info.lowerleft_x[0:info.boxpic-1],info.lowerleft_x[info.boxpic+1:n_elements(info.lowerleft_x)-1]]
        info.lowerleft_y = [info.lowerleft_y[0:info.boxpic-1],info.lowerleft_y[info.boxpic+1:n_elements(info.lowerleft_y)-1]]
    endif else begin
        info.upperright_x = info.upperright_x[1:n_elements(info.upperright_x)-1]
        info.upperright_y = info.upperright_y[1:n_elements(info.upperright_y)-1]
        info.lowerleft_x = info.lowerleft_x[1:n_elements(info.lowerleft_x)-1]
        info.lowerleft_y = info.lowerleft_y[1:n_elements(info.lowerleft_y)-1]
    endelse

    widget_control, info.drop, get_value = clusterboxlist

    info.numboxes-- 

    widget_control, info.draw_frame, get_value = winframe
    wset, winframe
    
    plotframe, info.centra, info.centdec, info.ramin, info.ramax, info.decmin, info.decmax, info.nagc, info.xra, $
      info.ydec, info.gsize, info.gellip, info.gposang, info.gvel, info.ngal, info.r_clust, info.nclust, $
      info.xra_clust, info.ydec_clust, info.clust_velocity, 0, '', info.range, info.clust_id, $
      info.nogon, info.nnog, info.xra_nog, info.ydec_nog, info.nogvel, info.nognum, info.nog_rad

    if(info.boxpic eq 0 and (info.nclust+info.nnog eq 0 or (info.nclust eq 0 and info.nogon eq 0)) $
       and n_elements(clusterboxlist) gt 1) then begin
        clusterboxlist = clusterboxlist[1:*]
    endif else if((info.boxpic+info.nclust+info.nnog eq n_elements(clusterboxlist)-1 or (info.boxpic+info.nclust eq n_elements(clusterboxlist)-1 and info.nogon eq 0))$
                  and n_elements(clusterboxlist) gt 1) then begin
        clusterboxlist = clusterboxlist[0:n_elements(clusterboxlist)-2]
    endif else if ((info.nclust+info.nnog eq 0 or (info.nclust eq 0 and info.nogon eq 0)) and n_elements(clusterboxlist) le 1) then begin
        clusterboxlist = [' ']
    endif else begin
        if(info.nogon eq 0) then clusterboxlist = [clusterboxlist[0:info.nclust+info.boxpic-1],clusterboxlist[info.nclust+info.boxpic+1:*]]
        if(info.nogon eq 1) then clusterboxlist = [clusterboxlist[0:info.nclust+info.nnog+info.boxpic-1],clusterboxlist[info.nclust+info.boxpic+info.nnog+1:*]]
    endelse
    widget_control, info.drop, set_value = clusterboxlist 


    if(info.numboxes ne 0) then begin
        boxnum = clusterboxlist[info.nclust+info.nnog:n_elements(clusterboxlist)-1]
        for i = 0, n_elements(boxnum)-1 do begin
            oplot, [info.lowerleft_x[i], info.upperright_x[i], info.upperright_x[i], $
                    info.lowerleft_x[i], info.lowerleft_x[i]], $
              [info.lowerleft_y[i], info.lowerleft_y[i], info.upperright_y[i], $
               info.upperright_y[i], info.lowerleft_y[i]], linestyle = 2, color = 100
            xyouts, (info.lowerleft_x[i]-info.upperright_x[i])/float(2) +info.upperright_x[i], $
              (info.upperright_y[i]-info.lowerleft_y[i])/float(2) +info.lowerleft_y[i], $
              strcompress(fix(strmid(clusterboxlist[i+info.nnog+info.nclust], 3,strlen(clusterboxlist[i+info.nnog+info.nclust])-1))),$
              charsize = 3, charthick = 2, color = 100, alignment = 0.5            
        endfor

        if(info.nclust ne 0) then begin
            plothistandczr_cluster, info.xra_clust, info.xra, info.ydec_clust, info.ydec, info.r_clust, info.ngal, 0, info.gvel, $
              info.clust_velocity, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
        endif else if(info.nclust eq 0 and (info.nnog eq 0 or info.nogon eq 0) and info.numboxes gt 0) then begin

            if(info.boxpic eq 0) then info.boxpic = 1
            if(info.boxpic ne 0) then info.boxpic--
            if(info.ngal ne 0) then begin
                nplotgals = 0
                r_cz = fltarr(1000)
                cz = fltarr(1000)
                for i = 0, info.ngal-1 do begin
                    if(info.xra[i] ge info.upperright_x[info.boxpic] and info.xra[i] le info.lowerleft_x[info.boxpic] $
                       and info.ydec[i] ge info.lowerleft_y[info.boxpic] and info.ydec[i] le info.upperright_y[info.boxpic]) then begin
                        r_cz[nplotgals] = cartes((info.lowerleft_x[info.boxpic]-info.upperright_x[info.boxpic])/float(2)+info.upperright_x[info.boxpic], info.xra[i], $
                                                 (info.upperright_y[info.boxpic]-info.lowerleft_y[info.boxpic])/float(2)+info.lowerleft_y[info.boxpic], info.ydec[i])
                        cz[nplotgals] = info.gvel[i]
                        nplotgals++
                    endif
                endfor
                
                widget_control, info.draw_cz, get_value = wincz
                wset, wincz
                if(nplotgals ge 1) then begin
                    max_cz = max(cz[0:nplotgals-1])
                    min_cz = min(cz[0:nplotgals-1])
                    max_r = max(r_cz[0:nplotgals-1])
                    min_r = min(r_cz[0:nplotgals-1])
                    
                    
                    plot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], /nodata, yrange = [min_cz-10000, max_cz+10000], ytitle = 'cz',$
                      xtitle = 'R from center of cluster, group or box', xstyle = 1, ystyle = 1, xrange = [min_r- 0.01, max_r+0.01], $
                      position=[0.18, 0.13, .95, 0.93]
                    oplot, r_cz[0:nplotgals-1], cz[0:nplotgals-1], psym=1
                    
                    widget_control, info.draw_cz_hist, get_value = winczhist
                    wset, winczhist
                    binsize = (max_cz-min_cz)/(float(nplotgals)/float(4))
                    
                    if(n_elements(cz[0:nplotgals-1]) ge 2) then  begin 
                        plothist, cz[0:nplotgals-1], bin = binsize, xtitle = 'cz' 
                        
                        widget_control, info.bin_slider, SET_SLIDER_MAX = binsize+binsize*.8
                        widget_control, info.bin_slider, SET_SLIDER_MIN = binsize-binsize*.8
                        widget_control, info.bin_slider, set_value = binsize
                    endif else erase
                endif else begin
                    max_cz = cz[0]
                    min_cz = cz[0]
                    max_r = r_cz[0]
                    min_r = r_cz[0]
                endelse
                
                widget_control, info.cz_slider, set_value = 1
                
                info.galcz = cz
                info.nplotgals = nplotgals
                
            endif 
            
        endif else if(info.nclust eq 0 and info.nnog ne 0 and info.nogon) then begin
            plothistandczr_nog, info.xra_nog, info.xra, info.ydec_nog, info.ydec, info.nog_rad, info.ngal, 0, info.gvel, $
              info.nogvel, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
        endif else begin
            widget_control, info.draw_cz_hist, get_value = winczhist
            wset, winczhist
            erase
            widget_control, info.draw_cz, get_value = wincz
            wset, wincz
            erase
        endelse
    endif else if(info.nclust ne 0) then begin
        plothistandczr_cluster, info.xra_clust, info.xra, info.ydec_clust, info.ydec, info.r_clust, info.ngal, 0, info.gvel, $
          info.clust_velocity, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
    endif else if(info.nclust eq 0 and info.nnog ne 0 and info.nogon) then begin
        plothistandczr_nog, info.xra_nog, info.xra, info.ydec_nog, info.ydec, info.nog_rad, info.ngal, 0, info.gvel, $
          info.nogvel, info.draw_cz, info.draw_cz_hist, info.point_info, info.bin_slider, info, infoptr, 1, 0
    endif else begin
        widget_control, info.draw_cz_hist, get_value = winczhist
        wset, winczhist
        erase
        widget_control, info.draw_cz, get_value = wincz
        wset, wincz
        erase
    endelse

    

    info.boxpic = 0
    savestateinfo, info, infoptr 
endif 

if(widget_ev eq 'helpquickstart') then begin
    h=['Plotcluster Quickstart',$
       'A sanctioned product of LOVEDATA, Inc. Ithaca, NY',$
       'CONTENTS',$
       '',$
       '    * Overview',$
       '    * Menu Options',$
       '    * Coordinates Text Box', $
       '    * Range Text Box', $
       '    * Main Window',$
       '    * cz vs. R Window',$
       '    * cz Histogram Window',$
       '    * Information Display',$
       '    * Bounds Text Box',$
       '    * Galaxies Text Box',$
       '    * Clusters Text Box',$
       '    * Bin Size Slider',$
       '    * cz Slider',$
       '    * cz Min and Max Text Boxes',$
       '    * Make Box, Delete Selected Box and Delete All Boxes buttons',$
       '',$
       'Plotcluster displays a widget ', $
       'where the user can input coordinates and the size of the box ', $
       'that the user wants to view. Plotcluster will plot all ', $
       'galaxies, clusters and NOG groups (if NOG option is turned on) in ', $
       'the user specified region. If a cluster or NOG group is in the ', $
       'region a cz vs. R plot is made of all the galaxies inside the ', $
       'NOG group or cluster radius. A cz historgram is also made of all the ', $
       'galaxies in the cluster or NOG group radius. The user can also ', $
       'specify a box of which a cz vs. R plot and a cz historgram are made. ', $
       'The user can also specify a cz range of which he wants a mean and standard ', $
       'deviation.', $
       '',$
       '',$
       'Menu Options',$
       'File 	',$
       '',$
       '    * Save Postscript - Save current plot to a postscript file',$
       '',$
       'Load Catalog 	',$
       '',$
       '    * NOG - Load and enable the NOG catalog',$
       '',$
       'Help 	',$
       '',$
       '    * Quickstart - Text version of this guide.',$
       '    * About - Information, update information, and modification history.',$
       '',$
       '',$
       'Coordinates Text Box',$
       'The coordinate text box takes the coordinates to plot in hhmmsss+ddmmss. ', $
       '',$
       'Range Text Box',$
       'The range text box takes the range to plot in degrees. The max is 10 degrees ', $
       'and the min is 0.5 degrees. The default is 2.4 degrees. ', $
       '',$
       'Main Window',$
       'The main window displays a plot of the user specified coordinates and range. ', $
       'In this plot any AGC galaxies, clusters and NOG groups (if enabled) are plotted ', $
       'and colored according to their redshifts. A color bar indiciates what colors ', $
       'correspond to what redshifts. ', $
       '',$
       'cz vs. R Window',$
       'This window is located on the right upper part of the widget. It displays ',$
       'a plot of the cz of all the galaxies in selected cluster, NOG group or box versus ', $
       'the distance of the galaxies from the center of the cluster, NOG group or box. ', $
       'The dotted line indicates the cz of the cluster or NOG group. ', $
       '',$
       'cz Histogram Window',$
       'The cz histogram window is located directly below the cz vs. R window. It displays ',$
       'a histogram of the cz of all the galaxies inside the selected cluster, ', $
       'NOG group or box. ', $
       '',$
       'Information Display',$
       'This text box below the main window at the bottom of the widget displays the ',$
       'coordinates of the point clicked on in the main window. If AGC galaxy, ', $
       'cluster center or NOG group center is clicked on the information display ', $
       'shows information about the object. ', $
       '',$
       'Bounds Text Box',$
       'This text box indicates the bounds that apply to the current main window ',$
       'display size (set by the box size text box). ', $ 
       '',$
       'Galaxies Text Box',$
       'The galaxies text box displays how many AGC galaxies were found in the current ',$
       'range. ', $
       '',$ 
       'Clusters Text Box',$
       'The clusters text box displays how many AGC clusters were found in the current ',$
       'range. ', $
       '',$
       'Clusters droplist',$
       'This droplist lets the user specify for which cluster, NOG group or box the ',$
       'cz vs. R plot and cz histogram are displayed. ', $
       '',$
       'Bin Size Slider',$
       'The bin size slider lets the user replot the cz histogram with a different binsize.', $
       '',$
       'cz Slider',$
       'This slider allows the user to zoom into the cz vs R plot with the cluster cz ', $
       'being the center of the zoom. The cz slider will not work with these boxes ', $
       'because there is nothing to center the zoom on. ', $
       '',$
       'cz Min and Max Text Boxes',$
       'These text boxes lets the user enter a cz range of which the mean and standard deviation ', $
       'are printed in the cz mean and cz standard dev. text boxes. ', $
       '',$
       'Make Box, Delete Selected Box and Delete All Boxes buttons',$
       'These buttons let the user make and delete boxes to get user defined cz vs R plots and  ', $
       'cz histograms. The boxes must be made by first clicking where the lower left corner of the ', $
       'box should be and then where the upper right corner of the box should be. ', $
       'The cz slider will not work with these boxes because there is nothing ', $
       'to center the zoom on. ', $
       '',$
       'Walter Hopkins, Rochester Institute of Technology.']


    if (not (xregistered('plotcluster_quickstart', /noshow))) then begin

        helptitle = strcompress('Plotcluster Quickstart')

        help_base =  widget_base(group_leader = info.tlb, $
                                 /column, /base_align_right, title = helptitle, $
                                 uvalue = 'help_base')

        help_text = widget_text(help_base, /scroll, value = h, xsize = 90, ysize = 50)
        
        help_done = widget_button(help_base, value = ' Done ', uvalue = 'quickstart_done')

        widget_control, help_base, /realize
        xmanager, 'plotcluster_quickstart', help_base, /no_block
        
    endif
endif

if(widget_ev eq 'helpabout') then begin
h=['Plotcluster        ', $
   'Written, July 2006', $
   ' ', $
   'Last update, Thursday, July 20, 2006']


if (not (xregistered('plotcluster_help', /noshow))) then begin

helptitle = strcompress('Plotcluster HELP')

    help_base =  widget_base(group_leader = info.tlb, $
                             /column, /base_align_right, title = helptitle, $
                             uvalue = 'help_base')

    help_text = widget_text(help_base, /scroll, value = h, xsize = 85, ysize = 15)
    
    help_done = widget_button(help_base, value = ' Done ', uvalue = 'help_done')

    widget_control, help_base, /realize
    xmanager, 'plotcluster_help', help_base, /no_block
    
endif
endif

end

pro plotcluster_quickstart_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'quickstart_done': widget_control, event.top, /destroy
    else:
endcase

end

pro plotcluster_help_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'help_done': widget_control, event.top, /destroy
    else:
endcase

end

PRO PLOTCLUSTER

; Set up the GUI

; Set up main widget
tlb = widget_base(mbar = mbar, column = 1, title = 'Plot Cluster', tlb_frame_attr=1)
main = widget_base(tlb, row = 1)

; Set up menu
filemenu = widget_button(mbar, value = 'File')
fileopt1 = widget_button(filemenu, value = 'Save Postscript... ', /separator, uvalue = 'fileopt1')

catmenu = widget_button(mbar, value = 'Load Catalog')
catopt1 = widget_button(catmenu, value = 'NOG', /separator, uvalue = 'catalogopt1', /checked_menu)

helpmenu = widget_button(mbar, value = 'Help')
helpopt1 = widget_button(helpmenu, value = 'Quickstart', uvalue = 'helpquickstart')
helpopt2 = widget_button(helpmenu, value = 'About', uvalue = 'helpabout')
; Set up widget used for plotting
draw_main = widget_base(main, column = 1, /base_align_top)
draw_frame = widget_draw(draw_main, xsize = 550, ysize = 500, uvalue = 'draw_widg', /button_events)

cz_main = widget_base(main, column = 1, /base_align_top)
draw_cz = widget_draw(cz_main, xsize = 350, ysize = 200, uvalue = 'draw_widg_cz')
draw_cz_hist = widget_draw(cz_main, xsize = 350, ysize = 200, uvalue = 'draw_widg_cz_hist')
selection_main = widget_base(cz_main, row = 1, /base_align_center, /grid_layout, space = 10)
selections = ['']
drop = widget_droplist(selection_main, value=selections, title='Clusters', /DYNAMIC_RESIZE, /SENSITIVE, uvalue = 'drop')
bin_slider = widget_slider(selection_main, value = 0, xsize = 100, title = 'Bin size', uvalue='binslider')

cz_slider = widget_slider(cz_main, value = 0, xsize = 100, title = 'cz range', uvalue='czslider')

cz_range_main = widget_base(cz_main, column = 1, /base_align_left)
cz_range_input_main = widget_base(cz_range_main, row = 1, /base_align_center, space = 10)

cz_min_main = widget_base(cz_range_input_main, row = 1, /base_align_center)
cz_min_label = widget_label(cz_min_main, value = 'Minimum cz:')
cz_min_text = widget_text(cz_min_main, value = '', xsize = 10, /editable, uvalue = 'cz_min')

cz_max_main = widget_base(cz_range_input_main, row = 1, /base_align_center)
cz_max_label = widget_label(cz_max_main, value = 'Maximum cz:')
cz_max_text = widget_text(cz_max_main, value = '', xsize = 10, /editable, uvalue = 'cz_max')

cz_stats_button = widget_button(cz_range_main, value = 'Get cz stats', uvalue = 'cz_stats')

cz_output_main = widget_base(cz_range_main, row = 1, /base_align_center, space = 10)

cz_mean_main = widget_base(cz_output_main, row = 1, /base_align_center)
cz_mean_label = widget_label(cz_mean_main, value = 'Mean cz:')
cz_mean_text = widget_text(cz_mean_main, value = '', xsize = 8)

cz_stdev_main = widget_base(cz_output_main, row = 1, /base_align_center)
cz_stdev_label = widget_label(cz_stdev_main, value = 'Standard Dev. of cz:')
cz_stdev_text = widget_text(cz_stdev_main, value = '', xsize = 8)

box_main = widget_base(cz_range_main, row = 1, /base_align_center)
make_box_button = widget_button(box_main, value = 'Make box', uvalue = 'makebox')
delete_boxe_button = widget_button(box_main, value = 'Delete selected box', uvalue = 'delete_box')
delete_all_boxes_button = widget_button(box_main, value = 'Delete all boxes', uvalue = 'delete_all_boxes')

device, retain = 2

; Set up input text widgets and plot button
below_plot_base = widget_base(draw_main, row = 1, /base_align_center)

text_button_base = widget_base(below_plot_base, column = 1, /base_align_left)

text_base = widget_base(text_button_base, row = 2, /base_align_center)
coords_label = widget_label(text_base, value = 'Enter Coordinates:')
coords_text = widget_text(text_base, value = '', /editable, uvalue = 'coords_text', xsize = 15)
range_label = widget_label(text_base, value = 'Enter Box Size (max is 10):')
range_text = widget_text(text_base, value = '', /editable, xsize = 4, uvalue = 'range_text')

button_base = widget_base(text_button_base, row = 1, /grid_layout, /base_align_left)
plot_button = widget_button(button_base, value = 'Plot', uvalue = 'Plot')

gals_bounds_base = widget_base(below_plot_base, column = 1, /base_align_left)

bounds_base = widget_base(gals_bounds_base, row = 1, /base_align_left)
boundaries_label =  widget_label(bounds_base, value = 'Bounds:')
boundaries_text =  widget_text(bounds_base, value = '', xsize = 35)

gals_base = widget_base(gals_bounds_base, row = 1, /base_align_left)
gals_label = widget_label(gals_base, value = 'Galaxies:')
gals_text = widget_text(gals_base, value = '', xsize = 8)

clusts_base = widget_base(gals_bounds_base, row = 1, /base_align_left)
clust_label = widget_label(clusts_base, value = 'Clusters:')
clust_text = widget_text(clusts_base, value = '', xsize = 5)

; Set up widgets that display plot info
info_base = widget_base(draw_main, row = 2)
point_label = widget_label(info_base, value = 'Click to get coordinate info')
point_info = widget_text(info_base, value = '', xsize = 90, uvalue = 'info_label')

; Realize widgets
widget_control, tlb, /realize 

; Set up info that needs to be retrieved from events
widg_info = {coords_text:coords_text, range_text:range_text, coords:'', range:0.5, xc:0L, yc:0L, point_info:point_info, centra:float(0), centdec:float(0), $
             ramin:float(0), ramax:float(0), decmin:float(0),decmax:float(0), nagc:intarr(150000), xra:fltarr(150000), ydec:fltarr(150000), gsize:fltarr(150000), $
             gellip:fltarr(150000), gposang:fltarr(150000), gvel:fltarr(150000), ngal:0, coords_plot: 0, boundaries_text:boundaries_text,plotted:0,gals_text:gals_text,$
             clust_text:clust_text,draw_frame:draw_frame, draw_cz:draw_cz, draw_cz_hist:draw_cz_hist, clust_id:strarr(10000), drop:drop, galcz:fltarr(10000), nclust:0, $
             xra_clust:fltarr(10000), ydec_clust:fltarr(10000), clust_velocity:fltarr(10000), r_clust:fltarr(10000), bin_slider:bin_slider, nplotgals:0, $
             cz_stdev_text:cz_stdev_text, cz_mean_text:cz_mean_text, cz_min_text:cz_min_text, cz_max_text:cz_max_text, cz_slider:cz_slider, clustpic:0, makebox:0, $
             firstclick:0, upperright_x:fltarr(100), upperright_y:fltarr(100), lowerleft_x:fltarr(100), lowerleft_y:fltarr(100), clip:fltarr(6), $
             s_x:fltarr(2), s_y:fltarr(2), window_x:fltarr(2), window_y:fltarr(2), numboxes:0, boxpic:0, nogon:0, nognum:intarr(1000), xra_nog:fltarr(1000), $
             ydec_nog:fltarr(1000), nogvel:fltarr(1000), nnog:0, nog_rad:fltarr(1000), tlb:tlb}
widg_infoptr = ptr_new(widg_info)
widget_control, tlb, set_uvalue = widg_infoptr

; Start xmanager to look for events
xmanager, 'plotcluster', tlb, /no_block

end
