;Opens widget so you can type in your catalog to be plotted and the plotting parameters. Then plots cone diagram and lets you click to locate the position of the mouse.You can then save the plot as a gif.

PRO WIDGET_CONE_PLOT

;Create top level base
tlb=widget_base(column=1)

;Create text entry widgets
base=widget_base(tlb, row=7, /grid_layout, frame=1)
label1=widget_label(base,value='Catalog')
ftext1=widget_text(base, /editable)
label2=widget_label(base,value='RA min (fmt: 0.0)')
ftext2=widget_text(base, /editable)
label3=widget_label(base,value='RA max (fmt: 0.0)')
ftext3=widget_text(base, /editable)
label4=widget_label(base,value='RA center (fmt: 0.0)')
ftext4=widget_text(base, /editable)
label5=widget_label(base,value='DEC min (fmt: 0.0)')
ftext5=widget_text(base, /editable)
label6=widget_label(base,value='DEC max (fmt: 0.0)')
ftext6=widget_text(base, /editable)
label7=widget_label(base,value='cz max (fmt: 0)')
ftext7=widget_text(base, /editable)

;Header buttons
headerbase=widget_base(tlb, row=1, /align_center)
label=widget_label(headerbase, value='Header:')
buttbase=widget_base(headerbase, column=2, /exclusive)
fbutt1=widget_button(buttbase, value='Yes', uvalue='Yes')
fbutt1=widget_button(buttbase, value='No', uvalue='No')

;Create button widgets
bbase=widget_base(tlb, row=1, /align_center)
fbutt2=widget_button(bbase, value='Cancel', uvalue='Cancel', xsize=75, event_pro='cone_exit')
fbutt3=widget_button(bbase, value='Next', uvalue='Next', xsize=75)

;Realize widgets
widget_control, tlb, /realize

;Create and store state information
widget_ids={text1:ftext1, text2:ftext2, text3:ftext3, text4:ftext4, text5:ftext5, text6:ftext6, text7:ftext7}
widget_control, tlb, set_uvalue=widget_ids

;Manage events and call widget_cone_plot_event
xmanager, 'widget_cone_plot', tlb;, event_handler='widget_cone_plot_event'

END

PRO CONE_EXIT, EVENT

widget_control, event.top, /destroy

END

PRO WIDGET_CONE_PLOT_EVENT, event

COMMON SHARE1, catname, ramins, ramaxs, racens, czmaxs, decmins, decmaxs, header

;Get widget identity
widget_control, event.id, get_uvalue=widget

;Collect and store text info
widget_control, event.top, get_uvalue=widgets
text1=widgets.text1
text2=widgets.text2
text3=widgets.text3
text4=widgets.text4
text5=widgets.text5
text6=widgets.text6
text7=widgets.text7
widget_control, text1, get_value=catname
widget_control, text2, get_value=ramins
widget_control, text3, get_value=ramaxs
widget_control, text4, get_value=racens
widget_control, text5, get_value=decmins
widget_control, text6, get_value=decmaxs
widget_control, text7, get_value=czmaxs

if (widget eq 'Yes') then begin
    if (event.select eq 1) then begin
         header=1
     endif
     if (event.select eq 0) then begin
         header=0
     endif
endif

if (widget eq 'No') then begin
    if (event.select eq 1) then begin
         header=0
     endif
     if (event.select eq 0) then begin
         header=1
     endif
endif

if (widget eq 'Cancel') then begin
    print, 'cancel'
    widget_control, event.top, /destroy
endif

if (widget eq 'Next') then begin
    print, 'next'
    print, header
    widget_control, event.top, /destroy
    position
endif

END

PRO POSITION

COMMON SHARE1 

COMMON SHARE2, ngal

;Convert text from string to floating point or integer
ramin=float(ramins)
ramax=float(ramaxs)
racen=float(racens)
decmin=float(decmins)
decmax=float(decmaxs)
czmax=fix(czmaxs)

ramin=ramin[0]
ramax=ramax[0]
racen=racen[0]
decmin=decmin[0]
decmax=decmax[0]
czmax=czmax[0]

;sample definitions for pulling optical galaxies out of the AGC
min_dec=decmin
max_dec=decmax

optramin=ramin
optramax=ramax

;Reading in the catalog of galaxies
print,'reading the galaxy catalog'

;Adjust NGAL upward for plots with more than 2000 galaxies.
ngal=2000
openr,lun,catname,/get_lun

;Read catalog with header information at the top.
if (header eq 1) then begin
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
          format='(1a17,1i7,1a9,1a17,2i4,1a17,1f7.1,2(1i6,1i5),1f8.2,1f6.2,1f8.2,1f7.1,1f6.2,1i4,1a12)'
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

index=where(code lt 3)
HIname=HIname[index]
agc=agc[index]
othername=othername[index]
HIcoords=HIcoords[index]
dra=dra[index]
ddec=ddec[index]
optcoords=optcoords[index]
hsize=hsize[index]
v50=v50[index]
verr=verr[index]
w50=w50[index]
werr=werr[index]
sint=sint[index]
serr=serr[index]
sintmap=sintmap[index]
sn=sn[index]
rms=rms[index]
code=code[index]
grid=grid[index]

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ALL galaxies in the ALFALFA catalog within the correct dec & cz range are included. If your
;catalog includes objects outside of your intended RA range, be sure to edit this line.
index=where(code lt 3 and decgal ge min_dec and decgal le max_dec and v50 le czmax)
ragal=ragal[index]
decgal=decgal[index]
v50=v50[index]
print,n_elements(index)
ngal=n_elements(index)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

temp1=min(ragal)
temp2=max(ragal)

;"Special case" is a zero-crossing.
if (temp1 lt 10. and temp2 gt 350.) then begin
    print,'special case'
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
        print,'modified racen'
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

xp=[1,0.5,-0.5,-1,-1,-0.5,0.5,1,1]
yp=[0.5,1,1,0.5,-0.5,-1,-1,-0.5,0.5]
usersym,xp,yp,/fill

;Create base widget
tlb=widget_base(column=1, tlb_frame_attr=1)

base1=widget_base(tlb, column=2)
base2=widget_base(base1,row=3)

base3=widget_base(base2, row=3, /grid_layout, frame=1)
label1=widget_label(base3,value='RA max')
ftext1=widget_text(base3, value='x', /editable)
ftext2=widget_text(base3, value='y', /editable)
label3=widget_label(base3,value='RA center')
ftext3=widget_text(base3,value='x', /editable)
ftext4=widget_text(base3, value='y',/editable)
label5=widget_label(base3,value='RA min')
ftext5=widget_text(base3,value='x', /editable)
ftext6=widget_text(base3,value='y', /editable)

base4=widget_base(base2, row=3, /grid_layout, frame=1)
label7=widget_label(base4,value='cz max')
ftext7=widget_text(base4, value='x', /editable)
ftext8=widget_text(base4, value='y', /editable)
label9=widget_label(base4,value='cz center')
ftext9=widget_text(base4,value='x', /editable)
ftext10=widget_text(base4, value='y',/editable)
label11=widget_label(base4,value='cz min')
ftext11=widget_text(base4,value='x', /editable)
ftext12=widget_text(base4,value='y', /editable)

base5=widget_base(base2, row=1, /grid_layout, frame=1)
label7=widget_label(base5,value='ALFALFA label')
ftext13=widget_text(base5, value='x', /editable)
ftext14=widget_text(base5, value='y', /editable)

draw=widget_draw(base1, xsize=1000, ysize=600, uvalue='Draw', /button_events)

buttbase1=widget_base(tlb, row=2, /align_center)
label=widget_label(buttbase1, value='X: Y:', /align_center, /dynamic_resize)
buttbase2=widget_base(buttbase1, column=3, /align_center)
butt1=widget_button(buttbase2, value='Refresh', uvalue='Refresh', /align_center, xsize=75)
butt2=widget_button(buttbase2, value='Save', uvalue='Save', /align_center, xsize=75)
butt3=widget_button(buttbase2, value='Cancel', uvalue='Cancel', /align_center, xsize=75, event_pro='position_exit')


;Realize widgets and get draw window index
widget_control, tlb, /realize
widget_control, draw, get_value=winid
wset, winid
plot,cz,t,/polar,psym=8,xstyle=5,ystyle=5,symsize=0.7,xrange=[-18000,18000], $
     yrange=[0,czmax+2000]

;Create and store information structure
info={text1:ftext1, text2:ftext2, text3:ftext3, text4:ftext4, text5:ftext5, text6:ftext6, text7:ftext7, text8:ftext8, text9:ftext9, text10:ftext10, text11:ftext11, text12:ftext12, text13:ftext13, text14:ftext14, winid:winid, label:label, x:-1L, y:-1L}
infoptr=ptr_new(info)
widget_control, tlb,set_uvalue=infoptr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Start managing events
xmanager, 'position', tlb, cleanup='position_cleanup', /no_block

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tmin, tmax, and tcen allow you to plot lines of constant RA at either edge
;and in the center of your plot. The code will do these automatically,
;but for wider RA ranges, you may want to include more such lines.
;To do so, calculate the desired RA in degrees, and then define a new "t." Using
;the example of 10 hours of RA,
;t10=fltarr(1000)+(150.-racen)*!pi/180.+!pi/2.
;And below, also plot the new "t", like:
;oplot,xax,t10,/polar,linestyle=1,thick=2.0
tmin=fltarr(1000)+(ramin-racen)*!pi/180+!pi/2.
tmax=fltarr(1000)+(ramax-racen)*!pi/180+!pi/2.
tcen=fltarr(1000)*!pi/180+!pi/2.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

zax=findgen(1000)*(czmax/1000.)

;plot the lines of constant RA
oplot,zax,tmin,/polar,linestyle=1,thick=2.0
oplot,zax,tmax,/polar,linestyle=1,thick=2.0
oplot,zax,tcen,/polar,linestyle=1,thick=3.0

END

PRO POSITION_EVENT, EVENT

COMMON SHARE1

COMMON SHARE2

;Get information structure
widget_control, event.top, get_uvalue=infoptr
info=*infoptr

;Get widget identity
widget_control, event.id, get_uvalue=widget

;Handle events
case widget of

    'Save':begin
        im=tvrd()
        write_gif, 'plot.gif', im
    end

    'Draw':begin
        ;Handle button press events (define position)
        if (event.press gt 0) then begin
            widget_control, event.id, draw_motion_events=0
            info.x=event.x
            info.y=event.y
        endif

        ;Update the label widget
        label_text=string(info.x, info.y, format='("X:", i3, 1x, "Y:", i3)')
        widget_control, info.label, set_value=label_text

    end

    'Refresh':begin

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

        ;Make labels for the plots.
        ;Note that this formatting is appropriate for ranges like 9.6 to 11.6, but not as appropriate for ranges
        ;between "whole numbers." Adjust as necessary!
        min_label=string(ramins,format='(F4.1)')+'h'
        max_label=string(ramaxs,format='(F4.1)')+'h'
        cen_label=string(racens,format='(F4.1)')+'h'

        ;ra axis labels
        xyouts,raxcen,raycen,cen_label,/device,charsize=1.25,charthick=2.0
        xyouts,raxmax,raymax,max_label,/device,charsize=1.25,charthick=2.0
        xyouts,raxmin,raymin,min_label,/device,charsize=1.25,charthick=2.0

        ;cz axis labels
        xyouts,czxmin,czymin,'5000',/device,charsize=1.25,charthick=2.0
        if (czmaxs GE 10000) then xyouts,czxcen,czycen,'10000',/   device,charsize=1.25,charthick=2.0
        if (czmaxs GE 15000) then xyouts,czxmax,czymax,'15000',/device,charsize=1.25,charthick=2.0

        ;ALFALFA & sample size label
        xyouts,alfx,alfy,'ALFALFA',/device,charsize=2.0,charthick=2.0
        xyouts,alfx,alfy-20,'N='+strtrim(string(ngal),2),/  device,charsize=2.0,charthick=2.0

    end

    else:print, 'Unrecognized event:', widget

endcase

;Update state information
*infoptr=info

END

PRO POSITION_EXIT, EVENT

widget_control, event.top, /destroy

END

PRO POSITION_CLEANUP, ID

widget_control, id, get_uvalue=infoptr
ptr_free, infoptr

END
