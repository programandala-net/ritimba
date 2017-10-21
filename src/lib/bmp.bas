' bmp.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem BMP format tools.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710210210
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

  ' doc{
  '
  ' bmp_width (file$)
  '
  ' A function that returns the width in pixels of the BMP image
  ' ``file$``.  If the file can not be read, the function
  ' returns the corresponding error code instead, which is a
  ' negative integer.
  '
  ' See: `bmp_height`.
  '
  ' }doc

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

  ' doc{
  '
  ' bmp_height (file$)
  '
  ' A function that returns the height in pixels of the BMP
  ' image ``file$``.  If the file can not be read, the function
  ' returns the corresponding error code instead, which is a
  ' negative integer.
  '
  ' See: `bmp_width`.
  '
  ' }doc

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

defproc load_bmp(file$,x,y)

  ' doc{
  '
  ' load_bmp (file$,x,y)
  '
  ' A procedure that loads a BMP image ``file$`` at the given
  ' screen coordinates ``x`` and ``y``.
  '
  ' NOTE: This function uses ``wl_bmp3load`` from the BMPCVT
  ' toolkit (by Wolfgang Lenerz, 2002).
  '
  ' }doc

  loc window%
  let window%=fopen("scr_")

  window #window%,bmp_width(file$),bmp_height(file$),x,y
  wl_bmp8load #window%,file$
  close #window%

enddef

defproc bmp_to_pic(infile$,outfile$)

  ' doc{
  '
  ' bmp_to_pic (infile$,outfile$)
  '
  ' A procedure that converts a BMP image ``infile$`` to a PIC
  ' image ``outfile$``.
  '
  ' NOTE: This procedure uses the following S*BASIC extensions:
  ' ``wl_bmp3load`` from BMPCVT (by Wolfgang Lenerz, 2002);
  ' ``wsain``, ``wsasv`` and ``s_wsa`` from EasyPtr 4 (by Albin
  ' Hessler and Marcel Kilgus, 2016).
  '
  ' }doc

  loc window%,pic_address,width%,height%

  let width%=bmp_width(infile$)
  let height%=bmp_height(infile$)

  let window%=fopen("scr_")
  window #window%,width%,height%,0,0

  wl_bmp8load #window%,infile$
  let pic_address=wsain(#window%)
  wsasv #window%,pic_address
  s_wsa #window%,pic_address,outfile$
  rechp pic_address
  close #window%

enddef

' ==============================================================
' Change log

' 2017-10-17: Start: `bmp_width`, `bmp_height`.
'
' 2017-10-18: Add `bmp_to_pic`.
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in order to build the manual.
'
' 2017-10-21: Fix and improve documentation.

' vim: filetype=sbim

