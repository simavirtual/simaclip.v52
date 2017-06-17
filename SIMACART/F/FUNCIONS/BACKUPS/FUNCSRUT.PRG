/*               	 SISTEMA CARTERA ACADEMICA
	      BIBLIOTECAS DE FUNCIONES PARA EL ARCHIVO DE RUTAS

REQUERIMIENTOS:

- Compilar: clipper FuncsRut /w/m/b

OBJETIVOS:

- Funciones aplicadas para el archivo de Rutas

FUNCIONES:


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: INCLUSION DE REGISTROS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 04/2001 JUE A
       Colombia, Bucaramanga        INICIO: 11:20 AM   OCT 04/2001 JUE

OBJETIVOS:

1- Permite la inclusion de registros

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IncluirRut(lShared)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE CONSTANTES
       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // Fila de Lectura
       LOCAL nNroCol := 2                   // Columna de Lectura
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lGrabar := .F.                 // .T. Grabar
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cCodigoTru := ''               // Codigo de la Ruta
       LOCAL cNombreTru := ''               // Nombre de la Ruta
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>GRABACION DE RUTAS
       SET CURSOR ON
       nNroFil := nMarco(nNroFil,'POR FAVOR INGRESE LOS '+;
				 'DETALLES DE LA RUTA',22,'°')
       IF RUT->(RECCOUNT()) == 0

**********LECTURA DEL TOTAL DE RUTAS
	    cCodigoTru := SPACE(02)
	    @ nNroFil+0,nNroCol SAY 'TOTAL DE RUTAS:';
				GET cCodigoTru PICT '@!';
				VALID !lValCodRut(cCodigoTru)
	    READ
**********FIN LECTURA DEL TOTAL DE RUTAS

**********GRABACION DE LAS RUTAS
	    SELECT RUT
	    FOR i := 1 TO VAL(cCodigoTru)
		IF RUT->(lRegLock(lShared,.T.))
		   REPL RUT->cCodigoRut WITH STR(i,2)
		   REPL RUT->cNombreRut WITH 'RUTA No.'+STR(i,2)
		   RUT->(DBCOMMIT())
		ENDIF
		IF lShared
		   RUT->(DBUNLOCK())
		ENDIF
	    NEXT
	    RETURN NIL
**********FIN GRABACION DE LAS RUTAS

       ENDIF
*>>>>FIN GRABACION DE RUTAS

*>>>>LECTURA Y CONFIRMACION DEL REGISTRO
       DO WHILE .T.

**********INICIALIZACION DE LAS VARIABLES
	    IF !lHayErr
	       cCodigoTru := cSpaces('RUT','cCodigoRut')
	       cNombreTru := cSpaces('RUT','cNombreRut')
	    ENDIF
**********FIN INICIALIZACION DE LAS VARIABLES

**********LECTURA DEL REGISTRO
	    @ nNroFil+0,nNroCol SAY 'CODIGO DE LA RUTA:';
				GET cCodigoTru PICT '@!';
				VALID !lValCodRut(cCodigoTru)

	    @ nNroFil+1,nNroCol SAY 'NOMBRE DE LA RUTA:';
				GET cNombreTru PICT '@!'
	    READ
**********FIN LECTURA DEL REGISTRO

**********VALIDACION DEL REGISTRO
	    IF cCodigoTru # cSpaces('RUT','cCodigoRut')
	       lGrabar := .T.
	    ELSE
	       lGrabar := .F.
	       cError('DEBE DAR LOS DATOS COMPLETOS. NO SE GRABA EL REGISTRO')
	    ENDIF
**********FIN VALIDACION DEL REGISTRO

**********PREGUNTA DE DECISION
	    IF lGrabar
	       IF lPregunta('DESEA GRABAR EL REGISTRO? Si No')
		  EXIT
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	    lHayErr := .T.
**********PREGUNTA DE DECISION

       ENDDO
*>>>>FIN LECTURA Y CONFIRMACION DEL REGISTRO

*>>>>GRABACION DEL REGISTRO
       SELECT RUT
       IF lGrabar
	  IF RUT->(lRegLock(lShared,.T.))
	     REPL RUT->cCodigoRut WITH cCodigoTru
	     REPL RUT->cNombreRut WITH cNombreTru
	     RUT->(DBCOMMIT())
	  ENDIF
       ENDIF
       IF lShared
	  RUT->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL CAMPO

/*************************************************************************
* TITULO..: LECTURA DE LAS RUTAS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 08/2001 LUN A
       Bucaramanga, Colombia	    INICIO: 10:45 AM   OCT 08/2001 LUN

OBJETIVOS:

1- Debe estar en uso el archivo de Rutas

2- Permite leer los c¢digos de las Rutas que deben tomar los Estudiantes.

3- Retorna los c¢digos de las Rutas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLeeRutas(nNroFil,nNroCol,nFilRut,nColRut,cRutEst,cConRut,nTotRut)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil			            // Fila Principal
       nNroCol			            // Columna Principal
       nFilRut			            // Fila Impresion de Rutas
       nColRut			            // Columna impresion Rutas
       cRutEst			            // Rutas Aplicados
       cConRut			            // Conceptos de Rutas
       nTotRut                              // Total de Rutas */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nFilSup := 0                   // Fila Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nFilInf := 0                   // Fila Inferior
       LOCAL nColInf := 0                   // Columna Inferior
       LOCAL lSavPan := .T.                 // .T. Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nNroRut := 1                   // N£mero de Rutas
       LOCAL nNroReg := 0                   // N£mero de Registro

       LOCAL cCodigoTru := ''               // C¢digo de la Ruta
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIZACION DE LAS COORDENADAS
	SELECT RUT
	nFilSup := nNroFil+1
	nColSup := nNroCol+1
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 22
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+18
*>>>>FIN INICIALIZACION DE LAS COORDENADAS

*>>>>LECTURA DE LAS RUTAS
       cRutEst := IF(cRutEst == NIL,'',cRutEst)
       DO WHILE .T.

/*
**********CAPTURA DEL CODIGO
	    cCodigo := cSpaces('RUT','cCodigoRut')
*	    TitBuscar(LEN(cCodigo),@nNroFil,@nNroCol,'ENTRE LA RUTA','RUTAS')
	    @ nFilRut,nColRut+4 SAY 'RUTA: ' GET cCodigo PICT '@!';
				VALID EMPTY(cCodigo) .OR. lValRutas(ROW(),COL()-3,@cCodigo)
	    READ
	    IF EMPTY(cCodigo)
	       EXIT
	    ENDIF
	    nNroReg := RUT->(RECNO())
**********FIN CAPTURA DEL CODIGO
*/

**********SELECCION DEL CODIGO DE LA RUTA
	    SELECT RUT
	    RUT->(DBGOTOP())
	    nNroReg := nBrowseDbf(nFilSup,nColSup,nFilInf-1,nColInf,;
				  {||RUT->cCodigoRut+' '+;
				     RUT->cNombreRut},16,lSavPan)
	    IF nNroReg == 0
	       EXIT
	    ENDIF
**********FIN SELECCION DEL CODIGO DE LA RUTA

**********ACUMULACION DEL CODIGO DE LA RUTA
	    nTotRut := IF(EMPTY(nTotRut),1,nTotRut)
	    nTotRut := IF(nTotRut>5,5,nTotRut)
	    IF nNroReg <> 0

*--------------ANALISIS DE LA VALIDACION
		 RUT->(DBGOTO(nNroReg))
		 DO CASE
		 CASE nNroRut > nTotRut
		      cError('SOLO SE PUEDE APLICAR ('+;
			     STR(nTotRut,1)+') RUTAS')
		      EXIT

		 CASE RUT->cCodigoRut $ cCodigoTru .OR.;
		      RUT->cCodigoRut $ cRutEst

		      cError('LA RUTA '+ALLTRIM(RUT->cNombreRut)+;
			     ' YA LA APLICO')

		 OTHERWISE

*.....................VALIDACION DE LOS CONCEPTOS DE LA RUTA
			lHayErr := .T.
			FOR i := 1 TO LEN(ALLTRIM(cConRut))/2
			   cCodigoTco := SUBS(cConRut,i*2-1,2)
			   IF cCodigoTco $ RUT->cConcepRut
			      lHayErr := .F.
			      EXIT
			   ENDIF
			NEXT
*.....................FIN VALIDACION DE LOS CONCEPTOS DE LA RUTA

*.....................ASIGNACION DEL CODIGO DE LA RUTA
			IF .NOT. lHayErr
			   cCodigoTru = cCodigoTru + RUT->cCodigoRut
			   @ nFilRut,nColRut SAY cCodigoTru
			   nNroRut++
			ELSE
			   cError('EL CONCEPTO NO ES VALIDO PARA '+;
				  'RUTA SELECCIONADA')
			ENDIF
*.....................FIN ASIGNACION DEL CODIGO DE LA RUTA

		 ENDCASE
*--------------FIN ANALISIS DE LA VALIDACION

	    ENDIF
**********FIN ACUMULACION DEL CODIGO DE LA RUTA

       ENDDO
       RETURN cCodigoTru
*>>>>FIN LECTURA DE LAS RUTAS

/*************************************************************************
* TITULO..: INTERVALO DE REGISTROS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2001 MAR A
       Bucaramanga, Colombia	    INICIO: 04:20 PM   OCT 16/2001 MAR


OBJETIVOS:

1- Permite selecionar un intervalo de Registros.

2- Retorna .T. si se ley¢ un intervalo

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lIntervRut(nNroFil,nNroCol,nRegIni,nRegFin,lIniFin)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la Columna
       nRegIni                              // @Registro Inicial
       nRegFin                              // @Registro Final
       lIniFin                              // @ .T. Todos los Grupos */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nFilSup := 0                   // Fila superior
       LOCAL nColSup := 0                   // Colunma superior
       LOCAL nFilInf := 0                   // Fila inferior
       LOCAL nColInf := 0                   // Columna inferior
       LOCAL nRegTem := 0                   // Registro temporal
       LOCAL nIniReg := 0                   // Registro Inicial
       LOCAL nFinReg := 0                   // Registro Final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE ENCABEZADOS
       cMsgTxt ='RUTA INICIAL:'
       @ nNroFil  ,nNroCol SAY cMsgTxt
       @ nNroFil+1,nNroCol SAY 'RUTA FINAL  :'
*>>>>FIN IMPRESION DE ENCABEZADOS

*>>>>CAPTURA DEL INTERVALO INICIAL
	SELECT RUT
	nNroCol = nNroCol + LEN(cMsgTxt)
	nFilSup := nNroFil
	nColSup := nNroCol
	IF nFilSup+RECCOUNT() > 22
	   nFilInf := 21
	ELSE
	   nFilInf := nFilSup + RECCOUNT()
	ENDIF
	nColInf := nColSup+3

	RUT->(DBGOTOP())
	nIniReg := RUT->(RECNO())
	nRegIni := nBrowseDbf(nFilSup,nColSup,nFilInf,nColInf,;
			      {||RUT->cCodigoRut})
	IF nRegIni == 0
	   RETURN .F.
	ENDIF
	RUT->(DBGOTO(nRegIni))
	@ nFilSup,nColSup SAY RUT->cCodigoRut
*>>>>FIN CAPTURA DEL INTERVALO INICIAL

*>>>>CAPTURA DEL INTERVALO FINAL
       RUT->(DBGOBOTTOM())
       nFinReg := RUT->(RECNO())

       RUT->(DBGOTOP())
       nRegFin := nBrowseDbf(nFilSup+1,nColSup,nFilInf,nColInf,;
			     {||RUT->cCodigoRut})
       IF nRegFin == 0
	  RETURN .F.
       ENDIF
       RUT->(DBGOTO(nRegFin))
       @ nFilSup+1,nColSup SAY RUT->cCodigoRut
*>>>>FIN CAPTURA DEL INTERVALO FINAL

*>>>>INTERCAMBIO DE REGISTROS
       IF nRegIni > nRegFin
	  nRegTem = nRegIni
	  nRegIni = nRegFin
	  nRegFin = nRegTem
       ENDIF
*>>>>FIN INTERCAMBIO DE REGISTROS

*>>>>ANALISIS DE TODOS LOS REGISTROS
       lIniFin := .F.
       IF nRegIni == nIniReg .AND. nRegFin == nFinReg
	  lIniFin := .T.
       ENDIF
       RETURN .T.
*>>>>FIN ANALISIS DE TODOS LOS REGISTROS

/*************************************************************************
* TITULO..: IMPRESION CAMPOS DEL MANTENIMIENTO                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 11/99 MAR A
       Colombia, Bucaramanga        INICIO: 09:50 AM   MAY 11/99 MAR

OBJETIVOS:

1- Imprime los campos del archivo de mantenimiento

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRut112(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,cNomUsr,cAnoUsr,cPatSis,;
		   oBrowse,cMaeAlu,cMaeAct,cJorTxt,lPrnArc,;
		   cOpcPrn)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       oBrowse                              // Browse del Archivo
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       lPrnArc                              // .T. Imprimir Archivo
       cOpcPrn                              // Opciones de Impresi¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cRutFin := ''                  // Grupo final de impresi¢n
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF RUT->(RECCOUNT()) == 0
	  cError('NO EXISTEN CONCEPTOS DE RUTAS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       IF !lCreallGru(lShared,cAnoUsr,cMaeAlu,cIntUno+'\'+cPatSis,FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntUno+'\'+PathSis+'\'+;
		       FilePer,'PER',;
		       cIntUno+'\'+PathSis+'\'+Ntx1Per,lShared,nModCry) .OR.;
	  !lUseMae(lSiRed,cIntUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileDes,'DES',;
		       cPatSis+'\'+fNtxDes,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileTar,'TAR',NIL,lShared,nModCry)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileUru,'URU',NIL,lShared,nModCry)   .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE REGISTROS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LAS RUTAS',;
			 22,NIL,NIL,20,60)
       IF !lIntervRut(nNroFil,21,@nRegIni,@nRegFin)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DE REGISTROS POR INTERVALO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF lPrnArc
          SET DEVICE TO PRINT
       ELSE
          FilePrn := 'Rut'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.F.)
          IF EMPTY(nOpcPrn)
	     CloseMae(cMaeAlu)
	     CloseDbf('GRU')
	     CloseDbf('CAA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT RUT
       GO nRegFin
       cRutFin = RUT->cCodigoRut

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********DEFINCION DEL ENCABEZADO
	    nNroPag := 0
	    lTamAnc := .F.

	    nTotReg := 0
	    aCabeza := {cNomEmp,cNomSis,;
			'A¥O: '+cAnoUsr+' JORNADA '+cJorTxt,;
			'ESTUDIANTES DE LA RUTA No.'+RUT->cCodigoRut,;
			'',;
			nNroPag++,;
			NIL,lTamAnc}
	    cCodIni := DRAFT_ON+PICA+CONDEN_ON
	    cCodFin := NEGRA_OF+DOBGOL_OF
**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    aNroCol := {04,06,06,30,70,16,16,16,14,40}
	    aTitulo := {'No.','CODIGO','GRUPO','NOMBRE',;
			'DIRECCION',;
			'CONCEPTOS',;
			'TEL CASA',;
			'TEL OFICINA',;
			'F. DE PAGO',;
			'OBSERVACIONES'}
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
	    bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
**********FIN ANALISIS PARA CENTRAR EL INFORME

**********IMPRESION DEL ENCABEZADO
	    @ PROW(),00 SAY INICIALIZA
	    EVAL(bCabeza)
	   *Impresi¢n del Encabezado
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL INFORME
	    RutasGru(lShared,nModCry,cNomEmp,cNomSis,cAnoUsr,;
		     cPatSis,cMaeAlu,aNroCol,bPagina,bDerAut,;
		     bCabeza)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT RUT
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       CloseMae(cMaeAlu)
       CloseDbf('GRU')
       CloseDbf('CAA')
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO


/*************************************************************************
* TITULO..: IMPRESION DE LAS RUTAS POR GRUPOS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2001 MAR A
       Colombia, Bucaramanga        INICIO: 04:40 PM   OCT 16/2001 MAR

OBJETIVOS:

1- Imprime los estudiantes por grupos que estan asignados a una ruta
   espec¡fica.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RutasGru(lShared,nModCry,cNomEmp,cNomSis,cAnoUsr,;
		  cPatSis,cMaeAlu,aNroCol,bPagina,bDerAut,;
		  bCabeza)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cPatSis                              // Path del Sistemas
       cMaeAlu                              // Maestros habilitados
       aNroCol                              // N£mero de Columnas
       bPagina                              // Block de P gina
       bDerAut                              // Block Derechos de Autor
       bCabeza                              // Block de Encabezado */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL nNroEst := 0                   // N£mero de Estudiantes
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nPosRut := 0                   // Posicci¢n de la Ruta
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL cNotMor := ''                  // Nota de Evaluaci¢n
       LOCAL cDirecc := ''                  // Direcci¢n
       LOCAL cConEst := ''                  // Conceptos del Estudiante

       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT GRU
       GO TOP
       DO WHILE .NOT. GRU->(EOF())

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseMae(cMaeAlu)
	       CloseDbf('GRU')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS '+FileCli)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseMae(cMaeAlu)
	       CloseDbf('GRU')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********RECORRIDO POR EL GRUPO
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('RUTA No. '+RUT->cCodigoRut+;
			     'ºGRUPO: '+GRU->cCodigoGru+'=>'+;
					CLI->(STR(RECNO(),2))+'/'+;
					CLI->(STR(RECCOUNT(),2))+;
			     'ºREGISTRO:'+GRU->(STR(RECNO(),2))+'/'+;
					  GRU->(STR(RECCOUNT(),2)),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		 IF lHayAlu
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS DE LA RUTA
		 nPosRut := AT(RUT->cCodigoRut,&cMaeAct->cCodigoRut)
		 IF !lHayAlu .OR. &cMaeAct->lRetiroEst .OR.;
		    CLI->lRetGruCli .OR. nPosRut == 0 .OR.;
		    (nPosRut # 1 .AND. nPosRut # 3)

		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF
*--------------FIN ANALISIS DE LA RUTA

*--------------ANALISIS DEL TIPO DE MOROSO
		 cNotaCli(CLI->cCodigoEst,;
			  &cMaeAct->cCodigoGru,;
			  ALLTRIM(CAA->cConPenCaA)+;
			  ALLTRIM(&cMaeAct->cConcepEst),;
			  CLI->nSdoActCli+CLI->nSdoMorCli,;
			  TipoMora(CLI->cMesPagCli),;
			  CLI->cMesPagCli,@cNotMor)
*--------------FIN ANALISIS DEL TIPO DE MOROSO

*--------------IMPRESION DEL REGISTRO
		 cDirecc := ALLTRIM(&cMaeAct->cDireccEst)+' '+;
			    ALLTRIM(&cMaeAct->cBarrioEst)+' '+;
			    ALLTRIM(&cMaeAct->cCiudadEst)
		 cDirecc := SUBS(cDirecc+SPACE(70),1,70)

		 cConEst := ALLTRIM(&cMaeAct->cCodigoRut)+'=>'+;
			    ALLTRIM(&cMaeAct->cConcepEst)
		 cConEst := SUBS(cConEst+SPACE(16),1,16)

		 aTitulo := {STR(++nNroEst,2),;
			     &cMaeAct->cCodigoEst,;
			     &cMaeAct->cCodigoGru,;
			     cNombreTes,;
			     cDirecc,;
			     cConEst,;
			     &cMaeAct->cTelefnEst,;
			     &cMaeAct->cTelPadEst,;
			     cNotMor,;
			     SPACE(40)}

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DEL REGISTRO

		 SELECT CLI
		 CLI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR EL GRUPO

	  CloseDbf('CLI',FileCli,nModCry)
	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
*>>>>IMPRESION DEL CUERPO DEL INFORME

*>>>>FILTRACION DEL ARCHIVO
       SELECT URU
       SET FILTER TO URU->cCodigoRut == RUT->cCodigoRut
       URU->(DBGOTOP())
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>IMPRESION DE LAS PERSONAS
       DO WHILE .NOT. URU->(EOF())

	  aTitulo := {}
	  AADD(aTitulo,STR(++nNroEst,2))
	  AADD(aTitulo,'')
	  AADD(aTitulo,'')

	  IF lSekCodigo(URU->cDocNitPer+URU->cTipNitPer,'Per')

	     AADD(aTitulo,SUBS(cApeNomPer()+SPACE(30),1,30))
	     AADD(aTitulo,SUBS(PER->cDireccPer+SPACE(70),1,70))
	     AADD(aTitulo,'')
	     AADD(aTitulo,PER->cTelefnPer)
	     AADD(aTitulo,PER->cTelCelPer)
	     AADD(aTitulo,'')
	     AADD(aTitulo,SUBS('Particular'+SPACE(40),1,40))

	  ELSE

	     AADD(aTitulo,SUBS(cApeNomPer()+SPACE(30),1,30))
	     AADD(aTitulo,SUBS(PER->cDireccPer+SPACE(70),1,70))
	     AADD(aTitulo,'')
	     AADD(aTitulo,PER->cTelefnPer)
	     AADD(aTitulo,PER->cTelCelPer)
	     AADD(aTitulo,'')
	     AADD(aTitulo,SUBS('PERSONA NO EXISTE'+SPACE(40),1,40))

	  ENDIF
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

	  SELECT URU
	  URU->(DBSKIP())

       ENDDO
*>>>>FIN IMPRESION DE LAS PERSONAS

*>>>>IMPRESION DEL AUXILIAR
       IF !EMPTY(RUT->cNitAuxRut)

	  aTitulo := {}
	  AADD(aTitulo,'')
	  AADD(aTitulo,'')
	  AADD(aTitulo,'')

	  IF lSekCodigo(RUT->cNitAuxRut+RUT->cTipAuxRut,'Per')

	     AADD(aTitulo,SUBS(cApeNomPer()+SPACE(30),1,30))
	     AADD(aTitulo,SUBS(PER->cDireccPer+SPACE(70),1,70))
	     AADD(aTitulo,'')
	     AADD(aTitulo,PER->cTelefnPer)
	     AADD(aTitulo,PER->cTelCelPer)
	     AADD(aTitulo,'')
	     AADD(aTitulo,SUBS('AUXILIAR'+SPACE(40),1,40))

	  ELSE

	     AADD(aTitulo,SUBS(cApeNomPer()+SPACE(30),1,30))
	     AADD(aTitulo,SUBS(PER->cDireccPer+SPACE(70),1,70))
	     AADD(aTitulo,'')
	     AADD(aTitulo,PER->cTelefnPer)
	     AADD(aTitulo,PER->cTelCelPer)
	     AADD(aTitulo,'')
	     AADD(aTitulo,SUBS('AUXILIAR NO EXISTE'+SPACE(40),1,40))

	  ENDIF
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN IMPRESION DEL AUXILIAR

*>>>>IMPRESION DEL CONDUCTOR
       IF !EMPTY(RUT->cNitChfRut)

	  aTitulo := {}
	  AADD(aTitulo,'')
	  AADD(aTitulo,'')
	  AADD(aTitulo,'')

	  IF lSekCodigo(RUT->cNitChfRut+RUT->cTipChfRut,'PER')

	     AADD(aTitulo,SUBS(cApeNomPer()+SPACE(30),1,30))
	     AADD(aTitulo,SUBS(PER->cDireccPer+SPACE(70),1,70))
	     AADD(aTitulo,'')
	     AADD(aTitulo,PER->cTelefnPer)
	     AADD(aTitulo,PER->cTelCelPer)
	     AADD(aTitulo,'')
	     AADD(aTitulo,SUBS('CONDUCTOR'+SPACE(40),1,40))

	  ELSE

	     AADD(aTitulo,SUBS(cApeNomPer()+SPACE(30),1,30))
	     AADD(aTitulo,SUBS(PER->cDireccPer+SPACE(70),1,70))
	     AADD(aTitulo,'')
	     AADD(aTitulo,PER->cTelefnPer)
	     AADD(aTitulo,PER->cTelCelPer)
	     AADD(aTitulo,'')
	     AADD(aTitulo,SUBS('CONDUCTOR NO EXISTE'+SPACE(40),1,40))

	  ENDIF
	  cTxtPrn := cRegPrint(aTitulo,aNroCol)
	  lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)

       ENDIF
*>>>>FIN IMPRESION DEL CONDUCTOR

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SELECT URU
       SET FILTER TO
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION DEUDAS Y PAGOS DE LAS RUTAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 24/2006 LUN A
       Colombia, Bucaramanga        INICIO: 03:30 PM   JUL 24/2006 LUN

OBJETIVOS:

1- Imprime los estudiantes de una ruta especifica, con la deuda o pago
   de la ruta.

2- Retorna NIL


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION OtrRut113(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,cNomSec,cNomUsr,cAnoUsr,cPatSis,;
		   oBrowse,cMaeAlu,cMaeAct,cJorTxt,lPrnArc,;
		   cOpcPrn)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       oBrowse                              // Browse del Archivo
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       lPrnArc                              // .T. Imprimir Archivo
       cOpcPrn                              // Opciones de Impresi¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
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
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL nRegIni := 0                   // Registro Inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL nMesIni := 0                   // Mes Inicial
       LOCAL cRutFin := ''                  // Grupo final de impresi¢n
       LOCAL nAvance := 0                   // Avance de registros
     *ÀVariables espec¡ficas

       LOCAL nMesIniTpa := 0                // Mes Inicial del pago
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF RUT->(RECCOUNT()) == 0
	  cError('NO EXISTEN CONCEPTOS DE RUTAS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>CREACION DE TODOS LOS GRUPOS
       FileTem := cFileTempo('',SUBS(cNomUsr,1,4),ExtFile)
       IF !lCreallGru(lShared,cAnoUsr,cMaeAlu,cIntUno+'\'+cPatSis,FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DE TODOS LOS GRUPOS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cIntUno+'\'+PathSis+'\'+;
		       FilePer,'PER',;
		       cIntUno+'\'+PathSis+'\'+Ntx1Per,lShared,nModCry) .OR.;
	  !lUseMae(lSiRed,cIntUno+'\'+cPatSis,cMaeAlu,cAnoSis) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+FileDes,'DES',;
		       cPatSis+'\'+fNtxDes,lShared,nModCry) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileTar,'TAR',NIL,lShared,nModCry)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileCon,'CON',NIL,lShared,nModCry)   .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FileUru,'URU',NIL,lShared,nModCry)   .OR.;
	  !lUseDbf(.T.,DIRNAME()+'\'+FileTem,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>CAPTURA DEL MES DEL RECIBO
       cSavPan := SAVESCREEN(0,0,24,79)
       nMesIniTpa := nMesano(15,10,'Mes del recibo',.T.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nMesIniTpa == 0
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DEL MES DEL RECIBO

*>>>>LECTURA DE REGISTROS POR INTERVALO
       cSavPan := SAVESCREEN(0,0,24,79)
       nNroFil := nMarco(06,'POR FAVOR SELECIONES LAS RUTAS',;
			 22,NIL,NIL,20,60)
       IF !lIntervRut(nNroFil,21,@nRegIni,@nRegFin)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN LECTURA DE REGISTROS POR INTERVALO

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseMae(cMaeAlu)
	  CloseDbf('GRU')
	  CloseDbf('CAA')
	  RETURN NIL
       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF lPrnArc
          SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'Rut'+cMes(nMesIniTpa,3)
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,cOpcPrn,.F.,.F.)
          IF EMPTY(nOpcPrn)
	     CloseMae(cMaeAlu)
	     CloseDbf('GRU')
	     CloseDbf('CAA')
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL INFORME PARA CADA GRUPO
       SELECT RUT
       GO nRegFin
       cRutFin = RUT->cCodigoRut

       GO nRegIni
       DO WHILE RECNO() <= nRegFin

**********DEFINCION DEL ENCABEZADO
	    nNroPag := 0
	    lTamAnc := .F.

	    nTotReg := 0
	    aCabeza := {cNomEmp,cNomSis,;
			'A¥O: '+cAnoUsr+' JORNADA '+cJorTxt,;
			'ESTUDIANTES DE LA RUTA No.'+RUT->cCodigoRut,;
			'RECIBOS DEL MES DE '+cMes(nMesIniTpa),;
			nNroPag++,;
			NIL,lTamAnc}
	    cCodIni := DRAFT_ON+PICA+CONDEN_ON
	    cCodFin := NEGRA_OF+DOBGOL_OF
**********FIN DEFINCION DEL ENCABEZADO

**********ENCABEZADOS DE COLUMNA
	    aNroCol := {04,06,06,30,10,16,16,16,16}
	    aTitulo := {'No.','CODIGO','GRUPO','NOMBRE','MESES',;
			'CONCEPTOS',;
			'SALDO RUTA',;
			'PAGOS RUTA',;
			'F. DE PAGO'}
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
	    bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
**********FIN ANALISIS PARA CENTRAR EL INFORME

**********IMPRESION DEL ENCABEZADO
	    @ PROW(),00 SAY INICIALIZA
	    EVAL(bCabeza)
	   *Impresi¢n del Encabezado
**********FIN IMPRESION DEL ENCABEZADO

**********IMPRESION DEL INFORME
	    PagosRut(lShared,nModCry,cNomEmp,cNomSis,cAnoUsr,;
		     cPatSis,cMaeAlu,aNroCol,bPagina,bDerAut,;
		     bCabeza,nMesIniTpa)
**********FIN IMPRESION DEL INFORME

**********AVANCE DEL SIGUIENTE GRUPO
	    SELECT RUT
	    SKIP

	    IF nRegIni = nRegFin
	       EXIT
	      *Salida por ser un solo grupo a imprimir
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE GRUPO

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       SET DEVICE TO SCREEN
       CloseMae(cMaeAlu)
       CloseDbf('GRU')
       CloseDbf('CAA')
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME PARA CADA GRUPO

/*************************************************************************
* TITULO..: IMPRESION DE LOS PAGOS POR GRUPOS DE LAS RUTAS               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 24/2006 LUN A
       Colombia, Bucaramanga        INICIO: 03:45 PM   JUL 24/2006 LUN

OBJETIVOS:

1- Imprime los estudiantes por grupos que estan asignados a una ruta
   espec¡fica, el pago o la deuda.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PagosRut(lShared,nModCry,cNomEmp,cNomSis,cAnoUsr,;
		  cPatSis,cMaeAlu,aNroCol,bPagina,bDerAut,;
		  bCabeza,nMesIni)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombres del Sistema
       cAnoUsr                              // A¤o del sistema
       cPatSis                              // Path del Sistemas
       cMaeAlu                              // Maestros habilitados
       aNroCol                              // N£mero de Columnas
       bPagina                              // Block de P gina
       bDerAut                              // Block Derechos de Autor
       bCabeza                              // Block de Encabezado
       nMesIni                              // Mes Inicial del pago */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contadores
       LOCAL nNroEst := 0                   // N£mero de Estudiantes
       LOCAL cMaeAct := ''                  // Maestro Actual
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nPosRut := 0                   // Posicci¢n de la Ruta
       LOCAL lHayAlu := .F.                 // .T. Hay Alumno
       LOCAL cConEst := ''                  // Conceptos del Estudiante
       LOCAL lHayPag := .F.                 // .T. Hay pago
       LOCAL lMesAct := .T.                 // Mes Actual

       LOCAL nVlrPag := 0                   // Valor del pago de un mes o varios meses.
       LOCAL nTotPag := 0                   // Total de pagos

       LOCAL nSdoAct := 0                   // Saldo Actual
       LOCAL nTotSdo := 0                   // Total de los saldos

       LOCAL aVlrCon := {}                  // Valor de los Conceptos
       LOCAL cCodRut := ''                  // Conceptos de ruta

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL lRetadoTes := .T.              // .T. Estudiante retirado
       LOCAL nSdoActTcl := 0                // Saldo Actual
       LOCAL nSdoMorTcl := 0                // Saldo de la Mora
       LOCAL cEstadoTpa := ''               // Estado del pago
       LOCAL cCodigoTco := ''               // C¢digo del Concepto
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT GRU
       GO TOP
       DO WHILE .NOT. GRU->(EOF())

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := cPatSis+'\CLIENTES\CL'+;
				GRU->cCodigoGru+cAnoSis+ExtFile

	    FilePag := cPatSis+'\PAGOS\PA'+;
				GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FilePag,'PAG',NIL,lShared,nModCry)
	       cError('ABRIENDO LOS ARCHIVOS DE CLIENTES PAGOS')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseMae(cMaeAlu)
	       CloseDbf('GRU')
	       RETURN NIL
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CLI->(RECCOUNT()) == 0
		 cError('NO EXISTEN CLIENTES GRABADOS '+FileCli)
	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('PAG',FilePag,nModCry)
	       CloseMae(cMaeAlu)
	       CloseDbf('GRU')
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********RECORRIDO POR EL GRUPO
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------IMPRESION DE LA LINEA DE ESTADO
		 SET DEVICE TO SCREEN
		 LineaEstado('RUTA No. '+RUT->cCodigoRut+;
			     'ºGRUPO: '+GRU->cCodigoGru+'=>'+;
					CLI->(STR(RECNO(),2))+'/'+;
					CLI->(STR(RECCOUNT(),2))+;
			     'ºCODIGO: '+CLI->cCodigoEst+;
			     'ºREGISTRO:'+GRU->(STR(RECNO(),2))+'/'+;
					  GRU->(STR(RECCOUNT(),2)),cNomSis)
		 SET DEVICE TO PRINT
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 lHayAlu := lSekCodMae(CLI->cCodigoEst,cMaeAlu,@cMaeAct,.F.)
		 IF lHayAlu
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		    cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
		 ENDIF
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS DE LA RUTA
		 nPosRut := AT(RUT->cCodigoRut,&cMaeAct->cCodigoRut)
		 IF !lHayAlu .OR. &cMaeAct->lRetiroEst .OR.;
		    CLI->lRetGruCli .OR. nPosRut == 0 .OR.;
		    (nPosRut # 1 .AND. nPosRut # 3)

		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP

		 ENDIF
*--------------FIN ANALISIS DE LA RUTA

*--------------ANALISIS SI ESTUDIANTE ESTA RETIRADO
		    nSdoAct := 0
		    nVlrPag := 0
		 nSdoActTcl := 0
		 nSdoMorTcl := 0
		 lRetadoTes := .F.
		 IF lHayAlu
		    IF &cMaeAct->lRetiroEst
		       lRetadoTes := .T.
		       nSdoActTcl := CLI->nSdoActCli
		       nSdoMorTcl := CLI->nSdoMorCli
		    ENDIF
		 ENDIF
*--------------FIN ANALISIS SI ESTUDIANTE ESTA RETIRADO

*--------------LOCALIZACION DEL PAGO
		 lHayPag := lLocCodPag(CLI->cCodigoEst,nMesIni,.F.)
*--------------FIN LOCALIZACION DEL PAGO

*--------------ANALISIS DEL CONCEPTO DE LA RUTA
		 cCodRut := ''
		 FOR i := 1 TO LEN(ALLTRIM(PAG->cConcepPag))/2

		     cCodigoTco := SUBS(PAG->cConcepPag,i*2-1,2)

		     SELECT CON
		     CON->(DBGOTOP())
		     LOCATE FOR CON->cCodigoCon == cCodigoTco .AND.;
				CON->nTipoCon == 1

		     IF CON->(FOUND())
			cCodRut += cCodigoTco
		     ENDIF
		 ENDFOR

		 IF EMPTY(cCodRut)
		    SELECT CLI
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS DEL CONCEPTO DE LA RUTA

*--------------ANALISIS DE LA FORMA DE PAGO
		 IF lHayPag
		    DO CASE
		    CASE PAG->cEstadoPag = 'P'
			 IF CAA->lLeeFecCaA
			    cEstadoTpa := IF(EMPTY(PAG->dFecPagPag),;
					      '   ??   ',;
					      cFecha(PAG->dFecPagPag)+':O')
			    cEstadoTpa += PAG->cCodigoFpg
			 ELSE
			    cEstadoTpa := SPACE(10)
			 ENDIF

		    CASE PAG->cEstadoPag = 'A'
			 IF CAA->lLeeFecCaA
			    cEstadoTpa = IF(EMPTY(PAG->dFecPagPag),;
					      '   ????   ',;
					      cFecha(PAG->dFecPagPag)+':E')
			    cEstadoTpa += PAG->cCodigoFpg
			 ELSE
			    cEstadoTpa := 'PAGO EXT'
			 ENDIF

		    CASE PAG->cEstadoPag = 'D'
			 cEstadoTpa = IF(CAA->lLeeFecCaA,;
					      SPACE(10),'NO PAGO ')

		    CASE PAG->cEstadoPag = '*'
			 cEstadoTpa = 'DEUDOR  '
		    OTHERWISE
			 cEstadoTpa = 'ERROR   '
		    ENDCASE
		 ENDIF
*--------------FIN ANALISIS DE LA FORMA DE PAGO

*--------------ANALISIS SI ES EL MES ACTUAL
		 lMesAct := .T.
		 IF nMesIni < LEN(RTRIM(CLI->cMesPagCli))
		    lMesAct := .F.
		 ENDIF
*--------------FIN ANALISIS SI ES EL MES ACTUAL

*--------------CALCULO DE LOS INTERESES ACUMULACION DE PAGOS
		 nSdoActTcl := 0
		 nSdoMorTcl := 0

		 IF lHayAlu .AND. lHayPag

*:::::::::::::::::::ANALISIS DE LA FORMA DE PAGO
		      DO CASE
		      CASE PAG->cEstadoPag == 'P' .OR.;
			   PAG->cEstadoPag == 'A'

*..........................DESCRIMINACION DEL PAGO POR CONCEPTOS
			     aVlrCon := {}
			     lVlrConRec(aVlrCon)
*..........................FIN DESCRIMINACION DEL PAGO POR CONCEPTOS

*..........................TOTALIZACION DE LOS PAGOS POR RUTAS
			     nVlrPag := 0
			     FOR i := 1 TO LEN(ALLTRIM(cCodRut))/2
				 cCodigoTco := SUBS(cCodRut,i*2-1,2)
				 j := ASCAN(aVlrCon,{|aArr|aArr[1] == cCodigoTco})
				 IF j # 0
				    nVlrPag += aVlrCon[j,3]
				 ENDIF
			     ENDFOR
			     nTotPag += nVlrPag
*..........................FIN TOTALIZACION DE LOS PAGOS POR RUTAS

		      CASE PAG->cEstadoPag == 'D'

			   IF lMesAct
			      nSdoActTcl := CLI->nSdoActCli
			   ELSE
			      nSdoActTcl := PAG->nSdoAntPag+PAG->nVlrMesPag
			   ENDIF

*..........................DESCRIMINACION DEL PAGO POR CONCEPTOS
			     aVlrCon := {}
			     lVlrConSdo(nSdoActTcl,0,aVlrCon)
*..........................FIN DESCRIMINACION DEL PAGO POR CONCEPTOS

*..........................TOTALIZACION DE LOS PAGOS POR RUTAS
			     nSdoAct := 0
			     FOR i := 1 TO LEN(ALLTRIM(cCodRut))/2
				 cCodigoTco := SUBS(cCodRut,i*2-1,2)
				 j := ASCAN(aVlrCon,{|aArr|aArr[1] == cCodigoTco})
				 IF j # 0
				    nSdoAct += aVlrCon[j,3]
				 ENDIF
			     ENDFOR
			     nTotSdo += nSdoAct
*..........................FIN TOTALIZACION DE LOS PAGOS POR RUTAS

		      CASE PAG->cEstadoPag = '*'

*..........................ANALISIS DEL DEUDOR
			     nSdoActTcl += IF(lMesAct,CLI->nSdoActCli,;
						      PAG->nSdoAntPag)
			     nSdoMorTcl += IF(lMesAct,CLI->nSdoMorCli,;
						      PAG->nMorAntPag)
			     nVlrPag := PAG->nVlrPagPag
*..........................FIN ANALISIS DEL DEUDOR

*..........................DESCRIMINACION DEL PAGO POR CONCEPTOS
			     aVlrCon := {}
			     lVlrConSdo(nSdoActTcl,0,aVlrCon)
*..........................FIN DESCRIMINACION DEL PAGO POR CONCEPTOS

*..........................TOTALIZACION DE LOS PAGOS POR RUTAS
			     nSdoAct := 0
			     FOR i := 1 TO LEN(ALLTRIM(cCodRut))/2
				 cCodigoTco := SUBS(cCodRut,i*2-1,2)
				 j := ASCAN(aVlrCon,{|aArr|aArr[1] == cCodigoTco})
				 IF j # 0
				    nSdoAct += aVlrCon[j,3]
				 ENDIF
			     ENDFOR
			     nTotSdo += nSdoAct
*..........................FIN TOTALIZACION DE LOS PAGOS POR RUTAS


		      ENDCASE
*:::::::::::::::::::FIN ANALISIS DE LA FORMA DE PAGO

		 ENDIF
*--------------FIN CALCULO DE LOS INTERESES ACUMULACION DE PAGOS

*--------------FILTRACION DE LOS ABONOS DEL ESTUDIANTE
		 SELECT DES
		 SET FILTER TO DES->cCodigoEst == CLI->cCodigoEst
		 DES->(DBGOTOP())
*--------------FIN FILTRACION DE LOS ABONOS DEL ESTUDIANTE

*--------------RECORRIDO DE LOS ABONOS
		 IF .NOT. DES->(EOF())
		    SELECT DES
		    DES->(DBGOTOP())
		    DO WHILE .NOT. DES->(EOF())

*::::::::::::::::::::::VALIDACION DEL ABONO
			 IF !(DES->nNroMesDes == nMesIni .AND.; // Abono
			      DES->nTipDesDes == 3 .AND. !DES->lDesEfeDes)

			      DES->(DBSKIP())
			      LOOP

			 ENDIF
*::::::::::::::::::::::FIN VALIDACION DEL ABONO

*::::::::::::::::::::::DESCRIMINACION DEL ABONO
			 lVlrConAbo(aVlrCon)

			 FOR i := 1 TO LEN(ALLTRIM(cCodRut))/2
			     cCodigoTco := SUBS(cCodRut,i*2-1,2)
			     j := ASCAN(aVlrCon,{|aArr|aArr[1] == cCodigoTco})
			     IF j # 0
				nVlrPag += aVlrCon[j,3]
			     ENDIF
			 ENDFOR

			 nTotPag += nVlrPag
*::::::::::::::::::::::FIN DESCRIMINACION DEL ABONO

		       DES->(DBSKIP())

		   ENDDO

		 ENDIF
*--------------FIN RECORRIDO DE LOS ABONOS


*--------------IMPRESION DEL REGISTRO
		 cConEst := ALLTRIM(&cMaeAct->cCodigoRut)+'=>'+;
			    ALLTRIM(&cMaeAct->cConcepEst)
		 cConEst := SUBS(cConEst+SPACE(16),1,16)

		 aTitulo := {STR(++nNroEst,2),;
			     &cMaeAct->cCodigoEst,;
			     &cMaeAct->cCodigoGru,;
			     cNombreTes,;
			     cMes(PAG->nMesIniPag,3)+'/'+;
				  cMes(PAG->nMesFinPag,3)+':'+;
				  STR(nNroMesFac(PAG->nMesIniPag,;
				  PAG->nMesFinPag),2),;
			     PAG->cConcepPag,;
			     TRANS(nSdoAct,"####,###,###"),;
			     IF(lHayPag .AND. lHayAlu,;
				TRANS(nVlrPag,"####,###,###"),SPACE(12)),;
			     IF(lHayPag .AND. lHayAlu ,cEstadoTpa,SPACE(12))}

		 cTxtPrn := cRegPrint(aTitulo,aNroCol)
		 lPrnReg(01,00,cTxtPrn,bPagina,bDerAut,bCabeza)
*--------------FIN IMPRESION DEL REGISTRO

		 SELECT CLI
		 CLI->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO POR EL GRUPO

	  CloseDbf('CLI',FileCli,nModCry)
	  SELECT GRU
	  GRU->(DBSKIP())

       ENDDO
       CloseDbf('CLI',FileCli,nModCry)
*>>>>IMPRESION DEL CUERPO DEL INFORME

*>>>>IMPRESION DE LOS TOTALES
       @ PROW()+1  ,nColTxt(aNroCol,07) SAY REPL('=',aNroCol[07])
       @ PROW()    ,nColTxt(aNroCol,08) SAY REPL('=',aNroCol[08])

       @ PROW()+1,00 SAY 'TOTALES ...'
       @ PROW()  ,nColTxt(aNroCol,07) SAY TRANS(nTotSdo,"####,###,###")
       @ PROW()  ,nColTxt(aNroCol,08) SAY TRANS(nTotPag,"##,###,###")
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SELECT URU
       SET FILTER TO
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS