; maketilescript.pro
; by Krzysztof Findeisen
; Last modified 10/27/2006
; Generates a tile-recovery FTP script based on the results (in CSV format) of the query in gettiles.gxq

pro maketilescript, infile, outfile

  ; What files we want to extract
  filetypes = ['-nd-intbgsub.fits.gz', '-fd-intbgsub.fits.gz']

  readcol, infile, tilenum, tilename, img, try, subvis, object, format='I,A,I,I,I,A', skipline=1, /silent
  ntiles = n_elements(tilename)
  dirbase  = strarr(ntiles)
  filebase = strarr(ntiles)
  index_sv = where(subvis ge 0, svcount, complement=index_nsv, ncomplement=nsvcount)
  
  ; Find the data
  if(svcount gt 0) then begin
  	dirbase[index_sv] = $
  		replicate('get GR2/pipe/01-vsn/', svcount) + $
  		string(tilenum[index_sv], format='(I5.5)') + $
  		replicate('-', svcount) + $
  		tilename[index_sv] + $
  		replicate('/d/00-visits/', svcount) + $
  		string(img[index_sv], format='(I4.4)') + $
  		replicate('-img/', svcount) + $
  		string(try[index_sv], format='(I2.2)') + $
  		replicate('-try/', svcount)
  	filebase[index_sv] = object[index_sv]
  endif
  if(nsvcount gt 0) then begin
  	dirbase[index_sv] = $
  		replicate('get GR2/pipe/01-vsn/', nsvcount) + $
  		string(tilenum[index_nsv], format='(I5.5)') + $
  		replicate('-', nsvcount) + $
  		tilename[index_nsv] + $
  		replicate('/d/01-main/', nsvcount) + $
  		string(img[index_nsv], format='(I4.4)') + $
  		replicate('-img/', nsvcount) + $
  		string(try[index_nsv], format='(I2.2)') + $
  		replicate('-try/', nsvcount)
  	filebase[index_nsv] = tilename[index_nsv]
  endif

  ; And now for the files themselves
  ntypes = n_elements(filetypes)
  filename = strarr(ntypes, ntiles)
  
  ; I'm pretty sure there's a function that lets you create 2D string arrays 
  ; in which all rows/columns are identical -- I just can't find it  
  ; So I'm stuck with this icky inefficient code
  for i=0, n_elements(filetypes) - 1 do $
  	filename[i,*] = dirbase + filebase + replicate(filetypes[i], ntiles) + ' ' + filebase + replicate(filetypes[i], ntiles)
  filename = reform(filename, ntypes*ntiles, /overwrite)

  openw, filey, outfile, /get_lun
  printf, filey, 'open galex.stsci.edu'
  printf, filey, 'user anonymous webuser'
  printf, filey, 'binary'
  printf, filey, filename
  printf, filey, 'bye'
  close, filey
  free_lun, filey

end
