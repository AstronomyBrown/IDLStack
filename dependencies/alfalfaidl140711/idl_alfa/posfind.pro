;+
; NAME:
;       POSFIND
; PURPOSE:
;       Detemine what pos files and drift files are need to make a map, given an RA, Dec, and 
;	map size
;
; EXPLANATION:
;       Command line program that searched for position and drift files needed to make a map.  
;       The user need only supply a list of position files on their local system with full 
;       path names.  A "master" pos file is created, with a corresponding directory 
;       master listing for each pos entry of the array.  An RA min/max
;       and Dec min/max are input to the 
;       procedure as keywords if desired. The program will return the master
;       pos array, the master directory array, a keyword assigned 
;       string array of the required files with their
;       full paths (filesoutlist), a keyword assigned listing of the
;       pos *FILES* required with their full paths (poslist), and
;       a pos array that contains the elements of those pos files for use with the determined 
;       drift files WITHIN THE SPECIFIED BOUNDARIES (posout).  
;       To create the masterpos and masterdir arrays, the user should invoke 
;       /loadpos.  If this has already been done, the keyword can be left off, and the user 
;       can pass their own masterpos and masterdir arrays previously
;       created by the procedure. The /show keyword will show a plot
;       of the covered area specified and drifts in that area.  The
;       procedure fetchs the most current POSMASTER.LIST from a
;       webserver so the user does not have to pass it. The option is
;       recommended  However, if the user wishes to user their own
;       custom file, they may use the FILENAME keyword with an
;       absolute directory listing of the files they know they require.
;
; CALLING SEQUENCE:
;       posfind, masterpos, $
;       masterdir,ramin=ramin,ramax=ramax, $
;       decmin=decmin,decmax=decmax, poslist=poslist, $
;       posout=posout,filesoutlist=filesoutlist, $
;       loadpos=loadpos, show=show, filename=filename
;
; INPUTS:
;       none
;
;
; OPTIONAL INPUT:
;
;
; OPTIONAL INPUT KEYWORD:
;
;       loadpos - if set, the program will open each pos file in the list, and create a 
;                     masterpos variable and masterdir directory
;                     listing.  
;       filename - ascii text file string name listing of pos files (default is
;                  fetched from a spawned wget command called posmaster.list)
;	ramin, ramax - Right Ascension limits in decimal hours
;       decmin, decmax - Declination limits in decimal degrees
;
; OUTPUTS:
;
;       masterpos - a combined array of structures - one entry for each drift file
;       masterdir - a master directory listing used to locate drift files
;       posoutlist - string array of position files needed for the determined map
;       filesoutlist - string array of drift files need for the determined map
;       posout - only required elements of the pos files needed for the determined map
;
;
; RESTRICTIONS:
;
;	- assumes variables stored in pos files are called either pos
;         or runpos, although runpos is now defunct
;       - reqruies TVBOXBK procedure
;
;
; EXAMPLE:
;  This will load the posmaster.list and show the region with drift coverage:
;    posfind, masterpos, masterdir, ramin=5,ramax=6, decmin=10,decmax=12, poslist=poslist,
;    posout=postout, filesoutlist=filesoutlist, /loadpos, /show
;
;  This is how posfind is called by grid_prep:
;    grid_prep, masterpos, masterdir, /loadpos
;
;  This is how one would use their own custom file, without displaying
;  anything:
;    posfind, masterpos, masterdir, ramin=5,ramax=6, decmin=10,decmax=12, posoutlist, posout,filesoutlist, $
;              /loadpos, filename='my_own_pos.list'
;
; MODIFICATION HISTORY:
;	WRITTEN, Brian Kent, Cornell U., August 15, 2005
;       Last update, November 9, 2005
;
;       Sept. 27, 2005 - simplified to work with grid_prep - BK
;         output can still be used, but it often uses fewer drifts
;         than grid_prep, as grid_prep uses the defined boundary plus
;         "a little more".  Now the master pos and master directory
;         listing are returned only. BK will update this in the future                                                    
;                                                        
;      November 4, 2005 - B. Kent - Major overhaul to work standalone
;                         and with the gridding routines.
;      November 9, 2005 - Comments/instructions updated and sent out.
;   ------------------------------------------------------------------------

pro posfind, masterpos, masterdir,ramin=ramin,ramax=ramax, $ 
             decmin=decmin, decmax=decmax, poslist=poslist, $ 
             posout=posout, filesoutlist=filesoutlist, $
             loadpos=loadpos, show=show, filename=filename, gridname=gridname


;KEYWORD AND PARAMETER CHECK

if (n_params() ne 2) then begin
    message, 'USAGE: posfind, masterpos, masterdir'
    return
endif

problemflag=1


;Part one of procedure generates masterpos and masterdir

;Load the file with the pos files.  This is quick, and is still needed
;to know the names of the posfiles for later output to the poslist
;variable.  You must always provide the file name of the list you are
;using, unless you are using the default wget to fetch the posmaster.list

   if (n_elements(filename) eq 0) then begin
      url='http://caborojo.astro.cornell.edu/alfalfalog/posmaster.list'
        
      print, ' '
      print, 'Obtaining latest list... '
      print, ' '

      spawn, 'wget -q -O posmaster.list ' + "'" + url + "'"

      filename='posmaster.list'
      fileflag=1
   endif else begin
      fileflag=0
   endelse

   ;Open list of files to process, place file names in string array
        print, ''
        print, 'Opening List of files from '+filename
        print, ''

        openr,lun,filename,/get_lun
        maxfiles=10000L
        templist=strarr(maxfiles)
        ifound=0L
        on_ioerror,done
       
        while (1) do begin
          inpline=''
          readf,lun,inpline
          strar=strsplit(inpline,' ',/extract)
          templist[ifound]=strtrim(strar[0],2)
          ifound=ifound+1
        end
        done:
        close, lun
        free_lun,lun

   print, ''
   print, templist[0]   ;Informs user of last update
   print, ''
        
   posfilelist=templist[1:ifound-1]  ; trim list to number of files found
	


   print, n_elements(posfilelist), ' files in list'

   posdir=strarr(n_elements(posfilelist))
   posfiles=strarr(n_elements(posfilelist))

   for i=0, n_elements(posfilelist)-1 do begin

      position=strpos(posfilelist[i], 'pos_')
      length=position
      posdir[i]=strmid(posfilelist[i],0,length)
      posfiles[i]=strmid(posfilelist[i],position)

  endfor







   ;If wget used to get default, then file not needed anymore, so remove
if (n_elements(fileflag) eq 1) then spawn, '/bin/rm -r posmaster.list'

;--------------------------------------------------------------------

;Load the pos files, create and append to the masterdir and masterpos arrays


if keyword_set(loadpos) then begin

   ;;;;;;;;;   OPEN FILES    ;;;;;;;;
   print, 'Creating master pos array...'

   ;Open first for a template

   on_ioerror, problem

   ;Determine if pos or runpos variable is used
   ;   for the template
   pos={name:''}
   runpos={name:''}
   
   restore, posfilelist[0]

   if (pos[0].name eq '') then begin
       pos=runpos
       delvarx, runpos
   endif else begin 
       delvarx, runpos
   endelse

   masterpos=pos
   masterdir=strarr(n_elements(pos))
   masterdir[*]=posdir[0]
   cutoff=n_elements(masterpos)
 

   print, 'Cutoff at: ', cutoff

;;;Now that template is set, go through and append all files and
;;;directories to the masterpos.  Then trim off the template at the 
;;;beginning of the array.

   for i=0, n_elements(posfilelist)-1 do begin

                                ;determine if pos file needs to be
                                ;opened based on declination and
                                ;spring/fall

       

       ra=ramin
       if (ra ge 6.0 AND ra le 17.0) then grid_sessionname='s'
       if ((ra le 5 AND ra ge 0.0) OR (ra ge 21.0 AND ra le 24.0)) then grid_sessionname='f'

       ;print, posfilelist[i]

       position=strpos(posfilelist[i], '.sav')
       sessionname=strmid(posfilelist[i],position-1, 1)
       ;print, sessionname

       ;print, posfilelist[i], sessionname, grid_sessionname
       
       decstring=strmid(posfilelist[i],position-8, 7)
       ;print, decstring
       filedec=dms1_deg(float(decstring))

       ;print, posfilelist[i], abs(filedec-decmin)

       if ((sessionname eq grid_sessionname) AND (abs(filedec-decmin) le 3.5)) then begin

           ;print, posfilelist[i]

   ;Determine if pos or runpos variable is used
      pos={name:''}
      runpos={name:''}

      print, 'Opening '+posfilelist[i]
   
      restore, posfilelist[i]
   
      if (pos[0].name eq '') then begin
          pos=runpos
          delvarx, runpos
      endif else begin
          delvarx, runpos
      endelse

      masterpos=[masterpos, pos]

      masterdirtemp=strarr(n_elements(pos))
      masterdirtemp[*]=posdir[i]
      masterdir=[masterdir, masterdirtemp]

  endif



  endfor


   masterpos=masterpos[cutoff:n_elements(masterpos)-1]
   masterdir=masterdir[cutoff:n_elements(masterdir)-1]

   problemflag=0

endif

;-------------------------------------------------------------------


;Second part of procedure searches for requried drifts if coordinates
;are specified as keywords.  This part is not invoked by the gridding
;procedures.  All keywords need to be specified.

if (n_elements(ramin) ne 0 AND $
    n_elements(ramax) ne 0 AND $
    n_elements(decmin) ne 0 AND $
    n_elements(decmin) ne 0) then begin    

problemflag=0

   ;Setup to find required pos files

   print, ''
   print, 'RA:'+strcompress(ramin)+' to '+strcompress(ramax)
   print, 'Dec:'+strcompress(decmin)+' to '+strcompress(decmax)
   print, ''

   posflag=intarr(n_elements(masterpos))

   for i=0, n_elements(masterpos)-1 do begin

      foundindex=where(((masterpos[i].rahr le ramax AND $
                         masterpos[i].rahr ge ramin)) AND $
       ((masterpos[i].decdeg le decmax AND masterpos[i].decdeg ge decmin)))

      if (foundindex[0] ne -1) then posflag[i]=1

   endfor

   posindex=where(posflag eq 1)
   print, 'Indices found: ', posindex

   ;;;Initialize output variables
   filesoutlist=strarr(n_elements(posindex))
   poslist=strarr(n_elements(posindex))
   posout=masterpos  ;;Better way to do this?  Just need a pos type template anyway, then cutoff 
                  ;;  the excess 


   if keyword_set(show) then begin

      window, /free, retain=2, xsize=800, ysize=800
      hor, ramax+1.0/15.0, ramin-1.0/15.0
      ver, decmin-1.0, decmax+1.0

      device, decomposed=1
      plot, [0,0],[0,0], /nodata, $
        xtitle='RA [Hrs]', ytitle='Dec [Deg]', $
        title='Map center at RA: '+$
        strcompress((ramin+ramax)/2.0)+$
        ', Dec: '+strcompress((decmin+decmax)/2.0), $
        charsize=1.4

      tvboxbk, [ramax-ramin, decmax-decmin], $
       ramin+(ramax-ramin)/2.0, decmin+(decmax-decmin)/2.0, $ 
       /data, color='0000FF'XL

      device, decomposed=0

   hor
   ver

   response=tvread(filename='skycov_'+gridname, /JPEG, quality=100, /nodialog)
   spawn, 'convert skycov_'+gridname+'.jpg skycov_'+gridname+'.gif'
   wdelete
   spawn, '/bin/rm -r skycov_'+bxcencoords+'.jpg'

   print, ' '
   print, 'Sky coverage map saved to disk.'
   print, ' '

endif


filecount=0

for i=0, n_elements(masterpos)-1 do begin
       
   if (posflag[i] eq 1) then begin
     if (keyword_set(show)) then begin
          device, decomposed=1
          for j=0, 6 do $
           oplot, masterpos[i].rahr[*,j], masterpos[i].decdeg[*,j], color='00FF00'XL,  psym=3;GREEN
           device, decomposed=0
     endif
     filesoutlist[filecount]=masterdir[i]+masterpos[i].name
     poslist[filecount]=masterdir[i]+posfiles[where (posdir eq masterdir[i])]
     posout[filecount]=masterpos[i]
     filecount++
   endif

endfor


print, 'Required driftfiles:'
print, filesoutlist



;;;;; Trim the posout for duplicates

poslist=poslist[rem_dup(poslist)]
print, 'Required position files:'
print, poslist
print, ''

posout=posout[0:filecount-1]

endif


problem:

if (problemflag eq 1) then begin
   print, 'There was a problem with the last file or you did not use '
   print, '  the correct command line input.  Please check your list of files.'
endif 

end
