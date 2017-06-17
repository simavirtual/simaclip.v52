/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : PAGOS
SUBMODULO...: PAGOS POR MODEM

**************************************************************************
* TITULO..: MENU DE PAGOS POR MODEM                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 06/2008 LUN A
       Colombia, Bucaramanga        INICIO: 09:45 PM   OCT 06/2008 LUN

OBJETIVOS:

1- Visualiza el men£ de los pagos por archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_504(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1			      // Parametros Generales
       aP2			      // Parametros Generales
       aP3			      // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION PARAMETROS
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
       LOCAL cLogEmp := xPrm(aP1,'cLogEmp') // Logo de la Empresa
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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Actual
       LOCAL cJornad := xPrm(aP1,'cJornad') // Jornadas habilitadas
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroCol := 0                   // N£mero de Columna
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
     *ÀVariables de menu

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n

       LOCAL GetList := {}                  // Variable del Sistema
       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       aMenus := {}
       AADD(aMenus,'1<MOVIMIENTO DIARIO>')
       AADD(aMenus,'2<MOVIMIENTO FACTURACION>')
       AADD(aMenus,'3<EXTRACTO BANCARIO     >')
       AADD(aMenus,'4<TIPOS DE TRANSACIONES >')
       AADD(aMenus,'5<CONCEPTOS TRANSACIONES>')

       aAyuda := {}
       AADD(aAyuda,'Procesa los Movimientos del d¡a.')
       AADD(aAyuda,'Procesa los Movimientos para la Facturaci¢n del mes.')
       AADD(aAyuda,'Procesa los Movimientos del Estracto Bancario.')
       AADD(aAyuda,'Permite Consultar e Incluir los tipos de Transaciones.')
       AADD(aAyuda,'Permite Consultar e Incluir los Conceptos de las Transaciones.')
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       nNroCol := nColInf
       IF nColInf + nLenOpc + 2 > 78
	  nNroCol := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf,nNroCol,NIL,NIL,nNroOpc,.F.)
	  RESTSCREEN(0,0,24,79,cSavPan)

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       MantenTra(aP1,aP2,aP3,'DIA')
	      *Mantenimiento de las Transaciones diarios

	  CASE nNroOpc == 2
	       MantenTra(aP1,aP2,aP3,NIL)
	      *Mantenimiento de las Transaciones Mensuales

	  CASE nNroOpc == 3
	       MantenExt(aP1,aP2,aP3)
	     *Mantenimiento del Extracto

	  CASE nNroOpc == 4

	       aArchvo := {}
	       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
	       AADD(aArchvo,{cPatSis+'\'+FileBan,NIL,'BAN'})

	       MantenTmv(aP1,aP2,aP3,aArchvo,;
			 xPrm(aP3,'cOpcPrn'),;
			 xPrm(aP3,'nCodPrn'))
	     *ÀTipo de Transaciones

	  CASE nNroOpc == 5

	       aArchvo := {}
	       aArchvo := {}
	       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
	       AADD(aArchvo,{cPatSis+'\'+FileCmv,NIL,'CMV'})

	       MantenCmv(aP1,aP2,aP3,aArchvo,;
			 xPrm(aP3,'cOpcPrn'),;
			 xPrm(aP3,'nCodPrn'))
	    *ÀConceptos Transaciones

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA