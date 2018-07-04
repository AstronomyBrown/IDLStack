;Sample batch script for running many grids in succession
;Example:
; IDL> @alfinit
; IDL> .com cont_find.pro
; IDL> .com cont_script.pro
; IDL> restore, '/home/dorado3/galaxy/idl_alfa/nvsscat_alfalfa.sav'
; IDL> cont_script, nvsscat, ['1220','1228','1236'], ['09','11'], '/home/arecibo2/galaxy/grids/'

pro cont_script, nvsscat, grids, decs, dir


for i=0,n_elements(decs)-1 do begin

   for j=0,n_elements(grids)-1 do begin

       print, grids[j]+'+'+decs[i]

       check=file_search(dir+grids[j]+'+'+decs[i]+'/gridbf_'+grids[j]+'+'+decs[i]+'b.sav')

       if (check ne '') then begin
           restore, dir+grids[j]+'+'+decs[i]+'/gridbf_'+grids[j]+'+'+decs[i]+'b.sav'
           cont_find, grid, nvsscat, cont_table
           save, cont_table, filename='cont_'+grids[j]+'+'+decs[i]+'.sav'
       endif

       if (check eq '') then begin
           restore, dir+grids[j]+'+'+decs[i]+'/grid_'+grids[j]+'+'+decs[i]+'b.sav'
           cont_find, grid, nvsscat, cont_table
           save, cont_table, filename='cont_'+grids[j]+'+'+decs[i]+'.sav'

       endif


   endfor



endfor


end
