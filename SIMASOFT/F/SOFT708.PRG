/*                      SIMASOFT - SISTEMA ADMINISTRADOR

MODULO     : UTILIDADES
SUBMODULO..: CONFIGURACION                             MODULO No. 708

**************************************************************************
* TITULO..: CONFIGURACION DEL SISTEMA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 06/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   SEP 06/2002 VIE

OBJETIVOS:

1- Visualiza un men£ para seleccionar las diferentes Configuraciones
   del Sistema.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Soft_708(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
		  nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SOFT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cNomSec := ''                  // Nombre Secundario

       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql */

       LOCAL lHayPrg := .F.                 // .T. Generar c¢digo prg

       LOCAL GetList := {}                  // Variable del Sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSof,'SOF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE SOF->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',SOF->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       AADD(aMenus,'1<CONFIGURACION SISTEMA>')
       AADD(aMenus,'2<CONFIGURACION A¥O    >')
       AADD(aMenus,'3<CONFIGURACION COLOR  >')
       AADD(aMenus,'4<CONFIGURACION PRINTER>')
       AADD(aMenus,'5<ARCHIVOS DEL SISTEMA >')
       AADD(aMenus,'6<ESTRUCTURAS ARCHIVOS >')

       AADD(aAyuda,'Consulta la Configuraci¢n del Sistema')
       AADD(aAyuda,'Consulta la Configuraci¢n para el A¤o')
       AADD(aAyuda,'Consulta la Configuraci¢n del Color')
       AADD(aAyuda,'Consulta la Configuraci¢n de las Impresoras')
       AADD(aAyuda,'Consulta los Archivos del Sistema')
       AADD(aAyuda,'Consulta la Estructura de los Archivos')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-1,nColInf,NIL,NIL,;
			   nNroOpc,.F.,;
			   IF(!EMPTY(xClrSys),xClrSys[4],''))

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       MantenSof(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)
	      *Configuraci¢n del Sistema

	  CASE nNroOpc == 2

	  CASE nNroOpc == 3
	       MantenClr(lShared,nModCry,PathSis,FileClr)
	      *Configuraci¢n del Color

	  CASE nNroOpc == 4
	       MantenPrn(lShared,nModCry,cNomSis,cNomEmp,;
			 cNomUsr,cAnoUsr,PathSis,FilePrn,2)
	      *Configuraci¢n de la Impresora

	  CASE nNroOpc == 5

	       lModReg := .T.
	       lDelReg := .T.
	       lInsReg := .T.
	       lHaySql := .F.

	       lHayPrg := .T.
	       cCodEmp := 'COLSAN001999'
	       cNomSec := cNomEmp

	       MantenFsy(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
			 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
			 PathSis,FileDbf,NIL,SOF->lPrnArcSof,;
			 SOF->cOpcPrnSof,lModReg,lDelReg,lInsReg,;
			 lHaySql,lHayPrg)
	     *Archivos del Sistema

	  CASE nNroOpc == 6

	       lModReg := .T.
	       lDelReg := .T.
	       lInsReg := .T.
	       lHaySql := .F.

	       lHayPrg := .T.
	       cCodEmp := 'COLSAN001999'
	       cNomSec := cNomEmp

	       MantenStr(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
			 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
			 PathSis,FileStr,NIL,SOF->lPrnArcSof,;
			 SOF->cOpcPrnSof,lModReg,lDelReg,lInsReg,;
			 lHaySql,lHayPrg,lHayPrg)
	     *Estructura de los Archivos

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA