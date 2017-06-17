/*************************************************************************
* TITULO ..: REGISTROS NO PROCESADOS                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:20 PM   MAY 27/99 JUE

OBJETIVOS:

1- Consulta y permite imprimir los registros no procesados.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrTra033(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse,cModem,cNroDia)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo
       cModem                               // Banco de la Gerencia
       cNroDia                              // N£mero del D¡a */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL oBrwTra := NIL                 // Browse de Registros no procesados
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cTitDos := ''                  // T¡tulo dos para el informe
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nNroCol := 0                   // N£mero de la Columna

       LOCAL GetList := {}                  // Variable del Sistema
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

*>>>>PREPARACION DE VARIABLES DE ARCHIVO
       IF EMPTY(cNroDia)
	  fNtxTra := 'PA'+cAnoUsr+cNroMes+cExtNtx
       ELSE
	  fNtxTra := cAnoUsr+cNroMes+cNroDia+cExtNtx
       ENDIF
*>>>>FIN PREPARACION DE VARIABLES DE ARCHIVO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LAS TRANSACIONES
       SELECT TRA
       SET FILTER TO TRA->nValidaTra == 0
       GO TOP
       IF EOF()
	  cError('NO HAY INCONSISTENCIAS')
	  SET FILTER TO
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LAS TRANSACIONES

*>>>>CONSULTA DE LAS INCONSISTENCIAS
       cSavPan := SAVESCREEN(0,0,24,79)
       oBrwTra := oDefBrwTra(nFilPal+1,00,22,79,cMaeAlu,cAnoUsr,;
		  CAA->cAnoAluCaA,VAL(cNroMes),cNroMes,;
		  '<<REGISTROS NO PROCESADOS. MES '+cMes(VAL(cNroMes),10)+;
		  IF(EMPTY(cNroDia),'',' DIA: '+cNroDia)+' >>','<ESC>Abandonar')

       TRA->(CtrlBrw(lShared,oBrwTra))
       SET FILTER TO
*>>>>FIN CONSULTA DE LAS INCONSISTENCIAS

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA IMPRIMIR LOS REGISTROS NO PROCESADOS? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>IMPRESION DE N COPIAS
       nCopias := 1
       DO WHILE nNroCop <= nCopias

	  PrnTra03(lShared,nModCry,cNomEmp,cNomSis,cNomUsr,;
		   cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cNroMes,;
		   cNroDia)
	 *Impresi¢n registros no procesados

	  nNroCop++

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DE N COPIAS



***************************************************************************
*----------------------------FIN DEL PROGRAMA ----------------------------*
*--------------- DECLARACION DE FUNCIONES PARA EL PROGRAMA ---------------*
***************************************************************************

/*************************************************************************
* TITULO DE LA FUNCION..: IMPRESION DE LOS REGISTROS NO PROCESADOS       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 12/95 LUN A
       Bucaramanga,Colombia         INICIO: 11:20 PM   JUN 12/95 LUN

OBJETIVOS:

1- Imprime los registros no procesados.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnTra03(lShared,nModCry,cNomEmp,cNomSis,cNomUsr,;
		  cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cNroMes,;
		  cNroDia)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomEmp                              // Nombre de la empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del Usuario
       cPatSis                              // Path del Sistema
       cMaeAlu                              // Maestros Habilitados
       cMaeAct                              // Maestro Actual
       cNroMes                              // N£mero del mes
       cNroDia                              // N£mero del Dia */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

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

       LOCAL lAnoAct := .T.                // .T. A¤o Actual
       LOCAL nNumero := 0                  // N£mero de registros
       LOCAL nNroReg := 0                  // N£mero de Registro
       LOCAL cNroLis := ''                 // N£mero de Lista
       LOCAL lHayAlu := .T.                // .T. Existe alumno
       LOCAL cMesPag := ''                 // Meses de pago
       LOCAL nVlrPag := 0                  // Valor pagado
       LOCAL nVlrTra := 0                  // Valor de la transaci¢n
       LOCAL aRegAct := {}                 // Registro Actual
       LOCAL lHayPag := .F.                // .T. Hay Pago
       LOCAL cCodAct := ''                 // C¢digo Actual
       LOCAL cCodAnt := ''                 // C¢digo Anterior
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables Espec¡ficas

       LOCAL cNombreTes := ''              // Nombre del Estudiante
       LOCAL cCodigoTgr := ''              // C¢digo del grupo
       LOCAL cObservTtr := ''              // Observaci¢n de la Transaci¢n

       LOCAL nMesIniTtr := 0                // Mes Inicial
       LOCAL nMesFinTtr := 0                // Mes Final
     *ÀVariables de Campos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'MOVIMIENTOS DEL MES DE '+cMes(VAL(cNroMes))+;
		   IF(EMPTY(cNroDia),'',' DIA:'+cNroDia)+;
		   '. A¥O: '+cAnoUsr,;
		   'REGISTROS NO PROCESADOS E INCONSISTENCIAS',;
		   'Nota: La confiabilidad depende del Cajero',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,12,36,04,12,12,40,12,12}
       aTitulo := {'Nro.',;
		   'REFERENCIA',;
		   'APELLIDOS Y NOMBRES ',;
		   'TRAN',;
		   'VALOR',;
		   'FECHA.PAGO',;
		   'OBSERVACION'}
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
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT TRA
       GO TOP
       nTotReg := TRA->(RECCOUNT())
       cCodAnt := TRA->cCodigoEst
       DO WHILE .NOT. EOF()

	  nMesIniTtr := VAL(SUBS(TRA->cCodRefTra,7,2))
	  nMesFinTtr := VAL(SUBS(TRA->cCodRefTra,9,2))

**********BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
	    nNroReg++
	    cCodAct := TRA->cCodigoEst
	    lHayAlu := lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
	    IF lHayAlu
	       cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
			     RTRIM(&cMaeAct->cNombreEst)
	       cCodigoTgr := &cMaeAct->cCodigoGru
	    ELSE
	       cNombreTes := 'POR FAVOR REVISAR? '
	       cCodigoTgr := SPACE(04)
	    ENDIF
	    cNombreTes := SUBS(cNombreTes+SPACE(33),1,33)
**********FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    IF !EMPTY(cCodigoTgr)
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       FileCli := cPatSis+'\CLIENTES\CL'+cCodigoTgr+cAnoSis+ExtFile
	       FilePag := cPatSis+'\PAGOS\PA'+cCodigoTgr+cAnoSis+ExtFile
	    ENDIF
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !EMPTY(cCodigoTgr)
	       IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
		  !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
		  cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
		  VerPrn(nOpcPrn,FilePrn)
		  CloseDbf('CLI',FileCli,nModCry)
		  CloseDbf('PAG',FilePag,nModCry)
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    IF !EMPTY(cCodigoTgr)
	       lHayErr := .T.
	       DO CASE
	       CASE CLI->(RECCOUNT()) == 0
		    cError('NO EXISTEN CLIENTES GRABADOS')

	       CASE PAG->(RECCOUNT()) == 0
		    cError('NO EXISTEN PAGOS GRABADOS')
	       OTHERWISE
		    lHayErr :=.F.
	       ENDCASE
	       IF lHayErr
		  VerPrn(nOpcPrn,FilePrn)
		  CloseDbf('CLI',FileCli,nModCry)
		  CloseDbf('PAG',FilePag,nModCry)
		  RETURN NIL
	       ENDIF
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LOCALIZACION EN CLIENTES
	    IF !EMPTY(cCodigoTgr)
	       IF lLocCodigo('cCodigoEst','CLI',TRA->cCodigoEst)
		  cNroLis := STR(CLI->(RECNO()),2)
	       ELSE
		  cNroLis := 'ERR'
		  cError(cNombreTes+' NO EXISTE EN LOS '+;
			 'CLIENTES DEL GRUPO: '+cCodigoTgr)
	       ENDIF
	    ELSE
	       cNroLis := SPACE(04)
	    ENDIF
	    cObservTtr := TRA->cObservTra
**********FIN LOCALIZACION EN CLIENTES

**********LOCALIZACION DEL PAGO
	    lHayPag := .F.
	    IF lHayAlu .AND. TRA->nValidaTra # 0
	       lHayPag := lLocCodPag(TRA->cCodigoEst,nMesIniTtr,.F.)
	       IF !lHayPag
		  cError('NO SE LE GENERO RECIBO DE PAGO A '+cNombreTes+;
			 'CODIGO: '+TRA->cCodigoEst)
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL PAGO

**********ANALISIS DEL PAGO
	    IF lHayAlu .AND. lHayPag
	       nVlrTra := 0
	       aRegAct := {}
	       DO WHILE PAG->cCodigoEst == TRA->cCodigoEst .AND.;
			!(nMesIniTtr < 1 .OR. nMesIniTtr > 12  .OR.;
			  nMesFinTtr < 1 .OR. nMesFinTtr > 12) .AND.;
			  !(nMesIniTtr # PAG->nMesIniPag)

		  nVlrTra += TRA->nValorTra
		  AADD(aRegAct,TRA->(RECNO()))
		  TRA->(DBSKIP())

	       ENDDO
	       IF EMPTY(aRegAct)
		  cError('EN EL VECTOR DE LOS PAGOS')
	       ENDIF
	       SELECT TRA
	       GO aRegAct[1]
	    ENDIF
**********FIN ANALISIS DEL PAGO

**********VALIDACION DEL PAGO
	    lHayErr := .F.
	    IF lHayAlu .AND. lHayPag

*--------------ANALISIS DEL PAGO
		 nVlrPag := 0
		 DO CASE
		 CASE PAG->cEstadoPag == 'P'
		      nVlrPag := PAG->nVlrPagPag

		 CASE PAG->cEstadoPag == 'A'
		      nVlrPag := PAG->nVlrPagPag+;
				 nVlrIntPag(CAA->lIntPenCaA,;
					    PAG->nMesIniPag,;
					    CAA->nMesAmnCaA)
		 ENDCASE
*--------------FIN ANALISIS DEL PAGO

*--------------ANALISIS DE VALIDACION
		 DO CASE
		 CASE nVlrPag # 0 .AND.;
		      PAG->cCodigoEst == TRA->cCodigoEst .AND.;
		      nVlrPag # nVlrTra .AND. cCodAct # cCodAnt

		      lHayErr := .T.
		      IF EMPTY(cObservTtr)
			 cObservTtr := 'EL PAGO NO COINCIDE'
		      ELSE
			 cObservTtr := ALLTRIM(cObservTtr)+' '+;
				       'EL PAGO NO COINCIDE'
		      ENDIF

		 CASE CAA->lLeeFecCaA .AND.;
		      PAG->cCodigoEst == TRA->cCodigoEst .AND.;
		      PAG->dFecPagPag # TRA->dFechaTra

		      lHayErr := .T.
		      IF EMPTY(cObservTtr)
			 cObservTtr := 'FECHA DE PAGO DIFERENTE:'+;
				       SUBS(cFecha(PAG->dFecPagPag),1,6)
		      ELSE
			 cObservTtr := ALLTRIM(cObservTtr)+' '+;
				       'FECHA DE PAGO DIFERENTE:'+;
				       SUBS(cFecha(PAG->dFecPagPag),1,6)
		      ENDIF

		 ENDCASE
*--------------FIN ANALISIS DE VALIDACION

	    ENDIF
	    cObservTtr := SUBS(cObservTtr+SPACE(40),1,40)
**********FIN VALIDACION DEL PAGO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('MES: '+cMes(nMesIniTtr,3)+;
			'ºCODIGO: '+TRA->cCodigoEst+' '+;
			SUBS(cNombreTes+SPACE(20),1,20)+;
			'ºGRUPO: '+cCodigoTgr+;
			'ºREG: '+STR(nNroReg,5)+'/'+;
			  STR(nTotReg,5),cNomSis)
	    SET DEVICE TO PRINT
**********IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL CONTENIDO DEL INFORME
	    IF TRA->nValidaTra == 0 .OR. lHayErr

	       cMesPag := STR(nMesIniTtr,2)+'-'+;
			  STR(nMesFinTtr,2)
	       aTitulo := {STR(++nNumero,4),;
			   TRA->cCodRefTra,;
			   SPACE(01)+cNombreTes,;
			   SPACE(01)+TRA->cCodigoTra,;
			   TRANS(TRA->nValorTra,"#####,###.99"),;
			   cFecha(TRA->dFechaTra),;
			   IF(TRA->lRegOkTra .AND. EMPTY(cObservTtr),;
			      'CORREGIDO?:',cObservTtr)}

	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

	    ENDIF
**********FIN IMPRESION DEL CONTENIDO DEL INFORME

**********ANALISIS DEL CODIGO ANTERIOR
	    IF cCodAnt # cCodAct
	       cCodAnt := cCodAct
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR

	  SELECT TRA
	  TRA->(DBSKIP())

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
       CloseDbf('PAG',FilePag,nModCry)
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS