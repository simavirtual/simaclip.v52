/*BIBLIOTECAS DE FUNCIONES PARA IMPRESION 1994

 AUTOR: NELSON FERNANDEZ GOMEZ       FECHA DE CREACION:

REQUERIMIENTOS:

1- Compilar: clipper funcions /w/m

OBJETIVOS:

1- Son independientes de cualquier programa

FUNCIONES:
 Printer_on

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES GENERALES
       #INCLUDE "inkey.ch"
*>>>>FIN DECLARACION DE CONSTANTES GENERALES

/*************************************************************************
* TITULO DE LA FUNCION......: ACTIVACION DE LA IMPRESORA                 *
**************************************************************************

OBJETIVOS:

1- Verifica si la impresora esta encendida

2- Retorna .T. si la impresora esta encendida

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PRINTER_ON(lPrnArc,nOpcPrn)

*>>>>PARAMATROS DE LA FUNCION
/*     lPrnArc                       // .T. Imprime en Archivo
       nOpcPrn                       // Opci¢n de Impresi¢n */
*>>>>FIN PARAMATROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lOnline := .T.          // .T.  Impresora preparada
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTIVACION DE LA IMPRESORA
       SET DEVICE TO SCREEN
       lPrnArc := IF(EMPTY(lPrnArc),.F.,lPrnArc)
       nOpcPrn := IF(EMPTY(nOpcPrn),0,nOpcPrn)

       IF nOpcPrn # 7 .AND. nOpcPrn # 8
	  IF .NOT. lPrnArc
	     DO WHILE .NOT. ISPRINTER()
		IF cError('POR FAVOR PREPARE LA IMPRESORA. NO ESTA EN LINEA',NIL,;
			  'Pulse la tecla <ESC> para NO Continuar') == CHR(27)
		   lOnline := .F.
		   EXIT
		ENDIF
	     ENDDO
	  ENDIF
       ENDIF

       IF lOnline
	  SET DEVICE TO PRINT
       ENDIF

       RETURN lOnline
*>>>>FIN ACTIVACION DE LA IMPRESORA

/*************************************************************************
* TITULO DEL PROGRAMA..: ENCABEZADO DEL INFORME                          *
**************************************************************************

OBJETIVOS:

1- Imprime el encabezado de un informe de acuerdo al tama¤o de la hoja

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EncabezPrn(cNomEmp,cNomSis,cTitUno,cTitDos,;
		    cTiTres,nNroPag,cTotPag,lTamAnc,;
		    cFecPrn,cHorPrn,cDiaPrn,;
		    cCodIso,cFecIso,cVerIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomEmp                                  // Nombre de la empresa
       cNomSis                                  // Nombre del sistema
       cTitUno                                  // Titulo uno del informe
       cTitDos                                  // Titulo dos del informe
       cTiTres                                  // Titulo tres del informe
       nNroPag                                  // N£mero p gina a imprimir
       cTotPag                                  // Total p ginas a imprimir
       lTamAnc                                 	// .T. Tama¤o ancho
       cFecPrn                                  // @Fecha de Impresi¢n
       cHorPrn                                  // @Hora de Impresi¢n
       cDiaPrn                                  // @D¡a de Impresi¢n
       cCodIso                                  // C¢digo Iso del Informe
       cFecIso                                  // Fecha del Iso
       cVerIso                                  // Versi¢n del Iso */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "EPSONFX.PRG"                   // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroCol := 0                           // N£mero de Columna
       LOCAL nLenPrn := 0                           // Longitud de impresi¢n
       LOCAL cCodIni := ''                          // C¢digos Iniciales de Impresi¢n
       LOCAL cCodFin := ''                          // C¢digos Finales de Impresi¢n
       LOCAL nPosIso := 0                           // Posici¢n del Iso
       LOCAL cIsoTem := ''                          // C¢digo Iso
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       lTamAnc := IF(lTamAnc == NIL,.F.,lTamAnc)
       nLenPrn := IF(lTamAnc,136,80)
      *Calculo de la longitud de impresion

       DO CASE
       CASE LEN(cNomEmp) <= 40
	    nNroCol := ((nLenPrn/2)-LEN(cNomEmp))/2
	    IF ALIAS(SELECT('PRN')) == 'PRN'
	       cCodIni := PCL({'DobAncOn','NegraOn','DobGolOn'})
	       cCodFin := PCL({'DobAncOf','NegraOf','DobGolOf'})
	    ELSE
	       cCodIni := DOBANC_ON+NEGRA_ON+DOBGOL_ON
	       cCodFin := DOBANC_OF+NEGRA_OF+DOBGOL_OF
	    ENDIF

       CASE LEN(cNomEmp) > 40 .AND. LEN(cNomEmp) <= 42
	    nNroCol = 0
	    IF ALIAS(SELECT('PRN')) == 'PRN'
	       cCodIni := PCL({'DobAncOn','NegraOn','DobGolOn'})
	       cCodFin := PCL({'DobAncOf','NegraOf','DobGolOf'})
	    ELSE
	       cCodIni := DOBANC_ON+NEGRA_ON+DOBGOL_ON
	       cCodFin := DOBANC_OF+NEGRA_OF+DOBGOL_OF
	    ENDIF
       OTHERWISE
	    nNroCol := (nLenPrn-LEN(cNomEmp))/2
	    IF ALIAS(SELECT('PRN')) == 'PRN'
	       cCodIni := PCL({'DobAncOn','DobGolOn'})
	       cCodFin := PCL({'DobAncOf','DobGolOf'})
	    ELSE
	       cCodIni := NEGRA_ON+DOBGOL_ON
	       cCodFin := NEGRA_OF+DOBGOL_OF
	    ENDIF
       ENDCASE

       IF ALIAS(SELECT('PRN')) == 'PRN'
	  @ PROW(),nNroCol SAY PCL({'GraphiOn','CondenOf',;
				    'ProporOf','Pica',;
				    'DraftOf','Roman'})
       ELSE
	  @ PROW(),nNroCol SAY GRAPHI_ON+CONDEN_OF+PROPOR_OF+;
			       PICA+DRAFT_OF+ROMAN_ON
       ENDIF

       @ PROW(),nNroCol SAY cCodIni
       @ PROW(),nNroCol SAY cNomEmp
       @ PROW(),nNroCol SAY cCodFin
*>>>>FIN IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL NOMBRE DEL SISTEMA
       nPosIso := AT('ISO:',cNomSis)
       IF nPosIso # 0
	  cIsoTem := SUBS(cNomSis+SPACE(50),nPosIso+4,50)
	  cIsoTem := ALLTRIM(cIsoTem)
	  cNomSis := ALLTRIM(SUBS(cNomSis,1,nPosIso-1))
       ELSE
	  cIsoTem := ALLTRIM(cCodIso)+SPACE(02)+;
		     ALLTRIM(cFecIso)+SPACE(02)+;
		     ALLTRIM(cVerIso)
       ENDIF

       nNroCol = (nLenPrn-LEN(cNomSis))/2

       IF ALIAS(SELECT('PRN')) == 'PRN'
	  @ PROW()+1,nNroCol SAY PCL('ItalicOn')+;
				 UPPER(cNomSis)+;
				 PCL('ItalicOf')

	  IF !EMPTY(cIsoTem)
	     nNroCol := IF(lTamAnc,nLenPrn-10,nLenPrn)
	     @ PROW(),nNroCol-10 SAY PCL('CondenOn')+;
				    cIsoTem+;
				    PCL('CondenOf')
	  ENDIF
       ELSE
	  @ PROW()+1,nNroCol SAY ITALIC_ON+UPPER(cNomSis)+ITALIC_OF
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL SISTEMA

*>>>>IMPRESION DEL TITULO UNO
       nNroCol = (nLenPrn-LEN(cTitUno))/2

       IF ALIAS(SELECT('PRN')) == 'PRN'
	  @ PROW()+1,nNroCol SAY PCL('NegraOn')+cTitUno+PCL('NegraOf')
       ELSE
	  @ PROW()+1,nNroCol SAY NEGRA_ON+cTitUno+NEGRA_OF
       ENDIF
*>>>>FIN IMPRESION DEL TITULO UNO

*>>>>IMPRESION DE LA FECHA, TITULO DOS, HORA
       IF nNroPag # NIL
	  cFecPrn := cFecha(DATE(),10)
	  @ PROW()+2,00 SAY cFecPrn
       ENDIF

       nNroCol = (nLenPrn-LEN(cTitDos))/2
       @ PROW(),nNroCol SAY cTitDos

       IF nNroPag # NIL
	  cHorPrn := cHoraSys()
	  @ PROW(),nLenPrn-13 SAY 'HORA '+cHorPrn
       ENDIF
*>>>>FIN IMPRESION DE LA FECHA, TITULO DOS, HORA

*>>>>IMPRESION DEL DIA DE LA SEMANA, TITULO TRES, TOTAL DE PAGINAS
       IF nNroPag # NIL
	  cDiaPrn := cDia(DOW(DATE()),9)
	  @ PROW()+1,00 SAY cDiaPrn
       ENDIF
       nNroCol = (nLenPrn-LEN(cTiTres))/2
       @ PROW(), nNroCol SAY cTiTres

       IF nNroPag # NIL
	  @ PROW(), nLenPrn-14 SAY 'P gina No.'+LTRIM(STR(nNroPag))+;
				   IF(cTotPag==NIL,'','/'+cTotPag)
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL DIA DE LA SEMANA, TITULO TRES, TOTAL DE PAGINAS

/*************************************************************************
* TITULO DEL PROGRAMA..: CALCULO DEL TOTAL DE PAGINAS                    *
**************************************************************************

OBJETIVOS:

1- Calcula el total de p ginas

2- Retorna el total de p ginas a imprimir

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTotPagina(nTotReg,nLinPag,lOficio)

*>>>>PARAMETROS DE LA FUNCION
/*     nTotReg                              // Total de Registros
       nLinPag                              // L¡neas por p gina
       lOficio                              // .F. Tama¤o Carta */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>PARAMETROS DE LA FUNCION
       LOCAL nTotPag := 0                     // Total de paginas
       LOCAL nNroLin := 0                     // N£mero de l¡neas por p gina
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>ANALISIS DE LOS PARAMETROS
      IF nTotReg == NIL .OR. nTotReg == 0
	 IF nTotReg == NIL
	    cError('NO PASO EL TOTAL DE REGISTROS EN cTotPagina')
	 ENDIF
	 RETURN NIL
      ENDIF
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>CALCULO DEL TOTAL DE PAGINAS
       lOficio := IF(EMPTY(lOficio),.F.,lOficio)
       nNroLin := IF(lOficio,62,52)
       nLinPag := IF(EMPTY(nLinPag),nNroLin,nLinPag)
       nTotPag = INT(nTotReg/nNroLin)
       IF nTotReg/nLinPag > nTotPag
	  nTotPag = nTotPag + 1
       ENDIF
       RETURN LTRIM(STR(INT(nTotPag)))
*>>>>FIN CALCULO DEL TOTAL DE PAGINAS

/*************************************************************************
* TITULO DEL PROGRAMA..: CALCULO DE LA HORA DEL SISTEMA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/95 MAR A
       Colombia, Bucaramanga        INICIO: 06:04 PM   DIC 26/95 MAR

OBJETIVOS:

1- Prepara la hora del sistema en forma de texto

2- Retorna la hora del sistema

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cHoraSys(cHorSys)

*>>>>PARAMETROS DE LA FUNCION
/*     cHorSys                              // Hora del sistema */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cHorDia := ''                      // Hora del D¡a
       LOCAL nHorSys := 0                       // Hora del sistema
       LOCAL nSegHor := 0                       // N£mero de Segundos
       LOCAL cAMorPM := ''                      // Meridiano AM o PM
*>>>>FIN DECLARACION DE VARIABLES

*>>>>HORA DEL SISTEMA
       IF cHorSys == NIL
	  cHorDia := TIME()
       ELSE
	  cHorDia := cHorSys
       ENDIF
       nHorSys := VAL(SUBS(cHorDia,1,2))

       nSegHor := nHoraSeg(cHorDia)
      *12h = 43200 Segundos

       IF nSegHor > 43200
	  IF nHorSys > 12
	     nHorSys = nHorSys - 12
	  ENDIF
	  cAMorPM = ' PM'
       ELSE
	  cAMorPM = ' AM'
       ENDIF
       nHorSys = IIF(nHorSys < 10 , STR(nHorSys,2) , STR(nHorSys,2))
       RETURN nHorSys+IF(cHorSys==NIL,SUBS(TIME(),3,3),SUBS(cHorSys,3,3))+cAMorPM
*>>>>FIN HORA DEL SISTEMA

/*************************************************************************
* TITULO DEL PROGRAMA..: REGISTRO DE IMPRESION                           *
**************************************************************************

OBJETIVOS:

1- Prepara como texto la l¡nea a imprimir de acuerdo con los contenidos
   de las columnas

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna la variable cTxtPrn

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cRegPrint(aTitulos,aTamCol,aNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     aTitulos                             // T¡tulos del informe
       aTamCol				    // Tama¤o de los t¡tilos
       aNroCol			            // @Columnas para los t¡tulos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lPrinte                        // .T. Impresora .F. Pantalla
       LOCAL nSpace  := 1                   // Espacios entre titulos
       LOCAL nSpaces := 0                   // Espacios
       LOCAL cTitulo := ''                  // Titulo
       LOCAL nTotEle := 0                   // Total Elementos
       LOCAL cTxtPrn := ''                  // Texto a imprimir
       LOCAL nTamCol := 0                   // Longitud de la Columna
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL       i := 0                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL TOTAL DE ELEMENTOS
       FOR i := 1 TO LEN(aTitulos)
	   IF aTitulos[i] # NIL
	      nTotEle++
	   ENDIF
       NEXT
*>>>>FIN CALCULO DEL TOTAL DE ELEMENTOS

*>>>>PREPARACION DE LA VARIABLE DE IMPRESION
       lPrinte := IF(aNroCol == NIL,.T.,.F.)
       i:=1
       DO WHILE i <= nTotEle

	  nTamCol := aTamCol[i]
	  cTitulo := aTitulos[i]

	  cTitulo := IF(lPar(LEN(cTitulo)),cTitulo,cTitulo+SPACE(01))

	  nSpaces := SPACE(nTamCol/2-LEN(cTitulo)/2)
	 *Calcula los espacios entre columna

	  IF lPrinte
	     cTxtPrn = cTxtPrn +'|'+nSpaces+cTitulo+nSpaces
	  ELSE
	     cTxtPrn = cTxtPrn +cTitulo+nSpaces+nSpaces+SPACE(nSpace)
	  ENDIF

	  i++

       ENDDO
       IF lPrinte
	  cTxtPrn = cTxtPrn + '|'
       ENDIF
*>>>>FIN PREPARACION DE LA VARIABLE DE IMPRESION

*>>>>CALCULO DEL VALOR DE LAS COLUMNAS
       IF !lPrinte
	  i := 1
	  AADD(aNroCol,i)
	  aNroCol[1] := 1
	  DO WHILE i <= nTotEle-1
	     nNroCol := aNroCol[i]
	     nTamCol := aTamCol[i]
	     AADD(aNroCol,i+1)
	     aNroCol[i+1] := nNroCol+nTamCol+nSpace
	     i++
	  ENDDO
       ENDIF
       RETURN RTRIM(cTxtPrn)
*>>>>FIN CALCULO DEL VALOR DE LAS COLUMNAS

/*************************************************************************
* TITULO DEL PROGRAMA..: DERECHOS DE AUTOR POR IMPRESORA                 *
**************************************************************************

OBJETIVOS:

1- Imprime los derechos de autor por la impresora

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION DerechosPrn(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag,nLinPrn)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del sistema
       cNomEmp                              // Nombre de la empresa
       nLenPrn                              // Longitud de impresi¢n
       lOficio                              // .F. Tama¤o Carta
       lPiePag                              // .T. Imprimir el Pie de P gina
       nLinPrn                              // L¡neas de impresi¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtPrn := ''                  // Texto de impresi¢
       LOCAL nNroCol := 0                   // Columna de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS DERECHOS DE AUTOR
       lOficio := IIF(EMPTY(lOficio),.F.,lOficio)
       lPiePag := IIF(lPiePag==NIL,.T.,lPiePag)
       IF EMPTY(nLinPrn)
	  nLinPrn := IIF(lOficio,73,61)-PROW()
       ENDIF

       IF lPiePag
	  cTxtPrn := ALLTRIM(UPPER(cNomSis))+;
		     '. Instalado para: '+ALLTRIM(UPPER(cNomEmp))
*		     'Donado para: '+ALLTRIM(UPPER(cNomEmp))
       ELSE
	  cTxtPrn := SPACE(01)
       ENDIF

       nNroCol = (nLenPrn-LEN(cTxtPrn))/2

       IF nNroCol < 0
	  cError('LA COLUMNA ES NEGATIVA EN DerechosPrn')
       ENDIF

       IF PRN->TipoPrn == 'M'
/*
	  SET DEVICE TO PRINT
	  @ PROW(),00 SAY PCL({"NegraOf","CondenOn","DobGolOn"})
	  @ PROW()+nLinPrn,nNroCol SAY cTxtPrn
	  @ PROW(),00 SAY PCL({"CondenOf","DobGolOf"})
	  SET DEVICE TO SCREEN
*/
       ENDIF
       RETURN NIL
*>>>>IMPRESION DE LOS DERECHOS DE AUTOR

/*************************************************************************
* TITULO..: IMPRESION DEL PIE DE PAGINA                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 24/2006 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   MAY 24/2006 MAR

OBJETIVOS:

1- Imprime el pie de p gina en los informes

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PiePagina(cTxtPrn,nLenPrn,lOficio,nLinPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTxtPrn                              // Texto de impresi¢n
       nLenPrn                              // Longitud de impresi¢n
       lOficio                              // .F. Tama¤o Carta
       nLinPrn                              // L¡neas de impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroCol := 0                   // Columna de impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL PIE DE PAGINA
       lOficio := IIF(EMPTY(lOficio),.F.,lOficio)
       IF EMPTY(nLinPrn)
	  nLinPrn := IIF(lOficio,73,61)-PROW()
       ENDIF

       nNroCol = (nLenPrn-LEN(cTxtPrn))/2
       IF nNroCol < 0
	  SET DEVICE TO SCREEN
	  cError('LA COLUMNA ES NEGATIVA EN PiePagina()')
	  SET DEVICE TO PRINT
       ENDIF

       SET DEVICE TO PRINT
       @ PROW(),00 SAY PCL({"NegraOf","CondenOn","DobGolOn"})
       @ PROW()+nLinPrn,nNroCol SAY cTxtPrn
       @ PROW(),00 SAY PCL({"CondenOf","DobGolOf"})
       SET DEVICE TO SCREEN

       RETURN NIL
*>>>>FIN IMPRESION DEL PIE DE PAGINA

/*************************************************************************
* TITULO DE LA FUNCION..: LINEA DE IMPRESION                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 08/94 LUN A
						       AGO 08/94 LUN
OBJETIVOS:

1)- Imprime un linea compuesta por campos

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION LineaPrn(aTitulo,nNroLin)

*>>>>PARAMETROS DE LA FUNCION
/*     aTitulo                              // Titulos de las Columnas
       nNroLin                              // Lineas de Impresion */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                        // Contador
       LOCAL aNroCol := {}                 // N£mero de Columnas
       LOCAL aTamCol[LEN(aTitulo)]         // Tama¤o de las Columnas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LA LINEA
       FOR i:=1 TO LEN(aTitulo)
	 aTamCol[i] := LEN(aTitulo[i])
       NEXT
       cRegPrint(aTitulo,aTamCol,@aNroCol)

       nNroLin := IF(nNroLin == NIL,1,nNroLin)
       FOR i:= 1 TO LEN(aTitulo)
	  IF i == 1
	     @ PROW()+nNroLin,aNroCol[i] SAY aTitulo[i]
	  ELSE
	     @ PROW(),aNroCol[i] SAY aTitulo[i]
	  ENDIF
       NEXT
       RETURN NIL
*>>>>FIN IMPRESION DE LA LINEA

/*************************************************************************
* TITULO DE LA FUNCION..: IMPREMIR EN LA IMPRESORA                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 12/95 SAB A
       Colombia, Bucaramanga        INICIO: 10:37 PM   AGO 12/95 SAB

OBJETIVOS:

1)- Imprime el texto por la impresora

2)- Verifica el control del cambio de p gina

3)- Retorna .T. si debe haber cambio de p gina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrintPrn(nAvance,nNroCol,cCodIni,aCabeza,cCabCol,nColCab,;
		   cCodFin,cRegPrn,cNomSis,cNomEmp,nLinReg,nLenPrn)

*>>>>PARAMETROS DE LA FUNCION
/*     nAvance                              // N£mero avances de l¡neas
       nNroCol                              // N£mero de columna
       cCodIni                              // C¢digos de impresora iniciales
       aCabeza                              // Encabezado del informe
       cCabCol                              // Encabezados de columna
       nColCab                              // Columna para encabezados
       cCodFin                              // C¢digos de impresora finales
       cRegPrn                              // Registro a imprimir
       cNomSis                              // Nombre del sistema
       cNomEmp                              // Nombre de la empresa
       nLinReg			            // L¡neas por registro
       nLenPrn                              // Longitud M ximo del registro*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       IF lPagina(nLinReg)
	  DerechosPrn(cNomSis,cNomEmp,nLenPrn)

	  EJECT
	  lPagina := .T.

	  CabezaPrn(cCodIni,aCabeza,cCabCol,nColCab,cCodFin)
	 *Impresi¢n del encabezado
       ELSE
	  lPagina := .F.
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DEL REGISTRO
       @ PROW()+nAvance,nNroCol SAY cRegPrn
      *Impresi¢n del registro

       RETURN lPagina
*>>>>FIN IMPRESION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE UN REGISTRO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 10:50 AM   ABR 19/96 VIE

OBJETIVOS:

1)- Imprime el texto por la impresora con salto de pagina.

2)- Verifica el control del cambio de p gina

3)- Retorna .T. si debe haber cambio de p gina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnReg(nAvance,nNroCol,cRegPrn,bPagina,bDerAut,bCabeza,nTotPag,;
		 lPrnEnc)

*>>>>PARAMETROS DE LA FUNCION
/*     nAvance                              // N£mero avances de l¡neas
       nNroCol                              // N£mero de columna
       cRegPrn                              // Registro a imprimir
       bPagina                              // Funci¢n control de impresi¢n
       bPrnAut                              // Funci¢n impresi¢n de derechos
       bCabeza                              // Funci¢n impresi¢n Encabezado
       nTotPag                              // Total de P ginas
       lPrnEnc                              // .@T. Imprimir Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .F.                 // Variable de Decisi¢n
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT

       lPrnEnc := IF(lPrnEnc==NIL,.F.,lPrnEnc)
       IF lPrnEnc

	  SendCodes(PCL('Reset'))
	  EVAL(bCabeza)

	  lPrnEnc := .F.
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       lSiorNo := EVAL(bPagina)

       IF lSiorNo
	  EVAL(bDerAut)
	 *Impresi¢n de los derechos de autor

	  EJECT
	  lPagina := .T.

	  EVAL(bCabeza)
	 *Impresi¢n del encabezado

	  IF nTotPag # NIL
	     nTotPag++
	  ENDIF

       ELSE
	  lPagina := .F.
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DEL REGISTRO
       @ PROW()+nAvance,nNroCol SAY cRegPrn
      *Impresi¢n del registro

       RETURN lPagina
*>>>>FIN IMPRESION DEL REGISTRO

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE UN REGISTRO                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/96 VIE A
       Colombia, Bucaramanga        INICIO: 10:50 AM   ABR 19/96 VIE

OBJETIVOS:

1- Imprime el texto por la impresora sin salto de pagina.

2- Verifica el control del cambio de p gina

3- Esta funci¢n es igual lPrnReg pero sin salto de pagina

3- Retorna .T. si debe haber cambio de p gina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnRegi(nAvance,nNroCol,cRegPrn,bPagina,bDerAut,bCabeza,nTotPag,;
		  lPrnEnc)

*>>>>PARAMETROS DE LA FUNCION
/*     nAvance                              // N£mero avances de l¡neas
       nNroCol                              // N£mero de columna
       cRegPrn                              // Registro a imprimir
       bPagina                              // Funci¢n control de impresi¢n
       bPrnAut                              // Funci¢n impresi¢n de derechos
       bCabeza                              // Funci¢n impresi¢n Encabezado
       nTotPag                              // Total de P ginas
       lPrnEnc                              // .@T. Imprimir Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .F.                 // Variable de Decisi¢n
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL ENCABEZADO
       SET DEVICE TO PRINT

       lPrnEnc := IF(lPrnEnc==NIL,.F.,lPrnEnc)
       IF lPrnEnc

	  SendCodes(PCL('Reset'))
	  EVAL(bCabeza)

	  lPrnEnc := .F.
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       lSiorNo := EVAL(bPagina)

       IF lSiorNo
	  EVAL(bDerAut)
	 *Impresi¢n de los derechos de autor

	  lPagina := .T.

	  EVAL(bCabeza)
	 *Impresi¢n del encabezado

	  IF nTotPag # NIL
	     nTotPag++
	  ENDIF

       ELSE
	  lPagina := .F.
       ENDIF
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

*>>>>IMPRESION DEL REGISTRO
       @ PROW()+nAvance,nNroCol SAY cRegPrn
      *Impresi¢n del registro

       RETURN lPagina
*>>>>FIN IMPRESION DEL REGISTRO

/*************************************************************************
* TITULO..: IMPRESION DE UN REGISTRO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/2004 MIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   ABR 07/2004 VIE

OBJETIVOS:

1- Imprime el texto de acuerdo a la opci¢n de impresi¢n con salto de
   pagina

3- Retorna .T. si debe haber cambio de p gina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnOpc(lShared,nOpcPrn,FilePrn,nHandle,nAvance,nNroCol,;
		 aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
		 cTxtPrn,nTotPag,lPrnEnc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nOpcPrn                              // Opci¢n de Impresi¢n
       FilePrn                              // Archivo de Impresion
       nHandle                              // Manejador de Archivo
       nAvance                              // N£mero avances de l¡neas
       nNroCol                              // N£mero de columna
       aTitPrn			            // T¡tulos de Impresi¢n
       aRegPrn			            // Registros de Impresi¢n
       aNroCol                              // N£meros de Columnas
       bPagina                              // Funci¢n control de impresi¢n
       bDerAut                              // Funci¢n impresi¢n de derechos
       bCabeza                              // Funci¢n impresi¢n Encabezado
       cTxtPrn                              // Texto de Impresi¢n
       nTotPag                              // Total de P ginas
       lPrnEnc                              // .@T. Imprimir Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>IMPRESION CON FORMATO DE IMPRESORA
       SET DEVICE TO PRINT
       IF nOpcPrn < 7 .AND. !('.XLS' $ UPPER(FilePrn))

	   IF EMPTY(cTxtPrn)
	      cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	   ENDIF
	   lPrnReg(nAvance,nNroCol,cTxtPrn,bPagina,;
		   bDerAut,bCabeza,nTotPag,@lPrnEnc)

       ENDIF
*>>>>FIN IMPRESION CON FORMATO DE IMPRESORA

*>>>>IMPRESION A FORMATO DE ARCHIVO ESPECIAL
       DO CASE
       CASE nOpcPrn == 6 .AND. '.XLS' $ UPPER(FilePrn)	 // Por Archivo Xls
	    RgExcelXml(FilePrn,nHandle,aRegPrn,aTitPrn)

       CASE nOpcPrn == 7                    // Por Archivo Dbf
	    GraFrmPrn(lShared,aRegPrn,nOpcPrn)

       CASE nOpcPrn == 8                    // Por Archivo Csv
	    SaveRegCsv(FilePrn,nHandle,aRegPrn)

/*
       CASE nOpcPrn == 8                    // Por Archivo Xml
	    SaveRegXml(FilePrn,nHandle,aRegPrn,aTitPrn)
*/


       ENDCASE
       SET DEVICE TO SCREEN
       RETURN .T.
*>>>>FIN IMPRESION A FORMATO DE ARCHIVO ESPECIAL

/*************************************************************************
* TITULO..: IMPRESION DE UN REGISTRO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/2004 MIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   ABR 07/2004 VIE

OBJETIVOS:

1- Imprime el texto de acuerdo a la opci¢n de impresi¢n sin salto de
   pagina.

2- Esta funcion es igual a lPrnOpc

3- Retorna .T. si debe haber cambio de p gina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnRegFrm(lShared,nOpcPrn,FilePrn,nHandle,nAvance,nNroCol,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza,;
		    cTxtPrn,nTotPag,lPrnEnc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nOpcPrn                              // Opci¢n de Impresi¢n
       FilePrn                              // Archivo de Impresion
       nHandle                              // Manejador de Archivo
       nAvance                              // N£mero avances de l¡neas
       nNroCol                              // N£mero de columna
       aTitPrn			            // T¡tulos de Impresi¢n
       aRegPrn			            // Registros de Impresi¢n
       aNroCol                              // N£meros de Columnas
       bPagina                              // Funci¢n control de impresi¢n
       bDerAut                              // Funci¢n impresi¢n de derechos
       bCabeza                              // Funci¢n impresi¢n Encabezado
       cTxtPrn                              // Texto de Impresi¢n
       nTotPag                              // Total de P ginas
       lPrnEnc                              // .@T. Imprimir Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>IMPRESION CON FORMATO DE IMPRESORA
       SET DEVICE TO PRINT
       IF nOpcPrn < 7 .AND. !('.XLS' $ UPPER(FilePrn))

	   IF cTxtPrn == NIL
	      cTxtPrn := cRegPrint(aRegPrn,aNroCol)
	   ENDIF
	   lPrnRegi(nAvance,nNroCol,cTxtPrn,bPagina,;
		   bDerAut,bCabeza,nTotPag,@lPrnEnc)

       ENDIF
*>>>>FIN IMPRESION CON FORMATO DE IMPRESORA

*>>>>IMPRESION A FORMATO DE ARCHIVO ESPECIAL
       DO CASE
       CASE nOpcPrn == 6 .AND. '.XLS' $ UPPER(FilePrn)	 // Por Archivo Xls
	    RgExcelXml(FilePrn,nHandle,aRegPrn,aTitPrn)

       CASE nOpcPrn == 7                    // Por Archivo Dbf
	    GraFrmPrn(lShared,aRegPrn,nOpcPrn)

       CASE nOpcPrn == 8                    // Por Archivo Cvs
	    SaveRegCsv(FilePrn,nHandle,aRegPrn)

/*
       CASE nOpcPrn == 8                    // Por Archivo Xml
	    SaveRegXml(FilePrn,nHandle,aRegPrn,aTitPrn)
*/

       ENDCASE
       SET DEVICE TO SCREEN
       RETURN .T.
*>>>>FIN IMPRESION A FORMATO DE ARCHIVO ESPECIAL

/*************************************************************************
* TITULO DE LA FUNCION..: NUMERO DE COLUMNA DEL TEXTO                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 15/96 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUL 15/96 LUN

OBJETIVOS:

1- Calcula la columna especificada del texto impreso

2- Retorna la columna a imprimir

SINTAXIS:

   @ PROW(),nColTxt(aNroCol,11) SAY REPL('-',aNroCol[11])

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nColTxt(aNroCol,nNroCol)

*>>>>DECLARACION DE PARAMETROS
/*     aNroCol                              // N£meros de columnas del inf
       nNroCol                              // N£mero de la columna */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nPosIni := 0                   // Posici¢n inicial
       LOCAL nNroLen := 0                   // Longitud de la columna
       LOCAL nColTxt := 0                   // Columna del Texto
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos del informe
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DEL VECTOR DE TITULOS
       FOR i := 1 TO LEN(aNroCol)
	   AADD(aTitulo,SPACE(aNroCol[i]))
       NEXT
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
*>>>>FIN INICIALIZACION DEL VECTOR DE TITULOS

*>>>>CALCULO DE LA COLUMNA DEL TEXTO
       FOR i := 1 TO nNroCol
	   nPosIni := AT('|',cTxtPrn)
	   nNroLen := IF(nNroCol < 10,1,2)
	   cTxtPrn = STUFF(cTxtPrn,nPosIni,nNroLen,STR(i,nNroLen))
       NEXT
       nColTxt := AT(STR(nNroCol,nNroLen),cTxtPrn)

       RETURN nColTxt
*>>>>FIN CALCULO DE LA COLUMNA DEL TEXTO

/*************************************************************************
* TITULO DE LA FUNCION..: ANALISIS DEL CAMBIO DE PAGINA                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/95 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   OCT 10/95 MAR

OBJETIVOS:

1)- Analiza si el pr¢ximo registro a imprimir requiere cambio de p gina

3)- Retorna .T. si hay cambio de p gina

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPagina(nLinReg,lOficio,nLenPag)

*>>>>PARAMETROS DE LA FUNCION
/*     nLinReg			            // L¡neas por registro
       lOficio                              // .F. Tama¤o Carta
       nLenPag                              // @l¡neas por p gina */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LINEAS POR PAGINA POR IMPRESORA
       lOficio := IF(lOficio==NIL,.F.,lOficio)
       nLenPag := IF(nLenPag==NIL,0,nLenPag)
       IF ALIAS(SELECT('PRN')) == 'PRN'

	  IF lOficio
	     nLenPag := PCL('nLinOfi')
	  ELSE
	     nLenPag := PCL('nLinCar')
	  ENDIF

       ENDIF
*>>>>FIN LINEAS POR PAGINA POR IMPRESORA

*>>>>LINEAS POR PAGANA POR DEFECTO
       IF lOficio
	  nLenPag := IF(nLenPag == 0,70,nLenPag)  // Tama¤o Oficio
       ELSE
	  nLenPag := IF(nLenPag == 0,58,nLenPag)  // Tama¤o Carta
       ENDIF
*>>>>FIN LINEAS POR PAGANA POR DEFECTO

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       nLinReg := IF(nLinReg == NIL,0,nLinReg)
       IF PROW() > (nLenPag - nLinReg)
	  lPagina := .T.
       ELSE
	  lPagina := .F.
       ENDIF
       RETURN lPagina
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA

/*************************************************************************
* TITULO DE LA FUNCION..: ENCABEZADO COMPLETO                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 12/95 SAB A
       Colombia, Bucaramanga        INICIO: 11:02 PM   AGO 12/95 SAB

OBJETIVOS:

1)- Imprime el encabezado completo incluyendo los encabezados de
    columna.

3)- Retorna Nil

SINTAXIS:

  cCodIni := DRAFT_ON+CONDEN_ON
  cCodFin := NEGRA_OF+DOBGOL_OF
  CabezaPrn(cCodIni,aCabeza,cCabCol,nColPrn,cCodFin)

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabezaPrn(cCodIni,aCabPri,xCabCol,nColPrn,cCodFin,aCabSec,;
		   cFecPrn,cHorPrn,cDiaPrn,cCodIso,cFecIso,cVerIso,;
		   aInfIso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodIni                              // C¢digos de impresora iniciales
       aCabPri			            // Encabezado Principal
       xCabCol			            // Encabezados de columna
       nColPrn                              // Columna de impresi¢n
       cCodFin                              // C¢digos de impresora finales
       aCabSec                              // Encabezado Secundario
       cFecPrn                              // @Fecha de Impresi¢n
       cHorPrn                              // @Hora de Impresi¢n
       cDiaPrn                              // @D¡a de Impresi¢n
       cCodIso                              // C¢digo Iso del Informe
       cFecIso                              // Fecha del Iso
       cVerIso                              // Versi¢n del Iso
       aInfIso                              // Informe Iso */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPag := 0                   // N£mero de p gina
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
*>>>>FINDECLARACION DE VARIABLES

*>>>>DETALLES DEL INFORME ISO
       IF aInfIso == NIL

	  aMarInf := {}
	  AADD(aMarInf,{0,0}) // MS:ID
	  AADD(aMarInf,{0,0}) // MI:ID
	  AADD(aMarInf,{0,0}) // M1:ID
	  AADD(aMarInf,{0,0}) // M2:ID
	*ÀLineas de Espaciado

	  aInfIso := {}
	  AADD(aInfIso,{'cLogEmp',''})      // Logo de la Empresa
	  AADD(aInfIso,{'nCabIso',0})       // Encabezado Iso
	  AADD(aInfIso,{'aMarInf',aMarInf}) // Encabezado Iso

       ENDIF
*>>>>FIN DETALLES DEL INFORME ISO

*>>>>ENCABEZADO PRINCIPAL
       SET DEVICE TO PRINT
       nNroPag := aCabPri[6]
       aCabPri[6] := IF(nNroPag==NIL,NIL,++nNroPag)
     *ÀIncremento del n£mero de p ginas

       EncabezPrn(aCabPri[1],;
		  aCabPri[2],;
		  aCabPri[3],;
		  aCabPri[4],;
		  aCabPri[5],;
		  aCabPri[6],;
		  aCabPri[7],;
		  aCabPri[8],;
		  @cFecPrn,@cHorPrn,@cDiaPrn,;
		  cCodIso,cFecIso,cVerIso,;
		  aInfIso)
*>>>>FIN ENCABEZADO PRINCIPAL

*>>>>ENCABEZADO SECUNDARIO
       IF !EMPTY(aCabSec)
	  @ PROW()+2,nColPrn SAY aCabSec[1]
	  FOR i := 2 TO LEN(aCabSec)
	     @ PROW()+1,nColPrn SAY aCabSec[i]
	  ENDFOR
       ENDIF
*>>>>ENCABEZADO SECUNDARIO

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       @ PROW(),01 SAY cCodIni
       IF VALTYPE(xCabCol) == 'C'
	  @ PROW()+1,nColPrn SAY REPL('-',LEN(xCabCol))
	  @ PROW()+1,nColPrn SAY xCabCol
	  @ PROW()+1,nColPrn SAY REPL('-',LEN(xCabCol))
       ELSE
	  @ PROW()+1,nColPrn SAY REPL('-',LEN(xCabCol[1]))
	  FOR i := 1 TO LEN(xCabCol)
	      @ PROW()+1,nColPrn SAY xCabCol[i]
	  ENDFOR
	  @ PROW()+1,nColPrn SAY REPL('-',LEN(xCabCol[1]))
       ENDIF
       @ PROW(),00 SAY cCodFin
       RETURN NIL
*>>>>FIN IMPRESION DEL ENCABEZADO DE COLUMNA

/*************************************************************************
* TITULO DE LA FUNCION..: COLUMNA DEL CENTRO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/95 VIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   OCT 20/95 VIE

OBJETIVOS:

1)- Calcula la columna para centrar texto entre columnas

2)- Retorna la columna

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nColCen(cMsgTxt,nColIni,nColFin)

*>>>>PARAMETROS DE LA FUNCION
/*     cMsgTxt                              // Texto a centrar
       cColIni                              // Columna Inicial a Centrar
       nColFin                              // Columna Inicial a Centrar */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenTxt := 0                   // Longitud del texto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS PARAMETROS
       nLenTxt := LEN(cMsgTxt)
       nColIni := IF(nColIni == NIL,0,nColIni)        // Defecto Columna 0
       nColFin := IF(nColFin == NIL,MAXCOL(),nColFin) // Defecto Columna 79
*>>>>FIN ANALISIS DE LOS PARAMETROS

*>>>>CALCULO DE LA COLUMNA DEL CENTRO
       nLenTxt := MIN(nLenTxt,(nColFin-nColIni))

       RETURN nColIni+ROUND((nColFin-nColIni-nLenTxt)/2,0)
*>>>>FIN CALCULO DE LA COLUMNA DEL CENTRO


/*************************************************************************
* TITULO DE LA FUNCION..: COLUMNA DEL RECIBO DE IMPRESION                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/95 VIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   OCT 20/95 VIE

OBJETIVOS:

1)- Calcula la columna inicial del recibo o la columa donde debe ir
    el texto centrado de acuerdo al n£mero de recibo.

2)- Si no se pasa texto para centrar solo se calcula la columna inicial
    del recibo.

3)- Retorna la columna

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nColRec(nNroRec,cMsgTxt,lPapSta,lConden)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroRec                              // N£mero del recibo
       cMsgTxt                              // Texto a centrar
       lPapSta                              // .T. Papel Estandar
       lConden                              // .T. Condensado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nColIni := 0                   // Columna inicial
       LOCAL nColFin := 0                   // Columna final
       LOCAL nColCen := 0                   // Colunna del centro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE PARAMETROS
       lPapSta := IF(lPapSta == NIL,.T.,lPapSta)
       lConden := IF(lConden == NIL,.T.,lConden)
*>>>>FIN VALIDACION DE PARAMETROS

*>>>>COLUMNAS INICIALES
       DO CASE
       CASE !lPapSta
	    nColIni := IF(lConden,;
			  VAL(SUBS('003058113',nNroRec*3-2,3)),;
			  VAL(SUBS('001033065',nNroRec*3-2,3)))

       CASE lPapSta
	    nColIni := IF(lConden,;
			  VAL(SUBS('0375',nNroRec*2-1,2)),;
			  VAL(SUBS('0244',nNroRec*2-1,2)))
       ENDCASE
       nColCen := nColIni
*>>>>FIN COLUMNAS INICIALES

*>>>>COLUMNAS FINALES
       DO CASE
       CASE !lPapSta .AND. cMsgTxt # NIL

	    nColFin := IF(lConden,;
			  VAL(SUBS('053108163',nNroRec*3-2,3)),;
			  VAL(SUBS('031063095',nNroRec*3-2,3)))

	    nColCen := nColCen(cMsgTxt,nColIni,nColFin)

       CASE lPapSta .AND. cMsgTxt # NIL

	    nColFin := IF(lConden,;
			  VAL(SUBS('068140',nNroRec*3-2,3)),;
			  VAL(SUBS('040082',nNroRec*3-2,3)))
	    nColCen := nColCen(cMsgTxt,nColIni,nColFin)

       ENDCASE
       RETURN nColCen
*>>>>FIN COLUMNAS FINALES


/*************************************************************************
* TITULO DE LA FUNCION..: LONGITUD TOTAL DEL RECIBO DE FACTURACION       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 24/95 MAR A
       Colombia, Bucaramanga        INICIO: 12:35 PM   OCT 24/95 MAR

OBJETIVOS:

1)- Calcula la columna inicial del recibo o la columa donde debe ir
    el texto centrado de acuerdo al n£mero de recibo.

2)- Si no se pasa texto para centrar solo se calcula la columna inicial
    del recibo.

3)- Retorna la columna

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nLenRec(lPapSta,lConden)

*>>>>PARAMETROS DE LA FUNCION
/*     lPapSta                              // .T. Papel Estandar
       lConden                              // .T. Condensado */
*>>>>PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenRec := 0                   // Longitud del recibo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LA LONGITUD EN LINEAS DEL RECIBO
       DO CASE
       CASE !lPapSta .AND. lConden
	    nLenRec := 50

       CASE !lPapSta .AND. !lConden
	    nLenRec := 30

       CASE lPapSta .AND. lConden
	    nLenRec := 65

       CASE lPapSta .AND. !lConden
	    nLenRec := 38
       ENDCASE
       RETURN nLenRec
*>>>>FIN ANALISIS DE LA LONGITUD EN LINEAS DEL RECIBO

/*************************************************************************
* TITULO DE LA FUNCION..: ENVIO DE CODIGOS DE CONTROL                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 13/96 MIE A
       Colombia, Bucaramanga        INICIO: 12:35 PM   NOV 13/96 MIE

OBJETIVOS:

1- Envia la secuencia de caracteres de control a la impresora evitando
   los problemas de alineaci¢n con la orden SETPRC()

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION SendCodes(cCodigo)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodigo                              // C¢digo Control para impresora */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // N£mero de fila
       LOCAL nNroCol := 0                   // N£mero de Columna
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ENVIO DEL CODIGO A LA IMPRESORA
       SET DEVICE TO PRINT
       nNroFil := PROW()
       nNroCol := PCOL()
       @ nNroFil,nNroCol SAY cCodigo
       SETPRC(nNroFil,nNroCol)
       RETURN ''
*>>>>FIN ENVIO DEL CODIGO A LA IMPRESORA

/*************************************************************************
* TITULO DE LA FUNCION..: ACTIVACION DEL TIPO DE IMPRESION               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/97 MIE A
       Colombia, Bucaramanga        INICIO: 12:40 PM   MAY 07/97 MIE

OBJETIVOS:

1- Activa el tipo de impresi¢n en red o local.

2- Permite redirigir la impresi¢n a una cola selecionada.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActivaPrn(lShared,cNomSis,PathSis,FileCfg,;
		   cCamPrn,cExtCam,cSiorNo,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       PathSis                              // Path del Sistema
       FileCfg			            // Archivo Configuraci¢n Sistema
       cCamPrn                              // Campo de Cola de Impresi¢n
       cExtCam                              // Extensi¢n del campo
       cSiorNo                              // Mensaje de Activaci¢n
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavLin := ''                  // Salvar L¡nea
       LOCAL     i,j := 0                   // Contadores
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cColact := ''                  // Cola de Impresi¢n Activa
       LOCAL lModCol := ''                  // .T. Modificaci¢n de Colas
       LOCAL cColas  := ''                  // Colas Configuradas
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LA RED
       IF !lShared
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE LA RED

*>>>>SELECION DE LAS AREAS DE TRABAJO
       nModCry := IF(nModCry==NIL,0,nModCry)
       IF !lUseDbf(.T.,PathSis+'\'+FileCfg,'CFG',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('CFG',PathSis+'\'+FileCfg,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CFG->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA CONFIGURACION GENERAL DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('CFG',PathSis+'\'+FileCfg,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE LA EXISTENCIA DE COLAS
       lModCol := CFG->&('lModCol'+cExtCam)
       IF lModCol
	  FOR i:= 1 TO 2
	      cColas := 'cCola'+PADL(i,2,'0')+cExtCam
	      IF !EMPTY(CFG->&cColas)
		 j++
	      ENDIF
	  NEXT
	  IF j <= 1
	     lModCol := .F.
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DE LA EXISTENCIA DE COLAS

*>>>>ACTIVACION DE LA MODIFICACION DE LAS COLAS
       IF lModCol
	  SETKEY(K_F2,{||CambiarCola(cNomSis,cExtCam,@cColact,cSavLin)})
       ENDIF
*>>>>FIN ACTIVACION DE LA MODIFICACION DE LAS COLAS

*>>>>ACTIVACION DE LA COLA DE IMPRESION
       IF VAL(CFG->&cCamPrn) == 0 .OR. VAL(CFG->&cCamPrn) > 10
	  cColact := 'cCola01'+cExtCam
       ELSE
	  cColact := 'cCola'+CFG->&cCamPrn+cExtCam
       ENDIF
*>>>>FIN ACTIVACION DE LA COLA DE IMPRESION

*>>>>IMPRESION DE LA LINEA DE ESTADO
       LineaEstado('COLA DE IMPRESION EN RED ACTIVADA: '+;
		   IF(EMPTY(ALLTRIM(CFG->&cColact)),'POR DEFECTO',;
			    ALLTRIM(CFG->&cColact))+;
		   IF(lModCol,'º<F2>CAMBIAR COLA',''),cNomSis)
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

*>>>>ACTIVACION DEL TIPO DE IMPRESION
       cSavLin := SAVESCREEN(22,0,22,79)
       cSiorNo := IF(EMPTY(cSiorNo),'No Si',cSiorNo)
       IF lPregunta('DESEA IMPRIMIR EN RED? '+cSiorNo)
	  NNETSETQ(1,ALLTRIM(CFG->&cColact))
	  NNETCAPBEG(1)
       ELSE
	  NNETCAPEND(1)
       ENDIF
*>>>>FIN ACTIVACION DEL TIPO DE IMPRESION

*>>>>DESACTIVACION DE LA MODIFICACION DE LAS COLAS
       IF lModCol
	  SETKEY(K_F2,NIL)
       ENDIF
       CloseDbf('CFG',PathSis+'\'+FileCfg,nModCry)
       SET FIXED ON
       RETURN NIL
*>>>>FIN DESACTIVACION DE LA MODIFICACION DE LAS COLAS

/*************************************************************************
* TITULO DE LA FUNCION..: CAMBIO DE LA COLA DE IMPRESION                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/97 MIE A
       Colombia, Bucaramanga        INICIO: 02:45 PM   MAY 07/97 MIE

OBJETIVOS:

1- Debe estar en uso el archivo de Configuraci¢n del sistema.

2- Permite al usuario cambiar la cola de impresi¢n para redirigir la salida

3- Retorna el N£mero de la cola selecionada

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CambiarCola(cNomSis,cExtCam,cColact,cSavLin)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomSis                              // Nombre del Sistema
       cExtCam                              // Extensi¢n del campo
       cColact                              // @Cola Actual
       cSavLin                              // Salvar l¡nea */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL     i,j := 0                   // Contadores
       LOCAL aMenus  := {}                  // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                  // Declaraci¢n de Ayudas
       LOCAL cColas  := ''                  // Colas Configuradas
       LOCAL nNroOpc := 1                   // Opci¢n escogida
       SET FIXED OFF
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LAS COLAS CONFIGURADAS
       cSavPan := SAVESCREEN(00,0,22,79)

       FOR i:= 1 TO 2
	   cColas := 'cCola'+PADL(i,2,'0')+cExtCam
	   IF !EMPTY(CFG->&cColas)
	      j++
	      AADD(aMenus,j)
	      AADD(aAyuda,j)
	      aMenus[j] := CFG->&cColas
	      aAyuda[j] := 'COLA DE IMPRESION. '+ALLTRIM(CFG->&cColas)
	   ENDIF
       NEXT

       RESTSCREEN(22,0,22,79,cSavLin)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'POR FAVOR ELIJA',NIL,nNroOpc)
       IF nNroOpc == 0
	  RESTSCREEN(0,0,22,79,cSavPan)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LAS COLAS CONFIGURADAS

*>>>>IMPRESION DE LA LINEA DE ESTADO
       cColact := 'cCola'+PADL(nNroOpc,2,'0')+cExtCam
      *Activaci¢n de la cola de impresi¢n

       LineaEstado('COLA DE IMPRESION EN RED ACTIVADA: '+;
		   ALLTRIM(CFG->&cColact)+'º<F2>HOLA CAMBIAR COLA',cNomSis)

       RESTSCREEN(0,0,22,79,cSavPan)
       SET FIXED ON
       RETURN NIL
*>>>>FIN IMPRESION DE LA LINEA DE ESTADO

/*************************************************************************
* TITULO DEL PROGRAMA..: CONVERSION DE LA HORA                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 30/97 MIE A
       Colombia, Bucaramanga        INICIO: 02:05 PM   JUL 30/97 MIE

OBJETIVOS:

1- Convierte la hora internacional en formato texto documentado

2- Retorna la hora

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cHora(cHora)

*>>>>PARAMETROS DE LA FUNCION
/*     cHora			            // Hora especificada */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nHora			// Hora del sistema
       LOCAL cAMorPM                        // Meridiano AM o PM
*>>>>FIN DECLARACION DE VARIABLES

*>>>>HORA DEL SISTEMA
       nHora = IF(cHora == NIL,VAL(SUBS(TIME(),1,2)),VAL(SUBS(cHora,1,2)))
       IF nHora > 12
	  nHora = nHora - 12
	  cAMorPM = ' PM'
       ELSE
	  cAMorPM = ' AM'
       ENDIF
       nHora = IIF(nHora < 10 , STR(nHora,2) , STR(nHora,2))
       RETURN nHora+IF(cHora==NIL,SUBS(TIME(),3,3),SUBS(cHora,3,3))+cAMorPM
*>>>>FIN HORA DEL SISTEMA

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE FIRMAS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AMY 07/96 MAR

OBJETIVOS:

1)- Imprime en la fila indicada los nombres de una o dos personas
    con sus cargos y cedula para la firma.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Firmas(nLenPrn,nNroLin,aFirmas,lCentra,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nLenPrn                              // Longitud de impresi¢n
       nNroLin                              // Lineas para avance
       aFirmas                              // Detalles para las firmas
       lCentra                              // .T. Centrar las firmas
       nNroCol                              // N£mero de Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nLenFir := 51                  // Longitud de la Firma
       LOCAL nSpaces := 15                  // Espacios entre firmas
       LOCAL cTxtPrn := ''                  // Texto para impresi¢n
       LOCAL nColUno := 0                   // Columna primera firma
       LOCAL nColDos := 0                   // Columna segunda firma
       LOCAL lFirmas := .F.                 // .T. Existen dos firmantes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS FIRMANTES
       lFirmas := .F.
       IF LEN(aFirmas) > 1
	  lFirmas := .T.
       ENDIF
*>>>>FIN ANALISIS DE LOS FIRMANTES

*>>>>CALCULO DE LAS COLUMNAS DE IMPRESION
       lCentra := IF(lCentra == NIL,.T.,lCentra)
       IF lCentra
	  cTxtPrn := SPACE(nLenFir*2)+SPACE(nSpaces)
	  nColUno := (nLenPrn-LEN(cTxtPrn))/2
       ELSE
	  nColUno := IF(EMPTY(nNroCol),0,nNroCol)
       ENDIF
       nColDos := nColUno+nLenFir+nSpaces
*>>>>FIN CALCULO DE LAS COLUMNAS DE IMPRESION

*>>>>IMPRESION DE LAS LINEAS PARA LAS FIRMAS
       @ PROW()+nNroLin,nColUno SAY REPL('-',nLenFir)
     *ÀLinea primera firma

       IF lFirmas
	  @ PROW(),nColDos SAY REPL('-',nLenFir)
	*ÀLinea segunda firma
       ENDIF
*>>>>FIN IMPRESION DE LAS LINEAS PARA LAS FIRMAS

*>>>>IMPRESION DE LOS NOMBRES DE LOS FIRMANTES
       @ PROW()+1,nColUno SAY aFirmas[1,1]
     *ÀNombre primera firma

       @ PROW(),nColDos SAY aFirmas[2,1]
     *ÀNombre segunda firma
*>>>>FIN IMPRESION DE LOS NOMBRES DE LOS FIRMANTES

*>>>>IMPRESION DE LOS DOCUMENTOS DE LOS FIRMANTES
       IF !EMPTY(aFirmas[1,2])
	  @ PROW()+1,nColUno SAY 'C.C. No. '+aFirmas[1,2]
	*ÀDocumento primera firma

	  @ PROW(),nColDos SAY 'C.C. No. '+aFirmas[2,2]
	*ÀDocumento segunda firma
       ENDIF
*>>>>FIN IMPRESION DE LOS DOCUMENTOS DE LOS FIRMANTES

*>>>>IMPRESION DE LOS CARGOS DE LOS FIRMANTES
       @ PROW()+1,nColUno SAY aFirmas[1,3]
     *ÀCargo primer firma

       @ PROW(),nColDos SAY aFirmas[2,3]
     *ÀCargo segunda firma
       RETURN NIL
*>>>>FIN IMPRESION DE LOS CARGOS DE LOS FIRMANTES

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE FIRMAS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AMY 07/96 MAR

OBJETIVOS:

1)- Imprime en la fila indicada los nombres de una o dos personas
    con sus cargos y cedula para la firma.

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Firmas1(nLenPrn,nNroLin,aFirmas,lCentra,nLenFir,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     nLenPrn                              // Longitud de impresi¢n
       nNroLin                              // Lineas para avance
       aFirmas                              // Detalles para las firmas
       lCentra                              // .T. Centrar las firmas
       nLenFir                              // Longitud de la Firmas
       nNroCol                              // N£mero de la Columna 	*/
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nSpaces := 5                   // Espacios entre firmas
       LOCAL cTxtPrn := ''                  // Texto para impresi¢n
       LOCAL nColUno := 0                   // Columna primera firma
       LOCAL nColDos := 0                   // Columna segunda firma
       LOCAL lFirmas := .F.                 // .T. Existen dos firmantes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE LOS FIRMANTES
       lFirmas := .F.
       IF LEN(aFirmas) > 1
	  lFirmas := .T.
       ENDIF
*>>>>FIN ANALISIS DE LOS FIRMANTES

*>>>>CALCULO DE LAS COLUMNAS DE IMPRESION
       lCentra := IF(lCentra == NIL,.T.,lCentra)
       nLenFir := IF(nLenFir == NIL,51,nLenFir)
       nNroCol := IF(nNroCol == NIL,0,nNroCol)
       IF lCentra
	  cTxtPrn := SPACE(nLenFir*2)+SPACE(nSpaces)
	  nColUno := (nLenPrn-LEN(cTxtPrn))/2
       ELSE
	  nColUno := nNroCol
       ENDIF
       nColDos := nColUno+nLenFir+nSpaces
*>>>>FIN CALCULO DE LAS COLUMNAS DE IMPRESION

*>>>>IMPRESION DE LAS LINEAS PARA LAS FIRMAS
       @ PROW()+nNroLin,nColUno SAY REPL('-',nLenFir)
     *ÀLinea primera firma

       IF lFirmas
	  @ PROW(),nColDos SAY REPL('-',nLenFir)
	*ÀLinea segunda firma
       ENDIF
*>>>>FIN IMPRESION DE LAS LINEAS PARA LAS FIRMAS

*>>>>IMPRESION DE LOS NOMBRES DE LOS FIRMANTES
       @ PROW()+1,nColUno SAY aFirmas[1,1]
     *ÀNombre primera firma

       @ PROW(),nColDos SAY aFirmas[2,1]
     *ÀNombre segunda firma
*>>>>FIN IMPRESION DE LOS NOMBRES DE LOS FIRMANTES

*>>>>IMPRESION DE LOS DOCUMENTOS DE LOS FIRMANTES
       IF !EMPTY(aFirmas[1,2])
	  @ PROW()+1,nColUno SAY 'C.C. No. '+aFirmas[1,2]
	*ÀDocumento primera firma

	  @ PROW(),nColDos SAY 'C.C. No. '+aFirmas[2,2]
	*ÀDocumento segunda firma
       ENDIF
*>>>>FIN IMPRESION DE LOS DOCUMENTOS DE LOS FIRMANTES

*>>>>IMPRESION DE LOS CARGOS DE LOS FIRMANTES
       @ PROW()+1,nColUno SAY aFirmas[1,3]
     *ÀCargo primer firma

       @ PROW(),nColDos SAY aFirmas[2,3]
     *ÀCargo segunda firma
       RETURN NIL
*>>>>FIN IMPRESION DE LOS CARGOS DE LOS FIRMANTES

/*************************************************************************
* TITULO DE LA FUNCION..: OTRA PAGINA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 07/96 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   AMY 07/96 MAR

OBJETIVOS:

1)- Imprime el encabezado principal y el encabezado de columna.


2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION OtraPagina(cCodIni,cCodFin,aTitulo,aNroCol,bCabeza,nNroCol)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodIni                              // C¢digos de impresi¢n iniciales
       cCodFin                              // C¢digos de impresi¢n finales
       aNroCol                              // Columnas de los titulos
       aTitulo                              // T¡tulos para el informe
       bCabeza                              // Block de Encabezado
       nNroCol                              // N£mero de Columna */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cTxtPrn := ''                  // Texto de impresion
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL ENCABEZADO
       IF !EMPTY(bCabeza)
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       nNroCol := IF(EMPTY(nNroCol),0,nNroCol)
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       @ PROW(),00 SAY cCodIni

       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))
       @ PROW()+1,nNroCol SAY cTxtPrn
       @ PROW()+1,nNroCol SAY REPL('-',LEN(cTxtPrn))

       @ PROW()  ,00 SAY cCodFin
       RETURN NIL
*>>>>FIN IMPRESION DEL ENCABEZADO DE COLUMNA

/*************************************************************************
* TITULO..: DIVISION DE LINEAS                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 07/2000 VIE A
       Colombia, Bucaramanga        INICIO: 04:45 PM   ABR 07/2000 VIE

OBJETIVOS:

1)- Divide un texto en las diferentes l¡neas de acuerdo a la longitud
    especificada.

2)- Retorna un vector con cada una de las l¡neas.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aDivLin(cTxtPrn,nLenLin)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTxtPrn                              // Texto a Dividir
       nLenLin                              // Longitud de las l¡neas. */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL aNroLin := {}                  // Vector de l¡neas
       LOCAL cLinTxt := ''                  // L¡nea de Texto
       LOCAL nNroPos := 1                   // N£mero de posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SEPARACION DEL TEXTO EN LINEAS
       DO WHILE .T.

**********ANALISIS DEL FINAL
	    cLinTxt := ''
	    IF LEN(cTxtPrn) <= nLenLin
	       cLinTxt := cTxtPrn
	       AADD(aNroLin,cLinTxt)
	       EXIT
	    ENDIF
**********FIN ANALISIS DEL FINAL

**********CREACION DE LA LINEA DE TEXTO
	    cLinTxt := SUBS(cTxtPrn,1,nLenLin)
	    nNroPos := RAT(' ',cLinTxt)

	    IF nNroPos < nLenLin
	       cLinTxt := SUBS(cLinTxt,1,nNroPos)
	    ENDIF
**********FIN CREACION DE LA LINEA DE TEXTO

**********TRUNCAMIENTO DEL TEXTO
	    IF LEN(cTxtPrn) > nNroPos
	       cTxtPrn := SUBS(cTxtPrn,nNroPos+1)
	    ELSE
	       cTxtPrn := SUBS(cTxtPrn,nNroPos)
	    ENDIF
**********FIN TRUNCAMIENTO DEL TEXTO

**********GRABACION DE LA LINEA EN EL VECTOR
	    IF .NOT. EMPTY(cLinTxt)
	      AADD(aNroLin,cLinTxt)
	    ENDIF
**********FIN GRABACION DE LA LINEA EN EL VECTOR

       ENDDO
       RETURN aNroLin
*>>>>FIN SEPARACION DEL TEXTO EN LINEAS

/*************************************************************************
* TITULO..: CAMPO DE IMPRESION                                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/2001 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   ENE 30/2001 MAR

OBJETIVOS:

1)- Calcula los espacios para la impresion de un campo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cCamPrn(cCampo,nLenCam)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCampo                               // Texto a Dividir
       nLenCam                              // Longitud del Campo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>CALCULO DEL CAMPO
       RETURN SUBS(ALLTRIM(cCampo)+SPACE(nLenCam),1,nLenCam)
*>>>>FIN CALCULO DEL CAMPO

/*************************************************************************
* TITULO..: MEMSAJE DE ERROR EN IMPRESION                                *
**************************************************************************

*OBJETIVOS DE LA FUNCION:

  1- Visualiza un marco con un mensaje de advertencia para el usuario

  2- Retorna  : El caracter que presion¢ el usuario en may£sculas

* SINTAXIS:

  ctecPul := cError('prueba de error')


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cErrorPrn(cMsgErr,cTitMar,cPieMar)

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
       SET DEVICE TO SCREEN
       centrar(cTitMar,nFilSup+1,nColSup+1,nColInf-1) // Titulo
       centrar(cMsgErr,nFilSup+3,nColSup+1,nColInf-1) // Mensaje
       centrar(cPieMar,nFilSup+5,nColSup+1,nColInf-1) // Pie
       SET DEVICE TO PRINT
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