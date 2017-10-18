' print_l.bas

' This file is part of Sbira
' http://programandala.net/en.program.sbira.html

rem Procedures to print left-justified strings.

rem Author: Marcos Cruz (programandala.net), 2017

' Last modified 201710180151
' See change log at the end of the file

' ==============================================================
' License

' You may do whatever you want with this work, so long as you
' retain all copyright, authorship and credit notices and this
' license in all redistributed copies and derived works.
' There is no warranty.

' ==============================================================

let paragraph_separation% = 0
  ' Number of lines between paragraphs.

let paragraph_indentation% = 2
  ' Spaces at the start of the first line of a paragraph.

defproc print_l(channel%,text$)

  ' Print the given text left justified from the current cursor
  ' position of the window identified by `channel%`.

  local first%,last%

  let first%=1
  for last%=1 to len(text$)
    if text$(last%)=" "
      print #channel%,!text$(first% to last%-1);
      let first%=last%+1
    endif
  next
    print #channel%,!text$(first% to);
  endfor last%

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
' Development benchmarks

#ifdef VOID

defproc print_l_v1(channel%,text$)

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

defproc print_l_v2(channel%,text$)

  ' Print the given text left justified from the current cursor
  ' position of the window identified by `channel%`.

  local t$,first%,last%

  let t$=text$&" "
  let first%=1
  for last%=1 to len(t$)
    if t$(last%)=" "
      print #channel%,!t$(first% to last%-1);
      let first%=last%+1
    endif
  endfor last%

enddef

defproc print_l_v3(channel%,text$)

  ' Print the given text left justified from the current cursor
  ' position of the window identified by `channel%`.

  local first%,last%

  let first%=1
  for last%=1 to len(text$)
    if text$(last%)=" "
      print #channel%,!text$(first% to last%-1);
      let first%=last%+1
    endif
  next
    print #channel%,!text$(first% to);
  endfor last%

enddef

defproc print_l_v4(channel%,text$)

  ' Print the given text left justified from the current cursor
  ' position of the window identified by `channel%`.

  local spacepos%,txt$

  let txt$=text$
  rep
    let spacepos%=" " instr txt$
    if spacepos%
      print #channel%,!txt$(to spacepos%-1);
      let txt$=txt$(spacepos%+1 to)
    else
      print #channel%,!txt$;
      exit
    endif
  endrep

enddef

defproc bpl(times%)

  ' Benchmark all variants of `print_l`.

  loc t0,t,i%,txt$

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

  window #0,scr_xlim,scr_ylim,0,0
  cls #0

  let t0=date:\
  for i%=1 to times%:\
    at #0,0,0:\
    print_l_v1 #0,txt$

  let t=date-t0
  print \"v1: ";t;" seconds"

  let t0=date:\
  for i%=1 to times%:\
    at #0,0,0:\
    print_l_v2 #0,txt$

  let t=date-t0
  print \\"v2: ";t;" seconds"

  let t0=date:\
  for i%=1 to times%:\
    at #0,0,0:\
    print_l_v3 #0,txt$

  let t=date-t0
  print \\\"v3: ";t;" seconds"

  let t0=date:\
  for i%=1 to times%:\
    at #0,0,0:\
    print_l_v4 #0,txt$

  let t=date-t0
  print \\\\"v4: ";t;" seconds"

  ' Results on 2017-10-17:
  '
  ' times    v1    v2    v3   v4
  ' ----------------------------
  ' 256     255   255   247  324

enddef

#endif

' ==============================================================
' Change log

' 2017-10-07: Start: Code extracted from Ritimba
' (http://programandala.net/es.programa.ritimba.html) and
' improved.
'
' 2017-10-17: Write altenative versions of `print_l`,
' benchmark them, and use the best one.

' vim: filetype=sbim
