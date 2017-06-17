/*************************************************************************
* TITULO ..: IMPRESION DEL MOVIMIENTO POR CONCEPTOS                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/99 JUE A
       Colombia, Bucaramanga        INICIO: 11:30 PM   MAY 21/99 JUE

OBJETIVOS:

1- Imprime los movimientos del extracto descriminados por conceptos

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt12(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

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
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
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
       LOCAL aCabXml := {}                  // Encabezado del Xml
       LOCAL aCamXml := {}                  // Campo Xml
       LOCAL aRegXml := {}                  // Registros de Impresion
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nVlrCre := 0                   // Valor Creditos
       LOCAL nVlrDeb := 0                   // Valor D‚bitos
       LOCAL nVlrSdo := 0                   // Valor Saldo
       LOCAL nTotCre := 0                   // Total Creditos
       LOCAL nTotDeb := 0                   // Total D‚bitos
       LOCAL nTotSdo := 0                   // Total Saldos
       LOCAL lTodos  := .T.                 // Imprimir todos los Conceptos
       LOCAL nPorMtr := 0                   // 1 => Por Matricular 2=>Matriculados 3=>Ambos
       LOCAL lMatric := .F.                 // .T. Matriculado
       LOCAL nCodigo := 0                   // Codigo del Concepto
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aPagMes[13,2]                  // Pagos por Meses
       LOCAL aAboMes[13,2]                  // Abonos por Meses
       LOCAL aMatric[2,2]                   // Matriculas
       LOCAL nMesPag := 0                   // N£mero del Mes de pago
       LOCAL nVlrAbo := 0                   // Valor del Abono
       LOCAL nMesAbo := 0                   // Mes del Abono
       LOCAL cMsgMtr := ''                  // Mensaje para la Matr¡cula
       LOCAL lErrMtr := .F.                 // .T. Error en Matriculas
       LOCAL cAnoTxt := ''                  // A¤o temporal

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTcm := ''               // Nombre de la materia
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
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

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN MOVIMIENTOS GRABADOS')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DE DECISION
	lTodos := .T.
       lErrMtr := .F.
       nPorMtr := 3
       IF !lPregunta('DESEA IMPRIMIR TODOS LOS CONCEPTOS? Si No')

***********LECTURA DEL CODIGO
	     SET CURSOR ON
	     nCodigo := 9999
	     TitBuscar(2,@nNroFil,@nNroCol)
	     @ nNroFil,nNroCol GET nCodigo PICT '9999';
			       VALID lValidaCmv(ROW(),COL()-1,@nCodigo)
	     READ

	     lTodos := .F.
	     IF CMV->nCodigoCmv == 4
		nPorMtr := nLeeOpcion('ENTRE LA FORMA DE IMPRESION: '+;
				      '1<POR MATRICULAR> '+;
				      '2<MATRICULADOS> '+;
				      '3<AMBOS>?',3,'0')
		lErrMtr := lPregunta('DESEA RELACIONAR SOLO LAS INCONSISTENCIAS? Si No')
	     ENDIF
***********FIN LECTURA DEL CODIGO

       ENDIF
*>>>>FIN CAPTURA DEL CODIGO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		      'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		      '. A¥O: '+cAnoUsr),;
		   'MOVIMIENTOS POR CONCEPTOS',;
		   IF(lTodos,'',ALLTRIM(CMV->cNombreCmv)),;
		   nNroPag++,;
		   NIL,lTamAnc}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF lTodos
	  aNroCol := {40,18,18,18}
	  aTitPrn := {'CONCEPTOS','CREDITOS','DEBITOS','SALDO'}
	  aCamXml := aTitPrn
       ELSE
	  aNroCol := {12,04,18,18,16,16,40}
	  aTitPrn := {'FECHA','TRAN','CREDITOS','DEBITOS',;
		      'REFERENCIA','COMPROBANTE','OBSERVACION'}
	  aCamXml := aTitPrn
       ENDIF
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

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
          SET DEVICE TO PRINT
       ELSE
	  FilePrn := SUBS(CAR->cSerFacCar,1,1)+'mvc'+cNroMes+BAN->cCodigoBan
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
             RETURN NIL
          ENDIF
       ENDIF
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION POR CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT CMV
       IF lTodos
	  GO TOP
       ENDIF

       DO WHILE .T.

**********ANALISIS DE FIN DE ARCHIVO
	    IF lTodos .AND. CMV->(EOF())
	       EXIT
	    ENDIF
**********FIN ANALISIS DE FIN DE ARCHIVO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( CMV->(RECNO()) / CMV->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********INICIALIZACION DE LOS PAGOS POR MESES
	    FOR i := 1 TO 2
		aMatric[i,1] := 0
		aMatric[i,2] := 0
	    ENDFOR

	    FOR i := 1 TO 13
		aPagMes[i,1] := 0
		aPagMes[i,2] := 0
		aAboMes[i,1] := 0
		aAboMes[i,2] := 0
	    ENDFOR
**********FIN INICIALIZACION DE LOS PAGOS POR MESES

**********IMPRESION DEL MOVIMIENTO
	    nVlrCre := 0
	    nVlrDeb := 0
	    nVlrSdo := 0

	    SELECT TRA
	    GO TOP
	    DO WHILE .NOT. TRA->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('CONCEPTOS: '+STR(CMV->(RECNO()),5)+'/'+;
					   STR(CMV->(RECCOUNT()),5)+'º'+;
			     'REFERENCIA: '+TRA->cCodRefTra+'º'+;
			     'MOVIMIENTOS: '+STR(TRA->(RECNO()),5)+'/'+;
					     STR(TRA->(RECCOUNT()),5),;
					     cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO


*--------------ACUMULACION DE CONCEPTOS
		 IF TRA->nCodigoCmv == CMV->nCodigoCmv

		    DO CASE
		    CASE CMV->nCodigoCmv == 1 .OR. CMV->nCodigoCmv == 2 // Pensiones

*........................VALIDACION DEL MES DE LA REFERENCIA
			   nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
			   IF nMesPag <= 0 .OR. nMesPag > 12

			      VerPrn(nOpcPrn,FilePrn)
			      SET DEVICE TO SCREEN
			      cError('LA REFERENCIA '+TRA->cCodRefTra+;
				     'NO ESTA ASIGNADA A NINGUN MES DE PENSION')
			      oBrowse:FORCESTABLE()
			      oBrowse:REFRESHALL()
			      RETURN NIL
			   ENDIF
*........................FIN VALIDACION DEL MES DE LA REFERENCIA

*........................CONSIGNACIONES POR RECIBOS PENSIONES
			   IF TRA->lSumarTra
			      nTotCre += TRA->nValorTra
			      aPagMes[nMesPag,1] += TRA->nValorTra
			      nTotSdo += TRA->nValorTra
			   ELSE
			      aPagMes[nMesPag,2] += TRA->nValorTra
			      nTotDeb += TRA->nValorTra
			      nTotSdo -= TRA->nValorTra
			   ENDIF
*........................FIN CONSIGNACIONES POR RECIBOS PENSIONES

		    CASE CMV->nCodigoCmv == 3  // Abonos


*........................VALIDACION DEL MES DEL ABONO EN LA REFERENCIA
			   nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))
			   IF nMesAbo <= 0 .OR. nMesAbo > 12 .OR.;
			      SUBS(TRA->cCodRefTra,7,2) # '14'

			      nMesAbo := 13
			      SET DEVICE TO SCREEN
			      cError('LA REFERENCIA '+TRA->cCodRefTra+;
				     ' ESTA MAL CODIFICADA')
			      SET DEVICE TO PRINT
			   ENDIF
*........................FIN VALIDACION DEL MES DEL ABONO EN LA REFERENCIA

*........................CONSIGNACIONES POR ABONOS
			   IF TRA->lSumarTra
			      nTotCre += TRA->nValorTra
			      aAboMes[nMesAbo,1] += TRA->nValorTra
			      nTotSdo += TRA->nValorTra
			   ELSE
			      aAboMes[nMesAbo,2] += TRA->nValorTra
			      nTotDeb += TRA->nValorTra
			      nTotSdo -= TRA->nValorTra
			   ENDIF
*........................FIN CONSIGNACIONES POR ABONOS

		    CASE CMV->nCodigoCmv == 4  // Matriculas

*........................ANALISIS DE LA MATRICULA
			   IF lSekCodMae(SUBS(TRA->cCodRefTra,1,6),;
			      cMaeAlu,@cMaeAct,.F.)

			      IF nPorMtr == 2 .OR. nPorMtr == 3

				 IF TRA->lSumarTra
				    nTotCre += TRA->nValorTra
				    aMatric[1,1] += TRA->nValorTra
				    nTotSdo += TRA->nValorTra
				 ELSE
				    aMatric[1,2] += TRA->nValorTra
				    nTotDeb += TRA->nValorTra
				    nTotSdo -= TRA->nValorTra
				 ENDIF

			      ENDIF

			   ELSE

			      IF nPorMtr == 1 .OR. nPorMtr == 3

				 IF TRA->lSumarTra
				    nTotCre += TRA->nValorTra
				    aMatric[2,1] += TRA->nValorTra
				    nTotSdo += TRA->nValorTra
				 ELSE
				    aMatric[2,2] += TRA->nValorTra
				    nTotDeb += TRA->nValorTra
				    nTotSdo -= TRA->nValorTra
				 ENDIF

			      ENDIF
			   ENDIF
*........................FIN ANALISIS DE LA MATRICULA

		    OTHERWISE

			 DO CASE
			 CASE CMV->nCodCmvCmv == 2 // Pensiones otro a¤o

*.............................VALIDACION DEL MES DE LA REFERENCIA
				nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
				IF nMesPag <= 0 .OR. nMesPag > 12

				   VerPrn(nOpcPrn,FilePrn)
				   SET DEVICE TO SCREEN
				   cError('LA REFERENCIA '+TRA->cCodRefTra+;
					  'NO ESTA ASIGNADA A NINGUN MES DE PENSION')
				   oBrowse:FORCESTABLE()
				   oBrowse:REFRESHALL()
				   RETURN NIL

				ENDIF
*.............................FIN VALIDACION DEL MES DE LA REFERENCIA

*.............................CONSIGNACIONES POR RECIBOS PENSIONES
				IF TRA->lSumarTra
				   nTotCre += TRA->nValorTra
				   aPagMes[nMesPag,1] += TRA->nValorTra
				   nTotSdo += TRA->nValorTra
				ELSE
				   aPagMes[nMesPag,2] += TRA->nValorTra
				   nTotDeb += TRA->nValorTra
				   nTotSdo -= TRA->nValorTra
				ENDIF
*.............................FIN CONSIGNACIONES POR RECIBOS PENSIONES

			 CASE CMV->nCodCmvCmv == 3  // Abonos otros a¤os

*.............................VALIDACION DEL MES DEL ABONO EN LA REFERENCIA
				nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))
				IF nMesAbo <= 0 .OR. nMesAbo > 12 .OR.;
				   SUBS(TRA->cCodRefTra,7,2) # '14'

				   nMesAbo := 13
				   SET DEVICE TO SCREEN
				   cError('LA REFERENCIA '+TRA->cCodRefTra+;
					  ' ESTA MAL CODIFICADA')
				   SET DEVICE TO PRINT
				ENDIF
*.............................FIN VALIDACION DEL MES DEL ABONO EN LA REFERENCIA

*.............................CONSIGNACIONES POR ABONOS OTRO A¥OS
				IF TRA->lSumarTra
				   nTotCre += TRA->nValorTra
				   aAboMes[nMesAbo,1] += TRA->nValorTra
				   nTotSdo += TRA->nValorTra
				ELSE
				   aAboMes[nMesAbo,2] += TRA->nValorTra
				   nTotDeb += TRA->nValorTra
				   nTotSdo -= TRA->nValorTra
				ENDIF
*.............................FIN CONSIGNACIONES POR ABONOS OTRO A¥OS

			 OTHERWISE

*.............................OTRAS CONSIGNACIONES
				IF TRA->lSumarTra
				   nVlrCre += TRA->nValorTra
				   nVlrSdo += TRA->nValorTra
				   nTotCre += TRA->nValorTra
				   nTotSdo += TRA->nValorTra
				ELSE
				   nVlrDeb += TRA->nValorTra
				   nVlrSdo -= TRA->nValorTra
				   nTotDeb += TRA->nValorTra
				   nTotSdo -= TRA->nValorTra
				ENDIF
*.............................FIN OTRAS CONSIGNACIONES

			 ENDCASE

		    ENDCASE

		 ENDIF
*--------------FIN ACUMULACION DE CONCEPTOS

*--------------DETALLES DEL ESTUDIANTE
		 lMatric := .T.
		 IF !lTodos .AND. (CMV->nCodigoCmv == 1 .OR.;
				   CMV->nCodigoCmv == 2 .OR.;
				   CMV->nCodigoCmv == 3 .OR.;
				   CMV->nCodigoCmv == 4)

		    cNombreTes := cSekNomAlu(SUBS(TRA->cCodRefTra,1,6),cMaeAlu)
		    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
		    cCodigoTgr := SUBS(cNombreTes,1,4)

		    IF CMV->nCodigoCmv == 4 .AND.;
		       'ALUMNO NO EXISTE' $ cNombreTes
		       cNombreTes := 'POR MATRICULAR'
		       lMatric := .F.
		    ENDIF

		 ENDIF
*--------------FIN DETALLES DEL ESTUDIANTE

*--------------LOCALIZACION DEL ABONO
		 nVlrAbo := 0
		 IF !lTodos .AND. CMV->nCodigoCmv == 3
		    SELECT DES
		    LOCATE FOR DES->cCodigoEst == TRA->cCodigoEst .AND.;
			       DES->nTipDesDes == 3 .AND.;
			       DES->nNroMesDes == VAL(SUBS(TRA->cCodRefTra,9,2)) .AND.;
			       DES->nValorDes  == TRA->nValorTra
		    IF FOUND()
		       nVlrAbo := DES->nValorDes
		    ENDIF
		 ENDIF
		 SELECT TRA
*--------------FIN LOCALIZACION DEL ABONO

*--------------LOCALIZACION DE LA MATRICULA
		 IF !lTodos .AND. CMV->nCodigoCmv == 4
		    SELECT PMT
		    LOCATE FOR PMT->cCodigoEst == TRA->cCodigoEst .AND.;
			       PMT->cMatricPag == '1'

		    cMsgMtr := 'NO RECIBO'
		    IF FOUND()
		       DO CASE
		       CASE TRA->nValorTra == PMT->nVlrPagPag .AND.;
			    TRA->dFechaTra == PMT->dFecPagPag
			    cMsgMtr := ''

		       CASE TRA->nValorTra == PMT->nVlrPagPag .AND.;
			    EMPTY(PMT->dFecPagPag)
			    cMsgMtr := 'NO REGISTRADO'

		       CASE TRA->nValorTra # PMT->nVlrPagPag .AND.;
			    TRA->dFechaTra # PMT->dFecPagPag .AND.;
			    EMPTY(PMT->dFecPagPag)
			    cMsgMtr := TRANS(PMT->nVlrPagPag,"#,###,###.##")

		       CASE TRA->nValorTra # PMT->nVlrPagPag .AND.;
			    TRA->dFechaTra # PMT->dFecPagPag .AND.;
			    !EMPTY(PMT->dFecPagPag)
			    cMsgMtr := cFecha(PMT->dFecPagPag)

		       CASE TRA->nValorTra # PMT->nVlrPagPag .AND.;
			    TRA->dFechaTra == PMT->dFecPagPag
			    cMsgMtr := TRANS(PMT->nVlrPagPag,"$,###,###.##")

		       CASE TRA->nValorTra == PMT->nVlrPagPag .AND.;
			    TRA->dFechaTra # PMT->dFecPagPag  .AND.;
			    !EMPTY(PMT->dFecPagPag)
			    cMsgMtr := DTOC(PMT->dFecPagPag)

		       OTHERWISE
			    cMsgMtr := 'ERROR?'
		       ENDCASE
		    ENDIF
		 ENDIF
*--------------FIN LOCALIZACION DE LA MATRICULA

*--------------IMPRESION DEL REGISTRO
		 IF !lTodos .AND. TRA->nCodigoCmv == CMV->nCodigoCmv

		    aRegPrn := {}
		    AADD(aRegPrn,cFecha(TRA->dFechaTra))
		    AADD(aRegPrn,TRA->cCodigoTra)
		    AADD(aRegPrn,IF(TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"9999999999"),;
				   SPACE(12)))
		    AADD(aRegPrn,IF(TRA->lSumarTra,;
				    SPACE(12),;
				    TRANS(TRA->nValorTra,"9999999999")))
		    AADD(aRegPrn,TRA->cCodRefTra)

		    DO CASE
		    CASE CMV->nCodigoCmv == 3
			 AADD(aRegPrn,TRANS(nVlrAbo,"####,###,###.##"))

		    CASE CMV->nCodigoCmv == 4
			 AADD(aRegPrn,cMsgMtr)

		    OTHERWISE
			 AADD(aRegPrn,TRA->cNroComTra)
		    ENDCASE
		    AADD(aRegPrn,cNombreTes)

		    IF CMV->nCodigoCmv == 4

		       IF (nPorMtr == 1 .AND. !lMatric) .OR.;
			  (nPorMtr == 2 .AND.  lMatric) .OR. nPorMtr == 3

			  lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				  nColCab,aTitPrn,aRegPrn,aNroCol,;
				  bPagina,bDerAut,bCabeza)

			  AADD(aRegPrn,'') // Campo Url
			  AADD(aRegXml,aRegPrn)
		       ENDIF

		    ELSE
		       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
			       nColCab,aTitPrn,aRegPrn,aNroCol,;
			       bPagina,bDerAut,bCabeza)

		       AADD(aRegPrn,'') // Campo Url
		       AADD(aRegXml,aRegPrn)
		    ENDIF
		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO

	       TRA->(DBSKIP())

	    ENDDO
**********IMPRESION DEL MOVIMIENTO

**********IMPRESION DE REGISTROS
	    IF lTodos

*--------------IMPRESION POR RECIBOS DE PENSIONES
		 IF CMV->nCodigoCmv == 1 .OR. CMV->nCodigoCmv == 2

		    FOR i := 1 TO 13
			IF aPagMes[i,1] # 0 .OR. aPagMes[i,2] # 0

			   cNombreTcm := IF(i#13,'RECIBOS DE '+cMes(i,3)+' '+;
						 CMV->cAnoCmvCmv,;
						 'RECIBOS OTRO A¥O '+;
						 CMV->cAnoCmvCmv)

			   cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			   aRegPrn := {cNombreTcm,;
				       IF(aPagMes[i,1] == 0,SPACE(12),;
					  TRANS(aPagMes[i,1],"####,###,###.##")),;
				       IF(aPagMes[i,2] == 0,SPACE(12),;
					  TRANS(aPagMes[i,2],"####,###,###.##")),;
				       IF(aPagMes[i,1] - aPagMes[i,2] == 0,SPACE(12),;
					  TRANS(aPagMes[i,1] - aPagMes[i,2],"#####,###,###.##"))}

			   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				   nColCab,aTitPrn,aRegPrn,aNroCol,;
				   bPagina,bDerAut,bCabeza)

			  AADD(aRegPrn,IF(i#13,'..\FACT'+cMes(i,3)+'\'+;
					  'PAG'+cMes(i,3)+cAnoSis+'.XML','')) // Campo Url
			  AADD(aRegXml,aRegPrn)
			ENDIF
		    ENDFOR
		 ENDIF
*--------------FIN IMPRESION POR RECIBOS DE PENSIONES

*--------------IMPRESION DE LOS ABONOS
		 IF CMV->nCodigoCmv == 3

		    FOR i := 1 TO 13
			IF aAboMes[i,1] # 0 .OR. aAboMes[i,2] # 0

			   cNombreTcm := IF(i#13,'ABONOS DE '+cMes(i,3)+' '+;
						 CMV->cAnoCmvCmv,;
						 'OTROS ABONOS '+;
						 CMV->cAnoCmvCmv)

			   cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			   aRegPrn := {cNombreTcm,;
				       IF(aAboMes[i,1] == 0,SPACE(12),;
					  TRANS(aAboMes[i,1],"####,###,###.##")),;
				       IF(aAboMes[i,2] == 0,SPACE(12),;
					  TRANS(aAboMes[i,2],"####,###,###.##")),;
				       IF(aAboMes[i,1]-aAboMes[i,2]== 0,SPACE(12),;
					  TRANS(aAboMes[i,1]-aAboMes[i,2],"#####,###,###.##"))}

			   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				   nColCab,aTitPrn,aRegPrn,aNroCol,;
				   bPagina,bDerAut,bCabeza)

			  AADD(aRegPrn,IF(i#13,'..\FACT'+cMes(i,3)+'\'+;
					  'PAG'+cMes(i,3)+cAnoSis+'.XML','')) // Campo Url
			  AADD(aRegXml,aRegPrn)

			ENDIF
		    ENDFOR

		 ENDIF
*--------------FIN IMPRESION DE LOS ABONOS

*--------------IMPRESION DE LAS MATRICULAS
		 IF CMV->nCodigoCmv == 4

		    FOR i := 1 TO 2
			IF aMatric[i,1] # 0 .OR. aMatric[i,2] # 0

			   cNombreTcm := IF(i==1,'MATRICULADOS',;
						 'POR MATRICULAR')
			   cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			   aRegPrn := {cNombreTcm,;
				       IF(aMatric[i,1] == 0,SPACE(12),;
					  TRANS(aMatric[i,1],"####,###,###.##")),;
				       IF(aMatric[i,2] == 0,SPACE(12),;
					  TRANS(aMatric[i,2],"####,###,###.##")),;
				       IF(aMatric[i,1]-aMatric[i,2]== 0,SPACE(12),;
					  TRANS(aMatric[i,1]-aMatric[i,2],"#####,###,###.##"))}

			   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				   aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				   bCabeza)

			   AADD(aRegPrn,'') // Campo Url
			   AADD(aRegXml,aRegPrn)

			ENDIF
		    ENDFOR

		 ENDIF
*--------------FIN IMPRESION DE LAS MATRICULAS

*--------------IMPRESION POR RECIBOS DE PENSIONES OTROS A¥OS
		 IF CMV->nCodigoCmv # 1 .AND.;
		    CMV->nCodigoCmv # 2 .AND.;
		    CMV->nCodigoCmv # 3 .AND.;
		    CMV->nCodigoCmv # 4 .AND.;
		    CMV->nCodigoCmv # CMV->nCodCmvCmv .AND.;
		    CMV->nCodCmvCmv == 2

		    FOR i := 1 TO 13
			IF aPagMes[i,1] # 0 .OR. aPagMes[i,2] # 0

			   cNombreTcm := ALLTRIM(CMV->cNombreCmv)

			   cAnoTxt := SUBS(cNombreTcm,LEN(cNombreTcm)-3,4)
			   IF cAnoTxt # CMV->cAnoCmvCmv
			      cNombreTcm += ' '+CMV->cAnoCmvCmv
			   ENDIF

			   IF i <= 12
			      cNombreTcm += ' '+cMes(i,3)
			   ELSE
			      cNombreTcm := STR(nCodigoCmv,4)+' '+;
					    ALLTRIM(CMV->cNombreCmv)+' '+;
					    CMV->cAnoCmvCmv
			   ENDIF

			   cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			   aRegPrn := {cNombreTcm,;
				       IF(aPagMes[i,1] == 0,SPACE(12),;
					  TRANS(aPagMes[i,1],"####,###,###.##")),;
				       IF(aPagMes[i,2] == 0,SPACE(12),;
					  TRANS(aPagMes[i,2],"####,###,###.##")),;
				       IF(aPagMes[i,1] - aPagMes[i,2] == 0,SPACE(12),;
					  TRANS(aPagMes[i,1] - aPagMes[i,2],"#####,###,###.##"))}

			   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				   nColCab,aTitPrn,aRegPrn,aNroCol,;
				   bPagina,bDerAut,bCabeza)

			  AADD(aRegPrn,IF(i#13,'..\FACT'+cMes(i,3)+'\'+;
					  'PAG'+cMes(i,3)+cAnoSis+'.XML','')) // Campo Url
			  AADD(aRegXml,aRegPrn)
			ENDIF
		    ENDFOR
		 ENDIF
*--------------FIN IMPRESION POR RECIBOS DE PENSIONES OTROS A¥OS

*--------------IMPRESION DE LOS ABONOS OTROS A¥OS
		 IF CMV->nCodigoCmv # 1 .AND.;
		    CMV->nCodigoCmv # 2 .AND.;
		    CMV->nCodigoCmv # 3 .AND.;
		    CMV->nCodigoCmv # 4 .AND.;
		    CMV->nCodigoCmv # CMV->nCodCmvCmv .AND.;
		    CMV->nCodCmvCmv == 3

		    FOR i := 1 TO 13
			IF aAboMes[i,1] # 0 .OR. aAboMes[i,2] # 0

			   cNombreTcm := ALLTRIM(CMV->cNombreCmv)

			   cAnoTxt := SUBS(cNombreTcm,LEN(cNombreTcm)-3,4)
			   IF cAnoTxt # CMV->cAnoCmvCmv
			      cNombreTcm += ' '+CMV->cAnoCmvCmv
			   ENDIF

			   IF i <= 12
			      cNombreTcm += ' '+cMes(i,3)
			   ELSE
			      cNombreTcm := STR(nCodigoCmv,4)+' '+;
					    ALLTRIM(CMV->cNombreCmv)+' '+;
					    CMV->cAnoCmvCmv
			   ENDIF

			   cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			   aRegPrn := {cNombreTcm,;
				       IF(aAboMes[i,1] == 0,SPACE(12),;
					  TRANS(aAboMes[i,1],"####,###,###.##")),;
				       IF(aAboMes[i,2] == 0,SPACE(12),;
					  TRANS(aAboMes[i,2],"####,###,###.##")),;
				       IF(aAboMes[i,1]-aAboMes[i,2]== 0,SPACE(12),;
					  TRANS(aAboMes[i,1]-aAboMes[i,2],"####,###,###.##"))}

			   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				   nColCab,aTitPrn,aRegPrn,aNroCol,;
				   bPagina,bDerAut,bCabeza)

			  AADD(aRegPrn,IF(i#13,'..\FACT'+cMes(i,3)+'\'+;
					  'PAG'+cMes(i,3)+cAnoSis+'.XML','')) // Campo Url
			  AADD(aRegXml,aRegPrn)

			ENDIF
		    ENDFOR

		 ENDIF
*--------------FIN IMPRESION DE LOS ABONOS OTROS A¥OS


*--------------IMPRESION DE OTRAS CONSIGNACIONES
		 IF (nVlrCre # 0 .OR. nVlrDeb # 0) .AND.;
		    (CMV->nCodigoCmv # 1 .AND.;
		     CMV->nCodigoCmv # 2 .AND.;
		     CMV->nCodigoCmv # 3)

		     aRegPrn := {CMV->cNombreCmv,;
				 IF(nVlrCre == 0,SPACE(12),;
						TRANS(nVlrCre,"####,###,###.##")),;
				 IF(nVlrDeb == 0,SPACE(12),;
						TRANS(nVlrDeb,"####,###,###.##")),;
				 IF(nVlrCre - nVlrDeb == 0,SPACE(12),;
				    TRANS(nVlrCre - nVlrDeb,"#####,###,###.##"))}

		     lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			     aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

		     AADD(aRegPrn,'') // Campo Url
		     AADD(aRegXml,aRegPrn)
		 ENDIF
*--------------IMPRESION DE OTRAS CONSIGNACIONES


	    ENDIF
**********IMPRESION DE REGISTROS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CMV
	    IF lTodos
	       CMV->(DBSKIP())
	       IF CMV->(EOF())
		  SET DEVICE TO SCREEN
		  Termometro(100)
		  SET DEVICE TO PRINT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DE LOS TOTALES
       SET DEVICE TO PRINT
       @ PROW()+1,nColCab+nColTxt(aNroCol,IF(lTodos,02,03)) SAY REPL('-',aNroCol[IF(lTodos,02,03)])
       @ PROW()  ,nColCab+nColTxt(aNroCol,IF(lTodos,03,04)) SAY REPL('-',aNroCol[IF(lTodos,03,04)])

       IF lTodos
	  aTitulo := {'',REPL('-',aNroCol[02]),;
			 REPL('-',aNroCol[03]),;
			 REPL('-',aNroCol[04])}

	  AADD(aTitulo,'') // Campo Url
	  AADD(aRegXml,aTitulo)

	  aTitulo := {'TOTALES ...',;
		      TRANS(nTotCre,"####,###,###.##"),;
		      TRANS(nTotDeb,"####,###,###.##"),;
		      TRANS(nTotSdo,"#####,###,###.##")}

	  AADD(aTitulo,'') // Campo Url
	  AADD(aRegXml,aTitulo)

       ELSE

	  aTitulo := {'','',REPL('-',aNroCol[03]),REPL('-',aNroCol[04]),;
		      '','',''}

	  AADD(aTitulo,'') // Campo Url
	  AADD(aRegXml,aTitulo)

	  aTitulo := {'TOTALES ...','',;
		       TRANS(nTotCre,"####,###,###.##"),;
		       TRANS(nTotDeb,"#####,###,###.##"),'','',''}

	  AADD(aTitulo,'') // Campo Url
	  AADD(aRegXml,aTitulo)
       ENDIF

       IF lTodos
	  @ PROW(),nColCab+nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       ENDIF

       @ PROW()+1,nColCab SAY IF (lTodos,'TOTALES ...','')
       @ PROW()  ,nColCab+nColTxt(aNroCol,IF(lTodos,02,03)) SAY TRANS(nTotCre,"####,###,###.##")
       @ PROW()  ,nColCab+nColTxt(aNroCol,IF(lTodos,03,04)) SAY TRANS(nTotDeb,"####,###,###.##")

       IF lTodos
	  @ PROW(),nColCab+nColTxt(aNroCol,04) SAY TRANS(nTotSdo,"#####,###,###.##")
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
*>>>>FIN IMPRESION DERECHOS

*>>>>EXPORTACION AL ARCHIVO
       AADD(aCabXml,cNomEmp)
      *Nombre de la Empresa

       AADD(aCabXml,cNomSis+':{PAGOS}{BANCO}{EXTRACTO BANCARARIO}(MES)'+;
			    '{F9}{MOVIMIENTOS}{IMPRIMIR POR CONCEPTOS}'+;
			    '(S)(S)')
      *Nombre del Sistema

       AADD(aCabXml,IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		      'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		      '. A¥O: '+cAnoUsr))
      *Titulo No. 1

       AADD(aCabXml,'MOVIMIENTOS POR CONCEPTOS')
      *Titulo No. 2

       AADD(aCabXml,IF(lTodos,'',ALLTRIM(CMV->cNombreCmv)))
      *Titulo No. 3

       AADD(aCabXml,cFecha(DATE()))
      *Fecha del Informe

       AADD(aCabXml,TIME())
      *Hora del Informe

       FileXml(PathW01+'\'+'FACT'+cMes(VAL(cNroMes),3)+'\'+;
	       IF(lTodos,;
	       'EXT'+cMes(VAL(cNroMes),3)+cAnoSis+'.XML',;
	       'CONT'+cMes(VAL(cNroMes),3)+cAnoSis+'.XML'),;
	       aRegXml,aCamXml,aCabXml)
     *ÀCreaci¢n del Archivo

       RETURN NIL
*>>>>FIN EXPORTACION AL ARCHIVO