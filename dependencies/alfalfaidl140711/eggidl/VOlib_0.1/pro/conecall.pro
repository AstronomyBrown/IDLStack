
;+
; Project     : VOlib (CTIO)
;
; NAME:
;       CONECALL 
;
; CATEGORY 
;       Utility
;
; PURPOSE:  
;       To make calls to VO Cone Services. A list of 
;       Cone Servers can be found by querying the VO
;       Registries (use CALL_REGISTRY).
;       Specifically, we call any specified Cone Server
;       and provide the ra,dec, search radius and the
;       ServiceURL as returned by CALL_REGISTRY.
;       Defaults are given in the code.
;       (Cone, SIAP, SkyNode).
;       The procedure calls the cone service, returns
;       a VOTable (which will appear in your working
;       directory), reads in the VOtable using READVOT,
;       and returns the structure. 
;
; CALLING SEQUENCE:
;       IDL>  conecall, str=str1, url=url, ra,dec,sr [,/save]
;
; INPUTS:
;       INPUT url = string of the URL for the Cone Service
;                   The best way to get this string is by
;                   using call_registry specifing a Cone
;                   Service.
;                   ra,dec = coordinates
;                   sr = search radius in degrees(? check this)
;                       
; OUTPUTS:
;       str: a structure containing the data from the 
;            VOtable returned by the cone service.
;            Type: IDL> help, /str, str 
;            to find out the name of the columns returned.
;
; KEYWORD PARAMETERS:
;       /SAVE: save the file downloaded from the ConeServer
;              to your current working directory. If the
;              name contains bad characters (like spaces
;              or whatever), the save function will not
;              rename the "download.xml" generic name to
;              a more meaningful name based on the query.
;       /REMEDIATE: Attempts to fix the downloaded XML.
;
; DEPENDENCIES:
;       READVOT
;
; MODIFCATION HISTORY 
;       Written: 2/04/05 Christopher J. Miller (NOAO/CTIO)
;       Contact     : cmiller@noao.edu
;
; EXAMPLE CALLS:
;    conecall,str=str, url = 'http://heasarc.gsfc.nasa.gov/cgi-bin/vo/cone/coneGet.pl?table=bsc5p', 180,1,10
;    conecall,str=str, url ='http://skyserver.sdss.org/vo/dr2cone/sdssConeSearch.asmx/ConeSearch?', 180,1,0.01
;    conecall,str=str, url ='http://archive.stsci.edu/fuse/search.php?', 180,1,10
;    conecall,str=str, url ='http://chart.stsci.edu/GSCVO/GSC1VO.jsp?', 180,1,1
;
; KNOWN ISSUES:
;    The SKYVIEW Coneserver doesnt seem to work (02/23/05). HEASARC might be the replacement?
;-

PRO CONECALL, str=str, url=url, ra,dec,sr, save=save, remediate=remediate

if (n_params(0) eq 0 and n_elements(url) eq 0)  then begin
   print,"conecall, str=str, url=URL, ra,dec, sr, [,/SAVE, /REMEDIATE]"
   print, 'Call a VO Cone Server as specified in the URL string (use CALL_REGISTRY).'
   print, 'The REMEDIATION keyword will attempt to fix a VOTable header and can be tried'
   print, 'if the code doesnt seem to work. The SAVE keyword allows you to keep the'
   print, 'downloaded VOTable in your working directory.'
   return
endif

;SDSS example
IF (n_elements(ra) eq 0) THEN ra = 180.0
IF (n_elements(dec) eq 0) THEN dec = 1.0
IF (n_elements(sr) eq 0) THEN sr = 0.01
IF (n_elements(url) eq 0) THEN url = 'http://skyserver.sdss.org/vo/dr2cone/sdssConeSearch.asmx/ConeSearch?'

;Example from the Bright Star Catalog, 5th Edition
;IF (n_elements(ra) eq 0) THEN ra = 180.0
;IF (n_elements(dec) eq 0) THEN dec = 1.0
;IF (n_elements(sr) eq 0) THEN sr = 10.0
;IF (n_elements(url) eq 0) THEN url =  'http://heasarc.gsfc.nasa.gov/cgi-bin/vo/cone/coneGet.pl?table=bsc5p'

;Parse the URL:
endit = strpos(url, '?')
query = strmid(url,0,endit+1) + 'RA=' + strtrim(string(ra,format='(f10.3)'),2) + '&DEC=' + $
 strtrim(string(dec,format='(f10.3)'),2) + '&SR=' + strtrim(string(sr,format='(f10.3)'),2) + '&' +  $
 strmid(url, endit+1, strlen(url) - endit + 1)
print,  'wget -q -O download.xml ' + "'" + query + "'"
spawn, 'wget -q -O download.xml ' + "'" + query + "'"

fileread = 'download.xml'
IF keyword_set(remediate) THEN readvot, fileread, str, /remediate
IF not  keyword_set(remediate) THEN readvot, fileread, str
IF not(keyword_set(SAVE)) THEN BEGIN
  spawn, 'rm download.xml'
ENDIF ELSE BEGIN
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(url,'/', start)
   IF (start2 ne -1) THEN start = start2 +1
 ENDWHILE
 name = strmid(query, start, strlen(query) - start)
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(name,'&', start)
   IF (start2 ne -1) THEN BEGIN
     name = strmid(name, 0, start2) + '\' + strmid(name, start2, strlen(name) - start)
     start = start2 +2
   ENDIF
 ENDWHILE
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(name,'?', start)
   IF (start2 ne -1) THEN BEGIN
     name = strmid(name, 0, start2) + '\' + strmid(name, start2, strlen(name) - start)
     start = start2 +2
   ENDIF
 ENDWHILE
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(name,'=', start)
   IF (start2 ne -1) THEN BEGIN
     name = strmid(name, 0, start2) + '\' + strmid(name, start2, strlen(name) - start)
     start = start2 +2
   ENDIF
 ENDWHILE
 spawn, 'mv ' + fileread + ' '  + name
ENDELSE

RETURN

END



