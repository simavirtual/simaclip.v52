/* SIMA - CONTABILIDAD PROFESORES

MODULO      : UTILIDADES
SUBMODULO...: ACTUALIZAR ESTRUCTURAS

**************************************************************************
* TITULO..: ACTUALIZACION DE ESTRUCTURAS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 30/2001 MAR A
       Colombia, Bucaramanga        INICIO: 03:00 PM   OCT 30/2001 MAR

OBJETIVOS:

1- Visualiza un men£ para actualizar los archivos de los profesores

2- Ejecuta las diferentes funciones del mantemiento

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_704(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := xPrm(aP1,'lShared') // .T. Sistema Compartido
       LOCAL nModCry := xPrm(aP1,'nModCry') // Modo de Protecci¢n
       LOCAL cCodSui := xPrm(aP1,'cCodSui') // C¢digo del Sistema
       LOCAL cNomSis := xPrm(aP1,'cNomSis') // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := xPrm(aP1,'cEmpPal') // Nombre de la Empresa principal
       LOCAL cNitEmp := xPrm(aP1,'cNitEmp') // Nit de la Empresa
       LOCAL cNomEmp := xPrm(aP1,'cNomEmp') // Nombre de la Empresa
       LOCAL cNomSec := xPrm(aP1,'cNomSec') // Nombre de la Empresa Secundario
       LOCAL cCodEmp := xPrm(aP1,'cCodEmp') // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := xPrm(aP1,'cNomUsr') // Nombre del Usuario
       LOCAL cAnoUsr := xPrm(aP1,'cAnoUsr') // A¤o del usuario
       LOCAL cAnoSis := xPrm(aP1,'cAnoSis') // A¤o del sistema
       LOCAL cPatSis := xPrm(aP1,'cPatSis') // Path del sistema
     *ÀDetalles del Usuario

       LOCAL PathW01 := xPrm(aP1,'PathW01') // Sitio del Sistema No.01
       LOCAL PathW02 := xPrm(aP1,'PathW02') // Sitio del Sistema No.02
       LOCAL PathW03 := xPrm(aP1,'PathW03') // Sitio del Sistema No.03
       LOCAL PathW04 := xPrm(aP1,'PathW04') // Sitio del Sistema No.04
       LOCAL PathW05 := xPrm(aP1,'PathW05') // Sitio del Sistema No.05
       LOCAL PathW06 := xPrm(aP1,'PathW06') // Sitio del Sistema No.06
       LOCAL PathW07 := xPrm(aP1,'PathW07') // Sitio del Sistema No.07
       LOCAL PathW08 := xPrm(aP1,'PathW08') // Sitio del Sistema No.08
       LOCAL PathW09 := xPrm(aP1,'PathW09') // Sitio del Sistema No.09
       LOCAL PathW10 := xPrm(aP1,'PathW10') // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := xPrm(aP1,'PathUno') // Path de Integraci¢n Uno
       LOCAL PathDos := xPrm(aP1,'PathDos') // Path de Integraci¢n Dos
       LOCAL PathTre := xPrm(aP1,'PathTre') // Path de Integraci¢n Tres
       LOCAL PathCua := xPrm(aP1,'PathCua') // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
       CloseAll()
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

/*
       AADD(aMenus,'1<PROFESOR   >')
       AADD(aMenus,'2<CARGAS STR >')
       AADD(aMenus,'3<MATERIAS   >')
       AADD(aMenus,'4<ASIGNATURAS>')
       AADD(aMenus,'5<CODIGOS    >')
*/
       AADD(aMenus,'1<ASIGNACION >')
       AADD(aMenus,'2<ESTRUCTURAS>')

       AADD(aMenus,'3<CORREGIR   >')
/*
       AADD(aAyuda,'Actualiza la Estructura del Archivo Configuraci¢n del Profesor')
       AADD(aAyuda,'Actualiza la Estructura del Archivo de Carga Acad‚mica del Profesor')
       AADD(aAyuda,'Actualiza la Estructura del Archivo de Materias del Profesor')
       AADD(aAyuda,'Actualiza Todas las Estructuras de la Asignaturas que dicta Profesor')
       AADD(aAyuda,'Actualiza los C¢digos para las Recuperaciones')
*/
       AADD(aAyuda,'Actualiza la Asignaci¢n Acad‚mica insertando las materias nuevas del Profesor')
       AADD(aAyuda,'Actualiza Todas las Estructuras de la Asignaturas que dicta Profesor')
       AADD(aAyuda,'Permite corregir las notas de las recuperaciones')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  RESTSCREEN(0,0,24,79,cSavPan)
	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

/*
	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Profe_742(aP1,aP2,aP3)
	      *Actualiza la Estructura de la Carga Acad‚mica

	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Profe_744(aP1,aP2,aP3)
	      *Actualiza la Estructura de todas las Asignaturas

	  CASE nNroOpc == 5
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Profe_745(aP1,aP2,aP3)
	      *Actualiza los C¢digos para Recuperaciones


	  CASE nNroOpc == 6
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Profe_746(aP1,aP2,aP3)
	      *Asignaci¢n
*/

	  CASE nNroOpc == 1
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Profe_746(aP1,aP2,aP3)
	      *Asignaci¢n

	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Profe_744(aP1,aP2,aP3)
	      *Actualiza la Estructura de todas las Asignaturas

	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
*	       Profe_743(aP1,aP2,aP3)
	       Profe_747(aP1,aP2,aP3)
	      *Recalculo notas de las recuperaciones. Isb
*	       Profe_748(aP1,aP2,aP3)

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA