pro srclog
;+
; NAME:
;       SRCLOG
; PURPOSE:
;       Generates log of source files measured from GALFLUX
; EXPLANATION:
;       This is a very simple procdure requested that summarizes a
;       user's findings after measuring galaxy fluxes.  The results
;       and comments are tabulated so the user can cut and paste into
;       their log.  The results can also be viewed in realtime in 10
;       second updates.
;
;       Important - the user needs to run this program from the grid
;                   name directory - ie ../1236+11/  in order for it
;                                    to work!!
;
; CALLING SEQUENCE:
;       SRCLOG
;
; INPUTS:
;       None.
;
; OUTPUTS:
;       Ouptut to screen
;
; NOTES:
;
;
; REVISION HISTORY:
;       Written  B. Kent, Cornell University, June 2006
;       July 14, 2006 - Small mod to add Gaussian Fit StoN
;-


option=''
read, option, prompt='(e)xport or (r)ealtime?:'

count=0

while (1 eq 1) do begin

;Get src files

spawn, 'clear'

for j=0,3 do begin

gridlabel=['a','b','c','d']

spawn,'ls -R src/HI*'+gridlabel[j]+'.src',filelist

print, ''
print, 'Log generated for grid '+gridlabel[j]+': '+strcompress(n_elements(filelist))+' source files'
print, ''

if (filelist[0] ne '') then begin

count=count+n_elements(filelist)


for i=0, n_elements(filelist)-1 do begin

if (filelist[i] ne '') then begin

   restore, filelist[i]

   position=strpos(filelist[i], 'HI')

   agcnr='          '

   if (src.spectra[0].agcnr ne '') then agcnr='AGC'+src.spectra[0].agcnr

   width=src.spectra[0].width[0]

   if (src.spectra[0].width[0] eq 0.0) then width=src.spectra[0].width[3]

   vel=src.spectra[0].vcen[0]

   if (src.spectra[0].vcen[0] eq 0.0) then vel=src.spectra[0].vcen[3]

   stn=src.spectra[0].ston[0]

   if (src.spectra[0].ston[0] eq 0.0) then stn=src.spectra[0].ston[4]


   print, strmid(filelist[i],position, 26),  $
    '  stn  ',string(stn, format='(f5.1)'), $
    '  v',string(long(round(vel)), format='(i7)'), '    w ',$
    string(width, format='(f6.2)'), '  '+string(agcnr,format='(a9)'), $
    ' '+src.comments

endif

endfor

endif

endfor

if (option eq 'e') then begin
    print, ''
    print, '*******************************'
    print, 'Total number of files: ',count
    return
endif else begin
    wait, 10.0
endelse



endwhile



end
