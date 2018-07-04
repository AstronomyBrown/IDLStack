; cat2ds9.pro
; by Krzysztof Findeisen
; Last modified 10/25/2006
; Converts an ALFALFA catalog list to a CSV file readable by DS9
; Syntax: cat2ds9, catalogFile, radioSources, [opticalSources]

pro cat2ds9, catfile, radiofile, opfile

	; Test for file existence
	if not file_test(catfile, /read) then message, 'Could not read catalog file ' + catfile
	
	; Load in the data
	readfmt, catfile, 'A17,18X,D8.1,D7.0,10X,D8.1,D7.0', srcnum, raH, decH, raO, decO, /silent
	; And repackage the data...
	fileO = -1
	openw, fileR, radiofile, /get_lun
	if(n_params() ge 3) then openw, fileO, opfile, /get_lun
	printf, fileR, "objID,ra,dec"
	if(fileO ge 0) then printf, fileO, "objID,ra,dec"
	for i=0, n_elements(srcnum)-1 do $
		printf, fileR, srcnum[i], raH[i]*15, decH[i], format='(I6,", ",D10.5,", ", D10.5)'
		if(fileO ge 0) printf, file)
	close, fileR
	free_lun, fileR
	if(fileO ge 0) then begin
		close, fileO
		free_lun, fileO
	endif

end
