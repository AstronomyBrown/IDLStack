pro JPEGOUT, filename, window=window
;+
; NAME:
;   JPEGOUT
; PURPOSE:
;   Writes the current 'X' plotting window to a JPEG file.
;
; CALLING SEQUENCE:
;   JPEG, filename, window=window
;
; INPUTS:
;   filename -- the filename to be written.
;
; KEYWORD PARAMETERS:
;   window = IDL window ID number
;
; OUTPUTS:
;   A JPEG filename.
;
; MODIFICATION HISTORY:
;       Written --
;       Tue Apr 9 01:26:27 2002, Erik Rosolowsky <eros@cosmic>
;
;       January 19, 2006, B. Kent, Cornell University
;                       - name changed to JPEGOUT to avoid conflict
;                       - device window keyword added	
;                       - Error checking
;	
;
;-



  if n_elements(filename) eq 0 then filename = 'idlfigure.jpg'


;Two "if" statements added by B. Kent
  if (keyword_set(window)) then wset, window

  if (!d.window eq -1) then begin
    print, '  No graphics window open!'
    return
  endif


  tvlct, r, g, b, /get
  r = congrid(r, 256)
  g = congrid(g, 256)
  b = congrid(b, 256)
  
  im = float(tvrd())
  im = byte((im/max(im))*255)
  image = bytarr(3, !d.x_size, !d.y_size)
  image[0, *, *] = r[im]
  image[1, *, *] = g[im]
  image[2, *, *] = b[im]
  write_png, 'temp', image
  spawn, 'convert temp jpeg:'+filename
  spawn, 'rm temp', /sh
  return

end
