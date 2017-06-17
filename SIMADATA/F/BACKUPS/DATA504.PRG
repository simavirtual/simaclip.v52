/* SIMA - CENTRAL DE RIESGOS

MODULO      : MODULO PRINCIPAL
SUBMODULO...: UTILIDADES

**************************************************************************
* TITULO..: MENU DE MATENIMIENTO ARCHIVOS DEL SISTEMA                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 19/2004 LUN A
       Colombia, Bucaramanga        INICIO: 06:30 PM   ABR 19/2004 LUN

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Data_504(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-DATA.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathDatAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       AADD(aMenus,'1<EMPRESAS     >')
       AADD(aMenus,'2<VALOR INICIAL>')
       AADD(aMenus,'3<RESTAURAR    >')

       AADD(aAyuda,'Permite el Mantenimiento de las Empresas Habilitadas')
       AADD(aAyuda,'Permite definir el valor inicial de la Oblibacici¢n.Costos Educativos')
       AADD(aAyuda,'Permite Restaurar las novedades del £ltimo reporte')
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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-2,nColInf,NIL,NIL,;
			   nNroOpc,.F.,;
			   IF(!EMPTY(xClrSys),xClrSys[4],''))

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       MantenEmp(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			 cJorTxt)
	     *Empresas



	  CASE nNroOpc == 2

		cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)

***************AREAS DE TRABAJO
		 aUseDbf := {}

		 AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',;
				   NIL,lShared,nModCry})

		 AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
				   FileNiv+cAnoSis+ExtFile,'NIV',;
				   NIL,lShared,nModCry})
***************FIN AREAS DE TRABAJO

***************MANTENIMIENTO DEL TOTAL DE SERVICIOS EDUCATIVOS
		 ManTotSer(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			   cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			   cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			   cJorTxt,aUseDbf)
***************FIN MANTENIMIENTO DEL TOTAL DE SERVICIOS EDUCATIVOS

	  CASE nNroOpc == 3

	       Data_543(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
			 cJorTxt)
	      *Restuar novedades

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA