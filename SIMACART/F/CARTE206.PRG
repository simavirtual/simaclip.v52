/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: INCONSISTENCIAS                          MODULO No. 206

**************************************************************************
* NOMBRE DEL PROGRAMA..: CARTE206.PRG                                    *
* TITULO DEL PROGRAMA..: MENU DE INCONSISTENCIAS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 02/2000 JUE A
       Bucaramanga, Colombia        INICIO: 07:15 PM   MAR 02/2000 JUE

REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Visualiza un men£ para las inconsistencias del mes.

2- Ejecuta las diferentes funciones.


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_206(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
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

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus  := {}
       AADD(aMenus,"1<FACTURACION MAS PAGOS>")
       AADD(aMenus,"2<SALDOS ANTERIORES    >")
       AADD(aMenus,"3<ESTADOS DE CUENTA    >")
       AADD(aMenus,"4<DEUDORES             >")

       aAyuda  := {}
       AADD(aAyuda,'Imprime las Inconsistencias en la Facturaci¢n.')
       AADD(aAyuda,'Imprime los Saldos Anteriores para conciliaci¢n')
       AADD(aAyuda,'Simamula los Estados de Cuenta de la Situaci¢n del Cliente')
       AADD(aAyuda,'Imprime la relaci¢n que figuran como deudores')

/*
		  "2<CONFRONTACION DESCUENTOS>",;
		  "3<CONFRONTACION BECAS     >",;
		  "4<CONFRONTACION ABONOS    >",;
		  "5<CARTERA Vs BANCO        >"}

		  'Imprime las Inconsistencias en los Descuentos ',;
		  'Imprime las Inconsistencias en la Becas o Ayudas',;
		  'Imprime las Inconsistencias en los Abonos',;
		  'Imprime las Inconsistencias de la Cartera Vs Banco'}
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

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_261(aParam1,aParam2,aParam3)
	      *Facturaci¢n mas pagos.

	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_262(aParam1,aParam2,aParam3)
	      *Saldos Anteriores

	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_263(aParam1,aParam2,aParam3)
	      *Simulaci¢n de los Estados de Cuenta

	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_264(aParam1,aParam2,aParam3)
	      *Estudiantes Deudores

/*
	  CASE nNroOpc == 2
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_262(aParam1,aParam2,aParam3)
	      *Confrontaci¢n de Descuentos.

	  CASE nNroOpc == 3
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_263(aParam1,aParam2,aParam3)
	      *Confrontaci¢n de Becas.

	  CASE nNroOpc == 4
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_264(aParam1,aParam2,aParam3)
	      *Confrontaci¢n de Abonos

	  CASE nNroOpc == 5
	       RESTSCREEN(0,0,24,79,cSavPan)
	       Carte_265(aParam1,aParam2,aParam3)
	      *Cartera Vs Banco.
*/
	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA