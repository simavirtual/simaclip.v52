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

FUNCTION FOtrExt13(aP1,aP2,aP3,;
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
       LOCAL nNroDia := 0                   // N£mero del d¡a.
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura

       LOCAL       i := 0                   // Contador
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL nTotCre := 0                   // Total Creditos
       LOCAL nTotDeb := 0                   // Total D‚bitos
       LOCAL cConcep := ''                  // Concepto de la Transacion
       LOCAL cNroDoc := ''                  // Numero del Documento
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTpr := ''               // Nombre de la materia
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

*>>>>ANALISIS DE DECISION
       lTodos := .T.
       IF !lPregunta('DESEA EL MOVIMIENTO TODOS LOS DIAS? Si No')

***********LECTURA DEL CODIGO
	     SET CURSOR ON
	     nNroDia := 0
	     TitBuscar(2,@nNroFil,@nNroCol,'ENTRE EL DIA:')
	     @ nNroFil,nNroCol GET nNroDia PICT '99';
			       VALID nNroDia <= 31
	     READ
	     lTodos := .F.
***********FIN LECTURA DEL CODIGO

       ENDIF
*>>>>FIN CAPTURA DEL CODIGO

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := TRA->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'EXTRACTO DEL MES DE '+cMes(VAL(cNroMes))+;
		   '. A¥O: '+cAnoUsr,;
		   IF(lTodos,'TODOS LOS MOVIMIENTOS',;
			     'MOVIMIENTOS DEL DIA '+STR(nNroDia,2)),;
		   '',;
		   nNroPag++,;
		   IF(lTodos,cTotPagina(nTotReg),NIL),lTamAnc}
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
       IF !lTodos
	  SELECT TRA
	  SET FILTER TO DAY(TRA->dFechaTra) == nNrodia
	  GO TOP
	  IF EOF()
	     SET FILTER TO
	     cError('NO EXISTEN MOVIMIENTOS PARA ESTE DIA')
	     SELECT TRA
	     oBrowse:GOTOP()
	     oBrowse:FORCESTABLE()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO DEL ESTRACTO

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
       IF !lTodos
	  SELECT TRA
	  SET FILTER TO
       ENDIF
       SELECT TRA
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS