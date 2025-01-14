;+
;NAME:
;maskbyrms - create mask using rms of fit residuals.
;SYNTAX:  mask=maskbyrms(x,y,deg=deg,maxloop=maxloop,nsig=nsig,$
;                        indxgood=indxgood,indxbad=indxbad,$
;                        nbad=nbad,ngood=ngood,verb=verb,coef=coef) 
;ARGS:
;     x[n]  : float x data
;     y[n]  : float y data
;
; RETURNS:
;  mask[n]:long holds the mask. 1 for good points, 0 for bad points
; indxgood:long indices of y whose mask value is 1
;  indxbad:long indices of y whose mask value is 0
;    ngood:long the number of good (mask=1) points.
;     nbad:long the number of bad  (mask=0) points.
;coef[deg+1]: float the coef from poly_fit
;
; KEYWORDS:
;      deg: int  degree for polynomial fit (def:1)
;  maxloop: int  max time to loop on fit before quitting. (def:20)
;     nsig: float keep points within nsig of fit (def: 3. sigma)
;     verb:     if set then plot out the residuals and mask after the
;               fitting.
;
; DESCTRIPTION:
;   This routine will fit a polynomial of order deg to the data x,y.
;It will then remove all points whose fit residuals are greater then
;nsig sigmas and iterate the fitting process. When all residuals are within
;nsig, a mask is created where the remaining points have a 1 and the points
;that were excluded have a mask value of 0.
;
;NOTE: this routine uses the value of x that is provided. For large values
;      of deg you should scale x so that x**deg  does not overflow (say -1,1).
;SEE ALSO:
;   blmask, cormask, corblauto
;-
;06feb05 - fit good points, but recompute error on all points with
;          ne fit coefs.
function maskbyrms,x,y,deg=deg,maxloop=maxloop,nsig=nsig,coef=coef,$
    indxgood=indxgood,indxbad=indxbad,verb=verb,ngood=ngood,nbad=nbad

    if not keyword_set(nsig) then nsig=3.
    if not keyword_set(maxloop) then maxloop=20
    if not keyword_set(deg) then deg=1
    ;
    npts=n_elements(x)
    indxgood=lindgen(npts)
    looped=0
	ngood=npts
    for i=0,maxloop-1 do begin
        coef=poly_fit(x[indxgood],y[indxgood],deg)
		yn=poly(x,coef)
        dif=y - poly(x,coef)
        a=rms(dif,/quiet)
        ii=where(abs(dif) le (a[1]*nsig),count)
		if (count gt ngood) then goto,done   ; this is worse 
        indxgood=ii
        looped=looped+1
    endfor
done:   mask=intarr(npts)
    mask[indxgood]=1
    indxbad=where(mask eq 0,nbad)
    if nbad eq 0 then indxbad=-1
    if keyword_set(verb) then begin
        colb=2
        symb=2
        lab=string(format=$
        '("fit deg:",i3," nsig:",f6.2," loop:",i3," good,bad pnts:",i4," ",i4)',$
            deg,nsig,looped,ngood,nbad)
        ii=sort(x)
        plot,x[ii],y[ii],psym=10,title=lab
        case nbad of 
            0: a=1
            1: plots,x[indxbad],y[indxbad],psym=symb,col=colb
            else: oplot,x[indxbad],y[indxbad],psym=symb,col=colb
        endcase
        xmin=min(x,max=xmax)
        xx=findgen(100)/100. * (xmax-xmin) + xmin
        oplot,xx,poly(xx,coef),color=3
    endif
    return,mask
end
