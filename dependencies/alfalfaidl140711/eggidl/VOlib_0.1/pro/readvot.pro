
;+
; PROJECT     : VOlib (CTIO)
;
; NAME:
;       READVOT
;
; CATEGORY:
;       Utility
;
; PURPOSE: 
;       To read in VOTables into structures. This utility is not fast,
;       especially since so much parsing is done. I'm sure there must
;       be a better way to use the Validation_Mode. Regardless, the
;       VALIDATION_MODE is defaulted to 0 (none). This means that
;       you VOTable and the DTD (Data Table Definition) must be valid.
;       Technically, this utility should work fine with Schema Definition
;       (XSD), but the VOTable-1.1.xsd doesn't seem to work (1.0 is an
;       invalid schema). So please use the VOTable.dtd.
;       The top of your VOTable document should look something like this:
;       <?xml version="1.0" encoding="UTF-8"?>
;       <!DOCTYPE VOTABLE SYSTEM "VOTable.dtd">
;
;       This version of the code offers a REMEDIATION technique
;       which re-writes the VOTable to be valid.
;       Example VO Tables which are successfully read in are provided
;       in the VOlib distribution DATA directory.
;
; CALLING SEQUENCE:
;       IDL> readvot, 'tsObj-000756-6-44-0367.vot', str
;
; INPUTS:
;       INPUT = filename (string)
;
; OPTIONAL INPUTS:
;       TABLE = table number from the VO Table. Defaults to 1.
;
; OUTPUTS: 
;       str: VOTable as a structure. 
;
; KEYWORD PARAMETERS:
;       VALIDATE = 1 (if found) or 2 (strict)
;       /REMEDIATE try to fix the VOT table by making
;                  sure it has a !DOCTYPE and specifies
;                  the VOTable.dtd
;
; DEPENDENCIES:
;       match
;       str2arr
;       add_tag
;       remove_tags
;       rtag_names
;       concat_structs
;       delvarx
;       get_date
;       match
;       deriv_arr
;       daycnv
;       combine_structs
;       copy_struct

;
; MODIFICATION HISTORY:
;       Written: 2/04/05 Christopher J. Miller (NOAO/CTIO)
;       Contact     : cmiller@noao.edu
;
; EXAMPLE:
;       readvot, 'votable.xml',str
;
; KNOWN ISSUES:
;       Some astronomical data contains the "&" symbol, which is XML
;       is apparently a reserved charachter for an ENTITY. The IDL
;       XML reader seems to have trouble with this and will fail.
;       The XMM SIAP service produces XML with "&"s in it.    
;       Also, to turn field names into structure tag names, invalid
;       IDL characters cause problems. The current version of the
;       code tries to weed most of these out.
;       I dont know how to make structures have multiple tables
;       (outside of a LIST). So currently, the code tries to 
;       detect multiple tables, but only reads the first or the
;       otherwise specified table.
;       Many VOT headers contain array(*) as a size. This makes
;       creating the proper structure size difficult. Especially
;       for strings where it is difficult to figure out the separator
;       character.
;       Type conversions sometimes show up as warnings from failures.
;
;-

PRO sample_recurse2, oNode, indent, a,J, K, resource_num, resource_read
   ;; "Visit" the node by printing its name and value 
   NodeName = oNode->GetNodeName()
;;This section reads in the actual TD data. The data are assumed to come after the
;;FIELDs. And so the datatypes and names to fill in the structure are taken from the
;;STRUCTURE header that has already been built.
   IF (STRUPCASE(strtrim(NodeName,2)) eq 'TR') THEN BEGIN
     J = 0L; J counts data in each table
     K = K + 1L; K counts tables
   ENDIF
   IF (STRUPCASE(strtrim(NodeName,2)) eq 'TD') THEN BEGIN
     J = J + 1L   
     sizeit = size(a.(J))
     result = tag_names(a)
;     print, result, J
     obj2 = oNode->GetFirstChild()
     IF (obj2 ne OBJ_NEW()) THEN BEGIN
      IF ((obj2 ->HasChildNodes()) eq 1) THEN BEGIN
;Put in to handle 2MASS hrefs in their VOTables:
       NodeAttributes = obj2->GetAttributes()
       item = NodeAttributes->item(0)
       a.(J) = item->GetValue()
       goto, getout
      ENDIF 
     ENDIF
     IF (obj2 eq OBJ_NEW()) THEN BEGIN
       IF (sizeit[1] eq 2) THEN a.(J) = -999
       IF (sizeit[1] eq 14) THEN a.(J) = -999
       IF (sizeit[1] eq 3) THEN a.(J) = -999
       IF (sizeit[1] eq 4) THEN a.(J) = -999.9
       IF (sizeit[1] eq 5) THEN a.(J) = -999.9
       IF (sizeit[1] eq 7) THEN a.(J) = 'null'
     ENDIF ELSE BEGIN
      ChildValue = obj2->GetData()
;     print,  ChildValue, result[J], sizeit
; Check to see if the row REALLY is an array, even though the dimensions
; were not specified in the header.
      IF (n_elements(sizeit) eq 3) THEN BEGIN
        IF (sizeit[1] eq 7) THEN BEGIN
;          IF (K lt 2) THEN BEGIN
;            array = str2arr(ChildValue, ',')
;          ENDIF ELSE BEGIN
             array = ChildValue
;          ENDELSE
        ENDIF
        IF (sizeit[1] ne 7) THEN BEGIN
          array = str2arr(ChildValue, ',')
          IF (n_elements(array) eq 1) THEN array = str2arr(ChildValue, ' ')
        ENDIF
      ENDIF ELSE BEGIN
        IF (sizeit[2] eq 7) THEN BEGIN
;          IF (K lt 2) THEN BEGIN
;           array = str2arr(ChildValue, ',')
;          ENDIF ELSE BEGIN
           array = ChildValue
;          ENDELSE
        ENDIF
        IF (sizeit[2] ne 7) THEN BEGIN
          array = str2arr(ChildValue, ',')
          IF (n_elements(array) eq 1) THEN array = str2arr(ChildValue, ' ')
        ENDIF
      ENDELSE
      w = where(array ne '')
      IF (w[0] ne -1) THEN BEGIN
       array = array[w]
      ENDIF
;If the datatype is NOT an array, fill in the structure
      IF (sizeit[0] eq 0 and n_elements(array) eq 1) THEN BEGIN
       IF (sizeit[1] eq 2) THEN a.(J) = long(strtrim(ChildValue,2))
       IF (sizeit[1] eq 14) THEN a.(J) = long64(strtrim(ChildValue,2))
       IF (sizeit[1] eq 3) THEN a.(J) = long64(strtrim(ChildValue,2))
       IF (sizeit[1] eq 4) THEN a.(J) = float(strtrim(ChildValue,2))
       IF (sizeit[1] eq 5) THEN a.(J) = double(strtrim(ChildValue,2))
       IF (sizeit[1] eq 7) THEN a.(J) = string(strtrim(ChildValue,2))
      ENDIF ELSE BEGIN
;;If the datatype is a ONE DIMENSIONAL array, fill in the structure
;       print, array, n_elements(array), sizeit[2], ChildValue, a.(J)
       IF (sizeit[1] eq 1 and n_elements(array) eq 1) THEN BEGIN
        IF (sizeit[2] eq 2) THEN a.(J) = long(strtrim(ChildValue,2))
        IF (sizeit[2] eq 14) THEN a.(J) = long64(strtrim(ChildValue,2))
        IF (sizeit[2] eq 3) THEN a.(J) = long64(strtrim(ChildValue,2))
        IF (sizeit[2] eq 4) THEN a.(J) = float(strtrim(ChildValue,2))
        IF (sizeit[2] eq 5) THEN a.(J) = double(strtrim(ChildValue,2))
        IF (sizeit[2] eq 7) THEN a.(J) = string(strtrim(ChildValue,2))
       ENDIF
       IF (sizeit[0] eq 1 and n_elements(array) gt 1) THEN BEGIN
;;Separate the node table data (TD) into any components (if charachter, only
;;separate on ",", if data, try to separate on ' ' and ','.
         IF (sizeit[2] eq 7) THEN BEGIN
;             IF (K lt 2) THEN BEGIN
;              lineit2 = str2arr(ChildValue, ',')
;              array = str2arr(ChildValue, ',')
;             ENDIF ELSE BEGIN
              array = ChildValue
;             ENDELSE
         ENDIF
         IF (sizeit[2] ne 7) THEN BEGIN
          lineit2 = array; str2arr(ChildValue, ',')
          IF (n_elements(lineit2) eq 1) THEN lineit2 = array;str2arr(ChildValue, ' ')
         ENDIF
;;If the table data (TD) seems to have more elements than specified in the
;;header, redo the structure to reflect the additon of the arrays.
          IF (n_elements(array) ne sizeit[1]) THEN BEGIN
;            IF (strpos(lineit2[0], 'Devine') ne -1) THEN stop
            a_old = a
            tags = rtag_names(a)
            keepname = tags[J]
            FOR LM = n_elements(tags) -1, J, -1 DO BEGIN
             remove_tags, a, tags[LM], new_a
             a = new_a
            ENDFOR
            IF (sizeit[2] eq 2) THEN  add_tag, a, keepname, long(lineit2), new_a
            IF (sizeit[2] eq 14) THEN add_tag, a, keepname, long64(lineit2), new_a
            IF (sizeit[2] eq 3) THEN add_tag, a, keepname, long64(lineit2), new_a
            IF (sizeit[2] eq 4) THEN add_tag, a, keepname, float(lineit2), new_a
            IF (sizeit[2] eq 5) THEN add_tag, a, keepname, double(lineit2), new_a
            IF (sizeit[2] eq 7) THEN add_tag, a, keepname, string(lineit2), new_a
            a = new_a 
            FOR LM = J+1, n_elements(tags) -1 DO BEGIN
             add_tag, a, tags[LM], a_old[0].(LM), a_new
	     a = a_new
             a.(LM) = a_old.(LM)
            ENDFOR
          ENDIF ELSE BEGIN
           IF (sizeit[2] eq 2) THEN a.(J) = long(lineit2)
           IF (sizeit[2] eq 14) THEN a.(J) = long64(lineit2)
           IF (sizeit[2] eq 3) THEN a.(J) = long64(lineit2)
           IF (sizeit[2] eq 4) THEN a.(J) = float(lineit2)
           IF (sizeit[2] eq 5) THEN a.(J) = double(lineit2)
           IF (sizeit[2] eq 7) THEN a.(J) = string(lineit2)
           delvarx, lineit2
          ENDELSE
       ENDIF
;;If the datatype is a TWO DIMENSIONAL array, fill in the structure
      IF (sizeit[0] eq 2) THEN BEGIN
;;Separate the node table data (TD) into any components (if charachter, only
;;separate on ",", if data, try to separate on ' ' and ','.
         IF (sizeit[3] eq 7) THEN BEGIN
;            IF (J lt 2) THEN BEGIN
;              lineit2 = str2arr(ChildValue, ',')
;              array = str2arr(ChildValue, ',')
;            ENDIF ELSE BEGIN
              array = ChildValue
;            ENDELSE
         ENDIF
         IF (sizeit[3] ne 7) THEN BEGIN
          lineit2 = str2arr(ChildValue, ',')
          IF (n_elements(lineit2) eq 1) THEN lineit2 = str2arr(ChildValue, ' ')
         ENDIF
         w = where(lineit2 ne '')
         IF (w[0] ne -1) THEN BEGIN
          lineit2 = lineit2[w]
         ENDIF
;;If the table data (TD) seems to have more elements than specified in the
;;header, redo the structure to reflect the additon of the arrays.
          IF (n_elements(lineit2) ne sizeit[4]) THEN BEGIN
            a_old = a
            tags = rtag_names(a)
            keepname = tags[J]
            FOR LM = n_elements(tags) -1, J, -1 DO BEGIN
             remove_tags, a, tags[LM], new_a
             a = new_a
            ENDFOR
            IF (sizeit[3] eq 2) THEN  add_tag, a, keepname, lonarr(sizeit[1], sizeit[2]), new_a
            IF (sizeit[3] eq 14) THEN add_tag, a, keepname, lon64arr(sizeit[1], sizeit[2]), new_a
            IF (sizeit[3] eq 3) THEN add_tag, a, keepname, lon64arr(sizeit[1], sizeit[2]), new_a
            IF (sizeit[3] eq 4) THEN add_tag, a, keepname, fltarr(sizeit[1], sizeit[2]), new_a
            IF (sizeit[3] eq 5) THEN add_tag, a, keepname, dblarr(sizeit[1], sizeit[2]), new_a
            IF (sizeit[3] eq 7) THEN add_tag, a, keepname, strarr(sizeit[1], sizeit[2]), new_a
            a = new_a
            FOR LM = J+1, n_elements(tags) -1 DO BEGIN
             add_tag, a, tags[LM], a_old[0].(LM), a_new
             a = a_new
             a.(LM) = a_old.(LM)
            ENDFOR
          ENDIF ELSE BEGIN
           IF (sizeit[3] eq 2) THEN a.(J) = long(lineit2)
           IF (sizeit[3] eq 14) THEN a.(J) = long64(lineit2)
           IF (sizeit[3] eq 3) THEN a.(J) = long64(lineit2)
           IF (sizeit[3] eq 4) THEN a.(J) = float(lineit2)
           IF (sizeit[3] eq 5) THEN a.(J) = double(lineit2)
           IF (sizeit[3] eq 7) THEN a.(J) = string(lineit2)
           delvarx, lineit2
          ENDELSE
       ENDIF
      ENDELSE
     ENDELSE
   ENDIF
   getout:
;;The VOTable has the header information in the FIELDs and their ATTRIBUTEs
;;We treat arrays and scalars separately. 
   NodeValue = oNode->GetNodeValue()
   NodeAttributes = oNode->GetAttributes()
   IF (obj_new() ne NodeAttributes) THEN BEGIN
     AttributesLength = NodeAttributes->GetLength()
     IF (AttributesLength gt 0) THEN BEGIN
      AttNames = strarr(AttributesLength)
      AttValue = strarr(AttributesLength)
      delvarx, ArrElem
      delvarx, DataElem
      delvarx, NameElem
      delvarx, IDElem
      FOR I = 0, AttributesLength -1 DO BEGIN
        item = NodeAttributes->item(I)
        AttNames[I] = item->GetName()
        AttValue[I] = item->GetValue()
;        print, AttNames[I],AttValue[I]
        arraypos = strpos(strtrim(AttNames[I],2), 'arraysize')
        IF (arraypos[0] ne -1) THEN BEGIN
           ArrElem = I
        ENDIF
        datapos =  strpos(strtrim(AttNames[I],2), 'datatype')
        IF (datapos[0] ne -1) THEN BEGIN
           DataElem = I
        ENDIF
        ucdpos =  strpos(strtrim(AttNames[I],2), 'ucd')
        IF (ucdpos[0] ne -1) THEN BEGIN
           UCSElem = I
        ENDIF
        namepos =  strpos(strtrim(AttNames[I],2), 'name')
        IF (namepos[0] ne -1) THEN BEGIN
           NameElem = I
        ENDIF ELSE BEGIN
           namepos =  strpos(strtrim(AttNames[I],2), 'ID')
           IF (namepos[0] ne -1) THEN BEGIN
             NameElem = I
           ENDIF
        ENDELSE
      ENDFOR
      delvarx, x
      delvarx, y
      IF (n_elements(ArrElem) ne 0) THEN BEGIN
       IF (strpos(AttValue[ArrElem], 'x') ne -1) THEN  BEGIN
         IF (AttValue[ArrElem] eq '*') THEN BEGIN
          x = 1
         ENDIF ELSE BEGIN
          x = long(strtrim(strmid(AttValue[ArrElem],0,strpos(AttValue[ArrElem], 'x')),2))
         ENDELSE
         IF (AttValue[ArrElem] eq '*') THEN BEGIN
          y = 1
         ENDIF ELSE BEGIN
          y = long(strtrim(strmid(AttValue[ArrElem], strpos(AttValue[ArrElem], 'x') +1,strlen(AttValue[ArrElem]) - strpos(AttValue[ArrElem], 'x') ),2))
         ENDELSE
       ENDIF ELSE BEGIN
         IF (AttValue[ArrElem] eq '*') THEN BEGIN
          x = 1
         ENDIF ELSE BEGIN
          x = long(AttValue[ArrElem])
         ENDELSE
         delvarx, y
       ENDELSE
      ENDIF
;;First, the TWO DIMENSIONAL ARRAY datatypes and names are given to the structure
      IF (STRUPCASE(strtrim(NodeName,2)) eq 'FIELD') THEN BEGIN
         tagname = strtrim(AttValue[NameElem],2)
         result = strpos(tagname, ',')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, ' ')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '-')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '=')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '&')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '+')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '*')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '$')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '!')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '(')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, ')')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, "'")
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         result = strpos(tagname, '"')
         IF (result[0] ne -1) THEN tagname = strmid(tagname,0,result) + strmid(tagname,result+1, strlen(tagname)-result)
         tagname = strtrim(tagname,2)
       IF (n_elements(y) ne 0) THEN BEGIN
        IF (strtrim(AttValue[DataElem],2) eq 'long') THEN   A = CREATE_STRUCT(a,tagname, lon64arr(x,y))
        IF (strtrim(AttValue[DataElem],2) eq 'int') THEN   A = CREATE_STRUCT(a,tagname, lonarr(x,y))
        IF (strtrim(AttValue[DataElem],2) eq 'short') THEN   A = CREATE_STRUCT(a,tagname, lon64arr(x,y))
        IF (strtrim(AttValue[DataELem],2) eq 'double') THEN    A = CREATE_STRUCT(a,tagname, dblarr(x,y))
        IF (strtrim(AttValue[DataElem],2) eq 'float') THEN   A = CREATE_STRUCT(a,tagname, fltarr(x,y))
        IF (strtrim(AttValue[DataElem],2) eq 'char') THEN   A = CREATE_STRUCT(a,tagname, strarr(x,y))
       ENDIF
;;NEXT, the ONE DIMENSIONAL ARRAY datatypes and names are given to the structure
       IF (n_elements(x) ne 0 and n_elements(y) eq 0) THEN BEGIN
        IF (strtrim(AttValue[DataElem],2) eq 'long') THEN   A = CREATE_STRUCT(a,tagname, lon64arr(x))
        IF (strtrim(AttValue[DataElem],2) eq 'int') THEN   A = CREATE_STRUCT(a,tagname, lonarr(x))
        IF (strtrim(AttValue[DataElem],2) eq 'short') THEN   A = CREATE_STRUCT(a,tagname, lon64arr(x))
        IF (strtrim(AttValue[DataELem],2) eq 'double') THEN    A = CREATE_STRUCT(a,tagname, dblarr(x))
        IF (strtrim(AttValue[DataElem],2) eq 'float') THEN   A = CREATE_STRUCT(a,tagname, fltarr(x))
        IF (strtrim(AttValue[DataElem],2) eq 'char') THEN   A = CREATE_STRUCT(a,tagname, strarr(x))
       ENDIF
;;FIANLLY, the SCALARS are assigned datatypes and names in the structure
       IF (n_elements(x) eq 0 and n_elements(y) eq 0) THEN BEGIN
        IF (n_elements(DataElem) ne 0) THEN BEGIN
         IF (strtrim(AttValue[DataElem],2) eq 'long') THEN   A = CREATE_STRUCT(a,tagname, long64(0))
         IF (strtrim(AttValue[DataElem],2) eq 'int') THEN   A = CREATE_STRUCT(a,tagname, long(0))
         IF (strtrim(AttValue[DataElem],2) eq 'short') THEN   A = CREATE_STRUCT(a,tagname, long64(0))
         IF (strtrim(AttValue[DataELem],2) eq 'double') THEN    A = CREATE_STRUCT(a,tagname, double(0))
         IF (strtrim(AttValue[DataElem],2) eq 'float') THEN   A = CREATE_STRUCT(a,tagname, float(0))
         IF (strtrim(AttValue[DataElem],2) eq 'char') THEN   A = CREATE_STRUCT(a,tagname, string(0))
        ENDIF
       ENDIF
      ENDIF
    ENDIF
   ENDIF ELSE BEGIN
;;If the NODE is useless, ignore it.
     AttributesLength = 0
   ENDELSE
;   print, AttributesLength
;   PRINT, indent gt 0 ? STRJOIN(REPLICATE(' ', indent)) : '', $  
;      NodeName, ':', NodeValue, '::' 
 
   ;; Visit children 
   oNodeList = oNode->GetChildNodes() 
   n = oNodeList->GetLength() 
;   print, n, NodeName
   IF (strupcase(strtrim(NodeName,2)) eq 'RESOURCE') THEN BEGIN
    resource_num = resource_num + 1
    IF (double(resource_num)/2.0 ne resource_read-1) THEN goto, endit
   ENDIF
   IF (strupcase(strtrim(NodeName,2)) eq 'TABLEDATA') THEN BEGIN
    K = -1L
    IF (n_elements(a) eq 0) THEN BEGIN
;; Stop everything if the XML doesn't have the right information to build the structure.
       print, 'Invalid VOT: No Header Information Provided'
       stop
    ENDIF

;; Replicate the structure to the full size of the VOTable
;;Since we're in the TABLEDATA section of the VOTable, send over the data structure
;;one line at a time.
;    data = replicate(a, n)
    old_a = a
    FOR i=0L, n-1L DO BEGIN
      k_old = k
      SAMPLE_RECURSE2, oNodeList->Item(i), indent+4 , a, J,K,resource_num, resource_read
      IF (k_old ne k) THEN BEGIN 
        IF (k eq 0) THEN BEGIN
         old_a = a
        ENDIF ELSE BEGIN
         concat_structs, old_a, a, new_a
         old_a = new_a
        ENDELSE
        k_old = k
      ENDIF
    ENDFOR
   a = old_a
   ENDIF ELSE BEGIN
;;Here, we're not in the TABLEDATA Section yet--we're building the header.
    FOR i=0L, n-1L DO $ 
       SAMPLE_RECURSE2, oNodeList->Item(i), indent+4 , a, J,K,resource_num, resource_read
   ENDELSE
    endit:
    OBJ_DESTROY, oNodeList 
    RETURN
END 
 
PRO readvot,filename, str, validate=validate, remediate=remediate, table=resource_read

if n_params(0) eq 0 then begin
   print,"readvot, 'tsObj-000756-6-44-0367.vot', str [,VALIDATE=0,1,2, /REMEDIATE, TABLE=]"
   print, 'Read in a VOTable XML file. If Validate = 0, no validation is performed.'
   print, 'The REMEDIATION keyword will attempt to fix a VOTable header to work with'
   print, 'this reader.'
   return
endif


fileread=filename
IF (keyword_set(REMEDIATE)) THEN BEGIN
 openr,1,filename
 openw,2,filename + '.remed'
 temp = ' '
 count=0
 WHILE NOT EOF(1) DO BEGIN
    ReadF,1,temp
    IF (COUNT eq 1) THEN BEGIN
      spawn, ('echo $VOlib_DATA'), datadir
;      temp = '<!DOCTYPE VOTABLE SYSTEM "' + strtrim(datadir,2) + 'VOTable.dtd">'
      temp = '<!DOCTYPE VOTABLE SYSTEM "VOTable.dtd">'
;      print, temp
      printf,2,temp
      temp = "<VOTABLE version='1.0'>"
      printf,2,temp
      founda = 1
      goto, skipit
    ENDIF
    IF (strpos(strupcase(temp), '/VOTABLE') ne -1) THEN     printf,2,temp
    IF (strpos(strupcase(temp), 'VOTABLE') ne -1) THEN GOTO, skipit
    IF (strpos(strupcase(temp), 'DOCTYPE') ne -1) THEN GOTO, skipit
    printf,2,temp
    skipit:
    count = count+1
 ENDWHILE
 close,/all
 fileread = filename + '.remed'
ENDIF

   if (n_elements(validate) eq 0) THEN validate = 0
   oDoc = OBJ_NEW('IDLffXMLDOMDocument') 
;    oDoc->Load, FILENAME="sample.xml" 
;   oDoc->Load, FILENAME="example2.vot" ,/EXCLUDE_IGNORABLE_WHITESPACE, VALIDATION_MODE=2
   oDoc->Load, FILENAME=fileread ,/EXCLUDE_IGNORABLE_WHITESPACE, VALIDATION_MODE=validate
   get_date, dte
   str = create_struct('Created', string(dte))
   J = -1L
   K = 0L
   resource_num = -1
   IF (n_elements(resource_read) eq 0) THEN resource_read = 1
   SAMPLE_RECURSE2, oDoc, 0,str,  J,K, resource_num, resource_read
   OBJ_DESTROY, oDoc 
   IF keyword_set(remediate) THEN spawn, 'rm ' + filename + '.remed'
   IF (resource_num gt 0) THEN print, strtrim(string(resource_num/2+1),2) + ' tables found. Table number ' + strtrim(string(resource_read),2) + $
           ' was read in.  You can specify another with table = x.'

END 
