;+
; NAME:
;      GALcat
; PURPOSE:
;       ALFALFA Tool for generating catalogs from ALFALFA HI source
;       files (*.src) from GALflux
;
; EXPLANATION:
;
;       GALcat is a simple GUI utility tha allows users to browse
;       *.src files, their contents and spectra, examine optical
;       images, issue a quality rating to each source, and export a
;       catalog in formatted, csv, or html format.
;
;
;
; CALLING SEQUENCE:
;       
;       galcat
;
; INPUTS:
;       none
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
;        Must have run in a directory that contains source (*.src)
;        files output from GALflux
;
; EXAMPLE:
;
;       Pretty straight forward:  galcat
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
;       WRITTEN, B. Kent, Cornell University, June, 2006
;       August, 26, 2006. BK, - Errors are rounded, not floored,
;                             - Comments are editable
;                             - S/N, stat/sys vel and width errors can be modfied.
;                             - optical coords can be updated with access to DSS, Sloan, NED, Skyview
;                                and the AGC.  Note that you need to have a web browser to get to Sloan
;                                and Skyview.  If you have a hidden browser somewhere, Sloan might pop up
;                                there without you knowing it. :)
;                             - mod to source files can be saved on the fly
;                             - deltaRA/deltaDEC taken out
;                             - only HI ellipse centroid coords displayed
;                             - Assigning a quality number will not reload all windows (slows it down)
;                             - Quality 4 added (low s/n, no previous cz info, but highly likely oc)
;
;	December 11, 2008. RG - Entered code 5 (prior-)
;
;       October 11, 2006. BK, - modification so Qualtiy status(0
;                               through 4) is saved in source file (src.spectra[0].x_int[0])
;
;
;       November 8, 2006. BK, - AGC can now be modified in the source
;                               file.  Numbers added to Quality
;                               options.
;
;       November 28,2006. BK -  Added HVC category
;
;       January  20,2006. BK -  Added codes to the filelist names
;                              (easier to pick out zeros)
;
;       May 9, 2010.      MH -  Change AGC call to agcnorthminus1
;
;----------------------------------------------------------
pro galcat_initcommon

common galcat_state, catstate
end


pro galcat_event, event

common galcat_state

widget_control, event.id, get_uvalue=uvalue

case uvalue of



'isolist': begin

catstate.isoindex=event.index



end

'exporthtml': begin

widget_control, catstate.filelistwidget, get_uvalue=filelist

runlist, strmid(filelist,4,30)

end

'exportcsv': begin

widget_control, catstate.filelistwidget, get_uvalue=filelist

exportcsv, strmid(filelist,4,30), catstate.codes

end

'exportformat': begin

widget_control, catstate.filelistwidget, get_uvalue=filelist

exportformat, strmid(filelist,4,30), catstate.codes

end



'exportmarked':begin

widget_control, catstate.filelistwidget, get_uvalue=filelist

validFiles=intarr(n_elements(filelist))

for i=0,n_elements(filelist)-1 do begin
   pos=strpos(filelist[i], 'x')
   if (pos[0] ne -1) then validFiles[i]=1
endfor



index=where(validFiles eq 1)

if (index[0] ne -1) then begin
exportformat, strmid(filelist[index], 4,30), catstate.codes[index], /marked
endif else begin
  print, 'No objects selected in the list'
endelse



end


'mainplotwindow': begin



end

'agcinfo': begin

widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4, 30)
specnr=catstate.isoindex

agcbrowse, agc=src.spectra[specnr].agcnr

end




'deleteitem':begin

widget_control, catstate.filelistwidget, get_uvalue=filelist

   first = 0
    last = N_Elements(filelist)-1
   CASE catstate.fileindex OF
      first:filelist = filelist[1:*]
      last: filelist = filelist[first:last-1]
      ELSE: filelist = [ filelist[first:catstate.fileindex-1], filelist[catstate.fileindex+1:last] ]
   ENDCASE

   widget_control, catstate.filelistwidget, set_value=filelist
   widget_control, catstate.filelistwidget, set_uvalue=filelist

   if (catstate.fileindex gt n_elements(filelist)-1) then catstate.fileindex = n_elements(filelist)-1

   widget_control, catstate.filelistwidget, set_list_select=catstate.fileindex


end



'cubewindow': begin

end

'opennavigator': begin

;Open firefox on the local system to the correct coordinates

widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4,30)
specnr=catstate.isoindex

RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell


url='http://cas.sdss.org/astro/en/tools/chart/navi.asp?ra='+strcompress(double(RA_ell*15.0), /remove_all)+'&dec='+$
       strcompress(double(Dec_ell), /remove_all)+'&opt=glsi'

spawn, '/usr/bin/firefox -remote "openurl('+url+')"', answer

;print, answer
end 

'openskyview': begin

widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4,30)
specnr=catstate.isoindex

RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell

url='http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD='+strcompress(RA_ell*15.0, /remove_all)+','+strcompress(Dec_ell, /remove_all)+'&SURVEY=DSS2+Blue&SCOORD=Equatorial&GRIDDD=Yes&SFACTOR=0.1&PIXELX=300&PIXELY=300&RETURN=GIF'

filename='~/junkdss42bk.gif'

spawn, 'wget -q -O '+ filename + " '" + url + "'"

;print, url
 ;http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD=183.18989,10.865351&SURVEY=DSS2+Blue&SCOORD=Equatorial&GRIDDD=Yes&SFACTOR=0.1&PIXELX=300&PIXELY=300&RETURN=GIF
;http://skys.gsfc.nasa.gov/cgi-bin/pskcall?VCOORD=mkn421&SURVEY=HRI&SCOORD=Galactic&GRIDDD=Yes&CATLOG=Hipparcos+Main+Catalog&RETURN=GIF

spawn, '/usr/bin/firefox -remote "openFile('+filename+')"', answer


end

'savechanges': begin


widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4,30)

widget_control, catstate.optcoords, get_value=rdopt
widget_control, catstate.snr, get_value=stn
widget_control, catstate.velerrstat, get_value=vstaterrstring
widget_control, catstate.velerrsys,  get_value=vsyserrstring
widget_control, catstate.widtherrstat, get_value=wstaterrstring
widget_control, catstate.widtherrsys,  get_value=wsyserrstring
widget_control, catstate.agcnumber, get_value=agcnumberstring

vstaterr=double(vstaterrstring)
vsyserr=double(vsyserrstring)
wstaterr=double(wstaterrstring)
wsyserr=double(wsyserrstring)

pluspos=strpos(rdopt,'+')
rastring=strmid(rdopt,0,pluspos)
decstring=strmid(rdopt,pluspos)

src.spectra[0].RA_opt=hms1_hr(double(rastring))
src.spectra[0].Dec_opt=dms1_deg(double(decstring))

;Place velocity errors in appropriate Peaks or Gaussian Listing
if (src.spectra[0].ston[0] ne 0.0) then src.spectra[0].vcenerr_stat[0]=vstaterr ;Peaks
if (src.spectra[0].ston[0] eq 0.0) then src.spectra[0].vcenerr_stat[3]=vstaterr ;Gaussian

if (src.spectra[0].ston[0] ne 0.0) then src.spectra[0].vcenerr_sys[0]=vsyserr/src.spectra[0].width[0]
if (src.spectra[0].ston[0] eq 0.0) then src.spectra[0].vcenerr_sys[3]=vsyserr/src.spectra[0].width[3]

;Place width errors in appropriate Peaks or Gaussian Listing
if (src.spectra[0].ston[0] ne 0.0) then src.spectra[0].widtherr[0]=wstaterr ;Peaks
if (src.spectra[0].ston[0] eq 0.0) then src.spectra[0].widtherr[3]=wstaterr ;Gaussian

if (src.spectra[0].ston[0] ne 0.0) then src.spectra[0].widtherr[4]=wsyserr/src.spectra[0].width[0]
if (src.spectra[0].ston[0] eq 0.0) then src.spectra[0].widtherr[5]=wsyserr/src.spectra[0].width[3]

;Place signal to noise in appropriate listing - Peaks or Gaussian
if (src.spectra[0].ston[0] ne 0.0) then src.spectra[0].ston[0]=double(stn)
if (src.spectra[0].ston[0] eq 0.0) then src.spectra[0].ston[4]=double(stn)

;Update comments
widget_control, catstate.commentsdisplay, get_value=commentsstring

finalcomments=''

for i=0,n_elements(commentsstring)-1 do finalcomments=finalcomments+commentsstring[i]

src.comments[0]=finalcomments

;Store AGC number added Nov. 2006
src.spectra[*].agcnr=agcnumberstring[0]

if (n_elements(src.comments) gt 1) then src.comments[1:n_elements(src.comments)-1]=' '

save, src,  filename=strmid(filelist[catstate.fileindex],4)


end



'sloan': begin

catstate.currentsurvey='sloan'
Widget_Control, event.id, Set_Button=1
widget_control, catstate.dss2bluemenu, set_button=0

end


'dss2blue': begin

catstate.currentsurvey='dss2blue'
Widget_Control, event.id, Set_Button=1
widget_control, catstate.sloanmenu, set_button=0

end


else:

endcase

galcat_openfile

end

;----------------------------------------------------
;Procedure for opening external GETDSS.PRO 
pro galcat_externaldss, event

common galcat_state



widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4,30)
print, strmid(filelist[catstate.fileindex],4,30)
specnr=catstate.isoindex

RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell

getdss, RA_ell, Dec_ell

end


;-----------------------------------------------------
;Event handler for filelisting

pro galcat_filelist, event

common galcat_state

catstate.fileindex=event.index

;Special marking feature requested by Riccardo - DOUBLE CLICK
if (event.clicks eq 2) then begin
widget_control, catstate.filelistwidget, get_uvalue=filelist
pos=strpos(filelist[event.index], 'x')

if (pos[0] eq -1) then begin
   filelist[event.index]=filelist[event.index]+' x'
endif else begin
   filelist[event.index]=strmid(filelist[event.index],0,34)
endelse

  widget_control, catstate.filelistwidget, set_uvalue=filelist
   widget_control, catstate.filelistwidget, set_value=filelist

endif

galcat_openfile
 
end 


;-----------------------------------------------------
pro galcat_markobject, event

common galcat_state

widget_control, catstate.filelistwidget, get_uvalue=filelist
pos=strpos(filelist[catstate.fileindex], 'x')

if (pos[0] eq -1) then begin
   filelist[catstate.fileindex]=filelist[catstate.fileindex]+' x'
endif else begin
   filelist[catstate.fileindex]=strmid(filelist[catstate.fileindex],0,34)
endelse

  widget_control, catstate.filelistwidget, set_uvalue=filelist
  widget_control, catstate.filelistwidget, set_value=filelist

galcat_openfile

end


;-----------------------------------------------------
;Modify signal to noise for large sources
pro galcat_fixsnr, event

common galcat_state

widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4,30)
specnr=catstate.isoindex

W50=src.spectra[specnr].width[0]
WGauss=src.spectra[specnr].width[3]

widget_control, catstate.snr, get_value=snrstring
snr=double(snrstring)

if (W50 ne 0.0) then snr=snr*sqrt(W50/200)
if (W50 eq 0.0) then snr=snr*sqrt(WGauss/200)

widget_control, catstate.snr, set_value=strcompress(snr)


end




;----------------------------------------------------------------------
pro galcat_nedgui, rahr, decdeg

 common galcat_state

widget_control, catstate.baseID, hourglass=1

widget_control, catstate.filelistwidget, get_uvalue=filelist
restore, strmid(filelist[catstate.fileindex],4,30)
specnr=catstate.isoindex

rahr=src.spectra[specnr].RA_ell
decdeg=src.spectra[specnr].Dec_ell

nedquery, rahr*15.0, decdeg,10.0, numberinfo=numberinfo, string_array=string_array

h=[numberinfo, '  Name 			         RA(J2000)   DEC(J2000)	TYPE      VEL    Z	   SKY DIST(arcmin)',string_array]


if (not (xregistered('galcat_nedgui', /noshow))) then begin

helptitle = strcompress('GalCat NED Results')

    help_base =  widget_base(group_leader = catstate.baseID, $
                             /column, /base_align_right, title = helptitle, $
                             uvalue = 'ned_base')

    help_text = widget_text(help_base, /scroll, value = h, xsize = 110, ysize = n_elements(h)+2)
    
    help_done = widget_button(help_base, value = ' Done ', uvalue = 'nedgui_done')

    widget_control, help_base, /realize
    xmanager, 'galcat_nedgui', help_base, /no_block
    
endif



widget_control, catstate.baseID, hourglass=0



end



;----------------------------------------------------------------------

pro galcat_nedgui_event, event

 common galcat_state

widget_control, event.id, get_uvalue = uvalue

case uvalue of
    'nedgui_done': begin
        widget_control, event.top, /destroy
    end


    else:
endcase

end



;----------------------------------------------------- 
;Exit event handler  
pro galcat_exit, event  

common galcat_state

hor
ver
!p.multi=0

widget_control, catstate.baseID, /destroy
loadct, 0, /silent
stretch, 0,100



delvarx, catstate

print, 'Exiting GALcat...'

end


;--------------------------------------------------
;Status code switch mechanism
pro galcat_codes, event

common galcat_state

widget_control, event.id, get_uvalue=codestring

catstate.codes[catstate.fileindex]=long(codestring)

widget_control, catstate.filelistwidget, get_uvalue=filelist

restore, strmid(filelist[catstate.fileindex],4,30)


;Save the code in the file
src.spectra[0].x_int[0]=long(codestring)

;Set the value of the code that is in the state structure

case catstate.codes[catstate.fileindex] of

0: widget_control, catstate.buttonnostatus, set_button=1
1: widget_control, catstate.buttondetection, set_button=1
2: widget_control, catstate.buttonprior, set_button=1
3: widget_control, catstate.buttonmarginal, set_button=1
4: widget_control, catstate.buttonlowsnr, set_button=1
9: widget_control, catstate.buttonhvc, set_button=1
;3: widget_control, catstate.buttonfollowup, set_button=1

else:

endcase

srcname=src.srcname
nspec=n_elements(src.spectra)

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(src.spectra[j].isophot), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]

if (catstate.isoindex gt nspec-1) then catstate.isoindex=nspec-1


widget_control, catstate.isolist_id, get_uvalue=self
self->SetValues, isophote, CurrentIndex=catstate.isoindex

specnr=catstate.isoindex

spec=src.spectra[specnr].spec
velarr=src.spectra[specnr].velarr
weight=src.spectra[specnr].weight

nchn=n_elements(spec)

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

ymin=-1.0*(max(src.spectra[specnr].peak_flx))
;ymax=1.5*src.spectra[specnr].rmsP*src.spectra[specnr].ston[0]
ymax=1.7*(max(src.spectra[specnr].peak_flx))


fwhm=nspec-2

;5 is the FWHM?? as of Apirl it is now element 0
vmin=min(velarr)
vmax=max(velarr)

charsize=1.1

widget_control, catstate.mainplotwindow, get_value=index
wset, index

plot,velarr,spec,xrange=[vmin,vmax],yrange=[ymin,ymax],xstyle=1,ystyle=1,position=[0.10,0.25,0.95,0.92], $
     ytitle='Flux Density [mJy]',title='HI'+srcname+ '   '+isophote[specnr]+' mJy km/s level', $
     charsize=charsize, xtickn=[' ',' ',' ',' ',' ',' ',' ']
oplot,velarr,fltarr(nchn),linestyle=1
device, decomposed=1
if (src.spectra[specnr].vcen[2] ne 0.0) then flag, src.spectra[specnr].vcen[2], color='0000FF'XL
if (src.spectra[specnr].vcen[2] eq 0.0) then flag, src.spectra[specnr].vcen[3], color='0000FF'XL
device, decomposed=0

weight=weight/max(weight)
plot,velarr,weight,xtickformat='(i5)',xrange=[vmin,vmax],yrange=[0.0,1.2],xstyle=1,ystyle=1,position=[0.10,0.12,0.95,0.25], $
     xtitle='Velocity [km/s]',ytitle='Weight',charsize=charsize,linestyle=2, /noerase


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Fill in the text display with measurements and parameters from
;source file.

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

; get ellipse
totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; Get and determine errors

vstaterr=src.spectra[specnr].vcenerr_stat[0]
   if (vstaterr eq 0.0) then vstaterr=src.spectra[specnr].vcenerr_stat[3]   ;if zero use gauss result
vsyserr=src.spectra[specnr].vcenerr_sys[0]*src.spectra[specnr].width[0]   ;use width
   if (vsyserr eq 0.0)  then vsyserr=src.spectra[specnr].vcenerr_sys[3]*src.spectra[specnr].width[3]  ;use width value

verr=sqrt((vstaterr)^2+(vsyserr)^2)   ;add computed results in quadrature


wstaterr=src.spectra[specnr].widtherr[0]
   if (wstaterr eq 0.0) then wstaterr=src.spectra[specnr].widtherr[3]   ;if zero use gauss result
wsyserr=src.spectra[specnr].widtherr[4]*src.spectra[specnr].width[0]
   if (wsyserr eq 0.0) then wsyserr=src.spectra[specnr].widtherr[5]*src.spectra[specnr].width[3]

werr=sqrt((wstaterr)^2+(wsyserr)^2)   ;add computed results in quadrature

fluxstaterr=src.spectra[specnr].flux_specP_err_stat/1000.0
   if (fluxstaterr eq 0.0) then fluxstaterr=src.spectra[specnr].flux_specG_err_stat/1000.0   ;if zero use gauss result
fluxsyserr=src.spectra[specnr].flux_specP_err_sys/1000.0    ;Don't need to convert to Jy km/s
   if (fluxsyserr eq 0.0)  then fluxsyserr=src.spectra[specnr].flux_specG_err_sys/1000.0

fluxerr=sqrt((fluxstaterr)^2+(fluxsyserr)^2)   ;add computed results in quadrature


; convert to string

sv50=strtrim(string(V50,W50,werr,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werr,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,verr,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

deltaRA= (src.spectra[specnr].RA_opt-ra_ell)*60.0  ;minutes
deltaDEC=(src.spectra[specnr].DEC_opt-dec_ell)*60.0  ;minutes
raunits='min'
decunits='arcmin'


if (abs(deltara) lt 1.0) then begin
    deltara=deltara*60.0
    raunits='sec'
endif

if (abs(deltadec) lt 1.0) then begin
    deltadec=deltadec*60.0
    decunits='arcsec'
endif


;Compute galactic coordinates
glactc,RA_cen, DEC_cen, 2000, l,b,1

lbcoords='('+string(l,format='(f6.2)')+', '+string(b,format='(f6.2)')+') degrees'

outstring=['HI'+srcname+'                                 (l,b)= '+lbcoords, $
'V50,W50:          '+sv50+  '    Cen_ell:  '+radec_ell+' [2000]', $
'V20,W20:          '+sv20+  '    Opt pos:  '+rdopt+' [2000]', $
'Vcen:             '+svcen+ '           dRA: '+strtrim(string(deltaRA, format='(f9.5)'))+' '+raunits, $
'V,W Gauss:        '+svg+   '    dDec: '+strtrim(string(deltaDEC, format='(f6.2)'))+' '+decunits,$
'Stot(profile, P): '+sstotP+'        Ellipse:  '+ellipse, $
'Stot(profile, G): '+sstotG+'        Isophote: '+ssiso,$
'Map Stot:         '+sstotm+'        Map Smax: '+smapsmax, $
'meanS, peakS:     '+smeans+'               rms: '+srms  , $
'S/N P:            '+sstnP, $
'S/N G:            '+sstnG, $ 
'Cont:             '+scont+'                     AGC'+src.spectra[specnr].agcnr, $
'Status Code:      '+strcompress(catstate.codes[catstate.fileindex], /remove_all)]

widget_control, catstate.textdisplay, set_value=outstring

widget_control, catstate.commentsdisplay, set_value=src.comments

widget_control, catstate.optcoords, set_value=rdopt
if (stn[0] ne 0.0) then widget_control, catstate.snr, set_value=string(stn[0], format='(f7.1)')
if (stn[0] eq 0.0) then widget_control, catstate.snr, set_value=string(stn[4], format='(f7.1)')

agcoptcz='no cz'

if (src.spectra[0].agcnr ne '') then begin
   agcnum_long=long(src.spectra[0].agcnr)
   agclocation=where(catstate.agc.agcnumber eq agcnum_long)
  if (agclocation[0] ne -1) then begin
       agcoptcz=strcompress(catstate.agc.vopt[agclocation], /remove_all)

       if (catstate.agc.vopt[agclocation] eq 0) then agcoptcz='no cz'

   endif

endif



widget_control, catstate.velerrstat, set_value=strcompress(vstaterr, /remove_all) 
widget_control, catstate.velerrsys,  set_value=strcompress(vsyserr, /remove_all) 
widget_control, catstate.widtherrstat, set_value=strcompress(wstaterr, /remove_all) 
widget_control, catstate.widtherrsys,  set_value=strcompress(wsyserr, /remove_all) 
widget_control, catstate.agcnumber, set_value=strcompress(src.spectra[0].agcnr, /remove_all)
widget_control, catstate.agcoptcz, set_value=agcoptcz

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Make the map plot with ellipses
widget_control, catstate.cubewindow, get_value=index
wset, index

plot, [0,0], /nodata, xrange=[n_elements(src.srccube.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5,n_elements(src.srccube.dbox[0,0,*])-0.5] , $
             xtitle='X pixel', ytitle='Y pixel', xstyle=1, ystyle=1

PX = !X.WINDOW * !D.X_VSIZE 
PY = !Y.WINDOW * !D.Y_VSIZE
SX = PX[1] - PX[0] + 1 
SY = PY[1] - PY[0] + 1

loadct, 1, /silent

;Display HI map with tvscl procedure
tvscl, reverse(congrid(src.srccube.totf, sx,sy)), px[0], py[0]

;print, sx, sy, px[0], py[0]

plot, [0,0], /nodata, xrange=[n_elements(src.srccube.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5, n_elements(src.srccube.dbox[0,0,*])-0.5], $
             xtitle='X pixel', ytitle='Y pixel', /noerase, xstyle=1, ystyle=1





for specnum=0, nspec-1 do begin

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']




a_ell=src.spectra[specnum].a_ell
b_ell=src.spectra[specnum].b_ell
PA_ell=src.spectra[specnum].PA_ell

dims=size(reform(src.srccube.dbox[0,*,*]),/dimensions)

fmax=max(src.srccube.totf,index)
xpxpk=index mod dims[0]
ypxpk=index/dims[0]

device, decomposed=1
;Mark the maximum value
plotsym, 0, /fill
plots, round(xpxpk),round(ypxpk), psym=7, symsize=2, thick=2.0, color='000000'XL, /data   ; Black

;ellipse_colors=[239,223,208,31,111,255,160,63]
;PINK, GOLD, YELLOW, MAGENTA, CYAN, RED, GREEN, WHITE for custom
ellipse_colors=['00BBFF'XL, '7F7FFF'XL, '00FFFF'XL, 'FF00FF'XL, 'FFFF00'XL, '0000FF'XL, '00FF00'XL, 'FFFFFF'XL]
ellipse_labels=isophote

;Units of device coorindates
ellipse_xpos=5
ellipse_ypos=[105,90,75,60,45,30,15,-200]

if (nspec eq 7) then ellipse_ypos[7]=5

xyouts, 5,120, 'Contour', /device




iso=[0.5*fmax, 0.25*fmax,100.,200.,300.,500.,1000, -1]

indices=where(src.srccube.totf gt iso[specnum],ncount)
    if (ncount gt 4) then begin
        
  ellipsePts=fit_ellipse(indices,xsize=src.srccube.nbx,ysize=src.srccube.nby,axes=axes,orientation=orientation,center=center, npoints=500)
 
  oplot,ellipsePts[0,*], ellipsePts[1,*], color=ellipse_colors[specnum], psym=3

  xyouts, ellipse_xpos, ellipse_ypos[specnum], ellipse_labels[specnum],$
           /device, color=ellipse_colors[specnum]

device, decomposed=0



    endif

endfor



stretch
device, decomposed=0

save, src, filename=strmid(filelist[catstate.fileindex],4,30)


end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro galcat_openfile

common galcat_state

widget_control, catstate.filelistwidget, get_uvalue=filelist

restore, strmid(filelist[catstate.fileindex],4,30)



;Load the code written in the file
catstate.codes[catstate.fileindex]=src.spectra[0].x_int[0]


;Set the value of the code that is in the state structure

case catstate.codes[catstate.fileindex] of

0: widget_control, catstate.buttonnostatus, set_button=1
1: widget_control, catstate.buttondetection, set_button=1
2: widget_control, catstate.buttonprior, set_button=1
3: widget_control, catstate.buttonmarginal, set_button=1
4: widget_control, catstate.buttonlowsnr, set_button=1
;3: widget_control, catstate.buttonfollowup, set_button=1

else:

endcase

srcname=src.srcname
nspec=n_elements(src.spectra)

isophote=['']
for j=0, nspec-1 do isophote=[isophote,strcompress(long(src.spectra[j].isophot), /remove_all)]
isophote=isophote[1:n_elements(isophote)-1]

if (catstate.isoindex gt nspec-1) then catstate.isoindex=nspec-1


widget_control, catstate.isolist_id, get_uvalue=self
self->SetValues, isophote, CurrentIndex=catstate.isoindex

specnr=catstate.isoindex

spec=src.spectra[specnr].spec
velarr=src.spectra[specnr].velarr
weight=src.spectra[specnr].weight

nchn=n_elements(spec)

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']

ymin=-1.2*(max(src.spectra[specnr].peak_flx))
ymax=1.7*(max(src.spectra[specnr].peak_flx))
;ymax=1.3*src.spectra[specnr].rmsP*src.spectra[specnr].ston[0]


fwhm=nspec-2

;5 is the FWHM?? as of Apirl it is now element 0
vmin=min(velarr)
vmax=max(velarr)

charsize=1.1

widget_control, catstate.mainplotwindow, get_value=index
wset, index

plot,velarr,spec,xrange=[vmin,vmax],yrange=[ymin,ymax],xstyle=1,ystyle=1,position=[0.10,0.25,0.95,0.92], $
     ytitle='Flux Density [mJy]',title='HI'+srcname+ '   '+isophote[specnr]+' mJy km/s level', $
     charsize=charsize, xtickn=[' ',' ',' ',' ',' ',' ',' ']
oplot,velarr,fltarr(nchn),linestyle=1
device, decomposed=1
if (src.spectra[specnr].vcen[2] ne 0.0) then flag, src.spectra[specnr].vcen[2], color='0000FF'XL
if (src.spectra[specnr].vcen[2] eq 0.0) then flag, src.spectra[specnr].vcen[3], color='0000FF'XL
device, decomposed=0

weight=weight/max(weight)
plot,velarr,weight,xrange=[vmin,vmax],yrange=[0.0,1.2],xstyle=1,ystyle=1,position=[0.10,0.12,0.95,0.25], $
     xtitle='Velocity [km/s]',ytitle='Weight',charsize=charsize,linestyle=2, /noerase, xtickformat='(i5)'


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Fill in the text display with measurements and parameters from
;source file.

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

; get ellipse
totf=src.srccube.totf
nbx=n_elements(totf[*,0])
nby=n_elements(totf[0,*])
nchn=n_elements(spec)
indices=where(totf gt isophot,npx)

; Get and determine errors

vstaterr=src.spectra[specnr].vcenerr_stat[0]
   if (vstaterr eq 0.0) then vstaterr=src.spectra[specnr].vcenerr_stat[3]   ;if zero use gauss result
vsyserr=src.spectra[specnr].vcenerr_sys[0]*src.spectra[specnr].width[0]   ;use width
   if (vsyserr eq 0.0)  then vsyserr=src.spectra[specnr].vcenerr_sys[3]*src.spectra[specnr].width[3]  ;use width value

verr=sqrt((vstaterr)^2+(vsyserr)^2)   ;add computed results in quadrature


wstaterr=src.spectra[specnr].widtherr[0]
   if (wstaterr eq 0.0) then wstaterr=src.spectra[specnr].widtherr[3]   ;if zero use gauss result
wsyserr=src.spectra[specnr].widtherr[4]*src.spectra[specnr].width[0]
   if (wsyserr eq 0.0) then wsyserr=src.spectra[specnr].widtherr[5]*src.spectra[specnr].width[3]

werr=sqrt((wstaterr)^2+(wsyserr)^2)   ;add computed results in quadrature

fluxstaterr=src.spectra[specnr].flux_specP_err_stat/1000.0
   if (fluxstaterr eq 0.0) then fluxstaterr=src.spectra[specnr].flux_specG_err_stat/1000.0   ;if zero use gauss result
fluxsyserr=src.spectra[specnr].flux_specP_err_sys/1000.0    ;Don't need to convert to Jy km/s
   if (fluxsyserr eq 0.0)  then fluxsyserr=src.spectra[specnr].flux_specG_err_sys/1000.0

fluxerr=sqrt((fluxstaterr)^2+(fluxsyserr)^2)   ;add computed results in quadrature


; convert to string

sv50=strtrim(string(V50,W50,werr,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sv20=strtrim(string(V20,W20,werr,format='(2f7.1,"+/-",f5.1,"  km/s")'))
svcen=strtrim(string(Vcen,verr,format='(f7.1,"+/-",f5.1,"  km/s")'))
svG=strtrim(string(Vgauss,Wgauss,WerrG,format='(2f7.1,"+/-",f5.1,"  km/s")'))
sstotP=strtrim(string(Stot_specP/1000.,Stot_specP_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
sstotG=strtrim(string(Stot_specG/1000.,Stot_specG_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
smeans=strtrim(string(mean_flx,max(peak_flx),format='(2f6.1,"  mJy")'))
srms=strtrim(string(max([rmsP,rmsG]),format='(f5.2," mJy")'))
sstnP=strtrim(string(stn[0],stn[1],stn[2],stn[3],format='(4f7.1)'))
sstnG=strtrim(string(stn[4],stn[5],stn[6],stn[7],format='(4f7.1)'))
scont=strtrim(string(cont,format='(f5.0,"  mJy")'))

ellipse=strtrim(string(a_ell,b_ell,PA_ell,format='(f4.1," x ",f4.1,"  PA=",f5.0)'))
sstotm=strtrim(string(Stot_map/1000.,Stot_map_err/1000.,format='(f7.2,"+/-",f5.2,"  Jy km/s")'))
ssiso=strtrim(string(isophot,format='(f5.0,"  mJy km/s")'))
snpix=strtrim(string(npix_ell,format='(i4)'))
smapsmax=strtrim(string(map_smax,format='(f5.0,"  mJy km/s")'))

rdopt=radec_to_name(src.spectra[specnr].RA_opt,src.spectra[specnr].Dec_opt)

deltaRA= (src.spectra[specnr].RA_opt-ra_ell)*60.0  ;minutes
deltaDEC=(src.spectra[specnr].DEC_opt-dec_ell)*60.0  ;minutes
raunits='min'
decunits='arcmin'


if (abs(deltara) lt 1.0) then begin
    deltara=deltara*60.0
    raunits='sec'
endif

if (abs(deltadec) lt 1.0) then begin
    deltadec=deltadec*60.0
    decunits='arcsec'
endif


;Compute galactic coordinates
glactc,RA_cen, DEC_cen, 2000, l,b,1

lbcoords='('+string(l,format='(f6.2)')+', '+string(b,format='(f6.2)')+') degrees'

outstring=['HI'+srcname+'                                 (l,b)= '+lbcoords, $
'V50,W50:          '+sv50+  '    Cen_ell:  '+radec_ell+' [2000]', $
'V20,W20:          '+sv20+  '    Opt pos:  '+rdopt+' [2000]', $
'Vcen:             '+svcen+ '           dRA: '+strtrim(string(deltaRA, format='(f9.5)'))+' '+raunits, $
'V,W Gauss:        '+svg+   '    dDec: '+strtrim(string(deltaDEC, format='(f6.2)'))+' '+decunits,$
'Stot(profile, P): '+sstotP+'        Ellipse:  '+ellipse, $
'Stot(profile, G): '+sstotG+'        Isophote: '+ssiso,$
'Map Stot:         '+sstotm+'        Map Smax: '+smapsmax, $
'meanS, peakS:     '+smeans+'               rms: '+srms  , $
'S/N P:            '+sstnP, $
'S/N G:            '+sstnG, $ 
'Cont:             '+scont+'                     AGC'+src.spectra[specnr].agcnr, $
'Status Code:      '+strcompress(catstate.codes[catstate.fileindex], /remove_all)]



widget_control, catstate.textdisplay, set_value=outstring

widget_control, catstate.commentsdisplay, set_value=src.comments

widget_control, catstate.optcoords, set_value=rdopt
if (stn[0] ne 0.0) then widget_control, catstate.snr, set_value=string(stn[0], format='(f7.1)')
if (stn[0] eq 0.0) then widget_control, catstate.snr, set_value=string(stn[4], format='(f7.1)')

agcoptcz='no cz'

if (src.spectra[0].agcnr ne '') then begin
   agcnum_long=long(src.spectra[0].agcnr)
   agclocation=where(catstate.agc.agcnumber eq agcnum_long)
   if (agclocation[0] ne -1) then begin
       agcoptcz=strcompress(catstate.agc.vopt[agclocation], /remove_all)
       
       if (catstate.agc.vopt[agclocation] eq 0) then agcoptcz='no cz'

   endif

endif


widget_control, catstate.velerrstat, set_value=strcompress(vstaterr, /remove_all)
widget_control, catstate.velerrsys,  set_value=strcompress(vsyserr, /remove_all)
widget_control, catstate.widtherrstat, set_value=strcompress(wstaterr, /remove_all)
widget_control, catstate.widtherrsys,  set_value=strcompress(wsyserr, /remove_all)
widget_control, catstate.agcnumber,  set_value=strcompress(src.spectra[0].agcnr, /remove_all)
widget_control, catstate.agcoptcz, set_value=agcoptcz

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Make the map plot with ellipses
widget_control, catstate.cubewindow, get_value=index
wset, index

plot, [0,0], /nodata, xrange=[n_elements(src.srccube.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5,n_elements(src.srccube.dbox[0,0,*])-0.5] , $
             xtitle='X pixel', ytitle='Y pixel', xstyle=1, ystyle=1

PX = !X.WINDOW * !D.X_VSIZE 
PY = !Y.WINDOW * !D.Y_VSIZE
SX = PX[1] - PX[0] + 1 
SY = PY[1] - PY[0] + 1

loadct, 1, /silent

;Display HI map with tvscl procedure
tvscl, reverse(congrid(src.srccube.totf, sx,sy)), px[0], py[0]

;print, sx, sy, px[0], py[0]

plot, [0,0], /nodata, xrange=[n_elements(src.srccube.dbox[0,*,0])-0.5,-0.5], yrange=[-0.5, n_elements(src.srccube.dbox[0,0,*])-0.5], $
             xtitle='X pixel', ytitle='Y pixel', /noerase, xstyle=1, ystyle=1





for specnum=0, nspec-1 do begin

;isophote=['100', '200', '300', '500', '1000', 'FWHM', 'FWQM', 'Custom']




a_ell=src.spectra[specnum].a_ell
b_ell=src.spectra[specnum].b_ell
PA_ell=src.spectra[specnum].PA_ell

dims=size(reform(src.srccube.dbox[0,*,*]),/dimensions)

fmax=max(src.srccube.totf,index)
xpxpk=index mod dims[0]
ypxpk=index/dims[0]

device, decomposed=1
;Mark the maximum value
plotsym, 0, /fill
plots, round(xpxpk),round(ypxpk), psym=7, symsize=2, thick=2.0, color='000000'XL, /data   ; Black

;ellipse_colors=[239,223,208,31,111,255,160,63]
;PINK, GOLD, YELLOW, MAGENTA, CYAN, RED, GREEN, WHITE for custom
ellipse_colors=['00BBFF'XL, '7F7FFF'XL, '00FFFF'XL, 'FF00FF'XL, 'FFFF00'XL, '0000FF'XL, '00FF00'XL, 'FFFFFF'XL]
ellipse_labels=isophote

;Units of device coorindates
ellipse_xpos=5
ellipse_ypos=[105,90,75,60,45,30,15,-200]

if (nspec eq 7) then ellipse_ypos[7]=5

xyouts, 5,120, 'Contour', /device




iso=[0.5*fmax, 0.25*fmax,100.,200.,300.,500.,1000, -1]

indices=where(src.srccube.totf gt iso[specnum],ncount)
    if (ncount gt 4) then begin
        
  ellipsePts=fit_ellipse(indices,xsize=src.srccube.nbx,ysize=src.srccube.nby,axes=axes,orientation=orientation,center=center, npoints=500)
 
  oplot,ellipsePts[0,*], ellipsePts[1,*], color=ellipse_colors[specnum], psym=3

  xyouts, ellipse_xpos, ellipse_ypos[specnum], ellipse_labels[specnum],$
           /device, color=ellipse_colors[specnum]

device, decomposed=0



    endif

endfor



stretch
device, decomposed=0

;-------------------------Query DSS and Sloan-------------

widget_control, catstate.baseID, hourglass=1

rahr=RA_ell
decdeg=Dec_ell

;rahr=  (src.srccube.rabox[n_elements(src.srccube.rabox)-1]-src.srccube.rabox[0])/2.0+$
;          src.srccube.rabox[0]
;decdeg=(gfstate.dec[ury]-gfstate.dec[lly])/2.0+gfstate.dec[lly]
;decdeg=(src.srccube.decbox[n_elements(src.srccube.decbox)-1]-src.srccube.decbox[0])/2.0+$
;          src.srccube.decbox[0]

;xrange=[src.srccube.rabox[n_elements(src.srccube.rabox)-1],src.srccube.rabox[0]]
;yrange=[src.srccube.decbox[0],src.srccube.decbox[n_elements(src.srccube.decbox)-1]]




imagesize=4.0
;imagesize=(max(src.srccube.decbox)-min(src.srccube.decbox))*60.0  ;units of arcminutes

cosdec=cos(decdeg*!dpi/180.0)
xrange=[rahr+(imagesize/2.0)/60.0/15.0/cosdec,rahr-(imagesize/2.0)/60.0/15.0/cosdec]
yrange=[decdeg-imagesize/60.0/2.0, decdeg+imagesize/60.0/2.0]

widget_control, catstate.imagedisplay, get_value=index
wset, index

plot, [0,0], /nodata, xrange=xrange, $
                      yrange=yrange , $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1


if (catstate.currentsurvey eq 'dss2blue') then begin

;Both coords must be in decimal degrees
  ;Get optical image from DSS 2 Blue
   coords=[rahr*15.0,decdeg]
  querydss, coords, opticaldssimage, Hdr, survey='2b', imsize=imagesize
   
   if (opticaldssimage[0] ne 0) then catstate.dss2blueimage=congrid(opticaldssimage, 218,236)




stretch, 100,0
tvscl, catstate.dss2blueimage,60.0015,40.0015
stretch


endif

if (catstate.currentsurvey eq 'sloan') then begin


;url='http://casjobs.sdss.org/ImgCutoutDR6/getjpeg.aspx?ra='+$
;                    strcompress(rahr*15.0, /remove_all)+$
;                    '&dec='+strcompress(decdeg, /remove_all)+$
;                    '&scale='+strcompress(imagesize/6.67,/remove_all)+$
;                    '&opt=I&width=400&height=400'
; modified def of "url" above to "if" statment  below -  RG 22jun2012
        if (rahr gt 20) or (rahr lt 5) and (decdeg gt 1) then $
           url='http://skyservice.pha.jhu.edu/DR8/ImgCutout/getjpeg.aspx?ra='+$
                    strcompress(rahr*15.0, /remove_all)+$
                    '&dec='+strcompress(decdeg, /remove_all)+$
                    '&scale='+strcompress(imagesize/6.67,/remove_all)+$
                    '&opt=I&width=400&height=400' $
	   else $
           url='http://casjobs.sdss.org/ImgCutoutDR7/getjpeg.aspx?ra='+$
                    strcompress(rahr*15.0, /remove_all)+$
                    '&dec='+strcompress(decdeg, /remove_all)+$
                    '&scale='+strcompress(imagesize/6.67,/remove_all)+$
                    '&opt=I&width=400&height=400'
         print,url

filename='~/12junksdss.jpg'
         spawn, 'wget -q -O '+ filename + " '" + url + "'"
         spawn, 'convert '+filename+' '+filename
         read_jpeg, filename, sloanimage, true=1
         spawn, '/bin/rm -r ~/12junksdss.jpg'

catstate.sloanimage=congrid(sloanimage,3,218,236)

;stretch, 225,0

tv, catstate.sloanimage, 60.0015,40.0015,true=1
;stretch

endif

plot, [0,0], /nodata, xrange=xrange, $
                      yrange=yrange, $
             xtitle='RA hours', ytitle='Dec degrees', xstyle=1, ystyle=1, /noerase


;Plot the HI detection


RA_ell=src.spectra[specnr].RA_ell
Dec_ell=src.spectra[specnr].Dec_ell

device, decomposed=1
oplot, [RA_ell], [Dec_ell], psym=1, color='0000FF'XL
plotsym, 0
oplot, [src.spectra[specnr].RA_opt],[src.spectra[specnr].Dec_opt], psym=8, color='0000FF'XL
xyouts, 5,285, '+ HI ellipse centroid  o Optical position   4 arcmin img', color='0000FF'XL, /device
device, decomposed=0


widget_control, catstate.baseID, hourglass=0


;-----------------------------------------------
;Query the sloan database

query='"SELECT p.objID,p.ra,p.dec FROM PhotoObj p WHERE '

c=double(299792.458)
if (src.spectra[specnr].vcen[2] ne 0.0) then redshift=src.spectra[specnr].vcen[2]/c
if (src.spectra[specnr].vcen[2] eq 0.0) then redshift=src.spectra[specnr].vcen[3]/c

coordstring='p.ra < '+strcompress(rahr*15.0+5./60.0, /remove_all)+' AND '+$
            'p.ra > '+ strcompress(rahr*15.0-5./60.0, /remove_all)+ ' AND '+$
            'p.dec < '+ strcompress(decdeg+5./60.0, /remove_all)+ ' AND '+$
            'p.dec > '+ strcompress(decdeg-5./60.0, /remove_all)
;            's.z < '  + strcompress(redshift-0.0016, /remove_all)+ ' AND '+$
;            's.z > '  + strcompress(redshift+0.0016, /remove_all)

;query=query+' '+coordstring+' AND p.type=3"'+' -f csv > ~/testsdss42.csv'

;query='~/pythonwork/sqlcl.py -q '+query

;conecall, str=str, url='http://skyserver.sdss.org/vo/dr4cone/sdssConeSearch.asmx/ConeSearch?', rahr*15.0, decdeg, 0.1

;print, str

;print, query

;spawn, query

;readcol, '~/testsdss42.csv', objID, ra,dec,SpecObjID,SpecObjID,z,zErr, delimiter=',',skipline=1

;print, objID

;spawn, '/bin/rm -r ~/testsdss42.csv'

widget_control, catstate.filelistwidget, set_list_top=catstate.fileindex

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro galcat

common galcat_state, catstate

;Get files in directory
; spawn,'ls HI*.src',filelist
  spawn, 'find . -maxdepth 1 -name "HI*.src" | sort -n', filelist
      IF filelist[0] eq '' THEN BEGIN
         filelist[0]='No HI files in this directory'
      ENDIF ELSE BEGIN
          for i=0, n_elements(filelist)-1 do begin
              filelist[i]=strmid(filelist[i],2)
          endfor
      ENDELSE




codes=intarr(n_elements(filelist))

;Read the quality codes
for i=0, n_elements(codes)-1 do begin
   restore, filelist[i]
     ;Load the code written in the file
   codes[i]=src.spectra[0].x_int[0]
endfor

filelist='('+strcompress(codes, /remove_all)+') '+filelist

;Open current AGC catalog
common agcshare, agcdir
restore, agcdir+'agcnorthminus1.sav'

rahr=double(agcnorthminus1.rah)+double(agcnorthminus1.ram)/double(60.0)+double(agcnorthminus1.ras10)/(10.0D)/3600.0D
decdeg=abs(double(agcnorthminus1.decd))+double(agcnorthminus1.decm)/double(60.0)+double(agcnorthminus1.decs)/3600.0D
signs=where(agcnorthminus1.sign eq '-')
if (signs[0] ne -1) then decdeg[signs]=-decdeg[signs]


catstate={baseID:0L, $         ;ID of base widget
         fmenu:0L, $          ;ID of file menu
         helpmenu:0L, $         ;ID of help menu
         filelistwidget:0L, $
         textdisplay:0L, $
         commentsdisplay:0L, $
         cubewindow:0L, $
         mainplotwindow:0L, $
         imagedisplay:0L, $
         fileindex:0L, $
         isoindex:0L, $
         isolist:0L, $
         isolist_id:0L, $
         buttonnostatus:0L, $
         buttondetection:0L, $
         buttonprior:0L, $
         buttonmarginal:0L, $
         buttonlowsnr:0L, $
	 buttonpriorminus:0L, $
         buttonhvc:0L, $
         buttonfollowup:0L, $
         codes:codes, $
         snr:0L, $
         optcoords:0L, $
         dss2blueimage:dblarr(218,236), $
         sloanimage:dblarr(3,218,236), $
         currentsurvey:'sloan', $
         sloanmenu:0L, $
         dss2bluemenu:0L, $
         velerrstat:0L, $
         velerrsys:0L, $
         widtherrstat:0L, $
         widtherrsys:0L, $
         agcnumber:0L, $
         agcoptcz:0L, $
         agc:agcnorthminus1, $
         rahr:rahr, $
         decdeg:decdeg}
        

  
     

if (not (xregistered('galcat', /noshow))) then begin



;WIDGET LAYOUT

;Top level base
tlb=widget_base(/column, title='ALFALFA Catalog creator', $
                tlb_frame_attr=1, xsize=1240, ysize=730, mbar=top_menu, $
                uvalue='tlb')

;Menu options

catstate.fmenu=widget_button(top_menu, value=' File ')
  buttonHTML=widget_button(catstate.fmenu, value=' Export HTML ', uvalue='exporthtml')
  buttonCSV=widget_button(catstate.fmenu, value=' Export CSV ', uvalue='exportcsv')
  buttonFORMAT=widget_button(catstate.fmenu, value= ' Export Catalog ', uvalue='exportformat')
  buttonMARKED=widget_button(catstate.fmenu, value= ' Export Marked Objects ', uvalue='exportmarked')
  buttonexit=widget_button(catstate.fmenu, value=' Exit ', /separator, $
                           event_pro='galcat_exit')

imagemenu=widget_button(top_menu, value=' Imaging ')
  catstate.sloanmenu=widget_button(imagemenu, value=' Sloan DSS ', uvalue='sloan', /Checked_Menu)
  catstate.dss2bluemenu=widget_button(imagemenu, value=' DSS 2 Blue ', uvalue='dss2blue', /Checked_Menu)

widget_control, catstate.sloanmenu, set_button=1

;TOP BASE

topbase=widget_base(tlb, xsize=900, ysize=315, /row, /frame)
   catstate.filelistwidget=widget_list(topbase, value=filelist, xsize=36, ysize=10, uvalue=filelist, event_pro='galcat_filelist')

codebase=widget_base(topbase, /column, /align_left)
   label=widget_label(codebase, value='STATUS')


codebuttonbase=widget_base(codebase, /column, /align_left, /exclusive)
        catstate.buttonnostatus=widget_button(codebuttonbase, value='(0) No status', uvalue='0', event_pro='galcat_codes')
        catstate.buttondetection=widget_button(codebuttonbase, value='(1) Detection', uvalue='1', event_pro='galcat_codes')
        catstate.buttonprior=widget_button(codebuttonbase,     value='(2) Prior', uvalue='2', event_pro='galcat_codes')
        catstate.buttonmarginal=widget_button(codebuttonbase, value='(3) Marginal',  uvalue='3', event_pro='galcat_codes')
        catstate.buttonlowsnr=widget_button(codebuttonbase,   value='(4) Low StN ', uvalue='4', event_pro='galcat_codes')
        catstate.buttonpriorminus=widget_button(codebuttonbase,   value='(5) Prior- ', uvalue='5', event_pro='galcat_codes')
        catstate.buttonhvc=widget_button(codebuttonbase,   value='(9) HVC   ', uvalue='9', event_pro='galcat_codes')
        ;catstate.buttonfollowup=widget_button(codebuttonbase, value='Followup',  uvalue='3', event_pro='galcat_codes')
        buttonSelect=widget_button(codebase, value='Mark \ Unmark', event_pro='galcat_markobject')


   displaybase=widget_base(topbase, xsize=525, ysize=290, /column, /align_left)
     catstate.textdisplay = widget_text(displaybase, value = ['',''], xsize = 85, ysize = 14)
     catstate.commentsdisplay = widget_text(displaybase, value=['',''], xsize=85, ysize = 5, /editable, uvalue='commentsdisplay')
   widget_control, catstate.buttonnostatus, set_button=1

   modifybase=widget_base(topbase, xsize=350, ysize=290, /column, /align_left)
    label=widget_label(modifybase, value=' MODIFY PARAMETERS')

    optbase=widget_base(modifybase, xsize=350, /row, /align_left)
      label=widget_label(optbase, value='Optical Coordinates')
      catstate.optcoords=widget_text(optbase, value='000000.0+000000', xsize=17, /editable)
    snrbase=widget_base(modifybase, xsize=350, /row, /align_left)     
      label=widget_label(snrbase, value='       Signal/Noise')
      catstate.snr=widget_text(snrbase, value='000.000', xsize=17, /editable)
      button=widget_button(snrbase, value=' Modify SNR ', uvalue='fixsnr', event_pro='galcat_fixsnr')
    velerrbase=widget_base(modifybase, xsize=350, /row, /align_left)
      label=widget_label(velerrbase, value='    cz Err Stat/Sys')
      catstate.velerrstat=widget_text(velerrbase, value='000.000', xsize=10, /editable, uvalue='velerrstat')
      label=widget_label(velerrbase, value='/')
      catstate.velerrsys=widget_text(velerrbase, value='000.000', xsize=10, /editable, uvalue='velerrsys')
    widtherrbase=widget_base(modifybase, xsize=350, /row, /align_left)
      label=widget_label(widtherrbase, value=' Width Err Stat/Sys')
      catstate.widtherrstat=widget_text(widtherrbase, value='000.000', xsize=10, /editable, uvalue='widtherrstat')
      label=widget_label(widtherrbase, value='/')
      catstate.widtherrsys=widget_text(widtherrbase, value='000.000', xsize=10, /editable, uvalue='widtherrsys')
    agcnumberbase=widget_base(modifybase, xsize=350, /row, /align_left)
      label=widget_label(agcnumberbase, value=' AGC Number        ')
      catstate.agcnumber= widget_text(agcnumberbase, value='000000', xsize=10, /editable, uvalue='agcnumber')
      label=widget_label(agcnumberbase, value='  cz(opt)')
      catstate.agcoptcz=widget_text(agcnumberbase, value='00000', xsize=8, uvalue='agcoptcz')

    buttonbase=widget_base(modifybase, xsize=80, /row)
      label=widget_label(buttonbase, value='                   ')
      button=widget_button(buttonbase, value=' Save Changes ', uvalue='savechanges') 
    agcbuttonbase=widget_base(modifybase, xsize=80, /row)
      label=widget_label(agcbuttonbase, value='                   ')
      button=widget_button(agcbuttonbase, value='View AGC Info ', uvalue='agcinfo') 

lowbase=widget_base(tlb, xsize=1240, ysize=605, /row)

isovals=['0','1','2','3','4','5','6','7']



cubebase=widget_base(lowbase, xsize=300, ysize=500, /column, /align_left)
   ;label=widget_label(cubebase, value='BRIAN')
   catstate.cubewindow=widget_draw(cubebase, xsize=295, ysize=295, /frame, uvalue='cubewindow', /keyboard_events)
   droplist=fsc_droplist(cubebase, value=isovals, $
              uvalue='isolist', index=0, title='Select Isophote: ')

    catstate.isolist_id=droplist->getID()

    

;buttonbase=widget_base(cubebase, /row, xsize=95, ysize=30)
;deletebutton=widget_button(buttonbase, xsize=90, ysize=25, value=' Delete Object ', uvalue='deleteitem')
;testbutton=widget_button(cubebase, value='TEST BUTTON')
catstate.mainplotwindow=widget_draw(lowbase, xsize=600, ysize=310, /frame, uvalue='mainplotwindow', /keyboard_events)

imagebase=widget_base(lowbase, xsize=315, /column)

catstate.imagedisplay=widget_draw(imagebase, xsize=295, ysize=295, /frame, /button_events, uvalue='imagewindow', event_pro='galcat_externaldss')
 button=widget_button(imagebase, value=' SDSS Navigator ', uvalue='opennavigator')
 button=widget_button(imagebase, value='     SkyView    ', uvalue='openskyview')
 button=widget_button(imagebase, value='      NED       ', uvalue='openned', event_pro='galcat_nedgui')
;widget_control, catstate.isolist_id, get_uvalue=self




;Realization
widget_control, tlb, /realize

catstate.baseID=tlb

;Xmanager startup
xmanager, 'galcat', catstate.baseID, /no_block

;runlist, filelist
      


endif


end
