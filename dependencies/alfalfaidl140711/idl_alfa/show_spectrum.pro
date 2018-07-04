;Procedure to save an image (borrowed from Liam E. Gumley's book
;  "Practical IDL programming"
 
;Screen read function
FUNCTION SCREENREAD,x0,y0,nx,ny,depth=depth
 
        ;Get display depth
        depth = 8
        win_true = !d.flags and 256
        tvrd_true = !d.flags and 128
        version = float(!version.release)
        if(win_true gt 0) then begin
                if (version ge 5.1) then begin
                        device,get_visual_depth = depth
                endif else begin
                        if (!d.n_colors gt 256) then depth = 24
                endelse
        endif
 
        ;Set decomposed color mode on 24-bit displays
        if (depth gt 8) then begin
                entry_decomposed = 0
                if (version gt 5.1) then $
                        device,get_decomposed = entry_decomposed
                        device,decomposed = 1
        endif
 
        ;Get the  contents of the window
        if (depth gt 8) then true = 1 else true = 0
        image = tvrd(order=0,true=true)
 
        ;Restore decomposed color mode on 24-bit displays
        if (depth gt 8) then device, decomposed = entry_decomposed
 
        ;Return
        return,image
 
END


;=================================================================
pro show_spectrum,DATE=date,OUTPUT=output

if (n_elements(output) le 0) then output='no'

restore,'sources'+date+'.sav'
sf=sources_final

nch=4096
gain=8.5

scan=0L
print,'Scan number: '
read,scan

beam=9
print,'Beam number: '
read,beam

channel=9999
print,'Channel number: '
read,channel

record=999
print,'Record number: '
read,record

i=where(sf.scannumber eq scan and sf.beam eq beam and sf.ch eq channel and sf.rec eq record)
if (n_elements(i) le 1) then begin
if (i lt 0) then begin
  print,'No sources corresponds to that entry.'
  goto,endshow
endif
endif
if (n_elements(i) gt 1) then begin
  print,'Multiple objects correspond to that entry.  I will pick the first one.'
  i=i[0]
endif

x=sf[i].ch
y=sf[i].rec
sigma_m=sf[i].w/(2.3568*5.3)
peak_m=sf[i].peak_flux
delta_m=x
model= peak_m*exp(-(findgen(nch)-delta_m)^2/(2*sigma_m^2))


window,8,xsize=800,ysize=800,retain=2
!p.multi=0
!p.multi=[0,1,2,0,0]
defback=!p.background
defcol=!p.color
!p.background='ffffff'x; white background
!p.color=0; draw in black
device,decomposed=1
blue='FF0000'XL
red='0000FF'XL
green='00FF00'XL
xmin=0
xmax=0
            if (x gt 250 and x lt nch-251) then begin
              xmin=x-250
              xmax=x+250
            endif
            if (x le 250) then begin
              xmin=0
              xmax=500
            endif
            if (x ge nch-251) then begin
              xmin=nch-500
              xmax=nch-1
          endif
xt=indgen(nch)

spectrum=0.5*(sf[i].sp1+sf[i].sp0)

temp=min(spectrum[xmin:xmax])
plot,xt,spectrum/gain*1000,charsize=2.0,xrange=[xmin,xmax],xstyle=1,thick=2.0, $
               ytitle='Intensity [mJy]',position=[0.15,0.50,0.95,0.85]
oplot,xt,model/gain*1000,color=blue,thick=2.0
;            arrow,x,temp-8,x,temp-3,color=blue,/data
xyouts,0.05,0.90,'w='+strtrim(string(sf[i].w),2)+'km/s    S/N='+strtrim(string(sf[i].sn),2),charsize=2.0,charthick=1.5,/normal
plot,xt,spectrum/gain*1000,charsize=2.0,xrange=[xmin,xmax],xstyle=1, $
               xtitle='Channel',ytitle='Intensity [mJy]',position=[0.15,0.15,0.95,0.50],/nodata
temp=min(sf[i].sp0[xmin:xmax])
oplot,xt,sf[i].sp0/gain*1000,color=blue,thick=2.0
oplot,xt,sf[i].sp1/gain*1000,color=red,thick=2.0
;            arrow,x,temp-8,x,temp-3,color=blue,/data


if (output eq 'yes') then begin
            radec=sf[i].radec
            print,'Writing HI profile for ',strtrim(radec,2)
            image=screenread(depth=8)
            tvlct,r,g,b,/get
            write_png,radec+'.png',image,r,g,b
            wdelete,8
endif


!p.background=defback; black background
!p.color=defcol; draw in white 

endshow:
end
