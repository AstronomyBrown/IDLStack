
pro cone_plot_opt,catname,ramin=ramin,ramax=ramax,racen=racen,decmin=decmin,decmax=decmax,czmax=czmax,width=width,height=height

;+
;NAME:
;	CONE_PLOT_OPT
;PURPOSE:
; 	Makes EPS cone plots of (1) ALFALFA galaxies in a given RA, DEC range and
;	(2) AGC galaxies with non-zero optical redshifts LT 18000 km/s in the same range.
;	Each plot is labeled ("ALFALFA" or "Opt") with the number of galaxies in the plot listed.
;
;       PLEASE NOTE THAT THE OUTPUT OF CONE_PLOT_OPT IS HIGHLY SENSITIVE TO YOUR INPUT PARAMETERS,
;	and to the characteristics of your galaxy catalog. It it HIGHLY LIKELY that you will need
;       to custom-modify this code to suit your purposes and your catalog. See the "Notes"
;	section for some helpful hints. The code is also pretty well commented and includes some
;	helpful examples of how to modify certain steps.
;
;	NOTE: Requires epsinit.pro and epsterm.pro to be compiled.
;
;CALLING SEQUENCE:
;	CONE_PLOT_OPT, CATNAME,ramin=ramin,ramax=ramax,racen=racen,decmin=decmin,decmax=decmax,czmax=czmax,width=width,height=height
;
;EXAMPLE:
;	cone_plot_opt,'ameliecatalog.dat',ramin=22.,ramax=3.,racen=.5,decmin=26.,decmax=28.,czmax=18000,width=8,height=10
;
;INPUTS:
;	CATNAME - filename of the input catalog, in standard GALCAT format. Should be headerless.
;	RAMIN - low end of the RA range, in hours (for 0 crossings, the min RA will be larger than the max RA -- 
;			i.e. for a range from 22 hours to 3 hours, RAMIN=22, while for a range from 17 hours to
;			22 hours, RAMIN=17.)
;	RAMAX - high end of the RA range, in hours (for 0 crossings, the max RA will be smaller than the min RA --
;			i.e. for a range from 22 hours to 3 hours, RAMAX=3, while for a range from 17 hours to
;			22 hours, RAMAX=22.)
;	RACEN - the center of the RA range, in hours (i.e. for a range from 22 hours to 3 hours, RACEN=0.5)
;	DECMIN - minimum declination (used for object selection from catalog & from AGC)
;	DECMAX - maximum declination
;	CZMAX - maximum cz for plots (note that the absolute maximum is 18000)
;	WIDTH - width of eps plot, in inches.
;	HEIGHT - height of eps plot, in inches.;	
;
;OUTPUTS:
;	cone_plot.eps - an EPS plot with the 2 cone plots stacked on top of each other.
;
;NOTES:
;	Should you want to add something to this code, please note that the input variables ramin, ramax, and racen are changed
;	in line ~186 (to degrees) while retaining the same variable name. The variables optramin and optramax retain the original
;	value, in degrees.
;
;	REGIONS OF CODE LIKELY TO NEED ADAPTATION BY EACH USER:
;	Labels: Lines 85 to 87 define default RA labels based on the minimum, maximum, and central RA. The format is F4.1, i.e., an
;		RA of 9:40 will appear as 9.6 but an RA of 22 will appear as 22.0. To fit your specific coneplot and RA range,
;		you may want to adjust these definitions. You can also hand-create and place your labels.
;
;	Ngal: A variable called "ngal" can be found in line 94; it defines the maximum number of ALFALFA galaxies that will be read
;		in, so if you have a larger catalog, you'll want to adjust upwards.
;	Headers: By default, the catalog read in should not have any header information, but if the 3 lines of headers still remain,
;			uncommenting lines 99 and 100 should accomplish that.
;
;	ALFALFA selection: As defined in line 229, ALL galaxies in the ALFALFA catalog coded as 1 or 2 and lying within the correct dec 
;				& cz range are included. If your catalog includes objects outside of your intended RA range, or
;				you want to apply other criteria, please be sure to edit this line.
;	Optical selection: An optically-selected sample is pulled from the AGC in lines 349 to 355. If you want to add magnitude
;				or other limits to your optically-selected AGC sample, do so here.
;
;	Lines of constant RA: see line 297 (for ALFALFA) or line 407 (for optical). The code will automatically plot "boundary" lines of
;				constant RA at either edge and in the center of your plot. For wider RA ranger, you may want to include more
;				such lines. To do so, calculate the desired RA in degrees and then define a new "t" - ie, for 10 hours,
;				t10=fltarr(1000)+(150.-racen)*!pi/180.+!pi/2. The new line can then be plotted.
;	CZ axis labels: See line 317 (for ALFALFA) or line 426 (for optical). The code will apply labels along the cz axis at 5000, 10000, and
;				15000, but the x & y coordinates will need to be adjusted for your particular cone diagram. 
;
;	RA axis labels: See line 324 (for ALFALFA) line 432 (for optical). The code will attempt to label the RA axis (see Labels, above) but
;				the x & y coordinates will need to be adjusted for your particular cone diagram.
;	
;REVISION HISTORY:
;	Created 2007 A. Saintonge
;	Documented July 2007, Ann Martin
;
;-

;sample definitions for pulling optical galaxies out of the AGC
min_dec=decmin
max_dec=decmax

optramin=ramin
optramax=ramax

;Make labels for the plots.
;Note that this formatting is appropriate for ranges like 9.6 to 11.6, but not as appropriate for ranges
;between "whole numbers." Adjust as necessary!
min_label=string(ramin,format='(F4.1)')+'h'
max_label=string(ramax,format='(F4.1)')+'h'
cen_label=string(racen,format='(F4.1)')+'h'


;Reading in the catalog of galaxies
print,'reading the galaxy catalog'

;Adjust NGAL upward for plots with more than 2000 galaxies.
ngal=2000
openr,lun,catname,/get_lun

;Include the following 2 lines of code should you want to read a catalog
;with header information at the top.
;junk='junk'
;for i=0,2 do readf,lun,junk,format='(1a1)'

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


;ALL galaxies in the ALFALFA catalog within the correct dec & cz range are included. If your
;catalog includes objects outside of your intended RA range, be sure to edit this line.
index=where(code lt 3 and decgal ge min_dec and decgal le max_dec and v50 le czmax)
ragal=ragal[index]
decgal=decgal[index]
v50=v50[index]
print,n_elements(index)
ngal=n_elements(index)

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

!p.multi=[0,1,2,0,0]

epsinit,'cone_plot.eps',xsize=width,ysize=height,/VECTOR

xp=[1,0.5,-0.5,-1,-1,-0.5,0.5,1,1]
yp=[0.5,1,1,0.5,-0.5,-1,-1,-0.5,0.5]
usersym,xp,yp,/fill

plot,cz,t,/polar,psym=8,xstyle=5,ystyle=5,symsize=0.7,xrange=[-12000,12000], $
     yrange=[0,czmax+2000]

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

zax=findgen(1000)*(czmax/1000.)

;plot the lines of constant RA
oplot,zax,tmin,/polar,linestyle=1,thick=2.0
oplot,zax,tmax,/polar,linestyle=1,thick=2.0
oplot,zax,tcen,/polar,linestyle=1,thick=3.0


;cz axis labels
;The x & y coordinates will need to be adjusted for your particular cone diagram
xyouts,-5100.,3600.,'5000',charsize=1.25,charthick=2.0
if (czmax GE 10000) then xyouts,-8400.,7500.,'10000',charsize=1.25,charthick=2.0
if (czmax GE 15000) then xyouts,-11500.,11500.,'15000',charsize=1.25,charthick=2.0


;ra axis labels
;The x & y coordinates will need to be adjusted for your particular cone diagram
xyouts,-800,czmax+390,cen_label,charsize=1.25,charthick=2.0
xyouts,-11600,czmax-2000,max_label,charsize=1.25,charthick=2.0
xyouts,10400,czmax-2000,min_label,charsize=1.25,charthick=2.0


;ALFALFA & sample size label
xyouts,-10700,3000,'ALFALFA',charsize=2.0,charthick=2.0
xyouts,-10700,1500,'N='+strtrim(string(ngal),2),charsize=2.0,charthick=2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;NOW DOING THE FIGURE FOR THE OPTICALLY SELECTED SAMPLE

restore,'/home/dorado3/galaxy/idl_alfa/agcnorth.sav'

	agc_rah=(agcnorth.rah)+(agcnorth.ram/60.)+(agcnorth.ras10/36000.)
	agc_dec=(agcnorth.decd)+(agcnorth.decm/60.)+(agcnorth.decs/3600.)

;Here the optical selection is done for a case that DOES cross zero and for a case that does NOT cross zero.
;If you want to add magnitude or other limits to your optically-selected AGC sample, do so here!
if (temp1 lt 10. and temp2 gt 350.) then begin
	index=where(agc_dec ge min_dec and agc_dec lt max_dec and (agc_rah ge optramin or agc_rah lt optramax) $
            and agcnorth.vopt ne 0 and agcnorth.vopt lt 18000 and agcnorth.vopt lt czmax)
endif else begin
	index=where(agc_dec ge min_dec and agc_dec lt max_dec and (agc_rah ge optramin AND agc_rah lt optramax) $
            and agcnorth.vopt ne 0 and agcnorth.vopt lt 18000 and agcnorth.vopt lt czmax)
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

plot,cz,t,/polar,psym=8,xstyle=5,ystyle=5,symsize=0.7,xrange=[-12000,12000], $
     yrange=[0,czmax+2000]

th=(tmax-tmin)*findgen(1000)/1000.+tmin
print,tmin,tmax


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

zax=findgen(1000)*(czmax/1000.)
;plot the lines of constant RA
oplot,zax,tmin,/polar,linestyle=1,thick=2.0
oplot,zax,tmax,/polar,linestyle=1,thick=2.0
oplot,zax,tcen,/polar,linestyle=1,thick=3.0


;cz axis labels
;The x & y coordinates will need to be adjusted for your particular cone diagram
xyouts,-5100.,3600.,'5000',charsize=1.25,charthick=2.0
if (czmax GE 10000) then xyouts,-8400.,7500.,'10000',charsize=1.25,charthick=2.0
if (czmax GE 15000) then xyouts,-11500.,11500.,'15000',charsize=1.25,charthick=2.0

;ra axis labels
;The x & y coordinates will need to be adjusted for your particular cone diagram
xyouts,-800,czmax+390,cen_label,charsize=1.25,charthick=2.0
xyouts,-11600,czmax-2000,max_label,charsize=1.25,charthick=2.0
xyouts,10400,czmax-2000,min_label,charsize=1.25,charthick=2.0

;OPT and sample size label
xyouts,-10700,3000,'Opt',charsize=2.0,charthick=2.0
xyouts,-10700,1500,'N='+strtrim(string(ngal),2),charsize=2.0,charthick=2.0

epsterm


end
