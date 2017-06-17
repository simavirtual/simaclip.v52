/*************************************************************************
* TITULO..: MENU DE OTROS PARA EL ARCHIVO                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ago 25/2008 DIA A
       Colombia, Bucaramanga        INICIO:  09:14 AM  ago 25/2008 DIA

OBJETIVOS:

1- Menu de Otros para el archivo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtrCla(aP1,aP2,aP3,;
		    aArchvo,cOpcPrn,nCodPrn,lModReg,;
		    lDelReg,lInsReg,lHaySql,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       aArchvo                              // Archivo en Uso
       cOpcPrn                              // Opciones de Impresi¢n
       nCodPrn                              // C¢digo de Impresi¢n
       lModReg                              // .T. Modificar el Registro
       lDelReg                              // .T. Borrar Registros
       lInsReg                              // .T. Insertar Registro
       lHaySql                              // .T. Exportar a Sql
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

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

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS GENERALES

*>>>>DECLARACION Y EJECUCION DEL MENU
       aMenus := {}
       AADD(aMenus,'1<CLASE DE INDICADORES>')
       AADD(aMenus,'2<TITULO DE LAS CLASES>')
       AADD(aAyuda,'Permite Definir el t¡tulo que separa las Clases en el Boletin')

       aAyuda := {}
       AADD(aAyuda,'Imprime los Detalles del Archivo')
       AADD(aAyuda,'Permite Definir el t¡tulo que separa las Clases en el Boletin')


       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,'MENU OTROS',NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)
       IF nNroOpc == 0
          RETURN NIL
       ENDIF
*>>>>FIN DECLARACION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    SCO_76500(aP1,aP2,aP3,;
		      aArchvo,cOpcPrn,nCodPrn,lModReg,;
		      lDelReg,lInsReg,lHaySql,oBrowse)
	   *Impresi¢n de los campos del Archivo

       CASE nNroOpc == 2
	    TituloCla(lShared,oBrowse)
	   *T¡tulo para el Bolet¡n

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: CODIGO DE DESCRIPCION DE LA CLASE DE INDICADOR               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 19/97 LUN A
       Colombia, Bucaramanga        INICIO: 09:14 AM   MAY 19/97 LUN

OBJETIVOS:

1- Retorna el Codigo de Descripci¢n de la clase de indicador


SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cClaInd(cClaInd,cCodCla)

*>>>>PARAMETROS DE LA FUNCION
/*     cClaInd                              // Clase de Indicador
       cCodCla				    // C¢digo de la Clase */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cCodigo := ''                  // C¢digo Descriptivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL CODIGO DESCRIPTIVO
       IF EMPTY(cClaInd)
	  cCodigo := SPACE(01)
       ELSE
	  IF ISDIGIT(cCodCla)
	     cCodigo := SUBS(cClaInd,VAL(cCodCla),1)
	  ELSE
	     cCodigo := cCodCla
	  ENDIF
       ENDIF
       RETURN SPACE(01)+cCodigo
*>>>>FIN LECTURA DEL CODIGO DESCRIPTIVO

/*************************************************************************
* TITULO..: TITULO DE LAS CLASES                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   AGO 20/2002 MAR

OBJETIVOS:

1- Lee el caracter separador y el t¡tulo de la Clase que va a salir en
   el bolet¡n

2- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION TituloCla(lShared,oBrowse)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // Archivos Compartidos
       oBrowse			            // Browse del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 0                   // Columna de lectura
       LOCAL cChrSep := ''                  // Caracter Separador
       LOCAL cTitulo := ''                  // T¡tulo de la Clase
       LOCAL nChrSep := 0                   // N£mero de Caracteres de Separaci¢n
       LOCAL nLinSep := 0                   // L¡neas Separadoras
       LOCAL nSepLef := 0                   // Separadores a la Izquierda
       LOCAL nSepRig := 0                   // Separadores a la Derecha
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNomBolTcl := ''               // T¡tulo para el Boletin
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CAPTURA DEL TITULO DE LA CLASE
       SET CURSOR ON
       cChrSep := '-'
       cNomBolTcl := cSpaces('CLA','cNomBolCla')
       TitBuscar(64,@nNroFil,@nNroCol,'INGRESE EL CARACTER SEPARADOR Y '+;
				      'EL TITULO PARA EL BOLETIN:')
       @ nNroFil,nNroCol   GET cChrSep    PICT 'X'
       @ nNroFil,nNroCol+2 GET cNomBolTcl PICT '@S63X'
       READ
*>>>>FIN CAPTURA DEL TITULO DE LA CLASE

*>>>>VALIDACION DEL TITULO DE LA CLASE
       IF !EMPTY(cNomBolTcl)
	  nLinSep := (108 - LEN(ALLTRIM(cNomBolTcl)))
	  IF lPar(nLinSep)
	     nSepLef := nLinSep/2
	     nSepRig := nSepLef
	  ELSE
	     nSepLef := (nLinSep-1)/2
	     nSepRig := nSepLef+1
	  ENDIF
       ENDIF
*>>>>FIN VALIDACION DEL TITULO DE LA CLASE

*>>>>GRABACION DEL TITULO DE LA CLASE
       IF !EMPTY(cNomBolTcl)
	  IF CLA->(lRegLock(lShared,.F.))
	     REPL CLA->cNomBolCla WITH REPL(cChrSep,nSepLef)+;
				       ALLTRIM(cNomBolTcl)+;
				       REPL(cChrSep,nSepRig)

	     IF EMPTY(CLA->cChrIniCla) .AND. EMPTY(CLA->cChrFinCla)
		REPL CLA->cChrIniCla WITH "CHR(27)+'E'"
		REPL CLA->cChrFinCla WITH "CHR(27)+'F'"
	     ENDIF
	     CLA->(DBCOMMIT())
	  ELSE
	     cError('NO SE GRABA EL REGISTRO INICIAL DE LA TABLA')
	  ENDIF
	  IF lShared
	     CLA->(DBUNLOCK())
	  ENDIF
       ELSE
	  cError('NO SE GRABA EL REGISTRO POR FALTA DE INFORMACION')
       ENDIF
       oBrowse:GOTOP()
       oBrowse:FORCESTABLE()
       RETURN NIL
*>>>>FIN GRABACION DEL TITULO DE LA CLASE

/*************************************************************************
* TITULO..: SUBDIVISION DE LA CLASE DE INDICADORES                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 27/2008 LUN A
       Colombia, Bucaramanga        INICIO:  03:30 AM  ENE 27/2008 LUN

OBJETIVOS:

1- Determina si hay clase de indicadores configurados para subdividir

2- Retorna el mayor nivel del clase de indicador clasificado.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nHayNivCla()

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroReg := 0                   // N£mero del registro

       LOCAL nNivClaTcl := 0                // N£mero del SubNivel del Indicador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       nNroReg := CLA->(RECNO())
       CLA->(DBGOTOP())
       DO WHILE .NOT. CLA->(EOF())
	  IF CLA->nNivClaCla > nNivClaTcl
	     nNivClaTcl := CLA->nNivClaCla
	  ENDIF
	  CLA->(DBSKIP())
       ENDDO
       CLA->(DBGOTO(nNroReg))
       RETURN nNivClaTcl
*>>>>FIN ANALISIS DE DECISION

/*************************************************************************
* TITULO..: VALIDAR EL PORCENTAJE DE APROBACION                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 04/2009 MIE A
       Colombia, Bucaramanga        INICIO:  09:30 AM  NOV 04/2009 MIE

OBJETIVOS:

1- Valida si han definido los porcentajes de aprobacion de la clase de
   indicadores.

2- Retorna .T. si no hay problemas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lPorAprCla()

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL nNroReg := 0                   // N£mero del registro

*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       nNroReg := CLA->(RECNO())
       CLA->(DBGOTOP())
       DO WHILE .NOT. CLA->(EOF())
	  IF CLA->nPorAprCla > 0
	     lHayErr := .F.
	     EXIT
	  ENDIF
	  CLA->(DBSKIP())
       ENDDO
       CLA->(DBGOTO(nNroReg))
       RETURN !lHayErr
*>>>>FIN ANALISIS DE DECISION