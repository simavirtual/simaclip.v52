/*SISTEMA DE CARTERA RESPALDO DE LA CONTABILIDAD ACADEMICA

MODULO      : OTROS
SUBMODULO...: CONSULTA DE NOVEDADES                    MODULO No. 607

**************************************************************************
* TITULO..: CONSULTA DE NOVEDADES                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUL 04/2002 JUE A
       Bucaramanga, Colombia	    INICIO: 09:30 PM   JUL 04/2002 JUE

OBJETIVOS:

1- Permite consultar las novedades de Rutas y Cafeteria

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Carte_634(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DESCRIPCION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CART.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL PathUno := ''                  // Path de integraci¢n Uno
       LOCAL cIntUno := ''                  // Path de integraci¢n Uno
       LOCAL PathDos := ''                  // Path de integraci¢n Dos
       LOCAL cIntDos := ''                  // Path de integraci¢n Dos
       LOCAL PathTre := ''                  // Path de integraci¢n Tres
       LOCAL cIntTre := ''                  // Path de integraci¢n Tres
       LOCAL PathCua := ''                  // Path de Integraci¢n Cuatro
       LOCAL cIntCua := ''                  // Path de integraci¢n cuatro

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nTipPer := 0                   // Tipo de Personal
       LOCAL nNroOpc := 1                   // Numero de la opcion

       LOCAL       i := 0                   // Contador
       LOCAL cNalias := ''                  // Nombrel del Alias
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL aCamLoc := {}                  // Campos a Localizar
       LOCAL cTitCam := ''                  // T¡tulo del Campo
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse del Browse

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DESCRIPCION DE VARIABLES

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
       aMenus := {}
       aAyuda  := {}
       AADD(aMenus,'1<ESTUDIANTES>')
       AADD(aMenus,'2<PROFESORES >')
       AADD(aMenus,'3<PERSONAL   >')

       AADD(aAyuda,'Consulta las Novedades de los Estudiantes')
       AADD(aAyuda,'Consulta las Novedades de los Profesores')
       AADD(aAyuda,'Consulta las Novedades del Personal Actual')

       cSavPan := SAVESCREEN(0,0,24,79)
       nTipPer := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,1,.F.)

       RESTSCREEN(0,0,24,79,cSavPan)
       IF nTipPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>LECTURA DE PATHS
       PathCarAno(lShared,cPatSis,cAnoUsr,@PathUno,;
		  @PathDos,@PathTre,@PathCua,nModCry,.F.)
       cIntUno := PathUno+'\'+cPatSis
       cIntTre := PathTre
       IF nTipPer == 1
	  cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       ENDIF
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathTre+'\'+PathSis+'\'+;
			 fPerCaF,'PER',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseMae(lShared,cIntUno,cMaeAct,cAnoSis) .OR.;
	  !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       SELECT &cMaeAct
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTE ESTUDIANTES')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE PER->(RECCOUNT()) == 0
	    cError('EL PERSONAL ACTUAL NO HAN SIDO GRABADO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINCION DEL BROWSE
       DO CASE

       CASE nTipPer == 1

************DEFINICION DEL BROWSE DE LOS ESTUDIANTES
	      cNalias := cMaeAct
	      SELECT &cNalias
	      cTitSup := '<< CONSULTA DE ESTUDIANTE DE '+cMaeAct+;
			 ' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
	    *ÀT¡tulo Superior

	      AADD(aCampos,{{"CODIGO","cCodigoEst"},{NIL}})
	      AADD(aCampos,{{"GRUPO","cCodigoGru"},{NIL}})
	      AADD(aCampos,{{"APELLIDOS;DEL ESTUDIANTE","cApelliEst"},{NIL}})
	      AADD(aCampos,{{"NOMBRES;DEL ESTUDIANTE","cNombreEst"},{NIL}})
	      AADD(aCampos,{{"RETIRADO","lRetiroEst"},{NIL}})
	      AADD(aCampos,{{"F.RETIRO","dFecRetEst"},{NIL}})
	      AADD(aCampos,{{"CONCEPTOS","cConcepEst"},{NIL}})
	      AADD(aCampos,{{"RUTAS","cCodigoRut"},{NIL}})
	      FOR i := 1 TO 12
		  cTitCam := 'INGRESOS A LA CAFETERIA MES '+cMes(i,3)+;
		  ';1234567890123456789012345678901'
		  AADD(aCampos,{{cTitCam,'cRes'+cMes(i,3)+'Est'},{NIL}})
	      ENDFOR
	    *ÀDefinici¢n de Campos

	      cTitInf := '<F5>Buscar<ESC>Abandona'

	      oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
	    *Creaci¢n del Browse

	      SETKEY(K_F5,{||BuscarAlu(lShared,oBrowse,cMaeAct,cAnoSis,cIntUno)})
************FIN DEFINICION DEL BROWSE DE LOS ESTUDIANTES

       CASE nTipPer == 2

************DEFINICION DEL BROWSE DE LOS PROFESORES
	      cNalias := 'PRO'
	      SELECT &cNalias
	      cTitSup := '<< CONSULTA DE PROFESORES'+;
			' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
	    *ÀT¡tulo Superior del Browse

	      AADD(aCampos,{{"CODIGO","cCodigoPro"},{NIL}})
	      AADD(aCampos,{{"APELLIDOS","cApelliPro"},{NIL}})
	      AADD(aCampos,{{"NOMBRES","cNombrePro"},{NIL}})
	      AADD(aCampos,{{"RETIRADO","lRetiroPro"},{NIL}})
	      AADD(aCampos,{{"F.RETIRO","dFecRetPro"},{NIL}})
	      AADD(aCampos,{{"RESTAURANTE","cSerHabPro"},{NIL}})
	      AADD(aCampos,{{"FECHA INICIAL","dResIniPro"},{NIL}})
	      AADD(aCampos,{{"FECHA FINAL","dResFinPro"},{NIL}})
	      FOR i :=1 TO 12
		  cTitCam := 'INGRESOS A LA CAFETERIA MES '+cMes(i,3)+';'+;
			     '1234567890123456789012345678901'
		  AADD(aCampos,{{cTitCam,'cRes'+cMes(i,3)+'Pro'},{NIL}})
		*ÀDefinici¢n de Campos
	      ENDFOR
	    *ÀCampos del Browse

	      cTitInf := '<F5>Buscar <ESC>Abandona'
	    *ÀT¡tulo Inferior del Browse

	      oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
	     *Creaci¢n del Browse

	      AADD(aCamLoc,{'1<POR CODIGO  >','cCodigoPro','ENTRE EL CODIGO:'})
	      SETKEY(K_F5,{||LocCampos(oBrowse,cNalias,aCamLoc)})
************FIN DEFINICION DEL BROWSE DE LOS PROFESORES

       CASE nTipPer == 3

************DEFINICION DEL BROWSE DEL PERSONAL ACTUAL
	      cNalias := 'PER'
	      SELECT &cNalias
	      cTitSup := '<< CONSULTA DEL PERSONAL ACTUAL'+;
			' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
	    *ÀT¡tulo Superior del Browse

	      AADD(aCampos,{{"CODIGO","cCodigoPer"},{NIL}})
	      AADD(aCampos,{{"APELLIDOS","cApelliPer"},{NIL}})
	      AADD(aCampos,{{"NOMBRES","cNombrePer"},{NIL}})
	      AADD(aCampos,{{"RETIRADO","lRetiroPer"},{NIL}})
	      AADD(aCampos,{{"F.RETIRO","dFecRetPer"},{NIL}})
	      AADD(aCampos,{{"RESTAURANTE","cSerHabPer"},{NIL}})
	      AADD(aCampos,{{"FECHA INICIAL","dResIniPer"},{NIL}})
	      AADD(aCampos,{{"FECHA FINAL","dResFinPer"},{NIL}})
	      FOR i :=1 TO 12
		  cTitCam := 'INGRESOS A LA CAFETERIA MES '+cMes(i,3)+';'+;
			     '1234567890123456789012345678901'
		  AADD(aCampos,{{cTitCam,'cRes'+cMes(i,3)+'Per'},{NIL}})
		*ÀDefinici¢n de Campos
	      ENDFOR
	    *ÀCampos del Browse

	      cTitInf := '<F5>Buscar <ESC>Abandona'
	    *ÀT¡tulo Inferior del Browse

	      oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
	     *Creaci¢n del Browse

	      AADD(aCamLoc,{'1<POR CODIGO  >','cCodigoPer','ENTRE EL CODIGO:'})
	      SETKEY(K_F5,{||LocCampos(oBrowse,cNalias,aCamLoc)})
************FIN DEFINICION DEL BROWSE DEL PERSONAL ACTUAL

       ENDCASE
*>>>>FIN DEFINCION DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       IF nTipPer == 1
	  SELECT &cMaeAct
	  DO CASE
	  CASE cMaeAct == 'JAR'
	       JAR->(CtrlBrw(lSiRed,oBrowse))

	  CASE cMaeAct == 'PRI'
	       PRI->(CtrlBrw(lSiRed,oBrowse))

	  CASE cMaeAct == 'BTO'
	       BTO->(CtrlBrw(lSiRed,oBrowse))

	  ENDCASE

       ELSE
	  SELECT &cNalias
	  CtrlBrw(lShared,oBrowse)
	 *Browse del Archivo
       ENDIF
       SETKEY(K_F5,NIL)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DEL ARCHIVO