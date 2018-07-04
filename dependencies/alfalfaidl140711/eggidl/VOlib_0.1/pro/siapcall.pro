
;+
; PROJECT     : VOlib (CTIO)
;
; NAME:
;       SIAPCALL 
;
; CATEGORY:
;       Utility
;
; PURPOSE:
;       To make calls to VO Siap Services. A list of 
;       SIAP Servers can be found by querying the VO
;       Registries (use CALL_REGISTRY).
;       Specifically, we call any specified SIAP Server
;       and provide the ra,dec, search radius and the
;       ServiceURL as returned by CALL_REGISTRY.
;       Defaults are given in the code.
;       (Cone, SIAP, SkyNode).
;       The procedure calls the cone service, returns
;       an image as a structure.
;
; CALLING SEQUENCE:
;       IDL>  siapcall, str=str, url=url, ra,dec,sr [,/save]
;
; INPUTS:
;       url = The SIAP Server in string format.
;             ra,dec = coordinates
;             sr = search radius in degrees(? check this)
;             url = string of SIAP server
;             Type: IDL> help, /str, str1
;             to find out the name of the columns returned.
;                       
; OPTIONAL INPUTS:
;       root = image rootname specified by the user.
;
; OUTPUTS: 
;       images are downloaded to your working directory.
;       Use MRDFITS to read in FITs or read_jpeg to read
;       in a JPEG.
;       str1 = structure of image metadata
;
; KEYWORD PARAMETERS:
;       /SAVE: save the metadata file downloaded from the SiapServer
;              to your current working directory. If the
;              name contains bad characters (like spaces
;              or whatever), the save function will not
;              rename the "download.xml" generic name to
;              a more meaningful name based on the query.
;       /METADATA: Only get the image header. No downloads.
;       /REDMEDIATE:  Try and fix the VOTable of the metadata
;
; DEPENDENCIES:
;       READVOT
;
; MODIFICATION HISTORY:
;       Written: 2/04/05 Christopher J. Miller (NOAO/CTIO)
;       Contact     : cmiller@noao.edu
;
; EXAMPLES:
;         siapcall, str=str, 217.5,35.0, 0.16, url="http://irsa.ipac.caltech.edu/cgi-bin/2MASS/IM/nph-im_sia?type=ql&ds=asky", root='2mass'
;         siapcall, str=str, url='http://xsa.vilspa.esa.es:8080/aio/jsp/siap.jsp', 34.26, -5, 0.16,root='xmm'
;         siapcall, str=str2, 217.5,35.0, 0.16, url="http://archive.noao.edu/nvo/sim/voquery.php", root='ndwfs'
;         siapcall, str=str2, 180,1.,0.1, url = "http://skyserver.sdss.org/vo/DR2SIAP/SIAP.aspx?bandpass=g&format=image/fits&", root='sdss'
;         siapcall, str=str2, 180,1.,0.1, url = "http://skyserver.sdss.org/vo/DR2SIAP/SIAP.aspx?bandpass=g&format=image/jpeg&", root='sdss'
;         siapcall, str=str, url="http://archive.ast.cam.ac.uk/cgi-bin/wfs-siap/queryImage", 340,1,0.1,root='intwfs'
;
; KNOWN ISSUES:
;         Obviously, the SIAP server must be functioning for the code
;         to work. The current version lacks a graceful exit strategy
;         for server failures.
;-

PRO SIAPCALL, str=str, url=url, ra,dec,sr, save=save, remediate=remediate, metadata=metadata, root=root

if (n_params(0) eq 0 and n_elements(str) eq 0) then begin
   print,"siapcall, str=str, url=url, ra,dec, sr, [,/SAVE, /REMEDIATE, /METADATA]"
   print, 'Call a VO SIAP Server as specified in the URL string (use CALL_REGISTRY).'
   print, 'The REMEDIATION keyword will attempt to fix a VOTable header and can be tried'
   print, 'if the code doesnt seem to work. The SAVE keyword allows you to keep the'
   print, 'downloaded VOTable in your working directory. The METADATA keyword means'
   print, 'only get the SIAP metadata, and do not download the images.'
   return
endif


;SDSS example
IF (n_elements(ra) eq 0) THEN ra = 180.0
IF (n_elements(dec) eq 0) THEN dec = 1.0
IF (n_elements(sr) eq 0) THEN sr = 0.5
;IF (n_elements(url) eq 0) THEN url = 'http://skyserver.sdss.org/vo/DR2SIAP/SIAP.aspx?BANDPASS=*&format=image/jpeg&'
IF (n_elements(url) eq 0) THEN url = "http://skyserver.sdss.org/vo/DR2SIAP/SIAP.aspx?bandpass=g&format=image/fits&"
; siapcall, str=str2, 217.5,35.0, 0.16, "http://irsa.ipac.caltech.edu/cgi-bin/2MASS/IM/nph-im_sia?type=ql&ds=asky"
;http://archive.noao.edu/nvo/sim/voquery.php




;Parse the URL:
endit = strpos(url, '?')
IF (endit[0] eq -1) THEN url = url + '?'
endit = strpos(url, '?')
query = strmid(url,0,endit+1) + 'POS=' + strtrim(string(ra,format='(f10.3)'),2) + ',' + $
 strtrim(string(dec,format='(f10.3)'),2) + '&SIZE=' + strtrim(string(sr,format='(f10.3)'),2) + '&' +  $
 strmid(url, endit+1, strlen(url) - endit + 1)
print,  'wget -q -O download.xml ' + "'" + query + "'"
spawn, 'wget -q -O download.xml ' + "'" + query + "'"

fileread = 'download.xml'
IF not keyword_set(remediate) THEN readvot, fileread, str
IF keyword_set(remediate) THEN readvot, fileread, str, /remediate

IF not(keyword_set(SAVE)) THEN BEGIN
  spawn, 'rm download.xml'
ENDIF ELSE BEGIN
 start = strpos(url, '?')
 name = strmid(query, start+1, strlen(query) - start)
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
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(name,',', start)
   IF (start2 ne -1) THEN BEGIN
     name = strmid(name, 0, start2) + '\' + strmid(name, start2, strlen(name) - start)
     start = start2 +2
   ENDIF
 ENDWHILE
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(name,'*', start)
   IF (start2 ne -1) THEN BEGIN
     name = strmid(name, 0, start2) + '\' + strmid(name, start2, strlen(name) - start)
     start = start2 +2
   ENDIF
 ENDWHILE
 start = 0
 start2 = 0
 WHILE (start2 ne -1) DO BEGIN
   start2= strpos(name,'/', start)
   IF (start2 ne -1) THEN BEGIN
     name = strmid(name, 0, start2)  + strmid(name, start2 +1, strlen(name) - start)
     start = start2 +2
   ENDIF
 ENDWHILE
 spawn, 'mv ' + fileread + ' '  + name
ENDELSE

IF (NOT keyword_set(metadata)) THEN BEGIN
  IF (n_elements(root) ne 0) THEN BEGIN
      image = strtrim(root,2) + '_image'
  ENDIF ELSE BEGIN
      image = 'image'
  ENDELSe
  J = 0
  FOR I = 0, n_elements(str) -1 DO BEGIN
   tags = rtag_names(str)
   w = where(STRUPCASE(tags) eq 'FORMAT')
   IF (w[0] ne -1) THEN BEGIN
    IF (strpos(STRUPCASE(str[I].(w)), 'IMAGE') eq -1) THEN goto, skipthis
   ENDIF
   w = where(STRUPCASE(tags) eq 'URL')
   IF (w[0] eq -1) THEN w = where(STRUPCASE(tags) eq 'DOWNLOAD')
   IF (w[0] eq -1) THEN w = where(STRUPCASE(tags) eq 'SIA_URL')
   IF (w[0] eq -1) THEN w = where(STRUPCASE(tags) eq 'ACCREF')
   IF (w[0] eq -1) THEN w = where(STRUPCASE(tags) eq 'ACCESSREFERENCE')
   IF (w[0] eq -1) THEN BEGIN
     print, 'No image URL given in the metadata'
     w = where(tags eq 'targe_name')
     IF (w[0] ne -1) THEN BEGIN
      IF (strpos(STRUPCASE(str[I].target_name), 'XMM') ne -1) THEN BEGIN
       print,   'This looks like XMM data, which is not a standard IVOA SIAP server.'
       print, ' Attempting countermeasures.....'
       byte_obsid = byte(str[I].obsid)
       w = where(byte_obsid ne 10)
       obsid = string(byte_obsid[w])
       newurl = 'http://xsa01.vilspa.esa.es:8080/aio/jsp/product.jsp?obsno=' + strtrim(obsid,2) + '&name=OIMAGE&level=PPS&extension=FTZ'
       spawn, 'wget ' + '"' +  newurl + '"' + ' -O local.http'
       close, 1
       openr,1, 'local.http'
       readit = 0
       temp = ''
       WHILE (not EOF(1) and readit eq 0) DO BEGIN
        readf,1, temp
        IF (strpos(STRUPCASE(temp), 'FTP://') ne -1) THEN BEGIN
          startit = strpos(STRUPCASE(temp), 'FTP://')
          stopit = strpos(temp, '"', startit + 2)
          ftploc = strmid(temp,startit, stopit - startit)
          spawn, 'wget -s -r  ' + '"' +  ftploc + '"' + ' -O ' + image + strtrim(string(I),2) + '.fits', xmmlog
          spawn, 'rm local.http'
          readit = 1
        ENDIF
       ENDWHILE
      ENDIF ELSE BEGIN
       RETURN
      ENDELSE
     ENDIF
   ENDIF
   spawn, 'wget -s -r -O ' + image + strtrim(string(J),2) + '.fits ' + "'" + str[I].(w) + "'", log
   openr,1, image +  strtrim(string(J),2) + '.fits'
   temp = 'a'
   k = 0
   gunzip = 0
   jpeg = 0
   WHILE (strtrim(temp,2) ne '') DO BEGIN
    readf,1,temp
    IF (strpos(STRUPCASE(temp), 'GZIP') ne -1) THEN  gunzip =1
    IF (strpos(STRUPCASE(temp), 'JPEG') ne -1 or strpos(STRUPCASE(temp), 'JPG') ne -1) THEN  jpeg =1
    IF (strpos(STRUPCASE(temp), 'TEXT') ne -1) THEN BEGIN
      spawn, 'rm  ' + image +  strtrim(string(I),2) + '.fits'
      goto, skipthis
    ENDIF
     K = K + 1
   ENDWHILE 
   close, 1
   spawn, ('wc -l ' + image +  strtrim(string(J),2) + '.fits '), lines
   linenum = strmid(lines, 0, (strpos( lines, image +  strtrim(string(J),2) + '.fits') -1))
   spawn, "tail " +  image +  strtrim(string(J),2) + '.fits -n ' +   strtrim(string(long(linenum) - K+1),2) + ' > ' +  image +  strtrim(string(J),2) + 'b.fits'
   IF (gunzip eq 1) THEN BEGIN
      spawn, 'mv '+  image +  strtrim(string(J),2) + 'b.fits ' +  image +  strtrim(string(J),2) + 'b.fits.gz'
      spawn, 'gunzip '+ image +  strtrim(string(J),2) + 'b.fits.gz'
   ENDIF
   spawn, 'mv ' +  image +  strtrim(string(J),2) + 'b.fits ' + image +  strtrim(string(J),2) + '.fits'
   IF (jpeg eq 1) THEN  spawn, 'mv  ' + image +  strtrim(string(J),2) + '.fits ' + image +  strtrim(string(J),2) + '.jpg'   
    J = J + 1
    skipthis:
    close, 1
  ENDFOR
ENDIF
   
RETURN

END



