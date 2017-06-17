/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: PAGOS ATRASOS                            MODULO No. 256

**************************************************************************
* TITULO..: PAGOS DE LOS ATRASOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 15/2002 MIE A
       Bucaramanga, Colombia	    INICIO: 10:00 AM   MAY 15/2002 MIE

OBJETIVOS:

1- Permite imprimir los pagos realizados por atrasos


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_256(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       #DEFINE nALUGRU 1                    // Posici¢n alumnos del grupo
       #DEFINE nNOPAGO 2                    // Posici¢n alumnos no pagaron
       #DEFINE nSIPAGO 3                    // Posici¢n alumnos si pagaron
       #DEFINE nPAGEXT 4                    // Posici¢n alumnos pagos ext

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nRegPag := 0                   // Registro de Pagos
       LOCAL nTotGru := 0                   // Total grupos a imprimir
       LOCAL nTotCon := 0                   // Total de conceptos
       LOCAL nLinInt := 0                   // l¡neas intermedias
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
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL cTitPrn := ''                  // T¡tulo del Informe
       LOCAL cConcep := ''                  // Conceptos
       LOCAL nVlrCon := 0                   // Valor Conceptos Individuales
       LOCAL nMesPag := 0                   // N£mero del Mes de pago

       LOCAL aPagMes[13]                    // Pagos por Meses
       LOCAL aAboMes[13]                    // Abonos por Meses
       LOCAL aParMes[13]                    // Abonos por Meses

       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL aConAlu := {}                  // Valores por conceptos por alumno
       LOCAL aConGru := {}                  // Valores por conceptos por Grupos
       LOCAL aTotNiv := {}                  // Totales por conceptos por nivel
       LOCAL aTotCon := {}                  // Totales por conceptos
       LOCAL nVlrInt := 0                   // Valor de los intereses

       LOCAL lMesAct := .T.                 // .T. Mes Actual.
       LOCAL nNroNiv := 0                   // N£mero de Niveles
       LOCAL nPagos := 0                   // N£mero de Pagos
       LOCAL nNroDeu := 0                   // N£mero de Deudores
       LOCAL nNroExt := 0                   // N£mero de Extemporaneos
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL       i := 1                   // Contador
       LOCAL       j := 0                   // Contador
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL nVlrTar := ''                  // Valor de las tarifas
       LOCAL lValida := .F.                 // .T. Validar por Estudiante.
       LOCAL  aTotal := {}                  // Total de Pagos
       LOCAL aTotMes := {}                  // Total del Mes
       LOCAL nLenEle := 0                   // Longitud de los Elementos
       LOCAL nTotPar := 0                   // Total Pagos Parciales
       LOCAL nNroMes := 0                   // N£mero del Mes
       LOCAL nVlrAbo := 0                   // Valor del Abono
       LOCAL nTotPag := 0                   // Total Pagos
       LOCAL nMesPar := 0                   // Mes del Pago Parcial
       LOCAL nMesAbo := 0                   // Mes del Abono
       LOCAL nTotRec := 0                   // Total Recargos
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL cMsgErr := ''                  // Mensaje de Error
       LOCAL nTipPrn := 0                   // Tipo de Informe

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
       LOCAL cNombreTco := ''               // Nombre del Concepto
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
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
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIniTpa := nMesano(nFilInf+1,IF(nColInf+49>80,31,nColInf),;
			     'Mes de Pago para la Pensi¢n',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nMesIniTpa == 0
	  CloseAll()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct)       .OR.;
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
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTE GRUPOS GRABADOS')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN TARIFAS CREADAS')

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

*>>>>LECTURA DE LA FORMA DE PAGO
       nTipPrn := nLeeOpcion('TIPO DE INFORME: '+;
			     '1<PAGOS MES> 2<ATRASOS> 3<ABONOS> '+;
			     '4<TODOS> 5<REGRESAR>?',5,'0')
       *Tipo de Informes

       DO CASE
       CASE nTipPrn == 1
	    cTitPrn := 'PAGOS DEL SOLO MES'
	    cError('ESTA OPCION NO ESTA HABILITADA')
	    CloseAll(aUseDbf)
	    RETURN NIL

       CASE nTipPrn == 2
	    cTitPrn := 'PAGOS DE ATRASOS'
       CASE nTipPrn == 3
	    cTitPrn := 'PAGOS DE ABONOS'
       CASE nTipPrn == 4
	    cTitPrn := 'PAGOS DE ATRASOS Y ABONOS'
       OTHERWISE
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDCASE
*>>>>FIN LECTURA DE LA FORMA DE PAGO

*>>>>LECTURA DE LOS CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cConcep := cConceptos()
       @ nFilInf+1,nColInf SAY 'CONCEPTOS' GET cConcep PICT "@!";
			   VALID lValLeeCon(nFilInf+1,nColInf+26,;
					    nFilInf+1,nColInf+10,;
					    @cConcep)
       READ
       IF EMPTY(cConcep) .OR. !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       cConcep := ALLTRIM(cConcep)
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE LOS CONCEPTOS

*>>>>GRABACION DE LOS CONCEPTOS A IMPRIMIR
       IF CAR->(lRegLock(lSiRed,.F.))
	  REPL CAR->cConPrnCar WITH cConcep
	  CAR->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA LOS CONCEPTOS A IMPRIMIR')
       ENDIF
       IF lShared
	  CAR->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DE LOS CONCEPTOS A IMPRIMIR

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
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
       aCabeza := {cNomEmp,cNomSis,;
		   cTitPrn+'.'+;
		   IF(lPrnFec,' DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin),''),;
		   'CORRESPONDIENTE A RECIBOS DE '+cMes(nMesIniTpa,10)+;
		   IF(CAA->nMesAmnCaA == nMesIniTpa,' CON AMNISTIA',''),;
		   'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
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
       aTotCon := {}
       aTotNiv := {}

       aNroCol := {04}
       aTitulo := {'NIV.'}

       FOR i := 1 TO LEN(cConcep)/2

	   AADD(aTotCon,0)  // Conceptos Mes
	   AADD(aTotNiv,0)  // Totales Conceptos Mes

	   IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	      IF i == 1
		 AADD(aNroCol,12)                          // Conceptos Mes
	      ELSE
		 AADD(aNroCol,12)                          // Conceptos Mes
	      ENDIF
	      AADD(aTitulo,SUBS(CON->cNombreCon,1,12))     // Conceptos Mes
	   ELSE
	      IF i == 1
		 AADD(aNroCol,16)                          // Conceptos Mes
	      ELSE
		 AADD(aNroCol,12)                          // Conceptos Mes
	      ENDIF
	      AADD(aTitulo,SUBS(cConcep,i*2-1,2))       // Conceptos Mes
	   ENDIF

       ENDFOR

       AADD(aNroCol,12)
       AADD(aTitulo,'INT% PAGADOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'VRL PAGADO')

       AADD(aNroCol,12)
       AADD(aTitulo,'TOT PAGADO')

       AADD(aTotCon,0)  // Intereses Pagados
       AADD(aTotCon,0)  // Total Nivel
       AADD(aTotCon,0)  // Total Pagado

       AADD(aTotNiv,0)  // Intereses Pagados
       AADD(aTotNiv,0)  // Total Nivel
       AADD(aTotNiv,0)  // Total Pagado

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
       ActivaPrn(lSiRed,cNomSis,PathSis,fSimCar,'cColaAcCar','Car')
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     CloseAll(aUseDbf)
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
       AFILL(aPagMes,0)                     // Inicializa los pagos en cero
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

**********INICIALIZACION DE ACUMULADORES
	    aConGru := {}
	    FOR i := 1 TO LEN(cConcep)/2
		AADD(aConGru,0)           // Conceptos Mes
	    ENDFOR
	    AADD(aConGru,0)               // Intereses Pagados
	    AADD(aConGru,0)               // Total Nivel
	    AADD(aConGru,0)               // Total Pagado
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

*--------------INICIALIZACION DE ACUMULADORES POR ESTUDIANTE
		 aConAlu := {}
		 FOR i := 1 TO LEN(cConcep)/2
		     AADD(aConAlu,0)           // Conceptos Mes
		 ENDFOR
		 AADD(aConAlu,0)               // Intereses Pagados
		 AADD(aConAlu,0)               // Total del Estudiante
		 AADD(aConAlu,0)               // Valor Pagado.
*--------------FIN INICIALIZACION DE ACUMULADORES POR ESTUDIANTE

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('MES : '+cMes(nMesIniTpa)+;
			     'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

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

*--------------CALCULO DE LOS DIFERENTES PAGOS
		 nDeuAnt := 0
		 IF lHayAlu .AND. lHayPag

*...................ANALISIS DE LA FECHA DE PAGO
		      lFechOk := .T.
		      IF PAG->cEstadoPag == 'P' .OR.;
			 PAG->cEstadoPag == 'A'
			 IF lPrnFec
			    IF PAG->dFecPagPag < dFecIni .OR.;
			       PAG->dFecPagPag > dFecFin
			       lFechOk := .F.
			    ENDIF
			 ENDIF
		      ENDIF
*...................FIN ANALISIS DE LA FECHA DE PAGO

*...................ANALISIS DEL MES ACTUAL
		      lMesAct := .T.
		      IF nMesIniTpa < LEN(RTRIM(CLI->cMesPagCli))
			 lMesAct := .F.
		      ENDIF
*...................FIN ANALISIS DEL MES ACTUAL

*...................ANALISIS DEL PAGO DEL ATRASO
		      nTotAbo := PAG->nAbonosPag
		      IF (PAG->cEstadoPag == 'P'   .OR.;
			  PAG->cEstadoPag == 'A') .AND.;
			  (nTipPrn == 2 .OR. nTipPrn == 4) .AND.;
			  lFechOk

			 IF CAA->nMesAmnCaA # nMesIniTpa
			    nDeuAnt := PAG->nSdoAntPag

			    aConAlu[LEN(aConAlu)-2] += PAG->nMorAntPag
			    aConGru[LEN(aConGru)-2] += PAG->nMorAntPag
			    aTotNiv[LEN(aTotNiv)-2] += PAG->nMorAntPag
			    aTotCon[LEN(aTotCon)-2] += PAG->nMorAntPag
			  *ÀIntereses Pagados

			    aConAlu[LEN(aConAlu)-1] += PAG->nMorAntPag
			    aConGru[LEN(aConGru)-1] += PAG->nMorAntPag
			    aTotNiv[LEN(aTotNiv)-1] += PAG->nMorAntPag
			    aTotCon[LEN(aTotCon)-1] += PAG->nMorAntPag
			  *ÀTotales Calculados

			    aConAlu[LEN(aConAlu)] += PAG->nSdoAntPag+PAG->nMorAntPag
			    aConGru[LEN(aConGru)] += PAG->nSdoAntPag+PAG->nMorAntPag
			    aTotNiv[LEN(aTotNiv)] += PAG->nSdoAntPag+PAG->nMorAntPag
			    aTotCon[LEN(aTotCon)] += PAG->nSdoAntPag+PAG->nMorAntPag
			  *ÀTotales fijos

			 ENDIF
		      ENDIF
*...................FIN ANALISIS DEL PAGO DEL ATRASO

*...................DESCRIMINACION DE LOS ATRASOS
		      IF lFechOk .AND. nDeuAnt # 0 .AND.;
			(nTipPrn == 2 .OR. nTipPrn == 4)
			 nRegPag := PAG->(RECNO())
			 nTotRec := nDivAtrPag(CLI->cCodigoEst,;
					       nDeuAnt,cConcep,;
					       aConAlu,aConGru,;
					       aTotNiv,aTotCon)
			 IF nTotRec # 0
			    PAG->(DBGOTO(nRegPag))
			    IF !lDivRecPag(CLI->cCodigoEst,;
					  nTotRec,cConcep,;
					  aConAlu,aConGru,;
					  aTotNiv,aTotCon)
			       cMsgErr += 'R'
			    ENDIF
			 ENDIF
		      ENDIF
*...................FIN DESCRIMINACION DE LOS ATRASOS

*...................DESCRIMINACION DE ABONOS
		      IF nTotAbo # 0 .AND.;
			 (nTipPrn == 3 .OR. nTipPrn == 4)
			 nRegPag := PAG->(RECNO())
			 nTotRec := nDivAboPag(CLI->cCodigoEst,;
					       nTotAbo,nMesIniTpa,;
					       cConcep,aConAlu,;
					       aConGru,aTotNiv,;
					       aTotCon,dFecIni,dFecFin)

			 IF nTotRec # 0
			    PAG->(DBGOTO(nRegPag))
			    DivRecMes(CLI->cCodigoEst,;
				      nTotRec,cConcep,;
				      aConAlu,aConGru,;
				      aTotNiv,aTotCon)
			 ENDIF
		      ENDIF
*...................FIN DESCRIMINACION DE ABONOS

*...................DESCRIMINACION DE LOS PAGOS POR MESES
		      IF lFechOk .AND. nDeuAnt # 0

			 nMesPag := MONTH(PAG->dFecPagPag)
			 IF nMesPag <= 0 .OR. nMesPag > 12
			    nMesPag := 13
			 ENDIF
		       *ÀAnalisis del mes de pago

			 aPagMes[nMesPag] += nDeuAnt
			*Totalizaci¢n del pago
		      ENDIF
*...................FIN DESCRIMINACION DE LOS PAGOS POR MESES

		 ENDIF
*--------------FIN CALCULO DE LOS DIFERENTES PAGOS

*--------------IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE
		 IF lValida
		    aTitulo := {}
		    AADD(aTitulo,GRU->cCodigoGru)
		    FOR i := 1 TO LEN(cConcep)/2
			AADD(aTitulo,TRANS(aConAlu[i],"####,###,###"))
		    ENDFOR
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-2],"####,###,###"))
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-1],"####,###,###"))
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-0],"####,###,###"))

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
			       '=>'+CLI->cCodigoEst+'-'+STR(CLI->(RECNO()),2)+;
			       IF(aConAlu[LEN(aConAlu)-1] = aConAlu[LEN(aConAlu)],'',;
				  'REVISAR '+cMsgErr)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE

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
	    FOR i := 1 TO LEN(cConcep)/2
		IF i == 1
		   AADD(aTitulo,TRANS(aConGru[i],"####,###,###"))
		ELSE
		   AADD(aTitulo,TRANS(aConGru[i],"####,###,###"))
		ENDIF
	    ENDFOR
	    AADD(aTitulo,TRANS(aConGru[LEN(aConGru)-2],"####,###,###"))
	    AADD(aTitulo,TRANS(aConGru[LEN(aConGru)-1],"####,###,###"))
	    AADD(aTitulo,TRANS(aConGru[LEN(aConGru)-0],"####,###,###"))

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		       IF(aConGru[LEN(aConGru)-1] = aConGru[LEN(aConGru)],'',;
			  'REVISAR')
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    nPagos  := 0
	    nNroExt := 0
	    nNroDeu := 0
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
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aTitulo,TRANS(aTotNiv[i],"####,###,###"))
	       ENDFOR
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-2],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-1],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-0],"####,###,###"))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       @ PROW()+1,00 SAY ''

	       aTotNiv := {}
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aTotNiv,0)  // Concepto Mes
	       ENDFOR
	       AADD(aTotNiv,0)  // Intereses Pagados
	       AADD(aTotNiv,0)  // Total Nivel
	       AADD(aTotNiv,0)  // Total Pagado

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
       FOR i := 1 TO LEN(aTotCon)
	   @ PROW(),nColCab+nColTxt(aNroCol,i+1) SAY REPL('=',aNroCol[i+1])
       ENDFOR

       aTitulo := {}
       AADD(aTitulo,'TOT.')
       FOR i := 1 TO LEN(cConcep)/2
	   AADD(aTitulo,TRANS(aTotCon[i],"####,###,###"))
       ENDFOR
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-2],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-1],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-0],"####,###,###"))

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS TOTALES

/*
*>>>>IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES
       aNroCol := {}
       aTitulo := {}
       aTotMes := {}
	aTotal := {}
       FOR i := 1 TO 12
	   IF !EMPTY(aPagMes[i]) .OR.;
	      !EMPTY(aParMes[i])

	      AADD(aNroCol,12)
	      AADD(aTitulo,cMes(i,3))
	      AADD(aTotMes,SPACE(12))
	      AADD(aTotal,0)
	   ENDIF
       ENDFOR

       IF !EMPTY(aPagMes[13]) .OR.;
	  !EMPTY(aParMes[13])

	  AADD(aNroCol,12)
	  AADD(aTitulo,'SIN FECHA')
	  AADD(aTotMes,SPACE(12))
	  AADD(aTotal,0)
       ENDIF

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')
       AADD(aTotMes,SPACE(12))
       AADD(aTotal,0)

       cTxtPrn := 'GRANDES TOTALES '+cRegPrint(aTitulo,aNroCol)
       lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES

*>>>>IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES
       FOR i := 1 TO 3

	   DO CASE
	   CASE i == 1  // PAGOS NORMALES

****************INICIALIZACION DE LOS TOTALES POR MES
		  FOR j := 1 TO LEN(aTotMes)
		      aTotMes[j] := SPACE(12)
		  ENDFOR
****************FIN INICIALIZACION DE LOS TOTALES POR MES

****************PAGOS NORMALES POR MESES
		  nTotPag := 0
		  FOR j := 1 TO 13

*---------------------PREPARACION DE LA IMPRESION
			IF !EMPTY(aPagMes[j])

			   IF j == 13
			      nNroMes := LEN(aTitulo)-1
			   ELSE
			      nNroMes := ASCAN(aTitulo,;
					      {|aArray| aArray == cMes(j,3)})
			   ENDIF

			   aTotMes[nNroMes] := TRANS(aPagMes[j],"####,###,###")
			   aTotal[nNroMes] += aPagMes[j]
			   nTotPag   += aPagMes[j]
			ENDIF
*---------------------FIN PREPARACION DE LA IMPRESION

		  ENDFOR
		  aTotMes[LEN(aTotMes)] := TRANS(nTotPag,"####,###,###")
		  aTotal[LEN(aTotal)] += nTotPag
****************FIN PAGOS NORMALES POR MESES

****************IMPRESION DE LOS PAGOS NORMALES
		  cTxtPrn := 'PAGOS  EN       '+cRegPrint(aTotMes,aNroCol)

		  nLenEle := 0
		  ASCAN(aTotMes,{|aArray| nLenEle += VAL(aArray)})
		 *Analisis del Contenido del vector.

		  IF !EMPTY(nLenEle)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		  ENDIF
****************FIN IMPRESION DE LOS PAGOS NORMALES

	   CASE i == 2  // ABANOS

****************INICIALIZACION DE LOS TOTALES POR MES
		  FOR j := 1 TO LEN(aTotMes)
		      aTotMes[j] := SPACE(12)
		  ENDFOR
****************FIN INICIALIZACION DE LOS TOTALES POR MES

****************ABONOS POR MESES
		  nVlrAbo := 0
		  FOR j := 1 TO 13

*---------------------PREPARACION DE LA IMPRESION
			IF !EMPTY(aAboMes[j])

			   IF j == 13
			      nNroMes := LEN(aTitulo)-1
			   ELSE
			      nNroMes := ASCAN(aTitulo,;
					      {|aArray| aArray == cMes(j,3)})
			   ENDIF

			   aTotMes[nNroMes] := TRANS(aAboMes[j],"####,###,###")
			   aTotal[nNroMes] += aAboMes[j]
			     nVlrAbo += aAboMes[j]
			ENDIF
*---------------------FIN PREPARACION DE LA IMPRESION

		  ENDFOR
		  aTotMes[LEN(aTotMes)] := TRANS(nVlrAbo,"####,###,###")
		  aTotal[LEN(aTotal)] += nVlrAbo
****************FIN ABONOS POR MESES

****************IMPRESION DE LOS ABONOS
		  cTxtPrn := 'ABONOS EN       '+cRegPrint(aTotMes,aNroCol)

		  nLenEle := 0
		  ASCAN(aTotMes,{|aArray| nLenEle += VAL(aArray)})
		 *Analisis del Contenido del vector.

		  IF !EMPTY(nLenEle)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		  ENDIF
****************FIN IMPRESION DE LOS ABONOS

	   CASE i == 3  // PAGOS PARCIALES

****************INICIALIZACION DE LOS TOTALES POR MES
		  FOR j := 1 TO LEN(aTotMes)
		      aTotMes[j] := SPACE(12)
		  ENDFOR
****************FIN INICIALIZACION DE LOS TOTALES POR MES

****************PAGOS PARCIALES POR MESES
		  nTotPar := 0
		  FOR j := 1 TO 13

*---------------------PREPARACION DE LA IMPRESION
			IF !EMPTY(aParMes[j])

			   IF j == 13
			      nNroMes := LEN(aTitulo)-1
			   ELSE
			      nNroMes := ASCAN(aTitulo,;
					      {|aArray| aArray == cMes(j,3)})
			   ENDIF

			   aTotMes[nNroMes] := TRANS(aParMes[j],"####,###,###")
			   aTotal[nNroMes] += aParMes[j]
			     nTotPar += aParMes[j]
			ENDIF
*---------------------FIN PREPARACION DE LA IMPRESION

		  ENDFOR
		  aTotMes[LEN(aTotMes)] := TRANS(nTotPar,"####,###,###")
		  aTotal[LEN(aTotal)] += nTotPar
****************FIN PAGOS PARCIALES POR MESES

****************IMPRESION DE LOS PAGOS PARCIALES
		  cTxtPrn := 'PAGOS PARCIALES '+cRegPrint(aTotMes,aNroCol)

		  nLenEle := 0
		  ASCAN(aTotMes,{|aArray| nLenEle += VAL(aArray)})
		 *Analisis del Contenido del vector.

		  IF !EMPTY(nLenEle)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		  ENDIF
****************FIN IMPRESION DE LOS PAGOS PARCIALES

	   ENDCASE
       ENDFOR
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES

*>>>>IMPRESION DEL GRAN TOTAL
       @ PROW()+1,00 SAY ''
       FOR i := 1 TO LEN(aTotal)
	   @ PROW(),16+nColTxt(aNroCol,i) SAY REPL('=',aNroCol[i])
       ENDFOR

       aTitulo := {}
       FOR i := 1 TO LEN(aTotal)
	   AADD(aTitulo,TRANS(aTotal[i],"####,###,###"))
       ENDFOR
       cTxtPrn := 'TOTALES         '+cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DEL GRAN TOTAL
*/

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

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: DESCRIMINACION DE CONCEPTOS POR PAGOS DE ATRASOS             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 12:00 AM   MAY 16/2002 JUE

OBJETIVOS:

1- Permite descriminar los conceptos por pago de los atrasos

2- Retorna el total de recargos pagados por descriminar


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nDivAtrPag(cCodEst,nDeuAnt,cConcep,aConAlu,;
		    aConGru,aTotNiv,aTotCon,lSwPaso)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nDeuAnt                              // Deuda Anterior
       cConcep                              // Conceptos a Descriminar
       aConGru                              // Conceptos por Grupos
       aTotNiv                              // Conceptos por Niveles
       aTotCon                              // Conceptos totales
       lSwPaso                              // Control de Flujo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayPag := .F.                 // .T. Hay Pagos
       LOCAL nTotRec := 0                   // Total de Recargos
       LOCAL nNroPos := 0                   // N£mero de la Posicion del Concepto
       LOCAL nVlrCon := 0                   // Valor del Concepto

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DE CONCEPTOS DE LOS ATRASOS
       lSwPaso := IF(lSwPaso == NIL,.T.,lSwPaso)
       DO WHILE nDeuAnt # 0

**********LOCALIZACION DEL PAGO DEL ATRASO
	    IF lSwPaso
	       lHayPag := lLocCodPag(cCodEst,PAG->nMesIniPag-1,.F.)
	    ENDIF

	    IF !lHayPag .OR. PAG->cEstadoPag # 'D'
	       EXIT
	    ENDIF
	    nTotRec += PAG->nVlrRecPag
	    nDeuAnt -= PAG->nVlrRecPag
**********FIN LOCALIZACION DEL PAGO DEL ATRASO

**********CALCULO PARA CADA UNO DE LOS CONCEPTOS
	    FOR i := 1 TO LEN(cConcep)/2

*---------------LOCALIZACION DEL VALOR DEL CONCEPTO
		  cCodigoTco := SUBS(cConcep,i*2-1,2)
		  lLocCodigo('cCodigoCon','CON',cCodigoTco)
		  SELECT PAG
		  IF cCodigoTco $ PAG->cConcepPag
		     nNroPos := (AT(cCodigoTco,;
				    PAG->cConcepPag)+1)/2
		     nVlrCon := &('nVlrCo'+;
				  STR(nNroPos,1)+'Pag')
		  ELSE
		     LOOP
		  ENDIF
*---------------FIN LOCALIZACION DEL VALOR DEL CONCEPTO

*---------------ANALISIS DEL PAGO DE LA DEUDA ANTERIOR
		  IF nDeuAnt <= nVlrCon
		     nVlrCon := nDeuAnt
		  ENDIF
		  nDeuAnt -= nVlrCon
*---------------FIN ANALISIS DEL PAGO DE LA DEUDA ANTERIOR

*---------------TOTALIZACION DEL CONCEPTO PAGADO
		  aConAlu[i] += nVlrCon
		  aConGru[i] += nVlrCon
		  aTotNiv[i] += nVlrCon
		  aTotCon[i] += nVlrCon
		*ÀValor pagado del concepto

		  aConAlu[LEN(aConAlu)-1] += nVlrCon
		  aConGru[LEN(aConGru)-1] += nVlrCon
		  aTotNiv[LEN(aTotNiv)-1] += nVlrCon
		  aTotCon[LEN(aTotCon)-1] += nVlrCon
		*ÀTotales Calculados
*---------------TOTALIZACION DEL CONCEPTO PAGADO

*---------------ANALISIS DEL TOTAL DE LA DEUDA
		  IF nDeuAnt == 0
		     EXIT
		  ENDIF
*---------------FIN ANALISIS DEL TOTAL DE LA DEUDA

	    ENDFOR
	    lSwPaso := .T.
**********FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS

       ENDDO
       RETURN nTotRec
*>>>>FIN DESCRIMINACION DE CONCEPTOS DE LOS ATRASOS

/*************************************************************************
* TITULO..: DESCRIMINACION DE CONCEPTOS POR PAGOS DE RECARGOS            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 12:00 AM   MAY 16/2002 JUE

OBJETIVOS:

1- Permite descriminar los conceptos por pago de los recargos

2- Retorna el total de recargos pagados por descriminar


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lDivRecPag(cCodEst,nTotRec,cConcep,aConAlu,aConGru,aTotNiv,aTotCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nTotRec			            // Total de Recargos
       cConcep                              // Conceptos a Descriminar
       aConGru                              // Conceptos por Grupos
       aTotNiv                              // Conceptos por Niveles
       aTotCon                              // Conceptos totales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayPag := .F.                 // .T. Hay Pagos
       LOCAL nNroPos := 0                   // N£mero de la Posicion del Concepto
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nVlrRec := 0                   // Valor de los Recargos
       LOCAL nRecarg := 0                   // Total de Recargos

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESCRIMINACION DE CONCEPTOS DE LOS ATRASOS
       nRecarg := nTotRec
       DO WHILE nTotRec # 0

**********LOCALIZACION DEL PAGO DEL ATRASO
	    lHayPag := lLocCodPag(cCodEst,PAG->nMesIniPag-1,.F.)

	    IF !lHayPag .OR. PAG->cEstadoPag # 'D'
	       EXIT
	    ENDIF
**********FIN LOCALIZACION DEL PAGO DEL ATRASO

**********VALIDACION DEL RECARGO
	    IF PAG->nVlrRecPag == 0
	       LOOP
	    ENDIF
	    nVlrRec += PAG->nVlrRecPag
**********FIN VALIDACION DEL RECARGO

**********DESCRIMINACION DEL RECARGO DEL MES
	    DivRecMes(cCodEst,PAG->nVlrRecPag,cConcep,;
		      aConAlu,aConGru,aTotNiv,aTotCon)
	    nTotRec -= PAG->nVlrRecPag
**********FIN DESCRIMINACION DEL RECARGO DEL MES

       ENDDO
       RETURN IF(nRecarg == nVlrRec,.T.,.F.)
*>>>>FIN DESCRIMINACION DE CONCEPTOS DE LOS ATRASOS

/*************************************************************************
* TITULO..: DESCRIMINACION DE CONCEPTOS POR PAGOS DE ABONOS              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2002 MAR A
       Bucaramanga, Colombia	    INICIO: 09:30 AM   MAY 21/2002 MAR

OBJETIVOS:

1- Permite descriminar los conceptos por pago de los abonos

2- Retorna el total de recargos pagados por descriminar


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nDivAboPag(cCodEst,nAbonos,nMesIni,cConcep,aConAlu,;
		    aConGru,aTotNiv,aTotCon,dFecIni,dFecFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nAbonos			            // Total de Abonos
       nMesIni                              // Mes Inicial del Abono
       cConcep                              // Conceptos a Descriminar
       aConGru                              // Conceptos por Grupos
       aTotNiv                              // Conceptos por Niveles
       aTotCon                              // Conceptos totales
       dFecIni                              // Fecha Inicial
       dFecFin                              // Fecha Final */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayPag := .F.                 // .T. Hay Pagos
       LOCAL nTotRec := 0                   // Total de Recargos
       LOCAL nNroPos := 0                   // N£mero de la Posicion del Concepto
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nVlrAbo := 0                   // Valor de los Abonos
       LOCAL nTotAbo := 0                   // Total de Abonos
       LOCAL nVlrInt := 0                   // Valor de los Intereses
       LOCAL lFechOk := .T.                 // Fecha de Acuerdo al intervalo

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DE LOS ABONOS
       SELECT DES
       SET FILTER TO DES->cCodigoEst == cCodEst .AND.;
		     DES->nNroMesDes == nMesIni .AND.;
		     DES->nTipDesDes == 3  // Abonos
       GO TOP
       IF DES->(EOF())
	  SET FILTER TO
	  RETURN nTotRec
       ENDIF
*>>>>FIN FILTRACION DE LOS ABONOS

*>>>>VERIRIFICACION DE LOS ABONOS
       SELECT DES
       GO TOP
       DO WHILE .NOT. DES->(EOF())

**********VALIDACION DE LA FECHA DEL ABONO
	    lFechOk := .T.
	    IF !EMPTY(dFecIni) .AND. !EMPTY(dFecIni)
	       IF DES->dFechaDes < dFecIni .OR.;
		  DES->dFechaDes > dFecFin
		  lFechOk := .F.
	       ENDIF
	    ENDIF
	    IF lFechOk
	       nTotAbo += DES->nValorDes
	    ENDIF
**********FIN VALIDACION DE LA FECHA DEL ABONO

	  DES->(DBSKIP())

       ENDDO
*>>>>FIN VERIRIFICACION DE LOS ABONOS

*>>>>ACUMULACION DEL ABONO
       aConAlu[LEN(aConAlu)] += nTotAbo
       aConGru[LEN(aConGru)] += nTotAbo
       aTotNiv[LEN(aTotNiv)] += nTotAbo
       aTotCon[LEN(aTotCon)] += nTotAbo
     *ÀTotales fijos
*>>>>FIN ACUMULACION DEL ABONO

*>>>>DESCRIMINACION DE LOS ABONOS
       SELECT DES
       GO TOP
       DO WHILE .NOT. DES->(EOF())

**********VALIDACION DE LA FECHA DEL ABONO
	    lFechOk := .T.
	    IF !EMPTY(dFecIni) .AND. !EMPTY(dFecIni)
	       IF DES->dFechaDes < dFecIni .OR.;
		  DES->dFechaDes > dFecFin
		  lFechOk := .F.
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE LA FECHA DEL ABONO

**********CALCULO DE LOS INTERESES
	    IF DES->dFechaDes > PAG->dPagExtPag .AND. lFechOk
	       nVlrInt := nIntMes(DES->nSdoAntPag+DES->nVlrMesPag)
	       nVlrInt := DES->nMorAntPag+nVlrInt
	    ELSE
	       nVlrInt := DES->nMorAntPag
	    ENDIF
	    IF lFechOk
	       nVlrAbo := DES->nValorDes - nVlrInt
	    ENDIF
**********FIN CALCULO DE LOS INTERESES

**********ACUMULACION DE LOS INTERESES
	    IF lFechOk
	       aConAlu[LEN(aConAlu)-2] += nVlrInt
	       aConGru[LEN(aConGru)-2] += nVlrInt
	       aTotNiv[LEN(aTotNiv)-2] += nVlrInt
	       aTotCon[LEN(aTotCon)-2] += nVlrInt
	     *ÀIntereses Pagados

	       aConAlu[LEN(aConAlu)-1] += nVlrInt
	       aConGru[LEN(aConGru)-1] += nVlrInt
	       aTotNiv[LEN(aTotNiv)-1] += nVlrInt
	       aTotCon[LEN(aTotCon)-1] += nVlrInt
	     *ÀTotales Calculados
	    ENDIF
**********FIN ACUMULACION DE LOS INTERESES

**********DESCRIMINACION DE DEL ABONO
	    lHayPag := .T.
	    DO WHILE nVlrAbo # 0 .AND. lFechOk

*--------------VALIDACION DEL PAGO
		 IF !lHayPag
		    EXIT
		 ENDIF
		 nTotRec += PAG->nVlrRecPag
		 nVlrAbo -= PAG->nVlrRecPag
*--------------FIN VALIDACION DEL PAGO

*--------------CALCULO PARA CADA UNO DE LOS CONCEPTOS
		 FOR i := 1 TO LEN(cConcep)/2

*....................LOCALIZACION DEL VALOR DEL CONCEPTO
		       cCodigoTco := SUBS(cConcep,i*2-1,2)
		       lLocCodigo('cCodigoCon','CON',cCodigoTco)
		       SELECT PAG
		       IF cCodigoTco $ PAG->cConcepPag
			  nNroPos := (AT(cCodigoTco,;
					 PAG->cConcepPag)+1)/2
			  nVlrCon := &('nVlrCo'+;
				       STR(nNroPos,1)+'Pag')
		       ELSE
			  LOOP
		       ENDIF
*....................FIN LOCALIZACION DEL VALOR DEL CONCEPTO

*....................ANALISIS DEL PAGO DEL CONCEPTO
		       IF nVlrAbo <= nVlrCon
			  nVlrCon := nVlrAbo
		       ENDIF
		       nVlrAbo -= nVlrCon
*....................FIN ANALISIS DEL PAGO DEL CONCEPTO

*....................TOTALIZACION DEL CONCEPTO PAGADO
		       aConAlu[i] += nVlrCon
		       aConGru[i] += nVlrCon
		       aTotNiv[i] += nVlrCon
		       aTotCon[i] += nVlrCon
		     *ÀValor pagado del concepto

		       aConAlu[LEN(aConAlu)-1] += nVlrCon
		       aConGru[LEN(aConGru)-1] += nVlrCon
		       aTotNiv[LEN(aTotNiv)-1] += nVlrCon
		       aTotCon[LEN(aTotCon)-1] += nVlrCon
		     *ÀTotales Calculados
*....................FIN TOTALIZACION DEL CONCEPTO PAGADO

*....................ANALISIS DEL ABONO
		       IF nVlrAbo == 0
			  EXIT
		       ENDIF
*....................FIN ANALISIS DEL ABONO

		 ENDFOR
		 lHayPag := lLocCodPag(cCodEst,PAG->nMesIniPag-1,.F.)
*--------------FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS

	    ENDDO
**********FIN DESCRIMINACION DE DEL ABONO

	  DES->(DBSKIP())

       ENDDO
       SELECT DES
       SET FILTER TO
       RETURN nTotRec
*>>>>FIN DESCRIMINACION DE LOS ABONOS

/*************************************************************************
* TITULO..: DESCRIMINACION DE CONCEPTOS DEL RECARGO MENSUAL              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 03:00 AM   MAY 21/2002 JUE

OBJETIVOS:

1- Permite determinar el valor de los conceptos pagados por el recargo
   del mes.

2- Retorna .T. si no se presentaron problemas


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DivRecMes(cCodEst,nTotRec,cConcep,aConAlu,aConGru,aTotNiv,aTotCon)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       nTotRec			            // Total de Recargos
       cConcep                              // Conceptos a Descriminar
       aConGru                              // Conceptos por Grupos
       aTotNiv                              // Conceptos por Niveles
       aTotCon                              // Conceptos totales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL lHayPag := .F.                 // .T. Hay Pagos
       LOCAL nNroPos := 0                   // N£mero de la Posicion del Concepto
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL nVlrRec := 0                   // Valor de los Recargos
       LOCAL nRecarg := 0                   // Total de Recargos

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>BUSQUEDA DEL RECARGO
       IF !(lSekCodDes(cCodEst,PAG->nMesIniPag,.F.) .AND.;
		       DES->nTipDesDes == 2) // Recargo
	  RETURN NIL
       ENDIF
*>>>>FIN BUSQUEDA DEL RECARGO

*>>>>CALCULO PARA CADA UNO DE LOS CONCEPTOS
       FOR i := 1 TO LEN(cConcep)/2

***********LECTURA DEL VALOR DE LOS CONCEPTOS DEL RECARGO
	     cCodigoTco := SUBS(cConcep,i*2-1,2)
	     IF cCodigoTco $ DES->cConcepDes
		nNroPos := (AT(cCodigoTco,DES->cConcepDes)+1)/2
		nVlrCon := &('DES->nVlrCo'+STR(nNroPos,1)+'Des')
	     ELSE
		LOOP
	     ENDIF
***********FIN LECTURA DEL VALOR DE LOS CONCEPTOS DEL RECARGO

***********ANALISIS DEL VALOR DEL CONCEPTO
	     IF nTotRec <= nVlrCon
		nVlrCon := nTotRec
	     ENDIF
	     nTotRec -= nVlrCon
***********FIN ANALISIS DEL VALOR DEL CONCEPTO

***********TOTALIZACION DEL CONCEPTO PAGADO DEL RECARGO
	     aConAlu[i] += nVlrCon
	     aConGru[i] += nVlrCon
	     aTotNiv[i] += nVlrCon
	     aTotCon[i] += nVlrCon
	   *ÀValor pagado del concepto

	     aConAlu[LEN(aConAlu)-1] += nVlrCon
	     aConGru[LEN(aConGru)-1] += nVlrCon
	     aTotNiv[LEN(aTotNiv)-1] += nVlrCon
	     aTotCon[LEN(aTotCon)-1] += nVlrCon
	   *ÀTotales Calculados
***********FIN TOTALIZACION DEL CONCEPTO PAGADO DEL RECARGO

***********ANALISIS DEL TOTAL DE LA DEUDA
	     IF nTotRec == 0
		EXIT
	     ENDIF
***********FIN ANALISIS DEL TOTAL DE LA DEUDA

       ENDFOR
       RETURN NIL
*>>>>FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS


