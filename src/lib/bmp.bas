' bmp.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem BMP format tools.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710180036
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

' Note: The long integers in the BMP file are little-endian (ie.
' LSB first), but they are big-endian (ie. MSB first) in QDOS.

deffn bmp_width(file$)

  ' Return the width in pixels of the BMP image `file$`.  If the
  ' file can not be read, return the corresponding error code
  ' instead, which is a negative integer.

  loc channel%,b0%,b1%,b2%,b3%

  let channel%=fopen(file$)

  if channel%>-1
    bget #channel%\18,b0%,b1%,b2%,b3%
    close #channel%
    ret b0%+b1%*$100+b2%*$10000+b3%*$1000000
  else
    ret channel%
  endif

enddef

deffn bmp_height(file$)

  ' Return the height in pixels of the BMP image `file$`.  If the
  ' file can not be read, return the corresponding error code
  ' instead, which is a negative integer.

  loc channel%,b0%,b1%,b2%,b3%

  let channel%=fopen(file$)

  if channel%>-1
    bget #channel%\22,b0%,b1%,b2%,b3%
    close #channel%
    ret b0%+b1%*$100+b2%*$10000+b3%*$1000000
  else
    ret channel%
  endif

enddef

' ==============================================================
' Change log

' 2017-10-17: Start.

' vim: filetype=sbim

