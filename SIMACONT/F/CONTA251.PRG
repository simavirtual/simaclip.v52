/*SISTEMA DE CONTABILIDAD ACADEMICA

MODULO      : PERIODOS
SUBMODULO...: CALCULOS - POR GRUPOS

**************************************************************************
* TITULO..: CALCULOS                                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: SEP 18/2008 JUE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   SEP 18/2008 JUE

OBJETIVOS:

1- Calcula las notas de las  reas, acumulados de acuerdo a los porcentajes
   especificados y determina los puestos de los estudiantes.

2- El c lculo por grupos puede afectar los c lculos relacionados con los
   dem s estudiantes que NO requieren recalculo y si pueden cambiar la nota
   actual Tener presente esta situaci¢n para resolverla

3- Retorna NiL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Conta_251(aP1,aP2,aP3)

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
       #INCLUDE "ARC-CONT.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL aHayErr := {}                  // Hay Errores
       LOCAL aTotErr := {}                  // Hay Errores

       LOCAL       i := 0                   // Contador
       LOCAL nNroPer := 0                   // N£mero del periodo

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL aNotAre := {}                  // Detalles de las areas
       LOCAL aNotMat := {}                  // Detalles de las materias

       LOCAL lNotFin := .F.                 // .T. Calcular la nota de fin de a¤o.

       LOCAL cJvfCal := ''                  // Juicio Valorativo Calculado

       LOCAL cHorIni := ''                  // Hora Inicial
       LOCAL cMenTxt := ''                  // Texto variable
       LOCAL aGenLog := {}                  // Campos Generales
       LOCAL aCamLog := {}                  // Campos del Log
       LOCAL cTxtLog := ''                  // Texto del Log
       LOCAL cAliasL := 'LOP'		    // Alias del Log
       LOCAL lGraLog := .T.                 // .T. Grabar el Log
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DEL NUMERO DEL BIMESTRE
       nNroPer := nLeeNroBis(nFilInf+1,nColInf,nFilPal)
       IF nNroPer == 0
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS PARA LA SALIDA DEL PROGRAMA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimaCo,'SCO',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileInf,'INF',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FileIso,'ISO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FConTbl+cMaeAct+ExtFile,'TCO',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,;
			 cPatSis+'\'+cMaeAct+'\'+;
			 fNtxAlu+cMaeAct+cAnoSis+cExtNtx,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileNiv+cAnoSis+ExtFile,'NIV',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileCla,'CLA',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileJvf,'JVF',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileMat+ExtFile,'MAT',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
			 FileSin+cMaeAct+cAnoSis+ExtFile,'SIN',NIL,lShared,nModCry})
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
	    cError('NO EXISTEN ALUMNOS GRABADOS')

       CASE SCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       CASE TCO->(RECCOUNT()) == 0
	    cError('NO EXISTEN CONFIGURACION PARA EL NIVEL DE '+cMaeAct)

       CASE TCO->nTotPerTbl == 0
	    cError('NO SE HAN DEFINIDO EL TOTAL DE PERIODOS'+cMaeAct)

/*
       CASE TCO->nMetodoTbl == 0  .AND.;
	    nNroPer >= TCO->nTotPerTbl .AND.;
	    SUBS(TCO->cJvfCalTbl,TCO->nTotPerTbl*3-2,3) == SPACE(03)

	    cError('EL NUMERO DEL PERIODO DEBE SER MENOR AL TOTAL DE PERIODOS')
*/

       CASE TCO->nMetodoTbl == 1 .AND. nNroPer # TCO->nTotPerTbl

	    cError('DEBE DIGITAR EL ULTIMO PERIODO:'+;
		   STR(TCO->nTotPerTbl,2,0))

       CASE TCO->nMetodoTbl == 1 .AND. LEN(aFactorJvf()) == 0

	    cError('SE DEBE DEFINIR BIEN EL VALOR NUMERICO '+;
		   'DE LOS JUICIOS VALORATIVOS')

       CASE TCO->nMetodoTbl == 1 .AND. !lHayItvJvf()

	    cError('SE DEBE DEFINIR BIEN EL INTERVALO DE LOS JUICIOS VALORATIVOS')

       CASE NIV->(RECCOUNT()) == 0
	    cError('NO EXISTEN NIVELES GRABADOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       CASE CLA->(RECCOUNT()) == 0
	    cError('NO EXISTEN CLASE DE INDICADORES GRABADAS')

       CASE MAT->(RECCOUNT()) == 0
	    cError('NO EXISTEN MATERIAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CREACION DEL LOG DEL SISTEMA
       FileLog := cFileTempo(cPatSis+'\'+PathLog+'\',;
			     'LOC'+STR(nNroPer,1,0),ExtFile,.F.)
       CreaConLog(lShared,nModCry,cPatSis+'\'+PathLog,FileLog)

       IF !lUseDbf(.T.,cPatSis+'\'+PathLog+'\'+FileLog,cAliasL,NIL,lShared)
	  cError('ABRIENDO ARCHIVO DEL LOG')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL LOG DEL SISTEMA

*>>>>VALIDACION DEL CALCULO DE LA NOTA DE FIN DE A¥O
       DO CASE
       CASE TCO->nMetodoTbl == 0

	    lNotFin := .F.
	    IF nNroPer+1 == TCO->nTotPerTbl .AND.;
	       SUBS(TCO->cJvfCalTbl,TCO->nTotPerTbl*3-2,3) == SPACE(03)

	       IF SUBS(TCO->cHayNotTbl,TCO->nTotPerTbl,1) == '0'
		  lNotFin := .T.
	       ENDIF

	       cError('La nota para el '+;
		      ALLTRIM(STR(TCO->nTotPerTbl,2))+' '+;
		      'per¡odo '+IF(lNotFin,'SI','NO')+' se calcula')

	       IF !lPregunta('DESEA CONTINUAR? No Si')
		  CloseAll()
		  RETURN NIL
	       ENDIF

	    ENDIF

       ENDCASE
*>>>>FIN VALIDACION DEL CALCULO DE LA NOTA DE FIN DE A¥O

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>REGISTRO DEL LOG
       cHorIni := TIME()
       cTxtLog := 'Inicio de la Lectura. Inicio a las: '+cHorIni
       AADD(aCamLog,{'cObservLog',cTxtLog})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
*>>>>FIN REGISTRO DEL LOG

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GRU->(DBGOTO(nRegIni))
       DO WHILE GRU->(RECNO()) <= nRegFin

***********SELECION DE LAS AREAS DE TRABAJO
	     IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+;
			    'PLAN'+SUBS(GRU->cCodigoGru,1,2)+cAnoSis+ExtFile,;
			    'PLA',NIL,lShared)

		cError('NO EXISTE PLAN ACADEMICO PARA EL NIVEL DE '+;
			cNomNiv(SUBS(GRU->cCodigoGru,1,2)))

		CloseAll()
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     IF PLA->(RECCOUNT()) == 0
		cError('NO EXISTEN PLAN ACADEMICO PARA GRUPO'+GRU->cCodigoGru)
		CloseDbf('PLA')
		GRU->(DBSKIP())
		LOOP
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\'+'NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru)
	      CloseAll()
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

***********DETALLES DEL AREA
	     aNotAre := {}
	     aNotMat := {}
	     DetAreas(@aNotAre,@aNotMat,nNroPer)
***********FIN DETALLES DEL AREA

**********CALCULO DE LAS NOTAS DE LOS GRUPOS
	    cJvfCal := SUBS(GRU->cJvfCalGru,nNroPer*3-2,3)

	    DO CASE
	    CASE cJvfCal == '102'  // Indice de Cumplimiento

*================INDICE DE CUMPLIMIENTO
		   CalNot102(aP1,aP2,aP3,;
			     nNroPer,TCO->nTotPerTbl,;
			     aNotAre,aNotMat,@aTotErr)
*================FIN INDICE DE CUMPLIMIENTO

*===============REGISTRO DEL LOG
		  FOR i := 1 TO LEN(aTotErr)

		      aHayErr := aTotErr[i]

		      AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		      AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		      AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		      AADD(aCamLog,{'cMatNotLog',xPrm(aHayErr,'cCodMat')})
		      AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
		    *ÀCampos del Log

		      aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		  ENDFOR
*===============FIN REGISTRO DEL LOG

	    CASE cJvfCal == '103'  // Indice de Cumplimiento. Variable

*================INDICE DE CUMPLIMIENTO
		   CalNot103(aP1,aP2,aP3,;
			     nNroPer,TCO->nTotPerTbl,;
			     aNotAre,aNotMat,@aTotErr)
*================FIN INDICE DE CUMPLIMIENTO

*===============REGISTRO DEL LOG
		  FOR i := 1 TO LEN(aTotErr)

		      aHayErr := aTotErr[i]

		      AADD(aCamLog,{'cCodigoEst',xPrm(aHayErr,'cCodEst')})
		      AADD(aCamLog,{'cCodigoGru',xPrm(aHayErr,'cCodGru')})
		      AADD(aCamLog,{'nNroRegEst',VAL(xPrm(aHayErr,'cNroLis'))})
		      AADD(aCamLog,{'cMatNotLog',xPrm(aHayErr,'cCodMat')})
		      AADD(aCamLog,{'cObservLog',xPrm(aHayErr,'cHayErr')})
		    *ÀCampos del Log

		      aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)
		  ENDFOR
*===============FIN REGISTRO DEL LOG

	    CASE cJvfCal == '301'  // Virrey Solis

*================INDICADORES PROMOCIONALES
		   CalNot301(aP1,aP2,aP3,;
			     nNroPer,TCO->nTotPerTbl,;
			     aNotAre,aNotMat,@aTotErr)
*================FIN INDICADORES PROMOCIONALES

	    CASE TCO->nMetodoTbl == 0  // Juicios Valorativos

*================CALCULO NUMERICO DE LAS AREAS
		   CalNot000(aP1,aP2,aP3,;
			     nNroPer,TCO->nTotPerTbl,;
			     aNotAre,aNotMat,lNotFin,;
			     @aTotErr)
*================FIN CALCULO NUMERICO DE LAS AREAS

	    CASE TCO->nMetodoTbl == 1  // Juicio valorativo calculodo. Factor N£merico

*================JUICIO VALORATIVO CALCULADO. FACTOR NUMERICO
		   CalNot001(aP1,aP2,aP3,;
			     nNroPer,TCO->nTotPerTbl,;
			     aNotAre,aNotMat,TCO->lRecNotTbl,@aTotErr)
*================FIN JUICIO VALORATIVO CALCULADO. FACTOR NUMERICO

	    CASE TCO->nMetodoTbl == 99  // Colsalle

*================CALCULO NUMERICO DE LAS AREAS
		   CalNot099(aP1,aP2,aP3,;
			     nNroPer,TCO->nTotPerTbl,;
			     aNotAre,aNotMat,@aTotErr)
*================FIN CALCULO NUMERICO DE LAS AREAS


	    ENDCASE
**********FIN CALCULO DE LAS NOTAS DE LOS GRUPOS

	  GRU->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>REGISTRO DEL LOG
       cTxtLog := 'Fin '+;
		  'Inicio a las: '+cHorIni+' y termino a las: '+TIME()
       AADD(aCamLog,{'cObservLog',cTxtLog})
       aCamLog := aGrabarLog(lShared,cAliasL,aCamLog,aGenLog)

       SELECT &cAliasL
       BROWSE()

       CloseAll()
       RETURN NIL
*>>>>REGISTRO DEL LOG

