/*************************************************************************
* TITULO ..: VALIDACION DE LOS RECIBOS DEL MES                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:20 PM   MAY 27/99 JUE

OBJETIVOS:

1- Valida los pagos en la cartera contra los pagos del Banco.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtExt211(aParam1,aParam2,aParam3,;
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
       LOCAL PathTem := ''                  // Path temporal

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
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL lValida := .F.                 // .T. Validar por Estudiante.
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL nVlrBan := 0                   // Valor del Grupo en Bancos
       LOCAL nTotBan := 0                   // Valor Total en Bancos
       LOCAL nBanNiv := 0                   // Valor Total en Bancos por niveles

       LOCAL nPagos  := 0                   // Valor pagos sin intereses
       LOCAL nPagTot := 0                   // Total pagos sin intereses
       LOCAL nPagNiv := 0                   // Total pagos por niveles

       LOCAL nIntVlr := 0                   // Valor de los intereses
       LOCAL nVlrInt := 0                   // Valor de los Intereses
       LOCAL nTotInt := 0                   // Total Intereses
       LOCAL nIntNiv := 0                   // Total Intereses por nivel

       LOCAL nPagPar := 0                   // Pagos Parciales
       LOCAL nVlrPag := 0                   // Valor pagos con intereses
       LOCAL nTotPag := 0                   // Total pagos con intereses
       LOCAL nTotNiv := 0                   // Total pagos con intereses por nivel

       LOCAL nVlrDif := 0                   // Valor Diferencia
       LOCAL nTotDif := 0                   // Total Diferencia
       LOCAL nDifNiv := 0                   // Total Diferencia por nivel
     *ÀVariables espec¡ficas


       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la fila
       LOCAL nNroCol := 0                   // N£mero de la Columna
       LOCAL lHayPag := .F.                 // .T. Hay pago

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

*>>>>LECTURA DEL A¥O ACTUAL
       cSavPan := SAVESCREEN(0,0,24,79)
       TitBuscar(10,@nNroFil,@nNroCol,'A¥O',;
		  '',13)
       SETCURSOR(1)

       @ nNroFil,nNroCol GET cAnoUsr PICT '9999'
       READ
       IF EMPTY(cAnoUsr)
	  CloseAll()
	  RETURN NIL
       ENDIF
       PathTem := cPatSis
       cPatSis := cAnoUsr+SUBS(cPatSis,5,4)
       cAnoSis := SUBS(cAnoUsr,3,2)
*>>>>FIN LECTURA DEL A¥O ACTUAL

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
       INDEX ON TRA->cCodigoEst;
	     TO &(cPatSis+'\MODEM\'+fNtxMoB+cNroMes+cAnoSis+cExtNtx)
*>>>>FIN INDEXACION DEL ARCHIVO


*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		      fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,PathTem+'\'+FileCmv,'CMV',NIL,lShared,nModCry) .OR.;
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

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIni := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de los Recibos',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIni == 0
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

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
       lValida := .F.
       IF nRegIni == nRegFin
	  lValida := lPregunta('DESEA IMPRIMIR EL INFORME CON DETALLE '+;
			       'POR CADA ESTUDIANTE? No Si')
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
		   'CARTERA Vs BANCO '+;
		   'EXTRACTO DE '+cMes(VAL(cNroMes))+;
		   '. A¥O: '+cAnoUsr,;
		   'RECIBOS DE '+cMes(nMesIni),;
		   'PAGOS DEL MES.'+;
		   IF(lPrnFec,' DE '+cFecha(dFecIni)+ ' A '+;
				     cFecha(dFecFin),''),;
		   nNroPag++,;
		   NIL,lTamAnc}

/*
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*/

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,16,16,16,18,16,40}
       aTitulo := {'Niv.',;
		   'VALOR PAGOS',;
		   '+INT PAGADOS',;
		   '=TOTAL PAGADO',;
		   '-PAGOS EN EL BANCO',;
		   '=DIFERENCIA','OBSERVACIONS'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
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
	  IF nRegIni == nRegFin
	     FilePrn := 'B'+BAN->cCodigoBan+'P'+ALLTRIM(GRU->cCodigoGru)
	  ELSE
	     FilePrn := 'BAN'+BAN->cCodigoBan+'PAG'
	  ENDIF
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
       cNivAnt := SUBS(GRU->cCodigoGru,1,2)
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
	    nPagos  := 0
	    nIntVlr := 0
	    nVlrPag := 0
	    nVlrBan := 0
	    nVlrDif := 0
	    DO WHILE .NOT. CLI->(EOF())


*--------------LOCALIZACION DEL PAGO
		 lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
		 IF lHayPag
		    IF !EMPTY(PAG->cCodigoFpg)
		       SELECT CLI
		       SKIP
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO


*-------------ANALISIS DEL BANCO
		 IF lHayPag
		    IF PAG->cCodigoBan # BAN->cCodigoBan
		       SELECT CLI
		       SKIP
		       LOOP
		    ENDIF
		 ENDIF
*-------------FIN ANALISIS DEL BANCO

*--------------ANALISIS DE LOS PAGOS EN EL BANCO
		 nVlrTra := 0
		 IF !CLI->lRetGruCli .AND.;
		    lSekCodigo(CLI->cCodigoEst,'TRA')


		    DO WHILE CLI->cCodigoEst == SUBS(TRA->cCodRefTra,1,6)

		       IF (TRA->nCodigoCmv == 1  .OR.;
			   TRA->nCodigoCmv == 2) .AND.;
			  VAL(SUBS(TRA->cCodRefTra,7,2)) == nMesIni

			  IF TRA->lSumarTra
			     nVlrTra += TRA->nValorTra
			     nVlrBan += TRA->nValorTra
			     nBanNiv += TRA->nValorTra
			  ELSE
			     nVlrTra -= TRA->nValorTra
			     nVlrBan -= TRA->nValorTra
			     nBanNiv -= TRA->nValorTra
			  ENDIF

		       ELSE

			  IF lLocCodigo('nCodigoCmv','CMV',TRA->nCodigoCmv)

			      IF (CMV->nCodCmvCmv == 1  .OR.;
				  CMV->nCodCmvCmv == 2) .AND.;
				  cAnoUsr == CMV->cAnoCmvCmv .AND.;
				  VAL(SUBS(TRA->cCodRefTra,7,2)) == nMesIni

				  IF TRA->lSumarTra
				     nVlrTra += TRA->nValorTra
				     nVlrBan += TRA->nValorTra
				     nBanNiv += TRA->nValorTra
				  ELSE
				     nVlrTra -= TRA->nValorTra
				     nVlrBan -= TRA->nValorTra
				     nBanNiv -= TRA->nValorTra
				  ENDIF


			      ENDIF


			  ENDIF


		       ENDIF
		       TRA->(DBSKIP())
		    ENDDO
		 ENDIF
*--------------FIN ANALISIS DE LOS PAGOS EN EL BANCO

*--------------BUSQUEDA DEL PAGO PARCIAL
		 nPagPar := 0
		 IF lSekCodDes(CLI->cCodigoEst,nMesIni,.F.)

		    IF DES->nTipDesDes == 4  // Pago Parcial

		       IF !(DES->dFechaDes < dFecIni .OR.;
			    DES->dFechaDes > dFecFin)

			    nPagPar := DES->nValorDes

			    nPagos  += nPagPar
			    nVlrPag += nPagPar

			    nPagNiv += nPagPar
			    nTotNiv += nPagPar

			    nVlrDif += nPagPar - nVlrTra
			    nDifNiv += nPagPar - nVlrTra

		       ENDIF

		    ENDIF
		 ENDIF
*--------------FIN BUSQUEDA DEL PAGO PARCIAL

*--------------LOCALIZACION DEL PAGO EN LA CARTERA
		 nVlrInt := 0
		 IF !CLI->lRetGruCli .AND. lHayPag

*...................ANALISIS DE LA FECHA DE PAGO
		      lFechOk := .T.
		      IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'

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

*                        TOTALIZACION DE LOS PAGOS
			   IF PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A'

			      nPagos +=  PAG->nVlrPagPag
			      nVlrPag += PAG->nVlrPagPag

			      nPagNiv += PAG->nVlrPagPag
			      nTotNiv += PAG->nVlrPagPag

			   ENDIF
*                        FIN TOTALIZACION DE LOS PAGOS

*                        PAGO EXTEMPORANEO
			   IF PAG->cEstadoPag == 'A'

			      nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
						    PAG->nMesIniPag,;
						    CAA->nMesAmnCaA)
			      nIntVlr += nVlrInt
			      nVlrPag += nVlrInt

			      nIntNiv += nVlrInt
			      nTotNiv += nVlrInt
			   ENDIF
*                        FIN PAGO EXTEMPORANEO

*                        CALCULO DE LA DIFERENCIA
			   IF PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A'
			      nVlrDif += PAG->nVlrPagPag+nVlrInt - nVlrTra
			      nDifNiv += PAG->nVlrPagPag+nVlrInt - nVlrTra

			      IF !EMPTY(PAG->cCodigoFpg) .AND. nVlrDif == 0
				 nVlrDif += nVlrTra
				 nDifNiv += nVlrTra
			      ENDIF
			    *ÀPago Registrado como No Banco y aparece en Banco.
			   ELSE
			      IF nPagPar == 0
				 nVlrDif += nVlrTra
				 nDifNiv += nVlrTra
			      ENDIF
			   ENDIF
*                        FIN CALCULO DE LA DIFERENCIA

		      ENDIF
*...................ANALISIS DEL PAGO

		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO EN LA CARTERA

*--------------IMPRESION DEL REGISTRO DEL ESTUDIANTE
		 IF lValida
		    IF (!CLI->lRetGruCli .AND. lFechOk) .OR. nPagPar # 0

			IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'

			   aTitulo := {GRU->cCodigoGru,;
				       TRANS(PAG->nVlrPagPag+nPagPar,;
					     "####,###,###.99"),;
				       TRANS(nVlrInt,;
					     "####,###,###.99"),;
				       TRANS(PAG->nVlrPagPag+nVlrInt+nPagPar,;
					     "####,###,###.99"),;
				       TRANS(nVlrTra,;
					     "####,###,###.99"),;
				       TRANS(PAG->nVlrPagPag+nVlrInt+;
					     nPagPar-nVlrTra,;
					     "####,###,###.99"),;
				       CLI->cCodigoEst+'-'+;
				       STR(CLI->(RECNO()),2)+' '+;
				       cFecha(PAG->dFecPagPag)+' '+;
				       IF(!EMPTY(PAG->cCodigoFpg),;
					 ' NO PAGO EN BANCO','')}

			ELSE
			   aTitulo := {GRU->cCodigoGru,;
				       TRANS(nPagPar,"####,###,###.99"),;
				       SPACE(16),;
				       TRANS(nPagPar,"####,###,###.99"),;
				       TRANS(nVlrTra,"####,###,###.99"),;
				       TRANS(nPagPar-nVlrTra,"####,###,###.99"),;
				       CLI->cCodigoEst+'-'+;
				       STR(CLI->(RECNO()),2)}

			   IF nPagPar == 0
			      nVlrDif += nVlrTra
			      nDifNiv += nVlrTra
			   ENDIF

			ENDIF
		    ELSE
			aTitulo := {GRU->cCodigoGru,;
				    SPACE(16),;
				    SPACE(16),;
				    SPACE(16),;
				    TRANS(nVlrTra,"####,###,###.99"),;
				    TRANS(nVlrTra,"####,###,###.99"),;
				    CLI->cCodigoEst+'-'+;
				    STR(CLI->(RECNO()),2)}
		    ENDIF
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO DEL ESTUDIANTE

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********IMPRESION DE LOS TOTALES
	    IF !lValida
	       aTitulo := {GRU->cCodigoGru,;
			   TRANS(nPagos,"####,###,###.99"),;
			   TRANS(nIntVlr,"####,###,###.99"),;
			   TRANS(nVlrPag,"####,###,###.99"),;
			   TRANS(nVlrBan,"####,###,###.99"),;
			   TRANS(nVlrPag-nVlrBan,"####,###,###.99"),; // nVlrDif
			   SPACE(04)}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF

	    nPagTot += nPagos
	    nTotInt += nIntVlr
	    nTotPag += nVlrPag
	    nTotBan += nVlrBan
	    nTotDif += nVlrDif
**********FIN IMPRESION DE LOS TOTALES

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct

*--------------IMPRESION DE LOS TOTALES POR NIVEL
		 aTitulo := {}
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,REPL('-',aNroCol[02]))
		 AADD(aTitulo,REPL('-',aNroCol[03]))
		 AADD(aTitulo,REPL('-',aNroCol[04]))
		 AADD(aTitulo,REPL('-',aNroCol[05]))
		 AADD(aTitulo,REPL('-',aNroCol[06]))
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		 aTitulo := {}
		 AADD(aTitulo,SUBS(cNivAnt,1,2))
		 AADD(aTitulo,TRANS(nPagNiv,"####,###,###.99"))
		 AADD(aTitulo,TRANS(nIntNiv,"####,###,###.99"))
		 AADD(aTitulo,TRANS(nTotNiv,"####,###,###.99"))
		 AADD(aTitulo,TRANS(nBanNiv,"####,###,###.99"))
		 AADD(aTitulo,TRANS(nDifNiv,"####,###,###.99"))
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 @ PROW()+1,00 SAY ''
*--------------FIN IMPRESION DE LOS TOTALES POR NIVEL

*--------------INICIALIZACION DE VALORES
		 nPagNiv := 0
		 nIntNiv := 0
		 nTotNiv := 0
		 nBanNiv := 0
		 nDifNiv := 0
		 cNivAnt := cNivAct
*--------------FIN INICIALIZACION DE VALORES

	    ENDIF
	    SET DEVICE TO SCREEN
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION DE LOS TOTALES
       SET DEVICE TO PRINT
       @ PROW()+1,nColCab+nColTxt(aNroCol,02) SAY REPL('=',aNroCol[02])
       @ PROW()  ,nColCab+nColTxt(aNroCol,03) SAY REPL('=',aNroCol[03])
       @ PROW()  ,nColCab+nColTxt(aNroCol,04) SAY REPL('=',aNroCol[04])
       @ PROW()  ,nColCab+nColTxt(aNroCol,05) SAY REPL('=',aNroCol[05])
       @ PROW()  ,nColCab+nColTxt(aNroCol,06) SAY REPL('=',aNroCol[06])

       @ PROW()+1,nColCab+nColTxt(aNroCol,02) SAY TRANS(nPagTot,"####,###,###.99")
       @ PROW(),nColCab+nColTxt(aNroCol,03)   SAY TRANS(nTotInt,"####,###,###.99")
       @ PROW(),nColCab+nColTxt(aNroCol,04)   SAY TRANS(nTotPag,"####,###,###.99")
       @ PROW(),nColCab+nColTxt(aNroCol,05)   SAY TRANS(nTotBan,"####,###,###.99")
       @ PROW(),nColCab+nColTxt(aNroCol,06)   SAY TRANS(nTotDif,"####,###,###.99")
       @ PROW()+1,00 SAY ''

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