/*                              SIMASOFT
		 SISTEMAS INSTEGRADOS MULTIUSUARIOS AVANZADOS
		     BIBLIOTECA PARA EL ARCHIVO INFORMES ISO

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: ENCABEZADO DEL INFORME ISO.                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 12/2008 VIE A
       Colombia, Bucaramanga        INICIO: 09:00 AM   AGO 12/2008 VIE

OBJETIVOS:

1- Permite imprimir diferentes encabezados para los informes para que
   sean adaptados a los encabezados de Iso.

2- Imprime los encabezados de columna.

3- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabPrnIso(aP1,aP2,aP3,;
		   aDetInf,cFecPrn,cHorPrn,cDiaPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       cFecPrn                              // @Fecha de Impresi¢n
       cHorPrn                              // @Hora de Impresi¢n
       cDiaPrn                              // @D¡a de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL xIniPrm := NIL                 // Inicializaci¢n del Parametro
       LOCAL nCabIso := 0                   // Encabezado Iso
       LOCAL nNroPag := 0                   // N£mero de P gina.
*>>>>FINDECLARACION DE VARIABLES

*>>>>NUMERO DE PAGINA
       nNroPag := xPrm(aDetInf,'nNroPag')           // N£mero de p gina
       nNroPag := IF(nNroPag==NIL,NIL,++nNroPag)
       nParameSet(aDetInf,'nNroPag',nNroPag)
*>>>>FIN NUMERO DE PAGINA

*>>>>ENCABEZADOS DE LOS INFORMES
       xIniPrm := 0
       nCabIso := xPrm(aDetInf,'nCabIso',xIniPrm)   // Encabezado Iso

       DO CASE
       CASE nCabIso == 00
	    CabIso000(aP1,aP2,aP3,;
		      aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)
	  *ÀEncabezado por defecto

       CASE nCabIso == 99
	    CabIso099(aP1,aP2,aP3,;
		      aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)
	  *ÀEncabezado ColSalle Bogot 

       OTHERWISE
	    CabIso000(aP1,aP2,aP3,;
		      aDetInf,@cFecPrn,@cHorPrn,@cDiaPrn)
	  *ÀEncabezado por defecto
       ENDCASE
       RETURN NIL
*>>>>FIN ENCABEZADOS DE LOS INFORMES

/*************************************************************************
* TITULO..: ENCABEZADO No. 00                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2008 JUE A
       Colombia, Bucaramanga        INICIO: 11:15 AM   AGO 14/2008 JUE

OBJETIVOS:

1- Este encabezado es el por defecto del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabIso000(aP1,aP2,aP3,;
		   aDetInf,cFecPrn,cHorPrn,cDiaPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       cFecPrn                              // @Fecha de Impresi¢n
       cHorPrn                              // @Hora de Impresi¢n
       cDiaPrn                              // @D¡a de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE PARAMETROS
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL lTamAnc := xPrm(aDetInf,'lTamAnc') // .T. Tama¤o ancho
       LOCAL nColPrn := xPrm(aDetInf,'nColPrn') // Columna de impresi¢n

       LOCAL aTitIso := xPrm(aDetInf,'aTitIso') // T¡tulos del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso') // C¢digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso') // Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso') // Versi¢n del Iso

       LOCAL nNroPag := xPrm(aDetInf,'nNroPag') // N£mero p gina a imprimir
       LOCAL cTotPag := xPrm(aDetInf,'cTotPag') // Total p ginas a imprimir

       LOCAL aCabSec := xPrm(aDetInf,'aCabSec') // Encabezado Secundario
       LOCAL cCodIni := xPrm(aDetInf,'cCodIni')	// C¢digos iniciales de impresi¢n
       LOCAL xCabCol :=	xPrm(aDetInf,'xCabCol')	// Encabezados de columna
       LOCAL cCodFin := xPrm(aDetInf,'cCodFin') // C¢digos de impresora finales
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nLenPrn := 0                   // Longitud de impresi¢n
       LOCAL nPosIso := 0                   // Posici¢n del Iso
       LOCAL cIsoTem := ''                  // C¢digo Iso
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       lTamAnc := IF(lTamAnc == NIL,.F.,lTamAnc)
       nLenPrn := IF(lTamAnc,136,80)
      *Calculo de la longitud de impresion

       DO CASE
       CASE LEN(cNomEmp) <= 40
	    nNroCol := ((nLenPrn/2)-LEN(cNomEmp))/2
	    cCodIni := PCL({'DobAncOn','NegraOn','DobGolOn'})
	    cCodFin := PCL({'DobAncOf','NegraOf','DobGolOf'})

       CASE LEN(cNomEmp) > 40 .AND. LEN(cNomEmp) <= 42
	    nNroCol = 0
	    cCodIni := PCL({'DobAncOn','NegraOn','DobGolOn'})
	    cCodFin := PCL({'DobAncOf','NegraOf','DobGolOf'})
       OTHERWISE
	    nNroCol := (nLenPrn-LEN(cNomEmp))/2
	    cCodIni := PCL({'DobAncOn','DobGolOn'})
	    cCodFin := PCL({'DobAncOf','DobGolOf'})
       ENDCASE

       @ PROW(),nNroCol SAY PCL({'GraphiOn','CondenOf',;
				 'ProporOf','Pica',;
				 'DraftOf','Roman'})

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
		     ALLTRIM(cVerIso)+SPACE(02)+;
		     ALLTRIM(cFecIso)
       ENDIF

       nNroCol = (nLenPrn-LEN(cNomSis))/2

       @ PROW()+1,nNroCol SAY PCL('ItalicOn')+;
			      UPPER(cNomSis)+;
			      PCL('ItalicOf')

       IF !EMPTY(cIsoTem)
	  nNroCol := IF(lTamAnc,nLenPrn-10,nLenPrn)
	  @ PROW(),nNroCol-10 SAY PCL('CondenOn')+;
				 cIsoTem+;
				 PCL('CondenOf')
       ENDIF
*>>>>FIN IMPRESION DEL NOMBRE DEL SISTEMA

*>>>>IMPRESION DEL TITULO UNO
       nNroCol = (nLenPrn-LEN(aTitIso[1]))/2

       @ PROW()+1,nNroCol SAY PCL('NegraOn')+aTitIso[1]+PCL('NegraOf')
*>>>>FIN IMPRESION DEL TITULO UNO

*>>>>IMPRESION DE LA FECHA, TITULO DOS, HORA
       IF nNroPag # NIL
	  cFecPrn := cFecha(DATE(),10)
	  @ PROW()+2,00 SAY cFecPrn
       ENDIF

       nNroCol = (nLenPrn-LEN(aTitIso[2]))/2
       @ PROW(),nNroCol SAY aTitIso[2]

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
       nNroCol = (nLenPrn-LEN(aTitIso[3]))/2
       @ PROW(), nNroCol SAY aTitIso[3]

       IF nNroPag # NIL
	  @ PROW(), nLenPrn-14 SAY 'P gina No.'+LTRIM(STR(nNroPag))+;
				   IF(cTotPag==NIL,'','/'+cTotPag)
       ENDIF
*>>>>FIN IMPRESION DEL DIA DE LA SEMANA, TITULO TRES, TOTAL DE PAGINAS

*>>>>ENCABEZADO SECUNDARIO
       IF !EMPTY(aCabSec)
	  @ PROW()+2,nColPrn SAY aCabSec[1]
	  FOR i := 2 TO LEN(aCabSec)
	     @ PROW()+1,nColPrn SAY aCabSec[i]
	  ENDFOR
       ENDIF
*>>>>ENCABEZADO SECUNDARIO

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       cCodIni := xPrm(aDetInf,'cCodIni')
       cCodFin := xPrm(aDetInf,'cCodFin')

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
* TITULO..: ENCABEZADO No. 99                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2008 JUE A
       Colombia, Bucaramanga        INICIO: 11:15 AM   AGO 14/2008 JUE

OBJETIVOS:

1- Este encabezado es el por defecto del sistema

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CabIso099(aP1,aP2,aP3,;
		   aDetInf,cFecPrn,cHorPrn,cDiaPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aDetInf                              // Detalles del Informe
       cFecPrn                              // @Fecha de Impresi¢n
       cHorPrn                              // @Hora de Impresi¢n
       cDiaPrn                              // @D¡a de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE PARAMETROS
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL nOpcPrn := xPrm(aDetInf,'nOpcPrn') // Opci¢n de Impresi¢n
       LOCAL lTamAnc := xPrm(aDetInf,'lTamAnc') // .T. Tama¤o ancho
       LOCAL nColPrn := xPrm(aDetInf,'nColPrn') // Columna de impresi¢n

       LOCAL aMarInf := xPrm(aDetInf,'aMarInf') // Margenes del Informe
       LOCAL aTitIso := xPrm(aDetInf,'aTitIso') // T¡tulos del Informe
       LOCAL cCodIso := xPrm(aDetInf,'cCodIso') // C¢digo Iso del Informe
       LOCAL cFecIso := xPrm(aDetInf,'cFecIso') // Fecha del Iso
       LOCAL cVerIso := xPrm(aDetInf,'cVerIso') // Versi¢n del Iso

       LOCAL nNroPag := xPrm(aDetInf,'nNroPag') // N£mero p gina a imprimir
       LOCAL cTotPag := xPrm(aDetInf,'cTotPag') // Total p ginas a imprimir

       LOCAL aCabSec := xPrm(aDetInf,'aCabSec') // Encabezado Secundario
       LOCAL cCodIni := xPrm(aDetInf,'cCodIni')	// C¢digos iniciales de impresi¢n
       LOCAL xCabCol :=	xPrm(aDetInf,'xCabCol')	// Encabezados de columna
       LOCAL cCodFin := xPrm(aDetInf,'cCodFin') // C¢digos de impresora finales
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL cLinPrn := ''                  // L¡nea a Imprimir
       LOCAL nTotCol := 66                  // Total Columnas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LINEA DE ENCABEZADO
       SETPRC(0,0)

       SendCodes(PCL({'GraphiOn','CondenOf',;
		      'ProporOf','Pica','DraftOf','Roman'}))
     *ÀInicializaci¢n

       cTxtPrn := REPL('-',80)
       @ PROW(),00 SAY cTxtPrn
*>>>>FIN LINEA DE ENCABEZADO

*>>>>LOGO DE LA EMPRESA
       IF nOpcPrn # 1 .AND. nOpcPrn # 5
	  cLogEmp := ''
       ENDIF
       IF !EMPTY(cLogEmp)
/*
	  @ PROW()+1,00 SAY '"'+cLogEmp+'"'
	  @ PROW()+0,00 SAY SPACE(275)+'.'  // Borra el mensaje Demo
*/
	  nNroFil := 1
	  @ nNroFil,001 SAY '"'+cLogEmp+'"'
	  @ nNroFil,001 SAY '                                                                                                                                                                                                                                                                                   .'

       ENDIF
*>>>>FIN LOGO DE LA EMPRESA

*>>>>TITULO UNO DEL INFORME
       cTxtPrn := ALLTRIM(aTitIso[1])

       nNroCol := (80-LEN(cTxtPrn))/2

       cLinPrn := ''
       cLinPrn += SPACE(nNroCol)+cTxtPrn
*>>>>FIN TITULO UNO DEL INFORME

*>>>>CODIGO DEL DOCUMENTO
       IF !EMPTY(cCodIso)

	  nNroCol := nTotCol-LEN(cLinPrn)+aMarInf[3,1]

	  cLinPrn += SPACE(nNroCol)+PCL({'CondenOn'})+'C¢digo: '+cCodIso

	  @ PROW()+1,00 SAY cLinPrn
	  SendCodes(PCL('CondenOf'))
       ELSE
	  @ PROW()+1,00 SAY cLinPrn
       ENDIF
*>>>>FIN CODIGO DEL DOCUMENTO

*>>>>TITULO DOS DEL INFORME
       cTxtPrn := ALLTRIM(aTitIso[2])
       nNroCol := (80-LEN(cTxtPrn))/2

       cLinPrn := ''
       cLinPrn += SPACE(nNroCol)+cTxtPrn
*>>>>FIN TITULO DOS DEL INFORME

*>>>>VERSION DEL DOCUMENTO
       IF !EMPTY(cVerIso)

	  nNroCol := nTotCol-LEN(cLinPrn)+aMarInf[3,2]

	  cLinPrn += SPACE(nNroCol)+PCL({'CondenOn'})+'Versi¢n: '+cVerIso
	  @ PROW()+1,00 SAY cLinPrn

	  SendCodes(PCL('CondenOf'))

       ELSE
	  @ PROW()+1,00 SAY cLinPrn
       ENDIF
*>>>>FIN VERSION DEL DOCUMENTO

*>>>>TITULO TRES DEL INFORME
       cTxtPrn := ALLTRIM(aTitIso[3])
       nNroCol := (80-LEN(cTxtPrn))/2

       cLinPrn := ''
       cLinPrn += SPACE(nNroCol)+cTxtPrn
*>>>>FIN TITULO TRES DEL INFORME

*>>>>FECHA APROBACION DEL DOCUMENTO
       IF !EMPTY(cFecIso)

	  nNroCol := nTotCol-LEN(cLinPrn)+aMarInf[4,1]

	  cLinPrn += SPACE(nNroCol)+PCL({'CondenOn'})+'Fecha: '+cFecIso

	  @ PROW()+1,00 SAY cLinPrn

	  SendCodes(PCL('CondenOf'))
       ELSE
	  @ PROW()+1,00 SAY cLinPrn
       ENDIF
*>>>>FIN FECHA APROBACION DEL DOCUMENTO

*>>>>LINEA DEL ENCABEZADO
       cTxtPrn := REPL('-',80)
       @ PROW()+1,00 SAY cTxtPrn
*>>>>FIN LINEA DEL ENCABEZADO

*>>>>ENCABEZADO SECUNDARIO
       IF !EMPTY(aCabSec)
	  @ PROW()+2,nColPrn SAY aCabSec[1]
	  FOR i := 2 TO LEN(aCabSec)
	     @ PROW()+1,nColPrn SAY aCabSec[i]
	  ENDFOR
       ENDIF
*>>>>ENCABEZADO SECUNDARIO

*>>>>IMPRESION DEL ENCABEZADO DE COLUMNA
       cCodIni := xPrm(aDetInf,'cCodIni')
       cCodFin := xPrm(aDetInf,'cCodFin')

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