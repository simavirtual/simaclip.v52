/*************************************************************************
* TITULO..: FACTURACION DEL MES TIPO No. 1                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Bucaramanga, Colombia	    INICIO: 11:00 PM   MAY 11/99 MAR

OBJETIVOS:

1)- Imprime la facturaci¢n del mes con el resumen y corte

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FactMes01(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-FACT.PRG"              // Archivos del Sistema

       #DEFINE nDEUANT 1                    // Deuda Anterior
       #DEFINE nMORANT 2                    // Mora Anterior
       #DEFINE nVLRMES 3                    // Valor del Mes

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
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
     *ÀVariables de informe

       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL lFPagOk := .T.                 // Fecha de Pago de Acuerdo al Corte
       LOCAL lFAboOk := .T.                 // Fecha de Abono de Acuerdo al Corte
       LOCAL lFPaPOk := .T.                 // Fecha de Pago Parcial de Acuerdo al Corte
       LOCAL aFacMes[16]                    // Facturaci¢n del Mes. 8 Conceptos
       LOCAL aAntici[16]                    // Anticipos. 8 Conceptos
       LOCAL aAntEst[16]		    // Valor de los Anticipos del Mes
       LOCAL lHayAnt := .F.                 // .T. Hay Anticipos
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL lAllGru := .F.                 // .T. Todos los Grupos

       LOCAL nVlrSdo := 0                   // Valor del saldo
       LOCAL nVlrDeu := 0                   // Valor de la deuda
       LOCAL nPorCob := 0                   // Intereses por Cobrar
       LOCAL nPago   := 0                   // Valor del pago de un mes o varios meses.

       LOCAL nIntCob := 0                   // Intereses por Cobrar
       LOCAL nIntMes := 0                   // Intereses del Mes
       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrIng := 0                   // Valor de los ingresos
       LOCAL nVlrMes := 0                   // Valor de lo facturado
       LOCAL nFacMes := 0                   // Facturaci¢n del Mes
       LOCAL nAntici := 0                   // Valor de los Anticipos
       LOCAL nMesAmn := 0                   // Mes de Anmistia
       LOCAL nAboEst := 0                   // Abonos del Estudiante

//     LOCAL aVlrWww := {}                  // Tabla Facturaci¢n Internet
//     LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aCamPag := {}                  // Campo Xml
*       LOCAL aPagXml := {}                  // Codigos de los pagos
       LOCAL aRetMor := {}                  // Retirado con Mora
       LOCAL aDeuAnt := {}                  // Codigos deuda Anterior
       LOCAL aRegEst := {}                  // Valor del Estudiante
       LOCAL aVlrGru := {}                  // Valores por conceptos
       LOCAL aVlrNiv := {}                  // Totales por conceptos por nivel
       LOCAL aVlrTot := {}                  // Totales por conceptos
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nIntNoP := 0                   // Valor de los intereses no pago
       LOCAL nTotal  := 0                   // Gran total de la facturaci¢n

       LOCAL lMesAct := .T.                 // .T. Mes Actual.
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nSdoMor := 0                   // Saldo de la Mora
       LOCAL nNroNiv := 0                   // N£mero de Niveles
       LOCAL nNroEst := 0                   // N£mero de Estudiantes
       LOCAL nTotEst := 0                   // Total Estudiantes
       LOCAL nNroDeu := 0                   // N£mero de Deudores
       LOCAL nTotDeu := 0                   // Total de Deudores
       LOCAL nNroExt := 0                   // N£mero de Extemporaneos
       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL lAnoAct := .T.                 // A¤o Actual
       LOCAL       i := 1                   // Contador
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nGruIni := 0                   // Grupo Inicial
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
       LOCAL nNroPos := 0                   // N£mero de la posici¢n

       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL nNroFil := 0                   // N£mero de Fila
       LOCAL cConcep := ''                  // Conceptos
       LOCAL nVlrTar := ''                  // Valor de las tarifas
       LOCAL nVlrRec := 0                   // Valor del Recargo
       LOCAL nTotDes := 0                   // Total de Descuentos
       LOCAL nTotRec := 0                   // Total de Recargos
       LOCAL nTotBec := 0                   // Total de Becas
       LOCAL nTotFac := 0                   // Total Facturaci¢n
       LOCAL nBecAnt := 0                   // Valor Beca Anterior
       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nDeuRet := 0                   // Deuda Anterior del Retirado
       LOCAL nMorRet := 0                   // Mora Anterior del Retirado
       LOCAL nMesRet := 0                   // Mes del ultimo recibo
       LOCAL nTotPag := 0                   // Total Pagos

       LOCAL nAboDes := 0                   // Abonos Descuentos
       LOCAL nDesMes := 0                   // Total de Abonos como Descuentos
       LOCAL nAboMes := 0                   // Abonos del Mes
       LOCAL nAboOtr := 0                   // Abonos otros Meses
       LOCAL nDeuInt := 0                   // Deuda Anterior para calcular los intereses por cobrar
       LOCAL cCodEst := ''                  // C¢digo del Estudiante
       LOCAL lSdoAnt := .F.                 // Tomar el Saldo Anterior
       LOCAL nVlrDes := 0                   // Valor del Descuento
       LOCAL nVlrBec := 0                   // Valor de la Beca
       LOCAL nRegTop := 0                   // Registro Inicial
       LOCAL nRegBot := 0                   // Registro Final
       LOCAL lHayXml := .T.                 // .T. Imprimir Archivo

       LOCAL nNroAde := 0                   // N£mero de anticipos
       LOCAL nFinAde := 0                   // N£mero de anticipos fin de a¤o

       LOCAL lValida := .F.                 // .T. Visualiza los descuentos aplicados
       LOCAL lFinMes := .F.                 // .T. Hay pagos de fin de Mes
       LOCAL nFinMes := 0                   // Total de pagos de fin de mes
       LOCAL nAboFin := 0                   // Total Abonos de fin de mes
       LOCAL nOtrFin := 0                   // Total Abonos otros meses de fin de mes
       LOCAL nDesFin := 0                   // Total Abonos Descuentos de fin de mes
       LOCAL nTotFin := 0                   // Gran Total de la Facturaci¢n de fin de mes
       LOCAL nTotCau := 0                   // Total Causaci¢n
       LOCAL lAllInf := .T.                 // .T. Todo el Informe .F. Sole Resumen
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

       LOCAL PathW01 := ''
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aPagXml := {}                  // Codigos de los pagos

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
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCnc,'CNC',NIL,lShared,nModCry})
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
       nMesAmn := CAA->nMesAmnCaA
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DE LOS CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cConcep := CAA->cConPrnCaA
       @ nFilInf+1,nColInf SAY 'CONCEPTOS' GET cConcep PICT "@!";
			   VALID lValLeeCon(nFilInf+1,nColInf+26,;
					    nFilInf+1,nColInf+10,;
					    @cConcep,16)
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

*>>>>LECTURA DEL CODIGO DEL ESTUDIANTE
       cCodEst := SPACE(06)
       IF lPregunta('DESEA IMPRIMIR EL INFORME PARA UN SOLO ESTUDIATE? No Si')
	  cCodEst := cLeeCodEst(nFilInf+1,nColInf,;
				cMaeAlu,@cNalias)
       ENDIF
*>>>>FIN LECTURA DEL CODIGO DEL ESTUDIANTE

*>>>>ANALISIS DE DECISION
       lAllInf := .T.
       IF EMPTY(cCodEst)
	  lAllInf := !lPregunta('DESEA IMPRIMIR SOLO '+;
			       'EL RESUMEN DEL INFORME? No Si')
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF EMPTY(cCodEst)
	  IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin,@lAllGru)
	     CloseAll(aUseDbf)
	     IF !lFileDelete(FileTem)
		cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	     ENDIF
	     RETURN NIL
	  ENDIF
       ELSE
	  lLocCodigo('cCodigoGru','GRU',&cNalias->cCodigoGru)
	  nRegIni := GRU->(RECNO())
	  nRegFin := nRegIni
       ENDIF

       lValida := .F.
       IF lPregunta('DESEA VISUALIZAR LOS DESCUENTOS? No Si')
	  lValida := .T.
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')
       lPrnFec := CAA->lLeeFecCaA .AND. CAA->lPrnFecCaA
       IF lPrnFec
	  IF lPregunta('DESEA EL INFORME POR FECHA DE CORTE? No Si')

	     RESTSCREEN(0,0,24,79,cSavPan)
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
       ENDIF
*>>>>LECTURA DE LA FECHA DE CORTE

*>>>>ANALISIS DE LA IMPRESION POR FECHAS
       IF lPrnFec
	  IF EMPTY(dFecPrn)
	     lPrnFec := .F.
	  ELSE
	     lPrnFec := .T.
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DE LA IMPRESION POR FECHAS

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES
       SELECT DES
       SET FILTER TO DES->nNroMesDes == nMesIniTpa .OR.;
		     DES->nMesModDes == nMesIniTpa
       DES->(DBGOTOP())
       IF DES->(EOF())
	  SET FILTER TO
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES

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
		   'FACTURACION DEL MES'+;
		   IF(EMPTY(dFecPrn),' A LA FECHA.',;
		     ' A '+cFecha(dFecPrn,3)),;
		   'CORRESPONDIENTE A RECIBOS DE '+cMes(nMesIniTpa,10)+;
		   IF(CAA->nMesAmnCaA == nMesIniTpa,' CON AMNISTIA',''),;
		   'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aVlrTot := {0,0,0,0,0}   // Saldo Actual
       aVlrNiv := {0,0,0,0,0}   // Saldo Actual

       aNroCol := {08,16,12,12,12,12}
       aTitulo := {'NIVEL ',;
		   'SALDO ACTUAL',;
		   'TOTAL DEUDA',;
		   'INTxCOBRAR',;
		   'INTxCOBMes',;
		   'INTxCOBAnt'}

       FOR i := 1 TO LEN(cConcep)/2

	   AADD(aVlrTot,0)  // Conceptos Mes
	   AADD(aVlrNiv,0)  // Totales Conceptos Mes

	   IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(CON->cNombreCon,1,12))  // Conceptos Mes
	   ELSE
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(cConcep,i*2-1,2))       // Conceptos Mes
	   ENDIF

       ENDFOR

       AADD(aNroCol,16)
       AADD(aTitulo,'INT PAGO MES')

       AADD(aNroCol,12)
       AADD(aTitulo,'ANTICIPOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')

       AADD(aVlrTot,0)  // Recargo
       AADD(aVlrTot,0)  // Anticipos
       AADD(aVlrTot,0)  // Total Nivel

       AADD(aVlrNiv,0)  // Recargo
       AADD(aVlrNiv,0)  // Anticipos
       AADD(aVlrNiv,0)  // Total Nivel

       cCabCol := cRegPrint(aTitulo,aNroCol)
       aCamPag := aTitulo
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

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       AFILL(aAntici,0)
*>>>>FIN ANALISIS DE DECISION


*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  IF EMPTY(cCodEst)
	     IF nRegIni == nRegFin
		FilePrn = SUBS(CAR->cSerFacCar,1,1)+'f'+GRU->cCodigoGru
	     ELSE
		FilePrn = SUBS(CAR->cSerFacCar,1,1)+'f'+cAnoUsr+cNroMes
	     ENDIF
	  ELSE
	     FilePrn = SUBS(CAR->cSerFacCar,1,1)+'f'+cCodEst

	  ENDIF
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
		 IF AT('PENSIONES',cNomSis) # 0
		    cError('NO EXISTEN CLIENTES GRABADOS')
		 ENDIF
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       VerPrn(nOpcPrn,FilePrn)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)

	       IF AT('PENSIONES',cNomSis) # 0
		  CloseAll(aUseDbf)
		  IF !lFileDelete(FileTem)
		     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
		  ENDIF
		  RETURN NIL
	       ELSE
		  GRU->(DBSKIP())
		  LOOP
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********INICIALIZACION DE ACUMULADORES
	    aVlrGru := {0,0,0,0,0}            // Saldo
	    FOR i := 1 TO LEN(cConcep)/2
		AADD(aVlrGru,0)           // Conceptos Mes
	    ENDFOR
	    AADD(aVlrGru,0)               // Recargos
	    AADD(aVlrGru,0)               // Anticipos
	    AADD(aVlrGru,0)               // Total Nivel
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
/*
// ojo
GO 1
*/
	    DO WHILE .NOT. CLI->(EOF())

*==============ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF CLI->lRetGruCli
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*==============INICIALIZACION DE ACUMULADORES
		 aRegEst := {0,; // Deuda Anterior
			     0,; // Mora Anterior
			     0}  // Valor del Mes
*==============FIN INICIALIZACION DE ACUMULADORES

*==============IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('MES : '+cMes(nMesIniTpa)+;
			     'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*==============FIN IMPRESION DE LA LINEA DE ESTADO

*==============ANALISIS PARA UN SOLO ESTUDIANTE
		 IF !EMPTY(cCodEst)
		    IF CLI->cCodigoEst # cCodEst
		       SELECT CLI
		       CLI->(DBSKIP())
		       LOOP
		    ENDIF
		    cCodEst += '-'+ALLTRIM(STR(CLI->(RECNO()),2))
		 ENDIF
*==============FIN ANALISIS PARA UN SOLO ESTUDIANTE

*==============ANALISIS SI ESTUDIANTE ESTA RETIRADO
		 lRetadoTes := .F.
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,;
				       cMaeAlu,@cNalias,.F.)
		 IF lHayAlu
		    cCodigoTes := &cNalias->cCodigoEst
		    IF &cNalias->lRetiroEst
		       lRetadoTes := .T.
		    ENDIF
		    cNombreTes := RTRIM(&cNalias->cApelliEst)+' '+;
				  &cNalias->cNombreEst
		 ENDIF
*==============FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*==============LOCALIZACION DEL PAGO
		 lHayPag := .F.
		 IF lHayAlu
		    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)
		 ENDIF
*==============FIN LOCALIZACION DEL PAGO

*==============ANALISIS DE LA FECHA DE PAGO
		 lFPagOk := .T.
		 IF lPrnFec .AND. lHayPag
		    IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
		       IF PAG->dFecPagPag > dFecPrn
			  lFPagOk := .F.
		       ENDIF
		    ENDIF
		 ENDIF
*==============FIN ANALISIS DE LA FECHA DE PAGO

*==============ANALISIS DEL PAGO DEL FIN DEL MES
		 lFinMes := .F.
		 IF !lPrnFec .AND.;
		    (YEAR(PAG->dFecPagPag) == VAL(cAnoUsr) .AND.;
		     MONTH(PAG->dFecPagPag) <= nMesIniTpa  .OR.;
		     YEAR(PAG->dFecPagPag)  < VAL(cAnoUsr))
		    lFinMes := .T.
		 ENDIF
*==============FIN ANALISIS DEL PAGO DEL FIN DEL MES

*==============CALCULO DE LOS DIFERENTES PAGOS
		 AFILL(aFacMes,0)
		 nFacMes := 0
		 IF lHayAlu .AND. lHayPag

*-------------------SUMATORIA DE AYUDAS,DESCUENTOS,RECARGOS
		      nVlrDes := PAG->nVlrDesPag+PAG->nDesGenPag
		      nVlrRec := PAG->nVlrRecPag+PAG->nRecGenPag
		      nVlrBec := PAG->nVlrBecPag

		      nTotDes += nVlrDes
		      nTotRec += nVlrRec
		      nTotBec += nVlrBec
*-------------------FIN SUMATORIA DE AYUDAS,DESCUENTOS,RECARGOS

*-------------------DETALLES DEL REGISTRO DE PAGOS DEL ESTUDIANTE
			       nVlrMes := PAG->nVlrMesPag
		      aRegEst[nDEUANT] := PAG->nSdoAntPag
		      aRegEst[nMORANT] := PAG->nMorAntPag
		      aRegEst[nVLRMES] := nVlrMes
*-------------------FIN DETALLES DEL REGISTRO DE PAGOS DEL ESTUDIANTE

*-------------------LOCALIZACION DEL ABONO
		      nDeuInt := 0
		      nAboDes := 0
		      SELECT DES
		      GO TOP
		      LOCATE FOR DES->cCodigoEst == CLI->cCodigoEst .AND.;
				 DES->nTipDesDes == 3

		      IF DES->(FOUND())

*                        TOTALIZACION DE LOS ABONOS
			   nAboEst := 0
			   nAboEst += nVlrAbo(CLI->cCodigoEst,cAnoUsr,;
					      nMesIniTpa,@nDeuInt,;
					      @nAboOtr,@nAboDes,;
					      @nAboFin,@nOtrFin,@nDesFin,;
					      lPrnFec,dFecPrn,aRegEst)
			   nAboMes += nAboEst
			   nDesMes += nAboDes
*                        FIN TOTALIZACION DE LOS ABONOS

*                        DEUDA ANTERIOR
			   nDeuAnt += PAG->nSdAbonPag
			   nMorAnt += PAG->nMoAbonPag

			   IF PAG->nSdAbonPag+PAG->nMoAbonPag # 0
			      AADD(aDeuAnt,{CLI->cCodigoEst,;
					    &cNalias->cCodigoGru,;
					    PAG->nSdAbonPag,;
					    PAG->nMoAbonPag,;
					    nAboEst,;
					    nAboOtr})
			   ENDIF
*                        FIN DEUDA ANTERIOR

		      ELSE

*                        DEUDA ANTERIOR
			   nDeuAnt += PAG->nSdoAntPag
			   nMorAnt += PAG->nMorAntPag

			   IF PAG->nSdoAntPag+PAG->nMorAntPag # 0
			      AADD(aDeuAnt,{CLI->cCodigoEst,;
					    &cNalias->cCodigoGru,;
					    PAG->nSdoAntPag,;
					    PAG->nMorAntPag,;
					    0,0})
			   ENDIF

			   IF PAG->nMesAmnPag == PAG->nMesIniPag
			      nDeuInt := nVlrMes()
			   ELSE
			      nDeuInt := PAG->nSdoAntPag+nVlrMes()
			   ENDIF
*                        FIN DEUDA ANTERIOR
		      ENDIF
*-------------------FIN LOCALIZACION DEL ABONO

*-------------------TOTALIZACION DE LOS PAGOS PARCIALES
		      nVlrMes := aRegEst[nVLRMES]
		      IF PAG->nPagParPag # 0
			 SELECT DES
			 GO TOP
			 LOCATE FOR DES->cCodigoEst == CLI->cCodigoEst .AND.;
				    DES->nTipDesDes == 4 .AND.;
				    DES->nNroMesDes == nMesIniTpa

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
			       DO CASE
			       CASE YEAR(DES->dFechaDes) == VAL(cAnoUsr) .AND.;
				    MONTH(DES->dFechaDes) <= nMesIniTpa
				    nFinMes += PAG->nPagParPag
			       CASE YEAR(DES->dFechaDes) < VAL(cAnoUsr)
				    nFinMes += PAG->nPagParPag
			       ENDCASE
			    ENDIF
			 ENDIF
		      ENDIF
*-------------------FIN TOTALIZACION DE LOS PAGOS PARCIALES

*-------------------VALIDACION DE DESCUENTOS Y OTROS
		      SELECT PAG
		      IF lValida
			 IF PAG->nVlrDesPag # 0 .OR.;
			    PAG->nDesGenPag # 0 .OR.;
			    PAG->nVlrRecPag # 0 .OR.;
			    PAG->nRecGenPag # 0 .OR.;
			    PAG->nVlrBecPag # 0

			    SET DEVICE TO SCREEN
			    nNroFil := nMarco(nFilInf+3,;
					      'ESTUDIANTE CON DESCUENTOS,'+;
					      'RECARGOS O AYUDAS')

			    cTxtPrn := 'COD: '+CLI->cCodigoEst+' '+;
				       cNombreTes+'GRUPO: '+GRU->cCodigoGru
			    @ nNroFil++,01 SAY cTxtPrn

			    cTxtPrn := 'RECARGOS INDIVIDUALES='+;
					STR(PAG->nVlrRecPag,10,2)+' '+;
				       'RECARGOS GENERALES ='+;
					STR(PAG->nRecGenPag,10,2)+' '+;
				       '= '+STR(nTotRec,10,2)
			    @ nNroFil++,01 SAY cTxtPrn

			    cTxtPrn := 'DESCUENTO INDIVIDUAL ='+;
					STR(PAG->nVlrDesPag,10,2)+' '+;
				       'DESCUENTO GENERAL  ='+;
					STR(PAG->nDesGenPag,10,2)+' '+;
				       '= '+STR(nTotDes,10,2)
			    @ nNroFil++,01 SAY cTxtPrn

			    cTxtPrn := 'AYUDAS               ='+;
				       STR(PAG->nVlrBecPag,10,2)+SPACE(32)+;
				       '= '+STR(nTotBec,10,2)
			    @ nNroFil++,01 SAY cTxtPrn

			    IF !lPregunta('DESEA CONTINUAR? Si No')
			       VerPrn(nOpcPrn,FilePrn)
			       CloseAll(aUseDbf)
			       IF !lFileDelete(FileTem)
				  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
			       ENDIF
			       RETURN NIL
			    ENDIF
			    SET DEVICE TO PRINT

			 ENDIF
		      ENDIF
*-------------------FIN VALIDACION DE DESCUENTOS Y OTROS

*-------------------ANALISIS SI ES EL MES ACTUAL
		      lMesAct := .T.
		      IF nMesIniTpa < LEN(RTRIM(CLI->cMesPagCli))
			 lMesAct := .F.
		      ENDIF
		      nNroEst++
*-------------------FIN ANALISIS SI ES EL MES ACTUAL

*-------------------CALCULO PARA CADA UNO DE LOS CONCEPTOS
		      nFacMes := 0
		      FOR i := 1 TO LEN(cConcep)/2

*                         LOCALIZACION DEL VALOR DEL CONCEPTO
			    SELECT PAG
			    cCodigoTco := SUBS(cConcep,i*2-1,2)
			    IF cCodigoTco $ PAG->cConcepPag
			       nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
			       nVlrTar := &('nVlrCo'+STR(nNroPos,1)+'Pag')
			    ELSE
			       nVlrTar := 0
			    ENDIF
*                         FIN LOCALIZACION DEL VALOR DEL CONCEPTO


*                         FACTURACION DEL MES PARA CADA CONCEPTO
			   IF lLocCodigo('cCodigoCon','CON',cCodigoTco)

			      IF CON->lDesEfeDes

				     nFacMes  -= nVlrTar
				 aFacMes[i] := nVlrTar
				 aVlrGru[i+5] -= nVlrTar
				 aVlrTot[i+5] -= nVlrTar
				 aVlrNiv[i+5] -= nVlrTar

				 aVlrGru[LEN(aVlrGru)] -= nVlrTar
				 aVlrNiv[LEN(aVlrNiv)] -= nVlrTar
				 aVlrTot[LEN(aVlrTot)] -= nVlrTar
			       *ÀTotales del Grupo

			      ELSE
				     nFacMes  += nVlrTar
				 aFacMes[i] := nVlrTar
				 aVlrGru[i+5] += nVlrTar
				 aVlrTot[i+5] += nVlrTar
				 aVlrNiv[i+5] += nVlrTar

				 aVlrGru[LEN(aVlrGru)] += nVlrTar
				 aVlrNiv[LEN(aVlrNiv)] += nVlrTar
				 aVlrTot[LEN(aVlrTot)] += nVlrTar
			       *ÀTotales del Grupo
			      ENDIF

			   ELSE
				  nFacMes  += nVlrTar
			      aFacMes[i] := nVlrTar
			      aVlrGru[i+5] += nVlrTar
			      aVlrTot[i+5] += nVlrTar
			      aVlrNiv[i+5] += nVlrTar

			      aVlrGru[LEN(aVlrGru)] += nVlrTar
			      aVlrNiv[LEN(aVlrNiv)] += nVlrTar
			      aVlrTot[LEN(aVlrTot)] += nVlrTar
			    *ÀTotales del Grupo


			   ENDIF
*                         FIN FACTURACION DEL MES PARA CADA CONCEPTO


		      ENDFOR
*-------------------FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS

*-------------------CALCULO DE LOS INTERESES ACTUALES
		      nVlrInt := nIntMesPag(CAA->lIntPenCaA,;
					    aRegEst[nDEUANT],;
					    nVlrMes,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)

		      nIntNoP := nIntMesNoP(CAA->lIntPenCaA,;
					    aRegEst[nDEUANT],;
					    nVlrMes,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)
*-------------------FIN CALCULO DE LOS INTERESES ACTUALES

*-------------------CALCULO DE OTROS TOTALES
		      aRegEst[nDEUANT] += PAG->nSdoAnoPag
		      aRegEst[nMORANT] += PAG->nMorAnoPag

		      DO CASE
		      CASE PAG->cEstadoPag == 'P' .OR.;
			   PAG->cEstadoPag == 'A'

*::::::::::::::::::::::::::ANALISIS DEL PAGO DE ACUERDO A LA FECHA
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
*::::::::::::::::::::::::::FIN ANALISIS DEL PAGO DE ACUERDO A LA FECHA


*::::::::::::::::::::::::::CALCULO DE LAS DEUDAS POR PAGO FUERA DE CORTE
			     IF CAA->nMesAmnCaA # nMesIniTpa .AND.;
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
					     aRegEst[nMORANT],aVlrGru,aVlrNiv,;
					     aVlrTot)
				*FIN REGISTRO DEL SALDO ACTUAL

			     ENDIF
*::::::::::::::::::::::::::FIN CALCULO DE LAS DEUDAS POR PAGO FUERA DE CORTE

*::::::::::::::::::::::::::CALCULOS DE LAS DEUDAS POR AMNISTIA
			     IF CAA->nMesAmnCaA == nMesIniTpa

			       *REGISTRO DEL SALDO ACTUAL
				  nSdoAct := IF(lMesAct,CLI->nSdoActCli,;
							PAG->nSdoAntPag)

				  nSdoMor := IF(lMesAct,CLI->nSdoMorCli,;
							PAG->nMorAntPag)
				  IF nSdoAct+nSdoMor
				     nNroDeu++
				     nTotDeu++
				     nVlrSdo := nSdoAct+nSdoMor
				     nVlrDeu := nSdoAct
				     nPorCob := nSdoMor

				     RegSdoAct(nVlrSdo,nVlrDeu,nPorCob,0,;
					       nSdoMor,aVlrGru,aVlrNiv,;
					       aVlrTot)
				  ENDIF
			       *FIN REGISTRO DEL SALDO ACTUAL

			     ENDIF
*::::::::::::::::::::::::::FIN CALCULOS DE LAS DEUDAS POR AMNISTIA

*::::::::::::::::::::::::::VALOR DE LOS INTERESES
			     IF PAG->cEstadoPag == 'A'
				nNroExt++

				aVlrGru[LEN(aVlrGru)-2] += nVlrInt
				aVlrNiv[LEN(aVlrNiv)-2] += nVlrInt
				aVlrTot[LEN(aVlrTot)-2] += nVlrInt
			      *ÀValor Recargo

				aVlrGru[LEN(aVlrGru)] += nVlrInt
				aVlrNiv[LEN(aVlrNiv)] += nVlrInt
				aVlrTot[LEN(aVlrTot)] += nVlrInt
			       *Total del grupo
			     ENDIF
*::::::::::::::::::::::::::FIN VALOR DE LOS INTERESE

*::::::::::::::::::::::::::VALOR DE LOS ANTICIPOS
			     IF PAG->nMesIniPag # PAG->nMesFinPag .OR.;
				lHayAntici(nMesIniTpa,PAG->cIniFinPag)

				nNroAde++
				IF PAG->nMesFinPag == CAA->nMesFinCaA
				   nFinAde++
				ENDIF

				IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses

				   aAntEst := AnticiVar(GRU->cCodigoGru,;
							aFacMes,;
							PAG->nMesIniPag,;
							PAG->nMesFinPag,;
							aAntici,;
							PAG->cIniFinPag,;
							PAG->cConcepPag,;
							cConcep)

				ELSE
				   aAntEst := Anticipos(aFacMes,;
						 (nNroMesFac(PAG->nMesIniPag,;
						  PAG->nMesFinPag)-1),aAntici,;
						  PAG->cIniFinPag,PAG->cConcepPag,;
						  cConcep)
				ENDIF

				nAntici := nSuma(aAntEst)


				aVlrGru[LEN(aVlrGru)-1] += nAntici
				aVlrNiv[LEN(aVlrNiv)-1] += nAntici
				aVlrTot[LEN(aVlrTot)-1] += nAntici
			      *ÀAnticipos

				aVlrGru[LEN(aVlrGru)] += nAntici
				aVlrNiv[LEN(aVlrNiv)] += nAntici
				aVlrTot[LEN(aVlrTot)] += nAntici
			      *ÀTotal del grupo

				IF lPrnFec .AND. !lFPagOK
				   aVlrGru[1] += nAntici
				   aVlrNiv[1] += nAntici
				   aVlrTot[1] += nAntici
				 *ÀSaldo

				   aVlrGru[2] += nAntici
				   aVlrNiv[2] += nAntici
				   aVlrTot[2] += nAntici
				 *ÀDeuda
				ENDIF
			      *ÀAnticipo como saldo

			     ENDIF
*::::::::::::::::::::::::::FIN VALOR DE LOS ANTICIPOS

		      CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

			   nNroDeu++
			   nTotDeu++
			   IF PAG->cEstadoPag = 'D'

*:::::::::::::::::::::::::::::REGISTRO DEL SALDO ACTUAL
				nPorCob := nIntNoP+aRegEst[nMORANT]
				nVlrDeu := aRegEst[nDEUANT]+aRegEst[nVLRMES]
				nVlrSdo := nVlrDeu+nPorCob

				RegSdoAct(nVlrSdo,nVlrDeu,nPorCob,nIntNoP,;
					  aRegEst[nMORANT],aVlrGru,aVlrNiv,;
					  aVlrTot)
*:::::::::::::::::::::::::::::FIN REGISTRO DEL SALDO ACTUAL

*:::::::::::::::::::::::::::::INTERESES POR COBRAR SIN ABONOS
				nIntCob += nIntNoP(nDeuInt)

				aVlrGru[LEN(aVlrGru)] += nIntNoP
				aVlrNiv[LEN(aVlrNiv)] += nIntNoP
				aVlrTot[LEN(aVlrTot)] += nIntNoP
			       *Total del grupo
*:::::::::::::::::::::::::::::FIN INTERESES POR COBRAR SIN ABONOS

			   ELSE

*:::::::::::::::::::::::::::::SALDO ACTUAL
				aVlrGru[1] += CLI->nSdoActCli+CLI->nSdoMorCli
				aVlrNiv[1] += CLI->nSdoActCli+CLI->nSdoMorCli
				aVlrTot[1] += CLI->nSdoActCli+CLI->nSdoMorCli
*:::::::::::::::::::::::::::::FIN SALDO ACTUAL

*:::::::::::::::::::::::::::::DEUDA SIN INTERESES
				aVlrGru[2] += CLI->nSdoActCli
				aVlrNiv[2] += CLI->nSdoActCli
				aVlrTot[2] += CLI->nSdoActCli
*:::::::::::::::::::::::::::::FIN DEUDA SIN INTERESES

*:::::::::::::::::::::::::::::INTERESES POR COBRAR
				aVlrGru[3] += CLI->nSdoMorCli
				aVlrNiv[3] += CLI->nSdoMorCli
				aVlrTot[3] += CLI->nSdoMorCli
*:::::::::::::::::::::::::::::FIN INTERESES POR COBRAR

*:::::::::::::::::::::::::::::INTERESES POR COBRAR ANTERIORES
				aVlrGru[5] += PAG->nMorAntPag
				aVlrNiv[5] += PAG->nMorAntPag
				aVlrTot[5] += PAG->nMorAntPag
*:::::::::::::::::::::::::::::FIN INTERESES POR COBRAR ANTERIORES

			   ENDIF

		      ENDCASE
*-------------------FIN CALCULO DE OTROS TOTALES

		 ELSE

*-------------------LOCALIZACION DEL PAGO
		      nMesRet := LEN(RTRIM(CLI->cMesPagCli))
		      IF nMesIniTpa < nMesRet
			 nMesRet := nMesIniTpa
		      ENDIF
		      lHayPag := .F.
		      IF lHayAlu
			 lHayPag := lLocCodPag(CLI->cCodigoEst,nMesRet,.F.)
		      ENDIF
*-------------------FIN LOCALIZACION DEL PAGO

*-------------------ESTUDIANTE RETIRADO CON SALDO
		      IF lRetadoTes .AND.;
			 CLI->nSdoActCli+CLI->nSdoMorCli # 0

*::::::::::::::::::::::::SALDO ANTERIOR
			 IF nMesRet < nMesIniTpa

			    nDeuAnt += CLI->nSdoActCli
			    nMorAnt += CLI->nSdoMorCli

			    AADD(aDeuAnt,{CLI->cCodigoEst,;
					  &cNalias->cCodigoGru,;
					  CLI->nSdoActCli,;
					  CLI->nSdoMorCli,;
					  0,0})
			 ENDIF
*::::::::::::::::::::::::FIN SALDO ANTERIOR

*::::::::::::::::::::::::SALDO ACTUAL
			   IF nMesRet < nMesIniTpa
			      aVlrGru[1] += CLI->nSdoActCli+CLI->nSdoMorCli
			      aVlrNiv[1] += CLI->nSdoActCli+CLI->nSdoMorCli
			      aVlrTot[1] += CLI->nSdoActCli+CLI->nSdoMorCli
			   ENDIF
*::::::::::::::::::::::::FIN SALDO ACTUAL

*::::::::::::::::::::::::DEUDA SIN INTERESES
			   IF nMesRet < nMesIniTpa
			      aVlrGru[2] += CLI->nSdoActCli
			      aVlrNiv[2] += CLI->nSdoActCli
			      aVlrTot[2] += CLI->nSdoActCli
			   ENDIF
*::::::::::::::::::::::::FIN DEUDA SIN INTERESES

*::::::::::::::::::::::::INTERESES POR COBRAR
			   IF nMesRet < nMesIniTpa
			      aVlrGru[3] += CLI->nSdoMorCli
			      aVlrNiv[3] += CLI->nSdoMorCli
			      aVlrTot[3] += CLI->nSdoMorCli
			   ENDIF
*::::::::::::::::::::::::FIN INTERESES POR COBRAR

*::::::::::::::::::::::::INTERESES POR COBRAR ANTERIORES
			   IF nMesRet < nMesIniTpa
			      aVlrGru[5] += CLI->nSdoMorCli
			      aVlrNiv[5] += CLI->nSdoMorCli
			      aVlrTot[5] += CLI->nSdoMorCli
			   ENDIF
*::::::::::::::::::::::::FIN INTERESES POR COBRAR ANTERIORES

		      ENDIF
*-------------------FIN ESTUDIANTE RETIRADO CON SALDO

*-------------------ESTUDIANTE RETIRADO SIN SALDO
		      IF lRetadoTes .AND.;
			 CLI->nSdoActCli+CLI->nSdoMorCli == 0

*::::::::::::::::::::::::ANALISIS DE LA FECHA DE PAGO
			   lFPagOk := .T.
			   IF lPrnFec .AND. lHayPag
			      IF PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'
				 IF PAG->dFecPagPag > dFecPrn
				    lFPagOk := .F.
				 ENDIF
			      ENDIF
			   ENDIF
*::::::::::::::::::::::::FIN ANALISIS DE LA FECHA DE PAGO

*::::::::::::::::::::::::ANALISIS DEL PAGO DEL FIN DEL MES
			   lFinMes := .F.
			   IF !lPrnFec .AND.;
			      (YEAR(PAG->dFecPagPag) == VAL(cAnoUsr) .AND.;
			       MONTH(PAG->dFecPagPag) <= nMesIniTpa  .OR.;
			       YEAR(PAG->dFecPagPag)  < VAL(cAnoUsr))

			       lFinMes := .T.
			   ENDIF
*::::::::::::::::::::::::FIN ANALISIS DEL PAGO DEL FIN DEL MES

*::::::::::::::::::::::::CALCULO DE LA DEUDA
			   IF (lHayAlu .AND. lHayPag)  .AND.;
			      ((!lPrnFec .AND. lFPagOk) .OR.;
			       (lPrnFec .AND. !lFPagOk)) .AND. !lFinMes

			       nVlrDeu := PAG->nSdoAntPag+PAG->nVlrMesPag
			       nSdoMor := PAG->nMorAntPag

			       AADD(aRetMor,{CLI->cCodigoEst,;
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
*::::::::::::::::::::::::FIN CALCULO DE LA DEUDA

*::::::::::::::::::::::::REGISTRO DEL SALDO ACTUAL
			   IF lHayAlu .AND. lHayPag .AND.;
			      lPrnFec .AND. !lFPagOk

			      nVlrSdo := nVlrDeu+nSdoMor+nIntNoP

			      RegSdoAct(nVlrSdo,nVlrDeu,nSdoMor+nIntNoP,;
					nVlrInt,nSdoMor,aVlrGru,aVlrNiv,;
					aVlrTot)
			   ENDIF
*::::::::::::::::::::::::FIN REGISTRO DEL SALDO ACTUAL

*::::::::::::::::::::::::FILTRACION DE DESCUENTOS PARA EL MES DEL RETIRO
			   IF lPrnFec
			      SELECT DES
			      SET FILTER TO
			      SET FILTER TO DES->nNroMesDes == nMesRet .OR.;
					    DES->nMesModDes == nMesRet
			      DES->(DBGOTOP())
			      IF DES->(EOF())
				 SET FILTER TO
			      ENDIF
			   ENDIF
*::::::::::::::::::::::::FIN FILTRACION DE DESCUENTOS PARA EL MES DEL RETIRO

*::::::::::::::::::::::::LOCALIZACION DEL ABONO
			   IF lPrnFec
			      DES->(DBGOTOP())
			      LOCATE FOR DES->cCodigoEst == CLI->cCodigoEst .AND.;
					 DES->nTipDesDes == 3

			      IF DES->(FOUND())

*................................ABONO EN FECHA POSTERIOR AL CORTE
				   IF DES->dFechaDes > dFecPrn
				      nVlrDeu := DES->nSdoAntPag+;
						 DES->nVlrMesPag
				      nIntPag := DES->nValorDes - nVlrDeu

				      nDeuAnt += nVlrDeu
				      nMorAnt += nIntPag

				      aVlrGru[1] += nVlrDeu+nIntPag
				      aVlrNiv[1] += nVlrDeu+nIntPag
				      aVlrTot[1] += nVlrDeu+nIntPag
				    *ÀSaldo Actual

				      aVlrGru[2] += nVlrDeu
				      aVlrNiv[2] += nVlrDeu
				      aVlrTot[2] += nVlrDeu
				    *ÀDeuda Sin Intereses

				      aVlrGru[3] += nIntPag
				      aVlrNiv[3] += nIntPag
				      aVlrTot[3] += nIntPag
				    *ÀIntereses por Cobrar

				      aVlrGru[5] += nIntPag
				      aVlrNiv[5] += nIntPag
				      aVlrTot[5] += nIntPag
				    *ÀIntereses por Cobrar Anteriores

				      AADD(aDeuAnt,{CLI->cCodigoEst,;
						    &cNalias->cCodigoGru,;
						    nVlrDeu,;
						    nIntPag,;
						    0,0})
				   ENDIF
*................................FIN ABONO EN FECHA POSTERIOR AL CORTE

			      ENDIF
			   ENDIF
*::::::::::::::::::::::::FIN LOCALIZACION DEL ABONO

*::::::::::::::::::::::::FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES
			   IF lPrnFec
			      SELECT DES
			      SET FILTER TO
			      SET FILTER TO DES->nNroMesDes == nMesIniTpa .OR.;
					    DES->nMesModDes == nMesIniTpa
			      DES->(DBGOTOP())
			      IF DES->(EOF())
				 SET FILTER TO
			      ENDIF
			   ENDIF
*::::::::::::::::::::::::FIN FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES

		      ENDIF
*-------------------FIN ESTUDIANTE RETIRADO SIN SALDO

		 ENDIF
*==============FIN CALCULO DE LOS DIFERENTES PAGOS

*==============AVANCE DEL SIGUIENTE REGISTRO
		 SET DEVICE TO SCREEN
		 Avance(CLI->(RECNO()),CLI->(RECCOUNT()))
		 SET DEVICE TO PRINT

		 SELECT CLI
		 CLI->(DBSKIP())

/*
// ojo
IF CLI->(RECNO()) == 7
   EXIT
ENDIF
*/

*==============FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

**********IMPRESION DEL CONTENIDO DEL INFORME
	    aTitulo := {}
	    AADD(aTitulo,GRU->cCodigoGru+'->'+STR(nNroEst,2))
	    AADD(aTitulo,' '+STR(nNroDeu,2)+':'+;
			 TRANS(aVlrGru[1],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[2],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[3],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[4],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[5],"####,###,###"))
	    FOR i := 1 TO LEN(cConcep)/2
		AADD(aTitulo,TRANS(aVlrGru[i+5],"####,###,###"))
	    ENDFOR
	    AADD(aTitulo,' '+STR(nNroExt,2)+':'+;
			 TRANS(aVlrGru[LEN(aVlrGru)-2],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[LEN(aVlrGru)-1],"####,###,###"))
	    AADD(aTitulo,TRANS(aVlrGru[LEN(aVlrGru)],"####,###,###"))

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    IF lAllInf
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF

	    AADD(aTitulo,GRU->cCodigoGru+cNroMes+cAnoSis+'.XML') // Campo Url
	    AADD(aPagXml,aTitulo)
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    nTotEst += nNroEst
	    nNroEst := 0
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

	       aTitulo := {}
	       AADD(aTitulo,'')

	       IF lAllInf
		  @ PROW()+1,00 SAY ''
	       ENDIF

	       FOR i := 1 TO LEN(aVlrNiv)

		   IF lAllInf
		      @ PROW(),nColTxt(aNroCol,i+1) SAY REPL('-',aNroCol[i+1])
		   ENDIF

		   AADD(aTitulo,REPL('-',aNroCol[i+1]))
	       ENDFOR
	       AADD(aTitulo,'') // Campo Url
	       AADD(aPagXml,aTitulo)

	       aTitulo := {}
	       AADD(aTitulo,cNivAnt)
	       AADD(aTitulo,SPACE(04)+TRANS(aVlrNiv[1],"####,###,###"))
	       AADD(aTitulo,TRANS(aVlrNiv[2],"####,###,###"))
	       AADD(aTitulo,TRANS(aVlrNiv[3],"####,###,###"))
	       AADD(aTitulo,TRANS(aVlrNiv[4],"####,###,###"))
	       AADD(aTitulo,TRANS(aVlrNiv[5],"####,###,###"))
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aTitulo,TRANS(aVlrNiv[i+5],"####,###,###"))
	       ENDFOR
	       AADD(aTitulo,SPACE(04)+;
			    TRANS(aVlrNiv[LEN(aVlrNiv)-2],"####,###,###"))
	       AADD(aTitulo,TRANS(aVlrNiv[LEN(aVlrNiv)-1],"####,###,###"))
	       AADD(aTitulo,TRANS(aVlrNiv[LEN(aVlrNiv)],"####,###,###"))

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       IF lAllInf
		  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	       ENDIF

	       AADD(aTitulo,'') // Campo Url
	       AADD(aPagXml,aTitulo)

	       IF lAllInf
		  @ PROW()+1,00 SAY ''
	       ENDIF

	       aVlrNiv := {0,0,0,0,0}   // Saldo Actual
	       FOR i := 1 TO LEN(cConcep)/2
		   AADD(aVlrNiv,0)  // Concepto Mes
	       ENDFOR
	       AADD(aVlrNiv,0)  // Recargo
	       AADD(aVlrNiv,0)  // Anticipos
	       AADD(aVlrNiv,0)  // Total Nivel
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
       aTitulo := {}
       AADD(aTitulo,'')

       IF lAllInf
	  @ PROW()+1,00 SAY ''
       ENDIF

       FOR i := 1 TO LEN(aVlrTot)

	   IF lAllInf
	      @ PROW(),nColTxt(aNroCol,i+1) SAY REPL('=',aNroCol[i+1])
	   ENDIF

	   AADD(aTitulo,REPL('=',aNroCol[i+1]))
       ENDFOR
       AADD(aTitulo,'') // Campo Url
       AADD(aPagXml,aTitulo)

       aTitulo := {}
       AADD(aTitulo,'TOTALES')
       AADD(aTitulo,SPACE(04)+TRANS(aVlrTot[1],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[2],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[3],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[4],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[5],"####,###,###"))
       FOR i := 1 TO LEN(cConcep)/2
	   AADD(aTitulo,TRANS(aVlrTot[i+5],"####,###,###"))
       ENDFOR
       AADD(aTitulo,SPACE(04)+TRANS(aVlrTot[LEN(aVlrTot)-2],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[LEN(aVlrTot)-1],"####,###,###"))
       AADD(aTitulo,TRANS(aVlrTot[LEN(aVlrTot)],"####,###,###"))

       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       IF lAllInf  // TOTALES
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF

       AADD(aTitulo,'RSF'+cMes(nMesIniTpa,3)+cAnoSis+'.XML') // Campo Url
       AADD(aPagXml,aTitulo)
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>CAMBIO DE PAGINA
       IF PROW() > 52
	  EJECT
	  EVAL(bCabeza)
	 *Impresi¢n del Encabezado
       ENDIF
*>>>>FIN CAMBIO DE PAGINA

*>>>>IMPRESION TOTALES DE LOS CONCEPTOS
       lPrnReg(02,00,DOBANC_ON+'RESUMEN'+DOBANC_OF,bPagina,bDerAut,bCabeza)
       lPrnReg(00,19,'MES '+cMes(nMesIniTpa,3),bPagina,bDerAut,bCabeza)
       lHayAnt := .F.
       IF aVlrTot[LEN(aVlrTot)-1] # 0
	  lPrnReg(00,34,'ANTICIPOS',bPagina,bDerAut,bCabeza)
	  lHayAnt := .T.
       ENDIF
       nTotal := 0
       FOR i := 1 TO LEN(cConcep)/2

	 IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	    lPrnReg(01,00,CON->cNombreCon+SPACE(03)+;
			  TRANS(aVlrTot[i+5],"####,###,###")+SPACE(01)+;
			  IF(lHayAnt,TRANS(aAntici[i],"####,###,###"),''),;
			  bPagina,bDerAut,bCabeza)
	    nTotal += aVlrTot[i+5]

	    AADD(aRegPrn,{CON->cNombreCon,;
			  TRANS(aVlrTot[i+5],"####,###,###"),;
			  IF(lHayAnt,TRANS(aAntici[i],"####,###,###"),''),''})

	 ELSE
	    lPrnReg(01,00,SUBS(cConcep,i*2-1,2)+SPACE(03)+;
			  TRANS(aVlrTot[i+5],"####,###,###"),;
			  bPagina,bDerAut,bCabeza)
	    nTotal += aVlrTot[i+5]

	    AADD(aRegPrn,{SUBS(cConcep,i*2-1,2),;
			 TRANS(aVlrTot[i+5],"####,###,###"),;
			 IF(lHayAnt,TRANS(aAntici[i],"####,###,###"),''),''})

	 ENDIF

/*
	 AADD(aVlrWww,{cCodEmp,1,nMesIniTpa,;
		       SUBS(cConcep,i*2-1,2),aVlrTot[i+5]})

	 AADD(aVlrWww,{cCodEmp,2,nMesIniTpa,;
		       SUBS(cConcep,i*2-1,2),aAntici[i]})
*/

       ENDFOR
*>>>>FIN IMPRESION TOTALES DE LOS CONCEPTOS

*>>>>OTROS TOTALES
       cTxtPrn := ''
       IF aVlrTot[LEN(aVlrTot)-1] # nSuma(aAntici)
	  cTxtPrn := ' =>ERROR'
       ENDIF
       nTotal += aVlrTot[LEN(aVlrTot)-1]

       lPrnReg(01,00,'+ANTICIPOS         '+;
		     TRANS(aVlrTot[LEN(aVlrTot)-1],"####,###,###")+;
		     IF(lHayAnt,'='+TRANS(nSuma(aAntici),"####,###,###")+;
				cTxtPrn,'')+' ESTUDIANTES='+;
				ALLTRIM(STR(nNroAde,4))+' '+;
				'A '+cMes(CAA->nMesFinCaA,3)+'='+;
				ALLTRIM(STR(nFinAde,4)),;
		     bPagina,bDerAut,bCabeza)

       AADD(aRegPrn,{'+ANTICIPOS         ',;
		     TRANS(aVlrTot[LEN(aVlrTot)-1],"####,###,###"),;
		     IF(lHayAnt,'='+TRANS(nSuma(aAntici),"####,###,###"),''),;
		     'ANT'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal += nTotRec
       lPrnReg(01,00,'+RECARGOS          '+TRANS(nTotRec,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

//       AADD(aVlrWww,{cCodEmp,3,nMesIniTpa,,nTotRec})

       AADD(aRegPrn,{'+RECARGOS',;
		     TRANS(nTotRec,"####,###,###"),'',;
		     'DES'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal -= nTotBec
       lPrnReg(01,00,'-AYUDAS            '+TRANS(nTotBec,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,4,nMesIniTpa,,nTotBec})

       AADD(aRegPrn,{'-AYUDAS',;
		     TRANS(nTotBec,"####,###,###"),'',;
		     'HLP'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal -= nTotDes
       lPrnReg(01,00,'-DESCUENTOS        '+TRANS(nTotDes,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,5,nMesIniTpa,,nTotDes})

       AADD(aRegPrn,{'-DESCUENTOS',;
		     TRANS(nTotDes,"####,###,###"),'',;
		     'DES'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       lPrnReg(01,00,SPACE(19)+REPL('=',12),bPagina,bDerAut,bCabeza)

       AADD(aRegPrn,{'',REPL('=',12),'',''})

       lPrnReg(01,00,'FACTURACION        '+;
		     TRANS(nTotal ,"####,###,###")+;
		     IF(EMPTY(cCodEst),;
		       ' ALUMNOS = '+TRANS(nTotEst,"####")+' '+;
				   'DEUDORES ='+TRANS(nTotDeu,"####"),;
		       ' CODIGO = '+cCodEst),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,6,nMesIniTpa,,nTotEst})

       AADD(aRegPrn,{'FACTURACION',TRANS(nTotal ,"####,###,###"),;
		     IF(EMPTY(cCodEst),' ALUMNOS = '+TRANS(nTotEst,"####"),;
		       'CODIGO = '+cCodEst),;
		     'EST'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal += aVlrTot[LEN(aVlrTot)-2]
       lPrnReg(01,00,'+INT PAGO MES      '+;
		     TRANS(aVlrTot[LEN(aVlrTot)-2],"####,###,###"),;
		     bPagina,bDerAut,bCabeza)

//       AADD(aVlrWww,{cCodEmp,7,nMesIniTpa,,aVlrTot[LEN(aVlrTot)-2]})

       AADD(aRegPrn,{'+INT PAGO MES',;
		     TRANS(aVlrTot[LEN(aVlrTot)-2],"####,###,###"),'',''})

       nTotal += nIntCob
       lPrnReg(01,00,'+INTxCobMes        '+;
		     TRANS(nIntCob,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,8,nMesIniTpa,,nIntCob})

       AADD(aRegPrn,{'+INTxCobMes',TRANS(nIntCob,"####,###,###"),'',''})

       lPrnReg(01,00,SPACE(19)+REPL('=',12),bPagina,bDerAut,bCabeza)
       AADD(aRegPrn,{'',REPL('=',12),'',''})

       lPrnReg(01,00,'TOTAL CAUSACION    '+;
		     TRANS(nTotal,"####,###,###"),bPagina,bDerAut,bCabeza)
       nTotCau := nTotal

       AADD(aRegPrn,{'TOTAL CAUSACION',TRANS(nTotal,"####,###,###"),'',''})

       nTotal += nDeuAnt
       lPrnReg(01,00,' DEUDA ANTERIOR    '+;
		     TRANS(nDeuAnt,"####,###,###")+;
		     IF(nDeuRet # 0,'+'+TRANS(nDeuRet,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,9,nMesIniTpa,,nDeuAnt})

       AADD(aRegPrn,{' DEUDA ANTERIOR',TRANS(nDeuAnt,"####,###,###"),;
		     IF(nDeuRet # 0,'+'+TRANS(nDeuRet,"####,###,###")+;
			' A '+cMes(nMesIniTpa,3),''),''})

       nTotal += nMorAnt
       lPrnReg(01,00,' MORA ANTERIOR     '+;
		     TRANS(nMorAnt,"####,###,###")+;
		     IF(nMorRet # 0,'+'+TRANS(nMorRet,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,10,nMesIniTpa,,nMorAnt})

       AADD(aRegPrn,{' MORA ANTERIOR',TRANS(nMorAnt,"####,###,###"),;
		     IF(nMorRet # 0,'+'+TRANS(nMorRet,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),''})

       lPrnReg(01,00,SPACE(19)+REPL('-',12),bPagina,bDerAut,bCabeza)
       AADD(aRegPrn,{'',REPL('=',12),'',''})

       lPrnReg(01,00,'+SALDO ANTERIOR    '+;
		     TRANS(nDeuAnt+nMorAnt,"####,###,###"),;
		     bPagina,bDerAut,bCabeza)
       AADD(aRegPrn,{'SALDO ANTERIOR',TRANS(nDeuAnt+nMorAnt,"####,###,###"),'',''})

       nTotFin := nTotal
       nTotal  -= nTotPag
       nTotFin -= nFinMes
       lPrnReg(01,00,'-PAGOS             '+;
		     TRANS(nTotPag,"####,###,###")+;
		     IF(nFinMes # 0,' '+TRANS(nFinMes,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,11,nMesIniTpa,,nTotPag})

       AADD(aRegPrn,{'-PAGOS',TRANS(nTotPag,"####,###,###"),;
		     IF(nFinMes # 0,' '+TRANS(nFinMes,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     'PAG'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal  -= nAboMes
       nTotFin -= nAboFin
       lPrnReg(01,00,'-ABONOS PARA EL MES'+;
		     TRANS(nAboMes,"####,###,###")+;
		     IF(nAboFin # 0,' '+TRANS(nAboFin,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,12,nMesIniTpa,,nAboMes})

       AADD(aRegPrn,{'-ABONOS PARA EL MES',TRANS(nAboMes,"####,###,###"),;
		     IF(nAboFin # 0,' '+TRANS(nAboFin,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     'DES'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal -= nDesMes
       nTotFin -= nDesFin
       lPrnReg(01,00,'-ABONOS DESCUENTOS '+TRANS(nDesMes,"####,###,###")+;
		     IF(nDesFin # 0,' '+TRANS(nDesFin,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,13,nMesIniTpa,,nDesMes})

       AADD(aRegPrn,{'-ABONOS DESCUENTOS',TRANS(nDesMes,"####,###,###"),;
		     IF(nDesFin # 0,' '+TRANS(nDesFin,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     'DES'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})

       nTotal -= nAboOtr
       nTotFin -= nOtrFin
       lPrnReg(01,00,'-ABONOS OTROS MESES'+;
		     TRANS(nAboOtr,"####,###,###")+;
		     IF(nOtrFin # 0,' '+TRANS(nOtrFin,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),;
		     bPagina,bDerAut,bCabeza)
//       AADD(aVlrWww,{cCodEmp,14,nMesIniTpa,,nAboOtr})

       AADD(aRegPrn,{'-ABONOS OTROS MESES',;
		     TRANS(nAboOtr,"####,###,###"),;
		     IF(nOtrFin # 0,' '+TRANS(nOtrFin,"####,###,###")+;
		     ' A '+cMes(nMesIniTpa,3),''),''})

       lPrnReg(01,00,SPACE(19)+REPL('=',12)+;
		  IF(nFinMes+nAboFin+nDesFin # 0,' '+REPL('=',12),''),;
		  bPagina,bDerAut,bCabeza)

       AADD(aRegPrn,{'',REPL('=',12),'',''})

       IF EMPTY(dFecPrn)

	  lPrnReg(01,00,IF(aVlrTot[1] == nTotal,'SALDO ACTUAL','saldo actual')+;
			'      '+;
			TRANS(nTotal,"####,###,###")+;
			IF(nFinMes+nAboFin+nDesFin+nDeuRet+nMorRet # 0,;
			' '+TRANS(nTotFin+nDeuRet+nMorRet,"####,###,###")+;
			' A '+cMes(nMesIniTpa,3),''),;
			bPagina,bDerAut,bCabeza)

	  AADD(aRegPrn,{'SALDO ACTUAL'+TRANS(nTotal,"####,###,###"),;
			IF(nFinMes+nAboFin+nDesFin+nDeuRet+nMorRet # 0,;
			' '+TRANS(nTotFin+nDeuRet+nMorRet,"####,###,###")+;
			' A '+cMes(nMesIniTpa,3),''),;
			'MOR'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})
       ELSE

	  lPrnReg(01,00,'SALDO ACTUAL'+;
			IF(aVlrTot[1] == (nTotal+nDeuRet+nMorRet),' ','.')+;
			'       '+;
			TRANS(nTotal+nDeuRet+nMorRet,"####,###,###"),;
			bPagina,bDerAut,bCabeza)

	  AADD(aRegPrn,{'SALDO ACTUAL',;
			TRANS(nTotal+nDeuRet+nMorRet,"####,###,###"),'',;
			'MOR'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})
       ENDIF
       AADD(aRegPrn,{IF(aVlrTot[1]==nTotal+nDeuRet+nMorRet,;
		     'CARTERA CUADRADA','CARTERA DESCUADRADA'),;
	    TRANS(aVlrTot[1],"####,###,###"),'',;
	    'FAC'+cMes(nMesIniTpa,3)+cAnoSis+'.XML'})
*>>>>FIN OTROS TOTALES

*>>>>GRABACION DE LA CAUSACION
       IF lAllGru
	  IF aVlrTot[1] == nTotal+nDeuRet+nMorRet
	     lSavTotCau(nMesIniTpa,nTotCau,lShared,.F.,cNomUsr)
	  ELSE
	     SET DEVICE TO SCREEN
*	     cError('CARTERA DESCUADRADA')
	     SET DEVICE TO PRINT
	  ENDIF
	  lSavTotPag(nMesIniTpa,nTotPag+nAboMes,lShared,.F.,cNomUsr)
       ENDIF
*>>>>FIN GRABACION DE LA CAUSACION

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

*>>>>EXPORTACION DE LA FACTURACION A UN ARCHIVO
       Termometro(0,"CREANDO EL ARCHIVO DE LA FACTURACION MES DE "+;
		     cMes(nMesIniTpa,3))

/*
       FileChr(cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)+'\'+;
	       'FAC'+cMes(nMesIniTpa,3)+cAnoSis+'.TXT',aVlrWww)
*/
*>>>>FIN EXPORTACION DE LA FACTURACION A UN ARCHIVO

/*

*>>>>EXPORTACION DEL RETIRADOS CON SALDO A UN ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis)
      *Nombre del Sistema

       AADD(aCabXml,'ESTUDIANTES RETIRADOS CON DEUDA ANTERIOR. A¥O: '+;
		    cAnoUsr+'. JORNADA: '+cJorTxt)
      *Titulo No. 1

       AADD(aCabXml,'')
      *Titulo No. 2

       AADD(aCabXml,'')
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       aCamXml := {'codigo','DeuAnt','MorAnt'}

       FileXml(cPatSis+'\FILEWWW\FACT'+cMes(nMesIniTpa,3)+'\'+;
	       'deudaret.XML',aRetMor,aCamXml,aCabXml)

     *ÀCreaci¢n del Archivo
*>>>>FIN EXPORTACION DEL RETIRADOS CON SALDO A UN ARCHIVO



*>>>>EXPORTACION DE LA FACTURACION
       aCabXml[2] := cNomSis+':{PAGOS}{INFORMES FACTURACION}{FACTURACION DEL MES}'

       aCabXml[3] := 'FACTURACION DEL MES'+;
		     IF(EMPTY(dFecPrn),' A LA FECHA.',;
		     ' A '+cFecha(dFecPrn,3))

       aCabXml[4] := 'CORRESPONDIENTE A RECIBOS DE '+cMes(nMesIniTpa,10)+;
		     IF(nMesAmn == nMesIniTpa,' CON AMNISTIA','')

       aCabXml[5] := 'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr

       IF lHayXml .AND. EMPTY(dFecPrn)

	  FileXml(PathW01+'\FACT'+cMes(nMesIniTpa,3)+'\'+;
		  'FAC'+cMes(nMesIniTpa,3)+cAnoSis+'.xml',;
		  aPagXml,aCamPag,aCabXml)
       ENDIF
     *ÀCreaci¢n del Archivo
*>>>>FIN EXPORTACION DE LA FACTURACION

*>>>>EXPORTACION DEL RESUMEN
       aCamXml := {'RESUMEN','MES '+cMes(nMesIniTpa,3),;
		   IF(aVlrTot[LEN(aVlrTot)-1] # 0,'ANTICIPOS','')}

       IF lHayXml .AND. EMPTY(dFecPrn)

	  FileXml(PathW01+'\'+;
		  'FACT'+cMes(nMesIniTpa,3)+'\'+;
		  'RSF'+cMes(nMesIniTpa,3)+cAnoSis+'.xml',;
		  aRegPrn,aCamXml,aCabXml)
       ENDIF
     *ÀCreaci¢n del Archivo
*/
       RETURN aDeuAnt
*>>>>FIN EXPORTACION DEL RESUMEN




