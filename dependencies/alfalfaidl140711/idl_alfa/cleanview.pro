pro cleanview, llx=llx, lly=lly, urx=urx, ury=ury

; Common blocks we need from gridview2
common gridview2_state
common gridstate

; Intialize common blocks
common cleanview_state,		viewstate, viewdisp
common clean,      		cleanstate, dbox, cbox, cleand, c_cleand

; Fix box size to a minmum of 20x20.  If it doesn't, expand equally in all directions.
while (urx-llx+1) LT 20 do begin
	urx = urx+1
	llx = llx-1
	if llx LT 0 then begin
		llx = 0
		urx = urx+1
	endif
	if urx GE grid.nx then begin
		urx = grid.nx-1
		llx = llx-1
	endif
endwhile
while (ury-lly+1) LT 20 do begin
	ury = ury+1
	lly = lly-1
	if lly LT 0 then begin
		lly = 0
		ury = ury+1
	endif
	if ury GE grid.ny then begin
		ury = grid.ny-1
		lly = lly-1
	endif
endwhile

; Define, grid, dbox, cbox, cleand, and c_cleand
rbox = grid.d[*, *, llx:urx, lly:ury]
wbox = grid.w[*, *, llx:urx, lly:ury]
dbox = total( rbox*wbox, 2, /Double) / total( wbox, 2, /Double)
  bad = where( finite(dbox) NE 1 )
  if bad[0] NE -1 then dbox[bad] = 0.0
cleand = dbox * 0.0

rbox = grid.cont[*, llx:urx, lly:ury]
wbox = grid.cw[*, llx:urx, lly:ury]
cbox = total( rbox*wbox, 1, /Double) / total( wbox, 1, /Double)
  bad = where( finite(cbox) NE 1 )
  if bad[0] NE -1 then cbox[bad] = 0.0
c_cleand = cbox * 0.0

; Define the viewstate structure (cleanview main window)
viewstate = { baseID: 0L, display_win: 0L, colorbar_win: 0L, slider: 0L, summary: 0L, clog: 0L, $
		linear: 0L, logari: 0L, histeq: 0L, acscale: 0L, ccscale: 0L, $
		agccz: 0L, agcncz: 0L, cathvc: 0L, cat3d: 0L, catchk: 0L, catcnt: 0L, $
		colorBLU: 0L, colorGRN: 0L, colorRED: 0L, $
		xval: 0L, yval: 0L, vval: 0L, ival: 0L, $
		xpix: 0L, ypix: 0L, vpix: 0L, $
		ramin: (grid.ramin+llx*grid.deltara/3600.0), $
		ramax: (grid.ramin+urx*grid.deltara/3600.0), $
		decmin: (grid.decmin+lly*grid.deltadec/60.0), $
		decmax: (grid.decmin+ury*grid.deltadec/60.0), $
		fmin: -5.0, fmax: 10.0, $
		drawfluxbox: 0, cornerx: 0.0, cornery: 0.0, px: [0.0, 0.0], py: [0.0, 0.0], sx: 0.0, sy: 0.0, mousestate: 0, $
		clean_rms: 0L, clean_flux: 0L, clean_sigma: 0L, clean_niter: 0L, clean_chn: 0L, clean_sum: 0L, $
		save_dir: 0L, save_name: 0L, $
		dir: '', frmsta: 0L, frmnum: 0L, frmste: 0L}

; Define viewdisp structure (controls how the maps are displayed in the cleanview window)
viewdisp = { UseCons: 0, UseAuto: 0, $
		UseLin: 0, UseLog: 0, UseHeq: 0, $
		CBMin: -5.0, CBMax: 10.0, colortab: 1, $
		UseKA: 0, UseUA: 0, UseHV: 0, Use3D: 0, UseCk: 0, UseCt: 0 }
; Setup the variables based off the gridview2_state
viewdisp.UseKA = state.agcoverlaystatus
viewdisp.UseUA = state.agcoverlaystatus_nocz
viewdisp.UseHV = state.dhbboverlaystatus
viewdisp.Use3D = state.overlaystatus3D
viewdisp.UseCk = state.checkliststatus
viewdisp.UseCT = state.cntsrcstatus

; Define cleanstate structur that holds of the info about cleaning
cleanstate = {llx: llx, lly: lly, urx: urx, ury: ury, cx: (urx+llx)/2, cy: (ury+lly)/2, $
	beam: dblarr(25,25), beamlog: strarr(10), rms: 0.0, flux: 0.0, sigma: 5.0, niter: 2000L, crange: [0L,1023L], allowsum: 0, $
	cleanlog: strarr(10001), cleansum: intarr(3)}

; Begin the Gui
main_base = widget_base(Title='CLEANview', /Column, mbar=top_menu)
viewstate.baseID = main_base
; Menu items
filemenu=widget_button(top_menu, value=' File')
buttonjpeg=widget_button(filemenu, value=' Export JPEG ', event_pro='cleanview_jpeg')
buttonsave=widget_button(filemenu, value=' Save Data ', uvalue='dsave')
buttonexit=widget_button(filemenu, value=' Exit ', uvalue='exit', /Separator)
colormenu=widget_button(top_menu, value=' Color ')
viewstate.colorBLU = widget_button(colormenu, value=' Blue/White ',  uvalue='blue', /Checked_Menu)
viewstate.colorGRN = widget_button(colormenu, value=' Green/White ', uvalue='green', /Checked_Menu)
viewstate.colorRED = widget_button(colormenu, value=' Red/White ',   uvalue='red', /Checked_Menu)
scalingmenu=widget_button(top_menu, value=' Scaling ')
viewstate.linear=widget_button(scalingmenu, value=' Linear ', uvalue='linscl', /Checked_Menu) 
viewstate.logari=widget_button(scalingmenu, value=' Logarithmic ', uvalue='logscl', /Checked_Menu) 
viewstate.histeq=widget_button(scalingmenu, value=' Histogram EQ ', uvalue='heqscl', /Checked_Menu) 
colorbarmenu=widget_button(top_menu, value=' Colorbar ')
viewstate.acscale=widget_button(colorbarmenu, value=' Autoscale ', uvalue='colorbar_ascale', /Checked_Menu)
viewstate.ccscale=widget_button(colorbarmenu, value=' Constant scale ', uvalue='colorbar_cscale', /Checked_Menu)
catalogmenu=widget_button(top_menu, value=' Catalogs ')
viewstate.agccz=widget_button(catalogmenu, value=' AGC Catalog (known cz)', uvalue='agc_cz', /Checked_Menu)
viewstate.agcncz=widget_button(catalogmenu, value=' AGC Catalog (no known cz)', uvalue='agc_ncz', /Checked_Menu) 
viewstate.cathvc=widget_button(catalogmenu, value= ' HVC catalog (de Heij 2002)', uvalue='cathvc',/Checked_Menu)
viewstate.cat3d=widget_button(catalogmenu, value=' 3D Catalog ', uvalue='cat3d', /Checked_Menu)
viewstate.catchk=widget_button(catalogmenu, value=' Checklist (GALflux) ', uvalue='catchk', /Checked_Menu)
viewstate.catcnt=widget_button(catalogmenu, value=' Continuum (>250mJy/bm) ', uvalue='catcnt', /Checked_Menu)
helpmenu=widget_button(top_menu, value=' Help ')
buttonstart=widget_button(helpmenu, value=' Quick Start ', uvalue='qstart')
buttonabout=widget_button(helpmenu, value=' About ', uvalue='about',/Separator)

; Plot Base
upper_base = widget_base(main_base, /Row)
	viewstate.display_win = widget_draw(upper_base, uvalue='draw', XSize=512, YSize=512, $
		Frame=1, Event_Pro='cleanview_display_event', /Motion_Events, /Button_Events, $
		Retain=2, /Keyboard_Events)
	viewstate.colorbar_win = widget_draw(upper_base, uvalue='color', XSize=100, YSize=512, $
		Frame=1, Event_Pro='cleanview_display_event', /Motion_Events, /Button_Events)
; Controls and info base
middle_base = widget_base(main_base, /Row)
	; Info on data window
	info_base = widget_base(middle_base, /Column, /Frame)
		info_sub1 = widget_base(info_base, /Align_Center)
			label = widget_label(info_sub1, value='Image Info:')
		info_sub2 = widget_base(info_base, /Row, /Align_Left)
			info_sub3 = widget_base(info_sub2, /Column, /Align_Left)
			info_sub4 = widget_base(info_sub2, /Column, /Align_Left)
				label = widget_label(info_sub3, value='Pixel X:  ')
				viewstate.xpix = widget_label(info_sub3, value='---')
				label = widget_label(info_sub4, value='RA:  ')
				viewstate.xval = widget_label(info_sub4, value='00 00 00.0')
				label = widget_label(info_sub3, value='Pixel Y:  ')
				viewstate.ypix = widget_label(info_sub3, value='---')
				label = widget_label(info_sub4, value='DEC: ')
				viewstate.yval = widget_label(info_sub4, value='+00 00 00.0')
				label = widget_label(info_sub3, value='Channel:  ')
				viewstate.vpix = widget_label(info_sub3, value='   0')
				label = widget_label(info_sub4, value='cz:  ')
				viewstate.vval = widget_label(info_sub4, $
					value=string(grid.velarr[0],Format='(F7.1)'))
				label = widget_label(info_sub3, value='Intensity: ')
				viewstate.ival = widget_label(info_sub4, value='999.999999')
		info_sub5 = widget_base(info_base, /Row, /Align_Center)
			viewstate.slider = widget_slider(info_sub5, min=0, max=n_elements(grid.velarr)-1, $
				title='Channel', value=0, uvalue='slider', /drag)
	; Control of CLEAN
	clean_base = widget_base(middle_base, /Column, /Frame)
		clean_sub1 = widget_base(clean_base, /Align_Center)
			label = widget_label(clean_sub1, value='CLEAN Control:')
		clean_sub2 = widget_base(clean_base, /Align_Left, Row=6)
			label = widget_label(clean_sub2, value='Grid RMS:         ')
			viewstate.clean_rms = widget_text(clean_sub2, value=string(0.0, Format='(F5.2)'), $
				XSize=7)
			label = widget_label(clean_sub2, value='Flux Limit:       ')
			viewstate.clean_flux = widget_text(clean_sub2, value='0.0', $
				uvalue='limitf', /Editable, XSize=7)
			label = widget_label(clean_sub2, value='Flux Sigma Limit: ')
			viewstate.clean_sigma = widget_text(clean_sub2, value='5.0', $
				uvalue='limits', /Editable, XSize=7)
			label = widget_label(clean_sub2, value='Iteration Limit:  ')
			viewstate.clean_niter = widget_text(clean_sub2, value='2000', $
				uvalue='limiti', /Editable, XSize=7)
			label = widget_label(clean_sub2, value='Channel Range: ')
			viewstate.clean_chn = widget_text(clean_sub2, value='0, 1023', $
				uvalue='limitc', /Editable, XSize=10)
			label = widget_label(clean_sub2, value='Combine to Improve S/N? ')
			viewstate.clean_sum = widget_button(clean_sub2, value='No ', uvalue='cleansum')
			
	; Output of CLEAN
	log_base = widget_base(middle_base, /Column, /Frame)
		label = widget_label(log_base, value='CLEAN Log:', /Align_Center)
		viewstate.summary = widget_label(log_base, value='Flux: ---- Iteration: ---- Residual: ----', $
			/Align_Left)
		viewstate.clog = widget_text(log_base, value='----', /Scroll, YSize=12, XSize=30)
; Button base
bottom_base = widget_base(main_base, /Row)
	beam_button = widget_button(bottom_base, value='View Beam', uvalue='beam')
	clean_button = widget_button(bottom_base, value='Clean Region', uvalue='clean')
	vfeld_button = widget_button(bottom_base, value='Velocity Field', uvalue='vfeld')
	flux_button = widget_button(bottom_base, value='Measure Flux', uvalue='flux')

; Go for it
widget_control, main_base, /realize
xmanager, 'cleanview', main_base, /no_block

; Setup default settings - scaling and colorbar
viewdisp.UseCons = 1
viewdisp.UseAuto = 0
widget_control, viewstate.linear, set_button=1
viewdisp.UseLin = 1
viewdisp.UseLog = 0
viewdisp.UseHeq = 0
widget_control, viewstate.ccscale, set_button=1
viewdisp.colortab = 1
widget_control, viewstate.colorBLU, Set_Button=1

; Setup default settings - grid rms
help,/memory
widget_control, /Hourglass
grid_rms = robust_sigma(grid.d)
widget_control, viewstate.clean_rms, set_value=string(grid_rms, Format='(F5.2)')
cleanstate.rms = grid_rms
help,/memory

; Setup default settings - catalog overlays
if viewdisp.UseKA EQ 1 then widget_control, viewstate.agccz, Set_Button=1
if viewdisp.UseUA EQ 1 then widget_control, viewstate.agcncz, Set_Button=1
if viewdisp.UseHV EQ 1 then widget_control, viewstate.cathvc, Set_Button=1
if viewdisp.Use3D EQ 1 then widget_control, viewstate.cat3d, Set_Button=1
if viewdisp.UseCk EQ 1 then widget_control, viewstate.catchk, Set_Button=1
if viewdisp.UseCT EQ 1 then widget_control, viewstate.catcnt, Set_Button=1

; Setup default settings - velocity slider
widget_control, state.velslider, get_value=channel
widget_control, viewstate.slider, set_value=string(channel)

cleanview_updatemap, /reset

end


pro cleanview_display_event, event

common cleanview_state
common gridstate
common clean

widget_control, event.id, get_uvalue=uvalue

case uvalue of
	'draw': begin
		Event_Types = ['DOWN', 'UP', 'MOTION', '?', '?', '?', '?']
		This_Event = Event_Types[event.type]
		case This_Event of
			'DOWN'  : begin
				if event.press eq 1 then begin
					viewstate.mousestate=1
					; Turn motion events on for the draw widget.
					widget_control, viewstate.display_win, Draw_Motion_Events=1
					widget_control, viewstate.display_win, get_value=index
										
					; Create a pixmap. Store its ID. Copy window contents into it.
					Window, 19, /Pixmap, XSize=512, YSize=512
					Device, Copy=[0, 0, 512, 512, 0, 0, index]
					
					; Get and store the static corner of the box.
					viewstate.cornerx = event.x
					viewstate.cornery = event.y
				endif
			end
			'UP'    : begin
				if viewstate.mousestate then begin
					viewstate.mousestate=0
					
					; Erase the last box drawn. Destroy the pixmap.
					widget_control, viewstate.display_win, get_value=index
					wSet, index
					Device, Copy=[0, 0, 512, 512, 0, 0, 19]
					
					; Order the box coordinates.
					sx = Min([viewstate.cornerx, event.x], Max=dx)
					sy = Min([viewstate.cornery, event.y], Max=dy)
					
					WDelete, 19
					
					;Determine coordinates FOR SQUARE BOX to zoom in on
					width=abs(dx-sx)
					xpos_min=sx
					xpos_max=dx
					ypos_min=sy
					
					if viewstate.drawfluxbox NE 0 then begin
						ypos_max=dy

						xpos_min = round( xpos_min - viewstate.px[0]-1 )
						xpos_max = round( xpos_max - viewstate.px[0]-1 )
						ypos_min = round( ypos_min - viewstate.py[0]-1 )
						ypos_max = round( ypos_max - viewstate.py[0]-1 )
						
						xmax = -round(float(cleanstate.urx-cleanstate.llx+1) / viewstate.sx*xpos_min) + $
							(cleanstate.urx)
						xmin = -round(float(cleanstate.urx-cleanstate.llx+1) / viewstate.sx*xpos_max) + $
							(cleanstate.urx)
						ymin =  round(float(cleanstate.ury-cleanstate.lly+1) / viewstate.sy*ypos_min) + $
							(cleanstate.lly)
						ymax =  round(float(cleanstate.ury-cleanstate.lly+1) / viewstate.sy*ypos_max) + $
							(cleanstate.lly)
						
						;Protect against going 'outside' the cube
						if (xmin lt cleanstate.llx) then xmin = cleanstate.llx
						if (ymin lt cleanstate.lly) then ymin = cleanstate.lly
						if (xmax gt cleanstate.urx) then xmax = cleanstate.urx
						if (ymax gt cleanstate.ury) then ymax = cleanstate.ury
						
						if viewstate.drawfluxbox EQ 1 then begin
							loadct, viewdisp.colortab, /Silent
						
							;Call the flux measureing routine GALFLUX
							viewstate.drawfluxbox = 0
						
							widget_control, viewstate.display_win, Clear_Events=1
							cleanflux,llx=xmin, lly=ymin, urx=xmax, ury=ymax
						endif
						if viewstate.drawfluxbox EQ 2 then begin
							loadct, viewdisp.colortab, /Silent
						
							;Call the flux measureing routine cleanvfield
							viewstate.drawfluxbox = 0
						
							widget_control, viewstate.display_win, Clear_Events=1
							xmin = xmin + cleanstate.llx
							xmax = xmax + cleanstate.llx
							ymin = ymin + cleanstate.lly
							ymax = ymax + cleanstate.lly
							fieldview, llx=xmin, lly=ymin, urx=xmax, ury=ymax
						endif
					endif
				endif
				cleanview_updatemap, /reset
			end
			'MOTION': begin
				if event.press eq 0 AND viewstate.mousestate eq 1 then begin
					; Here is where the actual box is drawn and erased.
					; First, erase the last box.

					widget_control, viewstate.display_win, get_value=index
					wset, index
					Device, Copy=[0, 0, 512, 512, 0, 0, 19]

					; Get the coodinates of the new box and draw it.
					sx = viewstate.cornerx
					sy = viewstate.cornery
					dx = event.x
					dy = event.y
					loadct, viewdisp.colortab, /silent
					width=abs(dx-sx)

					;plot a flux measurement box of arbitrary size
					if viewstate.drawfluxbox EQ 1 then begin
						color=FSC_Color('Red')
					
						PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
							Color=color, thick=1.5

						xyouts, sx+10, sy-10, 'FLUX BOX', /device, color=color
					endif
					if viewstate.drawfluxbox EQ 2 then begin
						color=FSC_Color('Magenta')
					
						PlotS, [sx, sx, dx, dx, sx], [sy, dy, dy, sy, sy], /Device, $
							Color=color, thick=1.5

						xyouts, sx+10, sy-10, 'V. FIELD BOX', /device, color=color
					endif
				endif
			end
			else    :
		endcase

		widget_control, viewstate.display_win, get_value=index
		wset, index
	
		hor, viewstate.ramax, viewstate.ramin
		ver, viewstate.decmin, viewstate.decmax
		
		xdevice=event.x
		ydevice=event.y
	
		widget_control, viewstate.slider, get_value=chnstring
		channel=long(chnstring[0])
		
		result=convert_coord(xdevice, ydevice, /Device, /Double, /To_Data)
		xdata=result[0]
		ydata=result[1]
	
		if (xdata lt viewstate.ramin OR xdata gt viewstate.ramax OR $
			ydata lt viewstate.decmin OR ydata gt viewstate.decmax) then begin
			widget_control, viewstate.xval, set_value='----'
			widget_control, viewstate.yval, set_value='----'
			widget_control, viewstate.xpix, set_value='----'
			widget_control, viewstate.ypix, set_value='----'
			widget_control, viewstate.ival, set_value='----'
		endif else begin
			radecconvert, xdata, ydata, rastring, decstring
			xpix = round((xdata - viewstate.ramin)*3600.0 / grid.deltara + cleanstate.llx)
			ypix = round((ydata - viewstate.decmin)*60.0 / grid.deltadec + cleanstate.lly)
			ival = cleand[channel, xpix-cleanstate.llx, ypix-cleanstate.lly]
			widget_control, viewstate.xval, set_value=string(rastring[0], format='(a11)')
			widget_control, viewstate.yval, set_value=string(decstring[0], format='(a11)')
			widget_control, viewstate.xpix, set_value=string(xpix,Format='(I3)')
			widget_control, viewstate.ypix, set_value=string(ypix,Format='(I3)')
			widget_control, viewstate.ival, set_value=string(ival,Format='(F10.3)')
		endelse
	end
	else:	

endcase


end


pro cleanview_event, event

common gridview2_state
common cleanview_state
common gridstate
common clean

widget_control, event.id, get_uvalue=uvalue, get_value=value

change_to = 1
case uvalue of
	'blue': begin
		if viewdisp.colortab NE 1 then begin
			viewdisp.colortab = 1
			widget_control, viewstate.colorBLU, Set_Button=1
			widget_control, viewstate.colorGRN, Set_Button=0
			widget_control, viewstate.colorRED, Set_Button=0
			cleanview_updatemap, /reset
		endif
	end
	'green': begin
		if viewdisp.colortab NE 8 then begin
			viewdisp.colortab = 8
			widget_control, viewstate.colorBLU, Set_Button=0
			widget_control, viewstate.colorGRN, Set_Button=1
			widget_control, viewstate.colorRED, Set_Button=0
			cleanview_updatemap, /reset
		endif
	end
	'red': begin
		if viewdisp.colortab NE 3 then begin
			viewdisp.colortab = 3
			widget_control, viewstate.colorBLU, Set_Button=0
			widget_control, viewstate.colorGRN, Set_Button=0
			widget_control, viewstate.colorRED, Set_Button=1
			cleanview_updatemap, /reset
		endif
	end

	; Update catalog information
	'agc_cz': begin
		if viewdisp.UseKA EQ 1 then change_to = 0
		viewdisp.UseKA = change_to
		widget_control, event.id, Set_Button=change_to
		cleanview_updatemap
	end
	'agc_ncz': begin
		if viewdisp.UseUA EQ 1 then change_to = 0
		viewdisp.UseUA = change_to
		widget_control, event.id, Set_Button=change_to
		cleanview_updatemap
	end
	'cathvc': begin
		if viewdisp.UseHV EQ 1 then change_to = 0
		viewdisp.UseHV = change_to
		widget_control, event.id, Set_Button=change_to
		cleanview_updatemap
	end
	'cat3d': begin
		if viewdisp.Use3D EQ 1 then change_to = 0
		viewdisp.Use3D = change_to
		widget_control, event.id, Set_Button=change_to
		cleanview_updatemap
	end
	'catchk': begin
		if viewdisp.UseCk EQ 1 then change_to = 0
		viewdisp.UseCk = change_to
		widget_control, event.id, Set_Button=change_to
		cleanview_updatemap
	end
	'catcnt': begin
		if viewdisp.UseCt EQ 1 then change_to = 0
		viewdisp.UseCt = change_to
		widget_control, event.id, Set_Button=change_to
		cleanview_updatemap
	end

	; Update Colorbar and display
	'colorbar_ascale': begin
		if viewdisp.UseAuto EQ 0 then begin
			; Set parameters in viewdisp to avoid calls to widget_info over and over again
			viewdisp.UseCons = 0
			viewdisp.UseAuto = 1
			; Update the buttons
			widget_control, event.id, Set_Button=1
			widget_control, viewstate.ccscale, set_button=0
			; Render the map with the new settings
			cleanview_updatemap, /reset
		endif
	end
	'colorbar_cscale': begin
		if viewdisp.UseCons EQ 0 then begin
			; Set parameters in viewdisp to avoid calls to widget_info over and over again
			viewdisp.UseCons = 1
			viewdisp.UseAuto = 0
			; Switch over to linear scale
			viewdisp.UseLin = 1
			viewdisp.UseLog = 0
			viewdisp.UseHeq = 0
			; Update the buttons
			widget_control, event.id, Set_Button=1
			widget_control, viewstate.acscale, set_button=0
			; Render the map with the new settings
			cleanview_updatemap, /reset
		endif
	end

	;Update scaling and display
	'linscl': begin
		if viewdisp.UseLin EQ 0 then begin
			viewdisp.UseLin = 1
			viewdisp.UseLog = 0
			viewdisp.UseHeq = 0

			widget_Control, event.id, Set_Button=1
			widget_control, viewstate.logari, set_button=0
			widget_control, viewstate.histeq, set_button=0
			
			cleanview_updatemap, /reset
		endif
	end
	'logscl': begin
		if viewdisp.UseLog EQ 0 then begin
			viewdisp.UseLin = 0
			viewdisp.UseLog = 1
			viewdisp.UseHeq = 0
			; Switch over to an automatic scale for this one
			viewdisp.UseCons = 0
			viewdisp.UseAuto = 1

			widget_Control, event.id, Set_Button=1
			widget_control, viewstate.linear, set_button=0
			widget_control, viewstate.histeq, set_button=0
			; Force to autoscale
			widget_control, viewstate.ccscale, set_button=0
			widget_control, viewstate.acscale, set_button=1

			cleanview_updatemap, /reset
		endif
	end
	'heqscl': begin
		if viewdisp.UseHeq EQ 0 then begin
			viewdisp.UseLin = 0
			viewdisp.UseLog = 0
			viewdisp.UseHeq = 1
			; Switch over to an automatic scale for this one
			viewdisp.UseCons = 0
			viewdisp.UseAuto = 1

			widget_Control, event.id, Set_Button=1
			widget_control, viewstate.logari, set_button=0
			widget_control, viewstate.linear, set_button=0
			; Force to autoscale
			widget_control, viewstate.ccscale, set_button=0
			widget_control, viewstate.acscale, set_button=1
		
			cleanview_updatemap, /reset
		endif
	end

	; Update channel stuff
	'slider': begin
		cleanview_updatemap
	end		

	; Update the variables that control cleaning
	'limitf': begin
		cleanstate.flux = float(value)
	end
	'limits': begin
		cleanstate.sigma = float(value)
	end
	'limiti': begin
		cleanstate.niter = float(value)
	end
	'limitc': begin
		cleanstate.crange = long( strsplit(value, ',', /Extract) )
	end
	'cleansum': begin
		if strcmp(value, 'No ') then begin
			cleanstate.allowsum = 1
			widget_control, event.id, set_value='Yes'
		endif else begin
			cleanstate.allowsum = 0
			widget_control, event.id, set_value='No '
		endelse
	end

	; Handle the beam thing
	'beam': begin
		Widget_Control, viewstate.display_win, Clear_Events=1
		beamview
	end

	'clean': begin
		; Retrive value in text boxes
		widget_control, viewstate.clean_flux, get_value=value
			cleanstate.flux = value
		widget_control, viewstate.clean_sigma, get_value=value
			cleanstate.sigma = value
		widget_control, viewstate.clean_niter, get_value=value
			cleanstate.niter = value
		widget_control, viewstate.clean_chn, get_value=value
			cleanstate.crange = long( strsplit(value, ',', /Extract) )
		widget_control, viewstate.clean_sum, get_value=value
			if strcmp(value,'No ') then cleanstate.allowsum = 0 else cleanstate.allowsum = 1

		; Clear our the previous log
		widget_control, viewstate.summary, set_value='Flux: ---- Iteration: ---- Residual: ----'
		widget_control, viewstate.clog, set_value='----'

		; Set and hourglass and run with it
		widget_control, /Hourglass
		; First, check to see if 
		if total(cleanstate.beam) EQ 0 then begin
			build_beam3, grid, [cleanstate.cx, cleanstate.cy], $
				beam_out, /Silent, Output=log
			cleanstate.beam = beam_out
			cleanstate.beamlog = log
		endif

		; Clean it
		alfa_clean5, dbox, cleanstate.beam, cleand, $
			Continuum=cbox, c_cleand=c_cleand, $
			MapRMS=cleanstate.rms, $
			NIter=cleanstate.niter, Flux=cleanstate.flux,  Sigma=cleanstate.sigma, $
			Range=cleanstate.crange, AllowSum=cleanstate.allowsum, $
			Exit_Status=exit_status, /Silent, Output=log
		; Save output parameters to the correct places
		cleanstate.cleanlog = log
		junk = where(exit_status EQ -1, junk1)
		junk = where(exit_status EQ +1, junk2)
		junk = where(exit_status EQ +2, junk3)
		cleanstate.cleansum = [junk1, junk2, junk3]

		; Update main window and display it
		;+ Update log window
		widget_control, viewstate.summary, set_value='Flux: '+string(junk2,Format='(I4)')+ $
			' Iteration: '+string(junk1,Format='(I4)')+' Residual: '+ $
			string(junk3,Format='(I4)')
		widget_control, viewstate.clog, set_value=log
		;+ Update display
		cleanview_updatemap
	end

	'vfeld': viewstate.drawfluxbox = 2

	'flux': viewstate.drawfluxbox = 1

	'qstart': begin
		h=['CLEANView Quickstart',$
		'CONTENTS',$
		'',$
		'    * Overview',$
		'    * Menu Options',$
		'    * Main Window',$
		'    * Colorbar',$
		'    * Information Display',$
		'    * Controls',$
		'    * Log Window',$
		'    * Other Notes',$
		'',$
		'Overview',$
		'Clean is a set of procedures written in IDL to assist in the ',$
		'deconvolution of ALFA data, primarily those of the ALFALFA ',$
		'extragalactic survey. CleanView acts as a tool that interfaces with ',$
		'GRIDview2, build_beam3, and alfa_clean5 to select data for deconvolution, ',$
		'model the local beam shape, and deconvolve the data.  The deconvolution ',$
		'process can also be fully controlled from this program.',$
		'',$
		'',$
		'Menu Options',$
		'File 	',$
		'',$
		'    * Export JPEG - allows user to export JPEGs in single channel or averaged ',$
		'                       channel maps in ',$
		'    * Save Data - Saves the deconvolved data along with the local beam shape',$
		'                     to an IDL save file that can be specified.',$
		'    * Exit - Exit the program.',$
		'',$
		'Color 	',$
		'',$
		'    * Blue/White - Set the color table to a linear blue-white stretch.',$
		'    * Green/White - Set the color table to a linear green-white stretch.',$
		'    * Red/White - Set the color table to a linear red-white stretch.',$
		'',$
		'Scaling 	',$
		'',$
		'    * Linear - Fixed minimum and maximum scaling for auto or constant scaling.',$
		'    * Logarithmic - Scaling where offset is calculated and subtracted before taking a ',$
		'                       base 10 logarithm.  This forced auto scaling to be turned on.',$
		'    * Histogram EQ - Histogram equalization of the image.  This forces auto scaling to ',$
		'                        turned on',$
		'',$
		'Colorbar 	',$
		'',$
		'    * Autoscale - minimum and maximum values are determined using the full ',$
		'                     range of the image.  This option is available for all options ',$
		'                     in the Scaling menu.',$
		'    * Constant Scale - minimum and maximum values are taken from input ',$
		'                          in the settings menu (default is -5 to +10).  This ',$
		'                          is only available with the Linear scale option.',$
		'',$
		'Catalogs 	',$
		'',$
		'    * AGC (known cz) - known cz catalog overlay.  If the galaxy has 21 cm line',$
		'                         information, OR has been searched before for HI, ', $
		'                         it will be displayed as a yellow box.  Hover your mouse', $
		'                         over the box to see the DETCODE at the bottom of the ',$
		'                         GRIDview2 window', $
		'    * AGC (no known cz) - unknown cz catalog overlay',$ 
		'    * 3D extractor - pass a keyword at start-up using:  ',$
		'                                 gridview2, grid, cat3D=filename_string ',$
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
		'   if the map has been deconvolved.  If not, the display are will show a solid ',$
		'   color.  Any selected catalogs will be overlaid on the map. ',$
		'',$
		'Colorbar',$
		'The colorbar window shows the current dynamic range for the currently selected',$ 
		'colortable (available in the Settings menu). ',$
		'Colorbar can autoscale for the currently displayed map, or use a fixed ',$
		'constant scale that can be set in the settings menu.',$
		'',$
		'Information Display',$
		'The left column of the information display show information from the ',$
		'current grid structure - The current coordinates for the mouse pointer ',$
		'in the main window - RA/DEC, velocity of the current channel, and ',$
		'x/y/intensity of the current cube pixel.',$
		'',$
		'Controls',$
		'This column controls all aspects of the deconvolution process.  The grid RMS ',$
		'is computed using GSFC IDL routine robust_sigma and cannot be changed.  The ',$
		'flux, flux sigma, and iteration options control how deeply each channel is ',$
		'cleaned.  "Flux" causes the cleaning loop to exit when the peak flux is below ',$
		'this value.  "Flux sigma" exits when the peak flux is below some multiple of the ',$
		'grid RMS.  "Iteration" is a simple iteration limit.  The channel selection option ',$
		'confines the deconvolution to a set range of channels.  For some sources, the ',$
		'signal strength is too low for a through cleaning.  To get around this, the ',$
		'"combine channels" can be set.  This combines channels until at least 75% of ',$
		'channels can be cleaned at least once.  Once the cleaning is done, the combined ',$
		'channels are split into constituent channels again.',$
		'',$
		'Log Window',$
		'Once the deconvolution has finished, details of the process are display in ',$
		'the log window.  These details include the how many channels were combined ',$
		'for the cleaning process, the exit status of each channel (flux limited, ',$
		'iteration limited, or residuals limited), and the total run time.  This ',$
		'information is also saved when the CLEANed data cube is saved.',$
		'',$
		'Other Notes',$
		'* For most sources, the default values are good.  However, for bright sources or ',$
		'     sources near Galactic HI a higher iteration limit of 5,000 to 10,000 should ',$
		'     be used.  This will slow down the deconvolution but yield better results',$
		'* If the channel range is a prime number and the "combine channel" options is set ',$
		'     then the routine will combine all channels into one.  Be sure to check the ',$
		'     log window to see if this has happened.',$
		'',$
		'',$
		'Jayce Dowell, Indiana University.']
			
		if NOT xregistered('cleanview_quickstart', /NoShow) then begin
			helptitle = strcompress('CLEANview Quickstart')
			help_base =  widget_base(group_leader=viewstate.baseID, /column, /base_align_right, $
				title=helptitle, uvalue = 'help_base')
			help_text = widget_text(help_base, /scroll, value = h, xsize = 90, ysize = 50)
			help_done = widget_button(help_base, value = ' Done ', uvalue = 'about_done', $
				event_pro='cleanview_event')
			widget_control, help_base, /realize
			xmanager, 'cleanview_quickstart', help_base, /no_block
		endif
	end
	'about': begin
		h = ['CleanView - Graphical deconvolution utility', $
		     '  Written, November 2007', $
		     ' ', $
		     '  Last update, Tuesday, March 18, 2008']
		
		if NOT xregistered('cleanview_help', /NoShow) then begin
			about_base =  widget_base(group_leader=viewstate.baseID, title='About CleanView', $
				/Column, /Base_Align_Right, uvalue = 'about_base')
			about_text = widget_text(about_base, /Scroll, value = h, xsize = 45, ysize = 10)
			about_done = widget_button(about_base, value = ' Done ', uvalue = 'about_done', $
				event_pro='cleanview_event')
			
			widget_control, about_base, /realize
			xmanager, 'cleanview_help', about_base, /no_block
		endif
	end
	'about_done': begin
		widget_control, event.top, /destroy
	end

	'dsave': begin
		if NOT xregistered('cleanview_save', /NoShow) then begin
			cd, current=dir
			save_base = widget_base(group_leader=viewstate.baseID, title=' CLEANview Save Data ', /Column, $
				uvalue='save_base')
			  top_base = widget_base(save_base, /Column, /Base_Align_Left)
			    save_text = widget_label(top_base, value='Output Directory:    ')
			    viewstate.save_dir = widget_text(top_base, value=dir+'/', uvalue='save_dir', $
				/Editable, XSize=40)
			    save_text = widget_label(top_base, value='Output File Name:    ')
			    viewstate.save_name = widget_text(top_base, value='cleanview.sav', uvalue='save_name', $
				/Editable, XSize=40)
			  bottom_base = widget_base(save_base, /Row, /Base_Align_Right)
			    save_save = widget_button(bottom_base, value = ' Save ',   uvalue = 'save_save')
			    save_done = widget_button(bottom_base, value = ' Cancel ', uvalue = 'save_cancel')

			widget_control, save_base, /realize
			xmanager, 'cleanview_save', save_base, /no_block
		endif
	end 

	'exit': begin
		widget_control, event.top, /destroy

		hor
		ver
		loadct, 1, /silent
		
		delvarx, viewstate, viewdisp
		delvarx, cleanstate, dbox, cbox, cleand, c_cleand

		widget_control, state.BaseID, /sensitive
		
		print, 'Exiting CleanView...'
	end
else:
endcase
		
end


pro cleanview_save_event, event

common cleanview_state
common gridstate
common clean

widget_control, event.id, get_uvalue=uvalue, get_value=value

case uvalue of
	'save_save': begin
		widget_control, viewstate.save_dir,  get_value=dir
		widget_control, viewstate.save_name, get_value=filename
		
		widget_control, /Hourglass
		filename = dir+filename
		save, cleanstate, cleand, c_cleand, filename=filename
		
		widget_control, event.top, /destroy
	end
	'save_cancel': begin
		widget_control, event.top, /destroy
	end
	else:	
endcase

end


pro cleanview_updatemap, Reset=Reset

common cleanview_state
common gridstate
common clean

device,decomposed=0

; Get current chan
widget_control, viewstate.slider, get_value=chnstring
channel=long(chnstring[0])

; Update the color table
loadct,viewdisp.colortab,/Silent

; Update the info base
widget_control, viewstate.vpix, set_value=string(chnstring,Format='(I4)')
widget_control, viewstate.vval, set_value=string(grid.velarr[channel],Format='(F7.1)')
; Check display scaling and colorbar mapping
if viewdisp.UseLin EQ 1 then begin
	to_disp = cleand[channel,*,*]

	title_cb = 'Flux Density [mJy/beam]'
	format_cb = '(I4)'
	
	delta = max(to_disp) - min(to_disp)
	d_min = min(to_disp) + delta/5.0
	d_max = max(to_disp) - delta/5.0
endif

if viewdisp.UseLog EQ 1 then begin
	offset = min(cleand[channel,*,*])-(max(cleand[channel,*,*])-min(cleand[channel,*,*]))*0.01
	to_disp = alog10(cleand[channel,*,*] - offset)

	title_cb = 'Log Flux Density [log(mJy/beam)]'
	format_cb = '(F5.2)'

	delta = max(to_disp) - min(to_disp)
	d_min = min(to_disp) + delta/5.0
	d_max = max(to_disp) - delta/5.0
endif

if viewdisp.UseHeq EQ 1 then begin
	to_disp = hist_equal(cleand[channel,*,*], minv=min(cleand[channel,*,*]), maxv=max(cleand[channel,*,*]))

	title_cb = 'Flux Density [mJy/beam]'
	format_cb = '(I3)'

	delta = max(to_disp) - min(to_disp)
	d_min = min(to_disp) + delta/5.0
	d_max = max(to_disp) - delta/5.0
endif

if viewdisp.UseCons EQ 1 then begin
	d_min = -5.0
	d_max = 10.0
endif

viewdisp.CBMin = d_min
viewdisp.CBMax = d_max
widget_control, viewstate.colorbar_win, get_value=index
  wset, index
  erase
  colorbar, Range=[d_min, d_max], Position=[0.50, 0.10, 0.90, 0.90], /Ver, $
  	Title=title_cb, Format=format_cb

; Update the image
widget_control, viewstate.display_win, get_value=index
wset, index

if Keyword_Set(Reset) then begin
	xrange = [viewstate.ramax, viewstate.ramin]
	yrange = [viewstate.decmin, viewstate.decmax]
	plot, [0,0], /nodata, xrange=xrange, yrange=yrange, xstyle=1, ystyle=1, $
		xtick_get=xvals, ytick_get=yvals, ticklen=ticklen, charsize=1.0, $
		Position=[0.15,0.15,0.95,0.95]
	nxticklabels=n_elements(xvals)
	nyticklabels=n_elements(yvals)
	xspacing=((xvals[n_elements(xvals)-1]-xvals[0])*60.0)/(nxticklabels-1)
	yspacing=((yvals[n_elements(yvals)-1]-yvals[0])*60.0)/(nyticklabels-1)
	xticlabs=ratickname(xvals*15.0)
	yticlabs=dectickname(yvals)
	plot, [0,0], /nodata, xrange=xrange, yrange=yrange, $
		xtitle='Right Ascension (J2000)', ytitle='Declination (J2000)', $
		xstyle=1, ystyle=1, Position=[0.15,0.15,0.95,0.95], $
		xtickn=xticlabs, ytickn=yticlabs, ticklen=-0.01, charsize=1.0
	viewstate.px = !X.WINDOW * !D.X_VSIZE
	viewstate.py = !Y.WINDOW * !D.Y_VSIZE
	viewstate.sx = viewstate.px[1] - viewstate.px[0] - 1
	viewstate.sy = viewstate.py[1] - viewstate.py[0] - 1
endif

hor, viewstate.ramax, viewstate.ramin
ver, viewstate.decmin, viewstate.decmax

tv, reverse( bytscl(congrid(reform(to_disp), viewstate.sx, viewstate.sy), min=d_min, max=d_max) ), $
	viewstate.px[0]+2, viewstate.py[0]+2

; Update catalog information
cleanview_updatecat
end



pro cleanview_updatecat

common cleanview_state
common gridstate
common clean
common gridview2_state

device, decomposed=1

widget_control, viewstate.slider, get_value=chnstring
channel=long(chnstring[0])

lc = ((channel-14) > 0 )
uc = ((channel+14) < (n_elements(grid.velarr)-1))

c_ra = (state.agc.rah+state.agc.ram/60.0+state.agc.ras10/10.0/3600.0)
c_dec = (state.agc.decd+state.agc.decm/60.0+state.agc.decs/3600.0) * float(state.agc.sign+'1')

hor, viewstate.ramax, viewstate.ramin
ver, viewstate.decmin, viewstate.decmax

if viewdisp.UseKA EQ 1 then begin
	iagc=where(c_ra GT viewstate.ramin AND c_ra LT viewstate.ramax AND $
		c_dec GT viewstate.decmin AND c_dec LT viewstate.decmax AND $
		((state.agc.v21 lt grid.velarr[channel]+state.agc.width/2.0 AND $
		state.agc.v21 gt grid.velarr[channel]-state.agc.width/2.0 AND $
		state.agc.v21 ne 0) OR $
		(state.agc.vopt lt grid.velarr[lc] AND $
		state.agc.vopt gt grid.velarr[uc] AND $
		state.agc.vopt ne 0)))
	color = '00FFFF'XL
	;color=FSC_Color('Yellow')

	if (iagc[0] ne -1) then begin
		plots, c_ra[iagc], c_dec[iagc], PSym=6,SymSize=2, Color=color, /Data

		resultcoords=convert_coord(c_ra[iagc],c_dec[iagc], /data, /double, /to_device)
		xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, strcompress(state.agc.agcnumber[iagc], /remove_all), $
			Color=color, /Device
	endif
endif

;Plot AGC galaxies with no known redshifts in the area
if viewdisp.UseUA EQ 1 then begin
	iagc=where(c_ra GT viewstate.ramin AND c_ra LT viewstate.ramax AND $
		c_dec GT viewstate.decmin AND c_dec LT viewstate.decmax AND $
           	state.agc.v21 eq 0 AND state.agc.vopt eq 0 )
	
	color = '0000FF'XL
	;color=FSC_Color('Red')
; 
	if (iagc[0] ne -1) then begin
		plots, c_ra[iagc], c_dec[iagc], PSym=4, SymSize=3, Color=Color, /Data
		
		resultcoords=convert_coord(c_ra[iagc],c_dec[iagc], /data, /double, /to_device)
		xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, strcompress(state.agc.agcnumber[iagc], /remove_all), $
			Color=color, /Device
	endif
endif

; Plot HVC data
if viewdisp.UseHV EQ 1 then begin
	idhbb=where(state.dhbb._raj2000/15.0 lt viewstate.ramax AND state.dhbb._raj2000/15.0 gt viewstate.ramin AND $
            state.dhbb._dej2000 lt viewstate.decmax AND state.dhbb._dej2000 gt viewstate.decmin AND $
            (state.dhbb_vhelio lt grid.velarr[channel]+state.dhbb.fwhm/2.0 AND $
             state.dhbb_vhelio gt grid.velarr[channel]-state.dhbb.fwhm/2.0))

	color = '0000FF'XL
	;color=FSC_Color('Red')

	if (idhbb[0] ne -1) then begin
		plots, state.dhbb._raj2000[idhbb]/15.0,  state.dhbb._dej2000[idhbb], PSym=6, SymSize=2, $
			Color=color, /Data

		resultcoords=convert_coord(state.dhbb._raj2000[idhbb]/15.0,state.dhbb._dej2000[idhbb], /data, /double, /to_device)
		xyouts,resultcoords[0,*]+10, resultcoords[1,*]-10, 'HVC '+strcompress(state.dhbb.seq[idhbb], /remove_all), $
			color=color, /device
	endif
endif

;Load from 3D extractions
if viewdisp.Use3D EQ 1 then begin
	;modified to accept a larger width
	i3D=where(state.table3D.ra lt viewstate.ramax AND state.table3D.ra gt viewstate.ramin AND $
           state.table3D.dec lt viewstate.decmax AND state.table3D.dec gt viewstate.decmin AND $
           state.table3D.cz lt grid.velarr[lc] AND state.table3D.cz gt grid.velarr[uc])

	color = '0000FF'XL
	;color=FSC_Color('Red')
	
	if (i3D[0] ne -1) then begin
		plots, state.table3D.ra[i3D], state.table3D.dec[i3D], PSym=1, SymSize=2, Color=color, Thick=2.0, /Data
		
		resultcoords=convert_coord(state.table3D.ra[i3D],state.table3D.dec[i3D], /data, /double, /to_device)
		xyouts,resultcoords[0,*]-25, resultcoords[1,*]+10, strcompress(state.table3D.id[i3D], /remove_all), color=color, /device
	endif
endif

; Load in checklist.txt
if viewdisp.UseCk then begin
	; Find checklist.txt file, if it exists
	check=findfile('checklist.txt', count=count)
    	if (count eq 1) then begin
		; Read in data
		data=read_ascii('checklist.txt', delimiter=',')

		rahr=data.field1[0,*]
		decdeg=data.field1[1,*]
		vel=data.field1[2,*]
		width=data.field1[3,*]
		
		icheck=where(rahr lt viewstate.ramax AND rahr gt viewstate.ramin AND $
			decdeg lt viewstate.decmax AND decdeg gt viewstate.decmin AND $
			( vel lt (grid.velarr[lc]+1.2*width/2.0) AND vel gt (grid.velarr[uc]-1.2*width/2.0) ) )

		color = '0000FF'XL
		;color=FSC_Color('Red')

		if (icheck[0] NE -1) then $
			plots, rahr[icheck], decdeg[icheck], PSym=4, SymSize=2, Thick=2.0, Color=color, /Data
	endif
endif

; Strong continuum sources
if viewdisp.UseCt then begin
	;Peak ranges in Jy/beam
	peaklower=.25
	peakupper=1.0e6
	
	invss=where(state.nvsscat.ra_2000_ lt viewstate.ramax*15.0 AND state.nvsscat.ra_2000_ gt viewstate.ramin*15.0 AND $
		state.nvsscat.dec_2000_ lt viewstate.decmax AND state.nvsscat.dec_2000_ gt viewstate.decmin AND $
		state.nvsscat.peak_int ge peaklower AND state.nvsscat.peak_int lt peakupper ) 
	
	color = 'FFFFFF'XL
	;color=FSC_Color('White')
	
	if (invss[0] NE -1) then $
		plots,state.nvsscat[invss].ra_2000_/15.0, state.nvsscat[invss].dec_2000_ , $
			PSym=6,SymSize=2.0,Thick=2.0, Color=color, /Data
endif

device, decomposed=0

end



pro cleanview_jpeg, event

common cleanview_state
common gridstate

widget_control, viewstate.slider, get_value=chnstring

if NOT xregistered('cleanview_jpeg', /NoShow) then begin
	jpeg_output_base = widget_base(group_leader=viewstate.baseID, /row, /base_align_right, $
		title='CLEANview JPEG Output', uvalue = 'jpeg_output_base')
	configbase=widget_base(jpeg_output_base, /column, /align_left)
	startbase=widget_base(configbase, /row)
	label=widget_label(startbase,     value='Start Channel:    ')
	viewstate.frmsta=widget_text(startbase, xsize=8, value=string(chnstring[0], Format='(I4)'), /Editable, uvalue='start')
	numframesbase=widget_base(configbase, /row)
	label=widget_label(numframesbase, value='Number of Frames: ')
	viewstate.frmnum=widget_text(numframesbase, xsize=8, value='1', /Editable, uvalue='number')
	numstepsbase=widget_base(configbase, /row)
	label=widget_label(numstepsbase,  value='Number of steps:  ')
	viewstate.frmste=widget_text(numstepsbase, xsize=8, value='5', /Editable, uvalue='step')
	
	cd, current=pwd  ;Get current working directory into a string
	filesbase=widget_base(jpeg_output_base, /column, /align_left)
	directorybase=widget_base(filesbase, /Column)
	label=widget_label(directorybase, value='Output Directory:')
	viewstate.dir=widget_text(directorybase, xsize=40, value=pwd+'/', /Editable, uvalue='dir')
	buttonbase=widget_base(filesbase, xsize=100,ysize=100, /align_right, /column)
	jpeg_output_export = widget_button(buttonbase, value = ' Export ', $
		uvalue = 'export', event_pro='cleanview_jpeg_event')
	cancel=widget_button(buttonbase, value=' Cancel ', uvalue='cancel', $
					event_pro='cleanview_jpeg_event')
	
	widget_control, jpeg_output_base, /realize
	xmanager, 'cleanview_jpeg', jpeg_output_base, /no_block
endif

end




pro cleanview_jpeg_event, event

common cleanview_state
common gridstate
common clean

widget_control, event.id, get_uvalue = uvalue

case uvalue of 
	'export': begin
		widget_control, viewstate.slider, get_value=chnstring
		widget_control, viewstate.frmsta, get_value=starts
		widget_control, viewstate.frmnum, get_value=nums
		widget_control, viewstate.frmste, get_value=steps
		widget_control, viewstate.dir,    get_value=dir

		start = long(starts[0])
		num = long(nums[0])
		step = long(steps[0])
		stop=start+(num-1)*step

		;Beginning for each file
		widget_control, /Hourglass
		for channel=start, stop, step do begin
			thisDevice=!d.name
			set_plot, 'Z', /COPY
			
			Device, Set_Resolution=[700, 800], Z_Buffer=0
			Erase
						
			lowerchan=channel-step
			upperchan=channel+step
			if (lowerchan lt 0) then lowerchan=0
			if (upperchan gt n_elements(grid.velarr)-1) $
				then upperchan=n_elements(grid.velarr)-1
			
			filename='clean_vel_'+strcompress(long(grid.velarr[upperchan]), /remove_all)+'_'+$
				strcompress(long(grid.velarr[lowerchan]), /remove_all)+'.jpg'
			
			filename=dir+filename
			
			loadct, viewdisp.colortab, /silent
			to_disp = total( reform(cleand[lowerchan:upperchan, *, *]), 1)
			to_disp = to_disp / float(step+1)
			
			; Check display scaling and colorbar mapping
			if viewdisp.UseLin EQ 1 then begin
				to_disp = to_disp
			
				title_cb = 'Flux Density [mJy/beam]'
				format_cb = '(I4)'
				
				delta = max(to_disp) - min(to_disp)
				d_min = min(to_disp) + delta/5.0
				d_max = max(to_disp) - delta/5.0
			endif
			
			if viewdisp.UseLog EQ 1 then begin
				offset = min(to_disp)-(max(to_disp)-min(to_disp))*0.01
				to_disp = alog10(to_disp - offset)
			
				title_cb = 'Log Flux Density [log(mJy/beam)]'
				format_cb = '(F5.2)'
			
				delta = max(to_disp) - min(to_disp)
				d_min = min(to_disp) + delta/5.0
				d_max = max(to_disp) - delta/5.0
			endif
			
			if viewdisp.UseHeq EQ 1 then begin
				to_disp = hist_equal(to_disp, minv=min(to_disp), maxv=max(to_disp))
			
				title_cb = 'Flux Density [mJy/beam]'
				format_cb = '(I3)'
			
				delta = max(to_disp) - min(to_disp)
				d_min = min(to_disp) + delta/5.0
				d_max = max(to_disp) - delta/5.0
			endif
			
			if viewdisp.UseCons EQ 1 then begin
				d_min = -5.0
				d_max = 10.0
			endif
			
			xrange = [viewstate.ramax, viewstate.ramin]
			yrange = [viewstate.decmin, viewstate.decmax]
			plot, [0,0], /nodata, xrange=xrange, yrange=yrange, xstyle=1, ystyle=1, $
				xtick_get=xvals, ytick_get=yvals, ticklen=ticklen, charsize=1.0, $
				Position=[0.15,0.203,0.95,0.953]
			nxticklabels=n_elements(xvals)
			nyticklabels=n_elements(yvals)
			xspacing=((xvals[n_elements(xvals)-1]-xvals[0])*60.0)/(nxticklabels-1)
			yspacing=((yvals[n_elements(yvals)-1]-yvals[0])*60.0)/(nyticklabels-1)
			xticlabs=ratickname(xvals*15.0)
			yticlabs=dectickname(yvals)
			plot, [0,0], /nodata, xrange=xrange, yrange=yrange, $
				xtitle='Right Ascension (J2000)', ytitle='Declination (J2000)', $
				xstyle=1, ystyle=1, Position=[0.15,0.256,0.95,0.956], $
				xtickn=xticlabs, ytickn=yticlabs, ticklen=-0.01, charsize=1.0
			px = !X.WINDOW * !D.X_VSIZE
			py = !Y.WINDOW * !D.Y_VSIZE
			sx = px[1] - px[0] - 1
			sy = py[1] - py[0] - 1
			
			hor, viewstate.ramax, viewstate.ramin
			ver, viewstate.decmin, viewstate.decmax
			
			tv, reverse( bytscl(congrid(reform(to_disp), sx, sy), min=d_min, max=d_max) ), $
				px[0]+1, py[0]+2	

			infostring='Channels '+strcompress(lowerchan)+' to '+strcompress(upperchan)+ $
				'  Smoothed over -> '+string(grid.velarr[lowerchan],Format='(F7.1)')+$
				' to '+string(grid.velarr[upperchan],Format='(F7.1)')+' km/s'
			xyouts, 40, 140, infostring, /Device, charsize=1.0

			infostring='Clean Settings:'
			xyouts, 40, 110, infostring, /Device, CharSize=1.0

			infostring='Local Beam:'
			xyouts, 588, 110, infostring, /Device, CharSize=1.0

			flux_lim = max([cleanstate.flux, cleanstate.rms*cleanstate.sigma], type)
			flux_type = 'Flux'
			if type EQ 1 then flux_type = 'Sigma'
			infostring=' Grid RMS: '+string(cleanstate.rms, Format='(F4.2)')+' mJy    '+ $
				' Flux Limit: '+string(flux_lim, Format='(F5.2)')+' mJy     '+ $
				' Flux Limit Type: '+flux_type
			xyouts, 40, 90, infostring, /Device, charsize=0.9

			comb_chan = 'No'
			if cleanstate.allowsum EQ 1 then comb_chan = 'Yes'
			infostring=' Iteration Limit: '+string(cleanstate.niter, Format='(I5)')+'    '+ $
				'Channel Range: '+string(cleanstate.crange[0], Format='(I4)')+' to '+ $
				string(cleanstate.crange[1], Format='(I4)')+'     '+ $
				'Combine Channels: '+comb_chan
			xyouts, 40, 70, infostring, /Device, charsize=0.9

			beam_cont = cleanstate.beam / max(cleanstate.beam)
			beam_cont = 10.0*alog10(beam_cont)
			

			hor,-12,12
			ver,-12,12
			tvimage, bytscl(beam_cont, min=-24.0, max=0.0), Pos=[0.843,0.03,0.95,0.124], $
				/Minus_One
			plot, [0,0], /NoData, XRange=[-12,12], YRange=[-12,12], /NoErase, $
				Pos=[0.843,0.03,0.95,0.124], CharSize=0.75
			
			
			snapshot=tvrd()
			tvlct, r,g,b, /get
			device, Z_Buffer=1
			set_plot, thisDevice
				
			image24 = BytArr(3, 700, 800)
			image24[0,*,*] = r[snapshot]
			image24[1,*,*] = g[snapshot]
			image24[2,*,*] = b[snapshot]
			
			write_jpeg, filename, image24, true=1, quality=100
		endfor

		widget_control, event.top, /destroy
	end
	'cancel': begin
		widget_control, event.top, /destroy
	end
	else: 
endcase

end
