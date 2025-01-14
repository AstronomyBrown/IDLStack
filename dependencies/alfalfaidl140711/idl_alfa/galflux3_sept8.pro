;+
; NAME:
;      GALflux
; PURPOSE:
;       ALFALFA Tool for measuring fluxes from integrated profiles
;
; EXPLANATION:
;
;       GALflux is a GUI based tool that examines a small subregion of 
;       a grided datacube.  The procedure obtains DSS 2 Blue and Sloan
;       images that match the selected region.
;       The user marks the detection, and ellipses
;       are fit at isophotal flux levels (at mJy km/s).  Custom
;       isophotal levels may also be input.  The result integrated
;       profiles can then be baselined if the user so chooses
;       with a polynomial of up to 11th order.  If a baseline if fit,
;       then the rms is calculated from the first baseline region.  Spectra at each
;       isophotal level can then be fit in GAUSSIAN or PEAK fitting
;       mode.  GAUSSIAN mode involves picking a peak value and width
;       estimate, as well as two points far to the left and right of
;       the peak. PEAKS mode (one or two peaks) involves picking four
;       points in a spectrum (lower chan marker, lower peak marker,
;       upper chan marker, upper peak marker).  Linear fits are made
;       to the "sides" of the galaxy profile.  The user can click the
;       marks in the plot to fine tune the fits.  In addtion, the AGC
;       and Digital HI Archive (Sprinob, et al. 2005) are shown, and
;       the user can compare the FWHM fit from the data with available
;       spectra in the Archive.  Saving the files in a SOURCE structure
;       and postscript output are also allowed. 
;
;	This program is based on a previous IDL program (flux.pro) 
;	written by R. Giovanelli.   
;
; CALLING SEQUENCE:
;       
;       galflux, grid=grid, llx=llx, lly=lly, urx=urx, ury=ury
;
; INPUTS:
;       grid - grid structure as output by grid_prep
;        llx - lower left x coordinate from selected box
;        lly - lower left y coordinate from selected box
;        urx - upper right x coordinate from selected box
;        ury - upper right y coordinate from selected box
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
;       none
;
;
; RESTRICTIONS:
;
;        Must have output from grid_prep
;
; EXAMPLE:
;
;       Pretty straight forward:  galflux, grid=gridbf, llx=46, lly=70, urx=53, ury=77
;
; PROCEDURES USED:
;         DSSQUERY, GSFC IDL USER'S LIBRARY
;         HOR.  See pjp AO library
;         VER.  See pjp AO library
;         FLAG.  See pjp AO library
;         GETDSS.PRO, B.Kent
;         CURS.PRO
;
;
;
; MODIFICATION HISTORY:
;       Based on FLUX.PRO, WRITTEN, R. Giovanelli, Cornell University, 2004-2006
;       WRITTEN, B. Kent, Cornell University, Feburary 17, 2006
;
;       March 11, 2006.  B.K.  - finished element that needs to
;                                   save "checklist" file.  Works when
;                                   the user saves a SRC file
;       March 12, 2006.  B.K. -  added median sky subtraction
;
;       April 04, 2006.  B.K. -  added systematic error determination
;       April 05, 2006.  B.K. -  width recorded in checklist,
;                                systematic error calculation
;                                modified.
;                                Comments added to postscript
;       April 18, 2006.  B.K. -  user added to postscript output
;       April 22, 2006.  B.K. -  when user "saves" in the postscript
;                               menu, both a ps and src file are
;                               written to disk
;
;        June 14, 2006.  B.K. - PS and SRC filenames changed to
;                               include grid name also
;
;        July 25, 2006.  B.K. - Top level base window size changed.
;                               Image options moved to menu bar
;       August 7, 2006.  B.K. - "Spike" repair fixed for linear
;                               interpolation
;
;       December  2006   B.K. - Added position correction based on
;                               first year ALFALFA data.  Cen_ell is
;                               corrected in the source file.  Version
;                               3.
;
;       Feb 6, 2007      B.K. - fixed pointing correction
;
;       Feb 10,2007      B.K. - added over plot on the optical image
;                               display - shows measured ellipse
;                                         position, position with
;                                         pointing correciton, as well
;                                         as the orgininal display
;                                         from the AGC catalog.
;
;
;----------------------------------------------------------


;---------INITIALIZE COMMON BLOCK-----------------
pro galflux_initcommon, llx=llx, lly=lly, urx=urx, ury=ury, srcfile=srcfile, skym=skym

common galflux_state, gfstate

common gridstate

end


;---------GALFLUX STARTUP-------------------------
pro galflux_startup, llx=llx, lly=lly, urx=urx, ury=ury, srcfile=srcfile, skym=skym

common gridstate

end

;------------------------------------------------------------------
;MAIN DISPLAY EVENT HANDLER

pro galflux_maindisplay_event, event

common galflux_state
common gridstate

   gfstate.xsize=600
   gfstate.ysize=400

   result=convert_coord(event.x, event.y, /device, /double, /to_data)

   if (result[0] gt gfstate.nchn-1) then result[0]=gfstate.nchn-1
   if (result[0] lt 0.0) then result[0]=0.0

   widget_control, gfstate.currentchan, set_value=strcompress(long(round(result[0])), /remove_all)
   widget_control, gfstate.currentvel,  $
              set_value=strtrim(string(grid.velarr[long(round(result[0]))] , format='  (f9.2)'))+' km/s'
   widget_control, gfstate.currentflux, set_value=strtrim(string(result[1], format=' (f9.2)'))+' mJy'

   ;print, result

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;CROSSHAIRS
   device, decomposed=1
   if (gfstate.mousestatus eq 0 AND gfstate.crosshairs eq 'on') then begin

      widget_control, gfstate.mainplotwindow, get_value=index 
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow 

      WSet, gfstate.wid
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID] 

     y=[-1000,20000]
     x=[0,16000]
     oplot, intarr(2)+long(round(result[0])), y,color='7F7F7F'XL, linestyle=2   ; gray dashed line
     oplot, x, fltarr(2)+result[1], color='7F7F7F'XL, linestyle=2  ; gray dashed line
   endif
   device, decomposed=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PEAK MODE TRACKING MOVEMENT

if(gfstate.fitmodeon eq 'on' AND gfstate.currentfitmode eq 'peaks' AND gfstate.mode eq 'spectrameasure') then begin
  ;print, 'Gaussian tracking'

 ;Determine if mouse pointer is over an
                                ;existing baseline marker ONLY FOR THE
                                ;CURRENT ISO VALUE!!!!!!!!
     result=convert_coord(event.x, event.y, /device, /double, /to_data)
       datalocation=where(gfstate.peaksparam[*,gfstate.currentlistval] lt long(round(result[0]))+5 AND $
                          gfstate.peaksparam[*,gfstate.currentlistval] gt long(round(result[0]))-5)

         
           device, decomposed=1
          ;Side to side arrows for the hi/lo channel markers
          case datalocation[0] of

              0: begin
                  xyouts, 595, 5, 'Lower Channel marker', /device, alignment=1.0, color='FFFF00'XL, charsize=1.5
                  curs, 70      ;movement mouse cursor
                 end 

              1: begin
                  xyouts, 595, 5, 'Upper Channel marker', /device, alignment=1.0, color='FF00FF'XL, charsize=1.5
                  curs, 70      ;movement mouse cursor
                 end

              2: begin
                  
                  if (gfstate.rmsstatus eq 'on') then begin

                  curs, 70   ;movement mouse cursor
                  xyouts, 595, 5, 'Lower RMS marker', /device, alignment=1.0, color='00FFFF'XL, charsize=1.5

                  endif

                 end

              3: begin
                  
                  if (gfstate.rmsstatus eq 'on') then begin

                  curs, 70   ;movement mouse cursor
                  xyouts, 595, 5, 'Upper RMS marker', /device, alignment=1.0, color='00FFFF'XL, charsize=1.5

                  endif

                 end

                  ;Hand pointer if it is the peak circle
                                ;- add yrange part to determine if
                                ;near the circle

              4: begin
                  yval=gfstate.currentyarr[gfstate.peaksparam[datalocation[0], gfstate.currentlistval]]
                                ;print, yval
                 if (yval lt long(round(result[1]))+2 AND yval gt long(round(result[1]))-2) then begin
                   curs, 58
                   xyouts, 595, 5, 'Lower peak marker', /device, alignment=1.0, color='FFFF00'XL, charsize=1.5
                 endif
                 end

              5: begin
                  yval=gfstate.currentyarr[gfstate.peaksparam[datalocation[0], gfstate.currentlistval]]
                                ;print, yval
                 if (yval lt long(round(result[1]))+2 AND yval gt long(round(result[1]))-2) then begin
                   curs, 58
                   xyouts, 595, 5, 'Upper peak marker', /device, alignment=1.0, color='FF00FF'XL, charsize=1.5
                 endif
                 end
              

                  else: curs, 'd'

          endcase
          device, decomposed=0

                                ;What to do if the cursor is over a
                                ;valid peaks parameter object, and
                                ;the right mouse button is clicked

          
          if (event.type le 2 AND event.press ne 4) then begin

              eventTypes = ['DOWN', 'UP', 'MOTION']
              thisEvent = eventTypes[event.type]
        

              CASE thisEvent OF

                  'DOWN': BEGIN

                       if (event.press eq 1) then begin
                          
   
                           if (datalocation[0] ne -1) then begin   
      
                                ; Turn motion events on for the draw widget.
                                ;Turn off zoom, turn on baseline mover!
                               gfstate.zoom='off'
                               gfstate.mousemover='on'

                               gfstate.mousestatus=1
                              

                                ;Save baseline mark
                               gfstate.mousemark=datalocation[0]

                               device, decomposed=1

                               galflux_plotter
                          
                               widget_Control, gfstate.mainplotwindow, Draw_Motion_Events=1
                               widget_control, gfstate.mainplotwindow, get_value=index
                               gfstate.wid=index
                               gfstate.drawID=gfstate.mainplotwindow

                                ;Create a pixmap. Store its ID. Copy window contents into it.

                               Window, 20, /Pixmap, XSize=gfstate.xsize, YSize=gfstate.ysize
                               gfstate.pixID = !D.Window
                               Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.wid]

                                ;Get and store the static corner of the box.

                                ;gfstate.zoomsx = event.x
                                ;gfstate.zoomsy = event.y


                           endif ;end of datalocation[0] eq -1 check

                       endif    ;end of event.press eq 1 IF statement

                   END          ;end of DOWN case

;UP GOES HERE

                   'UP': BEGIN
     
                                ;Note to Self:  mousemover put in
                                ;to prevent from UP option from being accessed

                       if (gfstate.mousestatus eq 1 AND event.press ne 4 and gfstate.mousemover eq 'on') then begin

                           gfstate.mousestatus=0
                           gfstate.mousemover='off'

                          ; Erase the last box drawn. Destroy the pixmap.

                           widget_control, gfstate.mainplotwindow, get_value=index
                           gfstate.wid=index
                           gfstate.drawID=gfstate.mainplotwindow

                           WSet, gfstate.wid
                           Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]
      
                           ;WDelete, gfstate.pixID

                                ;Convert to current data coordinates
                           result=convert_coord(event.x, event.y, /device, /double, /to_data)

                            ;Check to make sure we're not out of range
                           if (result[0] lt 0) then result[0]=0
                           if (result[0] gt gfstate.nchn-1) then result[0]=gfstate.nchn-1
                           

                           if (gfstate.setallmode eq 'on') then begin
                             gfstate.peaksparam[gfstate.mousemark, 0:gfstate.numisolevels]=long(round(result[0]))
                           endif else begin
                             gfstate.peaksparam[gfstate.mousemark, gfstate.currentlistval]=long(round(result[0]))
                           endelse
                           ;if (gfstate.setallmode eq 'on') then begin
                           ;    gfstate.baselinevalues[0:4,gfstate.mousemark]=long(round(result[0]))
                           ;endif else begin
                           ;    gfstate.baselinevalues[gfstate.currentlistval,gfstate.mousemark]=long(round(result[0]))
                           ;endelse

                                ;print, gfstate.baselinevalues
       
                                ;reset so as not to confuse zoom motion option
                           gfstate.mousemark=-1
                           gfstate.zoom='on'
                          
                                ; Turn draw motion events off. Clear any events queued for widget.
                                ; Return mouse pointer to original state

                           Widget_Control, gfstate.drawID, Clear_Events=1

                           galflux_spectrameasure

                           curs, 'd'

                       endif

                   END          ;END OF UP CASE



                   'MOTION': BEGIN
                       if (event.press eq 0 AND gfstate.mousestatus eq 1) then begin

                                ;Here is where the baseline flag is
                                ;erased and moved 

                            ;Side to side arrows for the hi/lo channel markers
                           if (gfstate.mousemark eq 0 OR gfstate.mousemark eq 1 OR gfstate.mousemark eq 3 OR gfstate.mousemark eq 4) then begin
                               curs, 70 ;movement mouse cursor
                           endif 
          
                                ;Hand pointer if it is the peak circle
                                ;- add yrange part to determine if
                                ;near the circle
                           if (gfstate.mousemark eq 4 OR gfstate.mousemark eq 5 ) then begin
                                curs, 58
                           endif

                           widget_control, gfstate.mainplotwindow, get_value=index 
                           gfstate.wid=index
                           gfstate.drawID=gfstate.mainplotwindow 

                           WSet, gfstate.wid
                           Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]

                                ; Get the coodinates of the new box
                                ; element an drag circle or flagged line

                           result=convert_coord(event.x, event.y, /device, /double, /to_data)
       
                           device, decomposed=1
                           color='FF00FF'XL  ;MAGNETA FOR PEAKS MODE

                                ;PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
                                ;   Color=color, thick=1.5
 
                           if (gfstate.mousemark eq 0) then begin
                             flag, long(round(result[0])), thick=2.0, color='FFFF00'XL  ;CYAN for lower
                           endif

                           if (gfstate.mousemark eq 1) then begin
                              flag, long(round(result[0])), thick=2.0, color=color
                           endif



                           if (gfstate.mousemark eq 4) then begin
                              plotsym, 0,1.5
                              plots, event.x, event.y, color='FFFF00'XL, psym=8, /device  ;CYAN for lower
                           endif
                           
                           if (gfstate.mousemark eq 5) then begin
                              plotsym, 0,1.5
                              plots, event.x, event.y, color=color, psym=8, /device
                           endif


                           if (gfstate.mousemark eq 2 OR gfstate.mousemark eq 3) then begin
                               
                               y=[-20,0,20]

                               color='00FFFF'XL ;YELLOW

                               oplot, fltarr(3)+long(round(result[0])), y, color=color, thick=2.0
                               

                           endif

                           device, decomposed=0

                       endif

                   END          ;END OF MOTION case

                  ELSE:

             ENDCASE




         endif




endif  ;END of peaks mode tracking movement


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GAUSSIAN MODE TRACKING MOVEMENT

if(gfstate.fitmodeon eq 'on' AND gfstate.currentfitmode eq 'gaussian' AND gfstate.mode eq 'spectrameasure') then begin
  ;print, 'Gaussian tracking'

 ;Determine if mouse pointer is over an
                                ;existing baseline marker ONLY FOR THE
                                ;CURRENT ISO VALUE!!!!!!!!
     result=convert_coord(event.x, event.y, /device, /double, /to_data)
       datalocation=where(gfstate.gaussparam[*,gfstate.currentlistval] lt long(round(result[0]))+5 AND $
                          gfstate.gaussparam[*,gfstate.currentlistval] gt long(round(result[0]))-5)

         


 ;Side to side arrows for the hi/lo channel markers
       device, decomposed=1
          case datalocation[0] of

              0: begin
                  xyouts, 595, 5, 'Lower Channel marker', /device, alignment=1.0, color='FFFF00'XL, charsize=1.5
                  curs, 70      ;movement mouse cursor
                 end 

              1: begin
                  xyouts, 595, 5, 'Upper Channel marker', /device, alignment=1.0, color='FFFF00'XL, charsize=1.5
                  curs, 70      ;movement mouse cursor
                 end

                                ;Hand pointer if it is the peak circle
                                ;- add yrange part to determine if
                                ;near the circle

              2: begin
                  yval=gfstate.currentyarr[gfstate.gaussparam[datalocation[0], gfstate.currentlistval]]
                                ;print, yval
                 if (yval lt long(round(result[1]))+2 AND yval gt long(round(result[1]))-2) then begin
                   curs, 58
                   xyouts, 595, 5, 'Peak estimate marker', /device, alignment=1.0, color='FFFF00'XL, charsize=1.5
                 endif
                 end


              3: begin

                  if (gfstate.rmsstatus eq 'on') then begin

                  curs, 70   ;movement mouse cursor
                  xyouts, 595, 5, 'Lower RMS marker', /device, alignment=1.0, color='00FFFF'XL, charsize=1.5

                  endif

                 end

              4: begin

                  if (gfstate.rmsstatus eq 'on') then begin

                  curs, 70   ;movement mouse cursor
                  xyouts, 595, 5, 'Upper RMS marker', /device, alignment=1.0, color='00FFFF'XL, charsize=1.5

                  endif

                 end

              

                  else: curs, 'd'

          endcase
          device, decomposed=0

        
                                ;What to do if the cursor is over a
                                ;valid gaussian parameter object, and
                                ;the right mouse button is clicked

          
          if (event.type le 2 AND event.press ne 4) then begin

              eventTypes = ['DOWN', 'UP', 'MOTION']
              thisEvent = eventTypes[event.type]
        

              CASE thisEvent OF

                  'DOWN': BEGIN

                       if (event.press eq 1) then begin
                          
   
                           if (datalocation[0] ne -1) then begin   
      
                                ; Turn motion events on for the draw widget.
                                ;Turn off zoom, turn on baseline mover!
                               gfstate.zoom='off'
                               gfstate.mousemover='on'

                               gfstate.mousestatus=1
                              

                                ;Save baseline mark
                               gfstate.mousemark=datalocation[0]

                               device, decomposed=1

                               galflux_plotter
                          
                               widget_Control, gfstate.mainplotwindow, Draw_Motion_Events=1
                               widget_control, gfstate.mainplotwindow, get_value=index
                               gfstate.wid=index
                               gfstate.drawID=gfstate.mainplotwindow

                                ;Create a pixmap. Store its ID. Copy window contents into it.

                               Window, 20, /Pixmap, XSize=gfstate.xsize, YSize=gfstate.ysize
                               gfstate.pixID = !D.Window
                               Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.wid]

                                ;Get and store the static corner of the box.

                                ;gfstate.zoomsx = event.x
                                ;gfstate.zoomsy = event.y


                           endif ;end of datalocation[0] eq -1 check

                       endif    ;end of event.press eq 1 IF statement

                   END          ;end of DOWN case

;UP GOES HERE

                   'UP': BEGIN
     
                                ;Note to Self:  mousemover put in
                                ;to prevent from UP option from being accessed

                       if (gfstate.mousestatus eq 1 AND event.press ne 4 and gfstate.mousemover eq 'on') then begin

                           gfstate.mousestatus=0
                           gfstate.mousemover='off'

                          ; Erase the last box drawn. Destroy the pixmap.

                           widget_control, gfstate.mainplotwindow, get_value=index
                           gfstate.wid=index
                           gfstate.drawID=gfstate.mainplotwindow

                           WSet, gfstate.wid
                           Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]
      
                           ;WDelete, gfstate.pixID

                                ;Convert to current data coordinates
                           result=convert_coord(event.x, event.y, /device, /double, /to_data)
                           
                            ;Check to make sure we're not out of range
                           if (result[0] lt 0) then result[0]=0
                           if (result[0] gt gfstate.nchn-1) then result[0]=gfstate.nchn-1


                           if (gfstate.setallmode eq 'on') then begin
                             gfstate.gaussparam[gfstate.mousemark, 0:gfstate.numisolevels]=long(round(result[0]))
                           endif else begin
                             gfstate.gaussparam[gfstate.mousemark, gfstate.currentlistval]=long(round(result[0]))
                           endelse
                           ;if (gfstate.setallmode eq 'on') then begin
                           ;    gfstate.baselinevalues[0:4,gfstate.mousemark]=long(round(result[0]))
                           ;endif else begin
                           ;    gfstate.baselinevalues[gfstate.currentlistval,gfstate.mousemark]=long(round(result[0]))
                           ;endelse

                                ;print, gfstate.baselinevalues
       
                                ;reset so as not to confuse zoom motion option
                           gfstate.mousemark=-1
                           gfstate.zoom='on'
                          
                                ; Turn draw motion events off. Clear any events queued for widget.
                                ; Return mouse pointer to original state

                           Widget_Control, gfstate.drawID, Clear_Events=1

                           galflux_spectrameasure

                           curs, 'd'

                       endif

                   END          ;END OF UP CASE



                   'MOTION': BEGIN
                       if (event.press eq 0 AND gfstate.mousestatus eq 1) then begin

                                ;Here is where the baseline flag is
                                ;erased and moved 

                            ;Side to side arrows for the hi/lo channel markers
                           if (gfstate.mousemark eq 0 OR datalocation[0] eq 1 ) then begin
                               curs, 70 ;movement mouse cursor
                           endif 
          
                                ;Hand pointer if it is the peak circle
                                ;- add yrange part to determine if
                                ;near the circle
                           if (gfstate.mousemark eq 2) then begin
                                curs, 58
                           endif

                           widget_control, gfstate.mainplotwindow, get_value=index 
                           gfstate.wid=index
                           gfstate.drawID=gfstate.mainplotwindow 

                           WSet, gfstate.wid
                           Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]

                                ; Get the coodinates of the new box
                                ; element an drag circle or flagged line

                           result=convert_coord(event.x, event.y, /device, /double, /to_data)
       
                           device, decomposed=1
                           color='FFFF00'XL  ;CYAN FOR GAUSSIAN MODE

                                ;PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
                                ;   Color=color, thick=1.5

                           if (gfstate.mousemark eq 0 OR gfstate.mousemark eq 1) then begin
                              flag, long(round(result[0])), thick=2.0, color=color
                           endif

                           if (gfstate.mousemark eq 2) then begin
                              plotsym, 0,1.5
                              plots, event.x, event.y, color=color, psym=8, /device
                           endif
                           
                           if (gfstate.mousemark eq 3 OR gfstate.mousemark eq 4) then begin
                               
                               y=[-20,0,20]

                               color='00FFFF'XL ;YELLOW

                               oplot, fltarr(3)+long(round(result[0])), y, color=color, thick=2.0
                               

                           endif

                           device, decomposed=0

                       endif

                   END          ;END OF MOTION case

                  ELSE:

             ENDCASE




         endif




endif  ;END of gaussian mode tracking movement



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BASELINE TRACKING MOVEMENT

;Baseline tracking movement to move baseline options
if (gfstate.baselinestatus eq 1 AND gfstate.mode eq 'spectrameasure') then begin
    ;print, 'baseline tracking'

    

                                ;Determine if mouse pointer is over an
                                ;existing baseline marker ONLY FOR THE
                                ;CURRENT ISO VALUE!!!!!!!!
     result=convert_coord(event.x, event.y, /device, /double, /to_data)
       datalocation=where(gfstate.baselinevalues[gfstate.currentlistval,*] lt long(round(result[0]))+5 AND $
                          gfstate.baselinevalues[gfstate.currentlistval,*] gt long(round(result[0]))-5)

          

         if (datalocation[0] ne -1 ) then begin
             curs, 70   ;movement mouse cursor
         endif else begin
             curs, 'd'
         endelse 

                                ;Option used for right clicking
                                ;up/down and movement when right mouse
                                ;button is down

    if (event.type le 2 AND event.press ne 4) then begin

        eventTypes = ['DOWN', 'UP', 'MOTION']
        thisEvent = eventTypes[event.type]
        

        CASE thisEvent OF

   'DOWN': BEGIN
      if (event.press eq 1) then begin
       ; Turn motion events on for the draw widget.

           ;Turn off zoom, turn on baseline mover!
       gfstate.zoom='off'
       gfstate.mousemover='on'

         ;Add another flag to the baseline stack
          if (datalocation[0] eq -1) then begin
             ;Convert to current data coordinates
              result=convert_coord(event.x, event.y, /device, /double, /to_data)  

              ;Check to make sure we're not out of range
              if (result[0] lt 0) then result[0]=0
              if (result[0] gt gfstate.nchn-1) then result[0]=gfstate.nchn-1

                                ;Either add to each baseline set of
                                ;indices, or only the current one
              if (gfstate.setallmode eq 'on') then begin
                 for isoval=0,gfstate.numisolevels do begin
                    index=where(gfstate.baselinevalues[isoval,*] eq -1000)
                    gfstate.baselinevalues[isoval,index[0]]=long(round(result[0]))
                 endfor
              endif else begin   
                    index=where(gfstate.baselinevalues[gfstate.currentlistval,*] eq -1000)
                    gfstate.baselinevalues[gfstate.currentlistval,index[0]]=long(round(result[0]))
              endelse

              gfstate.zoom='on'
              gfstate.mousemover='off'
              
               ;reset so as not to confuse zoom motion option
              gfstate.mousemark=-1
              gfstate.zoom='on'
              galflux_plotter


          endif


       if (datalocation[0] ne -1) then begin   

      

       gfstate.mousestatus=1
       curs, 70    ;movement mouse cursor 

       ;Save mouse mark
       gfstate.mousemark=datalocation[0]

       device, decomposed=1
       flag, gfstate.baselinevalues[gfstate.currentlistval,gfstate.mousemark], thick=2.0, color='000000'XL

      widget_Control, gfstate.mainplotwindow, Draw_Motion_Events=1
      widget_control, gfstate.mainplotwindow, get_value=index
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow

      ;Create a pixmap. Store its ID. Copy window contents into it.

      Window, 20, /Pixmap, XSize=gfstate.xsize, YSize=gfstate.ysize
      gfstate.pixID = !D.Window
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.wid]

      ;Get and store the static corner of the box.

      ;gfstate.zoomsx = event.x
      ;gfstate.zoomsy = event.y


      endif ;end of datalocation[0] eq -1 check

  endif  ;end of event.press eq 1 IF statement

    END      ;end of DOWN case


 'UP': BEGIN
      
                                ;Note to Self:  mousemover put in
                                ;to prevent from UP option from being accessed

      if (gfstate.mousestatus eq 1 AND event.press ne 4 and gfstate.mousemover eq 'on') then begin

       gfstate.mousestatus=0
       gfstate.mousemover='off'

         ; Erase the last box drawn. Destroy the pixmap.

      widget_control, gfstate.mainplotwindow, get_value=index
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow

      WSet, gfstate.wid
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]
      
      

       ;WDelete, gfstate.pixID

       ;Convert to current data coordinates
       result=convert_coord(event.x, event.y, /device, /double, /to_data)


       ;Check to makes sure we're not out of bounds
       if (result[0] lt 0) then result[0]=0
       if (result[0] gt gfstate.nchn-1) then result[0]=gfstate.nchn-1

       if (gfstate.setallmode eq 'on') then begin
          gfstate.baselinevalues[0:gfstate.numisolevels,gfstate.mousemark]=long(round(result[0]))
       endif else begin
          gfstate.baselinevalues[gfstate.currentlistval,gfstate.mousemark]=long(round(result[0]))
       endelse

       ;print, gfstate.baselinevalues
       
       ;reset so as not to confuse zoom motion option
       gfstate.mousemark=-1
       gfstate.zoom='on'
 
    ; Turn draw motion events off. Clear any events queued for widget.
    ; Return mouse pointer to original state

      Widget_Control, gfstate.drawID, Clear_Events=1

      galflux_spectrameasure

      curs, 'd'

    endif

    END   ;END OF UP CASE




     'MOTION': BEGIN
       if (event.press eq 0 AND gfstate.mousestatus eq 1) then begin

         ;Here is where the baseline flag is erased and moved 
       curs, 70    ;movement mouse cursor   

      widget_control, gfstate.mainplotwindow, get_value=index 
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow 

      WSet, gfstate.wid
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]

         ; Get the coodinates of the new box and draw it. 

      ;sx = gfstate.zoomsx 
      ;sy = gfstate.zoomsy
      ;dx = event.x
      ;dy = event.y
      
     
      result=convert_coord(event.x, event.y, /device, /double, /to_data)
       
      device, decomposed=1
      color='0000FF'XL   ;RED

       ;PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
       ;   Color=color, thick=1.5

        flag, long(round(result[0])), thick=2.0, color=color

       device, decomposed=0

   endif

END  ;END OF MOTION case

ELSE:

ENDCASE



endif                 ;end of event type press definition for baseline

 


endif  ;end of baseline option check





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;High/Lo channels in Ellipse mode

;Left button clicking for marking hi/lo channels in ellipse mode
if (event.press eq 1 and gfstate.mode eq 'ellipse') then begin

    result=convert_coord(event.x, event.y, /device, /double, /to_data)
  
    ;Fill in values for galaxy marking.  Arrange in correct order

    

    if ((gfstate.lochhich[0] eq 0 AND gfstate.lochhich[1] eq 0) OR $
        (gfstate.lochhich[0] ne 0 AND gfstate.lochhich[1] ne 0)) then begin
        if (gfstate.lochhich[0] ne 0 AND gfstate.lochhich[1] ne 0) then begin
          gfstate.lochhich=[0,0]
        endif

        gfstate.lochhich[0]=long(round(result[0]))
    endif else begin
        if (gfstate.lochhich[0] ne 0 AND gfstate.lochhich[1] eq 0) then begin
          gfstate.lochhich[1]=long(round(result[0]))
          if (gfstate.lochhich[0] gt gfstate.lochhich[1]) then gfstate.lochhich=reverse(gfstate.lochhich)
        endif        
    endelse

    
    galflux_plotter

    
endif



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Systematic error channels markings - done in baseline mode

if (event.press eq 1 AND gfstate.mode eq 'syserror' AND gfstate.zoom ne 'on') then begin

if (gfstate.syserrorcount eq 0) then gfstate.syserrorchan=[0,0,0,0]


result=convert_coord(event.x, event.y, /device, /double, /to_data)

device, decomposed=1
flag, long(round(result[0])), color='DB70DB'XL
device, decomposed=0

gfstate.syserrorchan[gfstate.syserrorcount]=long(round(result[0]))
gfstate.syserrorcount++


if (gfstate.syserrorcount eq 4) then begin

;Restore the state
gfstate.baselinestatus=1
gfstate.mode='spectrameasure'
gfstate.zoom='on'
gfstate.syserrorcount=0

wait, 0.5
 
gfstate.syserrorchan=gfstate.syserrorchan[sort(gfstate.syserrorchan)]

print, gfstate.syserrorchan

endif

galflux_plotter

endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; ZOOMING in main window handled with these IF and 
;;;;;;;;;;;;;; case statements

if (gfstate.zoom eq 'on') then begin

if (event.type le 2 AND event.press ne 1) then begin

eventTypes = ['DOWN', 'UP', 'MOTION']
thisEvent = eventTypes[event.type]
gfstate.xsize=600
gfstate.ysize=400


CASE thisEvent OF

   'DOWN': BEGIN
      if (event.press eq 4) then begin
       ; Turn motion events on for the draw widget.

       gfstate.mousestatus=1
       curs, 52

      widget_Control, gfstate.mainplotwindow, Draw_Motion_Events=1
      widget_control, gfstate.mainplotwindow, get_value=index
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow

      ;Create a pixmap. Store its ID. Copy window contents into it.

      Window, 20, /Pixmap, XSize=gfstate.xsize, YSize=gfstate.ysize
      gfstate.pixID = !D.Window
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.wid]

      ;Get and store the static corner of the box.

      gfstate.zoomsx = event.x
      gfstate.zoomsy = event.y

      endif

    END      ;end of DOWN case


 'UP': BEGIN
      
      if (gfstate.mousestatus eq 1) then begin

       gfstate.mousestatus=0
       curs, 'd'

         ; Erase the last box drawn. Destroy the pixmap.

      widget_control, gfstate.mainplotwindow, get_value=index
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow

      WSet, gfstate.wid
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]
      
      ; Order the box coordinates.

      sx = Min([gfstate.zoomsx, event.x], Max=dx)
      sy = Min([gfstate.zoomsy, event.y], Max=dy)

       ;WDelete, gfstate.pixID

                                ;Reset window parameters to zoom in or
                                ;zoom out OR use the zoom box x range
                                ;values to do call the linear
                                ;interpolation function

       if (gfstate.spikerepairstatus eq 'on') then begin
           
           if (sx eq dx AND sy eq dy) then begin

               ;Do nothing
             

           endif else begin
             resultlow=convert_coord(sx, sy, /device, /double, /to_data)
             resulthigh=convert_coord(dx, dy, /device, /double, /to_data)

            if (resultlow[0] lt 0) then resultlow[0]=0
            if (resulthigh[0] gt gfstate.nchn-1) then resulthigh[0]=gfstate.nchn-1


            galflux_spikerepair, round(resultlow[0]), round(resulthigh[0])
           
          
           endelse
            ;Reset spike interpolation status flag and button option
             gfstate.spikerepairstatus='off'
             widget_control, gfstate.buttonspikerepair, set_button=0
            

         endif else begin

         if (sx eq dx AND sy eq dy) then begin

           gfstate.mainxrange=[min(gfstate.currentxarr), max(gfstate.currentxarr)]
           gfstate.mainyrange=[min(gfstate.currentyarr), max(gfstate.currentyarr)]



         endif else begin
          resultlow=convert_coord(sx, sy, /device, /double, /to_data)
          resulthigh=convert_coord(dx, dy, /device, /double, /to_data)

          if (resultlow[0] lt 0) then resultlow[0]=0
          if (resulthigh[0] gt gfstate.nchn-1) then resulthigh[0]=gfstate.nchn-1

          gfstate.mainxrange=[round(resultlow[0]), round(resulthigh[0])]
          gfstate.mainyrange=[round(resultlow[1]), round(resulthigh[1])]

        endelse

      endelse

    ; Turn draw motion events off. Clear any events queued for widget.

      Widget_Control, gfstate.drawID, Clear_Events=1

      galflux_spectrameasure

    endif

    END   ;END OF UP CASE




     'MOTION': BEGIN
       if (event.press eq 0 AND gfstate.mousestatus eq 1) then begin

         ; Here is where the actual box is drawn and erased.
         ; First, erase the last box.

           curs, 52

      widget_control, gfstate.mainplotwindow, get_value=index
      gfstate.wid=index
      gfstate.drawID=gfstate.mainplotwindow

      WSet, gfstate.wid
      Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.pixID]

         ; Get the coodinates of the new box and draw it.

      sx = gfstate.zoomsx
      sy = gfstate.zoomsy
      dx = event.x
      dy = event.y
      
     
      
       
      device, decomposed=1
      color='0000FF'XL
      linestyle=0

      if (gfstate.spikerepairstatus eq 'on') then begin
          color='00BBFF'XL
          linestyle=2
      endif

       PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
          Color=color, thick=1.5, linestyle=linestyle

       device, decomposed=0

   endif

END  ;END OF MOTION case

ELSE:

ENDCASE  ;end of zoom case statement

endif  ;End of zoom mouse click check IF statement

endif




end


;-------------------------------------------------------------
;EVENT HANDLER FOR GENERAL BUTTON EVENTS
pro galflux_event, event

common galflux_state
common gridstate


widget_control, event.id, get_uvalue=uvalue


case uvalue of

'about': begin

    galflux_about

end

'instructions': begin

    galflux_instructions

end


'ellipsecalc': begin


        gfstate.mode='ellipse'
        gfstate.baselinestatus=0
        gfstate.fitmodeon='off'
        galflux_ellipsecalc
 
               end

'spectrameasure': begin

       gfstate.mode='spectrameasure'
       galflux_spectrameasure
    

                  end



'gaussian': begin
       gfstate.currentfitmode='gaussian'   ;Set to gaussian
       galflux_spectrameasure
end


'peaks': begin
       gfstate.currentfitmode='peaks'   ;Set to Peaks
       galflux_spectrameasure
end

'baselineoption': begin

      gfstate.mode='spectrameasure'
      gfstate.fitmodeon='off'
      gfstate.baselinestatus=1
     
        
      

      galflux_spectrameasure
          
  end

'baselineremove': begin
      if (gfstate.baselineremovestatus eq 'off') then begin
          gfstate.baselineremovestatus='on'
      endif else begin
          gfstate.baselineremovestatus='off'
      endelse

    if (gfstate.mode eq 'spectrameasure' AND gfstate.baselinestatus eq 1) then galflux_spectrameasure
  end


'baselineslider': begin

    if (gfstate.mode eq 'spectrameasure' AND gfstate.baselinestatus eq 1) then galflux_spectrameasure
    

end

'baselinereset': begin
      ;Initialize baseline values

      if (gfstate.setallmode eq 'on') then begin
        gfstate.baselinevalues[*,*]=-1000
        gfstate.baseyfit[*,*]=0.0
        gfstate.basecoef[*,*]=0.0
      endif else begin
        gfstate.baselinevalues[gfstate.currentlistval,*]=-1000
         gfstate.baseyfit[*,gfstate.currentlistval]=0.0
         gfstate.basecoef[gfstate.currentlistval,*]=0.0
      endelse

    if (gfstate.mode eq 'spectrameasure' AND gfstate.baselinestatus eq 1) then galflux_spectrameasure  
    

end

'setallmode': begin
      ;Make changes to all baseline or just the current iso value
     if (gfstate.setallmode eq 'on') then begin
         gfstate.setallmode='off'
     endif else begin
         gfstate.setallmode='on'
     endelse

end

'fitmodeon': begin
      ;Turn fit mode on/off

    gfstate.mode='spectrameasure'
    gfstate.baselinestatus=0
    gfstate.fitmodeon='on'

    galflux_spectrameasure

end

'gausswidthbox': begin

    widget_control, gfstate.gausswidthbox, get_value=widthstring
    width=long(widthstring[0])

    if (gfstate.setallmode eq 'on') then begin
        gfstate.gausswidth[*]=width
    endif else begin
        gfstate.gausswidth[gfstate.currentlistvalk]=width
    endelse

    galflux_spectrameasure


end

'gaussreset': begin
        galflux_gaussreset    
    end

'peaksreset': begin
        galflux_peaksreset
end

'numberpeaks1': begin
        gfstate.np=1
        galflux_spectrameasure
end

'numberpeaks2': begin
        gfstate.np=2
        galflux_spectrameasure
    end

'galflux_save': begin
     ;Save file
      galflux_writesource
  end



'crosshairs': begin
    if (gfstate.crosshairs eq 'on') then begin
        gfstate.crosshairs='off'
    endif else begin
        gfstate.crosshairs='on'
    endelse

    galflux_spectrameasure

end

'fetchdss': begin

galflux_dssfetch



end



'imageoption': begin


end

'dss2blue': begin

galflux_opticalimage, 'dss2blue'


end

'sloan': begin

galflux_opticalimage, 'sloan'

end


'dsswindow': begin
  
ra_ell=gfstate.cen_ell_ra[gfstate.currentlistval]
dec_ell=gfstate.cen_ell_dec[gfstate.currentlistval]

if (ra_ell lt 0.0) then ra_ell=ra_ell+24.0D

getdss, ra_ell, dec_ell
   
end

'agclist': begin

    ;print, event.index

if (event.index eq 0) then begin
    gfstate.agcnum=-1

    widget_control, gfstate.agcinfo, set_value=['']
    widget_control, gfstate.digitalHIlist, set_value=['']
    gfstate.digitalHI_agcnum=-1

endif else begin
    iagc=gfstate.agcindex[event.index-1]  ;needed because of the extra -1 added to the start of the array
;strtrim(string(grid.velarr[long(round(result[0]))] , format='  (f7.2)'))
 
 ;We now have the agc index - get the
 ; information and populate the agclist LIST widget

 rahr=double(gfstate.agc.rah[iagc])+double(gfstate.agc.ram[iagc]/60.0)+double(gfstate.agc.ras10[iagc]/10.0/3600.0)
 decdeg=double(gfstate.agc.decd[iagc])+double(gfstate.agc.decm[iagc]/60.0)+double(gfstate.agc.decs[iagc]/3600.0)
  if(gfstate.agc.sign[iagc] eq '-') then decdeg=-decdeg
  
  ;print, rahr, decdeg

radecconvert, rahr, decdeg, rastring, decstring


ra_ell=gfstate.cen_ell_ra[gfstate.currentlistval]
dec_ell=gfstate.cen_ell_dec[gfstate.currentlistval]

deltara=(rahr-ra_ell)*60.0  ;minutes
deltadec=(decdeg-dec_ell)*60.0   ;arcminutes
raunits='minutes'
decunits='arcminutes'

if (abs(deltara) lt 1.0) then begin
    deltara=deltara*60.0
    raunits='seconds'
endif

if (abs(deltadec) lt 1.0) then begin
    deltadec=deltadec*60.0
    decunits='arcseconds'
endif


 glactc,rahr, decdeg, 2000, l,b,1

   outputstring=['AGC'+strcompress(gfstate.agc.agcnumber[iagc], /remove_all)+$
                  '    Type= '+strcompress(gfstate.agc.description[iagc],/remove_all)+$
                  '    a x b= '+strtrim(string(gfstate.agc.a100[iagc]/100.0, format='(f5.2)'))+' x '+$
                                strtrim(string(gfstate.agc.b100[iagc]/100.0, format='(f5.2)'))+' arcminutes',$
                  '    Other ID: '+strcompress(gfstate.agc.ngcic[iagc], /remove_all)+$
                  '          Optical coords (J2000)= '+strcompress(rastring+decstring, /remove_all), $
                  '                            Galactic coords  (l,b)= '+strcompress(l, /remove_all)+', '+strcompress(b, /remove_all)+' deg', $
                  '    Ellipse fit compare:    deltaRA=  '+strtrim(string(deltaRA, format='(f9.5)'))+' '+raunits,$
                  '                            deltaDEC= '+strtrim(string(deltaDEC, format='(f9.5)'))+' '+decunits,$
                  '    Vopt= '+strcompress(gfstate.agc.vopt[iagc],/remove_all)+' +/- '+$  
                       strcompress(gfstate.agc.verr[iagc], /remove_all)+' km/s'+$
                  '    Detcode= '+strcompress(gfstate.agc.detcode[iagc],/remove_all), $
                  '    V21= '+strcompress(gfstate.agc.v21[iagc],/remove_all)+' km/s'+$
                  '    Width= '+strcompress(gfstate.agc.width[iagc],/remove_all)+' +/- '+$
                       strcompress(gfstate.agc.widtherr[iagc], /remove_all)+' km/s', $
                  '    Flux= '+strtrim(string(gfstate.agc.flux100[iagc]/100.0, format='(f8.2)'))+' Jy km/s'+$
                  '    rms= '+strtrim(string(gfstate.agc.rms100[iagc]/100.0, format='(f8.2)'))+' mJy'] 
          
;print, outputstring        

widget_control, gfstate.agcinfo, set_value=outputstring  

;Set for header output
gfstate.agcnum=gfstate.agc.agcnumber[iagc]

;Now look for the selected AGC galaxy in the DigitalHI archive 

digitalHIindex=where(gfstate.table3.number eq gfstate.agc.agcnumber[iagc]) 

  if (digitalHIindex[0] ne -1) then begin 
      widget_control, gfstate.digitalHIlist, $ 
         set_value=[strcompress(gfstate.agc.agcnumber[iagc],/remove_all)+' - click here for Archive data.']
         gfstate.digitalHI_agcnum=gfstate.table3.number[digitalHIindex[0]]
  endif else begin
        widget_control, gfstate.digitalHIlist, set_value=['No entry available.']
        gfstate.digitalHI_agcnum=-1
  endelse 
                               
endelse
 

end 


'digitalhilist': begin


   if (gfstate.digitalHI_agcnum ne -1) then galflux_digitalHIcompare


end

'galflux_ps': begin

    galflux_ps

end

'setcustomlevel': begin

    galflux_setcustomlevel

end

'rescale': begin

widget_control, gfstate.xmin, get_value=xminstring
widget_control, gfstate.xmax, get_value=xmaxstring
widget_control, gfstate.ymin, get_value=yminstring
widget_control, gfstate.ymax, get_value=ymaxstring

gfstate.mainxrange=[long(xminstring[0]), long(xmaxstring[0])]
gfstate.mainyrange=[float(yminstring[0]), float(ymaxstring[0])]

galflux_spectrameasure


end


'peaksfit': begin

    if (gfstate.currentfitmode eq 'peaks' AND $
        gfstate.mode eq 'spectrameasure' AND $
        gfstate.baselinestatus eq 0) then galflux_peaksfit



end


'gaussfit':begin

    if (gfstate.currentfitmode eq 'gaussian' AND $
        gfstate.mode eq 'spectrameasure' AND $
        gfstate.baselinestatus eq 0) then galflux_gaussfit

end

'hanning': begin

    gfstate.hanningwin=2*event.index+1

    galflux_spectrameasure


end

'rmsmarkers': begin

    if (gfstate.rmsstatus eq 'on') then begin
        gfstate.rmsstatus='off'
    endif else begin
        gfstate.rmsstatus='on'
    endelse

    galflux_spectrameasure

end




'skymframe_1': begin

gfstate.skym=0
gfstate.skympix=1
widget_control, gfstate.buttonskymreset, set_button=0
widget_control, gfstate.buttonskymframe, set_button=1
widget_control, gfstate.buttonskymcustom, set_button=0
widget_control, gfstate.buttonskymframe_1, set_button=1
widget_control, gfstate.buttonskymframe_2, set_button=0
widget_control, gfstate.buttonskymframe_3, set_button=0
galflux_skym


end

'skymframe_2': begin

gfstate.skym=0
gfstate.skympix=2
widget_control, gfstate.buttonskymreset, set_button=0
widget_control, gfstate.buttonskymframe, set_button=1
widget_control, gfstate.buttonskymcustom, set_button=0
widget_control, gfstate.buttonskymframe_1, set_button=0
widget_control, gfstate.buttonskymframe_2, set_button=1
widget_control, gfstate.buttonskymframe_3, set_button=0
galflux_skym

end


'skymframe_3': begin

gfstate.skym=0
gfstate.skympix=3
widget_control, gfstate.buttonskymreset, set_button=0
widget_control, gfstate.buttonskymframe, set_button=1
widget_control, gfstate.buttonskymcustom, set_button=0
widget_control, gfstate.buttonskymframe_1, set_button=0
widget_control, gfstate.buttonskymframe_2, set_button=0
widget_control, gfstate.buttonskymframe_3, set_button=1
galflux_skym

end



'skymcustom': begin

gfstate.skym=1
widget_control, gfstate.buttonskymreset, set_button=0
widget_control, gfstate.buttonskymframe, set_button=0
widget_control, gfstate.buttonskymcustom, set_button=1
widget_control, gfstate.buttonskymframe_1, set_button=0
widget_control, gfstate.buttonskymframe_2, set_button=0
widget_control, gfstate.buttonskymframe_3, set_button=0
galflux_skym



end

'skymreset':begin

gfstate.skym=-1
widget_control, gfstate.buttonskymreset, set_button=1
widget_control, gfstate.buttonskymframe, set_button=0
widget_control, gfstate.buttonskymcustom, set_button=0
widget_control, gfstate.buttonskymframe_1, set_button=0
widget_control, gfstate.buttonskymframe_2, set_button=0
widget_control, gfstate.buttonskymframe_3, set_button=0
galflux_skym


end

'spikerepair': begin

if (gfstate.spikerepairstatus eq 'on') then begin
    gfstate.spikerepairstatus='off'
    widget_control, gfstate.buttonspikerepair, set_button=0
endif else begin
    gfstate.spikerepairstatus='on'
    widget_control, gfstate.buttonspikerepair, set_button=1
endelse



end


'syserror': begin

gfstate.mode='syserror'
gfstate.zoom='off'

end

'viewbothpols': begin


end

'opennavigator': begin

llx=gfstate.llx
lly=gfstate.lly
urx=gfstate.urx
ury=gfstate.ury

rahr=  (gfstate.rah[urx]-gfstate.rah[llx])/2.0+gfstate.rah[llx]
decdeg=(gfstate.dec[ury]-gfstate.dec[lly])/2.0+gfstate.dec[lly]


;print, rahr, decdeg


imagesize=(gfstate.dec[ury]-gfstate.dec[lly])*60.0   ;units of arcminutes

degperpix=(imagesize/60.0)/295.0

if (rahr lt 0.0) then rahr=24.0+rahr
if (rahr gt 24.0D) then rahr=rahr-24.0D


url='http://cas.sdss.org/astro/en/tools/chart/navi.asp?ra='+strcompress(double(rahr*15.0), /remove_all)+'&dec='+$
       strcompress(double(decdeg), /remove_all)+'&opt=glsi'

spawn, '/usr/bin/firefox -remote "openurl('+url+')"', answer

galflux_sloancentroid

end



else:

endcase  ;End of event handler case statement


end

;-------------------------------------------------------------------------------
;Controls which isophote is currently selected
pro galflux_spectralist, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue=uvalue

index=long(uvalue)



       if (index lt 7 AND index gt -1) then gfstate.currentlistval=index

       if (index eq 7 AND gfstate.numisolevels eq 7) then gfstate.currentlistval=index
       
       if (index eq 7 AND gfstate.numisolevels ne 7) then begin
         status=dialog_message('You need to define a CUSTOM level in the SETTINGS menu.')
     endif
     
     ;Reset checks to zero
     for i=0, n_elements(gfstate.isophote_widgetid)-1 do widget_control, gfstate.isophote_widgetid[i], set_button=0
     ;Set currently selected to one
     widget_control, event.id, set_button=1


       galflux_spectrameasure

                                ;  if (gfstate.mode eq
                                ;  'spectrameasure') then
                                ;  galflux_spectrameasure
       

   if (gfstate.currentfitmode eq 'peaks' AND $
        gfstate.mode eq 'spectrameasure' AND $
        gfstate.baselinestatus eq 0) then galflux_peaksfit

   if (gfstate.currentfitmode eq 'gaussian' AND $
        gfstate.mode eq 'spectrameasure' AND $
        gfstate.baselinestatus eq 0) then galflux_gaussfit     




end


;-------------------------------------------------------------------
;Optical image plotting procedure
pro galflux_opticalimage, survey

common galflux_state
common gridstate

    widget_control, gfstate.dsswindow, get_value=index
    wset, index

llx=gfstate.llx
lly=gfstate.lly
urx=gfstate.urx
ury=gfstate.ury

       
plot, [0,0], /nodata, xrange=[gfstate.rah[urx], gfstate.rah[llx]], yrange=[gfstate.dec[lly], gfstate.dec[ury]] , $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1

;Window placement numbers
;218.000      236.000      60.0015      40.0015

loadct, 1, /silent
stretch, 100,0

if (survey eq 'dss2blue') then begin
   tvscl, gfstate.dssimage, 60.0015,40.0015
endif else begin
   tv, gfstate.sloanimage,60.0015,40.0015, true=1
endelse

stretch

plot, [0,0], /nodata, xrange=[gfstate.rah[urx], gfstate.rah[llx]], yrange=[gfstate.dec[lly], gfstate.dec[ury]] , $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1, /noerase





if (gfstate.agcindex[0] ne -1) then begin

device, decomposed=1
oplot, gfstate.agc_rahr[gfstate.agcindex], gfstate.agc_decdeg[gfstate.agcindex], psym=1, color='0000FF'XL  ;RED
result=convert_coord(gfstate.agc_rahr[gfstate.agcindex], gfstate.agc_decdeg[gfstate.agcindex], /data, /double, /to_device)

xyouts,result[0,*]+6, result[1,*]-10, $
             strcompress(gfstate.agc.agcnumber[gfstate.agcindex], /remove_all), color='0000FF'XL, /device


device, decomposed=0
endif



;Pointing correction
;Added by B. Kent, December 21, 2006  

coefra=[0.0D,0.0D,0.0D,0.0D]
coefdec=coefra
gfstate.correction=0   ;for messaging - zero if no correction, 1 if there is a correction

;Current as of January 6, 2007

;UNITS in second of arc
;Correction coefficients for 3rd order poly for +8 to +16 declination range
if (gfstate.cen_ell_dec[0] gt 7.8 AND gfstate.cen_ell_dec[0] lt 16.5) then begin
coefra=[56.608498D,      -15.295846D,       1.3616687D,    -0.042068705D]
coefdec=[ -53.364512D,       16.971647D,      -1.5659715D,     0.048449057D]
;gfstate.correction=1
endif


;Correction coefficients for 3rd order poly for +24 to +28 declination range
if (gfstate.cen_ell_dec[0] gt 23.5 AND gfstate.cen_ell_dec[0] lt 28.5) then begin
coefra=[  -33386.257D,       3837.6595D,      -146.93808D,       1.8728661D]
coefdec=[   23056.414D,      -2666.3824D,       102.67591D,      -1.3165387D]
;gfstate.correction=1
endif


correction_dec_deg=dblarr(gfstate.numisolevels+1)
correction_ra_hr=dblarr(gfstate.numisolevels+1)

for i=0,gfstate.numisolevels do begin

correction_ra_arcsec=coefra[0]+coefra[1]*gfstate.cen_ell_dec[i]+coefra[2]*gfstate.cen_ell_dec[i]^2+coefra[3]*gfstate.cen_ell_dec[i]^3
correction_dec_arcsec=coefdec[0]+coefdec[1]*gfstate.cen_ell_dec[i]+coefdec[2]*gfstate.cen_ell_dec[i]^2+coefdec[3]*gfstate.cen_ell_dec[i]^3

cosdec=cos(gfstate.cen_ell_dec[i]*!dpi/180.0)
correction_dec_deg[i]=correction_dec_arcsec/3600.0
correction_ra_hr[i]=(correction_ra_arcsec/3600.0/15.0)/cosdec

endfor

device, decomposed=1
plotsym, 0
plots, gfstate.cen_ell_ra[0], gfstate.cen_ell_dec[0], psym=8, color='00FF00'XL
plots, gfstate.cen_ell_ra[0]-correction_ra_hr[0], gfstate.cen_ell_dec[0]-correction_dec_deg[0], psym=6, color='FF00FF'XL

plots, 20, 282, psym=8, color='00FF00'XL, /device
   xyouts, 26, 280, 'Measured', color='00FF00'XL, /device

plots, 100, 282, psym=6, color='FF00FF'XL, /device
   xyouts, 106, 280, 'Corrected', color='FF00FF'XL, /device

plots, 180, 282, psym=1, color='0000FF'XL, /device
   xyouts, 186, 280, 'AGC Catalog', color='0000FF'XL, /device

device, decomposed=0







widget_control, gfstate.mainplotwindow, get_value=index 
wset, index

         !x.s=gfstate.xs
         !x.margin=gfstate.xmargin
         !x.window=gfstate.xwindow
         !x.region=gfstate.xregion
         !x.range=gfstate.mainxrange
         !x.crange=gfstate.mainxrange

         !y.s=gfstate.ys
         !y.margin=gfstate.ymargin
         !y.window=gfstate.ywindow
         !y.region=gfstate.yregion
         !y.range=gfstate.mainyrange
         !y.crange=gfstate.mainyrange
         !p.clip=gfstate.pclip


end


;----------------------------------------------------- 
;Main window plot utility 
;Handles any data that needs to be plotted in the main window 
pro galflux_plotter
 
common galflux_state
common gridstate

if (gfstate.mode eq 'spectrameasure') then begin
   widget_control, gfstate.weightswindow, get_value=index
   wset, index
   plot, gfstate.wspec[*,gfstate.currentlistval], linestyle=2, $
         ytitle='Weight', xrange=gfstate.mainxrange, yrange=[0.0,1.1], $
         charsize=1.2, xstyle=1, ystyle=1, position=[0.15,0.0,0.95,0.95]
endif



widget_control, gfstate.mainplotwindow, get_value=index 
wset, index

;Apply hanning smoothing from the hanningwin value.  Changable in 
;  droplist widget - default value is 1
plot,gfstate.currentxarr,gfstate.currentyarr, $ 
          xrange=gfstate.mainxrange, $
          yrange=gfstate.mainyrange, $ 
          title=gfstate.maintitle, charsize=gfstate.charsize , $ 
          xtitle=gfstate.mainxtitle, ytitle=gfstate.mainytitle, $
          xstyle=1, ystyle=1         

;Flat NaNs


         gfstate.xs=!x.s
         gfstate.xmargin=!x.margin
         gfstate.xwindow=!x.window
         gfstate.xregion=!x.region
         
         gfstate.ys=!y.s
         gfstate.ymargin=!y.margin
         gfstate.ywindow=!y.window
         gfstate.yregion=!y.region

         gfstate.pclip=!p.clip


;widget_control, gfstate.xmin, set_value=strcompress(long(gfstate.mainxrange[0]), /remove_all)
;widget_control, gfstate.xmax, set_value=strcompress(long(gfstate.mainxrange[1]), /remove_all)
;widget_control, gfstate.ymin, set_value=strcompress(string(gfstate.mainyrange[0], format=' (f7.2)'))
;widget_control, gfstate.ymax, set_value=strcompress(string(gfstate.mainyrange[1], format=' (f7.2)'))

;Plot the NaN channels no matter what the mode
;Note you cannot do value eq !values.f_nan is not a number and does
;not respond to normal numerical operations.  Use the function finite
;instead

nanindex=where(finite(gfstate.currentyarr) eq 0)

if (nanindex[0] ne -1) then begin

device, decomposed=1

    flag, nanindex, color='7FABFF'XL  ;Beige

device, decomposed=0


endif 


;;Flag inner and outer regions for systematic error calculations
if (gfstate.mode eq 'syserror') then begin



index=where(gfstate.syserrorchan ne 0)

if(index[0] ne -1) then begin
  device,decomposed=1
  flag, gfstate.syserrorchan[index], color='DB70DB'XL
  device, decompose=0
endif


endif


if (gfstate.mode eq 'ellipse') then begin
index=where(gfstate.lochhich ne 0)
    device, decomposed=1
    if (index[0] ne -1) then begin
       flag, gfstate.lochhich[index], color='0000FF'XL ; RED
   endif
   xyouts, 5,5, 'Ellipse Fit', charsize=gfstate.charsize, $
          alignment=0.0, /device, color='0000FF'XL   ; CYAN
    device, decomposed=0
endif


;checks to see if baseline mode is on and the program is in
;spectrameasure mode
galflux_baseline

;Choose to see what fit mode is on, gaussian or peaks

if (gfstate.fitmodeon eq 'on') then begin

    ;Populate the list of AGC Objects when fit mode it turned on
     if (gfstate.agcindex[0] ne -1) then begin
         widget_control, gfstate.agclist, set_value=['Do not add an AGC galaxy',strcompress(gfstate.agc.agcnumber[gfstate.agcindex], /remove_all)]
         gfstate.agcmessage='Do not add an AGC galaxy'
     endif else begin
         widget_control, gfstate.agclist, set_value=['No galaxies found.']
         gfstate.agcmessage='No galaxies found.'
     endelse

 



if (gfstate.currentfitmode eq 'gaussian') then begin 
                                ;Check to see if main gaussian screen
                                ;parameter array is all zeros.  If so,
                                ;this is the first run, so reset

    gausscheck=where(gfstate.gaussparam ne 0)
    
    if (gausscheck[0] eq -1) then galflux_gaussreset

    device, decomposed=1
    xyouts, 5,5, 'Gaussian Fit', charsize=gfstate.charsize, $
          alignment=0.0, /device, color='FFFF00'XL   ; RED
    device, decomposed=0
    galflux_gaussian

endif

if (gfstate.currentfitmode eq 'peaks') then begin


    peakscheck=where(gfstate.peaksparam ne 0)
    if (peakscheck[0] eq -1) then galflux_peaksreset


    device, decomposed=1
    if (gfstate.np eq 1) then begin
        xyouts, 5,5, '1 Peak Fit', charsize=gfstate.charsize, $
             alignment=0.0, /device, color='FFFF00'XL   ; CYAN
    endif else begin
        xyouts, 5,5, '2 Peaks Fit', charsize=gfstate.charsize, $
             alignment=0.0, /device, color='FF00FF'XL   ; MAGENTA
    endelse
    device, decomposed=0

    galflux_peaks

endif

endif  ;end of FITMODE on IF statement


;Copy map for crosshairs

       widget_Control, gfstate.mainplotwindow, Draw_Motion_Events=1
       widget_control, gfstate.mainplotwindow, get_value=index
       gfstate.wid=index
       gfstate.drawID=gfstate.mainplotwindow

       ;Create a pixmap. Store its ID. Copy window contents into it.

       Window, 20, /Pixmap, XSize=gfstate.xsize, YSize=gfstate.ysize
       gfstate.pixID = !D.Window
       Device, Copy=[0, 0, gfstate.xsize, gfstate.ysize, 0, 0, gfstate.wid]

end


;...........................................................................
;+

pro f_ell,nbx,nby,center,axes,adeg,xind,yind

; reads in params of ellipse, returns coords of pixels within ellipse
; reads in 	center[0],center[1] = coords of center of ellipse
;		axes[0],axes[1]	    = major, minor diameters
;		adeg		    = position angle of major axis, in deg,
;				      measured counterclockwise from x
;		nbx,nby		    = size of the search box 
; returns	xind,yind	    = coords of pixels within the ellipse

x=findgen(nbx)-center[0]
y=findgen(nby)-center[1]
a=axes[0]/2.
b=axes[1]/2.
xx=rebin(x,nbx,nby)
yy=reform(y,1,nby)
yy=rebin(yy,nbx,nby)
z=(xx/a)^2+(yy/b)^2
alpha=(adeg/180.)*!pi
ap=a*b/sqrt((b*cos(alpha))^2+(a*sin(alpha))^2)
bp=a*b/sqrt((a*cos(alpha))^2+(b*sin(alpha))^2)
;cpp=(sin(alpha)*cos(alpha)/((cos(alpha))^2+(sin(alpha))^2))*(1./bp^2-1./ap^2)
cp=sin(alpha)*cos(alpha)*(1./a^2-1./b^2)
zz=(xx/ap)^2+(yy/bp)^2+2.*xx*yy*cp
;imgdisp,zz,zx=5,zy=5
indices=where(zz lt 1)
xind=indices mod nbx
yind=indices/nbx
;plots,xind,yind,psym=1
;print,ap,bp,cp,adeg

end


;.........................................................................................



;------------------------------------------------------
;Main procedure to calculate centroid ellipses
pro galflux_ellipsecalc

common galflux_state
common gridstate

widget_control, gfstate.cubewindow, get_value=index 
wset, index

 gfstate.maintitle='Spectra summed over box'
 gfstate.mainxtitle='Channel'
 gfstate.mainytitle='Summed Intensity'
 gfstate.currentyarr=gfstate.chflux

loch=gfstate.lochhich[0]
hich=gfstate.lochhich[1]

;Check x-axis boundaries
if (loch lt 0) then loch=0
if (hich gt gfstate.nchn-1) then hich=fstate.nchn-1

; COMPUTE intensity-weighted centroid in each channel map within feature

dims=size(reform(gfstate.dbox[0,*,*]),/dimensions)

for nch=loch,hich do begin
  image=reform(gfstate.dbox[nch,*,*])
  wimage=reform(gfstate.wbox[nch,*,*])
  totra=total(gfstate.rabox*image*wimage)
  totdec=total(gfstate.decbox*image*wimage)
  totdw=total(image*wimage)
  gfstate.racen[nch]=totra/totdw
  gfstate.deccen[nch]=totdec/totdw
  maxval=max(image,index)
  xpxpk=index mod dims[0]
  ypxpk=index/dims[0]
  gfstate.rapeak[nch]=gfstate.rabox[xpxpk]
  gfstate.decpeak[nch]=gfstate.decbox[ypxpk]
  gfstate.peakval[nch]=image[index]
endfor

; COMPUTE total flux map for each pix of box

scaling=abs((grid.velarr[loch]-grid.velarr[hich])/(hich-loch)) ; avg ch width in km/s
gfstate.totf=total(gfstate.dbox[loch:hich,*,*],1)*scaling

gfstate.fmax=max(gfstate.totf,index)
xpxpk=index mod dims[0]
ypxpk=index/dims[0]
ra_s_pk=gfstate.rabox[xpxpk]
dec_s_pk=gfstate.decbox[ypxpk]

;print,'Max in totf map is:',gfstate.fmax,'  at pix=[',round(xpxpk),',',round(ypxpk),']'

;widget_control, gfstate.fmaxlabel, set_value='Map max flux= '+strtrim(string(gfstate.fmax, format=' (f10.2)'))+' at pix('+$
;                                   strcompress(round(xpxpk), /remove_all)+','+strcompress(round(ypxpk), /remove_all)+')'



gfstate.iso[0:6]=[0.5*gfstate.fmax, 0.25*gfstate.fmax,100.,200.,300.,500.,1000.]



;INSERT ADDITONAL ISOPHOTE LEVELS HERE?




loadct, 1, /silent

plot, [0,0], /nodata, xrange=[n_elements(gfstate.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5,n_elements(gfstate.dbox[0,0,*])-0.5] , $
             xtitle='X pixel', ytitle='Y pixel', xstyle=1, ystyle=1


PX = !X.WINDOW * !D.X_VSIZE 
PY = !Y.WINDOW * !D.Y_VSIZE
SX = PX[1] - PX[0] + 1 
SY = PY[1] - PY[0] + 1

tvscl, reverse(congrid(gfstate.totf, sx,sy)), px[0], py[0]

;print, sx, sy, px[0], py[0]

plot, [0,0], /nodata, xrange=[n_elements(gfstate.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5, n_elements(gfstate.dbox[0,0,*])-0.5], $
             xtitle='X pixel', ytitle='Y pixel', /noerase, xstyle=1, ystyle=1

device, decomposed=1
;Mark the maximum value
plots, round(xpxpk),round(ypxpk), psym=7, symsize=2, thick=2.0, color='0000FF'XL, /data   ; Red

;PINK, GOLD, YELLOW, MAGENTA, CYAN, RED, GREEN, WHITE for custom
ellipse_colors=['00BBFF'XL, '7F7FFF'XL, '00FFFF'XL, 'FF00FF'XL, 'FFFF00'XL, '0000FF'XL, '00FF00'XL, 'FFFFFF'XL]
ellipse_labels=gfstate.spectralistvals

;Units of device coorindates
ellipse_xpos=5
ellipse_ypos=[105,90,75,60,45,30,15,-200]

if (gfstate.numisolevels eq 7) then ellipse_ypos[7]=5

xyouts, 5,120, 'Contour', /device

isomessage=strarr(8)

for i=0,gfstate.numisolevels do begin
    indices=where(gfstate.totf gt gfstate.iso[i],ncount)
    if (ncount gt 4) then begin
        
  gfstate.npixused[i]=ncount
  isomessage[i]='Isophote number: '+strcompress(i, /remove_all)+'   Number of pixels above isophote level: '+$
                strcompress(ncount, /remove_all)
  ;imgdisp,totf,zx=8,zy=8

  ellipsePts=fit_ellipse(indices,xsize=gfstate.nbx,ysize=gfstate.nby,axes=axes,orientation=orientation,center=center, npoints=500)

  oplot,ellipsePts[0,*], ellipsePts[1,*], $
         color=ellipse_colors[i], psym=3
  xyouts, ellipse_xpos, ellipse_ypos[i], ellipse_labels[i],$
           /device, color=ellipse_colors[i]

  f_ell,gfstate.nbx,gfstate.nby,center,axes,orientation,xind,yind  ; xind,yind are coords of pix within ellipse
;  plots,xind,yind,psym=3
; now must recenter beam on ellipse center
  bxarr=gfstate.deltaram*(findgen(gfstate.nbx)-center[0])
  byarr=gfstate.deltadec*(findgen(gfstate.nby)-center[1])
  bxarr=rebin(bxarr,gfstate.nbx,gfstate.nby)
  byarr=reform(byarr,1,gfstate.nby)
  byarr=rebin(byarr,gfstate.nbx,gfstate.nby)
  shifted_beam=exp(-0.5*(bxarr/gfstate.sigmax)^2)*exp(-0.5*(byarr/gfstate.sigmay)^2)
  totbeam_shifted=total(shifted_beam)

  gfstate.stot[i]=total(gfstate.totf[xind,yind])/total(shifted_beam[xind,yind])
;  col_ind=indices mod dims[0]
;  row_ind=indices/dims[0]
  for nch=0,gfstate.nchn-1 do begin
    tmp=reform(gfstate.dbox[nch,*,*])
    tmp=total(tmp[xind,yind])/total(shifted_beam[xind,yind])
    gfstate.spec[nch,i]=tmp
    tmp=reform(gfstate.wbox[nch,*,*])
    tmp=total(tmp[xind,yind])/total(shifted_beam[xind,yind])
    gfstate.wspec[nch,i]=tmp
 endfor

xyouts, 15,280,'Map max flux= '+strtrim(string(gfstate.fmax, format=' (f10.2)'))+' at pix('+$
                                   strcompress(round(xpxpk), /remove_all)+','+strcompress(round(ypxpk), /remove_all)+')', $
                                /device

    ;Divide weights by max
  gfstate.wspec[*,i]=gfstate.wspec[*,i]/max(gfstate.wspec[*,i])

  gfstate.cont[i]=total(gfstate.cbox[xind,yind]*shifted_beam[xind,yind])/total(shifted_beam[xind,yind])
  gfstate.cen_ra[i]=total(gfstate.rabox_continue[xind,yind]*gfstate.totf[xind,yind])/total(gfstate.totf[xind,yind])
  gfstate.cen_dec[i]=total(gfstate.decbox[xind,yind]*gfstate.totf[xind,yind])/total(gfstate.totf[xind,yind])
  fl=floor(center[0])
  df=center[0]-fl
  gfstate.cen_ell_ra[i]=gfstate.rabox[fl]+df*(gfstate.rabox[fl+1]-gfstate.rabox[fl])
  fl=floor(center[1])
  df=center[1]-fl
  gfstate.cen_ell_dec[i]=gfstate.decbox[fl]+df*(gfstate.decbox[fl+1]-gfstate.decbox[fl])
  gfstate.a_ell[i]=axes[0]
  gfstate.b_ell[i]=axes[1]
  gfstate.PA_ell[i]=orientation



endif else begin

gfstate.iso[i]=-1

endelse



endfor

isomessage=[isomessage,'', 'RIGHT-click to drag a zoom box.', 'LEFT-click to mark the channel edges of the detection.', $
   '','Choose the mode baseline to begin subtracting polynomial fits...']

;print, isomessage

 widget_control, gfstate.textdisplay, set_value=isomessage


;Initialize baseline values
;gfstate.baselinevalues[0]=min(gfstate.mainxrange)+5
;gfstate.baselinevalues[1]=max(gfstate.mainxrange)-5

device, decomposed=0

galflux_plotter


end


;--------------------------------------------------------
;Handles the configuration of the selected integrated profile
pro galflux_spectrameasure

common galflux_state
common gridstate

if (gfstate.mode eq 'spectrameasure') then begin

  if (gfstate.baselineremovestatus eq 'on') then begin
    gfstate.currentyarr=hans(gfstate.hanningwin, gfstate.spec[*,gfstate.currentlistval]-gfstate.baseyfit[*,gfstate.currentlistval])
  endif else begin
    gfstate.currentyarr=hans(gfstate.hanningwin, gfstate.spec[*,gfstate.currentlistval])
  endelse

  gfstate.maintitle='Profile at the '+strcompress(gfstate.spectralistvals[gfstate.currentlistval], /remove_all)+$
                  ' level'
  gfstate.mainytitle='Flux Density  [mJy]'


endif

galflux_plotter 




end 


;----------------------------------------------------------
;Baseline procedure
pro galflux_baseline

common galflux_state


if (gfstate.baselinestatus eq 1 AND gfstate.mode eq 'spectrameasure') then begin

device, decomposed=1
xyouts, 5,5, 'Baseline', charsize=gfstate.charsize, $
          alignment=0.0, /device, color='00FF00'XL   ; GREEN
device, decomposed=0

message=['BASELINE MODE', '', 'LEFT-click the map to mark baselined regions.', $
         'RIGHT-click to drag a zoom box.', 'DRAG the slider to adjust the fit order.', $
         'GALflux will fit a baseline when an even number of marks have been placed.', $
         'LEFT-click existing markers and drag to the desired positions.', $
         'Click the ISOPHOTE drop down menu to cycle through the various profiles, and', $ 
         '     examine the fits.  Click the Remove Baselines Box when completed.', $
         'Click Reset baseline to begin again.', '', $ 
         'Choose mode Measure for the next step...'] 

widget_control, gfstate.textdisplay, set_value=message


baselineindex=where(gfstate.baselinevalues[gfstate.currentlistval,*] ne -1000) 

if (baselineindex[0] ne -1) then begin
device, decomposed=1
flag, gfstate.baselinevalues[gfstate.currentlistval, baselineindex], color='00FF00'XL, thick=2.0
device, decomposed=0
endif

;Check to see if there are an even number of baseline points defined
if ((n_elements(baselineindex) mod 2) eq 0) then begin

            if (gfstate.setallmode eq 'on') then begin

            ;CHANGE ALL BASELINES

for isoval=0,gfstate.numisolevels do begin

;setbaseline mask
bmask=intarr(gfstate.nchn)

channelpos=gfstate.baselinevalues[isoval,baselineindex]
channelpos=channelpos[sort(channelpos)]

;Get current polynomial order
widget_control, gfstate.baselineslider, get_value=norder

;If there is no baseline region defined for the isoval, then doing
; the fit is not neccessary

checkforregion_index=where(channelpos ne 0)

if (checkforregion_index[0] ne -1) then begin

;Note - one line loop
for i=0,n_elements(channelpos)-1, 2 do bmask[channelpos[i]:channelpos[i+1]]=1

indb=where(bmask eq 1)
gfstate.bmask=bmask


;print, channelpos

;print, indb

     ;From flux2.pro, modified for GALflux indices
     bcoef=poly_fit(gfstate.currentxarr[indb],gfstate.spec[indb,isoval],norder[0])
     gfstate.baseyfit[*,isoval]=poly(gfstate.currentxarr,bcoef)
     gfstate.basecoef[isoval,0:norder[0]]=bcoef


 endif


 endfor  ;end of isoval for loop






 endif else begin


;CHANGE ONLY THE CURRENT BASELINE

;setbaseline mask
bmask=intarr(gfstate.nchn)

channelpos=gfstate.baselinevalues[gfstate.currentlistval,baselineindex]
channelpos=channelpos[sort(channelpos)]

;Get current polynomial order
widget_control, gfstate.baselineslider, get_value=norder

for i=0,n_elements(channelpos)/2, 2 do bmask[channelpos[i]:channelpos[i+1]]=1
indb=where(bmask eq 1)

     ;From flux2.pro, modified for GALflux indices
     bcoef=poly_fit(gfstate.currentxarr[indb],gfstate.spec[indb,gfstate.currentlistval],norder[0])
     gfstate.baseyfit[*,gfstate.currentlistval]=poly(gfstate.currentxarr,bcoef)
     gfstate.basecoef[gfstate.currentlistval,0:norder[0]]=bcoef

     


 endelse



;If the user doesn't want to actually
     ;see the baseline removal, then go
     ;ahead and over plot the baseline in green for the current iso value
     if (gfstate.baselineremovestatus eq 'off') then begin
     device, decomposed=1
     oplot,gfstate.baseyfit[*,gfstate.currentlistval], linestyle=2, thick=2.0, color='00FF00'XL
     device, decomposed=0
     endif


endif



endif ;end of baseline check statement

end



;.........................................................................................
;
pro Gaussian_measure,velarr,spec,Gpar,yfit, ch1, ch2, chr1, chr2, Gpos, Gamp, Gw, dv

common galflux_state
common gridstate

; computes Gaussian fit to spec, reads params used for previous fit and returns new params
; Input: spec		an array of spectral values
;	 velarr		an array of velocities
;	 prev		set of params used in previous fit
; Output:Gpar		set of params of this fit
;	 prev		new set of params
;	 yfit		Gauss fit array

; PREV is an array of 10 elements, containing:
;	0 ch1   first channel to fit Gauss or lo ch boundary of feature
; 	1 ch2	last  channel to fit Gauss of hi ch boundary of feature
;	2 Gpos	guess of center ch for Gaussian
;	3 Gamp	guess of Gaussiam amplitude
;	4 GW	guess of Gaussian FWHM
;	5 np	number of peaks in profile (1 or 2)
;	6 chp1	channel nr of first (or only) peak
;	7 chp2	channel nr of second peak
;	8 chr1  low ch nr for rms computation
;	9 chr2  hi  ch nr for rms computation

;	Gpar[0]=v center
;	Gpar[1]=vcen err
;	Gpar[2]=Amplitude
;	Gpar[3]=Amp err
;	Gpar[4]=HPFW km/s
;	Gpar[5]=HPFWerr
;	Gpar[6]=totS
;	Gpar[7]=totSerr
;	Gpar[8]=meanS
;	Gpar[9]=rms
;	Gpar[10]=stn0
;	Gpar[11]=stn1
;	Gpar[12]=stn2
;	Gpar[13]=stn3

; RG: 29Dec05
; Modifed by B. Kent 19Feb06

nchn=n_elements(spec)
xarr=findgen(nchn)
;ch1=prev[0]
;ch2=prev[1]
;chr1=prev[8]
;chr2=prev[9]
;Gpos=prev[2]
;Gamp=prev[3]
;Gw=prev[4]

;ans=''
;print,'Modify INPUT PARAMS? [y/n, def=n]'
;read,ans

;if (prev[3] eq 0. or ans eq 'y' or ans eq 'Y') then begin
;  print,'Prompting for Gaussian parms:'
;  Print,'    Left click for ch1 to start fit (fair baseline to left)'
;  cp, x=x, y=y
;  ch1=round(x)
;  if (ch1 lt 0.) then ch1 = 0.
;  wait, 0.5
;  Print,'    Left Click for ch2 hi boundary (fair baseline to right)'
;  cp, x=x, y=y
;  ch2=round(x)
;  if (ch2 ge nchn) then ch2 = nchn-1
;  wait, 0.5
;  Print,'    Left click on peak of feature'
;  cp,x=x,y=y
;  Gpos=round(x)
;  Gamp=y
;  wait, 0.5
;  Print,'    Enter approx HPFW in ch units'
;  read, GW
;  print,'We need to measure rms noise: flag a baseline region'
;  Print,'    Left click for chr1, lo  boundary'
;  cp, x=x, y=y
;  chr1=round(x)
;  if (chr1 lt 0.) then chr1 = 0.
;  wait, 0.5
;  Print,'    Left Click for chr2, hi boundary'
;  cp, x=x, y=y
;  chr2=round(x)
;  if (chr2 ge nchn) then chr2 = nchn-1
;endif
;---taken out by B.Kent for GUI

;----Taken out by RG
;coefInit=dblarr(12)
;coefInit[3]=Gamp
;coefInit[4]=round(Gpos)
;coefInit[5]=0.4247*GW
;coef=fitngauss(xarr,spec,1,coefInit,yfit=yfit,sigmacoef=sigmacoef,trouble=trouble)
;prev[2]=coef[4]
;prev[3]=coef[3]
;prev[4]=coef[5]/0.4247
;v1=velarr[floor(coef[4])]
;dv=abs(v1-velarr[floor(coef[4])+1])
;Gpar=fltarr(6)
;Gpar[0]=v1+(coef[4]-floor(coef[4]))*dv	; center in km/s
;Gpar[1]=sigmacoef[4]*dv			; err on center in km/s
;Gpar[2]=coef[3]				; amplitude in mJy
;Gpar[3]=sigmacoef[3]			; error on amplitude
;W50=(coef[5]/0.4247)*dv			; HPFW in km/s
;Gpar[4]=sqrt(W50^2-100.)		; HPFW in km/s, corrected for han smo
;Gpar[5]=sigmacoef[4]*dv			; error on HPFW in km/s
;end of what was taken out by RG


Gpar=fltarr(20)
nterms=3
estimates=[Gamp,Gpos,0.4247*GW]
Result=GAUSSFIT(xarr[round(ch1):round(ch2)],spec[round(ch1):round(ch2)],A, $
                estimates=estimates,nterms=nterms,sigma=sigma)
yfit=a[0]*exp(-0.5*((xarr-a[1])/a[2])^2)

;prev[0]=ch1
;prev[1]=ch2
;prev[8]=chr1
;prev[9]=chr2
;prev[2]=A[1]
;prev[3]=A[0]
;prev[4]=A[2]/0.4247
v1=velarr[floor(A[1])]
dv=abs(velarr[floor(A[1])+1]-v1)
;rms=stddev(spec[chr1:chr2])
indb=where(gfstate.bmask eq 1)
rms=stddev(spec[indb])  ;calculate over baseline region
W50=(A[2]/0.4247)*dv			; HPFW in km/s

totS=total(yfit)*dv
;chind=where(yfit gt rms,nchind)  ; chans above 1 rms level
;meanS=mean(spec[chind])          ; mean signal of chans above 1 rms level
chind=where(yfit gt 0.5*a[0],nchind)  ; chans above half power level
meanS=totS/W50         ; mean signal 
totSerr=rms*dv*sqrt(nchind)    
stn0=meanS*sqrt(nchind/4.)/rms   ; assumes han smo to half width
stn1=meanS/rms
stn2=A[0]/rms
stn3=totS/totSerr


Gpar[0]=v1-(A[1]-floor(A[1]))*dv
Gpar[1]=sigma[1]*dv
Gpar[2]=A[0]
Gpar[3]=sigma[0]
Gpar[4]=sqrt(W50^2-100.)	; HPFW in km/s, corrected for han smo
Gpar[5]=sigma[2]*dv
Gpar[6]=totS
Gpar[7]=totSerr
Gpar[8]=meanS
Gpar[9]=rms
Gpar[10]=stn0
Gpar[11]=stn1
Gpar[12]=stn2
Gpar[13]=stn3

end

;--------------------------------------------------------------------
;Gaussian fitting routine
pro galflux_gaussian

common galflux_state
common gridstate

;print, 'FIT mode on.  You are in Gaussian!' 

device, decomposed=1
color='FFFF00'XL  ;GAUSSIAN mode is CYAN
;Plot the peak as an open circle
plotsym, 0,1.5
plots, gfstate.gaussparam[2,gfstate.currentlistval], gfstate.currentyarr[gfstate.gaussparam[2,gfstate.currentlistval]], psym=8, color=color

;Plot the high/low channels far from the peak
flag, gfstate.gaussparam[0:1, gfstate.currentlistval], color=color, thick=2.0

if (gfstate.rmsstatus eq 'on') then begin

;Plot the RMS as short flags
 y=[-20,0,20]

 yellow='00FFFF'XL ;YELLOW

 oplot, fltarr(3)+gfstate.gaussparam[3,gfstate.currentlistval], y, color=yellow, thick=2.0
 oplot, fltarr(3)+gfstate.gaussparam[4,gfstate.currentlistval], y, color=yellow, thick=2.0

endif

;Plot fit if needed
if (gfstate.gaussfitcomplete[gfstate.currentlistval] eq 1) then begin

     oplot, gfstate.gaussyfit[gfstate.currentlistval, *], color=color

endif

device, decomposed=0

end  ;end of gaussian fitting routine 



;------------------------------------------
pro galflux_gaussfit

common galflux_state
common gridstate

for i=0, gfstate.numisolevels do begin

if (gfstate.iso[i] ne -1) then begin

gfstate.gaussfitcomplete[i]=1

if (gfstate.baselineremovestatus eq 'on') then begin
    currentyarr=hans(gfstate.hanningwin, gfstate.spec[*,i]-gfstate.baseyfit[*,i])
  endif else begin
    currentyarr=hans(gfstate.hanningwin, gfstate.spec[*,i])
  endelse




;Gaussian fitting code here

Gaussian_measure,grid.velarr,currentyarr,Gpar,yfit, $
          gfstate.gaussparam[0,i], gfstate.gaussparam[1,i], $
          gfstate.gaussparam[3,i], gfstate.gaussparam[4,i], $
          gfstate.gaussparam[2,i], gfstate.currentyarr[gfstate.gaussparam[2,i]], $
          gfstate.gausswidth[i], dv

gfstate.Gpars[i,*]=Gpar

gfstate.gaussyfit[i,*]=yfit

endif

endfor

Gpar=gfstate.Gpars[gfstate.currentlistval,*]


;Systematic error calculation
if (total(gfstate.syserrorchan) ne 0) then begin

widthouter=grid.velarr[gfstate.syserrorchan[0]]-grid.velarr[gfstate.syserrorchan[3]]
widthinner=grid.velarr[gfstate.syserrorchan[1]]-grid.velarr[gfstate.syserrorchan[2]]
wsyserr=((widthouter-widthinner)/((widthouter+widthinner)/2.0))/2.0   ;relative error saved


veloutermean=(grid.velarr[gfstate.syserrorchan[0]]+grid.velarr[gfstate.syserrorchan[3]])/2.0
velinnermean=(grid.velarr[gfstate.syserrorchan[1]]+grid.velarr[gfstate.syserrorchan[2]])/2.0

outerindex=where(grid.velarr gt veloutermean)
innerindex=where(grid.velarr gt velinnermean)

chmeanouter=outerindex[n_elements(outerindex)-1]
chmeaninner=innerindex[n_elements(innerindex)-1]

;;velocity spacing
dvouter=abs(grid.velarr[chmeanouter]-grid.velarr[chmeanouter+1])
dvinner=abs(grid.velarr[chmeaninner]-grid.velarr[chmeaninner+1])

;Integrate - calculate hanning smooth if turned "on"
Spec=hans(gfstate.hanningwin, gfstate.spec[gfstate.syserrorchan[0]:gfstate.syserrorchan[3],gfstate.currentlistval])
Stot_outer=total(spec)*dvouter/1000.0
Spec=hans(gfstate.hanningwin, gfstate.spec[gfstate.syserrorchan[1]:gfstate.syserrorchan[2],gfstate.currentlistval])
Stot_inner=total(spec)*dvinner/1000.0

Stot_relative_error=abs(Stot_outer-Stot_inner)/((Stot_outer+Stot_inner)/2.0)

Stot_sys_error=(Stot_relative_error*Gpar[6])/1000.0


wavg=(widthouter+widthinner)/2.0



if ((wavg-Gpar[4])/Gpar[4] gt 0.0) then begin
   secondterm=((wavg-Gpar[4])/Gpar[4]*Gpar[9]/3.0)/1000.0   ;rms units mJy to Jy
   Stot_sys_error=sqrt((Stot_sys_error)^2+(secondterm)^2)

endif


gfstate.gausssyserrors[0]=wsyserr
gfstate.gausssyserrors[1]=wsyserr/2.0
gfstate.gausssyserrors[2]=Stot_sys_error

endif

;Create strings for display
wsyserrorstring_plus=strtrim(string(gfstate.gausssyserrors[0]*Gpar[4], format='(f5.1)'))
wsyserrorstring_minus=strtrim(string(gfstate.gausssyserrors[0]/(1+gfstate.gausssyserrors[0])*Gpar[4], format='(f5.1)'))
vsyserrorstring=strtrim(string(gfstate.gausssyserrors[1]*Gpar[0], format='(f5.1)'))
Stotsyserrorstring=strtrim(string(gfstate.gausssyserrors[2], format='(f5.1)'))






;Export info to viewing screen

   name1=radec_to_name(gfstate.cen_ra[gfstate.currentlistval],gfstate.cen_dec[gfstate.currentlistval])
   name2=radec_to_name(gfstate.cen_ell_ra[gfstate.currentlistval],gfstate.cen_ell_dec[gfstate.currentlistval])
   gfstate.name[gfstate.currentlistval]=name2
   a_e=strtrim(string(gfstate.a_ell[gfstate.currentlistval],format='(f5.1)'))
   b_e=strtrim(string(gfstate.b_ell[gfstate.currentlistval],format='(f5.1)'))
   cflx=strtrim(string(gfstate.cont[gfstate.currentlistval],format='(f6.0)'))
   maxflx=strtrim(string(gfstate.fmax,format='(f6.0)'))

     posv=strtrim(string(Gpar[0],format='(f8.2)'))
     posc=strtrim(string(gfstate.gaussparam[2, gfstate.currentlistval],format='(f7.2)'))
     posver=strtrim(string(Gpar[1],format='(f6.2)'))
     Amp=strtrim(string(Gpar[2],format='(f6.1)'))
     Amper=strtrim(string(Gpar[3],format='(f5.1)'))
     FWHMv=strtrim(string(Gpar[4],format='(f7.2)'))
     FWHMc=strtrim(string(Gpar[4]/dv,format='(f6.2)'))
     FWHMver=strtrim(string(Gpar[5],format='(f6.2)'))
     totS=strtrim(string(Gpar[6]/1000.,format='(f7.2)'))
     totSerr=strtrim(string(sqrt(Gpar[7]^2+(Gpar[9]*Gpar[4]/3.)^2)/1000.,format='(f4.2)'))
     rms=strtrim(string(Gpar[9],format='(f5.2)'))
     stn0=strtrim(string(Gpar[10],format='(f6.2)'))
     stn1=strtrim(string(Gpar[11],format='(f6.2)'))
     stn2=strtrim(string(Gpar[12],format='(f6.2)'))
     stn3=strtrim(string(Gpar[13],format='(f6.2)'))
     specnr=strtrim(string(gfstate.currentlistval,format='(i2)'))
     isophot=strtrim(string(gfstate.iso[gfstate.currentlistval],format='(i5)'))
     npxused=strtrim(string(gfstate.npixused[gfstate.currentlistval],format='(i3)'))

glactc, gfstate.cen_ell_ra[gfstate.currentlistval],gfstate.cen_ell_dec[gfstate.currentlistval], 2000, l,b,1

outputstring=['GAUSSIAN FIT RESULTS', $
              '--------------------', $
              'Object: '+name2+'   Galactic(l,b)= '+strcompress(l, /remove_all)+', '+strcompress(b, /remove_all), $ 
               name1+' centroid', $
               name2+' ellipse', $ 
              'Center Velocity   ='+posv+' +/- '+posver+' +/- '+vsyserrorstring+' km/s  (channel '+posc+')',$
              'Peak Flux Density ='+Amp+' +/- '+Amper+' mJy',$
              'FWHP              ='+FWHMv+' +/- '+FWHMver+' +/- '+wsyserrorstring_plus+'/'+wsyserrorstring_minus+' km/s  ('+FWHMc+' channels)', $
              'Total Flux        ='+totS+' +/- '+totSerr+' +/- '+Stotsyserrorstring+' Jy km/s', $
              'rms               ='+rms+' mJy', $
              'S/N               ='+stn0+'  '+stn1+'  '+stn2+'  '+stn3, $
              'a_ell x b_ell     ='+a_e+' x'+b_e+ ' arcminutes', $
              'isophote('+specnr+')      ='+isophot+' mJy km/s  npix='+npxused, $
              'Continuum         ='+cflx+' mJy']

    ; xyouts,xmin+dx,ymax-dy,name2,charsize=1.3
    ; xyouts,xmin+dx,ymax-2*dy,'Center='+posv+'+/-'+posver+' km/s  (ch. '+posc+')'
    ; xyouts,xmin+dx,ymax-3*dy,'Max f ='+Amp+'+/-'+Amper+' mJy'
    ; xyouts,xmin+dx,ymax-4*dy,'FWHP  ='+FWHMv+'+/-'+FWHMver+' km/s  (ch. '+FWHMc+')'
    ; xyouts,xmin+dx,ymax-5*dy,'totS='+totS+'+/-'+totSerr+' Jy km/s'
    ; xyouts,xmin+dx,ymax-6*dy,'rms  ='+rms+' mJy'
    ; xyouts,xmin+dx,ymax-7*dy,'S/N  ='+stn0+'  '+stn1+'  '+stn2+'  '+stn3
    ; xyouts,xmax-4*dx,ymax-1*dy,name1+' centroid'
    ; xyouts,xmax-4*dx,ymax-2*dy,name2+' ellipse'
    ; xyouts,xmax-4*dx,ymax-3*dy,'a_ell x b_ell='+a_e+'x'+b_e
    ; xyouts,xmax-4*dx,ymax-4*dy,'iso('+specnr+')='+isophot+' mJy km/s  npix='+npxused
    ; xyouts,xmax-4*dx,ymax-5*dy,'Max flux in map='+maxflx
    ; xyouts,xmax-4*dx,ymax-6*dy,'cont='+cflx+' mJy'

widget_control, gfstate.textdisplay, set_value=outputstring


galflux_spectrameasure




end




;---------------------------
;Resets the screen parameters
pro galflux_gaussreset

common galflux_state
common gridstate

gfstate.gaussfitcomplete[*]=0
gfstate.gaussyfit[*,*]=0.0

;Reset parameters to estimated screen values

gfstate.gaussparam[0,*]=gfstate.lochhich[0]
gfstate.gaussparam[1,*]=gfstate.lochhich[1]
gfstate.gaussparam[2,*]=gfstate.lochhich[0]+5

widget_control, gfstate.gausswidthbox, get_value=widthstring
width=long(widthstring[0])

gfstate.gausswidth[*]=width

;Set RMS
;gfstate.gaussparam[3,*]=min(gfstate.mainxrange)+5
;gfstate.gaussparam[4,*]=((max(gfstate.mainxrange)-min(gfstate.mainxrange))/2)+min(gfstate.mainxrange)

;Set RMS - default if a baseline has not been set.  Other wise use the
;          baselined region
if (total(gfstate.baselinevalues) eq 0.0) then begin
  gfstate.gaussparam[3,*]=min(gfstate.mainxrange)+50
  gfstate.gaussparam[4,*]=min(gfstate.mainxrange)+150
endif else begin
  gfstate.gaussparam[3,*]=gfstate.baselinevalues[0,0]
  gfstate.gaussparam[4,*]=gfstate.baselinevalues[0,1]
endelse


galflux_spectrameasure

end





;..................................................................................
;
pro Peaks_measure,velarr,spec,ch1, ch2, chr1, chr2, chp1, chp2,np, Ppar, warning=warning

common galflux_state
; measures spec, reads params used for previous measure, using standard reference
; to 2 peaks (or one only), fitting line to slopes and getting v, W at given level;
; returns Ppar and updates prev (array containing parms of previous msr)
; Input: spec		an array of spectral values
;	 velarr		an array of velocities
;	 prev		set of params used in previous msr
; Output:Ppar		set of params of this Pmsr
;	 prev		new set of params

; PREV is an array of 10 elements, containing:
;	0 ch1   first channel to fit Gauss or lo ch boundary of feature
; 	1 ch2	last  channel to fit Gauss of hi ch boundary of feature
;	2 Gpos	guess of center ch for Gaussian
;	3 Gamp	guess of Gaussiam amplitude
;	4 GW	guess of Gaussian FWHM
;	5 np	number of peaks in profile (1 or 2)
;	6 chp1	channel nr of first (or only) peak
;	7 chp2	channel nr of second peak
;	8 chr1  low ch nr for rms computation
;	9 chr2  hi  ch nr for rms computation
;
; Ppar contains:
;	Ppar[0]=ch1
;	Ppar[1]=ch2
;	Ppar[2]=chp1
;	Ppar[3]=chp2
;	Ppar[4]=spec[chp1]
;	Ppar[5]=spec[chp2]
;	Ppar[6]=result1[0]
;	Ppar[7]=result1[1]
;	Ppar[8]=0.
;	Ppar[9]=result2[0]
;	Ppar[10]=result2[1]
;	Ppar[11]=0.
;	Ppar[12]=yerror1
;	Ppar[13]=yerror2
;	Ppar[14]=ch1_50
;	Ppar[15]=ch1_20
;	Ppar[16]=ch2_50
;	Ppar[17]=ch2_20
;	Ppar[18]=vch50
;	Ppar[19]=vch20
;	Ppar[20]=Wch50
;	Ppar[21]=Wch20
;	Ppar[22]=v50
;	Ppar[23]=v20
;	Ppar[24]=vcen
;	Ppar[25]=verr
;	Ppar[26]=W50
;	Ppar[27]=W20
;	Ppar[28]=Werr
;	Ppar[29]=0.
;       Ppar[30]=0.
;	Ppar[31]=totS
;	Ppar[32]=meanS
;	Ppar[33]=max([spec[chp1],spec[chp2]])
;	Ppar[34]=rms
;	Ppar[35]=totSerr
;	Ppar[36]=stn0
;	Ppar[37]=stn1
;	Ppar[38]=stn2
;	Ppar[39]=stn3

; RG: 29Dec05

nchn=n_elements(spec)
xarr=findgen(nchn)

;Taken out, BK
;ch1=prev[0]
;ch2=prev[1]
;np=prev[5]
;chp1=prev[6]
;chp2=prev[7]
;chr1=prev[8]
;chr2=prev[9]

;ans=''
;print,'Modify INPUT PARAMS? [y/n, def=n]'
;read,ans

;if (np eq 0 or ans eq 'y' or ans eq 'Y') then begin
;  print,'Prompting for Pmsr parms:'
;  askagainP:
;  Print,'    How many PEAKS in feature (1 or 2)?'
;  read,np
;  if (np lt 1 or np gt 2) then goto,askagainP
;  Print,'    Left click for ch1, lo feature boundary'
;  cp, x=x, y=y
;  ch1=round(x)
;  if (ch1 lt 0.) then ch1 = 0.
;  wait, 0.5
;  Print,'    Left Click for ch2 hi boundary'
;  cp, x=x, y=y
;  ch2=round(x)
;  if (ch2 ge nchn) then ch2 = nchn-1
;  wait, 0.5
;  Print,'    Left click on lo peak of feature'
;  cp,x=x,y=y
;  chp1=round(x)
;  wait, 0.5
;  if (np eq 2) then begin
;    Print,'    Left click on hi peak of feature'
;    cp,x=x,y=y
;    chp2=round(x)
;    wait, 0.5
;  endif else begin
;    print,'    ... using first peak for both sides'
;    chp2=chp1
;  endelse
;  print,'We need to measure rms noise: flag a baseline region'
;  Print,'    Left click for chr1, lo  boundary'
;  cp, x=x, y=y
;  chr1=round(x)
;  if (chr1 lt 0.) then chr1 = 0.
;  wait, 0.5
;  Print,'    Left Click for chr2, hi boundary'
;  cp, x=x, y=y
;  chr2=round(x)
;  if (chr2 ge nchn) then chr2 = nchn-1
;endif

; find exact ch nr of peaks

sss=max(spec[chp1-5:chp1+5],index)
chp1=chp1-5+index
if (np eq 2) then begin
  sss=max(spec[chp2-5:chp2+5],index)
  chp2=chp2-5+index
endif else begin
  chp2=chp1
endelse
if (ch1 ge chp1) then ch1=chp1-2
if (ch2 le chp2) then ch2=chp2+2

; save out a few things
Ppar=fltarr(40)
Ppar[0]=ch1
Ppar[1]=ch2
Ppar[2]=chp1
Ppar[3]=chp2
Ppar[4]=spec[chp1]
Ppar[5]=spec[chp2]

;print, chp1, chp2

; Find channel ranges for fitting feature sides

res1=min(abs(spec[ch1:chp1]-0.2*spec[chp1]),ind1)
res2=min(abs(spec[ch1:chp1]-0.8*spec[chp1]),ind2)
res3=min(abs(spec[chp2:ch2]-0.8*spec[chp2]),ind3)
res4=min(abs(spec[chp2:ch2]-0.2*spec[chp2]),ind4)
ind1=ch1+ind1
ind2=ch1+ind2
ind3=chp2+ind3
ind4=chp2+ind4
; with noisy data, it can happen that ind<ind1 or ind4<ind3, so:
if (ind2 lt ind1) then begin
  res2=min(abs(spec[ch1:ind1]-0.8*spec[chp1]),ind2)
  ind2=ch1+ind2
  if (ind2 le ind1) then ind2=chp1  ; last resort
endif
if (ind4 lt ind3) then begin
  res4=min(abs(spec[ind3:ch2]-0.8*spec[chp2]),ind4)
  ind4=ind3+ind4
  if (ind3 ge ind4) then ind3=chp2
endif

; Fit sides of profile

result1=poly_fit(xarr[ind1:ind2],spec[ind1:ind2],1,sigma=sigma1,yerror=yerror1,status=status)
yfit1=poly(xarr,result1)
if (status ne 0) then print,'fit to left side fails on status=',status
result2=poly_fit(xarr[ind3:ind4],spec[ind3:ind4],1,sigma=sigma2,yerror=yerror2,status=status)
yfit2=poly(xarr,result2)
if (status ne 0) then print,'fit to right side fails on status=',status
ch1_50 = (0.5*spec[chp1]- result1[0])/result1[1]
ch1_20 = (0.2*spec[chp1]- result1[0])/result1[1]
ch2_50 = (0.5*spec[chp2]- result2[0])/result2[1]
ch2_20 = (0.2*spec[chp2]- result2[0])/result2[1]
vch50=(ch1_50+ch2_50)/2.
Wch50=abs(ch1_50-ch2_50)
vch20=(ch1_20+ch2_20)/2.
Wch20=abs(ch1_20-ch2_20)
verr=0.5*sqrt((yerror1/result1[1])^2+(yerror2/result2[1])^2)
werr=2.*verr
; now convert to km/s

;Add four lines by BK to prevent improper indexing

if (vch20 gt n_elements(velarr)-1) then vch20=n_elements(velarr)-2
if (vch20 lt 0.0) then vch20=0.0
if (vch50 gt n_elements(velarr)-1) then vch50=n_elements(velarr)-2
if (vch50 lt 0.0) then vch50=0.0

dv=abs(velarr[vch50]-velarr[vch50+1])
v50=velarr[vch50]-(vch50-floor(vch50))*dv
v20=velarr[vch20]-(vch20-floor(vch20))*dv
W50=Wch50*dv
W20=Wch20*dv
verr=verr*dv
werr=werr*dv
vcen=total(spec[ch1:ch2]*velarr[ch1:ch2])/total(spec[ch1:ch2])

; save out some more
Ppar[6]=result1[0]
Ppar[7]=result1[1]
Ppar[8]=0.
Ppar[9]=result2[0]
Ppar[10]=result2[1]
Ppar[11]=0.
Ppar[12]=yerror1
Ppar[13]=yerror2
Ppar[14]=ch1_50
Ppar[15]=ch1_20
Ppar[16]=ch2_50
Ppar[17]=ch2_20
Ppar[18]=vch50
Ppar[19]=vch20
chsep=(velarr[ch1]-velarr[ch1+1])  ; channel separation
Ppar[20]=Wch50
Ppar[21]=Wch20
Ppar[22]=v50
Ppar[23]=v20
Ppar[24]=vcen
Ppar[26]=sqrt(W50^2-(2.*chsep)^2)	; keep it simple
Ppar[27]=sqrt(W20^2-(2.*chsep)^2)	; keep it simple
; verr and Werr are fully estimated only after S/N is known - see below

; Compute mean intensity, Stot, S/N ratios 

indb=where(gfstate.bmask eq 1)
rms=stddev(spec[indb])  ;calculate over baseline regions

;rms=stddev(spec[chr1:chr2])



totS=total(spec[ch1:ch2])*dv
meanS=mean(spec[ch1:ch2])
ch1_base = (rms - result1[0])/result1[1]  ; ch at 1 rms level
ch2_base = (rms - result2[0])/result2[1]  ; same, other side
if ((ch1_base ge ch2_base) OR (ch1_base lt 0) OR (ch2_base ge nchn-1)) then begin
  warning=1
  ch1_base=ind1
  ch2_base=ind4
endif
meanSbase=mean(spec[ch1_50:ch2_50])   ; mean value over significant signal
totSerr=rms*dv*sqrt(ch2-ch1)
smofac=W50/(2.*10.)  	; assumes resolution is 10 km/s, after han
			; note that this is W50 before correcting for instr broadening!
if (W50 gt 400.) then smofac=20.
stn0=(totS/W50)*sqrt(smofac)/rms
stn1=(totS/W50)/rms
stn2=max([spec[chp1],spec[chp2]])/rms
stn3=totS/totSerr

;save out more
Ppar[29:30]=0.
Ppar[31]=totS
Ppar[32]=meanS
Ppar[33]=max([spec[chp1],spec[chp2]])
Ppar[34]=rms
Ppar[35]=totSerr
Ppar[36]=stn0
Ppar[37]=stn1
Ppar[38]=stn2
Ppar[39]=stn3

xvar=14.-stn0
werr_floor=2.+0.08*(xvar^2)			; this is a basic stn-dependent width error
if(werr_floor gt W50/4.) then werr_floor=W50/4.	; estimated off the seat of my pants -rg
if (stn0 ge 14.) then werr_floor=2.
Ppar[25]=sqrt(verr^2+(0.5*werr_floor)^2)
Ppar[28]=sqrt(Werr^2+werr_floor^2)

; reset PREV

;prev[0]=ch1
;prev[1]=ch2
;prev[5]=np
;prev[6]=chp1
;prev[7]=chp2
;prev[8]=chr1
;prev[9]=chr2


end





;--------------------------------------------------------------------
;Peaks fitting routine
pro galflux_peaks

common galflux_state
common gridstate

;print, 'FIT mode on.  You are in Peaks!' 

;print, gfstate.peaksparam[*,gfstate.currentlistval]

;print, gfstate.peaksparam[*,gfstate.currentlistval]






;print, gfstate.peaksparam[*,gfstate.currentlistval]

device, decomposed=1
  color='FF00FF'XL  ;PEAKS mode is MAGENTA
 ;Plot the peak as an open circle
  plotsym, 0,1.5
  plots, gfstate.peaksparam[4,gfstate.currentlistval], gfstate.currentyarr[gfstate.peaksparam[4,gfstate.currentlistval]], $
          psym=8, color='FFFF00'XL   ;CYAN for lower
 
 ;Plot the high/low channels far from the peak
  flag, gfstate.peaksparam[0, gfstate.currentlistval], color='FFFF00'XL, thick=2.0   ;CYAN for lower
  flag, gfstate.peaksparam[1, gfstate.currentlistval], color=color, thick=2.0


if (gfstate.rmsstatus eq 'on') then begin
 ;Plot the RMS as short flags
  y=[-20,0,20]

  yellow='00FFFF'XL ;YELLOW
  oplot, fltarr(3)+gfstate.peaksparam[2,gfstate.currentlistval], y, color=yellow, thick=2.0
  oplot, fltarr(3)+gfstate.peaksparam[3,gfstate.currentlistval], y, color=yellow, thick=2.0

endif

 ;Plot the second point if doing two point fit
  if (gfstate.np eq 2) then $
    plots, gfstate.peaksparam[5,gfstate.currentlistval], gfstate.currentyarr[gfstate.peaksparam[5,gfstate.currentlistval]], psym=8, color=color
 

  if(gfstate.peaksfitcomplete[gfstate.currentlistval] eq 1) then begin



     a=[gfstate.Ppars[gfstate.currentlistval,6],gfstate.Ppars[gfstate.currentlistval, 7]]
     oplot,gfstate.currentxarr,poly(gfstate.currentxarr,a), color='FFFF00'XL  ;CYAN for lower
     a=[gfstate.Ppars[gfstate.currentlistval,9],gfstate.Ppars[gfstate.currentlistval,10]]
     oplot,gfstate.currentxarr,poly(gfstate.currentxarr,a), color='FF00FF'XL  ;Magenta for upper



  endif
  


device, decomposed=0











end  ;end of peaks fitting routine 


;------------------------------------------------------------------------
pro galflux_peaksfit

common galflux_state
common gridstate


warninglist=intarr(8)

for i=0, gfstate.numisolevels do begin

if (gfstate.iso[i] ne -1) then begin

gfstate.peaksfitcomplete[i]=1

if (gfstate.baselineremovestatus eq 'on') then begin
    currentyarr=hans(gfstate.hanningwin, gfstate.spec[*,i]-gfstate.baseyfit[*,i])
  endif else begin
    currentyarr=hans(gfstate.hanningwin, gfstate.spec[*,i])
  endelse



warning=0

Peaks_measure,grid.velarr,currentyarr,$
                                  gfstate.peaksparam[0, i], $
                                  gfstate.peaksparam[1, i], $
                                  gfstate.peaksparam[2, i], $
                                  gfstate.peaksparam[3, i], $
                                  gfstate.peaksparam[4, i], $
                                  gfstate.peaksparam[5, i], gfstate.np, Ppar, $
                                  warning=warning


gfstate.Ppars[i,*]=Ppar
warninglist[i]=warning

;Save the newly computed values to the screen buffer array peaksparam

gfstate.peaksparam[0, i]=Ppar[0]  ;Channel 1
gfstate.peaksparam[1, i]=Ppar[1]  ;Channel 2 
gfstate.peaksparam[4, i]=Ppar[2]  ;Lo peak channel from fit
gfstate.peaksparam[5, i]=Ppar[3]  ;High peak channel from fit



endif


endfor

Ppar=gfstate.Ppars[gfstate.currentlistval,*]
warning=warninglist[gfstate.currentlistval]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Added April 3, 2006 - calculate the systematic errors, should be done
;                      with FWHM



if (total(gfstate.syserrorchan) ne 0) then begin

widthouter=grid.velarr[gfstate.syserrorchan[0]]-grid.velarr[gfstate.syserrorchan[3]]
widthinner=grid.velarr[gfstate.syserrorchan[1]]-grid.velarr[gfstate.syserrorchan[2]]
;wsyserr50=Ppar[26]*(widthouter-widthinner)/((widthouter+widthinner)/2.0)/2.0
;wsyserr20=Ppar[27]*(widthouter-widthinner)/((widthouter+widthinner)/2.0)/2.0

wrelsyserr=((widthouter-widthinner)/((widthouter+widthinner)/2.0))/2.0
vrelsyserr=wrelsyserr/2.0

veloutermean=(grid.velarr[gfstate.syserrorchan[0]]+grid.velarr[gfstate.syserrorchan[3]])/2.0
velinnermean=(grid.velarr[gfstate.syserrorchan[1]]+grid.velarr[gfstate.syserrorchan[2]])/2.0

outerindex=where(grid.velarr gt veloutermean)
innerindex=where(grid.velarr gt velinnermean)

chmeanouter=outerindex[n_elements(outerindex)-1]
chmeaninner=innerindex[n_elements(innerindex)-1]

;;velocity spacing
dvouter=abs(grid.velarr[chmeanouter]-grid.velarr[chmeanouter+1])
dvinner=abs(grid.velarr[chmeaninner]-grid.velarr[chmeaninner+1])

;Integrate - calculate hanning smooth if turned "on"
Spec=hans(gfstate.hanningwin, gfstate.spec[gfstate.syserrorchan[0]:gfstate.syserrorchan[3],gfstate.currentlistval])
Stot_outer=total(spec)*dvouter/1000.0
Spec=hans(gfstate.hanningwin, gfstate.spec[gfstate.syserrorchan[1]:gfstate.syserrorchan[2],gfstate.currentlistval])
Stot_inner=total(spec)*dvinner/1000.0

Stot_relative_error=abs(Stot_outer-Stot_inner)/((Stot_outer+Stot_inner)/2.0)

Stot_sys_error=(Stot_relative_error*Ppar[31])/1000.0

wavg=(widthouter+widthinner)/2.0



if ((wavg-Ppar[26])/Ppar[26] gt 0.0) then begin
   secondterm=((wavg-Ppar[26])/Ppar[26]*Ppar[34]/3.0)/1000.0   ;rms units mJy to Jy
   Stot_sys_error=sqrt((Stot_sys_error)^2+(secondterm)^2)

endif


gfstate.peaksyserrors[0]=wrelsyserr
gfstate.peaksyserrors[1]=vrelsyserr
gfstate.peaksyserrors[2]=Stot_sys_error

endif

;print, 'widthouter', widthouter, ' km/s'
;print, 'widthinner', widthinner, ' km/s'
;print, 'W50sys', wsyserr50, ' km/s'
;print, 'W20sys', wsyserr20, ' km/s'
;print, 'V50sys', wsyserr50/2.0, ' km/s'
;print, 'V20sys', wsyserr20/2.0, ' km/s'
;print, 'dvouter', dvouter, ' km/s'
;print, 'dvinner', dvinner, ' km/s'
;print, 'Stot_outer', Stot_outer, ' Jy km/s'
;print, 'Stot_inner', Stot_inner, ' Jy km/s'
;print, 'Stot_sys_error', Stot_sys_error, ' Jy km/s'

;print, gfstate.peaksparam[*,gfstate.currentlistval]


;Display the returned parameters in the text display

     name1=radec_to_name(gfstate.cen_ra[gfstate.currentlistval],gfstate.cen_dec[gfstate.currentlistval])
     name2=radec_to_name(gfstate.cen_ell_ra[gfstate.currentlistval],gfstate.cen_ell_dec[gfstate.currentlistval])
     gfstate.name[gfstate.currentlistval]=name2
     a_e=strtrim(string(gfstate.a_ell[gfstate.currentlistval],format='(f5.1)'))
     b_e=strtrim(string(gfstate.b_ell[gfstate.currentlistval],format='(f5.1)'))
     cflx=strtrim(string(gfstate.cont[gfstate.currentlistval],format='(f6.0)'))
     maxflx=strtrim(string(gfstate.fmax,format='(f6.0)'))


     v50=strtrim(string(Ppar[22],format='(f7.1)'))
     v20=strtrim(string(Ppar[23],format='(f7.1)'))
     vcen=strtrim(string(Ppar[24],format='(f7.1)'))
     verr=strtrim(string(Ppar[25],format='(f4.1)'))
     W50=strtrim(string(Ppar[26],format='(f5.1)'))
     W20=strtrim(string(Ppar[27],format='(f5.1)'))
     Werr=strtrim(string(Ppar[28],format='(f5.1)'))
     totS=strtrim(string(Ppar[31]/1000.,format='(f7.2)'))
     meanS=strtrim(string(Ppar[32],format='(f7.2)'))
     rms=strtrim(string(Ppar[34],format='(f5.2)'))
     totSerr=strtrim(string(sqrt(Ppar[35]^2+(Ppar[34]*Ppar[26]/3.)^2)/1000.,format='(f4.2)'))
     stn0=strtrim(string(Ppar[36],format='(f6.2)'))
     stn1=strtrim(string(Ppar[37],format='(f6.2)'))
     stn2=strtrim(string(Ppar[38],format='(f6.2)'))
     stn3=strtrim(string(Ppar[39],format='(f6.2)'))
     specnr=strtrim(string(gfstate.currentlistval,format='(i2)'))
     isophot=strtrim(string(gfstate.iso[gfstate.currentlistval],format='(i5)'))
     npxused=strtrim(string(gfstate.npixused[gfstate.currentlistval],format='(i3)'))

     sysw50err_plus=strtrim(string(gfstate.peaksyserrors[0]*Ppar[26], format='(f5.1)'))
     sysw50err_minus=strtrim(string(gfstate.peaksyserrors[0]/(1+gfstate.peaksyserrors[0])*Ppar[26], format='(f5.1)'))
     sysw20err_plus=strtrim(string(gfstate.peaksyserrors[0]*Ppar[27], format='(f5.1)'))
     sysw20err_minus=strtrim(string(gfstate.peaksyserrors[0]/(1+gfstate.peaksyserrors[0])*Ppar[27], format='(f5.1)'))
     sysv50err=strtrim(string(gfstate.peaksyserrors[1]*Ppar[26], format='(f4.1)'))
     sysv20err=strtrim(string(gfstate.peaksyserrors[1]*Ppar[27], format='(f4.1)')) 
     systotSerr=strtrim(string(gfstate.peaksyserrors[2], format='(f5.3)')) 

;Added by BK at request of RG
     totSmap=strtrim(string(gfstate.stot[gfstate.currentlistval]/1000.,format='(f7.2)'))

if (gfstate.np eq 1) then peaktitle='1 Peak  FIT RESULTS'
if (gfstate.np eq 2) then peaktitle='2 Peaks FIT RESULTS'

if (warning eq 1) then begin
    peaktitle=peaktitle+'   (WARNING: Questionable measurement of peaks... )'
endif

glactc, gfstate.cen_ra[gfstate.currentlistval],gfstate.cen_dec[gfstate.currentlistval], 2000, l,b,1

outputstring=[peaktitle, $
           '----------------------------------', $
           'Object: HI'+name2+'   Galactic(l,b)= '+strcompress(l, /remove_all)+', '+strcompress(b, /remove_all), $
           'Ellipse:  '+ name2+'   Centroid: '+name1, $
           'V20                ='+v20+' +/-'+verr+' +/- '+sysv20err+'  km/s',$
           'W20                = '+W20+' +/-'+Werr+' +/- '+sysw20err_plus+'/'+sysw20err_minus+'  km/s', $
           'V50                ='+v50+' +/-'+verr+' +/- '+sysv50err+'  km/s', $
           'W50                = '+W50+' +/-'+Werr+' +/- '+sysw50err_plus+'/'+sysw50err_minus+'  km/s', $
           'Total Flux Profile = '+totS+' +/- '+totSerr+' +/- '+systotSerr+' Jy km/s    Map= '+totSmap+ ' Jy km/s', $
           'Mean Flux Density  ='+meanS+' mJy          rms ='+rms+' mJy', $
           'S/N                ='+stn0+'  '+stn1+'  '+stn2+'  '+stn3 , $           
           'a_ell x b_ell      ='+a_e+' x'+b_e+' arcminutes', $
           'iso('+specnr+')            ='+isophot+' mJy km/s  ', $
           'Continuum          ='+cflx+' mJy']

    
widget_control, gfstate.textdisplay, set_value=outputstring 


galflux_spectrameasure



end




;--------------------------------------------------------------------
;Write source to disk
pro galflux_writesource, tempfile=tempfile

common galflux_state
common gridstate

result='No'

;print, gfstate.agcnum
;print, gfstate.agcmessage

if (gfstate.agcnum eq -1 AND gfstate.agcmessage eq 'Do not add an AGC galaxy' ) then begin 

    result=dialog_message('You have not selected an AGC.  Do you wish to add one to the file header?', /question) 

endif 

if (result eq 'No') then begin


loch=min(gfstate.lochhich)
hich=max(gfstate.lochhich)
srcname=gfstate.name[0]

gridgen={name:grid.name, 	$
	nxpix:gfstate.nx,        	$
        nypix:gfstate.ny,        	$
        nchn:gfstate.nchn,       	$
        rahr:gfstate.rah,        	$
        decdeg:gfstate.dec,		$
        velarr:grid.velarr,	$
 	deltara:grid.deltara,	$
	deltadec:grid.deltadec,	$
	box_llx:gfstate.llx,		$
 	box_lly:gfstate.lly,		$
	box_urx:gfstate.urx,		$
	box_ury:gfstate.ury}

srccube={nbx:gfstate.nbx,		$
	nby:gfstate.nby,		$
	nbz:(hich-loch+1),	$
	RAbox:gfstate.rabox,		$
	Decbox:gfstate.Decbox,		$
	Velbox:grid.velarr[loch:hich],$
	dbox:gfstate.dbox[loch:hich,*,*],$
	wbox:gfstate.wbox[loch:hich,*,*],$
	cbox:gfstate.cbox,		$
	RAcen:gfstate.racen[loch:hich],		$
	Deccen:gfstate.deccen[loch:hich],	$
	RAPeak:gfstate.rapeak[loch:hich],	$
	DecPeak:gfstate.decpeak[loch:hich],	$
	PeakVal:gfstate.peakval[loch:hich],	$
	totf:gfstate.totf}

if (gfstate.agcnum eq -1) then begin
    agcnr=''
    agcname=''
    RA_opt=gfstate.RA_opt
    Dec_opt=gfstate.Dec_opt
endif else begin

    agcindex=where(gfstate.agc.agcnumber eq gfstate.agcnum)

    RA_opt=double(gfstate.agc.rah[agcindex])+double(gfstate.agc.ram[agcindex])/double(60.0)+double(gfstate.agc.ras10[agcindex])/(10.0D)/3600.0D
    Dec_opt=abs(double(gfstate.agc.decd[agcindex]))+double(gfstate.agc.decm[agcindex])/double(60.0)+double(gfstate.agc.decs[agcindex])/3600.0D
   
    if(gfstate.agc.sign[agcindex] eq '-') then Dec_opt=-Dec_opt
   

    agcnr=strcompress(gfstate.agcnum, /remove_all)
    agcname=strcompress(gfstate.agc.ngcic[agcindex], /remove_all)
    


endelse

indexcomments=where(gfstate.comments eq '')
if (indexcomments[0] ne -1) then begin
    comments=gfstate.comments[0:indexcomments[0]]
endif else begin
    comments=['No comments for this entry.']
endelse

;Added by B. Kent, December 21, 2006  

coefra=[0.0D,0.0D,0.0D,0.0D]
coefdec=coefra
gfstate.correction=0   ;for messaging - zero if no correction, 1 if there is a correction

;Current as of January 6, 2007

;UNITS in second of arc
;Correction coefficients for 3rd order poly for +8 to +16 declination range
if (gfstate.cen_ell_dec[0] gt 7.8 AND gfstate.cen_ell_dec[0] lt 16.5) then begin
coefra=[56.608498D,      -15.295846D,       1.3616687D,    -0.042068705D]
coefdec=[ -53.364512D,       16.971647D,      -1.5659715D,     0.048449057D]
gfstate.correction=1
endif


;Correction coefficients for 3rd order poly for +24 to +28 declination range
if (gfstate.cen_ell_dec[0] gt 23.5 AND gfstate.cen_ell_dec[0] lt 28.5) then begin
coefra=[  -33386.257D,       3837.6595D,      -146.93808D,       1.8728661D]
coefdec=[   23056.414D,      -2666.3824D,       102.67591D,      -1.3165387D]
gfstate.correction=1
endif


correction_dec_deg=dblarr(gfstate.numisolevels+1)
correction_ra_hr=dblarr(gfstate.numisolevels+1)

for i=0,gfstate.numisolevels do begin

correction_ra_arcsec=coefra[0]+coefra[1]*gfstate.cen_ell_dec[i]+coefra[2]*gfstate.cen_ell_dec[i]^2+coefra[3]*gfstate.cen_ell_dec[i]^3
correction_dec_arcsec=coefdec[0]+coefdec[1]*gfstate.cen_ell_dec[i]+coefdec[2]*gfstate.cen_ell_dec[i]^2+coefdec[3]*gfstate.cen_ell_dec[i]^3

cosdec=cos(gfstate.cen_ell_dec[i]*!dpi/180.0)
correction_dec_deg[i]=correction_dec_arcsec/3600.0
correction_ra_hr[i]=(correction_ra_arcsec/3600.0/15.0)/cosdec

;print, 'ra sec ', correction_ra_hr

endfor

;Note to self
;0.25 degrees per minute at the equator
;deltaram=0.25*grid.deltara*cosdec   deltaram is in units of arcminutes

for i=0,gfstate.numisolevels do begin
;  ns=ind[i]

if (gfstate.iso[i] ne -1) then begin

   ns=i
  spectrum=    {name:gfstate.name[ns],			$
		agcnr:agcnr[0],	$
                agcname:agcname[0],			$
		NGC:'',				$
		IC:'',				$
		twomass:'',			$
		SDSS:'',			$
		Other:'',			$
		type:'integrated',		$
		coord_epoch:'2000',		$
		isophot:gfstate.iso[ns],		$
		RA_centroid:gfstate.cen_ra[ns],		$
		Dec_centroid:gfstate.cen_dec[ns],	$
		RA_ell:gfstate.cen_ell_ra[ns]-correction_ra_hr[ns],		$
		Dec_ell:gfstate.cen_ell_dec[ns]-correction_dec_deg[ns],	$
		a_ell:gfstate.a_ell[ns],		$
		b_ell:gfstate.b_ell[ns],		$
		PA_ell:gfstate.PA_ell[ns],		$
		npix_ell:gfstate.npixused[ns],		$
		map_maxflx:gfstate.fmax,		$
		RA_opt:RA_opt,			$  ;From AGC
		Dec_opt:Dec_opt,		$  ;From AGC
		feed:0L,			$
		strip:0L,			$
		nrec:0L,			$
		npol:3L,			$
		d_file:lonarr(3),		$
		nchn:gfstate.nchn,			$
		cen_f:0.,			$
		cen_v:0.,			$
		restfrq:1420.4058,		$
		cen_ch:0L,			$
		ch_fwidth:0.02441406D,		$
		heliovelproj:0.D,		$
		nchlo:loch,			$
		nchhi:hich,			$
		vcen:[gfstate.Ppars[ns,22],gfstate.Ppars[ns,23],gfstate.Ppars[ns,24],gfstate.Gpars[ns,0],0.,0.,0.,0.],		$
		vcenerr_stat:[gfstate.Ppars[ns,25],gfstate.Ppars[ns,25],gfstate.Ppars[ns,25],gfstate.Gpars[ns,1],0.,0.,0.,0.],	$
		vcenerr_sys:[gfstate.peaksyserrors[1],gfstate.peaksyserrors[1],gfstate.peaksyserrors[1],gfstate.gausssyserrors[1],0.,0.,0.,0.],		$ ;Systematic errors are recorded as relative errrors
		width:[gfstate.Ppars[ns,26],gfstate.Ppars[ns,27],0.,gfstate.Gpars[ns,4],0.,0.,0.,0.],		$
		widtherr:[gfstate.Ppars[ns,28],gfstate.Ppars[ns,28],0.,gfstate.Gpars[ns,5],gfstate.peaksyserrors[0],gfstate.gausssyserrors[0],0.,0.],	$   ;syserrors are relative errors
		pks_nch:[gfstate.Ppars[ns,2],gfstate.Ppars[ns,3]],	$
		pks_flx:[gfstate.Ppars[ns,4],gfstate.Ppars[ns,5]],	$
		slope_coeff_lo:[gfstate.Ppars[ns,6],gfstate.Ppars[ns,7],gfstate.Ppars[ns,8]],		$
		slope_coeff_hi:[gfstate.Ppars[ns,9],gfstate.Ppars[ns,10],gfstate.Ppars[ns,11]],		$
		msr_modes:['502P','202P','centroid','Gauss','','','',''],	$
		mean_flx:gfstate.Ppars[ns,32],		$
		peak_flx:[gfstate.Ppars[ns,33],gfstate.Gpars[ns,2]],	$
		peak_flx_ch:0L,			$
		flux_int_map:gfstate.stot[ns],		$
		flux_map_err_stat:0.,		$
		flux_map_err_sys:0.,		$
		flux_int_specP:gfstate.Ppars[ns,31],	$
		flux_specP_err_stat:gfstate.Ppars[ns,35],$
                flux_specP_err_sys:gfstate.peaksyserrors[2], $
;		flux_specP_err_sys:gfstate.Ppars[ns,34]*gfstate.Ppars[ns,26]/3.,	$ assume 1/3 of rms*W50
		flux_int_specG:gfstate.Gpars[ns,6],	$
		flux_specG_err_stat:gfstate.Gpars[ns,7],$
                flux_specG_err_sys:gfstate.gausssyserrors[2], $
;		flux_specG_err_sys:gfstate.Gpars[ns,9]*gfstate.Gpars[ns,4]/3.,		$ assume 1/3 of rms*W50
		peak_abs:0.,			$
		peak_abs_err:0.,		$
		taudv_int:0.,			$
		taudv_int_err:0.,		$
		continuum:gfstate.cont[ns],		$
		rmsP:gfstate.Ppars[ns,34],		$
		rmsG:gfstate.Gpars[ns,9],		$
		ston:[gfstate.Ppars[ns,36],gfstate.Ppars[ns,37],gfstate.Ppars[ns,38],gfstate.Ppars[ns,39],$
                      gfstate.Gpars[ns,10],gfstate.Gpars[ns,11],gfstate.Gpars[ns,12],gfstate.Gpars[ns,13]],$
		smo:3,				$
		detcode:[1,0,0,0],		$
		grid_name:grid.name,		$
		grid_mode:'Gauss',		$
		grid_parms:[2.0,0,0,0.],	$
		grid_smo:3L,			$
		grid_deltara:grid.deltara,	$
		grid_deltadec:grid.deltadec,	$
		phot_mode:3,			$
		phot_npix:gfstate.npixused[ns],		$
		phot_box:lonarr(4),		$
		phot_rad:0.,			$
		phot_ell_a:gfstate.a_ell[ns],		$
		phot_ell_b:gfstate.b_ell[ns],		$
		phot_ell_pa:gfstate.PA_ell[ns],		$
		baseline:reform(gfstate.basecoef[ns,*]),$
		xmin:0.,			$
		xmax:0.,			$
		ymin:-gfstate.Ppars[4]*0.5,			$
		ymax:gfstate.Ppars[4]*1.5,			$
		yunits:0,			$
		x_int:lonarr(16),		$
		x_flt:fltarr(16),		$
		x_dbl:dblarr(8),		$
		x_str:strarr(16),		$
		comments:comments[0],		$
		date_of_red:systime(0),		$
		name_of_red:'e.g. BK',		$
		mjd:0.D,			$
		velarr:grid.velarr,		$
		spec:hans(gfstate.hanningwin, reform(gfstate.spec[*,ns]-gfstate.baseyfit[*,ns])),	$
		weight:reform(gfstate.wspec[*,ns])}
  if(i eq 0) then begin
    spectra=spectrum
  endif else begin
    spectra=[spectra,spectrum]
endelse

end


end




src={srcname:srcname,	$
     gridgen:gridgen,	$
     srccube:srccube,	$
     spectra:spectra, $
     comments:comments}

if (keyword_set(tempfile)) then begin
    filename='~/temp1138bk.src'
endif else begin
    if (grid.czmin eq -2000.0) then suffix='a'
    if (grid.czmin eq 2500.0) then suffix='b'
    if (grid.czmin eq 7200.0) then suffix='c'
    if (grid.czmin eq 12100.0) then suffix='d'

    filename='HI'+strcompress(srcname, /remove_all)+'_'+strcompress(grid.name, /remove_all)+suffix+'.src'
    ;filename=string(srcname,format='("HI",a15,"_"+grid.name+".src")')

    check=findfile('checklist.txt', count=count)

                                ;Open file and append to it the new
                                ;object.  Gridview will read this file
    if (count eq 1) then begin
       openw, lun, 'checklist.txt', /append, /get_lun

       vcen=gfstate.Ppars[0,22]
       width=gfstate.Ppars[0,26]

       if(vcen eq 0.0) then vcen=gfstate.Gpars[0,0]
       if(width eq 0.0) then width=gfstate.Gpars[0,4]
       

       printf, lun, strcompress(gfstate.cen_ra[0], /remove_all)+','+$
                    strcompress(gfstate.cen_dec[0], /remove_all)+','+$
                    strcompress(vcen, /remove_all)+','+$
                    strcompress(width, /remove_all)

       close, lun
       free_lun, lun

    endif else begin

        openw, lun, 'checklist.txt', /get_lun

                                ;Dummy line so that when gridview
                                ;opens the file it has something to read
       
        vcen=gfstate.Ppars[0,22]
        width=gfstate.Ppars[0,26]

       if(vcen eq 0.0) then vcen=gfstate.Gpars[0,0]
       if(width eq 0.0) then width=gfstate.Gpars[0,4]

       printf, lun, strcompress(gfstate.cen_ra[0], /remove_all)+','+$
                    strcompress(gfstate.cen_dec[0], /remove_all)+','+$
                    strcompress(vcen, /remove_all)+','+$
                    strcompress(width, /remove_all)
        

       close, lun
       free_lun, lun

    endelse

endelse

;Added by BK January 21, 2007.  Quality code added to the source file
src.spectra[0].x_int[0]=gfstate.currentcode

save,src,file=filename

delvarx, src

endif


end

;---------------------------
;Resets the screen parameters
pro galflux_peaksreset

common galflux_state
common gridstate

gfstate.peaksfitcomplete[*]=0

;Reset parameters to estimated screen values

;lo / hi channels
gfstate.peaksparam[0,*]=gfstate.lochhich[0]
gfstate.peaksparam[1,*]=gfstate.lochhich[1]


;Set RMS - default if a baseline has not been set.  Other wise use the
;          baselined region
if (total(gfstate.baselinevalues) eq 0.0) then begin
  gfstate.peaksparam[2,*]=min(gfstate.mainxrange)+50
  gfstate.peaksparam[3,*]=min(gfstate.mainxrange)+150
endif else begin
  gfstate.peaksparam[2,*]=gfstate.baselinevalues[0,0]
  gfstate.peaksparam[3,*]=gfstate.baselinevalues[0,1]
endelse


; lo / hi peak marker
gfstate.peaksparam[4,*]=gfstate.lochhich[0]+10
gfstate.peaksparam[5,*]=gfstate.lochhich[1]-10

;gfstate.peaksparam[4,*]=where(gfstate.currentyarr eq max(gfstate.currentyarr[min(gfstate.mainxrange):max(gfstate.mainxrange)]))-5
;gfstate.peaksparam[5,*]=where(gfstate.currentyarr eq max(gfstate.currentyarr[min(gfstate.mainxrange):max(gfstate.mainxrange)]))+5





galflux_spectrameasure



end

;----------------------------------------------------
pro galflux_setcustomlevel

common galflux_state

if (not (xregistered('galflux_setcustomlevel', /noshow))) then begin

    customtitle = strcompress('Set CUSTOM iso level')

    custom_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = customtitle, $
                             uvalue = 'custom_base')

    mainbase=widget_base(custom_base, /row)

    label=widget_label(mainbase, value='Enter CUSTOM iso level: ')
    gfstate.custom_text = widget_text(mainbase, value = '50', xsize = 5, ysize = 1, /editable)
    
    custom_set = widget_button(custom_base,    value ='   Set  ', uvalue='custom_set')
    custom_reset = widget_button(custom_base,  value ='  Reset ', uvalue='custom_reset')
    custom_cancel = widget_button(custom_base, value =' Cancel ', uvalue='custom_cancel')

    widget_control, custom_base, /realize
    xmanager, 'galflux_setcustomlevel', custom_base, /no_block
    
endif






end

;----------------------------------------------------
pro galflux_setcustomlevel_event, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue=uvalue

case uvalue of

'custom_set': begin
    gfstate.numisolevels=7   ;
    widget_control, gfstate.custom_text, get_value=isostring
    iso=float(isostring[0])
    gfstate.iso[7]=iso

end

'custom_reset': begin
    gfstate.numisolevels=6
end

'custom_cancel': begin

end

else:

endcase


widget_control, event.top, /destroy


end




;----------------------------------------------------- 
;Exit event handler  
pro galflux_exit, event  

common galflux_state
common gridview_state

common gridstate
hor
ver
!p.multi=0

;Reset Cursor
widget_control, gfstate.mainplotwindow, get_value=index
wset, index
curs, 'd'

widget_control, gfstate.baseID, /destroy
loadct, 0, /silent
stretch, 0,100

;Reset cursor
;window, /free, retain=2
;curs, 'd'
;wdelete, !d.window

delvarx, gfstate

widget_control, state.baseID, /sensitive

print, 'Exiting GALflux...'

end


;-----------------------------------------------------
;Pop-up window to compare measure spectrum 
;     against the digitalHI archive

pro galflux_digitalHIcompare

common galflux_state
common gridstate
                agcnumber=gfstate.digitalhi_agcnum

                agcint=long(agcnumber[0])

                if (agcint lt 10) then filename='00000'+strcompress(agcint, /remove_all)
                if (agcint ge 10 AND agcint lt 100) then filename='0000'+strcompress(agcint, /remove_all)
                if (agcint ge 100 AND agcint lt 1000) then filename='000'+strcompress(agcint, /remove_all)
                if (agcint ge 1000 AND agcint lt 10000) then filename='00'+strcompress(agcint, /remove_all)
                if (agcint ge 10000 AND agcint lt 100000) then filename='0'+strcompress(agcint, /remove_all)
                if (agcint ge 100000) then filename=strcompress(agcint, /remove_all)
                
                ;URL for HI Archive
                url='http://128.84.3.248/hiarchive/spectra/A'+filename+'.xml'

                spawn, 'wget -q -O ~/A'+ filename + ".xml '" + url + "'"                             
                
                exists=file_test('~/junk1138.xml')
     
                IF exists eq 1  THEN BEGIN
                    spawn, '/bin/rm -r ~/junk1138.xml'
                ENDIF 
               
                spawn, "sed -e 's/<VOTABLE.*>/<VOTABLE>/g' ~/A" +filename+".xml > ~/junk1138.xml"           
                spawn, 'echo $HOME', homedir
                



                readvot, homedir[0]+'/junk1138.xml', archivefile

                ;restore, '/home/dorado3/galaxy/digitalhi/hisrc/A'+filename+'.hisrc'

	        ;readhisfile, state.master.srcname[masterindex], $
                ;             state.master.hisfile[masterindex], $
                ;             state.master.ordloc[masterindex], $
                ;             spect0=spect0, vel=vel, base=base, channels=channels, $
 		;	     smin=smin, smax=smax
                
                smin=min(archivefile.fluxdensity)
                smax=max(archivefile.fluxdensity)
                spectrum=archivefile.fluxdensity
                channels=n_elements(archivefile)
                base=archivefile.baseline
                vel=archivefile.vhelio
                
                spawn, '/bin/rm -r ~/A'+filename+'.xml'
                spawn, '/bin/rm -r ~/junk1138.xml'

                ;smin=hisrc.smin
                ;smax=hisrc.smax
                ;spectrum=hisrc.spectrum
                ;channels=hisrc.channels
                ;bandwidth=hisrc.bandwidth
                ;lastv=hisrc.lastv
                ;firstv=hisrc.firstv
                ;restfreq=hisrc.restfreq
                ;coeff=hisrc.coeff
                ;order=hisrc.order

                ;GETF.F way - reconstruct 
                ;DELTAV=LASTV-FIRSTV/(CHANNELS-1.)
                ;DELTAF=BANDWIDTH/CHANNELS
                ;SPEED=double(299792.458)
                ;z=double(FIRSTV/SPEED)
                ;FIRSTF=RESTFREQ/(1.+z)
                ;DELTAV=(LASTV-FIRSTV)/(CHANNELS)
                ;VCENTV=FIRSTV+((CHANNELS/2.)-1)*DELTAV

                ;vel=dblarr(2048)
                ;freq=dblarr(2048)
                ;base=dblarr(2048)
                

                ;for i=0,channels-1 do begin
                ;    freq[i]=firstf-deltaf*i
                ;    z=(restfreq/freq[i])-1.0
                ;    vel[i]=speed*z
                ;endfor

                ;m=-1
                ;for i=0, channels-1 do begin
                ;    m++
                ;    base[m]=coeff[0]
                ;    for j=1, order do base[m]=base[m]+coeff[j]*float(i)^j                    
                ;endfor
                

                


if (not (xregistered('galflux_digitalHIcompare', /noshow))) then begin

    comparetitle = strcompress('Compare with the Digital HI Archive')

    compare_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = comparetitle, $
                             uvalue = 'compare_base')

    mainbase=widget_base(compare_base, /row, xsize=900, ysize=700)

    comparedisplay=widget_draw(mainbase, xsize=500, ysize=695, /frame, $
                                       uvalue='comparedisplay')

    compare_text = widget_text(mainbase, value = ['Info goes here'], xsize = 60, ysize = 50)
    
    compare_done = widget_button(compare_base, value = ' Done ', uvalue = 'compare_done')

    widget_control, compare_base, /realize
    xmanager, 'galflux_digitalHIcompare', compare_base, /no_block
    
endif

table3index=where(gfstate.table3.number eq agcint)

;Populate text display with information
;FIRST - ALL FWHM VALUES from ALFALFA grid data

Ppar=gfstate.Ppars[0,*]

     name1=radec_to_name(gfstate.cen_ra[0],gfstate.cen_dec[0])
     name2=radec_to_name(gfstate.cen_ell_ra[0],gfstate.cen_ell_dec[0])
     gfstate.name[0]=name2
     a_e=strtrim(string(gfstate.a_ell[0],format='(f5.1)'))
     b_e=strtrim(string(gfstate.b_ell[0],format='(f5.1)'))
     cflx=strtrim(string(gfstate.cont[0],format='(f6.0)'))
     maxflx=strtrim(string(gfstate.fmax,format='(f6.0)'))


     v50=strtrim(string(Ppar[22],format='(f7.1)'))
     v20=strtrim(string(Ppar[23],format='(f7.1)'))
     vcen=strtrim(string(Ppar[24],format='(f7.1)'))
     verr=strtrim(string(Ppar[25],format='(f4.1)'))
     W50=strtrim(string(Ppar[26],format='(f5.1)'))
     W20=strtrim(string(Ppar[27],format='(f5.1)'))
     Werr=strtrim(string(Ppar[28],format='(f5.1)'))
     totS=strtrim(string(Ppar[31]/1000.,format='(f7.2)'))
     meanS=strtrim(string(Ppar[32],format='(f7.2)'))
     rms=strtrim(string(Ppar[34],format='(f5.2)'))
     totSerr=strtrim(string(sqrt(Ppar[35]^2+(Ppar[34]*Ppar[26]/3.)^2)/1000.,format='(f4.2)'))
     stn0=strtrim(string(Ppar[36],format='(f6.2)'))
     stn1=strtrim(string(Ppar[37],format='(f6.2)'))
     stn2=strtrim(string(Ppar[38],format='(f6.2)'))
     stn3=strtrim(string(Ppar[39],format='(f6.2)'))
     specnr=strtrim(string(0,format='(i2)'))
     isophot=strtrim(string(gfstate.iso[0],format='(i5)'))
     npxused=strtrim(string(gfstate.npixused[0],format='(i3)'))

if (gfstate.np eq 1) then peaktitle='1 Peak'
if (gfstate.np eq 2) then peaktitle='2 Peaks'

outputstring=[peaktitle+'  FIT RESULTS for FWHM isophote', $
           '-----------------------------------------', $
           'Object: HI'+name2, $
            name1+' centroid', $
            name2+' ellipse', $
           'V20               ='+v20+'   W20='+W20+'+/-'+Werr+'  km/s', $
           'V50               ='+v50+'   W50='+W50+'+/-'+Werr+'  km/s', $
           'Total Flux        ='+totS+'+/-'+totSerr+' Jy km/s', $
           'Mean Flux Density ='+meanS+' mJy', $
           'rms               ='+rms+' mJy', $
           'S/N               ='+stn0+'  '+stn1+'  '+stn2+'  '+stn3 , $           
           'a_ell x b_ell     ='+a_e+' x'+b_e+' arcminutes', $
           'iso('+specnr+')   ='+isophot+' mJy km/s  npix='+npxused, $
           'Max flux in map   ='+maxflx+'       Continuum ='+cflx+' mJy',$
           '******************************************************',$
           '','','','','','','','','']

outputstring=[outputstring, '','','',$
              '*****************************************************',$
              'DIGITAL HI ARCHIVE DATA (Springob et al. 2005)', $
                            '---------------------------------------------']

columns=['Morph. Type',$       
   'Observed Flux',$     
   'Corrected Flux',$     
   'Absorption corrected Flux',$     
   'EPSS',$     
   'RMS',$     
   'SNR',$     
   'VHELIO',$      
   'WF50',$      
   'WM50',$      
   'WP50',$      
   'WP20',$      
   'W2P50',$      
   'WC',$      
   'EPSW',$      
   'Telescope',$    
   'Bandwidth',$      
   'Channels']   

units= ['',$       
   'Jy km/s',$     
   'Jy km/s',$     
   'Jy km/s',$     
   'Jy km/s',$     
   'mJy',$     
   '',$     
   'km/s',$      
   'km/s',$      
   'km/s',$      
   'km/s',$      
   'km/s',$      
   'kms',$      
   'km/s',$      
   'km/s',$      
   '',$    
   'kHz',$      
   '']   

ra=strcompress(gfstate.table3.rahr2000[table3index], /remove_all)+$
   strcompress(gfstate.table3.ramin2000[table3index], /remove_all)+$
   strcompress(gfstate.table3.rasec2000[table3index], /remove_all)

dec=strcompress(gfstate.table3.decdeg2000[table3index], /remove_all)+$
   strcompress(gfstate.table3.decmin2000[table3index], /remove_all)+$
   strcompress(gfstate.table3.decsec2000[table3index], /remove_all)

outputstring=[outputstring, 'AGC '+strcompress(agcint, /remove_all)+$
              '   Other ID: '+strcompress(gfstate.table3.other[table3index], /remove_all), $
              'Coordinates (J2000): '+ra+dec, $
              'a x b Optical size: '+strtrim(string(gfstate.table3.a[table3index],gfstate.table3.b[table3index],format='(f4.1," x ",f4.1)'))+$
              ' arcminutes']

for i=10, 27 do begin
    outputstring=[outputstring, columns[i-10]+':   '+strcompress(gfstate.table3.(i)[table3index], /remove_all)+$
                  ' '+units[i-10]]
endfor



widget_control, compare_text, set_value=outputstring

widget_control, comparedisplay, get_value=index
wset, index

!p.multi=[0,1,2]

                device, decomposed=1

	        ver, smin, smax*1.3
                hor, min(vel[0:channels-1]), max(vel[0:channels-1])

              

                ;Plot the ALFALFA FHWM entry

                ;FWHM is now element 5
                plot,grid.velarr,gfstate.spec[*,5]-gfstate.baseyfit[*,5], $ 
                    title='AGC '+strcompress(agcnumber, /remove_all)+'     FWHM integrated profile', $
                    charsize=gfstate.charsize , $ 
                    xtitle='cz [km/s]', ytitle='Flux Density  [mJy]', $
                    xstyle=1, ystyle=1   
                
                ;plot the Digital HI Archive entry

                plot, vel[0:channels-1], spectrum[0:channels-1]-base[0:channels-1],$
                      xstyle=1, ystyle=1, charsize=gfstate.charsize,xtitle='cz [km/s]', ytitle='Flux Density  [mJy]', $
		      title='AGC '+strcompress(agcnumber, /remove_all)+' Digital HI Archive entry'
                      
                oplot, vel[0:channels-1], spectrum[0:channels-1]-base[0:channels-1], color='FFFF00'XL  ;CYAN


		

		;device, decomposed=1
	        ;oplot, vel[0:channels-1], base[0:channels-1], color='0000FF'XL, linestyle=2
            	;flag, vhelio[0], color='0000FF'XL

		device, decomposed=0

!p.multi=0

;Reset to window device

widget_control, gfstate.mainplotwindow, get_value=index 
wset, index

         !x.s=gfstate.xs
         !x.margin=gfstate.xmargin
         !x.window=gfstate.xwindow
         !x.region=gfstate.xregion
         !x.range=gfstate.mainxrange
         !x.crange=gfstate.mainxrange

         !y.s=gfstate.ys
         !y.margin=gfstate.ymargin
         !y.window=gfstate.ywindow
         !y.region=gfstate.yregion
         !y.range=gfstate.mainyrange
         !y.crange=gfstate.mainyrange
         !p.clip=gfstate.pclip



end

;----------------------------------------------------------------------
;Event hanlder for popup
pro galflux_digitalHIcompare_event, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'compare_done': widget_control, event.top, /destroy
    else:
endcase

end





;---------------------------------------------------------------
;Printing procedure
pro galflux_ps

common galflux_state
common gridstate


if (not (xregistered('galflux_ps', /noshow))) then begin

    pstitle = strcompress('Postscript Output')

    ps_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = pstitle, $
                             uvalue = 'ps_base')

    ;comparedisplay=widget_draw(compare_base, xsize=900, ysize=600, /frame, $
     ;                                  uvalue='comparedisplay')

    ;help_text = widget_text(help_base, /scroll, value = h, xsize = 85, ysize = 15)
    
    vmin=1000
    vmax=4000
    Ymin=-10
    Ymax=100
    printer=0   ;default is netlp3

    check=findfile('ps_scale.txt', count=count)

    if (count eq 1) then begin
        data=read_ascii('ps_scale.txt', delimiter=',')
        vmin=data.field1[0]
        vmax=data.field1[1]
        Ymin=data.field1[2]
        Ymax=data.field1[3]
        printer=long(data.field1[4])  ; as of March 2006 - a zero or one - more printers can be added later
    endif
   ;printer note - 0 is for netlp3, 1 is for netlp5, 2 is for hp2 at Arecibo

    
    labelbase=widget_base(ps_base, row=4, /grid_layout, /base_align_center, /frame)
     
         label=widget_label(labelbase, value='Vmin: ')
           gfstate.print_vmin=widget_text(labelbase, xsize=8, value=strcompress(vmin, /remove_all), /editable)
         label=widget_label(labelbase, value='Vmax: ')
           gfstate.print_vmax=widget_text(labelbase, xsize=8, value=strcompress(vmax, /remove_all), /editable)
         label=widget_label(labelbase, value='Ymin: ')
           gfstate.print_Ymin=widget_text(labelbase, xsize=8, value=strcompress(Ymin, /remove_all), /editable)
         label=widget_label(labelbase, value='Ymax: ')
           gfstate.print_Ymax=widget_text(labelbase, xsize=8, value=strcompress(Ymax, /remove_all), /editable) 
     
                                              
    choosebase=widget_base(ps_base, /column)
     
      ;gfstate.printiso=widget_droplist(choosebase, value=gfstate.spectralistvals, $
      ;                                          uvalue='spectralist')


       ;Alwasy set to print FWHM by default
       isofind=where(gfstate.iso ne -1)
       list=gfstate.spectralistvals[isofind]
       index=where(list eq 'Half')
       gfstate.spectralist_printer=index
       ;print, list

       droplistObj=fsc_droplist(choosebase, value=list, uvalue='spectralist', index=index, title='Isophote:')
       gfstate.printiso=droplistObj->getID()
      

      ;label=widget_label(choosebase, value='    Printer:')
      droplistObj2=fsc_droplist(choosebase, value=['netlp3', 'netlp5', 'hp2(AO)'], uvalue='printer', index=0, title='Printer:')
      gfstate.printer=droplistObj2->getID()
      droplistObj2->SetIndex, printer   ;set widget index
      gfstate.currentprinter=printer   ;set value in state structure

      ;gfstate.printer=widget_droplist(choosebase, value=['netlp3', 'netlp5'], uvalue='printer')
      

    buttonbase=widget_base(ps_base, /row)
      ps_print = widget_button(buttonbase, value = '   Print   ', uvalue='ps_print')
      ps_preview = widget_button(buttonbase, value= ' Preview ', uvalue='ps_preview')
      ps_save = widget_button(buttonbase, value = '   Save   ', uvalue = 'ps_save')
      ps_cancel = widget_button(buttonbase, value = '   Done   ', uvalue='ps_done')

    widget_control, ps_base, /realize
    xmanager, 'galflux_ps', ps_base, /no_block
    
endif


end



;------------------------------------------------------------
pro galflux_ps_event, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue=uvalue


galflux_writesource, /tempfile

restore,'~/temp1138bk.src'
srcname=src.srcname

    if (grid.czmin eq -2000.0) then suffix='a'
    if (grid.czmin eq 2500.0) then suffix='b'
    if (grid.czmin eq 7200.0) then suffix='c'
    if (grid.czmin eq 12100.0) then suffix='d'



outfile='HI'+srcname+'_'+grid.name+suffix+'.ps'

;Set default print flag
printflag=''


case uvalue of



'ps_done': begin

        
    widget_control, gfstate.print_vmin, get_value=vminstring
    widget_control, gfstate.print_vmax, get_value=vmaxstring
    widget_control, gfstate.print_Ymin, get_value=Yminstring
    widget_control, gfstate.print_Ymax, get_value=Ymaxstring

    vmin=float(vminstring)
    vmax=float(vmaxstring)
    Ymin=float(Yminstring)
    Ymax=float(Ymaxstring)

    openw, lun, 'ps_scale.txt', /get_lun
     printf, lun, strcompress(vmin)+','+strcompress(vmax)+','+strcompress(Ymin)+','+strcompress(Ymax)+','+$
                  strcompress(long(gfstate.currentprinter))
     close, lun
     free_lun, lun

        widget_control, event.top, /destroy
        flag='skip'
    end

'ps_save': begin
        flag='outputps'
       

end

'ps_print': begin
        flag='outputps'
        outfile='~/postscript_temp1138bk.ps'
        printflag='print'

end

'ps_preview': begin
        flag='outputps'
        outfile='~/postscript_temp1138bk.ps'
        printflag='preview'

end



'spectralist': begin
     ;print, event.index
     gfstate.spectralist_printer=event.index   ;returns even from drop list, droplist only populate with valid iso levels
     flag=''
end

'printer': begin
     gfstate.currentprinter=event.index
     flag=''
end


else:

endcase



;OUT TO POSTSCRIPT

if (flag eq 'outputps') then begin


;Save as a source file - requested on April 22, 2006
galflux_writesource


; DISPLAY CONTENTS IN FILE

nspec=n_elements(src.spectra)
if (nspec eq 0) then print,'No spectra stored in this file'

G=''
P=''
  outstring=['...........................................................................',$
             'specnr isophot npx  a_ell  b_ell  P  G  Stot_map rmsP  rmsG   stn0P  stn0G',$
             '...........................................................................']
  
;for ns=0,nspec-1 do begin
;  if (src.spectra[ns].flux_int_specG ne 0.) then G='G'
;  if (src.spectra[ns].flux_int_specP ne 0.) then P='P'
;  print,ns,src.spectra[ns].isophot,src.spectra[ns].phot_npix,	$
;        src.spectra[ns].phot_ell_a,src.spectra[ns].phot_ell_b,	$
;        P,G,src.spectra[ns].flux_int_map,			$
;        src.spectra[ns].rmsP,src.spectra[ns].rmsG,		$
;        src.spectra[ns].ston[0],src.spectra[ns].ston[4],	$
;	format='(3x,i1,3x,f5.0,3x,i3,f6.1,f7.1,3x,a1,2x,a1,2x,f6.1,2x,f4.2,2x,f4.2,3x,f5.1,2x,f5.1)'
;endfor

;print,'Select specnr to plot'
;read,specnr

specnr=gfstate.spectralist_printer

; GET PARMS TO DISPLAY

spec=src.spectra[specnr].spec
velarr=src.spectra[specnr].velarr
weight=src.spectra[specnr].weight

type='integrated'
V50=src.spectra[specnr].vcen[0]
V20=src.spectra[specnr].vcen[1]
Vcen=src.spectra[specnr].vcen[2]
VcenerrP=src.spectra[specnr].vcenerr_stat[0]
VGauss=src.spectra[specnr].vcen[3]
VGausserr=src.spectra[specnr].vcenerr_stat[3]
W50=src.spectra[specnr].width[0]
W20=src.spectra[specnr].width[1]
WGauss=src.spectra[specnr].width[3]
WerrP=src.spectra[specnr].widtherr[0]
WerrG=src.spectra[specnr].widtherr[3]
Stot_specP=src.spectra[specnr].flux_int_specP
Stot_specG=src.spectra[specnr].flux_int_specG
Stot_specP_err=sqrt(src.spectra[specnr].flux_specP_err_stat^2+src.spectra[specnr].flux_specP_err_sys^2)
Stot_specG_err=sqrt(src.spectra[specnr].flux_specG_err_stat^2+src.spectra[specnr].flux_specG_err_sys^2)
mean_flx=src.spectra[specnr].mean_flx
peak_flx=src.spectra[specnr].peak_flx
rmsP=src.spectra[specnr].rmsP
rmsG=src.spectra[specnr].rmsG
stn=src.spectra[specnr].ston
cont=src.spectra[specnr].continuum

RA_cen=src.spectra[specnr].RA_centroid
Dec_cen=src.spectra[specnr].Dec_centroid
radec_cen=radec_to_name(ra_cen,dec_cen)
RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell
radec_ell=radec_to_name(ra_ell,dec_ell)
a_ell=src.spectra[specnr].a_ell
b_ell=src.spectra[specnr].b_ell
PA_ell=src.spectra[specnr].PA_ell
npix_ell=src.spectra[specnr].npix_ell
isophot=src.spectra[specnr].isophot
map_smax=src.spectra[specnr].map_maxflx
Stot_map=src.spectra[specnr].flux_int_map
Stot_map_err=src.spectra[specnr].flux_map_err_stat


; ADD params which may not be in src (the laborious way...)

catname=strarr(7)
posopt=dblarr(2)
catname[0]=src.spectra[specnr].agcnr
catname[1]=src.spectra[specnr].agcname
catname[2]=src.spectra[specnr].NGC
catname[3]=src.spectra[specnr].IC
catname[4]=src.spectra[specnr].twomass
catname[5]=src.spectra[specnr].SDSS
catname[6]=src.spectra[specnr].other
posopt[0]=src.spectra[specnr].RA_opt
posopt[1]=src.spectra[specnr].Dec_opt

;addnames:
;Print,'Do you wish to update any of the following parameters [if not, enter 99]'
;Print,'0	AGCnr: ',src.spectra[specnr].agcnr
;Print,'1	agcname: ',src.spectra[specnr].agcname
;Print,'2	NGC nr: ',src.spectra[specnr].NGC
;Print,'3	IC nr: ',src.spectra[specnr].IC
;Print,'4	2Mass name: ',src.spectra[specnr].twomass
;Print,'5	SDSS name: ',src.spectra[specnr].SDSS
;Print,'6	Other: ',src.spectra[specnr].other
;Print,'7	Opt RA : ',src.spectra[specnr].RA_opt
;Print,'8	Opt Dec: ',src.spectra[specnr].Dec_opt
;read,catnr
;if (catnr lt 9) then begin
;  if (catnr le 6) then begin
;     print,'Enter new name'
;     newname=''
;     read,newname
;     catname[catnr]=newname
;  endif else begin
;     print,'Enter new coords in hhmmss.s/ddmmss format:'
;     read,newpos
;     posopt[catnr-7]=newpos
;  endelse
;  print,'     ...modify the input src file with this update? [y/n def=n]'
;  mans=''
;  read,mans
;  if (mans eq 'y' or mans eq 'Y') then begin
;    if (catnr eq 0) then src.spectra[specnr].agcnr=  catname[catnr]
;    if (catnr eq 1) then src.spectra[specnr].agcname=catname[catnr]
;    if (catnr eq 2) then src.spectra[specnr].NGC=    catname[catnr]
;    if (catnr eq 3) then src.spectra[specnr].IC=     catname[catnr]
;    if (catnr eq 4) then src.spectra[specnr].twomass=catname[catnr]
;    if (catnr eq 5) then src.spectra[specnr].SDSS=   catname[catnr]
;    if (catnr eq 6) then src.spectra[specnr].other=  catname[catnr]
;    if (catnr eq 7) then src.spectra[specnr].RA_opt= hms1_hr(posopt[0])
;    if (catnr eq 8) then src.spectra[specnr].Dec_opt=dms1_deg(posopt[1])
;  endif
;  print,'        Other updates [y/n def=n]'
;  oans=''
;  read,oans
;  if (oans eq 'y' or oans eq 'Y') then goto,addnames
;endif


; OK, READY TO PLOT

; get spectrum plot parms

;vmin=min(velarr,max=vmax)
;ymin=min(spec,max=ymax)
;if (src.spectra[specnr].ymin ne 0.) then begin
;  ymin=src.spectra[specnr].ymin
;  ymax=src.spectra[specnr].ymax
;endif 
;plot,velarr,spec,xrange=[vmin,vmax],yrange=[ymin,ymax]
;print,'Modify xmin,xmax,ymin,ymax? [y/n def=y]'
;ans='
;read,ans
;if (ans eq 'n' or ans eq 'N') then goto,moveon
;setlims:
;print,'Enter vmin,vmax,ymin,ymax'
;read,vmin,vmax,ymin,ymax
;plot,velarr,spec,xrange=[vmin,vmax],yrange=[ymin,ymax],xstyle=1,ystyle=1
;print,'Lims OK? [y/n def=y]?
;lims=''
;read,lims
;if (lims eq 'n' or lims eq 'N') then goto,setlims

;moveon:

;wdelete
;window,/free,xsize=1000,ysize=900,retain=2
!p.multi=[0,1,3,0,0]


widget_control, gfstate.print_vmin, get_value=vminstring
widget_control, gfstate.print_vmax, get_value=vmaxstring
widget_control, gfstate.print_Ymin, get_value=Yminstring
widget_control, gfstate.print_Ymax, get_value=Ymaxstring

vmin=float(vminstring)
vmax=float(vmaxstring)
Ymin=float(Yminstring)
Ymax=float(Ymaxstring)

; get ellipse


totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; convert to string

sv50=strtrim(string(V50,W50,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werrp,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,vcenerrp,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f9.4,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f9.4,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f9.4)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f9.4)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f8.2,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f8.2,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

; add info on all other spectra in file

strspec=strarr(nspec)
for ns=0,nspec-1 do begin

  rdell=radec_to_name(src.spectra[ns].ra_ell,src.spectra[ns].dec_ell)
  rdcen=radec_to_name(src.spectra[ns].ra_centroid,src.spectra[ns].dec_centroid)
  strspec[ns]=string(src.spectra[ns].isophot,src.spectra[ns].phot_npix,	$
	rdell,rdcen,src.spectra[ns].a_ell,src.spectra[ns].b_ell,		$
        src.spectra[ns].PA_ell,							$
	src.spectra[ns].vcen[0],src.spectra[ns].width[0],			$
	src.spectra[ns].vcen[3],src.spectra[ns].width[3],			$
	src.spectra[ns].flux_int_map/1000.,					$
	src.spectra[ns].flux_int_specP/1000.,src.spectra[ns].flux_int_specG/1000.,$
        src.spectra[ns].ston[0],src.spectra[ns].ston[4],			$
	format='(f8.0,i5,2(2x,a15),2f6.1,f5.0,2x,2(i5,i4),2x,3f7.2,1x,2f7.1)')
endfor



dx=abs(vmax-vmin)
vmed=vmin+0.35*dx
v3=vmin+0.8*dx




entry_device=!d.name
set_plot,'PS'
device,filename=outfile,xsize=8.0,ysize=10.0,yoffset=0.0,/inches 
hor
ver
                        
;imgdisp,totf,zx=10,zy=10,position=[0.685,0.35,0.90,0.52]
;imgdisp,totf, zx=10, zy=10, position=[0.685,0.15,0.90,0.32]

;device, decomposed=0
loadct, 0, /silent
stretch, 100,0

;Contour does not need to be reversed - the ranges take care of this 
contour,totf,position=[0.385, 0.05, 0.60, 0.22],$
            xrange=[n_elements(gfstate.dbox[0,*,0])-0.5,-0.5], $
            yrange=[-0.5,n_elements(gfstate.dbox[0,0,*])-0.5] , $
            xtitle='X pixel', ytitle='Y pixel', xstyle=1, ystyle=1, nlevels=20

plotsym,0,0.5,/fill

plots,fit_ellipse(indices,xsize=nbx,ysize=nby,axes=axes,orientation=orientation,center=center), $
       psym=8


imgdisp,gfstate.dssimage, $
            xrange=[n_elements(gfstate.dbox[0,*,0])-0.5,-0.5], $
            yrange=[-0.5,n_elements(gfstate.dbox[0,0,*])-0.5] , $
            xtitle='X pixel', ytitle='Y pixel', xstyle=1, ystyle=1, $
            position=[0.685,0.05,0.90,0.22]

stretch

isofind=where(gfstate.iso ne -1)
       list=gfstate.spectralistvals[isofind]


plot,velarr,spec,xrange=[vmin,vmax],yrange=[ymin,ymax],xstyle=1,ystyle=1,position=[0.10,0.65,0.90,0.95], $
     ytitle='Flux Density [mJy]',title=srcname+'   '+list[specnr]+' iso level',charsize=1.8, xtickformat='(i5)'
oplot,velarr,fltarr(nchn),linestyle=1
weight=weight/max(weight)
ytickm=[0.,0.4,0.8,1.2]
plot,velarr,weight,xrange=[vmin,vmax],yrange=[0.0,1.2],xstyle=1,ystyle=1,position=[0.10,0.57,0.90,0.62], $
     yticks=4,ytickv=ytickm,xtitle='Velocity [km/s]',ytitle='Weight',charsize=1.8,linestyle=1, xtickformat='(i5)'

xyouts,vmin-0.07*dx,-1.3,'Integrated Profile:',charsize=0.7
xyouts,vmin-0.07*dx,-1.8,'V50,W50   = '+sv50,charsize=0.7
xyouts,vmin-0.07*dx,-2.1,'V20,W20   = '+sv20,charsize=0.7
xyouts,vmin-0.07*dx,-2.4,'Vcen      = '+svcen,charsize=0.7
xyouts,vmin-0.07*dx,-2.7,'V, W Gauss= '+svg,charsize=0.7
xyouts,vmin-0.07*dx,-3.0,'Stot(profile, P)= '+sstotP,charsize=0.7
xyouts,vmin-0.07*dx,-3.3,'Stot(profile, G)= '+sstotG,charsize=0.7
xyouts,vmin-0.07*dx,-3.6,'rms = '+srms,charsize=0.7
xyouts,vmin-0.07*dx,-3.9,'meanS, peakS = '+smeans,charsize=0.7
xyouts,vmin-0.07*dx,-4.2,'S/N P = '+sstnP,charsize=0.7
xyouts,vmin-0.07*dx,-4.5,'S/N G = '+sstnG,charsize=0.7
xyouts,vmin-0.07*dx,-4.8,'Cont  = '+scont,charsize=0.7

xyouts,vmed,-1.8,'Centroid : '+radec_cen+' [2000]',charsize=0.7
xyouts,vmed,-2.1,'Opt pos  : '+rdopt+' [2000]',charsize=0.7
xyouts,vmed,-2.4,'Cen_ell  : '+radec_ell+' [2000]',charsize=0.7
xyouts,vmed,-2.7,'Ellipse  : '+ellipse,charsize=0.7
xyouts,vmed,-3.0,'Isophot  = '+ssiso,charsize=0.7
xyouts,vmed,-3.3,'Map Smax = '+smapsmax,charsize=0.7
xyouts,vmed,-3.6,'Map Stot = '+sstotm,charsize=0.7

case (gfstate.currentcode) of

0:codeout='(0) No status'
1:codeout='(1) Detection'
2:codeout='(2) Prior (Opt cz available)'
3:codeout='(3) Marginal'
4:codeout='(4) Marginal (possible OC)'
9:codeout='(9) HVC candidate'
else: codeout='Error'

endcase

xyouts,vmed,-3.9,'Quality Code = '+codeout, charsize=0.7

xyouts,vmin-0.07*dx,-5.6,'isophot npx        ell centr            centroid'$
         +'       a_ell  b_ell  PA    V,W[P]   V,W[G]          Sint map,P,G'$
         +'          S/N_0',charsize=0.7
for i=0,nspec-1 do begin  
  xyouts,vmin-0.07*dx,-6.1-i*0.3,strtrim(strspec[i]),charsize=0.7
endfor


indexcomments=where(gfstate.comments eq '')
if (indexcomments[0] ne -1) then begin
    comments=gfstate.comments[0:indexcomments[0]]
endif else begin
    comments=['No comments for this entry.']
endelse



spawn, 'whoami', user

xyouts,vmin-0.07*dx,-8.5,systime(0)+' by '+user,charsize=0.7
xyouts,vmin-0.07*dx,-9.0,'COMMENTS:',charsize=0.5

if (gfstate.correction eq 1) then begin
xyouts, vmin-0.07*dx, -13, 'Cen_ell has been corrected (GALflux v3.0)', charsize=0.5
endif

if (gfstate.correction eq 0) then begin
xyouts, vmin-0.07*dx, -13, 'No position correction made (GALflux v3.0)', charsize=0.5
endif


for i=0, n_elements(comments)-1 do xyouts,vmin-0.07*dx, -9.5-i*0.3, comments[i], charsize=0.5



xyouts,v3,8.5,'AGC nr    '+strtrim(catname[0]),charsize=0.7
xyouts,v3,8.2,'Other     '+strtrim(catname[1]),charsize=0.7
;xyouts,v3,7.9,'NGC       '+strtrim(catname[2]),charsize=0.7
;xyouts,v3,7.6,'IC        '+strtrim(catname[3]),charsize=0.7
;xyouts,v3,7.3,'2MASS     '+strtrim(catname[4]),charsize=0.7
;xyouts,v3,7.0,'SDSS      '+strtrim(catname[5]),charsize=0.7
;xyouts,v3,6.7,'other     '+strtrim(catname[6]),charsize=0.7



device,/close_file
set_plot,entry_device

!p.multi=0

endif

widget_control, gfstate.mainplotwindow, get_value=index 
wset, index

         !x.s=gfstate.xs
         !x.margin=gfstate.xmargin
         !x.window=gfstate.xwindow
         !x.region=gfstate.xregion
         !x.range=gfstate.mainxrange
         !x.crange=gfstate.mainxrange

         !y.s=gfstate.ys
         !y.margin=gfstate.ymargin
         !y.window=gfstate.ywindow
         !y.region=gfstate.yregion
         !y.range=gfstate.mainyrange
         !y.crange=gfstate.mainyrange
         !p.clip=gfstate.pclip





;Go ahead and print the output
if (printflag eq 'print') then begin

printers=['netlp3', 'netlp5', 'hp2']

spawn, 'lpr -P'+printers[gfstate.currentprinter]+' ~/postscript_temp1138bk.ps'




endif

if (printflag eq 'preview') then begin

spawn, 'gv ~/postscript_temp1138bk.ps &'

endif


spawn, '/bin/rm -r ~/temp1138bk.src'

loadct, 1, /silent
stretch


end



;-----------------------------------------------------
;DSS FETCH - get DSS/Sloan images
pro galflux_dssfetch

common galflux_state
common gridstate

widget_control, gfstate.dsswindow, get_value=index 
wset, index

widget_control, gfstate.baseID, hourglass=1
llx=gfstate.llx
lly=gfstate.lly
urx=gfstate.urx
ury=gfstate.ury

rahr=  (gfstate.rah[urx]-gfstate.rah[llx])/2.0+gfstate.rah[llx]
decdeg=(gfstate.dec[ury]-gfstate.dec[lly])/2.0+gfstate.dec[lly]


;print, rahr, decdeg


imagesize=(gfstate.dec[ury]-gfstate.dec[lly])*60.0   ;units of arcminutes

degperpix=(imagesize/60.0)/295.0




;DSS 2 BLUE IMAGE

if (rahr lt 0.0) then rahr=24.0+rahr
if (rahr gt 24.0D) then rahr=rahr-24.0D


;SLOAN IMAGE
               osfamily = strupcase(!version.os_family)
               if (osfamily eq 'UNIX') then begin

                 url='http://casjobs.sdss.org/ImgCutoutDR6/getjpeg.aspx?ra='+$
                    strcompress(rahr*15.0, /remove_all)+$
                    '&dec='+strcompress(decdeg, /remove_all)+$
                    '&scale='+strcompress(imagesize/6.67,/remove_all)+$
                    '&opt=GI&width=400&height=400'

                 filename='~/12junksdss.jpg'

                 spawn, 'wget -q -O '+ filename + " '" + url + "'"

                 spawn, 'convert '+filename+' '+filename

                 read_jpeg, filename, image, true=1

                 gfstate.sloanimage=congrid(image, 3,218,236)

                 spawn, '/bin/rm -r ~/12junksdss.jpg'
               endif

image=0

queryDSS, [rahr*15.0,decdeg], image, header, imsize=imagesize, survey='2b'

if (image[0] ne 0) then begin
gfstate.dssimage=congrid(image, 218,236)

plot, [0,0], /nodata, xrange=[gfstate.rah[urx], gfstate.rah[llx]], yrange=[gfstate.dec[lly], gfstate.dec[ury]] , $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1

;218.000      236.000      60.0015      40.0015

loadct, 1, /silent
stretch, 100,0

tvscl, gfstate.dssimage, 60.0015,40.0015

stretch

plot, [0,0], /nodata, xrange=[gfstate.rah[urx], gfstate.rah[llx]], yrange=[gfstate.dec[lly], gfstate.dec[ury]] , $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1, /noerase



endif else begin

erase

print, ''
print, 'DSS Unavailable - Defaulting to SDSS'
print, ''

loadct, 1, /silent
stretch, 100,0


 tv, gfstate.sloanimage,60.0015,40.0015, true=1

stretch

plot, [0,0], /nodata, xrange=[gfstate.rah[urx], gfstate.rah[llx]], yrange=[gfstate.dec[lly], gfstate.dec[ury]] , $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1, /noerase


;xyouts, 70,150, 'Technical Problem - try again later', color='FFFFFF'XL, /device

;xyouts, 70, 100, 'The program has not crashed.  Defaulting to Sloan', color='FFFFFF'XL, /device

;print, gfstate.agcindex[0]

endelse 


device, decomposed=1
if (gfstate.agcindex[0] ne -1) then begin
      plots, gfstate.agc_rahr[gfstate.agcindex], gfstate.agc_decdeg[gfstate.agcindex], psym=1, color='0000FF'XL, /data  ;RED
      plots, gfstate.agc_rahr[gfstate.agcindex]+24.0D, gfstate.agc_decdeg[gfstate.agcindex], psym=1, color='0000FF'XL, /data  ;RED
      plots, gfstate.agc_rahr[gfstate.agcindex]-24.0D, gfstate.agc_decdeg[gfstate.agcindex], psym=1, color='0000FF'XL, /data  ;RED
      result=convert_coord(gfstate.agc_rahr[gfstate.agcindex], gfstate.agc_decdeg[gfstate.agcindex], /data, /double, /to_device)
      result2=convert_coord(gfstate.agc_rahr[gfstate.agcindex]-24.0D, gfstate.agc_decdeg[gfstate.agcindex], /data, /double, /to_device)
      result3=convert_coord(gfstate.agc_rahr[gfstate.agcindex]+24.0D, gfstate.agc_decdeg[gfstate.agcindex], /data, /double, /to_device)

      xyouts,result[0,*]+6, result[1,*]-10, $
             strcompress(gfstate.agc.agcnumber[gfstate.agcindex], /remove_all), color='0000FF'XL, /device
     
      xyouts,result2[0,*]+6, result2[1,*]-10, $
             strcompress(gfstate.agc.agcnumber[gfstate.agcindex], /remove_all), color='0000FF'XL, /device

      xyouts,result3[0,*]+6, result3[1,*]-10, $
             strcompress(gfstate.agc.agcnumber[gfstate.agcindex], /remove_all), color='0000FF'XL, /device

endif


device, decomposed=0

;Pointing correction
;Added by B. Kent, December 21, 2006  

coefra=[0.0D,0.0D,0.0D,0.0D]
coefdec=coefra
gfstate.correction=0   ;for messaging - zero if no correction, 1 if there is a correction

;Current as of January 6, 2007

;UNITS in second of arc
;Correction coefficients for 3rd order poly for +8 to +16 declination range
if (gfstate.cen_ell_dec[0] gt 7.8 AND gfstate.cen_ell_dec[0] lt 16.5) then begin
coefra=[56.608498D,      -15.295846D,       1.3616687D,    -0.042068705D]
coefdec=[ -53.364512D,       16.971647D,      -1.5659715D,     0.048449057D]
;gfstate.correction=1
endif


;Correction coefficients for 3rd order poly for +24 to +28 declination range
if (gfstate.cen_ell_dec[0] gt 23.5 AND gfstate.cen_ell_dec[0] lt 28.5) then begin
coefra=[  -33386.257D,       3837.6595D,      -146.93808D,       1.8728661D]
coefdec=[   23056.414D,      -2666.3824D,       102.67591D,      -1.3165387D]
;gfstate.correction=1
endif


correction_dec_deg=dblarr(gfstate.numisolevels+1)
correction_ra_hr=dblarr(gfstate.numisolevels+1)

for i=0,gfstate.numisolevels do begin

correction_ra_arcsec=coefra[0]+coefra[1]*gfstate.cen_ell_dec[i]+coefra[2]*gfstate.cen_ell_dec[i]^2+coefra[3]*gfstate.cen_ell_dec[i]^3
correction_dec_arcsec=coefdec[0]+coefdec[1]*gfstate.cen_ell_dec[i]+coefdec[2]*gfstate.cen_ell_dec[i]^2+coefdec[3]*gfstate.cen_ell_dec[i]^3

cosdec=cos(gfstate.cen_ell_dec[i]*!dpi/180.0)
correction_dec_deg[i]=correction_dec_arcsec/3600.0
correction_ra_hr[i]=(correction_ra_arcsec/3600.0/15.0)/cosdec

endfor

device, decomposed=1
plotsym, 0
plots, gfstate.cen_ell_ra[0], gfstate.cen_ell_dec[0], psym=8, color='00FF00'XL
plots, gfstate.cen_ell_ra[0]-correction_ra_hr[0], gfstate.cen_ell_dec[0]-correction_dec_deg[0], psym=6, color='FF00FF'XL

plots, 20, 282, psym=8, color='00FF00'XL, /device
   xyouts, 26, 280, 'Measured', color='00FF00'XL, /device

plots, 100, 282, psym=6, color='FF00FF'XL, /device
   xyouts, 106, 280, 'Corrected', color='FF00FF'XL, /device

plots, 180, 282, psym=1, color='0000FF'XL, /device
   xyouts, 186, 280, 'AGC Catalog', color='0000FF'XL, /device

device, decomposed=0





;outstring='Field size: '+strtrim(string(imagesize, format='(f5.2)'))+' arcmin'
;widget_control, gfstate.imagesizelabel, set_value=outstring

gfstate.rahrimage=rahr
gfstate.decdegimage=decdeg

stretch
galflux_spectrameasure

 widget_control, gfstate.baseID, hourglass=0

end

;------------------------------------------------------------
;Help
pro galflux_about

   common galflux_state
common gridstate

h=['GALflux        ', $
   ' ', $
   'Started February 17, 2006', $
   'Last update, January 4, 2007']


if (not (xregistered('galflux_about', /noshow))) then begin

abouttitle = strcompress('About GALflux')

    about_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = abouttitle, $
                             uvalue = 'about_base')

    about_text = widget_text(about_base, /scroll, value = h, xsize = 85, ysize = 15)
    
    about_done = widget_button(about_base, value = ' Done ', uvalue = 'about_done')

    widget_control, about_base, /realize
    xmanager, 'galflux_about', about_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro galflux_about_event, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'about_done': widget_control, event.top, /destroy
    else:
endcase

end


;------------------------------------------------------------
;Help
pro galflux_instructions

common galflux_state
common gridstate

url='http://caborojo.astro.cornell.edu/alfalfalog/idldocs/msr_sources_14jun06.txt'
filename='galflux_instruct_1138'
spawn, 'wget -q -O ~/'+ filename + ".txt '" + url + "'" 

;uses JHU library getfile.pro
h=getfile('~/'+filename+'.txt')



if (not (xregistered('galflux_about', /noshow))) then begin

abouttitle = strcompress('About GALflux')

    about_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = abouttitle, $
                             uvalue = 'about_base')

    about_text = widget_text(about_base, /scroll, value = h, xsize = 85, ysize = 35)
    
    about_done = widget_button(about_base, value = ' Done ', uvalue = 'about_done')

    widget_control, about_base, /realize
    xmanager, 'galflux_about', about_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro galflux_instructions_event, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'about_done': widget_control, event.top, /destroy
    else:
endcase

end






;------------------------------------------------------------
;Comments
pro galflux_comments, event

common galflux_state
common gridstate

if (not (xregistered('galflux_comments', /noshow))) then begin

commentstitle = strcompress('GALflux file comments')

    comments_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = commentstitle, $
                             uvalue = 'comments_base')

    gfstate.comments_text = widget_text(comments_base, /scroll, value = gfstate.comments, xsize = 85, ysize = 15, /editable, uvalue='textbox')
    
    comments_done = widget_button(comments_base, value = ' Done ', uvalue = 'comments_done')

    widget_control, comments_base, /realize
    xmanager, 'galflux_comments', comments_base, /no_block
    
endif

end





;----------------------------------------------------------------------

pro galflux_comments_event, event

    common galflux_state
common gridstate

widget_control, event.id, get_uvalue = uvalue

case uvalue of


    'comments_done': begin
        
        widget_control, gfstate.comments_text, get_value=tempstring
        ;help, tempstring
        gfstate.comments=tempstring[0:99]
        
        widget_control, event.top, /destroy

     end

    else:
endcase

end


;------------------------------------------------------------
pro galflux_sloancentroid

common galflux_state
common gridstate

if (not (xregistered('galflux_sloancentroid', /noshow))) then begin

centroidtitle = strcompress('GALflux Optical Centroid')

    centroid_base =  widget_base(group_leader = gfstate.baseID, $
                             /column, /base_align_right, title = centroidtitle, $
                             uvalue = 'centroid_base')

    gfstate.centroid_text = widget_text(centroid_base, /scroll, value = gfstate.sloancentroid, xsize = 20, /editable, uvalue='textbox')
    
    centroid_done = widget_button(centroid_base, value = ' Done ', uvalue = 'centroid_done')

    widget_control, centroid_base, /realize
    xmanager, 'galflux_sloancentroid', centroid_base, /no_block
    
endif

end

;------------------------------------------------------------
pro galflux_sloancentroid_event, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue = uvalue

case uvalue of
   
     'centroid_done': begin

         widget_control, gfstate.centroid_text, get_value=tempstring

         pos=strpos(tempstring, '+')

         ;Check for empty input
         if (tempstring eq '' AND pos[0] eq -1) then begin
             gfstate.sloancentroid=tempstring
             widget_control, event.top, /destroy         
         endif

         if (tempstring ne '' AND pos[0] eq -1) then begin
             status=dialog_message('Incorrect Format!  Please try again.')
         endif
         
         if (pos[0] ne -1) then begin

             ;Separate out the ra and dec from the SDSS input
             ;Check for the leading J epoch if people accidentally put it in
             epochpos=strpos(tempstring, 'J')
             
             if (epochpos[0] ne -1) then tempstring=strmid(tempstring, epochpos[0]+1)
                 
             pluspos=strpos(tempstring, '+')
             if (pluspos[0] ne -1) then begin
                 
                 rastring=strmid(tempstring, 0, pluspos[0])
                 decstring=strmid(tempstring, pluspos[0])

                 gfstate.RA_opt=hms1_hr(rastring)
                 gfstate.Dec_opt=dms1_deg(decstring)

                 ;print, rastring, '  ',gfstate.RA_opt
                 ;print, decstring,'  ',gfstate.Dec_opt
                 gfstate.sloancentroid=tempstring
                

             endif

                
             widget_control, event.top, /destroy

         endif
         
     end

     else:

endcase

end



;----------------------------------------------------------------------
pro galflux_skym

 common galflux_state

common gridstate

widget_control, gfstate.baseID, hourglass=1

skymask=lonarr(gfstate.nx,gfstate.ny)
sky=fltarr(gfstate.nchn)

llx=gfstate.llx
lly=gfstate.lly
urx=gfstate.urx
ury=gfstate.ury

;if keyword is set, then check for skym=0, or skym=1
if (gfstate.SKYM ne -1) then begin

wgrid=total(grid.w,2)
dgrid=reform(grid.d[*,0,*,*]*grid.w[*,0,*,*]+$
             grid.d[*,1,*,*]*grid.w[*,1,*,*])/wgrid

   if (gfstate.SKYM eq 0) then begin
     lox=llx-gfstate.skympix
       if (lox lt 0) then lox=0
     hix=urx+gfstate.skympix
       if (hix gt n_elements(grid.d[0,0,*,0])-1) then hix=n_elements(grid.d[0,0,*,0])-1
     loy=lly-gfstate.skympix
       if (loy lt 0) then loy=0
     hiy=ury+gfstate.skympix
       if (hiy gt gfstate.ny-1) then hiy=n_elements(grid.d[0,0,0,*])-1
     skymask[lox:hix,loy:hiy]=1
     skymask[llx:urx,lly:ury]=0
   endif 
   if (gfstate.SKYM eq 1) then begin
       if ((xregistered('gridview', /noshow))) then begin
           common gridview_state
           widget_control, state.gotochannel, get_value=channelstring
           channel=long(channelstring[0])
           index=channel
       endif else begin
          index=where(grid.velarr lt 50 AND grid.velarr gt -50)
       endelse

     if (index[0] ne -1) then begin

         widget_control, gfstate.baseID, hourglass=0
         window, 0, retain=2
         win=!d.window

      
      imgdisp, reverse(reform(grid.d[index[0],0, *, *])),zx=4, zy=4, $
           xrange=[gfstate.nx-1,0], yrange=[0, gfstate.ny-1], xtitle='X pixel',$
           ytitle='Y pixel', title='Click LOWER x and y point', win=win

      curfull, lox, loy
      wait, 0.5

       imgdisp, reverse(reform(grid.d[index[0],0, *, *])),zx=4, zy=4, $
           xrange=[gfstate.nx-1,0], yrange=[0, gfstate.ny-1], xtitle='X pixel',$
           ytitle='Y pixel', win=win, title='Click UPPER x and y point

      curfull,hix, hiy
      wait, 0.5
      
      widget_control, gfstate.baseID, hourglass=1
      

     ;print,'Enter coords of llc sky pix: lox, loy'
     ;read,lox,loy
     ;print,'Enter coords of urc pix: hix,hiy'
     ;read,hix,hiy
      wdelete, win
     skymask[lox:hix,loy:hiy]=1

     endif

   endif
   skyindx=where(skymask eq 1,nnsky)
   for nch=0,gfstate.nchn-1 do begin
     image=reform(dgrid[nch,*,*])
     sky[nch]=median(image[skyindx]) ; sky is a 1D array of nchn values
   endfor
endif


for nch=0,gfstate.nchn-1 do begin
  gfstate.dbox[nch,*,*] = gfstate.dbox_orig[nch,*,*] - sky[nch]
endfor
chflux=total(gfstate.dbox,2)
chflux=(total(chflux,2))/gfstate.totbeam

gfstate.chflux=chflux
gfstate.currentxarr=dindgen(gfstate.nchn)
gfstate.currentyarr=chflux

galflux_plotter




widget_control, gfstate.baseID, hourglass=0

end


;-------------------------------------------------------------
;Low and high channels are passed to this procedure which this
;performs a simple linear interpolation

pro galflux_spikerepair, lowchan, highchan

common galflux_state
common gridstate

print, lowchan, highchan

flag, lowchan
flag, highchan

xarr=findgen(gfstate.nchn)

for i=0, gfstate.numisolevels do begin

if (gfstate.iso[i] ne -1) then begin


if (gfstate.baselineremovestatus eq 'on') then begin
    currentyarr=gfstate.spec[*,i]
  endif else begin
    currentyarr=gfstate.spec[*,i]
  endelse


xvals=[xarr[lowchan], xarr[highchan]]
yvals=[currentyarr[lowchan], currentyarr[highchan]]

result=poly_fit(xvals,yvals,1,sigma=sigma1,yerror=yerror1,status=status)
yfit=poly(xarr,result)

;if (i eq 0) then begin
;device, decomposed=1
;oplot, xarr[lowchan:highchan], yfit[lowchan: highchan], color='FFFF00'XL
;endif

gfstate.spec[lowchan:highchan, i]=yfit[lowchan:highchan] 


endif


endfor



end

;-------------------------------------------------
;Set Quality codes
pro galflux_codes, event

common galflux_state
common gridstate

widget_control, event.id, get_uvalue=codestring

gfstate.currentcode=long(codestring)


end


;-----------MAIN PROCEDURE-------------------------
pro galflux, llx=llx, lly=lly, urx=urx, ury=ury, $
             srcfile=srcfile

common gridstate   ;Common block defined in gridview initialization procedure

;Check to see if a grid was passed WITH the appropriate
; box coordinate parameters

if (n_elements(grid) ne 0 AND n_elements(srcfile) ne 0) then begin
    print, 'USAGE:  galflux, grid=grid, lx=lx, ly=ly, $'
    print, '                 ux=ux, uy=uy, srcfile=srcfile'
    return
endif

T=systime(1)

common galflux_state, gfstate

print, ''
print, 'Initializing GalFLUX v3.0. pointing correction applied for 7.8 < dec < 16.5 AND 23.5 < dec < 28.5.'
print, ''

nsx=urx-llx+1
nsy=ury-lly+1


; Get spectral, continuum data and respective weights

nx=n_elements(grid.d[0,0,*,0])
ny=n_elements(grid.d[0,0,0,*])
nchn=n_elements(grid.d[*,0,0,0])
xarr=findgen(nchn)


;Note from BK - RG says this should be 3 pixels wide

; Get the sky level from the region outlined by skymask
; the default skymask is =1 in a square ring, 5 pix wide, around the srcgrid
; If the keyword SKYM is specified on input, user is prompted to click
; on corners of a square box to be used as "sky"

wgrid=total(grid.w,2)
cwgrid=total(grid.cw,1)
;dgrid=reform(grid.d[*,0,*,*]*grid.w[*,0,*,*]+grid.d[*,1,*,*]*grid.w[*,1,*,*])/wgrid
cgrid=reform(grid.cont[0,*,*]*grid.cw[0,*,*]+grid.cont[1,*,*]*grid.cw[1,*,*])/cwgrid



skymask=lonarr(nx,ny)
sky=fltarr(nchn)




; Compute coords of grid pix and regrid source box in x if steps in 
; x and y are uneven (desirable when fitting ellipses, so axial ratios
; make sense if sky mapped 1:1 in ra:dec. Regrid box to 1 arcmin spacing
; in both directions

;deltara=grid.deltara     ; grid spacing in RA, sec of time - not need in 
;deltadec=grid.deltadec   ; grid spacing in Dec, arcmin
rah=grid.ramin+(dindgen(n_elements(grid.d[0,0,*,0]))+0.5)*grid.deltara/3600.   ;needed
dec=grid.decmin+(dindgen(n_elements(grid.d[0,0,0,*]))+0.5)*grid.deltadec/(60.) ;needed
; Check if grid spacings in x, y are similar
decnr=dec[(lly+ury)/2.]
cosdec=cos(decnr*!dpi/180.)
deltaram=0.25*grid.deltara*cosdec   ;needed




;dbox=dgrid[*,llx:urx,lly:ury]
dbox=reform(grid.d[*,0,llx:urx,lly:ury]*grid.w[*,0,llx:urx,lly:ury]+grid.d[*,1,llx:urx,lly:ury]*grid.w[*,1,llx:urx,lly:ury])/wgrid[*,llx:urx,lly:ury]
;help, dbox

wbox=wgrid[*,llx:urx,lly:ury]
cbox=cgrid[llx:urx,lly:ury]
cwbox=cwgrid[llx:urx,lly:ury]
rabox=rah[llx:urx]
decbox=dec[lly:ury]
nbx=nsx
nby=nsy
if (deltaram lt 0.97 or deltaram gt 1.03 or $
    grid.deltadec lt 0.97 or grid.deltadec gt 1.03) then begin
  nbx=round(nsx*deltaram)
  nby=round(nsy*grid.deltadec)
  xloc=(findgen(nbx)+0.5)*float(nsx)/float(nbx) - 0.5
  chloc=findgen(nchn)
  yloc=(findgen(nsy)+0.5)*float(nsy)/float(nby) - 0.5
  rabox=interpolate(rabox,xloc)
  decbox=interpolate(decbox,yloc)
  dbox=interpolate(dbox,chloc,xloc,yloc,/grid)
  wbox=interpolate(wbox,chloc,xloc,yloc,/grid)
  cbox=interpolate(cbox,xloc,yloc,/grid)
  cwbox=interpolate(cwbox,xloc,yloc,/grid)
endif

rabox_continue=rabox

for i=0,n_elements(rabox)-1 do begin

   if (rabox[i] lt 0.0) then rabox[i]=rabox[i]+24.0D
   if (rabox[i] gt 24.0) then rabox[i]=rabox[i]-24.0D

endfor

beam=dblarr(nbx,nby)
hpfwx=sqrt(3.3^2+grid.wf_fwhm^2)
hpfwy=sqrt(3.8^2+grid.wf_fwhm^2)
sigmax=0.42466*hpfwx
sigmay=0.42466*hpfwy

bxarr=deltaram*(findgen(nbx)-mean(findgen(nbx)))
byarr=grid.deltadec*(findgen(nby)-mean(findgen(nby)))
bxarr=rebin(bxarr,nbx,nby)
byarr=reform(byarr,1,nby)
byarr=rebin(byarr,nbx,nby)
beam=exp(-0.5*(bxarr/sigmax)^2)*exp(-0.5*(byarr/sigmay)^2)
totbeam=total(beam)

; COMPUTE total Flux in each channel map, after subtracting sky from
; data 

for nch=0,nchn-1 do begin
  dbox[nch,*,*] = dbox[nch,*,*] - sky[nch]
endfor
chflux=total(dbox,2)
chflux=(total(chflux,2))/totbeam


;Open and digitalhi catalogs
;Need common block from ALFALFA initialization script

common agcshare, agcdir
restore, agcdir+'agcnorth.sav'
restore, agcdir+'table3.sav'


rahr=double(agcnorth.rah)+double(agcnorth.ram)/double(60.0)+double(agcnorth.ras10)/(10.0D)/3600.0D
decdeg=abs(double(agcnorth.decd))+double(agcnorth.decm)/double(60.0)+double(agcnorth.decs)/3600.0D
signs=where(agcnorth.sign eq '-')
if (signs[0] ne -1) then decdeg[signs]=-decdeg[signs]

;Find AGC galaxies
iagc=where(rahr lt rah[urx] AND $
           rahr gt rah[llx] AND $
           decdeg lt dec[ury] AND $
           decdeg gt dec[lly])

if (iagc[0] eq -1) then iagc[0]=0


if (rah[llx] lt 0.0) then begin
iagc2=where(rahr gt rah[llx]+24 AND $
            decdeg lt dec[ury] AND $
            decdeg gt dec[lly])

if (iagc2[0] ne -1) then iagc=[iagc,iagc2]

endif



if (rah[urx] gt 24.0) then begin
iagc2=where(rahr lt rah[urx]-24.0 AND $
            decdeg lt dec[ury] AND $
            decdeg gt dec[lly])

if (iagc2[0] ne -1) then iagc=[iagc,iagc2]

endif

if (n_elements(iagc) eq 1  AND iagc[0] eq 0) then iagc[0]=-1
if (n_elements(iagc) gt 1  AND iagc[0] eq 0) then iagc=iagc[1:n_elements(iagc)-1]
         
gfstate={baseID:0L, $         ;ID of base widget
         fmenu:0L, $          ;ID of file menu
         settingsmenu:0L, $   ;ID of settings menu
         helpmenu:0L, $          ;ID of help menu
         mainplotwindow:0L, $
         weightswindow:0L, $
         cubewindow:0L, $
         dsswindow:0L, $
         textdisplay:0L, $
         spectralist:0L, $   ;ID of spectra droplist widget
         currentchan:0L, $
         currentflux:0L, $
         currentvel:0L, $
         fmaxlabel:0L, $  ;ID for label of Map max flux
         crosshairs:'on', $
         imagelabel:0L, $
         imagesizelabel:0L, $
         imageoptions:['DSS2 Blue', 'Sloan'], $
         dssimage:dblarr(218,236), $
         sloanimage:dblarr(3,218,236), $
         rahrimage:0.0D, $
         decdegimage:0.0D, $
         mainmode:lonarr(3), $ ;Exclusive button widget for ellipse, baseline, or fit modes
         fitmode:lonarr(2), $       ;ID of fit mode exclusive selection widget
         currentfitmode:'peaks', $     ;0 for Gaussian,  1 for Peaks
         mousestatus:0L, $    ;for use in widget clicking events
         baselineoption:0L, $ ;ID for baseline option widget
         baselineslider:0L, $ ;ID for baseline slider widget
         baselinestatus:0, $  ;0 for off, 1 for on
         baselinevalues:intarr(8,20)-1000, $
         mousemark:-1, $   ;index number mark for which marker is being moved
         mousemover:'off', $   ;- put in to prevent UP option from being accessed
         baselineremove:0L, $
         baselineremovestatus:'off', $
         allmodebutton:0L, $
         drawID:0L, $   ;widget clicking/zooming
         wid:0L, $      ;widget clicking/zooming device copies
         pixid:0L, $    ;hidden window holder for device copy bitmap
         xsize:600, $    ;Xsize/ysize for device copy in zooming
         ysize:400, $
         zoomsx:0, $
         zoomsy:0, $
         llx:llx, $
         lly:lly, $
         urx:urx, $
         ury:ury, $
         nsx:nsx, $     ;Number of x pixels in selected region
         nsy:nsy, $       ;Number of y pixels in selected region
         nx:n_elements(grid.d[0,0,*,0]), $
         ny:n_elements(grid.d[0,0,0,*]), $
         nchn:nchn, $
         xarr:xarr, $
         rah:rah, $
         dec:dec, $
         deltadec:grid.deltadec, $
         deltaram:deltaram, $
         dbox:dbox, $
         dbox_orig:dbox, $   ;Used if sky subtraction is reset
         wbox:wbox, $
         cbox:cbox, $
         cwbox:cwbox, $
         rabox:rabox, $
         decbox:decbox, $
         nbx:nbx, $
         nby:nby, $
         beam:beam, $
         hpfwx:hpfwx, $
         hpfwy:hpfwy, $
         sigmax:0.42466*hpfwx, $
         sigmay:0.42466*hpfwy, $
         totbeam:totbeam, $
         mainxrange:double([0,nchn-1]), $           ;Default starting value
         mainyrange:double([-20.0,30.0]), $  ;Default starting value        
         charsize:1.5, $
         maintitle:'Spectra summed over box', $
         mainxtitle:'Channel', $
         mainytitle:'Summed Intensity', $
         chflux:chflux, $
         currentxarr:dindgen(nchn), $  ;Default starting value
         currentyarr:chflux, $           ;Default starting value
         racen:dblarr(nchn), $        ;ELLIPSE PARAMETERS BEGIN HERE
         deccen:dblarr(nchn), $
         rapeak:dblarr(nchn), $
         decpeak:dblarr(nchn), $
         peakval:fltarr(nchn), $
         fmax:0.0D, $
         name:strarr(8), $
         totf:dblarr(n_elements(dbox[0,*,0]),n_elements(dbox[0,0,*])), $
         iso:fltarr(8), $
         numisolevels:6, $
         stot:fltarr(8), $
         spec:fltarr(nchn,8), $
         wspec:fltarr(nchn,8), $
         cont:fltarr(8), $
         cen_ra:dblarr(8), $
         cen_dec:dblarr(8), $
         cen_ell_ra:dblarr(8), $
         cen_ell_dec:dblarr(8), $
         a_ell:fltarr(8), $
         b_ell:fltarr(8), $
         PA_ell:fltarr(8), $
         npixused:lonarr(8), $
         mode:'ellipse', $   ;String name of the current mode
         lochhich:intarr(2), $
         spectralistvals:['Half', 'Quarter','100','200','300','500', '1000', 'Custom'], $  ;LISTING / BASELINE 
         isophote_widgetid:fltarr(8), $
         currentlistval:0, $    FWHM is the default value
         zoom:'on',$
         basecoef:dblarr(8,12), $
         baseyfit:dblarr(nchn,8), $
         setallmode:'on', $
         fitmodeonbutton:0L, $
         fitmodeon:'off', $
         Gpars:fltarr(8,20), $
         Ppars:fltarr(8,40), $
         gaussparam:intarr(5,8), $  ;0 is lochn, 1 is hichn, 2 is peak chn, 3 and 4 are rms hi/lo chan   ;GAUSSIAN SCREEN PARAMS
         gausswidth:intarr(8), $    ;Estimate of the width
         gausswidthbox:0L, $  ;widget ID for width
         peaksparam:intarr(6,8), $  ;0 is lochn, 1 is hichn, 2 is lorms, 3 is hi rms, 4 is peak 1, 5 is peak 2    ;PEAKS SCREEN PARAMS
         np:2, $        ;How many peaks to be fit - default is two}
         numberpeaks:lonarr(2), $   ;droplist widget for choosing the number of peaks
         agc:agcnorth, $
         table3:table3, $
         agclist:0L, $
         digitalHIlist:0L, $
         agcindex:iagc, $
         agc_rahr:rahr, $
         agc_decdeg:decdeg, $
         digitalHI_agcnum:-1L, $    ;single AGC number that stores the digitalHI entry
         agcinfo:0L, $
         agcnum:-1L, $
         printiso:0L, $
         printer:0L, $
         print_vmin:0L, $
         print_vmax:0L, $
         print_Ymin:0L, $
         print_Ymax:0L, $
         spectralist_printer:0, $    ;Default is FWHM
         currentprinter:0, $
         xs:dblarr(2), $         ;X and Y parameters for main window
         xmargin:fltarr(2), $
         xwindow:fltarr(2), $
         xregion:fltarr(2), $
         ys:dblarr(2),      $
         ymargin:fltarr(2), $
         ywindow:fltarr(2), $
         yregion:fltarr(2), $
         pclip:lonarr(6), $
         custom_text:0L, $    ;Custom ISO level text definition
         xmin:0.0, $      ;screen scaling
         xmax:0.0, $      ;screen scaling
         ymin:0.0, $      ;screen scaling
         ymax:0.0, $        ;screen scaling
         peaksfitcomplete:intarr(8), $  ;Is the peaks fit on for a particular iso level
         gaussfitcomplete:intarr(8), $
         gaussyfit:dblarr(8,nchn), $
         hanningwin:1, $    ;current hanning value - default is 1 - no hanning smoothing
         comments:strarr(100), $
         comments_text:0L, $
         rmsstatus:'off', $
         agcmessage:'', $
         skym:-1, $
         buttonskymreset:0L, $
         buttonskymframe:0L, $
         buttonskymframe_1:0L, $
         buttonskymframe_2:0L, $
         buttonskymframe_3:0L, $
         buttonskymcustom:0L, $
         buttonspikerepair:0L, $
         skympix:3, $    ;default value is 3 for the frame option
         spikerepairstatus:'off', $
         syserrorcount:0, $
         syserrorchan:intarr(4), $
         peaksyserrors:dblarr(3), $   ;Five systematic errors calculated (relwidth, relvel, syserrflux)
         gausssyserrors:dblarr(3), $   ;Three systematic errors calcualted (width, vel, flux)
         bmask:intarr(nchn), $
         RA_opt:0.0D, $
         Dec_opt:0.0D, $
         correction:0, $   ;correction pointing code     
         buttonnostatus:0L, $
         buttondetection:0L, $
         buttonprior:0L, $
         buttonmarginal:0L, $
         buttonlowsnr:0L, $
         buttonhvc:0L, $
         currentcode:0, $
         rabox_continue:rabox_continue, $
         centroid_text:0L, $
         sloancentroid:''}

delvarx, agcnorth, table3, rahr, decdeg

gfstate.iso[7]=-1.0   ;flag for custom iso level - not used by default


if (not (xregistered('galflux', /noshow))) then begin

;common galflux_state

;Initialize the common block
;galflux_initcommon, grid=grid, llx=llx, lly=lly, urx=urx, ury=ury, srcfile=srcfile, skym=skym

;WIDGET LAYOUT

;Top level base
tlb=widget_base(/row, title='GALflux', $
                tlb_frame_attr=1, xsize=1120, ysize=790, mbar=top_menu, $
                uvalue='tlb')

;Menu options

gfstate.fmenu=widget_button(top_menu, value=' File ', /menu)
  ;buttonopen=widget_button(gfstate.fmenu, value=' Open ', uvalue='galflux_open')
  ;buttonsave=widget_button(gfstate.fmenu, value=' Save ', uvalue='galflux_save')
  buttonps=widget_button(gfstate.fmenu, value=' Postscript and SRCfile ', uvalue='galflux_ps')
  ;buttonprint=widget_button(gfstate.fmenu, value=' Print ', uvalue='galflux_print')
  buttonexit=widget_button(gfstate.fmenu, value=' Exit ', /separator, $
                           event_pro='galflux_exit')

gfstate.settingsmenu=widget_button(top_Menu, value=' Settings ', /menu)
   buttoncustomlevel=widget_button(gfstate.settingsmenu, value='Set CUSTOM iso level', uvalue='setcustomlevel')
    buttoncrosshairs=widget_button(gfstate.settingsmenu, value= 'Crosshairs ON/OFF', uvalue='crosshairs')
  ;buttoncolors=widget_button(gfstate.settingsmenu, value=' ColorTable ', uvalue='colortable', $
  ;                         event_pro='galflux_colorsettings')
 
optionsmenu=widget_buttoN(top_Menu, value=' Options ', /menu)
   buttongetimages=widget_button(optionsmenu, value=' Fetch Optical Images ', uvalue='fetchdss')
   buttonsloancentroid=widget_button(optionsmenu, value=' Sloan Centroid ', uvalue='opennavigator')
   buttonaddcomments=widget_button(optionsmenu, value=' Comments ', event_pro='galflux_comments')
   ;buttonrmschange=widget_button(optionsmenu, value=' RMS markers ON/OFF ', uvalue='rmsmarkers')
   gfstate.buttonspikerepair=widget_button(optionsmenu, value=' Interpolate (spike repair)', uvalue='spikerepair', /Checked_Menu)
   ;buttonviewpols=widget_button(optionsmenu, value=' View both polarizations ', uvalue='viewbothpols')   

skymmenu=widget_button(top_Menu, value=' Median Sky ', /menu)
   gfstate.buttonskymreset=widget_button(skymmenu, value=' No Median Sky ', uvalue='skymreset', /Checked_Menu)
   gfstate.buttonskymframe=widget_button(skymmenu, value=' Median sky FRAME ', /Checked_Menu, /menu)
       gfstate.buttonskymframe_1=widget_button(gfstate.buttonskymframe, value=' 1 Pixel ', uvalue='skymframe_1', /Checked_Menu)
       gfstate.buttonskymframe_2=widget_button(gfstate.buttonskymframe, value=' 2 Pixel ', uvalue='skymframe_2', /Checked_Menu)
       gfstate.buttonskymframe_3=widget_button(gfstate.buttonskymframe, value=' 3 Pixel ', uvalue='skymframe_3', /Checked_Menu)
   gfstate.buttonskymcustom=widget_button(skymmenu, value=' Median sky CUSTOM ', uvalue='skymcustom', /Checked_Menu)

isophotemenu=widget_button(top_Menu, value=' Isophotes ', /menu)

    for i=0,n_elements(gfstate.isophote_widgetid)-1 do begin
        gfstate.isophote_widgetid[i]=widget_button(isophotemenu, value=gfstate.spectralistvals[i], $
                uvalue=strcompress(i, /remove_all), /Checked_Menu, event_pro='galflux_spectralist')
    endfor
  
   ;Initial menu setttings
    widget_control, gfstate.isophote_widgetid[0], set_button=1
    widget_control, gfstate.buttonskymreset, set_button=1

imagingmenu=widget_button(top_menu, value=' Imaging ', /menu)
   buttondss2blue=widget_button(imagingmenu, value= ' DSS2 Blue ', uvalue='dss2blue')
   buttonsloan=widget_button(imagingmenu, value= ' Sloan DSS ', uvalue='sloan')

gfstate.helpmenu=widget_button(top_menu, value=' Help ', /menu)
  buttoninstructions=widget_button(gfstate.helpmenu, value= ' Instructions ', uvalue='instructions')
  buttonabout=widget_button(gfstate.helpmenu, value= ' About ', uvalue='about')

;LEFT BASE
leftbase=widget_base(tlb, xsize=600, ysize=825, /column)
   gfstate.mainplotwindow=widget_draw(leftbase, xsize=600, ysize=350, /frame, $
       /motion_events, /button_events, uvalue='mainplotwindow', event_pro='galflux_maindisplay_event')
   gfstate.weightswindow=widget_draw(leftbase, xsize=600, ysize=70, /frame, $
                                       uvalue='weightswindow')

coordbase=widget_base(leftbase, xsize=485, ysize=30, /row, /frame)
   label=widget_label(coordbase, value='              Channel:')
     gfstate.currentchan=widget_label(coordbase, value='----')
   label=widget_label(coordbase, value='   Velocity:')
     gfstate.currentvel=widget_label(coordbase, value='--------------')
   label=widget_label(coordbase, value='   Flux Density:')
     gfstate.currentflux=widget_label(coordbase, value='--------------')

   cutoutbase=widget_base(leftbase, xsize=605, ysize=300, /row)
      gfstate.cubewindow=widget_draw(cutoutbase, xsize=295, ysize=295, /frame, uvalue='cubewindow')
      gfstate.dsswindow=widget_draw(cutoutbase, xsize=295, ysize=295, /frame, uvalue='dsswindow', /button_events)

   cutoutlabelbase=widget_base(leftbase, xsize=605, ysize=30, /row)
      ;maplabelbase=widget_base(cutoutlabelbase, xsize=295, ysize=30, /frame)
        ;gfstate.fmaxlabel=widget_label(maplabelbase, value='   ----------------------------------------------')
      
      imagebase=widget_base(cutoutlabelbase, xsize=295, ysize=30, /row)
   ;gfstate.imagelabel=widget_droplist(imagebase, value=gfstate.imageoptions, uvalue='imageoption')
   ;gfstate.imagesizelabel=widget_label(imagebase, value='                                  ')

;RIGHT BASE



rightbase=widget_base(tlb, xsize=500, ysize=850, /column)
gfstate.textdisplay = widget_text(rightbase, value = ['',''], xsize = 84, ysize = 14)

rangebase=widget_base(rightbase, xsize=480, ysize=30, /row, /frame)
   label=widget_label(rangebase, value='Xmin:')
     gfstate.xmin=widget_text(rangebase, xsize=5, value='0', /editable, uvalue='xmin')
   label=widget_label(rangebase, value='  Xmax:')
     gfstate.xmax=widget_text(rangebase, xsize=5, value=strcompress(nchn-1, /remove_all), /editable, uvalue='xmax')
   label=widget_label(rangebase, value='  Ymin:')
     gfstate.ymin=widget_text(rangebase, xsize=5, value='-20', /editable, uvalue='ymin')
   label=widget_label(rangebase, value='  Ymax:')
     gfstate.ymax=widget_text(rangebase, xsize=5, value='30', /editable, uvalue='ymax')
   label=widget_label(rangebase, value=' ')
   button=widget_button(rangebase, xsize=60, ysize=25, value=' Rescale ', uvalue='rescale')

qualitybase=widget_base(rightbase, xsize=485, ysize=30, /row, /frame, /exclusive)
        gfstate.buttonnostatus=widget_button(qualitybase, value='(0)No stat  ', uvalue='0', event_pro='galflux_codes')
        gfstate.buttondetection=widget_button(qualitybase, value='(1)Det  ', uvalue='1', event_pro='galflux_codes')
        gfstate.buttonprior=widget_button(qualitybase,     value='(2)Prior  ', uvalue='2', event_pro='galflux_codes')
        gfstate.buttonmarginal=widget_button(qualitybase, value='(3)Marg  ',  uvalue='3', event_pro='galflux_codes')
        gfstate.buttonlowsnr=widget_button(qualitybase,   value='(4)Marg+  ', uvalue='4', event_pro='galflux_codes')
        gfstate.buttonhvc=widget_button(qualitybase,   value='(9)HVC', uvalue='9', event_pro='galflux_codes')

widget_control, gfstate.buttonnostatus, set_button=1

buttonbase=widget_base(rightbase, xsize=485, ysize=250, /column, /align_left)

mainlabelbase=widget_base(buttonbase, /row, /align_left)
label=widget_label(mainlabelbase, value='MODE:    ')
mainmodebase=widget_base(mainlabelbase, /row, /frame, /align_left)
  gfstate.mainmode[0]=widget_button(mainmodebase, value='Ellipse ', uvalue='ellipsecalc') 
  gfstate.mainmode[1]=widget_button(mainmodebase, value='Baseline', uvalue='baselineoption') 
  gfstate.mainmode[2]=widget_button(mainmodebase, value='Measure ', uvalue='fitmodeon') 

hanningvals=['None', '3 point', '5 point', '7 point']

label=widget_label(mainmodebase, value='   Hanning:')
hanningdroplist=widget_droplist(mainmodebase, value=hanningvals, uvalue='hanning')

;ellipsebutton=widget_button(buttonbase, xsize=90, ysize=25, $
 ;                                value=' Ellipse Mode', uvalue='ellipsecalc')
;measurebutton=widget_button(buttonbase, xsize=90, ysize=25, $
 ;                                value=' Measurements ', uvalue='spectrameasure')


syserror=widget_button(mainmodebase, value='Sys Err', uvalue='syserror')

baselinelabelbase=widget_base(buttonbase, /row, /align_left)
label=widget_label(baselinelabelbase, value='BASELINE:')
baselinebase=widget_base(baselinelabelbase, /row, /align_left, /frame)
   ;baselineoptionbase=widget_base(baselinebase, /row, /align_left, /nonexclusive)
        ;gfstate.baselineoption=widget_button(baselineoptionbase, value=' Baseline mode on?    ', uvalue='baselineoption')

baselineresetbutton=widget_button(baselinebase, xsize=100, ysize=25, value= 'Reset baseline', uvalue='baselinereset')
label=widget_label(baselinebase, value='  Fit order:')

;Polynomial fit order - default value is 4th order
gfstate.baselineslider=widget_slider(baselinebase, min=1, max=11, $
                                        value=4, xsize=100, uvalue='baselineslider', /drag)

baselinesubtractbase=widget_base(baselinebase, /column, /align_left, /nonexclusive) 
        gfstate.baselineremove=widget_button(baselinesubtractbase, value='Remove Baseline?', uvalue='baselineremove') 


;Moved to the menu bar - January 2007

;isolabelbase=widget_base(buttonbase, /row, /align_left)
;label=widget_label(isolabelbase, value='ISOPHOTE:')
;isobase=widget_base(isolabelbase, /row, /align_left, /frame)
;    
;    droplistObj=fsc_droplist(isobase, value=gfstate.spectralistvals, $
;              event_pro='galflux_event', uvalue='spectralist', index=0, title='')
;    gfstate.spectralist=droplistObj->getID()

;   ;gfstate.spectralist=widget_droplist(isobase, value=gfstate.spectralistvals, event_pro='galflux_event', uvalue='spectralist')
;   label=widget_label(isobase, value='       ')
;   allmodebase=widget_base(isobase, /row, /align_left, /nonexclusive)
;   gfstate.allmodebutton=widget_button(allmodebase, value='Modify all in isophote list?           ', uvalue='setallmode')
;     widget_control, gfstate.allmodebutton, set_button=1


fitmodebase=widget_base(buttonbase, /column, /align_left, /frame, xsize=470)
;   fitmodeonbase=widget_base(fitmodebase, /row, /align_left, /nonexclusive)
;        gfstate.fitmodeonbutton=widget_button(fitmodeonbase, value=' Fit Mode on?    ', uvalue='fitmodeon')

peaksbase=widget_base(fitmodebase, /row, /align_left)

peaksfitbutton=widget_button(peaksbase, xsize=90, ysize=25, value=' PEAKS fit ', uvalue='peaksfit')
peaksresetbutton=widget_button(peaksbase, xsize=90, ysize=25, $
                                 value=' PEAKS reset ', uvalue='peaksreset')

numberpeaksbase=widget_base(peaksbase, /row, /align_left, /exclusive, /frame)
   gfstate.numberpeaks[0]=widget_button(numberpeaksbase, value='One peak        ', event_pro='galflux_event', uvalue='numberpeaks1')
   gfstate.numberpeaks[1]=widget_button(numberpeaksbase, value='Two peaks', event_pro='galflux_event', uvalue='numberpeaks2')
     widget_control, gfstate.numberpeaks[1], set_button=1


gaussianbase=widget_base(fitmodebase, /row, /align_left)
gaussfitbutton=widget_button(gaussianbase, xsize=90, ysize=25, value=' GAUSS fit ', uvalue='gaussfit')
gaussresetbutton=widget_button(gaussianbase, xsize=90, ysize=25, $
                                 value=' GAUSS reset ', uvalue='gaussreset')

label=widget_label(gaussianbase, value='    Gaussian Width: ')
gfstate.gausswidthbox=widget_text(gaussianbase, xsize=5, value='7', /editable, uvalue='gausswidthbox')
  label=widget_label(gaussianbase, value=' channels             ')



fitlabelbase=widget_base(fitmodebase, /row, /align_left)
   label=widget_label(fitlabelbase, value='MSR MODE: ')
fittingmodebase=widget_base(fitlabelbase, /row, /align_left, /exclusive, /frame)
          gfstate.fitmode[0]=widget_button(fittingmodebase, value='Gaussian             ', uvalue='gaussian')
          gfstate.fitmode[1]=widget_button(fittingmodebase, value='Peaks', uvalue='peaks')
           widget_control, gfstate.fitmode[1], set_button=1  ;Default is peaks mode


catalogbase=widget_base(rightbase, xsize=480, ysize=100, /row)
   agcbase=widget_base(catalogbase, xsize=230, ysize=100, /column)
      label=widget_label(agcbase, value='Add an AGC entry')
      gfstate.agclist=widget_list(agcbase, value=['',''], xsize=35, ysize=4, uvalue='agclist')
   digitalHIbase=widget_base(catalogbase, xsize=230, ysize=100, /column)
      label=widget_label(digitalHIbase, value='Digital HI Archive entries')
      gfstate.digitalHIlist=widget_list(digitalHIbase, value=['',''], xsize=35, ysize=4, uvalue='digitalhilist')

agcinfobase=widget_base(rightbase, xsize=480, ysize=110, /column)

gfstate.agcinfo=widget_text(agcinfobase, value = ['AGC Information display'], xsize = 85, ysize = 13)

;Realization
widget_control, tlb, /realize

gfstate.baseID=tlb

;Xmanager startup
xmanager, 'galflux', gfstate.baseID, /no_block


;outstring=['GALflux: ALFALFA spectrum measurement tool', '(c) 2006-2007 LOVEData, Inc.', '',$
;           'Obtaining DSS2 Blue and Sloan images...']

;widget_control, gfstate.textdisplay, set_value=outstring
;galflux_dssfetch

outstring=['GALflux: ALFALFA spectrum measurement tool (v.3.0)', '(c) 2006-2007 LOVEData, Inc.', 'Standing by...', $
   '', 'Choose an option from the MEDIAN SKY menu to perform a median sky subtraction',$
       ' before you begin.', $
   '', 'RIGHT-click to drag a zoom box.', 'LEFT-click to mark the channel edges of the detection.', $
   'Click ELLIPSE FIT to centroid/fit ellipses']

widget_control, gfstate.textdisplay, set_value=outstring

galflux_plotter

;Values that only work for this setup

!p.clip=[90,60,573,370,0,1000]

!x.region=[ 0.00000 ,     1.00000]
!x.s=[0.15000500,   0.00078690126]
!x.margin=[ 10.0000 ,     3.00000]
!x.window=[ 0.150005 ,    0.955005]
!x.crange=gfstate.mainxrange
!x.range=gfstate.mainxrange


!y.region=[ 0.00000 ,     1.00000]
!y.s=[0.46000502,     0.015500000]
!y.margin=[ 4.0,     2.00000]
!y.window=[ 0.150005 ,    0.925005]
!y.crange=gfstate.mainyrange
!y.range=gfstate.mainyrange

;print, systime(1)-T 

endif




;galflux_startup, grid=grid, llx=llx, lly=lly, $
;                 urx=urx, ury=ury, srcfile=srcfile, skym=skym


;widget_control, waitbase, /destroy


end
