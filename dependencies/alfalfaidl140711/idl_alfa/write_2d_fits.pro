; standalone version (no args, no params)
; should work on ALFALFA grids of any size
; asks for grid.sav filename 
; asks for the name of the grid structure
; WARNING: assumes the name of the grid str. contains string 'grid'
; averages 2 polarizations
; asks for a velocity range and integrates the grid within the range
; the resulting 2D map is in units=(original units)*(km/s)
; asks for output.fits filename
; outputs the map as fits file with some WCS header info

pro write_2d_fits

print,' enter name of grid save file'
input_name='aaaaaa'
read,input_name
restore,input_name

; grid name
print,' '
print,' the variables defined are :'
print,' '
help,names='*grid*'
print,' '
print,'enter name of grid structure [def GRID]'
struct_name='aaaaaa'
read,struct_name
if struct_name eq '' then struct_name='grid'
struct=scope_varfetch(struct_name)

; dimensions
sizedata=size(struct.d)
ndimens=sizedata(0)
nchann=sizedata(1)
npol=sizedata(2)
nra=sizedata(3)
ndec=sizedata(4)

; RA array in decimal hours
ra=struct.ramin + indgen(nra)*struct.deltara/3600.
ramax=max(ra)
ramin=min(ra)

; DEC array in decimal deg
dec=struct.decmin + indgen(ndec)*struct.deltadec/60.
decmax=max(dec)
decmin=min(dec)

;  Vel array in km/s
vel=struct.velarr

; average of the 2 polarizations   
cube_avpol = 0.5*( struct.d[*,0,*,*] + struct.d[*,1,*,*] )
cube_av=reform(cube_avpol)     ; now a 3d array

; velocity interval
vmax=max(vel)
vmin=min(vel)
print,' '
print,' vel.s from ',vmin,' to ',vmax,' km/s'
print,' enter v_start and v_end (km/s)'
read,vstart,vend
start_chn=value_locate(vel,vend)
end_chn=value_locate(vel,vstart)
center_chn=(start_chn+end_chn)/2
dv0=(vel(center_chn)-vel(center_chn+1)) ; avrg channel width in km/s

; integrate on the given vel interval
cube0= cube_av[start_chn:end_chn,*,*]
map0=(total(cube0,1)*dv0)   ;units are (original units)*(km/s)

; reverse the RA axis
map_rev=reverse(map0,1) ; reverse the RA axis 
ra_rev=reverse(ra,1)

;;;; MAKE FITS FILE

mkhdr,hdr,map_rev  ; make simple header

;;;;  ADD WCS INFO

crpix1=nra/2 ; X location of ref pixel
crpix2=ndec/2 ; Y location of ref pixel
crval1=ra_rev(crpix1)*15. ; X value of ref pixel in deg
crval2=dec(crpix2) ; Y value of ref pixel in deg
cdelt1=-(struct.deltara/3600.*15.)*cos(crval2/180.*!pi) ; X step in deg
cdelt2=struct.deltadec/60. ; Y step in deg

sxaddpar,hdr,'CTYPE1','RA---TAN'
sxaddpar,hdr,'CDELT1',cdelt1,'X axis increment [deg]'
sxaddpar,hdr,'CRPIX1',crpix1,'X coord of ref pixels'
sxaddpar,hdr,'CRVAL1',crval1,'RA of ref pixel [deg]'
sxaddpar,hdr,'CTYPE2','DEC--TAN'
sxaddpar,hdr,'CDELT2',cdelt2,'Y axis increment [deg]'
sxaddpar,hdr,'CRPIX2',crpix2,'Y coord of ref pixel'
sxaddpar,hdr,'CRVAL2',crval2,'DEC of ref pixel [deg]'
sxaddpar,hdr,'EQUINOX',2000.000,'equinox of coordinates'
sxaddpar,hdr,'BUNIT','???'
sxaddpar,hdr,'BZERO',0
sxaddpar,hdr,'BITPIX',-64
sxaddpar,hdr,'BSCALE',1
sxaddpar,hdr,'TELESCOP','Arecibo 305-m'
sxaddpar,hdr,'INSTRUM','ALFA'
sxaddpar,hdr,'IN-FILE',input_name
sxaddpar,hdr,'GRID',struct_name
sxaddpar,hdr,'POLARIZ','(A+B)/2'
sxaddpar,hdr,'VEL1',vstart,'start velocity range [km/s]'
sxaddpar,hdr,'VEL2',vend,'end velocity range [km/s]'


print,' '
print,' enter name of fits file'
namefits='aaaaaa'
read,namefits
if namefits eq input_name then print,' WRONG NAME!!' 
if namefits ne input_name then writefits,namefits,map_rev,hdr

end


