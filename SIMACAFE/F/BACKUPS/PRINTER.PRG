/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: ETIQUETAS - POR GRUPOS                   MODULO No. 311

**************************************************************************
* TITULO..: IMPRESION DE ETIQUETAS POR GRUPOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 24/2002 LUN A
       Colombia, Bucaramanga        INICIO: 12:00 AM   JUN 24/2002 LUN

OBJETIVOS:

1- Imprime las etiquetas por grupos para anexar a los carnets

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_311(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL cNombreTpr := ''               // Nombre de la materia
       CloseAll()                           // Cerrar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCaFAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimCaf,'CAF',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FCaFAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+;
			 'PROFES'+cAnoSis+'.DAT','PRO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DEL CONTENIDO
       IF PRO->(RECCOUNT()) == 0
	  cError('NO EXISTEN PROFESORES GRABADOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := PRO->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'PROFESORES A¥O:'+cAnoUsr+' JORNADA: '+cJorTxt,;
		   '',;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,08,52,16,20,22,12}
       aTitulo := {'No. ',;
		   'CODIGO',;
		   'NOMBRE',;
		   'CEDULA',;
		   'DE',;
		   'TELEFONOS',;
		   'OBSERVACION'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||cPagina(nLinReg)}
       bCabeza := {||Cabeza(cCodIni,aCabeza,cCabCol,;
			    nColCab,cCodFin,aCabSec)}
       bDerAut := {||Derechos(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>SELECION DEL TIPO DE IMPRESION
       IF lShared
	  NNETSETQ('COLA')
	  NNETCAPBEG(1)
	  IF !lPregunta('DESEA IMPRIMIR EN RED? Si No')
	     NNETCAPEND(1)
	  ENDIF
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DEL TIPO DE IMPRESION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY PCL({"Reset","Oficio"})
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT PRO
       GO TOP
       DO WHILE .NOT. PRO->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( PRO->(RECNO()) / PRO->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    cNombreTpr := RTRIM(PRO->cApelliPro)+' '+PRO->cNombrePro
	    cNombreTpr := SUBS(cNombreTpr+SPACE(52),1,52)
	    aTitulo := {STR(++i,4),;
			PRO->cCodigoOrg+PRO->cCodigoPro,;
			cNombreTpr,;
			PRO->cDocNitPro,;
			PRO->cLugNitPro,;
			ALLTRIM(PRO->cTelUnoPro)+'-'+;
			ALLTRIM(PRO->cTelDosPro),;
			SPACE(12)}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT PRO
	    PRO->(DBSKIP())
	    IF PRO->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       Derechos(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

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

FUNCTION Cabeza(cCodIni,aCabPri,cCabCol,nColPrn,cCodFin,aCabSec)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodIni                              // C¢digos de impresora iniciales
       aCabPri			            // Encabezado Principal
       cCabCol                              // Encabezados de columna
       nColPrn                              // Columna de impresi¢n
       cCodFin                              // C¢digos de impresora finales
       aCabSec                              // Encabezado Secundario */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPag := 0                   // N£mero de p gina
*>>>>FINDECLARACION DE VARIABLES

*>>>>ENCABEZADO PRINCIPAL
       nNroPag := aCabPri[6]
       aCabPri[6] := IF(nNroPag==NIL,NIL,++nNroPag)
     *ÀIncremento del n£mero de p ginas

       CabezaLpt(aCabPri[1],;
		  aCabPri[2],;
		  aCabPri[3],;
		  aCabPri[4],;
		  aCabPri[5],;
		  aCabPri[6],;
		  aCabPri[7],;
		  aCabPri[8])
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
       @ PROW()+1,nColPrn SAY REPL('-',LEN(cCabCol))
       @ PROW()+1,nColPrn SAY cCabCol
       @ PROW()+1,nColPrn SAY REPL('-',LEN(cCabCol))
       @ PROW(),00 SAY cCodFin
       RETURN NIL
*>>>>FIN IMPRESION DEL ENCABEZADO DE COLUMNA

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

FUNCTION CabezaLpt(cNomEmp,cNomSis,cTitUno,cTitDos,;
		   cTiTres,nNroPag,cTotPag,lTamAnc)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                                  // Nombre de la empresa
       cNomSis                                  // Nombre del sistema
       cTitUno                                  // Titulo uno del informe
       cTitDos                                  // Titulo dos del informe
       cTiTres                                  // Titulo tres del informe
       nNroPag                                  // N£mero p gina a imprimir
       cTotPag                                  // Total p ginas a imprimir
       lTamAnc                                 	// .T. Tama¤o ancho */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroCol := 0                           // N£mero de Columna
       LOCAL nLenPrn := 0                           // Longitud de impresi¢n
       LOCAL cCodIni := ''                          // C¢digos Iniciales de Impresi¢n
       LOCAL cCodFin := ''                          // C¢digos Finales de Impresi¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL NOMBRE DE LA EMPRESA
       lTamAnc := IF(lTamAnc == NIL,.F.,lTamAnc)
       nLenPrn := IF(lTamAnc,136,80)
      *Calculo de la longitud de impresion

       DO CASE
       CASE LEN(cNomEmp) <= 40
	    nNroCol := ((nLenPrn/2)-LEN(cNomEmp))/2
	    cCodIni := PCL({"DobAncOn","NegraOn","DobGolOn"})
	    cCodFin := PCL({"DobAncOf","NegraOf","DobGolOf"})

       CASE LEN(cNomEmp) > 40 .AND. LEN(cNomEmp) <= 42
	    nNroCol = 0
	    cCodIni := PCL({"DobAncOn","NegraOn","DobGolOn"})
	    cCodFin := PCL({"DobAncOf","NegraOf","DobGolOf"})

       OTHERWISE
	    nNroCol := (nLenPrn-LEN(cNomEmp))/2
	    cCodIni := PCL({"NegraOn","DobGolOn"})
	    cCodFin := PCL({"NegraOf","DobGolOf"})
       ENDCASE

       @ PROW(),nNroCol SAY PCL({"GraphiOn","CondenOf","ProporOf",;
				 "Pica","DraftOf","Roman"})

       @ PROW(),nNroCol SAY cCodIni
       @ PROW(),nNroCol SAY cNomEmp
       @ PROW(),nNroCol SAY cCodFin
*>>>>FIN IMPRESION DEL NOMBRE DE LA EMPRESA

*>>>>IMPRESION DEL NOMBRE DEL SISTEMA
       nNroCol = (nLenPrn-LEN(cNomSis))/2
       @ PROW()+1,nNroCol SAY PCL("ItalicOn")+UPPER(cNomSis)+PCL("ItalicOf")
*>>>>FIN IMPRESION DEL NOMBRE DEL SISTEMA

*>>>>IMPRESION DEL TITULO UNO
       nNroCol = (nLenPrn-LEN(cTitUno))/2
       @ PROW()+1,nNroCol SAY PCL("NegraOn")+cTitUno+PCL("NegraOf")
*>>>>FIN IMPRESION DEL TITULO UNO

*>>>>IMPRESION DE LA FECHA, TITULO DOS, HORA
       IF nNroPag # NIL
	  @ PROW()+2,00 SAY cFecha(DATE(),10)
       ENDIF

       nNroCol = (nLenPrn-LEN(cTitDos))/2
       @ PROW(),nNroCol SAY cTitDos

       IF nNroPag # NIL
	  @ PROW(),nLenPrn-13 SAY 'HORA '+cHoraSys()
       ENDIF
*>>>>FIN IMPRESION DE LA FECHA, TITULO DOS, HORA

*>>>>IMPRESION DEL DIA DE LA SEMANA, TITULO TRES, TOTAL DE PAGINAS
       IF nNroPag # NIL
	  @ PROW()+1,00 SAY cDia(DOW(DATE()),9)
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
* TITULO DEL PROGRAMA..: DERECHOS DE AUTOR POR IMPRESORA                 *
**************************************************************************

OBJETIVOS:

1- Imprime los derechos de autor por la impresora

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION Derechos(cNomSis,cNomEmp,nLenPrn,lOficio,lPiePag,nLinPrn)

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
	  @ PROW(),00 SAY PCL({"NegraOf","CondenOn","DobGolOn"})
	  @ PROW()+nLinPrn,nNroCol SAY cTxtPrn
	  @ PROW(),00 SAY PCL({"CondenOf","DobGolOf"})
       ENDIF
       RETURN NIL
*>>>>IMPRESION DE LOS DERECHOS DE AUTOR

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

FUNCTION cPagina(nLinReg)

*>>>>PARAMETROS DE LA FUNCION
/*     nLinReg			            // L¡neas por registro */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL lPagina := .T.                 // .T. Cambio de p gina
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS PARA EL CAMBIO DE PAGINA
       nLinReg := IF(nLinReg == NIL,0,nLinReg)
       IF PROW() > (70 - nLinReg)
	  lPagina := .T.
       ELSE
	  lPagina := .F.
       ENDIF
       RETURN lPagina
*>>>>FIN ANALISIS PARA EL CAMBIO DE PAGINA