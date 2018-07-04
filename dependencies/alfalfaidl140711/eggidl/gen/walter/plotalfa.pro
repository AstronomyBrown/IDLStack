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
; CALLING SEQUENCE:
;       PRINTAGCINFO, XCURS, YCURS, FOUNDFLAG, OUTPUTSTR
;
; INPUTS:
;       XCURS - X position of the cursor 
;       YCURS - Y position of the cursor
;
; OUTPUTS:
;       FOUNDFLAG - If there are no agc galaxies in the position
;                        this is set to 0 else 1.
;       OUTPUTSTR - The string containing the agc info of the agc
;                      galaxy
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated to idl by
;       W.H. during summer 2006
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
      format = '(I6,A1,A8,1x,2I2.2,I3.3,A1,3I2.2,I5,2I4,i6,2x,I5,I3,2x,I5,I4,I5,I4,1x,A4,A1,i1,I2,2i3,i5,2i3)'

    rahours = float(rah) + float(ram)/60 + float(ras10)/36000
    ra=rahours*15
    dec= float(decd)+ float(decm)/60 + float(decs)/3600

    if(sign eq '-') then dec = -dec
    if((abs(ra-xcurs) lt 0.02  and  abs(dec-ycurs) lt 0.05)) then begin

        outputstr = string(AGCNUMBER,WHICH,NGCIC,RAH,RAM,RAS10,SIGN,DECD,DECM,$
          DECS,A100,B100,MAG10,BSTEINTYPE,VOPT,VSOURCE,FLUX100,RMS100,$
          V21,WIDTH,WIDTHCODE,TELCODE,DETCODE,HISOURCE,$
          IBANDQUAL,IBANDSRC,POSANG,IPOSITION,ipalomar,$
          format = '(I6,A1,A8,1x,2I2.2,I3.3,A1,3I2.2,I5,2I4,i6,2x,I5,I3,2x,I5,I4,I5,I4,1x,A4,A1,i1,I2,2i3,i5,2i3)')
        foundflag = 1
    endif
endwhile
close, gals_txt_lun
free_lun, gals_txt_lun
end

;-------------------------------------------------------------
;+
; NAME:
;       ALFABEAMS
; PURPOSE:
;       Returns an array with the alfa beam coordinates
; EXPLANATION:
;       Arrays are created that outline the alfa beams and their
;       tracks depending whether the beams are pointed towards the 
;       north or south.
;
; CALLING SEQUENCE:
;       ALFABEAMS, NBEAM, CENTRA, CENTDEC, DECTRACK, X, Y, XCENT_LABEL, YCENT_LABEL
;
; INPUTS:
;       NBEAM - Which beam to plot  
;       CENTRA - The center R.A.
;       CENTDEC - The center dec
;
;
; OUTPUTS:
;       X - The array with the x positions of the beam (this is to
;           plot the beam circle)
;       Y - The array with the y positions of the beam (this is to
;           plot the beam circle)
;       XCENT_LABEL - X coordinate of the center of the circle where the label should be
;                     printed
;       YCENT_LABEL - Y coordinate of the center of the circle where
;                     the label (number) of the beam should be printed
;       DECTRACK - Y coordinates of the dec of the track (which is at
;                  the center of the beam)
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated to idl by
;       W.H. during summer 2006
;-
;-------------------------------------------------------------
PRO ALFABEAMS, NBEAM, CENTRA, CENTDEC, DECTRACK, X, Y, XCENT_LABEL, YCENT_LABEL
;
; Finds
;
; Input:   centra and centdec in degrees
;          apply cosine for center dec
; Output:  x1,x2 in degrees
;
x = fltarr(1000)
y = fltarr(1000)
beamra = fltarr(7)
beamdec = fltarr(7)
beamaz0 = fltarr(7)
beamza0 = fltarr(7)
beamaz19 = fltarr(7)
beamza19 = fltarr(7)
;
; assume offset is 2.1 arcmin + 128"
;        beamsize is 186" x 210" so use r=105"
;        PA from north is 64.6deg;  rotation is 22 deg CW
;        spacing to furthest beam is 371"
;
degrad=57.29578 
scale=1.0 
offset=128
avefwhm=190
;    ignore ellipticity, so theta = 60deg
;
; These in pixel units from beammap, assuming 22deg rotation
; Need to scale to arcsec using setting "pixel"
;
;      data beamra/0.0,24.0,26.0,2.2,-24.0,-26.0,-2.2/
;     data beamdec/0.0,21.6,-10.5,-32.1,-21.6,10.5,32.1/

;    data beamra/0.0,-321.0,-400.2,-82.5,315.7,403.5,84.4/
;     data beamdec/0.0,251.4,-124.2,-375.1,-253.1,121.3,375.1/

;     data beamra/0.0,-282.46,-352.55,-72.73,278.17,355.19,74.267/
;     data beamdec/0.0,251.43,-124.21,-375.06,-253.15,121.34,375.09/   
;
; Beam offsets now come from file according to Desh
;  offsets now in arcsec; they are in az and za directions
;
;    data beamaz/0.00,-164.5,-329.1,-164.5,164.5,329.1,164.5/
;    data beamza/0.00,332.6,0.00,-332.6,-332.6,0.0,332.6/
;
; From Abmpos2   23Aug04
;
;     data beamaz0/0.0,-164.5,-329.1,-164.5,164.5,329.1,164.5/
;      data beamza0/0.0,332.6,0.0,-332.6,-332.6,0.0,332.6/
beamaz19[0] = 0.0
beamaz19[1] = -62.8
beamaz19[2] = -311.1
beamaz19[3] = -248.3
beamaz19[4] = 62.8
beamaz19[5] = 311.1
beamaz19[6] = 248.3

beamza19[0] = 0.0
beamza19[1] = 376.9
beamza19[2] = 125.0
beamza19[3] = -251.9
beamza19[4] = -376.9
beamza19[5] = -125.0
beamza19[6] = 251.9

;
; convert to arcsecs
; first is to convert beammap
; switch below from 58 to 26  371/58 from pixmap which is wrong!
;     pixel=371./31.
pixel = 1 
;
;  Offsets are constant in Az, El for observations at transit.
; Need to take into account only the cos Decl correction and
; whether you are north or south of zenith
southofzenith = 1.0
if(centdec gt 18.35) then southofzenith = -1.0

beamra[nbeam] = southofzenith*beamaz19[nbeam]*cos(float(centdec)/degrad)
beamdec[nbeam] = southofzenith*beamza19[nbeam]*cos(float(centdec)/degrad)

xcent=(centra*3600.0)+beamra[nbeam]*pixel
ycent=(centdec*3600.0)+beamdec[nbeam]*pixel
xcent_label = xcent/3600
ycent_label = ycent/3600
; ang is the angle in degrees

radius=avefwhm/2.0
ang=-0.5
for j=1,720 do begin
    ang+=0.5
    x[j]=xcent+radius*cos(ang/degrad)
    y[j]=ycent+radius*sin(ang/degrad)
    x[j]=x[j]/3600.0
    y[j]=y[j]/3600.0
endfor

dectrack=ycent/3600.0

end

;-------------------------------------------------------------
;+
; NAME:
;       DRAWGAL
; PURPOSE:
;       Returns an array with the galaxy coordinates that outline the
;       galaxy
;
; EXPLANATION:
;       Takes the galaxy radius and creates arrays that hold the
;       galaxy drawing coordinates
;
; CALLING SEQUENCE:
;       DRAWGAL, XIN, YIN, GRAD, GEPS, GPA, SCALE, XGAL, YGAL, NGALPTS
;
; INPUTS:
;       XIN - The x coordinate of the galaxy center  
;       YIN - The y coordinate of the galaxy center
;       GRAD - The radius of the galaxy
;       GEPS - The galaxy eccentricity
;       SCALE - Scaling factor (to enlarge the plot)
;
; OUTPUTS:
;       XGAL - The array with the x positions of the galaxies (this is to
;           plot the galaxy)
;       YGAL - The array with the y positions of the galaxy (this is to
;           plot the galaxy)
;       NGALPTS - Number of points used to draw the galaxy 
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated to idl by
;       W.H. during summer 2006
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
        ang = -1
        for j=1,360 do begin
            ang++
            ngalpts++
            xgal[j] = xcent + grad * cos(float(ang)/degrad)
            ygal[j] = ycent + grad * sin(float(ang)/degrad)
        endfor
        for j=1, ngalpts do begin
            xgal[j]=xgal[j]/3600
            ygal[j]=ygal[j]/3600
        endfor
    endif else ngalpts = 5

    if(gpa lt 90 and gpa ne 0) then begin
        theta=90-gpa
        xgal[1]=xcent+grad*cos(float(theta)/degrad)
        ygal[1]=ycent+grad*sin(float(theta)/degrad)
        xgal[2]=xcent
        ygal[2]=ycent+grad*geps
        xgal[3]=xcent-grad*cos(float(theta)/degrad)
        ygal[3]=ycent-grad*sin(float(theta)/degrad)
        xgal[4]=xcent
        ygal[4]=ycent-grad*geps
        xgal[5]=xgal[1]
        ygal[5]=ygal[1]
        for j=1, ngalpts do begin
            xgal[j]=xgal[j]/3600
            ygal[j]=ygal[j]/3600
        endfor
        
    endif

    if(gpa gt 90  and  gpa lt 180) then begin
        theta=gpa-90
        xgal[1]=xcent+grad*cos(float(theta)/degrad)
        ygal[1]=ycent-grad*sin(float(theta)/degrad)
        xgal[2]=xcent
        ygal[2]=ycent+grad*geps
        xgal[3]=xcent-grad*cos(float(theta)/degrad)
        ygal[3]=ycent+grad*sin(float(theta)/degrad)
        xgal[4]=xcent
        ygal[4]=ycent-grad*geps
        xgal[5]=xgal[1]
        ygal[5]=ygal[1]
        
        for j=1, ngalpts do begin
            xgal[j]=xgal[j]/3600
            ygal[j]=ygal[j]/3600
        endfor
    endif
    

end
;-------------------------------------------------------------
;+
; NAME:
;       PLOTFRAME30
; PURPOSE:
;       Does the actual plotting of the beams, galaxies and frame of
;       interest.
; EXPLANATION:
;       Takes the user defined range and coordinates and then plots
;       all the galaxies in this range. Also shows the position of the
;       alfabeams in this range.
;
; CALLING SEQUENCE:
;       PLOTFRAME30, CENTRA, CENTDEC, RAMIN, RAMAX, DECMIN, DECMAX, NAGC, XRA, YDEC, GSIZE, GELLIP, GPOSANG, GVEL, NGALS, HARD, FILENAME_PLOT, RANGE
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
;       HARD - Whether or not this plot should be on postscript or
;              screen, 0 is on screen, 1 is on postscript
;       FILENAME_PLOT - Name of postscript file to plot on
;       RANGE - Range defined by user 
;
; PROCEDURES CALLED
;       ALFABEAMS, PRINTAGCINFO, DRAWGAL
;
; REVISION HISTORY:
;       Written by M.H. in fortran and translated and updated to idl by
;       W.H. during summer 2006
;-
;-------------------------------------------------------------

PRO PLOTFRAME30, CENTRA, CENTDEC, RAMIN, RAMAX, DECMIN, DECMAX, XRA, YDEC, GSIZE, GELLIP, GPOSANG, GVEL, NGALS, HARD, FILENAME_PLOT, RANGE

; This procedure plots everything onto the plotting area (the axis,
; the galaxies and the beams)

; Some initialisation
devname = ''
orient = ''
xlab = ''
ans = ''
blab = strarr(7)
xin_arr = fltarr(1)
yin_arr = fltarr(1)
x1 = fltarr(1000)
y1 = fltarr(1000)
xgal = fltarr(1000)
ygal = fltarr(1000)
nrads = 720
scale = 1.0
for i = 0, 6 do blab[i] = string(i)

; Make sure that the correct plotting device is chosen
entry_device = !d.name
if(hard eq 1) then begin
    set_plot, 'PS'
    device, filename = filename_plot, /color, xsize = 8.0, ysize = 8.0, xoffset = (8.5-7.0)*0.5, yoffset = (11-7.0)*0.5, /inches
    loadct, 13, /silent       
endif 

;Plot axis

plot, xin_arr, yin_arr, /nodata, xrange = [ramax, ramin], yrange = [decmin, decmax], xtitle = 'R.A.', ytitle = 'Dec.', xstyle = 1, ystyle = 1 

for j = 1, ngals do begin

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
        if(gv eq 0) then color = 'FFFFFF'XL
        if(gv ne 0 and gv le 500) then color = 'FF0000'XL
        if(gv gt 500  and  gv lt 1000) then color = 'FFFF00'XL 
        if(gv gt 1000  and gv lt 3000) then color = '00FF00'XL 
        if(gv gt 3000  and gv lt 6000) then color = '00FFFF'XL
        if(gv gt 6000  and gv lt 9000) then color = '3399FF'XL 
        if(gv gt 9000) then color = '0000FF'XL 
    endif

    if(hard eq 1) then begin
        if(gv eq 0) then color = 0
        if(gv ne 0 and gv le 500) then color = 65
        if(gv gt 500  and  gv lt 1000) then color = 112 
        if(gv gt 1000  and gv lt 3000) then color = 165
        if(gv gt 3000  and gv lt 6000) then color = 208
        if(gv gt 6000  and gv lt 9000) then color = 222 
        if(gv gt 9000) then color = 255
    endif
    
    if(hard eq 0) then begin
        oplot, xin_arr, yin_arr, psym = 1, color = color
        oplot, xgal[1:ngalpts], ygal[1:ngalpts], color = color
    endif

    if(hard eq 1) then begin
        oplot, xin_arr, yin_arr, psym = 1, color = color
        oplot, xgal[1:ngalpts], ygal[1:ngalpts], color = color
    endif
endfor

; 
;    Get the alfabeams
; 

xcent_label = 0
ycent_label = 0
dectrack_plot = fltarr(100)
ramin_to_ramax = fltarr(100)
if(hard eq 0) then color = '00ff00'XL
if(hard eq 1) then color = 165
for j=0,6 do begin
    nbeam=j
    alfabeams, nbeam, centra, centdec, dectrack, x1, y1, xcent_label, ycent_label
    oplot, x1[1:720],y1[1:720], color = color
    if(hard eq 0) then xyouts, xcent_label, ycent_label-0.0085, strcompress(string(j), /remove_all), $
      charsize = 3/(range/0.5), charthick = 2/(range/0.5), color = '00ff00'XL, alignment = 0.5
    if(hard eq 1) then xyouts, xcent_label, ycent_label-0.0075, strcompress(string(j), /remove_all), $
      charsize = 2/(range/0.5), charthick = 2/(range/0.5), color = 165, alignment = 0.5
    for i = 0, 99 do begin
        ramin_to_ramax[i] = ramin + i* ((ramax - ramin)/99)
        dectrack_plot[i] = dectrack
    endfor
    oplot, ramin_to_ramax, dectrack_plot, linestyle = 2, color = color    
endfor
if(hard eq 1) then device, /close
set_plot, entry_device
end


PRO OPENAGC, DECMIN, DECMAX, AGCLUN

; Open the agc catalog

if(decmin ge 0) then openr, agclun,'/home/dorado3/galaxy/esp3/cats/agc2000.north', /get_lun
if(decmax lt 0) then openr, agclun,'/home/dorado3/galaxy/esp3/cats/agc2000.south' , /get_lun
if(decmin gt -2 and decmax lt 2) then openr, agclun,'/home/dorado3/galaxy/esp3/cats/agc2000.bridge', /get_lun

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
;       and calculates the minimum and maximum R.A. and Dec
;
; CALLING SEQUENCE:
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
;       by W.H.during summer 2006
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


PRO PLOTALFA_EVENT, EVENT

; Set up the widget state info structure
widget_control, event.top, get_uvalue = infoptr
info = *infoptr

; Find out which event caused the event
widget_ev = ''
widget_control, event.id, get_uvalue = widget_ev

if(widget_ev eq 'Plot' or widget_ev eq 'draw_widg' or widget_ev eq 'coords_text' or widget_ev eq 'range_text') then begin

    if(widget_ev eq 'Plot' or widget_ev eq 'coords_text' or widget_ev eq 'range_text') then begin

        range_length = 0              

        widget_control, event.top, hourglass = 1

        widget_control, info.coords_text, get_value = coords
        widget_control, info.range_text, get_value = range

        if(range eq '') then begin
            range = float(0.5)
            range_length = strlen(strcompress(string(range), /remove_all))
        endif
        
        range_test = stregex(strcompress(string(range), /remove_all),'[0-9]*\.?[0-9]*', length = range_length)
 
        if(range_test ne -1 and range_length eq strlen(strcompress(string(range), /remove_all))) then begin
            range = range
        endif else range = 0.3                   

; Check that the input for the coordinates and range are valid
        if( stregex(strcompress(string(coords), /remove_all),'[0-9]{7}[\+-][0-9]{6}') ne -1 and $
           strlen(strcompress(string(coords), /remove_all)) eq 14 and $
            ((2*float(range) mod 1) eq 0) and (float(range) ge 0.5)) then begin

            x = fltarr(5000)
            y = fltarr(5000)
            xra = fltarr(5000)
            ydec = fltarr(5000)
            gsize = fltarr(5000)
            gellip = fltarr(5000)
            gposang = fltarr(5000)
            gvel = fltarr(5000)
            nagc = intarr(5000)
            onedeg = 3.1415926536/180
            

            openw, gals_radec_lun, 'gals.radec', /get_lun
            openw, gals_txt_lun, 'gals.txt', /get_lun

            if(range eq '') then range = 0.5

; Read coords as ALPHA so you can us it as PLOTLABEL
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
;
            openagc, decmin, decmax, agclun
            
            nrecagc = 0
            ngal = 0
            DESCRIPTION = ''
            NGCIC = ''
            WHICH = ''
            TELCODE = ''
            WIDTHCODE = ''
            SIGN = ''
            ra = 0
            dec = 0
            AGCNUMBER = 0L
            while((ra le ramax) and EOF(agclun) ne 1) do begin
                readf,agclun, AGCNUMBER,WHICH, $
                  RAH,RAM,RAS10,SIGN,DECD,DECM,DECS, $
                  A100,B100,MAG10,INCCODE,POSANG,DESCRIPTION,BSTEINTYPE, $
                  VOPT,VERR,EXTRC3,EXTDIRBE,VSOURCE,NGCIC,$
                  FLUX100,RMS100,V21,WIDTH,WIDTHERR,WIDTHCODE,TELCODE,$
                  DETCODE,HISOURCE,STATUSCODE,SNRATIO,$
                  IBANDQUAL,IBANDSRC,IRASFLAG,ICLUSTER,HIDATA,$
                  IPOSITION,IPALOMAR,RC3FLAG,IROTCAT,NEWSTUFF,$
                  format = '(I6,A1,2I2.2,I3.3,A1,3I2.2,I5,2I4,I2,I3,A8,I3,I6,I3,2I5,I3,A8,I5,I4,I5,I4,I2,A4,A1,i1,I2,I1,I3,I1,I2,I1,I2,5I1,I2)'
                nrecagc++
                rahours = float(rah) + float(ram)/60 + float(ras10)/36000
                ra = rahours*15	
                dec = float(decd) + float(decm)/60 +float(decs)/3600
                if(SIGN eq '-') then dec = -dec
                
                
                if(ra ge ramin and dec ge decmin and dec le decmax) then begin
                    ngal++
                    nagc[ngal] = agcnumber
                    xra[ngal] = ra
                    ydec[ngal]= dec
                    if(a100 gt 0) then gsize[ngal] = 60 *float(a100)/100 else gsize[ngal] = 5
                    if(b100 gt 0 and a100 ne 0) then gellip[ngal] = float(b100)/float(a100) else gellip[ngal] = 1
                    if(posang ne 0) then gposang[ngal] = float(posang) else gposang[ngal] = 0
                    
                    vel = 0
                    if(vopt ne 0) then vel = float(vopt)
                    if(v21 ne 0  and  (detcode eq 1  or  detcode eq 3  or detcode eq 8)) then  vel = float(v21)
                    if(v21 ne 0  and  vel eq 0  and  (detcode eq 2  or detcode eq 5 or  detcode eq 6 or detcode eq 9)) then vel = float(v21)
                    gvel[ngal] = vel

                    printf, gals_radec_lun,agcnumber,ra,dec, format = '(i6,2e18.10)'
                    printf, gals_txt_lun, AGCNUMBER,WHICH,NGCIC,RAH,RAM,RAS10,SIGN,DECD,DECM,$
                      DECS,A100,B100,MAG10,BSTEINTYPE,$
                      VOPT,VSOURCE,FLUX100,RMS100,$
                      V21,WIDTH,WIDTHCODE,TELCODE,DETCODE,HISOURCE,$
                      IBANDQUAL,IBANDSRC,POSANG,IPOSITION,IPALOMAR,$
                      format = '(I6,A1,A8,1x,2I2.2,I3.3,A1,3I2.2,I5,2I4,i6,2x,I5,I3,2x,I5,I4,I5,I4,1x,A4,A1,i1,I2,2i3,i5,2i3)'
                endif 
            endwhile

; Save important changeds into the info structure

            widget_control, info.gals_text, set_value = strcompress(string(ngal))

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
            info.plotted = 1
            info.range = range

            if(ptr_valid(infoptr) eq 0) then message, 'State information pointer is invalid'
            if(n_elements(info) eq 0) then message, 'State information structure is undefined'
            if keyword_set(no_copy) then begin
                *infoptr = temporary(info)
            endif else begin
                *infoptr = info
            endelse

; Finally make the plot and clas all the used files
            plotframe30, centra, centdec, ramin, ramax, decmin, decmax, xra, ydec, gsize, gellip, gposang, gvel, ngal, hard, '', range

            close, agclun
            free_lun, agclun
            close, gals_radec_lun
            close, gals_txt_lun
            free_lun, gals_txt_lun, gals_radec_lun

            widget_control, event.top, hourglass = 0

        endif else if(float(range) lt 0.5 or (2*float(range) mod 1) ne 0) then begin
            a = dialog_message('Please enter a valid range (multiple of 0.5 and at least 0.5)', /error)
        endif else a = dialog_message('Please enter valid coordinates', /error)
        
    endif

; If the draw widget is clicked return info about coords and galaxies
; clicked on
    if(widget_ev eq 'draw_widg' and info.plotted eq 1) then begin
        info.xc = event.x
        info.yc = event.y
        xy_data = convert_coord(info.xc, info.yc, /device, /to_data)
        x_data = xy_data[0]
        y_data =  xy_data[1]
        foundflag = 0
        printagcinfo, x_data, y_data, foundflag, point_info_text
        if(foundflag eq 0) then point_info_text = string(x_data, y_data, format = '(2f15.6,6x,2f15.6)')
        widget_control, info.point_info, set_value=point_info_text        
    endif

endif

; If user uses menu with save option save plot to ps file
if(widget_ev eq 'fileopt1' and info.plotted eq 1) then begin
    filename_plot = dialog_pickfile(/write, group=event.top)
    if(filename_plot ne '') then begin
        filename_plot += '.ps'
        hard = 1
        plotframe30, info.centra, info.centdec, info.ramin, info.ramax, info.decmin, info.decmax, info.nagc, info.xra, $
          info.ydec, info.gsize, info.gellip, info.gposang, info.gvel, hard, filename_plot, info.range
    endif 
    
endif

end

;+
; NAME:
;       PLOTALFA
; PURPOSE:
;       Set up the gui.
;
; EXPLANATION:
;       Set up the gui and let the event handler do the rest of the
;       work (plotting)
;
; CALLING SEQUENCE:
;       PLOTALFA
;
; REVISION HISTORY:
;       Written by W.H.during summer 2006
;  
;-

PRO PLOTALFA

; Set up the GUI

; Set up main widget
tlb = widget_base(mbar = mbar, column = 1, title = 'PlotALFA')
main = widget_base(tlb, column = 1)

; Set up menu
filemenu = widget_button(mbar, value = 'File')
fileopt1 = widget_button(filemenu, value = 'Save Postscript... ', /separator, uvalue = 'fileopt1')

; Set up widget used for plotting
draw_w = widget_draw(main, xsize = 700, ysize = 700, uvalue = 'draw_widg', /button_events)
device, retain = 2

; Set up input text widgets and plot button
below_plot_base = widget_base(main, row = 1, /base_align_center)
text_button_base = widget_base(below_plot_base, column = 1, /base_align_left)
text_base = widget_base(text_button_base, row = 2, /base_align_center)
coords_label = widget_label(text_base, value = 'Enter Coordinates:')
coords_text = widget_text(text_base, value = '', /editable, uvalue = 'coords_text', xsize = 15)
range_label = widget_label(text_base, value = 'Enter Box Size (in multiples of 0.5 degrees):')
range_text = widget_text(text_base, value = '', /editable, xsize = 4, uvalue = 'range_text')
button_base = widget_base(text_button_base, row = 1, /grid_layout, /base_align_left)
plot_button = widget_button(button_base, value = 'Plot', uvalue = 'Plot')
gals_bounds_base = widget_base(below_plot_base, column = 1, /base_align_left)
bounds_base = widget_base(gals_bounds_base, row = 1, /base_align_left)
boundaries_label =  widget_label(bounds_base, value = 'Bounds:')
boundaries_text =  widget_text(bounds_base, value = '', xsize = 35)
gals_base = widget_base(gals_bounds_base, row = 1, /base_align_left)
gals_label = widget_label(gals_base, value = 'Galaxies:')
gals_text = widget_text(gals_base, value = '', xsize = 5)

; Set up widgets that display plot info
info_base = widget_base(tlb, row = 2)
point_label = widget_label(info_base, value = 'Click to get coordinate info')
point_info = widget_text(info_base, value = '', xsize = 115, uvalue = 'info_label')

; Realize widgets
widget_control, tlb, /realize 

; Make sure everything is plotted on the draw widget
widget_control, draw_w, get_value = winid
wset, winid

; Set up info that needs to be retrieved from events
widg_info = {coords_text:coords_text, range_text:range_text, coords:'', range:0.5, xc:0L, yc:0L, point_info:point_info, centra:float(0), centdec:float(0), $
             ramin:float(0), ramax:float(0), decmin:float(0),decmax:float(0), nagc:fltarr(5000), xra:fltarr(5000), ydec:fltarr(5000), gsize:fltarr(5000), $
             gellip:fltarr(5000), gposang:fltarr(5000), gvel:fltarr(5000), ngal:0, boundaries_text:boundaries_text,plotted:0,gals_text:gals_text}
widg_infoptr = ptr_new(widg_info)
widget_control, tlb, set_uvalue = widg_infoptr

; Start xmanager to look for events
xmanager, 'plotalfa', tlb, /no_block

end
