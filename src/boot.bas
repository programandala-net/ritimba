rem Ritimba boot
rem This file is part of Ritimba
rem http://programandala.net/es.programa.ritimba.html
rem Copyright (C) 2011,2012,2015,2016,2017 Marcos Cruz (programandala.net)

' Last modified 201710110018

' ==============================================================
' Windows and files

window#0,scr_xlim,scr_ylim,0,0
cls#0
csize#0,3,1
close#1
close#2

data_use home_dir$

' ==============================================================
' Requirements

' From "DIY Toolkit", by Simon N. Goodwin, 1988-1994:
' `minimum%`, `maximum%`, `maximum`, `chan_w%`.

lrespr "ext_minmax_code"
lrespr "ext_chans_code"

' From BMPCVT, by Wolfgang Lenerz, 2002:
' `wl_bmp3load`.

lrespr "ext_bmpcvt_code"

' From EasyPtr 4, by Albin Hessler and Marcel Kilgus, 2016:
' `l_wsa`, `wsars`, `wsain`, `wsasv`, `s_wsa`.

lrespr "ext_easyptr_code"

' ==============================================================
' Boot

lrun "ritimba_bas"

' vim: filetype=sbim
