/*BIBLIOTECAS DE FUNCIONES DE USO GENERAL 1994

 AUTOR: LUIS CARLOS SALAMANCA        FECHA DE CREACION:
	 SEMINARIO DE CLIPPER

 MODIFICACION: NELSON FERNANDEZ GOMEZ


 REQUERIMIENTOS

 - Compilar: clipper funcions /w/m

 OBJETIVOS

 - Son independientes de cualquier programa

 FUNCIONES
  - nMenu, Centrar, BoxShadow, cError, LineaEstado, lPregunta, cMes cFecha
    Pausa, nMarco

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES GENERALES
       #INCLUDE "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES


**************************************************************************
* TITULO DE LA FUNCION......: CREACION DE UN MENU                        *
**************************************************************************

/*OBJETIVOS DE LA FUNCION:

  1- Desplegar un men£ dentro de una caja

  2- Retorna el n£mero de opci¢n elegida


* SINTAXIS DE LA FUNCION:

    nopc  := 1
    aMenu := { '<1. Grabar>',;
	       '<2. Corregir>',;
	       '<3. Consultar "Browse">',;
	       '<4. Indexar'}
    nOpc := nMenu(Menu,3,2,6,20,'Menu Principal',nOpc)


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMenu(aMenus,aAyudas,nFilSup,xColSup,cTitMen,;
	       cSubTit,nNroOpc,lFlecha,cColors,cChrBox)

*>>>>PARAMETROS DE LA FUNCION
/*     aMenus		    // Opciones del men£
       aAyudas              // Mensajes de ayuda

       nFilSup	            // Fila Superior
       xColSup	            // Columna Superior o Columas para las opciones

       cTitMen		    // Titulo para el men£ opcional
       cSubTit              // Subtitulo para el men£
       nNroOpc		    // N£mero de opci¢n inicial. opicional

       lFlecha              // .T. Desplazamientos con las flechas
       cColors              // Colores para el men£
       cChrBox              // Tipo linea para el marco,sencillo,doble,etc */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan	    // Salvar Pantalla
       LOCAL cSalvar        // Salvar Pantalla

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cClrAnt := ''  // Expresi¢n Color Anterior
       LOCAL xColors	    // Colores para el Men£
       LOCAL cClrMar := ''  // Color del Marco
       LOCAL cClrTit := ''  // Color para los T¡tulos
       LOCAL cClrMnu := ''  // Color del Men£

       LOCAL lHoriz         // Clase de men£ Vertical o Horizontal
       LOCAL nFilInf := 0   // Fila Inferior
       LOCAL nColInf := 0   // Columna Inferior
       LOCAL nLenOpc := 0   // Longitud mayor de los prompts del men£

       LOCAL i       := 0   // Contador
       LOCAL lHayErr := .F. // Variable de validaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       IF aMenus == NIL .OR. LEN(aMenus) > (MAXROW()-3)
	  RETURN NIL
       ENDIF
     *ÀSi no se envi¢ arreglo o no cabe en la pantalla, retorna NIL

       nNroOpc := IF(nNroOpc == NIL,1,nNroOpc )
       nFilSup := IF(nFilSup == NIL,1,nFilSup)

       cChrBox := IF( cChrBox == NIL, "ÉÍ»º¼ÍÈº", cChrBox )
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>ANALISIS DEL COLOR
       cColors := IF( cColors == NIL,;
		     IF(!EMPTY(xClrSys),xClrSys[5],''),cColors )

       Colores(xColores(cColors),@cClrMnu,@cClrMar,@cClrTit)
*>>>>IF ANALISIS DEL COLOR

*>>>>DETERMINACION DE LA CLASE MENU
       DO CASE
       CASE VALTYPE(xColSup) == "N"
	    lHoriz := .F.
       CASE VALTYPE(xColSup) == "A"
	    lHoriz := .T.
       OTHERWISE
	    RETURN NIL
       ENDCASE
*>>>>FIN DETERMINACION DE LA CLASE MENU

*>>>>LONGITUD MAYOR DE LAS OPCIONES Y VALIDACION DE TIPO
       IF !lHoriz
	   ASCAN(aMenus, {|str| nLenOpc := MAX(nLenOpc,LEN(str)), ;
			   lHayErr := (VALTYPE(str) <> "C" ) } )
	  *Longitud mayor de todos los elementos y validaci¢n tipo caracter

	   IF lHayErr
	      RETURN NIL
	   ENDIF
	  *Si alg£n elemento no es caracter retorna NIL
       ENDIF
*>>>>FIN LONGITUD MAYOR DE LAS OPCIONES Y VALIDACION DE TIPO

*>>>>DETERMINACION DE LAS COORDENADAS INFERIORES
       IF !lHoriz
	  nFilInf := nFilSup + LEN(aMenus) + 1
	  nColInf := xColSup + nLenOpc + 1
       ELSE
	  nFilInf := nFilSup + 2
	  nColInf := xColSup[LEN(aMenus)]+LEN(aMenus[LEN(aMenus)])
       ENDIF
*>>>>FIN DETERMINACION DE LAS COORDENADAS INFERIORES

*>>>>ESPECIFICACIONES INICIALES
      cSavPan := SAVESCREEN(nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),;
			    nFilInf,nColInf) //Guarda Pant
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>DIBUJO DEL MARCO
       cClrAnt := cSetColor(cClrMar)
      *Color del Marco

       SCROLL (nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),;
	       nFilInf,nColInf,0)                      // Limpia porcion

       DISPBOX(nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),;
	       nFilInf,nColInf,cChrBox)                // Dibuja marco
       SetClrTo()
*>>>>FIN DIBUJO DEL MARCO

*>>>>CENTRAR LOS TITULOS DEL MENU
       IF cTitMen <> NIL
	  cSetColor(cClrTit)
	 *Color del T¡tulo

	  centrar("["+cTitMen+"]",;
		  nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),nColInf)
	  SetClrTo()
       ENDIF
       IF cSubTit <> NIL
	  cSetColor(cClrTit)
	 *Color del T¡tulo

	  centrar("["+cSubTit+"]",;
		  nFilInf,IF(lHoriz,xColSup[1]-1,xColSup),nColInf)
	  SetClrTo()
       ENDIF
*>>>>FIN CENTRAR LOS TITULOS DEL MENU

*>>>>VISUALIZACION DEL MENU
*      BoxShadow(nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),nFilInf,nColInf )
      *Dibuja sobra del menu

       IF aAyudas # NIL
	  cSalvar := SAVESCREEN(22,00,22,79) // Salva la l¡nea de la ayuda
       ENDIF

       cSetColor(cClrMnu)
      *Color del Men£

       FOR i := 1 TO LEN(aMenus)
	   IF lHoriz
	      @ nFilSup+1,xColSup[i] PROMPT aMenus[i] MESSAGE ;
					    IF (aAyudas == NIL,'',aAyudas[i])
	   ELSE
	      @ ++nFilSup,xColSup+1 PROMPT LEFT(aMenus[i]+SPACE(nLenOpc),nLenOpc);
				    MESSAGE IF (aAyudas == NIL,'',aAyudas[i])
	   ENDIF
       NEXT

       lFlecha := IF(lFlecha==NIL,.T.,lFlecha)
       IF !lHoriz
	  IF lFlecha
	     SET KEY K_LEFT  TO Left_Arrow()
	     SET KEY K_RIGHT TO Right_Arrow()
	     MENU TO nNroOpc
	     SET KEY K_LEFT  TO
	     SET KEY K_RIGHT TO
	  ELSE
	     MENU TO nNroOpc
	  ENDIF
       ELSE
	  MENU TO nNroOpc
       ENDIF
       IF aAyudas # NIL
	  RESTSCREEN(22,00,22,79,cSalvar) // Restaura la l¡nea de ayuda
       ENDIF
*>>>>FIN VISUALIZACION DEL MENU

*>>>>RESTAURACION DE LA FILA SUPERIOR
       IF !lHoriz
	  nFilSup := nFilSup - LEN(aMenus)
       ENDIF
*>>>>FIN RESTAURACION DE LA FILA SUPERIOR

*>>>>ESPECIFICACIONES FINALES
       IF nNroOpc == 0
	  SCROLL(nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),nFilInf,nColInf,0)
       ENDIF
      *Borra el men£

       IF nNroOpc == 0
	  RESTSCREEN(nFilSup,IF(lHoriz,xColSup[1]-1,xColSup),;
		     nFilInf,nColInf,cSavPan)  // Restaura Pant
       ENDIF
       SETCOLOR(cClrAnt)                   // Restaura Color

       RETURN nNroOpc //N£mero de opci¢n escogida

       FUNCTION Left_Arrow()
       KEYBOARD CHR(27)+CHR(19)+CHR(13)
       RETURN NIL

       FUNCTION Right_Arrow()
       KEYBOARD CHR(27)+CHR(4)+CHR(13)
       RETURN NIL
*>>>>FIN ESPECIFICACIONES FINALES


**************************************************************************
* TITULO DE LA FUNCION......: CALCULAR COLUMNAS                          *
**************************************************************************

/*OBJETIVOS DE LA FUNCION:

  1- Calcula las columnas para las opciones de un men£ vertical

  2- Retorna el arreglo con las columnas

**SINTAXIS DE LA FUNCION:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aColOpc(aMenOPc,nSpaces,lLenMar)

*>>>>PARAMETROS DE LA FUNCION
/*     aMenOpc              // Men£ de Opciones
       nSpaces              // Espacios entre las opciones
       lLenMar             //  .T. Marco de 80 Columnas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nTotLen := 0   // Suma Total de caracteres de las opciones
       LOCAL aColOpc := ARRAY(LEN(aMenOPc))
       LOCAL i       := 0   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TOTAL CARACTERES DE LAS OPCIONES
       FOR i:=1 TO LEN(aMenOpc)
	   nTotLen += LEN(aMenOPc[i])
       NEXT
*>>>>FIN TOTAL CARACTERES DE LAS OPCIONES

*>>>>CALCULO DE LOS ESPACIOS ENTRE LAS OPCIONES
       IF nSpaces == NIL
	  nSpaces := INT((80-nTotLen) / (LEN(aMenOpc)-1))
       ENDIF
*>>>>FIN CALCULO DE LOS ESPACIOS ENTRE LAS OPCIONES

*>>>>CALCULO DE LAS OPCIONES
       aColOpc[1] := 1
       FOR i:= 2 TO LEN(aMenOpc)
	   aColOpc[i] := aColOpc[i-1]+LEN(aMenOpc[i-1])+nSpaces
       NEXT
*>>>>FIN CALCULO DE LAS OPCIONES

*>>>>RECALCULO DE LA ULTIMA COLUMNA
       lLenMar := IF(lLenMar == NIL,.F.,lLenMar)
       IF LEN(aMenOpc) # 1 .AND. lLenMar
	  aColOpc[LEN(aMenOpc)] := 79-LEN(aMenOpc[LEN(aMenOpc)])
       ENDIF
       RETURN aColOpc
*>>>>FIN RECALCULO DE LA ULTIMA COLUMNA


**************************************************************************
* TITULO DE LA FUNCION......: CENTRAR TEXTO                              *
**************************************************************************

/*OBJETIVOS DE LA FUNCION:

  1- Imprime un mensaje centrado entre dos columnas en una fila dada

  2- Retorna NIL

**SINTAXIS DE LA FUNCION:

  centrar('MENSAJE')          // Centra en la fila actual
  centrar('MENSAJE,12)        // Centra en la fila 12
  centrar('MENSAJE',24,60,79) // Centra en la fila 24 entre Columnas 60 y 79


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Centrar(cMsgTxt,nFilCen,nColIni,nColFin)

*>>>>PARAMETROS DE LA FUNCION
/*     cMsgTxt        // Texto a centrar
       nFilCen        // Fila a centrar
       cColIni        // Columna Inicial a Centrar
       nColFin        // Columna Inicial a Centrar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nPosIni  // Posici¢n inicial del texto
       LOCAL nFilCur  // Fila actual del cursor
       LOCAL nColCur  // Columna actual del cursor
       LOCAL nLenTxt  // Longitud del texto a desplegar
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ESPECIFICACIONES INICIALES
       nFilCur := ROW()
       nColCur := COL()
       nLenTxt := LEN(cMsgTxt)
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>ANALISIS DE LOS PARAMETROS
       nFilCen := IF(nFilCen == NIL,ROW(),nFilCen)    // Defecto fila cursor
       nColIni := IF(nColIni == NIL,0,nColIni)        // Defecto Columna 0
       nColFin := IF(nColFin == NIL,MAXCOL(),nColFin) // Defecto Columna 79
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>CENTRADO DEL TEXTO
       nLenTxt := MIN(nLenTxt,(nColFin-nColIni+1))
      *Maximo de espacio disponible

       nPosIni := nColIni+INT(nColFin-nColIni+1-nLenTxt)/2
      *Calculo de la posici¢n inicial

       @ nFilCen,nPosIni SAY SUBSTR(cMsgTxt,1,nLenTxt) // Despliega texto
*>>>>FIN CENTRADO DEL TEXTO

*>>>>ESPEFICACIONES FINALES
       DEVPOS(nFilCur,nColCur) // Ubica el cursor
       RETURN .T.
*>>>>FIN ESPEFICACIONES FINALES


**************************************************************************
* TITULO DE LA FUNCION......: SOMBRA                                     *
**************************************************************************

/*OBJETIVOS DE LA FUNCION:

  1- Pendiente

**SINTAXIS DE LA FUNCION:

  1- Pendiente


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BoxShadow( nTop, nLeft, nBottom, nRight )
 LOCAL nShadTop, nShadLeft, nShadBottom, nShadRight
   
 nShadTop   := nShadBottom := MIN(nBottom + 1, MAXROW())
 nShadLeft  := nLeft + 1
 nShadRight := MIN(nRight + 1, MAXCOL())

 RESTSCREEN( nShadTop, nShadLeft, nShadBottom, nShadRight,;
     transform( SAVESCREEN(nShadTop, nShadLeft, nShadBottom,nShadRight),;
     replicate("X", nShadRight - nShadLeft + 1 ) ) )

 nShadTop    := nTop + 1
 nShadLeft   := nShadRight := MIN(nRight + 1, MAXCOL())
 nShadBottom := nBottom

 RESTSCREEN( nShadTop, nShadLeft, nShadBottom, nShadRight,;
     transform( SAVESCREEN(nShadTop,  nShadLeft , nShadBottom, nShadRight),;
     replicate("X", nShadBottom - nShadTop + 1 ) ) )

RETURN NIL

/**************************************************************************
* TITULO DE LA FUNCION......: MEMSAJE DE ERROR                           *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Visualiza un marco con un mensaje de advertencia para el usuario

  2- Retorna  : El caracter que presion¢ el usuario en may£sculas

* SINTAXIS:

  ctecPul := cError('prueba de error')


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cError(cMsgErr,cTitMar,cPieMar)

*>>>PARAMETROS DE LA FUNCION
/*    cMsgErr        // Mensaje del error
      cTitMar         // Titulo del marco
      cPieMar         // Pie del marco */
*>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilCur  // Fila de Cursor
       LOCAL nColCur  // Columna del Cursor
       LOCAL nTipCur  // Tipo de Cursor

       LOCAL nFilSup  // Fila Superior
       LOCAL nColSup  // Columna Superior
       LOCAL nFilInf  // Fila Inferior
       LOCAL nColInf  // Columna Inferior

       LOCAL nTecPul  // Tecla Pulsada
       LOCAL nLenTxt  // Longitud del Texto
       LOCAL cSavPan  // Salvar Pantalla
       LOCAL cSavCol  // Salvar Color

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cClrErr := ''                  // Color Mensaje de Error

       SET DEVICE TO SCREEN
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[1],'')),;
	       ,,,,,,,,@cClrErr)

*>>>>IF ANALISIS DEL COLOR

*>>>>ANALISIS DE LOS PARAMETROS
       cTitMar := IF(cTitMar == NIL, '!Atenci¢n!',cTitMar)
       cPieMar := IF(cPieMar == NIL, 'Presione una tecla para Continuar',cPieMar)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>ESPECIFICACIONES INICIALES
       nLenTxt := MIN(MAX(MAX(LEN(cPieMar),LEN(cMsgErr)),LEN(cTitMar)),;
		      MAXCOL()-2)
       nFilSup := 09
       nFilInf := 15
       nColSup := (79-(nLenTxt+1))/2
       nColInf := nColSup+nLenTxt+1
     *ÀInicializacion de las coordenadas

       nFilCur := ROW()            // Fila de Cursor
       nColCur := COL()            // Columna del Cursor
       nTipCur := SETCURSOR(0)     // Guarda tipo de cursor y Apagarlo

       cSavPan := SAVESCREEN(nFilSup,nColSup,nFilInf,nColInf) // Guarda pant
       cSavCol := SETCOLOR('N/W+') // Cambia y guarda color original
       cSetColor(cClrErr)
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>DIBUJO DEL MARCO
       SCROLL(nFilSup,nColSup,nFilInf,nColInf,0)             // Limpia Regi¢n
       dispBox(nFilSup,nColSup,nFilInf,nColInf,1)            // Dibuja Marco
       dispBox(nFilSup+2,nColSup+1,nFilSup+2,nColInf-1)      // Linea 1
       dispBox(nFilSup+4,nColSup+1,nFilSup+4,nColInf-1)      // Linea 2
*>>>>FIN DIBUJO DEL MARCO

*>>>>VISUALIZACION DEL TEXTO
       centrar(cTitMar,nFilSup+1,nColSup+1,nColInf-1) // Titulo
       centrar(cMsgErr,nFilSup+3,nColSup+1,nColInf-1) // Mensaje
       centrar(cPieMar,nFilSup+5,nColSup+1,nColInf-1) // Pie
       tone(3500,3)
       tone(1000,1)
*>>>>FIN VISUALIZACION DEL TEXTO

*>>>>RESTAURAR ESPECIFICACIONES
       nTecPul := INKEY(0)        // Lectura de tecla pulsada
       RESTSCREEN( nFilSup,nColSup,nFilInf,nColInf,cSavPan) // Restaura Pant
       SETCOLOR(cSavCol)          // Restaura Color
       @ nFilCur,nColCur SAY ''   // Reubica cursor
       SETCURSOR(nTipCur)         // Restaura el Cursor
       SetClrTo()

       RETURN UPPER(CHR(nTecPul)) // Retorna caracter
*>>>>FIN ESPEFICACIONES FINALES

**************************************************************************
* TITULO DE LA FUNCION......: LINEA DE ESTADO                            *
**************************************************************************

/*OBJETIVOS DE LA FUNCION:

  1- Imprime la l¡nea de estado del sistema, junto con los derechos de autor

  2- Retorna NIL

**SINTAXIS DE LA FUNCION:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LineaEstado(cMsgTxt,cNomSis,lSiorNo)

*>>>>PARAMETROS DE LA FUNCION
/*     cMsgTxt                              // Texto de la l¡nea de Estado
       cNomSis                              // Nombre de sistema
       lSiorNo                              // .T. = Centrar .F. = No Centrar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cNomAut := ''                  // Nombre del autor
       LOCAL cClrAnt := ''                  // Color Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA LINEA DE ESTADO
       lSiorNo := IF(lSiorNo == NIL,.T.,lSiorNo)
       IF lSiorNo
	  cMsgTxt := SPACE(40-LEN(cMsgTxt)/2)+;
		     cMsgTxt+;
		     SPACE(40-LEN(cMsgTxt)/2)
       ELSE
	  cMsgTxt := cMsgTxt+SPACE(80-LEN(cMsgTxt))
       ENDIF
       IF LEN(cMsgTxt) < 80
	  cMsgTxt += SPACE(80-LEN(cMsgTxt))
       ENDIF

       cNomAut := '. AUTOR: ING. NELSON FERNANDEZ GOMEZ'
       cNomAut := '. ALL RIGHTS RESERVED.'
       IF CHECKSUM(cNomAut)+4 <> 369466826
	  cError('DA¥OS EN EL SISTEMA')
	  CLOSE ALL
	  QUIT
       ENDIF

       SET COLOR TO I
       @ 23,00 SAY cMsgTxt
       SetClrTo()
       Centrar(cNomSis+cNomAut,24,1,68)
       SHOWTIME(24,69,.F.,,.T.,.T.)
       RETURN NIL
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO


/**************************************************************************
* TITULO DE LA FUNCION......: PREGUNTA DE DECISION                       *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Realiza un pregunta con respuesta posible de Si o No

  2- Retorna el valor l¢gico de la respuesta

* SINTAXIS

  lSiorNo := lpregunta('DESEA CORREGIR EL MES? Si No')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lpregunta(cMsgTxt,nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cMsgTxt                    // Pregunta
       nNroFil                    // Fila para la pregunta
       nNroCol                    // Colaumna para la pregunta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan	          // Salvar pantalla
       LOCAL nColUno              // Columna 1 de la opci¢n
       LOCAL nColDos              // Columna 2 de la opci¢n
       LOCAL nNroOpc              // N£mero de la opci¢n escogida
       LOCAL lSiorNo              // Variable l¢gica
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL SI Y DEL NO
       #DEFINE SI SUBS(cMsgTxt,nColUno-nNroCol+1,2)
       #DEFINE NO SUBS(cMsgTxt,nColDos-nNroCol+1,2)
*>>>>FIN DECLARACION DEL SI Y DEL NO

*>>>>CALCULO DE LAS COORDENADAS
       tone(3500,3)
       nNroFil := IF(nNroFil == NIL,22,nNroFil)
       nNroCol := IF(nNroCol == NIL,(80-LEN(cMsgTxt))/2,nNroCol)
       nColUno := (nNroCol+LEN(cMsgTxt)-5)
       nColDos := (nNroCol+LEN(cMsgTxt)-2)
       cSavPan := SAVESCREEN(nNroFil,nNroCol,nNroFil,nColUno+5)
*>>>>FIN CALCULO DE LAS COORDENADAS

*>>>>PREGUNTA DE DECISION
       @ nNroFil,nNroCol SAY cMsgTxt

       nNroOpc := 0
       DO WHILE nNroOpc == 0
	  @ nNroFil,nColUno PROMPT SI
	  @ nNroFil,nColDos PROMPT NO
	  MENU TO nNroOpc
       ENDDO
*>>>>FIN PREGUNTA DE DECISION

*>>>>ANALISIS DE LA RESPUESTA
       DO CASE
       CASE nNroOpc == 1
	    lSiorNo := IF(UPPER(SI) == 'SI',.T.,.F.)

       CASE nNroOpc == 2
	    lSiorNo := IF(UPPER(NO) == 'NO',.F.,.T.)
       ENDCASE
       RESTSCREEN(nNroFil,nNroCol,nNroFil,nColUno+5,cSavPan)
       RETURN lSiorNo
*>>>>FIN ANALISIS DE LA RESPUESTA

/*************************************************************************
* TITULO DE LA FUNCION......: NOMBRE DEL MES EN TEXTO                    *
**************************************************************************

OBJETIVOS:

  1- Retorna el nombre del mes

SINTAXIS

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cMes(nNroMes,nNroLen)

*>>>>DECLARACION DE VARIABLES
       LOCAL cMeses := ''                   // Meses
       LOCAL cMes   := ''                   // Mes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONVERSION DEL MES
       cMeses := 'ENERO     FEBRERO   MARZO     ABRIL     '+;
		 'MAYO      JUNIO     JULIO     AGOSTO    '+;
		 'SEPTIEMBREOCTUBRE   NOVIEMBRE DICIEMBRE '

       nNroLen := IF(nNroLen == NIL .OR. nNroLen > 10 ,10,nNroLen)

       IF nNroMes >= 1 .AND. nNroMes <= 12
	  cMes := ALLTRIM(SUBS(cMeses,nNroMes*10-9,nNroLen))
       ELSE
	  cMes := SPACE(nNroLen)
       ENDIF
       RETURN cMes
*>>>>FIN CONVERSION DEL MES


/*************************************************************************
* TITULO DE LA FUNCION......: NOMBRE DEL DIA EN TEXTO                    *
**************************************************************************

OBJETIVOS:

1- Retorna el nombre del dia

SINTAXIS

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cDia(nNroDia,nLenDia)

*>>>>CONVERSION DEL MES
       LOCAL cDias := 'DOMINGO  LUNES    MARTES   MIERCOLES'+;
		      'JUEVES   VIERNES  SABADO   '
       nLenDia := IF(nLenDia == NIL .OR. nLenDia > 9 ,3,nLenDia)
       RETURN RTRIM(SUBS(cDias,nNroDia*9-8,nLenDia))
*>>>>FIN CONVERSION DEL MES


/**************************************************************************
* TITULO DE LA FUNCION......: CONVERCION DE FECHA                        *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Convierte una variable de tipo fecha al formato texto

  2- Retorna la fecha en texto


* SINTAXIS

  dFecNac := CTOD("03/24/94")
  cFecNac := cFecha(fecnac)    => MAR 24/94

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFecha(dFecha,nLenMes)

*>>>>PARAMETROS DE LA FUNCION
/*     dFecha                 // Fecha en formato date
       nLenMes                // Longitud del nombre del mes */
*>>>>PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIBLES
       LOCAL nNromes := 0         // N£mero del mes
       LOCAL cNrodia := ''        // N£mero del d¡a
       LOCAL cNroano := ''       // N£mero del a¤o
       LOCAL cFecha  := ''         // Fecha en caracter
*>>>>FIN DECLARACION DE VARIBLES

*>>>>CONVERSION DE LA FECHA
       nLenMes := IF(nLenMes == NIL .OR. nLenMes >10,3,nLenMes)
       cFecha := SPACE(nLenMes+8)
       IF !EMPTY(dFecha)
	  nNromes := VAL(STR(MONTH(dFecha),2))
	  cNrodia := STR(DAY(dFecha),2)

	  IF LEN(DTOC(dFecha)) == 8
	     cNroano := SUBS(STR(YEAR(dFecha),4), 3,2)
	  ELSE
	     cNroano := STR(YEAR(dFecha),4)
	  ENDIF
	  cFecha  := ALLTRIM(cMes(nNromes,nLenMes))+' '+cNrodia+'/'+cNroano
       ENDIF
       RETURN cFecha
*>>>>FIN CONVERSION DE LA FECHA

/**************************************************************************
* TITULO..: SEPARACION DE LA FECHA                                        *
***************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 20/2004 MAR A
       Colombia, Bucaramanga        INICIO: 03:00 PM   ABR 20/2004 MAR

OBJETIVOS:

1- Separa la fecha en a¤o,mes,dia en un vector

2- Retorna la fecha separada en un vector

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aFecha(dFecha)

*>>>>DESCRIPCION DE PARAMETROS
/*     dFecha                              // Fecha en formato date */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIBLES
       LOCAL cNroAno := SPACE(04)                 // N£mero del a¤o
       LOCAL cNroMes := SPACE(02)                 // N£mero del mes
       LOCAL cNroDia := SPACE(02)                 // N£mero del d¡a
       LOCAL aFecha  := {}                        // Fecha en Vector
*>>>>FIN DECLARACION DE VARIBLES

*>>>>CONVERSION DE LA FECHA
       AADD(aFecha,cNroMes)
       AADD(aFecha,cNroDia)
       AADD(aFecha,cNroAno)

       IF !EMPTY(dFecha)

	  cNroAno := STR(YEAR(dFecha),4)
	  lCorrecion(@cNroAno)

	  cNroMes := STR(MONTH(dFecha),2)
	  lCorrecion(@cNroMes)

	  cNroDia := STR(DAY(dFecha),2)
	  lCorrecion(@cNroDia)

	  aFecha[1] := cNroMes
	  aFecha[2] := cNroDia
	  aFecha[3] := cNroAno

       ENDIF
       RETURN aFecha
*>>>>FIN CONVERSION DE LA FECHA

/**************************************************************************
* TITULO..: CONVERTION DE FECHA NUMERICA A FORMATO FECHA                  *
***************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 19/2005 VIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   AGO 19/2005 VIE

OBJETIVOS:

1- Convierte el formato de la fecha numerica a formato fecha

2- Retorna la fecha

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION dFecha(nNroAno,nNroMes,nNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroAno                              // N£mero del A¤o
       nNroMes                              // N£mero del Mes
       nNroDia                              // N£mero del Dia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cNroAno := SPACE(04)                 // N£mero del a¤o
       LOCAL cNroMes := SPACE(02)                 // N£mero del mes
       LOCAL cNroDia := SPACE(02)                 // N£mero del d¡a
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONVERSION DE LA FECHA
       cNroAno := STR(nNroAno,4)
       lCorrecion(@cNroAno)

       cNroMes := STR(nNroMes,2)
       lCorrecion(@cNroMes)

       cNroDia := STR(nNroDia,2)
       lCorrecion(@cNroDia)

       RETURN CTOD(cNroMes+'\'+cNroDia+'\'+cNroAno)
*>>>>FIN CONVERSION DE LA FECHA


/*************************************************************************
* TITULO..: FECHA FINAL DEL MES                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 30/2012 ABR A
       Colombia, Bucaramanga        INICIO: 09:00 AM   ABR 30/2012 ABR

OBJETIVOS:

1- Calcula el d¡a del final del Mes

2- Retorna la fecha final del Mes

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION dFecFinMes(dFecha)

*>>>>DESCRIPCION DE PARAMETROS
/*     dFecha                               // Fecha                    */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL  aFecha := {}                  // Fecha de Proceso
       LOCAL cNroAno := ''                  // Numero del Actual
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL cNroDia := ''                  // N£mero del d¡a
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha de Proceso
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FECHA FINAL DEL MES
	aFecha := aFecha(dFecha)
       cNroAno := aFecha[3]
       cNroMes := aFecha[1]

       DO CASE
       CASE VAL(cNroMes) == 2
	    IF MOD(VAL(cNroAno),4) == 0
	       cNroDia := '29'
	    ELSE
	       cNroDia := '28'
	    ENDIF

       CASE VAL(cNroMes) == 11 .OR. VAL(cNroMes) == 04 .OR.;
	    VAL(cNroMes) == 06 .OR. VAL(cNroMes) == 09
	    cNroDia := '30'
       OTHERWISE
	    cNroDia := '31'
       ENDCASE
       RETURN CTOD(cNroMes+'\'+cNroDia+'\'+cNroAno)
*>>>>FIN FECHA FINAL DEL MES


/**************************************************************************
* TITULO DE LA FUNCION......: PAUSA EN LA EJECUCION                      *
**************************************************************************

OBJETIVOS:

1- Hace una pausa en la ejecuci¢n del programa

SINTAXIS:

  cPausa()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPausa(nNroFil,cMsgTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                               // N£mero de la fila
       cMsgTxt                               // Texto para la pausa */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan                        // Salvar Pantalla
       LOCAL nTecPul                        // Tecla Pulsada
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PAUSA EN LA EJECUCION
       cMsgTxt := IF(cMsgTxt == NIL,'Presione <ENTER> para continuar',cMsgTxt)
       nNroFil := IF(nNroFil == NIL,22,nNroFil)

       cSavPan := SAVESCREEN(nNroFil,00,nNroFil,79)
       centrar(cMsgtxt,nNroFil)
       nTecPul := INKEY(0)
       RESTSCREEN(nNroFil,00,nNroFil,79,cSavPan)
       RETURN UPPER(CHR(nTecPul))
*>>>>FIN PAUSA EN LA EJECUCION

/*************************************************************************
* TITULO DE LA FUNCION...: MARCO PARA VISULIZACION DE TEXTO              *
**************************************************************************

OBJETIVOS:

1- Crea un marco para la visualizaci¢n de texto

2- Retorna el n£mero de la fila para la impresi¢n del texto

SINTAXIS:

  nNroFil := nMarco(03,19,'POR FAVOR ESPERE MIENTRAS SE COPIAN LOS CLIENTES')
  @ nNroFil,01 SAY 'NELSON FERNANDEZ GOMEZ'

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMarco(nFilSup,cTitulo,nFilInf,cHrfill,cColors,nColSup,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup                  // Fila Superior para el marco
       cTitulo                  // Titulo para el marco
       nFilInf                  // Fila Inferior para el marco
       cHrfill                  // Caracter de relleno
       cColors                  // Colores para el Marco
       nColSup                  // Columna Superior
       nColInf                  // Columna Inferior  */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL xColors	                    // Colores para el Marco
       LOCAL cClrMar := ''                  // Color del Marco
       LOCAL cClrTit := ''                  // Color del Titulo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       cColors := IF( cColors == NIL, '', cColors )
       xColors := xColores(cColors)

       IF !EMPTY(cColors)
	  FOR i := 1 TO LEN(xColors)
	    DO CASE
	    CASE i == 1
		 cClrMar := xColors[1]  // Marco y Fondo
	    CASE i == 2
		 cClrTit := xColors[2]  // Titulo
	    ENDCASE
	  ENDFOR
       ENDIF
*>>>>IF ANALISIS DEL COLOR

*>>>>CREACION DEL MARCO
       nColSup := IF(nColSup == NIL,00,nColSup)
       nFilInf := IF(nFilInf == NIL,22,nFilInf)
       nColInf := IF(nColInf == NIL,79,nColInf)
       cHrfill := IF(cHrfill == NIL,' ',cHrfill)

       cSetColor(cClrMar)  // Color del Marco y fondo
       DISPBOX(nFilSup,nColSup,nFilInf,nColInf,'ÚÄ¿³ÙÄÀ³'+cHrfill)
       @ nFilSup+2,nColSup+1 TO nFilSup+2,nColInf-1
       SetClrTo()
     *ÀDibujo del Marco

       IF cTitulo # NIL
	  cSetColor(cClrTit)  // Color del Titulo
	  centrar(cTitulo,nFilSup+1,nColSup,nColInf)
	  SetClrTo()
       ENDIF
       RETURN nFilSup+3
*>>>>FIN CREACION DEL MARCO

/*************************************************************************
* TITULO DE LA FUNCION..: TITULO PARA LA BUSQUEDA                        *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 01/94 VIE A
						       JUL 01/94 VIE
1- Dibuja un marco como t¡tulo para la b£squeda de un c¢digo

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION TitBuscar(nLenCam,nNroFil,nNroCol,cTitDos,cTitUno,nFilInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nLenCam                              // Longitud del campo
       nNroFil                              // Fila de Captura
       nNroCol                              // Columna de Captura
       cTitDos                              // T¡tulo Dos
       cTitUno                              // T¡tulo Uno */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenTxt := 0                   // Longitud de Texto
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nColInf := 0                   // Columna Inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ESPECIFICACIONES INICIALES
       cTitUno := IF(EMPTY(cTitUno),'BUSCAR',cTitUno)
       cTitDos := IF(cTitDos == NIL,'ENTRE EL CODIGO:',cTitDos)
       nLenTxt := MIN(MAX(LEN(cTitDos),nLenCam ),MAXCOL()-2)
*>>>>FIN ESPECIFICACIONES INICIALES

*>>>>INICIALIZACION DE LAS COORDENADAS
       nFilSup := 10
       nFilInf := IF(EMPTY(nFilInf),13,nFilInf)
       nColSup := (79-(nLenTxt+1))/2
       nColInf := nColSup+nLenTxt+1
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>DIBUJO DEL MARCO
       dispBox(nFilSup,nColSup-1,nFilInf,nColInf+1,'ÉÍ»º¼ÍÈº°')
       centrar(cTitUno,nFilSup,nColSup+1,nColInf-1)
       @ nFilSup+1,nColSup+1 SAY cTitDos

*       tone(3500,3)
*       tone(1000,1)
       nNroFil := nFilSup+2
       nNroCol := nColSup+1
       RETURN NIL
*>>>>FIN DIBUJO DEL MARCO

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL MES DE ACUERDO A UN ARREGLO      *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 11/94 LUN A
						       JUL 11/94 LUN
1- Permite escoger un mes de acuerdo a un Browse de un arreglo con los
   meses del a¤o.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el n£mero del mes escogido en tipo caracter

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSelMes(nNroFil,nNroCol,lTodos)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de Impresi¢n
       nNroCol                              // Columna de Impresi¢n
       lTodos                               // .T. Todos los meses */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMeses  := NIL                 // Arreglo de meses
       LOCAL nNroMes := 0                   // N£mero del mes
       LOCAL cNroMes := ''                  // N£mero del mes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DEL VECTOR
       lTodos := IF(lTodos == NIL,.T.,lTodos)
       IF lTodos
	  aMeses := {'ENE','FEB','MAR','ABR','MAY','JUN',;
		     'JUL','AGO','SEP','OCT','NOV','DIC'}
       ELSE
	  aMeses := {'FEB','MAR','ABR','MAY','JUN',;
		     'JUL','AGO','SEP','OCT','NOV'}
       ENDIF
*>>>>FIN INICIALIZACION DEL VECTOR

*>>>>SELECCION DEL MES
      cSavPan := SAVESCREEN(,,,)
      nNroMes := nMenu(aMeses,NIL,nNroFil,nNroCol,NIL,NIL,1)
      RESTSCREEN(,,,,cSavPan)
*>>>>FIN SELECCION DEL MES

*>>>>CORRECION AUTOMATICA DEL MES
       DO CASE
       CASE nNroMes == 0
	    cNroMes := SPACE(02)

       CASE nNroMes > 0 .AND. nNroMes < 10
	    cNroMes := '0'+STR(nNroMes,1)

       CASE nNroMes <= 12
	    cNroMes := STR(nNroMes,2)
       ENDCASE
       RETURN cNroMes
*>>>>FIN CORRECION AUTOMATICA DEL MES


/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION CARACTER DEL MES
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 26/94 MAR A
						       JUL 26/94 MAR
1- Retorna por referencia los param‚tros de la funci¢n marcados con @

2- Valida el mes, en caso de error permite seleccionar
   el mes correcto

4- Retorna .T.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lcValMes(nNroFil,nNroCol,cNroMes,lTodos)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cNroMes				    // @N£mero del mes
       lTodos                               // .T. Todos los Meses */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL MES
       DO CASE
       CASE VAL(cNroMes)  > 0 .AND. VAL(cNroMes) <= 12
       OTHERWISE
	    lTodos := IF(lTodos == NIL,.T.,lTodos)
	    cNroMes := cSelMes(nNroFil,nNroCol,lTodos)
	    lHayErr := .F.
       ENDCASE
*>>>>FIN FIN VALIDACION MES

*>>>>CORRECION AUTOMATICA DEL MES
       IF lHayErr
	  DO CASE
	  CASE VAL(cNroMes) == 0
	       cNroMes := SPACE(02)

	  CASE VAL(cNroMes) > 0 .AND. VAL(cNroMes) < 10
	       cNroMes := '0'+STR(VAL(cNroMes),1)

	  CASE VAL(cNroMes) > 9 .AND. VAL(cNroMes) <= 12
	       cNroMes := STR(VAL(cNroMes),2)
	  ENDCASE
       ENDIF
       RETURN .T.
*>>>>FIN CORRECION AUTOMATICA DEL MES

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION NUMERICA DEL MES
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 26/94 MAR A
						       JUL 26/94 MAR
1- Retorna por referencia los param‚tros de la funci¢n marcados con @

2- Valida el mes, en caso de error permite seleccionar
   el mes correcto

4- Retorna .T.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnValMes(nNroFil,nNroCol,nNroMes,lTodos)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nNroMes				    // @N£mero del mes
       lTodos                               // .T. Todos los meses */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL MES
       DO CASE
       CASE nNroMes  > 0 .AND. nNroMes <= 12
       OTHERWISE
	    lTodos := IF(lTodos == NIL,.T.,lTodos)
	    nNroMes := VAL(cSelMes(nNroFil,nNroCol,lTodos))
       ENDCASE
       RETURN .T.
*>>>>FIN VALIDACION DEL MES

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DEL CODIGO DEL CLIENTE              *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 27/94 MIE A
						       JUL 27/94 MIE
1- Permite leer la opci¢n de un men£ texto pasado como parametro

2- Retorna el n£mero de la opci¢n escogida

SINTAXIS:

   nNroOpc := nLeeOpcion('1<DESCUENTO> 2<RECARGO> 3<NO GRABAR>?',3)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeOpcion(cMenuTxt,nTotOpc,cOpcion,nNroFil,cPregun)

*>>>>PARAMETROS DE LA FUNCION
/*     cMenuTxt                           // Men£ de Opciones
       nTotOpc			          // N£mero de Opciones
       cOpcion                            // Opcion a leer
       nNroFil                            // Fila de Lectura
       cPregun                            // Texto de la Pregunta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroCol                        // Columna de lectura
       LOCAL cSavPan                        // Salvar pantalla
       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y CONFIRMACION DE LA OPCION
       nNroFil := IF(EMPTY(nNroFil),21,nNroFil)
       cSavPan := SAVESCREEN(nNroFil,0,nNroFil,79)
       TONE(3500,3)
       SET ESCAPE OFF                    // Desactiva <ESC> salida GETS
       DO WHILE .T.

**********LECTURA DE LA OPCION
	    nNroCol := (80-LEN(cMenuTxt))/2
	    @ nNroFil,nNroCol SAY cMenuTxt


	    @ nNroFil,nNroCol+LEN(cMenuTxt) GET   cOpcion PICT '9' ;
					    VALID VAL(cOpcion) <> 0 .AND.;
						  VAL(cOpcion) <= nTotOpc
	    READ
**********FIN LECTURA DE LA OPCION

**********PREGUNTA DE DECISION
	    cPregun := IF(EMPTY(cPregun),'DESEA CORREGIR LA '+;
					 'OPCION ESCOGIDA? No Si',cPregun)
	    IF lPregunta(cPregun,nNroFil+1)
	       LOOP
	    ELSE
	       EXIT
	    ENDIF
**********FIN PREGUNTA DE DECISION

       ENDDO
       SET ESCAPE ON                    // Activa <ESC> salida GETS
       RESTSCREEN(nNroFil,0,nNroFil,79,cSavPan)
       RETURN VAL(cOpcion)
*>>>>FIN LECTURA Y CONFIRMACION DE LA OPCION

/*************************************************************************
* TITULO DE LA FUNCION..: CORRECCION AUTOMATICA DE UN CODIGO NUMERICO    *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: AGO 05/94 VIE A
						       AGO 05/94 VIE
1- Retorna por referencia los param‚tros de la funci¢n marcados con @

2- Agraga ceros a la izquierda e interpreta los espacios intermedios
   como ceros

3- Retorna el valor l¢gico

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lCorrecion(cCodigo,lCeros)

*>>>>DECLARACION DE VARIABLES
/*       cCodigo                             // @Codigo a Corregir
	 lCeros                              // .T. Permitir ceros */
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroDig := 0                   // N£mero de Digitos
       LOCAL cCeros  := ''                  // Ceros para agregar
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CORRECION DE ESPACIOS INTERMEDIOS
       nNroDig := LEN(cCodigo)
       IF cCodigo # SPACE(nNroDig)
	  cCodigo := ALLTRIM(cCodigo)
	  IF SPACE(01) $ cCodigo
	     DO WHILE AT(SPACE(01),cCodigo) # 0
		cCodigo := STUFF(cCodigo,AT(SPACE(01),cCodigo),1,'0')
	     ENDDO
	  ENDIF
       ENDIF
*>>>>FIN CORRECION DE ESPACIOS INTERMEDIOS

*>>>>INSERCION DE LOS CEROS A LA IZQUIERDA
       IF cCodigo # SPACE(nNroDig)
	  FOR i:= 1 TO nNroDig - LEN(cCodigo)
	      cCeros := cCeros+'0'
	  NEXT
	  cCodigo := cCeros+cCodigo
       ELSE
	  lCeros := IF(lCeros==NIL,.F.,lCeros)
	  IF lCeros
	     FOR i:= 1 TO LEN(cCodigo)
		 cCeros := cCeros+'0'
	     NEXT
	     cCodigo := cCeros+cCodigo
	  ELSE
	     cCodigo := SPACE(nNroDig)
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN INSERCION DE LOS CEROS A LA IZQUIERDA

/*************************************************************************
* TITULO DE LA FUNCION..: TERMOMETRO DE PROGRESO DE PROCESOS             *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: NOV 14/94 LUN A
						       NOV 14/94 LUN

1- Visualiza un term¢metro de progreso de procesos

2- Se puede utilizar para documentar cualquier proceso

3- Retorna Nil

SINTAXIS:

  Termometro(0,"CREANDO LA ESTRUCTURA DE ADMISION")
  Termometro(100)
  CreaDbfAdm()

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Termometro(nValor,cTitulo,lPrinte)

*>>>>PARAMETROS DE LA FUNCION
/*     nValor                               // Valor ejecutado
       cTitulo                              // Titulo del proceso
       lPrinte                              // .T. Impresi¢n Activa */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                   // Salvar Pantalla
       LOCAL nNroCol := 11                   // N£mero de la columna
       LOCAL       i := 0                    // Contador
       LOCAL nFilSup := 09                   // Fila Superior
       LOCAL nColSup := 09                   // Columna Superior
       LOCAL nFilInf := 14                   // Fila Inferior
       LOCAL nColInf := 63                   // Columna Inferior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA IMPRESION ACTIVA
       lPrinte := IF(lPrinte=NIL,.F.,lPrinte)
       IF lPrinte
	  SET DEVICE TO SCREEN
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION ACTIVA

*>>>>DIBUJO DEL TERMOMETRO
       IF nValor == 0

*	  SETCOLOR("w+/n")
	  @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
	  cTitulo := IF(cTitulo == NIL,"PORCENTAJE EJECUTADO",cTitulo)
	  centrar("["+cTitulo+"]",nFilSup,nColSup,nColInf)
	*ÀImpresi¢n del t¡tulo

	  @ 10,10 SAY "  1   10   20   30  40   50   60   70   80   90   100"
	  @ 11,10 SAY "ÚÙ...|....|....|....|....|....|....|....|....|....À¿ "
	  @ 12,10 SAY "³²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²³ "
	  @ 13,10 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ "
	*ÀDibujo del term¢metro
       ENDIF
*>>>>FIN DIBUJO DEL TERMOMETRO

*>>>>EJECUCION DEL TERMOMETRO
       nValor := IF(nValor > 100,100,nValor)
       IF nValor <> 0
	  FOR i = 1 TO nValor/2
*	      SOUND(880,1)
	      @ 12,nNroCol++ SAY CHR(219)
	  NEXT
       ENDIF
*>>>>FIN EJECUCION DEL TERMOMETRO

*>>>>ANALISIS DE LA IMPRESION ACTIVA
       lPrinte := IF(lPrinte=NIL,.F.,lPrinte)
       IF lPrinte
	  SET DEVICE TO PRINT
       ENDIF
       RETURN NIL
*>>>>FIN ANALISIS DE LA IMPRESION ACTIVA

/*************************************************************************
* TITULO DE LA FUNCION..: VISUALIZACION DEL AVANCE DEL TERMOMETRO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 01/95 MIE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   OCT 01/95 MIE

OBJETIVOS:

1- Visualiza la porci¢n de avance del termometro

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Avance(nNroAve,nNroFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroAve                              // N£mero de Avance
       nNroFin                              // N£mero Final de Avance */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nAvance := 0                   // Avance del Termometro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AVANCE DEL TERMOMETRO
       nAvance := INT((nNroAve/IF(lPar(nNroFin),nNroFin,nNroFin-1))*100)

       IF STR(nAvance,3) $ '25 50 75100'
	  Termometro(nAvance)
       ENDIF
       RETURN NIL
*>>>>FIN AVANCE DEL TERMOMETRO

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL MES A PROCESAR                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
						       AGO 13/94 SAB
OBJETIVOS:

1- Retorna el n£mero del mes a procesar en forma n£merica

SINTAXIS:

nMesiniTpa := nMesano(04,01)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMesAno(nFilSup,nColSup,cMsgTxt,lPregun,aOtrEle)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup		                    // N£mero de fila Superior
       nColSup                              // N£mero de Columna Superior
       cMsgTxt                              // T¡tulo del marco
       lPregun                              // .T. Pregunta para corregir
       aOtrEle                              // Elementos Adicionales */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aColSup	                    // Columnas para el men£
       LOCAL aMenus	                    // Vector de declaracion de men£
       LOCAL aAyuda                         // Vector de ayudas para el men£
       LOCAL nNroMes	                    // N£mero del mes escogido
       LOCAL lSiorNo := .T.                 // Variable l¢gica
       LOCAL       i := 0                   // Contador
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       cMsgTxt := IF(cMsgTxt == NIL,'Escoja el Mes a Procesar',cMsgTxt)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>DECLARACION DEL MENU
       aMenus := {'ENE','FEB','MAR','ABR','MAY','JUN',;
		  'JUL','AGO','SEP','OCT','NOV','DIC'}

       IF !EMPTY(aOtrEle)
	  FOR i := 1 TO LEN(aOtrEle)
	      AADD(aMenus,aOtrEle[i])
	  NEXT
       ENDIF
*>>>>DECLARACION DEL MENU

*>>>>CAPTURA Y CONFIRMACION DEL MES A PROCESAR
       DO WHILE lSiorNo

**********CALCULO DE LAS COLUMNAS DEL MENU
	    aColSup := aColOpc(aMenus,1)
	    FOR i:=1 TO LEN(aMenus)
		aColSup[i] += nColSup
	    NEXT
**********FIN CALCULO DE LAS COLUMNAS DEL MENU

**********IMPRESION Y ANALISIS DE LA OPCION ESCOGIDA
	    nNroMes := nMenu(aMenus,NIL,nFilSup,aColSup,cMsgTxt,NIL,1)

	    IF nNroMes == 0
	       EXIT
	    ENDIF
**********FIN IMPRESION Y ANALISIS DE LA OPCION ESCOGIDA

***********PREGUNTA DE DECISION
	     lPregun := IF(lPregun == NIL,.T.,lPregun)
	     lSiorNo := .F.
	     IF lPregun
		lSiorNo := lpregunta('DESEA CORREGIR EL MES? No Si')
	     ENDIF
**********FIN IMPRESION Y ANALISIS DE LA OPCION ESCOGIDA

       ENDDO
       RETURN nNroMes
*>>>>FIN CAPTURA Y CONFIRMACION DEL MES A PROCESAR

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL MES A PROCESAR                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/94 SAB A
						       AGO 13/94 SAB
OBJETIVOS:

1- Retorna el n£mero del mes a procesar en forma de caracter

SINTAXIS:

nMesiniTpa := nMesano(04,01)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cMesAno(nFilSup,nColSup,cMsgTxt,lPregun)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup		                    // N£mero de fila Superior
       nColSup                              // N£mero de Columna Superior
       cMsgTxt                              // T¡tulo del marco
       lPregun                              // .T. Pregunta para corregir */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aColSup	                    // Columnas para el men£
       LOCAL aMenus	                    // Vector de declaracion de men£
       LOCAL aAyuda                         // Vector de ayudas para el men£
       LOCAL nNroMes	                    // N£mero del mes escogido
       LOCAL cNroMes                        // N£mero del mes escogido
       LOCAL lSiorNo := .T.                 // Variable l¢gica
       LOCAL I                              // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       cMsgTxt := IF(cMsgTxt == NIL,'Escoja el Mes a Procesar',cMsgTxt)
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>DECLARACION DEL MENU
       aMenus := {'ENE','FEB','MAR','ABR','MAY','JUN',;
		  'JUL','AGO','SEP','OCT','NOV','DIC'}
*>>>>DECLARACION DEL MENU

*>>>>CAPTURA Y CONFIRMACION DEL MES A PROCESAR
       DO WHILE lSiorNo

**********CALCULO DE LAS COLUMNAS DEL MENU
	    aColSup := aColOpc(aMenus,1)
	    FOR I:=1 TO LEN(aMenus)
		aColSup[I] += nColSup
	    NEXT
**********FIN CALCULO DE LAS COLUMNAS DEL MENU

**********IMPRESION Y ANALISIS DE LA OPCION ESCOGIDA
	    nNroMes := nMenu(aMenus,NIL,nFilSup,aColSup,cMsgTxt,NIL,1)
	    cNroMes := STR(nNroMes,2)
	    lCorrecion(@cNroMes)
	    IF nNroMes == 0
	       EXIT
	    ENDIF
**********FIN IMPRESION Y ANALISIS DE LA OPCION ESCOGIDA

***********PREGUNTA DE DECISION
	     lPregun := IF(lPregun == NIL,.T.,lPregun)
	     lSiorNo := .F.
	     IF lPregun
		lSiorNo := lpregunta('DESEA CORREGIR EL MES? No Si')
	     ENDIF
**********FIN IMPRESION Y ANALISIS DE LA OPCION ESCOGIDA

       ENDDO
       RETURN cNroMes
*>>>>FIN CAPTURA Y CONFIRMACION DEL MES A PROCESAR

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DEL A¥O DEL SISTEMA                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 28/95 SAB A
       Bucaramanga,Colombia         INICIO: 08:10 PM   ENE 28/95 SAB

OBJETIVOS:

1)- Cambia el a¤o del sistema ubicado en el menu principal

2)- Crea de directorio del Path variable del sistema si no existe

3)- Retorna por referencia los param‚tros de la funci¢n marcados con @

4)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeeAnoSys(nNroCol,cAnoSys,cPatSis,cNomEmp,cNomSis)

*>>>>PARAMETROS DEL SISTEMA
/*     nNroCol                              // N£mero de la columna
       cAnoSys                              // @ A¤o del sistema
       cPatSys                              // @ Path del Sistema
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema */
*>>>>FIN PARAMETROS DEL SISTEMA

*>>>>DECLARACION DE VARIABLES
       LOCAL nTipCur := 0                   // Tipo de Cursor
       LOCAL PathAct := ''                  // Path Actual
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y VALIDACION DEL A¥O DEL SISTEMA
       SETKEY(K_F2,NIL)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
       nTipCur := SETCURSOR(1)
       DO WHILE .T.

**********LEE AL A¥O DEL SISTEMA
	    @ 2,nNroCol GET cAnoSys PICT '9999';
				    VALID VAL(cAnoSys) <> 0
	    READ
	    nNroPos := AT('.',cPatSis)
	    cPatSis := STUFF(cPatSis,nNroPos-4,4,cAnoSys)
**********FIN LEE AL A¥O DEL SISTEMA

**********VALIDACION DEL A¥O DEL SISTEMA
	    PathAct := cPathAct()
	    DO CASE
	    CASE DIRCHANGE (cPatSis) == 0
		 DIRCHANGE(PathAct)
		 EXIT

	    CASE DIRCHANGE (cPatSis) == -5
		 cError("NO TIENE DERECHOS EN EL DIRECTORIO "+cPatSis)
		 LOOP

	    CASE DIRCHANGE(cPatSis) == -3
		 cError('NO APARECE INFORMACION '+;
			'REGISTRADA PARA EL A¥O: '+cAnoSys)
		 LOOP
	    ENDCASE
**********FIN VALIDACION DEL A¥O DEL SISTEMA

       ENDDO
       SETCURSOR(nTipCur)
       @ 2,nNroCol SAY cAnoSys PICT '9999'
       RETURN NIL
*>>>>LECTURA Y VALIDACION DEL A¥O DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: CALCULO DE LA COLUMNA DEL A¥O                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/95 LUN A
       Bucaramanga,Colombia         INICIO: 05:30 PM   ENE 30/95 LUN

OBJETIVOS:

1)- Calcula la columna de lectura del a¤o del sistema ubicado en el
    menu principal.

2)- Retorna la columna de lectura del a¤o

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nColAno(aMenPri)

*>>>>PARAMETROS DEL SISTEMA
/*     aMenPri                              // Menu Principal del sistema */
*>>>>FIN PARAMETROS DEL SISTEMA

*>>>>DECLARACION DE VARIABLES
       LOCAL aColMen := {}                  // Columnas del Men£ Principal
       LOCAL nColFin := 0                   // Columna Final
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULA LA COLUMNA DE LECTURA DEL A¥O
       aColMen := aColOpc(aMenPri,NIL,.T.)
       nColFin := aColMen[LEN(aMenPri)]+LEN(aMenPri[LEN(aMenPri)])
       RETURN INT(nColFin)/2+1
*>>>>FIN LEE AL A¥O DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE UN CARACTER ALFANUMERICO            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 09/95 JUE A
       Bucaramanga,Colombia         INICIO: 02:30 PM   MAR 09/95 JUE

OBJETIVOS:

1)- Permite leer un caracter alfanumerico

2)- Permite leer la tecla <ENTER> o <ESC> para terminaci¢n de la lectura.

3)- Retorna el caracter leido

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLeeChr(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nTecPul := 0                   // Tecla pulsada
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA Y VALIDACION DEL CARACTER
       DO WHILE .T.
	  DEVPOS(nNroFil,nNroCol)
	  nTecPul := INKEY(0)
	  IF (!ISDIGIT(CHR(nTecPul)) .AND. !ISALPHA(CHR(nTecPul))) .AND.;
	     nTecPul <> K_ESC .AND. nTecPul <> K_ENTER .AND. nTecPul <> 32
	     LOOP
	  ENDIF
	  EXIT
       ENDDO
       RETURN nTecPul
*>>>>FIN LECTURA Y VALIDACION DEL CARACTER

/*************************************************************************
* TITULO DE LA FUNCION..: OPCION DE LECTURA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/95 DOM A
       Colombia, Bucaramanga        INICIO: 10:12 PM   AGO 20/95 DOM

OBJETIVOS:

1)- Lee la opci¢n para grabar o corregir un registro facilitando la
    correci¢n secuencial o directa con un caracter indicado.

2)- Permite leer la opci¢n de lectura facilitando la posibilidad
    de capturar n£meros.

3)- Retorna:
    <ESC> -> Para Abandonar o Regreasar
    + -----> Para aceptar y grabar el registro
    - -----> Para corregir secuencialmente el registro
    Un caracter para la correci¢n directa.

SINTAXIS:

 cOpcLec := cOpcionLec(nNroFil,aNroCol[8]-1,'IGCPDT','XXXX')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cOpcionLec(nNroFil,nNroCol,cValida,cPictur)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cValida                              // Caracteres a Validar
       cPictur                              // Picture de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cOpcLec := ''                  // Opci¢n de lectura
       LOCAL GetList := {}                  // Variable del Sistema

       SET ESCAPE ON
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA Y VALIDACION DE LA OPCION
       cOpcLec := ''
       cPictur := IF(cPictur == NIL,'X',cPictur)
       DO WHILE .T.

**********CAPTURA DE LA OPCION DE LECTURA
	    cOpcLec := '+'+SPACE(LEN(cPictur)-1)
	    @nNroFil,nNroCol GET cOpcLec PICT cPictur;
			      VALID lValCodOpc(ROW(),COL()-LEN(cPictur),;
					       @cOpcLec,cValida,cPictur)
	    READ
**********FIN CAPTURA DE LA OPCION DE LECTURA

**********ANALISIS PARA LA SALIDA
	    IF LASTKEY() = 27
	       IF cError('Presione <ESC> para Abandonar',;
			 '!! ATENCION !!') == CHR(27)
		  cOpcLec := CHR(27)
	       ENDIF
	    ENDIF
	    EXIT
**********FIN ANALISIS PARA LA SALIDA

       ENDDO
       SET ESCAPE OFF
       RETURN UPPER(cOpcLec)
*>>>>FIN CAPTURA Y VALIDACION DE LA OPCION

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION DE LA OPCION DE LECTURA             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/95 DOM A
       Colombia, Bucaramanga        INICIO: 09:20 PM   AGO 20/95 DOM

OBJETIVOS:

1)- Valida los caracteres permitidos y efectua correcci¢n automatica
    cuando la lectura es numerica.

2)- Retorna .T. si no se presentaron problemas

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValCodOpc(nNroFil,nNroCol,cOpcLec,cValida,cPictur)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cOpcLec                              // Opci¢n de lectura
       cValida                              // Caracteres a Validar
       cPictur                              // Picture de lectura */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA OPCION
       IF !(SUBS(cOpcLec,1,1) $ '123456789')
	  IF UPPER(SUBS(cOpcLec,1,1)) $ cValida
	     lHayErr := .T.
	     cOpcLec := SUBS(cOpcLec,1,1)+SPACE(LEN(cOpcLec)-1)
	  ENDIF
       ELSE
	  cOpcLec := STR(VAL(cOpcLec),LEN(cPictur),0)
	  lHayErr := .T.
       ENDIF
       cOpcLec := ALLTRIM(cOpcLec)
       RETURN lHayErr
*>>>>FIN VALIDACION DE LA OPCION

/*************************************************************************
* TITULO DE LA FUNCION..: CONTROL DE SEGURIDAD DEL SISTEMA               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 08/96 VIE A
       Colombia, Bucaramanga        INICIO: 05:12 PM   MAR 08/96 VIE


OBJETIVOS:

1- Analiza y controla la seguridad del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION KeySistema(lShared,cNomSis,aKeySis)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       cNomSis                              // Nombre del sistema
       aKeySis                              // Control del Sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>ANALISIS PARA EL CONTROL INTERNO DEL PROGRAMA
       IF lShared
	  IF CHECKSUM(nNetsName())+4 # aKeySis[1,1]
	     BOOTCOLD()
	  ENDIF
       ELSE
	  IF VOLSERIAL()+24 <> aKeySis[1,2]
	     BOOTCOLD()
	  ENDIF
       ENDIF

       DO CASE
       CASE CHECKSUM(aKeySis[2,1])+4 <> aKeySis[2,2]
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(aKeySis[3,1])+4 <> aKeySis[3,2]
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       CASE CHECKSUM(cNomSis)+4 <> aKeySis[4,2]
	    cError('DA¥OS INTERNOS EN EL SISTEMA')
	    QUIT
       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS PARA EL CONTROL INTERNO DEL PROGRAMA

FUNCTION lPar(nNumero)
RETURN IF(MOD(nNumero,2) == 0,.T.,.F.)

/*************************************************************************
* TITULO DEL PROGRAMA..: LECTURA DEL INTERVALO DE A¥OS                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 14/97 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 AM   JUL 14/97 LUN

OBJETIVOS:

1- Retorna por referencia los param‚tros de la funci¢n marcados con @

2- Lee un intervalo de a¤os.

3- Lee un n£mero de copias a imprimir

4- Retorna .T. si no hay problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lInterAno(nNroFil,nNroCol,cAnoIni,cAnoFin,nCopias,lMarcos)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       cAnoIni				    // @A¤o Inicial
       cAnoFin				    // @A¤o Final
       nCopias		                    // @N£mero de copias
       lMarcos                              // Encerrar con un marco */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL cAnoTem := ''	            // A¤o Temporal
       LOCAL nAnoIni := 0                   // A¤o Inicial
       LOCAL nAnoFin := 0                   // A¤o Final
       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt := 'A¥O INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'A¥O FINAL  :'
       IF nCopias # NIL
	  @ nNroFil+2,nNroCol SAY 'NRO DE COPIAS:'
       ENDIF
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>DIBUJO DEL MARCO
       lMarcos := IF(EMPTY(lMarcos),.F.,lMarcos)
       IF lMarcos
	  @ nNroFil-1,nNroCol-1 TO nNroFil+3,nNroCol+LEN(cMsgTxt)+4 DOUBLE
       ENDIF
*>>>>FIN DIBUJO DEL MARCO

*>>>>LECTURA DE LOS A¥OS
       nNroCol := nNroCol + LEN(cMsgTxt)
       nAnoIni := VAL(cAnoIni)
       nAnoFin := VAL(cAnoFin)

       @ nNroFil  ,nNroCol GET cAnoIni PICT '9999';
				       VALID LEN(cAnoIni) == 4

       @ nNroFil+1,nNroCol GET cAnoFin PICT '9999';
				       VALID LEN(cAnoFin) == 4 .AND.;
				       VAL(cAnoFin) >= nAnoIni

       lHayErr := .F.
       IF nCopias # NIL
	  nCopias := 1
	  @ nNroFil+2,nNroCol GET nCopias PICT '99'

	  IF EMPTY(nCopias)
	     lHayErr := .T.
	  ENDIF
       ENDIF
       READ
*>>>>FIN LECTURA DE LOS A¥OS

*>>>>VALIDACION DE LA LECTURA
       IF !lHayErr
	  IF EMPTY(cAnoIni) .OR. EMPTY(cAnoFin)
	     lHayErr := .T.
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA LECTURA

*>>>>INTERCAMBIO DE NIVELES
       IF !lHayErr

	 IF VAL(cAnoIni) > VAL(cAnoFin)
	    cAnoTem := cAnoIni
	    cAnoIni := cAnoFin
	    cAnoFin := cAnoTem
	 ENDIF

       ENDIF
       RETURN lPregunta('A¥OS:'+cAnoIni+':'+cAnoFin+'.DESEA CONTINUAR? Si No')
*>>>>FIN INTERCAMBIO DE NIVELES

/*************************************************************************
* TITULO DEL PROGRAMA..: HORARIO                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 02/2000 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 AM   FEB 02/2000 MIE

OBJETIVOS:

- Describe el C¢digo del Horario

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cHorario(cCodHor)

LOCAL nNroDia := 0
LOCAL cNroHor := ''
nNroDia := VAL(SUBS(cCodHor,1,2))
cNroHor := SUBS(cCodHor,3,2)

IF !EMPTY(cCodHor)
   RETURN cDia(nNroDia,3)+'-'+cNroHor
ELSE
   RETURN 'NoHora'
ENDIF
RETURN NIL

/*************************************************************************
* TITULO DE LA FUNCION..: VALIDACION NUMERICA DEL DIA
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 26/94 MAR A
						       JUL 26/94 MAR
1- Retorna por referencia los param‚tros de la funci¢n marcados con @

2- Valida el dia, en caso de error permite seleccionar
   el mes correcto

4- Retorna .T.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lnValDia(nNroFil,nNroCol,nNroDia)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       nNroMes				    // @N£mero del mes
       lTodos                               // .T. Todos los meses */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>VALIDACION DEL MES
       DO CASE
       CASE nNroDia  > 0 .AND. nNroDia <= 7
       OTHERWISE
	    nNroDia := VAL(cSelDia(nNroFil,nNroCol))
       ENDCASE
       RETURN .T.
*>>>>FIN VALIDACION DEL MES

/*************************************************************************
* TITULO DE LA FUNCION..: SELECCION DEL DIA DE ACUERDO A UN ARREGLO      *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: JUL 11/94 LUN A
						       JUL 11/94 LUN
1- Permite escoger un mes de acuerdo a un Browse de un arreglo con los
   meses del a¤o.

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna el n£mero del mes escogido en tipo caracter

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSelDia(nNroFil,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de Impresi¢n
       nNroCol                              // Columna de Impresi¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aDias   := NIL                 // Arreglo de D¡as
       LOCAL nNroDia := 0                   // N£mero del D¡a
       LOCAL cNroDia := ''                  // N£mero del D¡a
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DEL VECTOR
       aDias := {'DOM','LUN','MAR','MIE','JUE','VIE','SAB'}
*>>>>FIN INICIALIZACION DEL VECTOR

*>>>>SELECCION DEL MES
      cSavPan := SAVESCREEN(,,,)
      nNroDia := nMenu(aDias,NIL,nNroFil,nNroCol,NIL,NIL,1)
      RESTSCREEN(,,,,cSavPan)
*>>>>FIN SELECCION DEL MES

*>>>>CORRECION AUTOMATICA DEL MES
       DO CASE
       CASE nNroDia == 0
	    cNroDia := SPACE(01)

       CASE nNroDia > 0 .AND. nNroDia < 7
	    cNroDia := STR(nNroDia,1)
       ENDCASE
       RETURN cNroDia
*>>>>FIN CORRECION AUTOMATICA DEL MES

/*************************************************************************
* TITULO DE LA FUNCION..: AYUDA PARA LA LECTURA DEL CODIGO DEL LOGRO     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 19/96 JUE A
       Colombia, Bucaramanga        INICIO: 04:40 PM   SEP 19/96 JUE

OBJETIVOS:

1)- Verifica la salida de la grabaci¢n de los logros

2)- Valida la duplicaci¢n de logros aplicados

3)- Valida la existencia de la clase de indicador, el indicador,
    el c¢digo de Evaluaci¢n.

4)- Retorna .T. si no se presentaron problemas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION HelpRead(cMsgTxt)

*>>>>DESCRIPCION DE PARAMETRO
/*     cMsgTxt                              // Mensaje de Ayuda */
*>>>>FIN DESCRIPCION DE PARAMETRO

*>>>>VISUALIZACION DE LA AYUDA
       DO CASE
       CASE EMPTY(cMsgTxt)
	    cMsgTxt := 'SISTEMAS INTEGRADOS MULTIUSUARIOS'
	    SET COLOR TO I

       CASE cMsgTxt == 'FECHA'
	    SET COLOR TO I*
	    cMsgTxt := 'POR FAVOR INGRESE LA FECHA '+;
		       'EN EL SGTE ORDEN: MM/DD/AAAA'
       OTHERWISE
	    SET COLOR TO I*
       ENDCASE
       cMsgTxt := SPACE(40-LEN(cMsgTxt)/2)+cMsgTxt+SPACE(40-LEN(cMsgTxt)/2)
       @ 23,00 SAY cMsgTxt
       SetClrTo()
       RETURN .T.
*>>>>FIN VISUALIZACION DE LA AYUDA


/*************************************************************************
* TITULO..: SUMA LOS ELEMENTOS DE UN VECTOR                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 27/2000 MIE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   SEP 27/2000 MIE

OBJETIVOS:

1- Suma los elementos de un vector.

2- Retorna el total de la suma

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nSuma(aArray,j)

*>>>>DESCRIPICON DE PARAMETROS
/*     aArray                               // Vector a Sumar */
*>>>>FIN DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,nTotal := 0                  // Contadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SUMA DE LOS ELEMENTOS DEL VECTOR
       IF j == NIL
	  FOR i := 1 TO LEN(aArray)
	      IF VALTYPE(aArray[i]) == 'N'
		 nTotal += aArray[i]
	      ENDIF
	  ENDFOR
       ELSE
	  FOR i := 1 TO LEN(aArray)
	      IF VALTYPE(aArray[i,j]) == 'N'
		 nTotal += aArray[i,j]
	      ENDIF
	  ENDFOR
       ENDIF
       RETURN nTotal
*>>>>FIN SUMA DE LOS ELEMENTOS DEL VECTOR

FUNCTION cSUBS(cTxtTem,nLenTxt)
RETURN SUBS(cTxtTem+SPACE(nLenTxt),1,nLenTxt)

/*************************************************************************
* TITULO..: VISUALIZCION DEL TEXTO DE AYUDA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 05/2001 MIE A
       Colombia, Bucaramanga        INICIO: 12:30 AM   SEP 05/2001 MIE

OBJETIVOS:

1- Permite visualizar un texto de ayuda

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AyudaTxt(cTexto,cTitulo,cEstado,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     cTexto                               // Texto de Ayuda
       cTitulo                              // T¡tulo de ayuda
       cEstado                              // L¡nea de Estado
       nFilSup                              // Fila Superior
       nColSup                              // Columna Superior
       nFilInf                              // Fila Inferior
       nColInf                              // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DIBUJO DEL MARCO
       cSavPan := SAVESCREEN(0,0,24,79)
       nFilSup := IF(EMPTY(nFilSup),3,nFilSup)
       nColSup := IF(EMPTY(nColSup),0,nColSup)
       nFilInf := IF(EMPTY(nFilInf),22,nFilInf)
       nColinf := IF(EMPTY(nColInf),79,nColInf)
       @ nFilSup,nColSup TO nFilInf,nColInf DOUBLE
       centrar(cTitulo,nFilSup,nColSup,nColInf)
*>>>>FIN DIBUJO DEL MARCO

*>>>>VISUALIZACION DE LA AYUDA
       cEstado := IF(EMPTY(cEstado),'<ESC>Abandona',cEstado)
       cEstado := SPACE(40-LEN(cEstado)/2)+;
		  cEstado+;
		  SPACE(40-LEN(cEstado)/2)

       @ 23,00 SAY cEstado COLOR('I')

       MEMOEDIT(cTexto,nFilSup+1,nColSup+1,nFilInf-1,nColInf-1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN VISUALIZACION DE LA AYUDA

/*************************************************************************
* TITULO..: VALIDACION DEL SEXO DE UNA PERSONA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 14/2001 LUN A
       Colombia, Bucaramanga        INICIO: 05:45 PM   MAY 14/2001 LUN

OBJETIVOS:

1- Realiza la validaci¢n del Sexo

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValSexo(nNroFil,nNroCol,cCodSex,lSexFem)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodSex			            // @Codigo del Sexo
       lSexFem                              // @.T. Sexo Femenino */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<MASCULINO>',;
		  '2<FEMENINO>'}

       aAyudas := {'Sexo Masculino',;
		   'Sexo Femenino'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       IF cCodSex # 'M' .AND. cCodSex # 'F'

	  SAVE SCREEN
	  DO WHILE .T.
	     nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	     IF nNroOpc # 0
		EXIT
	     ENDIF
	  ENDDO
	  RESTORE SCREEN

	  IF nNroOpc == 1
	     lSexFem := .F.
	     cCodSex := 'M'
	  ELSE
	     lSexFem := .T.
	     cCodSex := 'F'
	  ENDIF

       ELSE
	  IF cCodSex == 'M'
	     lSexFem := .F.
	  ELSE
	     lSexFem := .T.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL SI o NO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 18/2004 LUN A
       Colombia, Bucaramanga        INICIO: 02:30 PM   JUL 18/2004 LUN

OBJETIVOS:

1- Realiza la validaci¢n del Si o No

2- Retorna .T. si hay problemas


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValSiNo(nNroFil,nNroCol,cSiorNo,lSiorNo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cSiorNo			            // @Codigo l¢gico
       lSiorNo                              // @.T. Si .F. No */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<SI>',;
		  '2<NO>'}

       aAyudas := {'Si',;
		   'No'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       IF cSiorNo # 'S' .AND. cSiorNo # 'N'

	  SAVE SCREEN
	  DO WHILE .T.
	     nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	     IF nNroOpc # 0
		EXIT
	     ENDIF
	  ENDDO
	  RESTORE SCREEN

	  IF nNroOpc == 1
	     lSiorNo := .T.
	     cSiorNo := 'S'
	  ELSE
	     lSiorNo := .F.
	     cSiorNo := 'N'
	  ENDIF

       ELSE
	  IF cSiorNo == 'S'
	     lSiorNo := .T.
	  ELSE
	     lSiorNo := .F.
	  ENDIF
       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: VALIDACION DEL TIPO DE DOCUMENTO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/2001 MAR A
       Colombia, Bucaramanga        INICIO: 12:30 PM   MAY 15/2001 MAR

OBJETIVOS:

1- Realiza la validaci¢n del tipo de Documento

2- Retorna .T. si hay problemas

3- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lValTipNit(nNroFil,nNroCol,cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // Fila de lectura
       nNroCol                              // Columna de lectura
       cCodigo			            // @Codigo a validar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyudas := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
*>>>>DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS TIPOS DE MATERIAS
       aMenus := {'1<CC  >',;
		  '2<TI  >',;
		  '3<RC  >',;
		  '4<NIT >',;
		  '5<CE  >',;
		  '6<NUIP>',;
		  '7<PP  >'}

       aAyudas := {'C‚dula de Ciudadania',;
		   'Tarjeta de Identidad',;
		   'Registro Civil',;
		   'Nit',;
		   'C‚dula de Extranjeria',;
		   'N£mero £nico de identificaci¢n personal',;
		   'Pasaporte'}
*>>>>FIN DEFINICION DE LOS TIPOS DE MATERIAS

*>>>>VALIDACION DEL CODIGO
       cCodigo := ALLTRIM(cCodigo)
       IF cCodigo # 'CC' .AND. cCodigo # 'TI'  .AND.;
	  cCodigo # 'RC' .AND. cCodigo # 'NIT' .AND.;
	  cCodigo # 'CE' .AND. cCodigo # 'NUIP' .AND.;
	  cCodigo # 'PP'

	  SAVE SCREEN
	  nNroOpc := nMenu(aMenus,aAyudas,nNroFil,nNroCol,NIL,NIL,1,.F.)
	  RESTORE SCREEN

	  IF nNroOpc == 0
	     cCodigo := SPACE(03)
	  ELSE
	     cCodigo := ALLTRIM(SUBS('CC  TI  RC  NIT CE  NUIPPP  ',nNroOpc*4-3,4))
	  ENDIF

       ENDIF
       RETURN .T.
*>>>>FIN VALIDACION DEL CODIGO

/*************************************************************************
* TITULO..: CONTROL DE LA FILA                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 02/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:20 PM   OCT 02/2002 MIE

OBJETIVOS:

1- Controla el n£mero de la fila respecto a la £ltima fila a imprimir

2- Retorna el n£mero de la fila

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Fila(nNroFil,bMarco,nFilFin,cTxtMar)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la fila
       bMarco                               // CodeBloc del Marco
       nFilFin                              // N£mero de fila final
       cTxtMar                              // Texto del Marco */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>CONTROL DE LA FILA
       nFilFin := IF(nFilFin==NIL,19,nFilFin)
       IF nNroFil > nFilFin
	  cPausa()
	  nNroFil := EVAL(bMarco)
	  IF !EMPTY(cTxtMar)
	     @ nNroFil,1 SAY cTxtMar
	     nNroFil++
	  ENDIF
       ENDIF
       RETURN nNroFil
*>>>>FIN CONTROL DE LA FILA

/*************************************************************************
* TITULO DE LA FUNCION..: VERIFICACION SI UN NUMERO ES PAR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 25/95 JUE A
       Colombia, Bucaramanga        INICIO: 12:05 AM   ABR 25/95 JUE

OBJETIVOS:

1)- Verifica si un n£mero es par

2)- Retorna .T. si el n£mero es par

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lNroPar(nNumero)

*>>>>PARAMETROS DE LA FUNCION
/*     nNumero                              // N£mero a verificar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lNroPar := .F.                 // .T. Numero par
       LOCAL       k := 0                   // Constante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VERIFICACION SI EL NUMERO PAR
       k := INT(nNumero/2)
       IF k*2 == nNumero
	  lNroPar := .T.
       ENDIF
       RETURN lNroPar
*>>>>VERIFICACION SI EL NUMERO ES PAR

/*************************************************************************
* TITULO..: NOMBRE DEL SISTEMA OPERATIVO                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 15/2003 MIE A
       Colombia, Bucaramanga        INICIO: 12:15 PM   ENE 15/2003 MIE

OBJETIVOS:

1- Determina el Nombre del Sistema Operativo

2- Retorna el Nombre del Sistema Operativo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNomSysOpe(nSysOpe)

*>>>>DESCRIPCION DE PARAMETROS
/*     nSysOpe                              // Tipo de Sistema Operativo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSysOpe := ''                  // Sistema Operativo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL SISTEMA OPERATIVO
       nSysOpe := IF(EMPTY(nSysOpe),0,nSysOpe)
       DO CASE
       CASE nSysOpe == 1
	    cSysOpe := 'NOVELL'
       CASE nSysOpe == 2
	    cSysOpe := 'LINUX'
       OTHERWISE
	    cSysOpe := 'WINDOWS'
       ENDCASE
       RETURN cSysOpe
*>>>>FIN ANALISIS DEL SISTEMA OPERATIVO

/*************************************************************************
* TITULO..: BORRADO DE UN ARCHIVO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 28/2003 MAR A
       Bucaramanga, Colombia	    INICIO: 11:30 PM   ENE 28/2003 MAR

OBJETIVOS:

1- Permite borrar un archivo

2- Valida la eliminaci¢n del Archivo

3- Retorna .T. si la operaci¢n fue valida


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION lFileDelete(fArchvo)

*>>>>DESCRIPCION DE PARAMETROS€
/*     fArchvo                              // Archivo a Borrar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiDele := .F.                 // .T. Hay Error
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA EXISTENCIA DEL ARCHIVO
       IF .NOT. FILE(ALLTRIM(fArchvo))
	  cError('EL ARCHIVO '+fArchvo+' NO EXISTE')
	  RETURN lSiDele
       ENDIF
*>>>>VALIDACION DE LA EXISTENCIA DEL ARCHIVO

*>>>>ELIMINACION DEL ARCHIVO
       FERASE(fArchvo)
       IF FILE(ALLTRIM(fArchvo))
	  cError('NO SE BORRO EL ARCHIVO '+fArchvo)
       ELSE
	  lSiDele := .T.
       ENDIF
       RETURN lSiDele
*>>>>FIN ELIMINACION DEL ARCHIVO

/*************************************************************************
* TITULO...: MARCO PARA SELECCION                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 13/2003 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   AGO 13/2003 MIE

OBJETIVOS:

1- Crea un marco para selecci¢n.

2- Retorna el n£mero de la fila.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMarcos(nFilSup,cTitSup,cTitInf,nFilInf,nColSup,nColInf,nColIzq)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup                  // Fila Superior para el marco
       cTitSup			// Titulo Superior par el Marco
       cTitDos                  // Titulo Inferior para el Marco
       nFilInf                  // Fila Inferior para el marco
       nColSup                  // Columna Superior
       nColInf                  // Columna Inferior
       nColIzq                  // Columna Izquierda para la linea vertical*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cHrfill := '°'                 // Caracter de relleno
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL MARCO
       nColSup := IF(nColSup == NIL,00,nColSup)
       nFilInf := IF(nFilInf == NIL,22,nFilInf)
       nColInf := IF(nColInf == NIL,79,nColInf)
       cHrfill := IF(cHrfill == NIL,' ',cHrfill)

       DISPBOX(nFilSup,nColSup,nFilInf,nColInf,'ÚÄ¿³ÙÄÀ³'+cHrfill)
      *Dibujo del Marco

       @ nFilSup+2,nColSup+1 TO nFilSup+2,nColInf-1
      *L¡nea horizontal superior

       @ nFilInf-2,nColSup+1 TO nFilInf-2,nColInf-1
      *L¡nea horizontal inferior

       IF nColIzq # NIL
	  @ nFilSup+3,nColInf-nColIzq TO nFilInf-3,nColInf-nColIzq
       ENDIF
     *ÀLinea vertical

       IF cTitSup # NIL
	  centrar(cTitSup,nFilSup+1,nColSup,nColInf)
       ENDIF
     *ÀT¡tulo Superior del marco

       IF cTitInf # NIL
	  centrar(cTitInf,nFilInf-1,nColSup,nColInf-1)
       ENDIF
     *ÀT¡tulo Inferior del marco

       RETURN nFilSup+3
*>>>>FIN CREACION DEL MARCO

/*************************************************************************
* TITULO..: A¥OS CUMPLIDOS                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2003 VIE A
       Colombia, Bucaramanga        INICIO: 02:24 PM   AGO 22/2003 VIE

OBJETIVOS:

1- Calcula los a¤os cumplidos de una persona

2- Retorna los A¤os cumplidos

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION nAnosSi(dFecNac,dFecAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     dFecNac                              // Fecha de Nacimiento
       dFecAct                              // Fecha Actual a Comparar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nAnosSi := 0                   // A¤os Cumplidos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS A¥O CUMPLIDOS
       nAnosSi := YEAR(dFecAct) - YEAR(dFecNac)
       IF .NOT. lAnosSi(dFecNac,dFecAct)
	  nAnosSi--
       ENDIF
       RETURN nAnosSi
*>>>>FIN CALCULO DE LOS A¥O CUMPLIDOS

/*************************************************************************
* TITULO..: ANALISIS SI YA CUMPLIO A¥OS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 22/2003 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   AGO 22/2003 VIE

OBJETIVOS:

1- Determina si una persona ya cumplio a¤os.

2- Retorna si una persona ya cumplio a¤os.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION lAnosSi(dFecNac,dFecAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     dFecNac                              // Fecha de Nacimiento
       dFecAct                              // Fecha Actual a Comparar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lAnosSi := .F.                 // .T. Cumplio A¤os
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL CUMPLEA¥OS
       IF MONTH(dFecNac) <= MONTH(dFecAct)
	  IF MONTH(dFecNac) == MONTH(dFecAct)
	     IF DAY(dFecNac) <= DAY(dFecAct)
		lAnosSi := .T.
	     ENDIF
	  ELSE
	     lAnosSi := .T.
	  ENDIF
       ENDIF
       RETURN lAnosSi
*>>>>FIN ANALISIS DEL CUMPLEA¥OS

*>>>>LIBRERIA ABRAXAS
FUNCTION nDifTiempo( dFecha1,cHora1,dFecha2,cHora2 )
  LOCAL nDias,nHorasp,nMinutp,nHorasa,nMinuta,nHoras,nMinuto

  // Control de par metros opcionales
  IF cHora1 = NIL .OR. EMPTY( cHora1 )
     cHora1 := "00:00"
  END IF

  IF dFecha2 = NIL .OR. EMPTY( dFecha2 )
     dFecha2 := DATE()
  END IF

  IF cHora2 = NIL .OR. EMPTY( cHora2 )
     cHora2 := SUBSTR( TIME(),1,5 )
  END IF

  // Control del tipo de par metros
  IF VALTYPE( dFecha1 ) != 'D' .OR. VALTYPE( dFecha2 ) != 'D' .OR.;
     VALTYPE( cHora1 )  != 'C' .OR. VALTYPE( cHora2 )  != 'C' .OR.;
     EMPTY( dFecha1 )
     RETURN 0
  END IF

  // Diferencia de dias
  nDias := dFecha2 - dFecha1

  // Se extraen las horas y minutos de cada fracci¢n horaria
  nHorasp := VAL( SUBSTR( cHora2,1,2 ) )
  nMinutp := VAL( SUBSTR( cHora2,4,2 ) )

  nHorasa := VAL( SUBSTR( cHora1,1,2 ) )
  nMinuta := VAL( SUBSTR( cHora1,4,2 ) )

  // Diferencia de Horas
  nHoras := nHorasp - nHorasa

  // Si la diferencia horaria es menor de 0
  IF nHoras < 0
     --nDias
     nHoras += 24
  END IF

  // Diferencia de Minutos
  nMinuto = nMinutp - nMinuta

  // Si la diferencia de minutos es menor de 0
  IF nMinuto < 0
     --nHoras
     nMinuto += 60
  END IF

RETURN nMinuto + ( nHoras * 60 ) + ( ( nDias * 24 ) * 60 )

/*************************************************************************
* TITULO...: NUMEROS A LETRAS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 03/2004 MIE A
       Colombia, Bucaramanga        INICIO: 02:25 PM   FEB 03/2004 MIE

OBJETIVOS:

1- Convierte un numero decimal de un entero y un digito a letras

2- Retorna las letras del numero

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNroToTxt(nNumero)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNumero                              // N£mero a convertir */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cDigTxt := 'UNO   '+;
			'DOS   '+;
			'TRES  '+;
			'CUATRO'+;
			'CINCO '+;
			'SEIS  '+;
			'SIETE '+;
			'OCHO  '+;
			'NUEVE '+;
			'DIEZ  '
       LOCAL nNroInt := 0                   // Numero Entero
       LOCAL nNroDec := 0                   // N£mero Decimal
       LOCAL cNroTxt := ''                  // Numero en letras
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SEPARACION DEL NUMERO
       cNroTxt := 'ERROR'
       IF nNumero >= 0 .OR. nNumero <= 10.0
	  nNroInt := INT(nNumero)
	  nNroDec := (nNumero - nNroInt) * 10

	  cNroTxt := ''
	  IF nNroInt == 0
	     cNroTxt := 'CERO'
	  ELSE
	     cNroTxt := ALLTRIM(SUBS(cDigTxt,nNroInt*6-5,6))
	  ENDIF
	  cNroTxt += ','

	  IF nNroDec == 0
	     cNroTxt += 'CERO'
	  ELSE
	     cNroTxt += ALLTRIM(SUBS(cDigTxt,nNroDec*6-5,6))
	  ENDIF

       ENDIF
       RETURN cNroTxt
*>>>>FIN SEPARACION DEL NUMERO

/*************************************************************************
* TITULO..: ENCRIPTACION DE TEXTO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2004 JUE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   MAR 04/2004 JUE

OBJETIVOS:

1- Encripta una cadena de texto

2- Retorna la cadena encriptada.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cEncry(cTexto,lEncryp)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTexto                               // Texto a Encriptar
       lEncryp                              // .T. Encriptar .F. Descriptar */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cChrTxt := ''                  // Caracter del texto
       LOCAL nChrNro := 0                   // N£mero ASCII del Caracter
       LOCAL cChrCry := ''                  // Caracter encryptado o desencryptado
       LOCAL cEncryp := ''                  // Texto encriptado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PROCESO DE ENCRIPTACION
       lEncryp := IF(lEncryp==NIL,.T.,lEncryp)
       FOR i := 1 TO LEN(cTexto)

*----------METODO DE ENCRYPTACION
	     cChrTxt := SUBS(cTexto,i,1)
	     nChrNro := ASC(cChrTxt)

	     IF lEncryp
		nChrNro++
	     ELSE
		nChrNro--
	     ENDIF

	     IF cChrTxt == SPACE(01)
		cChrCry := cChrTxt
	     ELSE
                cChrCry := CHR(nChrNro)
	     ENDIF
	   *ÀEspacio en Blanco no encrytado

	     cEncryp += cChrCry
*----------FIN METODO DE ENCRYPTACION

       ENDFOR
       RETURN cEncryp
*>>>>FIN PROCESO DE ENCRIPTACION

/*************************************************************************
* TITULO..: LECTURA DEL TEXTO DESENCRIPTADO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2004 JUE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAR 04/2004 JUE

OBJETIVOS:

1- Lee el texto encriptado en su formato original. NO ENCRIPTADO

2- Retorna el texto descriptado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeTxtCry(lSiCryp,cTexto)

*>>>>DESCRIPCION DE PARAMETROS
/*     lSiCryp                              // .T. Texto encriptado
       cTexto                               // Texto a Leer */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cCadena := ''                  // Cadena de Texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE ENCRIPTACION
      IF lSiCryp
	 cCadena := cEncry(cTexto,!lSiCryp)
      ELSE
	 cCadena := cTexto
      ENDIF
      RETURN cCadena
*>>>>FIN ANALISIS DE ENCRIPTACION

/*************************************************************************
* TITULO ..: LOGO PARA EL FONDO DEL SISTEMA                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 07/2001 SAB A
       Colombia, Bucaramanga        INICIO: 10:40 PM   JUL 07/2001 SAB

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LogoSys(cNomSis,cNomEmp)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList := {}                  // Variable del sistema

       MEMVA xClrSys			    // Color del Sistema
       LOCAL cClrFnd := ''                  // Color del Fondo
       LOCAL cGetsSi := ''                  // Color del Get Selecionados
       LOCAL cMarGen := ''                  // Marco General en Color
       LOCAL cGetsNo := ''                  // Color del Get No Seleccionados
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL COLOR
       Colores(xColores(IF(!EMPTY(xClrSys),xClrSys[1],'')),;
	       @cClrFnd,@cGetsSi,@cGetsNo,@cMarGen)
       cSetColor(cClrFnd+','+cGetsSi+','+cMarGen+',,'+cGetsNo)
*>>>>FIN ANALISIS DEL COLOR

*>>>>DISE¥O DEL FONDO
       CLEAR
       @ 00,00,24,80 BOX CHR(176)+CHR(176)+CHR(176)+CHR(176)+CHR(176)+;
			 CHR(176)+CHR(176)+CHR(176)+CHR(176)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
       RETURN NIL
*>>>>FIN DISE¥O DEL FONDO

/*************************************************************************
* TITULO DE LA FUNCION..: VISUALIZA LA FECHA Y HORA DEL SISTEMA          *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: NOV 25/94 VIE A
						       NOV 25/94 VIE

1- Visualiza la fecha y hora del sistema

2- Retorna el valor l¢gico de cambiar la fecha y hora

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FecHorSys(cNomSis,cTitulo)

*>>>>PARAMETROS DEL SISTEMA
/*     cNomSis                              // Nombre del sistema
       cTitulo                              // T¡tulo */
*>>>>FIN PARAMETROS DEL SISTEMA

*>>>>VISUALIZACION DE FECHA Y HORA Y SISTEMA
       LineaEstado('FECHA: '+cFecha(DATE())+" "+cDia(DOW(DATE()),9)+;
		   IF(EMPTY(cTitulo),'           ',' '+cTitulo+' ')+;
		   '<F10> CAMBIAR HORA/FECHA',cNomSis,.F.)

       SHOWTIME(23,71,.F.,,.T.,.T.)
       RETURN NIL
*>>>>FIN VISUALIZACION DE FECHA Y HORA Y SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: LECTURA DE LA FECHA Y HORA DEL SISTEMA         *
**************************************************************************

OBJETIVOS:                          FECHA DE CREACION: NOV 25/94 VIE A
						       NOV 25/94 VIE

1- Permite leer y cambiar la fecha y hora del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LeerFecHora(cNomSis,cTitulo)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cTitulo                              // T¡tulo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nFilSup := 10                  // Fila Superior
       LOCAL nColSup := 34                  // Columna Superior
       LOCAL nFilInf := 14                  // Fila Inferior
       LOCAL nColInf := 48                  // Columna Inferior

       LOCAL nCursor := 0                   // Numero del Cursor
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                  // Declaraci¢n de Ayudas
       LOCAL nNroOpc := 1                   // N£mero de la opci¢n

       LOCAL dFecSys := CTOD("00/00/00")    // Fecha del sistema
       LOCAL cHorSys := SPACE(08)           // Hora del sistema

       LOCAL GetList := {}
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA EL CAMBIO DE LA FECHA Y HORA
       aMenus  := {'1<FECHA>',;
		   '2<HORA >'}

       aAyuda  := {'Cambia la fecha en el formato MM/DD/AA',;
		   'Cambia la hora en el formato internaciona HH:MM:SS'}

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilSup,nColSup,NIL,NIL,1,.F.)
*>>>>FIN ANALISIS PARA EL CAMBIO DE LA FECHA Y HORA

*>>>>ANALISIS DE LA OPCION ESCOGIDA
       nCursor := SETCURSOR(1)
       DO CASE
       CASE nNroOpc == 1

************LECTURA DE LA FECHA
	      dFecSys := DATE()
	      @ nFilInf,nColSup SAY "FECHA:" GET dFecSys PICT "@D";
				     VALID dFecSys <> CTOD('00/00/00')
	      READ
************FIN LECTURA DE LA FECHA

************GRABACION DE LA FECHA
	      IF ISAT()
		 SETDATE(dFecSys,.T.)
	      ELSE
		 SETDATE(dFecSys)
	      ENDIF
************FIN GRABACION DE LA FECHA

       CASE nNroOpc == 2

*************LECTURA DE LA HORA
	       cHorSys := TIME()
	       @ nFilInf,nColSup SAY "HORA:"  GET cHorSys PICT "99:99:99" ;
				     VALID TIMEVALID(ALLTRIM(cHorSys))
	       READ
*************FIN LECTURA DE LA HORA

*************GRABACION DE LA HORA
	       IF ISAT()
		  SETTIME(cHorSys,.T.)
	       ELSE
		  SETTIME(cHorSys)
	       ENDIF
*************FIN GRABACION DE LA HORA
       ENDCASE
       SETCURSOR(nCursor)
       RESTSCREEN(0,0,24,79,cSavPan)
       FecHorSys(cNomSis,cTitulo)
       RETURN NIL
*>>>>FIN ANALISIS DE LA OPCION ESCOGIDA

/*************************************************************************
* TITULO..: DIVIDIR EL PATH                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2004 DOM A
       Colombia, Bucaramanga        INICIO: 07:00 PM   OCT 03/2004 DOM

1- Permite separar el Path de un directorio en sus subdirectorios
   correspondientes

2- Retorna un vector con los directorios

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aDivPath(PathDir,cPatArc,fArchvo,ExtFile)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathDir			            // Path del Directorio
       cPatArc                              // Path del Archivo
       fArchvo                              // Archivo del Sistema
       ExtFile                              // @Extensi¢n del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE PARAMETROS
       LOCAL       i := 0                   // Contador
       LOCAL cUnidad := ''                  // Unidad
       LOCAL PathTem := ''                  // Path Temporal
       LOCAL aPatDir := {}                  // Path de Directorios
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>UNIDAD DE DISCO
      cUnidad := ''
      IF At(':',PathDir) == 2
	 cUnidad := SUBS(PathDir,1,2)
	 PathDir := SUBS(PathDir,3,LEN(PathDir))
      ENDIF
*>>>>FIN UNIDAD DE DISCO

*>>>>ANALISIS DE DECISION
       IF At('\',PathDir) == 0
	  AAdd(aPatDir,PathDir)
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>SEPEARACION DE LOS PATH
       IF At('\',PathDir) # 0

	  DO WHILE At('\',PathDir) # 0
	     i := At('\',PathDir)
	     IF i == 1
		IF i == 1
		   PathTem := '\'
		   PathDir := SUBS(PathDir,2)
		ELSE
		   PathTem := SUBS(PathDir,1,3)
		   PathDir := SUBS(PathDir,4)
		ENDIF
	     ELSE
		PathTem += SUBS(PathDir,1,i-1)
		AAdd(aPatDir,PathTem)
		PathTem := ''
		PathDir := SUBS(PathDir,i+1)
	     ENDIF
	  ENDDO
	  AAdd(aPatDir,PathDir)
	  IF !EMPTY(cUnidad) .AND. LEN(aPatDir) > 0
	     aPatDir[1] := cUnidad+aPatDir[1]
	  ENDIF

       ENDIF
*>>>>FIN SEPEARACION DE LOS PATH

*>>>>DETALLES DEL ARCHIVO
       cPatArc := ''
       fArchvo := ''
       ExtFile := ''
       FOR i := 1 TO LEN(aPatDir)-1
	   IF i == 1
	      cPatArc := aPatDir[i]
	   ELSE
	      cPatArc += '\'+aPatDir[i]
	   ENDIF
       NEXT
       fArchvo := PathDir
       ExtFile := SUBS(fArchvo,AT('.',fArchvo),LEN(fArchvo))
       RETURN aPatDir
*>>>>FIN DETALLES DEL ARCHIVO

/*************************************************************************
* TITULO..: CAMBIAR DE DIRECTORIO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 07/2004 MAR A
       Colombia, Bucaramanga        INICIO: 12:30 PM   SEP 07/2004 MAR

1- Permite cambiar el directorio actual

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nCd(PathArc)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE PARAMETROS
       LOCAL nNroPos := 0                   // N£mero de Posici¢n
       LOCAL cUnidad := ''                  // Unidad de Drive
       LOCAL nNroErr := 0                   // N£mero de Error
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>CAMBIO DE UNIDAD
       nNroPos := AT(':',PathArc)
       IF nNroPos > 1
	  cUnidad := SUBS(PathArc,nNroPos-1,2)
	  IF !DISKCHANGE(cUnidad)
	     RETURN -3                      // No Existe el Directorio
	  ENDIF
       ENDIF
*>>>>FIN CAMBIO DE UNIDAD

*>>>>CAMBIO DEL DIRECTORIO
       nNroErr := DIRCHANGE(PathArc)
       RETURN nNroErr
*>>>>FIN CAMBIO DEL DIRECTORIO

/*************************************************************************
* TITULO..: CAMBIAR DE DIRECTORIO                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 07/2004 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   SEP 07/2004 MAR

1- Calcula el Path Actual

2- Retorna el Path Actual

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPathAct()

*>>>>DECLARACION DE PARAMETROS
       LOCAL cUnidad := ''                  // Unidad de Drive
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>PATH ACTUAL
       cUnidad := DISKNAME()
       PathAct := DIRNAME()
       RETURN cUnidad+':'+PathAct
*>>>>FIN PATH ACTUAL

/*************************************************************************
* TITULO..: CREAR DIRECTORIOS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 03/2004 DOM A
       Colombia, Bucaramanga        INICIO: 07:30 PM   OCT 03/2004 DOM

1- Crea los directorios de acuerdo al Path
   correspondientes

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Mdir(cPatDir,PathAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatDir				    // Path del Directorio */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                  // Contador
       LOCAL aPatDir := {}                 // Vector de Directorios
       LOCAL cNomDir := ''                 // Nombre del Directorio
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE DIRECTORIOS
       aPatDir := aDivPath(cPatDir)
       IF nCd(cPatDir) # 0
	  FOR i := 1 TO LEN(aPatDir)

	      cNomDir := aPatDir[i]

	      DO CASE
	      CASE nCd(cNomDir) == 0

	      CASE nCd(cNomDir) == -5
		   cError("NO HAY DERECHOS EN EL DIRECTORIO "+cNomDir)
		   QUIT

	      CASE nCd(cNomDir) == -3
		   DIRMAKE(cNomDir)
		   nCd(cNomDir)
	      ENDCASE

	  ENDFOR
       ENDIF
       nCd(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE DIRECTORIOS

/*************************************************************************
* TITULO ..: LINEAS EN BLANCO. ENTER                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 21/2001 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   JUN 21/2001 JUE

OBJETIVOS:

1- Crea un texto con el N£mero de l¡neas en blanco o <ENTER> para insertar
   en un texto

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cEnter(nNroLin)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroLin                              // N£mero de l¡neas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i := 0                     // Contador
       LOCAL Enter := ''                    // N£mero de Enter
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE LAS LINEAS EN BLANCO
       nNroLin := IF(EMPTY(nNroLin),1,nNroLin)
       FOR i := 1 TO nNroLin
	   Enter += CHR(13)+CHR(10)
       ENDFOR
       RETURN Enter
*>>>>FIN CREACION DE LAS LINEAS EN BLANCO

/*************************************************************************
* TITULO..: BASE DEL IVA                                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 29/2005 MIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   JUN 29/2005 MIE

OBJETIVOS:

1- Calcula la Base del Iva y el Valor del Iva

2- Retorna la Base del Iva

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BasIva(nVlrTot,nPorIva,nBasIva,nVlrIva)

*>>>>DESCRIPCION DEL PARAMETROS
/*     nVlrTot                              // Valor Total
       nPorIva                              // Porcentaje del Iva
       nBasIva                              // @Base del Iva
       nVlrIva                              // @Valor del Iva */
*>>>>FIN DESCRIPCION DEL PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nPorTem := 0                   // Porcentaje temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LA BASE DEL IVA
       nPorTem := (nPorIva/100)+1
       nBasIva := ROUND(nVlrTot/nPorTem,0)
       nVlrIva := nVlrTot - nBasIva
       RETURN NIL
*>>>>FIN CALCULO DE LA BASE DEL IVA

/*************************************************************************
* TITULO ..: HORAS DEL DIA                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 22/2005 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   JUL 22/2005 VIE

OBJETIVOS:

1- Calcula las horas y minutos del mismo d¡a de acuerdo a la hora
   de ingreso y salida.

2- Las Horas las Clasifica en Diurnas y Nocturnas

3- Retorna el tiempo transcurrido

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aHoraDia(cHorIng,cHorOut,cIniDiu,cFinDiu,cIniNoc,cFinNoc,aTiempo,;
		  nTipHor)

*>>>>DESCRIPICON DE PARAMETROS
/*     cHorIng                              // Hora del Ingreso
       cHorOut                              // Hora de Salida
       cIniDiu                              // Inicio Hora Diurna
       cFinDiu                              // Final Hora Diurna
       cIniNoc                              // Inicio Hora Nocturna
       cFinNoc                              // Final Hora Nocturna
       aTiempo			            // Tiempo Transcurrido
       nTipHor			            // @ Tipo de Horario */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #DEFINE ANO 1                        // A¤os
       #DEFINE MES 2                        // Meses
       #DEFINE DIA 3                        // Dias
       #DEFINE HOD 4                        // Horas Diurnas
       #DEFINE MDI 5                        // Minutos Diurnos
       #DEFINE HON 6                        // Horas Nocturnas
       #DEFINE MNO 7                        // Minutos Nocturnos
       #DEFINE SEG 8                        // Segundos

       LOCAL nSegEnt := 0                   // Segundos de Entrada
       LOCAL nSegOut := 0                   // Segundos de Salida

       LOCAL nSegJDI := 0                   // Segundos Jornada Diurna Inicial
       LOCAL nSegJDF := 0                   // Segundos Jornada Diurna Final
       LOCAL nSegJNI := 0                   // Segundos Jornada Nocturna Inicial
       LOCAL nSegJNF := 0                   // Segundos Jornada Nocturna Final

       LOCAL nTotSeg := 0                   // Total de Segundos
       LOCAL nTotHor := 0                   // Total de Horas
       LOCAL nTotMin := 0                   // Total de Minutos
       LOCAL nSegund := 0                   // Segundos

       LOCAL nTotDiu := 0                   // Total Segundos Diurnos
       LOCAL nHorDiu := 0                   // Horas Diurnas
       LOCAL nMinDiu := 0                   // Minutos Diurnos
       LOCAL nSegDiu := 0                   // Segundos Diurnos

       LOCAL nTotNoc := 0                   // Total Segundos Nocturnos
       LOCAL nHorNoc := 0                   // Horas Nocturnas
       LOCAL nMinNoc := 0                   // Minutos Nocturnos
       LOCAL nSegNoc := 0                   // Segundos Diurnos

       LOCAL nNroMin := 0                   // Minutos Transcurridos
       LOCAL nNroSeg := 0                   // Segundos Transcurridos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONVERSION DEL TIEMPO A SEGUNDOS
       nSegJDI := nHoraSeg(cIniDiu)
       nSegJDF := nHoraSeg(cFinDiu)
       nSegJNI := nHoraSeg(cIniNoc)
       nSegJNF := nHoraSeg(cFinNoc)

       nSegEnt := nHoraSeg(cHorIng)
       nSegOut := nHoraSeg(cHorOut)
*>>>>FIN CONVERSION DEL TIEMPO A SEGUNDOS

*>>>>DIFERENCIA DE TIEMPO
       nTotSeg := nSegOut - nSegEnt
       nTotHor := nHHMMSS(nTotSeg,@nTotMin,@nSegund)
*>>>>FIN DIFERENCIA DE TIEMPO

*>>>>ANALISIS DEL HORARIO DEL DIA
       DO CASE
       CASE (nSegEnt >= 0 .AND. nSegEnt <= nSegJNF) .AND.;
	    (nSegOut >= 0 .AND. nSegOut <= nSegJNF)              // (1,1)

	    nTipHor := 1  // Hora Nocturna
	    nHorNoc := nHHMMSS(nTotSeg,@nMinNoc,@nSegNoc)

       CASE (nSegEnt >= 0       .AND. nSegEnt <= nSegJNF) .AND.;
	    (nSegOut >= nSegJDI .AND. nSegOut <= nSegJDF)        // (1,2)

	    nTipHor := 2  // Horas Nocturnas y Horas Diurnas

	    nTotDiu := nHoraSeg(cHorOut) - nHoraSeg(cIniDiu)
	    nHorDiu := nHHMMSS(nTotDiu,@nMinDiu,@nSegDiu)
	  *ÀTiempo Diurno

	    nTotNoc := nTotSeg - nTotDiu
	    nHorNoc := nHHMMSS(nTotNoc,@nMinNoc,@nSegNoc)
	  *ÀTiempo Nocturno

       CASE (nSegEnt >= 0       .AND. nSegEnt <= nSegJNF) .AND.;
	    (nSegOut >= nSegJNI .AND. nSegOut <= 86400)          // (1,3)

	    nTipHor := 3  // Horas Nocturnas y Horas Diurnas

	    nTotDiu := nHoraSeg(cFinDiu) - nHoraSeg(cIniDiu)
	    nHorDiu := nHHMMSS(nTotDiu,@nMinDiu,@nSegDiu)
	  *ÀTiempo Diurno

	    nTotNoc := nTotSeg - nTotDiu
	    nHorNoc := nHHMMSS(nTotNoc,@nMinNoc,@nSegNoc)
	  *ÀTiempo Nocturno

       CASE (nSegEnt >= nSegJDI .AND. nSegEnt <= nSegJDF) .AND.;
	    (nSegOut >= nSegJDI .AND. nSegOut <= nSegJDF)        // (2,2)

	    nTipHor := 4  // Horas Diurnas
	    nHorDiu := nHHMMSS(nTotSeg,@nMinDiu,@nSegDiu)

       CASE (nSegEnt >= nSegJDI .AND. nSegEnt <= nSegJDF) .AND.;
	    (nSegOut >= nSegJNI .AND. nSegOut <= 86400)          // (2,3)

	    nTipHor := 5  // Horas Diurnas y Horas Nocturnas

	    nTotDiu := nHoraSeg(cFinDiu) - nHoraSeg(cHorIng)
	    nHorDiu := nHHMMSS(nTotDiu,@nMinDiu,@nSegDiu)
	  *ÀTiempo Diurno

	    nTotNoc := nTotSeg - nTotDiu
	    nHorNoc := nHHMMSS(nTotNoc,@nMinNoc,@nSegNoc)
	  *ÀTiempo Nocturno

       CASE (nSegEnt >= nSegJNI .AND. nSegEnt <= 86400) .AND.;
	    (nSegOut >= nSegJNI .AND. nSegOut <= 86400)          // (3,3)

	    nTipHor := 6  // Horas Nocturnas
	    nHorNoc := nHHMMSS(nTotSeg,@nMinNoc,@nSegNoc)

       ENDCASE
*>>>>FIN ANALISIS DEL HORARIO DEL DIA

*>>>>CALCULO DE LOS SEGUNDOS
       nNroSeg := nSegDiu+nSegNoc
       IF nNroSeg >= 60

	  nNroMin := INT(nNroSeg/60)
	  nNroSeg := nNroSeg - nNroMin*60

	  IF lSegDiu(nHorDiu,nMinDiu,nSegDiu,;
		     nHorNoc,nMinNoc,nSegNoc)
	     nMinDiu += nNroMin
	  ELSE
	     nMinNoc += nNroMin
	  ENDIF
       ENDIF
*>>>>FIN CALCULO DE LOS SEGUNDOS

*>>>>ASIGNACION DEL TIEMPO TRASCURRIDO
       aTiempo[HOD] += nHorDiu
       aTiempo[MDI] += nMinDiu
       aTiempo[HON] += nHorNoc
       aTiempo[MNO] += nMinNoc
       aTiempo[SEG] += nNroSeg

       RETURN aTiempo
*>>>>FIN ASIGNACION DEL TIEMPO TRASCURRIDO

/*************************************************************************
* TITULO ..: ANALISIS DE LOS HORAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 26/2005 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   SEP 26/2005 LUN

OBJETIVOS:

1- Compara las horas,minutos,segundos de los horarios Diurno y Nocturno
   para determinar quien es mayor en orden ascendente

2- Retorna .T. el tiempo Diurno es el Mayor

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSegDiu(nHorDiu,nMinDiu,nSegDiu,nHorNoc,nMinNoc,nSegNoc)

*>>>>DESCRIPCION DE PARAMETROS
/*     nHorDiu                              // Hora Diurna
       nMinDiu                              // Minuto Diurno
       nSegDiu                              // Segundo Diurno
       nHorNoc                              // Hora Nocturna
       nMinNoc                              // Minuto Nocturno
       nSegNoc                              // Segundo Nocturno */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSegDiu := .F.                  // .T. Tiempo Diurno
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DEL TIEMPO
       DO CASE
       CASE nSegDiu > nSegNoc
	    lSegDiu := .T.

       CASE nSegNoc > nSegDiu
	    lSegDiu := .F.

       OTHERWISE
	    DO CASE
	    CASE nMinDiu > nSegNoc
		 lSegDiu := .T.

	    CASE nMinNoc > nMinDiu
		 lSegDiu := .F.

	    OTHERWISE
		 IF nHorDiu > nHorNoc
		    lSegDiu := .T.
		 ELSE
		    lSegDiu := .F.
		 ENDIF
	    ENDCASE
       ENDCASE
       RETURN lSegDiu
*>>>>FIN ANALISIS DEL TIEMPO

/*************************************************************************
* TITULO ..: HORAS DIAS                                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 22/2005 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   JUL 22/2005 VIE

OBJETIVOS:

1- Calcula los d¡as,horas,minutos entre varios o el mismo d¡a.

2- Retorna el tiempo de estadia

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aHoraDias(dFecIng,dFecOut,cHorIng,cHorOut,cIniDiu,cFinDiu,;
		   cIniNoc,cFinNoc,nTipHor)

*>>>>DESCRIPICON DE PARAMETROS
/*     dFecIng                              // Fecha de Ingresa
       dFecOut                              // Fecha de Salida
       cHorIng                              // Hora del Ingreso
       cHorOut                              // Hora de Salida
       cIniDiu                              // Inicio Hora Diurna
       cFinDiu                              // Final Hora Diurna
       cIniNoc                              // Inicio Hora Nocturna
       cFinNoc                              // Final Hora Nocturna
       nTipHor                              // @Tipo de Hora */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nTotDia := 0                   // Total de Dias
       LOCAL nTotMes := 0                   // Total de Meses
       LOCAL nTotAno := 0                   // Total de A¤os

       LOCAL nNroAno := 0                   // N£mero de A¤os
       LOCAL nNroMes := 0                   // N£mero de Meses
       LOCAL nNroDia := 0                   // N£mero de Dias
       LOCAL nNroHor := 0                   // N£mero de Horas
       LOCAL nNroMin := 0                   // N£mero de Minutos
       LOCAL nNroSeg := 0                   // N£mero de Segundos

       LOCAL nTipHo1 := 0		    // Tipo de Horario primer dia
       LOCAL nTipHo2 := 0		    // Tipo de Horario segundo dia
       LOCAL nHorDiu := 0                   // Horas Diurnas
       LOCAL nHorNoc := 0                   // Horas Nocturnas

       LOCAL nVarUno := 0                   // Variable Temporal
       LOCAL nVarDos := 0                   // Variable Temporal

       LOCAL aTiempo[8]                     // Tiempo Transcurrido
*>>>>FIN DECLARACION DE VARIABLES

*>>>>TOTALES DIAS,MESES,A¥OS
       nTotDia := dFecOut - dFecIng
       DO CASE
       CASE nTotDia == 31 .AND.;
	    cHorIng == '00:00:00' .AND. cHorOut == '24:00:00'
	    nTotDia := 29

       CASE MONTH(dFecIng) == 2 .AND. nTotDia >= 28 .AND. nTotDia <= 31 .AND.;
	    cHorIng == '00:00:00' .AND. cHorOut == '24:00:00'
	    nTotDia := 27
       ENDCASE

       nTotMes := MONTH(dFecOut) - MONTH(dFecIng)
       nTotAno := YEAR(dFecOut) - YEAR(dFecIng)
*>>>>FIN TOTALES DIAS,MESES,A¥OS

*>>>>FEBRERO COMO DE 30 DIAS
       IF nTotMes > 0 .OR. nTotAno > 0

/* GENERA ERROR PARA TIEMPO DE PARQUEO
	  IF MONTH(dFecIng) == 2
	     nTotDia += 2
	     IF LASTDAYOM(MONTH(dFecIng)) == 29
		nTotDia -= 1
	     ENDIF
	  ENDIF
GENERA ERROR PARA TIEMPO DE PARQUEO */

       ENDIF
*>>>>FIN FEBRERO COMO DE 30 DIAS

*>>>>CALCULO DEL TIEMPO DE UN DIA
       AFILL(aTiempo,0)
       IF nTotDia == 0
	  aTiempo := aHoraDia(cHorIng,cHorOut,cIniDiu,cFinDiu,;
			      cIniNoc,cFinNoc,@aTiempo,@nTipHo1)
	  nTipHo2 := nTipHo1
	  nTipHor := nTipHo2
       ENDIF
*>>>>FIN CALCULO DEL TIEMPO DE UN DIA

*>>>>CALCULO DEL TIEMPO DE VARIOS DIAS
       IF nTotDia > 0

	  aTiempo := aHoraDia(cHorIng,'24:00:00',cIniDiu,cFinDiu,;
			      cIniNoc,cFinNoc,@aTiempo,@nTipHo1)
	*ÀTiempo del primer d¡a

	  aTiempo := aHoraDia('00:00:00',cHorOut,cIniDiu,cFinDiu,;
			      cIniNoc,cFinNoc,@aTiempo,@nTipHo2)
	*ÀTiempo del £ltimo d¡a

       ENDIF
       nTipHor := nTipHo2
*>>>>FIN CALCULO DEL TIEMPO DE VARIOS DIAS

*>>>>CALCULO DE LOS DIAS DE UN MES
       IF nTotDia >= 1 .AND. nTotDia <= 31

	       nNroDia := nTotDia - 1
	  aTiempo[DIA] := nNroDia

       ENDIF
*>>>>FIN CALCULO DE LOS DIAS DE UN MES

*>>>>CALCULO DE LOS DIAS VARIOS MESES
       IF nTotDia > 31

************DIAS DEL PRIMER MES
	      nNroDia := 30 - DAY(dFecIng)
	      IF nHoraSeg(cHorIng) == 0
		 nNroDia++
	      ENDIF
************FIN DIAS DEL PRIMER MES

************DIAS DEL ULTIMO MES
	      nNroDia += DAY(dFecOut) - 1
	      IF nHoraSeg(cHorOut) == 86400
		 nNroDia++
	      ENDIF
	      aTiempo[DIA] := nNroDia
************FIN DIAS DEL ULTIMO MES

       ENDIF
*>>>>FIN CALCULO DE LOS DIAS VARIOS MESES

*>>>>CALCULO DE LOS MESES DEL MISMO A¥O
       IF nTotAno == 0 .AND. nTotMes > 0

	       nNroMes := nTotMes - 1
	  aTiempo[MES] := nNroMes

       ENDIF
*>>>>FIN CALCULO DE LOS MESES DEL MISMO A¥O

*>>>>CALCULO DE LOS MESES DE VARIOS A¥OS
       IF nTotAno > 0

**********MESES DEL PRIMER A¥O
	    nNroMes := 12 - MONTH(dFecIng) - 1
	    IF DAY(dFecIng) == 1 .AND. nHoraSeg(cHorIng) == 0
	       nNroMes++
	    ENDIF
**********FIN MESES DEL PRIMER A¥O

**********MESES DEL ULTIMO A¥O
	    nNroMes += MONTH(dFecIng) - 1
	    IF (MONTH(dFecOut) == MONTH(dFecOut) .AND.;
	       nHoraSeg(cHorOut) >= nHoraSeg(cHorIng)) .OR.;
	       MONTH(dFecOut) > MONTH(dFecOut)

	       nNroMes++

	    ENDIF
**********FIN MESES DEL ULTIMO A¥O

	  aTiempo[MES] := nNroMes

       ENDIF
*>>>>FIN CALCULO DE LOS MESES DE VARIOS A¥OS

*>>>>CALCULO DE LOS A¥OS
       IF nTotAno > 0
	       nNroAno := nTotAno - 1
	  aTiempo[ANO] := nNroAno
       ENDIF
*>>>>FIN CALCULO DE LOS A¥OS

*>>>>CALCULO DE LOS SEGUNDOS
       IF aTiempo[SEG] >= 60

	  nNroMin := INT(aTiempo[SEG]/60)
	  nNroSeg := aTiempo[SEG] - nNroMin*60

	  DO CASE
	  CASE nTipHo1 == 1 .OR. nTipHo2 == 6
	       aTiempo[MNO] += nNroMin

	  CASE nTipHo1 == 6 .OR. nTipHo2 == 1
	       aTiempo[MNO] += nNroMin

	  OTHERWISE
	       aTiempo[MDI] += nNroMin
	  ENDCASE
	  aTiempo[SEG] := nNroSeg
       ENDIF
*>>>>FIN CALCULO DE LOS SEGUNDOS

*>>>>CALCULO DE LOS MINUTOS DIURNOS
       IF aTiempo[MDI] >= 60

	  nNroHor := INT(aTiempo[MDI]/60)
	  nNroMin := aTiempo[MDI] - nNroHor*60

	  aTiempo[HOD] += nNroHor
	  aTiempo[MDI] := nNroMin

       ENDIF
*>>>>FIN CALCULO DE LOS MINUTOS DIURNOS

*>>>>CALCULO DE LOS MINUTOS NOCTURNOS
       IF aTiempo[MNO] >= 60

	  nNroHor := INT(aTiempo[MNO]/60)
	  nNroMin := aTiempo[MNO] - nNroHor*60

	  aTiempo[HON] += nNroHor
	  aTiempo[MNO] := nNroMin

       ENDIF
*>>>>FIN CALCULO DE LOS MINUTOS NOCTURNOS

*>>>>SUMA DE LOS MINUTOS NOCTURNOS Y DIURNOS
       IF aTiempo[MNO]+aTiempo[MDI] >= 60

	  nNroHor := INT((aTiempo[MNO]+aTiempo[MDI])/60)
	  nNroMin := aTiempo[MNO]+aTiempo[MDI] - nNroHor*60

	  IF aTiempo[MDI] > aTiempo[MNO]
	     aTiempo[HOD] += nNroHor
	     aTiempo[MDI] := 0
	     aTiempo[MNO] := nNroMin
	  ELSE
	     aTiempo[HON] += nNroHor
	     aTiempo[MNO] := 0
	     aTiempo[MDI] := nNroMin
	  ENDIF

       ENDIF
*>>>>FIN SUMA DE LOS MINUTOS NOCTURNOS Y DIURNOS

*>>>>CALCULO DE LOS DIAS
       IF aTiempo[HOD] >= 12 .AND. aTiempo[HON] >= 12

	  nNroDia := INT((aTiempo[HOD]+aTiempo[HON])/24)

	  nHorDiu := aTiempo[HOD] - nNroDia*12
	  nHorNoc := aTiempo[HON] - nNroDia*12

	  aTiempo[DIA] += nNroDia
	  aTiempo[HOD] := nHorDiu
	  aTiempo[HON] := nHorNoc
       ENDIF
*>>>>FIN CALCULO DE LOS DIAS

*>>>>CALCULO DE LOS MESES
       IF aTiempo[DIA] >= 30

	  nNroMes := INT(aTiempo[DIA]/30)
	  nNroDia := aTiempo[DIA] - nNroMes*30

	  aTiempo[MES] += nNroMes
	  IF aTiempo[DIA] == 31
	     aTiempo[DIA] := 0
	  ELSE
	     aTiempo[DIA] := nNroDia
	  ENDIF
       ENDIF
*>>>>FIN CALCULO DE LOS MESES

*>>>>CALCULO DE LOS A¥OS
       IF aTiempo[MES] >= 12

	  nNroAno := INT(aTiempo[MES]/12)
	  nNroMes := aTiempo[MES] - nNroAno*12

	  aTiempo[ANO] += nNroAno
	  aTiempo[MES] := nNroMes
       ENDIF
       RETURN aTiempo
*>>>>FIN CALCULO DE LOS A¥OS

/*************************************************************************
* TITULO ..: HORAS MINUTOS                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 22/2005 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   JUL 22/2005 VIE

OBJETIVOS:

1- Calcula las horas y minutos de una hora inicia y final

2- Retorna las Horas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nHHMMSS(nTotSeg,nNroMin,nNroSeg)

*>>>>DESCRIPICON DE PARAMETROS
/*     nNroMin			            // @N£mero de Minutos
       nNroSeg                              // @N£mero de Segundos */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nTotMin := 0                   // Total Minutos
       LOCAL nNroHor := 0                   // N£mero de Horas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LAS HORAS
       nTotMin := INT(nTotSeg/60)
       nNroHor := INT(nTotMin/60)

       nNroMin := nTotMin - nNroHor*60
       nNroSeg := nTotSeg - (nNroHor*3600) - (nNroMin*60)

       RETURN nNroHor
*>>>>FIN CALCULO DE LAS HORAS

/*************************************************************************
* TITULO ..: HORA A SEGUNDOS                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 26/2005 MAR A
       Colombia, Bucaramanga        INICIO: 12:30 PM   JUL 26/2005 MAR

OBJETIVOS:

1- Convierte la hora en Segundos

2- Retorna los Segundos

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nHoraSeg(cTimes)

*>>>>DESCRIPICON DE PARAMETROS
/*     cTimes                               // Hora a Convertir */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nTotSeg := 0                   // Total de Segundos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>HORA A SEGUNDOS
       cTimes := ALLTRIM(cTimes)
       IF cTimes == '24:00:00'
	  nTotSeg := 86400
       ELSE
	  nTotSeg := TIMETOSEC(cTimes)
       ENDIF
       RETURN nTotSeg
*>>>>FIN HORA A SEGUNDOS

/*************************************************************************
* TITULO ..: TIEMPO A TEXTO                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 22/2005 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   JUL 22/2005 VIE

OBJETIVOS:

1- Convierte el vector del tiempo a texto

2- Retorna las Horas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTimeTxt(aTiempo)

*>>>>DESCRIPICON DE PARAMETROS
/*     aTiempo                              // Tiempo */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cTime   := ''                  // Tiempo
       LOCAL cTiempo := ''                  // Tiempo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CONVERSION DEL TIEMPO A TEXTO
       FOR i := 1 TO LEN(aTiempo)

	   cTime := STR(aTiempo[i],2)
	   lCorrecion(@cTime)

	   cTiempo += cTime
	   IF i # LEN(aTiempo)
	      cTiempo += ':'
	   ENDIF
       ENDFOR
       RETURN cTiempo
*>>>>FIN CONVERSION DEL TIEMPO A TEXTO

/*************************************************************************
* TITULO ..: CALCULO DEL PORCENTAJE                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 29/2007 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AGO 29/2007 MIE

OBJETIVOS:

1- Calcula el porcentaje

2- Retorna retorna el porcentaje

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cPorcen(nNroTot,nNroPar)

*>>>>DESCRIPICON DE PARAMETROS
/*     nNroTot                              // N£mero total
       nNroPar                              // N£mero parcial */
*>>>>DESCRIPICON DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cPorcen := ''                  // Porcentaje
       LOCAL nPorcen := 0                   // Porcentaje
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL PORCENTAJE
       IF nNroPar # 0
	  nPorcen := ROUND((nNroPar*100)/nNroTot,2)
	  cPorcen := ALLTRIM(STR(nPorcen,6,2))+'%'
       ENDIF
       RETURN cPorcen
*>>>>FIN CALCULO DEL PORCENTAJE

/*************************************************************************
* TITULO..: LECTURA DE LOS PARAMETROS GENERALES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 23/2007 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   NOV 23/2007 MIE

OBJETIVOS:

1- Permite leer un parametro de los parametros genereles especificados.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xParams(aParams,cParams)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParams			       // Parametros Generales
       cParams			       // Parametro de la funci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                         // Contador
       LOCAL xParams := NIL                       // xParametro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL PARAMETRO
       k := ASCAN(aParams,{|aArray|aArray[1] == cParams})
       IF k # 0
	  xParams := aParams[k,2]
       ELSE
	  cError(cParams+' NO SE ENCONTRO')
	  cParams := NIL
       ENDIF
       RETURN xParams
*>>>>FIN LECTURA DEL PARAMETRO

/*************************************************************************
* TITULO..: LECTURA DE LOS PARAMETROS GENERALES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 23/2007 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   NOV 23/2007 MIE

OBJETIVOS:

1- Permite leer un parametro de los parametros genereles especificados.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xPrm(aParams,cParams,xIniPrm)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParams			            // Parametros Generales
       cParams			            // Parametro de la funci¢n
       xIniPrm			            // Inicializar el Parametro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                   // Contador
       LOCAL xParams := NIL                 // xParametro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL PARAMETRO
       xIniPrm := IF(xIniPrm == NIL,NIL,xIniPrm)

       k := ASCAN(aParams,{|aArray|UPPER(aArray[1]) == UPPER(cParams)})
       IF k # 0
	  xParams := aParams[k,2]
       ELSE
	  IF xIniPrm == NIL
	     cError(cParams+' NO SE ENCONTRO')
	     cParams := NIL
	     ?aParams[k,2]   // Provoca un error en el sistema.
	  ELSE
	     AADD(aParams,{cParams,xIniPrm})
	     xParams := xIniPrm
	  ENDIF

       ENDIF
       RETURN xParams
*>>>>FIN LECTURA DEL PARAMETRO

/*************************************************************************
* TITULO..: ASIGNACION DE LOS PARAMETROS GENERALES                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 23/2007 MIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   NOV 23/2007 MIE

OBJETIVOS:

1- Permite asignar el valor de un parametro de los parametros
   genereles especificados.

2- Retorna el indice del parametro

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nParameSet(aParams,cParams,xValor)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParams			       // Parametros Generales
       cParams			       // Parametro de la funci¢n
       xValor                          // Valor del Parametro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                         // Contador
       LOCAL xParams := NIL                       // xParametro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ASIGNACION DEL PARAMETRO
       k := ASCAN(aParams,{|aArray|aArray[1] == cParams})
       IF k # 0
	  aParams[k,2] := xValor
       ELSE
	  cError(cParams+' NO SE ENCONTRO')
	  cParams := NIL
       ENDIF
       RETURN k
*>>>>FIN ASIGNACION DEL PARAMETRO

/*************************************************************************
* TITULO..: LECTURA DE LOS PARAMETROS GENERALES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 14/2007 MIE A
       Colombia, Bucaramanga        INICIO: 09:30 AM   NOV 14/2007 MIE

OBJETIVOS:

1- Permite leer un parametro de los parametros genereles especificados.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aParams(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1			       // Parametrso Generales No.1
       aParam2			       // Parametrso Generales No.2
       aParam3			       // Parametrso Generales No.3 */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0                         // Contador
       LOCAL aParams := {}                        // Parametrso Generales
*>>>>FIN DECLARACION DE VARIABLES

*>>>>PARAMETROS GENERALES
       aParams := {}

       IF !EMPTY(aParam1) .AND. LEN(aParam1) > 0
	  FOR k := 1 TO LEN(aParam1)
	      AADD(aParams,{aParam1[k,1],aParam1[k,2]})
	  ENDFOR
       ENDIF

       IF !EMPTY(aParam2) .AND. LEN(aParam2) > 0
	  FOR k := 1 TO LEN(aParam2)
	      AADD(aParams,{aParam2[k,1],aParam2[k,2]})
	  ENDFOR
       ENDIF

       IF !EMPTY(aParam3) .AND. LEN(aParam3) > 0
	  FOR k := 1 TO LEN(aParam3)
	      AADD(aParams,{aParam3[k,1],aParam3[k,2]})
	  ENDFOR
       ENDIF
       RETURN aParams
*>>>>FIN PARAMETROS GENERALES

/*************************************************************************
* TITULO..: LOCALIZACION DE UN PARAMETRO                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 25/2008 MIE A
       Colombia, Bucaramanga        INICIO:  04:00 PM  JUN 25/2008 MIE

OBJETIVOS:

1- Localiza un parametro dentro de un vector

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocatePrm(aArrPrm,cParams,xVlrPrm)

*>>>>DESCRIPCION DE PARAMETROS
/*     aArrPrm                              // Array de parametros
       cParams			            // Nombre del Parametro
       xVlrPrm                              // Valor del Parametro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayPrm := .F.                 // .T. Existe el Parametro
       LOCAL cNomPrm := ''                  // Nombre del parametro
       LOCAL xValor  := ''                  // Valor del Parametro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL PARAMETRO
       FOR i := 1 TO LEN(aArrPrm)

	   cNomPrm := aArrPrm[i,1]
	    xValor := aArrPrm[i,2]

	   IF cParams == cNomPrm .AND. xValor == xVlrPrm
	      lHayPrm := .T.
	   ENDIF

       ENDFOR
       RETURN lHayPrm
*>>>>FIN LOCALIZACION DEL PARAMETRO

/*************************************************************************
* TITULO..: LOCALIZACION DE UN PARAMETRO                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 25/2008 MIE A
       Colombia, Bucaramanga        INICIO:  05:00 PM  JUN 25/2008 MIE

OBJETIVOS:

1- Localiza un parametro dentro de un vector

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLocArrPrm(aArrPrm,cParams,xVlrPrm)

*>>>>DESCRIPCION DE PARAMETROS
/*     aArrPrm                              // Array de parametros
       cParams			            // Nombre del Parametro
       xVlrPrm                              // Valor del Parametro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayPrm := .F.                 // .T. Existe el Parametro
       LOCAL aArray  := ''                  // Vector de parametros
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL PARAMETRO
       FOR i := 1 TO LEN(aArrPrm)

	   aArray := aArrPrm[i]
	   IF lLocatePrm(aArray,cParams,xVlrPrm)
	      lHayPrm := .T.
	      EXIT
	   ENDIF

       ENDFOR
       RETURN IF(lHayPrm,i,0)
*>>>>FIN LOCALIZACION DEL PARAMETRO

