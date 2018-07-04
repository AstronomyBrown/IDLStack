pro convert_grid,grid,ngrid

; converts pre-Nov1 grid to new grid (added grid.baseline.rms)

baseline={nbase:grid.baseline.nbase,$
          coeffs:grid.baseline.coeffs,$
          nreg:grid.baseline.nreg,$
          rms:fltarr(2,grid.NX,grid.NY)}

ngrid={name:grid.name, $
      RAmin:grid.ramin, Decmin:grid.decmin, Epoch:grid.epoch, $
      DeltaRA:grid.deltara, DeltaDec:grid.deltadec, $
      NX:grid.NX, NY:grid.NY, $
      map_projection:grid.map_projection, $
      czmin:grid.czmin, $
      NZ:grid.NZ, $
      velarr:grid.velarr, $
      wf_type:grid.wf_type, $
      wf_fwhm:grid.wf_fwhm, $
      han:grid.han, $
      medsubtract:grid.medsubtract, $
      baseline:baseline, $
      calib_facs:grid.calib_facs, $
      grms:grid.grms, $
      date:grid.date, $
      who:grid.who, $
      pos:grid.pos, $
      drift_list:grid.drift_list, $
      grid_makeup:grid.grid_makeup, $
      d:grid.d, $
      w:grid.w, $
      cont:grid.cont,$
      cw:fltarr(2,grid.nx,grid.ny)}

end
