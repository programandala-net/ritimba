' print_cc.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Procedure that prints at the center of a window.

rem Authors:
rem Simon n Goodwin, 1991-12
rem Suggested by Dario Leslie
rem Adapted to Sbira by Marcos Cruz (programandala.net), 2017

' Last modified 201710212217
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

' #require win.bas ' XXX TODO --

deffn centre_line%(ch%)

  ' doc{
  '
  ' centre_line% (ch%)
  '
  ' A function that returns the centre line of window ``ch%``.
  '
  ' See: `centre_column%`, `win_height%`, `win_cursor_height%`, `win_lines%`.
  '
  ' }doc

  ret win_height%(#ch%) div (win_cursor_height%(#ch%)*2)

enddef

deffn centre_column%(ch%)

  ' doc{
  '
  ' centre_column% (ch%)
  '
  ' A function that returns the centre column of window ``ch%``.
  '
  ' See: `centre_line%`, `win_width%`, `win_cursor_width%`, `win_columns%`.
  '
  ' }doc

  ret win_width%(#ch%) div (win_cursor_width%(#ch%)*2)

enddef

defproc print_cc(ch%,text$)

  ' doc{
  '
  ' print_cc (ch%,text$)
  '
  ' A procedure that prints ``text$`` at the centre of the centre line of
  ' window ``ch%``.
  '
  ' See: `centre_line%`, `centre_column%`.
  '
  ' }doc

  loc fit$
  let fit$=text$(to win_columns%(ch%))
  at #ch%,centre_line%(ch%),centre_column%(ch%)-(len(fit$) div 2)
  print #ch%,fit$

enddef

' ==============================================================
' Change log

' 2017-09-23: Start. Adapt the original code, extracted from the
' examples included in Simon n Goodwin's DIY Toolkit (volume C,
' <chans_demo_bas>).
'
' 2017-09-27: Update file header.
'
' 2017-10-17: Cut lines longer than the width of the current
' window.
'
' 2017-10-20: Document the code with the format required by
' Glosara (http://programandala.net/en.program.glosara.html) in
' order to build the manual.
'
' 2017-10-21: Make `centre_line` and `centre_column` integer.

' vim: filetype=sbim
