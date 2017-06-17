/*************************************************************************
* TITULO ..: TOTAL CONSIGNACIONES POR GRUPOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 27/99 JUE A
       Colombia, Bucaramanga        INICIO: 12:20 PM   MAY 27/99 JUE

OBJETIVOS:

1- Imprime el total o consignaciones por grupos de los conceptos 1,2,3,4

2- Valida los pagos en la cartera contra los pagos del Banco.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt24(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

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
       LOCAL aGruCre[4]                     // Cr‚ditos por grupos
       LOCAL aGruDeb[4]                     // D‚bitos por grupos
       LOCAL aNivCre[4]                     // Cr‚ditos por niveles
       LOCAL aNivDeb[4]                     // D‚bitos por niveles
       LOCAL aTotCre[4]                     // Cr‚ditos por totales
       LOCAL aTotDeb[4]                     // D‚bitos por totales
       LOCAL aOtrCre[4]                     // Cr‚ditos Varios
       LOCAL aOtrDeb[4]                     // D‚bitos Varios

       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lValida := .F.                 // .T. Imprimir por detalle
       LOCAL lHayGru := .F.                 // .T. Hay Grupo
       LOCAL nVlrOtr := 0                   // Valor de otros
       LOCAL cNivAnt := ''                  // Nivel Anterior
       LOCAL cNivAct := ''                  // Nivel Actual
     *ÀVariables espec¡ficas

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n

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

*>>>>LECTURA DE PATHS
       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       CreaDbfGru(lShared,DIRNAME(),FileTem)

       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'FUE',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('FUE')
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
	      CloseDbf('GRU')
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
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>GRABACION DE UN GRUPO ADICIONAL
       IF FUE->(lRegLock(lShared,.T.))
	  REPL FUE->cCodigoGru WITH 'OTRO'
	  FUE->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA LA FORMA DE PAGO')
       ENDIF
       IF lShared
	  FUE->(DBUNLOCK())
       ENDIF
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN GRABACION DE UN GRUPO ADICIONAL

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       DO CASE
       CASE TRA->(RECCOUNT()) == 0
	    cError('NO EXISTEN TRANSACIONES REGISTRADOS')
	    IF !lFileDelete(FileTem)
	       cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	    ENDIF
	    RETURN NIL
       ENDCASE
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>INDEXACION DEL ARCHIVO
       SELECT TRA
       fNtxMoB := BAN->cCodigoBan+cAnoUsr+cNroMes+cExtNtx
       INDEX ON TRA->cCodigoEst TO &(cPatSis+'\MODEM\'+fNtxMoB)
*>>>>FIN INDEXACION DEL ARCHIVO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE GRU->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS GRUPOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',22,NIL,NIL,20,60)
       IF !lIntervGru(nNroFil,21,@nRegIni,@nRegFin)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RESTSCREEN(0,0,24,79,cSavPan)
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

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseDbf('GRU')
	  SELECT TRA
	  SET INDEX TO
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  IF !lFileDelete(FileTem)
	     cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	  ENDIF
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       ActivaPrn(lShared,cNomSis,PathSis,fSimCar,'cColaAcCar','Car',,nModCry)
*>>>>FIN ANALISIS DE DECISION

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		   '. A¥O: '+cAnoUsr,;
		   'CONSIGNACIONES POR GRUPOS',;
		   '',;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {142}
       aTitulo := {'GRUPO'      +SPACE(01)+'|'+SPACE(11)+;
		   'MES ACTUAL' +SPACE(12)+'|'+SPACE(11)+;
		   'OTROS MESES'+SPACE(11)+'|'+SPACE(14)+;
		   'ABONOS'     +SPACE(13)+'|'+SPACE(12)+;
		   'MATRICULAS' +SPACE(10)}
       cCabCol := cRegPrint(aTitulo,aNroCol)
       aNroCol := {06,16,16,16,16,16,16,16,16}
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
	     CloseDbf('GRU')
	     SELECT TRA
	     SET INDEX TO
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

*>>>>INICIALIZACION DEL GRUPO
       FOR i := 1 TO 4
	   aNivCre[i] := 0
	   aTotCre[i] := 0
	   aOtrCre[i] := 0

	   aNivDeb[i] := 0
	   aTotDeb[i] := 0
	   aOtrDeb[i] := 0
       ENDFOR
*>>>>FIN INICIALIZACION DEL GRUPO

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       cNivAnt := SUBS(GRU->cCodigoGru,1,2)
       DO WHILE RECNO() <= nRegFin

**********INICIALIZACION DEL GRUPO
	    FOR i := 1 TO 4
		aGruCre[i] := 0
		aGruDeb[i] := 0
	    ENDFOR
**********FIN INICIALIZACION DEL GRUPO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT TRA
	    GO TOP
	    DO WHILE .NOT. TRA->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('GRUPO: '+GRU->cCodigoGru+'/'+cGruFin+'º'+;
			     'REFERENCIA: '+TRA->cCodRefTra,cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS DEL CODIGO DEL CONCEPTO
		 IF !(TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2 .OR.;
		      TRA->nCodigoCmv == 3 .OR. TRA->nCodigoCmv == 4)
		    SELECT TRA
		    DBSKIP()
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DEL CODIGO DEL CONCEPTO

*--------------BUSQUEDA DEL ESTUDIANTE
		 lHayGru := .F.
		 IF lSekCodMae(TRA->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		    IF &cMaeAct->cCodigoGru == GRU->cCodigoGru
		       lHayGru := .T.
		    ELSE
		       SELECT TRA
		       DBSKIP()
		       LOOP
		    ENDIF
		 ENDIF
*--------------FIN BUSQUEDA DEL ESTUDIANTE

*--------------TOTALIZACION DE LOS CONCEPTOS
		 IF lHayGru
		    IF TRA->lSumarTra
		       aGruCre[TRA->nCodigoCmv] += TRA->nValorTra
		       aNivCre[TRA->nCodigoCmv] += TRA->nValorTra
		       aTotCre[TRA->nCodigoCmv] += TRA->nValorTra
		    ELSE
		       aGruDeb[TRA->nCodigoCmv] += TRA->nValorTra
		       aNivDeb[TRA->nCodigoCmv] += TRA->nValorTra
		       aTotDeb[TRA->nCodigoCmv] += TRA->nValorTra
		    ENDIF
		 ELSE
		    IF GRU->cCodigoGru == 'OTRO'
		       IF TRA->lSumarTra
			  aOtrCre[TRA->nCodigoCmv] += TRA->nValorTra
			  aTotCre[TRA->nCodigoCmv] += TRA->nValorTra
		       ELSE
			  aOtrDeb[TRA->nCodigoCmv] += TRA->nValorTra
			  aTotDeb[TRA->nCodigoCmv] += TRA->nValorTra
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN TOTALIZACION DE LOS CONCEPTOS

*--------------IMPRESION DEL REGISTRO DEL ESTUDIANTE
		 IF (lValida .AND. lHayGru) .OR.;
		    (lValida .AND. GRU->cCodigoGru == 'OTRO')
		    aTitulo := {TRA->cCodigoEst,;
				IF(TRA->nCodigoCmv == 1 .AND. TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 1 .AND. !TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 2 .AND. TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 2 .AND. !TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 3 .AND. TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 3 .AND. !TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 4 .AND. TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),''),;
				IF(TRA->nCodigoCmv == 4 .AND. !TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.99"),'')}
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO DEL ESTUDIANTE

	       SELECT TRA
	       SKIP

	    ENDDO
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********IMPRESION DE LOS TOTALES DEL GRUPO
	    IF GRU->cCodigoGru # 'OTRO'
	       aTitulo := {GRU->cCodigoGru,;
			   TRANS(aGruCre[1],"####,###,###.99"),;
			   TRANS(aGruDeb[1],"####,###,###.99"),;
			   TRANS(aGruCre[2],"####,###,###.99"),;
			   TRANS(aGruDeb[2],"####,###,###.99"),;
			   TRANS(aGruCre[3],"####,###,###.99"),;
			   TRANS(aGruDeb[3],"####,###,###.99"),;
			   TRANS(aGruCre[4],"####,###,###.99"),;
			   TRANS(aGruDeb[4],"####,###,###.99")}
	       cTxtPrn := cRegPrint(aTitulo,aNroCol)
	       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	    ENDIF
**********FIN IMPRESION DE LOS TOTALES

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

**********CONTROL PARA EL CAMBIO DE NIVEL
	    cNivAct := SUBS(GRU->cCodigoGru,1,2)
	    IF cNivAnt # cNivAct .AND. GRU->cCodigoGru # 'OTRO'

*--------------IMPRESION DE LOS TOTALES POR NIVEL
		 aTitulo := {}
		 AADD(aTitulo,SPACE(04))
		 AADD(aTitulo,REPL('-',aNroCol[02]))
		 AADD(aTitulo,REPL('-',aNroCol[03]))
		 AADD(aTitulo,REPL('-',aNroCol[04]))
		 AADD(aTitulo,REPL('-',aNroCol[05]))
		 AADD(aTitulo,REPL('-',aNroCol[06]))
		 AADD(aTitulo,REPL('-',aNroCol[07]))
		 AADD(aTitulo,REPL('-',aNroCol[08]))
		 AADD(aTitulo,REPL('-',aNroCol[09]))
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		 aTitulo := {}
		 AADD(aTitulo,SUBS(cNivAnt,1,2))
		 AADD(aTitulo,TRANS(aNivCre[1],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivDeb[1],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivCre[2],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivDeb[2],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivCre[3],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivDeb[3],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivCre[4],"####,###,###.99"))
		 AADD(aTitulo,TRANS(aNivDeb[4],"####,###,###.99"))
		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 @ PROW()+1,00 SAY ''
*--------------FIN IMPRESION DE LOS TOTALES POR NIVEL

*--------------INICIALIZACION DE VALORES
		 FOR i := 1 TO 4
		     aNivCre[i] := 0
		     aNivDeb[i] := 0
		 ENDFOR
		 cNivAnt := cNivAct
*--------------FIN INICIALIZACION DE VALORES

	    ENDIF
**********FIN CONTROL PARA EL CAMBIO DE NIVEL

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION DE LOS TOTALES DE VARIOS
       nVlrOtr := 0
       FOR i := 1 TO 4
	   nVlrOtr += aOtrCre[i]
       ENDFOR
       IF !EMPTY(nVlrOtr)
	  aTitulo := {'VARIOS',;
		      TRANS(aOtrCre[1],"####,###,###.99"),;
		      TRANS(aOtrDeb[1],"####,###,###.99"),;
		      TRANS(aOtrCre[2],"####,###,###.99"),;
		      TRANS(aOtrDeb[2],"####,###,###.99"),;
		      TRANS(aOtrCre[3],"####,###,###.99"),;
		      TRANS(aOtrDeb[3],"####,###,###.99"),;
		      TRANS(aOtrCre[4],"####,###,###.99"),;
		      TRANS(aOtrDeb[4],"####,###,###.99")}
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF
*>>>>FIN IMPRESION DE LOS TOTALES DE VARIOS

*>>>>IMPRESION DEL GRAN TOTAL
       aTitulo := {}
       AADD(aTitulo,SPACE(04))
       AADD(aTitulo,REPL('=',aNroCol[02]))
       AADD(aTitulo,REPL('=',aNroCol[03]))
       AADD(aTitulo,REPL('=',aNroCol[04]))
       AADD(aTitulo,REPL('=',aNroCol[05]))
       AADD(aTitulo,REPL('=',aNroCol[06]))
       AADD(aTitulo,REPL('=',aNroCol[07]))
       AADD(aTitulo,REPL('=',aNroCol[08]))
       AADD(aTitulo,REPL('=',aNroCol[09]))
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

       aTitulo := {}
       AADD(aTitulo,'TOTAL')
       AADD(aTitulo,TRANS(aTotCre[1],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotDeb[1],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotCre[2],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotDeb[2],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotCre[3],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotDeb[3],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotCre[4],"####,###,###.99"))
       AADD(aTitulo,TRANS(aTotDeb[4],"####,###,###.99"))
       cTxtPrn := cRegPrint(aTitulo,aNroCol)
       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       @ PROW()+1,00 SAY ''
*>>>>FIN IMPRESION DEL GRAN TOTAL

*>>>>CIERRE DE ARCHIVOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       CloseDbf('GRU')
       SELECT TRA
       SET INDEX TO
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>FIN CIERRE DE ARCHIVOS
