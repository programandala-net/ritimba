' zx_beep.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem A procedure that simulates the ZX Spectrum's 'beep' command.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201709272306
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================
' Credit

' The required information was found in the following
' files, from Dilwyn Jones' website:
'
' - <http://www.dilwyn.me.uk/docs/articles/beeps.pdf>, anonymous.
'
' - <http://www.dilwyn.me.uk/sound/music.zip>, by Dilwin Jones.
'
' - <http://www.dilwyn.me.uk/sound/playscale.zip>, by Mark Swift
'   (1993) and Simon N. Goodwin (1994).

' ==============================================================
' Usage example

' ----
' merge zx_beep_bas
' init_zx_beep
' let zx_beep_tempo=2.1:rem Default. Adjust to your machine.
' zx_beep seconds,pitch
' ----

' Where "seconds" and "pitch" are the parameters
' accepted by ZX Spectrum's 'beep' command (not their
' whole ranges, though).

' ==============================================================

defproc zx_beep(duration,tone%)

  ' Simulate the ZX Spectrum BASIC command `beep`.

  loc pitch%

  repeat zx_beep_busy:\
    if not beeping:\
      exit zx_beep_busy

  let pitch%=tone%+zx_beep_middle_c_offset%

  if pitch%>=0 and pitch%<=zx_beep_last_pitch%:\
      beep zx_beep_tempo*duration*1000000/72,ql_pitch%(pitch%)

enddef

defproc init_zx_beep

  ' Init the data used by `zx_beep`.

  loc i%,middle_c_pitch%

  let zx_beep_tempo=2.1
    ' The greater, the longer notes.
    ' Configure to your machine.

  let middle_c_pitch%=33

  restore @zx_beep_data

  zx_beep_last_pitch%=0

  rep count_data
    read i%
    if i%=-1:\
      exit count_data
    let zx_beep_last_pitch%=zx_beep_last_pitch%+1
  endrep count_data

  dim ql_pitch%(zx_beep_last_pitch%)

  restore @zx_beep_data

  for i%=0 to zx_beep_last_pitch%
    read ql_pitch%(i%)
    if ql_pitch%(i%)=middle_c_pitch%:\
      let zx_beep_middle_c_offset%=i%
  endfor i%

enddef

' ==============================================================
' Data

'    Hz approx = 11447/(10.6+pitch)
' pitch approx = 11447/Hz-10.6

label @zx_beep_data

'    QL pitch  Hz       Note
'    --------  ------   ----
data 000     ' 987.80 ' B
data 001     ' 932.30 ' A#
data 002     ' 880.00 ' A
data 003     ' 830.60 ' G#
data 004     ' 784.00 ' G
data 005     ' 740.00 ' F#
data 006     ' 698.50 ' F
data 007     ' 659.30 ' E
data 008     ' 622.30 ' D#
data 009     ' 587.30 ' D
data 010     ' 554.40 ' C#
data 011     ' 523.30 ' C
data 012     ' 493.90 ' B
data 014     ' 466.10 ' A#
data 015     ' 440.00 ' A 
data 017     ' 415.30 ' G#
data 019     ' 391.99 ' G 
data 020     ' 369.99 ' F#
data 022     ' 349.22 ' F 
data 024     ' 329.62 ' E 
data 026     ' 311.12 ' D#
data 028     ' 293.66 ' D 
data 031     ' 277.18 ' C#
data 033     ' 261.62 ' C (middle C)
data 036     ' 246.94 ' B 
data 039     ' 233.08 ' A#
data 041     ' 220.00 ' A 
data 045     ' 207.65 ' G#
data 048     ' 195.99 ' G 
data 051     ' 184.99 ' F#
data 055     ' 174.61 ' F 
data 059     ' 164.81 ' E 
data 063     ' 155.56 ' D#
data 067     ' 146.83 ' D 
data 072     ' 138.59 ' C#
data 077     ' 130.81 ' C 
data 082     ' 123.47 ' B 
data 088     ' 116.54 ' A#
data 093     ' 110.00 ' A 
data 100     ' 103.82 ' G#
data 106     ' 097.99 ' G 
data 113     ' 092.49 ' F#
data 121     ' 087.30 ' F 
data 128     ' 082.40 ' E 
data 137     ' 077.78 ' D#
data 145     ' 073.41 ' D 
data 155     ' 069.29 ' C#
data 164     ' 065.40 ' C 
data 175     ' 061.73 ' B 
data 186     ' 058.27 ' A#
data 198     ' 055.00 ' A 
data 210     ' 051.91 ' G#
data 223     ' 048.99 ' G 
data 237     ' 046.24 ' F#
data 252     ' 043.65 ' F 

data -1 ' end of data

' ==============================================================
' Change log

' 2017-09-18: Start. First working version.
'
' 2017-09-20: Integrate into the new library project.
'
' 2017-09-27: Update file header. Convert `i` to `i%`.

' vim: filetype=sbim
