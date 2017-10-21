' iso_lower.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that convert ISO 8859-1 characters and strings to lowercase.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710201832
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn iso_lower%(char%)

  ' doc{
  '
  ' iso_lower% (char%)
  '
  ' A function that returns the lowercase character code of the
  ' given ISO 8859-1 charactor ``char%``.
  '
  ' See: `iso_upper%`, `iso_lower$`.
  '
  ' }doc

  sel on char%
    =65 to 90,192 to 214,216 to 222:\
      ret char%+32
    =remainder:\
      ret char%
  endsel

enddef

deffn iso_lower$(text$)

  ' doc{
  '
  ' iso_lower$ (text$)
  '
  ' A function that returns the ISO 8859-1 string ``text$``
  ' in lowercase.
  '
  ' See: `iso_lower_1$`, `iso_upper$`,``iso_lower%`.
  '
  ' }doc

  loc i%,lower_text$
  let lower_text$=text$
  for i%=1 to len(lower_text$)
    let lower_text$(i%)=chr$(iso_lower%(code(text$(i%))))
  endfor i%
  ret lower_text$

enddef

deffn iso_lower_1$(text$)

  ' doc{
  '
  ' iso_lower_1$ (text$)
  '
  ' A function that returns the ISO 8859-1 string ``text$``
  ' with the its character converted to lowercase.
  '
  ' See: `iso_lower$`, `iso_upper_1$`, `iso_lower%`.
  '
  ' }doc

  ret iso_lower$(text$(1))&text$(2 to)

enddef

' ==============================================================
' Change log

' 2017-09-19: Start.
'
' 2017-09-27: Update file header.
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in
' order to build the manual.

' vim: filetype=sbim
