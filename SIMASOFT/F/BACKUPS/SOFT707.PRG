/*                      SIMASOFT - SISTEMA ADMINISTRADOR

MODULO     : UTILIDADES
SUBMODULO..: MANTENIMIENTOS                            MODULO No. 707

**************************************************************************
* TITULO..: MATENIMIENTO ARCHIVOS DEL SISTEMA                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 06/2002 VIE A
       Colombia, Bucaramanga        INICIO: 03:15 PM   SEP 06/2002 VIE

OBJETIVOS:

1- Visualiza un men£ para seleccionar las diferentes Configuraciones
   del Sistema.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Soft_707(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
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

       LOCAL GetList := {}                  // Variable del Sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       AADD(aMenus,'1<CIUDADES     >')
       AADD(aMenus,'1<TIPO EMPRESAS>')

       AADD(aAyuda,'Realiza el Mantenimiento del archivo Ciudades')
       AADD(aAyuda,'Realiza el Mantenimiento del archivo Tipo de Empresas')
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
	       MantenCiu(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)
	      *Ciudades

	  CASE nNroOpc == 2
	       MantenTip(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis)
	      *Tipo de Empresas
	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA