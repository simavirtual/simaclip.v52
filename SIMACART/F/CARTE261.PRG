/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INCONSISTENCIAS.
SUBMODULO...: FACTURACION MAS PAGOS                    MODULO No. 261

**************************************************************************
* TITULO..: FACTURACION MAS PAGOS                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 06/97 VIE A
       Bucaramanga, Colombia	    INICIO: 11:30 PM   JUN 06/97 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir el informe de la relaci¢n total de los ingresos y egresos
   que se efectuaron por los grupos en forma descriminada.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_261(aParam1,aParam2,aParam3)

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

       LOCAL nTotGru := 0                   // Total grupos a imprimir
       LOCAL nTotCon := 0                   // Total de conceptos
       LOCAL nLinInt := 0                   // l¡neas intermedias
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
     *ÀVariables Calculo total registro

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL nNroFil := 0                   // N£mero de la Fila
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

       LOCAL lMesAct := .T.                 // .T. Mes Actual.
       LOCAL nDeuAnt := 0                   // Deuda Anterior del Mes Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior del Mes Anterior
       LOCAL nDesSdo := 0                   // Descuedre del Saldo Anterior
       LOCAL nDesMor := 0                   // Descuadre de la Mora Anterior
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nSdoMor := 0                   // Saldo de la Mora
       LOCAL nNroNiv := 0                   // N£mero de Niveles
       LOCAL nVlrSdo := 0                   // Valor del saldo
       LOCAL nIntMor := 0                   // Intereses por mora
       LOCAL nVlrDeu := 0                   // Valor de la deuda
       LOCAL nPago   := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nVlrPag := 0                   // Valor de los pagos sin anticipos

       LOCAL nIntPag := 0                   // Intereses pagados
       LOCAL nVlrIng := 0                   // Valor de los ingresos
       LOCAL nFacMes := 0                   // Valor de lo facturado

       LOCAL aVlrEst := {}                  // Valores por Estudiante
       LOCAL aVlrCon := {}                  // Valores por conceptos
       LOCAL aTotNiv := {}                  // Totales por conceptos por nivel
       LOCAL aTotCon := {}                  // Totales por conceptos

       LOCAL nDeuInt := 0                   // Deuda para calcular intereses del mes
       LOCAL nVlrInt := 0                   // Valor de los intereses
       LOCAL nVlrAbo := 0                   // Valor del Abono para el mes
       LOCAL nAboOtr := 0                   // Valor del Abono otros meses
       LOCAL nAboDes := 0                   // Abono Descuento

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
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nNroPos := 0                   // N£mero de la posici¢n

       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL nMesFin := 0                   // Mes Final
       LOCAL lValida := .F.                 // .T. Valida o Detalla los Registros
       LOCAL lPorGru := .F.                 // .T. Por Grupos
       LOCAL cConcep := ''                  // Conceptos
       LOCAL nVlrTar := ''                  // Valor de las tarifas
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
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis,lAnoAct)       .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)  .OR.;
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

*>>>>LECTURA DE LOS CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       cConcep := CAR->cConPrnCar
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

*>>>>PREGUNTA DE DECISION
       lPorGru := .T.
       IF nRegIni # nRegFin
	  lPorGru := !lPregunta('DESEA IMPRIMIR LOS ESTUDIANTES '+;
			       'CON INCONSISTENCIAS? No Si')
	  IF !lPorGru
	     lValida := .T.
	  ENDIF
       ENDIF
*>>>>FIN PREGUNTA DE DECISION

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES
       SELECT DES
       SET FILTER TO DES->nNroMesDes == nMesIniTpa .OR.;
		     DES->nMesModDes == nMesIniTpa
       GO TOP
       IF EOF()
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
       lTamAnc := .T.
       aCabeza := {cNomEmp,cNomSis,;
		   'FACTURACION MAS PAGOS DEL MES.',;
		   'CORRESPONDIENTE A '+cMes(nMesIniTpa,10)+;
		   IF(CAA->nMesAmnCaA == nMesIniTpa,' CON AMNISTIA',''),;
		   'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aTotCon := {0,0,0}   // Saldo Actual,Deuda y Mora Anterior
       aTotNiv := {0,0,0}   // Saldo Actual,Deuda y Mora Anterior

       aNroCol := {06,12,12,12}
       aTitulo := {'NIVEL ',;
		   'SALDO ANT',;
		   'DEUDA ANT',;
		   'MORA ANT'}

       FOR i := 1 TO LEN(cConcep)/2

	   AADD(aTotCon,0)  // Conceptos Mes
	   AADD(aTotNiv,0)  // Conceptos Mes

	   IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(CON->cNombreCon,1,08))  // Conceptos Mes
	   ELSE
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(cConcep,i*2-1,2))       // Conceptos Mes
	   ENDIF

       ENDFOR

       AADD(aNroCol,12)
       AADD(aTitulo,'+INT PAGOMes')

       AADD(aNroCol,12)
       AADD(aTitulo,'+ANTICIPOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'+INTxCOBMes')

       AADD(aNroCol,12)
       AADD(aTitulo,'+RECARGOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'-DESCUENTOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'-BECAS')

       AADD(aNroCol,12)
       AADD(aTitulo,'FACTURACION')

       AADD(aNroCol,12)
       AADD(aTitulo,'-PAGOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'-ABONOS')

       AADD(aNroCol,12)
       AADD(aTitulo,'SALDO ACTUAL')

       AADD(aNroCol,12)
       AADD(aTitulo,'SALDO PUNTEO')

       AADD(aNroCol,12)
       AADD(aTitulo,'DESCUARE')

       AADD(aTotCon,0)  // Intereses pagados del Mes
       AADD(aTotCon,0)  // Anticipos
       AADD(aTotCon,0)  // Intereses por cobrar del Mes
       AADD(aTotCon,0)  // Recargos
       AADD(aTotCon,0)  // Descuentos
       AADD(aTotCon,0)  // Becas
       AADD(aTotCon,0)  // Facturacion
       AADD(aTotCon,0)  // Pagos
       AADD(aTotCon,0)  // Abonos
       AADD(aTotCon,0)  // Saldo Actual
       AADD(aTotCon,0)  // Saldo Punteo
       AADD(aTotCon,0)  // Descuadre

       AADD(aTotNiv,0)  // Intereses pagados del Mes
       AADD(aTotNiv,0)  // Anticipos
       AADD(aTotNiv,0)  // Intereses por cobrar del Mes
       AADD(aTotNiv,0)  // Recargo
       AADD(aTotNiv,0)  // Descuentos
       AADD(aTotNiv,0)  // Becas
       AADD(aTotNiv,0)  // Facturacion
       AADD(aTotNiv,0)  // Pagos
       AADD(aTotNiv,0)  // Abonos
       AADD(aTotNiv,0)  // Saldo Actual
       AADD(aTotNiv,0)  // Saldo Punteo
       AADD(aTotNiv,0)  // Descuadre

       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Wide
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
	  FilePrn = 'factInco'
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
	    aVlrCon := {0,0,0}            // Saldos Anteriores
	    FOR i := 1 TO LEN(cConcep)/2
		AADD(aVlrCon,0)           // Conceptos Pagos
	    ENDFOR
	    AADD(aVlrCon,0)  // Intereses pagados del Mes
	    AADD(aVlrCon,0)  // Anticipos
	    AADD(aVlrCon,0)  // Intereses por cobrar del Mes
	    AADD(aVlrCon,0)  // Recargo
	    AADD(aVlrCon,0)  // Descuentos
	    AADD(aVlrCon,0)  // Becas
	    AADD(aVlrCon,0)  // Facturacion
	    AADD(aVlrCon,0)  // Pagos
	    AADD(aVlrCon,0)  // Abonos
	    AADD(aVlrCon,0)  // Saldo Actual
	    AADD(aVlrCon,0)  // Saldo Punteo
	    AADD(aVlrCon,0)  // Descuadre
**********FIN INICIALIZACION DE ACUMULADORES

**********CALCULOS PARA EL GRUPO
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('MES : '+cMes(nMesIniTpa)+;
			     'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------INICIALIZACION DE LOS VALORES POR ESTUDIANTE
		  aVlrEst := {}
		  FOR i := 1 TO LEN(aVlrCon)
		      AADD(aVlrEst,0)
		  ENDFOR
*--------------FIN INICIALIZACION DE LOS VALORES POR ESTUDIANTE

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
		 nVlrPag := 0
		 nFacMes := 0
		 IF lHayAlu .AND. lHayPag

*...................ANALISIS SI ES EL MES ACTUAL
		      lMesAct := .T.
		      IF nMesIniTpa < LEN(RTRIM(CLI->cMesPagCli))
			 lMesAct := .F.
		      ENDIF
*...................FIN ANALISIS SI ES EL MES ACTUAL

*...................LOCALIZACION DEL ABONO
		      nVlrAbo := 0
		      nAboOtr := 0
		      nDeuInt := 0
		      nAboDes := 0
		      SELECT DES
		      GO TOP
		      LOCATE FOR DES->cCodigoEst == CLI->cCodigoEst .AND.;
				 DES->nTipDesDes == 3

		      IF DES->(FOUND())

*                        TOTALIZACION DE LOS ABONOS
			   nVlrAbo := nVlrAbo(CLI->cCodigoEst,cAnoUsr,;
					      nMesIniTpa,@nDeuInt,@nAboOtr,;
					      @nAboDes)
			   aVlrEst[LEN(aVlrEst)-3] += nVlrAbo+nAboOtr
*                        FIN TOTALIZACION DE LOS ABONOS

*                        DEUDA ANTERIOR
			   nDeuAnt := PAG->nSdAbonPag
			   nMorAnt := PAG->nMoAbonPag
*                        FIN DEUDA ANTERIOR

		      ELSE

*                        DEUDA ANTERIOR
			   nDeuAnt := PAG->nSdoAntPag
			   nMorAnt := PAG->nMorAntPag
			   IF PAG->nMesAmnPag == PAG->nMesIniPag
			      nDeuInt := nVlrMes()
			   ELSE
			      nDeuInt := PAG->nSdoAntPag+nVlrMes()
			   ENDIF
*                        FIN DEUDA ANTERIOR
		      ENDIF
*...................FIN LOCALIZACION DEL ABONO

*...................SALDO ANTERIOR
		      SELECT PAG
		      aVlrEst[2] := nDeuAnt          // Deuda Anterior
		      aVlrEst[3] := nMorAnt          // Mora Anterior

		      aVlrEst[1] := aVlrEst[2]+aVlrEst[3]    // Saldo Anterior
		      aVlrEst[LEN(aVlrEst)-5] += aVlrEst[1]
		     *Facturaci¢n
*...................FIN SALDO ANTERIOR

*...................BECAS,DESCUENTOS,RECARGOS
		      aVlrEst[LEN(aVlrEst)-8] := PAG->nVlrRecPag+;
						 PAG->nRecGenPag  // Recargos
		      aVlrEst[LEN(aVlrEst)-5] += aVlrEst[LEN(aVlrEst)-8]
		     *Facturaci¢n

		      aVlrEst[LEN(aVlrEst)-7] := PAG->nVlrDesPag+nAboDes+;
						 PAG->nDesGenPag   // Descuentos
		      aVlrEst[LEN(aVlrEst)-5] -= aVlrEst[LEN(aVlrEst)-7]
		     *Facturaci¢n

		      aVlrEst[LEN(aVlrEst)-6] := PAG->nVlrBecPag   // Becas
		      aVlrEst[LEN(aVlrEst)-5] -= PAG->nVlrBecPag
		     *Facturaci¢n
*...................FIN BECAS,DESCUENTOS,RECARGOS

*...................CALCULO PARA CADA UNO DE LOS CONCEPTOS
		      nFacMes := 0
		      FOR i := 1 TO LEN(cConcep)/2

*                         LOCALIZACION DEL VALOR DEL CONCEPTO
			    cCodigoTco := SUBS(cConcep,i*2-1,2)
			    IF cCodigoTco $ PAG->cConcepPag
			       nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
			       nVlrTar := &('nVlrCo'+STR(nNroPos,1)+'Pag')
			    ELSE
			       nVlrTar := 0
			    ENDIF
*                         FIN LOCALIZACION DEL VALOR DEL CONCEPTO

*                         FACTURACION DEL MES PARA CADA CONCEPTO
			    nFacMes  += nVlrTar
			    aVlrEst[i+3] := nVlrTar            // Valor Conceptos
			    aVlrEst[LEN(aVlrEst)-5] += nVlrTar // Facturaci¢n
*                         FIN FACTURACION DEL MES PARA CADA CONCEPTO

*                         TOTALIZACION DEL VALOR PAGADO
			    IF PAG->cEstadoPag == 'P' .OR.;
			       PAG->cEstadoPag == 'A'
			       nVlrPag += nVlrTar
			    ENDIF
*                         FIN TOTALIZACION DEL VALOR PAGADO

		      ENDFOR
*...................FIN CALCULO PARA CADA UNO DE LOS CONCEPTOS

*...................CALCULO DE OTROS PAGOS
		      aVlrEst[LEN(aVlrEst)-4] := PAG->nPagParPag
		     *Pagos parciales

		      DO CASE
		      CASE PAG->cEstadoPag == 'P' .OR.;
			   PAG->cEstadoPag == 'A'

*                          PAGOS DEL MES
			     nVlrPag += PAG->nSdoAntPag+PAG->nMorAntPag
			    *Pagos de Atrasos para calcular anticipos

			     aVlrEst[LEN(aVlrEst)-4] += PAG->nVlrPagPag
			    *Pagos

			     IF PAG->cEstadoPag == 'A'

				nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
						      PAG->nMesIniPag,;
						      CAA->nMesAmnCaA)

				nVlrPag += nVlrInt
			       *Intereses pagados para calcular anticipos

				aVlrEst[LEN(aVlrEst)-11] := nVlrInt
			       *Intereses Pagados

				aVlrEst[LEN(aVlrEst)-5] += nVlrInt
			       *Facturaci¢n

				aVlrEst[LEN(aVlrEst)-4] += nVlrInt
			       *Pagos
			     ENDIF
*                          FIN PAGOS DEL MES

*                          VALOR DE LOS ANTICIPOS
			     IF PAG->nMesIniPag # PAG->nMesFinPag .OR.;
				lHayAntici(nMesIniTpa,PAG->cIniFinPag)

				nMesIni := 0
				nMesIni := 0
				IF PAG->nMesIniPag # PAG->nMesFinPag
				   nMesIni := PAG->nMesIniPag
				   nMesFin := PAG->nMesFinPag
				ELSE
				   cIniFinPag(1,PAG->cIniFinPag,;
					      @nMesIni,@nMesFin)
				ENDIF
				aVlrEst[LEN(aVlrEst)-10] := nFacMes*;
				(nNroMesFac(nMesIni,nMesFin)-1)
			      *ÀAnticipos

				aVlrEst[LEN(aVlrEst)-5] += aVlrEst[LEN(aVlrEst)-10]
			       *Facturaci¢n
			     ENDIF
*                          FIN VALOR DE LOS ANTICIPOS

		      CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

*                          INTERESES POR COBRAR DEL MES
			     IF PAG->cEstadoPag = 'D'
				nVlrInt := nVlrInt(nDeuInt) // Intereses por cobrar del mes
				aVlrEst[LEN(aVlrEst)-9] := nVlrInt
				aVlrEst[LEN(aVlrEst)-5] += nVlrInt  // Facturaci¢n
			     ENDIF
*                          FIN INTERESES POR COBRAR DEL MES

		      ENDCASE
*...................FIN CALCULO DE OTROS PAGOS

		  ELSE

*...................SALDO DEL ESTUDIANTE RETIRADO
		      IF lRetadoTes .AND. CLI->nSdoActCli+CLI->nSdoMorCli # 0

			 aVlrEst[2] := CLI->nSdoActCli  // Deuda Anterior
			 aVlrEst[3] := CLI->nSdoMorCli  // Mora Anterior

			 aVlrEst[1] := aVlrEst[2]+aVlrEst[3]    // Saldo Anterior
			 aVlrEst[LEN(aVlrEst)-5] += aVlrEst[1]
			*Facturaci¢n

		      ENDIF
*...................FIN SALDO DEL ESTUDIANTE RETIRADO

		 ENDIF
*--------------FIN CALCULO DE LOS INTERESES ACUMULACION DE PAGOS POR CONCEPTO

*--------------SALDO ACTUAL
		 aVlrEst[LEN(aVlrEst)-2] := aVlrEst[LEN(aVlrEst)-5]-;
					    aVlrEst[LEN(aVlrEst)-4]-;
					    aVlrEst[LEN(aVlrEst)-3]
		*ÀSaldo Actual = Facturaci¢n-Pagos-Abonos
*--------------FIN SALDO ACTUAL

*--------------SALDO DEL PUNTEO Y VERIFICACION DE CUADRE
		 aVlrEst[LEN(aVlrEst)-1] := nSdoAct(nMesIniTpa,lRetadoTes)

		 aVlrEst[LEN(aVlrEst)] := aVlrEst[LEN(aVlrEst)-2]-;
					  aVlrEst[LEN(aVlrEst)-1]
*--------------SALDO DEL PUNTEO Y VERIFICACION DE CUADRE

*--------------ACUMULACION POR GRUPO
		 FOR i := 1 TO LEN(aVlrEst)
		     aVlrCon[i] += aVlrEst[i]
		 ENDFOR
*--------------FIN ACUMULACION POR GRUPO


*--------------IMPRESION DEL CONTENIDO DEL INFORME
		 IF lValida

		    IF lPorGru .OR. (!lPorGru .AND. aVlrEst[LEN(aVlrEst)] # 0)

		       aTitulo := {}
		       AADD(aTitulo,GRU->cCodigoGru)

		       FOR i := 1 TO LEN(aVlrEst)
			   AADD(aTitulo,TRANS(aVlrEst[i],"####,###,###"))
		       ENDFOR

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       lPrnReg(01,00,cTxtPrn+'->'+CLI->cCodigoEst+'-'+;
			       STR(CLI->(RECNO()),2,0),;
			       bPagina,bDerAut,bCabeza)
		    ENDIF
		 ENDIF
*--------------FIN IMPRESION DEL CONTENIDO DEL INFORME

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 SELECT CLI
		 CLI->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN CALCULOS PARA EL GRUPO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF !lValida
	       aTitulo := {}
	       AADD(aTitulo,GRU->cCodigoGru)
	       FOR i := 1 TO LEN(aVlrCon)
		   AADD(aTitulo,TRANS(aVlrCon[i],"####,###,###"))
	       ENDFOR
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
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

**********ACUMULACION POR GRUPO Y TOTAL
	    FOR i := 1 TO LEN(aVlrCon)
		aTotNiv[i] += aVlrCon[i]
		aTotCon[i] += aVlrCon[i]
	    ENDFOR
**********FIN ACUMULACION POR GRUPO Y TOTAL

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF !lValida .AND. cNivAnt # cNivAct

	       @ PROW()+1,00 SAY ''
	       FOR i := 1 TO LEN(aTotNiv)
		   @ PROW(),nColTxt(aNroCol,i+1) SAY REPL('-',aNroCol[i+1])
	       ENDFOR

	       aTitulo := {}
	       AADD(aTitulo,cNivAnt)
	       FOR i := 1 TO LEN(aTotNiv)
		   AADD(aTitulo,TRANS(aTotNiv[i],"####,###,###"))
	       ENDFOR
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
	       @ PROW()+1,00 SAY ''

	       FOR i := 1 TO LEN(aTotNiv)
		   aTotNiv[i] := 0
	       ENDFOR
	     *ÀInicializaci¢n de los totales de nivel

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
	   @ PROW(),nColTxt(aNroCol,i+1) SAY REPL('=',aNroCol[i+1])
       ENDFOR

       IF !lValida
	  aTitulo := {}
	  AADD(aTitulo,'TOTAL')
	  FOR i := 1 TO LEN(aTotCon)
	      AADD(aTitulo,TRANS(aTotCon[i],"####,###,###"))
	  ENDFOR
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF
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


FUNCTION lHayPagAnt(cCodEst,nMesAnt,nDeuAnt,nMorAnt)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodEst                              // C¢digo del Estudiante
       nMesAnt                              // Mes Anterior
       nDeuAnt			            // @Deuda Anterior
       nMorAnt                              // @Mora Anterior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrInt := 0                   // Valor Intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DEL SALDO ANTERIOR
       nRegAct := PAG->(RECNO())
       IF lLocCodPag(cCodEst,nMesAnt,.F.)

**********CALCULO DE LOS INTERESES
	    lHayPag := .T.
	    nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
				  PAG->nMesIniPag,;
				  CAA->nMesAmnCaA)
**********FIN CALCULO DE LOS INTERESES

**********ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO
	    DO CASE
	    CASE PAG->cEstadoPag == 'P' .OR. PAG->cEstadoPag == 'A'

		 IF CAA->nMesAmnCaA == PAG->nMesIniPag
		    nDeuAnt := PAG->nSdoAntPag
		    nMorAnt := PAG->nMorAntPag
		 ELSE
		    nDeuAnt := 0
		    nMorAnt := 0
		 ENDIF
	       *ÀActualizaci¢n del saldo

	    CASE PAG->cEstadoPag == 'D'

		 IF CAA->nMesAmnCaA == PAG->nMesIniPag
		    nDeuAnt := PAG->nSdoAntPag+PAG->nVlrPagPag
		    nMorAnt := PAG->nMorAntPag+nVlrInt
		 ELSE
		    IF PAG->nMesIniPag == PAG->nMesFinPag
		       nDeuAnt := PAG->nVlrPagPag-PAG->nMorAntPag
		    ELSE
		       nDeuAnt := PAG->nSdoAntPag+PAG->nVlrMesPag
		    ENDIF
                    nMorAnt := PAG->nMorAntPag+nVlrInt
		 ENDIF
		*Actualizaci¢n del saldo

	    CASE PAG->cEstadoPag = '*'
		 // Error
	    ENDCASE
**********FIN ACTUALIZACION DE SALDO DE ACUERDO A LA FORMA DE PAGO

       ENDIF
       SELECT PAG
       GO nRegAct
       RETURN lHayPag
*>>>>FIN CALCULO DEL SALDO ANTERIOR

FUNCTION nSdoAct(nMesIni,lRetEst)

*>>>>PARAMETROS DE LA FUNCION
/*     nMesIni                              // Mes Inicial de Pago
       lRetEst                              // .T. Estudiante Retirado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nDeuAct := 0                   // Deuda Actual
       LOCAL nMorAct := 0                   // Mora Actual
       LOCAL lMesAct := .F.                 // Mes Actual
       LOCAL nVlrInt := 0                   // Valor de los Intereres
       LOCAL nVlrPag := 0                   // Valor Pagado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS SI ES EL MES ACTUAL
       lMesAct := .T.
       IF nMesIni < LEN(RTRIM(CLI->cMesPagCli))
	  lMesAct := .F.
       ENDIF
*>>>>FIN ANALISIS SI ES EL MES ACTUAL

*>>>>ANALISIS SI ESTUDIANTE ESTA RETIRADO
       IF lRetEst .AND. lMesAct
	  nDeuAct := CLI->nSdoActCli
	  nMorAct := CLI->nSdoMorCli
	  RETURN nDeuAct+nMorAct
       ENDIF
*>>>>FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*>>>>CALCULO DE LOS INTERESES
       nVlrInt := nVlrIntPag(PAG->lIntPenPag,;
			     PAG->nMesIniPag,;
			     PAG->nMesAmnPag)
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DE LA FORMA DE PAGO
       DO CASE
       CASE PAG->cEstadoPag == 'P' .OR.;
	    PAG->cEstadoPag == 'A'

	    nDeuAct := 0
	    nMorAct := 0

	    IF PAG->nMesAmnPag == nMesIni
	       nDeuAct := IF(lMesAct,CLI->nSdoActCli,PAG->nSdoAntPag)
	       nMorAct := IF(lMesAct,CLI->nSdoMorCli,PAG->nMorAntPag)
	    ENDIF

       CASE PAG->cEstadoPag == 'D' .OR. PAG->cEstadoPag = '*'

	    IF PAG->cEstadoPag = 'D'

	       IF PAG->nMesIniPag == PAG->nMesFinPag
		  nVlrPag := PAG->nVlrPagPag
	       ELSE
		  nVlrPag := PAG->nSdoAntPag+PAG->nMorAntPag+;
			     PAG->nVlrMesPag
	       ENDIF

	       IF PAG->nMesAmnPag # nMesIni
		  nDeuAct := nVlrPag
		  nMorAct := nVlrInt
	       ELSE
		  nDeuAct := IF(lMesAct,CLI->nSdoActCli,PAG->nSdoAntPag)
		  nMorAct := IF(lMesAct,CLI->nSdoMorCli,PAG->nMorAntPag)
	       ENDIF

	    ELSE
	       nDeuAct := IF(lMesAct,CLI->nSdoActCli,PAG->nSdoAntPag)
	       nMorAct := IF(lMesAct,CLI->nSdoMorCli,PAG->nMorAntPag)
	    ENDIF

       ENDCASE
       RETURN nDeuAct+nMorAct
*>>>>FIN ANALISIS DE LA FORMA DE PAGO