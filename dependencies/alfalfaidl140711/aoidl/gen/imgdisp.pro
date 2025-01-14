;+
;NAME:
;imgdisp - display a 2-d array as an image.
;SYNTAX : imgdisp,d,ret,zx=zx,zy=zy,/histeq,/rdpix,win=win,border=border,
;          xrange=xval,yrange=yval,/axes,sort=sort,_extra=e,nomodlut=nomodlut,$
;	       usecongrid=usecongrid,noscale=noscale,nodisplay=nodisplay		
; ARGS   : 
;        d[m,n] : data to display
; KEYWORDS: 
;       zx: int x zoom factor
;       zy: int y zoom factor
;  usecongrid:     if set and zx or zy, then use congrid rather than
;				rebin for the new image.
;   histeq: set for histogram equalization of image disp
;     sort: if set then use sort for histogram equalization.
;    rdpix: set to turn on read pixel function.
;  profile: set to turn on profiles command
;      win:  int window number to use. default:1 
;   border: int  number of pixels around image to allow for labels.
;                (ignored if ps, or !p.multi in use).
;xrange[2]:float xrange for labeling the x axis (min,max)
;yrange[2]:float yrange for labeling the y axis (min,max)
;     axes:      if set then draw the axis and labels
;   invert:      if set then invert the colors white and black
;  noscale:      if set then do not bother to scale image.
;				 Use this when you are redisplaying an image that
;				 was returned by imgdisp.
;nodisplay:	     if set then just return the scaled image, do not display	   
;_extra=e        passed to plot routine when drawing the axes.
;                can include, xtitle,ytitle,title, etc..
;
;RETURNS:
;       ret[]   : array actually displayed after scaling.(optional)
;
;DESCRIPTION:
;   Display an m by n array as an image. The data is passed in 
;via the array d. It will normally create the image in window 1. This can
;be overridden with the win= keyword.
;
;   zx,zy allow you to zoom the image in the x or y dimension before display. 
;They must be integral values (rebin is used). gt 1  make the dimension
;larger while lt -1  make the dimension smaller by this amount. If the
;zoom is lt 0 then it must divide evenly into the dimension of the array.
;
;   The normal scaling of the data values is:
;   (d-minVal)/(maxVal-minVal) * number of ofColors in lookup table.
;You can switch to histogram equalization by setting /histeq. If your data
;has outliers then the /sort option will make the histogram equalization 
;work better (but it takes a little longer).
;
;   If the keyword axes is set, then tickmarks and labels will be drawn
;around the image. xrange,yrange hold the min,max values for each
;axis. If you do not specify xrange or yrange then the values 0..ndim-1
;is used. You can also pass in xtitle=,ytitle=,title=  to label the 
;axis and the plot.
;
;   Setting /rdpix will allow you to readback the position and 
;pixel values interactively.
;   You can change or load the lookup table with xloadct.
;
;Multiple plots per page.
;   The routine can also be used to place multiple images per page. In
;this case you must set !p.multi=[plotsLeft,ncols,nrows] outside of
;this routine. You must also define the size of the window you want
;to use before the first call. The border keyword is ignored.
;Each image will be scaled (congrid) to fit into the plot window.
;
;Postscript output.
;   You can also generate postscript files. To do this you call 
; psimage,args before calling imgdisp. imgdisp will check
;!d.flags for scalable pixels to determine if it is writing to a postscipt
;file. When postscript output is enabled the border keyword is ignored. 
;If !p.multi is not set then the image will fill the drawing area 
;(set in the call to psimage...default 7x9in) while keeping the aspect 
;ratio of x to y . If !p.multi is set then each image is scaled to the 
;plot window with congrid. When done with the postscript output you must 
;call hardcopy to flush the buffer.
;
;   The postscript output will look at the current lookup table. If it
;is not 0-255 then it will scale the data to 0-255 and then do 
;an indirect lookup through the lookup table. This allows you to display
;the image on the screen, change the lookup table with xloadct and then
;have the changes appear on the hardcopy output. On exit the 
;original lookup table is restored.
;
;Examples:
;   assume the images are d[1024,180]
;
;1. display image on the screen, label with a border of 50 pixels:
;   imgdisp,d,border=50,/axes,xra=[1400.,1500.],xtitle='freq [Mhz]',$
;   title='22jan01 spectra pol A'
;
;2. above, but display in landscape mode to a postscipt file:
;   imgdisp,d,border=50,/axes,xra=[1400.,1500.],xtitle='freq [Mhz]',$
;   title='22jan01 spectra pol A'
;   the border keyword is ignored.
;
;3. place  6 images per page. assume d is [1024,180,6]. 
;   window,1,xsize=1000,ysize=600       ; plot will fit in here
;   for i=0,5 do begin
;       !p.multi=[(6-i mod 6),2,3]
;       title=string(format='("image looking at distomat ",i2)',i+1)
;       imgdisp,d[*,*,i],/axes,xra=[1400.,1500.],xtitle='freq [Mhz]',$
;       title=title
;   endfor
;   
;   For the same thing with postscript output:
;   psimage
;   for i=0,5 do begin
;       !p.multi=[(6-i mod 6),2,3]
;       title=string(format='("image looking at distomat ",i2)',i+1)
;       imgdisp,d[*,*,i],/axes,xra=[1400.,1500.],xtitle='freq [Mhz]',$
;       title=title
;   endfor
;   hardcopy
;   x           ; to get back to x windows.
;
;GOTCHAS:
;1. When making images it is important to get all 256 colors for your
;  lookup table. The only way to guarantee this in idl is:
;  idl
;   p8      .. set to pseudo color mode
;  window,colors=256
;  Then proceed with normal processing.
;2. When scaling down a plot or when putting multiple plots per page
;   it is easy to loose information. If you have placed horizontal or
;   vertical lines in the plot for reference (and they are only 1 line
;   wide) they may not appear on the final image.
;3. landscape ps output does not always appear where you think it should. Any
;  page offsets are first applied and then the image is rotated by 270
;  degrees so that the xoffset points up and the yoffset points to the left.
;  psimage,/lanscape will fudge the offsets  so that
;  x'=yoff,y'=maxLen-xoff. so the origin is at the upper left. 
;  rotation by 270. this leaves:
;  y''=x, x''=(maxlen-1) so the image is inverted. It would have been nice
;  if idl did a rotate by 90 and then flip about the vertical axis...
;  For those that don't want psimage doing this magic, set xoff=0,yoff=0
;  with /landscape and this extra addition won't happen (but your plot 
;  won't be visible unless you play some games..).
;  To get a good plot out in landscape mode try using the pstops command
;  outside of idl to straighten things..
;
;  psimage,/landscape
;  plot the image
;  hardcopy
;  x
;
;  cmd=strarr(4)
;  cmd[0]='/pkg/image/bin/pstops'
;  cmd[1]='1:0u(8.5in,11in)'
;  cmd[2]='/dir.../idl.ps'
;  cmd[3]='/dir.../idlfixed.ps'
;  spawn,cmd,reply,/noshell
;
;  This should put the image in the correct location on the page.
;  You need to replace dir... with your directory..
;SEE ALSO:
;   imgflat,imgflaty,imghisteq,corimgdisp,corimgonoff
;-
;history
; 14aug03 - when zooming adjust the x,y labels to line up with the data
;           points.
; 
pro imgdisp,d,ret,zx=zx,zy=zy,histeq=histeq,rdpix=rdpix,win=win,$
    border=border,xrange=xval,yrange=yval,_extra=e,axes=axes,$
    invert=invert,profile=profile,sort=sort,nomodlut=nomodlut,$
		usecongrid=usecongrid,noscale=noscale,nodisplay=nodisplay

;
    ps= !d.flags and 1
    if not keyword_set(axes) then axes=0
    multi=0
    if (!p.multi[1] gt 0) or (!p.multi[2] gt 0) then multi=1
    noerase=1
    if (!p.multi[0] eq 0) then noerase=0
    if not keyword_set(multi) then multi=0
    if not keyword_set(invert) then invert=0
    if not keyword_set(sort) then sort=0
    if (n_elements(border) eq 0) then border=50
    if ps then border=0
        
    if (n_elements(zx)   eq 0) then zx=1
    if (n_elements(zy)   eq 0) then zy=1
    if (n_elements(win) eq 0) then win=1
        
    if zx eq -1 then zx=1
    if zx eq 0  then zx=1
    if zy eq -1 then zy=1
    if zy eq  0 then zy=1
    a=size(d)
    nx=a[1]
    ny=a[2]
    numColors=!d.table_size
	xvalLoc=[0.,nx-1]
	yvalLoc=[0.,ny-1]
    if n_elements(xval) ne 0 then xvalLoc=xval
    if n_elements(yval) ne 0 then yvalLoc=yval
;
;
;   figure out x,y size for window
;
    if zx lt 1 then begin
        nlenx=nx/abs(zx)
    endif else begin
        nlenx=nx*zx
 		if zx gt 1 then begin
;
;			for zooming suppose we start with: 1 to n and zoom by 3
;			the we get 
;			1aa2bb3cc4dd555 where,a,b.. are interpolated between the numbers.
;			the last value is repeated. To line the labels up with the 
;		    original values, use the following code.
;
 			xadd=(xvalLoc[1]-xvalLoc[0])/((nx-1.)*zx + 1.)*(zx-1.)
 			xvalLoc[1]=xvalLoc[1]+xadd
 		endif
    endelse
;
    if zy lt 1 then begin
        nleny=ny/abs(zy)
    endif else begin
        nleny=ny*zy
 		if zy gt 1 then begin 
 			yadd=(yvalLoc[1]-yvalLoc[0])/((ny-1.)*zy + 1.)*(zy-1.)
 			yvalLoc[1]=yvalLoc[1]+yadd
 		endif
    endelse
;
; create the window.. position at top middle
;
    winxmax=1152
    winymax= 900
    winxlen=nlenx + 2*border
    winylen=nleny + 2*border
    winxpos=(winxmax-winxlen)/2.
    winypos=(winymax-winylen)
;    print,"x,ysize:",nlenx,nleny,' x,ypos',winxpos,winypos
    if (not ps) and (not multi) and (not keyword_set(nodisplay)) then begin 
        window,win,xsize=winxlen,ysize=winylen,xpos=winxpos,ypos=winypos
    endif
    xoffn=(1.*border)/winxlen
    yoffn=(1.*border)/winylen
;
;   see if we rescale a dimension
;
;   if (nx ne 1) or (ny ne 1) then begin
    if (zx ne 1) or (zy ne 1) then begin
        if keyword_set(histeq) then begin
			if keyword_set(usecongrid) then begin
            	ret=congrid(imghisteq(d,invert=invert,sort=sort),nlenx,nleny)
			endif else begin
            	ret=rebin(imghisteq(d,invert=invert,sort=sort),nlenx,nleny)
			endelse
        endif else begin
            minval=min(d,max=maxval)
            delta=(maxval-minval)*1.
            if invert then  begin
				if keyword_set(usecongrid) then begin
                	ret=255B - $
                byte(congrid((numColors*(d-minval)/delta >0.)<255.,nlenx,nleny))
				endif else begin
                	ret=255B - $
                 byte(rebin((numColors*(d-minval)/delta >0.)<255.,nlenx,nleny))
				endelse
            endif else begin
			  if keyword_set(usecongrid) then begin
            ret=byte(congrid((numColors*(d-minval)/delta >0.)<255.,nlenx,nleny))
			  endif else begin
              ret=byte(rebin((numColors*(d-minval)/delta >0.)<255.,nlenx,nleny))
			  endelse
            endelse
        endelse

    endif else begin
		if keyword_set(noscale) then begin
			ret=d
		endif else begin
        	if keyword_set(histeq) then begin
            	ret=imghisteq(d,invert=invert,sort=sort)
        	endif else begin
           	 	if invert then begin
               		ret=255B - bytscl(d,top=numColors-1)
           	 	endif else begin
                	ret=bytscl(d,top=numColors-1)
             	endelse
			endelse
        endelse
    endelse
;
;   A typical sequence would be to display the image, play with the
;   lookup table, then come back and output it to postscript. For postscript
;   output we would like a linear ramp in the lut. If we find a non-linear
;   ramp in the lut we will:
;   1. do an indirect lookup through it,
;   2. load a linear lut
;   3. display
;   4. reload the old lut
;
    if ps  then begin
        tvlct,r,g,b,/get
        a=bindgen(numColors) 
        ind=where(a ne r,count)
        if count ne 0  and (not keyword_set(nomodlut))then begin
            ret=r[ret]
            loadct,0
        endif
    endif
;
;   if multi, just follow the partitioning of page by !p.multi
;   we ignore border
;
    if multi then begin
		if not keyword_set(nodisplay) then $
        plot,[0,0],[0,0],xra=xvalLoc,yra=yvalLoc,xstyle=1,ystyle=1,$
                /nodata,noerase=noerase,ticklen=-.02, _extra=e
        if (not ps) then begin
            px=!x.window * !d.x_vsize
            py=!y.window * !d.y_vsize
            sx=px[1]-px[0] + 1
            sy=py[1]-py[0] + 1
            ret=congrid(temporary(ret),sx,sy)
            if not keyword_set(nodisplay) then tv,ret,px[0],py[0]
        endif else begin
            print,!x.window,!y.window
			if not keyword_set(nodisplay) then $
            tv,ret,!x.window(0),  !y.window(0), $
                    XSIZE = !X.WINDOW(1) - !X.WINDOW(0), $
                    YSIZE = !Y.WINDOW(1) - !Y.WINDOW(0), /NORM
        endelse
    endif else begin
;
;       postscript, no multi, keep square pixels
;
        if ps then begin
            xres=!d.x_size/(winxlen*1.)
            yres=!d.y_size/(winylen*1.)
            if (xres lt yres) then begin
                xendN=1.
                yendN= xres/yres
            endif else begin
                yendN=1.
                xendN=yres/xres
            endelse
			if not keyword_set(nodisplay) then begin
            tv,ret
            if axes then begin
            plot,[0,0],[0,0],xra=xvalLoc,yra=yvalLoc,xstyle=1,ystyle=1,/nodata,$
                  /noerase,position=[0,0,xendN,yendN],ticklen=-.02, _extra=e
            endif
			endif
        endif else begin
			if not keyword_set(nodisplay) then begin
            tv,ret,xoffn,yoffn,/norm
           plot,[0,0],[0,0],xra=xvalLoc,yra=yvalLoc,xstyle=1,ystyle=1,$
                    /nodata,/noerase,ticklen=-.02, _extra=e,$
                    position=[xoffn,yoffn,1-xoffn,1-yoffn],/norm
			endif
        endelse
    endelse
	if not keyword_set(nodisplay) then begin
    if ps then  begin 
		if not keyword_set(nomodlut) then tvlct,r,g,b
    endif else begin
         if keyword_set(rdpix) then begin
			if keyword_set(usecongrid) then begin
            	rdpix,congrid(d,nlenx,nleny),border,border
			endif else begin
            	rdpix,rebin(d,nlenx,nleny),border,border
			endelse
        endif else begin
            if keyword_set(profile) then begin
                  px=!x.window*!d.x_vsize
                  py=!y.window*!d.y_vsize
                  sx=long(px[1] - px[0] + 1.5)
                  sy=long(py[1] - py[0] + 1.5)

                profiles,rebin(d,nlenx,nleny),sx=px[0],sy=py[0],wsize=.75
            endif
        endelse
    endelse
	endif
    return
end
