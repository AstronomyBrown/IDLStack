;+
;NAME: get_specdet	copies the specdet structure to variable name specout
;
; Note that specdet is only accessible through a common call froma procedure;
; it is accessible from command line only aftter running get_specdet.

pro get_specdet,specout


common atv_specdet, specdet, $	; array of structures with spectra/parms
                  spec1, $      ; structure with last spectrum/parms
                  specappend    ; if =1, append to existing specdet

;help,specdet,/st
specout=specdet

end
