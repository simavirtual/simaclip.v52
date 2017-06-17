/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : MODULO PRINCIPAL
SUBMODULO...: UTILIDADES                               MODULO No. 709

**************************************************************************
* TITULO..: MENU DE UTILIDADES VARIOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 26/94 LUN A
						       DIC 26/94 LUN
REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ de los archivos a realizarle el mantenimiento

2- Ejecuta las diferentes funciones del mantemiento


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_709(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de Integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n dos
       LOCAL PathTre := ''                  // Path de integraci¢n tres
       LOCAL PathCua := ''                  // Path de integraci¢n cuatro
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

LOCAL lIntUno := .T.
LOCAL lIntDos := .T.
LOCAL lIntTre := .F.
LOCAL lIntCua := .F.

*>>>>DECLARACION PARAMETROS GENERALES
       LOCAL lShared := .T.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // Modo de Protecci¢n
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

       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cJorTxt := ''                  // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := 0                   // Fila Inferior Men£ principal
       LOCAL nFilInf := 0                   // Fila Inferior del SubMen£
       LOCAL nColInf := 0                   // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL PathW01 := ''                  // Sitio del Sistema No.01
     *ÀSitios del Sistema

       LOCAL aParams := {}                  // Parametros Generales
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>LECTURA PARAMETROS GENERALES
       aParams := aParams(aParam1,aParam2,aParam3)
       IF !lParam0104(aParams,;
		      @lShared,@nModCry,@cNomSis,;
		      @cEmpPal,@cNitEmp,@cNomEmp,@cNomSec,@cCodEmp,;
		      @cNomUsr,@cAnoUsr,@cAnoSis,@cPatSis,;
		      @nFilPal,@nFilInf,@nColInf,;
		      @PathW01,;
		      @cMaeAlu,@cMaeAct,@cJorTxt)
	  CloseAll()
	  RETURN NIL
       ENDIF
       CloseAll()
*>>>>FIN LECTURA PARAMETROS GENERALES

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
*>>>>FIN LECTURA DE PATHS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)


       aMenus := {'1<DIGIGO DE CHEQUEO    >',;
		  '2<CONTROL DE RECIBOS   >',;
		  '3<CONSULTAR IMPRESION  >',;
		  '4<LOG DE ERRORES       >',;
		  '5<VALOR POR GRUPOS     >',;
		  '6<SITUACION DEL CLIENTE>'}

/*
       aMenus := {'1<DIGIGO DE CHEQUEO    >',;
		  '2<CONTROL DE RECIBOS   >',;
		  '3<CONSULTAR IMPRESION  >',;
		  '4<LOG DE ERRORES       >',;
		  '5<VALOR POR GRUPOS     >'}
*/


       aAyuda := {'Permite Calcular los digitos de Chequeo',;
		  'Permite Consultar el Control de los Recibos Impresos',;
		  'Permite Consultar los resultados de la impresi¢n',;
		  'Permite Consultar el Log Errores presentados en el Sistema',;
		  'Permite Consultar el valor por grupos',;
		  'Permite Consultar y Modificar la Situaci¢n del Cliente'}

/*
       aAyuda := {'Permite Calcular los digitos de Chequeo',;
		  'Permite Consultar el Control de los Recibos Impresos',;
		  'Permite Consultar los resultados de la impresi¢n',;
		  'Permite Consultar el Log Errores presentados en el Sistema',;
		  'Permite Consultar el valor por grupos'}
*/
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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc,.F.)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       Carte_791(aParam1,aParam2,aParam3)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Digito de Chequeo

	  CASE nNroOpc == 2
	       MantenRec(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,cNomSec,nFilInf,nColInf,nFilPal,;
			 cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
			 PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Mantenimiento Control de Recibos

	  CASE nNroOpc == 3
	       Carte_792(aParam1,aParam2,aParam3)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Consultar el archivo de impresi¢n

	  CASE nNroOpc == 4
/*
	       RESTSCREEN(0,0,24,79,cSavPan)
	       MantenErr(lShared,cNomSis,cEmpPal,cNitEmp,cNomEmp,;
			 cNomSec,nFilInf,nColInf,nFilPal,cNomUsr,;
			 cAnoUsr,cPatSis,PathSis+'\'+fErrSys,nModCry)
	      *Mantenimiento del archivo Errores
*/

	  CASE nNroOpc == 5
	       Carte_795(aParam1,aParam2,aParam3)
	       RESTSCREEN(0,0,24,79,cSavPan)
	      *Consultar el valor por grupos

	  CASE nNroOpc == 6
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_301(aParam1,aParam2,aParam3,.T.)
	      *Consulta situaci¢n del cliente

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA