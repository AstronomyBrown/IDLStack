
;+
; Project     : VOlib (CTIO)
;
; NAME: 
;       CALL_REGISTRY

; CATEGORY:
;       Utility
;
; PURPOSE:
;       To make queries to the NVO Registry Services.
;       Specifically, we call the JHU/STSci NVO Registry
;       (http://nvo.stsci.edu/voregistry/index.aspx)
;       As of the current version, a user may search
;       the registry for a given KEYWORD in any of 7
;       categories: Title, ShortName, Subject, Type,
;       Description, ServiceType, and Identifier.
;       Multiple KEYWORD searches are not available.
;       However, the use may specify a ServiceType
;       (Cone, SIAP, SkyNode).
;            
;
; CALLING SQUENCE:
;       IDL>  call_registry,str=str1,'parallax' [,/cone,/siap,/skynode]
;
; INPUTS: 
;       INPUT STING = keyword to be searched for in the registry
;                       
; OUTPUS: 
;        str: a structure containing the registry info. Type
;             IDL> help, /str, str 
;             to find out the name of the columns returned.
;             Basically, all FIELD names (or IDs) are given data columns
;             plus the first column which is entitled CREATED and is
;             a string of the data the structure was created. If only
;             one tag exists in your structure, the VOT was empty.
;
; KEYWORD PARAMETERS:
;        /CONE specifies that you want only cone services
;        /SIAP specifies that you want only siap services
;        /SKYNODE specifies that you want only cone services
;
; DEPENDENCIES:
;        The VOlib IDL/Java class libraries (included with VOlib).
;
; MODIFCATION HISTROY: 
;        Written: 2/04/05 Christopher J. Miller (NOAO/CTIO)
;        Contact     : cmiller@noao.edu
;
; KNOWN ISSUES:
;        The registry calls require registries to have their
;        information properly filled out as well as to use some
;        standardized methods. For instance, while there is only
;        one CONE type service in the JHU/STSci Registry, there
;        are three SIAPs (SIAP, SIAP/ARCHIVE, SIAP/CUTOUT). So a
;        simple search on all SIAP servers might miss the ARCHIVE
;        and CUTOUT versions.
;-


PRO CALL_REGISTRY, str=str, keyword, CONE=cone, SIAP=siap, SKYNODE=skynode

if (n_params(0) eq 0 and n_elements(str) eq 0) then begin
   print," call_registry,str=str1,'parallax' [,/cone,/siap,/skynode]"
   print, 'Call a VO registry and return a structure containing the XML information.'
   print, 'The user must specify a keyword to search in the registry. If CONE, '
   print, 'SIAP, or SKYNODE are specified, the search is limited to these services.'
   return
endif


IF (n_elements(keyword) eq 0) THEN KEYWORD = 'SDSSDR2'
regService = OBJ_NEW('IDLJavaObject$ORG_US_VO_WWW_REGISTRY_LOCATOR', 'org.us_vo.www.RegistryLocator')
regInterface = regService->getRegistrySoap()
query = "Title like '%" + keyword + "%' or " +  $
       "ShortName like '%" + keyword + "%' or " + $
       "Subject like '%" + keyword + "%' or " + $
       "Type like '%" + keyword + "%' or " + $
       "Description like '%" + keyword + "%' or " + $
       "ServiceType like '%" + keyword + "%' or " + $
       "Identifier like '%" + keyword + "%'"
;query = query + " and (" + constraint + ")";                   
;query = "ServiceType like '%SIAP%' and (Title like '%Sloan%')"
IF keyword_set(cone) THEN query = "ServiceType like '%CONE%' and (" + query + ")"
IF keyword_set(skynode) THEN query = "ServiceType like '%SKYNODE%' and (" + query + ")"
IF keyword_set(siap) THEN query = "(ServiceType like '%SIAP%' or ServiceType like '%SIAP;%ARCHIVE%') and (" + query + ")"
print, query
callit = regInterface->queryRegistry(query)
results = callit->getSimpleResource()
IF (results[0] ne OBJ_NEW()) THEN BEGIN
 str = create_struct('Title', ' ', 'URL', ' ', 'Type', ' ', 'ShortName', ' ', $
                      'ID', ' ', 'Desc', ' ', 'ServiceType', ' ', 'Coverage', ' ', $
                      'Subjects', ' ')
 str = replicate(str, n_elements(results))
 FOR I = 0, n_elements(results) -1 DO BEGIN
  str[I].Title = results[I]->getTitle()
  str[I].URL = results[I]->getServiceURL()
  str[I].Type = results[I]->getType()
  str[I].ShortName = results[I]->getShortName()
  str[I].ID = results[I]->getIdentifier()
  str[I].Desc = results[I]->getDescription()
  str[I].ServiceType = results[I]->getServiceType()
  str[I].Coverage = results[I]->getCoverageSpatial()
  first = results[I]->getSubject()
  IF (first[0] ne OBJ_NEW()) THEN BEGIN
  second = first->getString()
    FOR J = 0, n_elements(second) -1 DO BEGIN
      IF (J eq 0) THEN BEGIN
       subjects = second[0]
      ENDIF ELSE BEGIN
       subjects = subjects + ";" + second[J]
      ENDELSE
    ENDFOR
  ENDIF ELSE BEGIN
   subjects = ' '
  ENDELSE
  str[I].subjects = subjects
 ENDFOR
ENDIF  ELSE BEGIN
  str = OBJ_NEW()
;  str = create_struct('Title', ' ', 'URL', ' ', 'Type', ' ', 'ShortName', ' ', $
;                      'ID', ' ', 'Desc', ' ', 'ServiceType', ' ', 'Coverage', ' ', $
;                      'Subjects', ' ')
ENDELSE
RETURN
END
