/* SIMA - CONTABILIDAD PROFESORES

MODULO      : LOGROS
SUBMODULO...: POR GRUPO - INDICADORES CALCULADOS

**************************************************************************
* TITULO..: APLICAR LOGROS POR GRUPO                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 24/2008 MIE
       Colombia, Bucaramanga        INICIO: 10:50 AM   SEP 24/2008 MIE

OBJETIVOS:

1- Permite aplicar los logros por grupo

2- Calcula los indicadores y los almacena a cada estudiante.

3- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Profe_261(aP1,aP2,aP3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales */
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE PARAMETROS ESPECIFICOS
       LOCAL cCodPro := xPrm(aP1,'cCodPro') // C¢digo del Profesor
       LOCAL cPatPro := xPrm(aP1,'cPatPro') // Path del Profesor
       LOCAL cNomPro := xPrm(aP1,'cNomPro') // Nombre del Profesor
*>>>>DECLARACION DE PARAMETROS ESPECIFICOS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-SPR.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cHayErr := ''                  // Hay Error
       LOCAL aDetErr := ''                  // Detalles del Error
       LOCAL aHayErr := {}                  // Hay Error
     *ÀVariables generales

       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura

       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior

       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nRegMat := 0                   // Registro de la Materia
       LOCAL nTipPla := 0                   // Tipo del Plan

       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL lBorrar := .F.                 // .T. Borrar Registros
       LOCAL lRepite := .T.                 // .T. Repiter la pregunta

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nPerAct := 0                   // Periodo Actual
       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL nRegNoP := 0                   // Registro notas del profesor
       LOCAL cCamNot := ''                  // Campo de las notas
       LOCAL cCamInd := ''                  // Campo de los indicadores. Marca Error el la Macro al declararse local
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cCamDef := ''                  // Campo de definitivas
       LOCAL cCamObs := ''                  // Campo de Observaciones

       LOCAL aDetMat := {}                  // Detalle de la Materia
       LOCAL aDbfMat := {}                  // Campos de Materias
       LOCAL aDbfPla := {}                  // Campos del Plan Academico
       LOCAL aDbfNot := {}                  // Campos de Notas
       LOCAL aMatSel := {}                  // Materias Selectivas
       LOCAL aMatVar := {}                  // Materias Variables
       LOCAL aDbfSel := {}                  // Campos de Estudiantes con Materias Selectivas
       LOCAL aDbfVar := {}                  // Campos Materias Variables

       LOCAL aTitIso := {}                  // T¡tulo Iso del Informe

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
       LOCAL lJvfCal := .F.                 // .T. Juicio Valorativo Calculado

       LOCAL cCodInd := 0                   // C¢digo del Indicador
       LOCAL nNroInd := 0                   // N£mero de indicadores

       LOCAL cIndica1 := ''                 // Indicadores del Periodo No.1
       LOCAL cIndica2 := ''                 // Indicadores del Periodo No.2
       LOCAL cIndica3 := ''                 // Indicadores del Periodo No.3
       LOCAL cIndica4 := ''                 // Indicadores del Periodo No.4
       LOCAL cIndica5 := ''                 // Indicadores del Periodo No.5

       LOCAL cNotInd1 := ''                 // Nota de Indicadores P1
       LOCAL cNotInd2 := ''                 // Nota de Indicadores P2
       LOCAL cNotInd3 := ''                 // Nota de Indicadores P3
       LOCAL cNotInd4 := ''                 // Nota de Indicadores P4
       LOCAL cNotInd5 := ''                 // Nota de Indicadores P5

       LOCAL cNotDef := ''                  // Nota Definitiva

       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCodigoTes := ''               // C¢digo del estudiante
       LOCAL cNombreTes := ''               // Nombre del estudiante
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cNombreTma := ''               // Nombre de la Materia
       LOCAL cCodigoTgr := ''               // C¢digo del grupo
       LOCAL cCodigoTni := ''               // C¢digo del nivel
       LOCAL cCodigoTcl := ''               // C¢digo Clase del indicador
     *ÀVariables de Campo

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+;
			 FilePro+cAnoSis+ExtFile,'PRO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,;
			 lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileInd+cMaeAct+cAnoSis+ExtFile,'IND',;
			 PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FNtxInd+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileSin+cMaeAct+cAnoSis+ExtFile,'SIN',;
			 NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+fSimSpr,'SPR',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatPro+'\'+;
			 FCarPro+cAnoSis+ExtFile,'CAP',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       SELECT &cMaeAct
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTS GRABADOS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE LA CONTABILIDAD')

       CASE PRO->(RECCOUNT()) == 0
	    cError('NO EXISTEN PROFESORES GRABADOS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LAS CLASES DE LOGOS')

       CASE EVA->(RECCOUNT()) == 0
	    cError('NO EXISTEN LOS CODIGOS DE EVALUACION')

       CASE JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE IND->(RECCOUNT()) == 0
	    cError('NO EXISTEN INDICADORES DE LA CONTABILIDAD')

       CASE SIN->(RECCOUNT()) == 0
	    cError('NO EXISTEN LA CLASIFICACION DE LOS INDICADORES')

       CASE SPR->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE CAP->(RECCOUNT()) == 0
	    cError('NO EXISTE CARGA ACADEMICA DEL PROFESOR')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DEL GRUPO
       cCodigoTpr := SUBS(cPatPro,LEN(cPatPro)-5,6)
       IF !lLocCodigo('cCodigoPro','PRO',cCodigoTpr,'DEL PROFESOR')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DEL GRUPO

*>>>>SELECCION DE LA MATERIA DEL GRUPO
       SELECT CAP
       IF CAP->(RECCOUNT()) # 0

**********INICIALIZACION DE LAS COORDENADAS
	    nFilSup := nFilInf+2
	    nColSup := nColInf
	    IF nFilSup+RECCOUNT() > 22
	       nInfFil := 21
	    ELSE
	       nInfFil := nFilSup + RECCOUNT()-1
	    ENDIF
	    nInfCol := nColSup+LEN(CAP->cNombreMat)+2
**********FIN INICIALIZACION DE LAS COORDENADAS

**********BROWSE DE SELECCION
	    DO WHILE .T.

*--------------SELECCION DEL REGISTRO
		 SELECT CAP
		 IF nBrowseDbf(nFilSup,02,nInfFil,78,;
			      {||SUBS(CAP->cCodigoCar,5,4)+' '+;
			       Materia()}) == 0
		    CLOSE ALL
		    RETURN NIL
		 ENDIF
		 lLocCodigo('cCodigoMat','MAT',SUBS(CAP->cCodigoCar,1,4))
*--------------FIN SELECCION DEL REGISTRO

*--------------PREGUNTA DE DECISION
		 cMsgTxt := 'ESCOGIO '+ALLTRIM(CAP->cNombreMat)+' '+;
			    'DEL GRUPO: '+SUBS(CAP->cCodigoCar,5,4)
		 cMsgTxt := SUBS(cMsgTxt,1,50)

		 IF lPregunta(cMsgTxt+' DESEA CONTINUAR? Si No')
		    EXIT
		 ENDIF
*--------------FIN PREGUNTA DE DECISION

	    ENDDO
**********FIN BROWSE DE SELECCION

       ENDIF
	  nRegMat := MAT->(RECNO())
       cCodigoTgr := SUBS(CAP->cCodigoCar,5,4)
       cCodigoTni := SUBS(cCodigoTgr,1,2)
       cCodigoTma := MAT->cCodigoMat
       cNombreTma := MAT->cNombreMat
*>>>>FIN SELECCION DE LA MATERIA DEL GRUPO

*>>>>ANALISIS DEL TIPO DE PLAN ACADEMICO
       nTipPla := 0
       IF !('XXXX' $ cCodigoTgr)
	  nTipPla := nTipoPlan(SUBS(cCodigoTgr,1,2))
	  IF nTipPla == 0
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN LOCALIZACION DEL NIVEL

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
	  IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\'+;
			  cFilePlan(cAnoUsr,cCodigoTgr),'PLA',NIL,lShared)
	     cError('ABRIENDO ARCHIVO DEL PLAN DE ESTUDIOS')
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatPro+'\'+;
		       CAP->cCodigoCar+ExtFile,'NOP',NIL,lShared)
	  cError('ABRIENDO ARCHIVO DE NOTAS DEL PROFESOR GRUPO '+cCodigoTgr)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1 .AND.;
	    PLA->(RECCOUNT()) == 0
	    cError('NO EXISTE REGISTROS DEL PLAN ACADEMICO')

       CASE NOP->(RECCOUNT()) == 0
	    cError('NO EXISTEN ESTUDIANTES DE '+ALLTRIM(CAP->cNombreMat)+;
		   ' DE '+cCodigoTgr)
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
       cSavPan := SAVESCREEN(0,0,24,79)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA MATERIA EN PLAN
       lMatVarMat(cCodigoTma,.F.)
       IF !('XXXX' $ cCodigoTgr) .AND. nTipPla == 1
	  IF !lLocCodigo('cCodigoMat','PLA',MAT->cCodigoMat)
	     cError('LA MATERIA: '+cCodigoTma+;
		     'NO EXISTE EN PLAN DE: '+cCodigoTgr)
	     CloseAll()
	     RETURN NIL
	  ENDIF
       ENDIF
       MAT->(DBGOTO(nRegMat))
*>>>>FIN LOCALIZACION DE LA MATERIA EN PLAN

*>>>>LECTURA DEL PERIODO
       SELECT NOP
       NOP->(DBGOTOP())
       nRegNoP = RECNO()
       nTotPer := TCO->nTotPerTbl
       nPerAct := IF(EMPTY(PRO->nNroPerPro),TCO->nPerActTbl,PRO->nNroPerPro)
       nNroPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,nTotPer,nPerAct,.T.)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
       cCamNot := 'NOP->cNotas'+STR(nNroPer,1,0)+'NoP'
       cCamInd := 'NOP->cIndic'+STR(nNroPer,1,0)+'NoP'
       cCamNtI := 'NOP->cIndnt'+STR(nNroPer,1,0)+'NoP'
       cCamDef := 'NOP->cDefin'+STR(nNroPer,1,0)+'NoP'
       cCamObs := 'NOP->cObsev'+STR(nNroPer,1,0)+'NoP'
*>>>>FIN LECTURA DEL PERIODO

*>>>>JUICIO VALORATIVO CALCULADO
       IF !lLocCodigo('cCodigoGru','GRU',cCodigoTgr,'DEL GRUPO')
	  CloseAll()
	  RETURN NIL
       ENDIF
       cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)
       cJvfCal := IF(MAT->lJvfCalMat,SPACE(03),cJvfCal)
       lJvfCal := IF(EMPTY(cJvfCal),.F.,.T.)
     *ÀNota: Para la materias variables no funciona
*>>>>FIN JUICIO VALORATIVO CALCULADO

*>>>>LECTURA DE INDICADORES Y NOTA DEFINITIVA
       IF !lJvfCal
	  Pendiente(aP1,aP2,aP3,;
		    cCodigoTgr,cCodigoTni,cNombreTma,;
		    @cIndica5,@cNotDef)
	  cNotInd5 := SPACE(160)
       ENDIF
*>>>>FIN LECTURA DE INDICADORES Y NOTA DEFINITIVA

*>>>>RECORRIDO POR NOTAS DEL PROFESOR
       SELECT NOP
       NOP->(DBGOTOP())
       DO WHILE .NOT. NOP->(EOF())

**********RETIRO DEL ESTUDIANTE
	   IF NOP->lRetiroNoP
	      SELECT NOP
	      NOP->(DBSKIP())
	      LOOP
	   ENDIF
**********FIN RETIRO DEL ESTUDIANTE

**********VALIDACION DEL REEMPLAZO
	    IF (!EMPTY(&cCamInd) .OR. !EMPTY(&cCamDef)) .AND. lRepite

	       cError('EXISTEN INDICADORES YA APLICADOS')

	       nNroOpc := nLeeOpcion('FAVOR SELECCIONE: '+;
				     '1<REEMPLAZAR> 2<BORRAR> '+;
				     '3<ABANDONAR>?',3,'0')

	       IF !lPregunta('DESEA QUE SE REPITA LA PREGUNTAR? Si No')
		  lRepite := .F.
	       ENDIF
	    ENDIF

	    IF nNroOpc == 3
	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DEL REEMPLAZO

**********BUSQUEDA DEL ESTUDIANTE
	    IF !lSekCodigo(NOP->cCodigoEst,cMaeAct)

	       cHayErr := 'NO EXISTE EL ESTUDIENTE EN MAESTRO DE '+cMaeAct
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aDetErr := {NOP->cCodigoEst,;       // C¢digo del Estudiante
			   '',;                    // Grupo
			   '',;                    // N£mero de lista
			   '',;                    // Nombre del Estudiante
			   cHayErr}                // Observaci¢n
	       AADD(aHayErr,aDetErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
	    cNombreTes = RTRIM(&cMaeAct->cApelliEst)+' '+;
			 RTRIM(&cMaeAct->cNombreEst)
	    cNombreTes := SUBS(cNombreTes+SPACE(40),1,40)
**********FIN BUSQUEDA DEL ESTUDIANTE

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathUno+'\'+cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			'NT'+&cMaeAct->cCodigoGru+cAnoSis+ExtFile,'NOT',NIL,lShared)
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      &cMaeAct->cCodigoGru)
	       CloseDbf('NOT')
	       EXIT
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********LOCALIZACION DEL ESTUDIANTE EN NOTAS
	    IF !lLocCodigo('cCodigoEst','NOT',NOP->cCodigoEst)

	       cHayErr := 'NO EXISTE EN EL ARCHIVO DE NOTAS'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aDetErr := {NOP->cCodigoEst,;       // C¢digo del Estudiante
			   &cMaeAct->cCodigoGru,;  // Grupo
			   NOP->(STR(RECNO(),2)),; // N£mero de lista
			   cNombreTes,;            // Nombre del Estudiante
			   cHayErr}                // Observaci¢n
	       AADD(aHayErr,aDetErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DEL ESTUDIANTE EN NOTAS

**********LOCALIZACION DETALLES DEL AREA O MATERIA
	    aDetMat := aLocAreMat(cCodigoTma,nNroPer)
	    IF LEN(aDetMat) == 0

	       cHayErr := 'NO EXISTE DETELLAS DE LA MATERIA DE NOTAS'
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aDetErr := {NOP->cCodigoEst,;       // C¢digo del Estudiante
			   &cMaeAct->cCodigoGru,;  // Grupo
			   NOP->(STR(RECNO(),2)),; // N£mero de lista
			   cNombreTes,;            // Nombre del Estudiante
			   cHayErr}                // Observaci¢n
	       AADD(aHayErr,aDetErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN LOCALIZACION DETALLES DEL AREA O MATERIA

**********DETALLES DEL AREA O MATERIA
	    aDbfMat := xPrm(aDetMat,'aDbfMat')
	    aDbfPla := xPrm(aDetMat,'aDbfPla')
	    aDbfNot := xPrm(aDetMat,'aDbfNot')
	    aMatSel := xPrm(aDetMat,'aMatSel')
**********FIN DETALLES DEL AREA O MATERIA

**********VALIDACION DE LA MATERIA
	    IF cCodigoTma # xPrm(aDbfMat,'cCodMat')

	       cHayErr := 'MATERIAS NOT COINCIDEN:'+;
			  cCodigoTma+':'+xPrm(aDbfMat,'cCodMat')
	       cHayErr := SUBS(cHayErr+SPACE(80),1,80)

	       aDetErr := {NOP->cCodigoEst,;       // C¢digo del Estudiante
			   &cMaeAct->cCodigoGru,;  // Grupo
			   NOP->(STR(RECNO(),2)),; // N£mero de lista
			   cNombreTes,;            // Nombre del Estudiante
			   cHayErr}                // Observaci¢n
	       AADD(aHayErr,aDetErr)

	       SELECT NOP
	       NOP->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA MATERIA

**********CALCULO DE LOS LOGROS PROMOCIONALES
	    IF cJvfCal == '301' .OR. cJvfCal == '302'

	       cIndica1 := &(xPrm(aDbfNot,'cIndica1'))
	       cIndica2 := &(xPrm(aDbfNot,'cIndica2'))
	       cIndica3 := &(xPrm(aDbfNot,'cIndica3'))
	       cIndica4 := &(xPrm(aDbfNot,'cIndica4'))
	     *ÀIndicadores

	       cIndica5 := &(xPrm(aDbfNot,'cIndica5'))
	       cIndica5 := SPACE(LEN(cIndica5))
	     *ÀBorra el Contenido

	       cNotInd1 := &(xPrm(aDbfNot,'cNotInd1'))
	       cNotInd2 := &(xPrm(aDbfNot,'cNotInd2'))
	       cNotInd3 := &(xPrm(aDbfNot,'cNotInd3'))
	       cNotInd4 := &(xPrm(aDbfNot,'cNotInd4'))
	     *ÀNotas de los Indicadores.

	       cNotInd5 := &(xPrm(aDbfNot,'cNotInd5'))
	       cNotInd5 := SPACE(LEN(cNotInd5))
	     *ÀBorra el Contenido

	       DO CASE
	       CASE cJvfCal == '301'
		    cNotDef := cNotSin301(SUBS(&cMaeAct->cCodigoGru,1,2)+'00',;
					  cCodigoTma,nTotPer,;
					  cIndica1,cIndica2,cIndica3,;
					  cIndica4,@cIndica5,;
					  cNotInd1,cNotInd2,cNotInd3,;
					  cNotInd4,@cNotInd5)

	       CASE cJvfCal == '302'
		    cNotDef := cNotSin302(SUBS(&cMaeAct->cCodigoGru,1,2)+'00',;
					  cCodigoTma,nTotPer,;
					  cIndica1,cIndica2,cIndica3,;
					  cIndica4,@cIndica5,;
					  cNotInd1,cNotInd2,cNotInd3,;
					  cNotInd4,@cNotInd5)
	       ENDCASE

	    ENDIF
**********FIN CALCULO DE LOS LOGROS PROMOCIONALES

**********VALIDACION DE LOS INDICADORES
	    IF cJvfCal == '301' .OR. cJvfCal == '302'

	       IF EMPTY(cIndica5)

		  cHayErr := 'NO LE FIGURAN ITEMS DE EVALUACION'
		  cHayErr := SUBS(cHayErr+SPACE(80),1,80)

		  aDetErr := {NOP->cCodigoEst,;       // C¢digo del Estudiante
			      &cMaeAct->cCodigoGru,;  // Grupo
			      NOP->(STR(RECNO(),2)),; // N£mero de lista
			      cNombreTes,;            // Nombre del Estudiante
			      cHayErr}                // Observaci¢n
		  AADD(aHayErr,aDetErr)

		  SELECT NOP
		  NOP->(DBSKIP())
		  LOOP

	       ENDIF

	    ENDIF
**********FIN VALIDACION DE LOS INDICADORES


**********GRABACION DEL REGISTRO
	    SELECT NOP
	    IF NOP->(lRegLock(lShared,.F.))

	       REPL &cCamInd WITH IF(nNroOpc==2,SPACE(LEN(cIndica5)),cIndica5)
	     *ÀIndicadores

	       REPL &cCamNtI WITH IF(nNroOpc==2,SPACE(LEN(cNotInd5)),cNotInd5)
	     *ÀNota de los Indicadores

	       REPL &cCamDef WITH IF(nNroOpc==2,SPACE(LEN(cNotDef)),cNotDef)
	     *ÀNota definitiva

	       REPL NOP->cNomUsrNop WITH cNomUsr
	       REPL NOP->dFecUsrNop WITH DATE()
	       REPL NOP->cHorUsrNop WITH TIME()

	       NOP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
	    ENDIF
	    IF lShared
	       NOP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********TOTAL DE INDICADORES
	    FOR i := 1 TO 20
		cCodInd := SUBS(cIndica5,i*6-5,6)
		IF !EMPTY(cCodInd)
		   IF i > nNroInd
		      nNroInd := i
		   ENDIF
		ENDIF
	    ENDFOR
**********FIN TOTAL DE INDICADORES

***********LINEA DE ESTADO
	     LineaEstado('GRUPO:'+cCodigoTgr+;
			 'ºNo. '+NOP->(STR(RECNO(),2))+'/'+;
				 NOP->(STR(RECCOUNT(),2))+;
			 'ºCODIGO:'+NOP->cCodigoEst+;
			 'ºNOTA:'+IF(nNroOpc==2,SPACE(04),cNotDef)+;
			 'ºMATERIA:'+SUBS(cNombreTma,1,25),cNomSis)
***********FIN LINEA DE ESTADO

	  NOP->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR NOTAS DEL PROFESOR

*>>>>GRABACION DEL REGISTRO
       SELECT CAP
       IF CAP->(lRegLock(lShared,.F.))
	  REPL CAP->cNroIndCaP WITH STUFF(CAP->cNroIndCaP,nNroPer*2-1,2,;
				    STR(nNroInd,2,0))
	  CAP->(DBCOMMIT())
       ELSE
	  cError('NO SE GRABA EL NUMERO DE INDICADORES')
       ENDIF
       IF lShared
	  CAP->(DBUNLOCK())
       ENDIF
*>>>>FIN GRABACION DEL REGISTRO

*>>>>INFORME DE ERRORES
       IF LEN(aHayErr) # 0

	  cError('EXISTEN INCONSISTENCIAS',;
		 'ATENCION','PREPARE LA IMPRESORA')

	  aP3 := {}
	  AADD(aP3,{'cOpcPrn',SPR->cOpcPrnSpr})
	  AADD(aP3,{'cUsrIso',SPR->cUsrIsoSpr})
	  AADD(aP3,{'cPieTre',SPR->cPiePagSpr})

	  aTitIso := {}
	  AADD(aTitIso,cCodigoTma+':'+ALLTRIM(cNombreTma))   // T¡tulo Uno
	  AADD(aTitIso,'ERRORES DE LA GRABACION POR GRUPO')  // T¡tulo Dos
	  AADD(aTitIso,'GRUPO:'+cConverNiv(SUBS(cCodigoTgr,1,2))+;
			SUBS(cCodigoTgr,3,2)+' '+;
			'A¥O:<cAnoUsr> JORNADA:<cJorTxt>'+' '+;
			'PERIODO No.'+STR(nNroPer,1))        // T¡tulo Tres
	*ÀT¡tulo del Informe

	  AADD(aP3,{'aTitIso',aTitIso})
	  AADD(aP3,{'aHayErr',aHayErr})


	  SPR_26100(aP1,aP2,aP3)
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>FIN INFORME DE ERRORES


******************************

FUNCTION Pendiente(aP1,aP2,aP3,cCodGru,cCodNiv,cNomMat,cIndica,cNotDef)

*>>>>DESCRIPCION DE PARAMETROS
/*     aP1                                  // Parametros Generales
       aP2                                  // Parametros Generales
       aP3                                  // Parametros Generales
       cIndica                              // Indicadores a Aplicar
       cNotDef                              // Nota Definitiva */
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

       LOCAL cMaeAlu := xPrm(aP1,'cMaeAlu') // Maestros habilitados
       LOCAL cMaeAct := xPrm(aP1,'cMaeAct') // Maestro Activo
       LOCAL cJorTxt := xPrm(aP1,'cJorTxt') // Jornada escogida
     *ÀDetalles Acad‚micos

       LOCAL nFilPal := xPrm(aP1,'nFilPal') // Fila Inferior Men£ principal
       LOCAL nFilInf := xPrm(aP1,'nFilInf') // Fila Inferior del SubMen£
       LOCAL nColInf := xPrm(aP1,'nColInf') // Columna Inferior del SubMen£
     *ÀDetalles Tecnicos
*>>>>FIN DECLARACION PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cSavLin := ''                  // Salvar Linea
       LOCAL lHayErr := .F.                 // .T. Hay Error
     *ÀVariables generales

       LOCAL     i,j := 0                   // Contador
       LOCAL lAnoAct := .T.                 // .T. A¤o Actual

       LOCAL nFilSup := 0                   // Columna Superior
       LOCAL nColSup := 0                   // Columna Superior
       LOCAL nInfFil := 0                   // Fila Inferior
       LOCAL nInfCol := 0                   // Columna Inferior

       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura

       LOCAL nFilIni := 0                   // Fila Inicial
       LOCAL nColIni := 0                   // Columna Inicial

       LOCAL lIndNiv := .F.                 // .T. Indicadores de Nivel
       LOCAL cEvaInd := ''                  // Evaluar el Indicador
       LOCAL lHayNot := .F.                 // .T. Hay nota definitiva
       LOCAL lNotNum := .F.                 // .T. Nota N£merica .F. Nota Cualitativa
       LOCAL cValNot := ''                  // Validaci¢n de la nota

       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£
       LOCAL nOpcion := 0                   // Opci¢n del men£
       LOCAL nRegNoP := 0                   // Registro notas del profesor

       LOCAL nTotPer := 5                   // Total de Periodos
       LOCAL nPerAct := 0                   // Periodo Actual
       LOCAL nNroPer := 0                   // N£mero del periodo
       LOCAL cCamNot := ''                  // Campo de las notas
       LOCAL cCamInd := ''                  // Campo de los indicadores. Marca Error el la Macro al declararse local
       LOCAL cCamNtI := ''                  // Campo de Nota de Indicadores
       LOCAL cCamDef := ''                  // Campo de definitivas
       LOCAL cCamObs := ''                  // Campo de Observaciones

       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL aLenNom := {}                  // Longitud de nombres
       LOCAL nLenNom := 0                   // Longitud del nombre
       LOCAL nTotInd := 20                  // Total de Indicadores
       LOCAL nNroInd := 0                   // N£mero de indicadores
       LOCAL nIndMin := 0                   // Indicador M¡nimo para control
       LOCAL nNroLog := 1                   // N£mero de logro escogido
       LOCAL lRepite := .F.                 // .T. Repiter la pregunta
       LOCAL lSiorNo := .F.                 // .T. Repetir la pregunta
       LOCAL lGrabar := .T.                 // .T. Grabar el registro
       LOCAL nNroLec := 0                   // N£mero de logro leidos
       LOCAL cLogros := ''                  // Logros aplicados
       LOCAL cNotInd := ''                  // Nota de los Indicadores
       LOCAL cCodOld := ''                  // Logro leido
       LOCAL cCodNew := ''                  // Logro a reemplazar
       LOCAL cMsgTxt := ''                  // Texto variable
       LOCAL nRegMat := 0                   // Registro de la Materia
       LOCAL nLenInd := 6                   // Longitud del C¢digo
       LOCAL nLenNtI := 8                   // Longitud del C¢digo de la Nota de la Recuperaci¢n del Indicador
       LOCAL nTipPla := 0                   // Tipo del Plan
       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado
       LOCAL lJvfCal := .F.                 // .T. Juicio Valorativo Calculado
       LOCAL lRetiro := .F.                 // .T. Retirado
       LOCAL GetList := {}                  // Variable del Sistema
     *ÀVariables espec¡ficas 
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL INDICADORES
       nNroInd := nLeeNroInd(lShared,nFilInf+1,nColInf,nNroPer,nTotInd)
       IF nNroInd == 0
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DEL INDICADORES

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lIndNiv := TCO->lIndNivTbl

       cEvaInd := SUBS(TCO->cEvaIndTbl,nNroPer,1)
       lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)

       IF TCO->lNotPlaTbl
	  IF !('XXXX' $ cCodGru)
	     lHayNot := IF(SUBS(PLA->cHayNotPla,nNroPer,1)='1',.T.,.F.)
	  ENDIF
       ELSE
	  lHayNot := IF(SUBS(TCO->cHayNotTbl,nNroPer,1)='1',.T.,.F.)
       ENDIF

       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       IF lNotNum
	  cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
       ELSE
	  IF EMPTY(TCO->cValNumTbl)
	     cValNot := ALLTRIM(TCO->cValNotTbl)+SPACE(01)
	  ELSE
	     cValNot := ALLTRIM(TCO->cValNumTbl)+SPACE(01)
	  ENDIF
       ENDIF

       IF cEvaInd == '2'
	  cEvaInd := '0'
	  lHayNot := .F.
       ENDIF
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

lHayNot := .T.
lNotNum := .T.

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(nFilPal+1,ALLTRIM(cNomMat),22,'°')
       @ nNroFil,01 SAY 'NRO'
       @ nNroFil,05 SAY 'NOMBRE'
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>DETERMINACION DE COLS Y LONGITUD DE NOMBRE
       IF lHayNot
	  aNroCol := {32,26,20,14,32}
	  aLenNom := {26,20,13,08,26}
       ELSE
	  aNroCol := {37,31,25,19,37}
	  aLenNom := {31,25,18,13,31}
       ENDIF

       nIndMin := IF(nNroInd >10,10,nNroInd)
       nNroCol := IF(nIndMin < 7,aNroCol[5],aNroCol[nIndMin-6])
      *Escoge la columna seg£n el n£mero de notas

       nLenNom := IF(nIndMin < 7,aLenNom[5],aLenNom[nIndMin-6])
      *Escoge la longitud del nombre

       nFilIni := 06
       nColIni := nNroCol
       nNroFil := nFilIni
*>>>>FIN DETERMINACION DE COLS Y LONGITUD DE NOMBRE

*>>>>SELECION DE LAS NOTAS A GRABAR
       cSavLin := SAVESCREEN(21,0,22,79)
       Centrar('<ESC> Graba Horizontalmente. '+;
	       '<ENTER> Graba Verticalmente seg£n la elecci¢n',21)
       i := 1
       DO WHILE i <= nIndMin
	  @ nNroFil,nNroCol PROMPT IF(i<10,'INDI','IND')+LTRIM(STR(i))
	  i++
	  nNroCol := nNroCol + 6
       ENDDO
       MENU TO nNroLog

       IF lHayNot
	  @ nNroFil,nNroCol SAY IF(lNotNum,'NOTA','JUIC')
       ENDIF

       nNroCol = nNroCol - (i-1)*6
       nNroFil = nNroFil + 1
      *Ubica la fila primera de grabacion

       RESTSCREEN(21,0,22,79,cSavLin)
*>>>>FIN SELECION DE LAS NOTAS A GRABAR

*>>>>DETERMINACION DE LA COLUNA DE CAPTURA
       IF nNroLog # 0
	  nNroCol := nColIni + (nNroLog-1)*6
       ENDIF
*>>>>FIN DETERMINACION DE LA COLUNA DE CAPTURA

*>>>>CAPTURA Y VALIDACION DE LOS LOGROS
       cLogros := SUBS(SPACE(120),1,nNroInd*nLenInd)

       cNotDef := SPACE(04)

       IF !lLeeLogro(cNomSis,@nNroFil,nColIni,nNroPer,lIndNiv,;
		     cEvaInd,cCodGru,cCodNiv,nNroInd,;
		     nNroLog,@cLogros,cNotInd,lHayNot,lNotNum,;
		     @cNotDef,cValNot,cSavLin)
	  RETURN NIL
       ENDIF

       IF !lPregunta('DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA Y VALIDACION DE LOS LOGROS

*>>>>CALCULO DEL INDICADOR SELECCIONADO REEMPLAZAR
       IF nNroLog # 0
	  cLogros := SUBS(cLogros,nPosIni(nNroLog,nLenInd),nLenInd)
       ENDIF
*>>>>FIN CALCULO DEL INDICADOR SELECCIONADO REEMPLAZAR

*>>>>CALCULO DE LOS LOGROS A REEMPLAZAR
       nNroLec := nNroInd
       IF !EMPTY(cLogros)
	  nNroLec := ROUND(LEN(RTRIM(cLogros))/nLenInd,0)   // No permite borrar indicadores ya aplicados
	  nNroLec := ROUND(LEN(cLogros)/nLenInd,0)
	  cLogros := SUBS(cLogros,1,nNroLec*nLenInd)
       ENDIF
       IF nNroLog == 0
	  nNroLog := 1
       ENDIF
       cIndica := cLogros
       RETURN NIL
*>>>>FIN CALCULO DE LOS LOGROS A REEMPLAZAR