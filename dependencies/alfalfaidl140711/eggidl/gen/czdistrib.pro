;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO CZDISTRIB, INPUT_FILE_NAME,H0,PHI_STAR,LOGM_STAR,ALPHA
;+
;NAME:
;	CZDISTRIB
;PURPOSE:
;	To read a catalog file in the tabular format (*.table, the output of distance_catalog) and 
;	plot the observed redshift distribution against an expected redshift distribution
;	based on an input HIMF in Schechter form. The code does apply a completeness correction,
;	but does not account for the average spectral weights as a function of redshift.
;
;	NOTE: HVCs are left out of this analysis. Additionally, epsinit.pro and epsterm.pro
;	must be compiled to run this program.
;
;SYNTAX:
;	CZDISTRIB, input_file_name,H0,phi_star,logm_star,alpha
;
;INPUTS:
;	input_file_name - the full name of an input file in Riccardo's format, including directory structure.
;	H0 - value of the Hubble parameter (70.0 for ALFALFA)
;	PHI_STAR - value of phi_star in the selected HIMF
;	LOGM_STAR - value of log(M*) in the selected HIMF
;	ALPHA - faint-end slope in the selected HIMF
;	
;
;OUTPUTS:
;	cz_distribution.eps - EPS plot of the redshift distribution histogram (bin size 250 km/s) with
;				the expected redshift distribution overplotted as a dashed curve.
;	
;
;EXAMPLE:
;	czdistrib,'CR5.table',70.0,0.0086,9.79,(-1.30)
;
;	
;
;REVISION HISTORY:
;       Written	A.Martin   March 2006
;       Edited (correcting mistake in volume calculation), A. Martin, December 2008
;-

;convert logm_star to m_star
m_star=10.0^(logm_star)

;Pre-define strings
HINAME = ''
AGCNUM = ''
AGCNAME = ''
GRIDID = ''
SIGN = ''
OPTSIGN = ''

;create arrays for the HI mass, the distance in Mpc, the flux, the width, and the redshift.
;now also need to add the coordinates
massarr=dblarr(1)
distarr=dblarr(1)
fluxarr=dblarr(1)
warr=intarr(1)
czarr=intarr(1)
;NOTE: RA AND DEC WILL BE IN DEGREES
raarr=dblarr(1)
decarr=dblarr(1)

;read in the catalog and add information to arrays
openr, catlun, input_file_name, /get_lun

while(EOF(catlun) ne 1) do begin

readf,catlun,mycatnr,myagcnumber,rah,ram,ras,sign,decd,decm,decs,optrah,optram,optras,$
	optsign,optdecd,optdecm,optdecs,mycz,myw50,mywerr,myflux,myfluxerr,mysnr,myrms,mydistmpc,$
	myloghimass,code,$
format='(i5,2x,i6,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,1x,i2,7x,i2,1x,i2,1x,f4.1,8x,a1,i2,1x,i2,1x,i2,2x,i6,2x,i5,2x,i3,2x,f6.2,2x,f4.2,2x,f7.1,2x,f6.2,2x,f6.1,2x,f6.2,2x,i1)'


	if((CODE NE 9) AND (MYW50 LE 1000)) then begin
		massarr=[massarr,MYLOGHIMASS]
		distarr=[distarr,MYDISTMPC]
		fluxarr=[fluxarr,MYFLUX]
		warr=[warr,MYW50]
		czarr=[czarr,MYCZ]

		rahours = float(rah) + float(ram)/60 + float(ras)/3600
		ra=rahours*15
		dec= float(decd)+ float(decm)/60 + float(decs)/3600

		if(sign eq '-') then dec = -dec
		;at this point, ra and dec are in DEGREES
		raarr=[raarr,ra]
		decarr=[decarr,dec]

	endif
endwhile

close, catlun
free_lun, catlun

massarr=massarr(1:*)
distarr=distarr(1:*)
fluxarr=fluxarr(1:*)
warr=warr(1:*)
czarr=czarr(1:*)
raarr=raarr(1:*)
decarr=decarr(1:*)


print,'Number of elements in first cut: ',n_elements(massarr),n_elements(distarr),n_elements(fluxarr),n_elements(warr),n_elements(czarr)

;prepare to make a sub-sample
limmass=dblarr(1)
limdist=dblarr(1)
limflux=dblarr(1)
limw=intarr(1)
limcz=intarr(1)
limra=dblarr(1)
limdec=dblarr(1)


;use the following loop if you want to select a sub-sample of observed
;galaxies based on a flux limit or other criteria. Right now this loop does
;nothing to affect the sample.
i=0
while (i LT n_elements(massarr)) do begin
	mass=massarr(i)
	dist=distarr(i)
	flux=fluxarr(i)
	w50=warr(i)
	cz=czarr(i)
	newra=raarr(i)
	newdec=decarr(i)

	;if (flux GE fluxlimit) then begin
	if (flux le 1000) then begin
		limmass=[limmass,mass]
		limdist=[limdist,dist]
		limflux=[limflux,flux]
		limw=[limw,w50]
		limcz=[limcz,cz]
		limra=[limra,newra]
		limdec=[limdec,newdec]
	endif	

	i=i+1
endwhile

limmass=limmass(1:*)
limdist=limdist(1:*)
limflux=limflux(1:*)
limw=limw(1:*)
limcz=limcz(1:*)
limra=limra(1:*)
limdec=limdec(1:*)

print,'Number of elements in second cut: ',n_elements(limmass),n_elements(limdist),n_elements(limflux),n_elements(limw),n_elements(limcz)
ngal=n_elements(limmass)


;initialize the EPS
epsinit,'cz_distribution.eps',xsize=6,ysize=4,/VECTOR

;plot the histogram
plothist,limcz,xhist,yhist,bin=250,xrange=[0,18000],xstyle=1,XTICKFORMAT='(I5)',xtickinterval=5000,xtitle='cz[km/s]',ytitle='N',xthick=2,ythick=2,charsize=1.5,charthick=2,thick=3

;we now have a set of arrays with all the information we need to figure out the expected distribution.
;first figure out the overall maximum distance
;and the total volume
maxdist=max(limdist)
print,'Maximum distance: ',maxdist
massconstant=235600.0
;limits of the survey
onedeg=!dpi/180.0
ramin=7.5*15.0*onedeg
ramax=16.5*15.0*onedeg
decmin=12.0*onedeg
decmax=16.0*onedeg
maxvolume=(ramax-ramin)*abs(sin(decmin)-sin(decmax))*(maxdist^3)/3.0
;print,maxvolume
n_gal_obs=n_elements(limmass)
;now you can estimate the average density
density_avg=n_gal_obs/maxvolume
print,'Average density: ',density_avg

;The HIPASS values for the Schechter fit to HIMF:
;H0=70.0
;phi_star=0.0086
;m_star=10.0^(9.79)
;alpha=-1.30
;set up other constants:
dalpha=alpha*2.0
mass_cons=2.356*100000
crazy=(mass_cons/m_star)^alpha
lesscrazy=(mass_cons/m_star)

v_array=(dindgen(370)+0.5)*50.0
nofv_array=dblarr(n_elements(v_array))
num_vs=n_elements(v_array)

flux_arr=(dindgen(600)+5.1)*0.2

;completness correction
noff_array=dblarr(n_elements(flux_arr))
obsnoff_array=dblarr(n_elements(flux_arr))
num_fs=n_elements(flux_arr)
for j=0,num_fs-1 do begin
	schech_flux=flux_arr[j]
	temp_vel=(dindgen(610)+0.5)*50.0
	corr_nofvf=density_avg*(mass_cons)*phi_star*((temp_vel)^4.0)*((H0)^(-5.0))*((temp_vel/H0)^dalpha)*crazy*((schech_flux)^alpha)* exp(-1.0*lesscrazy*schech_flux*((temp_vel/H0)^2.0))
	corr_noff_result=int_tabulated(temp_vel,corr_nofvf,/DOUBLE)
	noff_array[j]=corr_noff_result

	index=where((limflux GE (schech_flux-0.1)) AND (limflux LE (schech_flux+0.1)),count)

	obsnoff_array[j]=count
endfor

corrgal_total=total(noff_array)
corrobs_total=float(n_gal_obs)
corr_coeff=corrobs_total/corrgal_total
noff_array=corr_coeff*noff_array
;print,noff_array

;print,total(obsnoff_array)
;print,total(noff_array)

;plot,flux_arr,obsnoff_array
;oplot,flux_arr,noff_array

complete_off=obsnoff_array/noff_array
;print,complete_off

for i=0,num_vs-1 do begin
	schech_vel=v_array[i]
	temp_flux=flux_arr
	;phi_flux=phi_star * crazy * ((schech_vel/H0)^(dalpha)) * ((temp_flux)^alpha) * exp(-1.0*lesscrazy*temp_flux*((schech_vel/H0)^2.0))
	nofvf=density_avg*(mass_cons)*phi_star*((schech_vel)^4.0)*((H0)^(-5.0))*((schech_vel/H0)^dalpha)*crazy*((temp_flux)^alpha)* exp(-1.0*lesscrazy*temp_flux*((schech_vel/H0)^2.0))
	completeness_nofvf=nofvf*complete_off
	nofv_result=int_tabulated(temp_flux,completeness_nofvf,/DOUBLE)
	nofv_array[i]=nofv_result

endfor

;then you want the total number of galaxies so that you can normalize your expected distribution
;gal_total=total(nofv_array)/5.0
;obs_total=float(n_gal_obs)
; or the total integrated area, which works out better
gal_total=int_tabulated(v_array,nofv_array,/DOUBLE)
obs_total=int_tabulated(xhist,float(yhist))

num_coeff=obs_total/gal_total
nofv_array=num_coeff*nofv_array

;print,nofv_array
oplot,v_array,nofv_array,thick=5,linestyle=5

epsterm


;check to make sure the integrated areas are equivalent
result_one=int_tabulated(xhist,float(yhist))
print,result_one
result_two=int_tabulated(v_array,nofv_array,/DOUBLE)
print,result_two


;print,nofv_array

END
