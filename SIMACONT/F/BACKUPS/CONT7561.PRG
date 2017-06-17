/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : MANTENIMIENTOS - ASIGNACION ACADEMICA
SUBMODULO...: REEMPLAZO

**************************************************************************
* TITULO..: REEMPLAZO DE LA ASIGNACION ACADEMICA                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 11/2009 VIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   SEP 11/2009 VIE


OBJETIVOS:

1- Permite reemplazar la asignaci¢n acad‚mica de un profesor por otroo.

2- Se debe renombrar manualmente el directorio de profesor en simaprof.

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_7561(aP1,aP2,aP3)

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
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"              // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL bNroFil := NIL                 // CodeBloc N£mero de Fila
       LOCAL bMarco  := NIL                 // CodeBloc Marco
       LOCAL cMsgTxt := ''                  // Texto temporal

       LOCAL cCodFue := ''                  // C¢digo del Profesor Fuente
       LOCAL cNomFue := ''                  // Nombre del Profesor Fuente
       LOCAL cCodDes := ''                  // C¢digo del Profesor Destino
       LOCAL cNomDes := ''                  // Nombre del Profesor Destino
       LOCAL cPatFue := ''                  // Path del Profesor Fuente
       LOCAL cPatDes := ''                  // Path del Profesor Destino
       LOCAL cMatVar := ''                  // Materia Variable
       LOCAL nTipMat := 0                   // Tipo de Materia
       LOCAL lHayMat := .T.                 // .T. Hay Materia
       LOCAL nPosIni := 0                   // Posici¢n Inicial

       LOCAL PathAct := ''                  // Path Actual
       LOCAL lMatVar := .F.                 // .T. Materia Variable
       LOCAL cNomVar := ''                  // Nombre materia variable
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTca := ''               // C¢digo de la Carga
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL NIVEL
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       nParameSet(aP1,'cMaeAct',cMaeAct)
*>>>>FIN SELECCION DEL NIVEL

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCar+cMaeAct+ExtFile,'CAR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuN,'SUN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuG,'SUG',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION DEL DE LA CONTABILIDAD')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CAR->(RECCOUNT()) == 0
	    cError('LA ASIGNACION ACADEMICA NO HA SIDO GENERADA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>FILTRACION DE LOS PROFESORES
       SELECT PRO
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro .OR. EMPTY(PRO->cMaeAluPro)

       PRO->(DBGOTOP())
       IF PRO->(EOF())
	  cError('NO HAY PROFESORES QUE DICTEN EN '+cMaeAct)
	  SET FILTER TO
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>IMPRESION DE LOS ENCABEZADOS
       bMarco := {||nMarco(nFilPal+1,'POR FAVOR INGRESE LOS CODIGOS '+;
				     'DE LOS PROFESORES',22,'°')}
       nNroFil := EVAL(bMarco)

       aTamCol := {06,30,06,30}
       aTitulo := {'CODIGO','PROFESOR FUENTE',;
		   'CODIGO','PROFESOR DESTINO'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt

       bNroFil := {||NroFil(nNroFil,nNroCol,19,bMarco,cMsgTxt)}
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>LECTURA DE CODIGOS
       DO WHILE .T.

**********LECTURA DEL CODIGO DEL PROFESOR FUENTE
	    nNroFil := EVAL(bNroFil)
	    cSavLin := SAVESCREEN(nNroFil,00,nNroFil,79)

	    cCodFue := cSpaces('PRO','cCodigoPro')
	    @ nNroFil,aNroCol[1] GET cCodFue PICT '999999';
				 VALID lValProfes(ROW(),COL()-6,@cCodFue)
	    READ
	    IF EMPTY(cCodFue)
	       EXIT
	    ENDIF
	    cNomFue := ALLTRIM(PRO->cApelliPro)+' '+;
		       ALLTRIM(PRO->cNombrePro)
	    cNomFue := SUBS(cNomFue+SPACE(30),1,30)
	    @ nNroFil,aNroCol[2] SAY cNomFue
	    cPatFue := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+cCodFue
**********FIN LECTURA DEL CODIGO DEL PROFESOR FUENTE

**********FILTRACION DE LA ASIGNACION ACADEMICA
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == cCodFue
	    CAR->(DBGOTOP())
	    IF CAR->(EOF())
	       cError('EL PROFESOR NO TIENE ASIGNACION ACADEMICA EN '+cMaeAct)
	       SET FILTER TO
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LA ASIGNACION ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatFue+'\'+;
			FilePro+ExtFile,'PRC',NIL,lShared)
	       cError('ABRIENDO ARCHIVOS DE SIMAPROF')
	       CloseDbf('PRC')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE PRC->(RECCOUNT()) == 0
		 cError('NO EXISTE EL REGISTRO DEL PROFESOR EN SIMAPROF')

	    CASE PRC->cCodigoPro # cCodFue
		 cError('EL CODIGO DEL PROFESOR NO COINCIDE CON EL QUE EXISTE EN SIMAPROF')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseDbf('PRC')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********LECTURA DEL CODIGO DEL PROFESOR DESTINO
	    cCodDes := cSpaces('PRO','cCodigoPro')
	    @ nNroFil,aNroCol[3] GET cCodDes PICT '999999';
				 VALID lValProfes(ROW(),COL()-6,@cCodDes)
	    READ
	    IF EMPTY(cCodDes)
	       EXIT
	    ENDIF
	    cNomDes := ALLTRIM(PRO->cApelliPro)+' '+;
		       ALLTRIM(PRO->cNombrePro)
	    cNomDes := SUBS(cNomDes+SPACE(30),1,30)
	    @ nNroFil,aNroCol[4] SAY cNomDes
	    cPatDes := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+cCodDes
**********FIN LECTURA DEL CODIGO DEL PROFESOR DESTINO

**********FILTRACION DE LA ASIGNACION ACADEMICA
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == cCodDes
	    CAR->(DBGOTOP())
	    IF .NOT. CAR->(EOF())
	       cError('EL PROFESOR TIENE ASIGNACION ACADEMICA EN '+cMaeAct)
	       SET FILTER TO
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LA ASIGNACION ACADEMICA

**********VALIDACION DEL DIRECTORIO EN SIMAPROF
	    PathAct := cPathAct()
	    IF DIRCHANGE (cPatDes) == 0
	       DIRCHANGE(PathAct)
	       cError('EL DIRCTORIO DEL PROFESOR CODIGO:'+cCodDes+' EXISTE')
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL DIRECTORIO EN SIMAPROF

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       cError('SE ABANDONA EL PROCESO')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********FILTRACION DE LA ASIGNACION ACADEMICA
	    SELECT CAR
	    SET FILTER TO CAR->cCodigoPro == cCodFue
	    CAR->(DBGOTOP())
	    IF CAR->(EOF())
	       cError('EL PROFESOR NO TIENE ASIGNACION ACADEMICA EN '+cMaeAct)
	       SET FILTER TO
	       LOOP
	    ENDIF
**********FIN FILTRACION DE LA ASIGNACION ACADEMICA

**********RECORRIDO DE LA ASIGANCION ACADEMICA
	    lHayErr := .F.
	    SELECT CAR
	    CAR->(DBGOTOP())
	    DO WHILE .NOT. CAR->(EOF())

*==============DETALLES ASIGNACION ACADEMICA
		 cCodigoTca := CAR->cCodigoCar
		 cCodigoTma := SUBS(cCodigoTca,1,4)
		 cCodigoTgr := SUBS(cCodigoTca,5,4)
		 cCodigoTni := SUBS(cCodigoTgr,1,2)
*==============FIN DETALLES ASIGNACION ACADEMICA

*==============SELECION DE LAS AREAS DE TRABAJO
		 CloseDbf('PLA')
		 IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
				cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)

		    cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			    cNomNiv(SUBS(cCodigoTgr,1,2)))

		    CloseDbf('PLA')
		    LOOP
		 ENDIF
*==============FIN SELECION DE LAS AREAS DE TRABAJO

*==============LOCALIZACION DE LA MATERIA
		 IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
		    cError('LA MATERIA NO EXISTE DEL PROFESOR FUENTE')
		    LOOP
		 ENDIF
		 cNombreTma := ALLTRIM(MAT->cNombreMat)
*==============FIN LOCALIZACION DE LA MATERIA

*==============LINEA DE ESTADO
		 LineaEstado('GRUPO : '+cCodigoTgr+;
			     'ºMATERIA:'+SUBS(cNombreTma,1,40)+;
			     'ºNo. '+STR(CAR->(RECNO()),4)+'/'+;
				    STR(CAR->(RECCOUNT()),4),cNomSis)
*==============LINEA DE ESTADO

*==============ANALISIS DE LA MATERIA VARIABLE
		 cMatVar := cCodigoTma
		 IF lMatVarMat(cCodigoTma,.F.)
		    cMatVar := MAT->cCodigoMat
		 ENDIF
*==============FIN ANALISIS DE LA MATERIA VARIABLE

*==============VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO
		 IF !lMatPlan(lShared,CAR->nTipCarCar,cMatVar,;
			      SUBS(cCodigoTma,1,2)+SUBS(cCodigoTma,3,2),;
			      cCodigoTgr,.F.)
		    CloseDbf('PLA')
		    LOOP
		 ENDIF
*==============FIN VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO

*==============VALIDACION SI EL PROFESOR DICTA LA MATERIA
		 nTipMat := 0
		 IF !lDictada(lShared,cCodFue,cNomFue,;
			      MAT->cCodigoMat,MAT->cNombreMat,;
			      cCodigoTgr,.F.,@nTipMat)
		    CloseDbf('PLA')
		    LOOP
		 ENDIF
		 IF nTipMat == 0
		    cError('ERROR EN EL TIPO DE LA MATERIA')
		    LOOP
		 ENDIF
*==============FIN VALIDACION SI EL PROFESOR DICTA LA MATERIA

*==============MATERIA NORMAL
		 IF CAR->nTipCarCar == 0 .AND.;
		    cCodigoTma == PLA->cCodigoMat

*-------------------ACTUALIZACION DEL PROFESOR EN PLAN ACADEMICO
		      IF PLA->(lRegLock(lShared,.F.))
			 REPL PLA->&('cPr'+cCodigoTgr+'Pla') WITH cCodDes
			 PLA->(DBCOMMIT())
		      ELSE
			 lHayErr := .T.
			 cError('NO SE GRABA LA CARGA DEL PROFESOR')
		      ENDIF
		      IF lShared
			 PLA->(DBUNLOCK())
		      ENDIF
*-------------------FIN ACTUALIZACION DEL PROFESOR EN PLAN ACADEMICO

		 ENDIF
*==============FIN MATERIA NORMAL

*==============VARIABLE POR GRUPO
		 IF CAR->nTipCarCar == 1          .AND.;
		    SUG->cCodigoGru == cCodigoTgr .AND.;
		    SUG->cCodigoMat == cCodigoTma .AND.;
		    SUG->cCodigoPro == cCodFue

		    IF SUG->(lRegLock(lShared,.F.))
		       REPL SUG->cCodigoPro WITH cCodDes
		       SUG->(DBCOMMIT())
		    ELSE
		       lHayErr := .T.
		       cError('NO SE GRABA LA CARGA DEL PROFESOR')
		    ENDIF
		    IF lShared
		       SUG->(DBUNLOCK())
		    ENDIF

		 ENDIF
*==============FIN VARIABLE POR GRUPO

*==============VARIABLE POR NIVEL
		 IF CAR->nTipCarCar == 2          .AND.;
		    SUN->cCodigoNiv == cCodigoTni .AND.;
		    SUN->cCodigoMat == cCodigoTma .AND.;
		    SUN->cCodigoPro == cCodFue    .AND.;
		    SUN->lPorNivSuN

		    IF SUN->(lRegLock(lShared,.F.))
		       REPL SUN->cCodigoPro WITH cCodDes
		       SUN->(DBCOMMIT())
		    ELSE
		       lHayErr := .T.
		       cError('NO SE GRABA LA CARGA DEL PROFESOR')
		    ENDIF
		    IF lShared
		       SUN->(DBUNLOCK())
		    ENDIF

		 ENDIF
*==============FIN VARIABLE POR NIVEL

*==============VARIABLE POR NIVELES
		 IF CAR->nTipCarCar == 3          .AND.;
		    SUN->cCodigoNiv == cCodigoTni .AND.;
		    SUN->cCodigoMat == cCodigoTma .AND.;
		    SUN->cCodigoPro == cCodFue    .AND.;
		    !SUN->lPorNivSuN              .AND.;
		    MAT->cCodigoMat == cCodigoTma .AND.;
		    MAT->cCodigoPro == cCodFue

		    IF MAT->(lRegLock(lShared,.F.))
		       REPL MAT->cCodigoPro WITH cCodDes
		       MAT->(DBCOMMIT())
		    ELSE
		       lHayErr := .T.
		       cError('NO SE GRABA LA CARGA DEL PROFESOR')
		    ENDIF
		    IF lShared
		       MAT->(DBUNLOCK())
		    ENDIF

		 ENDIF
*==============FIN VARIABLE POR NIVELES

*==============ACTUALIZACION DE LA CARGA ACADEMICA DE CONTABILIDAD
		 IF CAR->cCodigoCar == cCodigoTca .AND.;
		    CAR->cCodigoPro == cCodFue
		    IF CAR->(lRegLock(lShared,.F.))
		       REPL CAR->cCodigoPro WITH cCodDes
		       CAR->(DBCOMMIT())
		    ELSE
		       lHayErr := .T.
		       cError('NO SE GRABA LA CARGA DEL PROFESOR')
		    ENDIF
		    IF lShared
		       CAR->(DBUNLOCK())
		    ENDIF
		 ENDIF
*==============FIN ACTUALIZACION DE LA CARGA ACADEMICA DE CONTABILIDAD

*==============ACTUALIZACION DEL PROFESOR DESTINO EN CONTABILIDAD
		 IF lLocCodigo('cCodigoPro','PRO',cCodDes)

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
		    ELSE
		       lHayErr := .T.
		       cError('NO SE GRABA LOS DETALLES EN PROFESOR')
		    ENDIF

		 ENDIF
*==============FIN ACTUALIZACION DEL PROFESOR DESTINO EN CONTABILIDAD

*==============ACTUALIZACION DEL PROFESOR FUENTE EN CONTABILIDAD
		 IF lLocCodigo('cCodigoPro','PRO',cCodFue)

		    IF cMaeAct $ PRO->cMaeAluPro
		       nPosIni := AT(cMaeAct,PRO->cMaeAluPro)
		    ELSE
		       nPosIni := AT(SPACE(03),PRO->cMaeAluPro)
		    ENDIF

		    IF PRO->(lRegLock(lShared,.F.))

		       REPL PRO->cMaeAluPro WITH ;
			    STUFF(PRO->cMaeAluPro,nPosIni,3,SPACE(03))

		       IF EMPTY(ALLTRIM(PRO->cMaeAluPro))
			  REPL PRO->lSiProfPro WITH .F.
			  REPL PRO->lCargasPro WITH .F.
		       ELSE
			  REPL PRO->lSiProfPro WITH .T.
			  REPL PRO->lCargasPro WITH .T.
		       ENDIF

		       PRO->(DBCOMMIT())
		       IF lShared
			  PRO->(DBUNLOCK())
		       ENDIF
		    ELSE
		       lHayErr := .T.
		       cError('NO SE GRABA LOS DETALLES EN PROFESOR')
		    ENDIF

		 ENDIF
*==============FIN ACTUALIZACION DEL PROFESOR FUENTE EN CONTABILIDAD

	       CAR->(DBSKIP())

	    ENDDO
**********FIN RECORRIDO DE LA ASIGANCION ACADEMICA

**********ACTUALIZACION DEL PROFESOR FUENTE EN SIMAPROF
	    IF PRC->cCodigoPro == cCodFue

	       IF PRC->(lRegLock(lShared,.F.))
		  REPL PRC->cCodigoPro WITH cCodDes
		  PRC->(DBCOMMIT())
	       ELSE
		  lHayErr := .T.
		  cError('NO SE GRABA EL PROFESOR EN SIMAPROF')
	       ENDIF
	       IF lShared
		  CAR->(DBUNLOCK())
	       ENDIF

	    ELSE
	       lHayErr := .T.
	       cError('NO SE GRABA EL PROFESOR EN SIMAPROF.')
	    ENDIF
**********FIN ACTUALIZACION DEL PROFESOR FUENTE EN SIMAPROF

**********ANALISIS DE DECISION
	    IF lHayErr
	       cError('SE PRESETARON ERRORES POR FAVOR REVISE')
	    ELSE
	       cError('RENOMBRE EL DIRECTORIO '+cCodFue+' POR '+cCodDes,;
		      'EL CAMBIO SE REALIZO CON EXITO')
	    ENDIF
**********FIN ANALISIS DE DECISION

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN LECTURA DE CODIGOS

