' win.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Functions that return window channel information.

rem Authors:
rem Simon n Goodwin, 1988
rem Adapted to Sbira by Marcos Cruz (programandala.net), 2017

' Last modified 201710210206
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

deffn win_base(chan%)

  ' doc{
  '
  ' win_base(chan%)
  '
  ' A function that returns the screen address of top left of
  ' window ``chan%``.
  '
  ' NOTE: This function uses ``chan_l`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' }doc

  ret chan_l(chan%,50)

enddef

deffn win_ink%(chan%)

  ' doc{
  '
  ' win_ink% (chan%)
  '
  ' A function that returns the ink colour of window ``chan%``.
  '
  ' NOTE: This function uses ``chan_b%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_paper%`, `win_attr%`.
  '
  ' }doc

  ret chan_b%(chan%,70)

enddef

deffn win_paper%(chan%)

  ' doc{
  '
  ' win_paper% (chan%)
  '
  ' A function that returns the paper colour of window
  ' ``chan%``.
  '
  ' NOTE: This function uses ``chan_b%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_ink%`, `win_attr%`.
  '
  ' }doc

  ret chan_b%(chan%,68)

enddef

deffn win_width%(chan%)

  ' doc{
  '
  ' win_width% (chan%)
  '
  ' A function that returns the width (in pixels) of window
  ' ``chan%``, not including its border.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_height%`, `win_xmin%`.
  '
  ' }doc

  ret chan_w%(chan%,28)

enddef

deffn win_height%(chan%)

  ' doc{
  '
  ' win_height% (chan%)
  '
  ' A function that returns the height (in pixels) of window
  ' ``chan%``, not including its border.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_width%`, `win_ymin%`.
  '
  ' }doc

  ret chan_w%(chan%,30)

enddef

deffn win_xpos%(chan%)

  ' doc{
  '
  ' win_xpos% (chan%)
  '
  ' A function that returns the cursor X coordinate of window
  ' ``chan%``, relative to the top left corner of the window,
  ' not including its border.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_ypos%`, `win_xmin%`.
  '
  ' }doc

  ret chan_w%(chan%,34)

enddef

deffn win_ypos%(chan%)

  ' doc{
  '
  ' win_ypos% (chan%)
  '
  ' A function that returns the cursor Y coordinate of window
  ' ``chan%``, relative to the top left corner of the window,
  ' not including its border.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_xpos%`, `win_ymin%`.
  '
  ' }doc

  ret chan_w%(chan%,36)

enddef

deffn win_xmin%(chan%)

  ' doc{
  '
  ' win_xmin% (chan%)
  '
  ' A function that returns the cursor X coordinate of the left
  ' edge of window ``chan%``, not including its border.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_ymin%`, `win_width%`, `win_xpos%`.
  '
  ' }doc

  ret chan_w%(chan%,24)

enddef

deffn win_ymin%(chan%)

  ' doc{
  '
  ' win_ymin% (chan%)
  '
  ' A function that returns the cursor Y coordinate of the top
  ' of window ``chan%``, not including its border.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_xmin%`, `win_height%`, `win_ypos%`
  '
  ' }doc

  ret chan_w%(chan%,26)

enddef

deffn win_cursor_height%(chan%)

  ' doc{
  '
  ' win_cursor_height% (chan%)
  '
  ' A function that returns the cursor height (in pixels) of
  ' window ``chan%``.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_cursor_width%`, `win_attr%`.
  '
  ' }doc

  ret chan_w%(chan%,40)

enddef

deffn win_cursor_width%(chan%)

  ' doc{
  '
  ' win_cursor_width% (chan%)
  '
  ' A function that returns the cursor width (in pixels) of
  ' window ``chan%``.
  '
  ' NOTE: This function uses ``chan_w%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_cursor_height%`, `win_attr%`.
  '
  ' }doc

  ret chan_w%(chan%,38)

enddef

deffn win_attr%(chan%)

  ' doc{
  '
  ' win_attr%(chan%)
  '
  ' A function that returns the character attributes byte of
  ' window ``chan%``.  This byte contains seven useful bits of
  ' information about character printing in the window:

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

  ' NOTE: This function uses ``chan_b%`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_paper%`, `win_ink%`, `win_cursor_width%`,
  ' `win_cursor_heigth%`, `win_font1`, `win_font2`.
  '
  ' }doc

  ret chan_b%(chan%,66)

enddef

deffn win_font1(chan%)

  ' doc{
  '
  ' win_font1 (chan%)
  '
  ' A function that returns the start address of the first font
  ' of window ``chan%``.
  '
  ' NOTE: This function uses ``chan_l`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_font2`, `win_cursor_width%`, `win_cursor_height%`,
  ' `win_attr%`.
  '
  ' }doc

  ret chan_l(chan%,42)

enddef

deffn win_font2(chan%)

  ' doc{
  '
  ' win_font2 (chan%)
  '
  ' A function that returns the start address of the second font
  ' of window ``chan%``.
  '
  ' NOTE: This function uses ``chan_l`` from Simon N. Goodwin's
  ' DIY Toolkit (volume C).
  '
  ' See: `win_font1`, `win_cursor_width%`, `win_cursor_height%`,
  ' `win_attr%`.
  '
  ' }doc

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

  ' doc{
  '
  ' win_line% (chan%)
  '
  ' A function that returns the cursor Y coordinate of window
  ' `chan%`.
  '
  ' See: `win_column%`, `win_ypos%`, `win_lines%`,
  ' `win_cursor_height%`.
  '
  ' }doc

  ret win_ypos%(chan%)/win_cursor_height%(chan%)

enddef

deffn win_column%(chan%)

  ' doc{
  '
  ' win_column% (chan%)
  '
  ' A function that returns the cursor X coordinate of window
  ' `chan%`.
  '
  ' See: `win_line%`, `win_xpos%`, `win_columns%`,
  ' `win_cursor_width%`.
  '
  ' }doc

  ret win_xpos%(chan%)/win_cursor_width%(chan%)

enddef

deffn win_lines%(chan%)

  ' doc{
  '
  ' win_lines% (chan%)
  '
  ' A function that returns the number of lines of window
  ' ``chan%``.
  '
  ' See: `win_columns%`, `win_height%`, `win_line%`.
  '
  ' }doc

  ret win_height%(chan%)/win_cursor_height%(chan%)

enddef

deffn win_columns%(chan%)

  ' doc{
  '
  ' win_columns% (chan%)
  '
  ' A function that returns the number of columns of window
  ' ``chan%``.
  '
  ' See: `win_lines%`, `win_width%`, `win_column%`.
  '
  ' }doc

  ret win_width%(chan%)/win_cursor_width%(chan%)

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
'
' 2017-10-14: Finish `win_line%` and `win_column%`. Add
' `win_lines%` and `win_columns%`.
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in order to build the manual.
'
' 2017-10-21: Fix documentation.

' vim: filetype=sbim
