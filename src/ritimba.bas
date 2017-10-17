rem Ritimba

version$="0.1.0-dev.111+201710180148"

' ==============================================================
' Author and license {{{1

rem Copyright (C) 2011,2012,2015,2016,2017 Marcos Cruz (programandala.net)

rem You may do whatever you want with this work, so long as you
rem retain the copyright notice(s) and this license in all
rem redistributed copies and derived works. There is no warranty.
rem

' ==============================================================
' Description {{{1

rem Ritimba is a QL port of the Spanish version of Don Priestley's
rem ZX Spectrum game "DICTATOR" (1983), written in SBASIC for SMSQ/E.

rem Home page (in Spanish):
rem http://programandala.net/es.programa.ritimba.html

' This source is written in the SBim format of S*BASIC.
' http://programandala.net/es.programa.sbim.html

' ==============================================================
' Requirements {{{1

#include lib/bmp.bas
#include lib/csize_pixels.bas
#include lib/iso_lower.bas
#include lib/iso_upper.bas
#include lib/pic.bas
#include lib/print_cc.bas
#include lib/print_l.bas
#include lib/trim.bas
#include lib/win.bas
#include lib/zx_beep.bas

' The SBASIC extensions are loaded by the <boot> file.

' ==============================================================
' Main loop {{{1

' #define debugging

defproc ritimba

  loc i%

  init_once
  rep
    init_data
    splash_screen
    credits
    welcome
    rep game
      new_month
      audience
      plot
      assassination
      if not alive%:\
        exit game
      war
      if not alive% or escape%:\
        exit game
      plot
      police_report
      decision
      treasury_report
      plot
      police_report
      news
      rebellion
      if not alive% or escape%:\
        exit game
    endrep game
    the_end
  endrep

enddef

ritimba

' ==============================================================
' Presentation {{{1

defproc credits

  wipe black%,white%,blue%
  at #ow%,1,0

  print_l_paragraph #ow%,"Ritimba "&version$

  print_l_paragraph #ow%,\
    "Por: \
    Marcos Cruz (programandala.net), \
    2011, 2012, 2015, 2016, 2017."

  print_l_paragraph #ow%,\
    "Una versión en SBASIC para SMSQ/E del \
    «Dictator» de Don Priestley para ZX Spectrum (1983)."

  key_press

enddef

defproc splash_screen
  wipe black%,bright_white%,black%
  center #ow%,5,"RITIMBA"
  national_flag
  national_anthem
enddef

defproc national_flag

  loc i%,\
    flag_width%,flag_height%,flag_x%,flag_y%,\
    stars_width%,stars_height%,stars_x%,stars_y%,stars_row$,\
    bar_colour%

  let flag_width%=22  ' in chars
  let flag_height%=12 ' in chars
  let flag_x%=center_for%(flag_width%)
  let flag_y%=8

  let stars_width%=4  ' in chars
  let stars_height%=4 ' in chars
  let stars_row$=fill$("*",stars_width%)
  let stars_x%=center_for%(stars_width%)
  let stars_y%=flag_y%+(flag_height%-stars_height%)/2

  let bar_colour%=green%

  for i%=flag_y% to flag_y%+flag_height%-1
    at #ow%,i%,flag_x%
    paper #ow%,bar_colour%
    print #ow%,"     ";
    paper #ow%,blue%
    print #ow%,"            ";
    paper #ow%,bar_colour%
    print #ow%,"     "
    if bar_colour%=green%
      let bar_colour%=red%
    else
      let bar_colour%=green%
    endif
  endfor i%

  paper #ow%,blue%
  ink #ow%,yellow%
  for i%=stars_y% to stars_y%+stars_height%-1:\
    at #ow%,i%,stars_x%:\
    print #ow%,stars_row$

enddef

defproc national_anthem
  loc times%,note%,pitch%,tune$
  let tune$="KPKKMKIHK`KMRPOMOP"
  for times%=1 to 2
    for note%=1 to len(tune$)
      if len(inkey$(#iw%)):\
        exit times%
      let pitch%=code(tune$(note%))-80
      if pitch%=16
        beep
        pause 20
      else
        zx_beep .5,pitch%
      endif
    endfor note%
    beep
    pause 30
  endfor times%
enddef

defproc welcome

    wipe white%,black%,blue%
    paper #ow%,cyan%
    center #ow%,1,"Bienvenido al cargo"
    paper #ow%,white%

    if first_president%

      print_l_paragraph #ow%,\
        "Su excelencia es el primer presidente \
        de nuestra amada patria Ritimba."
      paragraph #ow%
      print_l #ow%,\
        "Confiamos en su excelencia..."

    else

      paragraph #ow%
      print_l #ow%,\
        "El anterior presidente \
        de nuestra amada patria Ritimba \
        obtuvo una puntuación de "&score%&"."

      if record% and (record%>score%)
        print_l #ow%,\
          "Y el que hasta la fecha \
          ha sido el mejor presidente \
          obtuvo una puntuación de "&record%&"."
      endif

      end_paragraph #ow%
      paragraph #ow%
      print_l #ow%,\
        "Deseamos que su excelencia \
        logre hacerlo mucho mejor..."

    endif

    print_l #ow%,"por el bien de todos."
    end_paragraph #ow%

    print_l_paragraph #ow%,\
      "Para empezar, su excelencia podrá leer un informe \
      de la hacienda pública \
      y otro de la policía secreta."

    key_press

    treasury_report
    ordinary_police_report

enddef

deffn first_president%
  ret not (score%+record%)
enddef

' ==============================================================
' Plot {{{1

defproc new_month

  let low%=rnd(2 to 4)
  let rebellion_strength%=rnd(10 to 12)
  let months%=months%+1

  wipe yellow%,black%,yellow%
  at #ow%,10,12
  paper #ow%,cyan%
  ink #ow%,black%
  print #ow%,"MES  ";
  paper #ow%,bright_white%
  print #ow%,months%
  pause 50
  plot
  if money<=0
    bankruptcy
  else
    let money=money-monthly_payment
  endif

enddef

defproc plot

  loc main_group%,ally_group%

  if months%<=2 or months%<pc%:\
    ret

  for main_group%=1 to main_groups%:\
    let plan%(main_group%)=none%:\
    let ally%(main_group%)=none%

  for main_group%=1 to main_groups%
    if popularity%(main_group%)<=low%
      for ally_group%=1 to local_groups%
        if not(main_group%=ally_group% \
               or popularity%(ally_group%)>low%)
          if power%(ally_group%)+power%(main_group%)\
             >=rebellion_strength%
            let plan%(main_group%)=rebellion%
            let ally%(main_group%)=ally_group%
            exit ally_group%
          endif
        endif
      next ally_group%
        let plan%(main_group%)=assassination%
      endfor ally_group%
    endif
  endfor main_group%

enddef

defproc assassination

  loc group%

  let group%=rnd(1 to main_groups%)

  if plan%(group%)=assassination%:\
    try_assassination

enddef

defproc try_assassination

  wipe black%,white%,black%
  center #ow%,8,"INTENTO DE MAGNICIDIO"
  center #ow%,10,"por un "&member$(group%)
  pause 50

  cls #ow%
  shoot_dead_sfx
  pause 50

  if all_groups_plan_assassination% or not secret_police_is_effective%
    successful_assassination
  else
    failed_assassination
  endif

  key_press

enddef

defproc failed_assassination

  ' XXX TODO -- Improve.
  wipe white%,black%,black%
  paper #ow%,white%
  ink #ow%,black%
  print_cc #ow%,"Intento fallido."

enddef

defproc successful_assassination

  ' XXX TODO -- Improve.
  wipe black%,white%,black%
  print_cc #ow%,"El asesino ha logrado su objetivo."
  zx_beep 3,-40
  let alive%=0

enddef

deffn all_groups_plan_assassination%

  return \
        plan%(army%)=assassination% \
    and plan%(peasants%)=assassination% \
    and plan%(landowners%)=assassination%

enddef

deffn secret_police_is_effective%

  ret popularity%(police%)>low% \
      or power%(police%)>low% \
      or rnd(0 to 1)

enddef

' ==============================================================
' Decisions {{{1

defproc audience

  loc petition%,soliciting_group%,decision%

  prepare_audience

  rep

    rep

      expose_petition soliciting_group%

      let decision%=decision_option%

      sel on decision%
        =0,1 ' no or yes?
          exit
        =2
         advice petition%
      endsel

    endrep

    if decision%=0
      reject petition%
      exit
    else
      if affordable%(petition%)
        take_decision petition%
        exit
      else
        ' XXX FIXME -- This point is not reached when money is not
        ' enough.
        '
        ' XXX TODO -- Improve.
        cls #ow%
        print_l_paragraph #ow%,\
          "No hay suficientes fondos para adoptar esta decisión."
        print_l_paragraph #ow%,\
          "La respuesta de su excelencia debe ser no."
        key_press
      endif
    endif

  endrep

enddef

defproc expose_petition

  wipe yellow%,black%,yellow%
  paper #ow%,green%
  at #ow%,5,0
  cls #ow%,1
  paper #ow%,white%
  ink #ow%,black%
  center #ow%,3,"AUDIENCIA"

  display_audience_icons soliciting_group%

  paper #ow%,yellow%
  ink #ow%,black%
  center #ow%,10,"Petición "\
                 &genitive_name$(soliciting_group%)&":"

  paper #ow%,bright_yellow%
  clear_lines #ow%,14,15 ' all petitions need at least 2 lines
  print_l #ow%,"¿Está su excelencia conforme con "\
    &iso_lower_1$(issue$(petition%))&"?"
  cls #ow%,4 ' clear the rest of the possible third line

enddef

defproc display_audience_icons(group%)

  ' Display the audience icons of the given group.

  loc icons%,x%,y%,last_x%,icon_image$,icon_width%

  let icons%=4
  let icon_image$=icon_file$(icon$(group%))
  let icon_width%=pic_width%(icon_image$)

  at #ow%,6,0
  let y%=win_ypos%(#ow%)
  let last_x%=ow_width%-ow_border_x_width%-icon_width%

  for x%=0 to last_x% step last_x% div (icons%-1)
    load_pic_win #ow%,icon_image$,x%,y%
  endfor

enddef

defproc prepare_audience

  ' Determine the petition and the soliciting group.

  ' XXX TODO -- Factor. Convert it into a function.

  if not petitions_left%
    restore_petitions
  endif

  rep choose_petition
    let petition%=rnd(1 to petitions%)
    if not is_decision_taken%(petition%)
      exit choose_petition
    endif
  endrep choose_petition

  mark_decision_taken petition%

  let soliciting_group%=int((petition%-1)/groups%)+1

enddef

deffn petitions_left%

  ' Return the number of petitions that have not been done yet.

  loc i%,count%

  for i%=1 to petitions%:\
    let count%=count%+not is_decision_taken%(i%)

  ret count%

enddef

defproc reject(petitition%)

  loc new_popularity%

  let new_popularity%=\
    popularity%(soliciting_group%)\
    -decision_popularity_effect%(petition%,soliciting_group%)

  let popularity%(soliciting_group%)=maximum%(new_popularity%,0)

  cls #ow%

enddef

defproc decision

  loc section%,chosen_decision%

  rep choose_decision

    let section%=decision_section%
    if section%=0
      exit choose_decision
    endif

    let chosen_decision%=decision%(section%)

    sel on chosen_decision%

      =0
       next choose_decision

      =37
        transfer
        if transferred_money
          exit choose_decision
        endif

      =38,39
        ask_for_loan chosen_decision%
        exit choose_decision

      =remainder

        advice chosen_decision%

        if affordable%(chosen_decision%)

          ' XXX FIXME -- Layout, colour...:
          cls #ow%
          paper #ow%,white%

          print_l #ow%,"¿"&issue$(chosen_decision%)&"?"

          if yes_key%

            if chosen_decision%=35
              let strength%=strength%+2
              take_decision chosen_decision%
              exit choose_decision
            else
              take_only_once_decision chosen_decision%
              exit choose_decision
            endif

          endif

        else

          ' XXX TODO --
          pause 200

        endif
        next choose_decision

    endsel

  endrep choose_decision

enddef

deffn decision_section%

  ' Display the sections of the presidential decisions, wait for a
  ' valid key press and return the corresponding section number.

  loc i%,col%,digit$,zero%,key$,valid_keys$,prompt$

  let zero%=code("0")

  wipe red%,yellow%,blue%

  print #ow%,fill$("*",columns%*ow_lines%)

  paper #ow%,bright_blue%
  ink #ow%,bright_white%
  center #ow%,3,"DECISIÓN PRESIDENCIAL"

  paper #ow%,yellow%
  ink #ow%,black%

  let col%=center_for%(3+section_max_len%)

  for i%=1 to decision_sections%
    decision_item
  endfor
  let prompt$=prompt$&"..."

  key$=get_key_prompt$(prompt$)
  if key$ instr valid_keys$
    ret key$
  else
    ret 0
  endif

enddef

defproc decision_item

  at #ow%,8+i%*2,col%
  print #ow%,i%;". ";decision_section$(i%)
  let digit$=chr$(i%+zero%)
  let valid_keys$=valid_keys$&digit$
  let prompt$=prompt$&digit$&" | "

enddef

deffn decision%(section%)

  loc i%,\
      option%,\     ' output
      options$,\    ' valid digits
      key$,\      ' user input
      prompt$

  cls #ow%

  at #ow%,(20-((last_decision%(section%)-first_decision%(section%))*3))*.5,0

  for i%=first_decision%(section%) to last_decision%(section%)

    if is_decision_taken%(i%)
      ink #ow%,white% ' XXX TMP --
    else
      ink #ow%,black%
      let options$=\
        options$\
        &decision_index%(i%)
      let prompt$=\
        prompt$\
        &if$(len(prompt$)," | ","")\
        &decision_index%(i%)
    endif

    item #ow%,\
      decision_index%(i%),\
      issue$(i%)&"."
    print #ow%

  endfor i%

  if len(options$)

    let key$=get_key_prompt$(prompt$&" | ...")
    if key$ instr options$
      let option%=first_decision%(section%)+key$-1
    else
      let option%=0
    endif

  else

    print_l_paragraph #ow%,"Esta sección está agotada."
    key_press
    let option%=0

  endif

  ret option%

enddef

deffn decision_index%(i%)

  ret i%-first_decision%(section%)+1

enddef

defproc take_only_once_decision(decision%)

  ' XXX TODO -- Rename.

  mark_decision_taken decision%
  take_decision decision%

enddef

defproc take_decision(decision%)

  loc group%,new_popularity%,new_power%

  for group%=1 to groups%
    let new_popularity%=popularity%(group%)\
      +decision_popularity_effect%(decision%,group%)
    let popularity%(group%)=in_range%(new_popularity%,0,9)
  endfor group%

  for group%=1 to local_groups%
    let new_power%=power%(group%)\
      +decision_power_effect%(decision%,group%)
    let power%(group%)=in_range%(new_power%,0,9)
  endfor group%

  let money=\
    money+decision_cost

  let monthly_payment=\
    maximum(monthly_payment-decision_monthly_cost,0)

enddef

deffn in_range%(x%,min%,max%)

  return maximum%(minimum%(x%,max%),min%)

enddef

defproc advice(decision%)

  loc \
    i%,\
    variation%,variations%,\
    datum_col%,\
    paragraph_separation_backup%,\
    deny_effect%

  let datum_col%=29

  wipe yellow%,black%,yellow%

  print_l #ow%,"Consecuencias de "\
    &iso_lower_1$(issue$(decision%))&":"
  end_paragraph #ow%

  advice_section "La popularidad del presidente"

  let variations%=0
  for i%=1 to groups%
    let variation%=decision_popularity_effect%(decision%,i%)
    let variations%=variations%+abs(variation%)
    if variation%
      print #ow%,\
        "-Entre ";plural_name$(i%);\
        to datum_col%;"+"(1 to variation%>0);variation%;
      if soliciting_group%=i% and decision%<25
        print #ow%,"*"
        let deny_effect%=-variation%
      else
        print #ow%
      endif
    endif
  endfor i%

  if not variations%:\
    print #ow%,"Ningún cambio."

  if deny_effect%
    csize #ow%,csize_width%-1,csize_height%
    print_l_paragraph #ow%,\
      "(*) "&deny_effect%&" si la petición es rechazada."
    csize #ow%,csize_width%,csize_height%
  endif

  advice_section "La fuerza de los grupos"

  let variations%=0
  for i%=1 to local_groups%
    let variation%=decision_power_effect%(decision%,i%)
    let variations%=variations%+abs(variation%)
    if variation%
      print #ow%,\
        "-";iso_upper_1$(name$(i%));\
        to datum_col%;"+"(1 to variation%>0);variation%
    endif
  endfor i%

  if not variations%:\
    print #ow%,"Ningún cambio."

  advice_section "La hacienda pública"

  let paragraph_separation_backup%=paragraph_separation%
  let paragraph_separation%=0
  decision_treasury_report decision%
  let paragraph_separation%=paragraph_separation_backup%

  key_press
  cls #ow%

enddef

defproc advice_section(title$)

  under #ow%,1
  print #ow%,\title$
  under #ow%,0

enddef

' ==============================================================
' Secret police report {{{1

defproc police_report

  loc fee%

  let fee%=1 ' in thousands

  wipe black%,white%,black%

  display_police_icon

  if money<=0 \
    or popularity%(police%)<=low% \
    or power%(police%)<=low%

    police_report_not_available

  else

    center #ow%,6,"¿Informe de la policía secreta?"
    center #ow%,12,"(Cuesta "&money$(fee%)&")"
    if yes_key%
      let money=money-fee%
      ordinary_police_report
    endif

  endif

enddef

defproc display_police_icon

  loc icon$,x%

  let icon$=datad$&"img_police_icon_pic"
  let x%=(win_width%(ow%)-pic_width%(icon$)) div 2
  load_pic_win #ow%,icon$,x%,0

enddef

defproc ordinary_police_report

  wipe black%,white%,black%
  print #ow%,"MES ";months%
  ink #ow%,blue%
  at #ow%,3,0
  cls #ow%,1
  police_report_data "INFORME DE LA POLICÍA SECRETA",""

enddef

defproc final_police_report

  wipe black%,white%,black%
  police_report_data "INFORME FINAL","DE LA POLICÍA SECRETA"

enddef

defproc police_report_data(title$,title_continued$)

  loc group%,\
      line%,\
      title_line%,\
      header_line%,\
      data_line%,\
      group_col%,\
      plan_col%,\
      popularity_col%,\
      strength_col%,\
      title_continued%

  let title_continued%=len(title_continued$)>0

  let title_line%=2-title_continued%
  let header_line%=title_line%+2+title_continued%
  let data_line%=header_line%+2

  let group_col%=0
  let plan_col%=10
  let ally_col%=14
  let popularity_col%=17
  let strength_col%=24

  paper #ow%,black%
  ink #ow%,white%
  under #ow%,1
  center #ow%,title_line%,title$
  if title_continued%
    center #ow%,title_line%+1,title_continued$
  endif
  under #ow%,0

  paper #ow%,black%
  ink #ow%,white%

  at #ow%,header_line%,group_col%
  csize #ow%,0,csize_height%
  print #ow%,"Grupo"
  restore_csize

  at #ow%,header_line%,plan_col%
  csize #ow%,0,csize_height%
  print #ow%,"Prepara" ' XXX TODO -- Improve.
  restore_csize

  at #ow%,header_line%,ally_col%
  csize #ow%,0,csize_height%
  print #ow%,"Aliado"
  restore_csize

  at #ow%,header_line%,popularity_col%
  csize #ow%,0,csize_height%
  print #ow%,"Popularidad"
  restore_csize

  at #ow%,header_line%,strength_col%
  csize #ow%,0,csize_height%
  print #ow%,"Fuerza"
  restore_csize

  for group%=1 to groups%

    let line%=data_line%+group%-1

    paper #ow%,bright_white%
    ink #ow%,black%
    at #ow%,line%,group_col%
    print #ow%,group%

    paper #ow%,yellow%
    at #ow%,line%,group_col%+1
    csize #ow%,csize_width%-2,csize_height%
    print #ow%,\
      short_name$(group%);\
      fill$(" ",max_short_name_len%-len(short_name$(group%)))
    restore_csize

    ' Mark possible plan and ally
    if is_main_group%(group%)
      at #ow%,line%,plan_col%
      csize #ow%,0,csize_height%
      paper #ow%,black%
      ink #ow%,red%
      sel on plan%(group%)
        =rebellion%
          print #ow%,"Rebelión"
          restore_csize
          at #ow%,line%,ally_col%
          paper #ow%,white%
          ink #ow%,black%
          print #ow%,ally%(group%)
        =assassination%
          print #ow%,"Magnicidio"
      endsel
      restore_csize
    endif

    if popularity%(group%)
      paper #ow%,green%
      ink #ow%,white%
      at #ow%,line%,popularity_col%
      csize #ow%,csize_width%-1,csize_height%
      print #ow%,"123456789"(to popularity%(group%))
      restore_csize
    endif

    if is_local_group%(group%)
      paper #ow%,red%
      ink #ow%,white%
      at #ow%,line%,strength_col%
      csize #ow%,csize_width%-1,csize_height%
      print #ow%,"123456789"(to power%(group%))
      restore_csize
    endif

  endfor group%

  paper #ow%,black%
  ink #ow%,white%
  paragraph #ow%
  print_l #ow%,"La fuerza de su excelencia es "&strength%&"."
  end_paragraph #ow%
  paragraph #ow%
  print_l #ow%,"La fuerza necesaria para una rebelión es "&rebellion_strength%&"."
  key_press

enddef

deffn is_main_group%(a_group%)

  return a_group%<=main_groups%

enddef

deffn is_local_group%(a_group%)

  return a_group%<=local_groups%

enddef

defproc police_report_not_available

  display_police_icon

  center #ow%,6,"INFORME DE LA POLICÍA SECRETA"
  ink #ow%,bright_white%
  center #ow%,8,"NO DISPONIBLE"
  ink #ow%,white%

  at #ow%,11,0

  if popularity%(police%)<=low%
    print_l_paragraph #ow%,\
      "La popularidad de su excelencia entre la policía es "&\
      popularity%(police%)&"."
  endif

  if power%(police%)<=low%
    print_l_paragraph #ow%,\
      "El poder de la policía es "&\
      power%(police%)&"."
  endif

  if money<=0
    print_l_paragraph #ow%,\
    "La hacienda pública no tiene dinero para pagar \
    los informes de la policía."
  endif

  key_press

enddef

' ==============================================================
' Rebellion {{{1

defproc rebellion

  loc \
    loyal_group%,\
    rebel_group%

  if rebels%
    unavoidable_rebellion
  endif

enddef

defproc unavoidable_rebellion

    rebellion_alarm

    if want_to_escape%
      escape
    else
      fight
    endif

enddef

deffn want_to_escape%

  ' Ask the player to escape. Return 1 (yes) or 0 (no).

  loc yes%

  wipe yellow%,black%,yellow%
  at #ow%,ow_lines% div 2,0
  paper #ow%,bright_yellow%
  cls #ow%,3
  print_l #ow%,"¿Desea su excelencia intentar escapar del país?"
  cls #ow%,4
  let yes%=yes_key%
  paper #ow%,yellow%
  cls #ow%
  ret yes%

enddef

deffn rebels%

  ' Do a random search among all groups.  If a rebel group is found,
  ' return its number.  Otherwise return zero.

  loc i%

  for i%=1 to main_groups%
    let rebel_group%=rnd(1 to main_groups%)
    if plan%(rebel_group%)=rebellion%:\
      exit i%
  next i%
    let rebel_group%=0
  endfor i%

  ret rebel_group%

enddef

defproc fight

  ask_for_help
  rebellion_report
  rebellion_starts

  if rebels_are_stronger%
    the_rebellion_wins
  else
    the_rebellion_is_defeated
  endif

enddef

defproc rebellion_starts

  wipe white%,black%,white%
  print_cc #ow%,"La rebelión ha comenzado"
  war_sfx

enddef

deffn rebels_are_stronger%

  ret not(rebels_strength%<=strength%\
         +power%(loyal_group%)\
         +rnd(-1 to 1))

enddef

defproc rebellion_alarm

  ' XXX TODO -- Improve sound; add flash.

  local i%

  wipe red%,black%,red%
  ink #ow%,white%
  print_cc #ow%,"REBELIÓN"
  for i%=1 to 5:\
    zx_beep .5,20:\
    zx_beep .5,10

enddef

defproc rebellion_report

  cls #ow%
  at #ow%,8,0

  print_l_paragraph #ow%,\
    "La fuerza de su excelencia es "&strength%&"."

  if loyal_group%
    print_l_paragraph #ow%,\
      "La fuerza de "&\
      name$(loyal_group%)&" es "&\
      power%(loyal_group%)&"."
  endif

  print_l_paragraph #ow%,\
    "La fuerza de los rebeldes es "&rebels_strength%&"."

  key_press

enddef

defproc ask_for_help

  local i%,loyal_groups$,k$,group_keys_prompt$

  pause 150
  cls #ow%

  let rebels_strength%=\
    power%(rebel_group%)\
    +power%(ally%(rebel_group%))

  at #ow%,5,0
  print_l_paragraph #ow%,\
    "Se han unido "&\
    name$(rebel_group%)&\
    " y "&\
    name$(ally%(rebel_group%))&"."

  print_l_paragraph #ow%,\
    "Su fuerza conjunta es "&rebels_strength%&"."

  print_l_paragraph #ow%,\
    "¿A quién va a pedir ayuda su excelencia?"

  for i%=1 to local_groups%
    if popularity%(i%)>low%
      print #ow%,to 6;i%;" ";name$(i%)
      let loyal_groups$=loyal_groups$&i%
      let group_keys_prompt$=group_keys_prompt$&i%&" "
    endif
  endfor i%

  let group_keys_prompt$=trim_right$(group_keys_prompt$)

  if len(loyal_groups$)

    rep
      let k$=get_key_prompt$("["&group_keys_prompt$&"]")
      if k$ instr loyal_groups$
        let loyal_group%=k$
        exit
      endif
    endrep

  else

    cls #ow%
    print_cc #ow%,"¡Su excelencia está solo!"
    key_press

  endif

enddef

defproc escape

  if got_helicopter%
    if not escape_by_helicopter%
      escape_on_foot
    endif
  else
    escape_on_foot
  endif

enddef

deffn escape_by_helicopter%

  ' XXX TODO -- Sound.

  if the_helicopter_works%
    do_escape_by_helicopter
  else
    the_helicopter_does_not_work
  endif
  ret escape%

enddef

deffn the_helicopter_works%

  ret rnd(0 to 2)

enddef

defproc do_escape_by_helicopter

  print_cc #ow%,"¡El helicóptero despega!"
  let escape%=1

enddef

defproc the_helicopter_does_not_work

  center #ow%,10,"¡El helicóptero no funciona!"
  pause 150

enddef

defproc escape_on_foot

  at #ow%,8,0
  print_l_paragraph #ow%,\
    "Su excelencia tiene que atravesar el monte a pie hacia Leftoto..."
  pause 200
  cls #ow%

  if not int((rnd*((power%(guerrilla%)/3)+.4)))
    do_escape_on_foot
  else
    the_guerrilla_catchs_you
  endif

enddef

defproc do_escape_on_foot

  at #ow%,12,0
  print_l_paragraph #ow%,\
    "Milagrosamente, la guerrilla no logra atraparlo."
  let escape%=1

enddef

defproc the_guerrilla_catchs_you

  wipe black%,white%,black%
  pause 50
  at #ow%,12,0
  paragraph #ow%
  print_l #ow%,\
    "Por desgracia, la guerrilla lo encuentra \
    antes de que llegue a la frontera..."
  pause 150
  shoot_dead_sfx
  pause 50
  print_l #ow%,\
    "y lo ejecuta."
  end_paragraph #ow%
  let alive%=0

enddef

defproc the_rebellion_wins

  wipe black%,white%,black%
  center #ow%,10,"Su excelencia es capturado"
  center #ow%,11,"por los rebeldes..."
  pause 150
  execution_sfx
  pause 50
  center #ow%,13,"y ejecutado."
  let alive%=0

enddef

defproc the_rebellion_is_defeated

  local i%

  wipe white%,black%,white%
  celebration
  paper #ow%,bright_white%
  center #ow%,10,"¡La rebelión ha sido sofocada!"

  at #ow%,12,0
  print_l #ow%,\
    "¿Ordena su excelencia castigar a los rebeldes?"
  cls #ow%,4

  if yes_key%
    punish_the_rebels
  endif

  let power%(loyal_group%)=9
  let pc%=months%+2

  plot
  police_report

enddef

defproc celebration

  ' XXX TODO -- Rewrite. Do something different.

  loc i%

  at #ow%,0,0

  for i%=0 to ow_lines%-1
    at #ow%,i%,0
    paper #ow%,rnd(1 to 14)
    cls #ow%,3
  endfor i%

enddef

defproc punish_the_rebels

  local i%

  for i%=1 to rnd(2 to 3)
    execution_sfx
    pause 50
  endfor i%

  let popularity%(rebel_group%)=0
  let power%(rebel_group%)=0
  let popularity%(ally%(rebel_group%))=0
  let power%(ally%(rebel_group%))=0

enddef

' ==============================================================
' Treasury {{{1

defproc treasury_report

  wipe white%,green%,green%
  print #ow%,fill$("$",columns%*ow_lines%)
  display_treasury_graph
  paper #ow%,bright_white%
  ink #ow%,black%
  center #ow%,8,"INFORME DE LA HACIENDA PÚBLICA"
  treasury_report_data

enddef

defproc display_treasury_graph

  ' Display the heading graph of the treasury report.

  loc icons%,x%,y%,first_x%,last_x%,icon_image$,icon_width%

  let icons%=8
  let icon_image$=icon_file$("dollar")
  let icon_width%=pic_width%(icon_image$)

  at #ow%,2,1
  let y%=win_ypos%(#ow%)
  let first_x%=win_xpos%(#ow%) div 2
  let last_x%=ow_width%-ow_border_x_width%-icon_width%-first_x%

  for x%=first_x% \
         to last_x% \
         step (last_x%-first_x%) div (icons%-1)
    load_pic_win #ow%,icon_image$,x%,y%
  endfor

enddef

deffn money$(amount)

  ' Return `amount` formatted as money.

  loc digit%,amount$,formatted$,digits%

  let amount$=trim_left$(idec$(abs(amount)*1000,8,0))
  let digits%=len(amount$)

  for digit%=1 to digits%
    let formatted$=amount$(digits%-digit%+1)&formatted$
    if not(digit% mod 3) and digit%<>digits%
      let formatted$=nbsp$&formatted$
    endif
  endfor digit%

  if amount<0
    let formatted$="-"&formatted$
  endif

  ret formatted$&" "&currency$

enddef

defproc treasury_report_data

  loc amount$

  paper #ow%,bright_blue%
  ink #ow%,bright_white%

  at #ow%,12,1
  print #ow%,"Saldo:";
  if money<0
    ink #ow%,bright_red%
  endif
  print_amount ow%,money
  ink #ow%,bright_white%

  at #ow%,14,1
  print #ow%,"Gasto mensual:";
  print_amount #ow%,monthly_payment

  at #ow%,16,1
  print #ow%,"En Suiza:";
  print_amount #ow%,money_in_switzerland

  key_press

enddef

defproc print_amount(channel%,amount)

  loc amount$
  let amount$=money$(amount)
  print #channel%,to columns%-1-len(amount$);amount$

enddef

defproc bankruptcy

  ' XXX TODO -- Improve.

  cls #ow%
  at #ow%,5,0

  print_l_paragraph #ow%,\
    "La hacienda pública está en bancarrota."

  at #ow%,9,0

  print_l_paragraph #ow%,\
    "La popularidad de su excelencia entre el ejército y \
    la policía secreta caerán."

  print_l_paragraph #ow%,\
    "El poder de la policía \
    y el propio poder de su excelencia se reducirán también."

  let popularity%(army%)=popularity%(army%)\
                         -(popularity%(army%)>0)

  let popularity%(police%)=popularity%(police%)\
                           -(popularity%(police%)>0)

  let power%(police%)=power%(police%)\
                      -(power%(police)>0)

  let strength%=strength%-(strength%>0)

  key_press
  plot
  police_report

enddef

defproc decision_treasury_report(decision%)

  loc printout$

  paper #ow%,yellow%
  ink #ow%,black%

  ' XXX TODO -- Factor:
  let decision_cost=10*decision_cost%(decision%)
  let decision_monthly_cost=decision_monthly_cost%(decision%)

  let printout$="Esta decisión"

  if not decision_cost and not decision_monthly_cost

    let printout$=printout$&" no costaría dinero."
    paragraph #ow%
    print_l #ow%,printout$

  else

    if decision_cost

      if decision_cost>0
        let printout$=printout$&" aportaría "
      else
        let printout$=printout$&" costaría "
      endif

      let printout$=printout$&money$(abs(decision_cost))

    endif

    if decision_cost and decision_monthly_cost:\
      let printout$=printout$&" y"

    if decision_monthly_cost

      if decision_monthly_cost<0
        let printout$=printout$&" aumentaría"
      else
        let printout$=printout$&" reduciría"
      endif

      let printout$=printout$\
        &" los gastos mensuales en "\
        &money$(abs(decision_monthly_cost))

    endif

    paragraph #ow%
    print_l #ow%,printout$&"."

    if money+decision_cost>0:\
      ret

    if not(\
         (decision_cost<0 or decision_monthly_cost<0) \
         and \
         (money+decision_cost<0 or money+decision_monthly_cost<0)\
       ):\
      ret
      ' XXX TODO -- Check and factor the condition.

    paragraph #ow%
    print_l #ow%,\
      "La hacienda pública no dispone del dinero necesario."

    ' XXX FIXME -- This message is too long. It scrolls
    ' some screens.
    ' XXX TODO -- Combine into one condition and one message:
    if not is_decision_taken%(38):\
      paragraph #ow%
      print_l #ow%,"Quizá los rusos pueden ayudar."
    if not is_decision_taken%(39):\
      paragraph #ow%
      print_l #ow%,"Los useños son un pueblo generoso"

  endif

enddef

deffn affordable%(decision%)

  ' XXX TODO -- Factor:
  let decision_cost=10*decision_cost%(decision%)
  let decision_monthly_cost=decision_monthly_cost%(decision%)

  if not decision_cost and not decision_monthly_cost
    ret 1
  endif

  if money+decision_cost>0:\
    ret 1

  ret \
     (decision_cost<0 or decision_monthly_cost<0) \
     and \
     (money+decision_cost<0 or money+decision_monthly_cost<0)
    ' XXX TODO -- Check and factor the condition.

enddef

defproc ask_for_loan(decision%)

  loc country%,\
      loan,\
      answer$,\
      answer_line%

  let answer_line%=12

  sel on decision%
    =38:let country%=russia%
    =39:let country%=usa%
  endsel

  wipe yellow%,black%,red%

  paper #ow%,red%
  center #ow%,1,"SOLICITUD DE PRÉSTAMO EXTRANJERO"
  center #ow%,answer_line%,"ESPERE"

  if country%=usa%
    ' tune "2m1j3f3j3m4r1 2v1t3r3j3l4m" ' XXX OLD
    sound "usa"
  else
    ' tune "2g2d3i4d2 2g2d3i4d" ' XXX OLD
    sound "russia"
  endif

  if months%<rnd(3 to 7)

    let answer$="opinan que es demasiado pronto \
      para conceder ayudas ecónomicas."

  else

    if is_decision_taken%(decision%)

      let answer$="te deniegan un nuevo préstamo"

    else

      if popularity%(country%)<=low%
        let answer$="dicen que no, sin ninguna explicación"
      else
        let loan=popularity%(country%)*30+rnd(0 to 199)
        let answer$="conceden un préstamo de "\
          &money$(loan)
        let money=money+loan
        mark_decision_taken decision%
      endif

    endif

  endif

  clear_lines \
    #ow%,answer_line%,answer_line%+1 ' at least 2 lines needed
  at #ow%,answer_line%-1,0
  print_l_paragraph #ow%,\
    iso_upper_1$(plural_name$(country%))&" "&answer$&"."
  cls #ow%,4 ' clear the rest of the possible third line

  key_press

enddef

defproc transfer

  ' XXX TODO -- Improve.

  let transferred_money=0

  cls #ow%
  center #ow%,1,"TRANSFERENCIA"
  center #ow%,2,"A LA CUENTA EN SUIZA"

  if money>0
    do_transfer
    if not transferred_money
      ret
    endif
  else
    print_l_paragraph #ow%,\
      "No hay fondos. \
      La transferencia no puede realizarse."
  endif

  key_press

enddef

defproc do_transfer

  loc i%,valid_options$,prompt$,key$

  at #ow%,4,0

  print_l_paragraph #ow%,\
    "¿Qué cantidad de dinero desea su excelencia \
    transferir desde la hacienda pública \
    a su cuenta personal en Suiza?"

  print #ow%
  for i%=1 to transfer_divisors%
     transfer_option i%
  endfor
  
  let key$=get_key_prompt$(prompt$&" | ...")

  if key$ instr valid_options$

    let transferred_money=money div key$
    let money_in_switzerland=money_in_switzerland+transferred_money
    let money=money-transferred_money

    at #ow%,3,0
    cls #ow%,2
    at #ow%,4,0

    print_l_paragraph #ow%,\
      money$(transferred_money)\
      &" han sido transferidos \
         a la cuenta personal de su excelencia en Suiza."

  endif

enddef

defproc transfer_option(divisor%)

  ' If the given transfer divisor is valid, dispaly its corresponding
  ' menu option and update the related menu variables.

  loc amount%,amount$

  let amount%=money div divisor%

  if valid_transfer%(amount%,divisor%)

    amount$=money$(amount%)
    print #ow%,\
      divisor%;". ";divisor$(divisor%);" ";\
      fill$(".",columns%-5-len(divisor$(divisor%))-len(amount$));\
      to columns%-len(amount$);amount$

    let valid_options$=valid_options$&divisor%
    let prompt$=prompt$&if$(divisor%<>1," | ","")&divisor%

  endif

enddef

deffn valid_transfer%(amount%,part%)

  ' Return 1 if `amount%` is valid, given its corresponding `part%`.
  ' Otherwise return zero.
  '
  ' This check is needed to avoid transfer options that are identical
  ' to the previous one.

  if part%=1
    ret 1
  else
    ret amount%>0 and amount%<(money div (part%-1))
  endif

enddef

' ==============================================================
' News {{{1

defproc news

  if not rnd(0 to 2):\
    newsflash

enddef

defproc newsflash

  loc event%

  let event%=new_event%

  wipe white%,black%,white%

  newsflash_title 10
  newsflash_contents event%
  take_only_once_decision event%
  key_press

  plot
  police_report

enddef

defproc newsflash_contents(event%)

  ' Display the contents of the given newsflash.

  paper #ow%,bright_white%
  ink #ow%,black%
  at #ow%,14,0
  cls #ow%,3 ' clear the line
  print_l #ow%,issue$(event%)&"."
  cls #ow%,4 ' clear the rest of the line

enddef

defproc newsflash_title(flashes%)

  ' Credit:
  ' The siren sound is borrowed from:
  '
  ' SOUNDbytes
  ' By Mike Jonas and Ed Kingsley
  ' http://www.dilwyn.me.uk/sound/
  ' http://www.dilwyn.me.uk/sound/soundbytes.zip

  loc i%,grad_y%

  let grad_y% = 1

  for i%=1 to flashes%

    if i% mod 2
      paper #ow%,white%
      ink #ow%,black%
    else
      paper #ow%,black%
      ink #ow%,white%
    endif

    center #ow%,10,"NOTICIA DE ÚLTIMA HORA"

    beep 10000,6,17,-1,grad_y%
    let grad_y% = -grad_y%
    pause 25

  endfor i%

enddef

deffn new_event%

  ' Return a new random event.

  loc i%,event%

  let event%=rnd(first_event% to last_event%)
  for i%=1 to events%
    if not is_decision_taken%(event%)
      exit i%
    endif
    let event%=event%+1
    if event%>last_event%
      let event%=first_event%
    endif
  endfor i%

  ret event%

enddef

' ==============================================================
' War {{{1

defproc war

  if risk_of_war%
    possible_war
  endif

enddef

deffn risk_of_war%

    ret \
        popularity%(leftoto%)<=low%\
    and power%(leftoto%)>=low%

enddef

defproc possible_war

  ' XXX TODO -- Message.

  if not rnd(0 to 3)
    actual_war
  else
    threat_of_war
  endif

  key_press

enddef

defproc threat_of_war

  ' XXX TODO -- Improve texts.

  loc i%

  wipe black%,white%,cyan%
  at #ow%,6,0
  print_l_paragraph #ow%,\
    "Su excelencia amenaza a Leftoto con la guerra."

  at #ow%,10,0
  print_l_paragraph #ow%,\
    "La popularidad de su excelencia crece en Ritimba."

  for i%=1 to main_groups%,police%
    increase_popularity i%
  endfor i%

enddef

defproc increase_popularity(group%) ' XXX TODO -- Rename.

  local current_popularity%

  ' XXX TODO -- Write a general solution to update the
  ' popularity by any amount, positive or negative.

  let current_popularity%=popularity%(group%)
  let popularity%(group%)=current_popularity%+(current_popularity%<9)

enddef

defproc actual_war

  loc ritimba_strength%,leftoto_strength%

  wipe red%,black%,black%

  center #ow%,8,"¡Leftoto invade Ritimba!" ' XXX TODO -- Improve.

  let ritimba_strength%=ritimba_current_strength%

  at #ow%,12,0
  print_l_paragraph #ow%,\
    "La fuerza de Ritimba es "&ritimba_strength%&"."

  let leftoto_strength%=leftoto_current_strength%

  at #ow%,14,0
  print_l_paragraph #ow%,\
    "La fuerza de Leftoto es "&leftoto_strength%&"."

  at #ow%,16,0
  print_l_paragraph #ow%,"Una corta y decisiva guerra."

  war_sfx

  if ritimba_wins%
    ritimba_wins
  else
    leftoto_wins
  endif

enddef

deffn ritimba_wins%

  ret (leftoto_strength%+rnd(-1 to 1))<ritimba_strength%

enddef

deffn ritimba_current_strength%

  loc i%,ritimba_strength%

  for i%=1 to main_groups%,police%
    if popularity%(i%)>low%:\
      let ritimba_strength%=ritimba_strength%+power%(i%)
  endfor i%

  ret ritimba_strength%+strength%

enddef

deffn leftoto_current_strength%

  loc i%,leftoto_strength%

  for i%=1 to local_groups%
    if popularity%(i%)<=low%:\
      let leftoto_strength%=leftoto_strength%+power%(i%)
  endfor i%

  ret leftoto_strength%

enddef

defproc ritimba_wins

  zx_border black%
  cls #ow%
  center #ow%,12,"Leftoto ha sido derrotado":
  let power%(leftoto%)=0

enddef

defproc leftoto_wins

  ' XXX TODO -- Improve texts and logic.
  ' XXX TODO -- Add sounds.

  wipe black%,white%,black%
  center #ow%,7,"Victoria de Leftoto"

  if have_helicopter% and rnd(0 to 2)

    ' Escape

    at #ow%,10,0
    print_l_paragraph #ow%,\
      "Su excelencia logra escapar en helicóptero."
    let escape%=1

  else

    if have_helicopter%
      at #ow%,10,0
      print_l_paragraph #ow%,\
        "Su excelencia intenta escapar en helicóptero, \
        pero el motor sufre una avería."
      pause 80
    endif

    at #ow%,12,0
    paragraph #ow%
    print_l #ow%,\
      "Su excelencia es acusado de ser un enemigo del pueblo y, \
      tras un juicio sumarísimo,"
    pause 50
    execution_sfx
    pause 50
    print_l #ow%,"ejecutado."
    end_paragraph #ow%
    let alive%=0

  endif

enddef

deffn have_helicopter%

  ret is_decision_taken%(36)

enddef

' ==============================================================
' The end {{{1

defproc the_end

  if alive%
    pause 100
  else
    pause 50
    tune "4d3d1d3d3g1f2f1d2d1d5d"
  endif

  score_report

enddef

defproc score_report

  loc i%,\
      popularity_bonus%,\
      time_bonus%,\
      money_bonus%,\
      alive_bonus%,\
      bonus_col%

  let bonus_col%=28 ' colum where bonus are displayed

  let score%=0

  wipe yellow%,black%,cyan%
  center #ow%,1,"PUNTUACIÓN"

  let popularity_bonus%=0
  for i%=1 to groups%:\
    let popularity_bonus%=\
      popularity_bonus%+popularity%(i%)

  print #ow%,\"Popularidad final:";to bonus_col%;
  print_using #ow%,"####",popularity_bonus%
  let score%=score%+popularity_bonus%

  time_bonus%=months%*3

  print #ow%,\"Por ";months%;" mes";"es"(to 2*(months%<>1));" en el poder:"\
    to bonus_col%;
  print_using #ow%,"####",time_bonus%
  let score%=score%+time_bonus%

  if alive%

    let alive_bonus%=alive%*10
    print #ow%,\"Por seguir con vida:";to bonus_col%;
    print_using #ow%,"####",alive_bonus%
    let score%=score%+alive_bonus%

    if money_in_switzerland
      let money_bonus%=money_in_switzerland div 10
      print #ow%,\"Por los «ahorros» en Suiza"\"(";\
        money$(money_in_switzerland);"):";to bonus_col%;
      print_using #ow%,"####",money_bonus%
      let score%=score%+money_bonus%
    endif

  endif

  print #ow%,\to bonus_col%;"----"

  print #ow%,\"Total:";to bonus_col%;
  paper #ow%,bright_yellow%
  print_using #ow%,"####",score%
  paper #ow%,yellow%

  if score%>record%
    let record%=score%
    print_l_paragraph #ow%,\
      "Sin duda estará usted satisfecho, \
      pues es la mayor puntuación obtenida \
      hasta hoy por un presidente de Ritimba."
  else
    print_l_paragraph #ow%,\
      "La mayor puntuación sigue siendo "&record%&"."
  endif

  key_press
  final_police_report

enddef

' ==============================================================
' Input {{{1

defproc key_prompt(prompt$,colour%)
  paper #iw%,colour%
  ink #iw%,contrast_colour%(colour%)
  cls #iw%
  center #iw%,1,prompt$
  cursen_home #iw%
enddef

deffn get_key_prompt$(prompt$)

  ' Display the given prompt in the input window and return the
  ' pressed key.

  rep dont_press_now

    if inkey$(#iw%)="":\
      exit dont_press_now

  endrep dont_press_now

  rep press_now

    key_prompt prompt$,prompt_colour_1%
    let key$=inkey$(#iw%,50)
    if key$<>"":\
      exit press_now
    zx_beep .01,30

    key_prompt prompt$,prompt_colour_2%
    let key$=inkey$(#iw%,50)
    if key$<>"":\
      exit press_now
    zx_beep .01,20

  endrep press_now

  paper #iw%,prompt_colour_1%

  curdis #iw%

  ret key$

enddef

deffn get_key$
  ret get_key_prompt$("...")
enddef

deffn yes_key%

  loc key$,yes%

  repeat
    let key$ = get_key_prompt$('Sí | No')
    if key$ instr "NSns"
      exit
    endif
  endrep

  let yes%=(key$=="s")
  cls #iw%
  zx_beep .25,10+40*yes% ' XXX TODO -- Improve.

  ret yes%

enddef

defproc key_press
  loc key$
  let key$=get_key$
enddef

deffn decision_option%

  ' Wait for a decision. Display the three options in the input window
  ' (yes, no, and advice) and return its value (No=0, Yes=1,
  ' Advice=2).

  loc key$,decision%

  repeat
    let key$ = get_key_prompt$('Sí  |  No  |  Consejo')
    if key$ instr "CNScns"
      exit
    endif
  endrep

  let decision%=(key$ instr "NnSsCc") div 2
  cls #iw%
  zx_beep .25,10+40*decision% ' XXX TODO -- Improve.

  ret decision%

enddef

' ==============================================================
' Data interface {{{1

defproc mark_decision_taken(decision%)

  ' Mark a decision taken.

  let issue_data$(decision%,1)="*"

enddef

defproc restore_petitions

  ' Mark all petitions not done.

  loc i%

  for i%=1 to petitions%:\
    let issue_data$(i%,1)="N"

enddef

defproc restore_decisions

  ' Mark all decisions not done.

  loc i%

  for i%=1 to issues%:\
    let issue_data$(i%,1)="N"

enddef

deffn is_decision_taken%(decision%)

  ret issue_data$(decision%,1)="*"

enddef

deffn got_helicopter%

  ret is_decision_taken%(36)

enddef

deffn decision_cost%(decision%)

  ret code(issue_data$(decision%,2))-code("M")

enddef

deffn decision_monthly_cost%(decision%)

  ret code(issue_data$(decision%,3))-code("M")

enddef

deffn decision_popularity_effect%(decision%,group%)

  ret code(issue_data$(decision%,group%+3))-code("M")

enddef

deffn decision_power_effect%(decision%,group%)

  ret code(issue_data$(decision%,group%+11))-code("M")

enddef

' ==============================================================
' Data {{{1

defproc init_data

  loc x$ ' XXX TMP --

  let issue_max_len%=70
  dim \
    issue$(issues%,issue_max_len%),\
    issue_data$(issues%,17)

  ' XXX TODO -- Calculate max lengths.
  let max_short_name_len%=17

  dim \
    popularity%(groups%),\
    power%(groups%),\
    plan%(groups%),\
    ally%(groups%),\
    name$(groups%,18),\
    short_name$(groups%,max_short_name_len%),\
    plural_name$(groups%,21),\
    genitive_name$(groups%,21),\
    member$(groups%,15)

  restore @plot_data

  for i%=1 to issues%:
    read issue_data$(i%),x$
    if len(x$)>issue_max_len%
      ' XXX TMP --
      print "ERROR: issue name too long:"\x$
      stop
    else
      let issue$(i%)=x$
    endif
  endfor i%

  restore @groups_data

  for i%=1 to groups%
    read \
      popularity%(i%),\
      power%(i%),\
      plan%(i%),\
      ally%(i%),\
      name$(i%),\
      short_name$(i%),\
      plural_name$(i%),\
      genitive_name$(i%),\
      member$(i%)
  endfor i%

  dim icon$(main_groups%,10)

  restore @icons_data

  for i%=1 to main_groups%
    read icon$(i%)
  endfor i%

  let decision_sections%=5
  let section_max_len%=21

  dim \
    decision_section$(decision_sections%,section_max_len%),\
    first_decision%(decision_sections%),\
    last_decision%(decision_sections%)

  restore @decisions_data

  for i%=1 to decision_sections%
    read \
      decision_section$(i%),\
      first_decision%(i%),\
      last_decision%(i%)
  endfor

  ' XXX TODO -- Not needed except to play again, what
  ' needs more restoration:
  restore_decisions

  let transfer_divisors%=5
  dim divisor$(transfer_divisors%,9)

  restore @transfer_divisor_data
  
  for i%=1 to transfer_divisors%
    read divisor$(i%)
  endfor

  let money=1000
  let transferred_money=0 ' in the latest transfer only
  let escape%=0
  let monthly_payment=60
  let strength%=4
  let money_in_switzerland=0
  let alive%=1
  let months%=0
  let pc%=0 ' XXX TODO -- What for?
  let rebellion_strength%=10

enddef

' ----------------------------------------------
' Petitions, decisions and events data

' XXX REMARK --
' Character fields in issue_data$():

' 01: decision already taken ("N"=no, "*"=yes)
' 02: cost (in thousands)
' 03: monthly cost (in thousands)
' 04..11: +/- popularity for groups 1-8
' 12..17 +/- power for groups% 1-6 (..."K"=-1, "L"=-1,"M"=0, "N"=1...)

' Fields 02..17 contain a letter ("G".."S") which represents a
' number calculated from its ASCII code, being "M" zero.
' Examples: ... "K"=-1, "L"=-1,"M"=0, "N"=1...

label @plot_data

' ..............................
' Petitions from the army (8)

data "NMHQJLMMMMMPKLMMM",\
     "Instaurar el servicio militar obligatorio"
data "NMMPMJMMMMMNMLMMM",\
     "Requisar tierras para construir un polígono de tiro"
data "NCMPLNMLMLMNMNIMM",\
     "Atacar las bases de la guerrilla"
data "NEMPLMMIMLMNMNKMM",\
     "Atacar la base de la guerrilla en Leftoto"
data "NMMQONMMIMMNMNMMJ",\
     "Destituir al jefe de la policía secreta"
data "NMMPMMMLMIOMMMMMM",\
     "Echar a los militares rusos"
data "NMDQMLMMMMMOLLLMM",\
     "Aumentar la paga de las tropas"
data "NAMQLLMLLMMPLLKLM",\
     "Comprar más armas y municiones"

' ..............................
' Petitions from the peasants (8)

data "NMMLONMMMMMLMMLMM",\
     "Poner freno a los abusos del ejército"
data "NMMMQIMNMMMMOLMMM",\
     "Aumentar el salario mínimo"
data "NMPNQOMMIMMNNNNMJ",\
     "Acabar con la policía secreta"
data "NMMMPKMKMMMMOKMMM",\
     "Detener la inmigración de Leftoto"
data "NCELQKMOLNMMNLLMM",\
     "Poner escuela gratis para todos"
data "NMMMQJMNLNMMPJMML",\
     "Legalizar los sindicatos"
data "NMMLQKMNLMMMOLLMM",\
     "Liberar a su líder encarcelado"
data "NMSMPLMMMMMMMMLMM",\
     "Iniciar una lotería pública"

' ..............................
' Petitions from the landowners (8)

data "NMMKMPMMMMMLMMMMM",\
     "Prohibir el uso militar de sus tierras"
data "NMMMIQMLMLMMKONMM",\
     "Bajar el salario mínimo"
data "NWHMMPMNMOIMMNMMM",\
     "Nacionalizar las empresas useñas"
data "NMRMMPMJMLMMNOMLM",\
     "Tasar las importaciones de leftoto"
data "NMQNNPMMIMMNMNNMK",\
     "Cortar los gastos de la policía secreta"
data "NMHMMQMMMMMMMOMMM",\
     "Bajar el impuesto sobre la tierra"
data "NMMKLPMMMMMLLNNMM",\
     "Ceder tropa para labrar tierra"
data "NACNNPMJMONMMPMKM",\
     "Construir un sistema de riego"

' ..............................
' Decisions

data "NMMQLLMMLMMNMMLML",\
     "Nombrar ministro al jefe del ejército"
data "NLILQNMOMNMMMMLMM",\
     "Construir hospitales para los trabajadores"
data "NMMLKQMMLLMLLOMML",\
     "Dar poderes a los terratenientes"
data "NRMKMMMQMKNLMMLPM",\
     "Vender armas useñas a Leftoto"
data "NYMMMLMLMKPMMMMMM",\
     "Vender derechos a empresas useñas"
data "NMWKMMMMMPJMMMMNM",\
     "Alquilar a Rusia una base naval"
data "NMENPPMMMMMLMMLMM",\
     "Bajar los impuestos"
data "NEMPPPMMMMMMMMLMM",\
     "Hacer una campaña de imagen presidencial"
data "NMUPPPMMDMMONNNMD",\
     "Reducir el poder de la policía secreta"
data "NMGJJJMMUMMLLLLMU",\
     "Aumentar el poder de la policía secreta"
data "NIMKLLMMLMMKMMMML",\
     "Aumentar el número de guardaespaldas"
data "NAMIIJMMKMMMMMMMM",\
     "Comprar un helicóptero para una posible huida del país"
data "NMMMMMMMMMMMMMMMM",\
     "Hacer una transferencia a la cuenta presidencial \
     en Suiza"
data "NMMMMMMMMMMMMMMMM",\
     "Solicitar un préstamo a los rusos"
data "NMMMMMMMMMMMMMMMM",\
     "Solicitar un préstamo a los useños"
data "NZMNNPMGMKMMMMMMM",\
     "Nacionalizar las empresas de Leftoto"
data "NHMPMMMJMLMRMMKKL",\
     "Comprar armas para el ejército"
data "NMMMPLMMLMMMRLPML",\
     "Legalizar las asociaciones campesinas"
data "NMMLLPMMLMMLLRLML",\
     "Permitir que los terratenientes tengan ejércitos privados"

' ..............................
' Events

data "NMMMMMMMIMMMMMQMI",\
     "Los archivos de la policía secreta han sido robados"
data "NMMMMMMMMMMLMMVMM",\
     "Cuba está entrenando a la guerrilla"
data "NMMMMMMMMMMIMMOMN",\
     "Un barracón del ejército ha explotado"
data "NMMMMMMMMMMMMJMKM",\
     "El precio de los plátanos ha caído un 98%"
data "NMMMMMMMMMMMMOMIM",\
     "El jefe del estado mayor del ejército se ha fugado a Leftoto"
data "NMMMMMMMMMMMILKMM",\
     "Se ha declarado una epidemia entre los campesinos"

' ----------------------------------------------
' Groups data

' popularity%(i%):  0..9
' power%(i%):       0..9
' plan%(i%):        none% | rebellion% | assassination%
' ally%(i%):        none% | group
' name$(i%)
' short_name$(i%)
' plural_name$(i%)
' genitive_name$(i%)

label @groups_data

data 7,6,none%,none%,\
     "el ejército",\
     "ejército",\
     "los militares",\
     "del ejército",\
     "militar"
data 7,6,none%,none%,\
     "los campesinos",\
     "campesinos",\
     "los campesinos",\
     "de los campesinos",\
     "campesino"
data 7,6,none%,none%,\
     "los terratenientes",\
     "terratenientes",\
     "los terratenientes",\
     "de los terratenientes",\
     "terrateniente"
data 0,6,none%,none%,\
     "la guerrilla",\
     "guerrilla",\
     "los guerrilleros",\
     "de la guerrilla",\
     "guerrillero"
data 7,6,none%,none%,\
     "Leftoto",\
     "leftotanos",\
     "los leftotanos",\
     "de Leftoto",\
     "leftotano"
data 7,6,none%,none%,\
     "la policía secreta",\
     "policía secreta",\
     "los policías secretos",\
     "de la policía secreta",\
     "policía secreto"
data 7,0,none%,none%,\
     "Rusia",\
     "rusos",\
     "los rusos",\
     "de Rusia",\
     "ruso"
data 7,0,none%,none%,\
     "Usa",\
     "useños",\
     "los useños",\
     "de Usa",\
     "useño"

label @icons_data

data "army"
data "peasants"
data "landowners"

label @decisions_data

' Data: section title, first decision, last decision

data "Complacer a un grupo ",25,30
data "Complacer a todos    ",31,33
data "Aumentar los ingresos",38,40
data "Fortalecer a un grupo",41,43
data "Asuntos privados     ",34,37

label @transfer_divisor_data

data "Todo"
data "La mitad"
data "Un tercio"
data "Un cuarto"
data "Un quinto"

' ==============================================================
' Special effects {{{1

defproc zx_border(colour%)

  border #ow%,ow_border_width%,colour%
  paper #bw%,colour%
  cls #bw%

enddef

defproc war_sfx
  sel on rnd(0 to 1)
    =0:sound "war"
    =1:sound "gunbattle"
  endsel
enddef

defproc execution_sfx
  sel on rnd(0 to 2)
    =0:sound "star9mm":sound "9mmgunshot"
    =1:sound "p90gunfire"
    =2:sound "p90machinegunfire"
  endsel
enddef

defproc shoot_dead_sfx
  sel on rnd(0 to 3)
    =0:sound "9mmgunshot"
    =1:sound "p90gunfire"
    =2:sound "p90machinegunfire"
    =3:sound "shotgunmossberg"
  endsel
enddef

defproc sound(basefile$)
  ' Play a sound file.
  soundfile datad$&"snd_"&basefile$&".ub"
  ' copy datad$&"snd_"&basefile$&".ub",sound1 ' XXX TMP --
enddef

deffn sounding%
 
  ' XXX TODO --

  ret 0
  
enddef

defproc tune(score$)

  loc note%

  for note%=1 to len(score$) step 2
    if score$(note%+1)=" "
      pause code(score$(note%))/4
    else
      zx_beep (code(score$(note%))-code("0"))/6,\
               code(score$(note%+1))-code("i")
    endif
  endfor note%

enddef

' ==============================================================
' Stock code {{{1

' deffn if%(flag%,true%,false%)
'   ' XXX REMARK -- Not used.
'   if flag%:\
'     ret true%:\
'   else:\
'     ret false%
' enddef

deffn if$(flag%,true$,false$)
  if flag%:\
    ret true$:\
  else:\
    ret false$
enddef

' ==============================================================
' Text output {{{1

defproc wipe(paper_colour%,ink_colour%,border_colour%)

  ' Clear the windows with the given colour combination.

  paper #ow%,paper_colour%
  ink #ow%,ink_colour%
  zx_border border_colour%
  cls #ow%
  paper #iw%,border_colour%
  cls #iw%
  let prompt_colour_1%=border_colour%
  let prompt_colour_2%=paper_colour%
  if prompt_colour_1%=prompt_colour_2%
    let prompt_colour_2%=contrast_colour%(prompt_colour_1%)
  endif
  zx_beep .1,40

enddef

deffn center_for%(width_in_chars%)

  ret (columns%-width_in_chars%) div 2

enddef

defproc center(channel%,line%,text$)

  loc length%,\
      i%,\
      first_part$,\
      first_part_length%

  let length%=len(text$)

  if length%>columns%

    ' The text does not fit in one line.
    ' Split it into several lines.

    for i%=columns%+1 to 1 step -1

      if text$(i%)=" "

        let first_part$=trim$(text$(to i%-1))
        let first_part_length%=len(first_part$)
        at #channel%,line%,center_for%(first_part_length%)

        center channel%,line%+1,text$(i%+1 to)

        exit i%

      endif

    next i%

      ' No way to split the text, so print it left justified.

      at #channel%,line%,0
      print_l #channel%,text$

    endfor i%

  else

    ' The text fits in one line.

    at #channel%,line%,center_for%(length%)
    print #channel%,text$

  endif

enddef

defproc restore_csize

  csize #ow%,csize_width%,csize_height%

enddef

defproc item(channel%,item%,item$)

  ' Display list item with number `item%` and text `item$` on window
  ' `channel%`.

  loc indentation%,\         ' min column usable by the item string
      width%,\               ' columns usable by the item string
      len%,\                 ' lenght of the item string
      first_char%,last_char% ' slice of item

  let len%=len(item$)

  print #channel%,item%&". ";
  let indentation%=win_column%(channel%)
  let width%=win_columns%(channel%)-indentation%
  #ifdef debugging
    print #dw%,"indentation%=";indentation%
    print #dw%,"width%=";width%
  #endif
  let first_char%=1
  let last_char%=minimum%(first_char%+width%,len%)

  rep

    #ifdef debugging
      print #dw%,"first_char%=";first_char%;"=(";item$(first_char%);")"
      print #dw%,"last_char%=";last_char%;"=(";item$(last_char%);")"
      print #dw%,"<";item$(first_char% to last_char%);">"
    #endif

    if item$(last_char%)=" "
      #ifdef debugging
        print #dw%,"Space!"
      #endif
      print #channel%,item$(first_char% to last_char%-1)
      let first_char%=last_char%+1
      let last_char%=minimum%(first_char%+width%,len%)
      print #channel%,to indentation%;
    else
      if (last_char%-first_char%+1)<=width% and last_char%=len%
        #ifdef debugging
          print #dw%,"FIT!"
        #endif
        print #channel%,item$(first_char% to last_char%);
        exit
      else
        #ifdef debugging
          print #dw%,"1 less..."
        #endif
        let last_char%=last_char%-1
      endif
    endif

  endrep

  print #channel%

enddef

' ==============================================================
' Screen {{{1

deffn contrast_colour%(colour%)

  sel on colour%
    =black%,\
     blue%,brigth_blue%,\
     red%,brigth_red%,\
     purple%,brigth_purple%:\
      ret white%
    =remainder:\
      ret black%
  endsel

enddef

defproc cursen_home(channel%)

  loc line%
  sel on channel%
    =iw%:line%=iw_lines%-1
    =ow%:line%=ow_lines%-1
  endsel
  cursen #channel%
  at #channel%,line%,columns%-1

enddef

deffn ow_line_y(line%)
  ' Return the y pixel coord of the given line in #ow%.
  ret char_height_pixels%*line%
enddef

deffn column_x%(column%)
  ' Return the x% pixel coord of the given column in #ow%.
  ' XXX REMARK -- Not used yet.
  ret char_width_pixels%*column%
enddef

defproc fonts(font_address)
  char_use #iw%,font_address,0
  char_use #ow%,font_address,0
enddef

defproc iso_font
  fonts font_address
enddef

defproc ql_font
  fonts 0
enddef

deffn icon_file$(icon_id$)
  ret datad$&"img_"&icon_id$&"_icon_pic"
enddef

defproc clear_lines(channel%,first_line%,last_line%)

  ' Clear the given range of lines of window `channel%`.  At the end
  ' the cursor is at the start of `first_line%`.

  loc i%

  for i%=last_line% to first_line% step -1
    at #channel%,i%,0
    cls #channel%,3
  endfor

enddef

' ==============================================================
' Init {{{1

defproc init_font

  let font$="iso8859-1_font"
  font_length=flen(\font$)
  font_address=alchp(font_length)
  lbytes font$,font_address
  iso_font

enddef

defproc init_windows

  loc lines%

  let columns%=32
  let lines%=26

  let csize_width%=3
  let csize_height%=1
  let char_width_pixels%=csize_width_pixels%(csize_width%)
  let char_height_pixels%=csize_height_pixels%(csize_height%)

  let iw%=fopen("con_") ' input window
  let ow%=fopen("scr_") ' output window
  let bw%=fopen("con_") ' bottom border window

  let iw_lines%=3
  let ow_lines%=lines%-iw_lines%
  let ow_border_width%=char_width_pixels%

  csize #iw%,csize_width%,csize_height%
  csize #ow%,csize_width%,csize_height%

  let ow_border_x_width%=ow_border_width%*4
  let ow_border_y_width%=ow_border_width%*2

  let ow_width%=columns%*char_width_pixels%+ow_border_x_width%
  let iw_width%=columns%*char_width_pixels%
  let bw_width%=ow_width%

  let ow_height%=ow_lines%*char_height_pixels%+ow_border_y_width%
  let iw_height%=iw_lines%*char_height_pixels%
  let bw_height%=iw_height%+ow_border_width%

  if windows_do_not_fit%
    init_font
    print_l #ow%,"Error fatal:"
    print_l #ow%,"La resolución de pantalla es insuficiente."
    print_l #ow%,"Este programa necesita una resolución mínima de "\
      &ow_width%&"x"&(ow_height%+iw_height%)&"."
    stop
  endif

  let ow_x%=(scr_xlim-ow_width%)/2
  let ow_y%=(scr_ylim-ow_height%-iw_height%)/2

  let iw_x%=(scr_xlim-iw_width%)/2
  let iw_y%=ow_y%+ow_height%

  let bw_x%=ow_x%
  let bw_y%=iw_y%

  window #ow%,ow_width%,ow_height%,ow_x%,ow_y%
  window #iw%,iw_width%,iw_height%,iw_x%,iw_y%
  window #bw%,bw_width%,bw_height%,bw_x%,bw_y%

  let blank_line$=fill$(" ",columns%)

  #ifdef debugging
  
    let dw%=fopen("scr_") ' debug window
    window #dw%,\
      scr_xlim-ow_x%-ow_width%,\
      scr_ylim,\
      ow_x%+ow_width%,\
      0
    paper #dw%,black%
    ink #dw%,red%
    csize #dw%,1,1
    border #dw%,4,black%

  #endif

enddef

deffn windows_do_not_fit%

  ret ow_width%>scr_xlim \
      or \
      (ow_height%+maximum%(iw_heigth%,bw_height%))>scr_ylim

enddef

defproc init_screen

  colour_pal

  palette_8 blue%,$0000D7   ' ZX Spectrum
  palette_8 red%,$D70000    ' ZX Spectrum
  palette_8 purple%,$D700D7 ' ZX Spectrum
  palette_8 green%,$00C000  ' modified
  palette_8 cyan%,$00D7D7,  ' ZX Spectrum
  palette_8 yellow%,$C0C000 ' modified
  palette_8 white%,$D7D7D7  ' ZX Spectrum

  let paragraph_separation%=1
  let paragraph_indentation%=0

enddef

defproc init_once

  randomise
  init_constants
  init_screen
  init_windows
  init_font
  init_zx_beep
  let score%=0
  let record%=0

enddef

defproc init_constants

  let black%=0
  let bright_white%=1
  let bright_red%=2
  let bright_green%=3
  let bright_blue%=4
  let bright_purple%=5
  let bright_yellow%=6
  let bright_cyan%=7
  let blue%=8
  let red%=9
  let purple%=10
  let green%=11
  let cyan%=12
  let yellow%=13
  let white%=14

  let issues%=49
  let petitions%=24

  let groups%=8
  let main_groups%=3  ' only the groups that can rebel
  let local_groups%=6 ' all groups but Russia and USA

  let nbsp$=chr$(160) ' non-breaking space in ISO 8859-1

  let currency$="RTD" ' Ritimban dolar

  ' Group ids
  let army%=1
  let peasants%=2
  let landowners%=3
  let guerrilla%=4
  let leftoto%=5
  let police%=6
  let russia%=7
  let usa%=8

  ' Plan identifiers
  let none%=-1 ' also used as ally identifier
  let rebellion%=1
  let assassination%=2

  ' Events
  let first_event%=44
  let last_event%=49
  let events%=last_event%-first_event%+1

enddef

' ==============================================================
' Meta {{{1

' #ifdef debugging ' XXX TODO --

defproc debug_(message$)
  if 1
    print #ow%,message$
    pause
  endif
enddef

defproc finish ' XXX TMP --
  close
  ql_font
  rechp font_address
enddef

defproc advices
  loc i%
  for i%=1 to first_event%-1
    advice i%
  endfor
enddef

defproc bmps_to_pic

  ' Convert some BMP images to PIC.

  loc d$
  let d$=datad$&"img_"

  bmp_to_pic d$&"usa_flag.bmp",d$&"usa_flag_pic"
  bmp_to_pic d$&"ussr_flag.bmp",d$&"ussr_flag_pic"

enddef

defproc lp(x%,y%)

  ' Test the loading of PIC files in the screen.

  load_pic datad$&"img_army_icon_pic",x%,y%

enddef

defproc lpw(x%,y%)

  ' Test the loading of PIC files in a window.

  load_pic_win #ow%,datad$&"img_army_icon_pic",x%,y%

enddef

defproc checkw

  loc i%

  for i%=0 to 10
    at #ow%,i%,i%
    print #ow%,win_xpos%(#ow%);",",win_ypos%(#ow%)
  endfor

enddef

defproc ci

  ' Check `item`

  paper #ow%,yellow%
  ink #ow%,black%
  cls
  cls #ow%
  item #ow%,1,\
    "En un lugar de La Mancha, \
    de cuyo nombre no quiero acordarme, \
    no ha mucho que vivía un hidalgo."

enddef

defproc item_v0(channel%,item%,item$)

  ' Display list item with number `item%` and text `item$` on window
  ' `channel%`.

  loc indentation%,\         ' min column usable by the item string
      width%,\               ' columns usable by the item string
      len%,\                 ' lenght of the item string
      first_char%,last_char% ' slice of item

  let len%=len(item$)

  print #channel%,item%&". ";
  let indentation%=win_column%(channel%)
  let width%=win_columns%(channel%)-indentation%
  let first_char%=1
  let last_char%=minimum%(first_char%+width%,len%)

  rep

    if (last_char%-first_char%+1)<=width% and last_char%=len%
      print #channel%,item$(first_char% to last_char%);
      exit
    else
      if item$(last_char%)=" "
        print #channel%,item$(first_char% to last_char%-1)
        let first_char%=last_char%+1
        let last_char%=minimum%(first_char%+width%,len%)
        print #channel%,to indentation%;
      else
        let last_char%=last_char%-1
      endif
    endif

  endrep

  print #channel%

enddef

defproc item_v1(channel%,item%,item$)

  ' Display list item with number `item%` and text `item$` on window
  ' `channel%`.

  loc indentation%,\         ' min column usable by the item string
      width%,\               ' columns usable by the item string
      len%,\                 ' lenght of the item string
      first_char%,last_char% ' slice of item

  let len%=len(item$)

  print #channel%,item%&". ";
  let indentation%=win_column%(channel%)
  let width%=win_columns%(channel%)-indentation%
  let first_char%=1
  let last_char%=minimum%(first_char%+width%,len%)

  rep

    if item$(last_char%)=" "
      print #channel%,item$(first_char% to last_char%-1)
      let first_char%=last_char%+1
      let last_char%=minimum%(first_char%+width%,len%)
      print #channel%,to indentation%;
    else
      if (last_char%-first_char%+1)<=width% and last_char%=len%
        print #channel%,item$(first_char% to last_char%);
        exit
      else
        let last_char%=last_char%-1
      endif
    endif

  endrep

  print #channel%

enddef

defproc item_v2(channel%,item%,item$)

  ' Display list item with number `item%` and text `item$` on window
  ' `channel%`.

  loc indentation%,\         ' min column usable by the item string
      width%,\               ' columns usable by the item string
      len%,\                 ' lenght of the item string
      first_char%,last_char% ' slice of item

  let len%=len(item$)

  print #channel%,item%&". ";
  let indentation%=win_column%(channel%)
  let width%=win_columns%(channel%)-indentation%
  let first_char%=1
  let last_char%=minimum%(first_char%+width%,len%)

  rep

    if item$(last_char%)=" "
      print #channel%,item$(first_char% to last_char%-1)
      let first_char%=last_char%+1
      let last_char%=minimum%(first_char%+width%,len%)
      print #channel%,to indentation%;
      next
    else
      if (last_char%-first_char%+1)<=width% and last_char%=len%
        print #channel%,item$(first_char% to last_char%);
        exit
      else
        let last_char%=last_char%-1
      endif
    endif

  endrep

  print #channel%

enddef

defproc item_v3(channel%,item%,item$)

  ' Display list item with number `item%` and text `item$` on window
  ' `channel%`.

  loc indentation%,\         ' min column usable by the item string
      width%,\               ' columns usable by the item string
      len%,\                 ' lenght of the item string
      first_char%,last_char% ' slice of item

  let len%=len(item$):\

  print #channel%,item%&". ";:\
  let indentation%=win_column%(channel%):\
  let width%=win_columns%(channel%)-indentation%:\
  let first_char%=1:\
  let last_char%=minimum%(first_char%+width%,len%)

  rep

    if item$(last_char%)=" "
      print #channel%,item$(first_char% to last_char%-1):\
      let first_char%=last_char%+1:\
      let last_char%=minimum%(first_char%+width%,len%):\
      print #channel%,to indentation%;:\
      next
    else
      if (last_char%-first_char%+1)<=width% and last_char%=len%
        print #channel%,item$(first_char% to last_char%);:\
        exit
      else
        let last_char%=last_char%-1
      endif
    endif

  endrep

  print #channel%

enddef

defproc bi(times%)

  ' Bench several variants of `item`, displaying a long text the given
  ' number of `times%`.

  loc t,i%,txt$

  let txt$=\
    "En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no \
    ha mucho tiempo que vivía un hidalgo de los de lanza en astillero, \
    adarga antigua, rocín flaco y galgo corredor. Una olla de algo más \
    vaca que carnero, salpicón las más noches, duelos y quebrantos los \
    sábados, lantejas los viernes, algún palomino de añadidura los \
    domingos, consumían las tres partes de su hacienda. El resto della \
    concluían sayo de velarte, calzas de velludo para las fiestas, con \
    sus pantuflos de lo mesmo, y los días de entresemana se honraba \
    con su vellorí de lo más fino. Tenía en su casa una ama que pasaba \
    de los cuarenta, y una sobrina que no llegaba a los veinte, y un \
    mozo de campo y plaza, que así ensillaba el rocín como tomaba la \
    podadera. Frisaba la edad de nuestro hidalgo con los cincuenta \
    años; era de complexión recia, seco de carnes, enjuto de rostro, \
    gran madrugador y amigo de la caza. Quieren decir que tenía el \
    sobrenombre de Quijada, o Quesada, que en esto hay alguna \
    diferencia en los autores que deste caso escriben; aunque, por \
    conjeturas verosímiles, se deja entender que se llamaba Quejana. \
    Pero esto importa poco a nuestro cuento; basta que en la narración \
    dél no se salga un punto de la verdad. \
    Es, pues, de saber que este sobredicho hidalgo, los ratos que \
    estaba ocioso, que eran los más del año, se daba a leer libros de \
    caballerías, con tanta afición y gusto, que olvidó casi de todo \
    punto el ejercicio de la caza, y aun la administración de su \
    hacienda. Y llegó a tanto su curiosidad y desatino en esto, que \
    vendió muchas hanegas de tierra de sembradura para comprar libros \
    de caballerías en que leer, y así, llevó a su casa todos cuantos \
    pudo haber dellos; y de todos, ningunos le parecían tan bien como \
    los que compuso el famoso Feliciano de Silva, porque la claridad \
    de su prosa y aquellas entricadas razones suyas le parecían de \
    perlas, y más cuando llegaba a leer aquellos requiebros y cartas \
    de desafíos, donde en muchas partes hallaba escrito: La razón de \
    la sinrazón que a mi razón se hace, de tal manera mi razón \
    enflaquece, que con razón me quejo de la vuestra fermosura. Y \
    también cuando leía: ...los altos cielos que de vuestra divinidad \
    divinamente con las estrellas os fortifican, y os hacen merecedora \
    del merecimiento que merece la vuestra grandeza."

  cls

  let t=date:\
  for i%=1 to times%:\
    at 0,0:\
    item_v0 0,1,txt$

  print "v0: ";date-t;" seconds"

  let t=date:\
  for i%=1 to times%:\
    at 0,0:\
    item_v1 0,1,txt$

  print \"v1: ";date-t;" seconds"

  let t=date:\
  for i%=1 to times%:\
    at 0,0:\
    item_v2 0,1,txt$

  print \\"v2: ";date-t;" seconds"

  let t=date:\
  for i%=1 to times%:\
    at 0,0:\
    item_v3 0,1,txt$

  print \\\"v3: ";date-t;" seconds"

  ' Results:
  '
  ' times    v0    v1    v2   v3
  '  64      45    44    44
  ' 256     179   177   177  179

enddef

defproc s(basefile$)
  ' Play a sound file.
  soundfile datad$&"snd_"&basefile$&".ub"
enddef

defproc s2(basefile$)
  ' Play a sound file in background.
  soundfile2  datad$&"snd_"&basefile$&".ub"
enddef

' #endif ' XXX TODO --

' vim: filetype=sbim textwidth=70
