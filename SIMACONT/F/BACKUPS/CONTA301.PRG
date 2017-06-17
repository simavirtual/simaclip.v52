/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: POR PROFESOR

**************************************************************************
* TITULO..: MENU INFORMES POR PROFESOR                                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/2002 VIE A
       Bucaramanga, Colombia	    INICIO: 02:45 PM   OCT 18/2002 VIE

OBJETIVOS:

1- Visualiza el men£ de los informes por Profesor.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_301(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
       LOCAL cCodSui := ''                  // C¢digo del Sistema
       LOCAL cNomSis := ''                  // Nombre del Sistema
     *ÀDetalles del Sistema

       LOCAL cEmpPal := ''                  // Nombre de la Empresa principal
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cNomSec := ''                  // Nombre de la Empresa Secundario
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
     *ÀDetalles de la Empresa

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL cPatSis := ''                  // Path del sistema
     *ÀDetalles del Usuario

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
       LOCAL PathW02 := ''                  // Sitio del Sistema No.02
       LOCAL PathW03 := ''                  // Sitio del Sistema No.03
       LOCAL PathW04 := ''                  // Sitio del Sistema No.04
       LOCAL PathW05 := ''                  // Sitio del Sistema No.05
       LOCAL PathW06 := ''                  // Sitio del Sistema No.06
       LOCAL PathW07 := ''                  // Sitio del Sistema No.07
       LOCAL PathW08 := ''                  // Sitio del Sistema No.08
       LOCAL PathW09 := ''                  // Sitio del Sistema No.09
       LOCAL PathW10 := ''                  // Sitio del Sistema No.10
     *ÀSitios del Sistema

       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de Integraci¢n Dos
       LOCAL PathTre := ''                  // Path de Integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
     *ÀPath de Integraci¢n

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF  !lParam0102(aParams,;
		       @lShared,@nModCry,@cCodSui,@cNomSis,;
		       @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		       @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		       @nFilPal,@nFilInf,@nColInf,;
		       @PathW01,@PathW02,@PathW03,@PathW04,@PathW05,;
		       @PathW06,@PathW07,@PathW08,@PathW09,@PathW10,;
		       @PathUno,@PathDos,@PathTre,@PathCua,;
		       @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aParam1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<LISTAS DE CLASE      >')
       AADD(aMenus,'2<INDICADORES FINALES  >')
       AADD(aMenus,'3<INDICADORES PARCIALES>')
       AADD(aMenus,'4<RESUMEN INDICADORES  >')
       AADD(aMenus,'5<PLANILLA DEL PERIODO >')
       AADD(aMenus,'6<RECUPERACIONES       >')
       AADD(aMenus,'7<RESUMEN JUICIOS      >')
       AADD(aMenus,'8<VALIDACION           >')
       AADD(aMenus,'9<ACTUALIZACION        >')

       AADD(aAyuda,'Imprime las listas de Clase')
       AADD(aAyuda,'Imprime la lista de indicadores finales.')
       AADD(aAyuda,'Imprime los indicadores parciales')
       AADD(aAyuda,'Imprime el resumen de Indicadores')
       AADD(aAyuda,'Imprime los Indicadores aplicados a cada Estudiante')
       AADD(aAyuda,'Imprime las Recuperaciones Pendientes')
       AADD(aAyuda,'Imprime el Resumen de los Juicios Valorativos por Peri¢dos')
       AADD(aAyuda,'Permite validar la informaci¢n del Profesor en la Contabilidad')
       AADD(aAyuda,'Permite Actualizar la informaci¢n del Profesor en la Contabilidad')

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
	    Conta_311(aParam1,aParam2,aParam3)
	   *Listas de Clase

       CASE nNroOpc == 2
	    Conta_312(aParam1,aParam2,aParam3)
	   *Indicadores Finales

       CASE nNroOpc == 3
	    cError('PENDIENTE')

       CASE nNroOpc == 4
	    cError('PENDIENTE')

       CASE nNroOpc == 5
	    cError('PENDIENTE')

       CASE nNroOpc == 6
	    cError('PENDIENTE')

       CASE nNroOpc == 7
	    Conta_317(aParam1,aParam2,aParam3)
	   *Resumen Juicios

       CASE nNroOpc == 8
	    Conta_318(aParam1,aParam2,aParam3)
	   *Validacion SimaProf <-> SimaCont

       CASE nNroOpc == 9
	    Conta_319(aParam1,aParam2,aParam3)
	   *Actualizaci¢n SimaProf <-> SimaCont

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA