/*SIMA - SISTEMA DE CAFETERIA

MODULO      : INFORMES
SUBMODULO...: ETIQUETAS                                MODULO No. 301

**************************************************************************
* TITULO..: IMPRESION DE ETIQUETAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 21/2002 VIE A
       Colombia, Bucaramanga        INICIO: 11:30 AM   JUN 21/2002 VIE

OBJETIVOS:

1- Permite imprimir las etiquetas de c¢digos para pegar en los carnets

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cafe_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL nTipPer := 0                   // Tipo de Personal
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DESCRIPCION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       aAyuda  := {}
       AADD(aMenus,'1<ESTUDIANTES>')
       AADD(aMenus,'2<PROFESORES >')
       AADD(aMenus,'3<PERSONAL   >')
       AADD(aMenus,'4<BOLETAS    >')

       AADD(aAyuda,'Imprime las Etiquetas de los Estudiantes')
       AADD(aAyuda,'Imprime las Etiquetas de los Profesores')
       AADD(aAyuda,'Imprime las Etiquetas del Personal Actual')
       AADD(aAyuda,'Imprime las Etiquetas de las Boletas')

       cSavPan := SAVESCREEN(0,0,24,79)
       nTipPer := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nTipPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>SELECCION DEL TIPO DE IMPRESION
       aMenus := {}
       aAyuda  := {}
       DO CASE
       CASE nTipPer == 1
	    AADD(aMenus,'1<POR GRUPOS    >')
	    AADD(aMenus,'2<POR ESTUDIANTE>')

	    AADD(aAyuda,'Imprime las Etiquetas por Grupos')
	    AADD(aAyuda,'Imprime las Etiquetas por Estudiante')

       CASE nTipPer == 2
	    AADD(aMenus,'1<   TODAS   >')
	    AADD(aMenus,'2<UNA POR UNA>')

	    AADD(aAyuda,'Imprime las Etiquetas de todos los Profesores')
	    AADD(aAyuda,'Imprime las Etiquetas por Profesor')

       CASE nTipPer == 3
	    AADD(aMenus,'1<   TODAS   >')
	    AADD(aMenus,'2<UNA POR UNA>')

	    AADD(aAyuda,'Imprime las Etiquetas de todo el Personal Actual')
	    AADD(aAyuda,'Imprime las Etiquetas por Persona')

       CASE nTipPer == 4
	    AADD(aMenus,'1<   TODAS   >')
	    AADD(aMenus,'2<UNA POR UNA>')

	    AADD(aAyuda,'Imprime las Etiquetas de todas las Boletas')
	    AADD(aAyuda,'Imprime las Etiquetas de las Boletas Una por Una')
       ENDCASE

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DEL TIPO DE IMPRESION

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Cafe_311(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt,nTipPer)
	   *Etiquetas por Grupo o Todas

       CASE nNroOpc == 2
	    Cafe_312(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		     cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
		     cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
		     cJorTxt,nTipPer)
	   *Etiquetas por Estudiante o Una por Una

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

