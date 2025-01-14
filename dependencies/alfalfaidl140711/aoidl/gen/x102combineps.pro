;+ 
;NAME:
;x102combineps - combine x102 ps files into 1 file.
;SYNTAX: x102combineps(m,fdscript,psdir)
;  ARGS:   m[]  : string array of filenames of a particular plot type to 
;                 combine.
;         fd    : int .. script file to write to
;       psdir   : string.. directory to hold the combined postscript files
;DESCRIPTION:
;   The mueller2.idl routine for x102 calibration creates a large number of 
;postscript files. For receivers with multiple frequencies it will create 
;1 separate file for each board or frequency. This routine will create a 
;csh file that will combine the N frequencies from a particular receiver into
;a ps file with N pages (1 for each frequency).
;To use:
;   1. go to the directory that has the postscript files.
;   2. in idl create a string array that has the plot type of the plots 
;      to combine:
;      eg:
;         m4=spawn,'ls lbn*m4*'
;   2. open the script file that will hold the commands to combine the files
;         openw,lun,'combineps.sc',/get_lun
;      When done you will execute this file in the shell to do the combination.
;   3. decide on an output directory where you want the combined ps files 
;      written.
;      x102combineps,lun,'dirpath') 
;      free_lun,lun
;   4. get out of idl, look at the file to make sure it is ok.
;      change the mode to executable, chmod +x combineps.sc
;      and then execute it.. combineps.sc
;
;The filenames look like:
;lbn_1300_bd0_B0035+130_m4_22-APR-2001.ps
; The routine strips off the first 3 sections to have:
;   B0035+130_m4_22-APR-2001.ps
;
;It gathers together all of the files that have this base filename. For each of
;these sets it sorts the full name  by the second section _1300_ 
;(the frequency).
;The outputfile it chooses is:
;lbn_all_B0035+130_m4_22-APR-2001.ps where B0035+130_m4_22-APR-2001.ps is the
;base name. The script file will then look like:
; psidlmerge -o psdir/lbn_all_B0035+130_m4_22-APR-2001.ps \
;  then a list of all frequencies for this source..
;
;The script psidlmerge is in ~phil/Solaris/bin..
;-
pro x102combineps,m,fd,outdir

    outdirloc=outdir
    if (strmid(outdir,0,1,/reverse) ne '/') then outdirloc=outdirloc + '/'
    if not keyword_set(mergeprog) then mergeprog='psidlmerge'
    n=n_elements(m)
    mn=strarr(n)
;
; get the frequency/board independant part of the name in mn
;
    for i=0,n-1 do begin 
        a=stregex(m[i],'bd[0-3]_(.*)',/EXTRACT,/sub)
        mn[i]=a[1]
;        mn[i]=stregex(m[i],'[JB].*',/EXTRACT)
    endfor
;
; get unique source by day
;
    indsrc=uniq(mn,sort(mn))
    nsrc=n_elements(indsrc)
;
; loop thru each unique source/file
;
    for i=0,nsrc-1 do begin
        ind=where(mn eq mn[indsrc[i]])
        src=m[ind]
;
;       figure out freq order to sort by freq
;
        nfrq=n_elements(src)
        freqAr=fltarr(nfrq)
        for j=0,nfrq-1 do begin 
            freq=stregex(src[j],'_([0-9]+)_',/EXTRACT,/sub) 
            freqAr[j]=freq[1] 
        endfor
        indfreq=sort(freqAr)
;
;       get the rcvr name
;
        a=stregex(m[ind[0]],'^([a-zA-Z0-9]+)_',/extract,/sub)
        outname= a[1] + '_all_'+ mn[ind[0]]
;;      print,a,outname
;
;       loop output data to file
;
        printf,fd,mergeProg + ' -o '+ outdirloc + outname + '\'
        atend='\'
        for j=0,nfrq-1 do begin
            if j eq nfrq-1 then atend=''
            printf,fd,'  ',src[indfreq[j]],atend
        endfor
    endfor
    return
end
