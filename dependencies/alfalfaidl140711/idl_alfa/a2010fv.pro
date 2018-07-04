; Convert from channel number to frequency and velocity for a2010
; based on EGG a2010fv.f
; Translated by Schuyler Smith 6-22-09
; ** NOTE THIS IS ONLY APPROXIMIATE FOR VELOCITIES!

pro a2010fv, channel
	
	restf=1420.405752D
	c=299792.458D
	centerf=1385.0D
	bw=100.0D
	nchans=4096
	deltaf=bw/nchans
	startf=centerf-deltaf*nchans/2.

	freq=startf+channel*deltaf
	z=(restf/freq)-1
	vel=c*z
	print, '    frequency = ', freq, format = '(a,d9.2)'
	print, 'velocity (cz) = ', vel, format = '(a,d9.2)'
	return
	end
