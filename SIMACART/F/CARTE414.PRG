/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: MOROSOS MAS MES ACTUAL                   MODULO No. 414

**************************************************************************
* TITULO..: ESTUDIANTES MOROSOS + MES ACTUAL                             *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: SEP 10/99 VIE A
       Bucaramanga, Colombia	    INICIO: 11:45 PM   SEP 10/99 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci�n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los estudiantes morosos + el mes Actual

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_414(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

       LOCAL nNroPag := 1                   // N�mero de p�gina
       LOCAL lTamAnc := .F.                 // .T. Tama�o Ancho
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C�digos de impresi�n iniciales
       LOCAL cCodFin := ''                  // C�digos de impresi�n finales
       LOCAL aNroCol := {}                  // Columnas de impresi�n
       LOCAL aTitulo := {}                  // T�tulos para impresi�n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l�nea de impresi�n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P�gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L�neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
     *�Variables de informe

       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL lAnoAct := .T.                 // A�o Actual
       LOCAL nTotDeu := 0                   // Total de la deuda

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi�n
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL Getlist := {}                  // Variable del sistema
     *�Variables espec�ficas 

       LOCAL nMesIniTpa := 0                // Mes inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci�n
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *�Detalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C�digo de la Empresa
     *�Detalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A�o del usuario
       LOCAL cAnoSis := ''                  // A�o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *�Detalles del Usuario

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *�Detalles Acad�micos

       LOCAL nFilPal := 0                   // Fila Inferior Men� principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen�
       LOCAL nColInf := 0                   // Columna Inferior del SubMen�
       LOCAL nOpcPrn := 0                   // Opci�n de Impresi�n
     *�Detalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *�Sitios del Sistema

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
     *�Lectura de paths
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

	   IF !lUseGru(lShared,cIntUno,cMaeAct,cAnoSis,lAnoAct)
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
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct)     .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared) .OR.;
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
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A�O')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

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
       IF !lLocCodigo('nCodigoPrn','PRN',SCA->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>CAPTURA DEL MES A PAGAR
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi�n',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIniTpa == 0
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

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

*>>>>LECTURA DEL INTERVALO DE FECHAS
       lPrnFec := CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA
       dFecIni := CTOD('00/00/00')
       dFecFin := CTOD('00/00/00')
       IF lPrnFec
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

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecIni) .AND. EMPTY(dFecFin)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := nTotReg+nLinTot
       nTotReg := 0
       aCabeza := {cNomEmp,cNomSis,;
		   'ESTUDIANTES MOROSOS MAS EL MES ACTUAL.'+;
		   ' A�O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   IF(!EMPTY(nMesIniTpa),'MES DE '+cMes(nMesIniTpa),''),;
		   IF(lPrnFec,' DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin),''),;
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
       aNroCol := {02,02,06,20,12,12,12,12,18,10}
       aTitulo := {'##',;
		   'No',;
		   'CODIGO',;
		   'APELLIDOS Y NOMBRES ',;
		   'SALDO ACTUAL',;
		   'VALOR MES',;
		   'TOTAL',;
		   '123456789012',;
		   'NOMBRE DEL PADRE',;
		   'TELECASA'}
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

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'MoraMes'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.,.F.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	      CloseAll(aUseDbf)
	      RETURN NIL
	  ENDIF
       ENDIF
       SendCodes(PCL('Reset'))
       EVAL(bCabeza)
      *Impresi�n del Encabezado
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
	       cError('ABRIENDO DE CLIENTES Y PAGOS')
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
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'�'+;
			'HASTA EL GRUPO: '+cGruFin+'�ESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
	    nTotDeu += nMorMesPrn(cNomEmp,cNomSis,cAnoUsr,lAnoAct,;
				  cJorTxt,GRU->cCodigoGru,cMaeAlu,nColCab,;
				  aTitulo,aNroCol,bPagina,bDerAut,bCabeza,;
				  nMesIniTpa,dFecIni,dFecFin,lPrnFec)
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi�n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi�n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       IF nTotDeu # 0
	  @ PROW()+1,nColCab+nColTxt(aNroCol,05);
		     SAY REPL('-',aNroCol[05])

	  @ PROW()+1,nColCab+nColTxt(aNroCol,01);
		     SAY 'GRAN TOTAL ... '
	  @ PROW()  ,nColCab+nColTxt(aNroCol,05);
		     SAY TRANS(nTotDeu,"####,###,###")
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
       CloseAll(aUseDbf)
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*-------------- DECLARACION DE PROCEDIMIENTOS PARA EL PROGRAMA------------*
***************************************************************************


/*************************************************************************
* TITULO DEL PROGRAMA..: INFORME DE PAGOS EFECTUADOS                     *
**************************************************************************

AUTOR: Nelson Fern�ndez G�mez       FECHA DE CREACION: JUL 10/96 MIE A
       Bucaramanga, Colombia	    INICIO: 11:50 PM   JUL 10/96 MIE

OBJETIVOS:

1- Imprime los estudiantes morosos

2- Return el total de la deuda del grupo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nMorMesPrn(cNomEmp,cNomSis,cAnoUsr,lAnoAct,cJorTxt,cCodGru,;
		    cMaeAlu,nColCab,aTitulo,aNroCol,bPagina,bDerAut,;
		    bCabeza,nMesIni,dFecIni,dFecFin,lPrnFec)

*>>>>PARAMETROS DE LA FUNCION
/*     cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A�o del sistema
       lAnoAct                              // .T. A�o Actual
       cJorTxt                              // Jornada escogida
       cCodGru                              // C�digo del grupo
       cMaeAlu                              // Maestros habilitados
       nColCab                              // Columna del encabezado
       aTitulo                              // T�tulos para impresi�n
       aNroCol                              // Columnas de impresi�n
       bPagina                              // Block de P�gina
       bCabeza                              // Block de Encabezado
       bDerAut                              // Block Derechos de Autor
       dFecIni                              // Fecha Inicial
       dFecIni                              // Fecha Final
       lPrnFec                              // .T. Imprimir por Fechas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A�o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci�n uno
       LOCAL cIntDos := ''                  // Path de integraci�n dos
       LOCAL cIntTre := ''                  // Path de integraci�n tres
       LOCAL cIntCua := ''                  // Path de integraci�n cuatro
     *�Variables generales

       LOCAL       i := 0                   // Contador
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL lHayAlu := .T.                 // .T. Existe alumno
       LOCAL nTotSdo := 0                   // Total de los saldos
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nLinTot := 2                   // L�neas totales de control
       LOCAL cTxtPrn := ''                  // Texto de impresi�n
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL lDeudor := .T.                 // .T. Deudor
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL lMesAct := .T.                 // .T. Mes Actual
     *�Variables espec�ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL nSdoActTcl := 0                // Deuda Actual
       LOCAL nSdoMorTcl := 0                // Mora Actual
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
     *�Variables temporales de campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL TERMOMETRO
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO EL GRUPO '+cCodGru)
       Termometro(10)
       SET DEVICE TO PRINT
*>>>>FIN IMPRESION DEL TERMOMETRO

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT CLI
       GO TOP
       DO WHILE .NOT. EOF()

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CLI->(RECNO()) / CLI->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********ANALISIS SI ES EL MES ACTUAL
	    lMesAct := .T.
	    IF nMesIni < LEN(RTRIM(CLI->cMesPagCli))
	       lMesAct := .F.
	    ENDIF
**********FIN ANALISIS SI ES EL MES ACTUAL

**********ANALISIS SI EL ESTUDIANTE ES MOROSO
	    lDeudor := .F.
	    IF lMesAct
	       IF CLI->nSdoActCli+CLI->nSdoMorCli # 0
		  lDeudor := .T.
		  nSdoActTcl := CLI->nSdoActCli
		  nSdoMorTcl := CLI->nSdoMorCli
		  nTotSdo += nSdoActTcl+nSdoMorTcl
		  i++
	       ENDIF
	    ENDIF
**********FIN ANALISIS SI EL ESTUDIANTE ES MOROSO

**********ANALISIS SI EXISTE PAGO
	    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
	    IF !lHayPag
	       lDeudor := .F.
	    ENDIF
**********FIN ANALISIS SI EXISTE PAGO

**********ANALISIS DEL PAGO
	    IF !lMesAct .AND. lHayPag

*--------------CALCULO DE LOS INTERESES
		 nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				       PAG->nMesIniPag,;
				       CAA->nMesAmnCaA)
*--------------FIN CALCULO DE LOS INTERESES

*--------------ANALISIS DE LA FORMA DE PAGO
		 lFechOk := .T.
		 lDeudor := .F.
		 DO CASE
		 CASE PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'

*.....................ANALISIS DE LA FECHA DE PAGO
		      IF lPrnFec
			 IF PAG->dFecPagPag < dFecIni .OR.;
			    PAG->dFecPagPag > dFecFin
			    lFechOk := .F.
			    lDeudor := .T.
			 ELSE
			    lDeudor := .F.
			 ENDIF
		      ENDIF
*.....................FIN ANALISIS DE LA FECHA DE PAGO

*.....................ANALISIS DE LA DEUDA. FECHA FUERA DE RANGO
			IF !lFechOk

*                          ANALISIS DEL RECIBO POR ADELANTADO
			     IF PAG->nMesIniPag == PAG->nMesFinPag
				nVlrPag := PAG->nVlrPagPag
			     ELSE
				nVlrPag := PAG->nSdoAntPag+PAG->nMorAntPag+;
					   PAG->nVlrMesPag
			     ENDIF
*                          FIN ANALISIS DEL RECIBO POR ADELANTADO

*                          ANALISIS DE LA AMNISTIA
			     IF CAA->nMesAmnCaA # nMesIni
				nSdoActTcl := nVlrPag

				IF PAG->cEstadoPag == 'A'
				   nSdoMorTcl := nVlrIntPag(CAA->lIntPenCaA,;
							    PAG->nMesIniPag,;
							    CAA->nMesAmnCaA)
				ELSE
				   nSdoMorTcl := 0
				ENDIF
			     ELSE
				nSdoActTcl := IF(lMesAct,CLI->nSdoActCli,;
							 PAG->nSdoAntPag)
				nSdoMorTcl := IF(lMesAct,CLI->nSdoMorCli,;
							 PAG->nMorAntPag)
			     ENDIF
			     nTotSdo += nSdoActTcl+nSdoMorTcl
*                          FIN ANALISIS DE LA AMNISTIA

			ENDIF
*.....................FIN ANALISIS DE LA DEUDA. FECHA FUERA DE RANGO

		 CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

		      IF PAG->cEstadoPag = 'D'

*........................ANALISIS DEL RECIBO POR ADELANTADO
			   lDeudor := .T.
			   IF PAG->nMesIniPag == PAG->nMesFinPag
			      nVlrPag := PAG->nVlrPagPag
			   ELSE
			      nVlrPag := PAG->nSdoAntPag+PAG->nMorAntPag+;
					 PAG->nVlrMesPag
			   ENDIF
*........................FIN ANALISIS DEL RECIBO POR ADELANTADO

*........................ANALISIS DE LA AMNISTIA
			   IF CAA->nMesAmnCaA # nMesIni
			      nSdoActTcl := nVlrPag
			      nSdoMorTcl := nVlrInt
			   ELSE
			      IF lMesAct
				 nSdoActTcl := CLI->nSdoActCli
				 nSdoMorTcl := CLI->nSdoMorCli
			      ELSE
				 nSdoActTcl := PAG->nSdoAntPag+nVlrPag
				 nSdoMorTcl := PAG->nMorAntPag+nVlrInt
			      ENDIF
			   ENDIF
			   nTotSdo += nSdoActTcl+nSdoMorTcl
*........................FIN ANALISIS DE LA AMNISTIA

		      ELSE

*........................ANALISIS DEL DEUDOR
			   nSdoActTcl := IF(lMesAct,CLI->nSdoActCli,;
						    PAG->nSdoAntPag)
			   nSdoMorTcl := IF(lMesAct,CLI->nSdoMorCli,;
						    PAG->nMorAntPag)
			   nTotSdo += nSdoActTcl+nSdoMorTcl
*........................FIN ANALISIS DEL DEUDOR

		      ENDIF

		 ENDCASE
*--------------FIN ANALISIS DE LA FORMA DE PAGO

	    ENDIF
**********FIN ANALISIS DEL PAGO

**********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	    lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cNalias,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
			     RTRIM(&cNalias->cNombreEst)
	    ELSE
	       cNombreTes := 'EL ALUMNO NO EXISTE'
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(20),1,20)
**********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

**********AVANCE DEL SIGUIENTE CLIENTE
	    SELECT CLI
	    IF !lDeudor
	       CLI->(DBSKIP())
	       IF CLI->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	       LOOP
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE CLIENTE

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {STR(i,2),;
			STR(CLI->(RECNO()),2),;
			CLI->cCodigoEst,;
			SPACE(01)+SUBS(cNombreTes,1,19),;
			TRANS(nSdoActTcl+nSdoMorTcl,'####,###,###'),;
			TRANS(PAG->nVlrMesPag,'####,###,###'),;
			TRANS(nSdoActTcl+nSdoMorTcl+;
			      PAG->nVlrMesPag,'####,###,###'),;
			CLI->cMesPagCli,;
			SUBS(&cNalias->cNomPadEst,1,18),;
			&cNalias->cTelefnEst}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CLI
	    CLI->(DBSKIP())
	    IF CLI->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL
       IF PROW() > 58 - nLinTot .OR. PROW() = 0
	  IF PROW() <> 0
	     EVAL(bDerAut)
	    *Impresi�n de derechos
	     EJECT
	  ENDIF
	  EVAL(bCabeza)
	 *Impresi�n del Encabezado
       ENDIF
*>>>>FIN IMPRESION ENCABEZADO DEL INFORME PARA TOTALES DE CONTROL

*>>>>IMPRESION DE LOS TOTALES
       IF nTotSdo # 0
	  @ PROW()+1,nColCab+nColTxt(aNroCol,05);
		     SAY REPL('-',aNroCol[05])

	  @ PROW()+1,nColCab+nColTxt(aNroCol,01);
		     SAY 'TOTAL GRUPO: '+cCodGru
	  @ PROW()  ,nColCab+nColTxt(aNroCol,05);
		     SAY TRANS(nTotSdo,"####,###,###")
       ENDIF

       RETURN nTotSdo
*>>>>FIN IMPRESION DE LOS TOTALES