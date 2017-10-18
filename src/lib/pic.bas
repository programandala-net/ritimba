' pic.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem PIC format tools.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710181407
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn pic_size%(file$,width%,height%)

  ' Set variables `width%` and `height%` to the size of the PIC
  ' image `file$`.
  '
  ' Return an I/O result: if the file can be read, return zero;
  ' otherwise return the corresponding error code, which is a
  ' negative integer.

  loc channel%
  let channel%=fopen(file$)

  if channel%>-1
    wget #channel%\2,width%,height%
    close #channel%
  endif

  ret channel%*(channel%<0)

enddef

deffn pic_width%(file$)

  ' Return the width in pixels of the PIC image `file$`.  If the
  ' file can not be read, return the corresponding error code
  ' instead, which is a negative integer.

  loc channel%,width%

  let channel%=fopen(file$)

  if channel%>-1
    wget #channel%\2,width%
    close #channel%
    ret width%
  else
    ret channel%
  endif

enddef

deffn pic_height%(file$)

  ' Return the height in pixels of the PIC image `file$`.  Ff the
  ' file can not be read, return the corresponding error code
  ' instead, which is a negative integer.

  loc channel%,height%

  let channel%=fopen(file$)

  if channel%>-1
    wget #channel%\4,height%
    close #channel%
    ret height%
  else
    ret channel%
  endif

enddef

defproc load_pic(file$,x%,y%)

  ' Load a PIC image from `file$` and display it at screen
  ' coordinates `x%`, `y%`. If the file can not be found, do
  ' nothing.

  loc pic_address,\
      width%,height%,\ ' image size in pixels
      ior%,\           ' I/O result
      pw%              ' picture window channel

  let ior%=pic_size%(file$,width%,height%)

  if not ior%
    let pw%=fopen("scr_")
    window #pw%,width%,height%,x%,y%
    let pic_address=l_wsa(file$)
    wsars #pw%,pic_address,
    close #pw%
  endif

  ' XXX REMARK -- The comma separator after the address
  ' parameter of `wsars` is used to give up the save area. A
  ' backslash separator would mean keep the save area. See the
  ' manual of EasyPtr 4.

enddef

defproc load_pic_win(channel%,file$,x%,y%)

  ' Load a PIC image from `file$` and display it at coordinates
  ' `x%`, `y%` of window `channel%`. If the file can not be
  ' found, do nothing.

  loc pic_address,\
      width%,height%,\ ' image size in pixels
      ior%,\           ' I/O result
      pw%,\            ' picture window channel
      px%,py%          ' coordinates of the picture in the window

  let ior%=pic_size%(file$,width%,height%)

  let px%=win_xmin%(channel%)+x%
  let py%=win_ymin%(channel%)+y%

  if not ior%
    let pw%=fopen("scr_")
    window #pw%,width%,height%,px%,py%
    let pic_address=l_wsa(file$)
    wsars #pw%,pic_address,
    close #pw%
  endif

  ' XXX REMARK -- The comma separator after the address
  ' parameter of `wsars` is used to give up the save area. A
  ' backslash separator would mean keep the save area. See the
  ' manual of EasyPtr 4.

enddef

defproc load_pic_win_cc(channel%,file$)

  ' Load a PIC image from `file$` and display it at the center
  ' of window `channel%`. If the file can not be found, do
  ' nothing.

  loc width%,height%,\ ' image size in pixels
      ior%,\           ' I/O result
      pw%,\            ' picture window channel
      px%,py%          ' coordinates of the picture in the window

  let ior%=pic_size%(file$,width%,height%)

  if not ior%
    let px%=\
      win_xmin%(channel%)+\
      (win_width%(channel%)-width%) div 2
    let py%=\
      win_ymin%(channel%)+\
      (win_height%(channel%)-height%) div 2
    let pw%=fopen("scr_")
    window #pw%,width%,height%,px%,py%
    let pic_address=l_wsa(file$)
    wsars #pw%,pic_address,
    close #pw%
  endif

  ' XXX REMARK -- The comma separator after the address
  ' parameter of `wsars` is used to give up the save area. A
  ' backslash separator would mean keep the save area. See the
  ' manual of EasyPtr 4.

enddef

' ==============================================================
' Change log

' 2017-10-10: Start.
'
' 2017-10-17: Replace `get` (which reads variables in its
' internal format) with `wget` (which reads words); there's no
' difference in this case, but, as an external binary file is
' read, `wget` is clearer.

' vim: filetype=sbim
