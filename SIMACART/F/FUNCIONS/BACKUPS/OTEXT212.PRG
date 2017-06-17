/*************************************************************************
* TITULO ..: EXTRACTO POR CONCEPTOS VALIDADOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 16/2001 JUE A
       Colombia, Bucaramanga        INICIO: 05:00 PM   AGO 16/2001 JUE

OBJETIVOS:

1- Imprime el Extracto por Conceptos validando todos los movimientos
   de la Cartera

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtExt212(aParam1,aParam2,aParam3,;
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

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
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
     *ÀVariables de informe


       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nVlrCre := 0                   // Valor Creditos
       LOCAL nVlrDeb := 0                   // Valor D‚bitos
       LOCAL nVlrSdo := 0                   // Valor Saldo
       LOCAL nTotCre := 0                   // Total Creditos
       LOCAL nTotDeb := 0                   // Total D‚bitos
       LOCAL nTotSdo := 0                   // Total Saldos
       LOCAL nCodigo := 0                   // Codigo del Concepto
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL aPagMes[13,3]                  // Pagos por Meses
       LOCAL aAboMes[13,3]                  // Abonos por Meses
       LOCAL nMesPag := 0                   // N£mero del Mes de pago
       LOCAL nVlrInt := 0                   // Valor de los Intereses pagados
       LOCAL lValida := .F.                 // Valida los Inconsistencias
       LOCAL nMesAbo := 0                   // Mes del Abono
       LOCAL lHayPag := .F.                 // .T. Hay Pago
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL nVlrTra := 0                   // Valor de la Transaci¢n
       LOCAL lSumar  := .F.                 // .T. Sumar
       LOCAL fNtxExt := ''                  // Archivo de Indice
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTcm := ''               // Nombre del Concepto
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
       lValida := lPregunta('DESEA IMPRIMIR LOS ESTUDIANTES '+;
			    'CON INCONSISTENCIAS? No Si')
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ACTIVACION DE LOS INDICES
       fNtxExt := 'EX'+cAnoUsr+cNroMes+cExtNtx
       SELECT TRA
       INDEX ON TRA->cCodigoEst;
	     TO &(cPatSis+'\MODEM\'+BAN->cCodigoBan+'\'+fNtxExt)
*>>>>FIN ACTIVACION DE LOS INDICES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		      'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		      '. A¥O: '+cAnoUsr),;
		   'MOVIMIENTOS POR CONCEPTOS VALIDADOS',;
		   IF(lValida,'ESTUDIANTES CON INCONSISTENCIAS',''),;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF .NOT. lValida
	  aNroCol := {40,16,16,16,16,16}
	  aTitulo := {'CONCEPTOS','CREDITOS','DEBITOS',;
		      'SALDO','EL SISTEMA','DIFERENCIA'}
       ELSE
	  aNroCol := {12,12,40,12,12,12}
	  aTitulo := {'FECHA',;
		      'REFERENCIA',;
		      'APELLIDOS Y NOMBRES',;
		      'BANCO',;
		      'EL SISTEMA',;
		      'DIFERENCIA'}
       ENDIF
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .T.
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
	  FilePrn := 'ValiExt'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,.T.,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION POR CONCEPTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT CMV
       GO TOP
       DO WHILE .T.

**********ANALISIS DE FIN DE ARCHIVO
	    IF CMV->(EOF())
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
	    FOR i := 1 TO 13
		aPagMes[i,1] := 0
		aPagMes[i,2] := 0
		aPagMes[i,3] := 0
		aAboMes[i,1] := 0
		aAboMes[i,2] := 0
		aAboMes[i,3] := 0
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
		 LineaEstado('REGISTRO: '+STR(CMV->(RECNO()),5)+'/'+;
					  STR(CMV->(RECCOUNT()),5)+'º'+;
			     'REFERENCIA: '+TRA->cCodRefTra+;
			     'º'+STR(TRA->(RECNO()),5)+'/'+;
				 STR(TRA->(RECCOUNT()),5),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DE PAGOS COMPUESTOS
		 nVlrTra := 0
		 lSumar := TRA->lSumarTra
		 cCodigoTes := TRA->cCodigoEst

		 IF TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2
 nVlrTra := TRA->nValorTra
/*		    DO WHILE TRA->cCodigoEst == cCodigoTes .AND.;
			     TRA->lSumarTra  == lSumar
		       nVlrTra += TRA->nValorTra
		       nRegAct := TRA->(RECNO())
		       TRA->(DBSKIP())
		    ENDDO
		    TRA->(DBGOTO(nRegAct)) */

		 ENDIF
*--------------FIN ANALISIS DE PAGOS COMPUESTOS


*--------------BUSQUEDA DEL ESTUDIANTE
		 lHayAlu := .F.
		 IF CMV->nCodigoCmv == 1 .OR. CMV->nCodigoCmv == 2 .OR.;
		    CMV->nCodigoCmv == 3 .OR. CMV->nCodigoCmv == 4
		    lHayAlu := lSekCodMae(TRA->cCodigoEst,;
					  cMaeAlu,@cMaeAct,.F.)
		 ENDIF
*--------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------PREPARACION DE LAS VARIABLES DE ARCHIVOS
		 IF lHayAlu .AND. (CMV->nCodigoCmv == 1 .OR.;
				   CMV->nCodigoCmv == 2)
		    FilePag := cPatSis+'\PAGOS\PA'+;
			       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
		 ENDIF
*--------------FIN PREPARACION DE LAS VARIABLES DE ARCHIVOS

*--------------SELECION DE LAS AREAS DE TRABAJO
		 IF lHayAlu .AND. (CMV->nCodigoCmv == 1 .OR.;
				   CMV->nCodigoCmv == 2)
		    IF !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES Y PAGOS')
		       
		       lHayAlu := .F.
		    ENDIF
		 ENDIF
*--------------FIN SELECION DE LAS AREAS DE TRABAJO

*--------------LOCALIZACION DEL CODIGO DEL PAGO
		 nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
		 lHayPag := .F.
		 IF lHayAlu .AND. (CMV->nCodigoCmv == 1 .OR.;
				   CMV->nCodigoCmv == 2)
		    SELECT PAG
		    GO TOP
		    LOCATE FOR PAG->cCodigoEst == TRA->cCodigoEst .AND.;
			       PAG->nMesIniPag == nMesPag .AND.;
			       PAG->dFecPagPag == TRA->dFechaTra
		    IF FOUND()
		       lHayPag := .T.
		    ENDIF
		 ENDIF
*--------------FIN LOCALIZACION DEL CODIGO DEL PAGO

*--------------CALCULO DE LOS INTERESES
		 nVlrInt := 0
		 IF lHayPag
		    IF PAG->dFecPagPag > PAG->dPagOpoPag
		       nVlrInt := nIntersPag(nMesPag)
		    ENDIF
		    IF TRA->nValorTra # PAG->nVlrPagPag+nVlrInt
		       lHayPag := .F.
		    ENDIF
		 ENDIF
*--------------FIN CALCULO DE LOS INTERESES

*--------------ACUMULACION DE CONCEPTOS
		 IF TRA->nCodigoCmv == CMV->nCodigoCmv

		    IF CMV->nCodigoCmv == 1 .OR. CMV->nCodigoCmv == 2

*______________________VALIDACION DEL MES DE LA REFERENCIA
			 IF nMesPag <= 0 .OR. nMesPag > 12

			    VerPrn(nOpcPrn,FilePrn)
			    SET DEVICE TO SCREEN
			    cError('LA REFERENCIA '+TRA->cCodRefTra+;
				   'NO ESTA ASIGNADA A NINGUN MES DE PENSION')
			    oBrowse:FORCESTABLE()
			    oBrowse:REFRESHALL()
			    RETURN NIL
			 ENDIF
*______________________FIN VALIDACION DEL MES DE LA REFERENCIA

*______________________CONSIGNACIONES POR RECIBOS PENSIONES
			 IF TRA->lSumarTra
			    nTotCre += TRA->nValorTra
			    aPagMes[nMesPag,1] += TRA->nValorTra
			    nTotSdo += TRA->nValorTra
			    IF lHayPag
			       aPagMes[nMesPag,3] += PAG->nVlrPagPag+nVlrInt
			    ENDIF
			 ELSE
			    aPagMes[nMesPag,2] += TRA->nValorTra
			    nTotDeb += TRA->nValorTra
			    nTotSdo -= TRA->nValorTra
			    IF lHayPag
			       aPagMes[nMesPag,3] -= (PAG->nVlrPagPag+nVlrInt)
			    ENDIF
			 ENDIF
*______________________FIN CONSIGNACIONES POR RECIBOS DE PENSIONES


*----------------------IMPRESION DEL ESTUDIANTE CON INCONSISTENCIAS
			 IF lValida .AND. lHayPag .AND.;
			    TRA->nValorTra # (PAG->nVlrPagPag+nVlrInt)

			    aTitulo := {cFecha(TRA->dFechaTra),;
					TRA->TRA->cCodRefTra,;
					'',;
					TRANS(TRA->nValorTra,"####,###,###.##"),;
					TRANS(PAG->nVlrPagPag+nVlrInt,"####,###,###.##"),;
					SPACE(12)}

			    cTxtPrn := cRegPrint(aTitulo,aNroCol)
			    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
			 ENDIF
*----------------------FIN IMPRESION DEL ESTUDIANTE CON INCONSISTENCIAS


		    ELSE

*______________________ANALISIS DE LOS ABANOS
			 IF CMV->nCodigoCmv == 3

*...........................VALIDACION DEL MES DEL ABONO EN LA REFERENCIA
			      nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))
			      IF nMesAbo <= 0 .OR. nMesAbo > 12

				 VerPrn(nOpcPrn,FilePrn)
				 nMesAbo := 13
				 SET DEVICE TO SCREEN
				 cError('LA REFERENCIA '+TRA->cCodRefTra+;
					'NO ESTA ASIGNADA A NINGUN MES DE ABONO')
*				 oBrowse:FORCESTABLE()
*				 oBrowse:REFRESHALL()
*				 RETURN NIL
			      ENDIF
*...........................FIN VALIDACION DEL MES DEL ABONO EN LA REFERENCIA

*...........................CONSIGNACIONES POR ABONOS
			      IF TRA->lSumarTra
				 nTotCre += TRA->nValorTra
				 aAboMes[nMesAbo,1] += TRA->nValorTra
				 nTotSdo += TRA->nValorTra
			      ELSE
				 aAboMes[nMesAbo,2] += TRA->nValorTra
				 nTotDeb += TRA->nValorTra
				 nTotSdo -= TRA->nValorTra
			      ENDIF
*...........................FIN CONSIGNACIONES POR ABONOS

			 ELSE
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
			  *ÀOtras Consignaciones
			 ENDIF
*______________________FIN ANALISIS DE LOS ABANOS

		    ENDIF

		 ENDIF
*--------------FIN ACUMULACION DE CONCEPTOS

	       CloseDbf('PAG',FilePag,nModCry)
	       TRA->(DBSKIP())

	    ENDDO
**********IMPRESION DEL MOVIMIENTO

**********IMPRESION POR RECIBOS DE PENSIONES
	    IF CMV->nCodigoCmv == 1 .OR. CMV->nCodigoCmv == 2

	       FOR i := 1 TO 13
		   IF aPagMes[i,1] # 0 .OR. aPagMes[i,2] # 0

		      cNombreTcm := IF(i#13,'RECIBOS DE '+cMes(i,3),;
					    'RECIBOS OTRO A¥O')
		      cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

		      aTitulo := {cNombreTcm,;
				  IF(aPagMes[i,1] == 0,SPACE(12),;
				     TRANS(aPagMes[i,1],"####,###,###.##")),;
				  IF(aPagMes[i,2] == 0,SPACE(12),;
				     TRANS(aPagMes[i,2],"####,###,###.##")),;
				  IF(aPagMes[i,1] - aPagMes[i,2] == 0,SPACE(12),;
				     TRANS(aPagMes[i,1] - aPagMes[i,2],"####,###,###.##")),;
				  IF(aPagMes[i,3] == 0,SPACE(12),;
				     TRANS(aPagMes[i,3],"####,###,###.##")),;
				  SPACE(12)}
		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		   ENDIF
	       ENDFOR
	    ENDIF
**********FIN IMPRESION POR RECIBOS DE PENSIONES

**********IMPRESION DE LOS ABONOS
	    IF CMV->nCodigoCmv == 3

	       FOR i := 1 TO 13
		   IF aAboMes[i,1] # 0 .OR. aAboMes[i,2] # 0

		      cNombreTcm := IF(i#13,'ABONOS DE '+cMes(i,3)+' '+;
					    CMV->cAnoCmvCmv,;
					    'OTROS ABONOS '+CMV->cAnoCmvCmv)
		      cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

		      aTitulo := {cNombreTcm,;
				  IF(aAboMes[i,1] == 0,SPACE(12),;
				     TRANS(aAboMes[i,1],"####,###,###.##")),;
				  IF(aAboMes[i,2] == 0,SPACE(12),;
				     TRANS(aAboMes[i,2],"####,###,###.##")),;
				  IF(aAboMes[i,1]-aAboMes[i,2]== 0,SPACE(12),;
				     TRANS(aAboMes[i,1]-aAboMes[i,2],"####,###,###.##"))}
		      cTxtPrn := cRegPrint(aTitulo,aNroCol)
		      lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		   ENDIF
	       ENDFOR

	    ENDIF
**********FIN IMPRESION DE LOS ABONOS

**********IMPRESION DE OTRAS CONSIGNACIONES
	    IF (nVlrCre # 0 .OR. nVlrDeb # 0) .AND.;
	       (CMV->nCodigoCmv # 1 .AND.;
		CMV->nCodigoCmv # 2 .AND.;
		CMV->nCodigoCmv # 3)

		aTitulo := {CMV->cNombreCmv,;
			    IF(nVlrCre == 0,SPACE(12),;
					   TRANS(nVlrCre,"####,###,###.##")),;
			    IF(nVlrDeb == 0,SPACE(12),;
					   TRANS(nVlrDeb,"####,###,###.##")),;
			    IF(nVlrCre - nVlrDeb == 0,SPACE(12),;
			       TRANS(nVlrCre - nVlrDeb,"####,###,###.##"))}
		cTxtPrn := cRegPrint(aTitulo,aNroCol)
		lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DE OTRAS CONSIGNACIONES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CMV
	    CMV->(DBSKIP())
	    IF CMV->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColCab+nColTxt(aNroCol,02) SAY REPL('-',aNroCol[02])
       @ PROW()  ,nColCab+nColTxt(aNroCol,03) SAY REPL('-',aNroCol[03])
       @ PROW(),nColCab+nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])

       @ PROW()+1,nColCab SAY 'TOTALES ...'
       @ PROW()  ,nColCab+nColTxt(aNroCol,02) SAY TRANS(nTotCre,"####,###,###.##")
       @ PROW()  ,nColCab+nColTxt(aNroCol,03) SAY TRANS(nTotDeb,"####,###,###.##")
       @ PROW(),nColCab+nColTxt(aNroCol,04) SAY TRANS(nTotSdo,"####,###,###.##")
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
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: VALOR DE LOS INTERESES DEL PAGO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 24/2001 VIE A
       Colombia, Bucaramanga        INICIO: 12:20 AM   AGO 24/2001 VIE

OBJETIVOS:

1- Calcula el valor de los intereses que fueron facturados tomando los
   valores del registro de pagos

2- Debe estar ubicado en el respectivo registro del archivo pagos

3- Retorna el valor de los intereses.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nIntersPag(nMesIni)

*>>>>PARARAMETROS DE LA FUNCION
/*     nMesIni                              // Mes Inicial del recibo */
*>>>>FIN PARARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nVlrInt := 0                   // Valor de los intereses
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CALCULO DE LOS INTERESES
       IF PAG->lIntPenPag
	  IF nMesIni # PAG->nMesAmnPag
	     nVlrInt := ROUND(((PAG->nSdoAntPag+ABS(PAG->nVlrMesPag))*;
				PAG->nIntMorPag)/100,0)
	  ELSE
	     nVlrInt := ROUND((ABS(PAG->nVlrMesPag)*PAG->nIntMorPag)/100,0)
	  ENDIF
       ELSE
	   nVlrInt := PAG->nVlrMorPag
       ENDIF
       RETURN nVlrInt
*>>>>FIN CALCULO DE LOS INTERESES