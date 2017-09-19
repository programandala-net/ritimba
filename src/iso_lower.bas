rem iso_lower.bas

rem SBASIC functions to convert ISO 8859-1
rem characters and strings to lowercase.

rem Author: Marcos Cruz (programandala.net)

' 2017-09-19: Start.

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

' vim: filetype=sbim
