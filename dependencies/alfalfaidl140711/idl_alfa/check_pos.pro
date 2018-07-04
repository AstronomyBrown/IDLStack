;check_pos.pro 

; to verify that pos file does not contain badbox errors such as
; Subscript range values of the form low:high < 0, > size, with low > high
; rg/17aug09

pro check_pos,pos

ndrifts=n_elements(pos.scannumber)
nproblem=0L

for nd=0,ndrifts-1 do begin
  for nb=0,6 do begin
    for np=0,1 do begin
      for nbox=0,99 do begin
        nlt0=0L
        ind=where(pos[nd].badbox[nbox,np,nb,*] lt 0,nlt0)
        if (pos[nd].badbox[nbox,np,nb,0] gt pos[nd].badbox[nbox,np,nb,2] or pos[nd].badbox[nbox,np,nb,1] gt pos[nd].badbox[nbox,np,nb,3] or $
            pos[nd].badbox[nbox,np,nb,0] gt 4095 or pos[nd].badbox[nbox,np,nb,2] gt 4095 or pos[nd].badbox[nbox,np,nb,1] gt 599 or $
            pos[nd].badbox[nbox,np,nb,3] gt 599 or nlt0 gt 0) then begin
            print,'-----------------------------------------------'
            print, 'Problem at drift: ', pos[nd].name
            print, '     scan number: ', pos[nd].scannumber
            print, '     beam, pol  : ', nb,np
            print, '     box        : ', nbox
            print, ' llx,lly,urx,ury: ', pos[nd].badbox[nbox,np,nb,*], format='(a18,4i6)'
            print, pos[nd].badbox[nbox,np,nb,0],' should be < ', pos[nd].badbox[nbox,np,nb,2], ' and '
            print, pos[nd].badbox[nbox,np,nb,1],' should be < ', pos[nd].badbox[nbox,np,nb,3], ' and '
	    print, '... both the first two should be < 4095, and '
	    print, '    both the latter two should be < 599'
            print, 'Thus, you have a problem here ==> Go correct your pos file.'
            nproblem=nproblem+1
        endif
      endfor
    endfor
  endfor
endfor

if (nproblem eq 0) then print,'pos.badbox passes test on all drifts.'

end
