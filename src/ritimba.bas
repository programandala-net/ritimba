rem Ritimba

version$="0.1.0-dev.49+201710072224"

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
' Files and requirements {{{1

' From "DIY Toolkit", (C) Simon N. Goodwin:
'   minimum, maximum
' (Loaded by the <boot> file.)

#include lib/iso_lower.bas
#include lib/iso_upper.bas
#include lib/print_l.bas
#include lib/trim.bas

' ==============================================================
' Main loop {{{1

defproc ritimba

  loc i%

  init_once
  rep
    credits
    key_press
    init_data
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
      treasure_report
      plot
      police_report
      news
      revolution
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
  print #ow%,"Ritimba"
  print #ow%,\\"Por:"\"Marcos Cruz (programandala.net),"
  print #ow%,\"2011, 2012, 2015, 2016, 2017"
  print #ow%,\\"Una versión en SBASIC de"
  print #ow%,"Dictador, de Don Priestley, 1983"
enddef

defproc national_flag

  loc i%,\
    flag_width%,flag_height%,flag_x%,flag_y%,\
    stars_width%,stars_height%,stars_x%,stars_y%,stars_row$,\
    bar_colour%

  let flag_width%=22  ' in chars
  let flag_height%=12 ' in chars
  let flag_x%=center_for(flag_width%)
  let flag_y%=8

  let stars_width%=4  ' in chars
  let stars_height%=4 ' in chars
  let stars_row$=fill$("*",stars_width%)
  let stars_x%=center_for(stars_width%)
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

defproc tapestry(text$)
  loc i%,times%
  let times%=columns%*ow_lines%/len(text$)
  for i%=1 to times%
    print #ow%,text$;" ";
    zx_beep .01,40-i%+rnd*10
  endfor i%
enddef

defproc title
  loc i%
  wipe cyan%,black%,black%
  tapestry "Ritimba"
  national_flag
  for i%=1 to 50:
    zx_beep .03,i%
  paper #ow%,white%
  ink #ow%,black%
  center #ow%,3," Pulsa una tecla y gobernarás "
  center #ow%,5," Ritimba "
  national_anthem
enddef

defproc national_anthem
  loc i%,pitch,tune$
  let tune$="KPKKMKIHK`KMRPOMOP"
  cursen_home #iw%
  rep listen
    for i%=1 to len(tune$)
      if len(inkey$(#iw%)):\
        exit listen
      let pitch=code(tune$(i%))-80
      if pitch=16
        beep
        pause 20
      else
        zx_beep .5,pitch
      endif
    endfor i%
    beep
    pause 30
  endrep listen
  curdis #iw%
enddef

defproc welcome

    title
    wipe white%,black%,blue%
    paper #ow%,cyan%
    center #ow%,1,"Bienvenido al cargo"
    paper #ow%,white%
    if first_game%
      paragraph #ow%
      print_l #ow%,"El anterior líder de nuestra \
        amada patria Ritimba \
        obtuvo una puntuación final de "&score%&"."
      paragraph #ow%
      print_l #ow%,"Te deseamos que logres hacerlo mucho mejor."
    else
      paragraph #ow%
      print_l #ow%,"Eres el primer presidente de nuestra \
        amada patria Ritimba. \
        Te deseamos que lo hagas bien."
    endif
    paragraph #ow%
    print_l #ow%,"Para empezar podrás ver un informe del \
      tesoro y otro de la policía secreta."
    key_press
    treasure_report
    actual_police_report

enddef

deffn first_game%
  ret score%>0 and record%
enddef

' ==============================================================
' Treasure {{{1

defproc treasure_report

  wipe white%,green%,green%
  print #ow%,fill$("$",columns%*ow_lines%)
  ink #ow%,black%
  center #ow%,8,"INFORME DEL TESORO"
  treasure_report_details

enddef

defproc print_money(money)

  ' XXX OLD -- See `money$()`.

  ' XXX FIXME -- Remove blanks on the left.

  ' XXX REMARK -- `print_using` uses commas for decimal point.
  ' print_using #ow%,"### ### ###,##' RTD'",money*1000;

  print #ow%,thousand$(money) ' XXX TMP --

enddef

deffn money$(ammount)

  ' Return _ammount_ formatted as money.

  ' XXX TODO --
  '
  ' XXX FIXME -- This does not work because when the floating point
  ' parameter is converted to a string, the exponent format is forced,
  ' ie. "1234567" becomes "1.234567E6".

  loc i%,ammount$,formatted$
  let ammount$=ammount
  for i%=len(ammount$) to 1 step -1
    print i%,ammount$(i%)
    let formatted$=ammount$(i%)&formatted$
    if not(i% mod 3) and i%<>1:\
      let formatted$=" "&formatted$
  endfor i%
  ret formatted$&" "&currency$

enddef

deffn thousand$(amount)

  return amount&nbsp$&"000 "&currency$

enddef

defproc treasure_report_details

  paper #ow%,blue%
  ink #ow%,white%

  at #ow%,12,1
  print #ow%,"El tesoro ";
  if int(money)>=0
    print #ow%,"tiene ";
  else
    print #ow%,"debe ";
  endif
  print_money abs(int(money))

  at #ow%,14,1
  print #ow%,"Gastos mensuales: ";
  print_money monthly_payment

  if money_in_switzerland>0
    at #ow%,17,2
    print #ow%,"En Suiza: ";
    print_money money_in_switzerland
  endif

  key_press

enddef

defproc bankruptcy

  cls #ow%
  center #ow%,5,"El tesoro está en bancarrota"

  at #ow%,9,0

  paragraph #ow%
  print_l #ow%,"Su popularidad entre el ejército y \
    la policía secreta caerán."

  paragraph #ow%
  print_l #ow%,"El poder de la policía \
    y su propio poder se reducirán también."

  let popularity%(army%)=popularity%(army%)\
                         -(popularity%(army%)>0)

  let popularity%(police%)=popularity%(police%)\
                           -(popularity%(police%)>0)

  let power%(police%)=power%(police%)\
                      -(power%(police)>0)

  let strength%=strength%-(strength%>0)

  pause 250
  plot
  police_report

enddef

' ==============================================================
' Plot {{{1

defproc new_month

  let low%=rnd(2 to 4)
  let revolution_strength%=rnd(10 to 12)
  let months%=months%+1

  wipe yellow%,black%,yellow%
  paper #ow%,cyan%
  ink #ow%,white%
  at #ow%,10,12
  print #ow%,"MES  ";
  paper #ow%,white%
  ink #ow%,black%
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
             >=revolution_strength%
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
  center #ow%,10,"por un "&member$(group%)&""
  pause 50
  cls #ow%
  shoot_dead_sfx
  pause 50

  if all_groups_plan_assassination% or not secret_police_is_effective%
    successful_assassination
  else
    failed_assassination
  endif

enddef

defproc failed_assassination

  ' XXX TODO -- Improve.
  wipe white%,black%,black%
  paper #ow%,white%
  ink #ow%,black%
  center #ow%,12,"Intento fallido"

enddef

defproc successful_assassination

  ' XXX TODO -- Improve.
  wipe black%,white%,black%
  center #ow%,12,"¡Está usted muerto!"
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

  loc i%,petition%

  wipe yellow%,black%,yellow%
  paper #ow%,green%
  at #ow%,5,0
  cls #ow%,1
  paper #ow%,white%
  ink #ow%,black%
  center #ow%,3,"UNA AUDIENCIA"

  if not petitions_left%:\
    restore_petitions

  rep choose_petition
    let petition%=rnd(1 to petitions%)
    if not is_decision_taken%(petition%):\
      exit choose_petition
  endrep choose_petition

  mark_decision_taken petition%
  let soliciting_group%=int((petition%-1)/groups%)+1
  paper #ow%,yellow%
  ink #ow%,black%
  center #ow%,10,"Petición "\
                 &genitive_name$(soliciting_group%)&":"
  paper #ow%,white%
  at #ow%,14,0
  print_l #ow%,"¿Está su excelencia conforme con "\
    &iso_lower_1$(decision$(petition%))&"?"
  key_press
  maybe_advice petition%

  ' XXX FIXME -- Layout, colour...:

  cls #ow%
  paper #ow%,white%
  center #ow%,1,"DECISIÓN"
  center #ow%,3,"Petición "\
                &genitive_name$(soliciting_group%)
  ' XXX FIXME -- Colours:
  paper #ow%,yellow%
  ink #ow%,black%
  paragraph #ow%
  print_l #ow%,decision$(petition%)&"."

  if not affordable%(petition%)
    cls #ow%
    paragraph #ow%
    print_l #ow%,"No hay suficientes fondos para adoptar esta decisión."
    paragraph #ow%
    print_l #ow%,"Su respuesta debe ser no."
    pause 250
  else
    if yes_key%
      take_decision petition%
    else
      reject petition%
    endif
  endif

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

  let popularity%(soliciting_group%)=maximum(new_popularity%,0)

  cls #ow%

enddef

defproc decision

  loc i%,\
    chosen_decision%,\
    option%,\
    options%,\
    first_decision%,\
    last_decision%

  rep choose_decision

    wipe red%,yellow%,blue%

    print #ow%,fill$("*",columns%*ow_lines%)

    paper #ow%,blue%
    ink #ow%,white%
    center #ow%,3,"DECISIÓN PRESIDENCIAL"

    paper #ow%,yellow%
    ink #ow%,black%
    ' XXX TODO -- Store these options in an array,
    ' reuse them as titles of the lower level,
    ' and keep the data of their unused suboptions.
    at #ow%,08,4:print #ow%,"1. Complacer a un grupo  "
    at #ow%,10,4:print #ow%,"2. Complacer a todos     "
    at #ow%,12,4:print #ow%,"3. Aumentar el tesoro    "
    at #ow%,14,4:print #ow%,"4. Fortalecer a un grupo "
    at #ow%,16,4:print #ow%,"5. Asuntos privados      "

    let option%=code(get_key$)-code("0")
    cls #ow%
    sel on option%
      ' XXX TODO -- Store these values in an array.
      =1:let first_decision%=25:let last_decision%=30
      =2:let first_decision%=31:let last_decision%=33
      =3:let first_decision%=38:let last_decision%=40
      =4:let first_decision%=41:let last_decision%=43
      =5:let first_decision%=34:let last_decision%=37
      =remainder:ret
    endsel

    ' XXX TODO -- Calculate valid options before displaying them.

    at #ow%,(20-((last_decision%-first_decision%)*3))*.5,0
    let options%=0
    for i%=first_decision% to last_decision%
      if not is_decision_taken%(i%)
        let options%=options%+1
        paragraph #ow%
        print_l #ow%,options%&". "&decision$(i%)&"."
      endif
    endfor i%

    if not options%
      paragraph #ow%
      print_l #ow%,"Esta sección está agotada"
      pause 150
      next choose_decision
    endif

    let k$=get_key$

    if not k$ instr "0123456"
      next choose_decision
    endif

    if k$<1 or k$>last_decision%-first_decision%+1
      next choose_decision
    endif

    let chosen_decision%=first_decision%+k$-1

    if is_decision_taken%(chosen_decision%)
      next choose_decision
    endif

    sel on chosen_decision%

      =37
        money_transfer
        exit choose_decision

      =38,39
        ask_for_loan chosen_decision%
        exit choose_decision

      =remainder

        maybe_advice chosen_decision%

        if affordable%(chosen_decision%)

          ' XXX FIXME -- Layout, colour...:
          cls #ow%
          paper #ow%,white%

          print_l #ow%,"¿"&decision$(chosen_decision%)&"?"

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
    let popularity%(group%)=in_range(new_popularity%,0,9)
  endfor group%

  for group%=1 to local_groups%
    let new_power%=power%(group%)\
      +decision_power_effect%(decision%,group%)
    let power%(group%)=in_range(new_power%,0,9)
  endfor group%

  let money=\
    money+decision_cost

  let monthly_payment=\
    maximum(monthly_payment-decision_monthly_cost,0)

enddef

deffn in_range(x,min,max)

  return maximum(minimum(x,9),0)

enddef

defproc maybe_advice(decision%)

  wipe green%,black%,blue%

  at #ow%,ow_lines%/3,0
  print_l #ow%,"¿Quiere recibir consejo \
    acerca de las consecuencias de tomar la decisión de "\
    &iso_lower_1$(decision$(decision%))&"?"

  if yes_key%:\
    advice decision%

enddef

defproc advice(decision%)

  loc \
    i%,\
    variation%,variations%,\
    datum_col%,\
    paragraph_separation_backup%

  let datum_col%=27

  wipe yellow%,black%,yellow%

  print_l #ow%,"Consecuencias de "\
    &iso_lower_1$(decision$(decision%))&":"
  end_paragraph #ow%

  under #ow%,1
  print #ow%,\"La popularidad del presidente"
  under #ow%,0

  let variations%=0
  for i%=1 to groups%
    let variation%=decision_popularity_effect%(decision%,i%)
    let variations%=variations%+abs(variation%)
    if variation%
      print #ow%,\
        "- Entre ";plural_name$(i%);\
        to datum_col%;"+"(1 to variation%>0);variation%;
      if soliciting_group%=i% and decision%<25
        ' XXX TODO -- Convert into a footnote.
        paper #ow%,red%
        ink #ow%,yellow%
        print #ow%,"<"
        paper #ow%,yellow%
        ink #ow%,black%
      else
        print #ow%
      endif
    endif
  endfor i%

  if not variations%:\
    print #ow%,"Ningún cambio."

  under #ow%,1
  print #ow%,\"La fuerza de los grupos"
  under #ow%,0

  let variations%=0
  for i%=1 to local_groups%
    let variation%=decision_power_effect%(decision%,i%)
    let variations%=variations%+abs(variation%)
    if variation%
      print #ow%,\
        "- ";iso_upper_1$(name$(i%));\
        to datum_col%;"+"(1 to variation%>0);variation%
    endif
  endfor i%

  if not variations%:\
    print #ow%,"Ningún cambio."

  under #ow%,1
  print #ow%,\"El tesoro"
  under #ow%,0

  let paragraph_separation_backup%=paragraph_separation%
  let paragraph_separation%=0
  decision_treasure_report decision%
  let paragraph_separation%=paragraph_separation_backup%

  key_press
  cls #ow%

enddef

' ==============================================================
' Secret police report {{{1

defproc police_report

  wipe black%,white%,black%

  if money<=0 \
    or popularity%(police%)<=low% \
    or power%(police%)<=low%

    police_report_not_avalaible

  else

    center #ow%,6,"¿Informe de la Policía Secreta?"
    center #ow%,12,"(Cuesta "&thousand$(1)&")"
    if yes_key%
      let money=money-1
      actual_police_report
    endif

  endif

enddef

defproc actual_police_report

  wipe black%,white%,black%
  print #ow%,"MES ";months%
  ink #ow%,blue%
  at #ow%,3,0
  cls #ow%,1
  police_report_data

enddef

defproc final_police_report

  wipe black%,white%,black%
  center #ow%,1,"FINAL"
  police_report_data

enddef

defproc police_report_data

  loc group%,line%,\
    header_line%,data_line%,\
    group_col%,plan_col%,popularity_col%,strength_col%

  let title_line%=2
  let header_line%=title_line%+2
  let data_line%=header_line%+2

  let group_col%=0
  let plan_col%=10
  let ally_col%=14
  let popularity_col%=17
  let strength_col%=24

  paper #ow%,black%
  ink #ow%,white%
  under #ow%,1
  center #ow%,title_line%,"INFORME DE LA POLICÍA SECRETA"
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

    paper #ow%,white%
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
  print_l #ow%,"Tu fuerza es "&strength%&"."
  end_paragraph #ow%
  paragraph #ow%
  print_l #ow%,"La fuerza necesaria para una revolución es "&revolution_strength%&"."
  key_press

enddef

deffn is_main_group%(a_group%)

  return a_group%<=main_groups%

enddef

deffn is_local_group%(a_group%)

  return a_group%<=local_groups%

enddef

defproc police_report_not_avalaible

  center #ow%,6,"INFORME DE LA POLICÍA SECRETA"
  center #ow%,10,"NO DISPONIBLE"

  if popularity%(police%)<=low%
    print #ow%,\\"Tu popularidad entre la policía es ";\
      popularity%(police%);"."
  endif

  if power%(police%)<=low%
    print #ow%,to 3\\"El poder de la policía es ";\
      power%(police%);"."
        ' XXX TODO -- Prevent "policía" twice.
  endif

  if money<=0
    print #ow%,to 3\\"No tienes dinero para pagar un informe."
  endif

enddef

' ==============================================================
' Revolution {{{1

defproc revolution

  loc \
    helping_group%,\
    rebel_group%,\
    try_escaping%

  if rebels%

    revolution_alarm

    if want_to_escape%
      escape
    else
      fight
    endif

  endif

enddef

deffn want_to_escape%

  loc yes%
  cls #ow%
  center #ow%,12,"¿Intento de escape?"
  let yes%=yes_key%
  cls #ow%
  ret yes%

enddef

deffn rebels%

  loc i%

  for i%=1 to main_groups%
    let rebel_group%=rnd(1 to main_groups%)
    if plan%(rebel_group%)=rebellion%:\
      exit i%
  next i%
    ret 0
  endfor i%

  ret rebel_group%

enddef

defproc fight

  ask_for_help
  revolution_report
  revolution_starts

  if rebels_are_stronger%
    the_revolution_wins
  else
    the_revolution_is_defeated
  endif

enddef

defproc revolution_starts

  wipe white%,black%,white%
  at #ow%,12,3
  print #ow%,"La revolución ha comenzado"
  war_sfx

enddef

deffn rebels_are_stronger%

  ret not(rebels_strength%<=strength%\
         +power%(helping_group%)\
         +rnd(-1 to 1))

enddef

defproc revolution_alarm

  local i%

  wipe red%,black%,red%
  ink #ow%,white%
  center #ow%,10,"REVOLUCIÓN"
  for i%=1 to 5:\
    zx_beep .5,20:\
    zx_beep .5,10
  wipe yellow%,black%,yellow%

enddef

defproc revolution_report

  cls #ow%
  at #ow%,8,0
  print #ow%,"Tu fuerza es ";strength%
  print #ow%,\\"La fuerza de ";\
    name$(helping_group%);" es ";\
    power%(helping_group%)
  print #ow%,\\"La de los revolucionarios es ";rebels_strength%
  key_press

enddef

defproc ask_for_help

  local i%,helping_groups$,k$,group_keys_prompt$

  pause 150
  cls #ow%

  let rebels_strength%=\
    power%(rebel_group%)\
    +power%(ally%(rebel_group%))

  at #ow%,5,0
  print_l #ow%,\
    "Se han unido "&\
    name$(rebel_group%)&\
    " y "&\
    name$(ally%(rebel_group%))&"."

  print #ow%,\\"Su fuerza conjunta es ";rebels_strength%;"."
  print #ow%,\\"¿A quién vas a pedir ayuda?"

  for i%=1 to local_groups%
    if popularity%(i%)>low%
      print #ow%,to 6;i%;" ";name$(i%)
      let helping_groups$=helping_groups$&i%
      let group_keys_prompt$=group_keys_prompt$&i%&" "
    endif
  endfor i%

  let group_keys_prompt$=trim_right$(group_keys_prompt$)

  if len(helping_groups$)

    rep
      let k$=get_key_prompt$("["&group_keys_prompt$&"]")
      if k$ instr helping_groups$
        let helping_group%=k$
        exit
      endif
    endrep

  else

    cls #ow%
    center #ow%,8,"¡Estás solo!"
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

  center #ow%,12,"¡Escapas en helicóptero!"
  let escape%=1

enddef

defproc the_helicopter_does_not_work

  center #ow%,10,"¡El helicóptero no funciona!"
  pause 150

enddef

defproc escape_on_foot

  at #ow%,10,2
  print #ow%,"Tienes que atravesar el"
  at #ow%,12,6
  print #ow%,"monte hacia Leftoto."
  pause 200
  cls #ow%

  if not int((rnd*((power%(guerrillas%)/3)+.4)))
    do_escape_on_foot
  else
    the_guerrilla_catchs_you
  endif

enddef

defproc do_escape_on_foot

  at #ow%,12,0
  print #ow%,"Las guerillas no te atraparon"
  let escape%=1

enddef

defproc the_guerrilla_catchs_you

  wipe black%,white%,black%
  pause 50
  shoot_dead_sfx
  at #ow%,12,0
  print #ow%,"Las guerillas están celebrándolo"
  shoot_dead_sfx
  let alive%=0

enddef

defproc the_revolution_wins

  wipe black%,white%,black%
  at #ow%,10,7
  print #ow%,"Has sido derrocado"
  at #ow%,12,10
  print #ow%,"y liquidado."
  shoot_dead_sfx
  let alive%=0

enddef

defproc the_revolution_is_defeated

  local i%

  wipe black%,white%,black%
  at #ow%,10,2
  print #ow%,"La revuelta ha sido sofocada."
  at #ow%,0,0
  for i%=1 to ow_lines%-1
    paper #ow%,rnd(1 to 5)
    print #ow%,blank_line$
  endfor i%
  at #ow%,10,0
  print #ow%,"¿Castigas a los revolucionarios?"
  if yes_key%
    for n=1 to 3:\
      shoot_dead_sfx:\
      pause .1
    let popularity%(rebel_group%)=0
    let power%(rebel_group%)=0
    let popularity%(ally%(rebel_group%))=0
    let power%(ally%(rebel_group%))=0
  endif
  let power%(helping_group%)=9
  let pc%=months%+2
  plot
  police_report

enddef

' ==============================================================
' Treasure {{{1

defproc decision_treasure_report(decision%)

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
        let printout$=printout$&" aportaría"
      else
        let printout$=printout$&" costaría"
      endif

      let printout$=printout$&\
        " al tesoro "&thousand$(abs(decision_cost))

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
        &thousand$(abs(decision_monthly_cost))

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
    print_l #ow%,"El dinero necesario no está en el tesoro."

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

  loc country,loan

  sel on decision% ' XXX TODO -- Improve.
    =38:let country=russian
    =39:let country=usa%
  endsel

  wipe yellow%,black%,red%
  paper #ow%,red%
  print #ow%,\"SOLICITUD DE PRÉSTAMO EXTRANJERO"
  center #ow%,12,"ESPERA"
  pause 50
  if country=usa%
    tune "2m1j3f3j3m4r1 2v1t3r3j3l4m"
  else
    tune "2g2d3i4d2 2g2d3i4d"
  endif
  at #ow%,12,0
  if country=usa%
    print #ow%,"Los useños";
  else
    print #ow%,"Los rusos";
  endif

  if months%<int(rnd*5)+3
    at #ow%,12,2

      ' XXX FIXME -- This position overrides the previous text.
      ' Concatenate strings and print the result with `print_l`.

    print #ow%,"opinan que es demasiado pronto \
      para conceder ayudas ecónomicas."
  else
    if is_decision_taken%(decision%)
      at #ow%,12,2
      print #ow%,"Te deniegan un nuevo préstamo."
    else

      ' XXX FIXME -- Run-time error in this expression:
      ' 2016-01-22: again:
      ' country=0
      ' popularity_field%=1
      ' low%=3
      ' popularity%(country) = character nul

      if popularity%(country)<=low%
        at #ow%,12,12
        print #ow%,'Te dicen que no, sin ninguna explicación.'
      else
        print #ow%," te concederán"
        let loan=popularity%(7+x%)*30+rnd(0 to 200)
        at #ow%,14,7
        print #ow%,y%;nbsp$&"000 "&currency$
        let money=money+loan
        mark_decision_taken 38+x%
      endif
    endif
  endif
  key_press

enddef

defproc money_transfer

  ' XXX TODO -- Improve.

  loc amount

  cls #ow%
  at #ow%,3,0
  print #ow%,"TRANSFERENCIA A LA CUENTA SUIZA"\\\:

  let amount=int(money/2)
  if amount>=1
    print #ow%,"El tesoro tenía ";thousand$(int(money));
    let money_in_switzerland=money_in_switzerland+amount
    let money=money-amount
    pause 100
    print #ow%,\\thousand$(amount);" han sido transferidos"
    exit choose_decision
  else
    center #ow%,12,"Ninguna transferencia hecha"
    pause 100
  endif

enddef

' ==============================================================
' News {{{1

defproc news

  if not rnd(0 to 2):\
    do_news

enddef

defproc do_news

  loc i%,random_event%,flashes%

  ' XXX TODO -- Preserve current paper and ink colours.

  let flashes%=10

  let random_event%=rnd(first_event% to last_event%)
  for i%=1 to events%
    if not is_decision_taken%(random_event%):\
      exit i%
    let random_event%=random_event%+1
    if random_event%>last_event%:\
      let random_event%=first_event%
  next i%
    ret
  endfor i%

  wipe white%,black%,white%

  for i%=1 to flashes%
    if i% mod 2
      paper #ow%,white%
      ink #ow%,black%
    else
      paper #ow%,black%
      ink #ow%,white%
    endif
    center #ow%,10,"NOTICIA DE ÚLTIMA HORA"
    if i%<>flashes%:\
      zx_beep .6,30
  endfor i%

  repeat:\
    if not beeping:\
      exit

  paper #ow%,white%
  ink #ow%,black%
  at #ow%,14,0
  print_l_paragraph #ow%,decision$(random_event%)&"."
  pause 100
  take_only_once_decision random_event%
  plot
  police_report

enddef

' ==============================================================
' War {{{1

defproc war

  if \
       popularity%(leftoto%)<=low%\
    and power%(leftoto%)>=low%:\
    possible_war

enddef

defproc possible_war

  ' XXX TODO -- Message.

  if not rnd(0 to 3)
    actual_war
  else
    threat_of_war
  endif

enddef

defproc threat_of_war

  ' XXX TODO -- Improve texts.

  loc i%

  wipe black%,white%,cyan%
  center #ow%,6,"Amenaza de guerra contra Leftoto"
  center #ow%,10,"Tu popularidad en Ritimba"
  center #ow%,12,"aumentará"
  for i%=1 to main_groups%,police%:\
    increase_popularity i%

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

  center #ow%,8,"Leftoto nos invade" ' XXX TODO -- Improve.

  let ritimba_strength%=ritimba_current_strength%

  at #ow%,12,1
  print #ow%,"La fuerza de Ritimba es ";ritimba_strength%

  let leftoto_strength%=leftoto_current_strength%

  at #ow%,14,1
  print #ow%,"La fuerza de Leftoto es ";leftoto_strength%

  at #ow%,18,3
  print #ow%,"Una corta y decisiva guerra"
  war_sfx

  if leftoto_strength%+rnd(-1 to 1)<ritimba_strength%
    ritimba_wins
  else
    leftoto_wins
  endif

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

  wipe black%,white%,black%
  center #ow%,7,"Victoria de Leftoto"

  if have_helicopter% and rnd(0 to 2)

    ' XXX TODO -- Improve texts.

    ' Escape

    cls #ow%
    at #ow%,12,3
    print #ow%,"¡Escapas en helicóptero!"
    let escape%=1

  else

    ' XXX TODO -- Improve texts.

    if have_helicopter%
      at #ow%,10,0
      print_l #ow%,"Intentas escapar en helicóptero, \
               pero el motor sufre una avería."
      pause 80
    endif

    at #ow%,12,0
    print_l #ow%,"Eres acusado de ser un enemigo del pueblo y, \
             tras un juicio sumarísimo,"
    pause 50
    shoot_dead_sfx
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

  loc i%,popularity_bonus%,time_bonus%,money_bonus%,bonus_col%

  let bonus_col%=28 ' colum where bonus are displayed

  let score%=0

  at #ow%,3,1
  wipe yellow%,black%,cyan%
  print #ow%,"Tu puntuación como presidente"

  let popularity_bonus%=0
  for i%=1 to groups%:\
    let popularity_bonus%=\
      popularity_bonus%+popularity%(i%)

  print #ow%,\"Popularidad final:";to bonus_col%;
  print_using #ow%,"####",popularity_bonus%
  let score%=score%+popularity_bonus%

  time_bonus%=months%*3

  print #ow%,\"Por el tiempo en el poder"\
    \"(";months%;" meses):";\
    to bonus_col%;
  print_using #ow%,"####",time_bonus%
  let score%=score%+time_bonus%

  if alive%

    print #ow%,\"Por estar vivo:";to bonus_col%;
    print_using #ow%,"####",alive%
    let score%=score%+alive%

    if money_in_switzerland
      let money_bonus%=int(money_in_switzerland/10)
      print #ow%,\"Por tus «ahorros» en Suiza"\"(";\
        thousand$(money_in_switzerland);"):";to bonus_col%;
      print_using #ow%,"####",money_bonus%
      let score%=score%+money_bonus%
    endif

  endif

  print #ow%,\\\"Total:";to bonus_col%;
  print_using #ow%,"####",score%

  if score%>record%
    let record%=score%
    paragraph #ow%
    print_l #ow%,"Es la mayor puntuación hasta ahora."
  else
    paragraph #ow%
    print_l #ow%,"La mayor puntuación es "&record%&"."
  endif

  key_press
  cls #ow%
  final_police_report
  key_press

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

  curdis #iw%

  ret key$

enddef

deffn get_key$
  ret get_key_prompt$("TECLA")
enddef

deffn yes_key%

  loc yes%
  let yes% = "s"==get_key_prompt$('TECLA ("S" = SÍ)')
  cls #iw%
  zx_beep .25,10+40*yes%
  ret yes%

enddef

defproc key_press
  loc key$
  let key$=get_key$
enddef

' ==============================================================
' Data interface {{{1

defproc mark_decision_taken(decision%)

  ' Mark a decision taken.

  let decision_data$(decision%,1)="*"

enddef

defproc restore_petitions

  ' Mark all petitions not done.

  loc i%

  for i%=1 to petitions%:\
    let decision_data$(i%,1)="N"

enddef

defproc restore_decisions

  ' Mark all decisions not done.

  loc i%

  for i%=1 to decisions%:\
    let decision_data$(i%,1)="N"

enddef

deffn is_decision_taken%(decision%)
    
  ret decision_data$(decision%,1)="*"

enddef

deffn got_helicopter%

  ret is_decision_taken%(36)

enddef

deffn decision_cost%(decision%)
    
  ret code(decision_data$(decision%,2))-code("M")

enddef

deffn decision_monthly_cost%(decision%)
    
  ret code(decision_data$(decision%,3))-code("M")

enddef

deffn decision_popularity_effect%(decision%,group%)
    
  ret code(decision_data$(decision%,group%+3))-code("M")

enddef

deffn decision_power_effect%(decision%,group%)

  ret code(decision_data$(decision%,group%+11))-code("M")

enddef

' ==============================================================
' Data {{{1

defproc init_data

  loc x$ ' XXX TMP --

  let decision_name_max_len%=70
  dim decision_data$(decisions%,17)
  dim decision$(decisions%,decision_name_max_len%)

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

  restore

  for i%=1 to decisions%:
    read decision_data$(i%),x$
    if len(x$)>decision_name_max_len%
      ' XXX TMP --
      print "ERROR: decision name too long:"\x$
      stop
    else
      let decision$(i%)=x$
    endif
  endfor i%

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

  
  ' XXX TODO -- Not needed except to play again, what
  ' needs more restoration.
  restore_decisions

  let money=1000
  let escape%=0
  let monthly_payment=60
  let strength%=4
  let money_in_switzerland=0
  let alive%=1
  let months%=0
  let pc%=0 ' XXX TODO -- What for?
  let revolution_strength%=10

enddef

' ----------------------------------------------
' Petitions, decisions and events data

' XXX REMARK --
' Character fields in decision_data$():

' 01: decision already taken ("N"=no, "*"=yes)
' 02: cost
' 03: monthly cost
' 04..11: +/- popularity for groups 1-8
' 12..17 +/- power for groups% 1-6 (..."K"=-1, "L"=-1,"M"=0, "N"=1...)

' Fields 02..17 contain a letter ("G".."S") which represents a
' number calculated from its ASCII code, being "M" zero.
' Examples: ... "K"=-1, "L"=-1,"M"=0, "N"=1...

' ..............................
' Petitions from the army (8)

data "NMHQJLMMMMMPKLMMM",\
     "Instaurar el servicio militar obligatorio"
data "NMMPMJMMMMMNMLMMM",\
     "Requisar tierras para construir un polígono de tiro"
data "NCMPLNMLMLMNMNIMM",\
     "Atacar las bases de la guerilla"
data "NEMPLMMIMLMNMNKMM",\
     "Atacar la base de la guerrilla en Leftoto"
data "NMMQONMMIMMNMNMMJ",\
     "Destituir al jefe de la policía secreta"
data "NMMPMMMLMIOMMMMMM",\
     "Echar a los militares rusos"
data "NMDQMLMMMMMOLLLMM",\
     "Aumentar la paga de las tropas"
data "NAMQLLMLLMMPLLKLM",\
     "Comprar más armas y municiomes"

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
     "Aumentar el número de guardaespaldas (*)"
data "NAMIIJMMKMMMMMMMM",\
     "Comprar un helicóptero para una posible huida del país"
data "NMMMMMMMMMMMMMMMM",\
     "Hacer una transferencia a la cuenta presidencial \
     en un banco suizo (*)"
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
     "Cuba está entrenando a las guerillas"
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
     "la guerilla",\
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

' ==============================================================
' Special effects {{{1

defproc zx_border(colour%) ' XXX TMP
enddef

#include lib/zx_beep.bas

defproc war_sfx
  ' XXX TODO
  pause 100
enddef

defproc shoot_dead_sfx
  ' XXX TODO --
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

' deffn on_(flag,result_if_false,result_if_true)
'   ' XXX REMARK -- Not used.
'   if flag:\
'     ret result_if_true:\
'   else:\
'     ret result_if_false
' enddef

' deffn if_(flag,result_if_true,result_if_false)
'   ' XXX REMARK -- Not used.
'   if flag:\
'     ret result_if_true:\
'   else:\
'     ret result_if_false
' enddef

' deffn if$(flag,result_if_true$,result_if_false$)
'   ' XXX REMARK -- Not used.
'   if flag:\
'     ret result_if_true$:\
'   else:\
'     ret result_if_false$
' enddef

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

deffn center_for(width_in_chars%)
  ret (columns%-width_in_chars%)/2
enddef

defproc center(channel,line%,text$)
  loc length%
  let length%=len(text$)
  if length%>columns%
    at #ow%,line%,0
    print_l #ow%,text$
  else
    at #channel,line%,center_for(length%)
    print #channel,text$
  endif
enddef

defproc center_here(channel,text$)
  ' XXX UNDER DEVELOPMENT
  loc length%
  let length%=minimum(len(text$),columns%)
  at #channel,line%,center_for(length%)
  print #channel,text$(to length%)
enddef

defproc restore_csize

  csize #ow%,csize_width%,csize_height%

enddef

' ==============================================================
' Screen {{{1

#include lib/csize_pixels.bas

deffn contrast_colour%(colour%)

  sel on colour%
    =black%,blue%,red%,purple%:\
      ret white%
    =remainder:\
      ret black%
  endsel

enddef

defproc cursen_home(channel%)
  cursen #channel%
  if channel%=iw%:\
    at #iw%,iw_lines%-1,columns%-1:\
  else \
    at #ow%,ow_lines%-1,columns%-1
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

' ==============================================================
' Init {{{1

defproc init_font

  let font$=home_dir$&"iso8859-1_font"
  font_length=flen(\font$)
  font_address=alchp(font_length)
  lbytes font$,font_address
  iso_font

enddef

defproc init_windows

  let columns%=32
  let lines%=24

  let csize_width%=3
  let csize_height%=scr_ylim<>256

  let iw_lines%=3 ' input window lines%
  let ow_lines%=lines%-iw_lines% ' output window lines%

  let ow%=fopen("scr_") ' output window

  csize #ow%,csize_width%,csize_height%
  let char_width_pixels%=csize_width_pixels(csize_width%)
  let char_height_pixels%=csize_height_pixels(csize_height%)

  let ow_width%=columns%*char_width_pixels%
  let ow_height%=ow_lines%*char_height_pixels%
  let ow_x%=(scr_xlim-ow_width%)/2
  let ow_y%=(scr_ylim-(lines%*char_height_pixels%))/2
  window #ow%,ow_width%,ow_height%,ow_x%,ow_y%

  let iw%=fopen("con_") ' input window

  csize #iw%,csize_width%,csize_height%

  let iw_width%=ow_width%
  let iw_height%=iw_lines%*char_height_pixels%
  let iw_x%=ow_x%
  let iw_y%=ow_y%+ow_lines%*char_height_pixels%
  window #iw%,iw_width%,iw_height%,iw_x%,iw_y%

  let blank_line$=fill$(" ",columns%)

enddef

defproc init_screen
  if disp_type<>32:\
    mode 32
  colour_ql
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
  let blue%=1
  let red%=2
  let purple%=3
  let green%=4
  let cyan%=5
  let yellow%=6
  let white%=7

  let petitions%=24
  let decisions%=49

  let groups%=8
  let main_groups%=3  ' only the groups that can rebel
  let local_groups%=6 ' all groups but Russia and USA

  let nbsp$=chr$(160) ' non-breaking space in ISO 8859-1

  let currency$="RTD" ' Ritimban dolar

  ' Group ids
  let army%=1
  let peasants%=2
  let landowners%=3
  let guerrillas%=4
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

' vim: filetype=sbim textwidth=70
