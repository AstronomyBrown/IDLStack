;+
;NAME:
;GRID_PREP
;
;SYNTAX:
;
;pro grid_prep, pos,grid_makeup,drift_list
;
;PARAMETERS:
;	Input:
;	pos	  	position structure array, covering region of interest
;	Output:
;	grid

; the output file is a structure containing:
; grid={name		str(64), a name for the grid picked by the user
;      RAmin, Decmin	min RA, Dec of grid map [hh.hhhh, dd.dddd]
;      DeltaRA,DeltaDec	grid step in RA (sec of time ) and in Dec (arcmin)
;	NOTE THAT THE GRID POINT WITH THE LOWEST RA,DEC HAS
;	RA=RAmin+DeltaRA/2., Dec=Decmin+DeltaDec/2
;      NX,NY		number of grid point in RA, in Dec
;      map_projection	string, describing the ttype of map projection
;      czmin		velocity of lowest vel channel of grid (km/s)
;      NZ		number of spectral channels in grid
;      velarr		velocity array 
;      wf_type		string(64) describing the type of weight function
;			used to grid
;      wf_fwhm		fwhm of grid function (arcmin)
;      han		int, nr of channels used to hansmooth spectral data
;			(1, 3, 5, 7)
;      medsubtract	if ne 0 then a median has been removed from each drift
;      baseline		structure containing the details of baselining process
;      		.nbase		intarr[2,NY] baseline polynomial order for given dec 
;				strip/pol; all spectra in one dec strip get same order
;		.coeff		double array[2,NX,NY,10] baseline coeffs
;				for each grid pt spectrum; max order=9
;      		.nreg		intarr[2,NY,40,4] boundaries of baseline regions
;				dim=2 		polarization
;				dim=NY		nr of Dec strip of grid points
;				dim=40		up to 40 regions per Dec strip
;				dim=4		llch,ll grid pt inx, urch, ur grid pt in RA of
;						baseline region EXCLUDED from baseline fit
;      calib_facs	fltarr(2,8,5) poly coeff of fits to conversion factors
;			to go from drift scan spectral units to grid map
;			dim=2 corresponds to polarizations
;			dim=8 corresponds to beam numbers
;			dim=5 corresponds to coeff, e.g. c0, c1, c2, c3, c4,
;				where coeffs refer to fit of conversion factors
;				as a function of time (modified Julian date)
;      grms		rms of spectral values over the whole grid
;      date		string, date when proc run 
;      who		name of person who produced this 
;      pos		pos structure array with all drifts contributing to grid map
;			there are as many array elements as there are drift scans 
;			contributing. Each array element has format:
;		.name		string, name of the drift scan
;		.scannumber	long integer
;		.posang		double, angle of the ALFA array, deg
;		.cenrahr	double, Ra in hrs at center of drift scan
;		.cendecdeg	double, Dec in deg at center of drift scan
;		.AZ0		double, azimuth angle in deg of bm0
;		.ZA0		double, zanith angle in deg of bm 0
;		.rahr		double array[600,8] RA positions of each rec/bm in scan
;		.decdeg		double array[600,8] Dec ositions of each rec/bm in scan
;		.cont		float array[2,600,8] continuum flux at given pol/rec/bm
;		.status		float array[2,600,8] status of given pol/rec/bm
;		.badbox		int array[100,2,8,4] corners of badboxes set by flagbb
;      drift_list	structure array containing list of drifts contributing, w/as many 
;			array elements as drift scans contributing; each record of array is:
;		.name		string, drift scan name
;		.scannumber	long, scan number
;		.cenrahr	double, Ra in hrs at center of drift scan
;		.cendecdeg	double, Dec in deg at center of drift scan
;      grid_makeup      structure array describing grid makeup, with as many elements as
;			there are grid points; each element of array contains:
;		.i		int index of grid pt in ra direction
;		.j		int index of grid pt in dec direction
;		.ra		double RA in hh.hhhhh of grid pt
;		.dec		double Dec in dd.dddd of grid pt
;		.driftname	string array[16} of up to 16 drift scans contributing
;				to flux at this grid pt
;		.scannumber	long array[16] of up to 16 drift scans contributing
;				to flux at this grid pt
;		.startrecnr	long[16,8] first rec in scan contributing to grid pt
;				for given beam
;		.stoprecnr	long[16,8] last rec in scan contributing to grid pt
;				for given beam
;		.date		string
;      d		fltarr[NZ,2,NX,NY] of grid spectral values
;			this IS the data cube
;      w		fltarr[NZ,2,NX,NY] of weights for each sp value
;      cont		fltarr[2,NX,NY] of continuum fluxes
;      cw               fltarr[2,NX,NY] of continuum weights
;OPTIONAL OUTPUT PARAMETERS:
;
;KEYWORDS:
;		
;
;DESCRIPTION:
;
; GRID_PREP produces a gridded data cube plus ancillary files,
;           after reading the pos /st and dred data files of a
;           region.
; It consists of a main program and a few subroutines.
; SUBROUTINE GRID_DISPLAY_IMG is used to display 2D drift maps
; SUBROUTINE GRID_HANNING can smooth spectra via han 3,5 or 7

;_________________________________________________________________
; PART 0 of GRID_PREP 
; obtains and checks input parameters, i.e.:
;	- RA_min, RA_max [hh.hhhh] of the output map
;	- Dec_min, Dec_max [dd.dddd] of the output map
;	- grid step in RA (sec of time) and in Dec (arcmin)
;	NOTE that the coords of the grid pixel with lowest RA, Dec
;	     are RA_min+RA_gridstep/2,Dec_min+Dec_gridstep/2
;	     and those with the highest RA, Dec are
;	     RA_max-RA_gridstep/2, Dec_max-Dec_gridstep/2 
;	- czmin (km/s), the lower vel for the output map, and
;	- nch_cube, the number of spectral channels to output
;	- w_fwhm the full width at half max of the Gaussian
;	  weight function used for the gridding, in arcmin
;	- hansmooth: 1,3,5 or 7, the spectral smoothing applied
;	  to the data before using for the gridding process
;	- medsubtract: if set, a median value is subtracted
;	  from each 2D drift map
;	- baseline: if set, interactive baselining of the data
;	  is invoked, before gridding

; After setting these parameters, PART 0 creates an array of
; positions for the grid: coord[0,i,j] are the RA values in hh.hhhh
; and                     coord[1,i,j] are the Dec values in dd.ddd
; for each point i,j of the grid.

;_______________________________________________________________________
; PART 1 of GRID_PREP
; uses the pos /st to:
; (a) make a drift_list /st which lists all drift scans fitting in
;     the grid box;
; (b) create a tmp_pos /st which contains only info from those drifts,
;     rather than the generic input pos, no longer used by this program
;     after tmp_pos is created. 
; Drift_list is an array of structures with size equal to the number
; of drift scans which have records within the grid box. The format
; of a drift_list record is:
;	drift_list.name		str, name of the drift scan
;	drift_list.scannumber	int, drift scan number
;	drift_list.cenrahr	flt, central RA of bm 0 of scan
;	drift_list.cendeg	flt, Dec of bm 0 of scan

; The array structure tmp_pos has as many pos records as there are in the
; drift_scan array structure. The format of a tmp_pos record is the same
; as that of that of a pos /st record.

;________________________________________________________________________
; PART 2 of GRID_PREP
; uses the tmp_pos and grid_list structures to produce a structure called
; "grid_makeup". This structure has a record for every point in the grid,
; which describes the data contributing to the flux at that grid point.
; A Grid_makeup record format is:
; 	grid_makeup.i		int, index in the ra direction of grid pt
;	grid_makeup.j		int, index in the dec direction of grid pt
;	grid_makeup.ra		flt, RA in hh.hhhh of the grid pt
;	grid_makeup.dec		flt, Dec in dd.ddd of the grid pt
;	grid_makeup.driftname	strarr of size [16], i.e. up to 16 different 
;				drift scans can contribute to the flux at
;				thsi grid point
;	grid_makeup.scannumber	intarr of size [16], see above
;	grid_makeup.startrecnr	intarr of size [nk,nb]=[16,8], giving the first
;				rec nr that contributes to flux at grid pt,
;				for beam nb of drift scan nk
;	grid_makeup.stoprecnr	intarr of size [nk,nb]=[16,8], giving the last
;				rec nr that contributes to flux at grid pt,
;				for beam nb of drift scan nk
;	grid_makeup.date	str, date of processing

; In this part of the program, we loop through the points of the grid.
; FOR EACH GRID POINT,
;	FIRST, we find all the records in tmp_pos of any scan - total number nd -  
;		that are in  vicinity (5 sec in RA, 5' in Dec) of the grid point. 
;		They are identified by 3 1D arrays
;		drindx (drift index), bmindx (beam index), recindx (rec index),
;		each of size nd; so, for i=0,nd-1, a record neighboring the given
;		grid point can be found at
;		ra  = tmp_pos[drindx[i]].rahr[recindx[i],bmindx[i]]
;		dec = tmp_pos[drindx[i]].decdeg[recindx[i],bmindx[i]]
;		The array "drindx" is repeated as many
;		times as there are recs and beams near the gridd pt;
;		an array "dr_nrs" is also made; it counts each drift only once, 
;		i.e. it contains only the unique list of drifts for that grd pt,
;		totalling ndr (ndr changes from a grid point to the next)
;	THEN, we loop through the ndr drift scans contributing to the current
;		drift scan, ans find which range of rec nrs corresponds, for
;		each beam, to a spectrum in vicinity of the grid point
;	FINALLY, we write to the grid_makeup structure

; Until this point, the only input used were the map parameters and the pos /st

; _________________________________________________________________________________
; PART 3 of GRID_PREP
; does the heavy-lifting grid  computational work, plus other things.
; One at a time, the drift scans contributing to the grid are loaded,
; by reference to the structure drift_list. 
; A "grid_map" 4D array is created, that will contain the spectral values
; of each grd pt, each pol (4096 x 2 x nr grd pts in X x nr grd pts in Y).
; A "weight_map" 4D array is also created, that will contain the total weight
; of each spectral value, by pol, by grid pt of the map.

; One at a time, drift scans in drift_list are loaded; each drift scan contributes
; to several (NN) grid points, with different weights. So for each grid
; point to which records of the the given drift scan contribute, weights are 
; computed (using the gridding weight function and the distance of each record
; from the grid point) and the weighted contribution of that drift scan is
; placed in the that grid point's bin. So, one drfit scan at a time, we build
; up the map.

; _________________________________________________________________________________
; PART 4 of GRID_PREP
; Divides the the grid map by the weight map, puts header information and
; outputs the results.


;RG = written May05
;RG - last update 050616
;RG - major rewrite, 4D weight_map, etc. 050630
;RG - made output an all-including structure 22Sep05
;BK - added pos creation procedure 27Sep05
;RG - addded patch to take care of map areas w/o data  05Oct05
;BK - added continuum gridding 18Oct05
;BK - added continuum weights 27Oct05
;BK - added continuum fix to remove 12 second radar pulses  28Oct05
;BK - procedure checked and tested  4Nov05
;BK - tested and distributed 9Nov05

;***************************************************************************************

; SUBROUTINE TO DISPLAY THE 2D IMAGE

PRO grid_display_img,img,Np=Np,NS=NS,driftname=driftname,clip_max=clip_max,mapwindow

nrec=n_elements(img[0,*])
nchn=n_elements(img[*,0])
image=img
if (n_elements(clip_max) ne 0) then begin
  for nr=0,nrec-1 do begin
    indx=where(image[*,nr] gt clip_max,nind)
    if (nind gt 0) then image[indx,nr]=clip_max
  endfor
endif
  
window,/free,xsize=800,ysize=600, retain=2
loadct, 1
device, decomposed=0

mapwindow=!d.window
!p.multi=[0,2,1]
imgdisp,image,$
;        /histeq,$
        position=[0.05,0.05,0.95,0.95]
xyouts,nchn/2,nrec+12,'Beam, Pol ='+strtrim(string(ns),2)+', '+strtrim(string(np),2),size=1.5
xyouts,0,nrec+12,driftname,size=1.5
device, decomposed=0
;contour,mask2,thick=2,position=[0.05,0.05,0.95,0.95],$
;        c_colors='0000FF'XL,/overplot
yp=0
repeat begin
 yp=yp+100
 plots,[0,nchn-1],[yp,yp],linestyle=1
endrep until (yp gt nrec-100)
xp=0
repeat begin
 xp=xp+100
 plots,[xp,xp],[0,nrec-1],linestyle=1
endrep until (xp gt nchn-100)

end

;______________________________________________________________________

;SUBROUTINE TO SMOOTH THE IMAGE 
; GAUSAV is the HPFW of a gaussian in the rec direction
; HAN can be 3, 5 or 7, for Hanning smoothing in the spectral direction

pro grid_smoothing,image_raw,image_smo,gausav=gausav,han=han

nrec=n_elements(image_raw[0,*])
nchn=n_elements(image_raw[*,0])

image_smo=image_raw
if (gausav gt 1) then begin
  gausskernel=psf_Gaussian(NPIXEL=41, FWHM=gausav,$
                           NDIMEN=1, /NORMALIZE)
  for i=0,nchn-1 do begin
    smoothedsample=convol(reform(image_raw[i,*]),gausskernel, /EDGE_TRUNCATE)
    image_smo[i,*]=reform(smoothedsample,1,nrec)     
  endfor
endif
image_smo2= image_smo
if (han gt 1) then begin
  if (han eq 3) then hansm=[0.5,1.,0.5]/2.
  if (han eq 5) then hansm=[0.25,0.75,1.,0.75,0.25]/3.
  if (han eq 7) then hansm=[0.146,0.5,0.854,1.,0.854,0.5,0.146]/4.
  for nr=0, nrec-1 do begin
    smoothedspec = convol(reform(image_smo[*,nr]),hansm,/edge_truncate)
    image_smo2[*,nr] = smoothedspec
  endfor 
endif

image_smo = image_smo2

end

;______________________________________________________________________

;Simple proceuder to remove 12 second radar

pro continuumfix, cont_pt

for ipol=0,1 do begin
   for ibeam=0,6 do begin

	y=fft(cont_pt[ipol,*,ibeam], -1)
	y=reform(y)
	xvals=[50,100,150,200,250,300,350,400,450,500,550]
	range=8

	for k=0,n_elements(xvals)-1 do begin

	    x=findgen(2*range+1)+xvals[k]-range
	    result=interpolate([y[xvals[k]-range],y[xvals[k]+range]],x)
	    y[xvals[k]-range:xvals[k]+range]=result

	endfor

        cont_pt[ipol, *, ibeam]=real_part(fft(y,1))

   endfor

endfor

end



;______________________________________________________________________
; MAIN PROGRAM


;***************************************************************************
pro grid_prep, grid 
;***************************************************************************


;PART 0. Check parameters & keywords

ramin=0.D
ramax=0.D
decmin=0.D
decmax=0.D
dgra=0.D
dgdec=0.D
print,'Enter RA_min, RA_max [hh.hhhhh] of map'
read,ramin,ramax
print,'Enter Dec_min, Dec_max [dd.ddddd] of map'
read,decmin,decmax
cosdec=cos(((decmax+decmin)/2.)*!PI/180.)
print,'Enter grid step in RA [sec of time], and in Dec [arcmin]'
read,dgrasec,dgdecmin
dgra=dgrasec/3600.
dgdec=dgdecmin/60.
Epoch=2000.0
print,'Enter czmin [km/s], and number of sp. chans in cube'
print,'      (e.g. 500,800 will cover from cz=500 to about 4700)'
read,czmin,nch_cube
nch_cube=round(nch_cube)
print,'Enter FWHM of weight function (arcmin)'
read,w_fwhm
w_fwhm_hrs=(w_fwhm/(60*15.))/cosdec
w_fwhm_deg=w_fwhm/60.
sigma=0.4247*w_fwhm_deg*!PI/180.
print,'Enter the name of the output grid (up to 64 chars)'
gname=string(64)
read,gname

hansmooth=1	;WILL NEED TO BE SET INTERACTIVELY
medsubtract=0	;WILL NEED TO BE SET INTERACTIVELY

;----------------------------------------------------
;----------------------------------------------------
;;Added by B. Kent September 27, 2005
;;This element will spawn and obtain the most recent master list of
;;the position structures.  pos does not need to be passed to the
;;program any longer.  It creates a masterpos/masterdir listing

print, ' '
print, 'Creating position strucutre... '
print, ' '

posfind, pos, masterdir,/loadpos

;----------------------------------------------------


Dra=ramax-ramin
Ddec=decmax-decmin
NX = round(Dra/dgra)
NY = round(Ddec/dgdec)

coord=dblarr(2,NX,NY)     ; MAKE coord array
ra=dindgen(NX)
dec=dindgen(NY)
ra=ra*dgra +ramin+dgra/2.
dec=dec*dgdec+decmin+dgdec/2.
for i=0,NX-1 do begin
  coord[0,i,*]=ra[i]
endfor
for j=0,NY-1 do begin
  coord[1,*,j]=dec[j]
endfor

;...............................................................................
;PART 1. Go find all the drifts partly fitting within box
;	- make a drift_list structure listing those
;	- and create a tmp_pos which contains only info from those drifts,
;	  rather than the generic input pos, no longer used by this program
;	  after tmp_pos is created.

ndrpos=n_elements(pos)

flag_up=0
for i=0,ndrpos-1 do begin
  rapc=pos[i].cenrahr		; RA of center of drift for bm 0
  decpc=pos[i].cendecdeg	; dec of center of drift for bm 0
  raphiedge=rapc+0.083333+0.007 ; accounts for 10 min duration and beams offsets
  raploedge=rapc-0.083333-0.007	; accounts for 10 min duration and beams offsets
  decphiedge=decpc+0.11
  decploedge=decpc-0.11
  if(ramin-raphiedge lt 2.5*w_fwhm_hrs and   $
     raploedge-ramax lt 2.5*w_fwhm_hrs and   $
     decploedge-decmax lt 2.5*w_fwhm_deg and $
     decmin-decphiedge lt 2.5*w_fwhm_deg) then begin
    print,ramin,raphiedge,ramax,raploedge,2.5*w_fwhm_hrs
    record={name:pos[i].name, $
            scannumber:pos[i].scannumber, $
            cenrahr:pos[i].cenrahr, $
            cendecdeg:pos[i].cendecdeg}
    rec_pos=pos[i]
    if (flag_up eq 0) then begin
      drift_list=record
      tmp_pos=rec_pos
    endif else begin
      drift_list=[drift_list,record]
      tmp_pos=[tmp_pos,rec_pos]
    endelse
    flag_up=1
  endif
endfor

map_ndrift=n_elements(drift_list)

print, ' '
print,n_elements(drift_list),' drifts found to contribute from grid_prep procedure.'
print,drift_list.name,format='(3a30)'
print, ' '  

;...............................................................................
;PART 2. Go loop through each grid point and identify drifts/recs that sweep 
;       close enough to make a contribution to the signal at that grid pt.
;	Here we loop through each grid point and find first the drifts that
;	due to vicinity can contribute to the grid point. 
;	Once identified the drift scans that contribute to that grid point,
;	we loop through them to find the records in each drift that are near.
;	The exercise could be done in a single "where" for each grid point,
;	but keeping track of the indices gets messy, so I break the process
;	in two stages.
;	FOR EACH GRID POINT:
;		FIRST, we find all the records - total number nd - in tmp_pos 
;			that are in  vicinity of the grid point. They are 
;			identified by 3 1D arrays
;			drindx, bmindx,recindx,  each of size nd
;			so, for i=0,nd-1, a record neighboring the given
;			grid point can be found at
;			ra  = tmp_pos[drindx[i]].rahr[recindx[i],bmindx[i]]
;			dec = tmp_pos[drindx[i]].decdeg[recindx[i],bmindx[i]]
;		THE ARRAY drindx repeats the name of a given drift as many
;			times as there are recs and beams in it near the grd pt
;			so the array dr_nrs counts each drift only once, i.e.
;			it contains only the unique list of drifts for that grd pt
;		NEXT, we create a structure GRID_MAKEUP. This is an array of
;			structures with as many elements as there are grid points
;			in the map. For each grid point, GRID_MAKEUP lists 
;			- the grid coords (i,j,ra and dec)
;			- up to 16 drift names, drift scannumbers
;			- and for each of the up to 16 drifts 
;			  the start scan nr and stop scan nr
;			  of a sequence of neighboring records, 
;			  separately for each beam of the drift.
;			  GRID_MAKEUP allows up to 16 different drifts to contribute
;			  to a given grid point, which is OK for ALFALFA but may
;			  fall short if this is used for deeper mapping with multiple
;			  passes. Since this is an internal structure not carried
;			  through in further processing, it is an easily correctable
;			  feature.
;		THIS CONCLUDES the preliminary work with the pos structure.
;			
; Q:WHAT DO WE DO IF THERE ARE NO DATA IN SPECIFIED VICINITY OF GRID PT? ==> see "IF ND=0, THEN..."

icount=0
N_nodata=0
for i=0,NX-1 do begin
  icount=icount+1
  if (icount eq 20) then begin
    print,i,' columns processed'
    icount=0
  endif
  for j=0,NY-1 do begin
    index=where(abs(tmp_pos.rahr-ra[i]) lt 0.00555 and 	$
                abs(tmp_pos.decdeg-dec[j]) lt 0.083333,nd)
;               index has as many values as there are records -of any drift -
;               within both 20 sec in ra and 5' in dec from the grid pt [i,j]
;   IF ND=0 THEN...
    if (nd eq 0) then begin
      record_MAKEUP={i:i,j:j, 	$
		  ra:ra[i],	$
		  dec:dec[j], 	$
		  driftname:strarr(16), $
		  scannumber:lonarr(16), $
		  startrecnr:lonarr(16,8), $
		  stoprecnr:lonarr(16,8), $
		  date:systime(0)}
      N_nodata=N_nodata+1
      goto,write_to_makeup
    endif
    dims=size(tmp_pos.rahr,/dimensions)
    nrec=dims[0]			; this is the usual # of rec in a drift, i.e. 600
    recindx=index mod nrec
    bmindx=index/600 mod dims[1]        ; dims[1] is =8
    drindx=index/(nrec*dims[1])		; recindx,bmindx and drindx are 1D arays
    					; tmp_pos[drindx].rahr[recindx,bmindx] 
                                        ; is near ra[i],dec[j]
    dr_nrs=drindx(uniq(drindx))		; unique drift indx (in tmp.pos) of the 
                                        ; drifts contributing to grid pt
    ndr=n_elements(dr_nrs)		; total nr of unique drifts contribtng to grid pt
;    PRINT,I,J,ND,NDR,ra[i],dec[j]
    driftname=strarr(16)			; Initialize
    scannumber=lonarr(16)
    startrecnr=lonarr(16,8)
    stoprecnr=lonarr(16,8)
    for k=0,ndr-1 do begin		; loop through the ndr unique drifts 
                                        ; for this grid pt
      driftname[k]=tmp_pos[dr_nrs[k]].name
      scannumber[k]=tmp_pos[dr_nrs[k]].scannumber
      index2=where(abs(tmp_pos[dr_nrs[k]].rahr-ra[i]) lt 0.00555 and $
                   abs(tmp_pos[dr_nrs[k]].decdeg-dec[j]) lt 0.083333,nd)
;     repeat this vicinity calculation b/c it's fast and simplifies code read
      recindx=index2 mod nrec		
;     1D array of rec nrs, for each rec in drift that counts to grid pt
      bmindx =index2/nrec		
;     1D array of bm nrs, for each rec in drift that counts to grid pt
      bm_nrs=bmindx[uniq(bmindx)]	
;     set of unique bm indices in this drift contribtng to grid pt
      n_bms=n_elements(bm_nrs)
;      PRINT,'     ',K,N_BMS,DRIFTNAME      
;     and now loop through the beams in this drift and find the start and stop rec nrs
      for n=0,n_bms-1 do begin
        beamnr=bm_nrs[n]
        indxb=where(bmindx eq bm_nrs[n],nbb)
        startrecnr[k,beamnr]=recindx[indxb[0]]
        stoprecnr [k,beamnr]=recindx[indxb[nbb-1]]
;        PRINT,'             ',N,BEAMNR,STARTRECNR[BEAMNR],STOPrecNR[BEAMNR]
      endfor
    endfor
    record_MAKEUP={i:i,j:j, 	$
		  ra:ra[i],	$
		  dec:dec[j], 	$
		  driftname:driftname, $
		  scannumber:scannumber, $
		  startrecnr:startrecnr, $
		  stoprecnr:stoprecnr, $
		  date:systime(0)}
    write_to_makeup:
    if (i eq 0 and j eq 0) then begin
      GRID_MAKEUP=record_MAKEUP
    endif else begin
      GRID_MAKEUP=[GRID_MAKEUP,record_MAKEUP]
    endelse
  endfor
endfor



; PART 2.2 - added by B. Kent
;Plot the defined box and over plot the drifts
window, /free, retain=2, xsize=800, ysize=800

;Set window
hor, ramax+1.0/15.0, ramin-1.0/15.0
ver, decmin-1.0, decmax+1.0

;Plotting space
device, decomposed=1
plot, [0,0],[0,0], /nodata, xtitle='RA [Hrs]', ytitle='Dec [Deg]', $
  title='Map center at RA: '+strcompress((ramin+ramax)/2.0)+', Dec: '$
  +strcompress((decmin+decmax)/2.0)

;Display box
tvboxbk, [ramax-ramin, decmax-decmin], ramin+(ramax-ramin)/2.0, decmin+(decmax-decmin)/2.0, $ 
/data, color='0000FF'XL

;Overplot drifts
for i=0, map_ndrift-1 do begin
     dirindex=where(pos.name eq drift_list[i].name)      
     for j=0, 6 do oplot, pos[dirindex].rahr[*,j], pos[dirindex].decdeg[*,j], color='00FF00'XL
endfor

;...........................................................................................
; PART 3. Loading the data files
;	Here we load the data files, one drift scan at a time, referring to
;	the drift_list structure created in PART 1. We process the data
;	of each drift, "filling" with its contribution the bin of each
;	grid pt that's appropriate.
;	The final products are: 
;	- a grid_map	a 4D array of spectral values (spec ch, pols, grid pt X, grid pt Y)
;	- a weight_map	a 4D array of weights, same dimensionality as grid_map 

weight_map=fltarr(nch_cube,2,NX,NY)	; array of weights for the new grid
grid_map=fltarr(nch_cube,2,NX,NY)	; array of new grid values
cont_map=fltarr(2,NX,NY)                ; array of new continuum values  ;---> Added by B. Kent
cont_weight_map=fltarr(2,NX,NY)         ; array of continuum weights     ;---> Added by B. Kent

; Here start big loop through each drift in drift_list
;...........................................................................................
for idr=0,map_ndrift-1 do begin			; loop through each drift in drift_list
  
  driftname=drift_list[idr].name
  dirindex=where(pos.name eq drift_list[idr].name)
  driftfilepath=masterdir(dirindex)+driftname
  indx=where(grid_makeup.driftname eq driftname,NN)	;NN is the number of grid pts
  dims=size(grid_makeup.driftname,/dimensions)		;to which this drift contributes
  n_entries=dims[0]
  indx_entry=indx mod n_entries		; 1D array of NN elements with the ordinal locations 
 					; of the drift in the list of up to 16 in GRID_MAKEUP
					; for each of the NN grid pts affected
  indx_grdpt=indx/n_entries		; index of the grid pt in GRID_MAKEUP for the NN grid 
					; pts affected
  
  restore,file=driftfilepath
  print,idr,' processing file:',driftname+' located at '+driftfilepath,'  ',NN,' grid pts'
; next:
;- rescale calibration
;- read pos.badbox and either replace bb with NaN, noise or interpolate
;- shift all spectra in drift to standard freq range
;- restrict spectra to desired channel range between vmin and vmax
;- smooth all spectra in drift
;- baseline all spectra in drift

  nrec=n_elements(dred[0,*,0])
  nbm=n_elements(dred[0,0,*])
  nchn=n_elements(dred[0,0,0].d)

; PART 3.1	Rescale Calibration

  mjd=dred[0,300,0].hf.mjd_obs	; mod Julian Date at center of drift
  cal_fx=fltarr(2,8)+1.		; factors to multiply each pol/bm spec to even flux scale
;  cal_fx=1.			; here define (or read from table) cal factors
  cal_fx[*,0]=1000./11.
  cal_fx[*,1:7]=1000./8.6
  dwrk=dred
  
  ;Apply continuum fix to remove the 12-second radar from the continuum
  continuumfix, cont_pt    ;---> Added by B. Kent

 cont_pt_wrk=cont_pt       ;---> Added by B. Kent


  for np=0,1 do begin
    for nb=0,nbm-1 do begin
      fx=cal_fx[np,nb]
      dwrk[np,*,nb].d=dred[np,*,nb].d*fx
      cont_pt_wrk[np,*,nb]=cont_pt[np,*,nb]*fx   ;---> Added by B. Kent
    endfor
  endfor

; PART 3.2	Hanning smooth if desired

  dwrk2=dwrk
  if (hansmooth eq 1) then begin
    hansmo=[0.5,1.,0.5]/2.
    for ip=0,1 do begin
      for ib=0,nbm-1 do begin
        for ir=0,nrec-1 do begin
          dwrk2[ip,ir,ib].d = convol(reform(dwrk[ip,ir,ib].d),hansmo,$
                      /EDGE_TRUNCATE,/NAN,MISSING=0)
        endfor
      endfor
    endfor
  endif
  dwrk=dwrk2

; PART 3.3	Get pos.badbox and create 4D mask wmask, and if MEDSUBTRACT=1 &
;		if badbox extends through whole drift (permanent RFI
;		feature), subtract the median within badbox from all spectral
;		data in given bm, pol 

  posindx=where(pos.name eq driftname)
  wmask=bytarr(nchn,2,nrec,nbm)+1B
  for np=0,1 do begin
    for nb=0,nbm-1 do begin
      inbb=where(total(reform(pos[posindx].badbox[*,np,nb,*]),2) ne 0,nbb)
      for ibb=0,nbb-1 do begin
        llch=pos[posindx].badbox[inbb[ibb],np,nb,0]
        urch=pos[posindx].badbox[inbb[ibb],np,nb,2]
        llrec=pos[posindx].badbox[inbb[ibb],np,nb,1]
        urrec=pos[posindx].badbox[inbb[ibb],np,nb,3]
        if (urrec ge nrec) then urrec=nrec-1            ; PLUG FOR BAD POS FILES
        wmask[llch:urch,np,llrec:urrec,nb]=0B
	if (medsubtract eq 1 and llrec eq 0 and urrec eq nrec-1) then begin
          bmpolmed=MEDIAN(reform(dwrk[np,*,nb].d),Dimension=2,/EVEN) ; 1D spec
          for ir=0,nrec-1 do begin
            dwrk[np,ir,nb].d[llch:urch]=bmpolmed[llch:urch]
          endfor
        endif
      endfor
    endfor
  endfor


; PART 3.4	Shift all spectra in drift so that vhel=7663 is in ch 2048

  heliovelproj=dred[0,nrec/2,0].h.pnt.r.heliovelproj*299792.458
  heliovelused=dred[0,0,0].h.dop.velobsproj	;immaterial for our computations
  cenfrq_used=dred[0,nrec/2,0].hf.rpfreq
  cenfrq_correct=1420.4058/(1.+(7663.-heliovelproj)/299792.458)
  delta_ch=(cenfrq_used-cenfrq_correct)/0.024414063
; if frq_used at 2048 is higher than frq_correct, we have to shift data UP for match
  dred.d=SHIFT(dred.d,delta_ch,0,0,0)
; 		Shift also the wmask
  wmask=SHIFT(wmask,delta_ch,0,0,0)
;		...and compute vel array
  frqarr=cenfrq_used+(findgen(nchn)-2048)*0.024414063
  velarr=299792.458*(1420.4058/frqarr -1.)+heliovelproj 
; which should place vhel=7663 at ch 2048
          

; PART 3.5	Trim 
;			Restrict spectral range to desired nr of channels n1:n2
;			both for data array and weight mask

  res=min(abs(velarr-czmin),ind)
  n2=ind
  n1=n2-nch_cube+1		; nch_cube=n2-n1+1 is the nr of sp chan after trim
  d_cube=dwrk.d[n1:n2]
  wmask_cube=wmask[n1:n2,*,*,*]
  varr=velarr[n1:n2]


; PART 3.6	Loop through al grid pts to which given drift makes a contribtn
;		FOR EACH GRID PT AFFECTED BY THE DRIFT:
;		- remind us which beams and, for each beam, which rec nrs are relevant
;		- remind us the i,j and ra,dec of the grid pt
;		- THEN LOOP through all beams, and if bm contrbts,
;			- LOOP through the recs that contribute
;			  	compute distance of each rec from grd pt
;				assign a "position" weight pweight
;				set wmask_cube=0 if the pos.status for reecord is flagged bad
;				add spectrum to the grd pt bin, weighted by pweight and wmask_cube
;				add pweight*wmask_cube to the weight_map bin of the grid pt

;  comp_data=dred.d[2651:3450]	;this is now an array of 800x2x600x8
;  ch1=2651
;  ch2=3450
;  dwrk=dred
  comp_data=d_cube

  frstrec=lonarr(8)		;define type
  lastrec=lonarr(8)
  for ngr=0,NN-1 do begin	; loop through all grid points to be affected by drift idr
    entry_nr=indx_entry[ngr]	; which location (of 16) corresponds to drift idr grid pt # ngr
    grdpt_nr=indx_grdpt[ngr]	; which index in grid_makeup corresponds to grid pt # ngr
    frstrec=grid_makeup[grdpt_nr].startrecnr[entry_nr,*]	; array of 8 first recs to use
    lastrec=grid_makeup[grdpt_nr].stoprecnr[entry_nr,*]		; array of 8 last recs to use 
    igrd=grid_makeup[grdpt_nr].i	; grid location of grid pt ngr
    jgrd=grid_makeup[grdpt_nr].j	; grid location of grid pt ngr
;   WHAT IF THERE IS NO DATA NEAR THE GRID PT? ==> SET WEIGHT_MAP TO ZERO
    if (total(grid_makeup[grdpt_nr].scannumber) eq 0) then begin
      weight_map[*,*,igrd,jgrd]=0.
      cont_weight_map[*,igrd,jgrd]=0.      ;---> Added by B. Kent
      goto, endof_gridpt_loop
    endif
    indx_bm=where(lastrec ne 0,nbmcontrb)	; beam tracks that will afffect grid pt ngr
    ragrdpt=grid_makeup[grdpt_nr].ra*15.*!PI/180.	; ra of grid pt in rad
    decgrdpt=grid_makeup[grdpt_nr].dec*!PI/180.		;dec of grid pt in rad
    cosdec=cos(decgrdpt)
    for nb=0,nbmcontrb-1 do begin 	; loop through all beam tracks contributing
      near_bm=indx_bm(nb)	; note that the near beam is near_bm, not nb
      if (indx_bm[nb] eq 7) then goto, endofnbloop	; skip the lame "beam"
      for nr=frstrec[near_bm],lastrec[near_bm] do begin	
	  ; loop through the recs found in vicinity of grid pt
        spec=comp_data[*,*,nr,near_bm]	; spectrum (2 pols: 4096x2) of rec nr, beam nb

        cont=cont_pt_wrk[*,nr,near_bm]  ; continuum point (2 element float array)   ;---> Added by B. Kent

        raspec=dred[0,nr,near_bm].rahr*15.*!PI/180.	; ra of spectrum above
        decspec=dred[0,nr,near_bm].decdeg*!PI/180.
        delra=(raspec-ragrdpt)*cosdec
        dist2=((raspec-ragrdpt)*cosdec)^2+(decspec-decgrdpt)^2 ; ang sep bw rec and grid pt
        pweight=exp(-0.5*(dist2/sigma^2))	; weight due to vicinity alone
        if (nb eq 0) then pweight=1.27*pweight
        for ip=0,1 do begin
          if (pos[posindx].status[ip,nr,near_bm] eq 1) then wmask_cube[*,ip,nr,near_bm]=0.
        endfor
        weight_map[*,*,igrd,jgrd]=weight_map[*,*,igrd,jgrd]+pweight*wmask_cube[*,*,nr,near_bm]
        grid_map[*,*,igrd,jgrd]=grid_map[*,*,igrd,jgrd] + $
                                spec[*,*]*reform(pweight*wmask_cube[*,*,nr,near_bm])
        
        cont_weight_map[*,igrd,jgrd]=cont_weight_map[*,igrd,jgrd]+pweight    ;---> Added by B. Kent

        cont_map[*,igrd,jgrd]=cont_map[*,igrd,jgrd]+cont[*]*pweight    ;---> Added by B. Kent

; IF (IGRD EQ 0 AND JGRD EQ 34) THEN BEGIN
;  FOR IIP=0,1 DO BEGIN
;    PRINT,DRIFTNAME,NEAR_BM,NR,IIP,DIST2*180.*60./!PI,PWEIGHT,WMASK_CUBE[100:130,IIP,NR,NEAR_BM],FORMAT='(A30,I2,I4,I2,2F6.3,1X,30I1)'
;  ENDFOR
; ENDIF
;	IF(GRDPT_NR EQ 521) THEN BEGIN
;          PRINT,DRIFTNAME,ENTRY_NR,NEAR_BM,NR,WEIGHT,FORMAT='(A30,I4,I3,I4,F6.3)'
;	ENDIF

      endfor
    endofnbloop:
    endfor
  endof_gridpt_loop:
  endfor
endfor
  
;.............................................................................................        
; PART 4	Divide grid_map by weight_map, and:
;		Keep in mind that the "synthesized beam" area has been increased with respect 
;		to that of the telescope, in the measure of the sqrt of the ratio
;		(telFWHM^2+wtFWHM^2)/telFWHM^2,
;		the flux density scale has thus been modified (depressed) by the same factor,
;		i.e. the flux that was comprised within telFWHM has now been spread over
;		sqrt(telFWHM^2+wtFWHM^2)
;		

map=grid_map/weight_map
cont_map_final=cont_map/cont_weight_map
indx=where(finite(map) eq 0,ncount)
print,ncount,' spectral values in grid map are NaN;'
print,       ' if weight_map=0, map is set to 0'
print,N_nodata,' grid points have no data nearby'
for ip=0,1 do begin
  for ii=0,NX-1 do begin
    for jj=0,NY-1 do begin
      ind=where(finite(map[*,ip,ii,jj]) eq 0,ncount)
      if (ncount gt 0) then map[ind,ip,ii,jj]=0.
      if (ncount gt 0) then cont_map[ip,ii,jj]=0    ;---> Added by B. Kent
    endfor
  endfor
endfor

map_projection='orthogonal'
wf_type='Gaussian'
baseline={nbase:intarr(2,NY), $
          coeffs:dblarr(2,NX,NY,10), $
          nreg:lonarr(2,NY,40,4), $
          rms:fltarr(2,NX,NY)}


calib_facs=dblarr(2,8,5)+1D
grms=stddev(map)
;cont=fltarr(2,NX,NY)  ;---> Commented out by B. Kent
who=''
; we'll need to seet ^^these earlier in the program 

grid={name:gname, $
      RAmin:ramin, Decmin:decmin, Epoch:epoch, $
      DeltaRA:dgrasec, DeltaDec:dgdecmin, $
      NX:NX, NY:NY, $
      map_projection:map_projection, $
      czmin:czmin, $
      NZ:nch_cube, $
      velarr:varr, $
      wf_type:wf_type, $
      wf_fwhm:w_fwhm, $
      han:hansmooth, $
      medsubtract:medsubtract, $
      baseline:baseline, $
      calib_facs:calib_facs, $
      grms:grms, $
      date:systime(0), $
      who:who, $
      pos:tmp_pos, $
      drift_list:drift_list, $
      grid_makeup:grid_makeup, $
      d:map, $
      w:weight_map, $
      cont:cont_map_final, $
      cw:cont_weight_map} 

t00=systime(1)




t3=systime(1)

end			; End of procedure
	
