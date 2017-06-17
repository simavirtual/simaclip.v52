/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS POR ARCHIVO      MODULO No. 203

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE203.PRG                                    *
* TITULO DEL PROGRAMA..: PAGOS POR MODEM                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 06/95 MAR A
       Colombia, Bucaramanga        INICIO: 10:25 AM   JUN 06/95 MAR

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza el men£ de los pagos por archivos

2- Ejecuta las diferentes opciones del menu.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_203(aParam1,aParam2,aParam3,cModem)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       cModem                               // Banco de la Gerencia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntUno := ''                  // Path de integraci¢n uno
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro
       LOCAL lAnoAct := .T.                 // A¤o Actual

       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION PARAMETROS GENERALES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

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

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n

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
       PathCarAno(lShared,cPatSis,cAnoUsr,@cIntUno,;
		  @cIntDos,@cIntTre,@cIntCua,nModCry)
     *ÀLectura de paths
*>>>>FIN LECTURA DE PATHS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<MOVIMIENTO DIARIO      >',;
		  '2<MOVIMIENTO FACTURACION >',;
		  '3<EXTRACTO BANCARIO      >',;
		  '4<TIPOS DE TRANSACCIONES >',;
		  '5<CONCEPTOS TRANSACCIONES>',;
		  '6<CUENTAS CONTABILIDAD   >'}

       aAyuda := {'Procesa los Movimientos del d¡a',;
		  'Procesa los Movimientos para la Facturaci¢n del mes',;
		  'Procesa los Movimientos del Extracto Bancario',;
		  'Permite Consultar e Incluir los tipos de Transacciones',;
		  'Permite Consultar e Incluir los Conceptos de las Transacciones',;
		  'Permite Consultar e Incluir las Cuentas de Contabilidad'}
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       MantenTra(aParam1,aParam2,aParam3,;
			 cModem,'DIA')
	      *Mantenimiento de las Transaciones diarios

	  CASE nNroOpc == 2
	       MantenTra(aParam1,aParam2,aParam3,;
			 cModem,NIL)
	      *Mantenimiento de las Transaciones Mensuales

	  CASE nNroOpc == 3
	       MantenExt(aParam1,aParam2,aParam3,;
			 cModem)
	     *Mantenimiento del Extracto

	  CASE nNroOpc == 4

	       aArchvo := {}
	       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
	       AADD(aArchvo,{cPatSis+'\'+FileBan,NIL,'BAN'})

	       MantenTmv(aParam1,aParam2,aParam3,;
			 aArchvo,'1234',0)
	      *Mantenimiento del archivo Tipos de Transaciones

	  CASE nNroOpc == 5

	       aArchvo := {}
	       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
	       AADD(aArchvo,{cPatSis+'\'+FileCmv,NIL,'CMV'})

	       MantenCmv(aParam1,aParam2,aParam3,;
			 aArchvo,'1234',0)
	      *Mantenimiento del archivo Conceptos de Transaciones

	  CASE nNroOpc == 6
	       MantenPuc(aParam1,aParam2,aParam3,cModem)
	      *Mantenimientos del Archivo de Cuentas del Puc

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA
