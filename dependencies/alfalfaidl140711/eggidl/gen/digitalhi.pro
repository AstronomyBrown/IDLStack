;+
; NAME:
;	DIGITALHI
; PURPOSE:
;       IDL Browser for the DIGITAL HI ARCHIVE
;
; EXPLANATION:
;
;       IDL Browser to display HI data and catalog from Springob et al. 2005 ApJS.  "A Digital 
;             HI Archive."  Data is read from table3 of the paper (detections table), and corresponding history
;	      files and ordinal location numbers are read from the master archive file.  The catalog
;	      entry is displayed, the spectrum, location of the peak flux density, and baseline fit are shown.
;	      The browser queries DSS2 Blue images, and displays an 8 arcminute image, if available.       
;
;
; SYNTAX:
;       digitalhi, agc=agc
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
;          AGC:  display a galaxy profile from startup, if desired.
;
; OUTPUTS:
;       none
;
;
; RESTRICTIONS:
;
;       As of now, name resolver is only for agc/ugc number.  Browser
;       shows images that are 8 arcminutes acriss
;
; EXAMPLE:
;
;       Pretty straight forward:  digitalhi, agc=1
;
; PROCEDURES USED:
;         DSSQUERY, GSFC IDL USER'S LIBRARY
;         READHISFILE:  Reads history files given the filename and ord location in the file
;         HOR.  See pjp AO library
;         VER.  See pjp AO library
;
;
;
; MODIFICATION HISTORY:
;       WRITTEN, B. Kent, Cornell U., August 2005
;
;
;-----------------------------------------------------------------------



;-------------------------------------------
; Initialize common blocks
pro digitalhi_initcommon

common digitalhi_state, state

restore, '/home/astrosun/bkent/hispec/table3.sav'
restore, '/home/astrosun/bkent/hispec/master.sav'

rec=n_elements(table3.number)

state={baseID:0L, $
       fmenu:0L, $
       helpmenu:0L, $
       plotwindowone:0L, $
       plotwindowtwo:0L, $
       plotwindowthree:0L, $
       resultlist:0L, $
       currentresults:0L, $
       currentagcnumber:0L, $ 
       searchra:0L, $
       searchdec:0L, $
       searchradius:0L, $
       table3:table3, $
       master:master, $
       table3rahr:fltarr(rec), $
       table3decdeg:fltarr(rec), $
       table3x:fltarr(rec), $
       table3y:fltarr(rec), $
       agcnumber:0L, $
       ngcic:0L, $
       ra:0L, $
       dec:0L, $
       ab:0L, $
       type:0L, $
       sobs:0L, $
       sc:0L, $
       scabs:0L, $ 
       rms:0L, $   
       snr:0L, $       
       vhelio:0L, $      
       widths1:0L, $
       widths2:0L, $
       widths3:0L, $    
       wc:0L, $    
       tel:0L, $        
       bwchan:0L, $        
       code:0L, $        
       resultlistmembers:lonarr(2000), $
       resultnumbers:0L}   

 delvarx, table3
 delvarx, master

end

;-------------------------------------------------------------
;Startup block
pro digitalhi_startup

if (not (xregistered('digitalhi', /noshow))) then begin

;print, 'Digital HI startup'

common digitalhi_state

digitalhi_initcommon

loadct, 1, /silent
stretch, 225,0

;Reset plots
hor
ver
!p.multi=0
device, decomposed=0

;Create widgets

;Top level base
tlb=widget_base(row=1, title='Digital HI Archive', $
                tlb_frame_attr=1, xsize=1100, ysize=800, mbar=top_menu, $
                uvalue='tlb')

;Menu options
state.fmenu=widget_button(top_menu, value=' File ')
  buttonexit=widget_button(state.fmenu, value=' Exit ', /separator, $
                           event_pro='digitalhi_exit')

state.helpmenu=widget_button(top_menu, value=' Help ')
  buttonhelpfits=widget_button(state.helpmenu, value= ' About ', event_pro='digitalhi_help')
;-------------------------------------------------

;LEFT BASE - query options, select galaxy list, selected galaxy
;            information from AGC

leftbase=widget_base(tlb, xsize=260, ysize=750, frame=1, /column)
  agcsearchbase=widget_base(leftbase, /row)
  label=widget_label(agcsearchbase, value='AGC ID: ')
  state.currentagcnumber=widget_text(agcsearchbase, xsize=8, /editable, value='123456', uvalue='displayagc')
  button=widget_button(agcsearchbase, value=' Display ', uvalue='displayagc')

coordsearchbase=widget_base(leftbase, /column, xsize=250, /frame)
  label=widget_label(coordsearchbase, value='Search by:')
  topcoordbase=widget_base(coordsearchbase, /row)
     label=widget_label(topcoordbase, value='(RA, Dec): ')
     state.searchra=widget_text(topcoordbase, value='12.568', xsize=7, /editable, uvalue='querposition')
     state.searchdec=widget_text(topcoordbase, value='25.025', xsize=7, /editable, uvalue='querypositon')
  bottomcoordbase=widget_base(coordsearchbase, /row)
     label=widget_label(bottomcoordbase, value='    within ')
     state.searchradius=widget_text(bottomcoordbase, value='5.0  ', xsize=7, /editable, uvalue='queryposition')
     label=widget_label(bottomcoordbase, value=' arcminutes')
  searchbutton=widget_button(coordsearchbase, value='Query Position', uvalue='queryposition')
  
listbase=widget_base(leftbase, /column, xsize=250)
state.currentresults=widget_label(listbase, value='Search Results')
state.resultlist=widget_list(listbase, xsize=20,ysize=10, value=['Enter a search'], $
                               uvalue='resultlist')

currentagcbase=widget_base(leftbase, /row, xsize=250, /base_align_left, /frame)
   labelbase=widget_base(currentagcbase, /column, /base_align_left)
    label=widget_label(labelbase,value='AGCNumber: ')
    label=widget_label(labelbase,value='NGC/IC: ')
    label=widget_label(labelbase,value='RA: ')
    label=widget_label(labelbase,value='Dec: ')
    label=widget_label(labelbase,value='a,b: ')
    label=widget_label(labelbase,value='Type: ')
    label=widget_label(labelbase,value='Sobs: ')
    label=widget_label(labelbase,value='Sc: ')
    label=widget_label(labelbase,value='Scabs(err): ')
    label=widget_label(labelbase,value='rms: ')
    label=widget_label(labelbase,value='SNR: ')
    label=widget_label(labelbase,value='Vhelio: ')
    label=widget_label(labelbase,value='WF50, WM50: ')
    label=widget_label(labelbase,value='WP50, WP20: ')
    label=widget_label(labelbase,value='W2P50: ')
    label=widget_label(labelbase,value='Wc(err): ')
    label=widget_label(labelbase,value='Telescope: ')
    label=widget_label(labelbase,value='BW   Chan: ')
    label=widget_label(labelbase,value='Code: ')

   infobase=widget_base(currentagcbase, /column, /base_align_left)
    state.agcnumber=    widget_label(infobase, value='123456           ')
    state.ngcic=        widget_label(infobase, value='NGC9999          ')
    state.ra=           widget_label(infobase, value='12 34 56.2       ')
    state.dec=          widget_label(infobase, value='+25 24 55        ')
    state.ab=           widget_label(infobase, value='12.3, 12.9       ')
    state.type=         widget_label(infobase, value='SB               ')
    state.sobs=         widget_label(infobase, value='12.0             ')
    state.sc=           widget_label(infobase, value='13.0             ')
    state.scabs=        widget_label(infobase, value='14.0(10)         ')
    state.rms=          widget_label(infobase, value='23               ')
    state.snr=          widget_label(infobase, value='10               ')
    state.vhelio=       widget_label(infobase, value='1434.5           ')
    state.widths1=       widget_label(infobase, value='123.0, 230.6    ')
    state.widths2=       widget_label(infobase, value='123.0, 230.6    ')
    state.widths3=       widget_label(infobase, value='123.0, 230.6    ')
    state.wc=           widget_label(infobase, value='23.56(10)        ')
    state.tel=          widget_label(infobase, value='AO Greg          ')
    state.bwchan=       widget_label(infobase, value='100 512          ')
    state.code=         widget_label(infobase, value='42               ')
   

;------------------------------------------------------------------------
;RIGHT BASE - full Aitoff sky plot. Spectrum/baseline and dss image display

rightbase=widget_base(tlb, xsize=830, ysize=630, /column)
   state.plotwindowone=widget_draw(rightbase, xsize=820, ysize=420, frame=1)

lowerbase=widget_base(rightbase, xsize=820, ysize=360, /row)
   state.plotwindowtwo=widget_draw(lowerbase, xsize=450, ysize=360, frame=1)
   state.plotwindowthree=widget_draw(lowerbase,xsize=360, ysize=360, frame=1)

;Realization
widget_control, tlb, /realize

state.baseID=tlb

;Xmanager startup
xmanager, 'digitalhi', state.baseID, /no_block

;To start, plot the entire AGC
widget_control, state.baseID, hourglass=1
table3=state.table3

rec=n_elements(table3.number)

rahr=fltarr(rec)
decdeg=fltarr(rec)

for i=0L, rec-1L do begin
   rahr[i]=table3.rahr2000[0,i]+table3.rahr2000[1,i]/60.0+(table3.rahr2000[2,i])/3600.0
   
decdeg[i]=abs(table3.decdeg2000[0,i])+table3.decdeg2000[1,i]/60.0+table3.decdeg2000[2,i]/3600.0
   if (table3.decdeg2000[0,i] lt 0.0) then decdeg[i]=-decdeg[i]
endfor

widget_control, state.plotwindowone, get_value=index
wset, index

ver, -90,90
hor, -180,180

glactc, rahr, decdeg, 2000, gl,gb, 1
aitoff,gl,gb,x,y

plot, x,y,psym=3, charsize=1.0, xtitle='Galactic Longitude', ytitle='Galactic Latitude'

aitoff_grid

state.table3x=x
state.table3y=y
state.table3rahr=rahr
state.table3decdeg=decdeg

delvarx, table3,x,y,gl,gb,rahr,decdeg,rec

widget_control, state.baseID, hourglass=0

endif

end

;-----------------------------------------------------
;EVENT HANDLER

pro digitalhi_event, event

common digitalhi_state

widget_control, event.id, get_uvalue=uvalue

case uvalue of

'displayagc': begin
     
              widget_control, state.currentagcnumber, get_value=agcnum

              agcnum=long(agcnum)
              agcnum=agcnum[0]
              agcindex=where(state.table3.number eq agcnum)

              if (agcindex ne -1) then begin
                  widget_control, state.resultlist, $
                      set_value=strcompress(state.table3.number[agcindex], /remove_all)
                  widget_control, state.resultlist, set_list_select=0
                  
                  state.resultlistmembers=state.table3.number[agcindex]
                  state.resultnumbers=n_elements(agcindex)

                 agcselect, agcindex

              endif else begin
                widget_control, state.resultlist, set_value=['No galaxies found']
              endelse
           

              end

'queryposition': begin

           ;Plot a zoomed in skyplot of surrounding area
              widget_control, state.searchra, get_value=rahr
              widget_control, state.searchdec, get_value=decdeg
              widget_control, state.searchradius, get_value=searchradius
              searchradius=float(searchradius)
              rahr=float(rahr)
              decdeg=float(decdeg)
              searchradius=searchradius[0]
              rahr=rahr[0]
              decdeg=decdeg[0]


              glactc, rahr, decdeg, 2000, gl,gb, 1
              aitoff,gl,gb,x,y

              widget_control, state.plotwindowone, get_value=index
              wset, index

              ver, -90,90
              hor, -180,180

              plot, state.table3x,state.table3y,psym=3, charsize=1.0, $
                    xtitle='Galactic Longitude',ytitle='Galactic Latitude'
              device, decomposed=1
              oplot, x,y, psym=6, symsize=2.0, thick=2.0, color='0000FF'XL
              device, decomposed=0

              aitoff_grid

              ralower=rahr-((searchradius/60.0)/15.0)
                if (ralower lt 0.0) then ralower=0.0
              raupper=rahr+((searchradius/60.0)/15.0)
                if (raupper gt 23.999999) then raupper=23.999999
              declower=abs(decdeg)-(searchradius/60.0)
                if (decdeg lt 0.0) then declower=-declower
                if (declower lt -90.0) then declower=-90.0
              decupper=abs(decdeg)+(searchradius/60.0)
                if (decdeg lt 0.0) then decupper=-decupper
                if (decupper gt 90.0) then decupper=90.0

;	      print, ralower, raupper
;             print, declower, decupper


              if (decdeg ge 0.0) then begin
              indexsurround=where(state.table3rahr ge ralower AND $
                                  state.table3rahr le raupper AND $
                                  state.table3decdeg ge declower AND $
                                  state.table3decdeg  le decupper  )
	      endif
  
	      if (decdeg lt 0.0) then begin
		indexsurround=where(state.table3rahr ge ralower AND $   
                                  state.table3rahr le raupper AND $   
                                  state.table3decdeg le declower AND $
                                  state.table3decdeg  ge decupper  )
	      endif

;              widget_control, state.plotwindowtwo, get_value=index
;               wset, index

;              hor, rahr+((searchradius/60.0)/15.0), rahr-((searchradius/60.0)/15.0)
;              ver, decdeg-(searchradius/60.0), decdeg+(searchradius/60.0)

             
            if (indexsurround[0] ne -1) then begin
;              plot, state.agcrahr[indexsurround], state.agcdecdeg[indexsurround], $
;                psym=5, xtitle='RA [hours]', ytitle='Dec [degrees]', $
;                title=strcompress(searchradius, /remove_all)+ ' arcminutes around query'

              widget_control, state.resultlist, $
              set_value=strcompress(state.table3.number[indexsurround], /remove_all)
              state.resultlistmembers=state.table3.number[indexsurround]
              state.resultnumbers=n_elements(indexsurround)
            endif

                 end

  'resultlist': begin

                 resultlist=state.resultlistmembers[0:state.resultnumbers-1]
                 agcnumber=resultlist[event.index]
                 agcnumber=long(agcnumber)
                 agcindex=where(long(state.table3.number) eq agcnumber[0])
                 
                 agcselect, agcindex

                end

else:

endcase

end


;-----------------------------------------------------
;Exit event handler
pro digitalhi_exit, event

common digitalhi_state

hor
ver
!p.multi=0

widget_control, state.baseID, /destroy
loadct, 0, /silent
stretch, 0,100

delvarx, state

print, 'Exiting DigitalHI...'

end

;------------------------------------------------------------
;Help
pro digitalhi_help, event

   common digitalhi_state

h=['DIGITAL HI ARCHIVE BROWSER        ', $
   'B. Kent, Cornell Univ.', $
   'Based on data from, well, all kinds of sources!', $
   'CMS, MPH, RG, Cornell EGG', $
   ' ', $
   'Started August, 2005', $
   'Last update, Friday August 19, 2005']


if (not (xregistered('digitalhi_help', /noshow))) then begin

helptitle = strcompress('DIGITALHI HELP')

    help_base =  widget_base(group_leader = state.baseID, $
                             /column, /base_align_right, title = helptitle, $
                             uvalue = 'help_base')

    help_text = widget_text(help_base, /scroll, value = h, xsize = 85, ysize = 15)
    
    help_done = widget_button(help_base, value = ' Done ', uvalue = 'help_done')

    widget_control, help_base, /realize
    xmanager, 'digitalhi_help', help_base, /no_block
    
endif


end

;----------------------------------------------------------------------

pro digitalhi_help_event, event

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'help_done': widget_control, event.top, /destroy
    else:
endcase

end

;------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------------
;Procedure for reading history files.  Passes back baseline subtracted spectrum,
;  baseline, velocity array, number of channels, and min and max flux for plot scaling.

pro readhisfile, srcname, filename, nget, spect0=spect0, vel=vel, base=base, $
channels=channels, smin=smin, smax=smax

openr, lun, '/home/esperanza3/galaxy/hisfiles/'+filename, /get_lun
;openr, lun, filename, /get_lun

mode=''
dollar=''
xxx=''
pairname=''
pairra=''
pairdec=''
dummy=''
hisfile=''
hisdir=''
history=''
outfile=''


name=''
ra=0.0
dec=0.0
restfreq=0.0
bandwidth=0.0
agc=0.0
ngcic=0.0
other=0.0
entry=0.0
channels=0.0
firstv=0.0
lastv=0.0
otag=0.0
order=0.0
coeff=dblarr(9)
rms=0.0
avtsys=0.0
inttime=0.0
sumwt=0.0
pairs=0.0
v=dblarr(5)
w=dblarr(5)
mode=dblarr(5)
smooth=0.0
dcoff=0.0
signalmax=0.0
reddate=''
spectrum=fltarr(2048)
vel=dblarr(2048)
zenang=0.0
tsys=0.0
zacorr=0.0
freqcorr=0.0
weight=0.0
clas=0.0
base=dblarr(2048)
spect0=dblarr(2048)
vmin=0.0
vmax=0.0
smin=0.0
smax=0.0

nchannels=0L
ngals=0L
onscan=0L
offscan=0L
astbegin=0L
recs=0L
holenum=0L
quadspols=0L
storcl=0L
tag=0L
;nget=0L
npairs=0L

;print, srcname, filename, nget

;read, nget, prompt=' Enter number of entry in file: '
;nget=long(nget)

ngal=0

while (ngal ne nget) do begin

format1='(1X,A12,F10.1,F8.0,2F10.4,4F8.0,/, 1X,5F8.1,/,1X,9E12.4,/,1X,6F10.3,/, 1X,3(2F10.1,4X,A6),/,1X,2(2F10.1,4X,A6),/,1X,3E10.3,8X,A12)'
readf, lun, format=format1,NAME,RA,DEC,RESTFREQ,  $
           BANDWIDTH,$ 
          AGC,NGCIC,OTHER,ENTRY,$ 
          CHANNELS,FIRSTV,LASTV,OTAG,ORDER,$ 
          COEFF,  $ 
          RMS,AVTSYS,INTTIME,SUMWT,PAIRS,AREA, $
          V,W,MODE, $
          SMOOTH,DCOFF,SIGNALMAX,REDDATE

;print, NAME, AGC, NGCIC, OTHER, ngal

ngal++

;print, 'NGAL ',ngal, '  ',name

;print, NAME,RA,DEC,RESTFREQ,  $
;           BANDWIDTH,$ 
;          AGC,NGCIC,OTHER,ENTRY,$ 
;          CHANNELS,FIRSTV,LASTV,OTAG,ORDER,$ 
;          COEFF,  $ 
;          RMS,AVTSYS,INTTIME,SUMWT,PAIRS,AREA, $
;          V,W,MODE, $
;         SMOOTH,DCOFF,SIGNALMAX,REDDATE

for i=0,7 do begin
   readf, lun, format='(A1)', DUMMY
endfor

npairs=pairs
;if (npairs eq 0) then npairs=1      ; MPH confirm?

;print, '*******************************************************'
;print, 'Npairs', npairs
;print, '***************************'
for i=0,npairs-1 do begin

format2='(A1,I7,2X,A12,I8,I3,1X,A8,A7,F6.2,F6.1,2F6.2,2I3,F6.2,F8.3,I4,I2)'

  readf, lun, format=format2, XXX,ONSCAN,PAIRNAME,ASTBEGIN, $
                            RECS,PAIRRA,PAIRDEC,ZENANG,TSYS, $
                            ZACORR,FREQCORR,HOLENUM,QUADSPOLS, $
                            WEIGHT,CALS,STORCL,TAG

;  print, XXX,ONSCAN,PAIRNAME,ASTBEGIN, $
;                            RECS,PAIRRA,PAIRDEC,ZENANG,TSYS, $
;                            ZACORR,FREQCORR,HOLENUM,QUADSPOLS, $
;                            WEIGHT,CALS,STORCL,TAG


  readf, lun, format='(A1,I7)', XXX,OFFSCAN
 
;  print, XXX, OFFSCAN

endfor




;for i=0, long(channels)-1 do begin
;   readf, lun, spectrum[i]
;   print, spectrum[i]
;endfor


;12 is the number of spectral elements in a row according to specpak
;files

;spectrum_temp=dblarr(12)
rows=long(ceil(channels/12.0))

;print, (long(channels) mod 12)

;if ((long(channels) mod 12) ne 0) then rows++

;print, ''
;print, 'Rows', rows
;print, ''
        for i=0, rows-1 do begin
         
          if ((i lt (rows-1)) OR (i eq (rows-1)  AND (long(channels) mod 12) eq 0)) then begin
;               print, 'regular path'
               spectrum_temp=dblarr(12)
               readf,lun,format='(1X,12E11.4)', spectrum_temp
;               print, spectrum_temp
               spectrum[i*12:12*(i+1)-1]=spectrum_temp 
          endif
 
          if (i eq (rows-1) AND (long(channels) mod 12) ne 0) then begin
;               print, 'modified path'
               spectrum_temp=dblarr(long(channels) mod 12)
               readf, lun, format='(1X,'+strcompress(long(channels) mod 12, /remove_all)+'E11.4)', spectrum_temp
;               print, spectrum_temp
               spectrum[i*12:long(channels)-1]=spectrum_temp
          endif          

          ;readf,lun,format='(1X,12E11.4)', spectrum_temp
         
        
          ;spectrum[i*12:12*(i+1)-1]=spectrum_temp 
       endfor
 ;       done:

;spectrum[0:channels-1]=spectrum_temp

;print, 'After for loop' 

;on_ioerror, really_done


;plot, spectrum[0:channels-1], title=name
;wait, 1.0

readf, lun, format='(a1, 1x, 2f6.0, 2f6.1)', dollar,vmin, vmax, smin, smax
;print, '   ',dollar, vmin, vmax, smin, smax
 ;print, '---------------------------------------------------------'
 ;print, ' '
 ;print, ' '
 ;print, ' '
 ;print, 'Num Chan = ', channels

if (dollar ne '$') then begin 
   print, 'Error for name: '+name+' in file '+filename
   wait, 4.0

   goto,error_done
endif

endwhile


;MPH way of reconstructing velocity array and baseline
vel=fltarr(channels)
for i=0, channels-1 do vel[i]=firstv+(lastv-firstv)/(channels-1)*i

m=-1
for i=0, channels-1 do begin
 m++
 base[m]=coeff[0]
   for j=1, order do base[m]=base[m]+coeff[j]*float(i)^j
 spect0[i]=spectrum[i]-base[i]
endfor


;wset, 18

;hor
;ver

;plot, vel, spect0[0:long(channels)-1], xstyle=1, ystyle=1,title='Source '+srcname

;device, decomposed=1

;oplot, vel, base[0:long(channels)-1], color='0000FF'XL, linestyle=2

;device, decomposed=0

;print, 'After final plot'

error_done:

really_done:

close, lun
free_lun, lun

end





;--------------------------------------------------------
;Refreshes screen with selected galaxy
pro agcselect, agcindex

common digitalhi_state

              rahr=state.table3.rahr2000[0,agcindex]+state.table3.rahr2000[1,agcindex]/60.0 $
                 +(state.table3.rahr2000[2,agcindex])/3600.0

              
decdeg=abs(state.table3.decdeg2000[0,agcindex])+state.table3.decdeg2000[1,agcindex]/60.0$
                  +state.table3.decdeg2000[2,agcindex]/3600.0
              if (state.table3.decdeg2000[0,agcindex] lt 0.0) then decdeg=-decdeg
              rahr=rahr[0]
              decdeg=decdeg[0]

              glactc, rahr, decdeg, 2000, gl,gb, 1
              aitoff,gl,gb,x,y

              widget_control, state.plotwindowone, get_value=index
              wset, index

              ver, -90,90
              hor, -180,180

              plot, state.table3x,state.table3y,psym=3, charsize=1.0, $
                    xtitle='Galactic Longitude',ytitle='Galactic Latitude'
             
              device, decomposed=1
              oplot, x,y, psym=6, symsize=2.0, thick=2.0, color='0000FF'XL
              device, decomposed=0

              aitoff_grid

              ;Update infobase window with galaxy information
              radecconvert, rahr, decdeg, rastring, decstring
              agcnumber=state.table3.number[agcindex]
              ngcic=state.table3.other[agcindex]
              a=state.table3.a[agcindex]
              b=state.table3.b[agcindex]
              type=state.table3.t[agcindex]
              sobs=state.table3.sobs[agcindex]
              sc=state.table3.sc[agcindex]
              scabs=state.table3.scabs[agcindex]
              epss=state.table3.epss[agcindex]
              rms=state.table3.rms[agcindex]      
              snr=state.table3.snr[agcindex]
              vhelio=state.table3.vhelio[agcindex]
              wf50=state.table3.wf50[agcindex]
              wm50=state.table3.wm50[agcindex]
              wp50=state.table3.wp50[agcindex]
              wp20=state.table3.wp20[agcindex]
              w2p50=state.table3.w2p50[agcindex]
              wc=state.table3.wc[agcindex]
              epsw=state.table3.epsw[agcindex]
              tel=state.table3.tel[agcindex]
              bw=state.table3.bw[agcindex]
              nchan=state.table3.nchan[agcindex]
              code=state.table3.code[agcindex]
             

widget_control, state.agcnumber, set_value=strcompress(agcnumber[0], /remove_all)
widget_control, state.ngcic, set_value=strcompress(ngcic[0])
widget_control, state.ra, set_value=rastring[0]
widget_control, state.dec, set_value=decstring[0]
widget_control, state.ab, set_value=strcompress(a[0], /remove_all)+', '+ $
                                    strcompress(b[0], /remove_all)
widget_control, state.type, set_value=strcompress(type[0], /remove_all)
widget_control, state.sobs, set_value=strcompress(sobs[0], /remove_all)
widget_control, state.sc, set_value=strcompress(sc[0], /remove_all)
widget_control, state.scabs, set_value=strcompress(scabs[0], /remove_all)+'('+ $
                                       strcompress(epss[0], /remove_all)+')'
widget_control, state.rms, set_value=strcompress(rms[0], /remove_all)
widget_control, state.snr, set_value=strcompress(snr[0], /remove_all)
widget_control, state.vhelio, set_value=strcompress(vhelio[0], /remove_all)
widget_control, state.widths1, set_value=strcompress(wf50[0], /remove_all)+', '+strcompress(wm50[0], /remove_all)
widget_control, state.widths2, set_value=strcompress(wp50[0], /remove_all)+', '+strcompress(wp20[0], /remove_all)
widget_control, state.widths3, set_value=strcompress(w2p50[0], /remove_all)
widget_control, state.wc, set_value=strcompress(wc[0], /remove_all)+'('+ $
                                       strcompress(epsw[0], /remove_all)+')'
widget_control, state.tel, set_value=strcompress(tel[0], /remove_all)
widget_control, state.bwchan, set_value=strcompress(bw[0], /remove_all)+'   '+$
                                        strcompress(nchan[0], /remove_all)
widget_control, state.code, set_value=strcompress(code[0], /remove_all)


               ;INSERT SPECTRUM PLOTTING HERE
    
                widget_control, state.plotwindowtwo, get_value=index
                wset, index

		hor
		ver

	        masterindex=where(state.master.agcugc eq long(agcnumber[0]))

	        readhisfile, state.master.srcname[masterindex], $
                             state.master.hisfile[masterindex], $
                             state.master.ordloc[masterindex], $
                             spect0=spect0, vel=vel, base=base, channels=channels, $
 			     smin=smin, smax=smax

	        ver, smin, smax*1.3

                plot, vel, spect0[0:channels-1], xtitle='Velocity [km/s]', $
                      ytitle='Flux Dens [mJy]', xstyle=1, ystyle=1, $
		      title='AGC '+strcompress(agcnumber, /remove_all)

		

		device, decomposed=1
	        oplot, vel, base[0:channels-1], color='0000FF'XL, linestyle=2
            	flag, vhelio[0], color='0000FF'XL

		device, decomposed=0

                ;Query DSS at STSCI
                widget_control, state.baseID, hourglass=1
              
                widget_control, state.searchradius, get_value=searchradius
                searchradius=float(searchradius)
                searchradius=searchradius[0]
              
                ;Both coords must be in decimal degrees
                coords=[rahr*15.0,decdeg]
                querydss, coords, image, Hdr, survey='2b', imsize=8.0
 	        widget_control, state.plotwindowthree, get_value=index
                wset, index  

		if (image[0] ne 0) then begin
                   image=congrid(image, 360,360) 
                   tvscl, image
		endif else begin
		    plot,[0,0],xstyle=4, ystyle=4
                    xyouts, 80,170, 'Image not available', /device, charsize=2.0
                    xyouts, 100, 155, 'at this time', /device, charsize=2.0
	        endelse

                widget_control, state.baseID, hourglass=0



end


;-----------------------------------------------
;MAIN PROCEDURE BLOCK
pro digitalhi, agc=agc


digitalhi_startup

common digitalhi_state

;Select galaxy if given at command prompt.
if (n_elements(agc) ne 0) then begin
              agcnum=agc

              agcindex=where(state.table3.number eq agcnum)

              if (agcindex ne -1) then begin
                  widget_control, state.resultlist, $
                      set_value=strcompress(state.table3.number[agcindex], /remove_all)
                  widget_control, state.resultlist, set_list_select=0
                  
                  widget_control, state.currentagcnumber, set_value=strcompress(agcnum, /remove_all)
                  state.resultlistmembers=state.table3.number[agcindex]
                  state.resultnumbers=n_elements(agcindex)

                 agcselect, agcindex

              endif else begin
                widget_control, state.resultlist, set_value=['No galaxies found']
              endelse
   
endif



end
