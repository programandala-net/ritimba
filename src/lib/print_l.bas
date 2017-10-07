' print_l.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Procedures to print left-justified strings.

' The following variables are used, and must be set by the
' application:
'
'   paragraph_separation% = number of lines between paragraphs
'
'   paragraph_indentation% = spaces at the start of the first
'   line of a paragraph

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710072219
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================


defproc print_l(channel%,text$)

  ' Print the given text left justified from the current cursor
  ' position of the window identified by `channel%`.

  local t$,first%,last%

  if len(text$)
    let t$=text$&" "
    let first%=1
    for last%=1 to len(t$)
      if t$(last%)=" "
        print #channel%,!t$(first% to last%-1);
        let first%=last%+1
      endif
    endfor last%
  endif

enddef

defproc paragraph(channel%)

  ' Start a new paragraph in the window identified by
  ' `channel%`.

  loc i%
  for i%=1 to paragraph_separation%:\
    print #channel%
  print #channel%,fill$(" ",paragraph_indentation%);
  ' XXX FIXME -- An extra blank line is created if the
  ' previous line occupied the whole width.
  ' Fix with a check with `chan_b%`.

enddef

defproc end_paragraph(channel%)

  ' End the current paragraph in the window identified by
  ' `channel%`.

  print #channel%

enddef

defproc print_l_paragraph(channel%,text$)

  ' Print the given text left justified as a new paragraph,
  ' in the window identified by `channel%`.

  paragraph #channel%
  print_l #channel%,text$
  end_paragraph #channel%

enddef

' ==============================================================
' Change log

' 2017-10-07: Start: Code extracted from Ritimba
' (http://programandala.net/es.programa.ritimba.html) and
' improved.

' vim: filetype=sbim
