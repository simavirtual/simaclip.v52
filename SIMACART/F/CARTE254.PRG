/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: PAGOS POR GRUPOS                         MODULO No. 254

**************************************************************************
* TITULO..: PAGOS POR GRUPO                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 11/96 JUE A
       Bucaramanga, Colombia	    INICIO: 05:40 PM   JUL 11/96 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir el informe de la relaci¢n total de los ingresos y egresos
   que se efectuaron por los grupos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_254(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 2                   // L¡neas totales de control
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

       LOCAL lHayAlu := .F.                 // .T. Hay Alumnos
       LOCAL nVlrSdo := 0                   // Valor del saldo
       LOCAL nIntMor := 0                   // Intereses por mora
       LOCAL nVlrDeu := 0                   // Valor de la deuda
       LOCAL nVlrPag := 0                   // Valor de los pagos
       LOCAL   nPago := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrIng := 0                   // Valor de los ingresos
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL nVlrTar := 0                   // Valor de las tarifas
       LOCAL nFacMes := 0                   // Facturaci¢n del Mes
       LOCAL nVlrMes := 0                   // Valor de lo facturado

       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final

       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nIntNoP := 0                   // Valor de los intereses no pago

       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nTotMor := 0                   // Total intereses por mora
       LOCAL nTotDeu := 0                   // Total de la deuda
       LOCAL nTotPag := 0                   // Total de pagos
       LOCAL nTotInt := 0                   // Total de intereses
       LOCAL nTotIng := 0                   // Total de ingresos
       LOCAL nTotMes := 0                   // Total del Mes
       LOCAL nPagos  := 0                   // Pagos

       LOCAL nAluGru := 0                   // Alumnos del grupo
       LOCAL nSiPago := 0                   // Alumnos que pagaron
       LOCAL nNoPago := 0                   // Alumnos que no pagaron
       LOCAL nTotAlu := 0                   // Total de alumnos
       LOCAL nTotSiP := 0                   // Total alumnos que pagaron
       LOCAL nTotNoP := 0                   // Total alumnos que no pagaron


       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL       i := 1                   // Contador
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
     *ÀVariables temporales de campos
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
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
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

	   IF !lUseGru(lSiRed,cIntUno,cMaeAct,cAnoSis,lAnoAct)
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

*>>>>CAPTURA DEL MES A PAGAR
       SAVE SCREEN
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTORE SCREEN
       IF nMesIniTpa == 0
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       cNroMes := STR(nMesIniTpa,2)
       lCorrecion(@cNroMes)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct)     .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lSiRed) .OR.;
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
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE BAN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS BANCOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

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
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

/*
*>>>>LECTURA DEL INTERVALO DE FECHAS
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')
       IF CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA

	  IF lPregunta('DESEA EL INFORME POR INTERVALO DE FECHAS? No Si')

	     RESTSCREEN(0,0,24,79,cSavPan)
	     cSavPan := SAVESCREEN(0,0,24,79)
	     @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	     @ nFilInf+1,nColInf SAY 'FECHA INICIAL:' GET dFecIni PICT '@D'
	     @ nFilInf+2,nColInf SAY 'FECHA FINAL  :' GET dFecFin PICT '@D'
	     READ
	     RESTSCREEN(0,0,24,79,cSavPan)

	     IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
		CloseAll(aUseDbf)
		IF !lFileDelete(FileTem)
		   cError('NO SE BORRO EL ARCHIVO TEMPORAL')
		ENDIF
		RETURN NIL
	     ENDIF

	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS
*/

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := GRU->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'RELACION DE PAGOS POR GRUPOS',;
		   'CORRESPONDIENTE AL MES DE '+;
		   cMes(nMesIniTpa,10)+' DE '+cAnoUsr,;
		   'JORNADA: '+cJorTxt,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

/*
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*/

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {06,12,12,12,12,12,12,12,38}
       aTitulo := {'GRUPO ',;
		   'SALDO ACTUAL',;
		   'FACTCION MES',;
		   'INTxCOBMes',;
		   'TOTAL DEUDA ',;
		   'VALOR PAGOS ',;
		   'INT PAGMes',;
		   'TOTAL PAGADO',;
		   'ESTADISTICAS DEL PAGO '}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
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
	  FilePrn := SUBS(CAR->cSerFacCar,1,1)+'g'+cAnoUsr+cNroMes
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
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

	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
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
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseAll(aUseDbf)
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('MES DE PROCESO: '+cMes(nMesIniTpa)+'º'+;
			'IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********INICIALIZACION DE ACUMULADORES
	    nVlrSdo := 0
	    nIntMor := 0
	    nVlrDeu := 0
	    nVlrPag := 0
	    nIntPag := 0
	    nVlrIng := 0
	    nVlrMes := 0

	    nAluGru := 0
	    nSiPago := 0
	    nNoPago := 0
**********FIN INICIALIZACION DE ACUMULADORES

**********IMPRESION DEL TERMOMETRO
	    SET DEVICE TO SCREEN
	    Termometro(0,'IMPRIMIENDO EL GRUPO '+GRU->cCodigoGru)
	    Termometro(10)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DEL TERMOMETRO

**********IMPRESION DE LOS GRUPOS
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		 lRetadoTes := .F.
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,;
				       cMaeAlu,@cNalias,.F.)
		 IF lHayAlu
		    cCodigoTes := &cNalias->cCodigoEst
		    IF &cNalias->lRetiroEst
		       lRetadoTes := .T.
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------LOCALIZACION DEL PAGO
		 lHayPag := .F.
		 IF lHayAlu
		    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)
		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO

*--------------CALCULO DE LOS INTERESES ACUMULACION DE PAGOS
		 nAluGru := CLI->(RECCOUNT())
		 nFacMes := 0
		 IF lHayAlu .AND. lHayPag

*...................FACTURACION DEL MES
		      nFacMes := 0
		      FOR i := 1 TO LEN(PAG->cConcepPag)/2

*                         LOCALIZACION DEL VALOR DEL CONCEPTO
			    cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)
			    IF cCodigoTco $ PAG->cConcepPag
			       nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
			       nVlrTar := &('nVlrCo'+STR(nNroPos,1)+'Pag')
			    ELSE
			       nVlrTar := 0
			    ENDIF
			    nFacMes += nVlrTar
*                         FIN LOCALIZACION DEL VALOR DEL CONCEPTO

		      ENDFOR
*...................FIN FACTURACION DEL MES

*...................CALCULO DE LOS INTERESES
		      nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)

		      nIntNoP := nVlrIntNoP(CAA->lIntPenCaA,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)
*...................FIN CALCULO DE LOS INTERESES

*...................ANALISIS DE LA FORMA DE PAGO
		      DO CASE
		      CASE PAG->cEstadoPag == 'P' .OR.;
			   PAG->cEstadoPag == 'A'

			   nFacMes := nFacMes* nNroMesFac(PAG->nMesIniPag,;
							  PAG->nMesFinPag)
			   nSiPago++
			   nVlrPag += PAG->nVlrPagPag
			   nVlrIng += PAG->nVlrPagPag

			   IF PAG->cEstadoPag == 'A'
			      nIntPag += nVlrInt
			      nVlrIng += nVlrInt
			   ENDIF

			   IF CAA->nMesAmnCaA == nMesIniTpa
			      nVlrSdo += CLI->nSdoActCli+CLI->nSdoMorCli
			   ENDIF

		      CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

			   nNoPago++
			   IF PAG->cEstadoPag = 'D'

			      IF PAG->nMesIniPag == PAG->nMesFinPag
				 nPagos := PAG->nVlrPagPag
			      ELSE
				 nPagos := PAG->nSdoAntPag+PAG->nMorAntPag+;
					   PAG->nVlrMesPag
			      ENDIF
			      nVlrDeu += nPagos
			      nIntMor += nIntNoP

			      IF CAA->nMesAmnCaA # nMesIniTpa
				 nVlrSdo += nPagos+nIntNoP
			      ELSE
				 nVlrSdo += CLI->nSdoActCli+CLI->nSdoMorCli
			      ENDIF

			   ELSE
			      nVlrSdo += CLI->nSdoActCli+CLI->nSdoMorCli
			   ENDIF

		      ENDCASE
		      nVlrMes += nFacMes
*...................FIN ANALISIS DE LA FORMA DE PAGO

		 ELSE
		     IF lRetadoTes
			nVlrSdo += CLI->nSdoActCli+CLI->nSdoMorCli
			nVlrDeu += CLI->nSdoActCli+CLI->nSdoMorCli
			nIntMor += 0
		     ENDIF
		 ENDIF
*--------------FIN CALCULO DE LOS INTERESES ACUMULACION DE PAGOS

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

		 IF STR(nAvance,3) $ '25 50 75100'
		    SET DEVICE TO SCREEN
		    Termometro(nAvance)
		    SET DEVICE TO PRINT
		 ENDIF

		 SELECT CLI
		 CLI->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {GRU->cCodigoGru,;
			TRANS(nVlrSdo,"####,###,###"),;
			TRANS(nVlrMes,"####,###,###"),;
			TRANS(nIntMor,"####,###,###"),;
			TRANS(nVlrDeu,"####,###,###"),;
			TRANS(nVlrPag,"####,###,###"),;
			TRANS(nIntPag,"####,###,###"),;
			TRANS(nVlrIng,"####,###,###"),;
			'('+TRANS(nAluGru,"9999")+')=>'+;
			SPACE(01)+;
			'SI('+TRANS(nSiPago,"999")+')'+;
			TRANS(nSiPago*100/nAluGru,"999.99")+'%'+;
			SPACE(01)+;
			'NO('+TRANS(nNoPago,"999")+')'+;
			TRANS(nNoPago*100/nAluGru,"999.99")+'%'}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ACUMULACION DE TOTALES
	    nTotSdo += nVlrSdo
	    nTotMor += nIntMor
	    nTotDeu += nVlrDeu
	    nTotPag += nVlrPag
	    nTotInt += nIntPag
	    nTotIng += nVlrIng
	    nTotMes += nVlrMes

	    nTotAlu += nAluGru
	    nTotSiP += nSiPago
	    nTotNoP += nNoPago
**********FIN ACUMULACION DE TOTALES

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi¢n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColTxt(aNroCol,02) SAY REPL('-',aNroCol[02])
       @ PROW()  ,nColTxt(aNroCol,03) SAY REPL('-',aNroCol[03])
       @ PROW()  ,nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       @ PROW()  ,nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])
       @ PROW()  ,nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
       @ PROW()  ,nColTxt(aNroCol,07) SAY REPL('-',aNroCol[07])
       @ PROW()  ,nColTxt(aNroCol,08) SAY REPL('-',aNroCol[08])

       @ PROW()+1,00 SAY 'TOTAL'
       @ PROW()  ,nColTxt(aNroCol,02) SAY TRANS(nTotSdo,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,03) SAY TRANS(nTotMes,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,04) SAY TRANS(nTotMor,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,05) SAY TRANS(nTotDeu,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,06) SAY TRANS(nTotPag,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotInt,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotIng,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,09) SAY '('+TRANS(nTotAlu,"9999")+')=>'+;
					  SPACE(01)+;
					  'SI('+TRANS(nTotSiP,"999")+')'+;
					  TRANS(nTotSiP*100/nTotAlu,"999.99")+'%'+;
					  SPACE(01)+;
					  'NO('+TRANS(nTotNoP,"999")+')'+;
					  TRANS(nTotNoP*100/nTotAlu,"999.99")+'%'
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS