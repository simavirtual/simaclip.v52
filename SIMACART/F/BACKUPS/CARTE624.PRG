/* SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: CONCEPTOS RUTAS                          MODULO No. 604

**************************************************************************
* TITULO..: CONSULTA DE LOS CONCEPTOS DE LAS RUTAS                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2001 MAR A
       Bucaramanga, Colombia	    INICIO: 02:00 AM   OCT 16/2001 MAR

OBJETIVOS:

1- Permite consultar los conceptos de Rutas

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_624(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"      // Archivos del Sistema

       LOCAL oBrowse := NIL                 // Objeto para el Concepto
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
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileCon,'CON',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>FILTRACION DEL ARCHIVO
       SELECT CON
       SET FILTER TO CON->nTipoCon == 1
       GO TOP
       IF EOF()
	  SET FILTER TO
	  cError('NO EXISTEN CONCEPTOS DE RUTAS')
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>MANTENIMIENTO DEL ARCHIVO
       oBrowse := oBrwConRut(lShared,nFilPal+1,00,22,79)
       CON->(CtrlBrw(lShared,oBrowse))
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE DE CONCEPTOS RUTAS              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 16/2001 MAR A
       Bucaramanga, Colombia	    INICIO: 02:10 PM   OCT 16/2001 MAR

OBJETIVOS:

1- Define el objeto Browse de los Conceptos de Rutas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oBrwConRut(lShared,nFilSup,nColSup,nFilInf,nColInf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse			    // Browse de Conceptos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<CONCEPTOS DE RUTAS>>','<ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT CON
       oColumn	     := TBCOLUMNNEW('CODIGO', {||CON->cCodigoCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRE DEL CONCEPTO', {||CON->cNombreCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('TIPO DE CONCEPTO', {||CON->nTipoCon})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE