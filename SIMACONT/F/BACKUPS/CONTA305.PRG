/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : INFORMES
SUBMODULO...: CARGAS ACADEMICAS

**************************************************************************
* TITULO..: MENU CARGAS ACADEMICAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 18/2002 VIE A
       Bucaramanga, Colombia	    INICIO: 02:45 PM   OCT 18/2002 VIE

OBJETIVOS:

1- Visualiza el men£ de los informes por Profesor.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_305(aParam1,aParam2,aParam3)

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
       AADD(aMenus,'1<GENERAR CARGAS      >')
       AADD(aMenus,'2<GENERAR AULA VIRTUAL>')

       AADD(aAyuda,'Permite Generar la Asignaci¢n Acad‚mica del Profesor')
       AADD(aAyuda,'Permite Generar el Aula Virtual para Manhantanr.')

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
	    Conta_351(aParam1,aParam2,aParam3)
	   *Generar Carga

       CASE nNroOpc == 2
	    Conta_352(aParam1,aParam2,aParam3)
	   *Generar Aula Virtual

       ENDCASE
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

/*************************************************************************
* TITULO..: CREACION DE LAS CARGAS ACADEMICAS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:25 AM   MAR 12/96 MAR


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite crear el archivo con las cargas acad‚micas de los profesores

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_351(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL cNroNiv := ''                  // N£mero del Nivel
       LOCAL cNomPla := ''                  // Nombre del Plan

       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL lMatVarTma := .F.              // .T. Materia Variable
       LOCAL cCodigoTpr := ''               // C¢digo del profesor
       LOCAL cCodigoTca := ''               // C¢digo de la carga
       LOCAL nTipCarTca := 0                // Tipo de Carga
       FIELD cCodigoPro                     // C¢digo del profesor
       FIELD cCodigoCar                     // C¢digo de la carga
*>>>>FIN DECLARACION DE CONSTANTES

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

*>>>>CREACION DEL ARCHIVO DE CARGAS
       Termometro(0,"CREANDO EL ARCHIVO DE CARGAS")
       Termometro(100)
       CreaDbfCar(cPatSis+'\'+cMaeAct,FileCar+cMaeAct+ExtFile)
*>>>>FIN CREACION DEL ARCHIVO DE CARGAS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat+ExtFile,'MAT',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuN,'SUN',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileSuG,'SUG',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CREACION DE LAS CARGAS
       SELECT GRU
       GO TOP
       DO WHILE .NOT. GRU->(EOF())

**********LOCALIZACION DEL NIVEL
	   cNroNiv := SUBS(GRU->cCodigoGru,1,2)
	   IF !lLocCodigo('cCodigoNiv','NIV',cNroNiv)
	      cError('EL NIVEL '+cNroNiv+' NO EXISTE')
	      CLOSE ALL
	      RETURN NIL
	   ENDIF
**********FIN LOCALIZACION DEL NIVEL

**********SELECCION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO
	    IF NIV->lPlaGruNiv
	       FilePla := 'PL'+GRU->cCodigoGru+cAnoSis+ExtFile
	       cNomPla := GRU->cCodigoGru
	    ELSE
	       FilePla := 'PLAN'+cNroNiv+cAnoSis+ExtFile
	       cNomPla := cNomNiv(cNroNiv)
	    ENDIF
**********FIN SELECCION DEL NOMBRE DEL ARCHIVO DEL PLAN ACADEMICO

**********SELECION DE AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   FilePla,'PLA',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DEL PLAN ACADEMICO DE '+cNomPla)

	       CloseDbf('PLA')
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
*********FIN SELECION DE AREAS DE TRABAJO

*********VALIDACION DE CONTENIDOS DE ARCHIVOS
	   IF PLA->(RECCOUNT()) == 0

	      cError('NO EXISTE PLAN ACADEMICO DE '+cNomPla)

	      CloseDbf('PLA')
	      GRU->(DBSKIP())
	      LOOP
	   ENDIF
*********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*********GRABACION CARGA ACADEMICA DEL GRUPO
	   SELECT PLA
	   GO TOP
	   DO WHILE .NOT. PLA->(EOF())

*-------------LOCALIZACION DEL PROFESOR
		lMatVarTma := lLocMatVar(PLA->cCodigoMat,'PLA')
		cCodigoTpr := SPACE(06)
		IF !lMatVarTma
		   cCodigoTpr := PLA->(&('cPr'+GRU->cCodigoGru+'PLA'))
		ENDIF

		IF !lMatVarTma .AND. !EMPTY(cCodigoTpr)

*..................GRABACION EN PROFESORES
		     IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)

		      IF cMaeAct $ PRO->cMaeAluPro
			 nPosIni := AT(cMaeAct,PRO->cMaeAluPro)
		      ELSE
			 nPosIni := AT(SPACE(03),PRO->cMaeAluPro)
		      ENDIF

		      IF PRO->(lRegLock(lShared,.F.))
			 REPL PRO->lSiProfPro WITH .T.
			 REPL PRO->lCargasPro WITH .T.
			 REPL PRO->cMaeAluPro WITH ;
			      STUFF(PRO->cMaeAluPro,nPosIni,3,cMaeAct)
			 PRO->(DBCOMMIT())
			 IF lShared
			    PRO->(DBUNLOCK())
			 ENDIF
		      ENDIF

		     ENDIF
*..................FIN GRABACION EN PROFESORES

		ENDIF
*-------------FIN LOCALIZACION DEL PROFESOR

*-------------GRABACION DE LA CARGA
		SELECT CAR
		IF !lMatVarTma .AND. !EMPTY(cCodigoTpr)
		   IF CAR->(lRegLock(lShared,.T.))
		      REPL CAR->cCodigoPro WITH cCodigoTpr
		      REPL CAR->cCodigoCar WITH PLA->cCodigoMat+;
						GRU->cCodigoGru
		      REPL CAR->nTipCarCar WITH 0  // Carga Normal
		      REPL CAR->cIntHorPla WITH PLA->cIntHorPla
		      CAR->(DBCOMMIT())
		      IF lShared
			 CAR->(DBUNLOCK())
		      ENDIF
		    *ÀGrabaci¢n de n£mero asignado
		   ENDIF
		ENDIF
*-------------FIN GRABACION DE LA CARGA

*------------RECORRIDO DE LA SUBDIVISION POR NIVEL
	       IF MAT->nMatVarMat == 1

*.................FILTRACION DE LA SUBDIVISION
		    SELECT SUN
		    SET FILTER TO (SUN->cCodigoNiv == SUBS(GRU->cCodigoGru,1,2) .OR.;
				   SUN->cCodigoNiv == 'XX') .AND.;
				   SUBS(SUN->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		    GO TOP
*.................FIN FILTRACION DE LA SUBDIVISION

*.................RECORRIDO DE LA SUBDIVISION
		    DO WHILE .NOT. SUN->(EOF())

*                       LOCALIZACION DEL PROFESOR
			  lLocCodigo('cCodigoMat','MAT',SUN->cCodigoMat)

			  IF SUN->lPorNivSuN
			     cCodigoTpr := SUN->cCodigoPro
			  ELSE
			     cCodigoTpr := MAT->cCodigoPro
			  ENDIF
*                       FIN LOCALIZACION DEL PROFESOR

*                       GRABACION EN PROFESORES
			  IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)

			     IF cMaeAct $ PRO->cMaeAluPro
				nPosIni := AT(cMaeAct,PRO->cMaeAluPro)
			     ELSE
				nPosIni := AT(SPACE(03),PRO->cMaeAluPro)
			     ENDIF

			     IF PRO->(lRegLock(lShared,.F.))
				REPL PRO->lSiProfPro WITH .T.
				REPL PRO->lCargasPro WITH .T.
				REPL PRO->cMaeAluPro WITH ;
				     STUFF(PRO->cMaeAluPro,nPosIni,3,cMaeAct)
				PRO->(DBCOMMIT())
				IF lShared
				   PRO->(DBUNLOCK())
				ENDIF
			     ENDIF

			  ENDIF
*                       FIN GRABACION EN PROFESORES

*                       CREACION DEL CODIGO DE LA CARGA
			  IF SUN->lPorNivSuN
			     cCodigoTca := SUN->cCodigoMat+;
					   SUBS(GRU->cCodigoGru,1,2)+'XX'
			     nTipCarTca := 2   // Variable por nivel
			  ELSE
			     cCodigoTca := SUN->cCodigoMat+'XXXX'
			     nTipCarTca := 3   // Variable por niveles
			  ENDIF
*                       FIN CREACION DEL CODIGO DE LA CARGA

*                       GRABACION DE LA CARGA
			  SELECT CAR
			  IF !EMPTY(cCodigoTpr) .AND.;
			     !lLocCodCar(cCodigoTca,cCodigoTpr)
*			     !lLocCodigo('cCodigoCar','CAR',cCodigoTca)

			     IF CAR->(lRegLock(lShared,.T.))
				REPL CAR->cCodigoPro WITH cCodigoTpr
				REPL CAR->cCodigoCar WITH cCodigoTca
				REPL CAR->nTipCarCar WITH nTipCarTca
				REPL CAR->cIntHorPla WITH PLA->cIntHorPla

				CAR->(DBCOMMIT())
				IF lShared
				   CAR->(DBUNLOCK())
				ENDIF
			      *ÀGrabaci¢n de n£mero asignado
			     ENDIF
			  ENDIF
*                       FIN GRABACION DE LA CARGA

			SUN->(DBSKIP())

		     ENDDO
		     SET FILTER TO
		     SELECT PLA
*..................FIN RECORRIDO DE LA SUBDIVISION

	       ENDIF
*------------RECORRIDO DE LA SUBDIVISION POR NIVEL

*------------RECORRIDO DE LA SUBDIVISION POR GRUPO
	       IF MAT->nMatVarMat == 2

*.................FILTRACION DE LA SUBDIVISION
		    SELECT SUG
		    SET FILTER TO SUG->cCodigoGru == GRU->cCodigoGru .AND.;
			SUBS(SUG->cCodigoMat,1,2) == SUBS(PLA->cCodigoMat,1,2)
		    GO TOP
*.................FIN FILTRACION DE LA SUBDIVISION

*.................RECORRIDO DE LA SUBDIVISION
		    DO WHILE .NOT. SUG->(EOF())

*                      GRABACION EN PROFESORES
			 cCodigoTpr := SUG->cCodigoPro
			 IF lLocCodigo('cCodigoPro','PRO',cCodigoTpr)

			    IF cMaeAct $ PRO->cMaeAluPro
			       nPosIni := AT(cMaeAct,PRO->cMaeAluPro)
			    ELSE
			       nPosIni := AT(SPACE(03),PRO->cMaeAluPro)
			    ENDIF

			    IF PRO->(lRegLock(lShared,.F.))
			       REPL PRO->lSiProfPro WITH .T.
			       REPL PRO->lCargasPro WITH .T.
			       REPL PRO->cMaeAluPro WITH ;
				    STUFF(PRO->cMaeAluPro,nPosIni,3,cMaeAct)
			       PRO->(DBCOMMIT())
			       IF lShared
				  PRO->(DBUNLOCK())
			       ENDIF
			    ENDIF

			 ENDIF
*                      FIN GRABACION EN PROFESORES

*                       GRABACION DE LA CARGA
			  cCodigoTca := SUG->cCodigoMat+GRU->cCodigoGru
			  SELECT CAR
			  IF !EMPTY(cCodigoTpr) .AND.;
			     !lLocCodCar(cCodigoTca,cCodigoTpr)
*			     !lLocCodigo('cCodigoCar','CAR',cCodigoTca)

			     IF CAR->(lRegLock(lShared,.T.))
				REPL CAR->cCodigoPro WITH cCodigoTpr
				REPL CAR->cCodigoCar WITH cCodigoTca
				REPL CAR->nTipCarCar WITH 1 // Variable por Grupo
				REPL CAR->cIntHorPla WITH PLA->cIntHorPla

				CAR->(DBCOMMIT())
				IF lShared
				   CAR->(DBUNLOCK())
				ENDIF
			      *ÀGrabaci¢n de n£mero asignado
			     ENDIF
			  ENDIF
*                       FIN GRABACION DE LA CARGA

			SUG->(DBSKIP())

		     ENDDO
		     SET FILTER TO
		     SELECT PLA
*..................FIN RECORRIDO DE LA SUBDIVISION

	       ENDIF
*------------FIN RECORRIDO DE LA SUBDIVISION POR GRUPO

	     PLA->(DBSKIP())

	   ENDDO
	   CloseDbf('PLA')
*********FIN GRABACION CARGA ACADEMICA DEL GRUPO

	 GRU->(DBSKIP())

       ENDDO
*>>>>FIN CREACION DE LAS CARGAS

*>>>>CREACION DE LA CARGA PARA PERSONAL SIN CARGA ACADEMICA
       SELECT GRU
       GO TOP
       DO WHILE .NOT. GRU->(EOF())

*********GRABACION CARGA ACADEMICA DEL GRUPO
	   IF CAR->(lRegLock(lShared,.T.))
	      REPL CAR->cCodigoPro WITH '999999'
	      REPL CAR->cCodigoCar WITH '9999'+GRU->cCodigoGru
	      CAR->(DBCOMMIT())
	      IF lShared
		 CAR->(DBUNLOCK())
	      ENDIF
	   ENDIF
*********FIN GRABACION CARGA ACADEMICA DEL GRUPO

	 GRU->(DBSKIP())

       ENDDO
*>>>>FIN CREACION DE LA CARGA PARA PERSONAL SIN CARGA ACADEMICA

*>>>>COPIA DEL ARCHIVO DE TARIFAS
       CloseDbf('CAR')
       FILECOPY(cPatSis+'\'+cMaeAct+'\'+FileCar+cMaeAct+ExtFile,;
		cPatSis+'\'+cMaeAct+'\'+FileTem+cExtTem)
*>>>>FIN COPIA DEL ARCHIVO DE TARIFAS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		      FileTem+cExtTem,'CAR',NIL,lShared)
	  cError('ABRIENDO ARCHIVO MAESTRO TEMPORAL EN '+cPatSis)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CAR->(RECCOUNT()) == 0
	    cError('NO EXISTEN CARGAS GRABADAS')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ORDENAMIENTO DEL ARCHIVO
       TERMOMETRO(0,'ORDENANDO LAS CARGAS')
       TERMOMETRO(50)
       SORT TO &(cPatSis+'\'+cMaeAct+'\'+FileCar+cMaeAct+ExtFile) ;
	    ON cCodigoPro,cCodigoCar
       TERMOMETRO(100)
*>>>>FIN ORDENAMIENTO DEL ARCHIVO

*>>>>BORRADO DEL ARCHIVO TEMPORAL
       CloseDbf('CAR')
       IF !lFileDelete(cPatSis+'\'+cMaeAct+'\'+FileTem+cExtTem)
	  cError('NO SE BORRO EL MAESTRO TEMPORAL')
       ENDIF
       CLOSE ALL
       RETURN NIL
*>>>>BORRADO DEL ARCHIVO TEMPORAL

/*************************************************************************
* TITULO..: CREACION AULAS VIRTUALES                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 12/96 MAR A
       Colombia, Bucaramanga        INICIO: 09:25 AM   MAR 12/96 MAR


REQUERIMIENTOS:

1- Para ejecutar la funci¢n tener presente la sintaxis

OBJETIVOS:

1- Permite crear el archivo con las cargas acad‚micas de los profesores

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_352(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL nNroFil := 0                   // N£mero de la Fila

       LOCAL nNroBis := 0                   // N£mero del peri¢do
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL nCopias := 1                   // N£meros de copias a imprimir
       LOCAL nNroCop := 1                   // N£mero de copia
       LOCAL cCodGru := ''                  // C¢dgio del grupo
       LOCAL nTipBol := 0                   // Tipo de Boletin
       LOCAL nNroLin := 0                   // N£mero de l¡neas para las listas
       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathNot := ''                  // Path de Notas

       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL nHanPro := 0                   // Manejador Archivo Binario
       LOCAL nHanCar := 0                   // Manejador de la Carga
       LOCAL fCodPro := ''                  // Archivo del Profesor
       LOCAL fCodCar := ''                  // Archivo del Profesor de la Carga
       LOCAL fProfes := ''                  // Archivo del Profesor
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cNombreTpr := ''               // Nombre del Profesor
       LOCAL lRetiroTes := .F.              // Estudiante Retirado
       LOCAL lRetiroTno := .F.              // Estudiante Retirado

       FIELD cCodigoGru                     // C¢digo del Grupo
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

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared)     .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+;
		       FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileMat,'MAT',NIL,lShared)

	  cError('ABRIENDO ARCHIVOS')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTE PROFESORES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LOS PROFESORES
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro .AND.;
		     PRO->lCargasPro .AND. !PRO->lRetiroPro
       GO TOP
       IF EOF()
	  cError('NO EXISTEN PROFESORES PARA '+cMaeAct)
	  SET FILTER TO
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervPro(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ANALISIS DE DESICION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CLOSE ALL
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DESICION

*>>>>CREACION DEL ARCHIVO
       fProfes := cFileTempo('AULASWWW\','Prof','.htm')
       IF FCREATE(fProfes,0) == -1
	   cError(fProfes,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHanPro := FOPEN(fprofes,2)) = -1 .AND. lFHayErr(fprofes)
	  cError(fprofes,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ENCABEZADO DE LA PAGINA
       lSaveTxt('<html>',nHanPro,fprofes)
       lSaveTxt('<head>',nHanPro,fprofes)
       lSaveTxt('<TITLE>AULA VIRTUAL</TITLE>',nHanPro,fprofes)
       lSaveTxt('</head>',nHanPro,fprofes)
       lSaveTxt('<BODY background="Fondo.gif">',nHanPro,fprofes)
       lSaveTxt('<p align="center"><img src="Logo.gif" width="254" height="65"></p>',nHanPro,fprofes)
*>>>>FIN ENCABEZADO DE LA PAGINA

*>>>>IMPRESION POR GRUPOS
       SELECT PRO
       GO nRegIni
       DO WHILE PRO->(RECNO()) <= nRegFin

**********VALIDACION DE LA CARGA ACADEMICA
	    DO CASE
	    CASE !PRO->lCargasPro
		 cError('NO TIENE CARGA ACADEMICA')

	    CASE !(cMaeAct $ PRO->cMaeAluPro)
		 cError('NO TIENE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE

	    IF lHayErr
	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTpr := ALLTRIM(PRO->cNombrePro)
**********FIN VALIDACION DE LA CARGA ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			    PRO->cCodigoPro+'\'+;
			'CARPRO'+cAnoSis+ExtFile,'CAR',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE CARGA ACADEMICA')
	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAR->(RECCOUNT()) == 0
		 cError('NO EXISTEN REGISTROS DE CARGA ACADEMICA')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE

	    IF lHayErr
	       SELECT PRO
	       PRO->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('PROFESOR. '+ALLTRIM(STR(PRO->(RECNO())),9)+'/'+;
					ALLTRIM(STR(PRO->(RECCOUNT())),9),'')
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********CREACION DEL ARCHIVO
	    fCodPro := 'AULASWWW\'+PRO->cCodigoPro+'.htm'

	    IF FCREATE(fCodPro,0) == -1
		cError(fCodPro,'EL ARCHIVO','NO SE PUEDE CREAR')
		RETURN NIL
	    ENDIF
**********FIN CREACION DEL ARCHIVO

**********APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
	    IF (nHandle := FOPEN(fCodPro,2)) = -1 .AND. lFHayErr(fCodPro)
	       cError(fCodPro,'EL ARCHIVO','NO SE PUDO ABRIR')
	       RETURN NIL
	    ENDIF
**********FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

**********ENCABEZADO DE LA PAGINA
	    lSaveTxt('<html>',nHandle,fCodPro)
	    lSaveTxt('<head>',nHandle,fCodPro)
	    lSaveTxt('<TITLE>ASIGNACION ACADEMICA</TITLE>',nHandle,fCodPro)
	    lSaveTxt('</head>',nHandle,fCodPro)
	    lSaveTxt('<BODY background="Fondo.gif">',nHandle,fCodPro)
	    lSaveTxt('<p align="center"><img src="Logo.gif" width="254" height="65"></p>',nHandle,fCodPro)
	    lSaveTxt('<p align="center">Prof. '+cNombreTpr+'</p>',nHandle,fCodPro)
**********FIN ENCABEZADO DE LA PAGINA

**********LINK DEL AULA VIRTUAL
	   lSaveTxt('<p align="center"><a href='+PRO->cCodigoPro+'.htm>'+;
		     'Prof. '+cNombreTpr+'</a></p>',nHanPro,fProfes)
**********FIN LINK DEL AULA VIRTUAL

**********CREACION DEL ARCHIVO DE LA CARGA
	    fCodCar := 'AULASWWW\'+PRO->cCodigoPro+'01.htm'

	    IF FCREATE(fCodCar,0) == -1
		cError(fCodCar,'EL ARCHIVO','NO SE PUEDE CREAR')
		RETURN NIL
	    ENDIF
**********FIN CREACION DEL ARCHIVO DE LA CARGA

**********APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
	    IF (nHanCar := FOPEN(fCodCar,2)) = -1 .AND. lFHayErr(fCodCar)
	       cError(fCodCar,'EL ARCHIVO','NO SE PUDO ABRIR')
	       RETURN NIL
	    ENDIF
**********FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

**********ENCABEZADO DE LA PAGINA DE LA CARGA
	    lSaveTxt('<html>',nHanCar,fCodCar)
	    lSaveTxt('<head>',nHanCar,fCodCar)
	    lSaveTxt('<TITLE>ASIGNACION ACADEMICA</TITLE>',nHandle,fCodCar)
	    lSaveTxt('</head>',nHanCar,fCodCar)
	    lSaveTxt('<BODY background="fondo.gif">',nHanCar,fCodCar)
	    lSaveTxt('<p align="center"><img src="logo.gif" width="254" height="65"></p>',nHanCar,fCodCar)
	    lSaveTxt('<p align="center">Prof. '+cNombreTpr+'</p>',nHanCar,fCodCar)
	    lSaveTxt('<form action="" method="post">',nHanCar,fCodCar)
	    lSaveTxt('<select name="selDay" >',nHanCar,fCodCar)
**********FIN ENCABEZADO DE LA PAGINA

**********RECORRIDO DE LA CARGA ACADEMICA
	    SELECT CAR
	    CAR->(DBGOTOP())
	    nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
	    DO WHILE .NOT. CAR->(EOF())

*..............VERIFICACION O CREACION DEL DIRECTORIO AULAS
		 PathAct := cPathAct()
		 DO CASE
		 CASE DIRCHANGE ('AULASWWW\'+CAR->cCodigoCar) == 0
		      DIRCHANGE(PathAct)

		 CASE DIRCHANGE ('AULASWWW\'+CAR->cCodigoCar) == -5
		      cError("NO HAY DERECHOS EN EL DIRECTORIO AULASWWW")
		      QUIT

		 CASE DIRCHANGE(CAR->cCodigoCar) == -3
		      DIRMAKE('AULASWWW\'+CAR->cCodigoCar)
		 ENDCASE
		 DIRCHANGE(PathAct)
*..............FIN VERIFICACION O CREACION DEL DIRECTORIO AULAS

*..............INICIALIZACION DEL PATH DE NOTAS
		 cCodGru := SUBS(CAR->cCodigoCar,5,4)
		 PathNot := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+PRO->cCodigoPro
		 FileNot := CAR->cCodigoCar+ExtFile
*..............FIN INICIALIZACION DEL PATH DE NOTAS

*..............SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,PathNot+'\'+FileNot,'NOT',NIL,lShared)
		    cError('ABRIENDO EL ARCHIVO DE NOTAS')
		    IF lPregunta('DESEA CONTINUAR? Si No')
		       EXIT
		    ENDIF
		    CloseAll()
		    RETURN NIL
		 ENDIF
		 lLocCodigo('cCodigoMat','MAT',SUBS(CAR->cCodigoCar,1,4))
*..............FIN SELECION DE LAS AREAS DE TRABAJO

*..............LINK DEL AULA VIRTUAL
		 lSaveTxt('<p align="center"><a href=/manhat-bin/doorstep?class='+;
			  CAR->cCodigoCar+'>'+'CURSO '+cCodGru+' '+;
			  ALLTRIM(MAT->cNomAulMat)+;
			  '</a><p>',nHandle,fCodPro)

		 lSaveTxt('<option value="'+CAR->cCodigoCar+'">CURSO '+;
			   cCodGru+' '+ALLTRIM(MAT->cNombreMat)+;
			   '</option>',nHanCar,fCodCar)
*..............FIN LINK DEL AULA VIRTUAL

*..............VISUALIZACION DE LA CARGA
		 @ nNroFil,01 SAY 'CURSO: '+cCodGru+' '+;
				  ALLTRIM(MAT->cNombreMat)
		 nNroFil++
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,'PROFESOR: '+cNombreTpr)
		 ENDIF
*..............FIN VISUALIZACION DE LA CARGA

*..............GRABACION DEL AULA VIRTUAL DEL CURSO
		 FileManhat('AULASWWW\'+CAR->cCodigoCar,;
			    'roster.txt',cMaeAct,;
			    ALLTRIM(MAT->cNomAulMat),;
			    cCodGru,;
			    PRO->cCodigoPro,;
			    cNombreTpr)
*..............FIN GRABACION DEL AULA VIRTUAL DEL CURSO

	       CloseDbf('NOT')
	       CAR->(DBSKIP())

	    ENDDO
	    SELECT CAR
	    CloseDbf('CAR')
	    lSaveTxt('</select>',nHanCar,fCodCar)
	    lSaveTxt('</body>',nHanCar,fCodCar)
	    lSaveTxt('</html>',nHanCar,fCodCar)
	    IF !FCLOSE(nHanCar) .AND. lFHayErr(fCodCar)
	       cError('ERROR CERRANDO EL ARCHIVO '+fCodCar)
	    ENDIF
**********FIN RECORRIDO DE LA CARGA ACADEMICA

	  SELECT PRO
	  PRO->(DBSKIP())

**********CERRANDO ARCHIVOS
	    lSaveTxt('</body>',nHandle,fCodPro)
	    lSaveTxt('</html>',nHandle,fCodPro)
	    IF !FCLOSE(nHandle) .AND. lFHayErr(fCodPro)
	       cError('ERROR CERRANDO EL ARCHIVO '+fCodPro)
	    ENDIF
**********FIN CERRANDO ARCHIVOS

**********CERRANDO ARCHIVOS

**********FIN CERRANDO ARCHIVOS

       ENDDO
*>>>>FIN IMPRESION POR GRUPOS

*>>>>CERRANDO ARCHIVOS
       lSaveTxt('</body>',nHanPro,fProfes)
       lSaveTxt('</html>',nHanPro,fProfes)

       IF !FCLOSE(nHanPro) .AND. lFHayErr(fProfes)
	  cError('ERROR CERRANDO EL ARCHIVO '+fProfes)
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS


/*************************************************************************
* TITULO..: GRABACION DEL ARCHIVO SQL                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 04/2003 MAR A
       Colombia, Bucaramanga        INICIO: 03:20 PM   MAR 04/2003 MAR

OBJETIVOS:

1- Crea un archivo texto con campos delimitados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FileManhat(PathArc,fArchvo,cMaeAct,cNomMat,cCodGru,cCodPro,cNomPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo
       fArchvo                              // Archivo a Crear
       cMaeAct                              // Maestro Actual
       cNomMat                              // Nombre de la Materia
       cCodGru                              // C¢digo del Grupo
       cCodPro                              // C¢digo del Profesor
       cNomPro                              // Nombre del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contadores
       LOCAL nHandle := 0                   // Manejador Archivo Binario
       LOCAL cCampos := ''                  // Campo del Registro
       LOCAL cTxtReg := ''                  // Texto del Registro
       LOCAL nAvance := 0                   // Control de Avance

       LOCAL cCamKey := ''                  // Campo Llave
       LOCAL cNomCam := ''                  // Nombre del Campo
       LOCAL cTipCam := ''                  // Tipo del Campo
       LOCAL nLenCam := ''                  // Longitud del Campo
       LOCAL nNroDec := ''                  // Numero de Decimales

       LOCAL cNomArc := ''                  // Nombre del Archivo
       LOCAL cCamSql := ''                  // Nombre del Campo Sql
       LOCAL cTipSql := ''                  // Tipo del Campo Sql
       LOCAL cLenSql := ''                  // Ancho del Campo Sql
       LOCAL cDecSql := ''                  // Decimales del Campo Sql
       LOCAL cCamTxt := ''                  // Contenido del Campo
       LOCAL cNomNiv := ''                  // Nombre del Nivel

       LOCAL cCodigoTes := ''               // C¢digo del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DEL ARCHIVO
       fArchvo := SUBS(fArchvo,1,AT('.',fArchvo)-1)
       cNomArc := fArchvo
       fArchvo := PathArc+'\'+fArchvo+'.txt'

       IF FCREATE(fArchvo,0) == -1
	   cError(fArchvo,'EL ARCHIVO','NO SE PUEDE CREAR')
	   RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA
       IF (nHandle := FOPEN(fArchvo,2)) = -1 .AND. lFHayErr(fArchvo)
	  cError(fArchvo,'EL ARCHIVO','NO SE PUDO ABRIR')
	  RETURN NIL
       ENDIF
*>>>>FIN APERTURA DEL ARCHIVO EN MODO LECTURA Y ESCRITURA

*>>>>ANALISIS DEL NIVEL ESCOGIDO
       DO CASE
       CASE 'JAR' $ cMaeAct
	    cNomNiv := 'JARDIN'
       CASE 'PRI' $ cMaeAct
	    cNomNiv := 'PRIMARIA'
       CASE 'BTO' $ cMaeAct
	    cNomNiv := 'BACHILLERATO'
       ENDCASE
*>>>>FIN ANALISIS DEL NIVEL ESCOGIDO

*>>>>CREACION DEL ENCABEZADO
       lSaveTxt(cNomMat,nHandle,fArchvo)
       lSaveTxt(cNomNiv,nHandle,fArchvo)
       lSaveTxt('CURSO: '+cCodGru,nHandle,fArchvo)
       lSaveTxt('Prof. '+cNomPro,nHandle,fArchvo)
       lSaveTxt(cCodPro+' '+cNomPro,nHandle,fArchvo)
*>>>>FIN CREACION DEL ENCABEZADO

*>>>>REGISTROS DE LA TABLA
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********BUSQUEDA DEL ESTUDIANTE
	    cCodigoTes := NOT->cCodigoEst
	    IF !lSekCodigo(cCodigoTes,cMaeAct)
	       cNombreTes := 'Estudiante No Existe'
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)

	    IF .NOT. &cMaeAct->lRetiroEst
	       lSaveTxt(cCodigoTes+' '+cNombreTes,nHandle,fArchvo)
	    ENDIF
**********FIN BUSQUEDA DEL ESTUDIANTE

	  NOT->(DBSKIP())

       ENDDO
*>>>>FIN REGISTROS DE LA TABLA

*>>>>CERRANDO ARCHIVOS
       IF !FCLOSE(nHandle) .AND. lFHayErr(fArchvo)
	  cError('ERROR CERRANDO EL ARCHIVO '+fArchvo)
       ENDIF
       RETURN NIL
*>>>>FIN CERRANDO ARCHIVOS