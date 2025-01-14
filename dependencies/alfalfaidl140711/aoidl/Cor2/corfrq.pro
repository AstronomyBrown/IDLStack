;+
;NAME:
;corfrq - compute the freq/vel array for a spectra
;
;SYNTAX:  retArr=corfrq(hdr,retvel=retvel,retrest=retrest)
;
;ARGS:  
;         hdr: header for this board
;
;KEYWORDS:
;         retvel : if not equal to zero, then return velocity rather 
;                   than frequency array
;         retrest: if not equal to zero, then return the rest frequency
;                  for the object being observered rather than the 
;                  topocentric frequency.
;
;RETURNS:
;           retArr: Array of floating point frequencies or velocities.
;              
;DESCRIPTION:
;
;   Compute the topocentric frequency array (in Mhz) for the correlator board
; corresponding to the header (hdr) passed in. If the keyword retvel 
; is set (not equal to zero) then return the velocity (optical definition).
; If the keyword retrest is set, then return the rest frequency of the object
; rather than the topocentric frequency.
; The array returned (retArr) will have the same number of elements
; as a single output sub correlator. 
;
;   The order of the data  assumes that the spectral channels are in
; increasing frequency order (corget always returns the data this way).
; If the spectra are spDat[2048] and then retAr[0] will be the lowest
; frequecy or the highest velocity.
;
;EXAMPLE:
;   .. assume 2 boards used, pola,b per board
;   corget,lun,b
;   frqArr=corfrq(b.b1.h)
;   frqArrRest=corfrq(b.b1.h,/rest)
;   velArr=corfrq(b.b1.h,/retvel)
;   plot,frqArr,b.b1.d[*,0] 
;-
;history:
;31jun00 - updated to new corget format
;02jun00 - fixed velocity computation. for rfonly, need band center
;          rest frequency, no rest frequency of center of topocentric band.
;02jaug01- vel definition was backwards.
;was:  vel= c*(f/f0 - 1.) + obserVelProjected.. optical definition
;      if retvel ne 0 then x= c*(1.D - x/cfrRestMhz) + h.dop.velObsProj;
;new:  vel= c*(f0/f - 1.) + obserVelProjected.. optical definition
;       if retvel ne 0 then x= c*(cfrRestMhz/x -1.D) + h.dop.velObsProj;
;18jun04- <pjp001>fixed projected observer velocity to work in the relativistic
;         case (thanks to chris salter...)
;11aug04- switched to use corhflippedh
;13nov04- if bwnum == 0 assume it's 100 Mhz
;   
function corfrq,h,retvel=retvel,retrest=retrest
    forward_function dophsbal
    on_error,1
    if (n_elements(retvel) eq 0) then retvel=0 ;return vel or freq
    if (n_elements(retrest) eq 0) then retrest=0 ;return rest freq
;
    nchan  =h.cor.lagSbcOut         ; number of channels
    brdInd =h.std.grpCurRec -1      ; for synth offsets..index to use...
	if brdInd ge 4 then brdInd = 0  ; for was data. use first board
    binWd  = (h.cor.bwnum eq 0L)? 100.D/h.cor.lagSbcOut :$
		   50.D/(ishft(1,h.cor.bwnum-1)*h.cor.lagSbcOut); binwidth Mhz
    c      =299792.458D             ; definition of c...
;
;   center (counting from zero is):
;          n/2   if no flip
;          n/2-1 if we flipped the band to get increasing freq order
;
   	cenChan= nchan/2 - corhflippedh(h,brdInd+1)
;
;   there are 2 ways we doppler shift:
;   1- each board .. eg.oh experiment at 1612,1665,1667.. you doppler
;                    shift using the rest freq of each line
;   2- just the center Rest freq .. eq  making a 100mhz filter bank
;                    out of 4 25mhz bands. You want the bands to 
;                    be contiguous in the topocentric system.
;
;   The headers have a Band center rest frequency and  4 offsets.  
;   If 1. is used, then the offsets are added to the BCRestFrq and then
;         each is doppler shifted.
;   If 2. is  used, then the BCRestFrq is doppler shifted, and then the
;         offsets are added in the topocentric system.
;
;       dopcorrect all
;
    if ( dophsball(h.dop) ) then begin ; doppler correct all sub bands
        cfrRestMhz= h.dop.freqBCRest + h.dop.freqOffsets[brdInd] 
        cfrTopMhz = cfrRestMhz*h.dop.factor     ; to topocentric
    endif else begin
;
;       dopcorrect rf only
;
        cfrTopMhz = h.dop.freqBCRest*h.dop.factor + h.dop.freqOffsets[brdInd] 
;;      cfrRestMhz= cfrTopMhz/h.dop.factor      ; go back to cfr rest frame
        cfrRestMhz= h.dop.freqBCRest            ; for velocity computation
    endelse

;
    if retrest ne 0 then begin
       x= (findgen(h.cor.lagSbcOut) - cenChan)*binWd  + cfrRestMhz
    endif else begin
       x= (findgen(h.cor.lagSbcOut) - cenChan)*binWd  + cfrTopMhz
;	 <pjp001> below 
       xvelCrd=x*(1.0 - (h.dop.velobsproj/c))
;   if They want velocity..
;   vel= c*(f0/f - 1.) + obserVelProjected.. optical definition
       if retvel ne 0 then x= c*(cfrRestMhz/xvelCrd -1.D)
    endelse
;
    return,x
end
