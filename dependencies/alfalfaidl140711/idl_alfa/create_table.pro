;
;Script to stitch together multiple grid files
;
;
;
pro create_table, grids, decs, cont_table_final


;Open the first file as a template
restore, 'cont_'+grids[0]+'+'+decs[0]+'.sav'
cont_table_final=cont_table

cutoffstart=n_elements(cont_table)



for i=0,n_elements(decs)-1 do begin
   for j=0, n_elements(grids)-1 do begin
        restore, 'cont_'+grids[j]+'+'+decs[i]+'.sav'
       cont_table_final=[cont_table_final, cont_table]

   endfor
endfor


print, n_elements(cont_table_final)
;cutout initial starting table
cont_table_final=cont_table_final[cutoffstart:n_elements(cont_table_final)-1]
print, n_elements(cont_table_final)

cont_table_final=cont_table_final[UNIQ(cont_table_final.nvssid, SORT(cont_table_final.nvssid))]


end
