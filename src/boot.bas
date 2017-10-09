rem Ritimba boot
rem This file is part of Ritimba
rem http://programandala.net/es.programa.ritimba.html
rem Copyright (C) 2011,2012,2015,2016,2017 Marcos Cruz (programandala.net)

' Last modified 201710091831

' ==============================================================

window#0,scr_xlim,scr_ylim,0,0
cls#0
csize#0,3,1
close#1
close#2

data_use home_dir$

' Load `minimum` and `maximum`
' from "DIY Toolkit", (C) Simon N. Goodwin:
lrespr "ext_minmax_code"

' Load `chans_b%`, `chans_w%` and `chans_l`
' from "DIY Toolkit", (C) Simon N. Goodwin:
lrespr "ext_chans_code"

lrun "ritimba_bas"

' vim: filetype=sbim
