/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS - INFORMES FACTURACION
SUBMODULO...: FACTURACION TOTAL POR FAMILIA

**************************************************************************
* TITULO..: FACTURACION TOTAL POR FAMILIA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2004 SAB A
       Bucaramanga, Colombia	    INICIO: 07:00 PM   MAY 16/2004 SAB

OBJETIVOS:

1- Permite imprimir el total de la facturaci¢n por familia de acuerdo
   a un tope.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_258(aParam1,aParam2,aParam3)

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
       LOCAL nTipInf := 0                   // Tipo de Informe
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas
       LOCAL dFecPrn := CTOD('00/00/00')    // Fecha de Corte de Impresi¢n
       LOCAL nTotFac := 0                   // Total Facturacion
       LOCAL nTotPag := 0                   // Total Pagos
       LOCAL nTotSdo := 0                   // Total Saldos
       LOCAL cErrFac := ''                  // Hay Error en la Facturaci¢n
       LOCAL lSiPaso := .F.                 // Control de Flujo
       LOCAL nVlrTop := 0                   // Valor del Tope
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodEstTfa := ''               // C¢digos de Estudiantes
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

*>>>>AREAS DE TRABAJO
       FileTem := 'fFacFam.dbf'
       CreaFacFam(lShared,nModCry,'printer',FileTem)

       aUseDbf := {}
       AADD(aUseDbf,{.T.,cIntDos+'\'+FileTar,'TMT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cIntUno+'\'+FileFam,'FAM',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FSimCar,'CAR',NIL,lSiRed,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+FileDes,'DES',;
			 cPatSis+'\'+fNtxDes,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,'printer\'+FileTem,'TEM',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE FAM->(RECCOUNT()) == 0
	    cError('NO EXISTEN FAMILIAS CREADAS')

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

*>>>>LECTURA DEL TOPE DE LA FACTURACION
       nVlrTop := 0
       @ nFilInf+1,nColInf SAY 'VALOR $' GET nVlrTop;
				       PICT "99999999";
				       VALID nVlrTop > 0 .AND. HelpRead();
       WHEN  {||HelpRead('FAVOR INGRESE EL VALOR TOPE MAYOR A CERO')}
       READ
*>>>>FIN LECTURA DEL TOPE DE LA FACTURACION

*>>>>LECTURA DEL TIPO DE INFORME
       nTipInf := nLeeOpcion('OPCION: '+;
			     '1<SALDO ACTUAL> '+;
			     '2<SALDO FIN DE MES> '+;
			     '3<POR FECHA> 4<ABANDONAR>?',4,'0')

       IF nTipInf == 4
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL TIPO DE INFORME

*>>>>LECTURA DE LA FECHA DE CORTE
       dFecPrn := CTOD('00/00/00')
       IF nTipInf == 3

	  lPrnFec := .T.
	  cSavPan := SAVESCREEN(0,0,24,79)
	  @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	  @ nFilInf+1,nColInf SAY '  FECHA DE CORTE:' GET dFecPrn PICT '@D'
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

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   'A¥O: '+cAnoUsr+' JORNADA: '+cJorTxt,;
		   'FACTURACION TOTAL FAMILIAR. TOPE '+;
		   TRANS(nVlrTop,"$###,###,###")}
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
       aNroCol := {30,12,12,12,60}
       aTitPrn := {'FAMILIA','FACTURACION','PAGOS','SALDO','ESTUDIANTES'}
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
	  FilePrn := 'ftotfam'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.F.)
	  IF EMPTY(nOpcPrn)
	     CloseAll(aUseDbf)
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

*>>>>RECORRIDO DE LAS FAMILIAS
       SELECT FAM
       FAM->(DBGOTOP())
       DO WHILE .NOT. FAM->(EOF())

**********CALCULO DE LA FACTURACION FAMILIAR
	    cMaeAct := ''
	    nTotFac := 0
	    nTotPag := 0
	    nTotSdo := 0

	    SET DEVICE TO SCREEN
	    cErrFac := cFactFam(lShared,nModCry,cNomSis,cAnoUsr,cPatSis,;
				cMaeAlu,FAM->cCodEstFam,nTipInf,dFecPrn,;
				@cMaeAct,@nTotFac,@nTotPag,@nTotSdo,;
				STR(FAM->(RECNO()),4)+'/'+;
				STR(FAM->(RECCOUNT()),4)+'=>FAMILIA:'+;
				ALLTRIM(FAM->cNombreFam))
	    SET DEVICE TO PRINT
**********FIN CALCULO DE LA FACTURACION FAMILIAR

**********ANALISIS DE DECISION
	    IF nTotFac < nVlrTop
	       IF nTotSdo < nVlrTop
		  SELECT FAM
		  FAM->(DBSKIP())
		  LOOP
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE DECISION

**********ANALISIS CODIGOS DE LA FAMILIA
	    cCodEstTfa := SUBS(FAM->cCodEstFam,1,6)
	    FOR i := 2 TO LEN(ALLTRIM(FAM->cCodEstFam))/6
		cCodEstTfa += '-'+SUBS(FAM->cCodEstFam,i*6-5,6)
	    NEXT
	    IF !EMPTY(cErrFac)
	       cCodEstTfa := 'ERROR '+ cCodEstTfa
	    ENDIF
	    cCodEstTfa := SUBS(cCodEstTfa+SPACE(60),1,60)
**********FIN ANALISIS CODIGOS DE LA FAMILIA

**********PREPARACION DEL REGISTRO
	    aRegPrn := {FAM->cNombreFam,;
			TRANS(nTotFac,"####,###,###"),;
			TRANS(nTotPag,"####,###,###"),;
			TRANS(nTotSdo,"####,###,###"),;
			cCodEstTfa}
**********FIN PREPARACION DEL REGISTRO

**********PREPARACION DE LOS DATOS DE LOS PADRES
	    IF nOpcPrn == 7         // A Archivo Dbf

	       DO CASE
	       CASE nTipInf == 1
		    AADD(aRegPrn,'SALDO ACTUAL A LA FECHA')
		    AADD(aNroCol,30)

	       CASE nTipInf == 2
		    AADD(aRegPrn,'SALDO A FIN DE MES')
		    AADD(aNroCol,30)

	       CASE nTipInf == 3
		    AADD(aRegPrn,'SALDO A '+cFecha(dFecPrn))
		    AADD(aNroCol,30)
	       ENDCASE

	       AADD(aRegPrn,RTRIM(&cMaeAct->cNomPadEst)+' '+;
			    RTRIM(&cMaeAct->cApePadEst))
	       AADD(aNroCol,70)

	       AADD(aRegPrn,&cMaeAct->cPadNitEst)
	       AADD(aNroCol,16)

	       AADD(aRegPrn,RTRIM(&cMaeAct->cNomMadEst)+' '+;
			    RTRIM(&cMaeAct->cApeMadEst))
	       AADD(aNroCol,70)

	       AADD(aRegPrn,&cMaeAct->cMadNitEst)
	       AADD(aNroCol,16)

	       AADD(aRegPrn,ALLTRIM(&cMaeAct->cDireccEst)+','+;
			    ALLTRIM(&cMaeAct->cBarrioEst)+','+;
			    ALLTRIM(&cMaeAct->cCiudadEst))
	       AADD(aNroCol,86)

	       AADD(aRegPrn,&cMaeAct->cTelefnEst)
	       AADD(aNroCol,14)

	    ENDIF
**********FIN PREPARACION DE LOS DATOS DE LOS PADRES

**********CREACION DEL ARCHIVO DE IMPRESION
	    IF !lSiPaso
	       nHanXml := CreaFrmPrn(lNoRed,FilePrn,aNroCol,;
				     nOpcPrn,aCabPrn,aTitPrn)
	       lSiPaso := .T.

	    ENDIF
**********FIN CREACION DEL ARCHIVO DE IMPRESION

**********IMPRESION DEL REGISTRO
	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********GRABACION DEL REGISTRO
	    IF TEM->(lRegLock(lShared,.T.))

	       REPL TEM->cNomFam WITH FAM->cNombreFam
	       REPL TEM->nTotFac WITH nTotFac
	       REPL TEM->nTotPag WITH nTotPag
	       REPL TEM->nTotSdo WITH nTotSdo
	       REPL TEM->cCodEst WITH cCodEstTfa

	       DO CASE
	       CASE nTipInf == 1
		    REPL TEM->cTipInf WITH 'SALDO ACTUAL A LA FECHA'

	       CASE nTipInf == 2
		    REPL TEM->cTipInf WITH 'SALDO A FIN DE MES'
		    AADD(aNroCol,30)

	       CASE nTipInf == 3
		    REPL TEM->cTipInf WITH 'SALDO A '+cFecha(dFecPrn)
	       ENDCASE

	       REPL TEM->cNomPad WITH RTRIM(&cMaeAct->cNomPadEst)+' '+;
				      RTRIM(&cMaeAct->cApePadEst)

	       REPL TEM->cPadNit WITH &cMaeAct->cPadNitEst

	       REPL TEM->cNomMad WITH RTRIM(&cMaeAct->cNomMadEst)+' '+;
				      RTRIM(&cMaeAct->cApeMadEst)

	       REPL TEM->cMadNit WITH &cMaeAct->cMadNitEst

	       REPL TEM->cDirecc WITH ALLTRIM(&cMaeAct->cDireccEst)+','+;
				      ALLTRIM(&cMaeAct->cBarrioEst)+','+;
				      ALLTRIM(&cMaeAct->cCiudadEst)

	       REPL TEM->cTelefn WITH &cMaeAct->cTelefnEst
	       TEM->(DBCOMMIT())
	    ELSE
	       cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
	    ENDIF
	    IF lShared
	       TEM->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********INCREMENTO DE LA SIGUIENTE FAMILIA
	    SELECT FAM
	    FAM->(DBSKIP())
**********FIN INCREMENTO DE LA SIGUIENTE FAMILIA

       ENDDO
       EVAL(bDerAut)
      *Derechos de Autor

       VerPrn(nOpcPrn,FilePrn,nHanXml)

       CloseAll(aUseDbf)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN RECORRIDO DE LAS FAMILIAS


/*************************************************************************
* TITULO..: FACTURACION TOTAL FAMILIAR                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 16/2004 DOM A
       Bucaramanga, Colombia        INICIO: 09:00 PM   MAY 16/2004 DOM

OBJETIVOS:

1- Imprime el Cuerpo del Estado de Cuenta del Cliente

2- Retorna el manejador del Archivo Xml


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cFactFam(lShared,nModCry,cNomSis,cAnoUsr,cPatSis,cMaeAlu,cEstFam,;
		  nTipInf,dFecPrn,cMaeAct,nTotFac,nTotPag,nTotSdo,cNomFam)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del Sistema
       cMaeAlu                              // Maestros Habilitados
       cEstFam                              // C¢digos del Estudiante de la Familia
       nTipInf                              // Tipo de Informe
       dFecPrn                              // Fecha de Corte de Impresi¢n
       cMaeAct                              // Maestro Actual
       nTotFac                              // @Total de la Facturaci¢n
       nTotPag                              // @Total de Pagos
       nTotSdo                              // @Total de Saldos
       cNomFam                              // Nombre de la Familia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL     i,j := 0                   // Contador
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL cHayErr := ''                  // '' => No hay Error F=> Error en Anticipos S=> Error en Saldos
       LOCAL cErrFac := ''                   // '' => No hay Error F=> Error en Anticipos S=> Error en Saldos
       LOCAL lPrnFec := .F.                 // .T. Imprimir por Fechas

       LOCAL nFacMat := 0                   // Facturaci¢n de la Matricula
       LOCAL aVlrEst := {}                  // Facturacion del Estudiante
       LOCAL nFacEst := 0                   // Facturaci¢n
       LOCAL nPagMes := 0		    // Valor Pagado
       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nPagFin := 0                   // Valor Pagado fin de mes
       LOCAL nSdoFin := 0                   // Saldo Actual fin de mes
     *ÀFacturaci¢n estudiante

       LOCAL cCodigoTes := ''               // Codigo del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO DEL GRUPO FAMILIAR
       FOR i := 1 TO LEN(ALLTRIM(cEstFam))/6

	   cCodigoTes := SUBS(ALLTRIM(cEstFam),i*6-5,6)

***********BUSQUEDA DEL CODIGO DEL ESTUDIANTE
	     IF !lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct,.F.)
		cError('EL CODIGO DEL ESTUDIANTE:' +;
			cCodigoTes+' '+'NO EXISTE')
		RETURN 'E'
	     ENDIF
***********FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

***********VALIDACION DEL GRUPO
	     cCodigoTgr := &cMaeAct->cCodigoGru
	     IF SUBS(&cMaeAct->cCodigoGru,3,2) == '00'
		LOOP
	     ENDIF
***********FIN VALIDACION DEL GRUPO

***********PREPARACION DE LAS VARIABLES DE ARCHIVO
	     FileCli := cPatSis+'\CLIENTES\CL'+;
				cCodigoTgr+cAnoSis+ExtFile

	     FilePag := cPatSis+'\PAGOS\PA'+;
				cCodigoTgr+cAnoSis+ExtFile
***********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		!lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		RETURN 'E'
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********LOCALIZACION DEL CLIENTE
	     IF !lLocCodigo('cCodigoEst','CLI',cCodigoTes)
		cError('EL CODIGO:'+cCodigoTes+' NO EXISTE EN CLIENTES')
		CloseAll(aUseDbf)
		RETURN 'E'
	     ENDIF
***********FIN LOCALIZACION DEL CLIENTE

***********ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
	     IF CLI->lRetGruCli
		cError('EL CODIGO:'+cCodigoTes+' '+;
		       'APARECE CAMBIADO DEL GRUPO. REVISAR')
		CloseAll(aUseDbf)
		RETURN 'E'
	     ENDIF
***********FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

***********FILTRACION DE LOS PAGOS
	     SELECT PAG
	     SET FILTER TO PAG->cCodigoEst == CLI->cCodigoEst
	     PAG->(DBGOTOP())

	     IF PAG->(EOF())
		SET FILTER TO
		LOOP
	     ENDIF
***********FIN FILTRACION DE LOS PAGOS

***********CALCULO DE LA MATRICULA
	     FOR j := 1 TO LEN(ALLTRIM(CAA->cConMatCaA))/2

*----------------LOCALIZACION DEL VALOR DEL CONCEPTO
		   cCodigoTco := SUBS(ALLTRIM(CAA->cConMatCaA),j*2-1,2)
		   SELECT TMT
		   GO TOP
		   LOCATE FOR TMT->cCodigoGru == SUBS(cCodigoTgr,1,2)+'00' .AND.;
			      TMT->cCodigoCon == cCodigoTco

		   IF FOUND()
		      nFacMat += TMT->nValorTar
		   ENDIF
*----------------FIN LOCALIZACION DEL VALOR DEL CONCEPTO

	     ENDFOR
	     nTotFac += nFacMat
	     nTotPag += nFacMat
***********FIN CALCULO DE LA MATRICULA

***********RECORRIDO DE LOS PAGOS
	     SELECT PAG
	     PAG->(DBGOTOP())
	     DO WHILE .NOT. PAG->(EOF())

*---------------IMPRESION DE LA LINEA DE ESTADO
		  LineaEstado('º'+cNomFam+;
			      'ºCODIGO: '+cCodigoTes+;
			      'ºGRUPO: '+cCodigoTgr+;
			      'ºMES:'+cMes(PAG->nMesIniPag,3),cNomSis)
*---------------FIN IMPRESION DE LA LINEA DE ESTADO

*---------------CALCULO DE LA FACTURACION DEL MES
		  lPrnFec := IF(EMPTY(dFecPrn),.F.,.T.)

		  cHayErr := cFactEst(cAnoUsr,cCodigoTes,;
				      &cMaeAct->lRetiroEst,;
				      PAG->nMesIniPag,;
				      lPrnFec,dFecPrn,;
				      @aVlrEst,@nFacEst,;
				      @nPagMes,@nSdoAct,;
				      @nPagFin,@nSdoFin)

		  nPagMes := IF(nTipInf==1 .OR. nTipInf==3,nPagMes,nPagFin)
		  nSdoAct := IF(nTipInf==1 .OR. nTipInf==3,nSdoAct,nSdoFin)

		  nTotFac += nFacEst
		  nTotPag += nPagMes
*---------------FIN CALCULO DE LA FACTURACION DEL MES

		cErrFac += cHayErr
		PAG->(DBSKIP())

	     ENDDO
	     nTotSdo += nSdoAct
***********RECORRIDO DE LOS PAGOS

       NEXT
       RETURN IF(EMPTY(cErrFac),'','E')
*>>>>RECORRIDO DEL GRUPO FAMILIAR


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

FUNCTION CreaFacFam(lShared,nModCry,PathArc,cNomArc,aStrDbf)

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
       AADD(aDbfStr,{"cNomFam","Character",30,0})
       AADD(aDbfStr,{"nTotFac","Numeric",16,2})
       AADD(aDbfStr,{"nTotPag","Numeric",16,2})
       AADD(aDbfStr,{"nTotSdo","Numeric",16,0})
       AADD(aDbfStr,{"cCodEst","Character",60,0})
       AADD(aDbfStr,{"cTipInf","Character",60,0})
       AADD(aDbfStr,{"cNomPad","Character",70,0})
       AADD(aDbfStr,{"cPadNit","Character",16,0})
       AADD(aDbfStr,{"cNomMad","Character",70,0})
       AADD(aDbfStr,{"cMadNit","Character",16,0})
       AADD(aDbfStr,{"cDirecc","Character",86,0})
       AADD(aDbfStr,{"cTelefn","Character",86,0})
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