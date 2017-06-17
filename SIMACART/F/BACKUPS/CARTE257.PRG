/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: FACTURACION TOTAL

**************************************************************************
* TITULO..: FACTURACION TOTAL POR ESTUDIANTE                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 06/2004 MAR A
       Bucaramanga, Colombia	    INICIO: 11:15 PM   ABR 06/2004 MAR

OBJETIVOS:

1- Permite imprimir el total de la facturaci¢n de cada mes por estudiante

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_257(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
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

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL lSiPaso := .F.                 // Control de Flujo

       LOCAL nTipInf := 0                   // Tipo de Informe
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL fFacTot := ''                  // Archivo para la facturaci¢n total
       LOCAL Getlist := {}                  // Variable del sistema

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
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths

       cIntUno := PathUno+'\'+cPatSis
       cIntDos := PathDos+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF

       FOR i := 1 TO LEN(cMaeAlu)/3

	   cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	   CloseDbf('GRU')

	   IF !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis)
	      cError('ABRIENDO ARCHIVOS')
	      CloseAll()
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

*>>>>AREAS DE TRABAJO
       fFacTot := 'fFacTot.dbf'
       CreaFacTot(lShared,nModCry,'printer',fFacTot)

       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,'printer\'+fFacTot,'TEM',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lSiRed)   .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
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
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL TIPO DE INFORME
       nTipInf := nLeeOpcion('OPCION: '+;
			     '1<SALDO ACTUAL> '+;
			     '2<SALDO FIN DE MES> '+;
			     '3<POR FECHA> 4<ABANDONAR>?',4,'0')

       IF nTipInf == 4
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE INFORME

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')
       IF nTipInf == 3

	  lPrnFec := .T.
	  cSavPan := SAVESCREEN(0,0,24,79)
	  @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	  @ nFilInf+1,nColInf SAY 'FECHA DE CORTE:' GET dFecPrn PICT '@D'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(dFecPrn)
	     CloseAll(aUseDbf)
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'FACTURACION TOTAL'}
       DO CASE
       CASE nTipInf == 1
	    AADD(aCabPrn,'SALDO ACTUAL A LA FECHA')

       CASE nTipInf == 2
	    AADD(aCabPrn,'SALDO A FIN DE MES')

       CASE nTipInf == 3
	    AADD(aCabPrn,'SALDO A '+cFecha(dFecPrn))
       ENDCASE

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       AADD(aNroCol,06)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,08)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,06)
       AADD(aTitPrn,'DESCRI')

       AADD(aNroCol,12)
       AADD(aTitPrn,'MATRICULA')

       FOR i := 2 TO 11
	   AADD(aNroCol,10)
	   AADD(aTitPrn,cMes(i,3))
       ENDFOR
       AADD(aNroCol,12)
       AADD(aTitPrn,'TOTAL')
       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := PCL('n17Stan')
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ftotal'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.T.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DE LOS ESTADOS DE CUENTA
       SELECT GRU
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       SELECT GRU
	       SKIP
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LOS RECIBOS DE PAGO DEL GRUPO
	    SELECT CLI
	    CLI->(DBGOTOP())
	    DO WHILE .NOT. CLI->(EOF())

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF !lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)

		    SET DEVICE TO SCREEN
		    cError('EL CODIGO:' +CLI->cCodigoEst+' NO EXISTE '+;
			   'EN CLIENTES DEL GRUPO '+GRU->cCodigoGru)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF
		 cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			       RTRIM(&cMaeAct->cNombreEst)
		 IF &cMaeAct->lRetiroEst
		    cNombreTes += '. SE RETIRO EN '+;
				  cFecha(&cMaeAct->dFecRetEst)+' '+;
				  'ULTIMO MES A FACTURAR .'+;
				  cMes(&cMaeAct->nUltRecEst,3)
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------VERIFICACION DEL GRUPO
		 IF &cMaeAct->cCodigoGru # GRU->cCodigoGru .AND.;
		    !(CLI->lRetGruCli)

		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN VERIFICACION DEL GRUPO

*--------------FILTRACION DE LOS PAGOS
		 SELECT PAG
		 SET FILTER TO PAG->cCodigoEst == CLI->cCodigoEst
		 PAG->(DBGOTOP())
		 IF PAG->(EOF())
		    SET FILTER TO
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN FILTRACION DE LOS PAGOS

*--------------IMPRESION DEL ESTADO DE CUENTA
		 lPrnFacEst(lShared,cNomSis,cAnoUsr,CLI->cCodigoEst,;
			    &cMaeAct->lRetiroEst,;
			    &cMaeAct->cCodigoGru+'-'+;
			    STR(CLI->(RECNO()),2),aNroCol,aTitPrn,nColCab,;
			    bPagina,bDerAut,bCabeza,aCabPrn,nOpcPrn,FilePrn,;
			    @nHanXml,nTipInf,dFecPrn,@lSiPaso)
		 SELECT PAG
		 SET FILTER TO
*--------------FIN IMPRESION DEL ESTADO DE CUENTA

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DE LOS RECIBOS DE PAGO DEL GRUPO

**********INCREMENTO DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni == nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN INCREMENTO DEL SIGUIENTE GRUPO

       ENDDO

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DE LOS ESTADOS DE CUENTA

/*************************************************************************
* TITULO..: IMPRESION DEL CUERPO DEL ESTADO DE CUENTA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2002 VIE A
       Bucaramanga, Colombia        INICIO: 06:15 PM   DIC 06/2002 VIE

OBJETIVOS:

1- Imprime el Cuerpo del Estado de Cuenta del Cliente

2- Retorna el manejador del Archivo Xml


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPrnFacEst(lShared,cNomSis,cAnoUsr,cCodEst,lRetEst,cCodGru,;
		    aNroCol,aTitPrn,nColCab,bPagina,bDerAut,bCabeza,;
		    aCabPrn,nOpcPrn,FilePrn,nHanXml,nTipInf,dFecPrn,;
		    lSiPaso)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del Usuario
       cCodEst                              // C¢digo del Estudiante
       lRetEst                              // .T. Estudiante Retirado
       cCodGru                              // C¢digo del Grupo
       aNroCol                              // N£mero de Columna
       aTitPrn                              // T¡tulos Encabezados para impresi¢n
       nColCab                              // Columna del encabezado
       bPagina                              // Block de P gina
       bDerAut                              // Block Derechos de Autor
       bCabeza                              // Block de Encabezado
       aCabPrn                              // Encabezado General del Informe
       nOpcPrn                              // Opci¢n de Impresi¢n
       FilePrn                              // Archivo de Impresi¢n
       nHanXml                              // Manejardo del Archivo Xml
       nTipInf                              // Tipo de Informe
       dFecPrn                              // Fecha de Corte de Impresi¢n
       lSiPaso                              // @Control de Flujo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL cHayErr := ''                   // '' => No hay Error F=> Error en Anticipos S=> Error en Saldos
       LOCAL cErrFac := ''                   // '' => No hay Error F=> Error en Anticipos S=> Error en Saldos
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas

       LOCAL aTitFac := {}                  // T¡tulos para Facturaci¢n
       LOCAL aColFac := {}                  // N£mero de Columna
       LOCAL aTitPag := {}                  // T¡tulos para Pagos
       LOCAL aTitSdo := {}                  // T¡tulos para Saldos
       LOCAL aMesFac := {}                  // Meses de Facturaci¢n

       LOCAL nFacMat := 0                   // Facturaci¢n de la Matricula
       LOCAL aVlrEst := {}                  // Facturacion del Estudiante
       LOCAL nFacEst := 0                   // Facturaci¢n
       LOCAL nPagMes := 0		    // Valor Pagado
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nPagFin := 0                   // Valor Pagado fin de mes
       LOCAL nSdoFin := 0                   // Saldo Actual fin de mes
     *ÀFacturaci¢n estudiante

       LOCAL nTotFac := 0                   // Total Facturaci¢n
       LOCAL nTotPag := 0                   // Total Pagos

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION
       AADD(aTitFac,cCodEst)

       AADD(aTiTFac,cCodGru)
       AADD(aTitFac,'FACTU')

       AADD(aTitPag,'')
       AADD(aTitPag,'')
       AADD(aTitPag,'PAGOS')

       AADD(aTitSdo,'')
       AADD(aTitSdo,'')
       AADD(aTitSdo,'SALDOS')
*>>>>FIN INICIALIZACION

*>>>>CALCULO DE LA MATRICULA
       FOR i := 1 TO LEN(ALLTRIM(CAA->cConMatCaA))/2

***********LOCALIZACION DEL VALOR DEL CONCEPTO
	     cCodigoTco := SUBS(ALLTRIM(CAA->cConMatCaA),i*2-1,2)
	     SELECT TMT
	     GO TOP
	     LOCATE FOR TMT->cCodigoGru == SUBS(cCodGru,1,2)+'00' .AND.;
			TMT->cCodigoCon == cCodigoTco

	     IF FOUND()
		nFacMat += TMT->nValorTar
	     ENDIF
***********FIN LOCALIZACION DEL CONCEPTO

       ENDFOR
       nTotFac += nFacMat
       nTotPag += nFacMat

       AADD(aTitFac,TRANS(nFacMat,'##,###,###'))
       AADD(aTitPag,TRANS(nFacMat,'##,###,###'))
       AADD(aTitSdo,TRANS(nSdoAct,'##,###,###'))
*>>>>FIN CALCULO DE LA MATRICULA

*>>>>RECORRIDO DE LOS PAGOS
       SELECT PAG
       PAG->(DBGOTOP())
       DO WHILE .NOT. PAG->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('ºGRUPO: '+GRU->cCodigoGru+;
			'ºCODIGO: '+CLI->cCodigoEst+;
			'ºMES:'+cMes(PAG->nMesIniPag,3)+;
			'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				STR(CLI->(RECCOUNT()),2),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

/*
**********ANALISIS DE LA FORMA DE PAGO
	    nVlrPag := 0
	    nVlrInt := 0
	    nDeuAct := 0
	    nMorAct := 0
	    nSdoAct := 0
	    VlrFormaPag(@nVlrPag,@nVlrInt,@nDeuAct,@nMorAct,@nSdoAct,@nFacEst)
**********FIN ANALISIS DE LA FORMA DE PAGO
*/

**********CALCULO DE LA FACTURACION DEL MES
	    lPrnFec := IF(EMPTY(dFecPrn),.F.,.T.)

	    cHayErr := cFactEst(cAnoUsr,cCodEst,;
				lRetEst,PAG->nMesIniPag,lPrnFec,dFecPrn,;
				@aVlrEst,@nFacEst,;
				@nPagMes,@nSdoAct,;
				@nPagFin,@nSdoFin)

	    nPagMes := IF(nTipInf==1 .OR. nTipInf==3,nPagMes,nPagFin)
	    nSdoAct := IF(nTipInf==1 .OR. nTipInf==3,nSdoAct,nSdoFin)
**********CALCULO DE LA FACTURACION DEL MES

**********IMPRESION DE LOS PAGOS
	    FOR i := 2 TO PAG->nMesIniPag
		IF PAG->nMesIniPag == i

		   nTotFac += nFacEst
		   nTotPag += nPagMes

		   IF 'F' $ cHayErr
		      cErrFac += 'F'
		      AADD(aTitFac,'E:'+TRANS(nFacEst,'99999999'))
		   ELSE
		      AADD(aTitFac,TRANS(nFacEst,'##,###,###'))
		   ENDIF
		   AADD(aTitPag,TRANS(nPagMes,'##,###,###'))

		   IF 'S' $ cHayErr
		      cErrFac += 'S'
		      AADD(aTitSdo,'E:'+TRANS(nSdoAct,'99999999'))
		   ELSE
		      AADD(aTitSdo,TRANS(nSdoAct,'##,###,###'))
		   ENDIF
		   AADD(aMesFac,i)
		ELSE
		   IF ASCAN(aMesFac,i) == 0
		      AADD(aTitFac,SPACE(01))
		      AADD(aTitPag,SPACE(01))
		      AADD(aTitSdo,SPACE(01))
		      AADD(aMesFac,i)
		   ENDIF
		ENDIF
	    ENDFOR
**********FIN IMPRESION DE LOS PAGOS

	  PAG->(DBSKIP())

       ENDDO

       FOR i := 2 TO 11
	   IF ASCAN(aMesFac,i) == 0
	      AADD(aTitFac,SPACE(01))
	      AADD(aTitPag,SPACE(01))
	      AADD(aTitSdo,SPACE(01))
	   ENDIF
       ENDFOR

       IF 'F' $ cErrFac
	  AADD(aTitFac,'E:'+TRANS(nTotFac,'########'))
       ELSE
	  AADD(aTitFac,TRANS(nTotFac,'##,###,###'))
       ENDIF

       AADD(aTitPag,TRANS(nTotPag,'##,###,###'))

       IF 'S' $ cErrFac
	  AADD(aTitSdo,'E:'+TRANS(nSdoAct,'########'))
       ELSE
	  AADD(aTitSdo,TRANS(nSdoAct,'##,###,###'))
       ENDIF
*>>>>FIN RECORRIDO DE LOS PAGOS

*>>>>IMPRESION DE LOS DATOS DE LOS ESTUDIANTES
       aColFac := ACLONE(aNroCol)
       cMaeAct := cAliasNiv(VAL(SUBS(cCodGru,1,2)))

       IF nOpcPrn == 7  // A Archivo Dbf

	  AADD(aTitFac,RTRIM(&cMaeAct->cNomPadEst)+' '+;
		       RTRIM(&cMaeAct->cApePadEst))
	  AADD(aColFac,70)

	  AADD(aTitFac,&cMaeAct->cPadNitEst)
	  AADD(aColFac,16)

	  AADD(aTitFac,RTRIM(&cMaeAct->cNomMadEst)+' '+;
		       RTRIM(&cMaeAct->cApeMadEst))
	  AADD(aColFac,70)

	  AADD(aTitFac,&cMaeAct->cMadNitEst)
	  AADD(aColFac,16)

	  AADD(aTitFac,ALLTRIM(&cMaeAct->cDireccEst)+','+;
		       ALLTRIM(&cMaeAct->cBarrioEst)+','+;
		       ALLTRIM(&cMaeAct->cCiudadEst))
	  AADD(aColFac,86)

	  AADD(aTitFac,&cMaeAct->cTelefnEst)
	  AADD(aColFac,14)

       ENDIF
*>>>>FIN IMPRESION DE LOS DATOS DE LOS ESTUDIANTES

*>>>>IMPRESION DE LOS TOTALES
       IF !lSiPaso
	  nHanXml := CreaFrmPrn(lShared,FilePrn,aColFac,nOpcPrn,aCabPrn,aTitPrn)
	  lSiPaso := .T.
       ENDIF
     *ÀCreaci¢n del archivo de impresi¢n

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aTitFac,aColFac,bPagina,bDerAut,bCabeza)

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aTitPag,aColFac,bPagina,bDerAut,bCabeza)

       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aTitSdo,aColFac,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>GRABACION DEL REGISTRO DE FACTURACION
       IF TEM->(lRegLock(lShared,.T.))

	  REPL TEM->cCodigoEst WITH aTitFac[1]
	  REPL TEM->cCodigoGru WITH aTitFac[2]
	  REPL TEM->cDescriPrn WITH aTitFac[3]
	  REPL TEM->cVlrMatPrn WITH aTitFac[4]
	  REPL TEM->cMesFebPrn WITH aTitFac[5]
	  REPL TEM->cMesMarPrn WITH aTitFac[6]
	  REPL TEM->cMesAbrPrn WITH aTitFac[7]
	  REPL TEM->cMesMayPrn WITH aTitFac[8]
	  REPL TEM->cMesJunPrn WITH aTitFac[9]
	  REPL TEM->cMesJulPrn WITH aTitFac[10]
	  REPL TEM->cMesAgoPrn WITH aTitFac[11]
	  REPL TEM->cMesSepPrn WITH aTitFac[12]
	  REPL TEM->cMesOctPrn WITH aTitFac[13]
	  REPL TEM->cMesNovPrn WITH aTitFac[14]
	  REPL TEM->cVrlTotPrn WITH aTitFac[15]
	  REPL TEM->cNomPadPrn WITH RTRIM(&cMaeAct->cNomPadEst)+' '+;
				    RTRIM(&cMaeAct->cApePadEst)
	  REPL TEM->cPadNitPrn WITH &cMaeAct->cPadNitEst
	  REPL TEM->cNomMadPrn WITH RTRIM(&cMaeAct->cNomMadEst)+' '+;
				    RTRIM(&cMaeAct->cApeMadEst)
	  REPL TEM->cMadNitPrn WITH &cMaeAct->cMadNitEst
	  REPL TEM->cDireccPrn WITH ALLTRIM(&cMaeAct->cDireccEst)+','+;
				    ALLTRIM(&cMaeAct->cBarrioEst)+','+;
				    ALLTRIM(&cMaeAct->cCiudadEst)
	  REPL TEM->cTelefnPrn WITH &cMaeAct->cTelefnEst
	  TEM->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO DE IMPRESION')
       ENDIF
       IF lShared
	  TEM->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL REGISTRO DE FACTURACION

*>>>>GRABACION DEL REGISTRO DE PAGOS
       IF TEM->(lRegLock(lShared,.T.))

	  REPL TEM->cCodigoEst WITH aTitPag[1]
	  REPL TEM->cCodigoGru WITH aTitPag[2]
	  REPL TEM->cDescriPrn WITH aTitPag[3]
	  REPL TEM->cVlrMatPrn WITH aTitPag[4]
	  REPL TEM->cMesFebPrn WITH aTitPag[5]
	  REPL TEM->cMesMarPrn WITH aTitPag[6]
	  REPL TEM->cMesAbrPrn WITH aTitPag[7]
	  REPL TEM->cMesMayPrn WITH aTitPag[8]
	  REPL TEM->cMesJunPrn WITH aTitPag[9]
	  REPL TEM->cMesJulPrn WITH aTitPag[10]
	  REPL TEM->cMesAgoPrn WITH aTitPag[11]
	  REPL TEM->cMesSepPrn WITH aTitPag[12]
	  REPL TEM->cMesOctPrn WITH aTitPag[13]
	  REPL TEM->cMesNovPrn WITH aTitPag[14]
	  REPL TEM->cVrlTotPrn WITH aTitPag[15]
	  REPL TEM->cNomPadPrn WITH RTRIM(&cMaeAct->cNomPadEst)+' '+;
				    RTRIM(&cMaeAct->cApePadEst)
	  REPL TEM->cPadNitPrn WITH &cMaeAct->cPadNitEst
	  REPL TEM->cNomMadPrn WITH RTRIM(&cMaeAct->cNomMadEst)+' '+;
				    RTRIM(&cMaeAct->cApeMadEst)
	  REPL TEM->cMadNitPrn WITH &cMaeAct->cMadNitEst
	  REPL TEM->cDireccPrn WITH ALLTRIM(&cMaeAct->cDireccEst)+','+;
				    ALLTRIM(&cMaeAct->cBarrioEst)+','+;
				    ALLTRIM(&cMaeAct->cCiudadEst)
	  REPL TEM->cTelefnPrn WITH &cMaeAct->cTelefnEst
	  TEM->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO DE IMPRESION')
       ENDIF
       IF lShared
	  TEM->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL REGISTRO DE PAGOS

*>>>>GRABACION DEL REGISTRO DE SALDOS
       IF TEM->(lRegLock(lShared,.T.))

	  REPL TEM->cCodigoEst WITH aTitSdo[1]
	  REPL TEM->cCodigoGru WITH aTitSdo[2]
	  REPL TEM->cDescriPrn WITH aTitSdo[3]
	  REPL TEM->cVlrMatPrn WITH aTitSdo[4]
	  REPL TEM->cMesFebPrn WITH aTitSdo[5]
	  REPL TEM->cMesMarPrn WITH aTitSdo[6]
	  REPL TEM->cMesAbrPrn WITH aTitSdo[7]
	  REPL TEM->cMesMayPrn WITH aTitSdo[8]
	  REPL TEM->cMesJunPrn WITH aTitSdo[9]
	  REPL TEM->cMesJulPrn WITH aTitSdo[10]
	  REPL TEM->cMesAgoPrn WITH aTitSdo[11]
	  REPL TEM->cMesSepPrn WITH aTitSdo[12]
	  REPL TEM->cMesOctPrn WITH aTitSdo[13]
	  REPL TEM->cMesNovPrn WITH aTitSdo[14]
	  REPL TEM->cVrlTotPrn WITH aTitSdo[15]
	  REPL TEM->cNomPadPrn WITH RTRIM(&cMaeAct->cNomPadEst)+' '+;
				    RTRIM(&cMaeAct->cApePadEst)
	  REPL TEM->cPadNitPrn WITH &cMaeAct->cPadNitEst
	  REPL TEM->cNomMadPrn WITH RTRIM(&cMaeAct->cNomMadEst)+' '+;
				    RTRIM(&cMaeAct->cApeMadEst)
	  REPL TEM->cMadNitPrn WITH &cMaeAct->cMadNitEst
	  REPL TEM->cDireccPrn WITH ALLTRIM(&cMaeAct->cDireccEst)+','+;
				    ALLTRIM(&cMaeAct->cBarrioEst)+','+;
				    ALLTRIM(&cMaeAct->cCiudadEst)
	  REPL TEM->cTelefnPrn WITH &cMaeAct->cTelefnEst
	  TEM->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL REGISTRO DE IMPRESION')
       ENDIF
       IF lShared
	  TEM->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO DE SALDOS

/*************************************************************************
* TITULO..: FACTURACION DEL ESTUDIANTE                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 12/2004 MIE A
       Bucaramanga, Colombia	    INICIO: 02:00 PM   MAY 12/2004 MIE

OBJETIVOS:

1- Calcula la Facturaci¢n del Mes de un Estudiante

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFactEst(cAnoUsr,cCodEst,lEstRet,nMesIni,lPrnFec,dFecPrn,;
		  aVlrEst,nTotFac,nPagMes,nTotSdo,nPagFin,nSdoFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoUsr                              // A¤o del usuario
       cCodEst                              // C¢digo del Estudiante
       lEstRet                              // Estudiante Retirado
       nMesIni                              // Mes Inicial
       lPrnFec                              // Imprimir por Fechas
       dFecPrn                              // Fecha de Corte
       aVlrEst                              // Facturaci¢n del Estudiante
       nTotFac                              // @Total Facturaci¢n
       nPagMes			            // @Total Valor Pagado del Mes
       nTotSdo                              // Valor del Saldo Actual
       nPagFin                              // @Total Pagado fin de mes
       nSdoFin                              // Saldo Actual a fin de mes */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #DEFINE nDEUANT 1                    // Deuda Anterior
       #DEFINE nMORANT 2                    // Mora Anterior
       #DEFINE nVLRMES 3                    // Valor del Mes

       LOCAL cHayErr := ''                   // '' => No hay Error F=> Error en Anticipos S=> Error en Saldos
       LOCAL       i := 0                   // Contador
       LOCAL aRegEst := {}                  // Valor del Estudiante
       LOCAL aVlrNiv := {}                  // Totales por conceptos por nivel
       LOCAL aVlrTot := {}                  // Totales por conceptos
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL lFPagOk := .T.                 // Fecha de Pago de Acuerdo al Corte
       LOCAL lFinMes := .F.                 // .T. Hay pagos de fin de Mes
       LOCAL aFacMes[16]                     // Facturaci¢n del Mes. 8 Conceptos
       LOCAL aAntici[16]                     // Anticipos. 8 Conceptos
       LOCAL nAntici := 0                   // Valor de los Anticipos
       LOCAL nFacMes := 0                   // Facturaci¢n del Mes
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nVlrRec := 0                   // Valor del Recargo
       LOCAL nVlrBec := 0                   // Valor de la Beca
       LOCAL nTotDes := 0                   // Total de Descuentos
       LOCAL nTotRec := 0                   // Total de Recargos
       LOCAL nTotBec := 0                   // Total de Becas
       LOCAL nVlrMes := 0                   // Valor de lo facturado

       LOCAL nDeuInt := 0                   // Deuda Anterior para calcular los intereses por cobrar
       LOCAL nAboDes := 0                   // Abonos Descuentos
       LOCAL nAboMes := 0                   // Abonos del Mes
       LOCAL nAboOtr := 0                   // Abonos otros Meses
       LOCAL nAboFin := 0                   // Total Abonos de fin de mes
       LOCAL nOtrFin := 0                   // Total Abonos otros meses de fin de mes
       LOCAL nDesFin := 0                   // Total Abonos Descuentos de fin de mes
       LOCAL nDesMes := 0                   // Total de Abonos como Descuentos

       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nTotPag := 0                   // Total Pagos
       LOCAL nFinMes := 0                   // Total de pagos de fin de mes

       LOCAL lMesAct := .T.                 // .T. Mes Actual.
       LOCAL nNroEst := 0                   // N£mero de Estudiantes

       LOCAL nVlrTar := ''                  // Valor de las tarifas
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nIntCob := 0                   // Intereses por Cobrar

       LOCAL nVlrSdo := 0                   // Valor del saldo
       LOCAL nVlrDeu := 0                   // Valor de la deuda
       LOCAL nPorCob := 0                   // Intereses por Cobrar

       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nSdoMor := 0                   // Saldo de la Mora
       LOCAL nNroDeu := 0                   // N£mero de Deudores
       LOCAL nNroExt := 0                   // N£mero de Extemporaneos

       LOCAL nDeuRet := 0                   // Deuda Anterior del Retirado
       LOCAL nMorRet := 0                   // Mora Anterior del Retirado
       LOCAL nMesRet := 0                   // Mes del ultimo recibo
       LOCAL aDeuAnt := {}                  // Codigos deuda Anterior
       LOCAL aRetMor := {}                  // Retirado con Mora

       LOCAL aFacEst := {}                  // Facturaci¢n del Estudiante
       LOCAL aFacFin := {}                  // Facturaci¢n a Fin de Mes
       LOCAL nTotal  := 0                   // Gran total de la facturaci¢n
       LOCAL nTotFin := 0                   // Gran Total de la Facturaci¢n de fin de mes

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE ACUMULADORES
       aRegEst := {0,; // Deuda Anterior
		   0,; // Mora Anterior
		   0}  // Valor del Mes

       AFILL(aAntici,0)
*>>>>FIN INICIALIZACION DE ACUMULADORES

*>>>>LOCALIZACION DEL PAGO
       lHayPag := .F.
       lHayPag := lLocCodPag(cCodEst,nMesIni,.F.)
*>>>>FIN LOCALIZACION DEL PAGO

*>>>>INICIALIZACION DE ACUMULADORES
       aVlrEst := {0,0,0,0,0}                 // Saldo
       aVlrNiv := {0,0,0,0,0}
       aVlrTot := {0,0,0,0,0}
       FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2
	   AADD(aVlrEst,0)                    // Conceptos Mes
	   AADD(aVlrNiv,0)
	   AADD(aVlrTot,0)
       ENDFOR
       AADD(aVlrEst,0)                        // Int Pago Mes
       AADD(aVlrEst,0)                        // Anticipos
       AADD(aVlrEst,0)                        // Total Nivel

       AADD(aVlrNiv,0)
       AADD(aVlrNiv,0)
       AADD(aVlrNiv,0)

       AADD(aVlrTot,0)
       AADD(aVlrTot,0)
       AADD(aVlrTot,0)
*>>>>FIN INICIALIZACION DE ACUMULADORES

*>>>>ANALISIS DE LA FECHA DE PAGO
       lFPagOk := .T.
       IF lPrnFec .AND. lHayPag
	  IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
	     IF PAG->dFecPagPag > dFecPrn
		lFPagOk := .F.
	     ENDIF
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA FECHA DE PAGO

*>>>>ANALISIS DEL PAGO DEL FIN DEL MES
       lFinMes := .F.
       IF !lPrnFec .AND.;
	  YEAR(PAG->dFecPagPag) == VAL(cAnoUsr) .AND.;
	  MONTH(PAG->dFecPagPag) <= nMesIni
	  lFinMes := .T.
       ENDIF
*>>>>FIN ANALISIS DEL PAGO DEL FIN DEL MES

*>>>>CALCULO DE LOS DIFERENTES PAGOS
       AFILL(aFacMes,0)
       nFacMes := 0
       IF lHayPag

**********SUMATORIA DE AYUDAS,DESCUENTOS,RECARGOS
	    nVlrDes := PAG->nVlrDesPag+PAG->nDesGenPag
	    nVlrRec := PAG->nVlrRecPag+PAG->nRecGenPag
	    nVlrBec := PAG->nVlrBecPag
	    nTotDes += nVlrDes
	    nTotRec += nVlrRec
	    nTotBec += nVlrBec
**********FIN SUMATORIA DE AYUDAS,DESCUENTOS,RECARGOS

**********DETALLES DEL REGISTRO DE PAGOS DEL ESTUDIANTE
		     nVlrMes := PAG->nVlrMesPag
	    aRegEst[nDEUANT] := PAG->nSdoAntPag
	    aRegEst[nMORANT] := PAG->nMorAntPag
	    aRegEst[nVLRMES] := nVlrMes
**********FIN DETALLES DEL REGISTRO DE PAGOS DEL ESTUDIANTE

**********LOCALIZACION DEL ABONO
	    nDeuInt := 0
	    nAboDes := 0
	    SELECT DES
	    GO TOP
	    LOCATE FOR DES->cCodigoEst == cCodEst .AND.;
		       DES->nTipDesDes == 3 .AND.;
		       (DES->nNroMesDes == nMesIni .OR.;
			DES->nMesModDes == nMesIni)

	    IF DES->(FOUND())

*--------------TOTALIZACION DE LOS ABONOS
		 nAboMes += nVlrAbo(cCodEst,cAnoUsr,;
				    nMesIni,@nDeuInt,;
				    @nAboOtr,@nAboDes,;
				    @nAboFin,@nOtrFin,@nDesFin,;
				    lPrnFec,dFecPrn,aRegEst)
		 nDesMes += nAboDes
*--------------FIN TOTALIZACION DE LOS ABONOS

*--------------DEUDA ANTERIOR
		 nDeuAnt += PAG->nSdAbonPag
		 nMorAnt += PAG->nMoAbonPag

		 IF PAG->nSdAbonPag+PAG->nMoAbonPag # 0
		    AADD(aDeuAnt,{cCodEst,;
				  PAG->nSdAbonPag,;
				  PAG->nMoAbonPag})
		 ENDIF
*--------------FIN DEUDA ANTERIOR

	    ELSE

*--------------DEUDA ANTERIOR
		 nDeuAnt += PAG->nSdoAntPag
		 nMorAnt += PAG->nMorAntPag

		 IF PAG->nSdoAntPag+PAG->nMorAntPag # 0
		    AADD(aDeuAnt,{cCodEst,;
				  PAG->nSdoAntPag,;
				  PAG->nMorAntPag})
		 ENDIF

		 IF PAG->nMesAmnPag == PAG->nMesIniPag
		    nDeuInt := nVlrMes()
		 ELSE
		    nDeuInt := PAG->nSdoAntPag+nVlrMes()
		 ENDIF
*--------------FIN DEUDA ANTERIOR

	    ENDIF
**********FIN LOCALIZACION DEL ABONO

**********TOTALIZACION DE LOS PAGOS PARCIALES
	    nVlrMes := aRegEst[nVLRMES]
	    IF PAG->nPagParPag # 0
	       SELECT DES
	       GO TOP
	       LOCATE FOR DES->cCodigoEst == cCodEst .AND.;
			  DES->nTipDesDes == 4 .AND.;
			  DES->nNroMesDes == nMesIni

	       IF DES->(FOUND())
		  IF lPrnFec
		     IF DES->dFechaDes <= dFecPrn
			nTotPag += PAG->nPagParPag
		     ELSE
			aRegEst[nVLRMES] += PAG->nPagParPag
		       *Revierte el pago parcial.
		     ENDIF
		  ELSE
		     nTotPag += PAG->nPagParPag
		     IF YEAR(DES->dFechaDes) == VAL(cAnoUsr) .AND.;
			MONTH(DES->dFechaDes) <= nMesIni
			nFinMes += PAG->nPagParPag
		     ENDIF
		  ENDIF
	       ENDIF
	    ENDIF
**********FIN TOTALIZACION DE LOS PAGOS PARCIALES

**********ANALISIS SI ES EL MES ACTUAL
	    lMesAct := .T.
	    IF nMesIni < LEN(RTRIM(CLI->cMesPagCli))
	       lMesAct := .F.
	    ENDIF
	    nNroEst++
**********FIN ANALISIS SI ES EL MES ACTUAL

**********CALCULO PARA CADA UNO DE LOS CONCEPTOS
	    nFacMes := 0
	    FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

*---------------LOCALIZACION DEL VALOR DEL CONCEPTO
		  cCodigoTco := SUBS(ALLTRIM(PAG->cConcepPag),i*2-1,2)
		  IF cCodigoTco $ PAG->cConcepPag
		     nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
		     nVlrTar := &('PAG->nVlrCo'+STR(nNroPos,1)+'Pag')
		  ELSE
		     nVlrTar := 0
		  ENDIF
*---------------FIN LOCALIZACION DEL VALOR DEL CONCEPTO

*---------------FACTURACION DEL MES PARA CADA CONCEPTO
		      nFacMes  += nVlrTar
		  aFacMes[i] := nVlrTar
		  aVlrEst[i+5] += nVlrTar
		  aVlrTot[i+5] += nVlrTar
		  aVlrNiv[i+5] += nVlrTar
*---------------FIN FACTURACION DEL MES PARA CADA CONCEPTO

*---------------TOTALES DEL GRUPO
		  aVlrEst[LEN(aVlrEst)] += nVlrTar
		  aVlrNiv[LEN(aVlrNiv)] += nVlrTar
		  aVlrTot[LEN(aVlrTot)] += nVlrTar
*---------------FIN TOTALES DEL GRUPO

	    ENDFOR
**********FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS

**********CALCULO DE LOS INTERESES ACTUALES
	    nVlrInt := nIntMesPag(CAA->lIntPenCaA,;
				  aRegEst[nDEUANT],;
				  nVlrMes,;
				  PAG->nMesIniPag,;
				  CAA->nMesAmnCaA)
**********FIN CALCULO DE LOS INTERESES ACTUALES

**********CALCULO DE OTROS TOTALES
	    aRegEst[nDEUANT] += PAG->nSdoAnoPag
	    aRegEst[nMORANT] += PAG->nMorAnoPag

	    DO CASE
	    CASE PAG->cEstadoPag == 'P' .OR.;
		 PAG->cEstadoPag == 'A'

*----------------ANALISIS DEL PAGO DE ACUERDO A LA FECHA
		   IF lPrnFec
		      IF lFPagOk
			 nTotPag += PAG->nVlrPagPag
			 IF PAG->cEstadoPag == 'A'
			    nTotPag += nVlrInt
			 ENDIF
		      ENDIF
		   ELSE
		      nTotPag += PAG->nVlrPagPag
		      IF lFinMes
			 nFinMes += PAG->nVlrPagPag
		      ENDIF

		      IF PAG->cEstadoPag == 'A'
			 nTotPag += nVlrInt
			 IF lFinMes
			    nFinMes += nVlrInt
			 ENDIF
		      ENDIF
		   ENDIF
*----------------FIN ANALISIS DEL PAGO DE ACUERDO A LA FECHA

*----------------CALCULO DE LAS DEUDAS POR PAGO FUERA DE CORTE
		   IF CAA->nMesAmnCaA # nMesIni .AND.;
		      lPrnFec .AND. !lFPagOK

		      *REGISTRO DEL SALDO ACTUAL
			 IF PAG->cEstadoPag == 'A'
			    nPorCob := nVlrInt+aRegEst[nMORANT]
			 ELSE
			    nPorCob := aRegEst[nMORANT]
			 ENDIF
			 nVlrDeu := aRegEst[nDEUANT]+;
				    aRegEst[nVLRMES]
			 nVlrSdo := nVlrDeu+nPorCob

			 RegSdoAct(nVlrSdo,nVlrDeu,nPorCob,nVlrInt,;
				   aRegEst[nMORANT],aVlrEst,aVlrNiv,;
				   aVlrTot)
		      *FIN REGISTRO DEL SALDO ACTUAL

		   ENDIF
*----------------FIN CALCULO DE LAS DEUDAS POR PAGO FUERA DE CORTE

*----------------CALCULOS DE LAS DEUDAS POR AMNISTIA
		   IF CAA->nMesAmnCaA == nMesIni

		     *REGISTRO DEL SALDO ACTUAL
			nSdoAct := IF(lMesAct,CLI->nSdoActCli,;
					      PAG->nSdoAntPag)

			nSdoMor := IF(lMesAct,CLI->nSdoMorCli,;
					      PAG->nMorAntPag)
			IF nSdoAct+nSdoMor
			   nNroDeu++
			   nVlrSdo := nSdoAct+nSdoMor
			   nVlrDeu := nSdoAct
			   nPorCob := nSdoMor

			   RegSdoAct(nVlrSdo,nVlrDeu,nPorCob,0,;
				     nSdoMor,aVlrEst,aVlrNiv,;
				     aVlrTot)
			ENDIF
		     *FIN REGISTRO DEL SALDO ACTUAL

		   ENDIF
*----------------FIN CALCULOS DE LAS DEUDAS POR AMNISTIA

*----------------VALOR DE LOS INTERESES
		   IF PAG->cEstadoPag == 'A'
		      nNroExt++

		      aVlrEst[LEN(aVlrEst)-2] += nVlrInt
		      aVlrNiv[LEN(aVlrNiv)-2] += nVlrInt
		      aVlrTot[LEN(aVlrTot)-2] += nVlrInt
		    *ÀValor Recargo

		      aVlrEst[LEN(aVlrEst)] += nVlrInt
		      aVlrNiv[LEN(aVlrNiv)] += nVlrInt
		      aVlrTot[LEN(aVlrTot)] += nVlrInt
		     *Total del grupo
		   ENDIF
*----------------FIN VALOR DE LOS INTERESES

*----------------VALOR DE LOS ANTICIPOS
		   IF PAG->nMesIniPag # PAG->nMesFinPag
		      Anticipos(aFacMes,;
			       (nNroMesFac(PAG->nMesIniPag,;
				PAG->nMesFinPag)-1),aAntici)
		    // Ojo pendiente para los Anticipos variables por meses

		      nAntici := nFacMes*;
		      (nNroMesFac(PAG->nMesIniPag,PAG->nMesFinPag)-1)

		      aVlrEst[LEN(aVlrEst)-1] += nAntici
		      aVlrNiv[LEN(aVlrNiv)-1] += nAntici
		      aVlrTot[LEN(aVlrTot)-1] += nAntici
		    *ÀAnticipos

		      aVlrEst[LEN(aVlrEst)] += nAntici
		      aVlrNiv[LEN(aVlrNiv)] += nAntici
		      aVlrTot[LEN(aVlrTot)] += nAntici
		    *ÀTotal del grupo

		      IF lPrnFec .AND. !lFPagOK
			 aVlrEst[1] += nAntici
			 aVlrNiv[1] += nAntici
			 aVlrTot[1] += nAntici
		       *ÀSaldo

			 aVlrEst[2] += nAntici
			 aVlrNiv[2] += nAntici
			 aVlrTot[2] += nAntici
		       *ÀDeuda
		      ENDIF
		    *ÀAnticipo como saldo

		   ENDIF
*----------------FIN VALOR DE LOS ANTICIPOS

	    CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

*----------------ANALISIS DE LA FORMA DE NO PAGO
		   nNroDeu++
		   IF PAG->cEstadoPag = 'D'

*.....................REGISTRO DEL SALDO ACTUAL
			nPorCob := nVlrInt+aRegEst[nMORANT]
			nVlrDeu := aRegEst[nDEUANT]+aRegEst[nVLRMES]
			nVlrSdo := nVlrDeu+nPorCob

			RegSdoAct(nVlrSdo,nVlrDeu,nPorCob,nVlrInt,;
				  aRegEst[nMORANT],aVlrEst,aVlrNiv,;
				  aVlrTot)
*.....................FIN REGISTRO DEL SALDO ACTUAL

*.....................INTERESES POR COBRAR SIN ABONOS
			nIntCob += nVlrInt(nDeuInt)

			aVlrEst[LEN(aVlrEst)] += nVlrInt
			aVlrNiv[LEN(aVlrNiv)] += nVlrInt
			aVlrTot[LEN(aVlrTot)] += nVlrInt
		       *Total del grupo
*.....................FIN INTERESES POR COBRAR SIN ABONOS

		   ELSE

*.....................SALDO ACTUAL
			aVlrEst[1] += CLI->nSdoActCli+CLI->nSdoMorCli
			aVlrNiv[1] += CLI->nSdoActCli+CLI->nSdoMorCli
			aVlrTot[1] += CLI->nSdoActCli+CLI->nSdoMorCli
*.....................FIN SALDO ACTUAL

*.....................DEUDA SIN INTERESES
			aVlrEst[2] += CLI->nSdoActCli
			aVlrNiv[2] += CLI->nSdoActCli
			aVlrTot[2] += CLI->nSdoActCli
*.....................FIN DEUDA SIN INTERESES

*.....................INTERESES POR COBRAR
			aVlrEst[3] += CLI->nSdoMorCli
			aVlrNiv[3] += CLI->nSdoMorCli
			aVlrTot[3] += CLI->nSdoMorCli
*.....................FIN INTERESES POR COBRAR

*.....................INTERESES POR COBRAR ANTERIORES
			aVlrEst[5] += PAG->nMorAntPag
			aVlrNiv[5] += PAG->nMorAntPag
			aVlrTot[5] += PAG->nMorAntPag
*.....................FIN INTERESES POR COBRAR ANTERIORES

		   ENDIF
*----------------FIN ANALISIS DE LA FORMA DE NO PAGO

	    ENDCASE
**********FIN CALCULO DE OTROS TOTALES

       ELSE

**********ESTUDIANTE RETIRADO CON SALDO
	    IF lEstRet .AND. CLI->nSdoActCli+CLI->nSdoMorCli # 0

	       nDeuAnt += CLI->nSdoActCli
	       nMorAnt += CLI->nSdoMorCli

	       AADD(aDeuAnt,{cCodEst,;
			     CLI->nSdoActCli,;
			     CLI->nSdoMorCli})
	      *Saldo Anterior

*--------------SALDO ACTUAL
		 aVlrEst[1] += CLI->nSdoActCli+CLI->nSdoMorCli
		 aVlrNiv[1] += CLI->nSdoActCli+CLI->nSdoMorCli
		 aVlrTot[1] += CLI->nSdoActCli+CLI->nSdoMorCli
*--------------FIN SALDO ACTUAL

*--------------DEUDA SIN INTERESES
		 aVlrEst[2] += CLI->nSdoActCli
		 aVlrNiv[2] += CLI->nSdoActCli
		 aVlrTot[2] += CLI->nSdoActCli
*--------------FIN DEUDA SIN INTERESES

*--------------INTERESES POR COBRAR
		 aVlrEst[3] += CLI->nSdoMorCli
		 aVlrNiv[3] += CLI->nSdoMorCli
		 aVlrTot[3] += CLI->nSdoMorCli
*--------------FIN INTERESES POR COBRAR

*--------------INTERESES POR COBRAR ANTERIORES
		 aVlrEst[5] += CLI->nSdoMorCli
		 aVlrNiv[5] += CLI->nSdoMorCli
		 aVlrTot[5] += CLI->nSdoMorCli
*--------------FIN INTERESES POR COBRAR ANTERIORES

	    ENDIF
**********FIN ESTUDIANTE RETIRADO CON SALDO

**********ESTUDIANTE RETIRADO SIN SALDO
	    IF lEstRet .AND. CLI->nSdoActCli+CLI->nSdoMorCli == 0

*--------------LOCALIZACION DEL PAGO
		 nMesRet := LEN(RTRIM(CLI->cMesPagCli))
		 IF nMesIni < nMesRet
		    nMesRet := nMesIni
		 ENDIF
		 lHayPag := .F.
		 lHayPag := lLocCodPag(cCodEst,nMesRet,.F.)
*--------------FIN LOCALIZACION DEL PAGO

*--------------ANALISIS DE LA FECHA DE PAGO
		 lFPagOk := .T.
		 IF lPrnFec .AND. lHayPag
		    IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
		       IF PAG->dFecPagPag > dFecPrn
			  lFPagOk := .F.
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS DE LA FECHA DE PAGO

*--------------ANALISIS DEL PAGO DEL FIN DEL MES
		 lFinMes := .F.
		 IF !lPrnFec .AND.;
		    YEAR(PAG->dFecPagPag) == VAL(cAnoUsr) .AND.;
		    MONTH(PAG->dFecPagPag) <= nMesIni
		    lFinMes := .T.
		 ENDIF
*--------------FIN ANALISIS DEL PAGO DEL FIN DEL MES

*--------------CALCULO DE LA DEUDA
		 IF lHayPag    .AND.;
		    ((!lPrnFec .AND. lFPagOk) .OR.;
		     (lPrnFec  .AND. !lFPagOk)) .AND. !lFinMes

		     nVlrDeu := PAG->nSdoAntPag+PAG->nVlrMesPag
		     nSdoMor := PAG->nMorAntPag

		     AADD(aRetMor,{cCodEst,;
				   nVlrDeu,nSdoMor})

		     nDeuRet += nVlrDeu
		     nMorRet += nSdoMor

		     nVlrInt := 0
		     IF PAG->cEstadoPag == 'A'
			nVlrInt += nVlrIntPag(CAA->lIntPenCaA,;
					      PAG->nMesIniPag,;
					      CAA->nMesAmnCaA)
			nMorRet += nVlrInt
		     ENDIF
		 ENDIF
*--------------FIN CALCULO DE LA DEUDA

*--------------REGISTRO DEL SALDO ACTUAL
		 IF lHayPag .AND.;
		    lPrnFec .AND. !lFPagOk

		    nVlrSdo := nVlrDeu+nSdoMor+nVlrInt

		    RegSdoAct(nVlrSdo,nVlrDeu,nSdoMor+nVlrInt,;
			      nVlrInt,nSdoMor,aVlrEst,aVlrNiv,;
			      aVlrTot)
		  ENDIF
*--------------FIN REGISTRO DEL SALDO ACTUAL

	    ENDIF
**********FIN ESTUDIANTE RETIRADO SIN SALDO

       ENDIF
*>>>>FIN CALCULO DE LOS DIFERENTES PAGOS

*>>>>TOTALES DE LOS CONCEPTOS
       nTotal := 0

       aFacEst := {}
       aFacFin := {}
       FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

	 cCodigoTco := SUBS(ALLTRIM(PAG->cConcepPag),i*2-1,2)
	 cNombreTco := cCodigoTco

	 IF lLocCodigo('cCodigoCon','CON',cCodigoTco)
	    cNombreTco := CON->cNombreCon
	 ENDIF
	 nTotal += aVlrEst[i+5]

	 AADD(aFacEst,{cNombreTco,aVlrEst[i+5]})
	 AADD(aFacFin,{cNombreTco,aVlrEst[i+5]})

       ENDFOR
*>>>>FIN TOTALES DE LOS CONCEPTOS

*>>>>OTROS TOTALES
       IF aVlrEst[LEN(aVlrEst)-1] # nSuma(aAntici)
	  cHayErr += 'F'   // Error en Anticipos
       ENDIF

       nTotal += aVlrEst[LEN(aVlrEst)-1]
       AADD(aFacEst,{'+ANTICIPOS         ',aVlrEst[LEN(aVlrEst)-1]})
       AADD(aFacFin,{'+ANTICIPOS         ',aVlrEst[LEN(aVlrEst)-1]})

       nTotal += nTotRec
       AADD(aFacEst,{'+RECARGOS          ',nTotRec})
       AADD(aFacFin,{'+RECARGOS          ',nTotRec})

       nTotal -= nTotBec
       AADD(aFacEst,{'-AYUDAS            ',nTotBec})
       AADD(aFacFin,{'-AYUDAS            ',nTotBec})

       nTotal -= nTotDes
       AADD(aFacEst,{'-DESCUENTOS        ',nTotDes})
       AADD(aFacFin,{'-DESCUENTOS        ',nTotDes})
*>>>>FIN OTROS TOTALES

*>>>>TOTALES FACTURACION DEL MES
       AADD(aFacEst,{'FACTURACION        ',nTotal})
       AADD(aFacFin,{'FACTURACION        ',nTotal})

       nTotal += aVlrEst[LEN(aVlrEst)-2]
       AADD(aFacEst,{'+INT PAGO MES      ',aVlrEst[LEN(aVlrEst)-2]})
       AADD(aFacFin,{'+INT PAGO MES      ',aVlrEst[LEN(aVlrEst)-2]})

       nTotal += nIntCob
       AADD(aFacEst,{'+INTxCobMes        ',nIntCob})
       AADD(aFacFin,{'+INTxCobMes        ',nIntCob})

       AADD(aFacEst,{'GRAN TOTAL         ',nTotal})
       AADD(aFacFin,{'GRAN TOTAL         ',nTotal})
       nTotFac := nTotal
*>>>>FIN TOTALES FACTURACION DEL MES

*>>>>CALCULO DEL SALDO ACTUAL
       nTotal += nDeuAnt
       AADD(aFacEst,{'+DEUDA ANTERIOR    ',nDeuAnt})
       AADD(aFacFin,{'+DEUDA ANTERIOR    ',nDeuAnt})

       nTotal += nMorAnt
       AADD(aFacEst,{'+MORA ANTERIOR     ',nMorAnt})
       AADD(aFacFin,{'+MORA ANTERIOR     ',nMorAnt})

       nTotFin := nTotal
       nTotal  -= nTotPag
       nTotFin -= nFinMes
       AADD(aFacEst,{'-PAGOS             ',nTotPag})
       AADD(aFacFin,{'-PAGOS             ',nFinMes})
       nPagMes := nTotPag
       nPagFin := nFinMes

       nTotal  -= nAboMes
       nTotFin -= nAboFin
       AADD(aFacEst,{'-ABONOS DESCUENTOS ',nAboMes})
       AADD(aFacFin,{'-ABONOS DESCUENTOS ',nAboFin})
       nPagMes += nAboMes
       nPagFin += nAboFin

       nTotal -= nAboOtr
       nTotFin -= nOtrFin
       AADD(aFacEst,{'-ABONOS OTROS MESES',nAboOtr})
       AADD(aFacFin,{'-ABONOS OTROS MESES',nOtrFin})

       IF EMPTY(dFecPrn)
	  nTotSdo := nTotal
	  AADD(aFacEst,{'SALDO ACTUAL       ',nTotSdo})

	  nSdoFin := nTotFin
	  IF nFinMes+nAboFin+nDesFin+nDeuRet+nMorRet # 0
	     nSdoFin := nTotFin+nDeuRet+nMorRet
	  ENDIF
	  AADD(aFacFin,{'SALDO ACTUAL FIN ME',nSdoFin})

       ELSE
	  nTotSdo := nTotal+nDeuRet+nMorRet
	  AADD(aFacFin,{'SALDO ACTUAL       ',nTotSdo})
       ENDIF
*>>>>FIN CALCULO DEL SALDO ACTUAL

*>>>>VALIDACION DE LA FACTURACION
       IF nTotSdo # aVlrEst[1]
	  cHayErr += 'S'  // Error en saldos
       ENDIF
       RETURN cHayErr
*>>>>FIN VALIDACION DE LA FACTURACION

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/2004 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 AM   MAY 19/2004 MAR

OBJETIVOS:

1- Crea la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaFacTot(lShared,nModCry,PathArc,cNomArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       cNomArc				    // Nombre del Archivo
       aStrDbf                              // @Estructura de las bases */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodigoEst","Character",06,0})
       AADD(aDbfStr,{"cCodigoGru","Character",04,0})
       AADD(aDbfStr,{"cDescriPrn","Character",06,0})
       AADD(aDbfStr,{"cVlrMatPrn","Character",16,2})
       AADD(aDbfStr,{"cMesFebPrn","Character",16,2})
       AADD(aDbfStr,{"cMesMarPrn","Character",16,2})
       AADD(aDbfStr,{"cMesAbrPrn","Character",16,2})
       AADD(aDbfStr,{"cMesMayPrn","Character",16,2})
       AADD(aDbfStr,{"cMesJunPrn","Character",16,2})
       AADD(aDbfStr,{"cMesJulPrn","Character",16,2})
       AADD(aDbfStr,{"cMesAgoPrn","Character",16,2})
       AADD(aDbfStr,{"cMesSepPrn","Character",16,2})
       AADD(aDbfStr,{"cMesOctPrn","Character",16,2})
       AADD(aDbfStr,{"cMesNovPrn","Character",16,2})
       AADD(aDbfStr,{"cVrlTotPrn","Character",16,2})
       AADD(aDbfStr,{"cNomPadPrn","Character",70,0})
       AADD(aDbfStr,{"cPadNitPrn","Character",16,0})
       AADD(aDbfStr,{"cNomMadPrn","Character",70,0})
       AADD(aDbfStr,{"cMadNitPrn","Character",16,0})
       AADD(aDbfStr,{"cDireccPrn","Character",86,0})
       AADD(aDbfStr,{"cTelefnPrn","Character",86,0})
*>>>>FIN DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(cNomArc,aDbfStr,"DBFNTX")
	    Proteger(cNomArc,nModCry)

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE

       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA