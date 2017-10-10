' win.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that return window channel information.

rem Authors:
rem Simon n Goodwin, 1988
rem Adapted to Sbira by Marcos Cruz (programandala.net), 2017

' Last modified 201710110022
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn win_base(chan%)
  ' Address of top left of screen.
  ret chan_l(chan%,50)
enddef

deffn win_ink%(chan%)
  ' Current ink in chan%.
  ret chan_b%(chan%,70)
enddef

deffn win_paper%(chan%)
  ' Current paper in chan%.
  ret chan_b%(chan%,68)
enddef

deffn win_width%(chan%)
  ' Pixel width of window chan%, not including its border.
  ret chan_w%(chan%,28)
enddef

deffn win_height%(chan%)
  ' Pixel height of window chan%, not including its border.
  ret chan_w%(chan%,30)
enddef

deffn win_xpos%(chan%)
  ' Cursor x coordinate of window chan%, relative to the top
  ' left corner of the window, not including its border.
  ret chan_w%(chan%,34)
enddef

deffn win_ypos%(chan%)
  ' Cursor y coordinate of window chan%, relative to the top
  ' left corner of the window, not including its border.
  ret chan_w%(chan%,36)
enddef

deffn win_xmin%(chan%)
  ' x co-ordinate of left edge of window chan%, not including
  ' its border.
  ret chan_w%(chan%,24)
enddef

deffn win_ymin%(chan%)
  ' y co-ordinate of top of window chan%, not including its
  ' border.
  ret chan_w%(chan%,26)
enddef

deffn win_cursor_height%(chan%)
  ' Cursor height in pixels of window chan%.
  ret chan_w%(chan%,40)
enddef

deffn win_cursor_width%(chan%)
  ' Cursor width in pixels of window chan%.
  ret chan_w%(chan%,38)
enddef

deffn win_attr%(chan%)

  ' Character attributes: this byte contains seven useful bits
  ' of information about character printing in this window.

  ' |===
  ' | Bitmask  | Attribute
  '
  ' | %0000001 | Underlining on
  ' | %0000010 | Flashing on
  ' | %0000100 | Transparent background
  ' | %0001000 | Overprinting: OVER -1
  ' | %0010000 | Tall text: CSIZE ?,1
  ' | %0100000 | Extra width: CSIZE 1, 3
  ' | %1000000 | Double width: CSIZE 2, 3
  ' |===

  ret chan_b%(chan%,66)

enddef

deffn win_font1(chan%)
  ' Start address of first character set.
  ret chan_l(chan%,42)
enddef

deffn win_font2(chan%)
  ' Start address of second character set.
  ret chan_l(chan%,46)
enddef

deffn win_csize_width%(chan%)
  ' XXX TODO --
  select on (chan_b%(#chan%,66) && %1100000)
    =%0000000:ret 0
    =%0100000:ret 1
    =%1000000:ret 2
  endsel
enddef

deffn win_csize_height%
  ' XXX TODO --
  ret (chan_b%(#chan%,66) && 16)<>0
enddef

deffn win_line%(chan%)
  ' XXX TODO --
  ret win_ypos%(chan%)/win_csize_height%(chan%)
enddef

deffn win_column%(chan%)
  ' XXX TODO --
  ret win_xpos%(chan%)/win_csize_width%(chan%)
enddef

' ==============================================================
' Change log

' 2017-09-23: Start. Adapt the original code, extracted from the
' examples included in DIY Toolkit (volume C, <chans_demo_bas>).
'
' 2017-09-24: Try drafts of `win_column%` and win_line%`.
'
' 2017-09-27: Update file header.
'
' 2017-09-28: Try drafts of `win_csize_width%` and
' `win_csize_heigth%`.
'
' 2017-10-10: Improve documentation.  Fix `win_cursor_width%`.

' vim: filetype=sbim
