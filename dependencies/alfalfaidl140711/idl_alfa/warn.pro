pro warn

spawn, 'whoami', user

if (user eq 'riccardo' OR user eq 'haynes' OR user eq 'bkent' or user eq 'sabrina' or $
 user eq 'amelie' or user eq 'amartin' or user eq 'koopmann' or user eq 'shan' OR user eq 'betsey' OR user eq 'papastergis') then begin

;   window, /free, retain=2, xsize=600, ysize=600
    print, 'make sure you are using the correct version of GALFLUX...'

endif

end
