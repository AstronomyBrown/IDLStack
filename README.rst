Abstract
~~~~~~~~
This documentation attempts to provide a friendly guide to start using IDLstack, 
a utility for stacking `ALFALFA <http://egg.astro.cornell.edu/index.php/>` 
atomic hydrogen 21 cm spectra from galaxies. 

If you are reading this page in plain text, open 'docs_html/index.html' to view full 
documentation webpage.

The current version was written by Toby Brown and is based upon the routines 
developed by Silvia Fabello.

More information on the stacking technique, its advantages and disadvantages 
is available in Section 3 of `Brown et al. 2015 <http://adsabs.harvard.edu/abs/2015MNRAS.452.2479B>`.


Introduction
------------
IDLstack is consists of three programs to be run in order, they are as follows:

	1. `aa_stack.pro <aa_stack.html>`
		- Bins and stacks the ALFALFA spectra according to a user defined input file.
	
	2. `aa_measure.pro <aa_measure.html>`
		- Reduces and measures stacked spectrum. To be run after aa_stack.pro.
	
	3. `aa_dagjk.pro <aa_dagjk.html>`
		- Calculates the Delete-a-Group Jackknife error on the stacked spectrum measurement. 
		To be run after aa_measure.pro.

Installation
------------

To install IDLstack:: 
	
	1. Unzip and place the IDLstack 'src/' directory in your IDL path. 

	2. Make a copy of the template configuration file 'inputexample.cfg'

	2. Edit the 'path' variable in your new configuration file to point
		to the directory containing ALFALFA HI spectra (see Requirements).

Warnings:  It is not advisable to separate the contents of the distribution; the code looks for resource files in locations relative to itself. Also, don't add the whole IDLstack directory to your IDL path as the 'doc_html' directory contains copies of the original source code.

Basics
------

The basic calling sequence for IDLstack routines specifies the path to either an input configuration file
(`aa_stack.pro <aa_stack.html>`) or the output stack directory (`aa_measure.pro <aa_measure.html>` and `aa_dagjk.pro <aa_dagjk.html>`)::

    IDL> aa_stack, cfgfile='path/to/cfigfile'

    IDL> aa_measure, stackingdir='path/to/stacks'

    IDL> aa_dagjk, stackingdir='path/to/stacks'

Requirements
------------

1. Parameter input file - aa_stack.pro requires users to specify a path to the input configuration file. 
This file allows the user to tweek the stacking-related parameters, such as directories, 
sample catalogues, binning properties and data specific parameters. 
There is a a template config file provided with this distribution ('inputexample.cfg').

2. ALFALFA HI spectra - As of 2017, raw ALFALFA data is proprietary. Therefore it is assumed the user already 
has access to raw HI spectra saved into IDL structures. Any deviation from the naming convection 'ID_specno.src'
will require edits to `aa_stack.pro <aa_stack.html>` and `aa_dagjk.pro <aa_dagjk.html>`.

3. master_sample.fits - IDLstack requires an SDSS master sample (e.g. `Brown et al. 2015 <http://adsabs.harvard.edu/abs/2015MNRAS.452.2479B>`) in .fits format with an ID convention that corresponds to the ALFALFA spectra file names. An example fits file is given with this distribution ('master_sample.fits')


:Author:
   Toby Brown

