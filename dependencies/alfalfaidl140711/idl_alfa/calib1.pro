;+
; NAME:
;       CALIB1
; PURPOSE:
;       Sort matched sets of noise calibration events    
;
; EXPLANATION:
;       Calib1 takes a list of files provided in an ASCII text file and matches
;         on/off pairs into two arrays, dCalON, and dCalOFF.  Specifically used
; 	  with ALFALFA observing program, and requires a list of files in sequence.
;         On/Off pairs are copied directly to the dCalON and dCalOFF arrays, respectively
;	  Ending and Beginning records from adjacent drift scans are averaged to
;         a caloff, and matched with a calon fired between drift scans
;       
;
; CALLING SEQUENCE:
;       calib1, CALlistfilename, dCalON, dCalOF
;
; INPUTS:
;      CALlistfilename - string - name of file for list of files of on/off pairs, 
;and beginning and ending records of FIXEDAX drift scans
;
;       
; OPTIONAL INPUT:
;      
;
; OPTIONAL INPUT KEYWORD:
;    
;
; OUTPUTS:
;         dCalON - array of "d" structures for CAL on records
;         dCalOFF - array of "d" structures for CAL off records
;       
;
; RESTRICTIONS:
;        Assumes that scans are sequential, for example:
;          Con/Coff Con/Coff Con/Coff Con/Coff Con/Coff ...Drift...   Con ...Drift... Con
;               ...Drift... Con/Coff Con/Coff Con/Coff Con/Coff Con/Coff
;
; EXAMPLE:
;       Open a CALlist ASCII text file list
;
;       IDL> filein='wapp.20040923.a1946.0002.fits.CALlist'
;	IDL> calib1, filein, dCalON, dCalOF
;	
;
; PROCEDURES USED:
;       
;
; MODIFICATION HISTORY:
;       WRITTEN, B. Kent, Cornell U.,  January 12, 2005
;       Feb 04, 2005 - Modification to allow for any combination of calibration pairs  
;-



pro calib1, CALlistfilename, dCalON, dCalOF,dir=dir

;	if (n_params() ne 3) then message, 'Usage: calib1, CALlist, dCalON, dCalOF'
        if (n_elements(dir) eq 0) then dir=''

	openr,lun,CALlistfilename,/get_lun

	maxfiles=300
	
        CALlist=strarr(maxfiles)
        ifound=0L
        on_ioerror,done
; from Phil Perillat's a1705 Leo script
        
	while (1) do begin
	  inpline=''
  	  readf,lun,inpline
	  strar=strsplit(inpline,' ',/extract)
          if (dir eq '') then begin
         	  CALlist[ifound]=strtrim(strar[0],2)
          endif else begin
                  CALlist[ifound]=dir+"/"+strtrim(strar[0],2)
          endelse
	  ifound=ifound+1
        end
	done:
	close, lun
	free_lun,lun
	CALlist=CALlist[0:ifound-1]

	ifile=0
;	calofbeginflag=1  ;if set to 1 then skip the first begin
  
;Initial start of the dCALON and dCALOF arrays with first file
; - will be concatenated off in the end

        restore, CALlist[0]
	dCalON=d
	restore, CALlist[0]
	dCalOF=d

;print, n_elements(dCalOF)

;wait, 1.0
	ifile=0
        
;Go through list of files - match on off pairs and end/Cal/begin triplets,
; averaging the end/begin pairs into a CALoff



	repeat begin
        
           if (strmatch(CALlist[ifile], '*CALON.sav', /FOLD_CASE)) then CALID='CALON'
;	   if (strmatch(CALlist[ifile], '*CALOF.sav', /FOLD_CASE)) then CALID='CALOF'
	   if (strmatch(CALlist[ifile], '*CALOFbegin.sav', /FOLD_CASE)) then CALID='CALOFbegin'
	   if (strmatch(CALlist[ifile], '*CALOFend.sav', /FOLD_CASE)) then CALID='CALOFend'

           if (ifile eq n_elements(CALlist)-1) then goto, endoffile


	   case CALID of
	   
            'CALON': begin
		     restore, CALlist[ifile]
		     dCalON=[[dCalON],[d]]
		     
		     restore, CALlist[ifile+1]
		     dCalOF=[[dCalOF],[d]]
		     ifile+=2
		    end

	   'CALOFend': begin
                     if (ifile+2 gt ifound-1) then goto, endoffile 

                     if (strmatch(CALlist[ifile+2], '*CALOF.sav', /FOLD_CASE)) then begin
                       ifile+=1
                     endif else begin
                       restore, CALlist[ifile]
		       calofend=d
		       restore, CALlist[ifile+2]
                       calofbegin=d
		       temp=calofend
	               temp[*,0,*].d=(calofend[*,0,*].d+calofbegin[*,0,*].d)/2.0
		       dCalOF=[[dCalOF],[temp]]

		       restore, CALlist[ifile+1]
		       dCalON=[[dCalON],[d]]
  			
		       ifile+=3
                     endelse

	               end
            
;	   'CALOF' : ifile+=1
	   'CALOFbegin' : begin
		     if (strmatch(CALlist[ifile+3], '*CALOF.sav', /FOLD_CASE)) then begin
			ifile+=2
		     endif

		     if (strmatch(CALlist[ifile+1], '*CALOFend.sav', /FOLD_CASE)) then ifile+=1
                    
;                       ifile+=1
			  end    

	   endcase

;print, ifile, n_elements(dCalON)

       endrep until (ifile gt ifound-1)

endoffile:
dCalON=dCalON[*,1:n_elements(dCalON[0,*,0])-1,*]
dCalOF=dCalOF[*,1:n_elements(dCalOF[0,*,0])-1,*]
end
