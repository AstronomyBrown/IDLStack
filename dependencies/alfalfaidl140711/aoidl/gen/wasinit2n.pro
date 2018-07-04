@corinit
addpath,'was2'
; get updated version.. note this is now the same as wasinit2
.compile corhquery
@was.h
;
; hold the luns as we open descriptors,
; this allows us to close all the luns at once if we want
;
common wascom,wasnluns,waslunar
	wasnluns=0L
	waslunar=intarr(100)
