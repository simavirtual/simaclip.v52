/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: INFORMES FACTURACION

**************************************************************************
* TITULO..: INFORMES FACTURACION                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 02/2000 JUE A
       Bucaramanga, Colombia        INICIO: 07:15 PM   MAR 02/2000 JUE

OBJETIVOS:

1- Visualiza un men£ para los informes de la facturaci¢n.

2- Ejecuta las diferentes funciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_205(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL lIntUno := .T.                 // Primera Integraci¢n
       LOCAL lIntDos := .T.                 // Segunda Integraci¢n
       LOCAL lIntTre := .F.                 // Tercera Integraci¢n
       LOCAL lIntCua := .F.                 // Cuarta Integraci¢n

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
       LOCAL lForPag := .F.                 // Habilitar Forma de Pago.
       LOCAL nMtdFac := 0                   // M‚todo de facturaci¢n.

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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		   fCarAno+cAnoUsr+ExtFile,'CAA',NIL,lShared,nModCry)
	  cError('ABRIENDO ARCHIVOS')
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL A¥O')
       OTHERWISE
	    lHayErr :=.F.       
       ENDCASE
       IF lHayErr
	  CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
	  CloseAll()
	  RETURN NIL
       ENDIF
       lForPag := CAA->lForPagCaA
       nMtdFac := CAA->nMtdFacCaA
       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       AADD(aMenus,"1<FACTURACION MES          >")
       AADD(aMenus,"2<ALUMNOS PAGOS ANTICIPADOS>")
       AADD(aMenus,"3<PAGOS DEL MES            >")
       AADD(aMenus,"4<PAGOS POR GRUPOS         >")
       AADD(aMenus,"5<CONTROL TOTAL ESTUDIANTES>")
       AADD(aMenus,"6<ATRASOS DISCRIMINADOS    >")
       AADD(aMenus,"7<FACTURACION TOTAL        >")
       AADD(aMenus,"8<FACTURACION POR FAMILIA  >")


       AADD(aAyuda,'Imprime el total de la facturaci¢n del Mes.')
       AADD(aAyuda,'Imprime los Estudiantes que realizaron pagos anticipados para el mes.')
       AADD(aAyuda,'Permite realizar el control sobre el total de Estudiantes.')
       AADD(aAyuda,'Imprime los Estudiantes a los cuales no se le genero recibo.')
       AADD(aAyuda,'Imprime los Estudiantes Retirados.')
       AADD(aAyuda,'Imprime los pagos del mes.')
       AADD(aAyuda,'Imprime el total de pagos por grupos.')
       AADD(aAyuda,'Imprime los pagos de los atrasos descriminados por conceptos')
       AADD(aAyuda,'Imprime el total de la facturaci¢n acumulada por estudiante')
       AADD(aAyuda,'Imprime el total de la facturaci¢n acumulada por familia')

       DO CASE
       CASE nMtdFac == 1
	    AADD(aMenus,"9<PAGOS POR FORMA DE PAGO  >")
	    AADD(aAyuda,'Imprime los pagos del mes por formas de pago')
       OTHERWISE
	    IF lForPag
	       AADD(aMenus,"9<PAGOS DISCRIMINADOS      >")
	       AADD(aAyuda,"Imprime los pagos descriminados")
	    ENDIF
       ENDCASE
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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-3,nColInf+2,NIL,NIL,nNroOpc,.F.)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       Carte_251(aParam1,aParam2,aParam3)
	      *Facturaci¢n del Mes.

	  CASE nNroOpc == 2
	       Carte_252(aParam1,aParam2,aParam3)
	      *Alumnos pagos anticipados.

	  CASE nNroOpc == 3
	       Carte_253(aParam1,aParam2,aParam3)
	      *Pagos del Mes.

	  CASE nNroOpc == 4
	       Carte_254(aParam1,aParam2,aParam3)
	      *Pagos por Grupos

	  CASE nNroOpc == 5
	       Carte_255(aParam1,aParam2,aParam3)
	      *Control total de Estudiantes

	  CASE nNroOpc == 6
	       Carte_256(aParam1,aParam2,aParam3)
	      *Pagos de atrasos

	  CASE nNroOpc == 7
	       Carte_257(aParam1,aParam2,aParam3)
	      *Facturaci¢n total

	  CASE nNroOpc == 8
	       Carte_258(aParam1,aParam2,aParam3)
	      *Facturaci¢n total por familia

	  CASE nNroOpc == 9

		DO CASE
		CASE nMtdFac == 1
		     Cart1_259(aParam1,aParam2,aParam3)
		    *Pagos por forma de pago

		OTHERWISE
		     IF lForPag
			Carte_259(aParam1,aParam2,aParam3)
		       *Pagos descriminados
		     ENDIF
		ENDCASE



	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseDbf('CAA',cPatSis+'\'+fCarAno+cAnoUsr+ExtFile,nModCry)
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

