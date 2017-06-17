/*************************************************************************
* TITULO ..: ESTUDIANTES CON INCONSISTENCIAS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:20 PM   MAY 27/99 JUE

OBJETIVOS:

1- Imprime los estudiantes con inconsistencias en los pagos

2- Valida los pagos en la cartera contra los pagos del Banco.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt22(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL lDebito := .T.                 // .T. Debito .F. Credito

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus  := {'1<CARTERA VS BANCO>',;
		   '2<BANCO VS CARTERA>'}

       aAyuda := {'Permite validar las consignaciones Cartera Vs Banco',;
		  'Permite validar las consignaciones Banco Vs Cartera'}

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,09,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    CarVsBan(aParam1,aParam2,aParam3,;
		     cNroMes,oBrowse)
	   *Validaci¢n Cartera Vs Banco

       CASE nNroOpc == 2
	    BanVsCar(aParam1,aParam2,aParam3,;
		     cNroMes,oBrowse)
	   *Validaci¢n Banco Vs Banco

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO ..: VALIDACION CARTERA VS BANCO                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:20 PM   MAY 27/99 JUE

OBJETIVOS:

1- Imprime los estudiantes con inconsistencias en los pagos

2- Valida los pagos en la cartera contra los pagos del Banco.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CarVsBan(aParam1,aParam2,aParam3,;
		  cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo

       LOCAL lHayDif := .F.                 // Hay Diferencia
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL nVlrBan := 0                   // Valor del Grupo en Bancos
       LOCAL nTotBan := 0                   // Valor Total en Bancos

       LOCAL nPagos  := 0                   // Valor pagos sin intereses
       LOCAL nIntVlr := 0                   // Valor de los intereses
       LOCAL nVlrInt := 0                   // Valor de los Intereses
       LOCAL nVlrPag := 0                   // Valor pagos con intereses
       LOCAL nVlrDif := 0                   // Valor Diferencia
       LOCAL cObsVal := ''                  // Observaci¢n de Validaci¢n
     *ÀVariables espec¡ficas

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lHayPag := .F.                 // .T. Hay Pago

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('FUE')
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
	      cError('ABRIENDO ARCHIVOS')
	      CloseDbf('GRU')
	      IF !lFileDelete(FileTem)
		 cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	      ENDIF
	      RETURN NIL
	   ENDIF

	   SELECT GRU
	   GO TOP
	   DO WHILE .NOT. (GRU->(EOF()))

	      IF FUE->(lRegLock(lShared,.T.))
		 REPL FUE->cCodigoGru WITH GRU->cCodigoGru
		 FUE->(DBCOMMIT())
	      ELSE
		 cError('NO SE GRABA LA FORMA DE PAGO')
	      ENDIF
	      IF lShared
		 FUE->(DBUNLOCK())
	      ENDIF

	      SELECT GRU
	      SKIP

	   ENDDO

       ENDFOR
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    IF !lFileDelete(FileTem)
	       cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	    ENDIF
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INDEXACION DEL ARCHIVO
       SELECT TRA
       fNtxMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+cExtNtx
       INDEX ON TRA->cCodigoEst TO &(cPatSis+'\MODEM\'+fNtxMoB)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		      fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS GRUPOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',;
			 22,NIL,NIL,20,60)
       IF !lIntervGru(nNroFil,21,@nRegIni,@nRegFin)
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')
       lPrnFec := CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA

       IF lPrnFec
	  IF lPregunta('DESEA EL INFORME POR INTERVALO DE FECHAS? No Si')

	     @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	     @ nNroFil+3,21 SAY 'FECHA INICIAL:' GET dFecIni PICT '@D'
	     @ nNroFil+4,21 SAY 'FECHA FINAL  :' GET dFecFin PICT '@D'
	     READ

	     IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
		RESTSCREEN(0,0,24,79,cSavPan)
		CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
		CloseDbf('GRU')
		SELECT TRA
		SET INDEX TO
		oBrowse:GOTOP()
		oBrowse:FORCESTABLE()
		IF !lFileDelete(FileTem)
		   cError('NO SE BORRO EL ARCHIVO TEMPORAL')
		ENDIF
		RETURN NIL
	     ENDIF
	  ELSE
	     lFechOk := .T.
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecIni) .AND. EMPTY(dFecFin)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		   '. A¥O: '+cAnoUsr,;
		   'ESTUDIANTES CON INCONSISTENCIAS',;
		   'CONSIGNACIONES MES ACTUAL.'+;
		   IF(lPrnFec,' DE '+cFecha(dFecIni)+ ' A '+;
				     cFecha(dFecFin),''),;
		   nNroPag++,;
		   NIL,lTamAnc}

/*
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*/

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})

*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,12,12,12,12,12,46,42}
       aTitulo := {'FECHA',;
		   'VALOR PAGOS',;
		   '+INT PAGADOS',;
		   '=TOT PAGADO',;
		   '-PAGOS BANCO',;
		   '=DIFERENCIA',;
		   'APELLIDOS Y NOMBRES',;
		   'OBSERVACIONES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE

	  FilePrn := BAN->cCodigoBan+'INPABA'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)

	  IF EMPTY(nOpcPrn)
	     CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	     CloseDbf('GRU')
	     SELECT TRA
	     SET INDEX TO
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

	       VerPrn(nOpcPrn,FilePrn)
	       SET DEVICE TO SCREEN
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       SELECT TRA
	       SET INDEX TO
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       SELECT TRA
	       SET INDEX TO
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------LOCALIZACION DEL PAGO
		 lHayPag := lLocCodPag(CLI->cCodigoEst,VAL(cNroMes),.F.)
		 IF lHayPag
		    IF !EMPTY(PAG->cCodigoFpg)
		       SELECT CLI
		       SKIP
		       LOOP
		    ENDIF
		 ENDIF
		 cNombreTes := cSekNomAlu(CLI->cCodigoEst,cMaeAlu,@cMaeAct,)
		 cNombreTes := CLI->cCodigoEst+' '+ALLTRIM(cNombreTes)
		 cNombreTes := SUBS(cNombreTes+SPACE(46),1,46)
*--------------FIN LOCALIZACION DEL PAGO

*--------------ANALISIS DE LOS PAGOS EN EL BANCO
		 nVlrTra := 0
		 lHayDif := .F.
		 cObsVal := ''
		 IF !CLI->lRetGruCli .AND.;
		    lSekCodigo(CLI->cCodigoEst,'TRA')

		    DO WHILE CLI->cCodigoEst == SUBS(TRA->cCodRefTra,1,6)

		       IF TRA->nCodigoCmv == 1
			  IF TRA->lSumarTra
			     nVlrTra += TRA->nValorTra
			  ELSE
			     nVlrTra -= TRA->nValorTra
			  ENDIF
		       ENDIF
		       cObsVal := TRA->cObsValTra
		       TRA->(DBSKIP())
		    ENDDO
		 ENDIF
*--------------FIN ANALISIS DE LOS PAGOS EN EL BANCO

*--------------LOCALIZACION DEL PAGO EN LA CARTERA
		 nVlrInt := 0
		 IF !CLI->lRetGruCli .AND. lHayPag

*...................ANALISIS DE LA FECHA DE PAGO
		      lFechOk := .T.
		      IF (PAG->cEstadoPag == 'P'  .OR.;
			  PAG->cEstadoPag == 'A') .AND.;
			  EMPTY(PAG->cCodigoFpg)

			 IF lPrnFec
			    IF PAG->dFecPagPag < dFecIni .OR.;
			       PAG->dFecPagPag > dFecFin
			       lFechOk := .F.
			    ENDIF
			 ENDIF
		      ENDIF
*.................. FIN ANALISIS DE LA FECHA DE PAGO

*...................ANALISIS DEL PAGO
		      IF lFechOk

*                        CALCULO DE LOS INTERESES
			   IF PAG->cEstadoPag == 'A' .AND.;
			      EMPTY(PAG->cCodigoFpg)

			      nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
						    PAG->nMesIniPag,;
						    CAA->nMesAmnCaA)
			   ENDIF
*                        FIN CALCULO DE LOS INTERESES

*                        ANALISIS DE LA DIFERENCIA
			   IF PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A'

			      IF ABS(PAG->nVlrPagPag+nVlrInt - nVlrTra) # 0
				 lHayDif := .T.
			      ELSE
				 IF !EMPTY(PAG->cCodigoFpg)
				    lHayDif := .T.
				 ENDIF
			      ENDIF
			   ELSE
			      lHayDif := .F.
			   ENDIF
*                        FIN ANALISIS DE LA DIFERENCIA

*                        ACUMULACION DE LA DIFERENCIA
			   IF lHayDif

			      IF PAG->cEstadoPag == 'A'
				 nIntVlr += nVlrInt
				 nVlrPag += nVlrInt
			      ENDIF

			      nVlrBan += nVlrTra
			      IF PAG->cEstadoPag == 'P' .OR.;
				 PAG->cEstadoPag == 'A'
				 nPagos  += PAG->nVlrPagPag
				 nVlrPag += PAG->nVlrPagPag
				 nVlrDif += PAG->nVlrPagPag+nVlrInt - nVlrTra
			      ELSE
				 nVlrDif += nVlrTra
			      ENDIF

			   ENDIF
*                        FIN ACUMULACION DE LA DIFERENCIA

		      ENDIF
*...................ANALISIS DEL PAGO

		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO EN LA CARTERA

*--------------IMPRESION DEL REGISTRO DEL ESTUDIANTE
		 IF !CLI->lRetGruCli .AND. lFechOk .AND. lHayDif

		    cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))

		    IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
		       aTitulo := {cFecha(PAG->dFecPagPag),;
				   TRANS(PAG->nVlrPagPag,;
					 "####,###,###"),;
				   TRANS(nVlrInt,;
					 "####,###,###"),;
				   TRANS(PAG->nVlrPagPag+nVlrInt,;
					 "####,###,###"),;
				   TRANS(nVlrTra,;
					 "####,###,###"),;
				   TRANS(nVlrTra-(PAG->nVlrPagPag+nVlrInt),;
					 "####,###,###"),;
				   cNombreTes,;
				   SPACE(42)}
		     ELSE
		       aTitulo := {cFecha(TRA->dFechaTra),;
				   SPACE(12),;
				   SPACE(12),;
				   SPACE(12),;
				   TRANS(nVlrTra,"####,###,###"),;
				   TRANS(nVlrTra,"####,###,###"),;
				   cNombreTes,;
				   SPACE(42)}
		     ENDIF

		     cTxtPrn := cRegPrint(aTitulo,aNroCol)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		     IF !EMPTY(cObsVal)
			cTxtPrn := cRegPrint({'JUSTIFICACION: '+;
				   SUBS(cObsVal+SPACE(152),1,151)},{151})
			lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		     ENDIF

		 ENDIF

*--------------FIN IMPRESION DEL REGISTRO DEL ESTUDIANTE

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SET DEVICE TO SCREEN
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION DE LOS TOTALES
       SET DEVICE TO PRINT
       @ PROW()+1,nColCab+nColTxt(aNroCol,02) SAY REPL('-',aNroCol[02])
       @ PROW()  ,nColCab+nColTxt(aNroCol,03) SAY REPL('-',aNroCol[03])
       @ PROW()  ,nColCab+nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       @ PROW()  ,nColCab+nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       @ PROW()  ,nColCab+nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])

       @ PROW()+1,nColCab+nColTxt(aNroCol,02) SAY TRANS(nPagos ,"####,###,###")
       @ PROW(),nColCab+nColTxt(aNroCol,03)   SAY TRANS(nIntVlr,"####,###,###")
       @ PROW(),nColCab+nColTxt(aNroCol,04)   SAY TRANS(nVlrPag,"####,###,###")
       @ PROW(),nColCab+nColTxt(aNroCol,05)   SAY TRANS(nVlrBan,"####,###,###")
       @ PROW(),nColCab+nColTxt(aNroCol,06)   SAY TRANS(nVlrDif,"####,###,###")

       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
       CloseDbf('GRU')
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       SET INDEX TO
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>IMPRESION DE LOS TOTALES

/*************************************************************************
* TITULO ..: VALIDACION BANCO VS CARTERA                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:20 PM   MAY 27/99 JUE

OBJETIVOS:

1- Imprime los estudiantes con inconsistencias en los pagos

2- Valida los pagos en la cartera contra los pagos del Banco.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION BanVsCar(aParam1,aParam2,aParam3,;
		  cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo

       LOCAL lHayDif := .F.                 // Hay Diferencia
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL nVlrBan := 0                   // Valor del Grupo en Bancos
       LOCAL nTotBan := 0                   // Valor Total en Bancos

       LOCAL nPagos  := 0                   // Valor pagos sin intereses
       LOCAL nIntVlr := 0                   // Valor de los intereses
       LOCAL nVlrInt := 0                   // Valor de los Intereses
       LOCAL nVlrPag := 0                   // Valor pagos con intereses
       LOCAL nVlrDif := 0                   // Valor Diferencia
     *ÀVariables espec¡ficas

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL cTemSis := ''                  // Path del Sistema Temporal
       LOCAL cTemUno := ''                  // Path de Integraci¢n Uno Temporal
       LOCAL cTemDos := ''                  // Path de Integraci¢n Dos Temporal
       LOCAL cAnoTem := ''                  // A¤o Temporal del Sistema
       LOCAL cConTxt := ''                  // Descripci¢n del Concepto
       LOCAL cMesTra := ''                  // Mes Transaci¢n
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago

       LOCAL GetList := {}                  // Variable del Sistema
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF VAL(cNroMes) == 11 .OR. VAL(cNroMes) == 12

	  cTemUno := SUBS(cIntUno,1,AT(cAnoUsr,cIntUno)-1)
	  cTemUno := cTemUno+STR(VAL(cAnoUsr)+1,4)+SUBS(cPatSis,5,4)
	  cAnoTem := SUBS(STR(VAL(cAnoUsr)+1,4),3,2)

	  IF !lUseMae(lSiRed,cTemUno,cMaeAlu,cAnoTem,.F.)
	     cError('ABRIENDO LOS ARCHIVOS MAESTROS')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       cSavPan := SAVESCREEN(0,0,24,79)
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		   '. A¥O: '+cAnoUsr,;
		   'INCONSISTENCIAS EXTRACTO VS CARTERA',;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}

/*
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*/

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,12,14,12,12,12,46,42}
       aTitulo := {'FECHA PAGO',;
		   'VALOR PAGADO',;
		   '-CONSIGNACION',;
		   'FECHA CONSIG',;
		   '=DIFERENCIA',;
		   'CONCEPTO',;
		   'APELLIDOS Y NOMBRES',;
		   'OBSERVACIONES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n20Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE

	  FilePrn := BAN->cCodigoBan+'INBAPA'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>RECORRIDO DEL EXTRACTO
       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SELECT TRA
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO: '+STR(TRA->(RECNO()),5)+'/'+;
				     STR(TRA->(RECCOUNT()),5)+'º'+;
			'REFERENCIA: '+TRA->cCodRefTra,cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DEL CODIGO DEL CONCEPTO DEL MOVIMIENTO
	    IF TRA->nCodigoCmv # 1 .AND. TRA->nCodigoCmv # 2 .AND.;
	       TRA->nCodigoCmv # 3 .AND. TRA->nCodigoCmv # 4
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL CODIGO DEL CONCEPTO DEL MOVIMIENTO

**********ANALISIS DEL MES
	    cCodigoTes := SUBS(TRA->cCodRefTra,1,6)
	    nVlrTra := nVlrTra(cCodigoTes,TRA->nCodigoCmv)

	    cMesTra := ''
	    DO CASE
	    CASE TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2
		 cMesTra := SUBS(TRA->cCodRefTra,7,2)

	    CASE TRA->nCodigoCmv == 3
		 cMesTra := SUBS(TRA->cCodRefTra,9,2)
	    ENDCASE
**********FIN ANALISIS DEL MES

**********BUSQUEDA DEL ESTUDIANTE
	    IF TRA->nCodigoCmv == 4 .AND.;
	       (VAL(cNroMes) == 11 .OR. VAL(cNroMes) == 12)
	       lHayAlu := lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct,.F.)
	    ELSE
	       lHayAlu := lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct,.F.)
	    ENDIF

	    IF lHayAlu
	       cCodigoTgr := &cMaeAct->cCodigoGru
	       cNombreTes := cCodigoTes+' '+cCodigoTgr+' '+;
			     RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	    ELSE
	       cNombreTes := cCodigoTes
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(46),1,46)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********ANALISIS DEL CONCEPTO
	    DO CASE
	    CASE TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2
		 cConTxt := 'PENSION DE '+cMes(VAL(cMesTra),3)
	    CASE TRA->nCodigoCmv == 3
		 cConTxt := 'ABONO DE '+cMes(VAL(cMesTra),3)
	    CASE TRA->nCodigoCmv == 4
		 cConTxt := 'MATRICULA'
	    ENDCASE
**********FIN ANALISIS DEL CONCEPTO

**********ANALISIS SI NO EXISTE EL ESTUDIANTE
	    IF .NOT. lHayAlu
	       aTitulo := {SPACE(12),;
			   SPACE(12),;
			   TRANS(nVlrTra,"####,###,###"),;
			   cFecha(TRA->dFechaTra),;
			   SPACE(12),;
			   cConTxt,;
			   cNombreTes,;
			   SUBS('FAVOR REVISAR'+SPACE(42),1,42)}

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN ANALISIS SI NO EXISTE EL ESTUDIANTE

**********ANALISIS DEL PATH DE ACUERDO AL MES
	    IF TRA->nCodigoCmv == 4  .AND. (cNroMes == '11' .OR.;
					    cNroMes == '12')
	       cTemDos := SUBS(cIntDos,1,AT(cAnoUsr,cIntDos)-1)
	       cTemDos := cTemDos+STR(VAL(cAnoUsr)+1,4)+SUBS(cPatSis,5,4)
	    ELSE
	       cTemDos := cIntDos
	    ENDIF

	    IF VAL(cMesTra) == 11 .AND. VAL(cNroMes) < 11
	       cTemSis := STR(VAL(cAnoUsr)-1,4)+SUBS(cPatSis,5,4)
	       cAnoSis := SUBS(STR(VAL(cAnoUsr)-1,4),3,2)
	    ELSE
	       cTemSis := cPatSis
	       cAnoSis := SUBS(cAnoUsr,3,2)
	    ENDIF
**********FIN ANALISIS DEL PATH DE ACUERDO AL MES

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cTemSis+'\CLIENTES\CL'+;
			       cCodigoTgr+cAnoSis+ExtFile

	    FilePag := cTemSis+'\PAGOS\PA'+;
			       cCodigoTgr+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********AREAS DE TRABAJO
	    aUseDbf := {}
	    AADD(aUseDbf,{.T.,cPatSis+'\'+;
			      fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
	    AADD(aUseDbf,{.T.,FileCli,'CLI',NIL,lShared,nModCry})
	    AADD(aUseDbf,{.T.,FilePag,'PAG',NIL,lShared,nModCry})
	    AADD(aUseDbf,{.T.,cTemDos+'\'+'PAGOS'+ExtFile,'PMT',;
			      cTemDos+'\'+'PAGOS'+cExtNtx,lShared,0})
	    AADD(aUseDbf,{.T.,cTemSis+'\'+FileDes,'DES',;
			      cTemSis+'\'+fNtxDes,lShared,nModCry})
**********FIN AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbfs(aUseDbf)
	       VerPrn(nOpcPrn,FilePrn)
	       SET DEVICE TO SCREEN
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseAll(aUseDbf,.F.)
	       SELECT TRA
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS')
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       VerPrn(nOpcPrn,FilePrn)
	       SET DEVICE TO SCREEN
	       CloseAll(aUseDbf,.F.)
	       SELECT TRA
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********ANALISIS DEL VALOR DE LA PENSION
	    aTitulo := NIL
	    lHayPag := .F.
	    IF TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2

*              CALCULO DE LOS INTERESES
		 lHayPag := lLocCodPag(cCodigoTes,VAL(cMesTra),.F.)

		 nVlrInt := 0
		 IF PAG->cEstadoPag == 'A'
		    nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
					  PAG->nMesIniPag,;
					  CAA->nMesAmnCaA)
		 ENDIF
*              FIN CALCULO DE LOS INTERESES

*              ANALISIS DE DECISION
		 IF (PAG->cEstadoPag == 'P'  .OR.;
		     PAG->cEstadoPag == 'A')

		     IF PAG->cCodigoBan # BAN->cCodigoBan

			aTitulo := {SPACE(12),;
				    SPACE(12),;
				    TRANS(nVlrTra,"####,###,###"),;
				    cFecha(TRA->dFechaTra),;
				    SPACE(12),;
				    'PAGO DE '+cMes(VAL(cMesTra),3),;
				    cNombreTes,;
				    'CODIGO DEL BANCO:'+PAG->cCodigoBan+;
				    ' NO COINCIDE.'}

		     ENDIF

		 ENDIF
*              FIN ANALISIS DE DECISION

*              ANALISIS DE LA DIFERENCIA

		 IF (PAG->cEstadoPag == 'P'  .OR.;
		     PAG->cEstadoPag == 'A')

		     IF TRA->dFechaTra == PAG->dFecPagPag

			IF ABS(PAG->nVlrPagPag+nVlrInt) # nVlrTra

			   aTitulo := {cFecha(PAG->dFecPagPag),;
				       TRANS(PAG->nVlrPagPag+nVlrInt,;
					     "####,###,###"),;
				       TRANS(nVlrTra,"####,###,###"),;
				       cFecha(TRA->dFechaTra),;
				       TRANS(PAG->nVlrPagPag+nVlrInt-ABS(nVlrTra),;
					     "####,###,###"),;
				       'PAGO DE '+cMes(VAL(cMesTra),3),;
				       cNombreTes,;
				       SPACE(42)}
			ENDIF
		     ELSE
			aTitulo := {SPACE(12),;
				    SPACE(12),;
				    TRANS(nVlrTra,"####,###,###"),;
				    cFecha(TRA->dFechaTra),;
				    SPACE(12),;
				    'PAGO DE '+cMes(VAL(cMesTra),3),;
				    cNombreTes,;
				    'FECHA NO COINCIDE. VERIFICAR'}
		     ENDIF
		 ENDIF
*              FIN ANALISIS DE LA DIFERENCIA

	    ENDIF
**********FIN ANALISIS DEL VALOR DE LA PENSION

**********ANALISIS DEL VALOR DEL ABONO
	    IF TRA->nCodigoCmv == 3

	       IF !lLocAbono(cCodigoTes,VAL(cMesTra),nVlrTra,TRA->dFechaTra)

		   aTitulo := {SPACE(12),;
			       SPACE(12),;
			       TRANS(nVlrTra,"####,###,###"),;
			       cFecha(TRA->dFechaTra),;
			       SPACE(12),;
			       'ABONO DE '+cMes(VAL(cMesTra),3),;
			       cNombreTes,;
			       SPACE(42)}
	       ENDIF

	    ENDIF
**********FIN ANALISIS DEL VALOR DEL ABONO

**********ANALISIS DEL VALOR DE LA MATRICULA
	    IF TRA->nCodigoCmv == 4

	       IF lSekCodigo(cCodigoTes+'1','PMT')

		  IF PMT->cCodigoEst # cCodigoTes
		     cError('ERROR EN LA BUSQUEDA '+cCodigoTes)
		  ENDIF

		  IF PMT->nVlrPagPag # nVlrTra

		       aTitulo := {cFecha(PMT->dFecPagPag),;
				   TRANS(PMT->nVlrPagPag,;
					 "####,###,###"),;
				   TRANS(nVlrTra,"####,###,###"),;
				   cFecha(TRA->dFechaTra),;
				   TRANS(PMT->nVlrPagPag-ABS(nVlrTra),;
					 "####,###,###"),;
				   'MATRICULA',;
				   cNombreTes,;
				   SPACE(42)}
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL VALOR DE LA MATRICULA

**********IMPRESION DEL REGISTRO
	    IF !EMPTY(aTitulo)
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL REGISTRO

	  CloseAll(aUseDbf,.F.)
	  TRA->(DBSKIP())

       ENDDO
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       RETURN NIL
*>>>>FIN RECORRIDO DEL EXTRACTO


FUNCTION nVlrTra(cCodEst,nCodCmv)

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrTra := 0
       LOCAL nRegAct := 0                   // Registro Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALOR DE LA TRANSACION
       nRegAct := TRA->(RECNO())
       DO WHILE SUBS(TRA->cCodRefTra,1,6) == cCodEst

	  IF TRA->nCodigoCmv == nCodCmv
	     IF TRA->lSumarTra
		nVlrTra += TRA->nValorTra
	     ELSE
		nVlrTra -= TRA->nValorTra
	     ENDIF
	  ENDIF
	  TRA->(DBSKIP())

       ENDDO
       TRA->(DBGOTO(nRegAct))
       RETURN nVlrTra
*>>>>FIN VALOR DE LA TRANSACION

/*************************************************************************
* TITULO DE LA FUNCION..: LOCALIZACION DEL ABONO CONSIGNADO              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/99 JUE A
       Colombia, Bucaramanga        INICIO: 03:25 PM   MAR 25/99 JUE

OBJETIVOS:

1- Verifica si el abono consignado en el Banco fue registrado en la
   Cartera.

2- Retorna .T. si el abono fue aplicado.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lLocAbono(cCodEst,nMesIni,nVlrTra,dFecTra)

*>>>>PARARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del Estudiante
       nMesIni                              // Mes Inicial del pago
       nVlrTra                              // Valor de la Consignaci¢n
       dFecTra                              // Fecha de la Consignaci¢n */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nDeuAnt := 0                   // Deuda Anterior
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL ABONO
       SELECT DES
       GO TOP
       LOCATE FOR DES->cCodigoEst == cCodEst .AND.;
		  DES->nTipDesDes == 3

       IF .NOT. DES->(FOUND())
	  RETURN .F.
       ENDIF
*>>>>FIN LOCALIZACION DEL ABONO

*>>>>LOCALIZACION DEL ABONO
       DO WHILE DES->(FOUND())

**********ANALISIS DEL ABONO
	    IF DES->nValorDes == nVlrTra        .AND.;
	       TRA->dFechaTra == DES->dFechaDes .AND.;
	       !DES->lDesEfeDes
	       RETURN .T.
	    ENDIF
**********FIN ANALISIS DEL ABONO

	  SELECT DES
	  CONTINUE
	  LOOP

       ENDDO
       RETURN .F.
*>>>>FIN LOCALIZACION DEL ABONO