' csize_pixels.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that convert `csize` parameters to pixels.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710081756
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn csize_width_pixels%(width%)
  sel on width%
    =0:ret 6
    =1:ret 8
    =2:ret 12
    =3:ret 16
  endsel
enddef

deffn csize_height_pixels%(height%)
  ret height%*10+10
enddef

' ==============================================================
' Change log

' 2017-09-28: Start: Code extracted from Ritimba
' (http://programandala.net/es.programa.ritimba.html).
'
' 2017-10-08: Convert to integer.

' vim: filetype=sbim
