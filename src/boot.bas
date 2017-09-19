rem Ritimba boot
rem This file is part of Ritimba
rem http://programandala.net/es.programa.ritimba.html
rem Copyright (C) 2011,2012,2015,2016,2017 Marcos Cruz (programandala.net)

' Last modified 201709200128

' ==============================================================

window#0,scr_xlim,scr_ylim,0,0
cls#0
csize#0,3,1
close#1
close#2

let dev$=device$("ritimba_bas","flpmdvdevsubwinnfados")

lrun dev$&"ritimba_bas"

#include device.bas

' vim: filetype=sbim
