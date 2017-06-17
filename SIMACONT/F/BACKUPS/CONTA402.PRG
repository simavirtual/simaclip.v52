/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : ESTADISTICAS
SUBMODULO...: POR MATERIAS

**************************************************************************
* TITULO..: ESTADISTICAS DE RENDIMIENTO                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 11/2005 MAR A
       Colombia, Bucaramanga        INICIO: 03:00 PM   OCT 11/2005 MAR

OBJETIVOS:

1- Calcula las estad¡sticas por materia

2- Retorna Nil

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_402(aParam1,aParam2,aParam3)

*>>>>DESCRIPCION DE PARAMETROS
/*     aParam1                              // Parametros Generales
       aParam2                              // Parametros Generales
       aParam3                              // Parametros Generales */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL     i,j := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql

       LOCAL nTotPer := 0                   // Total Periodos
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruIni := ''                  // C¢digo del grupo inicial
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL aStdMat := {}                  // Estadisticas de las Materias
       LOCAL aCodMat := {}                  // C¢digo de la Materia

       MEMVA xClrSys			    // Color del Sistema
       LOCAL GetList := {}                  // Variable del Sistema

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL nTotIndTst := 0                // Total Indicadores
       LOCAL nIndiSiTst := 0                // Indicadores Aprobados
       LOCAL nIndiNoTst := 0                // Indicadores Reprobados
       LOCAL nTotEstTst := 0                // Total de Estudiante
       LOCAL cNotDefTst := ''               // Nota Definitiva
       LOCAL nTotNotTst := 0                // Total de Estudiantes
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

*>>>>CREACION DE LAS ESTRUCTURAS
       CreaDbfStd(lShared,nModCry,cPatSis,FileStd)
       CloseAll()
*>>>>FIN CREACION DE LAS ESTRUCTURAS

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'CON',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FConAno+cAnoUsr+ExtFile,'COA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+;
			 FileStd,'STD',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileEva,'EVA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuN,'SUN',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSuG,'SUG',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSel+cMaeAct+ExtFile,'SEL',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
		       FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
		       cPatSis+'\'+cMaeAct+'\'+;
		       fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE CON->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE lHayJvfTco() .AND. JVF->(RECCOUNT()) == 0
	    cError('NO EXISTEN JUICIOS VALORATIVOS GRAGADOS PARA '+cMaeAct)

       CASE lHayItvTco() .AND. !lHayItvJvf()
	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',CON->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lPrnArc := CON->lPrnArcCon
       nCodPrn := CON->nCodigoPrn
       cOpcPrn := CON->cOpcPrnCon
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>LECTURA DEL PERIODO
       nTotPer := nLeeNroPer(nFilInf+1,nColInf,nFilPal,;
			     TCO->nTotPerTbl)
       IF nTotPer == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL PERIODO

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin := GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			 cFilePlan(cAnoUsr,GRU->cCodigoGru),;
			 'PLA',NIL,lShared)

		SET DEVICE TO SCREEN
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

	       SET DEVICE TO SCREEN
	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' EN '+cPatSis+'\NOTAS')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********RECORRIDO POR PERIODOS
	    FOR nNroPer := 1 TO nTotPer

*===============ESTADISTICA DEL GRUPO
		  aStdMat := {}
		  aCodMat := {}

		  TotNotGru(cNomSis,nNroPer,GRU->cCodigoGru,@aCodMat,@aStdMat)
*===============FIN ESTADISTICA DEL GRUPO

*===============GRABACION DE LAS ESTADISTICAS
		  FOR i := 1 TO LEN(aCodMat)

*:::::::::::::::::::::GRABACION DEL REGISTRO
			FOR j := 1 TO LEN(aStdMat)

			    LineaEstado('ºPERIODO: '+STR(nNroPer,2)+;
					'ºGRUPO: '+GRU->cCodigoGru+;
					'ºMATERIA: '+aCodMat[i,1]+;
					'º No. '+ALLTRIM(STR(i,4))+'/'+;
						 ALLTRIM(STR(LEN(aStdMat),4)),cNomSis)

			    SELECT STD
			    IF STD->(lRegLock(lShared,.T.))

			       cCodigoTma := aCodMat[i,1]
			       cCodigoTpr := aCodMat[i,5]

			       nTotIndTst := aCodMat[i,2]
			       nIndiNoTst := aCodMat[i,3]
			       nIndiSiTst := nTotIndTst - nIndiNoTst

			       nTotEstTst := aCodMat[i,4]
			       cNotDefTst := aStdMat[j,1]
			       nTotNotTst := aStdMat[j,i+2]

			       REPL STD->cCodigoGru WITH GRU->cCodigoGru
			       REPL STD->cCodigoMat WITH cCodigoTma
			       REPL STD->nNroPerStd WITH nNroPer

			       REPL STD->nTotIndStd WITH nTotIndTst
			       REPL STD->nIndiSiStd WITH nIndiSiTst
			       REPL STD->nIndiNoStd WITH nIndiNoTst
			       REPL STD->nTotEstStd WITH nTotEstTst

			       REPL STD->cNotDefStd WITH cNotDefTst
			       REPL STD->nTotNotStd WITH nTotNotTst
			       REPL STD->cCodigoPro WITH cCodigoTpr

			       REPL STD->nIdeCodStd WITH STD->(RECNO())
			       REPL STD->cNomUsrStd WITH cNomUsr
			       REPL STD->dFecUsrStd WITH DATE()
			       REPL STD->cHorUsrStd WITH TIME()

			       STD->(DBCOMMIT())
			    ELSE
			       cError('NO SE GRABA EL REGISTRO')
			    ENDIF

			    IF lShared
			       STD->(DBUNLOCK())
			    ENDIF

			ENDFOR
*:::::::::::::::::::::FIN GRABACION DEL REGISTRO

		  ENDFOR
*===============FIN GRABACION DE LAS ESTADISTICAS

*===============ESTADISTICA DE LAS MATERIAS SELECTIVAS
		  aStdMat := {}
		  aCodMat := {}
		  TotMatVar(lShared,cNomSis,cAnoUsr,cPatSis,;
			    cMaeAct,nNroPer,GRU->cCodigoGru,;
			    @aCodMat,@aStdMat)
*===============FIN ESTADISTICA DEL GRUPO

*===============GRABACION DE LAS ESTADISTICAS
		  FOR i := 1 TO LEN(aCodMat)

*:::::::::::::::::::::GRABACION DEL REGISTRO
			FOR j := 1 TO LEN(aStdMat)

			    SELECT STD
			    IF STD->(lRegLock(lShared,.T.))

			       cCodigoTma := aCodMat[i,1]
			       cCodigoTpr := aCodMat[i,5]

			       nTotIndTst := aCodMat[i,2]
			       nIndiNoTst := aCodMat[i,3]
			       nIndiSiTst := nTotIndTst - nIndiNoTst

			       nTotEstTst := aCodMat[i,4]
			       cNotDefTst := aStdMat[j,1]
			       nTotNotTst := aStdMat[j,i+2]

			       REPL STD->cCodigoGru WITH GRU->cCodigoGru
			       REPL STD->cCodigoMat WITH cCodigoTma
			       REPL STD->nNroPerStd WITH nNroPer

			       REPL STD->nTotIndStd WITH nTotIndTst
			       REPL STD->nIndiSiStd WITH nIndiSiTst
			       REPL STD->nIndiNoStd WITH nIndiNoTst
			       REPL STD->nTotEstStd WITH nTotEstTst

			       REPL STD->cNotDefStd WITH cNotDefTst
			       REPL STD->nTotNotStd WITH nTotNotTst
			       REPL STD->cCodigoPro WITH cCodigoTpr

			       REPL STD->nIdeCodStd WITH STD->(RECNO())
			       REPL STD->cNomUsrStd WITH cNomUsr
			       REPL STD->dFecUsrStd WITH DATE()
			       REPL STD->cHorUsrStd WITH TIME()

			       STD->(DBCOMMIT())
			    ELSE
			       cError('NO SE GRABA EL REGISTRO')
			    ENDIF

			    IF lShared
			       STD->(DBUNLOCK())
			    ENDIF

			ENDFOR
*:::::::::::::::::::::FIN GRABACION DEL REGISTRO

		  ENDFOR
*===============FIN ESTADISTICA DE LAS MATERIAS SELECTIVAS

	    ENDFOR
**********FIN RECORRIDO POR PERIODOS

**********AVANCE AL SIGUIENTE REGISTRO
	    CloseDbf('NOT')
	    CloseDbf('PLA')
	    SELECT GRU
	    GRU->(DBSKIP())
**********FIN AVANCE AL SIGUIENTE REGISTRO

       ENDDO
       lModReg := CON->lPruebaCon
       CloseAll(aUseDbf)
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>ORDENACION DEL ARCHIVO
       IF !lOrdFile(lShared,cPatSis+'\'+FileStd,;
		    'cCodigoMat','nNroPerStd','cNotDefStd')
	  cError('NO SE ORDENO EL ARCHIVO')
       ENDIF
*>>>>FIN ORDENACION DEL ARCHIVO

*>>>>AREAS DE TRABAJO
       aArchvo := {}
       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
       AADD(aArchvo,{cPatSis+'\'+FileStd,NIL,'STD'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FConTbl+cMaeAct+ExtFile,NIL,'TCO'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+FileMat,NIL,'MAT'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileJvf+ExtFile,NIL,'JVF'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileNiv+cAnoSis+ExtFile,NIL,'NIV'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileGru+cMaeAct+cAnoSis+ExtFile,NIL,'GRU'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileSuN,NIL,'SUN'})
       AADD(aArchvo,{cPatSis+'\'+cMaeAct+'\'+;
		     FileSuG,NIL,'SUG'})
*>>>>FIN AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       lDelReg := .F.
       lInsReg := .F.
       lHaySql := .F.

       MantenStd(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
		 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
		 aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
		 lModReg,lDelReg,lInsReg,lHaySql,;
		 cPatSis,cMaeAct)

       CloseAll()
       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: TOTAL DE JUICIOS VALORATIVOS Y DIFICULTADES DEL GRUPO        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: OCT 12/2005 MIE A
       Colombia, Bucaramanga        INICIO: 02:00 PM   OCT 12/2005 MIE

OBJETIVOS:

1- Totaliza el juicio valorativo de cada grupo

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION TotNotGru(cNomSis,nNroPer,cCodGru,aCodMat,aStdMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del Grupo
       aCodMat                              // C¢digo de Materias
       aStdMat                              // @Estadistica de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i,j,k,y,x := 0                 // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aStdJui := {}                  // Estadisticas de Juicios Valorativos
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL nTotEst := 0                   // Total de Estudiantes
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>ENCABEZADOS DE COLUMNA
       aCodMat := {}

       aStdJui := {}
       AADD(aStdJui,'')   // C¢digo del Juicio
       AADD(aStdJui,'')   // Nombre del Juicio

       FOR i:=1 TO LEN(aNotAre)

**********ANALISIS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*==============ANALISIS DE LA MATERIA NO IMPRIMIR
		 cCodigoTma := SUBS(aNotAre[i,6],9,4)
		 IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
		    SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
		    LOOP
		 ENDIF
		 cCodigoTpr := &('PLA->cPr'+cCodGru+'Pla')
*==============FIN ANALISIS DE LA MATERIA NO IMPRIMIR

	       AADD(aStdJui,0)   // Total del Jvf
	       AADD(aCodMat,{cCodigoTma,0,0,0,cCodigoTpr})

	    ENDIF
**********FIN ANALISIS DEL AREA

**********ANALISIS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*=================ANALISIS DE LA MATERIA NO IMPRIMIR
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
		       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
		       LOOP
		    ENDIF
		    cCodigoTpr := &('PLA->cPr'+cCodGru+'Pla')
*=================FIN ANALISIS DE LA MATERIA NO IMPRIMIR

		  AADD(aStdJui,0)
		  AADD(aCodMat,{cCodigoTma,0,0,0,cCodigoTpr})

	       ENDIF

	    ENDFOR
**********FIN ANALISIS DE LA MATERIA

       ENDFOR
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       lHayItv := lHayItvJvf()
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>LECTURA DE LOS JUICIOS VALORATIVOS
       aStdMat := {}

       SELECT JVF
       JVF->(DBGOTOP())
       DO WHILE .NOT. JVF->(EOF())
	  aStdJui[1] := JVF->cCodigoJvf
	  aStdJui[2] := JVF->cNombreJvf
	  AADD(aStdMat,ACLONE(aStdJui))
	  JVF->(DBSKIP())
       ENDDO
       aStdJui[1] := 'SN'
       aStdJui[2] := 'SIN JUICIO'
       aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
       AADD(aStdMat,ACLONE(aStdJui))

       aStdJui[1] := '?'
       aStdJui[2] := 'OTRO'
       aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
       AADD(aStdMat,ACLONE(aStdJui))
*>>>>FIN LECTURA DE LOS JUICIOS VALORATIVOS

*>>>>IMPRESION DEL CUERPO DEL INFORME
       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO
	    IF NOT->lRetGruNot
	       SELECT NOT
	       NOT->(DBSKIP())
	       LOOP
	    ENDIF
	    nTotEst++
**********FIN ANALISIS SI EL ESTUDIANTE ESTA RETIRADO DEL GRUPO

**********RECORRIDO POR AREAS
	    y := 0
	    FOR i:=1 TO LEN(aNotAre)

*==============DETALLES DEL AREA
		 IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*-------------------ANALISIS DE LA AREA NO IMPRIMIR
		      cCodigoTma := SUBS(aNotAre[i,6],9,4)
		      IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
			 SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
			 LOOP
		      ENDIF
*-------------------FIN ANALISIS DE LA AREA NO IMPRIMIR

*-------------------NOTAS DEL AREA
		      cCamNotDef := aNotAre[i,4]
			 cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			 cNotDef := cNotDef(cNotDef,lNotNum)
		     *ÀNota del Periodo

		      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
			 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
		    *ÀNota de Recuperaci¢n del Periodo
*-------------------FIN NOTAS DEL AREA

*-------------------INDICADORES DEL AREA
		      nNroDif := 0
		      cCamInd := aNotAre[i,6]

		      cCamInd := STUFF(cCamInd,8,1,STR(nNroPer,1))
		      cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
		    *ÀIndicadores del Periodo

		      cSiRecu := ''
		      cNoRecu := ''
		      IF !aNotAre[i,15]   // Recuperable
			 IndRecSiNo(cJuicio,lEvaInd,;
				    @cSiRecu,@cNoRecu,.F.)

		      ENDIF
		    *ÀIndicadores recuperados y por recuperar
*-------------------FIN INDICADORES DEL AREA

*-------------------TOTALIZACION DEL JUICIO VALORATIVO
		      y++
		      IF !EMPTY(cNotRec)
			 cNotDef := cNotRec
		      ENDIF

		      IF EMPTY(cNotDef)
			 cNotDef := 'SN'
		      ENDIF

		      k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
		      IF k # 0
			 aStdMat[k,y+2]++
		      ELSE
			 aStdMat[LEN(aStdMat),y+2]++
		      ENDIF
*-------------------FIN TOTALIZACION DEL JUICIO VALORATIVO

*-------------------TOTAL DE INDICADORES
		      aCodMat[y,2] += LEN(aJuicio(@cJuicio,;
						  TCO->lNoSortTbl))
		    *ÀTotal de Indicadores

		      aCodMat[y,3] += LEN(aJuicio(@cNoRecu,;
						  TCO->lNoSortTbl))
		    *ÀIndicadores no aprobados

		      aCodMat[y,4]++
		    *ÀTotal de Estudiantes
*-------------------FIN TOTAL DE INDICADORES

		 ENDIF
*==============FIN DETALLES DEL AREA

*==============RECORRIDO POR MATERIAS
		 FOR j := 1 TO LEN(aNotMat)

*-------------------DETALLES DE LA MATERIA
		      IF aNotAre[i,2] == aNotMat[j,1]


*::::::::::::::::::::::::IMPRESION DE LA LINEA DE ESTADO
			   LineaEstado('PERIODO: '+STR(nNroPer,2)+;
				      'ºGRUPO: '+GRU->cCodigoGru+;
				      'ºMATERIA:'+SUBS(aNotMat[j,5],9,4)+;
				      'º No. '+NOT->(STR(RECNO(),2))+'/'+;
				       NOT->(STR(RECCOUNT(),2)),cNomSis)
*::::::::::::::::::::::::FIN IMPRESION DE LA LINEA DE ESTADO

*::::::::::::::::::::::::ANALISIS DE LA MATERIA NO IMPRIMIR
			   cCodigoTma := SUBS(aNotMat[j,5],9,4)
			   IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
			      SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
			      LOOP
			   ENDIF
*::::::::::::::::::::::::FIN ANALISIS DE LA MATERIA NO IMPRIMIR

*::::::::::::::::::::::::NOTAS DE LA MATERIA
			   cCamNotDef := aNotMat[j,4]
			      cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
			      cNotDef := cNotDef(cNotDef,lNotNum)
			  *ÀNota del Periodo

			   IF TCO->nTotPerTbl == nNroPer .AND.;
			      SUBS(cCodigoTma,3,2) # '00'

			      cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
				 cNotRec := SUBS(&cCamNotRec,1,4)

			   ELSE
			      cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
				 cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
			   ENDIF
			 *ÀNota de Recuperaci¢n del Periodo
*::::::::::::::::::::::::FIN NOTAS DE LA MATERIA

*::::::::::::::::::::::::INDICADORES DE LA MATERIA
			   nNroDif := 0
			   cCamInd := aNotMat[j,5]

			   cCamInd := STUFF(cCamInd,8,1,STR(nNroPer,1))
			   cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
			 *ÀIndicadores del Periodo

			   cSiRecu := ''
			   cNoRecu := ''
			   IF !aNotMat[j,15]  // No Recuperable
			      IndRecSiNo(cJuicio,lEvaInd,;
					 @cSiRecu,@cNoRecu,.F.)
			   ENDIF
			 *ÀIndicadores recuperados y por recuperar
*::::::::::::::::::::::::FIN INDICADORES DE LA MATERIA

*::::::::::::::::::::::::TOTALIZACION DEL JUICIO VALORATIVO
			   y++
			   IF !EMPTY(cNotRec)
			      cNotDef := cNotRec
			   ENDIF
			   IF EMPTY(cNotDef)
			      cNotDef := 'SN'
			   ENDIF
			   k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
			   IF k # 0
			      aStdMat[k,y+2]++
			   ELSE
			      aStdMat[LEN(aStdMat),y+2]++
			   ENDIF
*::::::::::::::::::::::::FIN TOTALIZACION DEL JUICIO VALORATIVO

*::::::::::::::::::::::::TOTAL DE INDICADORES
			   aCodMat[y,2] += LEN(aJuicio(@cJuicio,;
						       TCO->lNoSortTbl))
			 *ÀTotal de Indicadores

			   aCodMat[y,3] += LEN(aJuicio(@cNoRecu,;
						       TCO->lNoSortTbl))
			 *ÀIndicadores no aprobados

			   aCodMat[y,4]++
			 *ÀTotal de Estudiantes
*::::::::::::::::::::::::FIN TOTAL DE INDICADORES

		      ENDIF
*-------------------FIN DETALLES DE LA MATERIA

		 ENDFOR
*==============FIN RECORRIDO POR MATERIAS

	    ENDFOR
**********FIN RECORRIDO POR AREAS

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RETURN NIL
*>>>>FIN IMPRESION DEL CUERPO DEL INFORME

/*************************************************************************
* TITULO..: MATERIAS A IMPRIMIR DEL PERIODO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2007 LUN A
       Colombia, Bucaramanga        INICIO: 09:30 AM   ABR 02/2007 LUN

OBJETIVOS:

1- Lee los c¢digos de las areas o materias que se deben imprimir en el
   boletin del respectivo periodo.

2- Retorna los c¢digos de las areas o materias a imprimir.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aMatPrnPer(lShared,cAnoUsr,cPatSis,cMaeAct,cCodGru,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro habilitado
       cCodGru                              // C¢digo del Grupo
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL     i,j := 0                   // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aMatPrn := {}                  // Materias a Imprimir

       LOCAL cCodigoTma := ''               // C¢digo de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
		   cFilePlan(cAnoUsr,cCodGru),;
		   'PLA',NIL,lShared) .OR.;
	  !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
		       'NT'+cCodGru+cAnoSis+ExtFile,;
		       'NOT',NIL,lShared)

	  CloseDbf('PLA')
	  CloseDbf('NOT')
	  RETURN aMatPrn
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS
       aNotAre := {}
       aNotMat := {}
       DetAreas(@aNotAre,@aNotMat,nNroPer)
*>>>>FIN DEFINICION DE LOS DETALLES DE LAS AREAS Y MATERIAS

*>>>>RECORRIDO POR AREAS
       FOR i:=1 TO LEN(aNotAre)

**********ANALISIS DEL AREA
	    IF SUBS(aNotAre[i][4],7,4) == 'AREN'

*==============ANALISIS DEL AREA NO IMPRIMIR
		 cCodigoTma := SUBS(aNotAre[i,6],9,4)
		 IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
		    SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
		    LOOP
		 ENDIF
*==============FIN ANALISIS DEL AREA NO IMPRIMIR

	       AADD(aMatPrn,{cCodigoTma,''})

	    ENDIF
**********FIN ANALISIS DEL AREA

**********ANALISIS DE LA MATERIA
	    FOR j:=1 TO LEN(aNotMat)

	       IF aNotAre[i,2] == aNotMat[j,1]

*=================ANALISIS DE LA MATERIA NO IMPRIMIR
		    cCodigoTma := SUBS(aNotMat[j,5],9,4)
		    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
		       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'
		       LOOP
		    ENDIF
*=================FIN ANALISIS DE LA MATERIA NO IMPRIMIR

		  AADD(aMatPrn,{cCodigoTma,''})

	       ENDIF

	    ENDFOR
**********FIN ANALISIS DE LA MATERIA

       ENDFOR
*>>>>FIN RECORRIDO POR AREAS

*>>>>MATERIAS VARIABLES POR GRUPO
       SUG->(DBGOTOP())
       DO WHILE .NOT. SUG->(EOF())

**********ANALISIS DE LA MATERIA NO IMPRIMIR
	    lMatVarMat(SUG->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
	    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
	       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'

	       SUG->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE LA MATERIA NO IMPRIMIR

**********ANALISIS DE DECISION
	    IF SUG->cCodigoGru == cCodGru
	       AADD(aMatPrn,{SUG->cCodigoMat,SUG->cCodigoPro})
	    ENDIF
**********FIN ANALISIS DE DECISION

	  SUG->(DBSKIP())

       ENDDO
*>>>>FIN MATERIAS VARIABLES POR GRUPO

*>>>>MATERIAS VARIABLES POR NIVEL
       SUN->(DBGOTOP())
       DO WHILE .NOT. SUN->(EOF())

**********ANALISIS DE LA MATERIA NO IMPRIMIR
	    lMatVarMat(SUN->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
	    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
	       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'

	       SUN->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE LA MATERIA NO IMPRIMIR

**********ANALISIS DE DECISION
	    IF SUN->cCodigoNiv == SUBS(cCodGru,1,2)
	       AADD(aMatPrn,{SUN->cCodigoMat,SUN->cCodigoPro})
	    ENDIF
**********FIN ANALISIS DE DECISION

	  SUN->(DBSKIP())

       ENDDO
       CloseDbf('PLA')
       CloseDbf('NOT')
       aMatPrn := ASORT(aMatPrn,,,{|x,y|x[1] < y[1]})
       RETURN aMatPrn
*>>>>FIN MATERIAS VARIABLES POR NIVEL



/*************************************************************************
* TITULO..: ESTADISTICA POR MATERIAS DEL PERIODO                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 29/2007 MAR A
       Colombia, Bucaramanga        INICIO: 10:13 AM   MAR 29/2007 MAR

OBJETIVOS:

1- Lee las estadisticas de una materia del grupo y del periodo

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aStdMatPer(cCodGru,nNroPer,cCodMat,cCodPro)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodGru                              // C¢digo del Grupo
       nNroPer                              // N£mero del Periodo
       cCodMat                              // C¢digo de la Materia
       cCodPro                              // C¢digo del Profesor */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       k := 0
       LOCAL nJuiSAp := 0
       LOCAL nJuiNAp := 0
       LOCAL aStdMat := {}                  // Estadistica de la materia
*>>>>FIN DECLARACION DE VARIABLES

*>>>>FILTRACION DEL ARCHIVO
       SELECT STD
       IF EMPTY(cCodPro)
	  SET FILTER TO STD->cCodigoGru == cCodGru .AND.;
			STD->nNroPerStd == nNroPer .AND.;
			STD->cCodigoMat == cCodMat
       ELSE
	  SET FILTER TO STD->cCodigoGru == cCodGru .AND.;
			STD->nNroPerStd == nNroPer .AND.;
			STD->cCodigoMat == cCodMat .AND.;
			STD->cCodigoPro == cCodPro
       ENDIF

       STD->(DBGOTOP())
       IF STD->(EOF())
	  SET FILTER TO
	  RETURN NIL
       ENDIF
*>>>>FIN FILTRACION DEL ARCHIVO

*>>>>INICIALIZACION DE LA ESTADISTICA
       AADD(aStdMat,{'',''})  // 1. C¢digo del Grupo
       AADD(aStdMat,{'',0})   // 2. N£mero de Estudiantes
       AADD(aStdMat,{'',0})   // 3. N£mero del Periodo
       AADD(aStdMat,{'',''})  // 4. C¢digo de la Materia
       AADD(aStdMat,{'',''})  // 5. C¢digo del Profesor
       AADD(aStdMat,{'',0})   // 6. Total de Indicadors aplicados
       AADD(aStdMat,{'',0})   // 7. Indicadores aprobados
       AADD(aStdMat,{'',0})   // 8. Indicadores No Aprobados
       AADD(aStdMat,{'',0})   // 9. Total Jvf Aprobados
       AADD(aStdMat,{'',0})   // 10.Total Jvf No Aprobados

       SELECT JVF
       JVF->(DBGOTOP())
       DO WHILE .NOT. JVF->(EOF())

	  AADD(aStdMat,{JVF->cCodigoJvf,0})  // Jvf Final
	  JVF->(DBSKIP())

       ENDDO
       AADD(aStdMat,{'SN',0})     // Sin Notas
       AADD(aStdMat,{'?',0})      // Otra Nota
*>>>>FIN INICIALIZACION DE LA ESTADISTICA

*>>>>INICIALIZACION DE LA ESTADISTICA
       aStdMat[1,1] := 'GRUPO'
       aStdMat[1,2] := STD->cCodigoGru

       aStdMat[2,1] := 'EST'
       aStdMat[2,2] := STD->nTotEstStd

       aStdMat[3,1] := 'PE'
       aStdMat[3,2] := nNroPer

       aStdMat[4,1] := 'MATERIA'
       aStdMat[4,2] := STD->cCodigoMat

       aStdMat[5,1] := 'PROFESOR'
       aStdMat[5,2] := STD->cCodigoPro

       aStdMat[6,1] := STD->cNotDefStd
       aStdMat[6,2] := STD->nTotIndStd

       aStdMat[7,1] := 'IND SI'
       aStdMat[7,2] := STD->nIndiSiStd

       aStdMat[8,1] := 'IND NO'
       aStdMat[8,2] := STD->nIndiNoStd

       aStdMat[9,1] := 'JVF SI'
       aStdMat[9,2] := 0

       aStdMat[10,1] := 'JVF NO'
       aStdMat[10,2] := 0
*>>>>FIN INICIALIZACION DE LA ESTADISTICA

*>>>>RECORRIDO POR MATERIA
       SELECT STD
       STD->(DBGOTOP())
       DO WHILE .NOT. STD->(EOF())

**********TOTAL JVF
	    k := ASCAN(aStdMat,{|aTot|aTot[1] == ALLTRIM(STD->cNotDefStd)})
	    IF k # 0
	       aStdMat[k,2] += STD->nTotNotStd
	    ENDIF
**********FIN TOTAL JVF

**********TOTAL JVF APROBATORIOS
	    IF lLocCodigo('cCodigoJvf','JVF',ALLTRIM(STD->cNotDefStd))
	       IF JVF->lAproboJvf
		  nJuiSAp += STD->nTotNotStd
	       ELSE
		  nJuiNAp += STD->nTotNotStd
	       ENDIF
	    ENDIF
**********FIN TOTAL JVF APROBATORIOS

	  STD->(DBSKIP())

       ENDDO
       aStdMat[9,1] := 'JVF SI'
       aStdMat[9,2] := nJuiSAp

       aStdMat[10,1] := 'JVF NO'
       aStdMat[10,2] := nJuiNAp

       SELECT STD
       SET FILTER TO
       RETURN aStdMat
*>>>>FIN RECORRIDO POR MATERIA

/*************************************************************************
* TITULO..: SUMA DE LAS ESTADISTICAS POR MATERIA                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 09/2007 MAR A
       Colombia, Bucaramanga        INICIO: 11:30 AM   ABR 09/2007 MAR

OBJETIVOS:

1- Suma las estadisticas de la asignatura.

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aSumStdMat(aStdMat,aSumStd)

*>>>>DESCRIPCION DE PARAMETROS
/*     aStdMat                              // Estadistica de la materia
       aSumStd                              // Suma de las Estadisticas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL i := 0                         // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>INICIALIAZION DE LAS ESTADISTICAS
       IF EMPTY(aSumStd)

	  aSumStd := ACLONE(aStdMat)
	  FOR i := 1 TO LEN(aSumStd)
	      IF VALTYPE(aSumStd[i,2]) == 'N'
		 aSumStd[i,2] := 0
	      ELSE
		 aSumStd[i,2] := ''
	      ENDIF
	  ENDFOR

       ENDIF
*>>>>FIN INICIALIAZION DE LAS ESTADISTICAS

*>>>>SUMA DE LAS ESTADISTICAS
       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'GRUPO'})
       IF i # 0
	  aSumStd[i,2] := aStdMat[i,2]
       ENDIF

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'PE'})
       IF i # 0
	  aSumStd[i,2] := aStdMat[i,2]
       ENDIF

       SELECT JVF
       JVF->(DBGOTOP())
       DO WHILE .NOT. JVF->(EOF())

	  i := ASCAN(aStdMat,;
		    {|aArray|aArray[1] == ALLTRIM(JVF->cCodigoJvf)})
	  IF i # 0
	     aSumStd[i,2] += aStdMat[i,2]
	  ENDIF

	  JVF->(DBSKIP())

       ENDDO

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'SN'})
       IF i # 0
	  aSumStd[i,2] += aStdMat[i,2]
       ENDIF
     *ÀSin Notas

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'JVF SI'})
       IF i # 0
	  aSumStd[i,2] += aStdMat[i,2]
       ENDIF

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'JVF NO'})
       IF i # 0
	  aSumStd[i,2] += aStdMat[i,2]
       ENDIF

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'IND SI'})
       IF i # 0
	  aSumStd[i,2] += aStdMat[i,2]
       ENDIF

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'IND NO'})
       IF i # 0
	  aSumStd[i,2] += aStdMat[i,2]
       ENDIF

       i := ASCAN(aStdMat,{|aArray|aArray[1] == 'EST'})
       IF i # 0
	  aSumStd[i,2] += aStdMat[i,2]
       ENDIF
       RETURN aSumStd
*>>>>FIN SUMA DE LAS ESTADISTICAS

/*************************************************************************
* TITULO..: TOTAL DE JUICIOS VALORATIVOS MATERIAS VARIABLES              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 26/2007 JUE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ABR 26/2007 JUE

OBJETIVOS:

1- Totaliza el juicio valorativo de las materias variables

2- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION TotMatVar(lShared,cNomSis,cAnoUsr,cPatSis,;
		   cMaeAct,nNroPer,cCodGru,aCodMat,aStdMat)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema
       cAnoUsr				    // A¤o del Sistema
       cPatSis                              // Path del sistema
       cMaeAct                              // Maestro Actual
       nNroPer                              // N£mero del Periodo
       cCodGru                              // C¢digo del Grupo
       aCodMat                              // C¢digo de Materias
       aStdMat                              // @Estadistica de la Materia */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema

       LOCAL i,j,k,y,x := 0                 // Contadores
       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias
       LOCAL aStdJui := {}                  // Estadisticas de Juicios Valorativos
       LOCAL cNotDef := ''                  // Nota Definitiva
       LOCAL cNotRec := ''                  // Nota de Recuperaci¢n
       LOCAL lEvaInd := .F.                 // .T. Evaluar el indicador
       LOCAL cValNot := ''                  // Validaci¢n de la nota
       LOCAL cJuicio := ''                  // Juicios para el periodo
       LOCAL aJuicio := {}                  // Juicios para el periodo
       LOCAL cSiRecu := ''                  // Logros SI Recuperados
       LOCAL cNoRecu := ''                  // Logros NO Recuperados
       LOCAL nNroDif := ''                  // N£mero de Dificultades
       LOCAL cCamInd := ''                  // Campo de Indicadores de la Materia
       LOCAL nTotEst := 0                   // Total de Estudiantes
       LOCAL lNotNum := .F.                 // .T. Nota Numerica .F. Nota Cualitativa
       LOCAL lHayItv := .F.                 // .T. Nota Numerica por Intervalo de Juicios valorativos

       LOCAL PathNot := ''                  // Path de Notas
       LOCAL aStrNot := {}                  // Vector con la estructura
     *ÀVariables Espec¡ficas

       LOCAL cCodigoTma := ''               // C¢digo de la Materia
       LOCAL cCodigoTpr := ''               // C¢digo del Profesor
       LOCAL cCamNotDef := ''               // Campo de Notas Definitivas
       LOCAL cCamNotRec := ''               // Campo de Notas de Recuperaci¢n
       LOCAL cNombreTes := ''               // Nombre del Estudiante
     *ÀVariables de Campo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR SUBGRUPOS
       aCodMat := {}

       aStdJui := {}
       AADD(aStdJui,'')   // C¢digo del Jvf
       AADD(aStdJui,'')   // Nombre del Jvf

       SUG->(DBGOTOP())
       DO WHILE .NOT. SUG->(EOF())

**********ANALISIS DE LA MATERIA NO IMPRIMIR
	    lMatVarMat(SUG->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
	    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
	       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'

	       SUG->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE LA MATERIA NO IMPRIMIR

**********INICIALIZACION DE LA MATERIA
	    IF SUG->cCodigoGru == cCodGru

	       cCodigoTpr := SUG->cCodigoPro
	       AADD(aStdJui,0)  // Total Jvf
	       AADD(aCodMat,{SUG->cCodigoMat,0,0,0,cCodigoTpr})

	    ENDIF
**********FIN INICIALIZACION DE LA MATERIA

	 SUG->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR SUBGRUPOS

*>>>>RECORRIDO POR SUBNIVELES
       SUN->(DBGOTOP())
       DO WHILE .NOT. SUN->(EOF())

**********ANALISIS DE LA MATERIA NO IMPRIMIR
	    lMatVarMat(SUN->cCodigoMat,.F.)
	    cCodigoTma := MAT->cCodigoMat
	    IF lLocCodigo('cCodigoMat','PLA',cCodigoTma) .AND.;
	       SUBS(PLA->cPrnBolPla,nNroPer,1) == '1'

	       SUN->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN ANALISIS DE LA MATERIA NO IMPRIMIR

**********INICIALIZACION DE LA MATERIA
	    IF SUN->cCodigoNiv == SUBS(cCodGru,1,2)

	       IF SUN->lPorNivSuN
		  cCodigoTpr := SUN->cCodigoPro
	       ELSE
		  cCodigoTpr := MAT->cCodigoPro
	       ENDIF
	       AADD(aStdJui,0)
	       AADD(aCodMat,{SUN->cCodigoMat,0,0,0,cCodigoTpr})

	    ENDIF
**********FIN INICIALIZACION DE LA MATERIA

	 SUN->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR SUBNIVELES

*>>>>LECTURA DE LOS JUICIOS VALORATIVOS
       aStdMat := {}

       SELECT JVF
       JVF->(DBGOTOP())
       DO WHILE .NOT. JVF->(EOF())
	  aStdJui[1] := JVF->cCodigoJvf
	  aStdJui[2] := JVF->cNombreJvf
	  AADD(aStdMat,ACLONE(aStdJui))
	  JVF->(DBSKIP())
       ENDDO
       aStdJui[1] := 'SN'
       aStdJui[2] := 'SIN JUICIO'
       aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
       AADD(aStdMat,ACLONE(aStdJui))

       aStdJui[1] := '?'
       aStdJui[2] := 'OTRO'
       aStdJui[2] := SUBS(aStdJui[2]+SPACE(14),1,14)
       AADD(aStdMat,ACLONE(aStdJui))
*>>>>FIN LECTURA DE LOS JUICIOS VALORATIVOS


*>>>>LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD
       lEvaInd := IF(SUBS(TCO->cEvaIndTbl,nNroPer,1)='0',.F.,.T.)
       lNotNum := IF(SUBS(TCO->cNotNumTbl,nNroPer,1)='1',.T.,.F.)
       lHayItv := lHayItvJvf()
*>>>>FIN LECTURA DE LA CONFIGURACION DEL NIVEL DE LA CONTABILIDAD

*>>>>RECORRIDO POR MATERIAS VARIABLES
       FOR i := 1 TO LEN(aCodMat)

	   cCodigoTma := aCodMat[i,1]
	   cCodigoTpr := aCodMat[i,5]

***********FILTRACION DEL ARCHIVO
	     SELECT SEL
	     SET FILTER TO SEL->cCodigoPro == cCodigoTpr .AND.;
			   SEL->cCodAreSel == SUBS(cCodigoTma,1,2) .AND.;
			   SUBS(SEL->cSecMatSel,nNroPer*2-1,2) == SUBS(cCodigoTma,3,2)

	     SEL->(DBGOTOP())
	     IF SEL->(EOF())
		SET FILTER TO
		RETURN NIL
	     ENDIF
***********FIN FILTRACION DEL ARCHIVO

***********RECORRIDO POR ESTUDIANTES SELECTIVOS
	     SEL->(DBGOTOP())
	     DO WHILE .NOT. SEL->(EOF())

*===============BUSQUEDA DEL ESTUDIANTE
		  IF lSekCodigo(SEL->cCodigoEst,cMaeAct) .AND.;
		     &cMaeAct->cCodigoGru # cCodGru

		     SEL->(DBSKIP())
		     LOOP

		  ENDIF
*===============FIN BUSQUEDA DEL ESTUDIANTE

*===============IMPRESION DE LA LINEA DE ESTADO
		  LineaEstado('ºPERIODO: '+STR(nNroPer,2)+'º'+;
			      'ºCODIGO: '+&cMaeAct->cCodigoEst+;
			      'ºGRUPO: '+&cMaeAct->cCodigoGru+;
			      'ºMATERIA: '+cCodigoTma+;
			      'º No. '+ALLTRIM(STR(i,4))+'/'+;
				       ALLTRIM(STR(LEN(aCodMat),4)),cNomSis)
*===============FIN IMPRESION DE LA LINEA DE ESTADO

*==============INICIALIZACION DEL PATH DE NOTAS
		 PathNot := cPatSis+'\'+cMaeAct+'\NOTAS\'
		 FileNot := 'NT'+cCodGru+cAnoSis+ExtFile
*==============FIN INICIALIZACION DEL PATH DE NOTAS

*==============SELECION DE LAS AREAS DE TRABAJO
		 IF !lUseDbf(.T.,PathNot+'\'+FileNot,'NOT',NIL,lShared)
		    cError('ABRIENDO EL ARCHIVO DE NOTAS DE '+cCodGru)
		    SEL->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN SELECION DE LAS AREAS DE TRABAJO

*==============LOCALIZACION DEL ESTUDIANTE
		 IF !lLocCodigo('cCodigoEst','NOT',&cMaeAct->cCodigoEst,.T.)
		    SEL->(DBSKIP())
		    LOOP
		 ENDIF
*==============FIN LOCALIZACION DEL ESTUDIANTE

*==============DETALLES DE LAS AREAS Y MATERIAS
		 aNotAre := {}
		 aNotMat := {}
		 DetAreas(@aNotAre,@aNotMat,nNroPer)
*==============FIN DETALLES DE LAS AREAS Y MATERIAS

*==============LOCALIZACION DE LA MATERIA VARIABLE
		 lMatVarMat(cCodigoTma,.F.)
		 FOR j := 1 TO LEN(aNotMat)
		     IF SUBS(aNotMat[j,4],9,4) == MAT->cCodigoMat
			EXIT
		     ENDIF
		 ENDFOR
*==============FIN LOCALIZACION DE LA MATERIA VARIABLE

*==============NOTAS DE LA MATERIA
		 cCamNotDef := aNotMat[j,4]
		    cNotDef := SUBS(&cCamNotDef,nNroPer*4-3,4)
		    cNotDef := cNotDef(cNotDef,lNotNum)
		*ÀNota del Periodo

		 IF TCO->nTotPerTbl == nNroPer .AND.;
		    SUBS(cCodigoTma,3,2) # '00'

		    cCamNotRec := 'NOT->cHa'+SUBS(cCamNotDef,9,4)+'Not'
		       cNotRec := SUBS(&cCamNotRec,1,4)

		 ELSE
		    cCamNotRec := STUFF(cCamNotDef,13,3,'Rec')
		       cNotRec := SUBS(&cCamNotRec,nNroPer*4-3,4)
		 ENDIF
	       *ÀNota de Recuperaci¢n del Periodo
*==============FIN NOTAS DE LA MATERIA

*==============INDICADORES DE LA MATERIA
		 nNroDif := 0
		 cCamInd := aNotMat[j,5]

		 cCamInd := STUFF(cCamInd,8,1,STR(nNroPer,1))
		 cJuicio := ALLTRIM(&cCamInd)+SPACE(02)
	       *ÀIndicadores del Periodo

		 cSiRecu := ''
		 cNoRecu := ''
		 IF !aNotMat[j,15]  // No Recuperable
		    IndRecSiNo(cJuicio,lEvaInd,;
			       @cSiRecu,@cNoRecu,.F.)
		 ENDIF
	       *ÀIndicadores recuperados y por recuperar
*==============FIN INDICADORES DE LA MATERIA

*==============TOTALIZACION DEL JUICIO VALORATIVO
		 IF !EMPTY(cNotRec)
		    cNotDef := cNotRec
		 ENDIF
		 IF EMPTY(cNotDef)
		    cNotDef := 'SN'
		 ENDIF
		 k := ASCAN(aStdMat,{|aStd|aStd[1] == ALLTRIM(cNotDef)})
		 IF k # 0
		    aStdMat[k,i+2]++
		 ELSE
		    aStdMat[LEN(aStdMat),i+2]++
		 ENDIF
*==============FIN TOTALIZACION DEL JUICIO VALORATIVO

*==============TOTAL DE INDICADORES
		 aCodMat[i,2] += LEN(aJuicio(@cJuicio,;
					     TCO->lNoSortTbl))
	       *ÀTotal de Indicadores

		 aCodMat[i,3] += LEN(aJuicio(@cNoRecu,;
					     TCO->lNoSortTbl))
	       *ÀIndicadores no aprobados

		 aCodMat[i,4]++
	       *ÀTotal de Estudiantes
*==============FIN TOTAL DE INDICADORES

	       SEL->(DBSKIP())

	     ENDDO
***********FIN RECORRIDO POR ESTUDIANTES SELECTIVOS

       ENDFOR
       RETURN NIL
*>>>>FIN RECORRIDO POR MATERIAS VARIABLES


