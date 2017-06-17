/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INCONSISTENCIAS.
SUBMODULO...: SALDOS ANTERIORES                        MODULO No. 262

**************************************************************************
* TITULO..: SALDOS ANTERIORES                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 07/2006 VIE A
       Bucaramanga, Colombia	    INICIO: 12:00 AM   SEP 07/2006 VIE

OBJETIVOS:

1- Permite imprimir los saldos anteriores que figuran en la facturaci¢n
   del mes para facilitar los procesos de conciliaci¢n.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_262(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contador

       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
       LOCAL oBrowse := NIL                 // Browse del Archivo

       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
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

       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo Final
       LOCAL nRegPag := 0                   // Registro de pagos

       LOCAL lPorGru := .T.                 // .T. Por Grupos
       LOCAL cGruAnt := ''                  // Grupo Anterior
       LOCAL cGruAct := ''                  // Grupo Actual
       LOCAL nTotGru := 0                   // Total por Grupo
       LOCAL nTotSdo := 0                   // Total Saldo Actual

       LOCAL cNalias := ''                  // Alias del Maestro
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL nMesRet := 0                   // Mes del ultimo recibo

       LOCAL nDeuAnt := 0                   // Deuda Anterior
       LOCAL nMorAnt := 0                   // Mora Anterior
       LOCAL nAboAnt := 0                   // Abonos del Estudiante
       LOCAL nAboMes := 0                   // Abonos del Estudiante
       LOCAL nAboOtr := 0                   // Abonos otros Meses


       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
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
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
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

	   IF !lUseGru(lShared,PathUno+'\'+cPatSis,cMaeAct,cAnoSis)
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
       cNroMes := STR(nMesIniTpa,2)
       lCorrecion(@cNroMes)
*>>>>FIN CAPTURA DEL MES A PAGAR

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileTar,'TAR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,PathUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
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
       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

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

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       lPorGru := lPregunta('DESEA EL INFORME POR GRUPOS? Si No')
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 1
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<PAGOS><INCONSISTENCIAS><SALDOS ANTERIORES>'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aMezIso,{'<nMesIni>',cMes(nMesIniTpa)})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'PROCESO DE CONCILIACION')          // T¡tulo Dos
       AADD(aTitIso,'RELACION DE SALDOS ANTERIORES MES DE <nMesIni>') // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

*       cPiePag := ALLTRIM(SCO->cPiePagCon)
       cPiePag := ''
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())

       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'SdoAnt'+ALLTRIM(STR(nMesIniTpa,2))
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.T.,.T.,bInsIso,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       SET DEVICE TO SCREEN
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       IF lPorGru
	  AADD(aNroCol,06)
	  AADD(aTitPrn,'GRUPO')
       ELSE
	  AADD(aNroCol,06)
	  AADD(aTitPrn,'CODIGO')
       ENDIF

       IF !lPorGru
	  AADD(aNroCol,8)
	  AADD(aTitPrn,'CURSO')

	  AADD(aNroCol,28)
	  AADD(aTitPrn,'APELLIDOS Y NOMBRES')
       ENDIF

       AADD(aNroCol,14)
       AADD(aTitPrn,'SALDO ANTERIOR')

       IF !lPorGru

	  AADD(aNroCol,14)
	  AADD(aTitPrn,'SALDO NO ABONO')

	  AADD(aNroCol,14)
	  AADD(aTitPrn,'DEUDA ANTERIOR')

	  AADD(aNroCol,14)
	  AADD(aTitPrn,'MORA ANTERIOR')

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'ABONOS '+cMes(nMesIniTpa,3))

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'ABOOTR '+cMes(nMesIniTpa,3))

	  AADD(aNroCol,12)
	  AADD(aTitPrn,'ABONOS '+cMes(nMesIniTpa-1,3))
       ENDIF

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPie)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES
       SELECT DES
       SET FILTER TO DES->nNroMesDes == nMesIniTpa .OR.;
		     DES->nMesModDes == nMesIniTpa
       DES->(DBGOTOP())
       IF DES->(EOF())
	  SET FILTER TO
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DE DESCUENTOS PARA EL MES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU

       GO nRegFin
       cGruFin = GRU->cCodigoGru
       GO nRegIni
       cGruAnt := GRU->cCodigoGru
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

**********RECORRIDO POR CLIENTES
	    SELECT CLI
	    CLI->(DBGOTOP())
	    DO WHILE .NOT. CLI->(EOF())

*==============INICIALIZACION DE ACUMULADORES
		 aRegPrn := {}
		 nDeuAnt := 0
		 nMorAnt := 0
		 nAboAnt := 0
		 nAboMes := 0
		 nAboOtr := 0
*==============FIN INICIALIZACION DE ACUMULADORES

*==============IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('MES : '+cMes(nMesIniTpa)+;
			     'ºGRUPO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºNo. '+STR(CLI->(RECNO()),2)+'/'+;
				     STR(CLI->(RECCOUNT()),2),cNomSis)
*==============FIN IMPRESION DE LA LINEA DE ESTADO

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
		    cNombreTes := SUBS(cNombreTes+SPACE(28),1,28)
		 ENDIF
*==============FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*==============LOCALIZACION DEL PAGO
		 lHayPag := .F.
		 IF lHayAlu
		    lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIniTpa,.F.)
		 ENDIF
*==============FIN LOCALIZACION DEL PAGO

*==============CALCULO DE LOS DIFERENTES PAGOS
		 IF lHayAlu .AND. lHayPag

*-------------------FILTRACION DEL ARCHIVO
		      SELECT DES
		      SET FILTER TO DES->cCodigoEst == CLI->cCodigoEst .AND.;
				    DES->nTipDesDes == 3 .AND.;
				  ((DES->nNroMesDes == nMesIniTpa-1 .AND.;
				    DES->nMesModDes == nMesIniTpa)  .OR.;
				   (DES->nNroMesDes == nMesIniTpa   .AND.;
				    DES->nMesModDes == nMesIniTpa-1) .OR.;
				   (DES->nNroMesDes == nMesIniTpa+1 .AND.;
				    DES->nMesModDes == nMesIniTpa))

		      DES->(DBGOTOP())
		      IF DES->(EOF())
			 SET FILTER TO
		      ENDIF
*-------------------FIN FILTRACION DEL ARCHIVO

*-------------------LOCALIZACION DE LOS ABONOS
		      nRegPag := PAG->(RECNO())
		      SELECT DES
		      IF !DES->(EOF())

*::::::::::::::::::::::::DEUDA ANTERIOR
			   PAG->(DBGOTO(nRegPag))
			   IF PAG->nSdAbonPag+PAG->nMoAbonPag # 0
			      nDeuAnt := PAG->nSdAbonPag
			      nMorAnt := PAG->nMoAbonPag
			   ENDIF
*::::::::::::::::::::::::FIN DEUDA ANTERIOR

*::::::::::::::::::::::::RECORRIDO DE LOS ABONOS
			   DO WHILE .NOT. DES->(EOF())

*.............................LOCALIZACION DEL PAGO
				IF lLocCodPag(CLI->cCodigoEst,DES->nNroMesDes,.F.)
				   DO CASE
				   CASE PAG->nMesIniPag == nMesIniTpa-1

					IF DES->dFechaDes > PAG->dPagExtPag
					   nAboAnt += DES->nValorDes
					ENDIF

				   CASE PAG->nMesIniPag == nMesIniTpa
					IF DES->dFechaDes > PAG->dPagExtPag
					   nAboOtr += DES->nAboOtrDes
					ELSE
					   nAboMes += DES->nValorDes
					ENDIF

				   CASE PAG->nMesIniPag == nMesIniTpa+1

					IF DES->dFechaDes <= PAG->dPagExtPag
*					   nDeuAnt := DES->nSdoAntDes
*					   nMorAnt := DES->nMorAntDes
					ENDIF

				   ENDCASE
				ENDIF
*.............................FIN LOCALIZACION DEL PAGO

			      DES->(DBSKIP())

			   ENDDO
			   PAG->(DBGOTO(nRegPag))
*::::::::::::::::::::::::FIN RECORRIDO DE LOS ABONOS

		      ELSE

*::::::::::::::::::::::::DEUDA ANTERIOR
			   PAG->(DBGOTO(nRegPag))
			   IF PAG->nSdoAntPag+PAG->nMorAntPag # 0
			      nDeuAnt := PAG->nSdoAntPag
			      nMorAnt := PAG->nMorAntPag
			   ENDIF
*::::::::::::::::::::::::FIN DEUDA ANTERIOR

		      ENDIF
*-------------------FIN LOCALIZACION DE LOS ABONOS

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
			    nDeuAnt := CLI->nSdoActCli
			    nMorAnt := CLI->nSdoMorCli
			 ENDIF
*::::::::::::::::::::::::FIN SALDO ANTERIOR

		      ENDIF
*-------------------FIN ESTUDIANTE RETIRADO CON SALDO

		 ENDIF
*==============FIN CALCULO DE LOS DIFERENTES PAGOS

*==============REGISTRO DE IMPRESION
		 IF nDeuAnt+nMorAnt # 0

		    nTotGru += nDeuAnt+nMorAnt-nAboMes-nAboOtr-nAboAnt
		    nTotSdo += nDeuAnt+nMorAnt-nAboMes-nAboOtr-nAboAnt

		    IF !lPorGru
		       aRegPrn := {}
		       AADD(aRegPrn,CLI->cCodigoEst)
		       AADD(aRegPrn,&cNalias->cCodigoGru+'-'+;
				    STR(CLI->(RECNO()),2,0))
		       AADD(aRegPrn,cNombreTes)
		       AADD(aRegPrn,STR(nDeuAnt+nMorAnt-;
						nAboMes-nAboOtr-;
						nAboAnt,14,0))
		       AADD(aRegPrn,STR(nDeuAnt+nMorAnt,14,0))
		       AADD(aRegPrn,STR(nDeuAnt,14,0))
		       AADD(aRegPrn,STR(nMorAnt,14,0))
		       AADD(aRegPrn,STR(nAboMes,12,0))
		       AADD(aRegPrn,STR(nAboOtr,12,0))
		       AADD(aRegPrn,STR(nAboAnt,12,0))
		    ENDIF

		 ENDIF
*==============FIN REGISTRO DE IMPRESION

*==============IMPRESION DEL REGISTRO
		 IF LEN(aRegPrn) # 0
		    SET DEVICE TO PRINT
		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
		    SET DEVICE TO SCREEN
		 ENDIF
*==============FIN IMPRESION DEL REGISTRO

	       SELECT CLI
	       CLI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR CLIENTES

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    GRU->(DBSKIP())

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
	    CloseDbf('CLI',FileCli,nModCry)
	    CloseDbf('PAG',FilePag,nModCry)
**********FIN AVANCE DEL SIGUIENTE GRUPO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cGruAct := GRU->cCodigoGru
	    IF cGruAnt # cGruAct

	       aRegPrn := {}
	       AADD(aRegPrn,cGruAnt)
	       AADD(aRegPrn,STR(nTotGru,14,0))

	       SET DEVICE TO PRINT
	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	       SET DEVICE TO SCREEN

	       cGruAnt := cGruAct
	       nTotGru := 0

	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>IMPRESION TOTAL DEL SALDO ACTUAL
       IF lPorGru .AND. nTotSdo # 0

	  aRegPrn := {}
	  AADD(aRegPrn,'')
	  AADD(aRegPrn,REPL('=',14))

	  SET DEVICE TO PRINT
	  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	  SET DEVICE TO SCREEN

	  aRegPrn := {}
	  AADD(aRegPrn,'TOTAL')
	  AADD(aRegPrn,STR(nTotSdo,14,0))

	  SET DEVICE TO PRINT
	  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
	  SET DEVICE TO SCREEN

       ENDIF
*>>>>FIN IMPRESION TOTAL DEL SALDO ACTUAL

*>>>>IMPRESION DERECHOS
       SET DEVICE TO PRINT
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS