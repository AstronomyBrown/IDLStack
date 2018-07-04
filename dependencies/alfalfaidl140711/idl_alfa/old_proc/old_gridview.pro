;+
; NAME:
;      GRIDView
; PURPOSE:
;       Visualization tool for astronomical 3D data cubes.
;
; EXPLANATION:
;
;       GRIDView displays output from the grid_prep
;       procedure.  It shows the 2-D view of the RA/Dec plane 
;       and allows the user to move through the cube in cz, changing
;       polarization, etc.  The user can also switch to a continuum
;       view of data in the grid structure  A clickable color bar can scale the
;       intensity/contrast of the image.  A weights map shows the
;       spectral/continuum weights.  The GRIDinfo and controls are
;       found in the lower left of the screen.  They include sliders
;       to move the spectral cube and choose the level of boxcar
;       smoothing.  The user can use the keyboard, NEXT/PREVIOUS
;       buttons, or arrow keys to "move" through the grid.  The
;       default is for single channel display.  Selected the
;       integration button will sum plus/minus the number of channels
;       specified.  Plus/minus 5 channels is recommended as a given
;       default.  In spectral mode, the AGC can be overlaid on the
;       map, and clicking on the map will give a DSS 2 blue image of
;       specified size in the lower right corner.  In continuum mode,
;       the NVSS will be overlaid, color-coded by intensity, and 
;       clicking on the map will give an NVSS image of specified size
;       in the lower right corner.  The user can customize the color
;       scheme under the settings menu, and scalling (linear, log,
;       hist_eq) is chosen under the scaling menu (linear is default).
;       Log scaling is determined by calculating an offset and
;       subtracting before taking the log of the pixels.  Passing a
;       keyword with a filename for a 3D extracted catalog will give
;       the user the option of overlaying the catalog contents.
;
;
; CALLING SEQUENCE:
;       gridview, grid
;
; INPUTS:
;       grid - grid structure as output by grid_prep
;
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;    cat3D=filenamestring - allows user to overlay a 3D extractor catalog
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
;       Pretty straight forward:  gridview, grid, cat3D='my_awesome_galaxies.cat'
;
; PROCEDURES USED:
;         DSSQUERY, GSFC IDL USER'S LIBRARY
;         HOR.  See pjp AO library
;         VER.  See pjp AO library
;         TVCIRCLE
;         ADSTRING
;         TVBOXBK
;         NEDQUERY, written by B. Kent, Cornell Univ.
;         
;
;
;
; MODIFICATION HISTORY:
;       WRITTEN, Brian Kent, Cornell U., October 2, 2005
;       October  26, 2005, B. Kent - weights window added, GUI
;                                     reorganized
;       November  3, 2005, B. Kent - spectra display option
;       November  8, 2005. B. Kent - smoothing and scaling options
;                                     added.
;       November 26, 2005. B. Kent - Colorbar autoscaling
;       November 27, 2005. B. Kent - weights map doesn't scale
;                                  - Simple spectrum display
;                                  - cube pixel values shown
;                                  - allowed constant value scaling
;                                    option
;       November 28, 2005. B. Kent - Zoom function added to spectrum
;                                    display.  Aperture option
;                                    removed.
;       November 29, 2005. B. Kent - Zoom function added to main
;                                    window.  Spectral weights added
;                                    to spectrum display
;       November 30, 2005. B. Kent - AGC info display fixed.
;       December  1, 2005. B. Kent - New version distributed.
;       December  2, 2005. B. Kent - Added NED Search Query
;       December 13, 2005. B. Kent - custom catalog overlay
;                                  - cz defaults to 21 cm
;                                    measurements and widths,
;                                    otherwise then goes to optical.
;       December 21, 2005. B. Kent - Detcode added to AGC display
;        January 07, 2006. B. Kent - fixed AGC (no cz) option -
;                                     thanks to MPH!
;        January 08, 2006. B. Kent - added Sloan to cutout optical
;                                    image option.  Access through
;                                    spawn and wget. 
;        January 15, 2006. B. Kent - Added AGC-multi mode - display
;                                    all AGC galaxies with different
;                                    colors based on current cz status.
;
;----------------------------------------------------------


;-------------------------------------------
; Initialize common block
pro gridview_initcommon, data, cat3D=cat3D

common gridview_state, state

;data=congrid(data,420,420,735)

;gridswitch, reform(data.d[*,0,*,*]), dataout

;dataout=congrid(dataout,420,420,735)

ramin=data.ramin
ramax=data.ramin+data.(6)*(data.deltara/3600.0)
decmin=data.decmin
decmax=data.decmin+data.(7)*(data.deltadec/60.0)

;racenter=ramin+(ramax-ramin)/2.0
;deccenter=decmin+(decmax-decmin)/2.0

;print, racenter
;print, deccenter

;print, double(decmax-decmin)*60.

;print, 'Obtaining Optical image.  Please wait...'
;queryDSS, [racenter*15.0,deccenter], image, header, imsize=double(decmax-decmin)*60., survey='2b'

;restore, 'imagetest.sav'

;image=randomn(1,1000,1000)



;optimagesize=size(image)
;image=congrid(image, optimagesize[1], optimagesize[1])

;raimagearr=(dindgen(optimagesize[1])/(optimagesize[1]-1))*(ramax-ramin)+ramin
;decimagearr=(dindgen(optimagesize[1])/(optimagesize[1]-1))*(decmax-decmin)+decmin

;raimagearr=(dindgen(optimagesize[1])/(optimagesize[1]-1))*(2.0)+12.0
;decimagearr=(dindgen(optimagesize[1])/(optimagesize[1]-1))*(2.0)+9.0


;raimagearr=reverse(raimagearr)

;raarr=findgen(420)/419.0*(ramax-ramin)+ramin
;raarr=reverse(raarr)
;decarr=findgen(420)/419.0*(decmax-decmin)+decmin
;czarr=findgen(735)/734.0*(data.velarr[0]-data.velarr[n_elements(data.velarr)-1])+data.velarr[n_elements(data.velarr)-1]
;czarr=reverse(czarr)

imagesize=strcompress(15.0*float(ramax-ramin), /remove_all)+' X '+$
        strcompress(float(decmax-decmin), /remove_all)+' degrees'
velrange=strcompress(float(data.velarr[n_elements(data.velarr)-1]), /remove_all)+ ' to '+$
 strcompress(float(data.velarr[0]), /remove_all)+' km/s'


;restore, '/home/dorado4/bkent/a2010/virgo3D/table3D.sav'
;restore, '/home/caborojo4/bkent/a2010/virgosouth/table2D.sav'


;If passed as a keyword, open and rearrange the input 3D catalog

if (n_elements(cat3D) ne 0) then begin
  ;print, '3D catalog!'
  restore, '/home/dorado3/galaxy/idl_alfa/catalog_template.sav' 
  table3D=read_ascii(cat3D, template=catalog_template)
  ;convert3Dcat, catin, table3D
  extracats=1
endif else begin
  ;opens catalog_template and dummy file
  restore, '/home/dorado3/galaxy/idl_alfa/catalog_template.sav'
  extracats=0
endelse

;restore, '/home/dorado4/bkent/a2010/virgo3D/table3D.sav'
;extracats=1

;Open AGC NORTH AND NVSS FOR ALFALFA RANGE
restore, '/home/dorado3/galaxy/idl_alfa/agcnorth.sav'
restore, '/home/dorado3/galaxy/idl_alfa/nvsscat_alfalfa.sav'

agc=agcnorth 
rec=n_elements(agc.agcnumber) 
rahr=dblarr(rec) 
decdeg=dblarr(rec) 

rahr=double(agc.rah)+double(agc.ram)/double(60.0)+double(agc.ras10)/(10.0D)/3600.0D
decdeg=abs(double(agc.decd))+double(agc.decm)/double(60.0)+double(agc.decs)/3600.0D
signs=where(agc.sign eq '-')
if (signs[0] ne -1) then decdeg[signs]=-decdeg[signs]


state={baseID:0L, $                           ; ID of top base
       fmenu:0L, $                            ; ID of File menu
       helpmenu:0L, $                         ; ID of Help menu
       settingsmenu:0L, $                     ; ID of Settings menu
       scalingmenu:0L, $                      ; ID of image scaling menu
       plotwindowone:0L, $                    ; ID of main window where image is shown
       plotwindowtwo:0L, $                    ; ID of window for weights display
       plotwindowcolorbar:0L, $               ; ID of window for colorbar
       plotwindowimage:0L, $                  ; ID of DSS/NVSS image display
       data:data, $                           ; Structure for the grid (output of grid_prep)
       ramin:ramin, $
       ramax:ramax, $
       decmin:decmin, $
       decmax:decmax, $
       xcubemin:0, $
       xcubemax:n_elements(data.d[0,0,*,0])-1, $
       ycubemin:0, $
       ycubemax:n_elements(data.d[0,0,0,*])-1, $
       xval:0L, $                             ; ID for RA label
       yval:0L, $                             ; ID for Dec label
       zval:0L, $                             ; ID for cz label
       xpix:0L, $                             ; ID for x pixel label
       ypix:0L, $                             ; ID for y pixel label
       intensitylevel:0L, $                   ; ID for pixel intensity level
       mousestatus:0L, $                      ; mousestatus for colorbar control
       imagesize:imagesize, $                 ; String for GRIDinfo display for image size
       velrange:velrange, $                   ; String for GRIDinfo display for velocity range
       projection:'Projection: '+data.map_projection, $
       epoch:'Epoch: '+strcompress(data.epoch, /remove_all), $
       dataset:'Dataset: '+data.name, $
       velslider:0L, $
       smoothslider:0L, $
       gotochannel:0L, $
       colortable:1, $
       polbutton:lonarr(3), $
       currentpol:2, $
       polAcolor:3, $
       polBcolor:8, $
       avgpolcolor:1, $
       polAselect:0L, $
       polBselect:0L, $
       avgpolselect:0L, $
       velintegselect:0L, $
       velintegselectstatus:0, $
       velintegtext:0L, $
       px:fltarr(2), $
       py:fltarr(2), $
       sx:0.0, $
       sy:0.0, $
       multiagcstatus:0, $
       agcoverlaystatus:0, $ 
       agcoverlaystatus_nocz:0,$
       overlaystatus3D:0,$
       overlaystatus2D:0,$
       nvssoverlaystatus:0, $
       agc:agc, $
       rahr:rahr, $
       decdeg:decdeg, $
       currentagc:lonarr(3,5000), $
       currentagc_nocz:lonarr(3,5000), $
       agcinfo:'', $
       nvsscat:nvsscat, $
       exportstart:0L, $
       exportnumframes:0L, $
       exportnumsteps:0L, $
       exportdirectory:0L, $
       apertureFWHM:0L, $
       plotwindowspectrum:0L, $
       plotwindowspectrumweights:0L, $
       spectrumwindowwidth:0L, $
       getspectrumstatus:0, $
       spectrumaxisbutton:lonarr(2), $
       spectrumaxisstatus:0, $    ;0 for velocity, and 1 for channels
       spectrum:dblarr(n_elements(data.velarr)), $
       spectrumweights:dblarr(n_elements(data.velarr)), $
       maxweight:max(data.w), $
       spectrum_xmin:0, $
       spectrum_xmax:0, $
       spectrum_ymin:0, $
       spectrum_ymax:0, $
       spectrumon:0, $
       stretchlower:0, $
       stretchupper:200, $
       minval:0.0D, $
       maxval:0.0D, $
       colorbar_y:0, $
       opticalsize:0L, $
       imageoptions:[' DSS Image Display', 'SDSS Image Display'], $
       currentimage:0, $
       dssimage:dblarr(225,225), $
       sloanimage:dblarr(3,225,225), $
       mapchoice:lonarr(2), $
       mapcurrent:'spectral', $ 
       imagelabel:0L, $
       copyright:0L, $
       keystatus:0, $
       currentscaling:'linearscaling', $
       colorbarscaling:'colorbar_autoscale', $
       extracats:extracats, $
       table3D:table3D, $
       colorbarmin:-5.0, $     ;Default minimum
       colorbarmax:10.0, $     ;Default maximum
       colorbarmin_text:0L, $
       colorbarmax_text:0L, $
         wid:0L, $          ; The window index number.
         drawID:0L, $    ; The draw widget identifier.
         pixID:-1, $         ; The pixmap identifier (undetermined now).
         xsize:0, $      ; The X size of the graphics window.
         ysize:0, $      ; The Y size of the graphics window.
         zoomsx:-1, $            ; The X value of the static corner of the box.
         zoomsy:-1, $            ; The Y value of the static corner of the box.
         boxColor:0L } ; The rubberband box color.}


    ;   table2D:table2D, $
    ;   table3D:table3D}

;Remove unneeded variables
delvarx, agcnorth, agc, nvsscat, table3D, cattable, table2D, catalog_template


end






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;STARTUP;;;;;;;;;;;;;
pro gridview_startup, data, cat3D=cat3D

if (not (xregistered('gridview', /noshow))) then begin

;print, 'Gridview startup'

common gridview_state

gridview_initcommon, data, cat3D=cat3D

set_plot, 'x'

loadct, 1, /silent
stretch, state.stretchlower,state.stretchupper

;Reset plots
hor
ver
!p.multi=0
device, decomposed=0

;Create widgets

;Top level base
tlb=widget_base(/column, title='GRIDview', $
                tlb_frame_attr=1, xsize=1150, ysize=900, mbar=top_menu, $
                uvalue='tlb')

;Menu options
state.fmenu=widget_button(top_menu, value=' File ')
 
  buttonjpegoutput=widget_button(state.fmenu, value=' Export JPEG ', event_pro='gridview_jpeg_output')
  buttonexit=widget_button(state.fmenu, value=' Exit ', /separator, $
                           event_pro='gridview_exit')

state.settingsmenu=widget_button(top_Menu, value=' Settings ')
  buttonpolsettings=widget_button(state.settingsmenu, value=' Pol Colors ', uvalue='polcolors', $
                           event_pro='gridview_polsettings')
  buttonscalesettings=widget_button(state.settingsmenu, value=' Colorbar scale ', uvalue='scalesettings', $
                           event_pro='gridview_scalesettings')

state.scalingmenu=widget_button(top_menu, value=' Scaling ')
  buttonlinear=widget_button(state.scalingmenu, value=' Linear ', uvalue='linearscaling')
  buttonlog=widget_button(state.scalingmenu, value=' Logarithmic ', uvalue='logscaling')
  buttonhisteq=widget_button(state.scalingmenu, value=' Histogram EQ ', uvalue='histeqscaling')

colorbarmenu=widget_button(top_menu, value=' Colorbar ')
  button_autoscale=widget_button(colorbarmenu, value=' Autoscale ', uvalue='colorbar_autoscale')
  button_constantscale=widget_button(colorbarmenu, value=' Constant scale ', uvalue='colorbar_constantscale')

catalogmenu=widget_button(top_menu, value=' Catalogs ')
  buttonmultiagc=widget_button(catalogmenu, value= ' Multi-AGC mode', uvalue='multiagc')
  buttonagccatalog=widget_button(catalogmenu, value=' AGC Catalog (known cz)', uvalue='agcoverlay')
  buttonagccatalog_nocz=widget_button(catalogmenu, value=' AGC Catalog (no known cz)', uvalue='agcoverlay_nocz') 
  buttonnvsscatalog=widget_button(catalogmenu, value=' NVSS Catalog ', uvalue='nvssoverlay') 
  buttoncatalog3D=widget_button(catalogmenu, value=' 3D Catalog ', uvalue='catalog3D') 
  buttoncatalog2D=widget_button(catalogmenu, value=' 2D Catalog (not active)', uvalue='catalog2D') 

state.helpmenu=widget_button(top_menu, value=' Help ')
  buttonquickstart=widget_button(state.helpmenu, value= ' Quickstart ', event_pro='gridview_quickstart')
  buttonhelp=widget_button(state.helpmenu, value= ' About ', event_pro='gridview_help')
  

;RIGHT BASE - upper base on the screen

rightbase=widget_base(tlb, xsize=1125, ysize=500, frame=1, /row)
     state.plotwindowone=widget_draw(rightbase, xsize=495, ysize=495, frame=1, $
               uvalue='plotwindowone', event_pro='gridview_display_event', /motion_events, /button_events, retain=2,$
               keyboard_events=1)
     state.plotwindowcolorbar=widget_draw(rightbase, xsize=100, ysize=495, frame=1, uvalue='plotwindowcolorbar', $
                                       event_pro='gridview_display_event', /motion_events, /button_events)
     state.plotwindowtwo=widget_draw(rightbase, xsize=495, ysize=495, frame=1, $
               uvalue='plotwindowone', event_pro='gridview_display_event', retain=2)



;LEFT BASE - Information display / controls

leftbase=widget_base(tlb, xsize=1000, ysize=375, frame=1, /row)
 
infocontrolbase=widget_base(leftbase, xsize=430, ysize=370, /column)

     lowerbase=widget_base(infocontrolbase,  xsize=420, ysize=150,frame=1, /row)
     infobase=widget_base(lowerbase,  xsize=210, ysize=140, /column)
        label=widget_label(infobase, value='GRIDinfo', frame=1)
        label=widget_label(infobase, value=state.dataset)
        label=widget_label(infobase, value=state.imagesize)
        label=widget_label(infobase, value=state.velrange)
        label=widget_label(infobase, value=state.epoch)
        ;label=widget_label(infobase, value=state.projection)
        
  mapchoicebase=widget_base(infobase, /row, /align_left, /exclusive)
          state.mapchoice[0]=widget_button(mapchoicebase, value='Spectral    ', uvalue='spectral')
          state.mapchoice[1]=widget_button(mapchoicebase, value='Continuum', uvalue='continuum')
           widget_control, state.mapchoice[0], set_button=1

     coordbase=widget_base(lowerbase,  xsize=210, ysize=150, /column)
        xbase=widget_base(coordbase, /row)
           label=widget_label(xbase, value='RA value:  ')
           state.xval=widget_label(xbase, value='12 23 24.54654')
        ybase=widget_base(coordbase, /row)
           label=widget_label(ybase, value='DEC value: ')
           state.yval=widget_label(ybase, value='12 23 24.56546')
        zbase=widget_base(coordbase, /row)
           label=widget_label(zbase, value='cz value:  ')
           state.zval=widget_label(zbase, value=strcompress(state.data.velarr[0]))
        xpixbase=widget_base(coordbase, /row)
           label=widget_label(xpixbase, value='X pixel:  ')
           state.xpix=widget_label(xpixbase, value='999')
        ypixbase=widget_base(coordbase, /row)
           label=widget_label(ypixbase, value='Y pixel:  ')
           state.ypix=widget_label(ypixbase, value='999')
        brightnessbase=widget_base(coordbase, /row)
           label=widget_label(brightnessbase, value='Intensity: ')
           state.intensitylevel=widget_label(brightnessbase, value='999.999999')
       

     sliderbase=widget_base(infocontrolbase, xsize=390, ysize=50, /row)
        state.velslider=widget_slider(sliderbase, min=0, max=n_elements(state.data.velarr)-1, $
                                      title='Channel', value=0, xsize=230, uvalue='velslider', /drag)
        gotobase=widget_base(sliderbase, xsize=180, ysize=35, /row)
        label=widget_label(gotobase, value='     Goto channel:')
        state.gotochannel=widget_text(gotobase, xsize=8, value='0',$ 
                                      /editable, uvalue='gotochannel')
     buttoncontrolbase=widget_base(infocontrolbase, xsize=390, ysize=40, /row)
        
        buttonprevious=widget_button(buttoncontrolbase, xsize=90, ysize=25, $
                                 value=' PREVIOUS ', uvalue='previouschannel')
        buttonnext=widget_button(buttoncontrolbase, xsize=90, ysize=25, $
                                 value=' NEXT ', uvalue='nextchannel')

        label=widget_label(buttoncontrolbase, value='     Smooth width: ')
        state.smoothslider=widget_slider(buttoncontrolbase, min=0, max=10, $
                                        value=3, xsize=120, uvalue='smoothslider', /drag)


        choicebase=widget_base(infocontrolbase, /row, /align_left)
        polbase=widget_base(choicebase, /column, /align_left, /exclusive, /frame)
          state.polbutton[0]=widget_button(polbase, value='Pol A   ', uvalue='pola')
          state.polbutton[1]=widget_button(polbase, value='Pol B',    uvalue='polb')
          state.polbutton[2]=widget_button(polbase, value='Avg Pol', uvalue='avgpol')
          widget_control, state.polbutton[2], set_button=1
          state.currentpol=2
          state.colortable=1

        choicebase2=widget_base(choicebase, /column, /align_left)
        integrationbase=widget_base(choicebase2, ysize=30, /row, /align_left, /frame)
        integrationbuttonbase=widget_base(integrationbase, ysize=25, /row, /align_left, /nonexclusive)
          state.velintegselect=widget_button(integrationbuttonbase, value='   Smooth over (+/-): ', $
                                             uvalue='velintegselect')
          state.velintegtext=widget_text(integrationbase, value='5', xsize=8, /editable, uvalue='velintegtext')
          label=widget_label(integrationbase, value='  channels')

        agcinfobase=widget_base(choicebase2, ysize=30, /row, /align_left, /frame)
        state.agcinfo=widget_label(agcinfobase, value='        AGC Information Displayed Here           ')
       
        ;agcbase=widget_base(choicebase2, ysize=35, /row, /align_left)
        ;agcbuttonbase=widget_base(agcbase, ysize=25, /row, /align_left, /nonexclusive, /frame)
        ;state.agcoverlay=widget_button(agcbuttonbase, value='Overlay AGC galaxies', $
        ;                                     uvalue='agcoverlay')
        ;nvssbuttonbase=widget_base(agcbase, ysize=25, /row, /align_left, /nonexclusive, /frame)
        ;state.nvssoverlay=widget_buttON(nvssbuttonbase, value='Overlay NVSS sources', $
        ;                                     uvalue='nvssoverlay')
        
;SPECTRUM DISPLAY

spectrumbase=widget_base(leftbase, xsize=445, ysize=360, /column)

;label=widget_label(spectrumbase, value='Spectrum Display', frame=1, /align_center)
state.plotwindowspectrum=widget_draw(spectrumbase, xsize=420, ysize=210, frame=1, $
             uvalue='plotwindowspectrum', retain=2, /button_events, event_pro='gridview_display_event')
state.plotwindowspectrumweights=widget_draw(spectrumbase, xsize=420, ysize=100, frame=1, $
             uvalue='plotwindowspectrumweights', retain=2, /button_events, event_pro='gridview_display_event')

spectrumbuttonbase=widget_base(spectrumbase, xsize=420, ysize=30, /row)
  getspectrum=widget_button(spectrumbuttonbase, xsize=120, ysize=25, value=' GET SPECTRUM ', uvalue='getspectrum')
  ;label=widget_label(spectrumbuttonbase, value='     Aperture FWHM: ')
  ;state.apertureFWHM=widget_text(spectrumbuttonbase, xsize=8, value='4.0', /editable, uvalue='apertureFWHM')
  ;label=widget_label(spectrumbuttonbase, value=' arcminutes')

;spectrumchannelbase=widget_base(spectrumbase, xsize=420, ysize=30, /row)
;label=widget_label(spectrumbuttonbase, value='Spectral window width: ')
;state.spectrumwindowwidth=widget_text(spectrumbuttonbase, xsize=8, value='250', /editable, uvalue='spectrumwindowwidth')
;label=widget_label(spectrumbuttonbase, value=' channels')

;spectrumaxisbase=widget_base(spectrumbase, xsize=420, ysize=30, /row, /align_left)
label=widget_label(spectrumbuttonbase, value='       ')
spectrumaxisbuttonbase=widget_base(spectrumbuttonbase, /row, /align_left, /exclusive)
  state.spectrumaxisbutton[0]=widget_button(spectrumaxisbuttonbase, value='Velocity      ', uvalue='axisvelocity')
  state.spectrumaxisbutton[1]=widget_button(spectrumaxisbuttonbase, value='Channel', uvalue='axischannel')
  widget_control, state.spectrumaxisbutton[0], set_button=1


;DSS/NVSS Image Display

imagebase=widget_base(leftbase, xsize=230, ysize=360, /column)
 
  state.plotwindowimage=widget_draw(imagebase, xsize=225, ysize=225, frame=1, uvalue='plotwindowimage')

   

   state.imagelabel=widget_droplist(imagebase, value=state.imageoptions, event_pro='gridview_event', uvalue='imageoption')

;   info.ncalibcalmaskbeamselect=widget_droplist(ncalibcalmaskheader, value=beamselections, $
;           event_pro='bpdgui_calmaskselect')

;   state.imagelabel=widget_label(imagebase, value=' DSS Image Display', frame=1, /align_center)
  label=widget_label(imagebase, value='Click the HI map for an image')
  sizetextbase=widget_base(imagebase, xsize=300, ysize=30, /row)
  label=widget_label(sizetextbase, value='Image size:  ')
  state.opticalsize=widget_text(sizetextbase, xsize=5, value='10', /editable, uvalue='opticalsize')
  label=widget_label(sizetextbase, value=' arcmin')
  spacer=widget_base(imagebase, xsize=200, ysize=20)
  state.copyright=widget_draw(imagebase, xsize=150, ysize=20, uvalue='copyright', $
                         /align_right, /button_events, event_pro='gridview_display_event')
   
;Realization
widget_control, tlb, /realize

state.baseID=tlb

;Xmanager startup
xmanager, 'gridview', state.baseID, /no_block

 widget_control, state.copyright, get_value=index
 wset, index
 xyouts, 10, 6, 'LOVEDATA, Inc.  Ithaca, NY', /device

endif 

end 


;------------------------------------------------------------------
;DISPLAY EVENT HANDLER

pro gridview_display_event, event

common gridview_state

widget_control, event.id, get_uvalue=uvalue

case uvalue of

    'plotwindowone': begin
        
        



;--------------------------------------------------------------------------
;--------------------------------------------------------------------------

       ;First section of case choice is reserved for zoom box
       ;Begin preliminary case statement for mouse control and motion 

if (event.type le 2 AND event.press ne 4 AND state.getspectrumstatus eq 0) then begin

;print, 'EVENT TYPE ', event.type
;print, 'EVENT PRESS ' , event.press

eventTypes = ['DOWN', 'UP', 'MOTION']
thisEvent = eventTypes[event.type]
state.xsize=495
state.ysize=495

widget_control, state.gotochannel, get_value=channelstring
               channel=long(channelstring[0])

CASE thisEvent OF

   'DOWN': BEGIN
      if (event.press eq 1) then begin
       ; Turn motion events on for the draw widget.

       state.mousestatus=1

      Widget_Control, state.plotwindowone, Draw_Motion_Events=1
      widget_control, state.plotwindowone, get_value=index
      state.wid=index
      state.drawID=state.plotwindowone

         ; Create a pixmap. Store its ID. Copy window contents into it.

      Window, /Free, /Pixmap, XSize=state.xsize, YSize=state.ysize
      state.pixID = !D.Window
      Device, Copy=[0, 0, state.xsize, state.ysize, 0, 0, state.wid]

         ; Get and store the static corner of the box.

      state.zoomsx = event.x
      state.zoomsy = event.y


      endif
  END


   'UP': BEGIN
      
      if (state.mousestatus eq 1) then begin

       state.mousestatus=0

         ; Erase the last box drawn. Destroy the pixmap.

      widget_control, state.plotwindowone, get_value=index
      state.wid=index
      state.drawID=state.plotwindowone

      WSet, state.wid
      Device, Copy=[0, 0, state.xsize, state.ysize, 0, 0, state.pixID]
      

       

         ; Order the box coordinates.

      sx = Min([state.zoomsx, event.x], Max=dx)
      sy = Min([state.zoomsy, event.y], Max=dy)

        ;New min and max for zooming
   
      ;print, sx,sy,dx,dy

     WDelete, state.pixID

     ;Determine coordinates FOR SQUARE BOX to zoom in on

     width=abs(dx-sx)

     xpos_min=sx
     xpos_max=dx
     ypos_min=sy

     if (sy lt dy) then ypos_max=sy+width
     if (sy gt dy) then ypos_max=sy-width
     if (sy eq dy) then ypos_max=dy
     ;Convert from device window coords to
     ;   enlarged cube coords, and then to original cube cooridnates

     ;print, 'Device ',xpos_min, xpos_max, ypos_min, ypos_max
     ;print, 'S and D ', sx,dx,sy,dy

     xpos_min=round(xpos_min-state.px[0]-1) 
     xpos_max=round(xpos_max-state.px[0]-1) 
     ypos_min=round(ypos_min-state.py[0]-1)
     ypos_max=round(ypos_max-state.py[0]-1)


     if ((sx eq dx AND sy eq dy) OR $
         (xpos_min lt 0  OR ypos_min lt 0 OR $
          xpos_max gt state.sx-1 OR ypos_max gt state.sy-1) $
        ) then begin
         ;print, 'Zooming out'
         state.xcubemax=n_elements(state.data.d[0,0,*,0])-1
         state.xcubemin=0
         state.ycubemin=0
         state.ycubemax=n_elements(state.data.d[0,0,0,*])-1
         
         state.ramin=state.data.ramin
         state.ramax=state.data.ramin+state.data.(6)*(state.data.deltara/3600.0)
         state.decmin=state.data.decmin
         state.decmax=state.data.decmin+state.data.(7)*(state.data.deltadec/60.0) 

     endif else begin
     ;print, 'Cube LARGE ',xpos_min, xpos_max, ypos_min, ypos_max

     state.xcubemax=-round(float(state.xcubemax-state.xcubemin+1)/state.sx*xpos_min)+(state.xcubemax)
     state.xcubemin=-round(float(state.xcubemax-state.xcubemin+1)/state.sx*xpos_max)+(state.xcubemax)
     state.ycubemin=round(float(state.ycubemax-state.ycubemin+1)/state.sy*ypos_min)+(state.ycubemin)
     state.ycubemax=round(float(state.ycubemax-state.ycubemin+1)/state.sy*ypos_max)+(state.ycubemin)

     ;Protect against going 'outside' the cube
     if (state.xcubemin lt 0) then state.xcubemin=0
     if (state.ycubemin lt 0) then state.ycubemin=0
     if (state.xcubemax gt n_elements(state.data.d[0,0,*,0])-1) then state.xcubemax=n_elements(state.data.d[0,0,*,0])-1
     if (state.ycubemax gt n_elements(state.data.d[0,0,0,*])-1) then state.ycubemax=n_elements(state.data.d[0,0,0,*])-1

     ;print, 'Cube Small ',state.xcubemin,state.xcubemax,state.ycubemin,state.ycubemax

     index_min=where(state.data.grid_makeup.i eq state.xcubemin AND $
                     state.data.grid_makeup.j eq state.ycubemin)
     index_max=where(state.data.grid_makeup.i eq state.xcubemax AND $
                     state.data.grid_makeup.j eq state.ycubemax)

     state.ramin=state.data.grid_makeup[index_min].ra-(state.data.deltara/3600.0)/2.0
     state.ramax=state.data.grid_makeup[index_max].ra+(state.data.deltara/3600.0)/2.0
     state.decmin=state.data.grid_makeup[index_min].dec-(state.data.deltadec/3600.0)/2.0
     state.decmax=state.data.grid_makeup[index_max].dec+(state.data.deltadec/3600.0)/2.0

     ;state.ramin=state.data.ramin+state.xcubemin*(state.data.deltara/3600.0)
     ;state.ramax=state.data.ramin+state.xcubemax*(state.data.deltara/3600.0)
     ;state.decmin=state.data.decmin+state.ycubemin*(state.data.deltadec/60.0)
     ;state.decmax=state.data.decmin+state.ycubemax*(state.data.deltadec/60.0)
     
     endelse

;     print, xpos_min,xpos_max, ypos_min, ypos_max


  ; Turn draw motion events off. Clear any events queued for widget.

    Widget_Control, state.drawID, Clear_Events=1

    


   gridview_display, channel
   gridview_display_weights, channel


   endif



      END

   'MOTION': BEGIN
       if (event.press eq 0 AND state.mousestatus eq 1) then begin

         ; Here is where the actual box is drawn and erased.
         ; First, erase the last box.

      widget_control, state.plotwindowone, get_value=index
      state.wid=index
      state.drawID=state.plotwindowone

      WSet, state.wid
      Device, Copy=[0, 0, state.xsize, state.ysize, 0, 0, state.pixID]

         ; Get the coodinates of the new box and draw it.

      sx = state.zoomsx
      sy = state.zoomsy
      dx = event.x
      dy = event.y
      loadct, 1, /silent
      state.boxcolor=!D.N_Colors-1

     
      width=abs(dx-sx)
     

      ;xcenter=sx+(dx-sx)/2.0
      ;ycenter=sy+(dy-sy)/2.0

      ;tvboxbk, width, xcenter,ycenter, $
      ;               linestyle=0, /device, color='0000FF'XL, thick=2.0    ;RED

     ;PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
     ;    Color=state.boxColor, thick=1.5


      if (sy lt dy) then begin
       PlotS, [sx, sx, dx, dx, sx], [sy, sy+width, sy+width, sy, sy], /Device, $
         color='0000FF'XL, thick=2.0    ;RED
      endif else begin 
       PlotS, [sx, sx, dx, dx, sx], [sy, sy-width, sy-width, sy, sy], /Device, $
         color='0000FF'XL, thick=2.0    ;RED
      endelse


      loadct, state.colortable, /silent

      endif

  END

ELSE:

ENDCASE

endif



        
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------

       widget_control, state.plotwindowone, get_value=index
       wset, index

       xdevice=event.x
       ydevice=event.y

       ramin=state.ramin
       ramax=state.ramax
       decmin=state.decmin
       decmax=state.decmax

       widget_control, state.gotochannel, get_value=channelstring
         channel=long(channelstring[0]) 

       hor, ramax, ramin
       ver, decmin, decmax

       result=convert_coord(xdevice, ydevice, /device, /double, /to_data)

       xdata=result[0]
       ydata=result[1]

       if (xdata lt ramin OR xdata gt ramax OR ydata lt decmin OR ydata gt decmax) then begin
           widget_control, state.xval, set_value='----'
           widget_control, state.yval, set_value='----'
           widget_control, state.xpix, set_value='----'
           widget_control, state.ypix, set_value='----'
           widget_control, state.intensitylevel, set_value='----'

        endif else begin
           radecconvert, xdata, ydata, rastring, decstring
           widget_control, state.xval, set_value='  '+rastring[0]
           widget_control, state.yval, set_value=decstring[0]

                                ;Update window for optical image
                                ;display if there is a mouse click

           xpos=round(event.x-state.px[0]-1) 
           ypos=round(event.y-state.py[0]-1)
           
          
           xcube=-round((float(state.xcubemax-state.xcubemin+1)/state.sx)*xpos)+(state.xcubemax)
           ycube=round((float(state.ycubemax-state.ycubemin+1)/state.sy)*ypos)+(state.ycubemin)

           if (xcube lt 0) then xcube=0
           if (ycube lt 0) then ycube=0
           if (xcube gt n_elements(state.data.d[0,0,*,0])-1) then xcube=n_elements(state.data.d[0,0,*,0])-1
           if (ycube gt n_elements(state.data.d[0,0,0,*])-1) then ycube=n_elements(state.data.d[0,0,0,*])-1

            widget_control, state.xpix, set_value=strcompress(xcube, /remove_all)
            widget_control, state.ypix, set_value=strcompress(ycube, /remove_all)

         if (state.mapcurrent eq 'spectral') then begin

            if (state.currentpol eq 0 OR state.currentpol eq 1) then $
                 intensityvalue=state.data.d[channel,state.currentpol,xcube,ycube]
            if (state.currentpol eq 2) then $
                 intensityvalue=(state.data.d[channel,0,xcube,ycube]+state.data.d[channel,1,xcube,ycube])/2.0

            widget_control, state.intensitylevel, set_value=strcompress(intensityvalue, /remove_all)

         endif

          if (state.mapcurrent eq 'continuum') then begin

             if (state.currentpol eq 0 OR state.currentpol eq 1) then $
                 intensityvalue=state.data.cont[state.currentpol,xcube,ycube]
             if (state.currentpol eq 2) then $
                 intensityvalue=(state.data.cont[0,xcube,ycube]+state.data.cont[1,xcube,ycube])/2.0

             widget_control, state.intensitylevel, set_value=strcompress(intensityvalue, /remove_all)

         endif
        
         ;If AGC catalog is turned on, check mouse coordinates
         
         agcindex=where(state.currentagc[1,*] lt event.x+5 AND $
                        state.currentagc[1,*] gt event.x-5 AND $
                        state.currentagc[2,*] lt event.y+5 AND $
                        state.currentagc[2,*] gt event.y-5)

         if (agcindex[0] ne -1) then begin
               agcnum=state.currentagc[0,agcindex]
               agcnum=agcnum[0]
               catindex=where(state.agc.agcnumber eq agcnum)
               stringout='A'+strcompress(state.agc.agcnumber[catindex], /remove_all)+',Type='+ $
                         strcompress(state.agc.DESCRIPTION[catindex], /remove_all)+',Vopt='+ $
                         strcompress(state.agc.Vopt[catindex], /remove_all)+',V21='+ $
                         strcompress(state.agc.V21[catindex], /remove_all)+',detcode='+ $
                         strcompress(state.agc.detcode[catindex], /remove_all)
               widget_control, state.agcinfo, set_value=stringout[0]
           endif else begin 
               widget_control, state.agcinfo, set_value='--------------' 
           endelse 
             

           ;IF N key is hit, query NED and bring up text box

          if (event.type eq 5 AND (StrTrim(event.ch,2) eq 'n' OR StrTrim(event.ch,2) eq 'N') AND state.keystatus eq 0) then begin

              gridview_nedgui, xdata,ydata

              state.keystatus=1
               

           endif


           case event.type of 

           0: begin   ;Mouse goes down

           if (event.press eq 4) then begin    ;Right mouse button click
               ;print, 'EVENT.PRESS DSS ',event.press


               case state.mapcurrent of 

               'spectral': begin
               
               if (state.getspectrumstatus eq 0) then begin
               widget_control, state.baseID, hourglass=1

               
        
               widget_control, state.opticalsize, get_value=imagesizestring
               imagesize=float(imagesizestring[0])
               
               xsizepixel=state.sx
               ysizepixel=state.sy

               xsizearcmin=15.0*(ramax-ramin)*60.0
               ysizearcmin=(decmax-decmin)*60.0

               pixscalex=xsizepixel/xsizearcmin
               pixscaley=ysizepixel/ysizearcmin

               device, decomposed=1
               tvboxbk, imagesize*pixscalex, event.x,event.y, $
                     linestyle=0, /device, color='0000FF'XL ;RED
              
               
                         
               queryDSS, [xdata*15.0,ydata], image, header, imsize=imagesize, survey='2b'
               state.dssimage=congrid(image, 225,225)

               url='http://casjobs.sdss.org/ImgCutoutDR4/getjpeg.aspx?ra='+$
                    strcompress(xdata*15.0, /remove_all)+$
                    '&dec='+strcompress(ydata, /remove_all)+$
                    '&scale='+strcompress(imagesize/6.67,/remove_all)+$
                    '&opt=GI&width=400&height=400'

               filename='~/12junksdss.jpg'

               spawn, 'wget -q -O '+ filename + " '" + url + "'"

               read_jpeg, filename, image, true=1

               state.sloanimage=congrid(image, 3,225,225)

               spawn, '/bin/rm -r ~/12junksdss.jpg'

gridview_cutout_display



               widget_control, state.baseID, hourglass=0
        

       
               endif

           end

           'continuum': begin

               
               widget_control, state.baseID, hourglass=1

               widget_control, state.opticalsize, get_value=imagesizestring
               imagesize=float(imagesizestring[0])

               xsizepixel=state.sx
               ysizepixel=state.sy

               xsizearcmin=15.0*(ramax-ramin)*60.0
               ysizearcmin=(decmax-decmin)*60.0

               pixscalex=xsizepixel/xsizearcmin
               pixscaley=ysizepixel/ysizearcmin

               device, decomposed=1
               tvboxbk, imagesize*pixscalex, event.x,event.y, $
                     linestyle=0, /device, color='0000FF'XL ;RED

               url='http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD='+strcompress(xdata*15.0, /remove_all)+$
               ','+strcompress(ydata, /remove_all)+'&SURVEY=VLA+NVSS+(1.4+Ghz)&SFACTR='+$
                   strcompress(imagesize/60.0, /remove_all)+$
                   '&PIXELX=400&PIXELY=400&COLTAB=Rainbow&RETURN=GIF'

               spawn, 'wget -q -O ~/temp1357_IDL.gif ' + "'" + url + "'"
               read_gif, '~/temp1357_IDL.gif', image, r,g,b

               spawn, '/bin/rm -r ~/temp1357_IDL.gif'
            
               widget_control, state.plotwindowimage, get_value=index
               wset, index
               device, decomposed=0
               loadct, 13, /silent
               tvscl, congrid(image, 225,225)

               widget_control, state.baseID, hourglass=0

           end 

           else:

       endcase



   endif



       end

       else:

   endcase


          

       endelse

       ;Update window for optical/nvss image display

       
   
       ;if (state.getspectrumstatus eq 1 and state.mapcurrent eq 'spectral') then begin

       ;    if (xdata gt ramin AND xdata lt ramax AND ydata gt decmin AND ydata lt decmax) then begin

       ;        xsizepixel=state.sx
       ;        ysizepixel=state.sy

       ;        xsizearcmin=15.0*(ramax-ramin)*60.0
       ;        ysizearcmin=(decmax-decmin)*60.0

       ;        pixscalex=xsizepixel/xsizearcmin
       ;        pixscaley=ysizepixel/ysizearcmin

       ;        widget_control, state.apertureFWHM, get_value=aperturestring

        ;       radiuspixel=double(aperturestring[0])*pixscalex/2.0

         ;      gridview_display, channel

        ;       red='0000FF'XL

     ;          device, decomposed=1
     ;          tvboxbk, 31, event.x,event.y, /device, color=red
     ;          tvcircle, radiuspixel, event.x, event.y, /device, color=red
     ;          device, decomposed=0

     ;      endif else begin
     ;          gridview_display, channel
     ;          gridview_display_weights, channel
     ;      endelse


     ; endif


      


   end


   'plotwindowcolorbar': begin

       case event.type of
           0: begin    ;Mouse button press

               state.mousestatus = 1 ;Mouse button is down
               state.colorbar_y=event.y

             end

           1: begin    ;Mouse button release

                state.mousestatus = 0   ;Mouse button is up
                state.colorbar_y=0   ;Reset value
             end

           2: begin           ; Button press
               
               if (state.mousestatus eq 1) then begin

                   y_diff_percent=abs(event.y-state.colorbar_y)/float(state.sy)

               if (event.y lt state.colorbar_y) then $
                 state.stretchupper=state.stretchupper-(y_diff_percent*255)
               if (event.y gt state.colorbar_y) then $
                 state.stretchupper=state.stretchupper+(y_diff_percent*255)

               widget_control, state.gotochannel, get_value=channelstring
               channel=long(channelstring[0])

               gridview_refresh, channel
               
                 state.colorbar_y=event.y

                 endif

             end

        else:

         endcase


    end

'copyright': begin
 
               if (event.press gt 0) then gridview_utility
 
             end


'plotwindowspectrum': begin

;For this window deal only with up, down, and mouse movement for box control

if (event.type le 2) then begin

eventTypes = ['DOWN', 'UP', 'MOTION']
thisEvent = eventTypes[event.type]
state.xsize=420
state.ysize=210

widget_control, state.gotochannel, get_value=channelstring
               channel=long(channelstring[0])

CASE thisEvent OF

   'DOWN': BEGIN
       ; Turn motion events on for the draw widget.

      Widget_Control, state.plotwindowspectrum, Draw_Motion_Events=1
      widget_control, state.plotwindowspectrum, get_value=index
      state.wid=index
      state.drawID=state.plotwindowspectrum

         ; Create a pixmap. Store its ID. Copy window contents into it.

      Window, /Free, /Pixmap, XSize=state.xsize, YSize=state.ysize
      state.pixID = !D.Window
      Device, Copy=[0, 0, state.xsize, state.ysize, 0, 0, state.wid]

         ; Get and store the static corner of the box.

      state.zoomsx = event.x
      state.zoomsy = event.y

      gridview_plotspectrum


     END


   'UP': BEGIN
       
         ; Erase the last box drawn. Destroy the pixmap.

      widget_control, state.plotwindowspectrum, get_value=index
      state.wid=index
      state.drawID=state.plotwindowspectrum

      WSet, state.wid
      Device, Copy=[0, 0, state.xsize, state.ysize, 0, 0, state.pixID]
     
         ; Order the box coordinates.

      sx = Min([state.zoomsx, event.x], Max=dx)
      sy = Min([state.zoomsy, event.y], Max=dy)

        ;New min and max for zooming
   
      ;print, sx,sy,dx,dy
      

spectrum=state.spectrum
spectrumweights=state.spectrumweights

;Plot velocity on x-axis
if (state.spectrumaxisstatus eq 0) then begin

;Redundant, but just for consistency
widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, state.data.velarr[state.spectrum_xmax], state.data.velarr[state.spectrum_xmin]
ver, state.spectrum_ymin, state.spectrum_ymax

      resultcoords_min=convert_coord(sx, sy, /device, /double, /to_data)
      resultcoords_max=convert_coord(dx, dy, /device, /double, /to_data)

      startvel=round(resultcoords_min[0])
      stopvel=round(resultcoords_max[0])
      minflux=round(resultcoords_min[1])
      maxflux=round(resultcoords_max[1])

;print, startvel, stopvel


chanmin_array=where(state.data.velarr ge stopvel)
startchannel=chanmin_array[n_elements(chanmin_array)-1]
chanmax_array=where(state.data.velarr le startvel)
stopchannel=chanmax_array[0]

;Situation where user clicks to zoom out
if (sx eq dx OR sy eq dy) then begin
startchannel=0
stopchannel=n_elements(state.data.velarr)-1
minflux=min(spectrum)
maxflux=max(spectrum)
endif


hor, state.data.velarr[stopchannel], state.data.velarr[startchannel]
ver, minflux,maxflux

device, decomposed=1
color='0000FF'XL   ;RED
plot,state.data.velarr[startchannel:stopchannel],spectrum[startchannel:stopchannel],$
      xstyle=1, ystyle=1, xtitle='Velocity [km/s]', $
      charsize=0.7, ytitle='Flux Density [mJy/beam]', /nodata
oplot,state.data.velarr[startchannel:stopchannel], spectrum[startchannel:stopchannel], color=color


flag, state.data.velarr[channel], color='00FF00'XL  ; GREEN current channel (velocity)

;Repeat for spectral weights

widget_control, state.plotwindowspectrumweights, get_value=index
wset, index

hor, state.data.velarr[stopchannel], state.data.velarr[startchannel]
ver, 0.0,1.1

color='0000FF'XL   ;RED
plot,state.data.velarr[startchannel:stopchannel],spectrumweights[startchannel:stopchannel]/state.maxweight,$
           xstyle=1, ystyle=1, xtitle='Velocity [km/s]', $
           charsize=0.7, ytitle='Weight', /nodata
oplot,state.data.velarr[startchannel:stopchannel], spectrumweights[startchannel:stopchannel]/state.maxweight, color=color

flag, state.data.velarr[channel], color='00FF00'XL  ; GREEN current channel (velocity)

device, decomposed=0

endif else begin   ;Plot channel on x-axis

widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, state.spectrum_xmin, state.spectrum_xmax
ver, state.spectrum_ymin, state.spectrum_ymax

      resultcoords_min=convert_coord(sx, sy, /device, /double, /to_data)
      resultcoords_max=convert_coord(dx, dy, /device, /double, /to_data)

      startchannel=round(resultcoords_min[0])
      stopchannel=round(resultcoords_max[0])
      minflux=round(resultcoords_min[1])
      maxflux=round(resultcoords_max[1])

hor, startchannel, stopchannel
ver, minflux,maxflux

device, decomposed=1
color='0000FF'XL   ;RED
plot,spectrum,xstyle=1, ystyle=1, xtitle='Channel', $
     charsize=0.7, ytitle='Flux Density [mJy/beam]', /nodata
oplot, spectrum, color=color

flag, channel, color='00FF00'XL  ; GREEN centroid for redshift

;Repeat for spectral weights

widget_control, state.plotwindowspectrumweights, get_value=index
wset, index

hor, startchannel, stopchannel
ver, 0.0,1.1

color='0000FF'XL   ;RED
plot,spectrumweights/state.maxweight,xstyle=1, ystyle=1, $
    xtitle='Channel', charsize=0.7, ytitle='Weight', /nodata
oplot, spectrumweights/state.maxweight, color=color
flag, channel, color='00FF00'XL  ; GREEN centroid for redshift

device, decomposed=0

endelse

;Store away for any changes
state.spectrum=spectrum
state.spectrumweights=spectrumweights
state.spectrum_xmin=startchannel
state.spectrum_xmax=stopchannel
state.spectrum_ymin=minflux
state.spectrum_ymax=maxflux

WDelete, state.pixID

  ; Turn draw motion events off. Clear any events queued for widget.

    Widget_Control, state.drawID, Draw_Motion_Events=0, Clear_Events=1

   gridview_display, channel
   gridview_display_weights, channel

    END

   'MOTION': BEGIN

         ; Here is where the actual box is drawn and erased.
         ; First, erase the last box.

      widget_control, state.plotwindowspectrum, get_value=index
      state.wid=index
      state.drawID=state.plotwindowspectrum

      WSet, state.wid
      Device, Copy=[0, 0, state.xsize, state.ysize, 0, 0, state.pixID]

         ; Get the coodinates of the new box and draw it.

      sx = state.zoomsx
      sy = state.zoomsy
      dx = event.x
      dy = event.y
      loadct, 1, /silent
      state.boxcolor=!D.N_Colors-1
      PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
         Color=state.boxColor
      loadct, state.colortable, /silent

  END

  ELSE:

ENDCASE

endif

end

else:

endcase


case event.type of

1: begin

   if (state.getspectrumstatus eq 1) then $
         gridview_fetch_spectrum, $
           round(event.x-state.px[0]-1), round(event.y-state.py[0]-1)
   end

   else:

endcase



end





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EVENT HANDLER FOR GENERAL BUTTON EVENTS
pro gridview_event, event

common gridview_state

widget_control, event.id, get_uvalue=uvalue



case uvalue of

'velslider': begin

    widget_control, event.id, get_value=channel
    
    

    widget_control, state.zval, set_value=strcompress(state.data.velarr[channel])
    widget_control, state.gotochannel, set_value=strcompress(channel, /remove_all)

    ;gridview_update_spectrum_box

    gridview_refresh, channel   ; 1 means mouse drag
    gridview_refresh_weights, channel
    ;if (event.drag eq 0) then gridview_display, channel ; 0 means end of drag
    

end

'gotochannel': begin

widget_control, event.id, get_value=channelstring

channel=long(channelstring)
channel=channel[0]

if (channel gt n_elements(state.data.velarr)-1) then $
                channel=n_elements(state.data.velarr)-1
if (channel lt 0) then channel=0

widget_control, state.zval, set_value=strcompress(state.data.velarr[channel])

widget_control, state.velslider, set_value=channel
widget_control, state.gotochannel, set_value=strcompress(channel, /remove_all)

gridview_display, channel
gridview_display_weights, channel

end


'nextchannel': begin

widget_control, state.velslider, get_value=channel

if (channel eq n_elements(state.data.velarr)-1) then channel=n_elements(state.data.velarr)-2



widget_control, state.zval, set_value=strcompress(state.data.velarr[channel+1])
widget_control, state.gotochannel, set_value=strcompress(channel+1, /remove_all)
widget_control, state.velslider, set_value=channel+1



gridview_refresh, channel+1
gridview_refresh_weights, channel+1

end


'previouschannel': begin

widget_control, state.velslider, get_value=channel

if (channel eq 0) then channel=1

widget_control, state.zval, set_value=strcompress(state.data.velarr[channel-1])
widget_control, state.gotochannel, set_value=strcompress(channel-1, /remove_all)
widget_control, state.velslider, set_value=channel-1



gridview_refresh, channel-1
gridview_refresh_weights, channel-1

end

'pola': begin

    state.currentpol=0
    state.colortable=state.polAcolor
    widget_control, state.velslider, get_value=channel
    gridview_display, channel
    gridview_display_weights, channel

end

'polb': begin

    state.currentpol=1
    state.colortable=state.polBcolor
    widget_control, state.velslider, get_value=channel
    gridview_display, channel
    gridview_display_weights, channel

end

'avgpol': begin

    state.currentpol=2
    state.colortable=state.avgpolcolor
    widget_control, state.velslider, get_value=channel
    gridview_display, channel
    gridview_display_weights, channel

end


'velintegselect': begin

    if (state.velintegselectstatus eq 0) then begin 
          state.velintegselectstatus=1
    endif else begin
          state.velintegselectstatus=0
    endelse

   
end

'multiagc': begin

if (state.multiagcstatus eq 0) then begin
        state.multiagcstatus=1
    endif else begin
        state.multiagcstatus=0
endelse

widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

   gridview_display, channel
   gridview_display_weights, channel


end




'agcoverlay': begin

   if (state.agcoverlaystatus eq 0) then begin
        state.agcoverlaystatus=1
    endif else begin
        state.agcoverlaystatus=0
    endelse

   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

   gridview_display, channel
   gridview_display_weights, channel

end

'agcoverlay_nocz': begin

   if (state.agcoverlaystatus_nocz eq 0) then begin
        state.agcoverlaystatus_nocz=1
    endif else begin
        state.agcoverlaystatus_nocz=0
    endelse

   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

   gridview_display, channel
   gridview_display_weights, channel

end

'catalog3D': begin

if (state.overlaystatus3D eq 0) then begin

    if (state.extracats eq 1) then begin
        state.overlaystatus3D=1
    endif else begin
         ;cat3D=dialog_pickfile(/read) 
        
         ;restore, '/home/dorado3/galaxy/idl_alfa/catalog_template.sav' 
         ;table3D=read_ascii(cat3D, template=catalog_template)
         ;convert3Dcat, catin, table3D
         ;state.table3D=table3D
         ;state.extracats=1
         ;state.overlaystatus3D=1

        status=dialog_message('You need to pass a file name as a keyword upon startup.')


    endelse



    endif else begin
        state.overlaystatus3D=0
    endelse

   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

   gridview_display, channel
   gridview_display_weights, channel


end




'nvssoverlay': begin

    if (state.nvssoverlaystatus eq 0) then begin
        state.nvssoverlaystatus=1
    endif else begin
        state.nvssoverlaystatus=0
    endelse

   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

   gridview_display, channel
   gridview_display_weights, channel


end


'getspectrum': begin

  if (state.mapcurrent eq 'spectral') then begin

   if (state.getspectrumstatus eq 0) then begin
        state.getspectrumstatus=1
    endif else begin
        state.getspectrumstatus=0
   endelse

   endif

end


'axisvelocity': begin

state.spectrumaxisstatus=0

if (state.spectrumon eq 1) then gridview_plotspectrum

end


'axischannel': begin

state.spectrumaxisstatus=1

if (state.spectrumon eq 1) then gridview_plotspectrum

end


'spectral': begin
   state.mapcurrent='spectral'
   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

   gridview_display, channel
   gridview_display_weights, channel


    widget_control, state.opticalsize, set_value='10'
    widget_control, state.imagelabel, set_value=[' DSS Image Display', 'SDSS Image Display']
    state.currentimage=0

end

'continuum': begin

   state.mapcurrent='continuum'
   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]
   
   gridview_display, channel
   gridview_display_weights, channel

    widget_control, state.opticalsize, set_value='20' 
    widget_control, state.imagelabel, set_value='NVSS Image Display'

end

'linearscaling': begin

state.currentscaling='linearscaling'

   widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]
   
   gridview_display, channel
   gridview_display_weights, channel

end

'logscaling': begin

state.currentscaling='logscaling'

widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]
   
   gridview_display, channel
   gridview_display_weights, channel

end


'histeqscaling': begin

state.currentscaling='histeqscaling'

widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]
   
   gridview_display, channel
   gridview_display_weights, channel


end

'smoothslider': begin

widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]

gridview_refresh, channel
gridview_refresh_weights, channel


end


'colorbar_autoscale': begin

state.colorbarscaling='colorbar_autoscale'

widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]
   
   gridview_display, channel
   gridview_display_weights, channel

end


'colorbar_constantscale': begin

state.colorbarscaling='colorbar_constantscale'

widget_control, state.gotochannel, get_value=channelstring

   channel=long(channelstring)
   channel=channel[0]
   
   gridview_display, channel
   gridview_display_weights, channel

end


'imageoption': begin

state.currentimage=event.index



gridview_cutout_display

end



else:

endcase

end


;-------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;WINDOW display procedure - resets entire window

pro gridview_display, channel

common gridview_state

widget_control, state.plotwindowone, get_value=index
wset, index


device, decomposed=0
loadct, state.colortable, /silent
stretch, state.stretchlower,state.stretchupper

ramin=state.ramin
ramax=state.ramax
decmin=state.decmin
decmax=state.decmax

hor, ramin, ramax
ver, decmin, decmax

posarray=[0.15,0.15,0.95,0.95]
xstyle=1
ystyle=1

color='00FFFF'XL
charsize=1.0
xtitle='RA [HMS] J2000'
ytitle='Dec [DMS] J2000'
ticklen=-0.01
if (state.currentpol eq 0) then poltitle='Pol A'
if (state.currentpol eq 1) then poltitle='Pol B'
if (state.currentpol eq 2) then poltitle='Avg Pol'

device, decomposed=1 
plot, [0,0], /nodata, xstyle=xstyle, ystyle=ystyle, position=posarray, $
             color=color, charsize=charsize, xtitle=xtitle, ytitle=ytitle, $
             xtick_get=xvals, ytick_get=yvals, ticklen=ticklen

device, decomposed=0

nxticklabels=n_elements(xvals)
nyticklabels=n_elements(yvals)

xvals=float(xvals)
yvals=yvals

xspacing=((xvals[n_elements(xvals)-1]-xvals[0])*60.0)/(nxticklabels-1)
yspacing=((yvals[n_elements(yvals)-1]-yvals[0])*60.0)/(nyticklabels-1)

ticlabels, xvals[0]*15.0, nxticklabels, xspacing, xticlabs,/ra,delta=1
ticlabels, yvals[0], nyticklabels, yspacing, yticlabs, delta=1

state.PX = !X.WINDOW * !D.X_VSIZE 
state.PY = !Y.WINDOW * !D.Y_VSIZE 
state.SX = state.PX[1] - state.PX[0] + 1 
state.SY = state.PY[1] - state.PY[0] + 1

erase

hor, ramax, ramin
ver, decmin, decmax
map=dblarr(state.sx, state.sy)


case state.mapcurrent of

'spectral': begin

if (state.velintegselectstatus eq 1) then begin
    widget_control, state.velintegtext, get_value=step
    step=long(step[0])
    lowerchan=channel-step
    upperchan=channel+step
    if (lowerchan lt 0) then lowerchan=0
    if (upperchan gt n_elements(state.data.velarr)-1) then upperchan=n_elements(state.data.velarr)-1
    if (state.currentpol eq 0 OR state.currentpol eq 1) then begin

       map=total(state.data.d[lowerchan:upperchan,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step))
               
    endif else begin
       
        map=reform(total(state.data.d[lowerchan:upperchan,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step)))
        map=total(map,1)/2.
       

    endelse

      infostring='Channels '+strcompress(lowerchan, /remove_all)+' to '+strcompress(upperchan, /remove_all)+ $
             '  Integrated Velocity= '+strcompress(state.data.velarr[lowerchan], /remove_all)+$
             ' to '+strcompress(state.data.velarr[upperchan], /remove_all)+' km/s   '+poltitle
       
 
endif else begin  

        if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.d[channel,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.d[channel,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
          
        endelse

infostring='Channel '+strcompress(channel)+ $
             '    Velocity= '+strcompress(state.data.velarr[channel])+' km/s   '+poltitle

endelse


end

'continuum': begin

if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.cont[state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.cont[*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
          
        endelse

infostring='Continuum    '+poltitle

end


else:

endcase


gridview_displaymap, reverse(congrid(reform(map), state.sx, state.sy))


device, decomposed=1
plot, [0,0], /nodata, xstyle=1, ystyle=1, /noerase, position=posarray, $ 
             xtickn=reverse(xticlabs), ytickn=yticlabs, $
             color=color, charsize=charsize, xtitle=xtitle, ytitle=ytitle, ticklen=ticklen
             



mask=fltarr(600,25)
tvscl, mask, 10,5

xyouts, 10, 10, infostring, /device, color=color, charsize=1.1

device, decomposed=0




gridview_loadColorBar

wset, index

gridview_agcdisplay
gridview_nvss

end



;----------------------------------------------------------------------------
;Resets weights window

pro gridview_display_weights, channel

common gridview_state

widget_control, state.plotwindowtwo, get_value=index
wset, index

device, decomposed=0
loadct, state.colortable, /silent
stretch, state.stretchlower,state.stretchupper

ramin=state.ramin
ramax=state.ramax
decmin=state.decmin
decmax=state.decmax

hor, ramin, ramax
ver, decmin, decmax

posarray=[0.15,0.15,0.95,0.95]
xstyle=1
ystyle=1


color='00FFFF'XL
charsize=1.0
xtitle='RA [HMS] J2000'
ytitle='Dec [DMS] J2000'
ticklen=-0.01
if (state.currentpol eq 0) then poltitle='Pol A'
if (state.currentpol eq 1) then poltitle='Pol B'
if (state.currentpol eq 2) then poltitle='Avg Pol'

device, decomposed=1 
plot, [0,0], /nodata, xstyle=xstyle, ystyle=ystyle, position=posarray, $
             color=color, charsize=charsize, xtitle=xtitle, ytitle=ytitle, $
             xtick_get=xvals, ytick_get=yvals, ticklen=ticklen



device, decomposed=0

nxticklabels=n_elements(xvals)
nyticklabels=n_elements(yvals)



xvals=float(xvals)
yvals=yvals

xspacing=((xvals[n_elements(xvals)-1]-xvals[0])*60.0)/(nxticklabels-1)
yspacing=((yvals[n_elements(yvals)-1]-yvals[0])*60.0)/(nyticklabels-1)

ticlabels, xvals[0]*15.0, nxticklabels, xspacing, xticlabs,/ra,delta=1
ticlabels, yvals[0], nyticklabels, yspacing, yticlabs, delta=1

state.PX = !X.WINDOW * !D.X_VSIZE 
state.PY = !Y.WINDOW * !D.Y_VSIZE 
state.SX = state.PX[1] - state.PX[0] + 1 
state.SY = state.PY[1] - state.PY[0] + 1

erase

hor, ramax, ramin
ver, decmin, decmax


case state.mapcurrent of

'spectral':  begin

if (state.velintegselectstatus eq 1) then begin
    widget_control, state.velintegtext, get_value=step
    step=long(step[0])
    lowerchan=channel-step
    upperchan=channel+step
    if (lowerchan lt 0) then lowerchan=0
    if (upperchan gt n_elements(state.data.velarr)-1) then upperchan=n_elements(state.data.velarr)-1
    if (state.currentpol eq 0 OR state.currentpol eq 1) then begin

       map=total(state.data.w[lowerchan:upperchan,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step))
               
    endif else begin
       
        map=reform(total(state.data.w[lowerchan:upperchan,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step)))
        map=total(map,1)/2.
       

    endelse

      
      
       
 
endif else begin  

        if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.w[channel,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.w[channel,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
         
        endelse


    endelse

   infostring='Spectral weights display'

end

'continuum':  begin

if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.cw[state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.cw[*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
          
        endelse

   infostring='Continuum weights display'


end 

else:

endcase

;Next line removed to keep linear scaling for weights
;gridview_displaymap, reverse(congrid(reform(map), state.sx, state.sy))

widget_control, state.smoothslider, get_value=smoothval
smoothval=smoothval[0]
tvscl, smooth(reverse(congrid(reform(map), state.sx, state.sy)),$
         smoothval, /edge_truncate), state.px[0], state.py[0]

device, decomposed=1
plot, [0,0], /nodata, xstyle=1, ystyle=1, /noerase, position=posarray, $ 
             xtickn=reverse(xticlabs), ytickn=yticlabs, $
             color=color, charsize=charsize, xtitle=xtitle, ytitle=ytitle, ticklen=ticklen
            

 xyouts, 225,15, infostring, /device, color=color, charsize=1.3

end



;---------------------------------------------------------------------------
;Refresh only the images - faster and less flickering

pro gridview_refresh, channel

common gridview_state

widget_control, state.plotwindowone, get_value=index
wset, index

device, decomposed=0
loadct, state.colortable, /silent
stretch, state.stretchlower,state.stretchupper

if (state.currentpol eq 0) then poltitle='Pol A'
if (state.currentpol eq 1) then poltitle='Pol B'
if (state.currentpol eq 2) then poltitle='Avg Pol'


case state.mapcurrent of

'spectral': begin

if (state.velintegselectstatus eq 1) then begin
    widget_control, state.velintegtext, get_value=step
    step=long(step[0])
    lowerchan=channel-step
    upperchan=channel+step
    if (lowerchan lt 0) then lowerchan=0
    if (upperchan gt n_elements(state.data.velarr)-1) then upperchan=n_elements(state.data.velarr)-1
    if (state.currentpol eq 0 OR state.currentpol eq 1) then begin

       map=total(state.data.d[lowerchan:upperchan,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step))
               
    endif else begin
       
        map=reform(total(state.data.d[lowerchan:upperchan,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step)))
        map=total(map,1)/2.
       

    endelse

      
        infostring='Channels '+strcompress(lowerchan, /remove_all)+' to '+strcompress(upperchan, /remove_all)+ $
             '  Integrated Velocity= '+strcompress(state.data.velarr[lowerchan], /remove_all)+$
             ' to '+strcompress(state.data.velarr[upperchan], /remove_all)+' km/s   '+poltitle
       
 
endif else begin  

        if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.d[channel,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.d[channel,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
        endelse

infostring='Channel '+strcompress(channel)+ $
             '    Velocity= '+strcompress(state.data.velarr[channel])+' km/s   '+poltitle

endelse

end

'continuum': begin

if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.cont[state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.cont[*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
          
        endelse

infostring='Continuum    '+poltitle

end

else:

endcase



gridview_displaymap, reverse(congrid(reform(map), state.sx, state.sy))


color='00FFFF'XL    ;YELLOW

device, decomposed=1
plots, findgen(long(state.sx))+state.px[0], $
       fltarr(long(state.sx))+state.px[0], color=color, /device
plots, fltarr(long(state.sx))+state.px[0],  $
       findgen(long(state.sx))+state.px[0], color=color, /device

plots, findgen(long(state.sx))+state.px[0], $
       fltarr(long(state.sx))+state.px[0]+state.sx-1, color=color, /device
plots, fltarr(long(state.sx))+state.px[0]+state.sx-1, $
       findgen(long(state.sx))+state.px[0], color=color, /device

mask=fltarr(600,25)
tvscl, mask, 10,5

xyouts, 10, 10, infostring, /device, color=color, charsize=1.1

device, decomposed=0

gridview_loadColorBar

wset, index

gridview_agcdisplay
gridview_nvss

end


;---------------------------------------------------------------------------
;Refresh only the images - faster and less flickering

pro gridview_refresh_weights, channel

common gridview_state

widget_control, state.plotwindowtwo, get_value=index
wset, index

device, decomposed=0
loadct, state.colortable, /silent
stretch, state.stretchlower,state.stretchupper


if (state.currentpol eq 0) then poltitle='Pol A'
if (state.currentpol eq 1) then poltitle='Pol B'
if (state.currentpol eq 2) then poltitle='Avg Pol'


case state.mapcurrent of

'spectral': begin

if (state.velintegselectstatus eq 1) then begin
    widget_control, state.velintegtext, get_value=step
    step=long(step[0])
    lowerchan=channel-step
    upperchan=channel+step
    if (lowerchan lt 0) then lowerchan=0
    if (upperchan gt n_elements(state.data.velarr)-1) then upperchan=n_elements(state.data.velarr)-1
    if (state.currentpol eq 0 OR state.currentpol eq 1) then begin

       map=total(state.data.w[lowerchan:upperchan,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step))
               
    endif else begin
       
        map=reform(total(state.data.w[lowerchan:upperchan,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step)))
        map=total(map,1)/2.

    endelse

endif else begin  

        if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.w[channel,state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.w[channel,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
        
        endelse

    endelse

end

'continuum':  begin

if (state.currentpol eq 0 OR state.currentpol eq 1) then begin
          map=reform(state.data.cw[state.currentpol,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
        endif else begin
          map=reform(state.data.cw[*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
          map=total(map,1)/2.
          
        endelse

end

else:
 
endcase


;gridview_displaymap, reverse(congrid(reform(map), state.sx, state.sy))
widget_control, state.smoothslider, get_value=smoothval
smoothval=smoothval[0]
tvscl, smooth(reverse(congrid(reform(map), state.sx, state.sy)),smoothval, /edge_truncate), state.px[0], state.py[0]

color='00FFFF'XL  ;YELLOW

device, decomposed=1
plots, findgen(long(state.sx))+state.px[0], fltarr(long(state.sx))+state.px[0], color=color, /device
plots, fltarr(long(state.sx))+state.px[0], findgen(long(state.sx))+state.px[0], color=color, /device

plots, findgen(long(state.sx))+state.px[0], fltarr(long(state.sx))+state.px[0]+state.sx-1, color=color, /device
plots, fltarr(long(state.sx))+state.px[0]+state.sx-1, findgen(long(state.sx))+state.px[0], color=color, /device

device, decomposed=0

end

;-----------------------------------------------------------------------
;Procedure that is passed map, and map (spectral, continuum or
;weights) is shown, with appropriate scaling applied

pro gridview_displaymap, map

common gridview_state

;Fetch the smoothing state
widget_control, state.smoothslider, get_value=smoothval
smoothval=smoothval[0]


case state.currentscaling of

   'linearscaling': begin

     if (state.colorbarscaling eq 'colorbar_autoscale') then begin
        tvscl, smooth(map,smoothval, /edge_truncate), state.px[0], state.py[0]
     endif else begin
        tv, bytscl(smooth(map,smoothval,/edge_truncate),min=state.colorbarmin,max=state.colorbarmax),$
             state.px[0], state.py[0]   
      endelse

     state.minval=min(map)
     state.maxval=max(map)

    end

    'logscaling': begin
       offset=min(map)-(max(map)-min(map))*0.01
       tvscl, smooth(alog10(map-offset), smoothval, /edge_truncate), state.px[0], state.py[0] 
       state.minval=alog10(min(map)-offset)
       state.maxval=alog10(max(map)-offset)

    end

    'histeqscaling':begin

        tvscl, smooth(hist_equal(map, minv=min(map), maxv=max(map)), smoothval, /edge_truncate), state.px[0], state.py[0] 
        state.minval=min(map)
        state.maxval=max(map)

    end

else:

endcase

end




;-------------------------------------------------------------
;Load colorbar

pro gridview_loadColorBar

common gridview_state

widget_control, state.gotochannel, get_value=channelstring
channel=channelstring[0]

widget_control, state.plotwindowcolorbar, get_value=index
wset, index

erase

device, decomposed=0
loadct, state.colortable, /silent
stretch, state.stretchlower,state.stretchupper

yellow='00FFFF'XL


device, decomposed=1

if (state.maxval eq 0.0) then state.maxval=10.0

if (state.colorbarscaling eq 'colorbar_autoscale') then begin
Colorbar, range=[state.minval,state.maxval], vertical=1, position=[0.5,0.15,0.9,0.95], ytitle='mJy/beam', ticklen=-0.05, color=yellow
endif else begin
Colorbar, range=[state.colorbarmin,state.colorbarmax], vertical=1, $
        position=[0.5,0.15,0.9,0.95], ytitle='mJy/beam', ticklen=-0.05, color=yellow
endelse

device, decomposed=0




end


;-----------------------------------------------------
;Overlay AGC galaxies if user so chooses
pro gridview_agcdisplay

common gridview_state



ramin=state.ramin
ramax=state.ramax
decmin=state.decmin
decmax=state.decmax

widget_control, state.gotochannel, get_value=channelstring

channel=long(channelstring)
channel=channel[0] 


    lowerchan=channel-10
    upperchan=channel+10


if (lowerchan lt 0) then lowerchan=0
if (upperchan gt n_elements(state.data.velarr)-1) then upperchan=n_elements(state.data.velarr)-1


if (state.agcoverlaystatus eq 1 AND state.mapcurrent eq 'spectral') then begin

iagc=where(state.rahr lt ramax AND $
           state.rahr gt ramin AND $
           state.decdeg lt decmax AND $
           state.decdeg gt decmin AND $
           ((state.agc.v21 lt state.data.velarr[channel]+state.agc.width/2.0 AND $
             state.agc.v21 gt state.data.velarr[channel]-state.agc.width/2.0 AND $
             state.agc.v21 ne 0) OR $
            (state.agc.vopt lt state.data.velarr[lowerchan] AND $
             state.agc.vopt gt state.data.velarr[upperchan] AND $
             state.agc.vopt ne 0)))


color='00FFFF'XL    ;YELLOW squares

hor, ramax, ramin
ver, decmax, decmin

if (iagc[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.rahr[iagc], state.decdeg[iagc], /data, /double, /to_device)

plots, state.rahr[iagc], state.decdeg[iagc], psym=6,symsize=2, color=color, /data
xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $
             strcompress(state.agc.agcnumber[iagc], /remove_all), color=color, /device

for i=0,n_elements(resultcoords[0,*])-1 do state.currentagc[*,i]=[state.agc.agcnumber[iagc[i]],resultcoords[0,i], resultcoords[1,i]]

device, decomposed=0
endif else begin
   state.currentagc=lonarr(3,5000)
endelse

endif

;Plot AGC galaxies with no known redshifts in the area

if (state.agcoverlaystatus_nocz eq 1 AND state.mapcurrent eq 'spectral') then begin

iagc=where(state.rahr lt ramax AND $
           state.rahr gt ramin AND $
           state.decdeg lt decmax AND $
           state.decdeg gt decmin AND $
           state.agc.v21 eq 0 AND $
           state.agc.vopt eq 0 )



color='0000FF'XL    ;RED DIAMONDS

hor, ramax, ramin
ver, decmax, decmin

if (iagc[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.rahr[iagc], state.decdeg[iagc], /data, /double, /to_device)

plots, state.rahr[iagc], state.decdeg[iagc], psym=4,symsize=2, color=color, /data
xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $
             strcompress(state.agc.agcnumber[iagc], /remove_all), color=color, /device



device, decomposed=0
endif

endif




;-------------------------------------------------------------------

if (state.overlaystatus2D eq 1) then begin

;;;;;FOR BRIAN KENT ONLY - VIRGO SOUTH STUFF - NOT GENERALIZED!!

;Load from 2D extractions



i2D=where(state.table2D.ra lt ramax AND $
           state.table2D.ra gt ramin AND $
           state.table2D.dec lt decmax AND $
           state.table2D.dec gt decmin AND $
           state.table2D.velocity lt state.data.velarr[lowerchan] AND $
           state.table2D.velocity gt state.data.velarr[upperchan])



color='00FF00'XL    ;GREEN Triangle

hor, ramax, ramin
ver, decmax, decmin

if (i2D[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.table2D[i2D].ra, state.table2D[i2D].dec, /data, /double, /to_device)

plots, state.table2D[i2D].ra, state.table2D[i2D].dec, psym=5,symsize=2, color=color, /data
xyouts,resultcoords[0,*]-25, resultcoords[1,*]-10, $
             strcompress(state.table2D[i2D].sourcenumber, /remove_all), color=color, /device

device, decomposed=0
endif


endif




if (state.overlaystatus3D eq 1 AND state.mapcurrent eq 'spectral' AND state.extracats eq 1) then begin

;Load from 3D extractions

i3D=where(state.table3D.ra lt ramax AND $
           state.table3D.ra gt ramin AND $
           state.table3D.dec lt decmax AND $
           state.table3D.dec gt decmin AND $
           state.table3D.cz lt state.data.velarr[lowerchan] AND $
           state.table3D.cz gt state.data.velarr[upperchan])



color='0000FF'XL    ;RED Plus sign

hor, ramax, ramin
ver, decmax, decmin

if (i3D[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.table3D.ra[i3D], state.table3D.dec[i3D], /data, /double, /to_device)

plots, state.table3D.ra[i3D], state.table3D.dec[i3D], psym=1,symsize=2, color=color, thick=2.0, /data
xyouts,resultcoords[0,*]-25, resultcoords[1,*]+10, $
             strcompress(state.table3D.id[i3D], /remove_all), color=color, /device

device, decomposed=0
endif

endif

;-------------------------------------
;New multi-color agc plotting

if (state.multiagcstatus eq 1 AND state.mapcurrent eq 'spectral') then begin
symsize=1.5


;Plot All AGC galaxies in the range in red

iagc=where(state.rahr lt ramax AND $
           state.rahr gt ramin AND $
           state.decdeg lt decmax AND $
           state.decdeg gt decmin)

color='0000FF'XL    ;RED squares

hor, ramax, ramin
ver, decmax, decmin

if (iagc[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.rahr[iagc], state.decdeg[iagc], /data, /double, /to_device)

plots, state.rahr[iagc], state.decdeg[iagc], psym=6,symsize=symsize, color=color, /data
xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $
             strcompress(state.agc.agcnumber[iagc], /remove_all), color=color, /device

for i=0,n_elements(resultcoords[0,*])-1 do state.currentagc[*,i]=[state.agc.agcnumber[iagc[i]],resultcoords[0,i], resultcoords[1,i]]

device, decomposed=0
endif else begin
   state.currentagc=lonarr(3,5000)
endelse


;Plot those that have known redshift or have been searched in HI,
;yielding positive OR negative results in Cyan

iagc=where(state.rahr lt ramax AND $
           state.rahr gt ramin AND $
           state.decdeg lt decmax AND $
           state.decdeg gt decmin AND $
          (state.agc.v21 ne 0 OR state.agc.vopt ne 0))

color='FFFF00'XL    ;CYAN squares

hor, ramax, ramin
ver, decmax, decmin

if (iagc[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.rahr[iagc], state.decdeg[iagc], /data, /double, /to_device)

plots, state.rahr[iagc], state.decdeg[iagc], psym=6,symsize=symsize, color=color, /data
xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $
             strcompress(state.agc.agcnumber[iagc], /remove_all), color=color, /device
endif

;Plot those that are in the redshift range in yellow

iagc=where(state.rahr lt ramax AND $
           state.rahr gt ramin AND $
           state.decdeg lt decmax AND $
           state.decdeg gt decmin AND $
           ((state.agc.v21 lt state.data.velarr[channel]+state.agc.width/2.0 AND $
             state.agc.v21 gt state.data.velarr[channel]-state.agc.width/2.0 AND $
             state.agc.v21 ne 0) OR $
            (state.agc.vopt lt state.data.velarr[lowerchan] AND $
             state.agc.vopt gt state.data.velarr[upperchan] AND $
             state.agc.vopt ne 0)))


color='00FFFF'XL    ;YELLOW squares

hor, ramax, ramin
ver, decmax, decmin

if (iagc[0] ne -1) then begin
device, decomposed=1
resultcoords=convert_coord(state.rahr[iagc], state.decdeg[iagc], /data, /double, /to_device)

plots, state.rahr[iagc], state.decdeg[iagc], psym=6,symsize=symsize, color=color, /data
xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, $
             strcompress(state.agc.agcnumber[iagc], /remove_all), color=color, /device

endif







endif


end

;---------------------------------------------------------------------------------
;----Overlay sources from the NVSS Catalog (Condon et al. 1998)
pro gridview_nvss

common gridview_state

if (state.nvssoverlaystatus eq 1 AND state.mapcurrent eq 'continuum') then begin

ramin=state.ramin
ramax=state.ramax
decmin=state.decmin
decmax=state.decmax

;Peak ranges in mJy/beam
peaklower=[0.005, 0.05, 0.1, 0.2, 0.3]    
peakupper=[0.05,   0.1, 0.2, 0.3, 100]
peakstring=['(5-50)', '(50-100)', '(100-200)', '(200-300)', '(>300)']

;CYAN, GREEN, MAGENTA, PINK, YELLOW, RED
colors=['FFFF00'XL, '00FF00'XL,'FF00FF'XL,'7F7FFF'XL, '0000FF'XL]

symsize=[0.9,1.2,2.0,2.0,2.2]
psym=[1,1,5,5,6]
xlevs=[50,130,210,290,370]
ylevs=480

for i=0, n_elements(peakupper)-1 do begin

   invss=where(state.nvsscat.ra_2000_ lt ramax*15.0 AND $
           state.nvsscat.ra_2000_ gt ramin*15.0 AND $
           state.nvsscat.dec_2000_ lt decmax AND $
           state.nvsscat.dec_2000_ gt decmin AND $
           state.nvsscat.peak_int ge peaklower[i] AND $
           state.nvsscat.peak_int lt peakupper[i])



   hor, ramax, ramin
   ver, decmax, decmin

   if (invss[0] ne -1) then begin
      device, decomposed=1
      plots,state.nvsscat[invss].ra_2000_/15.0, state.nvsscat[invss].dec_2000_ , $
         psym=psym[i],symsize=symsize[i], color=colors[i], /data
      device, decomposed=0

   endif



;Display Legend
device, decomposed=1
plots, xlevs[i], ylevs+3, psym=psym[i], symsize=1.0, color=colors[i], /device
xyouts,xlevs[i]+8, ylevs, peakstring[i], color=colors[i], charsize=1.0, /device
device, decomposed=0

endfor


xyouts, 425, ylevs, 'mJy/beam', charsize=1.0, color='FFFFFF'XL, /device



endif

end



;-----------------------------------------------------
;Exit event handler
pro gridview_exit, event

common gridview_state

hor
ver
!p.multi=0

widget_control, state.baseID, /destroy
loadct, 0, /silent
stretch, 0,100

delvarx, state

print, 'Exiting Gridview...'

end


;------------------------------------------------------------
;Help
pro gridview_help, event

   common gridview_state

h=['GRIDview        ', $
   'Brian Kent, Cornell Univ.', $
   ' ', $
   'Started October, 2005', $
   'Last update, Tuesday, December 14, 2005']


if (not (xregistered('gridview_help', /noshow))) then begin

helptitle = strcompress('Gridview HELP')

    help_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = helptitle, $
                             uvalue = 'help_base')

    help_text = widget_text(help_base, /scroll, value = h, xsize = 85, ysize = 15)
    
    help_done = widget_button(help_base, value = ' Done ', uvalue = 'help_done')

    widget_control, help_base, /realize
    xmanager, 'gridview_help', help_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro gridview_help_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'help_done': widget_control, event.top, /destroy
    else:
endcase

end

;----------------------------------------------------------------------

pro gridview_utility
  common gridview_state

if (not (xregistered('gridview_utility', /noshow))) then begin

utiltitle = strcompress('...')

    util_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = utiltitle, $
                             uvalue = 'util_base')

    util_draw = widget_draw(util_base, xsize=800, ysize=600)
    
    util_done = widget_button(util_base, value = ' Do you LOVE your data? ', uvalue = 'util_done')

    widget_control, util_base, /realize
    xmanager, 'gridview_utility', util_base, /no_block
    
    widget_control, util_draw, get_value=index
    wset, index
    url='http://www.astro.cornell.edu/~bkent/images/datautil'
    spawn, 'wget -q -O ~/datautil3754 ' + "'" + url + "'"
    read_jpeg, '~/datautil3754', testjunk
    tvscl, testjunk, true=1
    spawn, '/bin/rm -r ~/datautil3754'
endif 



end

;----------------------
pro gridview_utility_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'util_done': widget_control, event.top, /destroy
    else:
endcase

end



;-----------------------------------------------------------
;cutout Image display procedure
pro gridview_cutout_display

common gridview_state


widget_control, state.plotwindowimage, get_value=index
wset, index
device, decomposed=0
loadct, 1, /silent     


case state.currentimage of 

0: begin
              ;USE FOR DSS2 BLUE
             
               stretch, state.stretchupper, state.stretchlower
               tvscl, state.dssimage
               stretch, state.stretchlower, state.stretchupper

   end


1: begin

               ;USE TO GET SDSS IMAGES

               tv,state.sloanimage, true=1 
               
   end

else:

endcase






end



;;;;;;EVENT HANDLERS FOR SETTINGS

;------------------------------------------------------------
;Settings for Polarization colors
pro gridview_polsettings, event

   common gridview_state

if (not (xregistered('gridview_polsettings', /noshow))) then begin

colortablenames=[ 'B-W LINEAR', 'BLUE/WHITE', 'RED TEMPERATURE', 'RAINBOW', 'GREEN/WHITE LINEAR', 'STERN SPECIAL']
colortableselections=['0','1','3','13','8','14']


settingstitle = strcompress('Gridview Pol Settings')

    settings_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = settingstitle, $
                             uvalue = 'settings_base')
     PolAbase=widget_base(settings_base, /row)
     label=widget_label(PolAbase, value=' Polarization A ')
     state.polAselect=widget_droplist(PolAbase, value=colortablenames, uvalue=colortableselections)

     PolBbase=widget_base(settings_base, /row)
     label=widget_label(PolBbase, value=' Polarization B ')
     state.polBselect=widget_droplist(PolBbase, value=colortablenames, uvalue=colortableselections)

     avgpolbase=widget_base(settings_base, /row)
     label=widget_label(avgpolbase, value=' Average Pol ')
     state.avgpolselect=widget_droplist(avgpolbase, value=colortablenames, uvalue=colortableselections)


    settings_defaults=widget_button(settings_base, value = ' Defaults ', uvalue = 'polsettings_defaults', event_pro='gridview_polsettings_done')
    settings_done = widget_button(settings_base, value = ' Done ', uvalue = 'polsettings_done', event_pro='gridview_polsettings_done')

    widget_control, settings_base, /realize
    xmanager, 'gridview_polsettings', settings_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro gridview_polsettings_done, event

common gridview_state

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'polsettings_done': begin
     
        polA=widget_info(state.polAselect, /DropList_Select)
        polB=widget_info(state.polBselect, /DropList_Select)
        avgpol=widget_info(state.avgpolselect, /DropList_Select)

        widget_control, state.polAselect, get_uvalue=colortableselections

        colortableselections=long(colortableselections)

        state.polAcolor=colortableselections[polA]
        state.polBcolor=colortableselections[polB]
        state.avgpolcolor=colortableselections[avgpol]

        if (state.currentpol eq 0) then state.colortable=state.polAcolor
        if (state.currentpol eq 1) then state.colortable=state.polBcolor
        if (state.currentpol eq 2) then state.colortable=state.avgpolcolor

     end

     'polsettings_defaults': begin

        state.polAcolor=3
        state.polBcolor=8
        state.avgpolcolor=1

        if (state.currentpol eq 0) then state.colortable=state.polAcolor
        if (state.currentpol eq 1) then state.colortable=state.polBcolor
        if (state.currentpol eq 2) then state.colortable=state.avgpolcolor

     end


    else:
 endcase

        widget_control, state.velslider, get_value=channel
        gridview_display, channel
        gridview_display_weights, channel

     widget_control, event.top, /destroy


end


;-------------------------------------------------------------------------
;Settings for colorbar scale
pro gridview_scalesettings, event

   common gridview_state

if (not (xregistered('gridview_scalesettings', /noshow))) then begin




settingstitle = strcompress('Gridview Colorbar scale settings')

    settings_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = settingstitle, $
                             uvalue = 'settings_base')
     minbase=widget_base(settings_base, /row)
     label=widget_label(minbase, value=' Colorbar minimum ')
     state.colorbarmin_text=widget_text(minbase, value=strcompress(state.colorbarmin), $
                     uvalue='colorbarminbox', /editable)

     maxbase=widget_base(settings_base, /row)
     label=widget_label(maxbase, value=' Colorbar maximum ')
     state.colorbarmax_text=widget_text(maxbase, value=strcompress(state.colorbarmax), $
                     uvalue='colorbarmaxbox', /editable)

    
    settings_defaults=widget_button(settings_base, value = ' Defaults ', uvalue = 'scalesettings_defaults', event_pro='gridview_scalesettings_done')
    settings_done = widget_button(settings_base, value = ' Done ', uvalue = 'scalesettings_done', event_pro='gridview_scalesettings_done')

    widget_control, settings_base, /realize
    xmanager, 'gridview_scalesettings', settings_base, /no_block
    
endif


end

;----------------------------------------------------------------------
;Event handler for colobar scale settings window
pro gridview_scalesettings_done, event

common gridview_state

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'scalesettings_done': begin
     
        widget_control, state.colorbarmin_text, get_value=minstring
        state.colorbarmin=float(minstring[0])
        widget_control, state.colorbarmax_text, get_value=maxstring
        state.colorbarmax=float(maxstring[0])


     end

     'scalesettings_defaults': begin

       state.colorbarmin=-5.0
       state.colorbarmax=10.0  

     end


    else:
 endcase

        widget_control, state.velslider, get_value=channel
        gridview_display, channel
        gridview_display_weights, channel

     widget_control, event.top, /destroy


end


;---------------------------------------------------------------------
;RA dec conversion - takes ra in decimal hours, and dec in decimal degrees
;                    and converts to strings - uses adstring from GSFC
;                                              ASTRO LIB
      
pro radecconvert, rahr, decdeg, rastring, decstring
        
   radeg=(rahr/24.0)*360.0
      
   result=strtrim(adstring([radeg,decdeg], 2, /truncate))
      
;Use strmatch here?
;Get position of plus or minus sign for dec, and cut the string at
;that position
    
   signpos=strpos(result, '+')
   if (signpos eq -1) then signpos=strpos(result, '-')
           
   rastring=strmid(result, 0, signpos-1)
   decstring=strmid(result, signpos, strlen(result)-1)
  
end





;------------------------------------------------------------------
;Procedure that actually writes out the JPEG files
pro export_jpeg


common gridview_state

widget_control, state.baseID, hourglass=1

widget_control, state.exportstart, get_value=startstring
widget_control, state.exportnumframes, get_value=numframesstring
widget_control, state.exportnumsteps, get_value=numstepsstring
widget_control, state.exportdirectory, get_value=exportdirectory

start=long(startstring[0])
numframes=long(numframesstring[0])
step=long(numstepsstring[0])

res=700

stop=start+(numframes-1)*step

device, decomposed=0

stretch, state.stretchlower, state.stretchupper

;Beginning for each file
for i=start, stop, step do begin

;GOTO Z device for output
thisDevice=!d.name
set_plot, 'Z', /COPY

Device, Set_Resolution=[res,res], Z_Buffer=0
Erase




lowerchan=i-step
upperchan=i+step
if (lowerchan lt 0) then lowerchan=0
if (upperchan gt n_elements(state.data.velarr)-1) $
               then upperchan=n_elements(state.data.velarr)-1

filename='vel_'+strcompress(long(state.data.velarr[upperchan]), /remove_all)+'_'+$
         strcompress(long(state.data.velarr[lowerchan]), /remove_all)+'.jpg'

outputfilename=exportdirectory+filename


loadct, state.colortable, /silent


ramin=state.ramin
ramax=state.ramax
decmin=state.decmin
decmax=state.decmax

hor, ramin, ramax
ver, decmin, decmax

posarray=[0.15,0.15,0.95,0.95]
xstyle=1
ystyle=1

charsize=1.0
xtitle='RA [HMS] J2000'
ytitle='Dec [DMS] J2000'
ticklen=-0.01
if (state.currentpol eq 0) then poltitle='Pol A'
if (state.currentpol eq 1) then poltitle='Pol B'
if (state.currentpol eq 2) then poltitle='Avg Pol'


plot, [0,0], /nodata, xstyle=xstyle, ystyle=ystyle, position=posarray, $
             charsize=charsize, xtitle=xtitle, ytitle=ytitle, $
             xtick_get=xvals, ytick_get=yvals, ticklen=ticklen



nxticklabels=n_elements(xvals)
nyticklabels=n_elements(yvals)



xvals=float(xvals)
yvals=yvals

xspacing=((xvals[n_elements(xvals)-1]-xvals[0])*60.0)/(nxticklabels-1)

yspacing=((yvals[n_elements(yvals)-1]-yvals[0])*60.0)/(nyticklabels-1)

ticlabels, xvals[0]*15.0, nxticklabels, xspacing, xticlabs,/ra,delta=1

ticlabels, yvals[0], nyticklabels, yspacing, yticlabs, delta=1

erase

hor, ramax, ramin
ver, decmin, decmax

    
 loadct, state.colortable, /silent   
    
        xsize=561
        ysize=561
        px=105
        py=105

        map=reform(total(state.data.d[lowerchan:upperchan,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax],1)/(float(2*step)))
        map=total(map,1)/2.
        map=reverse(congrid(reform(map), xsize,ysize))

     

;Fetch the smoothing state
widget_control, state.smoothslider, get_value=smoothval
smoothval=smoothval[0]

case state.currentscaling of

   'linearscaling': begin
       tvscl, smooth(map,smoothval, /edge_truncate), px, py
   end

    'logscaling': begin
       offset=min(map)-(max(map)-min(map))*0.01
       tvscl, smooth(alog10(map-offset), smoothval, /edge_truncate), px,py
    end

    'histeqscaling':begin
        tvscl, smooth(hist_equal(map, minv=min(map), maxv=max(map)), smoothval, /edge_truncate), px, py
    end

else:

endcase
      
       infostring=' Channels '+strcompress(lowerchan)+' to '+strcompress(upperchan)+ $
             ', Integrated Velocity= '+strcompress(state.data.velarr[lowerchan])+$
             ' to '+strcompress(state.data.velarr[upperchan])+' km/s   '+poltitle
       
plot, [0,0], /nodata, xstyle=1, ystyle=1, /noerase, position=posarray, $ 
             xtickn=reverse(xticlabs), ytickn=yticlabs, $
             charsize=charsize, xtitle=xtitle, ytitle=ytitle, ticklen=ticklen
             
xyouts, 60, 30, infostring, /device, charsize=charsize

snapshot=tvrd()
tvlct, r,g,b, /get
device, Z_Buffer=1
set_plot, thisDevice
        
image = BytArr(3, res, res)
image[0,*,*] = r[snapshot]
image[1,*,*] = g[snapshot]
image[2,*,*] = b[snapshot]

write_jpeg, outputfilename, image, true=1, quality=100


endfor

widget_control, state.baseID, hourglass=0


end




;---------------------------------------------------------------------
;JPEG output - gui for procedure that outputs integrated velocity maps

pro gridview_jpeg_output, event

common gridview_state




if (not (xregistered('gridview_jpeg_ouput', /noshow))) then begin

jpeg_outputtitle = strcompress('GRIDview JPEG output')

    jpeg_output_base =  widget_base(group_leader = state.baseID, $
                             /row, /base_align_right, title = jpeg_outputtitle, $
                             uvalue = 'jpeg_output_base')
    configbase=widget_base(jpeg_output_base, /column, /align_left)
       startbase=widget_base(configbase, /row)
       widget_control, state.gotochannel, get_value=currentchannel
          state.exportstart=widget_text(startbase, xsize=8, value=currentchannel,$ 
                                      /editable, uvalue='exportstart')
           label=widget_label(startbase, value='Start Channel        ')
       numframesbase=widget_base(configbase, /row)
          state.exportnumframes=widget_text(numframesbase, xsize=8, value='1', $
                                      /editable, uvalue='exportnumframes')
          label=widget_label(numframesbase, value='# of frames')
       numstepsbase=widget_base(configbase, /row)
          state.exportnumsteps=widget_text(numstepsbase, xsize=8, value='5', $
                                      /editable, uvalue='exportnumsteps')
          label=widget_label(numstepsbase, value='# of steps')

          cd, current=pwd  ;Get current working directory into a string

    filesbase=widget_base(jpeg_output_base, /column, /align_left)
          directorybase=widget_base(filesbase, /row)
             state.exportdirectory=widget_text(directorybase, xsize=40, value=pwd+'/', $
                                               /editable, uvalue='exportdirectory')
             label=widget_label(directorybase, value='Output directory')

     buttonbase=widget_base(filesbase, xsize=100,ysize=100, /align_right, /column)

    jpeg_output_export = widget_button(buttonbase, value = ' Export ', $
                uvalue = 'jpeg_output_export', event_pro='gridview_jpeg_output_event')
    cancel=widget_button(buttonbase, value=' Cancel ', uvalue='jpeg_output_cancel', $
                                       event_pro='gridview_jpeg_output_event')

    widget_control, jpeg_output_base, /realize
    xmanager, 'gridview_jpeg_output', jpeg_output_base, /no_block
    
endif


end

;----------------------------------------------------------------------
;Event handler for JPEG output gui
pro gridview_jpeg_output_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'jpeg_output_export': begin

      export_jpeg

      widget_control, event.top, /destroy

  end

    'jpeg_output_cancel': widget_control, event.top, /destroy


    else:
endcase

end



;----------------------------------------------------------------------
pro gridview_fetch_spectrum, xpos, ypos

common gridview_state


state.spectrumon=1

if (xpos lt 0) then xpos=0
if (ypos lt 0) then ypos=0

if (xpos gt state.sx-1) then xpos=state.sx-1
if (ypos gt state.sy-1) then ypos=state.sy-1

;xsizepixel=state.sx
;ysizepixel=state.sy

;ramin=state.ramin
;ramax=state.ramax
;decmin=state.decmin
;decmax=state.decmax

;xsizearcmin=15.0*(ramax-ramin)*60.0
;ysizearcmin=(decmax-decmin)*60.0

;pixscalex=xsizepixel/xsizearcmin
;pixscaley=ysizepixel/ysizearcmin

;widget_control, state.apertureFWHM, get_value=FWHMstring
;FWHM=double(FWHMstring[0])

widget_control, state.gotochannel, get_value=channelstring
channel=long(channelstring[0])

;FOLLOWING TWO LINES NO LONGER NEEDED BECAUSE OF ZOOM FUNCTION
;widget_control, state.spectrumwindowwidth, get_value=widthstring
;width=long(widthstring[0])

;FWHM=4.0  ; units of arcmin

;sigma=FWHM*pixscalex/2.3548    ;sigma in pixels
;print, sigma

;nx=21
;ny=21

;X = DINDGEN(nx) # REPLICATE(1.0, ny)
;X=X-10
;Y = REPLICATE(1.0, nx) # DINDGEN(ny)
;Y=Y-10

;U=X^2+Y^2

;A=1/(2*sigma^2)

;B=A*EXP(-U/(2.0*sigma^2))

width=250

startchannel=channel-width/2
stopchannel=channel+width/2

if (startchannel lt 0) then startchannel=0
if (stopchannel gt n_elements(state.data.velarr)-1) then stopchannel=n_elements(state.data.velarr)-1

spectrum=dblarr(n_elements(state.data.velarr))
spectrumweights=dblarr(n_elements(state.data.velarr))

widget_control, state.baseID, hourglass=1

;print, xpos, ypos

;Convert from screen coordinates back to current cube coordinates   
;xcube=-round((float(n_elements(state.data.d[0,0,*,0]))/state.sx)*xpos)+n_elements(state.data.d[0,0,*,0])-1
;ycube=round((float(n_elements(state.data.d[0,0,0,*]))/state.sy)*ypos)

xcube=-round((float(state.xcubemax-state.xcubemin+1)/state.sx)*xpos)+(state.xcubemax-1)
ycube=round((float(state.ycubemax-state.ycubemin+1)/state.sy)*ypos)+(state.ycubemin)


;print, xcube, ycube

spectrum=(state.data.d[*,0,xcube,ycube]+state.data.d[*,1,xcube,ycube])/2.0
spectrumweights=(state.data.w[*,0,xcube,ycube]+state.data.w[*,1,xcube,ycube])/2.0

;for i=startchannel,stopchannel do begin

;    print, i

;   map=reform(state.data.d[i,*,state.xcubemin:state.xcubemax, state.ycubemin:state.ycubemax])
;   map=total(map,1)/2.0
   
;   image=reverse(congrid(map, state.sx,state.sy))
  
   ;Take care of clicks near the edge
;   lowerx=long(xpos-15)
;   upperx=long(xpos+15)
;   lowery=long(ypos-15)
;   uppery=long(ypos+15)


;   if (lowerx lt 0) then lowerx=0
;   if (upperx gt state.sx-1) then upperx=long(state.sx-1)
;   if (lowery lt 0) then lowery=0
;   if (uppery gt state.sy-1) then uppery=long(state.sy-1)

;   imagecutout=image[lowerx:upperx, lowery:uppery]   ;mJy/beam
  
;   convol_result=convol(imagecutout, B, total(B))    ;mJy

   ;weightedmean=total(B*imagecutout)
;   fluxdensity=total(convol_result)/total(B)

;   spectrum[i]=fluxdensity/10.0

;endfor

;BRIAN'S ATTEMPT AT CALIRBATION!!   :)
;which isn't really working

;map=reform(state.data.cont[*,state.xcubemin:state.xcubemax,state.ycubemin:state.ycubemax ])
;map=total(map,1)/2.
;xpos=212
;ypos=266
;image=reverse(congrid(map, state.sx,state.sy))

;lowerx=long(xpos-15)
;   upperx=long(xpos+15)
;   lowery=long(ypos-15)
;   uppery=long(ypos+15)

;imagecutout=image[lowerx:upperx, lowery:uppery]   ;mJy/beam

;convol_result=convol(imagecutout, B, total(B)) 

;fluxdensity=total(convol_result)/total(B)

;print, fluxdensity

;FOR CUBE 8 ONLY - ONLY A TEST
;calfactor=fluxdensity/(10^.56)

;spectrum=spectrum/calfactor


widget_control, state.baseID, hourglass=0






;Plot velocity on x-axis
if (state.spectrumaxisstatus eq 0) then begin

widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, state.data.velarr[stopchannel], state.data.velarr[startchannel]
ver, min(spectrum[startchannel:stopchannel]), max(spectrum[startchannel:stopchannel])

device, decomposed=1
color='0000FF'XL   ;RED
plot,state.data.velarr[startchannel:stopchannel],spectrum[startchannel:stopchannel],xstyle=1, ystyle=1, xtitle='Velocity [km/s]', charsize=0.7, ytitle='Flux Density [mJy/beam]', /nodata
oplot,state.data.velarr[startchannel:stopchannel], spectrum[startchannel:stopchannel], color=color
;x=indgen(n_elements(spectrum))
;xcentroid=total(spectrum*x)/total(spectrum)

flag, state.data.velarr[channel], color='00FF00'XL  ; GREEN current channel (velocity)

;REPEAT FOR WEIGHTS

widget_control, state.plotwindowspectrumweights, get_value=index
wset, index

hor, state.data.velarr[stopchannel], state.data.velarr[startchannel]
ver,0.0,1.1

color='0000FF'XL   ;RED
plot,state.data.velarr[startchannel:stopchannel],spectrumweights[startchannel:stopchannel]/state.maxweight,xstyle=1, ystyle=1, xtitle='Velocity [km/s]', charsize=0.7, ytitle='Weight', /nodata
oplot,state.data.velarr[startchannel:stopchannel], spectrumweights[startchannel:stopchannel]/state.maxweight, color=color

flag, state.data.velarr[channel], color='00FF00'XL  ; GREEN current channel (velocity)



device, decomposed=0


endif else begin   ;Plot channel on x-axis

widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, startchannel, stopchannel
ver, min(spectrum[startchannel:stopchannel]), max(spectrum[startchannel:stopchannel])

device, decomposed=1
color='0000FF'XL   ;RED
plot,spectrum,xstyle=1, ystyle=1, xtitle='Channel', charsize=0.7, ytitle='Flux Density [mJy]', /nodata
oplot, spectrum, color=color
;x=indgen(n_elements(spectrum))
;flag, total(spectrum*x)/total(spectrum), color='00FF00'XL  ; GREEN current channel
flag, channel, color='00FF00'XL  ; GREEN centroid for redshift

;Repeat for weights

widget_control, state.plotwindowspectrumweights, get_value=index
wset, index

hor, startchannel, stopchannel
ver, 0.0,1.1

color='0000FF'XL   ;RED
plot,spectrumweights/state.maxweight,xstyle=1, ystyle=1, xtitle='Channel', charsize=0.7, ytitle='Weight', /nodata
oplot, spectrumweights/state.maxweight, color=color
;x=indgen(n_elements(spectrum))
;flag, total(spectrum*x)/total(spectrum), color='00FF00'XL  ; GREEN current channel
flag, channel, color='00FF00'XL  ; GREEN centroid for redshift



device, decomposed=0



endelse

state.spectrum=spectrum
state.spectrumweights=spectrumweights
state.spectrum_xmin=startchannel
state.spectrum_xmax=stopchannel
state.spectrum_ymin=min(spectrum[startchannel:stopchannel])
state.spectrum_ymax=max(spectrum[startchannel:stopchannel])

hor
ver

gridview_display, channel
gridview_display_weights, channel

state.getspectrumstatus=0

end






;-----------------------------------------------------------------
;Displays spectrum in spectrum window box

pro gridview_plotspectrum


common gridview_state



widget_control, state.gotochannel, get_value=channelstring
channel=long(channelstring[0])

spectrum=state.spectrum
spectrumweights=state.spectrumweights

;Plot velocity on x-axis
if (state.spectrumaxisstatus eq 0) then begin


widget_control, state.plotwindowspectrumweights, get_value=index
wset, index

device, decomposed=1

hor, state.data.velarr[state.spectrum_xmax], state.data.velarr[state.spectrum_xmin]
ver, 0.0,1.1

color='0000FF'XL   ;RED
plot,state.data.velarr[state.spectrum_xmin:state.spectrum_xmax],spectrumweights[state.spectrum_xmin:state.spectrum_xmax]/state.maxweight,$
           xstyle=1, ystyle=1, xtitle='Velocity [km/s]', $
           charsize=0.7, ytitle='Weight', /nodata
oplot,state.data.velarr[state.spectrum_xmin:state.spectrum_xmax], spectrumweights[state.spectrum_xmin:state.spectrum_xmax]/state.maxweight, color=color

flag, state.data.velarr[channel], color='00FF00'XL  ; GREEN current channel (velocity)

widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, state.data.velarr[state.spectrum_xmax], state.data.velarr[state.spectrum_xmin]
ver, state.spectrum_ymin, state.spectrum_ymax



color='0000FF'XL   ;RED
plot,state.data.velarr[state.spectrum_xmin:state.spectrum_xmax],spectrum[state.spectrum_xmin:state.spectrum_xmax],xstyle=1, ystyle=1, xtitle='Velocity [km/s]', charsize=0.7, ytitle='Flux Density [mJy/beam]', /nodata
oplot,state.data.velarr[state.spectrum_xmin:state.spectrum_xmax],spectrum[state.spectrum_xmin:state.spectrum_xmax], color=color
;x=indgen(n_elements(spectrum))
;xcentroid=total(spectrum*x)/total(spectrum)

flag, state.data.velarr[channel], color='00FF00'XL  ; GREEN current channel (velocity)


device, decomposed=0


endif else begin   ;Plot channel on x-axis

widget_control, state.plotwindowspectrumweights, get_value=index
wset, index

device, decomposed=1

hor, state.spectrum_xmin, state.spectrum_xmax
ver, 0.0,1.1

color='0000FF'XL   ;RED
plot,spectrumweights/state.maxweight,xstyle=1, ystyle=1, $
    xtitle='Channel', charsize=0.7, ytitle='Weight', /nodata
oplot, spectrumweights/state.maxweight, color=color
flag, channel, color='00FF00'XL  ; GREEN centroid for redshift



widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, state.spectrum_xmin, state.spectrum_xmax
ver, state.spectrum_ymin, state.spectrum_ymax

color='0000FF'XL   ;RED
plot,spectrum,xstyle=1, ystyle=1, xtitle='Channel', charsize=0.7, ytitle='Flux Density [mJy/beam]', /nodata
oplot, spectrum, color=color
;x=indgen(n_elements(spectrum))
;flag, total(spectrum*x)/total(spectrum), color='00FF00'XL  ; GREEN current channel
flag, channel, color='00FF00'XL  ; GREEN centroid for redshift


device, decomposed=0

endelse    



end






;------------------------------------------------------------------
;Update the box in the spectrum window - NOT USED AS OF OCT 18.
pro gridview_update_spectrum_box

common gridview_state

widget_control, state.plotwindowspectrum, get_value=index
wset, index

hor, 0,n_elements(state.data.velarr)-1
ver, 0,1.0

plot, [0,0], /nodata, xstyle=1, ystyle=1, xtitle='Channel', charsize=0.7

widget_control, state.gotochannel, get_value=channelstring

channel=long(channelstring[0])
widget_control, state.spectrumwindowwidth, get_value=widthstring

width=long(widthstring[0])

device, decomposed=1
color='0000FF'XL   ;RED
tvboxbk, [width, 1.0], channel, 0.5, /data, color=color
device, decomposed=0




hor
ver

end

;------------------------------------------------------------------
;------------------------------------------------------------------
;HELP QUICKSTART BLOCK

;------------------------------------------------------------
;Help
pro gridview_quickstart, event

   common gridview_state

h=['GRIDviewTM Quickstart',$
'A sanctioned product of LOVEDATA, Inc. Ithaca, NY',$
'CONTENTS',$
'',$
'    * Overview',$
'    * Menu Options',$
'    * Main Window',$
'    * Colorbar',$
'    * Weights Window',$
'    * Information Display',$
'    * Controls',$
'    * Spectrum Window',$
'    * Imaging Window',$
'',$
'Overview',$
'GRIDview is a set of procedures written in IDL to assist in the ',$
'visualization of 3D data cubes, primarily those of the ALFALFA ',$
'extragalactic survey. The data from meridian transit drifts scans ',$
'are grouped and combined via procedures (posfind and grid_prep) into ',$
'regularly gridded data, with approprimate headers, coordinates, ',$
'and all pertinent information concerning the creation of the cube. ',$
'GRIDView acts as a tool that can read this data and display/average ',$
'cube spectral and continuum planes, extract single pixel spectra, ',$
'show the weights function derived in the creation of the cube, access ',$
'images, and export for use in other media.',$
'',$
'',$
'Menu Options',$
'File 	',$
'',$
'    * Export JPEG - allows user to export JPEGs in ',$
'        single channel or averaged channel maps in ',$
'        the directory of their chosing. Files are named by velocity range.',$
'    * Exit - exit the program!',$
'',$
'Settings 	',$
'',$
'    * Pol Colors - Choose color table to use with polarziation options',$
'    * Colorbar Scale - If a constant, fixed scaling option is used, then ',$
'        the program will use the intensity range specified here.',$
'',$
'Scaling 	',$
'',$
'    * Linear - Fixed minimum and maximum scaling for auto or constant scaling.',$
'    * Log - Scaling where offset is calculated and subtracted before taking a ',$
'               base 10 logarithm.',$
'    * Histogram EQ - Histogram equalization of the image.',$
'',$
'Colorbar 	',$
'',$
'    * Autoscale - minimum and maximum values are determined using the full ',$
'                     range of the image',$
'    * Constant Scale - minimum and maximum values are taken from input ',$
'                          in the settings menu (default is -5 to +10).',$
'',$
'Catalogs 	',$
'',$
'    * Multi-AGC mode - NEW!  For a given channel, this mode will display', $
'                       all AGC galaxies in the range.  RED for those that do not', $
'                       have any redshift information, LIGHT BLUE for those that have', $
'                       been searched or have a known optical or 21cm derived velocity,', $
'                       but are not in the current channel range (determined by the', $
'                       velocity width), and YELLOW for those with known redshifts', $
'                       or that have been search within the currently selected channel', $
'                       range.', $
'    * AGC (known cz) - known cz catalog overlay.  If the galaxy has 21 cm line',$
'                         information, OR has been searched before for HI, ', $
'                         it will be displayed as a yellow box.  Hover your mouse', $
'                         over the box to see the DETCODE at the bottom of the ',$
'                         GRIDview window', $
'    * AGC (no known cz) - unknown cz catalog overlay',$ 
'    * NVSS - continuum mode option. Sources above a peak intensity value ',$ 
'                of 5 mJy/beam are display and color coded.',$ 
'    * 2D extractor - not current active.  Ask Brian Kent for more information',$ 
'    * 3D extractor - pass a keyword at startup using:  ',$
'                                 gridview, grid, cat3D=filename_string ',$
'                     Sources will be displayed as a red cross with the source number', $
'',$
'Help 	',$
'',$
'    * Quickstart - Text version of this guide.',$
'    * About - Information, update information, and modification history.',$
'',$
'',$
'Main Window',$
'The main window display shows a color image of the current spectral channel ',$
'   (in single channel mode) or an averaged channel map (if ',$
'   the velocity "integration") option is selected. ',$
'    If continuum mode is selected, the continuum for the cube will be shown. ',$
'    Any selected catalogs will be overlaid on the map. The user may LEFT click',$ 
'    with the mouse and drag a square box to zoom to a selected region. ',$
'    A single LEFT mouse click will restore the display to the full range of ',$
'    the cube in RA and Dec. RIGHT clicking will display a DSS image ',$
'    (spectral mode) or NVSS image (continuum mode), overlaying a box showing ',$
'    the image size.  The user may hover the mouse over a point and press ',$
'    the "n" key to query NED within 10 arcminutes of that point on the sky.', $
'',$
'Colorbar',$
'The colorbar window shows the current dynamic range for the currently selected',$ 
'colortable (available in the Settings menu). ',$
'Colorbar can autoscale for the currently displayed map, or use a fixed ',$
'constant scale that can be set in the settings menu. The user can LEFT ',$
'click and drag the colorbar to refine the dynamic range.',$
'',$
'Weights Window',$
'The weights window shows the same area currently seen in the main window. ',$
'It shows a linearly scaled image of the weights for the current ',$
'(single or averaged) spectral channel or continuum map.',$
'',$
'Information Display',$
'The left column of the information display show information from the ',$
'current grid structure - The grid name, size, velocity range and ',$
'coordinate epoch. The switch for spectral and continuum mode is also ',$
'located is this display. The right column of the information display ',$
'shows current coordinates for the mouse pointer in the main window - ',$
'RA/DEC, velocity of the current channel, and x/y/intensnity of the',$
'current cube pixel.',$
'',$
'Controls',$
'In spectral mode, the user can access different spectral channels via ',$
'the channel slider, the NEXT and PREVIOUS buttons, or by typing a desired ',$
'channel into the channel box. If the slider is active, the left and right',$
'arrow keys may be used to scroll through the data cube. A second slider ',$
'can be used to boxcar smooth the currently displayed map, with a SCREEN ',$
'pixel width determined from the slider value. A simple boxcar smooth can ',$
'also be used in the spectral direction by clicking the velocity integration',$  
'option. A average will be taken over +/- the number of channels the user ',$ 
'specifies in the box (default is 5 channels). The box below the velocity ',$
'integration is the Arecibo General Catalog Display. If the AGC is turned ',$ 
'"on" (catalogs menu), then hovering the mouse over an AGC galaxy will ',$
'display the number, description, and optical and 21cm measured cz values.',$
'',$
'Spectrum Window',$
'Clicking the GET SPECTRUM button, followed by a click on the main window. ',$
'A spectrum will be shown (x axis units are chosen by user - velocity ',$
'or channels). A single LEFT click in the spectrum window will zoom ',$
'out to the full spectrum range. A LEFT click and dragging a box will ',$
'zoom into the selected box range.',$
'',$
'Imaging Window',$
'The user can input an image size; left clicking on the main window will ',$
'retreive an image of that size and display it in the imaging window. ',$
'DSS 2 Blue images are retreived in spectral mode, and NVSS image are ',$
'retrieved in continuum mode. ',$
'',$
'Brian Kent, Cornell University.']


if (not (xregistered('gridview_quickstart', /noshow))) then begin

helptitle = strcompress('Gridview Quickstart')

    help_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = helptitle, $
                             uvalue = 'help_base')

    help_text = widget_text(help_base, /scroll, value = h, xsize = 90, ysize = 50)
    
    help_done = widget_button(help_base, value = ' Done ', uvalue = 'quickstart_done')

    widget_control, help_base, /realize
    xmanager, 'gridview_quickstart', help_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro gridview_quickstart_event, event

 common gridview_state

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'quickstart_done': widget_control, event.top, /destroy
    else:
endcase

end




;----------------------------------------------------------------------
pro gridview_nedgui, rahr, decdeg

 common gridview_state

widget_control, state.baseID, hourglass=1

nedquery, rahr*15.0, decdeg,10.0, numberinfo=numberinfo, string_array=string_array

h=[numberinfo, '  Name 			         RA(J2000)   DEC(J2000)	TYPE      VEL    Z	   SKY DIST(arcmin)',string_array]


if (not (xregistered('gridview_nedgui', /noshow))) then begin

helptitle = strcompress('Gridview NED Results')

    help_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = helptitle, $
                             uvalue = 'ned_base')

    help_text = widget_text(help_base, /scroll, value = h, xsize = 110, ysize = n_elements(h)+2)
    
    help_done = widget_button(help_base, value = ' Done ', uvalue = 'nedgui_done')

    widget_control, help_base, /realize
    xmanager, 'gridview_nedgui', help_base, /no_block
    
endif



widget_control, state.baseID, hourglass=0



end



;----------------------------------------------------------------------

pro gridview_nedgui_event, event

 common gridview_state

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'nedgui_done': begin
        state.keystatus=0
        widget_control, event.top, /destroy
    end


    else:
endcase

end

;----------------------------------------------------------------------
;Rearrange structure for 3D extraction catalogs
;Not used as of Dec. 14

pro convert3Dcat, catin, catout

table=catin

catout=   {id:table.(0)[0], $
           ra:table.(1)[0], $
           dec:table.(2)[0], $
           radec:table.(3)[0], $
           channel:table.(4)[0], $
           rapixel:table.(5)[0], $
           decpixel:table.(6)[0], $
           width:table.(7)[0], $   
           ara:table.(8)[0], $     
           adec:table.(9)[0], $    
           peak_flux:table.(10)[0], $
           int_flux:table.(11)[0], $ 
           sn:table.(12)[0], $
           rms:table.(13)[0], $
           cz:table.(14)[0], $ 
           agc:table.(15)[0], $
           comment:table.(16)[0]}


for j=0,n_elements(table.(0))-1 do begin


tabletemp={id:table.(0)[j], $ 
           ra:table.(1)[j], $
           dec:table.(2)[j], $
           radec:table.(3)[j], $   
           channel:table.(4)[j], $ 
           rapixel:table.(5)[j], $ 
           decpixel:table.(6)[j], $
           width:table.(7)[j], $
           ara:table.(8)[j], $
           adec:table.(9)[j], $
           peak_flux:table.(10)[j], $
           int_flux:table.(11)[j], $
           sn:table.(12)[j], $ 
           rms:table.(13)[j], $  
           cz:table.(14)[j], $
           agc:table.(15)[j], $
           comment:table.(16)[j]}

catout=[catout, tabletemp]

endfor


catout=catout[1:n_elements(catout)-1]




end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Main program block;;;;;;;;;;;;
pro gridview, data, cat3D=cat3D

  gridview_startup, data, cat3D=cat3D

  common gridview_state

  gridview_display, 0
  gridview_display_weights, 0

end
