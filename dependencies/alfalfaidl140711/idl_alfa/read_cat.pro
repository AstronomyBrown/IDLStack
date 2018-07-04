; read a formatted source catalog and output contents within a structure
; array named "set"
; cat is the source catalog file name (can be hardwired in program) 
; assumes the first 3 records are text

pro read_cat,set,cat=cat

;catdir='/home/utuado2/riccardo/grids/cats/'
catdir=''
if (n_elements(cat) ne 0) then begin
  cat=cat
endif else begin
  cat='ll.cat_4'
endelse
filename=catdir+cat
openr,lun,filename,/get_lun
maxrec=10000L

record={HIsrc:'',agcnr:'',other:'',hra:0.D,hdec:0L,dra:0L,ddec:0L,$
        ora:0.D,odec:0L,hsize:0.,cz:0L,czerr:0L,w:0L,Werr:0L,$
        Sspec:0.,Specerr:0.,Smap:0.,SN:0.,rms:0.,code:0L,grid:'',extra:''}
nrecords=0L
dummy=''
;print, 'here' 
for i=0,2 do begin
  readf,lun,dummy,format='(a1)'
endfor
while(eof(lun) ne 1) do begin
  readf,lun,record,format='(a17,1x,a6,1x,a8,2x,f8.2,i7,2i4,f10.1,i7,f7.1,i6,i5,i6,i5,f8.2,f6.2,f8.2,f7.1,f6.2,i4,1x,a7,a2)'
  nrecords=nrecords+1
  if (nrecords eq 1) then begin
    set=record
  endif else begin
    set=[set,record]
  endelse
endwhile

free_lun,lun 

end
