/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: EXTRACTO.CONTABILIDAD.PAGOS POR CONCEPTOS

**************************************************************************
* TITULO..: PAGOS POR CONCEPTOS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 06/2008 MAR A
       Bucaramanga, Colombia        INICIO: 04:00 PM   MAY 06/2008 MAR

OBJETIVOS:

1- Permite descriminar los pagos del extracto por conceptos

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt32(aP1,aP2,aP3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL cUsrIso := ''                  // Usuario de la Iso
       LOCAL nNroInf := 0                   // N£mero del informe
       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL cCodInf := ''                  // C¢digo del Informe
       LOCAL aMarInf := {}                  // L¡neas de Espaciado
       LOCAL nNroDoc := 0                   // N£mero del Documento variable
       LOCAL fDocPrn := ''                  // Archivo a imprimir
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL cFecIso := ''                  // Fecha del Iso
       LOCAL cVerIso := ''                  // Versi¢n del Iso
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aObsIso := {}                  // Observaciones del informe
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental
     *ÀGestion Documental

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

       LOCAL     k,y := 0                   // Contador
       LOCAL nVlrCre := 0                   // Valor Creditos
       LOCAL nVlrDeb := 0                   // Valor D‚bitos
       LOCAL nVlrSdo := 0                   // Valor Saldo
       LOCAL nTotCre := 0                   // Total Creditos
       LOCAL nTotDeb := 0                   // Total D‚bitos
       LOCAL nTotSdo := 0                   // Total Saldos
       LOCAL aPagMes[13,3]                  // Pagos por Meses. Columnas: 1=>Debitos,2=Creditos,3=Conceptos Descriminados
       LOCAL aAboMes[13,3]                  // Abonos por Meses.Columnas: 1=>Debitos,2=Creditos,3=Conceptos Descriminados
       LOCAL aMatric[02,3]                  // Matriculas. Columnas: 1=>Debitos,2=Creditos,3=Conceptos Descriminados
       LOCAL nMesPag := 0                   // N£mero del Mes de pago
       LOCAL nMesAbo := 0                   // Mes del Abono

       LOCAL aCodCmv := {}                  // C¢digos del Concepto
       LOCAL nCodCmv := 0                   // C¢digo del C¢digo del Concepto
       LOCAL cNomCmv := ''                  // Concepto del Movimiento
       LOCAL lHayAlu := .F.                 // .T. Hay Estudiante
       LOCAL nHayErr := 0                   // Hay Error

       LOCAL nMesIni := 0                   // Mes Inicial del Pago
       LOCAL nMesFin := 0                   // Mes Final del Pago
       LOCAL aVlrCon := {}                  // Valor Por Conceptos
       LOCAL aVlrPag := {}                  // Conceptos Cancelados
       LOCAL aVlrErr := {}                  // Valor Por Inconsistencias
       LOCAL cNomCon := ''                  // Nombre del Concepto
       LOCAL nVlrCon := 0                   // Valor del Concepto
       LOCAL  nTotal := 0                   // Valor total Descriminado

       LOCAL nVlrDif := 0                   // Valor Diferencia
       LOCAL nConCre := 0                   // Creditos de Conceptos
       LOCAL nConDeb := 0                   // Debitos de Conceptos
       LOCAL aTotErr := {}                  // Registros inconsistentes
       LOCAL aRegErr := {}                  // Registro Error
       LOCAL aValErr := {1,3}               // Campos a Validar

       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTcm := ''               // Nombre del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN MOVIMIENTOS GRABADOS')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis,;
		   IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		      'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		      '. A¥O: '+cAnoUsr),;
		   'MOVIMIENTOS POR CONCEPTOS',;
		   'DESCRIMINADO',;
		   nNroPag++,;
		   NIL,lTamAnc}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Pica','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {40,16,16,16}
       aTitPrn := {'CONCEPTOS','CREDITOS','DEBITOS','SALDO'}
       aCamXml := aTitPrn

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
	  FilePrn := SUBS(CAR->cSerFacCar,1,1)+'mv1'+cNroMes+BAN->cCodigoBan
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

*>>>>ANALISIS DE DECISION
       aCodCmv := {}
       SELECT TRA
       TRA->(DBGOTOP())
       DO WHILE .NOT. TRA->(EOF())

**********SELECCION DE CODIGO
	    IF EMPTY(aCodCmv)
	       AADD(aCodCmv,{TRA->nCodigoCmv,''})
	    ELSE
	       i := ASCAN(aCodCmv,{|aArr|aArr[1] == TRA->nCodigoCmv})
	       IF i == 0
		  AADD(aCodCmv,{TRA->nCodigoCmv,''})
	       ENDIF
	    ENDIF
**********FIN SELECCION DE CODIGO

	  TRA->(DBSKIP())

       ENDDO
*>>>>FIN ANALISIS DE DECISION

*>>>>LOCALIZACION DE LOS CONCEPTOS
       aCodCmv := ASORT(aCodCmv,,,{|x,y|x[1] < y[1]})
       FOR i := 1 TO LEN(aCodCmv)

	   IF lLocCodigo('nCodigoCmv','CMV',aCodCmv[i,1])
	      aCodCmv[i,2] := CMV->cNombreCmv
	   ELSE
	      aCodCmv[i,2] := 'CODIGO:'+STR(aCodCmv[i,1],2)+' NO EXISTE'
	   ENDIF

       ENDFOR
*>>>>FIN LOCALIZACION DE LOS CONCEPTOS

*>>>>RECORRIDO POR CONCEPTOS DE MOVIMIENTOS
       cSavPan := SAVESCREEN(0,0,24,79)
       FOR k := 1 TO LEN(aCodCmv)

	  nCodCmv := aCodCmv[k,1]
	  cNomCmv := aCodCmv[k,2]

**********INICIALIZACION DE LOS PAGOS POR MESES
	    FOR i := 1 TO 2
		aMatric[i,1] := 0
		aMatric[i,2] := 0
		aMatric[i,3] := {}
	    ENDFOR

	    FOR i := 1 TO 13

		aPagMes[i,1] := 0
		aPagMes[i,2] := 0
		aPagMes[i,3] := {}

		aAboMes[i,1] := 0
		aAboMes[i,2] := 0
		aAboMes[i,3] := {}
	    ENDFOR
**********FIN INICIALIZACION DE LOS PAGOS POR MESES

**********IMPRESION DEL MOVIMIENTO
	    nVlrCre := 0
	    nVlrDeb := 0
	    nVlrSdo := 0

	    SELECT TRA
	    TRA->(DBGOTOP())
	    DO WHILE .NOT. TRA->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('CONCEPTOS: '+STR(k,5)+'/'+;
					   STR(LEN(aCodCmv),5)+'º'+;
			     'REFERENCIA: '+TRA->cCodRefTra+'º'+;
			     'MOVIMIENTOS: '+STR(TRA->(RECNO()),5)+'/'+;
					     STR(TRA->(RECCOUNT()),5),;
					     cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DEL RECIBO
		    nMesIni := VAL(SUBS(TRA->cCodRefTra,7,2))
		    nMesFin := VAL(SUBS(TRA->cCodRefTra,9,2))
		 cCodigoTes := SUBS(TRA->cCodRefTra,1,6)
*--------------FIN ANALISIS DEL RECIBO

*--------------BUSQUEDA DEL ESTUDIANTE
		 nHayErr := 0
		 lHayAlu := .F.
		 IF TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2 .OR.;
		    TRA->nCodigoCmv == 3 .OR. TRA->nCodigoCmv == 4

		    lHayAlu := lSekCodMae(cCodigoTes,cMaeAlu,@cMaeAct,.F.)

		    IF !lHayAlu

		       DO CASE
		       CASE TRA->nCodigoCmv == 1

			    nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
			    aVlrCon := aPagMes[nMesPag,3]
			    VlrCon('REC'+cMes(nMesIni,3),;
				   'RECIBOS SIN DESCRIMINAR '+;
				   cMes(nMesIni,3),;
				   TRA->nValorTra,@aVlrCon)
			    aPagMes[nMesPag,3] := aVlrCon

			    nHayErr := TRA->nCodigoCmv

		       CASE TRA->nCodigoCmv == 2

			    nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
			    aVlrCon := aPagMes[nMesPag,3]
			    VlrCon('REC'+cMes(nMesIni,3),;
				   'RECIBOS SIN DESCRIMINAR '+;
				   cMes(nMesIni,3),;
				   TRA->nValorTra,@aVlrCon)
			    aPagMes[nMesPag,3] := aVlrCon

			    nHayErr := TRA->nCodigoCmv

		       CASE TRA->nCodigoCmv == 3

			    nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))

			    aVlrCon := aAboMes[nMesAbo,3]
			    VlrCon('ABO'+cMes(nMesFin,3),;
				   'ABONOS SIN DESCRIMINAR '+cMes(nMesFin,3),;
				   TRA->nValorTra,@aVlrCon)
			    aAboMes[nMesAbo,3] := aVlrCon

			    nHayErr := TRA->nCodigoCmv

		       CASE TRA->nCodigoCmv == 4

			    aVlrCon := aMatric[1,3]
			    VlrCon('MTR','MATRICULA SIN DESCRIMINAR',;
				   TRA->nValorTra,@aVlrCon)
			    aMatric[2,3] := aVlrCon

			    nHayErr := TRA->nCodigoCmv

		       ENDCASE

		       aRegErr := {TRA->cCodRefTra,'','NO EXISTE'}
		       ValRegArr(@aTotErr,aRegErr,aValErr)

		    ENDIF

		 ENDIF
*--------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------LOCALIZACION PAGO DE LA MATRICULA
		 IF EMPTY(nHayErr) .AND.;
		    TRA->nCodigoCmv == 4

		    SELECT PMT
		    PMT->(DBGOTOP())
		    LOCATE FOR PMT->cMatricPag == '1'        .AND.;
			       PMT->cCodigoEst == cCodigoTes .AND.;
			       PMT->nMesIniPag == nMesIni    .AND.;
			       PMT->nMesFinPag == nMesFin

		    IF .NOT. PMT->(FOUND())

		       aVlrCon := aMatric[1,3]
		       VlrCon('MTR','MATRICULA SIN DESCRIMINAR',;
			      TRA->nValorTra,@aVlrCon)
		       aMatric[2,3] := aVlrCon

		       aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
				     'NO EXISTE EL PAGO DE LA MATRICULA'}

		       ValRegArr(@aTotErr,aRegErr,aValErr)

		       nHayErr := TRA->nCodigoCmv

		    ENDIF

		 ENDIF
*--------------FIN LOCALIZACION PAGO DE LA MATRICULA

*--------------PREPARACION DE LAS VARIABLES DE ARCHIVO
		 IF EMPTY(nHayErr) .AND.;
		    (TRA->nCodigoCmv == 1 .OR.;
		     TRA->nCodigoCmv == 2 .OR.;
		     TRA->nCodigoCmv == 3)

		    FileCli := cPatSis+'\CLIENTES\CL'+;
				       &cMaeAct->cCodigoGru+cAnoSis+ExtFile

		    FilePag := cPatSis+'\PAGOS\PA'+;
				       &cMaeAct->cCodigoGru+cAnoSis+ExtFile
		 ENDIF
*--------------FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

*--------------SELECCION DE LAS AREAS DE TRABAJO
		 IF EMPTY(nHayErr) .AND.;
		    (TRA->nCodigoCmv == 1 .OR.;
		     TRA->nCodigoCmv == 2 .OR.;
		     TRA->nCodigoCmv == 3)

		    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)

		       IF TRA->nCodigoCmv == 3

			  nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))

			  aVlrCon := aAboMes[nMesAbo,3]
			  VlrCon('ABO'+cMes(nMesFin,3),;
				 'ABONOS SIN DESCRIMINAR '+cMes(nMesFin,3),;
				 TRA->nValorTra,@aVlrCon)
			  aAboMes[nMesAbo,3] := aVlrCon

		       ELSE

			  nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
			  aVlrCon := aPagMes[nMesPag,3]
			  VlrCon('REC'+cMes(nMesIni,3),;
				 'RECIBOS SIN DESCRIMINAR',;
				 TRA->nValorTra,@aVlrCon)
			  aPagMes[nMesPag,3] := aVlrCon

		       ENDIF

		       aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
				   'ABRIENDO ARCHIVO DE CLIENTES Y PAGOS'}
		       ValRegArr(@aTotErr,aRegErr,aValErr)

		       CloseDbf('CLI')
		       CloseDbf('PAG')

		       nHayErr := TRA->nCodigoCmv

		    ENDIF

		 ENDIF
*--------------FIN SELECCION DE LAS AREAS DE TRABAJO

*--------------LOCALIZACION DEL PAGO DEL RECIBO
		 IF EMPTY(nHayErr) .AND.;
		    (TRA->nCodigoCmv == 1 .OR.;
		     TRA->nCodigoCmv == 2)

		    IF .NOT. lLocCodPag(cCodigoTes,nMesIni,.F.)

		       DO CASE
		       CASE TRA->nCodigoCmv == 1

			    nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
			    aVlrCon := aPagMes[nMesPag,3]
			    VlrCon('REC'+cMes(nMesIni,3),;
				   'RECIBOS SIN DESCRIMINAR '+;
				   cMes(nMesIni,3),;
				   TRA->nValorTra,@aVlrCon)
			    aPagMes[nMesPag,3] := aVlrCon

		       CASE TRA->nCodigoCmv == 2

			    nMesPag := VAL(SUBS(TRA->cCodRefTra,7,2))
			    aVlrCon := aPagMes[nMesPag,3]
			    VlrCon('REC'+cMes(nMesIni,3),;
				   'RECIBOS SIN DESCRIMINAR '+;
				   cMes(nMesIni,3),;
				   TRA->nValorTra,@aVlrCon)
			    aPagMes[nMesPag,3] := aVlrCon

		       ENDCASE

		       aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
				   'NO EXISTE EN PAGOS DEL GRUPO'}
		       ValRegArr(@aTotErr,aRegErr,aValErr)

		       CloseDbf('CLI')
		       CloseDbf('PAG')

		       nHayErr := TRA->nCodigoCmv

		    ENDIF

		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO DEL RECIBO

*--------------LOCALIZACION DEL ABONO EN DESCUENTOS
		 IF EMPTY(nHayErr) .AND.;
		    TRA->nCodigoCmv == 3

		    SELECT DES
		    DES->(DBGOTOP())
		    LOCATE FOR DES->nTipDesDes == TRA->nCodigoCmv .AND.;
			       !DES->lDesEfeDes                   .AND.;
			       DES->cCodigoEst == cCodigoTes	  .AND.;
			       DES->nNroMesDes == nMesFin         .AND.;
			       DES->dFechaDes  == TRA->dFechaTra  .AND.;
			       DES->nValorDes  == TRA->nValorTra

		    IF .NOT. DES->(FOUND())

		       nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))

		       aVlrCon := aAboMes[nMesAbo,3]
		       VlrCon('ABO'+cMes(nMesFin,3),;
			      'ABONOS SIN DESCRIMINAR '+cMes(nMesFin,3),;
			      TRA->nValorTra,@aVlrCon)
		       aAboMes[nMesAbo,3] := aVlrCon

		       aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
				   'NO EXISTE EN DESCUENTOS EL '+;
				   'ABONO APLICADO '+TRA->cCodRefTra}
		       ValRegArr(@aTotErr,aRegErr,aValErr)

		       nHayErr := TRA->nCodigoCmv

		    ENDIF

		 ENDIF
*--------------FIN LOCALIZACION DEL ABONO EN DESCUENTOS

*--------------LOCALIZACION DEL PAGO DEL ABONO
		 IF EMPTY(nHayErr) .AND.;
		    TRA->nCodigoCmv == 3

		    IF .NOT. lLocCodPag(cCodigoTes,nMesFin,.F.)

		       nMesAbo := VAL(SUBS(TRA->cCodRefTra,9,2))

		       aVlrCon := aAboMes[nMesAbo,3]
		       VlrCon('ABO'+cMes(nMesFin,3),;
			      'ABONOS SIN DESCRIMINAR '+cMes(nMesFin,3),;
			      TRA->nValorTra,@aVlrCon)
		       aAboMes[nMesAbo,3] := aVlrCon

		       aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
				   'NO EXISTE EN PAGOS EL ABONO APLICADO '+;
				   TRA->cCodRefTra}
		       ValRegArr(@aTotErr,aRegErr,aValErr)

		       CloseDbf('CLI')
		       CloseDbf('PAG')

		       nHayErr := TRA->nCodigoCmv

		    ENDIF

		 ENDIF
*--------------FIN LOCALIZACION DEL PAGO DEL ABONO

*--------------ACUMULACION DE CONCEPTOS
		 IF TRA->nCodigoCmv == nCodCmv

		    DO CASE
		    CASE nCodCmv == 1 .OR. nCodCmv == 2 // Pensiones

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

*........................DESCRIMINACION DEL RECIBO DE PENSIONES
			   IF EMPTY(nHayErr)

*:::::::::::::::::::::::::::::DESCRIMINACION
				aVlrPag := {}
				IF !lVlrConRec(aVlrPag)
				   aRegErr := {TRA->cCodRefTra,;
					       &cMaeAct->cCodigoGru,;
					       'REVISE EL ESTADO DE CUENTA:'+;
					       'DESCUENTOS,RECARGOS,ETC'}
				   ValRegArr(@aTotErr,aRegErr,aValErr)
				ENDIF
*:::::::::::::::::::::::::::::FIN DESCRIMINACION

*:::::::::::::::::::::::::::::DEBITO DE LA TRANSACION
				IF .NOT. TRA->lSumarTra
				   FOR y := 1 TO LEN(aVlrPag)
				       aVlrPag[y,4] := aVlrPag[y,3]  // Debito
				       aVlrPag[y,3] := 0             // Credito
				   ENDFOR
				ENDIF
*:::::::::::::::::::::::::::::FIN DEBITO DE LA TRANSACION

*:::::::::::::::::::::::::::::MAYOR O MENOR VALOR PAGADO
				nVlrDif := TRA->nValorTra - nVlrxPagar()

				DO CASE
				CASE nVlrDif > 0
				     VlrCon('MAYOR',;
					    'MAYOR VALOR PAGADO',;
					    nVlrDif,@aVlrPag)
				CASE nVlrDif < 0
				     RestarCon(aVlrPag,nVlrDif,;
					       TRA->lSumarTra)
				ENDCASE
*:::::::::::::::::::::::::::::FIN MAYOR O MENOR VALOR PAGADO

*:::::::::::::::::::::::::::::VALIDACION DEL TOTAL DESCRIMINADOS
				nTotal := 0
				FOR y := 1 TO LEN(aVlrPag)
				    nTotal += aVlrPag[y,3]
				ENDFOR

				IF nTotal # TRA->nValorTra

				   aRegErr := {TRA->cCodRefTra,'',STR(nTotal,10,2)+'#'+;
								  STR(TRA->nValorTra)+;
								  'REVISE EL ESTADO DE CUENTA'}
				   ValRegArr(@aTotErr,aRegErr,aValErr)

				ENDIF
*:::::::::::::::::::::::::::::FIN VALIDACION DEL TOTAL DESCRIMINADOS

*:::::::::::::::::::::::::::::ACUMULACION DE LOS CONCEPTOS
				aVlrCon := aPagMes[nMesPag,3]
				SumArrCon(aVlrCon,aVlrPag)
				aPagMes[nMesPag,3] := aVlrCon
*:::::::::::::::::::::::::::::FIN ACUMULACION DE LOS CONCEPTOS

			   ENDIF
*........................FIN DESCRIMINACION DEL RECIBO DE PENSIONES

		    CASE nCodCmv == 3  // Abonos

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

*........................DESCRIMINACION DEL ABONO
			   IF EMPTY(nHayErr)

			      IF VAL(cNroMes) == MONTH(TRA->dFechaTra)

				 aVlrCon := aAboMes[nMesAbo,3]
				 ConAboExt(aVlrCon)
				 aAboMes[nMesAbo,3] := aVlrCon

			      ELSE

				   aVlrCon := aAboMes[nMesAbo,3]
				   VlrCon('ABO'+cMes(nMesFin,3),;
					  'ABONOS SIN DESCRIMINAR '+cMes(nMesFin,3),;
					  TRA->nValorTra,@aVlrCon)
				   aAboMes[nMesAbo,3] := aVlrCon

				   nHayErr := TRA->nCodigoCmv

				  aRegErr := {TRA->cCodRefTra,&cMaeAct->cCodigoGru,;
					      'MES DEL EXTRACTO='+;
					      cMes(VAL(cNroMes),3)+' '+;
					      'MES DE LA TRANSACION='+;
					      cMes(MONTH(TRA->dFechaTra),3)+' '+;
					      'NO COINCIDEN'}
				  ValRegArr(@aTotErr,aRegErr,aValErr)
			      ENDIF

			   ENDIF
*........................FIN DESCRIMINACION DEL ABONO

		    CASE nCodCmv == 4  // Matriculas

*........................ANALISIS DE LA MATRICULA
			   IF lHayAlu

*                             MATRICULADO
				IF TRA->lSumarTra
				   nTotCre += TRA->nValorTra
				   aMatric[1,1] += TRA->nValorTra
				   nTotSdo += TRA->nValorTra
				ELSE
				   aMatric[1,2] += TRA->nValorTra
				   nTotDeb += TRA->nValorTra
				   nTotSdo -= TRA->nValorTra
				ENDIF
*                             FIN MATRICULADO

*                             DESCRIMINACION DE LA MATRICULA
				IF EMPTY(nHayErr)
				   aVlrCon := aMatric[1,3]
				   ConMtrExt(TRA->nValorTra,;
					     aVlrCon,'PMT','CMT')
				   aMatric[1,3] := aVlrCon
				ENDIF
*                             FIN DESCRIMINACION DE LA MATRICULA

			   ELSE

*                             POR MATRICULAR
				IF TRA->lSumarTra
				   nTotCre += TRA->nValorTra
				   aMatric[2,1] += TRA->nValorTra
				   nTotSdo += TRA->nValorTra
				ELSE
				   aMatric[2,2] += TRA->nValorTra
				   nTotDeb += TRA->nValorTra
				   nTotSdo -= TRA->nValorTra
				ENDIF
*                             FIN POR MATRICULAR

*                             DESCRIMINACION DE LA MATRICULA
				IF EMPTY(nHayErr)
				   aVlrCon := aMatric[2,3]
				   ConMtrExt(TRA->nValorTra,;
					     aVlrCon,'PMT','CMT')
				   aMatric[2,3] := aVlrCon
				ENDIF
*                             FIN DESCRIMINACION DE LA MATRICULA

			   ENDIF
*........................FIN ANALISIS DE LA MATRICULA

		    OTHERWISE

*........................OTRAS CONSIGNACIONES
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
*........................FIN OTRAS CONSIGNACIONES

		    ENDCASE

		 ENDIF
*--------------FIN ACUMULACION DE CONCEPTOS

	       TRA->(DBSKIP())

	    ENDDO
**********IMPRESION DEL MOVIMIENTO

**********IMPRESION POR RECIBOS DE PENSIONES
	    IF nCodCmv == 1 .OR. nCodCmv == 2

	       FOR i := 1 TO 13
		   IF aPagMes[i,1] # 0 .OR. aPagMes[i,2] # 0

*=====================IMPRESION DEL CONCEPTO DEL RECIBO
			cNombreTcm := IF(i#13,'RECIBOS DE '+cMes(i,3),;
					      'RECIBOS OTRO A¥O')
			cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			aRegPrn := {cNombreTcm,;
				    IF(aPagMes[i,1] == 0,SPACE(12),;
				       TRANS(aPagMes[i,1],"####,###,###.##")),;
				    IF(aPagMes[i,2] == 0,SPACE(12),;
				       TRANS(aPagMes[i,2],"####,###,###.##")),;
				    IF(aPagMes[i,1] - aPagMes[i,2] == 0,SPACE(12),;
				       TRANS(aPagMes[i,1] - aPagMes[i,2],"####,###,###.##"))}

			lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				nColCab,aTitPrn,aRegPrn,aNroCol,;
				bPagina,bDerAut,bCabeza)
*=====================FIN IMPRESION DEL CONCEPTO DEL RECIBO

*=====================IMPRESION DEL CONCEPTO DEL RECIBO DESCRIMINADO
			aVlrCon := aPagMes[i,3]
			FOR j := 1 TO LEN(aVlrCon)

			    cNomCon := ALLTRIM(aVlrCon[j,2])
			    cNomCon := SUBS(SPACE(02)+cNomCon+SPACE(40),1,40)

			    nConCre := aVlrCon[j,3]
			    nConDeb := aVlrCon[j,4]

			    IF nConCre # 0 .OR. nConDeb # 0
			       aRegPrn := {}
			       AADD(aRegPrn,cNomCon)
			       AADD(aRegPrn,IF(nConCre == 0,SPACE(12),TRANS(nConCre,"####,###,###.##")))
			       AADD(aRegPrn,IF(nConDeb == 0,SPACE(12),TRANS(nConDeb,"####,###,###.##")))
			       AADD(aRegPrn,IF(nConCre-nConDeb == 0,SPACE(12),TRANS(nConCre-nConDeb,"####,###,###.##")))

			       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				       nColCab,aTitPrn,aRegPrn,aNroCol,;
				       bPagina,bDerAut,bCabeza)
			    ENDIF

			ENDFOR
*=====================FIN IMPRESION DEL CONCEPTO DEL RECIBO DESCRIMINADO


		   ENDIF
	       ENDFOR
	    ENDIF
**********FIN IMPRESION POR RECIBOS DE PENSIONES

**********IMPRESION DE LOS ABONOS
	    IF nCodCmv == 3

	       FOR i := 1 TO 13
		   IF aAboMes[i,1] # 0 .OR. aAboMes[i,2] # 0

*=====================IMPRESION DEL CONCEPTO DE ABONO
			cNombreTcm := IF(i#13,'ABONOS DE '+cMes(i,3),;
					      'OTROS ABONOS')
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
*=====================FIN IMPRESION DEL CONCEPTO DE ABONO

*=====================IMPRESION DEL CONCEPTO DE ABONO DESCRIMINADO
			aVlrCon := aAboMes[i,3]
			FOR j := 1 TO LEN(aVlrCon)

			    cNomCon := ALLTRIM(aVlrCon[j,2])
			    cNomCon := SUBS(SPACE(02)+cNomCon+SPACE(40),1,40)

			    nVlrCon := aVlrCon[j,3]

			    aRegPrn := {}
			    AADD(aRegPrn,cNomCon)
			    AADD(aRegPrn,IF(nVlrCon == 0,SPACE(12),TRANS(nVlrCon,"####,###,###.##")))
			    AADD(aRegPrn,SPACE(12))
			    AADD(aRegPrn,SPACE(12))

			    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				    nColCab,aTitPrn,aRegPrn,aNroCol,;
				    bPagina,bDerAut,bCabeza)

			ENDFOR
*=====================FIN IMPRESION DEL CONCEPTO DE ABONO DESCRIMINADO

		   ENDIF
	       ENDFOR

	    ENDIF
**********FIN IMPRESION DE LOS ABONOS

**********IMPRESION DE LAS MATRICULAS
	    IF nCodCmv == 4

	       FOR i := 1 TO 2

		   IF aMatric[i,1] # 0 .OR. aMatric[i,2] # 0

*=====================IMPRESION DEL CONCEPTO DE MATRICULA
			cNombreTcm := IF(i==1,'MATRICULADOS',;
					      'POR MATRICULAR')
			cNombreTcm := SUBS(cNombreTcm+SPACE(40),1,40)

			aRegPrn := {cNombreTcm,;
				    IF(aMatric[i,1] == 0,SPACE(12),;
				       TRANS(aMatric[i,1],"####,###,###.##")),;
				    IF(aMatric[i,2] == 0,SPACE(12),;
				       TRANS(aMatric[i,2],"####,###,###.##")),;
				    IF(aMatric[i,1]-aMatric[i,2]== 0,SPACE(12),;
				       TRANS(aMatric[i,1]-aMatric[i,2],"####,###,###.##"))}

			lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
				aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,;
				bCabeza)
*=====================FIN IMPRESION DEL CONCEPTO DE MATRICULA

*=====================IMPRESION DEL CONCEPTO DE MATRICULA DESCRIMINADO
			aVlrCon := aMatric[i,3]
			FOR j := 1 TO LEN(aVlrCon)

			    cNomCon := ALLTRIM(aVlrCon[j,2])
			    cNomCon := SUBS(SPACE(02)+cNomCon+SPACE(40),1,40)

			    nVlrCon := aVlrCon[j,3]

			    aRegPrn := {}
			    AADD(aRegPrn,cNomCon)
			    AADD(aRegPrn,IF(nVlrCon == 0,SPACE(12),TRANS(nVlrCon,"####,###,###.##")))
			    AADD(aRegPrn,SPACE(12))
			    AADD(aRegPrn,SPACE(12))

			    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,;
				    nColCab,aTitPrn,aRegPrn,aNroCol,;
				    bPagina,bDerAut,bCabeza)

			ENDFOR
*=====================FIN IMPRESION DEL CONCEPTO DE MATRICULA DESCRIMINADO

		   ENDIF
	       ENDFOR

	    ENDIF
**********FIN IMPRESION DE LAS MATRICULAS

**********IMPRESION DE OTRAS CONSIGNACIONES
	    IF (nVlrCre # 0 .OR. nVlrDeb # 0) .AND.;
	       (nCodCmv # 1 .AND.;
		nCodCmv # 2 .AND.;
		nCodCmv # 3)

		aRegPrn := {cNomCmv,;
			    IF(nVlrCre == 0,SPACE(12),;
					   TRANS(nVlrCre,"####,###,###.##")),;
			    IF(nVlrDeb == 0,SPACE(12),;
					   TRANS(nVlrDeb,"####,###,###.##")),;
			    IF(nVlrCre - nVlrDeb == 0,SPACE(12),;
			       TRANS(nVlrCre - nVlrDeb,"####,###,###.##"))}

		lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DE OTRAS CONSIGNACIONES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT CMV
	    CMV->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDFOR
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN RECORRIDO POR CONCEPTOS DE MOVIMIENTOS

*>>>>IMPRESION DE LOS TOTALES
       SET DEVICE TO PRINT
       @ PROW()+1,nColCab+nColTxt(aNroCol,02) SAY REPL('-',aNroCol[02])
       @ PROW()  ,nColCab+nColTxt(aNroCol,03) SAY REPL('-',aNroCol[03])

       aTitulo := {'',REPL('-',aNroCol[02]),;
		      REPL('-',aNroCol[03]),;
		      REPL('-',aNroCol[04])}

       aTitulo := {'TOTALES ...',;
		   TRANS(nTotCre,"####,###,###.##"),;
		   TRANS(nTotDeb,"####,###,###.##"),;
		   TRANS(nTotSdo,"####,###,###.##")}

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

       IF LEN(aTotErr) == 0
	  RESTSCREEN(0,0,24,79,cSavPan)
	  RETURN NIL
       ENDIF
       cError('EXISTEN INCONSISTENCIAS',;
	      'ATENCION','PREPARE LA IMPRESORA')
*>>>>FIN IMPRESION DERECHOS

*>>>>GESTION DOCUMENTAL DEL INFORME
       aP3 := {}
       AADD(aP3,{'nNroInf',0})
     *ÀN£mero de identificaci¢n del informe

       AADD(aP3,{'cOpcSys',''})
     *ÀOpci¢n del sistema del informe

       AADD(aP3,{'cCodInf',''})
     *ÀC¢digo del Informe

       aMarInf := {}
       AADD(aMarInf,{0,0}) // MS:ID
       AADD(aMarInf,{0,0}) // MI:ID
       AADD(aMarInf,{0,0}) // M1:ID
       AADD(aMarInf,{0,0}) // M2:ID
       AADD(aP3,{'aMarInf',aMarInf})
     *ÀMargenes del Informe

       AADD(aP3,{'nNroDoc',0})
     *ÀInforme por defecto

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
       AADD(aP3,{'aMezIso',aMezIso})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		    'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		    '. A¥O: <cAnoUsr>'))                  // T¡tulo Uno
       AADD(aTitIso,'MOVIMIENTOS POR CONCEPTOS')          // T¡tulo Dos
       AADD(aTitIso,'INCONSISTENCIAS')                    // T¡tulo Tres
       AADD(aP3,{'aTitIso',aTitIso})
     *ÀT¡tulos del Informe por defecto

       AADD(aP3,{'cPiePag',CAR->cPiePagCar})
     *ÀPie de p gina por defecto

       aPieIso := {}
       AADD(aPieIso,'')                     // Pie de p gina Uno
       AADD(aPieIso,'')                     // Pie de p gina Dos
       AADD(aPieIso,'')                     // Pie de p gina Tres
       AADD(aP3,{'aPieIso',aPieIso})
     *ÀPie de p ginas por defecto

       aObsIso := {}
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aObsIso,'')
       AADD(aP3,{'aObsIso',aObsIso})
     *ÀObservaciones

       AADD(aP3,{'cUsrIso',CAR->cUsrIsoCar})
     *ÀUsuario del Iso

       AADD(aP3,{'oBrowse',oBrowse})
     *ÀBrowse del Archivo
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nOpcPrn := 0
       AADD(aP3,{'FilePrn','errext'})
       AADD(aP3,{'cOpcPrn',CAR->cOpcPrnCar})
       AADD(aP3,{'nCodXsl',CAR->nCodXslCar})
       AADD(aP3,{'nOpcPrn',nOpcPrn})
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,12)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,06)
       AADD(aTitPrn,'GRUPO')

       AADD(aNroCol,80)
       AADD(aTitPrn,'OBSERVACION')

       AADD(aP3,{'aNroCol',aNroCol})
       AADD(aP3,{'aTitPrn',aTitPrn})

       aCabSec := {}
       AADD(aP3,{'aCabSec',aCabSec})
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>IMPRESION DEL INFORME
       AADD(aP3,{'aTotReg',aTotErr})
       InfPrn00(aP1,aP2,aP3)
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

