pro mkfinding,name,output

;+
; NAME: 
;	MKFINDING
;
; PURPOSE:
;       Makes finding charts that give the distance between a galaxy/Halpha region of interest
;	and a set of standard stars in arcseconds. Input is a file with a set of coordinates
;	and output is a tex file.
;
; SYNTAX:
;	MKFINDING,input_name,output_name
;
; INPUTS:
;	Directory must contain an eps file with the following naming convention: agc******_find.eps
;	Must also contain aastex.cls
;	input_name - string; the filename of the .coord input file
;
;	agc******.coord must have EXACTLY the following format:	
;
;H1   721.94   892.54  1:41:07.90 27:19:34.88 
;S1   736.18   906.26  1:41:07.28 27:19:43.18 
;S2   742.66   769.43  1:41:06.89 27:18:21.78 
;S3  1061.76   596.82  1:40:52.52 27:16:41.93 
;S4   935.05  1092.34  1:40:58.52 27:21:35.77
;
;	See the NOTES section for information on how to make the .coord file.
; 
; OUTPUTS:
;	output_name - string; the filename of the .tex output file.
;	After running mkfinding, compile the tex file and convert to ps to print:
;	>latex agc112521.tex
;	>dvips agc112521 -o
;
; EXAMPLES:
;	mkfinding,'agc112521.coord','agc112521.tex'
;
;MODIFICATION HISTORY:
;	Amelie Saintonge, mkfinding.pro + "Notes on Making Finding Charts."
;	Documentation updated A. Martin, March 2009
;
;NOTES:
;       In the example above, the region of interest is an Halpha-emitting region,
;       designated as H1. In the *.fits image, it is found at pixels 721,892 or, in
;       sky coordinates, at 0141+27. S1-4 are nearby stars, with pixel and sky
;       coordinates given.
;
;       How to make a .coord file from IRAF:
;       use IMEXAM and the 'a' key to get the pixel coordinates of the HII regions and reference.  Ideally, get everything
;       from the image with continuum, but if the HII regions can't be identified use the continuum-subtracted image to get
;       these.  Put these values in a file called 'agc112521.pix'.  For example:
;
; 721.94  892.54 H1
; 736.18  906.26 S1
; 742.66  769.43 S2
;1061.76  596.82 S3
; 935.05 1092.34 S4
;
;       The first two numbers printed out from hitting 'a' are RA/dec (pixels). Hitting 'r' will show you
;       the profile of the star so you can make sure it's not saturated. Don't pick stars near bright/saturated
;       stars.
;
;       Use the XYEQ task in stsdas.analysis.gasp to get the screen output that you will put into the .coord file:
;
;PACKAGE = gasp
;   TASK = xyeq 
;
;iminfo  =                  yes  Is there an input image
;image   =       agc112521_R_SH  Input image name
;coeffile=                       Input astrometic solution file
;xyfile  =        agc112521.pix  Input (x,y) file name
;pix_cent=                 iraf  X,Y origin: iraf(1,1); dss(1.5,1.5); cos(0.5,0.5)
;xcolnum =                    1  X pixel column number
;ycolnum =                    2  Y pixel column number
;nskip   =                    0  Number of lines to skip in xy file
;(origina=                   no) Use original plate solution?
;(new    =                   no) Use new plate solution?
;(cdmatx =                  yes) Use CD matrix values?
;(ra_hour=                  yes) Display RA in h:m:s?
;(ra_form=                     ) Output format for RA
;(dec_for=                     ) Output format for DEC
;(mode   =                   al)
;
;this will create an output like this:
;    X        Y      RA_cd      DEC_cd
;                     (hrs)      (deg)
;  721.94   892.54  1:41:07.90 27:19:34.88
;  736.18   906.26  1:41:07.28 27:19:43.18
;  742.66   769.43  1:41:06.89 27:18:21.78
; 1061.76   596.82  1:40:52.52 27:16:41.93
;  935.05  1092.34  1:40:58.52 27:21:35.77
;
;	You also need to create an image, agc******_find.eps.
;	First we need to create an image with the position of the stars and HII regions marked.  
;	First, display the continuum image:
;
;	cl> displ agc112521_R_SH 1
;	cl> imdel temp   (just to make sure it's not already defined)
;	Then overplot the position of the stars and HII regions using TVMARK.
;	Finally, convert the output image to an eps agc******_find.eps in the EXPORT task (dataio package).
;-


;obj=strarr(100)
;x=fltarr(100)
;y=fltarr(100)
;ra=strarr(100)
;dec=strarr(100)

record={obj:' ',x:0.0,y:0.0,ra:'00:00:00.0',dec:'00:00:00.0'}
data=replicate(record,100)

nrec=0
openr,lun,name,/get_lun
while(eof(lun) ne 1) do begin
readf,lun,record,format='(a3,f8.2,f9.2,a12,a12)'
data[nrec]=record
nrec=nrec+1
endwhile
free_lun,lun

openw,lun,output,/get_lun
;printf,lun,strmid(name,0,(strpos(name,'.')))
;printf,lun,strtrim(name,2),format='(a25)'

printf,lun,'\documentclass[10pt,preprint]{aastex}',format='(a37)'
printf,lun,'\usepackage{epsfig}',format='(a20)'
printf,lun,'\begin{document}',format='(a16)'
;printf,lun,strmid(name,0,(strpos(name,'.'))),format='("\title{",a9,"}")'
printf,lun,'\centering',format='(a10)'
printf,lun,strmid(name,0,(strpos(name,'.'))),format='("\bf{",a9,"}")'

printf,lun,'\begin{figure}[h]',format='(a17)'
printf,lun,'\centering',format='(a10)'
printf,lun,strmid(name,0,(strpos(name,'.'))),format='("\epsfig{file=",a9,"_find.eps, width=100mm}")'
printf,lun,'\end{figure}',format='(a12)'
;printf,lun,'\nopagebreak',format='(a12)'


printf,lun,'\begin{table}[h]',format='(a16)'
printf,lun,'\centering',format='(a10)'
printf,lun,'\begin{tabular}{lcccccc}',format='(a24)'
printf,lun,'\\',format='(a2)'
printf,lun,'\tableline',format='(a10)'
printf,lun,'\tableline',format='(a10)'
printf,lun,'Name &x  &y  &RA(J2000)  &DEC(J2000) &RA  &DEC\\',format='(a48)'
printf,lun,'\tableline',format='(a10)'

rad=dblarr(nrec)
decd=dblarr(nrec)
for i=0,nrec-1 do begin
  rah=float(strmid(data[i].ra,1,2))
  ram=float(strmid(data[i].ra,4,2))
  ras=float(strmid(data[i].ra,7))
  rad[i]=rah+ram/60.0+ras/3600.0
  dech=float(strmid(data[i].dec,1,2))
  decm=float(strmid(data[i].dec,4,2))
  decs=float(strmid(data[i].dec,7))
  decd[i]=dech+decm/60.0+decs/3600.0
  
  printf,lun,data[i].obj,data[i].x,data[i].y,data[i].ra,data[i].dec,rad[i],decd[i], $
         format='(a2,2x,"&",f8.2,1x,"&",f9.2,1x,"&",a13,1x,"&",a13,1x,"&",d11.6,1x,"&",d11.6,"\\")'
endfor
printf,lun,'\tableline',format='(a10)'
printf,lun,'\end{tabular}',format='(a13)'
printf,lun,'\end{table}',format='(a11)'

for i=0,nrec-1 do begin
   if (strmid(data[i].obj,0,1) ne 'H') then begin
     stars=i
     break
   endif
endfor


printf,lun,'    ',format='(a3)'
printf,lun,'\begin{table}[b!]',format='(a17)'
printf,lun,'\centering',format='(a10)'
printf,lun,'\begin{tabular}{cccc}',format='(a21)'
printf,lun,'\\',format='(a2)'
printf,lun,'\tableline',format='(a10)'
printf,lun,'\tableline',format='(a10)'
printf,lun,'from &to &offset East  &offset North\\',format='(a38)'
printf,lun,'\tableline',format='(a10)'

for i=0,stars-1 do begin
 for j=stars,nrec-1 do begin
  n1=j
  n2=i
  gcirc,1,rad[n1],decd[n1],rad[n2],decd[n2],dist
  if (rad[n1] gt rad[n2]) then signra='-'
  if (rad[n1] lt rad[n2]) then signra='+'
  if (decd[n1] gt decd[n2]) then signdec='-'
  if (decd[n1] lt decd[n2]) then signdec='+'

  delra=abs((rad[n1]-rad[n2])*15.0*cos(decd[n1]*3.141592/180.0))*3600
  deldec=abs(decd[n1]-decd[n2])*3600

  printf,lun,data[n1].obj,data[n2].obj,signra,strtrim(delra,2),signdec,strtrim(deldec,2),$
       format='(a2,2x,"&",a2,2x,"&$",a1,f6.1,"$",2x,"&$",a1,"$",f6.1,"\\")'
 endfor
endfor

for i=stars,stars do begin
 for j=stars+1,nrec-1 do begin
  n1=j
  n2=i
  gcirc,1,rad[n1],decd[n1],rad[n2],decd[n2],dist
  if (rad[n1] gt rad[n2]) then signra='-'
  if (rad[n1] lt rad[n2]) then signra='+'
  if (decd[n1] gt decd[n2]) then signdec='-'
  if (decd[n1] lt decd[n2]) then signdec='+'

  delra=abs((rad[n1]-rad[n2])*15.0*cos(decd[n1]*3.141592/180.0))*3600
  deldec=abs(decd[n1]-decd[n2])*3600

  printf,lun,data[n1].obj,data[n2].obj,signra,strtrim(delra,2),signdec,strtrim(deldec,2),$
       format='(a2,2x,"&",a2,2x,"&$",a1,f6.1,"$",2x,"&$",a1,"$",f6.1,"\\")'
 endfor
endfor
printf,lun,'\tableline',format='(a10)'
printf,lun,'\end{tabular}',format='(a13)'
printf,lun,'\end{table}',format='(a11)'
printf,lun,'\end{document}',format='(a14)'

free_lun,lun

end
