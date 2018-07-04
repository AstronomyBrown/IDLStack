pro beamview

; Information we need from cleanview and gridview
common cleanview_state
common gridstate
common clean

; Information we need only for beamview
common beamview_state, beamstate

; Define beamstate (beamview window)
beamstate = {baseID: 0L, beam_win: 0L, xval: 0L, yval: 0L, dval: 0L, $
	scaleLIN: 0L, scaleLOG: 0L, UseLog: 1, $
	colorBLU: 0L, colorGRN: 0L, colorRED: 0L, colorRAI: 0L, colorINV: 0L, colortab: 39, colorinvert: 0, $
	dir: 0L}

; Compute the center grid point of the selected region
xc = cleanstate.cx
yc = cleanstate.cy
; The beam patter is stored in
if total(cleanstate.beam) EQ 0 then begin
	widget_control, /Hourglass
	build_beam3, grid, [xc, yc], beam_out, /Silent, Output=log
	cleanstate.beam = beam_out
	cleanstate.beamlog = log
endif else begin
	beam_out = cleanstate.beam
	log = cleanstate.beamlog
endelse
; max(beam_out) -> 1
beam_out = beam_out / max(beam_out)
; String to display for the location of the central beam
out_posi = '('+string(xc,Format='(I3)')+' '+ $
	string(yc,Format='(I3)')+')'
; String to display for the location of the central beam
rac = grid.ramin + xc*grid.deltara/3600.0
	rac_h = fix(rac)
	rac_m = fix( (rac - rac_h)*60.0 )
	rac_s = rac*3600.0 - rac_h*3600.0 - rac_m*60.0
	rac = string(rac_h,Format='(I02)')+':'+string(rac_m,Format='(I02)')+ $
		':'+string(rac_s,Format='(F05.2)')
decc = grid.decmin + yc*grid.deltadec/60.0
	decc_d = fix(abs(decc))
	decc_m = fix( (abs(decc) - decc_d)*60.0 )
	decc_s = abs(decc)*3600.0 - decc_d*3600.0 - decc_m*60.0
	if decc LT 0 then decc_d = -decc_d
	decc = string(decc_d,Format='(I+03)')+':'+ $
		string(decc_m,Format='(I02)')+':'+ $
		string(decc_s,Format='(F05.2)')
out_posw = '('+rac+','+decc+')'
; Now figure out beam FWHM and PA
FWHM_pixs = where( beam_out GE 0.5 )
junk = fit_ellipse(FWHM_pixs,xsize=25,ysize=25,axes=beam_fwhm,$
	orientation=beam_pa)
out_beamf = string(beam_fwhm[0],Format='(F4.2)')+"' x "+$
	string(beam_fwhm[1],Format='(F4.2)')+"'"
out_beamp = string(90.0-beam_pa,Format='(F+6.1)')+' degrees'	

; Now for the window
beam_main_base = widget_base(group_leader=viewstate.baseID, Title='BEAMview', mbar=top_menu, $
	/Column, /Base_Align_Left)
beamstate.baseID = beam_main_base
filemenu = widget_button(top_menu, value=' File ')
	jpegbutton = widget_button(filemenu, value=' Export JPEG ', uvalue='jpeg', event_pro='beamview_jpeg')
	exitbutton = widget_button(filemenu, value=' Exit ', uvalue='close', /Separator)
colormenu = widget_button(top_menu, value=' Color ')
	beamstate.colorBLU = widget_button(colormenu, value=' Blue/White ',  uvalue='blue', /Checked_Menu)
	beamstate.colorGRN = widget_button(colormenu, value=' Green/White ', uvalue='green', /Checked_Menu)
	beamstate.colorRED = widget_button(colormenu, value=' Red/White ',   uvalue='red', /Checked_Menu)
	beamstate.colorRAI = widget_button(colormenu, value=' Rainbow ',     uvalue='rainbow', /Checked_Menu)
	beamstate.colorINV = widget_button(colormenu, value='Invert Colors', uvalue='invert', /Checked_Menu, /Separator)
scalingmenu = widget_button(top_menu, value=' Scaling ')
	beamstate.scaleLIN = widget_button(scalingmenu, value=' Linear ', uvalue = 'linear', /Checked_Menu)
	beamstate.scaleLOG = widget_button(scalingmenu, value=' Logarithmic ', uvalue = 'loga', /Checked_Menu)
helpmenu = widget_button(top_menu, Value=' Help ')
	aboutbutton = widget_button(helpmenu, value=' About ', uvalue='about')
	
beamstate.beam_win = widget_draw(beam_main_base, XSize=425, YSize=425, Frame=1, $
	Event_Pro='beamview_display_event', /Motion_Events, /Button_Events, /Align_Center)
beam_middle_base = widget_base(beam_main_base, /Row)
	beam_left_base = widget_base(beam_middle_base, Column=1, /Frame, /Align_Left)
		label = widget_label(beam_left_base, value='Detail: ', $
			/Align_Center)
		left_sub1 = widget_base(beam_left_base, /Row, /Align_Left)
			label = widget_label(left_sub1, value='Delta X:  ', /Align_Left)
			beamstate.xval = widget_label(left_sub1, value='----', /Align_Left)
		left_sub2 = widget_base(beam_left_base, /Row, /Align_Left)
			label = widget_label(left_sub2, value='Delta Y:  ', /Align_Left)
			beamstate.yval = widget_label(left_sub2, value='----', /Align_Left)
		left_sub3 = widget_base(beam_left_base, /Row, /Align_Left)
			label = widget_label(left_sub3, value='Strength [dB]: ', /Align_Left)
			beamstate.dval = widget_label(left_sub3, value='----  ', /Align_Left)
	beam_right_base = widget_base(beam_middle_base, Column=1, /Frame, /Align_Left)
		label = widget_label(beam_right_base, value='Properties: ', $
			/Align_Center)
		label = widget_label(beam_right_base, value='Center [px]:     '+out_posi, /Align_Left)
		label = widget_label(beam_right_base, value='Center [RA,Dec]: '+out_posw, /Align_Left)
		label = widget_label(beam_right_base, value='FWHM:            '+out_beamf, /Align_Left)
		label = widget_label(beam_right_base, value='PA:              '+out_beamp, /Align_Left)
label = widget_label(beam_main_base, value='build_beam3 Log: ', $
	/Align_Center)
label = widget_text(beam_main_base, value=log, /Scroll, YSize=10, XSize=65)
;beam_close = widget_button(beam_main_base, value='Close', uvalue='close')

widget_control, beam_main_base, /realize
xmanager, 'beamview', beam_main_base, /No_Block

widget_control, beamstate.colorRAI, Set_Button=1
beamstate.colortab = 39
widget_control, beamstate.scaleLOG, Set_Button=1
beamstate.UseLog = 1

beamview_update
end


pro beamview_display_event, event

common beamview_state
common clean
widget_control, beamstate.beam_win, get_value=index
wset, index
xdevice=event.x
ydevice=event.y
hor, -12.0, 12.0
ver, -12.0, 12.0
result=convert_coord(xdevice, ydevice, /Device, /Double, /To_Data)
xdata=result[0]
ydata=result[1]
if (xdata lt -12 OR xdata gt 12 OR ydata lt -12 OR ydata gt 12) then begin
	widget_control, beamstate.xval, set_value='----'
	widget_control, beamstate.yval, set_value='----'
	widget_control, beamstate.dval, set_value='----'
endif else begin
	xpix = round( xdata + 12.0 )
	ypix = round( ydata + 12.0 )
	dval = 10.0d * alog10(cleanstate.beam[xpix,ypix] / max(cleanstate.beam))
	widget_control, beamstate.xval, set_value=string(xdata,Format='(I3)')
	widget_control, beamstate.yval, set_value=string(ydata,Format='(I3)')
	widget_control, beamstate.dval, set_value=string(dval,Format='(F+6.2)')
endelse
end


pro beamview_event, event

common cleanview_state
common beamview_state

widget_control, event.id, get_uvalue=uvalue, get_value=value
to_change = 1
case uvalue of
	'linear': begin
		if beamstate.UseLog NE 0 then begin
			beamstate.UseLog = 0
			widget_control, beamstate.scaleLIN, Set_Button=1
			widget_control, beamstate.scaleLOG, Set_Button=0
			beamview_update
		endif
	end
	'loga': begin
		if beamstate.UseLog NE 1 then begin
			beamstate.UseLog = 1
			widget_control, beamstate.scaleLIN, Set_Button=0
			widget_control, beamstate.scaleLOG, Set_Button=1
			beamview_update
		endif
	end

	'blue': begin
		if beamstate.colortab NE 1 then begin
			beamstate.colortab = 1
			widget_control, beamstate.colorBLU, Set_Button=1
			widget_control, beamstate.colorGRN, Set_Button=0
			widget_control, beamstate.colorRED, Set_Button=0
			widget_control, beamstate.colorRAI, Set_Button=0
			beamview_update
		endif
	end
	'green': begin
		if beamstate.colortab NE 8 then begin
			beamstate.colortab = 8
			widget_control, beamstate.colorBLU, Set_Button=0
			widget_control, beamstate.colorGRN, Set_Button=1
			widget_control, beamstate.colorRED, Set_Button=0
			widget_control, beamstate.colorRAI, Set_Button=0
			beamview_update
		endif
	end
	'red': begin
		if beamstate.colortab NE 3 then begin
			beamstate.colortab = 3
			widget_control, beamstate.colorBLU, Set_Button=0
			widget_control, beamstate.colorGRN, Set_Button=0
			widget_control, beamstate.colorRED, Set_Button=1
			widget_control, beamstate.colorRAI, Set_Button=0
			beamview_update
		endif
	end
	'rainbow': begin
		if beamstate.colortab NE 39 then begin
			beamstate.colortab = 39
			widget_control, beamstate.colorBLU, Set_Button=0
			widget_control, beamstate.colorGRN, Set_Button=0
			widget_control, beamstate.colorRED, Set_Button=0
			widget_control, beamstate.colorRAI, Set_Button=1
			beamview_update
		endif
	end
	'invert': begin
		if beamstate.colorinvert EQ 1 then begin
			beamstate.colorinvert = 0
			widget_control, beamstate.colorINV, Set_Button=0
		endif else begin
			beamstate.colorinvert = 1
			widget_control, beamstate.colorINV, Set_Button=1
		endelse
		beamview_update
	end

	'about': begin
		h = ['CleanView - Graphical beam utility        ', $
		     '  Written, November 2007', $
		     ' ', $
		     '  Last update, Tuesday, March 18, 2008']
		
		if NOT xregistered('beamview_help', /noshow) then begin
			about_base =  widget_base(group_leader=beamstate.baseID, title='About BeamView', $
				/Column, /Base_Align_Right, uvalue = 'about_base')
			about_text = widget_text(about_base, /Scroll, value = h, xsize = 45, ysize = 10)
			about_done = widget_button(about_base, value = ' Done ', uvalue = 'about_done', $
				event_pro='beamview_event')
			
			widget_control, about_base, /realize
			xmanager, 'beamview_help', about_base, /no_block
		endif
	end
	'about_done': begin
		widget_control, event.top, /destroy
	end

	'close': begin
		widget_control, event.top, /destroy
		
		hor
		ver
		loadct,1,/Silent
		device, decomposed=0

		delvarx, beamstate

		widget_control, viewstate.baseID, /sensitive
		
		print, 'Exiting BeamView...'
	end
	else:
endcase
end



pro beamview_update

common cleanview_state
common beamview_state
common clean

widget_control, beamstate.beam_win, get_value=index
wset,index

beam_cont = cleanstate.beam / max(cleanstate.beam)
beam_cont = 10.0*alog10(beam_cont)

beam_min = -24.0
beam_max =  00.0
beam_disp = beam_cont
if beamstate.UseLog NE 1 then begin
	beam_min = 0.005
	beam_max = 0.90
	beam_disp = cleanstate.beam / max(cleanstate.beam)
endif

hor,-12.0,12.0
ver,-12.0,12.0

loadct,beamstate.colortab,/Silent
offset = 0B
if beamstate.colorinvert EQ 1 then begin
	tvlct, r, g, b, /Get
	tvlct, Reverse(r), Reverse(g), Reverse(b)
endif

tvimage, bytscl(beam_disp, min=beam_min, max=beam_max), Pos=[0.15,0.15,0.95,0.95], $
	/Minus_One

if beamstate.colorinvert EQ 1 then begin
	tvlct, r, g, b, /Get
	tvlct, Reverse(r), Reverse(g), Reverse(b)
endif

contour, beam_cont, levels=[-21, -18, -15, -12, -9, -6, -3], $
	c_labels=[1, 1, 1, 1, 1, 1, 1], Position=[0.15,0.15,0.95,0.95], $
	XTitle='X Offset [arc min]', YTitle='Y Offset [arc min]', $
	XRange=[0,24],YRange=[0,24],XStyle=5,YStyle=5, /NoErase

plot,[0,0], /NoData, XRange=[-12,12],XStyle=1,YRange=[-12,12],YStyle=1, $
	XTitle='X Offset [arc min]', YTitle='Y Offset [arc min]', $
	Position=[0.15,0.15,0.95,0.95], /NoErase

end



pro beamview_jpeg, event

common cleanview_state
common beamview_state
common clean

if NOT xregistered('beamview_jpeg', /NoShow) then begin
	jpeg_output_base =  widget_base(group_leader=beamstate.baseID, /Column, /Base_Align_Right, $
		Title = 'BEAMview JPEG Output', uvalue = 'jpeg_output_base')
	
	cd, current=pwd  ;Get current working directory into a string
	filesbase=widget_base(jpeg_output_base, /Column, /Align_Left)
	directorybase=widget_base(filesbase, /Column)
	label=widget_label(directorybase, value='Output Directory: ', /Align_Left)
	beamstate.dir=widget_text(directorybase, xsize=40, value=pwd+'/', /Editable, $
		uvalue='directory')
	
	buttonbase=widget_base(filesbase, /Align_Right, /Row)
	jpeg_output_export = widget_button(buttonbase, value = ' Export ', $
		uvalue = 'export', event_pro='beamview_jpeg_event')
	cancel=widget_button(buttonbase, value=' Cancel ', uvalue='cancel', $
		event_pro='beamview_jpeg_event')
	
	widget_control, jpeg_output_base, /realize
	xmanager, 'beamview_jpeg', jpeg_output_base, /no_block 
endif
end



pro beamview_jpeg_event, event

common cleanview_state
common beamview_state
common gridstate
common clean

widget_control, event.id, get_uvalue = uvalue

case uvalue of
	'export': begin
		widget_control, beamstate.dir, get_value=dir
		widget_control, beamstate.beam_win, get_value=index

		widget_control, /Hourglass

		filename = 'beam_'+strcompress(grid.name)+ $
			'_'+string(cleanstate.cx, Format='(I03)')+ $
			'_'+string(cleanstate.cy, Format='(I03)')+'.jpg'
		filename = dir+filename

		thisDevice = !D.Name
   		set_plot, 'Z', /Copy
		device, set_resolution=[700,700], Z_Buffer=0
		erase
		
		beam_cont = cleanstate.beam / max(cleanstate.beam)
		beam_cont = 10.0*alog10(beam_cont)
		
		beam_min = -24.0
		beam_max =  00.0
		beam_disp = beam_cont
		if beamstate.UseLog NE 1 then begin
			beam_min = 0.005
			beam_max = 0.90
			beam_disp = cleanstate.beam / max(cleanstate.beam)
		endif
		
		hor,-12.0,12.0
		ver,-12.0,12.0
		
		loadct,beamstate.colortab,/Silent
		offset = 0B
		if beamstate.colorinvert EQ 1 then begin
			tvlct, r, g, b, /Get
			tvlct, Reverse(r), Reverse(g), Reverse(b)
		endif
		
		tvimage, bytscl(beam_disp, min=beam_min, max=beam_max), Pos=[0.15,0.15,0.95,0.95], $
			/Minus_One
		
		if beamstate.colorinvert EQ 1 then begin
			tvlct, r, g, b, /Get
			tvlct, Reverse(r), Reverse(g), Reverse(b)
		endif
		
		contour, beam_cont, levels=[-21, -18, -15, -12, -9, -6, -3], $
			c_labels=[1, 1, 1, 1, 1, 1, 1], Position=[0.15,0.15,0.95,0.95], $
			XTitle='X Offset [arc min]', YTitle='Y Offset [arc min]', $
			XRange=[0,24],YRange=[0,24],XStyle=5,YStyle=5, /NoErase
		
		plot,[0,0], /NoData, XRange=[-12,12],XStyle=1,YRange=[-12,12],YStyle=1, $
			XTitle='X Offset [arc min]', YTitle='Y Offset [arc min]', $
			Position=[0.15,0.15,0.95,0.95], /NoErase
		
		snapshot = tvrd()
   		tvlct, r, g, b, /Get
  		device, Z_Buffer=1
  		set_plot, thisDevice
		
		image24 = BytArr(3, 700, 700)
		image24[0,*,*] = r[snapshot]
		image24[1,*,*] = g[snapshot]
		image24[2,*,*] = b[snapshot]
		write_jpeg, filename, image24, true=1, quality=100

		widget_control, event.top, /destroy
	end

	'cancel': widget_control, event.top, /destroy
	else: 
endcase

end
