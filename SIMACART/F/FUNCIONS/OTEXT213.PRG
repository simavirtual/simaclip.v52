/*************************************************************************
* TITULO ..: VALIDACION DE LOS RECIBOS DE MATRICULAS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 06/2005 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 AM   DIC 06/2005 MAR

OBJETIVOS:

1- Valida los pagos en la cartera contra los pagos del Banco en lo
   referente a las matr¡culas.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtExt213(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
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
       LOCAL lPrnEnc := .T.                 // .T. Imprimir Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL lPrnReg := .F.                 // .T. Imprimir el Registro
       LOCAL lRegPrn := .F.                 // .T. Registros Impresos
       LOCAL nMesIni := 0                   // Mes Inicial del Pago
       LOCAL nMesFin := 0                   // Mes Final del Pago
       LOCAL nOpcion := 0                   // Opci¢n

       LOCAL nRegDbf := 0                   // Total Registros
       LOCAL nRegAct := 0                   // Registro Actual

       LOCAL dFecPag := CTOD('00/00/00')    // Fecha de Pago
       LOCAL nPagos  := 0                   // Valor pagos sin intereses
       LOCAL nPagNiv := 0                   // Total pagos por niveles
       LOCAL nPagTot := 0                   // Total pagos sin intereses
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n

       LOCAL nVlrInt := 0                   // Valor de los Intereses

       LOCAL nIntVlr := 0                   // Valor de los intereses
       LOCAL nIntNiv := 0                   // Total Intereses por nivel
       LOCAL nTotInt := 0                   // Total Intereses

       LOCAL nVlrPag := 0                   // Valor pagos con intereses
       LOCAL nTotNiv := 0                   // Total pagos con intereses por nivel
       LOCAL nTotPag := 0                   // Total pagos con intereses

       LOCAL nVlrBan := 0                   // Valor del Grupo en Bancos
       LOCAL nBanNiv := 0                   // Valor Total en Bancos por niveles
       LOCAL nTotBan := 0                   // Valor Total en Bancos

       LOCAL nVlrDif := 0                   // Valor Diferencia

       LOCAL nTotDif := 0                   // Total Diferencia
       LOCAL nDifNiv := 0                   // Total Diferencia por nivel
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
       LOCAL nNroReg := 0                   // N£mero de Registro

       LOCAL FileNtx := ''                  // Archivo Indice
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
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

*>>>>TIPO DE INFORME
       nOpcion := nLeeOpcion('OPCION: '+;
		 '1<INCONSISTENCIAS> 2<POR CONCEPTOS> 3<DETALLADO> '+;
		 '4<ABANDONAR>?',4,'0')

       IF nOpcion == 4
	  RETURN NIL
       ENDIF
*>>>>FIN TIPO DE INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'ValiMatr'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       DO CASE
       CASE nOpcion == 1
	    aCabPrn := {cNomEmp,cNomSis,;
			'MATRICULAS Vs BANCO EXTRACTO DE '+;
			cMes(VAL(cNroMes))+'. A¥O: '+cAnoUsr,;
			'VALIDACION DE MATRICULAS',;
			'PAGOS DEL MES'}

       CASE nOpcion == 2
	    aCabPrn := {cNomEmp,cNomSis,;
			'EXTRACTO DE '+cMes(VAL(cNroMes))+'. A¥O: '+cAnoUsr,;
			'MATRICULAS POR CONCEPTOS',;
			''}

       CASE nOpcion == 3
	    aCabPrn := {cNomEmp,cNomSis,;
			'MATRICULAS Vs BANCO EXTRACTO DE '+;
			cMes(VAL(cNroMes))+'. A¥O: '+cAnoUsr,;
			'VALIDACION DE MATRICULAS',;
			'PAGOS DEL MES'}
       ENDCASE

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       DO CASE
       CASE nOpcion == 1
	    aNroCol := {04,16,16,16,18,16,40}
	    aTitPrn := {'GRUPO',;
			'F.PAGO',;
			'EN EL SISTEMA',;
			'EN EL BANCO',;
			'DIFERENCIA',;
			'F.BANCO',;
			'OBSERVACIONS'}

       CASE nOpcion == 2
	    aNroCol := {16,12,40}
	    aTitPrn := {'CONCEPTOS',;
			'VALOR',;
			'OBSERVACIONES'}

       CASE nOpcion == 3
	    aNroCol := {04,16,16,16,18,16,40}
	    aTitPrn := {'GRUPO',;
			'F.PAGO',;
			'EN EL SISTEMA',;
			'EN EL BANCO',;
			'DIFERENCIA',;
			'F.BANCO',;
			'OBSERVACIONS'}
       ENDCASE
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

*>>>>CREACION ARCHIVO IMPRESION
       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN CREACION ARCHIVO IMPRESION

*>>>>ACTIVACION DE LOS INDICES
       SELECT TRA
       FileNtx := cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+;
		  BAN->cCodigoBan+'MATR'+cNroMes+'.NEL'

       INDEX ON TRA->cCodigoEst TO &(FileNtx)
       nRegDbf := TRA->(RECCOUNT())
*>>>>FIN ACTIVACION DE LOS INDICES

*>>>>RECORRIDO POR EXTRACTO
       SELECT TRA
       TRA->(DBGOTOP())
       DO WHILE .NOT. TRA->(EOF())

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO:'+STR(nRegAct++,4)+'/'+;
				    STR(nRegDbf,4),cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********VALIDACION DE LA MATRICULA
	    IF TRA->nCodigoCmv # 4
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA MATRICULA

**********ANALISIS DEL RECIBO
	       nMesIni := VAL(SUBS(TRA->cCodRefTra,7,2))
	       nMesFin := VAL(SUBS(TRA->cCodRefTra,9,2))
	    cCodigoTes := SUBS(TRA->cCodRefTra,1,6)
**********FIN ANALISIS DEL RECIBO

**********LOCALIZACION DEL CODIGO
	    SELECT PMT
	    PMT->(DBGOTOP())
	    LOCATE FOR PMT->cMatricPag == '1'        .AND.;
		       PMT->cCodigoEst == cCodigoTes .AND.;
		       PMT->nMesIniPag == nMesIni    .AND.;
		       PMT->nMesFinPag == nMesFin

	    lHayPag := .F.
	    IF FOUND()
	       lHayPag := .T.
	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS DE LOS PAGOS EN EL BANCO
	    nVlrBan := 0
	    IF lHayPag

	       DO WHILE PMT->cCodigoEst == SUBS(TRA->cCodRefTra,1,6) .AND.;
		  VAL(SUBS(TRA->cCodRefTra,7,2)) == PMT->nMesIniPag  .AND.;
		  VAL(SUBS(TRA->cCodRefTra,9,2)) == PMT->nMesFinPag  .AND.;
		  TRA->nCodigoCmv == 4

		  IF TRA->lSumarTra
		     nVlrBan += TRA->nValorTra
		  ELSE
		     nVlrBan -= TRA->nValorTra
		  ENDIF
		  nNroReg := TRA->(RECNO())

		  TRA->(DBSKIP())

	       ENDDO
	       TRA->(DBGOTO(nNroReg))

	    ENDIF
**********FIN ANALISIS DE LOS PAGOS EN EL BANCO

**********ANALISIS DEL PAGO
	    cMsgTxt := TRA->cCodRefTra
	    nVlrPag  := 0
	    nVlrInt := 0

	    lHayErr := .F.
	    IF lHayPag

	       dFecPag := PMT->dFecPagPag
	       IF !lPagoMtrOk(@nVlrPag,nVlrBan)
		  lHayErr := .T.
		  cMsgTxt += ' VALOR NO COINCIDE'
	       ENDIF

	       IF TRA->dFechaTra # PMT->dFecPagPag
		  cMsgTxt += ' ERROR FECHA'
		  lHayErr := .T.
	       ENDIF

	    ELSE
	       lHayErr := .T.
	       cMsgTxt += ' NO EXISTE EL RECIBO DE PAGO'
	       dFecPag := CTOD('00/00/00')
	    ENDIF
**********FIN ANALISIS DEL PAGO

**********DESCRIMINACION DE LA MATRICULA
	    IF PMT->nVlrCo1Pag+PMT->nVlrCo2Pag+;
	       PMT->nVlrCo3Pag+PMT->nVlrCo4Pag+;
	       PMT->nVlrCo5Pag+PMT->nVlrCo6Pag+;
	       PMT->nVlrCo7Pag+PMT->nVlrCo8Pag # 0

	       nVlrDif := 0
	       IF nVlrBan > nVlrPag
		  nVlrDif := nVlrBan - nVlrPag
		  VlrCon('BANCO','MAYOR VALOR',nVlrDif,aVlrCon)
	       ENDIF

	       nVlrTra := nVlrBan - nVlrDif
	       DO WHILE nVlrTra > 0
		  ConMtrExt(@nVlrTra,aVlrCon,'PMT','CMT')
	       ENDDO

	    ENDIF
**********FIN DESCRIMINACION DE LA MATRICULA

**********ANALISIS IMPRESION DEL REGISTRO
	    lPrnReg := .T.
	    DO CASE
	    CASE nOpcion == 1 .AND. lHayErr
	    CASE nOpcion == 3
	    OTHERWISE
		 lPrnReg := .F.
	    ENDCASE
**********FIN ANALISIS IMPRESION DEL REGISTRO

**********IMPRESION DEL REGISTRO
	    IF lPrnReg

	       aRegPrn := {}
	       AADD(aRegPrn,SPACE(01))
	       AADD(aRegPrn,cFecha(dFecPag))
	       AADD(aRegPrn,STR(nVlrPag,10,2))
	       AADD(aRegPrn,STR(TRA->nValorTra,10,2))
	       AADD(aRegPrn,STR(TRA->nValorTra-(nVlrPag),10,2))
	       AADD(aRegPrn,cFecha(TRA->dFechaTra))
	       AADD(aRegPrn,cMsgTxt)

	       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		       bCabeza,,,@lPrnEnc)
	       lRegPrn := .T.

	    ENDIF
**********FIN IMPRESION DEL REGISTRO

	  TRA->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR EXTRACTO

*>>>>IMPRIMIR POR CONCEPTOS
       IF nOpcion == 2

	  lPrnEnc := .T.
	  FOR i := 1 TO LEN(aVlrCon)

	      aRegPrn := {}
	      AADD(aRegPrn,aVlrCon[i,2])
	      AADD(aRegPrn,TRANS(aVlrCon[i,3],"####,###,###"))
	      AADD(aRegPrn,SPACE(40))

	      lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		      aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		      bCabeza,,,@lPrnEnc)

	  ENDFOR

	  aRegPrn := {}
	  AADD(aRegPrn,'TOTAL')
	  AADD(aRegPrn,TRANS(nSuma(aVlrCon,3),"####,###,###"))
	  AADD(aRegPrn,SPACE(40))

	  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		  aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
		  bCabeza,,,@lPrnEnc)

       ENDIF
*>>>>FIN IMPRIMIR POR CONCEPTOS

*>>>>IMPRESION DERECHOS
       IF lRegPrn
	  EVAL(bDerAut)
	 *Derechos de Autor
       ELSE
	  SET DEVICE TO SCREEN
          cError('NO EXISTEN REGISTROS A IMPRIMIR')
       ENDIF

       SET DEVICE TO SCREEN
       VerPrn(nOpcPrn,FilePrn,nHanXml)

       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO ..: PAGOS EN MATRICULAS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 14/2005 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 AM   DIC 14/2005 MIE

OBJETIVOS:

1- Valida los pagos en la cartera contra los pagos del Banco en lo
   referente a las matr¡culas.

2- Retorna .T. Sin Problemas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPagoMtrOk(nVlrPag,nVlrBan)

*>>>>DESCRIPCION DE PARAMETROS
/*     nVlrPag                              // @Valor pagodo seg£n matriculas
       nVlrBan                              // Valor pagado en el Banco */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nVlrInt := 0                   // Valor de los Intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS INTERESES
       IF PMT->lIntPenPag
	  nVlrInt := ROUND((ABS(PMT->nVlrMesPag)*PMT->nIntmorPag)/100,0)
       ELSE
	  nVlrInt := PMT->nVlrMorPag
       ENDIF
*>>>>FIN CALCULO DE LOS INTERESES

*>>>>ANALISIS DEL PAGO DEL RECIBO
       IF TRA->dFechaTra > PMT->dPagOpoPag
	  IF nVlrBan == PMT->nVlrPagPag+nVlrInt
	     nVlrPag := nVlrBan
	  ELSE
	     nVlrPag := PMT->nVlrPagPag
	     lHayErr := .T.
	  ENDIF
       ELSE
	  nVlrInt := 0
	  IF nVlrBan == PMT->nVlrPagPag
	     nVlrPag := nVlrBan
	  ELSE
	     nVlrPag := PMT->nVlrPagPag
	     lHayErr := .T.
	  ENDIF
       ENDIF
       RETURN !lHayErr
*>>>>FIN ANALISIS DEL PAGO DEL RECIBO