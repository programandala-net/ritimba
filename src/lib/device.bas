rem device.bas
rem A function for S*BASIC
rem By Marcos Cruz (programandala.net), 2016, 2017

' 2016-01-25: Extract from ce4_sbim.
' 2017-09-12: Fix typo. Rename "_sbim" ".sbim".
' 2017-09-17: Rename ".sbim" ".bas". Update header.

deffn device$(file$,devices$)

  rem Return the first device from a list where the given file is found.
  rem devices$ = list of 3-letter devices, without separators.

  loc device_offset%,drive_number%,dev$

  if ftest(file$)
    for device_offset%=1 to len(devices$) step 3
      for drive_number%=1 to 8
        let dev$=devices$(device_offset% to device_offset%+2)&drive_number%&"_"
        if not ftest(dev$&file$):exit device_offset%
      endfor drive_number%
    endfor device_offset%
  endif

  ret dev$

enddef

' vim: filetype=sbim
