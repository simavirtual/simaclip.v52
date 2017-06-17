/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : FINAL A¥O
SUBMODULO...: APROBACION TODOS

**************************************************************************
* TITULO..: APROBACIONES POR TODOS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 11/1996 LUN A
       Colombia, Bucaramanga        INICIO: 07:55 PM   NOV 11/1996 LUN

OBJETIVOS:

1- Imprime por grupos y n£mero de lista los boletines de los estudiantes

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_552(aParam1,aParam2,aParam3,nAprAut)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales
       nAprAut			            // Promoci¢n Automatica */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema
*>>>>FIN DECLARACION DE CONSTANTES

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL nNroFil := 0                   // N£mero de Fila

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aMateID := {}                  // Materia Insuficiente o Deficiente
       LOCAL nMatPer := 0                   // Materias Perdidas
       LOCAL nArePer := 0                   // Areas Perdidas
       LOCAL GetList := {}                  // Variable del sistema

       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAl nAproboTno := 0                // C¢digo de Aprobacion
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

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileApr,'APR',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       nAprAut := IF(nAprAut==NIL,0,nAprAut)
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL NIVEL')

       CASE TCO->nTotPerTbl == 0
	    cError('NO SE HA DEFINIDO EL TOTAL DE PERIODOS')

       CASE TCO->nTotPerTbl > 5
	    cError('EL TOTAL DE PERIODOS NO PUEDE SER MAYOR A CINCO(5)')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE APR->(RECCOUNT()) == 0
	    cError('NO ESTAN GRABADOS LOS CODIGOS DE APROBACION')

       CASE nAprAut # 0 .AND. !lValNivApr(nAprAut)
	    cError('REVISE LA CONFIGURACION DE LA TABLA DE PROMOCION')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       IF nAprAut # 0
	  IF !lPregunta('SE VA A CALCULAR LOS CODIGOS DE PROMOCION '+;
			'CON EL METODO No.'+;
			ALLTRIM(STR(nAprAut,2))+'?No Si')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>LECTURA DE LOS CODIGOS DE APROBACION
       IF nAprAut == 0
	  @ nFilInf+3,nColInf SAY 'CODIGO DE APROBACION:';
			      GET nAproboTno PICT '99'
	  READ
	  IF !lPregunta('DESEA CONTINUAR? Si No')
	     CloseAll(aUseDbf)
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LECTURA DE LOS CODIGOS DE APROBACION

*>>>>LOCALIZACION DEL CODIGO DE APROBACION
       IF nAprAut == 0
	  IF !EMPTY(nAproboTno)
	     IF !lLocCodigo('nCodigoApr','APR',nAproboTno)
		cError('CODIGO DE APROBACION NO EXISTE')
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO DE APROBACION

*>>>>IMPRESION DE LAS NOTAS DIGITADAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\'+cMaeAct+'\NOTAS\')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
	    IF nAprAut # 0
	       aNotAre := {}
	       aNotMat := {}
	       DetAreas(@aNotAre,@aNotMat,TCO->nTotPerTbl)
	    ENDIF
**********FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

**********GRABACION DE LOS REGISTROS
	    nNroFil := nMarco(nFilPal+1,'APROBACION DE ESTUDIANTES '+;
			      'METODO No.'+ALLTRIM(STR(nAprAut,2)))
	    SELECT NOT
	    GO TOP
	    DO WHILE .NOT. EOF()

*--------------IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRABANDO: '+GRU->cCodigoGru+'/'+cGruFin+;
			     'ºMETODO No. '+STR(nAprAut,2)+'/'+;
			     'ºNo. '+NOT->(STR(RECNO(),2))+'/'+;
			      NOT->(STR(RECCOUNT(),2)),cNomSis)
*--------------FIN IMPRESION DE LA LINEA DE ESTADO

*--------------ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO
		 IF NOT->lRetGruNot
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE PERTENECE AL GRUPO

*--------------BUSQUEDA DEL CODIGO DEL ESTUDIANTE
		 IF lSekCodigo(NOT->cCodigoEst,cMaeAct)
		    cNombreTes := RTRIM(&cMaeAct->cApelliEst)+' '+;
				  RTRIM(&cMaeAct->cNombreEst)
		 ELSE
		    cNombreTes := 'EL ALUMNO NO EXISTE'
		 ENDIF
		 cNombreTes := SUBS(cNombreTes+SPACE(30),1,30)
*--------------FIN BUSQUEDA DEL CODIGO DEL ESTUDIANTE

*--------------ANALISIS SI EL ESTUDIANTE ESTA RETIRADO
		 IF &cMaeAct->lRetiroEst
		    @ nNroFil,03 SAY cNombreTes+'... RETIRADO'
		    SELECT NOT
		    NOT->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO

*--------------ANALISIS DE MATERIAS PERDIDAS
		 DO CASE
		 CASE nAprAut == 1
		      aMateID := {}
		      EstMatID(aNotAre,aNotMat,;
			       TCO->nTotPerTbl,TCO->lRecNotTbl,;
			       @aMateID)
		      nMatPer := LEN(aMateID)

		 CASE nAprAut == 2
		      aMateID := {}
		      AreNAprEst(aNotAre,aNotMat,;
				 TCO->nTotPerTbl,TCO->lRecNotTbl,;
				 @aMateID)
		      nArePer := LEN(aMateID)
		 ENDCASE
*--------------FIN ANALISIS DE MATERIAS PERDIDAS

*--------------ANALISIS DEL CODIGO DE PROMOCION
		 DO CASE
		 CASE nAprAut == 1  // Por Intervalo
		      nAproboTno := nAprAut001(nMatPer,;
					       SUBS(GRU->cCodigoGru,1,2))

		 CASE nAprAut == 2  // Secuencia de Grados
		      nAproboTno := nAprAut002(nArePer,;
					       SUBS(GRU->cCodigoGru,1,2))
		 ENDCASE
*--------------FIN ANALISIS DEL CODIGO DE PROMOCION

*--------------GRABACION DEL REGISTRO
		 @ nNroFil,03 SAY cNombreTes+'... '+STR(nAproboTno,2)
		 SELECT NOT
		 IF NOT->(lRegLock(lShared,.F.))
		    REPL NOT->nAproboNot WITH nAproboTno
		 ELSE
		    cError('NO SE PUEDE GRABAR LAS NOTAS')
		 ENDIF
		 IF lShared
		    NOT->(DBUNLOCK())
		 ENDIF
*--------------FIN GRABACION DEL REGISTRO

*--------------GRABACION DEL REGISTRO EN EL MAESTRO
		 SELECT &cMaeAct
		 IF lRegLock(lShared,.F.)
		    REPL &cMaeAct->nAprAntNot WITH &cMaeAct->nAproboNot
		    REPL &cMaeAct->nAproboNot WITH nAproboTno
		    REPL &cMaeAct->lRepiteEst WITH !APR->lAproboApr
		 ELSE
		    cError('NO SE PUEDE GRABAR EL REGISTRO')
		 ENDIF
		 IF lShared
		    DBUNLOCK()
		 ENDIF
*--------------FIN GRABACION DEL REGISTRO EN EL MAESTRO

*--------------CONTROL DE VISUALIZACION
		 nNroFil++
		 IF nNroFil == 21
		    nNroFil := nMarco(nFilPal+1,'APROBACION DE ESTUDIANTES '+;
				      'METODO No.'+ALLTRIM(STR(nAprAut,2)))
		 ENDIF
*--------------FIN CONTROL DE VISUALIZACION

	       SELECT NOT
	       SKIP

	    ENDDO
	    CloseDbf('NOT')
**********FIN GRABACION DE LOS REGISTROS

	  SELECT GRU
	  SKIP

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LAS NOTAS DIGITADAS

/*************************************************************************
* TITULO..: AREAS PERDIDAS DEL ESTUDIANTE                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 13/2008 MAR A
       Colombia, Bucaramanga        INICIO: 09:30 AM   NOV 13/2008 MAR

OBJETIVOS:

1- Determina las Areas peridas del estudiante para un periodo especifico

2- Retorna un vector con las Areas perdidas.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION AreNAprEst(aNotAre,aNotMat,nNroPer,lRecNot,aMateID)

*>>>>DESCRIPCION DE PARAMETROS
/*     aNotAre                              // Detalles de las areas
       aNotMat                              // Detalles de las materias
       nNroPer                              // N£mero del Periodo
       lRecNot                              // .T. Recuperar el Juicio Valorativo
       aMateID                              // Materia Insuficiente o Deficiente */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j := 0                       // Contadores

       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL cNomJvf := ''                  // Nombre del Juicio Valorativo

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR AREAS
       aMateID := {}
       FOR i := 1 TO LEN(aNotAre)

***********AREAS NO PROMEDIABLES
	     IF SUBS(aNotAre[i][4],7,4) == 'AREN'

		cCamNotDef := aNotAre[i,4]
		cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		IF VAL(cNotDef) > 0
		   cNotDef := cNotDefJvf(VAL(cNotDef))
		ENDIF
		IF VAL(cNotRec) > 0
		   cNotRec := cNotDefJvf(VAL(cNotRec))
		ENDIF

		IF lRecNot .AND. !EMPTY(cNotRec)
		   cNotDef := cNotRec
		ENDIF

		cNomJvf := ''
		IF cAproboJvf(ALLTRIM(cNotDef),@cNomJvf) == 'N'

		   AADD(aMateID,{aNotAre[i,10],; // IF(EMPTY(PLA->cMatCerPla),cMatBol,cMatCer)
				 cNotDef,;
				 cNomJvf,;
				 aNotAre[i,7]})  // Titulo
		ENDIF
	     ENDIF
***********FIN AREAS NO PROMEDIABLES

**********RECORRIDO POR MATERIAS
	    FOR j := 1 TO LEN(aNotMat)

*===============ANALISIS DEL JUICIO VALORATIVO
		  IF aNotAre[i,2] == aNotMat[j,1]

*--------------------DESCARTAR LA MATERIA
		       cCodigoTma := SUBS(aNotMat[j,11],3,4)
		       IF SUBS(cCodigoTma,3,2) # '00'
			  LOOP
		       ENDIF
*--------------------FIN DESCARTAR LA MATERIA

		     cCamNotDef := aNotMat[j,4]
		     cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')

		     cNotDef := ALLTRIM(SUBS(&cCamNotDef,nNroPer*4-3,4))
		     cNotRec := ALLTRIM(SUBS(&cCamNotRec,nNroPer*4-3,4))
		     IF VAL(cNotDef) > 0
			cNotDef := cNotDefJvf(VAL(cNotDef))
		     ENDIF
		     IF VAL(cNotRec) > 0
			cNotRec := cNotDefJvf(VAL(cNotRec))
		     ENDIF

		     IF lRecNot .AND. !EMPTY(cNotRec)
			cNotDef := cNotRec
		     ENDIF

		     cNomJvf := ''
		     IF cAproboJvf(ALLTRIM(cNotDef),@cNomJvf) == 'N'
			AADD(aMateID,{aNotMat[j,10],;  //IF(EMPTY(PLA->cMatCerPla),cMatBol,cMatCer)
				      cNotDef,;
				      cNomJvf,;
				      aNotMat[j,7]})   // Titulo


		     ENDIF

		  ENDIF
*===============FIN ANALISIS DEL JUICIO VALORATIVO

	    ENDFOR
**********FIN RECORRIDO POR MATERIAS

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR AREAS
