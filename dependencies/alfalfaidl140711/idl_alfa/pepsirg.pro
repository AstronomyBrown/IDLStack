pro pepsirg

spawn, 'whoami', user

if (user eq 'riccardo' OR user eq 'haynes' OR user eq 'bkent' or user eq 'sabrina' or user eq 'amelie' or user eq 'amartin' or user eq 'koopmann' or user eq 'tbalonek') then begin

    window, /free, retain=2, xsize=600, ysize=600
    url='http://www.astro.cornell.edu/~bkent/images/pepsirg.jpg'
    spawn, 'wget -q -O ~/datautil3754 ' + "'" + url + "'"
    spawn, 'convert ~/datautil3754 ~/datautil3754'
    read_jpeg, '~/datautil3754', testjunk
    tvscl, testjunk, true=1
    spawn, '/bin/rm -r ~/datautil3754'

endif

end
