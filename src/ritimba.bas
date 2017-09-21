rem Ritimba

version$="0.1.0-dev.31+201709212324"

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

let dev$=device$("ritimba_bas","flpmdvdevsubwinnfados")

#include device.bas
#include iso_lower.bas

' ==============================================================
' Main loop {{{1

defproc ritimba

  loc i%

  init_once
  rep again
    credits
    key_press
    init_data
    welcome
    rep game
      new_month
      audience
      plot
      murder
      if not alive%:\
        exit game
      war
      if not alive% or escape%:\
        exit game
      plot
      police_report
      decision
      plot
      police_report
      news
      revolution
      if not alive% or escape%:\
        exit game
    endrep game
    the_end
  endrep again

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
        beep:pause 20
      else
        zx_beep .5,pitch
      endif
    endfor i%
    beep:pause 30
  endrep listen
  curdis #iw%
enddef

defproc welcome

    title
    wipe white%,black%,blue%
    paper #ow%,cyan%:center #ow%,1,"Bienvenido al cargo"
    paper #ow%,white%
    if score%>0
      tellNL "El anterior líder de nuestra"
      tell "amada patria Ritimba"
      tell "obtuvo una puntuación final de "&score%&"."
      tellNL "Te deseamos que logres hacerlo mucho mejor."
    else
      tellNL "Eres el primer líder de nuestra"
      tell "amada patria Ritimba."
      tell "Te deseamos que lo hagas bien."
    endif
    tellNL "Para empezar podrás ver un informe del"
    tell "tesoro y otro de la policía secreta."
    key_press
    treasure_report
    key_press
    actual_police_report

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

enddef

defproc bankruptcy

  cls #ow%
  center #ow%,5,"El tesoro está en bancarrota"

  at #ow%,9,0

  tellNL "Su popularidad entre el ejército y \
    la policía secreta caerán."

  tellNL "El poder de la policía \
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

  loc main_group%,partner_group%

  if months%<=2 or months%<pc%:\
    ret

  for main_group%=1 to main_groups%:\
    let plan%(main_group%)=none%:\
    let ally%(main_group%)=none%

  for main_group%=1 to main_groups%
    if popularity%(main_group%)<=low%
      for partner_group%=1 to local_groups%
        if not(main_group%=partner_group% \
               or popularity%(partner_group%)>low%)
          if power%(partner_group%)+power%(main_group%)\
             >=revolution_strength%
            let plan%(main_group%)=rebellion%
            let ally%(main_group%)=partner_group%
            exit partner_group%
          endif
        endif
      next partner_group%
        let plan%(main_group%)=assassination%
      endfor partner_group%
    endif
  endfor main_group%

enddef

defproc murder

  loc group%

  let group%=rnd(1 to main_groups%)

  if plan%(group%)=assassination%

    wipe black%,white%,black%
    at #ow%,10,7
    print #ow%,"INTENTO DE MAGNICIDIO"
    at #ow%,20,0
    print #ow%,"por un miembro de ";group_name$(group%)
      ' XXX TODO -- Special individual names for this case.
    cls #ow%
    pause 30
    shoot_dead_sfx
    pause 50

    if ((plan%(army%)=assassination% \
      and plan%(peasants%)=assassination% \
      and plan%(landowners%)=assassination%) \
      or not (popularity%(police%)>low% \
      or power%(police%)>low% \
      or rnd(0 to 1)))
      ' XXX TODO -- Check the compacted logic above.
      wipe black%,white%,black%
      center #ow%,12,"¡Está usted muerto!" ' XXX TODO -- Improve.
      zx_beep 3,-40
      let alive%=0
    else
      wipe white%,black%,black%
      paper #ow%,white%
      ink #ow%,black%
      center #ow%,12," Intento fallido "
    endif

  endif

enddef

' ==============================================================
' Decisions {{{1

defproc audience

  loc i%,affordable%,this_decision%

  wipe yellow%,black%,yellow%
  paper #ow%,green%
  at #ow%,5,0
  cls #ow%,1
  paper #ow%,white%
  ink #ow%,black%
  center #ow%,3,"UNA AUDIENCIA"

  rep choose_decision
    let this_decision%=rnd(1 to 24)
    for i%=1 to 22
      if decision_data$(this_decision%,1)="N"
        exit choose_decision
      endif
      let this_decision%=(this_decision%-int(this_decision%/24)*24)+1
    end for i%
    for i%=1 to 24:\
      let decision_data$(i%,1)="N"
  endrep choose_decision

  let decision_data$(this_decision%,1)="*"
  let soliciting_group%=int((this_decision%-1)/groups%)+1
  zx_border soliciting_group%
  let this_decision_data$=decision_data$(this_decision%)
  paper #ow%,yellow%
  ink #ow%,black%
  center #ow%,10,"Petición "\
                 &group_genitive_name$(soliciting_group%)&":"
  paper #ow%,white%
  at #ow%,14,0
  tell "¿Está su excelencia conforme con "\
    &iso_lower_1$(decision$(this_decision%))&"?"
  key_press
  advert this_decision%

  cls #ow%
  paper #ow%,white%
  center #ow%,1,"  DECISIÓN  "
  paper #ow%,soliciting_group%
  ink #ow%,contrast_colour%(soliciting_group%)
  center #ow%,3,"Petición "&group_genitive_name$(soliciting_group%)
  paper #ow%,yellow%
  ink #ow%,black%
  center #ow%,5,decision$(this_decision%)
  paper #ow%,blue%:print #ow%:cls #ow%,3

  let affordable%=cash_advice%(this_decision%)
  ink #ow%,green%

  if affordable%=0
    cls #ow%
    at #ow%,10,1
    print #ow%,"No hay suficientes fondos"
    print #ow%,\\" para";
    print #ow%," pagar esta decisión."
    at #ow%,15,4
    print #ow%,"Su respuesta debe ser no."
    pause 250
  else
    if yes_key:\
      ret
  endif

  let x%=popularity%(soliciting_group%)
  let y%=code(this_decision_data$(soliciting_group%+3))-77
  let x%=x%-y%
  if x%<0:\
    let x%=0 ' XXX TODO -- Use `maximum`.
  ' XXX FIXME -- Coercion:
  let popularity%(soliciting_group%)=x%
  cls #ow%
  treasure_report

enddef

defproc decision

  loc i%,affordable%,chosen_decision,key,options

  rep choose_gratis_decision

    rep choose_decision

      wipe red%,yellow%,blue%

      print #ow%,fill$("*",columns%*ow_lines%)
      paper #ow%,blue%
      ink #ow%,white%
      center #ow%,3,"DECISIÓN PRESIDENCIAL"
      paper #ow%,yellow%
      ink #ow%,black%
      at #ow%,06,1:print #ow%,"Elige entre:"
      at #ow%,08,4:print #ow%,"1. Complacer a un grupo  "
      at #ow%,10,4:print #ow%,"2. Complacer a todos     "
      at #ow%,12,4:print #ow%,"3. Tus negocios          "
      at #ow%,14,4:print #ow%,"4. Aumentar el tesoro    "
      at #ow%,16,4:print #ow%,"5. Fortalecer a un grupo "

      let key=code(get_key$) ' XXX TODO -- Use default routine.
      cls #ow%
      sel on key

        ' XXX TODO -- Extract athe values from `x$` and use them
        ' directly.

        =code("1"):let x$="-2"
        =code("2"):let x$="35"
        =code("3"):let x$="69"
        =code("4"):let x$=":<"
        =code("5"):let x$="=?"
        =remainder:ret
      endsel

      at #ow%,(20-(((code(x$(2))-20)-(code(x$(1))-20))*3))*.5,0
      let options=0
      for i%=code(x$(1))-20 to code(x$(2))-20
        if decision_data$(i%,1)<>"*"
          let options=options+1
          tellNL options&". "&decision$(i%)&"."
        endif
      endfor i%

      if not options
        at #ow%,12,3
        print #ow%,"Esta sección está agotada"
        pause 150
        next choose_decision
      endif

      let k$=get_key$

      if not k$ instr "0123456"
        next choose_decision
      endif

      if k$<1 or k$>(code(x$(2))-20)+1-(code(x$)-20)
        next choose_decision
      endif

      let chosen_decision=code(x$)-20+k$-1

      if decision_data$(chosen_decision,1)="*"
        next choose_decision
      endif

      sel on chosen_decision
        =37
          money_transfer
          exit choose_decision
        =38,39
          ask_for_loan chosen_decision
          treasure_report
          exit choose_gratis_decision
      endsel

      advert chosen_decision
      ' XXX TODO -- Restore the screen colors here?
      at #ow%,4,0
      print #ow%,decision$(chosen_decision)

      let affordable%=cash_advice%(chosen_decision)
      if not affordable%
        pause 200
        next choose_decision
      endif

      at #ow%,4,0
      print #ow%,decision$(chosen_decision)
      if not yes_key:\
        next choose_decision

      if chosen_decision<>35
        treasure_report
        take_only_once_decision chosen_decision
        exit choose_decision
      endif

      let strength%=strength%+2
      treasure_report
      take_decision chosen_decision
      exit choose_decision

    endrep choose_decision

    treasure_report_details
    exit choose_gratis_decision

  endrep choose_gratis_decision

enddef

defproc take_only_once_decision(decision)
  ' XXX TODO -- Rename.
  let decision_data$(decision,1)="*"
  take_decision decision
enddef

defproc take_decision(decision)

  ' XXX TODO -- Rename.

  loc group%,t$,x%

  let t$=decision_data$(decision,4 to 11)
  for group%=1 to groups%
    if t$(group%)<>"M"
      ' M means 0 above
      let x%=popularity%(group%)+(code(t$(group%))-77)
      if x%>9:\
        let x%=9 ' XXX TODO -- Use `maximum` and `minimum`.
      if x%<0:\
        let x%=0
      ' XXX FIXME -- Coercion:
      let popularity%(group%)=x%
    endif
  endfor group%

  let t$=decision_data$(decision,12 to 17)
  for group%=1 to local_groups%
    if t$(group%)<>"M" ' M means 0
      let x%=power%(group%)+(code(t$(group%))-77)
      if x%>9:\
        let x%=9 ' XXX TODO -- Use `maximum` and `minimum`.
      if x%<0:\
        let x%=0
      let power%(group%)=x%
    endif
  endfor group%

  ' XXX TODO -- Move: it seems this is month stuff:
  let money=money+decision_cost
  let monthly_payment=monthly_payment-decision_monthly_cost%
  if monthly_payment<0:\
    let monthly_payment=0

enddef

defproc advert(decision)

  loc i%,x%

  wipe green%,black%,blue%
  paper #ow%,cyan%
  for i%=0 to ow_lines%-1
    at #ow%,i%,11
    print #ow%,"¿Consejo?"
  endfor i%
  if yes_key
    wipe yellow%,yellow%,yellow%
    paper #ow%,black%
    at #ow%,1,0
    print #ow%,decision$(decision) ' XXX FIXME -- Wrap/justify.
    paper #ow%,white%
    ink #ow%,black%
    at #ow%,3,0
    print #ow%,"Su popularidad entre..."
    paper #ow%,yellow%
    for i%=1 to groups%
      let x%=code(decision_data$(decision,i%+3))-77
      if x%
        print #ow%,\to 2;group_plural_name$(i%);to 24;
        if x%>0:\
          print #ow%,"+";
        print #ow%,x%;
        if soliciting_group%=i% and decision<25
          paper #ow%,soliciting_group%
          ink #ow%,yellow%
          print #ow%,"< "
          paper #ow%,yellow%
          ink #ow%,black%
        endif
      endif
    endfor i%
    paper #ow%,white%
    print #ow%,\\\"El poder de..."
    paper #ow%,yellow%
    for i%=1 to local_groups%
      let x%=code(decision_data$(decision,i%+11))-77
      if x%
        print #ow%,to 2;group_name$(i%);to 24;"+"(1 to x%>0);x%
      endif
    endfor i%
    key_press
    cls #ow%
  endif
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

    center #ow%,6,"¿INFORME de la POLICÍA SECRETA?"
    center #ow%,12,"(Cuesta "&thousand$(1)&")"
    if yes_key
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
  print #ow%,"Prepara"
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
    print #ow%,group_short_name$(group%);\
      fill$(" ",max_short_name_len%-len(group_short_name$(group%)))
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
  print #ow%
  tellNL "Tu fuerza es "&strength%&"."
  print #ow%
  tellNL "La fuerza necesaria para una revolución es "&revolution_strength%&"."
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

  ' XXX TODO -- Factor.

  loc i%,helping_group%,helping_groups%,rebel_group%,try_escaping%

  for i%=1 to main_groups%
    let rebel_group%=rnd(1 to main_groups%)
    if plan%(rebel_group%)=rebellion%:\
      exit i%
  next i%
    ret
  endfor i%

  wipe red%,black%,red%
  ink #ow%,white%
  center #ow%,10,"REVOLUCIÓN"
  for i%=1 to 5:\
    zx_beep .5,20:\
    zx_beep .5,10
  wipe yellow%,black%,yellow%

  center #ow%,12,"¿Intento de escape?"
  let try_escaping%=yes_key
  cls #ow%
  if try_escaping%

    if decision_data$(36,1)="*" ' XXX TODO -- Factor.
      ' The helicopter was bought before.
      if rnd(0 to 2)
        center #ow%,12,"¡Escapas en helicóptero!"
        let escape%=1
        ret
      else
        center #ow%,10,"¡El helicóptero no funciona!"
        pause 150
      endif
    endif

    at #ow%,10,2
    print #ow%,"Tienes que atravesar el"
    at #ow%,12,6
    print #ow%,"monte hacia Leftoto."
    pause 200
    cls #ow%

    if not int((rnd*((power%(guerrillas%)/3)+.4)))
      at #ow%,12,0
      print #ow%,"Las guerillas no te atraparon"
      let escape%=1
    else
      wipe black%,white%,black%
      pause 50
      shoot_dead_sfx
      at #ow%,12,0
      print #ow%,"Las guerillas están celebrándolo"
      shoot_dead_sfx
      let alive%=0
    endif
    ret

  endif ' escape

  rep ask_for_help

    pause 150
    cls #ow%

    let rebels_strength%=\
      power%(rebel_group%)\
      +power%(ally%(rebel_group%))

    at #ow%,5,0
    tell \
      "Se han unido "&\
      group_name$(rebel_group%)&\
      " y "&\
      group_name$(ally%(rebel_group%))

    print #ow%,\\"Su fuerza conjunta es ";rebels_strength%
    print #ow%,\\"¿A quién vas a pedir ayuda?"
    let helping_groups%=0
    for i%=1 to local_groups%
      if popularity%(i%)>low%
      print #ow%,to 6;i%;" ";group_name$(i%)
      let helping_groups%=helping_groups%+1
      endif
    endfor i%

    if helping_groups%
      rep choose_group
        let k$=get_key$
        if k$ instr "123456":\
          exit choose_group
      endrep choose_group
      if popularity%(k$)>low%
        let helping_group%=k$:\
        exit ask_for_help
      else
        cls #ow%
        center #ow%,12,"¡Debes de estar bromeando!"
        next ask_for_help
      endif
    else
      cls #ow%
      center #ow%,8,"¡Estás solo!"
      key_press
    endif
    exit ask_for_help

  endrep ask_for_help

  cls #ow%

  at #ow%,8,0
  print #ow%,"Tu fuerza es ";strength%
  print #ow%,\\"La fuerza de ";\
    group_name$(helping_group%);" es ";\
    power%(helping_group%)
  print #ow%,\\"La de los revolucionarios es ";rebels_strength%
  pause 250
  wipe white%,black%,white%
  at #ow%,12,3
  print #ow%,"La revolución ha comenzado"
  war_sfx
  if not(rebels_strength%<=strength%\
         +power%(helping_group%)\
         +rnd(-1 to 1))
    wipe black%,white%,black%
    at #ow%,10,7
    print #ow%,"Has sido derrocado"
    at #ow%,12,10
    print #ow%,"y ";: print #ow%,"liquidado."
    shoot_dead_sfx
    let alive%=0
    ret
  endif

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
  if yes_key
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

deffn cash_advice%(decision)

  ' loc decision_cost

  paper #ow%,yellow%
  ink #ow%,black%
  let decision_cost=10*(code(decision_data$(decision,cost%))-77)
  let decision_monthly_cost%=\
    code(decision_data$(decision,monthly_cost%))-77

  if not decision_cost and not decision_monthly_cost%
    at #ow%,10,7
    print #ow%,"No cuesta dinero."
    ret 1
  endif

  at #ow%,9,1
  print #ow%,"Esta decisión";
  ' XXX TODO -- Create a string and use `tell`.

  if decision_cost
    if decision_cost>0:\
      print #ow%," aportaría";
    if decision_cost<0:\
      print #ow%," costaría";
    print #ow%," al tesoro ";thousand$(abs(decision_cost))\:
  endif

  if decision_monthly_cost%
    print #ow%," y"
    if decision_monthly_cost%<0:\
      print #ow%," subiría";
    if decision_monthly_cost%>0:\
      print #ow%," bajaría";
    print #ow%," los gastos mensuales en ";\
      thousand$(abs(decision_monthly_cost%));
  endif

  if money+decision_cost>0:\
    ret 1

  if not((decision_cost<0 or decision_monthly_cost%<0) \
    and (money+decision_cost<0 or money+decision_monthly_cost%<0)):\
    ret 1

  pause 250: cls #ow%
  center #ow%,5,decision$(decision)
  at #ow%,8,2
  print #ow%,"El dinero necesario"
  print #ow%,\to 4;"no está en el tesoro"\\\:

  if decision_data$(38,1)="N":\
    print #ow%,"Quizá los rusos pueden ayudar."

  if decision_data$(39,1)="N":\
    print #ow%,"Los useños son un pueblo generoso"\:

  pause 350
  ret 0

enddef

defproc ask_for_loan(decision)

  loc country,loan

  sel on decision ' XXX TODO -- Improve.
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
      ' Concatenate strings and print the result with `tell`.

    print #ow%,"opinan que es demasiado pronto \
      para conceder ayudas ecónomicas."
  else
    if decision_data$(decision,1)="*"
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
        let decision_data$(38+x%,1)="*"
      endif
    endif
  endif
  key_press

enddef

defproc money_transfer

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

  loc i%,random_event%,first_event%,last_event%

  let first_event%=44
  let last_event%=49
  let events%=last_event%-first_event%+1

  if not rnd(0 to 2)

    let random_event%=rnd(first_event% to last_event%)
    for i%=1 to events%
      ' XXX FIXME --
      if not (decision_data$(random_event%,1)="N"):\
        exit i%
      let random_event%=random_event%+1
      if random_event%>last_event%:\
        let random_event%=first_event%
    next i%
      ret
    endfor i%

    wipe white%,black%,white%

    ' XXX FIXME -- The original used a flash effect. That's why
    ' the title is printed again after the sound.

    center #ow%,10,"NOTICIA DE ÚLTIMA HORA"
    for i%=1 to 10:\
      zx_beep .6,30
    cls #ow%
    center #ow%,10,"NOTICIA DE ÚLTIMA HORA"
    at #ow%,14,0
    print #ow%,decision$(random_event%)
    ink #ow%,white%
    pause 100
    take_only_once_decision random_event%
    plot
    police_report

  endif

enddef

' ==============================================================
' War {{{1

defproc war

  loc i%

  if popularity%(leftoto%)>low%:\
    ret

  if power%(leftoto%)<low%:\
    ret

  if not rnd(0 to 3)
    actual_war
  else
    wipe black%,white%,cyan%
    at #ow%,6,1
    print #ow%,"Tratado de guerra con Leftoto"
    at #ow%,10,3
    print #ow%,"Tu popularidad en Ritimba"
    at #ow%,12,11
    print #ow%,"aumentará"
    for i%=1 to main_groups%,police%: increase_popularity i%
  endif

enddef

defproc increase_popularity(group%) ' XXX TODO -- Rename.

  local x%

  ' XXX TODO -- Write a general solution to update the
  ' popularity by any amount, positive or negative.

  let x%=popularity%(group%)
  ' XXX FIXME -- Coercion:
  let popularity%(group%)=x%+(x%<9)

enddef

defproc actual_war

  loc i%

  wipe red%,black%,black%
  center #ow%,8,"Leftoto nos invade"
  let ritimba_strength=0

  for i%=1 to main_groups%
    if popularity%(i%)>low%:\
      let ritimba_strength=ritimba_strength+power%(i%)
  endfor i%

  if popularity%(police%)>low%
    let ritimba_strength=ritimba_strength+power%(police%)
  endif

  let ritimba_strength=ritimba_strength+strength%
  at #ow%,12,1
  print #ow%,"La fuerza de Ritimba es ";ritimba_strength
  let leftoto_strength=0

  for i%=1 to 6
    if popularity%(i%)<=low%:\
      let leftoto_strength=leftoto_strength+power%(i%)
  endfor i%

  at #ow%,14,1
  print #ow%,"La fuerza de Leftoto es ";leftoto_strength

  at #ow%,18,3
  print #ow%,"Una corta y decisiva guerra"
  war_sfx

  if leftoto_strength+rnd(-1 to 1)<ritimba_strength

    ' XXX TODO -- Factor.

    ' Ritimba wins

    zx_border black%
    cls #ow%
    at #ow%,12,7
    print #ow%," Leftoto derrotado ":
    let power%(leftoto%)=0

  else

    ' XXX TODO -- Factor.

    ' Leftoto wins

    wipe black%,white%,black%
    at #ow%,7,7
    print #ow%,"Victoria de Leftoto"

    if not(decision_data$(36,1)="*" and rnd(0 to 2))

      let alive%=0
      if decision_data$(36,1)="*"
        at #ow%,10,0
        print #ow%,"El motor del helicóptero se para."
        pause 80
      endif
      at #ow%,12,4
      print #ow%,"Eres acusado de ser un enemigo del pueblo y,"
      pause 30:
      print #ow%,"tras un juicio sumarísimo,"
      pause 30:
      shoot_dead_sfx
      at #ow%,18,7
      print #ow%,"ejecutado."
    else
      ' Escape
      cls #ow%
      at #ow%,12,3
      print #ow%,"¡Escapas en helicóptero!"
      let escape%=1

    endif

  endif

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

  print #ow%,\"Popularidad final";to bonus_col%;
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
    tellNL "Es la mayor puntuación hasta ahora."
  else
    tellNL "La mayor puntuación es "&record%&"."
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

    key_prompt prompt$,prompt_colour_2
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

deffn yes_key
  loc yes
  let yes = "s"==get_key_prompt$('TECLA ("S" = SÍ)')
  zx_beep .25,10+40*yes
  ret yes
enddef

defproc key_press
  loc key$
  let key$=get_key$
enddef

' ==============================================================
' Data {{{1

defproc init_data

  loc x$ ' XXX TMP --

  let score%=0
  let record%=0

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

  let none%=-1         ' plan or partner identifier
  let rebellion%=1     ' plan identifier
  let assassination%=2 ' plan identifier

  ' Decision fields in decision_data$()
  let cost%=2
  let monthly_cost%=3

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
    group_name$(groups%,18),\
    group_short_name$(groups%,max_short_name_len%),\
    group_plural_name$(groups%,21),\
    group_genitive_name$(groups%,21)

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
      group_name$(i%),\
      group_short_name$(i%),\
      group_plural_name$(i%),\
      group_genitive_name$(i%)
  endfor i%

  ' XXX TODO -- Not needed.
  ' for i%=1 to decisions%:\
  '   let decision_data$(i%,1)="N"

  let money=1000
  let escape%=0
  let monthly_payment=60
  let strength%=4
  let money_in_switzerland=0
  let alive%=10
  let months%=0
  let pc%=0 ' XXX TODO -- What for?
  let revolution_strength%=10

enddef

' ----------------------------------------------
' Decisions data

' XXX REMARK --
' Character fields in decision_data$():

' 01: decision already taken ("N"=no, "*"=yes)
' 02: cost%
' 03: monthly cost%
' 04..11: +/- popularity for groups 1-8
' 12..17 +/- power for groups% 1-6 (..."K"=-1, "L"=-1,"M"=0, "N"=1...)

' Fields 02..17 contain a letter ("G".."S") which represents a
' number calculated from its ASCII code, being "M" zero.
' Examples: ... "K"=-1, "L"=-1,"M"=0, "N"=1...

' ..............................
' Petitions from the army

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
' Petitions from the peasants

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
' Petitions from the landowners

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
     "Comprar armas para el ejercito"
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
' group_name$(i%)
' group_short_name$(i%)
' group_plural_name$(i%)
' group_genitive_name$(i%)

data 7,6,none%,none%,\
     "el ejército",\
     "ejército",\
     "los militares",\
     "del ejército"
data 7,6,none%,none%,\
     "los campesinos",\
     "campesinos",\
     "los campesinos",\
     "de los campesinos"
data 7,6,none%,none%,\
     "los terratenientes",\
     "terratenientes",\
     "los terratenientes",\
     "de los terratenientes"
data 0,6,none%,none%,\
     "la guerilla",\
     "guerrilla",\
     "los guerrilleros",\
     "de la guerrilla"
data 7,6,none%,none%,\
     "Leftoto",\
     "leftotanos",\
     "los leftotanos",\
     "de Leftoto"
data 7,6,none%,none%,\
     "la policía secreta",\
     "policía secreta",\
     "los policías secretos",\
     "de la policía secreta"
data 7,0,none%,none%,\
     "Rusia",\
     "rusos",\
     "los rusos",\
     "de Rusia"
data 7,0,none%,none%,\
     "Usa",\
     "useños",\
     "los useños",\
     "de Usa"

' ==============================================================
' Special effects {{{1

defproc zx_border(colour%) ' XXX TMP
enddef

#include zx_beep.bas

defproc war_sfx
  ' XXX TODO
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

deffn on_(flag,result_if_false,result_if_true)
  if flag:\
    ret result_if_true:\
  else:\
    ret result_if_false
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
  let prompt_colour_2=paper_colour%
  if prompt_colour_1%=prompt_colour_2
    let prompt_colour_2=contrast_colour%(prompt_colour_1%)
  endif
  zx_beep .1,40

enddef

deffn center_for(width_in_chars)
  ret (columns%-width_in_chars)/2
enddef

defproc center(channel,line%,text$)
  loc length%
  let length%=len(text$)
  if length%>columns%
    at #ow%,line%,0
    tell text$
  else
    at #channel,line%,center_for(length%)
    print #channel,text$
  endif
enddef

defproc tell(txt$)
  local text$,first%,last%
  if len(txt$)
    let text$=txt$&" "
    let first%=1
    for last%=1 to len(text$)
      if text$(last%)=" "
        print #ow%,!text$(first% to last%-1);
        let first%=last%+1
      endif
    endfor last%
  endif
enddef

defproc tellNL(text$)
  print #ow%,\" ";
  tell(text$)
  ' XXX FIXME -- An extra blank line is created if the
  ' previous line occupied the whole width.
enddef

defproc restore_csize

  csize #ow%,csize_width%,csize_height%

enddef

' ==============================================================
' Screen {{{1

deffn csize_width_pixels(width%)
  sel on width%
    =0:ret 6
    =1:ret 8
    =2:ret 12
    =3:ret 16
  endsel
enddef

deffn csize_height_pixels(height%)
  ret height%*10+10
enddef

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

  let font$=dev$&"iso8859-1_font"
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
  let black%=0
  let blue%=1
  let red%=2
  let purple%=3
  let green%=4
  let cyan%=5
  let yellow%=6
  let white%=7
enddef

defproc init_once
  init_screen
  init_windows
  init_font
  init_zx_beep
enddef

' ==============================================================
' Meta {{{1

defproc w0
  window 800,600,0,0
  csize 3,1
enddef

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
