/*SIMA - SISTEMA DE CAFETERIA

MODULO      : BOLETAS
SUBMODULO...: VENTAS - POR INTERVALOS                   MODULO No. 411

**************************************************************************
* TITULO..: VENTAS DE BOLETAS POR INTERVALOS                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 07/2002 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 PM   OCT 07/2002 LUN

OBJETIVOS:

1- Permite digitar las boletas vendidas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_411(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-CAFE.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL       i := 0                   // Contador
       LOCAL nNroIni := 0                   // N£mero de Boleta Inicial
       LOCAL nNroFin := 0                   // N£mero de Boleta Final
       LOCAL bMarco  := NIL                 // Code Block del Marco

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL lGrabar := .F.                 // .T. Grabar el Registro
       LOCAL dFecVen := CTOD('00/00/00')    // Fecha de Venta General
       LOCAL cNroBol := ''                  // N£mero de Boleta

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTbo := ''               // C¢digo de la boleta
       LOCAL cCodUnoTbo := ''               // C¢digo de la Boleta Inicial
       LOCAL cCodDosTbo := ''               // C¢digo de la Boleta Final
       LOCAL dFecVenTbo := CTOD('00/00/00') // Fecha de Venta
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTip+cAnoUsr+ExtFile,'TIP',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileBol,'BOL',;
			 PathSis+'\'+fNtxBol,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE BOL->(RECCOUNT()) == 0
	    cError('NO EXISTEN BOLETAS EMITIDAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE LA FECHA DE VENTA GENERAL
       dFecVen := DATE()
       @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
       @ nFilInf+1,nColInf-2 SAY 'FECHA DE VENTA:' GET dFecVen PICT '@D'
       READ
*>>>>FIN LECTURA DE LA FECHA DE VENTA GENERAL

*>>>>IMPRESION DE LOS ENCABEZADOS
       bMarco := {||nMarco(nFilPal+1,'POR FAVOR DIGITE NUMEROS DE LAS '+;
				     'BOLETAS',22,'°')}
       nNroFil := EVAL(bMarco)

       aTamCol := {14,14}
       aTitulo := {'BOLETA INICIAL No.','BOLETA FINAL No.'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>REGISTRO DE LAS BOLETAS VENDIDAS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodUnoTbo := SPACE(14)
	    cCodDosTbo := SPACE(14)
	    dFecVenTbo := dFecVen

	    @ nNroFil,aNroCol[1] GET cCodUnoTbo PICT '@! X9999999999999';
				 VALID lValCodBol(@cCodUnoTbo,2)

	    @ nNroFil,aNroCol[2] GET cCodDosTbo PICT '@! X9999999999999';
				 VALID lValCodBol(@cCodDosTbo,2)
	    READ
	    IF EMPTY(cCodUnoTbo) .OR. EMPTY(cCodDosTbo)
	       EXIT
	    ENDIF
	    nNroIni := VAL(SUBS(cCodUnoTbo,2,7))
	    nNroFin := VAL(SUBS(cCodDosTbo,2,7))
**********LECTURA DEL CODIGO

**********LOCALIZACION DEL TIPO DE PERSONAL
	    IF !lLocCodigo('cCodigoTip','TIP',SUBS(cCodUnoTbo,1,1))
	       cError('EL CODIGO DEL TIPO '+SUBS(cCodUnoTbo,1,1)+' '+;
		      'NO EXISTE')
	       LOOP
	    ENDIF
	    IF !TIP->lBoletaTip
	       cError('EL CODIGO DEL TIPO '+SUBS(cCodUnoTbo,1,1)+' '+;
		      'NO ES DE UNA BOLETA')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL TIPO DE PERSONAL

**********VALIDACION DE LA BOLETA
	    lHayErr := .T.
	    DO CASE
	    CASE SUBS(cCodUnoTbo,1,1) # SUBS(cCodDosTbo,1,1)
		 cError('LOS NUMEROS DE LA BOLETAS DEBEN SER DEL MISMO TIPO')

	    CASE nNroIni > nNroFin
		 cError('EL NUMERO INICIAL NO PUEDE '+;
			'SER MAYOR AL NUMERO FINAL')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA BOLETA

**********VALIDACION DE LOS CODIGOS
	    FOR i := nNroIni TO nNroFin

	       cNroBol := STR(i,6)
	       lCorrecion(@cNroBol)
	       cCodigoTbo := TIP->cCodigoTip+cNroBol

	       IF !lSekCodigo(cCodUnoTbo,'BOL','DE LA BOLETA')
		  lHayErr := .T.
		  EXIT
	       ENDIF

	       lHayErr := .T.
	       DO CASE
	       CASE !EMPTY(BOL->dFecCnsBol)
		    cError('LA BOLETA YA FUE UTILIZADA')

	       CASE !EMPTY(BOL->dFecVenBol)
		    cError('LA BOLETA YA FUE VENDIDA')

	       OTHERWISE
		    lHayErr :=.F.
	       ENDCASE
	       IF lHayErr
		  EXIT
	       ENDIF

	    ENDFOR
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS CODIGOS

**********GRABACION DEL REGISTRO
	    nNroFil := Fila(nNroFil+1,bMarco)
	    FOR i := nNroIni TO nNroFin

*-------------BUSQUEDA DEL CODIGO DE LA BOLETA
		cNroBol := STR(i,6)
		lCorrecion(@cNroBol)
		cCodigoTbo := TIP->cCodigoTip+cNroBol

		IF lSekCodigo(cCodigoTbo,'BOL')

*..................IMPRESION DE LA LINEA DE ESTADO
		     LineaEstado('BOLETA No.: '+cCodigoTbo+'/'+;
				  cCodDosTbo,cNomSis)
*..................FIN IMPRESION DE LA LINEA DE ESTADO

*..................GRABACION DE LA FECHA DE VENTA
		     IF BOL->(lRegLock(lShared,.F.))

			REPL BOL->dFecVenBol WITH dFecVenTbo
			BOL->(DBCOMMIT())
			IF lShared
			   BOL->(DBUNLOCK())
			ENDIF

		      ENDIF
*..................FIN GRABACION DE LA FECHA DE VENTA

*..................GRABACION DEL TOTAL DE VENTAS
		     IF TIP->(lRegLock(lShared,.F.))

			REPL TIP->nTotVenTip WITH TIP->nTotVenTip+1
			TIP->(DBCOMMIT())
			IF lShared
			   TIP->(DBUNLOCK())
			ENDIF

		     ENDIF
*..................FIN GRABACION DEL TOTAL DE VENTAS

		ENDIF
*-------------FIN BUSQUEDA DEL CODIGO DE LA BOLETA

	    ENDFOR
**********GRABACION DEL REGISTRO

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN REGISTRO DE LAS BOLETAS VENDIDAS
