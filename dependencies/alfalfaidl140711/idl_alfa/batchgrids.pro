pro batchgrids, grids, decs, who

;BK's notes of what grids he has done for Riccardo, Amelie, Ann, and Martha
;grids=['1140','1148','1156','1204','1212','1220','1228','1236','1244','1252','1300']
;grids=['1308','1316','1324','1332','1340','1348']
;grids=['0812','0820','0828','0836']  ;Need to get these maps made!
;grids=['0204','0212','0220','0228','0236']
;grids=['0244','0252','0300']
;0204+25 to 0300+25
;grids=['0844','0852','0900','0908','0916','0924','0932']
;grids=['0940','0948','0956','1004','1012','1020','1028']
;grids=['1036','1044','1052','1100','1108','1116','1124','1132']
;grids=['0100','0108','0116','0124','0132','0140','0148','0156']
;grids=['0100']
;decs=['05']
;decs=['25']
;grids=['0100','0108','0116','0124','0132','0140','0148','0156']
;decs=['29']
;grids=['0804','0756','0748']
;decs=['05']
;grids=['1508','1516','1524','1532','1540','1548']
;grids=['1556','1604','1612','1620','1628']
;decs=['05']
;grids=['2140','2148'];
;grids=['2156','2204','2212']
;grids=['2220','2228','2236']
;grids=['2244','2252','2300']
;grids=['2308','2316','2324','2336']
;decs=['31']




for i=0,n_elements(decs)-1 do begin

    for j=0,n_elements(grids)-1 do begin

        print, grids[j]+'+'+decs[i]

        spawn, 'mkdir '+grids[j]+'+'+decs[i]
        cd, grids[j]+'+'+decs[i]

        grid_prep, /batch, bxcencoords=grids[j]+'+'+decs[i], bxsize=2.4, dgdecmin=1.0, w_fwhm=2.0, gname=grids[j]+'+'+decs[i], who=who;, filename='../posmaster.list'

        cd, '..'

    endfor


endfor



end

