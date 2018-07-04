pro getcomments,output_file

;+
;NAME:
;	GETCOMMENTS
;PURPOSE:
;	To prepare a "footnotes file", starting from a directory containing all the source files for
;	a given catalog. Format of the output file is then:
;	HI093603.0+105417_0940+11c.src  affected by rfi
;
;	The first 17 characters are the HI name of the source, followed by "_grid+XXa.src", followed by two spaces,
;	followed by a string (maximum length 400 characters) that contains the comment. 
;
;	Note that this procedure will grab all your comments and assume they are footnotes, so be sure to check
;	over everything!
;
;	A file in this format can then be used with distance_catalog.pro to make a set of ALFALFA catalog paper
;	tables including the footnotes for each source.
;
;
;CALLING SEQUENCE:
;	GETCOMMENTS,OUTPUT_FILE	
;
;EXAMPLE:
;	GETCOMMENTS,'footfile.txt'
;
;
;INPUTS:
;	No inputs - but you must be running GETCOMMENTS in a directory containing all the .src files
;	for which you want to create footnotes.
;
;OUTPUTS:
;	OUTPUT_FILE - a "footnotes file" that can then be used with distance_catalog.pro to create
;		ALFALFA paper tables with proper footnotes for sources.
;
;
;REVISION HISTORY:
;       Written and added to EGGGEN. S.Stierwalt Dec2007
;	Modified to work with distance_catalog. A.Martin Dec2007
;-


;getcomments should be run in a directory containing all of your .src

;Create a list of all of your .sav files
spawn, 'ls *.src > filelist.txt'

HINAME=''

openr,inlun,'filelist.txt',/get_lun
openw,outlun,output_file,/get_lun

while(EOF(inlun) ne 1) do begin
     readf,inlun,HINAME,format='(A30)'
     restore,HINAME
     HINAME=strtrim(HINAME,2)
     if ((src.spectra[0].x_int[0] ne 3) AND (src.spectra[0].x_int[0] ne 4)) then begin
	comment=src.comments[0]
	comment=strtrim(comment,2)
	comlength=strlen(comment)
	tag=strtrim(string(comlength),2)
		if(tag EQ 0) then continue
	printf,outlun,HINAME,comment,format="(A30,'  ',a"+tag+")"

     endif
 endwhile

close,inlun
free_lun,inlun
close,outlun
free_lun,outlun






end
