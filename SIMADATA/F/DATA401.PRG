/* SIMA - CENTRAL DE RIESGOS

MODULO      : INFORMES
SUBMODULO...: CONTRATANTES

**************************************************************************
* TITULO..: MENU IMPRESION DE CONTRATANTES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 05/2004 JUE A
       Colombia, Bucaramanga        INICIO: 10:15 AM   AGO 05/2004 JUE

OBJETIVOS:

1- Visualiza el men£ de impresi¢n de contratantes

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<POR GRADOS>')
       AADD(aMenus,'2<POR GRUPOS>')

       AADD(aAyuda,'Imprime los contrantes por grados')
       AADD(aAyuda,'Imprime los contrantes por grupos')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilPal+3,nColInf+2,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Data_411(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt)
	   *Contratantes por Grados

       CASE nNroOpc == 2
	    Data_412(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt)
	   *Contratantes por Grupos

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA