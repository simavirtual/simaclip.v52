/*************************************************************************
* TITULO ..: IMPRESION DEL EXTRACTO BANCARIO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 24/99 LUN A
       Colombia, Bucaramanga        INICIO: 02:45 PM   MAY 24/99 LUN

OBJETIVOS:

1- Imprime el extracto Bancario

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt13(aParam1,aParam2,aParam3,;
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

       LOCAL nOpcion := 0                   // Opciones
       LOCAL nNroDia := 0                   // N£mero del d¡a.
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nTotCre := 0                   // Total Creditos
       LOCAL nTotDeb := 0                   // Total D‚bitos
       LOCAL cConcep := ''                  // Concepto de la Transacion
       LOCAL cNroDoc := ''                  // Numero del Documento
       LOCAL cCodigo := ''                  // C¢digo
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTpr := ''               // Nombre de la materia
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
       nOpcion := nLeeOpcion('ENTRE LA OPCION: '+;
		 '1<EXTRACTO> 2<POR DIA> 3<POR CODIGO> 4<ABANDONAR>?',4,'0')

       IF nOpcion == 4
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>ANALISIS DE DECISION

*>>>>LECTURA DEL DIA
       IF nOpcion == 2

	  SET CURSOR ON
	  nNroDia := 0

	  TitBuscar(2,@nNroFil,@nNroCol,'ENTRE EL DIA:')
	  @ nNroFil,nNroCol GET nNroDia PICT '99';
			    VALID nNroDia <= 31
	  READ

	  IF nNroDia == 0
	     SELECT TRA
	     oBrowse:GOTOP()
	     oBrowse:FORCESTABLE()
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA DEL DIA

*>>>>LECTURA DEL CODIGO
       IF nOpcion == 3

	  SET CURSOR ON
	  cCodigo := SPACE(06)

	  TitBuscar(2,@nNroFil,@nNroCol,'CODIGO:')
	  @ nNroFil,nNroCol GET cCodigo PICT '999999'
	  READ

	  IF EMPTY(cCodigo)
	     SELECT TRA
	     oBrowse:GOTOP()
	     oBrowse:FORCESTABLE()
	     RETURN NIL
	  ENDIF

       ENDIF
*>>>>FIN LECTURA DEL CODIGO


*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       DO CASE
       CASE nOpcion == 1 // Todos

	    IF VAL(cNroMes) == 13
	       aCabeza := {cNomEmp,cNomSis,;
			   'EXTRACTO ACUMULADO'+;
			   '. A¥O: '+cAnoUsr,;
			   'TODOS LOS MOVIMIENTOS',;
			   '',;
			   nNroPag++,;
			   cTotPagina(nTotReg),lTamAnc}
	      ELSE
	       aCabeza := {cNomEmp,cNomSis,;
			   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
			   '. A¥O: '+cAnoUsr,;
			   'TODOS LOS MOVIMIENTOS',;
			   '',;
			   nNroPag++,;
			   cTotPagina(nTotReg),lTamAnc}
	      ENDIF

       CASE nOpcion == 2 // D¡a

	    IF VAL(cNroMes) == 13

	       aCabeza := {cNomEmp,cNomSis,;
			   'EXTRACTO ACUMULADO'+;
			   '. A¥O: '+cAnoUsr,;
			   'MOVIMIENTOS DEL DIA '+STR(nNroDia,2),;
			   '',;
			   nNroPag++,;
			   NIL,lTamAnc}
	    ELSE
	       aCabeza := {cNomEmp,cNomSis,;
			   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
			   '. A¥O: '+cAnoUsr,;
			   'MOVIMIENTOS DEL DIA '+STR(nNroDia,2),;
			   '',;
			   nNroPag++,;
			   NIL,lTamAnc}
	    ENDIF

       CASE nOpcion == 3 // Por c¢digo

	    IF VAL(cNroMes) == 13

	       aCabeza := {cNomEmp,cNomSis,;
			   'EXTRACTO ACUMULADO'+;
			   '. A¥O: '+cAnoUsr,;
			   'MOVIMIENTOS CODIGO:'+cCodigo,;
			   '',;
			   nNroPag++,;
			   NIL,lTamAnc}
	    ELSE

	       aCabeza := {cNomEmp,cNomSis,;
			   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
			   '. A¥O: '+cAnoUsr,;
			   'MOVIMIENTOS CODIGO:'+cCodigo,;
			   '',;
			   nNroPag++,;
			   NIL,lTamAnc}
	    ENDIF

       ENDCASE
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {12,40,12,12,12,40}
       aTitulo := {'FECHA','TIPO DE TRANSACION','REFERENCIA',;
		   'CREDITOS','DEBITOS','CONCEPTO'}
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

*>>>>FILTRACION DEL ARCHIVO DEL ESTRACTO
       SELECT TRA
       DO CASE
       CASE nOpcion == 1 // Todos

       CASE nOpcion == 2 // D¡a
	    SET FILTER TO DAY(TRA->dFechaTra) == nNrodia

       CASE nOpcion == 3 // Por c¢digo
	    SET FILTER TO TRA->cCodigoEst == cCodigo

       ENDCASE

       SELECT TRA
       TRA->(DBGOTOP())
       IF TRA->(EOF())
	  SET FILTER TO
	  cError('NO EXISTEN MOVIMIENTOS')
	  SELECT TRA
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DEL ESTRACTO

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
	  IF VAL(cNroMes) == 13

	     DO CASE
	     CASE nOpcion == 1 // Todos
		  FilePrn := 'Ext'+cAnoUsr

	     CASE nOpcion == 2 // D¡a
		  FilePrn := 'EX'+cAnoUsr+ALLTRIM(STR(nNrodia,2))

	     CASE nOpcion == 3 // Por c¢digo
		  FilePrn := 'E'+cCodigo

	     ENDCASE

	  ELSE

	     DO CASE
	     CASE nOpcion == 1 // Todos
		  FilePrn := 'Ext'+cMes(VAL(cNroMes),3)

	     CASE nOpcion == 2 // D¡a
		  FilePrn := 'Ext'+cMes(VAL(cNroMes),3)+ALLTRIM(STR(nNrodia,2))

	     CASE nOpcion == 3 // Por c¢digo
		  FilePrn := 'Ex'+cCodigo

	     ENDCASE

	  ENDIF
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,CAR->cOpcPrnCar,.F.,,,PathDoc)
	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL EXTRACTO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT TRA
       GO TOP
       DO WHILE .NOT. TRA->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( TRA->(RECNO()) / TRA->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('REGISTRO: '+STR(TRA->(RECNO()),5)+'/'+;
				     STR(TRA->(RECCOUNT()),5)+'º'+;
			'REFERENCIA: '+TRA->cCodRefTra,cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACUMULACION DEL TIPO DE TRANSACCION
	    IF TRA->lSumarTra
	       nTotCre += TRA->nValorTra
	    ELSE
	       nTotDeb += TRA->nValorTra
	    ENDIF
**********FIN ACUMULACION DEL TIPO DE TRANSACCION

**********NUMERO DEL DOCUMENTO
	    cConcep := cConcepTmv(TRA->cCodigoTra,'TRA')
	    IF BAN->nPosTalBan # 0
	       cNroDoc := SUBS(TRA->Registro,BAN->nPosTalBan,BAN->nLenTalBan)
	       cConcep := ALLTRIM(cConcep)+':'+cNroDoc
	    ENDIF
	    cConcep := SUBS(cConcep+SPACE(40),1,40)
**********FIN NUMERO DEL DOCUMENTO

**********IMPRESION DEL REGISTRO
	    aTitulo := {cFecha(TRA->dFechaTra),;
			cConcep,;
			TRA->cCodRefTra,;
			IF(TRA->lSumarTra,;
			   TRANS(TRA->nValorTra,"####,###,###"),;
			   SPACE(12)),;
			IF(TRA->lSumarTra,;
			   SPACE(12),;
			   TRANS(TRA->nValorTra,"####,###,###")),;
			ALLTRIM(STR(TRA->nCodigoCmv,4))+'='+;
			cConcepCmv(TRA->nCodigoCmv,'TRA')}
	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT TRA
	    TRA->(DBSKIP())
	    IF TRA->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColCab+nColTxt(aNroCol,04) SAY REPL('-',aNroCol[04])
       @ PROW()  ,nColCab+nColTxt(aNroCol,05) SAY REPL('-',aNroCol[05])

       @ PROW()+1,nColCab+nColTxt(aNroCol,04) SAY TRANS(nTotCre,"####,###,###")
       @ PROW()  ,nColCab+nColTxt(aNroCol,05) SAY TRANS(nTotDeb,"####,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       DerechosPrn(cNomSis,cNomEmp,nLenPrn)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea
       VerPrn(nOpcPrn,FilePrn)

       SET DEVICE TO SCREEN
       IF nOpcion # 1
	  SELECT TRA
	  SET FILTER TO
       ENDIF
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS