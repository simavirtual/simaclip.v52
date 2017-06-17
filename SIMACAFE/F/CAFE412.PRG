/*SIMA - SISTEMA DE CAFETERIA

MODULO      : BOLETAS
SUBMODULO...: VENTAS                                   MODULO No. 402

**************************************************************************
* TITULO..: VENTAS DE BOLETAS                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 07/2002 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 PM   OCT 07/2002 LUN

OBJETIVOS:

1- Permite digitar las boletas vendidas.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_412(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL bMarco  := NIL                 // Code Block del Marco

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal

       LOCAL lGrabar := .F.                 // .T. Grabar el Registro
       LOCAL dFecVen := CTOD('00/00/00')    // Fecha de Venta General

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTbo := ''               // C¢digo de la Boleta
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
       aTitulo := {'BOLETA No.','FECHA DE VENTA'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>REGISTRO DE LAS BOLETAS VENDIDAS
       nNroFil++
       DO WHILE .T.

**********LECTURA DEL CODIGO
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)
	    cCodigoTbo := SPACE(14)
	    dFecVenTbo := dFecVen

	    @ nNroFil,aNroCol[1] GET cCodigoTbo PICT '@! X9999999999999';
				 VALID lValCodBol(@cCodigoTbo,2)
	    READ
	    IF EMPTY(cCodigoTbo)
	       EXIT
	    ENDIF
**********LECTURA DEL CODIGO

**********BUSQUEDA DEL CODIGO
	    IF !lSekCodigo(cCodigoTbo,'BOL','DE LA BOLETA')
	       LOOP
	    ENDIF
**********FIN BUSQUEDA DEL CODIGO

**********LOCALIZACION DEL TIPO DE PERSONAL
	    IF !lLocCodigo('cCodigoTip','TIP',SUBS(cCodigoTbo,1,1))
	       cError('EL CODIGO DEL TIPO '+SUBS(cCodigoTbo,1,1)+' '+;
		      'NO EXISTE')
	       LOOP
	    ENDIF
	    IF !TIP->lBoletaTip
	       cError('EL CODIGO DEL TIPO '+SUBS(cCodigoTbo,1,1)+' '+;
		      'NO ES DE UNA BOLETA')
	    ENDIF
**********FIN LOCALIZACION DEL TIPO DE PERSONAL

**********VALIDACION DE LA BOLETA
	    IF !EMPTY(BOL->dFecCnsBol)
	       cError('LA BOLETA YA FUE UTILIZADA')
	       LOOP
	    ENDIF
	    IF !EMPTY(BOL->dFecVenBol)
	       cError('LA BOLETA YA FUE VENDIDA')
	       LOOP
	    ENDIF

	    IF EMPTY(BOL->dFecVenBol)
	       dFecVenTbo := dFecVen
	    ELSE
	       dFecVenTbo := BOL->dFecVenBol
	    ENDIF
**********FIN VALIDACION DE LA BOLETA

**********LECTURA DE LA FECHA DE VENTA
	    @ 21,20 SAY 'INGRESE LA FECHA EN EL SGTE ORDEN: (MM/DD/AA)'
	    @ nNroFil,aNroCol[2] GET dFecVenTbo  PICT '@D';
				 VALID !EMPTY(dFecVenTbo)
	    READ
	    nNroFil := Fila(nNroFil+1,bMarco)
**********FIN LECTURA DE LA FECHA DE VENTA

**********GRABACION DEL REGISTRO
	    lGrabar := .F.
	    IF BOL->(lRegLock(lShared,.F.))

	       REPL BOL->dFecVenBol WITH dFecVenTbo
	       BOL->(DBCOMMIT())
	       lGrabar := .T.
	       IF lShared
		  BOL->(DBUNLOCK())
	       ENDIF

	     ENDIF
**********FIN GRABACION DEL REGISTRO

**********GRABACION DEL REGISTRO
	    IF lGrabar
	       IF TIP->(lRegLock(lShared,.F.))

		  REPL TIP->nTotVenTip WITH TIP->nTotVenTip+1
		  TIP->(DBCOMMIT())
		  IF lShared
		     TIP->(DBUNLOCK())
		  ENDIF

	       ENDIF
	    ENDIF
**********FIN GRABACION DEL REGISTRO

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN REGISTRO DE LAS BOLETAS VENDIDAS