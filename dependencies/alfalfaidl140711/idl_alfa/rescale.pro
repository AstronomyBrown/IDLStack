; RESCALE.PRO
; erscales the continuum fluxes of all the gridbf in the current dir
pro resc

spawn, 'ls gridbf*.sav', files
for i=0, n_elements(files)-1 do begin
  restore, files[i]
  print,files[i]
  grid.cont=1.3*grid.cont
  save,grid,file=files[i]
endfor

end
