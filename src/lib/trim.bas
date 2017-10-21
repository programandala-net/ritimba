' trim.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions to trim strings.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710201923
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn trim_right$(txt$)

  ' doc{
  '
  ' trim_right$ (txt$)
  '
  ' A function that returns ``txt$`` without traling spaces.
  '
  ' See: `trim_left$`, `trim$`.
  '
  ' }doc

  loc last%
  rep trim
    let last%=len(txt$)
    if not last%:\
      exit trim
    if txt$(last%)=" "
      let txt$=txt$(1 to last%-1)
    else
      exit trim
    endif
  endrep trim
  ret txt$

enddef

deffn trim_left$(txt$)

  ' doc{
  '
  ' trim_left$ (txt$)
  '
  ' A function that returns ``txt$`` without leading spaces.
  '
  ' See: `trim_right$`, `trim$`.
  '
  ' }doc

  rep trim
    if not len(txt$):\
      exit trim
    if txt$(1)=" ":\
      let txt$=txt$(2 to):\
    else \
      exit trim
  endrep trim
  ret txt$
enddef

deffn trim$(txt$)

  ' doc{
  '
  ' trim$ (txt$)
  '
  ' A function that returns ``txt$`` without surrounding spaces.
  '
  ' See: `trim_left$`, `trim_right$`.
  '
  ' }doc

  ret trim_right$(trim_left$(txt$))

enddef

' ==============================================================
' Change log

' 2017-10-07: Start: Code extracted from CE4
' (http://programandala.net/es.programa.ce4.sbim.html).
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in
' order to build the manual.

' vim: filetype=sbim
