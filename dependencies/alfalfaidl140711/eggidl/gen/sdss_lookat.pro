
PRO sdss_lookat, agc, line

	; Load the user settings or set the defaults
	common inspectdata, opt, showALL
	if n_elements(opt) eq 0 then begin
		opt = 'GLIS'
		showALL = 0
	endif

	format =    '(I6,37x,A3,21x,I18,3x,I18,1x,I3,1x,I3,1x,I3,1x,I3,1x,I3)'
;	formatpar = '(I6,37x,A3,21x,I18,3x,I18,8x)'
	line = ''

	sdss_markup, agc, galaxy, child, specID
	zeroed = dblarr(n_elements(child))

	done = 0
	redraw = 0
	rewrite = 1
	specZeroed = 0
	while not(done) do begin

		if (redraw) then sdss_markup, agc, galaxy, child, specID
		if (rewrite) then sdss_totallight, agc, galaxy, child, specID, zeroed
		if (specZeroed eq 1) then specID = 0
		redraw = 1

		command = ''
		read, command
		command = strlowcase(command)

		if command eq 'ns' then begin
			specID = 0
			specZeroed = 1
;			print, 'Best Spectroscopic ID: 0'
			redraw = 0
			rewrite = 1

		; User says this is the only viable object
		endif else if command eq 'oly' then begin
			line = string(agc, 'oly', child[0].phot, specID, child[0].ulight, child[0].glight, $
				child[0].rlight, child[0].ilight, child[0].zlight, format=format)
			return

		; User chooses PARENT id
		endif else if command eq 'p' or command eq 'par' then begin
			line = string(agc, 'par', galaxy[0].phot, specID, galaxy[0].ulight, galaxy[0].glight, $
				galaxy[0].rlight, galaxy[0].ilight, galaxy[0].zlight, format=format)
			return

		; User chooses the brightest child
		endif else if command eq '1' then begin
			line = string(agc, '1  ', child[0].phot, specID, child[0].ulight, child[0].glight, $
				child[0].rlight, child[0].ilight, child[0].zlight, format=format)
			return

		; User chooses the 2nd brightest child as brightest
		endif else if command eq '2' then begin
			line = string(agc, '2  ', child[1].phot, specID, child[1].ulight, child[1].glight, $
				child[1].rlight, child[1].ilight, child[1].zlight, format=format)
			return

		; User chooses the 3rd brightest child as brightest
		endif else if command eq '3' then begin
			line = string(agc, '3  ', child[1].phot, specID, child[1].ulight, child[1].glight, $
				child[1].rlight, child[1].ilight, child[1].zlight, format=format)
			return

		; User says there is a problem
		endif else if command eq 'pb' then begin
			val=0
			read, prompt='Enter child: 1,2,3 ? ',val
			val -=1

			line = string(agc, 'pb ', child[val].phot, specID, child[val].ulight, child[val].glight, $
				child[val].rlight, child[val].ilight, child[val].zlight, format=format)
			return

		endif else if command eq '?' then begin
			line = string(agc, format='(I6," ?",80x)')

		; User wants to change the SDSS options
		endif else if strmid(command,0,1) eq 'o' then begin
			opt = strupcase(strmid(command,1))

		; User toggles whether all are shown or not
		endif else if command eq 'a' then begin
			showALL = not(showALL)

		; User wants to open up SDSS 'explore' tool
		endif else if strmid(command,0,1) eq 'e' then begin
			which = strmid(command,1)

			if which eq 'p' then id = galaxy[0].phot
			if which eq '1' then id = galaxy[1].phot
			if which eq '2' then id = galaxy[2].phot
			if which eq '3' then id = galaxy[3].phot

			spawn, "firefox 'http://cas.sdss.org/astro/en/tools/explore/obj.asp?id="+strtrim(id,2)+"'"
			redraw = 0
		endif else if strmid(command,0,1) eq 'x' then begin
			which = fix(strmid(command,1))-1
			zeroed[which] = 1
			rewrite = 1
			redraw  = 0

		endif else if command eq 'h' or command eq 'help' then begin
			openr, readme, '/home/hatillo/ghallenbeck/sdss-check/sdss_inspect.readme', /get_lun
			line = ''

			while not(eof(readme)) do begin
				readf, readme, line
				print, line
			endwhile
			rewrite = 0
			redraw  = 0
			close, readme, /force
		endif

	endwhile

END
