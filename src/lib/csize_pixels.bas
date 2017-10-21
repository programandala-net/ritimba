' csize_pixels.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that convert `csize` parameters to pixels.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710201829
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn csize_width_pixels%(width%)

  ' doc{
  '
  ' csize_width_pixels% (width%)
  '
  ' A function that returns the size in pixels corresponding to
  ' the ``csize`` width ``width%`` (0..3).
  '
  ' See: `csize_height_pixels%`.
  '
  ' }doc

  sel on width%
    =0:ret 6
    =1:ret 8
    =2:ret 12
    =3:ret 16
  endsel
enddef

deffn csize_height_pixels%(height%)

  ' doc{
  '
  ' csize_height_pixels% (height%)
  '
  ' A function that returns the size in pixels corresponding to
  ' the ``csize`` height ``height%`` (0 or 1).
  '
  ' See: `csize_width_pixels%`.
  '
  ' }doc

  ret height%*10+10
enddef

' ==============================================================
' Change log

' 2017-09-28: Start: Code extracted from Ritimba
' (http://programandala.net/es.programa.ritimba.html).
'
' 2017-10-08: Convert to integer.
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in
' order to build the manual.

' vim: filetype=sbim
