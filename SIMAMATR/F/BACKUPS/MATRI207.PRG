/* SIMA - MATRICULA ACADEMICA

MODULO      : EVALUACION
SUBMODULO...: GRABAR OBSERVACIONES

**************************************************************************
* TITULO..: GRABACION DE LAS OBSERVACIONES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 09/2006 MIE A
       Colombia, Bucaramanga        INICIO: 08:30 AM   AGO 09/2006 MIE

OBJETIVOS:

1- Permite grabar, las observaciones del proceso de admisi¢n del aspirante

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matri_207(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-MATR.PRG"      // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse del Archivo

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
       IF  !lParam0101(aParams,;
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+PathSis+'\'+;
			 fSimaCo,'SCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimMtr,'MTR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileAdm+cAnoUsr+ExtFile,'ADM',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileTob,'TOB',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileObs,'OBS',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE MTR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE ADM->(RECCOUNT()) == 0
	    cError('No Existen Inscripciones')

/*
       CASE TOB->(RECCOUNT()) == 0
	    cError('No existen los Tipos de Observaciones')
*/

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',MTR->nPrnCerPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>MANTENIMIENTO DEL ARCHIVO
       SELECT ADM

       cTitInf := '<F2>Observaciones <F5>Buscar <F9>Otros <ESC>Abandonar'

       oBrowse := oDefObsAdm(nFilPal+1,00,22,79,cJorTxt,cTitSup,cTitInf)

       SETKEY(K_F2,{||InfoObs(10,10,cNomEmp,cNomSis,'ADM',oBrowse)})

       SETKEY(K_F5,{||BuscarAdm(lShared,cPatSis,oBrowse)})

       SETKEY(K_F9,{||MenuOtr207(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,;
				 cNitEmp,cNomEmp,nFilInf,nColInf,nFilPal,;
				 cNomUsr,cAnoUsr,cPatSis,PathUno,PathDos,;
				 PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,;
				 oBrowse)})

       ADM->(CtrlBrw(lShared,oBrowse))
       SETKEY(K_F2,NIL)
       SETKEY(K_F5,NIL)
       SETKEY(K_F9,NIL)

       CLOSE ALL
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: MENU DE INFORMES PARA EL BROWSE DE INSCRIPTOS                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 02/2001 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 PM   OCT 02/2001 MAR

OBJETIVOS:

1- Menu de Otros Procesos e informes

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenuOtr207(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,PathUno,;
		    PathDos,PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cIntDos := ''                  // Path de integraci¢n dos
       LOCAL cIntTre := ''                  // Path de integraci¢n tres
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       AADD(aMenus,'1<IMPRIMIR RESULTADOS    >')
       AADD(aMenus,'2<IMPRIMIR OBSERVACION   >')
       AADD(aMenus,'3<ESTADISTICAS ADMISIONES>')
*       AADD(aMenus,'4<ESTADISTICAS MATRICULAS>')

       AADD(aAyuda,'Imprime los resultados de las pruebas de Admisi¢n')
       AADD(aAyuda,'Imprime las observaciones de un estudiante')
       AADD(aAyuda,'Imprime las estad¡sticas del proceso de admisiones')
*       AADD(aAyuda,'Imprime las estad¡sticas del proceso de matr¡culas')

       cSavPan := SAVESCREEN(0,0,24,79)
       nNroOpc := nMenu(aMenus,aAyuda,10,25,NIL,NIL,1,.F.)
       RESTSCREEN(0,0,24,79,cSavPan)

       IF nNroOpc == 0
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>ANALISIS DE OPCION ESCOGIDA
       DO CASE
       CASE nNroOpc == 1
	    Matr207_01(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,cNitEmp,;
		       cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,;
		       cPatSis,PathUno,PathDos,PathTre,PathCua,cMaeAlu,;
		       cMaeAct,cJorTxt,oBrowse)

       CASE nNroOpc == 2
	    ObsMemoEst(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		       oBrowse)

       CASE nNroOpc == 3
	    EstadiAdm(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		      oBrowse)

       CASE nNroOpc == 4
/*
	    EstadiMtr(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		      oBrowse)
*/

       ENDCASE
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: IMPRIMIR RESULTADOS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 15/2006 MAR A
       Colombia, Bucaramanga        INICIO: 05:15 PM   AGO 15/2006 MAR

OBJETIVOS:

1- Imprime el informe con los resultados aprobatorios de las pruebas
   de admisi¢n.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Matr207_01(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,cNitEmp,cNomEmp,;
		    nFilInf,nColInf,nFilPal,cNomUsr,cAnoUsr,cPatSis,PathUno,;
		    PathDos,PathTre,PathCua,cMaeAlu,cMaeAct,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       PathUno			            // Primera Integraci¢n
       PathDos			            // Segunda Integraci¢n
       PathTre			            // Tercera Integraci¢n
       PathCua			            // Cuarta Integraci¢n
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental

       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n

       LOCAL nNroNiv := 0                   // N£mero Nivel
       LOCAL cNivIni := 0                   // Nivel Inicial
       LOCAL cNivFin := 0                   // Nivel Final
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE LOS NIVELES A IMPRIMIR
       cSavPan := SAVESCREEN(0,0,24,79)
       SETCURSOR(1)
       IF !lLeeNivels(10,20,@cNivIni,@cNivFin,NIL,cMaeAlu,.T.)

	  SETCURSOR(0)
	  RESTSCREEN(0,0,24,79,cSavPan)
	  IF !EMPTY(oBrowse)
	     SELECT ADM
	     ADM->(DBGOTOP())
	     oBrowse:GOTOP()
	     oBrowse:FORCESTABLE()
	  ENDIF
	  RETURN NIL

       ENDIF
       RESTSCREEN(0,0,24,79,cSavPan)
       SETCURSOR(0)
       nNroNiv := VAL(cNivIni)
*>>>>FIN LECTURA DE LOS NIVELES A IMPRIMIR

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 1
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<EVALUACION><OBSERVACIONES><F9>IMPRIMIR RESULTADOS'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'RELACION DE PRUEBAS DE ADMISION.'+;
		    'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())

       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
          FilePrn := 'Obs'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,.T.,bInsIso)

	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL INFORME
       DO WHILE nNroNiv <= VAL(cNivFin)

**********FILTRACION DEL ARCHIVO
	    SELECT ADM
	    SET FILTER TO
	    SET FILTER TO VAL(SUBS(ADM->cCodigoGru,1,2)) == nNroNiv
	    ADM->(DBGOTOP())
	    IF ADM->(EOF())
	       cError('PARA '+cNomNiv(nNroNiv)+' NO HAY INSCRITOS')
	       nNroNiv++
	       LOOP
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********IMPRESION DE LA LINEA DE ESTADO
	    SET DEVICE TO SCREEN
	    LineaEstado('IMPRIMIENDO NIVEL: '+STR(nNroNiv,2)+'º'+;
			'HASTA NIVEL: '+cNivFin+;
			'ºPOR FAVOR ESPERE ...',cNomSis)
	    SET DEVICE TO PRINT
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********IMPRESION DEL INFORME
	    PrnObsEst(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		      cOpcSys,nNroIso,cCodIso,aTitIso,cPiePag,aPieIso,;
		      nTotPie,aMezIso,bInsIso,nLenPrn,@nHanXml,nNroNiv,;
		      oBrowse)
**********FIN IMPRESION DEL INFORME

	  SELECT ADM
	  SET FILTER TO

	  EJECT
	  nNroNiv++

       ENDDO
       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       IF !EMPTY(oBrowse)
	  SELECT ADM
	  ADM->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF
       RETURN NIL
*>>>>FIN IMPRESION DEL INFORME

/*************************************************************************
* TITULO..: IMPRESION DE LAS OBSERVACIONES                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 15/2006 MAR A
       Colombia, Bucaramanga        INICIO: 05:15 PM   AGO 15/2006 MAR

OBJETIVOS:

1- Imprime el informe con los resultados aprobatorios de las pruebas
   de admisi¢n.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnObsEst(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,;
		   cOpcSys,nNroIso,cCodIso,aTitIso,cPiePag,aPieIso,;
		   nTotPie,aMezIso,bInsIso,nLenPrn,nHanXml,nNroNiv,;
		   oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida
       cOpcSys                              // Opci¢n del Sistema
       nNroIso                              // N£mero Iso del Informe
       cCodIso                              // C¢digo Iso del Informe
       aTitIso                              // T¡tulo Iso del Informe
       cPiePag                              // Pie de P gina por defecto
       aPieIso      		            // Textos del pie de p gina
       nTotPie                              // Total de Pie de p ginas
       aMezIso                              // Campos a Mesclar
       bInsIso                              // Block de Gestion Documental
       nLenPrn                              // Longitud l¡nea de impresi¢n
       nHanXml                              // @Manejador del Archivo
       nNroNiv                              // N£mero del grado a imprimir
       oBrowse                              // Browse del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contador
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL lHayObs := .F.                 // .T. Hay Observaciones
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTto := ''               // Nombre tipo de prueba
     *ÀVariables de campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       aTitIso[2] := 'GRADO:'+cNomNiv(nNroNiv)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,6)
       AADD(aTitPrn,'CODIGO')

       AADD(aNroCol,6)
       AADD(aTitPrn,'GRADO')

       AADD(aNroCol,42)
       AADD(aTitPrn,'APELLIDOS Y NOMBRES')

       AADD(aNroCol,20)
       AADD(aTitPrn,'VALORACION')

       AADD(aNroCol,40)
       AADD(aTitPrn,'OBSERVACIONES')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPie)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ADM
       ADM->(DBGOTOP())
       DO WHILE .NOT. ADM->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( ADM->(RECNO()) / ADM->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LECTURA DEL NOMBRE DEL ESTUDIANTE
	    cNombreTes = ALLTRIM(ADM->cApelliEst)+' '+;
			 ALLTRIM(ADM->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(42),1,42)
**********FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

**********FILTRACION DEL ARCHIVO
	    lHayObs := .T.
	    SELECT OBS
	    SET FILTER TO OBS->cCodEstObs == ADM->cCodigoEst
	    OBS->(DBGOTOP())
	    
	    IF OBS->(EOF())
	       SET FILTER TO
	       lHayObs := .F.
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********IMPRESION DEL REGISTRO
            aRegPrn := {}
	    AADD(aRegPrn,ADM->cCodigoEst)
	    AADD(aRegPrn,ADM->cCodigoGru)
	    AADD(aRegPrn,cNombreTes)
	    AADD(aRegPrn,IF(ADM->lRetiroAdm,'RETIRADO',;
			 IF(lHayObs,'','SIN VALORACION')))
	    AADD(aRegPrn,'')

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
                    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DE LAS OBSERVACIONES
	    IF lHayObs
	       SELECT OBS
	       OBS->(DBGOTOP())
	       DO WHILE .NOT. OBS->(EOF())

*:::::::::::::::::LOCALITACION DEL TIPO DE PRUEBA
		    cNombreTto := 'Prueba No. '+OBS->cCodigoTob+' '+;
				  'No Existe'
		    IF lLocCodigo('cCodigoTob','TOB',OBS->cCodigoTob)
		       cNombreTto := TOB->cNombreTob
		    ENDIF
*:::::::::::::::::FIN LOCALITACION DEL TIPO DE PRUEBA

*:::::::::::::::::IMPRESION DEL REGISTRO
		    aRegPrn := {}
		    AADD(aRegPrn,'')
		    AADD(aRegPrn,'')
		    AADD(aRegPrn,cNombreTto)
		    DO CASE
		    CASE EMPTY(OBS->cNotaObs)
			 AADD(aRegPrn,'SIN OBSERVACION')

		    CASE 'SI' $ OBS->cNotaObs
			 AADD(aRegPrn,'APROBO')

		    CASE 'NO' $ OBS->cNotaObs
			 AADD(aRegPrn,'NO APROBO')
		    OTHERWISE
			 AADD(aRegPrn,OBS->cNotaObs)
		    ENDCASE

		    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
			    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
*:::::::::::::::::FIN IMPRESION DEL REGISTRO

		  OBS->(DBSKIP())

	       ENDDO
	       SELECT OBS
	       SET FILTER TO
	    ENDIF
**********FIN IMPRESION DE LAS OBSERVACIONES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ADM
	    ADM->(DBSKIP())
	    IF ADM->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO..: IMPRESION DE LAS PRUEBAS DEL ESTUDIANTE                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 16/2006 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   AGO 16/2006 MAR

OBJETIVOS:

1- Imprime el texto de las observaciones de las pruebas del estudiante.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ObsMemoEst(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental

       LOCAL     i,j := 0                   // Contador
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTto := ''               // Nombre tipo de prueba
     *ÀVariables de campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       SELECT OBS
       SET FILTER TO OBS->cCodEstObs == ADM->cCodigoEst
       OBS->(DBGOTOP())

       IF OBS->(EOF())

	  SET FILTER TO
	  cError('NO TIENE OBSERVACIONES GRABADAS')

	  IF !EMPTY(oBrowse)
	     SELECT ADM
	     ADM->(DBGOTOP())
	     oBrowse:GOTOP()
	     oBrowse:FORCESTABLE()
	  ENDIF
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 1
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<EVALUACION><OBSERVACIONES><F9>IMPRIMIR RESULTADOS'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'OBSERVACIONES PRUEBAS DE ADMISION.'+;
		    'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())

       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
          FilePrn := 'Obs'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,.T.,bInsIso)

	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>LECTURA DEL NOMBRE DEL ESTUDIANTE
       cNombreTes = ALLTRIM(ADM->cApelliEst)+' '+;
		    ALLTRIM(ADM->cNombreEst)
       cNombreTes := ALLTRIM(cNombreTes)
*>>>>FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       aTitIso[2] := cNombreTes
       aTitIso[3] := 'CODIGO:'+ADM->cNumeroAdm+' GRADO:'+;
		      cNomNiv(SUBS(ADM->cCodigoGru,1,2))

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,150)
       AADD(aTitPrn,'OBSERVACIONES DE LAS PRUEBAS DE ADMISION')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPie)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT OBS
       OBS->(DBGOTOP())
       DO WHILE .NOT. OBS->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( OBS->(RECNO()) / OBS->(RECCOUNT()) )*100)

            IF STR(nAvance,3) $ '25 50 75100'
               SET DEVICE TO SCREEN
               Termometro(nAvance)
               SET DEVICE TO PRINT
            ENDIF
**********FIN VISUALIZACION DE AVANCE

**********LOCALIZACION DEL TIPO DE PRUEBA
	    cNombreTto := 'PRUEBA No. '+OBS->cCodigoTob+' '+;
			  'NO EXISTE'
	    IF lLocCodigo('cCodigoTob','TOB',OBS->cCodigoTob)
	       cNombreTto := ALLTRIM(TOB->cNombreTob)+':'
	    ENDIF

	    DO CASE
	    CASE 'SI' $ OBS->cNotaObs
		 cNombreTto += 'APROBO'

	    CASE 'NO' $ OBS->cNotaObs
		 cNombreTto += 'NO APROBO'
	    ENDCASE
	    cNombreTto := SUBS(cNombreTto+SPACE(150),1,150)
**********FIN LOCALIZACION DEL TIPO DE PRUEBA

**********IMPRESION DEL REGISTRO
	    aRegPrn := {}
	    AADD(aRegPrn,cNombreTto)

	    lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		    aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********IMPRESION DEL CAMPO MEMO
	    cTxtPrn := OBS->mObservObs
	    PrnMemo(lShared,nOpcPrn,FilePrn,nHanXml,nColCab,aTitPrn,;
		    aNroCol,bPagina,bDerAut,bCabeza,cTxtPrn,150)
**********FIN IMPRESION DEL CAMPO MEMO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT OBS
	    OBS->(DBSKIP())
	    IF OBS->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       IF !EMPTY(oBrowse)
	  SELECT ADM
	  ADM->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF

       RETURN NIL
*>>>>FIN IMPRESION DERECHOS

/*************************************************************************
* TITULO DE LA FUNCION..: DEFINICION OBJETO DE INSCRITOS                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 03/96 MIE A
       Colombia, Bucaramanga        INICIO: 03:40 PM   ENE 03/96 MIE

1- Define el objeto Browse del Inscritos

2- Debe estar en uso el archivo de Admisiones

SINTAXIS:

 oConsul := oDefInsAdm(00,00,24,79,'94')

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefObsAdm(nFilSup,nColSup,nFilInf,nColInf,cJorTxt,cTitSup,cTitInf)

*>>>>PARAMETROS DE LA FUNCION
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cJorTxt                              // Jornada Escogida
       cTitSup                              // T¡tulo Superior del Browse
       cTitInf                              // T¡tulo Inferior del Browse */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oConsul := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oConsul := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       cTitSup := IF(!EMPTY(cTitSup),cTitSup,;
		    '<<  CONSULTA DE INSCRITOS. JORNADA: '+cJorTxt+' >>')

       cTitInf := IF(!EMPTY(cTitInf),cTitInf,;
		     '<F5>Buscar  <F9>Otros <ESC>Abandonar')


       oConsul:ColSep    := '³'
       oConsul:HeadSep   := 'Ä'
       oConsul:Cargo     := {cTitSup,cTitInf}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT ADM
       oColumn	     := TBCOLUMNNEW('CODIGO',;
				   {||ADM->cNumeroAdm})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
				       
       oColumn	     := TBCOLUMNNEW('NIVEL',{||ADM->cCodigoGru})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cCodigoGru'},;
			 {'PICTURE','9999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('APELLIDOS',;
			      {||ADM->cApelliEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cApelliEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
       oConsul:Freeze := 4
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES',;
			      {||ADM->cNombreEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cNombreEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('PADRES EXALUMNOS',;
				    {||ADM->lExAlumAdm})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','lExAlumAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NUMERO DEL;RECIBO DE PAGO',;
				    {||ADM->cRecPagAdm})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cRecPagAdm'},;
			 {'PICTURE','@X'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CODIGO',;
				   {||ADM->cCodigoEst})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('RETIRADO',{||ADM->lRetiroAdm})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','lRetiroAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('FECHA;INSCRIPCION',{||ADM->dFecInsAdm})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','dFecInsAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CONSULTAR;CEDULAS',{||ADM->cPrnNitAdm})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cPrnNitAdm'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA;DEL PADRE',{||ADM->cPadNitEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cPadNitEst'},;
			 {'PICTURE','9999999999999999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA;DEL MADRE',{||ADM->cMadNitEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cMadNitEst'},;
			 {'PICTURE','9999999999999999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('CEDULA DEL;ACUDIENTE',{||ADM->cAcuNitEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cAcuNitEst'},;
			 {'PICTURE','9999999999999999'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('OBSERVACION',;
				    {||IF(!ADM->lRetiroAdm .AND. ;
					  !ADM->lExamenAdm .AND. ;
					  ADM->nDefExaAdm == 0,;
					  'PENDIENTE',SPACE(09))})
       oColumn:Cargo := {{'MODI',.F.}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('APELLIDOS DEL;PADRE',{||ADM->cApePadEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cApePadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn	     := TBCOLUMNNEW('NOMBRES DEL;PADRE',{||ADM->cNomPadEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cNomPadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('APELLIDOS;DE LA MADRE',{||ADM->cApeMadEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cApeMadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('NOMBRES;DE LA MADRE',{||ADM->cNomMadEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cNomMadEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('TELEFONO',{||ADM->cTelefnEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','cTelefnEst'},;
			 {'PICTURE','@!'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('ESTRATO',{||ADM->nEstratEst})
       oColumn:Cargo := {{'MODI',.F.},{'ALIAS','ADM'},{'FIELD','nEstratEst'},;
			 {'PICTURE','99'}}
       oConsul:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oConsul
*>>>>FIN DEFINICION DEL OBJETO BROWSE

/*************************************************************************
* TITULO..: ESTADISTICAS DEL PROCESO DE ADMISIONES                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 25/2007 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   JUL 25/2007 MIE

OBJETIVOS:

1- Imprime las estad¡sticas del proceso de admisiones.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION EstadiAdm(lShared,cNomEmp,cNomSis,cNomUsr,cAnoUsr,cJorTxt,oBrowse)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del sistema
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cJorTxt                              // Jornada Escogida */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL cOpcSys := ''                  // Opci¢n del Sistema
       LOCAL nNroIso := ''                  // N£mero Iso del Informe
       LOCAL cCodIso := ''                  // C¢digo Iso del Informe
       LOCAL aTitIso := ''                  // T¡tulo Iso del Informe
       LOCAL cPiePag := ''                  // Pie de P gina por defecto
       LOCAL aPieIso := {}		    // Textos del pie de p gina
       LOCAL nTotPie := 0                   // Total de Pie de p ginas
       LOCAL aMezIso := {}                  // Campos a Mesclar
       LOCAL bInsIso := NIL                 // Block de Gestion Documental

       LOCAL     i,j := 0                   // Contador
       LOCAL FilePrn := ''                  // Archivo de impresion
       LOCAL nHanXml := 0                   // Manejador del Archivo
       LOCAL nRegPrn := 0                   // Registro de Impresi¢n
       LOCAL cFecPrn := ''                  // @Fecha de Impresi¢n
       LOCAL cHorPrn := ''                  // @Hora de Impresi¢n
       LOCAL cDiaPrn := ''                  // @D¡a de Impresi¢n
       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabPrn := {}                  // Encabezado del informe General
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitPrn := {}                  // T¡tulos para impresi¢n
       LOCAL aRegPrn := {}                  // Registros para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL nOpcPrn := 0                   // Opci¢n de Impresi¢n
     *ÀVariables de informe

       LOCAL aStdAdm := {}
       LOCAL nAvance := 0                   // Avance de registros
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables espec¡ficas

       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTto := ''               // Nombre tipo de prueba
     *ÀVariables de campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>GESTION DOCUMENTAL DEL INFORME
       nLenPrn := PCL('n17Stan')

       nNroIso := 2073
     *ÀN£mero de identificaci¢n del informe

       cOpcSys := '<EVALUACION><OBSERVACIONES><F9>ESTADISTICAS ADMISIONES'
     *ÀOpci¢n del sistema del informe

       aMezIso := {}
       AADD(aMezIso,{'<cAnoUsr>',cAnoUsr})
       AADD(aMezIso,{'<cJorTxt>',cJorTxt})
     *ÀCampos a sustituir

       aTitIso := {}
       AADD(aTitIso,'ESTADISTICAS ADMISIONES '+;
		    'A¥O:<cAnoUsr> JORNADA:<cJorTxt>')  // T¡tulo Uno
       AADD(aTitIso,'')                                 // T¡tulo Dos
       AADD(aTitIso,'')                                 // T¡tulo Tres
     *ÀT¡tulos del Informe por defecto

       cPiePag := ALLTRIM(SCO->cPiePagCon)
       IF !EMPTY(cPiePag)
	  cPiePag := SPACE((nLenPrn-LEN(cTxtPrn))/2)+cPiePag
       ENDIF

       aPieIso := {}
       AADD(aPieIso,'')                 // Pie de p gina Uno
       AADD(aPieIso,'')                 // Pie de p gina Dos
       AADD(aPieIso,IF(EMPTY(cPiePag),'',cPiePag))  // Pie de p gina Tres
     *ÀPie de p ginas por defecto

       bInsIso := {||lModRegIso(lShared,cNomUsr,oBrowse,;
				nNroIso,aTitIso[1],cOpcSys)}
     *ÀInclusi¢n o modificaci¢n de la gesti¢n docuemental
*>>>>FIN GESTION DOCUMENTAL DEL INFORME

*>>>>ACTIVACION DE LA IMPRESORA
       nRegPrn := PRN->(RECNO())

       IF MTR->lPrnArcMtr
	  SET DEVICE TO PRINT
       ELSE
	  FilePrn := 'EstiAdm'
	  nOpcPrn := nPrinter_On(cNomUsr,@FilePrn,MTR->cOpcPrnMtr,.T.,.T.,bInsIso)

	  IF EMPTY(nOpcPrn)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>LECTURA DEL NOMBRE DEL ESTUDIANTE
       cNombreTes = ALLTRIM(ADM->cApelliEst)+' '+;
		    ALLTRIM(ADM->cNombreEst)
       cNombreTes := ALLTRIM(cNombreTes)
*>>>>FIN LECTURA DEL NOMBRE DEL ESTUDIANTE

*>>>>SUSTITUCION DE TEXTO
       DetalleIso(nNroIso,@cCodIso,@aTitIso,@aPieIso)

       IF !EMPTY(cCodIso)
	  cCodIso := 'ISO:'+cCodIso
       ENDIF

       FOR i := 1 TO LEN(aTitIso)
	   FOR j := 1 TO LEN(aMezIso)
	       aTitIso[i] := cReplTxt(aMezIso[j,1],aMezIso[j,2],aTitIso[i])
	   ENDFOR
       ENDFOR

       nTotPie := 0
       FOR i := 1 TO LEN(aPieIso)
	   IF EMPTY(aPieIso[i])
	      LOOP
	   ENDIF
	   nTotPie++
       ENDFOR
*>>>>FIN SUSTITUCION DE TEXTO

*>>>>DEFINICION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.
       nTotReg := 0

       aCabPrn := {cNomEmp,cNomSis+cCodIso,aTitIso[1],aTitIso[2],aTitIso[3]}

       aCabeza := {aCabPrn[1],aCabPrn[2],aCabPrn[3],aCabPrn[4],aCabPrn[5],;
                   nNroPag++,;
                   cTotPagina(nTotReg),lTamAnc}

       cCodIni := PCL({'DraftOn','Elite','CondenOn'})
       cCodFin := PCL({'NegraOf','DobGolOf'})
*>>>>FIN DEFINICION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {}
       aTitPrn := {}

       AADD(aNroCol,10)
       AADD(aTitPrn,'NIVELES')

       AADD(aNroCol,10)
       AADD(aTitPrn,'INSCRITOS')

       AADD(aNroCol,08)
       AADD(aTitPrn,'ANULADOS')

       AADD(aNroCol,08)
       AADD(aTitPrn,'TOTALES')

       AADD(aNroCol,08)
       AADD(aTitPrn,'HOMBRES')

       AADD(aNroCol,08)
       AADD(aTitPrn,'MUJERES')

       AADD(aNroCol,10)
       AADD(aTitPrn,'NO EXAMEN')

       AADD(aNroCol,10)
       AADD(aTitPrn,'SI EXAMEN')

       AADD(aNroCol,08)
       AADD(aTitPrn,'NO CUPO')

       AADD(aNroCol,08)
       AADD(aTitPrn,'SI CUPO')

       AADD(aNroCol,16)
       AADD(aTitPrn,'NO MATRICULADOS')

       AADD(aNroCol,12)
       AADD(aTitPrn,'MATRICULADOS')

       AADD(aNroCol,08)
       AADD(aTitPrn,'HOMBRES')

       AADD(aNroCol,08)
       AADD(aTitPrn,'MUJERES')

       cCabCol := cRegPrint(aTitPrn,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       lCentra := .F.
       nColCab := 0
       IF lCentra
          nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nTotPie)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
                               nColCab,cCodFin,aCabSec,;
			       @cFecPrn,@cHorPrn,@cDiaPrn)}

       bDerAut := {||PiePagPrn(aPieIso,nLenPrn)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>IMPRESION DEL ENCABEZADO
       SendCodes(PCL('Reset'))

       EVAL(bCabeza)
      *Impresi¢n del Encabezado

       AADD(aCabPrn,cFecPrn)
       AADD(aCabPrn,cHorPrn)
       AADD(aCabPrn,cDiaPrn)

       nHanXml := CreaFrmPrn(lShared,FilePrn,aNroCol,nOpcPrn,aCabPrn,aTitPrn)
*>>>>FIN IMPRESION DEL ENCABEZADO

*>>>>RECORRIDO DE LOS REGISTROS
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT ADM
       ADM->(DBGOTOP())
       DO WHILE .NOT. ADM->(EOF())

**********LOCALIZACION DEL NIVEL
	    IF EMPTY(aStdAdm)
	       AADD(aStdAdm,{ADM->cCodigoGru,;  // 1. Niveles
				  0,;           // 2. Inscriptos
				  0,;           // 3. Anulados
				  0,;           // 4. Totales
				  0,;           // 5. Hombres
				  0,;           // 6. Mujeres
				  0,;           // 7. No Examen
				  0,;           // 8. Si Examen
				  0,;           // 9. No Cupo
				  0,;           // 10.Si Cupo
				  0,;           // 11.No Matriculados
				  0,;           // 12.Matriculados
				  0,;           // 13.Hombres
				  0})           // 14.Mujeres
	       i := LEN(aStdAdm)
	    ELSE
	       i := ASCAN(aStdAdm,{|aArr|aArr[1] == ADM->cCodigoGru})
	       IF i == 0
		  AADD(aStdAdm,{ADM->cCodigoGru,;  // 1. Niveles
				     0,;           // 2. Inscriptos
				     0,;           // 3. Anulados
				     0,;           // 4. Totales
				     0,;           // 5. Hombres
				     0,;           // 6. Mujeres
				     0,;           // 7. No Examen
				     0,;           // 8. Si Examen
				     0,;           // 9. No Cupo
				     0,;           // 10.Si Cupo
				     0,;           // 11.No Matriculados
				     0,;           // 12.Matriculados
				     0,;           // 13.Hombres
				     0})           // 14.Mujeres
		   i := LEN(aStdAdm)
	       ENDIF
	    ENDIF
**********FIN LOCALIZACION DEL NIVEL

**********ESTADISTICA DE LAS ADMISIONES
	    aStdAdm[i,2]++	                       // 2. Inscriptos
	    IF ADM->lRetiroAdm
	       aStdAdm[i,3]++	                       // 3. Anulados
	    ENDIF
	    aStdAdm[i,4] := aStdAdm[i,2]-aStdAdm[i,3]  // 4. Totales

	    IF !ADM->lRetiroAdm
	       IF ADM->lSexFemEst
		  aStdAdm[i,6]++                       // 6. Mujeres
	       ELSE
		  aStdAdm[i,5]++	               // 5. Hombres
	       ENDIF
	    ENDIF

	    IF !ADM->lRetiroAdm
	       IF !lLocCodigo('OBS->cCodEstObs','OBS',ADM->cCodigoEst)
		  aStdAdm[i,7]++                       // 7. No Examen
	       ELSE
		  aStdAdm[i,8]++                       // 8. Si Examen
	       ENDIF
	    ENDIF

	    IF !ADM->lRetiroAdm
	       IF ADM->lSiCupoEst
		  aStdAdm[i,10]++                          // 10. Si Cupo
	       ELSE
		  aStdAdm[i,9]++                           // 9. No Cupo
	       ENDIF
	    ENDIF

	    IF !ADM->lRetiroAdm
	       IF ADM->lSiMatrEst
		 aStdAdm[i,12]++                        // 12.Matriculados
	       ELSE
		 aStdAdm[i,11]++                        // 11.No Matriculados
	       ENDIF
	    ENDIF

	    IF ADM->lSiMatrEst
	       IF ADM->lSexFemEst
		  aStdAdm[i,14]++                        // 14.Mujeres
	       ELSE
		  aStdAdm[i,13]++                        // 13.Hombres
	       ENDIF
	    ENDIF
**********FIN ESTADISTICA DE LAS ADMISIONES

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT ADM
	    ADM->(DBSKIP())
	    IF ADM->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
*>>>>FIN RECORRIDO DE LOS REGISTROS

*>>>>IMPRESION DE LOS REGISTROS
       aStdAdm := ASORT(aStdAdm,,,{|x,y|x[1] < y[1]})
       FOR i := 1 TO LEN(aStdAdm)

	   aRegPrn := {}
	   AADD(aRegPrn,cNomNiv(SUBS(aStdAdm[i,1],1,2)))
	   FOR j := 2 TO LEN(aStdAdm[i])
	       AADD(aRegPrn,STR(aStdAdm[i,j],4,0))
	   ENDFOR

	   lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
		   aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
       ENDFOR
*>>>>FIN IMPRESION DE LOS REGISTROS

*>>>>IMPRESION DE LOS TOTALES
       aRegPrn := {}
       AADD(aRegPrn,SPACE(01))
       FOR j := 2 TO LEN(aStdAdm[1])
	   AADD(aRegPrn,REPL('=',4))
       ENDFOR
       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
     *ÀLinea separadora

       aRegPrn := {}
       AADD(aRegPrn,SPACE(01))
       FOR j := 2 TO LEN(aStdAdm[1])
	   AADD(aRegPrn,STR(nSuma(aStdAdm,j),4,0))
       ENDFOR
       lPrnOpc(lShared,nOpcPrn,FilePrn,nHanXml,01,nColCab,;
	       aTitPrn,aRegPrn,aNroCol,bPagina,bDerAut,bCabeza)
     *ÀTotales
*>>>>FIN IMPRESION DE LOS TOTALES

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       EJECT

       SET DEVICE TO SCREEN
       RESTSCREEN(0,0,24,79,cSavPan)

       VerPrn(nOpcPrn,FilePrn,nHanXml)
       PRN->(DBGOTO(nRegPrn))

       IF !EMPTY(oBrowse)
	  SELECT ADM
	  ADM->(DBGOTOP())
	  oBrowse:GOTOP()
	  oBrowse:FORCESTABLE()
       ENDIF

       RETURN NIL
*>>>>FIN IMPRESION DERECHOS