/* SIMA - CUENTAS POR PAGAR

MODULO      : CONSULTAS
SUBMODULO...: FACTURAS

**************************************************************************
* TITULO..: FACTURAS                                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 10/2004 VIE A
       Colombia, Bucaramanga        INICIO: 02:00 AM   OCT 10/2004 VIE

OBJETIVOS:

1- Permite consultar las facturas registradas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Pagos_301(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,cEmpPal,;
		   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatDat,cPatSys,cPatSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de Empresa
       cNitEmp                              // Nit de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre de la Empresa Secundario
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatDat                              // Path datos del Sistema
       cPatSys                              // Path del Sistema
       cPatSis                              // Path del sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-PAGOS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n uno
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathCxPAno(lShared,cPatSis(cPatDat,cPatSys,cPatSis),cAnoUsr,;
		  @cIntUno,@cIntDos,@cIntTre,@cIntCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimCxP,'CXP',NIL,lShared,nModCry})
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
       CASE CXP->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       lPrnArc := CXP->lPrnArcCxP
       nCodPrn := CXP->nCodigoPrn
       cOpcPrn := CXP->cOpcPrnCxP
       CloseAll()
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>AREAS DE TRABAJO
       aArchvo := {}
       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN',lShared,nModCry})

       AADD(aArchvo,{cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		     FileFac+cAnoUsr+ExtFile,;
		     cPatSis(cPatDat,cPatSys,cPatSis)+'\'+;
		     fNtxFac,;
		     'FAC',lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>MANTENIMEINTO DEL REGISTRO
       lModReg := .T.
       lDelReg := .T.
       lInsReg := .F.
       lHaySql := .F.
*>>>>FIN MANTENIMEINTO DEL REGISTRO

*>>>>MANTENIMIENTO DEL ARCHIVO
       MantenFac(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
		 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
		 aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
		 lModReg,lDelReg,lInsReg,lHaySql)

       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO