/*************************************************************************
* TITULO ..: CONSIGNACIONES POR GRUPOS                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 26/99 MIE A
       Colombia, Bucaramanga        INICIO: 09:30 PM   MAY 26/99 MIE

OBJETIVOS:

1- Imprime los pagos o consignaciones por grupos.

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt23(aParam1,aParam2,aParam3,;
		   cNroMes,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

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

       LOCAL lHayAlu := .T.                // .T. Existe alumno
       LOCAL nVlrGru := 0                  // Valor del Grupo
       LOCAL lPrimer := .T.                // .T. Primera pasada
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''              // Nombre del Estudiante
       LOCAL cCodigoTgr := ''              // C¢digo del grupo

       LOCAL nCopias := 0                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia

       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL cTitDos := ''                  // T¡tulo dos para el informe
       LOCAL cNalias := ''                  // Alias del maestro
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cGruFin := ''                  // Grupo final de impresi¢n
       LOCAL nVlrTot := 0                   // Valor Total

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila

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
       CloseDbf('FUE')
       CloseDbf('GRU')
*>>>>FIN CREACION DE TODOS LOS GRUPOS

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
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LOS GRUPOS',22,;
			 NIL,NIL,20,60)
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
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
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
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF CAR->lPrnArcCar
	  SET DEVICE TO PRINT
       ELSE

	  FilePrn := BAN->cCodigoBan+'BANGRU'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)

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
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********DEFINCION DEL ENCABEZADO
	    nNroPag := 0
	    lTamAnc := .F.

	    nTotReg := TRA->(RECCOUNT())+nLinTot
	    aCabeza := {cNomEmp,cNomSis,;
			'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
			'. A¥O: '+cAnoUsr,;
			'CONSIGNACIONES MES ACTUAL',;
			'GRUPO: '+cConverNiv(SUBS(GRU->cCodigoGru,1,2))+;
					     SUBS(GRU->cCodigoGru,3,2)+;
			' JORNADA: '+cJorTxt+'. A¥O: '+cAnoUsr,;
			nNroPag++,;
			cTotPagina(nTotReg),lTamAnc}

/*
	    cCodIni := DRAFT_ON+PICA+CONDEN_ON
	    cCodFin := NEGRA_OF+DOBGOL_OF
*/

**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    aNroCol := {02,06,06,40,04,16,12,10,12,22}
	    aTitulo := {'No',;
			'CURSO',;
			'CODIGO',;
			'APELLIDOS Y NOMBRES ',;
			'TRAN',;
			'TOTAL PAGADO',;
			'FECHA',;
			'MESES.FA',;
			'REFERENCIA',;
			'OBSERVACION'}
	    cCabCol := cRegPrint(aTitulo,aNroCol)
**********FIN ENCABEZADOS DE COLUMNA

**********ANALISIS PARA CENTRAR EL INFORME
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
**********FIN ANALISIS PARA CENTRAR EL INFORME

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       VerPrn(nOpcPrn,FilePrn)
	       SET DEVICE TO SCREEN
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES')
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT TRA
	       SET INDEX TO
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
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
	       SET DEVICE TO SCREEN
	       CloseDbf('GRU')
	       CloseDbf('CLI',FileCli,nModCry)
	       SELECT TRA
	       SET INDEX TO
	       oBrowse:GOTOP()
	       oBrowse:FORCESTABLE()
	       IF !lFileDelete(FileTem)
		  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
	       ENDIF
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO EL GRUPO: '+GRU->cCodigoGru+'º'+;
			'HASTA EL GRUPO: '+cGruFin+'ºESPERE',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL ENCABEZADO
	    EVAL(bCabeza)
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL CUERPO DEL INFORME
	    SELECT CLI
	    GO TOP
	    nVlrGru := 0
	    DO WHILE .NOT. EOF()

*--------------BUSQUEDA DEL NOMBRE DEL ESTUDIANTE
		 cMaeAct := cAliasNiv(VAL(SUBS(GRU->cCodigoGru,1,2)))
		 lHayAlu := lSekCodigo(CLI->cCodigoEst,cMaeAct)
		 IF lHayAlu
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		    cCodigoTgr := GRU->cCodigoGru
		 ELSE
		    cNombreTes := 'POR FAVOR REVISAR? '
		    cCodigoTgr := SPACE(04)
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(39),1,39)
*--------------FIN BUSQUEDA DEL NOMBRE DEL ESTUDIANTE

*--------------REGISTRO PARA EL NO PAGO O OTRO GRUPO
		 aTitulo := {STR(CLI->(RECNO()),2),;
			     cCodigoTgr,;
			     CLI->cCodigoEst,;
			     SPACE(01)+cNombreTes,;
			     SPACE(04),;
			     SPACE(16),;
			     SPACE(12),;
			     SPACE(10),;
			     SPACE(12),;
			     IF(CLI->lRetGruCli,'OTRO GRUPO',;
				     'NO LE FIGURA PAGO')}
*--------------FIN REGISTRO PARA EL NO PAGO O OTRO GRUPO


*--------------IMPRESION DEL CONTENIDO DEL INFORME
		 IF !CLI->lRetGruCli .AND.;
		    lSekCodigo(CLI->cCodigoEst,'TRA')

		    lPrimer := .T.
		    DO WHILE CLI->cCodigoEst == SUBS(TRA->cCodRefTra,1,6) .AND.;
			     (TRA->nCodigoCmv == 1 .OR. TRA->nCodigoCmv == 2)


		       IF TRA->lSumarTra
			  nVlrGru += TRA->nValorTra
		       ELSE
			  nVlrGru -= TRA->nValorTra
		       ENDIF

		       IF lPrimer


			  aTitulo := {STR(CLI->(RECNO()),2),;
				      &cMaeAct->cCodigoGru,;
				      CLI->cCodigoEst,;
				      SPACE(01)+cNombreTes,;
				      TRA->cCodigoTra,;
				      TRANS(TRA->nValorTra,"####,###,###.99"),;
				      cFecha(TRA->dFechaTra),;
				      cMes(VAL(SUBS(TRA->cCodRefTra,7,2)),3)+;
				      cMes(VAL(SUBS(TRA->cCodRefTra,7,2)),3),;
				      TRA->cCodRefTra,;
				      SPACE(22)}

		       ELSE

			  aTitulo := {'',;
				      '',;
				      '',;
				      '',;
				      TRA->cCodigoTra,;
				      TRANS(TRA->nValorTra,"####,###,###.99"),;
				      cFecha(TRA->dFechaTra),;
				      cMes(VAL(SUBS(TRA->cCodRefTra,7,2)),3)+;
				      cMes(VAL(SUBS(TRA->cCodRefTra,7,2)),3),;
				      TRA->cCodRefTra,;
				      SPACE(22)}

		       ENDIF
		       lPrimer := .F.
		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		       TRA->(DBSKIP())
		    ENDDO

		    IF CLI->cCodigoEst == SUBS(TRA->cCodRefTra,1,6) .AND.;
		       TRA->nCodigoCmv # 1

		       cTxtPrn := cRegPrint(aTitulo,aNroCol)
		       lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)

		    ENDIF

		 ELSE
		     cTxtPrn := cRegPrint(aTitulo,aNroCol)
		     lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DEL CONTENIDO DEL INFORME

	       SELECT CLI
	       SKIP

	    ENDDO
	    CloseDbf('CLI',FileCli,nModCry)
**********FIN IMPRESION DEL CUERPO DEL INFORME

**********IMPRESION DE LOS TOTALES
	    @ PROW()+1,nColCab+nColTxt(aNroCol,06) SAY REPL('-',aNroCol[06])
	    @ PROW()+1,nColCab+nColTxt(aNroCol,06) SAY TRANS(nVlrGru,"####,###,###.99")
**********FIN IMPRESION DE LOS TOTALES

**********IMPRESION DERECHOS
	    DerechosPrn(cNomSis,cNomEmp,nLenPrn)
	    @ PROW()-PROW(),00 SAY ' '
	   *Saca la ultima linea
	    SET DEVICE TO SCREEN
**********FIN IMPRESION DERECHOS

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT GRU
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       CloseDbf('GRU')
       CloseDbf('CLI',FileCli,nModCry)
       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       SELECT TRA
       SET INDEX TO
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       IF !lFileDelete(FileTem)
	  cError('NO SE BORRO EL ARCHIVO TEMPORAL')
       ENDIF
       RETURN NIL
*>>>>IMPRESION DE LOS TOTALES