' iso_lower.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that convert ISO 8859-1 characters and strings to lowercase.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201709291507
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn iso_lower%(char%)

  ' Return the lowercase char code of the given ISO 8859-1 char.

  sel on char%
    =65 to 90,192 to 214,216 to 222:\
      ret char%+32
    =remainder:\
      ret char%
  endsel

enddef

deffn iso_lower$(text$)

  ' Return the given ISO 8859-1 text in lowercase.

  loc i%,lower_text$
  let lower_text$=text$
  for i%=1 to len(lower_text$)
    let lower_text$(i%)=chr$(iso_lower%(code(text$(i%))))
  endfor i%
  ret lower_text$

enddef

deffn iso_lower_1$(text$)

  ' Return the given ISO 8859-1 text with the first letter in
  ' lowercase.

  ret iso_lower$(text$(1))&text$(2 to)

enddef

' ==============================================================
' Change log

' 2017-09-19: Start.
'
' 2017-09-27: Update file header.

' vim: filetype=sbim
