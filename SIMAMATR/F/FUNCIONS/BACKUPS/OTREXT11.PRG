/*************************************************************************
* TITULO ..: IMPRESION DEL MOVIMIENTO POR TIPO TRANSACCION               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 21/99 JUE A
       Colombia, Bucaramanga        INICIO: 11:50 PM   MAY 21/99 JUE

OBJETIVOS:

1- Imprime los movimientos del extracto descriminados por tipo de Transaci¢n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FOtrExt11(aP1,aP2,aP3,;
		   cNroMes,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			            // Parametros Generales
       aP2			            // Parametros Generales
       aP3			            // Parametros Generales
       cNroMes                              // N£mero del Mes
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS GENERALES
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
*>>>>FIN DECLARACION PARAMETROS GENERALES

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

       LOCAL lTodos  := .T.                 // Imprimir todos los Conceptos
       LOCAL cCodigo := ''                  // Codigo del Concepto
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nVlrCre := 0                   // Valor Creditos
       LOCAL nVlrDeb := 0                   // Valor D‚bitos
       LOCAL nVlrSdo := 0                   // Valor Saldo
       LOCAL nTotCre := 0                   // Total Creditos
       LOCAL nTotDeb := 0                   // Total D‚bitos
       LOCAL nTotSdo := 0                   // Total Saldos
       LOCAL nVlrOtr := 0                   // Otros Valores
       LOCAL nRegAct := 0                   // Registro Actual
       LOCAL lPrimer := .T.                 // .T. Primer paso
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF TRA->(RECCOUNT()) == 0
	  cError('NO EXISTEN MOVIMIENTOS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>ANALISIS DE DECISION
       lTodos := .T.
       IF !lPregunta('DESEA IMPRIMIR TODOS LOS TIPOS TRANSACIONES? Si No')

***********LECTURA DEL CODIGO
	     SET CURSOR ON
	     cCodigo := cSpaces('TRA','cCodigoTra')
	     TitBuscar(2,@nNroFil,@nNroCol)
	     @ nNroFil,nNroCol GET cCodigo PICT '@!';
			       VALID lValidaTmv(ROW(),COL()-1,@cCodigo)
	     READ
	     IF EMPTY(cCodigo)
		SELECT TRA
		oBrowse:GOTOP()
		oBrowse:FORCESTABLE()
		RETURN NIL
	     ENDIF
	     lTodos := .F.
***********FIN LECTURA DEL CODIGO

       ENDIF
*>>>>FIN CAPTURA DEL CODIGO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   IF(VAL(cNroMes)==13,'EXTRACTO ACUMULADO',;
		      'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		      '. A¥O: '+cAnoUsr),;
		   'MOVIMIENTOS POR TIPO DE TRANSACION',;
		   IF(lTodos,'',ALLTRIM(TMV->cNombreTmv)),;
		   nNroPag++,;
		   NIL,lTamAnc}
       cCodIni := DRAFT_ON+PICA+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       IF lTodos
	  aNroCol := {40,16,16,16}
	  aTitulo := {'CONCEPTOS','CREDITOS','DEBITOS','SALDO'}
       ELSE
	  aNroCol := {12,04,16,16,16,40}
	  aTitulo := {'FECHA','TRAN','CREDITOS','DEBITOS',;
		      'REFERENCIA','OBSERVACION'}
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

*>>>>ACTIVACION DE LA IMPRESORA
       IF xPrm(aP3,'lPrnArc')
	  SET DEVICE TO PRINT
       ELSE
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,xPrm(aP3,'cOpcPrn'),.F.)
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

       SELECT TMV
       IF lTodos
	  GO TOP
       ENDIF
       DO WHILE .T.

**********ANALISIS DE FIN DE ARCHIVO
	    IF lTodos .AND. TMV->(EOF())
	       EXIT
	    ENDIF
**********FIN ANALISIS DE FIN DE ARCHIVO

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( TMV->(RECNO()) / TMV->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL MOVIMIENTO
	    SELECT TRA
	    GO TOP
	    nVlrCre := 0
	    nVlrDeb := 0
	    nVlrSdo := 0
	    DO WHILE .NOT. TRA->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('REGISTRO: '+STR(TMV->(RECNO()),5)+'/'+;
					  STR(TMV->(RECCOUNT()),5)+'º'+;
			     'REFERENCIA: '+TRA->cCodRefTra,cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ACUMULACION DEL TIPO DE TRANSACCION
		 IF TRA->cCodigoTra == TMV->cCodigoTra

		    IF TRA->lSumarTra
		       nVlrCre += TRA->nValorTra
		       nVlrSdo += TRA->nValorTra
		    ELSE
		       nVlrDeb += TRA->nValorTra
		       nVlrSdo -= TRA->nValorTra
		    ENDIF

		 ENDIF
*--------------FIN ACUMULACION DEL TIPO DE TRANSACCION

*--------------IMPRESION DEL REGISTRO
		 IF !lTodos .AND. TRA->cCodigoTra == TMV->cCodigoTra
		    aTitulo := {cFecha(TRA->dFechaTra),;
				TRA->cCodigoTra,;
				IF(TRA->lSumarTra,;
				   TRANS(TRA->nValorTra,"####,###,###.##"),;
				   SPACE(12)),;
				IF(TRA->lSumarTra,;
				   SPACE(12),;
				   TRANS(TRA->nValorTra,"####,###,###.##")),;
				TRA->cCodRefTra,;
				SUBS(cSekNomAlu(SUBS(TRA->cCodRefTra,1,6),;
				     cMaeAlu)+SPACE(40),1,40)}
		    cTxtPrn := cRegPrint(aTitulo,aNroCol)
		    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
		 ENDIF
*--------------FIN IMPRESION DEL REGISTRO

*--------------ACUMULACION DE TIPOS DE TRANSACION NO DEFINIDO
		 IF lPrimer .AND. lTodos
		    lPrimer := .F.
		    SELECT TMV
		    nRegAct := TMV->(RECNO())
		    IF !lLocCodigo('cCodigoTra','TMV',TRA->cCodigoTra)
		       nVlrOtr += TRA->nValorTra
		    ENDIF
		    GO nRegAct
		 ENDIF
*--------------FIN ACUMULACION DE TIPOS DE TRANSACION NO DEFINIDOS

	       SELECT TRA
	       TRA->(DBSKIP())

	    ENDDO
	    nTotCre += nVlrCre
	    nTotDeb += nVlrDeb
	    nTotSdo += nVlrCre - nVlrDeb
**********IMPRESION DEL MOVIMIENTO

**********IMPRESION DEL REGISTRO
	    IF lTodos
	       IF nVlrCre # 0 .OR. nVlrDeb # 0
		  aTitulo := {TMV->cNombreTmv,;
			      IF(nVlrCre == 0,SPACE(12),;
					     TRANS(nVlrCre,"####,###,###.##")),;
			      IF(nVlrDeb == 0,SPACE(12),;
					     TRANS(nVlrDeb,"####,###,###.##")),;
			      IF(nVlrSdo == 0,SPACE(12),;
					     TRANS(nVlrSdo,"####,###,###.##"))}
		  cTxtPrn := cRegPrint(aTitulo,aNroCol)
		  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
	       ENDIF
	    ENDIF
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT TMV
	    IF lTodos
	       TMV->(DBSKIP())
	       IF TMV->(EOF())
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

*>>>>IMPRESION DE LOS OTROS VALORES
       IF nVlrOtr # 0 .AND. lTodos
	  nTotDeb += nVlrOtr
	  aTitulo := {SUBS('OTROS'+SPACE(40),1,40),;
		      SPACE(12),;
		      TRANS(nVlrOtr,"####,###,###.##")}
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
       ENDIF
*>>>>FIN IMPRESION DE LOS OTROS VALORES

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1,nColCab+nColTxt(aNroCol,IF(lTodos,02,03)) SAY REPL('-',aNroCol[IF(lTodos,02,03)])
       @ PROW()  ,nColCab+nColTxt(aNroCol,IF(lTodos,03,04)) SAY REPL('-',aNroCol[IF(lTodos,03,04)])
       IF lTodos
	  @ PROW(),nColCab+nColTxt(aNroCol,04,05) SAY REPL('-',aNroCol[04])
       ENDIF

       @ PROW()+1,nColCab SAY IF (lTodos,'TOTALES ...','')
       @ PROW()  ,nColCab+nColTxt(aNroCol,IF(lTodos,02,03)) SAY TRANS(nTotCre,"####,###,###.##")
       @ PROW()  ,nColCab+nColTxt(aNroCol,IF(lTodos,03,04)) SAY TRANS(nTotDeb,"####,###,###.##")
       IF lTodos
	  @ PROW(),nColCab+nColTxt(aNroCol,04) SAY TRANS(nTotSdo,"####,###,###.##")
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
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS