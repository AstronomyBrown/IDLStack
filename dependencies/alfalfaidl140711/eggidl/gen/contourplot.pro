;NAME:
;	 CONTOURPLOT
;
;PURPOSE:
;        Create contour diagram to overlay on an image.	
;
;CALLING SEQUENCE:
;        contourplot,grid,chanmin,chanmax
;
;        example:
;        IDL> restore, '/home/vieques2/galaxy/grids/1436+05/gridbf_1436+05a.sav'
;	 IDL> contourplot,grid,296,358
;
;OUTPUTS:
;	 A sav file of the contour plot parameters to be used for overlay.pro
;        or a contour plot which can be saved as a jpg using:
;        response=tvread(filename='contour',/JPEG,quality=100,/nodialog)
;
;NOTES:
;        Before running this program the grid of the contour you would like to
;        make must be restored. If you don't know what grid your object is 
;        located in, use findgrid.pro to find the correct grid. You can then
;        open up gridview to find the minimum and maximum channels of your
;        objects.
;
;        MAKING OVERLAYS:
;        Making overlays requires three steps: creating the contour, creating
;        the image and then overlaying them. This program only creates the
;        contour. There is also a well documented webpage:
;        file:///home/dorado3/galaxy/eggidl/gen/makeoverlay.htm
;        which outlines the entire process of making a contour overlay. Read
;        through all of this code and the webpage otherwise you might run into
;        problems!
;
;        REGIONS OF CODE LIKELY TO NEED ADAPTATION BY EACH USER:
;        The contour levels are non-trivial but the program does a good first
;        guess. It then prints out the maximum and minimum velocity levels
;        which can be used to decide on final contour levels. Adjust code
;        accordingly in lines 112 and 115.
;
;        Lines 120 through 135 will need adjusting for each individual contour.
;        Decide on a suitable plotting range and then save the parameters or plot.
;
;
;REVISION HISTORY:
;	Created by Sabrina Stierwalt
;	Revised and Documented July 2009, Tess Senty
;   Directory references changed by mph 2013
;-

PRO CONTOURPLOT,grid,chanmin,chanmax

;FIRST SET UP THE CONTOUR LEVELS YOU WILL USE FOR THE PLOT

;Average the polarizations
z=reform((grid.d[*,0,*,*]+grid.d[*,1,*,*])/2.)

;Zoom in to the area of interest
channelrange=(chanmax-chanmin)+1.

;Determine the contour values (i.e. find where the emission peaks in the 
;velocity range specified by the channel ranges entered above)
peaks=fltarr(n_elements(z[0,*,0]),n_elements(z[0,0,*]))
locatepeaks=fltarr(n_elements(z[0,*,0]),n_elements(z[0,0,*]))
for i=0,n_elements(z[0,*,0])-1. do begin
    for j=0,n_elements(z[0,0,*])-1. do begin
        peaks[i,j]=max(z[chanmin:chanmax,i,j],spot)
        locatepeaks[i,j]=spot
    endfor
endfor
flevels=.1*peaks ;we will be searching for when the signal drops to 10 percent of the peak
lowlefts=fltarr(n_elements(z[0,*,0]),n_elements(z[0,0,*]))
lowrights=fltarr(n_elements(z[0,*,0]),n_elements(z[0,0,*]))
for i=0,n_elements(z[0,*,0])-1. do begin
    for j=0,n_elements(z[0,0,*])-1. do begin    
        lowl=locatepeaks[i,j]+chanmin
        repeat lowl=lowl-1. until z[lowl,i,j] le flevels[i,j]
        lowr=locatepeaks[i,j]+chanmin
        repeat lowr=lowr+1. until z[lowr,i,j] le flevels[i,j]
        lowlefts[i,j]=lowl
        lowrights[i,j]=lowr
    endfor
endfor

znew=fltarr(n_elements(z[0,*,0]),n_elements(z[0,0,*]))
for i=0,n_elements(z[0,*,0])-1. do begin
    for j=0,n_elements(z[0,0,*])-1. do begin    
        znew[i,j]=reform(total(z[lowlefts[i,j]:lowrights[i,j],i,j],1))/(lowrights[i,j]-lowlefts[i,j])
    endfor
endfor 

;Get the ra and dec for the axes
velocity=grid.velarr[chanmin:chanmax]
rah=grid.ramin+(dindgen(n_elements(grid.d[0,0,*,0]))+0.5)*grid.deltara/3600.
dec=grid.decmin+(dindgen(n_elements(grid.d[0,0,0,*]))+0.5)*grid.deltadec/(60.)

;rename rah and dec. If you know your area of interest, you can zoom in here 
;otherwise you can zoom in later with the xrange and yrange of your contour plot.
;"zoom in" example: rahr=rah[0:117]
rahr=rah
decdeg=dec
znew=znew
print, min(znew),max(znew)

;picking the contour levels that you want to plot is not obvious - if you don't
;go low enough, you miss smaller structures, but if you go too low, the plot 
;looks like a mess. The c_levels we specify here are a good first guess, but you 
;should play with these values to get something that looks right. Looking at
;min(znew) and max(znew) is helpful to give you an idea of the range.
rms=stddev(znew)
;first guess:
c_levels=rms*(dindgen(20)+1)

;adjust the c_levels below to make a final decision:
;c_levels=[]
print,c_levels

n_levels=rms*[-2.0, -1.0]

;I played around with what I wanted the contours to look like before switching 
;these lines from ploting to save. I also adjusted the x and y range for the 
;plot depending on the region I wanted to plot.

contour,znew,rahr,decdeg,levels=c_levels

;xmin=
;xmax=
;ymin=
;ymax=
;Remember to plot your RA from "large" to "small"! Notice how I set up the
;xrange values!

;contour,znew,rahr,decdeg,xrange=[xmax,xmin],yrange=[ymin,ymax],levels=c_levels

;save,znew,rahr,decdeg,c_levels,xmin,xmax,ymin,ymax,filename='contour.sav'

END
