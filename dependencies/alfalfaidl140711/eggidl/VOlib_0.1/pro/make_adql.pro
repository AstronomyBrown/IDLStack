PRO MAKE_ADQL, qry=qry,ra,dec,sr,chisq

;Some Example Queries to use with SKYCLIENT (and OpenSkyQuery)

;Example #1
;Crossmatch SDSS DR2 galaxies (type = 3) with TWOMASS extended sources.
;IF (n_elements(ra) ne 1) THEN BEGIN
; ra = 16.0
; dec = -0.85
;ENDIF
;raArr = dblarr(n_elements(ra))
;decArr = dblarr(n_elements(dec))
;IF (n_elements(sr) ne 1) THEN sr = 50.0
;IF (n_elements(chisq) ne 1) THEN chisq = 2.5
;IC = 0
; raArr = ra[IC]
; decArr = dec[IC]
; srArr = long(sr[IC])
; chisqArr = chisq[IC]
; qry = " SELECT o.objId, o.ra,o.dec, o.type,t.objId,t.j_m,o.z " + $
;       " FROM SDSSDR2:PhotoPrimary o, " + $
;       " TWOMASS:PhotoPrimary t WHERE XMATCH(o,t)<" + strtrim(string(chisqArr),2) + " " + " AND o.type = 3 " + $
;       " AND Region('Circle J2000 " + strtrim(string(raArr,format='(f10.3)'),2) + " " + strtrim(string(decArr, format='(f10.3)'),2) + $
;         " " +  strtrim(string(srArr, format='(i2)'),2) + "') "
; print, qry
;
;
;Example #2
;Select SDSS DR2 galaxies brighter than r = 19.8
;IF (n_elements(ra) ne 1) THEN BEGIN
; ra = 16.0
; dec = -0.85
;ENDIF
;raArr = dblarr(n_elements(ra))
;decArr = dblarr(n_elements(dec))
;IF (n_elements(sr) ne 1) THEN sr = 50.0
;IF (n_elements(chisq) ne 1) THEN chisq = 2.5
;IC = 0
; raArr = ra[IC]
; decArr = dec[IC]
; srArr = long(sr[IC])
; chisqArr = chisq[IC]
; qry = " SELECT o.ra,o.dec,o.petroMag_u, o.petroMagErr_u, o.petroMag_g, o.petroMagErr_g, o.petroMag_r, o.petroMagErr_r, " + $
;       " o.petroMag_i, o.petroMagErr_i, o.petroMag_z,  o.petroMagErr_z, " + $
;       " o.extinction_u, o.extinction_g, o.extinction_r, o.extinction_i, o.extinction_z " + $
;       " FROM SDSSDR2:PhotoPrimary o " + $
;       " WHERE o.type = 3 AND o.petroMag_r < 19.8 " + $
;       " AND Region('Circle J2000 " + strtrim(string(raArr,format='(f10.3)'),2) + " " + strtrim(string(decArr, format='(f10.3)'),2) + $
;       " " +  strtrim(string(srArr, format='(i2)'),2) + "') "
;print, qry
;
;
;Example #3
;Select NDWFS galaxies.
;IF (n_elements(ra) ne 1) THEN BEGIN
; ra = 217.5
; dec = 35.0
;ENDIF
;raArr = dblarr(n_elements(ra))
;decArr = dblarr(n_elements(dec))
;IF (n_elements(sr) ne 1) THEN sr = 5.0
;IF (n_elements(chisq) ne 1) THEN chisq = 2.5
;IC = 0
; raArr = ra[IC]
; decArr = dec[IC]
; srArr = long(sr[IC])
; chisqArr = chisq[IC]
; qry = " SELECT o.ra,o.dec,o.field, o.number, o.mag_iso, o.magerr_iso, o.mag_isocor, o.magerr_isocor, " + $
;       " o.mag_auto, o.magerr_auto, o.ellipticity" + $
;       " FROM NDWFS:photoprimary o " + $
;       " WHERE o.mag_iso < 19.8 " + $
;       " AND Region('Circle J2000 " + strtrim(string(raArr,format='(f10.3)'),2) + " " + strtrim(string(decArr, format='(f10.3)'),2) + $
;       " " +  strtrim(string(srArr, format='(i2)'),2) + "') "
;print, qry
;
;
;
;Example #4
;Select NDWFS galaxies and 
IF (n_elements(ra) ne 1) THEN BEGIN
 ra = 217.5
 dec = 35.0
ENDIF
raArr = dblarr(n_elements(ra))
decArr = dblarr(n_elements(dec))
IF (n_elements(sr) ne 1) THEN sr = 5.0
IF (n_elements(chisq) ne 1) THEN chisq = 2.5
IC = 0
 raArr = ra[IC]
 decArr = dec[IC]
 srArr = long(sr[IC])
 chisqArr = chisq[IC]
 qry = " SELECT o.* " + $
       " FROM NDWFS:photoprimary o, " + $
       " PSCZ:photoprimary t " + $
       " WHERE XMATCH(o,t)<" + strtrim(string(chisqArr),2) + " and o.mag_iso < 19.0 " + $
       " AND Region('Circle J2000 " + strtrim(string(raArr,format='(f10.3)'),2) + " " + strtrim(string(decArr, format='(f10.3)'),2) + $
       " " +  strtrim(string(srArr, format='(i2)'),2) + "') "
;
;

RETURN
END


