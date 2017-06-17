/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: PAGOS DESCRIMINADOS                      MODULO No. 257

**************************************************************************
* TITULO..: PAGOS DESCRIMINADOS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 15/2000 MIE A
       Bucaramanga, Colombia	    INICIO: 10:00 AM   MAR 15/2000 MIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los pagos descrimandos por forma de pago.


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_259(aParam1,aParam2,aParam3)

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

       LOCAL       i := 0                   // Contador
       LOCAL nNroOpc := 0                   // N£mero de la opci¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
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
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'SCA',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileFpg,'FPG',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis) .OR.;
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
       CASE SCA->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE FPG->(RECCOUNT()) == 0
	    cError('NO EXISTE TIPOS DE FORMA DE PAGO')

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

*>>>>LECTURA DE LA FORMA DE PAGO
       nNroOpc := nLeeOpcion('ESCOJA EL TIPO DE INFORME: '+;
		 '1<POR GRUPOS> 2<POR DIAS> 3<ABANDONAR>?',3,'0')
       *Lee el tipo de Informe

       IF nNroOpc == 3
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE LA FORMA DE PAGO

*>>>>ANALISIS DE LA OPCION ESGODIDA
       DO CASE
       CASE nNroOpc == 1
	    PagoFpgGru(aParam1,aParam2,aParam3)
	   *Pagos de la forma de pago por Grupo

       CASE nNroOpc == 2
	    PagoFpgDia(aParam1,aParam2,aParam3)
	   *Pagos de la forma de pago por fechas.

       ENDCASE
       CloseAll(aUseDbf)
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN ANALISIS DE LA OPCION ESGODIDA

/*************************************************************************
* TITULO ..: PAGOS DE LA FORMA DE PAGO POR GRUPO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 15/2000 MIE A
       Bucaramanga, Colombia	    INICIO: 10:45 AM   MAR 15/2000 MIE

OBJETIVOS:

1- La forma de pago de por grupos.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagoFpgGru(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nTotGru := 0                   // Total grupos a imprimir
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
     *ÀVariables Calculo total registro

       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecIni := CTOD('00/00/00')    // Fecha Inicial
       LOCAL dFecFin := CTOD('00/00/00')    // Fecha Final
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
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
     *ÀVariables de informe

       LOCAL aFpgAlu := {}                  // Valores por Alumno
       LOCAL aVlrFpg := {}                  // Valores por Grupos
       LOCAL aTotNiv := {}                  // Totales por por nivel
       LOCAL aTotFpg := {}                  // Totales
       LOCAL aPagMes := {}                  // Pagos por Meses
       LOCAL nMesPag := 0                   // N£mero del Mes de pago
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL aTitPrn := {}                  // Contenidos de impresi¢n.

       LOCAL nNroNiv := 0                   // N£mero de Niveles
       LOCAL     k,i := 1                   // Contadores
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
       LOCAL lValida := .F.                 // .T. Validar por Estudiante.
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
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
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
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
	  RESTSCREEN(0,0,24,79,cSavPan)
	  cSavPan := SAVESCREEN(0,0,24,79)
	  @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	  @ nFilInf+1,nColInf SAY 'FECHA INICIAL:' GET dFecIni PICT '@D'
	  @ nFilInf+2,nColInf SAY 'FECHA FINAL  :' GET dFecFin PICT '@D'
	  READ
	  RESTSCREEN(0,0,24,79,cSavPan)

	  IF EMPTY(dFecIni) .OR. EMPTY(dFecFin)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DEL INTERVALO DE FECHAS

*>>>>CALCULO DEL TOTAL DE REGISTROS
       SELECT GRU
       GO nRegIni
       nNroNiv := 1
       cNivAnt := SUBS(GRU->cCodigoGru,1,2)
       DO WHILE GRU->(RECNO()) <= nRegFin
	  cNivAct := SUBS(GRU->cCodigoGru,1,2)
	  IF cNivAnt # cNivAct
	     cNivAnt := cNivAct
	     nNroNiv++
	  ENDIF
	  GRU->(DBSKIP())
       ENDDO
     *ÀCalculo del total de registros

       nTotGru := nRegFin-nRegIni+1
       nTotReg := nTotGru+(nNroNiv*3)+1
*>>>>FIN CALCULO DEL TOTAL DE REGISTROS

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       aCabeza := {cNomEmp,cNomSis+' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   'PAGOS DISCRIMINADOS POR FORMA DE PAGO.',;
		   'DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin),;
		   '',;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
/*
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*/

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aPagMes := {}
       aTotFpg := {}
       aTotNiv := {}

       aNroCol := {04}
       aTitulo := {'NIV.'}

       SELECT FPG
       GO TOP
       DO WHILE .NOT. FPG->(EOF())
	   AADD(aPagMes,{0,0,0,0,0,0,0,0,0,0,0,0,0,0})
	   AADD(aTotFpg,0)
	   AADD(aTotNiv,0)
	   AADD(aNroCol,12)
	   AADD(aTitulo,SUBS(FPG->cNombreFpg,1,12))
	   FPG->(DBSKIP())
       ENDDO
       AADD(aPagMes,{0,0,0,0,0,0,0,0,0,0,0,0,0,0})
       AADD(aTotFpg,0)
       AADD(aTotNiv,0)
       AADD(aNroCol,12)
       AADD(aTitulo,'TOTAL')
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
       IF SCA->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,SCA->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
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
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
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
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********INICIALIZACION DE ACUMULADORES
	    SELECT FPG
	    GO TOP
	    aVlrFpg := {}
	    DO WHILE .NOT. FPG->(EOF())
		AADD(aVlrFpg,0)
		FPG->(DBSKIP())
	    ENDDO
	    AADD(aVlrFpg,0)
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

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		 lRetadoTes := .F.
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		 IF lHayAlu
		    cCodigoTes := &cMaeAct->cCodigoEst
		    IF &cMaeAct->lRetiroEst
		       lRetadoTes := .T.
		    ENDIF
		 ELSE
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------FILTRACION DEL ARCHIVO DE LOS PAGOS
		 SELECT PAG
		 SET FILTER TO PAG->cCodigoEst == CLI->cCodigoEst
		 GO TOP
		 IF PAG->(EOF())
		    SET FILTER TO
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
		 PAG->(DBGOBOTTOM())
*--------------FIN FILTRACION DEL ARCHIVO DE LOS PAGOS

*--------------PROCESAMIENTO DE LOS PAGOS DEL ESTUDIANTE
		 SELECT PAG
		 GO TOP
		 DO WHILE .NOT. PAG->(EOF())

*...................ANALISIS DE LA FECHA DE PAGO
		      lFechOk := .T.
		      IF PAG->cEstadoPag == 'P' .OR.;
			 PAG->cEstadoPag == 'A'
			 IF PAG->dFecPagPag < dFecIni .OR.;
			    PAG->dFecPagPag > dFecFin
			    lFechOk := .F.
			 ENDIF
		      ENDIF
*...................FIN ANALISIS DE LA FECHA DE PAGO

*...................INICIALIZACION DE ACUMULADORES POR ESTUDIANTE
		      aFpgAlu := {}
		      IF (PAG->cEstadoPag == 'P' .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk
			  SELECT FPG
			  GO TOP
			  DO WHILE .NOT. FPG->(EOF())
			     AADD(aFpgAlu,0)
			     FPG->(DBSKIP())
			  ENDDO
			  AADD(aFpgAlu,0)
		      ENDIF
*...................FIN INICIALIZACION DE ACUMULADORES POR ESTUDIANTE

*...................CALCULO DE LOS INTERESES
		      IF (PAG->cEstadoPag == 'P' .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk
			  nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
						PAG->nMesIniPag,;
						CAA->nMesAmnCaA)
		      ENDIF
*...................FIN CALCULO DE LOS INTERESES

*...................CALCULO DEL VALOR PAGADO
		      IF (PAG->cEstadoPag == 'P' .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk

*                        LOCALIZAR LA FORMA DE PAGO
			   i := 1
			   IF lLocCodigo('cCodigoFpg','FPG',;
					 PAG->cCodigoFpg)
			      i := FPG->(RECNO())
			   ENDIF
*                        FIN LOCALIZAR LA FORMA DE PAGO

*                        DESCRIMINACION DE LOS PAGOS POR MESES
			   IF CAA->lLeeFecCaA

*                             ANALISIS DEL MES DE PAGO
				nMesPag := MONTH(PAG->dFecPagPag)
				IF nMesPag <= 0 .OR. nMesPag > 12
				   nMesPag := 13
				ENDIF
*                             FIN ANALISIS DEL MES DE PAGO

*                             TOTALIZACION DEL PAGO
				aPagMes[i,nMesPag] += PAG->nVlrPagPag
				aPagMes[i,LEN(aPagMes[i])] += PAG->nVlrPagPag

				aPagMes[LEN(aPagMes),nMesPag] += PAG->nVlrPagPag
				aPagMes[LEN(aPagMes),LEN(aPagMes[i])] += PAG->nVlrPagPag

				IF PAG->cEstadoPag == 'A'
				   aPagMes[i,nMesPag] += nVlrInt
				   aPagMes[i,LEN(aPagMes[i])] += nVlrInt

				  aPagMes[LEN(aPagMes),nMesPag] += nVlrInt
				  aPagMes[LEN(aPagMes),LEN(aPagMes[i])] += nVlrInt

				ENDIF
*                             FIN TOTALIZACION DEL PAGO

			   ENDIF
*                        FIN DESCRIMINACION DE LOS PAGOS POR MESES

*                        VALOR DE LOS INTERESES
			   aFpgAlu[i] := PAG->nVlrPagPag
			   aFpgAlu[LEN(aFpgAlu)] += PAG->nVlrPagPag

			   aVlrFpg[i] += PAG->nVlrPagPag
			   aVlrFpg[LEN(aVlrFpg)] += PAG->nVlrPagPag

			   aTotNiv[i] += PAG->nVlrPagPag
			   aTotNiv[LEN(aTotNiv)] += PAG->nVlrPagPag

			   aTotFpg[i] += PAG->nVlrPagPag
			   aTotFpg[LEN(aTotFpg)] += PAG->nVlrPagPag
			 *ÀValor Pagado

			   IF PAG->cEstadoPag == 'A'

			      aFpgAlu[i] += nVlrInt
			      aFpgAlu[LEN(aFpgAlu)] += nVlrInt

			      aVlrFpg[i] += nVlrInt
			      aVlrFpg[LEN(aVlrFpg)] += nVlrInt

			      aTotNiv[i] += nVlrInt
			      aTotNiv[LEN(aTotNiv)] += nVlrInt

			      aTotFpg[i] += nVlrInt
			      aTotFpg[LEN(aTotFpg)] += nVlrInt
			    *ÀValor Pagado

			   ENDIF
*                        FIN VALOR DE LOS INTERESES

		      ENDIF
*...................FIN CALCULO DEL VALOR PAGADO

*...................IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE
		      IF lValida .AND. !EMPTY(aFpgAlu)
			 aTitulo := {}
			 AADD(aTitulo,GRU->cCodigoGru)
			 FOR i := 1 TO LEN(aFpgAlu)-1
			     AADD(aTitulo,TRANS(aFpgAlu[i],"####,###,###"))
			 ENDFOR
			 AADD(aTitulo,TRANS(aFpgAlu[LEN(aFpgAlu)],"####,###,###"))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
				    cFecha(PAG->dFecPagPag,3)+;
				    ' =>'+CLI->cCodigoEst+'-'+;
				    STR(CLI->(RECNO()),2)+;
				    ' RECIBO DE '+cMes(PAG->nMesIniPag)
			 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		      ENDIF
*...................FIN IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE

		    SELECT PAG
		    PAG->(DBSKIP())

		 ENDDO
*--------------FIN PROCESAMIENTO DE LOS PAGOS DEL ESTUDIANTE

*--------------FILTRACION DEL ARCHIVO DE LOS PAGOS PARCIALES
		 SELECT DES
		 SET FILTER TO DES->cCodigoEst == CLI->cCodigoEst .AND.;
			       ((DES->nTipDesDes == 3 .AND.; // ABONO
				 !DES->lDesEfeDes)    .OR.;
				DES->nTipDesDes == 4)        // PAGO PARCIAL
		 GO TOP
		 IF DES->(EOF())
		    SET FILTER TO
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
		 DES->(DBGOBOTTOM())
*--------------FIN FILTRACION DEL ARCHIVO DE LOS PAGOS PARCIALES

*--------------PROCESAMIENTO DE LOS PAGOS PARCIALES
		 SELECT DES
		 GO TOP
		 DO WHILE .NOT. DES->(EOF())

*...................ANALISIS DE LA FECHA DE PAGO PARCIAL
		      lFechOk := .T.
		      IF DES->dFechaDes < dFecIni .OR.;
			 DES->dFechaDes > dFecFin
			 lFechOk := .F.
		      ENDIF
*...................FIN ANALISIS DE LA FECHA DE PAGO PARCIAL

*...................INICIALIZACION DE ACUMULADORES POR ESTUDIANTE
		      aFpgAlu := {}
		      IF lFechOk
			 SELECT FPG
			 GO TOP
			 DO WHILE .NOT. FPG->(EOF())
			    AADD(aFpgAlu,0)
			    FPG->(DBSKIP())
			 ENDDO
			 AADD(aFpgAlu,0)
		      ENDIF
*...................FIN INICIALIZACION DE ACUMULADORES POR ESTUDIANTE

*...................CALCULO DEL PAGO PARCIAL
		      IF lFechOk

*                        LOCALIZAR LA FORMA DE PAGO
			   i := 1
			   IF lLocCodigo('cCodigoFpg','FPG',;
					 DES->cCodigoFpg)
			      i := FPG->(RECNO())
			   ENDIF
*                        FIN LOCALIZAR LA FORMA DE PAGO

*                        DESCRIMINACION DE LOS PAGOS POR MESES
			   IF CAA->lLeeFecCaA

*                             ANALISIS DEL MES DE PAGO
				nMesPag := MONTH(DES->dFechaDes)
				IF nMesPag <= 0 .OR. nMesPag > 12
				   nMesPag := 13
				ENDIF
*                             FIN ANALISIS DEL MES DE PAGO

*                             TOTALIZACION DEL PAGO PARCIAL
				aPagMes[i,nMesPag] += DES->nValorDes
				aPagMes[i,LEN(aPagMes[i])] += DES->nValorDes

				aPagMes[LEN(aPagMes),nMesPag] += DES->nValorDes
				aPagMes[LEN(aPagMes),LEN(aPagMes[i])] += DES->nValorDes
*                             FIN TOTALIZACION DEL PAGO PARCIAL

			   ENDIF
*                        FIN DESCRIMINACION DE LOS PAGOS POR MESES

*                        TOTALIZACION DEL PAGO PARCIAL
			   aFpgAlu[i] := DES->nValorDes
			   aFpgAlu[LEN(aFpgAlu)] += DES->nValorDes

			   aVlrFpg[i] += DES->nValorDes
			   aVlrFpg[LEN(aVlrFpg)] += DES->nValorDes

			   aTotNiv[i] += DES->nValorDes
			   aTotNiv[LEN(aTotNiv)] += DES->nValorDes

			   aTotFpg[i] += DES->nValorDes
			   aTotFpg[LEN(aTotFpg)] += DES->nValorDes
			 *ÀValor Pagado
*                        FIN TOTALIZACION DEL PAGO PARCIAL

		      ENDIF
*...................FIN CALCULO DEL PAGO PARCIAL

*...................IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE
		      IF lValida .AND. !EMPTY(aFpgAlu)
			 aTitulo := {}
			 AADD(aTitulo,GRU->cCodigoGru)
			 FOR i := 1 TO LEN(aFpgAlu)-1
			     AADD(aTitulo,TRANS(aFpgAlu[i],"####,###,###"))
			 ENDFOR
			 AADD(aTitulo,TRANS(aFpgAlu[LEN(aFpgAlu)],"####,###,###"))

			 cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
				    cFecha(DES->dFechaDes,3)+;
				    ' =>'+DES->cCodigoEst+'-'+;
				    STR(CLI->(RECNO()),2)+' '+;
				    IF(DES->nTipDesDes == 3,;
				       'ABONO DE ','PAGO PARCIAL DE ')+;
				    cMes(DES->nNroMesDes)
			 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		      ENDIF
*...................FIN IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE

		    SELECT DES
		    DES->(DBSKIP())

		 ENDDO
*--------------FIN PROCESAMIENTO DE LOS PAGOS PARCIALES

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 SET DEVICE TO SCREEN
		 Avance(CLI->(RECNO()),CLI->(RECCOUNT()))
		 SET DEVICE TO PRINT

		 SELECT CLI
		 CLI->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {}
	    AADD(aTitulo,GRU->cCodigoGru)
	    FOR i := 1 TO LEN(aVlrFpg)-1
		AADD(aTitulo,TRANS(aVlrFpg[i],"####,###,###"))
	    ENDFOR
	    AADD(aTitulo,TRANS(aVlrFpg[LEN(aVlrFpg)],"####,###,###"))

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

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

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct

	       @ PROW()+1,00 SAY ''
	       FOR i := 1 TO LEN(aTotNiv)
		   @ PROW(),nColCab+nColTxt(aNroCol,i+1);
				    SAY REPL('-',aNroCol[i+1])
	       ENDFOR

	       aTitulo := {}
	       AADD(aTitulo,cNivAnt)
	       FOR i := 1 TO LEN(aTotNiv)-1
		   AADD(aTitulo,TRANS(aTotNiv[i],"####,###,###"))
	       ENDFOR
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)],"####,###,###"))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       @ PROW()+1,00 SAY ''

	       SELECT FPG
	       GO TOP
	       aTotNiv := {}
	       DO WHILE .NOT. FPG->(EOF())
		  AADD(aTotNiv,0)
		  FPG->(DBSKIP())
	       ENDDO
	       AADD(aTotNiv,0)
	       cNivAnt := cNivAct
	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

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
       @ PROW()+1,00 SAY ''
       FOR i := 1 TO LEN(aTotFpg)
	   @ PROW(),nColCab+nColTxt(aNroCol,i+1) SAY REPL('=',aNroCol[i+1])
       ENDFOR

       aTitulo := {}
       AADD(aTitulo,'TOT.')
       FOR i := 1 TO LEN(aTotFpg)-1
	   AADD(aTitulo,TRANS(aTotFpg[i],"####,###,###"))
       ENDFOR
       AADD(aTitulo,TRANS(aTotFpg[LEN(aTotFpg)],"####,###,###"))

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES
       aNroCol := {}
       aTitulo := {}

       FOR i := 1 TO LEN(aPagMes)
	   FOR k := 1 TO 14
	      IF !EMPTY(aPagMes[i,k])
		 DO CASE
		 CASE k <= 12
		      IF ASCAN(aTitulo,{|x| x == cMes(k,3)}) == 0
			 AADD(aNroCol,12)
			 AADD(aTitulo,cMes(k,3))
		      ENDIF
		 CASE k == 13
		      IF ASCAN(aTitulo,{|x| x == 'SIN FECHA'}) == 0
			 AADD(aNroCol,12)
			 AADD(aTitulo,'SIN FECHA')
		      ENDIF
		 CASE k == 14
		      IF ASCAN(aTitulo,{|x| x == 'TOTALES'}) == 0
			 AADD(aNroCol,12)
			 AADD(aTitulo,'TOTALES')
		      ENDIF
		 ENDCASE
	      ENDIF

	   ENDFOR
       ENDFOR
       cTxtPrn := SUBS('GRANDES TOTALES '+SPACE(21),1,21)+;
		  cRegPrint(aTitulo,aNroCol)
       lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES

*>>>>IMPRESION DE LOS TOTALES
       FOR i := 1 TO LEN(aPagMes)
	   aTitPrn := {}
	   FOR k := 1 TO 14
	      IF !EMPTY(aPagMes[i,k])
		 DO CASE
		 CASE k <= 12
		      IF ASCAN(aTitulo,{|x| x == cMes(k,3)}) # 0
			 AADD(aTitPrn,TRANS(aPagMes[i,k],"####,###,###"))
		      ENDIF
		 CASE k == 13
		      IF ASCAN(aTitulo,{|x| x == 'SIN FECHA'}) # 0
			 AADD(aTitPrn,TRANS(aPagMes[i,k],"####,###,###"))
		      ENDIF
		 CASE k == 14
		      IF ASCAN(aTitulo,{|x| x == 'TOTALES'}) # 0
			 AADD(aTitPrn,TRANS(aPagMes[i,k],"####,###,###"))
		      ENDIF
		 ENDCASE
	      ENDIF
	   ENDFOR
	   FPG->(DBGOTO(i))

	   IF i # LEN(aPagMes)
	      cTxtPrn := FPG->cNombreFpg+' '+cRegPrint(aTitPrn,aNroCol)
	   ELSE

	      @ PROW()+1,00 SAY ''
	      FOR i := 1 TO LEN(aTitPrn)
		  @ PROW(),21+nColTxt(aNroCol,i) SAY REPL('=',aNroCol[i])
	      ENDFOR

	      cTxtPrn := SUBS('TOTALES'+SPACE(21),1,21)+;
			 cRegPrint(aTitPrn,aNroCol)
	   ENDIF
	   lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDFOR
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,n17Stan)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS



/*************************************************************************
* TITULO ..: PAGOS DE LA FORMA DE PAGO POR DIAS                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 15/2000 MIE A
       Bucaramanga, Colombia	    INICIO: 10:45 AM   MAR 15/2000 MIE

OBJETIVOS:

1- Imprime la forma de pago por dias.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagoFpgDia(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
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

       LOCAL lValida := .F.                 // .T. Validar por Estudiante.
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
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

*>>>>SELECCION DE LA FORMA DE PAGO
      SELECT FPG
      DO WHILE .T.
	 IF nSelRegDbf(nFilInf+1,nColInf-1,'FPG','cNombreFpg') # 0
	    IF !lPregunta('ESCOGIO '+ALLTRIM(FPG->cNombreFpg)+;
	       ' DESEA CONTINUAR? Si No')
	       RETURN NIL
	    ENDIF
	    EXIT
	 ELSE
	     IF !lPregunta('ESCOGIO TODAS LAS FORMAS DE PAGO. '+;
			   'DESEA CONTINUAR? No Si')
		RETURN NIL
	     ENDIF
	     GO FPG->(RECCOUNT())+1
	    *Se Ubica al final del Archivo
	     EXIT
	 ENDIF
      ENDDO
      RETURN NIL
*>>>>FIN SELECCION DE LA FORMA DE PAGO