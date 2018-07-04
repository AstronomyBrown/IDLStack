
pro bkellipse, rmax, rmin, xc, yc, pos_ang, color, DATA = data, THICK = thick, $
	NPOINTS = npoints, COLOR = thecolor, LINESTYLE = linestyle, xprime=xprime, $
        yprime=yprime
;+
; NAME:
;      TVELLIPSE
;
; PURPOSE:
;      Draw an ellipse on the current graphics device.
;
; CALLING SEQUENCE:
;      TVELLIPSE, rmax, rmin, xc, yc, [ pos_ang, color, COLOR= ,/DATA, NPOINTS=
;                                        LINESTYLE=, THICK = 
; INPUTS:
;       RMAX,RMIN - Scalars giving the major and minor axis of the ellipse
; OPTIONAL INPUTS:
;       XC,YC - Scalars giving the position on the TV of the ellipse center
;               If not supplied (or if XC, YC are negative and /DATA is not set), 
;               and an interactive graphics device (e.g. not postscript) is set,
;               then the user will be prompted for X,Y
;       POS_ANG - Position angle of the major axis, measured counter-clockwise
;                 from the X axis.  Default is 0.
;       COLOR - Scalar  giving intensity level to draw ellipse.   The color
;               can be specified either with either this parameter or with the 
;               COLOR keyword.   Default is !P.COLOR
;
; OPTIONAL KEYWORD INPUT:
;        COLOR - Intensity value used to draw the circle, overrides parameter
;               value.  Default = !P.COLOR
;        /DATA - if this keyword is set and non-zero, then the ellipse radii and
;               X,Y position center are interpreted as being in DATA 
;               coordinates.   Note that the data coordinates must have been 
;               previously defined (with a PLOT or CONTOUR call).
;        THICK - Thickness of the drawn ellipse, default = !P.THICK
;        LINESTLYLE - Linestyle used to draw ellipse, default = !P.LINESTYLE
;        NPOINTS - Number of points to connect to draw ellipse, default = 120
;                  Increase this value to improve smoothness
; RESTRICTIONS:
;        TVELLIPSE does not check whether the ellipse is within the boundaries
;        of the window.
;
;        The ellipse is evaluated at NPOINTS (default = 120) points and 
;        connected by straight lines, rather than using the more sophisticated 
;        algorithm used by TVCIRCLE
;
;        TVELLIPSE does not accept normalized coordinates.
;
;        TVELLIPSE is not vectorized; it only draws one ellipse at a time
; EXAMPLE:
;        Draw an ellipse of major axis 50 pixels, minor axis 30 pixels, centered
;        on (250,100), with the major axis inclined 25 degrees counter-clockwise
;        from the X axis.   Use a double thickness line and device coordinates 
;        (default)
;
;	IDL> tvellipse,50,30,250,100,25,thick=2
; NOTES:
;        Note that the position angle for TVELLIPSE (counter-clockwise from the
;        X axis) differs from the astronomical position angle (counter-clockwise
;        from the Y axis). 
;
; REVISION HISTORY:
;        MODIFIED By Brian Kent, Cornell University, February 2006
;                -Used to return prime variables to hvccat.pro for flagbb.pro
;        Written  W. Landsman STX          July, 1989            
;        Converted to use with a workstation.  M. Greason, STX, June 1990
;        LINESTYLE keyword, evaluate at 120 points,  W. Landsman HSTX Nov 1995
;        Added NPOINTS keyword, fixed /DATA keyword W. Landsman HSTX Jan 1996
;        Check for reversed /DATA coordinates  P. Mangiafico, W.Landsman May 1996
;        Converted to IDL V5.0   W. Landsman   September 1997
;        Work correctly when X & Y data scales are unequal  December 1998
;        Removed cursor input when -ve coords are entered with /data 
;        keyword set  P. Maxted, Keele, 2002
;-
 On_error,2                              ;Return to caller

 if N_params() lt 2 then begin
   print,'Syntax - TVELLIPSE, rmax, rmin, xc, yc,[ pos_ang, color, COLOR = '
   print,'                         NPOINTS =, LINESTYLE = ,THICK=, /DATA ]'
   return
 endif

 if N_params() lt 4 then $
       cursor, xc, yc, /DEVICE, /NOWAIT      ;Get unroamed,unzoomed coordinates

 if ( (xc LT 0) or (yc LT 0)) and not(keyword_set(data)) then begin
       message,'Position cursor in window ' + strtrim(!D.WINDOW,2) + $
              ' -- then hit mouse button',/INF
       cursor, xc, yc, /DEVICE, /WAIT
         message,'Ellipse is centered at (' + strtrim(xc,2) + ',' + $
		strtrim(yc,2) + ')',/INF
 endif

 if N_params() LT 5 then pos_ang = 0.    ;Default position angle
  if N_Elements(TheColor) EQ 0 then begin
      IF N_Elements( Color ) eq 0 THEN Color = !P.COLOR
  endif else color = TheColor

 if not keyword_set(THICK) then thick = !P.THICK
 if not keyword_set(LINESTYLE) then linestyle = !P.LINESTYLE
 if not keyword_set(NPOINTS) then npoints = 120   ;Number of points to connect
 phi = 2*!pi*(findgen(npoints)/(npoints-1))       ;Divide circle into Npoints
 ang = pos_ang/!RADEG               	          ;Position angle in radians
 cosang = cos(ang)
 sinang = sin(ang)

 x =  rmax*cos(phi)              ;Parameterized equation of ellipse
 y =  rmin*sin(phi)

 xprime = xc + x*cosang - y*sinang   	;Rotate to desired position angle
 yprime = yc + x*sinang + y*cosang

 ;if keyword_set(data) then $
 ;plots, xprime, yprime, /DATA, COLOR=color, THICK=thick, LINESTYLE=linestyle $
 ;else $
 ;plots, round(xprime), round(yprime), $
 ;       /DEVICE, COLOR=color, THICK=thick, LINESTYLE=linestyle

 return
 end

;---------------------------------------------------------------
;+
; NAME:
;      HVCCAT
; PURPOSE:
;       Display for High-velocity cloud catalogs
;
; EXPLANATION:
;
;   Simple procedure that displays an AITOFF projection of HVCs
;     from the catalog of de Heij, Braun, and Burton 2002.  Ellipses
;     are displayed and color coded by vLSR.  The program can be used
;     stand alone or in conjunction with FLAGBB.
;
;
; CALLING SEQUENCE:
;       hvccat, rahr, decdeg, windowid=windowid
;
; INPUTS:
;       rahr - RA in decimal hours
;       decdeg - DEC in decimal degrees
;
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;    windowid - window id is passed out of the program so that the
;               window may be closed (ie in flagbb.pro)
;          
;
; OUTPUTS:
;       none
;
;
; RESTRICTIONS:
;
;     Only plots dBB catalog
;
; EXAMPLE:
;
;       hvccat, 12.4.20.4, windowid=windowid
;
; PROCEDURES USED:
;         BKELLIPSE (modified from TVELLIPSE
;         
;
;
;
; MODIFICATION HISTORY:
;       WRITTEN, Brian Kent, Cornell U., January 31, 2006
;
;
;----------------------------------------------------------

pro hvccat, rahr, decdeg, windowid=windowid

if N_params() lt 2 then begin
   print,'Syntax - HVCCAT, rahr, decdeg, windowid=windowid'
   print,'                   rahr in decimal hours, decdeg in decimal degrees]'
   return
 endif



window, /free, retain=2, xsize=1100,ysize=900
!p.multi=0

windowid=!d.window

common agcshare, agcdir
restore, agcdir+'dhbb.sav'

;window, /free, retain=2, xsize=1100, ysize=900

glactc, rahr, decdeg, 2000,lmapcenter, bmapcenter, 1
aitoff, lmapcenter,bmapcenter,xcenter,ycenter
xmin=xcenter-10
xmax=xcenter+10
ymin=ycenter-10
ymax=ycenter+10


hor, xmin,xmax
ver, ymin,ymax


loadct, 0, /silent
plot, [0,0], xtitle='GAL long', ytitle='GAL lat', /nodata,xstyle=4, ystyle=4, position=[0.06,0.1,0.8,0.9]

loadct, 34, /silent

for i=0, n_elements(dhbb)-1 do begin



if(dhbb[i].maj le 50) then begin
rmax=dhbb[i].maj
rmin=dhbb[i].min
xc=dhbb[i]._raj2000
yc=dhbb[i]._dej2000
pos_ang=dhbb[i].PALB

size=3
plotpoint=dblarr(1,120)+dhbb[i].lrv
min=-400
max=300


newplotpoint=bytscl(plotpoint, min=min, max=max)


glactc, xc/15.0, yc, 2000, l,b,1

resultcoords=convert_coord(dhbb[i]._raj2000/15.0, dhbb[i]._dej2000, /data, /double, /to_device)

bkellipse, rmax, rmin, l, b, pos_ang, /data, xprime=xprime, yprime=yprime, npoints=200

glactc, rax,decy, 2000, xprime,yprime,2




aitoff, xprime,yprime,x,y   ;xprime and yprime are ellipse points in galactic l,b

oplot, x,y, color=newplotpoint[0], psym=6, symsize=0.4, thick=2.0


endif

endfor


;Aitoff_grid
loadct, 0
aitoff_grid, 20,5, color=100


;Label longitude in a reasonable way
l_label_coords=[0,20,40,60,80,$
              100,120,140,160,180,$
              200,220,240,260,$
              280,300,320,340]
b_label_coords=[-70,-50,-10,10,30,50,70]

for i=0,n_elements(b_label_coords)-1 do begin
   for j=0,n_elements(l_label_coords)-1 do begin

       label='l='+strcompress(l_label_coords[j], /remove_all)
       aitoff, l_label_coords[j], b_label_coords[i], x,y
       xyouts, x+0.3, y+0.3, label


   endfor
endfor

;Label latitude in a reasonable way

if (xmin lt 0) then begin
  latitudemin=xmin+360
endif else begin
  latitudemin=xmin
endelse

b_label_coords=[-70,-65,-60,-55,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,5,10,15,20,25,30,35,40,45,50,55,60,65,70]
for i=0,n_elements(b_label_coords)-1 do begin



   label='b='+strcompress(b_label_coords[i], /remove_all)
   aitoff, latitudemin, b_label_coords[i], x,y
   resultcoords=convert_coord(x, y, /data, /double, /to_device)
   xyouts, resultcoords[0], resultcoords[1], label, /device

endfor


xyouts, 425, 30, 'Galactic Longitude', /device,charsize=2.0
xyouts, 30, 500, 'Galactic Latitude', /device, orientation=90, charsize=2.0





loadct, 34
Colorbar, range=[min,max],vertical=1, position=[0.90,0.1,0.95,0.95], ytitle=' V LSR', ticklen=-0.05, charsize=2.0
loadct, 0

end
