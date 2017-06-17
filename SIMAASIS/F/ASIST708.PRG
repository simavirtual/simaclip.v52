/* SIMA - CONTROL DE ASISTENCIA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: UTILIDADES                              MODULO No. 708

**************************************************************************
* TITULO..: CONFIGURACION DEL SISTEMA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 07/2004 LUN A
       Colombia, Bucaramanga        INICIO: 03:15 PM   JUN 07/2004 LUN

OBJETIVOS:

1- Visualiza un men£ para seleccionar las diferentes Configuraciones
   del Sistema.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Asist_708(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-ASIS.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathAsiAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>DECLARCION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<CONFIGURACION GENERAL>')
       AADD(aMenus,'2<CONFIGURACION SISTEMA>')
       AADD(aMenus,'3<CONFIGURACION A¥O    >')
       AADD(aMenus,'4<CONFIGURACION COLOR  >')
       AADD(aMenus,'5<CONFIGURACION PRINTER>')

       aAyuda := {}
       AADD(aAyuda,'Consulta la Configuraci¢n General del Sistema')
       AADD(aAyuda,'Consulta la Configuraci¢n del Sistema')
       AADD(aAyuda,'Consulta la Configuraci¢n para el A¤o')
       AADD(aAyuda,'Consulta la Configuraci¢n del Color')
       AADD(aAyuda,'Consulta la Configuraci¢n de las Impresoras')
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
	       ManSimCon(lShared,NIL,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 NIL,NIL,nFilPal,nFilInf,nColInf,cNomUsr,;
			 cAnoUsr,cPatSis,PathUno,PathDos,PathTre,;
			 PathCua,cMaeAlu,cMaeAct,cJorTxt,NIL,.F.,.T.)
	      *Mantenimiento Configuraci¢n del Sistema

	  CASE nNroOpc == 2
	       MantenAsi(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			 cJorTxt)
	      *Configuraci¢n del Sistema

	  CASE nNroOpc == 3
	       ManAsiAno(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			 cJorTxt)
	      *Configuraci¢n del A¤o

	  CASE nNroOpc == 4
	       MantenClr(lShared,nModCry,PathSis,FileClr)
	      *Configuraci¢n del Color

	  CASE nNroOpc == 5
	       MantenPrn(lShared,nModCry,cNomSis,cNomEmp,;
			 cNomUsr,cAnoUsr,PathSis,FilePrn,2)
	      *Configuraci¢n de la Impresora

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA