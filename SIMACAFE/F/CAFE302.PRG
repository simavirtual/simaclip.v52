/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: CARNETS                                  MODULO No. 302

**************************************************************************
* TITULO..: IMPRESION DE CARNETS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 01/2002 LUN A
       Colombia, Bucaramanga        INICIO: 08:00 PM   JUL 01/2002 LUN

OBJETIVOS:

1- Permite imprimir los carnets para ingresar a la Cafeteria

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_302(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		  cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		  cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DESCRIPCION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<POR GRUPOS    >')
       AADD(aMenus,'2<POR ESTUDIANTE>')

       AADD(aAyuda,'Imprime los Carnets por Grupos')
       AADD(aAyuda,'Imprime los Carnets por Estudiante')

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
	    Cafe_321(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt)
	   *Carntes por Grupo

       CASE nNroOpc == 2
	    Cafe_322(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt)
	   *Carntes por Estudiante

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA