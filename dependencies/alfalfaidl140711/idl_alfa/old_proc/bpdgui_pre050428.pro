;+
; NAME:  
;       BPDGUI
; PURPOSE:
;       GUI interface for bandpass calibration for ALFALFA drift data
;
; EXPLANATION:
;       BPDGUI adds a window interface to the bandpass calibration process.  It allows
;         information to be displayed to the user, including coordinates for the
;         beams, calibration information and plots.  A list of files to process 
;	  and a calibration structure (ncalib) are provided by the user.  dred
;         structures are written to disk
;
; CALLING SEQUENCE:
;       bpdgui
;
; INPUTS:
;       None at command line
;
;       
; OPTIONAL INPUT:
;      
;
; OPTIONAL INPUT KEYWORD:
;    
;
; OUTPUTS:
;       dhhmmss-ddmmss.scannumber.sav file for each sssssssss.sav file in list
;       
;
; RESTRICTIONS:
;       Opens *.list list files containg files to process
;       uses *.sav files with d structures in IDL format from ALFALFA and ncalib
;        structures in ncalib.sav files
;       Makes use of the following outside procedures for the bp calibration:
;       bpc.pro 
;	bpd.pro 
;	chdoppler.pro
;	hans.pro
;	make_caldrift.pro
;
; EXAMPLE:
;
;	
;
; PROCEDURES USED:
;         BPDGUI_INITCOMMON.
;         BPDGUI_EXIT.
;         BPDGUI_OPENSAVFILE.
;         BPDGUI_COORD.
;         BPDGUI_GET_STATE.
;         BPDGUI_SET_STATE.
;         BPDGUI_PROCESSBP.
;         BPDGUI_OPENNCALIBFILE.
;         BPDGUI_EVENT.
;         RADECCONVERT.
;         BPDGUI_PLOTCRATS.
;         BPDGUI_PLOTTSYS.
;         BPDGUI_BUTTONSELECT
;         BPDGUI_CALMASKSELECT.
;         BPDGUI.
;	  BPDGUI_OPENFILELIST.
;         BPDGUI_CHOOSEINTERP.
;         BPDGUI_CHOOSEINTERP_EVENT.
;         Uses STRINGAD from IDL Astro User's Library
;         HOR.  See pjp AO library
;         VER.  See pjp AO library
;
;       
;
; MODIFICATION HISTORY:
;       WRITTEN, B. Kent, Cornell U.,  January 15, 2005,  IDL 6.0
;       Jan 25 2005  RADECCONVERT added to make coords to string conversion easier
;       Jan 31 2005  Added functionality for bpd.pro and bandpass calibration
;       Mar 03 2005  Added ability to process list of files/update display
;       Mar 15 2005  Program was sent to Twilight zone - 
;                     ask B.K. about this if you dare.
;       Mar 18 2005  Last update 
;       Mar 21 2005  Reworked initialization, finished HIchns
;                    selection, reworked button event tools - more streamlined!
;	Mar 24 2005  Changed default horizontal display for the chooseinterp procedures
;-
;-----------------------------------------------------------------------
; Initialize any needed common blocks
pro bpdgui_initcommon

common bpdgui_info, info

;Create info structure for state information, and create info pointer
info={scantext:0L, $
       driftstarttext:0L, $
       driftstoptext:0L, $
       infocoordbeamselect:0L, $
       rastarttext:0L, $
       rastoptext:0L, $
       dectext:0L, $
       beampolstatus:intarr(2,8), $
       usecratmed:0L, $
       usecratfit:0L, $
       usecurrentcalsession:0L, $
       newcalsession:0L, $
       usecurrentcalsessionfile:0L, $
       newcalsessionfile:0L, $
       ncalibfiletext:0L, $
       ncalibdatetext:0L, $
       ncalibstarttimetext:0L, $
       ncalibstoptimetext:0L, $
       tcals:intarr(2,8), $
       medCrat:intarr(2,8), $
       medTsys:intarr(2,8), $
       ncalib2pol:intarr(2), $
       ncalib2beamselect:0L, $
       ncalibcalmaskpol:intarr(2),$
       ncalibcalmaskbeamselect:0L, $
       ncalib2currentpol:0L, $ 
       ncalibcurrentcalmaskpol:0L, $
       cratcurrent:0L, $
       calsessionselect:0L, $
       poswhatselect:0L, $
       cregionwindow:0L, $
       filenamelist:0L, $
       unprocessedlist:strarr(100), $
       numunprocessedlist:0L, $
       unprocesseddisplaylist:0L, $
       unprocessedlistlabel:0L, $
       processedlistlabel:0L, $
       processedlist:strarr(100), $
       processeddisplaylist:0L, $
       numprocessedlist:0L, $
       baseID:0L, $
       usecurrentposwhatfile:0L, $
       newposwhatfile:0L, $
       interp_reg:intarr(100), $
       chooseinterpdraw:0L, $
       totalspectrum:fltarr(4096), $
       chooseinterpdrawlabel:0L}

end


;-----------------------------------------------------------------------
;Exit event handler - clear up any stray pointers, and restore plotting defaults
pro bpdgui_exit, event

    common bpdgui_info
    
    widget_control, info.filenamelist, get_uvalue=dptr
    widget_control, info.ncalibfiletext, get_uvalue=ncalibptr
  
    print, "Returning system resources, restoring defaults..."

    if (ptr_valid(dptr) eq 1) then ptr_free, dptr
    if (ptr_valid(ncalibptr) eq 1) then ptr_free, ncalibptr 

    delvarx, info
    delvarx, d

    hor   ;Requires pjp AO libraries
    ver   ;Requires pjp AO libraries

    widget_control, event.top, /destroy
end

;-----------------------------------------------------------------------
;Open file for processing
pro bpdgui_opensavfile, filename

common bpdgui_info

   ;restore file and display information in GUI
   if(filename ne '') then begin
     restore, filename
     widget_control, info.scantext, set_value=strcompress(d[0,0,0].h.std.scannumber, /remove_all)
     widget_control, info.driftstarttext, set_value=strcompress(d[0,0,0].h.std.time, /remove_all)
     widget_control, info.driftstoptext, set_value=strcompress(d[0,n_elements(d[0,*,0])-1,0].h.std.time, $
       /remove_all)

     radecconvert, d[0,0,0].rahr, d[0,0,0].decdeg, rastring, decstring
       widget_control, info.rastarttext, set_value=rastring
     radecconvert, d[0,n_elements(d[0,*,0])-1,0].rahr, d[0,0,0].decdeg, rastring, decstring
       widget_control, info.rastoptext, set_value=rastring
       widget_control, info.dectext, set_value=decstring  
     widget_control, info.infocoordbeamselect, set_droplist_select=0 ;set to beam 0


  ;Set pointer for d structure, if not already made
     widget_control, info.filenamelist, get_uvalue=dptr
     if (ptr_valid(dptr) eq 1) then ptr_free, dptr
     dptr=ptr_new(d)
     widget_control, info.filenamelist, set_uvalue=dptr

     delvarx, d


   endif
      
end

;-------------------------------------------------------------------------
;Open list of files to process
pro bpdgui_openfilelist, event

common bpdgui_info

   filters=['*.list']
   filename=dialog_pickfile(/read, filter=filters)

   ;restore file and display information in GUI
   if(filename ne '') then begin
     widget_control, event.top, hourglass=1
     widget_control, info.filenamelist, set_value=filename

        ;Open list of files to process, place file names in string array
        openr,lun,filename,/get_lun
	maxfiles=100
        templist=strarr(maxfiles)
        ifound=0L
        on_ioerror,done
	       
	while (1) do begin
	  inpline=''
  	  readf,lun,inpline
	  strar=strsplit(inpline,' ',/extract)
	  templist[ifound]=strtrim(strar[0],2)
	  ifound=ifound+1
        end
	done:
	close, lun
	free_lun,lun
	templist=templist[0:ifound-1]  ; trim list to number of files found
	info.unprocessedlist=templist
	info.numunprocessedlist=ifound

	widget_control, info.unprocesseddisplaylist, set_value=info.unprocessedlist[0:info.numunprocessedlist-1]
	widget_control, info.unprocessedlistlabel, set_value=strcompress(ifound, /remove_all)+ ' unprocessed files'
	widget_control, info.unprocesseddisplaylist, set_list_select=0
 	
        bpdgui_opensavfile, info.unprocessedlist[0]

	strmessage=strcompress(ifound, /remove_all)+' files ready for processing.'
        result=dialog_message(strmessage, /information)

     widget_control, event.top, hourglass=0


   endif

	  
end

;-------------------------------------------------------------------------
;Get coordinate based on beam chosen
pro bpdgui_coord, event


   common bpdgui_info
   
   widget_control, info.filenamelist, get_value=filename

   if(filename eq '') then begin
     result=dialog_message('Please open an *.list file for processing.', /information)
   endif else begin   
     widget_control, info.filenamelist, get_uvalue=dptr
     d=*dptr

     radecconvert, d[0,0,event.index].rahr, d[0,0,event.index].decdeg, rastring, decstring
        widget_control, info.rastarttext, set_value=rastring
     radecconvert, d[0,n_elements(d[0,*,0])-1, event.index].rahr, d[0,0,event.index].decdeg, rastring, decstring
        widget_control, info.rastoptext, set_value=rastring
        widget_control, info.dectext, set_value=decstring 
   endelse

   delvarx, d

end

;------------------------------------------------------------------------
;Begin bandpass calibration
pro bpdgui_processbp, event

start_time=systime(1)


   common bpdgui_info

    widget_control, info.filenamelist, get_value=filenamelist
    widget_control, info.ncalibfiletext, get_value=ncalibfilename

      ;Check that appropriate files have been opened
    if(filenamelist eq '' or ncalibfilename eq '') then begin
        result=dialog_message('Please open an *.list AND ncalib file for processing.', /information)
    endif else begin   

	  if (info.calsessionselect ne 0) then widget_control, info.calsessionselect, get_value=calsessionselect
          if (info.cratcurrent ne 0) then widget_control, info.cratcurrent, get_value=cratcurrent
          if (info.poswhatselect ne 0) then widget_control, info.poswhatselect, get_value=poswhatselect

	  if (info.calsessionselect eq 0) then calsessionselect='Start New Calsession, File:'
          if (info.cratcurrent eq 0) then cratcurrent='Use CRAT median'
          if (info.poswhatselect eq 0) then poswhatselect='Start New runpos, File:'

          nbeams=7
          npols=2
          brdstat=bytarr(2,8)+1

	  ;Find any flagged boards       
          for i=0, npols-1 do begin
            for j=0, nbeams-1 do begin
              widget_control, info.beampolstatus[i,j], get_uvalue=beampolstatus
                if (beampolstatus ne '1') then brdstat[i,j]=0
	    endfor
          endfor

          if (calsessionselect eq 'Append to Calsession, File:') then begin
		calwhat='append'
		widget_control, info.usecurrentcalsessionfile, get_value=calsessionfilename
		restore, calsessionfilename
	  endif

          if (calsessionselect eq 'Start New Calsession, File:') then calwhat='new'

          if (poswhatselect eq 'Append to runpos, File:') then begin
		poswhat='append'
		widget_control, info.usecurrentposwhatfile, get_value=poswhatfilename
		restore, poswhatfilename
	  endif

          if (poswhatselect eq 'Start New runpos, File:') then poswhat='new'


	  if (cratcurrent eq 'Use CRAT median') then crat='median'
	  if (cratcurrent eq 'Use CRAT fit') then crat='fit'
	  ;  Need to find where this crat option is used in bpd...
 
	for ifile=0, info.numunprocessedlist-1 do begin   
	  widget_control, info.unprocesseddisplaylist, set_list_select=ifile
	  filename=info.unprocessedlist[ifile]
	  widget_control, event.top, hourglass=1
	  bpdgui_opensavfile, filename
	  widget_control, event.top, hourglass=0

  	  widget_control,info.filenamelist, get_uvalue=dptr
          d=*dptr

          widget_control, info.ncalibfiletext, get_uvalue=ncalibptr
          ncalib=*ncalibptr
  
          interp_reg=info.interp_reg[where(info.interp_reg ne 0)]
          print, interp_reg
          ;calls bpd - written by RG
           bpd, d, ncalib, brdstat=brdstat, calwhat=calwhat, poswhat=poswhat, $
                force_interp=1, interp_reg=interp_reg, $
		calsession=calsession, runpos=runpos, fileout=fileout      
 
	  ;write calsession and runpos to file - start new OR append old
	   
	   if (calwhat eq 'new') then begin
		widget_control, info.newcalsessionfile, get_value=calsessionfilename
		save, calsession, filename=calsessionfilename
	   endif

	   if (calwhat eq 'append') then begin
		save, calsession, filename=calsessionfilename
	   endif

	   if (poswhat eq 'new') then begin
		widget_control, info.newposwhatfile, get_value=poswhatfilename
		save, runpos, filename=poswhatfilename
	   endif

	   if (poswhat eq 'append') then begin
		save, runpos, filename=poswhatfilename
	   endif
		

          ;Update processed list
	  info.processedlist[ifile]=fileout
	  widget_control, info.processeddisplaylist, set_value=info.processedlist[0:ifile]
	  widget_control, info.processeddisplaylist, set_list_select=ifile
   
	  ;After the first file is processed, the calsession and position structures
	  ;  should be appended
	  calwhat='append'
	  poswhat='append'

 	endfor

   endelse

end_time=systime(1)


result=dialog_message('Total time: '+strcompress((end_time-start_time)/60.0, /remove_all)+' minutes', /information)

delvarx, d

end

;-----------------------------------------------------------------------
pro bpdgui_openncalibfile, event

;Get state information
    common bpdgui_info

 filters=['*ncalib.sav']
   filename=dialog_pickfile(/read, filter=filters)

   ;restore file and display information in GUI
   if(filename ne '') then begin
     widget_control, event.top, hourglass=1
     restore, filename
     widget_control, info.ncalibfiletext, set_value=filename
     widget_control, info.ncalibdatetext, set_value=strcompress(ncalib.date, /remove_all)
     widget_control, info.ncalibstarttimetext, set_value=strcompress(ncalib.startime, /remove_all)
     widget_control, info.ncalibstoptimetext, set_value=strcompress(ncalib.stoptime, /remove_all)
     
     for i=0,1 do begin
        for j=0,6 do begin
           widget_control, info.tcals[i,j], set_value=strcompress(ncalib.calvals[i,j], /remove_all)
           widget_control, info.medCrat[i,j], set_value=strcompress(ncalib.crat[i,j,0], /remove_all)
           widget_control, info.medTsys[i,j], set_value=strcompress(ncalib.tsys[i,j,0], /remove_all)
        endfor
     endfor
 
     ;Plot masked regions for selected beam and pol
     widget_control, info.cregionwindow, get_value=index
       wset, index
       device, retain=2
       chanvals=[ncalib.cregions[0,0,where(ncalib.cregions[0,0,*] ne 0)]]      
       mask=fltarr(4096,4)
       for i=0,n_elements(chanvals)-2,2 do begin
         mask[chanvals[i]:chanvals[i+1],*]=1
       endfor
        loadct, 11, /silent
        !p.position=[0.01,0.2,0.98,0.83]
        contour, mask, /fill, nlevels=1, title='Beam 0  Pol A'  ;Default plot
        loadct, 0, /silent

     widget_control, info.ncalibcalmaskbeamselect, set_droplist_select=0 ;set to beam 0

     widget_control, info.ncalibfiletext, get_uvalue=ncalibptr
     if (ptr_valid(ncalibptr) eq 1) then ptr_free, ncalibptr
     ncalibptr=ptr_new(ncalib)
     widget_control, info.ncalibfiletext, set_uvalue=ncalibptr

     widget_control, event.top, hourglass=0
   endif


end

;---------------------------------------------------------------------
;Default for non-useable buttons or buttons without a home  :)
pro bpdgui_event, event

end

;---------------------------------------------------------------------
;RA dec conversion - takes ra in decimal hours, and dec in decimal degrees
;                    and converts to strings

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

;---------------------------------------------------------------------
;plot Crats info from the ncalib structure

pro bpdgui_plotCrats, event

;Get state information
    common bpdgui_info

 widget_control, info.ncalibfiletext, get_value=filename

   if(filename eq '') then begin
     result=dialog_message('Please open an ncalib.sav file for viewing.', /information)
   endif else begin   
     widget_control, info.ncalibfiletext, get_uvalue=ncalibptr
     ncalib=*ncalibptr
  widget_control, event.top, hourglass=1
     ;Get the beam and pol selections
     ;Cool trick from D.Fanning's website!
      currentindex = widget_info(info.ncalib2beamselect, /DropList_Select)
      widget_control, info.ncalib2beamselect, get_uvalue=beamvalues

      if (info.ncalib2currentpol eq 0) then pol='Pol A   '
      if (info.ncalib2currentpol ne 0) then widget_control, info.ncalib2currentpol, get_value=pol
        if (pol eq 'Pol A   ') then polval=0
        if (pol eq 'Pol B') then polval=1      

      ;Use mpi_plot from D.Fanning
      mpi_plot, ncalib.crat[polval,currentindex,*], $
          xtitle='Rec', ytitle='Crats [Kelvins]', title='Crats plot   Beam '+strcompress(currentindex, /remove_all)+ ' ' + pol, color='Black', $
          datacolor='Green'
      widget_control, event.top, hourglass=0
   endelse



end

;--------------------------------------------------------------------------
;plot Tsys info from the ncalib structure

pro bpdgui_plotTsys, event

;Get state information
    common bpdgui_info

 widget_control, info.ncalibfiletext, get_value=filename

   if(filename eq '') then begin
     result=dialog_message('Please open an ncalib.sav file for viewing.', /information)
   endif else begin   
     widget_control, info.ncalibfiletext, get_uvalue=ncalibptr
     ncalib=*ncalibptr
    widget_control, event.top, hourglass=1
     ;Get the beam and pol selections
     ;Cool trick from D.Fanning's website!
      currentindex = widget_info(info.ncalib2beamselect, /DropList_Select)
      widget_control, info.ncalib2beamselect, get_uvalue=beamvalues

      if (info.ncalib2currentpol eq 0) then pol='Pol A   '
      if (info.ncalib2currentpol ne 0) then widget_control, info.ncalib2currentpol, get_value=pol
        if (pol eq 'Pol A   ') then polval=0
        if (pol eq 'Pol B') then polval=1      

      ;Use mpi_plot from D.Fanning
      mpi_plot, ncalib.tsys[polval,currentindex,*], $
          xtitle='Rec', ytitle='Tsys[Kelvins]', title='Tsys plot  Beam '+strcompress(currentindex, /remove_all)+ ' ' + pol, color='Black', $
          datacolor='Red'
       widget_control, event.top, hourglass=0
   endelse



end

;------------------------------------------------------------------
; Used to handle all exclusive button decisions within the GUI

pro bpdgui_buttonselect, event

common bpdgui_info

widget_control, event.ID, get_uvalue=uvalue

case uvalue of

   'ncalib2pol':       info.ncalib2currentpol = event.ID
   'ncalibcalmaskpol': info.ncalibcurrentcalmaskpol = event.ID
   'cratcurrent':      info.cratcurrent = event.ID
   'calsessionselect': info.calsessionselect = event.ID
   'poswhatselect':    info.poswhatselect = event.ID

endcase

end

;------------------------------------------------------------------
;Allows user to flag a bad board
pro bpdgui_beampolstatus, event
  
    common bpdgui_info
    widget_control, event.ID, get_uvalue=status
    if (status eq '1') then begin
        widget_control, event.ID, set_uvalue=0
    endif else begin
        widget_control, event.ID, set_uvalue=1
    endelse
    
	widget_control, event.ID, get_uvalue=status
	print, status

end

;------------------------------------------------------------------
;User selects beam and pol for the calmask.  The appropriate mask is
;  displayed on a channel plot

pro bpdgui_calmaskselect, event

;Get state information
    common bpdgui_info

    widget_control, info.ncalibfiletext, get_value=filename

    if(filename eq '') then begin
      result=dialog_message('Please open an ncalib.sav file for viewing.', /information)
    endif else begin
 
    widget_control, info.ncalibfiletext, get_uvalue=ncalibptr
    ncalib=*ncalibptr 
    
    if (info.ncalibcurrentcalmaskpol eq 0) then begin
       polval=0
       pol='Pol A   '
    endif else begin
        widget_control, info.ncalibcurrentcalmaskpol, get_value=pol
        if (pol eq 'Pol A   ') then polval=0
        if (pol eq 'Pol B') then polval=1      
    endelse

     ;Plot masked regions for selected beam and pol
     widget_control, info.cregionwindow, get_value=index
       wset, index
       device, retain=2
       chanvals=[ncalib.cregions[polval,event.index,where(ncalib.cregions[polval,event.index,*] $
                  ne 0)]]      
       mask=fltarr(4096,4)
       for i=0,n_elements(chanvals)-2,2 do mask[chanvals[i]:chanvals[i+1],*]=1
        loadct, 11, /silent
        !p.position=[0.01,0.2,0.98,0.83]
        contour, mask, /fill, nlevels=1, title='Beam ' +strcompress(event.index, /remove_all)+$
            ' '+pol
        loadct, 0, /silent

    endelse


end

;--------------------------------------------------------------------
;   Select interp mask for interpolation

pro bpdgui_chooseinterp, event

   common bpdgui_info

   widget_control, info.filenamelist, get_value=filenamelist
   widget_control, info.ncalibfiletext, get_value=ncalibfilename

    if(filenamelist eq '' or ncalibfilename eq '') then begin
     result=dialog_message('Please open an *.list AND ncalib file for processing.', /information)
    endif else begin
 
      if (not (xregistered('bpdgui_chooseinterp', /noshow))) then begin

       chooseinterpbase =  widget_base(group_leader = info.baseID, /column, /base_align_right, $
                     title = 'Choose Interpolation regions')
       
       info.chooseinterpdraw=widget_draw(chooseinterpbase, xsize=3000, ysize=800, uvalue='chooseinterp_draw', /button_events, /scroll, x_scroll_size=800, y_scroll_size=400)

       bottombase=widget_base(chooseinterpbase, /row, /base_align_right)
         labelbase=widget_base(chooseinterpbase, /column, /base_align_right)
         info.chooseinterpdrawlabel=widget_label(labelbase, $
            value='  Click on the above spectrum to chose the regions to interpolate over,')
         info.chooseinterpdrawlabel=widget_label(labelbase, $
            value=' or Click Default (defaults not defined yet)  ')
         info.chooseinterpdrawlabel=widget_label(labelbase, $
            value=' Use the scroll bars to examine the entire bandpass.  ')
         chooseinterp_reset=widget_button(bottombase, value= ' Reset ', uvalue='chooseinterp_reset')
         chooseinterp_default=widget_button(bottombase, value= ' Default ', uvalue='chooseinterp_default')
         chooseinterp_done = widget_button(bottombase, value = ' Done ', uvalue = 'chooseinterp_done')

       ;Realization
       widget_control, chooseinterpbase, /realize
       xmanager, 'bpdgui_chooseinterp', chooseinterpbase, /no_block
   endif
      info.interp_reg=intarr(100)

      widget_control,info.filenamelist, get_uvalue=dptr
      d=*dptr
      nbeams=7

      for i=0,nbeams-1 do begin
	info.totalspectrum+=total(reform(d[0,*,i].d),2)
      endfor

      widget_control, info.chooseinterpdraw, get_value=index
      wset, index     

      !p.position=[0.1,0.1,0.97,0.97]
      hor, 0,4095
      ver, min([info.totalspectrum[3300:3400],info.totalspectrum[300:400]]) $
                  -300.0, max(info.totalspectrum)
      
      plot, info.totalspectrum, xtitle='Channel', ytitle='Intensity of totaled spectra', charsize=1.2, ticklen=0.01
    endelse
    delvarx, d


end

;-----------------------------------------------------------------
; Default exit event handler for the interpolation window
pro bpdgui_chooseinterp_event, event

common bpdgui_info

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'chooseinterp_done': begin
        hor
        ver
        widget_control, event.top, /destroy
     end

    'chooseinterp_draw': begin
       if (event.press gt 0) then begin

         ;info.interp_reg=intarr(100)
          
;	 mapping from screen pixels to spectral channels - only works for this window
;        BK needs to generalize this - might be useful in future
;         m=4096.0/(776.0-80.0)
;         b=-m*80.0
;         print, round(m*(event.x)+b)
      ;NOTE:  USE COVERT_COORD INSTEAD!!
          ;print, convert_coord(event.x, event.y, /device, /to_data)     
         loc=where(info.interp_reg eq 0)
;         info.interp_reg[loc[0]]=round(m*(event.x)+b)
          xy=convert_coord(event.x, event.y, /device, /to_data)
          
         info.interp_reg[loc[0]]=xy[0]
         ;print, xy[0]
         ;print, info.interp_reg
         if (n_elements(where(info.interp_reg ne 0)) mod 2 eq 0) then begin
           widget_control, info.chooseinterpdraw, get_value=index
           wset, index     
           !p.position=[0.1,0.1,0.97,0.97]
           chanvals=info.interp_reg[where(info.interp_reg ne 0)]
           mask=fltarr(4096,4)
           x=indgen(4096)
           y=[0,5000,10000,60000]
           for i=0,n_elements(chanvals)-2,2 do mask[chanvals[i]:chanvals[i+1],*]=1
           loadct, 11, /silent
           contour, mask,x,y, nlevels=1, /fill, /overplot
           loadct, 0, /silent
           
      oplot, info.totalspectrum
      delvarx, x
      delvarx, y
      delvarx, mask
      delvarx, chanvals

         endif
  
        endif
    end

    'chooseinterp_default' : begin
   
     info.interp_reg=[3488,3514]
     hor
     ver
     widget_control, event.top, /destroy


    end

    'chooseinterp_reset' : begin

    info.interp_reg=intarr(100)
    plot, info.totalspectrum, xtitle='Channel', ytitle='Intensity of totaled spectra', charsize=1.2, ticklen=0.01
    end


    else:
endcase



end















;---------------------------------------------------------------------------
;                         help window - a nice scheme adopted from atv.pro
;---------------------------------------------------------------------------

pro bpdgui_help, event

   common bpdgui_info

h = strarr(45)
i = 0
h[i] =  'BPDGUI HELP'
i = i + 1
h[i] =  'Last update:  March 24, 2005,   B. Kent, Cornell U.'
i = i + 1
h[i] =  ''
i = i + 1
h[i] =  'FILE INFORMATION:'
i = i + 1
h[i] =  'Filelist:                Open a list of sssssssss.sav file to process'
i = i + 1
h[i] =  'Scannumber:              Scan number for current file being processed'
i = i + 1
h[i] =  'Drift start              Time (secs after midnight) for the start of the drift'
i = i + 1
h[i] =  'Drift stop               Time (secs after midnight) for the end of the drift'
i = i + 1
h[i]=''
i=i+1
h[i] =  'COORDINATES:'
i = i + 1
h[i] =  'RA start/stop:           Beginning and ending RA of the drift'
i = i + 1
h[i] =  'Declination:             Declination of the currently selected beam'
i = i + 1
h[i]=''
i=i+1
h[i] =  'BOARD STATUS:'
i = i + 1
h[i] =  'Board polA/B:            Default is that all boards are OK.  Click a board to mark it "bad")'
i = i + 1
h[i]=''
i=i+1
h[i] =  'STRUCTURE OUTPUT OPTIONS:'
i = i + 1
h[i] =  'Crat:			 Choose Median (default) or Fit'
i = i + 1
h[i] =  'Calsession:		 Choose new(default) or append'
i = i + 1
h[i] =  'Poswhat:		 Choose new(default) or append'
i = i + 1
h[i]=''
i=i+1
h[i] =  'FILE DISPLAYS:'
i = i + 1
h[i] =  'Unprocessed files: 	 List and number of unprocessed sav files'
i = i + 1
h[i] =  'Processed files:	 Updated as bandpass calibration is completed'
i = i + 1
h[i] =  ''
i = i + 1
h[i] =  'CALIBRATION STRUCTURE:'
i = i + 1
h[i] =  'ncalib file:		 File with the ncalib structure'
i = i + 1
h[i] =  'Date:			 Date stamp in the ncalib stucture'
i = i + 1
h[i] =  'Start/Stop time:	 Beginning and ending times of the cal scans for the current cal file'
i = i + 1
h[i] = ''
i = i + 1
h[i] = 'CALIBRATION INFORMATION AND PLOTTING:'
i = i + 1
h[i] =  'Tcals:          	 Cal Temps'
i = i + 1
h[i] =  'median Crat:             Median Calibration Ratio of Galactic HI'
i = i + 1
h[i] =  'median Tsys:		 Median System Temperature'
i = i + 1
h[i] =  'Plot Crats:		 Plot the Cal Ratios for a selected beam and polarization'
i = i + 1 
h[i] =  'Plot Tsys:		 Plot the System Temperature values for a selected beam and polarization'
i = i + 1
h[i] = '' 
i = i + 1 
h[i] =  'CALMASK REGIONS:'
i = i + 1
h[i] =  'Calmaks regions:         Plot showing the channels where the calibration was determined'
i = i + 1 
h[i] = ''
i = i + 1
h[i] = 'COMMAND BUTTONS:'
i = i + 1
h[i] = 'Process BP:              Start the bandpass calibration'
i = i + 1
h[i] = 'Interp_reg:                Select the regions to interpolate over'
i = i + 1
h[i] = 'Help:                    This window'
i = i + 1
h[i] = 'Exit:                    Exit the interface'
i = i + 1

if (not (xregistered('bpdgui_help', /noshow))) then begin

helptitle = strcompress('BPDGUI HELP')

    help_base =  widget_base(group_leader = info.baseID, $
                             /column, $
                             /base_align_right, $
                             title = helptitle, $
                             uvalue = 'help_base')

    help_text = widget_text(help_base, $
                            /scroll, $
                            value = h, $
                            xsize = 85, $
                            ysize = 45)
    
    help_done = widget_button(help_base, $
                              value = ' Done ', $
                              uvalue = 'help_done')

    widget_control, help_base, /realize
    xmanager, 'bpdgui_help', help_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro bpdgui_help_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'help_done': widget_control, event.top, /destroy
    else:
endcase

end

;---------------------------------------------------------------------
;---------------------------------------------------------------------
pro bpdgui

;GUI interface to bandpass calibration of ALFALFA data
;Started Sunday, January 16, 2005  B. Kent, Cornell U.

if (not (xregistered('bpdgui', /noshow))) then begin

common bpdgui_info

bpdgui_initcommon  ;Get things started...

;Reset plots using pjp procedures
hor
ver

;Create widgets

;Top level base
tlb=widget_base(column=1, title='ALFALFA Bandpass Calibration', $
                  tlb_frame_attr=1, xsize=975, ysize=675)

mainwindowbase=widget_base(tlb, row=1, /base_align_top)

beamselections=['0','1','2','3','4','5','6']

;---------------------------------------------------------------------
;Left aligned base
;Contains info on filename, scannumber, drift start and stop times, 
; coordinate ranges (ra start/stop, dec) and beam selection option
; Board status
; Exclusive selection ratio buttons for crat med, crat fit, and whether to begin
; a new cal session or append to one that already exists

leftbase=widget_base(mainwindowbase, column=1, /base_align_left)

infofilebase=widget_base(leftbase, column=1, /align_left)
    filebase=widget_base(infofilebase, row=1, /align_left)  
       info.filenamelist=widget_text(filebase, /editable, xsize=20, uvalue='dptr')
	label=widget_label(filebase, value='Filelist ')
	filelistbutton=widget_button(filebase, value=' Browse... ', event_pro='bpdgui_openfilelist')

    	
    scanbase=widget_base(infofilebase, row=1, /align_left)
       info.scantext=widget_text(scanbase, xsize=20)
       label=widget_label(scanbase, value='Scan Number')       
    
    driftstartbase=widget_base(infofilebase, row=1, /align_left)
       info.driftstarttext=widget_text(driftstartbase, xsize=20)
       label=widget_label(driftstartbase, value='Drift Start (AST sec after 0:00)')
    
    driftstopbase=widget_base(infofilebase, row=1, /align_left)
       info.driftstoptext=widget_text(driftstopbase, xsize=20)
       label=widget_label(driftstopbase, value='Drift Stop (AST sec after 0:00)')


infocoordbase=widget_base(leftbase, column=1, /align_left, frame=1)
  label=widget_label(infocoordbase, value='Coordinates')
    rastartbase=widget_base(infocoordbase, row=1, /align_left)
       info.rastarttext=widget_text(rastartbase, xsize=20)
       rastartlabel=widget_label(rastartbase, value='RA start   ')
       info.infocoordbeamselect=widget_droplist(rastartbase, value=beamselections, $
         event_pro='bpdgui_coord')
       label=widget_label(rastartbase, value='Beam #')

    rastopbase=widget_base(infocoordbase, row=1, /align_left)
       info.rastoptext=widget_text(rastopbase, xsize=20)
       rastoplabel=widget_label(rastopbase, value='RA stop   ')

    decbase=widget_base(infocoordbase, row=1, /align_left)
       info.dectext=widget_text(decbase, xsize=20)
       declabel=widget_label(decbase, value='Declination ')

infoboardstatusbase=widget_base(leftbase, column=1, /align_left, frame=1)
  label=widget_label(infoboardstatusbase, value='Data file:  Board Status ') 

   
    boardstatuspolA=widget_base(infoboardstatusbase, row=1, /align_left)
       boardbaseA=widget_base(boardstatuspolA, row=1, /align_left, /nonexclusive)
       for i=0,6 do begin
           info.beampolstatus(0,i)=widget_button(boardbaseA, value=strcompress(i, /remove_all)+' ', $
		uvalue='1', event_pro='bpdgui_beampolstatus')
           Widget_Control, info.beampolstatus(0,i), Set_Button=1
	
       endfor       
       label=widget_label(boardstatuspolA, value='   Pol A')

     boardstatuspolB=widget_base(infoboardstatusbase, row=1, /align_left)
       boardbaseB=widget_base(boardstatuspolB, row=1, /align_left, /nonexclusive)
       for i=0,6 do begin
           info.beampolstatus(1,i)=widget_button(boardbaseB, value=strcompress(i, /remove_all)+' ', $
		uvalue='1', event_pro='bpdgui_beampolstatus')
           Widget_Control, info.beampolstatus(1,i), Set_Button=1
         
       endfor       
       label=widget_label(boardstatuspolB, value='   Pol B')

cratbase=widget_base(leftbase, column=1, /align_left, /exclusive)
   info.usecratmed=widget_button(cratbase, value='Use CRAT median', uvalue='cratcurrent', event_pro='bpdgui_buttonselect')
   info.usecratfit=widget_button(cratbase, value='Use CRAT fit',    uvalue='cratcurrent', event_pro='bpdgui_buttonselect')
   widget_control, info.usecratmed, Set_Button=1

calsessionbase=widget_base(leftbase, row=1, /align_left)
   calsessionselectbase=widget_base(calsessionbase, column=1, /align_left, /exclusive)
      info.usecurrentcalsession=widget_button(calsessionselectbase, $ 
          value='Append to Calsession, File:', uvalue='calsessionselect', event_pro='bpdgui_buttonselect')
      info.newcalsession=widget_button(calsessionselectbase, $ 
          value='Start New Calsession, File:', uvalue='calsessionselect', event_pro='bpdgui_buttonselect')
   calsessionfilebase=widget_base(calsessionbase, column=1, /align_left)
      info.usecurrentcalsessionfile=widget_text(calsessionfilebase, xsize=15, /editable)
      info.newcalsessionfile=widget_text(calsessionfilebase, xsize=15, /editable)
	widget_control, info.newcalsession, set_button=1

poswhatbase=widget_base(leftbase, row=1, /align_left)
   poswhatselectbase=widget_base(poswhatbase, column=1, /align_left, /exclusive)
      usecurrentposwhat=widget_button(poswhatselectbase, $
          value='Append to runpos, File:', uvalue='poswhatselect', event_pro='bpdgui_buttonselect')
      newposwhat=widget_button(poswhatselectbase, $
          value='Start New runpos, File:', uvalue='poswhatselect', event_pro='bpdgui_buttonselect')
   poswhatfilebase=widget_base(poswhatbase, column=1, /align_left)
      info.usecurrentposwhatfile=widget_text(poswhatfilebase, xsize=15, /editable)
      info.newposwhatfile=widget_text(poswhatfilebase, xsize=15, /editable)
	  widget_control, newposwhat, set_button=1


;---------------------------------------------------------------------------
;Center base - only used for spacing
  centerbase=widget_base(mainwindowbase, row=1, /base_align_top, xsize=10)

;---------------------------------------------------------------------------
;Right aligned base
; Contains data from the Ncalib structure:  date, start time, stop time,
;   Tcals, median CRAT, and median Tsys for 2 pols x 7 beams, plus plotting buttons
;   for CRATS and Tsys allowing the user to select which beam and pols to plot
;   Calmask info for a given beam and polarization

rightbase=widget_base(mainwindowbase, column=1, /base_align_left)

rightbasetop=widget_base(rightbase, row=1, /align_left)
         
filelistbase=widget_base(rightbasetop, column=1, /align_left)
   info.unprocessedlistlabel=widget_label(filelistbase, value='   Unprocessed files:', /align_center)
   info.unprocesseddisplaylist=widget_list(filelistbase, xsize=20, ysize=7, value=['',''])

processedlistbase=widget_base(rightbasetop, column=1, /align_left)
   info.processedlistlabel=widget_label(processedlistbase, value='Processed files:', /align_center)
   info.processeddisplaylist=widget_list(processedlistbase, xsize=20, ysize=7, value=['',''])

ncalibinfobase=widget_base(rightbasetop, column=1, /align_left)
   ncalibfilebase=widget_base(ncalibinfobase, row=1, /align_left)
     info.ncalibfiletext=widget_text(ncalibfilebase, xsize=10, uvalue='ncalibptr')
     label=widget_label(ncalibfilebase, value='Ncalib file', /align_center)
     ncalibopenbutton=widget_button(ncalibfilebase, value=' Browse... ', event_pro='bpdgui_openncalibfile')
   ncalibdatebase=widget_base(ncalibinfobase, row=1, /align_left)
     info.ncalibdatetext=widget_text(ncalibdatebase, xsize=10)
     label=widget_label(ncalibdatebase, value='Date (YDDD)')
   ncalibstarttimebase=widget_base(ncalibinfobase, row=1, /align_left)
     info.ncalibstarttimetext=widget_text(ncalibstarttimebase, xsize=10)
     label=widget_label(ncalibstarttimebase, value='Start Time (sec after 0:00)')
   ncalibstoptimebase=widget_base(ncalibinfobase, row=1, /align_left)
     info.ncalibstoptimetext=widget_text(ncalibstoptimebase, xsize=10)
     label=widget_label(ncalibstoptimebase, value='Stop Time (sec after 0:00)')

ncalib2base=widget_base(rightbase, row=1, /align_left, frame=1)
   ncalib2displaybase=widget_base(ncalib2base, column=1, /align_left)

      tcalsbase=widget_base(ncalib2displaybase, row=1, /align_left)
         tcalsdatabase=widget_base(tcalsbase, column=1, /align_left)
          
            tcalsPolAbase=widget_base(tcalsdatabase, row=1, /align_left)
               label=widget_label(tcalsPolAbase, value='A')
               for i=0,6 do info.tcals(0,i)=widget_text(tcalsPolAbase, xsize=4)
                         
            tcalsPolBbase=widget_base(tcalsdatabase, row=1, /align_left)
               label=widget_label(tcalsPolBbase, value='B')
               for i=0,6 do info.tcals(1,i)=widget_text(tcalsPolBbase, xsize=4)
    
         label=widget_label(tcalsbase, value='Tcals')


      medCratbase=widget_base(ncalib2displaybase, row=1, /align_left)
         medCratdatabase=widget_base(medCratbase, column=1, /align_left)
          
            medCratPolAbase=widget_base(medCratdatabase, row=1, /align_left)
               label=widget_label(medCratPolAbase, value='A')
               for i=0,6 do info.medCrat(0,i)=widget_text(medCratPolAbase, xsize=4)
                             
            medCratPolBbase=widget_base(medCratdatabase, row=1, /align_left)
               label=widget_label(medCratPolBbase, value='B')
               for i=0,6 do info.medCrat(1,i)=widget_text(medCratPolBbase, xsize=4)
   
         label=widget_label(medCratbase, value='median Crat')

      medTsysbase=widget_base(ncalib2displaybase, row=1, /align_left)
         medTsysdatabase=widget_base(medTsysbase, column=1, /align_left)
           
            medTsysPolAbase=widget_base(medTsysdatabase, row=1, /align_left)
               label=widget_label(medTsysPolAbase, value='A')
               for i=0,6 do info.medTsys(0,i)=widget_text(medTsysPolAbase, xsize=4)
                   
            medTsysPolBbase=widget_base(medTsysdatabase, row=1, /align_left)
	       label=widget_label(medTsysPolBbase, value='B')
               for i=0,6 do info.medTsys(1,i)=widget_text(medTsysPolBbase, xsize=4)
            
         label=widget_label(medTsysbase, value='median Tsys')


   ncalibplotbase=widget_base(ncalib2base, column=1, /align_center, frame=1)

     ncalib2polselectbase=widget_base(ncalibplotbase, row=1, /align_left, /exclusive)
        info.ncalib2pol[0]=widget_button(ncalib2polselectbase, value='Pol A   ', uvalue='ncalib2pol', event_pro='bpdgui_buttonselect')
        info.ncalib2pol[1]=widget_button(ncalib2polselectbase, value='Pol B',    uvalue='ncalib2pol', event_pro='bpdgui_buttonselect')
	widget_control, info.ncalib2pol[0], set_button=1
     
     ncalib2beamselectbase=widget_base(ncalibplotbase, row=1, /align_left) 
        info.ncalib2beamselect=widget_droplist(ncalib2beamselectbase, value=beamselections, uvalue=beamselections)
        label=widget_label(ncalib2beamselectbase, value='Beam #')

     ncalibplotoptionbase=widget_base(ncalibplotbase, row=2, /grid_layout)
        plotCrats=widget_button(ncalibplotoptionbase, value='Plot Crats', event_pro='bpdgui_plotCrats')
        plotTsys=widget_button(ncalibplotoptionbase, value='Plot Tsys', event_pro='bpdgui_plotTsys')
        

ncalibcalmaskbase=widget_base(rightbase, column=1, /align_left, frame=1)
   ncalibcalmaskheader=widget_base(ncalibcalmaskbase, row=1, /align_left)
      label=widget_label(ncalibcalmaskheader, value='   Calmask  Regions ')
      info.ncalibcalmaskbeamselect=widget_droplist(ncalibcalmaskheader, value=beamselections, $
           event_pro='bpdgui_calmaskselect')
      label=widget_label(ncalibcalmaskheader, value='Beam #    ')
    
      ncalibcalmaskpolselectbase=widget_base(ncalibcalmaskheader, row=1, /align_left, /exclusive)
        info.ncalibcalmaskpol(0)=widget_button(ncalibcalmaskpolselectbase, value='Pol A   ', uvalue='ncalibcalmaskpol', event_pro='bpdgui_buttonselect')
        info.ncalibcalmaskpol(1)=widget_button(ncalibcalmaskpolselectbase, value='Pol B',    uvalue='ncalibcalmaskpol', event_pro='bpdgui_buttonselect')

    cregionbase=widget_base(ncalibcalmaskbase, column=1, /align_center, frame=1)
       info.cregionwindow=widget_draw(cregionbase, xsize=300, ysize=100)

buttonbase=widget_base(rightbase, column=4, /align_right, /grid_layout)
   processbp=widget_button(buttonbase, value='Process BP', event_pro='bpdgui_processbp')
   interp_reg=widget_button(buttonbase, value='Interp Region', event_pro='bpdgui_chooseinterp')
   bpdguihelp=widget_button(buttonbase, value='Help', event_pro='bpdgui_help')
   exitbpdgui=widget_button(buttonbase, value='Exit', event_pro='bpdgui_exit')

;Realization
widget_control, tlb, /realize

info.baseID=tlb

;xmanager startup
xmanager, 'bpdgui', info.baseID, /no_block


endif

end
