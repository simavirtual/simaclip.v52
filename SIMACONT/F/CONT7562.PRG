/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : MANTENIMIENTOS - ASIGNACION ACADEMICA
SUBMODULO...: TRASLADOS

**************************************************************************
* TITULO..: TRASLADOS DE LA ASIGNACION ACADEMICA                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 02/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:43 PM   AGO 02/2002 VIE


OBJETIVOS:

1- Permite realizar cambios en la asignaci¢n acad‚mica del profesor cuando
   ya esta creada en SIMAPROF

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Cont_7562(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar linea

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
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTca := ''               // C¢digo de la Carga
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del Nivel
       LOCAL cCodigoTma := 0                // C¢digo de la Materia
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
       SET FILTER TO cMaeAct $ PRO->cMaeAluPro
       PRO->(DBGOTOP())
       IF PRO->(EOF())
	  cError('NO HAY PROFESORES QUE DICTEN EN '+cMaeAct)
	  SET FILTER TO
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DE LOS PROFESORES

*>>>>IMPRESION DE LOS ENCABEZADOS
       bMarco := {||nMarco(nFilPal+1,'POR FAVOR INGRESE LOS DETALLES '+;
				     'DE LA ASIGINACION ACADEMICA',22,'°')}
       nNroFil := EVAL(bMarco)

       aTamCol := {06,30,08,06,30}
       aTitulo := {'CODIGO','PROFESOR FUENTE','MATERIA',;
		   'CODIGO','PROFESOR DESTINO'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt

       bNroFil := {||NroFil(nNroFil,nNroCol,19,bMarco,cMsgTxt)}
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>IMPRESION DE LOS BOLETINES
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

**********LECTURA DE LA ASIGNACION ACADEMICA
	    cCodigoTca := cSpaces('CAR','cCodigoCar')
	    @ nNroFil,aNroCol[3] GET cCodigoTca PICT '@!';
				 VALID lValCarga(ROW(),COL()-6,@cCodigoTca)
	    READ
	    IF EMPTY(cCodigoTca)
	       LOOP
	    ENDIF
	    SELECT CAR
	    SET FILTER TO
	    cCodigoTma := SUBS(cCodigoTca,1,4)
	    cCodigoTgr := SUBS(cCodigoTca,5,4)
	    cCodigoTni := SUBS(cCodigoTgr,1,2)
**********FIN LECTURA DE LA ASIGNACION ACADEMICA

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('CAF')
	    IF !lUseDbf(.T.,cPatFue+'\'+;
			FCarPro+cAnoSis+ExtFile,'CAF',NIL,lShared)

	       cError('ABRIENDO ARCHIVO CARGA ACADEMICA FUENTE')
	       CloseDbf('CAF')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DE LA CARGA FUENTE
	    IF !lLocCodigo('cCodigoCar','CAF',cCodigoTca)
	       cError('LA MATERIA NO EXISTE EN LA CARGA DEL PROFESOR FUENTE')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DE LA CARGA FUENTE

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('PLA')
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			   cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)

	       cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
		       cNomNiv(SUBS(cCodigoTgr,1,2)))

	       CloseDbf('PLA')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DE LA MATERIA
	    IF !lLocCodigo('cCodigoMat','MAT',cCodigoTma)
	       cError('LA MATERIA NO EXISTE DEL PROFESOR FUENTE')
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DE LA MATERIA

**********ANALISIS DE LA MATERIA VARIABLE
	    cMatVar := cCodigoTma
	    IF lMatVarMat(cCodigoTma,.F.)
	       cMatVar := MAT->cCodigoMat
	    ENDIF
**********FIN ANALISIS DE LA MATERIA VARIABLE

**********VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO
	    IF !lMatPlan(lShared,CAF->nTipCarCar,cMatVar,;
			 SUBS(cCodigoTma,1,2)+SUBS(cCodigoTma,3,2),;
			 cCodigoTgr,.F.)
	       CloseDbf('PLA')
	       RETURN .F.
	    ENDIF
**********FIN VALIDACION SI LA MATERIA PERTENECE AL PLAN ACADEMICO

**********VALIDACION SI EL PROFESOR DICTA LA MATERIA
	    nTipMat := 0
	    IF !lDictada(lShared,cCodFue,cNomFue,;
			 MAT->cCodigoMat,MAT->cNombreMat,;
			 cCodigoTgr,.F.,@nTipMat)
	       LOOP
	    ENDIF
	    IF nTipMat == 0
	       cError('ERROR EN EL TIPO DE LA MATERIA')
	       LOOP
	    ENDIF
**********FIN VALIDACION SI EL PROFESOR DICTA LA MATERIA

**********LECTURA DEL CODIGO DEL PROFESOR DESTINO
	    cCodDes := cSpaces('PRO','cCodigoPro')
	    @ nNroFil,aNroCol[4] GET cCodDes PICT '999999';
				 VALID lValProfes(ROW(),COL()-6,@cCodDes)
	    READ
	    IF EMPTY(cCodDes)
	       EXIT
	    ENDIF
	    cNomDes := ALLTRIM(PRO->cApelliPro)+' '+;
		       ALLTRIM(PRO->cNombrePro)
	    cNomDes := SUBS(cNomDes+SPACE(30),1,30)
	    @ nNroFil,aNroCol[5] SAY cNomDes
	    cPatDes := PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+cCodDes
**********FIN LECTURA DEL CODIGO DEL PROFESOR DESTINO

**********SELECION DE LAS AREAS DE TRABAJO
	    CloseDbf('CAD')
	    CloseDbf('PRC')
	    CloseDbf('MAP')

	    IF !lUseDbf(.T.,cPatDes+'\'+;
			FCarPro+cAnoSis+ExtFile,'CAD',NIL,lShared) .OR.;
	       !lUseDbf(.T.,cPatDes+'\'+;
			FilePro+ExtFile,'PRC',NIL,lShared)         .OR.;
	       !lUseDbf(.T.,cPatDes+'\'+;
			FMatPro+cAnoSis+ExtFile,'MAP',NIL,lShared)

	       cError('ABRIENDO ARCHIVOS DE SIMAPROF')
	       CloseDbf('CAD')
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DE CONTENIDOS DE ARCHIVOS
	    lHayErr := .T.
	    DO CASE
	    CASE CAD->(RECCOUNT()) == 0
		 cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR EN SIMAPROF')

	    CASE PRC->(RECCOUNT()) == 0
		 cError('NO EXISTE EL REGISTRO DEL PROFESOR EN SIMAPROF')

	    CASE PRC->(RECCOUNT()) == 0
		 cError('NO EXISTE LAS MATERIAS DEL PROFESOR EN SIMAPROF')

	    OTHERWISE
		 lHayErr :=.F.
	    ENDCASE
	    IF lHayErr
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********VALIDACION DE LA CARGA ACADEMICA DESTINO
	    IF lLocCodigo('cCodigoCar','CAD',cCodigoTca)
	       cError('LA MATERIA YA EXISTE EN EL PROFESOR DESTINO')
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA CARGA ACADEMICA DESTINO

**********VALIDACION DE LOS DETALLES PARA EL TRASLADO
	    lHayErr := .T.
	    DO CASE
	    CASE cCodigoTca # CAF->cCodigoCar
		 cError('NO COINCIDE EL CODIGO DE LA CARGA ACADEMICA')

	    CASE nTipMat == 1 .AND.;                      // Materia Fija
		 !(PLA->cCodigoMat == cCodigoTma .AND.;
		   &('PLA->cPr'+cCodigoTgr+'Pla') == cCodFue)

		 cError('LA CARGA DEL PROFESOR: '+cCodFue+;
			' NO COINCIDE EN EL PLAN ACADEMICO')

	    CASE nTipMat == 2 .AND.;
		 !(SUN->cCodigoNiv == cCodigoTni .AND.;
		   SUN->cCodigoMat == cCodigoTma .AND.;
		   SUN->cCodigoPro == cCodFue)   .AND.;
		   SUN->lPorNivSuN

		 cError('LA CARGA DEL PROFESOR: '+cCodFue+;
			' NO COINCIDE EN EL SUBNIVEL')

	    CASE nTipMat == 3 .AND.;
		 !(SUN->cCodigoNiv == cCodigoTni  .AND.;
		   SUN->cCodigoMat == cCodigoTma  .AND.;
		   !SUN->lPorNivSuN               .AND.;
		    MAT->cCodigoMat == cCodigoTma .AND.;
		    MAT->cCodigoPro == cCodFue)

		 cError('LA CARGA DEL PROFESOR: '+cCodFue+;
			' NO COINCIDE EN MATERIAS')

	    CASE nTipMat == 4 .AND.;
		 !(SUG->cCodigoGru == cCodigoTgr   .AND.;
		   SUG->cCodigoMat == cCodigoTma   .AND.;
		   SUG->cCodigoPro == cCodFue)

		 cError('LA CARGA DEL PROFESOR: '+cCodFue+;
			' NO COINCIDE EN EL SUBGRUPO')

	    OTHERWISE
		lHayErr := .F.

	    ENDCASE
	    IF lHayErr
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LOS DETALLES PARA EL TRASLADO

**********ANALISIS DE DECISION
	    IF !lPregunta('DESEA CONTINUAR? No Si')
	       cError('SE ABANDONA EL PROCESO')
	       LOOP
	    ENDIF
**********FIN ANALISIS DE DECISION

**********INCLUSION DE LA MATERIA EN LA CARGA ACADEMICA DESTINO
	    IF cCodigoTca == CAF->cCodigoCar
	       SELECT CAD
	       IF CAD->(lRegLock(lShared,.T.))
		  REPL CAD->cCodigoCar WITH CAF->cCodigoCar
		  REPL CAD->nTipCarCar WITH CAF->nTipCarCar
		  REPL CAD->cNombreMat WITH CAF->cNombreMat
		  REPL CAD->nNroRetCaP WITH CAF->nNroRetCaP
		  REPL CAD->cNroNotCaP WITH CAF->cNroNotCaP
		  REPL CAD->cNroIndCaP WITH CAF->cNroIndCaP
		  REPL CAD->cCriEvaCaP WITH CAF->cCriEvaCaP
		  REPL CAD->cGruNotCap WITH CAF->cGruNotCap
		  REPL CAD->cPorcenCaP WITH CAF->cPorcenCaP
		  REPL CAD->cLogro1CaP WITH CAF->cLogro1CaP
		  REPL CAD->cLogro2CaP WITH CAF->cLogro2CaP
		  REPL CAD->cLogro3CaP WITH CAF->cLogro3CaP
		  REPL CAD->cLogro4CaP WITH CAF->cLogro4CaP
		  REPL CAD->cLogro5CaP WITH CAF->cLogro5CaP
		  REPL CAD->cNroDifCaP WITH CAF->cNroDifCaP
		  REPL CAD->cDific1CaP WITH CAF->cDific1CaP
		  REPL CAD->cDific2CaP WITH CAF->cDific2CaP
		  REPL CAD->cDific3CaP WITH CAF->cDific3CaP
		  REPL CAD->cDific4CaP WITH CAF->cDific4CaP
		  REPL CAD->cDific5CaP WITH CAF->cDific5CaP
		  REPL CAD->cRecom1CaP WITH CAF->cRecom1CaP
		  REPL CAD->cRecom2CaP WITH CAF->cRecom2CaP
		  REPL CAD->cRecom3CaP WITH CAF->cRecom3CaP
		  REPL CAD->cRecom4CaP WITH CAF->cRecom4CaP
		  REPL CAD->cRecom5CaP WITH CAF->cRecom5CaP
		  REPL CAD->cIndi01CaP WITH CAF->cIndi01CaP
		  REPL CAD->cIndi02CaP WITH CAF->cIndi02CaP
		  REPL CAD->cIndi03CaP WITH CAF->cIndi03CaP
		  REPL CAD->cIndi04CaP WITH CAF->cIndi04CaP
		  REPL CAD->cIndi05CaP WITH CAF->cIndi05CaP
		  REPL CAD->cIndi06CaP WITH CAF->cIndi06CaP
		  REPL CAD->cIndi07CaP WITH CAF->cIndi07CaP
		  REPL CAD->cIndi08CaP WITH CAF->cIndi08CaP
		  REPL CAD->cIndi09CaP WITH CAF->cIndi09CaP
		  REPL CAD->cIndi10CaP WITH CAF->cIndi10CaP
		  REPL CAD->cIndi11CaP WITH CAF->cIndi11CaP
		  REPL CAD->cIndi12CaP WITH CAF->cIndi12CaP
		  REPL CAD->cIndi13CaP WITH CAF->cIndi13CaP
		  REPL CAD->cIndi14CaP WITH CAF->cIndi14CaP
		  REPL CAD->cIndi15CaP WITH CAF->cIndi15CaP
		  REPL CAD->cIndi16CaP WITH CAF->cIndi16CaP
		  REPL CAD->cIndi17CaP WITH CAF->cIndi17CaP
		  REPL CAD->cIndi18CaP WITH CAF->cIndi18CaP
		  REPL CAD->cIndi19CaP WITH CAF->cIndi19CaP
		  REPL CAD->cIndi20CaP WITH CAF->cIndi20CaP
	       ELSE
		  cError('NO SE PUEDE GRABAR EL REGISTRO')
	       ENDIF
	       IF lShared
		  CAD->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN INCLUSION DE LA MATERIA EN LA CARGA ACADEMICA DESTINO

**********GRABACION DE LAS MATERIAS DEL PROFESOR
	    SELECT MAP
	    IF TCO->lIndNivTbl
	       LOCATE FOR MAP->cCodigoNiv == cCodigoTni .AND.;
			  MAP->cCodigoMat == cCodigoTma
	       lHayMat := .F.
	       IF FOUND()
		  lHayMat := .T.
	       ENDIF
	    ELSE
		lHayMat := lLocCodigo('cCodigoMat','MAP',cCodigoTma)
	    ENDIF

	    IF !lHayMat
	       IF MAP->(lRegLock(lShared,.T.))
		  IF TCO->lIndNivTbl
		     REPL MAP->cCodigoNiv WITH cCodigoTni
		  ELSE
		     REPL MAP->cCodigoNiv WITH SPACE(02)
		  ENDIF
		  REPL MAP->cCodigoMat WITH cCodigoTma
		  REPL MAP->cNombreMat WITH CAF->cNombreMat
		  MAP->(DBCOMMIT())
	       ENDIF
	       IF lShared
		  MAP->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN GRABACION DE LAS MATERIAS DEL PROFESOR

**********COPIA DEL ARCHIVO DE NOTAS DEL PROFESOR AL DESTINO
	    cSavPan := SAVESCREEN(0,0,24,79)
	    Termometro(0,'TRASLADANDO LAS NOTAS AL PROFESOR DESTINO')
	    Termometro(40)
	    FILECOPY(cPatFue+'\'+CAF->cCodigoCar+ExtFile,;
		     cPatDes+'\'+CAF->cCodigoCar+ExtFile)
	    Termometro(100)
	    RESTSCREEN(0,0,24,79,cSavPan)
**********FIN COPIA DEL ARCHIVO DE NOTAS DEL PROFESOR AL DESTINO

**********ACTUALIZACION DEL PROFESOR EN PLAN ACADEMICO
	    IF nTipMat == 1                  .AND.;  // Materia Fija
	       PLA->cCodigoMat == cCodigoTma .AND.;
	      &('PLA->cPr'+cCodigoTgr+'Pla') == cCodFue

		  SELECT PLA
		  IF PLA->(lRegLock(lShared,.F.))
		     REPL PLA->&('cPr'+cCodigoTgr+'Pla') WITH cCodDes
		     PLA->(DBCOMMIT())
		     cError('ACTUALIZADO EN EL PLAN ACADEMICO')
		  ELSE
		     cError('NO SE GRABA LA CARGA DEL PROFESOR')
		  ENDIF
		  IF lShared
		     PLA->(DBUNLOCK())
		  ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL PROFESOR EN PLAN ACADEMICO

**********ACTUALIZACION DEL PROFESOR EN EL SUBNIVEL
	    IF nTipMat == 2 .AND.;
	       SUN->cCodigoNiv == cCodigoTni .AND.;
	       SUN->cCodigoMat == cCodigoTma .AND.;
	       SUN->cCodigoPro == cCodFue    .AND.;
	       SUN->lPorNivSuN

	       SELECT SUN
	       IF SUN->(lRegLock(lShared,.F.))
		  REPL SUN->cCodigoPro WITH cCodDes
		  SUN->(DBCOMMIT())
		  cError('ACTUALIZADO EN EL SUBNIVEL')
	       ELSE
		  cError('NO SE GRABA LA CARGA DEL PROFESOR')
	       ENDIF
	       IF lShared
		  SUN->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL PROFESOR EN EL SUBNIVEL

**********ACTUALIZACION DEL PROFESOR EN MATERIAS POR MATERIA POR NIVELES
	    IF nTipMat == 3 .AND.;
	       SUN->cCodigoNiv == cCodigoTni .AND.;
	       SUN->cCodigoMat == cCodigoTma .AND.;
	       SUN->cCodigoPro == cCodFue    .AND.;
	       !SUN->lPorNivSuN              .AND.;
	       MAT->cCodigoMat == cCodigoTma .AND.;
	       MAT->cCodigoPro == cCodFue

	       SELECT MAT
	       IF MAT->(lRegLock(lShared,.F.))
		  REPL MAT->cCodigoPro WITH cCodDes
		  MAT->(DBCOMMIT())
		  cError('ACTUALIZADO EN MATERIAS')
	       ELSE
		  cError('NO SE GRABA LA CARGA DEL PROFESOR')
	       ENDIF
	       IF lShared
		  MAT->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL PROFESOR EN MATERIAS POR MATERIA POR NIVELES

**********ACTUALIZACION DEL PROFESOR EN EL SUBGRUPO
	    IF nTipMat == 4 .AND.;
	       SUG->cCodigoGru == cCodigoTgr   .AND.;
	       SUG->cCodigoMat == cCodigoTma   .AND.;
	       SUG->cCodigoPro == cCodFue

	       SELECT SUG
	       IF SUG->(lRegLock(lShared,.F.))
		  REPL SUG->cCodigoPro WITH cCodDes
		  SUG->(DBCOMMIT())
		  cError('ACTUALIZADO EN EL SUBGRUPO')
	       ELSE
		  cError('NO SE GRABA LA CARGA DEL PROFESOR')
	       ENDIF
	       IF lShared
		  SUG->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DEL PROFESOR EN EL SUBGRUPO

**********ACTUALIZACION DE LA CARGA ACADEMICA DE CONTABILIDAD
	    IF CAR->cCodigoCar == cCodigoTca .AND.;
	       CAR->cCodigoPro == cCodFue
	       SELECT CAR
	       IF CAR->(lRegLock(lShared,.F.))
		  REPL CAR->cCodigoPro WITH cCodDes
		  CAR->(DBCOMMIT())
		  cError('ACTUALIZADO EN LA CARGA ACADEMICA')
	       ELSE
		  cError('NO SE GRABA LA CARGA DEL PROFESOR')
	       ENDIF
	       IF lShared
		  CAR->(DBUNLOCK())
	       ENDIF
	    ENDIF
**********FIN ACTUALIZACION DE LA CARGA ACADEMICA DE CONTABILIDAD

**********ELIMINACION DE LA CARGA FUENTE DEL PROFESOR
	    IF CAF->cCodigoCar == cCodigoTca
	       SELECT CAF
	       RENAMEFILE(cPatFue+'\'+CAF->cCodigoCar+ExtFile,;
			  cPatFue+'\'+CAF->cCodigoCar+'.ACT')
	       IF CAF->(lRegLock(lShared,.F.))
		  CAF->(DBDELETE())
	       ELSE
		  cError('NO SE PUDO BORRAR LA MATERIA EN LA CARGA FUENTE')
	       ENDIF
*	       PACK
	    ELSE
	      cError('LOS DATOS DE LA CARGA ACADEMICA FUENTE NO COINCIDEN')
	      LOOP
	    ENDIF
**********FIN ELIMINACION DE LA CARGA FUENTE DEL PROFESOR

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN IMPRESION DE LOS BOLETINES


/*************************************************************************
* TITULO..: INCREMENTO DE LA FILA                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 03/2002 SAB A
       Colombia, Bucaramanga        INICIO: 01:00 PM   AGO 03/2002 SAB


OBJETIVOS:

1- Incrementa el n£mero de la fila controlando la £ltima fila a visualizar

2- Dibuja un marco para permitir leer o visualizar registros

3- Visualiza el £ltimo registro procesado

3- Retorna el n£mero de la fila activa

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION NroFil(nNroFil,nNroCol,nFilFin,bMarco,cTxtCab,cTxtReg)

*>>>>DESCRIPCION DE PARAMETROS
/*     nNroFil                              // N£mero de la Fila
       nNroCol                              // N£mero de la Columna
       nFilFin                              // Ultima fila a Visualizar
       bMarco                               // CodeBloc del Marco
       cTxtCab                              // Texto de Encabezado
       cTxtReg                              // Texto del Registro */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>INCREMENTO DE LAS FILAS
       nNroFil++
       IF nNroFil > nFilFin
	  nNroFil := EVAL(bMarco)
	  @ nNroFil,nNroCol SAY cTxtCab

	  IF EMPTY(cTxtReg)
	     nNroFil++
	     SET COLOR TO I
	     SET COLOR TO
	  ENDIF
	  nNroFil++
       ENDIF
       RETURN nNroFil
*>>>>FIN INCREMENTO DE LAS FILAS