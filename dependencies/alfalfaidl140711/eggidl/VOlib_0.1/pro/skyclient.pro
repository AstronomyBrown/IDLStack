
;+
; PROJECT     : VOlib (CTIO)
;
; NAME:
;       SKYCLIENT
;
; CATEGORY:
;       Utility
;
; PURPOSE: 
;       To make queries to the NVOs OpenSkyQuery (OSQ)
;       dataservice (www.openskyquery.net). The OSQ
;       runs a web service and this IDL procedure uses 
;       a number of java classes that can talk directly
;       with the OSQ. The OSQ takes an ADQL formatted
;       query and returns data in a VOTable. SKYCLIENT
;       automatically parses that VOTable into an IDL
;       structure. ADQL is like SQL in that a SELECT,
;       FROM and WHERE must be specified. ADQL also allows
;       astronomy specific keywords (like REGION).
;              
;       To make efficient use of SKYCLIENT (or OSQ), one
;       must know the datasets being queried. For instance
;       in Query #4 in MAKE_ADQL, we return o.*, which is
;       all of the data columns of the NOAO Deep Wide Field
;       Survey (NDWFS). However, to specify the WHERE 
;       clause, one must know what those columns are. Also,
;       it helps to know where on the sky a dataset lives.
;
;       We provide a number of example queries in the
;       included MAKE_ADQL.pro query constructor. Please
;       add and/or edit that file to make your own queries.
;       One technique to get comfortable with ADQL, is to
;       use the OSQ web interface to build your queries
;       and them simply copy them into MAKE_ADQL.pro.
;
; CALLING SEQUENCE:
;       IDL> skyclient, str=str, ra,dec,sr,chisq [,query]
;
; INPUTS:
;       ra, dec - in decimal degrees.
;       sr - the search radius in arcminutes
;       chisq - the cross-match chi-square for
;               cross-matching catalogs (only needed
;               if more than one catalog is queried).
;       DEFAULTs are given in MAKE_ADQL.PRO
;
; OPTIONAL INPUTS:
;       query - A string containing the ADQL query
;
; OUTPUTS:
;       str: a structure containing the data. Type
;           IDL> help, /str, str 
;           to find out the name of the colmnes returned.
;
; KEYWORD PARAMETERS: 
;
; DEPENDENCIES:
;       MAKE_ADQL.PRO which creates the query string.
;       The VOlib IDL/Java class libraries (included with VOlib).
;
; MODIFICATION HISTORY:
;       Written: 2/04/05 Christopher J. Miller (NOAO/CTIO)
;       Contact     : cmiller@noao.edu
;
; EXAMPLES:
;       skyclient, str=strndwfs, qry = " SELECT o.*  FROM NDWFS:photoprimary o  WHERE o.mag_iso < 19.0  AND Region('Circle J2000 217.500 35.000 10')"
;
; KNOWN ISSUES:
;       The current version has some memory problems. Large 
;       calls seems to fail, even with the JAVA memory increased
;       to a proper value. Also, repeated calls tend to fail after
;       so many calls (~200 or so). 
;-


PRO skyclient, str=str, ra,dec,sr,chisqO,qry=qry

if (n_params(0) eq 0 and n_elements(qry) eq 0) then begin
   print,"skyclient, str=str, ra,dec,sr,chisq [,qry=qrystring]"
   print, 'Call the OpenSkyQuery and return matched data around ra,dec and within'
   print, 'sr arcminutes that match within some specified chisqr.' 
   print, 'NOTE: The USER must tailor MAKE_ADQL to meet his/her needs in performing'
   print, 'the actual query or enter a valid ADQL query as a string.'
   return
endif


IF (n_elements(qry) eq 0) THEN BEGIN
;Make the query
 make_adql, qry=qry, ra,dec,sr,chisq0
ENDIF
print, qry

;The Web Services stuff:
 nullit = OBJ_NEW()
 resource = OBJ_NEW('IDLJavaObject$Static$FR_U_STRASBG_VIZIER_XML_VOTABLE_1_1_XSD_RESOURCE', 'fr.u_strasbg.vizier.xml.VOTable_1_1_xsd/RESOURCE')
 vot = OBJ_NEW('IDLJavaObject$Static$FR_U_STRASBG_VIZIER_XML_VOTABLE_1_1_XSD_VOTABLE', 'fr.u_strasbg.vizier.xml.VOTable_1_1_xsd/VOTABLE')
 loc = OBJ_NEW('IDLJavaObject$NET_IVOA_SKYPORTAL_SKYPORTALLOCATOR','net.ivoa.SkyPortal.SkyPortalLocator')
 loc ->setSkyPortalSoapEndpointAddress,'http://openskyquery.net/Sky/SkyPortal/SkyPortal.asmx'
 addr =loc -> getSkyPortalSoapAddress()
 stub = loc -> getSKyPortalSoap()

;Make the query call, return a VOTable
 vod = stub -> submitDistributedQuery(qry,"VOTABLE")
 vot = vod ->getVOTABLE()
 
;Parse the VOTable into a structure
 resource = vot ->getResource(0)
 table = resource ->getTable(0)
 fields = table->getFIELD()
 cols = n_elements(fields)
 getdata = table -> getDATA()
 tabledata = getdata ->getTABLEDATA()
 tr = tabledata -> getTR()
 fName = strarr(cols)
 tName = strarr(cols)
 for i = 0, cols -1 DO BEGIN
  fields = table->getFIELD(i)
  types2 = fields->getDataType()
  tName[I] = types2 ->toString()
  fields2 = fields->getName()
  fName[i] = fields2 ->toString()
 endfor
 IF (n_elements(row) eq 0) THEN row = strarr(n_elements(tr), cols)
; print, fName
 ic = 0
 FOR i = ic*n_elements(tr), ic*n_elements(tr) + (ic + 1)*n_elements(tr) -1L DO BEGIN
  myRow = tr[i]
  IF (myrow ne OBJ_NEW()) THEN BEGIN
   row[i,*] = myrow->getTD()
  ENDIF
;  print, row
 ENDFOR
;At the moment (11/25/04), we handle 6 data types
;If not yet defined, define and fill structure
 IF (strtrim(tName[0],2) eq 'long') THEN   A = CREATE_STRUCT(strtrim(fName[0],2), long64(row[0,0]))
 IF (strtrim(tName[0],2) eq 'int') THEN   A = CREATE_STRUCT(strtrim(fName[0],2), long(row[0,0]))
 IF (strtrim(tName[0],2) eq 'short') THEN   A = CREATE_STRUCT(strtrim(fName[0],2), long(row[0,0]))
 IF (strtrim(tName[0],2) eq 'double') THEN    A = CREATE_STRUCT(strtrim(fName[0],2), double(row[0,0]))
 IF (strtrim(tName[0],2) eq 'float') THEN   A = CREATE_STRUCT(strtrim(fName[0],2), float(row[0,0]))
 IF (strtrim(tName[0],2) eq 'char') THEN   A = CREATE_STRUCT(strtrim(fName[0],2), string(row[0,0]))
 FOR J = 1, cols -1 DO BEGIN
   IF (strtrim(tName[J],2) eq 'long') THEN  A = CREATE_STRUCT(a, strtrim(fName[J],2), long(row[0,J]))
   IF (strtrim(tName[J],2) eq 'int') THEN   A = CREATE_STRUCT(a, strtrim(fName[J],2), long(row[0,J]))
   IF (strtrim(tName[J],2) eq 'short') THEN   A = CREATE_STRUCT(a, strtrim(fName[J],2), long(row[0,J]))
   IF (strtrim(tName[J],2) eq 'double') THEN    A = CREATE_STRUCT(a, strtrim(fName[J],2), double(row[0,J]))
   IF (strtrim(tName[J],2) eq 'float') THEN   A = CREATE_STRUCT(a, strtrim(fName[J],2), float(row[0,J]))
   IF (strtrim(tName[J],2) eq 'char') THEN   A = CREATE_STRUCT(a, strtrim(fName[J],2), string(row[0,J]))
 ENDFOR
 a_all = replicate(a,n_elements(tr))
 FOR J = 0, cols -1 DO BEGIN
  a_all.(J) = row[*,J]
 ENDFOR

str = a_all
OBJ_DESTROY, nullit
OBJ_DESTROY, resource
OBJ_DESTROY, vot
OBJ_DESTROY, loc
OBJ_DESTROY, stub
OBJ_DESTROY, vod,table
OBJ_DESTROY, fields
OBJ_DESTROY, getdata
OBJ_DESTROY, tabledata
OBJ_DESTROY, tr
OBJ_DESTROY, types2
OBJ_DESTROY, fields2
OBJ_DESTROY, myRow

return

END
