' iso_upper.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that convert ISO 8859-1 characters and strings to uppercase.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710201835
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn iso_upper%(char%)

  ' doc{
  '
  ' iso_upper% (char%)
  '
  ' A function that returns the uppercase character code of the
  ' given ISO 8859-1 charactor ``char%``.
  '
  ' See: `iso_lower%`, `iso_upper$`.
  '
  ' }doc

  sel on char%
    =97 to 122,224 to 246,248 to 254:\
      ret char%-32
    =remainder:\
      ret char%
  endsel

enddef

deffn iso_upper$(text$)

  ' doc{
  '
  ' iso_upper$ (text$)
  '
  ' A function that returns the ISO 8859-1 string ``text$``
  ' in uppercase.
  '
  ' See: `iso_upper_1$`, `iso_lower$`,``iso_upper%`.
  '
  ' }doc

  loc i%,upper_text$
  let upper_text$=text$
  for i%=1 to len(upper_text$)
    let upper_text$(i%)=chr$(iso_upper%(code(text$(i%))))
  endfor i%
  ret upper_text$

enddef

deffn iso_upper_1$(text$)

  ' doc{
  '
  ' iso_upper_1$ (text$)
  '
  ' A function that returns the ISO 8859-1 string ``text$``
  ' with the its character converted to uppercase.
  '
  ' See: `iso_upper$`, `iso_lower_1$`, `iso_upper%`.
  '
  ' }doc

  ret iso_upper$(text$(1))&text$(2 to)

enddef

' ==============================================================
' Change log

' 2017-09-19: Start: Code extracted from Asalto y castigo
' (http://programandala.net/es.programa.asalto_y_castigo.superbasic.html).
'
' 2017-09-27: Update file header.
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in
' order to build the manual.

' vim: filetype=sbim
