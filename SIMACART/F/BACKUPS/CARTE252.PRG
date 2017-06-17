/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: ALUMNOS PAGOS ANTICIPADOS                MODULO No. 252

**************************************************************************
* TITULO..: ALUMNOS PAGOS ANTICIPADOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 20/2000 VIE A
       Bucaramanga, Colombia	    INICIO: 02:20 PM   OCT 20/2000 VIE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite imprimir los estudiantes que realizaron los pagos por anticipados.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_252(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

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
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL cConcep := ''                  // Conceptos
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nVlrInt := 0                   // Valor de los Intereses
       LOCAL nTotPag := 0                   // Total pagos
       LOCAL nPagTot := 0                   // Pago Total
       LOCAL nNroTot := 0                   // N£mero de pagos totales
       LOCAL nNroEst := 0                   // N£mero de pagos anticipos
       LOCAL aConFac[8]                     // Conceptos Facturados. 8 Conceptos
       LOCAL aAntEst[8]		            // Anticipos del Estudiantes. 8 Conceptos
       LOCAL aTotAnt[16]                     // Total Anticipos. 8 Conceptos
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .F.              // .T. Estudiante Retirado
       LOCAL nMesIniTpa := 0                // Mes inicial del pago
       LOCAL cEstadoTpa := ''               // Estado del Pago
     *ÀVariables temporales de Campos
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
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lSiRed,cIntUno,cMaeAlu,cAnoSis)             .OR.;
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

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')

       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONCEPTOS GRABADOS')

       CASE TAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN TARIFAS CREADAS')

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
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := GRU->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'ESTUDIANTES CON PAGOS POR ANTICIPADOS',;
		   'FACTURADOS EN LOS RECIBOS DE '+cMes(nMesIniTpa,10),;
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
       aNroCol := {04,08,06,40,10,12}
       aTitulo := {'No','CURSO ',;
		   'CODIGO',;
		   'NOMBRE DEL ESTUDIANTE',;
		   'MESES',;
		   'ESTADO'}

       FOR i := 1 TO LEN(cConcep)/2

	   IF lLocCodigo('cCodigoCon','CON',SUBS(cConcep,i*2-1,2))
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(CON->cNombreCon,1,12))  // Conceptos Mes
	   ELSE
	      AADD(aNroCol,12)                          // Conceptos Mes
	      AADD(aTitulo,SUBS(cConcep,i*2-1,2))       // Conceptos Mes
	   ENDIF

       ENDFOR

       AADD(aNroCol,12)
       AADD(aTitulo,'TOTALES')
       AADD(aNroCol,12)
       AADD(aTitulo,'PAGOS')
       AADD(aNroCol,20)
       AADD(aTitulo,'OBSERVACION')

       cCabCol := cRegPrint(aTitulo,aNroCol)
       aCamXml := aTitulo
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
       AFILL(aTotAnt,0)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn = 'Antip'+cMes(nMesIniTpa,3)
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
		 LineaEstado('MES : '+cMes(nMesIniTpa)+;
			     'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		 lRetadoTes := .F.
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,;
				       cMaeAlu,@cMaeAct,.F.)
		 IF lHayAlu
		    cCodigoTes := &cMaeAct->cCodigoEst
		    IF &cMaeAct->lRetiroEst
		       lRetadoTes := .T.
		    ENDIF
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  &cMaeAct->cNombreEst
		    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		 ENDIF
*--------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------LOCALIZACION DEL PAGO
		 lHayPag := .F.
		 IF lHayAlu
		    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)
		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO

*--------------ANALISIS DEL ESTADO DE PAGO
		 DO CASE
		 CASE PAG->cEstadoPag = 'P'
		      cEstadoTpa := 'PAGO OPO'
		      cEstadoTpa := 'O:'+DTOC(PAG->dFecPagPag)

		 CASE PAG->cEstadoPag = 'A'
		      cEstadoTpa := 'PAGO EXT'
		      cEstadoTpa := 'E:'+DTOC(PAG->dFecPagPag)

		 CASE PAG->cEstadoPag = 'D'
		      cEstadoTpa := 'NO PAGO '

		 CASE PAG->cEstadoPag = '*'
		      cEstadoTpa = 'DEUDOR  '
		 OTHERWISE
		      cEstadoTpa = 'ERROR   '
		 ENDCASE
*--------------FIN ANALISIS DEL ESTADO DE PAGO

*--------------CALCULO DE LOS DIFERENTES PAGOS
		 nVlrInt := 0
		 AFILL(aConFac,0)
		 IF lHayAlu .AND. lHayPag

*...................ANALISIS DE LOS ANTICIPOS
		      IF PAG->nMesIniPag # PAG->nMesFinPag .OR.;
			 lHayAntici(nMesIniTpa,PAG->cIniFinPag)

			 nNroEst++

*                        IMPRESION DEL CONTENIDO DEL INFORME
			   aTitulo := {}

			   AADD(aTitulo,STR(nNroEst,4))
			   AADD(aTitulo,GRU->cCodigoGru+'-'+;
					STR(CLI->(RECNO()),2))
			   AADD(aTitulo,CLI->cCodigoEst)
			   AADD(aTitulo,cNombreTes)
			   AADD(aTitulo,cMes(PAG->nMesIniPag,3)+'/'+;
					cMes(PAG->nMesFinPag,3)+':'+;
					STR(nNroMesFac(PAG->nMesIniPag,;
						       PAG->nMesFinPag)-1,2))
			   AADD(aTitulo,cEstadoTpa)
*                        FIN IMPRESION DEL CONTENIDO DEL INFORME

*                        PAGO TOTAL
			   IF PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A'

			      IF PAG->cEstadoPag == 'A'
				 nVlrInt := nVlrIntPag(CAA->lIntPenCaA,;
						       PAG->nMesIniPag,;
						       CAA->nMesAmnCaA)
			      ELSE
				 nVlrInt := 0
			      ENDIF

			      nTotPag += PAG->nVlrPagPag+nVlrInt
			      IF PAG->nMesFinPag == CAA->nMesFinCaA
				 nPagTot += PAG->nVlrPagPag+nVlrInt
				 ++nNroTot
			      ENDIF
			   ENDIF
*                        FIN PAGO TOTAL

*                        CALCULO DE LOS ANTICIPOS
			   IF PAG->cEstadoPag == 'P' .OR.;
			      PAG->cEstadoPag == 'A'

			      aConFac := aConFactu(cConcep)

			      IF CAA->nMtdFacCaA == 2 // Tabla de Tarifas por meses

				 aAntEst := AnticiVar(GRU->cCodigoGru,;
						      aConFac,;
						      PAG->nMesIniPag+1,;
						      PAG->nMesFinPag,;
						      aTotAnt,;
						      PAG->cIniFinPag,;
						      PAG->cConcepPag,;
						      cConcep)

			      ELSE

				aAntEst := Anticipos(aConFac,;
					    (nNroMesFac(PAG->nMesIniPag,;
							PAG->nMesFinPag)-1),;
					     aTotAnt,;
					     PAG->cIniFinPag,;
					     PAG->cConcepPag,;
					     cConcep)
			      ENDIF

			      FOR i := 1 TO LEN(cConcep)/2
				AADD(aTitulo,TRANS(aAntEst[i],"####,###,###"))
			      ENDFOR
			      AADD(aTitulo,TRANS(nSuma(aAntEst),"####,###,###"))
			      AADD(aTitulo,TRANS(PAG->nVlrPagPag+nVlrInt,"####,###,###"))
			      AADD(aNroCol,12)

			      IF CLI->nBecIniCli # 0 .AND.;
				 CLI->nBecFinCli # 0
				 AADD(aTitulo,'.'+SPACE(19))
			      ELSE
				 AADD(aTitulo,'')
			      ENDIF
			   ENDIF

			   cTxtPrn := cRegPrint(aTitulo,aNroCol)
			   lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

			   AADD(aTitulo,'') // Campo Url
			   AADD(aRegPrn,aTitulo)
*                        FIN CALCULO DE LOS ANTICIPOS

		      ENDIF
*...................FIN ANALISIS DE LOS ANTICIPOS

		 ENDIF
*--------------CALCULO DE LOS DIFERENTES PAGOS

*--------------AVANCE DEL SIGUIENTE REGISTRO
		 SET DEVICE TO SCREEN
		 Avance(CLI->(RECNO()),CLI->(RECCOUNT()))
		 SET DEVICE TO PRINT

		 SELECT CLI
		 CLI->(DBSKIP())
*--------------FIN AVANCE DEL SIGUIENTE REGISTRO

	    ENDDO
**********FIN IMPRESION DE LOS GRUPOS

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
       @ PROW()+1,00 SAY ''
       aTitulo := {'','','','',''}
       FOR i := 1 TO (LEN(cConcep)/2)+1
	   @ PROW(),nColTxt(aNroCol,i+6) SAY REPL('=',aNroCol[i+6])

	   aTitulo[3] := REPL('*',40)
	   aTitulo[4] := REPL('*',12)
	   aTitulo[5] := REPL('*',12)
	   AADD(aTitulo,REPL('=',aNroCol[i+6]))
       ENDFOR
       AADD(aTitulo,'')
       AADD(aRegPrn,aTitulo)

       @ PROW()+1,00 SAY ''
       aTitulo := {'','','','',''}
       FOR i := 1 TO (LEN(cConcep)/2)
	   @ PROW(),nColTxt(aNroCol,i+6) SAY TRANS(aTotAnt[i],"####,###,###")
	   AADD(aTitulo,TRANS(aTotAnt[i],"####,###,###"))
       ENDFOR
       @ PROW(),nColTxt(aNroCol,i+6) SAY TRANS(nSuma(aTotAnt),"####,###,###")
       @ PROW(),nColTxt(aNroCol,i+7) SAY TRANS(nTotPag,"####,###,###")

       AADD(aTitulo,TRANS(nSuma(aTotAnt),"####,###,###"))
       AADD(aTitulo,'')
       AADD(aRegPrn,aTitulo)
       @ PROW()+1,00 SAY 'TOTAL PAGO A '+cMes(CAA->nMesFinCaA)+' '+;
			 TRANS(nPagTot,"####,###,###")+' '+;
			 'ESTUDIANTES='+ALLTRIM(STR(nNroTot,4))

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
*>>>>FIN IMPRESION DERECHOS

*>>>>EXPORTACION DEL ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{PAGOS}{INFORMES FACTURACION}{ALUMNOS PAGOS ANTICIPADOS}')
      *Nombre del Sistema

       AADD(aCabXml,'ESTUDIANTES CON PAGOS POR ANTICIPADOS')
      *Titulo No. 1

       AADD(aCabXml,'FACTURADOS EN LOS RECIBOS DE '+cMes(nMesIniTpa,10))
      *Titulo No. 2

       AADD(aCabXml,'JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr)
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       FileXml(PathW01+'\'+'FACT'+cMes(nMesIniTpa,3)+'\'+;
	       'ANT'+cMes(nMesIniTpa,3)+cAnoSis+'.XML',;
	       aRegPrn,aCamXml,aCabXml)
     *ÀCreaci¢n del Archivo

       RETURN NIL
*>>>>FIN EXPORTACION DEL ARCHIVO

/*************************************************************************
* TITULO..: FACTURACION POR CONCEPTOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 23/2000 LUN A
       Bucaramanga, Colombia	    INICIO: 05:30 PM   OCT 23/2000 LUN

OBJETIVOS:

1)- Permite descriminar los conceptos facturados

2)- Retorna el valor de los conceptos facturados descriminados.

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aConFactu(cConcep)

*>>>>DESCRIPCION DE PARAMETROS
/*     cConcep                              // Conceptos facturados */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroPos := 0                   // N£mero de la posici¢n del Concepto
       LOCAL nVlrTar := 0                   // Valor del Concepto facturado
       LOCAL aConFac[16]		    // Facturaci¢n del Mes

       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS CONCEPTOS FACTURADOS
       AFILL(aConFac,0)
       FOR i := 1 TO LEN(cConcep)/2

***********LOCALIZACION DEL VALOR DEL CONCEPTO
	     cCodigoTco := SUBS(cConcep,i*2-1,2)
	     IF cCodigoTco $ PAG->cConcepPag
		nNroPos := (AT(cCodigoTco,PAG->cConcepPag)+1)/2
		nVlrTar := &('nVlrCo'+STR(nNroPos,1)+'Pag')
	     ELSE
		nVlrTar := 0
	     ENDIF
             aConFac[i] := nVlrTar
***********FIN LOCALIZACION DEL VALOR DEL CONCEPTO

       ENDFOR
       RETURN aConFac
*>>>>FIN CALCULO DE LOS CONCEPTOS FACTURADOS
