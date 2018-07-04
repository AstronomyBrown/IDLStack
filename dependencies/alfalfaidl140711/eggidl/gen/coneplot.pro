;NAME:
;	WIDGET_CONE_PLOT
;PURPOSE:
; 	Makes EPS cone plots of (1) ALFALFA galaxies in a given RA, DEC range 
;	and (2) AGC galaxies with non-zero optical redshifts LT 18000 km/s in 
;	the same range.	Each plot is labeled ("ALFALFA" or "Opt") with the 
;	number of galaxies in the plot listed.
;
;	NOTE: Requires epsinit.pro and epsterm.pro to be compiled.
;
;CALLING SEQUENCE:
;	WIDGET_CONE_PLOT
;
;OUTPUTS:
;	cone_plot.eps - an EPS plot with the 2 cone plots stacked on top of each
;	other.
;
;NOTES:
;	The command line requires input from the user.
;
;	Next the program grabs the first and last RA from the catalog then
;	calculates the center RA. If two catalogs have been pasted together, 
;	make sure the minimum RA is at the top and the maximum RA is at the
;	bottom.
;
;	The program then searches for the minimum and maximum declination in the
;	catalog and prints these values. The user is then asked if they would
;	like to restrict these values and plot a different region. The default
;	value is do not restrict.
;
;	The program then asks the user if they would like to change the maximum
;	velocity value. If the velocity value is changed, sometimes the angle
;	does not come out correctly but the user is given a chance to adjust
;	the angle when the widget opens. The user should make sure to adjust the
;	angle before placing labels.
;	*Note: a large plotwidth makes a smaller angle*
;
;	The program then asks the user for eps plot width and height values.
;	These values are measured in inches.
;
;
;REGIONS OF CODE THAT MAY NEED ADAPTATION:
;	Labels: Labels for RA minimum, maximum and center are created and can
;		easily be placed anywhere by clicking at the correct position.
;		The program attempts to place each hour in the correct position
;		although this can be difficult and may need minor adjustments.
;		Lines 909, 917, 1029 and 1037 can be adjusted to move the labels
;		up or down.
;
;	Ngal:   A variable called "ngal" can be found in line 117; it defines the
;		maximum number of ALFALFA galaxies that will be read in, so if
;		you have a larger catalog, you'll want to adjust upwards.
;
;	Headers: If a catalog has more than 3 lines of header, adjust line 124
;
;	ALFALFA selection: As defined in lines 215 and 824, ALL galaxies in
;		the ALFALFA catalog coded as 1 or 2 and lying within the correct
;		dec & cz range are included. If your catalog includes objects 
;		outside of your intended RA range, or you want to apply other 
;		criteria, please be sure to edit these lines.
;
;	Optical selection: An optically-selected sample is pulled from the AGC 
;		near line 940. If you want to add magnitude or other limits to
;		your optically-selected AGC sample, do so here.
;
;REVISION HISTORY:
;	Created 2007 A. Saintonge
;	Documented July 2007, Ann Martin
;	Revised July 2009, Tess Senty
;
;-

PRO WIDGET_CONE_PLOT

COMMON SHARE, cindex, cHIname, cagc, cothername, cHIcoords, cdra, cddec,$
coptcoords, chsize, cv50, cverr, cw50, cwerr, csint, cserr, csintmap, csn,$
crms, ccode, cgrid, ramins, ramaxs, racens, czmaxs, decmins, decmaxs, width,$
height, mark_hours, number, thrarr, ralines

;Opens up a window to pick out a catalog to be read
catname=dialog_pickfile(/read, filter='*.dat')

if (catname eq '') then begin
    print, 'no catalog defined'
    cat=''
    read, 'define catalog yourself? (y/n):', cat
    if (cat eq 'y') then begin
        catname=''
        read, 'Which catalog?', catname
    endif
    if (cat ne 'y') then begin
        print, 'no catalog to plot'
        return
    endif
endif

;Asks if the catalog has a header. Default value is no.
header=''
read, 'Does catalog have a header? (y/n):', header

;Asks where to plot constant RA lines.
raline=''
print, 'Would you like your plot to have constant RA lines '
read, 'in the center (c), at each hour (h), or both (b)?:', raline
ralines=raline

;Here you can specify what size you would like your final eps file to be. 
repeat read, 'What width would you like your eps file? (inches):',$
width until n_elements(width gt 0)
repeat read, 'What height would you like your eps file? (inches):',$
height until n_elements(height gt 0)

;Reading in the catalog of galaxies
print,'reading the galaxy catalog'

;Adjust NGAL upward for plots with more than 2000 galaxies.
ngal=2000
openr,lun,catname,/get_lun

;Read catalog with header information at the top. If your catalog has more than
;3 lines of header, adjust.
if (header eq 'y') then begin
    junk='junk'
    for i=0,2 do readf,lun,junk,format='(1a1)'
endif

HIname=strarr(ngal)
agc=lonarr(ngal)
othername=strarr(ngal)
HIcoords=strarr(ngal)
dra=intarr(ngal)
ddec=intarr(ngal)
optcoords=strarr(ngal)
hsize=fltarr(ngal)
v50=intarr(ngal)
verr=intarr(ngal)
w50=intarr(ngal)
werr=intarr(ngal)
sint=fltarr(ngal)
serr=fltarr(ngal)
sintmap=fltarr(ngal)
sn=fltarr(ngal)
rms=fltarr(ngal)
code=intarr(ngal)
grid=strarr(ngal)

f1='HI230252.5+260100'
f2=0L
f3='FGC2452'
f4='230252.5+260100'
f5=0
f6=0
f7='230253.7+260052'
f8=0.0
f9=0
f10=0
f11=0
f12=0
f13=0.0
f14=0.0
f15=0.0
f16=0.0
f17=0.0
f18=0
f19='2308+27'

i=0
while (eof(lun) ne 1) do begin
    readf,lun,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19, $
          format='(1a17, 1i7, 1a9, 1a17, 2i4, 1a17, 1f7.1, 2(1i6,1i5), 1f8.2, 1f6.2, 1f8.2, 1f7.1, 1f6.2, 1i4, 1a12)'
    HIname[i]=f1
    agc[i]=f2
    othername[i]=f3
    HIcoords[i]=f4
    dra[i]=f5
    ddec[i]=f6
    optcoords[i]=f7
    hsize[i]=f8
    v50[i]=f9
    verr[i]=f10
    w50[i]=f11
    werr[i]=f12
    sint[i]=f13
    serr[i]=f14
    sintmap[i]=f15
    sn[i]=f16
    rms[i]=f17
    code[i]=f18
    grid[i]=f19
    i=i+1
endwhile
close,lun
free_lun,lun

HIname=HIname[0:i-1]
agc=agc[0:i-1]
othername=othername[0:i-1]
HIcoords=HIcoords[0:i-1]
dra=dra[0:i-1]
ddec=ddec[0:i-1]
optcoords=optcoords[0:i-1]
hsize=hsize[0:i-1]
v50=v50[0:i-1]
verr=verr[0:i-1]
w50=w50[0:i-1]
werr=werr[0:i-1]
sint=sint[0:i-1]
serr=serr[0:i-1]
sintmap=sintmap[0:i-1]
sn=sn[0:i-1]
rms=rms[0:i-1]
code=code[0:i-1]
grid=grid[0:i-1]

cindex=where(code lt 3)
cHIname=HIname[cindex]
cagc=agc[cindex]
cothername=othername[cindex]
cHIcoords=HIcoords[cindex]
cdra=dra[cindex]
cddec=ddec[cindex]
coptcoords=optcoords[cindex]
chsize=hsize[cindex]
cv50=v50[cindex]
cverr=verr[cindex]
cw50=w50[cindex]
cwerr=werr[cindex]
csint=sint[cindex]
cserr=serr[cindex]
csintmap=sintmap[cindex]
csn=sn[cindex]
crms=rms[cindex]
ccode=code[cindex]
cgrid=grid[cindex]

ngal=n_elements(cindex)
print, ngal

decgal=double(strmid(cHIcoords,10,3))+double(strmid(cHIcoords,13,2))/60.+double(strmid(cHIcoords,15,2))/3600.

ragal=strmid(cHIcoords,2,8)

print, 'Minimum RA (hhmmss.s):', ragal[0]
print, 'Maximum RA (hhmmss.s):', ragal[ngal-1]
ramin=ragal[0]
ramax=ragal[ngal-1]

ramind=(double(strmid(ramin,0,2))+double(strmid(ramin,2,2))/60.+double(strmid(ramin,4,4))/3600.)*15.
ramaxd=(double(strmid(ramax,0,2))+double(strmid(ramax,2,2))/60.+double(strmid(ramax,4,4))/3600.)*15.

if (ramind lt ramaxd) then begin
    racend=((ramaxd-ramind)/2)+ramind
    number=round((ramaxd-ramind)/15.)-1
endif

if (ramind gt ramaxd) then begin
    racend=((ramaxd+360-ramind)/2.)+ramind
    number=round((ramaxd+360-ramind)/15.)-1
endif

if (racend gt 360) then begin
    racend=racend-360
endif

mark_hours=dblarr(number)

for i=1,number do begin
    mark_hours[i-1]=((15*i+ramind)-racend)*!pi/180.+!pi/2.
    thrarr=rebin(mark_hours, 1000*number,/sample)
endfor

;Asks if a new range of DEC should be used rather than the minimum and maximum 
;values of the catalog. Default is no.
print, 'Minimum DEC (degrees):', min(decgal)
print, 'Maximum DEC (degrees):', max(decgal)

restrict_DEC='n'
read, 'Restrict? (y/n):',restrict_DEC

if (restrict_DEC eq 'y') then begin
    read, 'new minimum DEC (degrees):', decmins
    read, 'new maximum DEC (degrees):', decmaxs
    print, decmins, decmaxs
endif

if (restrict_DEC ne 'y') then begin
    decmins=min(decgal)
    decmaxs=max(decgal)
endif

;Asks if a new velocity should be used rather than 18000 which is default.
change='n'
read, 'Default maximum cz=18000, change? (y/n):', change

if (change eq 'y') then begin
    read, 'new max cz:', czmax
endif

if (change ne 'y') then begin
    czmax=18000
endif

ramins=ramind/15.
ramaxs=ramaxd/15.
racens=racend/15.

czmaxs=czmax
czmaxstring=string(czmax)
plotheight=czmax+2000
plotheight=string(plotheight)

;Create base widget
tlb=widget_base(column=1, tlb_frame_attr=1)

base1=widget_base(tlb, column=2)
base2=widget_base(base1,column=1)

;Plot Width defines how wide the plot should be in the x-axis direction. The 
;units for this are velocity. The larger you make the plot width, the smaller
;you make the width of the plot, the larger the angle will be.
base9=widget_base(base2, row=1, /grid_layout, frame=1)
label29=widget_label(base9,value='Plot Width')
ftext29=widget_text(base9, value=czmaxstring, /editable)

;These are text widgets for coordiniate locations for the labels. The units are 
;in "normal" coordinates.
base10=widget_base(base2, row=4)
label=widget_label(base10, value='ALFALFA')
base3=widget_base(base10, row=3, /grid_layout, frame=1)
label1=widget_label(base3,value='RA max')
ftext1=widget_text(base3, value='64', /editable)
ftext2=widget_text(base3, value='916', /editable)
label3=widget_label(base3,value='RA center')
ftext3=widget_text(base3,value='397', /editable)
ftext4=widget_text(base3, value='972',/editable)
label5=widget_label(base3,value='RA min')
ftext5=widget_text(base3,value='728', /editable)
ftext6=widget_text(base3,value='916', /editable)

base4=widget_base(base10, row=3, /grid_layout, frame=1)
label7=widget_label(base4,value='cz max')
ftext7=widget_text(base4, value='63', /editable)
ftext8=widget_text(base4, value='817', /editable)
label9=widget_label(base4,value='cz center')
ftext9=widget_text(base4,value='158', /editable)
ftext10=widget_text(base4, value='719',/editable)
label11=widget_label(base4,value='cz min')
ftext11=widget_text(base4,value='268', /editable)
ftext12=widget_text(base4,value='631', /editable)

base5=widget_base(base10, row=1, /grid_layout, frame=1)
label7=widget_label(base5,value='ALFALFA label')
ftext13=widget_text(base5, value='100', /editable)
ftext14=widget_text(base5, value='629', /editable)

base11=widget_base(base2, row=4)
label=widget_label(base11, value='Optical')
base6=widget_base(base11, row=3, /grid_layout, frame=1)
label15=widget_label(base6,value='RA max')
ftext15=widget_text(base6, value='64', /editable)
ftext16=widget_text(base6, value='406', /editable)
label17=widget_label(base6,value='RA center')
ftext17=widget_text(base6,value='397', /editable)
ftext18=widget_text(base6, value='464',/editable)
label19=widget_label(base6,value='RA min')
ftext19=widget_text(base6,value='728', /editable)
ftext20=widget_text(base6,value='406', /editable)

base7=widget_base(base11, row=3, /grid_layout, frame=1)
label21=widget_label(base7,value='cz max')
ftext21=widget_text(base7, value='63', /editable)
ftext22=widget_text(base7, value='298', /editable)
label23=widget_label(base7,value='cz center')
ftext23=widget_text(base7,value='158', /editable)
ftext24=widget_text(base7, value='207',/editable)
label25=widget_label(base7,value='cz min')
ftext25=widget_text(base7,value='268', /editable)
ftext26=widget_text(base7,value='120', /editable)

base8=widget_base(base11, row=1, /grid_layout, frame=1)
label27=widget_label(base8,value='Optical label')
ftext27=widget_text(base8, value='100', /editable)
ftext28=widget_text(base8, value='112', /editable)

;This draw widget contains the cone plot. When the draw widget is clicked, the
;coordinate location of the mouse click is displayed on the bottom of the
;window. This allows for someone to click where they want the labels to be
;located and then type in the coordinates in the text boxes.
draw=widget_draw(base1, xsize=768, ysize=1024, y_scroll_size=800, x_scroll_size=768, uvalue='Draw', /button_events)

;This is the coordinate display and the buttons.
buttbase1=widget_base(tlb, row=2, /align_center)
label=widget_label(buttbase1, value='X: Y:', /align_center, /dynamic_resize)
buttbase2=widget_base(buttbase1, column=3, /align_center)
butt4=widget_button(buttbase2, value='Refresh', uvalue='Refresh', /align_center, xsize=75)
butt2=widget_button(buttbase2, value='Save', uvalue='Save', /align_center, xsize=75)
butt3=widget_button(buttbase2, value='Exit', uvalue='Exit', /align_center, xsize=75)

;Realize widgets and get draw window index
widget_control, tlb, /realize
widget_control, draw, get_value=winid
wset, winid
coneplot,64, 916, 397, 974, 728, 916, 63, 817, 158, 207, 268, 631, 100, $
629, 64, 406, 397, 464, 728, 406, 63, 298, 158, 207, 268, 120, 100, 112, czmax

;Create and store information structure
info={text1:ftext1, text2:ftext2, text3:ftext3, text4:ftext4, text5:ftext5, $
text6:ftext6, text7:ftext7, text8:ftext8, text9:ftext9, text10:ftext10, $
text11:ftext11, text12:ftext12, text13:ftext13, text14:ftext14, text15:ftext15,$
text16:ftext16, text17:ftext17, text18:ftext18, text19:ftext19, text20:ftext20,$
text21:ftext21, text22:ftext22, text23:ftext23, text24:ftext24, text25:ftext25,$
text26:ftext26, text27:ftext27, text28:ftext28, text29:ftext29, winid:winid,$
label:label, x:-1L, y:-1L}
infoptr=ptr_new(info)
widget_control, tlb,set_uvalue=infoptr

;Start managing events
xmanager, 'widget_cone_plot', tlb, cleanup='widget_cone_plot_cleanup', /no_block

END

PRO WIDGET_CONE_PLOT_EVENT, EVENT

COMMON SHARE

czmax=czmaxs
ramin=ramins
ramax=ramaxs
racen=racens
decmin=decmins
decmax=decmaxs

zax=findgen(1000)*(czmax/1000.)

;Get information structure
widget_control, event.top, get_uvalue=infoptr
info=*infoptr

;Get widget identity
widget_control, event.id, get_uvalue=widget

;Handle events
case widget of

    'Refresh':begin
        ;erases the draw window, replots the cone plot and displays the labels
        ;in the new coordinate locations.
        wset, info.winid
        erase
        ;Collects coordinate information from text widgets.
        text1=info.text1
        text2=info.text2
        text3=info.text3
        text4=info.text4
        text5=info.text5
        text6=info.text6
        text7=info.text7
        text8=info.text8
        text9=info.text9
        text10=info.text10
        text11=info.text11
        text12=info.text12
        text13=info.text13
        text14=info.text14
        text15=info.text15
        text16=info.text16
        text17=info.text17
        text18=info.text18
        text19=info.text19
        text20=info.text20
        text21=info.text21
        text22=info.text22
        text23=info.text23
        text24=info.text24
        text25=info.text25
        text26=info.text26
        text27=info.text27
        text28=info.text28
        text29=info.text29
        widget_control, text1, get_value=raxmax
        widget_control, text2, get_value=raymax
        widget_control, text3, get_value=raxcen
        widget_control, text4, get_value=raycen
        widget_control, text5, get_value=raxmin
        widget_control, text6, get_value=raymin
        widget_control, text7, get_value=czxmax
        widget_control, text8, get_value=czymax
        widget_control, text9, get_value=czxcen
        widget_control, text10, get_value=czycen
        widget_control, text11, get_value=czxmin
        widget_control, text12, get_value=czymin
        widget_control, text13, get_value=alfx
        widget_control, text14, get_value=alfy
        widget_control, text15, get_value=optraxmax
        widget_control, text16, get_value=optraymax
        widget_control, text17, get_value=optraxcen
        widget_control, text18, get_value=optraycen
        widget_control, text19, get_value=optraxmin
        widget_control, text20, get_value=optraymin
        widget_control, text21, get_value=optczxmax
        widget_control, text22, get_value=optczymax
        widget_control, text23, get_value=optczxcen
        widget_control, text24, get_value=optczycen
        widget_control, text25, get_value=optczxmin
        widget_control, text26, get_value=optczymin
        widget_control, text27, get_value=optalfx
        widget_control, text28, get_value=optalfy
        widget_control, text29, get_value=plotwidths
        ;Calls coneplot
        coneplot,raxmax, raymax, raxcen, raycen, raxmin, raymin, czxmax, czymax, czxcen, czycen, czxmin, czymin, alfx, alfy, optraxmax, optraymax, optraxcen, optraycen, optraxmin, optraymin, optczxmax, optczymax, optczxcen, optczycen, optczxmin, optczymin, optalfx, optalfy, plotwidths
    end

    'Save':begin
        ;Collects coordinate information from text widgets.
        text1=info.text1
        text2=info.text2
        text3=info.text3
        text4=info.text4
        text5=info.text5
        text6=info.text6
        text7=info.text7
        text8=info.text8
        text9=info.text9
        text10=info.text10
        text11=info.text11
        text12=info.text12
        text13=info.text13
        text14=info.text14
        text15=info.text15
        text16=info.text16
        text17=info.text17
        text18=info.text18
        text19=info.text19
        text20=info.text20
        text21=info.text21
        text22=info.text22
        text23=info.text23
        text24=info.text24
        text25=info.text25
        text26=info.text26
        text27=info.text27
        text28=info.text28
        text29=info.text29
        widget_control, text1, get_value=raxmax
        widget_control, text2, get_value=raymax
        widget_control, text3, get_value=raxcen
        widget_control, text4, get_value=raycen
        widget_control, text5, get_value=raxmin
        widget_control, text6, get_value=raymin
        widget_control, text7, get_value=czxmax
        widget_control, text8, get_value=czymax
        widget_control, text9, get_value=czxcen
        widget_control, text10, get_value=czycen
        widget_control, text11, get_value=czxmin
        widget_control, text12, get_value=czymin
        widget_control, text13, get_value=alfx
        widget_control, text14, get_value=alfy
        widget_control, text15, get_value=optraxmax
        widget_control, text16, get_value=optraymax
        widget_control, text17, get_value=optraxcen
        widget_control, text18, get_value=optraycen
        widget_control, text19, get_value=optraxmin
        widget_control, text20, get_value=optraymin
        widget_control, text21, get_value=optczxmax
        widget_control, text22, get_value=optczymax
        widget_control, text23, get_value=optczxcen
        widget_control, text24, get_value=optczycen
        widget_control, text25, get_value=optczxmin
        widget_control, text26, get_value=optczymin
        widget_control, text27, get_value=optalfx
        widget_control, text28, get_value=optalfy
        widget_control, text29, get_value=plotwidths
        ;Saves the cone plot to an eps file in the current directory.
        !p.multi=[0,1,2,0,0]
        epsinit,'cone_plot.eps', xsize=width, ysize=height ,/VECTOR
        coneplot,raxmax, raymax, raxcen, raycen, raxmin, raymin, czxmax, $
            czymax, czxcen, czycen, czxmin, czymin, alfx, alfy, optraxmax, $
            optraymax, optraxcen, optraycen, optraxmin, optraymin, optczxmax, $
            optczymax, optczxcen, optczycen, optczxmin, optczymin, optalfx, $
            optalfy, plotwidths
        epsterm
    end

    'Draw':begin
        ;Handle button press events (define position)
        if (event.press gt 0) then begin
            widget_control, event.id, draw_motion_events=0
            info.x=event.x
            info.y=event.y
        endif

        ;Update the label widget
        label_text=string(info.x, info.y, format='("X:", i3, 1x, "Y:", i4)')
        widget_control, info.label, set_value=label_text

    end

    'Exit': begin
        widget_control, event.top, /destroy
    end

    else:print, 'Unrecognized event:', widget

endcase

;Update state information
if (widget ne 'Exit') then begin
    *infoptr=info
endif

END

PRO WIDGET_CONE_PLOT_CLEANUP, ID

widget_control, id, get_uvalue=infoptr
ptr_free, infoptr

END

;The following program is the entire coneplot. It is called when ever 'refresh'
;or 'save' are hit. If the angle does not come up correctly, the first time this
;program is called would be the best time to re-size it (ie before the labels 
;are all placed otherwise you will need to replace them).

PRO CONEPLOT,raxmax, raymax, raxcen, raycen, raxmin, raymin, czxmax, czymax, $
czxcen, czycen, czxmin, czymin, alfx, alfy, optraxmax, optraymax, optraxcen, $
optraycen, optraxmin, optraymin, optczxmax, optczymax, optczxcen, optczycen, $
optczxmin, optczymin, optalfx, optalfy, plotwidths

COMMON SHARE

ramin=ramins
ramax=ramaxs
racen=racens
decmin=decmins
decmax=decmaxs
czmax=czmaxs

vx=768.
vy=1024.

nraxmax=float(raxmax)
nraymax=float(raymax)
nraxcen=float(raxcen)
nraycen=float(raycen)
nraxmin=float(raxmin)
nraymin=float(raymin)
nczxmax=float(czxmax)
nczymax=float(czymax)
nczxcen=float(czxcen)
nczycen=float(czycen)
nczxmin=float(czxmin)
nczymin=float(czymin)
nalfx=float(alfx)
nalfy=float(alfy)
noptraxmax=float(optraxmax)
noptraymax=float(optraymax)
noptraxcen=float(optraxcen)
noptraycen=float(optraycen)
noptraxmin=float(optraxmin)
noptraymin=float(optraymin)
noptczxmax=float(optczxmax)
noptczymax=float(optczymax)
noptczxcen=float(optczxcen)
noptczycen=float(optczycen)
noptczxmin=float(optczxmin)
noptczymin=float(optczymin)
noptalfx=float(optalfx)
noptalfy=float(optalfy)
nplotwidth=float(plotwidths)

nraxmax=nraxmax[0]
nraymax=nraymax[0]
nraxcen=nraxcen[0]
nraycen=nraycen[0]
nraxmin=nraxmin[0]
nraymin=nraymin[0]
nczxmax=nczxmax[0]
nczymax=nczymax[0]
nczxcen=nczxcen[0]
nczycen=nczycen[0]
nczxmin=nczxmin[0]
nczymin=nczymin[0]
nalfx=nalfx[0]
nalfy=nalfy[0]
noptraxmax=noptraxmax[0]
noptraymax=noptraymax[0]
noptraxcen=noptraxcen[0]
noptraycen=noptraycen[0]
noptraxmin=noptraxmin[0]
noptraymin=noptraymin[0]
noptczxmax=noptczxmax[0]
noptczymax=noptczymax[0]
noptczxcen=noptczxcen[0]
noptczycen=noptczycen[0]
noptczxmin=noptczxmin[0]
noptczymin=noptczymin[0]
noptalfx=noptalfx[0]
noptalfy=noptalfy[0]
nplotwidth=nplotwidth[0]

nraxmax=nraxmax/vx
nraymax=nraymax/vy
nraxcen=nraxcen/vx
nraycen=nraycen/vy
nraxmin=nraxmin/vx
nraymin=nraymin/vy
nczxmax=nczxmax/vx
nczymax=nczymax/vy
nczxcen=nczxcen/vx
nczycen=nczycen/vy
nczxmin=nczxmin/vx
nczymin=nczymin/vy
nalfx=nalfx/vx
nalfy=nalfy/vy
noptraxmax=noptraxmax/vx
noptraymax=noptraymax/vy
noptraxcen=noptraxcen/vx
noptraycen=noptraycen/vy
noptraxmin=noptraxmin/vx
noptraymin=noptraymin/vy
noptczxmax=noptczxmax/vx
noptczymax=noptczymax/vy
noptczxcen=noptczxcen/vx
noptczycen=noptczycen/vy
noptczxmin=noptczxmin/vx
noptczymin=noptczymin/vy
noptalfx=noptalfx/vx
noptalfy=noptalfy/vy

;sample definitions for pulling optical galaxies out of the AGC
min_dec=decmin
max_dec=decmax

optramin=ramin
optramax=ramax

;Make labels for the plots.
;Note that this formatting is appropriate for ranges like 9.6 to 11.6, but 
;not as appropriate for ranges between "whole numbers." Adjust as necessary!
min_label=string(ramin,format='(F4.1)')+'h'
max_label=string(ramax,format='(F4.1)')+'h'
cen_label=string(racen,format='(F4.1)')+'h'

;Here I make labels for the hours which are not ramin, ramax and racen. I also
;calculate the coordinate location for the labels.

mark_labels=dblarr(number)
label_hour=strarr(number)

for i=1,number do begin
    mark_labels[i-1]=float(i+ramin)
    if (mark_labels[i-1] gt 24) then mark_labels[i-1]=mark_labels[i-1]-24
    label_hour[i-1]=string(mark_labels[i-1],format='(F4.1)')+'h'
endfor
label_hour=reverse(label_hour)
print, label_hour

spacing1=(nraxmin-nraxmax)/(number+1)

xspacing=fltarr(number+1)

for i=1, number+1 do xspacing[i-1]=float(nraxmax+i*spacing1)

if (number mod 2 eq 0) then begin
    spacing2=2*(nraycen-nraymax)/(number+1)
    yspacing1=fltarr(number/2)
    yoptspacing1=fltarr(number/2)
    for i=1, number/2 do begin
        yspacing1[i-1]=float(nraymax+i*spacing2)
        yoptspacing1[i-1]=float(noptraymax+i*spacing2)
    endfor
    yspacing=[yspacing1,reverse(yspacing1)]
    yoptspacing=[yoptspacing1,reverse(yoptspacing1)]
endif

if (number mod 2 eq 1) then begin
    spacing2=2*(nraycen-nraymax)/((number-1)/2)
    yspacing=fltarr((number-1)/2)
    for i=1, (number-1)/2 do begin
        yspacing[i-1]=float(nraymax+i*spacing2)
    endfor
endif

index=cindex
HIname=cHIname
agc=cagc
othername=cothername
HIcoords=cHIcoords
dra=cdra
ddec=cddec
optcoords=coptcoords
hsize=chsize
v50=cv50
verr=cverr
w50=cw50
werr=cwerr
sint=csint
serr=cserr
sintmap=csintmap
sn=csn
rms=crms
code=ccode
grid=cgrid

ngal=n_elements(index)

;Defining important parameters
if (n_elements(ramin) eq 0) then ramin=11.5   ; that is 1130
if (n_elements(ramax) eq 0) then ramax=14.0    ; that is 1400
if (n_elements(racen) eq 0) then racen=(ramax+ramin)/2.

ramin=ramin*15.
ramax=ramax*15.
racen=racen*15.

ragal=(double(strmid(HIcoords,2,2))+double(strmid(HIcoords,4,2))/60.+double(strmid(HIcoords,6,4))/3600.)*15.
decgal=double(strmid(HIcoords,10,3))+double(strmid(HIcoords,13,2))/60.+double(strmid(HIcoords,15,2))/3600.

;ALL galaxies in the ALFALFA catalog within the correct dec & cz range are 
;included. If your catalog includes objects outside of your intended RA range, 
;be sure to edit this line.
index=where(code lt 3 and decgal ge min_dec and decgal le max_dec and v50 le czmax)
ragal=ragal[index]
decgal=decgal[index]
v50=v50[index]
ngal=n_elements(index)

temp1=min(ragal)
temp2=max(ragal)

;"Special case" is a zero-crossing.
if (temp1 lt 10. and temp2 gt 350.) then begin
    for i=0,ngal-1 do begin
        if (ragal[i] ge 180.) then begin
            ragal[i]=ragal[i]-180.
        endif else begin
            ragal[i]=ragal[i]+180.
        endelse
    endfor
    ramin=ramin-180.
    ramax=ramax+180.
    if (racen lt 180.) then begin 
        racen=racen+180.
    endif else begin
        racen=racen-180.
    endelse
endif

;renaming arrays
ra=ragal
dec=decgal
cz=v50

t=(ra-racen)*!pi/180.+!pi/2.
tmax=(ramax-racen)*!pi/180+!pi/2.
tmin=(ramin-racen)*!pi/180+!pi/2.
r=20.*findgen(1000)
z5=fltarr(1000)+5000
z10=fltarr(1000)+10000
z15=fltarr(1000)+15000
z18=fltarr(1000)+18000

!p.multi=[0,1,2,0,0]

xp=[1,0.5,-0.5,-1,-1,-0.5,0.5,1,1]
yp=[0.5,1,1,0.5,-0.5,-1,-1,-0.5,0.5]
usersym,xp,yp,/fill

plot,cz,t,/polar,psym=8,xstyle=5,ystyle=5,symsize=0.7,$
     xrange=[-nplotwidth,nplotwidth], yrange=[0,czmax+2000]

th=(tmax-tmin)*findgen(1000)/1000.+tmin

;Dashed lines are normally plotted for czs of 5000, 10000, and 18000.
;If czmax is less than 18,000, that line is not plotted (and so on).
;A dashed line is also plotted at czmax
if (czmax GE 5000) then oplot,fltarr(1000)+5000,th,/polar,linestyle=1,thick=2.0
if (czmax GE 10000) then oplot,fltarr(1000)+10000,th,/polar,linestyle=1,thick=2.0
if (czmax GE 15000) then oplot,fltarr(1000)+15000,th,/polar,linestyle=1,thick=2.0
if (czmax GE 18000) then oplot,fltarr(1000)+18000,th,/polar,linestyle=1,thick=2.0
if (czmax LE 10000) then oplot,fltarr(1000)+czmax,th,/polar,linestyle=1,thick=2.0
if (czmax LE 15000) then oplot,fltarr(1000)+czmax,th,/polar,linestyle=1,thick=2.0
if (czmax LE 18000) then oplot,fltarr(1000)+czmax,th,/polar,linestyle=1,thick=2.0

;Tmin, tmax, tcen and thrarr allow you to plot lines of constant RA at either 
;edge, in the center and/or at each hour of your plot.
tmin=fltarr(1000)+(ramin-racen)*!pi/180+!pi/2.
tmax=fltarr(1000)+(ramax-racen)*!pi/180+!pi/2.
tcen=fltarr(1000)*!pi/180+!pi/2.

zax=findgen(1000)*(czmax/1000.)

;plot the lines of constant RA
oplot,zax,tmin,/polar,linestyle=1,thick=2.0
oplot,zax,tmax,/polar,linestyle=1,thick=2.0

if (ralines ne 'b' and ralines ne 'h') then begin
    oplot,zax,tcen,/polar,linestyle=1,thick=3.0
    xyouts,nraxcen,nraycen,cen_label,/normal,charsize=1.25,charthick=2.0
endif

if (ralines eq 'b') then begin
    oplot,zax,tcen,/polar,linestyle=1,thick=3.0
    xyouts,nraxcen,nraycen,cen_label,/normal,charsize=1.25,charthick=2.0
    for i=0,number-1 do begin
        oplot,zax,thrarr[i*1000:i*1000+999],/polar,linestyle=1,thick=3.0
        ;add or subtract to yspacing if the hour labels are to low or high
        xyouts, xspacing[i], yspacing[i]+.01,label_hour[i], /normal, charsize=1.25, charthick=2.0
    endfor
endif

if (ralines eq 'h') then begin
    for i=0,number-1 do begin
        oplot,zax,thrarr[i*1000:i*1000+999],/polar,linestyle=1,thick=3.0
        ;add or subtract to yspacing if the hour labels are to low or high
        xyouts, xspacing[i], yspacing[i]+.01,label_hour[i], /normal, charsize=1.25, charthick=2.0
    endfor
endif

;cz axis labels
xyouts,nczxmin,nczymin,'5000',/normal,charsize=1.25,charthick=2.0
if (czmaxs GE 10000) then xyouts,nczxcen,nczycen,'10000',/normal,charsize=1.25,charthick=2.0
if (czmaxs GE 15000) then xyouts,nczxmax,nczymax,'15000',/normal,charsize=1.25,charthick=2.0

;ra axis labels
xyouts,nraxmax,nraymax,max_label,/normal,charsize=1.25,charthick=2.0
xyouts,nraxmin,nraymin,min_label,/normal,charsize=1.25,charthick=2.0

;ALFALFA & sample size label
xyouts,nalfx,nalfy,'ALFALFA',/normal,charsize=2.0,charthick=2.0
xyouts,nalfx,nalfy-.03,'N='+strtrim(string(ngal),2),/normal,charsize=2.0,charthick=2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;NOW DOING THE FIGURE FOR THE OPTICALLY SELECTED SAMPLE

restore,'/home/dorado3/galaxy/idl_alfa/agcnorth.sav'

	agc_rah=(agcnorth.rah)+(agcnorth.ram/60.)+(agcnorth.ras10/36000.)
	agc_dec=(agcnorth.decd)+(agcnorth.decm/60.)+(agcnorth.decs/3600.)

;Here the optical selection is done for a case that DOES cross zero and for a
;case that does NOT cross zero. If you want to add magnitude or other limits to
;your optically-selected AGC sample, do so here!
if (temp1 lt 10. and temp2 gt 350.) then begin
	index=where(agc_dec ge min_dec and agc_dec lt max_dec and $
            (agc_rah ge optramin or agc_rah lt optramax) and $
            agcnorth.vopt ne 0 and agcnorth.vopt lt 18000 and $
            agcnorth.vopt lt czmax)
endif else begin
	index=where(agc_dec ge min_dec and agc_dec lt max_dec and $
            (agc_rah ge optramin AND agc_rah lt optramax) and $
            agcnorth.vopt ne 0 and agcnorth.vopt lt 18000 and agcnorth.vopt lt czmax)
endelse

ra=agc_rah[index]*15.
dec=agc_dec[index]
cz=agcnorth.vopt[index]
ngal=n_elements(index)

;special case is zero crossing
if (temp1 lt 10. and temp2 gt 350.) then begin

    for i=0,ngal-1 do begin
        if (ra[i] ge 180.) then begin
            ra[i]=ra[i]-180.
        endif else begin
            ra[i]=ra[i]+180.
        endelse
    endfor
endif


t=(ra-racen)*!pi/180.+!pi/2.
tmax=(ramax-racen)*!pi/180+!pi/2.
tmin=(ramin-racen)*!pi/180+!pi/2.
r=20.*findgen(1000)
z5=fltarr(1000)+5000
z10=fltarr(1000)+10000
z15=fltarr(1000)+15000
z18=fltarr(1000)+18000

xp=[1,0.5,-0.5,-1,-1,-0.5,0.5,1,1]
yp=[0.5,1,1,0.5,-0.5,-1,-1,-0.5,0.5]
usersym,xp,yp,/fill

plot,cz,t,/polar,psym=8,xstyle=5,ystyle=5,symsize=0.7, $
     xrange=[-nplotwidth,nplotwidth], yrange=[0,czmax+2000]

th=(tmax-tmin)*findgen(1000)/1000.+tmin


;Dashed lines are normally plotted for czs of 5000, 10000, and 18000.
;If czmax is less than 18,000, that line is not plotted (and so on).
;A dashed line is also plotted at czmax
if (czmax GE 5000) then oplot,fltarr(1000)+5000,th,/polar,linestyle=1,thick=2.0
if (czmax GE 10000) then oplot,fltarr(1000)+10000,th,/polar,linestyle=1,thick=2.0
if (czmax GE 15000) then oplot,fltarr(1000)+15000,th,/polar,linestyle=1,thick=2.0
if (czmax GE 18000) then oplot,fltarr(1000)+18000,th,/polar,linestyle=1,thick=2.0
if (czmax LE 10000) then oplot,fltarr(1000)+czmax,th,/polar,linestyle=1,thick=2.0
if (czmax LE 15000) then oplot,fltarr(1000)+czmax,th,/polar,linestyle=1,thick=2.0
if (czmax LE 18000) then oplot,fltarr(1000)+czmax,th,/polar,linestyle=1,thick=2.0

tmin=fltarr(1000)+(ramin-racen)*!pi/180+!pi/2.
tmax=fltarr(1000)+(ramax-racen)*!pi/180+!pi/2.
tcen=fltarr(1000)*!pi/180+!pi/2.
zax=findgen(1000)*(czmax/1000.)

;plot the lines of constant RA and labels

oplot,zax,tmin,/polar,linestyle=1,thick=2.0
oplot,zax,tmax,/polar,linestyle=1,thick=2.0

if (ralines eq 'c') then begin
    oplot,zax,tcen,/polar,linestyle=1,thick=3.0
    xyouts,noptraxcen,noptraycen,cen_label, /normal, charsize=1.25,charthick=2.0
endif

if (ralines eq 'b') then begin
    oplot,zax,tcen,/polar,linestyle=1,thick=3.0
    xyouts,noptraxcen,noptraycen,cen_label,/normal,charsize=1.25,charthick=2.0
    for i=0,number-1 do begin
        oplot,zax,thrarr[i*1000:i*1000+999],/polar,linestyle=1,thick=3.0
        ;add or subtract to yspacing if the hour labels are to low or high
        xyouts, xspacing[i], yoptspacing[i]+.01,label_hour[i], /normal, charsize=1.25, charthick=2.0
    endfor
endif

if (ralines ne 'b' and ralines ne 'c') then begin
    for i=0,number-1 do begin
        oplot,zax,thrarr[i*1000:i*1000+999],/polar,linestyle=1,thick=3.0
        ;add or subtract to yspacing if the hour labels are to low or high
        xyouts, xspacing[i], yoptspacing[i]+.01,label_hour[i], /normal, charsize=1.25, charthick=2.0
    endfor
endif

;cz axis labels
xyouts,noptczxmin,noptczymin,'5000', /normal, charsize=1.25,charthick=2.0
if (czmax GE 10000) then xyouts,noptczxcen,noptczycen,'10000', /normal, charsize=1.25,charthick=2.0
if (czmax GE 15000) then xyouts,noptczxmax,noptczymax,'15000', /normal, charsize=1.25,charthick=2.0

;ra axis labels
xyouts,noptraxmax,noptraymax,max_label, /normal, charsize=1.25,charthick=2.0
xyouts,noptraxmin,noptraymin,min_label, /normal, charsize=1.25,charthick=2.0

;OPT and sample size label
xyouts,noptalfx,noptalfy,'Opt', /normal, charsize=2.0,charthick=2.0
xyouts,noptalfx,noptalfy-0.03,'N='+strtrim(string(ngal),2), /normal, charsize=2.0,charthick=2.0

END
