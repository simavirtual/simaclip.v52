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

FUNCTION Cafe_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

*>>>>DESCRIPCION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nTipPer := 0                   // Tipo de Personal
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       aAyuda  := {}
       AADD(aMenus,'1<POR INTERVALOS>')
       AADD(aMenus,'2<UNA POR UNA   >')

       AADD(aAyuda,'Registra las Boletas vendidas por Intervalos')
       AADD(aAyuda,'Registra las Boletas vendidas una por una')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Cafe_411(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt,nNroOpc)
	   *Por Intervalos

       CASE nNroOpc == 2
	    Cafe_412(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt,nNroOpc)
	   *Una por Una

       ENDCASE

       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA