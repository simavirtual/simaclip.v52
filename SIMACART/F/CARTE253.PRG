/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: PAGOS DEL MES                            MODULO No. 253

**************************************************************************
* TITULO..: PAGOS DEL MES                                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 16/98 JUE A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   JUL 16/98 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir el total de la facturaci¢n incluyendo los pagos
   extemporaneos y los pagos por anticipos.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_253(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"  // Impresora EPSON FX
       #INCLUDE "ARC-FACT.PRG"              // Archivos del Sistema

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
       LOCAL lAllGru := .F.                 // .T. Todos los Grupos

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
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aTitPrn := {}                  // Registros de Impresion
       LOCAL aTitTem := {}                  // Temporal
     *ÀVariables de informe

       LOCAL nVlrSdo := 0                   // Valor del saldo
       LOCAL nIntMor := 0                   // Intereses por mora
       LOCAL nVlrDeu := 0                   // Valor de la deuda
       LOCAL nVlrPag := 0                   // Valor de los pagos sin anticipos
       LOCAL nMesPag := 0                   // N£mero del Mes de pago
       LOCAL cNroAno := ''                  // N£mero del A¤o
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL nSinFec := 0                   // Sin Fecha de Pago
       LOCAL nDeudor := 0                   // Deudores

       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrIng := 0                   // Valor de los ingresos
       LOCAL nVlrMes := 0                   // Valor de lo facturado

       LOCAL aFilExt := {}                  // Archivos Extracto de los pagos

       LOCAL aPagMes[13]                    // Pagos por Meses
       LOCAL aAboMes[13]                    // Abonos por Meses
       LOCAL aParMes[13]                    // Pagos Parciales por Meses
       LOCAL aVlrPag := {}                  // Total Pagos
       LOCAL nTotAbo := 0                   // Total Abonos
       LOCAL lPagMes := .F.                 // .T. Hay pagos descriminados por meses

       LOCAL aConAlu := {}                  // Valores por conceptos por alumno
       LOCAL aVlrCon := {}                  // Valores por conceptos
       LOCAL aTotNiv := {}                  // Totales por conceptos por nivel
       LOCAL aTotCon := {}                  // Totales por conceptos
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL aVlrDif := {}                  // Valor Diferencia

       LOCAL lMesAct := .T.                 // .T. Mes Actual.
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nSdoMor := 0                   // Saldo de la Mora
       LOCAL nNroNiv := 0                   // N£mero de Niveles
       LOCAL nPagos := 0                    // N£mero de Pagos
       LOCAL nNroDeu := 0                   // N£mero de Deudores
       LOCAL nNroExt := 0                   // N£mero de Extemporaneos
       LOCAL nPagTot := 0                   // Total de n£mero de pagos
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
       LOCAL cConcep := ''                  // Conceptos
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
       LOCAL nMesAmn := 0                   // Mes de Anmistia
       LOCAL nRegTop := 0                   // Registro Inicial
       LOCAL nRegBot := 0                   // Registro Final
       LOCAL lHayXml := .T.                 // .T. Imprimir Archivo
       LOCAL PathAct := ''                  // Path Actual
       LOCAL cLinUrl := ''                  // Link de Url
       LOCAL PathWww := ''                  // Path del Sitio
       LOCAL cCodBan := ''                  // C¢digo del Banco
       LOCAL lAllInf := .T.                 // .T. Todo el Informe .F. Sole Resumen

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
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

*>>>>VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE (cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)) == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE (cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)) == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE(cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)) == -3
	    DIRMAKE(cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3))
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO DE LA FACTURACION

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCnc,'CNC',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileBan,'BAN',NIL,lShared,nModCry})
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
       BAN->(DBGOTOP())
       cCodBan := BAN->cCodigoBan
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CAR->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       nMesAmn := CAA->nMesAmnCaA
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LOS CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cConcep := CAA->cConPrnCaA

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
       IF CAA->(lRegLock(lShared,.F.))
	  REPL CAA->cConPrnCaA WITH cConcep
	  CAA->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA LOS CONCEPTOS A IMPRIMIR')
       ENDIF
       IF lShared
	  CAA->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DE LOS CONCEPTOS A IMPRIMIR

*>>>>ANALISIS DE DECISION
       lAllInf := !lPregunta('DESEA IMPRIMIR SOLO '+;
			    'EL RESUMEN DEL INFORME? No Si')
*>>>>FIN ANALISIS DE DECISION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin,@lAllGru)
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
       nPagos := 0
       lTamAnc := .F.
       aCabeza := {cNomEmp,cNomSis,;
		   'PAGOS DEL MES.'+;
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
		 AADD(aNroCol,16)                          // Conceptos Mes
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

       AADD(aNroCol,16)
       AADD(aTitulo,'INT PAGO MES')

       AADD(aNroCol,12)
       AADD(aTitulo,'PAGO ATRASOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'ANTICIPOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')

       AADD(aNroCol,12)
       AADD(aTitulo,'VLR PAGADO')

       AADD(aTotCon,0)  // Int Pago Mes
       AADD(aTotCon,0)  // Pago Atrasos
       AADD(aTotCon,0)  // Anticipos
       AADD(aTotCon,0)  // Total Nivel
       AADD(aTotCon,0)  // Total Pagado

       AADD(aTotNiv,0)  // Int Pago Mes
       AADD(aTotNiv,0)  // Pago Atrasos
       AADD(aTotNiv,0)  // Anticipos
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
       IF .NOT. lAllInf
	  cCabCol := ''
       ENDIF
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(CAR->cSerFacCar,1,1)+'p'+cAnoUsr+cNroMes
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
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

       GRU->(DBGOTOP())
       nRegTop := GRU->(RECNO())

       GRU->(DBGOBOTTOM())
       nRegBot := GRU->(RECNO())

       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       AFILL(aPagMes,0)                     // Inicializa los pagos en cero
       cNivAnt := SUBS(GRU->cCodigoGru,1,2)

       IF nRegTop # nRegIni .OR. nRegBot # nRegFin
	  lHayXml := .F.
       ENDIF

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
	    aVlrCon := {}
	    FOR i := 1 TO LEN(cConcep)/2
		AADD(aVlrCon,0)           // Conceptos Mes
	    ENDFOR
	    AADD(aVlrCon,0)               // Recargos
	    AADD(aVlrCon,0)               // Pago Atrasos
	    AADD(aVlrCon,0)               // Anticipos
	    AADD(aVlrCon,0)               // Total Nivel
	    AADD(aVlrCon,0)               // Total Pagado
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
		 AADD(aConAlu,0)               // Recargos
		 AADD(aConAlu,0)               // Pago Atrasos
		 AADD(aConAlu,0)               // Anticipos
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
		    cCodigoTgr := &cNalias->cCodigoGru
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
		 FileMoB := ''
*--------------FIN LOCALIZACION DEL PAGO

*--------------VALIDACION DE DEUDORES Y PAGOS SIN FECHA
		 IF lHayAlu .AND. lHayPag
		    DO CASE
		    CASE PAG->cEstadoPag == '*'
			 nDeudor++

		    CASE PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
			 IF CAA->lLeeFecCaA .AND. EMPTY(PAG->dFecPagPag)
			    nSinFec++
			 ENDIF
		    ENDCASE
		 ENDIF
*--------------FIN VALIDACION DE DEUDORES Y PAGOS SIN FECHA




*--------------CALCULO DE LOS DIFERENTES PAGOS
		 nVlrPag := 0
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

*...................CALCULO PARA CADA UNO DE LOS CONCEPTOS
		      IF lFechOk
		      FOR i := 1 TO LEN(cConcep)/2

*                         LOCALIZACION DEL VALOR DEL CONCEPTO
			    cCodigoTco := SUBS(cConcep,i*2-1,2)
			    lLocCodigo('cCodigoCon','CON',cCodigoTco)
			    SELECT PAG
			    IF cCodigoTco $ PAG->cConcepPag
			       nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
			       nVlrTar := &('nVlrCo'+STR(nNroPos,1)+'Pag')
			    ELSE
			       nVlrTar := 0
			    ENDIF
*                         FIN LOCALIZACION DEL VALOR DEL CONCEPTO

*                         TOTALIZACION DEL VALOR PAGADO
			    IF PAG->cEstadoPag == 'P' .OR.;
			       PAG->cEstadoPag == 'A'

			       nVlrPag += nVlrTar
			       aConAlu[i] := nVlrTar
			       aVlrCon[i] += nVlrTar
			       aTotNiv[i] += nVlrTar
			       aTotCon[i] += nVlrTar
			     *ÀValor pagado del concepto

			      aConAlu[LEN(aConAlu)-1] += nVlrTar
			      aVlrCon[LEN(aVlrCon)-1] += nVlrTar
			      aTotNiv[LEN(aTotNiv)-1] += nVlrTar
			      aTotCon[LEN(aTotCon)-1] += nVlrTar
			    *ÀTotales del Grupo

			    ENDIF
*                         FIN TOTALIZACION DEL VALOR PAGADO

		      ENDFOR
		      ENDIF
*...................FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS

*...................DESCUENTO DE LA BECA
		      IF (PAG->cEstadoPag == 'P'  .OR.;
			  PAG->cEstadoPag == 'A') .AND.lFechOk
			 IF PAG->lHayBecPag
			       nVlrPag -= PAG->nVlrBecPag
			    aConAlu[1] -= PAG->nVlrBecPag
			    aVlrCon[1] -= PAG->nVlrBecPag
			    aTotNiv[1] -= PAG->nVlrBecPag
			    aTotCon[1] -= PAG->nVlrBecPag
			  *ÀDescuento de la Beca

			    aConAlu[LEN(aConAlu)-1] -= PAG->nVlrBecPag
			    aVlrCon[LEN(aVlrCon)-1] -= PAG->nVlrBecPag
			    aTotNiv[LEN(aTotNiv)-1] -= PAG->nVlrBecPag
			    aTotCon[LEN(aTotCon)-1] -= PAG->nVlrBecPag
			  *ÀTotales del Grupo
			 ENDIF
		      ENDIF
*...................FIN DESCUENTO DE LA BECA

*...................MENOS DESCUENTOS
		      IF (PAG->cEstadoPag == 'P'  .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk
			    nVlrPag -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aConAlu[1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aVlrCon[1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aTotNiv[1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aTotCon[1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)

			 aConAlu[LEN(aConAlu)-1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aVlrCon[LEN(aVlrCon)-1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aTotNiv[LEN(aTotNiv)-1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
			 aTotCon[LEN(aTotCon)-1] -= (PAG->nVlrDesPag+PAG->nDesGenPag)
		       *ÀTotales del Grupo
		      ENDIF
*...................FIN MENOS DESCUENTOS

*...................MENOS PAGOS PARCIALES
		      IF (PAG->cEstadoPag == 'P'  .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk
			    nVlrPag -= PAG->nPagParPag
			 aConAlu[1] -= PAG->nPagParPag
			 aVlrCon[1] -= PAG->nPagParPag
			 aTotNiv[1] -= PAG->nPagParPag
			 aTotCon[1] -= PAG->nPagParPag

			 aConAlu[LEN(aConAlu)-1] -= PAG->nPagParPag
			 aVlrCon[LEN(aVlrCon)-1] -= PAG->nPagParPag
			 aTotNiv[LEN(aTotNiv)-1] -= PAG->nPagParPag
			 aTotCon[LEN(aTotCon)-1] -= PAG->nPagParPag
		       *ÀTotales del Grupo
		      ENDIF
*...................FIN MENOS PAGOS PARCIALES

*...................MAS RECARGOS
		      IF (PAG->cEstadoPag == 'P'  .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk

			    nVlrPag += PAG->nVlrRecPag+PAG->nRecGenPag
			 aConAlu[1] += PAG->nVlrRecPag+PAG->nRecGenPag
			 aVlrCon[1] += PAG->nVlrRecPag+PAG->nRecGenPag
			 aTotNiv[1] += PAG->nVlrRecPag+PAG->nRecGenPag
			 aTotCon[1] += PAG->nVlrRecPag+PAG->nRecGenPag

			 aConAlu[LEN(aConAlu)-1] += PAG->nVlrRecPag+;
						    PAG->nRecGenPag
			 aVlrCon[LEN(aVlrCon)-1] += PAG->nVlrRecPag+;
						    PAG->nRecGenPag
			 aTotNiv[LEN(aTotNiv)-1] += PAG->nVlrRecPag+;
						    PAG->nRecGenPag
			 aTotCon[LEN(aTotCon)-1] += PAG->nVlrRecPag+;
						    PAG->nRecGenPag
		       *ÀTotales del Grupo
		      ENDIF
*...................FIN MAS RECARGOS

*...................CALCULO DE LOS INTERESES
		      nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)
*...................FIN CALCULO DE LOS INTERESES


*...................CALCULO DE OTROS TOTALES
		      IF (PAG->cEstadoPag == 'P' .OR.;
			  PAG->cEstadoPag == 'A') .AND. lFechOk

*                        DESCRIMINACION DE LOS PAGOS POR MESES
			   IF CAA->lLeeFecCaA

*                             ANALISIS DEL MES DE PAGO
*				nMesPag := 13
*				IF YEAR(PAG->dFecPagPag) == VAL(cAnoUsr)
				   nMesPag := MONTH(PAG->dFecPagPag)
				   IF nMesPag <= 0 .OR. nMesPag > 12
				      nMesPag := 13
*				      cError(PAG->cCodigoEst+' NO TIENE MES PARA LA PENSION')
				   ENDIF
*				ENDIF
*                             FIN ANALISIS DEL MES DE PAGO


*                             TOTALIZACION DEL PAGO
				aVlrPagos(PAG->dFecPagPag,;
					  PAG->nVlrPagPag,@aVlrPag,1,;
					  PAG->cCodigoBan)

				aVlrPagExt(cPatSis,;
					   PAG->cCodigoBan,;
					   PAG->dFecPagPag,;
					   PAG->nVlrPagPag,;
					   0,; // nVlrTra
					   1,; // Recibo de pago
					   @aFilExt,;
					   @FileMoB)



				IF PAG->cEstadoPag == 'P'

				   aVlrDifExt(cAnoUsr,FileMoB,;
					      PAG->cCodigoEst,;
					      cCodigoTgr,;
					      PAG->nMesIniPag,;
					      PAG->nMesFinPag,;
					      PAG->cCodigoBan,;
					      PAG->dFecPagPag,;
					      PAG->nVlrPagPag,;
					      aVlrDif)
				ENDIF

				IF PAG->cEstadoPag == 'A'
				   aVlrDifExt(cAnoUsr,FileMoB,;
					      PAG->cCodigoEst,;
					      cCodigoTgr,;
					      PAG->nMesIniPag,;
					      PAG->nMesFinPag,;
					      PAG->cCodigoBan,;
					      PAG->dFecPagPag,;
					      PAG->nVlrPagPag+nVlrInt,;
					      aVlrDif)
				ENDIF

				aPagMes[nMesPag] += PAG->nVlrPagPag
				IF PAG->cEstadoPag == 'A'
				   aPagMes[nMesPag] += nVlrInt

				   aVlrPagos(PAG->dFecPagPag,;
					     nVlrInt,@aVlrPag,1,;
					     PAG->cCodigoBan)

				   aVlrPagExt(cPatSis,;
					      PAG->cCodigoBan,;
					      PAG->dFecPagPag,;
					      nVlrInt,;
					      0,; // nVlrTra
					      1,; // Recibo de pago
					      @aFilExt,;
					      @FileMoB)
				ENDIF
*                             FIN TOTALIZACION DEL PAGO

			   ENDIF
*                        FIN DESCRIMINACION DE LOS PAGOS POR MESES

*                        VALOR DE LOS INTERESES
			   nPagos++
			   nPagTot++
			   nVlrPag += PAG->nSdoAntPag+PAG->nMorAntPag

			   aConAlu[LEN(aConAlu)] := PAG->nVlrPagPag
			   aVlrCon[LEN(aVlrCon)] += PAG->nVlrPagPag
			   aTotNiv[LEN(aTotNiv)] += PAG->nVlrPagPag
			   aTotCon[LEN(aTotCon)] += PAG->nVlrPagPag
			 *ÀValor Pagado

			   IF PAG->cEstadoPag == 'A'

			      nNroExt++

			      aConAlu[LEN(aConAlu)] += nVlrInt
			      aVlrCon[LEN(aVlrCon)] += nVlrInt
			      aTotNiv[LEN(aTotNiv)] += nVlrInt
			      aTotCon[LEN(aTotCon)] += nVlrInt
			    *ÀValor Pagado

			      aConAlu[LEN(aConAlu)-4] := nVlrInt
			      aVlrCon[LEN(aVlrCon)-4] += nVlrInt
			      aTotNiv[LEN(aTotNiv)-4] += nVlrInt
			      aTotCon[LEN(aTotCon)-4] += nVlrInt
			    *ÀValor Recargo

			      aConAlu[LEN(aConAlu)-1] += nVlrInt
			      aVlrCon[LEN(aVlrCon)-1] += nVlrInt
			      aTotNiv[LEN(aTotNiv)-1] += nVlrInt
			      aTotCon[LEN(aTotCon)-1] += nVlrInt
			     *Total del grupo
			   ENDIF
*                        FIN VALOR DE LOS INTERESES

*                        VALOR ATRASOS PAGADOS
			   IF CAA->nMesAmnCaA # nMesIniTpa

			      aConAlu[LEN(aConAlu)-3] := PAG->nSdoAntPag+;
							 PAG->nMorAntPag
			      aVlrCon[LEN(aVlrCon)-3] += PAG->nSdoAntPag+;
							 PAG->nMorAntPag
			      aTotNiv[LEN(aTotNiv)-3] += PAG->nSdoAntPag+;
							 PAG->nMorAntPag
			      aTotCon[LEN(aTotCon)-3] += PAG->nSdoAntPag+;
							 PAG->nMorAntPag
			    *ÀValor atrasos

			      aConAlu[LEN(aConAlu)-1] += PAG->nSdoAntPag+;
						       PAG->nMorAntPag
			      aVlrCon[LEN(aVlrCon)-1] += PAG->nSdoAntPag+;
						       PAG->nMorAntPag
			      aTotNiv[LEN(aTotNiv)-1] += PAG->nSdoAntPag+;
						       PAG->nMorAntPag
			      aTotCon[LEN(aTotCon)-1] += PAG->nSdoAntPag+;
						       PAG->nMorAntPag
			    *ÀTotal del grupo

			   ENDIF
*                        FIN VALOR ATRASOS PAGADOS

*                        VALOR DE LOS ANTICIPOS
			   IF PAG->nMesIniPag # PAG->nMesFinPag .OR.;
			      lHayAntici(nMesIniTpa,PAG->cIniFinPag)

			      aConAlu[LEN(aConAlu)-2] := PAG->nVlrPagPag-;
							 nVlrPag
			      aVlrCon[LEN(aVlrCon)-2] += PAG->nVlrPagPag-;
							 nVlrPag
			      aTotNiv[LEN(aTotNiv)-2] += PAG->nVlrPagPag-;
							 nVlrPag
			      aTotCon[LEN(aTotCon)-2] += PAG->nVlrPagPag-;
							 nVlrPag
			    *ÀAnticipos

			      aConAlu[LEN(aConAlu)-1] += PAG->nVlrPagPag-;
						       nVlrPag
			      aVlrCon[LEN(aVlrCon)-1] += PAG->nVlrPagPag-;
						       nVlrPag
			      aTotNiv[LEN(aTotNiv)-1] += PAG->nVlrPagPag-;
						       nVlrPag
			      aTotCon[LEN(aTotCon)-1] += PAG->nVlrPagPag-;
						       nVlrPag
			    *ÀTotal del grupo

			   ENDIF
*                        FIN VALOR DE LOS ANTICIPOS

		      ENDIF
*...................FIN CALCULO DE OTROS TOTALES

		 ENDIF
*--------------FIN CALCULO DE LOS DIFERENTES PAGOS

*--------------IMPRESION DEL CONTENIDO DEL INFORME POR ESTUDIANTE
		 IF lValida
		    aTitulo := {}
		    AADD(aTitulo,GRU->cCodigoGru)
		    FOR i := 1 TO LEN(cConcep)/2
			IF i == 1
			   AADD(aTitulo,SPACE(02)+': '+;
				TRANS(aConAlu[i],"####,###,###"))
			ELSE
			   AADD(aTitulo,TRANS(aConAlu[i],"####,###,###"))
			ENDIF
		    ENDFOR
		    AADD(aTitulo,' '+SPACE(02)+':'+;
				 TRANS(aConAlu[LEN(aConAlu)-4],"####,###,###"))
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-3],"####,###,###"))
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-2],"####,###,###"))
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-1],"####,###,###"))
		    AADD(aTitulo,TRANS(aConAlu[LEN(aConAlu)-0],"####,###,###"))

		    cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
			       '=>'+CLI->cCodigoEst+'-'+STR(CLI->(RECNO()),2)+;
			       IF(aConAlu[LEN(aConAlu)-1] = aConAlu[LEN(aConAlu)],'',;
				  'REVISAR')
		    IF lAllInf
		       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		    ENDIF
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
		   AADD(aTitulo,STR(nPagos,2)+': '+;
			TRANS(aVlrCon[i],"####,###,###"))
		ELSE
		   AADD(aTitulo,TRANS(aVlrCon[i],"####,###,###"))
		ENDIF
	    ENDFOR
	    AADD(aTitulo,' '+STR(nNroExt,2)+':'+;
			 TRANS(aVlrCon[LEN(aVlrCon)-4],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrCon[LEN(aVlrCon)-3],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrCon[LEN(aVlrCon)-2],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrCon[LEN(aVlrCon)-1],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrCon[LEN(aVlrCon)-0],"####,###,###"))

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)+;
		       IF(aVlrCon[LEN(aVlrCon)-1] = aVlrCon[LEN(aVlrCon)],'',;
			  'REVISAR')

	    IF lAllInf
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    nPagos := 0
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


	       IF lAllInf
		  @ PROW()+1,00 SAY ''
	       ENDIF

	       FOR i := 1 TO LEN(aTotNiv)

		   IF lAllInf
		      @ PROW(),nColCab+nColTxt(aNroCol,i+1);
				       SAY REPL('-',aNroCol[i+1])
		   ENDIF

	       ENDFOR

	       aTitulo := {}
	       AADD(aTitulo,cNivAnt)
	       FOR i := 1 TO LEN(cConcep)/2
		   IF i == 1
		      AADD(aTitulo,SPACE(04)+;
			   TRANS(aTotNiv[i],"####,###,###"))
		   ELSE
		      AADD(aTitulo,TRANS(aTotNiv[i],"####,###,###"))
		   ENDIF
	       ENDFOR
	       AADD(aTitulo,SPACE(04)+;
			    TRANS(aTotNiv[LEN(aTotNiv)-4],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-3],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-2],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-1],"####,###,###"))
	       AADD(aTitulo,TRANS(aTotNiv[LEN(aTotNiv)-0],"####,###,###"))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)

	       IF lAllInf
		  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		  @ PROW()+1,00 SAY ''
	       ENDIF

	       aTotNiv := {}
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aTotNiv,0)  // Concepto Mes
	       ENDFOR
	       AADD(aTotNiv,0)  // Interes Pago Mes
	       AADD(aTotNiv,0)  // Pago Atrasos
	       AADD(aTotNiv,0)  // Anticipos
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
       IF lAllInf
	  @ PROW()+1,00 SAY ''
       ENDIF

       FOR i := 1 TO LEN(aTotCon)
	   IF lAllInf
	      @ PROW(),nColCab+nColTxt(aNroCol,i+1) SAY REPL('=',aNroCol[i+1])
	   ENDIF
       ENDFOR

       aTitulo := {}
       AADD(aTitulo,'TOT.')
       FOR i := 1 TO LEN(cConcep)/2
	   IF i == 1
	      AADD(aTitulo,SPACE(04)+TRANS(aTotCon[i],"####,###,###"))
	   ELSE
	      AADD(aTitulo,TRANS(aTotCon[i],"####,###,###"))
	   ENDIF
       ENDFOR
       AADD(aTitulo,SPACE(04)+TRANS(aTotCon[LEN(aTotCon)-4],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-3],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-2],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-1],"####,###,###"))
       AADD(aTitulo,TRANS(aTotCon[LEN(aTotCon)-0],"####,###,###"))

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       IF lAllInf
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS
       SET DEVICE TO SCREEN
       Termometro(0,'SUMANDO LOS ABONOS')
       Termometro(10)
       SELECT DES
       SET FILTER TO DES->nNroMesDes == nMesIniTpa
       GO TOP
       IF EOF()
	  SET FILTER TO
       ENDIF
       Termometro(30)
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS



*>>>>ABONOS POR GRUPOS
       AFILL(aAboMes,0)                     // Inicializa los Abonos en cero
       AFILL(aParMes,0)                     // Inicializa los Pagos en cero
       SELECT GRU
       GO TOP
       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********CALCULO DE LOS ABONOS Y PAGOS PARCIALES
	    SELECT DES
	    GO TOP
	    DO WHILE .NOT. DES->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('MES : '+cMes(nMesIniTpa)+;
			     'ºCODIGO: '+DES->cCodigoEst+'/'+cGruFin+;
			     'ºNo. '+STR(DES->(RECNO()),4)+'/'+;
				     STR(DES->(RECCOUNT()),4),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO


	       DO CASE
	       CASE DES->nTipDesDes == 3 .AND.;  // ABONOS
		    DES->nNroMesDes == nMesIniTpa .AND. !DES->lDesEfeDes

		  IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias,.F.)
		     IF &cNalias->cCodigoGru == GRU->cCodigoGru

*-----------------------ANALISIS DEL MES DEL ABONO
			  nMesAbo := MONTH(DES->dFechaDes)
			  IF nMesAbo <= 0 .OR. nMesAbo > 12
			     nMesAbo := 13
			     cError(DES->cCodigoEst+' NO TIENE MES PARA EL ABONO')
			  ENDIF
*-----------------------FIN ANALISIS DEL MES DEL ABONO

*-----------------------TOTALIZACION DEL ABONO
			  IF lPrnFec
			      IF !(DES->dFechaDes < dFecIni .OR.;
				   DES->dFechaDes > dFecFin)
				 aAboMes[nMesAbo] += DES->nValorDes

				 aVlrPagos(DES->dFechaDes,;
					   DES->nValorDes,@aVlrPag,2)

				 aVlrPagExt(cPatSis,;
					    cCodBan,; // cCodBan
					    DES->dFechaDes,;
					    DES->nValorDes,;
					    0,; // nVlrTra
					    2,; // Abono
					    @aFilExt,;
					    @FileMoB)



				 aVlrDifExt(cAnoUsr,FileMoB,;
					    DES->cCodigoEst,;
					    cCodigoTgr,;
					    14,;
					    DES->nNroMesDes,;
					    '01',;
					    DES->dFechaDes,;
					    DES->nValorDes,;
					    aVlrDif)

			      ENDIF
			  ELSE
			     aAboMes[nMesAbo] += DES->nValorDes

			     aVlrPagos(DES->dFechaDes,;
				       DES->nValorDes,@aVlrPag,2)

			     aVlrPagExt(cPatSis,;
					cCodBan,; // cCodBan
					DES->dFechaDes,;
					DES->nValorDes,;
					0,; // nVlrTra
					2,; // Abono
					@aFilExt,;
					@FileMoB)


			     aVlrDifExt(cAnoUsr,FileMoB,;
					DES->cCodigoEst,;
					cCodigoTgr,;
					14,;
					DES->nNroMesDes,;
					'01',;
					DES->dFechaDes,;
					DES->nValorDes,;
					aVlrDif)

			  ENDIF
*-----------------------FIN TOTALIZACION DEL ABONO

		     ENDIF

		  ENDIF

	       CASE DES->nTipDesDes == 4 .AND.;  // PAGOS PARCIALES
		    DES->nNroMesDes == nMesIniTpa



		  IF lSekCodMae(DES->cCodigoEst,cMaeAlu,@cNalias,.F.)
		     IF &cNalias->cCodigoGru == GRU->cCodigoGru

*-----------------------ANALISIS DEL MES DEL PAGO PARCIAL
			  nMesPar := MONTH(DES->dFechaDes)
			  IF nMesPar <= 0 .OR. nMesPar > 12
			     nMesPar := 13
			     cError(DES->cCodigoEst+' NO TIENE MES PARA EL ABONO')
			  ENDIF
*-----------------------FIN ANALISIS DEL MES DEL PAGO PARCIAL



*-----------------------TOTALIZACION DEL PAGOS PARCIAL
			  IF lPrnFec
			      IF !(DES->dFechaDes < dFecIni .OR.;
				   DES->dFechaDes > dFecFin)
				 aParMes[nMesPar] += DES->nValorDes

				 aVlrPagos(DES->dFechaDes,;
					   DES->nValorDes,@aVlrPag,4)


				 aVlrPagExt(cPatSis,;
					    cCodBan,; // cCodBan
					    DES->dFechaDes,;
					    DES->nValorDes,;
					    0,; // nVlrTra
					    1,; // Recibo de pago
					    @aFilExt,;
					    @FileMoB)


			      ENDIF
			  ELSE

			     aParMes[nMesPar] += DES->nValorDes

			     aVlrPagos(DES->dFechaDes,;
				       DES->nValorDes,@aVlrPag,4)

			     aVlrPagExt(cPatSis,;
					cCodBan,; // cCodBan
					DES->dFechaDes,;
					DES->nValorDes,;
					0,; // nVlrTra
					1,; // Recibo de pago
					@aFilExt,;
					@FileMoB)

			  ENDIF
*-----------------------FIN TOTALIZACION DEL PAGOS PARCIAL

		     ENDIF

		  ENDIF

	       ENDCASE
	       DES->(DBSKIP())
	    ENDDO
**********FIN CALCULO DE LOS ABONOS Y PAGOS PARCIALES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SET DEVICE TO SCREEN
	    Avance(GRU->(RECNO()),nRegFin)
	    SET DEVICE TO PRINT

	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       SET DEVICE TO SCREEN
       Termometro(100)
       SET DEVICE TO PRINT
*>>>>FIN ABONOS POR GRUPOS

*>>>>IMPRESION DEL ENCABEZADO
       IF PROW() > 54
	  EJECT
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN IMPRESION DEL ENCABEZADO

/* // DUPLICADO EN FILA

*>>>>IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES
       aCamXml := {}
       aTitPrn := {}
       AADD(aCamXml,'GRANDES.TOTALES')
       AADD(aTitPrn,'')

       aNroCol := {}
       aTitulo := {}
       aTotMes := {}
	aTotal := {}
       FOR i := 1 TO 12
	   IF !EMPTY(aPagMes[i]) .OR.;
	      !EMPTY(aAboMes[i]) .OR.;
	      !EMPTY(aParMes[i])

	      AADD(aNroCol,12)
	      AADD(aTitulo,cMes(i,3))
	      AADD(aCamXml,cMes(i,3))
	      AADD(aTotMes,SPACE(12))
	      AADD(aTitPrn,SPACE(12))
	      AADD(aTotal,0)
	   ENDIF
       ENDFOR

       IF !EMPTY(aPagMes[13]) .OR.;
	  !EMPTY(aAboMes[13]) .OR.;
	  !EMPTY(aParMes[13])

	  AADD(aNroCol,12)
	  AADD(aTitulo,'SIN FECHA')
	  AADD(aCamXml,'SIN FECHA')
	  AADD(aTotMes,SPACE(12))
	  AADD(aTitPrn,SPACE(12))
	  AADD(aTotal,0)
       ENDIF

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')
       AADD(aCamXml,'TOTALES')
       AADD(aTotMes,SPACE(12))
       AADD(aTitPrn,SPACE(12))
       AADD(aTotal,0)
       AADD(aTitPrn,'')  // Url

       cTxtPrn := 'GRANDES*TOTALES '+cRegPrint(aTitulo,aNroCol)
       lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES

*>>>>IMPRESION DE LOS ENCABEZADOS DE LOS GRANDES TOTALES
       aRegPrn := {}
       FOR i := 1 TO 3

	   DO CASE
	   CASE i == 1  // PAGOS NORMALES

****************INICIALIZACION DE LOS TOTALES POR MES
		  aTitPrn[1] := 'PAGOS EN'
		  FOR j := 1 TO LEN(aTotMes)
		      aTotMes[j]   := SPACE(12)
		      aTitPrn[j+1] := SPACE(12)
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

			   aTotMes[nNroMes]   := TRANS(aPagMes[j],"####,###,###")
			   aTitPrn[nNroMes+1] := TRANS(aPagMes[j],"####,###,###")
			   aTotal[nNroMes] += aPagMes[j]
			   nTotPag   += aPagMes[j]
			ENDIF
*---------------------FIN PREPARACION DE LA IMPRESION

		  ENDFOR
		  aTotMes[LEN(aTotMes)]   := TRANS(nTotPag,"####,###,###")
		  aTitPrn[LEN(aTitPrn)-1] := TRANS(nTotPag,"####,###,###")
		  aTotal[LEN(aTotal)] += nTotPag
****************FIN PAGOS NORMALES POR MESES

****************IMPRESION DE LOS PAGOS NORMALES
		  cTxtPrn := 'PAGOS  EN       '+cRegPrint(aTotMes,aNroCol)

		  nLenEle := 0
		  ASCAN(aTotMes,{|aArray| nLenEle += VAL(aArray)})
		 *Analisis del Contenido del vector.

		  IF !EMPTY(nLenEle)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		     aTitTem := ACLONE(aTitPrn)
		     AADD(aTitTem,'EXT'+cMes(VAL(cNroMes),3)+cAnoSis+'.XML')
		     AADD(aRegPrn,aTitTem)
		  ENDIF
****************FIN IMPRESION DE LOS PAGOS NORMALES

	   CASE i == 2  // ABANOS

****************INICIALIZACION DE LOS TOTALES POR MES
		  aTitPrn[1] := 'ABONOS EN'
		  FOR j := 1 TO LEN(aTotMes)
		      aTotMes[j]   := SPACE(12)
		      aTitPrn[j+1] := SPACE(12)
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

			   aTotMes[nNroMes]   := TRANS(aAboMes[j],"####,###,###")
			   aTitPrn[nNroMes+1] := TRANS(aAboMes[j],"####,###,###")
			   aTotal[nNroMes] += aAboMes[j]
			     nVlrAbo += aAboMes[j]
			ENDIF
*---------------------FIN PREPARACION DE LA IMPRESION

		  ENDFOR
		  aTotMes[LEN(aTotMes)]   := TRANS(nVlrAbo,"####,###,###")
		  aTitPrn[LEN(aTitPrn)-1] := TRANS(nVlrAbo,"####,###,###")
		  aTotal[LEN(aTotal)] += nVlrAbo
****************FIN ABONOS POR MESES

****************IMPRESION DE LOS ABONOS
		  cTxtPrn := 'ABONOS EN       '+cRegPrint(aTotMes,aNroCol)

		  nLenEle := 0
		  ASCAN(aTotMes,{|aArray| nLenEle += VAL(aArray)})
		 *Analisis del Contenido del vector.

		  IF !EMPTY(nLenEle)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		     aTitTem := ACLONE(aTitPrn)
		     AADD(aRegPrn,aTitTem)
		  ENDIF
****************FIN IMPRESION DE LOS ABONOS

	   CASE i == 3  // PAGOS PARCIALES

****************INICIALIZACION DE LOS TOTALES POR MES
		  aTitPrn[1] := 'PAGOS PARCIALES'
		  FOR j := 1 TO LEN(aTotMes)
		      aTotMes[j]   := SPACE(12)
		      aTitPrn[j+1] := SPACE(12)
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

			   aTotMes[nNroMes]   := TRANS(aParMes[j],"####,###,###")
			   aTitPrn[nNroMes+1] := TRANS(aParMes[j],"####,###,###")
			   aTotal[nNroMes] += aParMes[j]
			     nTotPar += aParMes[j]
			ENDIF
*---------------------FIN PREPARACION DE LA IMPRESION

		  ENDFOR
		  aTotMes[LEN(aTotMes)] := TRANS(nTotPar,"####,###,###")
		  aTitPrn[LEN(aTitPrn)-1] := TRANS(nTotPar,"####,###,###")
		  aTotal[LEN(aTotal)] += nTotPar
****************FIN PAGOS PARCIALES POR MESES

****************IMPRESION DE LOS PAGOS PARCIALES
		  cTxtPrn := 'PAGOS PARCIALES '+cRegPrint(aTotMes,aNroCol)

		  nLenEle := 0
		  ASCAN(aTotMes,{|aArray| nLenEle += VAL(aArray)})
		 *Analisis del Contenido del vector.

		  IF !EMPTY(nLenEle)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		     aTitTem := ACLONE(aTitPrn)
		     AADD(aRegPrn,aTitTem)
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

       lPrnReg(02,nColCab,'ESTUDIANTES='+STR(nPagTot,4),;
	       bPagina,bDerAut,bCabeza)
*>>>>FIN IMPRESION DEL GRAN TOTAL

// DUPLICADO EN FILA */

*>>>>IMPRESION DEL TOTALES POR MESES
       lPrnReg(02,nColCab,'ESTUDIANTES='+STR(nPagTot,4),;
	       bPagina,bDerAut,bCabeza)

       aRegPrn := {}
       aCamXml := {}
       AADD(aCamXml,'GRANDES/TOTALES')

       aNroCol := {}
       aTitulo := {}
       IF nSuma(aVlrPag,3) # 0
	  AADD(aTitulo,'RECIBOS')
	  AADD(aNroCol,16)
	  AADD(aCamXml,'RECIBOS')
       ENDIF

       IF nSuma(aVlrPag,4) # 0
	  AADD(aTitulo,'ABONOS')
	  AADD(aNroCol,16)
	  AADD(aCamXml,'ABONOS')
       ENDIF

       IF nSuma(aVlrPag,6) # 0
	  AADD(aTitulo,'P PARCIALES')
	  AADD(aNroCol,16)
	  AADD(aCamXml,'P PARCIALES')
       ENDIF
       AADD(aTitulo,'TOTALES')
       AADD(aNroCol,16)
       AADD(aCamXml,'TOTALES')

       cTxtPrn := 'GRANDES>TOTALES '+cRegPrint(aTitulo,aNroCol)
       lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       FOR i := 1 TO LEN(aVlrPag)

	   aTitulo := {}
	   aTitPrn := {}


	   AADD(aTitPrn,STR(aVlrPag[i][1],4)+' '+;
			cMes(aVlrPag[i][2],3)+SPACE(02)+aVlrPag[i][7])


	   IF nSuma(aVlrPag,3) # 0
	      AADD(aTitulo,TRANS(aVlrPag[i][3],"####,###,###")) // Recibos
	      AADD(aTitPrn,TRANS(aVlrPag[i][3],"####,###,###")) // Recibos
	   ENDIF

	   IF nSuma(aVlrPag,4) # 0
	      AADD(aTitulo,TRANS(aVlrPag[i][4],"####,###,###")) // Abonos
	      AADD(aTitPrn,TRANS(aVlrPag[i][4],"####,###,###")) // Abonos
	   ENDIF

	   IF nSuma(aVlrPag,6) # 0
	      AADD(aTitulo,TRANS(aVlrPag[i][6],"####,###,###")) // Pagos Parciales
	      AADD(aTitPrn,TRANS(aVlrPag[i][6],"####,###,###")) // Pagos Parciales
	   ENDIF
	   AADD(aTitulo,TRANS(aVlrPag[i][3]+aVlrPag[i][4]+;
			      aVlrPag[i][6],"####,###,###")) // Totales
	   AADD(aTitPrn,TRANS(aVlrPag[i][3]+aVlrPag[i][4]+;
			      aVlrPag[i][6],"####,###,###")) // Totales

	   cTxtPrn := STR(aVlrPag[i][1],4)+' '+;
		      cMes(aVlrPag[i][2],3)+SPACE(02)+;
		      aVlrPag[i][7]+SPACE(04)+;
		      cRegPrint(aTitulo,aNroCol)

	   lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)


	   cNroAno := STR(aVlrPag[i][1],4)
	   lCorrecion(@cNroAno)

	   cNroMes := STR(aVlrPag[i][2],2)
	   lCorrecion(@cNroMes)

	   PathWww := cNroAno+SUBS(cPatSis,5,4)+;
		      SUBS(PathW01,9,LEN(PathW01))


	   IF cAnoUsr == cNroAno
	      IF nMesIniTpa == VAL(cNroMes)
		 cLinUrl := ''
	      ELSE
		 cLinUrl := '..\..\..\'+;
			    SUBS(PathW01,10,LEN(PathW01))+'\'+;
			    'FACT'+cMes(VAL(cNroMes),3)+'\'
	      ENDIF
	   ELSE
	      cLinUrl := '..\..\..\'+;
			 PathWww+'\'+'FACT'+cMes(VAL(cNroMes),3)
	   ENDIF

	   AADD(aTitPrn,cLinUrl+;
			'EXT'+cMes(VAL(cNroMes),3)+;
			SUBS(cNroAno,3,2)+'.XML')  // Url
	   AADD(aRegPrn,aTitPrn)

       ENDFOR

       aTitulo := {}
       aTitPrn := {}

       DO CASE
       CASE nDeudor # 0 .AND. nSinFec == 0
	    AADD(aTitPrn,'DEUDORES = '+STR(nDeudor,4))

       CASE nSinFec # 0 .AND. nDeudor == 0
	    AADD(aTitPrn,'SIN FECHA = '+STR(nSinFec,4))

       CASE nSinFec # 0 .AND. nDeudor # 0
	    AADD(aTitPrn,'NO FECHA= '+ALLTRIM(STR(nSinFec,4))+' '+;
			 'DUEDOR= '+ALLTRIM(STR(nDeudor,4)))
       OTHERWISE
	    AADD(aTitPrn,'')
       ENDCASE

       IF nSuma(aVlrPag,3) # 0
	  AADD(aTitulo,REPL('=',16))
	  AADD(aTitPrn,REPL('=',16))
       ENDIF

       IF nSuma(aVlrPag,4) # 0
	  AADD(aTitulo,REPL('=',16))
	  AADD(aTitPrn,REPL('=',16))
       ENDIF

       IF nSuma(aVlrPag,6) # 0
	  AADD(aTitulo,REPL('=',16))
	  AADD(aTitPrn,REPL('=',16))
       ENDIF
       AADD(aTitulo,REPL('=',16))
       AADD(aTitPrn,REPL('=',16))

       cTxtPrn := SPACE(16)+cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       AADD(aTitPrn,'')  // Url
       AADD(aRegPrn,aTitPrn)

       aTitulo := {}
       aTitPrn := {}
       AADD(aTitPrn,'TOTALES')

       IF nSuma(aVlrPag,3) # 0
	  AADD(aTitulo,TRANS(nSuma(aVlrPag,3),"####,###,###")) // Recibos
	  AADD(aTitPrn,TRANS(nSuma(aVlrPag,3),"####,###,###")) // Recibos
       ENDIF

       IF nSuma(aVlrPag,4) # 0
	  AADD(aTitulo,TRANS(nSuma(aVlrPag,4),"####,###,###")) // Abonos
	  AADD(aTitPrn,TRANS(nSuma(aVlrPag,4),"####,###,###")) // Abonos
       ENDIF

       IF nSuma(aVlrPag,6) # 0
	  AADD(aTitulo,TRANS(nSuma(aVlrPag,6),"####,###,###")) // Pagos Parciales
	  AADD(aTitPrn,TRANS(nSuma(aVlrPag,6),"####,###,###")) // Pagos Parciales
       ENDIF
       AADD(aTitulo,TRANS(nSuma(aVlrPag,3)+nSuma(aVlrPag,4)+;
			  nSuma(aVlrPag,6),"####,###,###")) // Totales
       AADD(aTitPrn,TRANS(nSuma(aVlrPag,3)+nSuma(aVlrPag,4)+;
			  nSuma(aVlrPag,6),"####,###,###")) // Totales

       cTxtPrn := 'TOTALES         '+cRegPrint(aTitulo,aNroCol)

       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       AADD(aTitPrn,'')  // Url
       AADD(aRegPrn,aTitPrn)
*>>>>FIN IMPRESION DEL TOTALES POR MESES


*>>>>VALIDACION DE LOS RECIBOS
       ValidarExt(cAnoUsr,cPatSis,aFilExt,nMesIniTpa,cMaeAlu,aVlrDif)

       aNroCol := {}
       aTitulo := {}

       AADD(aTitulo,'PAGOS')
       AADD(aNroCol,16)

       AADD(aTitulo,'BANCO')
       AADD(aNroCol,16)

       AADD(aTitulo,'OBSERVACIONES')
       AADD(aNroCol,16)

       IF CAR->lValidaCar
	  cTxtPrn := 'RECIBOS    '+cRegPrint(aTitulo,aNroCol)
	  lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF

       FOR i := 1 TO LEN(aFilExt)

	   aNroCol := {}
	   aTitulo := {}

	   IF aFilExt[i,6]+aFilExt[i,7] == 0
	      LOOP
	   ENDIF

	   AADD(aTitulo,TRANS(aFilExt[i,6],"####,###,###")) // Pagos
	   AADD(aNroCol,16)

	   AADD(aTitulo,TRANS(aFilExt[i,7],"####,###,###")) // Bancos
	   AADD(aNroCol,16)

	   IF aFilExt[i,6] == aFilExt[i,7]
	      AADD(aTitulo,'OK')
	      AADD(aNroCol,16)
	   ELSE
	      AADD(aTitulo,TRANS(aFilExt[i,7]-aFilExt[i,6],"####,###,###"))
	      AADD(aNroCol,16)
	   ENDIF

	   cTxtPrn := aFilExt[i,4]+' '+;              // A¤o
		      cMes(VAL(aFilExt[i,5]),3)+' '+; // Mes
		      aFilExt[i,3]                    // Banco
	   cTxtPrn := cTxtPrn+SPACE(11)
	   cTxtPrn := SUBS(cTxtPrn,1,11)

	   IF CAR->lValidaCar
	      cTxtPrn += cRegPrint(aTitulo,aNroCol)
	      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	   ENDIF

       ENDFOR

       aNroCol := {}
       aTitulo := {}

       AADD(aTitulo,TRANS(nSuma(aFilExt,6),"####,###,###"))
       AADD(aNroCol,16)

       cTxtPrn := 'TOTALES'+SPACE(11)
       cTxtPrn := SUBS(cTxtPrn,1,11)

       IF CAR->lValidaCar
	  cTxtPrn += cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF
*>>>>FIN VALIDACION DE LOS RECIBOS

*>>>>VALIDACION DE LOS ABONOS
       IF nSuma(aFilExt,8)+nSuma(aFilExt,9) # 0

	  aNroCol := {}
	  aTitulo := {}

	  AADD(aTitulo,'PAGOS')
	  AADD(aNroCol,16)

	  AADD(aTitulo,'BANCO')
	  AADD(aNroCol,16)

	  AADD(aTitulo,'OBSERVACIONES')
	  AADD(aNroCol,16)

	  IF CAR->lValidaCar
	     cTxtPrn := 'ABONOS     '+cRegPrint(aTitulo,aNroCol)
	     lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	  ENDIF

	  FOR i := 1 TO LEN(aFilExt)

	      IF aFilExt[i,8]+aFilExt[i,9] == 0
		 LOOP
	      ENDIF

	      aNroCol := {}
	      aTitulo := {}

	      AADD(aTitulo,TRANS(aFilExt[i,8],"####,###,###")) // Pagos
	      AADD(aNroCol,16)

	      AADD(aTitulo,TRANS(aFilExt[i,9],"####,###,###")) // Bancos
	      AADD(aNroCol,16)

	      IF aFilExt[i,8] == aFilExt[i,9]
		 AADD(aTitulo,'OK')
		 AADD(aNroCol,16)
	      ELSE
		 AADD(aTitulo,TRANS(aFilExt[i,9]-aFilExt[i,8],"####,###,###"))
		 AADD(aNroCol,16)
	      ENDIF

	      cTxtPrn := aFilExt[i,4]+' '+;              // A¤o
			 cMes(VAL(aFilExt[i,5]),3)+' '+; // Mes
			 aFilExt[i,3]                    // Banco
	      cTxtPrn := cTxtPrn+SPACE(11)
	      cTxtPrn := SUBS(cTxtPrn,1,11)

	      IF CAR->lValidaCar
		 cTxtPrn += cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	      ENDIF

	  ENDFOR

       ENDIF

       IF nSuma(aFilExt,8) > 0 .AND. CAR->lValidaCar

	  aNroCol := {}
	  aTitulo := {}

	  AADD(aTitulo,TRANS(nSuma(aFilExt,8),"####,###,###"))
	  AADD(aNroCol,16)

	  cTxtPrn := 'TOTALES'+SPACE(11)
	  cTxtPrn := SUBS(cTxtPrn,1,11)

	  cTxtPrn += cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN VALIDACION DE LOS ABONOS

*>>>>IMPRESION DE LAS INCONSISTENCIAS
*       aVlrDif := ASORT(aVlrDif,,,{|x,y|x[5] > y[5]})  // Mes Inicial
*       aVlrDif := ASORT(aVlrDif,,,{|x,y|x[1] < y[1]})  // Banco+A¤o/Mes/D¡a
*	aVlrDif := ASORT(aVlrDif,,,{|x,y|x[8] < y[8]})  // Fecha

/*
       aVlrDif := ASORT(aVlrDif,,,{|x,y| x[5] > y[5] .AND.; // Mes Inicial
					 x[1] < y[1] })     // Banco+A¤o/Mes
*/

       aVlrDif := ASORT(aVlrDif,,,{|x,y|x[1] < y[1]})  // Banco+A¤o/Mes/D¡a



       IF LEN(aVlrDif) > 0

	  aNroCol := {}
	  aTitPrn := {}

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'CODIGO')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'GRUPO')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'MESINI')

	  AADD(aNroCol,6)
	  AADD(aTitPrn,'MESFIN')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'VLRPAG')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'F.PAGO')

	  AADD(aNroCol,14)
	  AADD(aTitPrn,'REFERENCIA')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'VLRTRA')


	  AADD(aNroCol,12)
	  AADD(aTitPrn,'F.TRAN')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'VLRDIF')

	  IF CAR->lValidaCar
	     cTxtPrn := cRegPrint(aTitPrn,aNroCol)
	     lPrnReg(02,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	  ENDIF


	  FOR i := 1 TO LEN(aVlrDif)

	     aNroCol := {}
	     aTitPrn := {}

	     AADD(aNroCol,6)
	     AADD(aTitPrn,aVlrDif[i,3])
	   *ÀC¢digo del Estudiante

	     AADD(aNroCol,6)
	     AADD(aTitPrn,aVlrDif[i,4])
	   *ÀGrupo

	     AADD(aNroCol,6)
	     AADD(aTitPrn,aVlrDif[i,5])
	   *ÀMes Inicial

	     AADD(aNroCol,6)
	     AADD(aTitPrn,aVlrDif[i,6])
	   *ÀMes Final

	     AADD(aNroCol,12)
	     AADD(aTitPrn,TRANS(aVlrDif[i,7],"####,###,###"))
	   *ÀValor del Pago

	     AADD(aNroCol,12)
	     AADD(aTitPrn,cFecha(aVlrDif[i,8]))
	   *ÀFecha de Pago

	     AADD(aNroCol,12)
	     AADD(aTitPrn,aVlrDif[i,9])
	   *ÀReferencia

	     AADD(aNroCol,12)
	     AADD(aTitPrn,TRANS(aVlrDif[i,10],"####,###,###"))
	   *ÀValor Transaci¢n

	     AADD(aNroCol,12)
	     AADD(aTitPrn,cFecha(aVlrDif[i,11]))
	   *ÀFecha de la Transaci¢n

	     AADD(aNroCol,12)
	     AADD(aTitPrn,TRANS(aVlrDif[i,10]-aVlrDif[i,7],"####,###,###"))
	   *ÀDiferencia

	     IF CAR->lValidaCar
		cTxtPrn := cRegPrint(aTitPrn,aNroCol)+aVlrDif[i,1]
		lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	     ENDIF

	  ENDFOR

       ENDIF
*>>>>FIN IMPRESION DE LAS INCONSISTENCIAS

/*

*>>>>GRABACION DEL TOTAL PAGOS
       IF lLocCodigo('nNroMesCnc','CNC',nMesIniTpa)

	  IF lAllGru

	     IF CNC->nTotPagCnc == aTotal[LEN(aTotal)]
		lSavPagVal(nMesIniTpa,aTotal[LEN(aTotal)],;
			   lShared,.F.,cNomUsr)
	     ELSE
		SET DEVICE TO SCREEN
		cError('PAGOS DESCUADRADOS CON LA FACTURACION')
		SET DEVICE TO PRINT
	     ENDIF

	  ENDIF
       ELSE
	  SET DEVICE TO SCREEN
	  cError('NO SE HA CREADO EL MES DE '+cMes(nMesIniTpa,3)+' '+;
		 'DE LA CONCIALIACION')
	  SET DEVICE TO PRINT
       ENDIF
*>>>>FIN GRABACION DEL TOTAL PAGOS

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
*>>>>FIN IMPRESION DERECHOS

*>>>>EXPORTACION AL ARCHIVO
       aCabXml := {}
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{PAGOS}{INFORMES FACTURACION}{PAGOS DEL MES}')
      *Nombre del Sistema

       AADD(aCabXml,'PAGOS DEL MES.'+;
		    IF(lPrnFec,' DE '+cFecha(dFecIni)+ ' A '+cFecha(dFecFin),''))
      *Titulo No. 1

       AADD(aCabXml,'CORRESPONDIENTE A RECIBOS DE '+cMes(nMesIniTpa,10)+;
		    IF(nMesAmn == nMesIniTpa,' CON AMNISTIA',''))
      *Titulo No. 2

       AADD(aCabXml,'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr)
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

lHayXml := .T.

       IF lHayXml
	  FileXml(PathW01+'\'+'FACT'+cMes(nMesIniTpa,3)+'\'+;
		  'PAG'+cMes(nMesIniTpa,3)+cAnoSis+'.XML',;
		  aRegPrn,aCamXml,aCabXml)
       ENDIF
     *ÀCreaci¢n del Archivo

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN EXPORTACION AL ARCHIVO

/*************************************************************************
* TITULO..: VALIDACION DEL EXTRACTO                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 03/2014 MAR A
       Colombia, Bucaramanga        INICIO:  1:24 PM   MAR 03/2014 MAR

OBJETIVOS:

1- Pendiente

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ValidarExt(cAnoUsr,cPatSis,aFilExt,nMesIni,cMaeAlu,aVlrDif)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       aFilExt                              // Archivos Extracto de los pagos
       nMesIni                              // Mes Inicial
       cMaeAlu                              // Maestros habilitados
       aVlrDif                              // Valor Diferencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL PathTem := ''                  // Path temporal
       LOCAL ExtFile := '.DAT'              // Extensi¢n del Archivo
       LOCAL FileCmv := 'CONCEMOV'+ExtFile
       LOCAL FileTmv := 'TIPMOV'

       LOCAL i := 0                         // Contador
       LOCAL k := 0                         // Indice de B£squeda

       LOCAL lHayRec := .F.                 // .T. Hay Recibos
       LOCAL lHayAbo := .F.                 // .T. Hay Abonos
*       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL lMensaj := .F.                 // .T. Mostrar mensaje error

       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL FilePag := ''                  // Archivo de Pagos
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL lSumTra := .F.                 // .T. Credito .F. Debito

       LOCAL FileMoB := ''                  // Ej: 01199902.DAT
       LOCAL cCodBan := ''                  // C¢digo del Banco
       LOCAL nCodCmv := ''                  // C¢digo Concepto del Movimiento
       LOCAL lCodCmv := .F.                 // .T. Hay C¢digo Concepto del Movimiento
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL cDiaPag := ''                  // D¡a del pago
       LOCAL cMesPag := ''                  // Mes del pago
       LOCAL cAnoPag := ''                  // A¤o del Pago

       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL cCodEst := ''                  // C¢digo del Estudiante
       LOCAL cCodGru := ''                  // C¢digo del Grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DE LOS EXTRACTOS
       cNroMes := STR(nMesIni,2)
       lCorrecion(@cNroMes)

       FOR i := 1 TO LEN(aFilExt)

*********ANALISIS DE DECISION
	   FileMoB := aFilExt[i,2]
	   cCodBan := aFilExt[i,3]
	   cAnoPag := aFilExt[i,4]

	   PathTem := cAnoPag+'.'+;
		      SUBS(cPatSis,LEN(ALLTRIM(cPatSis))-2,3)

	   IF EMPTY(FileMoB)
	      LOOP
	   ENDIF
*********FIN ANALISIS DE DECISION

*********SELECION DE AREAS DE TRABAJO
	   IF !lUseDbf(.T.,FileMoB,'EXT',NIL,lShared,nModCry,lMensaj) .OR.;
	      !lUseDbf(.T.,PathTem+'\'+;
			   FileCmv,'CMV',NIL,lShared,nModCry) .OR.;
	      !lUseDbf(.T.,PathTem+'\'+FileTmv+cCodBan+ExtFile,;
			  'TMV',NIL,lShared,nModCry)

	      LOOP
	   ENDIF
*********FIN SELECION DE AREAS DE TRABAJO

*********RECORRIDO DE EXTRACTOS
	   SELECT EXT
	   EXT->(DBGOTOP())
	   DO WHILE .NOT. EXT->(EOF())

*=============ANALISIS DE DECISION
		nCodCmv := EXT->nCodigoCmv
		IF lLocCodigo('nCodigoCmv','CMV',nCodCmv)

		   IF cAnoUsr # CMV->cAnoCmvCmv
		      EXT->(DBSKIP())
		      LOOP
		   ENDIF

		ELSE
		    EXT->(DBSKIP())
		    LOOP
		ENDIF

		nCodCmv := IF(CMV->nCodCmvCmv==0,;
			      CMV->nCodigoCmv,;
			      CMV->nCodCmvCmv)

		IF nCodCmv # 1 .AND. nCodCmv # 2 .AND. nCodCmv # 3
		   EXT->(DBSKIP())
		   LOOP
		ENDIF

		lHayRec := (nCodCmv == 1  .OR. nCodCmv == 2) .AND.;
			    SUBS(EXT->cCodRefTra,7,2) == cNroMes

		lHayAbo := SUBS(EXT->cCodRefTra,7,4) == '14'+cNroMes
*=============FIN ANALISIS DE DECISION

*=============LOCALIZACION DEL TIPO DE MOVIMIENTO
		lSumTra := .F.
		IF lLocCodigo('cCodigoTra','TMV',EXT->cCodigoTra)
		   lSumTra := TMV->lSumarTra
		ENDIF
		SELECT EXT
*=============FIN LOCALIZACION DEL TIPO DE MOVIMIENTO

*=============BUSQUEDA DEL ESTUDIANTE
		IF lHayRec .OR. lHayAbo

		   cCodEst := SUBS(EXT->cCodRefTra,1,6)

		   lHayAlu := lSekCodMae(cCodEst,cMaeAlu,@cNalias,.F.)

		   IF lHayAlu
		      cCodGru := &cNalias->cCodigoGru
		   ELSE
		      cCodGru := ''
		   ENDIF

		   cAnoPag := STR(YEAR(EXT->dFechaTra),4)
		   cMesPag := STR(MONTH(EXT->dFechaTra),2)
		   cDiaPag := STR(DAY(EXT->dFechaTra),2)
		   lCorrecion(@cMesPag,2)
		   lCorrecion(@cDiaPag,2)


		   k := ASCAN(aVlrDif,{|aArray| aArray[3] == cCodEst})

		ENDIF
*=============FIN BUSQUEDA DEL ESTUDIANTE

*=============PAGOS DEL MES
		IF lHayRec

		   aVlrPagExt(cPatSis,;
			      cCodBan,;
			      EXT->dFechaTra,;
			      0,; // nVlrPag
			      IF(lSumTra,EXT->nValorTra,-EXT->nValorTra),;
			      1,; // Recibo de pago
			      @aFilExt)


		ENDIF
*=============FIN PAGOS DEL MES

*=============LOCALIZACION DEL PAGO
		IF lHayRec

		   IF !EMPTY(cCodGru)

		      FilePag := cPatSis+'\PAGOS\PA'+cCodGru+cAnoSis+ExtFile
		      lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		      lHayPag := lLocCodPag(cCodEst,nMesIni,.F.)

		      IF lHayPag


			 IF (PAG->cEstadoPag == 'P' .OR.;
			     PAG->cEstadoPag == 'A') .AND.;
			     !EMPTY(PAG->dFecPagPag)


			    nVlrInt := 0
			    IF PAG->cEstadoPag == 'A'
			       nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
						     PAG->nMesIniPag,;
						     CAA->nMesAmnCaA)
			    ENDIF

			    IF PAG->nVlrPagPag+nVlrInt # EXT->nValorTra

			       IF k == 0
				  AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
						FileMoB,;                // 2.  Archivo del Extracto
						cCodEst,;                // 3.  C¢digo de la Referencia
						cCodGru,;                // 4.  C¢digo del Grupo
						STR(PAG->nMesIniPag,2),; // 5.  Mes Inicial
						STR(PAG->nMesFinPag,2),; // 6.  Mes Final
						PAG->nVlrPagPag+nVlrInt,;// 7.  Valor Pago
						PAG->dFecPagPag,;        // 8.  Fecha de Pago
						EXT->cCodRefTra,;        // 9.  Referencia
						EXT->nValorTra,;         // 10. Valor de la Transaci¢n
						EXT->dFechaTra})         // 11. Fecha de la Transaci¢n
			       ELSE
				  aVlrDif[k,9]  := EXT->cCodRefTra
				  aVlrDif[k,10] := EXT->nValorTra
				  aVlrDif[k,11] := EXT->dFechaTra
			       ENDIF

			    ENDIF

			 ELSE

			    IF k == 0
			       AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
					     FileMoB,;                // 2.  Archivo del Extracto
					     cCodEst,;                // 3.  C¢digo de la Referencia
					     cCodGru,;                // 4.  C¢digo del Grupo
					     STR(PAG->nMesIniPag,2),; // 5.  Mes Inicial
					     STR(PAG->nMesFinPag,2),; // 6.  Mes Final
					     0,;                      // 7.  Valor Pago
					     '',;                     // 8.  Fecha de Pago
					     EXT->cCodRefTra,;        // 9.  Referencia
					     EXT->nValorTra,;         // 10. Valor de la Transaci¢n
					     EXT->dFechaTra})         // 11. Fecha de la Transaci¢n
			    ELSE

			       aVlrDif[k,9]  := EXT->cCodRefTra
			       aVlrDif[k,10] := EXT->nValorTra
			       aVlrDif[k,11] := EXT->dFechaTra
			    ENDIF

			 ENDIF

		      ELSE

			 IF k == 0

			    AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
					  FileMoB,;                // 2.  Archivo del Extracto
					  cCodEst,;                // 3.  C¢digo de la Referencia
					  cCodGru,;                // 4.  C¢digo del Grupo
					  '',; // 5.  Mes Inicial
					  '',; // 6.  Mes Final
					  0,;        // 7.  Valor Pago
					  '',;        // 8.  Fecha de Pago
					  EXT->cCodRefTra,;        // 9.  Referencia
					  EXT->nValorTra,;         // 10. Valor de la Transaci¢n
					  EXT->dFechaTra})         // 11. Fecha de la Transaci¢n

			 ELSE
			    aVlrDif[k,9]  := EXT->cCodRefTra
			    aVlrDif[k,10] := EXT->nValorTra
			    aVlrDif[k,11] := EXT->dFechaTra
			 ENDIF

		      ENDIF

		   ELSE

		      IF k == 0

			 AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
				       FileMoB,;         // 2.  Archivo del Extracto
				       cCodEst,;         // 3.  C¢digo de la Referencia
				       cCodGru,;         // 4.  C¢digo del Grupo
				       '',;              // 5.  Mes Inicial
				       '',;              // 6.  Mes Final
				       0,;               // 7.  Valor Pago
				       '',;              // 8.  Fecha de Pago
				       EXT->cCodRefTra,; // 9.  Referencia
				       EXT->nValorTra,;  // 10. Valor de la Transaci¢n
				       EXT->dFechaTra})  // 11. Fecha de la Transaci¢n

		      ELSE
			 aVlrDif[k,9]  := EXT->cCodRefTra
			 aVlrDif[k,10] := EXT->nValorTra
			 aVlrDif[k,11] := EXT->dFechaTra
		      ENDIF

		   ENDIF
		ENDIF
*=============FIN LOCALIZACION DEL PAGO

*=============ABONOS DEL MES
		IF lHayAbo

		   aVlrPagExt(cPatSis,;
			      cCodBan,;
			      EXT->dFechaTra,;
			      0,; // nVlrPag
			      IF(lSumTra,EXT->nValorTra,-EXT->nValorTra),;
			      2,; // Abono
			      @aFilExt)


		ENDIF
*=============FIN ABONOS DEL MES

	      EXT->(DBSKIP())

	   ENDDO
*********FIN RECORRIDO DE EXTRACTOS

       ENDFOR
       aFilExt := ASORT(aFilExt,,,{|x,y|x[1] < y[1]})
       RETURN NIL
*>>>>FIN RECORRIDO DE LOS EXTRACTOS

/*************************************************************************
* TITULO..: VALIDACION DE LOS PAGOS CON EL EXTRACTO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/2014 MAR A
       Colombia, Bucaramanga        INICIO:  5:39 PM   MAR 12/2014 MAR

OBJETIVOS:

1- Pendiente

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aVlrPagExt(cPatSis,cCodBan,dFecPag,nVlrPag,;
		    nVlrTra,nTipPag,aVlrPag,FileMoB)

*>>>>DESCRIPCION DE PARAMETROS
/*     cPatSis                              // Path del sistema
       cCodBan                              // C¢digo del Banco
       dFecPag                              // Fecha de Pago
       nVlrPag                              // Valor Pagado
       nVlrTra                              // Valor de Transaci¢n
       nTipPag                              // Tipo de Pago. 1=Recibos 2=Abonos
       aVlrPag                              // Valor de los Pagos
       FileMoB                              // @Ej: 01199902.DAT */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL k := 0                         // Indice de B£squeda

       LOCAL cMesPag := ''                  // Mes del pago
       LOCAL cAnoPag := ''                  // A¤o del Pago
       LOCAL cPatExt := ''                  // Path del Extracto

       LOCAL ExtFile := '.DAT'              // Extensi¢n del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ARCHIVO DEL EXTRACTO
       FileMoB := ''
       cCodBan := IF(cCodBan==NIL,'01',cCodBan)
       IF !EMPTY(dFecPag)

	  cAnoPag := STR(YEAR(dFecPag),4)
	  cMesPag := STR(MONTH(dFecPag),2)
	  lCorrecion(@cMesPag,2)

	  cPatExt := cAnoPag+'.'+;
		     SUBS(cPatSis,LEN(ALLTRIM(cPatSis))-2,3)

	  FileMoB := cPatExt+'\MODEM\'+cCodBan+'\'+;
		     cCodBan+cAnoPag+cMesPag+ExtFile
       ELSE
	  FileMoB := ''
       ENDIF

       k := ASCAN(aVlrPag,{|aArray| aArray[2] == FileMoB})

       IF k == 0

	  IF !EMPTY(FileMoB)
	     AADD(aVlrPag,{cCodBan+cAnoPag+cMesPag,;
			   FileMoB,;         // 2.Archivo del Extracto
			   cCodBan,;         // 3.Banco
			   cAnoPag,;         // 4.A¤o.
			   cMesPag,;         // 5.Mes.
			   0,;               // 6. Pagos del sistema
			   0,;               // 7. Pagos del Extracto
			   0,;               // 8. Abonos del Sistema
			   0})               // 9. Abonos del Extracto
	  ELSE
	     AADD(aVlrPag,{'',;
			   FileMoB,;         // 2.Archivo del Extracto
			   '',;              // 3.Banco
			   '',;              // 4.A¤o.
			   '',;              // 5.Mes.
			   0,;               // 6. Pagos del sistema
			   0,;               // 7. Pagos del Extracto
			   0,;               // 8. Abonos del Sistema
			   0})               // 9. Abonos del Extracto
	  ENDIF
       ENDIF
*>>>>FIN ARCHIVO DEL EXTRACTO

*>>>>VALIDACION DEL PAGO
       k := ASCAN(aVlrPag,{|aArray| aArray[2] == FileMoB})

       DO CASE
       CASE nTipPag == 1 // Recibo de Pago

	    DO CASE
	    CASE nVlrPag > 0

		 aVlrPag[k,6] += nVlrPag

	    CASE nVlrTra > 0

		 aVlrPag[k,7] += nVlrTra

	    ENDCASE

       CASE nTipPag == 2 // Abono

	    DO CASE
	    CASE nVlrPag > 0

		 aVlrPag[k,8] += nVlrPag

	    CASE nVlrTra > 0

		 aVlrPag[k,9] += nVlrTra

	    ENDCASE

       ENDCASE
       RETURN NIL
*>>>>FIN VALIDACION DEL PAGO

/*************************************************************************
* TITULO..: VALIDACION DE LOS PAGOS CON EL EXTRACTO                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/2014 MAR A
       Colombia, Bucaramanga        INICIO:  5:39 PM   MAR 12/2014 MAR

OBJETIVOS:

1- Pendiente

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aVlrDifExt(cAnoUsr,FileMoB,cCodEst,cCodGru,nMesIni,;
		    nMesFin,cCodBan,dFecPag,nVlrPag,aVlrDif)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoUsr                              // A¤o del usuario
       FileMoB                              // @Ej: 01199902.DAT
       cCodEst                              // C¢digo del Estudiante
       cCodGru                              // C¢digo del Grupo
       nMesIni                              // Mes Inicial
       nMesFin                              // Mes Final
       cCodBan                              // C¢digo del Banco
       dFecPag                              // Fecha de Pago
       nVlrPag                              // Valor Pagado
       aVlrDif                              // Valor diferencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathTem := ''                  // Path temporal
       LOCAL ExtFile := '.DAT'              // Extensi¢n del Archivo
       LOCAL FileCmv := 'CONCEMOV'+ExtFile

       LOCAL k := 0                         // Indice de B£squeda

       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL lMensaj := .F.                 // .T. Mostrar mensaje error

       LOCAL cMesIni := ''                  // Mes Inicial
       LOCAL cMesFin := ''                  // Mes Inicial
       LOCAL cCodRef := ''                  // C¢digo de la referencia
       LOCAL cDiaPag := ''                  // D¡a del pago
       LOCAL cMesPag := ''                  // Mes del pago
       LOCAL cAnoPag := ''                  // A¤o del Pago
       LOCAL cPatExt := ''                  // Path del Extracto
       LOCAL lHayExt := .F.                 // .T. Hay Extracto
       LOCAL nCodCmv := ''                  // C¢digo Concepto del Movimiento
*>>>>FIN DECLARACION DE VARIABLES


*>>>>SELECION DE AREAS DE TRABAJO
       IF !EMPTY(FileMoB)

	  PathTem := SUBS(FileMoB,1,8)

	  IF !lUseDbf(.T.,FileMoB,'EXT',NIL,lShared,nModCry,lMensaj) .OR.;
	     !lUseDbf(.T.,PathTem+'\'+;
			   FileCmv,'CMV',NIL,lShared,nModCry)

	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN SELECION DE AREAS DE TRABAJO

*>>>>ANALISIS DE LA INCONSISTENCIA
       cMesIni := STR(nMesIni,2)
       lCorrecion(@cMesIni,2)

       cMesFin := STR(nMesFin,2)
       lCorrecion(@cMesFin,2)

       k := ASCAN(aVlrDif,{|aArray| aArray[3] == cCodEst .AND.;
				    aArray[5] == cMesIni .AND.;
				    aArray[6] == cMesFin})

       IF !EMPTY(dFecPag)

	  cAnoPag := STR(YEAR(dFecPag),4)
	  cMesPag := STR(MONTH(dFecPag),2)
	  cDiaPag := STR(DAY(dFecPag),2)
	  lCorrecion(@cMesPag,2)
	  lCorrecion(@cDiaPag,2)

	  cCodRef := cCodEst+cMesIni+cMesFin

	  SELECT EXT
	  EXT->(DBGOTOP())
	  LOCATE FOR SUBS(ALLTRIM(EXT->cCodRefTra),1,10) == cCodRef .AND.;
		     dFecPag == EXT->dFechaTra

	  SELECT EXT
	  IF EXT->(FOUND())

	     nCodCmv := 0
	     IF lLocCodigo('nCodigoCmv','CMV',EXT->nCodigoCmv)

* ESTUDIANTE LO ENCONTRO EN EL EXTRACTO REVISAR
*		IF cAnoUsr # CMV->cAnoCmvCmv
*		   RETURN NIL
*		ENDIF

		nCodCmv := CMV->nCodigoCmv


		IF !(EXT->nCodigoCmv == 1 .OR. EXT->nCodigoCmv == 2)

		   IF (CMV->nCodCmvCmv == 1  .OR.;
		       CMV->nCodCmvCmv == 2) .AND.;
		       cAnoUsr == CMV->cAnoCmvCmv

		       nCodCmv := CMV->nCodCmvCmv
		   ENDIF

		ENDIF

	     ENDIF

	     IF nVlrPag # EXT->nValorTra

		IF k == 0
		   AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
				 FileMoB,;          // 2.  Archivo del Extracto
				 cCodEst,;          // 3.  C¢digo de la Referencia
				 cCodGru,;          // 4.  C¢digo del Grupo
				 '',;               // 5.  Mes Inicial
				 '',;               // 6.  Mes Final
				 0,;                // 7.  Valor Pago
				 CTOD('00/00/00'),; // 8.  Fecha de Pago
				 '',;               // 9.  Referencia
				 0,;                // 10. Valor de la Transaci¢n
				 ''})               // 11. Fecha de la Transaci¢n
		ENDIF

	     ELSE

		IF !(nCodCmv == 1 .OR. nCodCmv == 2 .OR. nCodCmv == 3)

		   IF k == 0
		      AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
				    FileMoB,;          // 2.  Archivo del Extracto
				    cCodEst,;          // 3.  C¢digo de la Referencia
				    cCodGru,;          // 4.  C¢digo del Grupo
				    '',;               // 5.  Mes Inicial
				    '',;               // 6.  Mes Final
				    0,;                // 7.  Valor Pago
				    CTOD('00/00/00'),; // 8.  Fecha de Pago
				    '',;               // 9.  Referencia
				    0,;                // 10. Valor de la Transaci¢n
				    ''})               // 11. Fecha de la Transaci¢n
		   ENDIF


		ENDIF

	     ENDIF


	  ELSE

	    IF k == 0
	       AADD(aVlrDif,{cCodBan+cAnoPag+cMesPag+cDiaPag,;
			     FileMoB,;          // 2.  Archivo del Extracto
			     cCodEst,;          // 3.  C¢digo de la Referencia
			     cCodGru,;          // 4.  C¢digo del Grupo
			     '',;               // 5.  Mes Inicial
			     '',;               // 6.  Mes Final
			     0,;                // 7.  Valor Pago
			     CTOD('00/00/00'),; // 8.  Fecha de Pago
			     '',;               // 9.  Referencia
			     0,;                // 10. Valor de la Transaci¢n
			     ''})               // 11. Fecha de la Transaci¢n
	    ENDIF

	  ENDIF
       ELSE

	 IF k == 0
	    AADD(aVlrDif,{'',;
			  '',;               // 2.  Archivo del Extracto
			  cCodEst,;          // 3.  C¢digo de la Referencia
			  cCodGru,;          // 4.  C¢digo del Grupo
			  '',;               // 5.  Mes Inicial
			  '',;               // 6.  Mes Final
			  0,;                // 7.  Valor Pago
			  CTOD('00/00/00'),; // 8.  Fecha de Pago
			  '',;               // 9.  Referencia
			  0,;                // 10. Valor de la Transaci¢n
			  ''})               // 11. Fecha de la Transaci¢n
	 ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA INCONSISTENCIA

*>>>>LOCALIZACION DE LA CONSIGNACION
       k := ASCAN(aVlrDif,{|aArray| aArray[3] == cCodEst})

/* revisar ojo
       k := ASCAN(aVlrDif,{|aArray| aArray[3] == cCodEst .AND.;
				    aArray[5] == cMesIni .AND.;
				    aArray[6] == cMesFin})
*/
       IF !EMPTY(dFecPag)

	  SELECT EXT
	  IF EXT->(FOUND())

	     cCodRef := ALLTRIM(EXT->cCodRefTra)+'='+ALLTRIM(STR(nCodCmv))
	     cCodRef := SUBS(cCodRef+SPACE(14),1,14)

	     IF nVlrPag # EXT->nValorTra

		aVlrDif[k,5]  := cMesIni
		aVlrDif[k,6]  := cMesFin
		aVlrDif[k,7]  := nVlrPag
		aVlrDif[k,8]  := dFecPag
		aVlrDif[k,9]  := cCodRef
		aVlrDif[k,10] := EXT->nValorTra
		aVlrDif[k,11] := EXT->dFechaTra

	     ELSE

		IF !(nCodCmv == 1 .OR. nCodCmv == 2 .OR. nCodCmv == 3)

		  aVlrDif[k,5]  := cMesIni
		  aVlrDif[k,6]  := cMesFin
		  aVlrDif[k,7]  := nVlrPag
		  aVlrDif[k,8]  := dFecPag
		  aVlrDif[k,9]  := cCodRef
		  aVlrDif[k,10] := EXT->nValorTra
		  aVlrDif[k,11] := EXT->dFechaTra

		ENDIF


	     ENDIF
	  ELSE
		aVlrDif[k,5]  := cMesIni
		aVlrDif[k,6]  := cMesFin
		aVlrDif[k,7]  := nVlrPag
		aVlrDif[k,8]  := dFecPag
	  ENDIF

       ELSE
	  aVlrDif[k,5]  := cMesIni
	  aVlrDif[k,6]  := cMesFin
	  aVlrDif[k,7]  := nVlrPag
	  aVlrDif[k,8]  := dFecPag
       ENDIF
       RETURN NIL
*>>>>FIN LOCALIZACION DE LA CONSIGNACION

