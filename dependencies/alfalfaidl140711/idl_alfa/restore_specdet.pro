;+
;NAME: restore_specdet	copies variable specin into structure specdet in common block
;
; You have a specdet structure, specin, that you want to load on the atv_specdet
; common block, replacing whatever may be stored there.

pro restore_specdet,specin


common atv_specdet, specdet, $	; array of structures with spectra/parms
                  spec1, $      ; structure with last spectrum/parms
                  specappend    ; if =1, append to existing specdet

res=size(specdet)
if (res[2] gt 1) then begin
  ans=''
  print, 'specdet structure currently in common block has >1 entries;'
  print, '... do you really wish to replace it? (y/n)'
  read, ans
  if (strlowcase(ans) ne 'y') then message,'OK. Be careful next time'
endif
specdet=specin

end
