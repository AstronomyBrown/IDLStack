
PRO MAKEDOC, DIR, OUTPUTFILE, OUTTITLE

;+
; NAME: 
;	MAKEDOC
;
; PURPOSE:
;	Uses IDL headers to create an HTML documentation file for a set of IDL .pro files and the procedures/
;	functions contained therein. Calls the IDL intrinsic function mk_html_help.
;
; SYNTAX:
;	MAKEDOC, dir, outputfile, outtitle
;
; INPUTS:
;	dir - string; the directory containing .pro files OR a string array containing the names of individual
;	.pro files
;
; OUTPUTS:
;	outputfile - string; the filename of the HTML output
;	outtitle - string; the title of the HTML output page
;
; EXAMPLES:
;	1. To create a documentation HTML file documentation.html with the title 'EGG IDL'
;	using the .pro files in /home/dorado5/amartin/idl_proc:
;
;	IDL> makedoc,'/home/dorado5/amartin/idl_proc','documentation.html','EGG IDL'
;
;	2. To create a documentation HTML file types.html with the title "Type Conversions'
;	using selected .pro files in the above directory which pertain to type
;	conversions:
;
;	IDL> files=['/home/dorado5/amartin/idl_proc/bsteintorc3.pro','/home/dorado5/amartin/idl_proc/typeesgc.pro']
;	IDL> makedoc,files,'types.html','Type Conversions'
;
;	3. To create a documentation HTML file cart.html with the title "Cartesian'
;	using only the .pro files in the above directory which contain the string
;	'cart':
;
;	IDL> cartfiles=FILE_SEARCH('/home/dorado5/amartin/idl_proc/*cart*.pro')
;	IDL> makedoc,cartfiles,'cart.html','Cartesian'
;
;MODIFICATION HISTORY:
;	A.Martin   June 2006
;-

MK_HTML_HELP,DIR,OUTPUTFILE,TITLE=outtitle

END
